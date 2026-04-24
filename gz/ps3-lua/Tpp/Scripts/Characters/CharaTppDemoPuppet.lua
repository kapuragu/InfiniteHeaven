--[[FDOC
	@id CharaTppDemoPuppet
	@category Script Character 
	@brief Demo人形
]]--
CharaTppDemoPuppet = {

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
	"Sd",
	"Fx",
},

pluginIndexEnumInfoName = "TppDemoPuppetPluginDefine",

----------------------------------------
--生成処理 OnCreate()
--　キャラクタ生成時に呼ばれる関数
--　プラグインの生成などを行う
----------------------------------------
OnCreate = function( chara )
	chara:InitPluginPriorities {
		"Body",
	}
	
	--プラグインの生成
	chara:AddPlugins{

		--Bodyプラグイン
		"PLG_BODY",
		ChBodyPlugin{
			name 			= "MainBody",
			parts			= "parts",
			motionLayers 	= {"Lower",},
			hasGravity		= false,
			useCharacterController = false,
			hasScaleAnimation	= true,
			hasTranslations = { true },
			maxMotionJoints = {21},
			maxMotionPoints = {21},
			priority		= "Body",
		},

		--AttachPlugin
		"PLG_ATTACH",
		ChAttachPlugin {
			name = "Attach",
		},
		
		--ActionRootPlugin
		"PLG_ACTION_ROOT",
		ChActionRootPlugin{
			name			= "ActionRoot",
		},

		--FacialPlugin
		"PLG_FACIAL",
		ChFacialPlugin {
			name		= "Facial",
			parent		= "MainBody",
			maxMotionJoints     = { 39, 20 },
			maxShaderNodes      = { 7, 7 },
			maxShaderAnimations = { 2, 2 },
			interpTime	= 60.0,
		},

		--EffectPlugin
		"PLG_EFFECT",
		ChEffectPlugin {
			name 		= "Effect",
			parent		= "MainBody",
		},
	}

end,


----------------------------------------
--初期化処理 OnReset()
--　リスポーン時など、パラメータ類の初期化が必要なタイミングで呼ばれる
--　パラメータの初期化などを行う
----------------------------------------
OnReset = function( chara )
	
end,
}
