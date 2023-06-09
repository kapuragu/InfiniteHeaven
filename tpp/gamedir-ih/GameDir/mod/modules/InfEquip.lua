-- InfEquip.lua
-- tex implements equipment on trucks, soldier item dropping,

local this={}

local InfCore=InfCore
local InfMain=InfMain
local GetGameObjectId=GameObject.GetGameObjectId
local NULL_ID=GameObject.NULL_ID

this.packages={
  "/Assets/tpp/pack/mission2/ih/ih_pickable_loc.fpk",
}

this.debugModule=false

--STATE
--soldier item drops
this.inf_lastNeutralized={}--tex actually next can drop time
--this.inf_dropQueue={}
this.currentLoadTable={}

function this.PostModuleReload(prevModule)
  this.currentLoadTable=prevModule.currentLoadTable
end--PostModuleReload

--TUNE
local dropTimeOut=7*60
local dropTimer=0.6

this.perSoldierCount=10

this.tppEquipTableTest={

    --"EQP_WP_West_thg_010",--wu s.pistol grade 1
   -- "EQP_WP_West_thg_020",--grade 2
    --"EQP_WP_West_thg_030",--wu s pistol inf supressor grade 5
    --"EQP_WP_West_thg_040",--grade 5
--"EQP_WP_West_thg_050",--wu s pistol cb grade7

--  "EQP_IT_Stealth",
--  "EQP_IT_Nvg",
--
--  "EQP_IT_ParasiteMist",
--  "EQP_IT_ParasiteCamouf",
--  "EQP_IT_ParasiteHard",
--  "EQP_IT_InstantStealth",
--  "EQP_IT_Pentazemin",
--  "EQP_IT_Clairvoyance",
--  "EQP_IT_ReflexMedicine",

-- "EQP_SLD_SV",
--  "EQP_SLD_PF_00",
--  "EQP_SLD_PF_01",
--  "EQP_SLD_PF_02",
--  "EQP_SLD_DD",
--  "EQP_SLD_DD_G02",
--  "EQP_SLD_DD_G03",
--  "EQP_SLD_DD_01",
--  "EQP_WP_West_hg_010",--AM D114 grade 1 -- PFs and DD hangun
--  "EQP_WP_West_hg_010_WG",--no name/icon/drop model
--  "EQP_WP_West_hg_020",--AM D114 with silencer(on icon) but no ext mag?  grade 4, skull normal strong
--  "EQP_WP_West_hg_030",--geist p3 - shows shotgun icon but clearly isnt, machine pistol grade 4
--  "EQP_WP_West_hg_030_cmn",--as above, no name/icon
--  "EQP_WP_East_hg_010",--burkov grade 1, sov normal strong
--  "EQP_WP_West_thg_010",--wu s.pistol grade 1
--  "EQP_WP_West_thg_020",--grade 2
--  "EQP_WP_West_thg_030",--wu s pistol inf supressor grade 5
--  "EQP_WP_West_thg_040",--grade 5
--  "EQP_WP_West_thg_050",--wu s pistol cb grade7
--  "EQP_WP_EX_hg_000",--AM A114 RP grade 7 - silencer, gas cloud
--  "EQP_WP_EX_hg_000_G01",--AM A114 RP grade 8 - silencer, gas cloud
--  "EQP_WP_EX_hg_000_G02",--AM A114 RP grade 9 - silencer, gas cloud
--  "EQP_WP_EX_hg_000_G03",
--  "EQP_WP_EX_hg_000_G04",
--  "EQP_WP_EX_hg_010",--tornado 6 grade 3
--  "EQP_WP_EX_hg_011",--tornado 6 grade 5
--  "EQP_WP_EX_hg_012",--tornado 6 grade 6
--  "EQP_WP_EX_hg_013",--tornado 6 grade 7
--  "EQP_WP_West_sm_010",--ze'ev cs grade 3 pf normal, dd min grade
--  "EQP_WP_West_sm_010_WG",--as above, no icon/name
--  "EQP_WP_West_sm_020",--macht 37 grade 3, pf strong, skull normal strong
--  "EQP_WP_East_sm_010",--sz 336 grade 3, sov normal
--  "EQP_WP_East_sm_020",--sz 336 cs grade 5, sov strong
--  "EQP_WP_East_sm_030",--sz 336 cs grade 3 light, supressor, skull cypr normal
--  "EQP_WP_West_sm_014",--zeeve model, big scope no icon/name, supressor, DD icon backing
--  "EQP_WP_West_sm_015",--as above
--  "EQP_WP_West_sm_016",--loads, but missing icons and some blacked out sights DD backing, DD weapon table
--  "EQP_WP_West_sm_017",--<
--  "EQP_WP_West_sm_019",
--  "EQP_WP_West_sm_01a",
--  "EQP_WP_West_sm_01b",
--  "EQP_WP_East_sm_042",--riot smg stn grd 1 stun
--  "EQP_WP_East_sm_043",
--  "EQP_WP_East_sm_044",
--  "EQP_WP_East_sm_045",
--  "EQP_WP_East_sm_047",
--  "EQP_WP_East_sm_049",
--  "EQP_WP_East_sm_04a",
--  "EQP_WP_East_sm_04b",
--  "EQP_WP_Com_sg_010",--s1000 grade 2
--  "EQP_WP_Com_sg_011",--s1000 cs grade 2, most normal shotty, sov a, pfs, skull, dd min
--  "EQP_WP_Com_sg_011_FL",--as above, flashlight ?
--  "EQP_WP_Com_sg_013",--? mag shotgun no name no icon
--  "EQP_WP_Com_sg_015",--above + scope, light
--  "EQP_WP_Com_sg_020",--kabarga 83, grade 4, looks like same model as 013,14
--  "EQP_WP_Com_sg_020_FL",--as abovem flashlight ?
--  "EQP_WP_Com_sg_016",
--  "EQP_WP_Com_sg_018",
--  "EQP_WP_Com_sg_023",--s1000 air-s stn at least icon grade 3 - icon shows slilencer scope but not in game
--  "EQP_WP_Com_sg_024",--as above, light ?
--  "EQP_WP_Com_sg_025",--as above
--  "EQP_WP_Com_sg_030",--s1000 air-s cs grade 6
--  "EQP_WP_Com_sg_038",--loads, but missing icons and some blacked out sights
--  "EQP_WP_West_ar_010",--AM MRS 4r Grade 3, pfs normal, dd 3rd
--  "EQP_WP_West_ar_010_FL",--flashlight
--  "EQP_WP_West_ar_020",--un arc cs grade 3 PF strong
--  "EQP_WP_West_ar_020_FL",--flashlight
--  "EQP_WP_West_ar_030",--un arc pt cs flashlight scope laser, skull normal and strong
--  "EQP_WP_East_ar_010",--svg 76 grade 1, soviet normal
--  "EQP_WP_East_ar_010_FL",--+flashlight
--  "EQP_WP_East_ar_020",--svg 67 cs grade 4, child
--  "EQP_WP_East_ar_030",--above grade 6, sov strong
--  "EQP_WP_East_ar_030_FL",--+ flashlight
--  "EQP_WP_West_ar_040",--am mrs 4 grade 1
--  "EQP_WP_West_ar_042",--above + supressor scope
--  "EQP_WP_West_ar_055",--scope, no icon name
--  "EQP_WP_West_ar_050",--am mrs 4r grade 5 scope laser
--  "EQP_WP_West_ar_057",--loads, but missing icons and some blacked out sights
--  "EQP_WP_West_ar_059",
--  "EQP_WP_West_ar_05a",
--  "EQP_WP_West_ar_05b",
--  "EQP_WP_West_ar_079",
--  "EQP_WP_West_ar_07a",
--  "EQP_WP_West_ar_07b",
--  "EQP_WP_West_ar_060",--un arc nl stn grade 2
--  "EQP_WP_West_ar_063",--above + scope no icon name
--  "EQP_WP_West_ar_070",--un arc nl stn light grade 4
--  "EQP_WP_West_ar_075",--above + supressor
--  "EQP_WP_West_ar_077",
--  "EQP_WP_West_sr_010",--m2000 d grade 2
--  "EQP_WP_West_sr_011",--PF normal, DD
--  "EQP_WP_East_sr_011",--sov a normal
--  "EQP_WP_East_sr_020",--sov a strong
--  "EQP_WP_EX_sr_000",--molotok-68 grade 9 --icon/scope issues
--  "EQP_WP_West_sr_013",
--  "EQP_WP_West_sr_014",
--  "EQP_WP_West_sr_020",
--  "EQP_WP_West_sr_027",
--  "EQP_WP_West_sr_029",
--  "EQP_WP_West_sr_02a",
--  "EQP_WP_West_sr_02b",
--  "EQP_WP_West_sr_049",
--  "EQP_WP_West_sr_04a",
--  "EQP_WP_West_sr_04b",
--  "EQP_WP_East_sr_032",
--  "EQP_WP_East_sr_033",
--  "EQP_WP_East_sr_034",
--  "EQP_WP_West_sr_037",
--  "EQP_WP_West_sr_047",
--  --"EQP_WP_West_sr_048",
--  "EQP_WP_West_mg_010",--un am cs grade 4 PF normal,strong,
--  "EQP_WP_West_mg_020",--alm 48 grade 2 skull normal strong, dd min
--  "EQP_WP_West_mg_021",--alm48 flashlight grade 4
--  "EQP_WP_East_mg_010",--lpg 61 grade 4, soviet normal
--  "EQP_WP_West_mg_023",--
--  "EQP_WP_West_mg_024",
--  "EQP_WP_West_mg_030",--alm 48 grade 5 flashlight
--  "EQP_WP_West_mg_037",--
--  "EQP_WP_West_mg_039",
--  "EQP_WP_West_mg_03a",
--  "EQP_WP_West_sr_048",
--  "EQP_WP_West_mg_03b",
--  "EQP_WP_West_ms_029",
--  "EQP_WP_West_ms_02a",
--  "EQP_WP_West_ms_02b",
--  "EQP_WP_Com_ms_029",
--  "EQP_WP_Com_ms_02a",
--  "EQP_WP_Com_ms_02b",
--  "EQP_WP_Com_ms_010",--killer bee grade 3, sov, pf, dd,skull strong
--  "EQP_WP_West_ms_010",--fb mr r grade 3, pf,skull normal
--  "EQP_WP_East_ms_010",--grom 11, grade 2, sov normal
--  "EQP_WP_East_ms_020",--cgm 25, used in s10054
--  "EQP_WP_Com_ms_023",
--  "EQP_WP_Com_ms_024",
--  "EQP_WP_Com_ms_020",--killer bee
--  "EQP_WP_Com_ms_026",
--  "EQP_WP_West_ms_020",--fb mr rl nlsp
--  "EQP_WP_EX_gl_000",--miraz zh 71 grade 9
}--tppEquipTableTest
--SYNC: Tpp\Scripts\Equip\EquipIdTable
--tex NOTE since this is pulled from EquipIdTable does not contain a lot of player only weapons, see EquipDevelopConstSetting
this.tppEquipTable={
  --SHIELD
  "EQP_SLD_SV",
  "EQP_SLD_PF_00",
  "EQP_SLD_PF_01",
  "EQP_SLD_PF_02",

  "EQP_SLD_DD",
  "EQP_SLD_DD_G02",
  "EQP_SLD_DD_G03",

  "EQP_SLD_DD_01",

  --HANDGUN
  "EQP_WP_West_hg_010",--AM D114 grade 1 -- PFs and DD hangun
  "EQP_WP_West_hg_010_WG",--no name/icon/drop model
  "EQP_WP_West_hg_020",--AM D114 with silencer(on icon) but no ext mag?  grade 4, skull normal strong
  "EQP_WP_West_hg_030",--geist p3 - shows shotgun icon but clearly isnt, machine pistol grade 4
  "EQP_WP_West_hg_030_cmn",--as above, no name/icon
  "EQP_WP_East_hg_010",--burkov grade 1, sov normal strong

  --TRANQ_PISTOL
  "EQP_WP_West_thg_010",--wu s.pistol grade 1
  "EQP_WP_West_thg_020",--grade 2
  "EQP_WP_West_thg_030",--wu s pistol inf supressor grade 5
  "EQP_WP_West_thg_040",--grade 5
  "EQP_WP_West_thg_050",--wu s pistol cb grade7
  "EQP_WP_EX_hg_000",--AM A114 RP grade 7 - silencer, gas cloud
  --tex added in retail 1080
  "EQP_WP_EX_hg_000_G01",--AM A114 RP grade 8 - silencer, gas cloud
  "EQP_WP_EX_hg_000_G02",--AM A114 RP grade 9 - silencer, gas cloud
  -- 1090
  "EQP_WP_EX_hg_000_G03",
  "EQP_WP_EX_hg_000_G04",
  "EQP_WP_EX_hg_010",--tornado 6 grade 3
  "EQP_WP_EX_hg_011",--tornado 6 grade 5
  "EQP_WP_EX_hg_012",--tornado 6 grade 6
  "EQP_WP_EX_hg_013",--tornado 6 grade 7

  --SMG
  "EQP_WP_West_sm_010",--ze'ev cs grade 3 pf normal, dd min grade
  "EQP_WP_West_sm_010_WG",--as above, no icon/name
  "EQP_WP_West_sm_020",--macht 37 grade 3, pf strong, skull normal strong
  "EQP_WP_East_sm_010",--sz 336 grade 3, sov normal
  "EQP_WP_East_sm_020",--sz 336 cs grade 5, sov strong
  "EQP_WP_East_sm_030",--sz 336 cs grade 3 light, supressor, skull cypr normal
  --dd table smg
  "EQP_WP_West_sm_014",--zeeve model, big scope no icon/name, supressor, DD icon backing
  "EQP_WP_West_sm_015",--as above
  "EQP_WP_West_sm_016",--loads, but missing icons and some blacked out sights DD backing, DD weapon table
  "EQP_WP_West_sm_017",--<
  --1090
  "EQP_WP_West_sm_019",
  "EQP_WP_West_sm_01a",
  "EQP_WP_West_sm_01b",

  --SMG_NONLETHAL
  --in dd table
  "EQP_WP_East_sm_042",--riot smg stn grd 1 stun
  "EQP_WP_East_sm_043",
  "EQP_WP_East_sm_044",
  "EQP_WP_East_sm_045",
  "EQP_WP_East_sm_047",
  --1090
  "EQP_WP_East_sm_049",
  "EQP_WP_East_sm_04a",
  "EQP_WP_East_sm_04b",

  --SHOTGUN
  "EQP_WP_Com_sg_010",--s1000 grade 2
  "EQP_WP_Com_sg_011",--s1000 cs grade 2, most normal shotty, sov a, pfs, skull, dd min
  "EQP_WP_Com_sg_011_FL",--as above, flashlight ?
  --in dd table
  "EQP_WP_Com_sg_013",--? mag shotgun no name no icon
  "EQP_WP_Com_sg_015",--above + scope, light
  "EQP_WP_Com_sg_020",--kabarga 83, grade 4, looks like same model as 013,14
  "EQP_WP_Com_sg_020_FL",--as abovem flashlight ?
  "EQP_WP_Com_sg_016",
  "EQP_WP_Com_sg_018",

  --SHOTGUN_NONLETHAL
  --dd
  "EQP_WP_Com_sg_023",--s1000 air-s stn at least icon grade 3 - icon shows slilencer scope but not in game
  "EQP_WP_Com_sg_024",--as above, light ?
  "EQP_WP_Com_sg_025",--as above
  "EQP_WP_Com_sg_030",--s1000 air-s cs grade 6
  "EQP_WP_Com_sg_038",--loads, but missing icons and some blacked out sights

  --ASSAULT
  "EQP_WP_West_ar_010",--AM MRS 4r Grade 3, pfs normal, dd 3rd
  "EQP_WP_West_ar_010_FL",--flashlight

  "EQP_WP_West_ar_020",--un arc cs grade 3 PF strong
  "EQP_WP_West_ar_020_FL",--flashlight
  "EQP_WP_West_ar_030",--un arc pt cs flashlight scope laser, skull normal and strong

  "EQP_WP_East_ar_010",--svg 76 grade 1, soviet normal
  "EQP_WP_East_ar_010_FL",--+flashlight
  "EQP_WP_East_ar_020",--svg 67 cs grade 4, child
  "EQP_WP_East_ar_030",--above grade 6, sov strong
  "EQP_WP_East_ar_030_FL",--+ flashlight

  --in dd table
  "EQP_WP_West_ar_040",--am mrs 4 grade 1
  "EQP_WP_West_ar_042",--above + supressor scope
  "EQP_WP_West_ar_055",--scope, no icon name
  "EQP_WP_West_ar_050",--am mrs 4r grade 5 scope laser
  "EQP_WP_West_ar_057",--loads, but missing icons and some blacked out sights
  --1090
  "EQP_WP_West_ar_059",
  "EQP_WP_West_ar_05a",
  "EQP_WP_West_ar_05b",
  "EQP_WP_West_ar_079",
  "EQP_WP_West_ar_07a",
  "EQP_WP_West_ar_07b",

  --ASSAULT_NONLETHAL
  "EQP_WP_West_ar_060",--un arc nl stn grade 2
  "EQP_WP_West_ar_063",--above + scope no icon name
  "EQP_WP_West_ar_070",--un arc nl stn light grade 4
  "EQP_WP_West_ar_075",--above + supressor
  "EQP_WP_West_ar_077",

  --SNIPER
  "EQP_WP_West_sr_010",--m2000 d grade 2
  "EQP_WP_West_sr_011",--PF normal, DD
  "EQP_WP_East_sr_011",--sov a normal
  "EQP_WP_East_sr_020",--sov a strong
  "EQP_WP_EX_sr_000",--molotok-68 grade 9 --icon/scope issues
  --dd table
  "EQP_WP_West_sr_013",
  "EQP_WP_West_sr_014",
  "EQP_WP_West_sr_020",
  "EQP_WP_West_sr_027",
  --1090
  "EQP_WP_West_sr_029",
  "EQP_WP_West_sr_02a",
  "EQP_WP_West_sr_02b",
  "EQP_WP_West_sr_049",
  "EQP_WP_West_sr_04a",
  "EQP_WP_West_sr_04b",

  --SNIPER_NONLETHAL
  --ddtable
  "EQP_WP_East_sr_032",
  "EQP_WP_East_sr_033",
  "EQP_WP_East_sr_034",
  "EQP_WP_West_sr_037",
  "EQP_WP_West_sr_047",
  "EQP_WP_West_sr_048",

  --MG
  "EQP_WP_West_mg_010",--un am cs grade 4 PF normal,strong,
  "EQP_WP_West_mg_020",--alm 48 grade 2 skull normal strong, dd min
  "EQP_WP_West_mg_021",--alm48 flashlight grade 4
  "EQP_WP_East_mg_010",--lpg 61 grade 4, soviet normal
  --dd
  "EQP_WP_West_mg_023",--
  "EQP_WP_West_mg_024",
  "EQP_WP_West_mg_030",--alm 48 grade 5 flashlight
  "EQP_WP_West_mg_037",--
  --1090
  "EQP_WP_West_mg_039",
  "EQP_WP_West_mg_03a",
  "EQP_WP_West_mg_03b",
  "EQP_WP_West_ms_029",
  "EQP_WP_West_ms_02a",
  "EQP_WP_West_ms_02b",
  "EQP_WP_Com_ms_029",
  "EQP_WP_Com_ms_02a",
  "EQP_WP_Com_ms_02b",

  --MISSILE
  "EQP_WP_Com_ms_010",--killer bee grade 3, sov, pf, dd,skull strong
  "EQP_WP_West_ms_010",--fb mr r grade 3, pf,skull normal
  "EQP_WP_East_ms_010",--grom 11, grade 2, sov normal
  "EQP_WP_East_ms_020",--cgm 25, used in s10054
  --dd table
  "EQP_WP_Com_ms_023",
  "EQP_WP_Com_ms_024",
  "EQP_WP_Com_ms_020",--killer bee
  "EQP_WP_Com_ms_026",

  --MISSILE_NONLETHAL
  "EQP_WP_West_ms_020",--fb mr rl nlsp

  --GRENADE_LAUNCHER
  "EQP_WP_EX_gl_000",--miraz zh 71 grade 9

  --SUPPORT_WEAPONS
  "EQP_SWP_Magazine",
  --animal bait
  "EQP_SWP_Kibidango",
  "EQP_SWP_Kibidango_G01",
  "EQP_SWP_Kibidango_G02",


  "EQP_SWP_Grenade",
  "EQP_SWP_Grenade_G01",
  "EQP_SWP_Grenade_G02",
  "EQP_SWP_Grenade_G03",
  "EQP_SWP_Grenade_G04",
  "EQP_SWP_Grenade_G05",
  --1090
  "EQP_SWP_Grenade_G06",
  "EQP_SWP_Grenade_G07",
  "EQP_SWP_Grenade_G08",

  "EQP_SWP_SmokeGrenade",
  "EQP_SWP_SmokeGrenade_G01",
  "EQP_SWP_SmokeGrenade_G02",
  "EQP_SWP_SmokeGrenade_G03",
  "EQP_SWP_SmokeGrenade_G04",

  "EQP_SWP_SupportHeliFlareGrenade",
  "EQP_SWP_SupportHeliFlareGrenade_G01",
  "EQP_SWP_SupportHeliFlareGrenade_G02",

  "EQP_SWP_SupplyFlareGrenade",
  "EQP_SWP_SupplyFlareGrenade_G01",
  "EQP_SWP_SupplyFlareGrenade_G02",

  "EQP_SWP_StunGrenade",
  "EQP_SWP_StunGrenade_G01",
  "EQP_SWP_StunGrenade_G02",
  "EQP_SWP_StunGrenade_G03",
  --1090
  "EQP_SWP_StunGrenade_G04",
  "EQP_SWP_StunGrenade_G05",
  "EQP_SWP_StunGrenade_G06",

  "EQP_SWP_SleepingGusGrenade",
  "EQP_SWP_SleepingGusGrenade_G01",
  "EQP_SWP_SleepingGusGrenade_G02",

  "EQP_SWP_MolotovCocktail",
  "EQP_SWP_MolotovCocktail_G01",
  "EQP_SWP_MolotovCocktail_G02",

  "EQP_SWP_MolotovCocktailPlaced",

  "EQP_SWP_C4",
  "EQP_SWP_C4_G01",
  "EQP_SWP_C4_G02",
  "EQP_SWP_C4_G03",
  "EQP_SWP_C4_G04",

  "EQP_SWP_Decoy",
  "EQP_SWP_Decoy_G01",
  "EQP_SWP_Decoy_G02",

  "EQP_SWP_ActiveDecoy",
  "EQP_SWP_ActiveDecoy_G01",
  "EQP_SWP_ActiveDecoy_G02",

  "EQP_SWP_ShockDecoy",
  "EQP_SWP_ShockDecoy_G01",
  "EQP_SWP_ShockDecoy_G02",
  --1090
  "EQP_SWP_ShockDecoy_G03",
  "EQP_SWP_ShockDecoy_G04",

  "EQP_SWP_CaptureCage",
  "EQP_SWP_CaptureCage_G01",
  "EQP_SWP_CaptureCage_G02",

  "EQP_SWP_DMine",
  "EQP_SWP_DMine_G01",
  "EQP_SWP_DMine_G02",
  "EQP_SWP_DMine_G03",

  "EQP_SWP_SleepingGusMine",
  "EQP_SWP_SleepingGusMine_G01",
  "EQP_SWP_SleepingGusMine_G02",

  "EQP_SWP_AntitankMine",
  "EQP_SWP_AntitankMine_G01",
  "EQP_SWP_AntitankMine_G02",

  "EQP_SWP_ElectromagneticNetMine",
  "EQP_SWP_ElectromagneticNetMine_G01",
  "EQP_SWP_ElectromagneticNetMine_G02",

  --fob
  --FOB
  "EQP_SWP_SleepingGusMineLocator",
  "EQP_SWP_DMineLocator",
  --crash requires fob mode/specifc set up i guess
  "EQP_WP_SCamLocator",
  "EQP_SWP_WormholePortal",
  --1090 --crashes on equip, looking for some fob function i guess
  "EQP_SWP_FakeSign",
  "EQP_SWP_FakeSign_G01",
  "EQP_SWP_FakeSign_G02",

  --AMMOBOX
  --tex crash on equip
  "EQP_AB_PrimaryCommon",
  "EQP_AB_PrimaryTranq",
  "EQP_AB_PrimaryMissile",
  "EQP_AB_PrimaryMissileTranq",
  "EQP_AB_SecondaryCommon",
  "EQP_AB_SecondaryTranq",
  "EQP_AB_Support",
  "EQP_AB_Suppressor",
  "EQP_AB_Item",
  "EQP_AB_Mecha",
  "EQP_BX_Primary",
  "EQP_BX_Secondary",
  "EQP_BX_Support",

  --hands
  --no world pickup model
  --no effect on pickup
  "EQP_HAND_STUNARM",
  "EQP_HAND_JEHUTY",
  "EQP_HAND_STUN_ROCKET",
  "EQP_HAND_KILL_ROCKET",
  "EQP_HAND_NORMAL",
  "EQP_HAND_GOLD",
  "EQP_HAND_SILVER",

  --items
  "EQP_IT_Fulton",
  "EQP_IT_Fulton_Cargo",
  "EQP_IT_Fulton_Child",
  "EQP_IT_Fulton_WormHole",
  "EQP_IT_Binocle",

  --equips item to players set level/amount
  --no world model
  --ITEMS
  "EQP_IT_InstantStealth",
  "EQP_IT_Pentazemin",
  "EQP_IT_Clairvoyance",
  "EQP_IT_ReflexMedicine",

  --world model is untextured/white
  --works fine on equipping though
  --CARDBOARD_BOX
  "EQP_IT_CBox_WR",
  "EQP_IT_CBox_SMK",
  "EQP_IT_CBox_DSR",
  "EQP_IT_CBox_DSR_G01",
  "EQP_IT_CBox_DSR_G02",
  "EQP_IT_CBox_FRST",
  "EQP_IT_CBox_FRST_G01",
  "EQP_IT_CBox_BOLE",
  "EQP_IT_CBox_BOLE_G01",
  "EQP_IT_CBox_CITY",
  "EQP_IT_CBox_CITY_G01",

  --tex no go
  "EQP_IT_CBox_CLB_A",
  "EQP_IT_CBox_CLB_A_G01",
  "EQP_IT_CBox_CLB_B",
  "EQP_IT_CBox_CLB_B_G01",
  "EQP_IT_CBox_CLB_C",
  "EQP_IT_CBox_CLB_C_G01",
  -- tex some kind of dlc box, defaults to regular texture though
  "EQP_IT_CBox_LIMITED",
  "EQP_IT_CBox_LIMITED_G01",
  --
  --tex needs parasite armor
  --no world model
  "EQP_IT_ParasiteMist",
  "EQP_IT_ParasiteCamouf",
  "EQP_IT_ParasiteHard",

  --tools
  --give current set level (amounts if applicable)?
  "EQP_IT_TimeCigarette",
  "EQP_IT_Stealth",--no world model
  "EQP_IT_Nvg",

  "EQP_IT_Cassette",--cassette ids?
  "EQP_IT_DevelopmentFile",
  --no effect
  "EQP_IT_FilmCase",

  "EQP_IT_IDroid",
  "EQP_IT_CureSpray",
  "EQP_IT_PickingToolR",
  "EQP_IT_PickingToolL",
  "EQP_IT_HandyLight",
  "EQP_IT_Knife",
  "EQP_IT_SKnife",
  "EQP_IT_Cigarette",
  "EQP_IT_CigaretteCase",
  "EQP_IT_Radio",
  "EQP_IT_SRadio",

  "EQP_IT_Telescope",
  "EQP_IT_GasMask",--tex likely handled through attachgasmask/requires asset fpk
  "EQP_IT_KnifePF",
  --no world model-v-
  "EQP_SWP_Dung",
  "EQP_IT_BayonetWest",
  "EQP_IT_ShotShell",
  "EQP_IT_Machete",
  "EQP_IT_MacheteLiquid",
  "EQP_IT_KnifeLiquid",
  "EQP_IT_PipeLiquid",
  "EQP_IT_BottleLiquid",
  "EQP_IT_ShellLiquid",
  "EQP_IT_mgs0_msbl0",
  "EQP_IT_DDogStunLod",

  "EQP_IT_Infected",--tex likely requires the specific mission assets

  --special weapons
  "EQP_WP_Wood_ar_010",
  --no go
  "EQP_WP_Quiet_sr_010",
  "EQP_WP_Quiet_sr_020",
  "EQP_WP_Quiet_sr_030",
  "EQP_WP_BossQuiet_sr_010",
  "EQP_WP_Pr_sm_010",
  "EQP_WP_Pr_ar_010",
  "EQP_WP_Pr_sg_010",
  "EQP_WP_Pr_sr_010",
  "EQP_WP_mgm0_mgun0",

  "EQP_WP_HoneyBee",
  "EQP_WP_Volgin_sg_010",--no go
  "EQP_WP_SkullFace_hg_010",--holds weird, its actual use in its mission has it's own custom animation?

  --hang on load --re test
  "EQP_WP_DEBUG_sr_010",
  "EQP_WP_DEMO_ar_010",
  "EQP_WP_DEMO_ar_020",
  "EQP_WP_DEMO_ar_030",
  "EQP_WP_DEMO_sr_010",
  "EQP_WP_DEMO_hg_010",
  "EQP_WP_DEMO_hg_020",
  "EQP_WP_DEMO_hg_030",
  "EQP_WP_DEMO_sm_010",
  "EQP_WP_DEMO_sm_020",
  "EQP_WP_DEMO_mg_010",
  "EQP_WP_DEMO_ms_010",
  "EQP_WP_DEMO_ms_020",

  "EQP_WP_SP_hg_010",
  "EQP_WP_SP_hg_020",
  "EQP_WP_SP_sm_010",
  "EQP_WP_SP_sg_010",

  "EQP_WP_SP_SLD_010",
  "EQP_WP_SP_SLD_010_G01",
  "EQP_WP_SP_SLD_010_G02",
  "EQP_WP_SP_SLD_020",
  "EQP_WP_SP_SLD_020_G01",
  "EQP_WP_SP_SLD_020_G02",
  "EQP_WP_SP_SLD_030",
  "EQP_WP_SP_SLD_030_G01",
  "EQP_WP_SP_SLD_030_G02",
  "EQP_WP_SP_SLD_040",
  "EQP_WP_SP_SLD_040_G01",
  "EQP_WP_SP_SLD_040_G02",

  --not equipable, hang on equip
  "EQP_AM_10001",
  "EQP_AM_10003",
  "EQP_AM_10015",
  "EQP_AM_10101",
  "EQP_AM_10103",
  "EQP_AM_10125",
  "EQP_AM_10134",
  "EQP_AM_10201",
  "EQP_AM_10203",
  "EQP_AM_10214",
  "EQP_AM_10302",
  "EQP_AM_10303",
  "EQP_AM_10305",
  "EQP_AM_10403",
  "EQP_AM_10404",
  "EQP_AM_10405",
  "EQP_AM_10407",
  "EQP_AM_10503",
  "EQP_AM_10515",
  "EQP_AM_10526",
  "EQP_AM_20002",
  "EQP_AM_20003",
  "EQP_AM_20005",
  "EQP_AM_20103",
  "EQP_AM_20104",
  "EQP_AM_20105",
  "EQP_AM_20106",
  "EQP_AM_20116",
  "EQP_AM_20203",
  "EQP_AM_20206",
  "EQP_AM_20302",
  "EQP_AM_20303",
  "EQP_AM_20304",
  "EQP_AM_20305",
  "EQP_AM_30001",
  "EQP_AM_30003",
  "EQP_AM_30014",
  "EQP_AM_30034",
  "EQP_AM_30043",
  "EQP_AM_30047",
  "EQP_AM_30054",
  "EQP_AM_30055",
  "EQP_AM_30102",
  "EQP_AM_30103",
  "EQP_AM_30123",
  "EQP_AM_30125",
  "EQP_AM_30201",
  "EQP_AM_30203",
  "EQP_AM_30223",
  "EQP_AM_30225",
  "EQP_AM_30232",
  "EQP_AM_30303",
  "EQP_AM_30305",
  "EQP_AM_30306",
  "EQP_AM_30325",
  "EQP_AM_40001",
  "EQP_AM_40004",
  "EQP_AM_40012",
  "EQP_AM_40015",
  "EQP_AM_40023",
  "EQP_AM_40102",
  "EQP_AM_40105",
  "EQP_AM_40115",
  "EQP_AM_40123",
  "EQP_AM_40126",
  "EQP_AM_40133",
  "EQP_AM_40135",
  "EQP_AM_40136",
  "EQP_AM_40143",
  "EQP_AM_40203",
  "EQP_AM_40204",
  "EQP_AM_40206",
  "EQP_AM_40304",
  "EQP_AM_50102",
  "EQP_AM_50115",
  "EQP_AM_50126",
  "EQP_AM_50147",
  "EQP_AM_50136",
  "EQP_AM_50202",
  "EQP_AM_50215",
  "EQP_AM_50226",
  "EQP_AM_50237",
  "EQP_AM_50303",
  "EQP_AM_50304",
  "EQP_AM_50306",
  "EQP_AM_60001",
  "EQP_AM_60007",
  "EQP_AM_60013",
  "EQP_AM_60102",
  "EQP_AM_60107",
  "EQP_AM_60114",
  "EQP_AM_60203",
  "EQP_AM_60303",
  "EQP_AM_60315",
  "EQP_AM_60325",
  "EQP_AM_60404",
  "EQP_AM_60406",
  "EQP_AM_60415",
  "EQP_AM_60417",
  "EQP_AM_70002",
  "EQP_AM_70003",
  "EQP_AM_70005",
  "EQP_AM_70103",
  "EQP_AM_70104",
  "EQP_AM_70105",
  "EQP_AM_70114",
  "EQP_AM_70115",
  "EQP_AM_70116",
  "EQP_AM_70203",
  "EQP_AM_70204",
  "EQP_AM_70205",
  "EQP_AM_Quiet_sr_010",
  "EQP_AM_Quiet_sr_020",
  "EQP_AM_Quiet_sr_030",
  "EQP_AM_Pr_sm_010",
  "EQP_AM_Pr_ar_010",
  "EQP_AM_Pr_sg_010",
  "EQP_AM_Pr_sr_010",
  "EQP_AM_SkullFace_hg_010",
  "EQP_AM_SP_hg_010",
  "EQP_AM_SP_hg_020",
  "EQP_AM_SP_sm_010",
  "EQP_AM_SP_sg_010",
  "EQP_AM_EX_hg_000",
  "EQP_AM_EX_gl_000",
  "EQP_BL_EX_gl_000",
  "EQP_AM_EX_sr_000",
  "EQP_AM_1003a",
  "EQP_AM_70125",
  "EQP_AM_70126",
  "EQP_AM_70127",
  "EQP_BL_ms02Fulton",
  "EQP_AM_EX_hg_010",
  "EQP_BL_HgGrenade",
  "EQP_BL_HgGrenade",
  "EQP_BL_HgSmoke",
  "EQP_BL_HgSleep",
  "EQP_BL_HgStun",
  "EQP_BL_40mmGrenade",
  "EQP_BL_40mmSmoke",
  "EQP_BL_40mmSleep",
  "EQP_BL_40mmStun",
  "EQP_BL_20mmGrenade",
  "EQP_BL_20mmRocket",
  "EQP_BL_20mmSmoke",
  "EQP_BL_20mmSleep",
  "EQP_BL_20mmStun",
  "EQP_BL_ms00",
  "EQP_BL_ms00_G2",
  "EQP_BL_ms00_G3",
  "EQP_BL_ms02",
  "EQP_BL_ms02_G2",
  "EQP_BL_ms02_G3",
  "EQP_BL_ms02Sleep",
  "EQP_BL_ms02F",
  "EQP_BL_ms02F_G2",
  "EQP_BL_ms02F_G3",
  "EQP_BL_ms03",
  "EQP_BL_ms03_G2",
  "EQP_BL_ms03_G3",
  "EQP_BL_ms03_G4",
  "EQP_BL_ms01",
  "EQP_BL_ms01_G2",
  "EQP_BL_ms01_G3",
  "EQP_BL_ms01_G4",
  "EQP_BL_ms01_Child",
  "EQP_BL_ms01_G2_Child",
  "EQP_BL_ms01_G3_Child",
  "EQP_BL_ms01_G4_Child",
  "EQP_BL_RocketPunchStun",
  "EQP_BL_RocketPunchBlast",
  "EQP_BL_uth0_ammo0",
  "EQP_BL_uth0_ammo1",
  "EQP_BL_mgm0_ammo0",
  "EQP_BL_mgm0_cmn_ammo0",
  "EQP_BL_mgm0_cmn_ammo1",
  "EQP_BL_mgm0_famo0",
  "EQP_BL_mgs0_miss1",
  "EQP_BL_mgs0_miss0",
  "EQP_BL_mgs0_srcm0",
  "EQP_BL_mgs0_grnd0",
  "EQP_BL_Mortar",
  "EQP_BL_Flare",
  "EQP_BL_Cannon",
  "EQP_BL_WavCannon",
  "EQP_BL_WavCannonHoming",
  "EQP_BL_TankCannon",
  "EQP_BL_TankCannonHoming",
  "EQP_BL_WavRocket",
  "EQP_BL_Tankgun_105mmRifledBoreGun",
  "EQP_BL_Tankgun_120mmSmoothBoreGun",
  "EQP_BL_Tankgun_125mmSmoothBoreGun",
  "EQP_BL_Tankgun_105mmRifledBoreGun_Homing",
  "EQP_BL_Tankgun_120mmSmoothBoreGun_Homing",
  "EQP_BL_Tankgun_125mmSmoothBoreGun_Homing",
  "EQP_BL_Tankgun_82mmRocketPoweredProjectile",
  "EQP_BL_Tankgun_MultipleRocketLauncher",
  "EQP_BL_SupplyBomb",
  "EQP_BL_SupplySmoke",
  "EQP_BL_SupplySleep",
  "EQP_BL_SupplyChaff",
  "EQP_BL_UavGrenade",
  "EQP_BL_UavSmokeGrenade",
  "EQP_BL_UavSleepGasGrenade",
}

