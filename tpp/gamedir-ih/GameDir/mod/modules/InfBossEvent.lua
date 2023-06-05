-- InfBossEvent.lua
-- tex implements 'boss attacks' of parasite/skulls unit event
-- currently attacks are are based around a single bossFocusPos (see BossAppear) and a lastContactTime 
-- conceptually similar to enemy focus position

--TODO: expose  parasiteAppearTimeMin, parasiteAppearTimeMax
--TODO: handle good period after event end to recover bodies
--basically once player out of focus range?
--unload packs after
--handle event rastart during this process
--test mulitple events work
--ie after endevent can a new event start?
--ivar multiple events
--ivar include solo bosses in multi boss events

--TODO min max boss ivars
--TODO: TppPatasiste2 is hard coded to 4 bosses, so it needs to be 0,max

--TODO: TppBossParasite2 health bars break when TppBossQuiet2 also loaded
--they both use a boss_gauge_head.fox2 pointing to the /Assets/tpp/ui/LayoutAsset/hud_headmark/UI_hud_headmark_gage.uilb

--TODO: reimplment tppboss2 'chase' (see Timer_BossEventMonitor)
--TODO: option for noescape ie no timeout (on ivar timeout 0?) no escapedist (on dist iva 0?)

--TODO: BossQuiet2
--need to possibly reposition otherwise its too easy to have them appear, bugger off to their cp and just walk away
--possbly need to store cp they are at
--and on SetFocusOnPlayerPos getClosestCp to it and if its not currentCp then Appear again (at player pos so they notice where they go like initial appear)
--and/or set them to chase (see above)

--TODO: InfBossEvent.EndEvent CancelForceRequestWeather dont work if you stack event on checkpoint?

--TODO: weather : off, boss param (default), specific setting

--TODO: decide how to handle scriptblockdata mission packs in respect to turning on event in mission
--have overall enable switch just set itself back to what it was and warn user
--or exclude ivar from menu in mission

--TODO: retest TppBossQuiet2 with quiet intro quest active

--TODO: sort out zombification, TppBossParasites do have an active zombifiy behavior, but it's inconsitant, 
--however if you blanket zombify the area you wont actually see it

--TODO: make sure 30250 attack parasites still work, limit types to parasites

--TODO: integrate into zombie outbreak and obliteration wargames

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
/Assets/tpp/pack/boss/ih/<bossObjectType>_scriptblockdata.fpkd
 <bossObjectType>_scriptblockdata.fox2
    just cribbed from f30010_sequence.fox2 quest_block
    ScriptBlockData <bossObjectType>_block

most other scriptblocks have a script (thus the name) loaded by a ScriptBlockScript entity in the script block fpkd
its mostly used to provide management during the OnAllocate,OnInitialize,OnTerminate
its not strictly required so I'm forgoing it for now just managing via OnScriptBlockStateTransition, ScriptBlock.GetScriptBlockState and manually wrestling it
TppScriptBlock has a few management features, but I'm not currently using it.

currently all scriptblockdata mission packs are loaded reguardless of setting at load time, 
otherwise scriptblock wont have id if you turn it on during mission
they are still not loaded if overall bossevent enabled ivar is off, so need to think about that or warn user somehow
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
  ZOMBIE={
    "/Assets/tpp/pack/boss/ih/zombie_asset.fpk",
    "/Assets/tpp/pack/mission2/ih/snd_zmb.fpk",
  },
}--packages


local bossTypeNames={
  TppParasite2="InfBossTppParasite2",
  TppBossQuiet2="InfBossTppBossQuiet2",
}
this.bossModules={}--bossModules[bossType]=_G[moduleName] PostAllModulesLoad

--tex lastContactTime is in terms of GetRawElapsedTimeSinceStartUp (which is not adjusted for reload from checkpoint), 
--however its not saved anyway, as it only meaningful during attack it gets reset with everything else
this.lastContactTime=0
this.currentCp=nil--tex cp that currently being targeted - TppBossQuiet2 is using them for routes

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

  this.GetBossModules()--tex this is called in PostAllModulesLoad where it might be grabbing old values, would be fixed mofing to OnModuleLoad
