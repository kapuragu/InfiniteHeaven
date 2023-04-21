--PlayerSkillType.lua
--just an (currently incomplete) enum for vars.playerSkillId

--tex DEBUGNOW this is actually just TppMotherBaseManagementConst.STAFF_SKILL_ID_*
--once you start mock modules anotatated, transfer notes to that, and put somewhere, since you don't need it as an actually loaded module

--tex: from designbuildnotes\vars playerSkillId .txt
--see --http://metalgear.wikia.com/wiki/Specialist_Skills_in_Metal_Gear_Solid_V:_The_Phantom_Pain for descriptions
--playerSkills seem to be either for actually playing as that char, or for affecting general mother base stats
--unnacounted for (probably just need to match to the unknowns, choose dd soldiers with the skills and look at vars.playerSkillId)
--also look up the unique staff definitions? (vars playerSkillId .txt again, and wherever it got those from), there's some unnacountet for there (study, lucky etc)
--!! the playable characters OCELOT and QUIET both have playerSkillId 16, which is different thatn their staff skill??

-- Vanguard Sharpshooter  Sniper who can pick off targets from long range and carry out covert scouting missions. (Exclusive to staff Quiet, not deployable quiet?)
--Anesthesia Specialist   When assigned to R&D Team, enables tranquilizer round conversion for handguns and sniper rifles.
--Bipedial Weapons Developer  When assigned to R&D Team, enables development of D-Walker equipment. (Exclusive to Huey Emmerich)
--Counselor   When assigned to Medical Team, recovery speed of staff suffering from PTSD in sickbay increased by 3%; can stack up to ten times for a maximum increase of 30%.
--Cybernetics Specialist  When assigned to R&D Team, enables the development of "Medical" prosthetic arm technology.
--Drug Developer  When assigned to Medical Team, enables the development of Noctocyanin and Acceleramin.
--Electromagnetic Net Specialist  When assigned to R&D Team, enables the development of EMN-Mine.
--Gunsmith (Handguns)   When assigned to R&D Team, GMP required to develop and use Handguns reduced by 3%; can stack up to ten times for a maximum 30% reduction. Also enables development of derivative models.
--Gunsmith (Machine Guns)   When assigned to R&D Team, GMP required to develop and use Machine Guns reduced by 3%; can stack up to ten times for a maximum 30% reduction. Also enables development of derivative models.
--Gunsmith (Missile Launchers)  When assigned to R&D Team, GMP required to develop and use Missile Launchers reduced by 3%; can stack up to ten times for a maximum 30% reduction. Also enables development of derivative models.
--Gunsmith (Submachine Guns)  When assigned to R&D Team, GMP required to develop and use Submachine Guns reduced by 3%; can stack up to ten times for a maximum 30% reduction. Also enables development of derivative models.
--Interpreter (Afrikaans)   When assigned to Support Unit, enables the simultaneous interpretation of Afrikaans.
--Interpreter (Kikongo)   When assigned to Support Unit, enables the simultaneous interpretation of Kikongo.
--Interpreter (Pashto)  When assigned to Support Unit, enables the simultaneous interpretation of Pashto.
--Interpreter (Russian)   When assigned to Support Unit, enables the simultaneous interpretation of Russian.
--Materials Engineer  When assigned to R&D Team, enables development of the Battle Dress and other equipment.
--Mechatronics Specialist   When assigned to R&D Team, enables development of the Precision prosthetic arms and other equipment.
--Metamaterials Specialist  When assigned to R&D Team, enables development of the Stealth Camo.PP and other equipment.
--Missile Guidance Specialist   When assigned to R&D Team, enables the development of the Killer Bee and other equipment.
--Mother Base XO  Positive morale variations are doubled for all members of Miller's team/unit. (Exclusive to Kazuhira Miller)
--Noise Suppression Specialist  When assigned to R&D Team, enables built in suppressor conversion for handguns.
--Parasitologist  When assigned to Medical Team, enables the development of the Parasite Suit. (Exclusive to Code Talker)
--Physician   When assigned to Medical Team, illness recovery speed of sickbay residents increased by 3%; can stack up to ten times for the maximum 30% increase.
--Radar Specialist  When assigned to R&D Team, enables the development of the Active Sonar and other equipment.
--Rocket Control Specialist   When assigned to R&D Team, enables the development of the Rocket prosthetic arms.
--Sleeping Gas Specialist When assigned to R&D Team, enables the development of LLG-Mine and Sleep Grenade.
--Tactical Instructor Negative morale variations are divided by two for all members of Ocelot's team/unit. (Exclusive to staff Ocelot, not deployable ocelot??)
--Transportation Specialist   When assigned to R&D Team, enables the development of the Cargo 2 Fulton upgrade.
--Trap Specialist   When assigned to R&D Team, enables the development of the E-Stun Decoy.
--Troublemaker (Harassment)   Has a 1% chance to cause PTSD to another staff member in the same team six times per day; can be stacked up to ten times (max chance = 10%); only three staff can be affected simultaneously.
--Troublemaker (Unsanitary)   Has a 1% chance to make another staff in the same team ill six times per day; can be stacked up to ten times (max chance = 10%); only three staff can be affected simultaneously.
--Troublemaker (Violence)   Has a 1% chance to injure another staff in the same team six times per day; can be stacked up to ten times (max chance = 10%); only three staff can be affected simultaneously.
--Video Surveillance Specialist   When assigned to R&D Team, enables the development of security devices such as the Surveillance Camera and other equipment.
--Zoologist   When assigned to R&D Team, enables the development of the Bait Bottle.

