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

--Behavior/quirks

--somehow automagically knows it's quiet when set to quiet .parts or something
--theres a SendCommand GetQuietType that returns Str32 
--Cam
--Quiet
--Light - the 'Light' version of Quiet in qest_bossQuiet_00 that just has snipe pose and quest just triggers demo > mission

--there is a ref in exe to 
--/Assets/tpp/motion/mtar/bossquiet2/LightQuiet_layers.mtar : PathCode64Ext: 67007e631796c9eb
--on testing changing the mtar/mog from LightQuiet to Quiet is what makes GetQuietType change from reporting Light to Quiet
--but no ref to quiet mtar in exe(check again)
--and camo uses same mtar/mog as quiet anyway
--there's also refs to .parts right next to it
--/Assets/tpp/parts/chara/qui/qui0_main0_def_v00.parts : PathCode64Ext: e0a9e69270ab9a87
--/Assets/tpp/parts/chara/wmu/wmu1_main0_def_v00.parts : PathCode64Ext: e0ab269eb05f2874
--so basically it uses the .parts name to decide between quiet/camo, and mtar name to decide between quiet/light 
--(since quiet/light use same parts but different mtar name and quiet/camo use same mtar name but different .parts name)

--actual logic (in FUN_140a55850 1.0.15.3) seems to be:
--if ..qui0_main0_def_v00.parts and not ..wmu1_main0_def_v00.parts
--  type = 0
--  if ..LightQuiet_layers.mtar
--    type = 1
--else
-- type = 2-- camo I guess

--well that's what supposedly happens, 
--but GetQuietType was still reporting Quiet even when I changed the .parts name to a unique name, or even to ..wmu1_main0_def_v00.parts
--yet it does change from Quiet to Light (visa versa) on ..LightQuiet_layers.mtar

--ultimately don't know what actual behavior this TppBossParasite2 sub type (for want of better name, not talking about ih boss subType)
--don't know what actual behavior it covers though, likely some of the other stuff described below that dont have obvious lua origins

--TODO: so don't know actually how safe it would be to retrieve quiet on heli, see if thats handled in mission lua or not


--QUIET: cant be fultoned TODO: you setting fulton correct? I think I am, using same code as camo which is fultonable, SetFultonEnabled 
--crash on mark if svar isMarked does not exist

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
this.currentInfo=nil
this.currentParams=nil

this.updateToClosestCommandPost=true--tex InfBossTppBossQuiet2 needs routes, and kludges by using cp routes
this.changeCpTime=10--tex > lastContactTime
this.playerDistanceChangeCp=200

this.gameIdToNameIndex={}--InitEvent

this.names={}
this.infos={}

this.enableSubTypeIvarNames={}

this.packages={
  --missionPack
  scriptBlockData="/Assets/tpp/pack/mission2/boss/ih/"..this.gameObjectType.."_scriptblockdata.fpk",
}--packages

