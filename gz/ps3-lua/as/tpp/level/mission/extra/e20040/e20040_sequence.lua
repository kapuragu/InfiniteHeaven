 local this = {}

---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------

this.missionID	= 20040
this.cpID		= "e20040CP"
this.tmpChallengeString = 0
this.tmpBestRank = 2				-- ベストクリアランク比較用(5 = RankD)
this.tmpRewardNum = 0				-- 達成率（報酬獲得数）表示用

---------------------------------------------------------------------------------
-- EventSequenceManager
---------------------------------------------------------------------------------

this.RequiredFiles = {
	"/Assets/tpp/script/common/GZCommon.lua",
}

this.Sequences = {
	{ "Seq_MissionPrepare" },
	{ "Seq_MissionSetup" },
	{ "Seq_OpeningDemoLoad" },
	{ "Seq_OpeningShowTransition" },
	{ "Seq_OpeningDemo" },
	{ "Seq_ToRescuePoint" },
	{ "Seq_Straight" },
	{ "Seq_FreeTarget" },
	{ "Seq_Escoat01" },
	{ "Seq_Escoat02" },
	{ "Seq_Escoat03" },
	{ "Seq_AAGun" },
	{ "Seq_Snipe" },
	{ "Seq_Snipe02" },
	{ "Seq_Boss" },
	{ "Seq_AdditionalEnemyForce" },
	{ "Seq_Escape" },
	{ "Seq_MissionClearDemoPrepare" },
	{ "Seq_MissionClearDemo01" },
	{ "Seq_MissionClearDemo02" },
	{ "Seq_MissionClearDemo03" },
	{ "Seq_MissionClearShowTransition" },
	{ "Seq_MissionClear" },
	{ "Seq_MissionFailed" },
	{ "Seq_MissionFailed_HelicopterDead" },
	{ "Seq_MissionFailed_HelicopterDeadNotOnPlayer" },
	{ "Seq_MissionEnd" },
	{ "Seq_MissionGameOver" },
	{ "Seq_ShowClearReward" },
}

this.OnStart = function( manager )
	GZCommon.Register( this, manager )
	TppMission.Setup()
end

this.ChangeExecSequenceList =  {
	"Seq_OpeningShowTransition",
	"Seq_OpeningDemo",
	"Seq_ToRescuePoint",
	"Seq_Straight",
	"Seq_FreeTarget",
	"Seq_Escoat01",
	"Seq_Escoat02",
	"Seq_Escoat03",
	"Seq_AAGun",
	"Seq_Snipe",
	"Seq_Snipe02",
	"Seq_Boss",
	"Seq_AdditionalEnemyForce",
	"Seq_Escape",
}

local IsChangeExecSequence = function()
	local sequence = TppSequence.GetCurrentSequence()

	for i = 1, #this.ChangeExecSequenceList do
		if sequence == this.ChangeExecSequenceList[i] then
			return true
		end
	end
	return false
end

this.OnEnterCommon = function()
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log( "=== " .. sequence .. " : OnEnter ===" )
	if IsChangeExecSequence() then
		TppMission.ChangeState( "exec" )
	end
end

this.OnLeaveCommon = function()
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log( "=== " .. sequence .. " : OnLeave ===" )
end

this.OnSkipEnterCommon = function()
end

this.OnSkipLeaveCommon = function()
end
---------------------------------------------------------------------------------
--● RADIO LIST
---------------------------------------------------------------------------------

this.RadioList = {
--Begining
	Radio_SearchStart = "e0040_rtrg9010",
	Radio_LookFor = "e0040_rtrg9005",
	Radio_RadioIncoming = "e0040_rtrg9011",
	Radio_FoundFlare = "e0040_rtrg9012",
--Straight
	Radio_EnemieFireIncoming = "e0040_rtrg9014",
--FreeTarget
	Radio_TargetConfirmed = "e0040_rtrg9020",
--Escoat
	Radio_StartEscoating  = "e0040_rtrg9030",
	Radio_Incoming = "e0040_rtrg1101",
	Radio_ShootRight = "e0040_rtrg9040",
	Radio_NiceShoot = "e0040_rtrg1011",
	Radio_ShootCenter = "e0040_rtrg9041",
	Radio_AboutToGetHeliport = "e0040_rtrg9042",
	Radio_GreatDrive = "e0040_rtrg9039",
--AAGun
	Radio_AAGunFireIncoming = "e0040_rtrg9050",
	Radio_DetourAAgunFacility = "e0040_rtrg9060",
	Radio_AAgunDestroyConfirmed = "e0040_rtrg9070",
--Snipe
	Radio_FriendVehicleClash = "e0040_rtrg9080",
	Radio_CoverTarget = "e0040_rtrg9090",
	Radio_DominateLZ = "e0040_rtrg9100",
	Radio_DominateLZ2 = "e0040_rtrg9101",
	Radio_RPGonTower = "e0040_rtrg9110",
	Radio_LZCleared = "e0040_rtrg9120",
--Boss
	Radio_GetOffHeli = "e0040_rtrg9130",
	Radio_CheackTargetStatus = "e0040_rtrg9140",
	Radio_BossIncoming = "e0040_rtrg9150",
	Radio_RequestingTargetCargo = "e0040_rtrg9170",
	Radio_AdditionalEnemyForce02 = "e0040_rtrg9159",
	Radio_AdditionalEnemyForce = "e0040_rtrg9160",
	Radio_TargetCaptured = "f0090_rtrg0460",
	Radio_TakeOff = "e0040_rtrg9171",
--Escape
	Radio_Escape = "e0040_rtrg9180",
	Radio_EnemyHeli = "e0040_rtrg9185",
	Radio_ShootHeli = "e0040_rtrg9186",
--Clear
	Radio_ClearSpeech = "e0040_rtrg9190",

--Utilities
	Radio_HeliHP70 = "e0040_rtrg0110", --ヘリが持たない！攻撃を許すな！
	Radio_HeliHP50 = "e0040_rtrg0111", --ヘリが限界だ！あきらめるな！
	Radio_HeliHP10	= "e0040_rtrg0120", --まずいヘリが落ちるぞ　撃たせるな！
	Radio_HeliDamage = "e0040_rtrg0150",
	Radio_HeliDown = "e0040_rtrg0130",
	Radio_TargetDead = "f0033_gmov0150",
	Radio_TargetSlept = "f0033_gmov0070",
	Radio_PlayerDead = "f0033_gmov0010",
	Radio_PlayerDeadwithHeli = "f0033_gmov0160",
	Radio_HeliDeadwithoutPlayer = "f0033_gmov0170",
	Radio_WarningWithoutEnemy = "e0040_rtrg0139",
	Radio_OutOfRange = "e0040_rtrg0140",
	Radio_OutOfRangeWithoutEnemy = "e0040_rtrg0141",
	Radio_RequestingTargetCargoFirst = "f0090_rtrg0190",
	Radio_FriendlyFire = "e0040_rtrg0240",
	Radio_AimFriend = "e0040_rtrg0250",
	Radio_HeliKill = "e0040_rtrg1010",
	Radio_Moai = "e0040_rtrg1200",

--Lessons
	Radio_UseUnderBarrel = "e0040_rtrg0030",
	Radio_UseScope = "e0040_rtrg0020",

--汎用無線
	Miller_SpRecoveryLifeAdvice = "f0090_rtrg0290",
	Miller_RevivalAdvice = "f0090_rtrg0280",
	Miller_CuarAdvice = "f0090_rtrg0300",
	Miller_HeliAttack = "f0090_rtrg0225",
}

this.OptionalRadioList = {
}

---------------------------------------------------------------------------------
--● FLAG LIST
---------------------------------------------------------------------------------
this.MissionFlagList = {
	isOPDemoSkip = false,
	isRideHeli = true,
	isAAGunDestroyed = false,
	isHostageCapture = false,
	isAdditionalEnemyForceDeactive = false,
	isHeliReLandingOK = false,
	isFriendManFaint = false,
	isDeadWatcher01END = false,
	isDeadWatcher02END = false,
	isDeadWatcher03END = false,
	isBossGenerated = false,
	isInBossGenerateArea = false,
	isTurretBroken = false,
	isInsideAddTrap = false,
	isInsideHeliDropArea = false,
	isAddEneGen = false,
	isHeliComeDown = false,
	isMoai01_Broken = false,
	isMoai02_Broken = false,
	isMoai03_Broken = false,
	isMoai04_Broken = false,
	isMoai05_Broken = false,
	isHeliEscapeOK = false,
	isEnemyHeliNeutralized = false,
	isEnemyHeliNoThreat = false,
	isRadioPlayed = false,
	isDebugEscoat = true,
	isDebugAAGun = true,
	isDebugBoss = true,
	isPrimaryWPIcon = false,
}
---------------------------------------------------------------------------------
-- Mission Counter List
---------------------------------------------------------------------------------
this.CounterList = {
	DEBUG_commonPrint2DCount		= 0,
	DeadTargets = 0,
	First_DeadTargets = 0,
	Moai_Counter = 0,
	GameOverFadeTime	= GZCommon.FadeOutTime_MissionFailed,	-- ゲームオーバー時フェードアウト開始までのウェイト
}
---------------------------------------------------------------------------------
-- Demo List
---------------------------------------------------------------------------------
this.DemoList = {
	Demo_Opening 		= "p12_030000_000",		-- オープニングデモ
	Demo_Boss			= "p12_030020_000",
	Demo_MissionClear01	= "p12_030010_000",		-- ミッションクリアデモSランク
	Demo_MissionClear02	= "p12_030010_001",		-- ミッションクリアデモABランク
	Demo_MissionClear03	= "p12_030010_002",		-- ミッションクリアデモそれ以外
}
---------------------------------------------------------------------------------
--● ALL SEQUENCE MESSAGE
---------------------------------------------------------------------------------
this.Messages = {
	Mission = {
		{ message = "MissionFailure", localFunc = "commonMissionFailure" },
		{ message = "MissionClear", localFunc = "commonMissionClear" },
		{ message = "MissionRestart", localFunc = "commonMissionCleanUp" },
		{ message = "MissionRestartFromCheckPoint", localFunc = "commonMissionCleanUp" },
		{ message = "ReturnTitle", 	localFunc = "commonMissionCleanUp" },
	},

	Demo = {
		{ data = "p12_030000_000", message = "Skip", commonFunc = function() TppMission.SetFlag( "isOPDemoSkip", true )end },
	},

	Character = {
		{ data = "FriendMan", message = "EnemyDead", commonFunc = function() this.FriendManDead() end },
		{ data = "FriendMan", message = "EnemyDamage", commonFunc = function() this.FriendlyDamageByPlayer() end },
		{ data = "SupportHelicopter", message = "LostControl", localFunc = "HelicopterLostControl"},
		{ data = "SupportHelicopter", message = "NotifyLifeRate", localFunc = "HeliHp" },
		{ data = "SupportHelicopter",	message = "DamagedByPlayer",		commonFunc = function() this.commonHeliDamagedByPlayer() end },
		{ data = "FirstEnemy01", message = {"EnemySleep","EnemyDead","EnemyDying","EnemyFaint"}, commonFunc = function() this.DeadWatcherAlmighty() end },
		{ data = "FirstEnemy02", message = {"EnemySleep","EnemyDead","EnemyDying","EnemyFaint"}, commonFunc = function() this.DeadWatcherAlmighty() end },
		{ data = "FirstEnemy03", message = {"EnemySleep","EnemyDead","EnemyDying","EnemyFaint"}, commonFunc = function() this.DeadWatcherAlmighty() end },
		{ data = "FirstEnemy04", message = {"EnemySleep","EnemyDead","EnemyDying","EnemyFaint"}, commonFunc = function() this.DeadWatcherAlmighty() end },
		{ data = "FirstEnemy05", message = {"EnemySleep","EnemyDead","EnemyDying","EnemyFaint"}, commonFunc = function() this.DeadWatcherAlmighty() end },
		{ data = "Player", message = "OnPickUpWeapon" , commonFunc = function() this.Common_PickUpWeaopn() end },	--武器を入手した時
	},
	Gimmick = {
		{ data = "gntn_area01_antiAirGun_002", message = "AntiAircraftGunBroken", commonFunc = function() this.AAGunDestroyed() end },
		{ data = "WoodTurret02", message = "BreakGimmick", commonFunc = function() this.TurretBreak() end },
		{ data = "Moai01", message = "BreakGimmick", commonFunc = function() this.MoaiBroken("isMoai01_Broken") end },
		{ data = "Moai02", message = "BreakGimmick", commonFunc = function() this.MoaiBroken("isMoai02_Broken") end },
		{ data = "Moai03", message = "BreakGimmick", commonFunc = function() this.MoaiBroken("isMoai03_Broken") end },
		{ data = "Moai04", message = "BreakGimmick", commonFunc = function() this.MoaiBroken("isMoai04_Broken") end },
		{ data = "Moai05", message = "BreakGimmick", commonFunc = function() this.MoaiBroken("isMoai05_Broken") end },
	},

	Timer = {
		{ data = "Timer_FriendlyVehicleBroken",	message = "OnEnd",	commonFunc = function() this.FriendVehicleBroken() end },
		{ data = "Timer_RadioMoai", message = "OnEnd",
			commonFunc = function()
				if( TppMission.GetFlag( "isRadioPlayed" ) == false ) then
					TppRadio.Play("Radio_Moai")
				end
			end,
		},

	},
}
---------------------------------------------------------------------------------
--● Mission Failure
---------------------------------------------------------------------------------
this.commonMissionFailure = function( manager, messageId, message )

	local radioDaemon = RadioDaemon:GetInstance()


	radioDaemon:StopDirectNoEndMessage()	-- 再生中の無線停止
	SubtitlesCommand.StopAll()	-- 字幕の停止

	-- CP無線をフェードアウトしつつ全停止
	TppEnemyUtility.IgnoreCpRadioCall(true)	-- 以降の新規無線コールを止める
	TppEnemyUtility.StopAllCpRadio( 0.5 )	-- フェード時間

	-- BGMフェードアウト
	TppSoundDaemon.SetMute( 'GameOver' )

	-- ミッション失敗フェード開始時間を汎用値で初期化しておく（Continue対策）
	this.CounterList.GameOverFadeTime = GZCommon.FadeOutTime_MissionFailed

	if( message == "Friendly_Dead" ) then
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:CallFailedTelop( "gameover_reason_target_died" )
		this.CounterList.GameOverRadioName = "Radio_TargetDead"
		GZCommon.PlayCameraOnCommonCharacterGameOver("FriendMan")

	elseif( message == "Friendly_Slept" ) then
		this.CounterList.GameOverRadioName = "Radio_TargetSlept"
		GZCommon.PlayCameraOnCommonCharacterGameOver("FriendMan")

	elseif( message == "Helicopter_Down" ) then
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:CallFailedTelop( "gameover_reason_heli_destroyed" )
		FadeFunction.SetFadeColor( 255, 255, 255, 255 )
		TppSequence.ChangeSequence( "Seq_MissionFailed_HelicopterDead" )
		return

	elseif( message == "Helicopter_Down_withoutPlayer" ) then
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:CallFailedTelop( "gameover_reason_heli_destroyed" )
		TppSequence.ChangeSequence( "Seq_MissionFailed_HelicopterDeadNotOnPlayer" )
		return

	elseif( message == "PlayerDead" ) then
		this.CounterList.GameOverRadioName = "Radio_PlayerDead"

	-- プレイヤーが落下死亡した
	elseif( message == "PlayerFallDead" )	then

		-- プレイヤー死亡時無線名を登録しておく
		this.CounterList.GameOverRadioName = "Radio_PlayerDead"

		-- 落下死亡時はフェード開始時間を変更
		this.CounterList.GameOverFadeTime = GZCommon.FadeOutTime_PlayerFallDead

	end
	TppSequence.ChangeSequence( "Seq_MissionFailed" )
end
---------------------------------------------------------------------------------
-- Missionクリア時処理
---------------------------------------------------------------------------------
this.commonMissionClear = function( manager, messageId, message )
		Trophy.TrophyUnlock(2)
		TppSequence.ChangeSequence( "Seq_MissionClearDemoPrepare" )
end

---------------------------------------------------------------------------------
-- 報酬ポップアップの表示
---------------------------------------------------------------------------------
this.OnShowRewardPopupWindow = function()
	local sequence = TppSequence.GetCurrentSequence()
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionClearDemo01" ) ) then
		Fox.Log("-------OnShowRewardPopupWindow--------")

		-- チャレンジ要素によってアンロックされた報酬表示
		local hudCommonData = HudCommonDataManager.GetInstance()
		local challengeString = PlayRecord.GetOpenChallenge()
		local uiCommonData = UiCommonDataManager.GetInstance()
		local AllHardClear = PlayRecord.IsAllMissionClearHard()
		local Rank = PlayRecord.GetRank()

		-- **** ミッション達成率の表示 ****
		local RewardAllCount = uiCommonData:GetRewardAllCount( this.missionID )
		Fox.Log("**** ShowRewardAllCount::"..RewardAllCount)
		-- 報酬の獲得状況（達成率）表示
		hudCommonData:SetBonusPopupCounter( this.tmpRewardNum, RewardAllCount )

		-- 汎用報酬チェック
		-- 空文字になるまで繰り返す
		while ( challengeString ~= "" ) do
			Fox.Log("-------OnShowRewardPopupWindow:challengeString:::"..challengeString)

			-- PopUpの表示。表示終了メッセージを受けたら再度実行
			hudCommonData:ShowBonusPopupCommon( challengeString )
			-- PlayRecordに問い合わせ
			challengeString = PlayRecord.GetOpenChallenge()
		end

		-- クリアランク報酬チェック
		if ( ( Rank == 1 ) and ( Rank < this.tmpBestRank ) ) then
			Fox.Log("-------OnShowRewardPopupWindow:ClearRankRewardItem-------"..this.tmpBestRank)

			this.tmpBestRank = ( this.tmpBestRank - 1 )

--			hudCommonData:ShowBonusPopupCommon( "reward_clear_s_sniper" )
			hudCommonData:ShowBonusPopupItem( "reward_clear_s_sniper", "WP_sr01_v00" ) -- 通常
		end

		-- チコテープチェック（ミッション固有）
		if uiCommonData:IsHaveCassetteTape( "tp_chico_01" ) == false then	-- カセットテープ入手
			hudCommonData:ShowBonusPopupItemTape( "reward_get_tape_20040" )
			uiCommonData:GetBriefingCassetteTape( "tp_chico_01" )
		end

		local AllChicoTape = GZCommon.CheckReward_AllChicoTape()
		-- チコテープ入手チェック
		-- 全ての「チコの記録」入手で「チコの記録（完全版）」入手
		if ( AllChicoTape == true and
				 uiCommonData:IsHaveCassetteTape( "tp_chico_08" ) == false ) then
			Fox.Log("-------OnShowRewardPopupWindow:GetCompChico-------")

			-- 「チコの記録（完全版）」カセット入手ポップアップ
			hudCommonData:ShowBonusPopupItemTape( "reward_get_tape_allchico" )

			-- 「チコの記録（完全版）」カセット入手処理
			uiCommonData:GetBriefingCassetteTape( "tp_chico_08" )

		end

		-- ANUBISテープ入手チェック
		-- 全てのHardモードクリアで「ANUBISテーマ」入手
		if ( AllHardClear == true and
				 uiCommonData:IsHaveCassetteTape( "tp_bgm_01" ) == false ) then
			Fox.Log("-------OnShowRewardPopupWindow:GetAnubis-------")

			-- 「ANUBISテーマ」カセット入手ポップアップ
			hudCommonData:ShowBonusPopupItemTape( "reward_get_tape_tp_bgm_01" )

			-- 「ANUBISテーマ」カセット入手処理
			uiCommonData:GetBriefingCassetteTape( "tp_bgm_01" )

		end

		--ハードモード開放チェック
		if	TppGameSequence.GetGameFlag("hardmode") == false and					-- ノーマルクリアかつ
			PlayRecord.GetMissionScore( 20040, "NORMAL", "CLEAR_COUNT" ) == 1 then	-- 初回クリア
			hudCommonData:ShowBonusPopupCommon( "reward_extreme" )						-- ハード解放
		end

		-- いずれのポップアップも呼ばれなかったら即座に次シーケンスへ
		if ( hudCommonData:IsShowBonusPopup() == false ) then
			Fox.Log("-------OnShowRewardPopupWindow:NoPopup!!-------")
			TppSequence.ChangeSequence( "Seq_MissionEnd" )	-- ST_CLEARから先に進ませるために次シーケンスへ
		end
	end
end
---------------------------------------------------------------------------------
-- Mission後片付け
---------------------------------------------------------------------------------
this.commonMissionCleanUp = function()
	-- ミッション共通後片付け
	FadeFunction.ResetFadeColor()
	TppSupportHelicopterService.SearchLightOff()
	GZCommon.MissionCleanup()
	TppMusicManager.PostSceneSwitchEvent( 'Stop_bgm_e20040_heli' )
	TppMusicManager.EndSceneMode()
	TppRadioConditionManagerAccessor.Unregister( "Tutorial" )
	TppRadioConditionManagerAccessor.Unregister( "Basic" )
end
---------------------------------------------------------------------------------
--● 関数
---------------------------------------------------------------------------------
--■　味方死亡
this.FriendManDead = function()
	TppMission.ChangeState( "failed", "Friendly_Dead" )
	TppEnemyUtility.CallVoice( "FriendMan", "MIDDLE", "DD_Intelmen", "INTL0020", "INTELMEM" )
end

--■　味方睡眠（回収不能）
this.FriendManSlept = function()
	TppMission.ChangeState( "failed", "Friendly_Slept" )
end

--■　フレンドリーファイア
this.FriendlyDamageByPlayer = function()
	Fox.Log("***************** FRIEND DAMAGED *******************")
	if TppData.GetArgument(3) == 0 then return end
	TppEnemyUtility.CallVoice( "FriendMan", "MIDDLE", "DD_Intelmen", "INTL0230", "INTELMEM" )
	if TppData.GetArgument(2) ~= "Player" then return end
	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then
		TppRadio.Play("Radio_FriendlyFire")
	end
end

--■　味方脅威値最大
this.FriendManThreatAlart = function()
	TppRadio.Play("Radio_AimFriend")
end

--■　味方車輌撃破
this.FriendVehicleBroken = function()
	TppEnemyUtility.ChangeStatus( "FriendMan" , "Dead" )
	TppMission.ChangeState( "failed", "Friendly_Dead" )
end

--■　ヘリロストコントロール
this.HelicopterLostControl = function()
	if TppData.GetArgument(1) ~= "SupportHelicopter" then return end
	TppSupportHelicopterService.StopSearchLightAutoAim()
	TppSupportHelicopterService.SetSearchLightAngle(0.0,20.0)
	Fox.Log("***************** HELI DEAD MESSAGE *******************")
		if( TppMission.GetFlag( "isRideHeli" ) == true ) then
			TppRadio.Play("Radio_HeliDown", nil, nil, nil, "none" )
			TppMission.ChangeState("failed", "Helicopter_Down")
		elseif ( TppMission.GetFlag( "isRideHeli" ) == false ) then
			TppMission.ChangeState("failed", "Helicopter_Down_withoutPlayer")
		end
end

