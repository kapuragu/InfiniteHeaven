--[[FDOC
	@id CharaTppSecurityCamera
	@category Ai Enemy
	@brief 監視カメラ定義スクリプト
	 * 利用するプラグイン・思考の定義。
--]]
CharaTppSecurityCamera = {

----------------------------------------
--各システムとの依存関係の定義
--
-- GeoやGrなどの各システムのJob実行タイミングを
-- 「キャラクタのJob実行後」に合わせ、
-- システムを正常に動作させるために必要。
-- 使用するシステム名を記述してください。
--
-- "Gr"				: 描画を使うなら必要
-- "Geo"			: 当たりを使うなら必要
-- "Nt"				: 通信同期を使うなら必要
-- "Fx"				: エフェクトを使うなら必要
-- "Sd"				: サウンドを使うなら必要
-- "Noise"			: ノイズを使うなら必要
-- "Ui"				: UIを使うなら必要
----------------------------------------
dependSyncPoints = {
	"Gr",
	"Geo",
	"Nt",
	"Fx",
	"Sd",
	"Noise",
},

pluginIndexEnumInfoName = "TppSecurityCameraPluginIndexDefine",

----------------------------------------
--生成処理 OnCreate()
-- キャラクタ生成時に呼ばれる関数
-- プラグインの生成などを行う
----------------------------------------
OnCreate = function( chara )
	--Ch.Log( chara, "CharaTppSoldier: OnCreate" )

	chara:InitPluginPriorities{
		"DamageAction",
		"DemoAction",
		"NoticeAction",
		"NormalAction",
	}

	--プラグインの生成
	--TODO: 肥大化してきたら、TppEnemyUtilityに移植するべし
	chara:AddPlugins{

		-- Bodyプラグイン
		"PLG_BODY",
		ChBodyPlugin{
			name			= "Body",
			parts			= "parts",
			asStaticModel		= true,
			useCharacterController = false,
			maxMotionJoints = {5},
			hasGravity = false,
		},

		-- Effectプラグイン
		"PLG_EFFECT",
		ChEffectPlugin {
			name			= "Effect",
			bodyPluginName	= "Body",
			components = {
			}
		},


		---------------------------------------------------------------------------------------------------
		-- 以下、Ai関連
		---------------------------------------------------------------------------------------------------

		-- Routeプラグイン
		"PLG_ROUTE",
		AiRoutePlugin{
			name			= "Route",
		},
		
		-- DamageModuleプラグイン
		"PLG_DAMAGE_MODULE",
		TppDamageModulePlugin{
			name			= "DamageModule",
			parent			= "Body",
		},

		---------------------------------------------------------------------------------------------------
		-- 以下、ActionPlugin関連
		---------------------------------------------------------------------------------------------------
		
		-- ActionRootPlugin
		"PLG_ACTION_ROOT",
		ChActionRootPlugin{
			name			= "ActionRoot",
		},
		--知識情報の制御
		"PLG_KNOWLEDGE",
		AiKnowledgePlugin{
			name		= "Knowledge",
		},

		-- Eyeプラグイン
		"PLG_EYE",
		TppSecurityCameraEyePlugin{
			name			= "Eye",
			paramComponent	= TppSecurityCameraEyeParameterUpdateComponent{ eyeCnp="CNP_LIGHT", },
			defaultRange			= 20,						--デフォルト視界距離（メートル）
			defaultAngleLeftRight	= ( ( 3.14 / 180 ) * 40 ),	--デフォルト左右視野角(Radian)
			defaultAngleUpDown		= ( ( 3.14 / 180 ) * 40 ),	--デフォルト上下視野角(Radian)
			params	= {
				"Discovery", GkConeSightCheckParam(),				--通常時でのプレイヤー発見用の視界
			},
			isSightCheckIncludeAttributeAll = false,
		},

		-- 基本アクションプラグイン
		"PLG_BASIC_ACTION",
		TppSecurityCameraBasicActionPlugin{
			name			= "BasicAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			priority		= "NormalAction",
			headName		= "CNP_LIGHT",
			boneNameDirection	= "SKL_001_branch",
			boneNameAngle		= "SKL_002_head",
			isAlwaysAwake	= true,
		},
	--
	}
	
	--ライフセット
	CharaTppSecurityCamera.SetLifePlugin( chara )

	if DEBUG then

		chara:AddPlugins{

			--デバッグ用乗っ取りカメラ
			--AroundCamera(ケツカメ)プラグイン
			ChAroundCameraPlugin{
				name			= "AroundCamera",
				distance		= 5.5,									-- 注視点からの距離設定
				focalLength		= 19.2,									-- 焦点距離設定
				isShake			= true,
				cameraPriority	= "Demo",
				exclusiveGroups	= { TppPluginExclusiveGroup.Camera },
				priority		= "AroundCamera",
				isSleepStart	= true,
			},
		}

	end	
	
end,


----------------------------------------
--リアライズ時処理 OnRealize()
----------------------------------------
OnRealize = function( chara )
end,

----------------------------------------
--解放処理 OnRelease()
-- キャラクタの解放時によばれる
----------------------------------------
OnRelease = function( chara )
	--Ch.Log( chara,  "CharaTppSoldier: OnRelease" )

	-- ここまで
	
end,

----------------------------------------
--デバッグ処理の更新 OnUpdateDebug()
--　OnUpdateDescの後に呼ばれる（リリースでは呼ばれないので注意）
----------------------------------------
OnUpdateDebug = function( chara, desc )

end,

----------------------------------------
--! @brief ライフセット
----------------------------------------
SetLifePlugin = function( chara )
	if chara == nil then
		Ch.Log( chara,  "[SetLifePlugin] chara is nil" )
		return
	end
	
	-- LifeとFaint、Sleep、Anesthを設定
	local lifeMax = 1000
	local lifeInitial = lifeMax
	
	chara:AddPlugins
	{
		--Lifeプラグイン
		"PLG_LIFE",
		TppSecurityCameraLifePlugin{
			name		= "LifePlugin",
			values		= {
						"Life", ChLifeValue{ max = lifeMax, initial = lifeInitial },	-- initial指定しないとmaxが自動でinitialにも入る
			},
		},
	}
	
end,


}