--REF for TppPickableLocatorParameter equipIdStrCode32
--local equipStr32={
--  EQP_AB_Item = 3701051719,
--  EQP_AB_Mecha = 1087922814,
--  EQP_AB_PrimaryCommon = 3636743652,
--  EQP_AB_PrimaryMissile = 165673314,
--  EQP_AB_PrimaryMissileTranq = 2632867348,
--  EQP_AB_PrimaryTranq = 3838800485,
--  EQP_AB_SecondaryCommon = 2648389228,
--  EQP_AB_SecondaryTranq = 550443242,
--  EQP_AB_Support = 1584841319,
--  EQP_AB_Suppressor = 2248319796,
--  EQP_AM_10001 = 942386689,
--  EQP_AM_10003 = 744457620,
--  EQP_AM_10015 = 1358446639,
--  EQP_AM_1003a = 3865925797,
--  EQP_AM_10101 = 3763602871,
--  EQP_AM_10103 = 1117855202,
--  EQP_AM_10125 = 365499484,
--  EQP_AM_10134 = 240002840,
--  EQP_AM_10201 = 145874407,
--  EQP_AM_10203 = 3011332882,
--  EQP_AM_10214 = 2861513002,
--  EQP_AM_10302 = 2120008197,
--  EQP_AM_10303 = 1915144394,
--  EQP_AM_10305 = 2173158461,
--  EQP_AM_10403 = 2640427390,
--  EQP_AM_10404 = 4101749406,
--  EQP_AM_10405 = 2277386885,
--  EQP_AM_10407 = 726461515,
--  EQP_AM_10503 = 3253056461,
--  EQP_AM_10515 = 2254235644,
--  EQP_AM_10526 = 405330773,
--  EQP_AM_20002 = 1318930306,
--  EQP_AM_20003 = 1430896920,
--  EQP_AM_20005 = 2168524468,
--  EQP_AM_20103 = 3695338189,
--  EQP_AM_20104 = 397061487,
--  EQP_AM_20105 = 3774968955,
--  EQP_AM_20106 = 4262765224,
--  EQP_AM_20116 = 3578910857,
--  EQP_AM_20203 = 3795859629,
--  EQP_AM_20206 = 3141003267,
--  EQP_AM_20302 = 3200494389,
--  EQP_AM_20303 = 2730924595,
--  EQP_AM_20304 = 208460826,
--  EQP_AM_20305 = 41987348,
--  EQP_AM_30001 = 1604283350,
--  EQP_AM_30003 = 2801949682,
--  EQP_AM_30014 = 2805408094,
--  EQP_AM_30034 = 1865417414,
--  EQP_AM_30043 = 3168448727,
--  EQP_AM_30047 = 1956400477,
--  EQP_AM_30054 = 570000243,
--  EQP_AM_30055 = 3699467218,
--  EQP_AM_30102 = 233110227,
--  EQP_AM_30103 = 2413361028,
--  EQP_AM_30123 = 2500994915,
--  EQP_AM_30125 = 3001943870,
--  EQP_AM_30201 = 659671488,
--  EQP_AM_30203 = 3325870963,
--  EQP_AM_30223 = 36512606,
--  EQP_AM_30225 = 2273310016,
--  EQP_AM_30232 = 2308649588,
--  EQP_AM_30303 = 2656667019,
--  EQP_AM_30305 = 4210003792,
--  EQP_AM_30306 = 2445577938,
--  EQP_AM_30325 = 3963562310,
--  EQP_AM_40001 = 4160422845,
--  EQP_AM_40004 = 2800769517,
--  EQP_AM_40012 = 3347515566,
--  EQP_AM_40015 = 3271835704,
--  EQP_AM_40023 = 4149411751,
--  EQP_AM_40102 = 4209479459,
--  EQP_AM_40105 = 514409796,
--  EQP_AM_40115 = 2921367150,
--  EQP_AM_40123 = 3188294448,
--  EQP_AM_40126 = 1872840152,
--  EQP_AM_40133 = 2966274613,
--  EQP_AM_40135 = 845376444,
--  EQP_AM_40136 = 90153563,
--  EQP_AM_40143 = 3381456965,
--  EQP_AM_40203 = 4268762764,
--  EQP_AM_40204 = 3278162543,
--  EQP_AM_40206 = 3327866036,
--  EQP_AM_40304 = 963486475,
--  EQP_AM_50102 = 3662130966,
--  EQP_AM_50115 = 1899736379,
--  EQP_AM_50126 = 2332536486,
--  EQP_AM_50136 = 3314734774,
--  EQP_AM_50147 = 3855601427,
--  EQP_AM_50202 = 3535171861,
--  EQP_AM_50215 = 1508343740,
--  EQP_AM_50226 = 2963941635,
--  EQP_AM_50237 = 2940728864,
--  EQP_AM_50303 = 3659669131,
--  EQP_AM_50304 = 694095484,
--  EQP_AM_50306 = 943084575,
--  EQP_AM_60001 = 883006582,
--  EQP_AM_60007 = 2994367062,
--  EQP_AM_60013 = 215543032,
--  EQP_AM_60102 = 1351531735,
--  EQP_AM_60107 = 2371946254,
--  EQP_AM_60114 = 2086864608,
--  EQP_AM_60203 = 1414760875,
--  EQP_AM_60303 = 3975999681,
--  EQP_AM_60315 = 2041958517,
--  EQP_AM_60325 = 2207493696,
--  EQP_AM_60404 = 4226965578,
--  EQP_AM_60406 = 3227953282,
--  EQP_AM_60415 = 3993363145,
--  EQP_AM_60417 = 459222973,
--  EQP_AM_70002 = 2358887088,
--  EQP_AM_70003 = 766255576,
--  EQP_AM_70005 = 2632349685,
--  EQP_AM_70103 = 3510080321,
--  EQP_AM_70104 = 4134048866,
--  EQP_AM_70105 = 1596949892,
--  EQP_AM_70114 = 1774493529,
--  EQP_AM_70115 = 2347306227,
--  EQP_AM_70116 = 1264841501,
--  EQP_AM_70125 = 742780294,
--  EQP_AM_70126 = 3385458845,
--  EQP_AM_70127 = 2776039916,
--  EQP_AM_70203 = 2803884036,
--  EQP_AM_70204 = 3070302356,
--  EQP_AM_70205 = 2093360574,
--  EQP_AM_EX_gl_000 = 447926378,
--  EQP_AM_EX_hg_000 = 473727751,
--  EQP_AM_EX_hg_010 = 1937218480,
--  EQP_AM_EX_sr_000 = 3470110506,
--  EQP_AM_Pr_ar_010 = 1631123210,
--  EQP_AM_Pr_sg_010 = 3706531358,
--  EQP_AM_Pr_sm_010 = 2193416726,
--  EQP_AM_Pr_sr_010 = 2450674805,
--  EQP_AM_Quiet_sr_010 = 2683522218,
--  EQP_AM_Quiet_sr_020 = 2872633414,
--  EQP_AM_Quiet_sr_030 = 1662206366,
--  EQP_AM_SP_hg_010 = 2289842122,
--  EQP_AM_SP_hg_020 = 797833356,
--  EQP_AM_SP_sg_010 = 1414996770,
--  EQP_AM_SP_sm_010 = 782405644,
--  EQP_AM_SkullFace_hg_010 = 1389072866,
--  EQP_BL_20mmGrenade = 471160147,
--  EQP_BL_20mmRocket = 4210772381,
--  EQP_BL_20mmSleep = 3495970553,
--  EQP_BL_20mmSmoke = 2543528557,
--  EQP_BL_20mmStun = 823050362,
--  EQP_BL_40mmGrenade = 3401287737,
--  EQP_BL_40mmSleep = 4258340665,
--  EQP_BL_40mmSmoke = 2091250291,
--  EQP_BL_40mmStun = 586553044,
--  EQP_BL_Cannon = 3652026893,
--  EQP_BL_EX_gl_000 = 424293115,
--  EQP_BL_Flare = 199958230,
--  EQP_BL_HgGrenade = 289902459,
--  EQP_BL_HgSleep = 408995493,
--  EQP_BL_HgSmoke = 1869526419,
--  EQP_BL_HgStun = 2632082634,
--  EQP_BL_Mortar = 3241565003,
--  EQP_BL_RocketPunchBlast = 1370836470,
--  EQP_BL_RocketPunchStun = 1273187832,
--  EQP_BL_SupplyBomb = 674937096,
--  EQP_BL_SupplyChaff = 3855377204,
--  EQP_BL_SupplySleep = 959291929,
--  EQP_BL_SupplySmoke = 794798824,
--  EQP_BL_TankCannon = 1032822480,
--  EQP_BL_TankCannonHoming = 3839775256,
--  EQP_BL_Tankgun_105mmRifledBoreGun = 3352078975,
--  EQP_BL_Tankgun_105mmRifledBoreGun_Homing = 2774022405,
--  EQP_BL_Tankgun_120mmSmoothBoreGun = 2402436344,
--  EQP_BL_Tankgun_120mmSmoothBoreGun_Homing = 3347454244,
--  EQP_BL_Tankgun_125mmSmoothBoreGun = 685053113,
--  EQP_BL_Tankgun_125mmSmoothBoreGun_Homing = 3524114420,
--  EQP_BL_Tankgun_82mmRocketPoweredProjectile = 1681994303,
--  EQP_BL_Tankgun_MultipleRocketLauncher = 937617026,
--  EQP_BL_UavGrenade = 545284451,
--  EQP_BL_UavSleepGasGrenade = 2053278280,
--  EQP_BL_UavSmokeGrenade = 156816365,
--  EQP_BL_WavCannon = 2896605544,
--  EQP_BL_WavCannonHoming = 1022193325,
--  EQP_BL_WavRocket = 489075643,
--  EQP_BL_mgm0_ammo0 = 1481356880,
--  EQP_BL_mgm0_cmn_ammo0 = 1066023737,
--  EQP_BL_mgm0_cmn_ammo1 = 510708170,
--  EQP_BL_mgm0_famo0 = 338342908,
--  EQP_BL_mgs0_grnd0 = 1398858507,
--  EQP_BL_mgs0_miss0 = 1751023113,
--  EQP_BL_mgs0_miss1 = 2402016362,
--  EQP_BL_mgs0_srcm0 = 1027474130,
--  EQP_BL_ms00 = 4008999740,
--  EQP_BL_ms00_G2 = 3504807822,
--  EQP_BL_ms00_G3 = 3706299389,
--  EQP_BL_ms01 = 3989756358,
--  EQP_BL_ms01_Child = 1806636541,
--  EQP_BL_ms01_G2 = 1657148044,
--  EQP_BL_ms01_G2_Child = 599094933,
--  EQP_BL_ms01_G3 = 833395813,
--  EQP_BL_ms01_G3_Child = 1761270286,
--  EQP_BL_ms01_G4 = 421231201,
--  EQP_BL_ms01_G4_Child = 2604275811,
--  EQP_BL_ms02 = 3640933022,
--  EQP_BL_ms02F = 3538607968,
--  EQP_BL_ms02F_G2 = 951821876,
--  EQP_BL_ms02F_G3 = 3788033983,
--  EQP_BL_ms02Fulton = 3182611276,
--  EQP_BL_ms02Sleep = 1655113344,
--  EQP_BL_ms02_G2 = 3817384181,
--  EQP_BL_ms02_G3 = 668070489,
--  EQP_BL_ms03 = 414523170,
--  EQP_BL_ms03_G2 = 1674028063,
--  EQP_BL_ms03_G3 = 1309977657,
--  EQP_BL_ms03_G4 = 3810026717,
--  EQP_BL_uth0_ammo0 = 1342437695,
--  EQP_BL_uth0_ammo1 = 3325619747,
--  EQP_BX_Primary = 2965041888,
--  EQP_BX_Secondary = 275830932,
--  EQP_BX_Support = 1539203178,
--  EQP_HAND_GOLD = 2555823993,
--  EQP_HAND_JEHUTY = 2490913558,
--  EQP_HAND_KILL_ROCKET = 4056597849,
--  EQP_HAND_NORMAL = 3199053329,
--  EQP_HAND_SILVER = 2585824023,
--  EQP_HAND_STUNARM = 2851473425,
--  EQP_HAND_STUN_ROCKET = 1088650704,
--  EQP_IT_BayonetWest = 2958564855,
--  EQP_IT_Binocle = 309978643,
--  EQP_IT_BottleLiquid = 4271227325,
--  EQP_IT_CBox_BOLE = 376120247,
--  EQP_IT_CBox_BOLE_G01 = 3228989621,
--  EQP_IT_CBox_CITY = 1420468688,
--  EQP_IT_CBox_CITY_G01 = 1112955485,
--  EQP_IT_CBox_CLB_A = 2472083186,
--  EQP_IT_CBox_CLB_A_G01 = 3408044433,
--  EQP_IT_CBox_CLB_B = 4208414082,
--  EQP_IT_CBox_CLB_B_G01 = 1343734093,
--  EQP_IT_CBox_CLB_C = 3852094676,
--  EQP_IT_CBox_CLB_C_G01 = 36321842,
--  EQP_IT_CBox_DSR = 215757141,
--  EQP_IT_CBox_DSR_G01 = 824474964,
--  EQP_IT_CBox_DSR_G02 = 2538764310,
--  EQP_IT_CBox_FRST = 1184162712,
--  EQP_IT_CBox_FRST_G01 = 1284424128,
--  EQP_IT_CBox_LIMITED = 562208995,
--  EQP_IT_CBox_LIMITED_G01 = 3131160279,
--  EQP_IT_CBox_SMK = 199206201,
--  EQP_IT_CBox_WR = 3040902098,
--  EQP_IT_Cassette = 3115897383,
--  EQP_IT_Cigarette = 218870227,
--  EQP_IT_CigaretteCase = 114400128,
--  EQP_IT_Clairvoyance = 1743804179,
--  EQP_IT_CureSpray = 3073940205,
--  EQP_IT_DDogStunLod = 2132483414,
--  EQP_IT_DevelopmentFile = 4154155589,
--  EQP_IT_FilmCase = 3467346754,
--  EQP_IT_Fulton = 2020961543,
--  EQP_IT_Fulton_Cargo = 789783388,
--  EQP_IT_Fulton_Child = 1732648546,
--  EQP_IT_Fulton_WormHole = 194136571,
--  EQP_IT_GasMask = 1958929861,
--  EQP_IT_HandyLight = 3260951228,
--  EQP_IT_IDroid = 515927244,
--  EQP_IT_Infected = 1829282362,
--  EQP_IT_InstantStealth = 633414155,
--  EQP_IT_Knife = 1625758311,
--  EQP_IT_KnifeLiquid = 1634943786,
--  EQP_IT_KnifePF = 3962271739,
--  EQP_IT_Machete = 3888944926,
--  EQP_IT_MacheteLiquid = 775241128,
--  EQP_IT_Nvg = 2704689080,
--  EQP_IT_ParasiteCamouf = 3675306451,
--  EQP_IT_ParasiteHard = 2481641904,
--  EQP_IT_ParasiteMist = 2696887792,
--  EQP_IT_Pentazemin = 3282036821,
--  EQP_IT_PickingToolL = 1818878992,
--  EQP_IT_PickingToolR = 2371811700,
--  EQP_IT_PipeLiquid = 4147360598,
--  EQP_IT_Radio = 66149589,
--  EQP_IT_ReflexMedicine = 796139346,
--  EQP_IT_SKnife = 2187881504,
--  EQP_IT_SRadio = 459927039,
--  EQP_IT_ShellLiquid = 229617213,
--  EQP_IT_ShotShell = 1800345829,
--  EQP_IT_Stealth = 195059527,
--  EQP_IT_Telescope = 3274141297,
--  EQP_IT_TimeCigarette = 3475942585,
--  EQP_IT_mgs0_msbl0 = 558066791,
--  EQP_SLD_DD = 22715550,
--  EQP_SLD_DD_01 = 2412339677,
--  EQP_SLD_DD_G02 = 2338929536,
--  EQP_SLD_DD_G03 = 1817573585,
--  EQP_SLD_PF_00 = 111660325,
--  EQP_SLD_PF_01 = 717613654,
--  EQP_SLD_PF_02 = 1034025940,
--  EQP_SLD_SV = 3569226671,
--  EQP_SWP_ActiveDecoy = 631777925,
--  EQP_SWP_ActiveDecoy_G01 = 125435196,
--  EQP_SWP_ActiveDecoy_G02 = 1572261594,
--  EQP_SWP_AntitankMine = 2380434448,
--  EQP_SWP_AntitankMine_G01 = 3398829166,
--  EQP_SWP_AntitankMine_G02 = 553841645,
--  EQP_SWP_C4 = 2248417544,
--  EQP_SWP_C4_G01 = 3680273883,
--  EQP_SWP_C4_G02 = 1638061628,
--  EQP_SWP_C4_G03 = 1245836066,
--  EQP_SWP_C4_G04 = 1330467844,
--  EQP_SWP_CaptureCage = 1711629690,
--  EQP_SWP_CaptureCage_G01 = 552167052,
--  EQP_SWP_CaptureCage_G02 = 452941044,
--  EQP_SWP_DMine = 269631637,
--  EQP_SWP_DMineLocator = 3866854189,
--  EQP_SWP_DMine_G01 = 593832643,
--  EQP_SWP_DMine_G02 = 1837867390,
--  EQP_SWP_DMine_G03 = 470410001,
--  EQP_SWP_Decoy = 3951752765,
--  EQP_SWP_Decoy_G01 = 3518196155,
--  EQP_SWP_Decoy_G02 = 672800204,
--  EQP_SWP_Dung = 775449917,
--  EQP_SWP_ElectromagneticNetMine = 1397745267,
--  EQP_SWP_ElectromagneticNetMine_G01 = 853152114,
--  EQP_SWP_ElectromagneticNetMine_G02 = 4231263272,
--  EQP_SWP_FakeSign = 2285172609,
--  EQP_SWP_FakeSign_G01 = 4140878589,
--  EQP_SWP_FakeSign_G02 = 1600143726,
--  EQP_SWP_Grenade = 3234702229,
--  EQP_SWP_Grenade_G01 = 832826455,
--  EQP_SWP_Grenade_G02 = 3796343448,
--  EQP_SWP_Grenade_G03 = 1873153737,
--  EQP_SWP_Grenade_G04 = 4098463476,
--  EQP_SWP_Grenade_G05 = 4078051275,
--  EQP_SWP_Grenade_G06 = 3561818312,
--  EQP_SWP_Grenade_G07 = 4129918514,
--  EQP_SWP_Grenade_G08 = 896708107,
--  EQP_SWP_Kibidango = 1729095651,
--  EQP_SWP_Kibidango_G01 = 1517131214,
--  EQP_SWP_Kibidango_G02 = 3582842553,
--  EQP_SWP_Magazine = 1729400768,
--  EQP_SWP_MolotovCocktail = 3601061635,
--  EQP_SWP_MolotovCocktailPlaced = 1777800427,
--  EQP_SWP_MolotovCocktail_G01 = 369997865,
--  EQP_SWP_MolotovCocktail_G02 = 1861473252,
--  EQP_SWP_ShockDecoy = 3164016199,
--  EQP_SWP_ShockDecoy_G01 = 3147793694,
--  EQP_SWP_ShockDecoy_G02 = 2575886044,
--  EQP_SWP_ShockDecoy_G03 = 104841607,
--  EQP_SWP_ShockDecoy_G04 = 2999447259,
--  EQP_SWP_SleepingGusGrenade = 1767259635,
--  EQP_SWP_SleepingGusGrenade_G01 = 3842441047,
--  EQP_SWP_SleepingGusGrenade_G02 = 1322908006,
--  EQP_SWP_SleepingGusMine = 2364332929,
--  EQP_SWP_SleepingGusMineLocator = 2265173,
--  EQP_SWP_SleepingGusMine_G01 = 3385519743,
--  EQP_SWP_SleepingGusMine_G02 = 1871659905,
--  EQP_SWP_SmokeGrenade = 1340992856,
--  EQP_SWP_SmokeGrenade_G01 = 537949682,
--  EQP_SWP_SmokeGrenade_G02 = 26456530,
--  EQP_SWP_SmokeGrenade_G03 = 589912424,
--  EQP_SWP_SmokeGrenade_G04 = 488255820,
--  EQP_SWP_StunGrenade = 3139845,
--  EQP_SWP_StunGrenade_G01 = 1822086030,
--  EQP_SWP_StunGrenade_G02 = 220294450,
--  EQP_SWP_StunGrenade_G03 = 575899652,
--  EQP_SWP_StunGrenade_G04 = 4190956630,
--  EQP_SWP_StunGrenade_G05 = 1623851637,
--  EQP_SWP_StunGrenade_G06 = 1610924274,
--  EQP_SWP_SupplyFlareGrenade = 160773547,
--  EQP_SWP_SupplyFlareGrenade_G01 = 3893550372,
--  EQP_SWP_SupplyFlareGrenade_G02 = 2540455665,
--  EQP_SWP_SupportHeliFlareGrenade = 2929309074,
--  EQP_SWP_SupportHeliFlareGrenade_G01 = 3086998058,
--  EQP_SWP_SupportHeliFlareGrenade_G02 = 243879909,
--  EQP_SWP_WormholePortal = 1372924546,
--  EQP_WP_BossQuiet_sr_010 = 2618042870,
--  EQP_WP_Com_ms_010 = 2652843571,
--  EQP_WP_Com_ms_020 = 3563412907,
--  EQP_WP_Com_ms_023 = 2664947204,
--  EQP_WP_Com_ms_024 = 396880388,
--  EQP_WP_Com_ms_026 = 1379167173,
--  EQP_WP_Com_ms_029 = 2357381301,
--  EQP_WP_Com_ms_02a = 1836768007,
--  EQP_WP_Com_ms_02b = 1375549568,
--  EQP_WP_Com_sg_010 = 2381010158,
--  EQP_WP_Com_sg_011 = 3747062774,
--  EQP_WP_Com_sg_011_FL = 2128560303,
--  EQP_WP_Com_sg_013 = 2087323406,
--  EQP_WP_Com_sg_015 = 2166157937,
--  EQP_WP_Com_sg_016 = 3900424921,
--  EQP_WP_Com_sg_018 = 11678877,
--  EQP_WP_Com_sg_020 = 2359733399,
--  EQP_WP_Com_sg_020_FL = 2697773255,
--  EQP_WP_Com_sg_023 = 685340280,
--  EQP_WP_Com_sg_024 = 2582567510,
--  EQP_WP_Com_sg_025 = 2098920834,
--  EQP_WP_Com_sg_030 = 190258288,
--  EQP_WP_Com_sg_038 = 394470869,
--  EQP_WP_DEBUG_sr_010 = 1436774388,
--  EQP_WP_DEMO_ar_010 = 160662483,
--  EQP_WP_DEMO_ar_020 = 3771918338,
--  EQP_WP_DEMO_ar_030 = 433307492,
--  EQP_WP_DEMO_hg_010 = 1898602042,
--  EQP_WP_DEMO_hg_020 = 3524947650,
--  EQP_WP_DEMO_hg_030 = 3964973642,
--  EQP_WP_DEMO_mg_010 = 1275995190,
--  EQP_WP_DEMO_ms_010 = 58887870,
--  EQP_WP_DEMO_ms_020 = 3712341932,
--  EQP_WP_DEMO_sm_010 = 1278304055,
--  EQP_WP_DEMO_sm_020 = 1310216725,
--  EQP_WP_DEMO_sr_010 = 2392059727,
--  EQP_WP_EX_gl_000 = 4169556718,
--  EQP_WP_EX_hg_000 = 4001165168,
--  EQP_WP_EX_hg_000_G01 = 3070538266,
--  EQP_WP_EX_hg_000_G02 = 4042976828,
--  EQP_WP_EX_hg_000_G03 = 1803076094,
--  EQP_WP_EX_hg_000_G04 = 1974491201,
--  EQP_WP_EX_hg_010 = 4179299715,
--  EQP_WP_EX_hg_011 = 661561680,
--  EQP_WP_EX_hg_012 = 259280670,
--  EQP_WP_EX_hg_013 = 4140816574,
--  EQP_WP_EX_sr_000 = 2090616205,
--  EQP_WP_East_ar_010 = 3704165053,
--  EQP_WP_East_ar_010_FL = 1885486820,
--  EQP_WP_East_ar_020 = 71986377,
--  EQP_WP_East_ar_030 = 3749235060,
--  EQP_WP_East_ar_030_FL = 1354170242,
--  EQP_WP_East_hg_010 = 2217654729,
--  EQP_WP_East_mg_010 = 661011400,
--  EQP_WP_East_ms_010 = 2105861306,
--  EQP_WP_East_ms_020 = 4283898693,
--  EQP_WP_East_sm_010 = 3946739440,
--  EQP_WP_East_sm_020 = 3184048147,
--  EQP_WP_East_sm_030 = 3527995433,
--  EQP_WP_East_sm_042 = 922867167,
--  EQP_WP_East_sm_043 = 791075340,
--  EQP_WP_East_sm_044 = 2494251918,
--  EQP_WP_East_sm_045 = 2705262656,
--  EQP_WP_East_sm_047 = 1311125152,
--  EQP_WP_East_sm_049 = 3274521203,
--  EQP_WP_East_sm_04a = 3740898701,
--  EQP_WP_East_sm_04b = 3895755609,
--  EQP_WP_East_sr_011 = 1906730152,
--  EQP_WP_East_sr_020 = 1086503214,
--  EQP_WP_East_sr_032 = 2038260248,
--  EQP_WP_East_sr_033 = 3257743636,
--  EQP_WP_East_sr_034 = 879491589,
--  EQP_WP_HoneyBee = 4231865953,
--  EQP_WP_Pr_ar_010 = 2752575230,
--  EQP_WP_Pr_sg_010 = 1831103880,
--  EQP_WP_Pr_sm_010 = 2875847062,
--  EQP_WP_Pr_sr_010 = 2874762533,
--  EQP_WP_Quiet_sr_010 = 2766172832,
--  EQP_WP_Quiet_sr_020 = 1590199376,
--  EQP_WP_Quiet_sr_030 = 3624849955,
--  EQP_WP_SCamLocator = 4074839377,
--  EQP_WP_SP_SLD_010 = 379754007,
--  EQP_WP_SP_SLD_010_G01 = 1183548925,
--  EQP_WP_SP_SLD_010_G02 = 1994584569,
--  EQP_WP_SP_SLD_020 = 699691113,
--  EQP_WP_SP_SLD_020_G01 = 3082906773,
--  EQP_WP_SP_SLD_020_G02 = 1081206013,
--  EQP_WP_SP_SLD_030 = 2139666375,
--  EQP_WP_SP_SLD_030_G01 = 3841461941,
--  EQP_WP_SP_SLD_030_G02 = 349586244,
--  EQP_WP_SP_SLD_040 = 1899789585,
--  EQP_WP_SP_SLD_040_G01 = 2108543,
--  EQP_WP_SP_SLD_040_G02 = 1884865098,
--  EQP_WP_SP_hg_010 = 2950334174,
--  EQP_WP_SP_hg_020 = 2454332517,
--  EQP_WP_SP_sg_010 = 677450990,
--  EQP_WP_SP_sm_010 = 2054119593,
--  EQP_WP_SkullFace_hg_010 = 3041864382,
--  EQP_WP_Volgin_sg_010 = 239105661,
--  EQP_WP_West_ar_010 = 4047504990,
--  EQP_WP_West_ar_010_FL = 1428812365,
--  EQP_WP_West_ar_020 = 1717548004,
--  EQP_WP_West_ar_020_FL = 524826996,
--  EQP_WP_West_ar_030 = 936868182,
--  EQP_WP_West_ar_040 = 1858930399,
--  EQP_WP_West_ar_042 = 4117383222,
--  EQP_WP_West_ar_050 = 3459808140,
--  EQP_WP_West_ar_055 = 3558182609,
--  EQP_WP_West_ar_057 = 1614747202,
--  EQP_WP_West_ar_059 = 2562693040,
--  EQP_WP_West_ar_05a = 1100428604,
--  EQP_WP_West_ar_05b = 3052535988,
--  EQP_WP_West_ar_060 = 1638878583,
--  EQP_WP_West_ar_063 = 581070372,
--  EQP_WP_West_ar_070 = 3731644209,
--  EQP_WP_West_ar_075 = 1306820854,
--  EQP_WP_West_ar_077 = 222016352,
--  EQP_WP_West_ar_079 = 867571564,
--  EQP_WP_West_ar_07a = 841386652,
--  EQP_WP_West_ar_07b = 3593323316,
--  EQP_WP_West_hg_010 = 1638409701,
--  EQP_WP_West_hg_010_WG = 288388838,
--  EQP_WP_West_hg_020 = 2514863450,
--  EQP_WP_West_hg_030 = 1524001822,
--  EQP_WP_West_hg_030_cmn = 3072840360,
--  EQP_WP_West_mg_010 = 1372660584,
--  EQP_WP_West_mg_020 = 2601800033,
--  EQP_WP_West_mg_021 = 3908037870,
--  EQP_WP_West_mg_023 = 3014886100,
--  EQP_WP_West_mg_024 = 1779580382,
--  EQP_WP_West_mg_030 = 3716387981,
--  EQP_WP_West_mg_037 = 2727677479,
--  EQP_WP_West_mg_039 = 3676621319,
--  EQP_WP_West_mg_03a = 1856874736,
--  EQP_WP_West_mg_03b = 1186744014,
--  EQP_WP_West_ms_010 = 1753488422,
--  EQP_WP_West_ms_020 = 1022605058,
--  EQP_WP_West_ms_029 = 818028818,
--  EQP_WP_West_ms_02a = 1721169765,
--  EQP_WP_West_ms_02b = 2338667780,
--  EQP_WP_West_sm_010 = 3426343295,
--  EQP_WP_West_sm_010_WG = 139488615,
--  EQP_WP_West_sm_014 = 3278367546,
--  EQP_WP_West_sm_015 = 883704911,
--  EQP_WP_West_sm_016 = 4262421142,
--  EQP_WP_West_sm_017 = 2218447420,
--  EQP_WP_West_sm_019 = 2778816778,
--  EQP_WP_West_sm_01a = 4235743289,
--  EQP_WP_West_sm_01b = 695481464,
--  EQP_WP_West_sm_020 = 2582967869,
--  EQP_WP_West_sr_010 = 2739379538,
--  EQP_WP_West_sr_011 = 1107864457,
--  EQP_WP_West_sr_013 = 3912688988,
--  EQP_WP_West_sr_014 = 1732918664,
--  EQP_WP_West_sr_020 = 4085075673,
--  EQP_WP_West_sr_027 = 134305031,
--  EQP_WP_West_sr_029 = 512393922,
--  EQP_WP_West_sr_02a = 1805253821,
--  EQP_WP_West_sr_02b = 2933941681,
--  EQP_WP_West_sr_037 = 2728579426,
--  EQP_WP_West_sr_047 = 1720774172,
--  EQP_WP_West_sr_048 = 3773341461,
--  EQP_WP_West_sr_049 = 516141085,
--  EQP_WP_West_sr_04a = 2084326138,
--  EQP_WP_West_sr_04b = 3173901658,
--  EQP_WP_West_thg_010 = 3810173747,
--  EQP_WP_West_thg_020 = 4005258284,
--  EQP_WP_West_thg_030 = 1492927031,
--  EQP_WP_West_thg_040 = 275062985,
--  EQP_WP_West_thg_050 = 2481935090,
--  EQP_WP_Wood_ar_010 = 3997713692,
--  EQP_WP_mgm0_mgun0 = 433801869
--}
--REF how table was built
--local equipStr32={}
--for i,equipStr in ipairs(this.tppEquipTable)do
--  equipStr32[equipStr]=Fox.StrCode32(equipStr)
--end
--InfCore.PrintInspect(equipStr32,"equipStr32")

