-- InfMBVisit.lua
-- tex implements mbMoraleBoosts and revengeDecayOnLongMbVisit
local this={}

--TUNE tex TODO: do I want to fuzz these?
local rewardOnSalutesCount=14--12 is nice if stacking since it's a division of total, but it's just a smidgen too easy for a single TODO: currently not taking into account increased soldiers
local rewardOnClustersCount={
  [5]=true,
  [7]=true
}
local rewardOnVisitDaysCount=3
local revengeDecayOnVisitDaysCount=3

--STATE
local saluteClusterCounts={}
local visitedClusterCounts={}
local visitDaysCount=0

local lastSalute=0

local saluteRewards=0
local clusterRewards={}
local longVisitRewards=0
local revengeDecayCount=0

--tex TODO: script reload support?

this.registerIvars={
  "mbMoraleBoosts",
  "revengeDecayOnLongMbVisit",
  "mbIncreaseStaffSaluteReactions",
}

this.mbMoraleBoosts={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.revengeDecayOnLongMbVisit={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  MissionCheck=IvarProc.MissionCheckMbAll,
}

this.mbIncreaseStaffSaluteReactions={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  MissionCheck=IvarProc.MissionCheckMbAll,
}
--<
this.langStrings={
  eng={
    mbMoraleBoosts="Staff-wide morale boost for good visit",
    mb_morale_visit_noticed="Word has spread of your visit",
    mb_morale_boosted="Staff-wide morale has improved due to your visit",
    revengeDecayOnLongMbVisit="Enemy prep decrease on long MB visit",
    mb_visit_revenge_decay="Enemy prep has decreased during your absence from the field",
  },
  help={
    eng={
      revengeDecayOnLongMbVisit="Spend a number of game days (break out that cigar) during a mother base visit and enemy prep levels will decrease on leaving. Currently reduces after 3 days (stacking), reduces the same as chicken hat ",
      mbMoraleBoosts="Gives a staff-wide morale boost on having a number of soldiers salute (most of a cluster), visiting a number of clusters (with at least one salute on each), or staying in base a number of game days (break out that cigar). Must leave the base via heli for it to apply.",
    },
  }
}

function this.Init(missionTable)
  this.messageExecTable=nil

  if not IvarProc.MissionCheckMbAll() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  this.ClearMoraleInfo()
end

function this.OnReload(missionTable)
  this.messageExecTable=nil

  if not IvarProc.MissionCheckMbAll() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnMissionCanStart()
  --tex don't mission filter since it needs to unregister clock (see the function)
  this.StartLongMbVisitClock()
end

function this.OnMissionGameEnd()
  if not IvarProc.MissionCheckMbAll() then
    return
  end
  this.CheckMoraleReward()
end

function this.Messages()
  return Tpp.StrCode32Table{
    GameObject={
      {msg="SaluteRaiseMorale",func=this.CheckSalutes},
    },
    Weather = {
      {msg="Clock",sender="MbVisitDay",func=this.OnMbVisitDay},
    },
  }
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.ClearMoraleInfo()
  for i=1,#InfMain.CLUSTER_NAME+1 do
    saluteClusterCounts[i]=0
    visitedClusterCounts[i]=false
  end
  visitDaysCount=0

  saluteRewards=0
  for n,bool in pairs(rewardOnClustersCount) do
    clusterRewards[n]=false
  end
  longVisitRewards=0

  revengeDecayCount=0

  lastSalute=0
end

function this.PrintMoraleInfo()
  InfCore.DebugPrint("saluteRewards:"..saluteRewards)
end

function this.GetTotalSalutes()
  local total=0
  for i=1,#InfMain.CLUSTER_NAME+1 do
    total=total+saluteClusterCounts[i]
  end
  return total
end

--tex on SaluteRaiseMorale msg
function this.CheckSalutes(saluterGameId)
  --InfCore.PCall(function()--DEBUG
  --tex already mission filtered
  if Ivars.mbMoraleBoosts:Is(0) then
    return
  end

  if vars.missionCode==30250 then--PATCHUP
    rewardOnSalutesCount=6--tex not so many out there, plus they get lonely
  end

  local currentCluster=mtbs_cluster.GetCurrentClusterId()

  saluteClusterCounts[currentCluster]=saluteClusterCounts[currentCluster]+1
  local totalSalutes=this.GetTotalSalutes()
  --InfCore.DebugPrint("SaluteRaiseMorale cluster "..currentCluster.." count:"..saluteClusterCounts[currentCluster].. " total sulutes:"..totalSalutes)--DEBUG
  --InfCore.PrintInspect(saluteClusterCounts)--DEBUG

  local modTotalSalutes=totalSalutes%rewardOnSalutesCount
  --InfCore.DebugPrint("totalSalutes % rewardSalutesCount ="..modTotalSalutes)--DEBUG
  if modTotalSalutes==0 then
    saluteRewards=saluteRewards+1
    --InfCore.DebugPrint("REWARD for "..totalSalutes.." salutes")--DEBUG
    InfMenu.PrintLangId"mb_morale_visit_noticed"
  end

  local totalClustersVisited=0
  for clusterId,saluteCount in pairs(saluteClusterCounts) do
    if saluteCount>0 then
      totalClustersVisited=totalClustersVisited+1
    end
  end
  --InfCore.DebugPrint("totalClustersVisited:"..totalClustersVisited)--DEBUG
  if rewardOnClustersCount[totalClustersVisited] and clusterRewards[totalClustersVisited]==false then
    clusterRewards[totalClustersVisited]=true
    --InfCore.DebugPrint("REWARD for ".. totalClustersVisited .." clusters visited")--DEBUG
    InfMenu.PrintLangId"mb_morale_visit_noticed"
  end

  lastSalute=Time.GetRawElapsedTimeSinceStartUp()
  --end)--
end

function this.CheckMoraleReward()
  --tex already mission filtered
  if Ivars.mbMoraleBoosts:Is(0) then
    return
  end

  local moraleBoost=0
  --tex was considering stacking, but even at the minimum 1 it's close to OP with a large staff size
  --actually with the standard morale decay, and making it take some effort to get in the first place it should be ok

  for numClusters,reward in pairs(clusterRewards) do
    if reward then
      moraleBoost=moraleBoost+1
    end
  end

  if saluteRewards>0 then
    moraleBoost=moraleBoost+saluteRewards
  end

  if longVisitRewards>0 then
    moraleBoost=moraleBoost+longVisitRewards
  end

  --InfCore.DebugPrint("Global moral boosted by "..moraleBoost.." by visit")--DEBUG
  if moraleBoost>0 then
    InfMenu.PrintLangId"mb_morale_boosted"
    TppMotherBaseManagement.IncrementAllStaffMorale{morale=moraleBoost}
  end
end

function this.GetMbVisitRevengeDecay()
  if visitDaysCount>0 then
    return revengeDecayCount
  end
  return 0
end

--GOTCHA: it's a clock time that registered, so registering current + 12 hour will trigger first in 12 hours, then again in 24
--so just register current time if you want 24 from start
--REF
--lvl 1 cigar is 6 cigars of 12hr so 3 day, 1 cigar about 15-17 seconds (takes a couple of seconds anim before time actually starts accell)
--lvl 2 is 8 cigars of 24hr so 8 days, ~28 seconds realtime
--lvl 3 is 10 cigars of 36hr so 15 days ~40 seconds
function this.StartLongMbVisitClock()
  if not IvarProc.MissionCheckMbAll() then
    TppClock.UnregisterClockMessage("MbVisitDay")
    return
  end

  if Ivars.mbMoraleBoosts:Is(0) then
    return
  end

  visitDaysCount=0

  local currentTime=TppClock.GetTime("number")
  InfCore.Log"RegisterClock MbVisitDay"
  TppClock.RegisterClockMessage("MbVisitDay",currentTime)
end

--tex on 24hr Clock msg
function this.OnMbVisitDay(sender,time)
  if not IvarProc.MissionCheckMbAll() then
    return
  end

  InfCore.Log"OnMbVisitDay"--DEBUG
  visitDaysCount=visitDaysCount+1
  if visitDaysCount>0 then
    local modLongVisit=visitDaysCount%rewardOnVisitDaysCount
    if modLongVisit==0 then
      longVisitRewards=longVisitRewards+1
      InfMenu.PrintLangId"mb_morale_visit_noticed"
    end
    local modRewardDecay=visitDaysCount%revengeDecayOnVisitDaysCount
    if modRewardDecay==0 then
      revengeDecayCount=revengeDecayCount+1
      -- TODO message?
    end
  end
end

function this._ReduceRevengePointByTime(missionId)
  if not Ivars.revengeDecayOnLongMbVisit:EnabledForMission() then
    return
  end

  --  if this.IsNoRevengeMission(missionId)then
  --    return
  --  end
  if bit.band(vars.playerPlayFlag,PlayerPlayFlag.USE_CHICKEN_CAP)==PlayerPlayFlag.USE_CHICKEN_CAP then
    return
  end

  local getMbVisitRevengeDecay=this.GetMbVisitRevengeDecay()
  if getMbVisitRevengeDecay>0 then
    InfMenu.PrintLangId"mb_visit_revenge_decay"
    local TppRevenge=TppRevenge
    for i=1,getMbVisitRevengeDecay do
      TppRevenge._ReduceRevengePointStealthCombat()
      TppRevenge._ReduceRevengePointOther()
    end
  end
end

--CALLER: TppEnemy.SetSaluteVoiceList
function this.SetSaluteVoiceList()
  if not GameObject.DoesGameObjectExistWithTypeName"TppSoldier2"then
    return
  end
  InfCore.LogFlow("InfSoldier.SetSaluteVoiceList")--tex DEBUG
  --LOCALOPT:
  local TppMotherBaseManagement=TppMotherBaseManagement
  local TppMotherBaseManagementConst=TppMotherBaseManagementConst
  local table=table

  local highList={}
  local highOnceList={}
  local midList={}
  local midOnceList={}
  local lowList={}
  local lowOnceList={}

  --tex from DEBUGNOW ?? speachLabels
  lowList={
    --other voice labels that have nothing to do with salute but might be cool to include:
    --Enemy Voices Sneak (NORMAL/player not spotted status)
    --"EVS040",--"very soft Phew/Ahh",},-- Relaxing --OFF too soft
    --"EVS060",--"(exersion) Hmph/Hup",},--Light exertion lines
    --"EVS090",--"Rrrgh",},--Soldier gets something in his eye.
    "EVS100",--"(tired) sigh",},--
    "EVS110",--"(frustrated) Dammit",},--Irritated
    "EVS120",--"He's taking so long...",},--Waiting for comrade - General purpose
    "EVS130",--"(to self) I'm going.",},--Can't bear waiting any longer, goes alone

    --Enemy Voiced Notice
    --"EVN060",--"soft huh?",},-- From nearby: Enemy spots something
    --"EVN070",--"real soft hmm",}, -- From nearby: Checking it out --OFF too soft
    "EVN080",--"you there!|hey!",}, -- From nearby: Spotted something suspicious

    --"EVN100",--"soft sigh",}, -- From nearby: Nothing spotted --OFF too soft
    --"EVN110",--"soft huh?!",}, -- Heard a knock, footsteps, or other unusual noise-- OFF too soft
    "EVN120",--"The hell?!|Wha-?!|What was that?!",},-- Reacting to an explosion or other loud noise
    "EVN130",--"soft Hm? Huh...",}, -- Checking last known position
    --"EVN140",--"He's here!",}, -- Spotting a suspicious person while searching/on guard, and engaging him
    --"EVN150",--"Contact!|Hostile!",}, --The suspicious person spotted has been identified as an enemy (the player) and is engaged.
    "EVN170",--"Hey - look over there.",},--Spotting something suspicious, and attracting a comrade's attention.
    "EVN180",--"Hey, that guy over there - who is it?",},--Spotted an intruder, getting a comrade to check it out.
    "EVN190",--"Fine, I'll check it out.",},--Responses to EV170, EV180.
    "EVN200",--"Fine, I'll check it out.",},--Responses to EV170, EV180.
    "EVN210",--"There's nothing there..",},--Responses to EV170, EV180.
    "EVN220",--"You see somebody there?",},--Nearby comrade suddenly checks something out.
    -- "EVN230",--"Gotta check it. Let's go.",},--Going in a pair to check it out.
    "EVN240",--"Got it.",},--Responses to EVN230.
    "EVN250",--"I'll go check it out.",},--Spotter goes to check it out himself.
    "EVN260",--"Go for it, I'll wait here.",},--Responses to EV250.
    "EVN270",--"My imagination, it's nothing.",},--
    --"EVN280",--"I'm relieving you.",},--not working, need condition? Relieving a sentry
    --"EVN290",--"Heeey, I'm relieving you!",},--not working, need condition? Relieving a sentry (shouted from a distance).
    "EVN300",--"What's the matter, boy? (talking to dog)",},--Asking a barking dog what's up.
    "EVN301",--"Calming the dog.",},--
    "EVN310",--"Shut up, you stupid mutt.",},--Telling a barking dog to shut up.
    --"EVN320",--"S-Somebody get over here!",},--interrogate: "Call out"
    --"EVN330",--"Can I get a hand over here? One guy's fine!",},--not working, need condition? interrogation: 'Call one guy',--
    "EVN331",--"Be right there.",},--Responding to being called.
    "EVN340",--"Come here a second.",},--Calling comrades (close range)
    "EVN341",--"Need a hand here!",},--Calling comrades (long range)


    --"EVN311",--"Shoo, shoo! (to animal)",},--chasing away an animal
    "EVN312",--"Get Lost! (to animal angry)",},--
    "EVN350",--"cursing something (multi-purpose)",},--

    --Enemy Voices Reaction
    "EVR010",--"(shock) What the!",}, --
    "EVR011",--"(shock,extreme) Huh!",}, --
    "EVR012",--"(shock,little) Ah!",}, --
    --"EVR020",--"Shit! Enemy fire!",}, --Taking gunfire
    --"EVR050",--"(Surprised at the bullet impact) Ah",}, --not working--Takes fire and looks around to spot the player, but is unable to find him and is tense/shaken.
    --"EVR061",--"Aaaahh (player gun on enemy)",}, --Player has their gun on the enemy,
    --"EVR062",--"Huh? Interrogated, no english",},--
    --"EVR063",--"Wh-what does that mean? (Ru/Af)",},--doesnt work Interrogated, but unable to understand English

    --"EVR070",--"hahh! (Short outbursts to steel himself.)",}, --Taking gunfirePlayer has their gun on the enemy, threatening him. Bold reactions.
    "EVR110",--"(see sleeping comrade) You lazy son of a...",--
    --"EVR130",--"Ew, Ughh etc (bad smell)"},--

    "EVR180",--"The hell you doing? (spotted hold-up)",}, --Spotting a comrade in hold-up status
    "EVR190",--"Fucking kidding me!"},--Enemy responses when CP rejects their requests for reinforcement.
    "EVR220",--"(chuckles)",},--spotted Snake while he's wearing the chicken hat
    "EVR230",--"(chuckles)",},--spotted Snake while he's wearing the chicken hat

    --Enemy Voices Damage/Status changes
    --"EVD070",--"General coughs.",},--doesnt seem to trigger, needs condition?

    --Enemy Voices Battle
    "EVB010",--"Small psych-up shouts.",},
    "EVB030",--"Big psych-up shouts.",},
    --"EVB040",--"Mammoth psych-up shouts.",},--doesnt seem to trigger, needs condition?

    --Enemy Voices Comrades (Battle,Teamwork)
    "EVC200",--"Watch out!",},--Warning calls.
    --"EVC250",--"Go! (to comrades)",},
    "EVC260",--"Go go go! (to comrades)",},
    "EVC320",--"Check your ammo! (to comrades)",},
    "EVC330",--"I'm OK (to comrades)",},
    "EVC340",--"You OK? (to comrades)",},
    "EVC400",--"(In battle, tense) Copy!",},
    --Enemy Voices E? Post-combat voices - Caution
    "EVE030",--"Roger that!",},--Checking last known point of contact (response)
    "EVE040",--" Hold it.",},--Clearing. Halt orders.
    "EVE050",--"Clear.",},--Clearing. Announcing clear
    "EVE110",--"Find 'em?!"},--
    "EVE120",--"Not here."},-- post-combat_caution dialog answer to 110
    "EVE130",--"I'll look over here."},
    --"EVE140",--"You try over that way."},--
    --"EVE150",--"Search complete! Search complete!"},--
    --"EVE160",--"Returning to post. Stay on the lookout."},--
    "EVE170",--"All clear, all clear!"},
    "EVE180",--"Get back to your post."},

    --Enemy soldier lines: EVSP
    "EVSP100",--"Spill it!",}, --interrogation spill it
    --"EVSP110",--"Don't lie to me!",}, --110 looks like its listed twice but its combined?
    --"EVSP110",--"State your mission!",}, --
    --"EVSP120",--"Do you WANT to die",}, --
    "EVSP130",--"Found it!",}, --found something they were looking for


    --Enemy Voices Fight?
    "EVF010",--"Boss!",},--default saluting boss. --TODO: in theory could filter this if playerType isnt snake/avatar (though some of the other lines that dont meet conditions seem to default to this line)
    "EVF020",--"its an honor boss|dont pull any punches",}, ----no ref,  Greeting Boss before practice:
    "EVF030",--"boss, thats not quite right|boss, um with all due respect",}, --no ref,-- Multipurpose lines for when player fails to do something correctly:
    "EVF040",--"thank you boss!",}, --no ref, the standard cqc reaction

    --TODO: is there a last mission result var anywhere to drive this?
    "salute0010",--"great work on that mission",},--no ref, After completing a mission (score: high)
    "salute0020",--"nice job on that mission",}, --no ref, After completing a mission (score: medium)
    "salute0030",--"that was a pretty rough mission",}, --no ref, ・After completing a mission (score: low)
    --<
    -- already used "salute0040",--"good to have you back boss",}, -- After Boss returns (they"re happy to see him)
    -- already used "salute0050",--"long time no see",}, -- ・Boss returns after a long time away
    -- already used "salute0060",--"welcome home boss",}, --- with warmth ・General-purpose lines after Boss returns
    --!  "salute0070",--"boss? what is..? uhh never mind|thats a.. interesting hat youve got there",},-- spoken uncertainly. ----no ref, ・After Boss returns (when wearing chicken hat) (prep)
    -- already used "salute0080",--"welcome back boss",},-- often said with trepidation, other times sounds normal. -- ・Boss"s "demon level" has exceeded a certain point
    -- already used "salute0090",--"we need more personel",},
    -- already used "salute0100",--"we cant get by with so few staff",},
    --! "salute0110",--"thanks for bringing in more guys",},--no ref,
    -- already used "salute0120",--"starting to get a little crowded here",},
    --!  "salute0130",--"thanks for upgrading the base|for expanding",},--no ref,
    --!  "salute0140",--"that new weapon is just what we needed boss",},--no ref,
    -- already used "salute0150",--"boss, we still in the red?",},
    -- already used "salute0160",--"we're ready to develop new equipment",},
    -- already used "salute0170",--"do you think you can bring in more materials?",},
    "salute0180",--"train with me",},
    -- already used "salute0190",--"boss! you, me, mock battle, what do you say?",},
    -- already used "salute0200",--"i'm ready for a dispatch. send me on a mission",},
    --!  "salute0210",--"damage to the fob is getting serious, you need to review fob security",}, --no ref,  for after fob attack i guess
    "salute0220",--"whatever supplies you need, let us know",},
    -- already used "salute0230",--"we're here for you if you need combat support",},
    -- already used "salute0240",--"boss, thanks for saving that puppy",},
    -- already used "salute0250",--"i hope you keep that woman locked up boss",},
    -- already used "salute0260",--"do you think you could bring back more medicinal plants?",},
    -- already used "salute0270",--"you have to rescue our men",},
    -- already used "salute0280",--"you need to put an end to the infection boss",},
    -- already used "salute0290",--"thanks for taking in those children",},
    -- already used "salute0300",--"thank you for getting those animals out boss",},
    "salute0310",--"how's it going boss?",},
    "salute0320",--"boss good moring|have a good day boss",}, -- condition: must actually be morning ?
    -- already used "salute0330",--"thank you for rescuing our men boss",},
    -- already used "salute0340",--"thank you for ending the infection",},
    -- already used "salute0350",--"boss, now our guys can rest in peace. thank you for what you did with the diamonds",},
    -- already used "salute0360",--"thank you for stopping the infection boss",},--with more emotion
    -- already used  "salute0370",--"boss, whoever you are, youre still my CO",},
    -- already used "salute0380",--"happy birthday boss",},
    --!  "salute0390",--"congratulations on the decomissioning boss",}, -- no ref,  ・After abolishing nuclear weapons
    --!  "salute0400",--"congratulations",}, -- --no ref ・General-purpose congratulatory greeting
    "salute0410",--"uh, how about taking a shower after a mission?",},--When Boss stinks - requires condition
    "salute0420",--"thank you for letting me join diamond dogs",},--  New recruit who was just extracted? - requires condition?
  --! "salute0430",--"boss! I new you were alive!|its.. its you boss",},--no ref amazed -- ●NPC lines: when reuniting with soldiers who were at the old Mother Base (survivors of 9 years ago)
  --> anything higher is silence/no table
  }--lowList

  local storySequence=gvars.str_storySequence
  --tex TODO:  does this sound ok multiple times in a visit?
  if TppMotherBaseManagement.GetOgrePoint()>=5e4 then
    table.insert(highOnceList,"salute0080")--'welcome back boss', often said with trepidation, other times sounds normal.
    table.insert(lowList,"salute0080")--tex low as well
  elseif Player.GetSmallFlyLevel()>=5 then
    table.insert(highOnceList,"salute0050")--'long time no see'
    table.insert(lowList,"salute0050")--tex low as well
  elseif Player.GetSmallFlyLevel()>=3 then
    table.insert(highOnceList,"salute0040")--'good to have you back boss'
    table.insert(lowList,"salute0040")--tex low as well
  else
    table.insert(highOnceList,"salute0060")--'welcome home boss', with warmth
    table.insert(lowList,"salute0060")--tex low as well
  end
  local staffcount=TppMotherBaseManagement.GetStaffCount()
  local staffLimit=0
  local GetSectionMax=TppMotherBaseManagement.GetSectionStaffCountLimit
  staffLimit=staffLimit+GetSectionMax{section=TppMotherBaseManagementConst.SECTION_COMBAT}
  staffLimit=staffLimit+GetSectionMax{section=TppMotherBaseManagementConst.SECTION_DEVELOP}
  staffLimit=staffLimit+GetSectionMax{section=TppMotherBaseManagementConst.SECTION_BASE_DEV}
  staffLimit=staffLimit+GetSectionMax{section=TppMotherBaseManagementConst.SECTION_SUPPORT}
  staffLimit=staffLimit+GetSectionMax{section=TppMotherBaseManagementConst.SECTION_SPY}
  staffLimit=staffLimit+GetSectionMax{section=TppMotherBaseManagementConst.SECTION_MEDICAL}
  staffLimit=staffLimit+GetSectionMax{section=TppMotherBaseManagementConst.SECTION_SECURITY}
  local percentageFull=staffcount/staffLimit
  if percentageFull<.2 then
    table.insert(lowList,"salute0100")--'we cant get by with so few staff'
  elseif percentageFull<.4 then
    table.insert(lowList,"salute0090")--'we need more personel'
  elseif percentageFull<=.8 then
    table.insert(lowList,"salute0110")--"thanks for bringing in more guys"--tex added
  elseif percentageFull>.8 then
    table.insert(lowList,"salute0120")--'starting to get a little crowded here'
  end
  if TppMotherBaseManagement.GetGmp()<0 then
    table.insert(lowList,"salute0150")--'boss, we still in the red?'
  end
  if TppMotherBaseManagement.GetDevelopableEquipCount()>8 then
    table.insert(lowList,"salute0160")--'we're ready to develop new equipment'
  end
  if(TppMotherBaseManagement.GetResourceUsableCount{resource="CommonMetal"}<500
    or TppMotherBaseManagement.GetResourceUsableCount{resource="FuelResource"}<200)
    or TppMotherBaseManagement.GetResourceUsableCount{resource="BioticResource"}<200 then
    table.insert(lowList,"salute0170")--'do you think you can bring in more materials?'
  end
  if TppMotherBaseManagement.IsBuiltFirstFob()then
    table.insert(lowList,"salute0190")--'boss! you, me, mock battle, what do you say?'
  end
  if TppTerminal.IsReleaseSection"Combat"then
    table.insert(lowList,"salute0200")--'i'm ready for a dispatch. send me on a mission'
  end
  if TppMotherBaseManagement.IsOpenedSectionFunc{sectionFuncId=TppMotherBaseManagementConst.SECTION_FUNC_ID_SUPPORT_BATTLE}then
    local n=TppMotherBaseManagement.GetSectionFuncRank{sectionFuncId=TppMotherBaseManagementConst.SECTION_FUNC_ID_SUPPORT_BATTLE}
    if n>=TppMotherBaseManagementConst.SECTION_FUNC_RANK_E then
      table.insert(lowList,"salute0230")--'we're here for you if you need combat support'
    end
  end
  if(TppBuddyService.DidObtainBuddyType(BuddyType.DOG)--[[and not TppBuddyService.CanSortieBuddyType(BuddyType.DOG)]])and not TppBuddyService.IsDeadBuddyType(BuddyType.DOG)then--tex keep the puppy comment even after he growd up
    table.insert(lowList,"salute0240")--'boss, thanks for saving that puppy'
  end
  if(TppBuddyService.DidObtainBuddyType(BuddyType.QUIET)--[[and not TppBuddyService.CanSortieBuddyType(BuddyType.QUIET)]])and not TppBuddyService.IsDeadBuddyType(BuddyType.QUIET)then--tex there will always be some people who are against quiet even after you pal around with her
    table.insert(lowList,"salute0250")--'i hope you keep that woman locked up boss'
  end
  if TppMotherBaseManagement.GetResourceUsableCount{resource="Plant2000"}<100 or TppMotherBaseManagement.GetResourceUsableCount{resource="Plant2005"}<100 then
    table.insert(lowList,"salute0260")--'do you think you could bring back more medicinal plants?'
  end
  if storySequence==TppDefine.STORY_SEQUENCE.CLEARD_TAKE_OUT_THE_CONVOY then--tex TODO ? can we make the same assumption that there's always men to rescue?
    table.insert(midList,"salute0270")--'you have to rescue our men'
  end
  if TppMotherBaseManagement.IsPandemicEventMode()or storySequence==TppDefine.STORY_SEQUENCE.CLEARD_FLAG_MISSIONS_BEFORE_MURDER_INFECTORS then
    table.insert(midList,"salute0280")--'you need to put an end to the infection boss'
  end
  if storySequence>=TppDefine.STORY_SEQUENCE.CLEARD_ELIMINATE_THE_POWS then--tex was ==, even after the kids have scarpered people can still think it was a good thing
    table.insert(lowList,"salute0290")--'thanks for taking in those children'--tex down to low
  end
  if TppTerminal.IsBuiltAnimalPlatform()then
    table.insert(lowList,"salute0300")--'thank you for getting those animals out boss'
  end
  if storySequence>=TppDefine.STORY_SEQUENCE.CLEARD_RESCUE_INTEL_AGENTS then--tex what men? lets just say even in end game you're constantly rescuing them via fobs, sideops, and those mission replays are actually new missions that happen to be mightily similar to past events lol
    table.insert(lowList,"salute0330")--'thank you for rescuing our men boss'--tex down to low
  end
  if storySequence>=TppDefine.STORY_SEQUENCE.CLEARD_METALLIC_ARCHAEA then--and storySequence<=TppDefine.STORY_SEQUENCE.CLEARD_OKB_ZERO then--tex
    table.insert(lowList,"salute0340")--'thank you for ending the infection'--tex down to low
  end
  if storySequence==TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS then--tex the emotion in salute0360 means it sounds out of place further from the even having occured, so keep it here
    table.insert(midList,"salute0350")--'boss, now our guys can rest in peace. thank you for what you did with the diamonds
    table.insert(midList,"salute0360")--'thank you for stopping the infection boss', with more emotion
  end
  if storySequence>TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS then--tex but in contrast to the above salute0350 sounds ok, but drop it to lowlist
    table.insert(lowList,"salute0350")--'boss, now our guys can rest in peace. thank you for what you did with the diamonds
  end
  if storySequence>=TppDefine.STORY_SEQUENCE.CLEARD_THE_TRUTH then
    table.insert(lowList,"salute0370")--'boss, whoever you are, youre still my CO'
  end
  if TppUiCommand.IsBirthDay()then
    table.insert(highList,"salute0380")--'happy birthday boss'
  end

  --tex> players pretty much constantly develop stuff, even at the end when they arent really developing much its an ok line at any time
  --see also salute0160
  if TppMotherBaseManagement.GetDevelopableEquipCount()<8 then
    table.insert(lowList,"salute0140")
  end

  --tex just assume player be expanding from arriving at mb onward
  if TppStory.IsMissionCleard(10030) then--Episode 2 - DIAMOND DOGS
    table.insert(lowList,"salute0130")--"thanks for upgrading the base|for expanding",},--no ref,
  end

  --TODO: find some good checks to make these fit
  --!  "salute0070",--"boss? what is..? uhh never mind|thats a.. interesting hat youve got there",},-- spoken uncertainly. ----no ref, ・After Boss returns (when wearing chicken hat) (prep)
  --!  "salute0210",--"damage to the fob is getting serious, you need to review fob security",}, --no ref,  for after fob attack i guess
  --!  "salute0390",--"congratulations on the decomissioning boss",}, -- no ref,  ・After abolishing nuclear weapons
  --!  "salute0400",--"congratulations",}, -- --no ref ・General-purpose congratulatory greeting
  --! "salute0430",--"boss! I new you were alive!|its.. its you boss",},--no ref, amazed -- ●NPC lines: when reuniting with soldiers who were at the old Mother Base (survivors of 9 years ago)
  --<
  
  InfCore.Log("#lowList:"..#lowList)--tex DEBUG
  --DEBUGNOW think there might be a limit?
  local max=63
  local actualLowList={}
  for i=1,max do
    local index=math.random(1,#lowList)
    table.insert(actualLowList,lowList[index])
    table.remove(lowList,index)
  end
  lowList=actualLowList

  local saluteVoiceList={high={normal=highList,once=highOnceList},mid={normal=midList,once=midOnceList},low={normal=lowList,once=lowOnceList}}
  local typeSoldier={type="TppSoldier2"}
  GameObject.SendCommand(typeSoldier,{id="SetSaluteVoiceList",list=saluteVoiceList})
end--SetSaluteVoiceList

return this
