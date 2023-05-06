-- InfBossEvent.lua
-- tex implements parasite/skulls unit event
--TODO: expose  parasiteAppearTimeMin, parasiteAppearTimeMax
--[[
Progression:
StartEventTimer 
  on FadeInOnGameStart, or some other means
  start Timer_BossStartEvent on bossEvent_eventPeriod (_MIN,_MAX)
  or on continue period if event already started (bossEvent_isActive)
Timer_BossStartEvent 
  start Timer_BossStartEvent (itself, via StartEventTimer)
  start Timer_BossAppear
Timer_BossAppear
  start Timer_BossEventMonitor
Timer_BossEventMonitor
  start Timer_BossEventMonitor (itself)
  end on event end
--]]

--DEBUGNOW problem with this setup:
--when player reloads (may die, may just want to retry something)
--then Timer_BossStartEvent will restart with full time period (its current time + whatever)
--solution: shift to clock message
--downside must be within 24 hour period
--user must figure how long work clock is to set period

--lastContactTime is in terms of GetRawElapsedTimeSinceStartUp and not adjusted for reload from checkpoint (from menu or from session restart)

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
  ARMOR={
    "/Assets/tpp/pack/mission2/ih/snd_zmb.fpk",
    "/Assets/tpp/pack/mission2/online/o50050/o50055_parasite_metal.fpk",
  --OFF script block WIP "/Assets/tpp/pack/mission2/ih/parasite_scriptblock.fpk",
  },
  MIST={
    "/Assets/tpp/pack/mission2/ih/snd_zmb.fpk",
    "/Assets/tpp/pack/mission2/ih/ih_parasite_mist.fpk",
  --OFF script block WIP "/Assets/tpp/pack/mission2/ih/parasite_scriptblock.fpk",
  },
  CAMO={
    "/Assets/tpp/pack/mission2/ih/snd_zmb.fpk",
    "/Assets/tpp/pack/mission2/ih/ih_parasite_camo.fpk",
  --OFF script block WIP "/Assets/tpp/pack/mission2/ih/parasite_scriptblock.fpk",
  },
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
  CAMO={
    "wmu_camo_ih_0000",
    "wmu_camo_ih_0001",
    "wmu_camo_ih_0002",
    "wmu_camo_ih_0003",
  },
}

--TODO: check to see if other objects support GetPosition (see Timer_BossEventMonitor)
this.bossObjectTypes={
  ARMOR="TppParasite2",
  MIST="TppParasite2",
  CAMO="TppBossQuiet2",
}

local disableFight=false--DEBUG

--STATE


this.parasiteType="ARMOR"

--tex indexed by parasiteNames
this.hitCounts={}
this.lastContactTime=0

--tex for current event
this.numParasites=0

this.routeBag=nil

this.hostageParasiteHitCount=0--tex mbqf hostage parasites

this.MAX_BOSSES_PER_TYPE=4--LIMIT, tex would also have to bump, or set parasiteSquadMarkerFlag size (and test that actually does anything)