--tex inserted into TppEnemy.weaponIdTable
this.weaponIdTable={
  WILDCARD={--tex dd max grades except for noted
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
  },
}
--EXEC SIDE
for id,idTable in pairs(this.weaponIdTable)do
  TppEnemy.weaponIdTable[id]=idTable
end

--tex DEBUG, requires EquipIdTable.lua in build
function this.CheckTppEquipTable()
  if not EquipIdTable.equipIdTable then
    InfCore.DebugPrint"InfEquip.tppEquipTable: TppEquip.lua not set up for this function."
    return
  end

  InfCore.DebugPrint"Checking InfEquip.tppEquipTable>TppEquip id"
  local equipIdToString={}
  for i,equipIdStr in ipairs(this.tppEquipTable)do
    local equipId=TppEquip[equipIdStr]
    if equipId==nil then
      InfCore.DebugPrint("Could not find "..tostring(equipIdStr))
    else
      equipIdToString[equipId]=equipIdStr
    end
  end

  InfCore.DebugPrint"Checking TppEquip id>InfEquip.tppEquipTable"
  for i,equipInfo in pairs(EquipIdTable.equipIdTable)do
    local equipId=equipInfo[1]
    local equipIdStr=this.tppEquipTable[equipId]
    if equipIdStr==nil then
      InfCore.DebugPrint("Could not find equipid:"..tostring(equipId).." EquipIdTable index:"..i)
    end
  end
