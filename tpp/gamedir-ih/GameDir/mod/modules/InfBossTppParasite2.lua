--InfBossTppParasite2.lua
--Boss type for InfBossEvent
--For TppParasite2 gameObject
--tex bunch of duplication with InfBossTppBossQuiet2, if common stuff extends to yet another, and changes are an issue
--subType (my name), various ways game refers to them)
--ARMOR, parasite_metal, wmu3, ParasiteHard, PARASITE_CURING, Metal (GetParasiteType)
  --fv2 - dont know how these are applied
  -- <value key="FovaHard">/Assets/tpp/fova/chara/wmu/wmu3_v00.fv2</value>
  -- <value key="FovaNormal">/Assets/tpp/fova/chara/wmu/wmu3_v01.fv2</value>

--MIST, parasite_fog, wmu0, ParasiteFog, ParasiteCommon, PARASITE_FOG, Fog (GetParasiteType)

--Behaviors/Quirks
--AI seems to be hard coded to use 4 instances in most cases
--even if theres only two locators, StartAppearance still uses entity totalcount
--if totalcount is less than 4, totalcount will appear but the ai will break/just stand there and not react to player
--if totalcount is greater than 4, totalcount will appear but those over toalcount will only react intermittanly, 
--moving to initiall attack pos with the others, ocasionally retreating out of range
--facing the player, 
--but not actually walking or fighting
--See submods/boss for split locator packs of diffrent counts used while debugging this

--health bars break when TppBossQuiet2 also loaded TODO: is this just a scripblock issue, or also a loaded at missionpack issue

--TODO: I'm not even sure how these are diffrentiated
--ARMOR
--MIST

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
this.name="InfBossTppParasite2"

this.gameObjectType="TppParasite2"
this.gameObjectTypeIndex=TppGameObject.GAME_OBJECT_TYPE_PARASITE2
this.bossStatesName="bossEvent_"..this.gameObjectType.."State"
local bossStatesName=this.bossStatesName
this.blockName=this.gameObjectType.."_block"
this.blockNameS32=InfCore.StrCode32(this.blockName)

this.hardcodedCount=true--tex see Behaviors/Quirks

--SetBossSubType
this.currentSubType=nil--tex while there is IsEnabled, this is a more accurate check whether this is chosen/active for an event (InfBossEvent.ChooseBossTypes)
this.currentBossNames=nil
this.currentParams=nil

this.gameIdToNameIndex={}--InitEvent

this.subTypes={
  ARMOR=true,
  MIST=true,
}

this.enableSubTypeIvarNames={}

this.packages={
  --missionPack
  scriptBlockData="/Assets/tpp/pack/mission2/boss/ih/"..this.gameObjectType.."_scriptblockdata.fpk",
  --scriptBlockPacks
  ARMOR={"/Assets/tpp/pack/mission2/online/o50050/o50055_parasite_metal.fpk",},
  MIST={"/Assets/tpp/pack/mission2/ih/ih_parasite_mist.fpk",},--TODO: pftxs
}--packages

--tex locatorNames from packs
this.bossObjectNames={
  ARMOR={
    "Parasite0",
    "Parasite1",
    "Parasite2",
    "Parasite3",
  },
  MIST={
    "wmu_mist_ih_0000",
    "wmu_mist_ih_0001",
    "wmu_mist_ih_0002",
    "wmu_mist_ih_0003",
  },
}--bossObjectNames

this.eventParams={
  ARMOR={
    spawnRadius=40,--ivar
    escapeDistance=250,--ivar
    timeOut=1*60,--ivar
    zombifies=true,--TODO: set false and test the boss objects zombifying ability
    fultonable=true,
  },
  MIST={
    spawnRadius=20,--ivar
    escapeDistance=250,
    timeOut=1*60,--ivar
    zombifies=true,
    fultonable=true,
  }
}--eventParams

