--[[FDOC
	@id CharaTppMortar
	@category Script Character 
	@brief サーチライト
]]--

--[[  配置スクリプト
Command.StartGroup()
local locator = Command.CreateData( Editor.GetInstance(), "ChCharacterLocatorData" )
local params = Command.CreateEntity( "TppAttackEmplacementLocatorParameter" )
local objectCreator = Command.CreateEntity( "TppAttackEmplacementObjectCreator" )
Command.SetProperty{ entity=locator, property="params", value=params }
Command.SetProperty{ entity=locator, property="objectCreator", value=objectCreator }
Command.SetProperty{ entity=locator, property="scriptPath", value="Tpp/Scripts/Gimmicks/CharaTppMortar.lua" }
Command.AddPropertyElement{ entity=params.fileResources, property="resources", key="parts" }
Command.SetProperty{ entity=params.fileResources, property="resources", key="parts", value="/Assets/tpp/parts/weapon/hew/hw00_main0_def.parts" }
Command.EndGroup()
--]]

CharaTppMortar = {

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
	charaObj.gadgetType = 2097152

end,

--[[ C++化済み

AddGadgetPlugins = function( chara )

	--プラグインの生成
	chara:AddPlugins{
		
		------------------------------------------
		-- アクションプラグイン
		------------------------------------------

		-- 銃座アクションプラグイン
		"PLG_GADGET_EMPLACEMENT_ACTION",
		TppGadgetAttackEmplacementActionPlugin{
			name			= "AttackEmplacementAction",
			parent			= "ActionRoot",
			
			--headName		= "CNP_LIGHT",
			leftHandName	= "CNP_LEFT_HAND",
			rightHandName	= "CNP_RIGHT_HAND",
			
			leftHandOffset	= 0.3,
			boneRotationType	= "ROT_BONE_GIMMICK",
			boneNameDirection	= "SKL_010_UNDER",
			boneNameAngle		= "SKL_010_UNDER",
			isSleepStart	= true,
		},

	}

end,
]]

}
