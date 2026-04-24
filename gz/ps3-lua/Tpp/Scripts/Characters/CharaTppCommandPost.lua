--[[FDOC
	@id 		CharaTppCommandPost
	@category 	Character Definition
	@brief		TppCommandPostキャラクタ定義
]]

CharaTppCommandPost = {

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
	"Nav",
	"GroupBehavior",
},

pluginIndexEnumInfoName = "TppCommandPostPluginIndexDefine",

--削除済み
----------------------------------------
--生成処理 OnCreate()
--　キャラクタ生成時に呼ばれる関数
--　プラグインの生成などを行う
----------------------------------------
__OnCreate = function( chara )

	--Ch.Log( chara,  "##### OnCreate() #####" );

	local behavior          = ""
	local behaviorGraphName = "CommandPost"
	if Ai.DoesUseAibFile() then
		behavior          = "behavior"
		behaviorGraphName = ""
	end

	--プラグインの生成
	chara:AddPlugins{

		--Squadプラグイン
		"CP_PLG_SQUAD",
		TppSquadCpPlugin{
			name			= "Squad",		--分隊管理くん
			isActiveInCharaStopping = true,
		},

		--CoopBehaviorプラグイン(Group Behavior)
		"CP_PLG_GROUP_BEHAVIOR",
		ChGroupBehaviorPlugin{
			name			= "GroupBehavior",
		},

		--Knowledgeプラグイン
		"CP_PLG_KNOWLEDGE",
		AiKnowledgePlugin{
			name			= "Knowledge",
		},

		--PlanningOperatorプラグイン
		"CP_PLG_PLANNING_OPERATOR",
		AiPlanningOperatorPlugin {
			name			= "GoalPlanning",
			planStepCount		= TppCommandPost.PlanMaxStepCount,
			planValueCount		= TppCommandPost.PlanVaribleSetMaxValueCount,
			behavior		= behavior,
			behaviorGraphName	= behaviorGraphName,
		--	exclusiveGroups	= { TppPluginExclusiveGroup.Operator },
			blackboard		= TppCommandPostAiBlackboard(),
		--	enableReserveHistory = true,
		--	reserveHistoryNum = 10,
		},

		--Voiceプラグイン
		"CP_PLG_VOICE2",
		ChVoicePlugin2{
			name			= "Voice",
			characterType	= "HqSquad",
		},

		-- Navi
		"CP_PLG_NAVIGATION",
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

	Ch.Log( chara,  "##### SquadHQ OK #####" );

end,

--削除済み
----------------------------------------
--初期化処理 OnReset()
--　リスポーン時など、パラメータ類の初期化が必要なタイミングで呼ばれる
--　パラメータの初期化などを行う
----------------------------------------
__OnReset = function( chara )
	local plgKnow = chara:FindPlugin( "AiKnowledgePlugin" )
	plgKnow:SetKnowledge( "IsSetClearing", AiKnowledgeValue{ value=false } )

	--尋問が使っているのでもう少し残す
	--字幕の多重表示の制御
	if chara.captionLife == nil then
		chara:AddProperty( "uint32", "captionLife", 1 )
	end
	chara.captionLife = 0

end,

--削除済み
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

	-- ボイスタイプ設定
	local plgVoice2 = chara:FindPlugin("ChVoicePlugin2")
	if not Entity.IsNull(plgVoice2) then
		local voiceType = "cp_a"
		if params.voiceType ~= nil then
			if params.voiceType ~= "" then
				voiceType = params.voiceType
			end
		end
		plgVoice2:SetVoiceType( voiceType )
	end

	if DEBUG then
		-- aib check
		local behavior = chara:GetParams():GetFile("behavior")
		if Entity.IsNull(behavior) then
			Fox.Warning("--- NO AI --- Please call npc programmer. :"..chara:GetName()..":"..chara:GetUniqueId())
		end
	end
end,

--削除済み
----------------------------------------
--解放処理 OnRelease()
--　キャラクタの解放時によばれる
----------------------------------------
__OnRelease = function( chara )
	--todo: できれば自分でリセットしてほしいんだが
	local phaseManager = TppSystemUtility.GetPhaseController()
	phaseManager:SetMinPhaseName("")
	chara:GetCharacterObject():GetPhaseController():SetMinPhaseName("")
end,

--削除済み
----------------------------------------
--公開情報の更新 OnUpdaetDesc()
--　ActorLevelの最後にまとめて呼ばれる
----------------------------------------
__OnUpdateDesc = function( chara, desc )

	--TODO 以下の処理は9末版だけの仮のもの
	--字幕の多重表示の制御
	if chara.captionLife > 0 then
		chara.captionLife = chara.captionLife - 1
		--GrxDebug.Print2D { life=1, x=40, y=120, size=15, color=Color(0.2,0.2,0.2,1), align="LEFT", log=false, args={ "Caption NG" } }
	else
		--GrxDebug.Print2D { life=1, x=40, y=120, size=15, color=Color(0,1,0.5,1), align="LEFT", log=false, args={ "Caption OK" } }
	end
	--Fox.Log( "HQ : captionLife[" .. chara.captionLife .. "]" )

end,

--削除済み
----------------------------------------
--デバッグ処理の更新 OnUpdateDebug()
--　OnUpdateDescの後に呼ばれる（リリースでは呼ばれないので注意）
----------------------------------------
__OnUpdateDebug = function( chara, desc )
	TppNpcDebugUtility.UpdateDebugAi( chara )

	--Preferenceデバッグ
	if DEBUG then
		local preference = Preference.GetPreferenceEntity("TppEnemyPreference")
		if preference then

			--最終位置表示
			if preference.viewLastPosition == true then
				local cpObj = chara:GetCharacterObject()
				cpObj:DebugDrawLastPositions()	-- デバッグ：最終位置の描画
			--	cpObj:DebugDumpLastPositions()	-- デバッグ：最終位置のダンプ
			end

		end

		local cpPref = Preference.GetPreferenceEntity("TppCommandPostPreference")
		if cpPref then
			-- 基本的な情報を表示
			local cpObj = chara:GetCharacterObject()
			if cpPref.displayBasicInfo then
				cpObj:DebugDisplayBasicInfo()
			end
			
			-- カメラから一番近いCPであればギミック情報表示
			if cpPref.displayRadioInfo then
				if cpObj:DebugIsClosestCpToCamera() then
					cpObj:DebugDisplayRadioGimmickInfo()
				end
			end
			
			-- Squad情報表示
			if cpPref.displaySquadInfo then
				cpObj:DebugDisplaySquadInfo()
			end
		end
	end
end,

}
