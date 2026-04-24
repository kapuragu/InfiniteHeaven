--dofile( "Tpp/Scripts/System/TppCharaPerfMonitor.lua" )
if DEBUG then

	--実機(360)上での負荷を 60fps=100% で指定する。

--[[
	-- プレイヤー用
	ChDebugCharacterPerformanceMonitor.RegisterThreashold{
		type = "Player", --Characterタグ
		total = { 10.0, 7.0 }, --NG閾値%(赤), 警告閾値%(黄)
		jobs = {
			-- Job名, NG閾値%(赤), 警告閾値%(黄) /  平常時は常に白の状態を保つつもりで。重いときでも赤は超えてはダメ。
			{ "OperatorUpdateJob",				2.27,1.51, },
			{ "ChDescUpdateJob",				1.85,1.24, },
			{ "WakeUpCheckJob",					1.19,0.79, },
			{ "SetupAnimJob",					0.74,0.49, },
			{ "LifeUpdateJob",					0.67,0.45, },
			{ "CameraUpdateJob",				0.66,0.44, },
			{ "AnimUpdateJob",					0.45,0.30, },
			{ "UpdateTargetJob",				0.41,0.27, },
			{ "PreAnimActionJob",				0.38,0.25, },
			{ "UpdateEffectJob",				0.26,0.18, },
			{ "UpdateInventoryJob",				0.22,0.15, },
			{ "SharedInfoStorageUpdateJob",		0.17,0.11, },
			{ "ThreatSearchJob",				0.12,0.08, },
			{ "ChProcessingJob",				0.11,0.07, },
			{ "PreControlActionJob",			0.11,0.07, },
			{ "SmartObjectPluginUpdateJob",		0.08,0.05, },
			{ "UpdateModelJob",					0.07,0.05, },
			{ "PostModelActionJob",				0.06,0.04, },
			{ "UpdateSoundJob",					0.05,0.04, },
			{ "ChInitialJob",					0.05,0.04, },
			{ "HomingUpdateJob",				0.05,0.03, },
			{ "AimUpdateJob",					0.05,0.03, },
			{ "ChTerminalJob",					0.05,0.03, },
			{ "DemoReceiveMessagesJob",			0.04,0.03, },
			{ "OperatorUpdateJob",				0.04,0.03, },
			{ "DamageProcessJob",				0.03,0.02, },
			{ "DamageTranslateJob",				0.02,0.01, },
			{ "HighSpeedCameraEventOperatorPluginUpdateJob",	0.00,0.01, },
			{ "PreModelActionJob",				0.02,0.01, },
			{ "GroupBehaviorUpdateJob",			0.02,0.01, },
			{ "AttachPluginUpdateJob",			0.02,0.01, },
			{ "CharaControlUpdateJob",			0.02,0.00, },
			{ "AnimEndJob",						0.02,0.00, },
			{ "SmartObjectUnbindCheckJob",		0.02,0.00, },
			{ "CharaControlEndJob",				0.02,0.00, },
			{ "SyncGroupBehaviorServiceJob",	0.02,0.00, },
			{ "SyncFxSystemJob",				0.02,0.00, },
			{ "SyncNoiseSystemJob",				0.02,0.00, },
			{ "SyncSdSystemJob",				0.02,0.00, },
		}
	}
]]
	-- 一般敵兵用
	ChDebugCharacterPerformanceMonitor.RegisterThreashold{
		type = "Enemy", --Characterタグ
		total = { 10.0, 7.0 }, --NG閾値%(赤), 警告閾値%(黄)
		jobs = {
			-- Job名, NG閾値%(赤), 警告閾値%(黄) /  平常時は常に白の状態を保つつもりで。重いときでも赤は超えてはダメ。
			{ "UpdatePlanStepJob2", 				4.00, 2.00, }, -- 2.50, 2.00, --理想
			{ "ChDescUpdateJob",					1.00, 0.50, }, -- 0.75, 0.50,
			{ "WakeUpCheckJob",					0.75, 0.40, },
			{ "SetupAnimJob",					0.75, 0.40, },
			{ "SharedInfoStorageUpdateJob",		1.00, 0.30, }, -- 0.50, 0.30,
			{ "SightCheckGetResultJob",			4.00, 0.30, }, -- 0.50, 0.30,
			{ "NoticeReactionCheckJob",			1.00, 0.30, }, -- 0.50, 0.30,
			{ "KnowledgeInferenceJob",			2.00, 0.25, }, -- 0.50, 0.25,
			{ "AiPhaseUpdateJob",					1.50, 0.25, }, -- 0.50, 0.25,
			{ "AnimUpdateJob",					0.50, 0.25, },
			{ "ReceiveKnowledgeEventJob",			0.50, 0.20, },
			{ "NoiseCheckJob",					1.00, 0.20, }, -- 0.30, 0.20,
			{ "SightCheckRequestJob",				3.00, 0.20, }, -- 0.30, 0.20,
			{ "DamageProcessJob",				0.30, 0.20, },
			{ "UpdateEffectJob",					0.30, 0.20, },
			{ "UpdateSoundJob",					0.50, 0.15, },
			{ "UpdateTargetJob",					0.25, 0.15, },
			{ "SightCheckParameterUpdateJob",		0.50, 0.15, },
			{ "SearchObjectUpdateJob",			0.20, 0.15, },
			{ "ThreatInfoUpdateJob",				0.20, 0.15, },
			{ "UpdateInventoryJob",				0.20, 0.15, },
			{ "DemoReceiveMessagesJob",			0.40, 0.10, },
			{ "LifeUpdateJob",					0.30, 0.10, },
			{ "PreAnimActionJob",					1.00, 0.10, }, -- 0.15, 0.10,
			{ "ChProcessingJob",					1.00, 0.10, }, -- 0.15, 0.10,
			{ "NoticeReactionInvokeJob",			0.20, 0.05, },
			{ "ChInitialJob",						0.50, 0.05, },
			{ "OperatorUpdateJob",				0.10, 0.05, },
			{ "UpdateModelJob",					0.20, 0.05, },
			{ "AiSquadCheckMessagesJob",			0.10, 0.05, },
			{ "AttachPluginUpdateJob",			0.10, 0.05, },
			{ "ChTerminalJob",					0.20, 0.03, },
			{ "DamageTranslateJob",				0.20, 0.03, },
			{ "GroupBehaviorUpdateJob",			0.10, 0.05, },
			{ "PreControlActionJob",				0.20, 0.05, }, 
			{ "PostModelActionJob",				0.10, 0.05, },
			{ "PreModelActionJob",				0.10, 0.05, },
			{ "CharaControlUpdateJob",			0.10, 0.05, },
			{ "ChRespawnCheckMessagesJob",		0.10, 0.05, },
			{ "ChUnrealUpdateJob",				0.10, 0.02, },
			{ "KnowledgeSearchSpaceUpdateJob",	0.05, 0.03, },
			{ "OperatorUpdateJob",				0.10, 0.05, },
			{ "SyncFxSystemJob",					0.02, 0.01, },
			{ "SyncNoiseSystemJob",				0.02, 0.01, },
			{ "SyncSdSystemJob",					0.02, 0.01, },
			{ "SyncGroupBehaviorServiceJob",		0.02, 0.01, },
			{ "SyncNoiseSystemJob",				0.02, 0.01, },
			{ "SyncNavSystemJob",				0.02, 0.01, },
			{ "AnimEndJob",						0.02, 0.01, },
			{ "CharaControlEndJob",				0.02, 0.01, },
		}
	}

	-- 武器用
	-- @todo

	-- 乗り物用
	-- @todo

	-- ギミック用
	-- @todo

end

