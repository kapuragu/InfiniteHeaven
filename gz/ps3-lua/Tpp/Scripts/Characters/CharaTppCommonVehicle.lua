----------------------------------------------------------------
-- 汎用車両
----------------------------------------------------------------
CharaTppCommonVehicle = {

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

pluginIndexEnumInfoName = "TppStrykerPluginIndexDefine",

OnCreate = function( chara )

	local isGz = true
	if TppGameSequence.GetGameTitleName() == "TPP" then
		isGz = false
	end

	chara:InitPluginPriorities {
		"Root",
		"DemoAction",
		"DeadAction",
		"NormalAction",
	}

	chara:AddPlugins{
	
		-- Bodyプラグイン（共通）
		"PLG_STRYKER_BODY",
		ChBodyPlugin{
			name	= "MainBody",
			parts 	= "parts",
			useCharacterController = false,
--			motionLayers 	= { "Full", },
--			maxMotionJoints = { 40 },
			motionLayers 	= { "Left", "Right", },
			maxMotionJoints = { 34, 34, },
			geoAttributes = { "VEHICLE" },
		},
		
		-- CameraBehavior（可変）
		"PLG_STRYKER_CAMERA_BEHAVIOR",
		TppStrykerCameraBehaviorPlugin
		{
			name						= "CameraBehavior",
			attachPointNameForAround	= { "SKL_170_WHEELL4", "SKL_180_WHEELR4", },
			basePosOffsetForAround		= Vector3( 0.0, 0.2, 2.75 ),
		},
		
		--バウンダープラグイン（Stryker）
		"PLG_STRYKER_BOUNDER",
		ChBounderPlugin{
			name			= "Bounder",
			sceneName		= "MainScene",
			bounders		= {
					{ worldName = "", partsName = "HumanBounder" },
			},
			isEnable		= true,		-- 初期状態での有効・無効フラグ,
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},
	
		--エフェクトプラグイン（共通）
		"PLG_STRYKER_EFFECT",
		ChEffectPlugin {
			name			= "Effect",
			bodyPluginName	= "MainBody",
		},
		
		-- 新武器システム対応Inventory（Stryker）
		"PLG_STRYKER_NEW_INVENTORY",
		TppMechaInventoryPlugin {
			name			= "NewInventory",
		},
		
		-- ActionRootPlugin（共通）
		"PLG_STRYKER_ACTION_ROOT",
		ChActionRootPlugin {
			name = "ActionRoot",
		},
		
		-- 基本挙動用Plugin（可変）
		"PLG_STRYKER_BASIC_ACTION",
		TppVehicleBasicActionPlugin {
			name			= "TppStrykerBasicAction",	-- 過去のスクリプト利用のため
			parent			= "ActionRoot",
			bodyPlugin		= "MainBody",
			layerName		= "Lower",
			priority		= "NormalAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Lower },
			--soundParamGroupName	= "TppLightVehicleSoundParam",
			--soundParamName		= "param",
			--physicalInteractionParamGroupName	= "TppLightVehiclePhysicalInteractionParam",
			--physicalInteractionParamName		= "param",
			--isAlwaysAwake	= true,
			isSleepStart = true,
		},
		
		-- DrivingActionPlugin（可変）
		-- Stryker用
		"PLG_STRYKER_DRIVING_ACTION",
		TppPlayerDrivingStrykerActionPlugin {
			name			= "DrivingAction",
			parent			= "ActionRoot",
			bodyPlugin		= "MainBody",
			--priority		= "NormalAction",
			priority		= "DrivingAction",
			exclusiveGroups = { TppPluginExclusiveGroup.Driving },
			isSleepStart = true,
		},
		
		-- 体当たり（軽車両）
		"PLG_STRYKER_HIT_ACTION",
		TppVehicleHitActionPlugin{
			name			= "HitAction",
			parent			= "ActionRoot",
			bodyPlugin		= "MainBody",
			priority		= "NormalAction",
			bodyAttackGroup = { "ENEMY", "OBJECT", "FRIEND" },
			velocityThresholdHit = 20.0,
			velocityThresholdPush = 5.0,
			isSleepStart = true,
		},

		-- 砲塔追従プラグイン（Stryker）
		"PLG_STRYKER_TRACK_TURRET",
		TppStrykerTurretTrackCameraActionPlugin {
			name			= "TrackTurret",
			bodyPlugin		= "MainBody",
			parent			= "ActionRoot",
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},
		
		-- アタックアクション（Stryker)
		"PLG_STRYKER_ATTACK_ACTION",
		TppStrykerAttackActionPlugin {
			name			= "AttackAction",
			parent			= "ActionRoot",
			bodyPlugin		= "MainBody",
			priority		= "NormalAction",
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},
		
		-- 敵用プラグイン
		--SharedInfoプラグイン
		"PLG_STRYKER_SHARED_INFO_STORAGE",
		ChSharedInfoStoragePlugin {
			name = "SharedInfoStorage",
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},
		
		--ナビゲーションの制御
		"PLG_STRYKER_NAVIGATION",
		TppVehicleNavigationPlugin{
			name		= "Navigation",
			sceneName	= "MainScene",
			worldName	= "",
			--typeName		 = "BasicController",
			typeName		 = "SteeringController",
			radius			 = 2,
			minimumTurningRadius = 5,
			steeringMargin   = 3.5,
			attribute		 = {0,0,0,0},
			--mode			 = "debug",
		},
	}

