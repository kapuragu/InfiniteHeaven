--InfBossTppBossQuiet2.lua
--Boss type for InfBossEvent
--For TppBossQuiet2 gameObject

--subType (my name), various ways game refers to them)
--CAMO, wmu1, ParasiteCmouf, PARASITE_CAMOFLA, Cam
--s10130

--QUIET
--s10050
--TODO: build pack
--\Assets\tpp\pack\mission2\story\s10050\s10050_area.fpk
--  \Assets\tpp\level_asset\chara\enemy\boss_quiet2.fox2
--or, which might be more contained (or might be incomplete)
--\Assets\tpp\pack\mission2\quest\battle\bossQuiet\qest_bossQuiet_00.fpk
--  \Assets\tpp\level\mission2\quest\battle\bossQuiet\qest_bossQuiet_00.fox2

local InfCore=InfCore
local InfMain=InfMain
local GetGameObjectId=GameObject.GetGameObjectId
local GetTypeIndex=GameObject.GetTypeIndex
local NULL_ID=GameObject.NULL_ID
local SendCommand=GameObject.SendCommand
local TimerStart=GkEventTimerManager.Start
local TimerStop=GkEventTimerManager.Stop
local IsTimerActive=GkEventTimerManager.IsTimerActive
local GAME_OBJECT_TYPE_PARASITE2=TppGameObject.GAME_OBJECT_TYPE_PARASITE2
local GAME_OBJECT_TYPE_BOSSQUIET2=TppGameObject.GAME_OBJECT_TYPE_BOSSQUIET2
local GAME_OBJECT_TYPE_HOSTAGE2=TppGameObject.GAME_OBJECT_TYPE_HOSTAGE2
local GAME_OBJECT_TYPE_PLAYER2=TppGameObject.GAME_OBJECT_TYPE_PLAYER2

local this={}
this.name="InfBossTppBossQuiet2"

this.disableFight=false--DEBUG
--tex since I'm repurposing routes buit for normal cps the camo parasites just seem to shift along a short route, or get stuck leaving and returning to same spot.
--semi workable solution is to just set new routes after the parasite has been damaged a few times.
local camoShiftRouteAttackCount=3

--tex indexed by parasiteNames
this.hitCounts={}

this.gameObjectType="TppBossQuiet2"
this.gameObjectTypeIndex=TppGameObject.GAME_OBJECT_TYPE_BOSSQUIET2
this.bossStatesName="bossEvent_"..this.gameObjectType.."State"
local bossStatesName=this.bossStatesName
this.blockName=this.gameObjectType.."_block"
this.blockNameS32=InfCore.StrCode32(this.blockName)

--SetBossSubType
this.currentSubType=nil--tex while there is IsEnabled, this is a more accurate check whether this is chosen/active for an event (InfBossEvent.ChooseBossTypes)
this.currentBossNames=nil
this.currentParams=nil

this.gameIdToNameIndex={}--InitEvent

this.subTypes={
  CAMO=true,
}

this.enableBossIvarName=nil
this.enableSubTypeIvarNames={}

this.packages={
  --missionPack
  scriptBlockData="/Assets/tpp/pack/mission2/boss/ih/"..this.gameObjectType.."_scriptblockdata.fpk",
  --scriptBlockPacks
  CAMO={"/Assets/tpp/pack/mission2/ih/ih_parasite_camo.fpk",}
}--packages

--tex locatorNames from packs
this.bossObjectNames={
  CAMO={
    "wmu_camo_ih_0000",
    "wmu_camo_ih_0001",
    "wmu_camo_ih_0002",
    "wmu_camo_ih_0003",
  },
}--bossObjectNames

this.eventParams={
  CAMO={
  --tex since camos start moving to route when activated, and closest cp may not be that discoverable
  --or their positions even that good, spawn at player pos in a close enough radius that they spot player
  --they'll then be aiming at player when they reach the cp
  --TODO: alternatively try triggering StartCombat on camo spawn
    spawnRadius=10,--ivar
    escapeDistance=100,--ivar
    timeOut=1*60,--ivar
    zombifies=true,--TODO: set false and test the boss objects zombifying ability
    fultonable=true,
  },
}--eventParams

this.combatGrade={--SetCombatGrade
  CAMO={
    defenseValue=4000,
    offenseGrade=2,
    defenseGrade=7,
  },
}

this.routeBag=nil--Appear

this.stateTypes={
  READY=0,
  DOWNED=1,
  FULTONED=2,
}