--■ 味方ヘリがプレイヤーに攻撃された
this.commonHeliDamagedByPlayer = function()
	Fox.Log("--------commonHeliDamagedByPlayer--------")
	if TppData.GetArgument(1) == "EnemyHelicopter" then return end
	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then
		--無線の種類に問わず再生中でなければ
		TppRadio.PlayEnqueue( "Miller_HeliAttack" )
	end
end

--■　壊れ櫓監視
this.TurretBreak = function()
	Fox.Log("***************** TURRET BROKEN *******************")
	TppMission.SetFlag( "isTurretBroken", true )
end

--■　モアイ破壊
this.MoaiBroken = function(MoaiId)
	Fox.Log("***************** MOAI HIT *******************")
	if( TppMission.GetFlag(MoaiId) == false ) then
		TppMission.SetFlag(MoaiId, true )
		this.MoaiCount()
	end
end

--■　モアイカウント
this.MoaiCount = function()
	Fox.Log("***************** MOAI WATCHER RUNS *******************")
	local moai = PlayRecord.IsMissionChallenge( "MOAI_SHOT" )
	if moai == true then
		local count = 0

		if( TppMission.GetFlag( "isMoai01_Broken" ) == true ) then	count = count + 1 end
		if( TppMission.GetFlag( "isMoai02_Broken" ) == true ) then	count = count + 1 end
		if( TppMission.GetFlag( "isMoai03_Broken" ) == true ) then	count = count + 1 end
		if( TppMission.GetFlag( "isMoai04_Broken" ) == true ) then	count = count + 1 end
		if( TppMission.GetFlag( "isMoai05_Broken" ) == true ) then	count = count + 1 end

		if count == 5 then
			PlayRecord.RegistPlayRecord( "MOAI_SHOT" )		-- 全ての木製櫓破壊達成を記録
		end

		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:AnnounceLogViewLangId( "announce_allHitMoai",count,5 )
	else
		GkEventTimerManager.Start( "Timer_RadioMoai", 1.5 )
	end

end

--■　AAGun破壊監視
this.AAGunDestroyed = function()
	Fox.Log("***************** THIS AAGUN DESTROYED *******************")
	TppRadio.Play("Radio_AAgunDestroyConfirmed",nil, nil, nil, "none" )
	TppMission.SetFlag( "isAAGunDestroyed", true )
end

--■　HeliHP監視
this.HeliHp = function()
	if TppData.GetArgument(1) ~= "SupportHelicopter" then return end
	if TppData.GetArgument(3) == "Player" then return end
	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then
		Fox.Log("***************** Heli Damaged *******************")
		local HeliDamage = TppData.GetArgument(2)
			if ( HeliDamage < 0.2 ) then
				if (HeliDamage > 0.1 ) then
					Fox.Log("***************** Heli Hp Remaining: 20%*******************")
					if( TppMission.GetFlag( "isRideHeli" ) == true ) then
						TppRadio.Play("Radio_HeliHP10", nil, nil, nil, "none" )
					elseif ( TppMission.GetFlag( "isRideHeli" ) == false ) then
						TppRadio.Play("Radio_HeliHP10")
					end
				end
			elseif ( HeliDamage < 0.3 ) then
				if (HeliDamage > 0.2 ) then
					Fox.Log("***************** Heli Hp Remaining: 30%*******************")
					if( TppMission.GetFlag( "isRideHeli" ) == true ) then
						TppRadio.Play("Radio_HeliHP50", nil, nil, nil, "none" )
					elseif ( TppMission.GetFlag( "isRideHeli" ) == false ) then
						TppRadio.Play("Radio_HeliHP50")
					end
				end
			elseif ( HeliDamage < 0.4 ) then
				if (HeliDamage > 0.3 ) then
					Fox.Log("***************** Heli Hp Remaining: 40%*******************")
					if( TppMission.GetFlag( "isRideHeli" ) == true ) then
						TppRadio.Play("Radio_HeliHP70", nil, nil, nil, "none" )
					elseif ( TppMission.GetFlag( "isRideHeli" ) == false ) then
						TppRadio.Play("Radio_HeliHP70")
					end
				end

			elseif ( HeliDamage < 0.6 ) then
				if (HeliDamage > 0.5 ) then
					Fox.Log("***************** Heli Hp Remaining: 50%*******************")
					if( TppMission.GetFlag( "isRideHeli" ) == true ) then
						TppRadio.Play("Radio_HeliDamage", nil, nil, nil, "none" )
					elseif ( TppMission.GetFlag( "isRideHeli" ) == false ) then
						TppRadio.Play("Radio_HeliDamage")
					end
				end

			elseif ( HeliDamage < 0.7 ) then
				if (HeliDamage > 0.6 ) then
					Fox.Log("***************** Heli Hp Remaining: 60%*******************")
					if( TppMission.GetFlag( "isRideHeli" ) == true ) then
						TppRadio.Play("Radio_HeliDamage", nil, nil, nil, "none" )
					elseif ( TppMission.GetFlag( "isRideHeli" ) == false ) then
						TppRadio.Play("Radio_HeliDamage")
					end
				end
			elseif ( HeliDamage < 0.8 ) then
				if (HeliDamage > 0.7 ) then
					Fox.Log("***************** Heli Hp Remaining: 80%*******************")
					if( TppMission.GetFlag( "isRideHeli" ) == true ) then
						TppRadio.Play("Radio_HeliDamage", nil, nil, nil, "none" )
					elseif ( TppMission.GetFlag( "isRideHeli" ) == false ) then
						TppRadio.Play("Radio_HeliDamage")
					end
				end
			end
	end
end

--■ 中目標
local commonUiMissionSubGoalNo = function( id )
	Fox.Log( "commonUiMissionSubGoalNo")
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end

	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end
	-- 中目標番号をその値に設定する
	luaData:SetCurrentMissionSubGoalNo( id )

	if ( id ~= 1 ) then
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:AnnounceLogViewLangId( "announce_mission_info_update" )
	end
end

--■　マーカー説明文定義
local commonMarkerText = function( id )
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end

	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end

	luaData:SetupIconUniqueInformationTable(
		{ markerId="FriendMan", langId="marker_info_under_cover" },
		{ markerId="Tactical_Vehicle_WEST_001", langId="marker_info_vehicle_4wd" },
		{ markerId="Tactical_Vehicle_WEST_002", langId="marker_info_vehicle_4wd" },
		{ markerId="Tactical_Vehicle_WEST_003", langId="marker_info_vehicle_4wd" },
		{ markerId="Tactical_Vehicle_WEST_004", langId="marker_info_vehicle_4wd" },
		{ markerId="Tactical_Vehicle_WEST_005", langId="marker_info_vehicle_4wd" },
		{ markerId="Tactical_Vehicle_WEST_006", langId="marker_info_vehicle_4wd" },
		{ markerId="Tactical_Vehicle_WEST_007", langId="marker_info_vehicle_4wd" },
		{ markerId="Tactical_Vehicle_WEST_008", langId="marker_info_vehicle_4wd" },
		{ markerId="Tactical_Vehicle_WEST_009", langId="marker_info_vehicle_4wd" },
		{ markerId="Tactical_Vehicle_WEST_010", langId="marker_info_vehicle_4wd" },
		{ markerId="Tactical_Vehicle_WEST_999", langId="marker_info_vehicle_4wd" },
		{ markerId="Truck_WEST01", langId="marker_info_truck" },
		{ markerId="Truck_WEST03", langId="marker_info_truck" },
		{ markerId="Armored_Vehicle_WEST_001", langId="marker_info_APC" },
		{ markerId="HeliRider01", langId="marker_info_mission_target" },
		{ markerId="e20040_marker_Moai01", langId="marker_info_moai" },
		{ markerId="e20040_marker_Moai02", langId="marker_info_moai" },
		{ markerId="e20040_marker_Armory", langId="marker_info_bullet_tranq" },
		{ markerId="e20040_marker_RecoillessRifle", langId="marker_info_weapon_02" },
		{ markerId="Flare", langId="marker_info_mission_targetArea" },
		{ markerId="EnemyHelicopter", langId="marker_info_heli_battle"}
	)
end

--■　味方車輌安全HP設定
local VehicleLifeHigh = function()
	local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Tactical_Vehicle_WEST_001" )
	local vehicle = vehicleObject:GetCharacter()
	local plgLife = vehicle:FindPluginByName( "Life" )
	plgLife:RequestSetMaxLife( "LeftWheelFrontLife", 99999 )
	plgLife:RequestSetMaxLife( "RightWheelFrontLife", 99999 )
	plgLife:RequestSetMaxLife( "LeftWheelSecondLife", 99999 )
	plgLife:RequestSetMaxLife( "RightWheelSecondLife", 99999 )
	plgLife:RequestSetMaxLife( "Life", 30000 )
	plgLife:RequestSetLifeMax( "LeftWheelFrontLife" )
	plgLife:RequestSetLifeMax( "RightWheelFrontLife" )
	plgLife:RequestSetLifeMax( "LeftWheelSecondLife" )
	plgLife:RequestSetLifeMax( "RightWheelSecondLife" )
	plgLife:RequestSetLifeMax( "Life" )
end

--■　味方車輌通常HP設定
local VehicleLifeNormal = function()
	local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Tactical_Vehicle_WEST_001" )
	local vehicle = vehicleObject:GetCharacter()
	local plgLife = vehicle:FindPluginByName( "Life" )
	plgLife:RequestSetMaxLife( "LeftWheelFrontLife", 15000 )
	plgLife:RequestSetMaxLife( "RightWheelFrontLife", 15000 )
	plgLife:RequestSetMaxLife( "LeftWheelSecondLife", 15000 )
	plgLife:RequestSetMaxLife( "RightWheelSecondLife", 15000 )
	plgLife:RequestSetMaxLife( "Life", 30000 )
	plgLife:RequestSetLifeMax( "LeftWheelFrontLife" )
	plgLife:RequestSetLifeMax( "RightWheelFrontLife" )
	plgLife:RequestSetLifeMax( "LeftWheelSecondLife" )
	plgLife:RequestSetLifeMax( "RightWheelSecondLife" )
	plgLife:RequestSetLifeMax( "Life" )
end

--■　味方車輌危険HP設定
local VehicleLifeLow = function()
	local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Tactical_Vehicle_WEST_001" )
	local vehicle = vehicleObject:GetCharacter()
	local plgLife = vehicle:FindPluginByName( "Life" )
	plgLife:RequestSetMaxLife( "LeftWheelFrontLife", 3000 )
	plgLife:RequestSetMaxLife( "RightWheelFrontLife", 3000)
	plgLife:RequestSetMaxLife( "LeftWheelSecondLife", 3000 )
	plgLife:RequestSetMaxLife( "RightWheelSecondLife", 3000 )
	plgLife:RequestSetMaxLife( "Life", 2000 )
	plgLife:RequestSetLifeMax( "LeftWheelFrontLife" )
	plgLife:RequestSetLifeMax( "RightWheelFrontLife" )
	plgLife:RequestSetLifeMax( "LeftWheelSecondLife" )
	plgLife:RequestSetLifeMax( "RightWheelSecondLife" )
	plgLife:RequestSetLifeMax( "Life" )
end

--■　敵車輌HP設定
local EnemyVehicleLifeLow = function(EnemyVehicleId)
	local vehicleObject = Ch.FindCharacterObjectByCharacterId(EnemyVehicleId)
	local vehicle = vehicleObject:GetCharacter()
	local plgLife = vehicle:FindPluginByName( "Life" )
	plgLife:RequestSetMaxLife( "LeftWheelFrontLife", 12000 )
	plgLife:RequestSetMaxLife( "RightWheelFrontLife", 12000 )
	plgLife:RequestSetMaxLife( "LeftWheelSecondLife", 12000 )
	plgLife:RequestSetMaxLife( "RightWheelSecondLife", 12000 )
	plgLife:RequestSetMaxLife( "Life", 5000 )
	plgLife:RequestSetLifeMax( "LeftWheelFrontLife" )
	plgLife:RequestSetLifeMax( "RightWheelFrontLife" )
	plgLife:RequestSetLifeMax( "LeftWheelSecondLife" )
	plgLife:RequestSetLifeMax( "RightWheelSecondLife" )
	plgLife:RequestSetLifeMax( "Life" )
end


--■　敵無力化判定
local IsDeadEnemy = function(characterId)
	local lifeStatus = TppEnemyUtility.GetLifeStatus(characterId)
		if lifeStatus == "Dead" then
			return true
		elseif lifeStatus == "Dying" then
			return true
		elseif lifeStatus == "Sleep" then
			return true
		elseif lifeStatus == "Faint" then
			return true
		else
			return false
	end
end

--■ ミッション全体の無力化数計測
this.DeadWatcherAlmighty = function()
	Fox.Log("***************** DEAD WATCHER TOTAL RUNS *******************")
	local count = 0
	if IsDeadEnemy("FirstEnemy01") then count = count + 1 end
	if IsDeadEnemy("FirstEnemy02") then count = count + 1 end
	if IsDeadEnemy("FirstEnemy03") then count = count + 1 end
	if IsDeadEnemy("FirstEnemy04") then count = count + 1 end
	if IsDeadEnemy("FirstEnemy05") then count = count + 1 end

	if count == 5 then
		TppMission.SetFlag( "isAdditionalEnemyForceDeactive", true )
	end
end

--■ポップアップウィンドウクローズ
this.OnClosePopupWindow = function()

	Fox.Log("-------OnClosePopupWindow--------")

	-- CloseされたポップアップのLangIdハッシュ値
	local LangIdHash = TppData.GetArgument(1)

	-- Closeされたポップアップが報酬用のものかどうかを識別
	if ( LangIdHash == this.tmpChallengeString ) then

		-- 報酬ポップアップ表示実行
		this.OnShowRewardPopupWindow()
	end
end

--■ チュートリアルボタン表示
this.Tutorial_2Button = function( textInfo, buttonIcon1, buttonIcon2 )
	-- 2ボタン
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:CallButtonGuide( textInfo, buttonIcon1, buttonIcon2 )
end

--■ ＰＣ武器を入手した時
this.Common_PickUpWeaopn = function()
	local weaponID = TppData.GetArgument( 1 )
	if weaponID == "WP_ms02" then					-- 無反動砲
		if( TppMission.GetFlag( "isPrimaryWPIcon" ) == false ) then
			this.Tutorial_2Button("tutorial_primary_wp_select", fox.PAD_U, "RStick")
			TppMission.SetFlag( "isPrimaryWPIcon", true )
		end
	elseif weaponID == "WP_sr01_v00" then				-- スナイパーライフル
		if( TppMission.GetFlag( "isPrimaryWPIcon" ) == false ) then
			this.Tutorial_2Button("tutorial_primary_wp_select", fox.PAD_U, "RStick")
			TppMission.SetFlag( "isPrimaryWPIcon", true )
		end
	end
end

---------------------------------------------------------------------------------
--● 各種設定
---------------------------------------------------------------------------------

--■　共通環境設定

local commonSetup = function ()

	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end

	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end

	luaData:SetTopMenuItemActive( "gz_helicopter", false )

	commonMarkerText()
	MissionManager.SetMiddleTextureWaitParameter( 0.5, 5 )
	TppEnemyUtility.SetThreatEnemyTime( "FriendMan", 6,0.5 )
--コンポーネントの登録
	TppRadioConditionManagerAccessor.Register( "Tutorial", TppRadioConditionTutorialPlayer{ time = 1.5 } )
	TppRadioConditionManagerAccessor.Register( "Basic", TppRadioConditionPlayerBasic{ time = 0.3 } )
	TppGimmick.OpenDoor( "Paz_PickingDoor00", 270 ) --Paz Chico Door　対応

--味方諜報員脅威値
	TppEnemyUtility.SetThreatEnemyTime( "FriendMan", 8, 1 )

--チコ檻開放（モアイ用）
	TppGimmick.OpenDoor( "AsyPickingDoor24",120 )

--ダメージメッセージ有効
	TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "FriendMan", true )
	TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "AddEnemy01", true )
	TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "AddEnemy02", true )
	TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "AddEnemy03", true )
	TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "AddEnemy04", true )
	TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "AddEnemy05", true )

--● 車輌クラッシュ設定
	TppVehicleUtility.SetCrashActionMode( "Tactical_Vehicle_WEST_001", true )
	TppVehicleUtility.SetCrashActionMode( "Tactical_Vehicle_WEST_003", true )
	TppVehicleUtility.SetCrashActionMode( "Tactical_Vehicle_WEST_004", true )
	TppVehicleUtility.SetCrashActionMode( "Tactical_Vehicle_WEST_005", true )
	TppVehicleUtility.SetCrashActionMode( "Tactical_Vehicle_WEST_006", true )
	TppVehicleUtility.SetCrashActionMode( "Tactical_Vehicle_WEST_007", true )
	TppVehicleUtility.SetCrashActionMode( "Tactical_Vehicle_WEST_008", true )
	TppVehicleUtility.SetCrashActionMode( "Tactical_Vehicle_WEST_010", true )
	TppVehicleUtility.SetCrashActionMode( "Tactical_Vehicle_WEST_011", true )
	TppVehicleUtility.SetCrashActionMode( "Tactical_Vehicle_WEST_012", true )

	TppVehicleUtility.SetNeverVanish("Tactical_Vehicle_WEST_001", true)
	TppVehicleUtility.SetNeverVanish("Tactical_Vehicle_WEST_002", true)
	TppVehicleUtility.SetNeverVanish("Tactical_Vehicle_WEST_003", true)
	TppVehicleUtility.SetNeverVanish("Tactical_Vehicle_WEST_004", true)
	TppVehicleUtility.SetNeverVanish("Tactical_Vehicle_WEST_005", true)
	TppVehicleUtility.SetNeverVanish("Tactical_Vehicle_WEST_006", true)
	TppVehicleUtility.SetNeverVanish("Tactical_Vehicle_WEST_007", true)
	TppVehicleUtility.SetNeverVanish("Tactical_Vehicle_WEST_009", true)
	TppVehicleUtility.SetNeverVanish("Tactical_Vehicle_WEST_010", true)
	TppVehicleUtility.SetNeverVanish("Tactical_Vehicle_WEST_011", true)
	TppVehicleUtility.SetNeverVanish("Tactical_Vehicle_WEST_012", true)
	TppVehicleUtility.SetNeverVanish("Truck_WEST01", true)
	TppVehicleUtility.SetNeverVanish("Truck_WEST03", true)
	TppVehicleUtility.SetNeverVanish("Armored_Vehicle_WEST_001", true)

	TppVehicleUtility.SetBlastProof( "Tactical_Vehicle_WEST_001", true )
	TppVehicleUtility.SetBlastProof( "Tactical_Vehicle_WEST_002", true )
	TppVehicleUtility.SetBlastProof( "Tactical_Vehicle_WEST_003", true )
	TppVehicleUtility.SetBlastProof( "Tactical_Vehicle_WEST_004", true )
	TppVehicleUtility.SetBlastProof( "Tactical_Vehicle_WEST_005", true )
	TppVehicleUtility.SetBlastProof( "Tactical_Vehicle_WEST_006", true )
	TppVehicleUtility.SetBlastProof( "Tactical_Vehicle_WEST_009", true )
	TppVehicleUtility.SetBlastProof( "Tactical_Vehicle_WEST_010", true )
	TppVehicleUtility.SetBlastProof( "Tactical_Vehicle_WEST_011", true )
	TppVehicleUtility.SetBlastProof( "Tactical_Vehicle_WEST_012", true )
	TppVehicleUtility.SetBlastProof( "Truck_WEST01", true )
	TppVehicleUtility.SetBlastProof( "Truck_WEST03", true )
	TppVehicleUtility.SetBlastProof( "Armored_Vehicle_WEST_001", true )

	TppVehicleUtility.SetWaitExplosionTime(  "Tactical_Vehicle_WEST_001", 0.5 )
	TppVehicleUtility.SetWaitExplosionTime(  "Tactical_Vehicle_WEST_002", 1 )
	TppVehicleUtility.SetWaitExplosionTime(  "Tactical_Vehicle_WEST_003", 3.5 )
	TppVehicleUtility.SetWaitExplosionTime(  "Tactical_Vehicle_WEST_004", 3.5 )
	TppVehicleUtility.SetWaitExplosionTime(  "Tactical_Vehicle_WEST_005", 2 )
	TppVehicleUtility.SetWaitExplosionTime(  "Tactical_Vehicle_WEST_006", 2 )
	TppVehicleUtility.SetWaitExplosionTime(  "Tactical_Vehicle_WEST_007", 2 )
	TppVehicleUtility.SetWaitExplosionTime(  "Tactical_Vehicle_WEST_009", 2 )
	TppVehicleUtility.SetWaitExplosionTime(  "Tactical_Vehicle_WEST_010", 2 )
	TppVehicleUtility.SetWaitExplosionTime(  "Tactical_Vehicle_WEST_011", 2 )
	TppVehicleUtility.SetWaitExplosionTime(  "Tactical_Vehicle_WEST_012", 2 )
	TppVehicleUtility.SetWaitExplosionTime(  "Truck_WEST01", 4 )
	TppVehicleUtility.SetWaitExplosionTime(  "Truck_WEST03", 3 )
	TppVehicleUtility.SetWaitExplosionTime(  "Armored_Vehicle_WEST_001", 1.5 )

--	TppSupportHelicopterService.SetDefaultRendezvousPointMarker("RV_SeaSide")
	TppCommandPostObject.GsSetAntiAircraftMode( "e20040CP", false )	--AA-Ai OFF
	TppCommandPostObject.GsSetForceRouteMode( this.cpID, true )--強制 ルート行動
--	TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTargetData0001", false )--増援用　GuardTarget　無効


-- アセット削除設定
	TppDataUtility.SetVisibleDataFromIdentifier( "asset_camp_west", "gntn_allm001_0023", false, false )
	TppDataUtility.SetVisibleDataFromIdentifier( "asset_camp_west", "gntn_allm001_0030", false, false )
	TppDataUtility.SetVisibleDataFromIdentifier( "asset_camp_west", "gntn_allm001_0031", false, false )
	TppDataUtility.SetVisibleDataFromIdentifier( "asset_camp_west", "gntn_allm001_0032", false, false )
	TppDataUtility.SetVisibleDataFromIdentifier( "asset_camp_west", "gntn_allm001_0033", false, false )
	TppDataUtility.SetVisibleDataFromIdentifier( "asset_camp_west", "gntn_allm001_0034", false, false )
	TppDataUtility.SetVisibleDataFromIdentifier( "asset_camp_west", "gntn_allm001_0035", false, false )


-- BGM初期設定
	TppSupportHelicopterService.SetEnableBgm(false)
	TppMusicManager.StartSceneMode()
	TppSound.PlayBGM( 'Play_bgm_e20040_heli' )
	TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_none' )

-- カウンター初期化
	this.CounterList.DeadTargets = 0
	this.CounterList.First_DeadTargets = 0
	this.DEBUG_commonPrint2DCount = 0

-- Climate Settings
	GrTools.SetLightingColorScale(4.0)
	TppEffectUtility.SetColorCorrectionLut( "gntn_25thDemo_FILTERLUT" )
--	TppEffectUtility.SetColorCorrectionLut( "/Assets/tpp/effect/gr_pic/lut/gntn_25thDemo_FILTERLUT.ftex" )--LUT指定仮対処
	WeatherManager.SetCurrentClock(5,31,0)-- Time Settings
	TppClock.Stop()
	WeatherManager.RequestWeather(0,0)--晴れにしてランダムを止める
	WeatherManager.PauseNewWeatherChangeRandom(true)--ランダム変化を止める

