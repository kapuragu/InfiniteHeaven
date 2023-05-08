-- InfBossEvent.lua
-- tex implements 'boss attacks' of parasite/skulls unit event
-- currently attacks are are based around a single bossFocusPos (see BossAppear) and a lastContactTime 
-- conceptually similar to enemy focus position

--TODO: expose  parasiteAppearTimeMin, parasiteAppearTimeMax

--[[
Rough sketch out of progression of current system:

OnLoad if IsMissionStart
  Select boss types for event

OnMissionCanStart or other means of starting event
  InitEvent

InitEvent
  ResetAttackCountdown or CalculateAttackCountdown - segmented interval for StartEventTimer 
  disable all the bosses
  init relavant state/boss settings

On FadeInOnGameStart, or some other means of starting event
  call StartEventTimer

StartEventTimer
  bail if all bosses eliminated
  start Timer_BossStartEvent on bossEvent_attackCountdownPeriod

Timer_BossStartEvent 
  decrement countdown
  call StartEventTimer again if countdown not done
  else start Timer_BossAppear

Timer_BossAppear
  bosses actually appear/event is actually active
  start Timer_BossEventMonitor

Timer_BossEventMonitor
  end event if player escaped from event position and the last contact timeout has passed
  else start Timer_BossEventMonitor (itself) on for next check

Various kill/fulton messages
    set boss states
    check all bosses to see if they have been eliminated
    if so then end event
--]]

local this={}

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

this.debugModule=false

--DATA

this.packages={
  --tex not seperate boss, just stuff that is alongside bosses that trigger zombification
  ZOMBIE={"/Assets/tpp/pack/mission2/ih/snd_zmb.fpk",},
}--packages

--TODO: check to see if other objects support GetPosition (see Timer_BossEventMonitor)
this.bossObjectTypes={
  ARMOR="TppParasite2",
  MIST="TppParasite2",
  CAMO="TppBossQuiet2",
}

local disableFight=false--DEBUG

--STATE
this.bossSubType="ARMOR"

--tex indexed by parasiteNames
this.hitCounts={}
--tex lastContactTime is in terms of GetRawElapsedTimeSinceStartUp (which is not adjusted for reload from checkpoint), 
--however its not saved anyway, as it only meaningful during attack it gets reset with everything else
this.lastContactTime=0

--tex for current event
this.numBosses=0

this.hostageParasiteHitCount=0--tex mbqf hostage parasites

this.MAX_BOSSES_PER_TYPE=4--LIMIT, tex would also have to bump, or set parasiteSquadMarkerFlag size (and test that actually does anything)

--tex see CalculateAttackCountdown, StartEventTimer
local attackCountdownTimespan=30--DYNAMIC: tex in minutes, rnd from min, max ivars see CalculateAttackCountdown
local countDownInterval=1*60--tex in seconds

function this.DeclareSVars()
  if not this.BossEventEnabled() then
    return{}
  end
  local saveVarsList = {
    --tex see ResetAttackCountdown
    bossEvent_attackCountdown=attackCountdownTimespan,
    --GOTCHA: svar arrays are from 0, but I'm +1 so I can index it lua style +1 since the rest of InfBoss uses that as bossNames 'nameIndex'
    bossEvent_bossStates={name="bossEvent_bossStates",type=TppScriptVars.TYPE_INT8,arraySize=InfBossEvent.MAX_BOSSES_PER_TYPE+1,value=InfBossEvent.stateTypes.READY,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},
    --DEBUGNOW TODO also index from 1
    bossEvent_focusPos={name="bossEvent_focusPos",type=TppScriptVars.TYPE_FLOAT,arraySize=3+1,value=0,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},
    --tex engine sets svars.parasiteSquadMarkerFlag when camo parasite marked, will crash if svar not defined
    --DEBUGNOW only if camo enabled? TEST
    parasiteSquadMarkerFlag={name="parasiteSquadMarkerFlag",type=TppScriptVars.TYPE_BOOL,arraySize=InfBossEvent.MAX_BOSSES_PER_TYPE,value=false,save=true,sync=true,wait=true,category=TppScriptVars.CATEGORY_RETRY},
  }
  return TppSequence.MakeSVarsTable(saveVarsList)
end

function this.PostModuleReload(prevModule)
  --this.hitCounts=prevModule.hitCounts
  --this.lastContactTime=prevModule.lastContactTime
  
  --tex for current event
  this.numBosses=prevModule.numParasites
  
  --this.hostageParasiteHitCount=prevModule.hostageParasiteHitCount
end
--

this.stateTypes={
  READY=0,
  DOWNED=1,
  FULTONED=2,
}

--TUNE
--tex since I'm repurposing routes buit for normal cps the camo parasites just seem to shift along a short route, or get stuck leaving and returning to same spot.
--semi workable solution is to just set new routes after the parasite has been damaged a few times.
local camoShiftRouteAttackCount=3

local triggerAttackCount=45--tex mbqf hostage parasites

local parasiteTypes={
  "ARMOR",
  "MIST",
  "CAMO",
}

--seconds
local monitorRate=10
local bossAppearTimeMin=4
local bossAppearTimeMax=8

local playerFocusRange=175--tex choose player pos as bossFocusPos if closest lz or cp > than this (otherwise whichever is closest of those)
local playerFocusRangeSqr=playerFocusRange*playerFocusRange
--tex player distance from parasite attack pos to call off attack
local escapeDistances={
  ARMOR=250,
  MIST=0,
  CAMO=250,
}
local escapeDistancesSqr={}
for paraType,escapeDistance in pairs(escapeDistances)do
  escapeDistancesSqr[paraType]=escapeDistance*escapeDistance
end

local spawnRadius={
  ARMOR=40,
  MIST=20,
  --tex since camos start moving to route when activated, and closest cp may not be that discoverable
  --or their positions even that good, spawn at player pos in a close enough radius that they spot player
  --they'll then be aiming at player when they reach the cp
  --TODO: alternatively try triggering StartCombat on camo spawn
  CAMO=10,
}
local spawnRadiusSqr={
}
for paraType,radius in pairs(spawnRadius)do
  spawnRadiusSqr[paraType]=radius*radius
end

local timeOuts={
  ARMOR=1*60,
  MIST=1*60,
  CAMO=1*60,
}

--TUNE zombies
local disableDamage=false
local isHalf=false
--<

local parasiteTypeNames={"ARMOR","MIST","CAMO"}

this.isParasiteObjectType={
  [TppGameObject.GAME_OBJECT_TYPE_PARASITE2]=true,
  [TppGameObject.GAME_OBJECT_TYPE_BOSSQUIET2]=true,
}

local bossModuleNames={
  ARMOR="InfBossTppParasite2",
  MIST="InfBossTppParasite2",
  CAMO="InfBossTppBossQuiet2",
}

