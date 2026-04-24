--[[FDOC
	@id CharaTppSearchLight
	@category Script Character 
	@brief サーチライト
]]--

--[[  配置スクリプト
Command.StartGroup()
local locator = Command.CreateData( Editor.GetInstance(), "ChCharacterLocatorData" )
local params = Command.CreateEntity( "TppSearchLightObjectLocatorParameter" )
local objectCreator = Command.CreateEntity( "TppSearchLightObjectCreator" )
Command.SetProperty{ entity=locator, property="params", value=params }
Command.SetProperty{ entity=locator, property="objectCreator", value=objectCreator }
Command.SetProperty{ entity=locator, property="scriptPath", value="Tpp/Scripts/Gimmicks/CharaTppSearchLight.lua" }
Command.AddPropertyElement{ entity=params.fileResources, property="resources", key="parts" }
Command.SetProperty{ entity=params.fileResources, property="resources", key="parts", value="/Assets/tpp/parts/environ/object/guantanamo/searchlight/gntn_srlg001/gntn_srlg001_gm.parts" }
Command.EndGroup()
--]]

CharaTppSearchLight = {

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
	charaObj.gadgetType = 16777216

	-- 使用者をアタッチする位置
	--charaObj.attachPointOffset = Vector3( 0.06, 0, -0.68 )
	-- アタッチ位置はエイミング方向を考慮しない
	charaObj.aimRotateAffects = false


end,



--[[ C++化済み

AddGadgetPlugins = function( chara )

	--プラグインの生成
	chara:AddPlugins{

		------------------------------------------
		-- アクションプラグイン
		------------------------------------------
		-- 設置物ギミックアクションプラグイン
		"PLG_GADGET_EMPLACEMENT_ACTION",
		TppGadgetEmplacementActionPlugin{
			name			= "EmplacementAction",
			parent			= "ActionRoot",
			
			headName		= "CNP_LIGHT",
			rightHandName	= "CNP_RIGHT_HAND",
			leftHandName	= "CNP_LEFT_HAND",
			
			leftHandOffset	= 0.3,
			boneRotationType	= "ROT_BONE_GIMMICK",
			boneNameDirection	= "SKL_001_branch",
			boneNameAngle		= "SKL_002_head",
			isSleepStart	= true,
		},
		
		
		-- ライト管理プラグイン
		"PLG_LIGHT_ACTION",
		TppLightActionPlugin{
			name			= "LightAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			isSleepStart	= false,
			needUpdateAlways = true,	-- マトリクス更新を常に行うか
		
			lights = {
				{
					registerName	= "SearchLight",	-- ライトの管理名
					light = TppLightObject{
								lightName = "SearchLight",	-- ライト名（カモフラへの影響タイプ分類も兼ねる）
								type = "Spot",				-- ライトの形
								range = 65.0,				-- 照射距離
								angle = 0.10,				-- 角度
								owner = chara,				-- 所有者
							},
					effectName	= "SearchLight",	-- エフェクト名（ビルダー名）
					attachPoint	= "CNP_LIGHT",	-- 付随ポイント名（ コネポ or 骨 ）
					switchOn	= false,		-- 初期点灯状態
				},
			},
		},
		
	}

end,
]]

}
