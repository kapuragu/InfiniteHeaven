--------------------------------------------------------------------------------
--! @file	CameraSubjectiveParams.lua
--! @brief	主観カメラ用のパラメータ設定
--------------------------------------------------------------------------------

CameraSubjectiveParams = {

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
		-- 馬
		"ACT_HorseDefault",
		-- ストライカー主砲
		"ACT_StrykerDefault",
		-- ストライカー副砲
		"ACT_StrykerSubWeapon",
		-- CQC
		"ACT_CqcDefault",
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

		-- マザベ端末
		"ACT_MBTerminal",
		"ACT_MBTerminalCrawl",
		"ACT_MBTerminalNormalVehicle",
		"ACT_MBTerminalCombatVehicle",
		"ACT_MBTerminalHeli",

		-- 冒頭病院ベッド主観
		"ACT_OnBed",
		"ACT_OnBed1_2_Shake1",
		"ACT_OnBed1_2_Shake2",
		"ACT_OnBed1_2_Shake3",
		"ACT_OnBed1_2_DoctorInterview",
		-- 冒頭病院ベッド主観(上半身起きている)
		"ACT_OnBed2",
		-- 冒頭病院ベッド下主観
		"ACT_UnderBed",
		"ACT_UnderBedRight",
		"ACT_UnderBedLeft",
		"ACT_UnderBedMove",
		-- 冒頭病院クワイエット射撃TPS
		"ACT_ShootQuiet",
		-- 冒頭病院ヴォルギン射撃TPS
		"ACT_ShootVolgin",
		-- 虐殺廊下
		"ACT_Massacre",
	},
	
},