-- 共通ミッションセットアップ※GZCommon関連の関数はこの以下に書く事！
	GZCommon.MissionSetup()
-- 巨大ゲート機銃装甲車設定
	GZCommon.Common_CenterBigGateVehicleSetup( "e20040CP", "06_BossVehicleInfo01", "BossRoute01", "BossRoute02", 0, 1 )
-- ヘリ回収時に兵士回収のアナウンスログを出さないようにする設定
	GZCommon.EnemyLaidonHeliNoAnnounceSet( "FriendMan" )
end

--■　共通デモロード設定
local commonDemoBlockSetup = function ()
	local demoBlockPath = "/Assets/tpp/pack/mission/extra/e20040/e20040_d01.fpk"
	TppMission.LoadDemoBlock( demoBlockPath )
end

--■　Load event block
local commonEventBlockSetup = function()
	local eventBlockPath = "/Assets/tpp/pack/location/gntn/gntn_heli.fpk"
	TppMission.LoadEventBlock( eventBlockPath )
end

--■　Demo&EventBlockのLoad 完了確認
local IsDemoAndEventBlockActive = function()
	if ( TppMission.IsDemoBlockActive() == false ) then
		return false
	end
	if ( TppMission.IsEventBlockActive() == false ) then
		return false
	end
	if ( TppVehicleBlockControllerService.IsHeliBlockExist() ) then
		if ( TppVehicleBlockControllerService.IsHeliBlockActivated() == false ) then
			return false
		end
	end
	if ( MissionManager.IsMissionStartMiddleTextureLoaded() == false ) then
		return false
	end
	local hudCommonData = HudCommonDataManager.GetInstance()
	if hudCommonData:IsEndLoadingTips() == false then
		hudCommonData:PermitEndLoadingTips()
		return false
	end
	return true
end

--■　ヘリ初期設定
local commonHeliSettings = function()
	local charaObj = Ch.FindCharacterObjectByCharacterId("SupportHelicopter")
	if not Entity.IsNull(charaObj) then
		local chara = charaObj:GetCharacter()
		TppSupportHelicopterService.RequestRouteMode("route01", true, 45)
		local plgAction = chara:FindPlugin("TppHelicopterBasicActionPlugin")
		local plgPassenger = chara:FindPlugin("TppPassengerManagePlugin")
		plgPassenger:SetPossibleGettingOn(true)
		TppSupportHelicopterService.SearchLightOn()
		TppSupportHelicopterService.SetSearchLightAngle(15.0,10.0)
		TppSupportHelicopterService.SetEnableBgm(false)
		TppSupportHelicopterService.SetEnablePilotAiVoice(false)
		TppSupportHelicopterService.SetRoomLightMode(1)
		TppSupportHelicopterService.StopSearchLightAutoAim()
	else
		Fox.Warning("not found SupportHelicopter")
	end
end

--■ デバッグ表示
local commonPrint2D = function( string )
	if( this.CounterList.DEBUG_commonPrint2DCount == 10 ) then
		this.CounterList.DEBUG_commonPrint2DCount = 0
	else
		this.CounterList.DEBUG_commonPrint2DCount = this.CounterList.DEBUG_commonPrint2DCount + 1
	end
	local params = {
		life = 150,
		x = 50, y = 200+(this.CounterList.DEBUG_commonPrint2DCount*15) ,
		size = 10, color = Color( 1.0, 0.0, 0.0, 1.0 ),
		args = { string },
	}
	GrxDebug.Print2D( params )
end

---------------------------------------------------------------------------------
--● SKIP FUNCTION
---------------------------------------------------------------------------------

this.OnSkipEnterCommon = function(manager)

	local hardmode = TppGameSequence.GetGameFlag("hardmode")
	local BestRank = 0

	-- 今回の難易度によって問い合わせる戦績が異なる
	if ( hardmode ) then
		-- 難易度HARD
		BestRank = PlayRecord.GetMissionScore( this.missionID, "HARD", "BEST_RANK")
		Fox.Log("***HARD_MODE::BEST_RANK_IS____"..BestRank)
	else
		-- 難易度NORMAL
		BestRank = PlayRecord.GetMissionScore( this.missionID, "NORMAL", "BEST_RANK")
		Fox.Log("***NORMAL_MODE::BEST_RANK_IS____"..BestRank)
	end

	-- BestRankに応じて無効化するアイテムを決定
	-- ミッションクリア時の報酬獲得ポップアップ用にミッション開始時点でのBestRankを返しておく
	if ( BestRank == 1 ) then
		TppPlayer.SetWeapons( GZWeapon.e20040_SetWeapons_S )
		this.tmpBestRank = BestRank
	else
		TppPlayer.SetWeapons( GZWeapon.e20040_SetWeapons )
		this.tmpBestRank = 2
	end

	TppMusicManager.PostSceneSwitchEvent( 'Stop_bgm_e20040_heli' )
	TppMusicManager.EndSceneMode()
	TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_20' )
	TppPlayer.SetStartStatus( "rideHeli_standLeft" )
	commonSetup()

	local sequence = TppSequence.GetCurrentSequence()
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionPrepare" ) ) then
	end
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionFailed" ) ) then
		TppMission.ChangeState( "failed" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionClear" ) ) then
		TppMission.ChangeState( "clear" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionPrepare" ) ) then
		commonDemoBlockSetup()
		commonEventBlockSetup()
	elseif( sequence == "Seq_MissionPrepare" ) then
		commonDemoBlockSetup()
		commonEventBlockSetup()
	end
end

this.OnSkipUpdateCommon = function()
	return IsDemoAndEventBlockActive()
end

this.OnSkipLeaveCommon = function(manager)
	local sequence = TppSequence.GetCurrentSequence()

	if( sequence ~= "Seq_MissionPrepare" )	then
		commonHeliSettings()
		TppSupportHelicopterService.SetInitializePropellerSoundEventId("SupportHelicopter", "Set_RTPC_m_heli_int_level_50_int")
		TppSupportHelicopterService.OpenLeftDoor(true)
		Fox.Log("***************** TppSupportHelicopterService.OpenLeftDoor(true) *******************")
	end

--■ Seq_ToRescuePoint
	if( sequence == "Seq_ToRescuePoint" )  then
		TppSupportHelicopterService.RequestRouteModeWithNodeIndex("route01", 0, true, 0)
		TppSupportHelicopterService.InitializeLife(30000)
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_check_00' )

--■　Seq_Straight
	elseif( sequence == "Seq_Straight" )  then
		TppSupportHelicopterService.RequestRouteModeWithNodeIndex("route01-02", 0, true, 0)
		GZCommon.CallCautionSiren()
		TppSupportHelicopterService.InitializeLife(30000)
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_check_01' )

--■ Seq_FreeTarget (FOR DEBUG ONLY)
	elseif( sequence == "Seq_FreeTarget" )	then
		Fox.Log("***************** FREETARGET SEQ RESTART *******************")
		GZCommon.CallCautionSiren()
		TppSupportHelicopterService.InitializeLife(30000)
		TppSupportHelicopterService.RequestRouteModeWithNodeIndex("route01-2", 0, true, 0)
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_check_01' )

--■ Seq_Escoat01
	elseif( sequence == "Seq_Escoat01" )  then
		Fox.Log("***************** Escoat01 SEQ RESTART *******************")
		TppSupportHelicopterService.InitializeLife(30000)
		TppCommandPostObject.GsSetForceRouteMode( "e20040CP", true )
		TppCommandPostObject.GsDisableGroupVehicleDefaultRideRouteInfo( this.cpID, "00_FriendVehicleInfo01" )
		TppCommandPostObject.GsDisableGroupVehicleDefaultRideRouteInfo( this.cpID, "01_FreeTargetEnemyVehicleInfo01" )
		TppSupportHelicopterService.RequestRouteModeWithNodeIndex("route01-R", 0, true, 0)
		TppMission.RegisterVipRestorePoint("Tactical_Vehicle_WEST_001", "RestartLocator0001")
		TppMission.RegisterVipRestorePoint("Tactical_Vehicle_WEST_002", "RestartLocator0003")
		TppEnemyUtility.SetEnableCharacterId( "FriendMan", true )
		TppData.Enable("Tactical_Vehicle_WEST_001")
		TppData.Enable("Tactical_Vehicle_WEST_002")
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_check_02' )
		TppMission.RegisterVipRestorePoint("Tactical_Vehicle_WEST_002", "RestartLocator0003")
	--FOR DEBUG START
		if( TppMission.GetFlag( "isDebugEscoat" ) == true ) then
			Fox.Log("***************** DEBUG MENU START *******************")
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager, "Tactical_Vehicle_WEST_001", "DebugRestartLocator01_FriendVehicle" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager, "FriendMan", "DebugRestartLocator01_FriendMan" )
		elseif( TppMission.GetFlag( "isDebugEscoat" ) == false ) then
--			TppEnemyUtility.SetEnableCharacterId( "FreeTargetEnemy05", true )
--			TppEnemyUtility.SetEnableCharacterId( "FreeTargetEnemy03", true )
--			TppEnemyUtility.SetEnableCharacterId( "FreeTargetEnemy02", true )
--			TppEnemyUtility.SetEnableCharacterId( "FreeTargetEnemy01", true )
		end

--■ Seq_AAGun (FOR DEBUG ONLY)
	elseif( sequence == "Seq_AAGun" )  then
		Fox.Log("***************** AAGUN SEQ RESTART *******************")
		TppCommandPostObject.GsSetForceRouteMode( "e20040CP", true )
		TppCommandPostObject.GsDisableGroupVehicleDefaultRideRouteInfo( this.cpID, "00_FriendVehicleInfo01" )
		TppSupportHelicopterService.RequestRouteModeWithNodeIndex("route02-3-1", 0, true, 0)
		TppData.Enable("Tactical_Vehicle_WEST_001")
		TppEnemyUtility.SetEnableCharacterId( "FriendMan", true )
		TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy07", true )
		TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy07", "AAgunRoute", 0 )

		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_check_03' )
	--FOR DEBUG START
		if( TppMission.GetFlag( "isDebugAAGun" ) == true ) then
			Fox.Log("***************** DEBUG MENU START *******************")
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager, "Tactical_Vehicle_WEST_001", "DebugRestartLocator02_FriendVehicle" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager, "FriendMan", "DebugRestartLocator02_FriendMan" )
			TppEnemyUtility.ChangeStatus( "FriendMan" , "Faint" )
			TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoRecoverFaint" )
			TppMission.SetFlag( "isFriendManFaint", true )
		end

--■ Seq_SNIPE
	elseif( sequence == "Seq_Snipe" )  then
		Fox.Log("***************** SNIPE SEQ RESTART *******************")
		TppSupportHelicopterService.InitializeLife(20000)
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_check_04' )
		TppCommandPostObject.GsSetForceRouteMode( "e20040CP", true )
		TppCommandPostObject.GsDisableGroupVehicleDefaultRideRouteInfo( this.cpID, "00_FriendVehicleInfo01" )
		TppSupportHelicopterService.RequestRouteModeWithNodeIndex("route02-4", 0, true, 0)
		TppData.Enable("Tactical_Vehicle_WEST_001")
		TppMission.RegisterVipRestorePoint("Tactical_Vehicle_WEST_001", "RestartLocator0002")
		TppEnemyUtility.SetEnableCharacterId( "FriendMan", true )
		TppEnemyUtility.ChangeStatus( "FriendMan" , "Faint" )
		TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoRecoverFaint" )
		TppEnemyUtility.SetLifeFlagByCharacterId("FriendMan", "NoDamageFaint" )--設定：気絶ダメージ無効

--■ Seq_Boss
	elseif( sequence == "Seq_Boss" )  then
		Fox.Log("***************** BOSS SEQ RESTART *******************")
		TppSupportHelicopterService.InitializeLife(20000)
		GZCommon.CallAlertSiren()
		TppCommandPostObject.GsDisableGroupVehicleDefaultRideRouteInfo( this.cpID, "00_FriendVehicleInfo01" )
		TppCommandPostObject.GsDisableGroupVehicleDefaultRideRouteInfo( this.cpID, "05_SnipeVehicleInfo01" )
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_check_05' )
		TppSupportHelicopterService.RequestRouteModeWithNodeIndex("route03", 0, true, 0)
		TppMission.RegisterVipRestorePoint("Tactical_Vehicle_WEST_001", "RestartLocator0002")
		TppMission.RegisterVipRestorePoint("Tactical_Vehicle_WEST_005", "RestartLocator0004")
		TppEnemyUtility.SetEnableCharacterId( "FriendMan", true )
		TppEnemyUtility.ChangeStatus( "FriendMan" , "Faint" )
		TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoRecoverFaint" )
		TppEnemyUtility.SetLifeFlagByCharacterId("FriendMan", "NoDamageFaint" )--設定：気絶ダメージ無効
		TppData.Enable("Tactical_Vehicle_WEST_001")
		TppData.Enable("Tactical_Vehicle_WEST_005")
		--TppRadio.Play("Radio_LZCleared", nil, nil, nil, "none" )
		TppRadio.DelayPlay( "Radio_LZCleared", "mid", "none" )

	--FOR DEBUG START
		if( TppMission.GetFlag( "isDebugBoss" ) == true ) then
			Fox.Log("***************** DEBUG MENU START *******************")
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager, "Tactical_Vehicle_WEST_001", "DebugRestartLocator02_FriendVehicle" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager, "FriendMan", "DebugRestartLocator02_FriendMan" )
			TppEnemyUtility.ChangeStatus( "FriendMan" , "Faint" )
			TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoRecoverFaint" )
			TppEnemyUtility.SetLifeFlagByCharacterId("FriendMan", "NoDamageFaint" )--設定：気絶ダメージ無効
		elseif( TppMission.GetFlag( "isDebugBoss" ) == false ) then
--			TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy07", true )
--			TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy08", true )
--			TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy09", true )
--			TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy10", true )
		end

--■ Seq_Escape
	elseif( sequence == "Seq_Escape" )	then
		Fox.Log("***************** BOSS SEQ RESTART *******************")
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_check_09' )
		TppSupportHelicopterService.RequestRouteModeWithNodeIndex("route04_1", 0, true, 0)
	end
end
---------------------------------------------------------------------------------
-- ■■■■■■■■■■■■■■■■■■■■■■■■■■■■　SEQUENCES LIST　■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
---------------------------------------------------------------------------------
--● 準備シーケンス
---------------------------------------------------------------------------------
this.Seq_MissionPrepare = {
	OnEnter = function()


		Fox.Log("************* CheckClearRankReward ***************")

		local hardmode = TppGameSequence.GetGameFlag("hardmode")
		local BestRank = 0

		-- 今回の難易度によって問い合わせる戦績が異なる
		if ( hardmode ) then
			-- 難易度HARD
			BestRank = PlayRecord.GetMissionScore( this.missionID, "HARD", "BEST_RANK")
			Fox.Log("***HARD_MODE::BEST_RANK_IS____"..BestRank)
		else
			-- 難易度NORMAL
			BestRank = PlayRecord.GetMissionScore( this.missionID, "NORMAL", "BEST_RANK")
			Fox.Log("***NORMAL_MODE::BEST_RANK_IS____"..BestRank)
		end

		-- BestRankに応じて無効化するアイテムを決定
		-- ミッションクリア時の報酬獲得ポップアップ用にミッション開始時点でのBestRankを返しておく
		if ( BestRank == 1 ) then
			TppPlayer.SetWeapons( GZWeapon.e20040_SetWeapons_S )
			this.tmpBestRank = BestRank
		else
			TppPlayer.SetWeapons( GZWeapon.e20040_SetWeapons )
			this.tmpBestRank = 2
		end

		TppMission.SetInGame(false)
		TppPlayer.SetStartStatus( "rideHeli_standLeft" )

		-- これまでに獲得している報酬数を保持
		local uiCommonData = UiCommonDataManager.GetInstance()
		this.tmpRewardNum = uiCommonData:GetRewardNowCount( this.missionID )
		Fox.Log("***e20040_MissionPrepare.tmpRewardNum_IS___"..this.tmpRewardNum)

		TppSequence.ChangeSequence( "Seq_MissionSetup" )
	end,
}
---------------------------------------------------------------------------------
--● スタートアップシーケンス
---------------------------------------------------------------------------------
this.Seq_MissionSetup = {
	OnEnter = function()
		commonSetup()
		TppSupportHelicopterService.InitializeLife(30000)
		TppPlayerUtility.SetStock( TppPlayer.StockDirectionLeft )
		TppSequence.ChangeSequence( "Seq_OpeningDemoLoad" )
	end,
}
---------------------------------------------------------------------------------
--● OPデモLOADシーケンス
---------------------------------------------------------------------------------
this.Seq_OpeningDemoLoad = {

	OnEnter = function()
		commonDemoBlockSetup()
		commonEventBlockSetup()
	end,

	OnUpdate = function()
		if( IsDemoAndEventBlockActive() ) then
			commonHeliSettings()
			TppSupportHelicopterService.SetInitializePropellerSoundEventId("SupportHelicopter", "Set_RTPC_m_heli_int_level_100_int")
			TppSequence.ChangeSequence( "Seq_OpeningShowTransition" )
		end
	end,
}
---------------------------------------------------------------------------------
--● ミッション開始テロップ
---------------------------------------------------------------------------------
this.Seq_OpeningShowTransition = {
	Messages = {

	},

	OnEnter = function()
		local localChangeSequence = {
			onOpeningBgEnd = function()		-- オープニングテロップのドクロマークが終了するタイミング
				TppSequence.ChangeSequence( "Seq_OpeningDemo" )
			end,
		}
		TppUI.ShowTransition( "opening", localChangeSequence )
		TppSoundDaemon.ResetMute( "Loading" )
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_01' )
	end,


}
---------------------------------------------------------------------------------
--● Seq_OpeningDemo
---------------------------------------------------------------------------------
this.Seq_OpeningDemo = {
	Messages = {

	},
	--openingDemo 再生
	OnEnter = function()
		TppDemo.Play( "Demo_Opening", { onStart = function() TppUI.FadeIn(1) end, onEnd = function() TppSequence.ChangeSequence( "Seq_ToRescuePoint" ) end }, { disableHelicopter = false } )
	end,
}


-- ■■■■■■■■■ GAME SEQUENCES LIST ■■■■■■■■■■

