-- DOBUILD: 1
-- ORIGINALQAR: chunk1
-- PACKPATH: \Assets\tpp\pack\mission2\heli\heli_common_script.fpkd
local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local TimerStart = GkEventTimerManager.Start
local IsSavingOrLoading = TppScriptVars.IsSavingOrLoading

if TppPackList.IsMissionPackLabel("PS3Store") then
	this.SKIP_TEXTURE_LOADING_WAIT = true
	this.NO_LOAD_UI_DEFAULT_BLOCK = true
end

local HELI_SPACE_REFLECTION_PATH = "/Assets/tpp/common_source/cubemap/environ/heliSpace/cm_heli_cb_indoor001/sourceimages/cm_heli_cb_indoor001.ftex"
local SORTIE_REFLECTION_PATH = "/Assets/tpp/common_source/cubemap/environ/sortie_space/cm_sortie_cb_001/sourceimages/cm_sortie_cb_001.ftex"

local SetReflectionTexture = WeatherManager.SetReflectionTexture or function() end

local sequences = {}

this.DEBUG_strCode32List = {
	"MissionPrep_Start",
	"MissionPrep_Abort",
	"MissionPrep_End",
	"MissionPrep_StartEdit",
	"MissionPrep_ChangeEditTarget",
	"MissionPrep_EndEdit",
	"MissionPrep_StartSlotSelect",
	"MissionPrep_ChangeSlot",
	"MissionPrep_EndSlotSelect",
	"MissionPrep_StartItemSelect",
	"MissionPrep_ChangeItem",
	"MissionPrep_EndItemSelect",
	"MissionPrep_StartModelView",
	"MissionPrep_EndtModelView",
	"MissionPrep_FocusTarget_Weapon",
	"MissionPrep_FocusTarget_PrimaryWeapon",
	"MissionPrep_FocusTarget_SecondaryWeapon",
	"MissionPrep_FocusTarget_SupportWeapon",
	"MissionPrep_FocusTarget_Item",
	"MissionPrep_FocusTarget_Suit",
	"MissionPrep_FocusTarget_Player",
	"MissionPrep_FocusTarget_Buddy",
	"MissionPrep_FocusTarget_Vehicle",
	"MissionPrep_FocusTarget_None",
	"MbDvcActSelectAvatarMenu",
}

this.EQUIP_MISSION_BLOCK_GROUP_SIZE = 0

this.MAX_PICKABLE_LOCATOR_COUNT = 1
this.MAX_PLACED_LOCATOR_COUNT = 1

this.ALWAYS_APPLY_TEMPORATY_PLAYER_PARTS_SETTING = true	

local PANDEMIC_TUTORIAL_DISPLAY = {
	ALL_DISABLED = 0,
	STAFF_ENABLED = 1,
	ALL_ENABLED = 2,
}

this.saveVarsList = {
	showInfoTypingText = false,
}

function this.OnLoad()
	Fox.Log("#### OnLoad ####")     

	local sequenceList = {
		"Seq_Demo_StartHasTitleMission",	
		"Seq_Game_PushStart",				
		"Seq_Game_TitleMenu",
		"Seq_Game_ChunkLoading",
		"Seq_Game_ChunkCanceled",
		"Seq_Game_ChunkInstalled",
		
		"Seq_Game_MainGame",
		
		"Seq_Game_MainGameToMissionPreparationTop",
		"Seq_Game_MissionPreparationTop",
		"Seq_Game_MissionPreparation_SelectItem",
		"Seq_Game_MissionPreparation_SelectSlot",
		"Seq_Game_MissionPreparation_SelectDetail",
		"Seq_Game_MissionPreparationAbort",
		"Seq_Game_MissionPreparationEnd",
		"Seq_Game_WeaponCustomize",
		"Seq_Game_WeaponCustomizeAbort",
		"Seq_Game_WeaponCustomizeEnd",
		"Seq_Demo_LoadAvatarEdit",
		"Seq_Demo_WaitReadyAvatarEdit",
		"Seq_Game_AvatarEdit",
		"Seq_Game_AvatarEditEnd",
		
		"Seq_Game_PandemicTutorial",
		
		"Seq_Game_TutorialIntroductionFobConstruct",
		"Seq_Game_TutorialFobConstruct",
		
		
		
		"Seq_Demo_PS3Store",
		
		"Seq_Demo_CheckDlc",
		"Seq_Demo_ShowDlcError",
		"Seq_Demo_ShowDlcAnnouncePopup",
		"Seq_Demo_WaitSavingPersonalData",
		nil
	}
	
	TppSequence.RegisterSequences(sequenceList)
	
	sequences = title_sequence.AddTitleSequenceTable(sequences)
	TppSequence.RegisterSequenceTable(sequences)
end

function this.OverrideFadeInGameStatus()
	local except = Tpp.GetAllDisableGameStatusTable()
	if not gvars.ini_isTitleMode then
		if TppPackList.IsMissionPackLabel("avatarEdit") then
			except["PauseMenu"] = nil
		else
			except["PauseMenu"] = nil
			except["AnnounceLog"] = nil
			except["InfoTypingText"] = nil
			except["ActionIcon"] = nil
			except["S_DISABLE_PLAYER_PAD"] = nil
			except["S_DISABLE_NPC"] = nil
			except["S_DISABLE_TARGET"] = nil
		end
	end
	TppUI.OverrideFadeInGameStatus( except )
end

function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***ooo")

	this.OverrideFadeInGameStatus()

	
	
		
		
		
	
	
	local systemCallbackTable ={
		OnEstablishMissionClear = function()
			Tpp.SetGameStatus{
				target = TppDefine.GAME_STATUS_TYPE_ALL,
				enable = true,
				scriptName = "heli_common_sequence.lua",
			}
			TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "OnEstablishMissionClearFadeOut", nil, { setMute = true } )
		end,
		OnGameOver = function()
		end,
		nil
	}
	
	TppMission.RegiserMissionSystemCallback(systemCallbackTable)
	
	if TppPackList.IsMissionPackLabel("default") then
		title_sequence.MissionPrepare()
		title_sequence.RegisterMissionGameSequenceName( "Seq_Game_MainGame" )
		title_sequence.RegisterGameStatusFunction( this.EnableGameStatusFunction, this.DisableGameStatusFunction )
		title_sequence.RegisterTitleModeOnEnterFunction( this.TitleModeOnEnterFunction )
		
		local maxReceiverBlockSize	= 272 * 1024--RETAILPATCH: 1070	 added bigger recieverblocksize for non lastgen
		local maxSightBlockSize   = 105 * 1024--RETAILPATCH 1.0.13
		local platform = Fox.GetPlatformName()
		if not ( ( platform == "Xbox360" ) or ( platform == "PS3" ) ) then
			maxReceiverBlockSize	= 330 * 1024	--RETAILPATCH 1.0.13 incresed
			maxSightBlockSize    = 106 * 1024--RETAILPATCH 1.0.13
		end--<
		TppEquip.CreateEquipPreviewSystem{
			maxReceiverBlockSize	= maxReceiverBlockSize,	
			maxBarrelBlockSize		= 70 * 1024,	
			maxAmmoBlockSize		= 80 * 1024,	
			maxStockBlockSize		= 36 * 1024,	
			maxMuzzleBlockSize		= 75 * 1024,	
			maxSightBlockSize		= maxSightBlockSize,
			maxOptionBlockSize		= 25 * 1024,	
			maxUnderBlockSize		= 90 * 1024,	
			equipListUpCount		= 5,			
			partsListUpCount		= 5,			
		}
	end
	
	if TppPackList.IsMissionPackLabel("avatarEdit") then
		mvars.avatarEditStart = false
		
		TppPlayer.RegisterTemporaryPlayerType{
			playerType = PlayerType.SNAKE,
			partsType = PlayerPartsType.AVATAR_EDIT_MAN,
			camoType = PlayerCamoType.AVATAR_EDIT_MAN
		}
	else
		
		Player.SetDoesAvatarResourceBorrow( true )
	end
	
	if TppPackList.IsMissionPackLabel("PS3Store") then
		TppMission.AlwaysMissionCanStart()
		Shop.AllocatePSStoreMemory()
	end
	
	
	if Player.AddHeliSpaceZoomCameraInfo ~= nil then
		Player.AddHeliSpaceZoomCameraInfo {
			position = Vector3(0.36, 1198.37, -0.63),
			target = Vector3(-0.25, 1198.8, -0.05),
			focalLength = 14.0,
			interpTime = 0.4,
			minFrame = 779,
			maxFrame = 864,
		}
		Player.AddHeliSpaceZoomCameraInfo {
			position = Vector3(0.98,1198.25,-0.55),
			target = Vector3(-1,1198.23,-0.453),
			focalLength = 38.0,
			interpTime = 0.4,
			minFrame = 671,
			maxFrame = 756,
		}
	end
	
	TppTerminal.StopChangeDayTerminalAnnounce()
	
	
	this.AddHeliSpaceDebugMenu()
	
	
	if not gvars.usingNormalMissionSlot then
		TppException.SuspendFobExceptionHandling()
	end
end

function this.AddHeliSpaceDebugMenu()
	if DEBUG then
		mvars.debug.heliSpace_showQuiet = false
		DEBUG.AddDebugMenu("HeliSpace", "showQuiet", "bool", mvars.debug, "heliSpace_showQuiet")
		mvars.debug.heliSpace_showDDog = false
		DEBUG.AddDebugMenu("HeliSpace", "showDDog", "bool", mvars.debug, "heliSpace_showDDog")
		mvars.debug.heliSpace_setForceShowPhoto = false
		DEBUG.AddDebugMenu("HeliSpace", "setForceShowPhoto", "bool", mvars.debug, "heliSpace_setForceShowPhoto")
		mvars.debug.heliSpace_showPhotoIndex = 1
		DEBUG.AddDebugMenu("HeliSpace", "showPhotoIndex", "int32", mvars.debug, "heliSpace_showPhotoIndex")
		mvars.debug.heliSpace_clearForceShowPhoto = false
		DEBUG.AddDebugMenu("HeliSpace", "clearForceShowPhoto", "bool", mvars.debug, "heliSpace_clearForceShowPhoto")
	end
end

function this.OnEndMissionPrepareSequence()
	Fox.Log("heli_common_sequence.OnEndMissionPrepareSequence")
	WeatherManager.RequestTag("heli_space", 0 )
	SetReflectionTexture( HELI_SPACE_REFLECTION_PATH )
end

function this.EnableGameStatusFunction()
	Tpp.SetGameStatus{
		target = "all",
		enable = true,
		scriptName = "heli_common_sequence.lua",
	}
end

function this.DisableGameStatusFunction()
	Tpp.SetGameStatus{
		target = "all",
		enable = false,
		scriptName = "heli_common_sequence.lua",
	}
end

function this.DisableGameStatusOnHelispace()
	Fox.Log("heli_common_sequnece.DisableGameStatusOnHelispace")
	Tpp.SetGameStatus{
		target = "all",
		enable = false,
		except = {
			S_DISABLE_PLAYER_PAD = false,
			S_DISABLE_NPC = false,
			PauseMenu = false,
			AnnounceLog = false,
			InfoTypingText = false,
			ActionIcon = false,
		},
		scriptName = "heli_common_sequence.lua",
	}
	TppGameStatus.Reset("heli_common_sequence.lua", "S_DISABLE_PLAYER_PAD")
	TppGameStatus.Reset("heli_common_sequence.lua", "S_DISABLE_NPC")
	TppGameStatus.Reset("heli_common_sequence.lua", "S_DISABLE_TARGET")

	local CLEAR_UI_STATUS_LIST = {
		"PauseMenu",
		"AnnounceLog",
		"InfoTypingText",
		"ActionIcon",
	}
	
	for i, uiName in ipairs(CLEAR_UI_STATUS_LIST) do
		TppUiStatusManager.ClearStatus( uiName )
	end

end