--tex TODO uhh, does SetCombatGrade exist for TppBossQuiet2?
-- this.combatGrade={--SetCombatGrade
--   DEFAULT={
--     defenseValue=4000,
--     offenseGrade=2,
--     defenseGrade=7,
--   },
--   CAMO={
--     defenseValue=4000,
--     offenseGrade=2,
--     defenseGrade=7,
--   },
-- }--combatGrade

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

  --tex this is load time, so needs to be on if you want to toggle subtype at runtime
  -- if not this.IsEnabled() then
  --   return{}
  -- end

  local saveVarsList = {
    --GOTCHA: svar arrays are from 0, but I'm +1 so I can index it lua style +1 since the rest of InfBoss uses that as bossNames 'nameIndex'
    [this.bossStatesName]={name=this.bossStatesName,type=TppScriptVars.TYPE_INT8,arraySize=InfBossEvent.MAX_BOSSES_PER_TYPE+1,value=this.stateTypes.READY,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},
    --tex engine sets svars.parasiteSquadMarkerFlag when camo parasite marked, will crash if svar not defined (what kind of crash)
    --during rework testing, there seems to be a hang when one dies, not sure if that's what it was I was originally commenting about above
    --DEBUGNOW only if camo enabled? TEST with this commented out on QUIET
    parasiteSquadMarkerFlag={name="parasiteSquadMarkerFlag",type=TppScriptVars.TYPE_BOOL,arraySize=InfBossEvent.MAX_BOSSES_PER_TYPE,value=false,save=true,sync=true,wait=true,category=TppScriptVars.CATEGORY_RETRY},
    --tex from s10050_sequence quiet, will hang on marking if this doesnt exist. I don't know how it knows its quiet/doesnt seem an issue with camo parasite
    isMarked=false,

    --REF s10050_sequence quiet
    -- deathBulletCount		= 0,
    -- restoreState			= "None",	
    
    
    -- isLostPlayer			= false,	
    -- isUseDeathBullet		= false,	
  
    
    -- isKillMode				= false,	
    -- isQuietDown				= false,
    -- isPlayerStayInDemoTrap	= false,	
    -- isPlayerRideSomething	= false,	
    -- isPermitFultonRadio		= false,	
    -- isPlayerRideHeliWithQ	= false,	
    -- isQuietCarried			= false,
    -- isQuietRideHeli			= false,	
    -- isHeliClear				= false,	
    -- isQuietDead				= false,
    
    
    -- isQuietInjured			= false,
    
    
    -- isBreakPrst_1_A			= false,
    -- isBreakPrst_1_B			= false,
    -- isBreakPrst_2_A			= false,
    -- isBreakPrst_2_B			= false,
    -- isBreakPrst_3_A			= false,
    -- isBreakPrst_3_B			= false,
    -- isBreakPrst_4_A			= false,
    -- isBreakPrst_4_B			= false,
    -- isBreakPrst_5_A			= false,
    -- isBreakPrst_5_B			= false,
    -- isBreakPrst_6_A			= false,
    -- isBreakPrst_6_B			= false,
    -- isBreakPrst_7_A			= false,
    -- isBreakPrst_7_B			= false,
    -- isBreakPrst_8_A			= false,
    -- isBreakPrst_8_B			= false,
  
    
    -- isQuietReady				= false,	
    -- isPlayerStayInRestrictTrap	= false,	
    -- isRideOffInDemoTrap			= false,	
    -- isFirstTimeErase			= false,	
    -- isFirstTimeAntiHeli			= false,	
    -- isFinishKillGame			= false,	
    -- isRecovery					= false,	
    -- --isMarked					= false,	
    -- isStayStartPos				= false,	
    -- isPlayAvoidQuiet_1			= false,	
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
    Timer={
      {msg="Finish",sender="Timer_AppearToInitialRoute",func=this.Timer_AppearToInitialRoute},
    },
  }
end--Messages

function this.PostModuleReload(prevModule)
  this.routeBag=prevModule.routeBag
end

function this.OnModuleLoad(prevModule)
  this.LoadInfos()
  this.AddSubTypeIvars()
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

--tex enable stuff thats usually blocked if not enabled during runtime (that actually can be)
function this.EnableInMission()
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.DisableInMission()
  this.messageExecTable=nil
end

