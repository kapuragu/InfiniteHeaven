--[[FDOC
	@id CharaTppMob
	@category Ai Mob
	@brief ヘリパイロット定義スクリプト
	 * 利用するプラグイン・思考の定義。
--]]

CharaTppHeliPilot = {

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


----------------------------------------
--生成処理 OnCreate()
-- キャラクタ生成時に呼ばれる関数
-- プラグインの生成などを行う
----------------------------------------
OnCreate = function( chara )

	--Ch.Log( chara, "CharaTppMob : OnCreate" )

	-- ボイスタイプ取得
	local voiceType = "ene_a"

	--[[chara:InitPluginPriorities{
		"DemoAction",
		"BasicAction",
	}]]

	--プラグインの生成
	chara:AddPlugins {

		-- Bodyプラグイン
		ChBodyPlugin {
			name			= "Body",
			parts			= "parts",
--			animGraphLayer	= "animGraph",
			animGraphLayer	= "motionGraph",
			script			= "Tpp/Scripts/Characters/Bodies/BodyTppPilot.lua",
			maxMotionPoints = { 2 }, 
		},
		
		-- Attachプラグイン
		ChAttachPlugin {
			name			= "Attach",
		},
		
		-- MotionAdjustModuleプラグイン
		TppMotionAdjustModulePlugin{
			name			= "MotionAdjustModule",
			parent			= "Body",
		},

		-- PlanningOperatorプラグイン
		--AiPlanningOperatorPlugin {
		--	name			= "Planning",
		--	behavior		= "behavior",
		--	exclusiveGroups = { TppPluginExclusiveGroup.Operator }
		--},

		-- Adjustプラグイン
		--ChHumanAdjustPlugin {
		--	name			= "Adjust",
		--},

		-- Effectプラグイン
		--ChEffectPlugin {
		--	name			= "Effect",
		--	bodyPluginName	= "Body",
		--},

		----------------------------------------------------
		--ActionPlugin関連
		----------------------------------------------------

		-- ActionRootPlugin
		ChActionRootPlugin {
			name			= "ActionRoot",
		},

	}

end,

----------------------------------------
--初期化処理 OnReset()
-- リスポーン時など、パラメータ類の初期化が必要なタイミングで呼ばれる
-- パラメータの初期化などを行う
----------------------------------------
OnReset = function( chara )
	--Ch.Log( chara,  "CharaTppMob : OnReset" )
end,

----------------------------------------
--解放処理 OnRelease()
-- キャラクタの解放時によばれる
----------------------------------------
OnRelease = function( chara )
	--Ch.Log( chara,  "CharaTppMob : OnRelease" )
end,

----------------------------------------
--デバッグ処理の更新 OnUpdateDebug()
--　OnUpdateDescの後に呼ばれる（リリースでは呼ばれないので注意）
----------------------------------------
OnUpdateDebug = function( chara, desc )

	--敵兵共通・デバッグ更新処理
	TppNpcDebugUtility.UpdateDebugEnemyDesc( chara, desc )

end,

}