function this.TitleModeOnEnterFunction()
	TppEffectUtility.SetFxCutLevelMaximum(5)
	GrTools.SetSubSurfaceScatterFade(1.0)	
	SimDaemon.SetForceStopSimWindEffect(true) 
	Player.RequestToPlayCameraNonAnimation {
		focalLength = 14.7,
		aperture = 1.05,
		focusDistance = 0.9,
		positionAndTargetMode = true,
		position = Vector3{ 0.213, 1198.166, 0.106},
		target = Vector3{ -0.222, 1198.16, -0.35},
	}
	TppClock.Stop()
end

function this.GetExceptGameStatusOnSortieMenu()
	local exceptGameStatus = Tpp.GetAllDisableGameStatusTable()
	exceptGameStatus["S_DISABLE_PLAYER_PAD"] = true
	exceptGameStatus["PauseMenu"] = true
	return exceptGameStatus
end

function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	
	if TppPackList.IsMissionPackLabel("avatarEdit") then
		TppPlayer.SetInitialPosition( { 0, 1000, 0 }, 0 )	
	else
		TppDataUtility.InvisibleMeshFromIdentifier( "HeliModelIdentifier", "uth0_intr0_def_0000", "MESH_WINDOWLEFT" )
		TppDataUtility.InvisibleMeshFromIdentifier( "HeliModelIdentifier", "uth0_intr0_def_0000", "MESH_WINDOWRIGHT" )
	end

	
	
	
	
	TppBuddy2BlockController.Load()
	
	mvars.heliSpace_SkipMissionPreparetion = {
		[10010] = true,
		[10020] = ( not TppStory.IsMissionCleard( 10020 ) ),
		[10030] = true,
		[10240] = true,
		[10280] = true,
		[11043] = true,
		[11044] = true,
		[30050] = true,
		[30150] = true,
		[30250] = true,
	}
	
	mvars.heliSpace_NoBuddyMenuFromMissionPreparetion = {
		[10020] = true,
		[10115] = true,
		[30050] = true,
		[30250] = true,
		[50050] = true
	}
	
	mvars.heliSpace_NoVehicleMenuFromMissionPreparetion = {
		[10115] = true,
		[30050] = true,
		[30150] = true,
		[30250] = true,
		[50050] = true
	}
	
	mvars.heliSpace_DisableSelectSortieTimeFromMissionPreparetion = {
		[10020] = true,
		[10080] = true,
	}

	vars.playerCameraRotation[0] = 1.86207
	vars.playerCameraRotation[1] = -155.40381

	
	if vars.playerInjuryCount > 0 then
		Player.HeliUseBloodPack()
	end
end


function this.OnBuddyBlockLoad()
	Fox.Log("heli_common_sequence.OnBuddyBlockLoad()")
	this.SetBuddyHeliSpaceSetting()
	
	if not TppPackList.IsMissionPackLabel("avatarEdit") then
		
		heli_common_photo.OnBuddyBlockLoad()
	end
end

function this.SetBuddyHeliSpaceSetting()
	this.CommonBuddyHeliSpaceSetting( BuddyType.QUIET, "BuddyQuietLocator" )
	this.CommonBuddyHeliSpaceSetting( BuddyType.DOG, "BuddyDDogLocator" )
end

function this.CommonBuddyHeliSpaceSetting( buddyType, locatorName )
	if not TppBuddyService.CanSortieBuddyType(buddyType) then
		Fox.Log("Buddy can not sortie. buddyType = " .. tostring(buddyType) )
		return
	end

	local translation, rotQuat = Tpp.GetLocatorByTransform( "HelispaceLocatorIdentifier", locatorName )
	if translation then
		Fox.Log( string.format( "HeliSpaceSetting. locatorName = %s, pos = (%f, %f, %f)", locatorName, translation:GetX(), translation:GetY(), translation:GetZ() ) )
		TppBuddyService.HeliSpaceSetting( translation, rotQuat, buddyType )
	else
		Fox.Warning( "HeliSpaceSetting. Cannot find buddy locator." )
	end
end


function this.RealizeHeliPilot()
	local gameObjectId = GameObject.GetGameObjectId( "hos_pilot_0000" )
	local command = { id="SetHostage2Flag", flag="forceRealize", on=true }
	GameObject.SendCommand( gameObjectId, command )
end

function this.StartPilotMotion()
	local n = math.random(0, 19)
	local motionPath
	local overrideflag
	if n < 16 then
		motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dds1/dds1/dds1_q_idl_a.gani"

		overrideflag = true
	elseif n == 16 then
		motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dds1/dds1/dds1_q_idl_b.gani"
		overrideflag = true
	elseif n == 17 then
		motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dds1/dds1/dds1_q_idl_c.gani"
		overrideflag = true
	elseif n == 18 then
		motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dds1/dds1/dds1_q_idl_d.gani"
		overrideflag = true
	elseif n == 19 then
		motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dds1/dds1/dds1_q_idl_e.gani"
		overrideflag = true
	end

	Fox.Log("### StartPilotMotion: ".. tostring(n) .. "###")
	local gameObjectId = GameObject.GetGameObjectId( "hos_pilot_0000" )
	GameObject.SendCommand(
		gameObjectId,
		{
			id = "SpecialAction",
			action = "PlayMotion",
			path = motionPath,
			startPosition = Vector3(-0.610663,1197.717,2.788802),
			override = overrideflag,
			autoFinish = false,
			enableMessage = true,
			commandId = StrCode32("CommandA"),
			enableGravity = false,
			enableCollision = false,
		}
	)
end

function this.OnUpdate()
	this.OnUpdateChunkInstalling()
	if DEBUG then
		this.DebugUpdate()
	end
end

function this.DebugUpdate()
	if not TppSequence.IsMissionPrepareFinished() then
		return
	end
	
	local mvars = mvars
	local DebugTextPrint = DebugText.Print
	local context = DebugText.NewContext()

	if mvars.debug.heliSpace_showQuiet then
		DEBUG.SetDebugMenuValue("Buddy2Block", "SelectEnable", "Enable")
		DEBUG.SetDebugMenuValue("Buddy2Block", "CallType", "Normal")
		DEBUG.SetDebugMenuValue("Buddy2Block", "BuddyType", "Quiet")
		vars.buddyType = BuddyType.QUIET
		TppBuddyService.SetSortieBuddyType(BuddyType.QUIET)
		TppBuddyService.SetVarsMissionStart()
		TppSave.VarSave()
		TppMission.RestartMission()
		mvars.debug.heliSpace_showQuiet = false
	end
	
	if mvars.debug.heliSpace_showDDog then
		DEBUG.SetDebugMenuValue("Buddy2Block", "SelectEnable", "Enable")
		DEBUG.SetDebugMenuValue("Buddy2Block", "CallType", "Normal")
		DEBUG.SetDebugMenuValue("Buddy2Block", "BuddyType", "Dog")
		vars.buddyType = BuddyType.DOG
		TppBuddyService.SetSortieBuddyType(BuddyType.DOG)
		TppBuddyService.SetVarsMissionStart()
		TppSave.VarSave()
		TppMission.RestartMission()
		mvars.debug.heliSpace_showDDog = false
	end
	
	if mvars.debug.heliSpace_setForceShowPhoto then
		mvars.debug.heliSpace_setForceShowPhoto = false
		heli_common_photo.DEBUG_ForceShow( mvars.debug.heliSpace_showPhotoIndex )
	end
	
	for i = 1, 42 do
		if heli_common_photo.DEBUG_IsForceShow( i ) then
			local context = DebugText.NewContext()
			DebugText.Print(context, {0.5, 0.5, 1.0}, "Now force show. photoIndex = " .. tostring(i) )
		end
	end
	
	if mvars.debug.heliSpace_showPhotoIndex < 1 then
		mvars.debug.heliSpace_showPhotoIndex = 1
	end
	
	if mvars.debug.heliSpace_showPhotoIndex > 42 then
		mvars.debug.heliSpace_showPhotoIndex = 42
	end
	
	if mvars.debug.heliSpace_clearForceShowPhoto then
		mvars.debug.heliSpace_clearForceShowPhoto = false
		heli_common_photo.DEBUG_ClearForceShow()
	end

end

function this.SetTerminalAttentionIcon( menuId, switch )
	Fox.Log("#### SetTerminalAttentionIcon ")
	if switch == true then
		Fox.Log("#### SetTerminalAttentionIcon : " .. tostring(menuId) ..  "####")
		TppUiCommand.SetMbTopMenuItemTutorialNotice( menuId, true )
	else
		Fox.Log("#### UnsetTerminalAttentionIcon : " .. tostring(menuId) ..  "####")
		TppUiCommand.SetMbTopMenuItemTutorialNotice( menuId, false )
	end

end

function this.ClearTerminalAttentionIcon()
	
	this.SetTerminalAttentionIcon(TppTerminal.MBDVCMENU.MBM_STAFF, false)
	this.SetTerminalAttentionIcon(TppTerminal.MBDVCMENU.MBM_DEVELOP_WEAPON, false)
	this.SetTerminalAttentionIcon(TppTerminal.MBDVCMENU.MSN_HELI_RENDEZVOUS, false)
	this.SetTerminalAttentionIcon(TppTerminal.MBDVCMENU.MSN_MISSIONLIST, false)
end

function this.PlayerHeliSpaceToPrepareSpace()
	Fox.Log("PlayerHeliSpaceToPrepareSpace")
	local pPos, pRotY = Tpp.GetLocator( "PreparationStageIdentifier", "PlayerPosition" )
	TppPlayer.Warp{
		pos = pPos,
		rotY = pRotY,
	}
	Player.HeliSpaceToPrepareSpace()
end

function this.PlayerPrepareSpaceToHeliSpace()
	Fox.Log("PlayerPrepareSpaceToHeliSpace")
	Player.PrepareSpaceToHeliSpace()
	TppPlayer.Warp{
		pos = mvars.helispacePlayerTransform.pos,
		rotY = mvars.helispacePlayerTransform.rotY
	}
end

function this.SaveCurrentClock()
	Fox.Log("SaveCurrentClock")
	mvars.startEditClock = vars.clock
end

function this.RestoreClock()
	Fox.Log("SaveCurrentClock")
	if mvars.startEditClock then
		vars.clock = mvars.startEditClock
	end
	mvars.startEditClock = nil
end

function this.RestoreWeather()
	Fox.Log("SaveCurrentWeather")
	TppWeather.CancelForceRequestWeather()
end

function this.SetEditingTimeAndWeather()
	Fox.Log("SetEditingTimeAndWeather")
	
	TppWeather.ForceRequestWeather( TppDefine.WEATHER.SUNNY, 0 )
	TppClock.SetTime( "11:40:00" )
	TppClock.Stop()
end

function this.SetMissionPrepPreviewPosition()
	Fox.Log("this.SetMissionPrepPreviewPosition")
	local previewList = {
		{ TppUiCommand.SetMissionPrepPlayerPreviewPosition, "PlayerPosition" },
		{ TppUiCommand.SetMissionPrepBuddyQuietPreviewPosition,"BuddyQuietPosition"},
		{ TppUiCommand.SetMissionPrepBuddyDogPreviewPosition,"BuddyDogPosition"},
		{ TppUiCommand.SetMissionPrepBuddyHorsePreviewPosition,"BuddyHorsePosition"},
		{ TppUiCommand.SetMissionPrepBuddyWalkerPreviewPosition,"BuddyWalkerPosition"},
		{ TppUiCommand.SetMissionPrepBuddyBattleGearPreviewPosition,"BuddyBattleGearPosition"},
		{ TppUiCommand.SetMissionPrepVehiclePreviewPosition,"VehicleCameraPosition" },
		{ TppUiCommand.SetMissionPrepVehicleVehiclePreviewPosition,"VehicleVehiclePosition" },
		{ TppUiCommand.SetMissionPrepVehicleTruckPreviewPosition,"VehicleTruckPosition" },
		{ TppUiCommand.SetMissionPrepVehicleWheeledArmoredVehiclePreviewPosition,"VehicleWheeledArmoredPosition" },
		{ TppUiCommand.SetMissionPrepVehicleTankPreviewPosition,"VehicleTankPosition" },
		{ TppUiCommand.SetMissionPrepWeaponPreviewPosition, "WeaponPosition" },
		{ TppUiCommand.SetMissionPrepHelicopterPreviewPosition, "HeliPosition" },
	}
	for i, previewSetting in ipairs(previewList) do
		local previewFunc, locatorName =  previewSetting[1], previewSetting[2]
		local target = Tpp.GetLocatorByTransform( "PreparationStageIdentifier", locatorName )
		Fox.Log("MissionPrep set preview position. target = " .. tostring(locatorName) )
		previewFunc( target )
	end