-- 基本パラメータ（アクション等によって変わるもの）
BasicParams = {

	-- デフォルト値
	DefaultParam = {
		
		-- カメラ距離（ m ）
		distance				= 0,
		
		-- カメラオフセット（ m ）
		offset				= Vector3( 0.0, 0.0, 0.0 ),
		
		-- 上方向限界角（ 度 ）
		rotXMin				= -70,
		
		-- 下方向限界角（ 度 ）
		rotXMax				= 55,
		
		-- 縦回転速度（ 度/秒 ）
		rotVelMaxX			= 45.0,
		
		-- 横回転速度（ 度/秒 ）
		rotVelMaxY			= 90,
		
		-- 回転加速度（Max速度までにかかるフレーム数）
		rotVelAccelFrame		= 12,
		
		-- 回転減速度（Max速度から停止までにかかるフレーム数）
		rotVelFadeFrame		= 1,
		
		-- 画角
		focalLength			= 36,
		
		-- オフセット補間時間（ 秒 ）
		offsetInterpTime		= 0.15,
		
		-- カメラ距離補間時間（ 秒 ）
		distanceInterpTime	= 0.15,
		
		-- 画角補間時間（ 秒 ）
		focalLengthInterpTime	= 0.15,
		
		-- ピント補間時間（ 秒 ）
		focusDistanceInterpTime	= 0.67,
		
		-- カメラの基準位置設定タイプ
		attachType			= "Head",

		-- AutoFocusつきかどうか
		enableAutoFocus		=  true,
		
		-- レンズ口径（ 1 ～32 ）
		aperture					= 100,
--		aperture					= 1.875,
		
		-- レンズ口径補間時間（ 秒 ）
		apertureInterpTime		= 0.23,

		-- 被写界深度の手前ボケをキャンセルする
		disableFrontBokeh			= true,

		-------------------------------------------
		-- 以下TPSカメラ特有（ ※ プリセットは未対応 ）
		-------------------------------------------

		-- ロックオン有効
		enableLockOn			= true,
		
		-- サイティング補助有効
		enableAssist			= false,
		
		-- サイティング補助の有効範囲（ 縦回転角度差 ）（ 度 ）
		assistRangeAngleXMax	= 16,
		
		-- サイティング補助の有効範囲（ 横回転角度差 ）（ 度 ）
		assistRangeAngleYMax	= 20,
		
		-- サイティング補助の強さ [ 0, 1 )
		assistForce			= 0.95,

		-- 特殊プリセット用デフォルト値
		PresetDefault = {
			-- 病院用デフォルト値 ※VGA専用。病院全体に影響しているので撮影が終わったら削除する
			{
				-- プリセット名
				presetName	= "hospital_vga",
				offset = Vector3( 0.0, 0.1, 0.5 ),
			},
			
		},
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

		},

		-- 匍匐（ 通常 ）
		{
			actionName	= "ACT_Crawl",
			offset		= Vector3( 0.0, 0.04, 0.0 ),
			rotXMin		= -32,
			rotXMax		= 27,
		},
		
		-- 馬（ 通常 ）
		{
			actionName	= "ACT_HorseDefault",
			
		},
		
		-- ストライカー主砲（ 通常 ）
		{
			actionName	= "ACT_StrykerDefault",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.1, 0.65, 0.9 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -13.25,
			-- 上方向限界角（ 度 ）
			rotXMax				= 15,
			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 24,
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 28,
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 20,
			-- 画角
			focalLength			= 36,
			-- カメラの基準位置設定タイプ
			-- 主観テストのときはHeadにしたらよいだろう
			attachType			= "Manual",
			-- ロックオン有効
			enableLockOn			= false,
			-- サイティング補助有効
			enableAssist			= false,

			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.0,
		},
		
		-- ストライカー副砲（ 通常 ）
		{
			actionName	= "ACT_StrykerSubWeapon",
			
			-- カメラ距離（ m ）
			distance				= 1.0,
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 1.02, 0.5 ),
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
			-- 画角
			focalLength			= 21,
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
			
			offset			= Vector3( 0.0, 0.1, 0.0 ),
			rotXMin			= -60,
			rotXMax			= 12,
			rotYMin			= -80,
			rotYMax			= 80,
		},

		-- 軽装車両
		{
			actionName	= "ACT_LightVehicleDefault",
			
			offset			= Vector3( 0.0, 0.1, 0.0 ),
			rotXMin			= -60,
			rotXMax			= 12,
			rotYMin			= -80,
			rotYMax			= 80,
			-- 画角
			focalLength			= 26,
		},

		-- トラック
		{
			actionName	= "ACT_TruckDefault",
			
			offset			= Vector3( 0.0, 0.1, 0.0 ),
			rotXMin			= -20,
			rotXMax			= 3,
			rotYMin			= -80,
			rotYMax			= 80,
			-- 画角
			focalLength			= 26,
		},

		-- ヘリ
		{
			actionName	= "ACT_HeliDefault",

			-- カメラの基準位置設定タイプ
			attachType	= "Manual",

			offset			= Vector3( 0.0, -0.05, 0.0 ),
			-- 上方向限界角（ 度 ）
			rotXMin			= -20,
			-- 下方向限界角（ 度 ）
			rotXMax			= 50,
			-- 右方向限界角（ 度 ）
			rotYMin			= -90,
			-- 左方向限界角（ 度 ）
			rotYMax			= 90,
		},

		-- マザベ端末
		{
			actionName = "ACT_MBTerminal",
			-- 上方向限界角（ 度 ）
			rotXMin			= -20,
			-- 下方向限界角（ 度 ）
			rotXMax			= 50,
		},
		{
			actionName = "ACT_MBTerminalCrawl",
			-- 上方向限界角（ 度 ）
			rotXMin			= -20,
			-- 下方向限界角（ 度 ）
			rotXMax			= 20,
		},

		-- マザベ端末（一般車両）
		{
			actionName	= "ACT_MBTerminalNormalVehicle",
			
			offset			= Vector3( 0.0, 0.1, 0.0 ),
			rotXMin			= -14,
			rotXMax			= 3,
			rotYMin			= -80,
			rotYMax			= 80,
			-- 画角
			focalLength			= 26,
		},
		
		-- マザベ端末（戦闘車両）
		{
			actionName	= "ACT_MBTerminalCombatVehicle",
			
			offset			= Vector3( 0.0, 0.1, 0.0 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -30,
			-- 上方向限界角（ 度 ）
			rotXMax				= 15,
			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 35,
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 43,
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 5,
			-- 画角
			focalLength			= 26,
		},

		-- マザベ端末（ヘリ）
		{
			actionName	= "ACT_MBTerminalHeli",

			-- カメラの基準位置設定タイプ
			attachType	= "Manual",

			-- 上方向限界角（ 度 ）
			rotXMin			= -20,
			-- 下方向限界角（ 度 ）
			rotXMax			= 20,
			-- 右方向限界角（ 度 ）
			rotYMin			= -40,
			-- 左方向限界角（ 度 ）
			rotYMax			= 40,
		},
		
		-- CQC（ 通常 ）
		{
			actionName	= "ACT_CqcDefault",
			
		},

		-- 対空機関砲（ 通常 ）
		{
			actionName	= "ACT_AntiAircraftGun",
			
			-- カメラの基準位置設定タイプ
			attachType			= "Manual",

			-- カメラ距離（ m ）
			distance				= 0.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.0 ),
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
		},

		-- 銃座（ 通常 ）
		{
			actionName	= "ACT_Turret",
			
			-- カメラ距離（ m ）
			distance				= 0.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.1, 0.5 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -20,
			-- 上方向限界角（ 度 ）
			rotXMax				= 20,
			-- 右方向限界角（ 度 ）
			--rotYMin				= -45,
			-- 左方向限界角（ 度 ）
			--rotYMax				= 45,
			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 60,
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 110,
			-- ロックオン有効
			enableLockOn			= false,
			-- サイティング補助有効
			enableAssist			= false, 
		},
		
		-- サーチライト
		{
			actionName	= "ACT_SearchLight",
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 1.70, 0 ),
			-- カメラの基準位置設定タイプ
			attachType			= "GlobalMotionPoint",
			attachPointName		= "MTP_GLOBAL_C",
			
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 40,
		},
		
		-- ベッド(仰向け第1段階)
		{
			actionName = "ACT_OnBed",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.0 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -35,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 13,
		
			-- 横方向限界角（ 度 ）
			rotYMin				= -50,
		
			-- 横限界角（ 度 ）
			rotYMax				= 45,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 10,
		
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 10,
		
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 40,
		
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 20,
		
			-- 画角
			focalLength			= 18,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- 回転基準Ｘ角度
			baseAxisRotX		=	-25,
			
			-- カメラの基準位置設定タイプ
			attachType			= "GlobalMotionPoint",
			attachPointName		= "MTP_GLOBAL_A",

			-- AutoFocus
			enableAutoFocus	= false,
		},

		-- ベッド(仰向け第2段階/カメラ揺れ衰弱)
		{
			actionName = "ACT_OnBed1_2_Shake1",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.0 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -35,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 13,
		
			-- 横方向限界角（ 度 ）
			rotYMin				= -70,
		
			-- 横限界角（ 度 ）
			rotYMax				= 50,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 25,
		
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 25,
		
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 40,
		
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 20,
		
			-- 画角
			focalLength			= 18,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- 回転基準Ｘ角度
			baseAxisRotX		=	-25,
			
			-- カメラの基準位置設定タイプ
			attachType			= "GlobalMotionPoint",
			attachPointName		= "MTP_GLOBAL_A",
		},		

		-- ベッド(仰向け第2段階/カメラ揺れ少し元気)
		{
			actionName = "ACT_OnBed1_2_Shake2",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.0 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -35,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 13,
		
			-- 横方向限界角（ 度 ）
			rotYMin				= -70,
		
			-- 横限界角（ 度 ）
			rotYMax				= 50,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 25,
		
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 25,
		
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 40,
		
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 20,
		
			-- 画角
			focalLength			= 18,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- 回転基準Ｘ角度
			baseAxisRotX		=	-25,
			
			-- カメラの基準位置設定タイプ
			--attachType			= "Head",
			attachType			= "GlobalMotionPoint",
			attachPointName		= "MTP_GLOBAL_A",

			-- AutoFocus
			enableAutoFocus	= false,			
		},

		-- ベッド(仰向け第2段階/カメラ揺れなし)
		{
			actionName = "ACT_OnBed1_2_Shake3",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.0 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -35,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 13,
		
			-- 横方向限界角（ 度 ）
			rotYMin				= -70,
		
			-- 横限界角（ 度 ）
			rotYMax				= 50,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 25,
		
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 25,
		
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 40,
		
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 20,
		
			-- 画角
			focalLength			= 18,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- 回転基準Ｘ角度
			baseAxisRotX		=	-25,
			
			-- カメラの基準位置設定タイプ
			--attachType			= "Head",
			attachType			= "GlobalMotionPoint",
			attachPointName		= "MTP_GLOBAL_A",

			-- AutoFocus
			enableAutoFocus	= false,			
		},

		-- ベッド(仰向け第2段階/医者問答中)
		{
			actionName = "ACT_OnBed1_2_DoctorInterview",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.0 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -35,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 13,
		
			-- 横方向限界角（ 度 ）
			rotYMin				= -40,
		
			-- 横限界角（ 度 ）
			rotYMax				= 2,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 25,
		
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 25,
		
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 40,
		
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 20,
		
			-- 画角
			focalLength			= 18,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- 回転基準Ｘ角度
			baseAxisRotX		=	-25,
			
			-- カメラの基準位置設定タイプ
			attachType			= "GlobalMotionPoint",
			attachPointName		= "MTP_GLOBAL_A",

			-- AutoFocus
			enableAutoFocus	= false,			
		},
		
		-- ベッド２(上半身を起こした状態)
		{
			actionName = "ACT_OnBed2",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.0 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -60,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 29,
		
			-- 横方向限界角（ 度 ）
			rotYMin				= -89,
		
			-- 横限界角（ 度 ）
			rotYMax				= 89,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 45,
		
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 45,
		
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 30,
		
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 10,
		
			-- 画角
			focalLength			= 23,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,

			-- 回転基準Ｘ角度
			baseAxisRotX		=	-10,
			
			-- カメラの基準位置設定タイプ
			--attachType			= "Head",
			attachType			= "GlobalMotionPoint",
			attachPointName		= "MTP_GLOBAL_A",

			-- AutoFocus
			enableAutoFocus	= false,			
		},

		-- ベッド下
		{
			actionName = "ACT_UnderBed",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.6 ),
