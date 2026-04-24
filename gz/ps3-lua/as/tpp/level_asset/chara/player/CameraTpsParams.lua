--------------------------------------------------------------------------------
--! @file	CameraTpsParams.lua
--! @brief	TPSカメラ用のパラメータ設定
--------------------------------------------------------------------------------

CameraTpsParams = {

-- パラメータ定義
Definitions = {

	-- 設定可能なアクション名
	ActionList = {

		-- 立ち
		"ACT_Stand",
		-- しゃがみ
		"ACT_Squat",
		-- 匍匐
		"ACT_Crawl",
		-- 立ち(設置武器)
		"ACT_PlaceHoldStand",
		-- しゃがみ(設置武器)
		"ACT_PlaceHoldSquat",
		-- 立ち、しゃがみ設置(設置武器)
		"ACT_PlaceHoldPut",
		-- 匍匐(設置武器)
		"ACT_PlaceHoldCrawl",
		-- 馬
		"ACT_HorseDefault",
		-- ストライカー主砲
		"ACT_StrykerDefault",
		-- ストライカー副砲
		"ACT_StrykerSubWeapon",
		-- CQC
		"ACT_CqcDefault",
		-- しゃがみCQC
		"ACT_CqcSquat",
		-- 対空機関砲（銃座の特殊タイプ）
		"ACT_AntiAircraftGun",
		-- 銃座
		"ACT_Turret",
		-- サーチライト
		"ACT_SearchLight",
		-- 一般車両
		"ACT_VehicleDefault",
		-- 軽装車両
		"ACT_LightVehicleDefault",
		-- トラック
		"ACT_TruckDefault",
		-- ヘリ
		"ACT_HeliDefault",
		-- 馬(ヴォルギンチェイス)
		"ACT_HorseVolginChase",
		-- 立ち担ぎ
		"ACT_CarryStand",
		-- しゃがみ担ぎ
		"ACT_CarrySquat",

		-- Behind投擲
		"ACT_BehindStandPeepThrow",
		"ACT_BehindSquatPeepThrow",		
	},

},


-- 基本パラメータ（アクション等によって変わるもの）
BasicParams = {

	-- デフォルト値
	DefaultParam = {

		-- カメラ距離（ m ）
		distance				= 1.2,

		-- カメラオフセット（ m ）
		offset				= Vector3( -0.5, 0.76, 0.0 ),

		-- 下方向限界角（ 度 ）
		rotXMin				= -70,

		-- 上方向限界角（ 度 ）
		rotXMax				= 55,

		-- 縦回転速度（ 度/秒 ）
		rotVelMaxX			= 45,

		-- 横回転速度（ 度/秒 ）
		rotVelMaxY			= 90,

		-- 回転加速度（Max速度までにかかるフレーム数）
		rotVelAccelFrame		= 12,

		-- 回転減速度（Max速度から停止までにかかるフレーム数）
		rotVelFadeFrame		= 1,

		-- 画角
		focalLength			= 22,

		-- オフセット補間時間（ 秒 ）
		offsetInterpTime		= 0.315,

		-- カメラ距離補間時間（ 秒 ）
		distanceInterpTime	= 0.15,

		-- 画角補間時間（ 秒 ）
		focalLengthInterpTime	= 0.15,

		-- カメラの基準位置設定タイプ
		attachType			= "None",

		-- AutoFocusつきかどうか
		enableAutoFocus		=  false,

		-- レンズ口径（ 1 ～32 ）
--		aperture				= 1.875,
		aperture				= 100,
		
		-- レンズ口径補間時間（ 秒 ）
		apertureInterpTime		= 0.23,

		-- 被写界深度の手前ボケをキャンセルする
		disableFrontBokeh			= true,

		-- 特殊プリセット用デフォルト値
		PresetDefault = {
			-- 病院エントランス
			{
				-- プリセット名
				presetName	= "hospital_entrance",
			},
		},

		-------------------------------------------
		-- 以下TPSカメラ特有（ ※ プリセットは未対応 ）
		-------------------------------------------

		-- ロックオン有効
		enableLockOn			= true,

		-- サイティング補助有効
		enableAssist			= true,

		-- サイティング補助の有効範囲（ 縦回転角度差 ）（ 度 ）
		assistRangeAngleXMax	= 16,

		-- サイティング補助の有効範囲（ 横回転角度差 ）（ 度 ）
		assistRangeAngleYMax	= 20,

		-- サイティング補助の強さ [ 0, 1 )
		assistForce			= 0.95,

	}, -- DefaultParam


	-- アクション毎のパラメータ
	Params = {

	----------------------------------------
	-- 通常用
	----------------------------------------

		-- 立ち（ 通常 ）
		{
			actionName	= "ACT_Stand",

		},

		-- しゃがみ（ 通常 ）
		{
			actionName	= "ACT_Squat",

			-- カメラオフセット（ m ）
			offset				= Vector3( -0.5, 0.4, 0.0 ),
		},

		-- 匍匐（ 通常 ）
		{
			actionName	= "ACT_Crawl",

			-- カメラ距離（ m ）
			distance				= 1.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.4, 0.15, 0.0 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -40,
			-- 上方向限界角（ 度 ）
			rotXMax				= 40,
		},
		-- 立ち（設置武器 ）
		{
			actionName	= "ACT_PlaceHoldStand",
			distance	= 3.1,
			offset				= Vector3( -0.5, 0.65, 0.0 ),
		},

		-- しゃがみ（設置武器 ）
		{
			actionName	= "ACT_PlaceHoldSquat",
			distance	= 2.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.5, 0.3, 0.0 ),
		},

		-- 立ちしゃがみ設置（設置武器 ）
		{
			actionName	= "ACT_PlaceHoldPut",
			distance	= 2.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.5, -0.1, 0.0 ),
		},

		-- 匍匐（設置武器 ）
		{
			actionName	= "ACT_PlaceHoldCrawl",

			-- カメラ距離（ m ）
			distance				= 1.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.4, 0.15, 0.0 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -40,
			-- 上方向限界角（ 度 ）
			rotXMax				= 40,
		},
		
		-- 馬（ 通常 ）
		{
			actionName	= "ACT_HorseDefault",

			-- カメラオフセット（ m ）
			offset				= Vector3( -0.4, 0.4, 0.0 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -40,
			-- 上方向限界角（ 度 ）
			rotXMax				= 40,
		},

		-- ストライカー主砲（ 通常 ）
		{
			actionName	= "ACT_StrykerDefault",

			-- カメラ距離（ m ）
			distance				= 5.0,
			-- カメラオフセット（ m ）
			offset				= Vector3( -1.5, 1.0, 0.0 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -13.25,
			-- 上方向限界角（ 度 ）
			rotXMax				= 15,
			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 35,
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 43,
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 20,
			-- カメラの基準位置設定タイプ
			attachType			= "Manual",
			-- ロックオン有効
			enableLockOn			= false,
			-- サイティング補助有効
			enableAssist			= false,
		},

		-- ストライカー副砲（ 通常 ）
		{
			actionName	= "ACT_StrykerSubWeapon",

			-- カメラ距離（ m ）
			distance				= 1.0,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.5, 1.25, 0.0 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -30,
			-- 上方向限界角（ 度 ）
			rotXMax				= 30,
			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 55,
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 75,
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 20,
			-- カメラの基準位置設定タイプ
			attachType			= "Manual",
			-- ロックオン有効
			enableLockOn			= false,
			-- サイティング補助有効
			enableAssist			= false,
		},

		-- 一般車両
		{
			actionName	= "ACT_VehicleDefault",

		},

		-- 軽装車両
		{
			actionName	= "ACT_LightVehicleDefault",
			-- カメラ距離（ m ）
			distance				= 2.75,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.625, 0.75, 0.0 ),

		},

		-- トラック
		{
			actionName	= "ACT_TruckDefault",
			-- カメラ距離（ m ）
			distance				= 4.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( -1.25, 0.75, 0.0 ),
		},

		-- CQC（ 通常 ）
		{
			actionName	= "ACT_CqcDefault",
			-- 上方向限界角（ 度 ）
			rotXMax				= 25,
		},

		-- しゃがみCQC（ 通常 ）
		{
			actionName	= "ACT_CqcSquat",

			-- カメラオフセット（ m ）
			offset				= Vector3( -0.5, 0.2, 0.0 ),
			-- 上方向限界角（ 度 ）
			rotXMax				= 20,
		},

		-- 対空機関砲（ 通常 ）
		{
			actionName	= "ACT_AntiAircraftGun",

			-- カメラの基準位置設定タイプ(回転軸の中心にアタッチ)
			attachType			= "Manual",
			-- カメラ距離（ m ）
			distance				= 1.45,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.35, 0.335 ,-0.42 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -20,
			-- 上方向限界角（ 度 ）
			rotXMax				= 20,
			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 46,
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 64,
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 40,
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 16.5,
			-- ロックオン有効
			enableLockOn			= false,
			-- サイティング補助有効
			enableAssist			= false,
			-- 画角
			focalLength			= 22,
		},

		-- 銃座（ 通常 ）
		{
			actionName	= "ACT_Turret",

			-- カメラ距離（ m ）
			distance				= 1.4,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.45, 0.8, 0.0 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -20,
			-- 上方向限界角（ 度 ）
			rotXMax				= 20,
			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 60,
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 110,
			-- ロックオン有効
			enableLockOn			= false,
			-- サイティング補助有効
			enableAssist			= false,
			-- 画角
			focalLength			= 19,
		},

		-- サーチライト
		{
			actionName	= "ACT_SearchLight",

			-- カメラ距離（ m ）
			distance				= 1.0,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.5, 1.60, 0.0 ),
			-- カメラの基準位置設定タイプ
			attachType			= "GlobalMotionPoint",
			attachPointName		= "MTP_GLOBAL_C",
		},
		
		-- ヘリ
		{
			actionName	= "ACT_HeliDefault",

			-- カメラの基準位置設定タイプ
			attachType			= "Manual",

			-- カメラ距離（ m ）
			distance			= 0.75,

			-- カメラオフセット（ m ）
			offset				= Vector3( -0.35, 0.0, 0.0 ),

			-- 上方向限界角（ 度 ）
			rotXMin			= -20,
			-- 下方向限界角（ 度 ）
			rotXMax			= 50,
			-- 右方向限界角（ 度 ）
			rotYMin			= -97,
			-- 左方向限界角（ 度 ）
			rotYMax			= 97,
		},

		-- 立ち担ぎ
		{
			actionName	= "ACT_CarryStand",

			distance	= 1.5,

			-- カメラオフセット（ m ）
			offset				= Vector3( -0.75, 0.76, 0.0 ),
		},

		-- しゃがみ担ぎ
		{
			actionName	= "ACT_CarrySquat",

			distance	= 1.5,
			
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.75, 0.4, 0.0 ),
		},

		-- Behind投擲
		{
			actionName	= "ACT_BehindStandPeepThrow",
			distance	= 2.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( -1.25, 0.75, 0.0 ),
		},
		{
			actionName	= "ACT_BehindSquatPeepThrow",
			distance	= 2.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( -1.25, 0.4, 0.0 ),
		},
		
	----------------------------------------
	-- 特殊用
	----------------------------------------

		-- 馬（ VolginChase ）
		{
			actionName	= "ACT_HorseVolginChase",

			-- プリセット名
			presetName	= "hospital_entrance",

			-- カメラ距離（ m ）
			distance				= 1.2,
			-- カメラオフセット（ m ）
			-- offset				= Vector3( -0.7, 0.15, 0.0 ),
			offset				= Vector3( -0.425, 0.05, -0.10 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -20,
			-- 上方向限界角（ 度 ）
			rotXMax				= 30,
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 1.5,
			-- 画角
			focalLength			= 25,

			-- AutoFocusつきかどうか
			enableAutoFocus		=  false,
			-- 焦点距離
			focusDistance 		= 4.0,
			-- レンズ口径（ 1 ～32 ）
			aperture			= 1.5,
			-- シャッタースピード
			shutterSpeed	=	0.04,
		},
		
	}, -- Params

}, -- BasicParams


