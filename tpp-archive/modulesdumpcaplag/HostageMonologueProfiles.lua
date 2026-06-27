--HostageMonologueProfiles.lua
local this={}

local lngT={
    ["E"]="english",
    ["R"]="russian",
    ["P"]="pashto",
    ["A"]="afrikaans",
    ["K"]="kikongo",
}

local voxT={
    ["a"]="hostage_a",
    ["b"]="hostage_b",
    ["c"]="hostage_c",
    ["d"]="hostage_d",
}


local skills={
    "なし",--0?
    "None",--0
    --physical
    "Reflex",--1 Gunman Reflex Mode duration increased by 1s when holding a weapon.
    "Ninja",--2 Climber movement speed increased by 20% when crawling, hanging and climbing.
    "Athlete",--3 movement speed increased by 20% when sprinting, jump distance increased by 20%, and no speed reduction when carrying bodies.
    "LockSmith",--4 0x543f865eec7b
    "FultonExpert",--5 Rescuer Fulton recovery success rate increased by 20%.
    "QuickReload",--6 weapon reload speed increased by 50%.
    "Study",--Tough Guy max health increased by 20%.
    "Lucky",--Fortunate serious injury probability reduced by 50%.
    "Grappler",--Savage  press the CQC Button while sprinting to unleash a devastating punch.
    "BigMouth",--Boaster Disguises abilities and ratings when scanned with an analyzer
    "Botanist",--0xb medicinal plant harvest multiplied by 2.5.
    "QuickDraw",--0xc speed to draw primary weapon doubled.
    "ScoutSniper",---0xd Vanguard Sharpshooter Quiet
    --bionic upgrades:
    "PhysicalLv1",--0xe    STAFF_SKILL_ID_PHYSICAL_LV1
    "PhysicalLv2",--0xf    STAFF_SKILL_ID_PHYSICAL_LV2
    --0x10 0x51bd8e78287a   STAFF_SKILL_ID_PHYSICAL_LV3
    "PhysicalLv3",--0x10 0x298d9898c24   STAFF_SKILL_ID_PHYSICAL_LV3
    "PrecisionLv1",--0x11    STAFF_SKILL_ID_PRECISION_LV1
    "PrecisionLv2",--0x12   STAFF_SKILL_ID_PRECISION_LV2
    "PrecisionLv3",--0x13   STAFF_SKILL_ID_PRECISION_LV3
    "MedicalLv1",--0x14   STAFF_SKILL_ID_MEDICAL_LV1
    "MedicalLv2",--0x15   STAFF_SKILL_ID_MEDICAL_LV2
    "MedicalLv3",--0x16 0xf821b90857d4   STAFF_SKILL_ID_MEDICAL_LV3
    --develop:
    "GunsmithHandGun",--0x17
    "GunsmithSubmachineGun",
    "GunsmithAssultRifle",
    "GunsmithShotGun",
    "GunsmithGrenadeLauncher",
    "GunsmithSniperRifle",
    "GunsmithMachineGun",
    "GunsmithMissile",--0x1e
    "MasterGunsmith",--enable weapon customization
    "TranqEngineer",--Anesthesia Specialist, tranquilizer round conversion for handguns
    "SuppressorEngineer",--Noise Suppression Specialist, built-in suppressor conversion for handguns
    "MissileHomingEngineer",--Missile Guidance Specialist, [KILLER BEE] missile launcher and other equipment
    "Zoologist",--[BAIT BOTTLE] support weapon
    "SleepingGasEngineer",--0x24 [LLG-MINE] support weapon and other equipment
    "ElectricEngineer",--0x25 Trap Specialist [E-STUN DECOY] support weapon
    "ElectromagneticNetEngineer",--0x26 Electromagnetic Net [EMN-MINE] support weapon
    "WaterproofEngineer",--0x27     STAFF_SKILL_ID_WATERPROOF_ENGINEER
    "RadarEngineer",--0x28 [+ ACTIVE SONAR] prosthesis and other equipment
    "MetamaterialEngineer",--0x29 [STEALTH CAMO.PP] item and other equipment
    "DrugEngineer",--[NOCTOCYANIN] item and other equipment
    "MechanicalEngineer",--0x2b Bionics Specialist prosthetic arms
    "MechatronicsEngineer",--Mechatronics Specialist [+ PRECISION 1] prosthesis and other equipment
    "CyberneticsEngineer",--Cybernetics Specialist [+ MEDICAL 1] prosthesis
    "RocketControlEngineer",--[ROCKET ARM] prosthesis
    "ElectricSpinningEngineer",--[SNEAKING (KNIFE)] D-Dog equipment and other equipment
    "MaterialEngineer",--0x30 [BATTLE DRESS] uniform and other equipment
    "HaulageEngineer",--0x31 [+ CARGO 2] tool and other equipment
    "RemoteControlEngineer",--0x32   STAFF_SKILL_ID_REMOTE_CONTROL_ENGINEER
    "MonitorEngineer",--0x33 Video Surveillance Specialist [SURVEILLANCE-CAM] security device and other equipment
    "ActiveProtectEngineer",--0x34   STAFF_SKILL_ID_ACTIVE_PROTECT_ENGINEER
    "AttitudeControlEngineer",--0x35   STAFF_SKILL_ID_ATTITUDE_CONTROL_ENGINEER
    "BipedalismWeaponDevelopment",--0x36 Huey
    --support:
    "TranslateRussian",--0x37
    "TranslateAfrikaans",--0x38
    "TranslateKikongo",--0x39
    "TranslatePashto",--0x3a
    --medical:
    --sevice
    "Surgeon",--0x3b 
    "Physician",--0x3c 
    "Counselor",--0x3d
    "ParasiteReseacher",--0x3e Parasitologist [PARASITE SUIT] uniform and other equipment
    "TroublemakerViolence",--0x3f
    "TroublemakerIntemperately",--0x40 Troublemaker (Unsanitary)
    "TroublemakerHarassment",--0x41
    "Moodmaker",--Diplomat 0x42
    "TacticsInstructor",--0x43 Ocelot
    "MBViceCommander",--0x44 Miller
    --retailpatch new
    "Defender1",
    "Defender2",
    "Defender3",
    "Sentry1",
    "Sentry2",
    "Sentry3",
    "Ranger1",
    "Ranger2",
    "Ranger3",
    "Medic1",
    "Medic2",
    "Medic3",
    "LiquidCarbonMissileEngineer1",
    "LiquidCarbonMissileEngineer2",
    "LiquidCarbonMissileEngineer3",
    "InterceptorMissileEngineer1",
    "InterceptorMissileEngineer2",
    "InterceptorMissileEngineer3",
}