this.params={--SetParameters
  ARMOR={
    sightDistance=25,--[[20,25,30,]]
    sightDistanceCombat=75,--[[75,100]]
    sightVertical=40,--[[36,40,55,60]]
    sightHorizontal=60,--[[48,60,100]]
    noiseRate=8,--[[10]]
    avoidSideMin=8,
    avoidSideMax=12,
    areaCombatBattleRange=50,
    areaCombatBattleToSearchTime=1,
    areaCombatLostSearchRange=1000,
    areaCombatLostToGuardTime=120,--[[120,60]]
    --DEBUGNOW no idea of what a good value is
    --areaCombatGuardDistance=120,
    throwRecastTime=10,
  },
  MIST={
    sightDistance=25,--[[20,25,30,]]
    sightDistanceCombat=75,--[[75,100]]
    sightVertical=40,--[[36,40,55,60]]
    sightHorizontal=60,--[[48,60,100]]
    noiseRate=8,--[[10]]
    avoidSideMin=8,
    avoidSideMax=12,
    areaCombatBattleRange=50,
    areaCombatBattleToSearchTime=1,
    areaCombatLostSearchRange=1000,
    areaCombatLostToGuardTime=120,--[[120,60]]
    --DEBUGNOW no idea of what a good value is
    --areaCombatGuardDistance=120,
    throwRecastTime=10,
  },
}--params
this.combatGrade={--SetCombatGrade
  ARMOR={
    defenseValueMain=4000,
    defenseValueArmor=7000,--[[8400]]
    defenseValueWall=8000,--[[9600]]
    offenseGrade=2,--[[5]]
    defenseGrade=7,
  },
  MIST={
    defenseValueMain=4000,
    defenseValueArmor=7000,--[[8400]]
    defenseValueWall=8000,--[[9600]]
    offenseGrade=2,--[[5]]
    defenseGrade=7,
  }
}--combatGrade

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

  local saveVarsList = {
    --GOTCHA: svar arrays are from 0, but I'm +1 so I can index it lua style +1 since the rest of InfBoss uses that as bossNames 'nameIndex'
    [this.bossStatesName]={name=this.bossStatesName,type=TppScriptVars.TYPE_INT8,arraySize=InfBossEvent.MAX_BOSSES_PER_TYPE+1,value=this.stateTypes.READY,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},
    --tex engine sets svars.parasiteSquadMarkerFlag when camo parasite marked, will crash if svar not defined
    --DEBUGNOW only if camo enabled? TEST
    --parasiteSquadMarkerFlag={name="parasiteSquadMarkerFlag",type=TppScriptVars.TYPE_BOOL,arraySize=InfBossEvent.MAX_BOSSES_PER_TYPE,value=false,save=true,sync=true,wait=true,category=TppScriptVars.CATEGORY_RETRY},
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
    --InfBossTppParasite2
    Timer={
      {msg="Finish",sender="Timer_BossCombat",func=this.Timer_BossCombat},
    },
  }
end--Messages

function this.PostModuleReload(prevModule)

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
  return Ivars[this.ivarNames.enableBoss]:Is(1)
end--IsEnabled

function this.GetEnabledSubTypes(missionCode)
  --tex TODO: forMission?
  --TODO: addon opt in or out?

  local enabledSubTypes=IvarProc.GetIvarKeyNameValues(this.enableSubTypeIvarNames)

  --tex WORKAROUND mb crashes on armor/mist
  if missionCode==30050 then
    enabledSubTypes.ARMOR=false
    enabledSubTypes.MIST=false
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
end--InitBoss

function this.EndEvent()
  if this.currentSubType==nil then
    return
  end
  
  for index=1,#this.currentBossNames do
    svars[bossStatesName][index]=this.stateTypes.READY
  end
  
  SendCommand({type="TppParasite2"},{id="StartWithdrawal"})
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
  local gameId=GetGameObjectId("TppParasite2",name)
  if gameId==NULL_ID then
    return
  end

  SendCommand(gameId,{id="Unrealize"})
