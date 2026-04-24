--[[FDOC
	@id CharaTppMob
	@category Ai Mob
	@brief モブキャラクター定義スクリプト
	 * 利用するプラグイン・思考の定義。
--]]

CharaTppMob = {

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

pluginIndexEnumInfoName = "TppMobPluginIndexDefine",

----------------------------------------
--生成処理 OnCreate()
-- キャラクタ生成時に呼ばれる関数
-- プラグインの生成などを行う
----------------------------------------
OnCreate = function( chara )

	--Ch.Log( chara, "CharaTppMob : OnCreate" )

	-- ボイスタイプ取得
	local voiceType = "ene_a"

	chara:InitPluginPriorities{
		"SpecialAction",
		"DemoAction",
		"BasicAction",
	}

	--プラグインの生成
	chara:AddPlugins{

		-- Bodyプラグイン
		"MOB_PLG_BODY",
		ChBodyPlugin{
			name			= "Body",
			parts			= "parts",
			animGraphLayer	= "motionGraph",
			maxMotionPoints	= { 7 },
			geoAttributes	= { "ENEMY" },
		},

		--Attachプラグイン
		"MOB_PLG_ATTACH",
		ChAttachPlugin {
			name = "Attach",
		},
		
		-- PlanningOperatorプラグイン
		"MOB_PLG_PLANNING_OPERATOR",
		AiPlanningOperatorPlugin {
			name			= "Planning",
			behavior		= "behavior",
			exclusiveGroups = { TppPluginExclusiveGroup.Operator }
		},

		-- Navigationプラグイン
		"MOB_PLG_NAVIGATION",
		ChNavigationPlugin{
			name			= "Nav",
			sceneName		= "MainScene",
			worldName		= "",
			typeName		= "BasicController",
			radius			= 0.45,
			attribute		= {0,0,0,0},
			--mode			= "debug",
		},

		-- Knowledgeプラグイン
		"MOB_PLG_KNOWLEDGE",
		TppHumanEnemyKnowledgePlugin{
			name			= "Knowledge",
		},

		-- Routeプラグイン
		"MOB_PLG_ROUTE",
		AiRoutePlugin{
			name			= "Route",
		},

		-- Adjustプラグイン
		"MOB_PLG_HUMAN_ADJUST",
		ChHumanAdjustPlugin{
			name			= "Adjust",
		},

		-- Voiceプラグイン
		"MOB_PLG_VOICE",
		ChVoicePlugin2{
			name				= "Voice",
			characterType		= "Enemy",
			basicArgs			= voiceType,
			connectPointName	= "CNP_MOUTH",
		},		

		-- Effectプラグイン
		"MOB_PLG_EFFECT",
		ChEffectPlugin {
			name			= "Effect",
			bodyPluginName	= "Body",
		},

		----------------------------------------------------
		--ActionPlugin関連
		----------------------------------------------------

		-- ActionRootPlugin
		"MOB_PLG_ACTION_ROOT",
		ChActionRootPlugin{
			name			= "ActionRoot",
		},

		-- デモアクションプラグイン
		"MOB_PLG_DEMO_ACTION",
		ChDemoActionPlugin{
			name			= "DemoAction",
			script			= "Tpp/Scripts/Characters/Actions/ActionTppDemo.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			layerName		= "Lower",
			priority		= "DemoAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Lower, TppPluginExclusiveGroup.Upper },
			isSleepStart	= true,
		},

		--ステージ固有アクションプラグイン
		"MOB_PLG_SPECIAL_ACTION",
		ChSpecialActionPlugin{
			script			= "MgsConception/Scripts/Characters/Actions/ActSpecial.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			layerName		= "Lower",
			priority		= "SpecialAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Lower, TppPluginExclusiveGroup.Upper },
			isSleepStart	= true,
		},

		-- 基本アクションプラグイン
		"MOB_PLG_BASIC_ACTION",
		TppBasicActionPlugin {
			name			= "BasicAction",
			script			= "Tpp/Scripts/Characters/Actions/ActionTppMobBasic.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			layerName		= "Lower",
			priority		= "BasicAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Lower },
			isAlwaysAwake	= true,
		},
	}

	-- 敵兵タイプ登録
	local desc = chara:GetCharacterDesc()
	desc:SetEnemyType( "Mob" )

	-- サウンドコンポーネントセットアップ
	local charaObject = chara:GetCharacterObject()
	charaObject:SetupSoundComponent{
		eventConvertScript = "/Assets/tpp/sound/scripts/chara/SoundTppSoldier.lua", -- 足音初期設定スクリプト
	}

end,

----------------------------------------
--初期化処理 OnReset()
-- リスポーン時など、パラメータ類の初期化が必要なタイミングで呼ばれる
-- パラメータの初期化などを行う
----------------------------------------
OnReset = function( chara )
	--Ch.Log( chara,  "CharaTppMob : OnReset" )
end,

----------------------------------------
--解放処理 OnRelease()
-- キャラクタの解放時によばれる
----------------------------------------
OnRelease = function( chara )
	--Ch.Log( chara,  "CharaTppMob : OnRelease" )
end,

----------------------------------------
--デバッグ処理の更新 OnUpdateDebug()
--　OnUpdateDescの後に呼ばれる（リリースでは呼ばれないので注意）
----------------------------------------
OnUpdateDebug = function( chara, desc )

	--敵兵共通・デバッグ更新処理
	TppNpcDebugUtility.UpdateDebugEnemyDesc( chara, desc )

end,

}