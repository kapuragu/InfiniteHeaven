local this={}

this.registerIvars={
    "PlayRadio",
    "PlayVoice",
    -- "ShowIntelIcon",
    -- "PlaySound3D",
    -- "AddSpecialNoiseAtLastMarker",
	"PlaySupportRadio",
	"CallVoiceOcelot",
	"SetOccasionalChatList",
	"isEnableCode102",
}

this.isEnableCode102={
	save=IvarProc.CATEGORY_EXTERNAL,
	range=Ivars.switchRange,
	settingNames="set_switch",
	default=0,
	OnChange=function(self,setting)
		this.EnableCode102((setting == 1))
	end,
}

this.SoldierToCp={
	"CPR0038", --After communications equipment is destroyed (combat alert)
	"CPR0200", --Fire a flare to illumniate the area
	
	"CPR0210", --Taking fire from enemy gunship
	"CPR0220", --Focus all your fire on that enemy chopper

	"CPR0230", --Lost prisoner
	"CPR0250", --Lost Paz
	"CPR0271", --Lost Chico
	"CPR0281", --Located prisoner
	"CPR0282", --Located Paz
	"CPR0283", --Located Chico
	"CPR0284", --Waiting for a response on that prisoner

	"CPR0350", --Lost contact in north sector
	"CPR0351", --Lost contact in northeast sector
	"CPR0352", --Lost contact in east sector
	"CPR0353", --Lost contact in southeast sector
	"CPR0354", --Lost contact in south sector
	"CPR0355", --Lost contact in southwest sector
	"CPR0356", --Lost contact in west sector
	"CPR0357", --Lost contact in northwest sector
	"CPRGZ0010", --Admin building
	"CPRGZ0011", --Admin helipad
	"CPRGZ0012", --Northeast coastline
	"CPRGZ0013", --Old prison area
	"CPRGZ0014", --East refugee camp
	"CPRGZ0015", --West refugee camp
	"CPRGZ0016", --Warehouse area
	"CPRGZ0017", --South cliff
	"CPRGZ0018", --Admin front gate
	"CPRGZ0019", --East-side crossing
	"CPRGZ0020", --Open the gate

	"CPRGZ0040", --Visiting officer found dead

	"CPI0100", --・CPI0100: Request repeat: Soldier > CP /Engaging enemy
	"CPI0110", --・CPI0110: Request repeat: CP > Soldier /Engaging enemy

	"CPR0049", --・CPR0049: Caution status: Order to remain on alert
	"HQR0080", --・HQR0080: inter-outpost communications are down
	"HQR0090", --・HQR0090: inter-outpost communications are working again

	"HQR0100", --・HQR0100: HQ has deployed helicopter
	"HQR0110", --・HQR0110: HQ has deployed tank
	"HQR0120", --・HQR0120: HQ has deployed armored vehicle
	"HQR0130", --・HQR0130: HQ orders checkpoint to be set up
	"HQR0140", --・HQR0140: HQ orders deployment of a retaliation team
	"HQR0150", --・HQR0150: Initiating helicopter patrol
	
	"CPR0042",--VIP's body found
	
	"CPR0022ENE",--Player has been spotted by a security camera. / Soldier response
	"CPR0037",--Player destroyed comms equipment (normal phase)
	"CPR0038_102",--After communications equipment is destroyed (combat alert)
	"CPR0042_KEEP",--VIP's body found / Order to remain on alert
	"CPR0049",--Order to remain on alert
	"CPR0064",--Order to continue search
	"CPR0071",--Search complete (Intense / emotional)
	"CPR0079",--Release from alert (Calm/Hushed)
	"CPR0191_KEEP",--Instruction to end observation (keep in caution)
	"CPR0231",--prisoner dead body version
	"CPR0232",--requesting investigation of fallen comrade
	"CPR0233",--Denying request from CPR0232
	"CPR0234",--requesting someone to investigate escaped prisoner who has been discovered
	"CPR0235",--Denying request from CPR0234
	"CPR0251",--Female prisoner (Paz) is gone / General purpose
	"CPR0270",--Chico is gone
	"CPR0339",--Monitor Room (directly lead into CPR0022)
	"CPR0360",--Shifting security focus / (2) "Slightly sngry." variation.
	"CPR03610",--Shifting security focus / (3) "Cool and collected." variation.
	"CPRGZ0110",--Shifting security focus /Admin  / (2) "Slightly sngry." variation
	"CPRGZ0210",--Shifting security focus /Admin / (3) "Cool and collected." variation.
	"CPRGZ0021",--Open gate (verbose)
	"CPRGZ0040_UNKEEP",--"Eliminate the Renegades" mission only
}