--staffTypeIds focusing on specific sections
local staffTypeIdGroups={
    [TppDefine.STAFF_TYPE_ID.SPY]={
        6,--spy100
        14,--spy100_combat90
        15,--spy100_develop90
        16,--spy100_baseDev90
        34,--spy95_combat85_medical_support80
        54,--spy120_baseDev100
        56,--spy120_medical110
        57,--spy120_combat100
        58,--spy120_support100
    },
    [TppDefine.STAFF_TYPE_ID.DEVELOP]={
        3,--develop100
        11,--develop100_baseDev90
        12,--develop100_support90
        13,--develop100_medical90
        30,--develop100_medical_support_spy80
        42,--develop120_combat100
        43,--develop120_baseDev100
        43,--develop120_baseDev100
        44,--develop120_support100
        45,--develop120_medical100
    },
    [TppDefine.STAFF_TYPE_ID.COMBAT]={
        2,--combat100
        8,--combat100_develop90
        9,--combat100_spy90
        10,--combat100_medical90
        31,--combat100_medical_support_spy80
        39,--combat120_medical100
        40,--combat120_support100
        41,--combat120_spy100
        47,--combat120_baseDev100
    },
    [TppDefine.STAFF_TYPE_ID.BASE_DEV]={
        4,--baseDev100
        17,--baseDev100_support90
        18,--baseDev100_spy90
        19,--baseDev100_medical90
        32,--baseDev100_medical_support_spy80
        46,--baseDev120_develop100
        48,--baseDev120_support100
        49,--baseDev120_spy100
        50,--baseDev120_medical100
        51,--baseDev120_combat100
    },
    [TppDefine.STAFF_TYPE_ID.MEDICAL]={
        7,--medical100
        23,--medical100_combat90
        24,--medical100_baseDev90
        25,--medical100_support90
        35,--medical95_baseDev85_support_spy80
        38,--medical120_support100
        55,--medical120_spy100
        60,--medical120_combat100
        61,--medical120_develop100
        62,--medical120_baseDev100
    },
    [TppDefine.STAFF_TYPE_ID.SUPPORT]={
        5,--support100
        20,--support100_combat90
        21,--support100_develop90
        22,--support100_spy90
        33,--support95_develop85_medical_spy80
        52,--support120_combat100
        53,--support120_spy100
    },
}