end

--TUNE
this.itemDropInfo={
  SUPPORT_ITEMS=10,--nades mags and bait
  ITEMS_MISC=6,
  HANDGUNS=2,
  --OFF DRUGS=1,
--SUPPORT_FLARE=1,--not if support disabled
}

this.soldierDropTable={
  SUPPORT_ITEMS={
    "EQP_SWP_Grenade",
    "EQP_SWP_SmokeGrenade",
    "EQP_SWP_StunGrenade",
    "EQP_SWP_SleepingGusGrenade",
    "EQP_SWP_MolotovCocktail",

    "EQP_SWP_C4",
  },
  ITEMS_MISC={
    "EQP_SWP_Magazine",
    "EQP_SWP_Kibidango",--animal bait
  },
  HANDGUNS={
    "EQP_WP_West_hg_010",--AM D114 grade 1 -- PFs and DD hangun
    "EQP_WP_West_hg_020",--AM D114 with silencer(on icon) but no ext mag?  grade 4, skull normal strong
    "EQP_WP_West_hg_030_cmn",----geist p3, machine pistol grade ?, no name/icon
    "EQP_WP_East_hg_010",--burkov grade 1, sov normal strong

    --"EQP_WP_West_thg_010",--wu s.pistol grade 1
    "EQP_WP_West_thg_020",--grade 2
    --"EQP_WP_West_thg_030",--wu s pistol inf supressor grade 5
    "EQP_WP_West_thg_040",--grade 5
    --"EQP_WP_West_thg_050",--wu s pistol cb grade7
    "EQP_WP_EX_hg_000",--AM A114 RP, DD, silencer, grade 7
    --"EQP_WP_EX_hg_000_G01",--AM A114 RP grade 8 - silencer, gas cloud
    "EQP_WP_EX_hg_010",--tornado 6 grade 3
  },
-- OFF till I can figure out a better approach to midding EquipIdTable
--  DRUGS={
--    --tex will drop as lowest grade (with that grades item count), if already have item it will replace with lowest grade
--    "EQP_IT_Pentazemin",
--    "EQP_IT_Clairvoyance",
--    "EQP_IT_ReflexMedicine",
--  },
}

