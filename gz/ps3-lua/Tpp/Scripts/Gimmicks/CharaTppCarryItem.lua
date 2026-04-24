--------------------------------------------------------------------------------
--! @file	CharaTppCarryItem.lua
--! @brief	破壊されたらアイテムになるギミック
--------------------------------------------------------------------------------

--[[  配置スクリプト
Command.StartGroup()
local locator = Command.CreateData( Editor.GetInstance(), "ChCharacterLocatorData" )
local params = Command.CreateEntity( "TppCarryItemLocatorParameter" )
local objectCreator = Command.CreateEntity( "TppCarryItemObjectCreator" )
Command.SetProperty{ entity=locator, property="params", value=params }
Command.SetProperty{ entity=locator, property="objectCreator", value=objectCreator }
Command.SetProperty{ entity=locator, property="scriptPath", value="Tpp/Scripts/Gimmicks/CharaTppCarryItem.lua" }
Command.AddPropertyElement{ entity=params.fileResources, property="resources", key="parts" }
Command.SetProperty{ entity=params.fileResources, property="resources", key="parts", value="/Assets/tpp/parts/weapon/mis/ms03_case0_def.parts" }
Command.AddPropertyElement{ entity=params.fileResources, property="resources", key="damageSet" }
Command.SetProperty{ entity=params.fileResources, property="resources", key="damageSet", value="/Assets/tpp/parts/gadget/gadget_com_dmgset.fdmg" }
Command.EndGroup()
--]]

CharaTppCarryItem = {

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

	--Fox.Log( "CharaTppDestructionObject>OnCreate()" )

	local charaObj = chara:GetCharacterObject()
	charaObj.gadgetType = 256

end,



AddGadgetPlugins = function( chara )

	-- プラグインの登録
	chara:AddPlugins {
		-- Body プラグイン
		"PLG_BODY",
		ChBodyPlugin {
			name			= "Body",
			parts			= "parts",
			maxMotionJoints = {3},
			useCharacterController = false,
		},
	}
end, -- OnCreate = function()

]]

} -- CharaTppDestructionObject
