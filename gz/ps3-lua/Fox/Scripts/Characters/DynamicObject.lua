--[[FDOC
	@id DynamicObject
	@category Script Character 
	@brief 単純なモーション再生オブジェクト
]]--
DynamicObject = {

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
	"Sd",
	"Noise",
},


----------------------------------------
--生成処理 OnCreate()
--　キャラクタ生成時に呼ばれる関数
--　プラグインの生成などを行う
----------------------------------------
OnCreate = function( chara )

	chara:InitPluginPriorities {
		"Body",
		
		"DemoAction",
		"NormalAction",
	}

	--プラグインの生成
	chara:AddPlugins{

		--Bodyプラグイン
		ChBodyPlugin{
			parts			= "parts",
			damageSet		= "damageSet",
			--animGraphLayer	= "motionGraph",
			motionLayers 	= {"Full",},
			hasGravity = false,
			useCharacterController = false,
			
			priority		= "Body",
		},

		--[[ Target プラグイン
		ChTargetPlugin {
			name 			= "Target",
			bodyPlugin		= "Body",
			partsName		= { "Target", },
			plgDamage		= "Damage",
			targetGroup		= { "OBJECT", },
		},
	
		ChDamagePlugin {
			name			= "Damage",
			script			= "MgsConception/Scripts/Characters/Damages/DamageDummyRoute.lua",
		},]]

		------------------------------------------
		-- アクションプラグイン
		------------------------------------------

		--ActionRootPlugin
		ChActionRootPlugin{
			name			= "ActionRoot",
		},
		
		--DemoActionプラグイン
		ChDemoActionPlugin{
			--script			= "Fox/Scripts/Characters/DemoActionPlugin.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "MainBody",
			--layerName		= "Full",
			priority		= "DemoAction",
			tags			= { "Editor", },
			
			isSleepStart		= true,
		},
		
		--基本アクション
		ChActionPlugin{
			name			= "BasicAction",
			parent			= "ActionRoot",
			priority		= "NormalAction",
		},

	}

end,


----------------------------------------
--初期化処理 OnReset()
--　リスポーン時など、パラメータ類の初期化が必要なタイミングで呼ばれる
--　パラメータの初期化などを行う
----------------------------------------
OnReset = function( chara )

	local plgBody = chara:FindPlugin( "ChBodyPlugin" )
	--local params = chara:GetParams()

	if not Entity.IsNull( plgBody ) then

		local locator = chara:GetLocatorHandle()
		local fileResources = locator.params.fileResources

		local motion = ""
		local motionKey = "motion"

		if fileResources.resources[ motionKey ] ~= nil
		and fileResources.resources[ motionKey ] ~= ""
		and fileResources.resources[ motionKey ] ~= "Null File" then
			motion = motionKey
			plgBody:SetMotion( "Full", motion )
		end

		--if params.hasGravity or params.hasCollision then
		--	local control = plgBody:GetControl()
		--	control:SetSize( params.controlRadius, params.controlHeight )
		--end
	end

end,

}
