--------------------------------------------------------------------------------
--! @file	CharaTppBreakableGenerator.lua
--! @brief プレイヤーが壊せるギミック
--------------------------------------------------------------------------------

CharaTppBreakSwitchGenerator = {


-- CharacterInstance生成スクリプト
--[[
Command.StartGroup()
local instance = Command.CreateData( Editor.GetInstance(),"ChCharacterInstance" )
Command.SetProperty{ entity=instance, property="name", value="GeneratorInstance" }
local factory = Command.CreateEntity( "TppBreakableObjectFactory" )
Command.SetProperty{ entity=instance, property="factory", value=factory }
Command.SetProperty{ entity=factory, property="scriptPath", value="Tpp/Scripts/Gimmicks/CharaTppBreakSwitchGenerator.lua" } 
-- Characterを生成する数を設定します。（下記は１つの場合）
Command.SetProperty{ entity=instance, property="size", value=1 }
Command.EndGroup()
--]]

-- CharacterLocator生成スクリプト
--[[
Command.StartGroup()
local locator = Command.CreateData( Editor.GetInstance(),"ChCharacterLocatorData" )
Command.SetProperty{ entity=locator, property="name", value="GeneratorLocator" }
Command.SetProperty{ entity=locator, property="scriptPath", value="Tpp/Scripts/Gimmicks/CharaTppBreakSwitchGenerator.lua" }
local params = Command.CreateEntity( "TppBreakableObjectParameter" )
Command.SetProperty{ entity=locator, property="params", value=params }
Command.EndGroup()
--]]

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



--[[ C++化完了

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

	--Fox.Log( "CharaTppBreakableGenerator>OnCreate()" )
	
	local charaObj = chara:GetCharacterObject()
	charaObj.gadgetType = 128

end,



AddGadgetPlugins = function( chara )

	-- ギミック共通プラグイン
	--TppGadgetUtility.AddGadgetCommonPlugin(chara)

	-- アクションプラグイン追加
	CharaTppBreakSwitchGenerator.AddActionPlugin(chara)

end, -- OnCreate = function()

-- アクションプラグイン追加
AddActionPlugin = function( chara )

	chara:AddPlugins {
		-- スイッチアクションプラグイン
		"PLG_GADGET_SWITCH_ACTION",
		TppBreakableGadgetSwitchActionPlugin{
			name			= "SwitchAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			isAlwaysAwake	= true,
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
