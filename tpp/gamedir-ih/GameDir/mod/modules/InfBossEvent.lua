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
  ResetAttackCountdown or CalculateAttackCountdown - for StartCountdown 

On FadeInOnGameStart, or some other means of starting event
  call StartBossCountdown


StartBossCountdown
  bail if all bosses eliminated
  start Timer_BossCountdown on bossEvent_attackCountdownPeriod

Timer_BossCountdown 
  decrement countdown
  call StartBossCountdown again if countdown not done
  else
    StartEvent

StartEvent
  ChooseBossTypes
  ScriptBlock Load Boss packs
  start Timer_BossAppear

ChooseBossTypes

OnScriptBlockStateTransition TRANSITION_ACTIVATED
  InitBoss
  
InitBoss
  disable all the bosses
  init relavant state/boss settings

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

--[[
scriptblocks: each boss type has its own
each scriptblock needs at least a ScriptBlockData entity loaded by mission
in this case it's just cribbed from f30010_sequence.fox2 quest_block
TODO: only thing possibly to mull about in future is sizeInBytes property
missionPack
/Assets/tpp/pack/mission2/boss/ih/<bossObjectType>_scriptblockdata.fpkd
 <bossObjectType>_scriptblockdata.fox2
    just cribbed from f30010_sequence.fox2 quest_block
    ScriptBlockData <bossObjectType>_block

most other scriptblocks have a script (thus the name) loaded by a ScriptBlockScript entity in the script block fpkd
its mostly used to provide management during the OnAllocate,OnInitialize,OnTerminate
its not strictly required so I'm forgoing it for now just managing via OnScriptBlockStateTransition, ScriptBlock.GetScriptBlockState and manually wrestling it
TppScriptBlock has a few management features, but I'm not currently using it.
]]

local this={}

local InfCore=InfCore
local InfMain=InfMain
local GetGameObjectId=GameObject.GetGameObjectId
local GetTypeIndex=GameObject.GetTypeIndex
local NULL_ID=GameObject.NULL_ID
local SendCommand=GameObject.SendCommand
local TimerStart=GkEventTimerManager.Start
local TimerStop=GkEventTimerManager.Stop
local GetRawElapsedTimeSinceStartUp=Time.GetRawElapsedTimeSinceStartUp
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


local bossTypeNames={
  TppParasite2="InfBossTppParasite2",
  TppBossQuiet2="InfBossTppBossQuiet2",
}
this.bossModules={}--bossModules[bossType]=_G[moduleName] PostAllModulesLoad

--tex lastContactTime is in terms of GetRawElapsedTimeSinceStartUp (which is not adjusted for reload from checkpoint), 
--however its not saved anyway, as it only meaningful during attack it gets reset with everything else
this.lastContactTime=0

this.hostageParasiteHitCount=0--tex mbqf hostage parasites

this.MAX_BOSSES_PER_TYPE=4--LIMIT, tex would also have to bump, or set parasiteSquadMarkerFlag size (and test that actually does anything)

--tex see CalculateAttackCountdown, StartCountdown
local attackCountdownTimespan=30--DYNAMIC: tex in minutes, rnd from min, max ivars see CalculateAttackCountdown
local countdownInterval=1*60--tex in seconds

function this.DeclareSVars()
  if not this.BossEventEnabled() then
    return{}
  end
  local saveVarsList = {
    --tex see ResetAttackCountdown
    bossEvent_attackCountdown=attackCountdownTimespan,
    bossEvent_eventCount=0,--tex how many events have happened this mission
    --tex size+1 so I can just uses it indexed from 1
    bossEvent_focusPos={name="bossEvent_focusPos",type=TppScriptVars.TYPE_FLOAT,arraySize=3+1,value=0,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},
  }
  return TppSequence.MakeSVarsTable(saveVarsList)
end--DeclareSVars

function this.PostModuleReload(prevModule)
  --this.lastContactTime=prevModule.lastContactTime

  --this.hostageParasiteHitCount=prevModule.hostageParasiteHitCount
end

--TUNE

local triggerAttackCount=45--tex mbqf hostage parasites



