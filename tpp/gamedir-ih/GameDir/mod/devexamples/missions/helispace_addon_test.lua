--helispace_addon_test.lua
--test helisspace addon using vanilla game location (afgh) as idle space and mission prep space
local this={	
	missionCode=43000,
  location="AFGH",
}

--tex currently not much different from TppMissionList.missionPackTable[40010] (or any of the other helispace missionPackTables)
--just pointing to the test mission area fpk (the only pack listed here that you should need to mod)
this.missionPacks=function(missionCode)
  if gvars.ini_isTitleMode then
    TppPackList.SetDefaultMissionPackLabelName()
  end
  TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/heli/heli_common_script.fpk"
  if TppPackList.IsMissionPackLabel"PS3Store"then
    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/common/title_sequence.fpk"
    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/common/helispace_ps3store.fpk"
  elseif TppPackList.IsMissionPackLabel"avatarEdit"then
    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/common/title_sequence.fpk"
    TppPackList.AddAvatarEditPack()
    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/heli/h40010/h40010_avatar.fpk"
  else
    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/common/title_sequence.fpk"
    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/heli/heli_ui.fpk"
    TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
    --TppPackList.AddLocationCommonScriptPack(missionCode)--tex has not been updated to be addon aware, so we'll manually list ours below
    TppPackList.AddMissionPack"/Assets/tpp/pack/location/afgh/pack_common/afgh_script.fpk"

    --TppPackList.AddDefaultMissionAreaPack(missionCode)--tex is based on mission code, so we'll manually list ours below instead
    --tex for test is pretty much a copy of h40010_area.fpk/d, 
    --with bare minimum of _sequence.fox2 player locator shifted and flor_common_asset.fox2 StageCenter and PlayerPosition shifted 
    --to test changes between idle helispace and prep space.
    --in order for player to not go 'missing' at title, instead of shifting player_locator_0000 create a new generic Locator and point HelispaceLocatorIdentifier PlayerLocator to that instead
    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/heli/hbaseloc/hbaseloc_area.fpk"
  end
  TppHostage2.SetHostageType{gameObjectType="TppHostage2",hostageType="Mob"}--tex for vanilla acc pilot
end

this.heliSpace={
  --want to be helispace for all locations, 
  --if you use this then technically you dont need any other locations or missions entries
  --however other helispaces that do specify missions,locations will be selected first
  ALL=true,

  --missions this is helispace for
  -- missions={
  --   30050,
  -- },
  -- --locations this is helispace for
  -- locations={
  --   "MAFR",
  -- },
}--heliSpace

--tex if your _sequence.fox2 PlayerLocator for helispace idle is on actual location terrain, this will load it in rather than leave it with no LOD
this.setStageBlockOnHeliSpace=true

--RequestToPlayDirectMotion table (see InfMotion for notes) for helispace idle, replaces sitting in heli anim
this.inHeliSpaceDirectMotion={
  "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_20_st.gani",

  --NOTE: there's probably lots of inventive ways to have a player break the game by letting them roam around in existing location while in helispace. You should probably have a very locked down/corraled custom area if you're going to do this
  false,--holdMotion: true = freeze anim at end, false = return to control of player in helispace idle

  "",--gameObjectTargetName
  "",--cnpTargetName
  "",--mtpTargetName
  true,--repeatMotion: holdMotion prevents controls/idroid from working, unless this is set to true
}