end

function this.SetMissionPrepPreviewRotation()
	local previewList = {
		{ TppUiCommand.SetMissionPrepPlayerPreviewRotation, "PlayerPosition" },
		{ TppUiCommand.SetMissionPrepBuddyQuietPreviewRotation,"BuddyQuietPosition"},
		{ TppUiCommand.SetMissionPrepBuddyDogPreviewRotation,"BuddyDogPosition"},
		{ TppUiCommand.SetMissionPrepBuddyHorsePreviewRotation,"BuddyHorsePosition"},
		{ TppUiCommand.SetMissionPrepBuddyWalkerPreviewRotation,"BuddyWalkerPosition"},
		{ TppUiCommand.SetMissionPrepBuddyBattleGearPreviewRotation,"BuddyBattleGearPosition"},
		{ TppUiCommand.SetMissionPrepVehicleVehiclePreviewRotation,"VehicleVehiclePosition" },
		{ TppUiCommand.SetMissionPrepVehicleTruckPreviewRotation,"VehicleTruckPosition" },
		{ TppUiCommand.SetMissionPrepVehicleWheeledArmoredVehiclePreviewRotation,"VehicleWheeledArmoredPosition" },
		{ TppUiCommand.SetMissionPrepVehicleTankPreviewRotation,"VehicleTankPosition" },
		{ TppUiCommand.SetMissionPrepWeaponPreviewRotation, "WeaponPosition" },
		{ TppUiCommand.SetMissionPrepHelicopterPreviewRotation, "HeliPosition" },
	}
	for i, previewSetting in ipairs(previewList) do
		local previewFunc, locatorName =  previewSetting[1], previewSetting[2]
		local tranlation, rotQuat = Tpp.GetLocatorByTransform( "PreparationStageIdentifier", locatorName )
		Fox.Log("MissionPrep set preview position. target = " .. tostring(locatorName) )
		previewFunc( Tpp.GetRotationY( rotQuat ) )
	end
end

function this.SetCustomizePreviewPosition()
	Fox.Log("this.SetCustomizePreviewPosition")
	local previewList = {
		{ TppUiCommand.SetCustomizeWeaponPreviewPosition, "CustomizeWeaponPosition" },
		{ TppUiCommand.SetCustomizeBuddyPreviewPosition, "CustomizeBuddyPosition" },
		{ TppUiCommand.SetCustomizeHelicopterPreviewPosition, "CustomizeHelicopterPosition" },
		{ TppUiCommand.SetCustomizeVehiclePreviewPosition, "CustomizeVehiclePosition" },
		{ TppUiCommand.SetCustomizeHelicopterPreviewPosition, "CustomizeHelicopterPosition" },
	}

	for i, previewSetting in ipairs(previewList) do
		local previewFunc, locatorName = previewSetting[1], previewSetting[2]
		local target = Tpp.GetLocatorByTransform( "PreparationStageIdentifier", locatorName )
		Fox.Log("Customize set preview position. target = " .. tostring(locatorName) )
		previewFunc( target )
	end
end

function this.Messages()
	return
	StrCode32Table {
		UI = {
			{
				msg = "EndFadeOut", sender = "OnEstablishMissionClearFadeOut",
				func = function()
					Player.SetAroundCameraManualMode(false) 
					
					if mvars.heliSequence_nextMissionCode == 50050 then
						if gvars.fobTipsCount <= TppDefine.TIPS.ONLINE_DISPATCH_MISSION then
							gvars.fobTipsCount = gvars.fobTipsCount + 1
						else
							gvars.fobTipsCount = TppDefine.TIPS.FOB_WORM_HOLE
						end
						TppUiCommand.SeekTips( tostring( gvars.fobTipsCount ))
					end
					TppMission.MissionFinalize{ isNoFade = true }
				end,
				option = { isExecMissionClear = true },
			},
			{
				msg = "EmblemEditEnd",
				func = function()
					TppSave.VarSavePersonalData()
					TppSave.SavePersonalData()
				end,
			},
		},
		Terminal = {
			{
				msg = "MbDvcActOpenTop", func = function()
					TppDataUtility.InvisibleMeshFromIdentifier("HeliModelIdentifier","uth0_intr0_def_0000","MESH_IDOROID")
				end
			},
			{
				msg = "MbDvcActCloseTop", func = function()
					TppDataUtility.VisibleMeshFromIdentifier("HeliModelIdentifier","uth0_intr0_def_0000","MESH_IDOROID")
				end
			},
		}
	}
end

function this.ClearMissionListGuidanceLimitation()
	Fox.Log("heli_common_sequence.ClearMissionListGuidanceLimitation")
	
	TppUiCommand.SetTutorialMode( false )
	this.ClearTerminalAttentionIcon()
end

function this.OnTerminate()
	Fox.Log("heli_common_sequence.OnTerminate")
	GrTools.SetSubSurfaceScatterFade(0.0)	
	TppEffectUtility.ClearFxCutLevelMaximum()
	SimDaemon.SetForceStopSimWindEffect(false) 
	TppUiStatusManager.UnsetStatus( "MbDvcTutorial", "INVALID" )
	for target, value in pairs( TppDefine.GAME_STATUS_TYPE_ALL ) do
		Fox.Log("heli_common_sequence.lua : Reset game status : target = " .. tostring(target) )
		TppGameStatus.Reset( "heli_common_sequence.lua", target )
	end
	TppUiStatusManager.UnsetStatus( "ResourcePanel", "SHOW_IN_HELI" )
end

function this.StartRain()
	Gimmick.ResetGimmickData( "uth0_rain1_def_gim_i0000|TppPermanentGimmick_uth0_rain1_def","/Assets/tpp/level/mission2/heli/common/heli_common_asset.fox2" )
	Gimmick.ChangeSequentialEventAnimation2{name="uth0_rain1_def_gim_n0000|srt_uth0_rain1_def",setPath="/Assets/tpp/level/mission2/heli/common/heli_common_asset.fox2", index=0}
end

function this.StopRain()
	Gimmick.ContinueSquentialEventAnimation{name="uth0_rain1_def_gim_n0000|srt_uth0_rain1_def",setPath="/Assets/tpp/level/mission2/heli/common/heli_common_asset.fox2"}
end

function this.AddCommonHeliSpaceMessage( messageTable )
	local messageTable = messageTable or {}
	messageTable.Weather = messageTable.Weather or {}
	table.insert( messageTable.Weather, { msg = "StartRain", func = this.StartRain,	} )
	table.insert( messageTable.Weather, { msg = "FinishRain", func = this.StopRain, } )

	messageTable.GameObject = messageTable.GameObject or {}
	table.insert( messageTable.GameObject, { msg = "SpecialActionEnd", func = this.StartPilotMotion, } )

	messageTable.Timer = messageTable.Timer or {}
	table.insert( messageTable.Timer, {	msg = "Finish", sender = "Timer_MotionReDrawLot", func = this.StartPilotMotion, } )

	messageTable.UI = messageTable.UI or {}
	table.insert( messageTable.UI, {	msg = "PauseMenuGotoMGO", func = this.SelectGoToMGO, } )
	table.insert( messageTable.UI, {	msg = "PauseMenuOpenStore", func = this.SelectPauseMenuOpenStore, } )
	table.insert( messageTable.UI, {	msg = "EndFadeOut", sender = "FadeOutGoToMGO", func = this.OnEndFadeOutGoToMGO, } )
	table.insert( messageTable.UI, {	msg = "EndFadeIn", sender = "FadeInOnStartMissionGame", func = TppTerminal.GetFobStatus, } )

	return messageTable
end

function this.AcquireHelispaceStartCassetteTape()
	Fox.Log("AcquireHelispaceStartCassetteTape")

	
	local storySeqeunce = TppStory.GetCurrentStorySequence()
	if storySeqeunce >= TppDefine.STORY_SEQUENCE.CLEARD_METALLIC_ARCHAEA then
		TppCassette.Acquire{
			cassetteList = {
				"tp_m_10150_15",
				"tp_m_10150_16",
				"tp_m_10150_17",
				"tp_m_10150_23",
			},
			isShowAnnounceLog = { delayTimeSec = 2.0 },
		}
	end
	if TppStory.IsMissionCleard(10260) then
		TppCassette.Acquire{
			cassetteList = { "tp_bgm_11_34" },	
			isShowAnnounceLog = { delayTimeSec = 2.0 },
		}
	end
end

function this.SelectGoToMGO()
	Fox.Log("SelectGoToMGO")
	InvitationManager.EnableMessage(false)	
	mvars.heliSpaceMGOChunkInstallCheckingState = "Start. Chunck prefetching"
	mvars.heliSpaceMgoChunkIndex = Tpp.GetChunkIndex( nil, true )	
	Tpp.StartWaitChunkInstallation( mvars.heliSpaceMgoChunkIndex )
end





local function HeliSpaceGoToMgoCoroutine()
	local function DebugPrintState(state)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "HeliSpaceGoToMgo: " .. tostring(state))
		end
	end
	
	
	if Chunk.GetChunkState(mvars.heliSpaceMgoChunkIndex) ~= Chunk.STATE_INSTALLED then
		Fox.Log("Mgo chunk not installed : mvars.heliSpaceMgoChunkIndex = " .. tostring(mvars.heliSpaceMgoChunkIndex) )
		Tpp.ShowChunkInstallingPopup( mvars.heliSpaceMgoChunkIndex, true )	

		while ( Chunk.GetChunkState(mvars.heliSpaceMgoChunkIndex) ~= Chunk.STATE_INSTALLED )
		and TppUiCommand.IsShowPopup( TppDefine.ERROR_ID.NOW_INSTALLING ) do
			Tpp.ShowChunkInstallingPopup( mvars.heliSpaceMgoChunkIndex, true )	
			coroutine.yield()
			DebugPrintState("Waiting chunk installation.")
		end
		
		if TppUiCommand.IsShowPopup( TppDefine.ERROR_ID.NOW_INSTALLING ) then
			TppUiCommand.ErasePopup()
		end

		while TppUiCommand.IsShowPopup( TppDefine.ERROR_ID.NOW_INSTALLING ) do
			coroutine.yield()
			DebugPrintState("waiting pop up closed.")
		end

		
		if Chunk.GetChunkState(mvars.heliSpaceMgoChunkIndex) ~= Chunk.STATE_INSTALLED then
			return false
		end
	end

	local function existPatchDlcFunc()
		TppUiCommand.ErasePopup()

		
		--RETAILPATCH: 1060
		TppMotherBaseManagement.ProcessBeforeSync()
		TppMotherBaseManagement.StartSyncControl{}
		TppSave.SaveMBAndGlobal()
		TppMission.CreateMbSaveCoroutine()
		
		
		
		while TppMission.waitMbSyncAndSaveCoroutine or TppSave.IsSaving() do
			
			
			coroutine.yield()
			DebugPrintState("waiting save end.")
		end
		--
		TppException.isNowGoingToMgo = true		
		TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHSPEED, "FadeOutGoToMGO", nil, { setMute = true } )
	end
	local function notExistPatchDlcFunc()
		
		
		TppUiCommand.ShowErrorPopup( 5103, Popup.TYPE_ONE_BUTTON )--INVITATION_PATCH_DLC_ERROR
		Tpp.ClearDidCancelPatchDlcDownloadRequest()
		
		while TppUiCommand.IsShowPopup() do
			coroutine.yield()
		end
	end
	return Tpp.PatchDlcCheckCoroutine( existPatchDlcFunc, notExistPatchDlcFunc ) 
