local this = {}

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■■■ Member Variables
------------------------------------------------------------------------------------------------------------------------------------------------------------------

this.missionID = 20030
this.cpID		= "gntn_cp"

-- 強制捜索の継続時間（KeepCaution）
this.Time_ForceSerching	= (60*5)

-- 内通者への合図説明無線を鳴らすまでの時間
this.Time_PlayRadioAboutSignal	= (60)

-- ヘリ回収した内通者から情報を聞き出している時間
this.Time_ListeningInfoFromBetrayer	= (20)

-- 内通者に接触した際に周囲のアクティブ敵兵を検索する範囲（m）
this.Size_ActiveEnemy		= 18

-- ユニークキャラのCharaID
this.BetrayerID		= "e20030_Betrayer"		-- 内通者
this.AssistantID	= "e20030_Assistant"	-- 内通者の取り巻き兵
this.MastermindID	= "e20030_Mastermind"	-- テープBを持つ反乱兵

-- カセットのID
this.CassetteA	=	"tp_it20030_01"
this.CassetteB	=	"tp_it20030_02"

-- CP無線：「監視カメラに異常発生」無線名
this.SecurityCameraDeadRadioName	= "CPR0340"

-- 所属エリア名フラグ管理用
this.Area_campEast = 0
this.Area_campWest = 1
this.Area_Heliport = 2
this.Area_WareHouse = 3

-- アナウンスログLangID
this.AnnounceLogID_Signal			= "announce_mission_40_20030_000_from_0_prio_0"
this.AnnounceLogID_Contact			= "announce_mission_40_20030_001_from_0_prio_0"
this.AnnounceLogID_CassetteA		= "announce_mission_40_20030_002_from_0_prio_0"
this.AnnounceLogID_CassetteB		= "announce_mission_40_20030_003_from_0_prio_0"
this.AnnounceLogID_Inspection		= "announce_mission_40_20030_004_from_0_prio_0"
this.AnnounceLogID_MapUpdate		= "announce_map_update"
this.AnnounceLogID_AreaWarning		= "announce_mission_area_warning"
this.AnnounceLogID_ChallengeFailure	= "announce_challengeFailure"
this.AnnounceLogID_RecoveryBetrayer		= "announce_mission_40_20030_005_from_0_prio_0"
this.AnnounceLogID_RecoveryMastermind	= "announce_mission_40_20030_006_from_0_prio_0"
this.AnnounceLogID_MissionGoal		= "announce_mission_goal"
this.AnnounceLogID_HeliDead			= "announce_destroyed_support_heli"
this.AnnounceLogID_InfoUpdate		= "announce_mission_info_update"


-- 実績解除ID
this.TrophyId_e20030_CargoClear		= 9		-- トラックの荷台に乗ってクリアした
this.TrophyId_GZ_SideOpsClear		= 2		-- サイドオプスを1つクリア
this.TrophyId_GZ_RankSClear			= 4		-- Sランクでミッションをクリア

-- 中間目標番号
this.MissionSubGoal_Betrayer	= 1		-- 調査員に接触せよ
this.MissionSubGoal_Cassette	= 2		-- カセットテープを回収せよ
this.MissionSubGoal_Mastermind	= 3		-- スキンヘッドの兵士からカセットテープを回収せよ	※使用しない
this.MissionSubGoal_Escape		= 4		-- 収容施設から脱出せよ

-- 報酬関連
this.tmpChallengeString = 0			-- 報酬ポップアップ識別用
this.tmpBestRank = 0				-- ベストクリアランク比較用(5 = RankD)
this.tmpRewardNum = 0				-- 達成率（報酬獲得数）表示用

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■■■ EventSequenceManager
------------------------------------------------------------------------------------------------------------------------------------------------------------------
this.RequiredFiles = {
	"/Assets/tpp/script/common/GZCommon.lua",
}

this.Sequences = {
	{ "Seq_MissionPrepare" },
	{ "Seq_MissionSetup" },
	{ "Seq_OpeningDemoLoad" },
	{ "Seq_OpeningShowTransition" },
	{ "Seq_OpeningDemo" },
	{ "Seq_MissionLoad" },
	{ "Seq_TruckInfiltration" },
	{ "Seq_Waiting_BetrayerContact" },
	{ "Seq_BetrayerContactDemo" },
	{ "Seq_Waiting_GetCassette" },
	{ "Seq_Escape_CameraActive" },
	{ "Seq_Escape_CameraBroken" },
	{ "Seq_PlayerRideHelicopter" },
	{ "Seq_PlayerEscapeMissionArea" },
	{ "Seq_MissionClearDemo" },
	{ "Seq_MissionClearShowTransition" },
	{ "Seq_MissionClear" },
	{ "Seq_MissionAbort" },
	{ "Seq_MissionFailed" },
	{ "Seq_MissionGameOver" },
	{ "Seq_ShowClearReward" },
	{ "Seq_MissionEnd" },
}

-- 使用するチェック処理を宣言
this.checkings = {
	"CheckLookingTarget"
}

this.OnStart = function( manager )
	GZCommon.Register( this, manager )
	TppMission.Setup()
end

-- "exec"に向かうべきシーケンスのリスト
this.ChangeExecSequenceList =  {
--	"Seq_OpeningShowTransition",
	"Seq_OpeningDemo",
	"Seq_MissionLoad",
	"Seq_TruckInfiltration",
	"Seq_Waiting_BetrayerContact",
	"Seq_BetrayerContactDemo",
	"Seq_Waiting_GetCassette",
	"Seq_Escape_CameraActive",
	"Seq_Escape_CameraBroken",
	"Seq_PlayerRideHelicopter",
--	"Seq_PlayerEscapeMissionArea",
--	"Seq_MissionClearDemo",
--	"Seq_MissionClearShowTransition",
}

-- ゲームに向かうべきシーケンスなのかを知ることが出来る
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
	-- 各シーケンスに入ったときに、execに向かうべきなら向かう
	if IsChangeExecSequence() then
		TppMission.ChangeState( "exec" )
	end
end

this.OnLeaveCommon = function()
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log( "=== " .. sequence .. " : OnLeave ===" )
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■■■ List
------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- ■■ Mission Flag List
---------------------------------------------------------------------------------
this.MissionFlagList = {
	isBetrayerContact				= false,		-- 内通者と接触済みか
	isGetCassette_A					= false,		-- カセットAを入手したか
	isGetCassette_B					= false,		-- カセットBを入手したか
	isDropCassette_B				= false,		-- カセットBをドロップしたか

	isGetInfo_Mastermind			= false,		-- 尋問により反乱兵の情報を入手済みか
	isGetInfo_CameraTrap			= false,		-- 中央管制塔に監視カメラが仕掛けられている情報を入手済みか（目視または破壊）
	isGetInfo_Suspicion1			= false,		-- 会話イベント一部遭遇により内通者に対する疑惑を持っているか
	isGetInfo_Suspicion2			= false,		-- 内通者に関して罠だと知ってるか（会話イベント完全遭遇、監視カメラ被発見、接触デモ後のカメラ破壊orカメラ諜報）
	isGetInfo_Suspicion3			= false,		-- 会話イベント完全遭遇
	isGetInfo_Intimidation			= false,		-- 内通者の尋問台詞「連中にバレて脅された」を聞いているか
--	isGetInfo_Rebellion				= false,		-- 反乱兵の尋問台詞「俺たちは国家を超える」を聞いているか

	isBetrayerDown					= false,		-- 内通者が死亡しているか
	isBetrayerMarking				= false,		-- 内通者にマーキング済み
	isBetrayerOnHeli				= false,		-- 内通者がヘリに乗せられた
	isAssistantDown					= false,		-- 取り巻き兵が生存しているか
	isMastermindDown				= false,		-- 反乱兵が死亡しているか
	isMastermindMarking				= false,		-- 反乱兵にマーキング済み
	isMastermindOnHeli				= false,		-- 反乱兵がヘリに乗せられた
	BetrayerArea					= this.Area_campEast,	-- 内通者の現在の所属エリア管理

	isCameraBroken					= false,		-- 中央管制塔の監視カメラが破壊されているか
	isCameraBrokenRadio				= false,		-- いずれかの中央管制塔の監視カメラ破壊時無線を再生済みか
	isCameraAlert					= false,		-- 中央管制塔の監視カメラがプレイヤーを発見したか
	isCameraDemoPlay				= false,		-- 中央管制塔の監視カメラ発見デモ再生済みか
	isCameraIntelRadioPlay			= false,		-- 中央管制塔の監視カメラに対して諜報無線を実行済みか
	isSignalExecuted				= false,		-- 内通者への合図を実行済みか
	isSignalCheckEventEnd			= false,		-- 内通者の合図確認イベントが終了済みか
	isSignalTurretDestruction		= false,		-- 内通者への合図やぐらが破壊済みか
--	isSignalLightDestruction		= false,		-- 内通者への合図サーチライトが破壊済みか
	listeningInfoFromBetrayer		= false,		-- ヘリ回収した内通者から情報を聞き出し中

	isPlayerEnterMissionArea		= false,		-- プレイヤーがミッションエリアに侵入済みか
	isPlayerInWestCamp				= false,		-- プレイヤーが西難民キャンプエリアに居るか
	isPlayerCheckMbPhoto			= false,		-- プレイヤーがMB端末の写真を確認しているか
	isBetrayerTogether				= false,		-- 内通者と取り巻き兵が一緒に行動している（合図チェックしている）かどうか
	isBetrayerSignalCheckWait		= false,		-- 内通者合図チェック同期待ちフラグ
	isAssistantSignalCheckWait		= false,		-- 取り巻き兵合図チェック同期待ちフラグ
	isWarningMissionArea			= false,		-- ミッション圏外警告を受けているか
	isMastermindConversationEnd		= false,		-- 内通者と反乱兵の会話イベントが終了しているか
	isAssistantConversationEnd		= false,		-- 内通者と取り巻き兵の会話イベントが終了しているか
	isInspectionActive				= false,		-- 検問が設置済みか

	isAlreadyAlert					= false,		-- ミッション中一度でもAlertになったか
	isWavActivate					= false,		-- 敵装甲車が出現済みか
	isWavBroken						= false,		-- 敵装甲車が破壊済みか

	-- Marker圏外でon/off切替制御用
	isMarkingTruck001				= false,		-- トラック001マーカー
	isMarkingTruck002				= false,		-- トラック002マーカー
	isMarkingDriver001				= false,		-- 運転手001マーカー
	isMarkingDriver002				= false,		-- 運転手002マーカー

	-- 無線関連
	isRadio_MissionBriefingSub1		= false,		-- 無線再生済みチェックフラグ
	isRadio_MissionBriefingSub1_3	= false,		-- 無線再生済みチェックフラグ
	isRadio_MissionBriefingSub2		= false,		-- 無線再生済みチェックフラグ
	isRadio_SimpleObjectivePlay		= false,		-- 「要するにやること無線」再生予約フラグ
	OnPlay_MissionBriefingSub1		= false,		-- ミッション補足説明無線再生中判定フラグ
	isNotMarkBeforeSignal			= false,		-- 内通者への合図実行前に内通者を特定していない

	-- デモ用フラグ
	dbg_OpeningDemoSkipFlag			= false,			-- Debug
	isOpeningDemoSkip				= false,			-- 開始デモがスキップされた
	isSwitchLightDemo				= false,			-- 停電デモが発生した

	-- 車両チュートリアル制御用フラグ
	isCarTutorial					= false,		-- 乗り物チュートリアルのボタン表示をした
	isAVMTutorial					= false,		-- 装甲車チュートリアルのボタン表示をした

	isHeliLandNow					= false,		-- ヘリが地面にホバリングってるかどうか
}

---------------------------------------------------------------------------------
-- ■■ Mission Counter List
---------------------------------------------------------------------------------
this.CounterList = {
	DEBUG_commonPrint2DCount	= 0,				-- デバッグ文字用カウント
	MissionRank					= 0,				-- ミッションランク
	PlayerArea					= "Area_campWest",	-- プレイヤーの所属エリア
--	BetrayerArea				= "Area_campEast",	-- 内通者の所属エリア
	BetrayerInterrogation		= 0,				-- 内通者の尋問用カウンター
	MastermindInterrogation		= 0,				-- 反乱兵の尋問用カウンター
	GameOverRadioName			= "NoRadio",		-- ゲームオーバー無線名
	BetrayerInterrogationSet	= "A",				-- 内通者の尋問セリフセット名
	BetrayerInterrogationSerif	= "A",				-- 内通者が最後に発言した尋問セリフ名
	BetrayerRestraintEndRadio	= "NoRadio",		-- 内通者拘束解除時のミラー無線名
	MastermindRestraintEndRadio	= "NoRadio",		-- 反乱兵拘束解除時のミラー無線名
	CameraBrokenRadio			= "NoRadio",		-- 監視カメラ破壊時のミラー無線名
	PlayerOnCargo				= "NoRide",			-- プレイヤーがトラックの荷台に乗っているかどうか
--	PlayerOnVehicle				= "NoRide",			-- プレイヤーが車両に乗っているかどうか
	GameOverFadeTime			= 1.4,	-- ゲームオーバー時フェードアウト開始までのウェイト
	WestTruckStatus				= 0,	-- 西検問を通過する循環トラックの現在位置管理 0:停車中、-1:区画内（圏外→圏内）、+値:区画内Node（圏内→圏外）
	NorthTruckStatus			= 0,	-- 北検問を通過する循環トラックの現在位置管理 0:停車中、-1:区画内（圏外→圏内）、+値:区画内Node（圏内→圏外）
	BetrayerRestraint			= 0,				-- 内通者の拘束が初回かどうか（拘束し続けているか？の識別）
}

---------------------------------------------------------------------------------
-- ■■ Demo List
---------------------------------------------------------------------------------
this.DemoList = {
	Demo_Opening 			= "p12_020000_000",		-- オープニングデモ
	Demo_BetrayerContactCam	= "p12_020010_000",		-- 内通者接触デモ（カメラ演出あり）
	Demo_BetrayerContact	= "p12_020020_000",		-- 内通者接触デモ（カメラ演出なし）
	Demo_SecurityCamera		= "p12_020030_000",		-- 監視カメラに発見されたデモ
	Demo_AreaEscapeNorth	= "p11_020010_000",		-- ミッション圏外離脱カメラデモ：北側
	Demo_AreaEscapeWest		= "p11_020020_000",		-- ミッション圏外離脱カメラデモ：西側
	SwitchLightDemo			= "p11_020003_000",		-- 停電デモ
--	Demo_MissionClear		= "p12_020010_000",		-- ミッションクリアデモ
}

---------------------------------------------------------------------------------
-- ■■ Radio List
---------------------------------------------------------------------------------
this.RadioList = {

	-- ミッション目的
--	Radio_MissionBriefing1		= "e0030_rtrg0005",			-- ミッション目的説明1：積荷にまぎれて潜入、ニカラグアを思い出すなぁ
	Radio_MissionBriefing2		= "e0030_rtrg0006",			-- ミッション目的説明2：調査員と接触しろ
	Radio_AboutSignal			= "e0030_rtrg0012",			-- 内通者への合図説明
	Radio_AboutContact			= "e0030_rtrg0010",			-- 内通者へ接触する方法の説明
--	Radio_MissionBriefingSub1	= "e0030_rtrg0007",			-- ミッション目的説明補足1（長尺）：今回の依頼･･･
	Radio_RideOffTruck			= { "e0030_rtrg0009", 1 },	-- トラックからの降り方
	Radio_CheckMbPhoto			= "e0030_rtrg0013",			-- 端末でターゲットの写真を確認しろ
	Radio_CheckMbPhotoTutorial	= { "e0030_rtrg0019", 1 },	-- 端末での写真確認チュートリアル
	Radio_SimpleObjective		= { "e0030_rtrg0011", 1 },	-- 要するにやること説明（長尺説明を聞いた上でトラックから降りた）

	-- ミッション目的補足系（長尺。シーケンスコンテナ化されているもの。）
	Radio_MissionBriefingSub1	= { "e0030_rtrg0301", 1 },	-- ミッション目的説明補足1：今回の依頼･･･
	Radio_MissionBriefingSub1_1	= { "e0030_rtrg0302", 1 },	-- ミッション目的説明補足1-1：奇妙な話だが･･･
	Radio_MissionBriefingSub1_2	= { "e0030_rtrg0304", 1 },	-- ミッション目的説明補足1-2：長引く戦争で米軍は･･･
	Radio_MissionBriefingSub1_3	= { "e0030_rtrg0305", 1 },	-- ミッション目的説明補足1-3："キューバの中のアメリカ"で、･･･
	Radio_MissionBriefingSub1_5	= { "e0030_rtrg0303", 1 },	-- ミッション目的説明補足1-5：その基地ではあらゆる国の法律が･･･
	Radio_MissionBriefingSub2	= { "e0030_rtrg0008", 1 },	-- ミッション目的説明補足2（長尺）：軍が自分たちで情報を･･･	※カセット入手シーケンスに入ったら言う


	-- 内通者への接触可否
	Radio_ContactNot_Phase		= "e0030_rtrg0030",			-- 接触不可：警戒中なので接触出来ない		→接触しようとした際にフェイズチェックして再生
	Radio_Contactable			= "e0030_rtrg0040",			-- 接触可：警戒が解けたので接触出来る		→フェイズが落ちたら再生
	Radio_ContactNot_NearEnemy1	= "e0030_rtrg0050",			-- 接触不可：付近に敵がいるので接触出来ない	→接触しようとした際に周囲チェックして再生
	Radio_ContactNot_NearEnemy2	= "e0030_rtrg0055",			-- 接触不可：付近に敵が居るので接触出来なかった	→接触した際に周囲チェックして再生
	Radio_Contact_JustNow		= "e0030_rtrg0045",			-- 接触可能になりデモ発動OK	：「よし今だ」

	-- 内通者へのマーキング
	Radio_MarkingBetrayer1		= "e0030_rtrg0140",			-- 内通者をマーキング：「居たな。そいつがターゲットだ」
	Radio_MarkingBetrayer2		= "e0030_rtrg0142",			-- 内通者をマーキング：「奴が1人の時に接触しろ。近づいて拘束するんだ」
	Radio_MarkingBetrayer3		= "e0030_rtrg0145",			-- 内通者をマーキング：「だが敵が一緒だな。排除するか、一人になるのを待つか･･･」
	Radio_MarkingBetrayer4		= "f0090_rtrg0335",			-- MB端末上の内通者写真を見た

	Radio_MarkingMastermind		= "e0030_rtrg0090",			-- 反乱兵をマーキング

	-- カセットA
	Radio_BetrayerContact		= "e0030_rtrg0060",			-- カセットAの位置を端末に反映した
	Radio_FocusCassette_A		= { "e0030_rtrg0065", 1 },	-- カセットはココだ。端末上でカセットAの位置にカーソルを合わせた
	Radio_GetCassette_A			= "e0030_rtrg0070",			-- カセットAを入手：「回収したな、脱出しろ」
	Radio_GetCassette_A_Alert	= "e0030_rtrg0071",			-- Alert中にカセットAを入手：「テープは入手したな、脱出だ、急げ」
	Radio_GetCassette_A_NoHint	= "e0030_rtrg0110",			-- カセットAを入手：接触なし、カメラ破壊済み「こんなところにテープ･･･」
	Radio_PlayedCassette_A		= { "e0030_rtrg0075", 1 },	-- カセットAを聞いた
	Radio_RecommendGetCassette_A = "e0030_oprg0021",		-- カセットの回収に向かえ

	-- カセットB
	Radio_DropCassette_B_NoHint		= "e0030_rtrg0115",			-- カセットBドロップ：尋問ヒントなし、テープAあり「テープがもう1つ･･･どういうことだ？」
	Radio_DropCassette_B_Suspicion	= "e0030_rtrg0190",			-- カセットBドロップ：尋問ヒントなし、テープAなし「何でそいつがテープを？渡ったのか？」
	Radio_DropCassette_B_Confidence	= "e0030_rtrg0195",			-- カセットBドロップ：接触あり、尋問ヒントあり「やはりそいつがテープを持っていたか」
	Radio_PlayedCassette_B			= { "e0030_rtrg0077", 1 },	-- カセットBを聞いた
	Radio_GetCassette_B_NoHint		= "e0030_rtrg0400",			-- カセットB入手：尋問ヒントなし、テープAなし「回収したな」「ともかく帰投してくれ、ボス。そのテープをクライアント（依頼主）に照合させる。」
	Radio_GetCassette_B_WithA		= "e0030_rtrg0401",			-- カセットB入手：尋問ヒントなし、テープAあり「回収したな」「ともかく目的は果たした。帰投してくれ。」
	Radio_GetCassette_B_Confidence	= "e0030_rtrg0402",			-- カセットB入手：接触あり、尋問ヒントあり「回収したな。脱出しろ。」


	-- 監視カメラに発見された
	Radio_CameraTrap_NoContact	= { "e0030_rtrg0119", 1 },		-- 監視カメラに引っかかった：「侵入がバレた。罠か？」
	Radio_CameraTrap_Normal		= { "e0030_rtrg0120", 1 },		-- 監視カメラに引っかかった：「侵入がバレた。罠か？」「あの諜報員俺たちをハメたのか？」
--	Radio_CameraTrap_Suspicion	= { "e0030_rtrg0121", 1 },		-- 監視カメラに引っかかった：諜報員を疑っていない「あの諜報員ハメたのか？」
	Radio_CameraTrap_Confidence	= { "e0030_rtrg0122", 1 },		-- 監視カメラに引っかかった：諜報員を疑っていた「くそ！やはり罠だったか！」

	-- 監視カメラを破壊した
	Radio_BrokeCamera_NoHint	= { "e0030_rtrg0124", 1 },	-- 監視カメラを破壊した：「監視カメラ･･･罠か」「あの調査員、俺たちをハメたのか？」
	Radio_BrokeCamera_Confidence= { "e0030_rtrg0125", 1 },	-- 監視カメラを破壊した：「監視カメラ･･･やはり罠だったか」
	Radio_BrokeCamera_Accident	= { "e0030_rtrg0160", 1 },	-- 監視カメラを破壊した：「監視カメラか･･･危ないところだったな」

	-- 内通者への合図
	Radio_RunSignal				= { "e0030_rtrg0150", 1 },	-- 内通者への合図を実行した
	Radio_AppearedBetrayer		= "e0030_rtrg0130",			-- 合図を受けて内通者が現れた：「よし、ターゲットが来た」
	Radio_IsThatBetrayer		= { "e0030_rtrg0020", 1 },	-- 合図を受けて内通者らしき敵兵が現れた：「あれは･･･！」
	Radio_AppearedAssistant		= "e0030_rtrg0132",			-- 内通者の取り巻きが邪魔：「敵が一緒か･･･どうする？」
	Radio_DisablementAssistant	= "e0030_rtrg0170",			-- 取り巻きを排除した：「よし、ターゲットが一人になった。接触してくれ」
	Radio_SignalBroken			= { "e0030_rtrg0015", 1 },	-- 内通者への合図用サーチライトが使用できなくなった
	Radio_Map_Signal			= { "e0030_rtrg0014", 1 },	-- MB端末上で合図用サーチライトにカーソルを合わせた

	-- 内通者の接触後の立ち話（裏切り発覚）
	Radio_Conversation_Comp		= "e0030_rtrg0200",			-- 内通者の立ち話を聞いた（完全）
	Radio_Conversation_InComp	= "e0030_rtrg0201",			-- 内通者の立ち話を聞いた（不完全）

	-- 内通者のステータス
	Radio_FaintBetrayer_BeforeDemo			= { "e0030_rtrg0093", 1 },	-- 内通者が気絶した（デモ前）
	Radio_SleepBetrayer_BeforeDemo			= { "e0030_rtrg0094", 1 },	-- 内通者が睡眠した（デモ前）
	Radio_DisablementBetrayer_AfterDemo		= "e0030_rtrg0103",		-- 内通者が無力化された（デモ後）
	Radio_DeadBetrayer_AfterDemo			= "e0030_rtrg0100",		-- 内通者が死亡した（デモ後）
	Radio_DeadBetrayer_AfterGetCassette		= "e0030_rtrg0105",		-- 内通者が死亡した（カセット入手後）
	Radio_BetrayerOnHeli					= "e0030_rtrg0240",		-- 内通者を回収した（接触デモ前）：「調査員を回収するのか？　わかった。テープの情報を聞き出そう」
	Radio_GetInfo_FromBetrayerOnHeli		= "e0030_rtrg0243",		-- 回収した内通者からカセットAの情報を入手した

	-- 脱出シーケンス
	Radio_Inspection			= { "e0030_rtrg0180", 1 },		-- 検問が設置された(テープA回収時にカメラに発見された状態)
	Radio_EscapeWay				= "e0030_oprg0080",				-- 脱出する方法は複数ある(テープA回収時にカメラに発見されなかった状態)
	Radio_RecommendEscape		= "e0030_oprg0030",				-- 目的は達したので脱出を勧める
	Radio_LandEscape			= "e0030_rtrg0033",				-- 陸路からの脱出について（MB端末で検問にフォーカスした）

	-- クリア評価
	Radio_MissionClearRank_D	= "e0030_rtrg0080",
	Radio_MissionClearRank_C	= "e0030_rtrg0082",
	Radio_MissionClearRank_B	= "e0030_rtrg0084",
	Radio_MissionClearRank_A	= "e0030_rtrg0086",
	Radio_MissionClearRank_S	= "e0030_rtrg0088",

	-- ミッション失敗無線（ゲームオーバー無線）
	Radio_DeadBetrayer_BeforeDemo		= "f0033_gmov0140",		-- 内通者が死亡した（デモ前）：ゲームオーバー無線
	Radio_DeadPlayer					= "f0033_gmov0010",		-- プレイヤーが死亡した
	Radio_RideHeli_Failed				= "f0033_gmov0040",		-- プレイヤーがヘリに乗って離脱した
	Radio_MissionArea_Failed			= "f0033_gmov0020",		-- プレイヤーがミッション圏外に出た

	-- クリア後黒電話（シーケンスコンテナ）
	Radio_BlackCall_Cassette_A	= "e0030_rtrg0210",		-- カセットAのみ回収
	Radio_BlackCall_Cassette_B	= "e0030_rtrg0215",		-- カセットBのみ回収


	-- 尋問への反応台詞
	Radio_Reaction_Intimidation	= { "e0030_rtrg0220", 1 },	-- 内通者尋問後「連中にバレて脅された」という台詞に対して:「そいつの言う『連中』･･･サイファーか？」
	Radio_Reaction_Escape		= { "e0030_rtrg0221", 1 },	-- 内通者尋問後：!調査員拘束デモ見た && !罠だと知ってるフラグ && テープＡ持ってる && !テープＢ落とした：「どういうことだ」「ともかく目的は果たした。帰投してくれ」
	Radio_Reaction_Search		= { "e0030_rtrg0222", 1 },	-- 内通者尋問後「テープを奪われた」という台詞に対して：「テープを奪った兵士……捜してみるか？」
	Radio_Reaction_Truth		= { "e0030_rtrg0223", 1 },	-- 内通者尋問後「テープを奪われた」という台詞に対して：「あのテープ……そういうことか！」

	Radio_Reaction_Rebellion	= "e0030_rtrg0230",			-- 反乱兵の「俺たちは国家を超える」という台詞に対して「国家を超える。どういうことだ」

	-- ミッション汎用無線
	Radio_MissionArea_Warning	= "f0090_rtrg0310",			-- ミッション圏外警告
	Radio_MissionArea_Clear		= "f0090_rtrg0315",			-- クリア条件を満たしてミッション圏外警告エリア内に入った
	Radio_MissionAbort_Warning	= "f0090_rtrg0120",			-- ミッション中断警告「どうした？ミッション中止か？」
	Radio_HeliAbort_Warning		= "f0090_rtrg0130",			-- ミッション中断警告「ヘリに乗ればミッション中止だ。いいのか？」
	Radio_RideHeli_Clear		= "f0090_rtrg0460",			-- ヘリで離脱する「よし、乗ってくれ！離脱する！」
	Radio_DiscoverHostage		= { "f0090_rtrg0470", 1 },	-- 捕虜を見つけた「捕虜か。どうする。助けるか？」
	Radio_HostageOnHeli			= "f0090_rtrg0200",			-- 捕虜をヘリに乗せた「よし、回収した」
	Radio_EncourageMission		= "f0090_rtrg0011",			-- ミッション遂行促し「任務に戻ってくれ、ボス」
	Radio_BrokenHeli			= "f0090_rtrg0220",			-- プレイヤー未搭乗のヘリが撃墜された
	Radio_BrokenHeliSneak		= "f0090_rtrg0155",			-- プレイヤー未搭乗のヘリが撃墜された

	--汎用無線
	Miller_AlartAdvice			= "f0090_rtrg0230",			--0 アラート警告
	Miller_AlertToEvasion		= "f0090_rtrg0260",			--0 アラート後、エバージョンフェーズ
	Miller_ReturnToSneak		= "f0090_rtrg0270",			--0 スニークフェイズに戻った
	Miller_SpRecoveryLifeAdvice	= "f0090_rtrg0290",			--超体力回復促し
	Miller_RevivalAdvice		= "f0090_rtrg0280",			--体力戻った
	Miller_CuarAdvice			= "f0090_rtrg0300",			--キュア促し
	Miller_EnemyOnHeli			= "f0090_rtrg0200",			--ターゲットをヘリで回収したら
	Miller_BreakSuppressor		= "f0090_rtrg0530",			-- サプレッサーが壊れた
	Miller_HeliNoCall			= "f0090_rtrg0166",			-- ヘリを呼べない
	Miller_CallHeli01			= "f0090_rtrg0170",			--支援ヘリを呼んだ
	Miller_CallHeli02			= "f0090_rtrg0171",			--支援ヘリを呼んだ(ポイント変更)
	Miller_HeliAttack 			= "f0090_rtrg0225",			-- 支援ヘリがプレイヤーから攻撃を受けた
	Miller_HeliLeave 			= "f0090_rtrg0465",			-- 支援ヘリから離れろ促し
	Radio_HostageDead			= "f0090_rtrg0540",			-- 捕虜死亡（プレイヤー）

	Miller_CallHeliHot01		= "e0010_rtrg0376",			--0 支援ヘリ要請時/ホットゾーン
	Miller_CallHeliHot02		= "e0010_rtrg0377",			--0 支援ヘリ要請時/ホットゾーン


}
-- 任意無線
this.OptionalRadioList = {
	-- 無線セット
	OptionalRadioSet_001 	= "Set_e0030_oprg0010",	-- ミッション目的：諜報員と接触しろ
	OptionalRadioSet_002 	= "Set_e0030_oprg0015",	-- ミッション目的：（サーチライト壊れた）
	OptionalRadioSet_003 	= "Set_e0030_oprg0017",	-- ヘリ回収した内通者から情報を聞き出し中

	OptionalRadioSet_101 	= "Set_e0030_oprg0020",	-- カセットを探せ
	OptionalRadioSet_102 	= "Set_e0030_oprg0023",	-- カセットを探せ（罠だと知っている）
	OptionalRadioSet_103 	= "Set_e0030_oprg0027",	-- カセットを探せ（本物はハゲが持っている＆罠だと知っているがカメラだとは知らない）
	OptionalRadioSet_104 	= "Set_e0030_oprg0021",	-- カセットを探せ（カセットBドロップ済みだが未入手）
	OptionalRadioSet_105 	= "Set_e0030_oprg0024",	-- カセットを探せ（罠だと知ってる＆カメラ破壊済み）
	OptionalRadioSet_106 	= "Set_e0030_oprg0026",	-- カセットを探せ（本物はハゲが持っている＆罠だとは知らない）
	OptionalRadioSet_107 	= "Set_e0030_oprg0028",	-- カセットを探せ（本物はハゲが持っている＆罠だと知っていてカメラの存在も知っている）
	OptionalRadioSet_109 	= "Set_e0030_oprg0029",	-- カセットを探せ（罠だと知っている＆ハゲが持っているとは知らない）
	OptionalRadioSet_110 	= "Set_e0030_oprg0022",	-- カセットを探せ（監視カメラのことを知っている）

	OptionalRadioSet_201 	= "Set_e0030_oprg0030",	-- エリアから脱出しろ
	OptionalRadioSet_202 	= "Set_e0030_oprg0033",	-- エリアから脱出しろ（検問がしかれた）
	OptionalRadioSet_203 	= "Set_e0030_oprg0037",	-- 本物をスキンヘッドが持っている（クリアしても良いけどハゲを捜す？）

}

--諜報無線
this.IntelRadioList = {
	-- ミッション固有
	SL_WoodTurret04			= "e0030_esrg0015",		-- 内通者への合図用サーチライトを諜報：そのサーチライトを点ければ･･･
	intel_e0030_rtrg0065	= "f0090_esrg0140",		-- カセットAがある中央管制塔を諜報	（初期状態は「管理棟について」にする）
--	e20030_Betrayer			= "e0030_esrg0020",		-- 内通者を諜報：奴が1人の時に接触しろ
	Cargo_Truck_WEST_001	= "e0030_esrg0042",		-- トラックを諜報：さっきは世話になったな
	Cargo_Truck_WEST_002	= "e0030_esrg0045",		-- トラックを諜報：脱出に使えそう
--	e20030_Mastermind		= "e0030_esrg0090",		-- 反乱兵を諜報：テープを奪った奴じゃないか？
	e20030_SecurityCamera	= "e0030_esrg0100",		-- 中央管制塔に設置された監視カメラを諜報：監視カメラか･･･

	-- その他大勢の敵
	e20030_Betrayer			= "e0030_esrg0080",		-- 内通者を諜報：（ミッション開始時点ではコイツもその他大勢扱い）
	e20030_Mastermind		= "e0030_esrg0080",		-- 反乱兵を諜報：（ミッション開始時点ではコイツもその他大勢扱い）
	e20030_Assistant		= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy002			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy003			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy004			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy005			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy006			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy007			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy008			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_DemoSoldier01	= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_DemoSoldier03	= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy011			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy012			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy013			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy014			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy015			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy016			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy017			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy018			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_DemoSoldier02	= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy020			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_Driver			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy022			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
	e20030_enemy023			= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？
--	e20030_WavDriver		= "e0030_esrg0080",		-- 敵兵を諜報：どいつが諜報員だ？

	-- 捕虜
	Hostage_e20030_000		= "e0030_esrg0110",		-- 捕虜を諜報
	Hostage_e20030_001		= "e0030_esrg0110",		-- 捕虜を諜報
	Hostage_e20030_002		= "e0030_esrg0110",		-- 捕虜を諜報


	-- GZ汎用
	intel_f0090_esrg0110		= "f0090_esrg0110", -- 収容施設
	intel_f0090_esrg0120		= "f0090_esrg0120", -- 難民キャンプ
	intel_f0090_esrg0130		= "f0090_esrg0130", -- 旧収容区画について
	intel_f0090_esrg0140		= "f0090_esrg0140", -- 管理棟
	intel_f0090_esrg0150		= "f0090_esrg0150", -- 運搬用ゲート（GZ)について
	intel_f0090_esrg0190		= "f0090_esrg0190", -- 赤い扉について
	intel_f0090_esrg0200		= "f0090_esrg0200", -- 星条旗について

	SL_WoodTurret01				= "f0090_esrg0010",	-- サーチライトについて
	SL_WoodTurret02				= "f0090_esrg0010",	-- サーチライトについて
	SL_WoodTurret03				= "f0090_esrg0010",	-- サーチライトについて
	SL_WoodTurret05				= "f0090_esrg0010",	-- サーチライトについて
	gntn_area01_searchLight_000	= "f0090_esrg0010",	-- サーチライトについて
	gntn_area01_searchLight_001	= "f0090_esrg0010",	-- サーチライトについて
	gntn_area01_searchLight_002	= "f0090_esrg0010",	-- サーチライトについて
	gntn_area01_searchLight_003	= "f0090_esrg0010",	-- サーチライトについて
	gntn_area01_searchLight_004	= "f0090_esrg0010",	-- サーチライトについて
	gntn_area01_searchLight_005	= "f0090_esrg0010",	-- サーチライトについて

	gntn_area01_antiAirGun_000	= "f0090_esrg0030", -- 対空機関砲について
	gntn_area01_antiAirGun_001	= "f0090_esrg0030", -- 対空機関砲について
	gntn_area01_antiAirGun_002	= "f0090_esrg0030", -- 対空機関砲について
	gntn_area01_antiAirGun_003	= "f0090_esrg0030", -- 対空機関砲について
	Tactical_Vehicle_WEST_001	= "f0090_esrg0040", -- 四輪駆動車について
	Tactical_Vehicle_WEST_002	= "f0090_esrg0040", -- 四輪駆動車について

	APC_Machinegun_WEST_001		= "f0090_esrg0080", -- 機銃装甲車について
	APC_Machinegun_WEST_002		= "f0090_esrg0080", -- 機銃装甲車について

	--監視カメラ
	e20030_SecurityCamera		= "e0030_esrg0100",	-- 中央管制塔のカメラ
	e20030_SecurityCamera_01	= "f0090_esrg0210",
	e20030_SecurityCamera_03	= "f0090_esrg0210",
	e20030_SecurityCamera_04	= "f0090_esrg0210",

	-- ドラム缶について
	gntnCom_drum0002			= "f0090_esrg0180",
	gntnCom_drum0005			= "f0090_esrg0180",
	gntnCom_drum0011			= "f0090_esrg0180",
	gntnCom_drum0012			= "f0090_esrg0180",
	gntnCom_drum0015			= "f0090_esrg0180",
	gntnCom_drum0019			= "f0090_esrg0180",
	gntnCom_drum0020			= "f0090_esrg0180",
	gntnCom_drum0021			= "f0090_esrg0180",
	gntnCom_drum0022			= "f0090_esrg0180",
	gntnCom_drum0023			= "f0090_esrg0180",
	gntnCom_drum0024			= "f0090_esrg0180",
	gntnCom_drum0025			= "f0090_esrg0180",
	gntnCom_drum0027			= "f0090_esrg0180",
	gntnCom_drum0028			= "f0090_esrg0180",
	gntnCom_drum0029			= "f0090_esrg0180",
	gntnCom_drum0030			= "f0090_esrg0180",
	gntnCom_drum0031 			= "f0090_esrg0180",
	gntnCom_drum0035			= "f0090_esrg0180",
	gntnCom_drum0037			= "f0090_esrg0180",
	gntnCom_drum0038			= "f0090_esrg0180",
	gntnCom_drum0039			= "f0090_esrg0180",
	gntnCom_drum0040			= "f0090_esrg0180",
	gntnCom_drum0041			= "f0090_esrg0180",
	gntnCom_drum0042			= "f0090_esrg0180",
	gntnCom_drum0043			= "f0090_esrg0180",
	gntnCom_drum0044			= "f0090_esrg0180",
	gntnCom_drum0045			= "f0090_esrg0180",
	gntnCom_drum0046			= "f0090_esrg0180",
	gntnCom_drum0047			= "f0090_esrg0180",
	gntnCom_drum0048			= "f0090_esrg0180",
	gntnCom_drum0065			= "f0090_esrg0180",
	gntnCom_drum0066			= "f0090_esrg0180",
	gntnCom_drum0068			= "f0090_esrg0180",
	gntnCom_drum0069			= "f0090_esrg0180",
	gntnCom_drum0070			= "f0090_esrg0180",
	gntnCom_drum0071			= "f0090_esrg0180",
	gntnCom_drum0072			= "f0090_esrg0180",
	gntnCom_drum0101			= "f0090_esrg0180",

	--ゲート開閉スイッチ
	intel_f0090_esrg0220		= "f0090_esrg0220",
}

-- 捕虜コンティニュー時の復帰位置管理テーブル
this.ContinueHostageRegisterList = {
	-- ビークル
	CheckList01 = {
		Pos				= "Pos_Tactical_Vehicle_WEST_001",
		VehicleType			= "Vehicle",
		HostageRegisterPoint		= { "Pos_HostageWarpVehicle001_01", "Pos_HostageWarpVehicle001_02", "Pos_HostageWarpVehicle001_03",},
	},
	CheckList02 = {
		Pos				= "Pos_Tactical_Vehicle_WEST_002",
		VehicleType			= "Vehicle",
		HostageRegisterPoint		= { "Pos_HostageWarpVehicle002_01", "Pos_HostageWarpVehicle002_02", "Pos_HostageWarpVehicle002_03",},
	},
	-- 機銃装甲車
	CheckList03 = {
		Pos				= "Pos_APC_Machinegun_WEST_001",
		VehicleType			= "Armored_Vehicle",
		HostageRegisterPoint		= { "Pos_HostageWarpAPC001_01", "Pos_HostageWarpAPC001_02", "Pos_HostageWarpAPC001_03",},
	},
	CheckList04 = {
		Pos				= "Pos_APC_Machinegun_WEST_002",
		VehicleType			= "Armored_Vehicle",
		HostageRegisterPoint		= { "Pos_HostageWarpAPC002_01", "Pos_HostageWarpAPC002_02", "Pos_HostageWarpAPC002_03",},
	},
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■■■ Mission CommonMessage
------------------------------------------------------------------------------------------------------------------------------------------------------------------

this.Messages = {
	Mission = {
		{ message = "MissionFailure", 					localFunc = "commonMissionFailure" },		-- ミッション失敗
		{ message = "MissionClear", 					localFunc = "commonMissionClear" },			-- ミッションクリア
		{ message = "MissionRestart", 					localFunc = "commonMissionCleanUp" },		-- ミッションリスタート（メニュー）
		{ message = "MissionRestartFromCheckPoint", 	localFunc = "commonMissionCleanUp" },		-- ミッションリスタート（チェックポイント）
		{ message = "ReturnTitle", 						localFunc = "commonReturnTitle" },		-- タイトル画面へ（メニュー）
	},
	Trap = {
		--プレイヤーの「現在居るエリア」判定トラップ(RV更新)
		{ data = "Trap_Area_campEast", 			message = { "Enter" }, commonFunc = function() this.commonPlayerAreacampEast() end },
		{ data = "Trap_Area_campWest", 			message = { "Enter" }, commonFunc = function() this.commonPlayerAreacampWest() end },
		{ data = "Trap_Area_ControlTower", 		message = { "Enter" }, commonFunc = function() this.commonPlayerAreaControlTower() end },

		-- 無線コール用に西難民キャンプのみピンポイントで居るかどうかをフラグ管理
		{  data = "WestCamp", 		message = "Enter",		commonFunc = function() TppMission.SetFlag( "isPlayerInWestCamp", true ) end },
		{  data = "WestCamp", 		message = "Exit",		commonFunc = function() TppMission.SetFlag( "isPlayerInWestCamp", false ) end },

		-- ミッション圏外判定トラップ
		{ data = "Trap_WarningMissionArea", message = { "Enter" }, 		commonFunc = function() this.commonOutsideMissionWarningAreaEnter() end },
		{ data = "Trap_WarningMissionArea", message = { "Exit"	}, 		commonFunc = function() this.commonOutsideMissionWarningAreaExit() end },
		{ data = "Trap_EscapeMissionArea",	message = { "Enter" }, 		commonFunc = function() this.commonOutsideMissionArea() end },

		-- 捕虜騒ぎ出すトラップ
		{ data = "Trap_HostageCallHelp",	message = "Enter",			commonFunc = function() this.commonOnPlayerEnterHostageCallTrap("Enter") end },
		{ data = "Trap_HostageCallHelp",	message = "Exit",			commonFunc = function() this.commonOnPlayerEnterHostageCallTrap("Exit") end },
		-- 捕虜エリア侵入トラップ
		{ data = "Trap_EnterHostageArea",	message = "Enter",			commonFunc = function() this.commonOnPlayerEnterHostageAreaTrap() end },
		-- 捕虜担ぎ台詞
		{ data = "Trap_Monologue_Hostage01",	message = "Enter",	commonFunc = function() GZCommon.CallMonologueHostage( "Hostage_e20030_000", "hostage_a", "e20030_trap", "Trap_Monologue_Hostage01" ) end },
		{ data = "Trap_Monologue_Hostage02",	message = "Enter",	commonFunc = function() GZCommon.CallMonologueHostage( "Hostage_e20030_001", "hostage_d", "e20030_trap", "Trap_Monologue_Hostage02" ) end },
		{ data = "Trap_Monologue_Hostage03",	message = "Enter",	commonFunc = function() GZCommon.CallMonologueHostage( "Hostage_e20030_002", "hostage_c", "e20030_trap", "Trap_Monologue_Hostage03" ) end },

		-- 監視カメラデモ発生チェックトラップ
		-- { data = "Trap_SecurityCameraDemo",	message = "Enter",			commonFunc = function() this.commonOnSecurityCameraDemo() end },

		-- 機銃装甲車出現トラップ
		{ data = "Trap_WavActivate",	message = "Enter",		commonFunc = function() this.commonCheckActivateWav() end },
		-- 検問設置チェック
		{ data = "Trap_InspectionInfo", message = "Enter",		commonFunc = function() this.commonCheckInspectionAppearance() end },

	},
	Timer = {
		-- 強制捜索イベント
		{ data = "ForceSerchingTimer", message = "OnEnd", commonFunc = function() this.commonFinishForceSerching() end },

		-- 端末写真確認促し無線再生チェックタイマー
		{ data = "CheckTargetPhotoTimer", message = "OnEnd", commonFunc = function() this.commonCheckTargetPhotoTimer() end },

		-- 内通者拘束チェックタイマー(拘束して判定を行うまでのウェイト)
		{ data = "RestraintCheckTimer", 	message = "OnEnd", commonFunc = function() this.commonBetrayerRestraint() end },
		-- 内通者接触条件チェックタイマー(拘束したら開始、気絶or睡眠or死亡したら停止)
		{ data = "BetrayerContactCheckTimer", message = "OnEnd", commonFunc = function() this.commonBetrayerContactCheck() end },
		-- 内通者尋問判定実行（字幕メッセージと判定タイミングをずらす）
		{ data = "InterrogationTimer", message = "OnEnd", commonFunc = function() this.commonBetrayerInterrogation() end },

		-- 尋問後にミラー台詞
		{ data = "dbg_InterrogationTimer_Betrayer1", 	message = "OnEnd", commonFunc = function() this.commonFinishBetrayerSerif1() end },
		{ data = "dbg_InterrogationTimer_Betrayer2", 	message = "OnEnd", commonFunc = function() this.commonFinishBetrayerSerif2() end },

		-- テープBドロップタイマー
		{ data = "CassetteDropTimer", message = "OnEnd", commonFunc = function() this.CommonDropCassette_B() end },

		-- トラックEnableタイマー
		{ data = "Truck001EnableTimer", message = "OnEnd", commonFunc = function() TppData.Enable( "Cargo_Truck_WEST_001" ) end },
		{ data = "Truck002EnableTimer", message = "OnEnd", commonFunc = function() TppData.Enable( "Cargo_Truck_WEST_002" ) end },

		-- ヘリタイマー
		{ data = "Timer_pleaseLeaveHeli", message = "OnEnd", commonFunc = function() this.commonHeliLeaveJudge() end },

		-- SignalLight用SE
		{ data = "Timer_SignalLightON_01",	message = "OnEnd", commonFunc = function() this.CallSignalLightSE_ON() end },
		{ data = "Timer_SignalLightOFF_01",	message = "OnEnd", commonFunc = function() this.CallSignalLightSE_OFF() end },
		{ data = "Timer_SignalLightON_02",	message = "OnEnd", commonFunc = function() this.CallSignalLightSE_ON() end },
		{ data = "Timer_SignalLightOFF_02",	message = "OnEnd", commonFunc = function() this.CallSignalLightSE_OFF() end },
		{ data = "Timer_SignalLightON_03",	message = "OnEnd", commonFunc = function() this.CallSignalLightSE_ON() end },
		{ data = "Timer_SignalLightOFF_03",	message = "OnEnd", commonFunc = function() this.CallSignalLightSE_OFF() end },
		{ data = "Timer_SignalLightON_04",	message = "OnEnd", commonFunc = function() this.CallSignalLightSE_ON() end },
		{ data = "Timer_SignalLightOFF_04",	message = "OnEnd", commonFunc = function() this.CallSignalLightSE_OFF() end },
		{ data = "Timer_SignalLightON_05",	message = "OnEnd", commonFunc = function() this.CallSignalLightSE_ON() end },
	},
	Character = {
		-- RoutePoint
		-- 取り巻き兵
		{ data = this.AssistantID,		message = "MessageRoutePoint",	commonFunc = function() this.commonBetrayerRoutePoint() end },	-- 取り巻き兵のルート行動監視
		-- 開始デモ兵
		{ data = "e20030_DemoSoldier01",	message = "EnemyArrivedAtRouteNode",	commonFunc = function() this.commonDemoSoldierRoutePoint() end },	-- デモに登場する敵兵
		{ data = "e20030_DemoSoldier02",	message = "EnemyArrivedAtRouteNode",	commonFunc = function() this.commonDemoSoldierRoutePoint() end },	-- デモに登場する敵兵

		-- 内通者
		-- :ルート行動監視
		{ data = this.BetrayerID,	message = "MessageRoutePoint",	commonFunc = function() this.commonBetrayerRoutePoint() end },
		-- :拘束された
		-- { data = this.BetrayerID,	message = "EnemyRestraint",		commonFunc = function() TppTimer.Start( "RestraintCheckTimer", 1.0 ) end },
		{ data = this.BetrayerID,	message = "EnemyRestraint",		commonFunc = function() this.commonBetrayerRestraint() end },
		-- :拘束解除された
		{ data = this.BetrayerID,	message = "EnemyRestraintEnd",	commonFunc = function() this.commonBetrayerRestraintEnd() end },
		-- :尋問された
		-- { data = this.BetrayerID,	message = "EnemyInterrogation",	commonFunc = function() this.commonBetrayerInterrogation() end },
		{ data = this.BetrayerID,	message = "EnemyInterrogation",	commonFunc = function() TppTimer.Start( "InterrogationTimer", 0.5 ) end },	-- 字幕メッセージと判定タイミングをずらすためにタイマー･･･
		-- :死亡した
		{ data = this.BetrayerID,	message = "EnemyDead", 			commonFunc = function() this.commonBetrayerDead() end },
		-- :気絶した
		{ data = this.BetrayerID,	message = "EnemyFaint",			commonFunc = function() this.commonBetrayerFaint() end },
		-- :睡眠した
		{ data = this.BetrayerID,	message = "EnemySleep",			commonFunc = function() this.commonBetrayerSleep() end },
		-- :担がれた
		{ data = this.BetrayerID,	message = "MessageHumanEnemyCarriedStart",	commonFunc = function() this.commonBetrayerCarried() end },

		-- 反乱兵
		-- :尋問された
		{ data = this.MastermindID,	 message = "EnemyInterrogation",	commonFunc = function() this.commonMastermindInterrogation() end },
		-- :死亡した
		{ data = this.MastermindID,	 message = "EnemyDead",				commonFunc = function() this.commonMastermindDead() end },
		-- :拘束解除された
		{ data = this.MastermindID,	 message = "EnemyRestraintEnd",		commonFunc = function() this.commonMastermindRestraintEnd() end },

		-- トラック運転手
		-- :ルート行動監視
		{ data = "e20030_Driver",	message = "EnemyArrivedAtRouteNode",	commonFunc = function() this.commonDriverRoutePoint() end },

		-- 監視カメラ（中央管制塔）
		{ data = "e20030_SecurityCamera",	message = "Dead",	commonFunc = function() this.commonSecurityCameraDead() end },
		{ data = "e20030_SecurityCamera",	message = "Alert",	commonFunc = function() this.commonSecurityCameraAlert() end },

		-- 監視カメラ（諜報無線の制御）
		{ data = "e20030_SecurityCamera_01",	message = "Dead",		commonFunc = function() this.Common_SecurityCameraBroken() end },
		{ data = "e20030_SecurityCamera_03",	message = "Dead",		commonFunc = function() this.Common_SecurityCameraBroken() end },
		{ data = "e20030_SecurityCamera_04",	message = "Dead",		commonFunc = function() this.Common_SecurityCameraBroken() end },
		{ data = "e20030_SecurityCamera",		message = "PowerOFF",	commonFunc = function() this.Common_SecurityCameraPowerOff() end },
		{ data = "e20030_SecurityCamera_01",	message = "PowerOFF",	commonFunc = function() this.Common_SecurityCameraPowerOff() end },
		{ data = "e20030_SecurityCamera_03",	message = "PowerOFF",	commonFunc = function() this.Common_SecurityCameraPowerOff() end },
		{ data = "e20030_SecurityCamera_04",	message = "PowerOFF",	commonFunc = function() this.Common_SecurityCameraPowerOff() end },
		{ data = "e20030_SecurityCamera",		message = "PowerON",	commonFunc = function() this.Common_SecurityCameraPowerOn() end },
		{ data = "e20030_SecurityCamera_01",	message = "PowerON",	commonFunc = function() this.Common_SecurityCameraPowerOn() end },
		{ data = "e20030_SecurityCamera_03",	message = "PowerON",	commonFunc = function() this.Common_SecurityCameraPowerOn() end },
		{ data = "e20030_SecurityCamera_04",	message = "PowerON",	commonFunc = function() this.Common_SecurityCameraPowerOn() end },

		-- 捕虜
		-- :死亡した
		{ data = "Hostage_e20030_000",	message = "Dead",	commonFunc = function() this.commonOnDeadHostage() end	},
		{ data = "Hostage_e20030_001",	message = "Dead",	commonFunc = function() this.commonOnDeadHostage() end	},
		{ data = "Hostage_e20030_002",	message = "Dead",	commonFunc = function() this.commonOnDeadHostage() end	},

		-- CommandPost
		{ data = "gntn_cp",		message = "VehicleMessageRoutePoint",	commonFunc = function() this.commonVehicleRouteUpdate() end },	-- 巡回トラックのルート行動監視
		{ data = "gntn_cp",		message = "EndGroupVehicleRouteMove",	commonFunc = function() this.commonVehicleRouteFinish() end },	-- 巡回トラックのルート行動終了
		{ data = "gntn_cp",		message = "Alert",						commonFunc = function() this.CheckAlertChange() end },			-- Alert開始判定
		{ data = "gntn_cp",		message = "Evasion",					commonFunc = function() this.CheckPhaseChange() end },			-- フェイズ切り替わり時判定
		{ data = "gntn_cp",		message = "Caution",					commonFunc = function() this.CheckPhaseChange() end },			-- フェイズ切り替わり時判定
		{ data = "gntn_cp",		message = "Sneak",						commonFunc = function() this.CheckPhaseChange() end },			-- フェイズ切り替わり時判定
		{ data = "gntn_cp",		message = "ConversationEnd",			commonFunc = function() this.commonConversationEnd() end },		-- 会話イベントが終了した
		{ data = "gntn_cp",		message = "AntiAir",					commonFunc = function() this.ChangeAntiAir() end },				-- 対空行動への切り替え
		{ data = "gntn_cp",		message = "EndRadio"		, 			commonFunc = function() this.EndCPRadio( ) end	},				-- CP無線が終わった
		-- 巨大ゲート
		{ data = "gntn_cp",		message = "VehicleMessageRoutePoint", 	commonFunc = function() GZCommon.Common_CenterBigGateVehicle( ) end  },
		{ data = "gntn_cp",		message = "EndRadio"		, 			commonFunc = function() GZCommon.Common_CenterBigGateVehicleEndCPRadio( ) end  },

		-- Player
		{ data = "Player", 		message = "RideHelicopter", 			commonFunc = function() this.commonPlayerRideHeli() end },		-- ヘリに乗った
		{ data = "Player", 		message = "OnPickUpItem", 				commonFunc = function() this.commonPlayerPickItem() end },		-- アイテムを取得した
		{ data = "Player", 		message = "OnVehicleRideSneak_End", 	commonFunc = function() this.commonPlayerRideOnCargo() end },	-- 荷台に乗り終わった
		{ data = "Player", 		message = "OnVehicleGetOffSneak_Start", commonFunc = function() this.commonPlayerGetOffCargo() end },	-- 荷台から降り始めた
		{ data = "Player",		message = "OnVehicleRide_End",			commonFunc = function() this.commonPlayerRideOnVehicle() end },	--　車両に乗った
		{ data = "Player",		message = "NotifyStartWarningFlare",	commonFunc = function() this.MbDvcActCallRescueHeli("SupportHelicopter", "flare") end },	--　フレアグレネードを使った
		{ data = "Player",		message = "TryPicking",					commonFunc = function() this.commonOnPickingDoor() end },		-- プレイヤーがピッキングドアを開けようとした

		-- 支援ヘリ
		{ data = "SupportHelicopter",	message = "ArriveToLandingZone",	commonFunc = function() this.commonHeliArrive() end },				--ヘリがＲＶに到着
		{ data = "SupportHelicopter",	message = "DepartureToMotherBase",	commonFunc = function() this.commonHeliTakeOff() end  },			-- 離陸開始した
		{ data = "SupportHelicopter",	message = "Dead",					commonFunc = function() this.commonHeliDead() end  },				-- 撃墜された
		{ data = "SupportHelicopter",	message = "DamagedByPlayer",		commonFunc = function() this.commonHeliDamagedByPlayer() end },		-- プレイヤーから攻撃を受けた

		-- 機銃装甲車
		{ data = "APC_Machinegun_WEST_002",		message = "StrykerDestroyed",	commonFunc = function() TppMission.SetFlag( "isWavBroken", true ) end },

		-- 捕虜
		{ data = "Hostage_e20030_000",	message = "HostageLaidOnVehicle",	commonFunc = function() this.commonHostageLaidOn() end	},	-- 乗り物に乗せられた
		{ data = "Hostage_e20030_001",	message = "HostageLaidOnVehicle",	commonFunc = function() this.commonHostageLaidOn() end	},	-- 乗り物に乗せられた
		{ data = "Hostage_e20030_002",	message = "HostageLaidOnVehicle",	commonFunc = function() this.commonHostageLaidOn() end	},	-- 乗り物に乗せられた
	},
	Enemy = {
		-- 乗り物に乗せられた
		{ message = "HostageLaidOnVehicle",			commonFunc = function() this.commonOnLaidEnemy() end  },
	},
	Myself = {
		{ data = this.BetrayerID,		message = "LookingTarget",		commonFunc = function() this.commonMissionTargetMarkingCheck() end },
		{ data = this.MastermindID,		message = "LookingTarget",		commonFunc = function() this.commonMissionTargetMarkingCheck() end },
	},
	Gimmick = {
		--壊れやぐら
		{ data = "WoodTurret03", 	message = "BreakGimmick", commonFunc = function() this.commonWoodTurret03Break() end },	--東難民キャンプのヤグラ破壊時
		{ data = "WoodTurret04", 	message = "BreakGimmick", commonFunc = function() this.commonWoodTurret04Break() end },	--西難民キャンプのヤグラ破壊時
		-- サーチライト
		{ data = "SL_WoodTurret04", message = "BreakGimmick", commonFunc = function() this.commonWoodTurret04Break() end },	--西難民キャンプのヤグラのサーチライト破壊時
		{ data = "SL_WoodTurret04", message = "RideEmplacement", commonFunc = function() this.commonUseSignalLight() end },	--西難民キャンプのヤグラのサーチライト使用時
		-- 配電盤
		{ data = "gntn_center_SwitchLight", message = "SwitchOn", commonFunc = function() this.SwitchLight_ON() end },	--管理棟配電盤ＯＮ
		{ data = "gntn_center_SwitchLight", message = "SwitchOff", commonFunc = function() this.SwitchLight_OFF() end },	--管理棟配電盤ＯＦＦ
	},
	Radio = {
		-- 諜報対象を双眼鏡で捉えた
		--{ message = "EspionageRadioCandidate" , commonFunc = function() this.commonWatchingBetrayer() end },
		-- 中央管制塔監視カメラへの諜報無線実行
		{ data = "e20030_SecurityCamera", message = "EspionageRadioPlayButton" , commonFunc = function() this.IntelRadioPlayCameraTrap() end },
		-- ヘリから離れろって促すのを延長
		{ data = "f0090_rtrg0130",		message = "RadioEventMessage", commonFunc = function() this.commonHeliLeaveExtension() end },
		{ data = "f0090_rtrg0200",		message = "RadioEventMessage", commonFunc = function() this.commonHeliLeaveExtension() end },
		{ data = "f0090_rtrg0210",		message = "RadioEventMessage", commonFunc = function() this.commonHeliLeaveExtension() end },
	},
	RadioCondition = {
--		{ message = "PlayerLifeLessThanHalf", 	commonFunc = function() TppRadio.Play( "Miller_SpRecoveryLifeAdvice" ) end },
		{ message = "PlayerHurt", 				commonFunc = function() TppRadio.Play( "Miller_CuarAdvice" ) end },
		{ message = "PlayerCureComplete", 		commonFunc = function() TppRadio.Play( "Miller_SpRecoveryLifeAdvice" ) end },
		{ message = "SuppressorIsBroken", 		commonFunc = function() this.commonSuppressorIsBroken() end },
	},
	Subtitles = {
		-- ミラー無線：「｛目標→ターゲット｝を特定したら、近付いて拘束してくれ。それが接触の合図だ。周囲に他の敵がいない時を狙え。」
		{ data="intl3000_1k1010", message = "SubtitlesEventMessage", commonFunc = function() this.commonShowTutorial_CQC() end },
		-- ミラー無線：「｛目標→ターゲット｝を見つけたら、近付いて『拘束』してくれ。それが接触の合図になる」
		{ data="intl0z00_111012", message = "SubtitlesEventMessage", commonFunc = function() this.commonShowTutorial_CQC() end },

		-- 内通者尋問台詞A：「やめてくれ。他の兵士に怪しまれる」
		{ data="sltb0z00_1y1010", message = "SubtitlesEventMessage", commonFunc = function() this.commonSubtitles_BetrayerSerifA() end },
		-- 内通者尋問台詞B：「ひ･･･すまない・連中にバレて脅されたんだ」
		{ data="sltb0z00_1y1210", message = "SubtitlesEventMessage", commonFunc = function() this.commonSubtitles_BetrayerSerifB() end },
		-- 内通者尋問台詞C：「テープも奪われた。スキンヘッドの兵士だ」
		{ data="sltb0z00_1y1310", message = "SubtitlesEventMessage", commonFunc = function() this.commonSubtitles_BetrayerSerifC() end },
		-- 内通者尋問台詞D：「許してくれ。家族が居る。人質に取られているんだ」
		{ data="sltb0z00_1y1410", message = "SubtitlesEventMessage", commonFunc = function() this.commonSubtitles_BetrayerSerifD() end },

		-- 反乱兵尋問台詞A：「くっ・・・このテープが欲しいのか」
		{ data="sltb0z00_1y1510", message = "SubtitlesEventMessage", commonFunc = function() this.commonSubtitles_DropTapeB() end },
		-- 反乱兵尋問台詞B：「もう遅い。計画は止まらん。俺たちは国家を超える」
		{ data="sltb0z00_1y1610", message = "SubtitlesEventMessage", commonFunc = function() this.commonSubtitles_Rebellion() end },

		-- 内通者会話台詞：「接触してきた男を中央管制塔に誘導した」
		{ data="sltb0z00_291010", message = "SubtitlesEventMessage", commonFunc = function() this.commonSubtitles_TrapA() end },
		-- 内通者会話台詞：「こっちも準備は完了･･･後はあの『ボス』が監視に引っかかるのを･･･」
		{ data="sltb0z00_2a1010", message = "SubtitlesEventMessage", commonFunc = function() this.commonSubtitles_TrapB() end },
	},
	UI = {
		-- カセットテープを聞き終えた
		{ message = "StopWalkMan" , commonFunc = function() this.commonStopWalkMan() end },
	},
	Terminal = {
		-- MB端末上でマップアイコンにフォーカスした
		{ message = "MbDvcActFocusMapIcon",	commonFunc = function() this.commonFocusMapIcon() end },
		{ message = "MbDvcActCallRescueHeli", commonFunc = function() this.MbDvcActCallRescueHeli("SupportHelicopter", "MbDvc") end  },    --支援ヘリ要請
	},
	Marker = {
		{	message = "ChangeToEnable",	commonFunc = function() this.commonMarkerEnable() end },	-- マーカーが付いた
	},
	Demo = {
		{ data="p11_020003_000", message="invis_cam",	commonFunc = function() TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20030_SecurityCamera_04", false ) end },
		{ data="p11_020003_000", message="lightOff", commonFunc = function() TppGadgetUtility.SetSwitch("gntn_center_SwitchLight",false) end },
		{ data="p11_020003_000", message="lightOn", commonFunc = function() TppGadgetUtility.SetSwitch("gntn_center_SwitchLight",true) end },
		{ data="p11_020003_000", message="under", commonFunc = function() TppWeatherManager:GetInstance():RequestTag("under", 0 ) end },
		{ data="p11_020003_000", message="default", commonFunc = function() TppWeatherManager:GetInstance():RequestTag("default", 0 ) end },
	},
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■■■ SetUp Functions
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■ onMissionPrepare
this.onMissionPrepare = function( manager )

	Fox.Log("************* onMissionPrepare ***************")

	local sequence = TppSequence.GetCurrentSequence()

	-- ミッション開始時orデバッグメニューからスキップ開始してきた場合のみ
	if ( sequence == "Seq_MissionPrepare" or manager:IsStartingFromResearvedForDebug() ) then
		-- HardModeかどうかで初期武器設定が変わる
		local hardmode = TppGameSequence.GetGameFlag("hardmode")
		if ( hardmode ) then
			TppPlayer.SetWeapons( GZWeapon.e20030_SetWeaponsHard )
		else
			TppPlayer.SetWeapons( GZWeapon.e20030_SetWeapons )
		end
	end

	if( TppSequence.IsGreaterThan( sequence, "Seq_TruckInfiltration" ) ) then

		-- 荷台上に居ないフラグを立てておく
		this.CounterList.PlayerOnCargo = "NoRide"
	else
		-- まだ基地内に侵入していなければ基地外のトラック荷台からスタート

		-- プレイヤーの初期状態を設定：トラックの荷台から開始
		TppPlayerUtility.SetActionStatusOnStartMission( "ACTION_STATUS_RIDE_ON_DECK" )
		TppPlayerUtility.SetPairCharacterIdOnStartMission( "Cargo_Truck_WEST_001" )		-- 西検問側

		-- 荷台上に居るフラグを立てておく
		this.CounterList.PlayerOnCargo = "Cargo_Truck_WEST_001"

		-- プレイヤーの所属エリア名を「西難民キャンプ」で登録しておく（保険処理）
		GZCommon.PlayerAreaName = "WestCamp"

	end

	-- 難易度別にこれまでの戦績に応じて報酬アイテムを設置（e20030はSランクのみ）
	this.tmpBestRank = this.CheckClearRankReward()
	Fox.Log("***e20030.tmpBestRank_IS___"..this.tmpBestRank)

	-- この回のプレイで未取得ならテープを持っていない設定にする
	local uiCommonData = UiCommonDataManager.GetInstance()
	if ( TppMission.GetFlag("isGetCassette_A") == false ) then
		uiCommonData:HideCassetteTape( this.CassetteA )
	end
	if ( TppMission.GetFlag("isGetCassette_B") == false ) then
		uiCommonData:HideCassetteTape( this.CassetteB )
	end

end

----------------------------------------
-- ■ CheckClearRankReward
-- 難易度別にこれまでの戦績に応じて報酬アイテムを設置する
this.CheckClearRankReward = function()

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
		-- RankS
		-- 輸送トラックにグレネーダー付きライフルを配置
		TppNewCollectibleUtility.PutCollectibleOnCharacter{ id = "WP_ar00_v05", count = 240, countSub = 15, target = "Cargo_Truck_WEST_001" , attachPoint = "CNP_USERITEM" }
		return BestRank
	else
		return 2
	end



end
---------------------------------------------------------------------------------
-- ■ onCommonMissionSetup
local onCommonMissionSetup = function()
	Fox.Log("************* onCommonMissionSetup ***************")

	GZCommon.MissionSetup()	-- GZ共通ミッションセットアップ

	-- 時間、天候は固定
	TppClock.SetTime( "18:00:00" )
	TppClock.Stop()
	TppWeather.SetWeather( "sunny" )
	WeatherManager.RequestTag("default", 0 )
	GrTools.SetLightingColorScale(4.0)	-- マッハバンド軽減対応

	TppEffectUtility.RemoveColorCorrectionLut()

	-- テクスチャロード待ち処理
	MissionManager.SetMiddleTextureWaitParameter( 0.5, 5 )

	-- 保存したくないミッションフラグを初期化
	this.commonMissionFlagRestore()

	-- 重要キャラをVip登録
	MissionManager.RegisterVipMember( "e20030_UniqueChara", this.BetrayerID, 	"espionage", 0 )	-- 内通者
	MissionManager.RegisterVipMember( "e20030_UniqueChara", this.MastermindID, 	"espionage", 1 )	-- 反乱兵
	MissionManager.RegisterVipMember( "e20030_UniqueChara", this.AssistantID, 	"espionage", 2 )	-- 内通者の取り巻き兵

	-- ヘリ回収時に汎用アナウンスログを出さないユニーク兵を登録
	GZCommon.EnemyLaidonHeliNoAnnounceSet( this.BetrayerID )
	GZCommon.EnemyLaidonHeliNoAnnounceSet( this.MastermindID )

	-- ユニークキャラは再発生しないようにする
	TppCommandPostObject.GsSetDisableRespawn( "gntn_cp", this.BetrayerID )
	TppCommandPostObject.GsSetDisableRespawn( "gntn_cp", this.MastermindID )

	-- パス檻のドアを開けておく
	TppGimmick.OpenDoor( "Paz_PickingDoor00", 270 )

	-- 増援発生時の武器設定
	TppCommandPostObject.GsAddRespawnRandomWeaponId( "gntn_cp", "WP_sg01_v00", 30 )		-- 30%でショットガン
	TppCommandPostObject.GsAddRespawnRandomWeaponId( "gntn_cp", "WP_ms02", 10 )			-- 10%で無反動砲

	-- ミッション開始時は検問のガードターゲット無効化
	TppCommandPostObject.GsSetGuardTargetValidity( "gntn_cp", "TppGuardTargetData_InspectionNorth", false )
	TppCommandPostObject.GsSetGuardTargetValidity( "gntn_cp", "TppGuardTargetData_InspectionWest", false )

	-- ミッション説明を一応リセットしておく
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager ~= NULL then
		local luaData = commonDataManager:GetUiLuaExportCommonData()
		if luaData ~= NULL then
			luaData:ResetMisionInfoCurrentStoryNo() -- ストーリー番号を0に戻す
		end
	end

	-- 保持すべきリアルタイム無線のフラグを保持
	TppRadio.SetAllSaveRadioId()

end
---------------------------------------------------------------------------------
-- ■ commonUiMissionPhotoSetup
-- ミッション写真有効化設定
local commonUiMissionPhotoSetup = function()

	Fox.Log(":::::::commonUiMissionPhotoSetup:::::::")
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end
	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end
	luaData:EnableMissionPhotoId(10)						-- 指定したIDのミッション写真を有効化する
	luaData:SetAdditonalMissionPhotoId(10, true, false)		-- 10番の写真で,付加写真1を使用する,付加写真2は使用しない

end
---------------------------------------------------------------------------------
-- ■ commonMissionSubGoalSetting
-- ミッション中間目標の設定
local commonMissionSubGoalSetting = function( GoalNum )

	Fox.Log(":::::::commonMissionSubGoalSetting:::::::")

	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
		return
	end

	local luaData = commonDataManager:GetUiLuaExportCommonData()

	if luaData == NULL then
		return
	end

	luaData:SetCurrentMissionSubGoalNo( GoalNum ) -- 中目標番号をその値に設定する

end
---------------------------------------------------------------------------------
-- ■ commonMarkerMissionSetup
-- マーカーの各種設定
local commonMarkerMissionSetup = function()

	Fox.Log(":::::::commonMarkerMissionSetup:::::::")

	----- 端末上のアイコンにカーソルがあったら出る説明分文を設定する -----
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
		return
	end

	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
		return
	end

	luaData:SetupIconUniqueInformationTable(
		-- ミッション固有
--		{ markerId= this.BetrayerID, 				langId="marker_info_agent" },
		{ markerId= "e20030_marker_Cassette", 		langId="marker_info_item_tape" },
		{ markerId= "e20030_marker_Signal", 		langId="marker_info_place_04" },			-- サーチライト
--		{ markerId= "TppMarkerLocator_EscapeWest", 	langId="marker_info_place_02" },
--		{ markerId= "TppMarkerLocator_EscapeNorth", langId="marker_info_place_02" },

		-- 車両
		{ markerId= "Tactical_Vehicle_WEST_001", 		langId="marker_info_vehicle_4wd" },
		{ markerId= "Tactical_Vehicle_WEST_002", 		langId="marker_info_vehicle_4wd" },
		{ markerId= "APC_Machinegun_WEST_001", 			langId="marker_info_APC" },
		{ markerId= "APC_Machinegun_WEST_002", 			langId="marker_info_APC" },
		{ markerId= "Cargo_Truck_WEST_001", 			langId="marker_info_truck" },
		{ markerId= "Cargo_Truck_WEST_002", 			langId="marker_info_truck" },

		-- 尋問用：汎用アイテム類
		{ markerId= "e20030_marker_Ammo001", 				langId="marker_info_bullet_tranq" },		-- 非殺傷弾
		{ markerId= "e20030_marker_Ammo002", 				langId="marker_info_bullet_tranq" },		-- 非殺傷弾
		{ markerId= "e20030_marker_Ammo003", 				langId="marker_info_bullet_tranq" },		-- 非殺傷弾
		{ markerId= "e20030_marker_C4_01", 					langId="marker_info_weapon_06" },
		{ markerId= "e20030_marker_C4_02", 					langId="marker_info_weapon_06" },
		{ markerId= "e20030_marker_Dmines", 				langId="marker_info_weapon_08" },
		{ markerId= "e20030_marker_Grenade", 				langId="marker_info_weapon_07" },
		{ markerId= "e20030_marker_HandGun_01", 			langId="marker_info_weapon_00" },
		{ markerId= "e20030_marker_HandGun_02", 			langId="marker_info_weapon_00" },
		{ markerId= "e20030_marker_MonlethalWeapon", 		langId="marker_info_weapon" },
		{ markerId= "e20030_marker_RecoillessRifle", 		langId="marker_info_weapon_02" },
		{ markerId= "e20030_marker_SmokeGrenade01", 		langId="marker_info_weapon_05" },
		{ markerId= "e20030_marker_SniperRifle", 			langId="marker_info_weapon_01" },
		{ markerId= "e20030_marker_SubAmmo01", 				langId="marker_info_bullet_artillery" },	-- 非殺傷弾
		{ markerId= "e20030_marker_SubAmmo02", 				langId="marker_info_bullet_tranq" },		-- 砲弾
		{ markerId= "e20030_marker_SubmachineGun", 			langId="marker_info_weapon_04" },
		{ markerId= "e20030_marker_Weapon", 				langId="marker_info_weapon" },
		{ markerId= "e20030_marker_ShotGun", 				langId="marker_info_weapon_03" },

		-- 尋問用：エリア
		{ markerId = "common_marker_Area_Asylum", 			langId = "marker_info_area_05" },				-- 旧収容施設
		{ markerId = "common_marker_Area_EastCamp", 		langId = "marker_info_area_00" },				-- 東難民キャンプ
		{ markerId = "common_marker_Area_WestCamp", 		langId = "marker_info_area_01" },				-- 西難民キャンプ
		{ markerId = "common_marker_Area_Center", 			langId = "marker_info_area_04" },				-- 管理棟
		{ markerId = "common_marker_Area_HeliPort", 		langId = "marker_info_area_03" },				-- ヘリポート
		{ markerId = "common_marker_Area_WareHouse", 		langId = "marker_info_area_02" },				-- 倉庫

		-- 場所名
		{ markerId= "common_marker_Armory_Center", 			langId="marker_info_place_armory" },		-- 武器庫
		{ markerId= "common_marker_Armory_HeliPort", 		langId="marker_info_place_armory" },		-- 武器庫
		{ markerId= "common_marker_Armory_WareHouse", 		langId="marker_info_place_armory" }			-- 武器庫
	)

	----- ミッション固有のマーカーを全て初期化 -----
	TppMarker.Disable( "e20030_marker_Signal" )				-- 合図ポイント
	-- TppMarker.Disable( this.BetrayerID )					-- 内通者
	TppMarker.Disable( "e20030_marker_Cassette" )			-- カセットテープ
	TppMarker.Disable( "TppMarkerLocator_EscapeWest" )		-- 脱出地点：西
	TppMarker.Disable( "TppMarkerLocator_EscapeNorth" )		-- 脱出地点：北

end

---------------------------------------------------------------------------------
-- ■ commonDemoBlockSetup
-- デモブロックのセットアップ
local commonDemoBlockSetup = function()

	-- デモブロックのロード
	local demoBlockPath = "/Assets/tpp/pack/mission/extra/e20030/e20030_d01.fpk"
	TppMission.LoadDemoBlock( demoBlockPath )
	TppMission.LoadEventBlock("/Assets/tpp/pack/location/gntn/gntn_heli.fpk" )
end
---------------------------------------------------------------------------------
-- ■ commonRouteSetMissionSetup
-- ルートセットの初期化
local commonRouteSetMissionSetup = function( currentRouteSet )

	Fox.Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!commonRouteSetMissionSetup!!!!!!!!!!!!!!!!!!!!!!!!!!!")

	-- ルートセットの登録
	TppEnemy.RegisterRouteSet( "gntn_cp", "sneak_day", 		"e20030_routeSet_d01_basic01" )
	TppEnemy.RegisterRouteSet( "gntn_cp", "sneak_night", 	"e20030_routeSet_d01_basic02" )
	TppEnemy.RegisterRouteSet( "gntn_cp", "caution_day", 	"e20030_routeSet_c01_basic01" )
	TppEnemy.RegisterRouteSet( "gntn_cp", "caution_night", 	"e20030_routeSet_c01_serching01" )
	TppEnemy.RegisterRouteSet( "gntn_cp", "hold", 			"gntn_common_routeSet_r01_controlTower" )	-- 交代行動はないので使用しない

	-- 現在のRouteSetを明示的に登録する。Cautionからのコンティニュー復帰時を考慮してワープ指定
--	TppEnemy.ChangeRouteSet( "gntn_cp", currentRouteSet, { warpEnemy = true } )
--	TppCommandPostObject.GsSetCurrentRouteSet( commandPost, routeSet, isForceUpdate, isResetAll, isZeroNode, isResetPosition )
	TppCommandPostObject.GsSetCurrentRouteSet( "gntn_cp", currentRouteSet, true, true, true, true )
	TppCharacterUtility.ResetPhase()	-- ワープ指定するときは敵のファイズもリセット


	-- ユニークキャラ専用のルートは使用禁止登録（将来的にはDisableではなく「ユニークキャラ用登録」のような方式になる予定）
	this.commonBetrayerRouteDisable()
	this.commonAssistantrRouteDisable()

	-- 反乱兵会話イベント用のルートを使用禁止
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_mst_route0000" )

	-- 車両搭乗用の排他ルートも使用禁止にしておく
	TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0028" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0030" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0128" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0032" )	-- 検問設置イベント後の検問前哨戒ルート
	TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0033" )	-- 検問設置イベント後の検問前哨戒ルート

	-- デモ登場兵が後で乗る予定のルートは使用禁止
	TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0010" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0011" )

	-- 管理棟巨大ゲート車両セットアップ（ミッション初回は乗り込み状態の車両連携データを指定する）
	GZCommon.Common_CenterBigGateVehicleSetup( "gntn_cp", "VehicleDefaultRideRouteInfo_e20030",
														  "gntn_common_v01_route0010", -- 開錠前のルート
														  "gntn_common_v01_route0011", -- 開錠後のルート
														  17, "NotClose" )	-- ゲート開錠ノード番号、閉鎖ノード番号（閉じないので文字列を渡す）

end
---------------------------------------------------------------------------------
-- ■ commonUniqueCharaRouteSetup
-- ユニークキャラ用のルートセット初期化
local commonUniqueCharaRouteSetup = function()

	Fox.Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!commonUniqueCharaRouteSetup!!!!!!!!!!!!!!!!!!!!!!!!!!!")

	-- 初期状態でユニークキャラが使用するルートは使用許可
	TppEnemy.EnableRoute( "gntn_cp", "gntn_e20030_tgt_route0001" )
	TppEnemy.EnableRoute( "gntn_cp", "gntn_e20030_ast_route0000" )

	-- 内通者と取り巻き兵に専用ルートを割り当て
	TppEnemy.ChangeRoute( "gntn_cp", this.BetrayerID, 	"e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route0001", 6 )		-- まずは東側キャンプエリアを回るルートを設定
	TppEnemy.ChangeRoute( "gntn_cp", this.AssistantID, 	"e20030_routeSet_d01_basic01", "gntn_e20030_ast_route0000", 58 )		-- こいつはエリア全域を回るルートを設定してみる

	-- 内通者は優先Realize指定
	TppCommandPostObject.GsSetRealizeFirstPriority( "gntn_cp", this.BetrayerID, true )

--	this.commonBetrayerRoutecampEast()	-- 内通者の使用ルート管理フラグを初期状態にしておく

end
---------------------------------------------------------------------------------
-- Demo&EventBlockのLoad完了確認
local IsDemoAndEventBlockActive = function()
	if ( TppMission.IsDemoBlockActive() == false ) then
		return false
	end
	if ( TppMission.IsEventBlockActive() == false ) then
		return false
	end
	if ( TppVehicleBlockControllerService.IsHeliBlockExist() ) then
		-- HeliBlockあり
		if ( TppVehicleBlockControllerService.IsHeliBlockActivated() == false ) then
			return false
		end
	end
	if ( MissionManager.IsMissionStartMiddleTextureLoaded() == false ) then
					return false
	end
	-- ローディングTipsの終了を待つ
	local hudCommonData = HudCommonDataManager.GetInstance()
	if hudCommonData:IsEndLoadingTips() == false then
		hudCommonData:PermitEndLoadingTips() -- 終了許可（決定ボタンを押したら消える）
		-- 決定ボタン押されるのを待っています
		return false
	end
	-- 決定ボタン押されたらここに到達します
	return true
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■■■ Mission Functions
------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- ■■ System Functions
---------------------------------------------------------------------------------
-- ■ commonMissionFailure
-- ミッション失敗時判定
this.commonMissionFailure = function( manager, messageId, message )
	Fox.Log("!!!!!commonMissionFailure!!!!!commonMissionFailure")
	-- ミッション失敗原因に応じて分岐させてそれぞれ演出処理を行う

	local hudCommonData = HudCommonDataManager.GetInstance()
	local radioDaemon = RadioDaemon:GetInstance()

	-- 再生中の無線停止
	radioDaemon:StopDirectNoEndMessage()
	-- 字幕の停止
	SubtitlesCommand.StopAll()

	-- CP無線をフェードアウトしつつ全停止
	TppEnemyUtility.IgnoreCpRadioCall(true)	-- 以降の新規無線コールを止める
	TppEnemyUtility.StopAllCpRadio( 0.5 )	-- フェード時間

	-- BGMフェードアウト
	TppSoundDaemon.SetMute( 'GameOver' )

	-- ミッション失敗フェード開始時間を汎用値で初期化しておく（Continue対策）
	this.CounterList.GameOverFadeTime = GZCommon.FadeOutTime_MissionFailed

	-- 接触デモ以前に内通者が死亡した
	if( message == "Betrayer_Dead" )  then
		Fox.Log("!!!!!Betrayer_Dead!!!!!")

		GZCommon.PlayCameraAnimationOnChicoPazDead(this.BetrayerID)

		-- 内通者死亡時の無線名を登録しておく
		this.CounterList.GameOverRadioName = "Radio_DeadBetrayer_BeforeDemo"

		hudCommonData:CallFailedTelop( "gameover_reason_target_died" )	-- 失敗理由テロップ表示

	-- カセット入手以前にミッション圏外に出た
	elseif( message == "OutsideMissionArea" )  then
		Fox.Log("!!!!!OutsideMissionArea!!!!!")

		-- トラック荷台に乗っているなら車両の強制移動演出を指定
		if ( this.CounterList.PlayerOnCargo ~= "NoRide" ) then

			-- 敵の運転するトラックの荷台にいる
			GZCommon.OutsideAreaCamera_Vehicle( this.CounterList.PlayerOnCargo, "Player" )
		else
			-- 徒歩または車両を運転している
			GZCommon.OutsideAreaCamera()
		end

		-- ミッション圏外離脱時の無線名を登録しておく
		this.CounterList.GameOverRadioName = "Radio_MissionArea_Failed"

		hudCommonData:CallFailedTelop( "gameover_reason_mission_outside" )	-- 失敗理由テロップ表示

	-- プレイヤーが死亡した
	elseif( message == "PlayerDead" )	then
		Fox.Log("!!!!!PlayerDefeated!!!!!")

		-- プレイヤー死亡時無線名を登録しておく
		this.CounterList.GameOverRadioName = "Radio_DeadPlayer"

	-- プレイヤーが落下死亡した
	elseif( message == "PlayerFallDead" )	then
		Fox.Log("!!!!!PlayerFallDead!!!!!")

		-- プレイヤー死亡時無線名を登録しておく
		this.CounterList.GameOverRadioName = "Radio_DeadPlayer"

		-- 落下死亡時はフェード開始時間を変更
		this.CounterList.GameOverFadeTime = GZCommon.FadeOutTime_PlayerFallDead

	-- ヘリに乗って離脱した
	elseif( message == "RideHeli_Failed" )	then
		Fox.Log("!!!!!RideHeli_Failed!!!!!")

		-- ヘリ離脱失敗無線名を登録しておく
		this.CounterList.GameOverRadioName = "Radio_RideHeli_Failed"

		hudCommonData:CallFailedTelop( "gameover_reason_mission_abort" )	-- 失敗理由テロップ表示

	-- プレイヤーが乗った状態のヘリが撃墜された
	elseif ( message == "PlayerDeadOnHeli" ) then
		Fox.Log("!!!!!PlayerDeadOnHeli!!!!!")

		-- ゲームオーバー無線はとりあえず通常のプレイヤー死亡と同じものを登録
		this.CounterList.GameOverRadioName = "Radio_DeadPlayer"

	end

	-- ミッション失敗シーケンスへ
	TppSequence.ChangeSequence( "Seq_MissionFailed" )

end
---------------------------------------------------------------------------------
-- ■ commonMissionClearRequest
-- ミッションクリア要求
this.commonMissionClearRequest = function( clearType )
	Fox.Log("!!!!!commonMissionClearRequest!!!!!")
	-- クリア要求前にスコア計算テーブルを設定しておく必要があるのでここでまとめる

	-- スコア計算テーブルの設定
	GZCommon.ScoreRankTableSetup( this.missionID )

	-- MissionManagerにクリアリクエストを送る
	TppMission.ChangeState( "clear", clearType )

end
---------------------------------------------------------------------------------
-- ■ commonMissionClear
-- ミッションクリア時判定
this.commonMissionClear = function( manager, messageId, message )
	Fox.Log("!!!!!commonMissionClear!!!!!")
	-- ミッションクリア方法に応じて分岐させてそれぞれ演出処理を行う

	local radioDaemon = RadioDaemon:GetInstance()

	-- 再生中の無線停止
	radioDaemon:StopDirectNoEndMessage()
	-- 字幕の停止
	SubtitlesCommand.StopAll()

	-- CP無線をフェードアウトしつつ全停止
	TppEnemyUtility.IgnoreCpRadioCall(true)	-- 以降の新規無線コールを止める
	TppEnemyUtility.StopAllCpRadio( 0.5 )	-- フェード時間

	-- 実績解除：「サイドオプスを1つクリア」
	Trophy.TrophyUnlock( this.TrophyId_GZ_SideOpsClear )

	-- ヘリに乗って離脱した
	if( message == "RideHeli_Clear" )  then
		Fox.Log("!!!!!RideHeli_Clear!!!!!")

		-- ミッションクリアシーケンスへ
		TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" )

	-- 地上の検問を抜けて離脱した
	elseif( message == "EscapeArea_Clear" )  then
		Fox.Log("!!!!!EscapeArea_Clear!!!!!")

		-------- 終了演出：車両に乗っているかで演出が変わる --------

		-- トラック荷台に乗っているなら車両の強制移動演出を指定
		if ( this.CounterList.PlayerOnCargo ~= "NoRide" ) then

			-- 敵の運転するトラックの荷台にいる
			GZCommon.OutsideAreaCamera_Vehicle( this.CounterList.PlayerOnCargo, "Player" )
		else
			-- 徒歩または車両を運転している
			GZCommon.OutsideAreaCamera()
		end

		-- 地上クリアシーケンスへ
		TppSequence.ChangeSequence( "Seq_PlayerEscapeMissionArea" )

	end

end
---------------------------------------------------------------------------------
-- ■ OnClosePopupWindow
-- ポップアップクローズ時の判定（今のところ報酬表示ポップアップ用）
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
---------------------------------------------------------------------------------
-- ■ OnShowRewardPopupWindow
-- 報酬ポップアップの表示
this.OnShowRewardPopupWindow = function()

	Fox.Log("-------OnShowRewardPopupWindow--------")

	-- チャレンジ要素によってアンロックされた報酬表示
	local hudCommonData = HudCommonDataManager.GetInstance()
	local challengeString = PlayRecord.GetOpenChallenge()
	local uiCommonData = UiCommonDataManager.GetInstance()
	local AllHardClear = PlayRecord.IsAllMissionClearHard()
	local AllChicoTape = GZCommon.CheckReward_AllChicoTape()
	local Rank = PlayRecord.GetRank()
	Fox.Log("-------RANK_IS__"..Rank.."__BESTRANK_IS__"..this.tmpBestRank )
	Fox.Log("-------challengeString:::"..challengeString)

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

		hudCommonData:ShowBonusPopupItem( "reward_clear_s_rifle", "WP_ar00_v05", { isBarrel=true } )
	end

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

	-- ハードモード開放
	if	TppGameSequence.GetGameFlag("hardmode") == false and					-- ノーマルクリアかつ
		PlayRecord.GetMissionScore( 20030, "NORMAL", "CLEAR_COUNT" ) == 1 then	-- 初回クリアなら

		hudCommonData:ShowBonusPopupCommon( "reward_extreme" )						-- ハード解放

	end

	-- いずれのポップアップも呼ばれなかったら即座に次シーケンスへ
	if ( hudCommonData:IsShowBonusPopup() == false ) then
		Fox.Log("-------OnShowRewardPopupWindow:NoPopup!!-------")
		TppSequence.ChangeSequence( "Seq_MissionEnd" )	-- ST_CLEARから先に進ませるために次シーケンスへ
	end
end
---------------------------------------------------------------------------------
-- ■ commonMissionCleanUp
-- ミッション後片付け
this.commonMissionCleanUp = function()
	Fox.Log("!!!!!commonMissionCleanUp!!!!!commonMissionCleanUp")

	-- ミッション共通後片付け
	GZCommon.MissionCleanup()

	-- 保存したくないミッションフラグを初期化
	this.commonMissionFlagRestore()

	-- 保存したくないカウンターを初期化
	this.commonMissionCounterListRestore()

	-- 無線のフラグをリセット
	GzRadioSaveData.ResetSaveRadioId()
	GzRadioSaveData.ResetSaveEspionageId()

	local radioManager = RadioDaemon:GetInstance()
	radioManager:DisableAllFlagIsMarkAsRead()
	radioManager:ResetRadioGroupAndGroupSetAlreadyReadFlag()

	-- 汎用無線登録解除
	TppRadioConditionManagerAccessor.Unregister( "Tutorial" )
	TppRadioConditionManagerAccessor.Unregister( "Basic" )

	-- マーカーをすべて削除
	TppMarkerSystem.DisableAllMarker()

end
---------------------------------------------------------------------------------
-- ■ commonReturnTitle
-- タイトルに戻る
this.commonReturnTitle = function()
	Fox.Log("!!!!!commonReturnTitle!!!!!")

	-- 全カセットテープの持ってない扱いをやめるのはタイトルに戻る時だけ
	local uiCommonData = UiCommonDataManager.GetInstance()
	uiCommonData:ShowAllCassetteTapes()

	-- ミッション後片付け
	this.commonMissionCleanUp()

end

---------------------------------------------------------------------------------
-- ■ commonMissionFlagRestore
-- ミッションフラグのクリア
this.commonMissionFlagRestore = function( manager, messageId, message )

	-- 保存したくないミッションフラグはここで初期化

	-- ミッション圏外警告を受けているか
	TppMission.SetFlag( "isWarningMissionArea", false )

	-- 内通者と取り巻き兵が一緒に行動しているか
	TppMission.SetFlag( "isBetrayerTogether", false )

	-- 合図チェック同期待ちフラグ
	TppMission.SetFlag( "isBetrayerSignalCheckWait", false )
	TppMission.SetFlag( "isAssistantSignalCheckWait", false )

	-- 「要するにやること無線」再生予約
	TppMission.SetFlag( "isRadio_SimpleObjectivePlay", false )

	-- ミッション補足説明1再生中判定フラグ
	TppMission.SetFlag( "OnPlay_MissionBriefingSub1", false )

end
---------------------------------------------------------------------------------
-- ■ commonMissionCounterListRestore
-- ミッションカウンターリストのクリア
this.commonMissionCounterListRestore = function()

	-- 保存したくないカウンターリストはここで明示的に初期化

	this.CounterList.BetrayerInterrogation 		= 0
	this.CounterList.MastermindInterrogation 	= 0
	this.CounterList.WestTruckStatus 	= 0
	this.CounterList.NorthTruckStatus 	= 0
	this.CounterList.BetrayerRestraint 	= 0

end
---------------------------------------------------------------------------------
-- ■ commonSearchTargetSetup
-- サーチターゲットの初期化
local commonSearchTargetSetup = function( manager )
	Fox.Log("commonSearchTargetSetup")
	-- 一旦全登録を削除
	manager.CheckLookingTarget:ClearSearchTargetEntities()

	-- 内通者
	if( TppMission.GetFlag( "isBetrayerDown" ) == false )  then
		GZCommon.SearchTargetCharacterSetup( manager, this.BetrayerID )
	end

	-- 反乱兵
	if( TppMission.GetFlag( "isMastermindDown" ) == false )  then
		GZCommon.SearchTargetCharacterSetup( manager, this.MastermindID )
	end

end
---------------------------------------------------------------------------------
-- ■ commonSetCompleteMissionPhoto
-- ミッション写真の「完了」化
this.commonSetCompleteMissionPhoto = function()

	Fox.Log(":::::::commonSetCompleteMissionPhoto:::::::")

	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager ~= NULL then
		local luaData = commonDataManager:GetUiLuaExportCommonData()
		if luaData ~= NULL then

			luaData:SetCompleteMissionPhotoId(10, true)
		end
	end

end
---------------------------------------------------------------------------------
-- ■ commonUpdateMissionDescription
-- ミッション中間目標の更新
this.commonUpdateMissionDescription = function()

	Fox.Log(":::::::commonUpdateMissionDescription:::::::")

	-- ミッション説明を変更する
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager ~= NULL then
		local luaData = commonDataManager:GetUiLuaExportCommonData()
		if luaData ~= NULL then
			-- ストーリー番号を変更
			luaData:SetMisionInfoCurrentStoryNo(1)									-- ストーリー番号を0から1に
		end
	end

end
---------------------------------------------------------------------------------
-- ■■ Radio Functions
---------------------------------------------------------------------------------
-- ■ commonOptionalRadioUpdate
-- 任意無線セットの更新
this.commonOptionalRadioUpdate = function()

	Fox.Log("---- commonOptionalRadioUpdate ----")


	-- 各MissionFlagを見て任意無線セットを切り替える
	if( TppMission.GetFlag( "isGetCassette_A" ) == true or TppMission.GetFlag( "isGetCassette_B" ) == true ) then
		----- いずれかのカセットテープ入手～脱出 -----
		-- テープBは未取得でかつ反乱兵がテープBを持っていることを知っている
		if ( TppMission.GetFlag( "isDropCassette_B" ) == false and TppMission.GetFlag( "isGetInfo_Mastermind" ) == true ) then
			Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_203 START ----")
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_203" )
		-- カセットBをドロップ済みだが未入手
		elseif ( TppMission.GetFlag( "isDropCassette_B" ) == true and TppMission.GetFlag( "isGetCassette_B" ) == false ) then
			Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_104 START ----")
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_104" )
		-- 検問が既に設置済み
		elseif ( TppMission.GetFlag( "isInspectionActive" ) == true ) then
			Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_202 START ----")
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_202" )
		-- 検問が未設置
		else
			Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_201 START ----")
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_201" )
		end

	elseif( TppMission.GetFlag( "isBetrayerContact" ) == true )  then
		----- 内通者接触～カセット入手前 -----

		-- カセットBをドロップ済みだが未入手
		if ( TppMission.GetFlag( "isDropCassette_B" ) == true and TppMission.GetFlag( "isGetCassette_B" ) == false ) then
			Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_104 START ----")
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_104" )

		-- 罠だと知らない（立ち話を聞いていない）
		elseif ( TppMission.GetFlag( "isGetInfo_Suspicion2" ) == false ) then
			-- 本物をスキンヘッドが持っていることを知っている
			if ( TppMission.GetFlag( "isGetInfo_Mastermind" ) == true ) then
				Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_106 START ----")
				TppRadio.RegisterOptionalRadio( "OptionalRadioSet_106" )
			else
				-- 監視カメラのことを知っている
				if ( TppMission.GetFlag( "isCameraAlert" ) or TppMission.GetFlag( "isCameraBroken" ) or TppMission.GetFlag( "isCameraIntelRadioPlay" ) ) then
					Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_110 START ----")
					TppRadio.RegisterOptionalRadio( "OptionalRadioSet_110" )
				else
					Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_101 START ----")
					TppRadio.RegisterOptionalRadio( "OptionalRadioSet_101" )
				end
			end

		-- 本物をスキンヘッドが持っていることを知っている
		elseif ( TppMission.GetFlag( "isGetInfo_Mastermind" ) == true ) then
			-- 監視カメラのことを知っている
			if ( TppMission.GetFlag( "isCameraAlert" ) or TppMission.GetFlag( "isCameraBroken" ) or TppMission.GetFlag( "isCameraIntelRadioPlay" ) ) then
				Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_107 START ----")
				TppRadio.RegisterOptionalRadio( "OptionalRadioSet_107" )
			else
				Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_103 START ----")
				TppRadio.RegisterOptionalRadio( "OptionalRadioSet_103" )
			end
		else
			-- 監視カメラのことを知っている
			if ( TppMission.GetFlag( "isCameraAlert" ) or TppMission.GetFlag( "isCameraBroken" ) or TppMission.GetFlag( "isCameraIntelRadioPlay" ) ) then
				Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_109 START ----")
				TppRadio.RegisterOptionalRadio( "OptionalRadioSet_109" )
			else
				-- 監視カメラ破壊済み
				if ( TppMission.GetFlag( "isCameraBroken" ) ) then
					Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_105 START ----")
					TppRadio.RegisterOptionalRadio( "OptionalRadioSet_105" )
				else
					Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_102 START ----")
					TppRadio.RegisterOptionalRadio( "OptionalRadioSet_102" )
				end
			end
		end

	else
		----- 内通者接触前 -----
		-- 内通者をヘリで回収したので情報を聞き出し中
		if ( TppMission.GetFlag( "listeningInfoFromBetrayer" ) == true ) then
			Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_003 START ----")
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_003" )
		-- カセットBドロップ済みだが未入手
		elseif ( TppMission.GetFlag( "isDropCassette_B" ) == true and TppMission.GetFlag( "isGetCassette_B" ) == false ) then
			Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_104 START ----")
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_104" )
		-- 合図用サーチライト使用済みまたは破壊済み
		elseif ( TppMission.GetFlag( "isSignalExecuted" ) == true or TppMission.GetFlag( "isSignalTurretDestruction" ) == true ) then
			Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_002 START ----")
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_002" )
		else
			Fox.Log("---- commonOptionalRadioUpdate:OptionalRadioSet_001 START ----")
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_001" )
		end

	end


end
---------------------------------------------------------------------------------
-- ■ commonRegisterIntelRadio
-- 諜報無線初期化
this.commonRegisterIntelRadio = function()

	Fox.Log("-----commonRegisterIntelRadio-----")

	-- トラックへの諜報無線を有効化
	TppRadio.EnableIntelRadio( "Cargo_Truck_WEST_001")
	TppRadio.EnableIntelRadio( "Cargo_Truck_WEST_002")

	-- 監視カメラ
	TppRadio.EnableIntelRadio( "e20030_SecurityCamera")

	-- 合図用サーチライトへの諜報無線を無効化
	TppRadio.DisableIntelRadio( "SL_WoodTurret04")
	-- カセットAへの諜報無線を無効化
	-- TppRadio.DisableIntelRadio( "intel_e0030_rtrg0065")

	-- 敵兵の諜報無線を有効化
	-- TppRadio.EnableIntelRadioCharacterType("Enemy")]

	TppRadio.EnableIntelRadio( this.BetrayerID )
	TppRadio.EnableIntelRadio( this.MastermindID )
	TppRadio.EnableIntelRadio( this.AssistantID )
	TppRadio.EnableIntelRadio( "e20030_enemy002" )
	TppRadio.EnableIntelRadio( "e20030_enemy003" )
	TppRadio.EnableIntelRadio( "e20030_enemy004" )
	TppRadio.EnableIntelRadio( "e20030_enemy005" )
	TppRadio.EnableIntelRadio( "e20030_enemy006" )
	TppRadio.EnableIntelRadio( "e20030_enemy007" )
	TppRadio.EnableIntelRadio( "e20030_enemy008" )
	TppRadio.EnableIntelRadio( "e20030_DemoSoldier01" )
	TppRadio.EnableIntelRadio( "e20030_DemoSoldier03" )
	TppRadio.EnableIntelRadio( "e20030_enemy011" )
	TppRadio.EnableIntelRadio( "e20030_enemy012" )
	TppRadio.EnableIntelRadio( "e20030_enemy013" )
	TppRadio.EnableIntelRadio( "e20030_enemy014" )
	TppRadio.EnableIntelRadio( "e20030_enemy015" )
	TppRadio.EnableIntelRadio( "e20030_enemy016" )
	TppRadio.EnableIntelRadio( "e20030_enemy017" )
	TppRadio.EnableIntelRadio( "e20030_enemy018" )
	TppRadio.EnableIntelRadio( "e20030_DemoSoldier02" )
	TppRadio.EnableIntelRadio( "e20030_enemy020" )
	TppRadio.EnableIntelRadio( "e20030_Driver" )
	TppRadio.EnableIntelRadio( "e20030_enemy022" )
	TppRadio.EnableIntelRadio( "e20030_enemy023" )
--	TppRadio.EnableIntelRadio( "e20030_WavDriver" )

	-- 捕虜の諜報無線を有効化
	TppRadio.EnableIntelRadio( "Hostage_e20030_000" )
	TppRadio.EnableIntelRadio( "Hostage_e20030_001" )
	TppRadio.EnableIntelRadio( "Hostage_e20030_002" )

	-- ドラム缶の諜報無線を有効化
	TppRadio.EnableIntelRadio( "gntnCom_drum0002" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0005" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0011" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0012" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0015" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0019" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0020" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0021" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0022" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0023" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0024" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0025" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0027" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0028" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0029" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0030" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0031" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0035" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0037" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0038" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0039" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0040" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0041" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0042" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0043" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0044" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0045" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0046" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0047" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0048" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0065" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0066" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0068" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0069" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0070" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0071" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0072" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0101" )

	-- 監視カメラ
	TppRadio.EnableIntelRadio( "e20030_SecurityCamera" )
	TppRadio.EnableIntelRadio( "e20030_SecurityCamera_01" )
	TppRadio.EnableIntelRadio( "e20030_SecurityCamera_03" )
	TppRadio.EnableIntelRadio( "e20030_SecurityCamera_04" )
end
-- 諜報無線セットアップ（やぐら無効化）
this.SetIntelRadio = function()
	Fox.Log("================== SetIntelRadio ====================== ")

	--全シーケンスで設定するもの
	TppRadio.DisableIntelRadio( "WoodTurret01" )
	TppRadio.DisableIntelRadio( "WoodTurret02" )
	TppRadio.DisableIntelRadio( "WoodTurret03" )
	TppRadio.DisableIntelRadio( "WoodTurret04" )
	TppRadio.DisableIntelRadio( "WoodTurret05" )
	-- 何故かこっち↓の書き方じゃないと適用されない
	TppPlayerUtility.SetPlayerSightSearchInfoRadioEnable( "WoodTurret01", false )
	TppPlayerUtility.SetPlayerSightSearchInfoRadioEnable( "WoodTurret02", false )
	TppPlayerUtility.SetPlayerSightSearchInfoRadioEnable( "WoodTurret03", false )
	TppPlayerUtility.SetPlayerSightSearchInfoRadioEnable( "WoodTurret04", false )
	TppPlayerUtility.SetPlayerSightSearchInfoRadioEnable( "WoodTurret05", false )
end
---------------------------------------------------
-- ■ commonUpdateCheckEnemyIntelRadio
-- 敵兵への諜報無線内容更新
this.commonUpdateCheckEnemyIntelRadio = function()

	Fox.Log("-----commonUpdateCheckEnemyIntelRadio-----")

	-- 反乱兵がテープを奪った情報を得ていてテープBが未ドロップ
	if ( TppMission.GetFlag( "isGetInfo_Mastermind" ) == true and
		  TppMission.GetFlag( "isDropCassette_B" ) == false ) then

		TppRadio.RegisterIntelRadio( this.MastermindID, "e0030_esrg0090", true )		-- 反乱兵を諜報：テープを奪った奴じゃないか？
		TppRadio.RegisterIntelRadio( this.BetrayerID, "e0030_esrg0085", true )		-- 内通者を諜報：テープを奪ったのはコイツじゃなさそう
		this.commonUpdateNormalEnemyIntelRadio( "e0030_esrg0085" )				-- 敵兵を諜報：テープを奪ったのはコイツじゃなさそう

	-- 内通者未接触かつ未特定、クリア条件を満たしていない
	elseif ( TppMission.GetFlag("isBetrayerContact") == false and
			 TppMission.GetFlag("isBetrayerMarking") == false and
			 TppMission.GetFlag("isGetCassette_A") == false and
			 TppMission.GetFlag("isDropCassette_B") == false ) then

		TppRadio.RegisterIntelRadio( this.MastermindID, "e0030_esrg0080", true )		-- 反乱兵を諜報：調査員はどこだ？
		TppRadio.RegisterIntelRadio( this.BetrayerID, "e0030_esrg0080", true )		-- 内通者を諜報：調査員はどこだ？
		this.commonUpdateNormalEnemyIntelRadio( "e0030_esrg0080" )				-- 敵兵を諜報：調査員はどこだ？

	-- 内通者特定済み、接触済み
	else
		TppRadio.RegisterIntelRadio( this.MastermindID, "e0030_esrg0070", true )		-- 反乱兵を諜報：海兵隊員だ
		TppRadio.RegisterIntelRadio( this.BetrayerID, "e0030_esrg0070", true )		-- 内通者を諜報：海兵隊員だ
		this.commonUpdateNormalEnemyIntelRadio( "e0030_esrg0070" )				-- 敵兵を諜報：海兵隊員だ
	end

end
---------------------------------------------------
-- ■ commonUpdateNormalEnemyIntelRadio
-- 通常敵兵への諜報無線内容更新
this.commonUpdateNormalEnemyIntelRadio = function( RadioId )

	Fox.Log("-----commonUpdateNormalEnemyIntelRadio---::"..RadioId)

	TppRadio.RegisterIntelRadio( this.AssistantID, RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy002", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy003", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy004", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy005", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy006", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy007", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy008", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_DemoSoldier01", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_DemoSoldier03", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy011", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy012", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy013", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy014", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy015", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy016", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy017", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy018", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_DemoSoldier02", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy020", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_Driver", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy022", RadioId, true )
	TppRadio.RegisterIntelRadio( "e20030_enemy023", RadioId, true )
--	TppRadio.RegisterIntelRadio( "e20030_WavDriver", RadioId, true )

end
---------------------------------------------------
-- ■ commonUpdateCheckCameraIntelRadio
-- 中央管制塔監視カメラへの諜報無線内容更新
this.commonUpdateCheckCameraIntelRadio = function()

	Fox.Log("-----commonUpdateCheckCameraIntelRadio-----")

	-- 「罠」系の無線を1種でも言っていれば通常の監視カメラ諜報無線に切り替える
	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsRadioGroupMarkAsRead("e0030_esrg0103") == true or
		 radioDaemon:IsRadioGroupMarkAsRead("e0030_esrg0102") == true or
		 radioDaemon:IsRadioGroupMarkAsRead("e0030_esrg0101") == true ) then
		TppRadio.RegisterIntelRadio( "e20030_SecurityCamera", "f0090_esrg0210", true )
	else
		-- 内通者接触済みで罠だと知っている
		if ( TppMission.GetFlag( "isBetrayerContact" ) == true and
			  TppMission.GetFlag( "isGetInfo_Suspicion2" ) == true ) then

			TppRadio.RegisterIntelRadio( "e20030_SecurityCamera", "e0030_esrg0103", true )	-- 「監視カメラ･･･やはり罠だったか」

		-- 内通者接触済みで罠だと知らない
		elseif ( TppMission.GetFlag( "isBetrayerContact" ) == true and
				  TppMission.GetFlag( "isGetInfo_Suspicion2" ) == false ) then

			TppRadio.RegisterIntelRadio( "e20030_SecurityCamera", "e0030_esrg0102", true )	-- 「監視カメラ･･･罠か。あの調査員、俺たちをハメたのか」

		-- 内通者未接触で罠だと知っている
		elseif ( TppMission.GetFlag( "isBetrayerContact" ) == false and
				  TppMission.GetFlag( "isGetInfo_Suspicion2" ) == true ) then

			TppRadio.RegisterIntelRadio( "e20030_SecurityCamera", "e0030_esrg0101", true )	-- 「監視カメラ･･･罠か」

		-- 内通者未接触、罠だと知らない
		else
			TppRadio.RegisterIntelRadio( "e20030_SecurityCamera", "e0030_esrg0100", true )	-- 「監視カメラか･･･」
		end
	end
end
-- 監視カメラ破壊
this.Common_SecurityCameraBroken = function()
	local characterID = TppData.GetArgument( 1 )
	TppRadio.DisableIntelRadio( characterID )
end
-- 監視カメラ電源オフ
this.Common_SecurityCameraPowerOff = function()
	local characterID = TppData.GetArgument( 1 )
	TppRadio.DisableIntelRadio( characterID )
end
-- 監視カメラ電源オン
this.Common_SecurityCameraPowerOn = function()
	local characterID = TppData.GetArgument( 1 )
	TppRadio.EnableIntelRadio( characterID)
end
---------------------------------------------------
-- ■ commonMissionClearRadio
-- ミッションクリアリアルタイム無線
this.commonMissionClearRadio = function()

	Fox.Log("-----commonMissionClearRadio-----")

	-- PlayRecordからクリアランクを取得
	-- 0：未クリア 1：S 2：A 3：B 4：C 5：D 6：E
	local Rank = PlayRecord.GetRank()

	if( Rank == 0 ) then
		Fox.Warning( "commonMissionClearRadio:Mission not yet clear!!" )
	elseif( Rank == 1 ) then
		TppRadio.Play( "Radio_MissionClearRank_S" )

		-- 実績解除：「Sランクでミッションをクリア」
		Trophy.TrophyUnlock( this.TrophyId_GZ_RankSClear )

	elseif( Rank == 2 ) then
		TppRadio.Play( "Radio_MissionClearRank_A" )

	elseif( Rank == 3 ) then
		TppRadio.Play( "Radio_MissionClearRank_B" )

	elseif( Rank == 4 ) then
		TppRadio.Play( "Radio_MissionClearRank_C" )

	else
		TppRadio.Play( "Radio_MissionClearRank_D" )

	end

end
---------------------------------------------------
-- ■ CallMissionBriefingOnTruck
-- ミッション開始時のトラック上で流れるリアルタイム無線郡
local CallMissionBriefingOnTruck = function()

	Fox.Log("-----CallMissionBriefingOnTruck-----")

	-- いくつかのパートに分かれていて「途中でトラックから降りたかどうか」で次の説明が続くかどうかが決まる
	-- 再生開始時点では「次に無線が続くか？」が確定しないので無線のコール音は別途独立してコール
	-- TppSoundDaemon.PostEvent( "Play_sfx_s_codec_NPC_begin" )	-- デモからのつながり的にはここのSEも要らなさそう

	TppRadio.DelayPlay( "Radio_AboutSignal", 0.2, "none", {	-- 接触の合図説明
		onStart = function()	TppMission.SetFlag( "OnPlay_MissionBriefingSub1", true )	end,	-- ミッション補足説明1再生中判定フラグ
		onEnd = function()
			if ( TppMission.GetFlag("isSignalTurretDestruction") == false ) then
				TppMarker.Enable( "e20030_marker_Signal", 0, "moving", "map_only_icon", 0, true, true )	-- 内通者への合図ポイントのマーカーをオン
				this.commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )		-- Map更新アナウンスログ表示
			end

			-- 合図用サーチライトへの諜報無線を有効化
			TppRadio.EnableIntelRadio( "SL_WoodTurret04")
			-- ミッション開始時ジングルを停止
			TppMusicManager.PostJingleEvent( "SingleShot", "Stop_bgm_gntn_op_default" )

			if ( this.CounterList.PlayerOnCargo ~= "NoRide" ) then	-- プレイヤーがまだトラックの荷台に乗っているなら

				TppRadio.DelayPlayEnqueue( "Radio_RideOffTruck", "short", "none", {	-- トラックからの降り方
					onEnd = function()

						if ( this.CounterList.PlayerOnCargo ~= "NoRide" ) then	-- プレイヤーがまだトラックの荷台に乗っているなら

							TppRadio.DelayPlayEnqueue( "Radio_MissionBriefingSub1", "mid", "none",{	-- ミッション目的説明補足1：今回の依頼･･･
								onStart = function()	TppMission.SetFlag( "isRadio_MissionBriefingSub1", true )	end,
								onEnd = function()
									if ( this.CounterList.PlayerOnCargo ~= "NoRide" ) then	-- プレイヤーがまだトラックの荷台に乗っているなら

										TppRadio.DelayPlayEnqueue( "Radio_MissionBriefingSub1_1", "short", "none", {	-- ミッション目的説明補足1-1：奇妙な話だが･･･その基地ではあらゆる国の法律が･･･
											onEnd = function()
												if ( this.CounterList.PlayerOnCargo ~= "NoRide" ) then	-- プレイヤーがまだトラックの荷台に乗っているなら

													local MissionBriefing1_23 = { "Radio_MissionBriefingSub1_2", "Radio_MissionBriefingSub1_3" }
													TppRadio.DelayPlayEnqueue( MissionBriefing1_23, "short", "none",  {	-- ミッション目的説明補足1-2,1-3：長引く戦争で米軍は･･･"キューバの中のアメリカ"で、･･･
														onEnd = function()
															TppMission.SetFlag( "isRadio_MissionBriefingSub1_3", true )
															if ( this.CounterList.PlayerOnCargo ~= "NoRide" ) then	-- プレイヤーがまだトラックの荷台に乗っているなら
																-- 再生開始同様無線のコール音は別途独立してコール
																TppSoundDaemon.PostEvent( "Play_sfx_s_codec_NPC_end" )
																-- 降りた際に再生させるために「要するにやること無線」を再生予約
																TppMission.SetFlag( "isRadio_SimpleObjectivePlay", true )
															else
																-- 既にトラックから降りていたなら「要するにやること無線」をここで再生
																TppRadio.DelayPlayEnqueue( "Radio_SimpleObjective", "mid", "end" )
																TppMission.SetFlag( "isRadio_SimpleObjectivePlay", false )
															end
															TppMission.SetFlag( "OnPlay_MissionBriefingSub1", false )
														end
													} )
												else	-- プレイヤーがトラックの荷台から降りていたら
													TppRadio.DelayPlayEnqueue( "Radio_MissionBriefingSub1_3", "short", "none", {	-- ミッション目的説明補足1-3："キューバの中のアメリカ"で、･･･
														onEnd = function()
															TppMission.SetFlag( "isRadio_MissionBriefingSub1_3", true )

															-- 「要するにやること無線」を再生
															TppRadio.DelayPlayEnqueue( "Radio_SimpleObjective", "mid", "end" )
															TppMission.SetFlag( "isRadio_SimpleObjectivePlay", false )
															TppMission.SetFlag( "OnPlay_MissionBriefingSub1", false )
														end
													} )
												end
												TppTimer.Stop( "CheckTargetPhotoTimer" )
												-- 端末写真確認促し無線タイマー開始
												TppTimer.Start( "CheckTargetPhotoTimer", GZCommon.Time_HintPhotoCheck )
											end
										} )
									else
										-- 既にトラックから降りていたなら「要するにやること無線」をここで再生
										TppRadio.DelayPlayEnqueue( "Radio_SimpleObjective", "mid", "end" )
										TppMission.SetFlag( "isRadio_SimpleObjectivePlay", false )
										TppMission.SetFlag( "OnPlay_MissionBriefingSub1", false )
										TppTimer.Stop( "CheckTargetPhotoTimer" )
										-- 端末写真確認促し無線タイマー開始
										TppTimer.Start( "CheckTargetPhotoTimer", GZCommon.Time_HintPhotoCheck )
									end
								end
							} )
						else
							-- 再生開始同様無線のコール音は別途独立してコール
							TppSoundDaemon.PostEvent( "Play_sfx_s_codec_NPC_end" )
							TppMission.SetFlag( "OnPlay_MissionBriefingSub1", false )
							TppTimer.Stop( "CheckTargetPhotoTimer" )
							-- 端末写真確認促し無線タイマー開始
							TppTimer.Start( "CheckTargetPhotoTimer", GZCommon.Time_HintPhotoCheck )
						end
					end
				} )
			else
				-- 再生開始同様無線のコール音は別途独立してコール
				TppSoundDaemon.PostEvent( "Play_sfx_s_codec_NPC_end" )
				TppMission.SetFlag( "OnPlay_MissionBriefingSub1", false )
				TppTimer.Stop( "CheckTargetPhotoTimer" )
				-- 端末写真確認促し無線タイマー開始
				TppTimer.Start( "CheckTargetPhotoTimer", GZCommon.Time_HintPhotoCheck )
			end

		end
	} )
end
---------------------------------------------------------------------------------
-- ■ commonCheckTargetPhotoTimer
-- 内通者の写真確認促し無線再生チェック
this.commonCheckTargetPhotoTimer = function()

	Fox.Log("-----commonCheckTargetPhotoTimer-----")

	-- いずれかの無線が再生中であれば今回はスキップ
	local radioDaemon = RadioDaemon:GetInstance()

	--無線の種類に問わず再生中ではない
	if ( radioDaemon:IsPlayingRadio() == false ) then
		-- 「写真を未確認」「内通者にマーカーなし」「内通者に未接触」「いずれのテープもなし」「Sneakである」
		if ( TppMission.GetFlag("isPlayerCheckMbPhoto") == false and
			 TppMission.GetFlag("isBetrayerMarking") == false and
			 TppMission.GetFlag("isBetrayerContact") == false and
			 TppMission.GetFlag("isGetCassette_A") == false and
			 TppMission.GetFlag("isDropCassette_B") == false and
			 TppEnemy.GetPhase("gntn_cp") == "sneak" ) then

			-- 全ての条件を満たしていたら「写真を確認しろ」無線
			TppRadio.Play( "Radio_CheckMbPhoto" )
			TppRadio.PlayEnqueue( "Radio_CheckMbPhotoTutorial" )
		end
	end

	TppTimer.Stop( "CheckTargetPhotoTimer" )
	-- タイマー再開
	TppTimer.Start( "CheckTargetPhotoTimer", GZCommon.Time_HintPhotoCheck )

end
---------------------------------------------------------------------------------
-- ■ IntelRadioPlayCameraTrap
-- 中央管制塔監視カメラへの諜報無線実行
this.IntelRadioPlayCameraTrap = function()

	Fox.Log("-----IntelRadioPlayCameraTrap-----")

	-- 内通者接触以降であれば内通者を疑う
	if ( TppMission.GetFlag("isBetrayerContact") == true) then

		-- 監視カメラの諜報無線を更新
		this.commonUpdateCheckCameraIntelRadio()

		TppMission.SetFlag( "isGetInfo_Suspicion2", true )
		this.commonBetrayerInterrogationSetUpdate()	-- 内通者の尋問時セリフセット更新

		TppMission.SetFlag("isCameraIntelRadioPlay", true )
	end

end
---------------------------------------------------------------------------------
-- ■ commonRadioGetCassetteB
-- 反乱兵のドロップしたカセットB入手時無線
this.commonRadioGetCassetteB = function()
	Fox.Log("----------------commonRadioGetCassetteB----------------")

	local RadioName

	-- ミラー無線の呼び分け
	if ( TppMission.GetFlag( "isGetInfo_Mastermind" ) == true ) then
		-- 尋問ヒントあり
		-- 「回収したな。脱出しろ」
		RadioName = "Radio_GetCassette_B_Confidence"

	elseif ( TppMission.GetFlag( "isGetCassette_A" ) == false ) then
		-- 尋問ヒントなし、カセットAを持っていない
		-- 「回収したな」「ともかく帰投してくれ、ボス。そのテープをクライアント（依頼主）に照合させる。」
		RadioName = "Radio_GetCassette_B_NoHint"

	else
		-- 尋問ヒントなし、カセットAを持っている
		-- 「回収したな」「ともかく目的は果たした。帰投してくれ。」
		RadioName = "Radio_GetCassette_B_WithA"

	end

	-- 無線の再生実行
	TppRadio.DelayPlayEnqueue( RadioName, "short", "begin", {
		onEnd = function()
			-- さらにこの時点で既にミッション圏外警告エリア内だった場合は、無線終了時に圏外エフェクトを解除
			if ( TppMission.GetFlag( "isWarningMissionArea" ) == true ) then
				-- ミッション圏外エフェクトの停止
				TppOutOfMissionRangeEffect.Disable( 1 )		-- 何かSE要る？
				GZCommon.OutsideAreaVoiceEnd()
				TppRadio.DelayPlay( "Radio_MissionArea_Clear", "short", "end" )
			else
				-- ミッション圏外警告エリア内じゃなければ無線終了SEだけコール
				TppSoundDaemon.PostEvent( "Play_sfx_s_codec_NPC_end" )
			end
		end
	 })

end
---------------------------------------------------------------------------------
-- ■ commonWatchingBetrayer
-- 内通者を双眼鏡で捉えた
this.commonWatchingBetrayer = function()

-- Fox.Log("-----commonWatchingBetrayer-----")
--[[
	-- 内通者のＡＩ状態を取得する
	local aiStatus = TppEnemyUtility.GetAiStatus( this.BetrayerID )
	-- 現在のルートIDを取得
	local routeId = TppEnemyUtility.GetRouteId( this.BetrayerID )

	-- 会話中
	if ( aiStatus == "Conversation" ) then

		-- ルートIDから実行されている会話イベントを判定する
		if ( routeId == "gntn_e20030_tgt_route9003" ) then
			-- 内通者と取り巻き兵との会話
			--TppRadio.Play("Miller_Conversation")

		elseif ( routeId == "gntn_e20030_tgt_route0003" ) then
			-- 内通者と反乱兵との会話

		end


	-- ルート移動中
	elseif ( aiStatus == "RouteMove" ) then

	end
]]

end

-- 捕虜の諜報無線更新
-- ■ commonHostageIntelCheck
this.commonHostageIntelCheck = function( CharacterID )
	Fox.Log("--------commonHostageIntelCheck--------")
	local status = TppHostageUtility.GetStatus( CharacterID )
	if status == "Dead" then
		TppRadio.DisableIntelRadio( CharacterID )
	else
		TppRadio.EnableIntelRadio( CharacterID )
	end
end
---------------------------------------------------------------------------------
-- ヘリから離れろって促すのを延長
-- ■ commonHeliLeaveExtension
this.commonHeliLeaveExtension = function()
	local timer = 55 --「ヘリから離れろよ」という促しをするまでの時間

	-- 一回止めて同じタイマーを回す
	GkEventTimerManager.Stop( "Timer_pleaseLeaveHeli" )
	GkEventTimerManager.Start( "Timer_pleaseLeaveHeli", timer )
end

---------------------------------------------------------------------------------
-- ■■ Gimmick Functions
---------------------------------------------------------------------------------
-- ■ commonWoodTurret03Break
-- 壊れやぐらを破壊した
this.commonWoodTurret03Break = function()
	Fox.Log("----------------commonWoodTurret03Break----------------")

	-- やぐら上のルートは使用不可
	TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0002" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_common_c01_route0002" )

end
--------------------------------------------------
-- ■ commonWoodTurret04Break
-- 壊れやぐらを破壊した
this.commonWoodTurret04Break = function()
	Fox.Log("----------------commonWoodTurret04Break----------------")
	-- このやぐらが壊れたら内通者への合図が出来なくなる
	-- サーチライトが壊れた場合も合図が出来ないのでフラグ的には１つで取り扱う

		-- 合図を未実行かつカセットAもBも入手していない
	if ( TppMission.GetFlag("isSignalExecuted") == false and
		 TppMission.GetFlag("isGetCassette_A") == false and
		 TppMission.GetFlag("isGetCassette_B") == false ) then
		-- 合図が出来なくなった無線
		TppRadio.DelayPlay( "Radio_SignalBroken", "mid" )
	end

	TppMission.SetFlag("isSignalTurretDestruction", true )

	-- 合図用サーチライトへの諜報無線を無効化
	TppRadio.DisableIntelRadio( "SL_WoodTurret04")

	-- 合図ポイントのターゲットマーカー表示をオフ
	TppMarker.Disable( "e20030_marker_Signal" )

	-- 任意無線を更新
	this.commonOptionalRadioUpdate()

	-- やぐら上のルートは使用不可	ToDo 壊れたのがサーチライトだけだった場合は除外しないと
	TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0009" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0025" )

end
---------------------------------------------------------------------------------
-- ■ commonUseSignalLight
-- 合図用サーチライトを使用した
this.commonUseSignalLight = function()
	Fox.Log("----------------commonUseSignalLight----------------")

	-- 合図を未実行かつ内通者に未接触、カセットAもBも入手していない、壊れてない
	if ( TppMission.GetFlag("isSignalExecuted") == false and
		 TppMission.GetFlag("isBetrayerContact") == false and
		 TppMission.GetFlag("isGetCassette_A") == false and
		 TppMission.GetFlag("isGetCassette_B") == false and
		 TppMission.GetFlag("isSignalTurretDestruction") == false ) then

		-- ALertフェイズでなければ合図有効、としてみる
		if ( TppEnemy.GetPhase("gntn_cp") ~= "alert" ) then

			-- 合図サーチライトSEコール
			this.CallSignalLightSE()

			-- アナウンスログ表示
			this.commonCallAnnounceLog( this.AnnounceLogID_Signal )

			-- この時点で内通者を特定していなければフラグ
			if ( TppMission.GetFlag( "isBetrayerMarking" ) == false ) then
				TppMission.SetFlag( "isNotMarkBeforeSignal", true )
			end

			-- 端末の写真を確認済みまたは調査員マーキング済みなら
			if ( TppMission.GetFlag( "isPlayerCheckMbPhoto" ) == true or TppMission.GetFlag( "isBetrayerMarking" ) == true ) then
				TppRadio.DelayPlayEnqueue( "Radio_RunSignal", "mid" )
			else
				local RunSignal = { "Radio_RunSignal", "Radio_CheckMbPhoto"}
				TppRadio.DelayPlayEnqueue( RunSignal, "mid" )

				-- 端末写真確認促し無線タイマーをリセット
				TppTimer.Stop( "CheckTargetPhotoTimer" )
				TppTimer.Start( "CheckTargetPhotoTimer", GZCommon.Time_HintPhotoCheck )

			end

			-- 合図ポイントのターゲットマーカー表示をオフ
			TppMarker.Disable( "e20030_marker_Signal" )

			-- 合図用サーチライトへの諜報無線を無効化
			TppRadio.DisableIntelRadio( "SL_WoodTurret04")

			-- 合図実行済みフラグをオン
			TppMission.SetFlag( "isSignalExecuted", true )

			-- 内通者と取り巻きをルートチェンジ
			this.ChangeSignalCheckRoute( "Normal" )

			-- 任意無線を更新
			this.commonOptionalRadioUpdate()

			TppMissionManager.SaveGame("10")	-- 今はID指定のみ対応

		else
			Fox.Log("UseSignal_but_AlertNow")
			-- 今は接触ダメだ無線
			TppRadio.DelayPlay( "Radio_ContactNot_Phase", "short" )

		end

	-- いずれかのカセットを取得済み
	elseif ( TppMission.GetFlag( "isGetCassette_A" ) == true or
			 TppMission.GetFlag( "isGetCassette_B" ) == true ) then

		TppRadio.DelayPlayEnqueue( "Radio_EscapeWay", "mid" )	-- 目的は達したので脱出を勧める

	-- いずれのカセットも未入手で内通者接触済み
	elseif ( TppMission.GetFlag( "isBetrayerContact" ) == true ) then

		TppRadio.DelayPlayEnqueue( "Radio_RecommendGetCassette_A", "mid" )	-- 接触したのでカセット入手を促す
	end

end
---------------------------------------------------------------------------------
-- ■ commonStopWalkMan
-- ウォークマンでカセットテープを聞き終えた
this.commonStopWalkMan = function()

	local CassetteId = TppData.GetArgument(1)

	Fox.Log("----------------commonStopWalkMan:"..CassetteId)

	-- 初回のみ無線
	if ( CassetteId == this.CassetteA ) then

		-- 「それが依頼のあったテープなのか？」
		TppRadio.Play( "Radio_PlayedCassette_A" )

	elseif ( CassetteId == this.CassetteB ) then

		-- 「磁気テープだった」
		TppRadio.Play( "Radio_PlayedCassette_B" )

	end
end
---------------------------------------------------------------------------------
-- ■ commonFocusMapIcon
-- MB端末上でマップアイコンにフォーカスした
this.commonFocusMapIcon = function()

	local Id_32Bit = TppEventSequenceManagerCollector.GetMessageArg( 0 )
	local sequence = TppSequence.GetCurrentSequence()

	Fox.Log("------commonFocusMapIcon:"..Id_32Bit)

	-- 内通者への合図用やぐら
	if StringId.IsEqual32( Id_32Bit, "e20030_marker_Signal" ) then
		if ( TppMission.GetFlag( "isSignalTurretDestruction" ) == false and TppMission.GetFlag( "listeningInfoFromBetrayer" ) == false ) then
			Fox.Log("********** MbDvcActWatchPhoto: e20030_marker_Signal **********")
			TppRadio.Play( "Radio_Map_Signal" )
		end

	-- 内通者
	elseif StringId.IsEqual32( Id_32Bit, this.BetrayerID ) then
		if ( sequence == "Seq_Waiting_BetrayerContact" and TppMission.GetFlag( "isBetrayerMarking") ) then
			TppRadio.Play( "Radio_AboutContact" )
		end
	-- カセットA
	elseif StringId.IsEqual32( Id_32Bit, "e20030_marker_Cassette" ) then

		TppRadio.Play( "Radio_FocusCassette_A" )
	-- 検問
	elseif StringId.IsEqual32( Id_32Bit, "TppMarkerLocator_EscapeWest" ) or
		   StringId.IsEqual32( Id_32Bit, "TppMarkerLocator_EscapeNorth" ) then

		TppRadio.Play( "Radio_LandEscape" )
	end

end

---------------------------------------------------------------------------------
-- ■ MbDvcActCallRescueHeli
--　支援ヘリ要請した
this.MbDvcActCallRescueHeli = function(characterId, type)
	local radioDaemon = RadioDaemon:GetInstance()
	local emergency = TppData.GetArgument(2)

	Fox.Log("MbDvcActCallRescueHeli:")

	Fox.Log( "=================================" )
	Fox.Log( "===  mbDvaActCall(Type:" .. tostring(type) .. ") !!!   ===" )
	Fox.Log( "=================================" )

	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()
	local charaObj = Ch.FindCharacterObjectByCharacterId("SupportHelicopter")
	local plgHeli = charaObj:GetCharacter():FindPlugin("TppSupportHelicopterPlugin")

	if( VehicleId == "SupportHelicopter" ) then
	else
		if ( type == "MbDvc" ) then
			Fox.Log( "=================================" )
			Fox.Log( "===  mbDvaActCall(emergencyRank:" .. tostring(emergency) .. ") !!!   ===" )
			Fox.Log( "=================================" )

			if ( radioDaemon:IsPlayingRadio() == false ) then
				--無線の種類に問わず再生中でない
				if(TppSupportHelicopterService.IsDueToGoToLandingZone(characterId)) then
				--これからＬＺに行く予定がある
					if(emergency == 2) then
						TppRadio.DelayPlay( "Miller_CallHeliHot02", "long" )
					else
						TppRadio.DelayPlay( "Miller_CallHeli02", "long" )
					end
				else
				--特にＬＺに行く予定はない
					if plgHeli:GetAiStatus() ~= "AI_STATUS_RETURN" then
					--帰還していない場合の処理
						if(emergency == 2) then
							TppRadio.DelayPlay( "Miller_CallHeliHot01", "long" )
						else
							TppRadio.DelayPlay( "Miller_CallHeli01", "long" )
						end
					end
				end
			end
		elseif ( type == "flare" ) then
			Fox.Log( "=================================" )
			Fox.Log( "===  FlareHeliCall(isUnderground:" .. tostring(emergency) .. ") !!!   ===" )
			Fox.Log( "=================================" )

			if ( emergency == false ) then
				-- 地下なのでヘリは呼べない
				if ( radioDaemon:IsPlayingRadio() == false ) then
					TppRadio.DelayPlay( "Miller_HeliNoCall", "long" )
				end
			else
				-- ヘリは呼べる
				if ( radioDaemon:IsPlayingRadio() == false ) then
					--無線の種類に問わず再生中でない
					if(TppSupportHelicopterService.IsDueToGoToLandingZone(characterId)) then
					--これからＬＺに行く予定がある
						if(emergency == 2) then
							TppRadio.DelayPlay( "Miller_CallHeliHot02", "long" )
						else
							TppRadio.DelayPlay( "Miller_CallHeli02", "long" )
						end
					else
					--特にＬＺに行く予定はない
						if plgHeli:GetAiStatus() ~= "AI_STATUS_RETURN" then
						--帰還していない場合の処理
							if(emergency == 2) then
								TppRadio.DelayPlay( "Miller_CallHeliHot01", "long" )
							else
								TppRadio.DelayPlay( "Miller_CallHeli01", "long" )
							end
						end
					end
				end
			end
		else
			if ( radioDaemon:IsPlayingRadio() == false ) then
				--無線の種類に問わず再生中でない
				if(TppSupportHelicopterService.IsDueToGoToLandingZone(characterId)) then
				--これからＬＺに行く予定がある
					TppRadio.DelayPlay( "Miller_CallHeli02", "long" )
				else
				--特にＬＺに行く予定はない
					TppRadio.DelayPlay( "Miller_CallHeli01", "long" )
				end
			end
		end
	end
end

---------------------------------------------------------------------------------
-- ■ commonSecurityCameraDead
-- 監視カメラ破壊時処理
this.commonSecurityCameraDead = function()
	Fox.Log("--------commonSecurityCameraDead--------")

	-- ToDo 誰に壊されたのか？の判定をしないとダメかも

	-- 破壊された
	TppMission.SetFlag( "isCameraBroken", true )

	-- カメラ破壊時の無線はCP無線後のため、無線条件判定自体はここでやってしまう
	if (TppMission.GetFlag("isGetInfo_Suspicion2") == true and
		TppMission.GetFlag("isBetrayerContact") == true) then

		-- 既に内通者を疑っていて、かつ内通者接触済み
		this.CounterList.CameraBrokenRadio = "Radio_BrokeCamera_Confidence"		-- 「監視カメラ･･･やはり罠だったか」

	elseif (TppMission.GetFlag("isGetInfo_Suspicion2") == false and
			TppMission.GetFlag("isBetrayerContact") == false) then

		-- そもそも内通者に接触していない場合
		this.CounterList.CameraBrokenRadio = "Radio_BrokeCamera_Accident"		-- 「監視カメラか･･･危ないところだったな」

	elseif (TppMission.GetFlag("isGetInfo_Suspicion2") == false and
			TppMission.GetFlag("isBetrayerContact") == true ) then

		this.CounterList.CameraBrokenRadio = "Radio_BrokeCamera_NoHint"		-- 「監視カメラ･･･罠か」「あの調査員、俺たちをはめたのか？」

	else
		-- それ以外は何も言わない
	end

	-- 内通者接触以降であれば内通者を疑う（罠だと知ったフラグ）
	if ( TppMission.GetFlag("isBetrayerContact") == true ) then
		TppMission.SetFlag( "isGetInfo_Suspicion2", true )
		this.commonBetrayerInterrogationSetUpdate()	-- 内通者の尋問時セリフセット更新
		-- 監視カメラの諜報無線を更新
		this.commonUpdateCheckCameraIntelRadio()
	end

	-- この時点で内通者への割り当てルートが「反乱兵との会話」ルートだったら元に戻す
	local routeId = TppEnemyUtility.GetRouteId( this.BetrayerID )
	if ( routeId == GsRoute.GetRouteId("gntn_e20030_tgt_route0003") ) then
		-- 通常の巡回ルートに戻す（全体巡回ルート）
		this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic02", "gntn_e20030_tgt_route0000", 16 )
		this.commonBetrayerRouteWareHouse()
	end

	-- 任意無線を更新
	this.commonOptionalRadioUpdate()

	-- 監視カメラの諜報無線を更新
	this.commonUpdateCheckCameraIntelRadio()

end
---------------------------------------------------------------------------------
-- ■ commonSecurityCameraAlert
-- 中央管制塔監視カメラがプレイヤーを発見
this.commonSecurityCameraAlert = function()
	Fox.Log("--------commonSecurityCameraAlert--------")

	-- ここでデモ再生してみる
	-- this.commonOnSecurityCameraDemo()

	-- 発見時点でAlertでなく、発見初回で、中央管制塔監視カメラの諜報無線を聞いていなければ無線
	if ( TppEnemy.GetPhase( "gntn_cp" ) ~= "alert" and
		 TppMission.GetFlag("isCameraAlert") == false and
		 TppMission.GetFlag("isCameraIntelRadioPlay") == false ) then
		--被発見時無線コール
		if ( TppMission.GetFlag("isGetInfo_Suspicion2") == true and
			 TppMission.GetFlag("isBetrayerContact") == true ) then

			-- 内通者接触済み、罠だと知っている
			TppRadio.Play( "Radio_CameraTrap_Confidence" )	-- 「くそ！やはり罠だったか！」

		elseif ( TppMission.GetFlag("isGetInfo_Suspicion2") == false and
			 TppMission.GetFlag("isBetrayerContact") == false ) then

			-- 内通者に接触してない、罠だと知らない
			TppRadio.Play( "Radio_CameraTrap_NoContact" )		-- 「侵入がバレた！罠か？」

		elseif ( TppMission.GetFlag("isGetInfo_Suspicion2") == false and
			 TppMission.GetFlag("isBetrayerContact") == true ) then

			-- 内通者接触済み、罠だと知らない
			TppRadio.Play( "Radio_CameraTrap_Normal" )		-- 「罠か？あの諜報員ハメたのか？」

		else
			-- それ以外の場合は何も言わない
		end
	end

	-- プレイヤーを発見した
	TppMission.SetFlag( "isCameraAlert", true )

	-- Cautionルートを管制塔捜索用に変えておく
	this.commonStartForceSerching()

	-- 内通者接触済みならこの時点で内通者を疑う
	if ( TppMission.GetFlag("isBetrayerContact") == true ) then
		TppMission.SetFlag( "isGetInfo_Suspicion2", true )
	end

	this.commonBetrayerInterrogationSetUpdate()	-- 内通者の尋問時セリフセット更新

	-- この時点で内通者への割り当てルートが「反乱兵との会話」ルートだったら元に戻す
	local routeId = TppEnemyUtility.GetRouteId( this.BetrayerID )
	if ( routeId == GsRoute.GetRouteId("gntn_e20030_tgt_route0003") ) then
		-- 通常の巡回ルートに戻す（全体巡回ルート）
		this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic02", "gntn_e20030_tgt_route0000", 16 )
		this.commonBetrayerRouteWareHouse()
	end

	-- 任意無線を更新
	this.commonOptionalRadioUpdate()

	-- 監視カメラの諜報無線を更新
	this.commonUpdateCheckCameraIntelRadio()
end
---------------------------------------------------------------------------------
-- ■ commonPlayerPickItem
-- アイテムを取得した
this.commonPlayerPickItem = function()

	Fox.Log("--------commonPlayerPickItem--------")

	local ItemID			= TppData.GetArgument(1)
	local Index				= TppData.GetArgument(2)

	-- カセットテープを入手した
	if ( ItemID == "IT_Cassette" ) then
		if ( Index == 14 ) then
			this.CommonGetCassette_A()
		elseif ( Index == 15 ) then
			this.CommonGetCassette_B()
		else
			Fox.Warning( "commonPlayerPickItem:irregul TapeIndex!!" )
		end
	end

end
---------------------------------------------------------------------------------
-- ■ commonMarkerEnable
-- マーカーが付いた
this.commonMarkerEnable = function()

	Fox.Log("--------commonMarkerEnable--------")

	-- ミッション圏外を行き来するキャラへのマーカー付与状態はフラグ管理する

	local MarkerID			= TppData.GetArgument(1)

	-- トラック001
	if ( MarkerID == "Cargo_Truck_WEST_001" ) then
		TppMission.SetFlag("isMarkingTruck001", true )
	-- トラック002
	elseif ( MarkerID == "Cargo_Truck_WEST_002" ) then
		TppMission.SetFlag("isMarkingTruck002", true )
	-- 運転手001
	elseif ( MarkerID == "e20030_Driver" ) then
		TppMission.SetFlag("isMarkingDriver001", true )
	-- 運転手002
	elseif ( MarkerID == "e20030_enemy022" ) then
		TppMission.SetFlag("isMarkingDriver002", true )
	-- カセットB
	elseif ( MarkerID == "IT_Cassette" ) then
		-- スキンヘッドがドロップするとマーカー自体は付与されるがマーカーに対する細かいオプション指定はここで行う
		TppMarker.Enable( "IT_Cassette", 0, "moving", "all", 0, true, true )	-- カセットAのマーカーをオン
		TppMarkerSystem.EnableMarker{ markerId = "IT_Cassette", viewType = { "VIEW_MAP_ICON", "VIEW_WORLD_GOAL" } }
	end
end
---------------------------------------------------------------------------------
-- ■ commonSuppressorIsBroken
-- サプレッサーが壊れた
this.commonSuppressorIsBroken = function()
	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()

	if( VehicleId == "SupportHelicopter" ) then
	else
		TppRadio.DelayPlayEnqueue( "Miller_BreakSuppressor", "short" )
	end
end
---------------------------------------------------------------------------------
-- ■ After_SwitchOff
-- 停電後処理
this.After_SwitchOff = function()

	-- 敵兵停電挙動トラップＯＮ
	TppDataUtility.SetEnableDataFromIdentifier( "gntn_Trap", "SwitchLightArea", true , false )
	-- 管理棟内全監視カメラ無効化
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20030_SecurityCamera_04" , false )
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20030_SecurityCamera" , false )

	-- 停電ルートチェンジ

end
---------------------------------------------------------------------------------
-- ■ SwitchLight_ON
-- 配電盤スイッチON
this.SwitchLight_ON = function()


		-- 敵兵停電ノーティストラップＯＦＦ
		TppDataUtility.SetEnableDataFromIdentifier( "gntn_Trap", "SwitchLightArea", false , false )
		-- 管理棟全監視カメラ有効化
		TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20030_SecurityCamera_04" , true )
		TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20030_SecurityCamera" , true )

		-- 停電復帰ルートチェンジ

end
-- ■ SwitchLight_OFF
-- 配電盤スイッチOFF
this.SwitchLight_OFF = function()

	local phase = TppEnemy.GetPhase( this.cpID )

	-- 演出デモを見てなく、アラート以外の時のみ停電演出デモが流れる
	if( TppMission.GetFlag( "isSwitchLightDemo" ) == false ) and
		( phase == "sneak" or phase == "caution" or phase == "evasion" ) then

		local onDemoStart = function()
			-- 再生中の無線停止
			local radioDaemon = RadioDaemon:GetInstance()
			radioDaemon:StopDirect()
			-- 字幕の停止
			SubtitlesCommand.StopAll()
			-- カメラに映らない監視カメラを無効化する
			-- TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20030_SecurityCamera_04", false )
			TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20030_SecurityCamera", false )
			-- ボイラー室エフェクトＯＮ
			TppDataUtility.CreateEffectFromGroupId( "wtrdrpbil" )
			TppDataUtility.CreateEffectFromGroupId( "dstcomviw" )
		end
		local onDemoSkip = function()
			-- スキップ時、照明を消す
			TppGadgetUtility.SetSwitch("gntn_center_SwitchLight",false)
		end
		local onDemoEnd = function()
			-- フラグ更新
			TppMission.SetFlag( "isSwitchLightDemo", true )
			-- 停電後処理
			this.After_SwitchOff()
			-- ボイラー室エフェクトＯＦＦ
			TppDataUtility.DestroyEffectFromGroupId( "wtrdrpbil" )
			TppDataUtility.DestroyEffectFromGroupId( "dstcomviw" )
		end
		TppDemo.Play( "SwitchLightDemo" , { onStart = onDemoStart, onSkip = onDemoSkip ,onEnd = onDemoEnd } , {
			disableGame			= false,	--共通ゲーム無効を、キャンセル
			disableDamageFilter		= false,	--エフェクトは消さない
			disableDemoEnemies		= false,	--敵兵は消さないでいい
			disableEnemyReaction	= true,		--敵兵のリアクションを向こうかする
			disableHelicopter		= false,	--支援ヘリは消さないでいい
			disablePlacement		= false, 	--設置物は消さないでいい
			disableThrowing		= false	 	--投擲物は消さないでいい
		})
	-- 演出デモを見たか、アラートフェイズの時
	else
		-- 停電後処理
		this.After_SwitchOff()
	end
end
---------------------------------------------------------------------------------
-- ■ CallSignalLightSE
-- 合図サーチライトSEコール
this.CallSignalLightSE = function()

	-- モールス信号「V」:『・・・－』
	TppTimer.Start( "Timer_SignalLightON_01", 0.1 )
	TppTimer.Start( "Timer_SignalLightOFF_01", 0.3 )

	TppTimer.Start( "Timer_SignalLightON_02", 0.4 )
	TppTimer.Start( "Timer_SignalLightOFF_02", 0.6 )

	TppTimer.Start( "Timer_SignalLightON_03", 0.7 )
	TppTimer.Start( "Timer_SignalLightOFF_03", 0.9 )

	TppTimer.Start( "Timer_SignalLightON_04", 1.0 )
	TppTimer.Start( "Timer_SignalLightOFF_04", 1.4 )

	-- 画面上ライトは点いているので全部終わったら最後はONで終わる
--	TppTimer.Start( "Timer_SignalLightON_05", 1.5 )

end

this.CallSignalLightSE_ON = function()
	local characterObject = Ch.FindCharacterObjectByCharacterId( "SL_WoodTurret04" )
	local pos = characterObject:GetPosition()
	TppSoundDaemon.PostEvent3D( "sfx_s_searchlight_noise_on", pos )
end
this.CallSignalLightSE_OFF = function()
	local characterObject = Ch.FindCharacterObjectByCharacterId( "SL_WoodTurret04" )
	local pos = characterObject:GetPosition()
	TppSoundDaemon.PostEvent3D( "sfx_s_searchlight_noise_off", pos )
end
---------------------------------------------------------------------------------
-- ■■ Area Functions
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- ■ commonOutsideMissionWarningAreaEnter
-- ミッションエリア圏外に出てしまう前の警告判定
this.commonOutsideMissionWarningAreaEnter = function()
	Fox.Log("!!!!!commonOutsideMissionWarningAreaEnter!!!!!")

	-- 既に侵入済みであれば警告無線
	if ( TppMission.GetFlag("isPlayerEnterMissionArea") == true ) then
		-- いずれかのカセットを入手している
		if( TppMission.GetFlag( "isGetCassette_A" ) == true or TppMission.GetFlag( "isGetCassette_B" ) == true ) then
			TppRadio.Play( "Radio_MissionArea_Clear" )	-- クリア条件を満たしてミッション圏外
			-- クリア条件を満たしていれば圏外エフェクトは無効
			GZCommon.isOutOfMissionEffectEnable = false
		else
			TppRadio.Play( "Radio_MissionArea_Warning" )	-- ミッション圏外警告無線
			-- this.commonCallAnnounceLog( this.AnnounceLogID_AreaWarning )	-- ミッション圏外警告アナウンスログ表示
		end
		TppMission.SetFlag("isWarningMissionArea", true )
	end
end
-- ■ commonOutsideMissionWarningAreaExit
this.commonOutsideMissionWarningAreaExit = function()
	Fox.Log("!!!!!commonOutsideMissionWarningAreaExit!!!!!")
	TppMission.SetFlag("isWarningMissionArea", false )
end
---------------------------------------------------------------------------------
-- ■ OutsideAreaUniqueCharaCheck
-- ミッションエリア圏外に出た際のユニーク兵存在チェック
local OutsideAreaUniqueCharaCheck = function( charaId )

	Fox.Log( "!!!!!OutsideAreaUniqueCharaCheck!!!!!" )

	local pos		= TppPlayerUtility.GetLocalPlayerCharacter():GetPosition()	-- BOX位置
	local size		= Vector3( 20, 12, 20 )										-- BOXサイズ
	local rot		= Quat( 0.0 , 0.50, 0.0, 0.50 )								-- BOX回転
	local npcIds	= TppNpcUtility.GetNpcByBoxShape( pos, size, rot )

	-- 対象敵兵のUniqueIdを取得しておく
	local charaObj = Ch.FindCharacterObjectByCharacterId( charaId )
	if Entity.IsNull( charaObj ) then
		Fox.Log("--- OutsideAreaUniqueCharaCheck:charaObj is Null! -----")
		return false
	end
	local chara = charaObj:GetCharacter()
	local uniqueId = chara:GetUniqueId()

	-- 検索範囲内に居る敵兵のUniqueId分チェックする
	if( npcIds and #npcIds.array > 0 ) then
		for i,id in ipairs(npcIds.array) do
			Fox.Log("OutsideAreaUniqueCharaCheck::::::::ID"..id)
			-- 反乱兵のIDと照合
			if ( id == uniqueId ) then
				-- 反乱兵が居たので生存チェック
				local life = TppEnemyUtility.GetLifeStatus( id )
				Fox.Log("enemy life:"..life)
				if ( life ~= "Dead" ) then
					-- 生きているので状態チェック
					local status = TppEnemyUtility.GetStatus( id )
					Fox.Log("enemy status:"..status)
					if( status == "RideVehicle" or status == "Carried" ) then
						return true		-- 車両に載せられているor担がれているならクリア条件成立
					else
						return false
					end
				end
			end
		end
	end
	Fox.Log("--------OutsideAreaUniqueCharaCheck:FALSE-------")
	return false

end
---------------------------------------------------------------------------------
-- ■ OutsideAreaRecoveryCharaCheck
-- ミッションエリア圏外に出た際の回収した捕虜、敵兵チェック
this.OutsideAreaRecoveryCharaCheck = function()

	Fox.Log( "!!!!!OutsideAreaRecoveryCharaCheck!!!!!" )

	local pos		= TppPlayerUtility.GetLocalPlayerCharacter():GetPosition()	-- BOX位置
	local size		= Vector3( 20, 12, 20 )										-- BOXサイズ
	local rot		= Quat( 0.0 , 0.50, 0.0, 0.50 )								-- BOX回転
	local npcIds	= TppNpcUtility.GetNpcByBoxShape( pos, size, rot )
	local npctype
--	local status
--	local lifestatus
	local CharacterID

	-- 検索範囲内に居るNPCのUniqueId分チェックする
	if( npcIds and #npcIds.array > 0 ) then
		-- 人数分ループ
		for i,id in ipairs(npcIds.array) do
			Fox.Log("OutsideAreaRecoveryCharaCheck::::::::ID"..id)
			npctype = TppNpcUtility.GetNpcType( id )
			Fox.Log("npc type:"..npctype )
			-- 敵兵
			if( npctype == "Enemy" ) then
				-- UniqueIDからCharaIDを取得
				CharacterID = TppCharacterUtility.GetCharacterIdFromUniqueId( id )

				-- ユニーク兵かどうか照合
				if ( CharacterID == this.BetrayerID ) then
					-- 内通者が居たので生存チェック
					local life = TppEnemyUtility.GetLifeStatus( id )
					Fox.Log("enemy life:"..life)
					if ( life ~= "Dead" ) then
						-- 生きているので状態チェック
						local status = TppEnemyUtility.GetStatus( id )
						Fox.Log("enemy status:"..status)
						if( status == "RideVehicle" or status == "Carried" ) then
							-- 車両に載せられているor担がれているならクリア条件成立
							-- アナウンスログ表示
							this.commonCallAnnounceLog( this.AnnounceLogID_RecoveryBetrayer )
							-- 戦績反映
							PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE", this.BetrayerID )
						else
							-- それ以外は回収扱いにしない
							Fox.Log("*** Betrayer_NoRide_NoCarried ***")
						end
					end
				elseif ( CharacterID == this.MastermindID ) then
					-- 反乱兵が居たので生存チェック
					local life = TppEnemyUtility.GetLifeStatus( id )
					Fox.Log("enemy life:"..life)
					if ( life ~= "Dead" ) then
						-- 生きているので状態チェック
						local status = TppEnemyUtility.GetStatus( id )
						Fox.Log("enemy status:"..status)
						if( status == "RideVehicle" or status == "Carried" ) then
							-- 車両に載せられているor担がれているならクリア条件成立
							-- アナウンスログ表示
							this.commonCallAnnounceLog( this.AnnounceLogID_RecoveryMastermind )
							-- 戦績反映
							PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE", this.MastermindID )
						else
							-- それ以外は回収扱いにしない
							Fox.Log("*** Mastermind_NoRide_NoCarried ***")
						end
					end
				else
					-- 通常敵兵が居たので生存チェック
					local life = TppEnemyUtility.GetLifeStatus( id )
					Fox.Log("enemy life:"..life)
					if ( life ~= "Dead" ) then
						-- 生きているので状態チェック
						local status = TppEnemyUtility.GetStatus( id )
						Fox.Log("enemy status:"..status)
						if( ( status == "RideVehicle" or status == "Carried" ) and
							( this.CounterList.PlayerOnCargo == "NoRide" ) ) then	-- プレイヤーがトラック荷台に居る場合は除外
							-- 車両に載せられているor担がれているならクリア条件成立
							-- アナウンスログ表示
							this.commonCallAnnounceLog( "announce_collection_enemy" )
							-- 戦績反映
							PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE" )
						else
							-- それ以外は回収扱いにしない
							Fox.Log("*** NormalEnemy_NoRide_NoCarried ***")
						end
					end
				end
			-- 捕虜
			elseif( npctype == "Hostage" ) then
				-- 捕虜が居たので生存チェック
				local life = TppHostageUtility.GetStatus( id )
				Fox.Log("hostage life:"..life)
				if ( life ~= "Dead" ) then
					-- 生きているので状態チェック
					local status = TppHostageUtility.GetStatus( id )
					Fox.Log("hostage status:"..status)
					if( status == "RideOnVehicle" or status == "Carried" ) then
						-- 車両に載せられているor担がれているならクリア条件成立
						CharacterID = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
						-- 「アナウンスログ表示」「戦績（PlayRecord）反映」
						GZCommon.NormalHostageRecovery( CharacterID )
					else
						-- それ以外は回収扱いにしない
						Fox.Log("*** Hostage_NoRide_NoCarried ***")
					end
				end
			end
		end
	end
end
---------------------------------------------------------------------------------
-- ■ commonOutsideMissionArea
-- ミッションエリア圏外の判定
this.commonOutsideMissionArea = function()
	Fox.Log("!!!!!commonOutsideMissionArea!!!!!")

	-- ミッション圏外警告を受けている状態であれば判定する
	-- 基地の外から入ってくる初回侵入時（ミッション開始直後：トラック荷台に潜んで潜入）は何もしない
	if ( TppMission.GetFlag("isWarningMissionArea") == true ) then

		-------- まずミッションクリアor失敗を判定 --------
		-- いずれかのカセット入手していればミッション圏外脱出クリアシーケンスへ遷移
		if( TppMission.GetFlag( "isGetCassette_A" ) == true or TppMission.GetFlag( "isGetCassette_B" ) == true ) then

			-- 回収した敵兵、捕虜、ユニーク兵のチェック
			this.OutsideAreaRecoveryCharaCheck()

			this.commonMissionClearRequest( "EscapeArea_Clear" )

		-- いずれのカセット入手していなければ
		elseif( TppMission.GetFlag( "isGetCassette_A" ) == false and TppMission.GetFlag( "isGetCassette_B" ) == false ) then

				TppMission.ChangeState( "failed", "OutsideMissionArea" )

		else
			-- ここに来ることはないはず
			Fox.Warning("commonOutsideMissionArea:ERROR")
		end

	else
		-- ここに来るのはミッション開始時のみ
		Fox.Log("commonOutsideMissionArea:MissionStart")
	end
end
---------------------------------------------------------------------------------
-- ■ commonPlayerEnterMissionArea
-- ミッション圏内に入ったためトラックから降りられるようしてシーケンスを進める
this.commonPlayerEnterMissionArea = function()
	Fox.Log("!!!!!!!!!!!!PlayerEnterMissionArea!!!!!!!!!!!!!!!!")

	if ( TppMission.GetFlag("isPlayerEnterMissionArea") == false ) then
		-- エリア侵入時にフラグON
		TppMission.SetFlag("isPlayerEnterMissionArea", true )

		-- ミッション圏外エフェクトを有効化
		GZCommon.isOutOfMissionEffectEnable = true

	end
end
---------------------------------------------------------------------------------
-- ■ commonPlayerAreacampEast
-- プレイヤー所属エリア：campEast
this.commonPlayerAreacampEast = function()
	-- Fox.Log("----------------commonPlayerAreacampEast----------------")
	this.CounterList.PlayerArea = "Area_campEast"

	-- ヘリのデフォルトRVを更新
--	TppSupportHelicopterService.SetDefaultRendezvousPointMarker("RV_SeaSide")
	-- ガードターゲット更新チェック
	this.commonUpdateGuardTarget()
end
-- ■ commonPlayerAreacampWest
-- プレイヤー所属エリア：campWest
this.commonPlayerAreacampWest = function()
	-- Fox.Log("----------------commonPlayerAreacampWest----------------")
	this.CounterList.PlayerArea = "Area_campWest"

	-- ヘリのデフォルトRVを更新
--	TppSupportHelicopterService.SetDefaultRendezvousPointMarker("RV_StartCliff")
	-- ガードターゲット更新チェック
	this.commonUpdateGuardTarget()
end
-- ■ commonPlayerAreaControlTower
-- プレイヤー所属エリア：ControlTower
this.commonPlayerAreaControlTower = function()
	-- Fox.Log("----------------commonPlayerAreaControlTower----------------")
	this.CounterList.PlayerArea = "Area_ControlTower"

	-- ヘリのデフォルトRVを更新
--	TppSupportHelicopterService.SetDefaultRendezvousPointMarker("RV_HeliPort")
	-- ガードターゲット更新チェック
	this.commonUpdateGuardTarget()
end
---------------------------------------------------------------------------------
-- ■ commonBetrayerRoutecampEast
-- 内通者使用ルート：campEast（東難民キャンプ）
this.commonBetrayerRoutecampEast = function()

	-- Fox.Log("----------------commonBetrayer:RoutecampEast----------------")
	-- this.CounterList.BetrayerArea = "Area_campEast"
	TppMission.SetFlag( "BetrayerArea", this.Area_campEast )

end
-- ■ commonBetrayerRoutecampWest
-- 内通者使用ルート：campWest（西難民キャンプ：合図チェッククルート）
this.commonBetrayerRoutecampWest = function()

	-- Fox.Log("----------------commonBetrayer:RoutecampWest----------------")
	-- this.CounterList.BetrayerArea = "Area_campWest"
	TppMission.SetFlag( "BetrayerArea", this.Area_campWest )

end
-- ■ commonBetrayerRouteHeliport
-- 内通者使用ルート：Heliport（ヘリポート）
this.commonBetrayerRouteHeliport = function()

	-- Fox.Log("----------------commonBetrayer:RouteHeliport----------------")
	-- this.CounterList.BetrayerArea = "Area_Heliport"
	TppMission.SetFlag( "BetrayerArea", this.Area_Heliport )

end
-- ■ commonBetrayerRouteWareHouse
-- 内通者使用ルート：WareHouse（倉庫エリア）
this.commonBetrayerRouteWareHouse = function()

	-- Fox.Log("----------------commonBetrayer:RouteWareHouse----------------")
	TppMission.SetFlag( "BetrayerArea", this.Area_WareHouse )

end

---------------------------------------------------------------------------------
-- ■ commonPlayerRideOnCargo
-- プレイヤーがトラックの荷台に乗った
this.commonPlayerRideOnCargo = function()

	local Type = TppData.GetArgument(2)

	if ( Type == "Truck" ) then
		-- 搭乗中の車両のCharaIdを保持
		this.CounterList.PlayerOnCargo = TppData.GetArgument(1)
		-- Fox.Log("----------------commonPlayerRideOnCargo----------------"..this.CounterList.PlayerOnCargo)
	end
end
-- ■ commonPlayerGetOffCargo
-- プレイヤーがトラックの荷台から降りた
this.commonPlayerGetOffCargo = function()

	this.CounterList.PlayerOnCargo = "NoRide"
	-- Fox.Log("----------------commonPlayerGetOffCargo----------------"..this.CounterList.PlayerOnCargo)

	-- 内通者接触シーケンスでかつ「要するにやること無線」が再生予約されていたらここで再生
	if ( TppSequence.GetCurrentSequence() == "Seq_Waiting_BetrayerContact" and
		 TppMission.GetFlag( "isRadio_SimpleObjectivePlay" ) == true ) then

		TppRadio.DelayPlay( "Radio_SimpleObjective", "long", "both" )
		TppMission.SetFlag( "isRadio_SimpleObjectivePlay", false )
	end
end
-- ■ commonPlayerRideOnVehicle
-- プレイヤーが車両に乗った
this.commonPlayerRideOnVehicle = function()
	local VehicleID = TppData.GetArgument(2)
	local hudCommonData = HudCommonDataManager.GetInstance()
	-- 機銃装甲車の場合
	if VehicleID == "WheeledArmoredVehicleMachineGun" then
		if( TppMission.GetFlag( "isAVMTutorial" ) == false ) then
			-- 初回はポーズ・装甲車の操作方法
			hudCommonData:CallButtonGuide( "tutorial_pause", fox.PAD_SELECT )
			hudCommonData:CallButtonGuide( "tutorial_apc", fox.PAD_Y )
			TppMission.SetFlag( "isAVMTutorial", true )
		else
			hudCommonData:CallButtonGuide( "tutorial_vehicle_attack", fox.PAD_L1 )
		end
	elseif VehicleID == "SupportHelicopter" then
		--
	else
--		if( TppMission.GetFlag( "isCarTutorial" ) == false ) then				--乗り物チュートリアルボタンを表示していないなら
			-- RT アクセルボタン
			hudCommonData:CallButtonGuide( "tutorial_accelarater", "VEHICLE_TRIGGER_ACCEL" )
			-- LT バックボタン
			hudCommonData:CallButtonGuide( "tutorial_brake", "VEHICLE_TRIGGER_BREAK" )

			TppMission.SetFlag( "isCarTutorial", true )							--乗り物チュートリアルボタンを表示した
--		end
	end
end
---------------------------------------------------------------------------------
-- ■ commonSequenceSaveIndefinite
-- 場所が不定な場合のSequenceSave処理
this.commonSequenceSaveIndefinite = function()

	-- プレイヤーの現在地から復帰位置を決定する
	if ( GZCommon.PlayerAreaName == "WareHouse" ) then
		TppMissionManager.SaveGame("20")
	elseif ( GZCommon.PlayerAreaName == "Asylum" ) then
		TppMissionManager.SaveGame("21")
	elseif ( GZCommon.PlayerAreaName == "EastCamp" ) then
		TppMissionManager.SaveGame("22")
	elseif ( GZCommon.PlayerAreaName == "WestCamp" ) then
		TppMissionManager.SaveGame("23")
	elseif ( GZCommon.PlayerAreaName == "Heliport" ) then
		TppMissionManager.SaveGame("24")
	elseif ( GZCommon.PlayerAreaName == "ControlTower_East" ) then
		TppMissionManager.SaveGame("25")
	elseif ( GZCommon.PlayerAreaName == "ControlTower_West" ) then
		TppMissionManager.SaveGame("26")
	elseif ( GZCommon.PlayerAreaName == "SeaSide" ) then
		TppMissionManager.SaveGame("27")
	else
		Fox.Log(" commonSequenceSaveIndefinite:GZCommon.PlayerAreaName illegality:".. GZCommon.PlayerAreaName )
		TppMissionManager.SaveGame("20")	-- 保険処理としてSave
	end

end
---------------------------------------------------------------------------------
-- ■■ Route Functions
---------------------------------------------------------------------------------
-- ■ commonBetrayerRouteDisable
-- 内通者用のRouteを使用禁止登録する
this.commonBetrayerRouteDisable = function()

	-- 内通者専用のルートは使用禁止登録（将来的にはDisableではなく「ユニークキャラ用登録」のような方式になる予定）
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_tgt_route0000" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_tgt_route0001" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_tgt_route0002" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_tgt_route0003" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_tgt_route9001" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_tgt_route9002" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_tgt_route9003" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_tgt_route9900" )

end

-- ■ commonAssistantrRouteDisable
-- 取り巻き兵用のRouteを使用禁止登録する
this.commonAssistantrRouteDisable = function()

	-- 取り巻き兵専用のルートは使用禁止登録（将来的にはDisableではなく「ユニークキャラ用登録」のような方式になる予定）
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_ast_route0000" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_ast_route0001" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_ast_route9001" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_ast_route9002" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_ast_route9003" )
	TppEnemy.DisableRoute( "gntn_cp", "gntn_e20030_ast_route9900" )

end
---------------------------------------------------------------------------------
-- ■ ChangeBetrayerRoute
-- 内通者のルート切り替え
this.ChangeBetrayerRoute = function( routeSet, routeID, nodeNum)
	Fox.Log("--------ChangeBetrayerRoute-------")

	-- 内通者専用ルートの一括使用不可登録
	this.commonBetrayerRouteDisable()
	-- 切り替え先のルートのみ使用許可登録
	TppEnemy.EnableRoute( "gntn_cp", routeID )
	-- ルートチェンジ（優先度指定）
	TppEnemy.ChangeRoute( "gntn_cp", this.BetrayerID,	routeSet, routeID, nodeNum )
end
---------------------------------------------------------------------------------
-- ■ ChangeAssistantRoute
-- 取り巻き兵のルート切り替え
this.ChangeAssistantRoute = function( routeSet, routeID, nodeNum)
	Fox.Log("--------ChangeAssistantRoute-------")

	-- 取り巻き兵専用ルートの一括使用不可登録
	this.commonAssistantrRouteDisable()
	-- 切り替え先のルートのみ使用許可登録
	TppEnemy.EnableRoute( "gntn_cp", routeID )
	-- ルートチェンジ（優先度指定）
	TppEnemy.ChangeRoute( "gntn_cp", this.AssistantID,	routeSet, routeID, nodeNum )
end
---------------------------------------------------------------------------------
-- ■ commonBetrayerRoutePoint
-- 内通者のルート行動管理：到達判定 将来的にツーマンセルさせる可能性もあるので今は取り巻き兵もここでまとめて管理
-- ToDo 内通者接触後のSneakRouteSetの場合も考慮する
this.commonBetrayerRoutePoint = function()
	-- Fox.Log("-------!!!!!!!!!!!commonBetrayerRoutePoint!!!!!!!!!!!!------")
	local RouteName				= TppData.GetArgument(3)
	local RoutePointNumber			= TppData.GetArgument(1)

	-- 内通者巡回：倉庫エリア
	if( RouteName == GsRoute.GetRouteId("gntn_e20030_tgt_route0000")  ) then
		if( ( RoutePointNumber >= 17 ) and ( this.CounterList.PlayerArea == "Area_ControlTower" )) then
			Fox.Log(" commonBetrayerRoutePoint RouteName:"..RouteName.."wareHouse→Heliport")

			-- ヘリポートへルートチェンジ
			this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route0002", 0 )
			this.commonBetrayerRouteHeliport()

		elseif ( ( RoutePointNumber >= 19 ) and ( this.CounterList.PlayerArea == "Area_campEast")) then
			Fox.Log(" commonBetrayerRoutePoint RouteName:"..RouteName.."wareHouse→campEast")

			-- 東側キャンプへルートチェンジ
			this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route0001", 0 )
			this.commonBetrayerRoutecampEast()

		end
	-- 内通者巡回：東側キャンプ
	elseif( RouteName == GsRoute.GetRouteId("gntn_e20030_tgt_route0001")  ) then
		if( ( (RoutePointNumber == 3) or (RoutePointNumber == 8) or (RoutePointNumber == 14) ) and
			  ( this.CounterList.PlayerArea == "Area_ControlTower")) then
			Fox.Log(" commonBetrayerRoutePoint RouteName:"..RouteName.."campEast→Heliport")

			-- ヘリポートへルートチェンジ
			this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route0002", 0 )
			this.commonBetrayerRouteHeliport()

		elseif ( ( (RoutePointNumber == 3) or (RoutePointNumber == 8) or (RoutePointNumber == 14) ) and
			  ( this.CounterList.PlayerArea == "Area_campWest")) then
			Fox.Log(" commonBetrayerRoutePoint RouteName:"..RouteName.."campEast→campWest")

			-- 倉庫エリアへルートチェンジ
			this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route0000", 0 )
			this.commonBetrayerRouteWareHouse()

		end
	-- 内通者巡回：ヘリポート
	elseif( RouteName == GsRoute.GetRouteId("gntn_e20030_tgt_route0002")  ) then
		if(( (RoutePointNumber == 7) or (RoutePointNumber == 8) or (RoutePointNumber == 14) or (RoutePointNumber == 15) ) and
			  ( this.CounterList.PlayerArea == "Area_campEast")) then
			Fox.Log(" commonBetrayerRoutePoint RouteName:"..RouteName.."Heliport→campEast")

			-- 東側キャンプへルートチェンジ
			this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route0001", 0 )
			this.commonBetrayerRoutecampEast()

		elseif(( (RoutePointNumber == 7) or (RoutePointNumber == 8) or (RoutePointNumber == 14) or (RoutePointNumber == 15) ) and
			  ( this.CounterList.PlayerArea == "Area_campWest")) then
			Fox.Log(" commonBetrayerRoutePoint RouteName:"..RouteName.."Heliport→campWest")

			-- 倉庫エリアへルートチェンジ
			this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route0000", 0 )
			this.commonBetrayerRouteWareHouse()

		end
	-- 内通者の合図チェック前待機ルート
	elseif( RouteName == ( GsRoute.GetRouteId("gntn_e20030_tgt_route9900")) ) then

		if( RoutePointNumber == 0 ) then
			TppMission.SetFlag( "isBetrayerSignalCheckWait", true )	-- 到着済み
		-- 取り巻き兵が既に到着済みor無力化されているか ToDo保険処理としてタイムアウトも入れる
		elseif ( TppMission.GetFlag( "isAssistantSignalCheckWait" ) == true or this.commonCheckAssistantStatus() == false ) then
			Fox.Log(" Betrayer::SignalCheckRoute:SetUpComplete ")


			-- 取り巻き兵が元気なら一緒に行動しているフラグを立てる
			if ( this.commonCheckAssistantStatus() ) then
				TppMission.SetFlag( "isBetrayerTogether", true )
			end

			this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route9001", 0 )
			this.ChangeAssistantRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_ast_route9001", 0 )

			this.commonBetrayerRoutecampWest()

		end
	-- 取り巻きの合図チェック前待機ルート
	elseif( RouteName == ( GsRoute.GetRouteId("gntn_e20030_ast_route9900")) ) then
		if( RoutePointNumber == 0 ) then
			TppMission.SetFlag( "isAssistantSignalCheckWait", true )	-- 到着済み
		elseif ( TppMission.GetFlag( "isBetrayerSignalCheckWait" ) == true ) then
			Fox.Log(" Assistant::SignalCheckRoute:SetUpComplete ")

			-- 一緒に行動しているフラグを立てる
			TppMission.SetFlag( "isBetrayerTogether", true )

			this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route9001", 0 )
			this.ChangeAssistantRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_ast_route9001", 0 )

		end
	-- 内通者の合図チェック移動ルート
	elseif( RouteName == ( GsRoute.GetRouteId("gntn_e20030_tgt_route9001")) ) then
		if( RoutePointNumber == 4 ) then
			-- Playerが西難民キャンプ付近に居るか？
			if( TppMission.GetFlag( "isPlayerInWestCamp" ) == true ) then
				-- 内通者特定済みか
				if( TppMission.GetFlag( "isBetrayerMarking" ) == true ) then
					-- 合図実行時点で内通者を特定済みなら
					if ( TppMission.GetFlag( "isNotMarkBeforeSignal" ) == false ) then
						Fox.Log("Betrayer::SignalCheckMoveRoute::CheckCallRadio")
						-- 取り巻き兵が居る
						if ( this.commonCheckAssistantStatus() == true ) then
							local Play_AppearedAssistant = { "Radio_AppearedBetrayer", "Radio_AppearedAssistant" }
							TppRadio.Play( Play_AppearedAssistant )

						else
							TppRadio.Play( "Radio_AppearedBetrayer" )
						end
					end
				else
					-- Playerが内通者特定前なら促し無線
					TppRadio.Play( "Radio_IsThatBetrayer" )	-- 「あれは･･･？」
				end
			end
		elseif ( RoutePointNumber == 15 ) then
			Fox.Log("Betrayer::SignalCheckMoveRoute_Arrive")

			-- 会話イベントを有効にしておく
			TppCommandPostObject.GsSetConversationEnableFlag( "gntn_cp", "CTE0030_0010" , true )

			-- 合図チェックルートに切り替え
			this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route9002", 0 )
			this.commonBetrayerRoutecampWest()

			-- 合図チェックルートに切り替え
			this.ChangeAssistantRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_ast_route9002", 0 )

		end
	-- 取り巻き兵の合図チェック移動ルート
	elseif( RouteName == ( GsRoute.GetRouteId("gntn_e20030_ast_route9001")) ) then
		if( RoutePointNumber == 15 ) then
			-- 合図チェックルートに切り替え
			this.ChangeAssistantRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_ast_route9002", 0 )

		end
	-- 内通者の合図チェックルート
	elseif( RouteName == ( GsRoute.GetRouteId("gntn_e20030_tgt_route9002")) ) then
		if( RoutePointNumber == 1 ) then
			Fox.Log("Betrayer::SignalCheckRoute_Arrive")

			-- 合図チェック完了後ルートに切り替え
			this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route9003", 0 )
			this.ChangeAssistantRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_ast_route9003", 0 )
			this.commonBetrayerRoutecampWest()
		end
	-- 取り巻き兵の合図チェックルート
	elseif( RouteName == ( GsRoute.GetRouteId("gntn_e20030_ast_route9002")) ) then
		-- Fox.Log("取り巻き兵の合図チェックルート")
		-- 内通者のルートチェック
		local routeId = TppEnemyUtility.GetRouteId( this.BetrayerID )
		-- 内通者が合図チェック中で無ければ保険処理
		if( RoutePointNumber == 1 and
			routeId ~= GsRoute.GetRouteId("gntn_e20030_tgt_route9002") ) then
			Fox.Log("Assistant::SignalCheckRoute_Arrive")
			-- 保険処理：合図チェック完了後ルートに切り替え
			this.ChangeAssistantRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_ast_route9003", 0 )
		end
	-- 内通者の合図チェック完了後ルート
	elseif( RouteName == ( GsRoute.GetRouteId("gntn_e20030_tgt_route9003")) ) then
		if( RoutePointNumber == 0 ) then
			-- 取り巻き兵を合図チェック完了後ルートに切り替え
			this.ChangeAssistantRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_ast_route9003", 0 )

		elseif( RoutePointNumber == 18 ) then
			-- 通常の巡回ルートに戻す（倉庫エリア巡回ルート）
			this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route0000", 11 )
			this.commonBetrayerRouteWareHouse()
			-- 合図確認イベント終了
			TppMission.SetFlag( "isSignalCheckEventEnd", true )

		end
	-- 取り巻き兵の合図チェック完了後ルート
	elseif( RouteName == ( GsRoute.GetRouteId("gntn_e20030_ast_route9003")) ) then

		if( RoutePointNumber == 10 ) then

			-- 一緒に行動しているフラグを下げる
			TppMission.SetFlag( "isBetrayerTogether", false )

			-- 内通者の周囲に居るアクティブな敵兵数を取得
			local enemyNum = TppEnemyUtility.GetNumberOfActiveSoldierByCharacterId( this.BetrayerID, this.Size_ActiveEnemy )
			-- 内通者特定済みで、周囲に敵兵が取り巻き兵以外居ない
			if( TppMission.GetFlag( "isBetrayerMarking" ) == true and enemyNum <= 1) then
				-- Playerが西難民キャンプ付近に居るか？
				if( TppMission.GetFlag( "isPlayerInWestCamp" ) == true ) then
					-- 内通者が一人になったな無線コール
					local radioGroup = {"Radio_DisablementAssistant", "Radio_MarkingBetrayer2" }
					TppRadio.Play( "Radio_DisablementAssistant" )
				end
			end

		elseif(  RoutePointNumber == 17 ) then

			Fox.Log("Assistant_SignalCheckAfterRoute:END")
			-- 通常の巡回ルートに戻す
			this.ChangeAssistantRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_ast_route0000", 60 )
			-- 取り巻き兵の優先Realiza指定を解除
			TppCommandPostObject.GsSetRealizeFirstPriority( "gntn_cp", this.AssistantID, false )

		end
	-- 内通者の接触デモ後の会話イベント用ルート
	elseif( RouteName == ( GsRoute.GetRouteId("gntn_e20030_tgt_route0003")) ) then
		-- if( RoutePointNumber == 0 ) then
			Fox.Log("*** Betrayer_AfterContactDemoRoute ***")

			this.commonBetrayerRouteWareHouse()	-- 所属エリア更新

			-- 会話イベントが終了したorプレイヤーが監視カメラに見つかっていたor壊されていたorカセットBを取得済みなら巡回ルートに戻す
			if ( TppMission.GetFlag( "isMastermindConversationEnd" ) == true or
				 TppMission.GetFlag( "isCameraAlert" ) == true or
				 TppMission.GetFlag( "isCameraBroken" ) == true or
				 TppMission.GetFlag( "isGetCassette_B" ) == true or
				 TppMission.GetFlag( "isGetInfo_Mastermind" ) == true ) then
				Fox.Log("*** Betrayer_AfterContactDemoRoute__END ***")
				-- 通常の巡回ルートに戻す（全体巡回ルート）
				this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic02", "gntn_e20030_tgt_route0000", 16 )
				this.commonBetrayerRouteWareHouse()
			end
		--end
	else
		--RouteName = commonGetGsRouteRouteName( RouteName )
		--commonPrint2D("■WARNING■ commonBetrayerRoutePoint RouteName:"..RouteName)
	end
end
---------------------------------------------------------------------------------
-- ■ commonDemoSoldierRoutePoint
-- デモ登場敵兵のルート行動管理：到達判定
this.commonDemoSoldierRoutePoint = function()
	-- Fox.Log("-------!!!!!!!!!!!commonDemoSoldierRoutePoint!!!!!!!!!!!!------")
	local RouteName				= TppData.GetArgument(2)
	local RoutePointNumber		= TppData.GetArgument(3)

	-- デモ中にミッション圏外から歩いてくるルート2本のうちどちらでも
	if( RouteName == GsRoute.GetRouteId("gntn_e20030_add_route0002") or RouteName == GsRoute.GetRouteId("gntn_e20030_add_route0003") ) then
		if( RoutePointNumber >= 14 ) then
			-- Fox.Log(" commonDemoSoldierRoutePoint RouteName:"..RouteName )

			-- 使用していたルートを使用禁止にして巡回させる予定だったルートを使用可能にする
			TppCommandPostObject.GsSetExclusionRoutes( "gntn_cp", "gntn_common_d01_route0010", "gntn_e20030_add_route0002" )
			TppCommandPostObject.GsSetExclusionRoutes( "gntn_cp", "gntn_common_d01_route0011", "gntn_e20030_add_route0003" )

		end
	else

	end
end
---------------------------------------------------------------------------------
-- ■ commonDriverRoutePoint
-- トラック運転手のルート行動管理：到達判定
this.commonDriverRoutePoint = function()
	Fox.Log("-------!!!!!!!!!!!commonDriverRoutePoint!!!!!!!!!!!!------")
	local RouteName				= TppData.GetArgument(2)
	local RoutePointNumber		= TppData.GetArgument(3)

	-- 管理棟内部ルート
	if( RouteName == GsRoute.GetRouteId( "gntn_common_d01_route0028" ) ) then
		Fox.Log("---commonDriverRoutePoint:RouteName:::"..RouteName )
		if( RoutePointNumber >= 2 and RoutePointNumber <= 9 ) then
			Fox.Log("---commonDriverRoutePoint:RoutePointNumber:::"..RoutePointNumber )
			-- プレイヤーがクリア条件を満たして管理棟内のトラック荷台に乗っていたら
			if ( TppMission.GetFlag( "isGetCassette_A" ) == true or TppMission.GetFlag( "isGetCassette_B" ) == true ) and
			   ( this.CounterList.PlayerOnCargo == "Cargo_Truck_WEST_001" ) then
			   	Fox.Log("---commonDriverRoutePoint:RouteChange---" )

				-- 即座に車両に乗り込んで出発させるために接続用ルートにのせる（各RouteSetにまとめて発行）
				TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0028" )		-- その間他の敵兵が乗らないようにしておく
				TppEnemy.EnableRoute( "gntn_cp", "gntn_common_d01_route0128" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "e20030_routeSet_d01_basic01", "gntn_common_d01_route0128", 0, "e20030_Driver" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "e20030_routeSet_d01_basic02", "gntn_common_d01_route0128", 0, "e20030_Driver" )
			end
		end

	elseif( RouteName == GsRoute.GetRouteId( "gntn_common_d01_route0128" ) ) then
		Fox.Log("---commonDriverRoutePoint:RouteName:::"..RouteName )
		if( RoutePointNumber > 1 ) then
			Fox.Log("---commonDriverRoutePoint:RoutePointNumber:::"..RoutePointNumber )

				-- 再び元のルートに戻して即座に車両に乗り込んで出発させる
				TppEnemy.EnableRoute( "gntn_cp", "gntn_common_d01_route0028" )
				TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0128" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "e20030_routeSet_d01_basic01", "gntn_common_d01_route0028", 10, "e20030_Driver" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "e20030_routeSet_d01_basic02", "gntn_common_d01_route0028", 10, "e20030_Driver" )

		end
	end

end

---------------------------------------------------------------------------------
-- ■ ChangeSignalCheckRoute
-- 内通者と取り巻きをツーマンセル合図確認ルートへ切り替える
this.ChangeSignalCheckRoute = function( flag )
	Fox.Log("--------ChangeSignalCheckRoute-------")

	local Flag = flag or "Normal"

	-- このイベント中は取り巻き兵を優先Realiza指定しておく
	TppCommandPostObject.GsSetRealizeFirstPriority( "gntn_cp", this.AssistantID, true )

	if ( flag == "Normal" ) then
		-- ユニークキャラ専用ルートの一括使用不可登録と切り替え先のルートのみ使用許可登録
		this.commonBetrayerRouteDisable()
		this.commonAssistantrRouteDisable()
		TppEnemy.EnableRoute( "gntn_cp", "gntn_e20030_tgt_route9900" )
		TppEnemy.EnableRoute( "gntn_cp", "gntn_e20030_ast_route9900" )

		-- それぞれ別々のルートを設定
		TppEnemy.ChangeRoute( "gntn_cp", this.BetrayerID,	"e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route9900", 0 )
		TppEnemy.ChangeRoute( "gntn_cp", this.AssistantID,	"e20030_routeSet_d01_basic01", "gntn_e20030_ast_route9900", 0 )

	elseif (flag == "Continue" ) then

		-- 一緒に行動しているフラグを立てる
		TppMission.SetFlag( "isBetrayerTogether", true )

		this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_tgt_route9001", 0 )
		this.ChangeAssistantRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_ast_route9001", 0 )

	end
end
---------------------------------------------------------------------------------
-- ■ commonVehicleRouteUpdate
-- 車両のルート行動監視
this.commonVehicleRouteUpdate = function()

	local vehicleGroupInfo	= TppData.GetArgument(2)

	local vehicleInfoName	= vehicleGroupInfo.routeInfoName			-- RouteInfデータ名
	local vehicleCharaID	= vehicleGroupInfo.vehicleCharacterId		-- 車両のキャラID
	local routeID			= vehicleGroupInfo.vehicleRouteId			-- 車両ルートのルートID
	local routeNodeIndex	= vehicleGroupInfo.passedNodeIndex			-- 到達したルートノードのインデックス
	local memberCharaIDs	= vehicleGroupInfo.memberCharacterIds		-- 乗車しているキャラのID

	local driverCharaID		= memberCharaIDs[1]

	Fox.Log("-------!!!!!!!!!!!commonVehicleRouteUpdate!!!!---"..vehicleGroupInfo.passedNodeIndex)

	-- 輸送トラックA：（西検問→管理棟内部）
	if( (vehicleInfoName == "VehicleRouteInfo_common_v01_0000") or (vehicleInfoName == "VehicleDefaultRideRouteInfo_e20030")) then
		-- 西検問→管制塔ゲート前
		if ( routeID == GsRoute.GetRouteId( "gntn_common_v01_route0010" ) ) then
			if ( routeNodeIndex == 0 ) then
				-- 検問区画通過中フラグを立てる
				this.CounterList.WestTruckStatus = -1
			elseif ( routeNodeIndex == 1 ) then
				-- 圏外から入ってきたので既にマーキング済みであればマーカーを付与する
				if ( TppMission.GetFlag("isMarkingTruck001") == true ) then
					TppMarker.Enable( "Cargo_Truck_WEST_001", 0, "none", "map_and_world_only_icon", 0, false, false )
				elseif ( TppMission.GetFlag("isMarkingDriver001") == true ) then
					TppMarkerSystem.EnableMarker{ markerId = "e20030_Driver", viewType = { "VIEW_MAP_ICON", "VIEW_WORLD_ICON" } }
				end
			elseif ( routeNodeIndex == 3 ) then
				-- 検問区画通過中フラグを下げる
				this.CounterList.WestTruckStatus = 0
			end
		-- 管制塔ゲート前→管理棟内部
		elseif ( routeID == GsRoute.GetRouteId( "gntn_common_v01_route0011" ) ) then

			if ( routeNodeIndex == 1 ) then
				-- とりあえずすぐゲート閉鎖
				-- GZCommon.Common_CenterBigGate_Close()
			end
		end
	-- 輸送トラックA：（管理棟内部→西検問）
	elseif( vehicleInfoName == "VehicleRouteInfo_common_v01_0001" ) then
		-- 管制塔内部→西検問
		if( routeID == GsRoute.GetRouteId( "gntn_common_v01_route0020" ) ) then
			if ( routeNodeIndex == 2 ) then
				-- ゲートへの閉鎖リクエスト
				GZCommon.Common_CenterBigGate_Close()
			elseif ( routeNodeIndex == 11 and  TppMission.GetFlag("isInspectionActive") == true ) then
				-- 検問設置済みなら退避ルートにルートチェンジ
				TppCommandPostObject.GsSetGroupVehicleRoute( "gntn_cp", "Cargo_Truck_WEST_001", "gntn_common_v01_route0025", 12 )
			elseif ( routeNodeIndex == 12 and  TppMission.GetFlag("isInspectionActive") == true ) then
				-- 検問設置済みなら退避ルートにルートチェンジ
				TppCommandPostObject.GsSetGroupVehicleRoute( "gntn_cp", "Cargo_Truck_WEST_001", "gntn_common_v01_route0025", 13 )
			elseif ( routeNodeIndex == 17 ) then
				-- 圏外に抜けたのでマーカーを消す
				TppMarkerSystem.DisableMarker{ markerId="Cargo_Truck_WEST_001" }
				TppMarkerSystem.DisableMarker{ markerId="e20030_Driver" }
			end
			-- 到達済みNode番号+1を保持していく
			this.CounterList.WestTruckStatus = routeNodeIndex + 1
		end
	-- 輸送トラックB：（北検問→倉庫エリア）
	elseif( vehicleInfoName == "VehicleRouteInfo_common_v02_0000" ) then
		-- 北検問→倉庫エリア
		if( routeID == GsRoute.GetRouteId( "gntn_common_v02_route0000" ) ) then
			if ( routeNodeIndex == 0 ) then
				-- 検問区画通過中フラグを立てる
				this.CounterList.NorthTruckStatus = -1
			elseif ( routeNodeIndex == 2 ) then
				-- 圏外から入ってきたので既にマーキング済みであればマーカーを付与する
				if ( TppMission.GetFlag("isMarkingTruck002") == true ) then
					TppMarker.Enable( "Cargo_Truck_WEST_002", 0, "none", "map_and_world_only_icon", 0, false, false )
				elseif ( TppMission.GetFlag("isMarkingDriver002") == true ) then
					TppMarkerSystem.EnableMarker{ markerId = "e20030_enemy022", viewType = { "VIEW_MAP_ICON", "VIEW_WORLD_ICON" } }
				end
			elseif ( routeNodeIndex == 5 ) then
				-- 検問区画通過中フラグを下げる
				this.CounterList.NorthTruckStatus = 0
			end
		end
	-- 輸送トラックB：（倉庫エリア→北検問）
	elseif( vehicleInfoName == "VehicleRouteInfo_common_v02_0001" ) then
		-- 倉庫エリア→北検問
		if( routeID == GsRoute.GetRouteId( "gntn_common_v02_route0001" ) ) then
			if ( routeNodeIndex == 6 and  TppMission.GetFlag("isInspectionActive") == true ) then
				Fox.Log("-------VehicleRouteChange!!!!-----"..routeNodeIndex)
				-- 検問設置済みなら退避ルートにルートチェンジ
				TppCommandPostObject.GsSetGroupVehicleRoute( "gntn_cp", "Cargo_Truck_WEST_002", "gntn_common_v02_route0005", 7 )
			elseif ( routeNodeIndex == 7 and  TppMission.GetFlag("isInspectionActive") == true ) then
				Fox.Log("-------VehicleRouteChange!!!!-----"..routeNodeIndex)
				-- 検問設置済みなら退避ルートにルートチェンジ
				TppCommandPostObject.GsSetGroupVehicleRoute( "gntn_cp", "Cargo_Truck_WEST_002", "gntn_common_v02_route0005", 8 )
			elseif ( routeNodeIndex == 14 ) then
				-- 圏外に抜けたのでマーカーを一時的に非表示
				TppMarkerSystem.DisableMarker{ markerId="Cargo_Truck_WEST_002" }
				TppMarkerSystem.DisableMarker{ markerId="e20030_enemy022" }
			end
			-- 到達済みNode番号+1を保持
			this.CounterList.NorthTruckStatus = routeNodeIndex + 1
		end
	else
		Fox.Log("■WARNING■ commonVehicleRouteUpdate vehicleGroupInfo:"..vehicleInfoName)
	end
end
---------------------------------------------------------------------------------
-- ■ commonVehicleRouteFinish
-- 車両のルート行動終了
this.commonVehicleRouteFinish = function()
	--Fox.Log("-------!!!!!!!!!!!commonVehicleRouteFinish!!!!!!!!!!!!------")
	local vehicleGroupInfo	= TppData.GetArgument(2)

	local vehicleInfoName	= vehicleGroupInfo.routeInfoName		-- RouteInfデータ名
	local vehicleCharaID	= vehicleGroupInfo.vehicleCharacterId	-- 車両のキャラID
	local routeID			= vehicleGroupInfo.vehicleRouteId		-- 車両ルートのルートID
	local routeNodeIndex	= vehicleGroupInfo.passedNodeIndex		-- 到達したルートノードのインデックス
	local memberCharaIDs	= vehicleGroupInfo.memberCharactorIds	-- 乗車しているキャラID
	local result 			= vehicleGroupInfo.result				-- 結果（成功or失敗）
	local reason			= vehicleGroupInfo.reason				-- 結果の原因


	-- 結果に応じて分岐
	if ( result == "SUCCESS" ) then
		-- 輸送トラックA：（西検問→管制塔前）
		if( (vehicleInfoName == "VehicleRouteInfo_common_v01_0000") or (vehicleInfoName == "VehicleDefaultRideRouteInfo_e20030")) then
			Fox.Log("TruckA：WestInspection__Center")

			-- 検問区画通過中フラグを下げる
			this.CounterList.WestTruckStatus = 0

			-- 検問が設置済みならトラックの循環は停止
			if ( TppMission.GetFlag("isInspectionActive") == true ) then
				-- ドライバー兵に割り当てられているルートをスイッチ（西検問前の乗り込み→西検問前の哨戒）ToDoルートは変えるかも
				TppCommandPostObject.GsSetExclusionRoutes( "gntn_cp", "gntn_common_d01_route0032", "gntn_common_d01_route0027")

			else
				-- ドライバー兵に割り当てられているルートをスイッチ（西検問前の乗り込み→管制塔前の乗り込み）
				TppCommandPostObject.GsSetExclusionRoutes( "gntn_cp", "gntn_common_d01_route0028", "gntn_common_d01_route0027")
			end

		-- 輸送トラックA：（管制塔前→西検問）
		elseif( vehicleInfoName == "VehicleRouteInfo_common_v01_0001" ) then
			Fox.Log("TruckA：Center__WestInspection")

			-- 検問区画通過中フラグを下げる
			this.CounterList.WestTruckStatus = 0

			-- 検問が設置済みならトラックの循環は停止
			if ( TppMission.GetFlag("isInspectionActive") == true ) then
				-- ドライバー兵に割り当てられているルートをスイッチ（管制塔前の乗り込み→西検問前の哨戒）
				TppCommandPostObject.GsSetExclusionRoutes( "gntn_cp", "gntn_common_d01_route0032", "gntn_common_d01_route0028")

			else
				-- ドライバー兵に割り当てられているルートをスイッチ（管制塔前の乗り込み→西検問前の乗り込み）
				TppCommandPostObject.GsSetExclusionRoutes( "gntn_cp", "gntn_common_d01_route0027", "gntn_common_d01_route0028")
			end

			-- 管理棟巨大ゲート車両セットアップ（以降は通常の車両連携データを指定する）
			GZCommon.Common_CenterBigGateVehicleSetup( "gntn_cp", "VehicleRouteInfo_common_v01_0000",
														  "gntn_common_v01_route0010", -- 開錠前のルート
														  "gntn_common_v01_route0011", -- 開錠後のルート
														  17, "NotClose" )	-- ゲート開錠ノード番号、閉鎖ノード番号（閉じないので文字列を渡す）
			-- 圏外に抜けたのでマーカーを一時的に非表示
			TppMarkerSystem.HideMarker{ markerId="Cargo_Truck_WEST_001", isHidden=true }
			TppMarkerSystem.HideMarker{ markerId="e20030_Driver", isHidden=true }

		-- 輸送トラックB：（北検問→倉庫エリア）
		elseif( vehicleInfoName == "VehicleRouteInfo_common_v02_0000" ) then
			Fox.Log("TruckB：NorthInspection__WareHouse")

			-- 検問区画通過中フラグを下げる
			this.CounterList.NorthTruckStatus = 0

			-- 検問が設置済みならトラックの循環は停止
			if ( TppMission.GetFlag("isInspectionActive") == true ) then
				-- ドライバー兵に割り当てられているルートをスイッチ（北検問前の乗り込み→北検問前の哨戒）
				TppCommandPostObject.GsSetExclusionRoutes( "gntn_cp", "gntn_common_d01_route0033", "gntn_common_d01_route0029")
			else
				-- ドライバー兵に割り当てられているルートをスイッチ（北検問前の乗り込み→倉庫エリアの乗り込み）
				TppCommandPostObject.GsSetExclusionRoutes( "gntn_cp", "gntn_common_d01_route0030", "gntn_common_d01_route0029")
			end

		-- 輸送トラックB：（倉庫エリア→北検問）
		elseif( vehicleInfoName == "VehicleRouteInfo_common_v02_0001" ) then
			Fox.Log("TruckB：WareHouse__NorthInspection")

			-- 検問区画通過中フラグを下げる
			this.CounterList.NorthTruckStatus = 0

			-- 検問が設置済みならトラックの循環は停止
			if ( TppMission.GetFlag("isInspectionActive") == true ) then
				-- ドライバー兵に割り当てられているルートをスイッチ（北検問前の乗り込み→北検問前の哨戒）
				TppCommandPostObject.GsSetExclusionRoutes( "gntn_cp", "gntn_common_d01_route0033", "gntn_common_d01_route0030")

			else
				-- ドライバー兵に割り当てられているルートをスイッチ（倉庫エリアの乗り込み→北検問前の乗り込み）
				TppCommandPostObject.GsSetExclusionRoutes( "gntn_cp", "gntn_common_d01_route0029", "gntn_common_d01_route0030")
			end

			-- 圏外に抜けたのでマーカーを一時的に非表示
			TppMarkerSystem.HideMarker{ markerId="Cargo_Truck_WEST_002", isHidden=true }
			TppMarkerSystem.HideMarker{ markerId="e20030_enemy022", isHidden=true }
		else

			Fox.Log("■WARNING■ commonVehicleRouteUpdate vehicleGroupInfo:"..vehicleInfoName)
		end
	else
		-- 後半シーケンスかどうかで使用するべきRouteSetは異なる
		local sequence = TppSequence.GetCurrentSequence()
		local RouteSetName
		if( TppSequence.IsGreaterThan( sequence, "Seq_Waiting_GetCassette" ) or  TppMission.GetFlag("isGetCassette_B") == true ) then
			RouteSetName = "e20030_routeSet_d01_basic02"
		else
			RouteSetName = "e20030_routeSet_d01_basic01"
		end
		-- 失敗終了の処理（乗車ルート無効化）。ドライバーに検問ルート割り当て
		if ( vehicleCharaID == "Cargo_Truck_WEST_001" ) then
			Fox.Log("TruckA：VehicleFailed")
			TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0027" )
			TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0028" )
			TppEnemy.EnableRoute( "gntn_cp", "gntn_common_d01_route0032" )
			TppEnemy.ChangeRoute( "gntn_cp", "e20030_Driver", 	RouteSetName, "gntn_common_d01_route0032", 0 )
		else
			Fox.Log("TruckB：VehicleFailed")
			TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0029" )
			TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0030" )
			TppEnemy.EnableRoute( "gntn_cp", "gntn_common_d01_route0033" )
			TppEnemy.ChangeRoute( "gntn_cp", "e20030_enemy022", 	RouteSetName, "gntn_common_d01_route0033", 0 )
		end
	end
end

---------------------------------------------------------------------------------
-- ■ commonCheckVehicleSkipInspection
-- 車両の検問スキップチェック
this.commonCheckVehicleSkipInspection = function()
	--Fox.Log("-------!!!!!!!!!!!commonCheckVehicleSkipInspection!!!!!!!!!!!!------")

	-- 走行中に検問が設置されたら該当区画をスキップさせる
	-- 各トラックの通過状況をフラグ管理して検問区画ならワープ＆ノードチェンジ、それ以前なら退避ルートへのルートチェンジを各ノード通過時にチェックしている

	-- トラックA（西検問担当）
	if ( this.CounterList.WestTruckStatus == -1 ) then
		-- 西検問→管制塔ルート移動中に検問区画通過中
		-- この場合は車両を消すかも（ギミックのリアライズ距離的に行けそうな気がするので一旦コメントアウト）
		-- TppData.Disable( "Cargo_Truck_WEST_001" )
		-- TppCharacterUtility.WarpCharacterIdFromIdentifier( "Cargo_Truck_WEST_001", "id_vipRestorePoint", "InspectionSkip_WarpPos_Truck0110" )
		-- TppCommandPostObject.GsSetGroupVehicleRoute( "gntn_cp", "Cargo_Truck_WEST_001", "gntn_common_v01_route0010", 4 )

	elseif ( this.CounterList.WestTruckStatus ~= 0 ) then
		-- 管制塔→西検問ルート移動中
		if ( this.CounterList.WestTruckStatus < 12 ) then
			-- Node12以前を進んでいる（検問以前に居る）ので退避用ルートにルートチェンジ各ノード通過時にチェック


		elseif ( this.CounterList.WestTruckStatus < 15 ) then
			-- 12～15に居る（検問区画に居る）のでワープ＆ルートノードチェンジ
			-- この場合は車両を消すかも
			-- TppData.Disable( "Cargo_Truck_WEST_001" )
			-- TppCharacterUtility.WarpCharacterIdFromIdentifier( "Cargo_Truck_WEST_001", "id_vipRestorePoint", "InspectionSkip_WarpPos_Truck0120" )
			-- TppCommandPostObject.GsSetGroupVehicleRoute( "gntn_cp", "Cargo_Truck_WEST_001", "gntn_common_v01_route0020", 16 )

		end
	end
	-- トラックB（北検問担当）
	if ( this.CounterList.NorthTruckStatus == -1 ) then
		-- 北検問→倉庫エリアルート移動中に検問区画通過中
		-- この場合は車両を消すかも
		-- TppData.Disable( "Cargo_Truck_WEST_002" )
		-- トラックワープ、ルートノードチェンジ
		-- TppCharacterUtility.WarpCharacterIdFromIdentifier( "Cargo_Truck_WEST_002", "id_vipRestorePoint", "InspectionSkip_WarpPos_Truck0200" )
		-- TppCommandPostObject.GsSetGroupVehicleRoute( "gntn_cp", "Cargo_Truck_WEST_002", "gntn_common_v02_route0005", 8 )

	elseif ( this.CounterList.NorthTruckStatus ~= 0 ) then
		-- 倉庫エリア→北検問ルート移動中
		if ( this.CounterList.NorthTruckStatus < 7 ) then
			-- Node7以前を進んでいる（検問以前に居る）ので退避用ルートにルートチェンジ各ノード通過時にチェック

		elseif ( this.CounterList.NorthTruckStatus < 12 ) then
			-- 7～12に居る（検問区画に居る）のでワープ＆ルートチェンジ
			-- この場合は車両を消すかも
			-- TppData.Disable( "Cargo_Truck_WEST_002" )
			-- TppCharacterUtility.WarpCharacterIdFromIdentifier( "Cargo_Truck_WEST_002", "id_vipRestorePoint", "InspectionSkip_WarpPos_Truck0201" )
			-- TppCommandPostObject.GsSetGroupVehicleRoute( "gntn_cp", "Cargo_Truck_WEST_001", "gntn_common_v02_route0001", 12 )

		end
	end

end
---------------------------------------------------------------------------------
-- ■■ Event Functions
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- ■ CheckAlertPhaseChange
-- Alertフェイズ切り替わり時判定
this.CheckAlertChange = function()

	-- 一度でもAlertになったのであればフラグを立てる
	TppMission.SetFlag( "isAlreadyAlert", true )

	-- 共通サイレンコール
	GZCommon.CallAlertSirenCheck()
	-- エヴァージョン時用任意無線初期化処理
	local radioDaemon = RadioDaemon:GetInstance()
	radioDaemon:DisableFlagIsCallCompleted( "e0030_oprg9020" )
end
---------------------------------------------------------------------------------
-- ■ CheckPhaseChange
-- フェイズ切り替わり時判定
this.CheckPhaseChange = function()

	-- Alert時サイレン停止判定共通処理
	GZCommon.StopAlertSirenCheck()


	local status = TppData.GetArgument(2)
	local radioDaemon = RadioDaemon:GetInstance()

	-- フェイズが「下がってきた」か
	if ( status == "Down" ) then
		-- 内通者接触前かどうか
		if ( TppSequence.GetCurrentSequence() == "Seq_Waiting_BetrayerContact" ) then

			-- Cautionに落ちたなら無線再生
			if( TppEnemy.GetPhase("gntn_cp") == "caution" )then
				-- TppRadio.Play( "Radio_Contactable")		-- 接触出来るようになったよ無線
			end
			-- Evasionに落ちてきた場合はCautionRouteにしておく
			if ( TppEnemy.GetPhase("gntn_cp") == "evasion" ) then
				TppRadio.Play( "Radio_Contactable")		-- 接触出来るようになったよ無線
				TppEnemy.ChangeRouteSet( "gntn_cp", "e20030_routeSet_c01_basic01", { warpEnemy = false } )
			end
		else
			-- Evasionに落ちてきた場合はCautionRoute
			if ( TppEnemy.GetPhase("gntn_cp") == "evasion" ) then
				TppEnemy.ChangeRouteSet( "gntn_cp", "e20030_routeSet_c01_basic01", { warpEnemy = false } )
			end
		end
		if( TppEnemy.GetPhase("gntn_cp") == "caution" )then
			-- エヴァージョン時用任意無線初期化処理
			radioDaemon:DisableFlagIsCallCompleted( "e0030_oprg9020" )
		end
		if ( TppEnemy.GetPhase("gntn_cp") == "evasion" ) then
			-- アラート時用任意無線初期化処理
			radioDaemon:DisableFlagIsCallCompleted( "e0060_oprg9010" )
		end

	end

end
---------------------------------------------------------------------------------
-- ■ ChangeAntiAir
-- 対空行動切り替わり時判定
this.ChangeAntiAir = function()

	-- 対空行動の開始or終了
	local status = TppData.GetArgument(2)

	-- 対空行動の開始
	if ( status == true ) then

		-- サイレン開始
		GZCommon.CallCautionSiren()

	-- 対空行動の終了
	else
		-- サイレンの通常停止
		GZCommon.StopSirenNormal()
	end

end
---------------------------------------------------------------------------------
-- ■ commonPlayerRideHeli
-- プレイヤーがヘリに乗り込んだ
this.commonPlayerRideHeli = function()
	Fox.Log("--------commonPlayerRideHeli--------")

	-- この時点でミッションクリア条件を満たしているかどうかを判定
	if ( TppMission.GetFlag("isGetCassette_A") == true or TppMission.GetFlag("isGetCassette_B") == true ) then

		-- 汎用のミラー無線：ヘリで離脱
		TppRadio.Play( "Radio_RideHeli_Clear")

		-- 暫定：この時点でシーケンスを遷移させる
		TppSequence.ChangeSequence( "Seq_PlayerRideHelicopter" )	-- ヘリ離脱シーケンスへ

	else

		-- 汎用のミラー無線：ミッション中断警告
		TppRadio.Play( "Radio_HeliAbort_Warning")

		-- 離陸を少し待つ
		TppSupportHelicopterService.SetEnableGetOffTime( GZCommon.WaitTime_HeliTakeOff )

	end

	-- シーケンス遷移はヘリからのmessageをトリガにして行う
	-- TppSequence.ChangeSequence( "Seq_PlayerRideHelicopter" )	-- ヘリ離脱シーケンスへ

end
---------------------------------------------------------------------------------
-- ■ commonHeliArrive
-- ヘリが着陸した
this.commonHeliArrive = function()
	Fox.Log("--------commonHeliDead--------")

	local timer = 55 --「ヘリから離れろよ」という促しをするまでの時間

	-- 離れるよう促すタイマー開始
	TppMission.SetFlag( "isHeliLandNow", true )						-- ヘリが着陸してる
	GkEventTimerManager.Start( "Timer_pleaseLeaveHeli", timer )
end
---------------------------------------------------------------------------------
-- ■ commonHeliTakeOff
-- ヘリが離陸した
this.commonHeliTakeOff = function()

	Fox.Log("--------commonHeliTakeOff--------")

	local isPlayer = TppData.GetArgument(3)

	-- プレイヤーが搭乗していたら
	if ( isPlayer == true ) then

		TppSequence.ChangeSequence( "Seq_PlayerRideHelicopter" )	-- ヘリ離脱シーケンスへ

	end

	TppMission.SetFlag( "isHeliLandNow", false )					-- ヘリが離陸してる
end
---------------------------------------------------------------------------------
-- ■ commonHeliDead
-- ヘリが撃墜された
this.commonHeliDead = function()

	Fox.Log("--------commonHeliDead--------")

	local sequence = TppSequence.GetCurrentSequence()
	local killerCharacterId = TppData.GetArgument(2)

	-- 「ヘリ離脱シーケンス（＝プレイヤーが搭乗している）」だったらミッション失敗
	if ( sequence == "Seq_PlayerRideHelicopter" ) then

		TppMission.ChangeState( "failed", "PlayerDeadOnHeli" )

	else
		-- プレイヤー未搭乗のヘリが撃墜された
		if killerCharacterId == "Player" then
			TppRadio.Play( "Radio_BrokenHeliSneak" )
		else
			TppRadio.Play( "Radio_BrokenHeli" )
		end

		-- 反乱兵が乗っていたら死亡
		if ( TppMission.GetFlag( "isMastermindOnHeli" ) == true ) then
			this.commonMastermindDead()
			-- 反乱兵ヘリ搭乗フラグも下げておく
			TppMission.SetFlag( "isMastermindOnHeli", false )
			this.commonBetrayerInterrogationSetUpdate()	-- 内通者の尋問時セリフセット更新
		end
		-- 内通者が乗っていたら死亡
		if ( TppMission.GetFlag( "isBetrayerOnHeli" ) == true ) then
			this.commonBetrayerDead()
			-- 内通者ヘリ搭乗フラグも下げておく
			TppMission.SetFlag( "isBetrayerOnHeli", false )
		end

		-- アナウンスログ表示
		this.commonCallAnnounceLog( this.AnnounceLogID_HeliDead )
	end


end
---------------------------------------------------------------------------------
-- ■ commonHeliDamagedByPlayer
-- プレイヤーに攻撃された
this.commonHeliDamagedByPlayer = function()
	Fox.Log("--------commonHeliDamagedByPlayer--------")
	local radioDaemon = RadioDaemon:GetInstance()

	if ( radioDaemon:IsPlayingRadio() == false ) then
		--無線の種類に問わず再生中でなければ
		TppRadio.PlayEnqueue( "Miller_HeliAttack" )
	end
end
---------------------------------------------------------------------------------
-- ■ commonHeliDamagedByPlayer
-- ヘリから離れろって促すかどうか
this.commonHeliLeaveJudge = function()
	local radioDaemon = RadioDaemon:GetInstance()
	local timer = 55 --「ヘリから離れろよ」という促しをするまでの時間
	-- ヘリが着陸してる
	if( TppMission.GetFlag( "isHeliLandNow" ) == true ) then
		-- プレイヤーがヘリの近くにいたら
		if ( GZCommon.Radio_pleaseLeaveHeli() == true ) then
			--無線流してもう一回同じタイマーを回す
			if ( radioDaemon:IsPlayingRadio() == false ) then
				--無線再生中でなければ
				TppRadio.PlayEnqueue( "Miller_HeliLeave" )
			end
			GkEventTimerManager.Start( "Timer_pleaseLeaveHeli", timer )
		end
	end
end
---------------------------------------------------------------------------------
-- ■ commonHostageLaidOn
-- 捕虜が乗り物に乗せられた
this.commonHostageLaidOn = function()
	Fox.Log("--------commonHostageLaidOn--------")

	local HostageCharacterID	= TppData.GetArgument(1)
	local VehicleCharacterID	= TppData.GetArgument(3)
	local sequence				= TppSequence.GetCurrentSequence()

	-- ヘリに乗せられた
	if ( VehicleCharacterID == "SupportHelicopter" ) then

		local funcs = {
			onEnd = function()
				-- クリア条件未達成なら続けて無線コール
				if ( TppMission.GetFlag("isGetCassette_A") == false and TppMission.GetFlag("isGetCassette_B") == false ) then
					TppRadio.Play( "Radio_EncourageMission" )	-- ミッション遂行促し「任務に戻ってくれ、ボス」
				end
			end,
		}
		TppRadio.Play( "Radio_HostageOnHeli", funcs )	-- 捕虜をヘリに乗せた「よし、回収した」

		-- 捕虜回収処理（アナウンスログ表示、戦績反映）
		GZCommon.NormalHostageRecovery( HostageCharacterID )
	end


end
---------------------------------------------------------------------------------
-- ■ commonCheckActivateWav
-- 機銃装甲車の出現チェック
this.commonCheckActivateWav = function()
	Fox.Log("--------commonCheckActivateWav--------")

	-- 一度でもAlertになっていたらor内通者に接触して内通者が生存していたら（侵入がバレていたら）
	if ( TppMission.GetFlag("isAlreadyAlert") == true or
		( TppMission.GetFlag("isBetrayerContact") == true and TppMission.GetFlag("isBetrayerDown") == false ) ) then
		-- 機銃装甲車とその乗組員を出現させる
		TppData.Enable( "APC_Machinegun_WEST_002" )
		TppData.Enable( "e20030_WavDriver" )
		TppMission.SetFlag( "isWavActivate", true )	-- 敵装甲車出現済み
	end
end
---------------------------------------------------------------------------------
-- ■ commonCheckInspectionAppearance
-- 検問の設置チェック
this.commonCheckInspectionAppearance = function()
	Fox.Log("--------commonCheckActivateWav--------")

	-- クリア条件成立後、特定エリア通過時点で敵勢力に「スネークの侵入」を知られていれば検問が設置される

	-- いずれかのテープを入手していて、検問未設置なら
	if ( ( TppMission.GetFlag("isGetCassette_A") == true or TppMission.GetFlag("isGetCassette_B") == true ) and
		 TppMission.GetFlag("isInspectionActive") == false ) then

		-- 監視カメラに見つかっていていたら（罠にかかっていたら）
		if ( TppMission.GetFlag("isCameraAlert") == true ) then

			-- 検問用オブジェクトの設置
			this.commonInspectionObjectON()

			-- 検問用トラックの出現チェック
			this.CenterAreaTruckCheck()

			-- 検問設置済み
			TppMission.SetFlag( "isInspectionActive", true )

			-- 各検問に追加兵を出現させる
			TppData.Enable( "e20030_enemyInspection01" )
			TppData.Enable( "e20030_enemyInspection02" )

			-- この時点で装甲車が未だ出現していなければここで出現
			if ( TppMission.GetFlag("isWavActivate") == false ) then
				this.commonCheckActivateWav()
			end

			-- 循環トラックのスキップチェック
			this.commonCheckVehicleSkipInspection()

			-- 検問について無線
			TppRadio.DelayPlay( "Radio_Inspection", "mid", "both", {
				onStart = function()
					-- アナウンスログ「検問を設置」
					this.commonCallAnnounceLog( this.AnnounceLogID_Inspection )
				end,
				onEnd = function()
					-- アナウンスログ「Map情報更新」
					this.commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )

					TppMarker.Enable( "TppMarkerLocator_EscapeWest", 0, "moving", "all", 0, false, true )		-- 基地からの脱出ポイントをマーカー表示
					TppMarker.Enable( "TppMarkerLocator_EscapeNorth", 0, "moving", "all", 0, false, true  )		-- 基地からの脱出ポイントをマーカー表示

					-- 任意無線を更新
					this.commonOptionalRadioUpdate()
				end,
			} )
		end
	end
end

---------------------------------------------------------------------------------
-- ■ commonInspectionObjectON
-- 検問用オブジェクトの設置
this.commonInspectionObjectON = function()
	Fox.Log("--------commonInspectionObjectON--------")

	-- 検問用ギミック出現
	TppCharacterUtility.SetEnableCharacterId( "North_Barricade001", true )
--	TppCharacterUtility.SetEnableCharacterId( "North_Barricade002", true )
	TppCharacterUtility.SetEnableCharacterId( "North_Barricade003", true )
--	TppCharacterUtility.SetEnableCharacterId( "North_Barricade004", true )
--	TppCharacterUtility.SetEnableCharacterId( "North_Barricade005", true )
--	TppCharacterUtility.SetEnableCharacterId( "North_Barricade006", true )
	TppCharacterUtility.SetEnableCharacterId( "North_Barricade007", true )
	TppCharacterUtility.SetEnableCharacterId( "North_Barricade008", true )
	TppCharacterUtility.SetEnableCharacterId( "North_BarricadeBox001", true )
	TppCharacterUtility.SetEnableCharacterId( "North_BarricadeBox002", true )
	TppCharacterUtility.SetEnableCharacterId( "West_BarricadeBox001", true )
	TppCharacterUtility.SetEnableCharacterId( "West_BarricadeBox002", true )

end
-------------------------------------------
-- ■ CenterAreaTruckCheck
-- 管理棟エリアのトラックをアンリアライズする
this.CenterAreaTruckCheck = function()
	Fox.Log( "---------- CenterAreaTruckCheck -------")
	local pos			= Vector3( -164, 36, -3 )				-- BOX位置
	local size			= Vector3( 83, 15, 62 )					-- BOXサイズ
	local rot			= Quat( 0.0, 0.0, 0.0, 0.0 )			-- BOX回転
	local npcIds		= 0
	local vehicleIds	= 0
	local characterID
	local UnrealFlag	= false

	-- 管理棟内（Playerから見える位置）にトラックBが居るかチェック
	-- 指定BOX内にいる車両を取得
	vehicleIds = TppVehicleUtility.GetVehicleByBoxShape( pos, size, rot )

	-- 指定BOX内にいる車両にトラックＢが居たらフラグ
	if( vehicleIds and #vehicleIds.array > 0 ) then
		for i,id in ipairs( vehicleIds.array ) do
			characterID = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
			Fox.Log( "CenterAreaTruckCheck:VehicleID::"..characterID )
			if( characterID == "Cargo_Truck_WEST_002" ) then
				UnrealFlag = true
			end
		end
	end

	-- フラグが立ってなければ消して検問車両を出現させる
	if ( UnrealFlag == false) then

		-- 検問予定地に車両が居るかチェック
		-- 指定BOX内にいる車両を取得
		pos		= Vector3( 26, 34, 61 )
		size	= Vector3( 26, 14, 33 )
		rot		= Quat( 0.0, -0.3, 0.0, 0.8 )

		vehicleIds = TppVehicleUtility.GetVehicleByBoxShape( pos, size, rot )

		-- 指定BOX内にいる車両は消してしまう（保険処理）
		if( vehicleIds and #vehicleIds.array > 0 ) then
			for i,id in ipairs( vehicleIds.array ) do
				characterID = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				Fox.Log( "CenterAreaTruckCheck:VehicleID::"..characterID )
				TppData.Disable( characterID )
			end
		end

		-- 車両表示ＯＦＦ
		Fox.Log( "CenterAreaTruckCheck::DisableTruck::"..characterID )

		-- 消す予定のトラックにプレイヤーが乗っていないかチェック（保険処理）
		local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()
		if ( VehicleId ~= "Cargo_Truck_WEST_002" ) then
			TppData.Disable( "Cargo_Truck_WEST_002" )
		end
		-- 検問車両をＯＮ
		TppData.Enable( "Cargo_Truck_WEST_003" )

		-- トラックBのドライバーのルートを念のため指定
		TppEnemy.ChangeRoute( "gntn_cp", "e20030_enemy022", "e20030_routeSet_d01_basic02", "gntn_common_d01_route0033", 0 )
	end
end
---------------------------------------------------------------------------------
-- ■ commonStartForceSerching
-- カセット入手後の捜索部隊発生イベント：開始
this.commonStartForceSerching = function()
	Fox.Log("--------commonStartForceSerching--------")
	-- タイマーをまわす
	--TppTimer.Start( "ForceSerchingTimer", this.Time_ForceSerching )

	-- KeepCautionにする
	-- TppEnemy.SetMinimumPhase( "gntn_cp", "caution" )

	-- 捜索用のCautionRouteSetに切り替える
	TppEnemy.RegisterRouteSet( "gntn_cp", "caution_day", 	"e20030_routeSet_c01_serching01" )	-- caution_dayを書き換える
	--TppEnemy.ChangeRouteSet( "gntn_cp", "e20030_routeSet_c01_serching01", { warpEnemy = true, startAtZero = true } )
	--TppCommandPostObject.GsSetCurrentRouteSet( "gntn_cp", "e20030_routeSet_c01_serching01", false, false, true, true )

end
---------------------------------------------------------------------------------
-- ■ commonFinishForceSerching
-- カセット入手後の捜索部隊発生イベント：終了
this.commonFinishForceSerching = function()
	Fox.Log("--------commonFinishForceSerching-------")
	-- KeepCautionを下げる ToDo:KeepCautionは維持しつつRouteSetだけ通常のCautionに戻すかも
	-- TppEnemy.SetMinimumPhase( "gntn_cp", caution )
	TppCommandPostObject.GsSetKeepPhaseName( "gntn_cp", "Sneak" )	--[dbg]現状ラッピングされたコマンドにSneak設定がないので直コマンド実行

	-- 基本のRouteSetに戻す
	TppEnemy.ChangeRouteSet( "gntn_cp", "e20030_routeSet_d01_basic02", { warpEnemy = false } )
	TppEnemy.RegisterRouteSet( "gntn_cp", "caution_day", 	"e20030_routeSet_c01_basic01" )	-- さらにcaution_dayを書き換えておく

end
---------------------------------------------------------------------------------
-- ■ commonSwitchSneakRouteSet
-- カセット捜索シーケンス（内通者接触後）のSneakRouteSetに切り替え
this.commonSwitchSneakRouteSet = function()
	Fox.Log("--------commonSwitchSneakRouteSet--------")

	-- カセット捜索シーケンス用のSneakRouteSetに切り替える
	TppEnemy.RegisterRouteSet( "gntn_cp", "sneak_day", 	"e20030_routeSet_d01_basic02" )	-- sneak_dayを書き換える

	-- 現在のRouteSetを明示的に登録する。
	TppEnemy.ChangeRouteSet( "gntn_cp", "e20030_routeSet_d01_basic02", { warpEnemy = false } )

	-- 取り巻き兵が残っていれば通常巡回に戻しておく
	if ( this.commonCheckAssistantStatus() == true ) then
		this.commonAssistantrRouteDisable()
		TppEnemy.EnableRoute( "gntn_cp", "gntn_e20030_ast_route0000" )
		TppEnemy.ChangeRoute( "gntn_cp", this.AssistantID,	"e20030_routeSet_d01_basic02", "gntn_e20030_ast_route0000", 0 )
	end

	-- 内通者と反乱兵の会話用ルートのセットアップ
	this.commonSwitchMastermindConversation()

end
---------------------------------------------------------------------------------
-- ■ commonSwitchMastermindConversation
-- 内通者と反乱兵の会話用ルートのセットアップ
this.commonSwitchMastermindConversation = function()
	Fox.Log("--------commonSwitchMastermindConversation--------")

	-- 内通者のRouteを会話イベント用のものにしておく
	this.commonBetrayerRouteDisable()
	TppEnemy.EnableRoute( "gntn_cp", "gntn_e20030_tgt_route0003" )
	TppEnemy.ChangeRoute( "gntn_cp", this.BetrayerID,	"e20030_routeSet_d01_basic02", "gntn_e20030_tgt_route0003", 0 )

	-- 反乱兵を会話イベントのために専用ルートに乗せる
	TppEnemy.EnableRoute( "gntn_cp", "gntn_e20030_mst_route0000" )
	TppEnemy.ChangeRoute( "gntn_cp", this.MastermindID,	"e20030_routeSet_d01_basic02", "gntn_e20030_mst_route0000", 0 )

	-- 反乱兵が乗るルートは優先Realize指定しておく
	TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( "gntn_cp", "gntn_e20030_mst_route0000", true )

	-- 内通者と反乱兵の会話イベントを有効にしておく
	TppCommandPostObject.GsSetConversationEnableFlag( "gntn_cp", "CTE0030_0020" , true )

end
---------------------------------------------------------------------------------
-- ■ commonCheckAssistantStatus
-- 取り巻き兵の状態取得：無力化されているかどうか
this.commonCheckAssistantStatus = function()
	Fox.Log("--------commonCheckAssistantStatus--------")
	local AssistantStatus = TppEnemy.GetEnemyStatus( this.AssistantID )

	if ( AssistantStatus == ( "Normal" ) ) then
		Fox.Log( "--------Assistant still Alive-------"..AssistantStatus)
		return true
	else
		Fox.Log("--------Assistant already Down-------"..AssistantStatus)
		return false
	end
end
---------------------------------------------------------------------------------
-- ■ commonConversationEnd
-- 会話イベントが終了した
this.commonConversationEnd = function()

	local LabelName			= TppData.GetArgument(2)
	local CharaID			= TppData.GetArgument(3)

	Fox.Log("--------commonConversationEnd------::"..LabelName)

	-- 内通者と反乱兵の会話イベント
	if ( LabelName == "CTE0030_0020" ) then
		Fox.Log("Betrayer&Mastermind_Conversation:END")

		TppMission.SetFlag( "isMastermindConversationEnd", true )

		-- 会話イベントを無効にしておく
		TppCommandPostObject.GsSetConversationEnableFlag( "gntn_cp", "CTE0030_0020" , false )

		-- フラグチェックしてミラー無線
		if ( (TppMission.GetFlag("isGetInfo_Suspicion1") == true) and (TppMission.GetFlag("isGetInfo_Suspicion3") == true)) then
			-- 完全に会話を聞いた
			TppRadio.Play( "Radio_Conversation_Comp" )

		elseif ( (TppMission.GetFlag("isGetInfo_Suspicion1") == true) or (TppMission.GetFlag("isGetInfo_Suspicion3") == true)) then
			-- 一部だけ会話を聞いた
			TppRadio.Play( "Radio_Conversation_InComp" )

		else
			-- 会話を聞けていない（何もしない）

		end

		-- 任意無線を更新
		this.commonOptionalRadioUpdate()

	-- 内通者と取り巻き兵の会話イベント
	elseif ( LabelName == "CTE0030_0010" ) then
		Fox.Log("Betrayer&Assistant_Conversation:END")

		-- 会話イベントを無効にしておく
		TppCommandPostObject.GsSetConversationEnableFlag( "gntn_cp", "CTE0030_0010" , false )

		-- 取り巻き兵を合図チェック完了後ルートに切り替え
		this.ChangeAssistantRoute( "e20030_routeSet_d01_basic01", "gntn_e20030_ast_route9003", 0 )

		-- フラグ立てておく
		TppMission.SetFlag( "isAssistantConversationEnd", true )

	end

end
---------------------------------------------------------------------------------
-- ■ CommonGetCassette_A
-- カセットAを入手した
this.CommonGetCassette_A = function()

	Fox.Log("--------CommonGetCassette_A--------")

	-- カセット入手処理
	local uiCommonData = UiCommonDataManager.GetInstance()
	uiCommonData:GetBriefingCassetteTape( this.CassetteA )

	-- ミラー無線の呼び分け（アナウンスログ表示はシステムが出す）
	-- 内通者接触済みか？
	if ( TppMission.GetFlag( "isBetrayerContact" ) == false ) then

		if ( TppMission.GetFlag( "isDropCassette_B" ) == false ) then
			-- 内通者接触済みでなく、テープBもドロップしていない→「こんなところにテープ･･･」
			TppRadio.Play( "Radio_GetCassette_A_NoHint" )
		else
			if ( TppEnemy.GetPhase("gntn_cp") == "alert" ) then
				TppRadio.Play( "Radio_GetCassette_A_Alert" )
			else
				TppRadio.Play( "Radio_GetCassette_A" )
			end
		end
	-- それ以外のケースはフェイズによってセリフが変わるのみ
	else
		if ( TppEnemy.GetPhase("gntn_cp") == "alert" ) then
			TppRadio.Play( "Radio_GetCassette_A_Alert" )
		else
			TppRadio.Play( "Radio_GetCassette_A" )
		end
	end

	TppMission.SetFlag( "isGetCassette_A", true )
	this.commonBetrayerInterrogationSetUpdate()	-- 内通者の尋問時セリフセット更新

	-- クリア条件を満たしていれば圏外エフェクトは無効化
	GZCommon.isOutOfMissionEffectEnable = false

	-- いきなりカセット入手した場合のため、合図ポイントのマーカーはオフする
	TppMarker.Disable( "e20030_marker_Signal" )

	-- カメラの破壊状態で分岐
	if ( TppMission.GetFlag( "isCameraBroken" ) == true ) then
		-- 監視カメラが破壊されている
		TppSequence.ChangeSequence( "Seq_Escape_CameraBroken" )

	else
		-- 監視カメラが破壊されていない
		TppSequence.ChangeSequence( "Seq_Escape_CameraActive" )

	end

	-- カセットBが未入手なら目標達成アナウンスログ
	if ( TppMission.GetFlag( "isGetCassette_B" ) == false ) then
		-- アナウンスログ表示
		this.commonCallAnnounceLog( this.AnnounceLogID_MissionGoal )
	end

	-- 任意無線の更新
	this.commonOptionalRadioUpdate()

	-- 敵兵の諜報無線の更新
	this.commonUpdateCheckEnemyIntelRadio()

	-- ガードターゲット更新チェック
	this.commonUpdateGuardTarget()

end
---------------------------------------------------------------------------------
-- ■ CommonGetCassette_B
-- カセットBを入手した
this.CommonGetCassette_B = function()

	Fox.Log("--------CommonGetCassette_B--------")

	-- カセット入手処理
	local uiCommonData = UiCommonDataManager.GetInstance()
	uiCommonData:GetBriefingCassetteTape( this.CassetteB )

	TppMission.SetFlag( "isGetCassette_B", true )

	local hardmode = TppGameSequence.GetGameFlag("hardmode")
	if ( hardmode == true ) then
		-- プレイレコードに登録（チャレンジ）
		PlayRecord.RegistPlayRecord( "TAPE_GET" )
	end

	-- ミッション中間目標更新
	commonMissionSubGoalSetting( this.MissionSubGoal_Escape )

	-- アナウンスログ表示
	this.commonCallAnnounceLog( this.AnnounceLogID_InfoUpdate )

	-- テープB入手に対するミラー無線
	this.commonRadioGetCassetteB()

	-- 任意無線を更新
	this.commonOptionalRadioUpdate()

	-- この時点で内通者への割り当てルートが「反乱兵との会話」ルートだったら元に戻す
	local routeId = TppEnemyUtility.GetRouteId( this.BetrayerID )
	if ( routeId == GsRoute.GetRouteId("gntn_e20030_tgt_route0003") ) then
		-- 通常の巡回ルートに戻す（全体巡回ルート）
		this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic02", "gntn_e20030_tgt_route0000", 16 )
		this.commonBetrayerRouteWareHouse()
	end

	-- 敵兵への諜報無線内容を更新する
	this.commonUpdateCheckEnemyIntelRadio()

	-- 検問以外の目的地マーカーを消す
	TppMarker.Disable( "e20030_marker_Signal" )		-- 合図ポイントのターゲットマーカー表示をオフ
	TppMarker.Disable( "e20030_marker_Cassette" )	-- カセットのターゲットマーカー表示をオフ

	-- クリア条件を満たしていれば圏外エフェクト判定フラグは無効にしておく
	GZCommon.isOutOfMissionEffectEnable = false

	-- カセット捜索シーケンス用のSneakRouteSetに切り替える
	TppEnemy.RegisterRouteSet( "gntn_cp", "sneak_day", 	"e20030_routeSet_d01_basic02" )	-- sneak_dayを書き換える

	-- 現在のRouteSetを明示的に登録する。
	TppEnemy.ChangeRouteSet( "gntn_cp", "e20030_routeSet_d01_basic02", { warpEnemy = false } )

	-- この時点でSequenceSave実行。場所が不定なので現在地を見て切り替える
	this.commonSequenceSaveIndefinite()

	-- ガードターゲット更新チェック
	this.commonUpdateGuardTarget()

	-- カセットAが未入手なら目標達成アナウンスログ
	if ( TppMission.GetFlag( "isGetCassette_A" ) == false ) then
		-- アナウンスログ表示
		this.commonCallAnnounceLog( this.AnnounceLogID_MissionGoal )
	end

	-- ボーナススコア
	PlayRecord.PlusExternalScore( 3000 )
end
---------------------------------------------------------------------------------
-- ■ CommonDropCassette_B
-- カセットBをドロップした
this.CommonDropCassette_B = function()

	Fox.Log("--------CommonDropCassette_B--------")
	-- テープBをドロップ
	TppEnemyUtility.DropItem {
		characterId	= this.MastermindID,
		itemId		= "IT_Cassette",
		itemIndex	= 15,
		setMarker	= true,
	}
	-- このフレームではMarkerIDが存在していないので、詳細なマーカー付与処理はマーカーのEnableメッセージ検知タイミングで行う

	----- 端末上のアイコンにカーソルがあったら出る説明分文を更新する -----
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
		return
	end

	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
		return
	end

	luaData:RegisterIconUniqueInformation( { markerId= "IT_Cassette", langId="marker_info_item_tape" })

	-- この時反乱兵がホールドアップ状態だったらホールドアップ尋問時とみなす。
	-- なのでここで拘束解除時と同様の無線コール処理を行う
	if ( TppEnemyUtility.GetStatus( this.MastermindID ) == "HoldUp" ) then
		this.commonMastermindRestraintEnd()
	end

end
---------------------------------------------------------------------------------
-- ■ commonOnSecurityCameraDemo
-- 監視カメラデモ発生チェック（このデモはオミット）
this.commonOnSecurityCameraDemo = function()

	Fox.Log("--------commonOnSecurityCameraDemo--------")

	-- デモ未再生かつカメラ未破壊ならデモ再生(Alert時も除外)
	if ( TppMission.GetFlag( "isCameraDemoPlay" ) == false and
		 TppMission.GetFlag( "isCameraBroken" ) == false and
		 TppEnemy.GetPhase( "gntn_cp" ) ~= "alert" ) then

		-- プレイヤーの姿勢と位置を補正する
		-- 9/6以降はこちらで
		TppPlayerUtility.RequestToStartTransition{stance="Stand",direction=100,doKeep=false}

		-- local funcs = { onStart = function() this.commonStartForceSerching() end }
		local funcs = {}
		-- デモ再生中でも監視カメラは動かす
		TppDemo.Play( "Demo_SecurityCamera", funcs,
		{ disableGame = false,			--共通ゲーム無効を、キャンセル
		  disableDamageFilter = false,	--エフェクトは消さない
		  disableDemoEnemies = false,	--敵兵無効を、キャンセル
		  disableHelicopter = false,	--支援ヘリ無効かを、キャンセル
		  disablePlacement = false,		--設置物は消さないでいい
		  disableThrowing = false,		--投擲物は消さないでいい
		} )

		TppMission.SetFlag( "isCameraDemoPlay", true )	-- 監視カメラデモ再生済みフラグ

		-- Cautionルートを管制塔捜索用に変えておく
		this.commonStartForceSerching()

	end

end

---------------------------------------------------------------------------------
-- ドアと捕虜を関連付ける
-- ex. local hostageCharacterId = this.doorToHostageMap[ doorCharacterId ]
this.doorToHostageMap = {
	AsyPickingDoor08 = "Hostage_e20030_000",
	AsyPickingDoor13 = "Hostage_e20030_002",
	AsyPickingDoor17 = "Hostage_e20030_001",
}

-- ■ commonOnPickingDoor
-- @summary ドアが開いているかどうか保持するフラグの名前を作って返す（btk16034対応）
-- @author Imaeda_Takuya
this.commonGetDoorOpenedFlagName = function( doorCharacterId )

	return doorCharacterId .. "Opened"

end

-- ■ commonOnPickingDoor
-- @summary ドアが開いているかどうか保持するフラグにflagで与えられた値を設定する（btk16034対応）
-- @author Imaeda_Takuya
this.commonSetDoorOpenedFlag = function( doorCharacterId, flag )

	TppMission.SetFlag( this.commonGetDoorOpenedFlagName( doorCharacterId ), flag )

end

-- ■ commonOnPickingDoor
-- @summary ドアが開いているかどうか保持するフラグの値を返す（btk16034対応）
-- @author Imaeda_Takuya
this.commonGetDoorOpenedFlag = function( doorCharacterId )

	return TppMission.GetFlag( this.commonGetDoorOpenedFlagName( doorCharacterId ) )

end

-- ドアが開いているかどうか保持するフラグをthis.MissionFlagListに追加（btk16034対応）
for doorCharacterId, hostageCharacterId in pairs( this.doorToHostageMap ) do
	this.MissionFlagList[ this.commonGetDoorOpenedFlagName( doorCharacterId ) ] = false
end

-- ■ commonOnPickingDoor
-- @summary プレイヤーがドアをピッキングしようとした（btk16034対応）
-- @author Imaeda_Takuya
this.commonOnPickingDoor = function()

	local doorCharacterId = TppData.GetArgument( 1 )
	local hostageCharacterId = this.doorToHostageMap[ doorCharacterId ]

	if hostageCharacterId ~= nil then

		-- 捕虜が暴れるのを止める
		TppHostageManager.GsSetStruggleFlag( hostageCharacterId, false )

		-- ドアが開いている事をフラグに保持させる
		this.commonSetDoorOpenedFlag( doorCharacterId, true )

	end

end

---------------------------------------------------------------------------------
-- ■ commonOnPlayerEnterHostageCallTrap
-- 捕虜騒ぎ出すトラップに入った
this.commonOnPlayerEnterHostageCallTrap = function( num )

	Fox.Log("--------commonOnPlayerEnterHostageCallTrap--------")

	local trapBodyHandle = TppData.GetArgument(3)
	local trapName = trapBodyHandle.data.name

	if( num == "Enter" ) then
		TppHostageManager.GsSetStruggleVoice( "Hostage_e20030_000", "POWV_0260" )	-- 捕虜の騒ぎ音声を設定
		TppHostageManager.GsSetStruggleVoice( "Hostage_e20030_001", "POWV_0260" )	-- 捕虜の騒ぎ音声を設定
		TppHostageManager.GsSetStruggleVoice( "Hostage_e20030_002", "POWV_0260" )	-- 捕虜の騒ぎ音声を設定

		-- 捕虜を暴れさせる
		for doorCharacterId, hostageCharacterId in pairs( this.doorToHostageMap ) do
			if this.commonGetDoorOpenedFlag( doorCharacterId ) == false then		-- ドアが開いていなかったら
				TppHostageManager.GsSetStruggleFlag( hostageCharacterId, true )			-- ドアに関連付けられている捕虜を暴れさせる
			end
		end

	else
		TppHostageManager.GsSetStruggleFlag( "Hostage_e20030_000", false )	-- 捕虜暴れ終わり
		TppHostageManager.GsSetStruggleFlag( "Hostage_e20030_001", false )	-- 捕虜暴れ終わり
		TppHostageManager.GsSetStruggleFlag( "Hostage_e20030_002", false )	-- 捕虜暴れ終わり

	end
end
---------------------------------------------------------------------------------
-- ■ commonOnPlayerEnterHostageAreaTrap
-- 捕虜エリア侵入トラップに入った
this.commonOnPlayerEnterHostageAreaTrap = function()

	Fox.Log("--------commonOnPlayerEnterHostageAreaTrap--------")

	-- 捕虜について無線
	TppRadio.Play( "Radio_DiscoverHostage" )

end

---------------------------------------------------------------------------------
-- ■■ Enemy Functions
---------------------------------------------------------------------------------
-- ■ commonBetrayerDead
-- 内通者が死亡した
this.commonBetrayerDead = function()
	Fox.Log("----------------commonMastermindDead----------------")

	local sequence = TppSequence.GetCurrentSequence()

	if ( sequence == "Seq_Waiting_BetrayerContact") then

		-- いずれのカセットも入手していなければ
		if ( TppMission.GetFlag( "isGetCassette_A" ) == false and TppMission.GetFlag( "isGetCassette_B" ) == false ) then
			TppMission.ChangeState( "failed", "Betrayer_Dead" )		-- 接触デモ前に殺すとミッション失敗（2週目でも）
		end

	elseif ( sequence == "Seq_Waiting_GetCassette" and TppMission.GetFlag( "isGetCassette_B" ) == false ) then

		TppMission.SetFlag( "isBetrayerDown", true )
		-- このシーケンスに来ているということは接触デモを見ている（内通者だと知っている）ということなので無線は鳴らす
		TppRadio.DelayPlay( "Radio_DeadBetrayer_AfterDemo", "short" )

	else

		TppMission.SetFlag( "isBetrayerDown", true )
		-- そもそも内通者にマーキングしていない（プレイヤーが認識していない）なら無線は鳴らさない
		if ( TppMission.GetFlag( "isBetrayerMarking" ) == true ) then
			TppRadio.DelayPlay( "Radio_DeadBetrayer_AfterGetCassette", "short" )
		end
	end

	-- 接触可否チェックタイマーを停止
	TppTimer.Stop( "BetrayerContactCheckTimer" )

end
----------------------------------------
-- ■ commonBetrayerFaint
-- 内通者が気絶した
this.commonBetrayerFaint = function()
	Fox.Log("----------------commonBetrayerFaint----------------")

	local sequence = TppSequence.GetCurrentSequence()

	-- そもそも内通者にマーキングしていない（プレイヤーが認識していない）なら無線は鳴らさない
	if ( TppMission.GetFlag( "isBetrayerMarking" ) == true ) then
		if ( sequence == "Seq_Waiting_BetrayerContact") then

			-- 拘束解除時のミラー無線名が予約されているか（＝一連の尋問結果に対するリアクション無線は初回のみ）
			if ( this.CounterList.BetrayerRestraintEndRadio ~= "NoRadio" ) then

				this.commonBetrayerRestraintEnd()
			else
				-- 睡眠の無線を既に再生済みならコールしない
				local radioDaemon = RadioDaemon:GetInstance()
				if ( radioDaemon:IsRadioGroupMarkAsRead("e0030_rtrg0094") == false ) then
					TppRadio.DelayPlay( "Radio_FaintBetrayer_BeforeDemo", "short" )
				end
			end

		elseif ( sequence == "Seq_Waiting_GetCassette") then

			-- ToDo デモ明けの目的提示無線とバッティングするので一旦塞ぐ。後で言わせるタイミングを工夫する
			-- 例えば、気絶状態にある内通者を一定時間画面中央に捕らえていたら、とか？
			-- TppRadio.Play( "Radio_DisablementBetrayer_AfterDemo" )	：ミラー「そいつをどこかに隠せ、怪しまれるぞ」

		else
			-- 拘束解除時のミラー無線名が予約されているか（＝一連の尋問結果に対するリアクション無線は初回のみ）
			if ( this.CounterList.BetrayerRestraintEndRadio ~= "NoRadio" ) then

				this.commonBetrayerRestraintEnd()

			else
				TppRadio.DelayPlay( "Radio_DisablementBetrayer_AfterDemo", "short" )	-- 「そいつをどこかに隠せ、怪しまれるぞ」
			end
		end
	end
	-- 接触可否チェックタイマーを停止
	TppTimer.Stop( "BetrayerContactCheckTimer" )

end
----------------------------------------
-- ■ commonBetrayerSleep
-- 内通者が睡眠した
this.commonBetrayerSleep = function()
	Fox.Log("----------------commonBetrayerSleep----------------")

	local sequence = TppSequence.GetCurrentSequence()

	-- そもそも内通者にマーキングしていない（プレイヤーが認識していない）なら無線は鳴らさない
	if ( TppMission.GetFlag( "isBetrayerMarking" ) == true ) then
		if ( sequence == "Seq_Waiting_BetrayerContact") then
			-- 気絶の無線を既に再生済みならコールしない
			local radioDaemon = RadioDaemon:GetInstance()
			if ( radioDaemon:IsRadioGroupMarkAsRead("e0030_rtrg0093") == false ) then
				TppRadio.DelayPlay( "Radio_SleepBetrayer_BeforeDemo", "short" )
			end

		elseif ( sequence == "Seq_Waiting_GetCassette") then

			-- ToDo デモ明けの目的提示無線とバッティングするので一旦塞ぐ。後で言わせるタイミングを工夫する
			-- 例えば、気絶状態にある内通者を一定時間画面中央に捕らえていたら、とか？
			-- TppRadio.Play( "Radio_DisablementBetrayer_AfterDemo" )	：ミラー「そいつをどこかに隠せ、怪しまれるぞ」

		else
			-- 拘束解除時のミラー無線名が予約されているか（＝一連の尋問結果に対するリアクション無線は初回のみ）
			if ( this.CounterList.BetrayerRestraintEndRadio ~= "NoRadio" ) then

				this.commonBetrayerRestraintEnd()
			else
				TppRadio.DelayPlay( "Radio_DisablementBetrayer_AfterDemo", "short" )	-- 「そいつをどこかに隠せ、怪しまれるぞ」
			end
		end
	end
	-- 接触可否チェックタイマーを停止
	TppTimer.Stop( "BetrayerContactCheckTimer" )

end
----------------------------------------
-- ■ commonBetrayerCarried
-- 内通者を担いだ
this.commonBetrayerCarried = function()
	Fox.Log("----------------commonBetrayerCarried----------------")

	-- 内通者を特定できていなければこの時点で特定マーキングする
	if ( TppMission.GetFlag( "isBetrayerMarking" ) == false and
		 TppMission.GetFlag( "isGetCassette_A" ) == false and TppMission.GetFlag( "isGetCassette_B" ) == false ) then
		-- ターゲットマーカーON
		this.commonBetrayerMarkerOn()
		TppRadio.Play("Radio_MarkingBetrayer4")		-- 「そいつがターゲットだ」
	end
end
---------------------------------------------------------------------------------
-- ■ commonBetrayerRestraint
-- 内通者を拘束した
this.commonBetrayerRestraint = function()
	Fox.Log("----------------commonBetrayerRestraint----------------")

	-- 拘束し続けていた場合の判定のためにフラグリセット
	this.CounterList.BetrayerRestraint = 0

	-- テープB未入手なら
	if ( TppMission.GetFlag( "isGetCassette_B" ) == false ) then
		-- 内通者への接触可否チェック
		this.commonBetrayerContactCheck()
	end

	-- 内通者を特定できていなければこの時点で特定マーキングする
	if ( TppMission.GetFlag( "isBetrayerMarking" ) == false and
		 TppMission.GetFlag( "isGetCassette_A" ) == false and TppMission.GetFlag( "isGetCassette_B" ) == false ) then
		-- ターゲットマーカーON
		this.commonBetrayerMarkerOn()
		TppRadio.Play("Radio_MarkingBetrayer4")		-- 「そいつがターゲットだ」
	end
end
----------------------------------------
-- ■ commonBetrayerRestraintEnd
-- 内通者が拘束解除された
this.commonBetrayerRestraintEnd = function()
	Fox.Log("----------------commonBetrayerRestraintEnd----------------")

	-- 拘束解除時のミラー無線名が予約されているか（＝一連の尋問結果に対するリアクション無線は初回のみ）
	if ( this.CounterList.BetrayerRestraintEndRadio ~= "NoRadio" ) then

		-- !調査員拘束デモ見た && !罠だと知ってるフラグ && テープＡ持ってる && !テープＢ落とした
		if (( TppMission.GetFlag( "isBetrayerContact" ) == false and
			  TppMission.GetFlag( "isGetInfo_Suspicion2" ) == false and
			  TppMission.GetFlag( "isGetCassette_A" ) == true and
			  TppMission.GetFlag( "isDropCassette_B" ) == false ) ) then

			this.CounterList.BetrayerRestraintEndRadio = "Radio_Reaction_Escape"	-- 「どういうことだ」「ともかく目的は果たした。帰投してくれ」
		end

		-- 予約されていたミラー無線をコール
		TppRadio.DelayPlay( this.CounterList.BetrayerRestraintEndRadio, "short" )

		-- 無線名を初期化しておく
		this.CounterList.BetrayerRestraintEndRadio = "NoRadio"

	end

	-- 拘束し続けていた場合の判定のためにフラグリセット
	this.CounterList.BetrayerRestraint = 0

	-- 接触可否チェックタイマーを停止
	TppTimer.Stop( "BetrayerContactCheckTimer" )
end
----------------------------------------
-- ■ commonBetrayerMarkerOn
-- 内通者を指定マーキング
this.commonBetrayerMarkerOn = function()
	Fox.Log("----------------commonBetrayerMarkerOn----------------")

	TppMission.SetFlag( "isBetrayerMarking", true )
	-- ターゲットマーカー表示ＯＮ
	TppMarker.Enable( this.BetrayerID, 0, "moving", "all", 0, true, true )
	TppMarkerSystem.EnableMarker{ markerId = this.BetrayerID, viewType = { "VIEW_MAP_ICON", "VIEW_WORLD_ICON" } }	-- 通常マーキングがされてなくても確実にココでつける

	----- 端末上のアイコンにカーソルがあったら出る説明分文を更新する -----
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
		return
	end

	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
		return
	end

	luaData:RegisterIconUniqueInformation( { markerId= this.BetrayerID, langId="marker_info_agent" })

	-- ターゲットマーカー音
	GZCommon.CallSearchTarget()

	-- 敵兵への諜報無線を更新
	this.commonUpdateCheckEnemyIntelRadio()

end
----------------------------------------
-- ■ commonMastermindDead
-- 反乱兵が死亡した
this.commonMastermindDead = function()
	Fox.Log("----------------commonMastermindDead----------------")

	TppMission.SetFlag( "isMastermindDown", true )
	this.commonBetrayerInterrogationSetUpdate()	-- 内通者の尋問時セリフセット更新

	-- テープBを入手前かつテープBドロップ前に反乱兵が死亡したらチャレンジ失敗
	if ( TppMission.GetFlag( "isGetCassette_B" ) == false and TppMission.GetFlag( "isDropCassette_B" ) == false ) then
		PlayRecord.UnsetMissionChallenge( "TAPE_GET" )

	end
end
----------------------------------------
-- ■ commonMastermindRestraintEnd
-- 反乱兵が拘束解除された
this.commonMastermindRestraintEnd = function()
	Fox.Log("----------------commonMastermindRestraintEnd----------------")

	-- 拘束解除時のミラー無線名が予約されているか
	if ( this.CounterList.MastermindRestraintEndRadio ~= "NoRadio" ) then

		-- 予約されていたミラー無線をコール
		TppRadio.DelayPlay( this.CounterList.MastermindRestraintEndRadio, "short" )

		-- 無線名を初期化しておく
		this.CounterList.MastermindRestraintEndRadio = "NoRadio"

	end
end
---------------------------------------------------------------------------------
-- ■ commonMissionTargetMarkingCheck
this.commonMissionTargetMarkingCheck = function()
	local CharacterID = TppData.GetArgument(1)
	-- Fox.Log( "this.commonMissionTargetMarkingCheck::"..CharacterID )
	-- 内通者
	if( CharacterID == this.BetrayerID ) then
		-- ターゲットマーカー表示されてない、かつテープAもテープBも所持していない、かつ内通者に接触していない
		if( TppMission.GetFlag( "isBetrayerMarking" ) == false and
			TppMission.GetFlag( "isGetCassette_A" ) == false and
			TppMission.GetFlag( "isGetCassette_B" ) == false and
			TppMission.GetFlag( "isBetrayerContact" ) == false ) then

			Fox.Log( "this.commonMissionTargetMarkingCheck::"..CharacterID )

			-- 全てのマーカーの新規フラグを解除する
			TppMarkerSystem.ResetAllNewMarker()

			-- ターゲットマーカーON
			this.commonBetrayerMarkerOn()

			-- 無線
			-- 周囲に敵がいるかどうかで後半の台詞が分岐
			local enemyNum = TppEnemyUtility.GetNumberOfActiveSoldierByCharacterId( this.BetrayerID, 5 )

			if ( enemyNum == 0 ) then
				local MarkingBetrayer = { "Radio_MarkingBetrayer1", "Radio_MarkingBetrayer2" }
				TppRadio.Play( MarkingBetrayer )
			else
				local MarkingBetrayer = { "Radio_MarkingBetrayer1", "Radio_MarkingBetrayer3" }
				TppRadio.Play( MarkingBetrayer )
			end

			-- 内通者への諜報無線を専用のものに差し替え
			TppRadio.RegisterIntelRadio( this.BetrayerID, "e0030_esrg0020", true )	-- 内通者を諜報：奴が1人の時に接触しろ

			-- 端末写真確認促し無線タイマーを停止
			TppTimer.Stop( "CheckTargetPhotoTimer" )
		end
	-- 反乱兵
	elseif( CharacterID == this.MastermindID ) then
		-- ターゲットマーカー表示されてない、かつ反乱兵の情報を得ている
		if( TppMission.GetFlag( "isMastermindMarking" ) == false and TppMission.GetFlag( "isGetInfo_Mastermind" ) == true ) then
			TppMission.SetFlag( "isMastermindMarking", true )

			Fox.Log( "this.commonMissionTargetMarkingCheck::"..CharacterID )

			-- 全てのマーカーの新規フラグを解除する
			TppMarkerSystem.ResetAllNewMarker()

			-- ターゲットマーカー表示ＯＮ
			TppMarker.Enable( this.MastermindID, 0, "moving", "map_only_icon", 0, true )
			-- ターゲットマーカー音
			GZCommon.CallSearchTarget()
			-- 無線
			TppRadio.Play( "Radio_MarkingMastermind" )

			-- 反乱兵への諜報無線を有効化
			TppRadio.EnableIntelRadio( "e20030_Mastermind")
		end
	end
end
----------------------------------------
-- ■ commonOnLaidEnemy
-- 敵兵が乗り物に乗せられた
this.commonOnLaidEnemy = function()

	local sequence				= TppSequence.GetCurrentSequence()
	local EnemyCharacterID		= TppData.GetArgument(1)
	local VehicleCharacterID	= TppData.GetArgument(3)
	local EnemyLife				= TppEnemyUtility.GetLifeStatus( EnemyCharacterID )

	Fox.Log("------- commonOnLaidEnemy---:"..EnemyCharacterID)

	-- そもそも死亡してたら何もしない
	if ( EnemyLife ~= "Dead" ) then
		-- ヘリに乗せた
		if( VehicleCharacterID == "SupportHelicopter" ) then
			-- クリア条件を達成済みなら
			if ( TppMission.GetFlag("isGetCassette_A") == true or TppMission.GetFlag("isGetCassette_B") == true ) then
				TppRadio.DelayPlay( "Radio_HostageOnHeli", "short" )	-- 捕虜をヘリに乗せた無線と同じものをコール「よし、回収した」
			else
				-- 内通者接触前シーケンスで内通者を回収したら専用の無線コール
				if ( sequence == "Seq_Waiting_BetrayerContact" and EnemyCharacterID == this.BetrayerID ) then

					TppRadio.DelayPlay( "Radio_BetrayerOnHeli", "mid", "end" )	-- 「調査員を回収するのか？　わかった。テープの情報を聞き出そう」

					-- 情報聞き出し中フラグ
					TppMission.SetFlag( "listeningInfoFromBetrayer", true )
					-- 任意無線を更新
					this.commonOptionalRadioUpdate()
					-- 内通者から情報を聞き出した無線タイマー開始
					TppTimer.Start( "Timer_ListeningInfoFromBetrayer", this.Time_ListeningInfoFromBetrayer )
				else
					local EncourageMission = { "Radio_HostageOnHeli", "Radio_EncourageMission" }	-- 「よし、回収した」「任務に戻ってくれ、ボス」
					TppRadio.DelayPlay( EncourageMission, "short", "begin", {
						onEnd = function()
							if ( TppMission.GetFlag("isBetrayerContact") == true ) then
								-- 内通者接触済みなら「カセット入手」を促す
								TppRadio.DelayPlay( "Radio_RecommendGetCassette_A", "mid", "end" )
							else
								-- 内通者未接触なら「調査員接触」を促す
								TppRadio.DelayPlay( "Radio_MissionBriefing2", "mid", "end" )
							end
						end
					} )
				end
			end

			-- 反乱兵だったらフラグ（拉致してカセット入手、は無くなったがヘリ撃墜されたら死亡扱いにするため）
			if( EnemyCharacterID == this.MastermindID ) then
				TppMission.SetFlag( "isMastermindOnHeli", true )
				this.commonBetrayerInterrogationSetUpdate()	-- 内通者の尋問時セリフセット更新

				-- アナウンスログ表示
				this.commonCallAnnounceLog( this.AnnounceLogID_RecoveryMastermind )
				-- 戦績反映
				PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE", this.MastermindID )
			end
			-- 内通者だったらフラグ（ヘリ撃墜されたら死亡扱いにするため）
			if( EnemyCharacterID == this.BetrayerID ) then
				TppMission.SetFlag( "isBetrayerOnHeli", true )
				-- アナウンスログ表示
				this.commonCallAnnounceLog( this.AnnounceLogID_RecoveryBetrayer )
				-- 戦績反映
				PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE", this.BetrayerID )
			end
		-- ヘリ以外（＝ビークルのみ？）
		else
			-- 今のところ何もなし
		end
	end
end
---------------------------------------------------------------------------------
-- ■ EndCPRadio
-- CP無線が終わった
this.EndCPRadio = function()

	local RadioEnentName = TppData.GetArgument(1)

	Fox.Log( "---------- EndCPRadio---RadioEnentName::"..RadioEnentName )

	-- 「監視カメラに異常発生」無線連絡終了後かつ中央管制塔の監視カメラ破壊済みで、かついずれの破壊時無線も未再生で一度もカメラに見つかっていない
	if( RadioEnentName == this.SecurityCameraDeadRadioName and
		TppMission.GetFlag( "isCameraBroken" ) == true and
		TppMission.GetFlag( "isCameraBrokenRadio" ) == false and
		TppMission.GetFlag( "isCameraAlert" ) == false and
		TppMission.GetFlag( "isCameraIntelRadioPlay" ) == false ) then	-- 監視カメラへの諜報無線を聞いていない

		-- 破壊時無線コール
		if ( this.CounterList.CameraBrokenRadio ~= "NoRadio") then
			TppRadio.DelayPlay( this.CounterList.CameraBrokenRadio, "short" )
		end
		TppMission.SetFlag( "isCameraBrokenRadio", true )
	end

end
----------------------------------------
-- ■ commonUpdateGuardTarget
-- ガードターゲットの更新
this.commonUpdateGuardTarget = function()

	-- クリア条件を満たしていたらガードターゲットをプレイヤーの所属エリアに応じて更新
	if ( TppMission.GetFlag( "isGetCassette_A" ) == true or
		 TppMission.GetFlag( "isGetCassette_B" ) == true ) then
		Fox.Log("--------- commonUpdateGuardTarget ----------")

		-- 調整次第でもう少し粒度細かくするかも
		if ( this.CounterList.PlayerArea == "Area_campWest" ) then
			-- 拠点西側
			TppCommandPostObject.GsSetGuardTargetValidity( "gntn_cp", "TppGuardTargetData_Gate", false )
			TppCommandPostObject.GsSetGuardTargetValidity( "gntn_cp", "TppGuardTargetData_InspectionNorth", false )
			TppCommandPostObject.GsSetGuardTargetValidity( "gntn_cp", "TppGuardTargetData_InspectionWest", true )

		else
			-- それ以外
			TppCommandPostObject.GsSetGuardTargetValidity( "gntn_cp", "TppGuardTargetData_Gate", false )
			TppCommandPostObject.GsSetGuardTargetValidity( "gntn_cp", "TppGuardTargetData_InspectionNorth", true )
			TppCommandPostObject.GsSetGuardTargetValidity( "gntn_cp", "TppGuardTargetData_InspectionWest", false )

		end
		-- コンバットライン更新
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0000",false)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0106",false)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0057",false)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0010",true)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0121",true)

	else
		-- 普段はヘリポート側のガードターゲット
		TppCommandPostObject.GsSetGuardTargetValidity( "gntn_cp", "TppGuardTargetData_Gate", true )
		TppCommandPostObject.GsSetGuardTargetValidity( "gntn_cp", "TppGuardTargetData_InspectionNorth", false )
		TppCommandPostObject.GsSetGuardTargetValidity( "gntn_cp", "TppGuardTargetData_InspectionWest", false )

		-- コンバットライン更新
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0167",false)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0095",false)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0146",false)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0014",true)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0130",true)
	end
end

-- commonOnDeadHostage
this.commonOnDeadHostage = function()
	Fox.Log( "commonOnDeadHostage" )
	local HostageCharacterID	= TppData.GetArgument(1)
	local PlayerDead			= TppData.GetArgument(4)
	-- 無線
	if( PlayerDead == true ) then
		TppRadio.DelayPlay( "Radio_HostageDead", "mid" )
	end
	TppRadio.DisableIntelRadio( HostageCharacterID )

end

---------------------------------------------------------------------------------
-- ■■ Interrogation Functions
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- ■ commonMastermindInterrogation
-- 反乱兵を尋問した
this.commonMastermindInterrogation = function()
	Fox.Log("----------------commonMastermindInterrogation----------------")

	-- 反乱兵：尋問台詞内訳
	-- 台詞A「くっ・・・このテープが欲しいのか」
	-- 台詞B「もう遅い。計画は止まらん。俺たちは国家を超える」

	-- カセットB未入手（尋問1回目or字幕が咽んでかき消された）ならカウンターを再セット
	if ( TppMission.GetFlag( "isDropCassette_B" ) == false ) then

		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.MastermindID, 0 )

	-- カセットB入手済み（尋問2回目以降or台詞Bの字幕が被って出なかった）
	else

		-- 以降はずっと台詞B
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.MastermindID, 1 )

	end
end

---------------------------------------------------------------------------------
-- ■ commonBetrayerContactCheck
-- 内通者への接触可否チェック
-- 接触デモの発生が可能かどうかを判定する
this.commonBetrayerContactCheck = function()
	Fox.Log("----------------commonBetrayerContactCheck----------------")

	-- チェックを回すので、念のため再度ステータスが「拘束中かどうか」を判定
	local status = TppEnemyUtility.GetStatus( this.BetrayerID )

	if ( status == "Hung") then
		-- 内通者の周囲に居るアクティブな敵兵数を取得
		local enemyNum = TppEnemyUtility.GetNumberOfActiveSoldierByCharacterId( this.BetrayerID, this.Size_ActiveEnemy )

		-- 周囲に敵が居たらデモ再生しない
		if ( enemyNum ~= 0 ) then
			Fox.Log("---------OtherEnemy_is_Here-------")

			-- 接触デモ前ならミラー無線
			if ( TppSequence.GetCurrentSequence() == "Seq_Waiting_BetrayerContact") then

				-- 接触前で付近に他の兵士がいたら台詞Aをセット
				TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 0 )

				-- 「今は接触出来ない」系の無線を言うのは拘束1回につき初回の1回のみ
				if ( this.CounterList.BetrayerRestraint == 0 ) then
					if ( TppEnemy.GetPhase( "gntn_cp" ) == "alert" ) then
						TppRadio.Play( "Radio_ContactNot_Phase")		-- 戦闘中なので接触出来ない無線
					else
						TppRadio.Play( "Radio_ContactNot_NearEnemy2")	-- 付近に敵が居るので接触出来ない無線
					end
					this.CounterList.BetrayerRestraint = 1	-- フラグを立てておく
				end
			end
		-- 敵が居ない上で条件成立ならデモ再生
		elseif ( (TppMission.GetFlag( "isBetrayerContact" ) == false) and
				 (TppMission.GetFlag( "isGetCassette_A" ) == false) and
				 (TppMission.GetFlag( "isDropCassette_B" ) == false) and
				 (TppMission.GetFlag( "isGetInfo_Suspicion2" ) == false) and
			--	 ( TppMission.GetFlag( "isMastermindDown" ) == false and TppMission.GetFlag( "isMastermindOnHeli" ) == false ) and
				 ((TppEnemy.GetPhase( "gntn_cp" ) ~= "alert") ) ) then
			Fox.Log("------- ContactDemoCheck:OK -------")
			-- 尋問初回でカセットも入手しておらず、周囲に敵が居ない、接触もしていないので接触デモ再生
			TppSequence.ChangeSequence( "Seq_BetrayerContactDemo" )
		else
			-- 尋問台詞セット設定時に最初の尋問台詞はセットされているのでここでは何もする必要が無い
		end
	end

	-- 接触デモ前であれば接触可否チェック用のタイマーを始動
	if ( TppSequence.GetCurrentSequence() == "Seq_Waiting_BetrayerContact") then
		TppTimer.Start( "BetrayerContactCheckTimer", 7 )
	end

end

---------------------------------------------------------------------------------
-- ■ commonBetrayerInterrogation
-- 内通者を尋問した
this.commonBetrayerInterrogation = function()
	Fox.Log("--------- commonBetrayerInterrogation ---------")

	-- 内通者：尋問台詞内訳
	-- 台詞A「やめてくれ。他の兵士に怪しまれる」
	-- 台詞B「ひ・・・す、すまない。連中にバレて脅されたんだ」
	-- 台詞C「て、テープも奪われた。スキンヘッドの兵士だ」
	-- 台詞D「許してくれ。家族が居る。人質に取られているんだ」

	-- 現在の尋問台詞セット名を取得
	local SetName = this.CounterList.BetrayerInterrogationSet
	-- 最後に表示された尋問台詞名を取得
	local SerifName = this.CounterList.BetrayerInterrogationSerif

	Fox.Log("--- commonBetrayerInterrogation:SetName::"..SetName )
	Fox.Log("--- commonBetrayerInterrogation:SerifName::"..SerifName )

	-- セット名毎に次の尋問台詞番号を設定する
	if ( SetName == "BCD" ) then
		if ( SerifName == "B") then
			TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 2 )
		elseif ( SerifName == "C" or SerifName == "D" ) then
			TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 3 )
		else
			-- 一度もこの台詞セット内の台詞が表示されていないのでセットの頭に番号を設定
			TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 1 )
		end
	elseif ( SetName == "BD" ) then
		if ( SerifName == "B" or SerifName == "D" ) then
			TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 3 )
		else
			-- 一度もこの台詞セット内の台詞が表示されていないのでセットの頭に番号を設定
			TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 1 )
		end
	elseif ( SetName == "A" ) then
		-- この台詞セットは常に台詞が同じ
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 0 )

	else
		Fox.Warning("--- commonBetrayerInterrogation:Irregul SetName!! ---")
		-- 保険処理
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 0 )

	end
end
---------------------------------------------------------------------------------
-- ■ commonBetrayerInterrogationSetUpdate
-- 内通者の尋問時セリフセット更新
this.commonBetrayerInterrogationSetUpdate = function()

	Fox.Log("--------- commonBetrayerInterrogationSetUpdate ---------")

	-- 尋問セリフに影響する各フラグをチェックしてセリフセットを更新
	-- isBetrayerContact		-- 内通者接触済み
	-- isGetCassette_A			-- カセットA取得済み
	-- isDropCassette_B		-- カセットBドロップ済み
	-- isGetInfo_Suspicion2	-- 罠だと確信した
	-- isMastermindDown		-- 反乱兵が死亡した
	-- isMastermindOnHeli		-- 反乱兵がヘリに乗せられた

		-- 調査員拘束デモ見た && !罠だと知ってるフラグ && !テープＢ落とした
	if ( TppMission.GetFlag( "isBetrayerContact" ) == true and
		 TppMission.GetFlag( "isGetInfo_Suspicion2" ) == false and
		 TppMission.GetFlag( "isDropCassette_B" ) == false ) then
		this.CounterList.BetrayerInterrogationSet = "A"
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 0 )

		-- !調査員拘束デモ見た && !罠だと知ってるフラグ && テープＡ持ってる && !テープＢ落とした && スキンヘッド退場
	elseif (
			( TppMission.GetFlag( "isBetrayerContact" ) == false and
			  TppMission.GetFlag( "isGetInfo_Suspicion2" ) == false and
			  TppMission.GetFlag( "isGetCassette_A" ) == true and
			  TppMission.GetFlag( "isDropCassette_B" ) == false and
			  ( TppMission.GetFlag( "isMastermindDown" ) == true or TppMission.GetFlag( "isMastermindOnHeli" ) == true ) ) or
		-- 罠だと知ってるフラグ && !テープＢ落とした && スキンヘッド退場
		   ( TppMission.GetFlag( "isGetInfo_Suspicion2" ) == true and
			 TppMission.GetFlag( "isDropCassette_B" ) == false and
			( TppMission.GetFlag( "isMastermindDown" ) == true or TppMission.GetFlag( "isMastermindOnHeli" ) == true ) )
		   ) then
		this.CounterList.BetrayerInterrogationSet = "BD"
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 1 )

		-- !調査員拘束デモ見た && !罠だと知ってるフラグ && テープＡ持ってる && !テープＢ落とした && !スキンヘッド退場
	elseif (
			( TppMission.GetFlag( "isBetrayerContact" ) == false and
			  TppMission.GetFlag( "isGetInfo_Suspicion2" ) == false and
			  TppMission.GetFlag( "isGetCassette_A" ) == true and
			  TppMission.GetFlag( "isDropCassette_B" ) == false and
			  ( TppMission.GetFlag( "isMastermindDown" ) == false and TppMission.GetFlag( "isMastermindOnHeli" ) == false ) ) or
		-- 調査員拘束デモ見た && 罠だと知ってるフラグ && !テープＡ持ってる && !テープＢ落とした && !スキンヘッド退場
		   ( TppMission.GetFlag( "isBetrayerContact" ) == true and
			 TppMission.GetFlag( "isGetInfo_Suspicion2" ) == true and
			 TppMission.GetFlag( "isGetCassette_A" ) == false and
			 TppMission.GetFlag( "isDropCassette_B" ) == false and
			( TppMission.GetFlag( "isMastermindDown" ) == false and TppMission.GetFlag( "isMastermindOnHeli" ) == false ) ) or
		-- 罠だと知ってるフラグ && テープＡ持ってる && !テープＢ落とした && !スキンヘッド退場
		   ( TppMission.GetFlag( "isGetInfo_Suspicion2" ) == true and
			 TppMission.GetFlag( "isGetCassette_A" ) == true and
			 TppMission.GetFlag( "isDropCassette_B" ) == false and
			( TppMission.GetFlag( "isMastermindDown" ) == false and TppMission.GetFlag( "isMastermindOnHeli" ) == false ) )
		   ) then
		this.CounterList.BetrayerInterrogationSet = "BCD"
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 1 )

	else
		this.CounterList.BetrayerInterrogationSet = "BCD"
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 1 )
	end

end
-- ■ commonFinishBetrayerSerif1
-- 内通者尋問後の処理１（暫定処理）
this.commonFinishBetrayerSerif1 = function()
	Fox.Log("----------------commonFinishBetrayerSerif1----------------")

	-- 拘束中に言うと「あいつ」は不自然なので「掴まれているかどうか」の判定をいれてみる
	if ( TppEnemyUtility.GetStatus( this.BetrayerID ) ~= "Hung" ) then
		TppRadio.Play( "Radio_Reaction_Intimidation" )	-- 「あいつの言う『連中』･･･サイファーか？」
	else
		-- ダメならタイマー再開
		TppTimer.Start( "dbg_InterrogationTimer_Betrayer1", 10 )
	end
end
-- ■ commonFinishBetrayerSerif2
-- 内通者尋問後の処理２（暫定処理）
this.commonFinishBetrayerSerif2 = function()
	Fox.Log("----------------commonFinishBetrayerSerif2----------------")

	TppRadio.Play( "Radio_Reaction_Escape" )	-- 「どういうことだ」「ともかく目的は果たした。帰投してくれ」

end
---------------------------------------------------------------------------------
-- ■ commonBetrayerInterrogationRegister
-- 内通者の尋問カウンターを初期化
this.commonBetrayerInterrogationRegister = function()
	Fox.Log("----------------commonBetrayerInterrogationRegister----------------")

	this.CounterList.BetrayerInterrogation = 0
	TppEnemyUtility.SetInterrogationAllDoneFlagByCharacterId( this.BetrayerID, false )

end

---------------------------------------------------------------------------------
-- ■ commonRadioCallAfterBetrayerInterrogation
-- 内通者尋問後のミラー無線コール
this.commonRadioCallAfterBetrayerInterrogation = function()

	-- 拘束状態解除後またはホールドアップ尋問後一定距離以上離れたら、ミラー無線
	-- 各フラグをチェックしてしかるべき台詞を言う

end
---------------------------------------------------------------------------------
-- ■■ Subtitles Functions
---------------------------------------------------------------------------------
-- ■ commonCallAnnounceLog
-- アナウンスログ表示
this.commonCallAnnounceLog = function( langId )
	Fox.Log( "commonCallAnnounceLog sequence:"..langId )

	local hudCommonData = HudCommonDataManager.GetInstance()

	hudCommonData:AnnounceLogViewLangId( langId )

	-- 端末情報更新アリ、の音
	TppSoundDaemon.PostEvent( "sfx_s_terminal_data_fix" )

end
--------------------------------------------
-- ■ commonShowTutorial_CQC
-- チュートリアル表示：CQC
this.commonShowTutorial_CQC = function()
	Fox.Log( "----- commonShowTutorial_CQC -----" )

	-- 1ボタン
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:CallButtonGuide( "tutorial_restraint","PL_CQC" )

end
--------------------------------------------
-- ■ commonSubtitles_BetrayerSerifA
-- 内通者尋問台詞A：「やめてくれ。他の兵士に怪しまれる」
this.commonSubtitles_BetrayerSerifA = function()

	Fox.Log("---commonSubtitles_BetrayerSerifA---")

	this.CounterList.BetrayerInterrogationSerif = "A"

	-- 字幕表示された＝尋問されたとみなして尋問回数カウンターを回す
	-- this.CounterList.BetrayerInterrogation = this.CounterList.BetrayerInterrogation + 1

end
-- ■ commonSubtitles_BetrayerSerifB
-- 内通者尋問台詞B：「ひ･･･すまない・連中にバレて脅されたんだ」
this.commonSubtitles_BetrayerSerifB = function()

	Fox.Log("---commonSubtitles_BetrayerSerifB---")

	-- 初回のみ無線
	if ( TppMission.GetFlag( "isGetInfo_Intimidation" ) == false ) then

		-- 無線名を予約登録しておく
		this.CounterList.BetrayerRestraintEndRadio = "Radio_Reaction_Intimidation"	-- 「そいつの言う『連中』･･･サイファーか？」
	end

	this.CounterList.BetrayerInterrogationSerif = "B"

	-- 内通者が脅迫されていたことを知った
	TppMission.SetFlag( "isGetInfo_Intimidation", true )

	-- 字幕表示された＝尋問されたとみなして尋問回数カウンターを回す
	-- this.CounterList.BetrayerInterrogation = this.CounterList.BetrayerInterrogation + 1

end
-- ■ commonSubtitles_BetrayerSerifC
-- 内通者尋問台詞C：「テープも奪われた。スキンヘッドの兵士だ」
this.commonSubtitles_BetrayerSerifC = function()

	Fox.Log("---commonSubtitles_BetrayerSerifC---")

	-- 初回のみ無線
	if ( TppMission.GetFlag( "isGetInfo_Mastermind" ) == false ) then

		-- この時点で「テープＡ持っていない」 &&「!テープＢ落としてない」 && 「スキンヘッドが居る」なら
		if ( TppMission.GetFlag( "isGetCassette_A" ) == false and
			 TppMission.GetFlag( "isDropCassette_B" ) == false and
			 ( TppMission.GetFlag( "isMastermindDown" ) == false and TppMission.GetFlag( "isMastermindOnHeli" ) == false ) ) then

			-- テープBの存在は知らないので捜索を促す
			this.CounterList.BetrayerRestraintEndRadio = "Radio_Reaction_Search"	-- 「テープを奪った兵士……捜してみるか？」
		elseif ( TppMission.GetFlag( "isDropCassette_B" ) == true ) then

			-- テープBの存在を知っているのでリアクション
			this.CounterList.BetrayerRestraintEndRadio = "Radio_Reaction_Truth"	-- 「あのテープ……そういうことか！」
		end
	end

	this.CounterList.BetrayerInterrogationSerif = "C"

	-- 反乱兵に関する情報を入手した
	TppMission.SetFlag( "isGetInfo_Mastermind", true )

	-- 敵兵への諜報無線内容を更新する
	this.commonUpdateCheckEnemyIntelRadio()

	-- 任意無線を更新
	this.commonOptionalRadioUpdate()

	-- この時点で内通者への割り当てルートが「反乱兵との会話」ルートだったら元に戻す
	local routeId = TppEnemyUtility.GetRouteId( this.BetrayerID )
	if ( routeId == GsRoute.GetRouteId("gntn_e20030_tgt_route0003") ) then
		-- 通常の巡回ルートに戻す（全体巡回ルート）
		this.ChangeBetrayerRoute( "e20030_routeSet_d01_basic02", "gntn_e20030_tgt_route0000", 16 )
		this.commonBetrayerRouteWareHouse()
	end

	-- 字幕表示された＝尋問されたとみなして尋問回数カウンターを回す
	-- this.CounterList.BetrayerInterrogation = this.CounterList.BetrayerInterrogation + 1

end
-- ■ commonSubtitles_BetrayerSerifD
-- 内通者尋問台詞D：「許してくれ。家族が居る。人質に取られているんだ」
this.commonSubtitles_BetrayerSerifD = function()

	Fox.Log("---commonSubtitles_BetrayerSerifD---")

	this.CounterList.BetrayerInterrogationSerif = "D"

end

-- ■ commonSubtitles_DropTapeB
-- 反乱兵尋問台詞A：「くっ・・・このテープが欲しいのか」
this.commonSubtitles_DropTapeB = function()

	Fox.Log("---commonSubtitles_DropTapeB---")

	-- テープBドロップタイマー
	TppTimer.Start( "CassetteDropTimer", 3 )

	TppMission.SetFlag( "isDropCassette_B", true )
	this.commonBetrayerInterrogationSetUpdate()	-- 内通者の尋問時セリフセット更新

	-- 任意無線を更新
	this.commonOptionalRadioUpdate()

	-- ミッション説明文更新
	this.commonUpdateMissionDescription()

	-- ミッション中間目標更新
	commonMissionSubGoalSetting( this.MissionSubGoal_Cassette )

	-- 反乱兵の諜報無線も無効化
	TppRadio.DisableIntelRadio( "e20030_Mastermind")

	-- 敵兵への諜報無線内容を更新する
	this.commonUpdateCheckEnemyIntelRadio()

	-- 尋問カウンターをセット（台詞Bにする）
	TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.MastermindID, 1 )

	-- 拘束解除後のミラー無線名を条件に応じて予約登録しておく
	if ( TppMission.GetFlag( "isGetInfo_Mastermind" ) == true ) then
		-- 尋問ヒントあり
		-- 「やはりそいつがテープを持っていたか」
		this.CounterList.MastermindRestraintEndRadio = "Radio_DropCassette_B_Confidence"

	elseif ( TppMission.GetFlag( "isGetCassette_A" ) == false ) then
		-- 尋問ヒントなし、カセットAを持っていない
		-- 「何でそいつがテープを？渡ったのか？」
		this.CounterList.MastermindRestraintEndRadio = "Radio_DropCassette_B_Suspicion"

	else
		-- 尋問ヒントなし、カセットAを持っている
		-- 「テープがもう1つ･･･どういうことだ？」
		this.CounterList.MastermindRestraintEndRadio = "Radio_DropCassette_B_NoHint"
	end

	-- この時点で保険として内通者尋問リアクション用無線名を初期化しておく
	this.CounterList.BetrayerRestraintEndRadio = "NoRadio"

end
-- ■ commonSubtitles_Rebellion
-- 反乱兵尋問台詞B：「もう遅い。計画は止まらん。俺たちは国家を超える」
this.commonSubtitles_Rebellion = function()

	Fox.Log("---commonSubtitles_Rebellion---")

	local radioDaemon = RadioDaemon:GetInstance()

	-- この尋問セリフに対するリアクション無線が再生済みかどうか
	if ( radioDaemon:IsRadioGroupMarkAsRead("e0030_rtrg0230") == false ) then

		-- 未だ拘束解除後のミラー無線名が予約登録されていない
		if ( this.CounterList.MastermindRestraintEndRadio == "NoRadio" ) then
			-- 拘束解除後のミラー無線名を予約登録
			this.CounterList.MastermindRestraintEndRadio = "Radio_Reaction_Rebellion"	-- 「国家を超える？どゆこと？？」
		end
	end

--	TppMission.SetFlag( "isGetInfo_Rebellion", true )

	-- 尋問2回目以降ならずっと台詞B
	TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.MastermindID, 1 )

end
-- ■ commonSubtitles_TrapA
-- 内通者会話台詞：「接触してきた男を中央管制塔に誘導した」
this.commonSubtitles_TrapA = function()
	Fox.Log("--- commonSubtitles_TrapA ---")
	-- 内通者の誘導に疑惑を持った
	TppMission.SetFlag( "isGetInfo_Suspicion1", true )

end
-- ■ commonSubtitles_TrapB
-- 内通者会話台詞：「こっちも準備は完了･･･後はあの『ボス』が監視に引っかかるのを･･･」
this.commonSubtitles_TrapB = function()
	Fox.Log("--- commonSubtitles_TrapB ---")
	-- 内通者の誘導が罠であることを知った
	TppMission.SetFlag( "isGetInfo_Suspicion2", true )
	TppMission.SetFlag( "isGetInfo_Suspicion3", true )
	this.commonBetrayerInterrogationSetUpdate()	-- 内通者の尋問時セリフセット更新

	-- 監視カメラの諜報無線を更新
	this.commonUpdateCheckCameraIntelRadio()

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■■■ Sequences
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■ Seq_MissionPrepare
-- ミッション起動前
this.Seq_MissionPrepare = {
	OnEnter = function( manager )
		this.onMissionPrepare( manager )

		-- これまでに獲得している報酬数を保持
		local uiCommonData = UiCommonDataManager.GetInstance()
		this.tmpRewardNum = uiCommonData:GetRewardNowCount( this.missionID )
		Fox.Log("***e20030_MissionPrepare.tmpRewardNum_IS___"..this.tmpRewardNum)

		TppSequence.ChangeSequence( "Seq_MissionSetup" )
	end,
}

---------------------------------------------------------------------------------
-- ■ Seq_MissionSetup
-- ミッション開始準備
this.Seq_MissionSetup = {

	OnEnter = function()
		onCommonMissionSetup()

		-- ルートセット関連初期化
		commonRouteSetMissionSetup( "e20030_routeSet_d01_basic01" )

		TppSequence.ChangeSequence( "Seq_OpeningDemoLoad" )
	end,
}

---------------------------------------------------------------------------------
-- ■ Seq_OpeningDemoLoad
-- デモブロックのロード（全てのデモが同じデモブロックに乗っている）
this.Seq_OpeningDemoLoad = {

	OnEnter = function()
		commonDemoBlockSetup()
	end,

	OnUpdate = function()
		-- デモブロックをロードするまで待機
		if( IsDemoAndEventBlockActive() ) then
			TppSequence.ChangeSequence( "Seq_OpeningShowTransition" )
		end
	end,
}

---------------------------------------------------------------------------------
-- ■ Seq_OpeningShowTransition
-- ミッション開始テロップ
this.Seq_OpeningShowTransition = {
	OnEnter = function()

		local localChangeSequence = {
			onOpeningBgEnd = function()		-- オープニングテロップのドクロマークが終了するタイミング
				TppSequence.ChangeSequence( "Seq_OpeningDemo" )
			end,
		}

		TppUI.ShowTransitionWithFadeIn( "opening", localChangeSequence )
		TppMusicManager.PostJingleEvent( "MissionStart", "Play_bgm_gntn_op_default" )
	end,
}

---------------------------------------------------------------------------------
-- ■ Seq_OpeningDemo
-- ミッション開始デモ
this.Seq_OpeningDemo = {

	Messages = {
		Timer = {
			{ data = "Timer_FadeInStart", message = "OnEnd", localFunc = "localFadeInStart" },
			{ data = "FaceLeftTimer", message = "OnEnd", localFunc = "funcFaceLeftTimer" },
			{ data = "FaceBackTimer", message = "OnEnd", localFunc = "funcFaceBackTimer" },
		},
		Trap = {
			-- ミッションエリアに侵入したかの判定
			{ data = "Trap_EnterMissionArea", 	message = { "Enter", "Exit" }, commonFunc = function() this.commonPlayerEnterMissionArea() end },
		},
		Demo = {
			-- デモスキップ(本当は"Skip"で検知したいところだけど正しく取得できないので暫定として"Finish"で)
			{ data = "p12_020000_000", 	message = "Skip", localFunc = "SkipOpeningDemo" },
		},
	},

	funcFaceLeftTimer = function()
		-- プレイヤーの向く方向を左後方に固定する
		TppPlayerUtility.SetDemoOnTruck( true )
	end,

	funcFaceBackTimer = function()

		-- プレイヤーの向く方向を正面に戻す(数値は、正面に戻るまでの時間(秒)です)。※正面に戻したいタイミングで呼んでください
		TppPlayerUtility.StartForwardToFace( 1 )

		-- ToDo デモスキップ処理暫定
		TppMission.SetFlag( "dbg_OpeningDemoSkipFlag", true )

	end,

	SkipOpeningDemo = function()
		-- プレイヤーがミッション圏内に侵入済みでなければデモスキップとみなす
		if ( TppMission.GetFlag( "dbg_OpeningDemoSkipFlag" ) == false ) then
			Fox.Log("------ Seq_OpeningDemo:OpeningDemoSkip -----")

			TppMission.SetFlag( "isOpeningDemoSkip", true )

			-- 顔の向きは戻す
			TppPlayerUtility.StartForwardToFace( 1 )
		end
	end,

	OnEnter = function()

		-- 開始デモからスタートの場合はストック方向を指定
		TppPlayerUtility.SetStock( TppPlayer.StockDirectionLeft )

		-- ミッション開始時は圏外エフェクトを無効化
		GZCommon.isOutOfMissionEffectEnable = false

		-- 追い越す歩兵とやぐら兵に専用ルートを割り当て
		TppEnemy.ChangeRoute( "gntn_cp", "e20030_DemoSoldier01", 	"e20030_routeSet_d01_basic01", "gntn_e20030_add_route0002", 0 )
		TppEnemy.ChangeRoute( "gntn_cp", "e20030_DemoSoldier02", 	"e20030_routeSet_d01_basic01", "gntn_e20030_add_route0003", 0 )
		TppEnemy.ChangeRoute( "gntn_cp", "e20030_DemoSoldier03", 	"e20030_routeSet_d01_basic01", "gntn_common_d01_route0009", 0 )

		TppDemoUtility.AddWaitCharacter("Player")
		TppDemoUtility.WaitPlayerReady()
		TppDemoUtility.SetCameraParameter()

		-- デモ中でも例外的にリアライズ指定するChara
		MissionManager.RegisterNotInGameRealizeCharacter( "Cargo_Truck_WEST_001" )	-- トラック
		MissionManager.RegisterNotInGameRealizeCharacter( "e20030_Driver" )			-- トラック運ちゃん

		TppDemo.Play( "Demo_Opening", {
										onStart = function()
											TppUI.FadeIn(0.7)
											--Demo中、荷台にくっつく設定
											TppPlayerUtility.RequestToAttachInDemo{ ownerId = "Cargo_Truck_WEST_001", connectPoint = "CNP_DECK_A", unattachOnSleep = false }

											MissionManager.RegisterNotInGameRealizeCharacter( "e20030_DemoSoldier01" )	-- トラックで追い越す歩兵１
											MissionManager.RegisterNotInGameRealizeCharacter( "e20030_DemoSoldier02" )	-- トラックで追い越す歩兵２
											MissionManager.RegisterNotInGameRealizeCharacter( "e20030_DemoSoldier03" )	-- 最初のやぐら上にいる敵兵
										end,
										onEnd 	= function() TppSequence.ChangeSequence( "Seq_MissionLoad" ) end } )

	end,

	-- デモ再生開始直後は色々バタついてるのでフェードインを少し遅らせる
	localFadeInStart = function()
		Fox.Log("----------------localFadeInStart----------------")
		TppUI.FadeIn(1)

		TppTimer.Start( "FaceLeftTimer", 15 )
		TppTimer.Start( "FaceBackTimer", 19.5 )	--顔を戻すタイマー

		-- TppDemo.Play( "Demo_Opening", { onEnd 	= function() TppSequence.ChangeSequence( "Seq_MissionLoad" ) end } )
	end,

	OnLeave = function()
	end,
}

---------------------------------------------------------------------------------
-- ■ Seq_MissionLoad
-- ゲームシーケンスの各種セットアップ
this.Seq_MissionLoad = {

	-- 処理落ち等の遅延対策としてここでも判定を取る
	Messages = {
		Trap = {
			-- ミッションエリアに侵入したかの判定
			{ data = "Trap_EnterMissionArea", 	message = { "Enter", "Exit" }, commonFunc = function() this.commonPlayerEnterMissionArea() end },
		},
	},

	OnEnter = function()
		-- ルートセット関連初期化
		-- commonRouteSetMissionSetup( "e20030_routeSet_d01_basic01" )

		commonUniqueCharaRouteSetup()

		-- 敵兵関連初期化（禁止ルート、ガードターゲット）
		--commonEnemyMissionSetup()

		-- 無線関連初期化
		--commonRadioMissionSetup()
		-- 任意無線設定
		this.commonOptionalRadioUpdate()

		-- 諜報無線を初期化
		this.commonRegisterIntelRadio()
		-- 諜報セットアップ
		this.SetIntelRadio()

		-- 監視カメラの諜報無線を更新
		this.commonUpdateCheckCameraIntelRadio()

		--汎用無線用コンポーネントの登録
		TppRadioConditionManagerAccessor.Register( "Tutorial", TppRadioConditionTutorialPlayer{ time = 1.5 } )
		TppRadioConditionManagerAccessor.Register( "Basic", TppRadioConditionPlayerBasic{ time = 0.3 } )

		-- ミッション写真有効化
		commonUiMissionPhotoSetup()

		-- ミッション中間目標設定
		commonMissionSubGoalSetting( this.MissionSubGoal_Betrayer )

		-- 尋問カウンター初期化
		this.commonBetrayerInterrogationRegister()

		-- 内通者の尋問台詞セットを初期化
		this.CounterList.BetrayerInterrogationSet = "A"
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.BetrayerID, 0 )

		-- マーカー関連初期化
		commonMarkerMissionSetup()

		TppSequence.ChangeSequence( "Seq_Waiting_BetrayerContact" )

		-- 開始デモがスキップされたならトラックと荷台のPlayer、歩兵をワープ
		if ( TppMission.GetFlag( "isOpeningDemoSkip" ) == true ) then

			-- トラック
			TppCharacterUtility.WarpCharacterIdFromIdentifier( "Cargo_Truck_WEST_001", "id_vipRestorePoint", "DemoSkip_WarpPos_Truck" )
			TppCommandPostObject.GsSetGroupVehicleRoute( "gntn_cp", "Cargo_Truck_WEST_001", "gntn_common_v01_route0010", 3 )

			-- 歩兵
			TppCharacterUtility.WarpCharacterIdFromIdentifier( "e20030_DemoSoldier01", "id_vipRestorePoint", "DemoSkip_WarpPos_Soldier01" )
			TppCharacterUtility.WarpCharacterIdFromIdentifier( "e20030_DemoSoldier02", "id_vipRestorePoint", "DemoSkip_WarpPos_Soldier02" )

		--	TppUI.FadeOut(0)	-- 車両ごとワープはバタつくのでフェード
		end
	end,
}
---------------------------------------------------------------------------------
-- ■ Seq_TruckInfiltration
-- ミッション開始時トラックで基地内部へ侵入中
-- 実際には開始デモ再生が入ってここのシーケンス自体は使わなくなるかも。
this.Seq_TruckInfiltration = {
	Messages = {
		Trap = {
			-- ミッションエリアに侵入したかの判定
			{ data = "Trap_EnterMissionArea", 	message = { "Enter", "Exit" }, commonFunc = function() this.commonPlayerEnterMissionArea() end },
		},
	},

	OnEnter = function()

		TppPadOperatorUtility.SetMasksForPlayer( 0, "Hospital_Wait" )			-- 左スティック操作を無効に

	end,

	OnLeave = function()

		TppPadOperatorUtility.ResetMasksForPlayer( 0, "Hospital_Wait" )			-- 左スティック操作を戻す
	end,
}

---------------------------------------------------------------------------------
-- ■ Seq_Waiting_BetrayerContact
-- 内通者に接触する前
this.Seq_Waiting_BetrayerContact = {

	--CheckLookingTargetの使用を宣言
	checkingsOnThisSequence = {
		"CheckLookingTarget"
	},

	Messages = {
		Character = {
			-- 取り巻き兵が無力化された
			{ data = this.AssistantID,	message= { "EnemyDead", "EnemySleep", "EnemyFaint"	},	localFunc = "OnDisablementAssistant" },
		},

		Terminal = {
			{ message = "MbDvcActWatchPhoto",	localFunc = "OnMbDvcActWatchPhoto" },
		},
		Trap = {
			-- ミッションエリアに侵入したかの判定
			{ data = "Trap_EnterMissionArea", 	message = { "Enter", "Exit" }, commonFunc = function() this.commonPlayerEnterMissionArea() end },
		},
		Timer = {
			{ data = "OpeningDemoSkipFadeInTimer", message = "OnEnd", localFunc = "OpeningDemoSKipFadeEnd" },
			-- ヘリ回収した内通者から情報を聞きだした無線タイマー
			{ data = "Timer_ListeningInfoFromBetrayer", message = "OnEnd", localFunc = "ListeningInfoFromBetrayerEnd" },
		},
		RadioCondition = {
			-- CQC可能距離になった
			{ message = "EnableCQC", localFunc = "EnableCQC_Betrayer" },
		},
	},

	-- MB端末でヒント写真を見た
	OnMbDvcActWatchPhoto = function()
		Fox.Log("********** MbDvcActWatchPhoto **********")

		local PhotoID = TppData.GetArgument(1)

		-- 調査員の写真でかつ「ミッション補足説明１の再生中」ではなく、カセットB未入手でヘリ回収した調査員から情報聞き出し中でもない
		if( PhotoID == 10 and TppMission.GetFlag( "OnPlay_MissionBriefingSub1" ) == false and
			TppMission.GetFlag( "isGetCassette_B" ) == false and
			TppMission.GetFlag( "listeningInfoFromBetrayer" ) == false ) then

			TppMission.SetFlag( "isPlayerCheckMbPhoto", true )

			TppTimer.Stop( "CheckTargetPhotoTimer" )	-- 端末写真確認促し無線再生チェックタイマーを停止
			-- ミッション補足説明２までを再生済みなら何も言わないように変更
			if ( TppMission.GetFlag( "isRadio_MissionBriefingSub2" ) == false ) then
				TppRadio.DelayPlay( "Radio_MarkingBetrayer4", "short", "begin", {	-- そいつがターゲットだ
					onEnd = function()
						-- ミッション補足説明１シリーズを最後まで聞いているかどうか
						if ( TppMission.GetFlag( "isRadio_MissionBriefingSub1_3" ) == false ) then
							-- ミッション補足説明１を全く聞いていない
							if ( TppMission.GetFlag( "isRadio_MissionBriefingSub1" ) == false ) then
								-- 補足説明：1,1-5をコール
								-- ミッション目的説明補足1,1-5：今回の依頼･･･その基地ではあらゆる国の法律が･･･"キューバの中のアメリカ"で、･･･
								local MissionBriefing1_15 = { "Radio_MissionBriefingSub1", "Radio_MissionBriefingSub1_5" }
								TppRadio.DelayPlayEnqueue( MissionBriefing1_15, "short", "end", {
									onEnd = function()
										TppMission.SetFlag( "isRadio_MissionBriefingSub1", true )
										TppMission.SetFlag( "isRadio_MissionBriefingSub1_3", true )
									end
								} )
							-- ミッション補足説明１のうち「奇妙な話だが・・・」以降を聞いていない
							else
								-- 補足説明：1-5をコール
								-- ミッション目的説明補足1-5：その基地ではあらゆる国の法律が･･･"キューバの中のアメリカ"で、･･･
								TppRadio.DelayPlayEnqueue( "Radio_MissionBriefingSub1_5", "short", "end", {
									onEnd = function()
										TppMission.SetFlag( "isRadio_MissionBriefingSub1_3", true )
									end
								} )
							end
						-- 再度写真を見た際にミッション補足説明２を聞いていなければ再生
						elseif ( TppMission.GetFlag( "isRadio_MissionBriefingSub2" ) == false ) then
							TppRadio.DelayPlayEnqueue( "Radio_MissionBriefingSub2", "short", "end", {	-- ミッション目的説明補足2（長尺）：軍が自分たちで情報を･･･
								onEnd = function() TppMission.SetFlag( "isRadio_MissionBriefingSub2", true ) end
							} )
						else
							-- 補足説明無線は全て再生済みなので無線終了SEだけコール
							TppSoundDaemon.PostEvent( "Play_sfx_s_codec_NPC_end" )
						end
					end
				} )
			end
		end
	end,

	-- 取り巻き兵が無力化された
	OnDisablementAssistant = function( manager, messageId, arg0, arg1, arg2, arg3 )

		-- 既に内通者を特定済みでかつ内通者と一緒に行動していてかつsneakであれば無線コール
		if ( TppMission.GetFlag( "isBetrayerMarking" ) and
			 TppMission.GetFlag( "isBetrayerTogether" ) and
			 ( TppEnemy.GetPhase("gntn_cp") == "sneak" )) then
			-- 内通者が一人になったな無線コール
			local radioGroup = {"Radio_DisablementAssistant", "Radio_MarkingBetrayer2" }
			TppRadio.Play( "Radio_DisablementAssistant" )
		end
	end,

	-- 開始デモスキップ時のフェード明け
	OpeningDemoSKipFadeEnd = function()
		--TppUI.FadeIn(1.0)

		-- デモスキップ時は開始時無線の冒頭だけちょっと違う
		TppRadio.DelayPlay( "Radio_MissionBriefing2", "short", "begin", {
			onEnd = function() CallMissionBriefingOnTruck() end		-- トラック上のゲーム開始時のミッション説明無線郡へ繋げる
		} )

	end,

	-- ヘリ回収した内通者から情報を聞き出し終わった
	ListeningInfoFromBetrayerEnd = function()

		TppRadio.DelayPlay( "Radio_GetInfo_FromBetrayerOnHeli", "short", "both", {
						onEnd = function()
							-- カセット捜索シーケンスへ
							TppSequence.ChangeSequence( "Seq_Waiting_GetCassette" )
						end
					} )
	end,

	-- CQC可能距離になった
	EnableCQC_Betrayer = function()
		-- Fox.Log("********** EnableCQC_Betrayer **********")

		local CharaID = TppData.GetArgument(1)

		-- 対象が内通者でかつ既に特定済みか
		if ( CharaID == this.BetrayerID and TppMission.GetFlag( "isBetrayerMarking" ) == true ) then

			-- 内通者の周囲に居るアクティブな敵兵数を取得
			local enemyNum = TppEnemyUtility.GetNumberOfActiveSoldierByCharacterId( this.BetrayerID, this.Size_ActiveEnemy )

			if ( TppEnemy.GetPhase("gntn_cp") == "alert" ) then

				TppRadio.Play( "Radio_ContactNot_Phase")		-- 戦闘中なので接触出来ない無線
			else
				-- 接触可能なフェイズだけど付近に敵が居たら警告無線
				if ( enemyNum ~= 0 ) then
					TppRadio.Play( "Radio_ContactNot_NearEnemy1")
				end
			end


		end
	end,

	OnEnter = function( manager )

		this.commonPlayerEnterMissionArea()	-- ミッション圏内侵入済み

		TppMissionManager.SaveGame("40")	-- 今はID指定のみ対応

		EspionageRadioController.SetEnable{ enable = true }
		-- 諜報セットアップ
		this.SetIntelRadio()

		-- サーチターゲット設定
		commonSearchTargetSetup( manager )


		-- 開始デモがスキップされていたらフェードインタイマー開始
		if ( TppMission.GetFlag( "isOpeningDemoSkip" ) == true and this.CounterList.PlayerOnCargo ~= "NoRide" ) then
			TppTimer.Start( "OpeningDemoSkipFadeInTimer", 3 )

		else
			-- トラック荷台に乗っていればミッション開始時ということ
			if ( this.CounterList.PlayerOnCargo ~= "NoRide" ) then
				-- トラック上のゲーム開始時のミッション説明無線郡
				CallMissionBriefingOnTruck()
			-- 合図未実行でかつクリア条件未達成（コンティニュー時用）
			elseif ( TppMission.GetFlag("isSignalExecuted") == false and
					 TppMission.GetFlag("isGetCassette_B") == false ) then

				-- 合図やぐらが残存しているか
				if ( TppMission.GetFlag("isSignalTurretDestruction") == false ) then
					Fox.Log("****Continue**isSignalExecuted:FALSE**")

					-- 合図用サーチライトへの諜報無線を有効化
					TppRadio.EnableIntelRadio( "SL_WoodTurret04")
					-- コンティニュー時の簡略ミッション説明
					TppRadio.DelayPlay( "Radio_MissionBriefing2", "mid", "begin", {
						onEnd = function()
							TppRadio.DelayPlay( "Radio_AboutSignal", "short", "end", {
								onEnd = function()
									if ( TppMission.GetFlag("isSignalTurretDestruction") == false ) then
										-- 内通者への合図ポイントのマーカーをオン
										TppMarker.Enable( "e20030_marker_Signal", 0, "moving", "map_only_icon", 0, true, true )
										this.commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )		-- Map更新アナウンスログ表示
									end
								end
							} )
						end
					} )
				else
					-- 内通者への合図ポイントのマーカーをオフ
					TppMarker.Disable( "e20030_marker_Signal" )
					-- 合図用サーチライトへの諜報無線を無効化
					TppRadio.DisableIntelRadio( "SL_WoodTurret04")
					-- コンティニュー時の簡略ミッション説明
					TppRadio.DelayPlay( "Radio_MissionBriefing2", "mid", "both" )
				end

				TppTimer.Stop( "CheckTargetPhotoTimer" )
				-- 端末写真確認促し無線タイマー開始
				TppTimer.Start( "CheckTargetPhotoTimer", GZCommon.Time_HintPhotoCheck )
			-- 合図確認イベント終了済みでクリア条件未達成（コンティニュー時用）
			elseif ( TppMission.GetFlag("isSignalCheckEventEnd") == true and
					 TppMission.GetFlag("isGetCassette_B") == false ) then
				-- コンティニュー時の簡略ミッション説明
				TppRadio.DelayPlay( "Radio_MissionBriefing2", "mid", "both" )
			end
		end
	end,
}

---------------------------------------------------------------------------------
-- ■ Seq_BetrayerContactDemo
-- 内通者接触デモ
this.Seq_BetrayerContactDemo = {

	Messages = {
		Character = {
		--	{ data = "Player", message = "TransitionActionEnd", localFunc = "CameraDemoPlay" },
		},
		Timer = {
			{ data = "InterpCameraToDemoTimer", message = "OnEnd", localFunc = "CameraDemoPlay" },
		},
	},

	-- カメラ付きデモ再生
	CameraDemoPlay = function()
		-- デモ明けに内通者を「気絶」状態にしておく
		TppEnemyUtility.ChangeStatus( this.BetrayerID, "Faint" )
		-- 気絶回復停止
		TppEnemyUtility.SetLifeFlagByCharacterId( this.BetrayerID, "NoRecoverFaint" )

		TppDemo.Play( "Demo_BetrayerContactCam",
					{
						onStart = function()
							TppEnemyUtility.ChangeStatus( this.BetrayerID, "EndCqc" )	-- 保険処理：デモ乗っ取りのために敵兵のCQCステータスを強制で解除
						end,
						onEnd = function()
							TppPadOperatorUtility.ResetMasksForPlayer( 0, "Hospital_Wait" )			-- 左スティック操作を戻す
							TppSequence.ChangeSequence( "Seq_Waiting_GetCassette" )
						end },
					{ disableGame = false } )	--共通ゲーム無効を、キャンセル
	end,

	OnEnter = function()

		-- デモ中でも例外的にリアライズ指定するChara
		MissionManager.RegisterNotInGameRealizeCharacter( "e20030_Betrayer" )

		TppMarker.Disable( this.BetrayerID )			-- 内通者のマーカーはオフ

		-- 内通者接触済みフラグ
		TppMission.SetFlag( "isBetrayerContact", true )
		this.commonBetrayerInterrogationSetUpdate()	-- 内通者尋問セリフセット更新

		-- プレイヤーを「立ち状態＆ＣＱＣ維持」にする
		TppPlayerUtility.RequestStandAndKeepCqc()

		-- ミッション圏外警告エリア内だったらエフェクトと音声をオフ
		if ( TppMission.GetFlag( "isWarningMissionArea" ) == true ) then
				-- ミッション圏外エフェクトの停止
				TppOutOfMissionRangeEffect.Disable( 1 )
				GZCommon.OutsideAreaVoiceEnd()
		end

		-- Playerの周囲をチェックしてスペースが確保されていればカメラつきデモ再生
		if (TppPlayerUtility.IsThereEnoughSpaceAroundPlayer(-2.5,2.5,-2.5,1.5) == false) then
			-- デモ明けに内通者を「気絶」状態にしておく
			TppEnemyUtility.ChangeStatus( this.BetrayerID, "Faint" )
			-- 気絶回復停止
			TppEnemyUtility.SetLifeFlagByCharacterId( this.BetrayerID, "NoRecoverFaint" )

			TppDemo.Play( "Demo_BetrayerContact",
						{
							onStart = function()
								-- 保険処理：デモ乗っ取りのために敵兵のCQCステータスを強制で解除
								TppEnemyUtility.ChangeStatus( this.BetrayerID, "EndCqc" )

							end,
							onEnd = function()

								TppSequence.ChangeSequence( "Seq_Waiting_GetCassette" )
							end
						},
						{
							disableGame = false,			--共通ゲーム無効を、キャンセル
							disablePlayerPad = false,		-- パッド無効をキャンセル
						 } )
		else
			-- 拘束し続けていて条件成立したのであれば無線
			if ( this.CounterList.BetrayerRestraint ~= 0 ) then
			--	TppRadio.Play( "Radio_Contact_JustNow")	-- 「よし今だ」
			end
			TppDemoUtility.Setup("p12_020010_000")
			TppPlayerUtility.RequestToInterpCameraToDemo( "p12_020010_000",0.15,1.8)	-- ケツカメとデモカメラ間を補間

			TppPadOperatorUtility.SetMasksForPlayer( 0, "Hospital_Wait" )			-- 左スティック操作を無効に

			TppTimer.Start( "InterpCameraToDemoTimer", 1.8 )

		end

		-- 接触可否チェックタイマーを停止
		TppTimer.Stop( "BetrayerContactCheckTimer" )

		-- 端末写真確認促し無線タイマーを停止
		TppTimer.Stop( "CheckTargetPhotoTimer" )
	end,

	OnLeave = function()

		TppUI.FadeIn( 1 )		-- 暫定対処 デモスキップ時用にフェード解除

		-- ミッション圏外警告エリア内だったらエフェクトと音声をオン
		if ( TppMission.GetFlag( "isWarningMissionArea" ) == true ) then
				-- ミッション圏外エフェクトの停止
				TppOutOfMissionRangeEffect.Enable( 1 )
				GZCommon.OutsideAreaVoiceStart()
		end

		-- アナウンスログ表示
		this.commonCallAnnounceLog( this.AnnounceLogID_Contact )

		-- 気絶回復再開
		TppEnemyUtility.UnsetLifeFlagByCharacterId( this.BetrayerID, "NoRecoverFaint" )

		-- 内通者への諜報無線は無効化
		TppRadio.DisableIntelRadio( "e20030_Betrayer")

		-- 通報されたら困るので内通者はダメージを受けたことを忘れさせる
		TppEnemyUtility.ForgetDamageFacts( this.BetrayerID )

	end,
}

---------------------------------------------------------------------------------
-- ■ Seq_Waiting_GetCassette
-- カセット捜索
this.Seq_Waiting_GetCassette = {

	--CheckLookingTargetの使用を宣言
	checkingsOnThisSequence = {
		"CheckLookingTarget"
	},

	Messages = {
	},

	OnEnter = function( manager )

		-- ここでSneakRouteSetを切り替える（管制塔を手薄に＆内通者と反乱兵の会話イベント設定）
		this.commonSwitchSneakRouteSet()

		-- 保険処理としてここで取り巻き兵の優先Realiza指定を解除発行
		TppCommandPostObject.GsSetRealizeFirstPriority( "gntn_cp", this.AssistantID, false )

		-- 内通者をヘリ回収していたかどうか
		if ( TppMission.GetFlag( "listeningInfoFromBetrayer" ) == true ) then
			-- 情報聞き出し中フラグは下げる
			TppMission.SetFlag( "listeningInfoFromBetrayer", false )

			TppMarker.Disable( this.BetrayerID )			-- 内通者のマーカーはオフ

			-- 内通者接触済みフラグは立てておく
			TppMission.SetFlag( "isBetrayerContact", true )

			-- 次の目的地無線は既にコール済みなのでMAP更新アナウンスログを出す
			this.commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )

		else
			-- 調査員に接触済み（デモを見た）なので、マーカーを付けてしまう
			TppMarker.Enable( this.BetrayerID, 0, "moving", "map_only_icon", 0, true )

			----- 端末上のアイコンにカーソルがあったら出る説明分文を更新する -----
			local commonDataManager = UiCommonDataManager.GetInstance()
			if commonDataManager == NULL then
				return
			end

			local luaData = commonDataManager:GetUiLuaExportCommonData()
			if luaData == NULL then
				return
			end

			luaData:RegisterIconUniqueInformation( { markerId= this.BetrayerID, langId="marker_info_agent" })

			TppMission.SetFlag( "isBetrayerMarking", true )

			-- コンティニュー時用にカセットBの有無で分岐
			if ( TppMission.GetFlag("isGetCassette_B") == false ) then
				-- 次の目的説明無線。再生終了後にMap更新アナウンスログ
				TppRadio.DelayPlay( "Radio_BetrayerContact","mid", { onEnd = function() this.commonCallAnnounceLog( this.AnnounceLogID_MapUpdate ) end } )
			else
				-- クリア条件を満たしているなら脱出を促す無線
				TppRadio.DelayPlay( "Radio_RecommendEscape", "mid" )	-- 脱出しろ
			end

		end

		-- ミッション写真を「完了」化
		this.commonSetCompleteMissionPhoto()

		TppMarker.Disable( "e20030_marker_Signal" )	-- 合図ポイントのマーカーはオフ
		TppMarker.Enable( "e20030_marker_Cassette", 0, "moving", "all", 0, true, true )	-- カセットAのマーカーをオン
		TppMarkerSystem.EnableMarker{ markerId = "e20030_marker_Cassette", viewType = { "VIEW_MAP_ICON", "VIEW_WORLD_GOAL" } }

		----- 端末上のアイコンにカーソルがあったら出る説明分文を更新する -----
		local commonDataManager = UiCommonDataManager.GetInstance()
		if commonDataManager == NULL then
			return
		end

		local luaData = commonDataManager:GetUiLuaExportCommonData()
		if luaData == NULL then
			return
		end

		luaData:RegisterIconUniqueInformation( { markerId= "e20030_marker_Cassette", langId="marker_info_item_tape" })

		-- カセットAへの諜報無線を無効化、バッティングする管理棟への諜報無線はオフ
		-- TppRadio.EnableIntelRadio( "intel_e0030_rtrg0065")
		TppRadio.RegisterIntelRadio( "intel_e0030_rtrg0065", "e0030_esrg0065", true )	-- 「そこにカセットがある」
		TppRadio.DisableIntelRadio( "intel_f0090_esrg0140")

		-- 諜報セットアップ
		this.SetIntelRadio()

		-- 任意無線の更新
		this.commonOptionalRadioUpdate()

		-- 敵兵の諜報無線の更新
		this.commonUpdateCheckEnemyIntelRadio()

		-- 監視カメラの諜報無線を更新
		this.commonUpdateCheckCameraIntelRadio()

		-- ここでのSequenceSaveは場所が不定なので現在地を見て切り替える
		this.commonSequenceSaveIndefinite()

		-- 内通者の尋問カウンターを初期化
		this.commonBetrayerInterrogationRegister()

		-- ミッション説明文更新
		this.commonUpdateMissionDescription()

		-- コンティニュー時用にフラグチェック
		if ( TppMission.GetFlag("isGetCassette_B") == false ) then
			-- ミッション中間目標更新
			commonMissionSubGoalSetting( this.MissionSubGoal_Cassette )
		end

		-- アナウンスログ表示
		this.commonCallAnnounceLog( this.AnnounceLogID_InfoUpdate )

		-- サーチターゲット設定
		commonSearchTargetSetup( manager )

	end,

	OnLeave = function()
		TppMarker.Disable( "e20030_marker_Cassette" )
	end,
}

---------------------------------------------------------------------------------
-- ■ Seq_Escape_CameraActive
-- 脱出シーケンス（監視カメラが残存している）
this.Seq_Escape_CameraActive = {

	--CheckLookingTargetの使用を宣言
	checkingsOnThisSequence = {
		"CheckLookingTarget"
	},

	Messages = {
		Trap = {
			-- 検問についての説明無線トラップ
		--	{ data = "Trap_InspectionInfo", message = { "Enter" }, localFunc = "FuncInspection_CameraActive" },
		},
	},

	OnEnter = function( manager )
		this.commonOptionalRadioUpdate()

		-- Cautionルートを変えておく
		-- this.commonStartForceSerching()

		-- 内通者の尋問カウンターを初期化
		this.commonBetrayerInterrogationRegister()

		-- ミッション中間目標更新
		commonMissionSubGoalSetting( this.MissionSubGoal_Escape )

		-- アナウンスログ表示
		this.commonCallAnnounceLog( this.AnnounceLogID_InfoUpdate )

		TppMissionManager.SaveGame("30")	-- 今はID指定のみ対応

		-- 諜報セットアップ
		this.SetIntelRadio()

		-- サーチターゲット設定
		commonSearchTargetSetup( manager )
	end,

	FuncInspection_CameraActive = function()

		local InspectionFunc = {
			onStart = function()
				-- アナウンスログ「検問を設置」
				this.commonCallAnnounceLog( this.AnnounceLogID_Inspection )
			end,
			onEnd = function()
				-- アナウンスログ「Map情報更新」
				this.commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )

				TppMarker.Enable( "TppMarkerLocator_EscapeWest", 0, "moving", "all", 0, false, true )	-- 基地からの脱出ポイントをマーカー表示
				TppMarker.Enable( "TppMarkerLocator_EscapeNorth", 0, "moving", "all", 0, false, true )	-- 基地からの脱出ポイントをマーカー表示

				-- 検問が設置されたフラグ
				TppMission.SetFlag( "isInspectionActive", true )

				-- 任意無線を更新
				this.commonOptionalRadioUpdate()
			end,
		}

		-- 検問について無線
		TppRadio.DelayPlay( "Radio_Inspection", "mid", "both", InspectionFunc )

	end,

}

---------------------------------------------------------------------------------
-- ■ Seq_Escape_CameraBroken
-- 脱出シーケンス（監視カメラが破壊されている）
this.Seq_Escape_CameraBroken = {

	--CheckLookingTargetの使用を宣言
	checkingsOnThisSequence = {
		"CheckLookingTarget"
	},

	Messages = {
		Trap = {
			-- 検問についての説明無線トラップ
		--	{ data = "Trap_InspectionInfo", message = { "Enter" }, localFunc = "FuncInspection_CameraBroken" },
		},
	},

	OnEnter = function( manager )
		this.commonOptionalRadioUpdate()

		-- 監視カメラ破壊状態でこのシーケンスにきたなら特に無線はなし

		-- Cautionにして捜索部隊を放つ
		-- commonStartForceSerching()

		-- 内通者の尋問カウンターを初期化
		this.commonBetrayerInterrogationRegister()

		-- ミッション中間目標更新
		commonMissionSubGoalSetting( this.MissionSubGoal_Escape )

		-- アナウンスログ表示
		this.commonCallAnnounceLog( this.AnnounceLogID_InfoUpdate )

		TppMissionManager.SaveGame("30")	-- 今はID指定のみ対応

		-- 諜報セットアップ
		this.SetIntelRadio()

		-- サーチターゲット設定
		commonSearchTargetSetup( manager )
	end,

	FuncInspection_CameraBroken = function()

		local EscapeFunc = {
			onEnd = function()
				-- アナウンスログ「Map情報更新」
				this.commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )

				TppMarker.Enable( "TppMarkerLocator_EscapeWest", 0, "moving", "all", 0, false, true )	-- 基地からの脱出ポイントをマーカー表示
				TppMarker.Enable( "TppMarkerLocator_EscapeNorth", 0, "moving", "all", 0, false, true )	-- 基地からの脱出ポイントをマーカー表示
			end,
		}

		-- 脱出方法について無線
		TppRadio.DelayPlay( "Radio_EscapeWay", "mid", "both", EscapeFunc )

	end,

}
--------------------------------------------------------------------------------
-- ■ Seq_PlayerRideHelicopter
-- ヘリに乗って脱出中
this.Seq_PlayerRideHelicopter = {

-- 	MissionState = "clear",

	Messages = {
		Character = {
			{ data = "SupportHelicopter",		message = "CloseDoor",		localFunc = "FuncCloseDoor" },	-- ドアが閉まった
		},
	},

	OnEnter = function()
		-- this.commonMissionClearRadio()

	end,

	FuncCloseDoor = function()

		-- この時点でクリア条件を再判定
		if ( TppMission.GetFlag("isGetCassette_A") == true or TppMission.GetFlag("isGetCassette_B") == true ) then


			this.commonMissionClearRequest( "RideHeli_Clear" )

		else

			TppMission.ChangeState( "failed", "RideHeli_Failed" )
		end
	end,

}
--------------------------------------------------------------------------------
-- ■ Seq_PlayerEscapeMissionArea
-- ミッション圏外に脱出
this.Seq_PlayerEscapeMissionArea = {

	MissionState = "clear",

	Messages = {
		Timer = {
			{ data = "MissionClearProductionTimer",	message = "OnEnd", 	localFunc="OnFinishMissionClearProduction" },
		},
	},

	-- ミッションクリア演出ウェイト明け
	OnFinishMissionClearProduction = function()
		Fox.Log("----------------Seq_MissionFailed:OnFinishMissionFailedProduction----------------")

		TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" )	-- デモないのでそのままクリア字幕へ
	end,

	OnEnter = function()

		-- this.commonMissionClearRadio()

		-- トラック荷台に乗ってクリアだったら実績解除
		if ( this.CounterList.PlayerOnCargo ~= "NoRide" ) then
			Trophy.TrophyUnlock( this.TrophyId_e20030_CargoClear )
		end

		-- クリア演出はFailedもClearも共通で呼んでしまっているのでここではウェイトだけ
		-- ミッションクリア演出中のウェイトを行う
		TppTimer.Start( "MissionClearProductionTimer", GZCommon.FadeOutTime_MissionClear )

	end,

}
--------------------------------------------------------------------------------
-- ■ Seq_MissionClearDemo	-- 使わない
-- ミッションクリアデモ
this.Seq_MissionClearDemo = {

	MissionState = "clear",

	OnEnter = function()
		-- TppDemo.Play( "Demo_MissionClear", { onEnd = function() TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" ) end } )
	end,
}

--------------------------------------------------------------------------------
-- ■ Seq_MissionClearShowTransition
-- ミッション終了テロップ
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
		-- TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default" )

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

		-- 強字幕設定にする
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )

		-- ミッションクリア無線をコール
		this.commonMissionClearRadio()

	end,

	OnEnter = function()

		local TelopEnd = {
			onEnd = function()
				TppSequence.ChangeSequence( "Seq_MissionClear" )
			end,
		}

		TppUI.ShowTransitionWithFadeOut( "ending", TelopEnd, 2 )

		-- 汎用無線登録解除
		TppRadioConditionManagerAccessor.Unregister( "Tutorial" )
		TppRadioConditionManagerAccessor.Unregister( "Basic" )
	end,

}

---------------------------------------------------------------------------------
-- ■ Seq_MissionClear
-- クリア画面後の演出：黒電話
this.Seq_MissionClear = {

	MissionState = "clear",

	OnEnter = function()

		-- 強字幕設定にする
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )

		-- カセットBを取得しているかによって呼び分け
		if ( TppMission.GetFlag("isGetCassette_B") == false ) then

			-- クリア後黒電話A
			TppRadio.Play( "Radio_BlackCall_Cassette_A", {
				onStart = function() TppMusicManager.PostJingleEvent( 'SingleShot', 'Set_Switch_bgm_gntn_ed_default_lp' ) end,
				onEnd = function()
					TppSequence.ChangeSequence( "Seq_ShowClearReward" )	-- 報酬表示シーケンスへ
				end
			}, nil, nil, "none" )
		else
			-- クリア後黒電話B
			TppRadio.Play( "Radio_BlackCall_Cassette_B", {
				onStart = function() TppMusicManager.PostJingleEvent( 'SingleShot', 'Set_Switch_bgm_gntn_ed_default_lp' ) end,
				onEnd = function()
					TppSequence.ChangeSequence( "Seq_ShowClearReward" )	-- 報酬表示シーケンスへ
				end
			}, nil, nil, "none" )

		end
	end,

	OnUpdate = function()
		-- スキップ処理
		local hudCommonData = HudCommonDataManager.GetInstance()
		if hudCommonData:IsPushRadioSkipButton() == true then
			-- スキップボタンが押されたら即座に黒電話停止、次シーケンスへ
			-- 再生中の無線停止
			local radioDaemon = RadioDaemon:GetInstance()
			radioDaemon:StopDirect()
			TppSequence.ChangeSequence( "Seq_ShowClearReward" )
		end
	end,
}
---------------------------------------------------------------------------------
-- ■ Seq_MissionAbort ※GZでは使わない
this.Seq_MissionAbort = {

	OnEnter = function()
		--ミッションアボート
		TppMission.ChangeState( "abort" )
		-- ミッションアボート演出があればここに書く

		TppSequence.ChangeSequence( "Seq_MissionEnd" )
	end,
}
---------------------------------------------------------------------------------
-- ■ Seq_MissionFailed
this.Seq_MissionFailed = {

	-- ここに入ってきた時点で自動的にMissionMangaerがST_FAILEDで止めている
	MissionState = "failed",

	Messages = {
		Timer = {
			{ data = "MissionFailedProductionTimer",	message = "OnEnd", 	localFunc="OnFinishMissionFailedProduction" },
		},
	},

	-- ミッション失敗演出ウェイト明け
	OnFinishMissionFailedProduction = function()
		Fox.Log("----------------Seq_MissionFailed:OnFinishMissionFailedProduction----------------")

		TppSequence.ChangeSequence( "Seq_MissionGameOver" )
	end,


	OnEnter = function( manager )
		Fox.Log("----------------Seq_MissionFailed:OnEnter----------------")

		-- ミッション失敗演出中のウェイトを行う
		TppTimer.Start( "MissionFailedProductionTimer", this.CounterList.GameOverFadeTime )

	end,
}
---------------------------------------------------------------------------------
-- ■ Seq_MissionGameOver
this.Seq_MissionGameOver = {

	-- ここに入ってきた時点で自動的にMissionMangaerがST_GAMEOVERになり、UI側でゲームオーバー画面の制御が行われる
	MissionState = "gameOver",

	Messages = {
		UI = {
			-- ゲームオーバー画面遷移完了
			{ message = "GameOverOpen" ,	localFunc = "OnFinishGameOverFade" },
		},
	},

	-- ゲームオーバー画面遷移が完了したタイミングでゲームオーバー無線コール
	OnFinishGameOverFade = function()

		-- 強字幕設定にする
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )

		-- ミッション失敗内容に応じた無線をコール
		TppRadio.DelayPlay( this.CounterList.GameOverRadioName, nil, "none" )

	end,

	OnEnter = function()
		-- この後の処理はMissionManagerからのmessage（RestartやReturnToTitleなど）に引っ掛けて行うのでここには記述不要
	end,
}
---------------------------------------------------------------------------------
-- ■ Seq_ShowClearReward
-- ミッションクリア後の報酬表示シーケンス
this.Seq_ShowClearReward = {

	MissionState = "clear",

	Messages = {
		UI = {
			-- ポップアップの終了メッセージ
			--{ message = "PopupClose", commonFunc = function() this.OnClosePopupWindow() end },
			-- 全ての報酬ポップアップが閉じられたら次シーケンスへ
			{ message = "BonusPopupAllClose", commonFunc = function() TppSequence.ChangeSequence( "Seq_MissionEnd" ) end },
		},
	},

	OnEnter = function()
		Fox.Log("-------Seq_ShowClearReward--------")

		-- 報酬ポップアップの表示
		this.OnShowRewardPopupWindow()

	end,
}
---------------------------------------------------------------------------------
-- ■ Seq_MissionEnd
this.Seq_MissionEnd = {

	-- ここに入ってくるのはMissionClear時のみ。
	-- 入ってきた時点で自動的にMissionMangaerがST_CLEARの先に処理を運んでくれる
	OnEnter = function()

		-- ミッション後片付け
		this.commonMissionCleanUp()

		-- ジングルフェード終了
		TppMusicManager.PostJingleEvent( "SingleShot", "Stop_bgm_gntn_ed_default" )

		--全カセットテープの持ってない扱いをやめる
		local uiCommonData = UiCommonDataManager.GetInstance()
		uiCommonData:ShowAllCassetteTapes()

		TppMissionManager.SaveGame()	-- Btk14449対応：報酬獲得Sequenceで獲得した報酬をSaveする
		--ミッションを終了させる（アンロード）
		TppMission.ChangeState( "end" )
	end,
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■■■ MissionSkip Functions
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■ OnSkipEnterCommon
this.OnSkipEnterCommon = function( manager )
	Fox.Log("********************OnSkipEnterCommon********************")
	local sequence = TppSequence.GetCurrentSequence()

	-- do prepare
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionPrepare" ) ) then
		this.onMissionPrepare( manager )
	end

	-- Set all mission states
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionFailed" ) ) then
		TppMission.ChangeState( "failed" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionAbort" ) ) then
		TppMission.ChangeState( "abort" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionClear" ) ) then
		TppMission.ChangeState( "clear" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionPrepare" ) ) then
		-- デモブロックはここで読み込んでおく
		commonDemoBlockSetup()
	elseif( sequence == "Seq_MissionPrepare" ) then
		-- デモブロックはここで読み込んでおく
		commonDemoBlockSetup()
	end

	-- 内通者接触後シーケンスであれば復帰位置を固定
	if( sequence == "Seq_Waiting_GetCassette" ) then
--		TppMission.RegisterVipRestorePoint( this.BetrayerID, "BetrayerRestorePoint")
	end
end

-- ■ OnSkipUpdateCommon
this.OnSkipUpdateCommon = function( manager )
	-- Fox.Log("********************OnSkipUpdateCommon********************")
	return IsDemoAndEventBlockActive()	-- デモブロックの読み込み完了待ち
end

-- ■ OnSkipLeaveCommon
this.OnSkipLeaveCommon = function( manager )
	Fox.Log("********************OnSkipLeaveCommon********************")
	local sequence = TppSequence.GetCurrentSequence()

	-- 全ゲームシーケンス共通のセットアップ
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionLoad" ) ) then

		onCommonMissionSetup()

		-- 任意無線設定
		this.commonOptionalRadioUpdate()

		-- 諜報無線を初期化
		this.commonRegisterIntelRadio()

		--汎用無線用コンポーネントの登録
		TppRadioConditionManagerAccessor.Register( "Tutorial", TppRadioConditionTutorialPlayer{ time = 1.5 } )
		TppRadioConditionManagerAccessor.Register( "Basic", TppRadioConditionPlayerBasic{ time = 0.3 } )

		-- ミッション写真有効化
		commonUiMissionPhotoSetup()

		-- 内通者の尋問台詞セットを初期化
		this.commonBetrayerInterrogationSetUpdate()

		-- 尋問カウンター初期化
		this.commonBetrayerInterrogationRegister()

		-- マーカー関連初期化
		commonMarkerMissionSetup()

		-- 装甲車出現済みで未破壊なら出現
		if ( TppMission.GetFlag("isWavActivate") == true and TppMission.GetFlag("isWavBroken") == false ) then
			this.commonCheckActivateWav()
		end

		-- 初期RouteSetのセットアップ(デバッグメニュー復帰用)
		commonRouteSetMissionSetup( "e20030_routeSet_d01_basic01" )

	end

	-- 内通者への諜報無線
	if ( TppMission.GetFlag("isBetrayerContact") == true ) then
		-- 内通者への諜報無線は無効化
		TppRadio.DisableIntelRadio( "e20030_Betrayer")
	elseif (  TppMission.GetFlag("isBetrayerMarking") == true ) then
		-- 内通者特定済みなら諜報無線を差し替え
		TppRadio.RegisterIntelRadio( this.BetrayerID, "e0030_esrg0020", true )	-- 内通者を諜報：奴が1人の時に接触しろ
	end
	-- 中央管制塔への諜報無線
	if ( TppMission.GetFlag("isBetrayerContact") == true and  TppMission.GetFlag("isGetCassette_A") == false ) then
		TppRadio.RegisterIntelRadio( "intel_e0030_rtrg0065", "e0030_esrg0065", true )	-- 「そこにカセットがある」
		TppRadio.DisableIntelRadio( "intel_f0090_esrg0140")
	else
		TppRadio.RegisterIntelRadio( "intel_e0030_rtrg0065", "f0090_esrg0140", true )	-- 「管理棟だ」
	end

	if (  TppMission.GetFlag("isBetrayerMarking") == true ) then
		----- 端末上のアイコンにカーソルがあったら出る説明分文を更新する -----
		local commonDataManager = UiCommonDataManager.GetInstance()
		if commonDataManager == NULL then
			return
		end

		local luaData = commonDataManager:GetUiLuaExportCommonData()
		if luaData == NULL then
			return
		end

		luaData:RegisterIconUniqueInformation( { markerId= this.BetrayerID, langId="marker_info_agent" })
	end

	-- 内通者の復帰位置はSave時点での所属エリアに応じて分岐。ここで定義しておく必要がある
	if ( TppMission.GetFlag( "BetrayerArea" ) == this.Area_WareHouse ) then
		-- 倉庫エリア
		TppMission.RegisterVipRestorePoint( this.BetrayerID, "BetrayerRestorePoint_WareHouse" )

	elseif ( TppMission.GetFlag( "BetrayerArea" ) == this.Area_campEast ) then
		-- 東側キャンプ
		TppMission.RegisterVipRestorePoint( this.BetrayerID, "BetrayerRestorePoint_campEast" )

	elseif ( TppMission.GetFlag( "BetrayerArea" ) == this.Area_Heliport ) then
		-- ヘリポート
		TppMission.RegisterVipRestorePoint( this.BetrayerID, "BetrayerRestorePoint_HeliPort" )

	elseif ( TppMission.GetFlag( "BetrayerArea" ) == this.Area_campWest ) then
		-- 西難民キャンプ（合図チェックルート）
		TppMission.RegisterVipRestorePoint( this.BetrayerID, "BetrayerRestorePoint_campWest" )

	else
		-- 保険
		TppMission.RegisterVipRestorePoint( this.BetrayerID, "BetrayerRestorePoint_WareHouse" )

	end

	-- ミッション開始デモに登場するトラックは安全のため復帰位置固定
	TppMission.RegisterVipRestorePoint( "Cargo_Truck_WEST_001", "TruckRestorePoint" )

	-- ミッションフラグ、シーケンス別の無線やイベント復帰
	if ( sequence == "Seq_Waiting_BetrayerContact" ) then
		-- 内通者への合図実行済みで未完了、合図やぐらが残存しているか
		if ( TppMission.GetFlag("isGetCassette_B") == true ) then
			-- 既にクリア条件を満たしている
			-- クリア条件を満たしていれば圏外エフェクトは無効化
			GZCommon.isOutOfMissionEffectEnable = false
--[[
			-- 検問出現済みか
			if ( TppMission.GetFlag("isInspectionActive") == true ) then
				-- 検問用オブジェクトの設置
				this.commonInspectionObjectON()
				-- ドライバー兵に割り当てられているルートを切り替え（西検問前の哨戒）
				TppEnemy.ChangeRoute( "gntn_cp", "e20030_Driver", 	RouteSetName, "gntn_common_d01_route0032", 0 )
				-- ドライバー兵に割り当てられているルートを切り替え（北検問前の哨戒）
				TppEnemy.ChangeRoute( "gntn_cp", "e20030_enemy022", 	RouteSetName, "gntn_common_d01_route0033", 0 )
			end
--]]
			TppRadio.DelayPlay( "Radio_RecommendEscape", "mid" )	-- 脱出しろ

		elseif ( TppMission.GetFlag("isSignalExecuted") == true and
			 TppMission.GetFlag("isSignalCheckEventEnd") == false and
			 TppMission.GetFlag("isSignalTurretDestruction") == false and
			 TppMission.GetFlag("isGetCassette_B") == false ) then

			Fox.Log("****OnSkipLeaveCommon**Seq_Waiting_BetrayerContact**isSignalExecuted:TRUE**")

			-- プレイヤーが西難民キャンプに居るなら合図について無線
			if ( TppMission.GetFlag( "isPlayerInWestCamp" ) == true ) then
				TppRadio.DelayPlay( "Radio_RunSignal", "mid" )
			else
				TppRadio.DelayPlay( "Radio_MissionBriefing2", "mid" )
			end
			-- 合図チェック用ルート付近の復帰位置を指定
			TppMission.RegisterVipRestorePoint( this.BetrayerID, "BetrayerRestorePoint_SignalCheck" )
			TppMission.RegisterVipRestorePoint( this.AssistantID, "BetrayerRestorePoint_SignalCheck" )	-- 合図チェックの場合のみ取り巻きもココから復帰

		-- 合図未実行かつやぐらが残存
		elseif ( TppMission.GetFlag("isSignalExecuted") == false and
				 TppMission.GetFlag("isSignalTurretDestruction") == false and
				 TppMission.GetFlag("isGetCassette_B") == false ) then
			Fox.Log("****OnSkipLeaveCommon**Seq_Waiting_BetrayerContact**isSignalExecuted:FALSE**")

			-- 内通者への合図ポイントのマーカーをオン
			-- TppMarker.Enable( "e20030_marker_Signal", 0, "moving", "map_only_icon", 0, true, true )
			-- 合図用サーチライトへの諜報無線を有効化
			TppRadio.EnableIntelRadio( "SL_WoodTurret04")
		end

		-- ミッション中間目標更新
		commonMissionSubGoalSetting( this.MissionSubGoal_Betrayer )

	elseif ( sequence == "Seq_Waiting_GetCassette" ) then

		-- ミッション説明を変更する
		local commonDataManager = UiCommonDataManager.GetInstance()
		if commonDataManager ~= NULL then
			local luaData = commonDataManager:GetUiLuaExportCommonData()
			if luaData ~= NULL then
				-- ストーリー番号を変更
				luaData:SetMisionInfoCurrentStoryNo(1)									-- ストーリー番号を0から1に
			end
		end

		-- ミッション中間目標更新
		commonMissionSubGoalSetting( this.MissionSubGoal_Cassette )

	end

	-- 既にクリア条件を満たしていたら
	if ( TppMission.GetFlag("isGetCassette_A") == true or
		 TppMission.GetFlag("isGetCassette_B") == true ) then

		-- ミッション中間目標更新
		commonMissionSubGoalSetting( this.MissionSubGoal_Escape )

		-- クリア条件を満たしていれば圏外エフェクトは無効化
		GZCommon.isOutOfMissionEffectEnable = false

		-- 検問出現済みか
		if ( TppMission.GetFlag("isInspectionActive") == true ) then
			-- 検問用オブジェクトの設置
			this.commonInspectionObjectON()
			-- 検問車両をＯＮ
			TppData.Enable( "Cargo_Truck_WEST_003" )
		end

	end

	-- 既にカセットBをドロップ済みなら反乱兵の尋問台詞を更新しておく
	if ( TppMission.GetFlag("isDropCassette_B") == true ) then
		-- 尋問カウンターをセット（台詞Bにする）
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( this.MastermindID, 1 )
	end

end

-- ■ OnAfterRestore
-- SaveデータからのRestore処理のさらに後で走る処理。PGでのSave復帰処理を上書いて例外的に再設定したいものをここに記述する。
-- OnSkipシリーズと異なり、こちらはデバッグメニュー開始の際は通らない
this.OnAfterRestore = function()
	Fox.Log("********************OnAfterRestore********************")

	-- ユニークキャラの復帰処理。復帰ポイントは仕込み済み。ミッション中の各状況に対して復帰位置と乗るべきルートの指定
	-- 全体のRouteSetのセットアップとユニークキャラのセットアップは分離する
	-- Save時のシーケンス、フラグ状態に合わせたルートセットの再設定

	local sequence = TppSequence.GetCurrentSequence()
	local RouteSetName

	-- 全体のRouteSetの決定
	if( TppSequence.IsGreaterThan( sequence, "Seq_Waiting_BetrayerContact" ) ) then

		RouteSetName = "e20030_routeSet_d01_basic02"
	else

		RouteSetName = "e20030_routeSet_d01_basic01"
	end

	-- 捕虜の復帰位置チェック
	GZCommon.CheckContinueHostageRegister( this.ContinueHostageRegisterList )

	-- 初期RouteSetのセットアップ
	commonRouteSetMissionSetup( RouteSetName )

	-- 捕虜諜報無線セットアップ
	this.commonHostageIntelCheck("Hostage_e20030_000")
	this.commonHostageIntelCheck("Hostage_e20030_001")
	this.commonHostageIntelCheck("Hostage_e20030_002")

	-- ユニークキャラのセットアップ
	-- 内通者は優先Realize指定
	TppCommandPostObject.GsSetRealizeFirstPriority( "gntn_cp", this.BetrayerID, true )

	-- 取り巻き兵はSequence問わず専用ルートを指定
	this.ChangeAssistantRoute( RouteSetName, "gntn_e20030_ast_route0000", 58 )

	-- 保存した諜報無線の内容をロードする
	TppRadio.RestoreIntelRadio()

	-- 内通者はSave時点での所属エリアに応じて巡回ルートを決定
	if ( TppMission.GetFlag( "BetrayerArea" ) == this.Area_WareHouse ) then
		-- 全体ワープで上書きされてしまうので復帰位置をここで再指定
		TppCharacterUtility.WarpCharacterIdFromIdentifier( this.BetrayerID, "id_vipRestorePoint", "BetrayerRestorePoint_WareHouse" )
		-- 倉庫エリア
		this.ChangeBetrayerRoute( RouteSetName, "gntn_e20030_tgt_route0000", 0 )

	elseif ( TppMission.GetFlag( "BetrayerArea" ) == this.Area_campEast ) then
		-- 全体ワープで上書きされてしまうので復帰位置をここで再指定
		TppCharacterUtility.WarpCharacterIdFromIdentifier( this.BetrayerID, "id_vipRestorePoint", "BetrayerRestorePoint_campEast" )
		-- 東側キャンプ
		this.ChangeBetrayerRoute( RouteSetName, "gntn_e20030_tgt_route0001", 5 )

	elseif ( TppMission.GetFlag( "BetrayerArea" ) == this.Area_Heliport ) then
		-- 全体ワープで上書きされてしまうので復帰位置をここで再指定
		TppCharacterUtility.WarpCharacterIdFromIdentifier( this.BetrayerID, "id_vipRestorePoint", "BetrayerRestorePoint_HeliPort" )
		-- ヘリポート
		this.ChangeBetrayerRoute( RouteSetName, "gntn_e20030_tgt_route0002", 8 )

	elseif ( TppMission.GetFlag( "BetrayerArea" ) == this.Area_campWest ) then
		Fox.Log("Warp__________Area_campWest")
		-- 全体ワープで上書きされてしまうので復帰位置をここで再指定
		TppCharacterUtility.WarpCharacterIdFromIdentifier( this.BetrayerID, "id_vipRestorePoint", "BetrayerRestorePoint_campWest" )

	else
		-- 保険
		TppCharacterUtility.WarpCharacterIdFromIdentifier( this.BetrayerID, "id_vipRestorePoint", "BetrayerRestorePoint_WareHouse" )
		this.ChangeBetrayerRoute( RouteSetName, "gntn_e20030_tgt_route0000", 0 )
	end


	-- 各イベント発生時用の復帰処理
	if( TppSequence.IsGreaterThan( sequence, "Seq_Waiting_BetrayerContact" ) ) then
		-- 会話イベントが発生していない
		if ( TppMission.GetFlag("isMastermindConversationEnd") == false ) then
			-- 内通者と反乱兵の会話用ルートのセットアップ
			this.commonSwitchMastermindConversation()
			if ( TppMission.GetFlag( "BetrayerArea" ) == this.Area_campWest ) then
				Fox.Log("Warp__________Area_campWest22222222")
				-- 全体ワープで上書きされてしまうので復帰位置をここで再指定
				TppCharacterUtility.WarpCharacterIdFromIdentifier( this.BetrayerID, "id_vipRestorePoint", "BetrayerRestorePoint_campWest" )
			end

		else
			-- 発生済みなら一応反乱兵のみルート指定しておく
			TppEnemy.EnableRoute( "gntn_cp", "gntn_e20030_mst_route0000" )
			TppEnemy.ChangeRoute( "gntn_cp", this.MastermindID,	RouteSetName, "gntn_e20030_mst_route0000", 0 )
		end

		-- 中央管制塔監視カメラがプレイヤー発見済みなら検問設置イベント
		if ( TppMission.GetFlag( "isCameraAlert" ) == true ) then
			-- Cautionルートを管制塔捜索用に変えておく
			this.commonStartForceSerching()
		end

	else
		-- 内通者接触前シーケンス
		if ( sequence == "Seq_Waiting_BetrayerContact" ) then
			-- 内通者への合図実行済みで未完了、合図やぐらが残存しているか
			if ( TppMission.GetFlag("isSignalExecuted") == true and
				 TppMission.GetFlag("isSignalCheckEventEnd") == false and
				 TppMission.GetFlag("isSignalTurretDestruction") == false ) then

					Fox.Log("****OnSkipLeaveCommon**Seq_Waiting_BetrayerContact**isSignalExecuted:TRUE**")
					-- 全体ワープで上書きされてしまうので復帰位置をここで再指定
					TppCharacterUtility.WarpCharacterIdFromIdentifier( this.BetrayerID, "id_vipRestorePoint", "BetrayerRestorePoint_SignalCheck" )
					TppCharacterUtility.WarpCharacterIdFromIdentifier( this.AssistantID, "id_vipRestorePoint", "BetrayerRestorePoint_SignalCheck" )
					-- 内通者と取り巻きをルートチェンジ
					this.ChangeSignalCheckRoute( "Continue" )
			end
		end
	end

	-- 既にクリア条件を満たしていたら
	if ( TppMission.GetFlag("isGetCassette_A") == true or
		 TppMission.GetFlag("isGetCassette_B") == true ) then

		-- 検問出現済みか
		if ( TppMission.GetFlag("isInspectionActive") == true ) then
			TppData.Disable( "Cargo_Truck_WEST_001" )	-- トラックを消す
			-- ドライバー兵に割り当てられているルートを切り替え（西検問前の哨戒）
			TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0027" )
			TppEnemy.EnableRoute( "gntn_cp", "gntn_common_d01_route0032" )
			TppEnemy.ChangeRoute( "gntn_cp", "e20030_Driver", 	RouteSetName, "gntn_common_d01_route0032", 0 )

			-- ドライバー兵に割り当てられているルートを切り替え（北検問前の哨戒）
			TppEnemy.DisableRoute( "gntn_cp", "gntn_common_d01_route0029" )
			TppEnemy.EnableRoute( "gntn_cp", "gntn_common_d01_route0033" )
			TppEnemy.ChangeRoute( "gntn_cp", "e20030_enemy022", 	RouteSetName, "gntn_common_d01_route0033", 0 )
		end
	end

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■■■ END
------------------------------------------------------------------------------------------------------------------------------------------------------------------
return this
