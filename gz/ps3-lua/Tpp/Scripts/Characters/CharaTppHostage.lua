------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tpp 捕虜キャラ
------------------------------------------------------------------------------------
CharaTppHostage = {

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
	"GroupBehavior",
	"Noise",
	"Sd",
},

---------------------------------
-- TPP専用のプラグインの生成などを行う
---------------------------------
pluginIndexEnumInfoName = "TppHostagePluginDefine",

AddTppPlugins = function( chara )

	chara:AddPlugins{
		--ステージ固有アクションプラグイン
		"PLG_SPECIAL_ACTION",
		ChSpecialActionPlugin{
			script			= "MgsConception/Scripts/Characters/Actions/ActSpecial.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			layerName		= "Lower",
			priority		= "SpecialAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Lower, TppPluginExclusiveGroup.Upper },
			isSleepStart	= true,
		},

		-- フルトン回収されるアクションプラグイン
		"PLG_FULTON_REVOCERD_ACTION",
		TppFultonRecoveredActionPlugin {
			name			= "FultonRecoveredAction",
			script			= "Tpp/Scripts/Characters/Actions/ActionTppFultonRecovered.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			layerName		= "Lower",
			priority		= "FultonRecoveredAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Lower },
			isSleepStart	= true,
		},
	}

end,

}
