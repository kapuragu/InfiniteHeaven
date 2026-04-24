--[[FDOC
	@id CharaTppHeliGunEmplacement
	@category Script Character 
	@brief ヘリ機銃
]]--

CharaTppHeliGunEmplacement = {

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

	--Fox.Log( "CharaTppPhysicsObject>OnCreate()" )
	local charaObj = chara:GetCharacterObject()
	charaObj.gadgetType = 131072

	-- 使用者をアタッチする位置
	charaObj.attachPointName = "CNP_ppos"
	charaObj.attachPointType = "ATTACH_CONNECT_POINT"
	charaObj.attachPointOffset = Vector3( 0, 0, 0 )
	-- アタッチ位置はエイミング方向を考慮しない
	charaObj.aimRotateAffects = false
	-- 強制主観にする
	charaObj.forceSubjectiveMode = true

end,


AddGadgetPlugins = function( chara )

	--プラグインの生成
	chara:AddPlugins{
		
		
		-- 新武器システム対応Inventory
		"PLG_NEW_INVENTORY",
		TppMechaInventoryPlugin {
			name			= "NewInventory",
			weaponId		= "WP_HeliMachinegun",
			connectPointName = "CNP_awp_a",
		},

		------------------------------------------
		-- アクションプラグイン
		------------------------------------------

		-- 銃座アクションプラグイン
		"PLG_GADGET_EMPLACEMENT_ACTION",
		TppGadgetAttackEmplacementActionPlugin{
			name			= "AttackEmplacementAction",
			parent			= "ActionRoot",
			headName		= "CNP_REAR_SIGHT",
			leftHandName	= "CNP_LEFT_HAND",
			rightHandName	= "CNP_RIGHT_HAND",
			boneRotationType	= "ROT_BONE_WEAPON",
			boneNameDirection	= "SKL_001_GUNBASE",
			boneNameAngle		= "SKL_002_GUNBODY",
			boneNameAimRoot		= "SKL_005_ARM_E",
			isSleepStart	= true,
		},

	}

end,

}
