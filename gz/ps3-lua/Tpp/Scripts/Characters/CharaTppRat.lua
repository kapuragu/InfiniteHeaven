----------------------------------------------------------------
-- Tpp 犬(実験用)
----------------------------------------------------------------
CharaTppRat = {

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
	"Fx",
	"Nt",
	"Sd",
	"Noise",
},

pluginIndexEnumInfoName = "TppRatPluginDefine",

--Cへ移動済み
__OnCreate = function( chara )

	chara:InitPluginPriorities {
		"BasicAction",
	}

	chara:AddPlugins {
	
		-- Bodyプラグイン
		"PLG_BODY",
		ChBodyPlugin{
			name = "Body",
			parts = "parts",
			animGraphLayer	= "motionGraph",
            hasTurnXYZ = true,
            geoAttributes = { "ENEMY" },
			maxMotionJoints = {17},
			hasTranslations = { true },
			maxMtarFiles = 1,
		},

		--モーション速度だけ変化させるプラグイン --
		"PLG_MOTION_SPEED",
		TppCharacterMotionSpeedPlugin {
			name = "TppCharacterMotionSpeed",
			bodyPluginName = "Body"
		},		

		---------------------------------------------------------------------------------------------------
		-- 以下、ActionPlugin関連
		---------------------------------------------------------------------------------------------------		

		"PLG_ACTION_ROOT",
		ChActionRootPlugin {
			name = "ActionRoot",
		},

		
		"PLG_RAT_ACTION",
                TppRatActionPlugin
		{
			name			=	"BasicAction",
			parent			=	"ActionRoot",
			bodyPlugin		=	"Body",
			layerName		=	"Full",
			priority		=	"BasicAction",
		},

        "PLG_ROUTE",
        AiRoutePlugin
        {
          name = "Route",
        },
	}

end,

}
