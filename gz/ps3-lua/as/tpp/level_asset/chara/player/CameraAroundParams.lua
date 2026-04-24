--------------------------------------------------------------------------------
--! @file	CameraAroundParams.lua
--! @brief	ケツカメ用のパラメータ設定
--------------------------------------------------------------------------------

CameraAroundParams = {

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
		-- ビハインド立ち
		"ACT_BehindStand",
		-- ビハインドしゃがみ
		"ACT_BehindSquat",
		-- ダッシュ
		"ACT_DashMove",
		-- エルード
		"ACT_Elude",
		"ACT_EludePeepingZoom",
		
		-- 馬
		"ACT_HorseDefault",
		"ACT_HorseRideOff",
		-- ストライカー
		"ACT_StrykerDefault",
		-- 装輪装甲車乗り込み
		"ACT_CombatVehicleRideOn",
		-- 装輪装甲車を降りる
		"ACT_CombatVehicleRideOff",
		-- 立ちCQC
		"ACT_CqcDefault",
		-- しゃがみCQC
		"ACT_CqcSquat",	
		-- CQC拘束中
		"ACT_CqcToHold",

		-- 一般車両
		"ACT_VehicleDefault",
		-- 軽装車両
		"ACT_LightVehicleDefault",

		-- 軽装車両を降りる
		"ACT_LightVehicleRideOff",

		-- トラック
		"ACT_TruckDefault",
		-- トラックを降りる
		"ACT_TruckRideOff",

		-- ヘリ
		"ACT_HeliDefault",
		-- ヘリ死亡
		"ACT_HeliDead",

		-- 中メタル
		"ACT_MgmDefault",

		-- 馬(VolginChase)
		"ACT_HorseVolginChase",
		
		-- 時間タバコ
		"ACT_TimeCigarette",

		-- トラック荷台
		"ACT_TruckDeck",
		"ACT_TruckDeckPeepingZoom",
		"ACT_TruckDeckCrawl",
		"ACT_TruckDeckOff",

		-- ピッキング
		"ACT_Picking",
		-- スイッチ
		"ACT_PushButton",

		-- ビハインド立ち端ズーム
		"ACT_BehindStandEdgeZoom",
		-- ビハインドしゃがみ端ズーム
		"ACT_BehindSquatEdgeZoom",
		-- ビハインドしゃがみ上覗きズーム
		"ACT_BehindSquatPeepingUpZoom",
	},
	
},