end--DisableByName

--InfBossEvent
--IN: this.ivarDefs
--IN: parasiteParamNames
--IN: parasiteGradeNames  
function this.SetupParasites()
  InfCore.LogFlow("InfBossTppParasite2.Setup")

  SendCommand({type="TppParasite2"},{id="SetFultonEnabled",enabled=true})

  local parasiteParams=this.params[this.currentSubType]
  SendCommand({type="TppParasite2"},{id="SetParameters",params=parasiteParams})
  if this.debugModule then
    InfCore.PrintInspect(parasiteParams,"SetParameters")
  end

  local combatGradeCommand=this.combatGrade[this.currentSubType]
  combatGradeCommand.id="SetCombatGrade"
  SendCommand({type="TppParasite2"},combatGradeCommand)
  if this.debugModule then
    InfCore.PrintInspect(combatGradeCommand,"SetCombatGrade")
  end
end--Setup

--InfBossEvent
function this.Appear(appearPos,closestCp,closestCpPos,spawnRadius)
  InfCore.Log("InfBossTppParasite2.Appear: spawnRadius:"..spawnRadius)
  if this.debugModule then
    InfCore.PrintInspect(appearPos,"appearPos")
  end
  --tex after fultoning armor parasites don't appear, try and reset
  --doesnt work, parasite does appear, but is in fulton pose lol
  --  if numFultonedThisMap>0 then
  --    for k,parasiteName in pairs(this.parasiteNames.ARMOR) do
  --      local gameId=GetGameObjectId(parasiteName)
  --      if gameId~=NULL_ID then
  --        SendCommand(gameId,{id="Realize"})
  --      end
  --    end
  --  end

  for index=1,this.numBosses do
    local name=this.currentBossNames[index]
    local gameId=GetGameObjectId(name)
    if gameId==NULL_ID then
      InfCore.Log("WARNING: "..name.. " not found",true)
    end
  end

  --tex totalCount parasites appear all at once, distributed in a circle (see Behaviors/Quirks in header) 
  SendCommand({type="TppParasite2"},{id="StartAppearance",position=Vector3(appearPos),radius=spawnRadius})

  --tex WORKAROUND once one armor parasite has been fultoned the rest will be stuck in some kind of idle ai state on next appearance
  --forcing combat bypasses this TODO VERIFY again
  local isFultoned=false
  for index=1,this.numBosses do
    if svars[bossStatesName][index]==this.stateTypes.FULTONED then
      isFultoned=true
      break
    end
  end
  if isFultoned and this.bossSubType=="ARMOR" then
    --InfCore.Log("Timer_BossCombat start",true)--DEBUG
    TimerStart("Timer_BossCombat",4)
  end
end--Appear

--Started by Timer_BossAppear soley as a workaround
function this.Timer_BossCombat()
  SendCommand({type="TppParasite2"},{id="StartCombat"})
end

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

function this.OnTakeDamage(nameIndex,gameId)
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
local bossMenuName=this.name.."_Menu"
table.insert(this.registerMenus,bossMenuName)

this[bossMenuName]={
  parentRefs={"InfBossEvent.bossEventMenu"},
  options={
  }
}

this.ivarNames={}

local ivarName=this.name.."_enable"
local ivar={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
}--ivar
IvarProc.AddIvarToModule(ivarName,this,ivar,bossMenuName)
this.ivarNames.enable=ivarName

local ivarName=ivarPrefix.."_variableBossCount"
local ivar={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
}--ivar
IvarProc.AddIvarToModule(ivarName,this,ivar,bossMenuName)
this.ivarNames.variableBossCount=ivarName

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
  IvarProc.AddIvarToModule(ivarName,this,ivar,bossMenuName)
end--for subTypeNames
--Ivars, menu<

return this