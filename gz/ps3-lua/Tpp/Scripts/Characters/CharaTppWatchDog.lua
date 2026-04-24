--[[FDOC
	@id CharaTppWatchDog
	@category Ai Enemy
	@brief 番犬定義スクリプト
	 * 利用するプラグイン・思考の定義。
--]]
CharaTppWatchDog = {

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
-- "Nav"			: 経路探索を使うなら必要
-- "GroupBehavior"	: 連携を使うなら必要
-- "Ui"				: UIを使うなら必要
----------------------------------------
dependSyncPoints = {
	"Gr",
	"Geo",
	"Nt",
	"Fx",
	"Sd",
	"Noise",
	"Nav",
},

pluginIndexEnumInfoName = "TppWatchDogPluginDefine",

--Cへ移動済み
----------------------------------------
--生成処理 OnCreate()
-- キャラクタ生成時に呼ばれる関数
-- プラグインの生成などを行う
----------------------------------------
__OnCreate = function( chara )
	--Ch.Log( chara, "CharaTppSoldier: OnCreate" )

	chara:InitPluginPriorities{
		"DamageAction",
		"DownAction",
		"NoticeAction",
		"NormalAction",
	}

	--プラグインの生成
	--TODO: 肥大化してきたら、TppEnemyUtilityに移植するべし
	chara:AddPlugins{

		-- Bodyプラグイン
		"PLG_WATCHDOG_BODY",
		ChBodyPlugin{
			name			= "Body",
			parts			= "parts",
			animGraphLayer	= "motionGraph",
			script			= "Tpp/Scripts/Characters/Bodies/BodyTppWatchDog.lua",
			maxMotionPoints	= { 2, 2, 2 },
			maxMtarFiles    = 1,
			extraScaleJoints = 1,
			useTwoStepAnim	= true,
			hasTrap			= false,
		},

		-- Effectプラグイン
		"PLG_WATCHDOG_EFFECT",
		ChEffectPlugin {
			name			= "Effect",
			bodyPluginName	= "Body",
		},

		---------------------------------------------------------------------------------------------------
		-- 以下、Ai関連
		---------------------------------------------------------------------------------------------------
		-- Navigationプラグイン
		"PLG_WATCHDOG_NAVIGATION",
		ChNavigationPlugin{
			name			= "Nav",
			sceneName		= "MainScene",
			worldName		= "",
			typeName		= "BasicController",
			turningRadii	= {0.5,1.0},
			radius			= 0.45,
			attribute		= {0,0,0,0},
			--mode			= "debug",
		},

		-- Routeプラグイン
		"PLG_WATCHDOG_ROUTE",
		AiRoutePlugin{
			name			= "Route",
		},

		--モーション速度だけ変化させるプラグイン --
		"PLG_WATCHDOG_MOTION_SPEED",
		TppCharacterMotionSpeedPlugin {
			name = "TppCharacterMotionSpeed",
			bodyPluginName = "Body"
		},
		---------------------------------------------------------------------------------------------------
		-- 以下、ActionPlugin関連
		---------------------------------------------------------------------------------------------------

		-- ActionRootPlugin
		"PLG_WATCHDOG_ACTION_ROOT",
		ChActionRootPlugin{
			name			= "ActionRoot",
		},
--![[
		-- ダメージアクションプラグイン
		"PLG_WATCHDOG_DAMAGE_ACTION",
		TppWatchDogDamageActionPlugin{
			name			= "DamageAction",
			script			= "Tpp/Scripts/Characters/Actions/ActionTppWatchDogDamage.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			layerName		= "Full",
			priority		= "DamageAction",
			exclusiveGroups = { TppPluginExclusiveGroup.Lower },
			isSleepStart	= true,
		},
--]]
		--知識情報の制御
		"PLG_WATCHDOG_KNOWLEDGE",
		AiKnowledgePlugin{
			name		= "Knowledge",
		},

		-- Eyeプラグイン
		"PLG_WATCHDOG_EYE",
		TppWatchDogEyePlugin{
			name			= "Eye",
			paramComponent	= TppWatchDogEyeParameterUpdateComponent{ eyeCnp="CNP_EYE", },
			defaultRange			= 20,						--デフォルト視界距離（メートル）
			defaultAngleLeftRight	= ( ( 3.14 / 180 ) * 40 ),	--デフォルト左右視野角(Radian)
			defaultAngleUpDown		= ( ( 3.14 / 180 ) * 40 ),	--デフォルト上下視野角(Radian)
			params	= {
				"Discovery", GkConeSightCheckParam(),				--通常時でのプレイヤー発見用の視界
			},
			isSightCheckIncludeAttributeAll = false,
		},

		-- 基本アクションプラグイン
		"PLG_WATCHDOG_BASIC_ACTION",
		TppWatchDogBasicActionPlugin{
			name			= "BasicAction",
			script			= "Tpp/Scripts/Characters/Actions/ActionTppWatchDogBasic.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			layerName		= { "Full" ,"Neck" },
			priority		= "NormalAction",
			exclusiveGroups = { TppPluginExclusiveGroup.Lower },
			isAlwaysAwake	= true,
		},

		-- MotionAdjustModuleプラグイン
		"PLG_WATCHDOG_MOTION_ADJUST_MODULE",
		TppMotionAdjustModulePlugin{
			name			= "MotionAdjustModule",
			parent			= "Body",
		},

	}

end,

}
