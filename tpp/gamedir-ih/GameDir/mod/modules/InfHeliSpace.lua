--InfHeliSpace.lua
--implements heli_common_sequence stuff and heliSpace addon specific stuff
--the majority of heli space addons is handled by InfMission addon system since they are just a type of mission
--this module handles ih related helispace features
--see also heli_common_sequence

--tex loading addon heliSpaces on missionPrep:
--heliSpaceMenu > heliSpace_loadOnSelectLandPoint
--exec flow:
--this.OnSelectLandPoint
--heli_common_sequence.Seq_Game_MainGame_OnEnter 
--  > this.Seq_Game_MainGame_OnEnterPost 
--    > heli_common_sequence OnSelectLandingPoint

--loading addon heliSpace when base game normally loads heliSpace:
-- Helispace is chosen on functions calling TppMission/InfMission .GetCurrentLocationHeliMissionAndLocationCode
-- I converted a few more to use GetCurrentLocationHeliMissionAndLocationCode that werent previously
-- TODO: see if I've missed any, search 40010,TppDefine.SYS_MISSION_ID.AFGH_HELI

--Since helispace is also used for title, there needs to be recovery if missionCode set to an invalid helispace
--StartTitle currently uses GetCurrentLocationHeliMissionAndLocationCode (via SetVarsTitleHeliSpace), 
--so fallback I added to that should work
--TODO: actually test once have addon helispace 

--TODO: whats the details behind this warning?
-- heliSpace_NoVehicleMenuFromMissionPreparetion="WARNING: Selecting a vehicle if the mission does not have player vehicle support means there will be no vehicle recovered on mission exit (effecively losing the vehicle you attempted to deploy).",

local StrCode32=InfCore.StrCode32

local this={
  name="InfHeliSpace"
}

--CALLER: heli_common_sequence Seq_Game_MainGame	msg  Terminal.MbDvcActSelectLandPoint
--DEBUGNOW theres no other base game subscribers to MbDvcActSelectLandPoint, but authors could also subscribe, what's the exec flow?
--do we need onfadeoutdirect instead?
function this.OnSelectLandPoint(missionCode,heliRoute,layoutCode,clusterCategory)
  local argsString="Not logged"
  if InfCore.debugMode then
    argsString=table.concat({missionCode,heliRoute,layoutCode,clusterCategory},",")
  end
  InfCore.Log("InfHeliSpace.OnSelectLandPoint("..argsString..") currentMissionCode: "..vars.missionCode)
  --tex look for msg  Terminal.MbDvcActSelectLandPoint rather than logging this
	mvars.heliSequence_startFobSneaking=false
	mvars.heliSequence_nextMissionCode=missionCode
	mvars.heliSequence_heliRoute=heliRoute
	mvars.heliSequence_clusterCategory=clusterCategory

  local heliSpace,heliSpaceLocation,addonWantsHeliSpace=InfMission.GetHeliSpaceForMission(missionCode)
  --GOTCHA: heliSpace will default to 40010 - AFGH_HELI if no heliSpace (with missionInfo if not a vanilla) found for mission or location

  if ivars.heliSpace_loadOnSelectLandPoint==0 then
    if this.debugModule then InfCore.Log("ivars.heliSpace_loadOnSelectLandPoint==0") end
    heliSpace=nil
  elseif heliSpace and ivars.heliSpace_loadOnSelectLandPoint==Ivars.heliSpace_loadOnSelectLandPoint.enum.ADDON then
    --tex addon heliSpaces only, or if an addon has defined one
    if not InfMission.missionInfo[heliSpace] and not addonWantsHeliSpace then
      if this.debugModule then InfCore.Log("not InfMission.missionInfo[heliSpace] and not missionWantsHeliSpace") end
      heliSpace=nil
    end
  end

  local skipMissionPreparetion=this.GetHeliSpaceFlag("SkipMissionPreparetion",missionCode)
  if this.debugModule then
    InfCore.Log("heliSpace: "..tostring(heliSpace).." skipMissionPreparetion: "..tostring(skipMissionPreparetion))
  end

  if heliSpace and heliSpace~=vars.missionCode and not skipMissionPreparetion then
    InfCore.Log("InfHeliSpace.OnSelectLandPoint: Loading heliSpace "..heliSpace)
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
    vars.missionCode=heliSpace
    vars.locationCode=heliSpaceLocation
    TppMission.SafeStopSettingOnMissionReload()
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