this.bossModules={}--PostAllModulesLoad

--REF
-- this.bgmList={
--   ARMOR={
--     bgm_metallic={
--       start="Play_bgm_s10140_metallic",
--       finish="Set_Switch_bgm_s10140_metallic_ed",
--       restore="Set_Switch_bgm_s10140_metallic_op",
--       switch={
--         "Set_Switch_bgm_s10140_metallic_op",
--         "Set_Switch_bgm_s10140_metallic_sn",
--         "Set_Switch_bgm_s10140_metallic_al",
--         "Set_Switch_bgm_s10140_metallic_ed",
--       },
--     },
--     bgm_post_metallic={
--       start="Play_bgm_s10140_post_metallic",
--       finish="Stop_bgm_s10140_post_metallic",
--     },
--   },
-- }

this.registerIvars={
  "parasite_enabledARMOR",
  "parasite_enabledMIST",
  "parasite_enabledCAMO",
  "bossEvent_weather",
  "bossEvent_playerFocusRange",
  "parasite_zombieLife",
  "parasite_zombieStamina",
  "parasite_msfRate",
}

IvarProc.MissionModeIvars(
  this,
  "bossEvent_enable",
  {
    save=IvarProc.CATEGORY_EXTERNAL,
    range=Ivars.switchRange,
    settingNames="set_switch",
  },
  {
    "FREE",
    --"MISSION",
    --"MB_ALL",
  }
)

