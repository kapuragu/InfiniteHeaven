--------------------------------------------------------------------------------
--! @file	TppPadOperatorUtility.lua
--! @brief	パッド関連のユーティリティ Lua 関数群
--------------------------------------------------------------------------------

TppPadOperatorUtility = {

--------------------------------------------------------------------------------
-- マスク設定サンプル 1（アサイン名指定）
--	TppPadOperatorUtility.RegisterPlayerMaskSettings{

--		registerName = "登録名",
--			-- マスク設定の登録名（ユニーク）

--		masks = {

--			exceptSetting	= true,
--				-- true		-> 指定したものだけ入力有効（マスクOFF）
--				-- false	-> 指定したものだけ入力無効（マスクON）

--			buttonNames		= { "PL_ACTION", "PL_DASH", },
--				-- ボタンアサイン名の指定

--			stickNames		= { "PL_STICK_L", "PL_STICK_R", },
--				-- スティックアサイン名の指定

--			triggerNames	= { "PL_CQC", },
--				-- トリガーアサイン名の指定

--		},
--	}

-- マスク設定サンプル 2（カテゴリ指定）
--	TppPadOperatorUtility.RegisterPlayerMaskSettings{

--		registerName = "登録名",
--			-- マスク設定の登録名（ユニーク）

--		masks = {

--			exceptSetting	= false,
--				-- true		-> 指定したものだけ入力有効（マスクOFF）
--				-- false	-> 指定したものだけ入力無効（マスクON）

--			categories		= { "Action", "Camera", },
--				-- アサイン時に一緒に登録したカテゴリ名の指定

--		},
--	}

--------------------------------------------------------------------------------
Init = function()

	-- マスク設定情報登録

	-- MB端末起動中（トップメニュー）
	TppPadOperatorUtility.RegisterPlayerMaskSettings{
		registerName = "MB_TopMenu",
		masks = {
			exceptSetting	= true,
			buttonNames		= { "MB_DEVICE", "PL_DASH", "PL_SQUAT" },
			stickNames		= { "PL_STICK_L", "PL_STICK_R", },
		},
	}

	-- MB端末起動中（端末操作中）
	TppPadOperatorUtility.RegisterPlayerMaskSettings{
		registerName = "MB_MenuOperation",
		masks = {
			exceptSetting	= true,
			buttonNames		= { "MB_DEVICE", },
			--stickNames		= { "PL_STICK_R", },
		},
	}

	-- MB端末以外操作不能にする（MB_MenuOperationとの重ね掛けあり）
	TppPadOperatorUtility.RegisterPlayerMaskSettings{
		registerName = "MB_OnlyMode",
		masks = {
			exceptSetting	= true,
			buttonNames		= { "MB_DEVICE", },
		},
	}

	-- MB端末開けない,閉じれない
	TppPadOperatorUtility.RegisterPlayerMaskSettings{
		registerName = "MB_Disable",
		masks = {
			exceptSetting	= false,
			buttonNames		= { "MB_DEVICE", },
		},
	}

	-- 全パッド封じ共通
	TppPadOperatorUtility.RegisterPlayerMaskSettings {
		registerName = "All",
		masks = {
			exceptSetting = true,
			buttonNames		= {},
			stickNames		= {},
		},
	}


	-- 病院アクションの待ち待機
	-- 病院ベッド上での左スティック封じにも使用
	TppPadOperatorUtility.RegisterPlayerMaskSettings{
		registerName = "Hospital_Wait",
		masks = {
			exceptSetting	= false,
			buttonNames		= { "PL_HOLD" },
			stickNames		= { "PL_STICK_L", },
		},
	}

	-- 病院ベッド上での左スティック封じ(Demo用)
	TppPadOperatorUtility.RegisterPlayerMaskSettings{
		registerName = "Hospital_DisableLStick_DEMO",
		masks = {
			exceptSetting	= false,
			stickNames		= { "PL_STICK_L", },
		},
	}

	-- 病院ベッド上での右スティックカメラ封じ
	TppPadOperatorUtility.RegisterPlayerMaskSettings{
		registerName = "Hospital_DisableRStick",
		masks = {
			exceptSetting	= false,
			stickNames		= { "PL_STICK_R", },
		},
	}

	-- 病院専用：イシュメールの「待て」アクションを受けての待ち待機
	TppPadOperatorUtility.RegisterPlayerMaskSettings{
		registerName = "Hospital_IshmaelStopSign",
		masks = {
			exceptSetting	= false,
			stickNames		= { "PL_STICK_L", },		-- 移動を封じる
			buttonNames		= { "PL_HOLD",				-- 銃構えを封じる
							  },
		},
	}

	-- 主観ボタン封じ用
	TppPadOperatorUtility.RegisterPlayerMaskSettings {
		registerName = "CannotSubjectiveCamera",
		masks = {
			exceptSetting = false,
			buttonNames = { "PL_SUB_CAMERA" },
		},
	}

	-- カタコンカメラ時の制限
	TppPadOperatorUtility.RegisterPlayerMaskSettings{
		registerName = "ConstCamera",
		masks = {
			exceptSetting	= true,
			buttonNames		= {},
			stickNames		= {},
		},
	}

	-- 双眼鏡Tutorial用（カズ救出）
	TppPadOperatorUtility.RegisterPlayerMaskSettings {
		registerName = "ScopeTutorial",
		masks = {
			exceptSetting	= true,
			buttonNames		= { "PL_SUB_CAMERA", "PL_CALL", "PL_ZOOM_CHANGE",
								"PL_ZOOM_IN", "PL_ZOOM_OUT" },
			stickNames		= { "PL_STICK_R", },
		},
	}

	-- プリセット無線起動中
	TppPadOperatorUtility.RegisterPlayerMaskSettings{
		registerName = "OpenPresetRadio",
		masks = {
			exceptSetting	= false,
			--要はプリセット無線とバッティングするボタンをマスクしたい
			buttonNames		= { "PL_SQUAT",
								"PL_ACTION",
								"PL_RELOAD",
								"PL_PICKUP_WEAPON"
							},
		},
	}

	-- カメラだけ動かせる
	TppPadOperatorUtility.RegisterPlayerMaskSettings{
		registerName = "CameraOnly",
		masks = {
			exceptSetting	= true,
			buttonNames		= {},
			stickNames		= {"PL_STICK_R"},
		},
	}
end,

SetStickMapping = function( leftRate, rightRate )
	local players = Ch.FindCharacters("Player")
	local player = players.array[1]
	local playerPadOperator = player:FindPluginByName( "PadOperator" )
	playerPadOperator.leftStickMappingRate = leftRate
	playerPadOperator.rightStickMappingRate = rightRate
	Fox.Log("StickMapping Left " .. playerPadOperator.leftStickMappingRate .. " Right " .. playerPadOperator.rightStickMappingRate )
end,
SetLeftStickMapping = function( leftRate )
	local players = Ch.FindCharacters("Player")
	local player = players.array[1]
	local playerPadOperator = player:FindPluginByName( "PadOperator" )
	playerPadOperator.leftStickMappingRate = leftRate
	Fox.Log("StickMapping Left " .. playerPadOperator.leftStickMappingRate )
end,

} -- TppPadOperatorUtility

