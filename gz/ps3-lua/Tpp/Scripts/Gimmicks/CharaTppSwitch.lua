--------------------------------------------------------------------------------
--! @file	CharaTppSwitch.lua
--! @brief	スイッチギミック
--------------------------------------------------------------------------------

--[[  配置スクリプト
Command.StartGroup()
local locator = Command.CreateData( Editor.GetInstance(), "ChCharacterLocatorData" )
local params = Command.CreateEntity( "TppSwitchGadgetLocatorParameter" )
local objectCreator = Command.CreateEntity( "TppGadgetObjectCreator" )
Command.SetProperty{ entity=locator, property="params", value=params }
Command.SetProperty{ entity=locator, property="objectCreator", value=objectCreator }
Command.SetProperty{ entity=locator, property="scriptPath", value="Tpp/Scripts/Gimmicks/CharaTppSwitch.lua" }
Command.AddPropertyElement{ entity=params.fileResources, property="resources", key="parts" }
Command.SetProperty{ entity=params.fileResources, property="resources", key="parts", value="/Assets/tpp/parts/environ/object/middle_africa/machine/mafr_mchn009/mafr_mchn009.parts" }
Command.EndGroup()
--]]

CharaTppSwitch = {


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
	charaObj.gadgetType = 33554432

end,


AddGadgetPlugins = function( chara )

	-- ギミック共通プラグイン
	--TppGadgetUtility.AddGadgetCommonPlugin(chara)

	-- プラグインの登録
	chara:AddPlugins {

		-- スイッチアクションプラグイン
		"PLG_GADGET_SWITCH_ACTION",
		TppGadgetSwitchActionPlugin{
			name			= "SwitchAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			isAlwaysAwake	= true,
		},

	}
end, -- OnCreate = function()

]]

} -- CharaTppSwitch