local this={
  NONE=0,--
  GUNMAN=1,--When deployed as a Combat Unit staff member, Reflex Mode duration increased by 1s when holding a weapon.
  CLIMBER=2,--When deployed as a Combat Unit staff member, movement speed increased by 20% when crawling, hanging and climbing.
  ATHLETE=3,--When deployed as a Combat Unit staff member, movement speed increased by 20% when sprinting, jump distance increased by 20%, and no speed reduction when carrying bodies.
  UNKNOWN4=4,--
  RESCUER=5,--When deployed as a Combat unit staff member, Fulton recovery success rate increased by 20%.
  QUICK_RELOAD=6,--When deployed as a Combat Unit staff member, weapon reload speed increased by 50%.
  TOUGH_GUY=7,--When deployed as a Combat unit staff member, max health increased by 20%.
  FORTUNATE=8,-- snake gets this too (check to see if it's modified by medical arm) -- When deployed as a Combat Unit staff member, serious injury probability reduced by 50%.
  SAVAGE=9,--When deployed as a Combat unit staff member, press the CQC Button while sprinting to unleash a devastating punch.
  BOASTER=10,--Disguises abilities and ratings when scanned with an analyzer (no longer useful once the skill's owner has been recruited).
  BOTANIST=11,--When deployed as a Combat Unit staff member, medicinal plant harvest multiplied by 2.5.
  QUICK_DRAW=12,-- When deployed as a Combat Unit staff member, speed to draw primary weapon doubled.
  UNKNOWN13=13,--
  UNKNOWN14=14,--
  UNKNOWN15=15,-- DEBUGNOW ask shigu
  UNKNOWN16=16,--? deployable ocelott and quiet has this ? - DEBUGNOW ask shigu
  UNKNOWN17=17,--
  UNKNOWN18=18,--
  UNKNOWN19=19,--? DEBUGNOW ask shigu (bigBossOld)
  UNKNOWN20=20,--
  UNKNOWN21=21,--
  UNKNOWN22=22,--
  UNKNOWN23=23,--
  UNKNOWN24=24,--
  GUNSMITH_ASSAULT=25,--Gunsmith (Assault Rifles)
  GUNSMITH_SHOTGUN=26,--Gunsmith (Shotguns)
  GUNSMITH_GRENADE_LAUNCHER=27,--Gunsmith (Grenade Launchers)
  GUNSMITH_SNIPER_RIFLE=28,--Gunsmith (Sniper Rifles)
  UNKNOWN29=29,--
  UNKNOWN30=30,--
  MASTER_GUNSMITH=31,--
  UNKNOWN32=32,-- Tactical Instructor - Ocelot ??? ANETHESIA_SPECIALIST?
  UNKNOWN33=33,--
  UNKNOWN34=34,--
  UNKNOWN35=35,--
  UNKNOWN36=36,--
  TRAP_SPECIALIST=37,--
  UNKNOWN38=38,--
  UNKNOWN39=39,--
  UNKNOWN40=40,--
  UNKNOWN41=41,--
  UNKNOWN42=42,--
  BIONICS_SPECIALIST=43,--
  UNKNOWN44=44,--
  UNKNOWN45=45,--
  UNKNOWN46=46,--
  ELECTROSPINNING_SPECIALIST=47,--
  UNKNOWN48=48,--
  TRANSPORTATION_SPECIALIST=49,--
  UNKNOWN50=50,--
  UNKNOWN51=51,--
  UNKNOWN52=52,--
  UNKNOWN53=53,--
  UNKNOWN54=54,--
  UNKNOWN55=55,--
  UNKNOWN56=56,--
  UNKNOWN57=57,--
  UNKNOWN58=58,--
  SURGEON=59,--
  UNKNOWN60=60,--
  UNKNOWN61=61,--
  UNKNOWN62=62,--
  TROUBLEMAKER_VIOLENCE=63,-- troublemaker (violence)
  UNKNOWN64=64,--
  TROUBLEMAKER_HARASSMENT=65,-- troublemaker (harassment)
  DIPLOMAT=66,--
  UNKNOWN67=67,--
  UNKNOWN68=68,--
  DEFENDER_1=69,-- pf durability stat (defending)
  DEFENDER_2=70,--
  DEFENDER_3=71,--
  SENTRY_1=72,-- pf defense stat
  SENTRY_2=73, --
  SENTRY_3=74, --
  RANGER_1=75, --
  RANGER_2=76, --
  RANGER_3=77, -- pf attack stat
  MEDIC_1=78, -- pf durability (during attack)
  MEDIC_2=79,--
  MEDIC_3=80, -- pf durability (during attack)
  LIQUID_CARBON_MISSILE_ENGINEER_1=81, --
  LIQUID_CARBON_MISSILE_ENGINEER_2=82, --
  LIQUID_CARBON_MISSILE_ENGINEER_3=83, --
  ANTI_BALLISTIC_MISSILE_ENGINEER_1=84,  -- increase attack and durability boost from anti-bal missiles
  ANTI_BALLISTIC_MISSILE_ENGINEER_2=85, --
  ANTI_BALLISTIC_MISSILE_ENGINEER_3=86, --
}--this

--tex build reverse lookup (but cant add to table your iterating without trouble, so put in temp)
local arr={}
for name,enum in pairs(this)do
  arr[enum]=name
end
--then fold back in
for enum,name in ipairs(arr)do
  this[enum]=name
end

return this
