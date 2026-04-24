--[[FDOC
	@id CharaTppAntiAircraftGun
	@category Script Character 
	@brief 対空機関砲
]]--

--[[  配置スクリプト
Command.StartGroup()
local locator = Command.CreateData( Editor.GetInstance(), "ChCharacterLocatorData" )
local params = Command.CreateEntity( "TppAttackEmplacementLocatorParameter" )
local objectCreator = Command.CreateEntity( "TppAttackEmplacementObjectCreator" )
Command.SetProperty{ entity=locator, property="params", value=params }
Command.SetProperty{ entity=locator, property="objectCreator", value=objectCreator }
Command.SetProperty{ entity=locator, property="scriptPath", value="Tpp/Scripts/Gimmicks/CharaTppAntiAircraftGun.lua" }
Command.AddPropertyElement{ entity=params.fileResources, property="resources", key="parts" }
Command.SetProperty{ entity=params.fileResources, property="resources", key="parts", value="/Assets/tpp/parts/mecha/nad/nad0_main0_def.parts" }
Command.EndGroup()
--]]

--[[ ターゲット
	MainBody
	Radar
	Barrel
]]

CharaTppAntiAircraftGun = {

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
	charaObj.gadgetType = 8

	charaObj.attachPointName = "CNP_ppos_a";
	charaObj.attachPointType = ATTACH_CONNECT_POINT;

	-- 使用者をアタッチする位置
	charaObj.attachPointOffset = Vector3( 0.0, 0.0, 0.0 )
	-- アタッチ位置はエイミング方向を考慮しない
	charaObj.aimRotateAffects = false
	

end,

--[[ C++化済み

AddGadgetPlugins = function( chara )	
	
	local params = chara:GetParams()

	--プラグインの生成
	chara:AddPlugins{
		
		--Bodyプラグイン
		"PLG_BODY",
		ChBodyPlugin {
			name					= "Body",
			parts					= "parts",
			asStaticModel			= true,
			damageSet				= "damageSet",
			hasGravity				= false,
			useCharacterController	= false,
			priority				= "Body",
			motionLayers 	= { "Ammo" },
			maxMotionJoints = { 8 },
		},


		------------------------------------------
		-- アクションプラグイン
		------------------------------------------
		
		-- 銃座アクションプラグイン
		"PLG_GADGET_EMPLACEMENT_ACTION",
		TppGadgetGatlingGunEmplacementActionPlugin {
			name			= "EmplacementAction",
			parent			= "ActionRoot",

			headName		= "CNP_REAR_SIGHT",
			leftHandName	= "CNP_LEFT_HAND",
			rightHandName	= "CNP_RIGHT_HAND",
			
			boneRotationType	= "ROT_BONE_GIMMICK",
			boneNameDirection	= "SKL_001_TURRET",
			boneNameAngle		= "SKL_004_SEAT",
			
			--boneNameAimRoot	= "SKL_004_SEAT",
			--leftHandOffset	= 0.3,
			
			isSleepStart	= true,
		},
	}
end,
]]

}
