local this={}

this.registerIvars={
    "PlayVoice",
    "PostEvent",
    "PostEvent3D",
	"PlaySceneMusic",
	"StopSceneMusic",
}

this.playerVoiceIdTable={
	-- All commented entries exist as hashes in HIRC sections, but don't play and don't have linked Sound objects.
	
	--			● Player voice
	--・1: Hold-up 1
	--Shoves gun into enemy:
	"PLA0010_001",-- Don't move! SNAK1000_101010_0_snak
	
	--・2: Hold-up 2
	--Shoves gun into enemy:
	"PLA0010_002",-- Hands up. SNAK1000_111010_0_snak
	
	--・3: Restraining enemy, order 1 during hold-up
	--Make enemy give false response to received radio call.
	"PLA0020_001",-- Lie to them. SNAK1000_121010_0_snak 
	"PLA0020_002",-- Respond. SNAK1000_131010_0_snak
	"PLA0020_003",-- Pick up! SNAK1000_141010_0_snak
	
	--・4: Restraining enemy, order 2 during hold-up
	--Extract useful information from enemy.
	"PLA0030_001",-- Spit it out! SNAK1000_151010_0_snak
	"PLA0030_002",-- Speak. SNAK1000_161010_0_snak
	"PLA0030_003",-- Talk. SNAK1000_171010_0_snak
	
	--・5: Restraining enemy, order 3 during hold-up
	--Force enemy to call in comrades.
	"PLA0040_001",-- Call them. SNAK1000_181010_0_snak
	"PLA0040_002",-- Call your friends. SNAK1000_191010_0_snak
	"PLA0040_003",-- Call them over. SNAK1000_1a1010_0_snak
	
	--・6: Order during hold-up
	--Make enemy lie face-down.
	"PLA0050_001",-- Get down. SNAK1000_1b1010_0_snak
	"PLA0050_002",-- Lie down. SNAK1000_1c1010_0_snak
	"PLA0050_003",-- On the ground! SNAK1000_1d1010_0_snak 
	
	--・7: Command while enemy is grabbed or held up 4
	--Asking location of soldier's comrades
	"PLA0051_001",-- Where are the others? SNAK1000_1d1014_0_snak 
	"PLA0051_002",-- Where are your friends? SNAK1000_1d1018_0_snak 
	
	-- "PLA0053_001", --NOGO v
	-- "PLA0053_002",
	-- "PLA0053_003",
	-- "PLA0053_004",
	-- "PLA0053_005",
	-- "PLA0053_006",
	-- "PLA0053_007",
	-- "PLA0060_001",
	-- "PLA0060_002",
	-- "PLA0060_003",
	-- "PLA0070_001",
	-- "PLA0070_002",
	-- "PLA0070_003",
	-- "PLA0070_004",
	-- "PLA0070_005",
	-- "PLA0070_006",
	-- "PLA0079_001", --NOGO ^
	
	--･25: KIAI - Performing an action/CQC (light)
	"PLA0080_001", --Hnngh!
	
	--･26: KIAI - Performing an action/CQC (medium)
	"PLA0090_001", --Huggh!
	
	--･27: KIAI - Performing an action/CQC (heavy)
	"PLA0100_001", --Nghah!
	
	--･28: KIAI - Performing an action/CQC (very large movements)
	"PLA0110_001", --Hahh!
	
	--･29: KIAI (fail)
	"PLA0120_001", --Huhgh...
	
	--･30: Roaring while shooting
	"PLA0130_001", --AaaaaaaaAaaAaAah!
	
	--･31: When hit/damaged (light) 
	"PLA0140_001", --Agh...
	
	--･32: When hit/damaged (heavy) 
	"PLA0150_001", --Aaghh!
	
	--･33: When hit/damaged (dead) 
	"PLA0160_001", --(Dies, with echo) "(Yell when dying / death throes)"
	
	--･34: When hit/damaged (gunshot) 
	"PLA0170_001", --Rrghhh...
	
	--･35: When hit/damaged (stroked) 
	-- "PLA0180_001", -- NOGO
	
	--･36: When hit/damaged (slashed)
	"PLA0190_001", --Aa!
	
	--･37: When hit/damaged (bombed)
	"PLA0200_001", --AA!
	
	--･38: When hit/damaged (stun grenades)
	-- "PLA0210_001", -- NOGO
	
	--･39: Cough 1
	"PLA0220_001", --Cough cough... (smoke grenade) SNAK1000_2c1010_0_snak
	
	--･40: Cough 2
	-- "PLA0220_002", -- NOGO
	
	--･41: Cough (End)
	-- "PLA0220_003", -- nogo
	
	--･42: Falling
	"PLA0230_001", --(Dies from fall) SNAK1000_261010_0_snak
	
	--･43: Die after falling
	-- "PLA0240_001", -- nogo
	
	--･44: Faint
	-- "PLA0250_001", -- nogo
	
	--･45: Waking from sleep/blackout

	--･46: Breathing (idle)
	"PLA0270_001", --(breathes)
	
	--･47: Breathing (little LIFE remaining, heavily wounded)
	"PLA0280_001", --Ackhh...
	
	--･48: Breathing (little LIFE remaining, almost dead)
	"PLA0290_001", --Aaagh...
	
	--･49: Breathing (sprinting)
	"PLA0300_001", --Huhhih! (running) SNAK1000_2m1010_1_snak
	
	--･50: Breathing (Emergency detour)
	"PLA0310_001", --Huhhg!
	
	--・Snoring
	"PLA0330", --SNAK1100_1c1010_0_snak (snoring)
	
	--・Sleeping
	"PLA0340", --SNAK1100_1d1010_0_snak (sleeping peacefully)
	
	-- "PLA0350_1", --NOGO v
	-- "PLA0350_2",
	
	-- "PLA0360_1",
	-- "PLA0360_2",
	
	-- "PLA0370_1",
	-- "PLA0370_2",
	
	-- "PLA0380_1",
	-- "PLA0390_1",
	-- "PLA0390_2", --NOGO ^
	
	"PLA0400_1",
	"PLA0400_2",
	
	-- ・Sees a photo of a sexy girl
	"PLA0410_1", -- Huh...?
	"PLA0410_2", -- Hnnnnng... (long; stares at photo in a trance)
	"PLA0410_3", -- Mmm... (short; likes what he sees)
	
	-- ・Electrocuted (1) Quivering scream when electrocuted
	"PLA0420_1", -- ("Uuuaaaaaaah! Hnnnnnnng!" etc.; long electrocution, two variations) 
	"PLA0420_2", -- ("Uuuaaaaaaah! Hnnnnnnng!" etc.; long electrocution, two variations)
	
	-- ・Electrocuted (2) Quivering scream when electrocuted
	"PLA0430_1", -- ("Aggh! Hrrg!" etc., short electrocution, two variations)
	"PLA0430_2", -- ("Aggh! Hrrg!" etc., short electrocution, two variations)
	
	-- ・Falling asleep (gas) Inhales sleeping gas; gasp that he lets out when he falls asleep
	"PLA0440_1", -- ("Unnh... Ahhh..." etc.; vocalization when succumbing to sleep after inhaling sleeping gas, two variations)
	"PLA0440_2", -- ("Unnh... Ahhh..." etc.; vocalization when succumbing to sleep after inhaling sleeping gas, two variations)
	
	 -- ・Snoring
	"PLA0450_1", --
	
	-- ・Sleeping
	"PLA0460_1", --
	
	-- ・Patting out fire on his body
	"PLA0470_1", -- (vocalization spoken when patting out fire; tense, but not panicking; approximately 5 seconds)
	"PLA0480_1", -- (vocalization spoken when patting out fire; it isn't going out that easily, so he's somewhat agitated; approximately 5 seconds)
	
	-- "PLA0490_1", -- nogo
	
	-- ・Fultoned (surprise)
	"PLA0500_1", -- What?! (taken by surprise as his body is lifted into the air)
	"PLA0500_2", -- Aaaahhh! (body is pulled up into the sky as he is Fultoned away)
	
	-- ・Fultoned (happy)
	"PLA0510_1", -- Shouts for joy as he is Fultoned away
	
	-- ・Feels sick and then throws up
	"PLA0520_1", -- Has spun around too much. Head is spinning, then throws up
	
	-- ・Resuscitated from near death
	-- "PLA0530_1", -- nogo Receives chest compressions, breathes when resuscitated
	
	-- ・Sand got into eyes
	-- "PLA0540_1", -- nogo Clicks his tongue, etc., after sand gets in his eyes during a sandstorm
	
	-- ・Something nearby stinks (or he got horse manure on him)
	"PLA0550_1", -- Dramatic reaction to something that stinks
	
	-- "PLA0560_1", -- NOGO v
	-- "PLA0570_1",
	-- "PLA0580_1",
	-- "PLA0590_1",
	-- "PLA0590_2",
	-- "PLA0600_1",
	-- "PLA0610_1",
	-- "PLA0610_2", -- nogo ^
	
	--			● Horse command
	--・Horse riding (beginning a gallop / short)
	--Making horse gallop
	"PLH001",
	--・Horse riding (beginning a canter)
	--Making horse go at a canter
	"PLH002",
	--・Horse riding (beginning a trot)
	--Making horse trot
	"PLH003",
	--・Horse riding (beginning a walk)
	--Making horse begin walking from a stop
	"PLH004",
	--・Horse riding (halting a gallop)
	--Stopping a horse that is galloping
	"PLH005",
	--・Horse riding (halting a trot)
	--Stopping a horse that is trotting
	"PLH006",
	--・Calming a horse that is out of control
	"PLH007",
	--・Stroking horse
	--When praising horse, or calming it down further
	"PLH008",
	--・Calling horse
	-- "PLH009", --nogo
	--・Calling horse (long range)
	-- "PLH010", --nogo
	--・Get away
	--Getting the horse to move away from its current position so that it doesn't catch a bullet in the fighting
	--The nuance isn't "Move because you're in the way"
	"PLH011",
	--・Making the horse defecate
	--Prompting the horse to defecate
	"PLH013_1",
	
	--			● Instruction system for dogs
	--・Dog commands 1/Normal: Good, good
	"PLD0010", --SNAK1100_2e1010_0_snak Good, good dog.
	
	--・Dog commands 2/Normal: OK
	"PLD0020", --SNAK1100_2f1010_0_snak OK.
	
	--・Dog commands 3/Normal: No
	"PLD0030",
	
	--・Dog commands 4/Normal: Sit
	"PLD0040",
	
	--・Dog commands 5/Normal: Lie down
	"PLD0050",
	
	--・Dog commands 6/Normal: Stay
	"PLD0060",
	
	--・Dog commands 7/Normal: Stand
	"PLD0070",
	
	--・Dog commands 8/Normal: Quiet
	"PLD0080",
	
	--・Dog commands 9/Normal: Watch (the handler)
	-- "PLD0090", --(nogo)
	
	--・Dog commands 10/Normal: Listen
	-- "PLD0100", --(nogo)
	
	-- ・Dog commands 11/Normal: House
	-- "PLD0110", --(nogo)
	
	-- ・Dog commands 12/Normal: Open (mouth)
	-- "PLD0120", --(nogo)
	
	-- ・Dog commands 13/Normal: Bite
	-- "PLD0130", --(nogo)
	
	-- ・Dog commands 14/Normal: Leave it, drop it, give it
	-- "PLD0140", --(nogo)
	
	--・Dog commands 15/Normal: Hold (in mouth)
	-- "PLD0150", --(nogo)
	
	--・Dog commands 16/Normal: Bark
	"PLD0160",
	
	--・Dog commands 17/Normal: Fetch
	-- "PLD0170", --(nogo)
	
	-- ・Dog commands 18/Normal: Steal
	-- "PLD0180", --(nogo)
	
	-- ・Dog command 19/normal: Attack
	"PLD0190_3", -- Go! Attack! Get 'em!
	
	"PLD0190_4", -- Go get him!
	-- ・Dog command 20/normal: Stop the enemy/go
	"PLD0200_1", -- Stop 'em.
	-- "PLD0200_2", -- nogo
	-- "PLD0200_3", -- nogo
	"PLD0200_4", -- Hold 'em off!
	"PLD0200_5", -- Go get 'em!

	-- ・Dog command 21/normal: "Extract/go (recover)"
	-- "PLD0210_2", --nogo
	-- "PLD0210_3", -- nogo
	"PLD0210_4", -- Fulton 'em! Go get 'em! Extract!

	-- ・Playing with the dog: Shake hands (trick)

	-- ・Playing with the dog: Stand (trick)

	-- ・Playing with the dog: Play dead (trick)

	--・Dog commands 1/tense: Good, good
	"PLD0220", --snak1100_2u1010_0_snak Gooood, gooood.
	
	--・Dog commands 5/tense: Lie down
	"PLD0230", --snak1100_2v1010_0_snak Down.
	
	--・Dog commands 2/tense: OK
	"PLD0240", --snak1100_2w1010_0_snak OK, OK.
	
	--・Dog commands 3/tense: No
	"PLD0250", --snak1100_2x1010_0_snak No.
	
	--・Dog commands 4/tense: Sit
	"PLD0260", --snak1100_2y1010_0_snak Sit.
	
	--・Dog commands 6/tense: Stay
	"PLD0270", --SNAK1100_2z1010_0_snak Stay.
	
	--・Dog commands 7/tense: Stand
	"PLD0280", --SNAK1100_301010_0_snak Stand.
	
	--・Dog commands 8/tense: Quiet
	"PLD0290",
	
	--・Dog commands 9/Normal: Watch (the handler)
	-- "PLD0300", --(nogo)
	
	-- ・Dog commands 10/Normal: Listen
	-- "PLD0310", --(nogo)
	
	-- ・Dog commands 11/Normal: House
	-- "PLD0320", --(nogo)
	
	-- ・Dog commands 12/Normal: Open (mouth)
	-- "PLD0330", --(nogo)
	
	-- ・Dog commands 13/Normal: Bite
	-- "PLD0340", --(nogo)
	
	-- ・Dog commands 14/Normal: Leave it, drop it, give it
	-- "PLD0350", --(nogo)
	
	-- ・Dog commands 15/Normal: Hold (in mouth)
	-- "PLD0360", --(nogo)
	
	-- ・Dog commands 16/tense: Bark
	"PLD0370", --SNAK1100_391010_0_snak Bark.
	
	-- "PLD0380", --(nogo)
	
	-- "PLD0390", --(nogo)
	
	-- ・Dog command 19/normal: Attack
	"PLD0400_3", -- Go! Attack! Get him!
	
	"PLD0400_4", -- Go get him!
	
	-- ・Dog command 20/normal: Stop the enemy/go
	-- "PLD0410_2", --nogo
	-- "PLD0410_3", --nogo
	"PLD0410_4", -- Hold 'em off! Go get him! Stop 'em.
	
	-- ・Dog command 21/normal: "Extract/go (recover)"
	-- "PLD0420_2", -- nogo
	-- "PLD0420_3", -- noog
	"PLD0420_4", -- Fulton 'em! Extract!
	"PLD0420_5", -- Go get him!
	
	--・Playing with the dog: Shake hands (trick)
	"PLD0430", --SNAK1100_391310_0_snak Shake. 
	
	--・Playing with the dog: Stand (trick)
	-- "PLD0440", --(nogo)
	
	--・Playing with the dog: Play dead (trick)
	"PLD0450", --SNAK1100_391510_0_snak Play dead. 
	
	--・Playing with the dog: Good! (short)
	"PLD0460", --SNAK1100_391610_0_snak Good boy! 
	
	--・Playing with the dog: Go get it (frisbee)
	"PLD0470", --SNAK1100_391710_0_snak Go get it! 
	
	-- ・Playing with the dog: Calling DD
	"PLD0480", --snak1100_391910_0_snak DD. 
	
	-- ・Playing with the dog: Calling DD (from a distance)
	"PLD0490", --SNAK1100_391a10_0_snak DD!
	
	--			●  Walker Gear commands
	-- ・Calling Walker Gear (short range)
	"PLW0010_1", -- snak1100_4t2110_0_snak Chico.
	"PLW0010_2", -- SNAK1100_4t2210_0_snak Walker Gear.
	"PLW0010_3", -- SNAK1100_4t2220_0_snak D-Walker.
	
	-- ・Calling Walker Gear (long range)
	"PLW0020_1", -- SNAK1100_4t2310_0_snak Chico!
	"PLW0020_2", -- SNAK1100_4t2410_0_snak Walker Gear! 
	"PLW0020_3", -- SNAK1100_4t2420_0_snak D-Walker!
	
	-- ・Walker Gear command: Camera mode
	-- Activating/deactivating Walker Gear remote camera mode
	"PLW0030_1", --nogo DDSP1000_bh1010_0_enea Camera mode. (Staff only)
	"PLW0030_2", --nogo DDSP1000_bi1010_0_enea Camera. (Staff only)
	
	-- ・Walker Gear command: Stealth mode
	-- Ordering Walker Gear to activate its stealth camouflage mode
	"PLW0040_1", --Stealth mode.
	"PLW0040_2", --Stealth.
	-- "PLW0040_3", --nogo
	-- "PLW0040_4", --nogo
	
	-- ・Walker Gear command: Search mode
	-- Ordering Walker Gear to activate its surveillance camera mode
	"PLW0050_1", -- Search mode.
	-- "PLW0050_2", -- nogo
	"PLW0050_3", -- Stand guard.
	
	-- ・Walker Gear command: Weapon mode
	-- Activating/deactivating Walker Gear remote weapon mode (remote control)
	-- "PLW0060_1", --nogo v
	-- "PLW0060_2",
	-- "PLW0060_3",
	
	-- ・Walker Gear command: Weapon mode 2
	-- Alternate name for weapon mode
	-- "PLW0070_1",
	-- "PLW0070_2", -- nogo ^
	
	-- ・Walker Gear: Intercept mode
	-- Activating/deactivating Walker Gear automatic intercept mode
	"PLW0080_1", -- Intercept mode.
	"PLW0080_2", -- Fire.
	"PLW0080_3", -- Engage targets.
	
	-- ・Walker Gear command: Normal mode
	"PLW0090_2", -- Cancel.
	"PLW0090_3", -- Return.
	"PLW0090_4", -- Mode cancelled.
	-- DDSP1000_c11010_0_enea Normal mode.
	
	--			● Order to child
	-- ・Order to child: Follow me - normal
	"PLC0010_1", -- SNAK1100_4t3510_0_snak Come with me.
	"PLC0010_4", -- SNAK1100_4t3810_0_snak All right.
	
	-- ・Order to child: Go - normal
	"PLC0010_5", -- Go. Come on. Now. Let's go.
	
	-- ・Order to child: Follow me - tense
	"PLC0020_1", -- Come with me.
	"PLC0020_4", -- All right.
	
	-- ・Order to child: Go - tense
	"PLC0020_5", -- Go! Come on! Now! Let's go!
	
	-- ・Order to child: Wait - normal
	"PLC0050_1", -- Wait. Stop.
	
	-- ・Order to child: Wait - tense
	"PLC0060_1", -- Wait! Stop!
	
	-- "PLC0070", -- nogo v
	-- "PLC0080", 
	-- "PLC0090", 
	-- "PLC0100", 
	-- "PLC0110_1", 
	-- "PLC0110_2",
	-- "PLC0120_1",
	-- "PLC0120_2", -- nogo ^
	
	--			● Mission specific (not used)
	
	-- ・Comment when quiet vanishes from view
	--When following Quiet's footsteps after she's disappeared.
	"PLE0010", --snak1100_4t1610_0_snak Quiet...
	"PLE0020", --snak1100_4t1710_0_snak Where are you...?
	"PLE0030", --snak1100_4t1810_0_snak Don't just run off...
	"PLE0040", --snak1100_4t1910_0_snak Quit playing around...!
	
	-- ・Having to kill an infected comrade. Spoken softly. Pained and remorseful
	-- When shooting an infected comrade. The other person may still be conscious, but overall it looks like a monologue.
	"PLE0050", --snak1100_4t1a10_0_snak Forgive me...
	"PLE0060", --snak1100_4t1b10_0_snak I'm sorry...
	"PLE0070", --snak1100_4t1c10_0_snak Be at peace...
	"PLE0080", --SNAK1100_4t1d10_0_snak Nngg...ha...(stifled sobs of anger/pain/regret/remorse as he's forced to kill a comrade)
	-- Throat slice or headshot
	"PLE0090", --snak1100_4t1d30_0_snak Rest in peace. 
	-- ・Having to kill an infected comrade who's struggling or resisting.
	"PLE0100", --Nnggaahhh! (Stifled cry of anger/sadness as he's forced to kill a comrade)
	"PLE0110", --SNAK1100_4t1f10_0_snak Rraaagggghhhhh! (Wailing in lament as he's forced to kill a comrade)
	"PLE0120", --SNAK1100_4t1g10_0_snak Mmmpphh... (letting a short audible sob escape as he's forced to kill a comrade)
	"PLE0130", --SNAK1100_4t1h10_0_snak Haaa... Haaaaaa... (Coarse breathing. Like an enraged beast. Unable to control his anger as he overpowers and kills a comrade)
	"PLE0140", --SNAK1100_4t1i10_0_snak Aah! (short gasp of realization as he regains control of himself)
	
	-- ・ For events: Conversation with Paz in the hospital room 1 (Call her name for a response)
	"PLE0150_1", --2028706508 SNAK1200_101010_0_snak Paz. 
	"PLE0150_2", --2028706511 SNAK1200_111010_0_snak Paz. 
	"PLE0150_3", --2028706510 snak1200_121010_0_snak Paz, what's wrong?
	"PLE0150_4", --2028706505 SNAK1200_131010_0_snak Paz... 
	
	-- ・ For events: Conversation with Paz in the hospital room 2 (Greeting her when entering the room)
	"PLE0160_1", --2146425613 snak1200_141010_0_snak It's me.
	"PLE0160_2", --2146425614 snak1200_151010_0_snak How are you feeling?
	"PLE0160_3", --2146425615 snak1200_161010_0_snak Feeling any better?
	
	-- ・ For events: Conversation with Paz in the hospital room 3 (when showing a photo)
	"PLE0170_1", --324571478 snak1200_171010_0_snak Do you remember...?
	"PLE0170_2", --324571477 snak1200_181010_0_snak Take a look.
	"PLE0170_3", --324571476 snak1200_191010_0_snak Want to see?
	
	-- ・ For events: Conversation with Paz in the hospital room 4 (calming Paz down when she's confused)
	"PLE0180_1", --15920959 snak1200_1a1010_0_snak It's OK... It's OK.
	"PLE0180_2", --15920956 snak1200_1b1010_0_snak Paz, it's over.
	
	-- ・ For events: Conversation with Paz in the hospital room 5 (calming Paz down)
	"PLE0190_1", --1415266376 snak1200_1c1010_0_snak Just relax.
	"PLE0190_2", --1415266379 snak1200_1d1010_0_snak Don't worry.
	
	-- ・ For events: Conversation with Paz in the hospital room 6 (Don't overdo it)
	-- * When stopping her, Snake feels that she would have to remember, so he's more concerned about her rather than wanting to stop her from remembering, but should he stop her?
	"PLE0200_1", --730256008 snak1200_1e1010_0_snak Don't push yourself.
	"PLE0200_2", --730256011 snak1200_1f1010_0_snak Are you alright?
	
	-- ・ For events: Conversation with Paz in the hospital room 7 (denial of negative remarks)
	"PLE0210_1", --3625877887 snak1200_1g1010_0_snak No, that's not it.
	"PLE0210_2", --3625877884 snak1200_1h1010_0_snak Don't worry about it.
	
	-- ・ For events: Conversation with Paz in the hospital room 8 (Straightening her back)
	"PLE0220_1", --1152764690 snak1200_1i1010_0_snak There, now...
	"PLE0220_2", --1152764689 snak1200_1j1010_0_snak ... (sigh)
	
	-- ・ For events: Conversation with Paz in the hospital room 9 (Rest now)
	"PLE0230_1", --2974618825 snak1200_1k1010_0_snak Paz, you need to rest.
	"PLE0230_2", --2974618826 snak1200_1l1010_0_snak That's enough. Lie down.
	"PLE0230_3", --2974618827 snak1200_1m1010_0_snak Rest now.
	
	-- ・ For events: Conversation with Paz in the hospital room 10 (Following the conversation)
	"PLE0240_1", --1996420212 snak1200_1n1010_0_snak Right.
	"PLE0240_2", --1996420215 snak1200_1o1010_0_snak Yeah. 
	"PLE0240_3", --1996420214 snak1200_1p1010_0_snak Is that right...?
	
	-- ・ For events: Conversation with Paz in the hospital room 11 (Lying with muddy words)
	"PLE0250_1", --617863019 snak1200_1q1010_0_snak Huh? Yeah...
	"PLE0250_2", --617863016 snak1200_1r1010_0_snak Ah... Sure...
	
	-- ・ For events: Conversation with Paz in the hospital room 12 (Cheering her up)
	"PLE0260_1", --2439717150 snak1200_1s1010_0_snak Everything's gonna be alright.
	"PLE0260_2", --2439717149 snak1200_1t1010_0_snak It's OK, Paz... 
	
	-- ・ For events: Conversation with Paz in the hospital room 13 (Don't worry anymore)
	--Instead of "questions to the sick", "sick of the question"?
	"PLE0270_1", --3182580821 snak1200_1u1010_0_snak Don't worry about it.
	"PLE0270_2", --3182580822 snak1200_1v1010_0_snak It's nothing.
	
	-- ・ For events: Conversation with Paz in the hospital room 14 (Leave it to me (empty promise))
	"PLE0280_1", --3283269472 snak1200_1w1010_0_snak That's right...
	"PLE0280_2", --3283269475 snak1200_1x1010_0_snak Yeah...
	"PLE0280_3", --3283269474 snak1200_1y1010_0_snak Sure... 
	
	-- ・ For events: Conversation with Paz in the hospital room 15 (lightly apologize)
	"PLE0290_1", --810156311 snak1200_1z1010_0_snak Sorry I bothered you.
	"PLE0290_2", --810156308 snak1200_201010_0_snak Oh... excuse me.
	
	-- ・ For events: Conversation with Paz in the hospital room 16 (lie about the past)
	"PLE0300_1", --1222489145 snak1200_211010_0_snak Yeah, everyone's fine.
	"PLE0300_2", --1222489146 snak1200_221010_0_snak Doing just fine... 
	"PLE0300_3", --1222489147 snak1200_231010_0_snak Everyone's waiting for you to get better.
	"PLE0300_4", --1222489148 snak1200_241010_0_snak Chico wanted to see you too.
	"PLE0300_5", --1222489149 snak1200_251010_0_snak Not exactly... 
	
	
	--			● MB terminal / MB support (not used)
	-- ・iDroid/You're fired
	"PLI0001_001",--You're fired.
	"PLI0001_002",--See you around.
	
	-- ・iDroid/Quarantine
	"PLI0002_001",--We need to quarantine you.
	"PLI0002_002",--Report to quarantine...
	
	-- ・iDroid/Getting revenge
	"PLI0003_001",--Payback time.
	"PLI0003_002",--They're not getting away with that.
	
	-- ・iDroid/Developing nukes
	"PLI0004_001",--Do it.
	"PLI0004_002",--Commence development of nuclear weapons.
	
	-- ・iDroid/Doing away with nukes
	"PLI0005_001",--Decomission the nukes.
	"PLI0005_002",--Decommission them.
	
	--			● Past titles
	-- "PLM0010_001",--(nogo/GZ)Just like old times...
	"PLM0010_002",--This must be...! (GZ)
	-- "PLM0010_003",--(nogo/GZ)Yes!
	-- "PLM0010_004",--(nogo/GZ)This brings back some memories!
	-- "PLM0010_005",--(nogo/DEMO)Liquiiiiiiiiid!
	-- "PLM0010_006",--(nogo)Is this nostalgic?
	-- "PLM0010_007",--(nogo)Not very nostalgic.
	-- "PLM0010_008",--(nogo/GZ)I can't remember.
	-- "PLM0010_009",--(nogo)I don't want to remember this.
	"PLM0020_001",--Kept you waiting, huh? (decoy)
	-- "PLM0020_002",--(nogo)This is bad...
	-- "PLM0020_003",--(nogo)This is Snake. Can you hear me?"
	-- "PLM0020_004",--(nogo/DEMO)A surveillance camera...
	"PLM0020_005",--Kept you waiting, huh? (unsubtitled/s10020)
	
	--・Past game title reference (1): CQC combo dialogue
	"PLM0030", --SNAK1100_802010_0_snak Consecutive! C! Q! C!
	"PLM0040", --SNAK1100_803010_0_snak You're pretty good. (decoy)
	"PLM0050", --SNAK1100_804010_0_snak Not yet! It's not over yet!
	"PLM0060", --SNAK1100_804110_0_snak Kawanishi-noseguchi, Kinunobebashi, Takiyama, Uguisunomori, Tsuzumigataki, Tada, Hirano, Ichinotorii, &#xD;&#xA;Uneno, Yamashita, Sasabe, Kofudai, Tokiwadai, Myokenguchi.
	
	--・Using "Rocket Punch" prosthesis
	"PLP0010", --SNAK1100_7w1010_0_snak Fiiire!
	"PLP0020", --SNAK1100_7x1010_0_snak Eat this!
	"PLP0030", --SNAK1100_7y1010_0_snak Rocket... Puuuunch!
	
	--・Using "Jehuty" prosthesis
	"PLP0040", --SNAK1100_7z1010_0_snak Haidara!
	"PLP0050", --SNAK1100_801010_0_snak Haidaraaa!
	"PLP0060", --SNAK1100_811010_0_snak Haidaraaaaaa!
	
	-- Stun Arm
	"PLP0070_1", --SNAK1100_811210_0_snak HAAAAAA (lightning stun arm)
	
	"PLP0070_2", -- Sorry.
	"PLP0070_3", -- Forgive me.
	
	"PLP0070_4", -- Outta my way.
	"PLP0070_5", -- Here we go!
	
	"PLP0070_6", -- Burn!
	"PLP0070_7", -- Chew on this!
	
	--			● Calls to allies (spare)
	
	--			●Thanks/Encouragement
	
	--			●Calling out actions
	
	--			●After being interrogated
	
	--			Sortie prep: Osaka dialect
	"OSAKA010",--What are you waiting for? Let's do it! (etc more, no eng voice)
	--"snak_down_normal_01",--(nogo, from s10010)

	--			???
	--no-go?
	-- "PCV0010",
	-- "PCV0020",
	-- "PCV0030",
	-- "PCV0040",
	-- "PCV0050",
	-- "PCV0060",
	-- "PCV0070",
	-- "PCV0080",
	-- "PCV0090",
	-- "PCV0100",
	"PCV0110", --Luring animal whistle/bird call?
	-- "PCV0140",
	-- "PCV0150",
	-- "PCV0160",
	-- "PCV0170",
	-- "PCV0180",
	-- "PCV0190",
	-- "PCV0200",
	-- "PCV0210",
	-- "PCV0220",
	-- "PCV0230",
	-- "PCV0240",
	-- "PCV0250",
	-- "PCV0260",
	-- "PCV0270",
	-- "PCV0280",
	-- "PCV0290",
	-- "PCV0300",
	-- "PCV0310",
	-- "PCV0320",
	-- "PCV0330",
	-- "PCV0340",
	-- "PCV0350",
	-- "PCV0360",
	-- "PCV0370",
	-- "PCV0380",
	-- "PCV0390",
	-- "PCV0400",
	-- "PCV0410",
	-- "PCV0420",
	-- "PCV0430",
	-- "PCV0440",
	-- "PCV0450",
	-- "PCV0460",
	-- "PCV0470",
	-- "PCV0480",
	-- "PCV0490",
	-- "PCV0500",
	-- "PCV0510",
	-- "PCV0520",
	-- "PCV0530",
	-- "PCV0540",
	-- "PCV0550",
	-- "PCV0560",
	-- "PCV0570",
	-- "PCV0580",
	-- "PCV0590",
	-- "PCV0600",
	-- "PCV0610",
	-- "PCV0620",
	-- "PCV0630",
	-- "PCV0640",
	-- "PCV0650",
	-- "PCV0660",
	-- "PCV0670",
	-- "PCV0680",
	-- "PCV0690",
	-- "PCV0700",
	-- "PCV0710",
	-- "PCV0720",
	-- "PCV0730",
	-- "PCV0740",
	-- "PCV0750",
	-- "PCV0760",
	-- "PCV0770",
	-- "PCV0780",
	
	--			Visiting Quiet (requires p31_030020.sbp/Visit Quiet side op active)
	--p31_030020_0050 --What? (there has to be more matches in p31_030020)
	"p31_030020_0090", --What's wrong with her?
	"p31_030020_0110", --She's okay?
	"p31_030020_0140", --She doesn't eat either?
	"p31_030020_0160", --Photosynthesis? That's the verdict from the Medical staff?
	"p31_030020_0200", --Can't you send her on a mission?
	
	--COLLISIONS
	-- Luring enemy?
	"a04awoo6",--824615362 snak1100_181310_0_snak Hey! snak1100_181410_0_snak Over here. snak1100_181510_0_snak Are you blind?
	
	-- ● Buddy commands
	
	-- ・Buddy commands 1/Normal: Come here
	-- Normal conversation volume, from about 3-5 meters away.
	"ran_xu", -- 3231876494 2FFB44BF.wem Come here. SNAK1100_3a1010_0_snak 
	-- Lowered voice. Also used for speaking over the radio.
	"ah7x_hj", -- 2339123532 2FFB4374.wem Come here!  SNAK1100_421010_0_snak 
	--・Buddy commands 2/Normal: Come back
	"dg4lk8", -- 1216583739 2FFB44C2.wem Come back.  SNAK1100_3b1010_0_snak
	"apv5nsa", -- 517269273 2FFB4377.wem Come back!   SNAK1100_431010_0_snak
	-- ・Buddy commands 3/Normal: Wait
	"ohz30i", -- 2990382580 2FFB44C5.wem Wait. SNAK1100_3c1010_0_snak
	"awl_ga4", -- 2990382566 2FFB437A.wem Wait!  SNAK1100_441010_0_snak
	
	-- ・Buddy commands 4/Normal: Get in
	-- Entering a vehicle
	"b817bb6", -- 3969687823 2FFB44CE.wem Let's go. SNAK1100_3d1210_0_snak
	"cjz_5ol", -- 751342249 2FFB4383.wem Let's go.  SNAK1100_451210_0_snak
	-- ・Buddy commands 5/Normal: Get out
	-- Exiting a vehicle
	"qx6z6", -- 3655115736 2FFB44D7.wem We're here. SNAK1100_3e1210_0_snak
	"ax23v_4", -- 3652158590 2FFB438C.wem We're here.  SNAK1100_461210_0_snak
	
	-- ・Buddy commands 6/Normal: Go
	"cc4qhn3", -- 3525387327 2FFB44DA.wem Go. SNAK1100_3f1010_0_snak
	"et004ts", -- 3525387309 2FFB438F.wem Go!  SNAK1100_471010_0_snak
	-- ・Buddy commands 7/Normal: Don't go
	"ccwp5ni", -- 1703533288 2FFB44DD.wem Don't go. SNAK1100_3g1010_0_snak
	"a87b355", -- 1703533306 2FFB4392.wem Don't go!  SNAK1100_481010_0_snak
	
	-- ・Buddy commands 8/Normal: Enter
	-- "", -- SNAK1100_3h1010_0_snak Go in.
	-- "", -- SNAK1100_491010_0_snak Go in! 
	-- ・Buddy commands 9/Normal: Exit
	-- "", -- SNAK1100_3i1010_0_snak Go out.
	-- "", -- SNAK1100_4a1010_0_snak Go out! 
	
	-- ・Buddy commands 10/Normal: Climb
	"awtfcpj", -- 2595080292 2FFB44E6.wem Climb up. SNAK1100_3j1010_0_snak
	"awtfcpx", -- 2595080310 2FFB439B.wem Climb up. SNAK1100_4b1010_0_snak
	-- ・Buddy commands 11/Normal: Descend
	"aldwskf", -- 1216523131 2FFB44E9.wem Climb down. SNAK1100_3k1010_0_snak
	"a8xq9j_", -- 1216523113 2FFB439E.wem Climb down! SNAK1100_4c1010_0_snak
	
	-- ・Buddy commands 12/Normal: Go right
	-- With the player in the middle, order to flank to the right
	-- "", -- SNAK1100_3l1010_0_snak 
	-- "", -- SNAK1100_4d1010_0_snak Go right! 
	-- ・Buddy commands 13/Normal: Go left
	-- With the player in the middle, order to flank to the left
	-- "", -- SNAK1100_3m1010_0_snak 
	-- "", -- SNAK1100_4e1010_0_snak Go left! 
	
	-- ・Buddy commands 14/Normal: Attack
	"mjmbur", -- 1329019160 2FFB44F2.wem Attack! SNAK1100_3n1010_0_snak
	"a_kb0q7", -- 1329019146 2FFB43A7.wem Attack. SNAK1100_4f1010_0_snak
	-- ・Buddy commands 15/Normal: Fire
	"a4vbrnu", -- 4224641135 2FFB44F5.wem Fire. SNAK1100_3o1010_0_snak
	"a4vbrng", -- 4224641149 2FFB43AA.wem Fire! SNAK1100_4g1010_0_snak
	-- ・Buddy commands 16/Normal: Kill him
	-- Out of options, giving the regrettable order to kill
	"h67jo5", -- 2273756360 2FFB44FE.wem Killshot! SNAK1100_3p1210_0_snak
	"b5swqbe", -- 2276022030 2FFB43B3.wem Killshot. SNAK1100_4h1210_0_snak
	-- ・Buddy commands 17/Normal: Knock him out
	"agic2ee", -- 2142205631 2FFB4507.wem Knockout! SNAK1100_3q1210_0_snak
	"d4gxezf", -- 2139939961 2FFB43BC.wem Knockout. SNAK1100_4i1210_0_snak
	
	-- ・Buddy commands 18/Normal: Head shot
	-- "", -- SNAK1100_3r1010_0_snak Head shot.
	-- "", -- SNAK1100_4j1010_0_snak Headshot!
	-- ・Buddy commands 19/Normal: Arm shot
	-- "", -- SNAK1100_3s1010_0_snak Arm shot.
	-- "", -- SNAK1100_4k1010_0_snak Arm shot! 
	-- ・Buddy commands 20/Normal: Leg shot
	-- "", -- SNAK1100_3t1010_0_snak Leg shot.
	-- "", -- SNAK1100_4l1010_0_snak To the leg!
	
	-- ・Buddy commands 21/Normal: Pull back
	"rpk9ad", -- 2627469788 2FFB4513.wem Pull back! SNAK1100_3u1010_0_snak
	"rpk9av", -- 2627469774 2FFB43C8.wem Pull back. SNAK1100_4m1010_0_snak
	
	-- ・Buddy commands 22/Tense: Retrieve
	-- "", -- SNAK1100_3v1010_0_snak  Take it.
	-- "", -- SNAK1100_4n1010_0_snak Grab it.
	
	-- ・Buddy commands 23/Normal: Destroy
	"cubiwa8", -- 923231558 2FFB4522.wem Destroy it. SNAK1100_3w1010_0_snak
	"b9_qrqo", -- 923231572 2FFB43D7.wem Destroy it. SNAK1100_4o1010_0_snak
	-- ・Buddy commands 24/Normal: Blow up
	"abiyef", -- 2093826759 2FFB4525.wem Blow it up. SNAK1100_3x1010_0_snak
	"abiyet", -- 2093826773 2FFB43DA.wem Blow it up. SNAK1100_4p1010_0_snak
	-- ・Buddy commands 25/Normal: Rescue
	-- Command to rescue a target individual, etc.
	"cmmyqh8", -- 271972528 2FFB4528.wem Mount a rescue. SNAK1100_3y1010_0_snak
	"hkz70p_", -- 271972514 2FFB43DD.wem Mount a rescue. SNAK1100_4q1010_0_snak
	
	-- ・Buddy commands 26/Normal: Help me
	-- Call for help when Snake is near death
	"aeg0ek3", -- 1458236305 2FFB452B.wem Need help... SNAK1100_3z1010_0_snak
	"aunz815", -- 1458236291 2FFB43E0.wem Need help. SNAK1100_4r1010_0_snak
	-- ・Buddy commands 27/Normal: Cover me
	-- General command to provide cover, either for Snake, or for another friendly
	"a4bjfpz", -- 3931349626 2FFB452E.wem Cover fire! SNAK1100_401010_0_snak
	"a4bjfph", -- 3931349608 2FFB43E3.wem Cover fire. SNAK1100_4s1010_0_snak
	
	-- ・Buddy commands 28/Normal: Hide
	-- Ordering nearby friendlies to hide
	"ak39u2c", -- 1901533371 2FFB4531.wem Hide! SNAK1100_411010_0_snak
	"ak39u2q", -- 1901533353 2FFB43E6.wem Hide. SNAK1100_4t1010_0_snak
	-- ・Buddy commands 29/Normal: Go take a look (recon)
	"ay14uz_", -- 3280090532 2FFB4534.wem Scout ahead. SNAK1100_411110_0_snak
	"vsfdm3", -- 3280090550 2FFB43E9.wem Scout ahead. snak1100_4t1110_0_snak
	-- ・Buddy commands 30/Normal: Lure them
	"a4mieo6", -- 3595008546 2FFB4537.wem Lure 'em out. SNAK1100_411210_0_snak
	"fbtyl13", -- 3595008560 2FFB43EC.wem Lure 'em out. SNAK1100_4t1210_0_snak
	-- ・Buddy commands 31/Normal: Put him to sleep
	"ask2juj", -- 1121895545 2FFB453A.wem Nap time. SNAK1100_411310_0_snak
	"ask2jux", -- 1121895531 2FFB43EF.wem Nap time... SNAK1100_4t1310_0_snak
	
	-- ・Buddy commands 32/Normal: Crouch down
	"dfnnxp5", -- 1004279480 2FFB453D.wem Crouch down! SNAK1100_411410_0_snak
	"g0vqytn", -- 1004279466 2FFB43F2.wem Crouch down. SNAK1100_4t1410_0_snak
	-- ・Buddy commands 33/Normal: Lie down
	"i3dava", -- 1752365967 2FFB4540.wem Go prone! SNAK1100_411510_0_snak
	"i3davs", -- 1752365981 2FFB43F5.wem Go prone. SNAK1100_4t1510_0_snak
	-- ・Buddy commands 34/Normal: Follow me
	"acsjyc4", -- 566205358 2FFB4543.wem Follow me! SNAK1100_411610_0_snak
	"km0pli", -- 566205372 2FFB43F8.wem Follow me. SNAK1100_4t1530_0_snak
	
	-- ・Ally command 35/normal: Aim
	-- Command to target the individual Snake is looking at through binoculars
	"a0mbzt", -- 3477392741 2FFB1041.wem Take aim. SNAK1100_411710_0_snak 2FFB415C.wem Get ready. SNAK1100_411810_0_snak 2FFB415F.wem Prepare to fire. SNAK1100_411910_0_snak 2FFB4162.wem On my command. SNAK1100_411a10_0_snak
	"a0mbzf", -- 3477392759 2FFAF3F2.wem Take aim! SNAK1100_4t1531_0_snak 2FFB4127.wem Get ready! SNAK1100_4t1532_0_snak 2FFB412A.wem Prepare to fire! SNAK1100_4t1533_0_snak 2FFB412D.wem On my command! SNAK1100_4t1534_0_snak
	
	"gc1grl", -- 1534173945 2FFB103E.wem Fire. SNAK1100_411b10_0_snak
	"a9g214f", -- 1534173931 2FFAF3F5.wem Fire! SNAK1100_4t1535_0_snak
	
	-- ・Ally command 36/normal: Start covering fire
	-- Getting ally to offer fire support
	"c86kmbn", -- 2729493850 3D312C96.wem Begin cover fire. SNAK1100_411d20_0_snak 2FFB1044.wem Fire at will. SNAK1100_411d30_0_snak 2FFB4168.wem Cover me! SNAK1100_411c10_0_snak
	"f7c1qzc", -- 3806218740 3C072F55.wem Begin cover fire! SNAK1100_4t1555_0_snak 2FFAF736.wem Fire at will! SNAK1100_4t1556_0_snak Cover me! SNAK1100_4t1536_0_snak
	
	-- ・Ally command 37/normal: Stop covering fire
	"d59qjtq", -- 3329699373 2FFB4139.wem Cease fire! SNAK1100_4t1538_0_snak
	"aelvjjw", -- 2258888904 2FFB4171.wem OK! SNAK1100_411f10_0_snak
	"d59qjtr", -- 3329699374 2FFB413C.wem OK! SNAK1100_4t1539_0_snak
	"aelvjjv", -- 2258888905 0CDC0624.wem Cease cover fire! SNAK1100_411f11_0_snak 2FFB1047.wem Stand down! SNAK1100_411f12_0_snak 2FFB416E.wem Cease fire! SNAK1100_411e10_0_snak
	"d59qjts", -- 3329699375 2FFAF739.wem Stand down! SNAK1100_4t1541_0_snak 2FFB413F.wem Cease cover fire! SNAK1100_4t1540_0_snak

	--			● General purpose (call name)
	--・Calling a person's name/Normal: Ocelot
	"a0ffdctv", -- 578780155 2FFB4546.wem Ocelot. SNAK1100_4u1010_0_snak
	--・Calling a person's name/Tense: Ocelot
	--Addressing person while in hiding; can also be spoken over the radio
	-- "atv92n7", -- 578780148 SNAK1100_4v1010_0_snak (nogo, no sound)
	--・Calling a person's name/Scream: Ocelot
	--Shouting, concerned for person's welfare
	-- "c_wn0_o", -- 578780134 SNAK1100_4w1010_0_snak (nogo, no sound)
	
	--・Calling a person's name/Normal: Miller
	"pltgk03b", -- 3238208592 2FFB4549.wem Kaz. SNAK1100_4x1010_0_snak
	--・Calling a person's name/Tense: Miller
	--Addressing person while in hiding; can also be spoken over the radio
	"cfx_jy_", -- 3238208589 2FFB4425.wem Kaz. SNAK1100_4y1010_0_snak
	--・Calling a person's name/Scream: Miller
	--Shouting, concerned for person's welfare
	"yg1ei3", -- 3238208607 2FFB4676.wem Kaaaz! SNAK1100_4z1010_0_snak
	
	--・Calling a person's name/Normal: Quiet
	"bqx5qwv", -- 4028777139 2FFB446A.wem Quiet! SNAK1100_501010_0_snak
	--・Calling a person's name/Tense: Quiet
	--Addressing person while in hiding; can also be spoken over the radio
	"bqx5qwk", -- 4028777134 2FFB4281.wem Quiet. SNAK1100_511010_0_snak
	--・Calling a person's name/Scream: Quiet
	--Shouting, concerned for person's welfare
	"bqx5qwy", -- 4028777148 16D52F63.wem Quiet!! SNAK1100_521010_0_snak
	
	--・Calling a person's name/Normal: DD
	"acxlu7h", -- 3419315795 2FFB454C.wem DD. SNAK1100_531010_0_snak
	--・Calling a person's name/Tense: DD
	--Addressing person while in hiding; can also be spoken over the radio
	"acxlu7u", -- 3419315790 2FFB4428.wem DD! SNAK1100_541010_0_snak
	--・Calling a person's name/Scream: DD
	--Shouting, concerned for person's welfare
	"acxlu7g", -- 3419315804 2FFB4679.wem DD!! SNAK1100_551010_0_snak

	--			● General-purpose dialogue
	--・Alert to those around: Hurry to the chopper!
	"aerw5fq", -- 1002082164 2FFB42F2.wem To the chopper! SNAK1100_7s1011_0_snak
	"aerw5fr", -- 1002082167 2FFB42F5.wem On the chopper! SNAK1100_7s1012_0_snak
	--・Alert to those around: Get away!
	"a9klykb", -- 3339433048 2FFB42F8.wem Scatter! SNAK1100_7s1013_0_snak
	"a9klyka", -- 3339433051 2FFB42FB.wem Disperse! SNAK1100_7s1014_0_snak
	--・Alert to those around: Run!
	"eyl101n", -- 887108239 2FFB42FE.wem Run! SNAK1100_7s1015_0_snak
	"eyl101m", -- 887108236 2FFB4301.wem Ruuun!! SNAK1100_7s1016_0_snak
	
	-- Unknown - no sounds attached, no matches
	-- 1360924909
	-- 1360924927
	-- 154356705
	-- 154356723
	-- 1942459278
	-- 1942459292
	-- 2003040466
	-- 2003040468
	-- 2003040469
	-- 2003040471
	-- 2139939960
	-- 2139939963
	-- 2142205629
	-- 2142205630
	-- 2273756361
	-- 2273756362
	-- 2276022028
	-- 2276022031
	-- 2542132838
	-- 2542132852
	-- 2542132859
	-- 2556184874
	-- 2556184887
	-- 2556184888
	-- 2729493851
	-- 3038377102
	-- 3038377116
	-- 3079073753
	-- 3079073754
	-- 3079073755
	-- 3079073756
	-- 3308417094
	-- 3308417108
	-- 3308417115
	-- 3652158588
	-- 3652158591
	-- 3655115737
	-- 3655115738
	-- 3764313505
	-- 3764313523
	-- 3781344069
	-- 3781344087
	-- 3806218741
	-- 3834037956
	-- 3834037974
	-- 3969687821
	-- 3969687822
	-- 4162981037
	-- 4162981040
	-- 4162981055
	-- 751342248
	-- 751342251 
}

-- Play player voice
this.PlayVoice={
	settings={
		"pla0010_001",
	},
	OnActivate=function(self,setting)
		Player.CallVoice(self.settings[setting+1])
	end
}

-- Play sfx
this.PostEvent={
	settings={
		"sfx_s_enemytag_main_tgt",
	},
	OnActivate=function(self,setting)  
		TppSoundDaemon.PostEvent(self.settings[setting+1])
	end
}

-- Play 3d sfx at last marker
this.PostEvent3D={
	settings={
		"sfx_m_door_buzzer",
	},
	OnActivate=function(self,setting)  
		local lastMarkerIndex=InfUserMarker.GetLastAddedUserMarkerIndex()
		if lastMarkerIndex==nil then
			InfMenu.PrintLangId"no_marker_found"
			return
		else
			local markerPostion=InfUserMarker.GetMarkerPosition(lastMarkerIndex)
			TppSoundDaemon.PostEvent3D(self.settings[setting+1],Vector3(markerPostion:GetX(),markerPostion:GetY(),markerPostion:GetZ()))
		end
	end
}

-- Play scene bgm
this.PlaySceneMusic={
	settings={
		"cd_jc3t", -- 366716151 start fob terminal bgm 15DBA4F7 
		"b6aa7gj", -- 2308271145 stop fob terminal bgm 89956C29 
		"Play_bgm_common_jingle_clear",
		"Play_bgm_common_jingle_failed",
		"Play_bgm_common_jingle_achieved",
		"Play_bgm_common_jingle_op",
		"Play_bgm_common_jingle_ed",
		"Play_bgm_mission_heli_descent_short",
		"Play_bgm_afgh_jingle_op",
		"Play_bgm_mafr_jingle_op",
		"Play_bgm_s10151_jingle_ed",
		"Set_Switch_bgm_jingle_result_kaz",
		"Play_bgm_gntn_phase",
		"Set_State_bgm_phase_al_es",
		"Set_State_bgm_phase_ct",
		"Set_State_bgm_phase_ev",
		"Set_State_bgm_phase_lost",
		"Set_State_bgm_phase_neutral",
		"Set_State_bgm_phase_nt",
		"Set_State_bgm_phase_sn",
		"Set_Switch_bgm_phase_reflex_on",
		"Set_Switch_bgm_phase_time_day",
		"Set_Switch_bgm_phase_time_night",
		"bgm_phase_al_es",
		"bgm_phase_ct",
		"bgm_phase_ev",
		"bgm_phase_lost",
		"bgm_phase_neutral",
		"bgm_phase_nt",
		"bgm_phase_sn",
		"bgm_phase_reflex_on",
		"bgm_phase_time_day",
		"bgm_phase_time_night",
	},
	OnActivate=function(self,setting)
		TppMusicManager.PostJingleEvent("SingleShot",self.settings[setting+1])
	end
}

this.registerMenus={
	"PlaySoundMenu",
}

this.PlaySoundMenu={
	parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
	options={
		"PlaySoundMenu.PlayVoice",
		"PlaySoundMenu.PostEvent",
		"PlaySoundMenu.PostEvent3D",
		"PlaySoundMenu.PlaySceneMusic",
	}
}

function this.Messages()
	return Tpp.StrCode32Table{
		
	}
end

function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
	Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText)
end

function this.Init(missionTable)
	this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

return this