--InfBossEvent.AddMissionPacks
function this.AddPacks(missionCode,packPaths)
  --tex see note in InfBossEvent
  -- if not this.IsEnabled() then
  --   return packPaths
  -- end

  packPaths[#packPaths+1]=this.packages.scriptBlockData
end--AddPacks

--tex addons>
function this.LoadInfos()
  InfCore.LogFlow(this.name..".LoadInfos")

  local files=InfCore.GetFileListInModFolder("bosses/"..this.gameObjectType.."/")
  InfCore.PrintInspect(files,"bosses/"..this.gameObjectType.."/")--
  for i,fileName in ipairs(files)do
    if fileName:find(".lua") then
      InfCore.Log(this.name..".LoadInfos: "..fileName)
      local info=InfCore.LoadSimpleModule(fileName)
      if not info then
        --InfCore.Log("")
      else
        this.infos[info.name]=info
        table.insert(this.names,info.name)
      end
    end--if .lua
  end--for files

 -- if this.debugModule then
    InfCore.PrintInspect(this.names,"names")
    --InfCore.PrintInspect(this.infos,"infos")
 -- end
end--LoadInfos
--<addons

function this.IsEnabled()
  return Ivars[this.ivarNames.enable]:Is(1)
end--IsEnabled

function this.GetEnabledSubTypes(missionCode)
  --tex WORKAROUND quiet battle, will crash with CAMO (which also use TppBossQuiet2)
  if TppPackList.GetLocationNameFormMissionCode(missionCode)=="AFGH" and TppQuest.IsActive"waterway_q99010" then
    InfCore.Log("InfBossEvent.ChooseBossTypes - IsActive'waterway_q99010', disabling CAMO")--DEBUGNOW TODO triggering when I wouldnt have expected it to
    return{}
  end
  --tex WORKAROUND zoo currently has no routes for sniper
  if missionCode==30150 then
    return{}
  end

  --tex TODO: forMission?
  --TODO: addon opt in or out?

  local enabledSubTypes=IvarProc.GetIvarKeyNameValues(this.enableSubTypeIvarNames)
  if this.debugModule then
    InfCore.PrintInspect(enabledSubTypes,"GetEnabledSubTypes")
  end

  return enabledSubTypes
end--GetEnabledSubTypes

--InfBossEvent
function this.SetBossSubType(bossSubType,numBosses)
  if not this.infos[bossSubType] then
    InfCore.Log("ERROR: "..this.name..".SetBossSubType: has no subType "..tostring(bossSubType))
    return
  end
  InfCore.Log(this.name..".SetBossSubType: "..bossSubType.." numBosses:"..numBosses)
  this.currentSubType=bossSubType
  this.currentInfo=this.infos[bossSubType]
  this.numBosses=numBosses
  this.currentParams=this.currentInfo.eventParams
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

function this.ClearStates()
  for index=1,InfBossEvent.MAX_BOSSES_PER_TYPE do
    svars[bossStatesName][index]=this.stateTypes.READY
  end
end

--CALLER: OnScriptBlockStateTransition above. 
--once scriptblock loaded the boss gameobjects are actually loaded
--OUT: this.gameIdToNameIndex
function this.InitBoss()
  if this.currentSubType==nil then
    return
  end
  InfCore.Log(this.name..".InitBoss")

  local types={--tex wrangled from exe
    [InfCore.StrCode32"Light"]="Light",
    [InfCore.StrCode32"Cam"]="Cam",
    [InfCore.StrCode32"Quiet"]="Quiet",
  }
  local quietType=SendCommand({type="TppBossQuiet2"},{id="GetQuietType"})
  local quietTypeStr=types[quietType] or ("Uknown:"..tostring(quietType))
  InfCore.Log("TppBossQuiet2 GetQuietType: "..quietTypeStr)

  InfUtil.ClearTable(this.gameIdToNameIndex)
  InfBossEvent.BuildGameIdToNameIndex(this.currentInfo.objectNames,this.gameIdToNameIndex)

  this.DisableAll()
  this.SetupParasites()

  for nameIndex,name in ipairs(this.currentInfo.objectNames)do
    this.hitCounts[nameIndex]=0
  end--for gameObjectNames
end--InitBoss

function this.EndEvent()
  if this.currentSubType==nil then
    return
  end

  this.ClearStates()
  
  SendCommand({type="TppBossQuiet2"},{id="SetWithdrawal",enabled=true})--tex uhh, where did I get this from, cant see any references to it
end--EndEvent

function this.DisableAll()
  if this.currentSubType==nil then
    return
  end

  for i,name in ipairs(this.currentInfo.objectNames) do
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
--IN: this.combatGrade
function this.SetupParasites()
  InfCore.LogFlow("InfBossTppBossQuiet2.Setup")

  SendCommand({type="TppBossQuiet2"},{id="SetFultonEnabled",enabled=true})

  --tex TODO: no actual usage in vanilla
  -- local combatGradeCommand=this.combatGrade[this.currentSubType] or this.combatGrade.DEFAULT
  -- combatGradeCommand.id="SetCombatGrade"
  -- SendCommand({type="TppBossQuiet2"},combatGradeCommand)
  -- if this.debugModule then
  --   InfCore.PrintInspect(combatGradeCommand,"SetCombatGrade")
  -- end
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
  --mb
  "plnt0",
  "plnt1",
  "plnt2",
  "plnt3",
}
local groupSniper="groupSniper"