---------------------------------------------------------------------------------
--● Seq_ToRescuePoint
---------------------------------------------------------------------------------
this.Seq_ToRescuePoint = {
	Messages = {
		Character = {
			{ data = "SupportHelicopter", message = "MessageRoutePoint", localFunc = "HelicopterRouteMove" },
			{ data = "FirstEnemy02", message = { "EnemySleep","EnemyDead","EnemyDying","EnemyFaint" }, commonFunc = function()TppSupportHelicopterService.StopSearchLightAutoAim()end },
		},
	},
	OnEnter = function()
		TppMissionManager.SaveGame(0000)
		commonUiMissionSubGoalNo(1)
		TppRadio.DelayPlay( "Radio_SearchStart", "mid", "none" )
--		TppRadio.Play("Radio_SearchStart", nil, nil, nil, "none" )
		TppEnemyUtility.SetEnableCharacterId( "FirstEnemy01", true )
		TppCharacterUtility.ChangeRouteCharacterId( "FirstEnemy01", "FirstRoute01", 0 )

		TppEnemyUtility.SetEnableCharacterId( "FirstEnemy02", true )
		TppCharacterUtility.ChangeRouteCharacterId( "FirstEnemy02", "FirstRoute02", 0 )

		TppEnemyUtility.SetEnableCharacterId( "FirstEnemy03", true )
		TppCharacterUtility.ChangeRouteCharacterId( "FirstEnemy03", "FirstRoute03", 0 )

		TppSupportHelicopterService.ChangeRoute("route01")
		TppSupportHelicopterService.ChangeTargetSpeed(30,0)
		TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("FirstEnemy03")
		if( TppMission.GetFlag( "isOPDemoSkip" ) == true ) then
			Fox.Log("***************** isOPDemoSkip *******************")
			TppSupportHelicopterService.RequestRouteModeWithNodeIndex("route01", 0, true, 0)
			TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_check_op' )
		end
	end,

	HelicopterRouteMove = function()
		local RouteName = TppData.GetArgument(3)
		local RoutePointNumber = TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("route01") ) then
			if(RoutePointNumber == 1) then
				TppCharacterUtility.ChangeRouteCharacterId( "FirstEnemy03", "FirstRoute03_2", 0 )
			elseif(RoutePointNumber == 2) then
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("FirstEnemy02")
				TppCharacterUtility.ChangeRouteCharacterId( "FirstEnemy02", "FirstRoute02_2", 0 )
				TppCharacterUtility.ChangeRouteCharacterId( "FirstEnemy01", "FirstRoute01_2", 0 )
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_01' )
				local characters = Ch.FindCharacters( "Bird" )
				for i=1, #characters.array do
				   local chara = characters.array[i]
				   local plgAction = chara:FindPlugin("TppBirdActionPlugin")
				   plgAction:SetForceFly()
				end
			elseif(RoutePointNumber == 3) then
				TppRadio.Play("Radio_LookFor",{onEnd = function()GZCommon.CallCautionSiren()end}, nil, nil, "none" )
				TppSupportHelicopterService.StopSearchLightAutoAim()
				TppSupportHelicopterService.SetSearchLightAngle(25.0,35.0)
			elseif(RoutePointNumber == 4) then
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_02' )

				TppEnemyUtility.SetEnableCharacterId( "FirstEnemy04", true )
				TppCharacterUtility.ChangeRouteCharacterId( "FirstEnemy04", "FirstRoute04", 0 )

				TppEnemyUtility.SetEnableCharacterId( "FirstEnemy05", true )
				TppCharacterUtility.ChangeRouteCharacterId( "FirstEnemy05", "FirstRoute05", 0 )

			elseif(RoutePointNumber == 5) then
				TppRadio.Play( "Radio_RadioIncoming", nil, nil, nil, "none" )
				TppSupportHelicopterService.SetSearchLightAngle(35.0,30.0)
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_tower1',tag = 'SingleShot',playEvent = 'sfx_m_e20040_whoosh_m',}
			elseif(RoutePointNumber == 6) then
				TppSupportHelicopterService.SetSearchLightAngle(45.0,25.0)
			elseif(RoutePointNumber == 9) then
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("Moai04")
			elseif(RoutePointNumber == 10) then
				TppSupportHelicopterService.ChangeRoute("route01-02")
				TppSequence.ChangeSequence ("Seq_Straight")
			end
		end
	end,
}
---------------------------------------------------------------------------------
--● Seq_Straight
---------------------------------------------------------------------------------
this.Seq_Straight = {
	Messages = {
		Character = {
			{ data = "SupportHelicopter", message = "MessageRoutePoint", localFunc = "HelicopterRouteMove" },
		},
		Trap = {
			{ data = "TrapFriendManOn", message = "Enter", commonFunc = function() TppSequence.ChangeSequence ("Seq_FreeTarget") end},
		},
	},

	OnEnter = function()
		TppSupportHelicopterService.SetSearchLightAngle(15.0,10.0)
		local daemon = TppSoundDaemon.GetInstance()
		TppDataUtility.CreateEffectFromId( "Flare" )
		daemon:RegisterSourceEvent{sourceName = 'Source_fixed_flare',tag = 'SingleShot',playEvent = 'sfx_m_e20040_fixed_21',}
		daemon:RegisterSourceEvent{sourceName = 'Source_fixed_tower2',tag = 'SingleShot',playEvent = 'sfx_m_e20040_whoosh_l',}
	end,


	HelicopterRouteMove = function()
		local RouteName = TppData.GetArgument(3)
		local RoutePointNumber = TppData.GetArgument(1)
		if (RouteName ==  GsRoute.GetRouteId("route01-02") ) then
			Fox.Log("***************** HELI MOVING ROUTE 01-02*******************")
			if (RoutePointNumber == 1) then
				local characters = Ch.FindCharacters( "Bird" )
				for i=1, #characters.array do
				   local chara = characters.array[i]
				   local plgAction = chara:FindPlugin("TppBirdActionPlugin")
				   plgAction:SetForceFly()
				end
			elseif (RoutePointNumber == 3) then
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("Raven0003")
				TppRadio.Play( "Radio_FoundFlare",
					{onEnd = function()
						TppMarker.Enable( "Flare", 0, "moving", "all" )
						TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_03' )
					end,},
				 nil, nil, "none" )
				TppMarkerSystem.SetMarkerNew{ markerId = "Flare", isNew = true }
			elseif (RoutePointNumber == 4) then
				TppSupportHelicopterService.StopSearchLightAutoAim()
				TppSupportHelicopterService.SetSearchLightAngle(10.0,5.0)
			elseif (RoutePointNumber == 5) then
				TppMissionManager.SaveGame(0001)
				TppEnemyUtility.SetEnableCharacterId( "StraightEne00", true )
				if( TppMission.GetFlag( "isTurretBroken" ) == false ) then
					TppCharacterUtility.ChangeRouteCharacterId( "StraightEne00", "StraightRoute00", 0 )
				elseif( TppMission.GetFlag( "isTurretBroken" ) == true ) then
					TppCharacterUtility.ChangeRouteCharacterId( "StraightEne00", "StraightRoute00_2", 0 )
				end

				TppEnemyUtility.SetEnableCharacterId( "StraightEne01", true )
				TppCharacterUtility.ChangeRouteCharacterId( "StraightEne01", "StraightRoute01", 0 )

				TppEnemyUtility.SetEnableCharacterId( "StraightEne02", true )
				TppCharacterUtility.ChangeRouteCharacterId( "StraightEne02", "StraightRoute02", 0 )

				TppEnemyUtility.SetEnableCharacterId( "StraightEne03", true )
				TppCharacterUtility.ChangeRouteCharacterId( "StraightEne03", "StraightRoute03", 0 )

				TppEnemyUtility.SetEnableCharacterId( "StraightEne04", true )
				TppCharacterUtility.ChangeRouteCharacterId( "StraightEne04", "StraightRoute04", 0 )

				TppEnemyUtility.SetEnableCharacterId( "StraightEne05", true )
				TppCharacterUtility.ChangeRouteCharacterId( "StraightEne05", "StraightRoute05", 0 )

				TppEnemyUtility.SetEnableCharacterId( "StraightEne06", true )
				TppCharacterUtility.ChangeRouteCharacterId( "StraightEne06", "StraightRoute06", 0 )

				TppEnemyUtility.SetEnableCharacterId( "StraightEne07", true )
				TppCharacterUtility.ChangeRouteCharacterId( "StraightEne07", "StraightRoute07", 0 )

				TppEnemyUtility.SetEnableCharacterId( "StraightEne08", true )
				TppCharacterUtility.ChangeRouteCharacterId( "StraightEne08", "StraightRoute08", 0 )

				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FirstEnemy01", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FirstEnemy02", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FirstEnemy03", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FirstEnemy04", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FirstEnemy05", false )
			elseif (RoutePointNumber == 6) then
				TppRadio.Play("Radio_EnemieFireIncoming", nil, nil, nil, "none" )
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("StraightEne02")
			elseif (RoutePointNumber == 9) then
				TppSupportHelicopterService.ChangeRoute("route01-03")
			end
		elseif (RouteName ==  GsRoute.GetRouteId("route01-03") ) then
			if (RoutePointNumber == 0) then
				TppSupportHelicopterService.StopSearchLightAutoAim()
			elseif (RoutePointNumber == 2) then
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("StraightEne04")
				local hudCommonData = HudCommonDataManager.GetInstance()
				hudCommonData:CallButtonGuide( "tutorial_change_barrel", "PL_HOLD", "PL_ACTION" )
				TppRadio.Play("Radio_UseUnderBarrel", nil, nil, nil, "none" )
			elseif (RoutePointNumber == 4) then
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("StraightEne05")
			elseif (RoutePointNumber == 5) then
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_pole1',tag = 'SingleShot',playEvent = 'sfx_m_e20040_whoosh_s',}
			end
		end
	end,
}
---------------------------------------------------------------------------------
--● Seq_FreeTarget
---------------------------------------------------------------------------------
this.Seq_FreeTarget = {
	Messages = {
		Character = {
			{ data = "SupportHelicopter", message = "MessageRoutePoint", localFunc = "HelicopterRouteMove" },
			{ data = "FriendMan",	message = "MessageRoutePoint",	localFunc = "FriendVehicleMovement" },
			{ data = "FriendMan", message = "EnemyThreat", commonFunc = function() this.FriendManThreatAlart() end },
			{ data = "FreeTargetEnemy03",	message = "MessageRoutePoint",	localFunc = "EnemyVehicleMovement" },
			{ data = "FriendMan", message = "EnemyThreat", commonFunc = function() this.FriendManThreatAlart() end },
			{ data = "FriendMan", message = "EnemySleep", commonFunc = function() this.FriendManSlept() end },
			{ data = "Tactical_Vehicle_WEST_001", message = "VehicleBroken", commonFunc = function() GkEventTimerManager.Start( "Timer_FriendlyVehicleBroken", 0.5 ) end },
			{ data = "e20040CP", message ="EndGroupVehicleRouteMove", localFunc = "EndVehicleMove"},
			{ data = "FreeTargetEnemy05", message = { "EnemySleep","EnemyDead","EnemyDying","EnemyFaint" }, localFunc = "DeadWatcher" },
			{ data = "FreeTargetEnemy03", message = { "EnemySleep","EnemyDead","EnemyDying","EnemyFaint" }, localFunc = "DeadWatcher" },
			{ data = "FreeTargetEnemy01", message = { "EnemySleep","EnemyDead","EnemyDying","EnemyFaint" }, localFunc = "DeadWatcher" },
			{ data = "FreeTargetEnemy02", message = { "EnemySleep","EnemyDead","EnemyDying","EnemyFaint" }, localFunc = "DeadWatcher" },
		},

		Timer = {
			{ data = "Timer_RadioOn", message = "OnEnd", commonFunc = function() TppRadio.Play("Radio_TargetConfirmed",{onEnd = function() commonUiMissionSubGoalNo(2) end,}, nil, nil, "none" )end},
			{ data = "Timer_MarkerOn",	message = "OnEnd",	localFunc = "MarkerOn" },
		},
	},

	OnEnter = function()
		Fox.Log( "***************** FRIEND MAN ACTIVATED *******************" )
		TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0000", false, false )
		TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0004", false, false )
		TppSupportHelicopterService.StopSearchLightAutoAim()
		TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_04' )
		TppEnemyUtility.SetEnableCharacterId( "FriendMan", true )
		TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "FriendMan", true )
		TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoDamageSleep" ) --設定：睡眠ダメージ無効
		TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoDamageFaint" ) --設定：気絶ダメージ無効
		TppData.Enable( "Tactical_Vehicle_WEST_001" )
		TppMission.SetFlag( "isDebugEscoat", false )
		TppEnemyUtility.SetEnableCharacterId( "Raven0000", false )
		TppEnemyUtility.SetEnableCharacterId( "Raven0001", false )
		TppEnemyUtility.SetEnableCharacterId( "Raven0002", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "StraightEne01", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "StraightEne02", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "StraightEne03", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "StraightEne04", false )
	end,


	FriendVehicleMovement = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		Fox.Log("RouteName"..RouteName)
		if( RouteName ==  GsRoute.GetRouteId("VehicleRoute01")	) then
			if( RoutePointNumber == 0 ) then
				Fox.Log("***************** NODE 00 *******************")
				TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0003", false, false )
			elseif( RoutePointNumber == 1 ) then
				Fox.Log("***************** NODE 01 *******************")
				VehicleLifeHigh()
				TppData.Enable( "Tactical_Vehicle_WEST_002" )
				TppEnemyUtility.SetEnableCharacterId( "FreeTargetEnemy01", true )
				TppCharacterUtility.ChangeRouteCharacterId( "FreeTargetEnemy01", "FreeTargetRoute01", 0 )

				TppEnemyUtility.SetEnableCharacterId( "FreeTargetEnemy02", true )
				TppCharacterUtility.ChangeRouteCharacterId( "FreeTargetEnemy02", "FreeTargetRoute02", 0 )

				TppEnemyUtility.SetEnableCharacterId( "FreeTargetEnemy03", true ) --Vehicle Rider

				TppEnemyUtility.SetEnableCharacterId( "FreeTargetEnemy05", true )
				TppCharacterUtility.ChangeRouteCharacterId( "FreeTargetEnemy05", "FreeTargetRoute05", 0 )
				TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0003", false, false )

			elseif( RoutePointNumber == 2 ) then
				Fox.Log("***************** NODE 02 *******************")
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("FriendMan")
				GkEventTimerManager.Start( "Timer_RadioOn", 2.5 )
				GkEventTimerManager.Start( "Timer_MarkerOn", 4.0 )
			elseif( RoutePointNumber == 3 ) then
				TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0003", true, false )
			end
		end
	end,


	MarkerOn = function()
		TppMarkerSystem.DisableMarker{ markerId = "Flare" }
		TppDataUtility.DestroyEffectFromId( "Flare" )
		TppMarker.Enable( "FriendMan", 0, "defend", "map_and_world_only_icon")
		TppMarkerSystem.SetMarkerImportant{ markerId="FriendMan", isImportant=true }
		TppMarkerSystem.SetMarkerNew{ markerId = "FriendMan", isNew = true }
		TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoDamageSleep" ) --設定：睡眠ダメージ無効
		TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoDamageFaint" ) --設定：気絶ダメージ無効
--		TppUI.ShowAllMarkers()
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:AnnounceLogViewLangId( "announce_mission_40_20040_004_from_0_prio_0" )
	end,

	EndVehicleMove = function()
		local arg2 = TppData.GetArgument(2)
		if arg2.vehicleCharacterId == "Tactical_Vehicle_WEST_001" then
			Fox.Log("***************** END VEHICLE ONE *******************")
			TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0004", true, false )
			TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("FreeTargetEnemy05")
			TppCharacterUtility.ChangeRouteCharacterId( "FriendMan", "FriendManRoute02_C", 0 )
			TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0000", true, false )
			TppCommandPostObject.GsSetRealizeEnable( this.cpID, "StraightEne00", false )
			TppCommandPostObject.GsSetRealizeEnable( this.cpID, "StraightEne05", false )
			TppCommandPostObject.GsSetRealizeEnable( this.cpID, "StraightEne06", false )
			TppCommandPostObject.GsSetRealizeEnable( this.cpID, "StraightEne07", false )
			TppCommandPostObject.GsSetRealizeEnable( this.cpID, "StraightEne08", false )
		elseif arg2.vehicleCharacterId == "Tactical_Vehicle_WEST_002" then
			Fox.Log("***************** END VEHICLE TWO *******************")
			TppCharacterUtility.ChangeRouteCharacterId( "FreeTargetEnemy03", "FreeTargetRoute03", 0 )
		end
	end,


	DeadWatcher = function()
		local count = 0
		Fox.Log("***************** DEAD WATCHER FREE_TGT RUNS *******************")
			if IsDeadEnemy("FreeTargetEnemy05") then
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("FreeTargetEnemy01")
				TppCharacterUtility.ChangeRouteCharacterId( "FriendMan", "FriendManRoute02_R", 0 )
				count = count + 1
			end
			if IsDeadEnemy("FreeTargetEnemy03") then
				TppCharacterUtility.ChangeRouteCharacterId( "FriendMan", "FriendManRoute02_L", 0 )
				count = count + 1
			end
			if IsDeadEnemy("FreeTargetEnemy02") then
				count = count + 1
			end
			if IsDeadEnemy("FreeTargetEnemy01") then
				count = count + 1
				if IsDeadEnemy("FreeTargetEnemy05") then
					if IsDeadEnemy("FreeTargetEnemy02") then
						if IsDeadEnemy("FreeTargetEnemy01") then
							TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("FreeTargetEnemy03")
						end
					end
				end
			end
			if count >= 4 then
				Fox.Log("***************** count >= 4 : ROUTE CHANGE ********************")
				TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0004", false, false )
				TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_02' )
				TppSequence.ChangeSequence( "Seq_Escoat01" )
			end
	end,


	HelicopterRouteMove = function()
		local RouteName = TppData.GetArgument(3)
		local RoutePointNumber = TppData.GetArgument(1)
		if (RouteName ==  GsRoute.GetRouteId("route01-03") ) then
			if (RoutePointNumber == 11) then
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_pole2',tag = 'SingleShot',playEvent = 'sfx_m_e20040_whoosh_s_w',}
			end
		end
	end,

}
---------------------------------------------------------------------------------
--● Seq_Escoat01
---------------------------------------------------------------------------------

this.Seq_Escoat01 = {
	Messages = {
		Character = {
			{ data = "SupportHelicopter", message = "MessageRoutePoint", localFunc = "HelicopterRouteMove" },
			{ data = "FriendMan", message = "MessageRoutePoint", localFunc = "FriendVehicleMovement" },
			{ data = "FriendMan", message = "EnemySleep", commonFunc = function() this.FriendManSlept() end },
			{ data = "FriendMan", message = "EnemyThreat", commonFunc = function() this.FriendManThreatAlart() end },
			{ data = "Tactical_Vehicle_WEST_001", message = "VehicleBroken", commonFunc = function() GkEventTimerManager.Start( "Timer_FriendlyVehicleBroken", 0.5 ) end },
			{ data = "FriendMan", message = "VehicleBroken", commonFunc = function() this.FriendVehicleBroken() end },
			{ data = "Tactical_Vehicle_WEST_003", message = "VehicleBroken", localFunc = "EnemyVehicleBroken"},
			{ data = "FollowVehicleEnemy01", message = "MessageRoutePoint", localFunc = "FollowVehicleMovement"},
			{ data = "e20040CP", message ="EndGroupVehicleRouteMove", localFunc = "EndVehicleMove"},
		},
		Timer = {
			{ data = "VehicleLifeRecover",	message = "OnEnd",	commonFunc = function() VehicleLifeHigh() end },
			{ data = "Timer_LightAim",	message = "OnEnd",	localFunc = "LightAimOff" },
			{ data = "Timer_FollowVehicle00Gen",	message = "OnEnd",	localFunc = "FollowVehicle00Gen" },
			{ data = "Timer_SearchLightMove01",	message = "OnEnd",	localFunc = "SearchLightMovement01" },
			{ data = "Timer_SearchLightMove02",	message = "OnEnd",	localFunc = "SearchLightMovement02" },
			{ data = "Timer_SearchLightMove03",	message = "OnEnd",	localFunc = "SearchLightMovement03" },
		},
	},

	OnEnter = function()
		Fox.Log( "***************** ENTER ESCOAT SEQs *******************" )
		TppMissionManager.SaveGame(0002)
		TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("Tactical_Vehicle_WEST_001")
		GkEventTimerManager.Start( "VehicleLifeRecover", 1 )
		TppMarker.Enable( "Heliport", 3, "moving", "map" )
		TppSupportHelicopterService.StopSearchLightAutoAim()
		TppSupportHelicopterService.SetSearchLightAngle(45.0,10.0)
		GkEventTimerManager.Start( "Timer_SearchLightMove01", 2 )
		GkEventTimerManager.Start( "Timer_FollowVehicle00Gen", 6 )

		TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoDamageSleep" ) --設定：睡眠ダメージ無効
		TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoDamageFaint" ) --設定：気絶ダメージ無効
		TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "FriendMan", true )
	end,

	SearchLightMovement01 = function()
		Fox.Log("***************** TIMER 01 END *******************")
		TppSupportHelicopterService.SetSearchLightAngle(110.0,5.0)
		TppRadio.Play( "Radio_StartEscoating", {onEnd = function() TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_03' )end,}, nil, nil, "none" )
		TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy13", true )
		TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy13", "EscoatRoute13", 0 )

		TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy14", true )
		TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy14", "EscoatRoute14", 0 )

		GkEventTimerManager.Start( "Timer_SearchLightMove02", 1 )
	end,

	SearchLightMovement02 = function()
		Fox.Log("***************** TIMER 02 END *******************")
		TppSupportHelicopterService.SetSearchLightAngle(50.0,10.0)
		GkEventTimerManager.Start( "Timer_SearchLightMove03", 2 )
	end,

	SearchLightMovement03 = function()
		Fox.Log("***************** TIMER 03 END *******************")
		TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("FriendMan")
		TppCharacterUtility.ChangeRouteCharacterId( "FriendMan", "FriendManRoute03", 0 )
		TppSupportHelicopterService.ChangeRoute("route02-1-1")
	end,

	FollowVehicle00Gen = function()
		TppEnemyUtility.SetEnableCharacterId( "FollowVehicleEnemy00", true )
		TppData.Enable("Tactical_Vehicle_WEST_007")
	end,

	FriendVehicleMovement = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("VehicleRoute02")	) then	-- 　敵兵の場合はこちらで、GsRoute.GetRouteId("VehicleRoute")
			if( RoutePointNumber == 0 ) then
				Fox.Log("***************** NODE 00 通過 *******************")
				VehicleLifeNormal()
				TppEnemyUtility:SetLifeByCharacterId( "FriendMan", "Life", 50000 )
				VehicleLifeNormal()
			elseif( RoutePointNumber == 1 ) then
				Fox.Log("***************** NODE 01 通過 *******************")
				TppEnemyUtility.CallVoice( "FriendMan", "MIDDLE", "DD_Intelmen", "INTL0090", "INTELMEM" )
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_05' )
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_pole3',tag = 'SingleShot',playEvent = 'sfx_m_e20040_whoosh_s',}
			elseif( RoutePointNumber == 2 ) then
				Fox.Log("***************** NODE 02 通過 *******************")
				TppSupportHelicopterService.ChangeTargetSpeed("SupportHelicopter",25, 0)
				TppSupportHelicopterService.ChangeRoute("route02-1-2")
				TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy11", true )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy11", "EscoatRoute11", 0 )

				TppEnemyUtility.SetEnableCharacterId(  "EscoatEnemy12", true )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy12", "EscoatRoute12", 0 )

				TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy15", true )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy15", "EscoatRoute15", 0 )

				TppEnemyUtility.CallVoice( "FriendMan", "MIDDLE", "DD_Intelmen", "INTL0060", "INTELMEM" )
			elseif( RoutePointNumber == 3 ) then
				Fox.Log("***************** NODE 03 通過 *******************")
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy13", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy14", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FollowVehicleEnemy00", false )

				TppData.Disable("Tactical_Vehicle_WEST_007")
				TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_007" }

				TppEnemyUtility.SetEnableCharacterId( "FollowVehicleEnemy01", true )
				TppData.Enable("Tactical_Vehicle_WEST_003")
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_car1',tag = 'SingleShot',playEvent = 'sfx_m_e20040_fixed_22',}
			elseif( RoutePointNumber == 4 ) then
				Fox.Log("***************** NODE 04 通過 *******************")
			elseif( RoutePointNumber == 5) then
				Fox.Log("***************** NODE 05 通過 *******************")
				TppRadio.Play( "Radio_ShootRight", nil, nil, nil, "none" )
				EnemyVehicleLifeLow("Tactical_Vehicle_WEST_003")

				TppData.Disable( "Tactical_Vehicle_WEST_002" )
				TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_002" }

				TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy16", true )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy16", "EscoatEnemy16", 0 )

				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FreeTargetEnemy01", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FreeTargetEnemy02", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FreeTargetEnemy03", false )
--				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FreeTargetEnemy04", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FreeTargetEnemy05", false )
			elseif( RoutePointNumber == 6) then
				Fox.Log("***************** NODE 06 通過 *******************")
				TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy01", true )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy01", "EscoatRoute01", 0 )
			elseif( RoutePointNumber == 9 ) then
				TppSequence.ChangeSequence( "Seq_Escoat02" )
				TppEnemyUtility.CallVoice( "FriendMan", "MIDDLE", "DD_Intelmen", "INTL0030", "INTELMEM" )
			end
		end
	end,

	FollowVehicleMovement = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("FollowVehicle01_02")	) then
			if( RoutePointNumber == 5 ) then
				Fox.Log("***************** LIFE SET LOW *******************")
				VehicleLifeLow()
				TppVehicleUtility.SetCrashActionMode( "Tactical_Vehicle_WEST_003", false )
			end
		end
	end,

	EnemyVehicleBroken = function()
		GkEventTimerManager.Start( "Timer_LightAim", 1 )
		TppRadio.Play("Radio_NiceShoot", nil, nil, nil, "none" )
		VehicleLifeNormal()
	end,

	LightAimOff = function()
		TppSupportHelicopterService.StopSearchLightAutoAim()
		TppSupportHelicopterService.SetSearchLightAngle(15.0,15.0)
	end,

	HelicopterRouteMove = function()
		local RouteName = TppData.GetArgument(3)
		local RoutePointNumber = TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("route02-1-1") ) then
			if	(RoutePointNumber == 1) then
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("EscoatEnemy14")
			end
		elseif( RouteName ==  GsRoute.GetRouteId("route02-1-2") ) then
			if	(RoutePointNumber == 5) then
--				TppSupportHelicopterService.ChangeAngleRateXZ(0.3)
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("Tactical_Vehicle_WEST_003")
			elseif (RoutePointNumber == 6) then
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_06' )
			elseif (RoutePointNumber == 14) then
				TppSupportHelicopterService.StopSearchLightAutoAim()
				TppSupportHelicopterService.SetSearchLightAngle(15.0,15.0)
			elseif (RoutePointNumber == 18) then
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_07' )
			end
		end
	end,

	EndVehicleMove = function()
		local arg2 = TppData.GetArgument(2)
		if arg2.vehicleCharacterId == "Tactical_Vehicle_WEST_007" then
			TppCharacterUtility.ChangeRouteCharacterId( "FollowVehicleEnemy00", "FollowVehicleEnemy00Route", 0 )
		end
	end,
}
---------------------------------------------------------------------------------
--● Seq_Escoat02
---------------------------------------------------------------------------------