end

function this.OnUpdateChunkInstalling()
	if not mvars.heliSpaceMGOChunkInstallCheckingState then
		return
	end
	
	


	if DebugText then
		local context = DebugText.NewContext()
		DebugText.Print(context, "")
		DebugText.Print(context, {1.0, 0.0, 0.0}, "Select GoToMGO : " )
	end
	
	TppUI.ShowAccessIconContinue()

	
	if not mvars.heliSpace_goToMgoCoroutine then
		mvars.heliSpace_goToMgoCoroutine = coroutine.create(HeliSpaceGoToMgoCoroutine)
		return
	end
	
	local status, ret1 = coroutine.resume(mvars.heliSpace_goToMgoCoroutine)
	
	if not TppGameSequence.IsMaster() then
		if ( not status )then
			Fox.Hungup()
		end
	end
	
	
	if ( coroutine.status(mvars.heliSpace_goToMgoCoroutine) == "dead" ) 
	or ( not status )then
		if ( ret1 == false ) or ( not status ) then
			InvitationManager.EnableMessage(true)	
			Mission.SendMessage("UI", "ActivatePauseMenu")
			Chunk.SetChunkInstallSpeed(Chunk.INSTALL_SPEED_NORMAL)
			mvars.heliSpace_goToMgoCoroutine = nil
	    mvars.heliSpaceMGOChunkInstallCheckingState = nil
      mvars.heliSpaceMgoChunkIndex = nil
    end
	end
end

function this.OnEndFadeOutGoToMGO()
	Fox.Log("OnEndFadeOutGoToMGO")
	Mission.SwitchApplication("mgo")
end

function this.SelectPauseMenuOpenStore()
	if not TppUiCommand.StartOnlineStore then
		Fox.Log("SelectPauseMenuOpenStore : skip not supported yet")
		return
	end
	
	if ( Fox.GetPlatformName() ~= "PS3" ) then
		Fox.Log("SelectPauseMenuOpenStore : Mission reload for store is only work PS3")
		return
	end
	
	Fox.Log("SelectPauseMenuOpenStore")
	
	TppSave.ReserveVarRestoreForContinue()
	TppPlayer.ResetInitialPosition()
	TppSequence.ReserveNextSequence("Seq_Demo_PS3Store")
	TppMission.Reload{
		missionPackLabelName = "PS3Store",
		showLoadingTips = false,
	}
end

function this.OnStartFobMission( layout, cluster, missionId, heliRoute )
	mvars.heliSequence_startFobSneaking = true
	mvars.heliSequence_nextMissionCode = missionId
	mvars.heliSequence_heliRoute = heliRoute
	mvars.heliSequence_clusterCategory = nil
	TppMission.AcceptStartFobSneaking( layout, cluster, missionId )
	TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "OnSelectLandingPoint" )
end

function this.OnSelectLandPoint( missionCode, heliRoute, layoutCode, clusterCategory )
	mvars.heliSequence_startFobSneaking = false
	mvars.heliSequence_nextMissionCode = missionCode
	mvars.heliSequence_heliRoute = heliRoute
	mvars.heliSequence_clusterCategory = clusterCategory
	TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "OnSelectLandingPoint" )
end

function this.OnEndFadeOutSelectLandingPoint()
	TppMission.SelectNextMissionHeliStartRoute( mvars.heliSequence_nextMissionCode, mvars.heliSequence_heliRoute, mvars.heliSequence_startFobSneaking )
	
  --tex> apply heliSpace_ flag ivars, WORKAROUND: even though this functions only handling SkipMissionPreparetion, it's called before OnEnter so covers so it's set for that.
  local nextMissionCode=mvars.heliSequence_nextMissionCode
  local heliSpaceFlagNames={
    "SkipMissionPreparetion",
    "NoBuddyMenuFromMissionPreparetion",
    "NoVehicleMenuFromMissionPreparetion",
    "DisableSelectSortieTimeFromMissionPreparetion",
  }
  local heliSpaceFlags={}
  for i,flagName in ipairs(heliSpaceFlagNames)do
    heliSpaceFlags[flagName]=InfTppUtil.GetHeliSpaceFlag(flagName,nextMissionCode)
  end
  if next(heliSpaceFlags)then
    if this.debugModule then
      InfCore.PrintInspect(heliSpaceFlags,"heliSpaceFlags for "..tostring(nextMissionCode))--DEBUG
    end
    InfTppUtil.SetHeliSpaceFlags(heliSpaceFlags,nextMissionCode)
  end
  --<
	
	local needSkipMissionPraparetion = mvars.heliSpace_SkipMissionPreparetion[mvars.heliSequence_nextMissionCode]
	
	if mvars.heliSequence_nextMissionCode == 50050 then
		if vars.fobSneakMode == FobMode.MODE_VISIT then
			needSkipMissionPraparetion = true
			mvars.heliSequence_needCreateEmblemToVisit = true
		end
		if vars.fobSneakMode == FobMode.MODE_SHAM then
			Fox.Log("heli_common_sequence: force mb save to slot, because go to FobMode.MODE_SHAM")
			TppSave.VarSaveMbMangement( nil, true )
		end
	end
	
	if needSkipMissionPraparetion then
		TppUiCommand.ReflectSortieLoadoutInfoToVarsOfCanceledPreparation()
		TppSequence.SetNextSequence("Seq_Game_MissionPreparationEnd")
	else
		TppSequence.SetNextSequence("Seq_Game_MainGameToMissionPreparationTop")
	end
end

function this.GetFobTutorialSequenceName()
	if gvars.str_storySequence < TppDefine.STORY_SEQUENCE.CLEARD_DEATH_FACTORY then
		return
	end
	if not TppTerminal.IsCleardRetakeThePlatform() then
		return
	end
		if gvars.trm_fobTutorialState >= TppTerminal.FOB_TUTORIAL_STATE.FINISH then
		return
	end
	
	
	if gvars.trm_doneFobTutorialInThisGame then
		return
	end
	
	
	if TppMotherBaseManagement.IsBuiltFirstFob() then
		gvars.trm_fobTutorialState = TppTerminal.FOB_TUTORIAL_STATE.FINISH
	end
	
	local fobTutorialSequenceNameTable = {
		[TppTerminal.FOB_TUTORIAL_STATE.INIT]							= "Seq_Game_TutorialIntroductionFobConstruct",
		[TppTerminal.FOB_TUTORIAL_STATE.INTRODUCTION_CONSTRUCT_FOB]	= "Seq_Game_TutorialIntroductionFobConstruct",
		[TppTerminal.FOB_TUTORIAL_STATE.CONSTRUCT_FOB]					= "Seq_Game_TutorialFobConstruct",
		
		
	}

	return fobTutorialSequenceNameTable[gvars.trm_fobTutorialState]
end

sequences.Seq_Game_MainGame = {
	
	Messages = function( self ) 
		local messageTable = 
		{
			UI = {
				{
					msg = "EndFadeOut", sender = "OnSelectLandingPoint",
					func = this.OnEndFadeOutSelectLandingPoint,
				},
				{
					msg = "EndFadeOut", sender = "OnSelectWeaponCustomize",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_WeaponCustomize")
					end,
				},
				{
					msg = "EndFadeOut", sender = "OnSelectAvatarMenu",
					func = function()
						TppSave.ReserveVarRestoreForContinue()
						TppSequence.ReserveNextSequence("Seq_Demo_LoadAvatarEdit")
						TppMission.Reload{
							isNoFade = true,
							missionPackLabelName = "avatarEdit",
							showLoadingTips = false,
						}
					end,
				},
				{
					msg = "Customize_Start",
					func = function( customizeTarget )
						mvars.startCustomizeTarget = customizeTarget
						TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "OnSelectWeaponCustomize" )
					end,
				},
			},
			MotherBaseManagement = {
				{
					msg = "StartFobMission",
					func = this.OnStartFobMission,
				},
			},
			Terminal = {
				{
					msg = "MbDvcActAcceptMissionList", func = TppMission.AcceptMission,
				},
				{
					msg = "MbDvcActOpenTop", func = function()
						
						self.StartPandemicTutorialSequence()
					end
				},
				{
					msg = "MbDvcActSelectLandPoint", func = this.OnSelectLandPoint,
				},
				{
					msg = "MbDvcActSelectAvatarMenu",
					func = function()
						TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "OnSelectAvatarMenu" )
					end,
				},
				{
					
					msg = "MbDvcActOpenMissionList",
					func = function()
						
						if mvars.heliSpace_nowMissionListGuidance then
							
							if not gvars.rad_isFinishMissionListTutorial then
								
								gvars.rad_isFinishMissionListTutorial = true
								this.ClearTerminalAttentionIcon()
								TppTerminal.SetUpOnHelicopterSpace()
								heli_common_radio.MissionListGuide10()
							end
						end
					end
				},
			},
			Radio = {
				{
					
					msg = "Finish",
					sender = "f2000_rtrg1120",
					func = self.FinishMissionListGuidance,
				},
				{
					
					msg = "Finish",
					sender = "f2000_rtrg9040",
					func = self.StartPandemicTutorialSequence,
				},
				{
					
					msg = "Finish",
					func = function( radioGroupHash )
						local radioList = TppStory.GetCurrentFreeHeliRadioList()
						if not radioList then
							return
						end
						if radioList[1] and ( radioGroupHash == StrCode32(radioList[1]) ) then
							Fox.Log("Free heli radio finished.")
							TppUiStatusManager.SetStatus( "ResourcePanel", "SHOW_IN_HELI" )
						end
					end,
				},
				nil
			},
		}

		local messageTable = this.AddCommonHeliSpaceMessage( messageTable )
		return StrCode32Table( messageTable )
	end,

	OnEnter = function( self )
		this.RealizeHeliPilot() 
		this.StartPilotMotion() 
		TppClock.Start()
		TppEffectUtility.SetFxCutLevelMaximum(5)
		GrTools.SetSubSurfaceScatterFade(1.0)	
		SimDaemon.SetForceStopSimWindEffect(true) 
		Player.RequestToStopCameraAnimation{}

		this.DisableGameStatusOnHelispace()
		this.SetMissionPrepPreviewPosition()
		this.SetMissionPrepPreviewRotation()
		this.SetCustomizePreviewPosition()
		
		if not mvars.helispacePlayerTransform then
			mvars.helispacePlayerTransform = {}
			local pos, rotY = Tpp.GetLocator( "HelispaceLocatorIdentifier", "PlayerLocator" )
			mvars.helispacePlayerTransform.pos = pos
			mvars.helispacePlayerTransform.rotY = rotY
		end

		
		TppUiCommand.SetMbTopMenuItemVisible( TppTerminal.MBDVCMENU.MSN, true)
		TppUiCommand.SetMbTopMenuItemActive( TppTerminal.MBDVCMENU.MSN, true)
		TppUiCommand.SetMbTopMenuItemVisible( TppTerminal.MBDVCMENU.MSN_MISSIONLIST, true)
		TppUiCommand.SetMbTopMenuItemActive( TppTerminal.MBDVCMENU.MSN_MISSIONLIST, true)

		
		if not gvars.usingNormalMissionSlot then
			
			TppUiStatusManager.SetStatus( "MissionPrep", "DISABLE_CANCEL_OPERATION" )
			
			TppUiStatusManager.SetStatus( "MissionPrep", "DISABLE_SELECT_SORTIE_TIME" )
			TppSequence.SetNextSequence("Seq_Game_MainGameToMissionPreparationTop")
			TppUI.FadeOut( TppUI.FADE_SPEED.FADE_MOMENT )
			return
		else
			
			TppUiStatusManager.UnsetStatus( "MissionPrep", "DISABLE_CANCEL_OPERATION" )
		end
		
		
		TppMission.ClearFobMode()--RETAILPATCH 1060
		vars.fobIsSneak = 0--RETAILPATCH 1060

		if not svars.showInfoTypingText then
			svars.showInfoTypingText = true
			TppUiCommand.RegistInfoTypingText( "location", 1 )
			TppUiCommand.RegistInfoTypingText( "cpname", 2, "helicopterSpace" )
			TppUiCommand.ShowInfoTypingText()
		end
		
		local fobTutorialSequenceName = this.GetFobTutorialSequenceName()
		if fobTutorialSequenceName then
			local except = Tpp.GetAllDisableGameStatusTable()
			except["PauseMenu"] = nil
			except["AnnounceLog"] = nil
			except["InfoTypingText"] = nil
			except["S_DISABLE_PLAYER_PAD"] = nil
			except["S_DISABLE_NPC"] = nil
			except["S_DISABLE_TARGET"] = nil
			TppUI.OverrideFadeInGameStatus( except )
			TppSequence.SetNextSequence( fobTutorialSequenceName )
			return
		end
		
		
		local radioResult = TppFreeHeliRadio.OnEnter()
		
		heli_common_radio.SetOptionalRadioFromSituation()
		
		this.AcquireHelispaceStartCassetteTape()
		
		if radioResult == TppFreeHeliRadio.ON_ENTER_RESULT.START_PANDEMIC_TUTORIAL then
			
			TppUiStatusManager.SetStatus( "MbDvcTutorial", "INVALID" )
		end
		
		
		if gvars.str_storySequence == TppDefine.STORY_SEQUENCE.CLEARD_TO_MATHER_BASE then
			if not gvars.rad_isFinishMissionListTutorial then
				self.StartMissionListGuidance()
				return
			end
		end

		
		if TppStory.GetCurrentFreeHeliRadioList() == nil then
			Fox.Log("No free heli radio.")
			TppUiStatusManager.SetStatus( "ResourcePanel", "SHOW_IN_HELI" )
		end
		
		InfMain.OnEnterACC()--tex
	end,
	
	OnLeave = function( self, nextSequenceName )
		
		TppFreeHeliRadio.OnLeave()

		if ( nextSequenceName == "Seq_Game_MainGameToMissionPreparationTop" ) then
			this.PlayerHeliSpaceToPrepareSpace()
		end

		if ( nextSequenceName == "Seq_Game_MainGameToMissionPreparationTop" )
		or ( nextSequenceName == "Seq_Game_WeaponCustomize" ) then
			this.SaveCurrentClock()
		end
		
		TppUiStatusManager.UnsetStatus( "ResourcePanel", "SHOW_IN_HELI" )
	end,
	
	StartMissionListGuidance = function()
		Fox.Log("StartMissionListGuidance")
		
		mvars.heliSpace_nowMissionListGuidance = true
		
		
		

		
		TppUiCommand.SetTutorialMode( true )

		
		TppTerminal.SetActiveTerminalMenu {
			TppTerminal.MBDVCMENU.MSN,
			TppTerminal.MBDVCMENU.MSN_MISSIONLIST,
		}

		
		this.ClearTerminalAttentionIcon()
		this.SetTerminalAttentionIcon(TppTerminal.MBDVCMENU.MSN_MISSIONLIST, true)
	end,
	
	FinishMissionListGuidance = function()
		Fox.Log("FinishMissionListGuidance")
		this.ClearMissionListGuidanceLimitation()
		mvars.heliSpace_nowMissionListGuidance = nil
	end,
	
	StartPandemicTutorialSequence = function()
		Fox.Log("StartPandemicTutorialSequence")
		if TppTerminal.IsNeedStartPandemicTutorial() then
			
			TppSequence.SetNextSequence("Seq_Game_PandemicTutorial")
		end
	end
}