end

--TUNE
local triggerAttackCount=45--tex mbqf hostage parasites

--seconds
local monitorRate=10--Timer_BossEventMonitor
local bossAppearTimeMin=4
local bossAppearTimeMax=8

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
  "bossEvent_combinedAttacks",
  "bossEvent_weather",
  "bossEvent_playerChaseRange",
  "bossEvent_escapeDistance",
  "bossEvent_timeOut",
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
    "MB_ALL",--DEBUGNOW
  }
)

this.bossEvent_combinedAttacks={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,--parasite
  settings={"NONE","FACTION","ALL"},--LANG whether multiple boss types can be involved in an event. allied = only those that are in the same faction - ie SKULLS, ALL all bosses
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

this.bossEvent_playerChaseRange={--TODO
  save=IvarProc.CATEGORY_EXTERNAL,
  default=175,
  range={min=0,max=1000,},
}
--tex player distance from parasite attack pos to call off attack
this.bossEvent_escapeDistance={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=250,
  range={min=0,max=1000,},
}
this.bossEvent_timeOut={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1*60,
  range={min=0,max=10*60,},
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
  parentRefs={"InfGameEvent.eventsMenu","InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.bossEvent_enableFREE",
    "Ivars.bossEvent_enableMB_ALL",--DEBUGNOW
    "Ivars.bossEvent_attackCountdownPeriod_MIN",
    "Ivars.bossEvent_attackCountdownPeriod_MAX",
    "Ivars.bossEvent_timeOut",
    "Ivars.bossEvent_escapeDistance",
    --"Ivars.bossEvent_playerChaseRange",--TODO:
    "Ivars.bossEvent_combinedAttacks",
    "Ivars.bossEvent_weather",
    "Ivars.parasite_zombieLife",
    "Ivars.parasite_zombieStamina",
    "Ivars.parasite_msfRate",
    "Ivars.parasite_msfCombatLevel_MIN",
    "Ivars.parasite_msfCombatLevel_MAX",

  },
}--bossEventMenu
--< ivar defs

function this.PostAllModulesLoad()
  this.GetBossModules()
end--PostAllModulesLoaded

function this.PreModuleReload()
  this.StopTimers()
end

function this.AddMissionPacks(missionCode,packPaths)
  if not this.BossEventEnabled(missionCode)then
    return
  end

  for bossType,BossModule in pairs(this.bossModules)do
    BossModule.AddPacks(missionCode,packPaths)
  end

  --TODO: ChooseBossTypes is no longer at Load, so cant tell if sub types zombifie or not
  --while technically these could be in scriptblocks, zombiefied soldiers hang around after scripblock may be unloaded
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
    },--GameObject
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

function this.GetBossModules()
  for bossType,moduleName in pairs(bossTypeNames)do
    this.bossModules[bossType]=_G[moduleName]
  end--for bossModuleNames
  if this.debugModule then
    InfCore.PrintInspect(this.bossModules,"InfBossEvent.bossModules")
  end
end--GetBossModules