this.Seq_Escoat02 = {
	Messages = {
		Character = {
			{ data = "SupportHelicopter", message = "MessageRoutePoint", localFunc = "HelicopterRouteMove" },
			{ data = "FriendMan",	message = "MessageRoutePoint",	localFunc = "FriendVehicleMovement" },
			{ data = "FriendMan", message = "EnemySleep", commonFunc = function() this.FriendManSlept() end },
			{ data = "FriendMan", message = "EnemyThreat", commonFunc = function() this.FriendManThreatAlart() end },
			{ data = "FollowVehicleEnemy02", message = "MessageRoutePoint", localFunc = "TruckRouteMove"  },
			{ data = "Tactical_Vehicle_WEST_001", message = "VehicleBroken", commonFunc = function() GkEventTimerManager.Start( "Timer_FriendlyVehicleBroken", 0.5 ) end },
			{ data = "Truck_WEST01", message = "VehicleBroken", localFunc = "TruckBroken" },
			{ data = "FollowVehicleEnemy02", message = {"EnemyDead","EnemyFaint"}, localFunc = "TruckDriverKilled"},
		},

		Timer = {
			{ data = "Timer_HokenKun",	message = "OnEnd",	localFunc = "HokenKun" },
		},
	},

	OnEnter = function()
--敵兵を消す
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy11", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy12", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy15", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy16", false )

		TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0005", false, false )
		TppSupportHelicopterService.SetSearchLightAngle(25.0,15.0)

		TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy02", true )
		TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy02", "EscoatRoute02", 0 )
		TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy03", true )
		TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy03", "EscoatRoute03", 0 )
	end,

	FriendVehicleMovement = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("VehicleRoute02")	) then	-- 　敵兵の場合はこちらで、GsRoute.GetRouteId("VehicleRoute")
			if( RoutePointNumber == 10 ) then
				Fox.Log("***************** 通過10 ROUTE CHANGE*******************")
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_truck',tag = 'SingleShot',playEvent = 'sfx_m_e20040_fixed_23',}
				TppData.Enable("Truck_WEST01")
				VehicleLifeHigh()
				TppVehicleUtility.SetCrashActionMode( "Truck_WEST01", false )
				TppEnemyUtility.SetEnableCharacterId( "FollowVehicleEnemy02", true )

				TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy08", true )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy08", "EscoatRoute08", 0 )

				TppSupportHelicopterService.ChangeRoute("route02-2-1")
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_08' )
			elseif( RoutePointNumber == 11 ) then
				TppRadio.Play( "Radio_ShootCenter" , nil, nil, nil, "none" )
				TppMusicManager.PostSceneSwitchEvent('Set_Switch_bgm_e20040_heli_03_b' )
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("Truck_WEST01")
			elseif( RoutePointNumber == 13 ) then
				Fox.Log("***************** 通過13 *******************")

--敵兵を消す
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FollowVehicleEnemy01", false )

				TppData.Disable("Tactical_Vehicle_WEST_003")
				TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_003" }

				TppSupportHelicopterService.ChangeRoute("route02-2-2")
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_10' )
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_drivingtech',tag = 'SingleShot',playEvent = 'sfx_m_e20040_fixed_24',}
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy03", "EscoatRoute03-2", 0 )
			elseif( RoutePointNumber == 15 ) then
				TppRadio.Play("Radio_GreatDrive", nil, nil, nil, "none" )
				TppSequence.ChangeSequence( "Seq_Escoat03" )
			end
		end
	end,

	TruckRouteMove = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("FollowVehicle02_02")	) then
--トラックが動き出す
			if( RoutePointNumber == 0 ) then
				Fox.Log("***************** TRUCK LIFE MAX *******************")
				local vehicleObjectTruck = Ch.FindCharacterObjectByCharacterId( "Truck_WEST01" )
				local vehicleTruck = vehicleObjectTruck:GetCharacter()
				local plgLifeTruck = vehicleTruck:FindPluginByName( "Life" )
				plgLifeTruck:RequestSetMaxLife( "Life", 9999999 )
				plgLifeTruck:RequestSetMaxLife( "LeftWheelFrontLife", 9999999 )
				plgLifeTruck:RequestSetMaxLife( "RightWheelFrontLife", 9999999 )
				plgLifeTruck:RequestSetMaxLife( "LeftWheelSecondLife", 9999999 )
				plgLifeTruck:RequestSetMaxLife( "RightWheelSecondLife", 9999999 )
				plgLifeTruck:RequestSetMaxLife( "LeftWheelThirdLife", 9999999 )
				plgLifeTruck:RequestSetMaxLife( "RightWheelThirdLife", 9999999 )
				plgLifeTruck:RequestSetLifeMax( "Life" )
				plgLifeTruck:RequestSetLifeMax( "LeftWheelFrontLife" )
				plgLifeTruck:RequestSetLifeMax( "RightWheelFrontLife" )
				plgLifeTruck:RequestSetLifeMax( "LeftWheelSecondLife" )
				plgLifeTruck:RequestSetLifeMax( "RightWheelSecondLife" )
				plgLifeTruck:RequestSetLifeMax( "LeftWheelThirdLife" )
				plgLifeTruck:RequestSetLifeMax( "RightWheelThirdLife" )
--トラックがバックして切り返す
			elseif( RoutePointNumber == 3 ) then
				Fox.Log("***************** TRUCK LIFE NORMAL *******************")
				TppEnemyUtility.CallVoice( "FriendMan", "MIDDLE", "DD_Intelmen", "INTL0040", "INTELMEM" )
				local vehicleObjectTruck = Ch.FindCharacterObjectByCharacterId( "Truck_WEST01" )
				local vehicleTruck = vehicleObjectTruck:GetCharacter()
				local plgLifeTruck = vehicleTruck:FindPluginByName( "Life" )
				plgLifeTruck:RequestSetMaxLife( "Life", 99999 )
				plgLifeTruck:RequestSetMaxLife( "LeftWheelFrontLife", 32000 )
				plgLifeTruck:RequestSetMaxLife( "RightWheelFrontLife", 32000 )
				plgLifeTruck:RequestSetMaxLife( "LeftWheelSecondLife", 32000 )
				plgLifeTruck:RequestSetMaxLife( "RightWheelSecondLife", 32000 )
				plgLifeTruck:RequestSetMaxLife( "LeftWheelThirdLife", 32000 )
				plgLifeTruck:RequestSetMaxLife( "RightWheelThirdLife", 32000 )
				plgLifeTruck:RequestSetLifeMax( "Life" )
				plgLifeTruck:RequestSetLifeMax( "LeftWheelFrontLife" )
				plgLifeTruck:RequestSetLifeMax( "RightWheelFrontLife" )
				plgLifeTruck:RequestSetLifeMax( "LeftWheelSecondLife" )
				plgLifeTruck:RequestSetLifeMax( "RightWheelSecondLife" )
				plgLifeTruck:RequestSetLifeMax( "LeftWheelThirdLife" )
				plgLifeTruck:RequestSetLifeMax( "RightWheelThirdLife" )
				TppVehicleUtility.SetCrashActionMode( "Truck_WEST01", true )
				VehicleLifeLow()
			elseif( RoutePointNumber == 6 ) then
				Fox.Log("***************** TRUCK MOVING ********************")
				GkEventTimerManager.Start( "Timer_HokenKun", 2 )
			end
		end
	end,

	HokenKun = function()
		local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Tactical_Vehicle_WEST_001" )
		local vehicle = vehicleObject:GetCharacter()
		local plgLife = vehicle:FindPluginByName( "Life" )
		plgLife:RequestSetLife( "Life", 0 )
		vehicle:SendMessage( ChDamageActionRequest() )
	end,

	HelicopterRouteMove = function()
		local RouteName = TppData.GetArgument(3)
		local RoutePointNumber = TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("route02-2-1") ) then
			if	(RoutePointNumber == 2) then
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_09' )
			end
		elseif( RouteName ==  GsRoute.GetRouteId("route02-2-2") ) then
			if	(RoutePointNumber == 2) then
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy01", "EscoatRoute01-2", 0 )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy02", "EscoatRoute02-2", 0 )
			elseif	(RoutePointNumber == 3) then
				TppSupportHelicopterService.ChangeRoute("route02-2-3")
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_11' )
			end
		end
	end,

	TruckBroken = function()
		TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0005", true, false )
	end,

	TruckDriverKilled = function()
		TppEnemyUtility.CallVoice( "FriendMan", "MIDDLE", "DD_Intelmen", "INTL0110", "INTELMEM" )
		TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0005", true, false )
	end,
}
---------------------------------------------------------------------------------
--● Seq_Escoat03
---------------------------------------------------------------------------------

this.Seq_Escoat03 = {
	Messages = {
		Character = {
			{ data = "SupportHelicopter", message = "MessageRoutePoint", localFunc = "HelicopterRouteMove" },
			{ data = "FriendMan",	message = "MessageRoutePoint",	localFunc = "FriendVehicleMovement" },
			{ data = "FriendMan", message = "EnemySleep", commonFunc = function() this.FriendManSlept() end },
			{ data = "FriendMan", message = "EnemyThreat", commonFunc = function() this.FriendManThreatAlart() end },
			{ data = "Tactical_Vehicle_WEST_001", message = "VehicleBroken", commonFunc = function() GkEventTimerManager.Start( "Timer_FriendlyVehicleBroken", 0.5 ) end },
			{ data = "Tactical_Vehicle_WEST_004", message = "VehicleBroken", localFunc = "EnemyVehicleBroken" },
		},
	},

	OnEnter = function()
		TppSupportHelicopterService.ChangeAngleRateXZ(1.0)
		TppSupportHelicopterService.StopSearchLightAutoAim()
		TppSupportHelicopterService.SetSearchLightAngle(25.0,10.0)
		TppMission.SetFlag( "isDebugAAGun", false )

		TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy05", true )
		TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy05", "EscoatRoute05", 0 )
		TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy06", true )
		TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy06", "EscoatRoute06", 0 )

	end,

	FriendVehicleMovement = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("VehicleRoute02")	) then

			if( RoutePointNumber == 16 ) then
				TppSupportHelicopterService.ChangeRoute("route02-3")
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_12' )

			elseif( RoutePointNumber == 17 ) then
				Fox.Log("***************** NODE 17 *******************")
				VehicleLifeNormal()
				TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy04", true )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy04", "EscoatRoute04", 0 )

				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy05", "EscoatRoute05_2", 0 )
			elseif( RoutePointNumber == 18 ) then
				Fox.Log("***************** NODE 18 *******************")
				TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy09", true )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy09", "EscoatRoute09", 0 )

				TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy10", true )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy10", "EscoatRoute10", 0 )

				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy01", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy02", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy03", false )
				TppData.Enable("Tactical_Vehicle_WEST_004")
				TppEnemyUtility.SetEnableCharacterId( "FollowVehicleEnemy03", true )
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_car2',tag = 'SingleShot',playEvent = 'sfx_m_e20040_fixed_25',}
			elseif( RoutePointNumber == 19 ) then
				EnemyVehicleLifeLow("Tactical_Vehicle_WEST_004")
				TppRadio.Play("Radio_Incoming")
			elseif( RoutePointNumber == 20 ) then
				Fox.Log("***************** NODE 20 *******************")
				TppRadio.Play( "Radio_AboutToGetHeliport" , nil, nil, nil, "none" )
			elseif( RoutePointNumber == 22 ) then
				VehicleLifeLow()
--				TppData.Enable("Tactical_Vehicle_WEST_004")
--				TppEnemyUtility.SetEnableCharacterId( "FollowVehicleEnemy03", true )
			end
		end
	end,

	HelicopterRouteMove = function()
		local RouteName = TppData.GetArgument(3)
		local RoutePointNumber = TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("route02-3") ) then
			if (RoutePointNumber == 3) then
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("EscoatEnemy09")
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy20", false )
			elseif (RoutePointNumber == 4) then
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_13' )
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_tower3',tag = 'SingleShot',playEvent = 'sfx_m_e20040_whoosh_m',}
			elseif (RoutePointNumber == 7) then
				TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy17", true )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy17", "EscoatRoute17", 0 )
				TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy19", true )
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy19", "EscoatRoute19", 0 )
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_14' )
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_pole4',tag = 'SingleShot',playEvent = 'sfx_m_e20040_whoosh_s',}
				TppSupportHelicopterService.StopSearchLightAutoAim()
			elseif (RoutePointNumber == 9) then
				TppData.Enable("Tactical_Vehicle_WEST_009")
				TppEnemyUtility.SetEnableCharacterId( "FollowVehicleEnemy04", true )
--				EnemyVehicleLifeLow("Tactical_Vehicle_WEST_009")
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy09", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy10", false )
				TppSupportHelicopterService.ChangeRoute("route02-3-1")
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_pole5',tag = 'SingleShot',playEvent = 'sfx_m_e20040_whoosh_s',}
				TppEnemyUtility.RequestToFireOnHelicopter( "EscoatEnemy17", "SupportHelicopter", "FriendMan", 270, 10 )
				TppSequence.ChangeSequence( "Seq_AAGun" )
			end
		end
	end,


	EnemyVehicleBroken = function()
		TppEnemyUtility.CallVoice( "FriendMan", "MIDDLE", "DD_Intelmen", "INTL0130", "INTELMEM" )
	end,

}
---------------------------------------------------------------------------------
--● Seq_AAGun
---------------------------------------------------------------------------------
this.Seq_AAGun = {
	Messages = {
		Character = {
			{ data = "HeliEnemy01", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher01" },
			{ data = "HeliEnemy02", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher01" },
			{ data = "HeliEnemy03", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher01" },
			{ data = "HeliEnemy04", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher01" },
			{ data = "EscoatEnemy07", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher01" },
			{ data = "SupportHelicopter", message = "MessageRoutePoint", localFunc = "HelicopterRouteMove" },
			{ data = "FriendMan",	message = "MessageRoutePoint",	localFunc = "FriendVehicleMovement" },
			{ data = "Tactical_Vehicle_WEST_001", message = "VehicleBroken", commonFunc = function() GkEventTimerManager.Start( "Timer_FriendlyVehicleBroken", 0.5 ) end },
			{ data = "FollowVehicleEnemy04", message = "MessageRoutePoint", localFunc = "EnemyVehicleRouteMove" },
			{ data = "FriendMan", message = "EnemySleep", commonFunc = function() this.FriendManSlept() end },
			{ data = "FriendMan", message = "EnemyThreat", commonFunc = function() this.FriendManThreatAlart() end },
			{ data = "EscoatEnemy07", message = "MessageRoutePoint", localFunc = "AAGunEventActivation" },
			{ data = "e20040CP", message ="EndGroupVehicleRouteMove", localFunc = "EndVehicleMove"},
		},
		Gimmick = {
			{ data = "gntn_area01_antiAirGun_002", message = "AntiAircraftGunBroken", commonFunc = function() this.AAGunDestroyed() end },
		},
		Timer = {
			{ data = "Timer_SnipeEnemyClear01",	message = "OnEnd",	commonFunc = function() TppSequence.ChangeSequence( "Seq_Snipe" ) end },
		},
	},

	OnEnter = function()
		Fox.Log("***************** ENTERED AAGUN SEQ*******************")
		TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy17", "EscoatRoute17-2", 0 )
		TppEnemyUtility.CallVoice( "FriendMan", "MIDDLE", "DD_Intelmen", "INTL0070", "INTELMEM" )
		TppMission.SetFlag( "isDebugBoss", false )
		VehicleLifeNormal()
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy04", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy05", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy06", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy08", false )
--		TppEnemyUtility.SetEnableCharacterId( "AAGunEnemy02", true )
--		TppEnemyUtility.SetEnableCharacterId( "AAGunEnemy03", true )
-- 		TppEnemyUtility.SetEnableCharacterId( "AAGunEnemy04", true )
		TppEnemyUtility.SetEnableCharacterId( "EscoatEnemy07", true )
		if( TppMission.GetFlag( "isAAGunDestroyed" ) == false ) then
			TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy07", "AAgunRoute", 0 )
		elseif( TppMission.GetFlag( "isAAGunDestroyed" ) == true ) then
			TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy07", "AAGunRoute_2", 0 )
		end
	end,

	AAGunEventActivation = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("AAgunRoute") ) then
			if (RoutePointNumber == 3) then
				Fox.Log("***************** ACTIVATES AAG *******************")
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("gntn_area01_antiAirGun_002")
				TppRadio.Play("Radio_AAGunFireIncoming", {onEnd = function() TppMusicManager.PostSceneSwitchEvent('Set_Switch_bgm_e20040_heli_04' )end}, nil, nil, "none" )
			end
		end
	end,


	HelicopterRouteMove = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("route02-3-1") ) then
			if (RoutePointNumber == 3) then
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy19", "EscoatRoute19-2", 0 )
			elseif (RoutePointNumber == 4) then
				TppEnemyUtility.SetEnableCharacterId( "HeliEnemy01", true )
				TppCharacterUtility.ChangeRouteCharacterId( "HeliEnemy01", "HeliEnemyRoute01", 0 )
				TppEnemyUtility.SetEnableCharacterId( "HeliEnemy03", true )
				TppCharacterUtility.ChangeRouteCharacterId( "HeliEnemy03", "HeliEnemyRoute03", 0 )
				TppEnemyUtility.SetEnableCharacterId( "HeliEnemy04", true )
				TppCharacterUtility.ChangeRouteCharacterId( "HeliEnemy04", "HeliEnemyRoute04", 0 )
				TppSupportHelicopterService.ChangeRoute("route02-3-2")
			end
		elseif( RouteName ==  GsRoute.GetRouteId("route02-3-2") ) then
			if (RoutePointNumber == 1) then
				TppSupportHelicopterService.ChangeRoute("route02-3-3")
			end
		elseif( RouteName ==  GsRoute.GetRouteId("route02-3-3") ) then
			if (RoutePointNumber == 1) then
				TppEnemyUtility.SetEnableCharacterId( "HeliEnemy02", true )
				TppCharacterUtility.ChangeRouteCharacterId( "HeliEnemy02", "HeliEnemyRoute02", 0 )
			elseif (RoutePointNumber == 2) then
				TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_15' )
			elseif (RoutePointNumber == 3) then
				TppCharacterUtility.ChangeRouteCharacterId( "EscoatEnemy07", "AAGunRoute_3", 0 )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy17", false )
			elseif (RoutePointNumber == 4) then
				TppRadio.Play("Radio_CoverTarget")
			elseif (RoutePointNumber == 5) then

				GZCommon.CallAlertSiren()
				TppSupportHelicopterService.StopSearchLightAutoAim()

				TppCharacterUtility.ChangeRouteCharacterId( "HeliEnemy01", "HeliEnemyRoute01_2", 0 )
				TppCharacterUtility.ChangeRouteCharacterId( "HeliEnemy03", "HeliEnemyRoute03_2", 0 )
				TppCharacterUtility.ChangeRouteCharacterId( "HeliEnemy04", "HeliEnemyRoute04_2", 0 )

				TppData.Disable( "Tactical_Vehicle_WEST_002" )
				TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_002" }

				TppData.Disable("Tactical_Vehicle_WEST_003")
				TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_003" }

				TppData.Disable("Truck_WEST01")
				TppMarkerSystem.DisableMarker{ markerId = "Truck_WEST01" }

				TppMarkerSystem.DisableMarker{ markerId = "Heliport" }
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy19", false )
			end
		end
	end,

	DeadWatcher01 = function()
		if( TppMission.GetFlag( "isDeadWatcher01END" ) == true ) then return end
		local count = 0
		Fox.Log("***************** DEAD WATCHER SNIPE_1 RUNS *******************")
		if IsDeadEnemy("HeliEnemy01") then count = count + 1 end
		if IsDeadEnemy("HeliEnemy02") then count = count + 1 end
		if IsDeadEnemy("HeliEnemy03") then count = count + 1 end
		if IsDeadEnemy("HeliEnemy04") then count = count + 1 end
		if IsDeadEnemy("EscoatEnemy07") then count = count + 1 end

		if count >= 2 then
			TppCharacterUtility.ChangeRouteCharacterId( "HeliEnemy02", "HeliEnemyRoute02_2", 0 )
		end

		if count == 5 then
			Fox.Log( "***************** Kill Count 4 : ROUTE CHANGE *****************" )
			TppMission.SetFlag( "isDeadWatcher01END", true )
			if( TppMission.GetFlag( "isFriendManFaint" ) == true ) then --監督が気絶済みなら、先に進行
				GkEventTimerManager.Start( "Timer_SnipeEnemyClear01", 1.5 )
			end
		end
	end,

--味方車輌 RouteMove
	FriendVehicleMovement = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("VehicleRoute02")	) then
			if(RoutePointNumber == 26 ) then
				TppEnemyUtility.SetEnableCharacterId( "VehicleBreaker", true )
				TppEnemyUtility.SetLifeFlagByCharacterId( "VehicleBreaker", "NoDamageLife" )
			elseif(RoutePointNumber == 27 ) then
				TppEnemyUtility.RequestToFireOnHelicopter( "VehicleBreaker", "SupportHelicopter", "FriendMan", 90, 7 )
				TppRadio.Play("Radio_FriendVehicleClash", {onEnd = function()TppMusicManager.PostSceneSwitchEvent('Set_Switch_bgm_e20040_heli_04' )end}, nil, nil, "none")
				--SOUND(SE)
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_carcrash',tag = 'SingleShot',playEvent = 'sfx_m_e20040_fixed_27',}
			elseif(RoutePointNumber == 28 ) then
				TppEnemyUtility.UnsetLifeFlagByCharacterId("VehicleBreaker","NoDamageLife" )--解除：ダメージ無効
				TppEnemyUtility.KillEnemy( "VehicleBreaker" )
--				TppEnemyUtility.ChangeStatus( "VehicleBreaker", "Faint" )

				TppEnemyUtility.UnsetLifeFlagByCharacterId("FriendMan", "NoDamageFaint" )--解除：気絶ダメージ無効
				TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoRecoverFaint" )--設定：気絶回復無効
				TppEnemyUtility.ChangeStatus( "FriendMan", "Faint" )--諜報員を気絶
				TppEnemyUtility.SetLifeFlagByCharacterId("FriendMan", "NoDamageFaint" )--設定：気絶ダメージ無効
				TppEnemyUtility:SetLifeByCharacterId( "FriendMan","Life", 8000 )
				TppMission.SetFlag( "isFriendManFaint", true )--監督兵気絶した判定ON
				--車輌を中破
				local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Tactical_Vehicle_WEST_001" )
				local vehicle = vehicleObject:GetCharacter()
				local plgLife = vehicle:FindPluginByName( "Life" )
				plgLife:RequestSetLife( "Life", 9999 )
				vehicle:SendMessage( ChDamageActionRequest() )

				if( TppMission.GetFlag( "isDeadWatcher01END" ) == true ) then--監督が気絶した段階で敵兵が全て排除されていたら進行
					GkEventTimerManager.Start( "Timer_SnipeEnemyClear01", 1.5 )
				end
			end
		end
	end,

--敵車輌 RouteMove（ドラム缶に突っ込んで爆破）
	EnemyVehicleRouteMove = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("FollowVehicleRoute04")) then
			if( RoutePointNumber == 0 ) then
				local vehicleObject = Ch.FindCharacterObjectByCharacterId("Tactical_Vehicle_WEST_009")
				local vehicle = vehicleObject:GetCharacter()
				local plgLife = vehicle:FindPluginByName( "Life" )
				plgLife:RequestSetMaxLife( "LeftWheelFrontLife", 50000 )
				plgLife:RequestSetMaxLife( "RightWheelFrontLife", 50000 )
				plgLife:RequestSetMaxLife( "LeftWheelSecondLife", 50000 )
				plgLife:RequestSetMaxLife( "RightWheelSecondLife", 50000 )
				plgLife:RequestSetMaxLife( "Life", 5000 )
				plgLife:RequestSetLifeMax( "LeftWheelFrontLife" )
				plgLife:RequestSetLifeMax( "RightWheelFrontLife" )
				plgLife:RequestSetLifeMax( "LeftWheelSecondLife" )
				plgLife:RequestSetLifeMax( "RightWheelSecondLife" )
				plgLife:RequestSetLifeMax( "Life" )
			elseif( RoutePointNumber == 2 ) then
				local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Tactical_Vehicle_WEST_009" )
				local vehicle = vehicleObject:GetCharacter()
				local plgLife = vehicle:FindPluginByName( "Life" )
				plgLife:RequestSetLife( "Life", 0 )
				vehicle:SendMessage( ChDamageActionRequest() )
			end
		end
	end,

}