--util TODO: think where this should be

--
function this.CallMissionInfoFunction(missionCode,missionInfoFuncKey,...)
  local missionInfo=InfMission.missionInfo[missionCode]
  if not missionInfo then
    return false
  end

  local Func=missionInfo[missionInfoFuncKey]
  if not Func then
    return false
  end

  if type(Func)~="function"then
    return false
  end

  InfCore.Log("Calling missionInfo."..missionInfoFuncKey)
  local success,result=pcall(Func,...)
  if not success then
    InfCore.Log("ERROR: InfHeliSpace.CallMissionInfoFunction missionInfo["..missionCode.."]."..missionInfoFuncKey,true,true)
    return false
  end

  return result
end--CallMissionInfoFunction

function this.GetMissionInfoTable(missionCode,missionInfoKey)
  local missionInfo=InfMission.missionInfo[missionCode]
  if not missionInfo then
    return nil
  end

  local missionInfoTable=missionInfo[missionInfoKey]
  if not missionInfoTable then
    return nil
  end

  if type(missionInfoTable)~="table"then
    InfCore.Log("WARNING: GetMissionInfoTable: "..missionCode.." missionInfo."..missionInfoKey.." is not a table")
    return nil
  end

  return missionInfo[missionInfoKey]
end--GetMissionInfoTable

function this.GetMissionInfoTableValue(missionCode,missionInfoKey,indexParam)
  local missionInfo=InfMission.missionInfo[missionCode]
  if not missionInfo then
    return nil
  end

  local missionInfoTable=missionInfo[missionInfoKey]
  if not missionInfoTable then
    return nil
  end

  if type(missionInfoTable)~="table"then
    InfCore.Log("WARNING: GetMissionInfoTable: "..missionCode.." missionInfo."..missionInfoKey.." is not a table")
    return nil
  end

  return missionInfo[missionInfoKey][indexParam]
end--GetMissionInfoTableValue

--heli_common_sequence overrides>

local titleModeCamParams={
  focalLength = 14.7,
  aperture = 1.05,
  focusDistance = 0.9,
  positionAndTargetMode = true,
  position = Vector3{ 0.213, 1198.166, 0.106},
  target = Vector3{ -0.222, 1198.16, -0.35},
}

--CALLER: title_sequence Seq_Demo_StartHasTitleMission OnEndShowSplashScreen,
--the Push to start phase of title
--calls helispace missionInfo.TitleModeOnEnter as a function
--or as a table passes it to RequestToPlayCameraNonAnimation
function this.TitleModeOnEnterFunction()
  local identity=this.name..".".."TitleModeOnEnterFunction"
  InfCore.Log(identity)
  --tex author wants to handle entire function
  local missionInfoKey="TitleModeOnEnter"
  local result=this.CallMissionInfoFunction(vars.missionCode,missionInfoKey)
  if result then
    InfCore.Log(identity..": missionInfo."..missionInfoKey.." handled")
    return
  end

  local camParams=this.GetMissionInfoTable(vars.missionCode,missionInfoKey)
  if not camParams then
    camParams=titleModeCamParams
  end

  this.TitleModeOnEnter(camParams)
end--TitleModeOnEnterFunction

function this.TitleModeOnEnter(camParams)
  TppEffectUtility.SetFxCutLevelMaximum(5)
  GrTools.SetSubSurfaceScatterFade(1.0)	
  SimDaemon.SetForceStopSimWindEffect(true) 

  Player.RequestToPlayCameraNonAnimation(camParams)
  TppClock.Stop()
end--SetTitleModeOnEnterCamera

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