this.PlayerVoiceIds={
	-- All commented entries exist as hashes in HIRC sections, but don't play and don't have linked Sound objects.
	
	-- ◆Snake In-game Voices◆

	-- ■ＧＺ
	-- from GZ
	--・1: Hold-up 1
	-- Shoves gun into enemy:
	"PLA0010_001",-- (Lowers voice to intimidate enemy)Don't move! SNAK1000_101010
	--・2: Hold-up 2
	-- Shoves gun into enemy:
	"PLA0010_002",-- (Lowers voice to intimidate enemy)Hands up! SNAK1000_111010
	
	--・3: Restraining enemy, order 1 during hold-up
	-- Make enemy give false response to received radio call.
	"PLA0020_001",-- Lie to them. SNAK1000_121010 
	"PLA0020_002",-- Respond. SNAK1000_131010
	"PLA0020_003",-- Pick up! (the radio) SNAK1000_141010
	
	--・4: Restraining enemy, order 2 during hold-up
	-- Extract useful information from enemy.
	"PLA0030_001",-- Spit it out! SNAK1000_151010
	"PLA0030_002",-- Speak. SNAK1000_161010
	"PLA0030_003",-- Talk. SNAK1000_171010_0_snak
	
	--・5: Restraining enemy, order 3 during hold-up
	-- Force enemy to call in comrades.
	"PLA0040_001",-- Call them(your comrades). SNAK1000_181010
	"PLA0040_002",-- Call your friends. SNAK1000_191010
	"PLA0040_003",-- Call them over. SNAK1000_1a1010
	
	--・6: Order during hold-up
	-- Make enemy lie face-down.
	"PLA0050_001",-- Get down. SNAK1000_1b1010
	"PLA0050_002",-- Lie down. SNAK1000_1c1010
	"PLA0050_003",-- On the ground! SNAK1000_1d1010

	--・7: Command while enemy is grabbed or held up 4
	-- Asking location of soldier's comrades
	"PLA0051_001",-- Where are the others? SNAK1000_1d1014
	"PLA0051_002",-- Where are your friends? SNAK1000_1d1018

	-- GZ-Only:
	-- 8
	"PLA0053_001", -- HQ. snak1000_1d1110 2ffaa056.wem
	"PLA0053_002", -- Mother Base. snak1000_1d1210 2ffaa059.wem
	-- 9
	"PLA0053_003", -- Intel. snak1000_1d1310 2ffaa05c.wem
	-- 10
	"PLA0053_004", -- Request Morpho. snak1000_1d1410 2ffaa05f.wem
	"PLA0053_005", -- Request chopper. snak1000_1d1510 2ffaa062.wem
	-- 11
	"PLA0053_006", -- (unsubtitled) Come here. snak1000_1d1610
	-- 12
	"PLA0053_007", -- (unsubtitled) Come back. snak1000_1d1710
	
	--・20: Witnessed by enemy
	--Seems like player was spotted by enemy/enemies
	"PLA0060_001", -- SNAK1000_1s1010
	"PLA0060_002", -- SNAK1000_1t1010
	"PLA0060_003", -- SNAK1000_1u1010
	
	--･21: Medical treatment - slight show of pain (dislocation)
	-- "(ADR video available for reference - "Yell in pain," "Grit your teeth and grunt in pain," - 2 patterns)" SNAK1000_1v1010 SNAK1000_1v1110
	"PLA0070_001",
	"PLA0070_002",
	--･22: Medical treatment - medium show of pain (gunshot/cut wound, lots of LIFE remaining)
	-- "(ADR video available for reference - "Yell in pain," "Grit your teeth and grunt in pain," - 2 patterns)" SNAK1000_1w1010 SNAK1000_1w1110
	"PLA0070_003",
	"PLA0070_004",
	--･23: Medical treatment - major show of pain (gunshot/cut wound, little LIFE remaining) SNAK1000_1x1010 SNAK1000_1x1011
	"PLA0070_005",
	"PLA0070_006",
	
	--・24: KIAI - Performing an action/CQC (very light and very short)
	-- "(3 patterns of short, sharp exhalations through the nose when starting CQC [mouth closed].)" SNAK1000_1x1110 SNAK1000_1x1210 SNAK1000_1x1310
	
	"PLA0079_001",
	
	--・25: KIAI - Performing an action/CQC (light and short)
	"PLA0080_001", --"(3 patterns of Snake quickly punching someone. E.g: Ha! Hmph! Etc. )" SNAK1000_1y1010 SNAK1000_1y1110 SNAK1000_1y1210
	
	--･26: KIAI - Performing an action/CQC (medium)
	"PLA0090_001", --"(3 patterns of Snake kicking someone. E.g: Fnn! Fu! Etc.)" SNAK1000_1z1010 SNAK1000_1z1110 SNAK1000_1z1210
	
	--･27: KIAI - Performing an action/CQC (heavy)
	"PLA0100_001", --"(3 patterns of Snake throwing someone. E.g: Hyaah! Huaa! Etc.)" SNAK1000_201010 SNAK1000_201110 SNAK1000_201210
	
	--･28: KIAI - Performing an action/CQC (very large movements)
	"PLA0110_001", --Hahh!
	
	--･29: KIAI (fail)
	"PLA0120_001", --Huhgh... _221012
	
	--･30: Roaring while shooting
	"PLA0130_001", --AaaaaaaaAaaAaAah!
	
	--･31: When hit/damaged (light) 
	"PLA0140_001", --"(3 patterns of Snake grunting/yelling quietly after being punched or sustaining minor damage.)" SNAK1000_241010 SNAK1000_241110 SNAK1000_241210
	
	--･32: When hit/damaged (heavy) 
	"PLA0150_001", --"(3 patterns of Snake grunting/yelling loudly after taking a heavy blow such as a roundhouse kick, etc.)" SNAK1000_241310 SNAK1000_241410 SNAK1000_241510
	
	--･33: When hit/damaged (dead) 
	"PLA0160_001", --"(Yell when dying / death throes)"
	
	--･34: When hit/damaged (gunshot) 
	"PLA0170_001", --"(3 patterns of Snake yelling when getting shot. E.g: Gg..., Gha..., etc)" SNAK1000_271010 SNAK1000_271110 SNAK1000_271210
	
	--･35: When hit/damaged (stroked) 
	"PLA0180_001", -- NOGO
	
	--･36: When hit/damaged (slashed)
	"PLA0190_001", --"(3 patterns of Snake yelling when being slashed with a machete. E.g: Gg, Dha!, etc)" SNAK1000_291010 SNAK1000_291210
	
	--･37: When hit/damaged (bombed)
	"PLA0200_001", --"(3 patterns of Snake yelling when blasted by an explosion. E.g: Gha, Dhoa!, etc)" SNAK1000_2a1010 SNAK1000_2a1110 SNAK1000_2a1210

	--･38: When hit/damaged (stun grenades)
	-- "PLA0210_001", -- NOGO
	
	--･39: Cough 1
	"PLA0220_001", --"(Variety of short coughs due to inhalation of smoke or tear gas.") SNAK1000_2c1010
	
	--･40: Cough 2
	"PLA0220_002", -- NOGO
	
	--･41: Cough (End)
	"PLA0220_003", -- nogo
	
	--･42: Falling
	"PLA0230_001", --"(3 patterns of Snake screaming when falling from a high place. E.g: AAAAAAAAAAAAaaa, Whaaaaaaaaaaaaaaaaaa, etc.)" SNAK1000_2f1010
	
	--･43: Die after falling
	"PLA0240_001", -- nogo
	
	--･44: Faint
	"PLA0250_001", -- nogo
	
	--･45: Waking from sleep/blackout
	--"(3 patterns of Snake moaning when waking up from regular sleep or from blackout. E.g: Unn..., nkkk..., etc.)" SNAK1000_2i1010 SNAK1000_2i1110

	--･46: Breathing (idle)
	"PLA0270_001", --(breathes)
	
	--･47: Breathing (little LIFE remaining, heavily wounded)
	"PLA0280_001", --Ackhh... 2k1010
	
	--･48: Breathing (little LIFE remaining, almost dead)
	"PLA0290_001", --"(Snake breathing extremely hard with accumulated damage.") SNAK1000_2l1010
	
	--･49: Breathing (sprinting)
	"PLA0300_001", --"(Few seconds of panting while sprinting.") SNAK1000_2m1010
	
	--･50: Breathing (Emergency detour)
	"PLA0310_001", --Huhhg!
	
	--■TPP
	-- ●TPP Snake ingame voices
	
	--"PLA0320_001"
	--"PLA0320_002"
	--"PLA0320_003"

	-- ・Taking medicine (pills)
	-- Swallowing pills
	-- (throws a pill in his mouth and swallows it) SNAK1100_101010
	-- (throws several pills in his mouth, then swallows them a moment later SNAK1100_111010

	--・Snoring
	"PLA0330", --SNAK1100_1c1010_0_snak (snoring)
	
	--・Sleeping
	"PLA0340", --SNAK1100_1d1010_0_snak (sleeping peacefully)
	
	"PLA0350_1", --NOGO v
	"PLA0350_2",
	
	"PLA0360_1",
	"PLA0360_2",
	
	"PLA0370_1",
	"PLA0370_2",
	
	"PLA0380_1",
	
	"PLA0390_1",
	"PLA0390_2", --NOGO ^
	
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
	"PLA0530_1", -- nogo Receives chest compressions, breathes when resuscitated
	
	-- ・Sand got into eyes
	"PLA0540_1", -- nogo Clicks his tongue, etc., after sand gets in his eyes during a sandstorm
	
	-- ・Something nearby stinks (or he got horse manure on him)
	"PLA0550_1", -- Dramatic reaction to something that stinks
	
	"PLA0560_1", -- NOGO v
	"PLA0570_1",
	"PLA0580_1",
	"PLA0590_1",
	"PLA0590_2",
	"PLA0600_1",
	"PLA0610_1",
	"PLA0610_2", -- nogo ^
	
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
	"PLH009", --nogo
	--・Calling horse (long range)
	"PLH010", --nogo
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
	-- "PLD0420_3", -- nogo
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
	--・iDroid/You're hired
	--When a soldier who wants to join Mother Base is added to the staff list
	--"PLI0000_001", -- Welcome to the unit.
	--"PLI0000_002", -- You're one of us now.
	
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
	
	--MGS1 homage
	"PLM0010_001",--(nogo/GZ)Just like old times... snak1000_1e1010 2ffaa02f.wem
	"PLM0010_002",--This must be...! (GZ) snak1000_1f1010
	"PLM0010_003",--(nogo/GZ)Yes! snak1000_1g1010 2ffaa035.wem
	"PLM0010_004",--(nogo/GZ)This brings back some memories! snak1000_1h1010 2ffaa038.wem
	-- "PLM0010_005",--(nogo/DEMO)Liquiiiiiiiiid! snak1000_1i1010
	-- "PLM0010_006",--(nogo)Is this nostalgic? snak1000_1j1010
	-- "PLM0010_007",--(nogo)Not very nostalgic. snak1000_1k1010
	"PLM0010_008",--(nogo/GZ)I can't remember. snak1000_1l1010 2ffaa044.wem
	-- "PLM0010_009",--(nogo)I don't want to remember this. snak1000_1m1010
	"PLM0020_001",--Kept you waiting, huh? (decoy) snak1000_1n1010
	-- "PLM0020_002",--(nogo)This is bad... snak1000_1o1010
	-- "PLM0020_003",--(nogo)This is Snake. Can you hear me?" snak1000_1p1010
	-- "PLM0020_004",--(nogo/DEMO)A surveillance camera...  snak1000_1p1110
	"PLM0020_005",--Kept you waiting, huh? (unsubtitled/s10020) snak1000_1n1110

	--			● Past titles
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
	"OSAKA010",--What are you waiting for? Let's do it! (etc more, no voice)
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
	
	--			Visiting Quiet (requires p31_030020.sbp)
	--p31_030020_0050 --What?
	"p31_030020_0090", --What's wrong with her?
	"p31_030020_0110", --She's okay?
	"p31_030020_0140", --She doesn't eat either?
	"p31_030020_0160", --Photosynthesis? That's the verdict from the Medical staff?
	"p31_030020_0200", --Can't you send her on a mission?
	
	--COLLISIONS
	-- ・Trick voices for calling enemies over to a decoy
	-- Used in audio decoy item (enemies are about 30 feet away)
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
	-- "", -- SNAK1100_3l1010_0_snak Go right.
	-- "", -- SNAK1100_4d1010_0_snak Go right! 
	-- ・Buddy commands 13/Normal: Go left
	-- With the player in the middle, order to flank to the left
	-- "", -- SNAK1100_3m1010_0_snak Go left.
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
	-- "atv92n7", -- 578780148 SNAK1100_4v1010_0_snak
	--・Calling a person's name/Scream: Ocelot
	--Shouting, concerned for person's welfare
	-- "c_wn0_o", -- 578780134 SNAK1100_4w1010_0_snak
	
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

this.PlayRadio={
	settings=this.SoldierToCp,
	OnActivate=function(self,setting)
		InfCore.DebugPrint"0"
		local label = self.settings[setting+1]
		if not Tpp.IsTypeString(label) then
			InfCore.DebugPrint(tostring(label))
			return
		end
		local closestSolPos
		local closestSolName
		local playerPos = TppPlayer.GetPosition()
		if not mvars.ene_soldierDefine then
			InfCore.DebugPrint"2"
			return
		end
		for cpName, cpTable in pairs( mvars.ene_soldierDefine ) do
			for index, enemyName in ipairs( cpTable ) do
				if GameObject.GetGameObjectId(enemyName)~=GameObject.NULL_ID then
					if not TppEnemy.IsNeutralized(enemyName) then
						local solPos = TppMath.Vector3toTable(GameObject.SendCommand(GameObject.GetGameObjectId(enemyName),{id="GetPosition"}))
						if closestSolName and closestSolPos then
							if TppMath.FindDistance(solPos,playerPos) < TppMath.FindDistance(closestSolPos,playerPos) then
								closestSolName = enemyName
								closestSolPos = solPos
							end
						else
							closestSolName = enemyName
							closestSolPos = solPos
						end
					end
				end
			end
		end
		InfCore.DebugPrint"3"
		GameObject.SendCommand(GameObject.GetGameObjectId(closestSolName),{id="CallRadio",label=label, stance="SquatCaution", isForce = true})
	end
}

this.PlayVoice={
	settings=this.PlayerVoiceIds,
	OnActivate=function(self,setting)
		Player.CallVoice(self.settings[setting+1])
	end
}

this.SoundEvents={
	"sfx_m_radio_sh1", --Dad was such a drag
	"sfx_m_radio_sh2", --Look behind you
	"sfx_m_radio_sh3", --As the congressional debate
	"sfx_m_radio_sh4", --Religion
	"a00uyyni", --PT startle
	"a083gqj3", --Lisa cry
	"a0043kjlw", --TGS 2014 Distant gunshot
	"a4cs5r7", --TGS 2014 mom hurt
}

this.PlaySound3D={
	settings=this.SoundEvents,
	OnActivate=function(self,setting)  
		local lastMarkerIndex=InfUserMarker.GetLastAddedUserMarkerIndex()
		if lastMarkerIndex==nil then
			InfMenu.PrintLangId"no_marker_found"
			return
		else
			local markerPostion=InfUserMarker.GetMarkerPosition(lastMarkerIndex)
			TppSoundDaemon.SetMute"CustomSoundHat"
			TppSoundDaemon.ResetMute"CustomSoundHat"
			TppSoundDaemon.PostEvent3D(self.settings[setting+1],Vector3(markerPostion:GetX(),markerPostion:GetY(),markerPostion:GetZ()),"CustomSoundHat")
		end
	end
}

this.RadioLabels={
	"f0091_rtrg0000",
	"f0091_rtrg0001",
	"f0091_rtrg0002",
	"f0091_rtrg0003",
	"f0091_rtrg0004",
	"f0091_rtrg0005",
	"f0091_rtrg0006",
	"f0091_rtrg0007",
	"f0091_rtrg0008",
	"f0091_rtrg0009",
	
	"f0090_esrg0010", --Searchlight
	"f0090_esrg0020", --Searchlight's beam
	"f0090_esrg0030", --Anti-air gun
	"f0090_esrg0040", --Four-wheel drive
	"f0090_esrg0050", --Truck
	"f0090_esrg0060", --"What are those guys talking about?"
	"f0090_esrg0070", --"What are they talking about? If you're gonna get close, do it carefully."
	"f0090_esrg0080", --Armored vehicle
	"f0090_esrg0100", --Marines (rdf doesn't want to play fifth)
	"f0090_esrg0110", -- 収容施設 Prison facility
	"f0090_esrg0120", -- 難民キャンプ refugee camp
	"f0090_esrg0130", -- 旧収容区画について About the old prison area
	"f0090_esrg0140", -- 管理棟 Administration Building
	"f0090_esrg0150", -- 運搬用ゲート（GZ)について About transportation gate (GZ)
	"f0090_esrg0160", --Armories
	"f0090_esrg0170", -- ocelot????
	"f0090_esrg0180", -- "It's a metal drum. They must use their color to tell them apart... that one being filled with gasoline."
	"f0090_esrg0190", -- 赤い扉について About the red door
	"f0090_esrg0200", -- 星条旗について About the Star-Spangled Banner
	"f0090_esrg0210", -- Surveillance camera
	"f0090_esrg0211", -- "That's a surveillance camera."
	"f0090_esrg0220", --ゲート開閉スイッチ Gate open/close switch
	
	"f0090_oprg0010", --"Use a sniper rifle when you need to take out an enemy from a distance."
	"f0090_oprg0020", --"Smoke grenades are perfect for obscuring the enemy's vision. "
	"f0090_oprg0030", --"Stun grenades emit a powerful flash and bang that will incapacitate any nearby enemies. "
	"f0090_oprg0040", --"C4 is a plastic explosive primarily made up of RDX. "
	"f0090_oprg0045", --"When you set those directional mines, be sure to remember which way they're facing."
	"f0090_oprg0050", --"Chaff grenades render electronic devices useless for a short period of time. "
	"f0090_oprg0060", --"Mission objectives clear. Time to RTB. Call in the chopper."
	"f0090_oprg0070", --"Keep in mind that time doesn't stop while you use the iDroid."
	"f0090_oprg0080", --"Your binoculars are equipped with a directional microphone. "

	"f0090_rtrg0010", --Boss, head toward the objective. ...
	"f0090_rtrg0011", --Boss, get back to the mission.
	"f0090_rtrg0020", --"Hurry up and carry the target toward the objective."
	"f0090_rtrg0030", --"Hurry up and get to the RV." "Head for the RV."
	"f0090_rtrg0040", --"Get to the chopper, ASAP!" "Get to where the chopper's touching down."
	"f0090_rtrg0050", --"If you're unsure of what to do next, use your iDroid." ...
	"f0090_rtrg0055", --"Open the "Menu" tab, then select "Mission Info."" ...
	"f0090_rtrg0060", --"I've marked the RV on your map."
	"f0090_rtrg0070", --"I'm changing the RV. Confirm it on your iDroid." ...
	"f0090_rtrg0080", --"Great, you've reached the RV." "That's it, you're at the RV."
	"f0090_rtrg0090", --"The RV's just a little further."
	"f0090_rtrg0100", --"That won't work, Boss. Hide the target in a place they're unlikely to be found." ...
	"f0090_rtrg0110", --"Damn. They're still on alert."
	"f0090_rtrg0120", --"What's wrong, Boss? Mission abort?"
	"f0090_rtrg0130", --"What's wrong, Boss? Mission abort?" "If you get on that chopper, you'll be aborting the mission. Are you sure?"
	"f0090_rtrg0140", --"OK, now use your iDroid to call the chopper for pickup."
	"f0090_rtrg0150", --"Go ahead and call the chopper." "Hurry up and carry the target toward the objective."
	"f0090_rtrg0155", --I'll ready another chopper, Boss.
	"f0090_rtrg0160", --"Keep an eye out for nearby enemies. They could try to shoot down the chopper." ...
	"f0090_rtrg0165", --"That's a negative. Can't send a chopper till you've eliminated the enemy." ...
	"f0090_rtrg0166", --"Boss, you can't call the chopper there."
	"f0090_rtrg0170", --"Roger that chopper request. It's headed your way now." "Roger. Dispatching chopper."
	"f0090_rtrg0171", --"Roger."
	"f0090_rtrg0175", --"Boss, are you sure about this?" "Snake, that area is a hot zone!"
	"f0090_rtrg0176", --"Roger that, Snake." "LZ confirmed."
	"f0090_rtrg0180", --"Put the target on the chopper."
	"f0090_rtrg0190", --"Put the target on board first." "Are you just going to leave the target there, Snake?"
	"f0090_rtrg0200", --"OK, subject is in." "Subject on board. Leave the rest to us."
	"f0090_rtrg0210", --"He's coming too? Roger that." ...
	"f0090_rtrg0220", --"They shot down the chopper!" ...
	"f0090_rtrg0225", --"Open your eyes, he's on our side!" ...
	"f0090_rtrg0280", --"You can recover by resting. Don't overdo it out there."
	"f0090_rtrg0290", --"Boss! Get outta there and find a place to recover."
	"f0090_rtrg0300", --"You're seriously injured. Find somewhere safe to rest. That'll give you a chance to apply first aid." ...
	"f0090_rtrg0310", --"Beyond there is outside the mission area." ...
	"f0090_rtrg0315", --"Continue out of the mission area to complete the mission."
	"f0090_rtrg0320", --"Great work! You destroyed an anti-air gun. That's punched a hole in their defenses."
	"f0090_rtrg0330", --"I've updated the info on your iDroid. Take a look."
	"f0090_rtrg0335", --"That's the target."
	"f0090_rtrg0340", --"Boss, that prisoner we rescued provided some intel."
	"f0090_rtrg0350", --"It's too dangerous to contact the target right now. Wait till the coast is clear."
	"f0090_rtrg0360", --"They've lightened their security. Make contact with the target."
	"f0090_rtrg0370", --"Don't make contact with the target yet -wait until the area's clear of enemies."
	"f0090_rtrg0390", --"It's the enemy..." "The guards are on edge..."
	"f0090_rtrg0400", --"Watch out. The enemy's close." "The enemy's nearby." "It's the enemy. Proceed with caution."
	"f0090_rtrg0410", --"Eyes open, Boss."
	"f0090_rtrg0420", --"They've really tightened security."
	"f0090_rtrg0430", --"Run!"
	"f0090_rtrg0440", --"You should lower your stance."
	"f0090_rtrg0450", --"Interrogate him. Find out what he knows."
	"f0090_rtrg0460", --HELI gz"I gotta pull out."/tpp"Departing."
	"f0090_rtrg0465", --"If you want to continue the mission, move away from the chopper."
	"f0090_rtrg0470", --"A prisoner! You gonna help him?"
	"f0090_rtrg0480", --"If you're not sure how to proceed, contact me by radio - I might have just the advice you need."
	"f0090_rtrg0490", --"Flawless work. You never cease to amaze, Boss." ...
	"f0090_rtrg0500", --"What's the big hurry? That's not like you. Take your time."
	"f0090_rtrg0510", --"I need you to get back to the mission."
	"f0090_rtrg0520", --"C4 is an explosive that can be placed and then detonated remotely."
	"f0090_rtrg0521", --"You've placed some C4. Get to a safe distance before detonating it."
	"f0090_rtrg0530", --"So your suppressor is worn out. That gun will be as loud as any other now. If you have to shoot, be careful."
	"f0090_rtrg0540", --"What the hell, Boss?! Why did you kill him?!"
	"f0090_rtrg0550", --Boss, looks like they've set up checkpoints. If you plan on escaping by land, you'll have to slip through somehow.
	"f0090_rtrg0560", --This is just a hunch, but... I think that's all the cassette tapes. Boss, get back to the mission.

	"f0033_gmov0010", --"Boss, what happened?! Boss!!"
	"f0033_gmov0020", --"Where are you -  Have it your way. Mission aborted." "Boss! "Why did you abandon the mission...?"
	"f0033_gmov0030", --"Dammit, the mission's a failure...!" "... Mission failed, Boss..."
	"f0033_gmov0040", --"You're really aborting the mission, huh... Head back in as soon as you're prepared." "Mission aborted..."
	"f0033_gmov0050", --"The extraction chopper's history. That was our only way of bringing you home. Mission failed."
	"f0033_gmov0060", --"The target's  dead. Mission failed."
	"f0033_gmov0070", --"What the hell were you thinking?!  Mission failed..."
	"f0033_gmov0080", --"The chopper carrying Chico went down. Mission failed."
	"f0033_gmov0090", --"Target confirmed dead. Mission failed."
	"f0033_gmov0100", --"Why'd you kill her, Boss? Mission failed."
	"f0033_gmov0110", --"The chopper carrying Paz crashed. Mission failed."
	"f0033_gmov0120", --"What the hell were you thinking?!  Mission failed... All that work for nothing."
	"f0033_gmov0130", --"Snake, the targets made it outside the mission area. The mission's a failure."
	"f0033_gmov0140", --"The target's dead. Mission failed."
	"f0033_gmov0150", --"Boss, the target's dead. Mission failed."
	"f0033_gmov0160", --"Snake! Snake!!"
	"f0033_gmov0170", --"The chopper went down. We've got no other means of extraction. Mission failed."
	"f0033_gmov0180", --"Snake, are you OK? Snake...!"
	"f0033_gmov0190", --"Snake, talk to me! Snake!! Snake!!"

	"f1000_esrg0000", -- pprg1001_481010 There a target in there? Take a closer look. (no sound?)
	"f1000_esrg0010", --・Target(before confirming target's face) hos_target_0000 s10033 _miller (Hm? )Is that the target...? Take a good look at his face. We need to ID the target. //Is that him?
	"f1000_esrg0020", --・About machine guns type_gunMount s10054 _ocelot A gun emplacement. You might wanna use it before the enemy uses it on you.
	"f1000_esrg0030", --・About machine guns (2)  _ocelot If you've got some explosives, destroying that emplacement would be easy enough...
	"f1000_esrg0040", --・About mortars type_mortar _ocelot Mortar shells travel in a curved trajectory. Meaning they hit from up above you.//Mortars require more than one person to transport, but they can do a lot of damage in a short amount of time. If you don't plan on using one yourself, it wouldn't hurt to destroy it. //Watch yourself. That can send high angle fire from quite a distance. If you get the chance, destroy it before it causes trouble.
	"f1000_esrg0050", --・About mortars (2) type_mortar mortar2nd s10054 Mortars require more than one person to transport, but they can do a lot of damage in a short amount of time. If you don't plan on using one yourself, it wouldn't hurt to destroy it. 
	"f1000_esrg0060", --・Walker Gear That's a Walker Gear. They're fast, and can operate off-road too. You do best to avoid them. type_walkergear_used
	"f1000_esrg0070", --・Walker Gear (2) That's a Walker Gear. "You could steal it for yourself, or destroy it if you've got explosives on you. type_walkergear
	"f1000_esrg0080", --・Wild animal: Common raven So this is raven territory... I heard once that some indigenous peoples in Canada and Alaska deify the common raven as a totem. type_raven
	"f1000_esrg0090", --・Supplemental for all wild animals I hope to hell you're not planning on catching and eating that. Save the survival routine for another time.
	"f1000_esrg0100", --・Wild animal: Hornbill family That's a hornbill. The protuberance above its bill is its crest. It's kind of like a rhinoceros horn. type_hornbill
	"f1000_esrg0110", --・Wild animal: Black stork type_ciconia_nigra
	"f1000_esrg0120", --・Wild animal: Jehuty (provisional) type_jehuty
	"f1000_esrg0130", --・Wild animal: Griffon vulture type_gyps_fulvus
	"f1000_esrg0140", --・Wild animal: Martial eagle type_polemaetus_bellicosus
	"f1000_esrg0150", --・Wild animal: Gerbil type_garbillinae
	"f1000_esrg0160", --・Wild animal: Long-eared hedgehog type_hamiechinus
	"f1000_esrg0170", --・Wild animal: Afghan pika type_ochotona_rufescens
	"f1000_esrg0180", --・Wild animal: Karakul sheep type_sheep
	"f1000_esrg0190", --・Wild animal: Cashmere goat type_goat
	"f1000_esrg0200", --・Wild animal: Nubian type_nubian
	"f1000_esrg0210", --・Wild animal: Boer type_bore
	"f1000_esrg0220", --・Wild animal: wild donkey type_donkey
	"f1000_esrg0230", --・Wild animal: Grant's zebra type_zebra
	"f1000_esrg0240", --・Wild animal: Okapi type_okapi
	"f1000_esrg0250", --・Wild animal: Gray wolf type_wolf
	"f1000_esrg0260", --・Wild animal: Lycaon pictus type_lycaon
	"f1000_esrg0270", --・Wild animal: Side-striped jackal type_jackal
	"f1000_esrg0280", --・Wild animal: Anubis (provisional) type_anubis
	"f1000_esrg0290", --・Wild animal: Brown bear type_ursus_arctos type_kashmiri_ursus_arctos
	"f1000_esrg0420", --・Enemy soldier: Soviet soldier (1) type_enemy_soviet "A Soviet soldier... A lot of them came from Central Asia before, but lately they've been using more and more Russians." "Simple really - there's less hesitation to pull the trigger if they're not fighting their own race." "Morbid cynicism, but it gets results. That's humanity for you."
	"f1000_esrg0430", --・Enemy soldier: Soviet soldier (2) Young men sent to a strange country to die for reasons they don't understand, all because their government decided it was right. The world is seeing another Vietnam.
	"f1000_esrg0460", --・Enemy soldier: ZRS soldier type_enemy_security That's a "security guard" with Zero Risk Security. "They like to call themselves a ""security company,"" but  their ranks are made up of former South African military." "When you look at what they're doing, I can think of a much more appropriate word for these guys - mercenaries."
	"f1000_esrg0470", --So those XOF scum live on, even after Skull Face's death. Maybe they've returned to their original chain of command, but Zero can't be in any condition to give orders... Cipher's lost its head, its sense... is it just using XOF to cling to life? // That's an XOF soldier. Previously, they were mostly made up of American Vietnam vets, but nowadays they headhunt
	"f1000_esrg0530", --・DD soldier _miller That's one of us. A Diamond Dogs soldier
	"f1000_esrg0540", --・Prompting player to extract target That's the target. Get him out of there.//That's the target. Extract him.
	"f1000_esrg0545", --・Prompting player to extract target That's the target. Get him out of there.
	"f1000_esrg0550", --・Discovering target, and prompting player to extract them _miller There's the target. No major injuries. Doubt he'll have the strength to walk, though. Go ahead and extract him. hos_s10033_0000
	"f1000_esrg0560", --・Discovering target, and prompting player to extract them _miller There's the target. No major injuries. You shouldn't have any trouble Fulton extracting him.
	"f1000_esrg0570", --・Discovering a badly wounded target "That's the target.( ... ) [p] He's badly wounded." He's still alive, but don't expect much action out of him. "What are you gonna do? [p] Can you extract him?" That's the target. He's badly wounded. He's still alive, so don't expect much action out of him. What are you gonna do? Can you extract him?
	"f1000_esrg0580", --・Discovering a badly wounded target "That's the target.( ... ) [p] He's badly wounded." // Those injuries are severe.
	"f1000_esrg0590", --・Target(before confirming target's face) (Hm? )Is that the target...?//Is that him...?
	"f1000_esrg0600", --Is that him...? Follows on from the above, when player doesn't have a good look at the person's face "Take a good look at his face. We need to ID the target."
	"f1000_esrg0610", --Intel support call for targets (after IDing face) That's one of the targets. Eliminate him.
	"f1000_esrg0620", --・Intel radio: Target's situation (before making contact) That's the target. He looks injured. hos_target_0000 s10052
	"f1000_esrg0630", --・Target (after confirming his identity) is being interrogated Boss, they'll kill him if you let this carry on! Hurry and rescue him!
	"f1000_esrg0640", --・Top-secret file An intel file showing their security layout... That might lead us to the targets. "Can you get to that file? [p] We'll analyze it here." rds_lab_intfile0000 s10093
	"f1000_esrg0650", --・Reconnaissance inside outpost (1): wooden watchtower A watchtower. You could use that to search for the target.
	"f1000_esrg0660", --・Reconnaissance inside outpost (2): high ground "It should be easier finding the target from the top of that cliff." See anywhere you can climb up?
	"f1000_esrg0670", --・Banana plantation enemy soldier He's too far away... Can't tell if he's the target from that distance. Think you can get closer?
	"f1000_esrg0680", --・Banana plantation target The target... Don't waste an opportunity to eliminate him.
	"f1000_esrg0690", --・Banana plantation target Target confirmed dead. Forget about him, Boss. We need to move on.
	"f1000_esrg0700", --・Banana plantation target The target's barely alive. He won't last long.
	"f1000_esrg0710", --・Enemy soldier other than target He's not the target.//That soldier doesn't look like the target.
	"f1000_esrg0720", --・Enemy soldier other than target Try interrogating the enemy. They may know the target's location.
	"f1000_esrg0730", --・CFA mercenaries "They're working for one of the bigger PFs, the Contract Forces of Africa, CFA for short." "These guys are all business - mercenary work is strictly about the money to them." Either way, they're no threat to us(Diamond Dogs). type_enemy_cfa
	"f1000_esrg0740", --・Rogue Coyote mercenaries They're mercenaries belonging to Rogue Coyote. "Not so much a corporation as a mixed bag of hired guns working together under a single banner. " "They cut their teeth in the British and Rhodesian SAS, the Selous Scouts, 32 Battalion..." "So they've seen plenty of action. [p] Don't take any chances with them." type_enemy_coyote
	"f1000_esrg0750", --・ I found a prisoner Boss, that prisoner.../Another prisoner. Looks like he's alive.
	"f1000_esrg0755", -- A prisoner. He might have some information.//It's a prisoner. You gonna extract him?
	"f1000_esrg0760", --・Prisoner (for intel) "A prisoner. [p] He might have some information." If you extract him, we'll see what he knows.
	"f1000_esrg0770", --"It's a prisoner. [p] You gonna extract him?" We'll find out if he knows anything. hos_s10033_0001
	"f1000_esrg0780", --・Discovered escaped prisoner "A prisoner! [p] You gonna help him?"
	"f1000_esrg0790", --"A prisoner. [p] You going to help him?" // "It's a prisoner. [p]Wonder if he knows anything..."
	"f1000_esrg0800", --Think that prisoner would be useful?
	"f1000_esrg0810", --A prisoner... That's not the target. Don't extract him just because you feel sorry for him. We can't afford to take in people we can't use.
	"f1000_esrg0820", --・About the enemy snipers KLPR3000_1l1010_0_ocelot So they've posted snipers... KLPR3000_1m1010_0_ocelot One of them sees you, he won't miss. KLPR3000_1n1010_0_ocelot Stay alert, no matter how far away you are.
	"f1000_esrg0830", --・About the enemy snipers So they've posted snipers... One of them sees you, he won't miss. Stay alert, no matter how far away you are. KLPR3000_1o1010_0_ocelot Guards everywhere, not a gap to be seen. KLPR3000_1p1010_0_ocelot The target must have figured his days are numbered. Man's got a good sense of danger.
	"f1000_esrg0840", --・Soviet soldiers "Not a civilian in sight. [p] The Soviets have taken complete control of the place."//A Soviet soldier... of the 40th Army.//"No DRA(Democratic Republic of Afghanistan) forces around. [p] The Soviets must want to keep that area under direct control." sol_slopedTown_0000 S10020
	"f1000_esrg0850", --A Soviet soldier... of the 40th Army.//"No DRA(Democratic Republic of Afghanistan) forces around. [p] The Soviets must want to keep that area under direct control." type_enemy s10020
	"f1000_esrg0860", -- ・Prompting extraction of interpreter (overhearing conversation version) Any idea what they're talking about? "If we had an interpreter here, we'd be able to translate their conversation..."
	"f1000_esrg0870", -- ・The enemy soldiers at Liquid's village "Those are UNITA troops, but their gear is from a PF known as the CFA - the Contract Forces of Africa." "So the militants hired a PF to strengthen themselves, but the PF got so big it absorbed them... How's that for irony."// "They're members of UNITA. But those locals have been hired by CFA, a South African PF." Guess they weren't happy with what UNITA was paying them. // Behind UNITA you have South Africa, and America, too. "After all, the Angolan government receives support from the East." // "The country's civil war is no different from any other East-West proxy war." Wonder if those guys realize that.
	"f1000_esrg0910", --・Flow station enemy soldiers CFA soldiers. "Those guys look different from the rest. Not UNITA... [p] Most likely Afrikaners( from South Africa)." 
	"f1000_esrg0920", --・Flow station enemy soldiers The CFA's core personnel are Afrikaners from South Africa. They're highly trained, too. Not the kind of mercs UNITA can afford these days. They must've been hired by someone with much deeper pockets.
	"f1000_esrg0930", --・About the enemy soldiers at the outpost before the human factory ???
	"f1000_esrg0940", --・Watchtower That's a watchtower.
	"f1000_esrg0950", --・Searchlight (general purpose) (1st time) That searchlight's manually operated. (2nd time) Watch that searchlight. type_searchlight
	"f1000_esrg0960", --Searchlight (night)"(First time)A searchlight... Stay out of the beam or the guard'll spot you." (2nd time)Study how the searchlight moves. "(3rd time)Given how bright it is, there's no way the guard would miss you."
	"f1000_esrg0970", --・Surveillance camera A surveillance camera... "Its feed is being monitored at their CP. Take it out, and guys would come running."
	"f1000_esrg0980", --・Surveillance camera "It's a surveillance camera. [p]Don't get spotted."
	"f1000_esrg0990", --・Anti-Air Emplacement When looking at an AA gun through binoculars: (Fifth time)An AA gun. "An AA gun. [p] If you can destroy it, that'll punch a big hole in their air defenses." type_antiAirGun
	"f1000_esrg1000", --・Red metal drums "(First time)It's a metal drum. [p] They must use their color to tell them apart... [p] that one being filled with gasoline." (Second time)If you shoot that metal drum it'll explode. "(Third time)A metal drum. [p] Careful, it'll ignite if you shoot it." (Fourth time)That's a metal drum. type_drumcan
	"f1000_esrg1010", --・Four-wheel drive (Second time)That's a military four-wheel drive. "(Third time)Looks like a four-wheel drive. Must be a lifesaver for getting around quickly." type_light_vehicle 
	"f1000_esrg1020", --・Trucks "A truck... [p] The back... [p] It's empty." "(Second time)That's a military truck. [p] Looks pretty solid." "(Third time)It's a truck. [p] Think you can pull yourself up into the cargo bed?" (Fourth time)A military truck. type_truck --_millergz
	"f1000_esrg1030", --・Armored vehicle with cannon"(First time)An armored vehicle. [p] You don't want to take on that cannon." "(Second time)Watch yourself. [p] That cannon could tear you apart." "(Fifth time)Look at that cannon. [p] It's like a bunker on wheels. [p] I'd love to have that on our side, [p] but I don't see how you could get close." "(Sixth time)If you could steal that, [p] nothing could stop you... [p] But make a wrong move [p] and it'll chew you up." type_armored_vehicle
	"f1000_esrg1040", --・Intel radio regarding tanks 01 "Without a recoilless rifle or some other explosive ordnance, taking out tanks is no easy matter." // ・Intel radio regarding tanks 02 You can also call in a Support Strike. "But they won't be easy to hit if you don't immobilize them first." type_tank
	"f1000_esrg1050", --・Intel radio regarding tanks 02 You can also call in a Support Strike. "But they won't be easy to hit if you don't immobilize them first."
	"f1000_esrg1055", -- _ocelot A Soviet tank... _miller If you could steal that, [p] nothing could stop you... [p] But make a wrong move [p] and it'll chew you up.
	"f1000_esrg1060", --・Dogs "(First time)It's a guard dog. Don't get too close. [p] You wouldn't want it to start barking." "A dog's sense of smell is better than ours, and so is their night vision. [p] Don't take any chances." "(Third time)Man's best friend since ancient times, and truly loyal. [p] They're a natural choice for use in combat." (Fourth time)That's a guard dog.
	"f1000_esrg1070", --・Dumpster explanation A dumpster... Looks big enough to hide somebody. "You could stash a downed enemy in there or hide in it yourself. Just... [p] don't stand too close to me afterward." type_trash
	"f1000_esrg1080", --"Most of that power will go to the lights. [p] It's probably not used for much before sundown." type_eleGenerator s10033 changeESPR_D
	"f1000_esrg1090", --・About the power system (daytime) "The power system. [p] Looks big enough to run the entire base."//"Destroy that power system and you'll get a real desert night. [p] Think you can get to it?" type_eleGenerator s10033 changeESPR_n
	"f1000_esrg1100", --・Subtle suggestion to the player to make use of vehicles (only if vehicle is empty) "A vehicle. [p] You always were a natural behind the wheel."
	"f1000_esrg1110", --・Hinting that destroying the communications equipment will work to the player's advantage That's communications equipment used by the outpost's CP. It must be how they keep in touch with headquarters. "If you destroy it, you might be able to cut off the CP from their HQ." //You can disrupt//If you cut the link between their outpost and HQ type_antenna
	"f1000_esrg1120", --・Gun emplacement announcement "That's a heavy machine gun. Packs far more power than any rifle." "You could either use it yourself, or destroy it... [p] Either way, best keep in mind some way to deal with it." type_gunMount
	"f1000_esrg1130", --・Mortar announcement "Watch yourself, that can send high-angle fire your way from quite a distance." If you get the chance, destroy it before it causes trouble.
	"f1000_esrg1140", --・Additional, larger antenna That's an anti-air radar. "It isn't one of the targets, but destroying it would shut down part of the enemy's air surveillance." It might make more landing zones available.
	"f1000_esrg1150", --・Intel radio: About armored vehicle (before player is aware of prisoner transfer) An armored vehicle. "You'll have a real problem if it spots you. [p] Be careful." Remember that your first priority is the target's safety. sol_s10052_guardVehicle_0000 veh_transportVehicle_0001
	"f1000_esrg1160", --・Enemy chopper parked at diamondNorth "An enemy patrol chopper? They keep a tight watch in the air, too." Boss, be careful when you call in the chopper. You don't want it in that thing's sights.
	"f1000_esrg1165", -- That's a target. Eliminate it any way you'd like.//
	"f1000_esrg1170", --・Transmitter for calling enemy chopper "Destroying that transmitter will cut off the enemy's communications." Then they can kiss their air support goodbye.
	"f1000_esrg1180", --・Discovered anti-air radar Anti-air radar... "Neutralize that and our choppers can breathe a little easier." type_searchradar
	"f1000_esrg1190", --・Armored vehicle An armored vehicle... You can't let it spot you. Either tread carefully, or neutralize it first.
	"f1000_esrg1200", --・Recommending eavesdropping (First time)What are those guys talking about? "You should try listening in on those soldiers. [p] Even casual chatter could reveal something in a place like this." "(Third time)Information gathering is fundamental to good recon. [p] Listen in to what they're saying." (Fourth time)Those guys are talking about something.
	"f1000_esrg1210", --・Recommending eavesdropping (First time)What are those guys talking about? "Those binoculars are equipped with a directional microphone. [p] You should be able to listen in even if they're that far away." "You should try listening in on those soldiers. [p] Even casual chatter could reveal something in a place like this." "(Third time)Information gathering is fundamental to good recon. [p] Listen in to what they're saying." (Fourth time)Those guys are talking about something.
	"f1000_esrg1220", --・Soldiers are talking (directional microphone not yet developed)"What are they talking about? (...) If you're gonna get close, do it carefully." "They may know something about the target. [p] Might be time for a little CTR(Close Target Reconnaissance) - [p] get close and listen in."
	"f1000_esrg1230", --・Prompt to develop directional mic "They're talking about something, but they're too far away to hear." "We really need to get a directional mic built into your binoculars." "Check your iDroid to see whether the R&D Unit can develop that."
	"f1000_esrg1240", --・Player looked at wrong person/object (different from VI) Boss, take a good look at the VI.
	"f1000_esrg1250", --・Prompting player to find correct person/object (Hm? )Is that it...? (it is)
	"f1000_esrg1260", --・Common to guard posts (small outposts) A guard post... Keep your eyes open for enemies on watch.
	"f1000_esrg1270", --・Enemy soldier guarding the target "A guard... [p] You could get around him, [p] or wait for the shifts to change."
	"f1000_esrg1280", --・Suggesting sniping Boss. You got a sniper rifle?
	"f1000_esrg1290", --・Suggesting sniping There's nothing wrong with doing the job from long range.
	"f1000_esrg1300", --・About causing a diversion "If their lookouts are getting in your way, start by causing a diversion."
	"f1000_esrg1310", --About causing a diversion "The best way to cause a diversion is to blow up an enemy vehicle or installation." "If it goes well, the guards'll go on alert and leave their posts. [p] That's your chance to slip past them."
	"f1000_esrg1320", --・Advice about which weapons are good for destroying the targets "The best weapons for destroying the targets will be explosives - things like grenades or C-4."//"With grenades, you can take them out from a distance, but you won't be able to destroy multiple targets at once."//"C-4, on the other hand, is remote operated, so you can detonate charges more or less simultaneously. [p] Only problem is, you have to approach the targets to plant them."//Choose your weapon according to the situation.
	"f1000_esrg1330", --・Prompting player to extract animals "By the way, Boss, I guess you've seen plenty of wild animals during missions." "To tell you the truth, an environmental NGO has asked us to remove wild animals from battlefields." "If you have the time, you think you could tranquilize any animals you see and Fulton extract them? [p] The NGO's willing to pay."
	"f1000_esrg1340", --・Why there are no residents around The villages around there belong to the Soviets now. "The local population probably packed up and left already."
	"f1000_esrg1350", --・Explanation of the Afghanistan situation "Sure, the Soviets originally used the Afghan government's request for help as their pretense for military intervention..." "But what we're seeing now is an invasion, plain and simple."
	"f1000_esrg1360", --・New chain reaction "The Soviets took over these villages to smoke out the guerrillas, but that's only creating more resistance." Their retaliation breeds retaliation. "Humanity's most time-honored way to mass-produce corpses."
	"f1000_esrg1370", --・Map radio multi-use: about [remnants] Lamar Khaate Palace. "Lamar khaate" means "sunrise."
	"f1000_esrg1380", --・About [remnants] "The place was originally built by progressive royals as a separate palace away from Kabul." "With its Western architecture, it was their declaration of ""a new dawn,"" [p] but I'd say their prosperity didn't last."
	"f1000_esrg1390", --・About [remnants] "After all those years, the ruins end up in the hands of (self-deprecating scoff) [p] Soviet invaders."
	"f1000_esrg1400", --・Strategies for [remnants] "In any area with multiple levels, higher ground offers the advantage."//"Acquiring a target is easier when you're aiming down, and aiming up can lead to dead angles."//Those walls are in pretty bad shape. Careful the enemy doesn't spot you through any holes.//"That place has a lot of rubble, and holes in the ground, too." Watch your step.
	"f1000_esrg1410", --・Strategies for [tent] A frontal assault is just asking for trouble. You'd be safer trying to find a way around...
	"f1000_esrg1420", --Security tends to be more lax at night. Not that it makes your job a picnic... "But still, use the darkness to your advantage, [p] and equip your night vision goggles."
	"f1000_esrg1430", --Wakh Sind is a major outpost that links this region together. It's huge, and its position in the mountains makes it hard to attack. Don't take this one lightly.
	"f1000_esrg1440", --・Map radio for reaching Sakhra Ee Village 02 "The houses in the village are packed together, built wherever the steep incline would support them." "Plenty of roofs and eaves for cover... the enemy'll never see you coming." "But if they do, you could find yourself cornered if you're not careful." Watch your back.
	"f1000_esrg1450", --・Where the village's name comes from "Apparently the village's name, Qarya Sakhra Ee, means ""cliff village"" in the Dari dialect." "It's one of the country's official languages, mostly spoken by the Tajiks and Hazara."
	"f1000_esrg1460", --・About local races "Some say that village was originally built by Alexander the Great's army." "Supposedly the residents were of European ancestry - they had blond hair and blue eyes - [p] but they're all gone now..."
	"f1000_esrg1470", --・About watchtowers with canopies "An observation post. That canopy is meant to camouflage it."//"Another observation post. [p] No guard in it?"//"Lot of observation posts around. [p]They're not taking any chances with security."//"That canopy is meant to camouflage it. [p] Take a good look to make sure it's empty." rds_enemyBase_0000 S10033
	"f1000_esrg1480", --・About the prefab cabin "Looks like the guardhouse... [p] Keeping watches in shifts means half the force is always off duty." ・Daytime (if it is deserted) "It's deserted? [p] Their men are stretched thinner than I thought." rds_enemyBase_0003 S10033 changeESPR_D
	"f1000_esrg1490", --・About the prefab cabin "Looks like the guardhouse... [p] Keeping watches in shifts means half the force is always off duty." ・Nighttime (if there are people inside & lights on) "Probably full of off-duty soldiers. [p] Don't go throwing rocks at that hornet's nest." //Best to have separate lines if the situation is different depending on night or day rds_enemyBase_0003 S10033 changeESPR_n
	"f1000_esrg1500",--・About the barn That's a shed where they hang their crops to dry. It's a sturdy building - should be able to take your weight.
	"f1000_esrg1510", --???
	"f1000_esrg1520", --Afghanistan is known for its grapes... But the harvest is a long way off yet. (As long as the war continues.)
	"f1000_esrg1530", --・Command post "A parabolic antenna. [p] The Soviets must have added that themselves. [p] Meaning there's communications equipment inside?"//"A parabolic antenna... [p] There could be intel files of some kind in there." erl_village_IntelHouse S10020
	"f1000_esrg1540", --・Irrigation channel "An irrigation ditch. Won't be long before the Soviets fill it in. [p] They've stepped up their scorched earth operation." erl_village_canal S10020
	"f1000_esrg1550", --・Soviet flag "It's the Soviet flag. [p] The hammer and sickle - the workers and the peasants. [p] Just a hollow symbol in a place like this. (war-torn Afghanistan)" erl_flag
	"f1000_esrg1560", --・Main road "That's a focal point of the enemy's defenses. [p] I'd avoid the direct approach if I were you." erl_Center
	"f1000_esrg1570", --・About the objective area Da Shago Kallai. It''s in Soviet hands now. "You''ll have to go into the village, or take out the target from a distance."
	"f1000_esrg1580", -- ・About facilities at the power station ???
	"f1000_esrg1590", --・Tent containing top-secret file There's a possibility this will be played between finding out about the top-secret file and actually picking it up. "Must be a temporary HQ for the security detail. [p] They're probably giving the orders from there..." // There could be an intel file inside. 
	"f1000_esrg1600", --・Tent containing top-secret file There's a possibility this will be played between finding out about the top-secret file and actually picking it up. "Must be a temporary HQ for the security detail. [p] They're probably giving the orders from there..." // There could be an intel file inside. // On the basis that the soldiers are outside, so there is no-one inside: "There may be more of them in there. [p] Watch it." rds_lab_tent0000 S10093
	"f1000_esrg1610", --・Diamond mine entrance gate The gate's closed. What about the side entrance?
	"f1000_esrg1620", --・Broken fence at edge of outpost That's the mine's perimeter fence.//"Seen better days. [p] Think you can get through?"
	"f1000_esrg1630", --・Diamond mine opening Security's tight, and it's a narrow space to boot. How about going via the basin below?
	"f1000_esrg1640", --・Diamond mine infiltration route: mud lake Crawling through the mud provides great camouflage. Particularly when you're close to the enemy.
	"f1000_esrg1650", --・Diamond mine infiltration route: mud lake (second time) Looks muddy. Crawling through there would provide great cover.
	"f1000_esrg1660", --・Cave entrance (second time) You should be able to pick the lock on that door.
	"f1000_esrg1670", --・Empty house A hut... Good place to stay out of sight. bananaSmallHouse01
	"f1000_esrg1680", --・Empty house It's a small hut... Perfect for someone to hide in. bananaSmallHouse02
	"f1000_esrg1690", --・Building with a thatched roof The inside is pretty exposed. Doesn't seem like a good hiding place... bananaSmallHouse03
	"f1000_esrg1700", --・Rest tent Looks like a rest tent. There isn't a clear view inside. Perfect place to hide. bananaTent01
	"f1000_esrg1710", --・Rest tent That tent must be for resting between shifts. "Not much room to move. [p] Be careful if you search it." bananaTent02
	"f1000_esrg1720", --・Generator (banana plantation) Looks like the power system. Killing the lights will reduce the enemy's visibility. But the same goes for you. You'll have a tougher time finding the target as well. lightPowerDown
	"f1000_esrg1730", --・Banana plantation "Your visibility won''t be as good in the trees, but they''ll provide cover." Use the terrain to your advantage. bananaFarm02
	"f1000_esrg1740", --・Area in front of banana plantation: high ground to the south There's some high ground there. Just what you need for recon. It'll give you a view of the entire base. bananaHill
	"f1000_esrg1750", --・Banana plantation infiltration route You'll have a clear view from the side of the road. "Good place to do your search, but also a good place to get spotted." bananaRordSide01
	"f1000_esrg1760", --・Banana plantation infiltration route "A place with that kind of visibility  will test your powers of observation." "You should mark as many enemies as you can to help reduce the chances of being seen." bananaRordSide02
	"f1000_esrg1770", --・Banana plantation infiltration route A banana field... All that cover means less risk of being spotted. Visibility won't be good, so keep your ears open too. bananaFarm01
	"f1000_esrg1780", --・Banana plantation infiltration route The trees and underbrush would provide good cover. "Not the best places to look for the target, but they'll help you close in on the enemy." Useful situation for CQC. bananaBush
	"f1000_esrg1790", --・About the boat
	"f1000_esrg1800", --・Use the kayak laying around to your advantage
	"f1000_esrg1810", --・Background about the village "Anyone who could tell you the name of that village is long gone." Only a dozen or so houses in the place. "Crops are nothing special... [p] taro and plantain." rds_hillNorthTownBackStory_0000
	"f1000_esrg1820", --・Background about the village 2 "The worsening conflict robbed the villagers of the peace they once had." "They evacuated rather than risk living on a battlefield, [p] and the place became a ghost town." "Nowadays, it's occupied on and off as an outpost by one or another of the factions." rds_hillNorthTownBackStory_0001
	"f1000_esrg1830", --・Savannah large rock "That rock is known as the ""Cradle of Spirits."" [p] What a shape... [p] Incredible what dust and wind can do over a long enough time."//"The ""Cradle of Spirits..."" [p] According to local beliefs, [p] spirits born here are what give life to the surrounding forests and grasslands." rds_EspRadioLocator_rock
	"f1000_esrg1840", --・About the barricades "Steel barricades on the hillside? [p] Talk about an ""iron curtain..."""//"Barricades. [p] There must be some kind of building on the far side." rds_enemyBase_0001 S10033
	"f1000_esrg1850", --・About the gate "The gate's wide open. [p] Not exactly the stealthiest approach..."//"They won't take kindly to visitors on their doorstep. [p] Look around for another way in." rds_enemyBase_0002 S10033
	"f1000_esrg1860", --・About the half-constructed building "That building's only half-finished, but... [p] looks like someone's in there." "You see a lot of that round here - put up a building, then just keep adding more as you need it. " rds_enemyBase_0004
	"f1000_esrg1870", --A prisoner... // That's not the target. // No major injuries. // You shouldn't have any trouble Fulton extracting him. // -
	"f1000_esrg1880", --"Another prisoner? [p] Looks like he's alive."//"A prisoner! [p] You gonna help him?"//Think that prisoner would be useful? GetFakeTargetName
	"f1000_esrg1890", --There's the target. Eliminate it.
	"f1000_esrg1900", --That's the target. Eliminate him, however you want.
	"f1000_esrg1910", --・About the ruins "Those may be ruins, but they can still function perfectly well as an outpost." Watch out for possible guards high up. rds_remnants_0000 S10045
	"f1000_esrg1920", --・About the ruins [2] Climbing up there should give you a good view of the area. rds_remnants_0001 S10045
	"f1000_esrg1930", --・Outpost information The front is heavily guarded. "Try to find an area where security is lighter, even if it means a detour." intelRadioListOnRemnants rds_remnants_0000
	"f1000_esrg1940", --That looks like the target. hos_vip_0000 S10045
	"f1000_esrg1950", --・Enemy soldier: puppet (zombie) soldier Looks like the Skulls have done something to him... What's making him move like that?
	"f1000_esrg1960", --・Quiet (searching for the player) There she is... The enemy sniper. Shoot on sight, Boss.
	"f1000_esrg1970", --・Two-story house An abandoned house... Plenty of cover. Two floors too. Perfect for attacking and defending.
	"f1000_esrg1980", --・Tower A tower. High positions with good views are ideal for sniping. But the enemy has a clear shot at you too, plus there's nowhere to run.
	"f1000_esrg1990", --・Cave A cave... No escape route, and a narrow line of sight. Not somewhere I'd normally recommend as a sniping position.
	"f1000_esrg2000", --・Forest That forest could provide plenty of cover from the enemy. But you'd have trees blocking YOUR line of sight too...
	"f1000_esrg2010", --・Pillar that looks like it could collapse Some old ruins. Looks like they could collapse any minute.
	"f1000_esrg2020", --・Large gate resembling [Ruins] Ooh, that's one big gate. You'd have a view of the entire area from up there. But you'd be pretty exposed too.
	"f1000_esrg2030", --・If player tries to make an intel support call while listening to enemy soldiers' standing conversation Sssh... listen!
	"f1000_esrg2040", --・Machine gun - pattern 1 That's a gun emplacement. "It's plenty destructive, and it'll work well against vehicles too." But using it will make you a target. Be careful.
	"f1000_esrg2050", --・Mortar - pattern 1 That's a mortar. It's difficult to hit a target, but it'll do major damage. Wait for your target to stop before launching.
	"f1000_esrg2060", --・Unique prisoner What's a prisoner doing there...? You gonna to save him, Boss?
	"f1000_esrg2070", --・Sniper It's a sniper. "It goes without saying that he'll try to spot you from long range and pick you off." Stay out of his field of vision. Or, you could take him out first.
	"f1000_esrg2080", --・Sniper female version It's a sniper. It goes without saying that she'll try to &#xD;&#xA;spot you from long range and pick you off. Stay out of her field of vision. Or, you could take her out first.
	"f1000_esrg2090", -- ・Control tower [1] Looks like that building is the control tower. It'll be the CFA's most important structure there.
	"f1000_esrg2100", -- ・Control tower [2] "That control tower is the perfect place to do recon or position a sniper." If you're going to approach it, use maximum caution.
	"f1000_esrg2110", -- ・Runway That runway has seen better days, but it still looks usable. "Of course, the CFA fly choppers more than anything, so they probably don't even use it."
	"f1000_esrg2120", -- ・Decoy A decoy. You're too smart for those trick... right?
	"f1000_esrg2130", --・Land mine "The enemy must have planted that mine. Well spotted, Boss."
	"f1000_esrg2140", --・Infrared sensors Infrared sensors? Watch you don't trip them. type_redSensor
	"f1000_esrg2150", --・Surveillance camera A surveillance camera... "Its feed is being monitored at their CP. Take it out, and guys would come running."//"It's a surveillance camera. [p] Don't get spotted." type_camera
	"f1000_esrg2160", --・Gun camera A gun camera. If it spots you, it'll give you a lead hello. type_gun_camera
	"f1000_esrg2170", --・UAV An enemy UAV... You gonna to shoot it down before it sees you? type_uav
	"f1000_esrg2180", --・Nuclear weapons container That container holds a nuclear weapon. "With that kind of deterrent, we could prevent other PFs from coming after us." "But you know better than anyone how dangerous they can be."
	"f1000_esrg2190", --・Communications equipment "If we cut the link between their CP and HQ, we disrupt outpost communications and reinforcements." "But soldiers will still be able to contact the CP using portable radios." Bear that in mind.
	"f1000_esrg2200", --・Power system "Either destroy that or turn it off to shut off all the lights and surveillance cameras in the outpost." But of course, the enemy will realize something's up. If you're gonna do it, be quick. type_eleGenerator type_switchboard ELECTRICITY
	"f1000_esrg2210", --・Toilet A portable toilet. "If you're going to hide inside, watch the enemy doesn't decide to use it." Same goes for hiding downed enemies in it. type_toilet
	"f1000_esrg2290", --・Raw diamond That's a rough diamond. As a tangible asset, it'll increase our GMP.
	"f1000_esrg2300", --・Enemy soldier: CFA "Though the CFA are a South African organization, they expanded into this region after they were hired by UNITA." "But nowadays it's the other way around; more and more UNITA soldiers are being hired by the CFA."
	"f1000_esrg2310", --・Enemy soldier: Rogue Coyote Rogue Coyote lacks any kind of company-wide doctrine. "It's made up of multiple commanders, each operating a unit at his own discretion." Rogue Coyote lack any kind of company-wide doctrine. It's made up of multiple commanders, each operating a unit at his own discretion.
	"f1000_esrg2320", --・Enemy soldier: ZRS [2] "The number of self-proclaimed ""security firms"" like ZRS is only going to increase." After all, it sounds better than "cutthroat mercenaries."
	"f1000_esrg2330", --・Enemy soldier: puppet (zombie) soldier [2] He has been made into a puppet by the Skulls... But only temporarily. Once the Skulls leave, the parasites should follow.
	"f1000_esrg2340", --・Enemy soldier: wandering puppet (stray zombie) soldier That soldier has been turned into a puppet by the Skulls... But I don't see them anywhere.
	"f1000_esrg2350", --・Enemy soldier: wandering puppet (stray zombie) soldier [2] "The parasites have an affinity for particular constitutions." Perhaps that is why they did not leave when the Skulls did.
	"f1000_esrg2360", --・Enemy soldiers' gear Their gear is different from before. Maybe they're trying to adapt to your tactics.
	"f1000_esrg2370", --・Target is about to leave the area Eliminate the target before he escapes.
	"f1000_esrg2380", --・About the ruins "Those may be ruins, but they can still function perfectly well as an outpost." Watch out for possible guards high up.
	"f1000_esrg2390", --・About the ruins [2] Climbing up there should give you a good view of the area.
	"f1000_esrg2400", --・Outpost information The front is heavily guarded. "Try to find an area where security is lighter, even if it means a detour.
	"f1000_esrg2410", --・Intel on XOF soldier (plot supplement) No doubt about it. XOF... Cipher's covert strike force. Now they're taking orders from Skull Face.//・Enemy soldier: XOF [2] That's an XOF soldier. "Previously, XOF was made up mostly of American Vietnam vets, but these days they headhunt from special forces units all over the world."//・Enemy soldier: XOF soldier That's a member of XOF... Cipher's covert strike force. type_enemy_xof
	"f1000_esrg2420", --・Intel on XOF soldier (game) The soldiers there are wearing helmets. Normal rounds won't penetrate them.
	"f1000_esrg2430", --・Intel on [citadelSouth] gate (during free play) Up ahead is the headquarters for the Soviets' Afghan invasion force. Breaking into it would be like a declaration of war. Stay away... for now.
	"f1000_esrg2440", --・Additional, larger antenna That's an anti-air radar. "It isn't one of the targets, but destroying it would shut down part of the enemy's air surveillance." It might make more landing zones available.//・Discovered anti-air radar Anti-air radar... "Neutralize that and our choppers can breathe a little easier."
	"f1000_esrg2450", --・Theft alarm device An alarm trigger...?! Boss, get away from that thing! type_burglar_alarm
	"f1000_esrg2460", --・ Intelligence of MB shower Showers... That's luxury stuff for the rank and file. type_shower
	--●Map radio
	"f1000_mirg0010", --・Target armored vehicle in s10054 A Soviet armored vehicle. Highly mobile, and it can pack a punch too. Those are our targets. Eliminate as many of them as you can. s10054 photo
	"f1000_mirg0020", --A Soviet tank... "(Sixth time)If you could steal that, [p] nothing could stop you... [p] But make a wrong move [p] and it'll chew you up." s10044_radio
	"f1000_mprg0010", -- ・Interpreter location (Pashto) "There are reports of a Pashto/English interpreter operating in that area." If you extract him, he could be plenty useful for us.
	"f1000_mprg0020", -- ・Interpreter location (Afrikaans) "We've heard there's an Afrikaans/English interpreter operating somewhere in that area." If you extract him, he could be plenty useful for us.
	"f1000_mprg0030", -- ・Interpreter location (Kikongo) "There should be a Kikongo/English interpreter somewhere in that area." If you extract him, he could be plenty useful for us.
	"f1000_mprg0040", -- ・Prompting extraction of interpreter If you extract him, he could be plenty useful for us.
	"f1000_mprg0050", --・Introducing Soviet soldier who can interpret "We've found out there's an English-speaking soldier somewhere in the region. [p] He's a language specialist." "His role is to translate information related to the West into Russian." "If we can get him to join us, we'll have the upper hand in information warfare." Find this language specialist and extract him.
	"f1000_mprg0060", --・iDroid cursor: target is somewhere in that area That's the target's predicted field of movement. It's up to you to find him. s10081
	"f1000_mprg0065", --That's the target's predicted field of movement. s10045 default_area_vip
	"f1000_mprg0070", --That's the target's predicted field of movement. The target should be somewhere in that area. s10041 marker_enemyBaseVip
	"f1000_mprg0075", --That's the target's predicted field of movement. Boss. Look for the target. s10041 s10121 10121_marker_Leader mapRadioName marker_fieldVip
	"f1000_mprg0080", --The target is somewhere in that area. Find him. s10041 marker_villageVip
	"f1000_mprg0090", --・iDroid cursor: location where target is The target is there. What's your approach gonna be? s10045 ON_AREA_VIp
	"f1000_mprg0095", --・iDroid cursor: location where target is The target is there. s10043 marker_info_mission_targetArea s10093 add_s10093_Container_A/B
	"f1000_mprg0100", --・iDroid cursor: that's the target Also used when player does not know that the target is injured There's the target. s10044 default_area_clifftown_VIP/default_area_clifftown_convoy/2 s10081 hos_spy s10091 target01_identify/target02_identifY
	"f1000_mprg0110", --・Map radio: vague target location (1 intel gained) That's the target's predicted field of movement. We need more specific intel... s10052 AREA_TENT_LV1
	"f1000_mprg0120", --・Map radio: vague target location (2 intel gained) That's the target's predicted field of movement. We could nail down a location if we had another lead. s10052 AREA_TENT_LV2
	"f1000_mprg0130", -- ・Map radio: vague target location (3 intel gained) We have a fix on the target's location. Head over there and extract him.
	"f1000_mprg0140", --・Introducing destruction target There's the target. "Destroy that, and we bring down the enemy's communications." s10043 on_target_s10043_antn001/2/3/4
	"f1000_mprg0150", --・Mission objective area (even-numbered responses) Da Ghwandai Khar means "sloped town." s10020_radio
	"f1000_mprg0160", --・That is the target That's the target. Take him out. s10036 photoRadioName
	"f1000_mprg0170", --・Player moves map cursor over predicted target location That's the target's predicted location. They should be somewhere in that area. s10085 Area_hosTarget_flee
	"f1000_mprg0180", --・Recon point High ground. Looks perfect for reconning the village. s10200 10200_marker_viewpoint
	"f1000_mprg0190", -- The target should be somewhere in that area.//You're gonna need more information to pinpoint a location... s10033 marker_area_Target
	"f1000_mprg0200", --s10041_radio ???
	"f1000_mprg0210", --s10041_radio ???
	"f1000_mprg0220", --・Enemy vehicle rough location - version 1 "The Intel Team has confirmed the presence of an enemy combat vehicle in this area." We don't know where exactly, so watch out. s10054 Marker_Target_01_vague
	"f1000_mprg0230", --・Enemy vehicle rough location - version 2 An enemy combat vehicle has been identified around here. Try to find it. s10054 Marker_Target_02_vague
	"f1000_mprg0235", --A Soviet tank... "(Sixth time)If you could steal that, [p] nothing could stop you... [p] But make a wrong move [p] and it'll chew you up." s10044_radio
	"f1000_mprg0240", --・Enemy vehicle (on the move) - version 1 If possible, translate without specifying it as a vehicle. That's the target's predicted route. "You could either move ahead and cut it off, or attack it from behind..." s10054 marker_target_forecast_path
	"f1000_mprg0250", --・Enemy vehicle (on the move) - version 2 If possible, translate without specifying it as a vehicle. That's the target's predicted route... Eliminate the target before it leaves the mission area. s10054 marker_target_forecast_path
	"f1000_mprg0260", --・Targets (plural) predicted route That's the predicted route the targets will take. Where to ambush them is up to you. s10041 route_vip_enemyBase_arrival
	"f1000_mprg0270", -- ・Target rendezvous point "After assembling, the targets will then advance on another outpost." "You could wait and take them all out at once, but it's a risky proposition."
	--●Outgoing calls
	"f1000_oprg0015", --・After marking targets, look at the map to plan your infiltration route "Take a look at the map on your iDroid and use the positions of marked enemies to help you plan an infiltration route."
	"f1000_oprg0025", --If you don't want the enemy to spot you, stay as low as possible. Sticking to walls is also a good idea.
	"f1000_oprg0035", --・Hide behind cover (during combat) "You need to take cover during a firefight! You're a sitting duck otherwise."
	"f1000_oprg0045", --・Hide behind cover (after getting a game over) "When the bullets start flying, get behind cover and make sure no one has eyes on you." You only make yourself an easy target by standing around.
	"f1000_oprg0055", --Sticking to cover lets you get a bead on the enemy from a safe position. Know where you're gonna shoot before you stick your head out
	"f1000_oprg0065", --Sometimes it's best to fall back. The enemy won't want to leave the base. It's too risky. I doubt they'd chase you very far.
	"f1000_oprg0075", --・Hide and wait for the enemy to leave "One way to shake the enemy is find a place to hide and wait for them to pass." Of course, it's all for nothing if you let them spot you.
	"f1000_oprg0085", --・Keep effective range in mind when shooting When targeting an enemy from a distance, keep the effective range of your weapon in mind. If the weapon's reticle is white, that means you're outside of his effective range. If you decide to fire anyway, take into account how gravity will make the bullet drop. Until you get a feel for that, you might want to approach the enemy until the reticle turns red, and then fire.
	"f1000_oprg0095", --・Recommending retreat Don't push yourself. Fall back to a safe position.
	"f1000_oprg0105", --・Use D-Dog (if DD hasn't joined MB yet, or is still a puppy) If we had a good military dog, we'd have an easier time locating people...
	"f1000_oprg0115", --・Use D-Dog (when DD can be deployed) Why don't you get DD out there? Put his nose to use. He'll alert you to anyone nearby.
	"f1000_oprg0125", --Your binoculars are equipped with a directional microphone. You should be able to listen in on whatever they're pointed at.
	"f1000_oprg0135", --Leave the hot zone and find someplace safe.
	"f1000_oprg0145", --I've sent VIs of the targets to your iDroid. Take a good look.
	"f1000_oprg0150", --D-Horse can get you places fast, and knows how to cover rough terrain.
	"f1000_oprg0160", --Like your horse, you can give commands to D-Dog as well. He'll normally follow you around, but you can also make him wait somewhere, or lure an enemy by barking at him. Or you can sic him on the enemy to slow them down. Develop more gear just for him and I'm sure he'll be capable of even more damage.
	"f1000_oprg0170", --Being a scout sniper, there are two tasks you can give Quiet. The first, to infiltrate an outpost ahead of you and scout out the enemy's positions. The second, is to send her to a sniping position and have her cover your infiltration. The kind of sniper support she'll provide will depend on the weapon you give her. Of course, this is all assuming she's willing to follow orders.
	"f1000_oprg0180", --Mission objectives clear. Time to RTB. Call in the chopper.
	"f1000_oprg0190", --Call the chopper from your iDroid. Choose whichever LZ you think is best. You'll have to carry the target there.
	"f1000_oprg0200", --You'll find the targets there. Leave no stone unturned. The target has to be somewhere.
	"f1000_oprg0210", --Check the target's VI so you'll recognize his face. I've marked the target there.
	"f1000_oprg0220", --I've marked the target for you. Extract him.
	"f1000_oprg0230", --Our contract is to eliminate the target. How you do that is up to you.
	"f1000_oprg0240", --Your objective is to eliminate the target. Doesn't matter how.
	"f1000_oprg0250", --Put the target on the chopper.
	"f1000_oprg0260", --Extract the target. I'm counting on you.
	"f1000_oprg0270", --We need more detailed intel on the target's whereabouts. Why don't you see what the enemy has to say? Interrogate them.
	"f1000_oprg0280", --The target should be somewhere in that outpost. Start by gathering intel. Why don't you interrogate the enemy?
	"f1000_oprg0290", --Can you tell where the target is? You could look for more intel, or just search the area. Your call.
	"f1000_oprg0300", --Why not interrogate the enemy? We might learn where the target is.
	"f1000_oprg0310", --About the target's location... You see any intel files that might help narrow it down?
	"f1000_oprg0320", --Have you figured out where the target is? If you extract a prisoner, we might get the information from them.
	"f1000_oprg0330", --Locate and extract the target. Check your iDroid's map for the location.
	"f1000_oprg0340", --There might be clues to the target's location in that outpost. Take a look around.
	"f1000_oprg0350", --Got all the information you need? Interrogating the enemy might provide some useful intel.
	"f1000_oprg0360", --First you have to identify the targets. Recon the site with your binoculars. Once you know where the targets are, take them out to take their network out of action. How you do that is up to you.
	"f1000_oprg0370", --Destroy the targets. Any method will do.
	"f1000_oprg0380", --One of the other prisoners might know where they're holding the target.
	"f1000_oprg0390", --The security forces must know something about the targets. Why not try getting them to talk?
	"f1000_oprg0400", --Try interrogating enemy soldiers. If they know the targets' locations, make 'em spill it.
	"f1000_oprg0410", --You'd have an easier time spotting the target from higher up... Try searching with your binoculars.
	"f1000_oprg0420", --The target should be at that outpost. Check the VI on your iDroid.
	"f1000_oprg0430", --Eliminate the target. Just be careful not to be spotted by other soldiers.
	"f1000_oprg0440", --The enemy's spotted our chopper. They're converging on the RV. Hurry
	"f1000_oprg0450", --Now that you've got a fix on the prisoner, go ahead and extract him.
	"f1000_oprg0460", --Use a sniper rifle when you need to take out an enemy from a distance. Its scope will help you aim with precision and you can change the zoom for a closer look.
	"f1000_oprg0470", --Smoke grenades are perfect for obscuring the enemy's vision. Just don't forget the smoke'll blind you as well. It's not gas, so don't expect to kill anything with it either.
	"f1000_oprg0480", --Stun grenades emit a powerful flash and bang that will incapacitate any nearby enemies. Make sure you don't look at it yourself.
	"f1000_oprg0490", --C4 is a plastic explosive primarily made up of RDX. Only detonate it if you're a safe distance away.
	"f1000_oprg0500", --When you set those directional mines, make sure to remember which way they're facing.
	"f1000_oprg0510", --Chaff grenades render electronic devices useless for a short period of time. You can use them to jam enemy transmissions, but you'll knock out your own iDroid at the same time. Be careful.
	"f1000_oprg0520", --Night vision goggles illuminate the area in front of you in near infrared, and display any nearby heat sources. They'll reveal a lot you couldn't see with the naked eye.
	"f1000_oprg0530", --Keep in mind that time doesn't stop when you use the iDroid. You can even move around while using it, but pay attention to your surroundings.
	"f1000_oprg0540", --If you ready your weapon while crawling, you can move horizontally left or right. If you do that holding the Dash button, you'll move faster.
	"f1000_oprg0550", --Your binoculars are equipped with a directional microphone. You should be able to listen in on whatever they're pointed at.
	"f1000_oprg0560", --Take a close look at the VI. The target should be somewhere in that area.
	"f1000_oprg0570", --Check the VI to see where the target is.
	"f1000_oprg0580", --Find the target.
	"f1000_oprg0590", --You're gonna need more information to pinpoint a location...
	"f1000_oprg0600", --We now know the target's location. Check it on the map.
	"f1000_oprg0610", --Your objective is to extract the target. Check the target's location on your iDroid.
	"f1000_oprg0620", --You know where you're headed, Boss? If you place a marker on the map, you can keep track of where you you want to go even if the map's closed.
	"f1000_oprg0630", --Check the location on your iDroid.
	"f1000_oprg0640", -- COMR4000_1w1010_0_ocelot One way to shake the enemy is to find a place to hide and wait for them to pass. COMR4000_1w1010_0_ocelot Of course, it's all for nothing if you let them spot you. COMR4000_1x1010_0_ocelot
	"f1000_oprg0650", --The guards have to change shifts at some point. No matter how tight the enemy's defenses are, gaps will appear during shift changes.
	"f1000_oprg0660", --When targeting an enemy from a distance, keep the effective range of your weapon in mind. If the weapon's reticle is white, that means you're outside of his effective range. If you decide to fire anyway, take into account how gravity will make the bullet drop. Until you get a feel for that, you might want to approach the enemy until the reticle turns red, and then fire.
	"f1000_oprg0690", --You can give the order to develop new weapons and items from your iDroid. There's no substitute for having the right equipment.
	"f1000_oprg0700", --Reconnaissance is best conducted from high vantage points. I've marked a good spot on your iDroid. Take a look at your iDroid.
	"f1000_oprg0710", --Boss. Intelligence work is all about observing and gathering information. Start by using your binoculars to get a grasp of your surroundings.
	"f1000_oprg0720", --If you're planning to infiltrate that outpost, start by marking as many enemies as you can. Once you're inside, they'll have eyes everywhere. You can't allow yourself any blind spots.
	"f1000_oprg0730", --Enemies will be looking and listening for hostiles, but the weather and time of day will affect how easily they identify you. Choose a situation that'll work for your advantage.
	"f1000_oprg0740", --Sandstorms will reduce your visibility, but the same goes for the enemy. How you take advantage of that situation is up to you.
	"f1000_oprg0750", --Don't forget about night vision goggles. They'll give you ample visibility, no matter how dark it gets.
	"f1000_oprg0760", --Don't forget about night vision goggles. They'll give you ample visibility, no matter how dark it gets. If you want to develop them, give the order from your iDroid.
	"f1000_oprg0770", --Having trouble seeing in the dark? If you want to wait till dawn, you could always pass the time with a smoke.
	"f1000_oprg0780", --Boss, it seems that guy doesn't understand English.
	"f1000_oprg0790", --Afrikaans is the lingua franca for mercs in that area. If you're going to get any information from interrogations, you'll need an interpreter.
	"f1000_oprg0800", --If you place someone with the Interpreter skill in the Support Unit, that'll enable us to do simultaneous interpretation.
	"f1000_oprg0810", --If you want to interrogate the enemy, you'll need to find someone with the Interpreter skill first.
	"f1000_oprg0820", --If you neutralize an enemy without killing him, you can then Fulton extract him. Once we've extracted a soldier, we should be able to convince him to join us. To do a Fulton extraction, first approach the neutralized individual.
	"f1000_oprg0830", --Attach the Fulton recovery device to him. The chopper will then pick them up.
	"f1000_oprg0840", --Ahh... it looks like that fall killed him.
	"f1000_oprg0850", --If he's on the brink of death, it's hard to say whether he'll survive a Fulton extraction.
	"f1000_oprg0860", --A Fulton extraction's success rate depends on various factors like the individual's health and the weather. If you want to extract someone who's on the verge of death, you'd better use the chopper. But if you want to carry them, put them to sleep first. You won't get far if you have to fight them every step.
	"f1000_oprg0870", --That soldier you extracted... He was dead on arrival. What a waste...
	"f1000_oprg0880", --Fulton extraction puts a huge strain on the body - too much for a child. To extract kids, you'll have to carry them to the chopper.
	"f1000_oprg0890", --We can't intercept enemy comms if they're too far away. On the other hand, being out of radio range means you're relatively safe.
	"f1000_oprg0900", --The principle of infiltration is hiding your entire presence. That includes not making any unnecessary noise. When you want to move quietly, move slowly or crawl.
	"f1000_oprg0910", --Sight. Sound. Keep all of your enemies' senses in mind. When you're near an enemy, stay low and move slowly. If you stand up and move around, you'll make it easier for them to spot you.
	"f1000_oprg0920", --There's more than one way to eliminate the target. Pick him off from a distance, sneak up on him with your knife... or, you could find a way to avoid killing him altogether. It's your choice, Boss. Do as you see fit.
	"f1000_oprg0930", --A perfect sniper's nest should be a high vantage point with good visibility, and preferably dark such as inside building. That way, there's less chance the enemy will spot you.
	"f1000_oprg0940", --When you're shooting from long range, remember it'll take a moment for the bullet to reach the target. Wait for the target to stand still or move parallel to your line of sight - that's your chance.
	"f1000_oprg0950", --・About the jungle before the human factory (telling the player that the mist covering this area lowers visibility)"That area's covered in mist all year round. It'll provide good cover for you, [p] but also make it difficult to see the enemy coming. Be careful, Boss." // "The terrain and plant life can work to your advantage. Use them to manage your position relative to the enemy."//"Never make a sound if you can avoid it. With the low visibility in the jungle, sound is a major giveaway. [p] Don't make things easy for the enemy."
	"f1000_oprg0960", --ALERT ONLY Fall back to a safe position. You can't take 'em all on! Lose the enemy, and find somewhere to keep out of sight.
	"f1000_oprg0970", --EVASION ONLY Looks like the enemy's lost sight of you. They're gonna try to hunt you down. The enemy's still searching for you. Stay sharp.
	"f1000_oprg0980", --Head for the RV. The chopper's waiting.
	"f1000_oprg0990", --We know where to find the target. Check your iDroid.
	"f1000_oprg1000", --Get him outta there
	"f1000_oprg1010", --Get yourself out of the hot zone. By chopper or by land, it's your choice.
	"f1000_oprg1015", --Get yourself out of the hot zone. By chopper or by land, it's your choice.
	"f1000_oprg1020", --You have to extract the target. Check his location on your iDroid.
	"f1000_oprg1030", --Exfiltrate out of the hot zone by chopper or on land.
	"f1000_oprg1040", --I've sent the information to your map screen. That's the target's predicted location. Check it on your iDroid.
	"f1000_oprg1050", --Check all around the target and plan carefully before moving in. You can check the target's VI on your iDroid.
	"f1000_oprg1060", --Good, you've completed the objective. Now get outta there. Exfiltrate out of the hot zone, by chopper or on land.
	"f1000_oprg1070", --What about the target? Put the target on the chopper.
	"f1000_oprg1080", --The target's safety is your top priority. Eliminate the threat.
	"f1000_oprg1090", --Good, you've completed the objective. Now get outta there.
	"f1000_oprg1100", --Eliminate the target. How you do it is your call.
	"f1000_oprg1110", --What's wrong? Hurry and secure the target.
	"f1000_oprg1120", --The target has started to move. You can check the predicted route on your iDroid.
	"f1000_oprg1130", --Boss, the target has already reached the objective area. You can check the target's location on your iDroid.
	"f1000_oprg1140", --Got enough ammo, Boss? If you run low, steal some from the enemy. Or, call in a supply drop.
	"f1000_oprg1150", --Boss, to take out enemy combat vehicles, you'll want to use explosive weaponry. Missiles, grenades, placed explosives... Make good use of your firepower. There's a lot of them out there.
	"f1000_oprg1160", --Your objective's complete. Exfiltrate the mission area by chopper or by land.
	"f1000_oprg1170", --Exfiltrate the mission area by chopper or by land.
	"f1000_oprg1180", --Don't try to take down a gunship from the front. You won't win in a head-to-head shootout. Try to get behind it and take it down with missiles.
	"f1000_oprg1190", --To take out a moving tank, first blow its tracks. How about planting mines in its path?
	"f1000_oprg1200", --A tank's armor is tough. To eliminate it, use missiles, grenades, or placed explosives. Something with a bang.
	"f1000_oprg1210", --No sign of the enemy... But a person's movement always affects their environment. Are there any light or sound clues you could use?
	"f1000_oprg1220", --Is the enemy using a scope, or maybe binoculars? If the lenses reflect light, that'll make them easier to spot.//Sometimes the lenses on scopes or binoculars will reflect light. But the same goes for yours. Avoid having them out for too long.
	"f1000_oprg1230", --Is the enemy using a scope, or maybe binoculars? If the lenses reflect light, that'll make them easier to spot.//Sometimes the lenses on scopes or binoculars will reflect light. But the same goes for yours. Avoid having them out for too long.
	"f1000_oprg1240", --The rule in a sniper duel is, "Whoever spots the other first, wins." Start by making sure you're somewhere you won't be seen. Then worry about looking for the enemy and shooting at them. Keep cool, or you will lose.
	"f1000_oprg1250", --If the enemy has a fix on you and pinned you down, try a distraction. Make 'em worry about something else. Do whatever you can to throw off their eyes and ears.
	"f1000_oprg1260", --Gunfire will give away your position to the enemy. After firing, immediately change your position.
	"f1000_oprg1270", --Boss, if we develop a child-size Fulton recovery device, you'll be able to extract those kids. Send the development order from your iDroid if you need it.
	"f1000_oprg1280", --Boss, you absolutely cannot use lethal weapons against kids. If only we had a Fulton device built for kids...
	"f1000_oprg1290", --You can neutralize the kids, but they have to wake up sometime. You could carry them to the chopper... But we want to keep this mission short and to the point.
	"f1000_oprg1300", --The amount of tranquilizer in your tranq darts is adjusted depending on the target. Don't worry about using it on those kids. They won't suffer any side effects.
	"f1000_oprg1310", --Press up against obstacles like walls to hide from the enemy and protect yourself from attack. This is "taking cover." Whenever the enemy is nearby, your first thought should be to take cover.
	"f1000_oprg1320", --When sneaking up on the enemy, move slowly, so your footsteps don't give you away. Approach the enemy undetected, and point your weapon at them to hold them up.
	"f1000_oprg1330", --You can use your prosthetic arm to make a knocking sound anywhere to lure the enemy. You can also select empty magazines, to throw them among your support weapons.
	"f1000_oprg1340", --Hiding on horseback allows you to stay out of sight even while on the move. It's effective for avoiding enemy guard posts and long-range reconnaissance patrols.
	"f1000_oprg1350", --You can view the target's predicted field of movement on your iDroid.
	"f1000_oprg1360", --We've already figured out the target's current position.
	"f1000_oprg1370", --Got enough ammo, Boss? If you run low, steal some from the enemy. Or, call in a supply drop.
	"f1000_oprg1380", --Boss, to take out enemy combat vehicles, you'll want to use explosive weaponry. Missiles, grenades, placed explosives... Make good use of your firepower. There's a lot of them out there.
	"f1000_oprg1390", --Don't try to take down a gunship from the front. You won't win in a head-to-head shootout. Try to get behind it and take it down with missiles.
	"f1000_oprg1400", --To take out a moving tank, first blow its tracks. How about planting mines in its path?
	"f1000_oprg1410", --A tank's armor is tough. To eliminate it, use missiles, grenades, or placed explosives. Something with a bang.
	"f1000_oprg1420", --Our bionic arm developer has submitted a proposal for a new feature. An active sonar that can detect the positions of soldiers, prisoners and animals. To start development, give the order from your iDroid.
	"f1000_oprg1430", --Hey, Boss, how about using a missile launcher?
	"f1000_oprg1440", --I know you've an expert when it comes to solo infiltrations, But now you have buddies that'll fight alongside you. Use your iDroid whenever you like.
	"f1000_oprg1450", --The role of your buddies is to support you during missions, but there's more than one way for them to do that. To get the most of a buddy's abilities, you need to give the right order for the situation.
	"f1000_oprg1460", --Your horse can move fast and does well on bad terrain. He's best for long journeys to your objective area. You can whistle to call him to your position from a distance. You can also shoot while on horseback, and hide off either side of him.
	"f1000_oprg1470", --The D-Walker is your own personal Walker Gear. Good not only for long trips and rough terrain, it can also move quietly. Perfect for infiltration. Like D-Horse, you can call it to your position by whistling. You can further develop it too, reinforcing the chassis and adding weapons. Go ahead and customize it however you like.
	"f1000_oprg1480", --The Battle Gear is an armored weapon developed to take on hostile bipedal weapon systems. You can alter its maneuverability by changing its posture. In travel mode it's as nimble as a horse, whereas in fire mode it can move while keeping an eye out in the area in front of you. It's armed with a railgun and a heavy machine gun. If you like, you can look into adding other weapons too.
	"f1000_oprg1490", --The target has started to move. You can check the predicted route on your iDroid.
	"f1000_oprg1500", --Guards have to change shifts sometime. You could always wait for that moment.
	"f1000_oprg1510", --Boss, the target has already reached the objective area.
	"f1000_oprg1520", --Not only does a chopper have a wide view of an area, once it spots you it's difficult to lose. If you're going to approach it, use buildings and trees for cover.
	"f1000_oprg1530", --A chopper's tail rotor prevents the fuselage from spinning around. Destroying its tail rotor will bring it down.
	"f1000_oprg1540", --That armored vehicle's equipped. With RMRFs. It can lay down fire over a wide area, so watch out. If you need to find it, move around behind it.
	"f1000_oprg1550", --A wheeled tank... Those are more faster than the more common tracked variety. Watch you don't get flanked in a fight.
	"f1000_oprg1560", --A Soviet main battle tank... Its armor is outdated, but that main gun isn't. A direct hit from that and you're finished.
	"f1000_oprg1570", --It's a third-generation main battle tank. With composite armor, it can withstand even HEAT rounds, it's practically a moving fortress. Its gas-turbine engine gives it speed too.
	"f1000_oprg1580", --Looks like it's equipped with a gatling gun. It's too dangerous to approach it from the front. Take out its operator from the front. You could also target its legs to immobilize it.
	"f1000_oprg1590", --Is that Walker Gear equipped with guided missiles? They'll track you right down if you don't evade them well. Try to put obstacles between them and you.
	"f1000_oprg1600", --Our radio calls and on-screen messages are recorded on your iDroid. If you want to view the records, open your iDroid and select "LOG" from the MISSIONS screen.
	"f1000_oprg1610", --The role of your support chopper is to extract you and your targets from the area of operations. It'll respond to situations with support fire as needed, and you can use flare grenades to indicate the objective directly.
	"f1000_oprg1620", --We can use compounds from plants to make medicine or poison, or even help develop new weapons and items. You can find out what types of plants we need by checking the "Plant List" on your iDroid. If you have the time, go pick a few. The staff'll appreciate it.
	"f1000_oprg1630", --Destroying their vehicles will slow the enemy down. But, you can also steal them for yourself.
	"f1000_oprg1640", --Destroying the power system will shut down the local electrical grid. That'll give you a leg up when operating in the dark.
	"f1000_oprg1650", --You can disrupt communications between enemy outposts by destroying comms equipment. That'll prevent one post from sending reinforcements to another.
	"f1000_oprg1660", --ALERT ONLY Fall back to a safe position. You can't take 'em all on! Lose the enemy, and find somewhere to keep out of sight.
	"f1000_oprg1670", --EVASION ONLY The enemy's still searching for you. Stay sharp.
	"f1000_oprg2000", -- ・Skulls (common): Strategy for mist combo You won't see them coming. Can you hear their footsteps? Surprise 'em with a guided missile?
	"f1000_oprg2010", -- ・Skulls (common): Strategy for defensive wall Looks like they can put up some kind of defensive wall. "You'll have to go around to attack, or use explosive weapons like grenades."
	"f1000_oprg2020", -- ・Skulls (common): Strategy for machetes "When they attack close up, you may be able to counter with CQC." But it's a high-risk strategy. There's no harm in playing it safe and diving away.
	"f1000_oprg2030", -- ・Skulls (common): Strategy for warp movement Don't let their quick movements lead you by the nose. Fire when they stop.
	"f1000_oprg2040", -- ・Skulls (common): Rust attack Don't get too close to that weird gas. It'll disable vehicles and Walker Gears.
	"f1000_oprg2050", -- ・Skulls (common): Eliminate them Eliminate the Skulls, Boss! Right now there's no choice but to fight it out!
	"f1000_oprg2060", -- ・Skulls (common): Eliminate them [2] Don't just let them hit you or you're finished. Make good use of cover, Boss.
	"f1000_oprg2070", -- ・Interpreter location (Pashto) "There are reports of a Pashto/English interpreter operating in that area." If you extract him, he could be plenty useful for us.
	"f1000_oprg2080", -- ・Interpreter location (Afrikaans) "We've heard there's an Afrikaans/English interpreter operating somewhere in that area." If you extract him, he could be plenty useful for us.
	"f1000_oprg2090", -- ・Interpreter location (Kikongo) "There should be a Kikongo/English interpreter somewhere in that area." If you extract him, he could be plenty useful for us.
	-- Real-time radio
	"f1000_rtrg0010", --・Outside the mission area Beyond there is outside the mission area.// "Where are you going?  [p] That's outside the mission area." //(Fourth time)Hey, where do you think you're going?!  
	"f1000_rtrg0015", -- (first time)Watch it, any further and you'll leave the mission area. (second time)You're heading outside the mission area. "(third time)You're leaving the mission area.  You're not giving up, are you?" 
	"f1000_rtrg0020", --・Aborting the mission "What's wrong, Boss?  [p] Mission abort?" //Are you sure? //Are you giving up? 
	"f1000_rtrg0030", --・Aborting the mission (chopper) "If you get on that chopper, you'll be aborting the mission.  [p] Are you sure?"// "Once you're on that chopper,  we'll have to abort the mission.  [p] Are you giving up?" 
	"f1000_rtrg0040", --Miller	"If you want to continue the mission, move away from the chopper."
	"f1000_rtrg0050", --・Chopper called Roger. Dispatching chopper. // Roger that chopper request. It's headed your way now. 
	"f1000_rtrg0060", --_millergz Roger.
	"f1000_rtrg0070", --・Called the chopper to a dangerous location Roger that, Snake. Boss, are you sure about this? Snake, that area is a hot zone! LZ confirmed.(Hesitant) 
	"f1000_rtrg0080", -- Don't even...! That's not funny.// Open your eyes, he's on our side // What are you doing?! That's one of ours! // Watch your fire! He's on our side! // Hey, don't you turn against us...! ("you damned impostor"... his true feelings nearly bubble to the surface)
	"f1000_rtrg0081", -- Open your eyes, he's on our side!/Don't even...! That's not funny./What are you thinking?!
	"f1000_rtrg0085", --・Don't shoot friendly choppers What are you doing?! That's one of ours! // Watch your fire! He's on our side! // Hey, don't you turn against us...! ("you damned impostor"... his true feelings nearly bubble to the surface)
	"f1000_rtrg0090", --・After Snake shot down the chopper himself While Snake attacks the chopper, Miller says "Boss, what are you doing?" "He's on our side!" "What's wrong with you?" etc., then when the chopper crashes:  (suppressing his anger) I'll ready another chopper, Boss. 
	"f1000_rtrg0100", --・Reporting retrieval (non-target passenger) He's coming too? Roger that.// You going to extract him? 
	"f1000_rtrg0105", --・Reporting retrieval (non-target passenger) All right, we'll bring him out. // Got him. Anyone else?
	"f1000_rtrg0110", --Boss, why did you kill him? //Enough! What do you think you're doing?
	"f1000_rtrg0115", --・Player dealt potentially lethal damage to a prisoner Enough! What do you think you're doing?
	"f1000_rtrg0116", --・Player dealt potentially lethal damage to a prisoner  Whoa, stop, stop! Your mission is to extract the targets.  //・Player dealt potentially lethal damage to a prisoner  What's gotten into you?! Do not injure the targets. You have to extract them. 
	"f1000_rtrg0120", --・Recommending "First Aid" ・Recommending "First Aid" If the player has serious injuries that require "first aid": "You're seriously injured. Find somewhere safe to rest.  [p] That'll give you a chance to apply first aid." // "Boss, that's a serious injury.  [p] It won't heal on its own.  [p] You'll need to treat it with first aid."//"First Aid" "(concerned grunt)That's a serious injury! Find cover and use first aid!"
	"f1000_rtrg0125", --・Recommending "First Aid" "(concerned grunt)That's a serious injury! Find cover and use first aid!" 
	"f1000_rtrg0126", --・Recommending "First Aid" Boss, that's a serious injury! "Perform first aid, now!  That wound won't heal on its own." 
	"f1000_rtrg0130", --・Suppressor has broken Your suppressor's dead! // "So your suppressor is worn out.  [p] That gun will be as loud as any other now.  [p] If you have to shoot, be careful." //Your suppressor's no longer effective. Bear in mind your weapon will be loud from now on. 
	"f1000_rtrg0135", --・Suppressor has broken Your suppressor's no longer effective. Bear in mind your weapon will be loud from now on. 
	"f1000_rtrg0140", --Destroyed anti-air emplacement "Anti-air emplacement confirmed destroyed.  [p] You'll have an easier time calling in  the chopper to your position now." //???//"Good, you took out an anti-air emplacement.  [p] I'm updating your LZ(landing zone) data." 
	"f1000_rtrg0145", --Destroyed anti-air emplacement "Destroying that anti-air emplacement's  put a dent in their air defenses.  [p] The chopper can come in closer now."// "Good, you took out an anti-air emplacement.  [p] I'm updating your LZ(landing zone) data." 
	"f1000_rtrg0150", --・Reporting updates to iDroid I've updated the info on your iDroid. Take a look.// iDroid information updated.//  I've updated the information on your iDroid.// I've sent new information to your iDroid. Take a look. 
	"f1000_rtrg0155", --・Reporting updates to iDroid I've updated the information on your iDroid. // I've sent new information to your iDroid. Take a look. 
	"f1000_rtrg0160", --・Time/Weather: Dawn  It'll be dawn soon. "Your surroundings will be easier to see, but that goes for the enemy as well." "The guard detail in Soviet outposts changes in the morning too." Watch yourself. 
	"f1000_rtrg0170", --・Time/Weather: Night shift change  It's about time for their shift change. Be prepared for a different guard detail. 
	"f1000_rtrg0180", --・Time/Weather: About rain  Rain... The sound of rainfall should help to mask your footsteps. 
	"f1000_rtrg0190", --・Time/Weather: About mist  It's getting misty. "That'll help keep visibility down, but watch you don't walk right into an enemy." 
	"f1000_rtrg0200", --・Time/Weather: About mist 2  Mist... wait, is it them?! 
	"f1000_rtrg0210", --・Time/Weather: About sandstorms  So a sandstorm's come in... Sandstorms effectively make you blind and deaf. But that goes for the enemy too. Use the situation to your advantage. 
	"f1000_rtrg0225", --・Outside weapon's effective range You're outside your weapon's effective range. Why don't you try getting a little closer to your target? "To land a shot from outside a weapon's effective range, you'll need to take bullet drop into account - [p] gravity's effect on the bullet."
	"f1000_rtrg0300", --・General-purpose movement instructions: Poor road, recommend horse  Vehicles aren't your best bet for traveling off-road. How about going on horseback? 
	"f1000_rtrg0310", --・General-purpose movement instructions: Unable to call in buddy, recommend vehicle  You're still pretty far from the objective. Why not try stealing an enemy vehicle? 
	"f1000_rtrg0320", --・Time-dependent radio call: Birthday Boss, we have an emergency! Get back to Mother Base, right now! I mean it - hurry! 
	"f1000_rtrg0330", --・Time-dependent radio call: Long play time 3  Boss, do you realize what time it is right now? Do yourself a favor and take a break. //"Boss, staying on the battlefield that long  will have a negative impact on your health." "Why not head back to Mother Base for a shower once in a while?" // Prolonged time in the field is bad for the body and mind. I think it's time you took a break. Do it for me. 
	"f1000_rtrg0340", --・Time-dependent radio call: Long play time 2  Prolonged time in the field is bad for the body and mind. I think it's time you took a break. Do it for me. 
	"f1000_rtrg0350", --・Time-dependent radio call: Long play time 3  Boss, do you realize what time it is right now? Do yourself a favor and take a break. 
	"f1000_rtrg0360", --・Results: No alerts  You completed the mission without being spotted... I can't believe it... Even after nine years in that coma! 
	"f1000_rtrg0370", --・Results: No kills  Mission complete without a single kill... No sense killing unless there's a profit in it, huh. Smooth work, Boss. 
	"f1000_rtrg0380", --・Results: Pat on the back after poor performance  Well, I guess you got the job done... You sure you're feeling up to this, Boss? 
	"f1000_rtrg0390", --・Results: Pat on the back after poor performance  Just one of those days, huh? It happens to the best of us... sometimes. 
	"f1000_rtrg0400", --_ocelot That soldier you extracted gave us some information. comr1000_g45010_0_ocelot 2ffb1986.wem
	"f1000_rtrg0401", -- That prisoner you extracted gave us some information.
	"f1000_rtrg0410", --"We got a lead on some work from that soldier you extracted."  I've added the details to your SIDE-OPS list. Whether we take it or not is up to you.
	"f1000_rtrg0411", -- "We got a lead on some work from that soldier you extracted."  I've added the details to your SIDE OPS List. If you're interested, take a look.
	"f1000_rtrg0420", --・Quest (side ops) addition (leading on from the above)  Whether we take it or not is up to you, Boss. I've added the details to your SIDE OPS List. If you're interested, take a look. 
	"f1000_rtrg0430", --・About revenge  "Hm? Those enemy soldiers are using different gear than before." "Maybe trying to put up some resistance against your tactics..." You might not do so well sticking to the same moves. Think carefully. 
	"f1000_rtrg0440", --・Mission info tape prompt  I put the mission details on a cassette tape. Before accepting the mission: Refer to that if you decide to accept the mission. 
	"f1000_rtrg0450", --・Prompts to listen to other tapes  "You can listen to the tapes you've  picked up using your iDroid." "If you're interested, why not play  them while you're on the move?" 
	"f1000_rtrg0460", --・What is GMP?  "GMP, Gross Military Product, is an index that  represents a military's economic situation." "We need GMP for everything from sending  out choppers to developing new weapons." "You could say that the overall strength of Diamond Dogs  depends on how much GMP we have." "You can earn more GMP by completing  missions and bringing in new staff." 
	"f1000_rtrg0470", --・Soviet radio transmissions  Do you hear that? "We're intercepting the Soviets' communications  and passing them onto you." "However, you'll need someone with the right  ""skill"" to interpret what they're saying." 
	"f1000_rtrg0480", --・Go to the mission start point (first time)  "There are supplies waiting for you at the mission start point." You'll also find the mission details there. You can check the location on your iDroid. 
	"f1000_rtrg0490", --・If the mission start point is far away  You're quite a distance from the mission start point. It'd probably be faster to call in the chopper. 
	"f1000_rtrg0500", --・Go to the mission start point (general-purpose)  All right, head for the mission start point. 
	"f1000_rtrg0510", --・Boarded a chopper during a mission  Boss, use your iDroid to select a destination. 
	"f1000_rtrg0520", --・Mission abort warning while moving by chopper  You're leaving the mission area. Are you aborting the mission? 
	"f1000_rtrg0530", --・Cargo Fulton extraction failed  "Boss, a Fulton recovery device designed for personnel  can't carry the weight of that kind of cargo." "We won't be able to extract it unless  we develop a specialized device." 
	"f1000_rtrg0531", --_miller Boss. We need a cargo-capable Fulton extraction device to recover the containers. Use your iDroid to order its development and have it dropped in.
	"f1000_rtrg0540", -- ・Fulton extraction will be spotted by the enemy Wait a minute, Boss. "There's a risk the Fulton extraction will be spotted by nearby enemies." "Either secure the area beforehand, or carry him somewhere out of sight first."
	"f1000_rtrg0550", --・Markers You can place markers on the map wherever you like. "I'd recommend setting some destination points to keep from getting lost."
	"f1000_rtrg0560", --・Diamond ore  Those are raw diamonds. Collecting them as assets will raise our GMP. 
	"f1000_rtrg0570", --・Material containers  That container's filled with raw materials. "Looks like they're using those colored bands  on the outside to tell the contents apart." "Whatever's in them, they'll come in  handy somehow for Diamond Dogs." 
	"f1000_rtrg0580", --・Processed materials  Those materials have already been processed... "It may not be much, but we can use them  straight away if you bring them back to base." 
	"f1000_rtrg0590", -- Emblems can be customized at the Aerial Command Center. "You can combine the parts you've gathered to create your own personal insignia."
	"f1000_rtrg0600", --・Contact us if you're in trouble  If you run into trouble, give us a call. (controls guide displayed) We may be able to offer some advice. 
	"f1000_rtrg0610", --・Recommending interrogation  "After you grab or hold up an enemy, try interrogating them." You never know what they might tell you. 
	"f1000_rtrg0611", --_miller The security forces must know something about the targets. After you grab or hold up an enemy, try interrogating them.
	"f1000_rtrg0615", --・Wild animals (prompting extraction)  Say, Boss, you seen many animals in the field? "Truth is, an environmental NGO has asked us to remove wild animals from combat zones." "If you have the time, can you extract some back here? There's a reward in it for us." 
	"f1000_rtrg0620", --・Captured animal: Normal (N) *small to medium-sized wild animal  Good, you captured it alive. 
	"f1000_rtrg0625", --・Captured animals  "If you set up a capture cage,  it'll trap small to medium size animals." "The Support Unit will handle the extraction, so all you need to do is place the cage." "Wild animals have all kinds of habitats. Try placing cages in a variety of places." "You can check the ANIMALS LIST on your iDroid to see which animals have been extracted." 
	"f1000_rtrg0630", --・Captured animal: Rare (R)  That's a pretty rare animal you caught! 
	"f1000_rtrg0635", --・Theft alarm device  An alarm trigger...?! Boss, get away from that thing! 
	"f1000_rtrg0640", --・Captured animal: Tsuchinoko  Is that... a Tsuchinoko? It's a legendary serpent said to inhabit parts of Japan. "No one's ever caught one before. Boss,  you just made the discovery of the century!" 
	"f1000_rtrg0645", --・Nuclear weapon (if development is already possible)  A nuclear weapon... "We could extract it and use it  as a deterrent, or dispose of it." What do you think, Boss?
	"f1000_rtrg0650", --・Captured animal: Tree pangolin  You caught a tree pangolin! "It's a mammal that resembles the armadillo, but  genealogically isn't far removed from order Carnivora." "It's endangered due to poaching, since its scales are  said to ward off evil spirits and have medicinal uses." 
	"f1000_rtrg0655", --・Nuclear weapon (if development is not yet possible)  That container holds... a nuclear weapon?! "That kind of deterrent WOULD make other  PFs think twice about coming after us... (a nuclear inspection was what triggered the events of GZ, so he's somewhat hesitant)"
	"f1000_rtrg0660", --・Captured animal: Caracal  You caught a caracal! "It's a predator of the Felidae family  that lives in deserts and hilly terrain. " "Cute... but completely lacking  the nobility of an ocelot." 
	"f1000_rtrg0665", --・Captured animal: African civet  That's an African civet! "In Indonesia, coffee beans harvested from civet dung go for a high price." "I've never heard of people doing that in Africa, but, I wouldn't mind giving it a try." 
	"f1000_rtrg0670", --・Captured animal: Blanford's fox  Hey, that's a Blanford's fox. "Foxes spend most of their time alone, but  they'll keep the same mate. They say in  the case of Blanford's foxes, it's for life." (sighs)Can't see the sense in it myself. 
	"f1000_rtrg0675", --・Captured animal: marsh mongoose  (serious) That's a marsh mongoose. Mongeese are widely known as snake eaters. (playful) Careful one of them doesn't get you too, Snake. (calls him Snake instead of Boss here to hammer the point) 
	"f1000_rtrg0680", --・Captured animal: Honey badger  You caught a honey badger! It may look funny, but it's got one fearless temperament. "It attacks bee hives and steals their honey, and  will even snatch a lion's kill out from under it." "It has resistance to cobra venom, not to mention  skin so thick even a lion can't bite through it." You might call it Africa's ultimate predator. 
	"f1000_rtrg0690", --・After interpreter soldier is automatically assigned "Boss, that language specialist you  extracted has been very cooperative." "Says he's always dreamed of living  a free life like folks in the West. (sarcastic tone of voice, as there is no freedom under Cipher's surveillance network)  [p] What are the odds, huh?" "I've gone ahead and placed him in the Support Unit.  [p] His job is Russian interpretation." "Now you'll know what Soviet soldiers are saying.  [p] You can even interrogate them." Should give you an edge in the mission. 
	"f1000_rtrg0700", --・Introducing Soviet soldier who can interpret "We've found out there's an English-speaking  soldier somewhere in the region.  [p] He's a language specialist." "His role is to translate information  related to the West into Russian." "If we can get him to join us, we'll have  the upper hand in information warfare." Find this language specialist and extract him. 
	"f1000_rtrg0710", --・Directing the players attention to something What's this...?
	"f1000_rtrg0720", --・Used when leading into something (object) There it is.
	"f1000_rtrg0730", --・Prompting player to gather intel (when an enemy outpost is in sight) Use your binoculars to see what's going on inside the base.
	"f1000_rtrg0740", --_miller The guards are on edge...//Eyes open, Boss.
	"f1000_rtrg0745", --_ocelot Tread carefully, Boss.
	"f1000_rtrg0750", --_millergz They've really tightened security. Eyes open, Boss.
	"f1000_rtrg0760", --_millergz Keep low. Check your surroundings carefully.
	"f1000_rtrg0770", --_millergz It's the enemy... Don't let 'em see you.
	"f1000_rtrg0780", --_millergz Enemy soldier! Hide - quickly!
	"f1000_rtrg0790", --When the threat detect effect appears: "Watch out.  [p] The enemy's close."// The enemy's nearby.// It's the enemy. Proceed with caution. 
	"f1000_rtrg0800", --・Player spotted by enemy They spotted you! Get away from there, now!
	"f1000_rtrg0810", --・Recommending retreat The enemy's trying to take you out. Don't push yourself. Fall back to a safe position.
	"f1000_rtrg0815", --_miller Boss, get out of there!//Get away from the enemy. Hurry!//Boss, get away from that thing!
	"f1000_rtrg0820", --・Recommending retreat Boss. Sometimes it's best to fall back. The enemy won't want to leave the base. It's too risky. I doubt they'd chase you very far.
	"f1000_rtrg0850", --・Announcing presence of interpreter "We've found out there's an English-speaking  soldier somewhere in the region.  [p] He's a language specialist." "With him on our side, we'd be capable  of Russian interpretation support." "We'd be able to do simultaneous interpretation  of what the Soviet soldiers are saying." 
	"f1000_rtrg0870", --・Reinforcements inbound Get outta there. Reinforcements are coming. "They have reinforcements coming in.  [p] Pull back now!"  (E3 2015)
	"f1000_rtrg0880", --・Checkpoint has been set up "Boss, looks like they've set up checkpoints.  [p] If you plan on escaping by land,  [p] you'll have to slip through somehow." 
	"f1000_rtrg0890", --・Enemies have lost sight of player When the enemy has lost the player following ALERT Mode: Looks like they've lost visual on you.// "Stay alert.  [p] You're not outta the woods yet."// "The enemy's searching for you.  [p] Stay out of sight." 
	"f1000_rtrg0900", --・The game returns to Infiltration Mode "You lost them...  [p] You need to focus, Boss."// "Looks like you lost 'em.  [p] You've got to be more careful." 
	"f1000_rtrg0910", --・Prolonged caution status Damn.(...) They're still on alert.(..) 
	"f1000_rtrg0920", --・A diversion worked (intercepted CP radio message) We've got enemy movement. "Security around the target will be light.  [p] Now's your chance." 
	"f1000_rtrg0930", --・Alert phase changed to evasion phase Looks like the enemy's lost sight of you. They're gonna try to hunt you down. 
	"f1000_rtrg0940", --・Evasion phase changed to caution phase The enemy's given up their search for you. But they're not giving the all clear just yet. Stay alert. 
	"f1000_rtrg0950", --・First time player couldn't understand a foreign language (when interrogating an enemy, etc.) Boss, you don't understand what he said? Ahh... I guess that makes sense... (Ocelot is thinking of an appropriate lie) It looks like that "horn" stuck in your head has impacted the language center of your brain. "If only we had a recruit with the Russian ""Interpreter"" skill, we could get by with simultaneous interpretation..." 
	"f1000_rtrg0960", --・Identified the interpreter soldier That Soviet soldier in the green beret is speaking English... must be a language specialist. With him on our side, we'd be capable of Russian interpretation support. Try and extract him. 
	"f1000_rtrg0970", --・Prompting player to assign interpreter soldier Boss, that language specialist you extracted has been very cooperative. Says he's always dreamed of living a free life like folks in the West. (sarcastic tone of voice, as there is no freedom under Cipher's surveillance network) What are the odds, huh? I'd like him to handle Russian interpretation. Open your iDroid and place him in the Support Unit. 
	"f1000_rtrg0980", --_miller Boss, that Soviet soldier you extracted is an English interpreter. He's a language specialist. He's been very cooperative. Friendly, even. I've gone ahead and placed him in the Support Unit. His job is Russian interpretation. Now you'll know what Soviet soldiers are saying. You can even interrogate them.
	"f1000_rtrg0990", --・Prompting player to assign interpreter soldier (and player extracted him without knowing he is an interpreter) Boss, one of the Soviet soldiers you extracted was an English interpreter. He's a language specialist.  He's been very cooperative. Friendly, even. I'd like him to handle Russian interpretation. Open your iDroid and place him in the Support Unit.  
	"f1000_rtrg1000", --If only one soldier was extracted Boss, that Soviet soldier you extracted is an English interpreter. He's a language specialist.  He's been very cooperative. Friendly, even. I'd like him to handle Russian interpretation. Open your iDroid and place him in the Support Unit. 
	"f1000_rtrg1005", --
	--■Announcements for use in "s10115: Take Back Mother Base"
	"f1000_rtrg1010", --・Mission occurrence notification (first time) Boss, we have an emergency. Mother Base is under attack. "The enemy has overrun several of the platforms,  and they're holding some of our staff hostage." "If we don't do something, they'll  try to take off with our men." That would mean losing some of our finest manpower. Boss, take back that platform! This is a race against time. For all of us... get on this mission right away, Boss. 
	"f1000_rtrg1020", --・Mission occurrence notification (second time) Boss, bad news. Mother Base has come under attack again. The Security Team couldn't hold them back. If we'd just focused more resources on them...  "Currently the enemy has control of one of  our platforms, and has taken hostages." pl. "Currently the enemy has control of several  platforms, and has taken hostages." "The only way to save them is to  eliminate the enemy commander." 
	"f1000_rtrg1030", --・Result of ignoring the mission Boss, I... have something to report. (bad news) "I sent a strike force to take back  the platform the enemy had captured." pl. "I sent a strike force to take back  the platform the enemy had captured. " All but one of the enemies were killed in the fighting. "But, the staff members they were  holding hostage didn't make it either." "Under orders from their commander,  one of them grabbed the hostages, and...  [p] He blew himself up." The commander used that diversion to get away. "I'm...  [p] I'm sorry, Boss." They were trying to pull out. We had to move in. "If we could've taken out the commander  before then without them noticing...  [p] Ah, forget it." I'll remove the mission from the Mission List. 
	"f1000_rtrg1040", --・Establishment of the Security Team Boss, listen a moment. "I want to bolster our security  to guard against enemy attacks." "What I have in mind is to create a ""Security Team""  that can defend each of the platforms." Can I go ahead with that? "So from now on,  [p] give some thought to building up the Security Team as well." "Without a strong enough deterrent,  we'd just be asking to get attacked again." I'm counting on you, Boss. 
	"f1000_rtrg1050", --・Prompting player to extract an interpreter (interrogation version) "He speaks Russian...  [p] What we need is an interpreter." "The main principle of intelligence work is intel gathering, [p] but that's a problem if you don't speak the enemy's language.  [p] We need a staff member with the Interpreter  skill to do simultaneous interpretation." 
	"f1000_rtrg1060", --・Reinforcements appear  Reinforcements from the south. They're moving to surround you! 
	"f1000_rtrg1070", --・Spotted by the enemy while moving with the boys  They saw you! Deal with them! 
	"f1000_rtrg1080", --When player should run to escape, etc. Move!!// Run! 
	"f1000_rtrg1090", --・Lower your stance You should lower your stance.// Keeping low will help you stay out of sight.
	"f1000_rtrg1100", --"If you don't want the enemy to  spot you, stay as low as possible." Sticking to walls is also a good idea. 
	"f1000_rtrg1110", --・Prompting action (Interrogation) "Interrogate him.  [p] Find out what he knows." 
	"f1000_rtrg1120", --・Minefield Wait, there's something there. "Did they set a trap?  [p] Look around carefully..." 
	"f1000_rtrg1130", --・Caution when indoors You've entered a building... "Always keep an escape route  in mind when you head indoors." If you get surrounded, you'll have nowhere to run. 
	"f1000_rtrg1140", --・Don't shoot the target Boss, what the hell was that?// Open your eyes, he's on our side!// Oh, I'm gonna tell everyone about this.// What the hell are you doing?!// Boss, stop!// What's gotten into you?// Hey hold on, that's...! 
	"f1000_rtrg1150", --_millergz Hey hold on, that's...! What's gotten into you?
	"f1000_rtrg1160", --_millergz Boss, what the hell was that?
	"f1000_rtrg1170", --_millergz Oh, I'm gonna tell everyone about this.
	"f1000_rtrg1180", --・To extract this person, call the chopper "If you want to extract him, call in  the chopper and we'll get him out." 
	"f1000_rtrg1200", --・Prompt to notice event in progress: Target already identified by face  Security's pretty light around the target. This could be your best chance. 
	"f1000_rtrg1210", --・Making player aware of mission completion method restriction Badly wounded(, huh)... We can rule out a Fulton extraction. We'll just have to do it by chopper. Call the chopper from your iDroid, Boss. Then carry the target to it. 
	"f1000_rtrg1220", --・When continuing  Get the targets to the RV. 
	"f1000_rtrg1230", --・Prompting player to call in a sniper rifle (if sniper rifle has already been developed) Follows previous line If you need a sniper rifle, call in a supply drop. 
	"f1000_rtrg1240", --・Prompting player to develop a sniper rifle (if sniper rifle hasn't been developed) Follows "You've reached the vantage point" line From that range, you'd be better off with a sniper rifle.(..) If you need one, just order it developed at Mother Base. 
	"f1000_rtrg1250", --_miller That's the target. Eliminate him, however you see fit.
	"f1000_rtrg1260", --_miller That's the target. How you eliminate them is up to you, Boss.
	"f1000_rtrg1270", --・Prompting player to get on with the mission Boss, head toward the objective. 
	"f1000_rtrg1280", --・Find the target Look for the target.
	"f1000_rtrg1290", --・Find the target Locate the target.
	"f1000_rtrg1300", --・Prompting player to get on with the mission (carrying) Hurry up and carry the target toward the objective. 
	"f1000_rtrg1310", --・Prompting player to hunt for target Where's the target? Has to be around there somewhere. 
	"f1000_rtrg1320", --・Prompting player to extract target Hurry up and extract the target.// Get him outta there!// You have to extract the target.
	"f1000_rtrg1330", --・Get back to the mission at hand (general purpose) I need you to get back to the mission.// Boss, get back to the mission. 
	"f1000_rtrg1340", --・Prompting player to get on with the mission "If you're not sure how to proceed, contact me by radio -  [p] I might have just the advice you need."// "What are you waiting for -  we don't have time to spare." 
	"f1000_rtrg1350", --・That's not the place Boss, let's try somewhere else. Forget about that one, Snake. 
	"f1000_rtrg1360", --・Supplemental information on how to clear the mission Your objective's complete. Exfiltrate the area. 
	"f1000_rtrg1370", --"Good, you've completed the objective.  [p] Now get outta there."  Exfiltrate out of the hot zone, by chopper or on land.
	"f1000_rtrg1375", --"Good, you've completed the objective.  [p] Now get outta there." 
	"f1000_rtrg1380", --・Prompting player to complete mission following extraction  Target extracted. Exfiltrate the hot zone, Boss. 
	"f1000_rtrg1390", --"Either exfiltrate by chopper, or make your  way outside the mission area by land. " 
	"f1000_rtrg1395", --"You've completed your objective.  Now get out of the hot zone."//Leave the mission area, by chopper or by land. 
	"f1000_rtrg1396", --"You've completed your objective.  Now get out of the hot zone." 
	"f1000_rtrg1400", --"Objectives complete.  [p] Get on the chopper." 
	"f1000_rtrg1405", --・When prompting player to exfiltrate the hot zone by chopper or on land "You've completed your objective.  Now get out of the hot zone."// Leave the hot zone and find someplace safe.// "Get yourself out of the hot zone.  By chopper or by land, it's your choice."// Exfiltrate out of the hot zone, by chopper or on land.//
	"f1000_rtrg1410", --・Prompting player to hurry to safe territory "No time to hang around.  Get out of the hot zone!" 
	"f1000_rtrg1420", --・Radio call when player has approached the area limits and can complete the mission by moving outside the mission area Continue out of the mission area to complete the mission. 
	"f1000_rtrg1430", --・Adding safe territory to iDroid I've marked the hot zone on your map. Check your iDroid. 
	"f1000_rtrg1440", --・Urging the player to exfiltrate (general purpose) (First time)Hurry. You've got to get outta there.// (Second time)Come on, Boss! You don't want to hang around!// "No point hanging around.  [p] Get your ass outta there."// Hurry up and get outta there.// Hurry up and exfiltrate the hot zone. 
	"f1000_rtrg1450", --・iDroid (VI) prompt You can check the target's VI on your iDroid. // "I've sent VIs of the targets to your iDroid.  [p] Take a good look." 
	"f1000_rtrg1460", --・Cassette tape prompt How about you try listening to the tape? 
	"f1000_rtrg1470", --・Hinting that there is a weapon nearby You've run out of explosives. "See anything in the area?  [p] Take a look around." If you need a supply drop, call it in from your iDroid. 
	"f1000_rtrg1480", --
	"f1000_rtrg1490", --・Reporting updates to iDroid I've updated the info on your iDroid. Take a look.
	"f1000_rtrg1500", --・Reporting updates to iDroid I've updated your map info. Check it on your iDroid.
	"f1000_rtrg1510", --・Reporting updates to iDroid iDroid information updated. It's on your iDroid.
	"f1000_rtrg1520", --・Reporting updates to iDroid I've updated the information on your iDroid.//I've sent new information to your iDroid. Take a look.
	"f1000_rtrg1530", --・Intel-related You got an intel file.// Picked up an intel file, huh? 
	"f1000_rtrg1540", --Analyzing the intel file you picked up. Unfortunately, there's nothing new in it. 
	"f1000_rtrg1550", --・Reporting retrieval "(First time)OK, subject is in. (ALT: OK, he's in.)" "(Second time)Subject on board. Leave the rest to us. (ALT: He's on board. Leave the rest to us.)" "(Third time)Subject's inside. Is that it? (ALT: He's inside. Is that it?)" 
	"f1000_rtrg1560", --Target extracted.//Good, that's the target extracted.//All right, target extracted.//Target extracted.//Target extraction confirmed.
	"f1000_rtrg1561", --Target extracted.
	"f1000_rtrg1562", --All right, target extracted.
	"f1000_rtrg1563", --Target extracted. Anyone else?
	"f1000_rtrg1564", --Good, that's the target extracted.
	"f1000_rtrg1565", --Target extracted. Is that everyone?
	"f1000_rtrg1570", --Is that everyone?
	"f1000_rtrg1580", --All right, target extracted.//He's coming too? Roger that.//You going to extract him?
	"f1000_rtrg1590", --・Fulton extractions - low success rate for the badly wounded "The Fulton system has a low  success rate for wounded extractees." The strain on the body would be too much. It'd be better if you could use the chopper instead.(..) 
	"f1000_rtrg1600", --Reminding the player We're better off extracting the wounded via chopper. 
	"f1000_rtrg1610", --Boss, just to make sure we're on the same page here... The Fulton Recovery System can't go through the ceiling. "If you're going to Fulton someone, make sure there's nothing directly overhead first."//Hey! Whoa, whoa, whoa. "If you're going to Fulton someone, make sure there's nothing directly overhead first."//Boss, stop!
	"f1000_rtrg1615", -- Hey! Whoa, whoa, whoa. "If you're going to Fulton someone, make sure there's nothing directly overhead first."//Enough already. Give it up.//Boss, stop!//What are you thinking?!
	"f1000_rtrg1620", --・Interpreter has arrived at Mother Base  "Boss,  [p] that interpreter you extracted has been cooperative." Turns out he's always been a fan of the legendary Big Boss. ・(if placement is set to manual)  "Put the interpreter in the Support Unit  to get him to interpret for us." 
	"f1000_rtrg1625", -- "Boss, [p] that interpreter you extracted has been cooperative." "Put the interpreter in the Support Unit to get him to interpret for us."
	"f1000_rtrg1630", --・Interpreter has arrived at Mother Base  "Boss,  [p] that interpreter you extracted has been cooperative." Turns out he's always been a fan of the legendary Big Boss. ・(if placement is set to automatic)  I'll put him in the Support Unit so he can start doing Afrikaans interpretation for us.
	"f1000_rtrg1635", --"Boss, [p] that interpreter you extracted has been cooperative." "I'll put him in the Support Unit so he can start doing Afrikaans interpretation for us."
	"f1000_rtrg1640", --That's the way! // Flawless work. You never cease to amaze, Boss.// Nice work. Keep it up. // Nice work. // Good work.
	"f1000_rtrg1641", --・Complimenting player on his skill Flawless work. You never cease to amaze, Boss. // Good work. // Great.
	"f1000_rtrg1645", --・Complimenting player on his skill Flawless work. You never cease to amaze, Boss. 
	"f1000_rtrg1647", --・General-purpose congratulatory remarks  Great job. Nice going, Boss. You're pretty good. 
	"f1000_rtrg1650", --・If player solved a problem in a way Miller hadn't imagined Ohhh! Now that's some lateral thinking! 
	"f1000_rtrg1660", --・Encouragement Nearly there, Snake.// Nearly there, Boss.// You can do it, Snake.// You can do it, Boss. 
	"f1000_rtrg1665", --・Encouragement "What's the big hurry? That's not like you.  [p] Take your time." //Calm down and focus.(ALT: Calm down and think clearly.)
	--・Countdown
	"f1000_rtrg1670", --_millergz Six minutes remaining.//Five minutes remaining.//Four minutes remaining.//Three minutes remaining.//Only two minutes remaining!//One minute remaining! What's wrong with you?! Move!//30 seconds remaining! Come on, Snake, hurry it up!//10 seconds!//No! You're not gonna make it!//You're outta time! Snake!!
	"f1000_rtrg1671", --_millergz Six minutes remaining.
	"f1000_rtrg1672", --_millergz Five minutes remaining.
	"f1000_rtrg1673", --_millergz Four minutes remaining.
	"f1000_rtrg1674", --_millergz Three minutes remaining.
	"f1000_rtrg1675", --_millergz Only two minutes remaining!
	"f1000_rtrg1676", --_millergz One minute remaining! What's wrong with you?! Move!
	"f1000_rtrg1677", --_millergz No! You're not gonna make it
	"f1000_rtrg1678", --_millergz You're outta time! Snake!
	"f1000_rtrg1680", --・Cannot obtain information during alert phase "Boss, leave the intel files till later.  The enemy's on combat alert."// "Wait for the enemy to stand down,  then you can worry about intel."  
	"f1000_rtrg1690", --・Intel file was lost "(rough sigh of disappointment)That the remains of an intel file?  [p] No way to decipher it now." 
	"f1000_rtrg1700", --・Intel file was lost "(rough sigh of disappointment)That the remains of an intel file?  [p] No way to decipher it now."  What now? Guess you'll have to search another outpost.
	"f1000_rtrg1710", --_・Announcing start of interpretation support Boss, Russian language interpretation is ready to go. Now you'll know what Soviet soldiers are saying. You can even interrogate them too. Should give you an edge in the mission.
	"f1000_rtrg1720", --・Spotted top-secret file (after recovering both containers) Analyzing the intel file you picked up. Hmm... There was no new information. Hurry up and get outta there.
	"f1000_rtrg1730", --・Child killed (by the enemy) He's dead.//They killed a target. //(pained grunt)They got him. //Another one dead. 
	"f1000_rtrg1731", --・Child killed (by the enemy)  He's dead. 
	"f1000_rtrg1732", --・Child killed (by the enemy)  (pained grunt)They got him. 
	"f1000_rtrg1733", --・Child killed (by the enemy)  Another one dead. 
	"f1000_rtrg1734", --・Child killed (by the enemy)  They killed a target. 
	"f1000_rtrg1740", --・RV updated "I'm changing the RV(rendezvous point). [p] Confirm it on your iDroid." "New RV (rendezvous point)marked. [p] Use your iDroid to check the location."
	"f1000_rtrg1750", --・Carry him to the RV I'll send the chopper. Get the target to the RV.
	"f1000_rtrg1760", --・Call the chopper OK, now use your iDroid to call the chopper for pickup. // Call the chopper from your iDroid. // ・Call the chopper 2 Go ahead and call the chopper. // Call in the chopper.	
	"f1000_rtrg1770", --"Use a flare grenade to call the chopper to your current position. [p] Just don't forget you might put it in danger of being shot down."
	"f1000_rtrg1780", --・Player used a flare grenade underground Boss, you can't call the chopper there.
	"f1000_rtrg1790", --Calling the chopper with the iDroid Choose an LZ(landing zone) and we'll send the chopper there.
	"f1000_rtrg1800", -- ・Caution when calling in the chopper The enemy is nearby OR the player tries to call the chopper from somewhere other than the RV: "Keep an eye out for nearby enemies. [p] They could try to shoot down the chopper." "Don't call in the chopper if the area's hot. [p] Stay sharp."
	"f1000_rtrg1810", -- ・Chopper called Roger. Dispatching chopper.//Roger that chopper request. It's headed your way now.
	"f1000_rtrg1820", -- ・Called the chopper to a dangerous location Roger that, Snake.// Boss, are you sure about this?// LZ confirmed.(Hesitant)
	"f1000_rtrg1830", -- ・Can't call chopper (general purpose) "That's a negative. Can't send a chopper till you've eliminated the enemy." Sorry, Boss. It's all up to you.
	"f1000_rtrg1840", --・Support chopper will arrive shortly The chopper'll be arriving any minute. Hurry to the RV. 
	"f1000_rtrg1850", --・Anti-air radar has picked up the support chopper The enemy's anti-air radar has picked up our chopper. Double-time it to the RV. 
	"f1000_rtrg1860", --・Prompting player to get on with the mission (RV/LZ) When there's no need to differentiate between the RV and LZ, or when prompting player from the second time onward. Get to the chopper, ASAP!//Get to where the chopper's touching down.
	"f1000_rtrg1870", --"All right, get in!  [p] Time to go!" 
	"f1000_rtrg1880", --All right. Take the chopper out of there.
	"f1000_rtrg1890", --・Spoken at takeoff when player boards the chopper to abort the mission All right, now get outta there. 
	"f1000_rtrg1900", --・If you want the chopper to leave, move away from it "If you want to continue the mission,  move away from the chopper." I'm pulling the chopper out for now. 
	"f1000_rtrg1910", --・Reporting that the chopper has been shot down, and warning the player about further risk First time They shot down the chopper! "I'll prep a backup chopper. Just make sure you don't send it somewhere hot." 
	"f1000_rtrg1920", --Second time "Not again!  [p] We lost another chopper!!  [p] Boss, get it together.  [p] Make sure the area's clear  before you call in the chopper." Boss, get it together. Make sure the area's clear before you call in the chopper. 
	"f1000_rtrg1930", --Third time "Damn it,  [p] that's another chopper down!  What's going on out there?!  [p] Snake, the heavy-handed approach isn't going to work.  [p] Take out the enemy's air defenses  before you call in the chopper."
	"f1000_rtrg1940", --・Support chopper shot down: enemy attack  They shot down the chopper!  I'll ready a backup chopper. Call it from your iDroid. 
	"f1000_rtrg1950", --・Enemy chopper appears  Got an enemy chopper inbound to the RV. It's coming after ours. Take it out! 
	"f1000_rtrg1960", --・Enemy chopper destroyed  (full of satisfaction)That's the way! Enemy chopper confirmed down. 
	"f1000_rtrg1970", --・High ground: chopper lands  Good work. The chopper's touching down. Get on! 
	"f1000_rtrg1980", --・Requesting support chopper  You can link up with the chopper at the designated RV. Head for the RV. 
	"f1000_rtrg1985", -- It's coming after ours. Take it out!
	"f1000_rtrg1990", --・Player calls chopper from iDroid after it's already arrived  The chopper's waiting at the RV. Hurry. 
	"f1000_rtrg2000", --・Support chopper shot down  I'm sending another chopper. Hang in there. 
	"f1000_rtrg2010", --・About the small outpost It's an enemy guard post. Watch yourself. 
	"f1000_rtrg2020", --・Announcing anti-air radar destruction You destroyed their anti-air radar? "It wasn''t one of the targets, but that''s  put a hole in their air surveillance." "The chopper will be able to get in close now.  [p] You can designate a landing zone near the outpost."
	"f1000_rtrg2030", --・Rescued prisoner provided intel (First time) Boss, that prisoner we rescued provided some intel. (Second time) That prisoner gave us some new intel. (Third time) I've got intel from that prisoner.
	"f1000_rtrg2040", --・Prisoner that isn't a target That prisoner doesn't look like the target... 
	"f1000_rtrg2050", --・Marked a prisoner (before confirming target)  A prisoner... Is that the target? "Even if it isn't, you might get some  information if you rescue him." //There's one of the prisoners... Check to see if that's the target. 
	"f1000_rtrg2060", --・Marked a prisoner (before confirming target)  There's one of the prisoners... Check to see if that's the target. 
	"f1000_rtrg2070", --・Cannot contact prisoner during an alert "It's too dangerous to make contact  with the prisoner right now.  [p] Wait for the enemy to stand down first." 
	"f1000_rtrg2080", --・Target (No. 2) cannot be Fultoned  That's the target prisoner. He's injured... looks half-starved, too. "There's no way he can stand  the shock of a Fulton extraction." Get him out by chopper. 	"f1000_rtrg2090", --He's coming too, huh? // "(Second time)Subject on board. Leave the rest to us.
	"f1000_rtrg2090", --
	"f1000_rtrg2095", --・Bonus prisoner extracted  He's coming too, huh? 
	"f1000_rtrg2100", --・Bonus prisoner died  "Dead, huh...? [p] Poor son of a bitch." Boss, let's focus on the contract. Head for the village.
	"f1000_rtrg2110", --・Bonus prisoner died  "Dead, huh...? [p] Poor son of a bitch." Boss, let's focus on the contract. 
	"f1000_rtrg2120", --・When unsure whether it is the target Is that him...? Take a good look at their faces so we can ID the targets.
	"f1000_rtrg2125", --The below follows if the face can't be seen very well from where the player is: Take a good look at their faces so we can ID the targets.
	"f1000_rtrg2130", --・Confirming target's current location Check the target's current location. 
	"f1000_rtrg2140", --・Marking the target's position on the map Snake, I've marked the target's position on your iDroid.
	"f1000_rtrg2150", --・Target location now confirmed We've got a fix on the target.
	"f1000_rtrg2160", --・Target location already confirmed We know where to find the target. Check your iDroid. 
	"f1000_rtrg2170", --There. That's the target.
	"f1000_rtrg2171", --・Identified target by face There. That's the target.//That's the target.//That looks like the target.
	"f1000_rtrg2175", --・Identified target by face That's the target. Looks like we've found him. 
	"f1000_rtrg2180", --・The target is him. On the iDroid That's the target.
	"f1000_rtrg2190", --・The target is him. That looks like the target.//There he is. That guy's the target.
	"f1000_rtrg2200", --・Target identified (one target among multiple targets) When the player identifies a target: That's one of the targets. 
	"f1000_rtrg2210", --・Reaction to getting vague intel on the target (interrogation [3]/secret info [3]/prisoner [2]) I've sent the information to your map screen. But as leads go, this one covers too wide an area. 
	"f1000_rtrg2220", --・Reaction to getting vague intel on the target (second intel onward following "interrogation" or "secret info") OK, your map information's updated. 
	"f1000_rtrg2230", --・Reaction to getting vague intel on the target (second intel onward following "prisoner") The prisoner you extracted knew where the target is. "I'm updating your map information.  [p] Take a look." 
	"f1000_rtrg2240", --・Can't contact target because enemy is nearby "It's too dangerous to contact the target right now.  [p] Wait till the coast is clear."// "(Second time) Contact is a no-go for now.  [p] Pull back, and wait till things die down."// "The enemy's looking for you. You should wait before trying to make contact." 
	"f1000_rtrg2250", --・Can't contact the target due to ongoing combat "It's too dangerous to try and contact the target.  Wait for the enemy to stand down."//"The enemy's trying to take you out.  Contact the target later." 
	"f1000_rtrg2260", --・Can't contact the target due to enemies nearby "Don't make contact with the target yet -  wait until the area's clear of enemies."// "The enemy's too close...  Can't approach the target like this." 
	"f1000_rtrg2270", --・Now able to contact target (security lightened) "They've lightened their security.  Make contact with the target." // OK - now's your chance to contact the target. 
	"f1000_rtrg2280", --・Now able to contact target (enemy standing down from combat status) "They're standing down.  [p] Make contact with the target." // OK - now's your chance to contact the target. 
	"f1000_rtrg2290", --・Contact the target "Good, the target's alone now.  [p] Make contact with him." 
	"f1000_rtrg2300", --・Target spotted So you've spotted the target.//Our contract is to eliminate the target. 
	"f1000_rtrg2310", --・Target's position is blown --_miller Not good. The enemy's spotted the target. Get him outta there
	"f1000_rtrg2320", --・Don't just leave the staff member (first time)Boss, you're just leaving the target? 
	"f1000_rtrg2325", --・Don't just leave the staff member (second time)You're not seriously leaving him there?! (reproachfully)
	"f1000_rtrg2330", --・Enemy has discovered that target has escaped (and player is already aware of escape) Boss. They've discovered the target's escaped. If they find him, they'll kill him. You gotta get to him first.
	"f1000_rtrg2340", --・Warning when player got target involved in combat The target's safety is your top priority. Eliminate the threat. 
	"f1000_rtrg2350", --_miller Not good. The target is severely wounded. The Fulton system has a low success rate for wounded extractees. It'd be better if you could use the chopper instead.
	"f1000_rtrg2360", --・Player put target in a chokehold or picked them up without confirming their identity Is that the target? 
	"f1000_rtrg2370", --・Player Fultoned/chopper extracted target without confirming their identity (Hm? )That's the target. Target extracted. "I'll tell the client they've been  [p] ""eliminated.""" 
	"f1000_rtrg2375", --(Hm? )That's the target. You've completed your objective. Now get out of the hot zone.
	"f1000_rtrg2380", --・Neutralized the target What are you planning on doing, Boss? "Putting the target to sleep  doesn't count as eliminating them.  [p] Neither does knocking them out."
	"f1000_rtrg2390", --・Target eliminated (killed) Target confirmed dead. 
	"f1000_rtrg2395", --・Target eliminated (killed) Target confirmed dead. Impressive work, Boss! 
	"f1000_rtrg2400", --・Eliminated (killed) target without confirming their identity Hey, that was...! Target confirmed dead. Impressive work, Boss! 
	"f1000_rtrg2410", --・Eliminated target by extracting them Extracting the target. "Our contract was to kill the target,  [p] but I'll go with your decision." 
	"f1000_rtrg2420", --・Target Fulton extraction failed "Boss,  [p] about the Fulton extraction of that target..." (upset)It was a failure. Target's confirmed dead. There was nothing we could do. 
	"f1000_rtrg2425", --・Target Fulton extraction failed, after having not confirmed their identity "Boss, that person you Fulton extracted  turned out to be the target." (upset)But it was a failure. Target's confirmed dead. "(... )That being said,  [p] the mission was to take out the target." So this won't present a problem for the contract.
	"f1000_rtrg2430", --・Elimination target Fulton extraction failed Boss, about the Fulton extraction of that target... "(upset)It was a failure.  Target's confirmed dead." "(... )That being said,  [p] the mission was to take out the target." So this won't present a problem for the contract. 	"f1000_rtrg2440", --・Escaping the half-constructed building Great. "If there's nothing in the way overhead,  you should be able to Fulton him." 
	"f1000_rtrg2440", --
	"f1000_rtrg2450", --・Child-size Fulton device can be developed  "Boss, if we develop a child-size Fulton recovery device, you'll be able to extract those kids." "Send the development order from your iDroid if you need it." 
	"f1000_rtrg2460", --・Prompt the player to try again based on proper timing. Try making contact again. 
	"f1000_rtrg2470", --・Quickly secure the target What's wrong? Hurry and secure the target. 
	"f1000_rtrg2480", --・Arrived at the RV Great, you made it. Put the target on the chopper. 
	"f1000_rtrg2490", --・Put the target on the chopper first The player, despite having rescued a target, tries to get in the chopper without putting the target on board (This is to ensure the player doesn't inadvertently cancel the mission) Put the target on board first.//Are you just going to leave the target there, Snake? 
	"f1000_rtrg2500", --・Target extracted by chopper (player got on board with target) Target extraction confirmed. Time to go! 
	"f1000_rtrg2505", --_miller Target extraction confirmed. You've completed your objective. Now get out of the hot zone.
	"f1000_rtrg2510", --・Neutralized one of multiple targets (one remaining) Target neutralized. One remaining. 
	"f1000_rtrg2520", --・Extracted/recovered one of multiple targets (human or object) (one remaining) Target extracted. Only one left. 
	"f1000_rtrg2530", --・[Progress] Target eliminated Target confirmed dead. Objective complete. Exfiltrate out of the hot zone, by chopper or on land. Don't hang around. 
	"f1000_rtrg2550", --・Your objective is to kill him Boss. I gotta say, it'd be a waste to kill him... "But putting him to sleep doesn't count as eliminating him.  [p] Neither does knocking him out." 
	"f1000_rtrg2560", --・Prompt to notice event in progress: Target not yet identified by face  They're talking about something... The target? Listen in and find out. 
	"f1000_rtrg2570", --・Also used as intel radio: About the tent outpost's fortified section (target identified by face)  We have a fix on the target's location. "We just have to figure out  how to get close and pull him out." "Check all around the target and  plan carefully before moving in." 
	"f1000_rtrg2580", --・Encouragement directly before mission complete  Great, the target's safe. Put him on the chopper. 
	"f1000_rtrg2590", --Second phase Good. We've narrowed down the target's whereabouts. Take another look at your iDroid. 
	"f1000_rtrg2600", --Third phase OK. We know where the target is. Get over there - no time to waste. 
	"f1000_rtrg2610", --・Target extracted (Fulton extraction) Target extracted. We'll let the client know he's been "dealt with." Exfiltrate out of the hot zone, by chopper or on land.
	"f1000_rtrg2620", --・Target extracted (Fulton extraction) All right, target extracted. We'll let the client know he's been "dealt with." Objectives complete. Get on the chopper.
	"f1000_rtrg2630", --・Target killed Target confirmed dead. Your objective's complete. Exfiltrate out of the hot zone, by chopper or on land.
	"f1000_rtrg2635", --
	"f1000_rtrg2640", --Boss. Continue out of the mission area to complete the mission.
	"f1000_rtrg2650", --"You're clear of the hot zone.  [p] Mission complete." 
	"f1000_rtrg2660", --If the player's field of vision gets hazy: Are you all right?! You're damaged pretty bad. Don't push yourself. Fall back to a safe position.//"Boss!  [p] Get outta there and find a place to recover." In general "You can recover by resting.  [p] Don't overdo it out there." 
	"f1000_rtrg2670", --If the player's field of vision gets even hazier: "Boss!  [p] Get outta there and find a place to recover." In general "You can recover by resting.  [p] Don't overdo it out there." 
	"f1000_rtrg2680", --You can bring up the targets' location on your iDroid.
	"f1000_rtrg2690", --You can find its location on your iDroid.//Check his location on your iDroid.
	"f1000_rtrg2700", --You can check the map on your iDroid.
	"f1000_rtrg2710", --・How to view photos "Open the ""Menu"" tab,  then select ""Mission Info.""" "From there you can view targets' photos  or check other visual information." 
	"f1000_rtrg2720", --・Use binoculars to recon "Careful when you fire that thing.  [p] The enemy might hear it." 
	"f1000_rtrg2730", --・Tutorial: Voluntary radio calls Anytime you need advice, just give me a call. 
	"f1000_rtrg2740", --・Marking  ・Tutorial: About marking "That's ""marking."" [p] Focus on a threat, and it'll be marked automatically." "You can mark enemies and vehicles by  zooming in with your binoculars or camera." "Once they're marked, you'll also  see their positions on the map." 
	"f1000_rtrg2745", --・Tutorial: About marking "You can mark enemies and vehicles by  zooming in with your binoculars or camera." "Once they're marked, you'll also  see their positions on the map." 
	"f1000_rtrg2750", --・Markers and sensing presence "Take a good look at the enemy through  your binoculars and you can mark him." "Marked enemies can be sensed when nearby,  even if there's a wall between you and them." "But it only works if you stop and  take the time to focus your attention." "You can also mark enemies by eye,  provided they're close enough." "This helps you maintain situational awareness.  [p] Try it."
	"f1000_rtrg2760", --・After marking targets, look at the map to plan your infiltration route "Take a look at the map on your iDroid and use the positions of marked enemies to help you plan an infiltration route." 
	"f1000_rtrg2770", --・While hanging (when the player tries hanging for the first time from the cliff) "Watch yourself.  [p] If you let go, it's a long way down." Just move carefully when you come back. 
	"f1000_rtrg2780", --・Other instances of hanging "You can move back and forth while hanging.  [p] You can also climb back up or let go and drop.(.. ) [p] Just be sure of your surroundings before you do." 
	"f1000_rtrg2790", --"(First time)Out of ammo?  [p] Take some from an enemy weapon." (Second time)You can restock your ammo from enemy weapons. 
	"f1000_rtrg2800", --"(First time)Out of ammo?  [p] Take some from an enemy weapon." 
	"f1000_rtrg2810", --Prompting use of Support Unit Out of ammo? Let the Support Unit help out if you need to restock. "Transmit a request from your iDroid,  and they'll send supplies right away." 
	"f1000_rtrg2820", --For missions when Miller is not present, or the Support Unit cannot be used "You can take ammunition from  weapons dropped by the enemy." "Of course, that's only if the weapon  category and ammo type match up." "If they don't, consider stealing  the enemy's weapon instead."
	"f1000_rtrg2830", --Prompting the player to call in support (during combat) Snake, you out of ammo? 
	"f1000_rtrg2840", --・Sound of gunfire (First time)CQC(close-quarters combat) is effective for dealing with nearby enemies. 
	"f1000_rtrg2850", --・Outside weapon's effective range You're outside your weapon's effective range. Why don't you try getting a little closer to your target? "To land a shot from outside a weapon's effective range,  you'll need to take bullet drop into account -  [p] gravity's effect on the bullet." 
	"f1000_rtrg2860", --・Tranquilizer round trajectory "Your tranquilizer gun's effective range isn't that great.  [p] The round's trajectory will drop the farther it goes,  [p] so take that into account while aiming." 
	"f1000_rtrg2870", --・About detonating radio-detonated explosives "You've placed some C4.  [p] Get to a safe distance before detonating it." 
	"f1000_rtrg2880", --・About radio-detonated explosives "C4 is an explosive that can be placed  and then detonated remotely." 
	"f1000_rtrg2890", --・About interpretation (Ocelot's excuse) "Understanding a language, and being able to interpret from that language for somebody else, are two different things." "Juggling languages at a rapid-fire pace  is more difficult than you might think." "So... in other words,  [p] while I do speak Russian,  [p] don't expect me to do your interpreting." 
	"f1000_rtrg2900", --・Interpreter soldier joke (fifth interrogation) "I'll let you know if we locate a  soldier with the Interpreter skill." "Extracting him will enable you to  understand what the Soviets are saying." "Otherwise your interrogations are going to be a... [p] ...waste of time." 
	"f1000_rtrg2910", --・Tutorial: Hide enemies you've taken down "Don't leave bodies out in the open.  Find some place to drop them out of sight." 
	"f1000_rtrg2920", --・Prompting caution regarding dangerous animals That area's home to gray wolves. There've been reports of people getting attacked. Be careful whenever you're off the beaten track.
	"f1000_rtrg2930", --・Prompting caution regarding dangerous animals That area's home to side-striped jackals. There've been reports of people getting attacked. Be careful whenever you're off the beaten track.
	"f1000_rtrg2940", --・Prompting caution regarding dangerous animals That area's home to African wild dogs. There've been reports of people getting attacked. Be careful whenever you're off the beaten track.
	"f1000_rtrg2950", --・Prompting caution regarding dangerous animals That area's home to brown bears. There've been reports of people getting attacked. Be careful whenever you're off the beaten track.
	"f1000_rtrg2960", --・Prompting caution regarding dangerous animals That area's home to Eurasian brown bears. There've been reports of people getting attacked. Be careful whenever you're off the beaten track. 
	"f1000_rtrg2970", --・Tutorial: How to call your horse Planning to walk the whole wilderness on foot? Use your horse. 
	"f1000_rtrg2980", --・Tutorial: Night has fallen Sun's down already. "It goes without saying that darkness is good for infiltration." But your vision will be affected just the same. "Keep your guard up, or who knows  when you'll bump into an enemy."
	"f1000_rtrg2990", --・Tutorial: Time cigar "If you need to pass the time, go ahead  and smoke that cigar of yours." Just remember, Miller can't wait forever. 
	"f1000_rtrg3000", --・Tutorial: Gather intel from high ground using binoculars "How about it?  [p] Can you see the village from there?" Use the binoculars to recon the place. 
	"f1000_rtrg3010", --
	"f1000_rtrg3020", --"A parabolic antenna...  [p] There could be intel files of some kind in there."
	"f1000_rtrg3030", --・C-4 explanation "Thinking of using C-4?  [p] It's an explosive that you detonate by  remote control after you've planted it." 
	"f1000_rtrg3040", --・C-4 explanation 2 All right, now get to a safe distance before you set it off. "To detonate it, hold the Ready Button  and then press the Action Button." 
	"f1000_rtrg3050", --Nice find. Analyzing that intel you've picked up. We've got a fix on the target. I've updated your map info. Check it on your iDroid.
	"f1000_rtrg3060", --Boss, that prisoner we rescued provided some intel. We've got a fix on the target. I've updated your map info. Check it on your iDroid. 
	"f1000_rtrg3070", --OK, subject is in. I need you to get back to the mission.
	"f1000_rtrg3080", --All right. "That's the target.  Get him out of there." 
	"f1000_rtrg3085", --・Prompting player to extract target "That's the target.  Get him out of there." 
	"f1000_rtrg3090", --Picked up an intel file, huh? Unfortunately, there's nothing new in it. Boss, get back to the mission.
	"f1000_rtrg3095", --You got an intel file. Unfortunately, there's nothing new in it.
	"f1000_rtrg3100", --Enough already. Give it up.//What are you thinking?!//Boss, stop!
	"f1000_rtrg3110", --Target extraction confirmed. Your objective's complete. Exfiltrate out of the hot zone, by chopper or on land.
	"f1000_rtrg3120", --・Soldier near death died after Fulton extraction  "That soldier you extracted...  He was dead on arrival.  [p] What a waste..." 
	"f1000_rtrg3130", --・Reached safe territory (not in alert phase) That's it - you've made it out of the hot zone. "No sign of the enemy.  [p] Mission complete, Boss." // All right, you're out of the hot zone. "No enemy forces in pursuit.  [p] Mission complete." 
	"f1000_rtrg3140", -- All right, you're out of the hot zone. "No enemy forces in pursuit.  [p] Mission complete." 
	"f1000_rtrg3150", --・Mission failure warning: left the target behind  What about the target? // Put the target on the chopper. 
	"f1000_rtrg3160", --Call the chopper from your iDroid, Boss. Then carry the target to it.
	"f1000_rtrg3170", --Great. I've updated the info on your iDroid. Take a look. I hope he's alright...
	"f1000_rtrg3180", --"What's wrong, Boss?  [p] Mission abort?" 
	"f1000_rtrg3190", --You got an intel file. Unfortunately, there's nothing new in it. "You've completed your objective.  Now get out of the hot zone." 
	"f1000_rtrg3210", --・Eliminate the target Find the target and eliminate him. 
	"f1000_rtrg3220", --・Target killed Target confirmed dead. 
	"f1000_rtrg3230", --・Player attacked the target You'll destroy the target. "That's not acceptable.  You need to Fulton it." 
	"f1000_rtrg3240", --・Target destroyed Target destroyed!// "Target destroyed!  [p] Excellent work. Keep it up." // "Another one down!  [p] Now for the next." 
	"f1000_rtrg3250", --・Can't contact target because enemy is nearby "It's too dangerous to contact the target right now.  [p] Wait till the coast is clear." "(Second time) Contact is a no-go for now.  [p] Pull back, and wait till things die down." "The enemy's looking for you. You should wait before trying to make contact." 
	"f1000_rtrg3260", -- Great. Hurry up and extract the target.
	"f1000_rtrg3270", --・Discovered escaped prisoner "A prisoner!  [p] You gonna help him?" 
	"f1000_rtrg3280", --・Information: Enemy vehicles have started moving  Boss, I have a report from the Intel Team. The targets are now on the move. I've sent their predicted route to your iDroid. Check your map. 
	"f1000_rtrg3290", --・Information: Additional enemy vehicles  "Boss, we have new targets! (ALT: Boss, we have new target!)" Check your iDroid for the details! 
	"f1000_rtrg3300", --・Information: Transport truck  Boss, need a little extra firepower? We've spotted a Soviet weapons transport truck. Apparently its cargo is something pretty powerful. What do you think... should we make 'em share?
	"f1000_rtrg3310", --・Position of hidden enemy vehicles So there were enemy vehicles here too... Boss. Eliminate it.
	"f1000_rtrg3320", --・Position of hidden enemy vehicles  So there were enemy vehicles here too... 
	"f1000_rtrg3330", --・Upon destruction of target vehicle  Target eliminated. Great, now onto the next. 
	"f1000_rtrg3340", --・Upon destruction of target vehicle  Target elimination confirmed. Got any more in you? 
	"f1000_rtrg3350", --・Upon destruction of target vehicle  Target eliminated! // All right, Boss! 
	"f1000_rtrg3360", --・Achieved half of maximum destruction count  Good, you've eliminated half the targets. 
	"f1000_rtrg3370", --・Achieved three quarters of maximum destruction count  Nice work, Boss! The targets are almost history! 
	"f1000_rtrg3380", --・One left to annihilation  Just one target left. Last one, Boss! 
	"f1000_rtrg3390", --Target extraction confirmed. "That's cut down the enemy mechanized unit's force strength."
	"f1000_rtrg3400", --All right, target extracted. Sorry, Reds, it belongs to Diamond Dogs now.
	"f1000_rtrg3410", --・Target vehicle Fulton failure [1]  Fulton extraction of target failed. But it still counts as eliminated. Keep going with the mission. 
	"f1000_rtrg3420", --・Target vehicle Fulton failure [2]  Failed to extract that target you Fultoned. Shame it went to waste, but it won't impact the mission. Boss, pay attention to the success rate when Fultoning. 
	"f1000_rtrg3430", --・Target vehicle has finished moving outside the mission area [1]  A target has left the mission area. It's too late to eliminate that one. Just focus on taking out the remaining targets. 
	"f1000_rtrg3440", --・Target vehicle has finished moving outside the mission area [2]  A target has left the mission area. There's no way to eliminate it now. Head for the remaining targets. 
	"f1000_rtrg3450", --・Target vehicle has finished moving outside the mission area [2]  A target has left the mission area. There's no way to eliminate it now. Head for the remaining targets. 
	"f1000_rtrg3460", --・Prisoner transport vehicle  "Boss, we've spotted a four-wheel drive transporting a prisoner." "It's not part of the mission,  but d'you think you can bust 'em loose?" Just if you have the time to spare. 
	"f1000_rtrg3470", --・Highly skilled prisoner being transported  Looks like a prisoner escort. I guess this is no time to be worrying about it... 
	"f1000_rtrg3480", --・Eliminate the target (vehicle)  That's a target. Eliminate it. 
	"f1000_rtrg3490", --・Eliminate the target (vehicle)  That's a target. Eliminate it any way you'd like. 
	"f1000_rtrg3500", --・Target: Armored vehicle (rocket launcher) [1]  That target... It's equipped with an MLRS. 
	"f1000_rtrg3510", --・Target: Vehicle (heavily armed/armored)  That's a target... but it's heavily armed. Be careful. One hit from that'll bury you. 
	"f1000_rtrg3520", --・Target: Armored vehicle (rocket launcher) [2]  Look at that target... It's fitted with an MLRS. You take that out, there's a bonus in it for us. 
	"f1000_rtrg3530", --・Target: Tank [1]  A tank... that's a target too. Just don't overstretch yourself. Tanks aren't something you just take on alone. 
	"f1000_rtrg3540", --・Target: Tank [2]  A Soviet tank... That's a target too, but can you really eliminate it? 
	"f1000_rtrg3545", --A Soviet tank... "(Sixth time)If you could steal that, [p] nothing could stop you... [p] But make a wrong move [p] and it'll chew you up."
	"f1000_rtrg3550", --・Can't contact target because enemy is nearby "It's too dangerous to contact the target right now.  [p] Wait till the coast is clear."//"(Second time) Contact is a no-go for now.  [p] Pull back, and wait till things die down."//"The enemy's looking for you. You should wait before trying to make contact."
	"f1000_rtrg3560", --・Put the target on the chopper Put the target on the chopper. 
	"f1000_rtrg3570", --(Hm? )Is that...? // Hey, that's...! (talking about an object) // Is that it?InIntelHouse
	
	"f1000_rtrg3580", --・Reaction to boss behavior: attacked from behind  What?! When did...?! Boss, don't hang around the same spot forever. 
	"f1000_rtrg3590", --・Reaction to boss behavior: breakable object damage  Nice. // Great work! // (satisfied) Oh yeah. // That's the Big Boss I know. 
	"f1000_rtrg3600", --・Reaction to boss behavior: hold-up  Impressive, Boss. She never stood a chance. 
	"f1000_rtrg3610", --・Boss battle advice: tip for long-range sharpshooting  "When firing from long range,  you need to calculate bullet drop." "A shot that travels further than your weapon's  effective range will land lower than the crosshair."
	"f1000_rtrg3620", --・Boss battle advice: don't get into a head-on shoot-out  "Boss, you need to go around outside the enemy's line of sight." "Get into position undetected, and attack from behind or the side."
	"f1000_rtrg3630", --・Boss battle advice: move quietly  Be careful when you move. "A sniper keeps everything in mind. Terrain, weather, everything about his sniping position..." That's the enemy's turf. If you draw attention to yourself, you WILL be spotted.

	"f1000_rtrg3640", --・Shot bounced off, but it knocked off the helmet with it  Your shot bounced off?! But at least it took that helmet with it. 
	"f1000_rtrg3650", --・Shot bounced off, but helmet & armor are still in place  It's no good, Boss. Attacking like that won't cut it. Aim somewhere else. Or, change to a different weapon. 

	"f1000_rtrg3660", --・Unable to Auto-Assign staff (reached max. staff assignment limits)  Boss, the base can't support more staff. We can't assign additional personnel to any of the teams. 
	"f1000_rtrg3670", --・If more platforms can be constructed  We'll have to build more platforms. 
	"f1000_rtrg3680", --・If FOBs can be constructed  We'll have to build an FOB. 
	"f1000_rtrg3690", --・If neither extra platforms nor FOBs can be built (all already constructed)  "If we can't even fit them into the waiting room,  we'll just have to fire them,  but I'd rather you made the decision." "If there are unnecessary staff clogging up the works, it's time to let them go."

	"f1000_rtrg3700", --・Direct contracts  "If there are staff you really don't want to lose, have them sign a direct contract." "Management of those staff will be entirely under your control."
	"f1000_rtrg3710", --・Unable to Auto-Assign staff (same best-choice stats)  Boss, about Diamond Dogs' human resources... "We're having trouble assigning staff whose skills would suit more than one team." I'd like you to judge where to assign them. "I've left them in the waiting room,  so just send your instructions from your iDroid."
	"f1000_rtrg3720", --・Unable to Fulton recover (vehicle/weapon emplacement/materials container)  Boss, we can't store anything else on the base. 
	"f1000_rtrg3730", --・If neither extra platforms nor FOBs can be built (all already constructed)  You'll have to sell something off before Fultoning that. 

	"f1000_rtrg3740", --・Identifying the interpreter  "That guy with the green hat is speaking English...  he's a language specialist." "If you extract him and convince him to join, we might be able to provide Russian interpretation support."

	"f1000_rtrg3750", --・Prompting player to look at face (may not be the target)  Is that him? (male) Look carefully at his face. 
	"f1000_rtrg3760", --・Prompting player to look at face (may not be the target) (female version)  Is that her? (female) Look carefully at her face. 

	"f1000_rtrg3770", --・Deleted target's predicted field of movement  I've taken the target's predicted FOM off your map. That data is no longer accurate. 
	"f1000_rtrg3780", --・Enemy chopper arrives (nervous) That's an enemy gunship. A single burst from its machine gun could cut a man in half. Tread carefully, Boss. 
	"f1000_rtrg3781", --・How to take out a bonus target That's an enemy gunship. Don't try to take down a gunship from the front. You won't win in a head-to-head shootout. Try to get behind it and take it down with missiles. 
	"f1000_rtrg3790", --・Information: Enemy vehicles have started moving  Boss, I have a report from the Intel Team. The targets are now on the move. I've sent their predicted route to your iDroid. Check your map.
	"f1000_rtrg3800", --・Information: Additional enemy vehicles  "Boss, we have new targets! (ALT: Boss, we have new target!)" Check your iDroid for the details! 
	"f1000_rtrg3810", --・Information: Transport truck  Boss, need a little extra firepower? We've spotted a Soviet weapons transport truck. Apparently its cargo is something pretty powerful. What do you think... should we make 'em share?
	"f1000_rtrg3820", --・Position of hidden enemy vehicles  So there were enemy vehicles here too... 

	"f1000_rtrg3830", --・Upon destruction of target vehicle  Target eliminated. Great, now onto the next. 
	"f1000_rtrg3840", --・Upon destruction of target vehicle  Target elimination confirmed. Got any more in you? 
	"f1000_rtrg3850", --・Upon destruction of target vehicle  Target eliminated! All right, Boss! 
	"f1000_rtrg3860", --・Achieved half of maximum destruction count  Good, you've eliminated half the targets. 
	"f1000_rtrg3870", --・Achieved three quarters of maximum destruction count  Nice work, Boss! The targets are almost history! 
	"f1000_rtrg3880", --・One left to annihilation  Just one target left. Last one, Boss! 
	"f1000_rtrg3890", --・Successfully Fultoned target vehicle  "That's cut down the enemy mechanized unit's force strength." 
	"f1000_rtrg3900", --・Successfully Fultoned target vehicle  Sorry, Reds, it belongs to Diamond Dogs now. 
	"f1000_rtrg3910", --・Target vehicle Fulton failure [1]  Fulton extraction of target failed. But it still counts as eliminated. Keep going with the mission. 
	"f1000_rtrg3920", --・Target vehicle Fulton failure [2]  Failed to extract that target you Fultoned. Shame it went to waste, but it won't impact the mission. Boss, pay attention to the success rate when Fultoning.
	"f1000_rtrg3930", --・Target vehicle has finished moving outside the mission area [1]  A target has left the mission area. It's too late to eliminate that one. Just focus on taking out the remaining targets.
	"f1000_rtrg3940", --・Target vehicle has finished moving outside the mission area [2]  A target has left the mission area. There's no way to eliminate it now. Head for the remaining targets.

	"f1000_rtrg3950", --・Prisoner transport vehicle  "Boss, we've spotted a four-wheel drive transporting a prisoner." "It's not part of the mission,  but d'you think you can bust 'em loose?" Just if you have the time to spare. 
	"f1000_rtrg3960", --・Highly skilled prisoner being transported  Looks like a prisoner escort. I guess this is no time to be worrying about it... 

	"f1000_rtrg3970", --・Eliminate the target (vehicle)  That's a target. Eliminate it. // That's a target. Eliminate it any way you'd like. 
	"f1000_rtrg3980", --・Target: Vehicle (heavily armed/armored)  That's a target... but it's heavily armed. Be careful. One hit from that'll bury you. 
	"f1000_rtrg3990", --・Target: Armored vehicle (rocket launcher) [1]  That target... It's equipped with an MLRS. 
	"f1000_rtrg4000", --・Target: Armored vehicle (rocket launcher) [2]  Look at that target... It's fitted with an MLRS. You take that out, there's a bonus in it for us. 
	"f1000_rtrg4010", --・Target: Tank [1]  A tank... that's a target too. Just don't overstretch yourself. Tanks aren't something you just take on alone. 
	"f1000_rtrg4020", --・Target: Tank [2]  A Soviet tank... That's a target too, but can you really eliminate it? 

	"f1000_rtrg4030", --・SIDE OPS (Quests) explanation  "The SIDE OPS LIST is comprised of problems we need you to  resolve, objectives to be completed, and information  gained from the soldiers and prisoners you've extracted." "These aren't missions per se, but if you can take care of  them when you're free, I'd appreciate it." 
	"f1000_rtrg4040", --・Gained SIDE OPS (Quest) information (Rescue the Intel Team Member)  Boss, one of our staff has been captured by the enemy. He won't last long on his own. I've added the details to your SIDE OPS LIST. Get our man out of there, Boss.
	"f1000_rtrg4050", --・The Intel Team member needing rescue in SIDE OPS (Quest) is KIA  "Boss, I've got some bad news. We've just confirmed that our manbeing held captive by the enemy is dead." I'll... I'll remove the operation from the SIDE OPS LIST.
	"f1000_rtrg4060", --・Gained SIDE OPS (Quest) information  "Boss, about that development you ordered...  there's something I'd like you to take care of if you can." I've put the details on your SIDE OPS LIST. Take a look if you're interested. 
	"f1000_rtrg4080", --・About key items (development materials)  That material... "It could be just what we need to develop new weapons and equipment." 
	"f1000_rtrg4090", --・Medicinal plants (prompting extraction)  "We can use compounds from plants to make medicine  or poison for use in new weapons and equipment." "Take a look at the PLANTS LIST on your iDroid to see which ones we need." "Then go find them if you get the chance. It'll keep the staff happy too." 

	"f1000_rtrg4100", --・Enemy soldier: former Mother Base soldier (after he salutes Boss - odd-numbered times)One of the guys out on a mission at the time... "He's fallen a long way from the glory days...  But... will he come back to us? " 
	"f1000_rtrg4101", --・Enemy soldier: former Mother Base soldier (after he salutes Boss - odd-numbered times) One of the guys out on a mission at the time... "He's fallen a long way from the glory days...  But... will he come back to us? "Bring 'em home, Boss!   
	"f1000_rtrg4110", --・Enemy soldier: former Mother Base soldier (after he salutes Boss - odd-numbered times) Is that... one of our men from nine years ago...? Bring 'em home, Boss! 
	"f1000_rtrg4111", --・Enemy soldier: former Mother Base soldier (after he salutes Boss - even-numbered times) "I remember him... he was off base during the attack nine years ago." Bring 'em home, Boss! 
	"f1000_rtrg4120", --・Skulls (common): Your attacks are damaging them  Damn it! They're still coming! But that looked like it worked. Stay on the offensive. 
	"f1000_rtrg4130", --・Skulls (Mist): When the mist gets thick  Where are they...? Use your ears. Try to sense their positions. 
	"f1000_rtrg4140", --・Skulls (common): Before combo attack  What are they up to? Watch it, Boss! 
	"f1000_rtrg4150", --・Skulls (common): Before combo attack  Here they come! 
	"f1000_rtrg4155", --・Noticing the player has started carrying someone who is already dead Boss... the person you're carrying is already dead...
	"f1000_rtrg4160", --・If player tries to call in Quiet during her disappearance  No can do. Quiet's gone missing, and hasn't come back yet. "Check the predicted FOM we've worked out and marked on your map." Take a look once you're free and not on a mission. 
	"f1000_rtrg4170", --・If player tries to call in Quiet after she has gone for good  Quiet's gone for good, Boss. Just... try to let it go. 
	"f1000_rtrg4180", --・General-purpose: Caution - "Destroy it!"  Destroy that thing. (singular)
	"f1000_rtrg4190", --・General-purpose: Caution - "Destroy it!"  Destroy them all. (plural)
	"f1000_rtrg4200", --・General-purpose: Caution - "Eliminate it!"  Eliminate that man. (no female targets, so male only is OK)
	"f1000_rtrg4210", --・General-purpose: Caution - "Eliminate it!"  Eliminate that thing.
	"f1000_rtrg4220", --・General-purpose: Caution - "Eliminate it!"  Eliminate them. (plural) 
	"f1000_rtrg4230", --・General-purpose: Caution - "Help him!"  You need to help him. 
	"f1000_rtrg4240", --・General-purpose: Caution - "Help him!"  You need to help her.
	"f1000_rtrg4250", --・General-purpose: Caution - "Help him!"  You need to help them.
	"f1000_rtrg4260", --・General-purpose: Caution - "Rescue him!"  Get him outta there.
	"f1000_rtrg4270", --・General-purpose: Caution - "Rescue him!"  Get her outta there.
	"f1000_rtrg4280", --・General-purpose: Caution - "Rescue him!"  Get them outta there. 
	"f1000_rtrg4290", --・General-purpose: Caution - "Don't just leave him!" You just gonna leave him there? 
	"f1000_rtrg4300", --・General-purpose: Caution - "Don't just leave him!" You just gonna leave her there? 
	"f1000_rtrg4310", --・General-purpose: Caution - "Don't just leave him!" You just gonna leave them there? 
	"f1000_rtrg4320", --・General-purpose: Caution - "Deal with it!"  You've got to deal with it somehow! 
	"f1000_rtrg4330", --・General-purpose: Caution - "Not now"  You can't do that right now. (Specifically Snake cannot do it) 
	"f1000_rtrg4340", --・General-purpose: Caution - "Not now" Sorry Boss, we can't right now. (Specifically Mother Base is unable to provide support, etc.) 
	"f1000_rtrg4345", --The guards are on edge... You can't do that right now. (Specifically Snake cannot do it)
	"f1000_rtrg4350", --・General-purpose: Normal - "Unable to provide support" (due to location)  That location won't work. (You can't select that location) Choose somewhere else. 
	"f1000_rtrg4360", --・When calling in Quiet "Hm? [p] Boss, hold it. [p] That's..." "Quiet...?! [p] Don't say I didn't warn you." "Roger that. [p] Sending her now." 
	"f1000_rtrg4370", --・Interpreter location (Pashto)  "There are reports of a Pashto/English interpreter operating in that area."  If you extract him, he could be plenty useful for us. ・Prompting extraction of interpreter  If you extract him, he could be plenty useful for us.   
	"f1000_rtrg4380", --・Interpreter location (Afrikaans)  "We've heard there's an Afrikaans/English interpreter operating somewhere in that area." ・Prompting extraction of interpreter  If you extract him, he could be plenty useful for us.  
	"f1000_rtrg4390", --・Interpreter location (Kikongo)  "There should be a Kikongo/English interpreter somewhere in that area."  ・Prompting extraction of interpreter  If you extract him, he could be plenty useful for us. 
	"f1000_rtrg4400", --・If player tries to call in Quiet during her disappearance  No can do. Quiet's gone missing, and hasn't come back yet. "Check the predicted FOM we've worked out and marked on your map." Take a look once you're free and not on a mission. 
	"f1000_rtrg4410", --・If player tries to call in Quiet after she has gone for good  Quiet's gone for good, Boss. Just... try to let it go. 
	"f1000_rtrg4420", --・Cannot extract the Skulls "Boss, we can't extract them.  We don't know who or what they are." We'd be putting Mother Base at risk. 
	"f1000_rtrg4430", --・Those guys are talking about something. "If we add a directional microphone feature to your binoculars, you'll be able to listen in on sounds from a distance." "Send the development order from your iDroid if you need it." //"They're talking about something,  but they're too far away to hear." "We really need to get a directional  mic built into your binoculars." "Check your iDroid to see whether  the R&D Unit can develop that." 
	"f1000_rtrg4440", --・If player tries to select Quiet as a buddy after the MB cutscene "p51_010310: Quiet wins over the kids" but before she becomes available again  "No, Quiet's still in sickbay after that salt water did a number on her skin. Pick a different buddy." 
	"f1000_rtrg4450", --・Alert phase changed to evasion phase Looks like the enemy's lost sight of you. They're gonna try to hunt you down. 
	"f1000_rtrg4460", --・Evasion phase changed to caution phase The enemy's given up their search for you. But they're not giving the all clear just yet. Stay alert. 
	"f1000_rtrg4470", --・Standing in front of a cliff crack That crack would make a great foothold. You can use crack climbing to make your way up. 
	"f1000_rtrg4480", --・Tutorial: Time cigar "If you need to pass the time, go ahead  and smoke that cigar of yours." 
	"f1000_rtrg4490", --Prompting use of Support Unit Out of ammo? Let the Support Unit help out if you need to restock. "Transmit a request from your iDroid,  and they'll send supplies right away." 
	"f1000_rtrg4500", --・Dumpster explanation A dumpster... Looks big enough to hide somebody. "You could stash a downed enemy  in there or hide in it yourself. Just...  [p] don't stand too close to me afterward." 
	"f1000_rtrg4510", --・Toilet  A portable toilet. "If you're going to hide inside,  watch the enemy doesn't decide to use it." Same goes for hiding downed enemies in it. 
	"f1000_rtrg4520", --・If the enemy soldiers are speaking Afrikaans  Afrikaans is the lingua franca for mercs in that area. "If you're going to get any information from  interrogations, you'll need an interpreter." 
	"f1000_rtrg4530", --・Power system  "Either destroy that or turn it off to shut off  all the lights and surveillance cameras in the outpost." But of course, the enemy will realize something's up. If you're gonna do it, be quick. 
	"f1000_rtrg4540", --・Supply drop: vehicles  You captured an enemy vehicle. "Just like weapons and items, you can use your iDroid to have vehicles you've extracted airdropped in." "You can also let members of the Combat Unit use them on DISPATCH MISSIONS."
	"f1000_rtrg4550", --・Prompting player to develop the sonar (lifeform detector)  "Our bionic arm developer has submitted a proposal for a new feature." "An active sonar that can detect the positions of soldiers, prisoners, and animals." To start development, give the order from your iDroid. 
	"f1000_rtrg4560", --・Requesting buddy deployment  I know you're an expert when it comes to solo infiltrations. But now you have buddies who'll fight alongside you. Use your iDroid to deploy them whenever you like. 
	"f1000_rtrg4570", --・Giving orders to buddies  "The role of your buddies is to support you during missions, but there's more than one way for them to do that." "To get the most out of a buddy's abilities, you need to give the right order for the situation." 
	"f1000_rtrg4580", --・Buddies: DD tutorial  Like your horse, you can give commands to D-Dog as well. "He'll normally follow you around, but you  can also make him wait somewhere,  or lure an enemy by barking at him." Or you can sic him on the enemy to slow them down. "Develop new gear just for him and I'm sure  he'll be capable of even more damage." 
	"f1000_rtrg4590", --・Buddies: Quiet tutorial  "Being a scout sniper, there are two tasks you can give Quiet." "The first, is to infiltrate an outpost ahead of  you and scout out the enemy's positions." "The second, is to send her to a sniping position  and have her cover your infiltration." "The kind of sniper support she'll provide  will depend on the weapon you give her." "Of course, this is all assuming she's willing to follow orders." 	
	"f1000_rtrg4600", -- ・Surveillance camera "It's a surveillance camera.  [p] Don't get spotted." 
	"f1000_rtrg4610", -- ・Gun camera  A gun camera. If it spots you, it'll give you a lead hello. 
	"f1000_rtrg4620", -- ・UAV  An enemy UAV... You gonna to shoot it down before it sees you? 
	"f1000_rtrg4630", -- ・Intel radio: Climbing pipes "The pipes, huh? They're strong enough.  [p] Could make for a nice shortcut." 
	"f1000_rtrg5010", -- ・Golden crescent - acquired it, or made intel support call  Golden crescent... It's a type of medicinal plant. We can use that to make tranquilizer rounds more potent. 
	"f1000_rtrg5011", -- ・Haoma - acquired it, or made intel support call  That's a medicinal plant called haoma. "Otherwise known as soma, people use it  to make a sacred drink for religious ceremonies." 
	"f1000_rtrg5012", -- ・African peach - acquired it, or made intel support call  That's African peach. "The shape of its petals gives it the nickname ""the pincushion."" It's used in local traditional medicine as a pain reliever and tranquilizer."
	"f1000_rtrg5013", -- ・Digitalis - acquired it, or made intel support call "That's digitalis. It's toxic, but it can also be used as medicine."
	"f1000_rtrg5014", -- ・Wormwood - acquired it, or made intel support call The wormwood. Also known as absinthium. That's used to make your Phantom Cigars.
	"f1000_rtrg5015", -- ・Tarragon - acquired it, or made intel support call That's tarragon, a type of medicinal plant. "It contains trace amounts of a benzodiazepine derivative that's the active ingredient in pentazemin." 
	"f1000_rtrg5016", -- ・Black carrot - acquired it, or made intel support call "Black carrot. It's something of an ancestor to the domestic carrot." It's also a favorite of wild animals.
	"f1000_rtrg5020", -- Boss, get down! The enemy sniper. Stay low and crawl along the ground. That should enable you to sneak past enemies.
	"f1000_rtrg5021", -- Boss, get down! (nervous) That's an enemy gunship. Stay low and crawl along the ground. That should enable you to sneak past enemies.
	"f1000_rtrg5030", --・The tape broke Hm? Looks like the tape broke. It won't play any more.
	"f1000_rtrg5040", --・If the puppy shows up again after the rain stops "That wild dog pup... [p] He's a tough little guy." Boss, this is no time to be playing with animals. What are you gonna do, Boss? (Wants Snake to Fulton extract it, but is too embarrassed to say so himself)
	"f1000_rtrg5050", --・Once player extracts the puppy (happy) Roger that, we'll pick him up!
	"f1000_rtrg5060", -- Damaged puppy - Boss, stop! // What's gotten into you?
	"f1000_rtrg5070", -- Killed puppy - Don't even...! That's not funny.//What are you thinking?!
	"f1000_rtrg5080", -- Huhh? Not good. "There's a risk the Fulton extraction  will be spotted by nearby enemies." "Either secure the area beforehand,  or carry him somewhere out of sight first." 
	"f1000_rtrg5090", --・If player solved a problem in a way Miller hadn't imagined Ohhh! Now that's some lateral thinking! 
	"f1000_rtrg5100", --・After extracting the legendary gunsmith's apprentice A (Africa) Boss, that man you picked up in Bwala ya Masa is a top-notch gunsmith. We've got plenty of work for him. "But it turns out that he's just the apprentice of a so-called ""legendary gunsmith.""" Now, if this "legendary gunsmith" is all he's cracked up to be, we could really use him on our side. "The apprentice gave us the whereabouts of his master. If you've got the time, go and grab him." I've added the details to your SIDE OPS list. 
	"f1000_rtrg5110", --・After extracting the legendary gunsmith's apprentice B (Afghanistan) "Boss, about the prisoner you extracted from the Central Base Camp." "It seems that he's not the ""legendary gunsmith"" either.  Just another one of his apprentices." Now I'm really dying to meet this guy... "We got intel on his location from the apprentice. Think you can recover him?" I've added the details to your SIDE OPS list. 
	"f1000_rtrg5120", --・Explaining the analyzer "Boss, as requested, we've added an analyzer function to your binoculars." Now you can view soldiers or POWs and get a read-out on their rank or any special skills they might have. Depending on their skills, they may even be able to develop new types of weapons or items. "Try it out the next time you're  thinking of Fultoning someone." 
	"f1000_rtrg5130", --・ When the buddy is incapable of fighting and is automatically collected Not good. "Don't let your buddy die, Snake. I'm pulling them outta there!" 
	"f1000_rtrg5140", -- Great job. All right, we'll bring him out.
	"f1000_rtrg7010", --"You've completed your objective. Now get out of the hot zone."
	"f1000_rtrg8010", --・Mission complete Mission complete. "You're clear of the hot zone.  [p] Mission complete." 
	"f1000_rtrg8020", --・Target (person/object) extracted, mission complete "Mission complete...  [p] and the target's safe." 
	"f1000_rtrg8030", --・Reached safe territory (not in alert phase) That's it - you've made it out of the hot zone. "No sign of the enemy. [p] Mission complete, Boss."//All right, you're out of the hot zone. "No enemy forces in pursuit. [p] Mission complete."
	"f1000_rtrg8040", --・Reached safe territory (alert phase) "We can't let them follow you. Throw off the enemies on your tail first."
	"f1000_rtrg8050", --・Dealt with the enemy combat alert while in safe territory "All right, the coast is clear. [p] Mission complete."
	"f1000_rtrg8060", --・Returned from safe territory into the hot zone "What? [p] You're going back?"
	"f1000_rtrg9010", --・Mission complete (poor performance) "Mission complete... [p] That was rough. [p] Thanks for getting us through it. (Half directed at the player)" "Mission complete. (Somewhat introspective) [p] I know we can do better next time."
	"f1000_rtrg9011", --・Mission complete (good performance) "Mission complete... [p] Boss."
	"f1000_rtrg9020", --・Mission complete (average performance) "Mission complete. [p] I guess it all worked out in the end." "Mission complete. [p] Phew, at least you made it out in one piece."
	"f1000_rtrg9030", --・Mission complete (good performance) "Mission complete. [p] Great work." "Mission complete... [p] Boss."
	"f1000_rtrg9040", --・Mission complete (very good performance) "Yes! Mission complete. Boss, that was exceptional."//"All right, mission complete, Boss.(jokingly) [p] Maybe you'll actually break a sweat next time, huh?"
	"f1000_rtrg9050", --・Mission complete (outstanding performance) "Amazing. Mission complete. [p] That right there is why you're the best, Boss. [p] The one and only."//"Mission complete - and how. [p] They're gonna tell stories about this one, Boss."
	-- Intel radio
	"f2000_esrg0010", --・Moon
	"f2000_esrg0020", --・Full moon
	"f2000_esrg0030", --・Southern Cross
	"f2000_esrg0040", --・Big Dipper
	"f2000_esrg0050", --・Sun
	-- ●Outgoing calls
	"f2000_oprg0010", --When you want to begin a mission, open your &#xD;&#xA;iDroid and select it from the Mission List. I've sent a list of selectable missions to your iDroid. They're all jobs that only you can handle.
	"f2000_oprg0020", --・Prompting player to extract soldiers Said as though speaking firmly to himself "I don't care how you do it, but you've got to get us more manpower." "If we're gonna get back at those bastards, our organization has to grow."
	"f2000_oprg0030", --・Prompting player to develop equipment "You can give the order to develop new weapons and items from your iDroid." There's no substitute for having the right equipment.
	"f2000_oprg0065", --・Goats/sheep are nearby "(sheep)There are sheep around; with the local residents gone, they've gone back to the wild."
	"f2000_oprg0075", --・Animals (dogs) in the area There are wolves in that area. They've been known to go after people... so watch yourself.
	"f2000_oprg0105", --・Prompting player to extract prisoners (adults) "There are engineers and doctors among the prisoners the Soviets have taken." "You rescue them, they might return the favor by working for us."
	"f2000_oprg0115", --・Prompting player to neutralize enemies "Destroying equipment at enemy outposts should help future missions go more smoothly." "Their security is light at the moment - this may be your best chance."
	"f2000_oprg0125", --・Prompting player to destroy fixed weapon emplacements "Gun emplacements and mortars can turn a firefight into a nightmare." "Taking the time to destroy them now should make missions less work for you later on."
	"f2000_oprg0130", --・Prompting player to destroy vehicles Destroying their vehicles will slow the enemy down. But, you could also steal them for yourself.
	"f2000_oprg0155", --・Prompting player to destroy power system (1) "Taking out the power system now will limit the enemy's activities at night."
	"f2000_oprg0165", --・Prompting player to destroy power system (2) "Destroying the power system will shut down the local electrical grid." That'll give you a leg up when operating in the dark.
	"f2000_oprg0175", --・Prompting player to destroy communications equipment "You can disrupt communications between enemy outposts by destroying comms equipment." That'll prevent one post from sending reinforcements to another.
	"f2000_oprg0185", --・Sandstorms "Sandstorms reduce your visibility, but the same goes for the enemy." How you take advantage of that situation is up to you.
	"f2000_oprg0190", --・Advantage of night-vision goggles "Don't forget about night vision goggles. [p] They'll give you ample visibility no matter how dark it gets." "(if they haven't been developed)If you want to develop them, give the order from your iDroid."
	"f2000_oprg0200", --・If the player can't develop the night-vision goggles Having trouble seeing in the dark? "If you want to wait till dawn, [p] you could always pass the time with a smoke."
	"f2000_oprg0210", --・Recommending Fulton extractions "If you neutralize an enemy without killing him, you can then Fulton extract him." "Once we've extracted a soldier, we should be able to convince him to join us."
	"f2000_oprg0220", --・Deployment request: D-Horse Use your horse for traveling long distances. Let us know from your iDroid and we can send him to you.
	"f2000_oprg0230", --All mission-relevant data is aggregated in the ACC. That's where you can accept missions and change your equipment. When you're in the area of operations,  the Support Unit will pass on information to you and handle your ammo resupplies. / When you want to begin a mission, open your &#xD;&#xA;iDroid and select it from the mission list. I've sent a list of selectable missions to your iDroid. They're all jobs that only you can handle.
	"f2000_oprg0240", --・Outgoing calls while on Mother Base "Miller doesn't plan to return to the field. Says he's going to stay here and focus on running things as XO." No surprise, with his body in that state. "But apparently he has no intention of wearing a prosthetic arm or leg." So he doesn't forget the pain, he says.
	"f2000_oprg0250", --・Outgoing calls while on Mother Base "My roles here include training our soldiers and supporting you during missions." "Since I'm still technically working for the GRU as well, I can't accompany you in the field." Don't take it personally.
	"f2000_oprg0260", --・Outgoing calls while on Mother Base The puppy's training is going well. "There'll come a day when he'll be able to join you on missions." But you know, he uh... he gets lonely easily. You should come visit him every once in a while.
	"f2000_oprg0270", --・Outgoing calls while on Mother Base Quiet's being held in a cell on the Medical Platform. She's slipped out on more than one occasion, but... "She always comes back on her own... maybe out of loyalty to you."
	"f2000_oprg0280", --・Outgoing calls while on Mother Base "Emmerich is developing a Walker Gear for you and is supporting the R&D Team from confinement." "We're continuing to monitor him to make sure he doesn’t try anything."
	"f2000_oprg0290", --・Outgoing calls while on Mother Base Eli is a real handful. We just can't get him to trust adults. I only hope he doesn't cause any serious trouble. (foreshadowing the Sahelanthropus theft)
	"f2000_oprg0300", --・Outgoing calls while on Mother Base We're having Code Talker continue his parasite research. He's clearly very grateful to you. I'm sure he'll return the favor somehow.
	"f2000_oprg0310", --・Outgoing calls while on Mother Base "You can deploy a buddy from the ACC (Aerial Command Center) before a mission, or from your iDroid." "Think carefully about the mission's objectives before deciding who you'd better take along. " "If you develop specialized equipment for them, they'll be able to help you out in even more situations."
	"f2000_oprg0500", --Select the mission as soon as you're prepared. We're ready when you are. / Boss, you can't solve our current problem here. Select the mission.
	"f2000_oprg1020", --"By connecting your iDroid to the on-board computer, you turn the chopper into your own Aerial Command Center, or ACC."
	"f2000_oprg1030", --"Some elements of staff assignment and R&D of weapons and items can only be performed from there."

	-- ●Real-time calls
	"f2000_rtrg0010", --・About free play "When you're not on a mission, use that free time wisely - surveying enemy outposts for example, or gathering manpower and resources." "Of course, even you need some downtime every now and then." "Whatever you do, it's all another step on the road to our goal."
	"f2000_rtrg0025", --・Interrogated enemy, but he doesn't know English Boss, it seems that guy doesn't understand English. ・Prompting player to extract an interpreter "If you place someone with the Interpreter skill in the Support Unit, that'll enable us to do simultaneous interpretation."
	"f2000_rtrg0035", --・Interrogated enemy, but he doesn't know English Boss, it seems that guy doesn't understand English. ・If there is no soldier with the Interpreter skill around "If you want to interrogate the enemy, you'll need to find someone with the Interpreter skill first."
	"f2000_rtrg0040", --・Once the Fulton Action Button icon appears "Attach the Fulton Recovery device to him. [p] The chopper will then pick him up." "A Fulton extraction's success rate depends on factors like the individual's health and the weather."
	"f2000_rtrg0050", --・Fulton extraction failed - enemy fell to his death (following "Once the Fulton Action Button icon appears") (tone of voice suggesting the fall looked painful)Ahhh... it looks like that fall killed him.
	"f2000_rtrg0060", --・Player tries to Fulton extract a soldier near death "If he's on the brink of death, it's hard to say whether he'll survive a Fulton extraction." "If you have to extract someone who's on the verge of death, you'd better use the chopper." "But if you're going to carry them, put 'em to sleep first. [p] You won't get far if you have to fight them every step."
	"f2000_rtrg0070", --・Soldier near death died after Fulton extraction "That soldier you extracted... He was dead on arrival. [p] What a waste..."
	"f2000_rtrg0080", --・Children can't be Fulton extracted "Fulton extraction puts a huge strain on the body - too much for a child." To extract kids, you'll have to carry them to the chopper.
	"f2000_rtrg0090", --・Can't hear enemy CP radio chatter clearly We can't intercept enemy comms if they're too far away. "On the other hand, being out of radio range means you're relatively safe."
	"f2000_rtrg0100", --_miller And Boss, we found the bodies of the two missing Intel Team members in Lufwa Valley. We knew we wouldn't get them back alive, but still... it's a damn shame. They won't be forgotten, though. Skull Face WILL pay for this.
	"f2000_rtrg0110", --_miller Thanks to Code Talker, we've managed to put a stop to any new vocal cord parasite infections. We couldn't save those already symptomatic, but everyone who survived has been released from the Quarantine Platform. I know you were faced with some tough decisions on this one. Sorry, Boss. But thank you.
	"f2000_rtrg0120", --_miller Boss, our Intel Team agents that the enemy captured have just been killed. 6B D3 68 FF It's them you were supposed to save in that rescue mission I mentioned. 40 3F 70 6F Damn it, why didn't you... DD 2C 6E 8B I'll remove it from the Mission List. 32 99 75 FB The Intel Team works right in there with the enemy. AF 8A 72 77 There's no telling when another man will get exposed and captured. 24 29 7A 07 When that happens, they depend on you. 01 E4 77 03 Don't forget about them, Boss. 66 77 57 F3",
	"f2000_rtrg0130", --_miller Boss, our Intel Team agent that the enemy captured has just been killed. 6A D3 68 FF It's him you were supposed to save in that rescue mission I mentioned. 41 3F 70 6F Damn it, why didn't you... DD 2C 6E 8B I'll remove it from the Mission List. 32 99 75 FB The Intel Team works right in there with the enemy. AF 8A 72 77 There's no telling when another man will get exposed and captured. 24 29 7A 07 When that happens, they depend on you. 01 E4 77 03 Don't forget about them, Boss. 66 77 57 F3",
	"f2000_rtrg1000", --_ocelot Be sure to check your weapons and equipment before deploying on a mission. You should choose your gear wisely to match the objective. If you feel your equipment's not up to scratch, cancel the mission and see what the R&D Team can develop for you.
	"f2000_rtrg1010", --・Helicopter cabin explanation "By connecting your iDroid to the on-board computer, you turn the chopper into your own Aerial Command Center, or ACC." "Some elements of staff assignment and R&D of weapons and items can only be performed from there." Take as long as you need to consider all your options.
	"f2000_rtrg1030", --・FOB resistance mission available Boss, we've got intruders on our FOB. "The Security Team is holding them off, but I'd feel better if you joined the fight." Come and support the counterattack if you can.
	"f2000_rtrg1040", --・FOB resistance mission available Boss, we've received a backup request from one of our supporters whose FOB is under fire. Should we help?
	"f2000_rtrg1050", --・Player ignored FOB resistance mission (defense successful) Boss, the Security Team successfully defended the FOB! See "FOB MISSIONS" on your iDroid for the full report.
	"f2000_rtrg1060", --・Player ignored FOB resistance mission (enemy defeated) Boss, the Security Team defeated the intruders on our FOB!
	"f2000_rtrg1070", --・Player ignored FOB resistance mission (defense failed) I'm sorry Boss, we failed to defend the FOB. You can see the details in "FOB MISSIONS" on your iDroid.
	"f2000_rtrg1080", --・Mother Base is now in the red Boss, our GMP is now in the red. "If it stays this way, staff morale will fall, and the men will start leaving Diamond Dogs." You've got to bring in more funds and keep costs down.
	"f2000_rtrg1240", --・Fulton extraction in bad weather failed I'm sorry, Boss, but the extraction failed. The Support Unit just isn't skilled enough. "If you want to increase the success rate of Fulton extractions in bad weather, you need to improve the Support Unit."
	"f2000_rtrg1300", --・Intel Team: Scouting for the enemy Members of the Intel Team are on the ground. "Their reports will be reflected as predicted enemy ""fields of movement"" on your iDroid's map." "The higher the team's level, the more accurate and frequent their reports will become." Be sure to take advantage of them.
	"f2000_rtrg1310", --・Support Unit: Artillery strikes Boss, good news from the Support Unit. They can now deliver support strikes to our areas of operation. Use your iDroid to designate a location for a strike. "Just make sure you're not in the kill zone. I'd hate to tell the men they blew up the Boss." "After you've called in a strike, move away from the target location immediately." Also, like supply drops, strikes cost GMP. "So watch you don't put us in the red. Remember what our real objective is."
	"f2000_rtrg1330", --・Rumors of Quiet (this is the first time her name appears in the game) Boss, this is important. "We've reports of a crack sniper at large in the Afghan wilderness." The Soviets call this sniper Tíxij - "Quiet." "There are never any sightings, and only corpses are left behind..." The Soviets have already lost a number of officers. You'd uh... best watch your step.
	"f2000_rtrg1345", --・Quiet's reception on Mother Base Boss, about the sniper you extracted - "Quiet..." We set up a cell for her on the Medical Platform. The Medical Team is looking into her... "abilities." I'll let you know if they learn anything.
	"f2000_rtrg1346", --・Quiet's reception on Mother Base And Boss... Leave Miller to me. If we manage to get some intel out of Quiet, that should satisfy him.
	"f2000_rtrg1347", --・Quiet's reception on Mother Base And Boss... Leave Miller to me. If we manage to get some intel out of Quiet, that should satisfy him. "In the meantime, get on the chopper. You need to head back to Afghanistan." Make contact with Emmerich.
	"f2000_rtrg1350", --・Encouraging player to return to MB to lead into "Visiting Quiet" cutscene Boss, I need to talk to you about this "Quiet." Can you meet me at her cell here on the base? Whenever's fine. Thanks.
	"f2000_rtrg1410", --・Dispatch/develop/customize: D-Dog Let me explain what D-Dog can do as your buddy. "With that nose of his, he can sniff out and mark nearby enemies and prisoners." Should come in handy for infiltrating outposts. I trained him to detect mines and medicinal plants too. When he locates something, check your map.
	"f2000_rtrg1459", --・Establishment of the Security Team Boss, listen a moment. "I want to bolster our security  to guard against enemy attacks." "What I have in mind is to create a ""Security Team"" that can defend each of the platforms." Can I go ahead with that? "So from now on, [p] give some thought to building up the Security Team as well."
	--CUT:: "Without a strong enough deterrent, we'd just be asking to get attacked again." I'm counting on you, Boss.
	"f2000_rtrg1460", --・FOB construction One other thing. "To divert some of the risk posed by our enemies, I'd like to construct a Forward Operating Base." "The more bases we have, the more staff we can house and the more materials we can secure."
	"f2000_rtrg1500", --・After Eli battle (Mother Base) Has that brat finally accepted that he lost? Hopefully now he'll be a bit more... obedient.
	"f2000_rtrg1510", --・Can be developed > parasite equipment "The R&D and Medical Teams have come up with a proposal for a newsuit that applies Code Talker's research - the Parasite Suit." "Apparently it can recreate some of the Skulls' unusual abilities." But in order to use those abilities, it needs parasites. "If you want to wear this suit, you're going to need to get a hold of parasites by extracting Skulls."
	"f2000_rtrg1515", -- We've begun development on that new "Battle Gear" weapon that Emmerich was talking about. If you want to see how development's going, come take a look for yourself. Check your map.
	"f2000_rtrg1517", -- "The Battle Gear is an armored weapon developed to take on hostile bipedal weapon systems." But unlike the Soviet-funded Walker Gear, the Battle Gear still hasn't been properly field tested. "I'd like to assign a combat unit to take it on dispatch missions, so that we can evaluate its capabilities and reliability." Assuming you've got no objections, give the order to dispatch the unit from your iDroid.
	"f2000_rtrg1520", --・About heroism "Boss, your heroic deeds appear to have earned the respect of other PFs." "Now you'll be able to infiltrate rival PFs' FOBs without having to worry about their nuclear deterrent." "Go get one over on these guys who've escaped retaliation thanks to their nukes."
	"f2000_rtrg1525", --・A world with nukes in it Boss, it looks like someone's developed nukes again. "I guess maintaining a nuke-free world is going to be harder than the disarmament ever was."
	"f2000_rtrg1530", --・After recovering the AI pod AI pod launch confirmed. We'll pick it up. (darkly sarcastic) I wonder what kind of secrets are buried in it... I'll let you know if we learn something.
	"f2000_rtrg1540", --・Extracting the Man on Fire Got a report from the Intel Team. "Remember how the Man on Fire was crushed by Sahelanthropus? Well, the Soviets recovered his body." Could he really be dead? "Boss, head for Yakho Oboo Supply Outpost, and secure the Man on Fire's body." "If Skull Face was right, and a thirst for revenge can turn a man into a demon and keep the dead alive..." "Then this ""Man on Fire"" who's been coming after us ever since you woke up... [p] well, that just might be what's left of our old friend Volgin."
	"f2000_rtrg1550", --・After extracting the Man on Fire's body Well this is one body we can't cremate. We'll store it on the Quarantine Platform.
	"f2000_rtrg1560", --・The escaped kids are there "According to the Intel Team, the escaped kids should be around here." Locate and secure them.
	"f2000_rtrg1561", --hideo quest _miller Boss, one of our staff has been captured by the enemy. comr1000_101752_0_miller He was on the staff at Mother Base nine years back. frer1000_108424_0_miller Get our man out of there, Boss. comr1000_101755_0_miller To say he's a critical VIP would be a massive understatement. frer1000_108422_0_miller
	
	"f2000_rtrg1910", -- The SIDE OP objective is around there.
	"f2000_rtrg2000", --・Quest objective//quest triggered→acquire intel→automatically board chopper (envisioned) Boss, maybe you've realized by now, but... There's no other way to say it. Quiet's gone. "She pulled her camo stunt and stowed away on a departing chopper." "After pinpointing which she took, we figured out her destination." Afghanistan. Get after her. Only you can do this.
	"f2000_rtrg2010", --・Quest objective [2] Boss, I told you this would happen. I wish I could say "Good riddance." But Quiet knows too much about us. We can't just leave her out there! Remember what you told me when she first got here? "One of these days we're gonna have to kill her." "When the time comes, I'll pull the trigger." ...I'd say that time has come.
	"f2000_rtrg2020", --・Quiet is around there Quiet should be around there somewhere.
	"f2000_rtrg2030", --・Upon arriving at the place the intel mentioned Quiet isn't there? Could she have been moved somewhere? You see any intel files lying around?
	"f2000_rtrg3005", --・Prompting player to return to base "Boss... If you got time on your hands, come spend it back at the base." Just wait till you see what we've done with the place. Besides, the men'll miss you if you're gone too long.
	"f2000_rtrg3010", --・Arrived at [powerPlant] (substation facility) You've made it to Serak Power Plant. "Emmerich should be beyond the gate at the northern edge of the facility." We have no idea what he's doing back there... But let's go find out.
	"f2000_rtrg7120", --Emmerich's finished development on that Battle Gear of his. Get back to Mother Base.
	"f2000_rtrg7325", --Boss... Come on back to base.
	"f2000_rtrg7330", --After extracting the Code Talker, once the player triggers certain flags (fulfills conditions), they receive a radio call from Miller upon completing a mission. Miller says they've learned something about Quiet. For that reason, the Code Talker has performed parasitic treatment on her. "Code Talker examined everyone here, and... one of us is infected." It's Quiet. It was our cutting-edge MRI that finally revealed it. But we don't know what language strain it is. Get back to base. Time for her to talk. You know the room number - "101." (meaning he has both the definite proof and Quiet's dreaded salt water at the ready)
	"f2000_rtrg7332", --・Eli's confinement "Boss, as we suspected, the mastermind behind the kids' escape was Eli." "It's hard to believe, but apparently he'd been plotting an armed uprising against us." He could be hiding something else too. Ocelot's going to press him for answers. Get back here as quick as you can!
	"f2000_rtrg7335", --・Notifying player that there's another vocal cord parasite outbreak Player receives this call from Miller during free play, after having met the mission activation conditions. He asks the player to return to Mother Base because there has been another parasite outbreak. Boss, we have an emergency. There's been another outbreak of the vocal cord parasites on the base. Several men are dead. It started in the Laboratory on the Quarantine Platform, where that radiation leak occurred. I'd only just deployed the Security Team... "I've sent in a rescue team to help, but they haven't returned." Boss, I need you on this. Come back to Mother Base ASAP.
	"f2000_rtrg7338", --・An uprising starts within Diamond Dogs because of Huey Boss, you there? We have a problem. "The staff have found out everything that Emmerich's been up to." They're right on the edge. I need you to intervene before things get out of control. Get back to Mother Base ASAP.
	"f2000_rtrg7350", --・Prompting player to return to base Prolonged time in the field is bad for the body and mind. I think it's time you took a break. Do it for me. Come back to Mother Base ASAP.
	"f2000_rtrg8000", --・After completing [s10030] DIAMOND DOGS (on board chopper) (REAX) (somewhat weak, as his injuries haven't fully healed yet) Boss. "I know you haven't been back long, but I've prepared a list of missions for you. Open your iDroid."
	"f2000_rtrg8010", --Player opens iDroid and then opens mission list "I've taken the job offers Diamond Dogs has received and made a list of those I want you to consider. [p] Which ones you accept is your call." "The objectives of the missions I've added are prisoner rescue, facility sabotage, and high-value target elimination..." "Probably all a walk in the park for you, but they should help you get back on your feet." This leads into COMR1000_g60010 "I put the mission details on a cassette tape." Refer to that if you decide to accept the mission. "We'll receive GMP for completing missions, and extracting soldiers and prisoners will boost our ranks." "Building up Mother Base is the first step to achieving our goal." "If that means wetwork, so be it. We're gonna have to get our hands dirty." "I hope you're rested up, because we're not stopping. Not until the pain is gone." "The future of Diamond Dogs is in your hands. We're counting on you, Boss."
	"f2000_rtrg8020", --・If the player extracted prisoners and/or soldiers in Ground Zeroes By the way, I have some good news. "Remember the guys you brought back from the base in Cuba nine years ago?" "Believe it or not, some of them survived that hell we went through." "Word reached them that Big Boss is back, and they wanted in." "They're good men - our brothers in fate. They'll be glad to know you've seen them here." Check your iDroid.
	"f2000_rtrg8030", --・When [s10040] WHERE DO THE BEES SLEEP? is unlocked "Boss, we've received a back-channel request from Langley." "We're to find a piece of new American military hardware that's gone missing in the mountains of Afghanistan." "It's a difficult mission, but I'd say you're back in top form by now." Check your iDroid for the details.
	"f2000_rtrg8040", --・Forming a Base Development Unit (played following on from the above) "Our army is growing like crazy thanks to you, Boss. In fact, it's getting downright crowded around here!" "To bring a greater number of people on board, we'll need to expand our facilities." To that end, I've created a Base Development Unit. "It has two roles: material refinement, and platform construction."
	"f2000_rtrg8050", --・Material Refinement and platform construction (played following on from the above) I'll start with the material refinement part. "The Base Development Unit procures material resources on a regular basis according to its level." "The materials are stored in containers and placed on the deck of Mother Base. Once they're finished being processed, they can finally be put to use." "By using these materials to build new platforms, we'll be able to add a greater number of staff to our ranks." "We don't need any specific instructions from you to refine the materials, but I want YOU to be the one to decide how we construct platforms." "Once we have sufficient GMP and the required material resources, you can issue construction orders from your iDroid."
	"f2000_rtrg8060", --・After completing [s10040] WHERE DO THE BEES SLEEP? (on board chopper) Boss, we've had some new job offers come in. "I've selected the ones I'd like you to handle and added them to the list." I've selected the one I'd like you to handle and added it to the list. Take a look on your iDroid. "The more missions you complete, the more we can expand Mother Base."
	"f2000_rtrg8070", --・Aborting Quiet battle [s10050]: leaving from the exit side (relieved) You made it through the enemy's kill zone. Serak Power Plant is just up ahead. Make contact with Emmerich.
	"f2000_rtrg8080", --・Lead-in to unlocking [s10070] HELLBOUND (Rescue Emmerich) (following on from the above) Bring him back here - alive. "It's time we heard his story about what happened 9 years ago."
	"f2000_rtrg8090", --・After completing [s10070] HELLBOUND (Rescue Emmerich) (played during free roam on Mother Base) Boss, there's no doubt about it. Cipher's working on something in Central Africa. "There's evidence they've been in contact with private forces operating in the region." "We follow that evidence, we should learn what Cipher is after." Diamond Dogs has gotten a lot bigger. Now's the time to take the offensive. Head back to the ACC for your next mission.
	"f2000_rtrg8100", --・Played after the lines above once boarding the chopper Boss, I've been meaning to tell you something. "Our old friend Zero hasn't been seen in public since you left the States. That was over ten years ago now." "You suspected he was responsible for the ""accident"" at your base in the Caribbean." But at that point, Zero was already bedridden. So it never felt right to me that Zero gave the order... "Now that I've seen the man Emmerich was working for, I'm sure he didn't." I know that man. He was our old friend's XO. A man without a face. Not one you'd want to look at, anyway. Skull Face. He's the one who destroyed your base nine years ago. "The unit he commands, XOF, was Cipher's strike force. But he's since split from Zero and used XOF to usurp control over Cipher itself." In other words... The Cipher we're hunting isn't Zero. Beyond Zero is a void that's even darker. Skull Face.
	"f2000_rtrg8115", --・After completing [s10080] PITCH DARK Boss, I've updated the Mission List. We've received a new job offer. "It doesn't seem connected to Cipher or Skull Face at all, but if it goes well we may get an Afrikaans interpreter." The details are on your iDroid.
	"f2000_rtrg8120", --・After completing [s10086] LINGUA FRANCA (Tail the Interpreter) "Boss, one of the latest missions to come in is connected to the Walker Gears." "This could be our chance to close in on Cipher. Take a look at your mission list."
	"f2000_rtrg8130", --・After completing [s10082] FOOTPRINTS OF PHANTOMS "Boss, the Intel Team has come back with its report following its investigation into PF logistics." "Cipher has to be involved with this distribution network somehow..." "One thing in particular caught my eye. A convoy that regularly crosses the savannah." "On paper, it's just mined resources going to the government... but the security's much too heavy." At the very least, it's worth checking out. Take a look at the mission.
	"f2000_rtrg8140", --・After completing [s10090] TRAITOR'S CARAVAN Boss, this is an emergency. "We had two Intel Team agents undercover at the PF ""Contract Forces of Africa."" The CFA have captured them both." "They don't have long to live. You've got to get them out of there ASAP." This means Cipher might be getting wind of our existence. We may need to move more cautiously from now on. I just hope this incident has nothing to do with them... "I've added the details to your Mission List. Don't let 'em down, Boss."
	"f2000_rtrg8150", --・After completing [s10091] RESCUE THE INTEL AGENTS Boss, one of the job offers we received concerns me. "There's a PF commander who's been talking big about getting into the nuclear arms trade." This could be connected to that yellowcake. And there's another contract I'd like you to handle. It's a wet job, but we need to divert Cipher's attention. Check the Mission List for the details.
	"f2000_rtrg8160", --・When unlocking [s10110] VOICES (Factory of Death) Got a new mission for you, Boss. The "client" is one of the kids you rescued from that mine. "According to the kids, people often disappear from the mine to a place called ""Nzo ya Badiabulu"" - the Devil's House..." On top of that, SANR's involved with the place. Check your iDroid for the mission details.
	"f2000_rtrg8170", -- ・After completing [s10195] INFO MAN (If player has already completed [s10100] BLOOD RUNS DEEP, Miller continues talking) One more thing, Boss... "About those Walker Gears spreading all over Africa, Huey's got an idea for a counterweapon." Come on back to base. Let's talk details the next time you're back at Mother Base.
	"f2000_rtrg8175", -- ・After completing [s10195] INFO MAN (If INFO MAN was completed first, start here) Boss... "About those Walker Gears spreading all over Africa, Huey's got an idea for a counterweapon." Come on back to base. Let's talk details the next time you're back at Mother Base.
	"f2000_rtrg8180", -- ・When unlocking [s10121] WAR ECONOMY (Eliminate the PF Operator) "Boss, word has it that a Western arms dealer is going to be inspecting a CFA outpost." "It appears he's involved with nuclear weapons development in the area."My hunch is that this guy is somehow connected to Cipher. "I've got no proof, but we know Skull Face is working through PFs in the region." "Anyway, it just so happens a job connected to this inspection has come in." Take a look at your iDroid.
	"f2000_rtrg8185", --・After completing [s10121] WAR ECONOMY (common) "Boss, [p] I know you're just coming off this mission, [p] but there are reports of child soldiers taking over Masa village after the CFA got wiped out there." "They've been raiding the surrounding villages, so the people have requested we eliminate them." Check your Mission List for the details.
	"f2000_rtrg8190", --・After completing [s10120] WHITE MAMBA Boss, about Eli... "No matter how many times we talk to him, he just won't listen." "He sees everything in terms of victory or defeat, and still won't accept that you beat him." We're going to have to put him in his place... again. "If you don't mind, come back to Mother Base and go another round with him." Of course, feel free to prioritize your missions.
	--CUT: "Nothing directly connected to Cipher has come in, but I'm sure you'll run into them again sooner or later out there." "You know, something bothers me about the deaths of those people at Bwala ya Masa..." If it WAS some disease, why didn't it affect the kids too?
	"f2000_rtrg8200", --・After completing either [s10085] CLOSE CONTACTS or [s10200] AIM TRUE, YE VENGEFUL Boss, about Eli..."I'd heard that one product of the ""Les Enfants Terribles"" project went missing in Africa." The age would be about right. "Now I'm not saying I think it's Eli... but I want to run a genetic test all the same." "Don't worry. I'll have it done without him noticing. (Actually Eli did notice, and this led to him discovering the secret of his birth, and stealing Sahelanthropus)" "The test may take some time, but I'll tell you as soon as we have the results."
	"f2000_rtrg8210", --・When unlocking [s10211] HUNTING DOWN (Trafficker's Escape) Boss, a new job's come in. "It's a hit - on the human trafficker who sent Shabani and the others to Nzo ya Badiabulu, where you ran into Skull Face." "The thing is, this guy might know something about the disease that's going around Mother Base." "The symptoms are similar to the ones we saw at that factory." Start by checking the mission details on your iDroid.
	"f2000_rtrg8220", --・When unlocking [s10081] ROOT CAUSE "Boss, we've finally heard from one of our missing Intel Team members." "He says he has a solid lead on the epidemic at Mother Base." Take a look at the mission details ASAP.
	"f2000_rtrg8230", --・When unlocking [s10130] CODE TALKER "Boss, you need to make contact with Code Talker, the ""old man"" who knows what the pathogen is." "We have to stop this disease that's spreading across Mother Base." Select the mission on your iDroid.
	"f2000_rtrg8240", --・When unlocking [s10140] METALLIC ARCHAEA Boss, are you OK?! "So the vocal cord parasites that have infected Mother Base..." "They're ""ethnic cleansers"" designed to silence those who don't fit into Skull Face's world view. " We can't allow him to have such power. Go over the mission details and get going ASAP. We'll hit back at Skull Face as soon as you return. 
	"f2000_rtrg8250", --・When unlocking [s10150] SKULL FACE (OKB Zero part one) "Thanks to Code Talker, we've managed to put a stop to any new vocal cord parasite infections." "We couldn't save those already symptomatic, but everyone who survived has been released from the Quarantine Platform." "I know you were faced with some tough decisions on this one." Sorry, Boss. But thank you. "And Boss, we found the bodies of the two missing Intel Team members in Lufwa Valley." "We knew we wouldn't get them back alive, but still... it's a damn shame." "They won't be forgotten, though. Skull Face WILL pay for this." Select the mission as soon as you're prepared. We're ready when you are.
	"f2000_rtrg8260", --Even with Skull Face dead, our pain is still right with us. We need... we need more strength. We need more men. Diamond Dogs needs to be bigger. Missions have come in, too. We still have a long road ahead of us."
	"f2000_rtrg8261", --・After completing [s10151] SAHELANTHROPUS (OKB Zero part two) (about developing/disposing of nuclear weapons) "Boss, you can now give the order to develop or dispose of nuclear weapons from your iDroid." "With a nuclear deterrent, even if you're discovered while infiltrating a rival PF's FOB, most PFs won't dare retaliate." "But you of all people know how dangerous it can be to have nuclear weapons." "So, will you add nukes to our arsenal as a deterrent? [p] Or will you take them away from other PFs and dispose of them to help build a world that's free of nuclear weapons?" I'll leave that decision up to you. 
	--CUT: Even with Skull Face dead, our pain is still right with us. We need... we need more strength. We need more men. Diamond Dogs needs to be bigger. "I will weed out any traitors, any parasites, and eliminate them." "To begin with, head for the Central Base Camp in Afghanistan and retrieve the AI pod." "Getting a hold of it could tell us more about what Emmerich's been up to." "Missions have come in, too. We still have a long road ahead of us."
	"f2000_rtrg8270", --・AI pod recovery SIDE OP unlocked (lines added Feb 2015) "Boss, we need evidence to prove our suspicions about Emmerich." "Head to the Central Base Camp in Afghanistan and recover that AI Pod." "It's time we purged Diamond Dogs of that traitorous parasite once and for all."
	"f2000_rtrg8280", --・After completing [s10045] DESERT HUNT (Kill the escaped Soviet soldier) or [s10156] DEAD DROP (Bring back the classified intel) Boss, there's been an accident in the boys' quarters. A pile of steel pipes gave way and crushed one of the kids. The boy named Ralph... They tell me he died instantly. "I'm sorry, Boss. It's my fault. I should have been keeping an eye on them..."
	"f2000_rtrg8290", -- ・After completing [s10045] TO KNOW TOO MUCH (Desert hunt) and [s10156] EXTRAORDINARY (Bring back the classified intel) Boss. Some of the kids we've been keeping here have escaped. "We don't know why they ran off, but it may have something to do with Ralph's death." The Intel Team's looking for them as we speak. I'll add information to your SIDE OPS list as it comes in. You need to locate and secure those kids. I'll try to find out what happened.
	"f2000_rtrg8310", --・Search for the escaped kids (during) "Boss, about the kids... it appears there's a movement among them to organize against us." I can think of only one person who'd be behind that... I'll continue to look into it.
	"f2000_rtrg8320", --・Prompt to search for escaped kids Boss, you need to find those kids who escaped. Fighting's still the only way of life they know. "If we don't bring them back, they'll just end up getting killed."
	"f2000_rtrg8330", --・After extracting the escaped kids (random) (relieved) Whole lot of trouble they put us through. (relieved) Making me worry like that...
	"f2000_rtrg8340", --・Eli's confinement "Boss, as we suspected, the mastermind behind the kids' escape was Eli." "It's hard to believe, but apparently he'd been plotting an armed uprising against us." He could be hiding something else too. Ocelot's going to press him for answers. Get back here as quick as you can!
	"f2000_rtrg8350", --・After Eli's escape Boss... "We're looking for the kids and Sahelanthropus, but there's still no sign of them." We don't know if the chopper pilot is alive either. What have we gone and put in the hands of those kids? We don't know how bad this is until we find them. Also, regarding our "concerns" about Eli... "I've finished looking into whether or not he's a product of THAT project. I have an answer." I put it on tape. Give it a listen.
	"f2000_rtrg8360", --・Some time after Eli's escape "About Eli hijacking Sahelanthropus... we know how he got it moving." It was Emmerich. "He used the kids in the staff living quarters to carry out his repairs." "We got the details on tape. You're gonna want to hear this."
	"f2000_rtrg8370", --・Some time after retrieving the AI Pod "Boss, about that AI pod you retrieved from Emmerich's research facility..." (heavily sarcastic) Guess what we found inside. A corpse - human. "The pod maintained a low internal temperature the whole time, and very little outside air got in. " That would've slowed down decomposition. "Still, the remains were mostly skeletal. Estimated time of death is between six months and a year ago." We put the screws to Huey about it. Listen to the tape. Turns out it was the body of someone we knew very well.
	"f2000_rtrg8380", --・Radiation leak Taking place before the vocal cord parasite outbreak, Miller informs player of a radiation leak. Boss, I have a quick report for you here. "We've discovered a radiation leak in the Laboratory on the Quarantine Platform." "It's coming from testing equipment we installed the other day." "Members of the Medical Team have been conducting research there, [p] but we'll evacuate them all from the Research Block to the Containment Block next to it. [p] Emmerich?" "There's no need to worry - no radioactive material has leaked, so the contamination won't spread. We just need to seal off the testing equipment." "I've dispatched the Security Team to get the researchers out. I'll keep you updated."
	"f2000_rtrg8390", --・Notifying player that there's another vocal cord parasite outbreak Player receives this call from Miller during free play, after having met the mission activation conditions. He asks the player to return to Mother Base because there has been another parasite outbreak. Boss, we have an emergency. There's been another outbreak of the vocal cord parasites on the base. Several men are dead. It started in the Laboratory on the Quarantine Platform, where that radiation leak occurred. I'd only just deployed the Security Team... "I've sent in a rescue team to help, but they haven't returned." Boss, I need you on this. Come back to Mother Base ASAP.
	"f2000_rtrg8391", --"・After [p51_070010] Return to Mother Base and receive Miller's briefing ([s10240] SHINING LIGHTS, EVEN IN DEATH mission unlock radio call)" "We have no idea why the parasite has showed up again. I thought we took care of it." We need more information. Find out what's going on, Boss. Select the mission on your iDroid.
	"f2000_rtrg8400", --・After completing [s10240] SHINING LIGHTS, EVEN IN DEATH (Slaughter the MB infected) You got a minute? It's about the Quarantine Facility. "We've more or less figured out what caused the mutation in the vocal cord parasites." It was the radiation from that scanner. And the one who installed it was Emmerich... "I've added a tape recording of the interrogation. You should listen to it."
	"f2000_rtrg8420", --・Explaining mission objective (1) "Boss, a certain scientist has contacted us wanting to defect from the East." His name... is Emmerich. That's right. The man we knew as Huey. "We suspect he was complicit in the attack on Mother Base nine years ago." He was working with Cipher. (only a guess, but this is the conclusion Miller has come to) ...I've been waiting a long time for this. So I say, let's help Emmerich defect. Once he's here, we can sit down and catch up on old times. (meaning to interrogate him) Emmerich is currently at Serak Power Plant. This is our chance. Boss, head for the power plant.
	"f2000_rtrg8421", --Boss. "The scientist, Emmerich, wants us to find him so he can defect." He should be inside Serak Power Plant. Make contact with him.
	"f2000_rtrg8440", --Boss. We've received some new job offers. The details are on your iDroid.
	"f2000_rtrg8450", --Boss, I've updated the Mission List. We've received some new job offers. The details are on your iDroid.
	"f2000_rtrg8451", --Boss, I've updated the Mission List. We've received some new job offers. The details are on your iDroid.
	"f2000_rtrg8452", --Boss, I've updated the Mission List. We've received a new job offer. The details are on your iDroid.
	"f2000_rtrg8453", --Boss, I've updated the Mission List. We've received some new job offers. The details are on your iDroid.
	"f2000_rtrg8454", --Boss, I've updated the Mission List. We've received some new job offers. The details are on your iDroid.
	"f2000_rtrg8900", --・End of Chapter 2 radio call (before Truth Mission) (Heartfelt and emotional) Boss... I don't know how you do it. "I... [p] All I could do was obsess over revenge... doubting my comrades along the way. [p] But even after all we accomplished, the phantom pain never let up. [p] (self derisive snort) If anything, it just got worse." But you understood that from the start, didn't you? From the moment you opened your eyes in that hospital. You knew it wouldn't go away... "Yet, you've been fighting the pain and confronting your phantoms the whole time..." "Knowing full well that the battle would never end... not till the day you die. " I respect that now... more than ever. It's an honor and a privilege, Big Boss. (completes the circle that began with "Let the legend come back to life" in the first mission)
	"f2000_rtrg9010", --・Radio message from Miller during black background "Look closely. [p] Those are the symptoms of  the infection on Mother Base." "The blisters on the body were full of tiny worms - parasite larvae, most likely." Continues to ID photos. "The faces of the infected flash across the screen one after another." The ID photos switch to yet more infected. Their profiles are displayed one after the other. "Boss, [p] do you remember seeing these symptoms before?" "The bodies floating around in the oil facility... [p] The bedridden test subjects at the Devil's House..." "This epidemic looks just like what we've seen on our hunt for Cipher." "So this is the weapon of mass destruction Cipher was working on in Africa...?" "Boss, the situation is urgent. We need to quarantine the infected and contain the pathogen." Priority now is to prevent more casualties."But we couldn't find any adults. [p] It doesn't seem to mature in the body - like a sparganum." "We don't know the route of infection, or what causes symptoms to develop."
	"f2000_rtrg9020", --・Radio message from Miller during black background But the problem is, how do we tell who's infected? "During the incubation period, we have no way of knowing who's clean." "You'll have to try and guess who's infected before they go symptomatic, and quarantine them." "That'd be easy if we just knew the route or vector of the infection..."
	"f2000_rtrg9030", --・Radio message from Miller during black background "From now on, if you even suspect a staff member's infected, use your iDroid to order them into quarantine." "Given the situation, the men won't submit to quarantine just because I or the Medical Team tell them to." But they will listen to you. "Of course, it's just a temporary measure until we find a permanent solution." "But, at least, they'd be in solitary isolation so they won't infect each other, and would get the mental care they need." If we do nothing, we'll only lose more people. We have no choice.
	"f2000_rtrg9040", --・◆Start of "quarantining the infected" game Boss, open your iDroid.
	"f2000_rtrg9050", --・◆Start of "quarantining the infected" game What's the matter, Boss?
	"f2000_rtrg9060", --・Screen when iDroid is open (map screen) "I'll explain how to quarantine staff members suspected of infection. " "Go to the MOTHER BASE menu and select STAFF MANAGEMENT."
	"f2000_rtrg9070", --・Screen when iDroid is open (map screen) What's wrong? Select the red icon.
	"f2000_rtrg9080", --・STAFF MANAGEMENT screen First, take a look at the Quarantine Facility we've set up.
	"f2000_rtrg9090", --・STAFF MANAGEMENT screen What are you waiting for? Look at the Quarantine Facility.
	"f2000_rtrg9100", --・About Quarantine Facility and the infected "We'll isolate anyone who's already symptomatic at the Quarantine Facility." "But we have to expect that there are multiple staff who are infected, but asymptomatic." So how do we identify them? At present, we have no way to tell them apart. But there has to be something for us to go on. "If you notice anything, REASSIGN staff you suspect are infected to the Quarantine Facility." "We'll monitor them and then contact you if there's a change in their condition." "Correctly quarantining these asymptomatic infected will reduce the number of new infections." You should continue with your missions as usual. "If Cipher is behind this, going after them should help us determine the root cause of this epidemic." "Also, until we identify the pathogen, we can't fire or dispatch any staff. We cannot let this thing spread." "Boss... get to the bottom of this, fast. We're counting on you."
	"f2000_rtrg9110", --・Upon moving soldier to quarantine facility using the STAFF MANAGEMENT screen All right, we'll quarantine the staff you specified. Did you figure out what's causing the infection?
	"f2000_rtrg9120", --・Upon moving soldier to quarantine facility using the STAFF MANAGEMENT screen Understood. Initiating quarantine.
	"f2000_rtrg9130", --・Upon moving soldier to quarantine facility using the STAFF MANAGEMENT screen "Slow down, if we quarantine everyone in sight there won't be anyone left to work." Mother Base would grind to a halt.
	"f2000_rtrg9140", --・Upon moving soldier to quarantine facility using the STAFF MANAGEMENT screen "You want to release staff from quarantine? People could be asymptomatic infected. [p] You need to think very carefully about this first."
	"f2000_rtrg9150", --・1) No one has had their quarantine status changed (first time) Boss, someone else has turned symptomatic. "The staff member's been moved to Quarantine, but at this rate we're going to lose everybody." Find out what's causing this, and quarantine the infected!
	"f2000_rtrg9160", --・1) No one has had their quarantine status changed (second time onward) "We've got someone else who's symptomatic, Boss. You need to quarantine the infected!"
	"f2000_rtrg9170", --・2) At least one person was quarantined, but it was the wrong person(s) (odd-numbered times) "Boss, there's been no improvement in the outbreak. You may have quarantined the wrong people..."
	"f2000_rtrg9180", --・2) At least one person was quarantined, but it was the wrong person(s) (even-numbered times) "Boss, got another symptomatic case among the non-quarantined staff. There must be other staff that need to be quarantined..."
	"f2000_rtrg9190", --・1 or 2) Hint (follows 1 or 2) [1] The infected have to have something in common.
	"f2000_rtrg9200", --・1 or 2) Hint (follows 1 or 2) [2] "You can view the symptomatic staff in the Quarantine Facility from the STAFF LIST." See if you pick up on anything.
	"f2000_rtrg9210", --・1 or 2) Hint (follows 1 or 2) [3] Maybe their abilities have something in common? Check anything and everything, Boss.
	"f2000_rtrg9220", --・3) If the situation improves after quarantining someone Boss, looks like that last quarantine was the right call. "We're seeing less symptomatic cases among unquarantined staff."
	"f2000_rtrg9230", --・3) Hint (follows 3) Did you figure out what the infected have in common? "Just remember, there are still other carriers who can spread the infection." Quarantine all staff that have the same thing in common.
	"f2000_rtrg9240", --・4) When choices are clearly correct (number of infected plummets) "We're definitely seeing a reduction in the number of full-blown infections." Did you figure out what's causing this, Boss? Did it did have something to do with staff abilities...?
	"f2000_rtrg9250", --・5) Player's quarantine orders follow a pattern (number of unquarantined infected reaches the minimum, i.e., there are no staff with the Kikongo language skill outside of the quarantine facility) "Incredible, Boss. Thanks to you, the number of new victims has plummeted." And the common point between the infected... "Is it really possible for a disease to spread because of that?"
	"f2000_rtrg9260", --・After clearing Root Cause mission "Boss, there'll be no more new casualties, but this crisis isn't over yet." "To save the infected, you need to make contact with the old man known as Code Talker."
	"f5000_rtrg0010", --・FOB mission (infiltration) start "Successfully sneak your way into the heart of the rival PF's FOB, and you can capture staff from them." I'll be looking forward to meeting the new recruits, Boss.
	"f5000_rtrg0020", --・FOB mission (infiltration) start "Successfully sneak your way into the heart of the rival PF's FOB, and you can take back the staff they captured." Make 'em regret they ever messed with us, Boss.
	"f5000_rtrg0030", --・FOB mission (defense) start There's one intruder. "Their objective is unclear, but if they make it to the heart of the FOB, they'll capture staff from it. (Because the player may be defending a friend's FOB, ""our"" can't be used)" You've got to make sure that doesn't happen.
	"f5000_rtrg0040", --・FOB mission (defense) start There's one intruder. "Their objective is probably to make it to the heart of the FOB and take back the staff that were captured." "But we're not gonna let that happen. Beat them at their own game, Boss."
	"f5000_rtrg0050", --・FOB mission (infiltration) end Infiltration successful!
	"f5000_rtrg0060", --・FOB mission (infiltration) end Withdrawal complete...
	"f5000_rtrg0070", --・FOB mission (infiltration) end Infiltration failed...
	"f5000_rtrg0080", --・FOB mission (infiltration) end Are you hurt? Try a little harder next time.
	"f5000_rtrg0090", --・FOB mission (infiltration) end Damn it, a staff member died. (singular, male or female) Try to be more careful next time, Boss.
	"f5000_rtrg0100", --・FOB mission (infiltration) end Damn it, a staff member's been captured. You'll just have to get 'em back, Boss.
	"f5000_rtrg0110", --・FOB mission (infiltration) end Boss, the rival PF knows who we are. Better step up FOB security in case they retaliate.
	"f5000_rtrg0120", --・FOB mission (defense) end Defense successful!
	"f5000_rtrg0130", --・FOB mission (defense) end Victory is ours! They need their heads checked, trying to take us on.
	"f5000_rtrg0140", --・FOB mission (defense) end We fought them off!
	"f5000_rtrg0150", --・FOB mission (defense) end I guess they took one look at you and got scared.
	"f5000_rtrg0160", --・FOB mission (defense) end Defense failed...
	"f5000_rtrg0170", --・FOB mission (defense) end Damn, staff got captured. Maybe security was too lax? (Because the player may be defending a friend's FOB, "our" can't be used)
	"f5000_rtrg0180", --・FOB mission (defense) end Boss, we've located an FOB belonging to that rival PF. Now we can retaliate.
	
	"f6000_rtrg0010", --・After completing [s10041] RED BRASS ・Black-screen phone call (meeting didn't take place and targets weren't extracted) "Mission complete, Boss. That was impressive." "...But what do you suppose they were going to discuss at such a rare meeting?" Guess we'll never know.
	"f6000_rtrg0020", --"Ocelot got the details of the meeting out of that commander." "It seems you've been doing your  job just a little too well, Boss." "The Soviets have begun reinforcing  the 40th Army's units in Afghanistan." Sending in more men, and new equipment... "While things haven't exactly been easy for us up till now, they're about to get even tougher."
	"f6000_rtrg0030", -- Remember what the commanders were talking about? "It seems you've been doing your  job just a little too well, Boss." "The Soviets have begun reinforcing  the 40th Army's units in Afghanistan." Sending in more men, and new equipment... "While things haven't exactly been easy for us up till now, they're about to get even tougher." "You've probably gotten used to operating in Afghanistan, [p] but therein lies the danger. [p] You can't let your guard down, Boss." 
	"f6000_rtrg0040", -- Remember what the commanders were talking about? "It seems you've been doing your  job just a little too well, Boss." "The Soviets have begun reinforcing  the 40th Army's units in Afghanistan." Sending in more men, and new equipment... Not to mention setting up minefields around outposts. "While things haven't exactly been easy for us  up till now, they're about to get even tougher." "You've probably gotten used to operating in Afghanistan,  [p] but therein lies the danger.  [p] You can't let your guard down, Boss." 
	"f6000_rtrg0050", -- ・After completing [s10045] TO KNOW TOO MUCH [1]  Boss, the target filled us in on what's been going on. "He betrayed the Soviets, passing information to Langley, but got scared after learning XOF used the vocal cord parasites." "Then came feelings of guilt that his leaks sent comrades to their deaths, and fear that America might deploy such a weapon itself..." "But in reality, XOF and Langley don't have a collaborative  relationship, and Skull Face was not working for America." Still, I can't blame the man for being afraid. "After laying low with the Mujahideen, he tried to cut his ties with the U.S. and return to the Soviet military." "But along the way, someone came after him and he was forced back into hiding." Could have been remnants of XOF looking to silence him. And you know the rest. "He doesn't seem to know much about the parasites,  but nevertheless, it'd be too dangerous to hand him  over to Langley or the Soviets." We'll keep him here as originally planned.
	"f6000_rtrg0060", -- ・After completing [s10045] TO KNOW TOO MUCH (extracted executioner) [2]   Boss, the target filled us in on what's been going on. "He betrayed the Soviets, passing information to Langley, but got scared after learning XOF used the vocal cord parasites." "Then came feelings of guilt that his leaks sent comrades to their deaths, and fear that America might deploy such a weapon itself..." "But in reality, XOF and Langley don't have a collaborative  relationship, and Skull Face was not working for America." Still, I can't blame the man for being afraid. "After laying low with the Mujahideen, he tried to cut his ties with the U.S. and return to the Soviet military." "But along the way, someone came after him and he was forced back into hiding." Could have been remnants of XOF looking to silence him. And you know the rest. "He doesn't seem to know much about the parasites,  but nevertheless, it'd be too dangerous to hand him  over to Langley or the Soviets." We'll keep him here as originally planned."Those men hunting for the target were Soviet troops who were colluding with the XOF." "After securing the north observation post and learning the target's location, XOF sent assassins to eliminate him." "Skull Face had turned XOF into his personal army, but the organization continues to exist even after his death." "According to the man you extracted, their orders came through the same channel as always." But is Zero really able to give orders in his current state? Or is somebody else calling the shots for XOF? For Cipher? What the hell...? (final line of MGS2) 
	"f6000_rtrg0070", -- ・After completing [s10052] ANGEL WITH BROKEN WINGS  Boss. "That target you extracted, Malak,  is saying that he's never heard of our client." "What's more, he says his village was destroyed long before he was ever taken prisoner." "Apparently it fell victim to some sort of disease, then was completely burned to the ground." "Malak was out on a mission at the time, and that's the reason why he alone survived." But the question is, who hired us to find him? "According to Malak, he saw strange soldiers snooping around the village when he got back." Turns out they were members of Cipher's strike force, XOF. "My theory is they wanted to get their hands on Malak to question or silence him before the Soviets could get to him." "Cipher was just using us to cover things up. All that crap about Malak's relative was a front to convince us to retrieve him." But an entire colony just wiped off the map... it sounds a lot like the Hamid during the Honey Bee incident. "All I know, Boss, is there's no way in hell I'm handing Malak over to Cipher." I decided to bring him back to Mother Base instead. He's one of us now. "We told the client, through a cut-out,  that the target was killed." "For some reason, though, they still  paid us everything we were owed." Cipher's obviously up to something, and this is probably just another preemtive cleanup operation to them. "But to Malak, he lost his village, his family... Everything. And he wants his revenge." In other words, he's one of us. 
	"f6000_rtrg0080", -- ・After completing [s10080] PITCH DARK  "Boss, we took another look into SANR, the owner of the oilfield." They were behind what happened.  "They hired the PF, not UNITA. They restarted the facility all the while pretending they were the victims." "One other thing. SANR's Johannesburg ""head office"" is just a room in a multi-tenant building. Company's essentially nonexistent." "Three years ago, that investment fund stepped in and started gutting it through a series of mergers and sell-offs. And, get this...  [p] the fund itself no longer exists, either." "It's a shell corporation... Meaning someone is just using SANR's name from the shadows." "But what about those strange corpses? Just what the hell were they doing over there?" 
	"f6000_rtrg0090", --・After completing [s10081] ROOT CAUSE (target DOA)  "Boss, the Intel Team member you extracted... [p] was DOA." He kept insisting we listen, right up until his last breath. About "the pathogen." And the "old man" who knows how to treat it... "Code Talker." He even told us where he is. Boss, let's make sure his death was the last. It's high time we met this Code Talker. 
	"f6000_rtrg0100", --・After completing [s10081] ROOT CAUSE (target survived)  "Boss, the Intel Team member you extracted is gonna be OK." All thanks to your quick actions. He keeps muttering the same things over and over. About "the pathogen." And the "old man" who knows how to treat it... "Code Talker." He even told us where he is. This is our only lead, Boss. Let's go meet this Code Talker. 
	"f6000_rtrg0110", --・After completing [s10085] CLOSE CONTACTS  Boss, we've placed the two targets in quarantine. "They don't show signs of anything, but we'll monitor them just the same." "If they had access to the Devil's House, I doubt they were sent there by some health organization." "Cipher used them, and would've eliminated them eventually." But we'll protect them here. They've agreed to that. "After all, we helped them out of the country as promised. The mission's complete..."  But Boss, they've been behind the curtains at Ngumba. They examined the patients there nearly every day. "They told us the patients were being made to listen to voices on tape." But the male target added something interesting. "He said he doesn't know what was on the tapes because there was no English version." "Of all the voices that were ""shoved down"" those people's throats..." ...English wasn't one of them. //This is followed-up in audio tapes; they talk about what was on those tapes that were being played in various languages, as well as raising the question of why English apparently wasn't one of them. The player doesn't understand what is going on at this point, but once they rescue Code Talker, they learn what Skull Face was up to at that facility, and later it becomes clear that Skull Face has an English strain as well. 
	"f6000_rtrg0120", --・After completing [s10086] LINGUA FRANCA (extracted a prisoner other than the target)  "Boss, one of the other British prisoners filled us in about the viscount. It turns out he's a real two-faced son of a bitch." "He was planning to secure the  MPLA's oilfield rights for himself [p] in exchange for swapping the CFA's alliance  from the anti-government UNITA rebels  to the state-backed MPLA." "He hid this from the Afrikaners, but once  he thought the jig was up, he tried to pin it on  the other British personnel and take off." "The Afrikaners captured him, and that was  when he asked us to rescue him and only him." "I'll throw him in the Brig for now, but... we may have to be extra ""persuasive"" with this one." ・After completing [s10086] LINGUA FRANCA (common)  "By the way, Boss, we got some interesting news out of our friend the ""viscount.""" "He mentioned that more than a few PFs in the region have purchased Walker Gears. The CFA's the same." That's Soviet Army technology... and it's still a prototype. Only Cipher could be leaking it to the PFs.  But the question is... why? 
	"f6000_rtrg0130", --・After completing [s10086] LINGUA FRANCA (didn't extract a prisoner other than the target)  In this case, the target joins the Mother Base staff straight away without being put in the Brig "Boss, now that the viscount is no longer  with the CFA, he says he wants to work for us." "Something about him bugs me, but he did pay us for the  contract, and he'll probably come in useful for something." See if you can find a place for him. "According to the viscount, the CFA planned to switch sides from the UNITA rebels to support the MPLA government forces in exchange for oilfield rights." ・After completing [s10086] LINGUA FRANCA (common)  "By the way, Boss, we got some interesting news out of our friend the ""viscount.""" "He mentioned that more than a few PFs in the region have purchased Walker Gears. The CFA's the same." That's Soviet Army technology... and it's still a prototype. Only Cipher could be leaking it to the PFs.  But the question is... why? 
	"f6000_rtrg0140", --・After completing [s10090] TRAITORS' CARAVAN  Boss, we searched the truck you recovered. There were two primary types of cargo. "First, drums of malachite, a copper ore.  That took up most of the truck bed." But malachite isn't valuable enough to warrant an escort. "The real cargo was likely the second  item, a shielding container." The contents? Yellowcake. That's right. The raw material for a nuclear weapon. "That might point to the ""weapon to surpass Metal Gear""  Emmerich told us about, but who can say..." "Thing is, there isn't a lot of it.  Not enough to make a nuclear warhead." "Give us some time. We'll look into it, try to figure  out why they had this under such close guard." 
	"f6000_rtrg0150", --・Black background call: Commander's past Boss, we've figured out who that enemy commander was. He was on the staff at Mother Base nine years back. "Despite surviving the attack, he broke off from us,  and spent his years terrified that a clean-up squad  would come after him." The isolation screwed with his sense of loyalty. A rumor, source unknown, had him convinced... "...that the attack nine years ago,  was orchestrated by you yourself." "That Big Boss sold out his comrades to hide from the world." He thought that's why you weren't at the base that day. "He was so desperate to take us down,  he built up his own PF, copying us in every way." His idea of the perfect revenge. "But in the end...  [p] he was just a victim of disinformation." I'll leave you to decide how to deal with him. 
	"f6000_rtrg0160", --・After completing [s10121] WAR ECONOMY (extracted the target)  "Boss,  [p] about that target you extracted...  [p] he says he wants to work for us." Having talked to him, he doesn't seem that bad a guy. "Apparently the arms dealer's people demanded they prolong the conflict, and he couldn't go against the management." "That doesn't excuse everything he did,  [p] but his skills will make him a useful asset." Let's put him to good use. 
	"f6000_rtrg0165", --・After completing [s10121] WAR ECONOMY (extracted the target and visitor)"Boss,  [p] about that target you extracted...  [p] he says he wants to work for us." Having talked to him, he doesn't seem that bad a guy. "Apparently the arms dealer's people demanded they prolong the conflict, and he couldn't go against the management." "That doesn't excuse everything he did,  [p] but his skills will make him a useful asset." Let's put him to good use.  I've tossed that arms dealer in the brig. "The way he tells it, he worked in logistics with the  South African Army, but he was headhunted by SANR." "Whoever gave him his orders would only  have been a pawn of Skull Face anyway...  [p] but apparently he hasn't been in contact for some time. " "He doesn't know much about SANR...  not even what its president looks like." Just another cog in the machine. 
	"f6000_rtrg0170", --・After completing [s10121] WAR ECONOMY (extracted the visitor)  I've tossed that arms dealer in the brig. "The way he tells it, he worked in logistics with the  South African Army, but he was headhunted by SANR." "Whoever gave him his orders would only  have been a pawn of Skull Face anyway...  [p] but apparently he hasn't been in contact for some time. " "He doesn't know much about SANR...  not even what its president looks like." Just another cog in the machine. 
	"f6000_rtrg0180", --・After completing [s10195] ON THE TRAIL  "The ""Major"" spilled his guts all right... His nuclear arms  business was just a rumor he was paid to spread around." He doesn't even know who's paying him. All his instructions came through a cut-out. But hell, who else would be behind it but Cipher? "And this nuclear arms trading is  clearly connected to that yellowcake." "He thought the same thing, which is why  he tried to investigate ZRS himself..." "He said something else that caught my attention.  [p] That ZRS are trying to kill some old man." How did one old man get that kind of attention? 
	"f6000_rtrg0190", --・After completing [s10200] AIM TRUE, YE VENGEFUL  Boss, about how we report this one to the client... "I'll tell them we took heavy resistance from the renegade platoon, and the hostage was killed in the firefight." Also, their leader wouldn't let himself be taken alive. "I doubt the client will pay us for this one, but we got a big enough reward from the general's No. 2 instead." "And as for the No. 2, he's saying he wants to join Diamond Dogs. I guess he knows what that means for him..." "He said, ""If I'm working for you, I can be No. 2 or No. 200 for all I care.""" 
	"f6000_rtrg0200", --・After completing [s10211] HUNTING DOWN  Our trafficker was very talkative. (Ocelot tortured him, and he cracked easily) "Guinea pigs..." That's what became of his kidnap victims. "Says he got a good look at that ""factory"" at Nzo ya Badiabulu when he dropped off some fresh guinea pigs for them. " Along with our man without a face. "His instincts told him to run like the rat he is.  [p] Said it wasn't worth the money.  [p] Figured he could be next." That's why he went to the NGO for help. "He thought that in exchange for his buyers list, they could  set him up with a new identity someplace far away." "He had an idea who he was up against,  and he didn't want to take any chances." "A true rat.  [p] But like us Dogs, he knew when he smelled trouble." "And something else -  [p] he said, ""The 'specimens' come from deep in the forest...""" We don't know what he meant by "specimens" just yet. "But those guinea pigs' symptoms match what  we've seen on the infected at Mother Base." "Deep in the forest... maybe there's the clue  we need to beat this infection." Boss... The truth could be right around the corner. 
	"f6000_rtrg0220", --・After completing [s10110] VOICES (FACTORY OF DEATH)  Skull Face. So he was in Africa after all. "Working behind the scenes, with even that  ""Man on Fire"" at his beck and call..." But what the hell was going on at "the Devil's House"? "Earphones embedded in people's throats, tapes playing voices..." "And those lumps on their chests... It looked like the ones on the bodies at the oilfield." The Man on Fire burned everything to the ground... "But we were recording audio the whole time you were there." We'll conduct a thorough analysis of it. 
	"f6000_rtrg0230", --・After completing [s10082] FOOTPRINTS OF PHANTOMS  Boss, we were right. "Once you'd eliminated those Walker Gears, a resupply  call was made from Ditadi to CFA headquarters." "The CFA then contacted none other than SANR... that's right, the shell company that ""owned"" Mfinda Oilfield." So SANR was just a front for Cipher... "The resupply won't be happening just yet, but we did learn that the Walker Gears are transported out of Nova Braga Airport." "Apparently there's a distribution network on the savanna that links all the PF outposts." I'll have the Intel Team investigate this network. "If Cipher is supplying PFs with Walker Gears, the PFs have to be offering them something in return." "We follow the money trail, and we might just find ourselves on Cipher's doorstep." 
	"f6000_rtrg0240", --・After completing [s10093]  "Boss, we got Code Talker's research materials back in one piece." "The Medical Team has them under lock and key in the Quarantine Facility." "The materials should help their research into the vocal cord parasites." Cipher won't be getting their hands on them now. 
	"f6000_rtrg0250", --・After completing [s10033] OVER THE FENCE  The engineer we rescued has been extremely cooperative. The guys on the R&D Team are glad to have him aboard.  Thing is, his specialty isn't mechanics, but something called "bionics" - engineering based on... biology. (Miller doesn't really understand it) "He's already submitted a proposal for modifying your prosthetic arm.(Was he the one who created Zadornov's prosthesis?)" "If you're interested, go ahead and give the development order." 
	"f6000_rtrg0265", --・Quiet's Parasite Therapy  You have the results of Quiet's scans? "Yes. As I suspected, her entire body underwent parasite therapy." "The parasites compensated for her burned epidermis, and provide her blood with oxygen through cutaneous respiration instead of pulmonary respiration." "In addition, they replaced the digestive organs she lost, and she receives carbohydrates through photosynthesis." Was Skull Face responsible? There is no other possibility. "Skull Face ordered Quiet to assassinate Snake, only she got set on fire instead when he woke up in that hospital." "But then Skull Face revived Quiet through his parasite therapy." At the same time, infecting her with the English strain. "That way, even if the assassination failed again, she could still kill all of us just by coming here." "That was the third English mating pair - correction, the first and only English pair to be carried by a person." "So either because she wanted to get even with Snake, or because she was working for Skull Face,  Quiet approached Snake again." "Though in the end, for whatever reason, she did not complete her objective." Some change of heart perhaps? We won't hear it from her. 
	"f6000_rtrg0300", --frer1000_104372_0_miller Boss. frer1000_104371_0_miller About those Walker Gears spreading all over Africa, Huey's got an idea for a counterweapon. frer1000_107295_0_miller Come on back to base.
	"f6000_rtrg0310", --・Start of "Quarantine the Infected" game During free play, the player receives a real-time radio call from Miller. Miller tells Snake an infection has sprung up among base personnel.  "Boss, we have an emergency. Many of our staff are falling ill." "At first it seemed like a common cold, but before we knew it, blisters started popping up on their chests, and... Damn it..." I'll fill you in at the ACC. Just get in the chopper. 
	"f6000_rtrg0325",
	"f6000_rtrg0330",
	"f6000_rtrg0332",
	"f6000_rtrg0335",
	"f6000_rtrg0338",
	"f6000_rtrg0340",
	"f6000_rtrg0350",
	"f6000_rtrg0360",
	"f6000_rtrg0370",
	"f6000_rtrg0380",
	"f6000_rtrg0400",
	"f6000_rtrg0500",
	"f6000_rtrg0511",
	"f6000_rtrg2010",
	"f6000_rtrg2020",
	"f6000_rtrg2030",
	"f6000_rtrg2040",
	"f6000_rtrg2050",
	"f6000_rtrg2060",
	"f6000_rtrg2110", --_ocelot We've begun development on that new "Battle Gear" weapon that Emmerich was talking about. Don't worry, I've spoken with Miller and he's signed off on it too. It's an offshoot of Metal Gear technology. A variable multi-legged tank. Should come in handy. We've prepared a hangar for the Battle Gear in the lower part of the Command Platform. If you want to see how development's going, come take a look for yourself.
	"f6000_rtrg2120",
	"f6000_rtrg2130",
	"f6000_rtrg2140",
	"f6000_rtrg2150",
	"f6000_rtrg2160",
	"f6000_rtrg2270",
	"f8000_gmov0010", -- PLAYER_DEAD
	"f8000_gmov0020", -- OUT_OF_MISSION_AREa
	"f8000_gmov0030", -- OUT_OF_MISSION_AREA_HELI",
	"f8000_gmov0040", -- HELICOPTER_DESTROYED
	"f8000_gmov0050", -- PLAYER_DESTROY_HELI",
	"f8000_gmov0060", -- RIDING_HELI_DESTROYED
	"f8000_gmov0070", --_miller I thought I could count on you, Boss. Mission failed.
	"f8000_gmov0080", --_miller We lost the targets. The kids are all dead. Mission failed.
	"f8000_gmov0090", -- S10020_OUT_OF_MISSION_AREa
	"f8000_gmov0100", -- PLAYER_DEAD s10020",
	"f8000_gmov0110", -- TARGET_DEAD s10020",
	"f8000_gmov0115", -- TargetDead s10045",
	"f8000_gmov0120", -- PLAYER_KILL_TARGEt
	"f8000_gmov0123", -- PLAYER_KILL_TARGET_WOMAn
	"f8000_gmov0125",
	"f8000_gmov0130", --_miller Target confirmed dead. He didn't survive the shock of the Fulton extraction. Mission failed.
	"f8000_gmov0140", --_miller Boss, the target's dead. Mission failed.
	"f8000_gmov0150", --_miller Why did you kill her, Boss? Mission failed.
	"f8000_gmov0220",
	"f8000_gmov0230", -- PLAYER_KILL_CHILD_SOLDIEr
	"f8000_gmov0240",
	"f8000_gmov2500", -- PLAYER_KILL_DD
	"f8000_gmov9090", -- OTHERS MissionFailedTimeOver MissionFailedContainerBreak
}

