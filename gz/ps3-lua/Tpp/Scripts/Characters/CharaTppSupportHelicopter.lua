----------------------------------------------------------------
-- Tpp SupportHelicopter
----------------------------------------------------------------
CharaTppSupportHelicopter = {

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
	"Nav",
},

pluginIndexEnumInfoName = "TppHelicopterPluginDefine",

--Cへ移植済み
__OnCreate = function( chara )

	local resourceList = {
		parts="parts",
		motionGraph="motionGraph",
		damageSet="damageSet",
		behavior="behavior"
	}
	local locator = chara:GetLocatorHandle()
	if Entity.IsNull(locator) then
		resourceList.parts="/Assets/tpp/parts/mecha/uth/uth0_main0_def.parts"
		resourceList.motionGraph="/Assets/tpp/motion/motion_graph/helicopter/TppHelicopter_layers.fagx"
		resourceList.damageSet="/Assets/tpp/parts/mecha/uth/uth0_main0_def.fdmg"
		resourceList.behavior="Tpp/Scripts/Characters/AiBehavior/SupportHelicopter/AiBehaviorTppSupportHelicopter.aib"
	end
	

	local behavior          = ""
	local behaviorGraphName = "SupportHelicopter"
	if Ai.DoesUseAibFile() then
		behavior          = resourceList.behavior
		behaviorGraphName = ""
	end

	local isSleepPlgPlan = false
	if DEBUG then
		local pref = Preference.GetPreferenceEntity("TppHelicopterPreference")
		if not Entity.IsNull(pref) then
			isSleepPlgPlan = pref.noPlanningMode
		end
	end
	
	local charaObj = chara:GetCharacterObject()
	
	chara:InitPluginPriorities {
		"DemoAction",
		"BasicAction",
		"LightAction",
		"DamageAction",
		"HoveringAction",
		"MoveAction",
		"AttackAction",
	}
	
	chara:AddPlugins{
		-- BodyPlugin
		"PLG_BODY",
		ChBodyPlugin{
			name	= "Body",
			script = "Tpp/Scripts/Characters/Bodies/BodyTppHelicopter.lua",
			parts = resourceList.parts,
			animGraphLayer	= resourceList.motionGraph,
			hasGravity = false,
			--hasCollision = false,
			useCharacterController = false,
			--allStopWhileInvisible = true,
			maxMotionJoints = { 21, 21, 21, 21 },
			hasTranslations = { true, true, true, true },
			maxMtarFiles = 1,
		},

		--Voiceプラグイン
		"PLG_VOICE2",
		ChVoicePlugin2{
			name				= "Voice",
			characterType		= "HqSquad",
			basicArgs			= "PILOT",
		--	connectPointName	= "CNP_MOUTH",
		--	distanceRtpcName	= "voice_distance",
			plgFacial           = false,
		},
		
		--ルートプラグイン
		"PLG_ROUTE",
		AiRoutePlugin{
			name	= "Route",
		},
		
		--NewInventory
		"PLG_NEW_INVENTORY",
		TppHeliInventoryPlugin {
			name			= "NewInventory",
			--weaponId		= "WP_HeliMachinegun",
			--connectPointName= "CNP_pos_psl",
		},
		
		--AIタスクの制御
		"PLG_PLANNING_OPERATOR",
		AiPlanningOperatorPlugin{
			name			= "PlanningOperator",
			planStepCount		= TppSh.PlanMaxStepCount,
			planValueCount		= TppSh.PlanVaribleSetMaxValueCount,
			behavior		= behavior,
			behaviorGraphName	= behaviorGraphName,
			priority		= "AiOperation",
			exclusiveGroups	= { TppPluginExclusiveGroup.Operator },
			blackboard 		= TppSupportHelicopterAiBlackboard(),
			isSleepStart	= isSleepPlgPlan,
			enableReserveHistory = true,
			reserveHistoryNum = 10,
		},

		--乗客管理プラグイン
		"PLG_PASSENGER_MANAGE",
		TppPassengerManagePlugin {
			name						= "PassengerManage",
			isPossibleGettingOnInit		= false,
			isPossibleGettingOffInit	= false,
		},
		
		-- Navigationプラグイン
		"PLG_NAVIGATION",
		ChNavigationPlugin{
			name			= "Navigation",
			sceneName		= "MainScene",
			worldName		= "sky",
			typeName		= "SkyController",
			radius			= 0.5,
			--mode			= "debug",
		},
		
		-- 支援ヘリプラグイン
		"PLG_SUPPORT_HELICOPTER",
		TppSupportHelicopterPlugin{
			name			= "SupportHelicopter",
		},
		
		---------------------------------------------------------------------------------------------------
		-- 以下、ActionPlugin関連
		---------------------------------------------------------------------------------------------------
		
		--アクションルートプラグイン
		"PLG_ACTION_ROOT",
		ChActionRootPlugin {
			name = "ActionRoot",
		},
		
		--[[
		--基本アクションプラグイン
		"PLG_BASIC_ACTION",
		TppHelicopterBasicActionPlugin {
			name			=	"BasicAction",
			parent			=	"ActionRoot",
			bodyPlugin		=	"Body",
			priority		=	"BasicAction",
			layerName		=	{ "Full", "LandingGear", "RightDoor", "LeftDoor" },
			exclusiveGroups	=	{ TppPluginExclusiveGroup.Basic },
			isSleepStart = true,
		},
		]]
		--ライトアクションプラグイン
		"PLG_LIGHT_ACTION",
		TppHelicopterLightActionPlugin {
			name			=	"LightAction",
			parent			=	"ActionRoot",
			bodyPlugin		=	"Body",
			priority		=	"LightAction",
			layerName		=	{ "Full", "LandingGear", "RightDoor", "LeftDoor" },
			isSleepStart	=	true,
		},

		--移動アクションプラグイン
		"PLG_MOVE_ACTION",
		TppHelicopterMoveActionPlugin {
			name			=	"MoveAction",
			parent			=	"ActionRoot",
			bodyPlugin		=	"Body",
			priority		=	"MoveAction",
			exclusiveGroups	=	{ TppPluginExclusiveGroup.Move },
			isSleepStart	=  true,
		},
		
		--ホバリングアクションプラグイン
		"PLG_HOVERING_ACTION",
		TppHelicopterHoveringActionPlugin {
			name			=	"HoveringAction",
			parent			=	"ActionRoot",
			bodyPlugin		=	"Body",
			priority		=	"HoveringAction",
			exclusiveGroups	=	{ TppPluginExclusiveGroup.Move },
			isSleepStart	= true,
		},
		
		--攻撃アクションプラグイン
		"PLG_ATTACK_ACTION",
		TppHelicopterAttackActionPlugin {
			name			=	"AttackAction",
			parent			=	"ActionRoot",
			bodyPlugin		=	"Body",
			priority		=	"AttackAction",
			exclusiveGroups	=	{ TppPluginExclusiveGroup.Attack },
		},
		
		--ダメージアクションプラグイン
		"PLG_DAMAGE_ACTION",
		TppHelicopterDamageActionPlugin {
			name			= "DamageAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			priority		= "DamageAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Attack, TppPluginExclusiveGroup.Move },
			isSleepStart	= true,
		},
		
		--デモアクションプラグイン
		"PLG_DEMO_ACTION",
		ChDemoActionPlugin{
			name			= "DemoAction",
			script			= "Tpp/Scripts/Characters/Actions/ActionTppDemo.lua",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			priority		= "DemoAction",
			layerName		=	{ "Full", "RightDoor", "LeftDoor", "LandingGear" },
			exclusiveGroups	= { TppPluginExclusiveGroup.Basic, TppPluginExclusiveGroup.Attack, TppPluginExclusiveGroup.Move },
			isSleepStart	= true,
		},
	}
	
	local charaParams = chara:GetParams()
	--@TODO parts付けるまでの仮対応
	if charaParams.mainRotorBoneName ~= "SKL_003_MAINROTOR" then
		chara:AddPlugins{
			--基本アクションプラグイン
			"PLG_BASIC_ACTION",
			TppHelicopterBasicActionPlugin {
				name			=	"BasicAction",
				parent			=	"ActionRoot",
				bodyPlugin		=	"Body",
				priority		=	"BasicAction",
				layerName		=	{ "Full", "LandingGear", "RightDoor", "LeftDoor" },
				exclusiveGroups	=	{ TppPluginExclusiveGroup.Basic },
				isSleepStart = true,
			},
		}
	else
		chara:AddPlugins{			
			--基本アクションプラグイン
			"PLG_BASIC_ACTION",
			TppHelicopterBasicActionPlugin {
				name			=	"BasicAction",
				parent			=	"ActionRoot",
				bodyPlugin		=	"Body",
				priority		=	"BasicAction",
				layerName		=	{ "Full", "RightDoor", "LeftDoor" },
				exclusiveGroups	=	{ TppPluginExclusiveGroup.Basic },
				isSleepStart = true,
			},
		}
	end