this.parasite_enabledARMOR={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.parasite_enabledMIST={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.parasite_enabledCAMO={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--tex See weatherTypes in StartEvent
this.bossEvent_weather={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,--parasite
  settings={"NONE","PARASITE_FOG","RANDOM"},
}

--tex time in minutes
--tex DEBUGNOW test to see if this breaks if changing it while in mission due to all the changes
IvarProc.MinMaxIvar(
  this,
  "bossEvent_attackCountdownPeriod",
  {
    default=10,
    OnChange=function(self,setting,prevSetting)
      IvarProc.PushMax(self,setting,prevSetting)
      InfBossEvent.CalculateAttackCountdown()
      InfBossEvent.StartEventTimer()
    end,
  },
  {
    default=30,
    OnChange=function(self,setting,prevSetting)
      IvarProc.PushMin(self,setting,prevSetting)
      InfBossEvent.CalculateAttackCountdown()
      InfBossEvent.StartEventTimer()
    end,
  },
  {
    inMission=true,
    range={min=0,max=180,increment=1},
  }
)

--SetParameters, mist/armor
local parasiteParamNames={
  "sightDistance",
  "sightDistanceCombat",
  "sightVertical",
  "sightHorizontal",
  "noiseRate",
  "avoidSideMin",
  "avoidSideMax",
  "areaCombatBattleRange",
  "areaCombatBattleToSearchTime",
  "areaCombatLostSearchRange",
  "areaCombatLostToGuardTime",
  --"areaCombatGuardDistance"
  "throwRecastTime",
}--parasiteParamNames

this.parasite_sightDistance={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=25,--20,25,30
  range={min=0,max=1000,},
}
this.parasite_sightDistanceCombat={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=75,--75,100
  range={min=0,max=1000,},
}
this.parasite_sightVertical={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=40,--36,40,55,60
  range={min=0,max=1000,},
}
this.parasite_sightHorizontal={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=60,--48,60,100
  range={min=0,max=1000,},
}
this.parasite_noiseRate={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=8,--10
  range={min=0,max=100,},
}
this.parasite_avoidSideMin={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=8,
  range={min=0,max=100,},
}
this.parasite_avoidSideMax={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=12,
  range={min=0,max=100,},
}
this.parasite_areaCombatBattleRange={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=50,
  range={min=0,max=1000,},
}
this.parasite_areaCombatBattleToSearchTime={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range={min=0,max=100,},
}
this.parasite_areaCombatLostSearchRange={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1000,
  range={min=0,max=10000,},
}
this.parasite_areaCombatLostToGuardTime={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=120,--120,60
  range={min=0,max=1000,},
}
--DEBUGNOW no idea of what a good value is
--this.parasite_areaCombatGuardDistance={
--  save=IvarProc.CATEGORY_EXTERNAL,
--  default=120,
--  range={min=0,max=1000,},
--}
this.parasite_throwRecastTime={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=10,
  range={min=0,max=1000,},
}
--
local parasiteGradeNames={
  "defenseValueMain",
  "defenseValueArmor",
  "defenseValueWall",
  "offenseGrade",
  "defenseGrade",
}--parasiteGradeNames

this.parasite_defenseValueMain={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=4000,
  range={min=0,max=100000,increment=1000},
}
this.parasite_defenseValueArmor={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=7000,--8400
  range={min=0,max=100000,increment=1000},
}
this.parasite_defenseValueWall={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=8000,--9600
  range={min=0,max=100000,increment=1000},
}
this.parasite_offenseGrade={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=2,--5
  range={min=0,max=100,},
}
this.parasite_defenseGrade={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=7,
  range={min=0,max=100,},
}

local parasiteGradeNamesCAMO={
  "defenseValue",
  "offenseGrade",
  "defenseGrade",
}--parasiteGradeNamesCAMO

this.parasite_defenseValueCAMO={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=4000,
  range={min=0,max=100000,increment=1000},
}
this.parasite_offenseGradeCAMO={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=2,
  range={min=0,max=100,},
}
this.parasite_defenseGradeCAMO={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=7,
  range={min=0,max=100,},
}
--
this.parasite_escapeDistanceARMOR={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=250,
  range={min=0,max=10000,},
}
this.parasite_escapeDistanceMIST={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=150,
  range={min=0,max=10000,},
}
this.parasite_escapeDistanceCAMO={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=250,
  range={min=0,max=10000,},
}

this.parasite_spawnRadiusARMOR={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=40,
  range={min=0,max=1000,},
}
this.parasite_spawnRadiusMIST={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=20,
  range={min=0,max=1000,},
}
--DEBUGNOW ADDLANG
--tex since camos start moving to route when activated, and closest cp may not be that discoverable
--or their positions even that good, spawn at player pos in a close enough radius that they spot player
--they'll then be aiming at player when they reach the cp
this.parasite_spawnRadiusCAMO={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=10,
  range={min=0,max=1000,},
}

this.parasite_timeOutARMOR={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=60,
  range={min=0,max=1000,},
}
this.parasite_timeOutMIST={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=60,
  range={min=0,max=1000,},
}
this.parasite_timeOutCAMO={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=60,
  range={min=0,max=1000,},
}
--DEBUGNOW ADDLANG -tex choose player pos as attack pos if closest lz or cp >
--tex player distance from parasite attack pos to call off attack
this.bossEvent_playerFocusRange={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=175,
  range={min=0,max=1000,},
}
--
this.parasite_zombieLife={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=300,
  range={min=0,max=10000,},
}
this.parasite_zombieStamina={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=200,
  range={min=0,max=10000,},
}
this.parasite_msfRate={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=10,
  range={min=0,max=100,},
}

IvarProc.MinMaxIvar(
  this,
  "parasite_msfCombatLevel",
  {
    default=0,
    OnChange=function(self,setting,prevSetting)
      IvarProc.PushMax(self,setting,prevSetting)
    end,
  },
  {
    default=9,
    OnChange=function(self,setting,prevSetting)
      IvarProc.PushMin(self,setting,prevSetting)
    end,
  },
  {
    range={min=0,max=9,increment=1},
  }
)

this.registerMenus={
  'bossEventMenu',
}

this.bossEventMenu={
  parentRefs={"InfGameEvent.eventsMenu"},
  options={
    "Ivars.bossEvent_enableFREE",
    "Ivars.parasite_enabledARMOR",
    "Ivars.parasite_enabledMIST",
    "Ivars.parasite_enabledCAMO",
    "Ivars.bossEvent_attackCountdownPeriod_MIN",
    "Ivars.bossEvent_attackCountdownPeriod_MAX",
    "Ivars.bossEvent_weather",
    "Ivars.parasite_zombieLife",
    "Ivars.parasite_zombieStamina",
    "Ivars.parasite_msfRate",
    "Ivars.parasite_msfCombatLevel_MIN",
    "Ivars.parasite_msfCombatLevel_MAX",
    "Ivars.bossEvent_playerFocusRange",
  },
}--bossEventMenu
local parasiteStr="parasite_"
local ivarsStr="Ivars."
for i,paramName in ipairs(parasiteParamNames)do
  local ivarName=parasiteStr..paramName
  table.insert(this.registerIvars,ivarName)
  table.insert(this.bossEventMenu.options,ivarsStr..ivarName)
end
for i,paramName in ipairs(parasiteGradeNames)do
  local ivarName=parasiteStr..paramName
  table.insert(this.registerIvars,ivarName)
  table.insert(this.bossEventMenu.options,ivarsStr..ivarName)
end
for i,paramName in ipairs(parasiteGradeNamesCAMO)do
  local ivarName=parasiteStr..paramName.."CAMO"
  table.insert(this.registerIvars,ivarName)
  table.insert(this.bossEventMenu.options,ivarsStr..ivarName)
end

for i,parasiteType in ipairs(parasiteTypes)do
  local ivarName=parasiteStr.."escapeDistance"..parasiteType
  table.insert(this.registerIvars,ivarName)
  table.insert(this.bossEventMenu.options,ivarsStr..ivarName)
end
for i,parasiteType in ipairs(parasiteTypes)do
  local ivarName=parasiteStr.."spawnRadius"..parasiteType
  table.insert(this.registerIvars,ivarName)
  table.insert(this.bossEventMenu.options,ivarsStr..ivarName)
end
for i,parasiteType in ipairs(parasiteTypes)do
  local ivarName=parasiteStr.."timeOut"..parasiteType
  table.insert(this.registerIvars,ivarName)
  table.insert(this.bossEventMenu.options,ivarsStr..ivarName)
end


local parasiteToggle=false
this.DEBUG_ToggleBossEvent=function()
  if not this.BossEventEnabled() then
    InfCore.Log("InfBossEvent InitEvent BossEventEnabled false",true)--DEBUG
    return
  end

  parasiteToggle=not parasiteToggle
  if parasiteToggle then
    InfCore.Log("DEBUG_ToggleBossEvent on",false,true)
    this.InitEvent()
    this.StartEventTimer(true)
  else
    InfCore.Log("DEBUG_ToggleBossEvent off",false,true)
    this.EndEvent()
  end
end--DEBUG_ToggleBossEvent
--< ivar defs


function this.PostAllModulesLoad()
  for bossSubType,moduleName in pairs(bossModuleNames)do
    this.bossModules[bossSubType]=_G[moduleName]
  end--for bossModuleNames
  if this.debugModule then
    InfCore.PrintInspect(this.bossModules,"InfBossEvent.bossModules")
  end
end--PostAllModulesLoaded

function this.PreModuleReload()
  local timers={
    "Timer_BossStartEvent",
    "Timer_BossAppear",
    "Timer_BossCombat",
    "Timer_BossEventMonitor",
    "Timer_BossUnrealize",
  }
  for i,timerName in ipairs(timers)do
    TimerStop(timerName)
  end
end

function this.OnLoad(nextMissionCode,currentMissionCode)
  if not this.BossEventEnabled(nextMissionCode) then
    return
  end

  if not TppMission.IsMissionStart() then
    return
  end

  this.ChooseBossTypes(nextMissionCode)
end--OnLoad

function this.AddMissionPacks(missionCode,packPaths)
  if not this.BossEventEnabled(missionCode)then
    return
  end

  --OFF script block WIP packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/parasite_scriptblock.fpk"
  local BossModule=this.bossModules[this.bossSubType]
  BossModule.AddPacks(missionCode,packPaths)

  if BossModule.eventParams[this.bossSubType].zombifies then
    for i,packagePath in ipairs(this.packages.ZOMBIE)do
      packPaths[#packPaths+1]=packagePath
    end
  end
end--AddMissionPacks

function this.MissionPrepare()
  if not this.BossEventEnabled() then
    return
  end

  --OFF script block WIP TppScriptBlock.RegisterCommonBlockPackList("parasite_block",this.packages)
end

function this.Init(missionTable)
  this.messageExecTable=nil

  if not this.BossEventEnabled() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnReload(missionTable)
  this.messageExecTable=nil

  if not this.BossEventEnabled() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.Messages()
  return Tpp.StrCode32Table{
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
      {msg="Finish",sender="Timer_BossStartEvent",func=this.Timer_BossStartEvent},
      {msg="Finish",sender="Timer_BossAppear",func=this.Timer_BossAppear},
      {msg="Finish",sender="Timer_BossCombat",func=this.Timer_BossCombat},
      {msg="Finish",sender="Timer_BossEventMonitor",func=this.Timer_BossEventMonitor},
      {msg="Finish",sender="Timer_BossUnrealize",func=this.Timer_BossUnrealize},
    },
    UI={
      {msg="EndFadeIn",sender="FadeInOnGameStart",func=this.FadeInOnGameStart},--fires on: most mission starts, on-foot free and story missions, not mb on-foot, but does mb heli start
    },
  }
end--Messages
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.OnMissionCanStart()
  if not this.BossEventEnabled() then
    return
  end

  this.InitEvent()
end

function this.FadeInOnGameStart()
  if not this.BossEventEnabled() then
    return
  end

  if Ivars.bossEvent_enableFREE:Is(0) then
    return
  end

    InfCore.Log"InfBossEvent mission start StartEventTimer"
    this.StartEventTimer()
end--FadeInOnGameStart

function this.BossEventEnabled(missionCode)
  local missionCode=missionCode or vars.missionCode
  if Ivars.bossEvent_enableFREE:Is(1) and (Ivars.bossEvent_enableFREE:MissionCheck(missionCode) or missionCode==30250) then
    return true
  end
  return false
end

function this.ChooseBossTypes(nextMissionCode)
--tex DEBUGNOW currently hinging on mission load AddPackages (or rather visa versa), 
  --ScriptBlock loading should free this up to be a per event setup thing

  InfMain.RandomSetToLevelSeed()

  local enabledTypes={
    ARMOR=Ivars.parasite_enabledARMOR:Is(1),
    MIST=Ivars.parasite_enabledMIST:Is(1),
    CAMO=Ivars.parasite_enabledCAMO:Is(1),
  }
  if this.debugModule then
    InfCore.Log("InfBossEvent.ChooseBossTypes")
    InfCore.PrintInspect(enabledTypes,"enabledTypes")
  end

  --tex WORKAROUND quiet battle, will crash with CAMO (which also use TppBossQuiet2)
  if TppPackList.GetLocationNameFormMissionCode(nextMissionCode)=="AFGH" and TppQuest.IsActive"waterway_q99010" then
    InfCore.Log("InfBossEvent.ChooseBossTypes - IsActive'waterway_q99010', disabling CAMO")--DEBUGNOW TODO triggering when I wouldnt have expected it to
    enabledTypes.CAMO=false
  end
  --tex WORKAROUND zoo currently has no routes for sniper
  if nextMissionCode==30150 then
    enabledTypes.CAMO=false
  end
  --tex WORKAROUND mb crashes on armor/mist
  if nextMissionCode==30050 then
    enabledTypes.ARMOR=false
    enabledTypes.MIST=false
  end

  local parasiteTypesEnabled={}

  local allDisabled=true
  for paraType,enabled in pairs(enabledTypes) do
    if enabled then
      table.insert(parasiteTypesEnabled,paraType)
      allDisabled=false
    end
  end

  if allDisabled then
    InfCore.Log("InfBossEvent.ChooseBossTypes allDisabled, adding ARMOR")
    table.insert(parasiteTypesEnabled,"ARMOR")
  end

  this.bossSubType=parasiteTypesEnabled[math.random(#parasiteTypesEnabled)]

  --DEBUGNOW stopgap
  for i,module in ipairs(this.bossModules)do
    if module.subtypes[this.bossSubType]then
      module.SetBossSubType(this.bossSubType)
    end
  end--for bossModules

  InfCore.Log("InfBossEvent.ChooseBossTypes parasiteType:"..this.bossSubType)

  InfMain.RandomResetToOsTime()
end--ChooseBossTypes

function this.OnDamage(gameId,attackId,attackerId)
  local typeIndex=GetTypeIndex(gameId)

  if typeIndex==GAME_OBJECT_TYPE_HOSTAGE2 then
    --tex dont block if parasite events off so player can always manually trigger event
    if vars.missionCode==30250 then
      this.OnDamageMbqfParasite(gameId,attackId,attackerId)
    end
    return
  end

  if not this.BossEventEnabled() then
    return
  end

  local attackerIndex=GetTypeIndex(attackerId)
  if typeIndex==GAME_OBJECT_TYPE_PLAYER2 then
    if this.isParasiteObjectType[attackerIndex] then
      this.lastContactTime=Time.GetRawElapsedTimeSinceStartUp()+timeOuts[this.bossSubType]
      this.SetArrayPos(svars.bossEvent_focusPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
    end
    return
  end

  if not this.isParasiteObjectType[typeIndex] then
    return
  end

  local BossModule=this.bossModules[this.bossSubType]
  local nameIndex=BossModule.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  if attackerIndex==GAME_OBJECT_TYPE_PLAYER2 then
    this.lastContactTime=Time.GetRawElapsedTimeSinceStartUp()+timeOuts[this.bossSubType]
    this.SetArrayPos(svars.bossEvent_focusPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
  end

  if typeIndex==GAME_OBJECT_TYPE_BOSSQUIET2 then
    if not this.BossEventEnabled() then
      return
    end
    this.OnDamageCamoParasite(nameIndex,gameId)
  end
end--OnDamage

local hostageParasites={
  "hos_wmu00_0000",
  "hos_wmu00_0001",
  "hos_wmu01_0000",
  "hos_wmu01_0001",
  "hos_wmu03_0000",
  "hos_wmu03_0001",
}
function this.OnDamageMbqfParasite(gameId,attackId,attackerId)
  if vars.missionCode~=30250 then
    return
  end
  --InfCore.DebugPrint"OnDamage"--DEBUG

  local isHostage=false
  for i,parasiteName in pairs(hostageParasites) do
    local parasiteHostage=GetGameObjectId(parasiteName)
    if gameId==parasiteHostage then
      isHostage=true
      break
    end
  end

  if isHostage then
    this.hostageParasiteHitCount=this.hostageParasiteHitCount+1
    InfCore.Log("hostageParasiteHitCount "..this.hostageParasiteHitCount,this.debugModule)--DEBUG

    if this.hostageParasiteHitCount>triggerAttackCount then
      this.hostageParasiteHitCount=0
      this.StartEventTimer(true)
    end
  end
end

function this.OnDamageCamoParasite(parasiteIndex,gameId)
  if svars.bossEvent_bossStates[parasiteIndex]==this.stateTypes.READY then
    this.hitCounts[parasiteIndex]=this.hitCounts[parasiteIndex]+1
    if this.hitCounts[parasiteIndex]>=camoShiftRouteAttackCount then
      this.hitCounts[parasiteIndex]=0
      this.SetCamoRoutes(this.routeBag,gameId)
    end
  end
end

function this.OnDying(gameId)
  --InfCore.PCall(function(gameId)--DEBUG
  local parasiteType=nil
  local typeIndex=GetTypeIndex(gameId)
  if not this.isParasiteObjectType[typeIndex] then
    return
  end
  if not this.BossEventEnabled() then
    return
  end

  local BossModule=this.bossModules[this.bossSubType]
  local nameIndex=BossModule.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  --KLUDGE DEBUGNOW don't know why OnDying keeps triggering repeatedly
  if svars.bossEvent_bossStates[nameIndex]==this.stateTypes.DOWNED then
    InfCore.Log"WARNING: InfBossEvent.OnDying state already ==DOWNED"
    return
  end

  svars.bossEvent_bossStates[nameIndex]=this.stateTypes.DOWNED

  if this.debugModule then
    InfCore.Log("OnDying is para",true)
  end
  --InfCore.PrintInspect(this.states,{varName="states"})--DEBUGNOW InspectVars

  local numCleared=this.GetNumCleared()
  if numCleared==this.numBosses then
    InfCore.Log("InfBossEvent OnDying: all eliminated")--DEBUG
    this.EndEvent()
  end
  --end,gameId)--
end--OnDamage

function this.OnFulton(gameId,gimmickInstance,gimmickDataSet,stafforResourceId)
  --InfCore.PCall(function(gameId)--DEBUG
  local typeIndex=GetTypeIndex(gameId)
  if not this.isParasiteObjectType[typeIndex] then
    return
  end
  if not this.BossEventEnabled() then
    return
  end

  local BossModule=this.bossModules[this.bossSubType]
  local nameIndex=BossModule.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  svars.bossEvent_bossStates[nameIndex]=this.stateTypes.FULTONED

  --InfCore.PrintInspect(this.states,{varName="states"})--DEBUGNOW

  local numCleared=this.GetNumCleared()
  if numCleared==this.numBosses then
    InfCore.Log("InfBossEvent OnFulton: all eliminated")--DEBUG
    this.EndEvent()
  end
  --end,gameId)--
end--OnFulton

function this.OnPlayerDamaged(playerIndex,attackId,attackerId)
  local typeIndex=GetTypeIndex(attackerId)
  if not this.isParasiteObjectType[typeIndex] then
    return
  end
  if not this.BossEventEnabled() then
    return
  end

  local BossModule=this.bossModules[this.bossSubType]
  local nameIndex=BossModule.gameIdToNameIndex[attackerId]
  if nameIndex==nil then
    return
  end

  this.lastContactTime=Time.GetRawElapsedTimeSinceStartUp()+timeOuts[this.bossSubType]
  this.SetArrayPos(svars.bossEvent_focusPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
end--OnPlayerDamaged

--OUT: this.gameIdToNameIndex
function this.InitEvent()
  --InfCore.PCall(function()--DEBUG
  if not this.BossEventEnabled() then
    InfCore.Log("InfBossEvent.InitEvent BossEventEnabled false")--DEBUG
    return
  end

  InfCore.Log("InfBossEvent.InitEvent")--DEBUG

  if TppMission.IsMissionStart() then
    this.ResetAttackCountdown()
  else
    this.CalculateAttackCountdown()
  end

  local BossModule=this.bossModules[this.bossSubType]
  BossModule.InitEvent()

  local bossNames=BossModule.bossObjectNames[this.bossSubType]
  this.numBosses=#bossNames
  for index=1,#bossNames do
    this.hitCounts[index]=0
  end


  this.hostageParasiteHitCount=0

  for i,parasiteType in ipairs(parasiteTypes)do
    local ivarName=parasiteStr.."escapeDistance"..parasiteType
    escapeDistances[parasiteType]=Ivars[ivarName]:Get()
  end
  for i,parasiteType in ipairs(parasiteTypes)do
    local ivarName=parasiteStr.."spawnRadius"..parasiteType
    spawnRadius[parasiteType]=Ivars[ivarName]:Get()
  end
  for i,parasiteType in ipairs(parasiteTypes)do
    local ivarName=parasiteStr.."timeOut"..parasiteType
    timeOuts[parasiteType]=Ivars[ivarName]:Get()
  end
  
  playerFocusRange=Ivars.bossEvent_playerFocusRange:Get()

  --distsqr
  playerFocusRangeSqr=playerFocusRange*playerFocusRange
  for paraType,escapeDistance in pairs(escapeDistances)do
    escapeDistancesSqr[paraType]=escapeDistance*escapeDistance
  end
  for paraType,radius in pairs(spawnRadius)do
    spawnRadiusSqr[paraType]=radius*radius
  end

  if this.debugModule then
    InfCore.PrintInspect(escapeDistancesSqr,"escapeDistances sqr")
  end
  --end)--
end--InitEvent
  
function this.StartEventTimer(startNow)
  --InfCore.PCall(function(time)--DEBUG
  if not this.BossEventEnabled() then
    return
  end

  if Ivars.bossEvent_enableFREE:Is(0) then
    return
  end

  --tex DEBUGNOW was this because one of the parasite types has trouble resetting them if they been killed?
  --VERIFY, if that is the issue then it may be overcome with scriptblock loader
  local numCleared=this.GetNumCleared()
  if numCleared==this.numBosses then
    InfCore.Log("StartEventTimer numCleared==numParasites aborting")
    this.EndEvent()
    return
  end

  if startNow then
    svars.bossEvent_attackCountdown=0
  end

  InfCore.Log("InfBossEvent.StartEventTimer svars.bossEvent_attackCountdown=="..tostring(svars.bossEvent_attackCountdown))

  local nextTimer=1--tex need a non 0 value I guess, Timer_BossStartEvent handles a short period of rnd for Timer_BossAppear, but it does fire weather immediately
  if svars.bossEvent_attackCountdown>0 then
    --tex via bossEvent_attackCountdown we only run the timer for some division (countdownSegmentMax) of the total time
    --so that on a reload it wont be postponed the full timespan
    --see CalculateAttackCountdown
    nextTimer=countDownInterval--module local

    InfCore.Log("Timer_BossStartEvent next countdown in "..nextTimer,this.debugModule)--DEBUG
  elseif startNow then
    InfCore.Log("Timer_BossStartEvent startNow in "..nextTimer,this.debugModule)--DEBUG
  else
    --tex TODO: anyway to differentiate between first start and continue?
    InfCore.Log("Timer_BossStartEvent start in "..nextTimer,this.debugModule)--DEBUG
  end

  --OFF script block WIP
  --tex fails due to invalid blockId. I can't figure out how fox assigns blockIds.
  --ScriptBlocks that aren't used for the current mission return invalid,
  --but as the scriptblock definitions are in the scriptblock fpk itself there's a chicken and egg problem if they're what is used to define the script block name.
  --  local success=TppScriptBlock.Load("parasite_block",this.parasiteType,true,true)--DEBUGNOW TODO only start once block loaded and active
  --  if not success then
  --    InfCore.Log("WARNING: InfBossEvent TppScriptBlock.Load returned false")--DEBUG
  --  end

  TimerStop("Timer_BossStartEvent")--tex may still be going from self start vs Timer_BossEventMonitor start
  TimerStart("Timer_BossStartEvent",nextTimer)
  --end,time)--
end--StartEventTimer
--Timer started by StartEventTimer
function this.Timer_BossStartEvent()
  InfCore.Log("InfBossEvent.Timer_BossStartEvent")

  --tex DEBUGNOW see comment in StartEventTimer 
  local numCleared=this.GetNumCleared()
  if numCleared==this.numBosses then
    InfCore.Log("StartEventTimer numCleared==numParasites aborting")
    this.EndEvent()
    return
  end

  --tex timer period is only part of the whole event start period, and it restarts timer with increasingly shorter periods
  --which gives a rough way to prevent the start event being postponed for the full perion on reload
  if svars.bossEvent_attackCountdown>0 then
    svars.bossEvent_attackCountdown=svars.bossEvent_attackCountdown-1
    InfCore.Log("InfBossEvent.Timer_BossStartEvent svars.bossEvent_attackCountdown: "..tostring(svars.bossEvent_attackCountdown))
    this.StartEventTimer()
    return
  end

  --tex actually start
  --tex need some leeway between wather start and boss apread
  this.StartEventWeather()
  local parasiteAppearTime=math.random(bossAppearTimeMin,bossAppearTimeMax)
  TimerStart("Timer_BossAppear",parasiteAppearTime)
end--Timer_BossStartEvent
--Timer started by above, and Timer_BossEventMonitor
function this.Timer_BossAppear()
  InfCore.PCallDebug(function()--DEBUG
    InfCore.LogFlow("InfBossEvent ParasiteAppear")
    local playerPos={vars.playerPosX,vars.playerPosY,vars.playerPosZ}
    local closestCpPos=playerPos
    local closestCpDist=999999999999999

    local isMb=vars.missionCode==30050 or vars.missionCode==30250
    local noCps=false

    local closestCp,cpDistance,cpPosition

    if noCps then
      InfCore.Log("InfBossEvent.ParasiteAppear noCps")
      closestCpPos=playerPos
    else
      closestCp,cpDistance,cpPosition=InfMain.GetClosestCp(playerPos)
      if closestCp==nil or cpPosition==nil then
        InfCore.Log("WARNING: InfBossEvent ParasiteAppear closestCp==nil")--DEBUG
        closestCpPos=playerPos
      else
        closestCpDist=cpDistance

        if not isMb then--tex TODO: implement for mb
          local closestLz,lzDistance,lzPosition=InfLZ.GetClosestLz(playerPos)
          if closestLz==nil or lzPosition==nil then
            InfCore.Log("WARNING: InfBossEvent.Timer_BossAppear closestLz==nil")--DEBUG
          else
            local lzCpDist=TppMath.FindDistance(lzPosition,cpPosition)
            closestCpPos=cpPosition
            if cpDistance>lzDistance and lzCpDist>playerFocusRangeSqr*2 then--tex TODO what was my reasoning here?
              closestCpPos=lzPosition
              closestCpDist=lzDistance
            end
          end--if closestLz
        end--if no isMb

        if closestCpDist>playerFocusRangeSqr then
          closestCpPos=playerPos
        end
      end--if closestCp
    end--if not noCps

    InfCore.Log("ParasiteAppear "..this.bossSubType.." closestCp:"..tostring(closestCp),this.debugModule)

    this.lastContactTime=Time.GetRawElapsedTimeSinceStartUp()+timeOuts[this.bossSubType]
    InfCore.Log("InfBossEvent.Timer_BossAppear: lastContactTime:"..this.lastContactTime)

    --tex anywhere but playerPos needs more consideration to how discoverable the bosses are
    --CAMO will start heading to cp anyway because they rely on the routes, 
    --so its more important that they start where player will notice
    local appearPos=playerPos
    this.SetArrayPos(svars.bossEvent_focusPos,appearPos)
    local BossModule=this.bossModules[this.bossSubType]
    BossModule.Appear(appearPos,closestCp,closestCpPos,spawnRadius[this.bossSubType])

    if BossModule.eventParams[this.bossSubType].zombifies then
      if isMb then
        this.ZombifyMB()
      else
        this.ZombifyFree(closestCp,closestCpPos)
      end
    end

    --tex WORKAROUND once one armor parasite has been fultoned the rest will be stuck in some kind of idle ai state on next appearance
    --forcing combat bypasses this TODO VERIFY again
    local armorFultoned=false
    for index=1,this.numBosses do
      local state=svars.bossEvent_bossStates[index]
      if state==this.stateTypes.FULTONED then
        armorFultoned=true
      end
    end
    if armorFultoned and this.bossSubType=="ARMOR" then
      --InfCore.Log("Timer_BossCombat start",true)--DEBUG
      TimerStart("Timer_BossCombat",4)
    end

    TimerStart("Timer_BossEventMonitor",monitorRate)
  end)--
end--Timer_BossAppear

--tex TODO: is ForceRequestWeather saved?
function this.StartEventWeather()
  --GOTCHA: for some reason always seems to fire parasite effect if this table is defined local to module/at module load time, even though inspecting fogType it seems fine? VERIFY
  local weatherTypes={
    {weatherType=TppDefine.WEATHER.FOGGY,fogInfo={fogDensity=0.15,fogType=WeatherManager.FOG_TYPE_PARASITE}},
    {weatherType=TppDefine.WEATHER.RAINY,fogInfo=nil},
    --{weatherType=TppDefine.WEATHER.SANDSTORM,fogInfo=nil},--tex too difficult to discover non playerpos appearances
    {weatherType=TppDefine.WEATHER.FOGGY,fogInfo={fogDensity=0.15,fogType=WeatherManager.FOG_TYPE_NORMAL}},
  }

  local weatherInfo
  if Ivars.bossEvent_weather:Is"PARASITE_FOG" then
    weatherInfo=weatherTypes[1]
  elseif Ivars.bossEvent_weather:Is"RANDOM" then
    weatherInfo=weatherTypes[math.random(#weatherTypes)]
  end

  if weatherInfo then
    if weatherInfo.fogInfo then
      weatherInfo.fogInfo.fogDensity=math.random(0.001,0.9)
    end

    TppWeather.ForceRequestWeather(weatherInfo.weatherType,4,weatherInfo.fogInfo)
  end
end--StartEventWeather

function this.ZombifyMB(disableDamage)
  local cpZombieLife=Ivars.parasite_zombieLife:Get()
  local cpZombieStamina=Ivars.parasite_zombieStamina:Get()
  local msfRate=Ivars.parasite_msfRate:Get()
  local msfLevel=math.random(Ivars.parasite_msfCombatLevel_MIN:Get(),Ivars.parasite_msfCombatLevel_MAX:Get())
  for cpName,cpDefine in pairs(mvars.ene_soldierDefine)do
    for i,soldierName in ipairs(cpDefine)do
      local soldierId=GetGameObjectId("TppSoldier2",soldierName)
      if soldierId~=NULL_ID then
        local isMsf=math.random(100)<msfRate
        this.SetZombie(cpDefine[i],disableDamage,isHalf,cpZombieLife,cpZombieStamina,isMsf,msfLevel)

        --tex GOTCHA setfriendlycp seems to be one-way only
        local command={id="SetFriendly",enabled=false}
        SendCommand(soldierId,command)
      end
    end
  end
end

local SetZombies=function(soldierNames,position,radius)
  local cpZombieLife=Ivars.parasite_zombieLife:Get()
  local cpZombieStamina=Ivars.parasite_zombieStamina:Get()
  local msfRate=Ivars.parasite_msfRate:Get()
  local msfLevel=math.random(Ivars.parasite_msfCombatLevel_MIN:Get(),Ivars.parasite_msfCombatLevel_MAX:Get())
  for i,soldierName in ipairs(soldierNames) do
    local gameId=GetGameObjectId("TppSoldier2",soldierName)
    if gameId~=NULL_ID then
      local soldierPosition=SendCommand(gameId,{id="GetPosition"})
      local soldierDistance=0
      if position then
        soldierDistance=TppMath.FindDistance({soldierPosition:GetX(),soldierPosition:GetY(),soldierPosition:GetZ()},position)
      end
      if not position or (radius and soldierDistance<radius) then
        --InfCore.Log(soldierName.." close to "..closestCp.. ", zombifying",true)--DEBUG
        local isMsf=math.random(100)<msfRate
        this.SetZombie(soldierName,disableDamage,isHalf,cpZombieLife,cpZombieStamina,isMsf,msfLevel)
      end
    end
  end
end

function this.ZombifyFree(closestCp,position)
  local radius=escapeDistancesSqr[this.bossSubType]

  --tex soldiers of closestCp
  if closestCp then
    local cpDefine=mvars.ene_soldierDefine[closestCp]
    if cpDefine==nil then
      InfCore.Log("WARNING InfBossEvent StartEvent could not find cpdefine for "..closestCp)--DEBUG
    else
      SetZombies(cpDefine)
    end
  end

  --tex IH free roam foot lrrps
  if InfMainTpp.lrrpDefines then
    for cpName,lrrpDefine in pairs(InfMainTpp.lrrpDefines) do
      if lrrpDefine.base1==closestCp or lrrpDefine.base2==closestCp then
        SetZombies(lrrpDefine.cpDefine,position,radius)
      end
    end
  end

  --tex TODO doesn't cover vehicle lrrp

  if mvars.ene_soldierDefine and mvars.ene_soldierDefine.quest_cp then
    SetZombies(mvars.ene_soldierDefine.quest_cp,position,radius)
  end
end

--Started by Timer_BossAppear soley as a workaround
function this.Timer_BossCombat()
  SendCommand({type="TppParasite2"},{id="StartCombat"})
end

--localopt
local monitorPlayerPos={}
local monitorFocusPos={}
local monitorParasitePos={}
function this.Timer_BossEventMonitor()
  --  InfCore.PCall(function()--DEBUG
  --InfCore.Log("MonitorEvent",true)
  if svars.bossEvent_attackCountdown>0 then
    return
  end

  local outOfRange=false
  this.SetArrayPos(monitorPlayerPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
  this.SetArrayPos(monitorFocusPos,svars.bossEvent_focusPos)
  local focusPosDistSqr=TppMath.FindDistance(monitorPlayerPos,monitorFocusPos)
  local escapeDistanceSqr=escapeDistancesSqr[this.bossSubType]
  if escapeDistanceSqr>0 and focusPosDistSqr>escapeDistanceSqr then
    outOfRange=true
  end

  local outOfContactTime=this.lastContactTime<Time.GetRawElapsedTimeSinceStartUp() --tex GOTCHA: DEBUGNOW lastContactTime actually outOfContactTimer or something, since its set like a game timer as GetRawElapsedTimeSinceStartUp+timeout

  if this.debugModule then
    local elapsedTime=Time.GetRawElapsedTimeSinceStartUp()
    InfCore.Log("InfBossEvent.Timer_BossEventMonitor "..this.bossSubType.. " escapeDistanceSqr:"..escapeDistanceSqr.." focusPosDistSqr:"..focusPosDistSqr)--DEBUG
    InfCore.PrintInspect(monitorFocusPos,"focusPos")
    InfCore.PrintInspect(monitorPlayerPos,"playerPos")
    InfCore.Log("lastContactTime: "..tostring(this.lastContactTime).." timeSinceStartup: "..elapsedTime)
    InfCore.Log("outOfRange:"..tostring(outOfRange).." outOfContactTime:"..tostring(outOfContactTime))--DEBUG
    InfCore.DebugPrint("escapeDistance:"..escapeDistanceSqr.." focusPosDist:"..focusPosDistSqr.." lastContact: "..tostring(this.lastContactTime).." elapsedTime: "..elapsedTime)
  end
  
  --tex GOTCHA: TppParasites aparently dont support GetPosition, frustrating inconsistancy, you'd figure it would be a function of all gameobjects
  local bossObjectType=this.bossObjectTypes[this.bossSubType]
  local BossModule=this.bossModules[this.bossSubType]
  local bossNames=BossModule.bossObjectNames[this.bossSubType]
  for index,parasiteName in pairs(bossNames) do
    if svars.bossEvent_bossStates[index]==this.stateTypes.READY then
      local gameId=GetGameObjectId(bossObjectType,parasiteName)
      if gameId~=NULL_ID then
        local parasitePos=SendCommand(gameId,{id="GetPosition"})
        if parasitePos==nil then
          break--tex this type doesnt support GetPosition DEBUGNOW revisit if you expand bossObjectTypes
        end
        this.SetArrayPos(monitorParasitePos,parasitePos:GetX(),parasitePos:GetY(),parasitePos:GetZ())
        local distSqr=TppMath.FindDistance(monitorPlayerPos,monitorParasitePos)
        InfCore.Log("EventMonitor: "..parasiteName.." dist:"..math.sqrt(distSqr),this.debugModule)--DEBUG
        if distSqr<escapeDistanceSqr then
          outOfRange=false
          break
        end
      end--if gameId
    end--if stateTypes.READY
  end--for bossObjectNames
  
  --tex I think my original reasoning here for only mist and not armor was that 'mist is chasing you'
  --DEBUGNOW but since TppParasite2 doesnt have GetPosition it might be a bit weird in situations where ARMOR are still right near you
  --since you just nead to get out of focusPos range (their appear pos, or last contact pos) so I might have to add them too
  if this.bossSubType=="MIST" then
    if focusPosDistSqr>playerFocusRangeSqr then
      InfCore.Log("EventMonitor: > playerFocusRangeSqr",this.debugModule)
      if not outOfContactTime then
        InfCore.Log("EventMonitor: not outOfContactTime, starting combat",this.debugModule)
        --SendCommand({type="TppParasite2"},{id="StartCombat"})
        this.SetArrayPos(svars.bossEvent_focusPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
        local parasiteAppearTime=math.random(1,2)
        TimerStart("Timer_BossAppear",parasiteAppearTime)
        outOfRange=false
      end
    end
  end

  if outOfRange and outOfContactTime then
    InfCore.Log("EventMonitor: out of range and outOfContactTime :"..math.sqrt(focusPosDistSqr).."> "..math.sqrt(escapeDistanceSqr).. ", ending event",this.debugModule)
    this.EndEvent()
    this.StartEventTimer()--tex start event countdown again (EndEvent resets bossEvent_attackCountdown)
  else
    TimerStart("Timer_BossEventMonitor",monitorRate)--tex start self again
  end
  --end)--
end--Timer_BossEventMonitor

function this.EndEvent()
  InfCore.Log("InfBossEvent EndEvent",this.debugModule)

  TppWeather.CancelForceRequestWeather(TppDefine.WEATHER.SUNNY,7)

  if this.bossSubType=="CAMO"then
    SendCommand({type="TppBossQuiet2"},{id="SetWithdrawal",enabled=true})
  else
    SendCommand({type="TppParasite2"},{id="StartWithdrawal"})
  end

  --tex TODO throw CAMO parasites to some far route (or warprequest if it doesn't immediately vanish them) then Off them after a while

  TimerStop("Timer_BossEventMonitor")

  TimerStart("Timer_BossUnrealize",6)
  
  this.ResetAttackCountdown()--tex reset in case we want to restart
end--EndEvent 

--OUT: attackCountdownTimespan
function this.CalculateAttackCountdown()
  local min=Ivars.bossEvent_attackCountdownPeriod_MIN:Get()
  local max=Ivars.bossEvent_attackCountdownPeriod_MAX:Get()
  attackCountdownTimespan=math.random(min,max)

  InfCore.Log("InfBossEvent.CalculateAttackCountdown: attackCountdownTotal: "..attackCountdownTimespan)
end--CalculateAttackCountdown
--OUT: attackCountdownTimespan
--OUT: svars.bossEvent_attackCountdown
function this.ResetAttackCountdown()
  this.CalculateAttackCountdown()

  svars.bossEvent_attackCountdown=attackCountdownTimespan
end--ResetAttackCountdown

function this.Timer_BossUnrealize()
  local BossModule=this.bossModules[this.bossSubType]
  local bossNames=BossModule.bossObjectNames[this.bossSubType]
  if this.bossSubType=="CAMO" then
    for index,parasiteName in ipairs(bossNames) do
      if svars.bossEvent_bossStates[index]==this.stateTypes.READY then--tex can leave behind non fultoned
        this.DisableTppBossQuiet2(parasiteName)
      end
    end
  else
    --tex possibly not nessesary for ARMOR parasites, but MIST parasites have a bug where they'll
    --withdraw to wherever the withdraw postion is but keep making the warp noise constantly.
    for index,parasiteName in ipairs(bossNames) do
      if svars.bossEvent_bossStates[index]==this.stateTypes.READY then
        this.DisableTppParasite2(parasiteName)
      end
    end
  end
end

function this.GetNumCleared()
  local numCleared=0
  for index=1,this.numBosses do
    local state=svars.bossEvent_bossStates[index]
    if state~=this.stateTypes.READY then
      numCleared=numCleared+1
    end
  end
  return numCleared
end

function this.SetZombie(gameObjectName,disableDamage,isHalf,life,stamina,isMsf,msfLevel)
  isHalf=isHalf or false
  local gameObjectId=GetGameObjectId("TppSoldier2",gameObjectName)
  SendCommand(gameObjectId,{id="SetZombie",enabled=true,isHalf=isHalf,isZombieSkin=true,isHagure=true,isMsf=isMsf})
  SendCommand(gameObjectId,{id="SetMaxLife",life=life,stamina=stamina})
  SendCommand(gameObjectId,{id="SetZombieUseRoute",enabled=false})
  if disableDamage==true then
    SendCommand(gameObjectId,{id="SetDisableDamage",life=false,faint=true,sleep=true})
  end
  if isHalf then
    local ignoreFlag=0
    SendCommand(gameObjectId,{id="SetIgnoreDamageAction",flag=ignoreFlag})
  end
  if msfLevel~=nil then
    SendCommand(gameObjectId,{id="SetMsfCombatLevel",level=msfLevel})
  end
end

--util
--OUT: indexTable
function this.BuildGameIdToNameIndex(names,indexTable)
  for index,name in ipairs(names)do
    local gameId=GetGameObjectId(name)
    if gameId==NULL_ID then
      InfCore.Log("ERROR: InfBossEvent.BuildGameIdToNameIndex: gameId==NULL_ID for "..tostring(name))
    else
      indexTable[gameId]=index
    end
  end--for bossObjectNames
  if this.debugModule then
    InfCore.PrintInspect(indexTable,"indexTable")
  end
end--BuildGameIdToNameIndex

function this.GetIndexFrom1(array)
  if array[0]~=nil then
    return -1
  end
  return 0
end--GetIndexFrom1
--tex handles 0 or 1 based vec arrays
--works on scriptvars since its using indexing
--OUT:toArray
function this.SetArrayPos(toArray,xOrPos,Y,Z)
  local x,y,z=xOrPos,Y,Z--tex avoid unnessesary new table
  if type(xOrPos)=='table'then
    local fromIndexShift=this.GetIndexFrom1(xOrPos)
    x=xOrPos[1+fromIndexShift]
    y=xOrPos[2+fromIndexShift]
    z=xOrPos[3+fromIndexShift]
  end

  local toIndexShift=this.GetIndexFrom1(toArray)
  toArray[1+toIndexShift]=x
  toArray[2+toIndexShift]=y
  toArray[3+toIndexShift]=z
end--SetArrayPos

function this.PointOnCircle(origin,radius,angle)
  local x=origin[1]+radius*math.cos(math.rad(angle))
  local y=origin[3]+radius*math.sin(math.rad(angle))
  return {x,origin[2],y}
end

this.langStrings={
  eng={
    bossEventMenu="Skulls event menu",
    bossEvent_enableFREE="Enable Skull attacks in Free roam",
    bossEvent_attackCountdownPeriod_MIN="Skull attack min (minutes)",
    bossEvent_attackCountdownPeriod_MAX="Skull attack max (minutes)",
    bossEvent_weather="Weather on Skull attack",
    bossEvent_weatherSettings={"None","Parasite fog","Random"},
    parasite_enabledARMOR="Allow armor skulls",
    parasite_enabledMIST="Allow mist skulls",
    parasite_enabledCAMO="Allow sniper skulls",
  },
  help={
    eng={
      bossEvent_enableFREE="Skulls attack at a random time (in minutes) between Skull attack min and Skull attack max settings.",
      parasite_msfRate="Percentage chance a zombified soldier will have msf zombie behaviour",
    },
  }
}

return this