this.PlaySupportRadio={
	settings=this.RadioLabels,
	OnActivate=function(self,setting)
		TppRadio.Play(self.settings[setting+1])
	end
}

this.ConversationList={
	"USSR_story_01",
	"USSR_story_02",
	"USSR_story_03",
	"USSR_story_04",
	"USSR_story_05",
	"USSR_story_06",
	"USSR_story_07",
	"USSR_story_08",
	"USSR_story_09",
	"USSR_story_10",
	"USSR_story_11",
	"USSR_story_12",
	"USSR_story_13",
	"USSR_story_14",
	"USSR_story_15",
	"USSR_story_16",
	"USSR_story_17",
	"USSR_story_18",
	"USSR_story_19",
	"USSR_revenge_01",
	"USSR_revenge_02",
	"USSR_revenge_03",
	"USSR_revenge_04",
	"USSR_revenge_05",
	"USSR_revenge_06",
	"USSR_revenge_07",
	"USSR_revenge_08",
	"USSR_revenge_09",
	"USSR_revenge_10",
	"USSR_revenge_11",
	"USSR_revenge_12",
	"USSR_revenge_13",
	"USSR_counter_01",
	"USSR_counter_02",
	"USSR_counter_03",
	"USSR_counter_04",
	"USSR_counter_05",
	"USSR_counter_06",
	"USSR_counter_07",
	"USSR_counter_08",
	"USSR_counter_09",
	"USSR_counter_10",
	"USSR_counter_11",
	"USSR_counter_12",
	"USSR_counter_13",
	"USSR_counter_14",
	"USSR_counter_15",
	"USSR_counter_16",
	"USSR_counter_17",
	"USSR_counter_18",
	"USSR_counter_19",
	"USSR_counter_20",
	"USSR_counter_21",
	"USSR_counter_22",
	"PF_story_01",
	"PF_story_02",
	"PF_story_03",
	"PF_story_04",
	"PF_story_05",
	"PF_story_06",
	"PF_story_07",
	"PF_story_08",
	"PF_story_09",
	"PF_story_10",
	"PF_story_11",
	"PF_story_12",
	"PF_story_13",
	"PF_story_14",
	"PF_story_15",
	"PF_revenge_01",
	"PF_revenge_02",
	"PF_revenge_03",
	"PF_revenge_04",
	"PF_revenge_05",
	"PF_revenge_06",
	"PF_revenge_07",
	"PF_revenge_08",
	"PF_revenge_09",
	"PF_revenge_10",
	"PF_revenge_11",
	"PF_revenge_12",
	"PF_revenge_13",
	"PF_counter_01",
	"PF_counter_02",
	"PF_counter_03",
	"PF_counter_04",
	"PF_counter_05",
	"PF_counter_06",
	"PF_counter_07",
	"PF_counter_08",
	"PF_counter_09",
	"PF_counter_10",
	"PF_counter_11",
	"PF_counter_12",
	"PF_counter_13",
	"PF_counter_14",
	"PF_counter_15",
	"PF_counter_16",
	"PF_counter_17",
	"PF_counter_18",
	"PF_counter_19",
	"PF_counter_20",
	"PF_counter_21",
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
  
}