function this.BossEventEnabled(missionCode)
  local missionCode=missionCode or vars.missionCode
  if IvarProc.EnabledForMission("bossEvent_enable",missionCode) or missionCode==30250 then--tex you ca trigger attack in 30250 by attacking parasites in cage
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
  --incremented at endevent
  for i=0,svars.bossEvent_eventCount do
    math.random()
  end

  -- local enabledTypes={
  --   TppParasite2=InfBossTppParasite2.IsEnabled(),
  --   TppBossQuiet2=InfBossTppBossQuiet2.IsEnabled(),
  -- }
  -- if this.debugModule then
  --   InfCore.PrintInspect(enabledTypes,"enabledTypes")
  -- end

  --tex DEBUGNOW Util
  --this is specifically for ivar 0,1 / false true (lua 0 is normally true)
  local function KeysToList(t)
    local outTable={}
    local i=1
    for k,v in pairs(t)do
      if v==1 then
        outTable[i]=k
        i=i+1
      end
    end
    return outTable
  end

  --TODO: get enabled bosses with enabled subtypes
  --main boss = pick a rnd boss and rnd subtype
  --mainboss rnd numbosses

  --if multi attack not off
  --if multi attack == FACTION
  --for enabled bosses (not selected) filter out those that arent of main boss faction
  
  --if some attack size ivar? manage number of bosses based on main boss

  for bossType,BossModule in pairs(this.bossModules)do
    BossModule.ClearBossSubType()

    local blockId=ScriptBlock.GetScriptBlockId(bossType.."_block")
    ScriptBlock.Load(blockId,"")--tex unloads
  end

  local enabledBosses={}
  local enabledBossesList={}
  for bossType,BossModule in pairs(this.bossModules)do  
    if BossModule.IsEnabled() then
      local enabledSubTypes=KeysToList(BossModule.GetEnabledSubTypes(nextMissionCode))
      if #enabledSubTypes>0 then
        enabledBosses[bossType]=enabledSubTypes
        table.insert(enabledBossesList,bossType)
      end--if #enabledSubTypes
    end--if IsEnabled
  end--for bossModules

  if #enabledBossesList==0 then
    InfCore.Log("InfBossEvent.ChooseBossTypes: All bosses/subtypes disabled, bailing.")
    InfMain.RandomResetToOsTime()
    return
  end

  InfCore.PrintInspect(enabledBosses,"enabledBosses")

  local mainBossType=InfUtil.GetRandomInList(enabledBossesList)
  local mainSubType=InfUtil.GetRandomInList(enabledBosses[mainBossType])
  local MainBossModule=this.bossModules[mainBossType]
  local mainBossFaction=MainBossModule.eventParams[mainSubType] and MainBossModule.eventParams[mainSubType].faction or (MainBossModule.eventParams.DEFAULT and MainBossModule.eventParams.DEFAULT.faction)
  local selectedBosses={}
  selectedBosses[mainBossType]=mainSubType
  if ivars.bossEvent_combinedAttacks>0 then
    if Ivars.bossEvent_combinedAttacks:Is("FACTION") then
      for bossType,subTypes in pairs(enabledBosses)do          
        local filtered={}
        if bossType~=mainBossType then
          local BossModule=this.bossModules[bossType]
          for i,subType in ipairs(subTypes)do
            local faction=BossModule.eventParams[subType] and BossModule.eventParams[subType].faction or BossModule.eventParams.DEFAULT.faction
            InfCore.Log("bossEvent_combinedAttacks FACTION "..mainSubType..":"..tostring(mainBossFaction).." "..subType..":"..tostring(faction))
            if faction and mainBossFaction and faction==mainBossFaction then
              table.insert(filtered,subType)
            end
          end--for subTypes
        end
        --tex NOTE: mainBossType is also removed by this
        if #filtered==0 then filtered=nil end
        enabledBosses[bossType]=filtered
      end--for enabledBosses
    end--if FACTION

    enabledBossesList=KeysToList(enabledBosses)
    for i,bossType in ipairs(enabledBossesList)do
      local subType=InfUtil.GetRandomInList(enabledBosses[bossType])
      local BossModule=this.bossModules[bossType]
      --tex TODO ethink, this is really just to choose whether to include or not
      --possibly need to manage total attack size too if num bosses grows
      local minBosses=0
      local maxBosses=#BossModule.infos[subType].objectNames
      local numBosses=math.random(minBosses,maxBosses)
      if numBosses>0 then
        selectedBosses[bossType]=subType
      end
    end
  end--if combinedAttacks

  InfCore.PrintInspect(selectedBosses,"selectedBosses")

  for bossType,subType in pairs(selectedBosses)do
    local BossModule=this.bossModules[bossType]
    local minBosses=1
    local maxBosses=#BossModule.infos[subType].objectNames
    local numBosses=math.random(minBosses,maxBosses)
    --tex boss is hard coded for a certain number of instances, see InfBossTppParasite2 Behaviors/Quirks
    --we are still letting random above to select 0 though
    --for non hardcodedCount solo bosses are simply defined by single entry in names list, reguardless of actual locator count
    if BossModule.hardcodedCount or not Ivars[BossModule.ivarNames.variableBossCount]:Is(1) then
      numBosses=maxBosses
    end
    BossModule.SetBossSubType(subType,numBosses)
  end--for selectedBosses

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

  TimerStop("Timer_BossCountdown")--tex may still be going from self start vs Timer_BossEventMonitor start

  if svars.bossEvent_attackCountdown>0 then
    --tex via bossEvent_attackCountdown we only run the timer for some division (countdownSegmentMax) of the total time
    --so that on a reload it wont be postponed the full timespan
    --see CalculateAttackCountdown
    InfCore.Log("StartBossCountdown countdown:"..svars.bossEvent_attackCountdown.."mins: next tick in "..countdownInterval.."sec",this.debugModule)--DEBUG
    TimerStart("Timer_BossCountdown",countdownInterval)
    return
  end
  
  if startNow then
    InfCore.Log("StartBossCountdown startNow",this.debugModule)--DEBUG
  else
    --tex TODO: anyway to differentiate between first start and continue?
    InfCore.Log("StartBossCountdown countdown: 0",this.debugModule)--DEBUG
  end

  this.StartEvent()
  --end,time)--