---------------------------------------------------------------------------------
--● Seq_Snipe
---------------------------------------------------------------------------------

this.Seq_Snipe = {
	Messages = {
		Character = {
			{ data = "SupportHelicopter", message = "MessageRoutePoint", localFunc = "HelicopterRouteMove" },

			{ data = "SnipeEnemy02", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher02" },
			{ data = "SnipeEnemy03", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher02" },
			{ data = "SnipeEnemy04", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher02" },
			{ data = "SnipeEnemy05", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher02" },
			{ data = "SnipeEnemy06", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher02" },

			{ data = "SnipeEnemy01", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher03" },
			{ data = "SnipeEnemy07", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher03" },
			{ data = "SnipeEnemy08", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher03" },
			{ data = "SnipeEnemy09", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher03" },
			{ data = "SnipeEnemy10", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "DeadWatcher03" },

			{ data = "SnipeEnemy01",	message = "MessageRoutePoint",	localFunc = "RoketEnemyMove" },
			{ data = "SnipeEnemy05",	message = "MessageRoutePoint",	localFunc = "RocketManVanish" },
			{ data = "FriendMan",	message = "MessageRoutePoint",	localFunc = "FriendVehicleMovement" },
			{ data = "FriendMan", message = "EnemyThreat", commonFunc = function() this.FriendManThreatAlart() end },
			{ data = "e20040CP", message ="EndGroupVehicleRouteMove", localFunc = "EndVehicleMove"},
		},
		Timer = {
			{ data = "Timer_SnipeEnemyClear02",	message = "OnEnd",	localFunc = "SnipeEnemyClear02" },
			{ data = "Timer_SnipeEnemyClear03",	message = "OnEnd",	localFunc = "SnipeEnemyClear03" },
			{ data = "Timer_SnipeEnemyGen01",	message = "OnEnd",	localFunc = "SnipeEnemyGroupeGen01" },
			{ data = "Timer_SnipeEnemyGen02",	message = "OnEnd",	localFunc = "SnipeEnemyGroupeGen02" },
			{ data = "Timer_SnipeEnemyGen03",	message = "OnEnd",	localFunc = "SnipeEnemyGroupeGen03" },
		},
	},

	OnEnter = function()
		TppMissionManager.SaveGame(0003)
		TppRadio.DelayPlay( "Radio_DominateLZ", "mid", "none" )
--		TppRadio.Play ("Radio_DominateLZ", nil, nil, nil, "none" )
		TppSupportHelicopterService.ChangeRoute("route02-4")
		TppSupportHelicopterService.ChangeAngleRateXZ(0.5)
		TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_16' )
		TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "FriendMan", true )
		GkEventTimerManager.Start( "Timer_SnipeEnemyGen01", 7 ) --Timer：カウント終了で次の敵兵投入
		--次の敵勢力準備
		TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy02", true )
		TppCharacterUtility.ChangeRouteCharacterId( "SnipeEnemy02", "SnipeRoute02", 0 )
		TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy03", true )
		TppCharacterUtility.ChangeRouteCharacterId( "SnipeEnemy03", "SnipeRoute03", 0 )
		--消す
		TppData.Disable("Tactical_Vehicle_WEST_009")
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_009" }

		TppMission.SetFlag( "isDeadWatcher01END", true )
	end,

	DeadWatcher02 = function()
		if( TppMission.GetFlag( "isDeadWatcher02END" ) == true ) then return end
		Fox.Log("***************** DEAD WATCHER SNIPE_2 RUNS *******************")
		local count = 0
		if IsDeadEnemy("SnipeEnemy02") then count = count + 1 end
		if IsDeadEnemy("SnipeEnemy03") then count = count + 1 end
		if IsDeadEnemy("SnipeEnemy04") then count = count + 1 end
		if IsDeadEnemy("SnipeEnemy05") then count = count + 1 end
		if IsDeadEnemy("SnipeEnemy06") then count = count + 1 end

		if count >= 2 then
			Fox.Log("***************** Kill count 2 *******************")
			TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy04", true )
			TppCharacterUtility.ChangeRouteCharacterId( "SnipeEnemy04", "SnipeRoute04", 0 )
			TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy05", true )
			TppCharacterUtility.ChangeRouteCharacterId( "SnipeEnemy05", "SnipeRoute05", 0 )
		end

		if count >= 5 then
			Fox.Log("***************** Kill count == 5 : ROUTE CHANGE *******************")
			GkEventTimerManager.Start( "Timer_SnipeEnemyClear02", 1.5 )
			TppMission.SetFlag( "isDeadWatcher02END", true )
		end
	end,

	SnipeEnemyClear02 = function()
		TppSupportHelicopterService.ChangeRoute("route02-5")
		TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_17' )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "HeliEnemy01", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "HeliEnemy02", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "HeliEnemy03", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "HeliEnemy04", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "EscoatEnemy07", false )
		TppRadio.Play("Radio_DominateLZ2", nil, nil, nil, "none" )
		TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy07", true )
		TppCharacterUtility.ChangeRouteCharacterId( "SnipeEnemy07", "SnipeRoute07", 0 )
		TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy09", true )
		TppCharacterUtility.ChangeRouteCharacterId( "SnipeEnemy09", "SnipeRoute09", 0 )
		GkEventTimerManager.Start( "Timer_SnipeEnemyGen02", 4 )
		TppSupportHelicopterService.SetSearchLightAngle(55.0,13.0)
	end,

	DeadWatcher03 = function()
		if( TppMission.GetFlag( "isDeadWatcher03END" ) == true ) then return end
		Fox.Log("***************** DEAD WATCHER SNIPE_3 RUNS *******************")
		local count = 0
		if IsDeadEnemy("SnipeEnemy01") then count = count + 1 end
		if IsDeadEnemy("SnipeEnemy07") then count = count + 1 end
		if IsDeadEnemy("SnipeEnemy08") then count = count + 1 end
		if IsDeadEnemy("SnipeEnemy09") then count = count + 1 end
		if IsDeadEnemy("SnipeEnemy10") then count = count + 1 end

		if count >= 2 then
			Fox.Log("***************** Kill count >= 2 *******************")
			GkEventTimerManager.Start( "Timer_SnipeEnemyGen03", 2 )
		end

		if count >= 5 then
			GkEventTimerManager.Start( "Timer_SnipeEnemyClear03", 0.5 )
			TppMission.SetFlag( "isDeadWatcher03END", true )
		end
	end,

	SnipeEnemyClear03 = function()
		Fox.Log("***************** Kill count == 5 : ROUTE CHANGE *******************")
		TppRadio.Play("Radio_LZCleared",{onEnd = function() TppSequence.ChangeSequence( "Seq_Boss" )end}, nil, nil, "none" )
	end,

--敵戦力投入１
	SnipeEnemyGroupeGen01 = function()
		TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy06", true )
		TppCharacterUtility.ChangeRouteCharacterId( "SnipeEnemy06", "SnipeRoute06", 0 )
		commonUiMissionSubGoalNo(3)
		TppSupportHelicopterService.SetSearchLightAngle(90.0,15.0)
		TppData.Disable("Tactical_Vehicle_WEST_009") --見えなくなった敵/車輌を削除
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_009" }
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "VehicleBreaker", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "FollowVehicleEnemy04", false ) --見えなくなった敵/車輌を削除
	end,

--敵戦力投入２
	SnipeEnemyGroupeGen02 = function()
		TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy08", true )
		TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy10", true )
		TppData.Enable( "Tactical_Vehicle_WEST_005" )

		TppRadio.Play("Radio_UseScope", nil, nil, nil, "none" )

		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy04", false ) --見えなくなった敵/車輌を削除
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy05", false ) --見えなくなった敵/車輌を削除
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy06", false ) --見えなくなった敵/車輌を削除
	end,

--敵戦力投入３
	SnipeEnemyGroupeGen03 = function()
		TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy01", true )
		TppCharacterUtility.ChangeRouteCharacterId( "SnipeEnemy01", "SnipeRoute01", 0 )
	end,

	RoketEnemyMove = function() --管制塔ロケット兵が接近したら無線
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("SnipeRoute01") ) then
			if (RoutePointNumber == 1) then
				TppRadio.Play("Radio_RPGonTower", nil, nil, nil, "none" )
				TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("SnipeEnemy01")
			end
		end
	end,


	RocketManVanish = function()
		local RouteName	= TppData.GetArgument(3)
		local RoutePointNumber = TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("SnipeRoute05") ) then
			if (RoutePointNumber == 6) then
				Fox.Log("***************** ROCKET MAN Vanished *******************")
				TppEnemyUtility.ChangeStatus( "SnipeEnemy05" , "Faint" ) --USE EVER FAINT
				TppEnemyUtility.SetLifeFlagByCharacterId( "SnipeEnemy05", "NoRecoverFaint" )
			else
				Fox.Log("***************** ROKET MAN 移動中 *******************")
			end
		end
	end,

--味方車輌 RouteMove
	FriendVehicleMovement = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("VehicleRoute02")	) then
			if(RoutePointNumber == 26 ) then
				TppEnemyUtility.SetEnableCharacterId( "VehicleBreaker", true )
				TppEnemyUtility.SetLifeFlagByCharacterId( "VehicleBreaker", "NoDamageLife" )
			elseif(RoutePointNumber == 27 ) then
				TppEnemyUtility.RequestToFireOnHelicopter( "VehicleBreaker", "SupportHelicopter", "FriendMan", 90, 8 )
				GkEventTimerManager.Start( "Timer_VehicleCrash", 0.3 )
				--SOUND(SE)
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_carcrash',tag = 'SingleShot',playEvent = 'sfx_m_e20040_fixed_27',}
				--車輌を中破
				local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Tactical_Vehicle_WEST_001" )
				local vehicle = vehicleObject:GetCharacter()
				local plgLife = vehicle:FindPluginByName( "Life" )
				plgLife:RequestSetLife( "Life", 9999 )
				vehicle:SendMessage( ChDamageActionRequest() )
			elseif(RoutePointNumber == 28 ) then
				TppEnemyUtility.UnsetLifeFlagByCharacterId("VehicleBreaker", "NoDamageLife" )
				TppEnemyUtility.ChangeStatus( "VehicleBreaker", "Faint" )
				TppEnemyUtility.ChangeStatus( "FriendMan", "Faint" )
				TppEnemyUtility.SetLifeFlagByCharacterId( "FriendMan", "NoRecoverFaint" )
				TppEnemyUtility:SetLifeByCharacterId( "FriendMan","Life", 8000 )
				TppRadio.Play("Radio_FriendVehicleClash", nil, nil, nil, "none" )
			end
		end
	end,

	EndVehicleMove = function()
		local arg2 = TppData.GetArgument(2)
		if arg2.vehicleCharacterId == "Tactical_Vehicle_WEST_005" then
			Fox.Log("***************** END VEHICLE ONE *******************")
			TppCharacterUtility.ChangeRouteCharacterId( "SnipeEnemy08", "SnipeRoute08", 0 )
			TppCharacterUtility.ChangeRouteCharacterId( "SnipeEnemy10", "SnipeRoute10", 0 )
		end
	end,
}
---------------------------------------------------------------------------------
--● Seq_Boss
---------------------------------------------------------------------------------

this.Seq_Boss = {
	Messages = {
		RadioCondition = {
			{ message = "PlayerLifeLessThanHalf", commonFunc = function() TppRadio.Play( "Miller_SpRecoveryLifeAdvice" ) end },
			{ message = "PlayerHurt", commonFunc = function() TppRadio.Play( "Miller_CuarAdvice" ) end },
			{ message = "PlayerCureComplete", commonFunc = function() TppRadio.Play( "Miller_SpRecoveryLifeAdvice" ) end },
		},
		Character = {
			{ data = "SupportHelicopter", message = "MessageRoutePoint", localFunc = "HelicopterRouteMove" },
			{ data = "Player", message = "RideHelicopter", localFunc ="Escape" },
			{ data = "Player", message = "OnVehicleGetOff_End", localFunc ="RideOffHeli" },
			{ data = "BossRider01", message = "MessageRoutePoint", localFunc = "BossVehicleMovement"},
			{ data = "FriendMan", message = "HostageLaidOnVehicle", localFunc = "Capture"},
			{ data = "FriendMan", message = "EnemyThreat", commonFunc = function() this.FriendManThreatAlart() end },
			{ data = "Armored_Vehicle_WEST_001", message = "StrykerDestroyed", commonFunc = function() GkEventTimerManager.Start( "Timer_KillBoss", 3 )end },
			{ data = this.cpID, message = "VehicleMessageRoutePoint", commonFunc = function() GZCommon.Common_CenterBigGateVehicle( ) end  },
			{ data = this.cpID, message = "EndRadio", commonFunc = function() GZCommon.Common_CenterBigGateVehicleEndCPRadio( ) end  },
		},
		Trap = {
			{ data = "TrapCautionRange", message = "Exit", localFunc = "Warning"},
			{ data = "TrapCautionRange", message = "Enter", localFunc = "WarningOff"},
			{ data = "TrapCautionRangeOut", message = "Exit", localFunc = "GameOver"},
			{ data = "TrapBossEneGen" , message = "Enter", localFunc = "BossEnemiesGen"},
			{ data = "TrapBossGenerate", message = "Enter", localFunc = "BossGenerate"},
			{ data = "TrapBossCamera", message = "Enter", localFunc = "BossCameraIn"},
			{ data = "TrapBossCamera", message = "Exit", localFunc = "BossCameraOut"},
			{ data = "TrapHeliDrop", message = "Enter", localFunc = "HeliDrop"},
			{ data = "TrapHeliDrop", message = "Exit", localFunc = "HeliHober"},
			{ data = "TrapAdditionalEnemies", message = "Enter", commonFunc = function() TppMission.SetFlag( "isInsideAddTrap", true)end },
			{ data = "TrapAdditionalEnemies", message = "Exit", commonFunc = function() TppMission.SetFlag( "isInsideAddTrap", false)end },
		},
		Timer = {
			{ data = "Timer_BossGen", message = "OnEnd", localFunc = "BossGen" },
			{ data = "Timer_HighSpeedSound", message = "OnEnd", localFunc = "HighSpeedSound" },
			{ data = "Timer_KillBoss", message = "OnEnd", localFunc = "KILLBOSS" },
			{ data = "Timer_HeliRadio", message = "OnEnd", localFunc = "HeliRadio" },
			{ data = "Timer_HeliKiller", message = "OnEnd", commonFunc = function()TppSupportHelicopterService.Break("SupportHelicopter") end },
		},
	},

	OnEnter = function()
		Fox.Log("***************** BOSS SEQUENCE ENTERED *******************")
		TppMissionManager.SaveGame(0004)
		TppSupportHelicopterService.ChangeRoute("route03")
		TppVehicleUtility.SetCannotRide("Tactical_Vehicle_WEST_001")--車輌に乗れなくしておく
		TppVehicleUtility.SetCannotRide("Tactical_Vehicle_WEST_005")--車輌に乗れなくしておく
		TppVehicleUtility.SetCannotRide("Truck_WEST03")--車輌に乗れなくしておく
		TppDataUtility.SetEnableDataFromIdentifier( "id_GeoPath", "pathWall_0001", false, false )
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_05' )
		TppSupportHelicopterService.ChangeRoute("route03")
		TppSupportHelicopterService.ChangeAngleRateXZ(1)
		TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_18' )
		local daemon = TppSoundDaemon.GetInstance()
		daemon:RegisterSourceEvent{sourceName = 'Source_fixed_tower4',tag = 'SingleShot',playEvent = 'sfx_m_e20040_whoosh_l',}
		TppEnemyUtility.SetEnableCharacterId( "BossEnemy01", true )
--		TppEnemyUtility.SetEnableCharacterId( "BossEnemy02", true )
		TppEnemyUtility.SetEnableCharacterId( "BossEnemy03", true )
		TppEnemyUtility.SetEnableCharacterId( "BossEnemy04", true )
		TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "FriendMan", true )

		commonUiMissionSubGoalNo(4)
--		TppGadgetUtility.AttachGadgetToChara("Moai05","SupportHelicopter","CNP_ppos_c",Vector3(0,270,0))
	end,

--BossEne生成
	BossEnemiesGen = function()
		Fox.Log("***************** BOSS ENE GEN *******************")
		TppCommandPostObject.GsSetForceRouteMode( this.cpID, false )
		TppSupportHelicopterService.SearchLightOff()
		TppRadio.Play("Radio_GetOffHeli", nil, nil, nil, "none" )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy01", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy07", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy08", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy09", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy10", false )

		--車輌の中破コマンドもう一度（保険処理）
		local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Tactical_Vehicle_WEST_001" )
		local vehicle = vehicleObject:GetCharacter()
		local plgLife = vehicle:FindPluginByName( "Life" )
		if plgLife:GetValue("Life"):Get() > 0 then
		  plgLife:RequestSetLife( "Life", 14000 )
		  vehicle:SendMessage( ChDamageActionRequest() )
		end

		local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Tactical_Vehicle_WEST_005" )
		local vehicle = vehicleObject:GetCharacter()
		local plgLife = vehicle:FindPluginByName( "Life" )
		if plgLife:GetValue("Life"):Get() > 0 then
		  plgLife:RequestSetLife( "Life", 14000 )
		  vehicle:SendMessage( ChDamageActionRequest() )
		end

		local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Truck_WEST03" )
		local vehicle = vehicleObject:GetCharacter()
		local plgLife = vehicle:FindPluginByName( "Life" )
		if plgLife:GetValue("Life"):Get() > 0 then
		  plgLife:RequestSetLife( "Life", 14000 )
		  vehicle:SendMessage( ChDamageActionRequest() )
		end

	end,

--ヘリ降機判定
	RideOffHeli = function()
		TppEnemyUtility.SetEnableCharacterId( "SnipeEnemy01", false )
		local LaidOnVehicleId = TppData.GetArgument(2)
		Fox.Log ("************************"..tostring(LaidOnVehicleId).."**************************")
		if LaidOnVehicleId == ("SupportHelicopter") then
			if( TppMission.GetFlag( "isHeliComeDown" ) == false ) then
				TppSupportHelicopterService.ChangeRoute("HeliHober")
				TppMission.SetFlag("isRideHeli",false)
				TppSupportHelicopterService.SetPossibleGettingOn("SupportHelicopter", false)
			end
		end
	end,

--機銃装甲車登場セットアップ
	BossGenerate = function()
		GkEventTimerManager.Start( "Timer_BossGen", 1 )
		TppRadio.Play("Radio_CheackTargetStatus")
	end,

--機銃装甲車登場
	BossGen = function()
		if( TppMission.GetFlag( "isBossGenerated" ) == false ) then
			Fox.Log("***************** BOSS GENERATED *******************")
			TppEnemyUtility.SetEnableCharacterId( "BossRider01", true )
			TppData.Enable( "Armored_Vehicle_WEST_001" )
			TppEnemyUtility.SetForceRouteMode( "BossRider01", true )
			TppMission.SetFlag( "isBossGenerated", true )
		end
	end,

	BossCameraIn = function()
		Fox.Log("***************** CAMERA IN *******************")
		TppMission.SetFlag( "isInBossGenerateArea", true )
	end,

	BossCameraOut = function()
		Fox.Log("***************** CAMERA OUT *******************")
		TppMission.SetFlag( "isInBossGenerateArea", false )
	end,

--■BossVehicleMovement
	BossVehicleMovement = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		Fox.Log("RouteName"..RouteName)
			if( RouteName ==  GsRoute.GetRouteId("BossRoute02")  ) then
				if( RoutePointNumber == 0 ) then
					local vehicleObjectAPC = Ch.FindCharacterObjectByCharacterId( "Armored_Vehicle_WEST_001" )
					local vehicleAPC = vehicleObjectAPC:GetCharacter()
					local plgLifeTruck = vehicleAPC:FindPluginByName( "Life" )
					plgLifeTruck:RequestSetMaxLife( "Life", 999999 )
					plgLifeTruck:RequestSetMaxLife( "LeftWheelFrontLife", 999999 )
					plgLifeTruck:RequestSetMaxLife( "RightWheelFrontLife", 999999 )
					plgLifeTruck:RequestSetMaxLife( "LeftWheelSecondLife", 999999 )
					plgLifeTruck:RequestSetMaxLife( "RightWheelSecondLife", 999999 )
					plgLifeTruck:RequestSetMaxLife( "LeftWheelThirdLife", 999999 )
					plgLifeTruck:RequestSetMaxLife( "RightWheelThirdLife", 999999 )
					plgLifeTruck:RequestSetMaxLife( "LeftWheelFourthLife", 999999 )
					plgLifeTruck:RequestSetMaxLife( "RightWheelFourthLife", 999999 )
					plgLifeTruck:RequestSetLifeMax( "Life" )
					plgLifeTruck:RequestSetLifeMax( "LeftWheelFrontLife" ) --FRONT
					plgLifeTruck:RequestSetLifeMax( "RightWheelFrontLife" ) --FRONT
					plgLifeTruck:RequestSetLifeMax( "LeftWheelSecondLife" ) --SECOND
					plgLifeTruck:RequestSetLifeMax( "RightWheelSecondLife" ) --SECOND
					plgLifeTruck:RequestSetLifeMax( "LeftWheelThirdLife" ) --THIRD
					plgLifeTruck:RequestSetLifeMax( "RightWheelThirdLife" ) --THIRD
					plgLifeTruck:RequestSetLifeMax( "LeftWheelFourthLife" ) --FORTH
					plgLifeTruck:RequestSetLifeMax( "RightWheelFourthLife" ) --FORTH
				elseif( RoutePointNumber == 1 ) then
					GZCommon.Common_CenterBigGate_Close()
					GkEventTimerManager.Start( "Timer_HeliRadio", 1.0 )
					local vehicleObjectAPC = Ch.FindCharacterObjectByCharacterId( "Armored_Vehicle_WEST_001" )
					local vehicleAPC = vehicleObjectAPC:GetCharacter()
					local plgLifeTruck = vehicleAPC:FindPluginByName( "Life" )
					plgLifeTruck:RequestSetMaxLife( "Life", 30000 )
					plgLifeTruck:RequestSetMaxLife( "LeftWheelFrontLife", 2400 )
					plgLifeTruck:RequestSetMaxLife( "RightWheelFrontLife", 2400 )
					plgLifeTruck:RequestSetMaxLife( "LeftWheelSecondLife", 2400 )
					plgLifeTruck:RequestSetMaxLife( "RightWheelSecondLife", 2400 )
					plgLifeTruck:RequestSetMaxLife( "LeftWheelThirdLife", 2400 )
					plgLifeTruck:RequestSetMaxLife( "RightWheelThirdLife", 2400 )
					plgLifeTruck:RequestSetMaxLife( "LeftWheelFourthLife", 2400 )
					plgLifeTruck:RequestSetMaxLife( "RightWheelFourthLife", 2400 )
					plgLifeTruck:RequestSetLifeMax( "Life" )
					plgLifeTruck:RequestSetLifeMax( "LeftWheelFrontLife" ) --FRONT
					plgLifeTruck:RequestSetLifeMax( "RightWheelFrontLife" ) --FRONT
					plgLifeTruck:RequestSetLifeMax( "LeftWheelSecondLife" ) --SECOND
					plgLifeTruck:RequestSetLifeMax( "RightWheelSecondLife" ) --SECOND
					plgLifeTruck:RequestSetLifeMax( "LeftWheelThirdLife" ) --THIRD
					plgLifeTruck:RequestSetLifeMax( "RightWheelThirdLife" ) --THIRD
					plgLifeTruck:RequestSetLifeMax( "LeftWheelFourthLife" ) --FORTH
					plgLifeTruck:RequestSetLifeMax( "RightWheelFourthLife" ) --FORTH
				elseif( RoutePointNumber == 2 ) then
					TppSupportHelicopterService.SetInvincibleMode(true)
					TppSupportHelicopterService.SetDamageModeManually("SupportHelicopter", true)
					TppSupportHelicopterService.ChangeRoute("HeliDodge")
				elseif( RoutePointNumber == 3 ) then
					TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_07' )
					TppSupportHelicopterService.StartSearchLightAutoAimToCharacter("BossRider01")
				elseif( RoutePointNumber == 5 ) then
					TppSupportHelicopterService.SearchLightOn()
					TppEnemyUtility.SetForceRouteMode( "BossRider01", false )
				end
			end
	end,

	HeliRadio = function()
		TppRadio.Play("Radio_BossIncoming",{onEnd = function() commonUiMissionSubGoalNo(5) end,})
		TppMarkerSystem.DisableMarker{ markerId = "FriendMan" }
		TppMarker.Enable( "Armored_Vehicle_WEST_001", 0, "attack", "map_and_world_only_icon" )
		TppMarkerSystem.SetMarkerNew{ markerId = "Armored_Vehicle_WEST_001", isNew = true }
		if( TppMission.GetFlag( "isInBossGenerateArea" ) == true ) then
			MissionManager.RegisterNotInGameRealizeCharacter( "BossRider01" )
			MissionManager.RegisterNotInGameRealizeCharacter( "Armored_Vehicle_WEST_001" )
			MissionManager.RegisterNotInGameRealizeCharacter( "FriendMan" )
			TppDemo.Play( "Demo_Boss" )
			GkEventTimerManager.Start( "Timer_HighSpeedSound", 1.0 )
		end
	end,

	HighSpeedSound = function()
		TppSoundDaemon.PostEvent( 'Play_Test_s_highspeed_end' )
	end,

	HelicopterRouteMove = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("route03") ) then
			if (RoutePointNumber == 3) then
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy02", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy03", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy04", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy05", false )
				TppCommandPostObject.GsSetRealizeEnable( this.cpID, "SnipeEnemy06", false )
				TppEnemyUtility.SetEnableCharacterId( "BossEnemy05", true )
				TppCommandPostObject.GsSetKeepPhaseName( this.cpID, "Alert")
			end
		elseif( RouteName ==  GsRoute.GetRouteId("HeliDodge") ) then
			if (RoutePointNumber == 3) then
				TppSupportHelicopterService.ChangeRoute("HeliWaiting")
					TppSupportHelicopterService.SetInvincibleMode(false)
					TppSupportHelicopterService.SetDamageModeManually("SupportHelicopter", false)
			end
		elseif( RouteName ==  GsRoute.GetRouteId("HeliBoarding") ) then
			if (RoutePointNumber == 3) then
				TppMission.SetFlag("isHeliComeDown", true)
			end
		elseif( RouteName ==  GsRoute.GetRouteId("HeliBoarding_2") ) then
			if (RoutePointNumber == 4) then
				TppMission.SetFlag("isHeliComeDown", true)
			end
		end
	end,

--　ボス破壊（増援判定）
	KILLBOSS = function()
		Fox.Log("***************** BOSS KILLED *******************")
			TppSupportHelicopterService.StopSearchLightAutoAim()
			local hudCommonData = HudCommonDataManager.GetInstance()
			hudCommonData:AnnounceLogViewLangId( "announce_destroy_APC" )
			TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_08' )
--　増援フラグ有　⇒　増援シーケンスへ
			if( TppMission.GetFlag( "isAdditionalEnemyForceDeactive" ) == false ) then
				TppSequence.ChangeSequence( "Seq_AdditionalEnemyForce" )

--　増援フラグ無　⇒　ヘリが回収に降下
			else
		Fox.Log("***************** HELI DOWN *******************")
				TppVehicleUtility.Extinguish( "Armored_Vehicle_WEST_001" )
				TppMarkerSystem.DisableMarker{ markerId = "Armored_Vehicle_WEST_001"}
				TppSupportHelicopterService.SetPossibleGettingOn("SupportHelicopter", true)
				TppRadio.Play ("Radio_RequestingTargetCargo",{onEnd = function() commonUiMissionSubGoalNo(7) end,})
				TppMarker.Enable( "FriendMan", 0, "defend", "map_and_world_only_icon")
				TppMarkerSystem.SetMarkerImportant{ markerId="FriendMan", isImportant=true }
				TppMarkerSystem.SetMarkerNew{ markerId = "FriendMan", isNew = true }
				TppMission.SetFlag( "isHeliReLandingOK", true )
				if ( TppMission.GetFlag( "isInsideHeliDropArea" ) == false) then--ドロップ範囲に居ない場合
					TppSupportHelicopterService.ChangeRoute("HeliBoarding_2")--★調整
				elseif ( TppMission.GetFlag( "isInsideHeliDropArea" ) == true) then--既にドロップ範囲に居た場合
					TppSupportHelicopterService.ChangeRoute("HeliBoarding_2")
				end
			end
	end,


	HeliDrop = function()
		TppMission.SetFlag( "isInsideHeliDropArea", true )
		if( TppMission.GetFlag( "isHeliComeDown" ) == true ) then
			TppSupportHelicopterService.ChangeRoute("HeliDrop")
		end
	end,

	HeliHober = function()
		TppMission.SetFlag( "isInsideHeliDropArea", false )
		if( TppMission.GetFlag( "isHeliComeDown" ) == true ) then
			TppSupportHelicopterService.ChangeRoute("HeliHober")
		end
	end,

--　圏外処理
	Warning = function()
		TppCommandPostObject.GsSetAntiAircraftMode( "e20040CP", true )
		GkEventTimerManager.Start( "Timer_BossGen", 1 )
		if( TppMission.GetFlag( "isBossGenerated" ) == true ) then
			local enemyNum = TppEnemyUtility.GetNumberOfActiveSoldier( Vector3(-106,31,54), 60 )
			if( enemyNum <= 2 ) then
				TppRadio.Play("Radio_WarningWithoutEnemy")
			else
				TppRadio.Play("Radio_HeliHP10")
			end
		end
	end,

	WarningOff = function()
		TppCommandPostObject.GsSetAntiAircraftMode( "e20040CP", false )
--		GZCommon.OutsideAreaEffectDisable()
	end,

	GameOver = function()
		local enemyNum = TppEnemyUtility.GetNumberOfActiveSoldier( Vector3(-106,31,54), 60 )
		if( enemyNum <= 3 ) then
			TppRadio.Play("Radio_OutOfRangeWithoutEnemy")
		else
			TppRadio.Play("Radio_OutOfRange")
		end
		TppSupportHelicopterService.SetLife("SupportHelicopter", 10000)
		TppEnemyUtility.SetEnableCharacterId( "Killer01", true )
		TppEnemyUtility.SetEnableCharacterId( "Killer02", true )
		TppEnemyUtility.SetEnableCharacterId( "Killer03", true )
		TppEnemyUtility.SetEnableCharacterId( "Killer04", true )
		GkEventTimerManager.Start( "Timer_HeliKiller", 8 )
		TppSupportHelicopterService.ChangeRoute("HeliWaiting")
--		TppEnemyUtility.SetForceRouteMode( "Killer01", true )
--		TppEnemyUtility.SetForceRouteMode( "Killer02", true )
	end,

--ターゲット回収判定
	Capture = function()
		local LaidOnVehicleId = TppData.GetArgument(3)
		Fox.Log ("************************"..tostring(LaidOnVehicleId).."**************************")
		if LaidOnVehicleId == ("SupportHelicopter") then
			if( TppMission.GetFlag( "isHostageCapture" ) == false ) then
				TppMission.SetFlag( "isHostageCapture", true )
			--	TppRadio.Play ( "Radio_TargetCaptured" )
				PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE", "FriendMan" )
				Fox.Log("***************** FRIEND MAN CAPTURED *******************")
				TppSupportHelicopterService.SetPossibleGettingOff("SupportHelicopter", false)
				local hudCommonData = HudCommonDataManager.GetInstance()
				hudCommonData:AnnounceLogViewLangId( "announce_mission_40_20040_000_from_0_prio_0" )
				hudCommonData:AnnounceLogViewLangId( "announce_mission_goal" )
				commonUiMissionSubGoalNo(8)
			end
		end
	end,

--脱出可能判定
	Escape= function()
		if( TppMission.GetFlag( "isHostageCapture" ) == true ) then
			TppSequence.ChangeSequence( "Seq_Escape" )
		else
			TppRadio.Play ("Radio_RequestingTargetCargoFirst")
		end
	end,
}
---------------------------------------------------------------------------------
--● Seq_AdditionalEnemyForce
---------------------------------------------------------------------------------

this.Seq_AdditionalEnemyForce = {
	Messages = {
		RadioCondition = {
			{ message = "PlayerLifeLessThanHalf", commonFunc = function() TppRadio.Play( "Miller_SpRecoveryLifeAdvice" ) end },
			{ message = "PlayerHurt", commonFunc = function() TppRadio.Play( "Miller_CuarAdvice" ) end },
			{ message = "PlayerCureComplete", commonFunc = function() TppRadio.Play( "Miller_SpRecoveryLifeAdvice" ) end },
		},

		Character = {
			{ data = "SupportHelicopter", message = "MessageRoutePoint", localFunc = "HelicopterRouteMove" },
			{ data = "Player", message = "RideHelicopter", localFunc ="Escape" },
			{ data = "FriendMan", message = "HostageLaidOnVehicle", localFunc = "Capture"},
			{ data = "FriendMan", message = "EnemyThreat", commonFunc = function() this.FriendManThreatAlart() end },
			{ data = "BossEnemy01", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "AdditioalDeadWatcher" },
--			{ data = "BossEnemy02", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "AdditioalDeadWatcher" },
			{ data = "BossEnemy03", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "AdditioalDeadWatcher" },
			{ data = "BossEnemy04", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "AdditioalDeadWatcher" },
			{ data = "BossEnemy05", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "AdditioalDeadWatcher" },
			{ data = "AddEnemy01", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "AdditioalDeadWatcher" },
			{ data = "AddEnemy02", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "AdditioalDeadWatcher" },
			{ data = "AddEnemy03", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "AdditioalDeadWatcher" },
			{ data = "AddEnemy04", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "AdditioalDeadWatcher" },
			{ data = "AddEnemy05", message = { "EnemyDead", "EnemySleep", "EnemyDying","EnemyFaint"}, localFunc = "AdditioalDeadWatcher" },
			{ data = "AddEnemy01", message = "MessageRoutePoint", localFunc = "EnemyRouteMove" },
			{ data = "AddEnemy02", message = "MessageRoutePoint", localFunc = "EnemyRouteMove" },
			{ data = "AddEnemy03", message = "MessageRoutePoint", localFunc = "EnemyRouteMove" },
			{ data = "AddEnemy04", message = "MessageRoutePoint", localFunc = "EnemyRouteMove" },
			{ data = "AddEnemy05", message = "MessageRoutePoint", localFunc = "EnemyRouteMove" },
			{ data = "AddEnemy01", message = "EnemyDamage", commonFunc = function() TppEnemyUtility.SetForceRouteMode( "AddEnemy01", false ) end },
			{ data = "AddEnemy02", message = "EnemyDamage", commonFunc = function() TppEnemyUtility.SetForceRouteMode( "AddEnemy02", false ) end },
			{ data = "AddEnemy03", message = "EnemyDamage", commonFunc = function() TppEnemyUtility.SetForceRouteMode( "AddEnemy03", false ) end },
			{ data = "AddEnemy04", message = "EnemyDamage", commonFunc = function() TppEnemyUtility.SetForceRouteMode( "AddEnemy04", false ) end },
			{ data = "AddEnemy05", message = "EnemyDamage", commonFunc = function() TppEnemyUtility.SetForceRouteMode( "AddEnemy05", false ) end },
		},

		Trap = {
			{ data = "TrapCautionRange", message = "Exit", localFunc = "Warning"},
			{ data = "TrapCautionRange", message = "Enter", localFunc = "WarningOff"},
			{ data = "TrapCautionRangeOut", message = "Exit", localFunc = "GameOver"},
			{ data = "TrapHeliDrop", message = "Enter", localFunc = "HeliDrop"},
			{ data = "TrapHeliDrop", message = "Exit", localFunc = "HeliHober"},
			{ data = "TrapAdditionalEnemies", message = "Enter", localFunc = "AdditionalEnemiesGen"},
			{ data = "TrapAdditionalEnemies", message = "Enter", commonFunc = function() TppMission.SetFlag( "isInsideAddTrap", true)end },
			{ data = "TrapAdditionalEnemies", message = "Exit", commonFunc = function() TppMission.SetFlag( "isInsideAddTrap", false)end },
		},

		Timer = {
			{ data = "Timer_HeliKiller", message = "OnEnd", commonFunc = function()TppSupportHelicopterService.Break("SupportHelicopter") end },
		},
	},

	OnEnter = function()
--プレイヤーが増援出現トラップの中にいる場合は即時増援出現
		if( TppMission.GetFlag( "isInsideAddTrap" ) == true ) then
			Fox.Log("***************** ADDITIONAL ENEMY GEN ON ENTER*******************")
			local hudCommonData = HudCommonDataManager.GetInstance()
			hudCommonData:AnnounceLogViewLangId( "announce_enemyIncrease" )
			TppRadio.Play("Radio_AdditionalEnemyForce",{onEnd = function() commonUiMissionSubGoalNo(6) end,})
--			TppRadio.Play("Radio_AdditionalEnemyForce")
			TppEnemyUtility.SetEnableCharacterId( "AddEnemy01", true )
			TppCharacterUtility.ChangeRouteCharacterId( "AddEnemy01", "AddEneRoute01", 0 )
			TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "AddEnemy01", true )

--			TppEnemyUtility.SetEnableCharacterId( "AddEnemy02", true )
--			TppCharacterUtility.ChangeRouteCharacterId( "AddEnemy02", "AddEneRoute02", 0 )

			TppEnemyUtility.SetEnableCharacterId( "AddEnemy03", true )
			TppCharacterUtility.ChangeRouteCharacterId( "AddEnemy03", "AddEneRoute03", 0 )
			TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "AddEnemy03", true )

			TppEnemyUtility.SetEnableCharacterId( "AddEnemy04", true )
			TppCharacterUtility.ChangeRouteCharacterId( "AddEnemy04", "AddEneRoute04", 0 )
			TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "AddEnemy04", true )

			TppEnemyUtility.SetEnableCharacterId( "AddEnemy05", true )
			TppCharacterUtility.ChangeRouteCharacterId( "AddEnemy05", "AddEneRoute05", 0 )
			TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( "AddEnemy05", true )

			TppEnemyUtility.SetForceRouteMode( "AddEnemy01", true )
			TppEnemyUtility.SetForceRouteMode( "AddEnemy02", true )
			TppEnemyUtility.SetForceRouteMode( "AddEnemy03", true )
			TppEnemyUtility.SetForceRouteMode( "AddEnemy04", true )
			TppEnemyUtility.SetForceRouteMode( "AddEnemy05", true )
			TppCommandPostObject.GsSetKeepPhaseName( this.cpID, "Alert" )
			TppMission.SetFlag("isAddEneGen",true)