this.SetOccasionalChatList={
	settings=this.ConversationList,
	OnActivate=function(self,setting)
		GameObject.SendCommand( { type="TppCommandPost2" } , { id="SetChatEnable", enabled=true }  ) 
		if mvars.ene_soldierDefine then
			for cpName, soldierList in pairs(mvars.ene_soldierDefine) do
				for i, soldierName in ipairs(soldierList) do
					local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
					local command = { id="SetDisableOccasionalChat", disable=false }
					GameObject.SendCommand( gameObjectId, command )
				  end
			end
		end
		local labelName = self.settings[setting+1]
  		GameObject.SendCommand({type="TppSoldier2"},{id="SetConversationList",list={labelName}})
	end
}

this.MillerVoice={
	-- --・Saying something when the player gets up close (1) 
	-- --UNIQ2100_1i1010 What's up? gq_s7u
	-- "gq_s7u",
	-- --・Saying something when the player gets up close (2)
	-- --UNIQ2100_1j1010 Hm? a8aq7_a
	-- "a8aq7_a",
	
	-- --・Calling out to the player
	-- -- UNIQ2100_1f1010 Hey! 2ffb3bf1.wem 3983588162 afs_j_k
	-- "afs_j_k",
	-- -- UNIQ2100_1g1010 Big Boss. (Eyes meet, and this is said in greeting) 2ffb3bf4.wem 4000365877 i281o9
	-- "i281o9",
	-- -- UNIQ2100_1h1010 You're pretty good. 2ffb3bf7.wem 4017143464 gq_s4s
	-- "gq_s4s",
	
	-- "POWV_0010",
	-- "POWV_0020",
	
	-- "POWV_0070",
	-- "POWV_0100",
	-- "POWV_0110",
	-- "POWV_0120",
	-- "POWV_0130",
	-- "POWV_0140",
	-- "POWV_0150",
	-- "POWV_0160",
	-- "POWV_0170",
	
	-- "POWV_0180",
	-- "POWV_0190",
	-- "POWV_0200",
	-- "POWV_0210",
	-- "POWV_0220",
	-- "POWV_0230",
	
	-- "POWV_0340",
	-- "POWV_0350",
	-- "POWV_0360",
	-- "ocelot_a", -- broken
	"ocelot_b",
	"ocelot_c",
	"ocelot_d",
	"ocelot_e",
	"ocelot_f",
	"ocelot_g",
	"ocelot_h",
	-- 2E1DDED9
	-- 66335F48
	-- E528D345
	"ocelot_aa",
	"ocelot_cqc",
	"ocelot_go_heli",
	-- D6A8D221
	-- D90FCFAE
}