-- アクション等に依存しない基本的に固定のパラメータ
FixedParams = {

	-- デフォルト値
	DefaultParam = {

		-- 右スティックの遊び（ 0 ～ 1 ）
		stickMargin				= ( 24 / 255 ),

		-- 右スティックの別の軸入力量に応じた遊び率（ 0 ～ 1 ）
		stickMarginByAnotherAxis	= 0.15,

		-- カメラ切り替え時のカメラ距離補間時間（ 秒 ）
		distanceInterpTimeAtStart	= 0.16,

		-- カメラ切り替え時のオフセット補間時間（ 秒 ）
		offsetInterpTimeAtStart	= 0.15,

		-- 基準点補間時間（ 秒 ）
		basePosInterpTime			= 0.3,

		-- アタリチェックによる位置補正の補間時間（ 秒 ）
		collisionInterpTime		= 0.15,

		-- 補間用ベジエ曲線の制御時間
		bezierControlTime			= 0.4,

		-- 補間用ベジエ曲線の制御レート
		bezierControlRate			= 0.78,


		-------------------------------------------
		-- 以下TPSカメラ特有
		-------------------------------------------

		-- ストックチェンジのカメラ補間時間（ 秒 ）
		stockChangeInterpTime			= 0.2,

		-- ロックオンの補間時間（ 秒 ）
		lockOnInterpTime				= 0.1,

		-- ロックオン後サイティング補助を有効にし続ける時間（ 秒 ）
		lockOnAssistKeepTime			= 0.4,

		-- 射撃ブレによるカメラ回転の補間時間（ 秒 ）
		wobblingInterpTime			= 0.1,

		-- ターゲット固定でのカメラ回転を行える、ターゲットまでの最低距離（ m ）
		fixedAttackTargetLimitDist		= 2.0,

		-- ストックチェンジ時にターゲット固定でのカメラ回転を行える、ターゲットまでの最低距離（ m ）
		fixedAttackTargetLimitDistForStockChange		= 5.0,

		-- サイティング補助有効範囲の遊び率（ 1.0 ～ ）
		assistRangeAngleMaxExcessRate	= 1.05,

		-- サイティング補助のカメラ速度補間レート [ 0, 1 )
		assistInterpRate				= 0.00,

		-- 手動回転量に対するサイティング補助の強さ最低値 [ 0, 1 ]
		assistForceForManualRotaionMin	= 0.7,

		-- 手動回転量に対するサイティング補助の強さ最大値 [ 0, 1 ]
		assistForceForManualRotaionMax	= 0.85,

		-- 移動による回転量に対するサイティング補助の強さ最大値 [ 0, 1 ]
		assistForceForMove		= 0.80,

		-- ロックオン後のサイティング補助有効期間中の補助の強さ [ 0, 1 ]
		assistForceInLockOnKeeging		= 1.0,

	},

}, -- FixedParams


-- カメラ揺れパラメータ
ShakeParams = {

	-- デフォルト値
	DefaultParam = {

		-- X方向揺れ幅 ( m )
		rangePosX	= 0,

		-- Y方向揺れ幅 ( m )
		rangePosY	= 0,

		-- Z方向揺れ幅 ( m )
		rangePosZ	= 0,

		-- X回転揺れ幅 （ 度 ）
		rangeRotX	= 0.0,

		-- Y回転揺れ幅 （ 度 ）
		rangeRotY	= 0.0,

		-- Z回転揺れ幅 （ 度 ）
		rangeRotZ	= 0.0,

		-- 位置揺れ周期 （ 秒 ）
		cyclePos		= 0,

		-- 回転揺れ周期 （ 秒 ）
		cycleRot		= 0,

		-- 補間時間
		interpTime	= 0,

		-- 速度変化に対応するか
		speedMode	= false,

	},

	Params = {

	},

}, -- ShakeParams

} -- CameraTpsParams

