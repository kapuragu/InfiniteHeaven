--------------------------------------------------------------------------------
--! @file	CharaTppBreakableGenerator.lua
--! @brief プレイヤーが壊せるギミック
--------------------------------------------------------------------------------

CharaTppBreakableGenerator = {

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

--[[ C++化完了 dependSyncPointsはTppBreakableObjectすべてが移行しないとはずせない


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

	local charaObj = chara:GetCharacterObject()
	charaObj.gadgetType = 16


end,


AddGadgetPlugins = function( chara )

	--Fox.Log( "CharaTppBreakableGenerator>OnCreate()" )
	
	-- ギミック共通プラグイン
	--TppGadgetUtility.AddGadgetCommonPlugin(chara)

	-- アクションプラグイン追加
	CharaTppBreakableGenerator.AddActionPlugin(chara)

end, -- OnCreate = function()

-- アクションプラグイン追加
AddActionPlugin = function( chara )

	chara:AddPlugins {
		-- 破壊オブジェクトアクション
		"PLG_DESTRUCTIBLE_ACTION",
		TppGadgetDestructActionPlugin {
			name			= "DestructibleObjectAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			exclusiveGroups = { TppPluginExclusiveGroup.StateAction },
		},
	}
			
end,

----------------------------------------
--初期化処理 OnReset()
--　リスポーン時など、パラメータ類の初期化が必要なタイミングで呼ばれる
--　パラメータの初期化などを行う
----------------------------------------
OnReset = function( chara )


	if Fox.GetActMode() == "GAME" then
		-- 稼働音
		local plgSound = chara:FindPlugin( "ChSoundPlugin" )
		--plgSound:CallSound("PlayGeneratorLoop", ChConnectSoundObject{ eventName = "Play_sfx_m_light_generator_1_loop", })
		
		plgSound:CallSound(
			"PlayGeneratorLoop",
			ChSoundObject{
				eventName	= "Play_sfx_m_light_generator_1_loop",
				worldMatrix	= chara:GetWorldMatrix(),
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


	local plgLife = chara:FindPlugin( "ChLifePlugin" )
	if not Entity.IsNull(plgLife) then
		local life = plgLife:GetValue( "Strength" )
				
		if life:Get() < 0 or not Fox.GetActMode() == "GAME" then
			-- 稼働音停止
			local plgSound = chara:FindPlugin( "ChSoundPlugin" )
			plgSound:RequestToStoreSoundControl()   -- LastSoundが即消えしないようにする。
			plgSound:StopSound( "PlayGeneratorLoop" )       -- LoopSoundが残り続けないようにする。
			plgSound:CallSound(
					"PlayGeneratorEnd",
					ChConnectSoundObject{ eventName = "Play_sfx_m_light_generator_1_down", 
					worldMatrix	= chara:GetWorldMatrix(),
				}
			)
		end
	end
end,


]]


} -- CharaTppBreakableGenerator