end--StartCountdown
--Timer started by StartCountdown
function this.Timer_BossCountdown()
  InfCore.Log("InfBossEvent.Timer_BossCountdown")

  --tex timer period (1 minute) is only part of the whole event countdown period, and it restarts timer after it ticks down
  --which gives a rough way to prevent the start event being postponed for the full period on reload
  svars.bossEvent_attackCountdown=svars.bossEvent_attackCountdown-1
  InfCore.Log("InfBossEvent.Timer_BossCountdown: svars.bossEvent_attackCountdown: "..tostring(svars.bossEvent_attackCountdown))
  this.StartCountdown()
end--Timer_BossCountdown

function this.StartEvent()
  InfCore.Log("InfBossEvent.StartEvent")
  this.ChooseBossTypes(vars.missionCode)
  this.InitEvent()

  TimerStop"Timer_BossUnrealize"--tex unloads old event blocks, so stop it since it may still be running after we've loaded the new ones

  for bossType,BossModule in pairs(this.bossModules)do
    if BossModule.currentSubType~=nil then
      --tex only has a blockId if theres a ScriptBlockData entity with the name 
      --(in this case its loaded via AddMissionPacks > BossModule.packages.scriptBlockData)
      --DEBUGNOW: may want to load reguardless so ChooseBossTypes can be done in-mission at each event kickoff 
      local blockId=ScriptBlock.GetScriptBlockId(bossType.."_block")
      InfCore.Log("BossStartEvent "..bossType.." blockId:"..tostring(blockId))
      if blockId==ScriptBlock.SCRIPT_BLOCK_ID_INVALID then
        InfCore.Log("ERROR: BossStartEvent "..bossType.." blockId==SCRIPT_BLOCK_ID_INVALID")
      else
        local packages=BossModule.currentInfo.packages
        if packages==nil then
          InfCore.Log("ERROR: InfBossEvent.StartEvent: "..bossType.." info packages==nil")
          packages=""--tex ScriptBlockLoad with "" actually unloads any existing TODO: see if nil does too?
        end
        
        if this.debugModule then
          InfCore.PrintInspect(packages,bossType.." packages")
        end
        ScriptBlock.Load(blockId,packages)
        ScriptBlock.Activate(blockId)
      end
    end--if currentSubType
  end--for bossModules

  --tex actually start
  --tex need some leeway between wather start and boss aprear
  this.StartEventWeather()
  local parasiteAppearTime=math.random(bossAppearTimeMin,bossAppearTimeMax)
  TimerStart("Timer_BossAppear",parasiteAppearTime)
end--StartEvent