--			offset				= Vector3( 0.0, 0.18, 0.0 ),

			-- 上方向限界角（ 度 ）
			rotXMin				= -10,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 5,


			-- 横方向限界角（ 度 ）
			rotYMin				= -65,
		
			-- 横限界角（ 度 ）
			rotYMax				= 65,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 100,
			
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 130,
			
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 20,
			
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 5,
		
			-- 画角
			focalLength			= 21,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- カメラの基準位置設定タイプ
			attachType			= "None",
			--attachType			= "Head",
			--attachType			= "GlobalMotionPoint",
			--attachPointName		= "MTP_GLOBAL_A",
		},

		-- ベッド下右
		{
			actionName = "ACT_UnderBedRight",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.4, 0.0, 0.6 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -10,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 0,

			-- 横方向限界角（ 度 ）
			rotYMin				= -65,
		
			-- 横限界角（ 度 ）
			rotYMax				= 65,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 100,
			
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 130,
			
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 20,
			
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 5,
		
			-- 画角
			focalLength			= 21,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- カメラの基準位置設定タイプ
			attachType			= "None",
			--attachType			= "Head",
			--attachType			= "GlobalMotionPoint",
			--attachPointName		= "MTP_GLOBAL_A",
		},		

		-- ベッド下左
		{
			actionName = "ACT_UnderBedLeft",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.4, 0.0, 0.6 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -10,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 0,

			-- 横方向限界角（ 度 ）
			rotYMin				= -65,
		
			-- 横限界角（ 度 ）
			rotYMax				= 80,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 100,
			
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 130,
			
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 20,
			
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 5,
		
			-- 画角
			focalLength			= 21,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- カメラの基準位置設定タイプ
			attachType			= "None",
			--attachType			= "Head",
			--attachType			= "GlobalMotionPoint",
			--attachPointName		= "MTP_GLOBAL_A",
		},

		-- ベッド下移動
		{
			actionName = "ACT_UnderBedMove",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.6 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -10,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 5,

			-- 横方向限界角（ 度 ）
			rotYMin				= -65,
		
			-- 横限界角（ 度 ）
			rotYMax				= 65,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 100,
			
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 130,
			
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 20,
			
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 5,
		
			-- 画角
			focalLength			= 21,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- カメラの基準位置設定タイプ
			--attachType			= "None",
			--attachType			= "Head",
			attachType			= "GlobalMotionPoint",
			attachPointName		= "MTP_GLOBAL_A",
		},		
		
		-- クワイエット射撃
		{
			actionName = "ACT_ShootQuiet",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.3, 0.2, -0.6 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -15,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 15,
		
			-- 横方向限界角（ 度 ）
			rotYMin				= 0,
		
			-- 横限界角（ 度 ）
			rotYMax				= 90,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 30,
		
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 30,
		
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 40,
		
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 20,
		
			-- 画角
			focalLength			= 21,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- カメラの基準位置設定タイプ
			attachType			= "Head",
			--attachType			= "GlobalMotionPoint",
			--attachPointName		= "MTP_GLOBAL_A",
		},

		-- ヴォルギン射撃
		{
			actionName = "ACT_ShootVolgin",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.3, 0.2, -0.6 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -20,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 20,
		
			-- 横方向限界角（ 度 ）
			rotYMin				= -20,
		
			-- 横限界角（ 度 ）
			rotYMax				= 20,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 60,
		
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 60,
		
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 20,
		
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 10,
		
			-- 画角
			focalLength			= 21,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- カメラの基準位置設定タイプ
			attachType			= "Head",
			--attachType			= "GlobalMotionPoint",
			--attachPointName		= "MTP_GLOBAL_A",
		},

		-- 虐殺廊下
		{
			actionName = "ACT_Massacre",

			presetName = "hospital",
			
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.0 ),
		
			-- 上方向限界角（ 度 ）
			rotXMin				= -60,
		
			-- 下方向限界角（ 度 ）
			rotXMax				= 60,
		
			-- 横方向限界角（ 度 ）
			rotYMin				= -45,
		
			-- 横限界角（ 度 ）
			rotYMax				= 45,

			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 30,
		
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 30,
		
			-- 回転加速度（Max速度までにかかるフレーム数）
			rotVelAccelFrame		= 40,
		
			-- 回転減速度（Max速度から停止までにかかるフレーム数）
			rotVelFadeFrame		= 20,
		
			-- 画角
			--focalLength			= 21,
		
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.3,
		
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 0.3,
		
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 0.3,
		
			-- カメラの基準位置設定タイプ
			--attachType			= "Manual",
			attachType			= "Head",
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
		distanceInterpTimeAtStart	= 0.0,
		
		-- カメラ切り替え時のオフセット補間時間（ 秒 ）
		offsetInterpTimeAtStart	= 0.05,
		
		-- 基準点補間時間（ 秒 ）
		basePosInterpTime			= 0.3,
		
		-- アタリチェックによる位置補正の補間時間（ 秒 ）
		collisionInterpTime		= 0.15,
		
		-- 補間用ベジエ曲線の制御時間
		bezierControlTime			= 0.4,
		
		-- 補間用ベジエ曲線の制御レート
		bezierControlRate			= 0.8,

		
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
		
		-- サイティング補助有効範囲の遊び率（ 1.0 ～ ）
		assistRangeAngleMaxExcessRate	= 1.05,

		-- サイティング補助のカメラ速度補間レート [ 0, 1 )
		assistInterpRate				= 0.00,

		-- 手動回転量に対するサイティング補助の強さ最低値 [ 0, 1 ]
		assistForceForManualRotaionMin	= 0.70,

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
		rangeRotX	= 0,
		
		-- Y回転揺れ幅 （ 度 ）
		rangeRotY	= 0,
		
		-- Z回転揺れ幅 （ 度 ）
		rangeRotZ	= 0,

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

		-- 病院ベッド(仰向け第1段階/カメラ揺れ衰弱)
		{
			name		= "ACT_OnBed",

			-- X方向揺れ幅 ( m )
			rangePosX	= 0.01,
		
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.015,

			-- Z方向揺れ幅 ( m )
			rangePosZ	= 0,
		
			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.2,
		
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.2,
		
			-- Z回転揺れ幅 （ 度 ）
			rangeRotZ	= 0,

			-- 位置揺れ周期
			cyclePos		= 4,
		
			-- 回転揺れ周期
			cycleRot		= 5,
		
			-- 補間時間
			interpTime	= 0.3,
		
			-- 速度変化に対応するか
			speedMode	= false,
		
		},

		-- 病院ベッド(仰向け第2段階/カメラ揺れ衰弱)
		{
			name		= "ACT_OnBed1_2_Shake1",

			-- X方向揺れ幅 ( m )
			rangePosX	= 0.01,
		
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.015,

			-- Z方向揺れ幅 ( m )
			rangePosZ	= 0,
		
			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.2,
		
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.2,
		
			-- Z回転揺れ幅 （ 度 ）
			rangeRotZ	= 0,

			-- 位置揺れ周期
			cyclePos		= 4,
		
			-- 回転揺れ周期
			cycleRot		= 5,
		
			-- 補間時間
			interpTime	= 0.3,
		
			-- 速度変化に対応するか
			speedMode	= false,
		
		},

		-- 病院ベッド(仰向け第2段階/カメラ揺れ少し元気)
		{
			name		= "ACT_OnBed1_2_Shake2",

			-- X方向揺れ幅 ( m )
			rangePosX	= 0.01,
		
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.015,

			-- Z方向揺れ幅 ( m )
			rangePosZ	= 0,
		
			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.15,
		
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.15,
		
			-- Z回転揺れ幅 （ 度 ）
			rangeRotZ	= 0,

			-- 位置揺れ周期
			cyclePos		= 3,
		
			-- 回転揺れ周期
			cycleRot		= 4,
		
			-- 補間時間
			interpTime	= 0.3,
		
			-- 速度変化に対応するか
			speedMode	= false,
		
		},

		-- 病院ベッド(仰向け第2段階/カメラ揺れ収まる)
		{
			name		= "ACT_OnBed1_2_Shake3",

			-- X方向揺れ幅 ( m )
			rangePosX	= 0.0,
		
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.0,

			-- Z方向揺れ幅 ( m )
			rangePosZ	= 0,
		
			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.0,
		
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.0,
		
			-- Z回転揺れ幅 （ 度 ）
			rangeRotZ	= 0,

			-- 位置揺れ周期
			cyclePos		= 0,
		
			-- 回転揺れ周期
			cycleRot		= 0,
		
			-- 補間時間
			interpTime	= 3.0,
		
			-- 速度変化に対応するか
			speedMode	= false,
		
		},		
	},

}, -- ShakeParams	

} -- CameraSubjectiveParams

