--------------------------------------------------------------------------------
--! @file	CharaTppOilDrum.lua
--! @brief	ドラム缶 (Gagdetクラスで作成)
--------------------------------------------------------------------------------

--[[  配置スクリプト
Command.StartGroup()
local locator = Command.CreateData( Editor.GetInstance(), "ChCharacterLocatorData" )
local params = Command.CreateEntity( "TppGadgetLocatorParameter" )
local objectCreator = Command.CreateEntity( "TppGadgetObjectCreator" )
Command.SetProperty{ entity=locator, property="params", value=params }
Command.SetProperty{ entity=locator, property="objectCreator", value=objectCreator }
Command.SetProperty{ entity=locator, property="scriptPath", value="Tpp/Scripts/Gimmicks/CharaTppOilDrum.lua" }
Command.EndGroup()
--]]

CharaTppOilDrum = {

--[[ C++化完了
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
	"Nav",
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

	--Fox.Log( "CharaTppBreakableObject>OnCreate()" )

	local charaObj = chara:GetCharacterObject()
	charaObj.gadgetType = 4194304

end,



AddGadgetPlugins = function( chara )

	-- ギミック共通プラグイン
	--TppGadgetUtility.AddGadgetCommonPlugin(chara)

	-- アクションプラグイン追加
	CharaTppOilDrum.AddActionPlugin(chara)

end, -- OnCreate = function()

-- アクションプラグイン追加
AddActionPlugin = function( chara )

	chara:AddPlugins {

		--バウンダープラグイン
		ChBounderPlugin{
			name			= "Bounder",
			sceneName		= "MainScene",
	        bounders        = {
	                { worldName = "" },
	        },
			isEnable		= true,		-- 初期状態での有効・無効フラグ,
		},
	}
			
end,
]]

} -- CharaTppOilDrum