--tex Used by a few camera setup functions in heli_common_sequence
--in the base game (a simplified version of) the table is only used for UpdateCameraParameter
--i've expanded it for more heli_common_sequence camera functions
--if this table does not exist in a missioninfo then it will use the vanilla table (see InfHeliSpace.SelectCameraParameter)
--<heli_common_sequence function name>--Defaults: the parameters that follow after it will merge over those values.
--linkKey: EntityLink key in PreparationStageIdentifier (flor_common_asset.fox2 in vanilla heliSpaces), will set aroundCam.target with locators position
--aroundCam table: is a SetAroundCameraManualModeParams table (search the game lua for other parameters it suppotts)
--aroundCam target=Vector3(x,y,z) will override linkKeys locator position
--aroundCam ignoreObjectType: GameObject name (ex: "TppWalkerGear2") will be used by function to set aroundCam.ignoreCollisionGameObjectId
--the SetCameraStageCenter* functions are a bit messy since they have a seperate setting if buddy horse is on the stage
this.SelectCameraParameter={--tex heli_common_sequence defaults
  --for SetCameraStageCenter function >
  --handles the default camera for mission prep, when not in any of the sub menus of mission prep   
  SetCameraStageCenter={--Defaults
    linkKey="StageCenter",
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
    aroundCam={distance=3.0,targetInterpTime=0.6,ignoreCollisionGameObjectName="Player"},
    rotation={rotX=-5,rotY=170,interpTime=0.6}
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
    aroundCam={distance=4.0,targetInterpTime=0.3,ignoreCollisionGameObjectName="Player"},
    rotation={rotX=-5,rotY=170,interpTime=0.3}
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
    aroundCam={distance=1.5,focusDistance=1.5,aperture=1.6,targetIsPlayer=false},
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

function this.GetCamParams(defaultParamsName,paramsName)
  local SelectCams=this.GetMissionInfoTable(vars.missionCode,"SelectCameraParameter")
  if not SelectCams then
    SelectCams=this.SelectCameraParameter
  end

  local selectParams=SelectCams[paramsName]
	if not selectParams then
		InfCore.Log("ERROR: GetCamParams: Invalid paramsName:"..paramsName)
		return
	end

  local camParams=InfUtil.CopyTable(SelectCams[defaultParamsName])
  if paramsName and paramsName~=defaultParamsName then
    InfUtil.MergeTable(camParams,selectParams)
  end

  return camParams
end--GetCamParams

function this.SetCameraStageCenterCommon(overrideFuncName,defaultParamsName,paramsName,immediately)
  --tex NMC this is what sets aroundcam on for mission prep, wheres UpdateCameraParameter (as the name suggests) just assumes its on because of this
	Player.SetAroundCameraManualMode(true)

  --tex if author wants to handle entire function
  local result=this.CallMissionInfoFunction(vars.missionCode,overrideFuncName,paramsName,immediately)
  if result then
    InfCore.Log("SetCameraStageCenterCommon: missionInfo."..overrideFuncName.." handled")
    return
  end

  local camParams=this.GetCamParams(defaultParamsName,paramsName)
	if not camParams then
		InfCore.Log("ERROR: GetCamParams: Invalid paramsName:"..paramsName)
		return
	end

  this.UpdateSelectedCameraParameter(camParams,paramsName,immediately)
end--SetCameraStageCenterCommon

--CALLERS: heli_common_sequence.SetCameraStageCenter <
--Seq_Game_MainGameToMissionPreparationTop OnEnter
--Seq_Game_MissionPreparationTop OnEnter
--Seq_Game_MissionPreparationTop MissionPreparationCamera --!!?? caller?
--msg MissionPrep_EndSortieTimeSelect
--msg MissionPrep_EndItemSelect
--msg MissionPrep_ExitWeaponChangeMenu
--Seq_Game_MissionPreparation_SelectItem OnEnter
function this.SetCameraStageCenter(interpTime)
  local identity="InfHeliSpace.SetCameraStageCenter"
	InfCore.Log(identity)

  --tex SetCameraStageCenter is only called with interpTime in once case, where it is set to 0
  --so just making this the equivalent of UpdateCameraParameter s immediately paramter
  local immediately=interpTime==0

  local overrideFuncName="SetCameraStageCenter"--missionInfo key

  local defaultParamsName="SetCameraStageCenter"--SelectCameraParameter key
  local paramsName=defaultParamsName

  if (vars.buddyType==BuddyType.HORSE) then
    paramsName=paramsName.."_Horse"
  end

  this.SetCameraStageCenterCommon(overrideFuncName,defaultParamsName,paramsName,immediately)
end--SetCameraStageCenter

--msg = "MissionPrep_StartSortieTimeSelect",
function this.SetCameraStageCenter_Go()
  local immediately=false

  local overrideFuncName="SetCameraStageCenter_Go"--missionInfo key

  local defaultParamsName="SetCameraStageCenter_Go"--SelectCameraParameter key
  local paramsName=defaultParamsName

  if (vars.buddyType==BuddyType.HORSE) then
    paramsName=paramsName.."_Horse"
  end

  this.SetCameraStageCenterCommon(overrideFuncName,defaultParamsName,paramsName,immediately)
end--SetCameraStageCenter_Go
--OnMissionPreparetionEnd
function this.SetCameraStageCenter_GoOut()
  local immediately=false

  local overrideFuncName="SetCameraStageCenter_GoOut"--missionInfo key

  local defaultParamsName="SetCameraStageCenter_GoOut"--SelectCameraParameter key
  local paramsName=defaultParamsName

  if (vars.buddyType==BuddyType.HORSE) then
    paramsName=paramsName.."_Horse"
  end

  this.SetCameraStageCenterCommon(overrideFuncName,defaultParamsName,paramsName,immediately)
end--SetCameraStageCenter_GoOut


--Various camera settings for MissionPrep and Customize menus
--Calls missionInfo.SelectCameraFunction(focusTarget,immediately), 
--SelectCameraFunction function should return true if it handled the focusTarget 
--See UpdateSelectedCameraParameter, or heli_common_sequence.UpdateCameraParameter for example of function
--else it passes missionInfo.SelectCameraParameter[focusTarget] (see above for example) to UpdateSelectedCameraParameter
--focusTargetS32: is strcode because it gets sent by exe msgs (UI.MissionPrep_ChangeEditTarget, UI.MissionPrep_StartItemSelect etc)
function this.UpdateCameraParameter(focusTargetS32,immediately)
  local identity="InfHeliSpace.UpdateCameraParameter"
  InfCore.Log(identity)

  local paramsName=focusTargetS32ToString[focusTargetS32]
  
  local overrideFuncName="UpdateCameraParameter"--missionInfo key
  local defaultParamsName="UpdateCameraParameter"--SelectCameraParameter key

  --tex if author wants to handle entire function
  local result=this.CallMissionInfoFunction(vars.missionCode,overrideFuncName,paramsName,immediately)
  if result then
    InfCore.Log(identity..": missionInfo."..overrideFuncName.." handled")
    return
  end

  local camParams=this.GetCamParams(defaultParamsName,paramsName)
	if not camParams then
		InfCore.Log("ERROR: GetCamParams: Invalid paramsName:"..paramsName)
		return
	end

  --tex custom cases from UpdateCameraParameter> TODO: maybe tack on padmask to params?
	if paramsName=="MissionPrep_FocusTarget_Weapon" then
		Player.SetPadMask {
      settingName = "WeaponCamera",
      except = true,
      sticks = PlayerPad.STICK_L,
		}
	elseif TppSequence.GetCurrentSequenceName()=="Seq_Game_WeaponCustomize" then
    camParams.aroundCam.aperture=100
	end

  this.UpdateSelectedCameraParameter(camParams,paramsName,immediately)
end--UpdateCameraParameter

--tex reworked heli_common_sequence UpdateCameraParameter
function this.UpdateSelectedCameraParameter(camParams,focusTarget,immediately)
  local aroundCam=camParams.aroundCam

  if immediately then 
    aroundCam.interpImmediately=true
    aroundCam.targetInterpTime=0.0--is this even nessesary when interpImmediately true?
    camParams.rotation.interpTime=0.0--tex not done in UpdateCameraParameter, but is for SetCameraStageCenter interpTime 
  end

  --tex to override this with a set value instead of this you'd have to set linkKey=nil,aroundCam={target=Vector3(x,y,z)
  local targetPosVector3
  if camParams.aroundCam.target==nil and camParams.linkKey then
    InfCore.Log("InfHeliSpace.SetCameraStageCenter: linkKey: "..tostring(camParams.linkKey))
    targetPosVector3=Tpp.GetLocatorByTransform("PreparationStageIdentifier",camParams.linkKey)
    camParams.aroundCam.target=targetPosVector3
  end

	local ignoreGameId
	if aroundCam.ignoreObjectType then
    ignoreGameId=GameObject.CreateGameObjectId(aroundCam.ignoreObjectType,0)
    if ignoreGameId==GameObject.NULL_ID then
      InfCore.Log("WARNING: InfHeliSpace.UpdateCameraParameter: could not find gameObjectId for "..tostring(aroundCamParams.ignoreObjectType),true,true)
    else
      aroundCam.ignoreCollisionGameObjectId=ignoreGameId
    end
  end

  Player.SetAroundCameraManualModeParams(camParams.aroundCam)
	Player.UpdateAroundCameraManualModeParams()
	Player.RequestToSetCameraRotation(camParams.rotation)
end--UpdateSelectedCameraParameter

--heli_common_sequence<

--heliSpaceFlags >
-- heliSpaceFlags are mvars set in vanilla in heli_common_sequence.OnRestoreSVars
-- but can also be overidden by missionInfo (if missioninfo is for vanilla, or used to set the addon mission settings obviously) 
-- or overridden by ivars (of same name)
-- see this.GetHeliSpaceFlag (and uses thereof)

this.heliSpaceFlagNames={
  "SkipMissionPreparetion",
  "NoBuddyMenuFromMissionPreparetion",--GOTCHA: ivar also used for TppBuddyService.SetDisableAllBuddy in TppMain DEBUGNOW rethink
  "NoVehicleMenuFromMissionPreparetion",
  "DisableSelectSortieTimeFromMissionPreparetion",
}

--CALLER: heli_common_sequence.OnEndFadeOutSelectLandingPoint
--IN: this.heliSpaceNameFlags
--OUT: mvars.heliSpace_<flagName>
function this.UpdateHeliSpaceFlags(missionCode)
  local heliSpaceFlags={}
  for i,flagName in ipairs(this.heliSpaceFlagNames)do
    heliSpaceFlags[flagName]=this.GetHeliSpaceFlag(flagName,missionCode)
  end
  if next(heliSpaceFlags)then
    if this.debugModule then
      InfCore.PrintInspect(heliSpaceFlags,"heliSpaceFlags for "..tostring(missionCode))--DEBUG
    end
    this.SetHeliSpaceFlags(heliSpaceFlags,missionCode)
  end
end--UpdateHeliSpaceFlags

--REF this.heliSpaceFlagNames
--tex see heli_common_sequence OnRestoreSVars
function this.SetHeliSpaceFlags(heliSpaceFlags,missionCode)
  for flagName,set in pairs(heliSpaceFlags) do
    local mvarName="heliSpace_"..flagName
    if mvars[mvarName]then
      mvars[mvarName][missionCode]=set
    end
  end
end--SetHeliSpaceFlags

--SYNC: heli_common_sequence .OnRestoreSVars
local heliFlagDefaults={
  SkipMissionPreparetion={
    [10010]=true,
    [10020]=false,--ORIG: [10020]=(not TppStory.IsMissionCleard(10020)),--tex cant use TppStory while module is loaded, see GetHeliSpaceFlag for workaround
    [10030]=true,
    [10240]=true,
    [10280]=true,
    [11043]=true,
    [11044]=true,
    [30050]=true,
    [30150]=true,
    [30250]=true,
  },
  NoBuddyMenuFromMissionPreparetion={
    [10020]=true,
    [10115]=true,
    [30050]=true,
    [30250]=true,
    [50050]=true
  },
  NoVehicleMenuFromMissionPreparetion={
    [10115]=true,
    [30050]=true,
    [30150]=true,
    [30250]=true,
    [50050]=true
  },
  DisableSelectSortieTimeFromMissionPreparetion={
    [10020]=true,
    [10080]=true,
  },
}--heliFlagDefaults

--tex get heliSpaceFlag from ivar, or missionInfo, or default
function this.GetHeliSpaceFlag(flagName,missionCode)
  local varName="heliSpace_"..flagName

  --ivar
  if IvarProc.EnabledForMission(varName,missionCode) then
    local setting=IvarProc.GetForMission(varName,missionCode)
    --tex REF ivar settings "DEFAULT","FALSE","TRUE" == 0,1,2
    if setting~=0 then
      return setting==2--TRUE
    end
  end
  
  --missionInfo
  local missionInfo=InfMission.missionInfo[missionCode]
  if missionInfo then
    if missionInfo.heliSpaceFlags and missionInfo.heliSpaceFlags[flagName]~=nil then
      return missionInfo.heliSpaceFlags[flagName]
    end--if heliSpaceFlags
  end

  --DEFAULT (from heli_common_sequence.OnRestoreSvars)
  local flag=heliFlagDefaults[flagName][missionCode]
    --tex WORKAROUND cant use TppStory while module is loaded so heliFlagDefaults will be wrong
    if missionCode==10020 and flagName=="SkipMissionPreparetion" then
      flag=not TppStory.IsMissionCleard(10020)
  end
  return flag
end--GetHeliSpaceFlag
--heliSpaceFlags<

--Ivars>
this.heliSpace_loadOnSelectLandPoint={--TODO lang string
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  settings={"OFF","ADDON","ALL"}
}

this.heliSpaceMenu={--"Mission-prep features menu"
  parentRefs={"InfMenuDefs.safeSpaceMenu"},--tex TODO heliSpaceFlagsMenu also had InfMainTppIvars.playerRestrictionsMenu
  options={
    "Ivars.heliSpace_loadOnSelectLandPoint",
  }
}

this.registerIvars={
  "heliSpace_loadOnSelectLandPoint"
}

this.registerMenus={
  "heliSpaceMenu",
}

--heliSpaceFlag ivars>
local heliSpaceIvarPrefix="heliSpace_"
local heliSpaceIvarNames={}
local missionModes={"FREE","MISSION","MB_ALL",}
for i,flagName in ipairs(this.heliSpaceFlagNames)do
  local ivarName=heliSpaceIvarPrefix..flagName
  for i,missionMode in ipairs(missionModes)do
    heliSpaceIvarNames[#heliSpaceIvarNames+1]="Ivars."..ivarName..missionMode
  end

  IvarProc.MissionModeIvars(
    this,
    ivarName,
    {save=IvarProc.CATEGORY_EXTERNAL,
      settings={"DEFAULT","FALSE","TRUE"},
      flagName=flagName,
    },
    missionModes
  )--MissionModeIvars
end--for heliSpaceFlagNames

--tex add to menu
for i,ivarName in ipairs(heliSpaceIvarNames)do
  table.insert(this.heliSpaceMenu.options,ivarName)
end
--InfCore.PrintInspect(heliSpaceIvarNames,"heliSpaceIvarNames")--DEBUG
--heliSpaceFlag ivars<

this.langStrings={
  eng={
    heliSpaceMenu="Mission-prep features menu",
    heliSpace_SkipMissionPreparetion="Skip mission prep",
    heliSpace_NoBuddyMenuFromMissionPreparetion="Disable select-buddy",
    heliSpace_NoVehicleMenuFromMissionPreparetion="Disable select-vehicle",
    heliSpace_DisableSelectSortieTimeFromMissionPreparetion="Disable select-sortie time",
  },--eng
  help={
    eng={
      heliSpaceMenu="Only affects the mission-prep screen, not the in-mission equivalents.", 
      heliSpace_SkipMissionPreparetion="Go straight to mission, skipping the mission prep screen.",
      heliSpace_NoBuddyMenuFromMissionPreparetion="Prevents selection of buddies during mission prep.",
      heliSpace_NoVehicleMenuFromMissionPreparetion="WARNING: Selecting a vehicle if the mission does not have player vehicle support means there will be no vehicle recovered on mission exit (effecively losing the vehicle you attempted to deploy).",
      heliSpace_DisableSelectSortieTimeFromMissionPreparetion="Only allows ASAP at mission prep",
    },--eng
  }--help
}--langStrings

--KLUDGE: DEBUGNOW: have get ivars name/help function do this append mission mode string instead
function this.PostAllModulesLoad()
  --REF InfLang   missionModes={
  --   FREE="Free Roam",
  --   MISSION="Story Mission",
  --   MB="MB",
  --   MB_ALL="MB",
  -- },
  local missionModeStrings=InfLangProc.LangString("missionModes")
  for i,flagName in ipairs(this.heliSpaceFlagNames)do
    local ivarName=heliSpaceIvarPrefix..flagName
    for i,missionMode in ipairs(missionModes)do
      local ivarNameFull=ivarName..missionMode
      InfLang.eng[ivarNameFull]=InfLang.eng[ivarName].." for "..missionModeStrings[missionMode]
      InfLang.help.eng[ivarNameFull]=InfLang.help.eng[ivarName]
    end
  end
end

--Ivars<

return this