local labels={}
local label="p31_010015_0%02d0"
for i=1,45 do
	table.insert(labels,string.format(label,i))
end

--[[this.CallVoiceOcelot={
	settings=labels,
	OnActivate=function(self,setting)
		GameObject.SendCommand({type="TppOcelot2",index=0},{id="CallVoice",dialogueName="dd_tutr",parameter=self.settings[setting+1]})
	end,
}]]
this.CallVoiceOcelot=function()
	local PDOR_NAME1	 				= "flowStation_pickingDoor_01"		
	local PDOR_NAME2	 				= "flowStation_pickingDoor_02"		
	local FLOWSTATION_GIMMICK_PATH 		= "/Assets/tpp/level/location/mafr/block_large/flowStation/mafr_flowStation_gimmick.fox2"
	TppGimmick.ResetGimmick{ gimmickId = PDOR_NAME1, searchFromSaveData = false }
	TppGimmick.ResetGimmick{ gimmickId = PDOR_NAME2, searchFromSaveData = false }
	TppDataUtility.SetVisibleDataFromIdentifier( "id_before_explosion", "before_explosion", true , true )
	TppDataUtility.SetVisibleDataFromIdentifier( "id_after_explosion" , "after_explosion" , false , true )

	TppDataUtility.SetEnableDataFromIdentifier( "id_after_explosion", "pathWall_0001", false)

	TppDataUtility.SetVisibleEffectFromGroupId( "FxLocatorGroupFlowStationBefore", 	true )
	TppDataUtility.SetVisibleEffectFromGroupId( "FxLocatorGroupFlowStationAfter", 		false )
	
	Gimmick.ForceIndelibleClear(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,"mafr_tank005_gim_n0001|srt_mafr_tank005",FLOWSTATION_GIMMICK_PATH)
	Gimmick.ForceIndelibleClear(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,"mafr_tank003_gim_n0000|srt_mafr_tank003",FLOWSTATION_GIMMICK_PATH)
	Gimmick.ForceIndelibleClear(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,"mafr_tank003_gim_n0001|srt_mafr_tank003",FLOWSTATION_GIMMICK_PATH)
	Gimmick.ForceIndelibleClear(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,"mafr_tank003_gim_n0002|srt_mafr_tank003",FLOWSTATION_GIMMICK_PATH)
	Gimmick.ForceIndelibleClear(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,"mafr_tank005_vrtn006_gim_n0001|srt_mafr_tank005_vrtn006",FLOWSTATION_GIMMICK_PATH)