--プレイヤーが増援出現トラップの中にいない場合は一度ヘリ降下してプレイヤーの移動を誘う
		else
			Fox.Log("***************** HELI DOWN FAKE *******************")
			TppVehicleUtility.Extinguish( "Armored_Vehicle_WEST_001" )
			TppRadio.Play ("Radio_RequestingTargetCargo")
			TppSupportHelicopterService.ChangeRoute("HeliBoarding_2")
		end
	end,

	AdditionalEnemiesGen = function() --特定範囲内にプレイヤーがいる場合に適増援を出す
		if( TppMission.GetFlag( "isAddEneGen" ) == false ) then
			Fox.Log("***************** ADDITIONAL ENEMY GEN TRAPPED*******************")
			local hudCommonData = HudCommonDataManager.GetInstance()
			hudCommonData:AnnounceLogViewLangId( "announce_enemyIncrease" )
			TppRadio.Play("Radio_AdditionalEnemyForce",{onEnd = function() commonUiMissionSubGoalNo(6) end,})
			TppEnemyUtility.SetEnableCharacterId( "AddEnemy01", true )
			TppEnemyUtility.SetEnableCharacterId( "AddEnemy02", true )
			TppEnemyUtility.SetEnableCharacterId( "AddEnemy03", true )
			TppEnemyUtility.SetEnableCharacterId( "AddEnemy04", true )
			TppEnemyUtility.SetEnableCharacterId( "AddEnemy05", true )
			TppEnemyUtility.SetForceRouteMode( "AddEnemy01", true )
			TppEnemyUtility.SetForceRouteMode( "AddEnemy02", true )
			TppEnemyUtility.SetForceRouteMode( "AddEnemy03", true )
			TppEnemyUtility.SetForceRouteMode( "AddEnemy04", true )
			TppEnemyUtility.SetForceRouteMode( "AddEnemy05", true )
			TppSupportHelicopterService.ChangeRoute("HeliWaiting")
			TppRadio.Play("Radio_AdditionalEnemyForce02")
			TppCommandPostObject.GsSetKeepPhaseName( this.cpID, "Alert" )
			TppMission.SetFlag("isAddEneGen",true)
		end
	end,

	AdditioalDeadWatcher = function()
			local count = 0
			Fox.Log("***************** DEAD WATCHER ADD_ENE RUNS *******************")
				if IsDeadEnemy("BossEnemy01") then count = count + 1 end
--				if IsDeadEnemy("BossEnemy02") then count = count + 1 end
				if IsDeadEnemy("BossEnemy03") then count = count + 1 end
				if IsDeadEnemy("BossEnemy04") then count = count + 1 end
				if IsDeadEnemy("BossEnemy05") then count = count + 1 end
				if IsDeadEnemy("AddEnemy01") then count = count + 1 end
--				if IsDeadEnemy("AddEnemy02") then count = count + 1 end
				if IsDeadEnemy("AddEnemy03") then count = count + 1 end
				if IsDeadEnemy("AddEnemy04") then count = count + 1 end
				if IsDeadEnemy("AddEnemy05") then count = count + 1 end

				if count >= 6 then
					Fox.Log("***************** Helicopter Come Down *******************")
					if( TppMission.GetFlag( "isHeliReLandingOK" ) == false ) then
							TppVehicleUtility.Extinguish( "Armored_Vehicle_WEST_001" )
							TppMarker.Enable( "FriendMan", 0, "defend", "map_and_world_only_icon")
							TppMarkerSystem.SetMarkerImportant{ markerId="FriendMan", isImportant=true }
							TppMarkerSystem.SetMarkerNew{ markerId = "FriendMan", isNew = true }
							TppSupportHelicopterService.SetPossibleGettingOn("SupportHelicopter", true)
							TppRadio.Play ("Radio_RequestingTargetCargo",{onEnd = function() commonUiMissionSubGoalNo(7) end,})
							TppMission.SetFlag( "isHeliReLandingOK", true )
						if ( TppMission.GetFlag( "isInsideHeliDropArea" ) == false) then--ドロップ範囲に居ない場合
							TppSupportHelicopterService.ChangeRoute("HeliBoarding_2")--★調整
						elseif ( TppMission.GetFlag( "isInsideHeliDropArea" ) == true) then--既にドロップ範囲に居た場合
							TppSupportHelicopterService.ChangeRoute("HeliBoarding_2")
						end
					end
				end
	end,

	HelicopterRouteMove = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("HeliBoarding") ) then
			if (RoutePointNumber == 3) then
				TppMission.SetFlag("isHeliComeDown", true)
			end
		elseif( RouteName ==  GsRoute.GetRouteId("HeliBoarding_2") ) then
			if (RoutePointNumber == 4) then
				TppMission.SetFlag("isHeliComeDown", true)
			end
		end
	end,

	HeliDrop = function()
		TppMission.SetFlag( "isInsideHeliDropArea", true )
		if( TppMission.GetFlag( "isHeliComeDown" ) == true ) then
			TppSupportHelicopterService.ChangeRoute("HeliDrop")
		end
	end,

	HeliHober = function()
		TppMission.SetFlag( "isInsideHeliDropArea", false )
		if( TppMission.GetFlag( "isHeliComeDown" ) == true ) then
			TppSupportHelicopterService.ChangeRoute("HeliHober")
		end
	end,

-- 増援が途中までルート行動で接近 ⇒ Ａｉに切り替わる
	EnemyRouteMove = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("AddEneRoute01") ) then
			if (RoutePointNumber == 1) then	TppEnemyUtility.SetForceRouteMode( "AddEnemy01", false ) end
		end
		if( RouteName ==  GsRoute.GetRouteId("AddEneRoute02") ) then
			if (RoutePointNumber == 2) then	TppEnemyUtility.SetForceRouteMode( "AddEnemy02", false ) end
		end
		if( RouteName ==  GsRoute.GetRouteId("AddEneRoute03") ) then
			if (RoutePointNumber == 2) then	TppEnemyUtility.SetForceRouteMode( "AddEnemy03", false ) end
		end
		if( RouteName ==  GsRoute.GetRouteId("AddEneRoute04") ) then
			if (RoutePointNumber == 2) then TppEnemyUtility.SetForceRouteMode( "AddEnemy04", false ) end
		end
		if( RouteName ==  GsRoute.GetRouteId("AddEneRoute05") ) then
			if (RoutePointNumber == 3) then TppEnemyUtility.SetForceRouteMode( "AddEnemy05", false ) end
		end
	end,


--　圏外処理
	Warning = function()
		TppCommandPostObject.GsSetAntiAircraftMode( "e20040CP", true )
		local enemyNum = TppEnemyUtility.GetNumberOfActiveSoldier( Vector3(-106,31,54), 60 )
		if( enemyNum <= 2 ) then
			TppRadio.Play("Radio_WarningWithoutEnemy")
		else
			TppRadio.Play("Radio_HeliHP10")
		end
	end,

	WarningOff = function()
		TppCommandPostObject.GsSetAntiAircraftMode( "e20040CP", false )
