--DEBUGNOW
--Mother base soldiers salute voice list
--With no salue list set all they will say is "Boss!"
--Can be re-called during in-mission with changes to test
--each salute id(?) has multiple variations (depending on the voice of the soldier I guess, dont know if theres multiple takes for same)
--tex TODO: figure out the saluteId is related to the multiple voice/subtitle lines
--example
--salute0080 =
--sltb1000_093528_0_eneb_enf
--sltb1000_093527_0_enea_enf
--sltb1000_093268_0_enec

--See debug_CallVoice / speechLabels for more notes

function this.SetSaluteVoiceList()
  --DEBUGNOW
  --  if mb_additionalSalueCommentsorsomething
  --      InfSolier.SetMBSaluteVoiceList()
  --      return
  --    end


  InfCore.LogFlow("SetSaluteVoiceList")--tex DEBUG
  if not GameObject.DoesGameObjectExistWithTypeName"TppSoldier2"then
    return
  end

  local highList={}
  local highOnceList={}
  local midList={}
  local midOnceList={}
  local lowList={}
  local lowOnceList={}


  --tex from DEBUGNOW ?? speechLabels
  lowList={
    --other voice labels that have nothing to do with salute but might be cool to include:
    --Enemy Voices Sneak (NORMAL/player not spotted status)
    --"EVS040",--"very soft Phew/Ahh",},-- Relaxing --OFF too soft
    "EVS060",--"(exersion) Hmph/Hup",},--Light exertion lines
    "EVS090",--"Rrrgh",},--Soldier gets something in his eye.
    "EVS100",--"(tired) sigh",},--
    "EVS110",--"(frustrated) Dammit",},--Irritated
    "EVS120",--"He's taking so long...",},--Waiting for comrade - General purpose
    "EVS130",--"(to self) I'm going.",},--Can't bear waiting any longer, goes alone

    --Enemy Voiced Notice
    "EVN060",--"soft huh?",},-- From nearby: Enemy spots something
    --"EVN070",--"real soft hmm",}, -- From nearby: Checking it out --OFF too soft
    "EVN080",--"you there!|hey!",}, -- From nearby: Spotted something suspicious

    --"EVN100",--"soft sigh",}, -- From nearby: Nothing spotted --OFF too soft
    --"EVN110",--"soft huh?!",}, -- Heard a knock, footsteps, or other unusual noise-- OFF too soft
    "EVN120",--"The hell?!|Wha-?!|What was that?!",},-- Reacting to an explosion or other loud noise
    "EVN130",--"soft Hm? Huh...",}, -- Checking last known position
    --"EVN140",--"He's here!",}, -- Spotting a suspicious person while searching/on guard, and engaging him
    --"EVN150",--"Contact!|Hostile!",}, --The suspicious person spotted has been identified as an enemy (the player) and is engaged.
    "EVN170",--"Hey - look over there.",},--Spotting something suspicious, and attracting a comrade's attention.

    "EVN311",--"Shoo, shoo! (to animal)",},--chasing away an animal
    "EVN312",--"Get Lost! (to animal angry)",},--
    "EVN350",--"cursing something (multi-purpose)",},--

    --Enemy Voices Reaction
    "EVR010",--"(shock) What the!",}, --
    "EVR011",--"(shock,extreme) Huh!",}, --
    "EVR012",--"(shock,little) Ah!",}, --
    --"EVR020",--"Shit! Enemy fire!",}, --Taking gunfire

    "EVR070",--"hahh! (Short outbursts to steel himself.)",}, --Taking gunfirePlayer has their gun on the enemy, threatening him. Bold reactions.
    "EVR180",--"The hell you doing? (spotted hold-up)",}, --Spotting a comrade in hold-up status
    "EVR220",--"(chuckles)",},--spotted Snake while he's wearing the chicken hat
    "EVR230",--"(chuckles)",},--spotted Snake while he's wearing the chicken hat

    --Enemy Voices Damage/Status changes
    --"EVD070",--"General coughs.",},--doesnt seem to trigger, needs condition?

    --Enemy Voices Battle
    "EVB010",--"Small psych-up shouts.",},
    "EVB030",--"Big psych-up shouts.",},
    --"EVB040",--"Mammoth psych-up shouts.",},--doesnt seem to trigger, needs condition?

    --Enemy Voices Comrades (Battle,Teamwork)
    --"EVC250",--"Go! (to comrades)",},
    "EVC260",--"Go go go! (to comrades)",},
    "EVC330",--"I'm OK (to comrades)",},
    "EVC340",--"You OK? (to comrades)",},

    --Enemy Voices E? Post-combat voices - Caution

    --Enemy Voices Fight?
    "EVF010",--"Boss!",},--default saluting boss.
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



  table.insert(lowList,"EVF010")--"Boss!",},--default saluting boss.
  table.insert(lowList,"salute0180")--'train with me'
  table.insert(lowList,"salute0220")--'whatever supplies you need, let us know'
  table.insert(lowList,"salute0310")--'how's it going boss?'
  table.insert(lowList,"salute0320")--"boss good moring|have a good day boss",}, -- condition: must actually be morning ?

  table.insert(midList,"salute0410")--"uh, how about taking a shower after a mission?",},--When Boss stinks - requires condition?
  table.insert(midList,"salute0420")--  New recruit who was just extracted - requires condition?

  local storySequence=gvars.str_storySequence
  if TppMotherBaseManagement.GetOgrePoint()>=5e4 then
    table.insert(highOnceList,"salute0080")--'welcome back boss', often said with trepidation, other times sounds normal.
  elseif Player.GetSmallFlyLevel()>=5 then
    table.insert(highOnceList,"salute0050")--'long time no see'
  elseif Player.GetSmallFlyLevel()>=3 then
    table.insert(highOnceList,"salute0040")--'good to have you back boss'
  else
    table.insert(highOnceList,"salute0060")--'welcome home boss', with warmth
  end
  local staffcount=TppMotherBaseManagement.GetStaffCount()
  local staffLimit=0
  staffLimit=staffLimit+TppMotherBaseManagement.GetSectionStaffCountLimit{section=TppMotherBaseManagementConst.SECTION_COMBAT}
  staffLimit=staffLimit+TppMotherBaseManagement.GetSectionStaffCountLimit{section=TppMotherBaseManagementConst.SECTION_DEVELOP}
  staffLimit=staffLimit+TppMotherBaseManagement.GetSectionStaffCountLimit{section=TppMotherBaseManagementConst.SECTION_BASE_DEV}
  staffLimit=staffLimit+TppMotherBaseManagement.GetSectionStaffCountLimit{section=TppMotherBaseManagementConst.SECTION_SUPPORT}
  staffLimit=staffLimit+TppMotherBaseManagement.GetSectionStaffCountLimit{section=TppMotherBaseManagementConst.SECTION_SPY}
  staffLimit=staffLimit+TppMotherBaseManagement.GetSectionStaffCountLimit{section=TppMotherBaseManagementConst.SECTION_MEDICAL}
  staffLimit=staffLimit+TppMotherBaseManagement.GetSectionStaffCountLimit{section=TppMotherBaseManagementConst.SECTION_SECURITY}
  local percentageFull=staffcount/staffLimit
  if percentageFull<.2 then
    table.insert(lowList,"salute0100")--'we cant get by with so few staff'
  elseif percentageFull<.4 then
    table.insert(lowList,"salute0090")--'we need more personel'
  elseif percentageFull>.8 then
    table.insert(lowList,"salute0120")--'starting to get a little crowded here'
  end
  if TppMotherBaseManagement.GetGmp()<0 then
    table.insert(lowList,"salute0150")--'boss, we still in the red?'
  end
  if TppMotherBaseManagement.GetDevelopableEquipCount()>8 then
    table.insert(lowList,"salute0160")--'we're ready to develop new equipment'
  end
  if(TppMotherBaseManagement.GetResourceUsableCount{resource="CommonMetal"}<500 or TppMotherBaseManagement.GetResourceUsableCount{resource="FuelResource"}<200)or TppMotherBaseManagement.GetResourceUsableCount{resource="BioticResource"}<200 then
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
  if(TppBuddyService.DidObtainBuddyType(BuddyType.DOG)and not TppBuddyService.CanSortieBuddyType(BuddyType.DOG))and not TppBuddyService.IsDeadBuddyType(BuddyType.DOG)then
    table.insert(lowList,"salute0240")--'boss, thanks for saving that puppy'
  end
  if(TppBuddyService.DidObtainBuddyType(BuddyType.QUIET)and not TppBuddyService.CanSortieBuddyType(BuddyType.QUIET))and not TppBuddyService.IsDeadBuddyType(BuddyType.QUIET)then
    table.insert(lowList,"salute0250")--'i hope you keep that woman locked up boss'
  end
  if TppMotherBaseManagement.GetResourceUsableCount{resource="Plant2000"}<100 or TppMotherBaseManagement.GetResourceUsableCount{resource="Plant2005"}<100 then
    table.insert(lowList,"salute0260")--'do you think you could bring back more medicinal plants?'
  end
  if storySequence==TppDefine.STORY_SEQUENCE.CLEARD_TAKE_OUT_THE_CONVOY then
    table.insert(midList,"salute0270")--'you have to rescue our men'
  end
  if TppMotherBaseManagement.IsPandemicEventMode()or storySequence==TppDefine.STORY_SEQUENCE.CLEARD_FLAG_MISSIONS_BEFORE_MURDER_INFECTORS then
    table.insert(midList,"salute0280")--'you need to put an end to the infection boss'
  end
  if storySequence==TppDefine.STORY_SEQUENCE.CLEARD_ELIMINATE_THE_POWS then
    table.insert(midList,"salute0290")--'thanks for taking in those children'
  end
  if TppTerminal.IsBuiltAnimalPlatform()then
    table.insert(lowList,"salute0300")--'thank you for getting those animals out boss'
  end
  if storySequence==TppDefine.STORY_SEQUENCE.CLEARD_RESCUE_INTEL_AGENTS then
    table.insert(midList,"salute0330")--'thank you for rescuing our men boss'
  end
  if storySequence>=TppDefine.STORY_SEQUENCE.CLEARD_METALLIC_ARCHAEA and storySequence<=TppDefine.STORY_SEQUENCE.CLEARD_OKB_ZERO then
    table.insert(midList,"salute0340")--'thank you for ending the infection'
  end
  if storySequence==TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS then
    table.insert(midList,"salute0350")--'boss, now our guys can rest in peace. thank you for what you did with the diamonds'
    table.insert(midList,"salute0360")--'thank you for stopping the infection boss', with more emotion
  end
  if storySequence>=TppDefine.STORY_SEQUENCE.CLEARD_THE_TRUTH then
    table.insert(lowList,"salute0370")--'boss, whoever you are, youre still my CO'
  end
  if TppUiCommand.IsBirthDay()then
    table.insert(highList,"salute0380")--'happy birthday boss'
  end
  local saluteVoiceList={high={normal=highList,once=highOnceList},mid={normal=midList,once=midOnceList},low={normal=lowList,once=lowOnceList}}
  local typeSoldier={type="TppSoldier2"}
  GameObject.SendCommand(typeSoldier,{id="SetSaluteVoiceList",list=saluteVoiceList})
end--SetSaluteVoiceList