--IN: mvars.ene_routeSetsDefine
function this.GetRoutes(cpName)
  local routeSets=mvars.ene_routeSetsDefine[cpName]
  if not routeSets then
    InfCore.Log"WARNING: InfBossEvent.GetRoutes: no routesets found, aborting"
    return
  end

  local cpRoutes={}
  --tex TODO prioritze picking sniper group first?
  if routeSets==nil then
    InfCore.Log("WARNING: InfBossEvent.GetRoutes: no routesets for "..cpName,true)--DEBUG
    return
  end

  if this.debugModule then
    InfCore.PrintInspect(routeSets,"InfBossTppBossQuiet.GetRoutes: routeSets: "..cpName)
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
--IN: this.currentInfo.objectNames
--IN: this.this.disableFight
--OUT: this.routeBag
function this.Appear(appearPos,closestCp,closestCpPos,spawnRadius)
  --InfCore.Log"CamoParasiteAppear"--DEBUG

  --tex may already be cleared according to svars
  if this.IsAllCleared() then
    InfCore.Log(this.name..".Appear: IsAllCleared, aborting appear")
    return
  end

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
    local name=this.currentInfo.objectNames[index]
    if svars[bossStatesName][index]==this.stateTypes.READY then
      local gameId=GetGameObjectId("TppBossQuiet2",name)
      if gameId==NULL_ID then
        InfCore.Log("WARNING: InfBossTppBossQuiet2.Appear - "..name.. " not found",true)
      else
        InfCore.Log(name.." appear",this.debugModule)
        local angle=(360/this.numBosses)*(index-1)--tex TODO fuzz with rnd
        local spawnPos=InfUtil.PointOnCircle(appearPos,spawnRadius,angle)
        local parasiteRotY=InfUtil.YawTowardsLookPos(spawnPos,appearPos)

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
  end--for objectNames

  TimerStart("Timer_AppearToInitialRoute",math.random(2,3))

  return appearPos
end--Appear

function this.SetRoutes(routeBag,gameId)
  InfCore.Log("InfBossTppBossQuiet2.SetRoutes",this.debugModule)--DEBUG
  local attackRoute=routeBag:Next()
  local runRoute=routeBag:Next()
  local deadRoute=attackRoute--routeBag:Next()
  local relayRoute=routeBag:Next()
  local killRoute=routeBag:Next()

  --tex TODO: analyse vanilla routes to figure these out
  SendCommand(gameId,{id="SetSnipeRoute",route=attackRoute,phase=0})
  SendCommand(gameId,{id="SetSnipeRoute",route=runRoute,phase=1})
  SendCommand(gameId,{id="SetDemoRoute",route=deadRoute})--tex route on death
  SendCommand(gameId,{id="SetLandingRoute",route=relayRoute})--tex nesesary else it gets stuck in jump to same position behaviour
  SendCommand(gameId,{id="SetKillRoute",route=killRoute})--?

  --SendCommand(gameId,{id="SetRecoveryRoute",route=recoveryRoute})--tex ?only used with quiet
  --SendCommand(gameId,{id="SetAntiHeliRoute",route=antiHeliRoute})--tex ?only used with quiet