--Timer started by above, and Timer_BossEventMonitor
function this.Timer_BossAppear()
  InfCore.PCallDebug(function()--DEBUG
    InfCore.LogFlow("InfBossEvent.Timer_BossAppear")

    --tex KLUDGE wait for boss scriptblocks
    --could shift the bossappear call to BossModule OnScriptBlockStateTransition
    --but would need to think how to handle the singular focuspos
    --or could just repond to OnScriptBlockStateTransition and check allReady there
    --in practice the StartEvent > Timer_BossAppear is enough time anyway and it wont hit this
    local allReady=true
    for bossType,BossModule in pairs(this.bossModules)do
      if BossModule.currentSubType~=nil then
        local blockId=ScriptBlock.GetScriptBlockId(BossModule.blockName)
        local blockState=ScriptBlock.GetScriptBlockState(blockId)
        if blockState~=ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE then
          allReady=false
        end
      end
    end--for bossModules
    if not allReady then
      InfCore.Log("Not all Boss scriptblocks active, delaying")
      local delayTime=5
      TimerStart("Timer_BossAppear",delayTime)
      return
    end

    local playerPos={vars.playerPosX,vars.playerPosY,vars.playerPosZ}
    local closestCpPos=playerPos
    local closestCpDist=999999999999999

    local isMb=vars.missionCode==30050 or vars.missionCode==30250

    local closestCp,cpDistance,cpPosition=InfMain.GetClosestCp(playerPos)
    if closestCp==nil or cpPosition==nil then
      InfCore.Log("WARNING: InfBossEvent.Timer_BossAppear closestCp==nil")--DEBUG
      closestCpPos=playerPos
    else
      this.currentCp=closestCp
      this.currentCpPosition=cpPosition
    end--if closestCp

    local zombifies=false
    for bossType,BossModule in pairs(this.bossModules)do
      if BossModule.currentSubType~=nil then
        InfCore.Log("BossAppear "..BossModule.currentSubType.." closestCp:"..tostring(closestCp),this.debugModule)

        --tex anywhere but playerPos needs more consideration to how discoverable the bosses are
        --CAMO will start heading to cp anyway because they rely on the routes, 
        --so its more important that they start where player will notice
        this.SetFocusOnPlayerPos()
        
        local appearPos=playerPos
        BossModule.Appear(appearPos,closestCp,closestCpPos,BossModule.currentParams.spawnRadius+math.random(5))

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
end--ZombifyFree

--localopt
local monitorPlayerPos={}
local monitorFocusPos={}
local monitorBossPos={}
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
      escapeDistanceSqr=ivars.bossEvent_escapeDistance^2
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
  
  --tex check too close to boss
  --tex GOTCHA: TppParasites aparently dont support GetPosition, frustrating inconsistancy, you'd figure it would be a function of all gameobjects
  for bossType,BossModule in pairs(this.bossModules)do
    if BossModule.currentSubType~=nil then
      for index=1,BossModule.numBosses do
        local name=BossModule.currentInfo.objectNames[index]
        if BossModule.IsReady(index) then
          local gameId=GetGameObjectId(bossType,name)
          if gameId~=NULL_ID then
            local bossPos=SendCommand(gameId,{id="GetPosition"})
            if bossPos==nil then
              break--tex this type doesnt support GetPosition DEBUGNOW revisit if you expand bossObjectTypes
            end
            InfUtil.SetArrayPos(monitorBossPos,bossPos:GetX(),bossPos:GetY(),bossPos:GetZ())
            local distSqr=TppMath.FindDistance(monitorPlayerPos,monitorBossPos)
            --InfCore.Log("EventMonitor: "..name.." dist:"..math.sqrt(distSqr),this.debugModule)--DEBUG
            if distSqr<escapeDistanceSqr then
              if this.debugModule then
                InfCore.Log("EventMonitor: boss position < escapeDistance",this.debugModule)
              end
              outOfRange=false
              break
            end
          end--if gameId
        end--if IsReady
      end--for currentBossNames
    end--if currentSubType
  end--for bossModules

  if not outOfRange then
    --tex TppBossQuiet has a real discoverablitiy problem not just literraly being stealth units but needing to be off by a cp
    --this basically just repoitions them to a new cp, by way of appearing again
    local closestCp,cpDistanceSqr,cpPosition=InfMain.GetClosestCp(monitorPlayerPos)
    if closestCp==nil or cpPosition==nil then
      InfCore.Log("WARNING: InfBossEvent.Timer_BossEventMonitor closestCp==nil")--DEBUG
    elseif closestCp~=this.currentCp then
      if this.debugModule then
        InfCore.Log("BossEventMonitor closestCp~=this.currentCp")
      end
      for bossType,BossModule in pairs(this.bossModules)do
        if BossModule.currentSubType~=nil then
          if BossModule.updateToClosestCommandPost then
            if GetRawElapsedTimeSinceStartUp()>((this.lastContactTime-ivars.bossEvent_timeOut)+BossModule.changeCpTime) then--tex KLUDGE lastContactTime is actually essentially timer/future value 
              InfCore.Log("BossEventMonitor lastContact > changeCpTime",this.debugModule)
              this.currentCp=closestCp
              this.SetFocusOnPlayerPos()
              BossModule.Appear(monitorPlayerPos,closestCp,cpPosition,BossModule.currentParams.spawnRadius+math.random(5))
            end
          end
        end
      end--for bosmodules
    end--if closestCp
  end--if not outOfRange
  
  --tex I think my original reasoning here for only mist and not armor was that 'mist is chasing you'
  --DEBUGNOW but since TppParasite2 doesnt have GetPosition it might be a bit weird in situations where ARMOR are still right near you
  --since you just nead to get out of focusPos range (their appear pos, or last contact pos) so I might have to add them too
  --but the mist already do chase you if they are aware of you
  --its camo that needs help repositioning if I want them to chase
--DEBUGNOW TODO: eventParams.chase or something
  -- if this.bossSubType=="MIST" then
  --  local playerChaseRangeSqr=ivars.bossEvent_playerChaseRange^2
  --   if focusPosDistSqr>playerChaseRangeSqr then
  --     InfCore.Log("EventMonitor: > playerChaseRangeSqr",this.debugModule)
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

  local endEvent=false
  if outOfRange and outOfContactTime then
    InfCore.Log("EventMonitor: out of range and outOfContactTime :"..math.sqrt(focusPosDistSqr).."> "..math.sqrt(escapeDistanceSqr).. ", ending event",this.debugModule)
    endEvent=true
  end

  if this.IsAllCleared() then
    InfCore.Log("EventMonitor: IsAllCleared")
    endEvent=true
  end

  if endEvent then
    this.EndEvent()
    this.StartCountdown()--tex start event countdown again (EndEvent resets bossEvent_attackCountdown)
    return
  end

  TimerStart("Timer_BossEventMonitor",monitorRate)--tex start self again
  --end)--
