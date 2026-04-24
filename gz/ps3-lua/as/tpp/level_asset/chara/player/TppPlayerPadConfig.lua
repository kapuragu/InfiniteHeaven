--------------------------------------------------------------------------------
--! @file	TppPlayerPadConfig.lua
--! @brief	システム関連のユーティリティ Lua 関数群
--------------------------------------------------------------------------------

TppPlayerPadConfig = {


--[[
-- C++化
ConfigDefaultPadAssigns = function()
end,

]]


-------------------------------------------------------------------------------------------------
-- パッドコンフィグ
-------------------------------------------------------------------------------------------------
SetConfigDefaultPadAssigns = function(padType)

	Fox.Log(" > SetConfigDefaultPadAssigns padType:" .. padType )

	-- どのパッドタイプでも変化の無いもの
	TppPlayerPadConfig.baseAssigns()

	-- パッドタイプごとの設定
	if padType == 0 then
		-- アクションタイプA(デフォルト)
		TppPlayerPadConfig.defaultAssigns( false )
	elseif padType == 1 then
		-- シュータータイプA
		TppPlayerPadConfig.fpsTypeAssigns( false )
	elseif padType == 2 then
		-- アクションタイプB
		TppPlayerPadConfig.defaultAssigns( true )
	elseif padType == 3 then
		-- シュータータイプB
		TppPlayerPadConfig.fpsTypeAssigns( true )
	else
		Fox.Warning("no defined padType : " .. padType)
	end

	TppPlayerPadConfig.vehicleAssigns()

	Fox.Log(" > > > >")

end,

-- 全パターン共通
baseAssigns = function()

	-- LRトリガの検出用の閾値変更
 	-- @param level 0.5-3.0の範囲でlevelが高いほど深い入力にに敏感になります.
 	-- @note	通常1.0-1.75程度に設定します.
	-- 引数を省略する(無効な値を入力すると)とデフォルト値に戻します.わかり辛れぇ…
	HidDriver.SetPadSensibility("digitaltrigger",0.8)

--[[
   	if Pad.GetDeviceType() == "PAD_DEVICE_TYPE_X360" then
		Fox.Log("360")
	elseif Pad.GetDeviceType() == "PAD_DEVICE_TYPE_PS3" then
		Fox.Log("PS3")
	elseif Pad.GetDeviceType() == "PAD_DEVICE_TYPE_OTHERS" then
		Fox.Log("Other")
	else
		Fox.Log("UnKnown")
	end
]]
	-- 基本ボタン
	Pad.RegisterButtonAssign	( "OK",				fox.PAD_A )
	Pad.RegisterButtonAssign	( "CANCEL",			fox.PAD_B )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_PAUSE",			fox.PAD_SELECT )

	-- アクション
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_ROLLING",			fox.PAD_L3 )	-- Side Roll
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_LIGHTSWITCH",		fox.PAD_R )		-- フラッシュライトのスイッチ切替

	-- スティック
	Pad.RegisterAxisAssign		( "LSTICK_X",		fox.PAD_AXIS_LX, false )
	Pad.RegisterAxisAssign		( "LSTICK_Y",		fox.PAD_AXIS_LY, false )
	Pad.RegisterAxisAssign		( "RSTICK_X",		fox.PAD_AXIS_RX, false )
	Pad.RegisterAxisAssign		( "RSTICK_Y",		fox.PAD_AXIS_RY, false )

	-- CQC動作チェック
	TppPadOperatorUtility.RegisterButtonAssign	( "CQC_TESTMODE",		fox.PAD_X )
	TppPadOperatorUtility.RegisterButtonAssign	( "CQC_TESTMODE_UP",	fox.PAD_U )
	TppPadOperatorUtility.RegisterButtonAssign	( "CQC_TESTMODE_DOWN",	fox.PAD_D )

	-- カメラ
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_ZOOM_CHANGE", fox.PAD_R3, "Camera" )	-- 注目
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_ZOOM_IN", fox.PAD_U, "Camera" )	-- ズームイン
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_ZOOM_OUT", fox.PAD_D, "Camera" )	-- ズームアウト

	-- サーチライト
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_SEARCHLIGHT",		fox.PAD_R ) -- used in turret

	-- 声かけ
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_CALL",	fox.PAD_L1 )

	-- 装備
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_PAD_PRIMARY",		fox.PAD_U )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_PAD_SECONDARY",	fox.PAD_D )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_PAD_SUPPORT",		fox.PAD_L )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_PAD_ITEM",		fox.PAD_R )

	-- 犬(PadDogActions)
    Pad.RegisterButtonAssign( "DOG_PAD_ACCEL",	fox.PAD_B )
    Pad.RegisterButtonAssign( "DOG_PAD_BREAK",	fox.PAD_X )
	Pad.RegisterButtonAssign( "DOG_PAD_BARK_NORMAL",	fox.PAD_R )
	Pad.RegisterButtonAssign( "DOG_PAD_BARK_MAD",	fox.PAD_L )
	Pad.RegisterButtonAssign( "DOG_PAD_BARK_JOY",	fox.PAD_U )
	Pad.RegisterButtonAssign( "DOG_PAD_SQUAT",	fox.PAD_A )
	Pad.RegisterButtonAssign( "DOG_PAD_SCENT",	fox.PAD_Y )
	Pad.RegisterButtonAssign( "DOG_PAD_CRAWL",	fox.PAD_D )

	-- MotherBase端末
	TppPadOperatorUtility.RegisterButtonAssign	( "MB_DEVICE",	fox.PAD_START )

	-- ストライカー
	TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_PAD_RIDEON",		fox.PAD_Y )
	TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_PAD_RIDEOFF",		fox.PAD_Y )
	TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_PAD_FIRE",			fox.PAD_L1 )
	TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_PAD_BREAK",		fox.PAD_L2 )	-- アナログ対応をしたので不要
	TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_PAD_ACCEL",		fox.PAD_R2 )	-- アナログ対応をしたので不要
	TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_PAD_CHANGESIGHT",	fox.PAD_R3 )
	TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_PAD_SWITCH_LIGHT",	fox.PAD_R )
	
	--アクセル・ブレーキ(トリガーとして登録。UIのアイコン表示のためにボタンとしても登録)
	TppPadOperatorUtility.RegisterTriggerAssign( "VEHICLE_TRIGGER_BREAK",	fox.PAD_TRIGGER_LEFT )
	TppPadOperatorUtility.RegisterTriggerAssign( "VEHICLE_TRIGGER_ACCEL",	fox.PAD_TRIGGER_RIGHT )
	TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_TRIGGER_BREAK",	fox.PAD_L2 )	-- アナログ対応をしたので不要
	TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_TRIGGER_ACCEL",	fox.PAD_R2 )	-- アナログ対応をしたので不要

	-- スティック
	TppPadOperatorUtility.RegisterStickAssign( "PL_STICK_L", fox.PAD_STICK_LEFT, "Player", false, false )
	TppPadOperatorUtility.RegisterStickAssign( "PL_STICK_R", fox.PAD_STICK_RIGHT, "Player", false, false )

	-- 中メタル
	TppPadOperatorUtility.RegisterButtonAssign( "MGM_PAD_RIDEON",	fox.PAD_Y )
	TppPadOperatorUtility.RegisterButtonAssign( "MGM_PAD_RIDEOFF",	fox.PAD_Y )
	TppPadOperatorUtility.RegisterButtonAssign( "MGM_PAD_CARRY",	fox.PAD_A )
	TppPadOperatorUtility.RegisterButtonAssign( "MGM_PAD_HOLD",		fox.PAD_L2 )
	TppPadOperatorUtility.RegisterButtonAssign( "MGM_PAD_DASH",		fox.PAD_X )
	TppPadOperatorUtility.RegisterButtonAssign( "MGM_PAD_SHOT",		fox.PAD_R2 )
