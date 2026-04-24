--------------------------------------------------------------------------------
--! @file	CharaTppEquipment.lua
--! @brief	キャラ生成スクリプト / Primary, Secondary 武器
--------------------------------------------------------------------------------

CharaTppEquipment = {

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
},

pluginIndexEnumInfoName = "TppEquipmentPluginDefine",

OnCreate = function( chara )

	-- プラグイン初期化

	chara:AddPlugins {

		--	モデル／アニメーションの管理(ChBodyPlugin)
		"PLG_BODY",
		ChBodyPlugin{
			name			= "Body",
			motionLayers 	= { "Full", },
			useCharacterController	= false,
		},

		-- Attachment 追従
		"PLG_ATTACH",
		TppAttachmentAttachPlugin {
			name		= "Attach",
		},

		-- アクションプラグイン
		"PLG_ACTION_ROOT",
		ChActionRootPlugin{
			name			= "ActionRoot",
		},

		-- 武器 銃器用 キャラクタ使用アクションプラグイン (発砲・リロードなど)
		"PLG_GUN_ACTION",
		TppNewGunActionPlugin {
			name			= "GunAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			isSleepStart		= true,
			reticleUiGraphName	= "/Assets/tpp/ui/GraphAsset/StageGame/Weapon/Reticle/reticle_base.uig"
		},

	}

	chara:SetUpdateDescWhenStoppingFlag( true )

end,

}