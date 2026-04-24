--------------------------------------------------------------------------------
--! @file	CharaTppDestructionObject.lua
--! @brief 汎用破壊物(物理破壊)
--------------------------------------------------------------------------------


CharaTppDestructionObject = {

--[[ C++化済み
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

	--Fox.Log( "CharaTppDestructionObject>OnCreate()" )

	local charaObj = chara:GetCharacterObject()
	charaObj.gadgetType = 2048

end,



AddGadgetPlugins = function( chara )

	-- ギミック共通プラグイン
	--TppGadgetUtility.AddGadgetCommonPlugin(chara)
	
	-- アクションプラグイン追加
	CharaTppDestructionObject.AddActionPlugin(chara)

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
		},
	}

end,

--------------------------------
-- リアライズコールバック
--------------------------------
OnRealize = function(chara)

	-- 設定されているエフェクトコール
	local plgEffect = chara:FindPlugin( "ChEffectPlugin" )
	if plgEffect then
		plgEffect:CallEffect(
	        "BodyFireEffectObject",
	        ChPartsBuilderEffectObject{
				effectBuilderName = "fx_tst_firtstdes01lop_s0LG",
			}
		)
	end
	--chara:SetStop()
end,

----------------------------------------
--解放処理 OnRelease()
--　キャラクタの解放時によばれる
----------------------------------------
OnRelease = function( chara )
	
	local plgEffect = chara:FindPlugin( "ChEffectPlugin" )
	if plgEffect then
		plgEffect:StopEffect( "BodyFireEffectObject" )
	end
	--エフェクト終了、削除
	if plgEffect then
	    plgEffect:StopEffect( "TppModelEffect" )
	    --Fox.Log("StopEffect TppModelEffect")
	end	
end,

]]


} -- CharaTppDestructionObject