if TppGameSequence.GetGameTitleName() ~= "GZ" then

	chara:AddPlugins{

		--AIタスクの制御
		"PLG_STRYKER_PLANNING_OPERATOR",
		AiPlanningOperatorPlugin{
			name				= "PlanningOperator",
			behavior			= "behavior",--"Tpp/Scripts/Characters/AiBehavior/Stryker/AiBehaviorTppStryker.aib",
			priority		= "AiOperation",
			exclusiveGroups	= { TppPluginExclusiveGroup.Operator },
			blackboard = TppEnemyAiBlackboard(),
			enableReserveHistory = true,
			reserveHistoryNum = 10,
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
			TODO_allowNoBehaviorGraph = true,
		},
		
		--Noticeの制御
		"PLG_STRYKER_NOTICE",
		AiNoticePlugin{
			name		= "Notice",
			conditions	= "Tpp/Scripts/Ai/Stryker/Notices/NoticeConditionsTppStryker.lua",
			conditionComponent	= TppEnemyStrykerNoticeConditionComponent{},
			isSleepStart	= true,
		},
		
		--知識情報の制御
		"PLG_STRYKER_KNOWLEDGE",
		AiKnowledgePlugin{
			name		= "Knowledge",
			isSleepStart = true,
		},
		
		--視覚情報の制御
		"PLG_STRYKER_EYE",
		TppHumanEnemyEyePlugin {
			name			= "Eye",
			paramComponent	= TppStrykerEyeParameterUpdateComponentEnemy{ eyeCnp="CNP_mzf_cann", },
			defaultRange			= 10,					--デフォルト視界距離（メートル）
			defaultAngleLeftRight	= ((3.14/180) * 40 ),	--デフォルト左右視野角(Radian)
			defaultAngleUpDown		= ((3.14/180) * 30 ),	--デフォルト上下視野角(Radian)
			params = {
				"Discovery",	GkConeSightCheckParam(),	--プレイヤー近距離発見用の視界を追加
				"Indis", 		GkConeSightCheckParam(),	--プレイヤー中距離発見用の視界を追加
				"Dim", 			GkConeSightCheckParam(),	--プレイヤー遠距離発見用の視界を追加
			},
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},
		
		--ルートの制御
		"PLG_STRYKER_ROUTE",
		AiRoutePlugin{
			name	= "Route",
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},

		--Phaseプラグイン
		"PLG_STRYKER_PHASE",
		AiPhasePlugin{
			name			= "Phase",
			controller		= TppEnemyPhaseController{ script = "Tpp/Scripts/Ai/Soldier/Phases/AiPhaseTppSoldier.lua" },
			initPhaseName	= "Neutral",	--初期フェイズ名
			phases = {
				AiPhase{ name="Neutral", maxLevel="99.9" },		--散策フェイズ
				AiPhase{ name="Sneak", 	 maxLevel="99.9" },		--潜入フェイズ
				AiPhase{ name="Caution", maxLevel="99.9" },		--警戒フェイズ
				AiPhase{ name="Evasion", maxLevel="99.9" },		--回避フェイズ
				AiPhase{ name="Alert",   maxLevel="99.9" },		--危険フェイズ
			},
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},
	}
