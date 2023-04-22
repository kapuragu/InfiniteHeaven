--InfMissionQuest.lua
--from rlc
--implements quests in story missions, either through a hand-picked selection of which ones work, or ivar to force them
--also adds addon missionInfo support ex:
--enableQuests={"lab_q39011","lab_q80700","lab_q10700"},
--and questAddon support ex:
--enableInMissions={10033,10041},
--See also: TppQuest.RegisterCanActiveQuestListInMission/CanActiveQuestInMission

local this={}

this.hasAnyAddonQuestForMissions=false

function this.PostModuleReload(prevModule)
  this.hasAnyAddonQuestForMissions=prevModule.hasAnyAddonQuestForMissions
end

this.registerIvars={
  "enableMissionQuest",
  "forceEnableMissionAllQuest",
}

this.enableMissionQuest={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.forceEnableMissionAllQuest={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.registerMenus={
  "missionQuestMenu",
}

this.missionQuestMenu={
  parentRefs={"InfQuestIvars.sideOpsMenu"},
  options={
    "Ivars.enableMissionQuest",
    "Ivars.forceEnableMissionAllQuest",
  },
}

this.langStrings={
  eng={
    missionQuestMenu="Side ops in missions menu",
    enableMissionQuest="Enable side ops in missions",
    forceEnableMissionAllQuest="Force use all side ops in missions",
  },
  help={
    eng={
      missionQuestMenu="Change settings related to side ops in story missions.",
      enableMissionQuest="Enable side ops in missions using a hand-picked selection of side ops in specific story missions.",
      forceEnableMissionAllQuest="WARNING: The side ops enabled with this option can cause instability or simply won't be clearable. Enables all side ops to be included in all story missions when using the 'Enable side ops in missions' setting.",
    },
  }
}

function this.IsEnableMissionQuest()
  if Ivars.enableMissionQuest:Is(1) then
    return true
  end
  return false
end

function this.IsEnableForceAllQuest()
  if Ivars.forceEnableMissionAllQuest:Is(1) then
    return true
  end
  return false
end

--tex for NeedUpdateActiveQuest
function this.IsAnyMissionQuest()
  --tex forceEnableMissionAllQuest is already gated by enableMissionQuest
  return Ivars.enableMissionQuest:Is(1) or this.hasAnyAddonQuestForMissions
end--

this.MISSION_QUEST_LIST={
  --[[ [10020]={--PHANTOM LIMBS - miller is unavoidable on the radio
  "ruins_q19010",--Extract the Russian Interpreter
  "ruins_q60115",--Secure the [RIOT-SMG] Blueprint
  "field_q10020",--Extract the Highly-Skilled Soldier 02
  "cliffTown_q10050",--Extract the Highly-Skilled Soldier 04
  "quest_q20065",--Prisoner Extraction 01
  "field_q30010",--Extract the Little Lost Sheep
  "quest_q52080",--Eliminate the Armored Vehicle Unit 08
  "quest_q52035",--Eliminate the Tank Unit 01
  }, ]]
  --[[ [10030]={--DIAMONG DOGS - nothing fitting
  }, ]]
  [10036]={--A HERO'S WAY
    "quest_q20025",--Prisoner Extraction 02 w
    "field_q80020",--Extract the Wandering Mother Base Soliders 02 w
    "ruins_q60010",--Mine Clearing 01 w
  },
  [10043]={--C2W (TppHostage2)
    "ruins_q19010",--Extract the Russian Interpreter VANILLA
    "ruins_q60115",--Secure the [RIOT-SMG] Blueprint w
    "field_q10020",--Extract the Highly-Skilled Soldier 02 w
    "quest_q20065",--Prisoner Extraction 01 w
    "field_q30010",--Extract the Little Lost Sheep w
  },
  --[[ [10033]={--OVER THE FENCE - nothing fitting
  }, ]]
  [10040]={--WHERE DO THE BEES SLEEP? (TppHostageUnique, EnemyHeli, only one soldier spawns)
    --"commFacility_q19013",--Extract the Pashto Interpreter (TppHostageUnique defined)
    --"citadel_q60112",--Secure the [IR-SENSOR] Blueprint --Bees uncut only
    "fort_q10080",--Extract the Highly Skilled Soldier 03 w
    --"commFacility_q10060",--Extract the Highly Skilled Solider 06 only spawns sol 0000, even if active alone, and doesn't spawn anyone in 03?
    --"quest_q20805",--Prisoner Extraction 04 (TppHostageUnique defined)
    --"quest_q20905",--Prisoner Extraction 05 (TppHostageUnique defined)
    --"quest_q20055",--Prisoner Extraction 18 (TppHostageUnique defined, Bees uncut only)
    "commFacility_q80060",--Extract the Wandering Mother Base Soldier 01
    --"fort_q80080",--Extract the Wandering Mother Base Soldiers 09--Bees uncut only
    --"quest_q20085",--Unlucky Dog 02 (TppHostageUnique defined)
    --"cliffTown_q11040",--Eliminate the Heavy Infantry 04 --Bees uncut only
    --"commFacility_q11080",--Eliminate the Heavy Infantry 07 only spawns sol 0000, clears the side op when extracting though
    --"fort_q11060",--Eliminate the Heavy Infantry 08 ditto commFacility_q11080
    --"fort_q11070",--Eliminate the Heavy Infantry 15 ditto commFacility_q11080
    "fort_q60013",--Mine Clearing 04 w
  --"cliffTown_q60012",--Mine Clearing 07--Bees uncut only
  },
  [10041]={--RED BRASS (TppHostage2)
    "ruins_q60115",--Secure the [RIOT-SMG] Blueprint w high inter becomes third
    "field_q10020",--Extract the Highly-Skilled Soldier 02
    "cliffTown_q10050",--Extract the Highly-Skilled Soldier 04 w
    "ruins_q10030",--Extract the Highly-Skilled Soldier 13 w
    "quest_q20025",--Prisoner Extraction 02 w
    "quest_q20035",--Prisoenr Extraction 07 w
    "field_q30010",--Extract the Little Lost Sheep w
    --"field_q80020",--Extract the Wandering Mother Base Soliders 02 OUT OF BORDER
    "tent_q60011",--Mine Clearing 02 w
    "quest_q52080",--Eliminate the Armored Vehicle Unit 08 w
    --"quest_q52140",--Eliminate the Armored Vehicle Unit 14 Second tank doesn't spawn, player vehicle or none, soldiers go OOB
    --"cliffTown_q99080",--Intel Agent Extraction -- no realtime radio on quest announce, can't unlock and start demo
    "quest_q52035",--Eliminate the Tank Unit 01 w
  --"quest_q52025",--Eliminate the Tank Unit 02 ditto quest_q52140
  --"quest_q52135",--Eliminate the Tank Unit 11 HELI
  },
  [10044]={--OCCUPATION FORCES (TppHostage2)
    "citadel_q60112",--Secure the [IR-SENSOR] Blueprint w
    "fort_q10080",--Extract the Highly Skilled Soldier 03 w
    "quest_q20905",--Prisoner Extraction 05 w
    "quest_q20055",--Prisoner Extraction 18 w
    "fort_q80080",--Extract the Wandering Mother Base Soldiers 09 w
    "quest_q20085",--Unlucky Dog 02 w
    "cliffTown_q11040",--Eliminate the Heavy Infantry 04 w
    "fort_q11060",--Eliminate the Heavy Infantry 08 w
    "fort_q11070",--Eliminate the Heavy Infantry 15 w
    "fort_q60013",--Mine Clearing 04 w
    "cliffTown_q60012",--Mine Clearing 07
    "fort_q20911",--Search for the Escaped Children 05 W (free roam radio on quest enter announce doesn't work, warping in by box didn't work at first, zombies don't load faces)
  },
  [10054]={--BACKUP, BACK DOWN (TppHostage2, TppHostageUnique2, EnemyHeli, only two soldiers appear)
    "tent_q10010",--Extract the Highly Skilled Soldier 01 w spawns only two soldiers but target appears so works
    "quest_q21005",--Prisoner Extraction 10 w
    "tent_q80010",--Extract the Wandering Mother Base Soldiers 07 w
    "quest_q20015",--Unlucky Dog 01 w
    "tent_q11010",--Eliminate the Heavy Infantry 01 w
    "tent_q11020",--Eliminate the Heavy Infantry 02 w
    "tent_q60011",--Mine Clearing 02 w
    --"quest_q52030",--Eliminate the Armored Vehicle Unit 01 VEHICLES
    "tent_q99072",--Extract the Legendary Gunsmith Yet Again w
    --"quest_q52025",--Eliminate the Tank Unit 02 VEHICLES
    --"quest_q52095",--Eliminate the Tank Unit 09 VEHICLES
    --"tent_q99040",--Secure the Remains of the Man on Fire cutscene won't play
    "tent_q20910",--Search for the Escaped Children 04 w
  },
  [10052]={--ANGEL WITH BROKEN WINGS (TppHostage2, no soldiers)
    --"tent_q10010",--Extract the Highly Skilled Soldier 01 soldiers didnt spawn
    "quest_q21005",--Prisoner Extraction 10 w (shares cell with tied up prisoner, presuming no soldiers)
    --"tent_q80010",--Extract the Wandering Mother Base Soldiers 07 (target doesn't spawn)
    "quest_q20015",--Unlucky Dog 01 w (nicely shares the cell with two more prisoners, presuming no soldiers)
    --"tent_q11010",--Eliminate the Heavy Infantry 01 will conflict with conversation event presuming no soldiers
    --"tent_q11020",--Eliminate the Heavy Infantry 02  presuming no soldiers
    --"quest_q52030",--Eliminate the Armored Vehicle Unit 01 presuming no soldiers
    "tent_q99072",--Extract the Legendary Gunsmith Yet Again w (when malak arrives he shares his cell with him, when interrogated kinda clips)
    --"quest_q52025",--Eliminate the Tank Unit 02
    --"quest_q52095",--Eliminate the Tank Unit 09
    --"tent_q99040",--Secure the Remains of the Man on Fire cutscene won't play
    "tent_q20910",--Search for the Escaped Children 04 w presuming no soldiers
  },
  [10050]={--CLOAKED IN SILENCE (no enemies)
    "sovietBase_q20912",--Search for the Escaped Children 02 w (free roam radio on quest enter announce doesn't work, bears don't load as there's no animal_block)
  --"waterway_q80040",--Extract the Wandering Mother Base Soldiers 10
  },
  [10070]={--HELLBOUND (EnemyHeli, no soldiers)
    --"sovietBase_q99030",--Extract the AI Pod cutscene won't play, soldiers didn't show up
    "sovietBase_q60110",--Secure the [STUN ARM] Blueprint w (disables all soldiers in powerplant, no soldiers, but clearable)
    "sovietBase_q60111",--Secure the [UA DRONE] Blueprint w (doesn't spawn new soldiers)
    --"sovietBase_q10070",--Extract the Highly Skilled Soldier (probably won't show the target)
    "sovietBase_q60014",--Mine Clearing 09 w (bear and mission's soldiers create madness)
    "sovietBase_q99070",--Extract the Legendary Gunsmith Again w (no soldiers neearby target but clearable)
    "quest_q20075",--Prisoner Extraction 03 w (no soldiers nearby but clearable)
  --"quest_q52040",--Eliminate the Armored Vehicle Unit 03 (most likely won't show all targets)
  },
  [10080]={--PITCH DARK (no vehicles)
    "outland_q99071",--Extract the Legendary Gunsmith w

    "outland_q20913",--Search for the Escaped Children 01 w (enemyheli doesn't show, no revengeblock?)
    "outland_q80100",--Extract the Wandering Mother Base Soldiers 03 w
    "outland_q60113",--Secure the [ANTITHEFT DEVICE] Blueprint w
    "outland_q60024",--Mine Clearing 03 w
    --"quest_q52020",--Eliminate the Armored Vehicle Unit 04 tanks don't spawn
    "outland_q10100",--Extract the Highly-Skilled Soldier 08 w
    "outland_q11090",--Eliminate the Heavy Infantry 09 w
    "quest_q20105",--Prisoner Extraction 11 w
    --"quest_q52055",--Eliminate the Tank Unit 07 tanks doesn't spawn
    "outland_q11100",--Eliminate the Heavy Infantry 16 w
  --"quest_q52115",--Eliminate the Tank Unit 12 tanks doesn't spawn
  --"quest_q52110",--Eliminate the Armored Vehicle Unit 12 tanks doesn't spawn
  },
  [10086]={--LINGUA FRANCA (TppHostage2, TppHostageUnique2, 1 vehicle)
    --"outland_q19011",--Extract the Afrikaans Interpreter (out of bounds, would conflict with mission's interpreter)

    "outland_q60113",--Secure the [ANTITHEFT DEVICE] Blueprint w
    "savannah_q10300",--Extract the Highly Skilled Soldier 09 (one non-target sniper is just slightly out of bounds damn)
    "outland_q11100",--Eliminate the Heavy Infantry 16 w
    "quest_q52020",--Eliminate the Armored Vehicle Unit 04 w
  --"quest_q52055",--Eliminate the Tank Unit 07 two vehicles
  },
  [10082]={--FOOTPRINTS OF PHANTOMS (no vehicles)
    "savannah_q10300",--Extract the Highly Skilled Soldier 09 w
    "savannah_q11400",--Eliminate the Heavy Infantry 05 w
    "savannah_q11300",--Eliminate the Heavy Infantry 13 w

  --"quest_q52050",--Eliminate the Armored Vehicle Unit 05 two vehicles
  --"quest_q52120",--Eliminate the Armroed Vehicle Unit 13 two vehicles
  --"quest_q52105",--Eliminate the Tank Unit 10 two vehicles
  },
  [10090]={--TRAITORS' CARAVAN (no vehicles, no soldiers)
    "pfCamp_q60114",--Secure the [GUN-CAM DEFENDER] Blueprint w (soldiers don't spawn)
    --"outland_q10100",--Extract the Highly-Skilled Soldier 08
    --"savannah_q10300",--Extract the Highly Skilled Soldier 09
    "quest_q20305",--Prisoner Extraction 06 w (soldiers don't spawn)
    "quest_q25005",--Prisoner Extraction 15 w (soldiers don't spawn)
    "quest_q20205",--Unlucky Dog 03 w (soldiers don't spawn)
    --"savannah_q11400",--Eliminate the Heavy Infantry 05
    --"savannah_q11300",--Eliminate the Heavy Infantry 13
    --"outland_q11100",--Eliminate the Heavy Infantry 16
    "outland_q60024",--Mine Clearing 03 w
    "outland_q20913",--Search for the Escaped Children 01 w (no soldiers, enemyheli doesn't show, no revengeblock?)
  },
  [10091]={--RESCUE THE INTEL AGENTS (TppHostageUnique, 1 vehicle)
    "savannah_q10300",--Extract the Highly Skilled Soldier 09 w
    "outland_q11100",--Eliminate the Heavy Infantry 16 w
  --note: mission adds riot gear men, some riot gear soldiers appear without their riot gear, perhaps because of infantry?
  },
  [10100]={--BLOOD RUNS DEEP (TppHostageUnique, EnemyHeli, no vehicles, seven soldiers)
    "outland_q19011",--Extract the Afrikaans Interpreter w
    "banana_q10500",--Extract the Highly-Skilled Soldier 10 w (vehicle doesn't spawn, but clearable)
    "diamond_q10600",--Extract the Highly-Skilled Soldier 12 w
    "diamond_q80600",--Extract the Wandering Mother Base Soldiers 05 w
    "banana_q11600",--Eliminate the Heavy Infantry 10 w (should be six targets but only five spawned)
    "banana_q11700",--Eliminate the Heavy Infantry 14 w (should be eight targets but seven spawned)
    "banana_q60023",--Mine Clearing 08 w
    "outland_q40010",--Extract Materials Containers w
  --"diamond_q71500",--Eliminate the Wandering Puppets 13 w (zombie face fovas aren't loaded but clearable, only seven spawn)
  },
  --[[ [10195]={--ON THE TRAIL (EnemyHeli, TppHostage2, 1 vehicle, no soldiers)
  --"diamond_q10600",--Extract the Highly-Skilled Soldier 12
  --"savannah_q11400",--Eliminate the Heavy Infantry 05 (soldiers didn't spawn, outpost disabled along with tail target)
  --"savannah_q11300",--Eliminate the Heavy Infantry 13
  }, ]]
  [10110]={--VOICES (TppHostageUnique, no vehicles)
    "hill_q10400",--Extract the Highly-Skilled Soldier 11 w
    "hill_q80400",--Extract the Wandering Mother Base Soldiers 06 w
    "cliffTown_q11050",--Eliminate the Heavy Infantry 11 w (one of the soldiers wasn't wearing riot gear as he should)
    "hill_q11500",--Eliminate the Heavy Infantry 12 w
    "hill_q60021",--Mine Clearing 05 w
  },
  [10121]={--THE WAR ECONOMY (EnemyHeli)
    "pfCamp_q60114",--Secure the [GUN-CAM DEFENDER] Blueprint w
    "quest_q20205",--Unlucky Dog 03 w
    "pfCamp_q11200",--Eliminate the Heavy Infantry 06 w
    "quest_q25005",--Prisoner Extraction 15 w
    "pfCamp_q60020",--Mine Clearing 06 w
  },
  --[[ [10120]={--THE WHITE MAMBA (children; nothing fitting)
  }, ]]
  [10085]={--CLOSE CONTACTS (TppHostage2, TppHostageUnique2, 1 vehicle, seven soldiers)
    "hill_q19012",--Extract the Kikongo Interpreter w
    "hill_q10400",--Extract the Highly-Skilled Soldier 11 w
    "quest_q27005",--Prisoner Extraction 16 w
    "quest_q20405",--Prisoner Extraction 20 w (gunship doesn't appear but clearable)
    "hill_q80400",--Extract the Wandering Mother Base Soldiers 06 w
    "hill_q11500",--Eliminate the Heavy Infantry 12 w
    "hill_q60021",--Mine Clearing 05 w
  --"quest_q52095",--Elimiante the Tank Unit 08 (heli probably won't show up, seven soldiers incl tank)
  },
  [10200]={--AIM TRUE, YE VENGEFUL (children, no soldiers, 1 vehicle TppHostage2)
    "hill_q19012",--Extract the Kikongo Interpreter w (no soldiers but helps as there's kids, but clearable)
  --"hill_q60021",--Mine Clearing 05 last mine is juuuust out of bounds
  },
  [10211]={--HUNTING DOWN (TppHostage2, 1 vehicle, no soldiers)
    --"savannah_q10300",--Extract the Highly Skilled Soldier 09 no soldiers spawn
    "quest_q20305",--Prisoner Extraction 06 w soldiers don't spawn
  --"savannah_q11400",--Eliminate the Heavy Infantry 05
  --"savannah_q11300",--Eliminate the Heavy Infantry 13
  },
  [10081]={--ROOT CAUSE (TppHostageUnique, 1 vehicle, no soldiers)
    --"banana_q10500",--Extract the Highly-Skilled Soldier 10
    --"banana_q11600",--Eliminate the Heavy Infantry 10
    --"banana_q11700",--Eliminate the Heavy Infantry 14
    "banana_q60023",--Mine Clearing 08 w (can kinda mess with the truck crash scripting)
  },
  [10130]={--CODE TALKER (EnemyHeli, zombie event doesn't affect soldiers, they don't zombie)
    "lab_q10700",--Extract the Highly Skilled Soldier 14 w
    "lab_q39011",--Extract the Legendary Ibis w
    "lab_q80700",--Extract the Wandering Mother Base Soliders 08 w
    --"quest_q20705",--Unlucky Dog 04 - HELI doesn't appear in side op, doesn't clear?
    "cliffTown_q11050",--Eliminate the Heavy Infantry 11 w
    --"lab_q60022",--Mine Clearing 10 doesn't work?
    "lab_q20914",--Search for the Escaped Children 02 w
  },
  --[[ [10150]={--SKULL FACE (EnemyHeli, XOF, doesn't clear any)
  -- "quest_q20095",--Unlucky Dog 05 no soldiers doesn't clear
  --"citadel_q10090",--Extract the Highly Skilled Soldier 16 presuming no soldiers
  --"quest_q22005",--Prisoner Extraction 19 doesn't clear
  }, ]]
  --[[ [10045]={--TO KNOW TOO MUCH (TppHostageUnique)
  --"field_q80020",--Extract the Wandering Mother Base Soliders 02 right on the border
  --"quest_q52140",--Eliminate the Armored Vehicle Unit 14 not enough soldiers and would screw up xof assassin's vehicle
  --"quest_q52025",--Eliminate the Tank Unit 02 assuming ditto quest_q52140
  }, ]]
  [10093]={--CURSED LEGACY (EnemyHeli)
    "lab_q80700",--Extract the Wandering Mother Base Soliders 08 - w Intel Radio wrong/marking the soldier says he's ZRS

    "lab_q20914",--Search for the Escaped Children 02 W (free roam radio on quest enter announce doesn't work)
    --"lab_q39011",--Extract the Legendary Ibis - TppStork already defined
    "lab_q10700",--Extract the Highly Skilled Soldier 14 w
    --"quest_q20705",--Unlucky Dog 04 - HELI doesn't appear in side op, doesn't clear?
    "lab_q60022",--Mine Clearing 10 W (people can step on the mines really quickly)
  },
  [10156]={--EXTRAORDINARY (TppHostage2, 1 vehicle, EnemyHeli is called as revengeheli reinforce)
    "ruins_q19010",--Extract the Russian Interpreter w
    "quest_q20035",--Prisoner Extraction 07 w
    "ruins_q10030",--Extract the Highly-Skilled Soldier 13 w
  },
  [10171]={--PROXY WAR WITHOUT END (EnemyHeli, no vehicles, seven soldiers)
    "pfCamp_q60114",--Secure the [GUN-CAM DEFENDER] Blueprint w
    "savannah_q10300",--Extract the Highly Skilled Soldier 09 w
    "quest_q20305",--Prisoner Extraction 06 w
    "quest_q25005",--Prisoner Extraction 15 w
    "quest_q20205",--Unlucky Dog 03 w
    "savannah_q11400",--Eliminate the Heavy Infantry 05 w
    "savannah_q11300",--Eliminate the Heavy Infantry 13 w (only seven soldiers spawn but clearable
    "outland_q11100",--Eliminate the Heavy Infantry 16 w (only seven soldiers spawn but clearable)
  },
  [10260]={--A QUIET EXIT (EnemyHeli, surprisingly two soldiers)
    --"quest_q21005",--Prisoner Extraction 10 adds two soldiers in front of cells, not clearable?
    "tent_q11010",--Eliminate the Heavy Infantry 01 w
    "tent_q20910",--Search for the Escaped Children 04 w (two soldiers)
  },
}

this.MISSION_QUEST_ENEMY={
  soldierDefine = {
    quest_cp = {
      "sol_quest_0000",
      "sol_quest_0001",
      "sol_quest_0002",
      "sol_quest_0003",
      "sol_quest_0004",
      "sol_quest_0005",
      "sol_quest_0006",
      "sol_quest_0007",
    }
  },
  routeSets = {
    quest_cp = {
      USE_COMMON_ROUTE_SETS = true,
    }
  }
}

local quest_block="/Assets/tpp/pack/mission2/ih/quest_block.fpk"

this.DeactivateQuestAreaTrapPack={
  [TppDefine.LOCATION_ID.AFGH]="/Assets/tpp/pack/mission2/ih/afgh_deact_quest_area.fpk",
  [TppDefine.LOCATION_ID.MAFR]="/Assets/tpp/pack/mission2/ih/mafr_deact_quest_area.fpk",
}

function this.GetDeactQuestAreaPack(missionCode)
  local deactTrapPack
  if missionCode~=30010 and missionCode~=30020 then
    local location = TppPackList.GetLocationNameFormMissionCode(missionCode)
    if location then
      deactTrapPack=this.DeactivateQuestAreaTrapPack[TppDefine.LOCATION_ID[location]]
    end
  end
  return deactTrapPack
end

function this.AddMissionPacks(missionCode,packPaths)
  if this.GetMissionQuestList(missionCode) then
    packPaths[#packPaths+1]=quest_block
    local deactTrapPack=this.GetDeactQuestAreaPack(missionCode)
    if deactTrapPack then
      packPaths[#packPaths+1]=deactTrapPack
    end
  end
end
local allQuestNames
function this.GetMissionQuestList(missionCode)
  this.AddAddonQuestsToMissionQuestTable()
  this.AddAddonMissionQuestListToMissionQuestTable()
  if not TppMission.IsStoryMission(missionCode) then
    return false
  end
  if not this.IsEnableMissionQuest() then
    return false
  end
  if TppMission.IsHardMission(missionCode) then
    missionCode=TppMission.GetNormalMissionCodeFromHardMission(missionCode)
  end
  if this.IsEnableForceAllQuest() then
    --tex KLUDGE
    if allQuestNames==nil then
      allQuestNames={}
      for i,questInfo in ipairs(TppQuest.GetQuestInfoTable())do
        table.insert(allQuestNames,questInfo.questName)
      end
    end
    return allQuestNames
    --tex CULL dont use, questInfoTable -^- instead since the list of ui/playable quests. return TppDefine.QUEST_DEFINE
  end
  return this.MISSION_QUEST_LIST[missionCode]
end

function this.Init(missionTable)
  if this.GetMissionQuestList(vars.missionCode) then
    if missionTable.enemy then
      --stuff that story missions might not have defined that quests need
      missionTable.enemy.soldierDefine=missionTable.enemy.soldierDefine or{}
      missionTable.enemy.soldierDefine.quest_cp=missionTable.enemy.soldierDefine.quest_cp or this.MISSION_QUEST_ENEMY.soldierDefine.quest_cp
      missionTable.enemy.routeSets=missionTable.enemy.routeSets or{}
      missionTable.enemy.routeSets.quest_cp=missionTable.enemy.routeSets.quest_cp or this.MISSION_QUEST_ENEMY.routeSets.quest_cp
    end
  end
end

function this.SetUpEnemy(missionTable)
  if this.GetMissionQuestList(vars.missionCode) then
    TppEnemy.SetupQuestEnemy()
  end
end

function this.MissionPrepare()
  if this.GetMissionQuestList(vars.missionCode) then
    local questTable=this.GetMissionQuestList(vars.missionCode)
    if not Tpp.IsTypeTable(questTable) then
      questTable={questTable}
    end
    TppQuest.RegisterCanActiveQuestListInMission(questTable)
  end
end

function this.AddToMissionQuestTable(missionCode,questName)
  this.MISSION_QUEST_LIST[missionCode]=this.MISSION_QUEST_LIST[missionCode] or {}
  local alreadyContainsQuest = false
  for index, qestName in ipairs(this.MISSION_QUEST_LIST[missionCode]) do
    if qestName==questName then
      alreadyContainsQuest=true
    end
  end
  local isValidQuest = false
  for index, qestName in ipairs(TppDefine.QUEST_DEFINE) do
    if qestName==questName then
      isValidQuest=true
    end
  end
  if not alreadyContainsQuest and isValidQuest then
    table.insert(this.MISSION_QUEST_LIST[missionCode],questName)
  end
  --tex for NeedUpdateActiveQuest
  --ASSUMPTION: only calling AddToMissionQuestTable when adding addon quest/not vanilla (vanilla should aready be in this.MISSION_QUEST_LIST
  if isValidQuest then
    this.hasAnyAddonQuestForMissions=true
  end
end

function this.AddAddonQuestsToMissionQuestTable()
  --[[

        enableInMissions={10033,10041},

     ]]
  if not InfQuest then
    return
  end
  if not InfQuest.ihQuestsInfo then
    return
  end
  for questName, questAddon in pairs(InfQuest.ihQuestsInfo) do
    if questAddon.enableInMissions then
      if not Tpp.IsTypeTable(questAddon.enableInMissions) then
        questAddon.enableInMissions={questAddon.enableInMissions}
      end
      for index, missionCode in ipairs(questAddon.enableInMissions) do
        this.AddToMissionQuestTable(missionCode,questName)
      end
    end
  end
end

function this.AddAddonMissionQuestListToMissionQuestTable()
  --[[

        enableQuests={"lab_q39011","lab_q80700","lab_q10700"},

     ]]
  if not InfMission then
    return
  end
  if not InfMission.missionInfo then
    return
  end
  for missionCode, missionInfo in pairs(InfMission.missionInfo) do
    if missionInfo.enableQuests then
      if not Tpp.IsTypeTable(missionInfo.enableQuests) then
        missionInfo.enableQuests={missionInfo.enableQuests}
      end
      for index, questName in ipairs(missionInfo.enableQuests) do
        this.AddToMissionQuestTable(missionCode,questName)
      end
    end
  end
end

return this
