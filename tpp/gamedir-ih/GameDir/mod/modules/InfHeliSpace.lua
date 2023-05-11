--InfHeliSpace.lua
--implements heli_common_sequence stuff and heliSpace addon specific stuff
--the majority of heli space addons is handled by InfMission addon system

--tex loading addon heliSpaces on missionPrep:
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

local StrCode32=InfCore.StrCode32

local this={}

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
--linkKey: EntityLink key in PreparationStageIdentifier (flor_common_asset.fox2 in vanilla heliSpaces), will set aroundCam target with locators position
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

--heliSpaceFlags >
-- heliSpaceFlags are mvars set in vanilla in heli_common_sequence.OnRestoreSVars
-- but can also be overidden by missionInfo (if missioninfo is for vanilla, or used to set the addon mission settings obviously) 
-- see this.OnRestoreSVars
-- or overridden by ivars (of same name)
-- see this.SetHeliSpaceFlagsFromIvars

this.heliSpaceFlagNames={
  "SkipMissionPreparetion",
  "NoBuddyMenuFromMissionPreparetion",
  "NoVehicleMenuFromMissionPreparetion",
  "DisableSelectSortieTimeFromMissionPreparetion",
}

function this.OnRestoreSvars()
  --tex aka SetHeliSpaceFlagsFromMissionInfos
  --sortie mvars per mission - see heli_common_sequence OnRestoreSvars, which is called before this 
  --not really nessesary since GetHeliSpaceFlag now looks them up
  for missionCode,missionInfo in pairs(InfMission.missionInfo)do
    if missionInfo.heliSpaceFlags then--tex alway a question when choosing a name whether to make it friendly for user (sortiePrepFlags or somthin), or to use naming from existing code, missionInfo in general uses code derived naming
      this.SetHeliSpaceFlags(missionInfo.heliSpaceFlags,missionCode)
    end--if heliSpaceFlags
  end--for missionInfo
end

--CALLER: heli_common_sequence.OnEndFadeOutSelectLandingPoint
--IN: this.heliSpaceNameFlags
--OUT: mvars.heliSpace_<flagName>
function this.SetHeliSpaceFlagsFromIvars(nextMissionCode)
  local heliSpaceFlags={}
  for i,flagName in ipairs(this.heliSpaceFlagNames)do
    heliSpaceFlags[flagName]=this.GetHeliSpaceFlag(flagName,nextMissionCode)
  end
  if next(heliSpaceFlags)then
    if this.debugModule then
      InfCore.PrintInspect(heliSpaceFlags,"heliSpaceFlags for "..tostring(nextMissionCode))--DEBUG
    end
    this.SetHeliSpaceFlags(heliSpaceFlags,nextMissionCode)
  end
end--SetHeliSpaceFlagsFromIvars

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
this.heliSpace_loadOnSelectLandPoint={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  settings={"OFF","ADDON","ALL"}
}

this.heliSpaceMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu"},
  options={
    "Ivars.heliSpace_loadOnSelectLandPoint",
  }
}

this.registerIvars={
  "heliSpace_loadOnSelectLandPoint"
}

this.registerMenus={
  "heliSpaceMenu"
}
--Ivars<

return this