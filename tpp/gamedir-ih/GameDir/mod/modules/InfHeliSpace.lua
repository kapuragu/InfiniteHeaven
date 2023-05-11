--InfHeliSpace.lua
--implements heli_common_sequence stuff and helispace addon specific stuff
--the majority of heli space addons is handled by InfMission addon system

--tex loading addon helispaces on missionPrep:
--this.OnSelectLandPoint
--heli_common_sequence.Seq_Game_MainGame_OnEnter 
--  > this.Seq_Game_MainGame_OnEnterPost 
--    > heli_common_sequence OnSelectLandingPoint

--loading addon helispace when base game normally loads helispace:
-- Helispace is chosen on functions calling TppMission/InfMission .GetCurrentLocationHeliMissionAndLocationCode
-- I converted a few more to use GetCurrentLocationHeliMissionAndLocationCode that werent previously
-- TODO: see if I've missed any, search 40010,TppDefine.SYS_MISSION_ID.AFGH_HELI

local StrCode32=InfCore.StrCode32

local this={}

--CALLER: heli_common_sequence Seq_Game_MainGame	msg  Terminal.MbDvcActSelectLandPoint
--DEBUGNOW theres no other base game subscribers to MbDvcActSelectLandPoint, but authors could also subscribe, what's the exec flow?
--do we need onfadeoutdirect instead?
function this.OnSelectLandPoint(missionCode,heliRoute,layoutCode,clusterCategory)
	mvars.heliSequence_startFobSneaking=false
	mvars.heliSequence_nextMissionCode=missionCode
	mvars.heliSequence_heliRoute=heliRoute
	mvars.heliSequence_clusterCategory=clusterCategory

  
	if helispace_loadOnSelectLandPoint==0 then
    TppUI.FadeOut(TppUI.FADE_SPEED.FADE_HIGHESTSPEED,"OnSelectLandingPoint")
    return
  end

  local helispace,helispaceLocation=InfMission.GetHelispaceForMission(missionCode)

  if ivars.helispace_loadOnSelectLandPoint==0 then
    helispace=nil
  elseif ivars.helispace_loadOnSelectLandPoint==Ivars.helispace_loadOnSelectLandPoint.enum.ADDON then
    --tex addon helispaces only?
    if helispace and not InfMission.missionInfo[helispace] then
      helispace=nil
    end
  end

  if helispace and helispace~=vars.missionCode then
    InfCore.Log("Loading helispace "..helispace)
    this.transitionToAddonHelispace=true
    --tex mvars are cleared on mission change so need to store them
    this.mvars={}
    this.mvars.heliSequence_startFobSneaking=false
    this.mvars.heliSequence_nextMissionCode=missionCode
    this.mvars.heliSequence_heliRoute=heliRoute
    this.mvars.heliSequence_clusterCategory=clusterCategory
    this.mvars.heliSequence_layoutCode=layoutCode--not actually stored in base game
    
    --tex see this.Seq_Game_MainGame_OnEnter for transition to mission prep once loaded
    --DEBUGNOW TODO: no pause and end of loading screen
    gvars.ini_isTitleMode=false

    --varsave for bleh
    local prevMissionCode=vars.missionCode

    Ivars.prevMissionCode=vars.missionCode
    vars.missionCode=helispace
    vars.locationCode=helispaceLocation
    TppSave.VarSave()
    TppSave.SaveGameData()

    --TppUiStatusManager.SetStatus("AnnounceLog","INVALID_LOG")
    TppMission.RequestLoad(vars.missionCode,prevMissionCode,{showLoadingTips=false})
  else
    TppUI.FadeOut(TppUI.FADE_SPEED.FADE_HIGHESTSPEED,"OnSelectLandingPoint")
  end
end--OnSelectLandPoint

--CALLER: InfMain.OnEnterACC < Post heli_common_sequence.Seq_Game_MainGame.OnEnter
this.Seq_Game_MainGame_OnEnterPost=function()
  if this.transitionToAddonHelispace then
    this.transitionToAddonHelispace=false

    mvars.heliSequence_startFobSneaking=false
    mvars.heliSequence_nextMissionCode=this.mvars.heliSequence_nextMissionCode
    mvars.heliSequence_heliRoute=this.mvars.heliSequence_heliRoute
    mvars.heliSequence_clusterCategory=this.mvars.heliSequence_clusterCategory
    TppUI.FadeOut(0,"OnSelectLandingPoint")
    --heli_common_sequence.OnEndFadeOutSelectLandingPoint()
  end
end--Seq_Game_MainGame_OnEnterPost