end,

--Cへ移植済み
__OnReset = function( chara )

	--黒板仮対応
	local plgPlan = chara:FindPlugin("AiPlanningOperatorPlugin")
	local planExecuter = plgPlan:GetPlanExecuter()
	local bb = planExecuter:GetBlackboard()
	if bb.calledPointPosition == nil then
		bb:AddProperty("Vector3", "calledPointPosition", 1)
	end
	bb.calledPointPosition = Vector3(0,0,0)
	
	--@TODO マスク情報の設定が現状では遅いので再度初期モーションをリクエストする
	--本来はinitタグで解決できるはずだがマスクの設定が遅いので仮対応
	local params = chara:GetParams()
	if params.mainRotorBoneName ~= "SKL_003_MAINROTOR" then
		local plgAction = chara:FindPlugin("TppHelicopterBasicActionPlugin")
		plgAction:SendActionRequest( ChDirectChangeStateActionRequest{ groupName = "stateTakeIn", layerName="LandingGear" } )
		--plgAction:SendActionRequest( ChChangeStateActionRequest{ groupName="stateOpen", layerName="LeftDoor" } )
		--plgAction:SendActionRequest( ChChangeStateActionRequest{ groupName="stateOpen", layerName="RightDoor" } )
	end
	
	--ナビの更新距離を短めにする
	local plgNav = chara:FindPlugin("ChNavigationPlugin")
	plgNav:SetUpdateDistance(2)

end,

--Cへ移植済み
----------------------------------------
--デバッグ処理の更新 OnUpdateDebug()
--OnUpdateDescの後に呼ばれる（リリースでは呼ばれないので注意）
----------------------------------------
__OnUpdateDebug = function( chara, desc )

	local pref = Preference.GetPreferenceEntity("TppHelicopterPreference")
	local y = 150
	
	--メンバー連携情報表示
	if pref.viewAttackActionInfo then
		local plgAttack = chara:FindPlugin("TppHelicopterAttackActionPlugin")
		plgAttack:DebugView(20, y, 15)
		y = y + 150
	end
	
end,

}