--		GZCommon.OutsideAreaEffectDisable()
	end,

	GameOver = function()
		local enemyNum = TppEnemyUtility.GetNumberOfActiveSoldier( Vector3(-106,31,54), 60 )
		if( enemyNum <= 3 ) then
			TppRadio.Play("Radio_OutOfRangeWithoutEnemy")
		else
			TppRadio.Play("Radio_OutOfRange")
		end
		TppSupportHelicopterService.SetLife("SupportHelicopter", 10000)
		TppEnemyUtility.SetEnableCharacterId( "Killer01", true )
		TppEnemyUtility.SetEnableCharacterId( "Killer02", true )
		TppEnemyUtility.SetEnableCharacterId( "Killer03", true )
		TppEnemyUtility.SetEnableCharacterId( "Killer04", true )
		GkEventTimerManager.Start( "Timer_HeliKiller", 8 )
		TppSupportHelicopterService.ChangeRoute("HeliWaiting")
--		TppEnemyUtility.SetForceRouteMode( "Killer01", true )
--		TppEnemyUtility.SetForceRouteMode( "Killer02", true )
	end,
--ターゲット回収判定
	Capture = function()
		local LaidOnVehicleId = TppData.GetArgument(3)
		Fox.Log ("************************"..tostring(LaidOnVehicleId).."**************************")
		if LaidOnVehicleId == ("SupportHelicopter") then
			if( TppMission.GetFlag( "isHostageCapture" ) == false ) then
				TppMission.SetFlag( "isHostageCapture", true )
			--	TppRadio.Play ( "Radio_TargetCaptured" )
				PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE", "FriendMan" )
				Fox.Log("***************** FRIEND MAN CAPTURED *******************")
				TppSupportHelicopterService.SetPossibleGettingOff("SupportHelicopter", false)
				local hudCommonData = HudCommonDataManager.GetInstance()
				hudCommonData:AnnounceLogViewLangId( "announce_mission_40_20040_000_from_0_prio_0" )
				hudCommonData:AnnounceLogViewLangId( "announce_mission_goal" )
				commonUiMissionSubGoalNo(8)
			end
		end
	end,

--脱出可能判定
	Escape= function()
		if( TppMission.GetFlag( "isHostageCapture" ) == true ) then
			TppCommandPostObject.GsSetAntiAircraftMode( "e20040CP", false )
			TppSequence.ChangeSequence( "Seq_Escape" )
		else
			TppRadio.Play ("Radio_RequestingTargetCargoFirst")
		end
	end,
}

---------------------------------------------------------------------------------
--● Seq_Escape
---------------------------------------------------------------------------------

this.Seq_Escape = {
	Messages = {
		Character = {
			{ data = "HeliRider03", message = { "EnemyDead", "EnemySleep","EnemyFaint"}, localFunc = "HeliEnemyKill"},
			{ data = "SupportHelicopter", message = "MessageRoutePoint", localFunc = "HelicopterRouteMove" },
			{ data = "EnemyHelicopter", message = "MessageRoutePoint",localFunc ="EnemyHelicopterRouteMove" },
			{ data = "SupportHelicopter", message = "LostControl",	localFunc = "EnemyHeliDown"},
			{ data = "e20040CP", message ="EndGroupVehicleRouteMove", localFunc = "EndVehicleMove"},
		},

		Timer = {
			{ data = "Timer_StartRadio", message = "OnEnd", localFunc = "RadioPlay" },

			{ data = "Timer_StartRadio_EnemyHeliKill", message = "OnEnd",
				commonFunc = function()
					if( TppMission.GetFlag( "isRadioPlayed" ) == false ) then
						TppRadio.Play("Radio_HeliKill", nil, nil, nil, "none" )
					end
				end,
			},

			{ data = "Timer_StartRadio_EnemyHeliKill_2", message = "OnEnd", commonFunc = function() TppRadio.Play("Radio_HeliKill", nil, nil, nil, "none" )end,},
			{ data = "Timer_HeliEnemyDead", message = "OnEnd", localFunc = "EnemyHeliRouteChange"},
			{ data = "Timer_EnemyMissileHit", message = "OnEnd", commonFunc = function() TppSupportHelicopterService.Break("SupportHelicopter")end,},
			{ data = "Timer_SupportHelicopterRouteChange", message = "OnEnd", localFunc = "SupportHelicopterRouteChange"},
			{ data = "Timer_SupportHelicopterRouteChange_2", message = "OnEnd", localFunc = "SupportHelicopterRouteChange"},
			{ data = "Timer_Clear", message = "OnEnd", localFunc = "EnterClear"},
			{ data = "Timer_PlayRadioHeli", message = "OnEnd", localFunc = "PlayRadioHeli"},
		},
	},

	OnEnter = function()
		TppCommandPostObject.GsSetForceRouteMode( this.cpID, true )
		TppMissionManager.SaveGame(0005)
		TppPlayerUtility.SetStock( TppPlayer.StockDirectionLeft )
		TppMission.SetFlag("isRideHeli",true)
		TppSupportHelicopterService.ChangeRoute("route04_1")
		TppSoundDaemon.PostEvent( 'sfx_m_e20040_fixed_19' )
		local daemon = TppSoundDaemon.GetInstance()
		daemon:RegisterSourceEvent{sourceName = 'Source_fixed_tower5',tag = 'SingleShot',playEvent = 'sfx_m_e20040_whoosh_l_w',}
		TppData.Disable( "Tactical_Vehicle_WEST_001" )
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_001" }

		TppData.Disable( "Tactical_Vehicle_WEST_002" )
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_002" }

		TppData.Disable( "Tactical_Vehicle_WEST_003" )
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_003" }

		TppData.Disable( "Tactical_Vehicle_WEST_004" )
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_004" }

		TppData.Disable( "Tactical_Vehicle_WEST_006" )
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_006" }

		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "BossEnemy01", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "BossEnemy02", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "BossEnemy03", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "BossEnemy04", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "BossEnemy05", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "AddEnemy01", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "AddEnemy02", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "AddEnemy03", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "AddEnemy04", false )
		TppCommandPostObject.GsSetRealizeEnable( this.cpID, "AddEnemy05", false )
		TppEnemyUtility.SetEnableCharacterId( "EscapeEnemy01", true )
		TppCharacterUtility.ChangeRouteCharacterId( "EscapeEnemy01", "EscapeRoute01", 0 )
		TppEnemyUtility.SetEnableCharacterId( "EscapeEnemy02", true )
		TppCharacterUtility.ChangeRouteCharacterId( "EscapeEnemy02", "EscapeRoute02", 0 )
		TppEnemyUtility.SetEnableCharacterId( "EscapeEnemy03", true )
		TppCharacterUtility.ChangeRouteCharacterId( "EscapeEnemy03", "EscapeRoute03", 0 )
		TppEnemyUtility.SetEnableCharacterId( "EscapeEnemy04", true )
		TppCharacterUtility.ChangeRouteCharacterId( "EscapeEnemy04", "EscapeRoute04", 0 )
		GkEventTimerManager.Start( "Timer_StartRadio", 2 )
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_09' )
--		TppData.Disable("Moai05")
--		TppData.Enable( "EnemyHelicopter" )
	end,

	RadioPlay = function()
		TppRadio.Play("Radio_TakeOff",{onEnd = function() TppRadio.Play("Radio_Escape", nil, nil, nil, "none")end}, nil, nil, "none" )
	end,

	HelicopterRouteMove = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("route04_1") ) then
			if (RoutePointNumber == 6) then
				TppCharacterUtility.ChangeRouteCharacterId( "EscapeEnemy01", "EscapeRoute01_2", 0 )
				TppCharacterUtility.ChangeRouteCharacterId( "EscapeEnemy02", "EscapeRoute02_2", 0 )
				TppCharacterUtility.ChangeRouteCharacterId( "EscapeEnemy03", "EscapeRoute03_2", 0 )
				TppCharacterUtility.ChangeRouteCharacterId( "EscapeEnemy04", "EscapeRoute04_2", 0 )
			elseif (RoutePointNumber == 7) then
				TppSupportHelicopterService.RequestRouteMode("EnemyHelicopter","EnemyHeliRoute", true, 45)
				TppSupportHelicopterService.OpenLeftDoor("EnemyHelicopter")
				TppSupportHelicopterService.InitializeLife("EnemyHelicopter", 21000)
				TppSupportHelicopterService.InitializeLife("SupportHelicopter", 30000)
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_heli1',tag = 'SingleShot',playEvent = 'sfx_m_e20040_fixed_28',}
			elseif (RoutePointNumber == 8) then
				TppSupportHelicopterService.ChangeRoute("route04_2")
				TppEnemyUtility.SetEnableCharacterId( "HeliRider01", true )
				TppEnemyUtility.RequestToGetOnHelicopterAndAimTarget( "HeliRider01", "EnemyHelicopter", "Player", "LEFT" )
				local daemon = TppSoundDaemon.GetInstance()
				daemon:RegisterSourceEvent{sourceName = 'Source_fixed_pole6',tag = 'SingleShot',playEvent = 'sfx_m_e20040_whoosh_s',}
				GkEventTimerManager.Start( "Timer_PlayRadioHeli", 2 )
			end
		elseif( RouteName ==  GsRoute.GetRouteId("route04_2") ) then
			if (RoutePointNumber == 1) then
				TppEnemyUtility.RequestToFireOnHelicopter( "HeliRider01", "EnemyHelicopter", "Player", 240, 12 )
				TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20040_heli_10' )
			elseif (RoutePointNumber == 18) then
				TppData.Enable("Tactical_Vehicle_WEST_10")
				TppEnemyUtility.SetEnableCharacterId( "EscapeVehicleEnemy01", true )
				TppEnemyUtility.SetEnableCharacterId( "EscapeVehicleEnemy02", true )
			elseif (RoutePointNumber == 19) then
				TppData.Enable("Tactical_Vehicle_WEST_11")
				TppEnemyUtility.SetEnableCharacterId( "EscapeVehicleEnemy03", true )
				TppData.Enable("Tactical_Vehicle_WEST_12")
				TppEnemyUtility.SetEnableCharacterId( "EscapeVehicleEnemy04", true )
				TppMission.SetFlag("isHeliEscapeOK", true)
				if( TppMission.GetFlag( "isEnemyHeliNeutralized" ) == true ) then
					Fox.Log("ROUTE CHANGE : ROUTE CLEAR")
					TppSupportHelicopterService.ChangeRoute("SupportHelicopter","route_clear")
				else
					if( TppMission.GetFlag( "isEnemyHeliNoThreat" ) == false ) then
						TppRadio.Play("Radio_ShootHeli", nil, nil, nil, "none" )
					end
				end
			end
		elseif( RouteName == GsRoute.GetRouteId("route_clear") ) then
			if (RoutePointNumber == 1) then
				SimDaemon.SetForceSimNotActiveMode( 20 )
				GkEventTimerManager.Start( "Timer_Clear", 6.333 )
			end
		end
	end,

	PlayRadioHeli = function()
		TppRadio.Play( "Radio_EnemyHeli",
			{onEnd = function()
				TppMarker.Enable( "EnemyHelicopter", 0, "attack", "map_and_world_only_icon")
				TppMarkerSystem.SetMarkerNew{ markerId = "EnemyHelicopter", isNew = true }
			 end},
			nil,
			nil,
			"none"
		)
	end,

	EnemyHelicopterRouteMove = function()
		local RouteName					= TppData.GetArgument(3)
		local RoutePointNumber				= TppData.GetArgument(1)
		if( RouteName ==  GsRoute.GetRouteId("EnemyHeliRoute") ) then
			if (RoutePointNumber == 6) then
				TppEnemyUtility.SetEnableCharacterId( "HeliRider01", false )
				TppEnemyUtility.SetEnableCharacterId( "HeliRider02", true )
				TppEnemyUtility.RequestToGetOnHelicopterAndAimTarget( "HeliRider02", "EnemyHelicopter", "Player", "LEFT" )
			elseif (RoutePointNumber == 7) then
				TppEnemyUtility.RequestToFireOnHelicopter( "HeliRider02", "EnemyHelicopter", "Player", 270, 15 )
			elseif (RoutePointNumber == 17) then
				TppEnemyUtility.SetEnableCharacterId( "HeliRider02", false )
				TppSupportHelicopterService.OpenRightDoor("EnemyHelicopter")
				TppEnemyUtility.SetEnableCharacterId( "HeliRider03", true )
				TppEnemyUtility.RequestToGetOnHelicopterAndAimTarget( "HeliRider03", "EnemyHelicopter", "Player", "RIGHT" )
			elseif (RoutePointNumber == 19) then
				TppSupportHelicopterService.ChangeRoute("EnemyHelicopter","EnemyHeliRoute_2")
			end
		elseif( RouteName ==  GsRoute.GetRouteId("EnemyHeliRoute_2") ) then
			if (RoutePointNumber == 2) then
				TppEnemyUtility.RequestToFireOnHelicopter( "HeliRider03", "EnemyHelicopter", "Player", 280, 5.0 )
			elseif (RoutePointNumber == 3) then
				TppEnemyUtility.SetFlagDisableBulletDamageReactionInHelicopter( "HeliRider03", true )
			elseif (RoutePointNumber == 4) then
				if( TppMission.GetFlag( "isEnemyHeliNoThreat" ) == false ) then
					TppEnemyUtility.RequestToFireOnHelicopter( "HeliRider03", "EnemyHelicopter", "Player", 270, 0.3 )
					GkEventTimerManager.Start( "Timer_EnemyMissileHit", 0.6 )
				end
			end
		end
	end,

	EndVehicleMove = function()
		local arg2 = TppData.GetArgument(2)
		if arg2.vehicleCharacterId == "Tactical_Vehicle_WEST_10" then
			TppCharacterUtility.ChangeRouteCharacterId( "EscapeVehicleEnemy01", "EscapeRoute09", 0 )
			TppCharacterUtility.ChangeRouteCharacterId( "EscapeVehicleEnemy02", "EscapeRoute10", 0 )
		end
	end,


	EnterClear = function()
		TppEnemyUtility.SetEnableCharacterId( "HeliRider01", false )
		TppEnemyUtility.SetEnableCharacterId( "HeliRider03", false )
		GZCommon.StopSirenNormal()
		GZCommon.ScoreRankTableSetup( this.missionID )
		TppMission.ChangeState( "clear", "RideHeli_Clear" )
	end,

	HeliEnemyKill = function()
		TppMission.SetFlag("isEnemyHeliNoThreat",true)
		TppSupportHelicopterService.ChangeTargetSpeed("EnemyHelicopter",35, 2)
		GkEventTimerManager.Start( "Timer_HeliEnemyDead", 3 )
		if( TppMission.GetFlag( "isRadioPlayed" ) == false ) then
			TppRadio.Play("Radio_HeliKill", nil, nil, nil, "none" )
			TppMission.SetFlag( "isRadioPlayed", true )
		end
	end,

	EnemyHeliRouteChange = function()
		TppSupportHelicopterService.ChangeRoute("EnemyHelicopter","EnemyHeliRouteRetrun")
--旋回音を鳴らす
		local heliChara = Ch.FindCharacterObjectByCharacterId( "EnemyHelicopter" )
		TppSoundDaemon.PostEvent3D('sfx_m_e20040_fixed_29', heliChara:GetPosition())

		GkEventTimerManager.Start( "Timer_SupportHelicopterRouteChange", 3 )
	end,

	SupportHelicopterRouteChange = function()
		TppSupportHelicopterService.ChangeTargetSpeed("SupportHelicopter",60, 3)
		if( TppMission.GetFlag( "isHeliEscapeOK" ) == true ) then
			TppSupportHelicopterService.ChangeRoute("SupportHelicopter","route_clear")
		Fox.Log("ROUTE CHANGE : ROUTE CLEAR")
		end
	end,

	EnemyHeliDown = function()
		if TppData.GetArgument(1) ~= "EnemyHelicopter" then return end
		Fox.Log("***************** ENEMY HELI DOWN *******************")
		TppMission.SetFlag("isEnemyHeliNoThreat",true)
		TppMission.SetFlag("isEnemyHeliNeutralized", true)
		GkEventTimerManager.Start( "Timer_StartRadio_EnemyHeliKill", 7 )
		GkEventTimerManager.Start( "Timer_SupportHelicopterRouteChange_2", 6 )
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:AnnounceLogViewLangId( "announce_destroy_heli" )
	end,

}
--------------------------------------------------------------------------------
--● クリアデモ判定シーケンス
---------------------------------------------------------------------------------
this.Seq_MissionClearDemoPrepare = {
	MissionState = "clear",
	OnEnter = function()
		TppSupportHelicopterService.DisableDamageEffects("SupportHelicopter")
		local Rank = PlayRecord.GetRank()
		if( Rank == 0 ) then
			Fox.Warning( "commonMissionClearDemo:Mission not yet clear!!" )
		elseif( Rank == 1 ) then
			TppSequence.ChangeSequence( "Seq_MissionClearDemo01" )
			-- 実績解除：「Sランクでミッションをクリア」
			Trophy.TrophyUnlock(4)
		elseif( Rank == 2 ) then
			TppSequence.ChangeSequence( "Seq_MissionClearDemo02" )
		elseif( Rank == 3 ) then
			TppSequence.ChangeSequence( "Seq_MissionClearDemo02" )
		else
			TppSequence.ChangeSequence( "Seq_MissionClearDemo03" )
		end
	end,
}
--------------------------------------------------------------------------------
--● クリアデモ再生シーケンス
---------------------------------------------------------------------------------
this.Seq_MissionClearDemo01 = {
	MissionState = "clear",
	OnEnter = function()
		SimDaemon.SetForceSimLocalMode( 10 )
		TppDemo.Play( "Demo_MissionClear01", {onEnd = function()TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" )end})
	end,
}

this.Seq_MissionClearDemo02 = {
	MissionState = "clear",
	OnEnter = function()
		SimDaemon.SetForceSimLocalMode( 10 )
		TppDemo.Play( "Demo_MissionClear02", {onEnd = function()TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" )end})
	end,
}

this.Seq_MissionClearDemo03 = {
	MissionState = "clear",
	OnEnter = function()
		SimDaemon.SetForceSimLocalMode( 10 )
		TppDemo.Play( "Demo_MissionClear03", {onEnd = function()TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" )end})
	end,
}
--------------------------------------------------------------------------------
--● ミッション終了テロップシーケンス
---------------------------------------------------------------------------------
this.Seq_MissionClearShowTransition = {
	MissionState = "clear",

	Messages = {
		UI = {
			-- 終了ミッションテロップのフェードイン
			{ message = "EndMissionTelopFadeIn" ,	localFunc = "OnFinishClearFade" },
		},
	},

	-- クリア画面遷移タイミングでクリア無線コール
	OnFinishClearFade = function()

		-- テロップ～ミッション完全終了まで無線とBGM以外ミュート
		TppSoundDaemon.SetMute( 'Result' )
		-- ミッション終了ジングル再生
--		TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default" )

		-- Btk14648対応：クリアランクに応じてジングル呼び分け
		local Rank = PlayRecord.GetRank()
		if( Rank == 0 ) then
			Fox.Warning( "Seq_MissionClearShowTransition:Mission not yet clear!!" )
		elseif( Rank == 1 ) then
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_s" )
		elseif( Rank == 2 ) then
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_ab" )
		elseif( Rank == 3 ) then
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_ab" )
		elseif( Rank == 4 ) then
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_cd" )
		elseif( Rank == 5 ) then
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_cd" )
		else
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_e" )
		end
	end,

	OnEnter = function()
		local funcs = {
			onStart = function()
				TppUI.FadeOut( 60 )
			end,
			onEnd = function()
				TppSequence.ChangeSequence( "Seq_ShowClearReward" )
--				TppSequence.ChangeSequence( "Seq_MissionEnd" )
			end,
		}
		TppUI.ShowTransition( "ending", funcs )

	end,
}
--------------------------------------------------------------------------------
--● 報酬表示シーケンス
---------------------------------------------------------------------------------
this.Seq_ShowClearReward = {
	MissionState = "clear",
	Messages = {
		UI = {
--			{ message = "PopupClose", commonFunc = function() this.OnClosePopupWindow() end },
			{ message = "BonusPopupAllClose", commonFunc = function() TppSequence.ChangeSequence( "Seq_MissionEnd" ) end },
		},
	},
	OnEnter = function()
		Fox.Log("-------Seq_ShowClearReward--------")
		this.OnShowRewardPopupWindow()
	end,
}

---------------------------------------------------------------------------------
--● ミッション失敗時処理シーケンス
---------------------------------------------------------------------------------
this.Seq_MissionFailed = {
	MissionState = "failed",
	Messages = {
		Timer = {
			{ data = "MissionFailedProductionTimer",	message = "OnEnd", 	localFunc="OnFinishMissionFailedProduction" },
		},
	},

	OnFinishMissionFailedProduction = function( manager )
		TppSequence.ChangeSequence( "Seq_MissionGameOver" )
	end,

	OnEnter = function( manager )
		TppMusicManager.PostSceneSwitchEvent( 'Stop_bgm_e20040_heli' )
		TppMusicManager.EndSceneMode()
		GkEventTimerManager.Start( "MissionFailedProductionTimer", this.CounterList.GameOverFadeTime )
	end
}

-- ■ Seq_MissionFailed_HelicopterDead
this.Seq_MissionFailed_HelicopterDead = {
	MissionState = "failed",
	Messages = {
		Character = {
			{ data = "SupportHelicopter",	message = "Dead",	localFunc = "localChangeSequence" },
		},
	},
	OnEnter = function()
		TppPlayerUtility.RequestPlayMissionFailAnimationInHelicopter{}
		this.CounterList.GameOverRadioName = "Radio_PlayerDeadwithHeli"	-- ここは各ミッションで用意している無線の名前に変更
	end,
	localChangeSequence = function()
		TppSequence.ChangeSequence( "Seq_MissionGameOver" )
	end,
}

-- ■ Seq_MissionFailed_HelicopterDeadNotOnPlayer
this.Seq_MissionFailed_HelicopterDeadNotOnPlayer = {
	MissionState = "failed",
	Messages = {
		Character = {
			{ data = "SupportHelicopter",	message = "Dead",	localFunc = "localChangeSequence" },
		},
	},
	OnEnter = function()
		GZCommon.PlayCameraOnCommonHelicopterGameOver()
				this.CounterList.GameOverRadioName = "Radio_HeliDeadwithoutPlayer"	-- ここは各ミッションで用意している無線の名前に変更
	end,
	localChangeSequence = function()
		TppSequence.ChangeSequence( "Seq_MissionGameOver" )
	end,
}
---------------------------------------------------------------------------------
--● GameOver シーケンス
---------------------------------------------------------------------------------
-- ■ Seq_MissionGameOver
this.Seq_MissionGameOver = {
	MissionState = "gameOver",
	Messages = {
		UI = {
			{ message = "GameOverOpen" ,	localFunc = "OnFinishGameOverFade" },
		},
	},

	OnFinishGameOverFade = function()
		FadeFunction.ResetFadeColor()
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )
		TppRadio.DelayPlay( this.CounterList.GameOverRadioName, nil, "none" )
	end,

	OnEnter = function()
	end,
}
---------------------------------------------------------------------------------
--● ミッション終了処理シーケンス
---------------------------------------------------------------------------------
this.Seq_MissionEnd = {
	OnEnter = function()
		this.commonMissionCleanUp()
		-- ジングルフェード終了
		TppMusicManager.PostJingleEvent( "SingleShot", "Stop_bgm_gntn_ed_default" )
		TppMissionManager.SaveGame()		-- Btk14449対応：報酬獲得Sequenceで獲得した報酬をSaveする
		TppMission.ChangeState( "end" )

	end,
}
---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this