sequences.Seq_Game_MainGameToMissionPreparationTop = {
	
	Messages = function( self ) 
		return
		StrCode32Table {
			Timer = {
				{
					msg = "Finish", sender = "Timer_GoToMissionPreparationTop",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_MissionPreparationTop")
					end,
				},
			},
		}
	end,
	OnEnter = function( self )
		WeatherManager.RequestTag("sortie_space", 0 )
		SetReflectionTexture( SORTIE_REFLECTION_PATH )
		this.SetEditingTimeAndWeather()
		Player.SetPadMask{
			settingName = "MissionPrepareSequence",
			except = true,
			sticks = PlayerPad.STICK_R,
		}
		this.SetCameraStageCenter( 0 )	

		if gvars.usingNormalMissionSlot then
			TimerStart( "Timer_GoToMissionPreparationTop", 0.5 )
		else
			TimerStart( "Timer_GoToMissionPreparationTop", 2.0 )
		end
	end,
	OnLeave = function ()
		if not gvars.usingNormalMissionSlot then
			TppSoundDaemon.ResetMute( "Loading" )
		end
		TppUiCommand.StartMissionPreparation()
	end,
}

sequences.Seq_Game_MissionPreparationTop = {
	
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					msg = "EndFadeIn", sender = "OnMissionPreparationStart",
					func = function()
						
					end,
				},
				{
					msg = "EndFadeOut", sender = "OnMissionPreparationAbort",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_MissionPreparationAbort")
					end,
				},
				{
					msg = "MissionPrep_End",
					func =	function( selectedDeployTime )
						mvars.heliSpace_selectedDeployTime = selectedDeployTime
						TppSequence.SetNextSequence("Seq_Game_MissionPreparationEnd")
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_Abort",
					func = function()
						TppMission.OnAbortMissionPreparation()
						TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "OnMissionPreparationAbort" )
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_StartEdit",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_MissionPreparation_SelectItem")
					end,
				},
			},
		}
	end,
	OnEnter = function( self )
		TppException.PermitFobExceptionHandling()
		
		WeatherManager.RequestTag("sortie_space", 0 )
		SetReflectionTexture( SORTIE_REFLECTION_PATH )
		this.SetEditingTimeAndWeather()

		Player.SetPadMask{
			settingName = "MissionPrepareSequence",
			except = true,
			sticks = PlayerPad.STICK_R,
		}

		self.MissionPreparationCamera()
		
		local exceptGameStatus = this.GetExceptGameStatusOnSortieMenu()
		TppUI.FadeIn( TppUI.FADE_SPEED.FADE_HIGHSPEED, "OnMissionPreparationStart", nil, { exceptGameStatus = exceptGameStatus } )
		this.SetCameraStageCenter()
		
		local nextMissionCode = mvars.heliSequence_nextMissionCode
		if not gvars.usingNormalMissionSlot then
			nextMissionCode = TppMission.GetNextMissionCodeForEmergency()	
		end
		
		
		if mvars.heliSpace_DisableSelectSortieTimeFromMissionPreparetion[nextMissionCode] then
			TppUiStatusManager.SetStatus( "MissionPrep", "DISABLE_SELECT_SORTIE_TIME" )
		end
		
		
		TppUiStatusManager.UnsetStatus( "MissionPrep", "DISABLE_SELECT_BUDDY" )
		if mvars.heliSpace_NoBuddyMenuFromMissionPreparetion[nextMissionCode] then
			TppUiStatusManager.SetStatus( "MissionPrep", "DISABLE_SELECT_BUDDY" )
		end
		
		
		if ( nextMissionCode == 10050 )
		or ( nextMissionCode == 10260 )
		or ( nextMissionCode == 11050 ) then
			
			TppBuddyService.SetDisableCallBuddyType(BuddyType.QUIET)
		end
		
		
		TppUiStatusManager.UnsetStatus( "MissionPrep", "DISABLE_SELECT_VEHICLE" )
		if mvars.heliSpace_NoVehicleMenuFromMissionPreparetion[nextMissionCode] then
			TppUiStatusManager.SetStatus( "MissionPrep", "DISABLE_SELECT_VEHICLE" )
		end

		
		if nextMissionCode == 50050 then
			TppUiStatusManager.SetStatus( 'MissionPrep2', 'FOB_MISSION' )
		else
			TppUiStatusManager.UnsetStatus( 'MissionPrep2', 'FOB_MISSION' )
		end		
	end,
	OnLeave = function ()
		this.SetBuddyHeliSpaceSetting()
	end,

	MissionPreparationCamera = function()
		this.SetCameraStageCenter()
	end,
}

