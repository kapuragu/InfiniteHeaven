--------------------------------------------------------------------------------
--! @file	CharaTppContainer.lua
--! @brief	ドラム缶 (Gagdetクラスで作成)
--------------------------------------------------------------------------------

--[[  配置スクリプト
Command.StartGroup()
local locator = Command.CreateData( Editor.GetInstance(), "ChCharacterLocatorData" )
local params = Command.CreateEntity( "TppBreakableObjectLocatorParameter" )
local objectCreator = Command.CreateEntity( "TppGadgetObjectCreator" )
Command.SetProperty{ entity=locator, property="params", value=params }
Command.SetProperty{ entity=locator, property="objectCreator", value=objectCreator }
Command.SetProperty{ entity=locator, property="scriptPath", value="Tpp/Scripts/Gimmicks/CharaTppContainer.lua" }
Command.EndGroup()
--]]

CharaTppContainer = {

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

	--Fox.Log( "CharaTppContainer>OnCreate()" )

	local charaObj = chara:GetCharacterObject()
	charaObj.gadgetType = 512


end,




AddGadgetPlugins = function( chara )
	-- アクションプラグイン追加
	CharaTppContainer.AddActionPlugin(chara)

end, -- OnCreate = function()

-- アクションプラグイン追加
AddActionPlugin = function( chara )

	chara:AddPlugins {
		
		-- フルトン回収されるアクションプラグイン
		"PLG_FULTON_RECOVERED_ACTION",
		TppFultonRecoveredActionPlugin {
			name			= "FultonRecoveredAction",
			script			= "Tpp/Scripts/Characters/Actions/ActionTppFultonRecovered.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			priority		= "FultonRecoveredAction",
			isSleepStart	= true,
		},	
	}


end,

]]

} -- CharaTppContainer