local randomRanges={
    --from lowest to highest medium in ranges
    --[[ {randomRangeId=0,minRate=20,maxRate=40},20 30
    {randomRangeId=1,minRate=10,maxRate=35},25 22.5
    {randomRangeId=2,minRate=40,maxRate=60},20 50
    {randomRangeId=3,minRate=50,maxRate=95},45 72.5
    {randomRangeId=4,minRate=30,maxRate=80},50 55
    {randomRangeId=5,minRate=35,maxRate=80},45 57.5
    {randomRangeId=6,minRate=75,maxRate=95},20 85
    {randomRangeId=7,minRate=10,maxRate=35},15 17 ]]
    7, 1, 0, 2, 4, 5, 3, 6
}--randomRanges

local raceGroups={
    [lngT.E]={
        TppDefine.QUEST_RACE_TYPE.CAUCASIAN,
        TppDefine.QUEST_RACE_TYPE.ASIA,
        TppDefine.QUEST_RACE_TYPE.BROWN,
        TppDefine.QUEST_RACE_TYPE.BLACK,
    },
    [lngT.R]={
        TppDefine.QUEST_RACE_TYPE.CAUCASIAN,
        TppDefine.QUEST_RACE_TYPE.ASIA,
        TppDefine.QUEST_RACE_TYPE.BROWN,
    },
    [lngT.P]=TppDefine.QUEST_RACE_TYPE.BROWN,
    [lngT.A]={
        TppDefine.QUEST_RACE_TYPE.BLACK,
        TppDefine.QUEST_RACE_TYPE.BROWN,
    },
    [lngT.K]=TppDefine.QUEST_RACE_TYPE.BLACK,
}

local lblF="speech_generic_carry_"

