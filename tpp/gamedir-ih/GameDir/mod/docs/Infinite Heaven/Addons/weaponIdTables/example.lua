--example.lua
--example weaponIdTable addon
--should install addon to mod\weaponIdTables\
--selected in game by weaponTableGlobal<missionMode> - Global soldier weapon table in Free/Mission/MB 
--via Enemy Prep menu > Custom soldier equip menu

--REF see TppEnemy.weaponIdTable for default table

local this={
  description="Example weaponIdTable",
}

this.weaponIdTable={
  SOVIET_A={
    NORMAL={
      HANDGUN=TppEquip.EQP_WP_West_hg_030,--geist p3 machine pistol grade 4 - shows shotgun icon but clearly isnt,
      SMG=TppEquip.EQP_WP_West_sm_01b,
      ASSAULT=TppEquip.EQP_WP_West_ar_05b,
      SNIPER=TppEquip.EQP_WP_EX_sr_000,--molotok-68 grade 9
      SHOTGUN=TppEquip.EQP_WP_Com_sg_018,
      MG=TppEquip.EQP_WP_West_mg_03b,--alm48 flashlight grade 4 --TppEquip.EQP_WP_West_mg_037,
      MISSILE=TppEquip.EQP_WP_Com_ms_02b,
      SHIELD=TppEquip.EQP_SLD_DD_01,
    },
  },--SOVIET_A
  PF_A={
    NORMAL={
      HANDGUN=TppEquip.EQP_WP_West_hg_030,--geist p3 machine pistol grade 4 - shows shotgun icon but clearly isnt,
      SMG=TppEquip.EQP_WP_West_sm_01b,
      ASSAULT=TppEquip.EQP_WP_West_ar_05b,
      SNIPER=TppEquip.EQP_WP_EX_sr_000,--molotok-68 grade 9
      SHOTGUN=TppEquip.EQP_WP_Com_sg_018,
      MG=TppEquip.EQP_WP_West_mg_03b,--alm48 flashlight grade 4 --TppEquip.EQP_WP_West_mg_037,
      MISSILE=TppEquip.EQP_WP_Com_ms_02b,
      SHIELD=TppEquip.EQP_SLD_DD_01,
    },
  },--PF_A
  PF_B={
    NORMAL={
      HANDGUN=TppEquip.EQP_WP_West_hg_030,--geist p3 machine pistol grade 4 - shows shotgun icon but clearly isnt,
      SMG=TppEquip.EQP_WP_West_sm_01b,
      ASSAULT=TppEquip.EQP_WP_West_ar_05b,
      SNIPER=TppEquip.EQP_WP_EX_sr_000,--molotok-68 grade 9
      SHOTGUN=TppEquip.EQP_WP_Com_sg_018,
      MG=TppEquip.EQP_WP_West_mg_03b,--alm48 flashlight grade 4 --TppEquip.EQP_WP_West_mg_037,
      MISSILE=TppEquip.EQP_WP_Com_ms_02b,
      SHIELD=TppEquip.EQP_SLD_DD_01,
    },
  },--PF_B
  PF_C={
    NORMAL={
      HANDGUN=TppEquip.EQP_WP_West_hg_030,--geist p3 machine pistol grade 4 - shows shotgun icon but clearly isnt,
      SMG=TppEquip.EQP_WP_West_sm_01b,
      ASSAULT=TppEquip.EQP_WP_West_ar_05b,
      SNIPER=TppEquip.EQP_WP_EX_sr_000,--molotok-68 grade 9
      SHOTGUN=TppEquip.EQP_WP_Com_sg_018,
      MG=TppEquip.EQP_WP_West_mg_03b,--alm48 flashlight grade 4 --TppEquip.EQP_WP_West_mg_037,
      MISSILE=TppEquip.EQP_WP_Com_ms_02b,
      SHIELD=TppEquip.EQP_SLD_DD_01,
    },
  },--PF_C
  SKULL_CYPR={
    NORMAL={
      HANDGUN=TppEquip.EQP_WP_West_hg_020,
      SMG=TppEquip.EQP_WP_East_sm_030
    }
  },--SKULL_CYPR
  SKULL={
    NORMAL={
      HANDGUN=TppEquip.EQP_WP_West_hg_030,--geist p3 machine pistol grade 4 - shows shotgun icon but clearly isnt,
      SMG=TppEquip.EQP_WP_West_sm_01b,
      ASSAULT=TppEquip.EQP_WP_West_ar_05b,
      SNIPER=TppEquip.EQP_WP_EX_sr_000,--molotok-68 grade 9
      SHOTGUN=TppEquip.EQP_WP_Com_sg_018,
      MG=TppEquip.EQP_WP_West_mg_03b,--alm48 flashlight grade 4 --TppEquip.EQP_WP_West_mg_037,
      MISSILE=TppEquip.EQP_WP_Com_ms_02b,
      SHIELD=TppEquip.EQP_SLD_DD_01,
    },
  },--SKULL
  CHILD={
    NORMAL={
      HANDGUN=TppEquip.EQP_WP_East_hg_010,
      ASSAULT=TppEquip.EQP_WP_East_ar_020
    }
  }--CHILD
}--weaponIdTable

return this