end--Timer_BossEventMonitor

function this.StopTimers()
  local timers={
    "Timer_BossCountdown",
    "Timer_BossAppear",
    "Timer_BossCombat",
    "Timer_BossEventMonitor",
    "Timer_BossUnrealize",
    "Timer_AppearToInitialRoute",--InfBossTppBossQuiet2
  }
  for i,timerName in ipairs(timers)do
    TimerStop(timerName)
  end
end--StopTimers

function this.EndEvent()
  InfCore.Log("InfBossEvent.EndEvent",this.debugModule)

  TppWeather.CancelForceRequestWeather(TppDefine.WEATHER.SUNNY,7)

  for bossType,BossModule in pairs(this.bossModules)do
    BossModule.EndEvent()
  end

  --tex TODO throw CAMO parasites to some far route (or warprequest if it doesn't immediately vanish them) then Off them after a while

  TimerStop("Timer_BossEventMonitor")

  TimerStart("Timer_BossUnrealize",40)--tex should be less than countdown period

  for bossType,BossModule in pairs(this.bossModules)do
    BossModule.ClearBossSubType()
  end

  svars.bossEvent_eventCount=svars.bossEvent_eventCount+1
  
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
    local blockId=ScriptBlock.GetScriptBlockId(bossType.."_block")
    ScriptBlock.Load(blockId,"")--tex unloads
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

function this.SetFocusOnPlayerPos()
  this.lastContactTime=GetRawElapsedTimeSinceStartUp()+ivars.bossEvent_timeOut
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
  end--for objectNames
  if this.debugModule then
    InfCore.PrintInspect(indexTable,this.name..".BuildGameIdToNameIndex indexTable")
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
