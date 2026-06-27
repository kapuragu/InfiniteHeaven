local this={}

--from tpprng RngDefine

--RENlang enum
this.HOS_LANG={
    LOCATION=0,--unused, GetHostageLangAtMissionId defaults to 1 and 0 is only mentioned by absence in SetHostageFaceTable, else checks location and all are white except africa where its black
	ENGLISH=1,--ASIAN SOME WHITE default
	RUSSIAN=2, --WHITE
	KIKONGO=3, --BLACK
	PASHTO=4, --BROWN
	AFRIKAANS=5, --BLACK SOME WHITE
	PASHTO_RUSSIAN=6, --WHITE BROWN
}

this.staffTypeIdsEnum={
    --all 0 stats
    all0=1,
    --pure 100 stats
    combat100=2,-- S10020_ENEMY_BASE_COMMANDER S10020_DRIVER S10036_COMMANDER 
    --S10040_ENEMY_02 S10041_FIELD_COMMANDER S10041_FIELD_BODYGUARD S10044_CLIFFTOWN_HOSTAGE 
    --10052 HOSTAGE_01 S10091_EXECUTEUNIT_A S10093_ZRS_CAPTAIN S10120_OUTLAND_HOSTAGE S10171_BONUS_SOLIDER
    --S10211_BODYGUARD_01 QUEST_HOSTAGE_R_02 S10043_HOSTAGE_A
    develop100=3,-- S10033_TARGET_HOSTAGE S10041_ENEMY_BASE_DRIVER S10045_HOSTAGE_A 
    --S10045_HOSTAGE_B 10052 HOSTAGE_04 S10054_HOSTAGE_01 S10054_HOSTAGE_06 
    --S10080_ENGINEER S10082_HOSTAGE_A S10091_SWAMPNEAR_HOSTAGE S10121_WEAPON_DEALER 
    --S10156_HOSTAGE S10195_TRACER S10195_HOSTAGE S10200_BONUS_HOSTAGE
    baseDev100=4,-- S10082_HOSTAGE_B
    support100=5,-- S10040_ENEMY_01 S10043_HOSTAGE_B S10041_ENEMY_BASE_COMMANDER S10086_INTERPRETER S10195_TARGET
    spy100=6,-- 10052 HOSTAGE_02 S10086_HOSTAGE_A
    medical100=7,-- QUEST_HOSTAGE_R_01
    --100 and 90 stats
    --combat stats
    combat100_develop90=8,--
    combat100_spy90=9,
    combat100_medical90=10,-- S10040_ENEMY_03
    --develop stats
    develop100_baseDev90=11,--
    develop100_support90=12,-- S10054_HOSTAGE_03
    develop100_medical90=13,--
    --spy stats
    spy100_combat90=14,--
    spy100_develop90=15,-- S10041_VILLAGE_COMMANDER
    spy100_baseDev90=16,--
    --baseDev stats
    baseDev100_support90=17,--
    baseDev100_spy90=18,
    baseDev100_medical90=19,--
    --support stats
    support100_combat90=20,--
    support100_develop90=21,
    support100_spy90=22,--
    --medical stats
    medical100_combat90=23,--
    medical100_baseDev90=24,
    medical100_support90=25,--
    --100 triple 80 stats
    develop100_medical_support_spy80=30,--
    combat100_medical_support_spy80=31,--
    baseDev100_medical_support_spy80=32,--
    --95 85 double 80 stats
    support95_develop85_medical_spy80=33,--
    spy95_combat85_medical_support80=34,--
    medical95_baseDev85_support_spy80=35,--
    --120 100 stats, missions and quests
    medical120_support100=38,--
    combat120_medical100=39,--
    combat120_support100=40,-- - S10091_EXECUTEUNIT_B
    combat120_spy100=41,-- - S10041_ENEMY_BASE_BODYGUARD S10054_HOSTAGE_02 S10115_MOSQUITO S10121_PF_OPERATOR
    develop120_combat100=42,-- - S10086_HOSTAGE_C
    develop120_baseDev100=43,-- - S10086_HOSTAGE_B QUEST_HOSTAGE_SR_02
    develop120_support100=44,-- - S10086_HOSTAGE_D
    develop120_medical100=45,-- - S10052_MALAK
    baseDev120_develop100=46,-- - S10033_HOSTAGE S10200_TARGET_HOSTAGE
    combat120_baseDev100=47,--
    baseDev120_support100=48,-- - S10091_TRUCK_DRIVER
    baseDev120_spy100=49,-- - 10052 HOSTAGE_03
    baseDev120_medical100=50,-- - 10052 HOSTAGE_05 S10211_HOSTAGE_C
    baseDev120_combat100=51,-- - S10211_BODYGUARD_03
    support120_combat100=52,-- - S10044_CLIFFTOWN_VIP S10052_DRIVER S10211_BODYGUARD_02
    support120_spy100=53,-- - S10211_HOSTAGE_D
    spy120_baseDev100=54,--
    medical120_spy100=55,--
    --120 110 stats
    spy120_medical110=56,-- - S10045_HOSTAGE_TARGET S10211_TRAFFICKER
    --120 100 stats
    spy120_combat100=57,-- - S10045_EXECUTION S10211_BODYGUARD_05
    spy120_support100=58,-- - S10041_FIELD_DRIVER S10100_BANANA_TARGET
    --120 100 stats
    medical120_combat100=60,-- - S10054_HOSTAGE_05 S10211_BODYGUARD_04 QUEST_HOSTAGE_SR_01
    medical120_develop100=61,-- - S10054_HOSTAGE_04 S10085_HOSTAGE S10085_FEMALE_HOSTAGE
    medical120_baseDev100=62,-- - S10041_HOSTAGE_A S10041_HOSTAGE_B S10211_HOSTAGE_B
}

return this