this.registerIvars={
  "weaponTableStrength",
  "weaponTableAfgh",
  "weaponTableMafr",
  "weaponTableSkull",
  "weaponTableDD",
  "allowUndevelopedDDEquip",
  "mbSoldierEquipRange",
  "mbDDEquipNonLethal",
  "putEquipOnTrucks",
  "itemDropChance",
}

IvarProc.MissionModeIvars(
  this,
  "weaponTableGlobal",
  {
    save=IvarProc.CATEGORY_EXTERNAL,
    settings={"DEFAULT"},--DYNAMIC via addon
    settingNamesDoc=[[<list of \mod\weaponIdTables>]],
    OnSelect=function(self)
      IvarProc.SetSettings(self,InfWeaponIdTable.addonsNames)
    end,
    GetSettingText=function(self,setting)
      local addonName=self.settings[setting+1]
      return InfWeaponIdTable.addons[addonName].description or addonName
    end,
  },
  {"FREE","MISSION","MB_ALL",}
)

--custom weapon table
IvarProc.MissionModeIvars(
  this,
  "customWeaponTable",
  {
    save=IvarProc.CATEGORY_EXTERNAL,
    range=Ivars.switchRange,
    settingNames="set_switch",
  },
  {"FREE","MISSION","MB_ALL",}
)
this.weaponTableStrength={
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={"NORMAL","STRONG","COMBINED"},
}
----
--  "weaponTableAfgh",
--  "weaponTableMafr",
--  "weaponTableSkull",
--  "weaponTableDD",

