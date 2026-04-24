--------------------------------------------------------------------------------
--! @file	CharaTppCurtain.lua
--! @brief	カーテン (TppAnimateObjectクラスで作成)
--------------------------------------------------------------------------------

--[[  配置スクリプト
Command.StartGroup()
local locator = Command.CreateData( Editor.GetInstance(), "ChCharacterLocatorData" )
local params = Command.CreateEntity( "TppAnimateObjectLocatorParameter" )
local objectCreator = Command.CreateEntity( "TppAnimateObjectCreator" )
Command.SetProperty{ entity=locator, property="params", value=params }
Command.SetProperty{ entity=locator, property="objectCreator", value=objectCreator }
Command.SetProperty{ entity=locator, property="scriptPath", value="Tpp/Scripts/Gimmicks/CharaTppCurtain.lua" }
Command.AddPropertyElement{ entity=params.fileResources, property="resources", key="parts" }
Command.SetProperty{ entity=params.fileResources, property="resources", key="parts", value="/Assets/tpp_sandbox/level/weapon/CurtainTest.parts" }
Command.SetProperty{ entity=params.fileResources, property="resources", key="motion", value="/Assets/tpp_sandbox/motion/SI_game/fani/env/envt/envtest/envtest_cypr_crtn02_vrtn6_gim.gani" }
Command.EndGroup()
--]]

CharaTppCurtain = {

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

	local charaObj = chara:GetCharacterObject()
	charaObj.gadgetType = 1024


end,


AddGadgetPlugins = function( chara )


	--プラグインの生成
	chara:AddPlugins{

		-- カーテンアクションプラグイン
		"PLG_GADGET_CURTAIN_ACTION",
		TppGadgetCurtainActionPlugin{
			name	= "GadgetCurtainAction",
			parent			= "ActionRoot",
			priority		= "CurtainAction",
			bodyPlugin		= "Body",
			isAlwaysAwake	= true,
		},

	}

end,

]]

}