end--SetRoutes

function this.Timer_AppearToInitialRoute()
  for index=1,this.numBosses do
    local name=this.currentInfo.objectNames[index]
    if svars[bossStatesName][index]==this.stateTypes.READY then
      local gameId=GetGameObjectId("TppBossQuiet2",name)
      if gameId==NULL_ID then
        InfCore.Log("WARNING: InfBossTppBossQuiet2.Appear - "..name.. " not found",true)
      else
        this.SetRoutes(this.routeBag,gameId)
      end
    end
  end
end--Timer_AppearToInitialRoute

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
    InfBossEvent.SetFocusOnPlayerPos()
    return
  end

  --tex boss damaged by player
  if typeIndex==BossModule.gameObjectTypeIndex and attackerIndex==GAME_OBJECT_TYPE_PLAYER2 then
    InfBossEvent.SetFocusOnPlayerPos()
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
  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=this.gameObjectTypeIndex then
    return
  end

  local nameIndex=this.gameIdToNameIndex[gameId]
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

  --tex CULL Timer_BossEventMonitor should handle this
  -- if InfBossEvent.IsAllCleared() then
  --   InfCore.Log("InfBossEvent OnDying: all eliminated")--DEBUG
  --   InfBossEvent.EndEvent()
  --   InfBossEvent.StartCountdown()
  -- end
end--OnDying

function this.OnFulton(gameId,gimmickInstance,gimmickDataSet,stafforResourceId)
  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=this.gameObjectTypeIndex then
    return
  end

  local nameIndex=this.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  svars[bossStatesName][nameIndex]=this.stateTypes.FULTONED

  --InfCore.PrintInspect(this.states,{varName="states"})--DEBUGNOW

  if this.debugModule then
    InfCore.Log("OnFulton is "..this.gameObjectType,true)
  end

  --tex CULL Timer_BossEventMonitor should handle this
  -- if InfBossEvent.IsAllCleared() then
  --   InfCore.Log("InfBossEvent OnFulton: all eliminated")--DEBUG
  --   InfBossEvent.EndEvent()
  --   InfBossEvent.StartCountdown()
  -- end
end--OnFulton

function this.OnPlayerDamaged(playerIndex,attackId,attackerId)
  local gameId=attackerId

  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=this.gameObjectTypeIndex then
    return
  end

  local nameIndex=this.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  InfBossEvent.SetFocusOnPlayerPos()
end--OnPlayerDamaged
--Messages<

function this.IsAllCleared()
  if this.currentSubType==nil then
    return true
  end

  local allCleared=true

  for index=1,this.numBosses do
    if svars[bossStatesName][index]==this.stateTypes.READY then
      if this.debugModule then
        InfCore.Log(this.name..".IsAllCleared: boss index "..index.." not cleared")
      end
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

this.OnChangeEnable=function(self,setting)
  if TppMission.IsMissionStart()then
    if setting==1 then
      this.EnableInMission()
    else
      this.DisableInMission()
    end
  end
end

local ivarName=this.name.."_enable"
local ivar={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=this.OnChangeEnable,
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

function this.AddSubTypeIvars()
  local registerIvars={}
  local menuName=bossMenuName
  --REF boss_TppParasite2_ARMOR_enable
  for i,subType in ipairs(this.names)do
    local ivarName=table.concat({ivarPrefix,subType,"enable"},"_")
    local ivar={
      description=this.infos[subType].description and this.infos[subType].description.." Enable",
      save=IvarProc.CATEGORY_EXTERNAL,
      default=1,
      range=Ivars.switchRange,
      settingNames="set_switch",
      OnChange=this.OnChangeEnable,
    }--ivar
    IvarProc.AddIvarToModule(ivarName,this,ivar,menuName)

    table.insert(registerIvars,ivarName)

    this.enableSubTypeIvarNames[subType]=ivarName
  end--for subTypeNames
end--AddSubTypeIvars
--Ivars, menu<

return this