function this.DeclareSVars()
  if not this.BossEventEnabled() then
    return{}
  end
  local saveVarsList = {
    bossEvent_isActive=false,--tex TODO maybe change to bossEvent_state enum for state none,waitstart,active
    bossEvent_bossStates={name="bossEvent_bossStates",type=TppScriptVars.TYPE_INT8,arraySize=InfBossEvent.MAX_BOSSES_PER_TYPE,value=InfBossEvent.stateTypes.READY,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},
    bossEvent_focusPos={name="bossEvent_focusPos",type=TppScriptVars.TYPE_FLOAT,arraySize=3,value=0,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},
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
  this.numParasites=prevModule.numParasites
  
  this.routeBag=prevModule.routeBag
  
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

--REF CULL
--SetParameters
--local PARASITE_PARAMETERS={
--  EASY={--10020
--    sightDistance = 20,
--    sightVertical = 36.0,
--    sightHorizontal = 48.0,
--  },
--
--  --ARMOR
--  --o50050_enemy
--  HARD = {
--    sightDistance = 30,
--    sightVertical = 55.0,
--    sightHorizontal = 48.0,
--  },
--
--
--  --10090
--  NORMAL = {
--    sightDistance                 = 25,
--    sightDistanceCombat           = 75,
--    sightVertical                 = 40,
--    sightHorizontal               = 60,
--    noiseRate                     = 8,
--    avoidSideMin                  = 8,
--    avoidSideMax                  = 12,
--    areaCombatBattleRange         = 50,
--    areaCombatBattleToSearchTime  = 1,
--    areaCombatLostSearchRange     = 1000,
--    areaCombatLostToGuardTime     = 120,
--    --areaCombatGuardDistance
--    throwRecastTime               = 10,
--  },
--  --10090
--  EXTREME={
--    sightDistance                 = 25,
--    sightDistanceCombat           = 100,
--    sightVertical                 = 60,
--    sightHorizontal               = 100,
--    noiseRate                     = 10,
--    avoidSideMin                  = 8,
--    avoidSideMax                  = 12,
--    areaCombatBattleRange         = 50,
--    areaCombatBattleToSearchTime  = 1,
--    areaCombatLostSearchRange     = 1000,
--    areaCombatLostToGuardTime     = 60,
--    --areaCombatGuardDistance
--    throwRecastTime               = 10,
--  },
--}--PARASITE_PARAMETERS
--
----SetCombatGrade
----o50050_enemy
--local PARASITE_GRADE={
--  NORMAL={
--    --DEBUGNOW where did I get these values from, did I log fob?
--    defenseValueMain=4000,
--    defenseValueArmor=7000,
--    defenseValueWall=8000,
--    offenseGrade=2,
--    defenseGrade=7,
--  },
--  HARD={
--    defenseValueMain=4000,
--    defenseValueArmor=8400,
--    defenseValueWall=9600,
--    offenseGrade=5,
--    defenseGrade=7,
--  },
--}
--
----SetCombatGrade
--local PARASITE_GRADE_CAMO={
--  defenseValue=4000,
--  offenseGrade=2,
--  defenseGrade=7,
--}
local parasiteTypes={
  "ARMOR",
  "MIST",
  "CAMO",
}

--seconds
local monitorRate=10
local bossAppearTimeMin=5
local bossAppearTimeMax=10

local playerFocusRange=175--tex choose player pos as bossFocusPos if closest lz or cp > than this (otherwise whichever is closest of those)
--tex player distance from parasite attack pos to call off attack
local escapeDistances={
  ARMOR=250,
  MIST=0,
  CAMO=250,
}

local spawnRadius={
  ARMOR=40,
  MIST=20,
  --tex since camos start moving to route when activated, and closest cp may not be that discoverable
  --or their positions even that good, spawn at player pos in a close enough radius that they spot player
  --they'll then be aiming at player when they reach the cp
  --TODO: alternatively try triggering StartCombat on camo spawn
  CAMO=10,
}

local timeOuts={
  ARMOR=0,
  MIST=1*60,
  CAMO=0,
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
IvarProc.MinMaxIvar(
  this,
  "bossEvent_eventPeriod",
  {
    default=10,
    OnChange=function(self,setting,prevSetting)
      IvarProc.PushMax(self,setting,prevSetting)
      InfBossEvent.StartEventTimer()
    end,
  },
  {
    default=30,
    OnChange=function(self,setting,prevSetting)
      IvarProc.PushMin(self,setting,prevSetting)
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
  default=0,
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
  default=0,
  range={min=0,max=1000,},
}
this.parasite_timeOutMIST={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=60,
  range={min=0,max=1000,},
}
this.parasite_timeOutCAMO={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0,
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
    "Ivars.bossEvent_eventPeriod_MIN",
    "Ivars.bossEvent_eventPeriod_MAX",
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
    this.StartEventTimer(1)
  else
    InfCore.Log("DEBUG_ToggleBossEvent off",false,true)
    this.EndEvent()
  end
end--DEBUG_ToggleBossEvent
--< ivar defs

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

  InfMain.RandomSetToLevelSeed()

  local enabledTypes={
    ARMOR=Ivars.parasite_enabledARMOR:Is(1),
    MIST=Ivars.parasite_enabledMIST:Is(1),
    CAMO=Ivars.parasite_enabledCAMO:Is(1),
  }
  if this.debugModule then
    InfCore.Log("InfBossEvent.OnLoad")
    InfCore.PrintInspect(enabledTypes,"enabledTypes")
  end

  --tex WORKAROUND quiet battle, will crash with CAMO (which also use TppBossQuiet2)
  if TppPackList.GetLocationNameFormMissionCode(nextMissionCode)=="AFGH" and TppQuest.IsActive"waterway_q99010" then
    InfCore.Log("InfBossEvent.Onload - IsActive'waterway_q99010', disabling CAMO")--DEBUGNOW TODO triggering when I wouldnt have expected it to
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
    InfCore.Log("InfBossEvent.OnLoad allDisabled, adding ARMOR")
    table.insert(parasiteTypesEnabled,"ARMOR")
  end

  this.parasiteType=parasiteTypesEnabled[math.random(#parasiteTypesEnabled)]

  --tex DEBUG
  --TODO force type via ivar
  --this.parasiteType="MIST"
  --this.parasiteType="ARMOR"
  --this.parasiteType="CAMO"

  InfCore.Log("OnLoad parasiteType:"..this.parasiteType)

  InfMain.RandomResetToOsTime()
end--OnLoad

function this.AddMissionPacks(missionCode,packPaths)
  if not this.BossEventEnabled(missionCode)then
    return
  end

  --OFF script block WIP packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/parasite_scriptblock.fpk"
  for i,packagePath in ipairs(this.packages[this.parasiteType])do
    packPaths[#packPaths+1]=packagePath
  end
end

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
    },
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
end
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

  --tex svar, so it must be a reload from checkpoint (otherwise it would have been initialized to false)
  if svars.bossEvent_isActive then
    --tex cant rely on boss gameobjects being set up for checkpoints as they are pretty heavily managed in the vanilla missions they appear
    --so they need to essentially go through startup again
    --tex GOTCHA: in theory player could break this by passing through checkpoint and then restarting withing the 5-10 second period in which this is set again
    svars.bossEvent_isActive=false

    InfCore.Log"InfBossEvent mission start ContinueEvent"
    local continueTime=math.random(bossAppearTimeMin,bossAppearTimeMax)
    this.StartEventTimer(continueTime)
  else
    InfCore.Log"InfBossEvent mission start StartEventTimer"
    this.StartEventTimer()
  end
end--FadeInOnGameStart

function this.BossEventEnabled(missionCode)
  local missionCode=missionCode or vars.missionCode
  if Ivars.bossEvent_enableFREE:Is(1) and (Ivars.bossEvent_enableFREE:MissionCheck(missionCode) or missionCode==30250) then
    return true
  end
  return false
end

function this.SetupParasites()
  InfCore.LogFlow("InfBossEvent.SetupParasites")

  local skullTypes={"TppBossQuiet2","TppParasite2"}
  for n,skullType in ipairs(skullTypes)do
    if GameObject.DoesGameObjectExistWithTypeName(skullType)then
      SendCommand({type=skullType},{id="SetFultonEnabled",enabled=true})
    end
  end

  if this.parasiteType=="CAMO" then
    local combatGradeCommand={id="SetCombatGrade",}
    for i,paramName in ipairs(parasiteGradeNamesCAMO)do
      local ivarName=parasiteStr..paramName.."CAMO"
      combatGradeCommand[paramName]=Ivars[ivarName]:Get()
    end
    SendCommand({type="TppBossQuiet2"},combatGradeCommand)
    if this.debugModule then
      InfCore.PrintInspect(combatGradeCommand,"SetCombatGrade")
    end
  else
    local parameters={}
    for i,paramName in ipairs(parasiteParamNames)do
      local ivarName=parasiteStr..paramName
      parameters[paramName]=Ivars[ivarName]:Get()
    end
    SendCommand({type="TppParasite2"},{id="SetParameters",params=parameters})

    local combatGradeCommand={id="SetCombatGrade",}
    for i,paramName in ipairs(parasiteGradeNames)do
      local ivarName=parasiteStr..paramName
      combatGradeCommand[paramName]=Ivars[ivarName]:Get()
    end
    SendCommand({type="TppParasite2"},combatGradeCommand)

    if this.debugModule then
      InfCore.PrintInspect(parameters,"SetParameters")
      InfCore.PrintInspect(combatGradeCommand,"SetCombatGrade")
    end
  end
end--SetupParasites

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
      this.lastContactTime=Time.GetRawElapsedTimeSinceStartUp()+timeOuts[this.parasiteType]
      this.SetArrayPos(svars.bossEvent_focusPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
    end
    return
  end

  if not this.isParasiteObjectType[typeIndex] then
    return
  end

  local parasiteIndex=0
  for index,parasiteName in ipairs(this.bossObjectNames[this.parasiteType]) do
    local parasiteId=GetGameObjectId(parasiteName)
    if parasiteId~=nil and parasiteId==gameId then
      parasiteIndex=index
      break
    end
  end
  if parasiteIndex==0 then
    return
  end

  if attackerIndex==GAME_OBJECT_TYPE_PLAYER2 then
    this.lastContactTime=Time.GetRawElapsedTimeSinceStartUp()+timeOuts[this.parasiteType]
    this.SetArrayPos(svars.bossEvent_focusPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
  end

  if typeIndex==GAME_OBJECT_TYPE_BOSSQUIET2 then
    if not this.BossEventEnabled() then
      return
    end
    this.OnDamageCamoParasite(parasiteIndex,gameId)
  end
end

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
      this.StartEventTimer(1)
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

  local parasiteIndex=0
  for index,parasiteName in ipairs(this.bossObjectNames[this.parasiteType]) do
    local parasiteId=GetGameObjectId(parasiteName)
    if parasiteId~=nil and parasiteId==gameId then
      parasiteIndex=index
      break
    end
  end
  if parasiteIndex==0 then
    return
  end

  --KLUDGE DEBUGNOW don't know why OnDying keeps triggering repeatedly
  if svars.bossEvent_bossStates[parasiteIndex]==this.stateTypes.DOWNED then
    InfCore.Log"WARNING: InfBossEvent.OnDying state already ==DOWNED"
    return
  end

  svars.bossEvent_bossStates[parasiteIndex]=this.stateTypes.DOWNED

  if this.debugModule then
    InfCore.Log("OnDying is para",true)
  end
  --InfCore.PrintInspect(this.states,{varName="states"})--DEBUGNOW InspectVars

  local numCleared=this.GetNumCleared()
  if numCleared==this.numParasites then
    InfCore.Log("InfBossEvent OnDying: all eliminated")--DEBUG
    this.EndEvent()
  end
  --end,gameId)--
end

function this.OnFulton(gameId,gimmickInstance,gimmickDataSet,stafforResourceId)
  --InfCore.PCall(function(gameId)--DEBUG
  local typeIndex=GetTypeIndex(gameId)
  if not this.isParasiteObjectType[typeIndex] then
    return
  end
  if not this.BossEventEnabled() then
    return
  end

  local parasiteIndex=0
  for index,parasiteName in ipairs(this.bossObjectNames[this.parasiteType]) do
    local parasiteId=GetGameObjectId(parasiteName)
    if parasiteId~=nil and parasiteId==gameId then
      parasiteIndex=index
      break
    end
  end
  if parasiteIndex==0 then
    return
  end

  svars.bossEvent_bossStates[parasiteIndex]=this.stateTypes.FULTONED

  --InfCore.PrintInspect(this.states,{varName="states"})--DEBUGNOW

  local numCleared=this.GetNumCleared()
  if numCleared==this.numParasites then
    InfCore.Log("InfBossEvent OnFulton: all eliminated")--DEBUG
    this.EndEvent()
  end
  --end,gameId)--
end

function this.InitEvent()
  --InfCore.PCall(function()--DEBUG
  if not this.BossEventEnabled() then
    InfCore.Log("InfBossEvent InitEvent BossEventEnabled false")--DEBUG
    return
  end

  InfCore.Log("InfBossEvent InitEvent")--DEBUG
  --InfCore.PrintInspect(svars.bossEvent_isActive,"svars.bossEvent_isActive")--DEBUGNOW
  
  if svars.bossEvent_isActive then
    this.SetupParasites()--tex just assuming these arent saved
    return
  end

  if this.parasiteType=="CAMO" then
    for i,parasiteName in ipairs(this.bossObjectNames[this.parasiteType]) do
      this.CamoParasiteOff(parasiteName)
    end
  else
    for i,parasiteName in ipairs(this.bossObjectNames[this.parasiteType]) do
      this.AssaultParasiteOff(parasiteName)
    end
  end

  this.hostageParasiteHitCount=0

  this.numParasites=#this.bossObjectNames[this.parasiteType]

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
  playerFocusRange=playerFocusRange*playerFocusRange
  for paraType,escapeDistance in pairs(escapeDistances)do
    escapeDistances[paraType]=escapeDistance*escapeDistance
  end

  -- if TppMission.IsMissionStart() then
  --   InfCore.Log"InfBossEvent InitEvent IsMissionStart clear"--DEBUG
  --   svars.bossEvent_isActive=false
  -- end

  for index,state in ipairs(this.bossObjectNames[this.parasiteType])do
    this.hitCounts[index]=0
  end
  --end)--
end--InitEvent

function this.StartEventTimer(time)
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
  if numCleared==this.numParasites then
    InfCore.Log("StartEventTimer numCleared==numParasites aborting")
    this.EndEvent()
    return
  end

  local minute=60
  local nextEventTime=time or math.random(Ivars.bossEvent_eventPeriod_MIN:Get()*minute,Ivars.bossEvent_eventPeriod_MAX:Get()*minute)
  InfCore.Log("Timer_BossStartEvent start in "..nextEventTime,this.debugModule)--DEBUG

  --OFF script block WIP
  --tex fails due to invalid blockId. I can't figure out how fox assigns blockIds.
  --ScriptBlocks that aren't used for the current mission return invalid,
  --but as the scriptblock definitions are in the scriptblock fpk itself there's a chicken and egg problem if they're what is used to define the script block name.
  --  local success=TppScriptBlock.Load("parasite_block",this.parasiteType,true,true)--DEBUGNOW TODO only start once block loaded and active
  --  if not success then
  --    InfCore.Log("WARNING: InfBossEvent TppScriptBlock.Load returned false")--DEBUG
  --  end

  TimerStop("Timer_BossStartEvent")--tex may still be going from self start vs Timer_BossEventMonitor start
  TimerStart("Timer_BossStartEvent",nextEventTime)
  --end,time)--
end--StartEventTimer
--Timer started by StartEventTimer
function this.Timer_BossStartEvent()
  InfCore.Log("InfBossEvent.Timer_BossStartEvent")

  --tex DEBUGNOW see comment in StartEventTimer 
  local numCleared=this.GetNumCleared()
  if numCleared==this.numParasites then
    InfCore.Log("StartEventTimer numCleared==numParasites aborting")
    this.EndEvent()
    return
  end

  --tex restart self, this way if player interrupts any of the other post fight states that restart the timer this will still be ticking
  --also since timers dont save/reload we need determistic starting of timer (which starting on FadeInOnGameStart, then restarting self is)
  this.StartEventTimer()

  if svars.bossEvent_isActive then
    return
  end

  svars.bossEvent_isActive=true

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

  local parasiteAppearTime=math.random(bossAppearTimeMin,bossAppearTimeMax)
  TimerStart("Timer_BossAppear",parasiteAppearTime)
end--Timer_BossStartEvent
--Timer started by above, and Timer_BossEventMonitor
function this.Timer_BossAppear()
  InfCore.PCallDebug(function()--DEBUG
    InfCore.LogFlow("InfBossEvent ParasiteAppear")
    local playerPos={vars.playerPosX,vars.playerPosY,vars.playerPosZ}
    local closestPos=playerPos
    local closestDist=999999999999999

    local isMb=vars.missionCode==30050 or vars.missionCode==30250
    local noCps=false

    local closestCp,cpDistance,cpPosition

    if noCps then
      InfCore.Log("InfBossEvent.ParasiteAppear noCps")
      closestPos=playerPos
    else
      closestCp,cpDistance,cpPosition=InfMain.GetClosestCp(playerPos)
      if closestCp==nil or cpPosition==nil then
        InfCore.Log("WARNING: InfBossEvent ParasiteAppear closestCp==nil")--DEBUG
        closestPos=playerPos
      else
        closestDist=cpDistance

        if not isMb then--tex TODO: implement for mb
          local closestLz,lzDistance,lzPosition=InfLZ.GetClosestLz(playerPos)
          if closestLz==nil or lzPosition==nil then
            InfCore.Log("WARNING: InfBossEvent ParasiteAppear closestLz==nil")--DEBUG
          else
            local lzCpDist=TppMath.FindDistance(lzPosition,cpPosition)
            closestPos=cpPosition
            if cpDistance>lzDistance and lzCpDist>playerFocusRange*2 then
              closestPos=lzPosition
              closestDist=lzDistance
            end
          end--if closestLz
        end--if no isMb

        if closestDist>playerFocusRange then
          closestPos=playerPos
        end
      end--if closestCp
    end--if not noCps

    InfCore.Log("ParasiteAppear "..this.parasiteType.." closestCp:"..tostring(closestCp),this.debugModule)

    this.lastContactTime=Time.GetRawElapsedTimeSinceStartUp()+timeOuts[this.parasiteType]

    --tex anywhere but playerPos needs more consideration to how discoverable the bosses are
    --CAMO will start heading to cp anyway because they rely on the routes, 
    --so its more important that they start where player will notice
    local appearPos=playerPos

    if this.parasiteType=="CAMO" then
      this.SetArrayPos(svars.bossEvent_focusPos,playerPos)
      this.CamoParasiteAppear(appearPos,closestCp,cpPosition,spawnRadius[this.parasiteType])
    elseif this.parasiteType=="MIST" then
      this.SetArrayPos(svars.bossEvent_focusPos,closestPos)
      this.ArmorParasiteAppear(appearPos,spawnRadius[this.parasiteType])
    elseif this.parasiteType=="ARMOR" then
      this.SetArrayPos(svars.bossEvent_focusPos,closestPos)
      this.ArmorParasiteAppear(appearPos,spawnRadius[this.parasiteType])
    end

    if isMb then
      this.ZombifyMB()
    else
      this.ZombifyFree(closestCp,closestPos)
    end

    --tex WORKAROUND once one armor parasite has been fultoned the rest will be stuck in some kind of idle ai state on next appearance
    --forcing combat bypasses this
    local armorFultoned=false
    for index,state in ipairs(this.bossObjectNames[this.parasiteType])do
      if state==this.stateTypes.FULTONED then
        armorFultoned=true
      end
    end
    if armorFultoned and this.parasiteType=="ARMOR" then
      --InfCore.Log("Timer_BossCombat start",true)--DEBUG
      TimerStart("Timer_BossCombat",4)
    end

    TimerStart("Timer_BossEventMonitor",monitorRate)
  end)--
end--Timer_BossAppear

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
  local radius=escapeDistances[this.parasiteType]

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

function this.ArmorParasiteAppear(parasitePos,spawnRadius)
  InfCore.Log("InfBossEvent ArmorParasiteAppear spawnRadius:"..spawnRadius)
  if this.debugModule then
    InfCore.PrintInspect(parasitePos,"parasitePos")
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

  for k,parasiteName in pairs(this.bossObjectNames[this.parasiteType]) do
    local gameId=GetGameObjectId(parasiteName)
    if gameId==NULL_ID then
      InfCore.Log("WARNING: "..parasiteName.. " not found",true)
    end
  end

  --tex Armor parasites appear all at once, distributed in a circle
  SendCommand({type="TppParasite2"},{id="StartAppearance",position=Vector3(parasitePos[1],parasitePos[2],parasitePos[3]),radius=spawnRadius})
end

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
function this.CamoParasiteAppear(parasitePos,closestCp,cpPosition,spawnRadius)
  --InfCore.Log"CamoParasiteAppear"--DEBUG
  --tex camo parasites rely on having route set, otherwise they'll do a constant grenade drop evade on the same spot
  local routeCount,cpRoutes=this.GetRoutes(closestCp)

  --  InfCore.PrintInspect("CamoParasiteAppear cpRoutes")--DEBUG
  --  InfCore.PrintInspect(cpRoutes)

  if routeCount<this.numParasites then
    InfCore.Log("WARNING: InfBossEvent CamoParasiteAppear - routeCount< #camo parasites",true)
    return
  end

  this.routeBag=InfUtil.ShuffleBag:New()
  for route,bool in pairs(cpRoutes) do
    this.routeBag:Add(route)
  end

  for index,parasiteName in ipairs(this.bossObjectNames.CAMO) do
    if svars.bossEvent_bossStates[index]==this.stateTypes.READY then
      local gameId=GetGameObjectId("TppBossQuiet2",parasiteName)
      if gameId==NULL_ID then
        InfCore.Log("WARNING: InfBossEvent CamoParasiteAppear - "..parasiteName.. " not found",true)
      else
        local parasiteRotY=0

        InfCore.Log(parasiteName.." appear",this.debugModule)

        --ASSUMPTION 4 parasites
        --half circle with 2 leads
        --local angle=360/i

        --4 quadrants
        local angle=90*(index-1)
        local spawnPos=this.PointOnCircle(parasitePos,spawnRadius,angle)

        this.SetCamoRoutes(this.routeBag,gameId)

        SendCommand(gameId,{id="ResetPosition"})
        SendCommand(gameId,{id="ResetAI"})

        --tex can put camo parasites to an initial position
        --but they will move to their set route on activation
        SendCommand(gameId,{id="WarpRequest",pos=spawnPos,rotY=parasiteRotY})

        if disableFight then
          this.CamoParasiteOnDisableFight(parasiteName)
        else
          this.CamoParasiteOn(parasiteName)
        end

        this.CamoParasiteCloseCombatMode(parasiteName,true)
      end
      --SendCommand({type="TppBossQuiet2"},{id="StartCombat"})
    end
  end

  return parasitePos
end
--DEBUGNOW get working for MB
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
          end
        end
      end
    end
  end
  return routeCount,cpRoutes
end--GetRoutes
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
  if svars.bossEvent_isActive==false then
    return
  end

  local outOfRange=false
  this.SetArrayPos(monitorPlayerPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
  this.SetArrayPos(monitorFocusPos,svars.bossEvent_focusPos)
  local focusPosDistSqr=TppMath.FindDistance(monitorPlayerPos,monitorFocusPos)
  local escapeDistance=escapeDistances[this.parasiteType]
  if escapeDistance>0 and focusPosDistSqr>escapeDistance then
    outOfRange=true
  end

  local outOfContactTime=this.lastContactTime<Time.GetRawElapsedTimeSinceStartUp() --tex GOTCHA: DEBUGNOW lastContactTime actually outOfContactTimer or something, since its set like a game timer as GetRawElapsedTimeSinceStartUp+timeout

  if this.debugModule then
    InfCore.Log("InfBossEvent.Timer_BossEventMonitor "..this.parasiteType.. " escapeDistanceSqr:"..escapeDistance.." distSqr:"..focusPosDistSqr)--DEBUG
    InfCore.Log("dist:"..math.sqrt(focusPosDistSqr).." outOfRange:"..tostring(outOfRange).." outOfContactTime:"..tostring(outOfContactTime),true)--DEBUG
  end
  
  --tex GOTCHA: TppParasites aparently dont support GetPosition, frustrating inconsistancy, you'd figure it would be a function of all gameobjects
  local bossObjectType=this.bossObjectTypes[this.parasiteType]
  for index,parasiteName in pairs(this.bossObjectNames[this.parasiteType]) do
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
        if distSqr<escapeDistance then
          outOfRange=false
          break
        end
      end--if gameId
    end--if stateTypes.READY
  end--for bossObjectNames
  
  --tex I think my original reasoning here for only mist and not armor was that 'mist is chasing you'
  --DEBUGNOW but since TppParasite2 doesnt have GetPosition it might be a bit weird in situations where ARMOR are still right near you
  --since you just nead to get out of focusPos range (their appear pos, or last contact pos) so I might have to add them too
  if this.parasiteType=="MIST" then
    if focusPosDistSqr>playerFocusRange then
      InfCore.Log("EventMonitor: > playerRange",this.debugModule)
      InfCore.Log("EventMonitor: lastcontactTime:"..this.lastContactTime,this.debugModule)
      if not outOfContactTime then
        InfCore.Log("EventMonitor: lastContactTime timeout, starting combat",this.debugModule)
        --SendCommand({type="TppParasite2"},{id="StartCombat"})
        this.SetArrayPos(svars.bossEvent_focusPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
        local parasiteAppearTime=math.random(1,2)
        TimerStart("Timer_BossAppear",parasiteAppearTime)
        outOfRange=false
      end
    end
  end

  if outOfRange then
    InfCore.Log("EventMonitor: out of range :"..math.sqrt(focusPosDistSqr).."> "..math.sqrt(escapeDistance).. ", ending event",this.debugModule)
    this.EndEvent()
    this.StartEventTimer()
  else
    TimerStart("Timer_BossEventMonitor",monitorRate)--tex start self again
  end
  --end)--
end--Timer_BossEventMonitor

function this.EndEvent()
  InfCore.Log("InfBossEvent EndEvent",this.debugModule)

  svars.bossEvent_isActive=false
  TppWeather.CancelForceRequestWeather(TppDefine.WEATHER.SUNNY,7)

  if this.parasiteType=="CAMO"then
    SendCommand({type="TppBossQuiet2"},{id="SetWithdrawal",enabled=true})
  else
    SendCommand({type="TppParasite2"},{id="StartWithdrawal"})
  end

  --tex TODO throw CAMO parasites to some far route (or warprequest if it doesn't immediately vanish them) then Off them after a while

  TimerStop("Timer_BossEventMonitor")

  TimerStart("Timer_BossUnrealize",6)
end

function this.Timer_BossUnrealize()
  if this.parasiteType=="CAMO" then
    for index,parasiteName in ipairs(this.bossObjectNames.CAMO) do
      if svars.bossEvent_bossStates[index]==this.stateTypes.READY then--tex can leave behind non fultoned
        this.CamoParasiteOff(parasiteName)
      end
    end
  else
    --tex possibly not nessesary for ARMOR parasites, but MIST parasites have a bug where they'll
    --withdraw to wherever the withdraw postion is but keep making the warp noise constantly.
    for index,parasiteName in ipairs(this.bossObjectNames[this.parasiteType]) do
      if svars.bossEvent_bossStates[index]==this.stateTypes.READY then
        this.AssaultParasiteOff(parasiteName)
      end
    end
  end
end

function this.GetNumCleared()
  local numCleared=0
  for index,parasiteName in ipairs(this.bossObjectNames[this.parasiteType]) do
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

--
function this.AssaultParasiteOff(parasiteName)
  local gameId=GetGameObjectId("TppParasite2",parasiteName)
  if gameId~=NULL_ID then
    SendCommand(gameId,{id="Unrealize"})
  end
end

--camo zombies/TppBossQuiet2
function this.CamoParasiteOff(parasiteName)
  local gameObjectId=GetGameObjectId("TppBossQuiet2",parasiteName)

  if gameObjectId~=NULL_ID then
    local command01={id="SetSightCheck",flag=false}
    SendCommand(gameObjectId,command01)

    local command02={id="SetNoiseNotice",flag=false}
    SendCommand(gameObjectId,command02)

    local command03={id="SetInvincible",flag=true}
    SendCommand(gameObjectId,command03)

    local command04={id="SetStealth",flag=true}
    SendCommand(gameObjectId,command04)

    local command05={id="SetHumming",flag=false}
    SendCommand(gameObjectId,command05)

    local command06={id="SetForceUnrealze",flag=true}
    SendCommand(gameObjectId,command06)
  end
end

function this.CamoParasiteOn(parasiteName)
  local gameObjectId=GetGameObjectId("TppBossQuiet2",parasiteName)

  local command={id="SetForceUnrealze",flag=false}
  SendCommand(gameObjectId,command)

  local command01={id="SetSightCheck",flag=true}
  SendCommand(gameObjectId,command01)

  local command02={id="SetNoiseNotice",flag=true}
  SendCommand(gameObjectId,command02)

  local command03={id="SetInvincible",flag=false}
  SendCommand(gameObjectId,command03)

  local command04={id="SetStealth",flag=false}
  SendCommand(gameObjectId,command04)

  local command05={id="SetHumming",flag=true}
  SendCommand(gameObjectId,command05)
end

function this.CamoParasiteOnDisableFight(parasiteName)
  local gameObjectId=GetGameObjectId("TppBossQuiet2",parasiteName)

  local command={id="SetForceUnrealze",flag=false}
  SendCommand(gameObjectId,command)

  local command01={id="SetSightCheck",flag=false}
  SendCommand(gameObjectId,command01)

  local command02={id="SetNoiseNotice",flag=false}
  SendCommand(gameObjectId,command02)

  local command03={id="SetInvincible",flag=false}
  SendCommand(gameObjectId,command03)

  local command04={id="SetStealth",flag=false}
  SendCommand(gameObjectId,command04)

  local command05={id="SetHumming",flag=true}
  SendCommand(gameObjectId,command05)
end

function this.SetCamoRoutes(routeBag,gameId)
  InfCore.Log("SetCamoRoutes",this.debugModule)--DEBUG
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
end

function this.CamoParasiteCloseCombatMode(parasiteName,enabled)
  local command={id="SetCloseCombatMode",enabled=enabled}--tex NOTE unsure if this command is actually individual
  local gameObjectId={type="TppBossQuiet2",parasiteName}
  if gameObjectId~=NULL_ID then
    SendCommand(gameObjectId,command)
  end
end

--REF interesting functions/commands not doing anythig with yet
--armor, from fob
--this.StartSearchParasite = function ()
--  Fox.Log("***** this.StartSearchParasite *****")
--
--  for k, parasiteName in pairs(this.PARASITE_NAME_LIST) do
--    local gameObjectId = GameObject.GetGameObjectId(parasiteName)
--    if gameObjectId ~= nil then
--      GameObject.SendCommand( gameObjectId, { id="StartSearch" })
--    end
--  end
--end

--camo
--function this.CamoParasiteEnableFulton(enabled)
--  local command={id="SetFultonEnabled",enabled=enabled}
--  command.enabled = true
--  local gameObjectId={type="TppBossQuiet2"}
--  SendCommand(gameObjectId, command)
--end

--function this.CamoParasiteNarrowFarSight(parasiteName,enabled)
--  local command={id="NarrowFarSight",enabled=enabled}
--  local gameObjectId=GetGameObjectId("TppBossQuiet2",parasiteName)
--  if gameObjectId~=NULL_ID then
--    SendCommand(gameObjectId,command)
--  end
--end

--function this.CamoParasiteWaterFallShift(enabled)
--  local command = {id="SetWatherFallShift",enabled=enabled}
--  local gameObjectId = { type="TppBossQuiet2" }
--  SendCommand(gameObjectId, command)
--end

--function this.IsCamoParasite()
--  local quietType=SendCommand({type="TppBossQuiet2"},{id="GetQuietType"})
--  if quietType==InfCore.StrCode32"Cam"then--Camo parasite, not Quiet
--
--  end
--end

--tex REF from quiet boss fight s10050_enemy
--this.RequestShoot = function( target )
--  local command = {}
--
--  if ( target == "player" ) then
--    command = { id="ShootPlayer" }
--
--  elseif ( target == "entrance" ) then
--    command = { id="ShootPosition", position="position" }
--    command.position = {-1828.670, 360.220, -132.585}
--
--  end
--
--  if not( command == {} ) then
--    SendCommand( { type="TppBossQuiet2", index=0 }, command )
--    Fox.Log("#### qest_bossQuiet_00 #### RequestShoot [ "..tostring(target).." ]")
--
--    if ( target == "player" ) then
--      local ridingGameObjectId = vars.playerVehicleGameObjectId
--      if Tpp.IsHorse(ridingGameObjectId) then
--
--        SendCommand( ridingGameObjectId, { id = "HorseForceStop" } )
--      elseif( Tpp.IsPlayerWalkerGear(ridingGameObjectId) or Tpp.IsEnemyWalkerGear(ridingGameObjectId) )then
--
--        SendCommand( ridingGameObjectId, { id = "ForceStop", enabled = true } )
--      end
--    end
--
--    if (this.isPlayerRideVehicle()) then
--      this.ChangeVehicleSettingForEvent()
--    end
--  end
--end
--REF s10050_enemy
--local BOSS_QUIET  = "BossQuietGameObjectLocator"
--this.SetQuietExtraRoute = function(demo,kill,recovery,antiHeli)
--  local gameObjectId = GetGameObjectId("TppBossQuiet2", BOSS_QUIET )
--
--
--  local command = {id="SetDemoRoute", route="route"}
--  if gameObjectId ~= NULL_ID then
--    command.route = demo
--    SendCommand(gameObjectId, command)
--  end
--
--
--  command = {id="SetKillRoute", route="route"}
--  if gameObjectId ~= NULL_ID then
--    command.route = kill
--    SendCommand(gameObjectId, command)
--  end
--
--
--  command = {id="SetRecoveryRoute", route="route"}
--  if gameObjectId ~= NULL_ID then
--    command.route = recovery
--    SendCommand(gameObjectId, command)
--  end
--
--
--  command = {id="SetAntiHeliRoute", route="route"}
--  if gameObjectId ~= NULL_ID then
--    command.route = kill
--    SendCommand(gameObjectId, command)
--  end
--end
--REF s10050_enemy
--tex doesn't seem to be called
--this.QuietKillModeChange = function()
--  local command = {id="SetKill", flag="flag"}
--  local gameObjectId = GetGameObjectId("TppBossQuiet2", BOSS_QUIET)
--
--  if gameObjectId ~= NULL_ID then
--
--    command.flag = svars.isKillMode
--    SendCommand(gameObjectId, command)
--  else
--  end
--end
--REF s10050_enemy
--this.QuietForceCombatMode = function()
--  SendCommand( { type="TppBossQuiet2", index=0 }, { id="StartCombat" } )
--end
--REF s10050_enemy
--this.StartQuietDeadEffect = function()
--  local command = { id="StartDeadEffect" }
--  local gameObjectId = { type="TppBossQuiet2", index=0 }
--  SendCommand(gameObjectId, command)
--end
---
--util

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
    bossEvent_eventPeriod_MIN="Skull attack min (minutes)",
    bossEvent_eventPeriod_MAX="Skull attack max (minutes)",
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
