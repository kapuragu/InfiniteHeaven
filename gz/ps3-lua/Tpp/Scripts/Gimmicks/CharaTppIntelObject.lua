--[[FDOC
	@id CharaTppIntelObject
	@category Script Character 
	@brief 情報ギミック
]]--

--[[  配置スクリプト
Command.StartGroup()
local locator = Command.CreateData( Editor.GetInstance(), "ChCharacterLocatorData" )
local params = Command.CreateEntity( "TppGadgetLocatorParameter" )
local objectCreator = Command.CreateEntity( "TppGadgetObjectCreator" )
Command.SetProperty{ entity=locator, property="params", value=params }
Command.SetProperty{ entity=locator, property="objectCreator", value=objectCreator }
Command.SetProperty{ entity=locator, property="scriptPath", value="Tpp/Scripts/Gimmicks/CharaTppIntelObject.lua" }
Command.AddPropertyElement{ entity=params.fileResources, property="resources", key="parts" }
Command.SetProperty{ entity=params.fileResources, property="resources", key="parts", value="/Assets/tpp/parts/weapon/mis/ms03_case0_def.parts" }
Command.EndGroup()
--]]

CharaTppIntelObject = {

--[[ C++化対応済み

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

----------------------------------------
--生成処理 OnCreate()
--　キャラクタ生成時に呼ばれる関数
--　プラグインの生成などを行う
----------------------------------------
OnCreate = function( chara )

	local charaObj = chara:GetCharacterObject()
	charaObj.gadgetType = 262144

end,


AddGadgetPlugins = function( chara )

	--プラグインの生成
	chara:AddPlugins{
		
		-- スイッチアクションプラグイン
		"PLG_GADGET_INTEL_ACTION",
		TppGadgetIntelActionPlugin{
			name			= "IntelAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			isAlwaysAwake	= true,
		},
	}

end,

]]

}