--seconds
local monitorRate=10
local bossAppearTimeMin=4
local bossAppearTimeMax=8

local playerFocusRange=175--tex choose player pos as bossFocusPos if closest lz or cp > than this (otherwise whichever is closest of those)
local playerFocusRangeSqr=playerFocusRange*playerFocusRange

--TUNE zombies
local disableDamage=false
local isHalf=false
--<


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
  "bossEvent_enabled_TppParasite2",
  "bossEvent_enabled_InfBossTppBossQuiet2",
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

this.bossEvent_enabled_TppParasite2={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
}
this.bossEvent_enabled_InfBossTppBossQuiet2={
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
      InfBossEvent.ResetAttackCountdown()
      InfBossEvent.StartCountdown()
    end,
  },
  {
    default=30,
    OnChange=function(self,setting,prevSetting)
      IvarProc.PushMin(self,setting,prevSetting)
      InfBossEvent.ResetAttackCountdown()
      InfBossEvent.StartCountdown()
    end,
  },
  {
    inMission=true,
    range={min=0,max=180,increment=1},
  }
)

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

local parasiteToggle=false
this.DEBUG_ToggleBossEvent=function()
  if not this.BossEventEnabled() then
    InfCore.Log("InfBossEvent InitEvent BossEventEnabled false",true)--DEBUG
    return
  end

  parasiteToggle=not parasiteToggle
  if parasiteToggle then
    InfCore.Log("DEBUG_ToggleBossEvent on",false,true)
    this.StartCountdown(true)
  else
    InfCore.Log("DEBUG_ToggleBossEvent off",false,true)
    this.EndEvent()
  end
end--DEBUG_ToggleBossEvent
--< ivar defs

function this.PostAllModulesLoad()
  for bossType,moduleName in pairs(bossTypeNames)do
    this.bossModules[bossType]=_G[moduleName]
  end--for bossModuleNames
  if this.debugModule then
    InfCore.PrintInspect(this.bossModules,"InfBossEvent.bossModules")
  end
end--PostAllModulesLoaded

function this.PreModuleReload()
  local timers={
    "Timer_BossCountdown",
    "Timer_BossAppear",
    "Timer_BossCombat",
    "Timer_BossEventMonitor",
    "Timer_BossUnrealize",
  }
  for i,timerName in ipairs(timers)do
    TimerStop(timerName)
  end
end