this.OnChangeWeaponTable=function(self,setting)
  --TODO:
  --for weaponTableIvars
  --if all set to 0
  --for all customWeaponTable
  --if any set to 1
  --then give a debugprint warning
end

this.weaponTableAfgh={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  default=1,
  settingNames="set_switch",
}
this.weaponTableMafr={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  default=1,
  settingNames="set_switch",
}
this.weaponTableSkull={--xof
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  default=1,
  settingNames="set_switch",
}
this.weaponTableDD={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--TODO BREAKOUT these are enabled by Ivar enableDDEquip > InfMain. IsDDEquip
IvarProc.MinMaxIvar(
  this,
  "soldierEquipGrade",
  {default=3},--tex 3 is the min grade at which all weapon types are available
  {default=15},
  {
    range={min=1,max=15}
  }
)

this.allowUndevelopedDDEquip={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.mbSoldierEquipRange={
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={"SHORT","MEDIUM","LONG","RANDOM"},
}

this.mbDDEquipNonLethal={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  MissionCheck=IvarProc.MissionCheckMbAll,
}

--patrol vehicles
this.putEquipOnTrucks={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.itemDropChance={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  --range={min=0,max=this.perSoldierCount,increment=1},
  range={min=0,max=100,increment=10},
  isPercent=true,
}
--< ivar defs

this.registerMenus={
  'customEquipMenu',
}

this.customEquipMenu={
  options={
    --CULL DEBUGNOW are these still being read?
    --    "Ivars.enableDDEquipMB",
    --    "Ivars.enableDDEquipFREE",
    --    "Ivars.enableDDEquipMISSION",
    "Ivars.weaponTableGlobalFREE",
    "Ivars.weaponTableGlobalMISSION",
    "Ivars.weaponTableGlobalMB_ALL",--DEBUGNOW
    
    "Ivars.customWeaponTableFREE",
    "Ivars.customWeaponTableMISSION",
    "Ivars.customWeaponTableMB_ALL",
    "Ivars.weaponTableStrength",
    "Ivars.weaponTableAfgh",
    "Ivars.weaponTableMafr",
    "Ivars.weaponTableSkull",
    "Ivars.weaponTableDD",
    "Ivars.soldierEquipGrade_MIN",
    "Ivars.soldierEquipGrade_MAX",
    "Ivars.allowUndevelopedDDEquip",
    "Ivars.mbDDEquipNonLethal",
  }
}
--< menu defs
this.langStrings={
  eng={
    mbSoldierEquipRange="MB Equip Range Type (MB Prep mode FOB only)",
    mbSoldierEquipRangeSettings={"Short-range","Medium-range","Long-range","Random range"},
    customEquipMenu="Custom soldier equip menu",
    soldierEquipGrade_MIN="DD weapons grade MIN",
    soldierEquipGrade_MAX="DD weapons grade MAX",
    allowUndevelopedDDEquip="Allow undeveloped DD weapons",
    mbDDEquipNonLethal="DD equipment non-lethal",
    itemDropChance="Soldier item drop chance",
    putEquipOnTrucks="Equipment on trucks",
    customWeaponTableFREE="Enemy use custom weapon table in free roam",
    customWeaponTableMISSION="Enemy use custom equip table in missions",
    customWeaponTableMB_ALL="MB staff use custom equip table",
    weaponTableStrength="Weapon stengths",
    weaponTableStrengthSettings={"NORMAL","STRONG","Combined"},
    weaponTableAfgh="Include Soviet weapons",
    weaponTableMafr="Include PF weapons",
    weaponTableSkull="Include XOF weapons",
    weaponTableDD="Include DD weapons",
    weaponTableGlobalFREE="Global soldier weapon table in FreeRoam",
    weaponTableGlobalMISSION="Global soldier weapon table in Missions",
    weaponTableGlobalMB_ALL="Global soldier weapon table in MB",
  },
  help={
    eng={
      customEquipMenu="Allow soldiers to have equipment from other locations/types, including DD equipment usually only used on FOB. Soldiers are assigned a random weapon of the type the prep system assigns them, so you'll see more weapon variation",
      itemDropChance="Chance soldier will drop an item when eliminated.",
      putEquipOnTrucks="Puts a random piece of equipment on the back of patrol trucks.",
      soldierEquipGrade_MIN="A grade will be chosen between MIN and MAX at mission start. Note: Equip grade 3 is the minimum grade that has all types of weapons.",
      allowUndevelopedDDEquip="Whether to limit the selection to equipment you have developed or allow all equipment. Restriction does not apply to Enemies using DD weapons.",
      weaponTableStrength="The game weapon tables have Normal and Strong lists that the Enemy prep system will pick from, this setting allows you to select either, or combine them.",
      weaponTableDD="Add the DD weapons table that's usually used for FOB, the following grade and developed settings control how this table is built",
      weaponTableGlobalFREE="Base soldier weapon table, either the games default or an addon table. Combined soldier weapon table builds from this.",
      weaponTableGlobalMISSION="Base soldier weapon table, either the games default or an addon table. Combined soldier weapon table builds from this.",
      weaponTableGlobalMB_ALL="Base soldier weapon table, either the games default or an addon table. Combined soldier weapon table builds from this.",
    },
  }
}
--< lang strings

--tex GOTCHA there's a limit to how much equip can be loaded before it starts crapping out - players weapons not showing/test equip spawn function crash on ~110th item in list (but weirdly on mg but not sniper in same list position).
--TppEquip.CreateEquipMissionBlockGroup and/or TppEquip.AllocInstances?
--tex also only items with p4 set to TppEquip.EQP_BLOCK_MISSION in /Tpp/Scripts/Equip/EquipIdTable.lua need to be loaded (mostly weapons, support items are alread loaded in EQP_BLOCK_COMMON).
--tex see also AddToCurrentLoadTable which is called after this (TppMain.OnAllocate > TppRevenge.DecideRevenge > _AllocateResources vs TppMain.OnAllocate > module.OnAllocate)
--CALLER: this.OnAllocate
--OUT/SIDE: this.currentLoadTable
function this.LoadEquipTable()
  InfUtil.ClearTable(this.currentLoadTable)
  local equipLoadTable=this.currentLoadTable

  local equipCount=0
  for n,equipName in ipairs(this.tppEquipTableTest)do
    local equipId=TppEquip[equipName]
    if equipId~=nil then
      equipLoadTable[equipId]=true
      equipCount=equipCount+1
    end
  end
  InfCore.Log("InfEquip.LoadEquipTable - #testEquipCount="..equipCount)--DEBUG

  --tex can't skip if itemDropChance 0 because user may enable during mission.
  --tex TODO: equipid TppEquip.EQP_BLOCK_MISSION lookup, then run whole table:
  --for category,equipNames in pairs(this.soldierDropTable)do
  --for n,equipName in ipairs(equipNames)do
  --8 guns
  for n,equipName in ipairs(this.soldierDropTable.HANDGUNS)do
    local equipId=TppEquip[equipName]
    if equipId~=nil then
      if not equipLoadTable[equipId] then
        equipLoadTable[equipId]=true
      end
    end
  end
  --tex TODO add to this.currentEquipLoad table in a once-per-mission way.
  --end

  --8 guns
  if Ivars.enableWildCardFreeRoam:EnabledForMission() then
    for weaponType,equipId in pairs(TppEnemy.weaponIdTable.WILDCARD.NORMAL)do
        equipLoadTable[equipId]=true
    end
  end

  --tex dont really like having this here rather than in InfQuest, but is easiest way to keep track of equipment loaded so the limit can be managed
  if InfQuest then
    if TppMission.IsFreeMission(vars.missionCode) or TppMission.IsStoryMission(vars.missionCode) then--tex TODO theres a quests allowed for mission function or table somewhere.
      local equipCount=0
      for questName,questAddon in pairs(InfQuest.ihQuestsInfo)do
        if TppQuest.IsActive(questName) then
          if questAddon.requestEquipIds then
            InfCore.Log("InfQuest.LoadEquipTable IsActive:"..questName)
            for n,equipName in ipairs(questAddon.requestEquipIds)do
              local equipId=TppEquip[equipName]
              if equipId==nil then
                InfCore.Log("InfQuest.LoadEquipTable: requestEquipIds ERROR: "..questName.."  could not find equipId "..tostring(equipId))
              else
                equipLoadTable[equipId]=true
                equipCount=equipCount+1
              end
            end--for requestEquipIds
          end--if requestEquipIds
        end--if IsActive
      end--for ihQuestsInfo
      InfCore.Log("InfEquip.LoadEquipTable - #questEquipCount="..equipCount)--DEBUG
    end--if freemission or mission
  end--if InfQuest

  local loadEquipTable={}
  for equipId,bool in pairs(equipLoadTable)do
    loadEquipTable[#loadEquipTable+1]=equipId
  end

  InfCore.Log("InfEquip.LoadEquipTable - #loadEquipTable="..#loadEquipTable)--DEBUG

  if #loadEquipTable>0 and TppEquip.RequestLoadToEquipMissionBlock then
    TppEquip.RequestLoadToEquipMissionBlock(loadEquipTable)
  end

  --tex setup weaponIdTable.CUSTOM
  --is RequestLoadToEquipMissionBlock in TppRevenge._AllocateResources
  InfCore.PCallDebug(this.CreateCustomWeaponTable,vars.missionCode,nil,this.currentLoadTable,#loadEquipTable)--DEBUGNOW TEST was in PremissionLoad (ala TppEnemy.PrepareDDParameter)
end

--CALLER: TppRevenge._AllocateResources
--SIDE: this.currentLoadTable
function this.AddToCurrentLoadTable(loadEquipTable)
  if InfMain.IsOnlineMission(vars.missionCode) then
    return
  end

  for i,equipId in ipairs(loadEquipTable)do
    this.currentLoadTable[equipId]=true
  end
  if this.debugModule then
    local count=0
    for equipId,bool in pairs(this.currentLoadTable)do
      count=count+1
    end
    InfCore.Log("InfEquip.AddToCurrentLoadTable - #loadEquipTable="..#loadEquipTable.." #currentLoadTable="..count)--DEBUG
  end
end

function this.Messages()
  return Tpp.StrCode32Table {
    GameObject = {
      {msg="Neutralize",func=this.OnNeutralize},
    },
    Timer={
      {msg="Finish",sender="Timer_DropItem",func=this.DropItem},
    },
  }
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.AddMissionPacks(missionCode,packPaths)
  --tex packs for putting on trucks pickables
  if not Ivars.vehiclePatrolProfile:EnabledForMission() then
    return
  end

  if Ivars.vehiclePatrolTruckEnable:Is(0) then
    return
  end

  if Ivars.putEquipOnTrucks:Is(0) then
    return
  end

  for i,packPath in ipairs(this.packages) do
    packPaths[#packPaths+1]=packPath
  end
end

function this.PreMissionLoad(missionId,currentMissionId)
--CULL this.CreateCustomWeaponTable(missionId)
end

function this.Init(missionTable)
  this.messageExecTable=nil

  if InfMain.IsOnlineMission(vars.missionCode)then
    return
  end

  --tex cant skip on itemDropChance since its an inmission var

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  this.inf_lastNeutralized={}

  this.dropChanceBag=InfUtil.ShuffleBag:New()
  for i=1,this.perSoldierCount do
    local amount=1
    this.dropChanceBag:Add(i,amount)
  end

  this.dropItemBag=InfUtil.ShuffleBag:New()
  for name,amount in pairs(this.itemDropInfo) do
    this.dropItemBag:Add(name,amount)
  end
end

function this.OnAllocate(missionTable)
  if missionTable.enemy then
    this.LoadEquipTable()
  end
end

function this.OnMissionCanStart()
  this.PutEquipOnTrucks()
end

function this.OnReload(missionTable)
  this.messageExecTable=nil

  if InfMain.IsOnlineMission(vars.missionCode)then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

--soldier item drops
function this.OnNeutralize(gameId,sourceId,neutralizeType,neutralizeCause)
  --InfCore.PCall(function(gameId,sourceId,neutralizeType,neutralizeCause)--DEBUG
  local dropChance=Ivars.itemDropChance:Get()/this.perSoldierCount
  if dropChance==0 then
    return
  end

  --tex have to manage table since reinforcements re-use gameobjects
  --a timeout after a few minutes should be fine
  local elapsedTime=Time.GetRawElapsedTimeSinceStartUp()
  local lastNeutralized=this.inf_lastNeutralized[gameId]
  if lastNeutralized and lastNeutralized>elapsedTime then
    return
  end

  this.inf_lastNeutralized[gameId]=elapsedTime+dropTimeOut

  --    local neutralizeTypes={
  --      [NeutralizeType.INVALID]="INVALID",
  --      [NeutralizeType.DEAD]="DEAD",
  --      [NeutralizeType.FAINT]="FAINT",
  --      [NeutralizeType.SLEEP]="SLEEP",
  --      [NeutralizeType.DYING]="DYING",
  --      [NeutralizeType.FULTON]="FULTON",
  --    }

  --InfCore.DebugPrint("Neutralize gameId:"..gameId.." sourceId:"..sourceId.. " neutralizeType:"..neutralizeTypes[neutralizeType].." neutralizeCause:"..neutralizeCause)--DEBUG
  if this.dropChanceBag:Next()<=dropChance then
    --      GkEventTimerManager.Start("Timer_DropItem",dropTimer)
    --      this.inf_dropQueue[#this.inf_dropQueue]=gameId
    this.DropItem(gameId)
  end
  --end,gameId,sourceId,neutralizeType,neutralizeCause)--DEBUG
end

--tex drop system a bit convoluted
--decision whether to drop an item or nothing handled in OnNeutralize by dropChanceBag shufflebag (to get a consistant rate)
--then dropItemBag chooses a category, and a random item from that category in soldierDropTable is chosen
function this.DropItem(gameId)
  --  local gameId=this.inf_dropQueue[1]
  --  table.remove(this.inf_dropQueue,1)
  local category=this.dropItemBag:Next()
  local categoryTable=this.soldierDropTable[category]
  local equipName=categoryTable[math.random(#categoryTable)]

  local equipId=TppEquip[equipName]

  --InfCore.DebugPrint("drop "..equipName)--DEBUG

  --TUNE
  local number=1
  if category=="HANDGUNS" then
    number=math.random(14,26)
  end

  local linearMax=0.1
  local angularMax=4

  local dropOffsetY=1.2

  local dropPosition=GameObject.SendCommand(gameId,{id="GetPosition"})
  if not dropPosition then
    InfCore.Log("WARNING: InfEquip.DropItem: GetPosition nil for gameId:"..tostring(gameId))
  else
    dropPosition=Vector3(dropPosition:GetX(),dropPosition:GetY()+dropOffsetY,dropPosition:GetZ())

    TppPickable.DropItem{
      equipId=equipId,
      number=number,
      position=dropPosition,
      rotation=Quat.RotationY(0),
      linearVelocity=Vector3(math.random(-linearMax,linearMax),math.random(-linearMax,linearMax),math.random(-linearMax,linearMax)),
      angularVelocity=Vector3(math.random(-angularMax,angularMax),math.random(-angularMax,angularMax),math.random(-angularMax,angularMax)),
    }
  end
end

--tex TODO: convert equipidstring to equipid once you mock TppEquip equipid enums
--local pickables={
--  --equipid string={"<locator prefix>",<count>},
--  EQP_SWP_CaptureCage_G02={"pickable_item_capturecage_",1},
--  EQP_IT_CBox_WR={"pickable_item_cardboardbox_",1},
--}
--tex truck items
this.pickables={
  afgh={--WORKAROUND
    "pickable_ih_0000",--EQP_WP_East_ms_020--4283898693--cgm 25
    --"pickable_ih_0001",--EQP_WP_EX_sr_000--2090616205--molotok-68 grade 9
    "pickable_ih_0002",--EQP_WP_EX_gl_000--4169556718--miraz zh 71 grade 9
    "pickable_ih_0003",--EQP_SWP_CaptureCage_G02--452941044
    "pickable_ih_0004",--EQP_IT_CBox_WR--3040902098
    "pickable_ih_0005",--EQP_AB_PrimaryMissile--165673314
    "pickable_ih_0006",--EQP_AB_SecondaryTranq--550443242
    "pickable_ih_0007",--EQP_AB_Suppressor--2248319796
    "pickable_ih_0008",--EQP_AB_Mecha--1087922814
    "pickable_ih_0009",--EQP_WP_West_ms_020--1022605058--fb mr rl nlsp
    "pickable_ih_0010",--EQP_SWP_SupportHeliFlareGrenade--2929309074
    "pickable_ih_0011",--EQP_SWP_SupplyFlareGrenade--160773547
  },
  mafr={
    "pickable_ih_0000",--EQP_WP_East_ms_020--4283898693--cgm 25
    --"pickable_ih_0001",--EQP_WP_EX_sr_000--2090616205--molotok-68 grade 9
    "pickable_ih_0002",--EQP_WP_EX_gl_000--4169556718--miraz zh 71 grade 9
    "pickable_ih_0003",--EQP_SWP_CaptureCage_G02--452941044
    "pickable_ih_0004",--EQP_IT_CBox_WR--3040902098
    "pickable_ih_0005",--EQP_AB_PrimaryMissile--165673314
    "pickable_ih_0006",--EQP_AB_SecondaryTranq--550443242
    "pickable_ih_0007",--EQP_AB_Suppressor--2248319796
    "pickable_ih_0008",--EQP_AB_Mecha--1087922814
    "pickable_ih_0009",--EQP_WP_West_ms_020--1022605058--fb mr rl nlsp
    "pickable_ih_0010",--EQP_SWP_SupportHeliFlareGrenade--2929309074
    "pickable_ih_0011",--EQP_SWP_SupplyFlareGrenade--160773547
  },
}
--
function this.PutEquipOnTrucks()
  if not Ivars.vehiclePatrolProfile:EnabledForMission() then
    return
  end

  if Ivars.vehiclePatrolTruckEnable:Is(0) then
    return
  end

  if Ivars.putEquipOnTrucks:Is(0) then
    return
  end
  
  InfCore.LogFlow"InfEquip.PutEquipOnTrucks"

  InfMain.RandomSetToLevelSeed()
  local locationName=TppLocation.GetLocationName()
  local pickableBag=InfUtil.ShuffleBag:New(this.pickables[locationName])
  local pickableCount=pickableBag:Count()

  if InfVehicle.inf_patrolVehicleInfo then
    local truckStr="TRUCK"
    local numPutOn=0
    for vehicleName,vehicleInfo in pairs(InfVehicle.inf_patrolVehicleInfo) do
      if vehicleInfo.baseType==truckStr then
        local vehicleId=GetGameObjectId(vehicleName)
        if vehicleId~=NULL_ID then
          local itemLocator=pickableBag:Next()
          --InfCore.Log("PutOn "..vehicleName.." "..itemLocator)--DEBUG
          TppPickable.PutOn(itemLocator,vehicleId,0)
          numPutOn=numPutOn+1
          if numPutOn==pickableCount then
            break
          end
        end
      end
    end
  end
  InfMain.RandomResetToOsTime()
  --end)--
end

--EnemyEquip

local weaponTableTypes={
  SOVIET_A="AFGH",
  PF_A="MAFR",
  PF_B="MAFR",
  PF_C="MAFR",
  SKULL_CYPR="SKULL",
  SKULL="SKULL",
  DD="DD",
}
local ivarNameToWeaponTableType={
  weaponTableAfgh="AFGH",
  weaponTableMafr="MAFR",
  weaponTableSkull="SKULL",
  weaponTableDD="DD",
}

--tex see GOTCHA note before LoadEquipTable above
--Don't know if it's a count or a memory thing (which would depend on the mix of equipment loaded)
local maxEquipment=45--47--ok --50 no good
--CALLER: LoadEquipTable
--OUT: TppEnemy.weaponIdTable.DD, TppEnemy.weaponIdTable.CUSTOM
function this.CreateCustomWeaponTable(missionCode,settingsTable,currentLoadTable,currentLoadCount)
  if not IvarProc.EnabledForMission("customWeaponTable",missionCode) then
    return nil
  end

  InfCore.LogFlow"InfEquip.CreateCustomWeaponTable"

  local strengthType
  local activeTypes
  local noneActive=true
  if settingsTable then
    InfCore.Log"settingsTable"--DEBUGNOW
    noneActive=false
    strengthType=settingsTable.strengthType
    activeTypes=settingsTable.weaponTypes
  else
    strengthType=Ivars.weaponTableStrength:GetSettingName()
    activeTypes={}
    for ivarName,ivarType in pairs(ivarNameToWeaponTableType)do
      if Ivars[ivarName]:Is(1) then
        InfCore.Log("Ivar "..ivarName.." ActiveType "..ivarType)--DEBUGNOW
        noneActive=false
        activeTypes[ivarType]=true
      end
    end
  end

  InfCore.PrintInspect(activeTypes,"activeTypes")

  if noneActive then
    InfCore.Log("WARNING: CreateCustomWeaponTable - no weapon types set.",true,true)--DEBUG
    local weaponIdTable={NORMAL={HANDGUN=TppEquip.EQP_WP_West_hg_010,ASSAULT=TppEquip.EQP_WP_West_ar_040}}
    TppEnemy.weaponIdTable.DD=weaponIdTable--tex MB needs DD set to something
    TppEnemy.weaponIdTable.CUSTOM=weaponIdTable
    return weaponIdTable
  end

  if activeTypes.DD then
    --tex usually built with TppEneFova.PreMissionLoad > TppEnemy.PrepareDDParameter > _CreateDDWeaponIdTable
    TppEnemy.weaponIdTable.DD=this.CreateDDWeaponIdTable()
  end
  
  local weaponIdTable=InfWeaponIdTable.GetWeaponIdTable()--tex returns TppEnemy.WeaponIdTable if default
  weaponIdTable.DD=TppEnemy.weaponIdTable.DD--WORKAROUND: rest of the code should use TppEnemy.weaponIdTable.DD, but below combines DD so it needs to be in selected weaponIdTable

  --tex combine all active weapon tables
  local allTotal=0
  local allNoDuplicates={}
  for weaponTableType,ivarType in pairs(weaponTableTypes) do
    if activeTypes[ivarType] then
      local weaponTable=weaponIdTable[weaponTableType]
      for strength,weapons in pairs(weaponTable)do
        if strengthType=="COMBINED" or strengthType==strength then
          for weaponType,weaponId in pairs(weapons)do
            allNoDuplicates[weaponType]=allNoDuplicates[weaponType] or {}
            if type(weaponId)=="table" then
              for i,weaponId in ipairs(weaponId)do
                allNoDuplicates[weaponType][weaponId]=true
              end
            else
              allNoDuplicates[weaponType][weaponId]=true
            end
            allTotal=allTotal+1
          end--for weapons
        end--if strenghtType
      end--for weaponTable
    end--if activeTypes
  end--for weaponTableTypes

  --tex transform back to TppEnemy.weaponIdTable format
  local weaponIdTableAll={}
  for weaponType,weaponIds in pairs(allNoDuplicates)do
    local toWeaponIds=weaponIdTableAll[weaponType] or {}
    for weaponId,bool in pairs(weaponIds)do
      table.insert(toWeaponIds,weaponId)
    end
    weaponIdTableAll[weaponType]=toWeaponIds
  end

  InfCore.Log("allTotal="..allTotal)
  if this.debugModule then
    InfCore.PrintInspect(weaponIdTableAll,"weaponIdTableAll")--DEBUG
  end

  --tex these dont count towards equipcount or always resident? VERIFY
  local skipType={
    IS_NOKILL=true,
    GRENADE=true,
    STUN_GRENADE=true,
    SNEAKING_SUIT=true,
    BATTLE_DRESS=true,
  }

  --tex add those that are already in the current loaded equip table (soldier drops, wildcards, quests etc from loadequiptable).
  --NOTE: only builds NORMAL because there's no point in doing a normal strong split when you have control over building the table and the purpose is variation
  local weaponIdTableFinal={NORMAL={}}
  for weaponType,weaponIds in pairs(weaponIdTableAll)do
    if skipType[weaponType] then
      weaponIdTableFinal.NORMAL[weaponType]=weaponIds--tex some of these not actually weaponids for these
    else
      weaponIdTableFinal.NORMAL[weaponType]=weaponIdTableFinal.NORMAL[weaponType] or {}
      for i,weaponId in ipairs(weaponIds)do
        if currentLoadTable[weaponId] then
          table.insert(weaponIdTableFinal.NORMAL[weaponType],weaponId)
        end
      end
    end
  end

  if this.debugModule then
    InfCore.PrintInspect(weaponIdTableFinal,"weaponIdTableFinal Initial")--DEBUG
  end

  --tex add more weapons till we hit the limit
  local toAddCount=maxEquipment-currentLoadCount
  InfCore.Log("CreateCustomWeaponTable currentLoadCount="..currentLoadCount.." maxEquipment="..maxEquipment.." toAddCount="..toAddCount)--DEBUGNOW

  local function GetLeastWeaponType(weaponTable,weaponTypes)
    local leastWeaponCount=9999999999
    local leastWeaponType
    for weaponType,weaponIds in pairs(weaponTable)do
      if weaponTypes[weaponType] then
        if #weaponIds<leastWeaponCount then
          leastWeaponCount=#weaponIds
          leastWeaponType=weaponType
        end
      end
    end
    if this.debugModule then
      if leastWeaponType==nil then
        InfCore.Log("GetLeastWeaponType leastWeaponType==nil")
        InfCore.PrintInspect(weaponTypes,"leastWeaponTypes")
        InfCore.PrintInspect(weaponTable,"weaponTable")
      end
    end
    --
    return leastWeaponType
  end

  InfMain.RandomSetToLevelSeed()
  for i=1,toAddCount do
    local typeCount=0
    local leastWeaponTypes={}
    for weaponType,weaponIds in pairs(weaponIdTableFinal.NORMAL)do
      if not skipType[weaponType] then
        --InfCore.PrintInspect(weaponIdTableAll[weaponType],"weaponIdTableAll["..weaponType.."]")--DEBUG
        if weaponIdTableAll[weaponType] then
          leastWeaponTypes[weaponType]=true
          typeCount=typeCount+1
        end
      end
    end
    if typeCount==0 then
      InfCore.Log("WARNING: typeCount==0 while toAddCount="..toAddCount)--DEBUGNOW
      break
    end

    local leastWeaponType=GetLeastWeaponType(weaponIdTableFinal.NORMAL,leastWeaponTypes)
    if this.debugModule then
      InfCore.Log("leastWeaponType="..tostring(leastWeaponType))--DEBUG
    end
    local weaponIds=weaponIdTableAll[leastWeaponType]
    if #weaponIds>0 then
      local rnd=math.random(#weaponIds)
      local weaponId=weaponIds[rnd]
      table.remove(weaponIds,rnd)
      table.insert(weaponIdTableFinal.NORMAL[leastWeaponType],weaponId)
    end
  end
  InfMain.RandomResetToOsTime()

  for weaponName,weaponIds in pairs(weaponIdTableFinal.NORMAL)do
    local shuffleBag=InfUtil.ShuffleBag:New()
    shuffleBag:Fill(weaponIds)
    weaponIds.bag=shuffleBag
  end

  if this.debugModule then
    InfCore.PrintInspect(weaponIdTableFinal,"weaponIdTableFinal")--DEBUG
  end

  TppEnemy.weaponIdTable.CUSTOM=weaponIdTableFinal
end--CreateCustomWeaponTable

--tex adapted from TppEnemy._CreateDDWeaponIdTable
function this.CreateDDWeaponIdTable(settingsTable)
  local minGrade=Ivars.soldierEquipGrade_MIN:Get()
  local maxGrade=Ivars.soldierEquipGrade_MAX:Get()
  local nonLethal=Ivars.mbDDEquipNonLethal:Is(1)

  local ddWeaponIdTable={NORMAL={}}
  local ddWeaponIdTableNormal=ddWeaponIdTable.NORMAL
  ddWeaponIdTableNormal.IS_NOKILL={}
  local DDWeaponIdInfo=TppEnemy.DDWeaponIdInfo
  for powerType,weaponInfoTable in pairs(DDWeaponIdInfo)do
    for n,ddWeaponInfo in ipairs(weaponInfoTable)do
      local addWeapon=false
      local developedEquipType=ddWeaponInfo.developedEquipType
      if developedEquipType==nil then
        --tex this only affects default assault and grenade TODO, figure out which grade the first item with developedEquipType and make sure minGrade covers up to it
        if minGrade==1 then
          addWeapon=true
        else
          addWeapon=false
        end
      elseif ddWeaponInfo.isNoKill and not nonLethal then
        addWeapon=false
      elseif not ddWeaponInfo.isNoKill and nonLethal then
        addWeapon=false
      else
        local developId=ddWeaponInfo.developId
        local developGrade=TppMotherBaseManagement.GetEquipDevelopRank(developId)
        --InfCore.DebugPrint("dd power:"..tostring(powerType).." developid:"..tostring(ddWeaponInfo.developId).." developRank:"..tostring(developRank))--DEBUG
        local isDeveloped=TppMotherBaseManagement.IsEquipDevelopedFromDevelopID{equipDevelopID=developId}
        if Ivars.allowUndevelopedDDEquip:Is(1) then
          isDeveloped=true
        end

        if developGrade>=minGrade and developGrade<=maxGrade and isDeveloped then--tex added override
          addWeapon=true
        end
      end
      if addWeapon then
        ddWeaponIdTableNormal[powerType]=ddWeaponIdTableNormal[powerType] or {}
        table.insert(ddWeaponIdTableNormal[powerType],ddWeaponInfo.equipId)

        if ddWeaponInfo.isNoKill then
          ddWeaponIdTableNormal.IS_NOKILL[powerType]=true
        end
      end
    end
  end

  --tex SetUpDDParameter isn't set up for tables if ids, grenade type seems to be global anyway so might as well just conver there
  local singularPowers={
    GRENADE=true,
    STUN_GRENADE=true,
    SNEAKING_SUIT=true,
    BATTLE_DRESS=true,
  }
  for weaponName,weaponIds in pairs(ddWeaponIdTable.NORMAL)do
    if singularPowers[weaponName] then
      if type(weaponIds)=="table" then
        --weaponIdTable.NORMAL[weaponName]=weaponIds[math.random(#weaponIds)]
        --ASSUMPTION equipId in strength order
        ddWeaponIdTable.NORMAL[weaponName]=weaponIds[1]
      end
    end
  end

  return ddWeaponIdTable
end--CreateDDWeaponIdTable

return this