local focusTargetNames={
  "MissionPrep_FocusTarget_Weapon",
	"MissionPrep_FocusTarget_PrimaryWeapon",
	"MissionPrep_FocusTarget_PrimaryWeapon_HIP",
	"MissionPrep_FocusTarget_PrimaryWeapon_BACK",

	"MissionPrep_FocusTarget_SecondaryWeapon",
	"MissionPrep_FocusTarget_SecondaryWeapon_WEAPON",
	"MissionPrep_FocusTarget_SecondaryWeapon_ARM",
	"MissionPrep_FocusTarget_SupportWeapon",
	"MissionPrep_FocusTarget_Item",

	"MissionPrep_FocusTarget_Suit",

	"MissionPrep_FocusTarget_HeadOption",

	"MissionPrep_FocusTarget_Player",
	
	"MissionPrep_FocusTarget_BuddyQuiet",

	"MissionPrep_FocusTarget_BuddyQuietEquip",
	"MissionPrep_FocusTarget_BuddyDog",
	"MissionPrep_FocusTarget_BuddyHorse",
	"MissionPrep_FocusTarget_BuddyWalker",
	"MissionPrep_FocusTarget_BuddyBattleGear",
	"MissionPrep_FocusTarget_Vehicle",

	"MissionPrep_FocusTarget_None",
	"Customize_Target_Weapon",
	"Customize_Target_Buddy",

	"Customize_Weapon_Handgun",
	"Customize_Weapon_SubMachinegun",
	"Customize_Weapon_AssaultRifle",
	"Customize_Weapon_ShotGun",
	"Customize_Weapon_GrenadeLauncher",
	"Customize_Weapon_SniperRifle",
	"Customize_Weapon_MachineGun",
	"Customize_Weapon_Missile",

	"Customize_Target_BuddyDog",
	"Customize_Target_Dog_Body",
	"Customize_Target_Dog_Eye",

	
	"Customize_Target_BuddyHorse",
	"Customize_Target_Horse_Body",
	"Customize_Target_Horse_Head",
	"Customize_Target_Horse_Leg",

	"Customize_Target_BuddyWalker",
	"Customize_Target_DW_Body",
	"Customize_Target_DW_Manipulator",
	"Customize_Target_DW_MainWeapon",
	"Customize_Target_DW_SubWeapon",
	"Customize_Target_DW_Head",
	"Customize_Target_DW_Color",

	"Customize_Target_Heli_Body",
	"Customize_Target_Heli_Main",
	"Customize_Target_Heli_OpFlare",
	"Customize_Target_Heli_OpArmor",
	"Customize_Target_Heli_Color",
	"Customize_Target_Helicopter",
	"Customize_Target_Vehicle",
}--focusTargetNames
local focusTargetS32ToString={}
for i,name in ipairs(focusTargetNames)do
  focusTargetS32ToString[StrCode32(name)]=name
end--for focusTargetNames