local SelectCameraParameter = {

	[ StrCode32( "MissionPrep_FocusTarget_Weapon" ) ]
		= { "WeaponPosition", 1.5, rotX = -10, rotY = 170, interpTime = 0.3,},

	[ StrCode32( "MissionPrep_FocusTarget_PrimaryWeapon" ) ]
		= { "PlayerPosition", 3.0, rotX = 5, rotY = 230, interpTime = 0.4 },

	[ StrCode32( "MissionPrep_FocusTarget_PrimaryWeapon_HIP" ) ]
		= { "PlayerPosition", 2.5, rotX = 5, rotY = 220, interpTime = 0.4 },

	[ StrCode32( "MissionPrep_FocusTarget_PrimaryWeapon_BACK" ) ]
		= { "PlayerPosition_Up", 3.0, rotX = 5, rotY = 320, interpTime = 0.4 },

	[ StrCode32( "MissionPrep_FocusTarget_SecondaryWeapon" ) ]
		= { "PlayerPosition", 3.0 , rotX = -5, rotY = 160, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_SecondaryWeapon_WEAPON" ) ]
		= { "PlayerPosition", 2.0 , rotX = -5, rotY = 150, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_SecondaryWeapon_ARM" ) ]
		= { "PlayerPosition_Up", 2.0 , rotX = -5, rotY = 230, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_SupportWeapon" ) ]
		= { "PlayerPosition_Up", 1.8 , rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_Item" ) ]
		= { "PlayerPosition_Up", 3.3 , rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_Suit" ) ]
		= { "PlayerPosition_Up", 3.3, rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_HeadOption" ) ]
		= { "PlayerHeadPosition", 2.3, rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_Player" ) ]
		= { "PlayerPosition_Up", 3.3, rotX = -5, rotY = 170, interpTime = 0.3 },


	
	[ StrCode32( "MissionPrep_FocusTarget_BuddyQuiet" ) ]
		= { "BuddyQuietPosition", 3.6, rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_BuddyQuietEquip" ) ]
		= { "BuddyQuietPosition_Up", 3.2, rotX = -5, rotY = 270, interpTime = 0.4 },

	[ StrCode32( "MissionPrep_FocusTarget_BuddyDog" ) ]
		= { "BuddyDogPosition", 3.8, rotX = -5, rotY = 182, interpTime = 0.3 },


	[ StrCode32( "MissionPrep_FocusTarget_BuddyHorse" ) ]
		= { "BuddyHorsePosition_2", 5.3, rotX = -5, rotY = 180, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_BuddyWalker" ) ]
		= { "BuddyPosition", 4.0, rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_BuddyBattleGear" ) ]
		= { "BuddyPosition", 5.8, rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_Vehicle" ) ]
		= { "VehicleCameraPosition", 9.0, rotX = 24, rotY = 65, interpTime = 0.6 },

	[ StrCode32( "MissionPrep_FocusTarget_None" ) ]
		= { "StageCenter", 3.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Weapon" ) ]
		= { "CustomizeWeaponPosition", 1.7, rotX = -5, rotY = 170, interpTime = 0.3},
	[ StrCode32( "Customize_Target_Buddy" ) ]
		= { "CustomizeBuddyPosition", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },

	
	[ StrCode32( "Customize_Weapon_Handgun" ) ]
		= { "CustomizeWeaponPosition", 1.0, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_SubMachinegun" ) ]
		= { "CustomizeWeaponPosition", 1.4, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_AssaultRifle" ) ]
		= { "CustomizeWeaponPosition", 1.5, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_ShotGun" ) ]
		= { "CustomizeWeaponPosition", 1.5, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_GrenadeLauncher" ) ]
		= { "CustomizeWeaponPosition", 1.5, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_SniperRifle" ) ]
		= { "CustomizeWeaponPosition", 1.7, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_MachineGun" ) ]
		= { "CustomizeWeaponPosition", 1.7, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_Missile" ) ]
		= { "CustomizeWeaponPosition", 1.7, rotX = 0, rotY = 180, interpTime = 0.3 },


	
	[ StrCode32( "Customize_Target_BuddyDog" ) ]
		= { "CustomizeBuddyPosition", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Dog_Body" ) ]
		= { "CustomizeBuddyPosition", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Dog_Eye" ) ]
		= { "CustomizeBuddyPosition", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },

	
	[ StrCode32( "Customize_Target_BuddyHorse" ) ]
		= { "CustomizeBuddyPosition_HorsePos", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Horse_Body" ) ]
		= { "CustomizeBuddyPosition_HorsePos", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Horse_Head" ) ]
		= { "CustomizeBuddyPosition_HorsePos", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Horse_Leg" ) ]
		= { "CustomizeBuddyPosition_HorsePos", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },

	
	[ StrCode32( "Customize_Target_BuddyWalker" ) ]
		= { "CustomizeBuddyPosition_DWPos", 4.8, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_Body" ) ]
		= { "CustomizeBuddyPosition_DWPos", 4.8, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_Manipulator" ) ]
		= { "CustomizeBuddyPosition_DWPos", 4.0, rotX = -5, rotY = 120, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_MainWeapon" ) ]
		= { "CustomizeBuddyPosition_Head", 3.0, rotX = 7, rotY = 185, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_SubWeapon" ) ]
		= { "CustomizeBuddyPosition_Head", 3.0, rotX = 3, rotY = 115, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_Head" ) ]
		= { "CustomizeBuddyPosition_Head", 3.0, rotX = 25, rotY = 90, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_Color" ) ]
		= { "CustomizeBuddyPosition_DWPos", 4.8, rotX = -5, rotY = 170, interpTime = 0.3 },

	
	[ StrCode32( "Customize_Target_Heli_Body" ) ]
		= { "CustomizeHelicopterCameraPosition", 16 , rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Heli_Main" ) ]
		= { "CustomizeHelicopterCameraPosition_MainWeapon", 10 , rotX = 25, rotY = 150, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Heli_OpFlare" ) ]
		= { "CustomizeHelicopterCameraPosition", 16 , rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Heli_OpArmor" ) ]
		= { "CustomizeHelicopterCameraPosition", 16 , rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Heli_Color" ) ]
		= { "CustomizeHelicopterCameraPosition", 16 , rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "Customize_Target_Helicopter" ) ]
		= { "CustomizeHelicopterCameraPosition", 16 , rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "Customize_Target_Vehicle" ) ]
		= { "CustomizeVehicleCameraPosition", 12, rotX = 15, rotY = 150, interpTime = 0.2 },
}

function this.UpdateCameraParameter( focusTarget, immediately )
	local cameraParameter = SelectCameraParameter[ focusTarget ]
	if not cameraParameter then
		Fox.Error("Invalid focus target. focusTarget = " .. tostring(focusTarget) )
		return
	end
	local locatorName, distance, rotX, rotY, interpTime = cameraParameter[1], cameraParameter[2], cameraParameter.rotX, cameraParameter.rotY, cameraParameter.interpTime
	Fox.Log("MissionPrepare.UpdateCameraParameter: locatorName = " .. tostring(locatorName) .. ", distance = " .. tostring(distance) )
	local target = Tpp.GetLocatorByTransform( "PreparationStageIdentifier", locatorName )
	
	local ignoreCollision
	if focusTarget == StrCode32( "Customize_Target_Buddy" ) 
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyQuiet" )
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyQuietEquip" )
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyDog" )
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyHorse" )
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyWalker" ) 
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyBattleGear" )  then
		ignoreCollision = GameObject.CreateGameObjectId( "TppWalkerGear2", 0 )
	elseif focusTarget == StrCode32( "Customize_Target_Vehicle" ) 
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_Vehicle" ) then
		ignoreCollision = GameObject.CreateGameObjectId( "TppVehicle2", 0 )
	end
	
	local targetInterpTime = 0.3
	
	if immediately then
		targetInterpTime = 0.0
		
	end
	
	if focusTarget == Fox.StrCode32( "MissionPrep_FocusTarget_Weapon" ) then

		Player.SetAroundCameraManualModeParams{
			distance = distance,		
			target = target,			
			focusDistance = 1.5,
			aperture = 1.6,                 
			targetInterpTime = targetInterpTime,         
			targetIsPlayer = false,
			ignoreCollisionGameObjectId = ignoreCollision,
			interpImmediately = immediately,
		}

		Player.SetPadMask {
		        settingName = "WeaponCamera",
		        except = true,
		        sticks = PlayerPad.STICK_L,
		}


	else
		if TppSequence.GetCurrentSequenceName() == "Seq_Game_WeaponCustomize" then
			
			Player.SetAroundCameraManualModeParams{
				distance = distance,		
				target = target,			
				focusDistance = 8.175,
				aperture = 100,				
				targetInterpTime = targetInterpTime,		
				ignoreCollisionGameObjectId = ignoreCollision,
				interpImmediately = immediately,
			}
		else

			Player.SetAroundCameraManualModeParams{
				distance = distance,		
				target = target,			
				focusDistance = 8.175,
				targetInterpTime = targetInterpTime,		
				ignoreCollisionGameObjectId = ignoreCollision,
				interpImmediately = immediately,
			}
		end

	end
	Player.UpdateAroundCameraManualModeParams()
	Player.RequestToSetCameraRotation { rotX = rotX, rotY = rotY, interpTime = interpTime }
end

function this.SetCameraStageCenter( interpTime )
	Fox.Log("MissionPreparationCamera")
	local interpTimeSec = interpTime or 0.3
	local target
	if ( vars.buddyType == BuddyType.HORSE ) then
		target = Tpp.GetLocatorByTransform( "PreparationStageIdentifier", "StageCenter_Horse" )
	else 
		target = Tpp.GetLocatorByTransform( "PreparationStageIdentifier", "StageCenter" )
	end
	Player.SetAroundCameraManualMode(true) 

	if ( vars.buddyType == BuddyType.HORSE ) then

		Player.SetAroundCameraManualModeParams{
			distance = 4.5, 				
			target = target,	  
			targetInterpTime = interpTimeSec, 		
			ignoreCollisionGameObjectName = "Player"		
		}
	else

		Player.SetAroundCameraManualModeParams{
			distance = 4.0, 				
			target = target,	  
			targetInterpTime = interpTimeSec, 		
			ignoreCollisionGameObjectName = "Player"		
		}
	end


	Player.UpdateAroundCameraManualModeParams()
	Player.RequestToSetCameraRotation { rotX = -5, rotY = 170, interpTime = interpTimeSec }


end

function this.SetCameraStageCenter_Go()
	Fox.Log("MissionPreparationCamera")
	local target
	if ( vars.buddyType == BuddyType.HORSE ) then
		target = Tpp.GetLocatorByTransform( "PreparationStageIdentifier", "StageCenter_Horse" )
	else 
		target = Tpp.GetLocatorByTransform( "PreparationStageIdentifier", "StageCenter" )
	end
	Player.SetAroundCameraManualMode(true) 

	if ( vars.buddyType == BuddyType.HORSE ) then

		Player.SetAroundCameraManualModeParams{
			distance = 4.5, 				
			target = target,	  
			targetInterpTime = 0.3, 		
			ignoreCollisionGameObjectName = "Player"		
		}
	else

		Player.SetAroundCameraManualModeParams{
			distance = 4.0, 				
			target = target,	  
			targetInterpTime = 0.3, 		
			ignoreCollisionGameObjectName = "Player"		
		}
	end


	Player.UpdateAroundCameraManualModeParams()
	Player.RequestToSetCameraRotation { rotX = -5, rotY = 170, interpTime = 0.3 }


end

function this.SetCameraStageCenter_GoOut()
	Fox.Log("MissionPreparationCamera")
	local target
	if ( vars.buddyType == BuddyType.HORSE ) then
		target = Tpp.GetLocatorByTransform( "PreparationStageIdentifier", "StageCenter_Horse" )
	else 
		target = Tpp.GetLocatorByTransform( "PreparationStageIdentifier", "StageCenter_Horse" )
	end
	Player.SetAroundCameraManualMode(true) 

	if ( vars.buddyType == BuddyType.HORSE ) then

		Player.SetAroundCameraManualModeParams{
			distance = 3.0, 				
			target = target,	  
			targetInterpTime = 0.6, 		
			ignoreCollisionGameObjectName = "Player"		
		}
	else

		Player.SetAroundCameraManualModeParams{
			distance = 3.0, 				
			target = target,	  
			targetInterpTime = 0.6, 		
			ignoreCollisionGameObjectName = "Player"		
		}
	end


	Player.UpdateAroundCameraManualModeParams()
	Player.RequestToSetCameraRotation { rotX = -15, rotY = 170, interpTime = 0.6 }


end


function this.OnMissionPreparetionEnd( selectedDeployTime )
	TppException.SuspendFobExceptionHandling()
	
	mvars.heliSpace_selectedDeployTime = selectedDeployTime --tex NMC for TppClock.SetTimeFromHelicopterSpace

	if TppUiCommand.IsKansaiDialectEquip() then
		Player.CallVoice( "OSAKA010","DD_Player")
	else
		TppTerminal.PlayTerminalVoice( "VOICE_DONE_DEPLOY" )
	end

	
	if PlayerMissionPrepareAction then	
		GameObject.SendCommand( { type="TppPlayer2", index=PlayerInfo.GetLocalPlayerIndex() }, { id="SetSpecialAttackMode", enabled = true, type = "MissionPrepare", sequence = PlayerMissionPrepareAction.READY, } )
	end
	
	TppBuddyService.EntryGateGo()

	this.SetCameraStageCenter_GoOut()

	TimerStart("Timer_GoToOnMissionPrepar", 1.0 )
	
end

function this.OnEndFadeOutMissionPreparetionEnd()
	TppSequence.SetNextSequence("Seq_Game_MissionPreparationEnd")
end

function this.OnAbortMissionPreparation()
	TppException.ForbidFobExceptionHandling()
	TppMission.OnAbortMissionPreparation()
	TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "OnMissionPreparationAbort" )
end

sequences.Seq_Game_MissionPreparation_SelectItem = {
	
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					msg = "MissionPrep_StartSortieTimeSelect",
					func = function()
						Fox.Log("MissionPrep_StartSortieTimeSelect")
						this.SetCameraStageCenter_Go()
					end,
				},
				{
					msg = "MissionPrep_EndSortieTimeSelect",
					func = function()
						this.SetCameraStageCenter()
					end,
				},
				{
					msg = "EndFadeOut", sender = "OnMissionPreparationAbort",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_MissionPreparationAbort")
					end,
				},
				{
					msg = "EndFadeOut", sender = "OnMissionPreparationEnd",
					func = this.OnEndFadeOutMissionPreparetionEnd,
				},
				{
					msg = "MissionPrep_ChangeEditTarget",
					func = function( focusTarget )
						mvars.heliSpace_currentEditTarget = focusTarget
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_EndEdit",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_MissionPreparationTop")
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_StartItemSelect",
					func = function()
						this.UpdateCameraParameter( mvars.heliSpace_currentEditTarget )
						
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_EndItemSelect",
					func = function()
						Fox.Log("MissionPreparationCamera")
						this.SetCameraStageCenter()
					end,
					option = { isExecMissionClear = true },

				},
				
				
				{
					msg = "MissionPrep_EnterWeaponChangeMenu",
					func = function( focusTarget )
						Fox.Log("EnterEquipPartSelect")
						mvars.heliSpace_currentEditTarget = focusTarget
						this.UpdateCameraParameter( mvars.heliSpace_currentEditTarget )
					end,
					option = { isExecMissionClear = true },
				},
				
				{
					msg = "MissionPrep_ExitWeaponChangeMenu",
					func = function()
						Fox.Log("ExitEquipPartSelect")
						this.SetCameraStageCenter()
					end,
					option = { isExecMissionClear = true },
				},

				{
					msg = "MissionPrep_StartSlotSelect",
					func = function()
						this.UpdateCameraParameter( mvars.heliSpace_currentEditTarget )
						TppSequence.SetNextSequence("Seq_Game_MissionPreparation_SelectSlot")
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_End",
					func =	this.OnMissionPreparetionEnd,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_Abort",
					func = this.OnAbortMissionPreparation,
					option = { isExecMissionClear = true },
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_GoToOnMissionPrepar",
					func = function()
						TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "OnMissionPreparationEnd" )
					end,
				},
			},
		}
	end,
	OnEnter = function( self )
		this.SetCameraStageCenter()
	end,
	OnLeave = function ()
	end,
}

sequences.Seq_Game_MissionPreparation_SelectSlot = {
	
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					msg = "EndFadeOut", sender = "OnMissionPreparationAbort",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_MissionPreparationAbort")
					end,
				},
				{
					msg = "EndFadeOut", sender = "OnMissionPreparationEnd",
					func = this.OnEndFadeOutMissionPreparetionEnd,
				},
				{
					msg = "MissionPrep_EndSlotSelect",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_MissionPreparation_SelectItem")
						
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_StartItemSelect",
					func = function()
						this.UpdateCameraParameter( mvars.heliSpace_currentEditTarget )
						TppSequence.SetNextSequence("Seq_Game_MissionPreparation_SelectDetail")
					end,
					option = { isExecMissionClear = true },
				},

				{
					msg = "MissionPrep_End",
					func =	function( selectedDeployTime )
						mvars.heliSpace_selectedDeployTime = selectedDeployTime
						TppSequence.SetNextSequence("Seq_Game_MissionPreparationEnd")
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_Abort",
					func = this.OnMissionPreparetionEnd,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_ChangeEditTarget",
					func = function( focusTarget )
						mvars.heliSpace_currentEditTarget_forDetail = mvars.heliSpace_currentEditTarget
						mvars.heliSpace_currentEditTarget = focusTarget
						this.UpdateCameraParameter( mvars.heliSpace_currentEditTarget )
					end,
					option = { isExecMissionClear = true },
				},
			},
		}
	end,
	OnEnter = function( self )
		mvars.heliSpace_currentEditTarget_forDetail = mvars.heliSpace_currentEditTarget
	end,
	OnLeave = function ()
	end,
}

sequences.Seq_Game_MissionPreparation_SelectDetail = {
	
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					msg = "EndFadeOut", sender = "OnMissionPreparationAbort",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_MissionPreparationAbort")
					end,
				},
				{
					msg = "EndFadeOut", sender = "OnMissionPreparationEnd",
					func = this.OnEndFadeOutMissionPreparetionEnd,
				},
				{
					msg = "MissionPrep_ChangeEditTarget",
					func = function( focusTarget )
						mvars.heliSpace_currentEditTarget = focusTarget
					end,
					option = { isExecMissionClear = true },
				},

				{
					msg = "MissionPrep_EndItemSelect",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_MissionPreparation_SelectSlot")
						
						mvars.heliSpace_currentEditTarget = mvars.heliSpace_currentEditTarget_forDetail
						this.UpdateCameraParameter( mvars.heliSpace_currentEditTarget_forDetail )

						
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_End",
					func =	this.OnMissionPreparetionEnd,
					option = { isExecMissionClear = true },
				},
				{
					msg = "MissionPrep_Abort",
					func = this.OnAbortMissionPreparation,
					option = { isExecMissionClear = true },
				},
			},
		}
	end,
	OnEnter = function( self )
	end,
	OnLeave = function ()
		Player.ResetPadMask {
		        settingName = "WeaponCamera"
		}

	end,
}

sequences.Seq_Game_MissionPreparationAbort = {
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					msg = "EndFadeIn", sender = "OnMissionPreparationAbort",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_MainGame")
					end,
				},
			},
		}
	end,
	OnEnter = function( self )
		Player.ResetPadMask{
			settingName = "MissionPrepareSequence",
		}
		
		TppBuddyService.UnsetDisableCallBuddyType(BuddyType.QUIET)
		TppUiCommand.AbortMissionPreparation()
		this.PlayerPrepareSpaceToHeliSpace()
		this.DisableGameStatusOnHelispace()
		
		Player.SetAroundCameraManualMode(false) 
		
		this.RestoreClock()
		this.RestoreWeather()
		TppUiStatusManager.UnsetStatus( "MissionPrep", "DISABLE_SELECT_SORTIE_TIME" ) 
		WeatherManager.RequestTag("heli_space", 0 )	
		SetReflectionTexture( HELI_SPACE_REFLECTION_PATH )

		if ( TppMission.GetNextMissionCodeForEmergency() == 50050 ) then
			TppMission.ReturnToMission()	
			mvars.heliSpace_doneReturnToMission = true 
		end
		
		if ( TppUiStatusManager.CheckStatus( 'MissionPrep2', 'FOB_MISSION' ) == true ) then
			TppServerManager.AbortSneakMotherBase()
			TppMission.ClearFobMode()
			vars.fobIsSneak = 0
		end
    self.waitPlayerLoadStartFlame = 5--RETAILPATCH 1.10
		mvars.startFadeIn = false
	end,

	OnUpdate = function(self)
	 --RETAILPATCH 1.10>
	   if TppGameStatus.IsSet("heli_common_sequence.lua", "S_IS_SORTIE_PREPARATION") then
      return
    end
    if self.waitPlayerLoadStartFlame > 0 then
      self.waitPlayerLoadStartFlame = self.waitPlayerLoadStartFlame - 1
      return 
    end
    --<
	
		if not mvars.heliSpace_doneReturnToMission then
			if mvars.startFadeIn == false then
				local isLoading = false
				if Player.IsLoading ~= nil then
					isLoading = Player.IsLoading()
					Fox.Log("PlayerIsLoading : " .. tostring(isLoading))
				end
				if isLoading == false then
					local exceptGameStatus = Tpp.GetAllDisableGameStatusTable()
					TppUI.FadeIn( TppUI.FADE_SPEED.FADE_HIGHSPEED, "OnMissionPreparationAbort", { exceptGameStatus = exceptGameStatus } )
					mvars.startFadeIn = true
				end
			end
		end
	end,
	
	OnLeave = function ()
		WeatherManager.RequestTag("heli_space", 0 )
		SetReflectionTexture( HELI_SPACE_REFLECTION_PATH )
	end,
}


sequences.Seq_Game_MissionPreparationEnd = {
	
	Messages = function( self ) 
		return
		StrCode32Table {
			Timer = {
				{
					msg = "Finish", sender = "Timer_NextMission",
					func = function()
						this.RestoreClock()
						TppMission.OnEndMissionPreparation( mvars.heliSpace_selectedDeployTime , mvars.heliSequence_clusterCategory)
					end,
				},
			},
		}
	end,
	OnEnter = function( self )
		TppUiCommand.EndMissionPreparation()
		TppUiStatusManager.UnsetStatus( "MissionPrep", "DISABLE_SELECT_SORTIE_TIME" ) 
		TppBuddyService.UnsetDisableCallBuddyType(BuddyType.QUIET)
		vars.playerInjuryCount = 0 

		if mvars.heliSequence_needCreateEmblemToVisit then
			TppUiCommand.CreateEmblemToVisit()
		end
	end,
	
	OnUpdate = function( self )
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "Creating emblem data ...")
		end
		
		local isCreatingEmblem = TppUiCommand.IsCreatingEmblem()
		if mvars.heliSequence_needCreateEmblemToVisit then
			if DebugText then
				DebugText.Print(DebugText.NewContext(), "/ for fob visit mode /")
			end
			isCreatingEmblem = TppUiCommand.IsCreatingEmblemToVisit()
		end
		
		if not isCreatingEmblem then
			if not mvars.heliSpace_doneOnEndMissionPreparation then
				mvars.heliSpace_doneOnEndMissionPreparation = true
				GkEventTimerManager.Start("Timer_NextMission",1)
			end
		end
	end,
}





sequences.Seq_Game_WeaponCustomize = {
	
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					msg = "EndFadeIn", sender = "OnWeaponCustomizeStart",
					func = function()
						
					end,
				},
				{
					msg = "EndFadeOut", sender = "OnWeaponCustomizeAbort",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_WeaponCustomizeAbort")
					end,
				},
				{
					msg = "EndFadeOut", sender = "OnWeaponCustomizeEnd",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_WeaponCustomizeEnd")
					end,
				},
				{
					msg = "Customize_ChangePart",
					func = function( focusTarget )
						mvars.heliSpace_currentEditTarget = focusTarget
						this.UpdateCameraParameter( mvars.heliSpace_currentEditTarget )
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "Customize_End",
					func =	function()
						TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "OnWeaponCustomizeEnd" )
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "Customize_Abort",
					func = function()
						TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "OnWeaponCustomizeAbort" )
					end,
					option = { isExecMissionClear = true },
				},
			},
		}
	end,
	
	OnEnter = function( self )
		this.SetEditingTimeAndWeather()
		WeatherManager.RequestTag("sortie_space", 0 )
		SetReflectionTexture( SORTIE_REFLECTION_PATH )

		if mvars.startCustomizeTarget == StrCode32( "Customize_Target_Weapon" ) then
			Fox.Log("### Customize:Weapon ###")
			WeatherManager.RequestTag("sortie_space_ShadowShort", 0 ) 
			Player.SetPadMask{
				settingName = "CustomizeSelector",
				except = true,
				buttons = PlayerPad.ZOOM_CHANGE,
			}

		elseif mvars.startCustomizeTarget == StrCode32( "Customize_Target_Helicopter" )
		or mvars.startCustomizeTarget == StrCode32( "Customize_Target_Vehicle" ) then
			Fox.Log("### Customize:Heli & Vehicle ###")
			WeatherManager.RequestTag("sortie_space_heli", 0 )
			Player.SetPadMask{
				settingName = "CustomizeSelector",
				except = true,
				buttons = PlayerPad.ZOOM_CHANGE,
				sticks = PlayerPad.STICK_R,
			}
		else
			Fox.Log("### Customize: etc ###")
			Player.SetPadMask{
				settingName = "CustomizeSelector",
				except = true,
				buttons = PlayerPad.ZOOM_CHANGE,
				sticks = PlayerPad.STICK_R,
			}
		end
		
		TppUiCommand.OpenCustomizeSelector()
		
		Player.SetAroundCameraManualMode(true) 
		this.UpdateCameraParameter( mvars.startCustomizeTarget, true )
		
		local exceptGameStatus = this.GetExceptGameStatusOnSortieMenu()
		TppUI.FadeIn( TppUI.FADE_SPEED.FADE_HIGHSPEED, "OnWeaponCustomizeStart", nil, { exceptGameStatus = exceptGameStatus } )
		SetReflectionTexture( SORTIE_REFLECTION_PATH )
	end,
	OnLeave = function ()
		TppUiCommand.CloseCustomizeSelector()
		WeatherManager.RequestTag("heli_space", 0 ) 
		SetReflectionTexture( HELI_SPACE_REFLECTION_PATH )
	end,
}


sequences.Seq_Game_WeaponCustomizeAbort = {
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					msg = "EndFadeIn", sender = "OnWeaponCustomizeAbort",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_MainGame")
					end,
				},
			},
		}
	end,
	OnEnter = function( self )
		Player.SetAroundCameraManualMode(false) 
		this.SetBuddyHeliSpaceSetting()
		this.RestoreClock()
		this.RestoreWeather()
		WeatherManager.RequestTag("heli_space", 0 )
		SetReflectionTexture( HELI_SPACE_REFLECTION_PATH )
		Player.ResetPadMask{
			settingName = "CustomizeSelector",
		}
		this.DisableGameStatusOnHelispace()
		local exceptGameStatus = Tpp.GetAllDisableGameStatusTable()
		TppUI.FadeIn( TppUI.FADE_SPEED.FADE_HIGHSPEED, "OnWeaponCustomizeAbort", { exceptGameStatus = exceptGameStatus } )
	end,
}


sequences.Seq_Game_WeaponCustomizeEnd = {
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					msg = "EndFadeIn", sender = "OnWeaponCustomizeEnd",
					func = function()
						this.DisableGameStatusOnHelispace()
						TppSequence.SetNextSequence("Seq_Game_MainGame")
					end,
				},
			},
		}
	end,
	OnEnter = function( self )
		Player.SetAroundCameraManualMode(false) 
		this.SetBuddyHeliSpaceSetting()
		this.RestoreClock()
		this.RestoreWeather()
		WeatherManager.RequestTag("heli_space", 0 )
		SetReflectionTexture( HELI_SPACE_REFLECTION_PATH )
		Player.ResetPadMask{
			settingName = "CustomizeSelector",
		}
		this.DisableGameStatusOnHelispace()
		local exceptGameStatus = Tpp.GetAllDisableGameStatusTable()
		TppUI.FadeIn( TppUI.FADE_SPEED.FADE_HIGHSPEED, "OnWeaponCustomizeEnd", { exceptGameStatus = exceptGameStatus } )
		TppSave.SaveOnlyMbManagement()
	end,
}


sequences.Seq_Demo_LoadAvatarEdit = {
	OnEnter = function( self )
		if ( mvars.avatarEditStart == false ) then
			Player.SetPadMask{
				settingName = "avatarEdit",
				except = true,
			}
			this.SaveCurrentClock()
			this.SetEditingTimeAndWeather()
			TppTerminal.EnableTerminalVoice( false )
			TppUiCommand.LoadAvatarEdit( { type=AvatarEdit.AVATAR_IN_HELI, presets=avatar_presets.presets } )
			TppSequence.SetNextSequence("Seq_Demo_WaitReadyAvatarEdit")
		end
	end,
}


sequences.Seq_Demo_WaitReadyAvatarEdit = {
	OnEnter = function( self )
	end,
	OnUpdate = function( self )
		if ( mvars.avatarEditStart == false ) then
			if TppUiCommand.IsAvatarEditReady() then
				mvars.avatarEditStart = true
				TppUiCommand.StartAvatarEdit()
				Player.SetAroundCameraManualMode(true)
				vars.playerDisableActionFlag = PlayerDisableAction.LOOK_CAMERA_DIR
				local exceptGameStatus = Tpp.GetAllDisableGameStatusTable()
				TppUI.FadeIn( TppUI.FADE_SPEED.FADE_HIGHSPEED, "FadeInAvatarEditStart", { exceptGameStatus = exceptGameStatus } )
				TppSequence.SetNextSequence("Seq_Game_AvatarEdit")
			end
		end
	end,
}

sequences.Seq_Game_AvatarEdit = {
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					msg = "AvatarEditEnd",
					func = function( needSave )
						if needSave and ( needSave == 1 ) then
							mvars.needAvatarSave = true
						else
							mvars.needAvatarSave = false
						end
						TppUI.FadeOut( TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "FadeOutAvatarEditEnd" )
					end,
				},
				{
					msg = "EndFadeOut", sender = "FadeOutAvatarEditEnd",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_AvatarEditEnd")
					end,
				},
			},
		}
	end,
	OnEnter = function( self )
		TppSoundDaemon.ResetMute( "Loading" )
		GrTools.SetSubSurfaceScatterFade(0.6)
	end,
}


sequences.Seq_Game_AvatarEditEnd = {
	OnEnter = function( self )
		TppUiCommand.EndAvatarEdit()	
		if mvars.needAvatarSave then
			TppSave.SaveAvatarData()
		end
		Player.SetAroundCameraManualMode(false)
		this.RestoreWeather()
		this.RestoreClock()
		TppSave.ReserveVarRestoreForContinue()
		TppPlayer.ResetInitialPosition()
		TppSequence.ReserveNextSequence("Seq_Game_MainGame")
		TppMission.Reload{
			isNoFade = true,
			missionPackLabelName = "default",
			showLoadingTips = false,
		}
	end,
}


sequences.Seq_Game_PandemicTutorial = {
	Messages = function( self ) 
		local messageTable = {
			MotherBaseManagement = {
				{
					msg = "ChangedStaffListTab",
					func = function( assingnedSection )
						Fox.Log( "ChangedStaffListTab " .. tostring(assingnedSection) )
						
						if ( assingnedSection == TppMotherBaseManagementConst.SECTION_SEPARATION ) then
							if not TppRadio.IsPlayed( TppFreeHeliRadio.PANDEMIC_RADIO.PANDEMIC_FACILITY ) then
								TppFreeHeliRadio._PlayRadio( TppFreeHeliRadio.PANDEMIC_RADIO.PANDEMIC_FACILITY )
							end
							
							TppTerminal.FinishPandemicTutorial()							
						end
					end,
				},
			},
			Terminal = {
				{
					msg = "MbDvcActOpenTop", func = function()
						this.SetPandemicTutorialMbMenuActive( PANDEMIC_TUTORIAL_DISPLAY.STAFF_ENABLED )	
					end
				},
				{
					msg = "MbDvcActCloseTop",
					func = function()
						
						if TppTerminal.IsPandemicTutorialFinished() then
							TppSequence.SetNextSequence("Seq_Game_MainGame")
						end
					end,
				},
				{
					msg = "MbDvcActOpenStaffList",
					func = function()
						if not TppRadio.IsPlayed( TppFreeHeliRadio.PANDEMIC_RADIO.OPEN_TERMINAL_SELECT ) then
							TppFreeHeliRadio._PlayRadio( TppFreeHeliRadio.PANDEMIC_RADIO.OPEN_TERMINAL_SELECT )
						end
					end,
				},
			},
		}
		
		local messageTable = this.AddCommonHeliSpaceMessage( messageTable )
		return StrCode32Table( messageTable )
	end,
	OnEnter = function( self )
		Fox.Log( "Seq_Game_PandemicTutorial OnEnter" )
		
		if not TppRadio.IsPlayed( TppFreeHeliRadio.PANDEMIC_RADIO.OPEN_TERMINAL ) then
			TppFreeHeliRadio._PlayRadio( TppFreeHeliRadio.PANDEMIC_RADIO.OPEN_TERMINAL )
		end
		this.SetPandemicTutorialMbMenuActive( PANDEMIC_TUTORIAL_DISPLAY.STAFF_ENABLED )	
		TppUiCommand.RequestMbDvcOpenCondition{ imagePath="/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10211_09.ftex" } 
	end,
	OnLeave = function( self )
		Fox.Log( "Seq_Game_PandemicTutorial OnLeave" )
		
		
		TppCassette.Acquire{
			cassetteList = { "tp_c_00000_18" },
			isShowAnnounceLog = true,
		}
		
		this.SetPandemicTutorialMbMenuActive( PANDEMIC_TUTORIAL_DISPLAY.ALL_ENABLED )	
		
		


	end,
}

this.SetPandemicTutorialMbMenuActive = function( displayState )
	
	if displayState == PANDEMIC_TUTORIAL_DISPLAY.ALL_DISABLED then
		TppUiCommand.SetTutorialMode( false )	
		
		
		heli_common_sequence.SetTerminalAttentionIcon( TppTerminal.MBDVCMENU.MBM_STAFF, false )
						
		
		TppUiCommand.InitAllMbTopMenuItemActive( false )
	
	elseif displayState == PANDEMIC_TUTORIAL_DISPLAY.STAFF_ENABLED then
		TppUiCommand.SetTutorialMode( true )	
		
		
		heli_common_sequence.SetTerminalAttentionIcon( TppTerminal.MBDVCMENU.MBM_STAFF, true )
		
		
		TppUiCommand.SetMbTutorialMark( "STAFFLIST_SEPARATION_TAB", true )

		
		TppUiCommand.InitAllMbTopMenuItemActive( false )
		TppUiCommand.SetMbTopMenuItemActive( TppTerminal.MBDVCMENU.MBM_STAFF, true )
	else
		TppUiCommand.SetTutorialMode( false )	
		
		
		heli_common_sequence.SetTerminalAttentionIcon( TppTerminal.MBDVCMENU.MBM_STAFF, false )

		
		TppUiCommand.InitAllMbTopMenuItemActive( true )
	end

end

local TERMINAL_TUTORIAL_RESULT = {
	OK = 1,
	NG = 0,
}

sequences.Seq_Game_TutorialIntroductionFobConstruct = {
	Messages = function( self ) 
		local messageTable = {
			Radio = {
				{
					msg = "Finish",
					sender = "f2000_rtrg1459",
					func = function()
						gvars.trm_fobTutorialState = TppTerminal.FOB_TUTORIAL_STATE.CONSTRUCT_FOB
						TppSequence.SetNextSequence("Seq_Game_TutorialFobConstruct")
					end
				},
			},
		}
		local messageTable = this.AddCommonHeliSpaceMessage( messageTable )
		return StrCode32Table( messageTable )
	end,
	OnEnter = function( self )
		Fox.Log( "Seq_Game_TutorialFobIntroduction" )
		TppUI.RegisterHeliSpacePauseMenuPage( false )
		vars.playerDisableActionFlag = PlayerDisableAction.SUBJECTIVE_CAMERA + PlayerDisableAction.HELISPACE_CASSETTE
		TppRadio.Play( { "f2000_rtrg1459", "f2000_rtrg1460" }, { delayTime = "mid" } )
	end,
	OnLeave = function( self, nextSequenceName )
		TppUI.RegisterHeliSpacePauseMenuPage( true )
		this.OverrideFadeInGameStatus()
		TppPlayer.ResetDisableAction()
	end,
}


sequences.Seq_Game_TutorialFobConstruct = {
	Messages = function( self ) 
		local messageTable = {
			Terminal = {
				{
					msg = "MbDvcActEndTutorial",
					sender = "FOB_EXPANTION",
					func = function( tutorialNameHash, result )
						if result == TERMINAL_TUTORIAL_RESULT.OK then
							
							TppTerminal.ReleaseFunctionOfMbSection()
							TppMotherBaseManagement.UpdateSections()--RETAILPATCH 1060
							TppSequence.SetNextSequence("Seq_Game_MainGame")
						else
							TppSequence.SetNextSequence("Seq_Game_MainGame")
						end
					end
				},
				{
					msg = "MbDvcActEndTutorial",
					sender = "ONLINE",
					func = function( tutorialNameHash, result )
						TppSequence.SetNextSequence("Seq_Game_MainGame")
					end
				},
			},
		}
		local messageTable = this.AddCommonHeliSpaceMessage( messageTable )
		return StrCode32Table( messageTable )
	end,
	OnEnter = function( self )
		Fox.Log( "Seq_Game_TutorialFobConstruct OnEnter" )
		TppUI.RegisterHeliSpacePauseMenuPage( false )
		vars.playerDisableActionFlag = PlayerDisableAction.HELISPACE_CASSETTE
		gvars.trm_doneFobTutorialInThisGame = true
		if TppGameMode.GetUserMode() == TppGameMode.U_KONAMI_LOGIN then
			TppUiCommand.RequestMbDvcOpenCondition{ isForceTutorial=true, tutorialMode="FOB_EXPANTION" }
		else
			TppUiCommand.RequestMbDvcOpenCondition{ isForceTutorial=true, tutorialMode="ONLINE" }
		end
	end,
	OnLeave = function( self )
		gvars.trm_fobTutorialState = TppTerminal.FOB_TUTORIAL_STATE.INTRODUCTION_FOB_MISSIONS
		TppPlayer.ResetDisableAction()
		TppUI.RegisterHeliSpacePauseMenuPage( true )
		this.OverrideFadeInGameStatus()
	end,
}





































































































sequences.Seq_Demo_PS3Store = {
	Messages = function( self ) 
		return StrCode32Table{
			UI = {
				{
					msg = "EndOnlineStore",
					func = function()
						Shop.FreePSStoreMemory()
						TppSave.ReserveVarRestoreForContinue()
						TppPlayer.ResetInitialPosition()
						TppSequence.ReserveNextSequence("Seq_Game_MainGame")
						TppMission.Reload{
							isNoFade = true,
							missionPackLabelName = "default",
							showLoadingTips = false,
						}
					end,
				},
			},
		}
	end,
	OnEnter = function( self )
		TppUiCommand.StartOnlineStore()
	end,
	OnLeave = function( self )
	end,
}




return this