end,

-- 車両のためのパッドアサイン
vehicleAssigns = function()
	local localPlayerCharacter = TppPlayerUtility.GetLocalPlayerCharacter()
	if TppPlayerUtility.IsRidingVehicle( localPlayerCharacter ) then
		Fox.Log("Ride On Vehicle")
		TppPadOperatorUtility.RegisterButtonAssign( "PL_CALL", fox.PAD_X )
		TppPadOperatorUtility.RegisterButtonAssign( "PL_SUB_CAMERA", fox.PAD_R1 )
	end
	if TppPlayerUtility.IsRidingStryker( localPlayerCharacter ) then
		Fox.Log("Ride On Stryker")
		TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_PAD_TOGGLE_WEAPON", fox.PAD_R )
	end
end,

defaultAssigns = function( CqcButtonConfig )

	Fox.Log("default Pad Assignment : CqcButtonConifg is " .. tostring(CqcButtonConfig) )

	local sysL1 = fox.PAD_L1
	local sysL2 = fox.PAD_L2
	local sysR1 = fox.PAD_R1
	local sysR2 = fox.PAD_R2
	
	if Pad.GetDeviceType() == "PAD_DEVICE_TYPE_X360" then
		-- nothing
   	elseif Pad.GetDeviceType() == "PAD_DEVICE_TYPE_PS3" then
		sysL1 = fox.PAD_L2;
		sysL2 = fox.PAD_L1;
		sysR1 = fox.PAD_R2;
		sysR2 = fox.PAD_R1;
	else
		-- use x360, so nothing
	end

	TppPadOperatorUtility.RegisterButtonAssign	( "PL_ACTION",			fox.PAD_Y )

	TppPadOperatorUtility.RegisterButtonAssign	( "PL_RELOAD",			fox.PAD_B )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_SQUAT",			fox.PAD_A )
	
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_CALL",			sysL1 )

	TppPadOperatorUtility.RegisterButtonAssign	( "PL_SUB_CAMERA",		sysR1 )

	TppPadOperatorUtility.RegisterButtonAssign	( "PL_HOLD",			sysL2 )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_SHOT",			sysR2 )

	TppPadOperatorUtility.RegisterButtonAssign	( "PL_DASH", 			fox.PAD_L3 )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_STOCK",			fox.PAD_R3 ) -- L/R over the shoulder during aim mode

	if ( CqcButtonConfig ) then
		TppPadOperatorUtility.RegisterButtonAssign	( "PL_CQC",				fox.PAD_X )
		TppPadOperatorUtility.RegisterButtonAssign	( "PL_EVADE_ACTION",	sysR2 )
	else
		TppPadOperatorUtility.RegisterButtonAssign	( "PL_CQC",				sysR2 )
		TppPadOperatorUtility.RegisterButtonAssign	( "PL_EVADE_ACTION",	fox.PAD_X )
	end
	
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_CQC_INTERROGATE",	sysL1 )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_CQC_KNIFE_KILL",	fox.PAD_Y )

	TppPadOperatorUtility.RegisterButtonAssign	( "HORSE_PAD_ACCEL",	fox.PAD_X )
	TppPadOperatorUtility.RegisterButtonAssign	( "HORSE_PAD_CLING",	fox.PAD_A )

