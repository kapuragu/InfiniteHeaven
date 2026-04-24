--------------------------------------------------------------------------------
-- Squadスクリプト
--------------------------------------------------------------------------------
CharaTppSubSquad = {

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
	"Nav",
	"GroupBehavior",
},

pluginIndexEnumInfoName = "TppSquadPluginIndexDefine",

--Cへ移動済み
----------------------------------------
--生成処理 OnCreate()
--　キャラクタ生成時に呼ばれる関数
--　プラグインの生成などを行う
----------------------------------------
__OnCreate = function( chara )

	--プラグインの生成

	local behavior          = ""
	local behaviorGraphName = "SubSquad"
	if Ai.DoesUseAibFile() then
		behavior          = "Tpp/Scripts/Characters/AiBehavior/SubSquad/AiBehaviorTppSubSquad.aib"
		behaviorGraphName = ""
	end

	-- OrderFact有効時/無効時 共通
	chara:AddPlugins{

		--Squadプラグイン
		"SQUAD_PLG_SQUAD",
		TppSquadSubSquadPlugin{
			name			= "Squad",
--			isActiveInCharaStopping = true,
		},

		--PlanningOperatorプラグイン
		"SQUAD_PLG_PLANNING_OPERATOR",
		AiPlanningOperatorPlugin{
			name				= "Planning",
			planStepCount		= TppSquad.PlanMaxStepCount,
			planValueCount		= TppSquad.PlanVaribleSetMaxValueCount,
			behavior			= behavior,
			behaviorGraphName	= behaviorGraphName,
			exclusiveGroups		= { TppPluginExclusiveGroup.Operator },
			blackboard			= TppSquadAiBlackboard(),
		},
		
	}

	-- OrderFact無効時専用
	local plgPlan = chara:FindPlugin("AiPlanningOperatorPlugin")
	local bb = plgPlan:GetPlanExecuter():GetBlackboard()
	if not bb.useOrderFact then
		chara:AddPlugins{

			--Knowledgeプラグイン
			"SQUAD_PLG_KNOWLEDGE",
			AiKnowledgePlugin{
				name 			= "Knowledge",
			},

		}
	end

	-- OrderFact有効時/無効時 共通
	chara:AddPlugins{
		
		--GroupBehaviorプラグイン
		"SQUAD_PLG_GROUP_BEHAVIOR",
		ChGroupBehaviorPlugin{},
		
		-- 【隊列移動関連】
		-- Navigationプラグイン
		"SQUAD_PLG_NAVIGATION",
		ChNavigationPlugin{
			name			= "Nav",
			sceneName		= "MainScene",
			worldName		= "",
			typeName		= "BasicController",
			turningRadii	= {0.5,1.0},
			radius			= 0.45,
			attribute		= {0,0,0,0},
			--mode			= "debug",
		},
		
		-- Routeプラグイン
		"SQUAD_PLG_ROUTE",
		AiRoutePlugin{
			name			= "Route",
		},
		
		-- SubSquadMoveプラグイン
		"SQUAD_PLG_SUB_SQUAD_MOVE",
		TppSubSquadMovePlugin{
			name			= "SubSquadMove",
			isSleepStart	= true,
		},
		
		-- SubSquadMoveプラグイン
		"SQUAD_PLG_SUB_SQUAD_ROUTE_MOVE",
		TppSubSquadRouteMovePlugin{
			name			= "SubSquadRouteMove",
			isSleepStart	= true,
		},
		
	}

	--保持しておくフォーメーション追加
	local desc = GkBasicTacticalSensorLayoutDesc{}
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

--Cへ移動済み
----------------------------------------
--リアライズ処理 OnRealize()
--　リアライズ時に呼ばれる
--　chara:GetParams()が必要な初期化処理はここへ
----------------------------------------
__OnRealize = function( chara )
	-- パラメータ取得
	local params = chara:GetParams()
	
	-- AI関連パラメータ
	params.dictateGrenadeWaitMin = 10.0
	params.probDictateGrenadeMin = 0.3
	params.dictateGrenadeWaitMax = 30.0
	params.checkGrenadeWaitTime = 1.0
	params.enableThrowGrenadeLength = 40.0
	params.isUseAroundBhdShift = true
	params.aroundBhdShiftStartWait = 1.0
	
	-- コンバット用デフォルトパラメータあれば上書き
	local gameDefaultData = TppDefaultParameter.GetDataFromGroupName( "TppEnemyCombatDefaultParameter" )
	if gameDefaultData ~= NULL and gameDefaultData ~= nil then
		local gameDefaultParams = gameDefaultData:GetParam( "params" )
		if gameDefaultParams ~= NULL then
			params.isThrowGrenade = gameDefaultParams.isThrowGrenade
			params.dictateGrenadeWaitMin = gameDefaultParams.dictateGrenadeWaitMin
			params.probDictateGrenadeMin = gameDefaultParams.probDictateGrenadeMin
			params.dictateGrenadeWaitMax = gameDefaultParams.dictateGrenadeWaitMax
			params.checkGrenadeWaitTime = gameDefaultParams.checkGrenadeWaitTime
			params.enableThrowGrenadeLength = gameDefaultParams.enableThrowGrenadeLength
			params.isUseAroundBhdShift = gameDefaultParams.isUseAroundBhdShift
			params.aroundBhdShiftStartWait = gameDefaultParams.aroundBhdShiftStartWait
		end
	end
end,

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
--Debug表示等の更新
----------------------------------------
--[[
OnUpdateDebug = function( chara, desc )
end,
--]]

}