function this.AddMissionPacks(missionCode,packPaths)
  if not this.BossEventEnabled(missionCode)then
    return
  end

  for bossType,BossModule in pairs(this.bossModules)do
    BossModule.AddPacks(missionCode,packPaths)
  end

  --TODO: ChooseBossTypes is no longer at Load, so cant tell if sub types zombifie or not
  --if zombifies then
    for i,packagePath in ipairs(this.packages.ZOMBIE)do
      packPaths[#packPaths+1]=packagePath
    end
  --end
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
      --{msg="Dying",func=this.OnDying},
      --tex TODO: "FultonInfo" instead of fulton and fultonfailed
      -- {msg="Fulton",--tex fulton success i think
      --   func=function(gameId,gimmickInstance,gimmickDataSet,stafforResourceId)
      --     this.OnFulton(gameId)
      --   end},
      -- {msg="FultonFailed",
      --   func=function(gameId,locatorName,locatorNameUpper,failureType)
      --     if failureType==TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
      --       this.OnFulton(gameId)
      --     end
      --   end},
    },--GameObject
    -- Player={
    --   {msg="PlayerDamaged",func=this.OnPlayerDamaged},
    -- },--Player
    Timer={
      {msg="Finish",sender="Timer_BossCountdown",func=this.Timer_BossCountdown},
      {msg="Finish",sender="Timer_BossAppear",func=this.Timer_BossAppear},
      --{msg="Finish",sender="Timer_BossCombat",func=this.Timer_BossCombat},
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

  if TppMission.IsMissionStart() then
    this.ResetAttackCountdown()
  else
    this.CalculateAttackCountdown()
  end
end

function this.FadeInOnGameStart()
  if not this.BossEventEnabled() then
    return
  end

  if Ivars.bossEvent_enableFREE:Is(0) then
    return
  end

  InfCore.Log"InfBossEvent mission start StartCountdown"
  this.StartCountdown()
end--FadeInOnGameStart

function this.BossEventEnabled(missionCode)
  local missionCode=missionCode or vars.missionCode
  if Ivars.bossEvent_enableFREE:Is(1) and (Ivars.bossEvent_enableFREE:MissionCheck(missionCode) or missionCode==30250) then
    return true
  end
  return false
end

function this.ChooseBossTypes(nextMissionCode)
  InfCore.Log("InfBossEvent.ChooseBossTypes")
--tex DEBUGNOW currently hinging on mission load AddPackages (or rather visa versa), 
  --ScriptBlock loading should free this up to be a per event setup thing

  InfMain.RandomSetToLevelSeed()
  --tex essentially shifts rnd seed along deterministically and reloadably
  for i=0,svars.bossEvent_eventCount do
    math.random()
  end
  svars.bossEvent_eventCount=svars.bossEvent_eventCount+1

  -- local enabledTypes={
  --   TppParasite2=InfBossTppParasite2.IsEnabled(),
  --   TppBossQuiet2=InfBossTppBossQuiet2.IsEnabled(),
  -- }
  -- if this.debugModule then
  --   InfCore.PrintInspect(enabledTypes,"enabledTypes")
  -- end

  --tex DEBUGNOW Util
  local function KeysToList(t)
    local outTable={}
    local i=1
    for k,v in pairs(t)do
      outTable[i]=k
      i=i+1
    end
    return outTable
  end

  local allDisabled=true
  local hasABoss=false
  while(not hasABoss)do
    for bossType,BossModule in pairs(this.bossModules)do
      BossModule.currentSubType=nil
      if BossModule.IsEnabled() then
        local enabledSubTypes=KeysToList(BossModule.GetEnabledSubTypes(nextMissionCode))
        if #enabledSubTypes>0 then
          allDisabled=false
          local subType=InfUtil.GetRandomInList(enabledSubTypes)
          local minBosses=0
          local maxBosses=#BossModule.bossObjectNames[subType]
          local numBosses=math.random(minBosses,maxBosses)
          if numBosses>0 then
            hasABoss=true
            BossModule.SetBossSubType(subType,numBosses)
          end
        end--if #enabledSubTypes
      end--if IsEnabled
    end--for bossModules
    if allDisabled then break end
  end--while not hasABoss

  if allDisabled then
    InfCore.Log("InfBossEvent.ChooseBossTypes: All boss subtypes disabled, bailing.")
  end

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
      this.StartCountdown(true)
    end
  end
end--OnDamageMbqfParasite

--OUT: this.gameIdToNameIndex
function this.InitEvent()
  --InfCore.PCall(function()--DEBUG
  if not this.BossEventEnabled() then
    InfCore.Log("InfBossEvent.InitEvent BossEventEnabled false")--DEBUG
    return
  end

  InfCore.Log("InfBossEvent.InitEvent")--DEBUG

  --tex CULL now handled by boss module OnScriptBlockStateTransition
  -- for bossType,BossModule in pairs(this.bossModules)do
  --   BossModule.InitEvent()
  -- end

  this.hostageParasiteHitCount=0

  playerFocusRange=Ivars.bossEvent_playerFocusRange:Get()

  --distsqr
  playerFocusRangeSqr=playerFocusRange*playerFocusRange
  --end)--
end--InitEvent
  
function this.StartCountdown(startNow)
  --InfCore.PCall(function(time)--DEBUG
  if not this.BossEventEnabled() then
    return
  end

  if Ivars.bossEvent_enableFREE:Is(0) then
    return
  end

  if startNow then
    svars.bossEvent_attackCountdown=0
  end

  InfCore.Log("InfBossEvent.StartEventTimer svars.bossEvent_attackCountdown=="..tostring(svars.bossEvent_attackCountdown))

  local nextTimer=1--tex need a non 0 value I guess, StartEvent handles a short period of rnd for Timer_BossAppear, but it does fire weather immediately
  if svars.bossEvent_attackCountdown>0 then
    --tex via bossEvent_attackCountdown we only run the timer for some division (countdownSegmentMax) of the total time
    --so that on a reload it wont be postponed the full timespan
    --see CalculateAttackCountdown
    nextTimer=countdownInterval--module local

    InfCore.Log("StartBossCountdown next countdown in "..nextTimer,this.debugModule)--DEBUG
  elseif startNow then
    InfCore.Log("StartBossCountdown startNow in "..nextTimer,this.debugModule)--DEBUG
  else
    --tex TODO: anyway to differentiate between first start and continue?
    InfCore.Log("StartBossCountdown start in "..nextTimer,this.debugModule)--DEBUG
  end

  TimerStop("Timer_BossCountdown")--tex may still be going from self start vs Timer_BossEventMonitor start
  TimerStart("Timer_BossCountdown",nextTimer)
  --end,time)--
end--StartCountdown
--Timer started by StartCountdown
function this.Timer_BossCountdown()
  InfCore.Log("InfBossEvent.Timer_BossCountdown")

  --tex timer period is only part of the whole event start period, and it restarts timer with increasingly shorter periods
  --which gives a rough way to prevent the start event being postponed for the full period on reload
  if svars.bossEvent_attackCountdown>0 then
    svars.bossEvent_attackCountdown=svars.bossEvent_attackCountdown-1
    InfCore.Log("InfBossEvent.Timer_BossCountdown: svars.bossEvent_attackCountdown: "..tostring(svars.bossEvent_attackCountdown))
    this.StartCountdown()
    return
  end

  this.StartEvent()
end--Timer_BossCountdown

function this.StartEvent()
  this.ChooseBossTypes(vars.missionCode)
  this.InitEvent()

  for bossType,BossModule in pairs(this.bossModules)do
    --tex only has a blockId if theres a ScriptBlockData entity with the name 
    --(in this case its loaded via AddMissionPacks > BossModule.packages.scriptBlockData)
    --DEBUGNOW: may want to load reguardless so ChooseBossTypes can be done in-mission at each event kickoff 
    local blockId=ScriptBlock.GetScriptBlockId(bossType.."_block")
    InfCore.Log("BossStartEvent "..bossType.." blockId:"..tostring(blockId))
    if blockId==ScriptBlock.SCRIPT_BLOCK_ID_INVALID then
      InfCore.Log("ERROR: BossStartEvent "..bossType.." blockId==SCRIPT_BLOCK_ID_INVALID")
    else
      ScriptBlock.Load(blockId,BossModule.packages[BossModule.currentSubType])
      ScriptBlock.Activate(blockId)
    end
  end

  --tex flow continues on each bossmodules OnScriptBlockStateTransition

  --tex actually start
  --tex need some leeway between wather start and boss apread
  this.StartEventWeather()
  local parasiteAppearTime=math.random(bossAppearTimeMin,bossAppearTimeMax)
  TimerStart("Timer_BossAppear",parasiteAppearTime)
end--StartEvent

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

    local zombifies=false
    for bossType,BossModule in pairs(this.bossModules)do
      if BossModule.currentSubType~=nil then
        InfCore.Log("BossAppear "..BossModule.currentSubType.." closestCp:"..tostring(closestCp),this.debugModule)

        --tex anywhere but playerPos needs more consideration to how discoverable the bosses are
        --CAMO will start heading to cp anyway because they rely on the routes, 
        --so its more important that they start where player will notice
        this.SetFocusOnPlayerPos(BossModule.currentParams.timeOut)
        
        local appearPos=playerPos
        BossModule.Appear(appearPos,closestCp,closestCpPos,BossModule.currentParams.spawnRadius)

        if BossModule.currentParams.zombifies then
          zombifies=true
        end
      end--if currentSubType
    end--for bossModules

    if zombifies then
      if isMb then
        this.ZombifyMB()
      else
        local spawnRadiusSqr=40*40
        this.ZombifyFree(closestCp,closestCpPos,spawnRadiusSqr)
      end
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

local SetZombies=function(soldierNames,position,radiusSqr)
  local cpZombieLife=Ivars.parasite_zombieLife:Get()
  local cpZombieStamina=Ivars.parasite_zombieStamina:Get()
  local msfRate=Ivars.parasite_msfRate:Get()
  local msfLevel=math.random(Ivars.parasite_msfCombatLevel_MIN:Get(),Ivars.parasite_msfCombatLevel_MAX:Get())
  for i,soldierName in ipairs(soldierNames) do
    local gameId=GetGameObjectId("TppSoldier2",soldierName)
    if gameId~=NULL_ID then
      local soldierPosition=SendCommand(gameId,{id="GetPosition"})
      local soldierDistanceSqr=0
      if position then
        soldierDistanceSqr=TppMath.FindDistance({soldierPosition:GetX(),soldierPosition:GetY(),soldierPosition:GetZ()},position)
      end
      if not position or (radiusSqr and soldierDistanceSqr<radiusSqr) then
        --InfCore.Log(soldierName.." close to "..closestCp.. ", zombifying",true)--DEBUG
        local isMsf=math.random(100)<msfRate
        this.SetZombie(soldierName,disableDamage,isHalf,cpZombieLife,cpZombieStamina,isMsf,msfLevel)
      end
    end
  end
end

function this.ZombifyFree(closestCp,position,radiusSqr)
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
        SetZombies(lrrpDefine.cpDefine,position,radiusSqr)
      end
    end
  end

  --tex TODO doesn't cover vehicle lrrp

  if mvars.ene_soldierDefine and mvars.ene_soldierDefine.quest_cp then
    SetZombies(mvars.ene_soldierDefine.quest_cp,position,radiusSqr)
  end
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

  local outOfRange=true

  InfUtil.SetArrayPos(monitorPlayerPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
  InfUtil.SetArrayPos(monitorFocusPos,svars.bossEvent_focusPos)
  local focusPosDistSqr=TppMath.FindDistance(monitorPlayerPos,monitorFocusPos)

  local escapeDistanceSqr=0
  for bossType,BossModule in pairs(this.bossModules)do
    if BossModule.currentSubType~=nil then
      escapeDistanceSqr=BossModule.currentParams.escapeDistanceSqr
      if escapeDistanceSqr>0 and focusPosDistSqr<escapeDistanceSqr then
        outOfRange=false
      end
    end
  end

  local outOfContactTime=this.lastContactTime<Time.GetRawElapsedTimeSinceStartUp() --tex GOTCHA: DEBUGNOW lastContactTime actually outOfContactTimer or something, since its set like a game timer as GetRawElapsedTimeSinceStartUp+timeout

  if this.debugModule then
    local elapsedTime=Time.GetRawElapsedTimeSinceStartUp()
    InfCore.Log("InfBossEvent.Timer_BossEventMonitor escapeDistanceSqr:"..escapeDistanceSqr.." focusPosDistSqr:"..focusPosDistSqr)--DEBUG
    InfCore.PrintInspect(monitorFocusPos,"focusPos")
    InfCore.PrintInspect(monitorPlayerPos,"playerPos")
    InfCore.Log("lastContactTime: "..tostring(this.lastContactTime).." timeSinceStartup: "..elapsedTime)
    InfCore.Log("outOfRange:"..tostring(outOfRange).." outOfContactTime:"..tostring(outOfContactTime))--DEBUG
    InfCore.DebugPrint("escapeDistance:"..escapeDistanceSqr.." focusPosDist:"..focusPosDistSqr.." lastContact: "..tostring(this.lastContactTime).." elapsedTime: "..elapsedTime)
  end
  
  --tex GOTCHA: TppParasites aparently dont support GetPosition, frustrating inconsistancy, you'd figure it would be a function of all gameobjects
  for bossType,BossModule in pairs(this.bossModules)do
    if BossModule.currentSubType~=nil then
      for index,parasiteName in pairs(BossModule.currentBossNames) do
        if BossModule.IsReady(index) then
          local gameId=GetGameObjectId(bossType,parasiteName)
          if gameId~=NULL_ID then
            local parasitePos=SendCommand(gameId,{id="GetPosition"})
            if parasitePos==nil then
              break--tex this type doesnt support GetPosition DEBUGNOW revisit if you expand bossObjectTypes
            end
            InfUtil.SetArrayPos(monitorParasitePos,parasitePos:GetX(),parasitePos:GetY(),parasitePos:GetZ())
            local distSqr=TppMath.FindDistance(monitorPlayerPos,monitorParasitePos)
            --InfCore.Log("EventMonitor: "..parasiteName.." dist:"..math.sqrt(distSqr),this.debugModule)--DEBUG
            if distSqr<escapeDistanceSqr then
              outOfRange=false
              break
            end
          end--if gameId
        end--if IsReady
      end--for bossObjectNames
    end--if currentSubType
  end--for bossModules
  
  --tex I think my original reasoning here for only mist and not armor was that 'mist is chasing you'
  --DEBUGNOW but since TppParasite2 doesnt have GetPosition it might be a bit weird in situations where ARMOR are still right near you
  --since you just nead to get out of focusPos range (their appear pos, or last contact pos) so I might have to add them too
--DEBUGNOW TODO: eventParams.chase or something
  -- if this.bossSubType=="MIST" then
  --   if focusPosDistSqr>playerFocusRangeSqr then
  --     InfCore.Log("EventMonitor: > playerFocusRangeSqr",this.debugModule)
  --     if not outOfContactTime then
  --       InfCore.Log("EventMonitor: not outOfContactTime, starting combat",this.debugModule)
  --       --SendCommand({type="TppParasite2"},{id="StartCombat"})
  --       this.SetArrayPos(svars.bossEvent_focusPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
  --       local parasiteAppearTime=math.random(1,2)
  --       TimerStart("Timer_BossAppear",parasiteAppearTime)
  --       outOfRange=false
  --     end
  --   end
  -- end

  if outOfRange and outOfContactTime then
    InfCore.Log("EventMonitor: out of range and outOfContactTime :"..math.sqrt(focusPosDistSqr).."> "..math.sqrt(escapeDistanceSqr).. ", ending event",this.debugModule)
    this.EndEvent()
    this.StartCountdown()--tex start event countdown again (EndEvent resets bossEvent_attackCountdown)
  else
    TimerStart("Timer_BossEventMonitor",monitorRate)--tex start self again
  end
  --end)--
end--Timer_BossEventMonitor

function this.EndEvent()
  InfCore.Log("InfBossEvent.EndEvent",this.debugModule)

  TppWeather.CancelForceRequestWeather(TppDefine.WEATHER.SUNNY,7)

  for bossType,BossModule in pairs(this.bossModules)do
    BossModule.EndEvent()
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
  for bossType,BossModule in pairs(this.bossModules)do
    BossModule.DisableAll()
  end
end--Timer_BossUnrealize

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

function this.SetFocusOnPlayerPos(focusTimeOut)
  this.lastContactTime=GetRawElapsedTimeSinceStartUp()+focusTimeOut
  InfUtil.SetArrayPos(svars.bossEvent_focusPos,vars.playerPosX,vars.playerPosY,vars.playerPosZ)
  InfCore.Log("InfBossEvent.SetFocusOnPlayerPos: lastContactTime:"..this.lastContactTime)
end--SetFocusOnPlayerPos

function this.IsAllCleared()
  local allCleared=true
  for bossType,BossModule in pairs(this.bossModules)do
    if not BossModule.IsAllCleared() then
      allCleared=false
    end
  end
  return allCleared
end--IsAllCleared

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
      bossEventMenu=[[The Boss Event system manages random attacks from different boss types and their subTypes.
The system will choose a subType for each bossType for the event.
(*multiple boss types may cause crashes depending on what other game features are loaded).
TppParasite2 has ARMOR and MIST Skull subTypes.
TppBossQuiet2 has CAMO Skull.]],
      bossEvent_enableFREE="Skulls attack at a random time (in minutes) between Skull attack min and Skull attack max settings.",
      parasite_msfRate="Percentage chance a zombified soldier will have msf zombie behaviour",
    },
  }
}

return this
