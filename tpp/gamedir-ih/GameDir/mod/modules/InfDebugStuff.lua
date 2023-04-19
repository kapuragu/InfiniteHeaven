--InfDebugStuff
--for a want of a better place to put this stuff
local this={}

--TODO: search CallVoice
--TODO: find out exactly what soundbank(s) these are in
--assuming DD_vox_ene for now
this.speechLabels={
  --other voice labels that have nothing to do with salute but might be cool to include:
  --Enemy Voices Sneak (NORMAL/player not spotted status)
  {"EVS040","very soft Phew/Ahh",},-- Relaxing
  {"EVS060","(exersion) Hmph/Hup",},--Light exertion lines
  {"EVS090","Rrrgh",},--Soldier gets something in his eye.
  {"EVS100","(tired) sigh",},--
  {"EVS110","(frustrated) Dammit",},--Irritated
  {"EVS120","He's taking so long...",},--Waiting for comrade - General purpose
  {"EVS130","(to self) I'm going.",},--Can't bear waiting any longer, goes alone

  --Enemy Voiced Notice
  {"EVN060","soft huh?",},-- From nearby: Enemy spots something
  {"EVN070","real soft hmm",}, -- From nearby: Checking it out
  {"EVN080","you there!|hey!",}, -- From nearby: Spotted something suspicious

  {"EVN100","soft sigh",}, -- From nearby: Nothing spotted
  {"EVN110","soft huh?!",}, -- Heard a knock, footsteps, or other unusual noise
  {"EVN120","The hell?!|Wha-?!|What was that?!",},-- Reacting to an explosion or other loud noise
  {"EVN130","soft Hm? Huh...",}, -- Checking last known position
  {"EVN140","He's here!",}, -- Spotting a suspicious person while searching/on guard, and engaging him
  {"EVN150","Contact!|Hostile!",}, --The suspicious person spotted has been identified as an enemy (the player) and is engaged.
  {"EVN170","Hey - look over there.",},--Spotting something suspicious, and attracting a comrade's attention.
  {"EVN180","Hey, that guy over there - who is it?",},--Spotted an intruder, getting a comrade to check it out.
  {"EVN190","Fine, I'll check it out.",},--Responses to EV170, EV180.
  {"EVN200","Fine, I'll check it out.",},--Responses to EV170, EV180.
  {"EVN210","There's nothing there..",},--Responses to EV170, EV180.
  {"EVN220","You see somebody there?",},--Nearby comrade suddenly checks something out.
  {"EVN230","Gotta check it. Let's go.",},--Going in a pair to check it out.
  {"EVN240","Got it.",},--Responses to EVN230.
  {"EVN250","I'll go check it out.",},--Spotter goes to check it out himself.
  {"EVN260","Go for it, I'll wait here.",},--Responses to EV250.
  {"EVN270","My imagination, it's nothing.",},--
  {"EVN280","I'm relieving you.",},--not working, need condition? Relieving a sentry
  {"EVN290","Heeey, I'm relieving you!",},--not working, need condition? Relieving a sentry (shouted from a distance).
  {"EVN300","What's the matter, boy? (talking to dog)",},--Asking a barking dog what's up.
  {"EVN301","Calming the dog.",},--
  {"EVN310","Shut up, you stupid mutt.",},--Telling a barking dog to shut up.
  {"EVN320","S-Somebody get over here!",},--interrogate: "Call out"
  {"EVN330","Can I get a hand over here? One guy's fine!",},--not working, need condition? interrogation: 'Call one guy',--
  {"EVN331","Be right there.",},--Responding to being called.
  {"EVN340","Come here a second.",},--Calling comrades (close range)
  {"EVN341","Need a hand here!",},--Calling comrades (long range)
  --later in .xslt under ◆Enemy soldier lines_basic◆
  {"EVN311","Shoo, shoo! (to animal)",},--chasing away an animal
  {"EVN312","Get Lost! (to animal angry)",},--
  {"EVN350","cursing something (multi-purpose)",},--
  --TODO: continues up to EVN370

  --Enemy Voices Reaction
  {"EVR010","(shock) What the!",}, --
  {"EVR011","(shock,extreme) Huh!",}, --
  {"EVR012","(shock,little) Ah!",}, --
  {"EVR020","Shit! Enemy fire!",}, --Taking gunfire
  {"EVR050","(Surprised at the bullet impact) Ah",}, --not working--Takes fire and looks around to spot the player, but is unable to find him and is tense/shaken.
  {"EVR061","Aaaahh (player gun on enemy)",}, --Player has their gun on the enemy,
  {"EVR062","Huh? Interrogated, no english",},--
  {"EVR063","Wh-what does that mean? (Ru/Af)",},--doesnt work Interrogated, but unable to understand English
  {"EVR070","hahh! (Short outbursts to steel himself.)",}, --Taking gunfirePlayer has their gun on the enemy, threatening him. Bold reactions.
  --..TODO up to EVR100
  --!
  {"EVR110","(see sleeping comrade) You lazy son of a..."},--
  --TODO up to EVR123
  {"EVR130","Ew, Ughh etc (bad smell)"},--
  --.. TODO: up to EVR160
  {"EVR180","The hell you doing? (spotted hold-up)",}, --Spotting a comrade in hold-up status
  {"EVR190","Fucking kidding me!"},--Enemy responses when CP rejects their requests for reinforcement.

  {"EVR200","Ahhhhhhhhh!! (fultoned angry)"},--
  {"EVR201","Wha?! (fultoned surprised)"},--
  {"EVR202","Wa-hoo! (fultoned excited)"},--

  --..TODO: continues up to EVR211
  --..TODO: contines later in .xls from EVR084
  {"EVR220","(chuckles)",},--spotted Snake while he's wearing the chicken hat
  {"EVR230","(chuckles)",},--spotted Snake while he's wearing the chicken hat

  --Enemy Voices Damage/Status changes
  --TODO up to EVD60
  {"EVD070","General coughs.",},--doesnt seem to trigger, needs condition?
  --TODO:
  {"EVD110","Wh-whoah! (Near-misstep)"},--cliff
  --..TODO: up to EVD270
  --TODO later in .xsl from EVD171

  --Enemy Voices Battle
  {"EVB010","Small psych-up shouts.",},
  {"EVB030","Big psych-up shouts.",},
  {"EVB040","Mammoth psych-up shouts.",},--doesnt seem to trigger, needs condition?
  --TODO:
  {"EVB090","Ready!"},--not working Letting team know reload is complete.
  --..TODO: continues up to EVB100

  --Enemy Voices Comrades (Battle,Teamwork)
  --TODO
  {"EVC200","Watch out!",},--Warning calls.
  --TODO up to EVC240
  {"EVC250","Go! (to comrades)",},
  {"EVC260","Go go go! (to comrades)",},
  --TODO: up to EVC290
  {"EVC320","Check your ammo! (to comrades)",},
  {"EVC330","I'm OK (to comrades)",},
  {"EVC340","You OK? (to comrades)",},
  --TODO
  {"EVC400","(In battle, tense) Copy!",},

  --TODO: up to EVC440

  --Enemy Voices E? Post-combat voices - Caution
  --TODO EVE
  {"EVE030","Roger that!",},--Checking last known point of contact (response)
  {"EVE040"," Hold it.",},--Clearing. Halt orders.
  {"EVE050","Clear.",},--Clearing. Announcing clear
  --TODO
  {"EVE080","No...|I'll get that bastard...",},--When dying comrade passes.
  --TODO: later in .xls
  {"EVE110","Find 'em?!"},--
  {"EVE120","Not here."},-- post-combat_caution dialog answer to 110
  {"EVE130","I'll look over here."},
  {"EVE140","You try over that way."},--
  {"EVE150","Search complete! Search complete!"},--
  {"EVE160","Returning to post. Stay on the lookout."},--
  {"EVE170","All clear, all clear!"},
  {"EVE180","Get back to your post."},

  --Enemy Voises Sneak? Prisoner - Prisoner escort lines
  --TODO

  --Enemy soldier lines: EVSP
  {"EVSP100","Spill it!",}, --interrogation spill it
  --{"EVSP110","Don't lie to me!",}, --110 looks like its listed twice but its combined?
  --{"EVSP110","State your mission!",}, --
  {"EVSP120","Do you WANT to die",}, --
  {"EVSP130","Found it!",}, --found something they were looking for

  --TODO EVSP


  --EVSP: Slaughtering the infected
  --TODO: no ids

  --Enemy Voices Fight?
  {"EVF010","Boss!",},--default saluting boss.
  {"EVF020","its an honor boss|dont pull any punches",}, ----no ref,  Greeting Boss before practice:
  {"EVF030","boss, thats not quite right|boss, um with all due respect",}, --no ref,-- Multipurpose lines for when player fails to do something correctly:
  {"EVF040","thank you boss!",}, --no ref, the standard cqc reaction
  --> anything higher, silence/no table


  {"salute0010","great work on that mission",},--no ref, After completing a mission (score: high)
  {"salute0020","nice job on that mission",}, --no ref, After completing a mission (score: medium)
  {"salute0030","that was a pretty rough mission",}, --no ref, ・After completing a mission (score: low)
  {"salute0040","good to have you back boss",}, -- After Boss returns (they"re happy to see him)
  {"salute0050","long time no see",}, -- ・Boss returns after a long time away
  {"salute0060","welcome home boss",}, --- with warmth ・General-purpose lines after Boss returns
  {"salute0070", "boss? what is..? uhh never mind|thats a.. interesting hat youve got there",},-- spoken uncertainly. ----no ref, ・After Boss returns (when wearing chicken hat) (prep)
  {"salute0080","welcome back boss",},-- often said with trepidation, other times sounds normal. -- ・Boss"s "demon level" has exceeded a certain point
  {"salute0090","we need more personel",},
  {"salute0100","we cant get by with so few staff",},
  {"salute0110", "thanks for bringing in more guys",},--no ref,
  {"salute0120","starting to get a little crowded here",},
  {"salute0130","thanks for upgrading the base|for expanding",},--no ref,
  {"salute0140", "that new weapon is just what we needed boss",},--no ref,
  {"salute0150","boss, we still in the red?",},
  {"salute0160","we're ready to develop new equipment",},
  {"salute0170","do you think you can bring in more materials?",},
  {"salute0180","train with me",},
  {"salute0190","boss! you, me, mock battle, what do you say?",},
  {"salute0200","i'm ready for a dispatch. send me on a mission",},
  {"salute0210","damage to the fob is getting serious, you need to review fob security",}, --no ref,  for after fob attack i guess
  {"salute0220","whatever supplies you need, let us know",},
  {"salute0230","we're here for you if you need combat support",},
  {"salute0240","boss, thanks for saving that puppy",},
  {"salute0250","i hope you keep that woman locked up boss",},
  {"salute0260","do you think you could bring back more medicinal plants?",},
  {"salute0270","you have to rescue our men",},
  {"salute0280","you need to put an end to the infection boss",},
  {"salute0290","thanks for taking in those children",},
  {"salute0300","thank you for getting those animals out boss",},
  {"salute0310","how's it going boss?",},
  {"salute0320","boss good moring|have a good day boss",}, -- condition: must actually be morning ?
  {"salute0330","thank you for rescuing our men boss",},
  {"salute0340","thank you for ending the infection",},
  {"salute0350","boss, now our guys can rest in peace. thank you for what you did with the diamonds",},
  {"salute0360","thank you for stopping the infection boss",},--with more emotion
  {"salute0370","boss, whoever you are, youre still my CO",},
  {"salute0380","happy birthday boss",},
  {"salute0390","congratulations on the decomissioning boss",}, -- no ref,  ・After abolishing nuclear weapons
  {"salute0400","congratulations",}, -- --no ref ・General-purpose congratulatory greeting
  {"salute0410","uh, how about taking a shower after a mission?",},--When Boss stinks - requires condition
  {"salute0420","thank you for letting me join diamond dogs",},--  New recruit who was just extracted? - requires condition?
  {"salute0430", "boss! I new you were alive!|its.. its you boss",},--no ref amazed -- ●NPC lines: when reuniting with soldiers who were at the old Mother Base (survivors of 9 years ago)
--> anything higher is silence/no table
}--this.speechLabels

--tex used to select soldier for debug_CallVoice, debug_CallConversation
this.selectSpeechSoldier={
  settings={},--DYNAMIC
  OnSelect=function(self)
    IvarProc.SetSettings(self,InfObjects.objectNames)
  end,
  GetSettingText=this.GetObjectSettingText,
}

this.selectSpeechSoldier2={
  settings={},--DYNAMIC
  OnSelect=function(self)
    IvarProc.SetSettings(self,InfObjects.objectNames)
  end,
  GetSettingText=this.GetObjectSettingText,
}

--  s10010_sequence
--    Player.CallVoice( "snak_down_normal_01", nil, "DD_vox_Snake_reaction" )--doesnt work, soundbank just for that mission?
--    Player.CallVoice( "PLA0130_001", "SNAK", "DD_Player" )--works
--heli_common_sequence
--Player.CallVoice( "OSAKA010","DD_Player") -- does subtitles, check if it does anything in jap
--tex works on soldier selected via selectListObject
this.debug_CallVoice={
  --save=IvarProc.CATEGORY_EXTERNAL,
  settings=this.speechLabels,
  GetSettingText=function(self,setting)
    local speechLabelT=self.settings[setting+1]
    local desc=speechLabelT[2] or ""
    return speechLabelT[1]..":"..desc
  end,
  OnActivate=function(self,setting,previousSetting)
    local speechLabelT=self.settings[setting+1]
    local soldierName=Ivars.selectSpeechSoldier:GetSettingName()
    local gameObjectId=GameObject.GetGameObjectId(soldierName)
    if gameObjectId==GameObject.NULL_ID then
      return
    end
    --TODO: check if soldier?
    local command={id="CallVoice",dialogueName="DD_vox_ene",parameter=speechLabelT[1]}
    GameObject.SendCommand(gameObjectId,command)

    --DEBUGNOW
    --Player.CallVoice( "OSAKA010","DD_Player")
    -- Player.CallVoice(speechLabel,"DD_vox_ene")
    --Player.CallVoice( "snak_down_normal_01", nil, "DD_vox_Snake_reaction" )
  end,
}--debug_CallVoice
--DEBUGNOW
--TODO: search CallConversation
this.conversationSpeechLabels={
  "MB_story_01",--"You hear about this? The boss has completed most of his missions without killing anybody",--
  "MB_story_02",--"So, what do you think of how the boss has been acting, they say he's been killing left and right",--
  "MB_story_03",--"I tell ya, these guard shifts lately have been killers",--
  "MB_story_04",--"Hey how do you think those kids are doing",--talks as if they are still on mb
  "MB_story_05",--"That animal conservation platform has really taken off huh?",--
  "MB_story_06",--"Looks like resource opeations are going well. Yeah but I don't know why they call it a FOB",--
  "MB_story_07",--"Hey, you know why big boss is called big boss?",--
  "MB_story_08",--"So why'd the bosses old organisation get taken out?",--
  "MB_story_09",--"So.. who's that woman that doesn't talk that the boss brought back",--
  "MB_story_10",--"That puppy boss brought back is so cute",--
  "MB_story_11",--"Huh that dog's all grown up now",--
  "MB_story_12",--"What the hell could be causing this disease",--
  "MB_story_13",--"So, about the side effects of that shot",--the vaccine
  "MB_story_14",--"Things aren't so cozy around here these days are they?",--
  "MB_story_15",--"Hey what happened the other day, that was something huh? Yeah the boss killed my best buddy in there",--
  "MB_story_16",--"I hear the boss has been going to that area under construction a lot lately",--
  "MB_story_17",--"I guess the boss is weaker than I thought. You mean kicking that scientist out?",--
  "MB_story_18",--"You gotten used to this place?",--male to fem
  "MB_story_19",--"So.. who do you like? What do you mean? Are you team miller or team occelot",--fem to fem
}--conversationSpeechLabels

this.GetObjectSettingText=function(self,setting)
  if #self.settings==0 then
    return InfLangProc.LangString"list_empty"
  end
  local objectName=self.settings[setting+1]
  if objectName==nil then
    return InfLangProc.LangString"list_empty"
  end
  local gameObjectId=GameObject.GetGameObjectId(objectName)
  if gameObjectId==GameObject.NULL_ID then
    return objectName.."==NULL_ID"
  end

  return objectName
end--GetObjectSettingText

this.debug_CallConversation={
  --save=IvarProc.CATEGORY_EXTERNAL,
  settings=this.conversationSpeechLabels,
  GetSettingText=function(self,setting)
    local speechLabel=self.settings[setting+1]
    local desc=speechLabel or ""
    return speechLabel
  end,
  OnActivate=function(self,setting,previousSetting)
    local speechLabel=self.settings[setting+1]
    local soldierName=Ivars.selectSpeechSoldier:GetSettingName()
    local gameObjectId=GameObject.GetGameObjectId(soldierName)
    if gameObjectId==GameObject.NULL_ID then
      return
    end
    local fiendName=Ivars.selectSpeechSoldier2:GetSettingName()
    local friendGameObjectId=GameObject.GetGameObjectId(soldierName)
    if friendGameObjectId==GameObject.NULL_ID then
      return
    end
    --TODO: check if soldier?

    local command={id="CallConversation",label=speechLabel,friend=friendGameObjectId,}
    GameObject.SendCommand(gameObjectId,command)
  end,
}--debug_CallConversation


this.registerIvars={
  "selectSpeechSoldier",
  "selectSpeechSoldier2",
  "debug_CallVoice",
  "debug_CallConversation",
}

this.registerMenus={
  "debugStuffMenu",
  "debugPrintMenu",
}

this.debugStuffMenu={
  parentRefs={"InfDebug.debugInMissionMenu"},
  options={
    "Ivars.selectSpeechSoldier",
    "Ivars.selectSpeechSoldier2",
    "Ivars.debug_CallVoice",
    "Ivars.debug_CallConversation",
  }
}--debugStuffMenu

this.debugPrintMenu={
  parentRefs={"InfDebug.debugInMissionMenu"},
  options={
    "InfMenuCommandsTpp.DEBUG_PrintCpPowerSettings",
    "InfMenuCommandsTpp.DEBUG_PrintPowersCount",
    "InfMenuCommandsTpp.DEBUG_PrintReinforceVars",
    "InfMenuCommandsTpp.DEBUG_PrintSoldierDefine",   
     --"InfMenuCommandsTpp.DEBUG_PrintEnemyFova",    
     --"InfMenuCommandsTpp.DEBUG_PrintRealizedCount",
    --"InfMenuCommandsTpp.DEBUG_PrintSoldierIDList",  
  }
}--debugStuffMenu

this.langStrings={
  eng={
  },
  help={
    eng={
      debugPrintMenu="Dump various things to log",
      selectSpeechSoldier="Selects a soldier from Object list (see Objects menu) as a target for debug_CallVoice, debug_CallConversation",
      debug_CallConversation="Requires a valid selectSpeechSoldier, selectSpeechSoldier2 of a nearby soldier",
    },
  },
}--langStrings

return this