function this.DeclareSVars()
  if not InfBossEvent.BossEventEnabled() then
    return{}
  end

  if not this.IsEnabled() then
    return{}
  end

  --DEBUGNOW only if boss type enabled

  local saveVarsList = {
    --GOTCHA: svar arrays are from 0, but I'm +1 so I can index it lua style +1 since the rest of InfBoss uses that as bossNames 'nameIndex'
    [this.bossStatesName]={name=this.bossStatesName,type=TppScriptVars.TYPE_INT8,arraySize=InfBossEvent.MAX_BOSSES_PER_TYPE+1,value=this.stateTypes.READY,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},
    --tex engine sets svars.parasiteSquadMarkerFlag when camo parasite marked, will crash if svar not defined (what kind of crash)
    --during rework testing, there seems to be a hang when one dies, not sure if that's what it was I was originally commenting about above
    --DEBUGNOW only if camo enabled? TEST
    parasiteSquadMarkerFlag={name="parasiteSquadMarkerFlag",type=TppScriptVars.TYPE_BOOL,arraySize=InfBossEvent.MAX_BOSSES_PER_TYPE,value=false,save=true,sync=true,wait=true,category=TppScriptVars.CATEGORY_RETRY},
  }
  return TppSequence.MakeSVarsTable(saveVarsList)
end--DeclareSVars

function this.Messages()
  return Tpp.StrCode32Table{
    Block={
      {msg="OnScriptBlockStateTransition",func=this.OnScriptBlockStateTransition},
    },
    GameObject={
      {msg="Damage",func=this.OnDamage},
      {msg="Dying",func=this.OnDying},
      --tex TODO: "FultonInfo" instead of fulton and fultonfailed
      {msg="Fulton",--tex fulton success i think
        func=function(gameId,gimmickInstance,gimmickDataSet,stafforResourceId)
          this.OnFulton(gameId)
        end
      },
      {msg="FultonFailed",
        func=function(gameId,locatorName,locatorNameUpper,failureType)
          if failureType==TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
            this.OnFulton(gameId)
          end
        end
      },
    },--GameObject
    Player={
      {msg="PlayerDamaged",func=this.OnPlayerDamaged},
    },--Player
  }
end--Messages

function this.PostModuleReload(prevModule)
  this.routeBag=prevModule.routeBag
end

function this.Init(missionTable)
  this.messageExecTable=nil

  if not InfBossEvent.BossEventEnabled() then
    return
  end

  if not this.IsEnabled() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnReload(missionTable)
  this.messageExecTable=nil

  if not InfBossEvent.BossEventEnabled() then
    return
  end

  if not this.IsEnabled() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