--heli_common_sequence does a bunch of WeatherManager.RequestTag calls as different points, 
--mostly its just helispace idle and prep space
--but customize weapon and customize heli/vehicle get there own tags for whatever reason
--also in vanilla helispace area flor_common_asset has a trap that requesttags sortie_space (but if you're bypassing that then it wont be hit)
--vanilla values:
-- this.heliSpaceWeatherTags={
--   title="heli_space",--tex the vanilla game doesn't set this differently, but IH kind of seperates title from helispace idle
--   heliSpace="heli_space",
--   prepSpace="sortie_space",
--   customizeVehicle="sortie_space_heli",--Customize_Target_Helicopter, Customize_Target_Vehicle
--   customizeWeapon="sortie_space_ShadowShort",--Customize_Target_Weapon
-- }

this.weatherTags={
  title="heli_space",
  --tex the helispace test places all spaces (except title) on afgh world terrain
  heliSpace="default",--tex normal world weather tag
  prepSpace="default",
  customizeVehicle="default",--Customize_Target_Helicopter, Customize_Target_Vehicle
  customizeWeapon="default",--Customize_Target_Weapon
}

--tex Used by a few camera setup functions in heli_common_sequence
--in the base game (a simplified version of) the table is only used for UpdateCameraParameter
--if this table does not exist then it will use the vanilla (see InfHeliSpace.SelectCameraParameter)
--i've expanded it for more heli_common_sequence camera functions
--<heli_common_sequence function name>--Defaults: the parameters that follow after it will merge over those values.
--linkKey: EntityLink key in PreparationStageIdentifier (flor_common_asset.fox2 in vanilla heliSpaces), will set aroundCam.target with locators position
--aroundCam table: is a SetAroundCameraManualModeParams table (search the game lua for other parameters it supports)
--aroundCam target=Vector3(x,y,z) will override linkKeys locator position
--aroundCam ignoreObjectType: GameObject name (ex: "TppWalkerGear2") will be used by function to set aroundCam.ignoreCollisionGameObjectId
--the SetCameraStageCenter* functions are a bit messy since they have a seperate setting if buddy horse is on the stage
this.SelectCameraParameter={--tex heli_common_sequence defaults
  --for SetCameraStageCenter function >
  --handles the default camera for mission prep, when not in any of the sub menus of mission prep   
  SetCameraStageCenter={--Defaults
    linkKey="StageCenter",
    --tex dumb values so you notice the difference
    --aroundCam={distance=400000.0,targetInterpTime=0.3,ignoreCollisionGameObjectName="Player"},
    --normal values: 
    aroundCam={distance=4.0,targetInterpTime=0.3,ignoreCollisionGameObjectName="Player"},
    rotation={rotX=-5,rotY=170,interpTime=0.3}
  },
  SetCameraStageCenter_Horse={
    linkKey="StageCenter_Horse",
    aroundCam={distance=4.5},
  },
  --for SetCameraStageCenter function<
  --for SetCameraStageCenter_Go function> 
  --called on SortieTimeSelect
  SetCameraStageCenter_Go={--Defaults
    linkKey="StageCenter",
    --tex dumb values so you notice the difference
    aroundCam={distance=3000,targetInterpTime=0.6,ignoreCollisionGameObjectName="Player"},
    --normal values: aroundCam={distance=3.0,targetInterpTime=0.6,ignoreCollisionGameObjectName="Player"},
    rotation={rotX=-5,rotY=70,interpTime=0.6}
    --normal values: rotation={rotX=-5,rotY=170,interpTime=0.6}
  },
  SetCameraStageCenter_Go_Horse={
    linkKey="StageCenter_Horse",
    aroundCam={distance=3.0},
  },
  --for SetCameraStageCenter_Go function<
  --for SetCameraStageCenter_GoOut function> 
  --called OnMissionPreparetionEnd
  --the values in vanilla are actually just the same as SetCameraStageCenter
  SetCameraStageCenter_GoOut={--Defaults
    linkKey="StageCenter",
    --tex dumb values so you notice the difference
    aroundCam={distance=400,targetInterpTime=0.3,ignoreCollisionGameObjectName="Player"},
    --normal values: aroundCam={distance=4.0,targetInterpTime=0.3,ignoreCollisionGameObjectName="Player"},
    rotation={rotX=-5,rotY=17,interpTime=0.3}
    --normal values: rotation={rotX=-5,rotY=170,interpTime=0.3}
  },
  SetCameraStageCenter_GoOut_Horse={
    linkKey="StageCenter_Horse",
    aroundCam={distance=4.5},
  },
  --for SetCameraStageCenter_GoOut function<
  --for UpdateCameraParameter>
  --handles most of the camera settings for sub menus of mission prep, but also the customize menu outside of mission prep
  UpdateCameraParameter={--Defaults
    aroundCam={focusDistance=8.175,targetInterpTime=0.3}},

  MissionPrep_FocusTarget_Weapon={
    linkKey="WeaponPosition",
    --tex dumb values so you notice the difference
    aroundCam={distance=100000.5,focusDistance=1.5,aperture=1.6,targetIsPlayer=false},
    --normal values: aroundCam={distance=1.5,focusDistance=1.5,aperture=1.6,targetIsPlayer=false},
    rotation={rotX=-10,rotY=17,interpTime=0.3}},
    --normal values: rotation={rotX=-10,rotY=170,interpTime=0.3}},
  MissionPrep_FocusTarget_PrimaryWeapon={linkKey="PlayerPosition",aroundCam={distance=3.0},rotation={rotX=5,rotY=230,interpTime=0.4}},
  MissionPrep_FocusTarget_PrimaryWeapon_HIP={linkKey="PlayerPosition",aroundCam={distance=2.5},rotation={rotX=5,rotY=220,interpTime=0.4}},
  MissionPrep_FocusTarget_PrimaryWeapon_BACK={linkKey="PlayerPosition_Up",aroundCam={distance=3.0},rotation={rotX=5,rotY=320,interpTime=0.4}},
  MissionPrep_FocusTarget_SecondaryWeapon={linkKey="PlayerPosition",aroundCam={distance=3.0},rotation={rotX=-5,rotY=160,interpTime=0.3}},
  MissionPrep_FocusTarget_SecondaryWeapon_WEAPON={linkKey="PlayerPosition",aroundCam={distance=2.0},rotation={rotX=-5,rotY=150,interpTime=0.3}},
  MissionPrep_FocusTarget_SecondaryWeapon_ARM={linkKey="PlayerPosition_Up",aroundCam={distance=2.0},rotation={rotX=-5,rotY=230,interpTime=0.3}},
  MissionPrep_FocusTarget_SupportWeapon={linkKey="PlayerPosition_Up",aroundCam={distance=1.8},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  MissionPrep_FocusTarget_Item={linkKey="PlayerPosition_Up",aroundCam={distance=3.3},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  MissionPrep_FocusTarget_Suit={linkKey="PlayerPosition_Up",aroundCam={distance=3.3},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  MissionPrep_FocusTarget_HeadOption={linkKey="PlayerHeadPosition",aroundCam={distance=2.3},rotation={rotX=-5,rotY=170,interpTime=0.3}},
--tex dumb values so you notice the difference
  MissionPrep_FocusTarget_Player={linkKey="PlayerPosition_Up",aroundCam={distance=300.3},rotation={rotX=-50,rotY=100,interpTime=0.3}},
--normal values: MissionPrep_FocusTarget_Player={linkKey="PlayerPosition_Up",aroundCam={distance=3.3},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  MissionPrep_FocusTarget_BuddyQuiet={linkKey="BuddyQuietPosition",aroundCam={distance=3.6,ignoreObjectType="TppWalkerGear2"},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  MissionPrep_FocusTarget_BuddyQuietEquip={linkKey="BuddyQuietPosition_Up",aroundCam={distance=3.2,ignoreObjectType="TppWalkerGear2"},rotation={rotX=-5,rotY=270,interpTime=0.4}},

  MissionPrep_FocusTarget_BuddyDog={linkKey="BuddyDogPosition",aroundCam={distance=3.8,ignoreObjectType="TppWalkerGear2"},rotation={rotX=-5,rotY=182,interpTime=0.3}},
  MissionPrep_FocusTarget_BuddyHorse={linkKey="BuddyHorsePosition_2",aroundCam={distance=5.3,ignoreObjectType="TppWalkerGear2"},rotation={rotX=-5,rotY=180,interpTime=0.3}},
  MissionPrep_FocusTarget_BuddyWalker={linkKey="BuddyPosition",aroundCam={distance=4.0,ignoreObjectType="TppWalkerGear2"},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  MissionPrep_FocusTarget_BuddyBattleGear={linkKey="BuddyPosition",aroundCam={distance=5.8,ignoreObjectType="TppWalkerGear2"},rotation={rotX=-5,rotY=170,interpTime=0.3}},

  MissionPrep_FocusTarget_Vehicle={linkKey="VehicleCameraPosition",aroundCam={distance=9.0,ignoreObjectType="TppVehicle2"},rotation={rotX=24,rotY=65,interpTime=0.6}},

  MissionPrep_FocusTarget_None={linkKey="StageCenter",aroundCam={distance=3.5},rotation={rotX=-5,rotY=170,interpTime=0.3}},

  Customize_Target_Weapon={linkKey="CustomizeWeaponPosition",aroundCam={distance=1.7},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_Buddy={linkKey="CustomizeBuddyPosition",aroundCam={distance=4.5,ignoreObjectType="TppWalkerGear2"},rotation={rotX=-5,rotY=170,interpTime=0.3}},

  Customize_Weapon_Handgun={linkKey="CustomizeWeaponPosition",aroundCam={distance=1.0},rotation={rotX=0,rotY=180,interpTime=0.3}},
  Customize_Weapon_SubMachinegun={linkKey="CustomizeWeaponPosition",aroundCam={distance=1.4},rotation={rotX=0,rotY=180,interpTime=0.3}},
  Customize_Weapon_AssaultRifle={linkKey="CustomizeWeaponPosition",aroundCam={distance=1.5},rotation={rotX=0,rotY=180,interpTime=0.3}},
  Customize_Weapon_ShotGun={linkKey="CustomizeWeaponPosition",aroundCam={distance=1.5},rotation={rotX=0,rotY=180,interpTime=0.3}},
  Customize_Weapon_GrenadeLauncher={linkKey="CustomizeWeaponPosition",aroundCam={distance=1.5},rotation={rotX=0,rotY=180,interpTime=0.3}},
  Customize_Weapon_SniperRifle={linkKey="CustomizeWeaponPosition",aroundCam={distance=1.7},rotation={rotX=0,rotY=180,interpTime=0.3}},
  Customize_Weapon_MachineGun={linkKey="CustomizeWeaponPosition",aroundCam={distance=1.7},rotation={rotX=0,rotY=180,interpTime=0.3}},
  Customize_Weapon_Missile={linkKey="CustomizeWeaponPosition",aroundCam={distance=1.7},rotation={rotX=0,rotY=180,interpTime=0.3}},

  Customize_Target_BuddyDog={linkKey="CustomizeBuddyPosition",aroundCam={distance=4.5},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_Dog_Body={linkKey="CustomizeBuddyPosition",aroundCam={distance=4.5},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_Dog_Eye={linkKey="CustomizeBuddyPosition",aroundCam={distance=4.5},rotation={rotX=-5,rotY=170,interpTime=0.3}},

  Customize_Target_BuddyHorse={linkKey="CustomizeBuddyPosition_HorsePos",aroundCam={distance=4.5},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_Horse_Body={linkKey="CustomizeBuddyPosition_HorsePos",aroundCam={distance=4.5},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_Horse_Head={linkKey="CustomizeBuddyPosition_HorsePos",aroundCam={distance=4.5},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_Horse_Leg={linkKey="CustomizeBuddyPosition_HorsePos",aroundCam={distance=4.5},rotation={rotX=-5,rotY=170,interpTime=0.3}},

  Customize_Target_BuddyWalker={linkKey="CustomizeBuddyPosition_DWPos",aroundCam={distance=4.8},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_DW_Body={linkKey="CustomizeBuddyPosition_DWPos",aroundCam={distance=4.8},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_DW_Manipulator={linkKey="CustomizeBuddyPosition_DWPos",aroundCam={distance=4.0},rotation={rotX=-5,rotY=120,interpTime=0.3}},
  Customize_Target_DW_MainWeapon={linkKey="CustomizeBuddyPosition_Head",aroundCam={distance=3.0},rotation={rotX=7,rotY=185,interpTime=0.3}},
  Customize_Target_DW_SubWeapon={linkKey="CustomizeBuddyPosition_Head",aroundCam={distance=3.0},rotation={rotX=3,rotY=115,interpTime=0.3}},
  Customize_Target_DW_Head={linkKey="CustomizeBuddyPosition_Head",aroundCam={distance=3.0},rotation={rotX=25,rotY=90,interpTime=0.3}},
  Customize_Target_DW_Color={linkKey="CustomizeBuddyPosition_DWPos",aroundCam={distance=4.8},rotation={rotX=-5,rotY=170,interpTime=0.3}},

  Customize_Target_Heli_Body={linkKey="CustomizeHelicopterCameraPosition",aroundCam={distance=16},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_Heli_Main={linkKey="CustomizeHelicopterCameraPosition_MainWeapon",aroundCam={distance=10},rotation={rotX=25,rotY=150,interpTime=0.3}},
  Customize_Target_Heli_OpFlare={linkKey="CustomizeHelicopterCameraPosition",aroundCam={distance=16},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_Heli_OpArmor={linkKey="CustomizeHelicopterCameraPosition",aroundCam={distance=16},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_Heli_Color={linkKey="CustomizeHelicopterCameraPosition",aroundCam={distance=16},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_Helicopter={linkKey="CustomizeHelicopterCameraPosition",aroundCam={distance=16},rotation={rotX=-5,rotY=170,interpTime=0.3}},
  Customize_Target_Vehicle={linkKey="CustomizeVehicleCameraPosition",aroundCam={distance=12,ignoreObjectType="TppVehicle2"},rotation={rotX=15,rotY=150,interpTime=0.2}},
}--SelectCameraParameter
--HeliSpace only missionInfo parameters<
return this