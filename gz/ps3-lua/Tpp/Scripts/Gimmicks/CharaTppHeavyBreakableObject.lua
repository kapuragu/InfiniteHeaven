--------------------------------------------------------------------------------
--! @file	CharaTppHeavyBreakableObject.lua
--! @brief プレイヤーがインタラクションできる物理物 (Gagdetクラスで作成)
--------------------------------------------------------------------------------


CharaTppHeavyBreakableObject = {

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
	"Nav",
	"Sd",
	"Noise",
},


pluginIndexEnumInfoName = "TppGadgetPluginDefine",

--------------------------------------------------------------------------------
-- callback function
--------------------------------------------------------------------------------
----------------------------------------
--! @brief 生成処理 OnCreate()
--!			キャラクタ生成時に呼ばれる関数. プラグインの生成などを行う
--! @param chara
----------------------------------------
OnCreate = function( chara )

	--Fox.Log( "CharaTppPhysicsObject>OnCreate()" )
	local charaObj = chara:GetCharacterObject()
	charaObj.gadgetType = 65536

end,

--[[ C++化済み

AddGadgetPlugins = function( chara )

	-- ギミック共通プラグイン
	--TppGadgetUtility.AddGadgetCommonPlugin(chara)
	
	-- アクションプラグイン追加
	CharaTppHeavyBreakableObject.AddActionPlugin(chara)

end, -- OnCreate = function()


-- アクションプラグイン追加
AddActionPlugin = function( chara )

	chara:AddPlugins {

		-- 物理挙動プラグイン
		"PLG_GADGET_PHYSICS_ACTION",
		TppGadgetPhysicsActionPlugin {
			name			= "PhysicsAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			isStopChara		= false,	-- 物理停止時に親も停止
			isSetupPhObject = false,
			isHeavy			= true,		-- 車でしか動かせない物理
			isSleepStart	= true,
		},

	}
end,

]]

} -- CharaTppPhysicsObject