-- 基本パラメータ（アクション等によって変わるもの）
BasicParams = {

	-- デフォルト値
	DefaultParam = {
		
		-- カメラ距離（ m ）
--		distance				= 4.5,
		distance				= 5.1,

		-- カメラオフセット（ m ）
--		offset				= Vector3( 0.0, 0.5, 0.0 ),
		offset				= Vector3( -0.30, 0.7, 0.0 ),
		
		-- 下方向限界角（ 度 ）
		rotXMin				= -60,
		
		-- 上方向限界角（ 度 ）
		rotXMax				= 80,
		
		-- 縦回転速度（ 度/秒 ）
		rotVelMaxX			= 80,
		
		-- 横回転速度（ 度/秒 ）
		rotVelMaxY			= 160,
		
		-- 回転加速度（Max速度までにかかるフレーム数）
		rotVelAccelFrame		= 10,
		
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
		attachType			= "None",

		-- 焦点距離(0を設定するとEoFがOffになる)
		focusDistance = 8.75,

		
		-- 焦点距離補間時間
		focusDistanceInterpTime = 0.1,
		
		-- レンズ口径（ 1 ～32 ）
--		aperture					= 1.875,
		aperture					= 100,
		
		-- レンズ口径補間時間（ 秒 ）
		apertureInterpTime		= 0.3,

		-- 被写界深度の手前ボケをキャンセルする
--		disableFrontBokeh			= true,

		-------------------------------------------
		-- 以下ケツカメ特有（ ※ プリセットは未対応 ）
		-------------------------------------------

		-- 乗り物カメラのデフォルトのX回転角（ 度 ）
		defaultRotXAngle			= 5,
		
		-- 乗り物カメラのX回転のデフォルトからのズレの許容値（ 度 ）
		correctAimOffsetX			= 10,
		
		-- 乗り物カメラのY回転のデフォルトからのズレの許容値（ 度 ）
		correctAimOffsetY			= 15,
		
		-- パッド操作後の乗り物カメラの無効時間（ 秒 ）
		rotationCorrectInvalidTime	= 2,
		
		-- 乗り物カメラの乗り物の速度の補正率
		correctPosSpeedRate		= 1.0,
		
		-- 乗り物カメラの回転補間時間最低値（ 秒 ）
		correctRotInterpTimeMin	= 1.5,
		
		-- 乗り物カメラの回転補間時間最大値（ 秒 ）
		correctRotInterpTimeMax	= 5,
		
		-- 乗り物カメラのY回転の回転補正を始める閾値（ correctAimOffsetYに対する割合 ）
		corectAimOffsetYExcessRate	= 0.1,

		-- Demo-Game遷移時のeffectiveFocalLengthRatio
		effectiveFocalLengthRatioFromDemo = -2.0,
		
		-- Demo-Game遷移時のfocalLength補間時間
		focalLengthInterpTimeFromDemo = 0.0,
		
		-- 特殊プリセット用デフォルト値
		PresetDefault = {
			
			-- 屋内用デフォルト値
			{
				-- プリセット名
				presetName	= "Indoor",
			
				-- カメラ距離（ m ）
				distance				= 2.9,
			
				-- カメラオフセット（ m ）
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				-- 画角
				focalLength			= 18,
			},

			-- やぐら
			{
				presetName	= "watchtower",
				distance	= 3.0,
				offset		= Vector3( -0.3, 0.3, 0 ),
			},
			
			-- 病院用デフォルト値
			{
				-- プリセット名
				presetName	= "hospital",
			
				-- カメラ距離（ m ）
				distance				= 1.5,
			
				-- カメラオフセット（ m ）
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				-- 画角
				focalLength			= 18,
			},
			
			-- 病院GDCポスターゆるコン用値
			{
				-- プリセット名
				presetName	= "hospital_poster_constcam",
			
				-- カメラ距離（ m ）
				distance				= 1.5,
			
				-- カメラオフセット（ m ）
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				-- 画角
				focalLength			= 18,
			},
			
			-- 病院煙部屋用
			{
				-- プリセット名
				presetName	= "hospital_smoke_room",
			
				-- カメラ距離（ m ）
				distance				= 2.9,
			
				-- カメラオフセット（ m ）
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				-- 画角
				focalLength			= 18,
			},
			
			-- 病院虐殺廊下用
			{
				-- プリセット名
				presetName	= "hospital_murder_collidor",
			
				-- カメラ距離（ m ）
				distance				= 2.9,
			
				-- カメラオフセット（ m ）
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				-- 画角
				focalLength			= 18,
			},
			
			-- 病院カーテン部屋用
			{
				-- プリセット名
				presetName	= "hospital_curtain_room",
			
				-- カメラ距離（ m ）
				distance				= 2.9,
			
				-- カメラオフセット（ m ）
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				-- 画角
				focalLength			= 18,
			},
			
			
			-- 病院エントランス用
			{
				-- プリセット名
				presetName	= "hospital_entrance",
			
				-- カメラ距離（ m ）
				distance				= 1.5,
			
				-- カメラオフセット（ m ）
				offset				= Vector3( 0.0, 0.6, 0.0 ),
			
				-- 画角
				focalLength			= 18,
			},			
			-- 不明
			{
				-- プリセット名
				presetName	= "homage",
			
				-- カメラ距離（ m ）
				distance			= 12,
				-- 下方向限界角（ 度 ）
				rotXMin				= 64,
				-- 上方向限界角（ 度 ）
				rotXMax				= 65,
			},
			-- グアンタナモ：難民キャンプ
			{
				-- プリセット名
				presetName	= "gntn_000",
				
				-- カメラ距離（ m ）
				distance				= 3.55,
				-- カメラオフセット（ m ）
				offset			= Vector3( -0.15, 0.55, 0.0 ),
			},	
			-- グアンタナモ：やぐら
			{
				-- プリセット名
				presetName	= "gntn_001",
				
				-- カメラ距離（ m ）
				distance				= 3.0,
				-- カメラオフセット（ m ）
				offset			= Vector3( -0.30, 0.30, 0.0 ),
			},	
			-- グアンタナモ：ボイラー室
			{
				-- プリセット名
				presetName	= "gntn_002",
				
				-- カメラ距離（ m ）
				distance				= 3.95,
				-- カメラオフセット（ m ）
				offset			= Vector3( -0.30, 0.5, 0.0 ),
			},	
		},
	},
	

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
		
			-- カメラ距離（ m ）
			distance				= 3.25,	
			-- カメラオフセット（ m ）
			offset			= Vector3(-0.30, 0.2, 0.0 ),
		},

		-- 匍匐（ 通常 ）
		{
			actionName	= "ACT_Crawl",
			
			-- カメラ距離（ m ）
			distance			= 2.5,
			-- カメラオフセット（ m ）
			offset			= Vector3(-0.30, 0.2, 0.0 ),
		},

		-- ビハインド立ち
		{
			actionName	= "ACT_BehindStand",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 1.0,
			-- カメラ距離（ m ）
			distance			= 4.5,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.6, 0.5, 0.0 ),
		},

		-- ビハインドしゃがみ
		{
			actionName	= "ACT_BehindSquat",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 1.0,
			-- カメラ距離（ m ）
			distance			= 4.5,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.6, 0.45, 0.0 ),
		},

		
		-- ダッシュ（ 通常 ）
		{
			actionName	= "ACT_DashMove",
			
			-- カメラ距離（ m ）
			distance			= 3.5,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.30, 0.325, 0.0 ),
		},
		
		-- エルード
		{
			actionName	= "ACT_Elude",
			
			-- カメラ距離（ m ）
			distance				= 4.0,	
			-- カメラオフセット（ m ）
			offset			= Vector3(-0.30, 0.3, 0.0 ),
		},
		
		-- エルード(ズーム中)
		{
			actionName	= "ACT_EludePeepingZoom",
			
			-- カメラ距離（ m ）
			distance				= 4.0,	
			-- カメラオフセット（ m ）
			offset			= Vector3(-0.30, 0.7, 0.0 ),
		},
		
		-- 馬（ 通常 ）
		{
			actionName	= "ACT_HorseDefault",
			
			-- カメラ距離（ m ）
			distance				= 7.0,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.5, -0.4, 0.0 ),
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 1.5,
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 1.5,
		},
		
		-- 馬（ 降りる ）
		{
			actionName	= "ACT_HorseRideOff",
			
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 1.76,
			
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 1.76,
		},
		
		-- ストライカー（ 通常 ）
		{
			actionName	= "ACT_StrykerDefault",

			attachType = "Manual",
			
			-- カメラ距離（ m ）
			distance				= 10.0,
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.0 ),
			-- 画角
			focalLength			= 18,
			-- カメラの俯角（ ° ）
			defaultRotXAngle			= 8,
			-- 下方向限界角（ 度 ）
			rotXMin				= -30,
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 1.0,
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 1.0,
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 1.0,
			-- 乗り物カメラのY回転のデフォルトからのズレの許容値（ 度 ）
			correctAimOffsetY			= 16,
			-- 乗り物カメラの回転補間時間最低値（ 秒 ）
			correctRotInterpTimeMin	= 0.6,
			-- パッド操作後の乗り物カメラの無効時間（ 秒 ）
			rotationCorrectInvalidTime	= 0.85,
			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 40,
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 80,
		},

		-- 装輪装甲車乗り込み
		{
			actionName	= "ACT_CombatVehicleRideOn",

			attachType = "Manual",
			
			-- カメラ距離（ m ）
			distance				= 10.0,
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.0 ),
			-- 画角
			focalLength			= 18,
			-- カメラの俯角（ ° ）
			defaultRotXAngle			= 8,
			-- 下方向限界角（ 度 ）
			rotXMin				= -30,
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 1.0,
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 1.0,
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 1.0,
			-- 乗り物カメラのY回転のデフォルトからのズレの許容値（ 度 ）
			correctAimOffsetY			= 16,
			-- 乗り物カメラの回転補間時間最低値（ 秒 ）
			correctRotInterpTimeMin	= 0.6,
			-- パッド操作後の乗り物カメラの無効時間（ 秒 ）
			rotationCorrectInvalidTime	= 0.85,

		},
		
		-- 装輪装甲車を降りる
		{
			actionName	= "ACT_CombatVehicleRideOff",
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 2.0,
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 3.0,
		},
		
		-- 一般車両
		{
			actionName	= "ACT_VehicleDefault",
			-- カメラの基準位置設定タイプ
			attachType			= "Manual",
		},

		-- 軽装車両
		{
			actionName	= "ACT_LightVehicleDefault",
			-- カメラの基準位置設定タイプ
			attachType			= "Manual",

			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, -0.5, 0.0 ),
			-- カメラ距離（ m ）
			distance				= 6.0,
			-- カメラの俯角（ ° ）
			defaultRotXAngle			= 10,
			-- 乗り物カメラのY回転のデフォルトからのズレの許容値（ 度 ）
			correctAimOffsetY			= 8,
			-- 乗り物カメラの回転補間時間最低値（ 秒 ）
			correctRotInterpTimeMin	= 0.6,
			-- パッド操作後の乗り物カメラの無効時間（ 秒 ）
			rotationCorrectInvalidTime	= 0.85,
		},

		-- 軽装車両を降りる
		{
			actionName	= "ACT_LightVehicleRideOff",
			-- カメラの基準位置設定タイプ
			attachType			= "Manual",

			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, -0.5, 0.0 ),

			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 1.85,
		},

		-- トラック
		{
			actionName	= "ACT_TruckDefault",
			-- カメラの基準位置設定タイプ
			attachType			= "Manual",

			-- カメラ距離（ m ）
			distance				= 9.5,
			-- カメラの俯角（ ° ）
			defaultRotXAngle			= 10,
			-- 画角
			focalLength			= 21,
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.0, 0.0 ),
			-- 下方向限界角（ 度 ）
			rotXMin				= -30,
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 1.0,
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 1.0,
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 1.0,
			-- 乗り物カメラのY回転のデフォルトからのズレの許容値（ 度 ）
			correctAimOffsetY			= 12,
			-- 乗り物カメラの回転補間時間最低値（ 秒 ）
			correctRotInterpTimeMin	= 0.6,
			-- パッド操作後の乗り物カメラの無効時間（ 秒 ）
			rotationCorrectInvalidTime	= 0.85,
			-- 縦回転速度（ 度/秒 ）
			rotVelMaxX			= 50,
			-- 横回転速度（ 度/秒 ）
			rotVelMaxY			= 100,
		},

		-- トラックを降りる
		{
			actionName	= "ACT_TruckRideOff",
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, 0.5, 0.0 ),
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 1.0,
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 2.0,


			-- 上方向限界角（ 度 ）
			rotXMin			= 30,
		},

		-- ヘリ
		{
			actionName	= "ACT_HeliDefault",

			-- カメラの基準位置設定タイプ
			attachType			= "Manual",

			-- カメラ距離（ m ）
			distance				= 1.5,
			-- カメラオフセット（ m ）
			offset			= Vector3(-0.15, -0.05, 0.0 ),

			-- 上方向限界角（ 度 ）
			rotXMin			= -20,
			-- 下方向限界角（ 度 ）
			rotXMax			= 50,
			-- 右方向限界角（ 度 ）
			rotYMin			= -90,
			-- 左方向限界角（ 度 ）
			rotYMax			= 90,
		},

		-- ヘリ死亡
		{
			actionName	= "ACT_HeliDead",
		
			-- カメラの基準位置設定タイプ
			attachType			= "Manual",

			-- カメラ距離（ m ）
			distance				= 2.0,
			-- カメラオフセット（ m ）
			offset			= Vector3(0.0, -0.25, 0.0 ),

			-- 上方向限界角（ 度 ）
			rotXMin			= -20,
			-- 下方向限界角（ 度 ）
			rotXMax			= 50,
			-- 右方向限界角（ 度 ）
			rotYMin			= -90,
			-- 左方向限界角（ 度 ）
			rotYMax			= 90,
		},

		-- 中メタル
		{
			actionName	= "ACT_MgmDefault",
			-- カメラ距離（ m ）
			distance			= 5.0,
			-- カメラオフセット（ m ）
			offset				= Vector3( 0.0, -0.5, 0.0 ),
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 1.5,
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 1.5,
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 1.5,
		},

		-- 立ちCQC（ 通常 ）
		{
			actionName	= "ACT_CqcDefault",
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.35, 0.0 ),
			-- 画角
			focalLength			= 32,
		},

		-- しゃがみCQC（ 通常 ）
		{
			actionName	= "ACT_CqcSquat",

			-- カメラ距離（ m ）
			distance				= 3.6,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.0, 0.0 ),
			-- 画角
			focalLength			= 32,
		},

		-- CQC拘束開始
		{
			actionName	= "ACT_CqcToHold",

			-- カメラ距離（ m ）
			distance			= 3.0,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.00, 0.65, 0.0 ),
			-- 補間時間
			interpTime	= 0.2,
			-- 画角
			focalLength			= 32,
		},

		-- 時間タバコ
		{
			actionName	= "ACT_TimeCigarette",

			-- カメラ距離（ m ）
			distance				= 1.5,

			-- 焦点距離
			focusDistance			= 1.5,

			-- カメラオフセット（ m ）
			offset			= Vector3( -0.3, 0.7, 0.0 ),
			-- 画角
			focalLength			= 32,
			
			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,
			
			-- レンズ口径（ 1 ～32 ）
			aperture				= 4.0,
		},

		-- トラック荷台
		{
			actionName = "ACT_TruckDeck",
			
			-- カメラ距離（ m ）
			distance			= 1.2,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.4, 0.25, 0.0 ),
		},
		
		-- トラック荷台(ズーム中)
		{
			actionName = "ACT_TruckDeckPeepingZoom",
			
			-- カメラ距離（ m ）
			distance			= 1.2,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.175, 0.36, 0.0 ),
		},
		
		-- トラック荷台(匍匐)
		{
			actionName = "ACT_TruckDeckCrawl",

			-- カメラ距離（ m ）
			distance			= 1.0,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.4, 0.20, 0.0 ),

		},
		-- トラック荷台から降り
		{
			actionName = "ACT_TruckDeckOff",

			-- カメラ距離（ m ）
			distance				= 3.25,	
			-- カメラオフセット（ m ）
			offset			= Vector3(-0.30, 0.2, 0.0 ),
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 1.8,
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 1.8,
		},

		-- ピッキング
		{
			actionName = "ACT_Picking",

			-- カメラ距離（ m ）
			distance			= 2.25, 
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.20, 0.27, 0.0 ),
			-- 画角
			focalLength			= 26
		},

		-- スイッチ
		{
			actionName = "ACT_PushButton",

			-- カメラ距離（ m ）
			distance			= 2.25, 
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.20, 0.40, 0.0 ),
			-- 画角
			focalLength			= 26
		},

		-- ビハインド立ち端ズーム
		{
			actionName	= "ACT_BehindStandEdgeZoom",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.4,
			-- カメラ距離（ m ）
			distance			= 4.5,
			-- カメラオフセット（ m ）
			offset			= Vector3( -1.1, 0.5, 0.0 ),
		},

		-- ビハインドしゃがみ端ズーム
		{
			actionName	= "ACT_BehindSquatEdgeZoom",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.4,
			-- カメラ距離（ m ）
			distance			= 4.5,
			-- カメラオフセット（ m ）
			offset			= Vector3( -1.1, 0.45, 0.0 ),
		},
		
		-- ビハインドしゃがみ上覗きズーム
		{
			actionName	= "ACT_BehindSquatPeepingUpZoom",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 0.4,
			-- カメラ距離（ m ）
			distance			= 4.5,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.6, 0.8, 0.0 ),
		},

	----------------------------------------
	-- 屋内用
	----------------------------------------
		
		-- 立ち（ 屋内用 ）
		{
			actionName	= "ACT_Stand",
			
			-- プリセット名
			presetName	= "Indoor",
			-- カメラ距離（ m ）
			distance			= 2.9,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.7, 0.0 ),
		},
		
		-- しゃがみ（ 屋内用 ）
		{
			actionName	= "ACT_Squat",
			
			-- プリセット名
			presetName	= "Indoor",
			
			-- カメラ距離（ m ）
			distance			= 2.6,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.05, 0.0 ),
		},
		
		-- 匍匐（ 屋内用 ）
		{
			actionName	= "ACT_Crawl",
			
			-- プリセット名
			presetName	= "Indoor",
			
			-- カメラ距離（ m ）
			distance			= 2.3,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.2, 0.0 ),
		},
		
		-- ダッシュ（ 屋内用 ）
		{
			actionName	= "ACT_DashMove",
			
			-- プリセット名
			presetName	= "Indoor",
			
			-- カメラ距離（ m ）
			distance			= 2.5,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.05, 0.0 ),
		},

	----------------------------------------
	-- やぐら
	----------------------------------------
	{	presetName			= "watchtower",
		actionName			= "ACT_Stand",
		distance			= 3.0,
		offset				= Vector3( -0.3, 0.3, 0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_Squat",
		distance			= 1.7,
		offset				= Vector3( -0.30, 0.2, 0.0 ),
	},		
	{	presetName			= "watchtower",
		actionName			= "ACT_Crawl",
		distance			= 1.6,
		offset				= Vector3(-0.30, 0.2, 0.0 ),
	},		
	{	presetName			= "watchtower",
		actionName			= "ACT_BehindStand",
		offsetInterpTime	= 1.0,
		distance			= 2.0,
		offset				= Vector3( -0.6, 0.5, 0.0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_BehindSquat",
		offsetInterpTime	= 1.0,
		distance			= 1.7,
		offset				= Vector3( -0.6, 0.30, 0.0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_DashMove",
		distance			= 2.5,
		offset				= Vector3( -0.35, 0.325, 0.0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_BehindStandEdgeZoom",
		offsetInterpTime	= 0.4,
		distance			= 2.0,
		offset				= Vector3( -1.1, 0.5, 0.0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_BehindSquatEdgeZoom",
		offsetInterpTime	= 0.4,
		distance			= 1.7,
		offset				= Vector3( -1.1, 0.15, 0.0 ),
	},
	{	presetName			= "watchtower",
		actionName			= "ACT_BehindSquatPeepingUpZoom",
		offsetInterpTime	= 0.4,
		distance			= 1.7,
		offset				= Vector3( -0.3, 0.4, 0.0 ),
	},
		
	----------------------------------------
	-- 病院用
	----------------------------------------
		
		-- 立ち（ 病院用 ）
		{
			actionName	= "ACT_Stand",
			
			-- プリセット名
			presetName	= "hospital",

			-- カメラ距離（ m ）
			distance			= 2.9,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.2, 0.0 ),
			-- 画角
			focalLength			= 18,

			-- 焦点距離
			focusDistance 		= 5.5,

			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,

			-- レンズ口径（ 1 ～32 ）
			aperture				= 0.9,

		},
		
		-- しゃがみ（ 病院用 ）
		{
			actionName	= "ACT_Squat",
			
			-- プリセット名
			presetName	= "hospital",
			
			-- カメラ距離（ m ）
			distance			= 2.6,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.05, 0.0 ),
			-- 画角
			focalLength			= 18,
			
			-- 焦点距離
			focusDistance 		= 5.5,			

			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,

			-- レンズ口径（ 1 ～32 ）
			aperture				= 0.9,

		},
		
		-- 匍匐（ 病院用 ）
		{
			actionName	= "ACT_Crawl",
			
			-- プリセット名
			presetName	= "hospital",
			
			-- カメラ距離（ m ）
			distance			= 2.3,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.2, 0.0 ),
			-- 画角
			focalLength			= 18,
			--focalLength			= 18.836,

			-- 焦点距離
			focusDistance 		= 5.5,
			--focusDistance 		= 2.7,

			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,

			-- レンズ口径（ 1 ～32 ）
			aperture				= 0.9,
			--aperture				= 1.3,

		},

		------------------------------------------------
		-- 病院煙部屋用 ※立ちの姿勢は存在しない
		------------------------------------------------
		
		-- しゃがみ（ 病院煙部屋用 ）
		{
			actionName	= "ACT_Squat",
			
			-- プリセット名
			presetName	= "hospital_smoke_room",
			
			-- カメラ距離（ m ）
			distance			= 1.5,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.15, 0.0 ),
			-- 画角
			focalLength			= 18,
			
			-- 焦点距離
			focusDistance 		= 3.0,

			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,

			-- 下方向限界角（ 度 ）
			rotXMin				= -20,
		
			-- 上方向限界角（ 度 ）※煙で上に上げると何も見えなくなるので
			rotXMax				= 20,
		},
		
		-- 匍匐（ 病院煙部屋用 ）
		{
			actionName	= "ACT_Crawl",
			
			-- プリセット名
			presetName	= "hospital_smoke_room",
			
			-- カメラ距離（ m ）
			distance			= 1.0,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.25, 0.0 ),
			-- 画角
			focalLength			= 18,

			-- 焦点距離
			focusDistance 		= 3.0,

			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,

			-- 下方向限界角（ 度 ）
			rotXMin				= -20,
		
			-- 上方向限界角（ 度 ）※煙で上に上げると何も見えなくなるので
			rotXMax				= 20,
		},

		------------------------------------------------
		-- 病院カーテン部屋用
		------------------------------------------------

		-- 立ち（ 病院カーテン部屋用 ）
		{
			actionName	= "ACT_Stand",
			
			-- プリセット名
			presetName	= "hospital_curtain_room",

			-- カメラ距離（ m ）
			distance			= 2.25,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.8, 0.0 ),
			-- 画角
			focalLength			= 18,

			-- 焦点距離
			focusDistance 		= 3.0,

			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,

		},

		-- しゃがみ（ 病院カーテン部屋用 ）
		{
			actionName	= "ACT_Squat",
			
			-- プリセット名
			presetName	= "hospital_curtain_room",
			
			-- カメラ距離（ m ）
			distance			= 1.5,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.1, 0.0 ),
			-- 画角
			focalLength			= 18,
			
			-- 焦点距離
			focusDistance 		= 3.0,

			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,

		},

		-- 匍匐（ 病院カーテン部屋用 ）
		{
			actionName	= "ACT_Crawl",
			
			-- プリセット名
			presetName	= "hospital_curtain_room",
			
			-- カメラ距離（ m ）
			distance			= 1.25,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.2, 0.0 ),
			-- 画角
			focalLength			= 18,

			-- 焦点距離
			focusDistance 		= 3.0,

			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,
		},

		------------------------------------------------
		-- 病院虐殺廊下用
		------------------------------------------------

		-- 立ち（ 病院虐殺廊下用 ）
		{
			actionName	= "ACT_Stand",
			
			-- プリセット名
			presetName	= "hospital_murder_collidor",

			-- カメラ距離（ m ）
			distance			= 2.25,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.8, 0.0 ),
			-- 画角
			focalLength			= 18,

			-- 焦点距離
			focusDistance 		= 3.0,

			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,

		},

		-- しゃがみ（ 病院虐殺廊下用 ）
		{
			actionName	= "ACT_Squat",
			
			-- プリセット名
			presetName	= "hospital_murder_collidor",
			
			-- カメラ距離（ m ）
			distance			= 1.5,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.1, 0.0 ),
			-- 画角
			focalLength			= 18,
			
			-- 焦点距離
			focusDistance 		= 3.0,

			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,

		},

		-- 匍匐（ 病院虐殺廊下用 ）
		{
			actionName	= "ACT_Crawl",
			
			-- プリセット名
			presetName	= "hospital_murder_collidor",
			
			-- カメラ距離（ m ）
			distance			= 0.85,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.2, 0.2 ),
			-- 画角
			focalLength			= 18,

			-- 焦点距離
			focusDistance 		= 1.0,

			-- 焦点距離補間時間
			focusDistanceInterpTime = 0.1,

			-- 下方向限界角（ 度 ）
			rotXMin				= -20,
		
			-- 上方向限界角（ 度 ）※煙で上に上げると何も見えなくなるので
			rotXMax				= 20,
		},

		------------------------------------------------
		-- 病院エントランス用
		------------------------------------------------
		
		-- 立ち（ 病院エントランス用 ）
		{
			actionName	= "ACT_Stand",
			
			-- プリセット名
			presetName	= "hospital_entrance",

			-- カメラ距離（ m ）
			distance			= 2.9,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.2, 0.0 ),
			-- 画角
			focalLength			= 18,
		},
		
		-- しゃがみ（ 病院エントランス用 ）
		{
			actionName	= "ACT_Squat",
			
			-- プリセット名
			presetName	= "hospital_entrance",
			
			-- カメラ距離（ m ）
			distance			= 2.6,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.05, 0.0 ),
			-- 画角
			focalLength			= 18,
		},
	
		-- 匍匐（ 病院エントランス用 ）
		{
			actionName	= "ACT_Crawl",
			
			-- プリセット名
			presetName	= "hospital_entrance",
			
			-- カメラ距離（ m ）
			distance			= 2.3,
			-- カメラオフセット（ m ）
			offset			= Vector3( 0.0, 0.2, 0.0 ),
			-- 画角
			focalLength			= 18,
		},		
		-- 馬（ ヴォルギンチェイス ）
		{
			actionName	= "ACT_HorseVolginChase",

			-- プリセット名
			presetName	= "hospital_entrance",
			 
			-- カメラ距離（ m ）
			distance				= 4.8,
			-- カメラオフセット（ m ）
			-- offset				= Vector3( -0.7, 0.15, 0.0 ),
			offset				= Vector3( -0.9, -0.9, 0.0 ),
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime		= 1.5,
			-- カメラ距離補間時間（ 秒 ）
			distanceInterpTime	= 1.5,
			-- 画角補間時間（ 秒 ）
			focalLengthInterpTime	= 1.5,
		 	-- 画角
			focalLength			= 18,
			-- 焦点距離
			focusDistance			= 5.0,
			-- レンズ口径（ 1 ～32 ）
			aperture				= 0.8,
			-- シャッタースピード
			shutterSpeed			= 0.04,
		},
		
	----------------------------------------
	-- グアンタナモ用：テントの間
	----------------------------------------
		
		-- 立ち（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_Stand",
			-- プリセット名
			presetName			= "gntn_000",
			-- カメラ距離（ m ）
			distance			= 3.55,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.15, 0.55, 0.0 ),
		},
		
		-- しゃがみ（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_Squat",
			-- プリセット名
			presetName			= "gntn_000",
			-- カメラ距離（ m ）
			distance			= 1.7,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.15, 0.1, 0.0 ),
		},
		
		-- 匍匐（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_Crawl",
			-- プリセット名
			presetName			= "gntn_000",
			-- カメラ距離（ m ）
			distance			= 1.6,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.15, 0.2, 0.0 ),
		},
		
		-- ビハインド立ち
		{
			actionName			= "ACT_BehindStand",
			-- プリセット名
			presetName			= "gntn_000",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 1.0,
			-- カメラ距離（ m ）
			distance			= 2.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.6, 0.5, 0.0 ),
		},
		-- ビハインドしゃがみ
		{
			actionName			= "ACT_BehindSquat",
			-- プリセット名
			presetName			= "gntn_000",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 1.0,
			-- カメラ距離（ m ）
			distance			= 2.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.6, 0.15, 0.0 ),
		},
		-- ダッシュ（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_DashMove",
			-- プリセット名
			presetName			= "gntn_000",
			-- カメラ距離（ m ）
			distance			= 2.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.35, 0.325, 0.0 ),
		},
		
		-- ビハインド立ち端ズーム
		{
			actionName			= "ACT_BehindStandEdgeZoom",
			-- プリセット名
			presetName			= "gntn_000",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 0.4,
			-- カメラ距離（ m ）
			distance			= 2.0,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.9, 0.5, 0.0 ),
		},
		
		-- ビハインドしゃがみ端ズーム
		{
			actionName			= "ACT_BehindSquatEdgeZoom",
			-- プリセット名
			presetName			= "gntn_000",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 0.4,
			-- カメラ距離（ m ）
			distance			= 1.7,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.85, 0.0, 0.0 ),
		},
		
		-- ビハインドしゃがみ上覗きズーム
		{
			actionName			= "ACT_BehindSquatPeepingUpZoom",
			-- プリセット名
			presetName			= "gntn_000",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 0.4,
			-- カメラ距離（ m ）
			distance			= 1.7,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.3, 0.4, 0.0 ),
		},
		
	----------------------------------------
	-- グアンタナモ用：やぐら
	----------------------------------------
		
		-- 立ち（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_Stand",
			-- プリセット名
			presetName			= "gntn_001",
			-- カメラ距離（ m ）
			distance			= 3.0,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.30, 0.30, 0.0 ),
		},
		
		-- しゃがみ（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_Squat",
			-- プリセット名
			presetName			= "gntn_001",
			-- カメラ距離（ m ）
			distance			= 1.7,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.30, 0.2, 0.0 ),
		},
		
		-- 匍匐（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_Crawl",
			-- プリセット名
			presetName			= "gntn_001",
			
			-- カメラ距離（ m ）
			distance			= 1.6,
			-- カメラオフセット（ m ）
			offset				= Vector3(-0.30, 0.2, 0.0 ),
		},
		
		-- ビハインド立ち
		{
			actionName			= "ACT_BehindStand",
			-- プリセット名
			presetName			= "gntn_001",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 1.0,
			-- カメラ距離（ m ）
			distance			= 1.8,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.6, 0.5, 0.0 ),
		},
		-- ビハインドしゃがみ
		{
			actionName			= "ACT_BehindSquat",
			-- プリセット名
			presetName			= "gntn_001",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 1.0,
			-- カメラ距離（ m ）
			distance			= 1.7,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.6, 0.30, 0.0 ),
		},
		-- ダッシュ（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_DashMove",
			-- プリセット名
			presetName			= "gntn_001",
			-- カメラ距離（ m ）
			distance			= 2.5,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.35, 0.325, 0.0 ),
		},
		
		-- ビハインド立ち端ズーム
		{
			actionName			= "ACT_BehindStandEdgeZoom",
			-- プリセット名
			presetName			= "gntn_001",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 0.4,
			-- カメラ距離（ m ）
			distance			= 1.8,
			-- カメラオフセット（ m ）
			offset			= Vector3( -1.0, 0.5, 0.0 ),
		},
		
		-- ビハインドしゃがみ端ズーム
		{
			actionName			= "ACT_BehindSquatEdgeZoom",
			-- プリセット名
			presetName			= "gntn_001",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 0.4,
			-- カメラ距離（ m ）
			distance			= 1.7,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.9, 0.1, 0.0 ),
		},
		
		-- ビハインドしゃがみ上覗きズーム
		{
			actionName			= "ACT_BehindSquatPeepingUpZoom",
			-- プリセット名
			presetName			= "gntn_001",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 0.4,
			-- カメラ距離（ m ）
			distance			= 1.7,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.3, 0.4, 0.0 ),
		},
		
	----------------------------------------
	-- グアンタナモ用：ボイラー
	----------------------------------------
		
		-- 立ち（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_Stand",
			-- プリセット名
			presetName			= "gntn_002",
			-- カメラ距離（ m ）
			distance			= 3.95,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.30, 0.5, 0.0 ),
		},
		
		-- しゃがみ（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_Squat",
			-- プリセット名
			presetName			= "gntn_002",
			-- カメラ距離（ m ）
			distance			= 2.75,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.30, 0.2, 0.0 ),
		},
		
		-- 匍匐（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_Crawl",
			-- プリセット名
			presetName			= "gntn_002",
			-- カメラ距離（ m ）
			distance			= 2.0,
			-- カメラオフセット（ m ）
			offset				= Vector3(-0.30, 0.2, 0.0 ),
		},
		
		-- ビハインド立ち
		{
			actionName			= "ACT_BehindStand",
			-- プリセット名
			presetName			= "gntn_002",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 1.0,
			-- カメラ距離（ m ）
			distance			= 2.25,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.6, 0.5, 0.0 ),
		},
		-- ビハインドしゃがみ
		{
			actionName			= "ACT_BehindSquat",
			-- プリセット名
			presetName			= "gntn_002",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 1.0,
			-- カメラ距離（ m ）
			distance			= 2.25,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.6, 0.30, 0.0 ),
		},
		-- ダッシュ（ グアンタナモ難民キャンプ用 ）
		{
			actionName			= "ACT_DashMove",
			-- プリセット名
			presetName			= "gntn_002",
			-- カメラ距離（ m ）
			distance			= 3.0,
			-- カメラオフセット（ m ）
			offset				= Vector3( -0.35, 0.325, 0.0 ),
		},
		
		-- ビハインド立ち端ズーム
		{
			actionName			= "ACT_BehindStandEdgeZoom",
			-- プリセット名
			presetName			= "gntn_002",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 0.4,
			-- カメラ距離（ m ）
			distance			= 2.25,
			-- カメラオフセット（ m ）
			offset			= Vector3( -1.1, 0.5, 0.0 ),
		},
		
		-- ビハインドしゃがみ端ズーム
		{
			actionName			= "ACT_BehindSquatEdgeZoom",
			-- プリセット名
			presetName			= "gntn_002",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 0.4,
			-- カメラ距離（ m ）
			distance			= 2.25,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.9, 0.15, 0.0 ),
		},
		
		-- ビハインドしゃがみ上覗きズーム
		{
			actionName			= "ACT_BehindSquatPeepingUpZoom",
			-- プリセット名
			presetName			= "gntn_002",
			-- オフセット補間時間（ 秒 ）
			offsetInterpTime	= 0.4,
			-- カメラ距離（ m ）
			distance			= 2.25,
			-- カメラオフセット（ m ）
			offset			= Vector3( -0.3, 0.4, 0.0 ),
		},
		
	},



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
		distanceInterpTimeAtStart	= 0.4,
		
		-- カメラ切り替え時のオフセット補間時間（ 秒 ）
		offsetInterpTimeAtStart	= 0.3,
		
		-- 基準点補間時間（ 秒 ）
		basePosInterpTime			= 0.3,
		
		-- アタリチェックによる位置補正の補間時間（ 秒 ）
		collisionInterpTime		= 0.3,
		
		-- 補間用ベジエ曲線の制御時間
		bezierControlTime			= 0.4,
		
		-- 補間用ベジエ曲線の制御レート
		bezierControlRate			= 0.8,
		
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
		rangeRotX	= 0.5,
		
		-- Y回転揺れ幅 （ 度 ）
		rangeRotY	= 0.05,
		
		-- Z回転揺れ幅 （ 度 ）
		rangeRotZ	= 0,

		-- 位置揺れ周期
		cyclePos		= 6,
		
		-- 回転揺れ周期
		cycleRot		= 14,
		
		-- 補間時間
		interpTime	= 0.5,
		
		-- 速度変化に対応するか
		speedMode	= true,

		-- 速度変化が0のときの手振れ割合
		speedRateMin = 0.15,
			
		-- 速度変化の計算基準値(この速度のときに最大手振れになる)
		speedRateBaseValue = 3.5,

		-- 速度変化が0のときの位置揺れ周期倍率
		cyclePosRateWhenSpeedRateIsMin = 0.333333,
		-- 速度変化が0のときの回転揺れ周期倍率
		cycleRotRateWhenSpeedRateIsMin = 0.333333,
	},

	Params = {

		-- 立ち
		{
			name		= "ACT_Stand",
			
			-- 位置揺れ幅 ( m )　XYZ
			rangePosX	= 0.0005,
			rangePosY	= 0.0005,
			rangePosZ	= 0.07,
			
			-- 回転揺れ幅 （ 度 ）　XYZ
			rangeRotX	= 0.12,
			rangeRotY	= 0.03,
			rangeRotZ	= 0.1,

			-- 揺れ周期　位置、回転
			cyclePos		= 4.5,
			cycleRot		= 18,
			
			speedRateBaseValue = 4.19,
			
			-- 速度変化が0のときの手振れ割合
			speedRateMin = 0.01,
		},
		-- ダッシュ
		{
			name		= "ACT_DashMove",
			
			-- 位置揺れ幅 ( m )　XYZ
			rangePosX	= 0.005,
			rangePosY	= 0.005,
			rangePosZ	= 0.175,
			
			-- 回転揺れ幅 （ 度 ）　XYZ
			rangeRotX	= 0.35,
			rangeRotY	= 0.07,
			rangeRotZ	= 0.2,

			-- 揺れ周期　位置、回転
			cyclePos		= 9,
			cycleRot		= 36,
			
			speedRateBaseValue = 8.39,
			
			-- 速度変化が0のときの手振れ割合
			speedRateMin = 0.01,
		},
		-- しゃがみ
		{
			name		= "ACT_Squat",

			-- X方向揺れ幅 ( m )
			rangePosX	= 0.0005,
			
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.0005,

			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.10,
			
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.10,

			-- 位置揺れ周期
			cyclePos		= 6,
			
			-- 回転揺れ周期
			cycleRot		= 14,
			
			-- 速度変化の計算基準値(この速度のときに最大手振れになる)
			speedRateBaseValue = 2.5,

			-- 速度変化が0のときの位置揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.5,
			-- 速度変化が0のときの回転揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.5,
		},

		-- 担ぎ(立ち)
		{
			name		= "ACT_CarryStand",	

			-- 位置揺れ幅 ( m )　XYZ
			rangePosX	= 0.005,
			rangePosY	= 0.005,
			rangePosZ	= 0.175,
			
			-- 回転揺れ幅 （ 度 ）　XYZ
			rangeRotX	= 0.35,
			rangeRotY	= 0.07,
			rangeRotZ	= 0.2,

			-- 揺れ周期　位置、回転
			cyclePos		= 9,
			cycleRot		= 36,
			
			speedRateBaseValue = 8.39,
			
			-- 速度変化が0のときの手振れ割合
			speedRateMin = 0.01,
		},

		-- 担ぎ(しゃがみ)
		{
			name		= "ACT_CarrySquat",

			-- X方向揺れ幅 ( m )
			rangePosX	= 0.0005,
			
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.0005,

			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.10,
			
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.10,

			-- 位置揺れ周期
			cyclePos		= 6,
			
			-- 回転揺れ周期
			cycleRot		= 14,
			
			-- 速度変化の計算基準値(この速度のときに最大手振れになる)
			speedRateBaseValue = 2.0,

			-- 速度変化が0のときの位置揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.5,
			-- 速度変化が0のときの回転揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.5,
		},

		-- 匍匐
		{
			name		= "ACT_Crawl",

			-- X方向揺れ幅 ( m )
			rangePosX	= 0.0,
			
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.0,

			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.05,
			
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.05,

			-- 位置揺れ周期
			cyclePos		= 6,
			
			-- 回転揺れ周期
			cycleRot		= 14,

			-- 速度変化が0のときの手振れ割合
			speedRateMin = 0.5,
			
			-- 速度変化の計算基準値(この速度のときに最大手振れになる)
			speedRateBaseValue = 1.0,

			-- 速度変化が0のときの位置揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.5,
			-- 速度変化が0のときの回転揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.5,
		},
		
		-- 馬（ 通常 ）
		{
			name	= "ACT_HorseDefault",
			
			-- X方向揺れ幅 ( m )
			rangePosX	= 0.01,
			
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.02,

			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.30,
			
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.45,
			
			-- 位置揺れ周期
			cyclePos		= 9,
		
			-- 回転揺れ周期
			cycleRot		= 21,
		
			-- 速度変化が0のときの手振れ割合
			speedRateMin = 0.01,
				
			-- 速度変化の計算基準値(この速度のときに最大手振れになる)
			speedRateBaseValue = 11,

			-- 速度変化が0のときの位置揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.333333,
			-- 速度変化が0のときの回転揺れ周期倍率
			cycleRotRateWhenSpeedRateIsMin = 0.333333,
		},

		-- 東西ビークル用
		{
			name	= "ACT_LightVehicleDefault",

			-- 位置揺れ幅 ( m )　XYZ
			rangePosX	= 0.0,
			rangePosY	= 0.0,
			rangePosZ	= 0.25,
			
			-- 回転揺れ幅 （ 度 ）　XYZ
			rangeRotX	= 0.2,
			rangeRotY	= 0.2,

			-- 位置揺れ周期
			cyclePos		= 24,
		
			-- 回転揺れ周期
			cycleRot		= 56,
		
			-- 速度変化が0のときの手振れ割合
			speedRateMin = 0.01,
				
			-- 速度変化の計算基準値(この速度のときに最大手振れになる)
			speedRateBaseValue = 11,

			-- 速度変化が0のときの位置揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.333333,
			-- 速度変化が0のときの回転揺れ周期倍率
			cycleRotRateWhenSpeedRateIsMin = 0.333333,
		},

		-- 東西トラック用
		{
			name	= "ACT_TruckDefault",

			-- 位置揺れ幅 ( m )　XYZ
			rangePosX	= 0.0,
			rangePosY	= 0.0,
			rangePosZ	= 0.35,
			
			-- 回転揺れ幅 （ 度 ）　XYZ
			rangeRotX	= 0.2,
			rangeRotY	= 0.2,

			-- 位置揺れ周期
			cyclePos		= 24,
		
			-- 回転揺れ周期
			cycleRot		= 56,
		
			-- 速度変化が0のときの手振れ割合
			speedRateMin = 0.01,
				
			-- 速度変化の計算基準値(この速度のときに最大手振れになる)
			speedRateBaseValue = 11,

			-- 速度変化が0のときの位置揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.333333,
			-- 速度変化が0のときの回転揺れ周期倍率
			cycleRotRateWhenSpeedRateIsMin = 0.333333,
		},
		
		-- 機銃装甲車、装輪戦車用
		{
			name	= "ACT_StrykerDefault",

			-- 位置揺れ幅 ( m )　XYZ
			rangePosX	= 0.0,
			rangePosY	= 0.0,
			rangePosZ	= 0.45,
			
			-- 回転揺れ幅 （ 度 ）　XYZ
			rangeRotX	= 0.2,
			rangeRotY	= 0.2,

			-- 位置揺れ周期
			cyclePos		= 24,
		
			-- 回転揺れ周期
			cycleRot		= 56,
		
			-- 速度変化が0のときの手振れ割合
			speedRateMin = 0.1,
				
			-- 速度変化の計算基準値(この速度のときに最大手振れになる)
			speedRateBaseValue = 5,

			-- 速度変化が0のときの位置揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.333333,
			-- 速度変化が0のときの回転揺れ周期倍率
			cycleRotRateWhenSpeedRateIsMin = 0.333333,
		},

		-- トラック荷台しゃがみ
		{
			name	= "ACT_TruckDeck",
			
			-- X方向揺れ幅 ( m )
			rangePosX	= 0.01,
			
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.02,

			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.30,
			
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.45,
			
			-- 位置揺れ周期
			cyclePos		= 24,
		
			-- 回転揺れ周期
			cycleRot		= 56,
		
			-- 速度変化が0のときの手振れ割合
			speedRateMin = 0.05,
				
			-- 速度変化の計算基準値(この速度のときに最大手振れになる)
			speedRateBaseValue = 9,

			-- 速度変化が0のときの位置揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.15,
			-- 速度変化が0のときの回転揺れ周期倍率
			cycleRotRateWhenSpeedRateIsMin = 0.15,
		},

		-- トラック荷台ホフク
		{
			name	= "ACT_TruckDeckCrawl",
			
			-- X方向揺れ幅 ( m )
			rangePosX	= 0.0075,
			
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.015,

			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.20,
			
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.3,
			
			-- 位置揺れ周期
			cyclePos		= 24,
		
			-- 回転揺れ周期
			cycleRot		= 56,
		
			-- 速度変化が0のときの手振れ割合
			speedRateMin = 0.05,
				
			-- 速度変化の計算基準値(この速度のときに最大手振れになる)
			speedRateBaseValue = 9,
			
			-- 速度変化が0のときの位置揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 0.15,
			-- 速度変化が0のときの回転揺れ周期倍率
			cycleRotRateWhenSpeedRateIsMin = 0.15,
		},

		-- ピッキング
		{
			name	= "ACT_Picking",
			
			-- X方向揺れ幅 ( m )
			rangePosX	= 0.01,
			
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.02,

			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.30,
			
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.45,
			
			-- 位置揺れ周期
			cyclePos		= 24,
		
			-- 回転揺れ周期
			cycleRot		= 56,
		},

		-- ヘリ内アクション
		{
			name		= "ACT_HeliDefault",

			-- X方向揺れ幅 ( m )
			rangePosX	= 0.000,
			
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.000,

			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.14,
			
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.14,
			
			-- 位置揺れ周期
			cyclePos		= 18,
		
			-- 回転揺れ周期
			cycleRot		= 36,
		
			-- 速度変化が0のときの手振れ割合
			speedRateMin = 1.0,
				
			-- 速度変化の計算基準値(この速度のときに最大手振れになる)
			speedRateBaseValue = 1.0,

			-- 速度変化が0のときの位置揺れ周期倍率
			cyclePosRateWhenSpeedRateIsMin = 1.0,
			-- 速度変化が0のときの回転揺れ周期倍率
			cycleRotRateWhenSpeedRateIsMin = 1.0,
		},

		-- 病院レールアクション（　静止　）
		{
			name		= "ACT_RailIdle",

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

			-- 位置揺れ周期
			cyclePos		= 0,
		
			-- 回転揺れ周期
			cycleRot		= 0,
		
			-- 補間時間
			interpTime	= 1.0,
		
			-- 速度変化に対応するか
			speedMode	= false,
		
		},

		-- 病院レールアクション（　匍匐移動　）
		{
			name		= "ACT_RailCrawlMove",

			-- X方向揺れ幅 ( m )
			rangePosX	= 0.0001,
		
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.0001,

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
			cycleRot		= 7,
		
			-- 補間時間
			interpTime	= 0.5,
		
			-- 速度変化に対応するか
			speedMode	= false,
		
		},

		-- 病院レールアクション（　匍匐移動　）
		{
			name		= "ACT_RailSquatMove",

			-- X方向揺れ幅 ( m )
			rangePosX	= 0.0005,
		
			-- Y方向揺れ幅 ( m )
			rangePosY	= 0.0005,

			-- Z方向揺れ幅 ( m )
			rangePosZ	= 0,
		
			-- X回転揺れ幅 （ 度 ）
			rangeRotX	= 0.25,
		
			-- Y回転揺れ幅 （ 度 ）
			rangeRotY	= 0.25,
		
			-- Z回転揺れ幅 （ 度 ）
			rangeRotZ	= 0,

			-- 位置揺れ周期
			cyclePos		= 7,
		
			-- 回転揺れ周期
			cycleRot		= 15,
		
			-- 補間時間
			interpTime	= 0.5,
		
			-- 速度変化に対応するか
			speedMode	= false,
		
		},
	},

}, -- ShakeParams