--heli_common_sequence>
--linkKey: EntityLink key in PreparationStageIdentifier (flor_common_asset.fox2 in vanilla helispaces), will set aroundCam target with locators position
--aroundCam: SetAroundCameraManualModeParams, target and ignoreCollisionGameObjectId will be overridded by UpdateCameraParameter
--aroundCam target=Vector3(x,y,z) will override linkKeys locator position
--aroundCam ignoreObjectType: GameObject name (ex: "TppWalkerGear2") for SetAroundCameraManualModeParams ignoreCollisionGameObjectId
local SelectCameraParameter={--tex heli_common_sequence defaults
  MissionPrep_FocusTarget_Weapon={
    linkKey="WeaponPosition",
    aroundCam={distance=1.5,focusDistance=1.5,aperture=1.6},
    rotation={rotX=-10,rotY=170,interpTime=0.3}},
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

  MissionPrep_FocusTarget_Player={linkKey="PlayerPosition_Up",aroundCam={distance=3.3},rotation={rotX=-5,rotY=170,interpTime=0.3}},

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

--CALLER: heli_common_sequence MissionPrep and Customize menus
--focusTargetS32: is strcode because it gets sent by exe msg
--TODO: would need to build a lookup if I wanted to dehash SelectCameraParameter table keys
function this.UpdateCameraParameter(focusTargetS32,immediately)
  local focusTarget=focusTargetS32ToString[focusTargetS32]
  if focusTarget==nil then
    local lookup=tostring(InfLookup.StrCode32ToString(focusTargetS32))
    InfCore.Log("WARNING: InfHeliSpace.UpdateCameraParameter: unknown focusTarget: "..focusTargetS32.." Lookup: "..lookup,false,true)
    return
  end
  InfCore.Log("InfHeliSpace.UpdateCameraParameter: focusTarget: "..focusTarget)

  local missionInfo=InfMission.missionInfo[vars.missionCode]
  if missionInfo and missionInfo.SelectCameraParameter then
    SelectCameraParameter=missionInfo.SelectCameraParameter
    if type(SelectCameraParameter)=="function"then
      InfCore.Log("Calling missionInfo.SelectCameraParameter")
      if SelectCameraParameter(focusTarget,immediately) then
        return
      end
    else
      local cameraParameter=SelectCameraParameter[focusTarget]
      if cameraParameter then
        InfCore.Log("Found missionInfo.SelectCameraParameter")
        this.UpdateSelectedCameraParameter(cameraParameter,focusTarget,immediately)
        return
      end
    end
  end--SelectCameraParameter

  local locationInfo=InfMission.locationInfo[vars.locationCode]
  if locationInfo and locationInfo.SelectCameraParameter then
    SelectCameraParameter=locationInfo.SelectCameraParameter
    if type(SelectCameraParameter)=="function"then
      InfCore.Log("Calling locationInfo.SelectCameraParameter")
      if SelectCameraParameter(focusTarget,immediately) then
        return
      end
    else
      local cameraParameter=SelectCameraParameter[focusTarget]
      if cameraParameter then
        InfCore.Log("Found locationInfo.SelectCameraParameter")
        this.UpdateSelectedCameraParameter(cameraParameter,focusTarget,immediately)
        return
      end
    end
  end--SelectCameraParameter

  local cameraParameter=SelectCameraParameter[focusTarget]
	if not cameraParameter then
		InfCore.Log("ERROR: InfHeliSpace.UpdateCameraParameter: Invalid focus target. focusTarget = " .. tostring(focusTargetS32) )
		return
	end
  this.UpdateSelectedCameraParameter(cameraParameter,focusTarget,immediately)
end--UpdateCameraParameter

--tex reworked heli_common_sequence UpdateCameraParameter
function this.UpdateSelectedCameraParameter(cameraParameter,focusTarget,immediately)
  -- local focusTarget=focusTargetS32ToString[focusTargetS32]
  -- if focusTarget==nil then
  --   local lookup=tostring(InfLookup.StrCode32ToString(focusTargetS32))
  --   InfCore.Log("WARNING: InfHeliSpace.UpdateCameraParameter: unknown focusTarget: "..focusTargetS32.." Lookup: "..lookup,false,true)
  --   return
  -- end

	-- local cameraParameter=SelectCameraParameter[focusTarget]
	-- if not cameraParameter then
	-- 	Fox.Error("Invalid focus target. focusTarget = " .. tostring(focusTargetS32) )
	-- 	return
	-- end

  local targetPosVector3
  if cameraParameter.linkKey then
    InfCore.Log("InfHeliSpace.UpdateSelectedCameraParameter: linkKey: "..tostring(cameraParameter.linkKey))
    targetPosVector3=Tpp.GetLocatorByTransform("PreparationStageIdentifier",cameraParameter.linkKey)
  end
	  
  local aroundCamParams={
    --distance = distance,		
    target = targetPosVector3,
    focusDistance = 8.175,
    targetInterpTime=0.3,
    --ignoreCollisionGameObjectId = ignoreGameId,
    interpImmediately = immediately,
  }

	if focusTarget=="MissionPrep_FocusTarget_Weapon" then
		Player.SetPadMask {
      settingName = "WeaponCamera",
      except = true,
      sticks = PlayerPad.STICK_L,
		}

    aroundCamParams.targetIsPlayer=false--tex TODO: decide which has priority, vanilla behavior or table/addon setting, currently addon has prio see -v-
	elseif TppSequence.GetCurrentSequenceName()=="Seq_Game_WeaponCustomize" then
    aroundCamParams.aperture=100
	end

  InfUtil.MergeTable(aroundCamParams,cameraParameter.aroundCam)

	local ignoreGameId
	if aroundCamParams.ignoreObjectType then
    ignoreGameId=GameObject.CreateGameObjectId(aroundCamParams.ignoreObjectType,0)
    if ignoreGameId==GameObject.NULL_ID then
      InfCore.Log("WARNING: InfHeliSpace.UpdateCameraParameter: could not find gameObjectId for "..tostring(aroundCamParams.ignoreObjectType),true,true)
    else
      aroundCamParams.ignoreCollisionGameObjectId=ignoreGameId
    end
  end

  --tex TODO: decide which has priority, flag or table/addon setting, is this even nessesary when interpImmediately true?
  if immediately then aroundCamParams.targetInterpTime=0.0 end

  Player.SetAroundCameraManualModeParams(aroundCamParams)
	Player.UpdateAroundCameraManualModeParams()
	Player.RequestToSetCameraRotation(cameraParameter.rotation)
end--UpdateSelectedCameraParameter

--heli_common_sequence<

--Ivars>
this.helispace_loadOnSelectLandPoint={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  settings={"OFF","ADDON","ALL"}
}

this.helispaceMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu"},
  options={
    "Ivars.helispace_loadOnSelectLandPoint",
  }
}

this.registerIvars={
  "helispace_loadOnSelectLandPoint"
}

this.registerMenus={
  "helispaceMenu"
}
--Ivars<

return this