end,

-- FPSタイプ
fpsTypeAssigns = function( CqcButtonConfig )

	Fox.Log("fpsTypeAssigns : CqcButtonConifg is " .. tostring(CqcButtonConfig) )

	local sysL1 = fox.PAD_L1
	local sysL2 = fox.PAD_L2
	local sysR1 = fox.PAD_R1
	local sysR2 = fox.PAD_R2
	
	if Pad.GetDeviceType() == "PAD_DEVICE_TYPE_X360" then
		-- nothing
   	elseif Pad.GetDeviceType() == "PAD_DEVICE_TYPE_PS3" then
		sysL1 = fox.PAD_L2;
		sysL2 = fox.PAD_L1;
		sysR1 = fox.PAD_R2;
		sysR2 = fox.PAD_R1;
	else
		-- use x360, so nothing
	end
	
	-- プレイヤー操作
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_ACTION",			fox.PAD_A )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_SQUAT",			fox.PAD_B )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_RELOAD",			fox.PAD_X )
	
	if ( CqcButtonConfig ) then
		TppPadOperatorUtility.RegisterButtonAssign	( "PL_CQC",				fox.PAD_Y )
		TppPadOperatorUtility.RegisterButtonAssign	( "PL_EVADE_ACTION",	sysR2 )
	else
		TppPadOperatorUtility.RegisterButtonAssign	( "PL_CQC",				sysR2 )
		TppPadOperatorUtility.RegisterButtonAssign	( "PL_EVADE_ACTION",	fox.PAD_Y )
	end
	
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_CQC_KNIFE_KILL",	fox.PAD_A )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_STOCK",			fox.PAD_R3 )

	TppPadOperatorUtility.RegisterButtonAssign	( "PL_DASH", 			fox.PAD_L3 )

	-- 馬(PadTppPlayerRideHorseActions)
	TppPadOperatorUtility.RegisterButtonAssign	( "HORSE_PAD_ACCEL",	fox.PAD_A )
	TppPadOperatorUtility.RegisterButtonAssign	( "HORSE_PAD_CLING",	fox.PAD_B )
	
	-- ストライカー
	TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_PAD_RIDEON",		fox.PAD_A )
	TppPadOperatorUtility.RegisterButtonAssign( "VEHICLE_PAD_RIDEOFF",		fox.PAD_A )

	-- トリガー操作
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_CALL",			sysL1 )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_SUB_CAMERA",		sysR1 )

	TppPadOperatorUtility.RegisterButtonAssign	( "PL_HOLD",			sysL2 )
	TppPadOperatorUtility.RegisterButtonAssign	( "PL_SHOT",			sysR2 )

	TppPadOperatorUtility.RegisterButtonAssign	( "PL_CQC_INTERROGATE",	sysL1 )

end,

-- SquadLocater以下のEnemyのenable/disableを切り替える
-- EnemyUtilityにあるべき？
SetSquadEnableState = function( locator, enableFlag )
	if ( locator:IsKindOf( "ChCharacterLocator" ) == false ) then
		Fox.Log("arg1 is not a ChCharacterLocator")
		return false
	end
	local charaObj = locator.charaObj
	if ( Entity.IsNull(charaObj) ) then
		Fox.Log("charaObj is null")
		-- Unreallize状態？
		return true
	end
	if ( charaObj:IsKindOf( "AiSquadObject" ) == false ) then
		Fox.Log("not a AiSquadObject")
		return false
	end
	charaObj:SetMembersEnable( enableFlag )
	return true
end


} -- TppPlayerPadConfig