end

	chara:AddPlugins{

		"PLG_STRYKER_SQUAD",
		TppSquadMemberPlugin{
			name			= "Squad",
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},
		
		-- Stryker制御用ActionPlugin
		"PLG_ENEMY_STRYKER_BASIC_ACTION",
		TppEnemyStrykerBasicActionPlugin {
			name			= "EnemyBasicAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			priority		= "EnemyBasicAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.EnemyBasic },
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},
		
		-- Stryker制御用ActionPlugin
		"PLG_ENEMY_STRYKER_TURRET_ACTION",
		TppEnemyStrykerTurretActionPlugin {
			name			= "TurretAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			priority		= "TurretAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Turret },
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},
		
		-- Stryker制御用ActionPlugin
		"PLG_ENEMY_STRYKER_MACHINEGUN_ACTION",
		TppEnemyStrykerMachinegunActionPlugin{
			name			= "MachinegunAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			priority		= "MachinegunAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Machinegun },
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},
		
		-- Stryker制御用ActionPlugin
		"PLG_ENEMY_STRYKER_DEAD_ACTION",
		TppEnemyStrykerDeadActionPlugin {
			name			= "DeadAction",
			parent			= "ActionRoot",
			bodyPlugin		= "Body",
			priority		= "DeadAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Turret, TppPluginExclusiveGroup.Machinegun },
			isSleepStart	= true,
		},

		"PLG_STRYKER_NPC_DRIVING_ACTION",
		TppNpcDrivingActionPlugin {
			name			= "NpcDrivingAction",
			parent			= "ActionRoot",
			bodyPlugin		= "MainBody",
			priority		= "DrivingAction",
			exclusiveGroups	= { TppPluginExclusiveGroup.Driving },
			vpc	= "vpc",
			vdp = "vdp",
			isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
		},
		
		"PLG_STRYKER_PASSENGER_ADJUST",
		TppVehiclePassengerAdjustPlugin{
			name			= "PassengerAdjust",
			isSleepStart	= true,
		},
		
		"PLG_STRYKER_FALL_DAMAGE_ACTION",
		TppVehicleFallDamageActionPlugin{
			name			= "FallDamageAction",
			bodyPlugin		= "MainBody",
			parent			= "ActionRoot",
			isSleepStart	= true,
		},
		
		"PLG_STRYKER_CRASH_DAMAGE_ACTION",
		TppVehicleCrashDamageActionPlugin{
			name			= "CrashDamageAction",
			bodyPlugin		= "MainBody",
			parent			= "ActionRoot",
			minRelativeSpeed = 4.0,
			maxRelativeSpeed = 14.0,
			isSleepStart	= true,
		},
	}


	if isGz == false then
		chara:AddPlugins
		{
			"PLG_STRYKER_FULTON_RECOVERED_ACTION",
			TppVehicleFultonRecoveredActionPlugin
			{
				name			= "FultonRecoveredAction",
				bodyPlugin		= "MainBody",
				parent			= "ActionRoot",
				isSleepStart	= true,		-- 初期状態での有効・無効フラグ,
			},
		}
	end

end,

OnRealize = function( chara )
end,

OnReset = function( chara )
end,

OnRelease = function( chara )
end,

--[[
Command.StartGroup()
local chara   = Command.CreateData( Editor.GetInstance(),"ChCharacterLocatorData" )
local params  = Command.CreateEntity( "TppWesternMilitaryVehicleLocatorParameter" )
local creator = Command.CreateEntity( "TppWesternMilitaryVehicleObjectCreator" )
Command.SetProperty{ entity=chara, property="name", value="WesternMilitaryVehicleLocator" }
Command.SetProperty{ entity=chara, property="scriptPath", value="Tpp/Scripts/Characters/CharaTppWesternJeep.lua" }
Command.SetProperty{ entity=chara, property="objectCreator", value=creator }
Command.SetProperty{ entity=chara, property="params", value=params }
local param = chara.params.fileResources
Command.AddPropertyElement{ entity = param, property = "resources", key = "parts" }
Command.SetProperty{ entity = param, property = "resources", key = "parts", value = "/Assets/tpp/parts/mecha/plv/plv0_main0_def.parts" }
Command.EndGroup()
--]]

}