end

this.registerMenus={
	"PlayRadioMenu",
}

this.PlayRadioMenu={
	parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
	options={
		"RadioTest.PlayRadio",
		"RadioTest.PlayVoice",
		-- "RadioTest.ShowIntelIcon",
		-- "RadioTest.PlaySound3D",
		-- "RadioTest.AddSpecialNoiseAtLastMarker",
		"RadioTest.PlaySupportRadio",
		"RadioTest.CallVoiceOcelot",
		"RadioTest.SetOccasionalChatList",
		"RadioTest.isEnableCode102",
	}
}

function this.Messages()
	return Tpp.StrCode32Table{
		GameObject = {
		},
		Player = {
		},
		Demo = {
		},
		Terminal={
		},
		MotherBaseManagement={
		},
	}
end

function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
	Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText)
end

function this.EnableCode102(isCode102)
	if not IHH then
		InfCore.Log("No IHH")
		return
	end
	if not IHH.EnableCode102 then
		InfCore.Log("No IHH.EnableCode102")
		return
	end
	if isCode102==nil then
		isCode102=this.IsCode102()
	end
	IHH.EnableCode102(isCode102)
end

function this.IsCode102()
	if Ivars.isEnableCode102:Is(1) then
		return true
	end
	return false
end

function this.Init(missionTable)
	this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
	local isCode102=this.IsCode102()
	this.EnableCode102(isCode102)
end

return this