VehicleNoiseParam = {

	DefaultParam = {

		-- ノイズ発生距離最大 （ m ）
		enableDistanceMax = 15.0,
	
		-- ノイズ発生車両スピード最小 （ m　/　s ）
		enableSpeedMin = 1.39,
	
		-- ノイズ発生車両スピード最大 （ m　/　s ） ※ このスピード以上でノイズの強さが最大になる
		enableSpeedMax = 16.7,
	
		-- ノイズ縦揺れ幅最大（ 度 ）
		levelXMax = 0.25,
	
		-- ノイズ横揺れ幅最大（ 度 ）
		levelYMax = 0.15,
	
		-- ノイズ継続時間（ 秒 ）　※車両通過ノイズ発生条件が外れた後の継続時間
		time = 0.0,
	
		-- ノイズ減衰率（ 0 以上 1 未満 ）
		decayRate = 0.75,

	},

	Params = {

		-- 装輪戦車
		{
			vehicleType = 0,	-- 車種（　装輪戦車:0, ジープ:1, トラック:2, 戦車:3 ）
			enableDistanceMax = 30.0,
		},

		-- ジープ
		{
			vehicleType = 1,	-- 車種（　装輪戦車:0, ジープ:1, トラック:2, 戦車:3 ）
		},

		-- トラック
		{
			vehicleType = 2,	-- 車種（　装輪戦車:0, ジープ:1, トラック:2, 戦車:3 ）
		},

		-- 戦車
		{
			vehicleType = 3,	-- 車種（　装輪戦車:0, ジープ:1, トラック:2, 戦車:3 ）
		},

	},
	
}, -- VehicleNoiseParam


} -- CameraAroundParams