--■Special prisoners
this.hostageProfiles={
    --●NPC lines: Male, English-speaking special prisoners
    {
        --・CIA-related personnel (Common between Afghanistan and Africa. Has Intel skills.)
        langType=lngT.E, voiceType=voxT.a,
        sections=TppDefine.STAFF_TYPE_ID.SPY,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.SPY],
        labelForm=lblF.."en00_%02d", labelCount=9
        --Tell you the truth, I'm an agent on the CIA payroll. Was, anyway.
    },
    {
        --・Researcher (For use in Afghanistan. Born in the West, he defected to the Soviet Union, but was imprisoned. Has R&D skills.)
        langType=lngT.E, voiceType=voxT.b,
        sections=TppDefine.STAFF_TYPE_ID.DEVELOP,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.DEVELOP],
        labelForm=lblF.."en01_%02d", labelCount=10,
        race=TppDefine.QUEST_RACE_TYPE.CAUCASIAN,
        locations=TppDefine.LOCATION_ID.AFGH,
        area="sovietBase"
        --I'm from West Germany, you know.
    },
    {
        --・Researcher (For use in Africa. Has R&D skills.)
        langType=lngT.E, voiceType=voxT.b,
        sections=TppDefine.STAFF_TYPE_ID.DEVELOP,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.DEVELOP],
        labelForm=lblF.."en02_%02d", labelCount=8,
        race=TppDefine.QUEST_RACE_TYPE.CAUCASIAN,
        locations=TppDefine.LOCATION_ID.MAFR
        --I'm Israeli by birth, you see...
    },
    {
        --・Mercenary (For use in Afghanistan. Has Combat skills.)
        langType=lngT.E, voiceType=voxT.c,
        sections=TppDefine.STAFF_TYPE_ID.COMBAT,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.COMBAT],
        labelForm=lblF.."en03_%02d", labelCount=9,
        locations=TppDefine.LOCATION_ID.AFGH
        --I came to Afghanistan as a volunteer. Got lots of help from you Americans.
    },
    {
        --・Mercenary (For use in Africa. Has high combat abilities, but was being held captive by an enemy PF. Has Combat skills.)
        langType=lngT.E, voiceType=voxT.c,
        sections=TppDefine.STAFF_TYPE_ID.COMBAT,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.COMBAT],
        labelForm=lblF.."en04_%02d", labelCount=10,
        locations=TppDefine.LOCATION_ID.MAFR
        --20 years now - ever since the Congo Crisis.
    },
    {
        --・Resource developer (For use in Afghanistan. Has Resource Development skills.)
        langType=lngT.E, voiceType=voxT.d,
        sections=TppDefine.STAFF_TYPE_ID.BASE_DEV,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.BASE_DEV],
        labelForm=lblF.."en05_%02d", labelCount=8,
        locations=TppDefine.LOCATION_ID.AFGH
        --I was working as a drilling technician on Saudi Arabian oil interests.
    },
    {
        --・Resource developer (For use in Africa. Had come to Africa to work on resource development. Has Resource Development skills.)
        langType=lngT.E, voiceType=voxT.d,
        sections=TppDefine.STAFF_TYPE_ID.BASE_DEV,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.BASE_DEV],
        labelForm=lblF.."en06_%02d", labelCount=10,
        locations=TppDefine.LOCATION_ID.MAFR
        --I came here to design a drilling plant for a British oil and gas firm.
    },

    --●NPC lines: Female, English-speaking special prisoners
    {
        --・CIA-related (Has Intel skills.) 
        f=true, voiceType=voxT.a,
        sections=TppDefine.STAFF_TYPE_ID.SPY,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.SPY],
        labelForm=lblF.."en07_%02d", labelCount=10
        --(giggles)You know, that horn's real cute up close.
    },
    {
        --・Doctor (Came to help the locals, but got captured. Has Medical skills.)
        f=true, voiceType=voxT.b,
        sections=TppDefine.STAFF_TYPE_ID.MEDICAL,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.MEDICAL],
        labelForm=lblF.."en08_%02d", labelCount=8
        --I could've gone to any of a dozen research labs, but I thought my calling was to help people in need...
    },
    {
        --・NGO member who came to give aid to local women (Has Support skills.)
        f=true, voiceType=voxT.c,
        sections=TppDefine.STAFF_TYPE_ID.SUPPORT,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.SUPPORT],
        labelForm=lblF.."en09_%02d", labelCount=12
        --No one here gives a damn about women's rights...
    },
    {
        --・Researcher (Came to conduct research on medicinal plants. Has Medical skills.)
        f=true, voiceType=voxT.d,
        sections=TppDefine.STAFF_TYPE_ID.MEDICAL,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.MEDICAL],
        skill="Botanist",
        labelForm=lblF.."en10_%02d", labelCount=9
        --This region is rich in medicinal plant life.
    },

    --●NPC lines: Afrikaans special prisoners
    {
        --・Mercenary (Has high combat abilities, but was being held captive by an enemy PF. Has Combat skills.)
        langType=lngT.A, voiceType=voxT.a,
        sections=TppDefine.STAFF_TYPE_ID.COMBAT,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.COMBAT],
        labelForm=lblF.."af00_%02d", labelCount=10,
        locations=TppDefine.LOCATION_ID.MAFR
        --Believe it or not, I used to be in the Rhodesian SAS.
    },
    {
        --・Resource developer (Had come to Africa to work on resource development. Has Resource Development skills.)
        langType=lngT.A, voiceType=voxT.b,
        sections={TppDefine.STAFF_TYPE_ID.BASE_DEV,TppDefine.STAFF_TYPE_ID.DEVELOP},
        staffTypeIds={
            46,--baseDev120_develop100
        },
        labelForm=lblF.."af01_%02d", labelCount=9,
        locations=TppDefine.LOCATION_ID.MAFR,
        area="flowStation",
        --I headed up design of large-scale plants for a South African construction company.
    },
    {
        --・NGO worker (Has Support skills.)
        langType=lngT.A, voiceType=voxT.a,
        sections=TppDefine.STAFF_TYPE_ID.SUPPORT,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.SUPPORT],
        labelForm=lblF.."af02_%02d", labelCount=7,
        locations=TppDefine.LOCATION_ID.MAFR,
        area="outland"
        --I work for a UN NGO. I was here conducting a survey of the child soldiers.
    },
    {
        --・Doctor (Has Medical skills.)
        langType=lngT.A, voiceType=voxT.b,
        sections=TppDefine.STAFF_TYPE_ID.MEDICAL, skill="Surgeon",
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.MEDICAL],
        labelForm=lblF.."af03_%02d", labelCount=8,
        locations=TppDefine.LOCATION_ID.MAFR,
        area="factory"
        --You'd never know from this getup, but I used to be an army field surgeon.
    },

    --●NPC lines: Pashto-speaking special prisoners
    {
        --・Engineer from Pakistan (Has R&D skills) 
        langType=lngT.P, voiceType=voxT.a,
        sections=TppDefine.STAFF_TYPE_ID.DEVELOP,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.DEVELOP],
        labelForm=lblF.."ps00_%02d", labelCount=10,
        locations=TppDefine.LOCATION_ID.AFGH,
        area="citadel"
        --I was a nuclear weapons researcher in Pakistan.
    },
    {
        --・From Afghanistan (Has Combat skills)
        langType=lngT.P, voiceType=voxT.b,
        sections=TppDefine.STAFF_TYPE_ID.COMBAT,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.COMBAT],
        labelForm=lblF.."ps01_%02d", labelCount=10,
        locations=TppDefine.LOCATION_ID.AFGH
        --I've fought to defend this country ever since they invaded.
    },
    {
        --・From Saudi Arabia, combat support (Has Support skills)
        langType=lngT.P, voiceType=voxT.a,
        sections=TppDefine.STAFF_TYPE_ID.SUPPORT,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.SUPPORT],
        labelForm=lblF.."ps02_%02d", labelCount=9,
        locations=TppDefine.LOCATION_ID.AFGH
        --Me? I came from Saudi Arabia. I used to be in the military.
    },
    {
        --・From Pakistan (Has Intel skills)
        langType=lngT.P, voiceType=voxT.b,
        sections=TppDefine.STAFF_TYPE_ID.SPY,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.SPY],
        labelForm=lblF.."ps03_%02d", labelCount=9,
        locations=TppDefine.LOCATION_ID.AFGH
        --And Pakistan has its own little intelligence agency, as well.
    },

    --●NPC lines: Russian-speaking special prisoners
    {
        --・Doctor (Field medic; he was charged with aiding the enemy for treating a mujahid. Has Medical skills) 
        langType=lngT.R, voiceType=voxT.a,
        sections=TppDefine.STAFF_TYPE_ID.MEDICAL,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.MEDICAL],
        labelForm=lblF.."ru00_%02d", labelCount=10,
        locations=TppDefine.LOCATION_ID.AFGH,
        area="tent"
        --I am a Soviet field medic - I am your enemy.
    },
    {
        --・KGB agent (Imprisoned for being a double agent. Has Intel skills)
        langType=lngT.R, voiceType=voxT.b,
        sections=TppDefine.STAFF_TYPE_ID.SPY,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.SPY],
        labelForm=lblF.."ru01_%02d", labelCount=10,
        locations=TppDefine.LOCATION_ID.AFGH,
        area="commFacility"
        --I am Tsentr - KGB. But I started passing information to the Company.
    },

    --●NPC lines: Kikongo-speaking special prisoners
    {
        --・Mercenary (High combat ability, but was captured by an enemy PF. Has Combat Support skills)
        langType=lngT.K, voiceType=voxT.a,
        sections={TppDefine.STAFF_TYPE_ID.SUPPORT,TppDefine.STAFF_TYPE_ID.COMBAT},
        staffTypeIds={
            20,--support100_combat90
            52,--support120_combat100
        },
        labelForm=lblF.."kg00_%02d", labelCount=10,
        locations=TppDefine.LOCATION_ID.MAFR
        --I worked mainly as... logistical support, though in the field, I'm the guy you want watching your back.
    },
    {
        --・Mining engineer (Has Base Development skills)
        langType=lngT.K, voiceType=voxT.b,
        sections=TppDefine.STAFF_TYPE_ID.BASE_DEV,
        staffTypeIds=staffTypeIdGroups[TppDefine.STAFF_TYPE_ID.BASE_DEV],
        labelForm=lblF.."kg01_%02d", labelCount=10,
        locations=TppDefine.LOCATION_ID.MAFR,
        area="diamond"
        --I am a mining engineer from Zaire. I was once in charge of a mining team at Shinkolobwe...
    },
}

return this