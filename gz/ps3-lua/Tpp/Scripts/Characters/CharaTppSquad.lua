--------------------------------------------------------------------------------
-- Squadスクリプト
--------------------------------------------------------------------------------
CharaTppSquad = {

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
},

pluginIndexEnumInfoName = "TppSquadPluginIndexDefine",

--Cへ移動済み
----------------------------------------
--生成処理 OnCreate()
--　キャラクタ生成時に呼ばれる関数
--　プラグインの生成などを行う
----------------------------------------
__OnCreate = function( chara )

	-- aibファイルの選択（暫定）
	local aib = "behavior"
	-- NewSquadPref廃止(12.11.14)
--	local npcPref = Preference.GetPreferenceEntity( "TppNpcPreference" )
--	if not Entity.IsNull(npcPref) and npcPref.enableNewSquadOperation then
		aib = "Tpp/Scripts/Characters/AiBehavior/Squad/AiBehaviorTppSquad.aib"
--	end

	--プラグインの生成

	-- OrderFact有効時/無効時 共通
	chara:AddPlugins{

		--Squadプラグイン
		"SQUAD_PLG_SQUAD",
		TppSquadBaseSquadPlugin{
			name			= "Squad",
			subSquadScript	= "Tpp/Scripts/Characters/CharaTppSubSquad.lua",
			isActiveInCharaStopping = true,
		},

		--PlanningOperatorプラグイン
		"SQUAD_PLG_PLANNING_OPERATOR",
		AiPlanningOperatorPlugin{
			name			= "Planning",
			planStepCount		= TppSquad.PlanMaxStepCount,
			planValueCount		= TppSquad.PlanVaribleSetMaxValueCount,
		--	behavior		= "behavior", --"Tpp/Scripts/Characters/AiBehavior/Squad/AiBehaviorTppSquad.aib",
		--	behavior		= aib,
			behaviorGraphName = "Squad",
			exclusiveGroups	= { TppPluginExclusiveGroup.Operator },
			blackboard		= TppSquadAiBlackboard(),
			enableReserveHistory = true,
			reserveHistoryNum = 10,
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

			-- Notice
			"SQUAD_PLG_NOTICE",
			AiNoticePlugin{
				name			= "Notice",
			},

		}
	end

	-- OrderFact有効時/無効時 共通
	chara:AddPlugins{

		-- Navi
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
	}
	
	
	if DEBUG then

		-- とりあえずDEBUG用
		-- クリアリングルート変更
		chara:AddPlugins{
	
			-- Routeプラグイン
			AiRoutePlugin{
				name			= "Route",
			},
		}
		
	end
end,

--削除済み
----------------------------------------
--初期化処理 OnReset()
--　リスポーン時など、パラメータ類の初期化が必要なタイミングで呼ばれる
--　パラメータの初期化などを行う
----------------------------------------
__OnReset = function( chara )

	-- NewSquadPref廃止(12.11.14)
--	local npcPref = Preference.GetPreferenceEntity( "TppNpcPreference" )
--	if not Entity.IsNull(npcPref) and npcPref.enableNewSquadOperation then
--		-- 新しい仕組みではSubSquadは作らない
--	else
--		local plgSquad	= chara:FindPlugin( "TppSquadPlugin" )
--		if not Entity.IsNull(plgSquad) then
--			plgSquad:AddSubSquad()
--			plgSquad:AddSubSquad()
--		end
--	end
end,

--Cへ移動済み
----------------------------------------
--リアライズ処理 OnRealize()
--　リアライズ時に呼ばれる
--　chara:GetParams()が必要な初期化処理はここへ
----------------------------------------
__OnRealize = function( chara )
	-- パラメータ取得
	local params = chara:GetParams()

	if Entity.IsNull(params) then
		Fox.Warning("no params:".." cid:"..chara:GetUniqueId().." :"..chara:GetName())
		return
	end
	
	-- AI関連パラメータ
	params.dictateGrenadeWaitMin = 10.0
	params.probDictateGrenadeMin = 0.3
	params.dictateGrenadeWaitMax = 30.0
	params.checkGrenadeWaitTime = 1.0
	params.isUseAroundBhdShift = true
	params.aroundBhdShiftStartWait = 1.0
	
	-- コンバット用デフォルトパラメータあれば上書き
	local gameDefaultData = TppDefaultParameter.GetDataFromGroupName( "TppEnemyCombatDefaultParameter" )
	if gameDefaultData ~= NULL and gameDefaultData ~= nil then
		local gameDefaultParams = gameDefaultData:GetParam( "params" )
		if gameDefaultParams ~= NULL then
			params.dictateGrenadeWaitMin = gameDefaultParams.dictateGrenadeWaitMin
			params.probDictateGrenadeMin = gameDefaultParams.probDictateGrenadeMin
			params.dictateGrenadeWaitMax = gameDefaultParams.dictateGrenadeWaitMax
			params.checkGrenadeWaitTime = gameDefaultParams.checkGrenadeWaitTime
			params.isUseAroundBhdShift = gameDefaultParams.isUseAroundBhdShift
			params.aroundBhdShiftStartWait = gameDefaultParams.aroundBhdShiftStartWait
		end
	end

	if DEBUG then
		--[[ 13.05.02現在 SquadはaibをFileResourcesで読まないのでチェックを封印
		-- aib check
		if not Entity.IsNull(chara:GetLocatorHandle()) then
			local behavior = chara:GetParams():GetFile("behavior")
			if Entity.IsNull(behavior) then
				Fox.Warning("--- NO AI --- Please call npc programmer. :"..chara:GetName()..":"..chara:GetUniqueId())
			end
		end
		]]
		-- squadチェック
		if Entity.IsNull(params.squad) then
			--下記メソッドをRealizeで呼ぶと、Game外でUrgentJobが投入され、クラッシュします。
			--TODO: 描画班対応(-2012.6/1予定)を待って、コメントを解きます。
			--TppNpcDebugUtility.DispNoticeWarning()
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


}