--InfBossEvent.AddMissionPacks
function this.AddPacks(missionCode,packPaths)
  if not this.IsEnabled() then
    return packPaths
  end

  packPaths[#packPaths+1]=this.packages.scriptBlockData
end--AddPacks

function this.IsEnabled()
  return Ivars[this.enableBossIvarName]:Is(1)
end--IsEnabled

function this.GetEnabledSubTypes(missionCode)
  --tex TODO: forMission?
  --TODO: addon opt in or out?

  local enabledSubTypes=IvarProc.GetIvarKeyNameValues(this.enableSubTypeIvarNames)

  --tex WORKAROUND quiet battle, will crash with CAMO (which also use TppBossQuiet2)
  if TppPackList.GetLocationNameFormMissionCode(missionCode)=="AFGH" and TppQuest.IsActive"waterway_q99010" then
    InfCore.Log("InfBossEvent.ChooseBossTypes - IsActive'waterway_q99010', disabling CAMO")--DEBUGNOW TODO triggering when I wouldnt have expected it to
    enabledSubTypes.CAMO=false
  end
  --tex WORKAROUND zoo currently has no routes for sniper
  if missionCode==30150 then
    enabledSubTypes.CAMO=false
  end

  return enabledSubTypes
end--GetEnabledSubTypes

--InfBossEvent
function this.SetBossSubType(bossSubType,numBosses)
  if not this.subTypes[bossSubType] then
    InfCore.Log("ERROR: "..this.name..".SetBossSubType: has no subType "..tostring(bossSubType))
    return
  end
  InfCore.Log(this.name..".SetBossSubType: "..bossSubType.." numBosses:"..numBosses)
  this.currentSubType=bossSubType
  this.currentBossNames=this.bossObjectNames[bossSubType]
  this.numBosses=numBosses
  --TODO shift BuildGameIdToNameIndex here if you move ChosseBossTypes/SetBossSubType from pre load
  this.currentParams=this.eventParams[bossSubType]
end--SetBossSubType

function this.ClearBossSubType()
  this.currentSubType=nil


end

--blockState: ScriptBlock.TRANSITION_* enums
--note: ScriptBlock.SCRIPT_BLOCK_STATE_* is for ScriptBlock.GetScriptBlockState
function this.OnScriptBlockStateTransition(blockNameS32,blockState)
  if blockNameS32~=this.blockNameS32 then
    return
  end
  if blockState==ScriptBlock.TRANSITION_DEACTIVATED then
    
  elseif blockState==ScriptBlock.TRANSITION_ACTIVATED then
    this.InitBoss()
  end
end--OnScriptBlockStateTransition

--InfBossEvent
--OUT: this.gameIdToNameIndex
function this.InitBoss()
  if this.currentSubType==nil then
    return
  end
  InfCore.Log(this.name..".InitBoss")

  InfUtil.ClearTable(this.gameIdToNameIndex)
  InfBossEvent.BuildGameIdToNameIndex(this.currentBossNames,this.gameIdToNameIndex)

  this.DisableAll()
  this.SetupParasites()

  for nameIndex,name in ipairs(this.currentBossNames)do
    this.hitCounts[nameIndex]=0
  end--for gameObjectNames
end--InitBoss

function this.EndEvent()
  if this.currentSubType==nil then
    return
  end

  for index=1,#this.currentBossNames do
    svars[bossStatesName][index]=this.stateTypes.READY
  end
  
  SendCommand({type="TppBossQuiet2"},{id="SetWithdrawal",enabled=true})--tex uhh, where did I get this from, cant see any references to it
end--EndEvent

function this.DisableAll()
  if this.currentSubType==nil then
    return
  end

  for i,name in ipairs(this.currentBossNames) do
    this.DisableByName(name)
  end  
end--DisableAll

function this.DisableByName(name)
  local gameId=GetGameObjectId("TppBossQuiet2",name)

  if gameId==NULL_ID then
    return
  end

  SendCommand(gameId,{id="SetSightCheck",flag=false})
  SendCommand(gameId,{id="SetNoiseNotice",flag=false})
  SendCommand(gameId,{id="SetInvincible",flag=true})
  SendCommand(gameId,{id="SetStealth",flag=true})
  SendCommand(gameId,{id="SetHumming",flag=false})
  SendCommand(gameId,{id="SetForceUnrealze",flag=true})
end--DisableByName

function this.EnableByName(name)
  local gameObjectId=GetGameObjectId("TppBossQuiet2",name)
  SendCommand(gameObjectId,{id="SetForceUnrealze",flag=false})
  SendCommand(gameObjectId,{id="SetSightCheck",flag=true})
  SendCommand(gameObjectId,{id="SetNoiseNotice",flag=true})
  SendCommand(gameObjectId,{id="SetInvincible",flag=false})
  SendCommand(gameObjectId,{id="SetStealth",flag=false})
  SendCommand(gameObjectId,{id="SetHumming",flag=true})
end--EnableByName

function this.DisableFight(name)
  local gameObjectId=GetGameObjectId("TppBossQuiet2",name)
  SendCommand(gameObjectId,{id="SetSightCheck",flag=false})
  SendCommand(gameObjectId,{id="SetNoiseNotice",flag=false})
end

--InfBossEvent
function this.SetupParasites()
  InfCore.LogFlow("InfBossTppBossQuiet2.Setup")

  SendCommand({type="TppBossQuiet2"},{id="SetFultonEnabled",enabled=true})

  local combatGradeCommand=this.combatGrade[this.currentSubType]
  combatGradeCommand.id="SetCombatGrade"
  SendCommand({type="TppBossQuiet2"},combatGradeCommand)
  if this.debugModule then
    InfCore.PrintInspect(combatGradeCommand,"SetCombatGrade")
  end
end--Setup

local phases={
  "caution",
  "sneak_day",
  "sneak_night",
}
local groups={
  "groupSniper",
  "groupA",
  "groupB",
  "groupC",
}
local groupSniper="groupSniper"

--DEBUGNOW get working for MB
--IN: mvars.ene_routeSetsDefine
function this.GetRoutes(cpName)
  local routeSets=mvars.ene_routeSetsDefine[cpName]
  if not routeSets then
    InfCore.Log"WARNING: InfBossEvent  CamoParasiteAppear - no routesets found, aborting"
    return
  end

  local cpRoutes={}
  --tex TODO prioritze picking sniper group first?
  if routeSets==nil then
    InfCore.Log("WARNING: InfBossEvent CamoParasiteAppear no routesets for "..cpName,true)--DEBUG
    return
  end

  local routeCount=0
  for i,phaseName in ipairs(phases)do
    local phaseRoutes=routeSets[phaseName]
    if phaseRoutes then
      for i,groupName in ipairs(groups)do--tex TODO read groups from routeSet .priority instead
        local group=phaseRoutes[groupName]
        if group then
          --tex some groups have duplicate groups
          for i,route in ipairs(group)do
            if groupName==groupSniper then
              cpRoutes[route[1]]=true
            else
              cpRoutes[route]=true
            end
            routeCount=routeCount+1
          end--for group
        end--if group
      end--for groups
    end--if phaseRoutes
  end--for phases
  return routeCount,cpRoutes
end--GetRoutes

--InfBossEvent
--IN: this.currentSubType
--IN: this.currentBossNames
--IN: this.this.disableFight
--OUT: this.routeBag
function this.Appear(appearPos,closestCp,closestCpPos,spawnRadius)
  --InfCore.Log"CamoParasiteAppear"--DEBUG
  --tex camo parasites rely on having route set, otherwise they'll do a constant grenade drop evade on the same spot
  local routeCount,cpRoutes=this.GetRoutes(closestCp)

  --  InfCore.PrintInspect("CamoParasiteAppear cpRoutes")--DEBUG
  --  InfCore.PrintInspect(cpRoutes)

  if routeCount<this.numBosses then--this.numParasites then--DEBUGNOW
    InfCore.Log("WARNING: InfBossEvent CamoParasiteAppear - routeCount< #TppBossQuiet2 instances",true)
    --return
  end

  this.routeBag=InfUtil.ShuffleBag:New()
  for route,bool in pairs(cpRoutes) do
    this.routeBag:Add(route)
  end

  for index=1,this.numBosses do
    local name=this.currentBossNames[index]
    if svars[bossStatesName][index]==this.stateTypes.READY then
      local gameId=GetGameObjectId("TppBossQuiet2",name)
      if gameId==NULL_ID then
        InfCore.Log("WARNING: InfBossTppBossQuiet2.Appear - "..name.. " not found",true)
      else
        local parasiteRotY=0

        InfCore.Log(name.." appear",this.debugModule)

        --ASSUMPTION 4 parasites
        --half circle with 2 leads
        --local angle=360/i

        --4 quadrants
        local angle=90*(index-1)
        local spawnPos=InfUtil.PointOnCircle(appearPos,spawnRadius,angle)

        this.SetRoutes(this.routeBag,gameId)

        SendCommand(gameId,{id="ResetPosition"})
        SendCommand(gameId,{id="ResetAI"})

        --tex can put camo parasites to an initial position
        --but they will move to their set route on activation
        SendCommand(gameId,{id="WarpRequest",pos=spawnPos,rotY=parasiteRotY})

        this.EnableByName(name)

        if this.disableFight then
          this.DisableFight(name)
        end

        SendCommand(gameId,{id="SetCloseCombatMode",enabled=true})--tex NOTE unsure if this command is actually individual
      end--if gameId
      --SendCommand({type="TppBossQuiet2"},{id="StartCombat"})
    end--if stateTypes.READY
  end--for currentBossNames

  return appearPos
end--Appear

function this.SetRoutes(routeBag,gameId)
  InfCore.Log("InfBossTppBossQuiet2.SetRoutes",this.debugModule)--DEBUG
  local attackRoute=routeBag:Next()
  local runRoute=routeBag:Next()
  local deadRoute=attackRoute--routeBag:Next()
  local relayRoute=routeBag:Next()
  local killRoute=routeBag:Next()

  SendCommand(gameId,{id="SetSnipeRoute",route=attackRoute,phase=0})
  SendCommand(gameId,{id="SetSnipeRoute",route=runRoute,phase=1})
  SendCommand(gameId,{id="SetDemoRoute",route=deadRoute})--tex route on death
  SendCommand(gameId,{id="SetLandingRoute",route=relayRoute})--tex nesesary else it gets stuck in jump to same position behaviour
  SendCommand(gameId,{id="SetKillRoute",route=killRoute})

  --SendCommand(gameId,{id="SetRecoveryRoute",route=recoveryRoute})--tex ?only used with quiet
  --SendCommand(gameId,{id="SetAntiHeliRoute",route=antiHeliRoute})--tex ?only used with quiet
end--SetRoutes

--Messages>
function this.OnDamage(gameId,attackId,attackerId)
  local BossModule=this

  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=BossModule.gameObjectTypeIndex then
    return
  end

  local nameIndex=BossModule.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  local attackerIndex=GetTypeIndex(attackerId)
  --tex player damaged by boss
  if typeIndex==GAME_OBJECT_TYPE_PLAYER2 and attackerIndex==BossModule.gameObjectTypeIndex then
    InfBossEvent.SetFocusOnPlayerPos(BossModule.currentParams.timeOut)
    return
  end

  --tex boss damaged by player
  if typeIndex==BossModule.gameObjectTypeIndex and attackerIndex==GAME_OBJECT_TYPE_PLAYER2 then
    InfBossEvent.SetFocusOnPlayerPos(BossModule.currentParams.timeOut)
    return
  end

  BossModule.OnTakeDamage(nameIndex,gameId)
end--OnDamage

--IN: this.states
--IN/OUT: this.hitCounts
--IN: camoShiftRouteAttackCount
function this.OnTakeDamage(nameIndex,gameId)
  --tex see note on camoShiftRouteAttackCount
  if svars[bossStatesName][nameIndex]==this.stateTypes.READY then
    this.hitCounts[nameIndex]=this.hitCounts[nameIndex]+1
    if this.hitCounts[nameIndex]>=camoShiftRouteAttackCount then--tex module local
      this.hitCounts[nameIndex]=0
      this.SetRoutes(this.routeBag,gameId)
    end
  end
end--OnTakeDamage

function this.OnDying(gameId)
  local BossModule=this

  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=BossModule.gameObjectTypeIndex then
    return
  end

  local nameIndex=BossModule.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  --KLUDGE DEBUGNOW don't know why OnDying keeps triggering repeatedly
  if svars[bossStatesName][nameIndex]==this.stateTypes.DOWNED then
    InfCore.Log"WARNING: InfBossEvent.OnDying state already ==DOWNED"
    return
  end

  svars[bossStatesName][nameIndex]=this.stateTypes.DOWNED

  if this.debugModule then
    InfCore.Log("OnDying is "..this.gameObjectType,true)
  end
  --InfCore.PrintInspect(this.states,{varName="states"})--DEBUGNOW InspectVars

  if InfBossEvent.IsAllCleared() then
    InfCore.Log("InfBossEvent OnDying: all eliminated")--DEBUG
    InfBossEvent.EndEvent()
  end
end--OnDying

function this.OnFulton(gameId,gimmickInstance,gimmickDataSet,stafforResourceId)
  local BossModule=this

  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=BossModule.gameObjectTypeIndex then
    return
  end

  local nameIndex=BossModule.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  svars[bossStatesName][nameIndex]=this.stateTypes.FULTONED

  --InfCore.PrintInspect(this.states,{varName="states"})--DEBUGNOW

  if InfBossEvent.IsAllCleared() then
    InfCore.Log("InfBossEvent OnFulton: all eliminated")--DEBUG
    InfBossEvent.EndEvent()
  end
end--OnFulton

function this.OnPlayerDamaged(playerIndex,attackId,attackerId)
  local BossModule=this
  local gameId=attackerId

  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=BossModule.gameObjectTypeIndex then
    return
  end

  local nameIndex=BossModule.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  InfBossEvent.SetFocusOnPlayerPos(BossModule.currentParams.timeOut)
end--OnPlayerDamaged
--Messages<

function this.IsAllCleared()
  if this.currentSubType==nil then
    return true
  end

  local allCleared=true

  for index=1,this.numBosses do
    if svars[bossStatesName][index]==this.stateTypes.READY then
      allCleared=false
    end
  end
  return allCleared
end--IsAllCleared

function this.IsReady(nameIndex)
  return svars[bossStatesName][nameIndex]==this.stateTypes.READY
end--IsReady

--Ivars, menu>
this.registerIvars={}
this.registerMenus={}

local ivarPrefix="boss_"..this.gameObjectType
local bossMenuName=ivarPrefix.."_Menu"
table.insert(this.registerMenus,bossMenuName)

this[bossMenuName]={
  parentRefs={"InfBossEvent.bossEventMenu"},
  options={
  }
}

this.enableBossIvarName=ivarPrefix.."_enable"
local ivar={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
}--ivar
IvarProc.AddIvarToModule(this,this.enableBossIvarName,ivar,bossMenuName)

--REF boss_TppParasite2_ARMOR_enable
local subTypeNames=InfUtil.TableKeysToArray(this.subTypes)
for i,subType in ipairs(subTypeNames)do
  local ivarName=table.concat({ivarPrefix,subType,"enable"},"_")
  local ivar={
    save=IvarProc.CATEGORY_EXTERNAL,
    default=1,
    range=Ivars.switchRange,
    settingNames="set_switch",
  }--ivar
  this.enableSubTypeIvarNames[subType]=ivarName
  IvarProc.AddIvarToModule(this,ivarName,ivar,bossMenuName)
end--for subTypeNames
--Ivars, menu<

return this