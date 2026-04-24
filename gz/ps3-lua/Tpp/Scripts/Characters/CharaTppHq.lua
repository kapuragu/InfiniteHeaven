--[[FDOC
	@id 		CharaTppHq
	@category 	Character Definition
	@brief		TppHqキャラクタ定義
]]

CharaTppHq = {

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
	"Nt",
	"Sd",
	"Noise",
	"GroupBehavior",
},

pluginIndexEnumInfoName = "TppHqPluginIndexDefine",

----------------------------------------
--生成処理 OnCreate()
--　キャラクタ生成時に呼ばれる関数
--　プラグインの生成などを行う
----------------------------------------
OnCreate = function( chara )

	--Ch.Log( chara,  "##### OnCreate() #####" );

	local behavior          = ""
	local behaviorGraphName = "Hq"
	if Ai.DoesUseAibFile() then
		behavior          = "behavior"
		behaviorGraphName = ""
	end

	--プラグインの生成
	chara:AddPlugins{

		--Squadプラグイン
		"HQ_PLG_SQUAD",
		TppSquadTppHqPlugin{
			name			= "Squad",		--分隊管理くん
		},

		--CoopBehaviorプラグイン(Group Behavior)
		"HQ_PLG_GROUP_BEHAVIOR",
		ChGroupBehaviorPlugin{
			name			= "GroupBehavior",
		},

		--Knowledgeプラグイン
		"HQ_PLG_KNOWLEDGE",
		AiKnowledgePlugin{
			name 			= "Knowledge",
		},

		--PlanningOperatorプラグイン
		"HQ_PLG_PLANNING_OPERATOR",
		AiPlanningOperatorPlugin {
			name			= "GoalPlanning",
			planStepCount		= TppHq.PlanMaxStepCount,
			planValueCount		= TppHq.PlanVaribleSetMaxValueCount,
			behavior		= behavior,
			behaviorGraphName	= behaviorGraphName,
		},

		--Voiceプラグイン
		"HQ_PLG_VOICE",
		ChVoicePlugin2{
			name			= "Voice",
			characterType	= "HqSquad",
			basicArgs		= "hqc",
		},
	}
end,

----------------------------------------
--初期化処理 OnReset()
--　リスポーン時など、パラメータ類の初期化が必要なタイミングで呼ばれる
--　パラメータの初期化などを行う
----------------------------------------
--[[
OnReset = function( chara )
end,
--]]

----------------------------------------
--リアライズ処理 OnRealize()
--　リアライズ時に呼ばれる
--　chara:GetParams()が必要な初期化処理はここへ
----------------------------------------
--[[
OnRealize = function( chara )
	-- パラメータ取得
	local params = chara:GetParams()
end,
--]]

----------------------------------------
--解放処理 OnRelease()
--　キャラクタの解放時によばれる
----------------------------------------
--[[
OnRelease = function( chara )
end,
--]]

----------------------------------------
--公開情報の更新 OnUpdaetDesc()
--　ActorLevelの最後にまとめて呼ばれる
----------------------------------------
--[[
OnUpdateDesc = function( chara, desc )
end,
--]]

----------------------------------------
--デバッグ処理の更新 OnUpdateDebug()
--　OnUpdateDescの後に呼ばれる（リリースでは呼ばれないので注意）
----------------------------------------
--[[
OnUpdateDebug = function( chara, desc )
end,
--]]
}
