local this = {}
---------------------------------------------------------------------------------
-- Member Variables
this.missionID	= 20010
this.cpID		= "gntn_cp"
this.tmpBestRank = 0				-- ベストクリアランク比較用(5 = RankD)
this.tmpRewardNum = 0				-- 達成率（報酬獲得数）表示用

-- 調整パラメータ
----チコに会う
this.demoStaPlayer_chico = "Stand"--プレイヤーの位置補正　姿勢・向き
this.eneCheckSize_chico = Vector3(24,6,28) -- チコに会うデモ　敵兵を確認する判定のサイズ
this.hostageCheckSize = Vector3(2.6,4.8,4.7)--チコに会うデモ　捕虜を確認する判定のサイズ
this.hostageOtherCheckSize = Vector3(40.7, 4.8, 40.9)--チコに会うデモ　w他の捕虜を確認する判定のサイズ
----パスに会う
this.demoStaPlayer_paz = "Stand"---プレイヤーの位置補正　姿勢・向き
local eneCheckSize_paz = Vector3(27,7,26) -- パスに会うデモ　敵兵を確認する判定のサイズ
--デモチェック用サイズ
local eneCheckSize_seaside = Vector3(38.7,9.1, 26.8 ) --海岸での敵兵チェックサイズ
local eneCheckSize_bukiko = Vector3(5.9, 5.8, 8.4)--武器庫での敵兵チェックサイズ
-- 海辺のワープチェック　洞窟からどのくらい近いか
this.demoSeaSideDist = 18
this.demoSeaSideDist = 18
--デモ補正カメラの移動時間
this.demoCamRot = 0.15
this.demoCamSpeed = 1.8
--OpeningDemoSkip後暗転処理用
this.openingDemoSkipCount = 0
---------------------------------------------------------------------------------
-- EventSequenceManager
---------------------------------------------------------------------------------
this.RequiredFiles = {
	"/Assets/tpp/script/common/GZCommon.lua",
	"/Assets/tpp/level/mission/extra/e20010/e20010_require_01.lua",
}

this.Sequences = {
	--１番最初に呼ばれるシーケンス
	{ "Seq_MissionPrepare" },				-- 準備
	--システム
	{ "Seq_MissionSetup" },					--　セットアップ
	{ "Seq_OpeningDemoLoad" },				--　デモロード
	{ "Seq_MissionLoad" },					-- ミッションロード
	{ "Seq_Mission_Failed" },				-- ミッション失敗
	{ "Seq_HelicopterDeadNotOnPlayer" },	-- ヘリ墜落 ※ＰＣ乗っていない
	{ "Seq_MissionGameOver" },				--　ゲームオーバー
	{ "Seq_Mission_End" },					-- ミッション終了
	{ "Seq_Mission_Clear" },				-- ミッションクリア
	{ "Seq_Mission_Telop" },				-- ミッションテロップ
	--ゲームシーケンス
	{ "Seq_RescueHostages" },				-- ゲーム開始～１人目に会う
	{ "Seq_NextRescuePaz" },				-- １人目チコ～２人目パスに会うまで
	{ "Seq_NextRescueChico" },				-- １人目パス～２人目チコに会うまで
	{ "Seq_ChicoPazToRV" },					-- チコパスの順で助け、ＲＶを目指す
	{ "Seq_PazChicoToRV" },					-- パスチコの順で助け、ＲＶを目指す
	{ "Seq_PlayerOnHeli" },					-- ２人ともヘリで回収してから自分がヘリに乗るまで
	{ "Seq_PlayerOnHeliAfter" },			-- 自分がヘリに乗ってから扉が閉まるまで
	--デモシーケンス
	{ "Seq_OpeningDemoPlay" },				--　オープニングデモ再生
	{ "Seq_RescueChicoDemo01" },			-- チコに会う１デモ再生
	{ "Seq_RescueChicoDemo02" },			-- チコに会う２デモ再生
	{ "Seq_RescuePazDemo" },				-- パスに会うデモ再生
	{ "Seq_QuestionChicoDemo" },			-- チコ回収デモ再生
	{ "Seq_QuestionPazDemo" },				-- パス回収デモ再生
	{ "Seq_CassetteDemo" },					-- テープ再生
}
-- Main
this.OnStart = function( manager )
	GZCommon.Register( this, manager )
	TppMission.Setup()
end

-- "exec"に向かうべきシーケンスのリスト
this.ChangeExecSequenceList =  {
	"Seq_MissionLoad",
	"Seq_RescueHostages",
	"Seq_NextRescuePaz",
	"Seq_NextRescueChico",
	"Seq_ChicoPazToRV",
	"Seq_PazChicoToRV",
	"Seq_PlayerOnHeli",
	"Seq_PlayerOnHeliAfter",
	 "Seq_OpeningDemoPlay",
	"Seq_RescueChicoDemo01",			-- チコに会う１デモ再生
	"Seq_RescueChicoDemo02",			-- チコに会う２デモ再生
	"Seq_RescuePazDemo",				-- パスに会うデモ再生
	"Seq_QuestionChicoDemo",			-- チコ回収デモ再生
	"Seq_QuestionPazDemo",				-- パス回収デモ再生
	"Seq_CassetteDemo" ,					-- テープ再生
}

-- クリアランク報酬テーブル
this.ClearRankRewardList = {

	-- ステージ上に配置した報酬アイテムロケータのLocatorIDを登録
	RankS = "Rank_S_Reward_Assault",
	RankA = "Rank_A_Reward_Sniper",
	RankB = "Rank_B_Reward_Missile",
	RankC = "Rank_C_Reward_SubmachinGun",
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
---------------------------------------------------------------------------------
-- Mission Flag List
---------------------------------------------------------------------------------
this.MissionFlagList = {
	--51
	isPlayerOnHeli				= false,		--プレイヤーヘリに乗る
	isFirstEncount_Chico		= false,		--先チコルート
	isEncounterChico			= false,		--チコに会うデモ
	isQuestionChico				= false,		--チコ回収デモ
	isPlaceOnHeliChico			= false,		--チコをヘリに乗せる
	isFinishOnHeliChico			= false,		--チコをヘリに乗せ終わる
	isChicoPrisonBreak			= false,		--チコ脱獄がバレる
	isEncounterPaz				= false,		--パスに会うデモ
	isQuestionPaz				= false,		--パス回収デモ
	isPlaceOnHeliPaz			= false,		--パスをヘリに乗せる
	isPazPrisonBreak			= false,		--パス脱獄がバレる
	isPazChicoDemoArea			= false,		--回収デモ未再生でパスorチコが回収デモ再生エリアに下ろされている
	isSaftyArea01				= false,		--安全エリア 海
	isSaftyArea02				= false,		--安全エリア　南
	isDangerArea				= false,		--危険エリア
	isPazChicoDangerArea		= false,		--パスorチコを危険エリアに置いている
	isHeliComingRV				= false,		--ヘリを呼んでから扉を閉じる(帰る)まで
	isHeliComeToSea				= false,		--ヘリがLZに到着したら
	isHeliLandNow				= false,		--ヘリが地面にホバリングってるかどうか
	isChicoTapeGet				= false,		--チコのテープを入手する
	isChicoTapePlay				= false,		--チコのテープを再生する
--	isChicoTapeListen			= false,		--チコのテープを聞きおえた
	isAlertTapeAdvice			= false,		--テープ再生促し無線がアラートフェイズで聞けなかった
	isPlayInterrogationAdv		= false,		--パスの情報を尋問で手に入れる促し無線をコンテニュー前に聞いているフラグ
	isHostageUnusual			= false,		--チコ周辺の捕虜の状況、２人どちらかが異常でtrue
	isKeepCaution				= false,		--キープコーション
	isPlaceOnHeliSpHostage		= false,		--脱走捕虜をヘリに乗せる
	isFinishOnHeliSpHostage		= false,		--脱走捕虜をヘリに乗せ終わる
	isCarryOnSpHostage			= false,		--脱走捕虜を担いだ
	isGetDuctInfomation			= false,		--排水溝情報を入手した
	isGunTutorialArea			= false,		--麻酔銃チュートリアルエリアにいるか
	isPreCarryAdvice			= false,		--敵兵、無力化時担ぎアドバイス
	isDoCarryAdvice 			= false,		--担ぎアドバイス再生許可フラグ（スタート崖を抜けたフラグ）
	isCenterBackEnter			= false,		--管理棟裏口侵入
	isAfterChicoDemoHostage		= false,		--チコに会うデモの後で騒ぐ捕虜
	isCarTutorial				= false,		--乗り物チュートリアルのボタン表示をした
	isBehindTutorial			= 0,			--ビハインドで表示するチュートリアル判定用
	isInSeaCliffArea			= false,		--旧収容所側の崖チェック
	isInStartCliffArea			= false,		--スタート崖側の崖チェック
	isAlertCageCheck			= false,		--アラート時にパスチコの檻を開けようとした
	isDoneCQC					= false,		--CQCをしたことがある
	isAsylumRadioArea			= false,		--旧収容所の外側の無線再生するトラップ内にいる（Radio_MillerHistory2）
	isDramaPazArea				= false,		--西側の捕虜のいる近くの道の無線再生するトラップ内にいる（Radio_DramaPaz）
	isPrimaryWPIcon				= false,		--プライマリウェポンのチュートリアルのボタンを表示した
	isMissionStartRadio			= false,		--ミッションスタート無線聞いた
	isSearchLightChicoArea		= 0,			--旧収容所のやぐらの上にいる
	isSpHostage_Dead			= false,		--脱走捕虜の死亡判定
	isCenterTowerEnemy			= false,		--管理棟の監視塔敵兵
	isPlaceOnHeliHostage04		= false,		--通常捕虜０４をヘリに乗せる
	isFinishOnHeliHostage04		= false,		--通常捕虜０４をヘリに乗せ終わる
	isGetXofMark_Hostage04		= false,		--通常捕虜０４からのＸＯＦワッペンを取得しているか？
	isHostageOnVehicle			= false,		--捕虜を車両に乗せた
	-- デモ(3)
	isCassetteDemo				= false,		-- テープ再生のデモを見た
	isSwitchLightDemo			= false,		-- 停電演出を見たか
	isDemoRelativePlay			= false,		-- このトラップの中は相対再生可能
	--会話(6)
	isTalkChicoTapeFinish		= false,		--チコテープ会話を最後まで聞いた
	isKillSpHostageEnemy01		= false,		--Talk_KillSpHostaheの敵兵が会話準備できているか？
	isKillingSpHostage			= false,		--脱走捕虜処刑執行開始
	isCTE0010_0280_NearArea		= false,		--処刑伝令会話の近くにいたか？
	isCTE0010_0310_NearArea		= false,		--パス檻の近くにいたか？
	isEscapeHostage				= false,		--脱走捕虜を探す敵兵会話が終了しているか？
	--ルートチェンジ(9)
	isAsyInsideRouteChange_01	= false,		--旧収容施設内パトロール兵、ルートチェンジ
	isCenter2F_EneRouteChange	= false,		--管理棟２Ｆ敵兵ルートチェンジ
--	isComEne25RouteChange01		= false,		--管理棟裏敵兵ルートチェンジ
--	isComEne25RouteChange02		= false,		--管理棟裏敵兵ルートチェンジ
--	isComEne25RouteChange03		= false,		--管理棟裏敵兵ルートチェンジ
	isSmokingRouteChange		= false,		--管理棟サボリ敵兵ルートチェンジ
	isVehicle_Seq30_0506Start	= false,		--最初から車輌兵
	isArmorVehicle_Start		= 0,			--最初から車輌兵
--	isPazCheckEnemy_Start		= false,		--パス確認敵兵ルートチェンジしたか？
	isSeq10_02_DriveEnd			= 0,			--seq10_02運転終了したか？
	isSeq10_03_DriveEnd			= 0,			--seq10_03運転終了したか？
	isSeq20_02_DriveEnd			= 0,			--seq20_02運転終了したか？
	isSeq40_0304_DriveEnd		= 0,			--seq40_0304運転終了したか？
	--その他(15)
	isSeq10_05SL_ON				= false,		--Seq10_05サーチライト点灯
	isAsyPickingDoor05			= false,		--ピッキングしたか否か
	isAsyPickingDoor15			= false,		--ピッキングしたか否か
	isTruckSneakRideOn			= false,		--巨大ゲートを通過するトラックの荷台に乗ったか？
	isInterrogation_Count		= 0,			--尋問回数カウント
	isInterrogation_Radio		= false,		--尋問誘導無線が流れたか
	isNoConversation_GateInTruck	= false,	--巨大ゲート通過トラック、会話をしていないか否か？
	isChicoPaz1stCarry			= false,		--チコパスどちらか１回でも担いだか？
	isSpHostageEncount			= false,		--一度でも脱走捕虜と接触したか？
	isChicoHeliJingle			= false,		--チコのヘリジングルが鳴ったか？
	isPazHeliJingle				= false,		--パスのヘリジングルが鳴ったか？
	isChicoMarkJingle			= false,		--チコのマークジングルが鳴ったか？
	isPazMarkJingle				= false,		--パスのマークジングルが鳴ったか？
	isCenterEnter				= false,		--管理棟に入ったか
	isSaveAreaNo				= 0,			--特殊セーブ用
	isSpHostageKillVersion		= false,		--脱走捕虜処刑状態になっているか？
	--破壊系(10)
	isWoodTurret01_Break		= false,		--スタート崖の木製ヤグラorサーチライト
	isWoodTurret02_Break		= false,		--東難民キャンプ（南）の木製ヤグラorサーチライト
	isWoodTurret03_Break		= false,		--東難民キャンプ（北）の木製ヤグラorサーチライト
	isWoodTurret04_Break		= false,		--西難民キャンプの木製ヤグラorサーチライト
	isWoodTurret05_Break		= false,		--旧収容施設の木製ヤグラorサーチライト
	isIronTurretSL01_Break		= false,		--倉庫（南）鉄製ヤグラのサーチライト
	isIronTurretSL02_Break		= false,		--倉庫（北）鉄製ヤグラのサーチライト
	isIronTurretSL04_Break		= false,		--ヘリポート（巨大ゲート側）鉄製ヤグラのサーチライト
	isIronTurretSL05_Break		= false,		--ヘリポート（ヘリパッド側）鉄製ヤグラのサーチライト
	isCenterTowerSL_Break		= false,		--監視塔のサーチライト
	isWappenDemo				= false,		-- ワッペンデモを見たかどうか
}
---------------------------------------------------------------------------------
-- Demo List
---------------------------------------------------------------------------------
this.DemoList = {
	ArrivalAtGuantanamo							= "p11_010100_000",	--オープニングデモ
	EncounterChico_BeforePaz_WithHostage		= "p11_010120_000",	--チコに会う１捕虜有り
	EncounterChico_BeforePaz_WithoutHostage		= "p11_010125_000",	--チコに会う１捕虜なし
	EncounterChico_BeforePaz_NoHostage			= "p11_010126_000",	--チコに会う１捕虜全滅
	EncounterChico_AfterPaz_WithHostage			= "p11_010110_000",	--チコに会う２捕虜有り
	EncounterChico_AfterPaz_WithoutHostage		= "p11_010115_000",	--チコに会う２捕虜なし
	EncounterChico_AfterPaz_NoHostage			= "p11_010116_000",	--チコに会う２捕虜全滅
	QuestionChico								= "p11_010140_000",	--チコ回収
	QuestionChicoCut							= "p11_010145_000",	--チコ回収
	EncounterPaz								= "p11_010130_000",	--パスに会う
	QuestionPaz									= "p11_010150_000",	--パス回収
	QuestionPazCut								= "p11_010155_000",	--パス回収
	SwitchLightDemo								= "p11_020001_000",		--スイッチを押したときのカメラ
	BigGateOpenDemo								= "p11_020005_000",		--巨大ゲート演出カメラ
	Demo_AreaEscapeNorth						= "p11_020010_000",	-- ミッション圏外離脱カメラデモ：北側
	Demo_AreaEscapeWest							= "p11_020020_000",	-- ミッション圏外離脱カメラデモ：西側
	Demo_XOFrolling								= "p11_010170_000", -- XOFマーク　ローリングゲット
	Demo_CassettePlayWithTapeL					= "p11_010149_000", -- カセット再生　テープを持っている左
	Demo_CassettePlayWithTapeR					= "p11_010148_000", -- カセット再生　テープを持っている右
	Demo_CassettePlayWithoutTapeL				= "p11_010147_000", -- カセット再生　テープを持っていない左
	Demo_CassettePlayWithoutTapeR				= "p11_010146_000", -- カセット再生　テープを持っていない右
}
---------------------------------------------------------------------------------
-- ■■ Mission Counter List
---------------------------------------------------------------------------------
this.CounterList = {
	GameOverRadioName			= "NoRadio",		-- ゲームオーバー無線名
	GameOverFadeTime			= GZCommon.FadeOutTime_MissionFailed,	-- ゲームオーバー時フェードアウト開始までのウェイト
	PlayQuestionDemo 			= "QuestionChico"
}
--]]
---------------------------------------------------------------------------------
-- Radio List
---------------------------------------------------------------------------------
--リアルタイム無線
this.RadioList = {
	--全シーケンス共通リアルタイム無線
	Miller_CarryDownInDanger		= "e0010_rtrg0090",			--0 捕虜を降ろした時、危険エリア
	Miller_ChicoOnHeliAdvice		= "e0010_rtrg0250",			--0 チコ、ヘリ未回収でパスをヘリで回収したら
	Miller_PazOnHeliAdvice			= "e0010_rtrg0260",			--0 パス、ヘリ未回収でチコをヘリで回収したら
	Miller_EnemyOnHeli				= "e0010_rtrg1240",			--0 捕虜・敵兵をヘリで回収したら
	Miller_KillHostage				= "e0010_rtrg1245",			--0 プレイヤーが捕虜を殺したら
	Miller_DontSneakPhase			= "e0010_rtrg0240",			--キープコーション後、スニークフェイズに戻らない
	Miller_DontEscapeTargetOnHeli	= "e0010_rtrg0340",			--0 ターゲットをヘリ未回収状態でヘリに乗ろうとした
	Miller_TargetOnHeliAdvice		= "e0010_rtrg0360",			--0 どちらかのターゲットと会った状態でヘリが到着
	Miller_DontOnHeliOnlyPlayer		= "e0010_rtrg0370",			--ターゲットと出会っているのにプレイヤーがヘリに乗ろうとした
	Miller_CallHeli01				= "e0010_rtrg0378",			--0 支援ヘリ要請時
	Miller_CallHeli02				= "e0010_rtrg0379",			--0 支援ヘリ要請時
	Miller_CallHeliHot01			= "e0010_rtrg0376",			--0 支援ヘリ要請時/ホットゾーン
	Miller_CallHeliHot02			= "e0010_rtrg0377",			--0 支援ヘリ要請時/ホットゾーン
	Miller_HeliNoCall				= "e0010_rtrg0375",			--0 ヘリを呼べない
	Miller_MissionFailedOnHeli		= "e0010_rtrg0380",			--0 クリア条件を満たしていない時にヘリに乗った無線
	Miller_StartCallHeli			= {"e0010_rtrg0381", 1},	--0 スタート崖にいるうちにヘリを呼んだ
	Miller_HeliLeave				= "e0010_rtrg0390",			--ヘリから離れろ
	Miller_HeliAttack				= "e0010_rtrg0400",			--プレイヤーがヘリを攻撃した
	Miller_WarningFlareAdvice		= {"e0010_rtrg0420", 1},	--0 発炎筒の説明
--	Miller_CarryUpAdvice			= "e0010_rtrg0460",			--0 担ぎ方法
--	Miller_AlartAdvice				= "e0010_rtrg0480",			--0 アラート警告
--	Miller_RunAwayAdvice			= "e0010_rtrg0490",			--逃亡促し
--	Miller_AlertToEvasion			= "e0010_rtrg0540",			--0 アラート後、エバージョンフェーズ
--	Miller_ReturnToSneak			= "e0010_rtrg0550",			--0 スニークフェイズに戻った
	Miller_UnKillGunAdvice			= {"e0010_rtrg0570", 1},	--麻酔銃でモノは壊せない
	Miller_BreakSuppressor			= "e0010_rtrg0636",			--サプレッサー壊れる
	Miller_EspionageRadioAdvice		= {"e0010_rtrg0660", 1},	--0 諜報無線促し
	Miller_CqcAdvice				= {"e0010_rtrg0670", 1},	--ＣＱＣ促し
	Miller_InterrogationAdvice		= {"e0010_rtrg0680", 1},	--尋問促し
	Miller_RestrictAdvice			= {"e0010_rtrg0681", 1},	--尋問チュートリアル（拘束）
	Miller_QustionAdvice			= {"e0010_rtrg0682", 1},	--尋問チュートリアル（尋問）
--	Miller_FaintAdvice				= "e0010_rtrg0683",			--尋問チュートリアル（気絶）
--	Miller_KillAdvice				= "e0010_rtrg0684",			--尋問チュートリアル（殺害）
	Miller_MillerEludeFall			= {"e0010_rtrg0690", 1},	--エルード（落下）
	Miller_MillerEludeNoFall		= {"e0010_rtrg0692", 1},	--エルード（地上）
--	Miller_RecoveryLifeAdvice		= {"e0010_rtrg0700", 1},	--体力回復促し
	Miller_SpRecoveryLifeAdvice		= "e0010_rtrg0710",			--超体力回復促し
--	Miller_RevivalAdvice			= "e0010_rtrg0720",			--体力戻った
	Miller_CuarAdvice				= "e0010_rtrg0731",			--キュア促し
--	Miller_CarRideAdviceJeep		= {"e0010_rtrg0740", 1},	--車両の、乗り方
--	Miller_CarRideAdviceCommon		= {"e0010_rtrg0750", 1},	--車両の、乗り方
--	Miller_CarDriveAdvice			= {"e0010_rtrg0760", 1},	--0 車両の運転の仕方
	Miller_MissionAreaOut			= "e0010_rtrg0790",			--0 ミッション圏外警告
	Miller_MissileGet				= {"e0010_rtrg0810", 1},	--0 無反動砲入手
	Miller_GranadoGet				= {"e0010_rtrg0813", 1},	--0 グレネード入手
	Miller_BreakAAG					= "e0010_rtrg0816",			--0 対空機関砲破壊
	Miller_AtherCagePicking			= "e0010_rtrg0825",			--0 チコ以外の捕虜の檻をピッキング（ピッキングしたとき）
	Miller_AtherHostageAdvice		= {"e0010_rtrg0830", 1},	--0 他の捕虜も助けられることを示唆（担いだとき）
	Miller_SpWeaponGet				= {"e0010_rtrg0890", 1},	--0 秘密兵器を入手した ※仮で無反動砲
	Miller_EmptyMagazin				= "e0010_rtrg0910",			--弾切れ
	Miller_MarkingTutorial			= {"e0010_rtrg0930", 1},	--敵兵マーキングチュートリアル
--	Miller_EnemyCopeCommon			= "e0010_rtrg0952",			--汎用兵士対処
--	Miller_EnemyIntelAdvice			= {"e0010_rtrg0966", 1},	--敵兵の会話が聞けることを教える
	Miller_CoverTutorial			= {"e0010_rtrg0967", 1},	-- 覗き込み
	Miller_CrawlTutorial			= {"e0010_rtrg0968", 1},	-- ホフクチュートリアル
--	Miller_BinocularsTutorial		= {"e0010_rtrg0972", 1},	-- 双眼鏡チュートリアル
	Miller_CommonHostageInformation	= "e0010_rtrg0980",			--0 汎用捕虜情報
	Miller_XofMarking				= "e0010_rtrg1000",			--0 捕虜からXOFマークを聞いた
--	Miller_GetXof					= "e0010_rtrg1010",			--XOFマークを入手
--	Miller_VehicleDriveAdvice		= "e0010_rtrg1050",			--0 Backボタンでビークル基本操作説明
	Miller_StrykerDriveAdvice		= {"e0010_rtrg1060", 1},	--Backボタンで機銃装甲車基本操作説明
	Miller_AboutXofMark				= "e0010_rtrg1070",			--0 XOFマークについて
	Miller_AboutXofMarkTwo			= "e0010_rtrg1071",			--0 XOFマーク2つ目入手
	Miller_AllXofMarkGet			= "e0010_rtrg1075",			--0 XOFマーク全取得
	Miller_PlayerOnHeliAdvice		= "e0010_rtrg1080",			--0 チコパスをヘリに乗せた後、ＰＣもヘリに乗るように促す
--	Miller_UpCamfulaOnCar			= "e0010_rtrg1200",			--車両に乗ったらカモフラ率UP ※保留
--	Miller_choseLZ					= {"e0010_rtrg1230", 1},	--0 LZ選択画面でLZ選択促し
	Miller_HohukuAdvice				= {"e0010_rtrg1250", 1},	--0 排水溝の入り口に立ったとき匍匐促し
--	Miller_RouteDrain				= {"e0010_rtrg3060", 1},	--0 こんな道があったとは
	Miller_InHeliport				= {"e0010_rtrg3050", 1},	--0 ヘリポートに着いた
	Miller_GetPazInfo				= {"e0010_rtrg1260", 1},	--0 パスの居場所の情報を入手した
	Miller_AllGetTape				= {"e0010_rtrg4010", 1},	--カセットテープ全取得
	Miller_JointVoice01				= "e0010_rtrg9900",			--0 それからボス
--	Miller_JointVoice02				= "e0010_rtrg9901",			--0 それとボス
	Miller_TapeReaction00			= {"e0010_rtrg1269", 1},	--チコテープへのリアクション0
	Miller_TapeReaction01			= "e0010_rtrg1270",			--チコテープへのリアクション1
	Miller_TapeReaction02			= "e0010_rtrg1271",			--チコテープへのリアクション2
	Miller_TapeReaction03			= "e0010_rtrg1272",			--チコテープへのリアクション3
	Miller_TapeReaction04			= "e0010_rtrg1273",			--チコテープへのリアクション4
	Miller_TapeReaction05			= "e0010_rtrg1274",			--チコテープへのリアクション5
--	Miller_TapeReaction06			= {"e0010_rtrg1275", 1},	--チコテープへのリアクション6
	Miller_TapeReaction07			= {"e0010_rtrg0111", 1},	--チコテープEnd
--	Miller_TapeReaction07			= {"e0010_rtrg1276", 1},	--チコテープへのリアクション7
--	Miller_TapeReaction08			= {"e0010_rtrg1277", 1},	--チコテープへのリアクション8
--	Miller_TapeReaction09			= {"e0010_rtrg1278", 1},	--チコテープへのリアクション9
	Miller_SecurityCameraAdvice		= {"e0010_rtrg2050", 1},	--監視カメラ注意促し
	--ゲーム開始～１人目に会う専用
	Miller_MissionStart				= {"e0010_rtrg0010", 1},	--0 ミッション概要説明
	Miller_MissionContinue			= {"e0010_rtrg0009", 1},	--0 ミッション概要説明
--	Miller_TargetMarkOn				= {"e0010_rtrg0030", 1},	--0 マップにターゲット位置をマーク
	Miller_CallAdvice				= {"e0010_rtrg0031", 1},	--0 アドバイスが必要なら連絡
	Miller_MovingAdvice				= {"e0010_rtrg0040", 1},	--0 敷地内侵入後の目的指示
	Miller_DeviceAdvice				= {"e0010_rtrg0041", 1},	--0 端末チュートリアル
	Miller_ChangePostureAdvice		= {"e0010_rtrg0940", 1},	--0 低姿勢促し
	Miller_EnemyCopeOnlyVersion		= {"e0010_rtrg0950", 1},	--0 兵士対処、旧収容施設前
	Miller_EnemyCopeOnlyCQC			= {"e0010_rtrg0952", 1},	--0 兵士対処、旧収容施設前
	Miller_TranquilizerGunAdvice	= {"e0010_rtrg0960", 1},	--0 麻酔銃の促し
--	Miller_BasicActionAdvice		= "e0010_rtrg1040",			--0 Backボタンで基本操作説明
	Miller_DiscoverySpHostage		= {"e0010_rtrg1090", 1},	--0 敵兵に見つかる前の処刑捕虜を発見
	Miller_MarkingExTape			= {"e0010_rtrg1150", 1},	--先パス専用、テープの在り処
	Miller_MarkingExhaveTape		= {"e0010_rtrg1152", 1},	--テープを持っている
	Miller_StepOnAdvice				= {"e0010_rtrg1170", 1},	--0 段差のぼり
	Miller_PreCarryAdvice			= "e0010_rtrg0965",			--敵兵担ぎアドバイス
	Miller_DramaChico				= {"e0010_rtrg2020", 1},	--ドラマ無線：チコのこと
	Miller_Drama2Chico				= {"e0010_rtrg2021", 1},	--ドラマ無線：チコのこと2
	Miller_InOldAsylum				= {"e0010_rtrg0050", 1},	--旧収容所の近くに入った
	--１人目チコ～２人目パスに会うまで
	Miller_TakeChicoToRVPoint		= {"e0010_rtrg0060", 1},	--0 チコをＲＶに移動させる
	Miller_TakeChicoOnHeli			= "e0010_rtrg0061",			--0 チコをヘリで回収しろ
--	Miller_ChicoRV					= "e0010_rtrg0095",			--0 ルートから離れていることを知らせる
	Miller_ChicoTapeAdvice01		= "e0010_rtrg0100",			--0 チコ回収デモ再生後
	Miller_ChicoTapeAdvice02		= {"e0010_rtrg0101", 1},	--0 チコ回収デモ再生済で海岸から戻る特定の地点まで到達した
	Miller_ChicoTapeReAdvice		= {"e0010_rtrg0110", 1},	--0 チコ回収デモ再生せずチコをヘリに乗せ、そのヘリが飛び立ち扉を閉じた
--	Miller_PazTakeRouteInCamp		= {"e0010_rtrg0120", 1},	--0 パス連行ルート確認、キャンプ
	Miller_PazTakeRouteInHeliport	= {"e0010_rtrg0140", 1},	--0 パス連行ルート確認、ヘリポート
	Miller_PazTakeRouteInGate		= {"e0010_rtrg0150", 1},	--0 パス連行ルート確認、ゲート
	Miller_PazTakeRouteInBoilar		= {"e0010_rtrg0160", 1},	--0 パス連行ルート確認、ボイラー
	Miller_PazTakeRouteInFlag		= {"e0010_rtrg0130", 1},	--0 パス連行ルート確認、星条旗
--	Miller_PazPlaceAdvice			= "e0010_rtrg0850",			--尋問でパスの居場所を吐かせる
--	Miller_WalkmanAdvice			= "e0010_rtrg0885",			--0 ウォークマンチュートリアル
	Miller_LeadSpHostageEscape		= {"e0010_rtrg1140", 1},	--0 先チコ専用、処刑捕虜の話し後
	Miller_EscapeOrAttack			= {"e0010_rtrg1160", 1},	--先チコ専用、パス救出後のクエストの後
	Miller_DramaPaz1				= {"e0010_rtrg2010", 1},	--ドラマ無線：パスのこと１
	Miller_DramaPaz2				= {"e0010_rtrg2011", 1},	--ドラマ無線：パスのこと２
--	Miller_DramaPaz3				= {"e0010_rtrg2012", 1},	--ドラマ無線：パスのこと３
--	Miller_CareChico				= {"e0010_rtrg3010", 1},	--監禁中に何があった？
	Miller_RescuePaz1				= {"e0010_rtrg3030", 1},	--パスの居場所がわからず焦るミラー1
	Miller_RescuePaz2				= {"e0010_rtrg3035", 1},	--パスの居場所がわからず焦るミラー2
	Miller_InCenterCoverAdviceCQC	= {"e0010_rtrg3070", 1},	--管理棟に入ったら（排水溝以外、未CQC）
	Miller_InCenterCoverAdvice		= {"e0010_rtrg3072", 1},	--管理棟に入ったら（排水溝以外、済CQC）
	--１人目パス～２人目チコに会うまで
--	Miller_DiscoveryPaz				= {"e0010_rtrg0180", 1},	--0 先パス専用、パスを意外な場所で発見した
--	Miller_takePazToRVPoint02		= "e0010_rtrg0190",			--0 先パス専用、パス回収デモを見たら
	Miller_takePazToRVPoint01		= "e0010_rtrg0200",			--0 先パス専用、パスに会うデモを見たら
	Miller_takePazOnHeli			= {"e0010_rtrg0210", 1},	--0 先チコ専用、パスに会ったら
--	Miller_AttackSearchLightEnemy	= "e0010_rtrg1030",			--先パス専用、旧収容施設サーチライト兵を倒す
	--単独もしくは複数シーケンス
	Miller_NearRV					= {"e0010_rtrg0070", 1},	--0 チコパスを担いでいる状態で指定ＲＶに近づいた
	Miller_ArriveRV					= {"e0010_rtrg0080", 1},	--0 パスを担いでいる状態でＲＶに到着
	Miller_ArriveRVChico			= {"e0010_rtrg0083", 1},	--0 チコを担いでいる状態でＲＶに到着
	Miller_ArriveRVChicoAlert		= {"e0010_rtrg0081", 1},	--0 チコを担いでいる状態でＲＶに到着(敵警戒時)
	Miller_ArriveRVChicoNearEnemy	= {"e0010_rtrg0082", 1},	--0 チコを担いでいる状態でＲＶに到着(敵警戒時)
	Miller_PazJailBreak				= "e0010_rtrg0220",			--0 パス脱獄がばれた(チコ未遭遇)
	Miller_PazJailBreak2			= "e0010_rtrg0221",			--0 パス脱獄がばれた(チコ遭遇済)
	Miller_EnemyDiscoveryChico		= "e0010_rtrg0320",			--放置していたチコが敵兵に見つかった
	Miller_EnemyDiscoveryPaz		= "e0010_rtrg0330",			--放置していたパスが敵兵に見つかった
	Miller_CallHeliAdvice			= {"e0010_rtrg0350", 1},	--0 チコ先のとき管理棟の外に出た
--	Miller_InCenterAdvice			= {"e0010_rtrg0860", 2},	--0 管理棟に入る方法
--	Miller_OpenBigGateAdvice		= "e0010_rtrg0870",			--運搬用ゲートが開いたお知らせ
--	Miller_PazOnVehicle				= "e0010_rtrg0905",			--パスをビークルに乗せられて時間短縮
--	Miller_SwitchLightAdvice01		= {"e0010_rtrg0990", 1},	--0 管理棟内の配電盤（捕虜からの情報）
	Miller_MeetChicoPazInCombat		= "e0010_rtrg1020",			--戦闘中なのでチコパス接触不可
	Miller_MeetChicoPazNearEnemy	= "e0010_rtrg1022",			--近くに敵がいるのでチコパス接触不可
	Miller_UlMeetChicoPazInCombat	= "e0010_rtrg1025",			--戦闘中なのでチコパス接触不可から解除
	Miller_UlMeetChicoPazNearEnemy	= "e0010_rtrg1026",			--近くに敵がいるのでチコパス接触不可から解除
	Miller_CarrySpHostage			= {"e0010_rtrg1095", 1},	--脱走捕虜を担ぐ
	Miller_RescueSpHostage			= {"e0010_rtrg1096", 1},	--脱走捕虜を担ぐ(チコ遭遇後)
--	Miller_SpHostageInSaftyArea		= "e0010_rtrg1100",			--0 処刑捕虜を安全エリアに運んだとき
	Miller_AboutDuct01				= "e0010_rtrg1110",			--0 処刑捕虜をヘリで回収（排水溝情報を入手していない）
--	Miller_ChicoSpHosHosOnHeli		= "e0010_rtrg1111",			--0 チコと脱走捕虜と、通常捕虜０４を一度にヘリに乗せた時専用
--	Miller_AboutDuct02				= "e0010_rtrg1120",			--0 排水溝位置マーキング（排水溝情報を入手している）
	Miller_SwitchLightAdvice02		= {"e0010_rtrg1130", 1},	--0 配電盤を切ると...
	Miller_ReChicoAdviceEva			= "e0010_rtrg1180",			--アラート→エバージョン以下でチコ回収デモ促し
--	Miller_ReChicoAdvice			= "e0010_rtrg1183",			--アラート→コーション以下でチコ回収デモ促し
	Miller_ReChicoAdviceCarrie		= "e0010_rtrg0085",			--アラート→コーション以下でチコ回収デモ促し
	Miller_ReChicoAdviceOutRV		= "e0010_rtrg0086",			--アラート→コーション以下でチコ回収デモ促し
--	Miller_RePazAdvice				= {"e0010_rtrg1193", 1},	--アラート→コーション以下でパス回収デモ促し
	Miller_PazChicoCarriedEndRV		= "e0010_rtrg1220",			--パスチコを遭遇済みでどちらかをRVにおろしたら
	Miller_SearchChico				= {"e0010_rtrg1300", 1},	--旧収容所のやぐらにのぼったら
	Miller_SearchLightChico			= {"e0010_rtrg1310", 1},	--旧収容所のやぐらのライトでチコの檻を照らしたら
	Miller_MillerHistory1			= {"e0010_rtrg2030", 1},	--ドラマ無線：カズとの思い出（出会い）
	Miller_MillerHistory2			= {"e0010_rtrg2040", 1},	--ドラマ無線：カズとの思い出（コロンビアからPW）
	Miller_CliffAttention			= {"e0010_rtrg3020", 1},	--海に落ちるな
	Miller_Rain						= {"e0010_rtrg3040", 1},	--雨がひどい
	Miller_Cheer					= {"e0010_rtrg3080", 1},	--ミラーが応援する
--	Miller_ComingHeli				= {"e0010_rtrg3090", 1},	--ヘリが来るまでもう少し
--	Miller_WatchPhotoAsylum			= {"e0010_rtrg1400", 1},	--写真を見る（旧収容所）
	Miller_WatchPhotoChico			= {"e0010_rtrg1410", 1},	--写真を見る（チコ）
	Miller_WatchPhotoPaz			= {"e0010_rtrg1420", 1},	--写真を見る（パス）
	Miller_WatchPhotoStart			= {"e0010_rtrg1429", 1},	--最初の写真を見る無線の前に言う
	Miller_WatchPhotoAll			= {"e0010_rtrg1430", 1},	--写真を全部見たから改めて目的指示
	--ゲームオーバー用
	Miller_DeadPlayer				= "f0033_gmov0010",			--プレイヤー死亡
	Miller_OutofMissionArea			= "f0033_gmov0020",			--プレイヤーミッション圏外
	Miller_StopMission				= "f0033_gmov0030",			--ミッション中止
--	Miller_FailedMission			= "f0033_gmov0180",			--ミッション失敗
	Miller_DeadChico				= "f0033_gmov0060",			--チコ死亡
	Miller_KillChoco				= "f0033_gmov0070",			--チコ殺害
	Miller_HeliDownChico			= "f0033_gmov0080",			--チコ搭乗ヘリ墜落
	Miller_DeadPaz					= "f0033_gmov0090",			--パス死亡
	Miller_KillPaz					= "f0033_gmov0100",			--パス殺害
	Miller_HeliDownPaz				= "f0033_gmov0110",			--パス搭乗ヘリ墜落
	Miller_OnlyPcOnHeli				= "f0033_gmov0040",			--パスチコを乗せずにヘリで離脱した
	Miller_HeliDead					= "f0033_gmov0050",			--ヘリが落とされた
}
--任意無線
this.OptionalRadioList = {
	Optional_GameStartToRescue			= "Set_e0010_oprg0010",
	Optional_GameStartToRescueBino		= "Set_e0010_oprg1010",
	Optional_InOldAsylum				= "Set_e0010_oprg0011",
	Optional_DiscoveryChico				= "Set_e0010_oprg0012",
	Optional_RescueChicoToRVChico		= "Set_e0010_oprg0015",
	Optional_OnRVChico					= "Set_e0010_oprg0019",
	Optional_RVChicoToRescuePaz			= "Set_e0010_oprg0020",
	Optional_RVChicoToRescuePazBino		= "Set_e0010_oprg1020",
	Optional_ChicoOnHeli				= "Set_e0010_oprg0021",
	Optional_Interrogation				= "Set_e0010_oprg0022",
	Optional_InterrogationBino			= "Set_e0010_oprg1022",
	Optional_DiscoveryPaz				= "Set_e0010_oprg0025",
	Optional_RescuePazToRVPaz			= "Set_e0010_oprg0029",
	Optional_RescuePazToRescueChico		= "Set_e0010_oprg0030",
	Optional_RescuePazToRescueChicoBino	= "Set_e0010_oprg1030",
	Optional_RescueBothToRideHeli		= "Set_e0010_oprg0040",
	Optional_RideHeliChico				= "Set_e0010_oprg0041",
	Optional_RideHeliPaz				= "Set_e0010_oprg0042",
	Optional_RescueComplete				= "Set_e0010_oprg0043",
}
--諜報無線
this.IntelRadioList = {
	--シェイプ
	intel_e0010_esrg0020	= "e0010_esrg0020",
	intel_e0010_esrg0030	= "e0010_esrg0030",
	intel_e0010_esrg0040	= "e0010_esrg0040",	-- 0050,0060
	intel_e0010_esrg0090	= "e0010_esrg0090",
	intel_e0010_esrg0110	= "e0010_esrg0110",
	intel_e0010_esrg0120	= "e0010_esrg0120",
	intel_e0010_esrg0190	= "e0010_esrg0190",
	intel_e0010_esrg0380	= "e0010_esrg0380",
	intel_e0010_esrg0440	= "e0010_esrg0440",
	intel_e0010_esrg0440_1	= "e0010_esrg0440",
	intel_e0010_esrg0450	= "e0010_esrg0450",
	intel_e0010_esrg0450_1	= "e0010_esrg0450",
	intel_e0010_esrg0450_2	= "e0010_esrg0450",
	intel_e0010_esrg0480	= "e0010_esrg0480",
	intel_e0010_esrg0490	= "e0010_esrg0490",
	--パスチコ
	Chico = "e0010_esrg0080",
	Paz   = "e0010_esrg0100",
	--敵兵・捕虜
	ComEne01 = "e0010_esrg0170",
	ComEne02 = "e0010_esrg0170",
	ComEne03 = "e0010_esrg0170",
	ComEne04 = "e0010_esrg0170",
	ComEne05 = "e0010_esrg0170",
	ComEne06 = "e0010_esrg0170",
	ComEne07 = "e0010_esrg0170",
	ComEne08 = "e0010_esrg0170",
	ComEne09 = "e0010_esrg0170",
	ComEne10 = "e0010_esrg0170",
	ComEne11 = "e0010_esrg0170",
	ComEne12 = "e0010_esrg0170",
	ComEne13 = "e0010_esrg0170",
	ComEne14 = "e0010_esrg0170",
	ComEne15 = "e0010_esrg0170",
	ComEne16 = "e0010_esrg0170",
	ComEne17 = "e0010_esrg0170",
	ComEne18 = "e0010_esrg0170",
	ComEne19 = "e0010_esrg0170",
	ComEne20 = "e0010_esrg0170",
	ComEne21 = "e0010_esrg0170",
	ComEne22 = "e0010_esrg0170",
	ComEne23 = "e0010_esrg0170",
	ComEne24 = "e0010_esrg0170",
	ComEne25 = "e0010_esrg0170",
	ComEne26 = "e0010_esrg0170",
	ComEne27 = "e0010_esrg0170",
	ComEne28 = "e0010_esrg0170",
	ComEne29 = "e0010_esrg0170",
	ComEne30 = "e0010_esrg0170",
	ComEne31 = "e0010_esrg0170",
	ComEne32 = "e0010_esrg0170",
	ComEne33 = "e0010_esrg0170",
	ComEne34 = "e0010_esrg0170",
	Seq10_01 = "e0010_esrg0170",
	Seq10_02 = "e0010_esrg0170",
	Seq10_05 = "e0010_esrg0170",
	Seq10_06 = "e0010_esrg0170",
	Seq10_07 = "e0010_esrg0170",
	SpHostage = "e0010_esrg0330",
	--対空砲
	gntn_area01_antiAirGun_000 = "e0010_esrg0180",
	gntn_area01_antiAirGun_001 = "e0010_esrg0180",
	gntn_area01_antiAirGun_002 = "e0010_esrg0180",
	gntn_area01_antiAirGun_003 = "e0010_esrg0180",
	--やぐら
	WoodTurret01 = "e0010_esrg0201",
	WoodTurret02 = "e0010_esrg0201",
	WoodTurret03 = "e0010_esrg0200",
	WoodTurret04 = "e0010_esrg0200",
	WoodTurret05 = "e0010_esrg0200",
	--ジープ
--	Tactical_Vehicle_WEST_001 = "e0010_esrg0210",
	Tactical_Vehicle_WEST_002 = "e0010_esrg0210",
	Tactical_Vehicle_WEST_003 = "e0010_esrg0210",
	Tactical_Vehicle_WEST_004 = "e0010_esrg0210",
	Tactical_Vehicle_WEST_005 = "e0010_esrg0210",
	--トラック
	Cargo_Truck_WEST_002 = "e0010_esrg0290",
	Cargo_Truck_WEST_003 = "e0010_esrg0290",
	Cargo_Truck_WEST_004 = "e0010_esrg0290",
	--機銃装甲車
	Armored_Vehicle_WEST_001 = "e0010_esrg0390",
	Armored_Vehicle_WEST_002 = "e0010_esrg0390",
	Armored_Vehicle_WEST_003 = "e0010_esrg0390",
	--サーチライト（やぐら）
	SL_WoodTurret01 = "e0010_esrg0010",
	SL_WoodTurret02 = "e0010_esrg0010",
	SL_WoodTurret03 = "e0010_esrg0010",
	SL_WoodTurret04 = "e0010_esrg0010",
	SL_WoodTurret05 = "e0010_esrg0010",
--	SL_WoodTurret05 = "e0010_esrg0460",
	--サーチライト（鉄塔）
	gntn_area01_searchLight_000 = "e0010_esrg0010",
	gntn_area01_searchLight_001 = "e0010_esrg0010",
	gntn_area01_searchLight_002 = "e0010_esrg0010",
	gntn_area01_searchLight_003 = "e0010_esrg0010",
	gntn_area01_searchLight_004 = "e0010_esrg0010",
	gntn_area01_searchLight_005 = "e0010_esrg0010",
	gntn_area01_searchLight_006 = "e0010_esrg0010",
	--犬
--	WatchDog_e20010_0000 = "e0010_esrg0420",
--	WatchDog_e20010_0004 = "e0010_esrg0420",
	--ドラム缶
	e20010_drum0025  = "e0010_esrg0430",
	e20010_drum0027  = "e0010_esrg0430",
	e20010_drum0040  = "e0010_esrg0430",
	e20010_drum0042  = "e0010_esrg0430",
	gntnCom_drum0002 = "e0010_esrg0430",
	gntnCom_drum0005 = "e0010_esrg0430",
	gntnCom_drum0011 = "e0010_esrg0430",
	gntnCom_drum0012 = "e0010_esrg0430",
	gntnCom_drum0015 = "e0010_esrg0430",
	gntnCom_drum0019 = "e0010_esrg0430",
	gntnCom_drum0020 = "e0010_esrg0430",
	gntnCom_drum0021 = "e0010_esrg0430",
	gntnCom_drum0022 = "e0010_esrg0430",
	gntnCom_drum0023 = "e0010_esrg0430",
	gntnCom_drum0024 = "e0010_esrg0430",
	gntnCom_drum0025 = "e0010_esrg0430",
	gntnCom_drum0027 = "e0010_esrg0430",
	gntnCom_drum0028 = "e0010_esrg0430",
	gntnCom_drum0029 = "e0010_esrg0430",
	gntnCom_drum0030 = "e0010_esrg0430",
	gntnCom_drum0031 = "e0010_esrg0430",
	gntnCom_drum0035 = "e0010_esrg0430",
	gntnCom_drum0037 = "e0010_esrg0430",
	gntnCom_drum0038 = "e0010_esrg0430",
	gntnCom_drum0039 = "e0010_esrg0430",
	gntnCom_drum0040 = "e0010_esrg0430",
	gntnCom_drum0041 = "e0010_esrg0430",
	gntnCom_drum0042 = "e0010_esrg0430",
	gntnCom_drum0043 = "e0010_esrg0430",
	gntnCom_drum0044 = "e0010_esrg0430",
	gntnCom_drum0045 = "e0010_esrg0430",
	gntnCom_drum0046 = "e0010_esrg0430",
	gntnCom_drum0047 = "e0010_esrg0430",
	gntnCom_drum0048 = "e0010_esrg0430",
	gntnCom_drum0065 = "e0010_esrg0430",
	gntnCom_drum0066 = "e0010_esrg0430",
	gntnCom_drum0068 = "e0010_esrg0430",
	gntnCom_drum0069 = "e0010_esrg0430",
	gntnCom_drum0070 = "e0010_esrg0430",
	gntnCom_drum0071 = "e0010_esrg0430",
	gntnCom_drum0072 = "e0010_esrg0430",
	gntnCom_drum0101 = "e0010_esrg0430",
	--監視カメラ
	e20010_SecurityCamera_01 = "e0010_esrg0470",
	e20010_SecurityCamera_02 = "e0010_esrg0470",
	e20010_SecurityCamera_03 = "e0010_esrg0470",
	e20010_SecurityCamera_04 = "e0010_esrg0470",
}

local PrepareDisposal = function()
	-- これまでに獲得している報酬数を保持
	local uiCommonData = UiCommonDataManager.GetInstance()
	this.tmpRewardNum = uiCommonData:GetRewardNowCount( this.missionID )
	Fox.Log("***e20010_MissionPrepare.tmpRewardNum_IS___"..this.tmpRewardNum)
	-- ゲームフラグにこれまでに獲得している報酬数を登録
	TppGameSequence.SetGameFlag("rewardNumOfMissionStart", this.tmpRewardNum )

	--ミッション都合などで、持ってない扱いにする
	if( TppMission.GetFlag( "isChicoTapeGet" ) == false ) then
		local uiCommonData = UiCommonDataManager.GetInstance()
		uiCommonData:HideCassetteTape( "tp_chico_03" )
	else
		-- ミッション内で入手したので何もしない
	end
	-- 難易度別にこれまでの戦績に応じて報酬アイテムを設置。同時にミッション開始時点でのBestRankを保持しておく
	this.tmpBestRank = GZCommon.CheckClearRankReward( this.missionID, this.ClearRankRewardList )
	Fox.Log("***e20010.tmpBestRank_IS__"..this.tmpBestRank)
	-- ゲームフラグに過去のベストランクを登録
	TppGameSequence.SetGameFlag("e20010_beforeBestRank", this.tmpBestRank )
	--チコ3再生中に無線再生できるようにする
	TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( false )
end
---------------------------------------------------------------------------------
--アナウンスログ
---------------------------------------------------------------------------------
-- ミッション圏外に移動
local AnounceLog_area_warning = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_mission_area_warning" )
end
-- 警備シフト変更
local AnounceLog_enemyReplacement = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_enemyReplacement" )
end
-- エリア外に移動
local AnounceLog_enemyDecrease = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_enemyDecrease" )
end
-- チコに接触
local AnounceLog_EncountChico = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_mission_40_20010_000_from_0_prio_0" )
end
-- パスに接触
local AnounceLog_EncountPaz = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_mission_40_20010_003_from_0_prio_0" )
end
-- チコをＲＶに運んだ
local AnounceLog_CarryChicoToRV = function()
	if ( TppMission.GetFlag( "isSaftyArea01" ) == true ) then
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:AnnounceLogViewLangId( "announce_mission_40_20010_001_from_0_prio_0" )
	else
	end
end
-- パスをＲＶに運んだ
local AnounceLog_CarryPazToRV = function()
	if ( TppMission.GetFlag( "isSaftyArea01" ) == true ) then
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:AnnounceLogViewLangId( "announce_mission_40_20010_004_from_0_prio_0" )
	else
	end
end
-- チコをヘリに乗せた
local AnounceLog_ChicoRideOnHeli = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_mission_40_20010_002_from_0_prio_0" )
end
-- パスをヘリに乗せた
local AnounceLog_PazRideOnHeli = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_mission_40_20010_005_from_0_prio_0" )
end
-- 脱走捕虜を担いだ
local AnounceLog_SpHostage = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_mission_40_20010_006_from_0_prio_0" )
end
-- 脱走捕虜をヘリに乗せた
local AnounceLog_SpHostageRideOnHeli = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_mission_40_20010_007_from_0_prio_0" )
end
-- ヘリが離脱した
local AnounceLog_HeliEscape = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_heli_escape" )
end
-- 通常捕虜をヘリに乗せた
local AnounceLog_NormalHostageRideOnHeli = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_collection_hostage" )
end
-- 敵兵をヘリに乗せた
local AnounceLog_EnemyRideOnHeli = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_collection_enemy" )
end
-- ＸＯＦマークを入手
local AnounceLog_GetXofMark = function()
	local count = TppStorage.GetXOFEmblemCount()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_get_xof", count , 9 )

	if ( count == 1 ) then	-- ＸＯＦはじめて拾った！！
		TppRadio.DelayPlay("Miller_AboutXofMark", "short")
	elseif ( count == 2 ) then	-- ＸＯＦ2つ目拾った！！
		TppRadio.DelayPlay("Miller_AboutXofMarkTwo", "short")
	elseif ( count == 9 ) then	-- ＸＯＦワッペン全て揃った！！
		TppRadio.DelayPlay("Miller_AllXofMarkGet", "short")
	end

end
-- マップ情報を更新
local AnounceLog_MapUpdate = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_map_update" )
end
-- ミッション情報を更新
local AnounceLog_MissionUpdate = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_mission_info_update" )
end
-----------------------------------------------------------------------------
-- ミッション圏外付近でデモ発動した際にデモ終了後、強制的にミッション圏外扱いにする
local MissionArea_PcWarp = function()

	local player	= Ch.FindCharacterObjectByCharacterId( "Player" )
	local playerPos	= player:GetPosition()
	local x = playerPos:GetX()
	local z = playerPos:GetZ()

	-- 東ミッション圏外以外判定
	if ( 4.5 < x ) and ( x < 72) and ( 2.5 < z) and ( z < 62.5 ) then
		Fox.Log("EastMissionArea_OUT")
		TppMission.ChangeState( "failed", "MissionAreaOut" )
	-- 西ミッション圏外以外判定
	elseif ( -380 < x ) and ( x < -293) and ( 113 < z) and ( z < 200) then
		Fox.Log("WestMissionArea_OUT")
		TppMission.ChangeState( "failed", "MissionAreaOut" )
	else
		-- ミッション圏外にしない
		Fox.Log("IN Mission Area !!")
	end
end
---------------------------------------------------------------------------------
-- Mission Functions
---------------------------------------------------------------------------------

this.e20010_PlayerSetWeapons = function()
	local hardmode = TppGameSequence.GetGameFlag("hardmode")	-- 現在の難易度を取得
	if hardmode == true then
		TppPlayer.SetWeapons( GZWeapon.e20010_SetWeaponsHard )
	else
		TppPlayer.SetWeapons( GZWeapon.e20010_SetWeapons )
	end
end

this.e20010_PlayerSetWeapons = function()
	local hardmode = TppGameSequence.GetGameFlag("hardmode")	-- 現在の難易度を取得
	if hardmode == true then
		TppPlayer.SetWeapons( GZWeapon.e20010_SetWeaponsHard )
	else
		TppPlayer.SetWeapons( GZWeapon.e20010_SetWeapons )
	end
end

--リトライ時のコーションサイレン
local Common_RetryKeepCautionSiren = function()
	--パス脱獄がバレていたらキープコーションサイレンを鳴らす
	if( TppMission.GetFlag( "isPazPrisonBreak" ) == true ) then
		local timer = 2
		GkEventTimerManager.Start( "Timer_CallCautionSiren", timer )
	else
		TppMusicManager.SetSwitch{
			groupName = "bgm_phase_ct_level",
			stateName = "bgm_phase_ct_level_01",
		}
	end
end

--準備シーケンス
this.Seq_MissionPrepare = {
	OnEnter = function()
		this.e20010_PlayerSetWeapons()
		TppSequence.ChangeSequence( "Seq_MissionSetup" )
		PrepareDisposal()
	end,
}

-- Do all mission setup
local MissionSetup = function()
	-- Set colorCorrection
	-- TODO: delete this!!
--	local colorCorrectionLUTPath = "/Assets/tpp/effect/gr_pic/lut/gntn_25thDemo_FILTERLUT.ftex"
--	TppEffectUtility.SetColorCorrectionLut( colorCorrectionLUTPath )
	TppEffectUtility.SetColorCorrectionLut( "gntn_25thDemo_FILTERLUT" )

	--パスミッションのプローブのレンジ
	GrTools.SetLightingColorScale(1.0)
	-- Set default time and weather
	TppClock.SetTime( "00:00:00" )
	TppClock.Stop()
	TppWeather.SetWeather( "pouring" )
	TppWeather.Stop()

	-- テクスチャロード待ち処理
--	MissionManager.SetMiddleTextureWaitParameter( 0.5, 5 )

	--ルートセット
	local cpRouteSets = {
		{
			cpID = "gntn_cp",
			sets = {
				sneak_night = "e20010_Seq00_SneakRouteSet",
				caution_night = "e20010_Seq00_CautionRouteSet",
			},
		},
	}
	TppEnemy.SetRouteSets( cpRouteSets )
	PrepareDisposal()
	--RadioSave
--	GzRadioSaveData.SetSaveRadioId( "e0010_esrg0070" )
--	GzRadioSaveData.SetSaveRadioId( "e0010_esrg0080" )
	TppRadio.SetAllSaveRadioId()
	--輸送トラックにリボルバーショットガン
	TppNewCollectibleUtility.PutCollectibleOnCharacter{ id = "WP_hg02_v00", count = 90, target = "Cargo_Truck_WEST_002" , attachPoint = "CNP_USERITEM" }

	--DemoDoor設定
	TppGadgetUtility.SetWillBeOpenedInDemo("AsyPickingDoor24")
	TppGadgetUtility.SetWillBeOpenedInDemo("Paz_PickingDoor00")
	TppGadgetUtility.AddDoorEnableCheckInfo("AsyPickingDoor24", Vector3(69,20,204), this.eneCheckSize_chico)
	TppGadgetUtility.AddDoorEnableCheckInfo("Paz_PickingDoor00", Vector3(-138, 24, -16), eneCheckSize_paz )

	-- Register siren source event (base)
--	local tag = "Siren"
--	TppSound.RegisterSourceEvent( "SoundSource_alertsiren", tag, "sfx_m_gntn_alert_siren_lp", "Stop_sfx_m_gntn_alert_siren_lp" )	-- base
--	TppSound.RegisterSourceEvent( "SoundSource_alertsiren2", tag, "sfx_m_gntn_alert_siren2_lp", "Stop_sfx_m_gntn_alert_siren2_lp" )	-- heliport
end
--[[
-- Load demo block
local LoadDemoBlock = function( blockID )
	local demoBlockPath = "/Assets/tpp/pack/mission/extra/e20010/e20010_" .. blockID .. ".fpk"
	TppMission.LoadDemoBlock( demoBlockPath )
end
--]]
local IsEventBlockActive = function()
	if ( TppMission.IsEventBlockActive() == false ) then
		return false
	end

	--ローディングTipsの終了を待つ
	local hudCommonData = HudCommonDataManager.GetInstance()
	if hudCommonData:IsEndLoadingTips() == false then
			hudCommonData:PermitEndLoadingTips() --終了許可(決定ボタンを押したら消える)
			-- 決定ボタン押されるのを待ってます
			return false
	end
	-- 決定ボタン押されれたらここに到達します
	return true
--[[
	if ( TppVehicleBlockControllerService.IsHeliBlockExist() ) then
		-- HeliBlockあり
		if ( TppVehicleBlockControllerService.IsHeliBlockActivated() ) then
			return true
		end
	else
		return true
	end
	return false
--]]
end

-- Load main game mission
local MainMissionLoad = function()
	-- Enable Chico
	TppData.GetData( "Chico" ).enable = true

	-- Register optional radio
--	TppRadio.RegisterOptionalRadio( "Optional_GameStartToRescue" )
end

-- 相対再生チェックでずれていたらワープ
local Check_AroundSpace = function( charaId )
	-- Check Space Around and Play Demo
	local warpPlayer = "notWarp"

	local player = Ch.FindCharacterObjectByCharacterId( "Player")
	local hikaku = player:GetRotation()

	if( TppMission.GetFlag( "isSaftyArea01" ) == true ) then
		if (TppMission.GetFlag( "isDemoRelativePlay" ) == false) then
			-- chenge position to safe space
			Fox.Log(":: Not in relative play area ::")
			Fox.Log(" check position near 10 or 15")
			-- どの相対位置が近いか確認
			local player = Ch.FindCharacterObjectByCharacterId( "Player" )
			local playerPos = player:GetPosition()
			local point10 = TppData.GetPosition( "warp_demo_seaside10" )
			-- 距離を計算
			local checkPto10 = TppUtility.FindDistance( playerPos, point10 )
			Fox.Log ( "dist = "..checkPto10)

			-- 距離から洞窟内からどうか判定
			if ( checkPto10 < this.demoSeaSideDist ) then
				-- 洞窟内なら　10
				Fox.Log("near point is 10")
				warpPlayer = "warp_demo_seaside10"
			else
				-- 洞窟外なので20
				Fox.Log("near point is 20")
				warpPlayer = "warp_demo_seaside20"
			end

		else
			Fox.Log(":: In relative play area ")
			warpPlayer = "notWarp"
		end

	else
		-- その場で再生
		return warpPlayer

	end

	return warpPlayer

end

--回収デモ前にプレイヤーをその場その向きで姿勢だけ変更 by yamamoto 0901
local commonTranrationPlayer = function(stand,r)
	local sisei = "Stand"
	if( stand ~= nul)then
		sisei = stand
	end

	-- 姿勢の変更
	TppPlayerUtility.RequestToStartTransition{stance=sisei,direction=r,doKeep = true}


end

--安全エリアに敵兵がいるかどうかチェック
local Check_SafetyArea_enemy = function(id,size)
	Fox.Log(":::: Check_SafetyArea_enemy ::::")
	local checkPos = TppData.GetPosition( id ) --delite this
	--local npcIds = TppNpcUtility.GetNpcByBoxShape( checkPos, size )

	local eneNum = 0
--[[
	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
				local type = TppNpcUtility.GetNpcType( id )
				if type == "Enemy" then
						-- 敵兵だった
						local status = TppEnemyUtility.GetLifeStatus( id )
						if (status =="Normal")then
							eneNum = eneNum + 1
					end
				end
		end
	end
--]]
	eneNum = TppEnemyUtility.GetNumberOfActiveSoldierByBoxShape( checkPos, size )

	Fox.Log( "enemy : "..eneNum )

	-- 洞窟内かどうか確認
	local player = Ch.FindCharacterObjectByCharacterId( "Player" )
	local playerPos = player:GetPosition()
	local point10 = TppData.GetPosition( "warp_demo_seaside10" )
	-- 距離を計算
	local checkPto10 = TppUtility.FindDistance( playerPos, point10 )
	Fox.Log ( "dist = "..checkPto10)

	-- 距離から洞窟内からどうか判定
	local n = 0
	if ( checkPto10 < this.demoSeaSideDist ) then
		-- 洞窟内なら　車両チェックの処理をスキップ
	else
		-- 洞窟外なので車両を確認
		Fox.Log("check vehicle")
		local pos = Vector3( 135, 5, 110 )
		local size = Vector3( 10, 10, 10 )					-- BOXサイズ
		local rot = Quat( 0.0, 0.0, 0.0, 0.0 )			-- BOX回転


		local vehicleIds = 0
		vehicleIds = TppVehicleUtility.GetVehicleByBoxShape( pos, size, rot )

		-- 指定BOX内にいる車両を数える
		if( vehicleIds and #vehicleIds.array > 0 ) then
			for i,id in ipairs( vehicleIds.array ) do
				n = n + 1
			end
		end
	end
	Fox.Log("vehicle : "..n )


	if( eneNum == 0 )then

		if( n == 0 )then
			return true
		else
			-- 車両がいるのでダメ
			return false
		end
	else
		-- 敵兵がいるのでダメ
		return false
	end

end

-- チコパスを降ろしたときの安全圏チェック
local Check_SafetyArea = function()
	Fox.Log(":: Check_SafetyArea ::")
	local check = false

	if( TppMission.GetFlag( "isSaftyArea01" ) == true )then
		check = Check_SafetyArea_enemy("eneCheck_seaside",eneCheckSize_seaside)
	end

	return ( check )
end

-- check to phase level and near enemy
local CheckDemoCondition = function()
	Fox.Log(":: CheckDemoCondition ::")
	local phase = TppEnemy.GetPhase( this.cpID )
	if ( phase == "alert" ) then
		Fox.Log(":: Ceheck Demo - Flase - "..phase)
		return false
	else
		if ( Check_SafetyArea() == true ) then
			Fox.Log(":: Ceheck Demo - True - "..phase)
			return true
		else
			return false
		end
	end

end


--扉のピッキングを無効かしておく　by yamamoto
-- → 不要にしました。by Sonoyama
local changeEnablePickingDoor = function( id, doing )
--[[
		Fox.Log( ":: change enable picking door ::" )
		local doorObj = Ch.FindCharacterObjectByCharacterId( id )
		if ( doorObj ~= nil ) then

			local door = doorObj:GetCharacter()

			if (doing == "lock") then
				Fox.Log( id.." is Look!! "..doing )
				door:SendMessage( TppGadgetDoorSetPickingRequest{ isEnablePicking = false } )
			else
				Fox.Log( id.." is Unlook!! "..doing )
				door:SendMessage( TppGadgetDoorSetPickingRequest{ isEnablePicking = true } )
			end
		else
			Fox.Log(":: !! Error doorObj is nil :: changeEnablePickingDoor ::")
		end
--]]
end

local Demo_eneChecker = function( flag ) -- yamamoto
	-- デモ再生付近に敵兵がいないかチェック　いたらドアをピッキング不能にする
	-- 引数でチコのチェックorパスのチェックを分けている

	Fox.Log(":: enemy checker around player ::")
	local enemyNum = 0
	local phase = TppEnemy.GetPhase( cpID )
	local radioDaemon = RadioDaemon:GetInstance()

	Fox.Log(phase)

	if ( phase == "alert") then --一時的に evasion を抜く 1004
		-- そもそもアラートだったら処理しない　無線流して返す
		TppRadio.Play( "Miller_MeetChicoPazInCombat" )
		TppMission.SetFlag( "isAlertCageCheck", true )
		Fox.Log(":: phase is alert ::")
	else

		if ( flag == "chico") then
			-- chico ene check
			enemyNum = TppEnemyUtility.GetNumberOfActiveSoldierByBoxShape( Vector3(69, 20, 204), this.eneCheckSize_chico )
			Fox.Log( enemyNum)

			if ( enemyNum >= 1 ) then
				changeEnablePickingDoor( "AsyPickingDoor24", "lock" )
				TppRadio.Play( "Miller_MeetChicoPazNearEnemy" )
			else
				changeEnablePickingDoor( "AsyPickingDoor24", "unlock" )
				if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1022") == true ) then
					TppRadio.Play( "Miller_UlMeetChicoPazNearEnemy" )
				end
			end

		else
			-- paz ene check
			-- memo eneCheck_paz
			enemyNum = TppEnemyUtility.GetNumberOfActiveSoldierByBoxShape( Vector3(-138, 24, -16), eneCheckSize_paz )
			Fox.Log( enemyNum)

			if ( enemyNum >= 1 ) then
				changeEnablePickingDoor( "Paz_PickingDoor00", "lock" )
				TppRadio.Play( "Miller_MeetChicoPazNearEnemy" )
			else
				changeEnablePickingDoor( "Paz_PickingDoor00", "unlock" )
				if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1022") == true ) then
					TppRadio.Play( "Miller_UlMeetChicoPazNearEnemy" )
				end
			end

		end
	end
end

local Demo_hosChecker = function()-- by yamamoto 0825
-- 捕虜が檻にいるか確認してチコに会うデモを分岐させる
	--①　ユニーク捕虜が生きているかどうか
	--②　ユニーク捕虜がいるかどうか
	--③　他の捕虜がいるかどうか
	Fox.Log(":: Demo_shoChecker ::")
	local hosNum = 0

	-- ③　他の捕虜がいるかどうか
	local checkPos = TppData.GetPosition( "hosCheck_chico" ) --delite this
	local npcIds = TppNpcUtility.GetNpcByBoxShape( checkPos, this.hostageOtherCheckSize )
	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				-- キャラクターIDを取得
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )

				if( characterId ~="Chico" and characterId ~="Paz" )then
					-- チコはカウントしない
					-- 捕虜が生きているか確認　生きているものをカウント
					local status = TppHostageUtility.GetStatus( characterId )
					if status == "Normal" then
						-- 通常状態
						hosNum = hosNum + 1
					end
				end
			end
		end
	end

	-- 捕虜が一人もいなければ０を返す
	if ( hosNum == 0 ) then
		Fox.Log("No hostage")
		return 0
	else

		------ 捕虜はまだいる ------
		-- ①　ユニーク捕虜がいきているかどうか
		if TppMission.GetFlag( "isHostageUnusual" ) then
			-- 他の捕虜がいた
			Fox.Log("hostage is gone, but other one is there")
			return 1
		else
		-- ②　ユニーク捕虜が檻の中にいるかどうか
			Fox.Log("uniq hostage is OK")

			-- ユニーク捕虜がいるのかチェック
			hosNum = 0
			local checkPos = TppData.GetPosition( "eneCheck_chico_hos" )
			local npcIds = TppNpcUtility.GetNpcByBoxShape( checkPos, this.hostageCheckSize )
			if npcIds and #npcIds.array > 0 then
				for i,id in ipairs(npcIds.array) do
					local type = TppNpcUtility.GetNpcType( id )
					if type == "Hostage" then
						-- キャラクターIDを取得
						local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
						if( characterId =="Hostage_e20010_001" or characterId =="Hostage_e20010_002")then
							hosNum = hosNum + 1
						end
					end
				end
			end

			-- 判定結果を見て返り値をだす
			Fox.Log( "Uniq hostage num = "..hosNum )
			if (hosNum >= 2) then
				-- 演技捕虜が檻の中に2人いた
				Fox.Log("hostage is inside")
				return 2
			else
				-- 演技捕虜が檻の中にいない
				Fox.Log("hostage is outside")
				return 1
			end
		end
	end
end

local ChengeChicoPazIdleMotion = function()
	Fox.Log(":: ChengeChicoPazIdleMotion ::")
	-- パスに会う前は繋がれているモーションにしておく by yamamoto
	if ( TppMission.GetFlag( "isEncounterPaz" ) == false ) then
		Fox.Log(": Special Idle - Paz - true")
		TppHostageManager.GsSetSpecialIdleFlag( "Paz", true )
	else
		Fox.Log(": Special Idle - Paz - false")
		TppHostageManager.GsSetSpecialIdleFlag( "Paz", false )
	end

	if( TppMission.GetFlag( "isQuestionChico" ) == true ) then			--チコの回収デモ後　通常
		Fox.Log(": Special Faint - Chico - false")
		Fox.Log(": Special Idle - Chico - false")
		TppHostageManager.GsSetSpecialFaintFlag( "Chico", false )
		TppHostageManager.GsSetSpecialIdleFlag( "Chico", false )
	else
		if ( TppMission.GetFlag( "isEncounterChico" ) == false ) then 	-- チコに会う前　座ったまま
			Fox.Log(": Special Idle - Chico - true")
			TppHostageManager.GsSetSpecialIdleFlag( "Chico", true )
		else
			Fox.Log(": Special Faint - Chico - true")
			Fox.Log(": Special Idle - Chico - false")
			TppHostageManager.GsSetSpecialIdleFlag( "Chico", false )
			TppHostageManager.GsSetSpecialFaintFlag( "Chico", true )	--　チコにあった後　気絶したまま
		end
	end
end

-- ごろごろワッペン
local DropXOFCrawRoling = function()
	-- 一定数ころがったらワッペンを落とす
	local rolling = TppData.GetArgument( 1 )
	local result = TppStorage.HasXOFEmblem(9)
	Fox.Log( "rolling "..rolling )
	Fox.Log("Emblem have : "..result )

	if( rolling == 10 and result == 0 and TppMission.GetFlag( "isWappenDemo" ) == false)then
		Fox.Log(":: XOF Emblem Dorop !! craw rolling")

		local onDemoEnd = function()
			TppMission.SetFlag( "isWappenDemo", true )
			-- ワッペンを出す
			local player = TppPlayerUtility.GetLocalPlayerCharacter()
			local pos = player:GetPosition()

			local vel = player:GetRotation():Rotate( Vector3( -1.5, 1.5, 0) )

			local offset = player:GetRotation():Rotate( Vector3( 0.0, 0, 0) )
			TppNewCollectibleUtility.DropItem{ id = "IT_XOFEmblem", index = 9, pos = pos+offset, rot = Quat.RotationY(1.5), vel = vel, rotVel = Vector3(0,2,0) }
			--GZCommon.DromItemFromPlayer( "IT_XOFEmblem", 9 )
			--スネークのXOFMeshをOFFにする
			TppCharacterUtility.SetMeshVisible("Player","MESH_XOF_IV",false)
			--パス脱獄がばれている状態チェック
			Common_RetryKeepCautionSiren()
			-- ミッション圏外付近でデモ発動した際にデモ終了後、強制的にミッション圏外扱いにする
			MissionArea_PcWarp()
		end
		TppDemo.Play( "Demo_XOFrolling" , {onEnd = onDemoEnd })

	end
end

local RegisterRadioCondition = function()
	TppRadioConditionManagerAccessor.Register(
												"Tutorial", 				-- 登録コンポーネント名
												TppRadioConditionTutorialPlayer{
														time = 1.5, 	-- 更新のInterval時間（秒）→頻繁にチェックする必要なかったら出来れば増やして下さい
														descMessage = {
																		-- RadioConditionManagerのメッセージボックスに送るメッセージ、Desc内容
																		"PlayerBehind", "Behind",
																		"PlayerBinocle", "BinocleHold",
																		"PlayerRecovering", "Recovering",
																		"PlayerElude", "Elude",
																		"PlayerCrawl", "Crawl"
														},
												}
										)

	TppRadioConditionManagerAccessor.Register( "Basic", TppRadioConditionPlayerBasic{ time = 0.3 } )
end

-- マップアイコンテキスト
local MapIconText = function()

		local commonDataManager = UiCommonDataManager.GetInstance()
		if commonDataManager == NULL then
				return
		end

		local luaData = commonDataManager:GetUiLuaExportCommonData()
		if luaData == NULL then
				return
		end

		luaData:SetupIconUniqueInformationTable(
				--最終目的地:3
				{ markerId="20010_marker_Chico",				langId="marker_info_mission_targetArea" }		--ターゲット予測範囲
				,{ markerId="20010_marker_ChicoPinpoint",		langId="marker_info_chico" }					--チコ
				,{ markerId="20010_marker_Paz",					langId="marker_info_mission_targetArea" }		--ターゲット予測範囲
				--キャラクター:3
				,{ markerId="Chico",							langId="marker_info_chico" }					--チコ
				,{ markerId="Paz",								langId="marker_info_paz" }						--パス
				,{ markerId="SpHostage",						langId="marker_info_hostage_esc" }				--脱走捕虜
				--四輪駆動車:3
				,{ markerId="Tactical_Vehicle_WEST_002",		langId="marker_info_vehicle_4wd" }
				,{ markerId="Tactical_Vehicle_WEST_003",		langId="marker_info_vehicle_4wd" }
				,{ markerId="Tactical_Vehicle_WEST_004",		langId="marker_info_vehicle_4wd" }
				,{ markerId="Tactical_Vehicle_WEST_005",		langId="marker_info_vehicle_4wd" }
				--トラック:3
				,{ markerId="Cargo_Truck_WEST_002",				langId="marker_info_truck" }
				,{ markerId="Cargo_Truck_WEST_003",				langId="marker_info_truck" }
				,{ markerId="Cargo_Truck_WEST_004",				langId="marker_info_truck" }
				--機銃装甲車:3
				,{ markerId="Armored_Vehicle_WEST_001",			langId="marker_info_APC" }
				,{ markerId="Armored_Vehicle_WEST_002",			langId="marker_info_APC" }
				,{ markerId="Armored_Vehicle_WEST_003",			langId="marker_info_APC" }
				--場所:13
				,{ markerId="20010_marker_RV",					langId="marker_info_RV" }						--ランデブーポイント
				,{ markerId="e20010_marker_PowerSupply",		langId="marker_info_place_00" }					--配電盤
				,{ markerId="Marker_Duct",						langId="marker_info_place_01" }					--排水溝
				,{ markerId="e20010_marker_Kill",				langId="marker_info_place_03" }					--脱走捕虜処刑エリア
				,{ markerId="common_marker_Armory_WareHouse",	langId="marker_info_place_armory" }				--武器庫
				,{ markerId="common_marker_Armory_HeliPort",	langId="marker_info_place_armory" }				--武器庫
				,{ markerId="common_marker_Armory_Center",		langId="marker_info_place_armory" }				--武器庫
				,{ markerId="common_marker_Area_EastCamp",		langId="marker_info_area_00" }					--東難民キャンプ区画
				,{ markerId="common_marker_Area_WestCamp",		langId="marker_info_area_01" }					--西難民キャンプ区画
				,{ markerId="common_marker_Area_WareHouse",		langId="marker_info_area_02" }					--倉庫区画
				,{ markerId="common_marker_Area_HeliPort",		langId="marker_info_area_03" }					--ヘリ発着場
				,{ markerId="common_marker_Area_Center",		langId="marker_info_area_04" }					--管理棟
				,{ markerId="common_marker_Area_Asylum",		langId="marker_info_area_05" }					--旧収容区画
				--弾薬:5
				,{ markerId="e20010_marker_Ammo01",				langId="marker_info_bullet_tranq" }				--弾薬（非殺傷弾）
				,{ markerId="e20010_marker_Ammo02",				langId="marker_info_bullet_tranq" }				--弾薬（非殺傷弾）
				,{ markerId="e20010_marker_Ammo03",				langId="marker_info_bullet_tranq" }				--弾薬（非殺傷弾）
				,{ markerId="e20010_marker_Ammo04",				langId="marker_info_bullet_tranq" }				--弾薬（非殺傷弾）
				,{ markerId="e20010_marker_Ammo05",				langId="marker_info_bullet_tranq" }				--弾薬（非殺傷弾）
--				,{ markerId="e20010_marker_SubAmmo01",			langId="marker_info_bullet_artillery" }			--砲弾
--				,{ markerId="e20010_marker_SubAmmo02",			langId="marker_info_bullet_artillery" }			--砲弾
				--武器:3
--				,{ markerId="e20010_marker_HundGun",			langId="marker_info_weapon_00" }				--ハンドガン
				,{ markerId="e20010_marker_SniperRifle",		langId="marker_info_weapon_01" }				--スナイパーライフル
--				,{ markerId="e20010_marker_RecoillessRifle",	langId="marker_info_weapon_02" }				--無反動砲
				,{ markerId="e20010_marker_ShotGun",			langId="marker_info_weapon_03" }				--ショットガン
--				,{ markerId="e20010_marker_SubMachineGun",		langId="marker_info_weapon_04" }				--サブマシンガン
--				,{ markerId="e20010_marker_SmokeGrenade",		langId="marker_info_weapon_05" }				--スモークグレネード
--				,{ markerId="e20010_marker_C4",					langId="marker_info_weapon_06" }				--Ｃ４
				,{ markerId="e20010_marker_Grenade",			langId="marker_info_weapon_07" }				--グレネード
--				,{ markerId="e20010_marker_DirectionalMines",	langId="marker_info_weapon_08" }				--クレイモア
				--アイテム:6
				,{ markerId="e20010_marker_Cassette",			langId="marker_info_item_tape" }				--カセットテープ
				,{ markerId="Marker_Cassette",					langId="marker_info_item_tape" }				--カセットテープ
				,{ markerId="Marker_XOF",						langId="marker_info_item_xof" }					--ＸＯＦマーク（通常捕虜救出用）
				,{ markerId="e20010_marker_Patch01",			langId="marker_info_item_xof" }					--ＸＯＦマーク（尋問用）
				,{ markerId="e20010_marker_Patch02",			langId="marker_info_item_xof" }					--ＸＯＦマーク（尋問用）
				,{ markerId="e20010_marker_Patch03",			langId="marker_info_item_xof" }					--ＸＯＦマーク（尋問用）
				,{ markerId="e20010_marker_Patch04",			langId="marker_info_item_xof" }					--ＸＯＦマーク（尋問用）
		)
end
--Seq_RescueHostages_RouteSetの詳細設定
local Setting_Seq_RescueHostages_RouteSet = function()

	local sequence = TppSequence.GetCurrentSequence()

	if ( sequence == "Seq_MissionLoad" ) then
		--何もしない
	else
	end
	--シーケンス開始時有効無効ルート
	--無効
	TppEnemy.DisableRoute( this.cpID , "Seq10_02_RideOnVehicle" )
	TppEnemy.DisableRoute( this.cpID , "S_GoToExWeaponTruck" )
	TppEnemy.DisableRoute( this.cpID , "S_GoTo_EastCamp" )
	TppEnemy.DisableRoute( this.cpID , "S_Sen_EastCamp_SouthLeftGate" )
	TppEnemy.DisableRoute( this.cpID , "S_Pat_WestCampOutLine" )
	TppEnemy.DisableRoute( this.cpID , "S_RainTalk_ComEne05" )
	TppEnemy.DisableRoute( this.cpID , "S_GoTo_SeaSideEnter" )
	TppEnemy.DisableRoute( this.cpID , "S_GoTo_EastCampNorthTower" )
	TppEnemy.DisableRoute( this.cpID , "S_Sen_SeaSideEnter" )
	TppEnemy.DisableRoute( this.cpID , "S_SL_EastCamp_North" )
	TppEnemy.DisableRoute( this.cpID , "S_SL_EastCamp_South_in" )
	TppEnemy.DisableRoute( this.cpID , "S_Seq10_03_RideOnTruck" )
	TppEnemy.DisableRoute( this.cpID , "S_GunTutorial_Route" )
	TppEnemy.DisableRoute( this.cpID , "S_Sen_AsylumBehind" )
	TppEnemy.DisableRoute( this.cpID , "S_GoToSearchEscapeHostage_a" )
	TppEnemy.DisableRoute( this.cpID , "S_GoToSearchEscapeHostage_b" )
	TppEnemy.DisableRoute( this.cpID , "S_Pat_AsylumInside_Ver02" )
	TppEnemy.DisableRoute( this.cpID , "S_Pat_AsylumInside_Ver03" )
	TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_go" )
	TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_back" )
	TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate01" )
	TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate02" )
	TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_d" )
	TppEnemy.DisableRoute( this.cpID , "S_Ret_Center_d" )
	TppEnemy.DisableRoute( this.cpID , "S_Mov_Smoking_Center" )
	TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_2Fto1F" )
	TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_e" )
	TppEnemy.DisableRoute( this.cpID , "S_Mov_CenterHouse_a" )
	TppEnemy.DisableRoute( this.cpID , "S_Mov_CenterHouse_b" )
	TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_a" )
	TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_b" )
	TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret01_Route" )
	TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret02_Route" )
	TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret03_Route" )
	TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret04_Route" )
	TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret05_Route" )
	TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL01_Route" )
	TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL02_Route" )
	TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL04_Route" )
	TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL05_Route" )
	TppEnemy.DisableRoute( this.cpID , "Break_CenterTower_Route" )
	TppEnemy.DisableRoute( this.cpID , "S_Talk_ChicoTape" )
	TppEnemy.DisableRoute( this.cpID , "S_Talk_EscapeHostage" )
	TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage01" )
	TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage02" )
	TppEnemy.DisableRoute( this.cpID , "GoToWestCamp_TalkWeapon" )
	TppEnemy.DisableRoute( this.cpID , "S_Mov_CenterHouse_a2" )
	TppEnemy.DisableRoute( this.cpID , "S_Mov_CenterHouse_b2" )
	TppEnemy.DisableRoute( this.cpID , "ComEne21_TalkRoute" )
	TppEnemy.DisableRoute( this.cpID , "S_Seeing_Sea" )
	TppEnemy.DisableRoute( this.cpID , "Seq10_01_VehicleFailed_Route" )
	TppEnemy.DisableRoute( this.cpID , "Seq10_02_VehicleFailed_Route" )
	-- 停電用ルート
	TppEnemy.DisableRoute( this.cpID , "ComEne25_SwitchOFF" )
	TppEnemy.DisableRoute( this.cpID , "ComEne26_SwitchOFF" )
	TppEnemy.DisableRoute( this.cpID , "ComEne27_SwitchOFF" )
	TppEnemy.DisableRoute( this.cpID , "ComEne28_SwitchOFF" )
	TppEnemy.DisableRoute( this.cpID , "ComEne29_SwitchOFF" )
	TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF" )
	--敵兵専用ルート設定
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_ExWeaponTalk_a" , -1 , "ComEne01" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_SL_WestCamp" , -1 , "ComEne02" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_ExWeaponTalk_b" , -1 , "ComEne03" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_SL_WareHouse01a" , -1 , "ComEne04" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_RainTalk_a" , -1 , "ComEne05" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_RainTalk_b" , -1 , "ComEne06" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_WareHouseBehind" , -1 , "ComEne07" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_GunTitorial_Waiting" , -1 , "ComEne08" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pat_AsylumInside_Ver01" , -1 , "ComEne09" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_AsylumOutSideGate_a" , -1 , "ComEne10" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_EastCamp_NorthLeftGate" , -1 , "ComEne11" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_WareHouse_NorthGate" , -1 , "ComEne12" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_EscapeHostageTalk_a" , -1 , "ComEne13" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_EscapeHostageTalk_b" , -1 , "ComEne14" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_HeliPortFrontGate_a" , -1 , "ComEne15" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_HeliPortFrontGate_b" , -1 , "ComEne16" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_Bridge" , -1 , "ComEne17" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_HeliPortBehind_a" , -1 , "ComEne18" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_HeliPortBehind_b" , -1 , "ComEne19" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_HeliPortYard" , -1 , "ComEne20" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_HeliPortCenter_a" , -1 , "ComEne21" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_HeliPortCenter_b" , -1 , "ComEne22" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_BigGate_a" , -1 , "ComEne23" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_BigGate_b" , -1 , "ComEne24" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_Center_d" , -1 , "ComEne25" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_Center_a" , -1 , "ComEne26" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_BoilarFront" , -1 , "ComEne27" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_Center_b" , -1 , "ComEne28" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_Center_c" , -1 , "ComEne29" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Search_Xof" , -1 , "ComEne30" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_ChikcoTapeTalk_c" , -1 , "ComEne31" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_ChikcoTapeTalk_d" , -1 , "ComEne32" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_SL_EastCamp_South" , -1 , "ComEne33" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_SL_HeliPortTower" , -1 , "ComEne34" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_WestCamp_WestGate2" , -1 , "Seq10_01" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Sen_EastCampCenter_East" , -1 , "Seq10_02" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_TruckWaiting" , -1 , "Seq10_03" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_SL_StartCliff" , -1 , "Seq10_05" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_ChikcoTapeTalk_a" , -1 , "Seq10_06" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq10_SneakRouteSet" , "S_Pre_ChikcoTapeTalk_b" , -1 , "Seq10_07" , "ROUTE_PRIORITY_TYPE_FORCED" )
end
-- シーケンス別強制リアライズ設定
local Setting_RealizeEnable = function()

	local sequence = TppSequence.GetCurrentSequence()

	if ( sequence == "Seq_RescueHostages" ) then
		-- 有効
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_01" , true )
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_02" , true )
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_03" , true )
	elseif ( sequence == "Seq_NextRescuePaz" ) then
		-- 有効
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq20_02" , true )
		-- 無効
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_01" , false )
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_02" , false )
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_03" , false )
	elseif ( sequence == "Seq_NextRescueChico" ) or ( sequence == "Seq_PazChicoToRV" ) then
		-- 有効
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq40_03" , true )
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq40_04" , true )
		-- 無効
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_01" , false )
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_02" , false )
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_03" , false )
	elseif ( sequence == "Seq_ChicoPazToRV" ) then
		-- 有効
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq30_05" , true )
		-- 無効
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq20_02" , false )
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_01" , false )
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_02" , false )
		TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_03" , false )
	else	-- Seq_PlayerOnHeli or Seq_PlayerOnHeliAfter
		if( TppMission.GetFlag( "isFirstEncount_Chico" ) == true ) then
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq30_05" , true )
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq20_02" , false )
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_01" , false )
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_02" , false )
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_03" , false )
		else
			-- 有効
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq40_03" , true )
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq40_04" , true )
			-- 無効
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_01" , false )
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_02" , false )
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_03" , false )
		end
	end
end
---------------------------------------------------------------------------------
--任意無線設定
---------------------------------------------------------------------------------
local SetOptionalRadio = function()
	local sequence = TppSequence.GetCurrentSequence()
	local radioDaemon = RadioDaemon:GetInstance()
	Fox.Log("================== SetOptionalRadio ======================")

	--シーケンスチェック
	if ( sequence == "Seq_RescueHostages" ) then
	--		TppRadio.RegisterOptionalRadio( "Optional_InOldAsylum" )			--0011トラップ判定なのでここでは選ばない
--		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0180") == true ) then
--			Fox.Log("================== 1-1 ======================")
--			TppRadio.RegisterOptionalRadio( "Optional_DiscoveryPaz" )			--0025
--		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_esrg0080") == true ) then
--			Fox.Log("================== 1-2 ======================")
--			TppRadio.RegisterOptionalRadio( "Optional_DiscoveryChico" )			--0012
--		else
--			Fox.Log("================== 1-3 ======================")
			TppRadio.RegisterOptionalRadio( "Optional_GameStartToRescue" )		--0010
--		end

	elseif ( sequence == "Seq_NextRescuePaz" ) then
	--		TppRadio.RegisterOptionalRadio( "Optional_DiscoveryPaz" )			--0025トラップ判定なのでここでは選ばない
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1260") == true ) then
			TppRadio.RegisterOptionalRadio( "Optional_ChicoOnHeli" )			--0021

		elseif( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) then
--			Fox.Log("================== 2-1 ======================")
			TppRadio.RegisterOptionalRadio( "Optional_RVChicoToRescuePaz" )		--0020

		elseif( TppMission.GetFlag( "isQuestionChico" ) == true ) then
--			Fox.Log("================== 2-2 ======================")
			TppRadio.RegisterOptionalRadio( "Optional_RideHeliPaz" )			--0042 チコをヘリに乗せるんだ

--		elseif( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0083") == true ) then
--			Fox.Log("================== 2-3 ======================")
--			TppRadio.RegisterOptionalRadio( "Optional_OnRVChico" )				--0019
		else
--			Fox.Log("================== 2-4 ======================")
			TppRadio.RegisterOptionalRadio( "Optional_RescueChicoToRVChico" )	--0015
		end

	elseif ( sequence == "Seq_NextRescueChico" ) then
	--		TppRadio.RegisterOptionalRadio( "Optional_InOldAsylum" )			--0011トラップ判定なのでここでは選ばない
--		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_esrg0070") == true or radioDaemon:IsRadioGroupMarkAsRead("e0010_esrg0080") == true ) then
--			Fox.Log("================== 3-1 ======================")
--			TppRadio.RegisterOptionalRadio( "Optional_DiscoveryChico" )			--0012
		if( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then
--			Fox.Log("================== 3-2 ======================")
			TppRadio.RegisterOptionalRadio( "Optional_RescuePazToRescueChico" )	--0030
		elseif( TppMission.GetFlag( "isQuestionPaz" ) == true ) then
--			Fox.Log("================== 3-3 ======================")
			TppRadio.RegisterOptionalRadio( "Optional_DiscoveryPaz" )			--0025
		else
--			Fox.Log("================== 3-4 ======================")
			TppRadio.RegisterOptionalRadio( "Optional_RescuePazToRVPaz" )		--0029
		end

	elseif ( sequence == "Seq_ChicoPazToRV" or sequence == "Seq_PazChicoToRV" ) then
		if( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then
--			Fox.Log("================== 4-1 ======================")
			TppRadio.RegisterOptionalRadio( "Optional_RideHeliPaz" )			--0042
		elseif( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) then
--			Fox.Log("================== 4-2 ======================")
			TppRadio.RegisterOptionalRadio( "Optional_RideHeliChico" )			--0041
		else
--			Fox.Log("================== 4-3 ======================")
			TppRadio.RegisterOptionalRadio( "Optional_RescueBothToRideHeli" )	--0040
		end

	elseif ( sequence == "Seq_PlayerOnHeli" ) then
--			Fox.Log("================== 5-1 ======================")
		TppRadio.RegisterOptionalRadio( "Optional_RescueComplete" )			--0043
	else
--			Fox.Log("================== anknown sequence ======================")
	end
end

---------------------------------------------------------------------------------
--諜報無線設定(シーケンス開始時)
---------------------------------------------------------------------------------
local SetIntelRadio = function()
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log("================== SetIntelRadio ====================== " .. sequence)

	--全シーケンスで設定するもの
	this.Check_SetIntelRadio( "ComEne01", "enemy" )
	this.Check_SetIntelRadio( "ComEne02", "enemy" )
	this.Check_SetIntelRadio( "ComEne03", "enemy" )
	this.Check_SetIntelRadio( "ComEne04", "enemy" )
	this.Check_SetIntelRadio( "ComEne05", "enemy" )
	this.Check_SetIntelRadio( "ComEne06", "enemy" )
	this.Check_SetIntelRadio( "ComEne07", "enemy" )
	this.Check_SetIntelRadio( "ComEne08", "enemy" )
	this.Check_SetIntelRadio( "ComEne09", "enemy" )
	this.Check_SetIntelRadio( "ComEne10", "enemy" )
	this.Check_SetIntelRadio( "ComEne11", "enemy" )
	this.Check_SetIntelRadio( "ComEne12", "enemy" )
	this.Check_SetIntelRadio( "ComEne13", "enemy" )
	this.Check_SetIntelRadio( "ComEne14", "enemy" )
	this.Check_SetIntelRadio( "ComEne15", "enemy" )
	this.Check_SetIntelRadio( "ComEne16", "enemy" )
	this.Check_SetIntelRadio( "ComEne17", "enemy" )
	this.Check_SetIntelRadio( "ComEne18", "enemy" )
	this.Check_SetIntelRadio( "ComEne19", "enemy" )
	this.Check_SetIntelRadio( "ComEne20", "enemy" )
	this.Check_SetIntelRadio( "ComEne21", "enemy" )
	this.Check_SetIntelRadio( "ComEne22", "enemy" )
	this.Check_SetIntelRadio( "ComEne23", "enemy" )
	this.Check_SetIntelRadio( "ComEne24", "enemy" )
	this.Check_SetIntelRadio( "ComEne25", "enemy" )
	this.Check_SetIntelRadio( "ComEne26", "enemy" )
	this.Check_SetIntelRadio( "ComEne27", "enemy" )
	this.Check_SetIntelRadio( "ComEne28", "enemy" )
	this.Check_SetIntelRadio( "ComEne29", "enemy" )
	this.Check_SetIntelRadio( "ComEne30", "enemy" )
	this.Check_SetIntelRadio( "ComEne31", "enemy" )
	this.Check_SetIntelRadio( "ComEne32", "enemy" )
	this.Check_SetIntelRadio( "ComEne33", "enemy" )
	this.Check_SetIntelRadio( "ComEne34", "enemy" )
	this.Check_SetIntelRadio( "Seq10_01", "enemy" )
	this.Check_SetIntelRadio( "Seq10_02", "enemy" )
	this.Check_SetIntelRadio( "Seq10_03", "enemy" )
	this.Check_SetIntelRadio( "Seq10_05", "enemy" )
	this.Check_SetIntelRadio( "Seq10_06", "enemy" )
	this.Check_SetIntelRadio( "Seq10_07", "enemy" )

	this.Check_SetIntelRadio( "SpHostage", "hostage" )
	this.Check_SetIntelRadio( "Chico", "hostage" )
	this.Check_SetIntelRadio( "Paz", "hostage" )

	this.Check_SetIntelRadio( "WoodTurret01", "gimmick" )
	this.Check_SetIntelRadio( "WoodTurret02", "gimmick" )
	this.Check_SetIntelRadio( "WoodTurret03", "gimmick" )
	this.Check_SetIntelRadio( "WoodTurret04", "gimmick" )
	this.Check_SetIntelRadio( "WoodTurret05", "gimmick" )
	this.Check_SetIntelRadio( "gntn_area01_antiAirGun_000", "gimmick" )
	this.Check_SetIntelRadio( "gntn_area01_antiAirGun_001", "gimmick" )
	this.Check_SetIntelRadio( "gntn_area01_antiAirGun_002", "gimmick" )
	this.Check_SetIntelRadio( "gntn_area01_antiAirGun_003", "gimmick" )
--	this.Check_SetIntelRadio( "Tactical_Vehicle_WEST_001", "gimmick" )
	this.Check_SetIntelRadio( "Tactical_Vehicle_WEST_002", "gimmick" )
	this.Check_SetIntelRadio( "Tactical_Vehicle_WEST_003", "gimmick" )
	this.Check_SetIntelRadio( "Tactical_Vehicle_WEST_004", "gimmick" )
	this.Check_SetIntelRadio( "Tactical_Vehicle_WEST_005", "gimmick" )
	this.Check_SetIntelRadio( "Cargo_Truck_WEST_002", "gimmick" )
	this.Check_SetIntelRadio( "Cargo_Truck_WEST_003", "gimmick" )
	this.Check_SetIntelRadio( "Cargo_Truck_WEST_004", "gimmick" )
	this.Check_SetIntelRadio( "Armored_Vehicle_WEST_001", "gimmick" )
	this.Check_SetIntelRadio( "Armored_Vehicle_WEST_002", "gimmick" )
	this.Check_SetIntelRadio( "Armored_Vehicle_WEST_003", "gimmick" )
	this.Check_SetIntelRadio( "SL_WoodTurret01", "gimmick" )
	this.Check_SetIntelRadio( "SL_WoodTurret02", "gimmick" )
	this.Check_SetIntelRadio( "SL_WoodTurret03", "gimmick" )
	this.Check_SetIntelRadio( "SL_WoodTurret04", "gimmick" )
	this.Check_SetIntelRadio( "SL_WoodTurret05", "gimmick" )
	this.Check_SetIntelRadio( "gntn_area01_searchLight_000", "gimmick" )
	this.Check_SetIntelRadio( "gntn_area01_searchLight_001", "gimmick" )
	this.Check_SetIntelRadio( "gntn_area01_searchLight_002", "gimmick" )
	this.Check_SetIntelRadio( "gntn_area01_searchLight_003", "gimmick" )
	this.Check_SetIntelRadio( "gntn_area01_searchLight_004", "gimmick" )
	this.Check_SetIntelRadio( "gntn_area01_searchLight_005", "gimmick" )
	this.Check_SetIntelRadio( "gntn_area01_searchLight_006", "gimmick" )
	this.Check_SetIntelRadio( "e20010_drum0025", "gimmick" )
	this.Check_SetIntelRadio( "e20010_drum0027", "gimmick" )
	this.Check_SetIntelRadio( "e20010_drum0040", "gimmick" )
	this.Check_SetIntelRadio( "e20010_drum0042", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0002", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0005", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0011", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0012", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0015", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0019", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0020", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0021", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0022", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0023", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0024", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0025", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0027", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0028", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0029", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0030", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0031", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0035", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0037", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0038", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0039", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0040", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0041", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0042", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0043", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0044", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0045", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0046", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0047", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0048", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0065", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0066", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0068", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0069", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0070", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0071", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0072", "gimmick" )
	this.Check_SetIntelRadio( "gntnCom_drum0101", "gimmick" )
	this.Check_SetIntelRadio( "e20010_SecurityCamera_01", "gimmick" )
	this.Check_SetIntelRadio( "e20010_SecurityCamera_02", "gimmick" )
	this.Check_SetIntelRadio( "e20010_SecurityCamera_03", "gimmick" )
	this.Check_SetIntelRadio( "e20010_SecurityCamera_04", "gimmick" )

	TppRadio.EnableIntelRadio( "intel_e0010_esrg0020" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0030" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0040" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0090" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0110" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0120" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0190" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0380" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0440" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0440_1" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0450" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0450_1" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0450_2" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0480" )
	TppRadio.EnableIntelRadio( "intel_e0010_esrg0490" )

	-- 初期設定
	TppRadio.RegisterIntelRadio( "Chico", "e0010_esrg0080", true )
	TppRadio.RegisterIntelRadio( "Paz", "e0010_esrg0100", true )
	TppRadio.RegisterIntelRadio( "intel_e0010_esrg0040", "e0010_esrg0040", true )
	TppRadio.RegisterIntelRadio( "intel_e0010_esrg0090", "e0010_esrg0090", true )
	TppRadio.RegisterIntelRadio( "intel_e0010_esrg0120", "e0010_esrg0120", true )
	TppRadio.RegisterIntelRadio( "SL_WoodTurret05", "e0010_esrg0460", true )
	TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_002", "e0010_esrg0210", true )
	TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_003", "e0010_esrg0210", true )
	TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_004", "e0010_esrg0210", true )
	TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_005", "e0010_esrg0210", true )

	--シーケンス毎に設定するもの
	if ( sequence == "Seq_RescueHostages" ) then
		--変更
		TppRadio.RegisterIntelRadio( "Chico", "e0010_esrg0080", true )
		TppRadio.RegisterIntelRadio( "SL_WoodTurret05", "e0010_esrg0460", true )

	elseif ( sequence == "Seq_NextRescuePaz" ) then
		--変更
		TppRadio.RegisterIntelRadio( "intel_e0010_esrg0040", "e0010_esrg0060", true )
		TppRadio.RegisterIntelRadio( "Chico", "e0010_esrg0083", true )
		TppRadio.RegisterIntelRadio( "SL_WoodTurret05", "e0010_esrg0010", true )	--旧収容所のサーチライト
		--無効
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0090" )	--フェンスドア
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0120" )	--フェンス
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0380" )	--旧収容所物置

	elseif ( sequence == "Seq_NextRescueChico" ) then
		--変更
		TppRadio.RegisterIntelRadio( "intel_e0010_esrg0040", "e0010_esrg0050", true )
		TppRadio.RegisterIntelRadio( "Chico", "e0010_esrg0070", true )
		TppRadio.RegisterIntelRadio( "Paz", "e0010_esrg0104", true )
		--無効
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0090" )	--フェンスドア
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0120" )	--フェンス
--		TppRadio.DisableIntelRadio( "intel_e0010_esrg0380" )	--旧収容所物置
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0110" )	--管理棟について
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0190" )	--管理棟のゲートについて

	elseif ( sequence == "Seq_ChicoPazToRV" ) then
		--変更
		TppRadio.RegisterIntelRadio( "intel_e0010_esrg0040", "e0010_esrg0060", true )
		TppRadio.RegisterIntelRadio( "Chico", "e0010_esrg0083", true )
		TppRadio.RegisterIntelRadio( "Paz", "e0010_esrg0103" )
		TppRadio.RegisterIntelRadio( "SL_WoodTurret05", "e0010_esrg0010", true )	--旧収容所のサーチライト
--		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_001", "e0010_esrg0215", true )
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_002", "e0010_esrg0215", true )
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_003", "e0010_esrg0215", true )
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_004", "e0010_esrg0215", true )
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_005", "e0010_esrg0215", true )
		--無効
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0090" )	--フェンスドア
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0120" )	--フェンス
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0380" )	--旧収容所物置
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0110" )	--管理棟について
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0190" )	--管理棟のゲートについて

	elseif ( sequence == "Seq_PazChicoToRV" ) then
		--変更
		TppRadio.RegisterIntelRadio( "intel_e0010_esrg0040", "e0010_esrg0060", true )
		TppRadio.RegisterIntelRadio( "Chico", "e0010_esrg0083", true )
		TppRadio.RegisterIntelRadio( "Paz", "e0010_esrg0103" )
		TppRadio.RegisterIntelRadio( "SL_WoodTurret05", "e0010_esrg0010", true )	--旧収容所のサーチライト
--		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_001", "e0010_esrg0215", true )
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_002", "e0010_esrg0215", true )
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_003", "e0010_esrg0215", true )
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_004", "e0010_esrg0215", true )
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_005", "e0010_esrg0215", true )
		--無効
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0090" )	--フェンスドア
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0120" )	--フェンス
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0380" )	--旧収容所物置
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0110" )	--管理棟について
		TppRadio.DisableIntelRadio( "intel_e0010_esrg0190" )	--管理棟のゲートについて

	end

end

--チェックつき諜報無線有効化
this.Check_SetIntelRadio = function( characterID, type )

	--敵兵
	if( type == "enemy" ) then
		--双眼鏡で覗いたときに変更しているので無条件にON
		TppRadio.EnableIntelRadio( characterID )
	--捕虜
	elseif( type == "hostage" ) then
		local status = TppHostageUtility.GetStatus( characterID )

		--チコ
		if( characterID == "Chico" ) then
			if(TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) then
				TppRadio.DisableIntelRadio( characterID )
			else
				TppRadio.EnableIntelRadio( characterID )
			end
		--パス
		elseif( characterID == "Paz" ) then
			if(TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then
				TppRadio.DisableIntelRadio( characterID )
			else
				TppRadio.EnableIntelRadio( characterID )
			end
		else
			if (status =="Dead" ) then
			else
				TppRadio.EnableIntelRadio( characterID )
			end
		end

	--ギミック
	elseif( type == "gimmick" ) then
		TppRadio.EnableIntelRadio( characterID )
	end
end

---------------------------------------------------------------------------------
--タイマー
---------------------------------------------------------------------------------
local MissionStartTelopTimerStart = function()
	local timer = 0		-- 調整用で残す
	GkEventTimerManager.Start( "Timer_MissionStartTelop", timer )
end
-- ミッション開始タイマー終了時実行
local MissionStartTelop_ON = function()
		--ミッション開始テロップ
		local funcs = {
--			onStart = function() print( "Opening telop start!" ) end,
--			onEnd = function() TppSequence.ChangeSequence( "Seq_B" ) end,
		}
--		TppUI.FadeIn(0)
		TppUI.ShowTransitionInGame( "opening", funcs )
end
---------------------------------------------------------------------------------
--ルートセット管理
---------------------------------------------------------------------------------
--ゲーム開始～チコorパスに会うまで
local Seq_RescueHostages_RouteSet = function()
	local cpRouteSets = {
		{
			cpID = "gntn_cp",
			sets = {
				sneak_night = "e20010_Seq10_SneakRouteSet",
				caution_night = "e20010_Seq10_CautionRouteSet",
			},
		},
	}
	TppEnemy.SetRouteSets( cpRouteSets )
end
--ゲーム開始～チコorパスに会うまで（コンテニュー用）
local Seq_RescueHostages_RouteSet_Continue = function()
	local cpRouteSets = {
		{
			cpID = "gntn_cp",
			sets = {
				sneak_night = "e20010_Seq10_SneakRouteSet",
				caution_night = "e20010_Seq10_CautionRouteSet",
			},
		},
	}
	TppEnemy.SetRouteSets( cpRouteSets , { warpEnemy = true , forceUpdate = true } )
end
--１人目チコ～パスに会うまで
local Seq_NextRescuePaz_RouteSet = function()
	local cpRouteSets = {
		{
			cpID = "gntn_cp",
			sets = {
				sneak_night = "e20010_Seq20_SneakRouteSet",
				caution_night = "e20010_Seq20_CautionRouteSet",
			},
		},
	}
	TppEnemy.SetRouteSets( cpRouteSets , { warpEnemy = true , forceUpdate = true , forceReload = true , startAtZero = true } )
--	TppEnemy.SetRouteSets( cpRouteSets , { warpEnemy = true } )
end
--チコパスの順で助け、２人をＲＶに運ぶまで
local Seq_ChicoPazToRV_RouteSet = function()
	local cpRouteSets = {
		{
			cpID = "gntn_cp",
			sets = {
				sneak_night = "e20010_Seq30_SneakRouteSet",
				caution_night = "e20010_Seq30_CautionRouteSet",
			},
		},
	}
	TppEnemy.SetRouteSets( cpRouteSets , { warpEnemy = true } )
end
--１人目パス～チコに会うまで
local Seq_NextRescueChico_RouteSet = function()
	local cpRouteSets = {
		{
			cpID = "gntn_cp",
			sets = {
				sneak_night = "e20010_Seq40_SneakRouteSet",
				caution_night = "e20010_Seq40_CautionRouteSet",
			},
		},
	}
	TppEnemy.SetRouteSets( cpRouteSets , { warpEnemy = true , forceUpdate = true , forceReload = true , startAtZero = true } )
--	TppEnemy.SetRouteSets( cpRouteSets , { warpEnemy = true } )
end
--パスチコの順で助け、２人をＲＶに運ぶまで
local Seq_PazChicoToRV_RouteSet = function()
	local cpRouteSets = {
		{
			cpID = "gntn_cp",
			sets = {
				sneak_night = "e20010_Seq40_SneakRouteSet",
				caution_night = "e20010_Seq50_CautionRouteSet",
			},
		},
	}
	TppEnemy.SetRouteSets( cpRouteSets , { warpEnemy = true , forceUpdate = true , forceReload = true , startAtZero = true } )
--	TppEnemy.SetRouteSets( cpRouteSets , { warpEnemy = true } )
end
---------------------------------------------------------------------------------
-- シーケンス管理敵兵ON/OFF
---------------------------------------------------------------------------------
--Seq10敵兵Enable
local Seq10Enemy_Enable = function()
	TppEnemyUtility.SetEnableCharacterId( "Seq10_01" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_02" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_03" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_05" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_06" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_07" , true )
end
--Seq10敵兵Disable
local Seq10Enemy_Disable = function()
	TppEnemyUtility.SetEnableCharacterId( "Seq10_01" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_02" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_03" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_05" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_06" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_07" , false )
end
--Seq10敵兵Disable Ver.2(Seq40以降で使用
local Seq10Enemy_Disable_Ver2 = function()
	TppEnemyUtility.SetEnableCharacterId( "Seq10_01" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_02" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_03" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq10_05" , false )
end
--Seq20敵兵Enable
local Seq20Enemy_Enable = function()
	TppEnemyUtility.SetEnableCharacterId( "Seq20_01" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq20_02" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq20_03" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq20_04" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq20_05" , true )
end
--Seq20敵兵Disable
local Seq20Enemy_Disable = function()
	TppEnemyUtility.SetEnableCharacterId( "Seq20_01" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq20_02" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq20_03" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq20_04" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq20_05" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq20_06" , false )
end
--Seq30敵兵Enable
local Seq30Enemy_Enable = function()
	TppEnemyUtility.SetEnableCharacterId( "Seq30_01" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_02" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_03" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_04" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_05" , true )
	--11/3 Seq30_06 削除
	TppEnemyUtility.SetEnableCharacterId( "Seq30_07" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_08" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_09" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_10" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_11" , true )
end
--Seq30敵兵Disable
local Seq30Enemy_Disable = function()
	TppEnemyUtility.SetEnableCharacterId( "Seq30_01" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_02" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_03" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_04" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_05" , false )
	--11/3 Seq30_06 削除
	TppEnemyUtility.SetEnableCharacterId( "Seq30_07" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_08" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_09" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_10" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq30_11" , false )
end
--Seq40敵兵Enable
local Seq40Enemy_Enable = function()
	TppEnemyUtility.SetEnableCharacterId( "Seq40_01" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq40_02" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq40_03" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq40_04" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq40_05" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq40_06" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq40_07" , true )
	TppEnemyUtility.SetEnableCharacterId( "Seq40_08" , true )
end
--Seq40敵兵Disable
local Seq40Enemy_Disable = function()
	TppEnemyUtility.SetEnableCharacterId( "Seq40_01" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq40_02" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq40_03" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq40_04" , false )
	--11/3 Seq40_05&06 削除
	TppEnemyUtility.SetEnableCharacterId( "Seq40_07" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq40_08" , false )
end
---------------------------------------------------------------------------------
-- ミッション写真の制御
---------------------------------------------------------------------------------
local EnablePhoto = function()
-- チコとパスの写真を表示する　1001 yamamoto 関数化
	--写真設定
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
		return
	end
	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
		return
	end
	luaData:EnableMissionPhotoId( 10 )--チコ
	luaData:EnableMissionPhotoId( 30 )--パス
	luaData:SetAdditonalMissionPhotoId(10,true,false)-- チコ追加写真 1001_yamamoto
	luaData:SetAdditonalMissionPhotoId(30,true,false)-- パス追加写真 1001_yamamoto

end

local SetComplatePhoto = function( num )
-- 写真を達成済みにする
-- 番号を受け取って対応
-- 番号なければフラグを見て勝手に反映
	Fox.Log(":: Set complate photo ::")
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end

	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end

	if ( num ~= nil ) then
		-- 指定があれば反映
		Fox.Log(num)
		luaData:SetCompleteMissionPhotoId(num, true)
	else
		Fox.Log("num is nil : check flag")
		-- 指定がないのでフラグ見て反映
		if ( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then
			--パス救出していたら　達成済みにマーク
			Fox.Log("Set Paz")
			luaData:SetCompleteMissionPhotoId(30, true)
		end

		if ( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) then
			--パス救出していたら　達成済みにマーク
			Fox.Log("Set Chico")
			luaData:SetCompleteMissionPhotoId(10, true)
		end

	end
end
--木製ヤグラ雨遮りを戻す
local WoodTurret_RainFilter_OFF = function()
	local rainManager = TppRainFilterInterruptManager:GetInstance()
	--雨フィルタのパラメータを上の命令で変更した値を元に戻す、z秒で
	rainManager:ResetStartEndFadeInDistanceDemo( 1 )
	--ついでに雨カメラしぶきレートもデフォに戻す
	TppEffectUtility.SetCameraRainDropRate( 1.0 )
end
---------------------------------------------------------------------------------
--中間目標設定
---------------------------------------------------------------------------------
local commonUiMissionSubGoalNo = function( id )

	local sequence = TppSequence.GetCurrentSequence()

	if ( sequence ~= "Seq_RescueHostages" ) then
		AnounceLog_MissionUpdate()
	end

	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end

	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end
	-- 中目標番号をその値に設定する
	luaData:SetCurrentMissionSubGoalNo( id)
end
---------------------------------------------------------------------------------
--SystemSequences
---------------------------------------------------------------------------------
--ミッションセットアップ
this.Seq_MissionSetup = {

	OnEnter = function()
		MissionSetup()
		GZCommon.MissionSetup()
		TppSequence.ChangeSequence( "Seq_OpeningDemoLoad" )
	end,
}
--オープニングデモブロックロード
this.Seq_OpeningDemoLoad = {

	OnEnter = function()
--		LoadDemoBlock( "d01" )
		TppMission.LoadEventBlock("/Assets/tpp/pack/mission/extra/e20010/e20010_e01.fpk")
		--Demo途中で敵がアクティブになったときに武器Loadを発生させたくないので予めロード発行しておく
		TppCollectibleDataManager.LoadMissionWeapon("WP_ms02")
		TppCollectibleDataManager.LoadMissionWeapon("WP_sr01_v00")
		TppCollectibleDataManager.LoadMissionWeapon("WP_sg01_v00")
		TppCollectibleDataManager.LoadMissionWeapon("WP_ar00_v01")
	end,

	OnUpdate = function()
		if( IsEventBlockActive() ) then
			TppSequence.ChangeSequence( "Seq_OpeningDemoPlay" )
		end
	end,
}
--ミッションロード
this.Seq_MissionLoad = {

	Messages = {
		Timer = {
				{ data = "Timer_MissionStartTelop", message = "OnEnd", commonFunc = MissionStartTelop_ON },
			},
	},

	OnEnter = function()
		--シーケンスセーブ
		TppMissionManager.SaveGame("10")
		-- 中間目標
		commonUiMissionSubGoalNo(1)
		-- デフォルトランディングゾーン設定
		TppSupportHelicopterService.SetDefaultRendezvousPointMarker("no_lz")
		--シーケンスセーブ
--		TppMissionManager.SaveGame("10")
		--雨さえぎりOFF
		WoodTurret_RainFilter_OFF()
		--キャラEnable/Disable
		Seq10Enemy_Enable()
		Seq20Enemy_Disable()
		Seq30Enemy_Disable()
		Seq40Enemy_Disable()
		--ルート設定
		Seq_RescueHostages_RouteSet()
		--Seq_RescueHostages_RouteSetの詳細設定
		Setting_Seq_RescueHostages_RouteSet()
		--e20010_e02ブロック読み替え
		TppMission.LoadEventBlock("/Assets/tpp/pack/mission/extra/e20010/e20010_e02.fpk")
		MainMissionLoad()
		--ミッション開始テロップタイマースタート
		MissionStartTelopTimerStart()
		--マップアイコン説明テキスト
		MapIconText()
		RegisterRadioCondition()
		--ミラー強制無線
	--	local radioDaemon = RadioDaemon:GetInstance()
	--	TppRadio.DelayPlay( "Miller_MissionStart", "mid" )
	end,

	OnUpdate = function()
		if( IsEventBlockActive() ) then
			TppSequence.ChangeSequence( "Seq_RescueHostages" )
		end
	end,
}
------------------------------------------------------------------------------------------------
-- シーケンス別ガードターゲット設定
------------------------------------------------------------------------------------------------
local GuardTarget_Setting = function()

	local sequence = TppSequence.GetCurrentSequence()

	if( sequence == "Seq_RescueHostages" ) then
		--フロントライントラップ
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine000", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine001", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine002", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine000", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine001", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine002", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine003", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine004", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine005", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine006", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine007", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine008", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine009", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine010", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetMainGuardIndex000", true , false )
		--優先コンバットロケーター
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0126",false)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0000",true)
		--ON
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Chico", true )		-- 旧収容施設
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Paz", true )			-- ボイラー室
		--OFF
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_HeliPort", false )	-- ヘリポート
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Paz2", false )		-- 海岸
	elseif( sequence == "Seq_NextRescuePaz" ) then
		--フロントライントラップ
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine000", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine001", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine002", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine000", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine001", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine002", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine003", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine004", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine005", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine006", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine007", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine008", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine009", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine010", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetMainGuardIndex000", true , false )
		--優先コンバットロケーター
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0126",true)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0000",false)
		--ON
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Paz2", true )			-- 海岸
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Paz", true )			-- ボイラー室
		--OFF
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Chico", false )		-- 旧収容施設
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_HeliPort", false )	-- ヘリポート
	elseif( sequence == "Seq_NextRescueChico" ) then
		--フロントライントラップ
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine000", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine001", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine002", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine000", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine001", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine002", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine003", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine004", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine005", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine006", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine007", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine008", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine009", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine010", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetMainGuardIndex000", false , false )
		--優先コンバットロケーター
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0126",false)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0000",true)
		--ON
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Chico", true )		-- 旧収容施設
		--OFF
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_HeliPort", false )	-- ヘリポート
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Paz2", false )		-- 海岸
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Paz", false )			-- ボイラー室
	else
		--フロントライントラップ
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine000", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine001", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_OFF_SetFrontLine002", true , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine000", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine001", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine002", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine003", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine004", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine005", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine006", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine007", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine008", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine009", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetFrontLine010", false , false )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "paz_ON_SetMainGuardIndex000", false , false )
		--優先コンバットロケーター
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0126",true)
		TppCommandPostObject.GsSetPriorityCombatLocator("gntn_cp","TppCombatLocatorData0000",false)
		--ON
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Paz2", true )		-- 海岸
		--OFF
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_HeliPort", false )	-- ヘリポート
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Chico", false )		-- 旧収容施設
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID, "TppGuardTarget_Paz", false )		-- ボイラー室
	end
end
---------------------------------------------------------------------------------
--Skip
---------------------------------------------------------------------------------
this.OnSkipEnterCommon = function()

	local sequence = TppSequence.GetCurrentSequence()

	-- do prepare
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionPrepare" ) ) then
--		this.onMissionPrepare()
	end

	-- Set all mission states
--[[
	if( TppSequence.IsGreaterThan( sequence, "Seq_Mission_Failed" ) ) then
		TppMission.ChangeState( "failed" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionAbort" ) ) then
		TppMission.ChangeState( "abort" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionClear" ) ) then
		TppMission.ChangeState( "clear" )
--]]
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionPrepare" ) ) then

		this.e20010_PlayerSetWeapons()
		-- 環境設定
		MissionSetup()
		-- デモブロックはここで読み込んでおく
		TppMission.LoadEventBlock("/Assets/tpp/pack/mission/extra/e20010/e20010_e02.fpk")
		--マップアイコン説明テキスト
		MapIconText()
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_Mission_Failed" ) ) then
		TppMission.ChangeState( "failed" )
	end
end

this.OnSkipUpdateCommon = function()
-- デモブロックが読み込み終わるまで待機
--	return TppMission.IsDemoBlockActive() and IsEventBlockActive()
	return IsEventBlockActive()
end

this.OnSkipLeaveCommon = function()
	local sequence = TppSequence.GetCurrentSequence()

	--写真設定
	EnablePhoto()

	-- シーケンスごとのセットアップがあればここに書いておく
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionLoad" ) ) then
--		commonRouteSetMissionSetup()
		GZCommon.MissionSetup()
		RegisterRadioCondition()
	end

end
--後復帰処理
this.OnAfterRestore = function()
	-- ユニークキャラの復帰処理
	-- Save時のシーケンス、フラグ状態に合わせたルートセットの再設定
	local sequence = TppSequence.GetCurrentSequence()
	--雨さえぎりOFF
	WoodTurret_RainFilter_OFF()
	TppMission.SetFlag( "isTruckSneakRideOn", false )
	-- 捕虜ワープ処理
	e20010_require_01.HostageWarp_FrontGateArmorVehicle()
	e20010_require_01.HostageWarp_EastCampVehicle01()
	e20010_require_01.HostageWarp_EastCampTruck()
	e20010_require_01.HostageWarp_CarryWeaponTruck()
	e20010_require_01.HostageWarp_OpenGateTruck01()
	e20010_require_01.HostageWarp_OpenGateTruck02()
	e20010_require_01.HostageWarp_OpenGateTruck03()
	e20010_require_01.HostageWarp_CenterOutVehicle01()
	e20010_require_01.HostageWarp_CenterOutVehicle02()
	e20010_require_01.HostageWarp_WareHouseArmorVehicle()
	e20010_require_01.HostageWarp_AsylumVehicle()
	e20010_require_01.HostageWarp_HeliPortFrontGateArmorVehicle()
	-- シーケンスごとのセットアップがあればここに書いておく
	if ( sequence == "Seq_MissionLoad" ) or ( sequence == "Seq_RescueHostages" ) then					-- ゲーム開始～１人目に会うまで_10
		Seq_RescueHostages_RouteSet_Continue()
		--　コンテニュー時無線用フラグ除去
		local radioDaemon = RadioDaemon:GetInstance()
		radioDaemon:DisableFlagIsMarkAsRead( "e0010_rtrg0010" )

		if( TppMission.GetFlag( "isSpHostage_Dead" ) == true ) then
			TppRadio.DisableIntelRadio( "SpHostage" )
		else
		end
	elseif ( sequence == "Seq_NextRescuePaz" ) then					-- チコに会った～パスに会うまで_20
		Seq_NextRescuePaz_RouteSet()
		e20010_require_01.SpHostageStatus()	-- 脱走捕虜状態判定
		if( TppMission.GetFlag( "isSeq20_02_DriveEnd" ) == 2 ) then
			TppEnemy.Warp( "Cargo_Truck_WEST_004" , "warp_OpenGateTruck" )
		else
		end
	elseif ( sequence == "Seq_NextRescueChico" ) then				-- パスに会った～チコに会うまで_40
		Seq_NextRescueChico_RouteSet()
		if( TppMission.GetFlag( "isArmorVehicle_Start" ) == 1 ) then
			TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_002" , "ArmorVehicle_onRaid_Seq40_08_02" , -1 )
		elseif( TppMission.GetFlag( "isArmorVehicle_Start" ) == 2 ) then
			TppEnemy.Warp( "Armored_Vehicle_WEST_002" , "warp_ArmorVehicle" )
			TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_002" , "ArmorVehicle_WareHouseWait" , -1 )
		end
		if( TppMission.GetFlag( "isSeq40_0304_DriveEnd" ) == 2 ) then
			TppEnemy.Warp( "Tactical_Vehicle_WEST_005" , "warp_ToAsylumVehicle" )
		else
			TppEnemy.EnableRoute( this.cpID , "Seq40_03_RideOnVehicle" )
			TppEnemy.EnableRoute( this.cpID , "Seq40_04_RideOnVehicle" )
			TppEnemy.DisableRoute( this.cpID , "Seq40_03_PreRideOnVehicle" )
			TppEnemy.DisableRoute( this.cpID , "Seq40_04_PreRideOnVehicle" )
			TppEnemy.ChangeRoute( this.cpID , "Seq40_03","e20010_Seq40_SneakRouteSet","Seq40_03_RideOnVehicle", 0 )
			TppEnemy.ChangeRoute( this.cpID , "Seq40_04","e20010_Seq40_SneakRouteSet","Seq40_04_RideOnVehicle", 0 )
		end
	elseif ( sequence == "Seq_ChicoPazToRV" ) then					-- チコパス順で会い、ヘリに２人を乗せるまで_30
		Seq_ChicoPazToRV_RouteSet()
		if( TppMission.GetFlag( "isVehicle_Seq30_0506Start" ) == true ) then
			TppEnemy.EnableRoute( this.cpID , "Seq30_05_RideOnVehicle" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_AsylumOutSideGate_c" )
			TppEnemy.ChangeRoute( this.cpID , "Seq30_05","e20010_Seq30_SneakRouteSet","Seq30_05_RideOnVehicle", 0 )
		else
		end
		if( TppMission.GetFlag( "isArmorVehicle_Start" ) == 1 ) then
			TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_003" , "ArmorVehicle_onRaid_Seq30_11_2" , -1 )
		elseif( TppMission.GetFlag( "isArmorVehicle_Start" ) == 2 ) then
			TppEnemy.Warp( "Armored_Vehicle_WEST_002" , "warp_ArmorVehicle" )
			TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_003" , "ArmorVehicle_WareHouseWait" , -1 )
		end
		if( TppMission.GetFlag( "isSeq20_02_DriveEnd" ) == 2 ) then
			TppEnemy.Warp( "Cargo_Truck_WEST_004" , "warp_OpenGateTruck" )
		else
		end
	elseif ( sequence == "Seq_PazChicoToRV" ) then					-- パスチコ順で会い、ヘリに２人を乗せるまで_50
		Seq_PazChicoToRV_RouteSet()
		if( TppMission.GetFlag( "isArmorVehicle_Start" ) == 1 ) then
			TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_002" , "ArmorVehicle_onRaid_Seq40_08_02" , -1 )
		elseif( TppMission.GetFlag( "isArmorVehicle_Start" ) == 2 ) then
			TppEnemy.Warp( "Armored_Vehicle_WEST_002" , "warp_ArmorVehicle" )
			TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_002" , "ArmorVehicle_WareHouseWait" , -1 )
		end
		if( TppMission.GetFlag( "isSeq40_0304_DriveEnd" ) == 2 ) then
			TppEnemy.Warp( "Tactical_Vehicle_WEST_005" , "warp_ToAsylumVehicle" )
		else
			TppEnemy.EnableRoute( this.cpID , "Seq40_03_RideOnVehicle" )
			TppEnemy.EnableRoute( this.cpID , "Seq40_04_RideOnVehicle" )
			TppEnemy.DisableRoute( this.cpID , "Seq40_03_PreRideOnVehicle" )
			TppEnemy.DisableRoute( this.cpID , "Seq40_04_PreRideOnVehicle" )
			TppEnemy.ChangeRoute( this.cpID , "Seq40_03","e20010_Seq40_SneakRouteSet","Seq40_03_RideOnVehicle", 0 )
			TppEnemy.ChangeRoute( this.cpID , "Seq40_04","e20010_Seq40_SneakRouteSet","Seq40_04_RideOnVehicle", 0 )
		end
	else							-- ２人を乗せてＰＣもヘリに乗るまで_30or50
		if( TppMission.GetFlag( "isFirstEncount_Chico" ) == true ) then
			Seq_ChicoPazToRV_RouteSet()
			-- 旧収容施設からスタートビークル
			if( TppMission.GetFlag( "isVehicle_Seq30_0506Start" ) == true ) then
				TppEnemy.EnableRoute( this.cpID , "Seq30_05_RideOnVehicle" )
				TppEnemy.DisableRoute( this.cpID , "S_Sen_AsylumOutSideGate_c" )
				TppEnemy.ChangeRoute( this.cpID , "Seq30_05","e20010_Seq30_SneakRouteSet","Seq30_05_RideOnVehicle", 0 )
			else
			end
			if( TppMission.GetFlag( "isArmorVehicle_Start" ) == 1 ) then
				TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_003" , "ArmorVehicle_onRaid_Seq30_11_2" , -1 )
			elseif( TppMission.GetFlag( "isArmorVehicle_Start" ) == 2 ) then
				TppEnemy.Warp( "Armored_Vehicle_WEST_003" , "warp_ArmorVehicle" )
				TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_003" , "ArmorVehicle_WareHouseWait" , -1 )
			end
			if( TppMission.GetFlag( "isSeq20_02_DriveEnd" ) == 2 ) then
				TppEnemy.Warp( "Cargo_Truck_WEST_004" , "warp_OpenGateTruck" )
			else
			end
		else
			Seq_PazChicoToRV_RouteSet()
			if( TppMission.GetFlag( "isArmorVehicle_Start" ) == 1 ) then
				TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_002" , "ArmorVehicle_onRaid_Seq40_08_02" , -1 )
			elseif( TppMission.GetFlag( "isArmorVehicle_Start" ) == 2 ) then
				TppEnemy.Warp( "Armored_Vehicle_WEST_002" , "warp_ArmorVehicle" )
				TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_002" , "ArmorVehicle_WareHouseWait" , -1 )
			end
			if( TppMission.GetFlag( "isSeq40_0304_DriveEnd" ) == 2 ) then
				TppEnemy.Warp( "Tactical_Vehicle_WEST_005" , "warp_ToAsylumVehicle" )
			else
				TppEnemy.EnableRoute( this.cpID , "Seq40_03_RideOnVehicle" )
				TppEnemy.EnableRoute( this.cpID , "Seq40_04_RideOnVehicle" )
				TppEnemy.DisableRoute( this.cpID , "Seq40_03_PreRideOnVehicle" )
				TppEnemy.DisableRoute( this.cpID , "Seq40_04_PreRideOnVehicle" )
				TppEnemy.ChangeRoute( this.cpID , "Seq40_03","e20010_Seq40_SneakRouteSet","Seq40_03_RideOnVehicle", 0 )
				TppEnemy.ChangeRoute( this.cpID , "Seq40_04","e20010_Seq40_SneakRouteSet","Seq40_04_RideOnVehicle", 0 )
			end
		end
	end
	GuardTarget_Setting()	--ガードターゲット設定

	local radioDaemon = RadioDaemon:GetInstance()
	--諜報無線セット
--	SetIntelRadio()
	-- 保存した諜報無線の内容をロードする
	Fox.Log("================== RestoreIntelRadio ====================== " .. sequence)
	TppRadio.RestoreIntelRadio()

	--任意無線セット
	SetOptionalRadio()
	if( sequence == "Seq_NextRescuePaz" ) then
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1260") == false ) then
			if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true )then
				--尋問促し無線
				if( TppMission.GetFlag( "isPlayInterrogationAdv" ) == false ) then
					e20010_require_01.InterrogationAdviceTimerReStart()
				else
					if( TppMission.GetFlag( "isPazMarkJingle" ) == false ) then
						TppRadio.DelayPlay("Miller_InterrogationAdvice", "mid")
						TppRadio.RegisterOptionalRadio( "Optional_Interrogation" )
					end
				end
			elseif( TppMission.GetFlag( "isQuestionChico" ) == true )then
				if( TppMission.GetFlag( "isSaftyArea01" ) == true ) then
					TppRadio.DelayPlay("Miller_TakeChicoOnHeli", 3.5)
				end
			end
		end
	end
	-- チコテープ3再生中の無線再生許可判定
	if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1270") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1271") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1272") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1274") == false ) then
		if( TppMission.GetFlag( "isPazMarkJingle" ) == false and TppMission.GetFlag( "isInterrogation_Radio" ) == false ) then
			--チコ3再生中に無線再生できないようにする
			TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( true )
		else
			--チコ3再生中に無線再生できるようにする
			TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( false )
		end
	else
		--チコ3再生中に無線再生できるようにする
		TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( false )
	end

end
---------------------------------------------------------------------------------
--ゲームオーバー画面設定
---------------------------------------------------------------------------------
-- ミッション失敗画面
local SetGameOverMissionFailed = function()
	local uiCommonData = UiCommonDataManager.GetInstance()
	uiCommonData:SetGameOverMissionFailed()
end
-- タイムパラドックス画面
local SetGameOverTimeParadox = function()
	local uiCommonData = UiCommonDataManager.GetInstance()
	uiCommonData:SetGameOverTimeParadox()
end

---------------------------------------------------------------------------------
--GameSequences
---------------------------------------------------------------------------------
-------------------------------------------------------------
--マーカー
---------------------------------------------------------------------------------
-- 旧収容施設マーカーＯＮ
local Asylum_MarkerON = function()
	TppMarker.Enable( "20010_marker_Chico", 2 , "moving" , "map" , 0 , false )
end
-- 廃棄カセットテープ
local Cassette_MarkerOn = function()
	TppMarker.Enable( "Marker_Cassette", 0 , "none" , "map_only_icon" , 0 , false , true )
end
-- 排水溝位置
local Duct_MarkerOn = function()
	TppMarker.Enable( "Marker_Duct", 0 , "none" , "map_only_icon" , 0 , false , true )
end
-- ＸＯＦマーク
local Xof_MarkerOn = function()
	TppMarker.Enable( "Marker_XOF", 0 , "none" , "map_only_icon" , 0 , false , true )
end
-- 海岸ＲＶマーカーＯＮ
local RV_MarkerON = function()
	TppMarker.Enable( "20010_marker_RV" , 0 , "moving" , "all" , 0 , false , true )
--	TppMarker.Enable( "20010_marker_RV" , 1 , "moving" , "all" , 0 , true , true )
end
-- チコマーカーＯＮ
local Chico_MarkerON = function()
	--チコをヘリに乗せていなかったら
	if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == false ) then
		--チコマーカーＯＮ
		TppMarker.Enable( "Chico" , 0 , "none" , "map_and_world_only_icon" , 0 , true )
	--チコをヘリに乗せていたら
	else
		--チコマーカーＯＦＦ
		TppMarkerSystem.DisableMarker{ markerId = "Chico" }
	end
end
-- パスマーカーＯＮ
local Paz_MarkerON = function()
	--パスをヘリに乗せていなかったら
	if( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == false ) then
		--パスマーカーＯＮ
		TppMarker.Enable( "Paz" , 0 , "none" , "map_and_world_only_icon" , 0 , true )
	--パスをヘリに乗せていたら
	else
		--パスマーカーＯＦＦ
		TppMarkerSystem.DisableMarker{ markerId = "Paz" }
	end
end
---------------------------------------------------------------------------------
--その他
---------------------------------------------------------------------------------
--共通関数
--ランキングフィードバック
local RankingFeedBack = function()
	-- 0：未クリア 1：S 2：A 3：B 4：C 5：D 6：E
	local Rank = PlayRecord.GetRank()
	if( Rank == 0 ) then
	elseif( Rank == 1 ) then
		Trophy.TrophyUnlock(4)
	elseif( Rank == 2 ) then
	elseif( Rank == 3 ) then
	elseif( Rank == 4 ) then
	else
	end
end
--管理棟巨大ゲート最初から開錠状態
local Common_CenterBigGate_DefaultOpen = function()
	TppGadgetUtility.SetDoor{ id = "gntn_BigGate", isVisible = true, isEnableBounder = false, isOpen = true }
end
--管理棟巨大ゲート開錠
local Common_CenterBigGate_Open = function()
	local gateObj = Ch.FindCharacterObjectByCharacterId( "gntn_BigGate" )
	local gateChara = gateObj:GetCharacter()
	gateChara:SendMessage( TppGadgetStartActionRequest() )
end
--管理棟巨大ゲート封鎖
local Common_CenterBigGate_Close = function()
	local gateObj = Ch.FindCharacterObjectByCharacterId( "gntn_BigGate" )
	local gateChara = gateObj:GetCharacter()
	gateChara:SendMessage( TppGadgetUnsetOwnerRequest() )
	gateChara:SendMessage( TppGadgetEndActionRequest() )
end
--脱走捕虜Enable
local SpHostage_Enable = function()
	TppCharacterUtility.SetEnableCharacterIdWithMarker( "SpHostage" , true )
end
--脱走捕虜Disable
local SpHostage_Disable = function()

	if( TppMission.GetFlag( "isSpHostageEncount" ) == true ) then
		--接触してたら消さない
	else
		--接触してなかったら消す
		TppCharacterUtility.SetEnableCharacterIdWithMarker( "SpHostage" , false )
	end
end
--Seq10で使用するトラップEnable
local Seq10Trap_Enable = function()
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "AsyInsideRouteChange_01", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "EastCampMoveTruck_Start", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "EastCampSouth_SL_RouteChange", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "GunTutorialEnemyRouteChange", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_AsyWC", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_ChicoTape", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_EscapeHostage", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "VehicleStart", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "CTE0010_0310_NearArea", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_Helipad01", true , false )
end
--Seq10で使用するトラップDisable
local Seq10Trap_Disable = function()
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "AsyInsideRouteChange_01", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "EastCampMoveTruck_Start", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "EastCampSouth_SL_RouteChange", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "GunTutorialEnemyRouteChange", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_AsyWC", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_ChicoTape", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_EscapeHostage", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "VehicleStart", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "CTE0010_0310_NearArea", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_Helipad01", false , false )
end
--Seq20で使用するトラップEnable
local Seq20Trap_Enable = function()
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "BoilarEnemyRouteChange", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne11_RouteChange", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "GateOpenTruckRouteChange", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seaside2manStartRouteChange", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq20_05_RouteChange", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ChicoMonologue", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ChicoMonologue02", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ChicoMonologue03", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ChicoMonologue04", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "CTE0010_0280_NearArea", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne17_RouteChange", true , false )
--	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_KillSpHostage01", true , false )
end
--Seq20で使用するトラップDisable
local Seq20Trap_Disable = function()
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "BoilarEnemyRouteChange", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne11_RouteChange", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "GateOpenTruckRouteChange", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seaside2manStartRouteChange", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq20_05_RouteChange", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_KillSpHostage01", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ChicoMonologue", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ChicoMonologue02", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ChicoMonologue03", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ChicoMonologue04", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "CTE0010_0280_NearArea", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne17_RouteChange", false , false )
end
--Seq10&20で使用するトラップEnable
local Seq10_20Trap_Enable = function()
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Center2F_EneRouteChange", true , false )
--	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne25RouteChange01", true , false )
--	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne25RouteChange02", true , false )
--	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne25RouteChange03", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "SmokingRouteChange", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_Helipad02", true , false )
end
--Seq10&20で使用するトラップDisable
local Seq10_20Trap_Disable = function()
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Center2F_EneRouteChange", false , false )
--	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne25RouteChange01", false , false )
--	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne25RouteChange02", false , false )
--	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne25RouteChange03", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "SmokingRouteChange", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_Helipad02", false , false )
end
--Seq30で使用するトラップEnable
local Seq30Trap_Enable = function()
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq30_PatrolVehicle_Start", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq30_PazCheck_Start", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq30_ArmorVehicle_Start", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq30_02_RouteChange", true , false )
end
--Seq30で使用するトラップDisable
local Seq30Trap_Disable = function()
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq30_PatrolVehicle_Start", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq30_PazCheck_Start", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq30_ArmorVehicle_Start", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq30_02_RouteChange", false , false )
end
--Seq40で使用するトラップEnable
local Seq40Trap_Enable = function()
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "toAsylumGroupStart", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne24_RouteChange", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq40_ComEne27_RouteChange", true , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq40_ArmorVehicle_Start", true , false )
end
--Seq40で使用するトラップDisable
local Seq40Trap_Disable = function()
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "toAsylumGroupStart", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne24_RouteChange", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq40_ComEne27_RouteChange", false , false )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq40_ArmorVehicle_Start", false , false )
end
-- チコのテープ入手
local GetChicoTape = function()
--	local hudCommonData = HudCommonDataManager.GetInstance()
--	hudCommonData:AnnounceLogViewLangId( "announce_get_tape" )
	local uiCommonData = UiCommonDataManager.GetInstance()
	uiCommonData:GetBriefingCassetteTape( "tp_chico_03" )
	TppMission.SetFlag( "isChicoTapeGet", true )
	--任意無線追加
--	TppRadio.RegisterOptionalRadio( "Optional_RVChicoToRescuePaz" )
	SetOptionalRadio()
end
--[[
-- 脱走捕虜のテープ入手 ※レーティング審査暫定対応
local GetSpHostageTape = function()
	local uiCommonData = UiCommonDataManager.GetInstance()
	uiCommonData:GetBriefingCassetteTape( "tp_chico_04" )
end
--]]

local UnlockDoorFromPhase = function()
-- フェイズが下がったときに状況をみて鍵を解除する（デモのトリガー）
-- 1001 yamamoto
	Fox.Log(":: Unlock Door From phase ::")

	local chicoNum = 0
	local pazNum = 0

	chicoNum = TppEnemyUtility.GetNumberOfActiveSoldierByBoxShape( Vector3(69, 20, 204), this.eneCheckSize_chico )
	pazNum = TppEnemyUtility.GetNumberOfActiveSoldierByBoxShape( Vector3(-138, 24, -16), eneCheckSize_paz )
	Fox.Log( chicoNum)
	Fox.Log( pazNum)

	if ( chicoNum == 0 ) then
		-- 敵兵がいなければ解除
		Fox.Log(" unlock !! chico")
		changeEnablePickingDoor( "AsyPickingDoor24", "unlock" ) 	-- チコのデモドアをアンロック
	end
	if ( pazNum == 0 ) then
		-- 敵兵がいなければ解除
		Fox.Log(" unlock !! paz")
		changeEnablePickingDoor( "Paz_PickingDoor00", "unlock" ) 	-- パスのデモドアをアンロック
	end
end


-- バイナリルートデータを文字列に変換
local commonGetGsRouteRouteName = function( string )
	if DEBUG then
		return GsRoute.DEBUG_GetRouteName( string )
	else
		return string
	end
end
--アラートフェイズ
local Common_Alert = function()

	--アラートサイレンを鳴らす
	GZCommon.CallAlertSirenCheck()

	changeEnablePickingDoor( "AsyPickingDoor24", "lock" ) 	-- チコのデモドアをロック
	changeEnablePickingDoor( "Paz_PickingDoor00", "lock" ) 	-- パスのデモドアをロック
--	TppRadio.Play( "Miller_AlartAdvice" )

	-- エヴァージョン時用任意無線初期化処理
	local radioDaemon = RadioDaemon:GetInstance()
	radioDaemon:DisableFlagIsCallCompleted( "e0010_oprg9020" )

end
--エバージョンフェイズ
local Common_Evasion = function()

	--アラートサイレンを停止する
	GZCommon.StopAlertSirenCheck()

	-- デモトリガーのドアのロック解除
	UnlockDoorFromPhase()
	-- 一時的にエバージョンでもデモ可能に　yamamoto 1004
	--changeEnablePickingDoor( "AsyPickingDoor24", "lock" ) 	-- チコのデモドアをロック
	--changeEnablePickingDoor( "Paz_PickingDoor00", "lock" ) 	-- パスのデモドアをロック

	local PhaseState = TppData.GetArgument( 2 )
	if PhaseState == "Down" then				--フェイズが下がった時
		local radioDaemon = RadioDaemon:GetInstance()
		local sequence = TppSequence.GetCurrentSequence()

		--パス脱獄がバレていたらサイレン鳴らす
		Common_RetryKeepCautionSiren()

		-- アラート時用任意無線初期化処理
		radioDaemon:DisableFlagIsCallCompleted( "e0010_oprg9010" )

		--ルートチェンジ
		if( sequence == "Seq_RescueHostages" ) then			-- 10
			TppEnemy.ChangeRouteSet( this.cpID , "e20010_Seq10_CautionRouteSet", { warpEnemy = false } )
		elseif( sequence == "Seq_NextRescuePaz" ) then		-- 20
			TppEnemy.ChangeRouteSet( this.cpID , "e20010_Seq20_CautionRouteSet", { warpEnemy = false } )
		elseif( sequence == "Seq_NextRescueChico" ) then	-- 40
			TppEnemy.ChangeRouteSet( this.cpID , "e20010_Seq40_CautionRouteSet", { warpEnemy = false } )
		elseif( sequence == "Seq_ChicoPazToRV" ) then		-- 30
			TppEnemy.ChangeRouteSet( this.cpID , "e20010_Seq30_CautionRouteSet", { warpEnemy = false } )
		elseif( sequence == "Seq_PazChicoToRV" ) then		-- 50
			TppEnemy.ChangeRouteSet( this.cpID , "e20010_Seq50_CautionRouteSet", { warpEnemy = false } )
		else
			if( TppMission.GetFlag( "isFirstEncount_Chico" ) == true ) then		-- 40
				TppEnemy.ChangeRouteSet( this.cpID , "e20010_Seq40_CautionRouteSet", { warpEnemy = false } )
			else		-- 50
				TppEnemy.ChangeRouteSet( this.cpID , "e20010_Seq50_CautionRouteSet", { warpEnemy = false } )
			end
		end
		--Radio
		if( TppMission.GetFlag( "isAlertCageCheck" ) == true ) then
			TppRadio.DelayPlayEnqueue("Miller_UlMeetChicoPazInCombat", "mid")
			TppMission.SetFlag( "isAlertCageCheck", false )

		elseif( TppMission.GetFlag( "isAlertTapeAdvice" ) == true ) then
			e20010_require_01.Radio_AlertTapeReAdvice()
		elseif( sequence == "Seq_NextRescuePaz" and	--先チコ
				radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0081") == true or
				radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0082") == true ) then
			if( TppPlayerUtility.IsCarriedCharacter( "Chico" ) == true and		--チコを担いでいる
				TppMission.GetFlag( "isSaftyArea01" ) == true ) then			--RVにいる
				TppRadio.DelayPlayEnqueue("Miller_ReChicoAdviceCarrie", "mid")
			elseif( TppMission.GetFlag( "isPazChicoDemoArea" ) == true ) then	--RVにチコを置いている
				TppRadio.DelayPlayEnqueue("Miller_ReChicoAdviceEva", "mid")
				TppRadio.DelayPlayEnqueue("Miller_PazChicoCarriedEndRV", "short")
			else
				TppRadio.DelayPlayEnqueue("Miller_ReChicoAdviceOutRV", "mid")
			end
		else
			if ( TppMission.GetFlag( "isDoCarryAdvice" ) == true and
				radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0050") == false ) then	--↓を再生していなければ
				TppRadio.DelayPlay( "Miller_MovingAdvice", "short" )
			end
		end
	else
	end
end
--コーションフェイズ
local Common_Caution = function()
	--アラートサイレンを停止する
	GZCommon.StopAlertSirenCheck()
	-- デモトリガーのドアのロック解除
	UnlockDoorFromPhase()
	local PhaseState = TppData.GetArgument( 2 )
	if PhaseState == "Down" then				--フェイズが下がった時

		-- アラート・エヴァージョン時用任意無線初期化処理
		local radioDaemon = RadioDaemon:GetInstance()
		radioDaemon:DisableFlagIsCallCompleted( "e0010_oprg9010" )
		radioDaemon:DisableFlagIsCallCompleted( "e0010_oprg9020" )

		--パス脱獄がバレていたらサイレン鳴らす
		Common_RetryKeepCautionSiren()

		if( TppMission.GetFlag( "isKeepCaution" ) == true ) then
			if( TppMission.GetFlag( "isPlayerOnHeli" ) == false ) then
				TppRadio.DelayPlayEnqueue("Miller_DontSneakPhase", "mid")
			end
		else
			local radioDaemon = RadioDaemon:GetInstance()
			if ( TppMission.GetFlag( "isDoCarryAdvice" ) == true and
				radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0050") == false ) then	--↓を再生していなければ
				TppRadio.DelayPlay( "Miller_MovingAdvice", "short" )
			end
		end
	else
	end
end
--スニークフェイズ
local Common_Sneak = function()

	--アラートサイレンを停止する
	GZCommon.StopAlertSirenCheck()

	-- アラート・エヴァージョン時用任意無線初期化処理
	local radioDaemon = RadioDaemon:GetInstance()
	radioDaemon:DisableFlagIsCallCompleted( "e0010_oprg9010" )
	radioDaemon:DisableFlagIsCallCompleted( "e0010_oprg9020" )

	-- デモトリガーのドアのロック解除
	UnlockDoorFromPhase()
	local PhaseState = TppData.GetArgument( 2 )
	if PhaseState == "Down" then				--フェイズが下がった時
		local radioDaemon = RadioDaemon:GetInstance()
		local sequence = TppSequence.GetCurrentSequence()

		if( sequence == "Seq_NextRescuePaz" and	--先チコ
				radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0081") == true or
				radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0082") == true ) then
			if( TppMission.GetFlag( "isPazChicoDemoArea" ) == true and	--RVにチコを置いている
				TppMission.GetFlag( "isSaftyArea01" ) == true ) then	--RVにいる
			--	TppRadio.DelayPlayEnqueue("Miller_ReChicoAdvice", "mid")
			end
		elseif ( TppMission.GetFlag( "isDoCarryAdvice" ) == true and
			radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0050") == false ) then	--↓を再生していなければ
			TppRadio.DelayPlay( "Miller_MovingAdvice", "short" )

		end
	else
	end
end
-- 通常捕虜１死亡
local Common_Hostage001_Dead = function()
	TppMission.SetFlag( "isHostageUnusual", true )
--	TppMission.SetFlag( "isHostage001_Dead", true )

	--プレイヤーが殺したチェック
	local killChk = TppData.GetArgument( 4 )
	if killChk == true then
		TppRadio.DelayPlayEnqueue("Miller_KillHostage", "mid")
	end
end
-- 通常捕虜２死亡
local Common_Hostage002_Dead = function()
	TppMission.SetFlag( "isHostageUnusual", true )
--	TppMission.SetFlag( "isHostage002_Dead", true )

	--プレイヤーが殺したチェック
	local killChk = TppData.GetArgument( 4 )
	if killChk == true then
		TppRadio.DelayPlayEnqueue("Miller_KillHostage", "mid")
	end
end
-- 通常捕虜３死亡
local Common_Hostage003_Dead = function()
	TppMission.SetFlag( "isAfterChicoDemoHostage", true )
--	TppMission.SetFlag( "isHostage003_Dead", true )

	--プレイヤーが殺したチェック
	local killChk = TppData.GetArgument( 4 )
	if killChk == true then
		TppRadio.DelayPlayEnqueue("Miller_KillHostage", "mid")
	end
end
-- 通常捕虜４死亡
local Common_Hostage004_Dead = function()
--	TppMission.SetFlag( "isHostage004_Dead", true )

	--プレイヤーが殺したチェック
	local killChk = TppData.GetArgument( 4 )
	if killChk == true then
		TppRadio.DelayPlayEnqueue("Miller_KillHostage", "mid")
	end
end
--脱走捕虜死亡
local Common_SpHostage_Dead = function()
	TppMission.SetFlag( "isSpHostage_Dead", true )
	TppRadio.DisableIntelRadio( "SpHostage" )

	PlayRecord.UnsetMissionChallenge( "HOSTAGE_RESCUE" )

	if( TppMission.GetFlag( "isKillingSpHostage" ) == true ) then
		--脱走捕虜のステータス変更
--		TppHostageUtility.SetHostageStatusInCp( "gntn_cp", "SpHostage", "HOSTAGE_STATUS_DEAD" )
	else
	end

	--プレイヤーが殺したチェック
	local killChk = TppData.GetArgument( 4 )
	if killChk == true then
		TppRadio.DelayPlayEnqueue("Miller_KillHostage", "mid")
	end
	TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( "Seq20_03", 1 )
end
-- ビークル破壊
local Common_VehicleBroken = function()

	local CharacterID = TppData.GetArgument( 1 )

	if CharacterID == "Tactical_Vehicle_WEST_002" then
		TppMission.SetFlag( "isSeq10_02_DriveEnd", 1 )
	else
	end
end
-- トラック破壊
local Common_TruckBroken = function()

	local CharacterID = TppData.GetArgument( 1 )

	if CharacterID == "Cargo_Truck_WEST_003" then
		TppMission.SetFlag( "isSeq10_03_DriveEnd", 1 )
	else
	end
end
--敵兵、檻に居ないパスを発見する
local Common_EnemyDiscoveryNoPaz = function()

	local hostageID = TppData.GetArgument( 2 )
	local stateID = TppData.GetArgument( 3 )
	if hostageID == "Paz" then						--パスがいない！！
		if stateID == "ReportedLostHostage" then	--捕虜ロスト無線後
			--キープコーションサイレン
			TppCommandPostObject.GsSetKeepPhaseName( this.cpID , "Caution" )
			GZCommon.CallCautionSiren()
			local sequence = TppSequence.GetCurrentSequence()
			if( sequence == "Seq_NextRescuePaz" ) then
				TppRadio.Play("Miller_PazJailBreak")
			else
				TppRadio.Play("Miller_PazJailBreak2")
			end
			TppMission.SetFlag( "isKeepCaution", true )
			--BGM設定
			TppMusicManager.SetSwitch{
				groupName = "bgm_phase_ct_level",
				stateName = "bgm_phase_ct_level_02",
			}
			TppMission.SetFlag( "isPazPrisonBreak", true )	--パス脱獄バレるフラグ
		elseif stateID == "ReportedHostage" then	--捕虜発見
			TppRadio.Play("Miller_EnemyDiscoveryPaz")
		end
	elseif hostageID == "Chico" then						--チコがいない
		if stateID == "ReportedHostage" then
			TppRadio.Play("Miller_EnemyDiscoveryChico")
		end
	end
end
-- 敵兵死亡時処理
local Common_EnemyDead = function()

	local sequence = TppSequence.GetCurrentSequence()
	local CharaID = TppData.GetArgument(1)

	if( sequence == "Seq_RescueHostages" ) then
		if CharaID == "Seq10_01" then
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_01" , false )
		elseif CharaID == "Seq10_02" then
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_02" , false )
		elseif CharaID == "Seq10_03" then
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_03" , false )
		end
	elseif( sequence == "Seq_NextRescuePaz" ) then
		if CharaID == "Seq20_02" then
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq20_02" , false )
		else
		end
	elseif( sequence == "Seq_NextRescueChico" ) or ( sequence == "Seq_PazChicoToRV" ) then
		if CharaID == "Seq40_03" then
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq40_03" , false )
		elseif CharaID == "Seq40_04" then
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq40_04" , false )
		end
	elseif( sequence == "Seq_ChicoPazToRV" ) then
		if CharaID == "Seq30_05" then
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq30_05" , false )
		else
		end
	else	-- Seq_PlayerOnHeli or Seq_PlayerOnHeliAfter
		if( TppMission.GetFlag( "isFirstEncount_Chico" ) == true ) then
			if CharaID == "Seq30_05" then
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq30_05" , false )
			else
			end
		else
			if CharaID == "Seq40_03" then
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq40_03" , false )
			elseif CharaID == "Seq40_04" then
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq40_04" , false )
			end
		end
	end
end
--敵兵かつぐアドバイス
local Common_PreEnemyCarryAdvice = function()
	if( TppMission.GetFlag( "isPreCarryAdvice" ) == false ) then
		if( TppMission.GetFlag( "isDoCarryAdvice" ) == true ) then
			TppRadio.DelayPlay("Miller_PreCarryAdvice", "long" )
			TppMission.SetFlag( "isPreCarryAdvice", true )
		end
	end
end
-- 対空行動への切り替え
local Common_ChangeAntiAir = function()

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
--PCヘリに乗る
local Common_PlayerOnHeli = function()

	--フラグチェック
	if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true
		and TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then		-- チコパスをヘリに乗せている
		-- いい無線があったら流す
		TppSequence.ChangeSequence( "Seq_PlayerOnHeliAfter" )				-- ヘリ離脱シーケンスに移行
	else
		local sequence = TppSequence.GetCurrentSequence()
		--　このままだとミッション失敗になるけどいい？無線を流す
		if( sequence == "Seq_ChicoPazToRV" or sequence == "Seq_PazChicoToRV" ) then
			local NearCheckPaz = false
			local NearCheckChico = false
			if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true) then	--チコをヘリに乗せている
				--パスが近くにいないかチェックする
				if( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == false ) then
					NearCheckPaz = e20010_require_01.playerNearCheck("Paz")
				end
			else															--パスをヘリに乗せている
				--チコが近くにいないかチェックする
				if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == false ) then
					NearCheckChico = e20010_require_01.playerNearCheck("Chico")
				end
			end
			if( NearCheckPaz == true or NearCheckChico == true ) then
				TppRadio.Play("Miller_DontOnHeliOnlyPlayer")
			else
				TppRadio.Play("Miller_MissionFailedOnHeli")
			end
		else
			TppRadio.DelayPlay( "Miller_MissionFailedOnHeli", "mid" )
		end
		-- 離陸を少し待つ
		TppSupportHelicopterService.SetEnableGetOffTime( GZCommon.WaitTime_HeliTakeOff )
	end
end
--ＰＣ武器を入手した時
local Common_PickUpWeaopn = function()
	local weaponID = TppData.GetArgument( 1 )
	if weaponID == "WP_ms02" then					-- 無反動砲
		TppRadio.DelayPlayEnqueue("Miller_MissileGet", "mid")
		if( TppMission.GetFlag( "isPrimaryWPIcon" ) == false ) then
			e20010_require_01.Tutorial_2Button("tutorial_primary_wp_select", fox.PAD_U, "RStick")
			TppMission.SetFlag( "isPrimaryWPIcon", true )
		end
	elseif weaponID == "WP_sr01_v00" then				-- スナイパーライフル
		if( TppMission.GetFlag( "isPrimaryWPIcon" ) == false ) then
			e20010_require_01.Tutorial_2Button("tutorial_primary_wp_select", fox.PAD_U, "RStick")
			TppMission.SetFlag( "isPrimaryWPIcon", true )
		end
	elseif weaponID == "WP_hg00_v01" then				-- ハンドガン（殺傷）

	elseif weaponID == "WP_hg02_v00" then						-- リボルバーショットガン ※未だ配置できない
		TppRadio.DelayPlayEnqueue("Miller_SpWeaponGet", "mid")
	elseif weaponID == "WP_Grenade" then				-- グレネード
		TppRadio.DelayPlayEnqueue("Miller_GranadoGet", "mid")
	elseif weaponID == "WP_SmokeGrenade" then		-- スモークグレネード

	elseif weaponID == "WP_C4" then					-- 無線起爆型爆弾
		TppRadio.DelayPlayEnqueue("Miller_GranadoGet", "mid")
	elseif weaponID == "WP_Claymore" then						-- クレイモア ※未だ配置できない

	else
	end
end
--ＰＣアイテムを入手した時
local Common_PickUpItem = function()
	local ItemID = TppData.GetArgument( 1 )
	local IndexNo = TppData.GetArgument( 2 )
	if ItemID == "IT_XOFEmblem" then					-- ＸＯＦワッペン
		if IndexNo == 9 then
		-- プレます用対応　ここから
				AnounceLog_GetXofMark()
				PlayRecord.RegistPlayRecord( "EMBLEM_GET" )
		else
			AnounceLog_GetXofMark()
			PlayRecord.RegistPlayRecord( "EMBLEM_GET" )
		end
	elseif ItemID == "IT_Cassette" then					-- カセットテープ
		if IndexNo == 1 then
			local uiCommonData = UiCommonDataManager.GetInstance()
			uiCommonData:GetBriefingCassetteTape( "tp_chico_02" )
		elseif IndexNo == 4 then
			local uiCommonData = UiCommonDataManager.GetInstance()
			uiCommonData:GetBriefingCassetteTape( "tp_chico_05" )
		elseif IndexNo == 12 then
			local uiCommonData = UiCommonDataManager.GetInstance()
			uiCommonData:GetBriefingCassetteTape( "tp_bgm_03" )
		else
		end
	else
	end
end
--武器を装備した時
local Common_EquipWeapon = function()
	local weaponID = TppData.GetArgument( 1 )
	local radioDaemon = RadioDaemon:GetInstance()

	if weaponID == "WP_WarningFlare" then								-- ワーニングフレア
		if ( radioDaemon:IsPlayingRadio() == false ) then
			--無線の種類に問わず再生中
			if ( TppMission.GetFlag("isHeliComingRV") == false and
				 TppMission.GetFlag("isDoCarryAdvice") == true ) then
				TppRadio.DelayPlay( "Miller_WarningFlareAdvice", "short" )
			end
		end
	else
	end
end
--木製ヤグラ雨遮り
local WoodTurret_RainFilter_ON = function()
	local rainManager = TppRainFilterInterruptManager:GetInstance()
	--雨フィルタのカメラ前フェードイン開始距離がｘから始まり、yで完全にフェードインする距離になる、z秒で
	rainManager:SetStartEndFadeInDistanceDemo( 1, 4, 1 )
end
--ミッション圏外アナウンス
local MissionArea_Out = function()
--	AnounceLog_area_warning()
end

--チコパスを担ぐ
local Common_ChicoPazCarry = function()
	TppMission.SetFlag( "isSeq10_02_DriveEnd", 1 )
	TppMission.SetFlag( "isSeq10_03_DriveEnd", 1 )
end

--チコをヘリに乗せる
local Common_ChicoOnHeli = function()

	local sequence = TppSequence.GetCurrentSequence()
	local VehicleID = TppData.GetArgument(3)

	Fox.Log(":: Common_ChicoOnHeli :: "..tostring(VehicleID))
	if VehicleID == "SupportHelicopter" then							--ヘリの場合
		TppMission.SetFlag( "isPlaceOnHeliChico", true )				--フラグ更新
		SetComplatePhoto(10)											--写真に達成済みマーク
		TppMarkerSystem.DisableMarker{ markerId = "Chico" }
		AnounceLog_ChicoRideOnHeli()	--アナウンスログ

		PlayRecord.RegistPlayRecord( "HOSTAGE_RESCUE", "Chico" )

		--中間目標設定＆ＲＶ設定解除
		if ( sequence == "Seq_NextRescuePaz" ) then
			-- デフォルトランディングゾーン設定
			TppSupportHelicopterService.SetDefaultRendezvousPointMarker("no_lz")
			if( TppMission.GetFlag( "isChicoTapePlay" ) == true ) then
				commonUiMissionSubGoalNo(4)		-- チコテープを聴いた＝デモが流れない＝中間目標更新
			else
			end
		elseif ( sequence == "Seq_ChicoPazToRV" )
			or ( sequence == "Seq_PazChicoToRV" ) then
			if ( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == false ) then
				commonUiMissionSubGoalNo(7)
			else
			end
		elseif ( sequence == "Seq_PlayerOnHeli" ) then
			commonUiMissionSubGoalNo(8)
		end

		TppRadio.DisableIntelRadio( "Chico" )
		--任意無線更新
		SetOptionalRadio()

		--ヘリ中に配置
		TppHostageManager.GsGetOnHelicopter("Chico","CNP_pos_rbr")
		e20010_require_01.ChicoPaznHeliSave()							--セーブ

		if( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then			--パス、ヘリの乗っている
			-- ミッション目的達成アナウンスログ
			local hudCommonData = HudCommonDataManager.GetInstance()
			hudCommonData:AnnounceLogViewLangId( "announce_mission_goal" )
			e20010_require_01.Timer_PlayerOnHeliAdviceStart()
			TppSequence.ChangeSequence( "Seq_PlayerOnHeli" )
		else															--パス、ヘリに乗っていない
		end
	-- ヘリ以外
	elseif VehicleID == "Tactical_Vehicle_WEST_002" then
		TppMission.SetFlag( "isSeq10_02_DriveEnd", 2 )
	elseif VehicleID == "Cargo_Truck_WEST_003" then
		TppMission.SetFlag( "isSeq10_03_DriveEnd", 2 )
	else
		TppMission.SetFlag( "isSeq10_02_DriveEnd", 1 )
		TppMission.SetFlag( "isSeq10_03_DriveEnd", 1 )
	end
end
--パスをヘリに乗せる
local Common_PazOnHeli = function()
	local sequence = TppSequence.GetCurrentSequence()
	local VehicleID = TppData.GetArgument(3)

	Fox.Log(":: Common_PazOnHeli :: "..tostring(VehicleID))
	if VehicleID == "SupportHelicopter" then							--ヘリの場合
		TppMission.SetFlag( "isPlaceOnHeliPaz", true )					--フラグ更新
		TppMarkerSystem.DisableMarker{ markerId = "20010_marker_RV" }	--ＲＶマーカー消す
		SetComplatePhoto(30)											--写真に達成済みマーク
		-------------------------------------------------------------------------------
		--ハードモードだったらチャレンジ項目達成
		local hardmode = TppGameSequence.GetGameFlag("hardmode")	-- 現在の難易度を取得
		if hardmode == true then									-- 難易度がハードだったら
			PlayRecord.RegistPlayRecord( "PAZ_RESCUE" )				-- チャンレンジ要素達成を記録
			-- Trophy.TrophyUnlock( 12 )							-- トロフィー・実績「チャレンジ項目を一つでも達成した」
		else														-- 難易度がノーマルだったら
		end
		-------------------------------------------------------------------------------
		TppRadio.DisableIntelRadio( "Paz" )
		SetOptionalRadio()	--任意無線更新
		TppMarkerSystem.DisableMarker{ markerId = "Paz" }
		PlayRecord.RegistPlayRecord( "PAZ_RESCUE" )
		AnounceLog_PazRideOnHeli()	--アナウンスログ

		PlayRecord.RegistPlayRecord( "HOSTAGE_RESCUE", "Paz" )

		--中間目標設定＆デフォルトＲＶ設定
		if ( sequence == "Seq_NextRescueChico" ) then
			-- デフォルトランディングゾーン設定
			TppSupportHelicopterService.SetDefaultRendezvousPointMarker("no_lz")
			commonUiMissionSubGoalNo(1)
		elseif ( sequence == "Seq_ChicoPazToRV" )
			or ( sequence == "Seq_PazChicoToRV" ) then
			if ( TppMission.GetFlag( "isPlaceOnHeliChico" ) == false ) then
				commonUiMissionSubGoalNo(3)
			else
			end
		elseif ( sequence == "Seq_PlayerOnHeli" ) then
			commonUiMissionSubGoalNo(8)
		end

		--ヘリ中に配置
		TppHostageManager.GsGetOnHelicopter("Paz","CNP_pos_rsm")
		e20010_require_01.ChicoPaznHeliSave()							--セーブ

		if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) then		--チコ、ヘリの乗っている
			-- ミッション目的達成アナウンスログ
			local hudCommonData = HudCommonDataManager.GetInstance()
			hudCommonData:AnnounceLogViewLangId( "announce_mission_goal" )
			e20010_require_01.Timer_PlayerOnHeliAdviceStart()
			TppSequence.ChangeSequence( "Seq_PlayerOnHeli" )
		else															--チコ、ヘリに乗っていない
			TppRadio.DelayPlayEnqueue( "Miller_ChicoOnHeliAdvice", "short" )
		end
	-- ヘリ以外
	elseif VehicleID == "Tactical_Vehicle_WEST_002" then
		TppMission.SetFlag( "isSeq10_02_DriveEnd", 2 )
	elseif VehicleID == "Cargo_Truck_WEST_003" then
		TppMission.SetFlag( "isSeq10_03_DriveEnd", 2 )
	else
		TppMission.SetFlag( "isSeq10_02_DriveEnd", 1 )
		TppMission.SetFlag( "isSeq10_03_DriveEnd", 1 )
	end
end
--脱走捕虜をヘリに乗せる
local Common_SpHostageOnHeli = function()
	local CharacterID	= TppData.GetArgument(1)
	local VehicleID = TppData.GetArgument(3)
	if VehicleID == "SupportHelicopter" then								--ヘリの場合
		if( TppMission.GetFlag( "isSpHostage_Dead" ) == false ) then		--脱走捕虜生きてる
			TppMission.SetFlag( "isPlaceOnHeliSpHostage", true )			--フラグ更新
			PlayRecord.PlusExternalScore( 3500 )		-- ﾎﾞｰﾅｽ
			Trophy.TrophyUnlock(6)		--実績解除
			TppRadio.DelayPlay("Miller_EnemyOnHeli", "mid")
			PlayRecord.RegistPlayRecord( "HOSTAGE_RESCUE", "SpHostage" )
			AnounceLog_SpHostageRideOnHeli()
		else																--脱走捕虜死んでる
			--何もしない
		end
	else
	end
end
--通常捕虜０１～０３をヘリに乗せる
local Common_HostageOnHeli = function()

	local CharacterID	= TppData.GetArgument(1)
	local status = TppHostageUtility.GetStatus( CharacterID )
	local VehicleID = TppData.GetArgument(3)
	if VehicleID == "SupportHelicopter" then								--ヘリの場合
		if( status ~= "Dead" ) then											--捕虜生きてる
			TppRadio.DelayPlay("Miller_EnemyOnHeli", "mid")
			GZCommon.NormalHostageRecovery( CharacterID )
		else
		end
	else
	end
end
--捕虜０４をヘリに乗せる
local Common_Hostage04OnHeli = function()

	local CharacterID	= TppData.GetArgument(1)
	local VehicleID = TppData.GetArgument(3)
	local status = TppHostageUtility.GetStatus( "Hostage_e20010_004" )

	if VehicleID == "SupportHelicopter" then								--ヘリの場合
		if( status ~= "Dead" ) then											--通常捕虜０４生きてる
			TppMission.SetFlag( "isPlaceOnHeliHostage04", true )			--フラグ更新
			TppRadio.DelayPlay("Miller_EnemyOnHeli", "mid")
			GZCommon.NormalHostageRecovery( CharacterID )
		else																--通常捕虜０４死んでる
		end
	else
	end
end
--敵兵をヘリに乗せる
local Common_EnemyOnHeli = function()
	local characterID = TppData.GetArgument(1)
	local VehicleID = TppData.GetArgument(3)
	if VehicleID == "SupportHelicopter" then								--ヘリの場合
		local status = TppEnemyUtility.GetLifeStatus( characterID )
		if (status ~="Dead")then
			TppRadio.DelayPlay("Miller_EnemyOnHeli", "mid")
		end
	else
	end
end
--脱走捕虜を担ぐ
local Common_SpHostageCarryStart = function()

	local sequence = TppSequence.GetCurrentSequence()

	TppMission.SetFlag( "isCarryOnSpHostage", true )			--フラグ更新
	TppMission.SetFlag( "isSpHostageEncount", true )
	TppRadio.DisableIntelRadio( "SpHostage" )

	if( TppMission.GetFlag( "isSpHostage_Dead" ) == false ) then		--脱走捕虜生きてる
		if ( sequence == "Seq_RescueHostages" ) then
			TppRadio.Play("Miller_CarrySpHostage")
			if( TppMission.GetFlag( "isEscapeHostage" ) == false ) then
				TppEnemy.EnableRoute( this.cpID , "S_Talk_EscapeHostage" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Pre_EscapeHostageTalk_a" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq10_SneakRouteSet","S_Talk_EscapeHostage",0 )
				TppMission.SetFlag( "isEscapeHostage", true )
			else
			end
		else
			local radioDaemon = RadioDaemon:GetInstance()
			if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1095") == false ) then
				TppRadio.Play("Miller_RescueSpHostage")
			end
		end
	else																--脱走捕虜死んでる
		--何もしない
	end
end
--車両に乗る
local Common_RideOnVehicle = function()
	local CharacterID = TppData.GetArgument(1)
	local VehicleID = TppData.GetArgument(2)
	local hudCommonData = HudCommonDataManager.GetInstance()

	-- 機銃装甲車の場合
	if VehicleID == "WheeledArmoredVehicleMachineGun" then
		TppMission.SetFlag( "isSeq10_02_DriveEnd", 1 )
		TppMission.SetFlag( "isSeq10_03_DriveEnd", 1 )
		local radioDaemon = RadioDaemon:GetInstance()
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1060") == true ) then
			hudCommonData:CallButtonGuide( "tutorial_vehicle_attack", fox.PAD_L1 )
		end
		TppRadio.DelayPlay( "Miller_StrykerDriveAdvice", "mid" )
	-- 支援ヘリの場合
	elseif VehicleID == "SupportHelicopter" then
		-- 何もしない
	else
--		if( TppMission.GetFlag( "isCarTutorial" ) == false ) then				--乗り物チュートリアルボタンを表示した
			-- RT アクセルボタン
			hudCommonData:CallButtonGuide( "tutorial_accelarater", "VEHICLE_TRIGGER_ACCEL" )
			-- LT バックボタン
			hudCommonData:CallButtonGuide( "tutorial_brake", "VEHICLE_TRIGGER_BREAK" )

			TppMission.SetFlag( "isCarTutorial", true )							--乗り物チュートリアルボタンを表示した
--		end
		-----------------------------------------------------------------------------------------------------
		if CharacterID == "Tactical_Vehicle_WEST_002" then
			TppMission.SetFlag( "isSeq10_02_DriveEnd", 2 )		-- スタート崖で見せるビークルに乗った
		elseif CharacterID == "Cargo_Truck_WEST_003" then
			TppMission.SetFlag( "isSeq10_03_DriveEnd", 2 )		-- 東難民キャンプを通過するトラックに乗った
		else
			TppMission.SetFlag( "isSeq10_02_DriveEnd", 1 )
			TppMission.SetFlag( "isSeq10_03_DriveEnd", 1 )
		end
	end
end
--ヘリがＲＶ到着
local Common_HeliArrive = function()
	local sequence = TppSequence.GetCurrentSequence()
	local lz = TppData.GetArgument( 2 )--add by yamamoto 0805
	local timer = 55 --「ヘリから離れろよ」という促しをするまでの時間
	local NearCheckPaz = false
	local NearCheckChico = false

	Fox.Log(":: Common_HeliArrive :: "..lz)

	if (lz == "RV_SeaSide") then
		TppMission.SetFlag( "isHeliComeToSea", true )
	else
		TppMission.SetFlag( "isHeliComeToSea", false )
	end

	-- 離れるよう促すタイマー開始
	TppMission.SetFlag( "isHeliLandNow", true )						-- ヘリが着陸してる
	GkEventTimerManager.Start( "Timer_pleaseLeaveHeli", timer )

	if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true and
		TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then	--チコパスをヘリに乗せている

	else																												--チコパスをヘリに乗せていない
		--ヘリに乗せていなければ近くにいるかチェックする
		if( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == false ) then
			NearCheckPaz = e20010_require_01.playerNearCheck("Paz")
		end
		if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == false ) then
			NearCheckChico = e20010_require_01.playerNearCheck("Chico")
		end

		if( NearCheckPaz == true or NearCheckChico == true ) then		--チコ、パスどちらかが近くにいる
			TppRadio.Play("Miller_TargetOnHeliAdvice")

		else																--チコ、パスどちらも近くにいない
			if( e20010_require_01.playerNearCheck("Hostage_e20010_001") == true 	--捕虜が近くにいる
				or e20010_require_01.playerNearCheck("Hostage_e20010_002") == true
				or e20010_require_01.playerNearCheck("Hostage_e20010_003") == true
				or e20010_require_01.playerNearCheck("Hostage_e20010_004") == true
				or e20010_require_01.playerNearCheck("SpHostage") == true ) then

			else																	--捕虜が近くに居ない
				if( sequence == "Seq_ChicoPazToRV" or
					sequence == "Seq_PazChicoToRV" ) then
					TppRadio.Play("Miller_TargetOnHeliAdvice")
				elseif( sequence == "Seq_PlayerOnHeli" ) then

				else
					TppRadio.Play("Miller_DontEscapeTargetOnHeli")
				end
			end

		end
	end
end
-- ヘリが離陸した
local Common_Departure = function()

	local isPlayer = TppData.GetArgument(3)
	-- プレイヤーが搭乗していたら
	if ( isPlayer == true ) then
		TppMission.SetFlag( "isPlayerOnHeli", true )					--フラグ更新
		TppSequence.ChangeSequence( "Seq_PlayerOnHeliAfter" )	-- ヘリ離脱シーケンスへ
	else
		TppMission.SetFlag( "isPlayerOnHeli", false )					--フラグ更新
	end

	TppMission.SetFlag( "isHeliLandNow", false )						-- ヘリが離陸してる
end
--ヘリが扉を閉めたとき
local Common_HeliCloseDoor = function()

	local sequence = TppSequence.GetCurrentSequence()
	local timer = 20 --扉が閉まるとき無線用タイマー

	--山本君追加分0805
	TppMission.SetFlag( "isHeliComeToSea", false )
	TppMission.SetFlag( "isHeliComingRV", false )
	--シーケンスチェック
	if ( sequence == "Seq_PlayerOnHeliAfter" ) then				-- ＰＣがヘリに乗ったシーケンス
		--チコパスをヘリに乗せているか？
		if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true )
			and ( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then
			-- スコア計算テーブルの設定
			GZCommon.ScoreRankTableSetup( this.missionID )
			TppMission.ChangeState( "clear", "RideHeli_Clear" )		-- "MissionState"を"clear"に変更
		else
			TppMission.ChangeState( "failed", "PlayerOnHeli" )
		end
	else		-- 他シーケンス
		--カセットテープを入手していない
		--排水溝情報を入手していない
		--ＸＯＦワッペンを入手していない
		if( TppMission.GetFlag( "isChicoTapeGet" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliChico" ) == false )
		and ( TppMission.GetFlag( "isGetDuctInfomation" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliSpHostage" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliSpHostage" ) == false )
		and ( TppMission.GetFlag( "isGetXofMark_Hostage04" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliHostage04" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliHostage04" ) == false ) then
			if ( sequence == "Seq_RescueHostages" ) or ( sequence == "Seq_NextRescuePaz" ) then
				--　無線再生
			--	local RadioSet01 = {"Miller_ChicoTapeAdvice01","Miller_CommonHostageInformation","Miller_AboutDuct01","Miller_JointVoice01","Miller_XofMarking"}
			--	TppRadio.DelayPlay( RadioSet01, "mid" )
				GkEventTimerManager.Start( "Timer_HeliCloseDoor_01", timer )
				-- フラグ更新
				TppMission.SetFlag( "isChicoTapeGet", true )
				TppMission.SetFlag( "isGetDuctInfomation", true )
				TppMission.SetFlag( "isGetXofMark_Hostage04", true )
				TppMission.SetFlag( "isFinishOnHeliChico", true )
				TppMission.SetFlag( "isFinishOnHeliSpHostage", true )
				TppMission.SetFlag( "isFinishOnHeliHostage04", true )
				-- その他
				GetChicoTape()	-- チコテープ入手
				e20010_require_01.InterrogationAdviceTimerStart()	--尋問促し無線タイマー開始
			--		Duct_MarkerOn()		--排水溝位置マーク
			--		Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
			else
				--　無線再生
			--	local RadioSet01b = {"Miller_CommonHostageInformation","Miller_XofMarking"}
			--	TppRadio.Play( RadioSet01b )
				GkEventTimerManager.Start( "Timer_HeliCloseDoor_01b", timer )
				-- フラグ更新
				TppMission.SetFlag( "isGetXofMark_Hostage04", true )
				TppMission.SetFlag( "isFinishOnHeliChico", true )
				TppMission.SetFlag( "isFinishOnHeliSpHostage", true )
				TppMission.SetFlag( "isFinishOnHeliHostage04", true )
				-- その他
			--		Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
			end
		--排水溝情報を入手していない
		--ＸＯＦワッペンを入手していない
		elseif ( TppMission.GetFlag( "isGetDuctInfomation" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliSpHostage" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliSpHostage" ) == false )
		and ( TppMission.GetFlag( "isGetXofMark_Hostage04" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliHostage04" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliHostage04" ) == false ) then
			if ( sequence == "Seq_RescueHostages" ) or ( sequence == "Seq_NextRescuePaz" ) then
				--　無線再生
			--	local RadioSet04 = {"Miller_CommonHostageInformation","Miller_AboutDuct01","Miller_JointVoice01","Miller_XofMarking"}
			--	TppRadio.Play( RadioSet04 )
				GkEventTimerManager.Start( "Timer_HeliCloseDoor_04", timer )
				-- フラグ更新
				TppMission.SetFlag( "isGetDuctInfomation", true )
				TppMission.SetFlag( "isGetXofMark_Hostage04", true )
				TppMission.SetFlag( "isFinishOnHeliSpHostage", true )
				TppMission.SetFlag( "isFinishOnHeliHostage04", true )
				-- その他
			--	Duct_MarkerOn()		--排水溝位置マーク
			--	Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
			else
				--　無線再生
			--	local RadioSet04b = {"Miller_CommonHostageInformation","Miller_XofMarking"}
			--	TppRadio.Play( RadioSet04b )
				GkEventTimerManager.Start( "Timer_HeliCloseDoor_04b", timer )
				-- フラグ更新
				TppMission.SetFlag( "isGetXofMark_Hostage04", true )
				TppMission.SetFlag( "isFinishOnHeliHostage04", true )
				-- その他
			--	Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
			end
		--カセットテープを入手していない
		--ＸＯＦワッペンを入手していない
		elseif( TppMission.GetFlag( "isChicoTapeGet" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliChico" ) == false )
		and ( TppMission.GetFlag( "isGetXofMark_Hostage04" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliHostage04" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliHostage04" ) == false ) then
			if ( sequence == "Seq_RescueHostages" ) or ( sequence == "Seq_NextRescuePaz" ) then
				--　無線再生
			--	local RadioSet05 = {"Miller_ChicoTapeAdvice01","Miller_CommonHostageInformation","Miller_XofMarking"}
			--	TppRadio.DelayPlay( RadioSet05, "mid" )
				GkEventTimerManager.Start( "Timer_HeliCloseDoor_05", timer )
				-- フラグ更新
				TppMission.SetFlag( "isChicoTapeGet", true )
				TppMission.SetFlag( "isGetXofMark_Hostage04", true )
				TppMission.SetFlag( "isFinishOnHeliChico", true )
				TppMission.SetFlag( "isFinishOnHeliHostage04", true )
				-- その他
				e20010_require_01.InterrogationAdviceTimerStart()	--尋問促し無線タイマー開始
			--	GetChicoTape()	-- チコテープ入手
			--	Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
			else
				--　無線再生
			--	local RadioSet05b = {"Miller_CommonHostageInformation","Miller_XofMarking"}
			--	TppRadio.Play( RadioSet05b )
				GkEventTimerManager.Start( "Timer_HeliCloseDoor_05b", timer )
				-- フラグ更新
				TppMission.SetFlag( "isGetXofMark_Hostage04", true )
				TppMission.SetFlag( "isFinishOnHeliHostage04", true )
				-- その他
			--	Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
			end
		--カセットテープを入手していない
		--排水溝情報を入手していない
		elseif( TppMission.GetFlag( "isChicoTapeGet" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliChico" ) == false )
		and ( TppMission.GetFlag( "isGetDuctInfomation" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliSpHostage" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliSpHostage" ) == false ) then
			if ( sequence == "Seq_RescueHostages" ) or ( sequence == "Seq_NextRescuePaz" ) then
				--　無線再生
			--	local RadioSet06 = {"Miller_ChicoTapeAdvice01","Miller_CommonHostageInformation","Miller_AboutDuct01"}
			--	TppRadio.DelayPlay( RadioSet06, "mid" )
				GkEventTimerManager.Start( "Timer_HeliCloseDoor_06", timer )
				-- フラグ更新
				TppMission.SetFlag( "isChicoTapeGet", true )
				TppMission.SetFlag( "isGetDuctInfomation", true )
				TppMission.SetFlag( "isFinishOnHeliChico", true )
				TppMission.SetFlag( "isFinishOnHeliSpHostage", true )
				-- その他
				e20010_require_01.InterrogationAdviceTimerStart()	--尋問促し無線タイマー開始
			--	GetChicoTape()	-- チコテープ入手
			--	Duct_MarkerOn()		--排水溝位置マーク
			else
			end
		--ＸＯＦワッペンを入手していない
		elseif ( TppMission.GetFlag( "isGetXofMark_Hostage04" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliHostage04" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliHostage04" ) == false ) then
			--　無線再生
		--	local RadioSet02 = {"Miller_CommonHostageInformation","Miller_XofMarking"}
		--	TppRadio.Play( RadioSet02 )
			GkEventTimerManager.Start( "Timer_HeliCloseDoor_02", timer )
			-- フラグ更新
			TppMission.SetFlag( "isGetXofMark_Hostage04", true )
			TppMission.SetFlag( "isFinishOnHeliHostage04", true )
			-- その他
		--		Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
		--排水溝情報を入手していない
		elseif ( TppMission.GetFlag( "isGetDuctInfomation" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliSpHostage" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliSpHostage" ) == false ) then
			if ( sequence == "Seq_RescueHostages" ) or ( sequence == "Seq_NextRescuePaz" ) then
				--　無線再生
			--	local RadioSet03 = {"Miller_CommonHostageInformation","Miller_AboutDuct01"}
			--	TppRadio.Play( RadioSet03 )
				GkEventTimerManager.Start( "Timer_HeliCloseDoor_03", timer )
				-- フラグ更新
				TppMission.SetFlag( "isGetDuctInfomation", true )
				TppMission.SetFlag( "isFinishOnHeliSpHostage", true )
				-- その他
			--	Duct_MarkerOn()		--排水溝位置マーク
			else
			end
		--カセットテープを入手していない
		elseif ( TppMission.GetFlag( "isChicoTapeGet" ) == false ) and ( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) and ( TppMission.GetFlag( "isFinishOnHeliChico" ) == false ) then
			if ( sequence == "Seq_RescueHostages" ) or ( sequence == "Seq_NextRescuePaz" ) then
				--　無線再生
			--	TppRadio.DelayPlay( "Miller_ChicoTapeAdvice01", "mid" )
				GkEventTimerManager.Start( "Timer_HeliCloseDoor_07", timer )
				-- フラグ更新
				TppMission.SetFlag( "isChicoTapeGet", true )
				TppMission.SetFlag( "isFinishOnHeliChico", true )
				-- その他
			--	GetChicoTape()	-- チコテープ入手
				e20010_require_01.InterrogationAdviceTimerStart()	--尋問促し無線タイマー開始
			else
			end
		end
	end
end
--ヘリの扉が閉まるとき無線
local Radio_HeliCloseDoor = function( setName )
	local RadioSet
	local result = TppStorage.HasXOFEmblem(8)
	Fox.Log("========================================"..setName.."=="..result)

	if( setName == "RadioSet01" ) then
		if ( result == 0 ) then --8番のワッペンを持っていなかったら言う
			RadioSet = {"Miller_CommonHostageInformation","Miller_AboutDuct01","Miller_JointVoice01","Miller_XofMarking"}
			Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
		else
			RadioSet = {"Miller_CommonHostageInformation","Miller_AboutDuct01"}
		end
		Duct_MarkerOn()		--排水溝位置マーク
	elseif( setName == "RadioSet01b" ) then
		if ( result == 0 ) then --8番のワッペンを持っていなかったら言う
			RadioSet = {"Miller_CommonHostageInformation","Miller_XofMarking"}
			Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
		end
	elseif( setName == "RadioSet04" ) then
		if ( result == 0 ) then --8番のワッペンを持っていなかったら言う
			RadioSet = {"Miller_CommonHostageInformation","Miller_AboutDuct01","Miller_JointVoice01","Miller_XofMarking"}
			Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
		else
			RadioSet = {"Miller_CommonHostageInformation","Miller_AboutDuct01"}
		end
		Duct_MarkerOn()		--排水溝位置マーク
	elseif( setName == "RadioSet04b" ) then
		if ( result == 0 ) then --8番のワッペンを持っていなかったら言う
			RadioSet = {"Miller_CommonHostageInformation","Miller_XofMarking"}
			Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
		end
	elseif( setName == "RadioSet05" ) then
		if ( result == 0 ) then --8番のワッペンを持っていなかったら言う
			RadioSet = {"Miller_CommonHostageInformation","Miller_XofMarking"}
			Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
		end
		GetChicoTape()		-- チコテープ入手
	elseif( setName == "RadioSet05b" ) then
		if ( result == 0 ) then --8番のワッペンを持っていなかったら言う
			RadioSet = {"Miller_CommonHostageInformation","Miller_XofMarking"}
			Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
		end
	elseif( setName == "RadioSet06" ) then
		RadioSet = {"Miller_CommonHostageInformation","Miller_AboutDuct01"}
		GetChicoTape()		-- チコテープ入手
		Duct_MarkerOn()		--排水溝位置マーク
	elseif( setName == "RadioSet02" ) then
		if ( result == 0 ) then --8番のワッペンを持っていなかったら言う
			RadioSet = {"Miller_CommonHostageInformation","Miller_XofMarking"}
			Xof_MarkerOn()		--ＸＯＦワッペン位置マーク
		end
	elseif( setName == "RadioSet03" ) then
		RadioSet = {"Miller_CommonHostageInformation","Miller_AboutDuct01"}
		Duct_MarkerOn()		--排水溝位置マーク
	elseif( setName == "RadioSet07" ) then
		GetChicoTape()		-- チコテープ入手
		return
	else
		return
	end

	TppRadio.DelayPlayEnqueue( RadioSet, "mid" , nil , { onEnd = function() AnounceLog_MapUpdate() end }, nil )
end
--通常捕虜01を担いだとき
local Common_NomalHostage01CarryStart = function()

	local status = TppHostageUtility.GetStatus( "Hostage_e20010_001" )

	if( status ~= "Dead" ) then
		TppRadio.Play("Miller_AtherHostageAdvice")
	else
	end
end
--通常捕虜02を担いだとき
local Common_NomalHostage02CarryStart = function()

	local status = TppHostageUtility.GetStatus( "Hostage_e20010_002" )

	if( status ~= "Dead" ) then
		TppRadio.Play("Miller_AtherHostageAdvice")
	else
	end
end
--通常捕虜03を担いだとき
local Common_NomalHostage03CarryStart = function()

	local status = TppHostageUtility.GetStatus( "Hostage_e20010_003" )

	if( status ~= "Dead" ) then
		TppRadio.Play("Miller_AtherHostageAdvice")
	else
	end
end
--通常捕虜04を担いだとき
local Common_NomalHostage04CarryStart = function()

	local status = TppHostageUtility.GetStatus( "Hostage_e20010_004" )

	if( status ~= "Dead" ) then
		TppRadio.Play("Miller_AtherHostageAdvice")
	else
	end
end
--旧収容施設内部パトロール敵兵ルートチェンジトラップ処理
local AsyInsideRouteChange_01 = function()
	TppMission.SetFlag( "isAsyInsideRouteChange_01", true )
end
--トラック移動
local EastCampMoveTruck_Start = function()

	if( TppMission.GetFlag( "isSeq10_02_DriveEnd" ) == 1 ) then
		TppEnemy.EnableRoute( this.cpID , "S_Seq10_03_RideOnTruck" ) 	--ルート有効
		TppEnemy.DisableRoute( this.cpID , "S_Pre_TruckWaiting" )	--ルート無効
		TppEnemy.ChangeRoute( this.cpID , "Seq10_03","e20010_Seq10_SneakRouteSet","S_Seq10_03_RideOnTruck", 0 )	--指定敵兵ルートチェンジ
	else
	end
end
--東難民キャンプ南サーチライトルートチェンジ
local EastCampSouth_SL_RouteChange = function()
	TppEnemy.EnableRoute( this.cpID , "S_SL_EastCamp_South_in" ) 	--ルート有効
	TppEnemy.DisableRoute( this.cpID , "S_SL_EastCamp_South" )	--ルート無効
	TppEnemy.ChangeRoute( this.cpID , "ComEne33","e20010_Seq10_SneakRouteSet","S_SL_EastCamp_South_in", 0 )	--指定敵兵ルートチェンジ
end
--銃チュートリアル敵兵ルートチェンジ
local GunTutorialEnemyRouteChange = function()

	TppEnemy.EnableRoute( this.cpID , "S_GunTutorial_Route" ) 			--ルート有効
	TppEnemy.DisableRoute( this.cpID , "S_Pre_GunTitorial_Waiting" )	--ルート無効
	TppEnemy.ChangeRoute( this.cpID , "ComEne08","e20010_Seq10_SneakRouteSet","S_GunTutorial_Route", 0 )	--指定敵兵ルートチェンジ
end
--トイレ会話敵兵ルートチェンジ
local Talk_AsyWC = function()
	TppEnemy.EnableRoute( this.cpID , "S_RainTalk_ComEne05" ) 	--ルート有効
	TppEnemy.DisableRoute( this.cpID , "S_Pre_RainTalk_a" )	--ルート無効
	TppEnemy.ChangeRoute( this.cpID , "ComEne05","e20010_Seq10_SneakRouteSet","S_RainTalk_ComEne05", 0 )	--指定敵兵ルートチェンジ
end
--チコテープ会話敵兵ルートチェンジ
local Talk_ChicoTape = function()

	TppEnemy.EnableRoute( this.cpID , "S_Talk_ChicoTape" ) 		--ルート有効
	TppEnemy.DisableRoute( this.cpID , "S_Pre_ChikcoTapeTalk_a" )	--ルート無効
	TppEnemy.ChangeRoute( this.cpID , "Seq10_06","e20010_Seq10_SneakRouteSet","S_Talk_ChicoTape",0 )	--指定敵兵ルートチェンジ
end
--脱走捕虜会話敵兵ルートチェンジ
local Talk_EscapeHostage = function()

	TppEnemy.EnableRoute( this.cpID , "S_Talk_EscapeHostage" ) 	--ルート有効
	TppEnemy.DisableRoute( this.cpID , "S_Pre_EscapeHostageTalk_a" )	--ルート無効
	TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq10_SneakRouteSet","S_Talk_EscapeHostage",0 )	--指定敵兵ルートチェンジ
end
--ビークル敵兵ルートチェンジ
local VehicleStart = function()

	if( TppMission.GetFlag( "isEscapeHostage" ) == false ) then
		TppEnemy.EnableRoute( this.cpID , "Seq10_02_RideOnVehicle" )			--ルート有効
		TppEnemy.DisableRoute( this.cpID , "S_Sen_EastCampCenter_East" ) 		--ルート無効
		TppEnemy.ChangeRoute( this.cpID , "Seq10_02","e20010_Seq10_SneakRouteSet","Seq10_02_RideOnVehicle", 0 )	--指定敵兵ルートチェンジ
		TppMission.SetFlag( "isEscapeHostage", true )
	else
	end
end
--管理棟２Ｆ敵兵ルートチェンジ
local Center2F_EneRouteChange = function()

	local sequence = TppSequence.GetCurrentSequence()

	if ( sequence == "Seq_RescueHostages" ) then
		if( TppMission.GetFlag( "isCenter2F_EneRouteChange" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_Mov_Center_2Fto1F" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_c" ) 	--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq10_SneakRouteSet","S_Mov_Center_2Fto1F", 0 )	--指定敵兵ルートチェンジ
			TppMission.SetFlag( "isCenter2F_EneRouteChange", true )
		else
		end
	elseif ( sequence == "Seq_NextRescuePaz" ) then
		if( TppMission.GetFlag( "isCenter2F_EneRouteChange" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_Mov_Center_2Fto1F" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_c" ) 	--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq20_SneakRouteSet","S_Mov_Center_2Fto1F", 0 )	--指定敵兵ルートチェンジ
			TppMission.SetFlag( "isCenter2F_EneRouteChange", true )
		else
		end
	else
	end
end
--[[
--管理棟裏敵兵ルートチェンジ01
local ComEne25RouteChange01 = function()

	local sequence = TppSequence.GetCurrentSequence()

	if ( sequence == "Seq_RescueHostages" ) then
		if( TppMission.GetFlag( "isComEne25RouteChange01" ) == false ) then
			if( TppMission.GetFlag( "isCenterBackEnter" ) == false ) then
				TppEnemy.EnableRoute( this.cpID , "S_Mov_Center_d" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" ) 		--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq10_SneakRouteSet","S_Mov_Center_d", 0 )	--指定敵兵ルートチェンジ
				TppMission.SetFlag( "isComEne25RouteChange01", true )
			else
			end
		else
		end
	elseif ( sequence == "Seq_NextRescuePaz" ) then
		if( TppMission.GetFlag( "isComEne25RouteChange01" ) == false ) then
			if( TppMission.GetFlag( "isCenterBackEnter" ) == false ) then
				TppEnemy.EnableRoute( this.cpID , "S_Mov_Center_d" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" ) 		--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq20_SneakRouteSet","S_Mov_Center_d", 0 )	--指定敵兵ルートチェンジ
				TppMission.SetFlag( "isComEne25RouteChange01", true )
			else
			end
		else
		end
	else
	end
end
--管理棟裏敵兵ルートチェンジ02
local ComEne25RouteChange02 = function()

	local sequence = TppSequence.GetCurrentSequence()

	if ( sequence == "Seq_RescueHostages" ) then
		if( TppMission.GetFlag( "isComEne25RouteChange02" ) == false ) then
			if( TppMission.GetFlag( "isCenterBackEnter" ) == false ) then
				TppEnemy.EnableRoute( this.cpID , "S_Ret_Center_d" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_d" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq10_SneakRouteSet","S_Ret_Center_d", 0 )	--指定敵兵ルートチェンジ
				TppMission.SetFlag( "isComEne25RouteChange02", true )
			else
			end
		else
		end
	elseif ( sequence == "Seq_NextRescuePaz" ) then
		if( TppMission.GetFlag( "isComEne25RouteChange02" ) == false ) then
			if( TppMission.GetFlag( "isCenterBackEnter" ) == false ) then
				TppEnemy.EnableRoute( this.cpID , "S_Ret_Center_d" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_d" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq20_SneakRouteSet","S_Ret_Center_d", 0 )	--指定敵兵ルートチェンジ
				TppMission.SetFlag( "isComEne25RouteChange02", true )
			else
			end
		else
		end
	else
	end
end
--管理棟裏敵兵ルートチェンジ03
local ComEne25RouteChange03 = function()

	local sequence = TppSequence.GetCurrentSequence()

	if ( sequence == "Seq_RescueHostages" ) then
		if( TppMission.GetFlag( "isComEne25RouteChange03" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_Ret_Center_d" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" ) 	--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq10_SneakRouteSet","S_Ret_Center_d", 0 )	--指定敵兵ルートチェンジ
			TppMission.SetFlag( "isComEne25RouteChange03", true )
			TppMission.SetFlag( "isCenterBackEnter", true )
		else
		end
	elseif ( sequence == "Seq_NextRescuePaz" ) then
		if( TppMission.GetFlag( "isComEne25RouteChange03" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_Ret_Center_d" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" ) 	--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq20_SneakRouteSet","S_Ret_Center_d", 0 )	--指定敵兵ルートチェンジ
			TppMission.SetFlag( "isComEne25RouteChange03", true )
			TppMission.SetFlag( "isCenterBackEnter", true )
		else
		end
	else
	end
end
--]]
--管理棟さぼり敵兵ルートチェンジ
local SmokingRouteChange = function()

	local sequence = TppSequence.GetCurrentSequence()

	if ( sequence == "Seq_RescueHostages" ) then
		if( TppMission.GetFlag( "isSmokingRouteChange" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_Mov_Smoking_Center" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_b" ) 	--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq10_SneakRouteSet","S_Mov_Smoking_Center", 0 )	--指定敵兵ルートチェンジ
			TppMission.SetFlag( "isSmokingRouteChange", true )
		else
		end
	elseif ( sequence == "Seq_NextRescuePaz" ) then
		if( TppMission.GetFlag( "isSmokingRouteChange" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_Mov_Smoking_Center" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_b" ) 	--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq20_SneakRouteSet","S_Mov_Smoking_Center", 0 )	--指定敵兵ルートチェンジ
			TppMission.SetFlag( "isSmokingRouteChange", true )
		else
		end
	else
	end
end
--ボイラー敵兵ルートチェンジ
local BoilarEnemyRouteChange = function()

	TppEnemy.EnableRoute( this.cpID , "S_GetOut_Boilar01" )
	TppEnemy.EnableRoute( this.cpID , "S_GetOut_Boilar02" )
	TppEnemy.DisableRoute( this.cpID , "S_WaitingInBoilar_01" )
	TppEnemy.DisableRoute( this.cpID , "S_WaitingInBoilar_02" )
	TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq20_SneakRouteSet","S_GetOut_Boilar01", 0 )
	TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq20_SneakRouteSet","S_GetOut_Boilar02", 0 )
end
--ComEne11ルートチェンジ
local ComEne11_RouteChange = function()

	TppEnemy.EnableRoute( this.cpID , "S_Pat_EastCamp_North" )
	TppEnemy.DisableRoute( this.cpID , "S_Sen_EastCamp_NorthLeftGate" )
	TppEnemy.ChangeRoute( this.cpID , "ComEne11","e20010_Seq20_SneakRouteSet","S_Pat_EastCamp_North", 0 )
end
--巨大ゲート通過敵兵ルートチェンジ
local GateOpenTruckRouteChange = function()
	TppEnemy.EnableRoute( this.cpID , "Seq20_02_RideOnTruck" ) 				--ルート有効
	TppEnemy.DisableRoute( this.cpID , "S_WaitingInTruck" ) 					--ルート無効
	TppEnemy.ChangeRoute( this.cpID , "Seq20_02","e20010_Seq20_SneakRouteSet","Seq20_02_RideOnTruck", 0 )	--指定敵兵ルートチェンジ
end
--海岸調査敵兵ルートチェンジ
local Seaside2manStartRouteChange = function()

	TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide01a" ) 	--ルート有効
	TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide02a" ) 	--ルート有効
	TppEnemy.DisableRoute( this.cpID , "S_Waiting_PC_AsyOut01" ) 	--ルート無効
	TppEnemy.DisableRoute( this.cpID , "S_Waiting_PC_AsyOut02" ) 	--ルート無効
	TppEnemy.ChangeRoute( this.cpID , "Seq20_03","e20010_Seq20_SneakRouteSet","S_Pat_SeaSide02a", 0 )	--指定敵兵ルートチェンジ
	TppEnemy.ChangeRoute( this.cpID , "Seq20_04","e20010_Seq20_SneakRouteSet","S_Pat_SeaSide01a", 0 )	--指定敵兵ルートチェンジ
end
--追跡時倉庫詰め所敵兵ルートチェンジ
local Seq20_05_RouteChange = function()
	TppEnemy.EnableRoute( this.cpID , "OutDoorFromWareHouse" ) 							--ルート有効
	TppEnemy.DisableRoute( this.cpID , "S_Waiting_Seq20_05" )							--ルート無効
	TppEnemy.ChangeRoute( this.cpID , "Seq20_05","e20010_Seq20_SneakRouteSet","OutDoorFromWareHouse",0 )	--指定敵兵ルートチェンジ
end
--処刑捕虜会話敵兵ルートチェンジ
local Talk_KillSpHostage01 = function()

	if ( TppMission.GetFlag( "isQuestionChico" ) == true )
		and ( TppMission.GetFlag( "isKillSpHostageEnemy01" ) == false ) then
		TppEnemy.EnableRoute( this.cpID , "Seq20_04_Talk_KillHostage" ) 					--ルート有効
		TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide01b" )							--ルート無効
		TppEnemy.ChangeRoute( this.cpID , "Seq20_04","e20010_Seq20_SneakRouteSet","Seq20_04_Talk_KillHostage",0 )	--指定敵兵ルートチェンジ
		TppMission.SetFlag( "isKillSpHostageEnemy01", true )
	else
	end
end
--パス確認２マンセルスタート
local Seq30_PazCheck_Start = function()

	TppEnemy.DisableRoute( this.cpID , "S_Pre_PazCheck_Vip" )							--ルート無効
	TppEnemy.DisableRoute( this.cpID , "S_Pre_PazCheck" )							--ルート無効
	TppEnemy.EnableRoute( this.cpID , "GoTo_PazCheck_vip" )
	TppEnemy.EnableRoute( this.cpID , "GoTo_PazCheck" )
	TppEnemy.ChangeRoute( this.cpID , "Seq30_03","e20010_Seq30_SneakRouteSet","GoTo_PazCheck_vip", 0 )
	TppEnemy.ChangeRoute( this.cpID , "Seq30_04","e20010_Seq30_SneakRouteSet","GoTo_PazCheck", 0 )
	--フラグ更新
--	TppMission.SetFlag( "isPazCheckEnemy_Start", true )
end
--パトロールビークルスタート
local Seq30_PatrolVehicle_Start = function()
	TppMission.SetFlag( "isVehicle_Seq30_0506Start" , true )
	TppEnemy.EnableRoute( this.cpID , "Seq30_05_RideOnVehicle" )
	TppEnemy.DisableRoute( this.cpID , "S_Sen_AsylumOutSideGate_c" )
	TppEnemy.ChangeRoute( this.cpID , "Seq30_05","e20010_Seq30_SneakRouteSet","Seq30_05_RideOnVehicle", 0 )
end
--通常捕虜が居る檻をピッキングした時
local Common_NoTargetCagePicking = function()

	local chacterID = TppData.GetArgument( 1 )
	local status01 = TppHostageUtility.GetStatus( "Hostage_e20010_001" )
	local status02 = TppHostageUtility.GetStatus( "Hostage_e20010_002" )
	local status03 = TppHostageUtility.GetStatus( "Hostage_e20010_003" )
	local status04 = TppHostageUtility.GetStatus( "Hostage_e20010_004" )

	if chacterID == "AsyPickingDoor22" then
		if( status01 ~= "Dead" ) then
			TppRadio.Play("Miller_AtherCagePicking")
		else
		end
	elseif chacterID == "AsyPickingDoor21" then
		if( status02 ~= "Dead" ) then
			TppRadio.Play("Miller_AtherCagePicking")
		else
		end
	elseif chacterID == "AsyPickingDoor15" then
		if( status03 ~= "Dead" ) then
			TppRadio.Play("Miller_AtherCagePicking")
			TppHostageManager.GsSetStruggleFlag( "Hostage_e20010_003" , false )
		else
		end
	elseif chacterID == "AsyPickingDoor05" then
		if( status04 ~= "Dead" ) then
			TppRadio.Play("Miller_AtherCagePicking")
			TppHostageManager.GsSetStruggleFlag( "Hostage_e20010_004" , false )
		else
		end
	end
end

--ビハインドしたとき
this.flagchk_LookInTutorialStart = 2  --ビハインドをしたら1.5秒後に覗き込みチュートリアル。無線がなる前にビハインドをやめていたら、最初から2秒後の時点で最初に戻る。
this.flagchk_LookInTutorialEnd	 = 4  --覗き込みチュートリアル再生時～2秒タイマー発動まで。ビハインドし続けている場合、タイマーが発動する前にタイマーリセットされる。
this.flagchk_CoverTutorialPre	 = 5  --2秒タイマー発動時～ビハインドするまで。準備タイマー発動
this.flagchk_CoverTutorialStart  = 6  --ビハインドをしてからカバー攻撃チュートリアルを表示するまで。表示する前にビハインドをやめていたらflagchk_CoverTutorialPreに戻る。
this.flagchk_CoverTutorialEnd	 = 7  --カバー攻撃チュートリアル表示後。ここまできたらおわりです。
local Common_behind = function()

	--スタート崖のフェンスを抜けていたら
	if( TppMission.GetFlag( "isDoCarryAdvice" ) == true ) then

		--武器庫内にいなかったら
		if( TppMission.GetFlag( "isSaftyArea02" ) == false ) then
	--	if( TppMission.GetFlag( "isSaftyArea02" ) == false and
	--		TppMission.GetFlag( "isSaftyArea03" ) == false and
	--		TppMission.GetFlag( "isSaftyArea04" ) == false ) then

			if( TppMission.GetFlag( "isBehindTutorial" ) == 0 ) then
				TppMission.SetFlag( "isBehindTutorial", this.flagchk_LookInTutorialStart )
			--	TppMission.SetFlag( "isBehindTutorial", true )
				local timer = 2
				GkEventTimerManager.Start( "Timer_Behind", timer )

			elseif( TppMission.GetFlag( "isBehindTutorial" ) == this.flagchk_LookInTutorialStart ) then

				local phase = TppEnemy.GetPhase( this.cpID )
				if ( phase == "alert" or phase == "evasion" ) then
				else
					TppRadio.PlayEnqueue( "Miller_CoverTutorial", {
						onStart = function() e20010_require_01.Tutorial_1Button("tutorial_look_in","PL_STOCK")
						TppMission.SetFlag( "isBehindTutorial", this.flagchk_LookInTutorialEnd )
						GkEventTimerManager.Stop( "Timer_Behind" )
						local timer = 2
						GkEventTimerManager.Start( "Timer_Behind", timer )
					end })
				end
			elseif( TppMission.GetFlag( "isBehindTutorial" ) == this.flagchk_LookInTutorialEnd ) then
				GkEventTimerManager.Stop( "Timer_Behind" )
				local timer = 2
				GkEventTimerManager.Start( "Timer_Behind", timer )

			elseif( TppMission.GetFlag( "isBehindTutorial" ) == this.flagchk_CoverTutorialPre ) then
				local timer = 2
				GkEventTimerManager.Start( "Timer_Behind", timer )
				TppMission.SetFlag( "isBehindTutorial", this.flagchk_CoverTutorialStart )

			elseif( TppMission.GetFlag( "isBehindTutorial" ) == this.flagchk_CoverTutorialStart ) then
				GkEventTimerManager.Stop( "Timer_Behind" )
				e20010_require_01.Tutorial_2Button( "tutorial_cover_attack", "PL_HOLD", "PL_SHOT" )
				TppMission.SetFlag( "isBehindTutorial", this.flagchk_CoverTutorialEnd )
			end
		end
	end

end
--ビハインド用タイマーのカウントが終わったとき
local TimerBehindCount = function()
	if( TppMission.GetFlag( "isBehindTutorial" ) == this.flagchk_LookInTutorialStart ) then
		TppMission.SetFlag( "isBehindTutorial", 0 )
	elseif( TppMission.GetFlag( "isBehindTutorial" ) == this.flagchk_LookInTutorialEnd) then
		TppMission.SetFlag( "isBehindTutorial", this.flagchk_CoverTutorialPre )
	elseif( TppMission.GetFlag( "isBehindTutorial" ) == this.flagchk_CoverTutorialStart ) then
		TppMission.SetFlag( "isBehindTutorial", this.flagchk_CoverTutorialPre )
	end
end

local Timer_SwitchOFF = function()
	TppDataUtility.SetEnableDataFromIdentifier( "gntn_Trap", "SwitchLightArea", true , false )
end
local Timer_takePazToRVPoint01_OnEnd = function()
	local sequence = TppSequence.GetCurrentSequence()
	if ( sequence == "Seq_NextRescueChico" ) then
		TppRadio.DelayPlay("Miller_takePazToRVPoint01", "mid")
	elseif ( sequence == "Seq_ChicoPazToRV" ) then
		TppRadio.DelayPlay("Miller_takePazOnHeli", "mid")
	else
	end
end
--敵兵を見た
local Common_enemyIntel = function(id)

	local radioDaemon = RadioDaemon:GetInstance()
	local status = TppEnemyUtility.GetStatus( id )			-- 敵兵の状態を取得する
	local aiStatus = TppEnemyUtility.GetAiStatus( id )		-- 敵兵のＡＩ状態を取得する
	local lifeStatus = TppEnemyUtility.GetLifeStatus( id )	-- 敵兵のライフ状態を取得する
	local routeId = TppEnemyUtility.GetRouteId( id )		-- 敵兵のルートIDを取得する
	local phase = TppEnemy.GetPhase( this.cpID )			-- フェイズ取得

	Fox.Log( "=== statas ===" .. id .. " === " .. aiStatus .. " === " .. routeId .. " === " .. status )

	--リアルタイム無線再生
	local espRadioPlay = function()
		local radioDaemon = RadioDaemon:GetInstance()
		if ( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0660") == false ) then	--↓を再生していなければ
			if( TppMission.GetFlag( "isEncounterChico" ) == false and TppMission.GetFlag( "isEncounterPaz" ) == false ) then
				TppRadio.DelayPlayEnqueue( "Miller_EspionageRadioAdvice", "short" )					--e0010_rtrg0660
			end
		elseif( TppMission.GetFlag( "isDoCarryAdvice" ) == true ) then			--スタート崖を抜けていれば
			if( lifeStatus == "Dead" ) then
			else
				if( TppMission.GetFlag( "isEncounterChico" ) == false and TppMission.GetFlag( "isEncounterPaz" ) == false ) then
					TppRadio.DelayPlayEnqueue("Miller_MarkingTutorial", "short" )
				end
			end
		end
	end

	if lifeStatus == "Normal" and (status == "HoldUp") == false then
		if	(routeId == GsRoute.GetRouteId("S_Sen_AsylumOutSideGate_a")
			or routeId == GsRoute.GetRouteId("S_Sen_AsylumOutSideGate_b") )
			and ( phase == "neutral" or phase == "sneak" ) then
			--　旧収容所前ルートにいるとき
			TppRadio.RegisterIntelRadio( id, "e0010_esrg0370", true )	--対象の諜報無線を変更
			espRadioPlay()										--リアルタイム無線再生

		elseif (routeId == GsRoute.GetRouteId("S_Pat_AsylumInside_Ver01")
			or routeId == GsRoute.GetRouteId("S_Pat_AsylumInside_Ver02")
			or routeId == GsRoute.GetRouteId("S_Pat_AsylumInside_Ver03"))
			and ( phase == "neutral" or phase == "sneak" ) then
			--　旧収容所内ルートにいるとき
			TppRadio.RegisterIntelRadio( id, "e0010_esrg0360", true )	--対象の諜報無線を変更
			espRadioPlay()										--リアルタイム無線再生

		elseif aiStatus == "Conversation" then
			-- 会話中
	--	Fox.Log( "Conversation" )
			TppRadio.RegisterIntelRadio( id, "e0010_esrg0310", true )	--対象の諜報無線を変更

			--リアルタイム無線再生（会話中専用分岐）
			if ( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0660") == false ) then
				if( TppMission.GetFlag( "isEncounterChico" ) == false and TppMission.GetFlag( "isEncounterPaz" ) == false ) then
					TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" )
				end
			else
			--	TppRadio.Play( "Miller_EnemyIntelAdvice" )
			end

		else
			-- ルート移動中
	--	Fox.Log( "RouteMove" )
			TppRadio.RegisterIntelRadio( id, "e0010_esrg0170", true )	--対象の諜報無線を変更（デフォルト）
			espRadioPlay()										--リアルタイム無線再生
		end
	else	-- 相手が通常状態でない
			TppRadio.RegisterIntelRadio( id, "e0010_esrg0171", true )	--対象の諜報無線を変更（デフォルト）
			espRadioPlay()										--リアルタイム無線再生
	end
end
--ルートチェンジ系ギミック破壊
local Common_Gimmick_Break = function()

	local gimmick	= TppData.GetArgument( 1 )			-- ギミックＩＤ取得

	-- スタート崖木製ヤグラ
	if ( gimmick == "WoodTurret01" ) then
		TppMission.SetFlag( "isWoodTurret01_Break", true )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "WoodTurret_RainFilter01", false , false )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret01_Route" , "S_SL_StartCliff" )
	-- スタート崖木製ヤグラのサーチライト
	elseif ( gimmick == "SL_WoodTurret01" ) then
		TppMission.SetFlag( "isWoodTurret01_Break", true )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret01_Route" , "S_SL_StartCliff" )
	--東難民キャンプ（南）ヤグラ破壊
	elseif ( gimmick == "WoodTurret02" ) then
		TppMission.SetFlag( "isWoodTurret02_Break", true )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "WoodTurret_RainFilter03", false , false )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret02_Route" , "S_SL_EastCamp_South" )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret02_Route" , "S_SL_EastCamp_South_in" )
	--東難民キャンプ（南）ヤグラサーチライト破壊
	elseif ( gimmick == "SL_WoodTurret02" ) then
		TppMission.SetFlag( "isWoodTurret02_Break", true )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret02_Route" , "S_SL_EastCamp_South" )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret02_Route" , "S_SL_EastCamp_South_in" )
	--東難民キャンプ（北）ヤグラ破壊
	elseif ( gimmick == "WoodTurret03" ) then
		TppMission.SetFlag( "isWoodTurret03_Break", true )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "WoodTurret_RainFilter04", false , false )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret03_Route" , "S_SL_EastCamp_North" )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret03_Route" , "S_Pre_RainTalk_b" )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret03_Route" , "S_GoTo_EastCampNorthTower" )
	--東難民キャンプ（北）ヤグラサーチライト破壊
	elseif ( gimmick == "SL_WoodTurret03" ) then
		TppMission.SetFlag( "isWoodTurret03_Break", true )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret03_Route" , "S_SL_EastCamp_North" )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret03_Route" , "S_Pre_RainTalk_b" )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret03_Route" , "S_GoTo_EastCampNorthTower" )
	--西難民キャンプヤグラ破壊
	elseif ( gimmick == "WoodTurret04" ) then
		TppMission.SetFlag( "isWoodTurret04_Break", true )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "WoodTurret_RainFilter02", false , false )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret04_Route" , "S_SL_WestCamp" )
	--西難民キャンプヤグラサーチライト破壊
	elseif ( gimmick == "SL_WoodTurret04" ) then
		TppMission.SetFlag( "isWoodTurret04_Break", true )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret04_Route" , "S_SL_WestCamp" )
	--旧収容施設ヤグラ破壊
	elseif ( gimmick == "WoodTurret05" ) then
		TppMission.SetFlag( "isWoodTurret05_Break", true )
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "WoodTurret_RainFilter05", false , false )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret05_Route" , "S_SL_Asylum" )
	--旧収容施設ヤグラサーチライト破壊
	elseif ( gimmick == "SL_WoodTurret05" ) then
		TppMission.SetFlag( "isWoodTurret05_Break", true )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_WoodTurret05_Route" , "S_SL_Asylum" )
	--倉庫南エリア鉄製ヤグラのサーチライト
	elseif ( gimmick == "gntn_area01_searchLight_001" ) then
		TppMission.SetFlag( "isIronTurretSL01_Break", true )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_IronTurretSL01_Route" , "S_SL_WareHouse01a" )
	--倉庫北エリア鉄製ヤグラのサーチライト
	elseif ( gimmick == "gntn_area01_searchLight_002" ) then
		TppMission.SetFlag( "isIronTurretSL02_Break", true )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_IronTurretSL02_Route" , "S_SL_WareHouse02a" )
	--ヘリポート鉄製ヤグラ、巨大ゲート照射のサーチライト
	elseif ( gimmick == "gntn_area01_searchLight_004" ) then
		TppMission.SetFlag( "isIronTurretSL04_Break", true )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_IronTurretSL04_Route" , "S_SL_HeliPortTurret02" )
	--ヘリポート鉄製ヤグラ、ヘリポート照射のサーチライト
	elseif ( gimmick == "gntn_area01_searchLight_005" ) then
		TppMission.SetFlag( "isIronTurretSL05_Break", true )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_IronTurretSL05_Route" , "S_SL_HeliPortTurret01" )
	--ヘリポート監視塔のサーチライト
	elseif ( gimmick == "gntn_area01_searchLight_006" ) then
		TppMission.SetFlag( "isCenterTowerSL_Break", true )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID , "Break_CenterTower_Route" , "S_SL_HeliPortTower" )
	end
end
--倉庫武器庫近く対空機関砲破壊時
local Common_AAG01_Break = function()
	TppRadio.DelayPlayEnqueue("Miller_BreakAAG", "mid")
end
--ヘリポート前対空機関砲破壊時
local Common_AAG02_Break = function()
	TppRadio.DelayPlayEnqueue("Miller_BreakAAG", "mid")
end
--ヘリポート東対空機関砲破壊時
local Common_AAG03_Break = function()
	TppRadio.DelayPlayEnqueue("Miller_BreakAAG", "mid")
end
--ヘリポート西対空機関砲破壊
local Common_AAG04_Break = function()
	TppRadio.DelayPlayEnqueue("Miller_BreakAAG", "mid")
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 車輌設定
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 先チコ登場車輌（前半）
local FirstChico_Vehicle_01 = function()
	-- 必須車輌
	TppData.Enable( "Cargo_Truck_WEST_004" )		-- １：巨大ゲートを通過するトラック
	TppData.Enable( "Armored_Vehicle_WEST_001" )	-- ２：ヘリポートに止めている機銃装甲車
	-- 準車輌（消えてるかも知れない車輌）
	TppData.Enable( "Cargo_Truck_WEST_002" )		-- ３：秘密兵器を運ぶトラック
	-- 前シーケンスでＰＣが使用していなかったら消える車輌
	if( TppMission.GetFlag( "isSeq10_02_DriveEnd" ) == 2 ) then	-- ４：スタート崖ビークル
	else
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_002" }
		TppData.Disable("Tactical_Vehicle_WEST_002")
	end
	if( TppMission.GetFlag( "isSeq10_03_DriveEnd" ) == 2 ) then	-- ５：パトロールトラック
	else
		TppMarkerSystem.DisableMarker{ markerId = "Cargo_Truck_WEST_003" }
		TppData.Disable("Cargo_Truck_WEST_003")
	end
	-- スタンバイ
	TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_003" }
	TppData.Disable( "Tactical_Vehicle_WEST_003" )	-- 旧収容施設からくるビークル
	TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_004" }
	TppData.Disable( "Tactical_Vehicle_WEST_004" )	-- パス確認兵士が使っていたと思われるビークル
	TppMarkerSystem.DisableMarker{ markerId = "Armored_Vehicle_WEST_003" }
	TppData.Disable( "Armored_Vehicle_WEST_003" )	-- ヘリポートに登場する機銃装甲車
	-- このシーケンスでは絶対に出てこない車輌
	TppMarkerSystem.DisableMarker{ markerId = "Armored_Vehicle_WEST_002" }
	TppData.Disable( "Armored_Vehicle_WEST_002" )	-- ミッション圏外から来る機銃装甲車
	TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_005" }
	TppData.Disable( "Tactical_Vehicle_WEST_005" )	-- 旧収容施設に向かうビークル
end
-- 先チコ登場車輌（後半）
local FirstChico_Vehicle_02 = function()
	-- 必須車輌
	TppData.Enable( "Cargo_Truck_WEST_004" )		-- １：巨大ゲートを通過するトラック
	TppData.Enable( "Armored_Vehicle_WEST_001" )	-- ２：ヘリポートに止めている機銃装甲車
	TppData.Enable( "Armored_Vehicle_WEST_003" )	-- ３：ヘリポートに登場する機銃装甲車
	-- 準車輌（消えてるかも知れない車輌）
	TppData.Enable( "Cargo_Truck_WEST_002" )		-- ４：秘密兵器を運ぶトラック
	-- 前シーケンスでＰＣが使用していなかったら入れ替える車輌
	if( TppMission.GetFlag( "isSeq10_02_DriveEnd" ) == 2 ) then	-- ５：スタート崖ビークル
		TppEnemyUtility.SetEnableCharacterId( "Seq30_05" , false )
	else
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_002" }
		TppData.Disable("Tactical_Vehicle_WEST_002")
		TppData.Enable( "Tactical_Vehicle_WEST_003" )			-- ５：旧収容施設からくるビークル
	end
	if( TppMission.GetFlag( "isSeq10_03_DriveEnd" ) == 2 ) then	-- ６：パトロールトラック
	else
		TppMarkerSystem.DisableMarker{ markerId = "Cargo_Truck_WEST_003" }
		TppData.Disable("Cargo_Truck_WEST_003")
		TppData.Enable( "Tactical_Vehicle_WEST_004" )			-- ６：パス確認兵士が使っていたと思われるビークル
	end
	-- このシーケンスでは絶対に出てこない車輌
	TppMarkerSystem.DisableMarker{ markerId = "Armored_Vehicle_WEST_002" }
	TppData.Disable( "Armored_Vehicle_WEST_002" )	-- ミッション圏外から来る機銃装甲車
	TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_005" }
	TppData.Disable( "Tactical_Vehicle_WEST_005" )	-- 旧収容施設に向かうビークル
end
-- 先パス登場車輌
local FirstPaz_Vehicle = function()
	-- 必須車輌
	TppData.Enable( "Tactical_Vehicle_WEST_005" )	-- １：旧収容施設に向かうビークル
	TppData.Enable( "Armored_Vehicle_WEST_002" )	-- ２：ミッション圏外から来る機銃装甲車
	TppData.Enable( "Armored_Vehicle_WEST_001" )	-- ３：ヘリポートに止めている機銃装甲車
	-- 準車輌（消えてるかも知れない車輌）
	TppData.Enable( "Cargo_Truck_WEST_002" )		-- ４：秘密兵器を運ぶトラック
	-- 前シーケンスでＰＣが使用していなかったら消える車輌
	if( TppMission.GetFlag( "isSeq10_02_DriveEnd" ) == 2 ) then	-- ５：スタート崖ビークル
	else
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_002" }
		TppData.Disable("Tactical_Vehicle_WEST_002")
	end
	if( TppMission.GetFlag( "isSeq10_03_DriveEnd" ) == 2 ) then	-- ６：パトロールトラック
	else
		TppMarkerSystem.DisableMarker{ markerId = "Cargo_Truck_WEST_003" }
		TppData.Disable("Cargo_Truck_WEST_003")
	end
	-- 先パスでは登場しない車輌
	TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_003" }
	TppData.Disable( "Tactical_Vehicle_WEST_003" )	-- 旧収容施設からくるビークル
	TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_004" }
	TppData.Disable( "Tactical_Vehicle_WEST_004" )	-- パス確認兵士が使っていたと思われるビークル
	TppMarkerSystem.DisableMarker{ markerId = "Armored_Vehicle_WEST_003" }
	TppData.Disable( "Armored_Vehicle_WEST_003" )	-- ヘリポートに登場する機銃装甲車
	TppMarkerSystem.DisableMarker{ markerId = "Cargo_Truck_WEST_004" }
	TppData.Disable( "Cargo_Truck_WEST_004" )		-- 巨大ゲートを通過するトラック
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- チコパス回収デモ後チェックポイント復帰処理
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ChicoPazQustionDemoAfterReStart = function()
	local sequence = TppSequence.GetCurrentSequence()
	-- 復帰箇所指定 --------------------------------------------------------------------
	if( TppMission.GetFlag( "isSaftyArea01" ) == true ) then
		TppMissionManager.SaveGame("40")		--回収デモ後セーブ：海岸ＲＶ
--[[	elseif( TppMission.GetFlag( "isSaftyArea02" ) == true ) then
		TppMissionManager.SaveGame("41")		--回収デモ後セーブ：倉庫武器庫セーブ
	elseif( TppMission.GetFlag( "isSaftyArea03" ) == true ) then
		TppMissionManager.SaveGame("43")		--回収デモ後セーブ：管理棟武器庫セーブ
	elseif( TppMission.GetFlag( "isSaftyArea04" ) == true ) then
		TppMissionManager.SaveGame("42")		--回収デモ後セーブ：ヘリポート武器庫セーブ
--]]
	else
		--何もしない（地形依存チェックポイントから復帰）
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- チコの扉ＯＮ/ＯＦＦ
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- チコ檻非表示
local ChicoDoor_OFF = function()
	TppGadgetUtility.SetDoor{ id = "AsyPickingDoor24", isVisible = false, isEnableBounder = true, isEnableTacticalActionEdge = false , angle = 0, isOpen = false }
end
-- チコ檻表示開錠=タクティカルパスＯＮ
local ChicoDoor_ON_Open = function()
	TppGadgetUtility.SetDoor{ id = "AsyPickingDoor24", isVisible = true, isEnableBounder = true, isEnableTacticalActionEdge = true , angle = 270, isOpen = true }
end
-- チコ檻表示施錠=タクティカルパスＯＦＦ
local ChicoDoor_ON_Close = function()
	TppGadgetUtility.SetDoor{ id = "AsyPickingDoor24", isVisible = true, isEnableBounder = true, isEnableTacticalActionEdge = false , angle = 0, isOpen = false }
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- パスの扉ＯＮ/ＯＦＦ
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- パス檻非表示
local PazDoor_OFF = function()
	TppGadgetUtility.SetDoor{ id = "Paz_PickingDoor00", isVisible = false, isEnableBounder = true, isEnableTacticalActionEdge = false , angle = 0, isOpen = false }
end
-- パス檻表示開錠=タクティカルパスＯＮ
local PazDoor_ON_Open = function()
	TppGadgetUtility.SetDoor{ id = "Paz_PickingDoor00", isVisible = true, isEnableBounder = true, isEnableTacticalActionEdge = true , angle = 270, isOpen = true }
end
-- チコ檻表示施錠=タクティカルパスＯＦＦ
local PazDoor_ON_Close = function()
	TppGadgetUtility.SetDoor{ id = "Paz_PickingDoor00", isVisible = true, isEnableBounder = true, isEnableTacticalActionEdge = false , angle = 0, isOpen = false }
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 停電後処理
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
local After_SwitchOff = function()

	local sequence = TppSequence.GetCurrentSequence()

	GkEventTimerManager.Start( "Timer_SwitchOFF", 0.75 )
	-- 管理棟内全監視カメラ無効化
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20010_SecurityCamera_02", false )
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20010_SecurityCamera_03", false )
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20010_SecurityCamera_04", false )
	-- 停電ルートチェンジ
	if ( sequence == "Seq_RescueHostages" ) then				-- 10
		--ComEne25
--		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne25RouteChange01", false , false )
--		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne25RouteChange02", false , false )
--		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne25RouteChange03", false , false )
		TppEnemy.EnableRoute( this.cpID , "ComEne25_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" )
		TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_d" )
		TppEnemy.DisableRoute( this.cpID , "S_Ret_Center_d" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne256","e20010_Seq10_SneakRouteSet","ComEne25_SwitchOFF", 0 )
		--ComEne26
		TppEnemy.EnableRoute( this.cpID , "ComEne26_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_a" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq10_SneakRouteSet","ComEne26_SwitchOFF", 0 )
		--ComEne27
		TppEnemy.EnableRoute( this.cpID , "ComEne27_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_BoilarFront" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq10_SneakRouteSet","ComEne27_SwitchOFF", 0 )
		--ComEne28
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "SmokingRouteChange", false , false )
		TppEnemy.EnableRoute( this.cpID , "ComEne28_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_b" )
		TppEnemy.DisableRoute( this.cpID , "S_Mov_Smoking_Center" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq10_SneakRouteSet","ComEne28_SwitchOFF", 0 )
		--ComEne29
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Center2F_EneRouteChange", false , false )
		TppEnemy.EnableRoute( this.cpID , "ComEne29_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_c" )
		TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_2Fto1F" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq10_SneakRouteSet","ComEne29_SwitchOFF", 0 )
	elseif ( sequence == "Seq_NextRescuePaz" ) then				-- 20
		--ComEne25
		TppEnemy.EnableRoute( this.cpID , "ComEne25_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne256","e20010_Seq20_SneakRouteSet","ComEne25_SwitchOFF", 0 )
		--ComEne26
		TppEnemy.EnableRoute( this.cpID , "ComEne26_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_a" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq20_SneakRouteSet","ComEne26_SwitchOFF", 0 )
		--ComEne27
		TppEnemy.EnableRoute( this.cpID , "ComEne27_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_BoilarFront" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq20_SneakRouteSet","ComEne27_SwitchOFF", 0 )
		--ComEne28
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "SmokingRouteChange", false , false )
		TppEnemy.EnableRoute( this.cpID , "ComEne28_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_b" )
		TppEnemy.DisableRoute( this.cpID , "S_Mov_Smoking_Center" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq20_SneakRouteSet","ComEne28_SwitchOFF", 0 )
		--ComEne29
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Center2F_EneRouteChange", false , false )
		TppEnemy.EnableRoute( this.cpID , "ComEne29_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_c" )
		TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_2Fto1F" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq20_SneakRouteSet","ComEne29_SwitchOFF", 0 )
		--ComEne31
		TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF_v3" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_f" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq20_SneakRouteSet","ComEne31_SwitchOFF_v3",0 )
		--ComEne32
		TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF_v2" )
		TppEnemy.DisableRoute( this.cpID , "S_TalkingDelatetape_After02" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq20_SneakRouteSet","ComEne31_SwitchOFF_v2",0 )
	elseif ( sequence == "Seq_NextRescueChico" ) or ( sequence == "Seq_PazChicoToRV" ) then		-- 40 or 50
		--ComEne24
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne24_RouteChange", false , false )
		TppEnemy.EnableRoute( this.cpID , "ComEne24_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortBigGate" )
		TppEnemy.DisableRoute( this.cpID , "GoToCenterB_2F_02" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterB_2F" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne24","e20010_Seq40_SneakRouteSet","ComEne24_SwitchOFF", 0 )
		--ComEne25
		TppEnemy.EnableRoute( this.cpID , "ComEne25_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq40_SneakRouteSet","ComEne25_SwitchOFF", 0 )
		--ComEne26
		TppEnemy.EnableRoute( this.cpID , "ComEne26_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_a" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq40_SneakRouteSet","ComEne26_SwitchOFF", 0 )
		--ComEne27
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq40_ComEne27_RouteChange", false , false )
		TppEnemy.EnableRoute( this.cpID , "ComEne27_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterBack" )
		TppEnemy.DisableRoute( this.cpID , "S_GoTo_BoilarFront" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_BoilarFront" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq40_SneakRouteSet","ComEne27_SwitchOFF", 0 )
		--ComEne28
		TppEnemy.EnableRoute( this.cpID , "ComEne28_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Mov_Smoking_Center" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq40_SneakRouteSet","ComEne28_SwitchOFF", 0 )
		--ComEne29
		TppEnemy.EnableRoute( this.cpID , "ComEne29_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_e" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq40_SneakRouteSet","ComEne29_SwitchOFF", 0 )
		--ComEne31
		TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF_v2" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_Middle2" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq40_SneakRouteSet","ComEne31_SwitchOFF_v2", 0 )
		--ComEne32
		TppEnemy.EnableRoute( this.cpID , "ComEne32_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_Middle" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq40_SneakRouteSet","ComEne32_SwitchOFF", 0 )
	elseif ( sequence == "Seq_ChicoPazToRV" ) then				-- 30
		--ComEne25
		TppEnemy.EnableRoute( this.cpID , "ComEne25_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne256","e20010_Seq30_SneakRouteSet","ComEne25_SwitchOFF", 0 )
		--ComEne26
		TppEnemy.EnableRoute( this.cpID , "ComEne26_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_a" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq30_SneakRouteSet","ComEne26_SwitchOFF", 0 )
		--ComEne27
		TppEnemy.EnableRoute( this.cpID , "ComEne27_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_BoilarFront" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq30_SneakRouteSet","ComEne27_SwitchOFF", 0 )
		--ComEne28
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "SmokingRouteChange", false , false )
		TppEnemy.EnableRoute( this.cpID , "ComEne28_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_b" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq30_SneakRouteSet","ComEne28_SwitchOFF", 0 )
		--ComEne29
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Center2F_EneRouteChange", false , false )
		TppEnemy.EnableRoute( this.cpID , "ComEne29_SwitchOFF" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_e" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq30_SneakRouteSet","ComEne29_SwitchOFF", 0 )
		--ComEne31
		TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF_v3" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_f" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq30_SneakRouteSet","ComEne31_SwitchOFF_v3",0 )
	else
		if( TppMission.GetFlag( "isFirstEncount_Chico" ) == true ) then		-- 30
			--ComEne25
			TppEnemy.EnableRoute( this.cpID , "ComEne25_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne256","e20010_Seq30_SneakRouteSet","ComEne25_SwitchOFF", 0 )
			--ComEne26
			TppEnemy.EnableRoute( this.cpID , "ComEne26_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_a" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq30_SneakRouteSet","ComEne26_SwitchOFF", 0 )
			--ComEne27
			TppEnemy.EnableRoute( this.cpID , "ComEne27_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_BoilarFront" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq30_SneakRouteSet","ComEne27_SwitchOFF", 0 )
			--ComEne28
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "SmokingRouteChange", false , false )
			TppEnemy.EnableRoute( this.cpID , "ComEne28_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_b" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq30_SneakRouteSet","ComEne28_SwitchOFF", 0 )
			--ComEne29
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Center2F_EneRouteChange", false , false )
			TppEnemy.EnableRoute( this.cpID , "ComEne29_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_e" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq30_SneakRouteSet","ComEne29_SwitchOFF", 0 )
			--ComEne31
			TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF_v3" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_f" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq30_SneakRouteSet","ComEne31_SwitchOFF_v3",0 )
		else	-- 50
			--ComEne24
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne24_RouteChange", false , false )
			TppEnemy.EnableRoute( this.cpID , "ComEne24_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortBigGate" )
			TppEnemy.DisableRoute( this.cpID , "GoToCenterB_2F_02" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterB_2F" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne24","e20010_Seq40_SneakRouteSet","ComEne24_SwitchOFF", 0 )
			--ComEne25
			TppEnemy.EnableRoute( this.cpID , "ComEne25_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq40_SneakRouteSet","ComEne25_SwitchOFF", 0 )
			--ComEne26
			TppEnemy.EnableRoute( this.cpID , "ComEne26_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_a" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq40_SneakRouteSet","ComEne26_SwitchOFF", 0 )
			--ComEne27
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq40_ComEne27_RouteChange", false , false )
			TppEnemy.EnableRoute( this.cpID , "ComEne27_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterBack" )
			TppEnemy.DisableRoute( this.cpID , "S_GoTo_BoilarFront" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_BoilarFront" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq40_SneakRouteSet","ComEne27_SwitchOFF", 0 )
			--ComEne28
			TppEnemy.EnableRoute( this.cpID , "ComEne28_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Mov_Smoking_Center" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq40_SneakRouteSet","ComEne28_SwitchOFF", 0 )
			--ComEne29
			TppEnemy.EnableRoute( this.cpID , "ComEne29_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_e" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq40_SneakRouteSet","ComEne29_SwitchOFF", 0 )
			--ComEne31
			TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF_v2" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_Middle2" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq40_SneakRouteSet","ComEne31_SwitchOFF_v2", 0 )
			--ComEne32
			TppEnemy.EnableRoute( this.cpID , "ComEne32_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_Middle" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq40_SneakRouteSet","ComEne32_SwitchOFF", 0 )
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 配電盤スイッチライトＯＮ/ＯＦＦ
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ON
local SwitchLight_ON = function()

	local sequence = TppSequence.GetCurrentSequence()

	-- 敵兵停電ノーティストラップＯＦＦ
	TppDataUtility.SetEnableDataFromIdentifier( "gntn_Trap", "SwitchLightArea", false , false )
	-- 管理棟内、全監視カメラ無力化
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20010_SecurityCamera_02", true )
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20010_SecurityCamera_03", true )
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20010_SecurityCamera_04", true )
	-- 復帰時ルートチェンジ
	if ( sequence == "Seq_RescueHostages" ) then				-- 10
		--ComEne25
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" )
		TppEnemy.DisableRoute( this.cpID , "ComEne25_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq10_SneakRouteSet","S_Sen_Center_d", 0 )
		--ComEne26
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_a" )
		TppEnemy.DisableRoute( this.cpID , "ComEne26_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq10_SneakRouteSet","S_Sen_Center_a", 0 )
		--ComEne27
		TppEnemy.EnableRoute( this.cpID , "S_Sen_BoilarFront" )
		TppEnemy.DisableRoute( this.cpID , "ComEne27_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq10_SneakRouteSet","S_Sen_BoilarFront", 0 )
		--ComEne28
		TppEnemy.EnableRoute( this.cpID , "S_Mov_Smoking_Center" )
		TppEnemy.DisableRoute( this.cpID , "ComEne28_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq10_SneakRouteSet","S_Mov_Smoking_Center", 0 )
		--ComEne29
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_e" )
		TppEnemy.DisableRoute( this.cpID , "ComEne29_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq10_SneakRouteSet","S_Sen_Center_e", 0 )
		--ComEne31
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_b" )
		TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq10_SneakRouteSet","S_Sen_Boilar_b",0 )
	elseif ( sequence == "Seq_NextRescuePaz" ) then				-- 20
		--ComEne25
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" )
		TppEnemy.DisableRoute( this.cpID , "ComEne25_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq20_SneakRouteSet","S_Sen_Center_d", 0 )
		--ComEne26
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_a" )
		TppEnemy.DisableRoute( this.cpID , "ComEne26_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq20_SneakRouteSet","S_Sen_Center_a", 0 )
		--ComEne27
		TppEnemy.EnableRoute( this.cpID , "S_Sen_BoilarFront" )
		TppEnemy.DisableRoute( this.cpID , "ComEne27_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq20_SneakRouteSet","S_Sen_BoilarFront", 0 )
		--ComEne28
		TppEnemy.EnableRoute( this.cpID , "S_Mov_Smoking_Center" )
		TppEnemy.DisableRoute( this.cpID , "ComEne28_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq20_SneakRouteSet","S_Mov_Smoking_Center", 0 )
		--ComEne29
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_e" )
		TppEnemy.DisableRoute( this.cpID , "ComEne29_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq20_SneakRouteSet","S_Sen_Center_e", 0 )
		--ComEne31
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_f" )
		TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF_v3" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq20_SneakRouteSet","S_Sen_Center_f",0 )
		--ComEne32
		TppEnemy.EnableRoute( this.cpID , "S_TalkingDelatetape_After02" )
		TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF_v2" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq20_SneakRouteSet","S_TalkingDelatetape_After02",0 )
	elseif ( sequence == "Seq_NextRescueChico" ) or ( sequence == "Seq_PazChicoToRV" ) then			-- 40
		--ComEne24
		TppEnemy.EnableRoute( this.cpID , "S_Sen_CenterB_2F" )
		TppEnemy.DisableRoute( this.cpID , "ComEne24_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne24","e20010_Seq40_SneakRouteSet","S_Sen_CenterB_2F",0 )	--指定敵兵ルートチェンジ
		--ComEne25
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" )
		TppEnemy.DisableRoute( this.cpID , "ComEne25_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne24","e20010_Seq40_SneakRouteSet","S_Sen_Center_d",0 )	--指定敵兵ルートチェンジ
		--ComEne26
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_a" )
		TppEnemy.DisableRoute( this.cpID , "ComEne26_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq40_SneakRouteSet","S_Sen_Center_a",0 )	--指定敵兵ルートチェンジ
		--ComEne27
		TppEnemy.EnableRoute( this.cpID , "S_Sen_BoilarFront" )
		TppEnemy.DisableRoute( this.cpID , "ComEne27_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq40_SneakRouteSet","S_Sen_BoilarFront",0 )	--指定敵兵ルートチェンジ
		--ComEne28
		TppEnemy.EnableRoute( this.cpID , "S_Mov_Smoking_Center" )
		TppEnemy.DisableRoute( this.cpID , "ComEne28_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq40_SneakRouteSet","S_Mov_Smoking_Center", 0 )
		--ComEne29
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_e" )
		TppEnemy.DisableRoute( this.cpID , "ComEne29_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq40_SneakRouteSet","S_Sen_Center_e", 0 )
		--ComEne31
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_Middle2" )
		TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF_v2" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq40_SneakRouteSet","S_Sen_Boilar_Middle2", 0 )
		--ComEne32
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_Middle" )
		TppEnemy.DisableRoute( this.cpID , "ComEne32_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq40_SneakRouteSet","S_Sen_Boilar_Middle", 0 )
	elseif ( sequence == "Seq_ChicoPazToRV" ) then				-- 30
		--ComEne25
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" )
		TppEnemy.DisableRoute( this.cpID , "ComEne25_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne256","e20010_Seq30_SneakRouteSet","S_Sen_Center_d", 0 )
		--ComEne26
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_a" )
		TppEnemy.DisableRoute( this.cpID , "ComEne26_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq30_SneakRouteSet","S_Sen_Center_a", 0 )
		--ComEne27
		TppEnemy.EnableRoute( this.cpID , "S_Sen_BoilarFront" )
		TppEnemy.DisableRoute( this.cpID , "ComEne27_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq30_SneakRouteSet","S_Sen_BoilarFront", 0 )
		--ComEne28
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "SmokingRouteChange", false , false )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_b" )
		TppEnemy.DisableRoute( this.cpID , "ComEne28_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq30_SneakRouteSet","S_Sen_Center_b", 0 )
		--ComEne29
		TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Center2F_EneRouteChange", false , false )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_e" )
		TppEnemy.DisableRoute( this.cpID , "ComEne29_SwitchOFF" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq30_SneakRouteSet","S_Sen_Center_e", 0 )
		--ComEne31
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_f" )
		TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF_v3" )
		TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq30_SneakRouteSet","S_Sen_Center_f",0 )
	else
		if( TppMission.GetFlag( "isFirstEncount_Chico" ) == true ) then		-- 30
			--ComEne25
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" )
			TppEnemy.DisableRoute( this.cpID , "ComEne25_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne256","e20010_Seq30_SneakRouteSet","S_Sen_Center_d", 0 )
			--ComEne26
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_a" )
			TppEnemy.DisableRoute( this.cpID , "ComEne26_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq30_SneakRouteSet","S_Sen_Center_a", 0 )
			--ComEne27
			TppEnemy.EnableRoute( this.cpID , "S_Sen_BoilarFront" )
			TppEnemy.DisableRoute( this.cpID , "ComEne27_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq30_SneakRouteSet","S_Sen_BoilarFront", 0 )
			--ComEne28
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "SmokingRouteChange", false , false )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_b" )
			TppEnemy.DisableRoute( this.cpID , "ComEne28_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq30_SneakRouteSet","S_Sen_Center_b", 0 )
			--ComEne29
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Center2F_EneRouteChange", false , false )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_e" )
			TppEnemy.DisableRoute( this.cpID , "ComEne29_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq30_SneakRouteSet","S_Sen_Center_e", 0 )
			--ComEne31
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_f" )
			TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF_v3" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq30_SneakRouteSet","S_Sen_Center_f",0 )
		else	-- 50
			--ComEne24
			TppEnemy.EnableRoute( this.cpID , "S_Sen_CenterB_2F" )
			TppEnemy.DisableRoute( this.cpID , "ComEne24_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne24","e20010_Seq40_SneakRouteSet","S_Sen_CenterB_2F",0 )	--指定敵兵ルートチェンジ
			--ComEne25
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" )
			TppEnemy.DisableRoute( this.cpID , "ComEne25_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne24","e20010_Seq40_SneakRouteSet","S_Sen_Center_d",0 )	--指定敵兵ルートチェンジ
			--ComEne26
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_a" )
			TppEnemy.DisableRoute( this.cpID , "ComEne26_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne26","e20010_Seq40_SneakRouteSet","S_Sen_Center_a",0 )	--指定敵兵ルートチェンジ
			--ComEne27
			TppEnemy.EnableRoute( this.cpID , "S_Sen_BoilarFront" )
			TppEnemy.DisableRoute( this.cpID , "ComEne27_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq40_SneakRouteSet","S_Sen_BoilarFront",0 )	--指定敵兵ルートチェンジ
			--ComEne28
			TppEnemy.EnableRoute( this.cpID , "S_Mov_Smoking_Center" )
			TppEnemy.DisableRoute( this.cpID , "ComEne28_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne28","e20010_Seq40_SneakRouteSet","S_Mov_Smoking_Center", 0 )
			--ComEne29
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_e" )
			TppEnemy.DisableRoute( this.cpID , "ComEne29_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq40_SneakRouteSet","S_Sen_Center_e", 0 )
			--ComEne31
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_Middle2" )
			TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF_v2" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq40_SneakRouteSet","S_Sen_Boilar_Middle2", 0 )
			--ComEne32
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_Middle" )
			TppEnemy.DisableRoute( this.cpID , "ComEne32_SwitchOFF" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq40_SneakRouteSet","S_Sen_Boilar_Middle", 0 )
		end
	end
end
-- OFF
local SwitchLight_OFF = function()

	local phase = TppEnemy.GetPhase( this.cpID )

	-- 演出デモを見てなく、アラート以外の時のみ停電演出デモが流れる
	if( TppMission.GetFlag( "isSwitchLightDemo" ) == false )
		and ( phase == "sneak" or phase == "caution" or phase == "evasion" ) then

		local onDemoStart = function()
			-- 再生中の無線停止
			local radioDaemon = RadioDaemon:GetInstance()
			radioDaemon:StopDirect()
			-- 字幕の停止
			SubtitlesCommand.StopAll()
			-- カメラに映らない監視カメラを無効化する
			TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20010_SecurityCamera_03", false )
			TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20010_SecurityCamera_04", false )
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
			After_SwitchOff()
			-- ボイラー室エフェクトＯＦＦ
			TppDataUtility.DestroyEffectFromGroupId( "wtrdrpbil" )
			TppDataUtility.DestroyEffectFromGroupId( "dstcomviw" )
		end
		TppDemo.Play( "SwitchLightDemo" , { onStart = onDemoStart, onSkip = onDemoSkip , onEnd = onDemoEnd } , {
			disableGame				= false,	--共通ゲーム無効を、キャンセル
			disableDamageFilter		= false,	--エフェクトは消さない
			disableDemoEnemies		= false,	--敵兵は消さないでいい
			disableEnemyReaction	= true,		--敵兵のリアクションを向こうかする
			disableHelicopter		= false,	--支援ヘリは消さないでいい
			disablePlacement		= false, 	--設置物は消さないでいい
			disableThrowing			= false	 	--投擲物は消さないでいい
		})
	-- 演出デモを見たか、アラートフェイズの時
	else
		-- 停電後処理
		After_SwitchOff()
	end
end
---------------------------------------------------------------------------------
-- 巨大ゲート通過トラック
---------------------------------------------------------------------------------
local OpenGateRouteChange = function()
	TppMission.SetFlag( "isSeq20_02_DriveEnd", 1 )
	--管理棟巨大ゲート通過車輌設定
	GZCommon.Common_CenterBigGateVehicleSetup( this.cpID, "TppGroupVehicleRouteInfo_Seq20_02a", "GateEnterTruck", "GateEnterTruck02", 2, 1 )
	GZCommon.Common_CenterBigGateVehicle()

end
---------------------------------------------------------------------------------
--DemoSequences
---------------------------------------------------------------------------------
--オープニングデモ
this.Seq_OpeningDemoPlay = {

	Messages = {
	   Demo = {
			{ data="p11_010100_000", message="characterRealize", localFunc="DemoInGameAction" },
		},
	},

	OnEnter = function()
		TppMusicManager.ClearParameter()	--BGMクリア
		this.openingDemoSkipCount = 0		--スキップしたかどうかを初期化
		-- デモ開始処理
		local function onDemoStart()
			Fox.Log("-------------- OpeningDemo_Start --------------")
			TppCharacterUtility.SetEnableCharacterId( "gntn_flag_000" , false )
			TppEffectUtility.SetThunderSpotLightShadowEnable( true )	--雷の影ＯＮ
			TppGadgetUtility.SetDoor{ id = "Asy_PickingDoor", isVisible = false, isEnableBounder = true, isEnableTacticalActionEdge = true, angle = 0, isOpen = false }
			TppUI.FadeIn(1)
		end
		--　デモスキップ処理
		local function onDemoSkip()
			Fox.Log("-------------- OpeningDemo_Skip --------------")

			MissionManager.RegisterNotInGameRealizeCharacter("Seq10_05")
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq00_SneakRouteSet" , "OpeningDemoRoute03" , -1 , "Seq10_05" , "ROUTE_PRIORITY_TYPE_FORCED" )

			TppCharacterUtility.SetEnableCharacterId( "gntn_flag_000" , true )
			TppEffectUtility.SetThunderSpotLightShadowEnable( false )	--雷の影ＯＦＦ
			TppGameStatus.Set("MissionScript", "S_DISABLE_GAME")
			TppGadgetUtility.SetDoor{ id = "Asy_PickingDoor", isVisible = true, isEnableBounder = false, isEnableTacticalActionEdge = true, angle = 0, isOpen = false }
			this.openingDemoSkipCount = 1 -- スキップ開始宣言
		end
		-- デモ終了処理
		local function onDemoEnd()
			if this.openingDemoSkipCount == 0 then --0ってことは、スキップではないので正常遷移
				Fox.Log("-------------- OpeningDemo_NoSkip_End --------------")
				TppCharacterUtility.SetEnableCharacterId( "gntn_flag_000" , true )
				TppEffectUtility.SetThunderSpotLightShadowEnable( false )	--雷の影ＯＦＦ
				TppGadgetUtility.SetDoor{ id = "Asy_PickingDoor", isVisible = true, isEnableBounder = false, isEnableTacticalActionEdge = true, angle = 0, isOpen = false }
				TppSequence.ChangeSequence( "Seq_MissionLoad" )
				TppRadio.DelayPlay( "Miller_MissionStart", 2.0 )
			else
				TppRadio.DelayPlay( "Miller_MissionStart", 6.2 )
			end
		end
		TppDemo.Play( "ArrivalAtGuantanamo", { onStart = onDemoStart, onEnd = onDemoEnd, onSkip = onDemoSkip } )
	end,

	OnUpdate = function()
		--スキップ開始
		if this.openingDemoSkipCount >= 1 then
			this.openingDemoSkipCount = this.openingDemoSkipCount + 1
			if this.openingDemoSkipCount >= 150 or TppMission.GetFlag( "isSeq10_05SL_ON" ) == true then --30フレの保険処理もしくはSeq10_05がサーチライトを使用したら
				TppGameStatus.Reset("MissionScript", "S_DISABLE_GAME")
				TppGadgetUtility.SetDoor{ id = "Asy_PickingDoor", isVisible = true, isEnableBounder = false, isEnableTacticalActionEdge = true, angle = 0, isOpen = false }
				TppSequence.ChangeSequence( "Seq_MissionLoad" )
			end
		end
	end,

	DemoInGameAction = function()

		--デモ中強制出現敵兵
		MissionManager.RegisterNotInGameRealizeCharacter("ComEne01")		-- スタート崖ヤグラ
		MissionManager.RegisterNotInGameRealizeCharacter("ComEne04")		-- 倉庫鉄製ヤグラ
		MissionManager.RegisterNotInGameRealizeCharacter("Seq10_01")		-- 会話１
		MissionManager.RegisterNotInGameRealizeCharacter("Seq10_05")		-- 会話２
		--ルートセット
		local cpRouteSets = {
			{
				cpID = "gntn_cp",
				sets = {
					sneak_night = "e20010_Seq00_SneakRouteSet",
					caution_night = "e20010_Seq00_SneakRouteSet",
				},
			},
		}
		TppEnemy.SetRouteSets( cpRouteSets )
		--ルート強制割り当て
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq00_SneakRouteSet" , "OpeningDemoRoute01" , -1 , "ComEne01" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq00_SneakRouteSet" , "OpeningDemoRoute02" , -1 , "ComEne04" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq00_SneakRouteSet" , "S_Pre_ExWeaponTalk_b" , -1 , "Seq10_01" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq00_SneakRouteSet" , "OpeningDemoRoute03" , -1 , "Seq10_05" , "ROUTE_PRIORITY_TYPE_FORCED" )
	end,
}

--チコに会う１
this.Seq_RescueChicoDemo01 = {
	--　位置補正が終わってからデモをスタートするように変更 0826 yamamoto
	Messages = {
	   Character = {
			{ data="Player", message="TransitionActionEnd", localFunc="DemoStart" },
		},
		Demo = {
			{ data="p11_010120_000", message="visibleGate", localFunc="onDemoVisibleGate" },
			{ data="p11_010125_000", message="visibleGate", localFunc="onDemoVisibleGate" },
			{ data="p11_010126_000", message="visibleGate", localFunc="onDemoVisibleGate" },
		},
	},

	demoId = "EncounterChico_BeforePaz_WithoutHostage",

	onDemoVisibleGate = function()
		Fox.Log(":: on demo visible gate ::")
		ChicoDoor_ON_Open()
	end,

	DemoStart = function()
		-- デモが開始するときに、チコドアを無効
		local onDemoStart = function()
			ChicoDoor_OFF()
			-- チコパスのモーションがデモ後につながるように変更	0810 yamamoto
			ChengeChicoPazIdleMotion()
		end

		--　デモが終了するときに、チコドアを有効、開く＋任意無線設定
		local onDemoEnd = function()
			Trophy.TrophyUnlock(13)		--実績解除
			TppRadio.DelayPlayEnqueue( "Miller_TakeChicoToRVPoint", "long", nil, { onEnd = function() AnounceLog_MapUpdate() end }, nil )
			AnounceLog_EncountChico()	--アナウンスログ
--			ChicoDoor_ON_Open()
--			SetComplatePhoto(10)--写真を達成済みにする yamamoto 1001
			TppSequence.ChangeSequence( "Seq_NextRescuePaz" )
		end

		-- フラグ更新
		TppMission.SetFlag( "isEncounterChico", true )

		TppDemo.Play( this.Seq_RescueChicoDemo01.demoId, { onStart = onDemoStart, onEnd = onDemoEnd } )

	end,

	OnEnter = function()
		GZCommon.StopAlertSirenCheck()

		-- チコ周辺の捕虜状態、正常 かつ 檻の中にいる
		local hosCheck = Demo_hosChecker()	-- 0:NO捕虜、1:捕虜足りない、2:演技捕虜OK
		if( hosCheck == 0 ) then
				this.Seq_RescueChicoDemo01.demoId = "EncounterChico_BeforePaz_NoHostage"
		elseif( hosCheck == 2 )then
				this.Seq_RescueChicoDemo01.demoId = "EncounterChico_BeforePaz_WithHostage"
		else
				this.Seq_RescueChicoDemo01.demoId = "EncounterChico_BeforePaz_WithoutHostage"
		end

		local demoInterpCameraId = this.DemoList[this.Seq_RescueChicoDemo01.demoId]
		Fox.Log(demoInterpCameraId)
		Fox.Log(this.Seq_RescueChicoDemo01.demoId)

		-- プレイヤーの向きを補正（デモの入り口に）
		local demoPos = 0
		local demoRot = 0
		demoPos, demoRot = e20010_require_01.getDemoStartPos( demoInterpCameraId )
		Fox.Log(":: get !! ::")
		Fox.Log("x = " .. demoPos:GetX() .. " y = ".. demoPos:GetY() .. " z = " .. demoPos:GetZ())

		-- デモのセットアップ、プレイヤーの向きを補正、カメラの補正
		TppDemoUtility.Setup(demoInterpCameraId)
		TppPlayerUtility.RequestToStartTransition{stance=this.demoStaPlayer_chico, position=demoPos, direction=demoRot, doKeep = true}
		TppPlayerUtility.RequestToInterpCameraToDemo(demoInterpCameraId,this.demoCamRot,this.demoCamSpeed)
		GZCommon.SetGameStatusForDemoTransition()
	end,
}
--チコに会う２
this.Seq_RescueChicoDemo02 = {
	--　位置補正が終わってからデモをスタートするように変更 0826 yamamoto
	Messages = {
	   Character = {
			{ data="Player", message="TransitionActionEnd", localFunc="DemoStart" },
		},
		Demo = {
			{ data="p11_010110_000", message="visibleGate", localFunc="onDemoVisibleGate" },
			{ data="p11_010115_000", message="visibleGate", localFunc="onDemoVisibleGate" },
			{ data="p11_010116_000", message="visibleGate", localFunc="onDemoVisibleGate" },
		},
	},

	demoId = "EncounterChico_AfterPaz_WithoutHostage",

	onDemoVisibleGate = function()
		Fox.Log(":: on demo visible gate ::")
		ChicoDoor_ON_Open()
	end,

	DemoStart = function()
		-- デモが開始するときに、チコドアを無効
		local onDemoStart = function()
			ChicoDoor_OFF()
			-- チコパスのモーションがデモ後につながるように変更 0810 yamamoto
			ChengeChicoPazIdleMotion()

		end

		--　デモが終了するときに、チコドアを有効、開く＋任意無線設定
		local onDemoEnd = function()
			Trophy.TrophyUnlock(13)		--実績解除
			AnounceLog_EncountChico()	--アナウンスログ
			TppRadio.DelayPlayEnqueue( "Miller_TakeChicoOnHeli", "long" )
--			ChicoDoor_ON_Open()
--			SetComplatePhoto(10)--写真を達成済みにする yamamoto 1001
			TppSequence.ChangeSequence( "Seq_PazChicoToRV" )
		end
		-- フラグ更新
		TppMission.SetFlag( "isEncounterChico", true )

		TppDemo.Play( this.Seq_RescueChicoDemo02.demoId, { onStart = onDemoStart, onEnd = onDemoEnd } )

	end,

	OnEnter = function()
		GZCommon.StopAlertSirenCheck()

		-- チコ周辺の捕虜状態、正常 かつ 檻の中にいる
		local hosCheck = Demo_hosChecker()	-- 0:NO捕虜、1:捕虜足りない、2:演技捕虜OK
		if( hosCheck == 0 ) then
				this.Seq_RescueChicoDemo02.demoId = "EncounterChico_AfterPaz_NoHostage"
		elseif( hosCheck == 2 )then
				this.Seq_RescueChicoDemo02.demoId = "EncounterChico_AfterPaz_WithHostage"
		else
				this.Seq_RescueChicoDemo02.demoId = "EncounterChico_AfterPaz_WithoutHostage"
		end

		Fox.Log(this.Seq_RescueChicoDemo02.demoId)

		local demoInterpCameraId = this.DemoList[this.Seq_RescueChicoDemo02.demoId]
		Fox.Log(demoInterpCameraId)

		-- プレイヤーの向きを補正（デモの入り口に）
		local demoPos = 0
		local demoRot = 0
		demoPos, demoRot = e20010_require_01.getDemoStartPos( demoInterpCameraId )
		Fox.Log(":: get !! ::")
		Fox.Log("x = " .. demoPos:GetX() .. " y = ".. demoPos:GetY() .. " z = " .. demoPos:GetZ())


		-- デモのセットアップ、プレイヤーの向きを補正、カメラの補正
		TppDemoUtility.Setup(demoInterpCameraId)
		TppPlayerUtility.RequestToStartTransition{stance=this.demoStaPlayer_chico,position=demoPos,direction=demoRot,doKeep = true}
		TppPlayerUtility.RequestToInterpCameraToDemo(demoInterpCameraId,this.demoCamRot,this.demoCamSpeed)
		GZCommon.SetGameStatusForDemoTransition()
	end,
}
--チコ回収
this.Seq_QuestionChicoDemo = {
	Messages = {
	   Character = {
			{ data="Player", message="TransitionActionEnd", localFunc="DemoStart" },
		},
		Timer = {
			{ data = "timer_demoRescueChico", message = "OnEnd", localFunc = "DemoStart" },
		},
	},

	-- デモの再生
	DemoStart = function()
		local function onDemoStart()
			-- チコパスのモーションがデモ後につながるように変更	0810 yamamoto
			ChengeChicoPazIdleMotion()
		end
		local function onDemoEnd()
			TppEnemy.SetFormVariation( "Chico" , "ChicoYPfova" )	-- イヤホンを表示する
			e20010_require_01.InterrogationAdviceTimerStart()	--尋問促し無線タイマー開始
			AnounceLog_CarryChicoToRV()	--アナウンスログ
			GetChicoTape()
			TppHostageManager.GsSetSpecialFaintFlag( "Chico", false ) -- デモ開始前に気絶状態にしていたので元に戻す matsushita
			if( TppMission.GetFlag( "isHeliComingRV" ) == false ) then
				TppRadio.DelayPlay("Miller_PazChicoCarriedEndRV","mid")
			end
			e20010_require_01.Radio_RescuePaz1Timer()
			e20010_require_01.Radio_RescuePaz2Timer()
			TppSequence.ChangeSequence( "Seq_NextRescuePaz" )
		end
		TppMission.SetFlag( "isQuestionChico", true )								--フラグ更新

		TppDemo.Play( this.CounterList.PlayQuestionDemo, { onStart = onDemoStart, onEnd = onDemoEnd} )
	end,

	OnEnter = function()
		Fox.Log(":: sep_chico rescue ::")
		GZCommon.StopAlertSirenCheck()
		-- demo Id の確定
		this.CounterList.PlayQuestionDemo = "QuestionChico"

		local demoInterpCameraId = ""

		-- ワープするべきか判定をとる
		local demoPos
		local demoRot
		local degree

		local warpPoint = Check_AroundSpace("Chico")
		Fox.Log( "warp point is "..warpPoint )-- warp が必要ならポイントが返ってくる,シームレスなら false

		-- デモの再生位置を取得
		local ret,quat,trans
		if( warpPoint == "notWarp" ) then			-- ワープすべきでない
			-- デモデータと位置関係より再生位置を計算
			Fox.Log("get demo pos for seemless play")
			this.CounterList.PlayQuestionDemo = "QuestionChicoCut"
			-- Utility 用にデモIDをとる
			demoInterpCameraId = this.DemoList[this.CounterList.PlayQuestionDemo]

			ret,quat,trans = Demo.GetCharacterTransformFromCharacter(demoInterpCameraId,"Player","Chico")
			if ret then
				Fox.Log( tostring(quat) )
				Fox.Log( tostring(trans) )

				local offsetBase = Vector3(0.0,0,0.0215)
				local offset = quat:Rotate(offsetBase)
				trans = trans + offset
				Fox.Log("offset")
				local direction = quat:Rotate( Vector3( 0.0, 0.0, 1.0 ) )
				local angle = foxmath.Atan2( direction:GetX(), direction:GetZ() )
				degree = foxmath.RadianToDegree( angle )
				demoPos = trans
				demoRot = quat

			else
				--保険処理
				TppSequence.ChangeSequence( "Seq_NextRescuePaz" )
			end

		else		-- ワープすべき
			Fox.Log("need warp")
			this.CounterList.PlayQuestionDemo = "QuestionChico"
			-- Utility 用にデモIDをとる
			demoInterpCameraId = this.DemoList[this.CounterList.PlayQuestionDemo]
			demoPos = TppData.GetPosition( warpPoint )
			demoRot = TppData.GetRotation( warpPoint )
		end

		-- デモデータを対応する位置に移動させる
		Fox.Log("move demo data"..demoInterpCameraId )
		local body = DemoDaemon.FindDemoBody(demoInterpCameraId)

		if not Entity.IsNull(body)then
			Fox.Log("set position :  demo")
			Fox.Log( tostring(demoRot) )
			Fox.Log( tostring(demoPos) )
			body.data.transform.translation = demoPos
			body.data.transform.rotQuat = demoRot
		end

		-- デモのセットアップ
		TppDemoUtility.Setup(demoInterpCameraId)

		-- デモを再生　必要ならプレイヤーの位置を補正か
		if( warpPoint == "notWarp" ) then
			-- ワープしない
			Fox.Log("not warp : play demo")
			Fox.Log("demoId = "..demoInterpCameraId )
			TppPlayerUtility.RequestToStartTransition{stance="Squat",position=trans,direction=degree,doKeep = true}
			TppPlayerUtility.RequestToInterpCameraToDemo(demoInterpCameraId,this.demoCamRot,this.demoCamSpeed)

			GZCommon.SetGameStatusForDemoTransition()
		else
			Fox.Log("warp : play demo")
			this.Seq_QuestionChicoDemo.DemoStart()
		end
	end,
}
--テープを再生デモ　by yamamoto 1022
this.Seq_CassetteDemo = {

	OnEnter = function()

		local function onDemoStart()
			-- カセットデモ専用のフェイズリセット処理。。。他でやっちゃダメ！
			do
				local cpObj = Ch.FindCharacterObjectByCharacterId( this.cpID )
				if not Entity.IsNull(cpObj) then
					local phaseController = cpObj:GetPhaseController()
					if not Entity.IsNull(phaseController) then
						phaseController:SetCurrentPhaseByName("Neutral")
						phaseController:SetCurrentPhaseLevel(0)
						TppCharacterUtility.ResetPhase()
						TppSoundDaemon.PostEvent( "Stop_sfx_m_gntn_alert_siren4_lp" )
					end
				end
			end
			-- ヘリ初期化
			TppSupportHelicopterService.Initialize("SupportHelicopter")
			ChengeChicoPazIdleMotion()
		end
		local function onDemoEnd()
			if ( TppMission.GetFlag( "isChicoTapeGet" ) == false ) then
				GetChicoTape()		-- チコのテープ入手
				e20010_require_01.InterrogationAdviceTimerStart()	--尋問促し無線タイマー開始
			else
				--既に持っているケース
			end
			TppMission.SetFlag( "isHeliLandNow", false )
			TppMission.SetFlag( "isHeliComeToSea", false )
			TppMission.SetFlag( "isHeliComingRV", false )
			TppUI.FadeIn( 0 )
			TppSequence.ChangeSequence( "Seq_NextRescuePaz" )
		end

	-- ヘリにプレイヤーもってかれる不具合があるので一括でコメントあうと
	--TppSequence.ChangeSequence( "Seq_NextRescuePaz" )
		-- ランデブーポイントの場所を見て　デモを切り替える
		-- プレイヤーの位置から最寄りのポイントを検索
		local player = Ch.FindCharacterObjectByCharacterId( "Player" )
		local playerPos = player:GetPosition()
		local point00 = TppData.GetPosition( "cassetteDemoCheck_00" )
		local point10 = TppData.GetPosition( "cassetteDemoCheck_10" )
		local point20 = TppData.GetPosition( "cassetteDemoCheck_20" )
		local point25 = TppData.GetPosition( "cassetteDemoCheck_25" )
		local point30 = TppData.GetPosition( "cassetteDemoCheck_30" )
		local point35 = TppData.GetPosition( "cassetteDemoCheck_35" )
		-- 距離を測る
		local checkP00 = TppUtility.FindDistance( playerPos, point00 )
		local checkP10 = TppUtility.FindDistance( playerPos, point10 )
		local checkP20 = TppUtility.FindDistance( playerPos, point20 )
		local checkP25 = TppUtility.FindDistance( playerPos, point25 )
		local checkP30 = TppUtility.FindDistance( playerPos, point30 )
		local checkP35 = TppUtility.FindDistance( playerPos, point35 )
		-- 最寄りポイントを検索
		local minLength = 999999999999999999
		local minIndex = ""

		local hoge = {
		}
		hoge["cassetteDemoCheck_00"] = checkP00
		hoge["cassetteDemoCheck_10"] = checkP10
		hoge["cassetteDemoCheck_20"] = checkP20
		hoge["cassetteDemoCheck_25"] = checkP25
		hoge["cassetteDemoCheck_30"] = checkP30
		hoge["cassetteDemoCheck_35"] = checkP35
		for index, length in pairs( hoge ) do
			if length < minLength then
				minLength = length
				minIndex = index
			end
		end
		Fox.Log( " near point is "..minIndex )

		local demoName = "Demo_CassettePlayWithoutTapeL"
		local demoPos = Vector3(137.771,	4.970	,114.796)
		local demoRot = Quat(0,	0.208172,	0,	0.978092)
		local LR = "L"
		if( minIndex == "cassetteDemoCheck_10" )then
			demoPos = Vector3(-220.154600,	37.969590,	302.029100)
			demoRot = Quat(0,	-0.65277750,	0,			0.75754960)
			LR = "L"
		elseif( minIndex == "cassetteDemoCheck_20" )then
			demoPos = Vector3(-119.560, 27.944, 146.219)--
			demoRot = Quat(0,	0.70710650,	0,	0.70710700)
			LR = "L"
		elseif( minIndex == "cassetteDemoCheck_25" )then
			demoPos = Vector3(-111.207400,	27.944450	,140.348100)
			demoRot = Quat(0,	-0.72373610,	0,	0.69007680)
			LR = "R"
		elseif( minIndex == "cassetteDemoCheck_30" )then
			demoPos = Vector3(-95.282150,	31.080120	,52.449980)
			demoRot = Quat(0,	0,	0,	1)
			LR = "L"
		elseif( minIndex == "cassetteDemoCheck_35" )then
			demoPos = Vector3(-83.816440,	31.080120	,52.364280)
			demoRot = Quat(0,	0,	0,	1)
			LR = "R"
		end

		-- デモの番号を取得
		if( TppMission.GetFlag( "isQuestionChico" ) == false )then
		-- カセットを持っていない
			if ( LR == "L")then
				demoName = "Demo_CassettePlayWithoutTapeL"
			else
				demoName = "Demo_CassettePlayWithoutTapeR"
			end
		else
		-- カセットを持っている
			if ( LR == "L")then
				demoName = "Demo_CassettePlayWithTapeL"
			else
				demoName = "Demo_CassettePlayWithTapeR"
			end
		end
		Fox.Log("demoName is "..demoName )

		Fox.Log(":: cassette demo start ::")
		TppMission.SetFlag( "isCassetteDemo", true )								--フラグ更新
		GZCommon.StopAlertSirenCheck()

		-- デモデータを対応する位置に移動させる
		local demoInterpCameraId = this.DemoList[demoName]
		local body = DemoDaemon.FindDemoBody(demoInterpCameraId)

		if not Entity.IsNull(body)then
			body.data.transform.translation = demoPos
			body.data.transform.rotQuat = demoRot
		end

		TppDemo.Play( demoName, { onStart = onDemoStart, onEnd = onDemoEnd } )

	end,

	OnLeave = function()
		-- デモ後にテープを再生する
		TppMusicManager.PlayMusicPlayer( 'tp_chico_00_03' )
		Fox.Log("================== DemoEnd_HeliFlag Reset ======================")
		TppMission.SetFlag( "isHeliLandNow", false )
		TppMission.SetFlag( "isHeliComeToSea", false )
		TppMission.SetFlag( "isHeliComingRV", false )
		TppMission.SetFlag( "isChicoTapePlay", true )
		-- Save
		if( TppMission.GetFlag( "isSaveAreaNo" ) == 1 ) then		-- ヘリポート
			TppMissionManager.SaveGame("50")
		elseif( TppMission.GetFlag( "isSaveAreaNo" ) == 2 ) then	-- 海岸
			TppMissionManager.SaveGame("40")
		elseif( TppMission.GetFlag( "isSaveAreaNo" ) == 3 ) then	-- スタート崖
			TppMissionManager.SaveGame("10")
		elseif( TppMission.GetFlag( "isSaveAreaNo" ) == 4 ) then	-- 倉庫
			TppMissionManager.SaveGame("51")
		else
			-- セーブしない
		end
	end,

}

--パスに会う
this.Seq_RescuePazDemo = {
	--　位置補正が終わってからデモをスタートするように変更 0826 yamamoto
	Messages = {
	   Character = {
			{ data="Player", message="TransitionActionEnd", localFunc="DemoStart" },
		},
		Demo = {
			{ data="p11_010130_000", message="visibleGate", localFunc="onDemoVisibleGate" },
		},
	},


	onDemoVisibleGate = function()
		Fox.Log(":: on demo visible gate ::")
		PazDoor_ON_Open()
	end,

	DemoStart = function()
		TppMission.SetFlag( "isEncounterPaz", true )								--フラグ更新

		local function onDemoStart()
			-- チコパスのモーションがデモ後につながるように変更 0810 yamamoto
			ChengeChicoPazIdleMotion()
			PazDoor_OFF()
			TppEnemy.SetFormVariation( "Paz" , "fovaPazBeforeDemo2" )	-- 半そで手のロープを消す
--			TppEnemy.SetFormVariation( "Paz" , "fovaPazAfterDemo" )	-- 元非表示モデルを出す
		end
		local function onDemoEnd()
			TppEnemy.SetFormVariation( "Paz" , "fovaPazAfterDemo" )	-- 元非表示モデルを出す
			Trophy.TrophyUnlock(13)		--実績解除
			AnounceLog_EncountPaz()		--アナウンスログ
			PazDoor_ON_Open()
--			SetComplatePhoto(30) --写真を達成済みにする yamamoto 1001
			--チコ3再生中に無線再生できるようにする
			TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( false )

		--	local timer = 3
		--	GkEventTimerManager.Start( "Timer_takePazToRVPoint01", timer )	--少し遅らせてパスを運んでくれ無線を再生する

			if( TppMission.GetFlag( "isEncounterChico" ) == false ) then			--チコに会うデモを見ていない
				TppRadio.DelayPlayEnqueue( "Miller_takePazToRVPoint01", "long", nil, { onEnd = function() AnounceLog_MapUpdate() end }, nil )
				TppSequence.ChangeSequence( "Seq_NextRescueChico" )

			else																--チコに会うデモを見ている
				TppRadio.DelayPlayEnqueue("Miller_takePazOnHeli","mid")
				TppSequence.ChangeSequence( "Seq_ChicoPazToRV" )
			end
		end
		TppDemo.Play( "EncounterPaz", { onStart = onDemoStart, onEnd = onDemoEnd } )
		TppTimer.Start( "PazPrizonBreakTimer", 60 )	--仮機構

	end,

	OnEnter = function()
		GZCommon.StopAlertSirenCheck()

		local demoInterpCameraId = "p11_010130_000"

		-- プレイヤーの向きを補正（デモの入り口に）
		local demoPos = 0
		local demoRot = 0
		demoPos, demoRot = e20010_require_01.getDemoStartPos( demoInterpCameraId )
		Fox.Log(":: get !! ::")
		Fox.Log("x = " .. demoPos:GetX() .. " y = ".. demoPos:GetY() .. " z = " .. demoPos:GetZ())
		Fox.Log( demoRot )

		-- プレイヤーの向きを補正（デモの入り口に）
		TppDemoUtility.Setup(demoInterpCameraId)
		TppPlayerUtility.RequestToStartTransition{stance=this.demoStaPlayer_paz,position=demoPos,direction=demoRot,doKeep = true}
		TppPlayerUtility.RequestToInterpCameraToDemo(demoInterpCameraId,this.demoCamRot,this.demoCamSpeed)

		-- ゲームステータスを変更
		GZCommon.SetGameStatusForDemoTransition()

	end,
}
--パス回収
this.Seq_QuestionPazDemo = {
	Messages = {
	   Character = {
			{ data="Player", message="TransitionActionEnd", localFunc="DemoStart" },
		},
		Timer = {
			{ data = "timer_demoRescuePaz", message = "OnEnd", localFunc = "DemoStart" },
		},
	},

	DemoStart = function()
		local function onDemoStart()
		end
		local function onDemoEnd()
			AnounceLog_CarryPazToRV()	--アナウンスログ

			TppSequence.ChangeSequence( "Seq_NextRescueChico" )
		end
		TppMission.SetFlag( "isQuestionPaz", true )								--フラグ更新
		TppDemo.Play( this.CounterList.PlayQuestionDemo, { onStart = onDemoStart, onEnd = onDemoEnd } )
	end,
	OnEnter = function()
		Fox.Log(":: sep_paz rescue ::")
		GZCommon.StopAlertSirenCheck()
		-- demo Id の確定
		this.CounterList.PlayQuestionDemo = "QuestionPaz"

		local demoInterpCameraId = ""

		-- ワープするべきか判定をとる
		local demoPos
		local demoRot
		local degree

		local warpPoint = Check_AroundSpace("Paz")
		Fox.Log( "warp point is "..warpPoint )-- warp が必要ならポイントが返ってくる,シームレスなら false


		-- デモの再生位置を取得
		local ret,quat,trans
		if( warpPoint == "notWarp" ) then			-- ワープすべきでない
			-- デモデータと位置関係より再生位置を計算
			Fox.Log("get demo pos for seemless play")
			this.CounterList.PlayQuestionDemo= "QuestionPazCut"
			-- Utility 用にデモIDをとる
			demoInterpCameraId = this.DemoList[this.CounterList.PlayQuestionDemo]


			ret,quat,trans = Demo.GetCharacterTransformFromCharacter(demoInterpCameraId,"Player","Paz")
			if ret then
				Fox.Log( tostring(quat) )
				Fox.Log( tostring(trans) )

				local offsetBase = Vector3(0.0,0,0.0215)
				local offset = quat:Rotate(offsetBase)
				trans = trans + offset
				Fox.Log("offset")
				local direction = quat:Rotate( Vector3( 0.0, 0.0, 1.0 ) )
				local angle = foxmath.Atan2( direction:GetX(), direction:GetZ() )
				degree = foxmath.RadianToDegree( angle )
				demoPos = trans
				demoRot = quat

			else
				--保険処理
				TppSequence.ChangeSequence( "Seq_NextRescueChico" )
			end

		else		-- ワープすべき
			Fox.Log("need warp")
			this.CounterList.PlayQuestionDemo = "QuestionPaz"
			-- Utility 用にデモIDをとる
			demoInterpCameraId = this.DemoList[this.CounterList.PlayQuestionDemo]
			demoPos = TppData.GetPosition( warpPoint )
			demoRot = TppData.GetRotation( warpPoint )
		end

		-- デモデータを対応する位置に移動させる
		Fox.Log("move demo data")
		local body = DemoDaemon.FindDemoBody(demoInterpCameraId)

		if not Entity.IsNull(body)then
			Fox.Log("set position :  demo")
			Fox.Log( tostring(demoRot) )
			Fox.Log( tostring(demoPos) )
			body.data.transform.translation = demoPos
			body.data.transform.rotQuat = demoRot
		end

		-- デモのセットアップ
		TppDemoUtility.Setup(demoInterpCameraId)

		-- デモを再生　必要ならプレイヤーの位置を補正か
		if( warpPoint == "notWarp" ) then
			-- ワープしない
			Fox.Log("not warp : play demo")
			Fox.Log("demoId = "..demoInterpCameraId )
			TppPlayerUtility.RequestToStartTransition{stance="Squat",position=trans,direction=degree,doKeep = true}
			TppPlayerUtility.RequestToInterpCameraToDemo(demoInterpCameraId,this.demoCamRot,this.demoCamSpeed)

			GZCommon.SetGameStatusForDemoTransition()
		else
			Fox.Log("warp : play demo")
			this.Seq_QuestionPazDemo.DemoStart()
		end
	end,
}
--マーカーがついた
this.commonMarkerEnable = function()

	Fox.Log("--------commonMarkerEnable--------")

	-- ミッション圏外を行き来するキャラへのマーカー付与状態はフラグ管理する

	local MarkerID			= TppData.GetArgument(1)

	if ( MarkerID == "Chico" ) then
		if( TppMission.GetFlag( "isSearchLightChicoArea" ) == 1 ) then --旧収容所のやぐらのうえにいる
			TppRadio.PlayEnqueue( "Miller_SearchLightChico" )
		end
		TppMission.SetFlag( "isSearchLightChicoArea", 2 )
	end
end
--旧収容所のやぐらの上にはいった
this.enterSearchLightChicoArea = function()
	if( TppMission.GetFlag( "isSearchLightChicoArea" ) == 0 ) then
		TppMission.SetFlag( "isSearchLightChicoArea", 1 )
	end
end
--旧収容所のやぐらの上から離れた
this.exitSearchLightChicoArea = function()
	if( TppMission.GetFlag( "isSearchLightChicoArea" ) == 1 ) then
		TppMission.SetFlag( "isSearchLightChicoArea", 0 )
	end
end
-- プレイヤーに攻撃された
this.commonHeliDamagedByPlayer = function()
	local radioDaemon = RadioDaemon:GetInstance()

	if ( radioDaemon:IsPlayingRadio() == false ) then
		--無線の種類に問わず再生中でなければ
		TppRadio.PlayEnqueue( "Miller_HeliAttack" )
	end
end
-- サプレッサーが壊れた
this.commonSuppressorIsBroken = function()
	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()

	if( VehicleId == "SupportHelicopter" ) then
	else
		TppRadio.DelayPlayEnqueue( "Miller_BreakSuppressor", "short" )
	end
end

-- ホフクチュートリアル
this.commmonPlayerCrawl = function()
	local phase = TppEnemy.GetPhase( this.cpID )
	local radioDaemon = RadioDaemon:GetInstance()
	if ( phase == "alert" or phase == "evasion" ) then
	else
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0968") == false )then
			if ( radioDaemon:IsPlayingRadio() == false ) then
				TppRadio.DelayPlayEnqueue( "Miller_CrawlTutorial", "short", nil, { onEnd = function() e20010_require_01.Tutorial_2Button( "tutorial_rolling", "PL_HOLD", fox.PAD_L3 ) end } )
			end
		end
	end
end

--全シーケンス共通
this.Messages = {
	Mission = {
		{ message = "MissionFailure", localFunc = "commonMissionFailure" },
		{ message = "MissionClear", localFunc = "commonMissionClear" },
		{ message = "MissionRestart", localFunc = "commonMissionCleanUp" },		-- ミッションリスタート（メニュー）
		{ message = "MissionRestartFromCheckPoint", localFunc = "commonMissionCleanUp" },		-- ミッションリスタート（チェックポイント）
		{ message = "ReturnTitle", localFunc = "Pre_commonMissionCleanUp" },		-- タイトル画面へ（メニュー）
	},
	Enemy = {
		{ message = "EnemyFindHostage", commonFunc = Common_EnemyDiscoveryNoPaz },
		{ message = "EnemyDead", commonFunc = Common_EnemyDead },
	},
	Character = {
		{ data = "gntn_cp", message = "Alert", commonFunc = Common_Alert },	--CP、アラート
		{ data = "gntn_cp", message = "Evasion", commonFunc = Common_Evasion },									--CP、エバージョン
		{ data = "gntn_cp", message = "Caution", commonFunc = Common_Caution },									--CP、コーション
		{ data = "gntn_cp", message = "Sneak", commonFunc = Common_Sneak },	--CP、スニーク
		{ data = "gntn_cp", message = "EnemySleep" , commonFunc = Common_PreEnemyCarryAdvice },					--睡眠：敵兵を担ぐアドバイス
		{ data = "gntn_cp", message = "EnemyFaint" , commonFunc = Common_PreEnemyCarryAdvice },					--気絶：敵兵を担ぐアドバイス
		{ data = "gntn_cp", message = "EnemyDying" , commonFunc = Common_PreEnemyCarryAdvice },					--瀕死：敵兵を担ぐアドバイス
		{ data = "gntn_cp", message = "EnemyDead" , commonFunc = Common_PreEnemyCarryAdvice },						--死亡：敵兵を担ぐアドバイス
		{ data = "gntn_cp",	message = "AntiAir",	commonFunc = Common_ChangeAntiAir },	-- 対空行動への切り替え
		{ data = "gntn_cp", message = "ConversationEnd", commonFunc = function() e20010_require_01.Common_ConversationEnd() end },	-- 立ち話終了時
		{ data = "gntn_cp", message = "EnemyFaint" , commonFunc = function() TppMission.SetFlag( "isDoneCQC", true ) end },		--気絶：CQCしたことあるフラグtrue
		{ data = "gntn_cp", message = "EnemyRestraint", commonFunc = function() TppMission.SetFlag( "isDoneCQC", true ) end },	--拘束：CQCしたことあるフラグtrue
		{ data = "Player", message = "RideHelicopter", commonFunc = Common_PlayerOnHeli },	--PCヘリに乗る
		{ data = "Player", message = "OnVehicleRide_End", commonFunc = Common_RideOnVehicle },	--PCが車両に乗る
		{ data = "Player", message = "OnPickUpWeapon" , commonFunc = Common_PickUpWeaopn },	--武器を入手した時
		{ data = "Player", message = "OnPickUpItem" , commonFunc = Common_PickUpItem },	--アイテムを入手した時
		{ data = "Player", message = "TryPicking", commonFunc = Common_NoTargetCagePicking },	--通常捕虜がいる檻をピッキング
		{ data = "Player", message = "OnEquipWeapon", commonFunc = Common_EquipWeapon },		--武器を装備
		{ data = "Player", message = "OnAmmoStackEmpty", commonFunc = function() e20010_require_01.Radio_OnAmmoStackEmpty() end },		--弾切れになったとき
--		{ data = "Player", message = "OnVehicleRideSneak_Start", commonFunc = function() e20010_require_01.OpenGateTruck_SneakRideON() end },	--巨大ゲート通過トラックの荷台潜入
		{ data = "Player", message = "OnVehicleRideSneak_End", commonFunc = function() e20010_require_01.OpenGateTruck_SneakRideON() end },	--巨大ゲート通過トラックの荷台潜入
		{ data = "Player", message = "OnVehicleGetOffSneak_Start", commonFunc = function() e20010_require_01.OpenGateTruck_SneakRideOFF() end },	--巨大ゲート通過トラックの荷台から降りた
		{ data = "Player", message = "NotifyStartWarningFlare", commonFunc = function() e20010_require_01.MbDvcActCallRescueHeli("SupportHelicopter", "flare") end },	--フレアグレネードを使った
		{ data = "Player", message = "CrawlRolling", commonFunc = function() DropXOFCrawRoling() end },	-- XOF ローリング
		{ data = "Player", message = "RideHelicopterWithHostage", commonFunc = function() e20010_require_01.Common_CarryHostageOnHeli() end },	-- ヘリに担ぎ乗り
		{ data = "Player", message = "OnBinocularsMode", commonFunc = function() e20010_require_01.Radio_BinocularsModeOn() end },	--双眼鏡モードになったとき任意変更
		{ data = "Player", message = "OffBinocularsMode", commonFunc = function() e20010_require_01.Radio_BinocularsModeOff() end },	--双眼鏡モードを解除したとき任意変更
		{ data = "Chico", message = "MessageHostageCarriedStart", commonFunc = Common_ChicoPazCarry },	--チコを担ぐ
		{ data = "Paz", message = "MessageHostageCarriedStart", commonFunc = Common_ChicoPazCarry },	--パスを担ぐ
		{ data = "Chico", message = "HostageLaidOnVehicle", commonFunc = Common_ChicoOnHeli },	--チコをヘリに乗せる
		{ data = "Chico", message = "DeadType", commonFunc = function() GZCommon.Common_ChicoPazDead() end },
		{ data = "Paz", message = "HostageLaidOnVehicle", commonFunc = Common_PazOnHeli },	--パスをヘリに乗せる
		{ data = "Paz", message = "DeadType", commonFunc = function() GZCommon.Common_ChicoPazDead() end },
		{ data = "SpHostage", message = "HostageLaidOnVehicle", commonFunc = function() Common_SpHostageOnHeli() end },	--処刑捕虜をヘリに乗せる
		{ data = "Hostage_e20010_004", message = "HostageLaidOnVehicle", commonFunc = Common_Hostage04OnHeli },	--捕虜０４をヘリに乗せる
		{ data = "ComEne01", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne02", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne03", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne04", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne05", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne06", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne07", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne08", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne09", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne10", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne11", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne12", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne13", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne14", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne15", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne16", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne17", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne18", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne19", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne20", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne21", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne22", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne23", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne24", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne25", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne26", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne27", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne28", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne29", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne30", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne31", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne32", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne33", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "ComEne34", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "Seq10_01", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "Seq10_02", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "Seq10_03", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "Seq10_05", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "Seq10_05", message = "SearchLightOn", commonFunc = function() TppMission.SetFlag( "isSeq10_05SL_ON", true ) end },	--サーチライトを使用
		{ data = "Seq10_06", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "Seq10_07", message = "HostageLaidOnVehicle", commonFunc = Common_EnemyOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "Hostage_e20010_001", message = "HostageLaidOnVehicle", commonFunc = Common_HostageOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "Hostage_e20010_002", message = "HostageLaidOnVehicle", commonFunc = Common_HostageOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "Hostage_e20010_003", message = "HostageLaidOnVehicle", commonFunc = Common_HostageOnHeli },	--捕虜・敵兵をヘリに乗せる
		{ data = "SpHostage", message = "MessageHostageCarriedStart", commonFunc = Common_SpHostageCarryStart },	--脱走捕虜を担いだ
		{ data = "SupportHelicopter", message = "ArriveToLandingZone", commonFunc = Common_HeliArrive },	--ヘリがＲＶに到着
		{ data = "SupportHelicopter", message = "DescendToLandingZone", commonFunc = function() e20010_require_01.Common_HeliDescend() end },	--ヘリがＲＶ上空から降下
		{ data = "SupportHelicopter", message = "LostControl", commonFunc = function() TppMission.ChangeState( "failed", "HeliLostControl" ) end },
		{ data = "SupportHelicopter", message = "DepartureToMotherBase",	commonFunc = Common_Departure },	-- 離陸開始した
--		{ data = "SupportHelicopter", message = "CloseDoor", commonFunc = function() TppMission.SetFlag( "isHeliComeToSea", false )  end },	--ヘリが扉を閉じたとき yamamoto 0805
		{ data = "SupportHelicopter", message = "CloseDoor", commonFunc = Common_HeliCloseDoor },	--ヘリが扉を閉じたとき
		{ data = "SupportHelicopter", message = "DamagedByPlayer", commonFunc = function() this.commonHeliDamagedByPlayer() end },	--プレイヤーから攻撃を受けた
--		{ data = "Hostage_e20010_001", message = "Dead", commonFunc = function() TppMission.SetFlag( "isHostageUnusual", true ) end },	--チコ周辺の捕虜１、死亡
		{ data = "Hostage_e20010_001", message = "HostageSleep", commonFunc = function() TppMission.SetFlag( "isHostageUnusual", true ) end },	--チコ周辺の捕虜１、睡眠
		{ data = "Hostage_e20010_001", message = "HostageFaint", commonFunc = function() TppMission.SetFlag( "isHostageUnusual", true ) end },	--チコ周辺の捕虜１、気絶
--		{ data = "Hostage_e20010_002", message = "Dead", commonFunc = function() TppMission.SetFlag( "isHostageUnusual", true ) end },	--チコ周辺の捕虜２、死亡
		{ data = "Hostage_e20010_002", message = "HostageSleep", commonFunc = function() TppMission.SetFlag( "isHostageUnusual", true ) end },	--チコ周辺の捕虜２、睡眠
		{ data = "Hostage_e20010_002", message = "HostageFaint", commonFunc = function() TppMission.SetFlag( "isHostageUnusual", true ) end },	--チコ周辺の捕虜２、気絶
		{ data = "Hostage_e20010_001", message = "MessageHostageCarriedStart", commonFunc = Common_NomalHostage01CarryStart },			--通常捕虜１を担ぐ
		{ data = "Hostage_e20010_002", message = "MessageHostageCarriedStart", commonFunc = Common_NomalHostage02CarryStart },			--通常捕虜２を担ぐ
		{ data = "Hostage_e20010_003", message = "MessageHostageCarriedStart", commonFunc = Common_NomalHostage03CarryStart },			--通常捕虜３を担ぐ
		{ data = "Hostage_e20010_004", message = "MessageHostageCarriedStart", commonFunc = Common_NomalHostage04CarryStart },			--通常捕虜４を担ぐ
		{ data = "Hostage_e20010_001", message = "Dead", commonFunc = Common_Hostage001_Dead },	--通常捕虜１、死亡
		{ data = "Hostage_e20010_002", message = "Dead", commonFunc = Common_Hostage002_Dead },	--通常捕虜２、死亡
		{ data = "Hostage_e20010_003", message = "Dead", commonFunc = Common_Hostage003_Dead },	--通常捕虜３、死亡
		{ data = "Hostage_e20010_004", message = "Dead", commonFunc = Common_Hostage004_Dead },	--通常捕虜４、死亡
		{ data = "SpHostage",		   message = "Dead", commonFunc = Common_SpHostage_Dead },	--脱走捕虜死亡
--		{ data = "Tactical_Vehicle_WEST_001", message = "VehicleBroken", commonFunc = Common_VehicleBroken },	--　ビークル破壊
		{ data = "Tactical_Vehicle_WEST_002", message = "VehicleBroken", commonFunc = Common_VehicleBroken },	--　ビークル破壊
		{ data = "Tactical_Vehicle_WEST_003", message = "VehicleBroken", commonFunc = Common_VehicleBroken },	--　ビークル破壊
		{ data = "Tactical_Vehicle_WEST_004", message = "VehicleBroken", commonFunc = Common_VehicleBroken },	--　ビークル破壊
		{ data = "Tactical_Vehicle_WEST_005", message = "VehicleBroken", commonFunc = Common_VehicleBroken },	--　ビークル破壊
		{ data = "Cargo_Truck_WEST_002", message = "VehicleBroken", commonFunc = Common_TruckBroken },	--　トラック破壊
		{ data = "Cargo_Truck_WEST_003", message = "VehicleBroken", commonFunc = Common_TruckBroken },	--　トラック破壊
		{ data = "Cargo_Truck_WEST_004", message = "VehicleBroken", commonFunc = Common_TruckBroken },	--　トラック破壊
		{ data = "ComEne34", message = "EnemyDead", commonFunc = function() TppMission.SetFlag( "isCenterTowerEnemy", true ) end },	--死亡
		{ data = "e20010_SecurityCamera_01", message = "Dead", commonFunc = function() e20010_require_01.Common_SecurityCameraBroken() end },
		{ data = "e20010_SecurityCamera_02", message = "Dead", commonFunc = function() e20010_require_01.Common_SecurityCameraBroken() end },
		{ data = "e20010_SecurityCamera_03", message = "Dead", commonFunc = function() e20010_require_01.Common_SecurityCameraBroken() end },
		{ data = "e20010_SecurityCamera_04", message = "Dead", commonFunc = function() e20010_require_01.Common_SecurityCameraBroken() end },
		{ data = "e20010_SecurityCamera_01", message = "PowerOFF", commonFunc = function() e20010_require_01.Common_SecurityCameraPowerOff() end },
		{ data = "e20010_SecurityCamera_02", message = "PowerOFF", commonFunc = function() e20010_require_01.Common_SecurityCameraPowerOff() end },
		{ data = "e20010_SecurityCamera_03", message = "PowerOFF", commonFunc = function() e20010_require_01.Common_SecurityCameraPowerOff() end },
		{ data = "e20010_SecurityCamera_04", message = "PowerOFF", commonFunc = function() e20010_require_01.Common_SecurityCameraPowerOff() end },
		{ data = "e20010_SecurityCamera_01", message = "PowerON", commonFunc = function() e20010_require_01.Common_SecurityCameraPowerOn() end },
		{ data = "e20010_SecurityCamera_02", message = "PowerON", commonFunc = function() e20010_require_01.Common_SecurityCameraPowerOn() end },
		{ data = "e20010_SecurityCamera_03", message = "PowerON", commonFunc = function() e20010_require_01.Common_SecurityCameraPowerOn() end },
		{ data = "e20010_SecurityCamera_04", message = "PowerON", commonFunc = function() e20010_require_01.Common_SecurityCameraPowerOn() end },
		{ data = "e20010_SecurityCamera_01", message = "Alert", commonFunc = function() e20010_require_01.Common_SecurityCameraAlert() end },
		{ data = "e20010_SecurityCamera_02", message = "Alert", commonFunc = function() e20010_require_01.Common_SecurityCameraAlert() end },
		{ data = "e20010_SecurityCamera_03", message = "Alert", commonFunc = function() e20010_require_01.Common_SecurityCameraAlert() end },
		{ data = "e20010_SecurityCamera_04", message = "Alert", commonFunc = function() e20010_require_01.Common_SecurityCameraAlert() end },
	},
	Trap = {
		{ data = "Wave_OFF", message = "Enter", commonFunc = function() TppDataUtility.DestroyEffectFromGroupId( "splash01" ) end },
		{ data = "Wave_OFF", message = "Exit", commonFunc = function() TppDataUtility.CreateEffectFromGroupId( "splash01" ) end },
		{ data = "S01_HeliPort", message = "Enter", commonFunc = function() TppMission.SetFlag( "isSaveAreaNo", 1 ) end },
		{ data = "S01_HeliPort", message = "Exit", commonFunc = function() TppMission.SetFlag( "isSaveAreaNo", 0 ) end },
		{ data = "S02_SeaSide", message = "Enter", commonFunc = function() TppMission.SetFlag( "isSaveAreaNo", 2 ) end },
		{ data = "S02_SeaSide", message = "Exit", commonFunc = function() TppMission.SetFlag( "isSaveAreaNo", 0 ) end },
		{ data = "S03_StartCliff", message = "Enter", commonFunc = function() TppMission.SetFlag( "isSaveAreaNo", 3 ) end },
		{ data = "S03_StartCliff", message = "Exit", commonFunc = function() TppMission.SetFlag( "isSaveAreaNo", 0 ) end },
		{ data = "S04_WareHouse", message = "Enter", commonFunc = function() TppMission.SetFlag( "isSaveAreaNo", 4 ) end },
		{ data = "S04_WareHouse", message = "Exit", commonFunc = function() TppMission.SetFlag( "isSaveAreaNo", 0 ) end },
		{ data = "RainDropCamera", message = "Enter", commonFunc = function() TppEffectUtility.SetCameraRainDropRate( 3.3 ) end },
		{ data = "RainDropCamera", message = "Exit", commonFunc = function() TppEffectUtility.SetCameraRainDropRate( 1.0 ) end },
		{ data = "WoodTurret_RainFilter01", message = "Enter", commonFunc = WoodTurret_RainFilter_ON },
		{ data = "WoodTurret_RainFilter02", message = "Enter", commonFunc = WoodTurret_RainFilter_ON },
		{ data = "WoodTurret_RainFilter03", message = "Enter", commonFunc = WoodTurret_RainFilter_ON },
		{ data = "WoodTurret_RainFilter04", message = "Enter", commonFunc = WoodTurret_RainFilter_ON },
		{ data = "WoodTurret_RainFilter05", message = "Enter", commonFunc = WoodTurret_RainFilter_ON },
		{ data = "WoodTurret_RainFilter01", message = "Exit", commonFunc = WoodTurret_RainFilter_OFF },
		{ data = "WoodTurret_RainFilter02", message = "Exit", commonFunc = WoodTurret_RainFilter_OFF },
		{ data = "WoodTurret_RainFilter03", message = "Exit", commonFunc = WoodTurret_RainFilter_OFF },
		{ data = "WoodTurret_RainFilter04", message = "Exit", commonFunc = WoodTurret_RainFilter_OFF },
		{ data = "WoodTurret_RainFilter05", message = "Exit", commonFunc = WoodTurret_RainFilter_OFF },
		{ data = "MissionArea_Out", message = "Enter", commonFunc = MissionArea_Out },
		{ data = "CTE0010_0280_NearArea", message = "Enter", commonFunc = function() TppMission.SetFlag( "isCTE0010_0280_NearArea", true ) end },
		{ data = "CTE0010_0280_NearArea", message = "Exit", commonFunc = function() TppMission.SetFlag( "isCTE0010_0280_NearArea", false ) end },
		{ data = "CTE0010_0310_NearArea", message = "Enter", commonFunc = function() TppMission.SetFlag( "isCTE0010_0310_NearArea", true ) end },
		{ data = "CTE0010_0310_NearArea", message = "Exit", commonFunc = function() TppMission.SetFlag( "isCTE0010_0310_NearArea", false ) end },
		{ data = "SaftyAreaTrap01", message = "Enter", commonFunc = function() TppMission.SetFlag( "isSaftyArea01", true ) end },
		{ data = "SaftyAreaTrap01", message = "Exit", commonFunc = function() TppMission.SetFlag( "isSaftyArea01", false ) end },
		{ data = "SaftyAreaTrap02", message = "Enter", commonFunc = function() TppMission.SetFlag( "isSaftyArea02", true ) end },
		{ data = "SaftyAreaTrap02", message = "Exit", commonFunc = function() TppMission.SetFlag( "isSaftyArea02", false ) end },
		{ data = "Radio_DangerArea", message = "Enter", commonFunc = function() TppMission.SetFlag( "isDangerArea", true ) end },
		{ data = "Radio_DangerArea", message = "Exit", commonFunc = function() TppMission.SetFlag( "isDangerArea", false ) end },
		{ data = "Check_SeaCliff", message = "Enter", commonFunc = function() TppMission.SetFlag( "isInSeaCliffArea", true ) end },	--旧収容所側の崖の近くにいる
		{ data = "Check_SeaCliff", message = "Exit", commonFunc = function() TppMission.SetFlag( "isInSeaCliffArea", false ) end },	--旧収容所側の崖の近くにいない
		{ data = "Check_StartCliff", message = "Enter", commonFunc = function() TppMission.SetFlag( "isInStartCliffArea", true ) end },	--スタート崖側の崖の近くにいる
		{ data = "Check_StartCliff", message = "Exit", commonFunc = function() TppMission.SetFlag( "isInStartCliffArea", false ) end },	--スタート崖側の崖の近くにいない
		{ data = "Check_NoKillGunAdviceAsylum", message = "Enter", commonFunc = function() TppMission.SetFlag( "isGunTutorialArea", true ) end },	--麻酔儒チュートリアルエリアにいる
		{ data = "Check_NoKillGunAdviceAsylum", message = "Exit", commonFunc = function() TppMission.SetFlag( "isGunTutorialArea", false ) end },	--麻酔儒チュートリアルエリアにいない
		{ data = "Radio_SearchChico", message = "Enter", commonFunc = this.enterSearchLightChicoArea },	--旧収容所のやぐらのうえにいる
		{ data = "Radio_SearchChico", message = "Exit", commonFunc = this.exitSearchLightChicoArea },	--旧収容所のやぐらのうえにいない
		{ data = "AsyInsideRouteChange_01", message = "Enter", commonFunc = AsyInsideRouteChange_01 },
		{ data = "EastCampMoveTruck_Start", message = "Enter", commonFunc = EastCampMoveTruck_Start },
		{ data = "EastCampSouth_SL_RouteChange", message = "Enter", commonFunc = EastCampSouth_SL_RouteChange },
		{ data = "GunTutorialEnemyRouteChange", message = "Enter", commonFunc = GunTutorialEnemyRouteChange },
		{ data = "Talk_AsyWC", message = "Enter", commonFunc = Talk_AsyWC },
		{ data = "Talk_ChicoTape", message = "Enter", commonFunc = Talk_ChicoTape },
		{ data = "Talk_EscapeHostage", message = "Enter", commonFunc = Talk_EscapeHostage },
		{ data = "VehicleStart", message = "Enter", commonFunc = VehicleStart },
		{ data = "Center2F_EneRouteChange", message = "Enter", commonFunc = Center2F_EneRouteChange },
--		{ data = "ComEne25RouteChange01", message = "Enter", commonFunc = ComEne25RouteChange01 },
--		{ data = "ComEne25RouteChange02", message = "Enter", commonFunc = ComEne25RouteChange02 },
--		{ data = "ComEne25RouteChange03", message = "Enter", commonFunc = ComEne25RouteChange03 },
		{ data = "SmokingRouteChange", message = "Enter", commonFunc = SmokingRouteChange },
		{ data = "BoilarEnemyRouteChange", message = "Enter", commonFunc = BoilarEnemyRouteChange },
		{ data = "ComEne11_RouteChange", message = "Enter", commonFunc = ComEne11_RouteChange },
		{ data = "GateOpenTruckRouteChange", message = "Enter", commonFunc = GateOpenTruckRouteChange },
		{ data = "Seaside2manStartRouteChange", message = "Enter", commonFunc = Seaside2manStartRouteChange },
		{ data = "Seq20_05_RouteChange", message = "Enter", commonFunc = Seq20_05_RouteChange },
		{ data = "Talk_KillSpHostage01", message = "Enter", commonFunc = Talk_KillSpHostage01 },
		{ data = "Seq30_PazCheck_Start", message = "Enter", commonFunc = Seq30_PazCheck_Start },
		{ data = "Seq30_PatrolVehicle_Start", message = "Enter", commonFunc = Seq30_PatrolVehicle_Start },
		{ data = "Radio_RouteDrain", message = "Enter", commonFunc = function() e20010_require_01.Radio_RouteDrain() end },						--管理棟に入れる排水溝を通った
		{ data = "Radio_InCenterCoverAdvice", message = "Enter", commonFunc = function() e20010_require_01.Radio_InCenterCoverAdvice() end },	--管理棟に入った
		{ data = "Radio_HohukuAdvice", message = "Enter", commonFunc = function() TppRadio.DelayPlayEnqueue( "Miller_HohukuAdvice" ,"short" ) end },	--排水溝の各入り口
		{ data = "XofMarkerOff_Trap", message = "Enter", commonFunc = function() TppMarkerSystem.DisableMarker{ markerId = "Marker_XOF" } end },		--ＸＯＦワッペンが落ちてる場所に来たのでマーカーを消す
		{ data = "RV_MarkerOFF", message = "Enter", commonFunc = function() TppMarkerSystem.DisableMarker{ markerId = "20010_marker_RV" } end },		--ＲＶ近くに着たので、ＲＶマーカーを消す
		{ data = "HostageQuiet_Trap", message = "Enter", commonFunc = function() e20010_require_01.HostageQuiet_Trap() end },
		{ data = "SpHostageMonologue", message = "Enter", commonFunc = function() e20010_require_01.SpHostageMonologue() end },
		{ data = "Hostage01Monologue", message = "Enter", commonFunc = function() e20010_require_01.Hostage01Monologue() end },
		{ data = "Hostage02Monologue", message = "Enter", commonFunc = function() e20010_require_01.Hostage02Monologue() end },
		{ data = "Hostage03Monologue", message = "Enter", commonFunc = function() e20010_require_01.Hostage03Monologue() end },
		{ data = "Hostage04Monologue", message = "Enter", commonFunc = function() e20010_require_01.Hostage04Monologue() end },
		{ data = "PazFovaChangeTrap", message = "Enter", commonFunc = function() TppEnemy.SetFormVariation( "Paz" , "fovaPazBeforeDemo" ) end },
		{ data = "demoWarpOKTrap", message = "Enter", commonFunc = function() TppMission.SetFlag( "isDemoRelativePlay", true ) end },
		{ data = "demoWarpOKTrap", message = "Exit", commonFunc = function() TppMission.SetFlag( "isDemoRelativePlay", false ) end },
		{ data = "Radio_SecurityCameraAdvice", message = "Enter", commonFunc = function() e20010_require_01.Radio_SecurityCameraAdvice() end },	--監視カメラ注意促し
	},
	Gimmick = {
		--スイッチライト
		{ data = "gntn_center_SwitchLight", message = "SwitchOn", commonFunc = SwitchLight_ON },	--管理棟スイッチライトＯＮ
		{ data = "gntn_center_SwitchLight", message = "SwitchOff", commonFunc = SwitchLight_OFF },	--管理棟スイッチライトＯＦＦ
		--ピッキングドア
		{ data = "AsyPickingDoor05", message = "DoorUnlock", commonFunc = function() TppMission.SetFlag( "isAsyPickingDoor05", true ) end },
		{ data = "AsyPickingDoor15", message = "DoorUnlock", commonFunc = function() TppMission.SetFlag( "isAsyPickingDoor15", true ) end },
		--壊れヤグラ
		{ data = "WoodTurret01", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--スタート崖のヤグラ破壊時
		{ data = "WoodTurret02", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--東難民キャンプ（南）のヤグラ破壊時
		{ data = "WoodTurret03", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--東難民キャンプ（北）のヤグラ破壊時
		{ data = "WoodTurret04", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--西難民キャンプのヤグラ破壊時
		{ data = "WoodTurret05", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--旧収容施設のヤグラ破壊時
		--壊れヤグラのサーチライト
		{ data = "SL_WoodTurret01", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--スタート崖のヤグラのサーチライト破壊時
		{ data = "SL_WoodTurret02", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--東難民キャンプ（南）のヤグラのサーチライト破壊時
		{ data = "SL_WoodTurret03", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--東難民キャンプ（北）のヤグラのサーチライト破壊時
		{ data = "SL_WoodTurret04", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--西難民キャンプのヤグラのサーチライト破壊時
		{ data = "SL_WoodTurret05", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--旧収容施設のヤグラのサーチライト破壊時
		--鉄製ヤグラのサーチライト
		{ data = "gntn_area01_searchLight_000", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--倉庫武器庫近くヤグラのサーチライト破壊時
		{ data = "gntn_area01_searchLight_001", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--倉庫武器庫近くヤグラのサーチライト破壊時
		{ data = "gntn_area01_searchLight_002", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--倉庫ヤグラのサーチライト破壊時
		{ data = "gntn_area01_searchLight_003", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--倉庫ヤグラのサーチライト破壊時
		{ data = "gntn_area01_searchLight_004", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--ヘリポートヤグラのサーチライト破壊時
		{ data = "gntn_area01_searchLight_005", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--ヘリポートヤグラのサーチライト破壊時
		{ data = "gntn_area01_searchLight_006", message = "BreakGimmick", commonFunc = Common_Gimmick_Break },	--ヘリポートヤグラのサーチライト破壊時
		--対空機関砲
		{ data = "gntn_area01_antiAirGun_000", message = "BreakGimmick", commonFunc = Common_AAG01_Break },	--倉庫武器庫近く対空機関砲破壊時
		{ data = "gntn_area01_antiAirGun_001", message = "BreakGimmick", commonFunc = Common_AAG02_Break },	--ヘリポート前対空機関砲破壊時
		{ data = "gntn_area01_antiAirGun_002", message = "BreakGimmick", commonFunc = Common_AAG03_Break },	--ヘリポート東対空機関砲破壊時
		{ data = "gntn_area01_antiAirGun_003", message = "BreakGimmick", commonFunc = Common_AAG04_Break },	--ヘリポート西対空機関砲破壊時
		--　麻酔銃で壊れ物を撃った
		{ message = "HitTranqDamage", commonFunc = function() TppRadio.PlayEnqueue( "Miller_UnKillGunAdvice" ) end },
	},
	Radio = {
		{ data = "ComEne01", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne01" ) end },
		{ data = "ComEne02", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne02" ) end },
		{ data = "ComEne03", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne03" ) end },
		{ data = "ComEne04", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne04" ) end },
		{ data = "ComEne05", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne05" ) end },
		{ data = "ComEne06", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne06" ) end },
		{ data = "ComEne07", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne07" ) end },
		{ data = "ComEne08", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne08" ) end },
		{ data = "ComEne09", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne09" ) end },
		{ data = "ComEne10", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne10" ) end },
		{ data = "ComEne11", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne11" ) end },
		{ data = "ComEne12", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne12" ) end },
		{ data = "ComEne13", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne13" ) end },
		{ data = "ComEne14", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne14" ) end },
		{ data = "ComEne15", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne15" ) end },
		{ data = "ComEne16", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne16" ) end },
		{ data = "ComEne17", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne17" ) end },
		{ data = "ComEne18", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne18" ) end },
		{ data = "ComEne19", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne19" ) end },
		{ data = "ComEne20", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne20" ) end },
		{ data = "ComEne21", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne21" ) end },
		{ data = "ComEne22", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne22" ) end },
		{ data = "ComEne23", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne23" ) end },
		{ data = "ComEne24", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne24" ) end },
		{ data = "ComEne25", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne25" ) end },
		{ data = "ComEne26", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne26" ) end },
		{ data = "ComEne27", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne27" ) end },
		{ data = "ComEne28", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne28" ) end },
		{ data = "ComEne29", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne29" ) end },
		{ data = "ComEne30", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne30" ) end },
		{ data = "ComEne31", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne31" ) end },
		{ data = "ComEne32", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne32" ) end },
		{ data = "ComEne33", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne33" ) end },
		{ data = "ComEne34", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "ComEne34" ) end },
		{ data = "Seq10_01", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "Seq10_01" ) end },
		{ data = "Seq10_02", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "Seq10_02" ) end },
		{ data = "Seq10_03", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "Seq10_03" ) end },
		{ data = "Seq10_05", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "Seq10_05" ) end },
		{ data = "Seq10_06", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "Seq10_06" ) end },
		{ data = "Seq10_07", message = "EspionageRadioCandidate" , commonFunc = function() Common_enemyIntel( "Seq10_07" ) end },
		{ data = "SpHostage", message = "EspionageRadioPlayButton" , commonFunc = function() TppMission.SetFlag( "isSpHostageEncount", true ) end },
		{ data = "Chico", message = "EspionageRadioPlayButton" , commonFunc = function() e20010_require_01.Chico_Espion() end },
		{ data = "Paz", message = "EspionageRadioPlayButton" , commonFunc = function() e20010_require_01.Paz_Espion() end },
		{ data = "e0010_rtrg0370",		message = "RadioEventMessage", commonFunc = function() e20010_require_01.commonHeliLeaveExtension() end },
		{ data = "e0010_rtrg0380",		message = "RadioEventMessage", commonFunc = function() e20010_require_01.commonHeliLeaveExtension() end },
		{ data = "e0010_rtrg1240",		message = "RadioEventMessage", commonFunc = function() e20010_require_01.commonHeliLeaveExtension() end },
		{ data = "e0010_rtrg1220",		message = "RadioEventMessage", commonFunc = function() e20010_require_01.Tutorial_1Button("tutorial_mb_device","MB_DEVICE") end },
	},
	Terminal = {
		{ message = "MbDvcActCallRescueHeli", commonFunc = function() e20010_require_01.MbDvcActCallRescueHeli("SupportHelicopter", "MbDvc") end },	--支援ヘリ要請
--		{ message = "MbDvcActOpenHeliCall", commonFunc = function() TppRadio.PlayEnqueue( "Miller_choseLZ" ) end },			--ヘリ要請ポイント選択画面
	},
	Timer = {
		{ data = "Timer_CallCautionSiren", 		message = "OnEnd", commonFunc = function() e20010_require_01.Timer_CallCautionSiren() end },
		{ data = "Timer_RescuePaz1", 			message = "OnEnd", commonFunc = function() e20010_require_01.Radio_RescuePaz1() end },
		{ data = "Timer_RescuePaz2", 			message = "OnEnd", commonFunc = function() e20010_require_01.Radio_RescuePaz2() end },
		{ data = "Timer_MillerHistory1", 		message = "OnEnd", commonFunc = function() e20010_require_01.Radio_MillerHistory1() end },
		{ data = "Timer_Behind", 				message = "OnEnd", commonFunc = TimerBehindCount },
		{ data = "Timer_GetPazInfo", 			message = "OnEnd", commonFunc = function() e20010_require_01.Radio_GetPazInfo() end },
--		{ data = "Timer_takePazToRVPoint01", 	message = "OnEnd", commonFunc = function() TppRadio.Play("Miller_takePazToRVPoint01") end },
		{ data = "Timer_takePazToRVPoint01", 	message = "OnEnd", commonFunc = Timer_takePazToRVPoint01_OnEnd },
		{ data = "Timer_ListenTape", 			message = "OnEnd", commonFunc = function() e20010_require_01.Radio_ListenTape() end },
		{ data = "Timer_HeliCloseDoor_01",		message = "OnEnd", commonFunc = function() Radio_HeliCloseDoor("RadioSet01") end },
		{ data = "Timer_HeliCloseDoor_01b", 	message = "OnEnd", commonFunc = function() Radio_HeliCloseDoor("RadioSet01b") end },
		{ data = "Timer_HeliCloseDoor_02",		message = "OnEnd", commonFunc = function() Radio_HeliCloseDoor("RadioSet02") end },
		{ data = "Timer_HeliCloseDoor_03",		message = "OnEnd", commonFunc = function() Radio_HeliCloseDoor("RadioSet03") end },
		{ data = "Timer_HeliCloseDoor_04",		message = "OnEnd", commonFunc = function() Radio_HeliCloseDoor("RadioSet04") end },
		{ data = "Timer_HeliCloseDoor_04b", 	message = "OnEnd", commonFunc = function() Radio_HeliCloseDoor("RadioSet04b") end },
		{ data = "Timer_HeliCloseDoor_05",		message = "OnEnd", commonFunc = function() Radio_HeliCloseDoor("RadioSet05") end },
		{ data = "Timer_HeliCloseDoor_05b", 	message = "OnEnd", commonFunc = function() Radio_HeliCloseDoor("RadioSet05b") end },
		{ data = "Timer_HeliCloseDoor_06",		message = "OnEnd", commonFunc = function() Radio_HeliCloseDoor("RadioSet06") end },
		{ data = "Timer_HeliCloseDoor_07",		message = "OnEnd", commonFunc = function() Radio_HeliCloseDoor("RadioSet07") end },
		{ data = "Timer_pleaseLeaveHeli", 		message = "OnEnd", commonFunc = function() e20010_require_01.commonHeliLeaveJudge() end },
		{ data = "Timer_PlayerOnHeliAdvice", 	message = "OnEnd", commonFunc = function() e20010_require_01.Radio_PlayerOnHeliAdvice() end },
		{ data = "Timer_SwitchOFF", 			message = "OnEnd", commonFunc = Timer_SwitchOFF },
		{ data = "Timer_CarryDownInDanger", 	message = "OnEnd", commonFunc = function() e20010_require_01.Radio_CarryDownInDanger() end },
	},
	RadioCondition = {
--		{ message = "NearVehicle", commonFunc = function() e20010_require_01.Common_e0010_rtrg0740() end },
--		{ message = "PlayerDamaged", commonFunc = function() TppRadio.Playｆｆdio.PlayEnqueue( "Miller_SpRecoveryLifeAdvice" ) end },
		{ message = "PlayerHurt", commonFunc = function() TppRadio.DelayPlay( "Miller_CuarAdvice", "mid" ) end },
		{ message = "PlayerCureComplete", commonFunc = function() TppRadio.PlayEnqueue( "Miller_SpRecoveryLifeAdvice" ) end },
		{ message = "PlayerBehind", commonFunc = Common_behind },
--		{ message = "PlayerElude", commonFunc = function() e20010_require_01.Common_Elude() end },
		{ message = "SuppressorIsBroken", commonFunc = function() this.commonSuppressorIsBroken() end },
	},
	Subtitles = {
		{ data="rdps0z00_0x1010", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Tutorial_1Button("tutorial_bino","PL_SUB_CAMERA") end },		--双眼鏡で状況を把握
--		{ data="rdps0z00_0x1012", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Tutorial_1Button("tutorial_controll",fox.PAD_SELECT) end },		--操作方法はポーズ画面
		{ data="rdps0z00_0x1012", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Sub_rdps0z00_0x1012() end },										--操作方法はポーズ画面
		{ data="pprg1001_161010", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Tutorial_1Button("tutorial_mb_device","MB_DEVICE") end },		--目標の位置は端末で確認
		{ data="pprg1001_5u1010", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Tutorial_1Button("tutorial_advice","PL_CALL") end },			--アドバイスが必要なら連絡
		{ data="pprg1001_3i1010", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Tutorial_1Button("tutorial_radio","PL_CALL") end },				--何が見える？CALLボタンでこちらから情報を伝える
		{ data="pprg1001_511010", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Tutorial_2Button("tutorial_attack","PL_HOLD","PL_SHOT") end },	--構えボタンと攻撃ボタン（字幕は５１１０１０）
		{ data="pprg1001_5l1010", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Tutorial_1Button("tutorial_climeb_up","PL_ACTION") end },		--段差を上るにはアクションボタンだ（字幕は５Ｌ１０１０）
		{ data="pprg1001_261110", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Tutorial_1Button("tutorial_mb_device","MB_DEVICE") end },		--ヘリを呼んでくれ
--		{ data="rdps1001_111010", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Tutorial_1Button("tutorial_apc",fox.PAD_SELECT) end },			--そいつは機関砲も撃てる
		{ data="rdps1001_111010", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Sub_rdps1001_111010() end },										--そいつは機関砲も撃てる
		{ data="pprg1001_3k1010", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Tutorial_1Button("tutorial_cqc","PL_CQC") end },				--近くの敵には近接戦闘術……『CQC』が有効だ
		{ data="rdps1000_181015", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Sub_RDPS1000_181015() end },	--排除するなら銃を使え
		{ data="ENQT1000_1m1310", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Sub_ENQT1000_1m1310() end },	--パス情報尋問セリフ
		{ data="sltb0z10_5y1010", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Sub_SLTB0z10_5y1010() end },	--（バイタルチェックをするんだろ？）→了解
		{ data="rdps2110_141010", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Sub_rdps2110_141010() end },	--情報を聞き出せ。尋問だ
		{ data="prsn1000_2q1012", message = "SubtitlesFinishedEventMessage", commonFunc = function() e20010_require_01.SpHostageInformation() end },
	},
	Demo = {
		{ data="p11_020001_000", message="invis_cam", commonFunc = function() TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20010_SecurityCamera_02", false ) end },
		{ data="p11_020001_000", message="lightOff", commonFunc = function() TppGadgetUtility.SetSwitch("gntn_center_SwitchLight",false) end },
		{ data="p11_020001_000", message="lightOn", commonFunc = function() TppGadgetUtility.SetSwitch("gntn_center_SwitchLight",true) end },
		{ data="p11_020005_000", message="open_gate", commonFunc = OpenGateRouteChange },
	},
	UI = {
		{ message = "GetAllCassetteTapes" , commonFunc = function() TppRadio.DelayPlayEnqueue("Miller_AllGetTape", "mid" ) end },	--カセットテープ全取得
	},
}

------------------------------------------------------------------------------------------------------------------------------------
--指定シーケンス
local myMessages = {
	Character = {
		{ data = "gntn_cp", message = "EnemyRestraint", commonFunc = function() e20010_require_01.Radio_QustionAdvice() end },			-- 拘束時無線
		{ data = "Player", message = "OnBinocularsMode", commonFunc = function() e20010_require_01.Radio_BinocularsTutorial() end },	--双眼鏡モードになったとき
		{ data = "ComEne15", message = "MessageRoutePoint", commonFunc = function() e20010_require_01.Select_ComEne15_NodeAction() end },	--双眼鏡モードになったとき
	},
	Trap = {
		{ data = "DuctMarkerOFF", message = "Enter", commonFunc = function() TppMarkerSystem.DisableMarker{ markerId = "Marker_Duct" } end },				--排水溝マーカーＯＦＦ
		{ data = "Radio_SwitchLight", message = "Enter", commonFunc = function() TppRadio.DelayPlayEnqueue( "Miller_SwitchLightAdvice02", "short" ) end },	--スイッチライト
		{ data = "Radio_SwitchLightAdvice", message = "Enter", commonFunc = function() e20010_require_01.Select_SwitchLightAdvice() end },					--配電盤お知らせ
		{ data = "Radio_NearRvEscapedTarget", message = "Enter", commonFunc = function() e20010_require_01.Radio_NearRvEscapedTarget() end },				--チコパスと会い、ＲＶに近づく
		{ data = "Radio_InCenterAdvice", message = "Enter", commonFunc = function()  end },	--管理棟に近づく
		{ data = "Radio_SearchChico", message = "Enter", commonFunc = function() e20010_require_01.Radio_SearchChico() end },								--旧収容所のやぐらに登った
		{ data = "Radio_MillerHistory2", message = "Enter", commonFunc = function() e20010_require_01.Radio_DramaChico() end },								--
		{ data = "Radio_InOldAsylum", message = "Enter", commonFunc = function() TppRadio.DelayPlayEnqueue( "Miller_InOldAsylum", "short" ) end },			--旧収容所の近くに入った
		{ data = "Radio_PaztakeRoute_HeliPort", message = "Exit", commonFunc = function() e20010_require_01.Radio_Cheer() end },							--管理棟から離れた
		{ data = "Talk_Helipad02", message = "Enter", commonFunc = function() e20010_require_01.Talk_Helipad02() end },
	},
	Timer = {
	},
	RadioCondition = {
		{ message = "EnableCQC", commonFunc = function() e20010_require_01.Radio_CQCTutorial() end },
		{ message = "PlayerElude", commonFunc = function() e20010_require_01.Common_Elude() end },
		{ message = "PlayerCrawl", commonFunc = function() this.commmonPlayerCrawl() end },
	},
}
------------------------------------------------------------------------------------------------------------------------------------
--　ミッション失敗判定
------------------------------------------------------------------------------------------------------------------------------------
this.commonMissionFailure = function( manager, messageId, message )

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

	-- ミッション失敗原因に応じて分岐させてそれぞれ演出処理を行う
	--ヘリ墜落
	if( message == "HeliLostControl" )	then
		--プレイヤーが乗っていたらタイムパラドックス
		if( TppMission.GetFlag( "isPlayerOnHeli" ) == true ) then
			SetGameOverTimeParadox()									-- TimeParadox
			this.CounterList.GameOverRadioName = "Miller_DeadPlayer"	-- ゲームオーバー音声を登録
			TppSequence.ChangeSequence( "Seq_Mission_Failed" )	-- ミッション失敗シーケンスへ

		--パスチコが乗っていたら
		elseif( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true and
				TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) then
			SetGameOverMissionFailed()										-- MissionFailed
			this.CounterList.GameOverRadioName = "Miller_StopMission"			-- ゲームオーバー音声を登録
			TppSequence.ChangeSequence( "Seq_Mission_Failed" )	-- ミッション失敗シーケンスへ
			-- ミッション失敗テロップ
			hudCommonData:CallFailedTelop( "gameover_reason_target_died" )	  --- 引数はlangIdのメッセージID
		--パスが乗っていたら
		elseif( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then
			SetGameOverMissionFailed()										-- MissionFailed
			this.CounterList.GameOverRadioName = "Miller_HeliDownPaz"			-- ゲームオーバー音声を登録
			TppSequence.ChangeSequence( "Seq_Mission_Failed" )				-- ミッション失敗シーケンスへ
			-- ミッション失敗テロップ
			hudCommonData:CallFailedTelop( "gameover_reason_target_died" )

		--チコが乗っていたら
		elseif( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) then
			SetGameOverMissionFailed()										-- MissionFailed
			this.CounterList.GameOverRadioName = "Miller_HeliDownChico"			-- ゲームオーバー音声を登録
			TppSequence.ChangeSequence( "Seq_Mission_Failed" )	-- ミッション失敗シーケンスへ
			-- ミッション失敗テロップ
			hudCommonData:CallFailedTelop( "gameover_reason_target_died" )	  --- 引数はlangIdのメッセージID

		--プレイヤーが乗っていなかったら
		else
			TppSequence.ChangeSequence( "Seq_HelicopterDeadNotOnPlayer" )
			-- ミッション失敗テロップ
			hudCommonData:CallFailedTelop( "gameover_reason_heli_destroyed" )	 --- 引数はlangIdのメッセージID
		end
	-- チコ死亡
	elseif( message == "ChicoDead" )  then
		if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) then	--ヘリに乗っていたら
			this.CounterList.GameOverFadeTime = 1.0							-- フェード
		else
			--ヘリに乗っていない
		end
		---------------------------------------------------------------------------------------
		SetGameOverMissionFailed()										-- MissionFailed
		this.CounterList.GameOverRadioName = "Miller_DeadChico"			-- ゲームオーバー音声を登録
		GZCommon.PlayCameraAnimationOnChicoPazDead("Chico")
		TppSequence.ChangeSequence( "Seq_Mission_Failed" )				-- ミッション失敗シーケンスへ
		-- ミッション失敗テロップ
		hudCommonData:CallFailedTelop( "gameover_reason_target_died" )	  --- 引数はlangIdのメッセージID

	--パス死亡
	elseif( message == "PazDead" )	then
		if( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then	--ヘリに乗っていたら
			this.CounterList.GameOverFadeTime = 1.0							-- フェード
		else
			--ヘリに乗っていない
		end
		---------------------------------------------------------------------------------------
		SetGameOverMissionFailed()										-- MissionFailed
		this.CounterList.GameOverRadioName = "Miller_DeadPaz"			-- ゲームオーバー音声を登録
		GZCommon.PlayCameraAnimationOnChicoPazDead("Paz")
		TppSequence.ChangeSequence( "Seq_Mission_Failed" )				-- ミッション失敗シーケンスへ
		-- ミッション失敗テロップ
		hudCommonData:CallFailedTelop( "gameover_reason_target_died" )

	--ミッション圏外
	elseif( message == "MissionAreaOut" )  then
		SetGameOverMissionFailed()										-- MissionFailed
		GZCommon.OutsideAreaCamera()									-- デモカメラ
		this.CounterList.GameOverRadioName = "Miller_OutofMissionArea"	-- ゲームオーバー音声を登録
		TppSequence.ChangeSequence( "Seq_Mission_Failed" )				-- ミッション失敗シーケンスへ
		-- ミッション失敗テロップ
		hudCommonData:CallFailedTelop( "gameover_reason_mission_outside" )

	--ＰＣ死亡
	elseif( message == "PlayerDead" )	then
		SetGameOverTimeParadox()										-- TimeParadox
		this.CounterList.GameOverRadioName = "Miller_DeadPlayer"		-- ゲームオーバー音声を登録
		TppSequence.ChangeSequence( "Seq_Mission_Failed" )	-- ミッション失敗シーケンスへ
	-- ＰＣ落下死亡
	elseif( message == "PlayerFallDead" )	then
		SetGameOverTimeParadox()										-- TimeParadox
		this.CounterList.GameOverRadioName = "Miller_DeadPlayer"		-- ゲームオーバー音声を登録
		this.CounterList.GameOverFadeTime = GZCommon.FadeOutTime_PlayerFallDead		-- 落下死亡時はフェード開始時間を変更
		TppSequence.ChangeSequence( "Seq_Mission_Failed" )	-- ミッション失敗シーケンスへ
	--チコパスを乗せずにヘリに乗る
	elseif( message == "PlayerOnHeli" )	then
		SetGameOverMissionFailed()										-- MissionFailed
		this.CounterList.GameOverRadioName = "Miller_OnlyPcOnHeli"		-- ゲームオーバー音声を登録
		TppSequence.ChangeSequence( "Seq_Mission_Failed" )	-- ミッション失敗シーケンスへ
		-- ミッション失敗テロップ
		hudCommonData:CallFailedTelop( "gameover_reason_mission_abort" )
	end
end
------------------------------------------------------------------------------------------------------------------------------------
--　ミッション成功判定
-----------------------------------------------------------------------------------------------------------------------------------
this.commonMissionClear = function( manager, messageId, message )

	-- ヘリに乗って離脱した
	if( message == "RideHeli_Clear" )  then
		-- リザルト画面へ
		TppSequence.ChangeSequence( "Seq_Mission_Telop" )
	else
	end
end
------------------------------------------------------------------------------------------------------------------------------------
--　ミッション後片付け前処理
-----------------------------------------------------------------------------------------------------------------------------------
this.Pre_commonMissionCleanUp = function()

	--全カセットテープの持ってない扱いをやめる
	local uiCommonData = UiCommonDataManager.GetInstance()
	uiCommonData:ShowAllCassetteTapes()
	--チコ3再生中に無線再生できるようにする
	TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( false )
	-- ミッション後片付けへ
	this.commonMissionCleanUp()
end

------------------------------------------------------------------------------------------------------------------------------------
--　ミッション後片付け
-----------------------------------------------------------------------------------------------------------------------------------
this.commonMissionCleanUp = function()

	GzRadioSaveData.ResetSaveRadioId()
	GzRadioSaveData.ResetSaveEspionageId()
	local radioManager = RadioDaemon:GetInstance()
	radioManager:DisableAllFlagIsMarkAsRead()
	radioManager:ResetRadioGroupAndGroupSetAlreadyReadFlag()
	TppRadioConditionManagerAccessor.Unregister( "Tutorial" )
	TppRadioConditionManagerAccessor.Unregister( "Basic" )

	-- ミッション共通後片付け
	GZCommon.MissionCleanup()
	-- ミッション固有の後片付け処理があればここに書く
end
----------------------------------------------------------------------------------------------------------------------------
--シーケンス内汎用共通処理
----------------------------------------------------------------------------------------------------------------------------
--All_Seq
	--ミッション圏外
	local All_Seq_MissionAreaOut = function()
		if( TppMission.GetFlag( "isPlayerOnHeli" ) == true ) then
			--プレイヤーがヘリに乗っていたら圏外扱いしない
		else
			TppMission.OnLeaveInnerArea( function() TppRadio.Play( "Miller_MissionAreaOut" ) end )
			TppMission.OnLeaveOuterArea( function() TppMission.ChangeState( "failed", "MissionAreaOut" ) end )	--ミッション失敗
		end
	end
--Seq_RescueHostages
--Seq_NextRescuePaz
	--海岸にRVマーカーを付け、ミラー無線
	local Seq_NextRescuePaz_NoChicoTapeStartExec = function()
--		TppMarker.Enable( "20010_marker_RV" , 0 , moving , all , 0 )
		--ルート無効
		TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide01b" )
		TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide01c" )
		TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide01d" )
		TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide02b" )
		TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide02c" )
		TppEnemy.DisableRoute( this.cpID , "GoToKillSpHostage" )
		TppEnemy.DisableRoute( this.cpID , "S_Driver03b" )
		TppEnemy.DisableRoute( this.cpID , "S_Boilar03d" )
		TppEnemy.DisableRoute( this.cpID , "S_Boilar04d" )
		TppEnemy.DisableRoute( this.cpID , "S_Boilar03e" )
		TppEnemy.DisableRoute( this.cpID , "S_Boilar04e" )
	end
	--チコのテープを入手している状態でのシーケンス（リ）スタート
	local Seq_NextRescuePaz_GetChicoTapeStartExec = function()
		--ルート無効
--		TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide01b" )
--		TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide02b" )
		TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide01c" )
		TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide01d" )
		TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide02c" )
		TppEnemy.DisableRoute( this.cpID , "GoToKillSpHostage" )
		TppEnemy.DisableRoute( this.cpID , "S_Driver03b" )
	end
----------------------------------------------------------------------------------------------------------------------------
-- ゲームシーケンス
----------------------------------------------------------------------------------------------------------------------------
--ゲーム開始～１人目に会うまで
-----------------------------------------------------------------------------------------------------------------
this.Seq_RescueHostages = {

	Messages = {
		Character = {
			myMessages.Character[1],
			myMessages.Character[2],
			myMessages.Character[3],
			{ data = "gntn_cp", message = "EndGroupVehicleRouteMove", localFunc = "Seq10_VehicleFailed" },
			{ data = "gntn_cp", message = "VehicleMessageRoutePoint", localFunc = "Seq10_VehicleMessageRoutePoint" },
			{ data = "gntn_cp", message = "ConversationEnd", localFunc = "local_Seq10_ConversationEnd" },	--会話終了判定
			{ data = "Seq10_01",	message = "MessageRoutePoint",	localFunc = "Seq10_01_NodeAction" },	--ノードアクション
			{ data = "Seq10_02",	message = "MessageRoutePoint",	localFunc = "Seq10_02_NodeAction" },	--ノードアクション
			{ data = "Seq10_03",	message = "MessageRoutePoint",	localFunc = "Seq10_03_NodeAction" },	--ノードアクション
			{ data = "Seq10_06",	message = "MessageRoutePoint",	localFunc = "Seq10_06_NodeAction" },	--ノードアクション
			{ data = "Seq10_07",	message = "MessageRoutePoint",	localFunc = "Seq10_07_NodeAction" },	--ノードアクション
			{ data = "ComEne01",	message = "MessageRoutePoint",	localFunc = "ComEne01_NodeAction" },	--ノードアクション
			{ data = "ComEne03",	message = "MessageRoutePoint",	localFunc = "ComEne03_NodeAction" },	--ノードアクション
			{ data = "ComEne05",	message = "MessageRoutePoint",	localFunc = "ComEne05_NodeAction" },	--ノードアクション
			{ data = "ComEne06",	message = "MessageRoutePoint",	localFunc = "ComEne06_NodeAction" },	--ノードアクション
			{ data = "ComEne08",	message = "MessageRoutePoint",	localFunc = "ComEne08_NodeAction" },	--ノードアクション
			{ data = "ComEne09",	message = "MessageRoutePoint",	localFunc = "ComEne09_NodeAction" },	--ノードアクション
			{ data = "ComEne13",	message = "MessageRoutePoint",	localFunc = "ComEne13_NodeAction" },	--ノードアクション
			{ data = "ComEne14",	message = "MessageRoutePoint",	localFunc = "ComEne14_NodeAction" },	--ノードアクション
			{ data = "ComEne18",	message = "MessageRoutePoint",	localFunc = "ComEne18_NodeAction" },	--ノードアクション
			{ data = "ComEne19",	message = "MessageRoutePoint",	localFunc = "ComEne19_NodeAction" },	--ノードアクション
			{ data = "ComEne21",	message = "MessageRoutePoint",	localFunc = "ComEne21_NodeAction" },	--ノードアクション
			{ data = "ComEne25",	message = "MessageRoutePoint",	localFunc = "ComEne25_NodeAction" },	--管理棟配電敵兵ノードアクション	--管理棟扉登場敵兵ノードアクション
			{ data = "ComEne29",	message = "MessageRoutePoint",	localFunc = "ComEne29_NodeAction" },	--管理棟キャットウオーク敵兵ノードアクション
			{ data = "Player", message = "TryPicking", localFunc = "Seq_RescueDemo_OnlyOnce"  },
		},
		Trap = {
			myMessages.Trap[1],
			myMessages.Trap[2],
			myMessages.Trap[3],
--			myMessages.Trap[5],
			myMessages.Trap[6],
			myMessages.Trap[7],
			{ data = "Radio_MillerHistory2", message = "Exit", commonFunc = function() TppMission.SetFlag( "isAsylumRadioArea", false ) end },
			{ data = "Talk_Helipad01", message = "Enter", localFunc = "Talk_Helipad01" },
			myMessages.Trap[8],
			myMessages.Trap[10],
			--　Character
			-- Radio trigger
			{ data = "Radio_ChangePostureAdvice", message = "Enter", localFunc = "Radio_ChangePostureAdvice" },
			{ data = "Radio_ChangePostureReAdvice", message = "Enter", commonFunc = function() TppRadio.DelayPlayEnqueue( "Miller_ChangePostureAdvice", "short" ) end },
			{ data = "Radio_MoveAsylumAnounce", message = "Enter", localFunc = "Radio_MoveAsylum" },
			{ data = "Radio_StepON", message = "Enter", commonFunc = function() TppRadio.Play( "Miller_StepOnAdvice" ) end },
			{ data = "Radio_SpHostageDiscovery", message = "Enter", localFunc = "Radio_SpHostageDiscovery" },
			{ data = "Radio_NoKillGunAdvice", message = "Enter", localFunc = "Radio_TranquilizerGunAdvice" },
--			{ data = "Radio_DiscoveryPaz", message = "Enter", commonFunc = function() e20010_require_01.Radio_DiscoveryPaz() end },
		--	{ data = "Radio_DramaChico", message = "Enter", commonFunc = function() e20010_require_01.Radio_DramaChico() end },
			{ data = "Radio_CliffAttention", message = "Enter", commonFunc = function() TppRadio.Play( "Miller_CliffAttention" ) end },
			{ data = "Radio_Rain", message = "Enter", commonFunc = function() e20010_require_01.OnVehicleCheckRadioPlayEnqueue("Miller_Rain", "mid" ) end },
--			{ data = "Radio_DramaPaz", message = "Enter", commonFunc = function() e20010_require_01.OnVehicleCheckRadioPlayEnqueue("Miller_DramaPaz1", "mid") end },
			{ data = "Radio_DramaPaz", message = "Enter", commonFunc = function() e20010_require_01.Radio_DramaPaz() end },
			{ data = "Radio_DramaPaz", message = "Exit", commonFunc = function() TppMission.SetFlag( "isDramaPazArea", false ) end },
			{ data = "Radio_CallAdvice", message = "Exit", commonFunc = function() TppRadio.DelayPlayEnqueue( "Miller_CallAdvice", "short" ) end },
			{ data = "Radio_PaztakeRoute_HeliPort", message = "Enter", commonFunc = function() e20010_require_01.Radio_helipad() end },
			{ data = "Radio_InOldAsylum", message = "Enter", commonFunc = function() e20010_require_01.OptionalRadio_InOldAsylum() end },								--旧収容所の近くに入った
			{ data = "Radio_InOldAsylum", message = "Exit", commonFunc = function() e20010_require_01.OptionalRadio_OutOldAsylum("Optional_GameStartToRescue") end },	--旧収容所から離れた
			{ data = "Radio_StartCliff", message = "Enter", commonFunc = function() e20010_require_01.Radio_StartCliffTimer() end },		--スタートの崖付近に入った
			{ data = "Radio_StartCliff", message = "Exit", commonFunc = function() GkEventTimerManager.Stop( "Timer_StartCliff" ) end },	--スタートの崖付近から離れた
			{ data = "Radio_InCenterCoverAdvice", message = "Enter", localFunc = "Radio_RescuePazTimerStop" },								--中央管制塔に入った
			-- Demo trigger
			{ data = "Demo_EncounterChico", message = "Enter", commonFunc = function() Demo_eneChecker("chico") end },
			{ data = "Demo_EncounterPaz", message = "Enter", commonFunc = function() Demo_eneChecker("paz") end },
		},
		Timer = {
			{ data = "Timer_StartCliff", message = "OnEnd", commonFunc = function() e20010_require_01.Radio_StartCliff() end },
		},
		Terminal = {
			{ message = "MbDvcActWatchPhoto", commonFunc = function() e20010_require_01.Mb_WatchPhoto() end },
		},
		Radio = {
			{ data = "intel_e0010_esrg0020", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0030", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0040", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
	--		{ data = "intel_e0010_esrg0070", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0090", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
	--		{ data = "intel_e0010_esrg0100", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0110", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0120", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0190", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0380", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0440", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0440_1", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0450", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0450_1", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0450_2", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "intel_e0010_esrg0490", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Paz", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Chico", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntn_area01_antiAirGun_000", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntn_area01_antiAirGun_001", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntn_area01_antiAirGun_002", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntn_area01_antiAirGun_003", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "WoodTurret01", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "WoodTurret02", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "WoodTurret03", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "WoodTurret04", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "WoodTurret05", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
	--		{ data = "Tactical_Vehicle_WEST_001", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Tactical_Vehicle_WEST_002", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Tactical_Vehicle_WEST_003", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Tactical_Vehicle_WEST_004", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Tactical_Vehicle_WEST_005", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Cargo_Truck_WEST_002", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Cargo_Truck_WEST_003", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Cargo_Truck_WEST_004", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Armored_Vehicle_WEST_001", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Armored_Vehicle_WEST_002", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "Armored_Vehicle_WEST_003", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
	--		{ data = "WatchDog_e20010_0000", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
	--		{ data = "WatchDog_e20010_0004", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "e20010_drum0025", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "e20010_drum0027", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "e20010_drum0040", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "e20010_drum0042", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0002", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0005", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0011", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0012", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0015", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0019", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0020", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0021", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0022", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0023", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0024", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0025", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0027", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0028", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0029", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0030", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0031", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0035", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0037", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0038", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0039", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0040", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0041", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0042", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0043", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0044", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0045", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0046", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0047", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0048", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0065", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0066", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0068", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0069", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0070", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0071", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0072", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntnCom_drum0101", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "SL_WoodTurret01", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "SL_WoodTurret02", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "SL_WoodTurret03", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "SL_WoodTurret04", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "SL_WoodTurret05", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntn_area01_searchLight_000", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntn_area01_searchLight_001", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntn_area01_searchLight_002", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntn_area01_searchLight_003", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntn_area01_searchLight_004", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntn_area01_searchLight_005", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
			{ data = "gntn_area01_searchLight_006", message = "EspionageRadioCandidate" , commonFunc = function() TppRadio.PlayEnqueue( "Miller_EspionageRadioAdvice" ) end },
		},
		RadioCondition = {
			myMessages.RadioCondition[1],	--CQCチュートリアル
			myMessages.RadioCondition[2],	--エルード無線
			myMessages.RadioCondition[3],	--ホフク転がり
		},
		Marker = {
			{ message = "ChangeToEnable",	commonFunc = function() this.commonMarkerEnable() end },	-- マーカーが付いた
		},
	},

	OnEnter = function( manager )
		--雨さえぎりOFF
		WoodTurret_RainFilter_OFF()
		-- デフォルトランディングゾーン設定
		TppSupportHelicopterService.SetDefaultRendezvousPointMarker("no_lz")
		--ミッション開始テロップタイマースタート
		MissionStartTelopTimerStart()		-- MissionLoadを通過していない場合は、Messageが来ないのはOK
		--先チコ？
		TppMission.SetFlag( "isFirstEncount_Chico", false )
		--チコパス扉設定
		ChicoDoor_ON_Close()
		PazDoor_ON_Close()
		--中間目標設定
		commonUiMissionSubGoalNo(1)
		--BGM設定
		TppMusicManager.ClearParameter()
		TppMusicManager.SetSwitch{
			groupName = "bgm_phase_ct_level",
			stateName = "bgm_phase_ct_level_01",
		}
		--写真設定
		EnablePhoto()
		--トラップEnable/Disable
		Seq10Trap_Enable()
		Seq10_20Trap_Enable()
		Seq20Trap_Disable()
		Seq30Trap_Disable()
		Seq40Trap_Disable()
		--脱走捕虜のステータス変更
		TppHostageUtility.SetHostageStatusInCp( "gntn_cp", "SpHostage", "HOSTAGE_STATUS_LOST" )
		-- パスのモーションをつながれにする
		ChengeChicoPazIdleMotion()
		--キャラEnable/Disable
		Seq10Enemy_Enable()
		Seq20Enemy_Disable()
		Seq30Enemy_Disable()
		Seq40Enemy_Disable()
		--車両Disable
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_003" }
		TppData.Disable( "Tactical_Vehicle_WEST_003" )
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_004" }
		TppData.Disable( "Tactical_Vehicle_WEST_004" )
		TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_005" }
		TppData.Disable( "Tactical_Vehicle_WEST_005" )
		TppMarkerSystem.DisableMarker{ markerId = "Armored_Vehicle_WEST_002" }
		TppData.Disable( "Armored_Vehicle_WEST_002" )
		TppMarkerSystem.DisableMarker{ markerId = "Armored_Vehicle_WEST_003" }
		TppData.Disable( "Armored_Vehicle_WEST_003" )
		TppMarkerSystem.DisableMarker{ markerId = "Cargo_Truck_WEST_004" }
		TppData.Disable( "Cargo_Truck_WEST_004" )
		--車両Enable(4)
		TppData.Enable( "Armored_Vehicle_WEST_001" )
		TppData.Enable( "Cargo_Truck_WEST_002" )
		TppData.Enable( "Cargo_Truck_WEST_003" )
		TppData.Enable( "Tactical_Vehicle_WEST_002" )
		--ルート設定
		Seq_RescueHostages_RouteSet()
		--Seq_RescueHostages_RouteSetの詳細設定
		Setting_Seq_RescueHostages_RouteSet()
		--強制リアライズ設定
		Setting_RealizeEnable()
		--ミッション圏外処理
		All_Seq_MissionAreaOut()
		--マーカー処理
		Asylum_MarkerON()	--旧収容施設マーカー

		--有効無効の設定
	--	EspionageRadioController.SetEnable{ Tactical_Vehicle_WEST_001 = { "Tactical_Vehicle_WEST_001", "Tactical_Vehicle_WEST_002" }, enable = true }
	--	EspionageRadioController.SetEnable{ gntn_area01_antiAirGun_000 = { "gntn_area01_antiAirGun_000", "gntn_area01_antiAirGun_001", "gntn_area01_antiAirGun_003", "gntn_area01_antiAirGun_004" }, enable = true }
	--	EspionageRadioController.SetEnable{ Armored_Vehicle_WEST_001 = "Armored_Vehicle_WEST_001", enable = true }
		--ガードターゲット設定
		GuardTarget_Setting()

		--諜報無線セット
		SetIntelRadio()
		--任意無線セット
		SetOptionalRadio()

		--コンテニュー時ミラー強制無線
		local radioDaemon = RadioDaemon:GetInstance()
		if( TppMission.GetFlag( "isMissionStartRadio" ) == false ) then
			TppRadio.DelayPlay( "Miller_MissionStart", 2.8 )
		else
			TppRadio.DelayPlay( "Miller_MissionContinue", 2.8 )
		end
		TppMission.SetFlag( "isMissionStartRadio", true )
	end,
	--車輌連携判定
	Seq10_VehicleFailed = function()

		local VehicleGroupInfo			= TppData.GetArgument(2)
		local VehicleGroupInfoName		= VehicleGroupInfo.routeInfoName
		local VehicleGroupResult		= VehicleGroupInfo.result
		local VehicleGroupReason		= VehicleGroupInfo.reason

		if( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Seq10_01" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				--降車が無いので無し
			else	-- 失敗
				TppMission.SetFlag( "isSeq10_02_DriveEnd", 1 )
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_02" , false )
				TppEnemy.EnableRoute( this.cpID , "Seq10_02_VehicleFailed_Route" )
				TppEnemy.DisableRoute( this.cpID , "Seq10_02_RideOnVehicle" )
				TppEnemy.ChangeRoute( this.cpID , "Seq10_02","e20010_Seq10_SneakRouteSet","Seq10_02_VehicleFailed_Route", 0 )
				EastCampMoveTruck_Start()		--トラックルートチェンジ開始
				TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "EastCampMoveTruck_Start", false , false )
			end
		elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Seq10_02" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				--降車が無いので無し
			else	-- 失敗
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_01" , false )
				TppEnemy.EnableRoute( this.cpID , "Seq10_01_VehicleFailed_Route" )
				TppEnemy.DisableRoute( this.cpID , "S_GoToExWeaponTruck" )
				TppEnemy.ChangeRoute( this.cpID , "Seq10_01","e20010_Seq10_SneakRouteSet","Seq10_01_VehicleFailed_Route", 0 )
			end
		elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Seq10_03" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				--降車が無いので無し
			else	-- 失敗
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_03" , false )
				TppEnemy.EnableRoute( this.cpID , "Seq10_02_VehicleFailed_Route" )
				TppEnemy.DisableRoute( this.cpID , "S_Seq10_03_RideOnTruck" )
				TppEnemy.ChangeRoute( this.cpID , "Seq10_03","e20010_Seq10_SneakRouteSet","Seq10_02_VehicleFailed_Route", 0 )
			end
		end
	end,
	--車輌ルートアクション設定
	Seq10_VehicleMessageRoutePoint = function()

		local PlayerRaidVehicleId	= TppPlayerUtility.GetRidingVehicleCharacterId()	-- プレイヤーが現在乗車している乗り物のCharaIDを取得
		local vehicleGroupInfo		= TppData.GetArgument(2)							-- 車輌連携Infoデータ取得
		local vehicleInfoName		= vehicleGroupInfo.routeInfoName					-- RouteInfoデータ名
		local vehicleCharaID		= vehicleGroupInfo.vehicleCharacterId				-- 車両のキャラID
		local routeID				= vehicleGroupInfo.vehicleRouteId					-- 車両ルートのルートID
		local routeNodeIndex		= vehicleGroupInfo.passedNodeIndex					-- 到達したルートノードのインデックス
		local memberCharaIDs		= vehicleGroupInfo.memberCharactorIds				-- 乗車しているキャラID
		local result 				= vehicleGroupInfo.result							-- 結果（成功or失敗）
		local reason				= vehicleGroupInfo.reason							-- 結果の原因

		-- 秘密兵器輸送トラック
		if ( vehicleInfoName == "TppGroupVehicleRouteInfo_Seq10_02" ) then
			if ( routeID == GsRoute.GetRouteId( "Truck_onRaid_Seq10_01" )) and ( routeNodeIndex == 12 ) then
				AnounceLog_enemyDecrease()	--エリア外アナウンスログ
				TppEnemyUtility.SetEnableCharacterId( "Seq10_01" , false )
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_01" , false )
				-- 乗り換えしていない（秘密兵器輸送トラック）
				if ( vehicleCharaID == "Cargo_Truck_WEST_002" ) then
					-- ＰＣが秘密兵器輸送トラックに乗っている
					if( PlayerRaidVehicleId == "Cargo_Truck_WEST_002" ) then
						-- まずありえない状況
					-- ＰＣは秘密兵器輸送トラックに乗っていない＝通常処理
					else
						TppMarkerSystem.DisableMarker{ markerId = "Cargo_Truck_WEST_002" }
						TppData.Disable( "Cargo_Truck_WEST_002" )
					end
				-- 乗り換えした（東難民キャンプ通過トラックのまま）
				elseif ( vehicleCharaID == "Cargo_Truck_WEST_003" ) then
					-- ＰＣが東難民キャンプ通過トラックに乗っている
					if( PlayerRaidVehicleId == "Cargo_Truck_WEST_003" ) then
						-- まずありえない状況
					-- ＰＣは東難民キャンプ通過トラックに乗っていない＝通常処理
					else
						TppMarkerSystem.DisableMarker{ markerId = "Cargo_Truck_WEST_003" }
						TppData.Disable( "Cargo_Truck_WEST_003" )
					end
				-- 他の車両
				else
					-- このシーケンスで他にトラックは無いので、上記２パターン以外存在しない
				end
			end
		-- 東難民キャンプ通過トラック
		elseif ( vehicleInfoName == "TppGroupVehicleRouteInfo_Seq10_03" ) then
			if ( routeID == GsRoute.GetRouteId( "Truck_onRaid_Seq10_03" )) and ( routeNodeIndex == 18 ) then
				TppMission.SetFlag( "isSeq10_03_DriveEnd", 1 )
				AnounceLog_enemyDecrease()	--エリア外アナウンスログ
				TppEnemyUtility.SetEnableCharacterId( "Seq10_03" , false )
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_03" , false )
				-- 乗り換えしていない（東難民キャンプ通過トラックのまま）
				if ( vehicleCharaID == "Cargo_Truck_WEST_003" ) then
					-- ＰＣが東難民キャンプ通過トラックに乗っている
					if( PlayerRaidVehicleId == "Cargo_Truck_WEST_003" ) then
						-- まずありえない状況
					-- ＰＣは東難民キャンプ通過トラックに乗っていない＝通常処理
					else
						TppMarkerSystem.DisableMarker{ markerId = "Cargo_Truck_WEST_003" }
						TppData.Disable( "Cargo_Truck_WEST_003" )
					end
				-- 乗り換えした（秘密兵器輸送トラック）
				elseif ( vehicleCharaID == "Cargo_Truck_WEST_002" ) then
					-- ＰＣが秘密兵器輸送トラックに乗っている
					if( PlayerRaidVehicleId == "Cargo_Truck_WEST_002" ) then
						-- まずありえない状況
					-- ＰＣは秘密兵器輸送トラックに乗っていない＝通常処理
					else
						TppMarkerSystem.DisableMarker{ markerId = "Cargo_Truck_WEST_002" }
						TppData.Disable( "Cargo_Truck_WEST_002" )
					end
				-- 他の車両
				else
					-- このシーケンスで他にトラックは無いので、上記２パターン以外存在しない
				end
			end
		else
			-- 該当車輌無し
		end
	end,
	--会話終了判定
	local_Seq10_ConversationEnd = function()
		local label		= TppData.GetArgument(2)
		local judge		= TppData.GetArgument(4)
		if ( label == "CTE0010_0010") then
			TppEnemy.EnableRoute( this.cpID , "S_GoTo_EastCamp" ) 	--ルート有効
			TppEnemy.EnableRoute( this.cpID , "GoToWestCamp_TalkWeapon" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Pre_ExWeaponTalk_a" )	--ルート無効
			TppEnemy.DisableRoute( this.cpID , "S_Pre_ExWeaponTalk_b" )	--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne01","e20010_Seq10_SneakRouteSet","S_GoTo_EastCamp", 0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "ComEne03","e20010_Seq10_SneakRouteSet","GoToWestCamp_TalkWeapon", 0 )	--指定敵兵ルートチェンジ
		elseif ( label == "CTE0010_0260") then
			TppEnemy.EnableRoute( this.cpID , "S_GoToExWeaponTruck" ) 	--ルート有効
			TppEnemy.EnableRoute( this.cpID , "S_Sen_WestCamp_WestGate2" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "GoToWestCamp_TalkWeapon" )	--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "Seq10_01","e20010_Seq10_SneakRouteSet","S_GoToExWeaponTruck", 0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "ComEne03","e20010_Seq10_SneakRouteSet","S_Sen_WestCamp_WestGate2", 0 )	--指定敵兵ルートチェンジ
		elseif ( label == "CTE0010_0310") then

			local LightState	= TppGadgetManager.GetGadgetStatus( "gntn_center_SwitchLight" )

			if ( judge == true ) then
				if( TppMission.GetFlag( "isCTE0010_0310_NearArea" ) == true ) then
					local uiCommonData = UiCommonDataManager.GetInstance()
					--カセットテープ取得済なら
					if uiCommonData:IsHaveCassetteTape( "tp_chico_05" ) then
						TppRadio.Play( "Miller_MarkingExhaveTape" )
					else	--カセットテープ未取得なら
						local onRadioStart = function()
							Cassette_MarkerOn()
						end
						local onRadioEnd = function()
							AnounceLog_MapUpdate()
						end
						TppRadio.Play("Miller_MarkingExTape" , { onStart = onRadioStart, onEnd = onRadioEnd } )
					end
				else
				end
			else
			end
			TppEnemy.EnableRoute( this.cpID , "S_Mov_CenterHouse_a" ) 	--ルート有効
			TppEnemy.EnableRoute( this.cpID , "S_Mov_CenterHouse_b" ) 	--ルート有効
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_a" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Talk_ChicoTape" )	--ルート無効
			TppEnemy.DisableRoute( this.cpID , "S_Pre_ChikcoTapeTalk_c" )	--ルート無効
			TppEnemy.DisableRoute( this.cpID , "S_Pre_ChikcoTapeTalk_d" )	--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq10_SneakRouteSet","S_Sen_Boilar_a",0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "Seq10_06","e20010_Seq10_SneakRouteSet","S_Mov_CenterHouse_a",0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "Seq10_07","e20010_Seq10_SneakRouteSet","S_Mov_CenterHouse_b",0 )	--指定敵兵ルートチェンジ
			TppMission.SetFlag( "isTalkChicoTapeFinish", true )
			--ComEne31
			if ( LightState == 2 ) then			-- 停電
				TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF" ) 		--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Pre_ChikcoTapeTalk_b" )	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_b" )			--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq10_SneakRouteSet","ComEne31_SwitchOFF",0 )	--指定敵兵ルートチェンジ
			else								-- 停電以外
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_b" ) 			--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Pre_ChikcoTapeTalk_b" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq10_SneakRouteSet","S_Sen_Boilar_b",0 )	--指定敵兵ルートチェンジ
			end

		elseif ( label == "CTE0010_0130") then
			TppEnemy.EnableRoute( this.cpID , "S_GoTo_SeaSideEnter" ) 	--ルート有効
			TppEnemy.EnableRoute( this.cpID , "S_GoTo_EastCampNorthTower" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_RainTalk_ComEne05" ) 	--ルート無効
			TppEnemy.DisableRoute( this.cpID , "S_Pre_RainTalk_b" ) 	--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne05","e20010_Seq10_SneakRouteSet","S_GoTo_SeaSideEnter", 0 )
			TppEnemy.ChangeRoute( this.cpID , "ComEne06","e20010_Seq10_SneakRouteSet","S_GoTo_EastCampNorthTower", 0 )
		elseif ( label == "CTE0010_0350") then
			TppEnemy.EnableRoute( this.cpID , "S_GoToSearchEscapeHostage_a" ) 	--ルート有効
			TppEnemy.EnableRoute( this.cpID , "S_GoToSearchEscapeHostage_b" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Talk_EscapeHostage" )			--ルート無効
			TppEnemy.DisableRoute( this.cpID , "S_Pre_EscapeHostageTalk_b" )	--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq10_SneakRouteSet","S_GoToSearchEscapeHostage_a",0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "ComEne14","e20010_Seq10_SneakRouteSet","S_GoToSearchEscapeHostage_b",0 )	--指定敵兵ルートチェンジ
		end
	end,
	--銃チュートリアル敵兵ノードアクション
	ComEne08_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_GunTutorial_Route" )) then
			if( RoutePointNumber == 0 ) then										--0ノードを通過した時
				local radioDaemon = RadioDaemon:GetInstance()
				if( TppMission.GetFlag( "isGunTutorialArea" ) == true and radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0960") == false ) then			--麻酔銃チュートリエリアにいるか
					TppRadio.Play( "Miller_EnemyCopeOnlyVersion" )
				elseif( TppMission.GetFlag( "isGunTutorialArea" ) == true and TppMission.GetFlag( "isDoneCQC" ) == false ) then			--麻酔銃チュートリエリアにいるか
					TppRadio.Play( "Miller_EnemyCopeOnlyCQC" )
					TppMission.SetFlag( "isDoneCQC", true )
				else																--麻酔銃チュートリエリアにいない
				end
			elseif( RoutePointNumber == 11 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumBehind" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_GunTutorial_Route" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne08","e20010_Seq10_SneakRouteSet","S_Sen_AsylumBehind", 0 )	--指定敵兵ルートチェンジ
			end
		else
		end
	end,
	--秘密兵器運ぶ敵兵ノードアクション
	Seq10_01_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)

		if ( RouteName ==  GsRoute.GetRouteId( "Seq10_01_VehicleFailed_Route" )) then
			if( RoutePointNumber == 8 ) then
					AnounceLog_enemyDecrease()	--エリア外アナウンスログ
					TppEnemyUtility.SetEnableCharacterId( "Seq10_01" , false )
					TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_01" , false )
			else
			end
		else
		end
	end,
	--しょっぱなビークル敵兵ノードアクション
	Seq10_02_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		-- プレイヤーが現在乗車している乗り物のCharaIDを取得
		local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()

		if ( RouteName ==  GsRoute.GetRouteId( "Vehicle_onRaid_Seq10_02" )) then
			if( RoutePointNumber == 16 ) then
				if( VehicleId == "Tactical_Vehicle_WEST_002" ) then
					-- このシーケンスで車種ビークルは１台なので、"Seq10_02"が"Vehicle_onRaid_Seq10_02"ルートに乗って
					-- "RoutePointNumber == 16"に到達した時に、このビークルにＰＣが乗っている事は有り得ない
				else
					AnounceLog_enemyDecrease()	--エリア外アナウンスログ
					TppEnemyUtility.SetEnableCharacterId( "Seq10_02" , false )
					TppMarkerSystem.DisableMarker{ markerId = "Tactical_Vehicle_WEST_002" }
					TppData.Disable( "Tactical_Vehicle_WEST_002" )
					TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_02" , false )
					TppMission.SetFlag( "isSeq10_02_DriveEnd", 1 )
					EastCampMoveTruck_Start()		--トラックルートチェンジ開始
					TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "EastCampMoveTruck_Start", false , false )
				end
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "Seq10_02_VehicleFailed_Route" )) then
			if( RoutePointNumber == 5 ) then
				AnounceLog_enemyDecrease()	--エリア外アナウンスログ
				TppEnemyUtility.SetEnableCharacterId( "Seq10_02" , false )
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_02" , false )
			else
			end
		else
		end
	end,
	--トラック敵兵ノードアクション
	Seq10_03_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)

		if ( RouteName ==  GsRoute.GetRouteId( "Seq10_02_VehicleFailed_Route" )) then
			if( RoutePointNumber == 5 ) then
				AnounceLog_enemyDecrease()	--エリア外アナウンスログ
				TppEnemyUtility.SetEnableCharacterId( "Seq10_03" , false )
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq10_03" , false )
			else
			end
		else
		end
	end,
	--ボイラー室から出て行く敵兵
	Seq10_06_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Mov_CenterHouse_a" )) then
			if( RoutePointNumber == 29 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Mov_CenterHouse_a2" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Mov_CenterHouse_a" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq10_06","e20010_Seq10_SneakRouteSet","S_Mov_CenterHouse_a2", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ボイラー室から出て行く敵兵
	Seq10_07_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Mov_CenterHouse_b" )) then
			if( RoutePointNumber == 21 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Mov_CenterHouse_b2" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Mov_CenterHouse_b" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq10_07","e20010_Seq10_SneakRouteSet","S_Mov_CenterHouse_b2", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne01ノードアクション
	ComEne01_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_GoTo_EastCamp" )) then
			if( RoutePointNumber == 21 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_EastCamp_SouthLeftGate" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_GoTo_EastCamp" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne01","e20010_Seq10_SneakRouteSet","S_Sen_EastCamp_SouthLeftGate", 0 )	--指定敵兵ルートチェンジ
			else
			end
		end
	end,
	--ComEne03ノードアクション
	ComEne03_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "GoToWestCamp_TalkWeapon" )) then
			if( RoutePointNumber == 19 ) then
				TppEnemy.EnableRoute( this.cpID , "S_GoToExWeaponTruck" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "S_Sen_WestCamp_WestGate2" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "GoToWestCamp_TalkWeapon" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq10_01","e20010_Seq10_SneakRouteSet","S_GoToExWeaponTruck", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne03","e20010_Seq10_SneakRouteSet","S_Sen_WestCamp_WestGate2", 0 )	--指定敵兵ルートチェンジ
			else
			end
		end
	end,
	--ComEne05ノードアクション
	ComEne05_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)

		if ( RouteName ==  GsRoute.GetRouteId( "S_GoTo_SeaSideEnter" )) then
			if( RoutePointNumber == 16 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_SeaSideEnter" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_GoTo_SeaSideEnter" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne05","e20010_Seq10_SneakRouteSet","S_Sen_SeaSideEnter", 0 )
			else
			end
		end
	end,
	--ComEne06ノードアクション
	ComEne06_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_GoTo_EastCampNorthTower" )) then
			if( RoutePointNumber == 22 ) then
				TppEnemy.EnableRoute( this.cpID , "S_SL_EastCamp_North" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_GoTo_EastCampNorthTower" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne06","e20010_Seq10_SneakRouteSet","S_SL_EastCamp_North", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne09ノードアクション
	ComEne09_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Pat_AsylumInside_Ver01" )) then
			if( RoutePointNumber == 4 ) then
				TppEnemy.DisableRoute( this.cpID , "S_Pat_AsylumInside_Ver01" ) 	--ルート無効
				if ( TppMission.GetFlag( "isAsyInsideRouteChange_01" ) == true ) then
					TppEnemy.EnableRoute( this.cpID , "S_Pat_AsylumInside_Ver03" ) 	--ルート有効
					TppEnemy.ChangeRoute( this.cpID , "ComEne09","e20010_Seq10_SneakRouteSet","S_Pat_AsylumInside_Ver03", 0 )	--指定敵兵ルートチェンジ
				else
				end
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "S_Pat_AsylumInside_Ver03" )) then
			if( RoutePointNumber == 7 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Seeing_Sea" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Pat_AsylumInside_Ver03" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne09","e20010_Seq10_SneakRouteSet","S_Seeing_Sea", 0 )
			else
			end
		end
	end,
	--ComEne13ノードアクション
	ComEne13_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_GoToSearchEscapeHostage_a" )) then
			if( RoutePointNumber == 11	 ) then
				TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage02" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage01" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_GoToSearchEscapeHostage_a" ) 	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_GoToSearchEscapeHostage_b" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne14","e20010_Seq10_SneakRouteSet","S_SearchSpHostage02", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq10_SneakRouteSet","S_SearchSpHostage01", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne14ノードアクション
	ComEne14_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_GoToSearchEscapeHostage_b" )) then
			if( RoutePointNumber == 12 ) then
				TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage01" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage02" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_GoToSearchEscapeHostage_a" ) 	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_GoToSearchEscapeHostage_b" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq10_SneakRouteSet","S_SearchSpHostage01", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne14","e20010_Seq10_SneakRouteSet","S_SearchSpHostage02", 0 )	--指定敵兵ルートチェンジ	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne18ノードアクション
	ComEne18_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_HeliPort_2manSeparate02" )) then
			if( RoutePointNumber == 12 ) then
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate01" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq10_SneakRouteSet","S_HeliPort_2mancell_back", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate02" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq10_SneakRouteSet","S_HeliPort_2mancell_back", 0 )	--指定敵兵ルートチェンジ
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "S_HeliPort_2mancell_back" )) then
			if( RoutePointNumber == 6 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBehind_a" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBehind_b" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq10_SneakRouteSet","S_Sen_HeliPortBehind_a", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq10_SneakRouteSet","S_Sen_HeliPortBehind_b", 0 )	--指定敵兵ルートチェンジ	--指定敵兵ルートチェンジ
			else
			end
		end
	end,
	--ComEne19ノードアクション
	ComEne19_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Sen_HeliPortBehind_b" )) then
			if( RoutePointNumber == 4 ) then
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortBehind_b" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq10_SneakRouteSet","S_HeliPort_2mancell_go", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortBehind_a" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq10_SneakRouteSet","S_HeliPort_2mancell_go", 0 )	--指定敵兵ルートチェンジ
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "S_HeliPort_2mancell_go" )) then
			if( RoutePointNumber == 9 ) then
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2manSeparate01" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2manSeparate02" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq10_SneakRouteSet","S_HeliPort_2manSeparate02", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq10_SneakRouteSet","S_HeliPort_2manSeparate01", 0 )	--指定敵兵ルートチェンジ
			else
			end
		end
	end,
	--ComEne21ノードアクション
	ComEne21_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "ComEne21_TalkRoute" )) then
			if( RoutePointNumber == 4 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortCenter_a" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "ComEne21_TalkRoute" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne21","e20010_Seq10_SneakRouteSet","S_Sen_HeliPortCenter_a", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--管理棟配電敵兵ノードアクション
	ComEne25_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Mov_Center_d" )) then
			if( RoutePointNumber == 5 ) then										--ノードを通過した時
				if( TppMission.GetFlag( "isCenterBackEnter" ) == true ) then
					TppEnemy.EnableRoute( this.cpID , "S_Ret_Center_d" ) 	--ルート有効
					TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_d" ) 	--ルート無効
					TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq10_SneakRouteSet","S_Ret_Center_d", 0 )	--指定敵兵ルートチェンジ
				else
				end
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "S_Ret_Center_d" )) then
			if( RoutePointNumber == 8 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Ret_Center_d" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq10_SneakRouteSet","S_Sen_Center_d", 0 )	--指定敵兵ルートチェンジ
			else
			end
		end
	end,
	--管理棟キャットウオーク敵兵ノードアクション
	ComEne29_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Mov_Center_2Fto1F" )) then
			if( RoutePointNumber == 15 ) then										--ノードを通過した時
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_e" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_2Fto1F" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq10_SneakRouteSet","S_Sen_Center_e", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ヘリポート巨大ゲート前会話
	Talk_Helipad01 = function()
		TppEnemy.EnableRoute( this.cpID , "ComEne21_TalkRoute" ) 	--ルート有効
		TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortCenter_a" ) 	--ルート無効
		TppEnemy.ChangeRoute( this.cpID , "ComEne21","e20010_Seq10_SneakRouteSet","ComEne21_TalkRoute", 0 )	--指定敵兵ルートチェンジ
	end,
	--姿勢変更促し
	Radio_ChangePostureAdvice = function()
		local radioDaemon = RadioDaemon:GetInstance()
		if ( radioDaemon:IsPlayingRadio() == false ) then
			TppRadio.DelayPlay( "Miller_ChangePostureAdvice", "short" )
		end
	end,
	--処刑捕虜発見
	Radio_SpHostageDiscovery = function()
		if( TppMission.GetFlag( "isSpHostage_Dead" ) == false ) then
			if( TppMission.GetFlag( "isEscapeHostage" ) == false ) then
				TppMission.SetFlag( "isSpHostageEncount", true )
				TppRadio.Play( "Miller_DiscoverySpHostage" )
			end
		else
		end
	end,
	--麻酔銃促し
	Radio_TranquilizerGunAdvice = function()
		local lifeStatus1 = TppEnemyUtility.GetLifeStatusByRoute( "gntn_cp", "S_SL_StartCliff" )
		local radioPlay = false

		if(lifeStatus1 == "Normal" and TppMission.GetFlag( "isDoCarryAdvice" ) == false )then
				-- 通常状態
	--	Fox.Log("==================== normal ====================")
			radioPlay = true
		end

		if radioPlay == true then
			--スタート崖のやぐらの上
			local checkPos = Vector3(-151.5,35.0,253.8)
			local size = Vector3(3.0,3.0,3.0)--トラック前での敵兵チェックサイズ

			local npcIds = TppNpcUtility.GetNpcByBoxShape( checkPos, size )

			local eneNum = 0
			if npcIds and #npcIds.array > 0 then
				for i,id in ipairs(npcIds.array) do
					local type = TppNpcUtility.GetNpcType( id )
					if type == "Enemy" then
						-- 敵兵だった
						TppRadio.Play( "Miller_TranquilizerGunAdvice" )
					end
				end
			end
			Fox.Log( eneNum )
		end
	end,
	--基地内潜入無線
	Radio_MoveAsylum = function()
		if( TppMission.GetFlag( "isDoCarryAdvice" ) == false ) then
			local radioDaemon = RadioDaemon:GetInstance()

			if ( radioDaemon:IsPlayingRadioWithGroupName("e0010_rtrg0009") == true ) then
				TppRadio.PlayEnqueue( "Miller_DeviceAdvice" )
			else
				local phase = TppEnemy.GetPhase( this.cpID )
				if ( phase == "alert" or phase == "evasion" ) then
				else
					TppRadio.DelayPlay( "Miller_MovingAdvice", "short" )
				end
			end
			TppMission.SetFlag( "isDoCarryAdvice", true )	-- 担ぎアドバイス無線を有効にする
			TppRadio.RegisterIntelRadio( "intel_e0010_esrg0090", "e0010_esrg0091", true )
			TppRadio.RegisterIntelRadio( "intel_e0010_esrg0120", "e0010_esrg0121", true )
			RegisterRadioCondition()
		end
	end,

	-- チコ・パスに会うデモチェック
	Seq_RescueDemo_OnlyOnce = function()
		--フェイズチェック
		--敵兵チェック

			-- どの扉かのチェック
			if( (TppData.GetArgument( 1 ) == "AsyPickingDoor24" ) ) then
				TppSequence.ChangeSequence( "Seq_RescueChicoDemo01" )

			elseif( (TppData.GetArgument( 1 ) == "Paz_PickingDoor00" ) )then

				TppSequence.ChangeSequence( "Seq_RescuePazDemo" )

			end
	end,
	--中央管制塔に入ったらタイマーを止める
	Radio_RescuePazTimerStop = function()
		e20010_require_01.Radio_RescuePaz1TimerStop()
		e20010_require_01.Radio_RescuePaz2TimerStop()
	end,
}
-----------------------------------------------------------------------------------------------------------------
--１人目チコで、パスに会うまで
-----------------------------------------------------------------------------------------------------------------
this.Seq_NextRescuePaz = {

	Messages = {
		Character = {
			myMessages.Character[1],
			myMessages.Character[2],
			{ data = "gntn_cp", message = "ConversationEnd", localFunc = "local_ConversationEnd" },		--会話終了判定
			{ data = "gntn_cp", message = "EndGroupVehicleRouteMove", localFunc = "EnterCenterTruck" },
			{ data = "Chico", message = "MessageHostageCarriedStart", localFunc = "ChicoCarriedStart" },
			{ data = "Chico", message = "MessageHostageCarriedEnd", localFunc = "Seq_QuestionChicoDemo_OnlyOnce" },
			{ data = "Chico", message = "HostageLaidOnVehicle", commonFunc = function() e20010_require_01.Common_HostageOnVehicleInDangerArea() end },
			{ data = "ComEne01",	message = "MessageRoutePoint",	localFunc = "ComEne01_NodeAction" },
			{ data = "ComEne11",	message = "MessageRoutePoint",	localFunc = "ComEne11_NodeAction" },
			{ data = "ComEne13",	message = "MessageRoutePoint",	localFunc = "ComEne13_NodeAction" },
			{ data = "ComEne14",	message = "MessageRoutePoint",	localFunc = "ComEne14_NodeAction" },
			{ data = "ComEne17",	message = "MessageRoutePoint", commonFunc = function() e20010_require_01.ComeEne17_NodeAction() end },
			{ data = "ComEne18",	message = "MessageRoutePoint",	localFunc = "ComEne18_NodeAction" },
			{ data = "ComEne19",	message = "MessageRoutePoint",	localFunc = "ComEne19_NodeAction" },
			{ data = "ComEne25",	message = "MessageRoutePoint",	localFunc = "ComEne25_NodeAction" },	--管理棟配電敵兵ノードアクション
			{ data = "ComEne29",	message = "MessageRoutePoint",	localFunc = "ComEne29_NodeAction" },
			{ data = "ComEne31",	message = "MessageRoutePoint",	localFunc = "ComEne31_NodeAction" },	--管理棟キャットウオーク敵兵ノードアクション
			{ data = "Seq20_01",	message = "MessageRoutePoint",	localFunc = "Seq20_01_NodeAction" },
			{ data = "Seq20_02",	message = "EnemyArrivedAtRouteNode", localFunc = "Seq20_02_ArrivedAtRoutePoint" },
			{ data = "Seq20_03",	message = "MessageRoutePoint",	localFunc = "Seq20_03_NodeAction" },
			{ data = "Seq20_04",	message = "MessageRoutePoint",	localFunc = "Seq20_04_NodeAction" },
			{ data = "Seq20_05",	message = "MessageRoutePoint",	localFunc = "Seq20_05_NodeAction" },
			{ data = "SpHostage",	message = "Dead",	localFunc = "SpHostageIsDead" },
			{ data = "SpHostage",	message = "MessageHostageCarriedStart", localFunc = "SpHostage_EnemyLost" },
			{ data = "Player", message = "TryPicking", localFunc = "Seq_RescueDemo_OnlyOnce"  },
			-- 巨大ゲート
			{ data = "gntn_cp",		message = "VehicleMessageRoutePoint", commonFunc = function() GZCommon.Common_CenterBigGateVehicle( ) end  },
			{ data = "gntn_cp",		message = "EndRadio", commonFunc = function() GZCommon.Common_CenterBigGateVehicleEndCPRadio( ) end  },
		},
		Enemy = {
			{ message = "EnemyInterrogation", commonFunc = function() e20010_require_01.Seq20_Interrogation() end },
		},
		Trap = {
			myMessages.Trap[1],
			myMessages.Trap[2],
			myMessages.Trap[3],
--			myMessages.Trap[5],
--			myMessages.Trap[7],
			-- Radio trigger
			{ data = "Radio_ChicoRV", message = "Exit", localFunc = "Radio_ChicoRV" },
			{ data = "Radio_NearRV", message = "Enter", localFunc = "Radio_NearRV" },
			{ data = "Radio_ArriveRV", message = "Enter", localFunc = "Radio_ArriveRV" },
			{ data = "Radio_PaztakeRoute_Camp", message = "Enter", localFunc = "Radio_PazTakeRoute_Camp" },
			{ data = "Radio_PaztakeRoute_HeliPort", message = "Enter", localFunc = "Radio_PazTakeRoute_HeliPort" },
			{ data = "Radio_PaztakeRoute_Gate", message = "Enter", localFunc = "Radio_PazTakeRoute_Gate" },
			{ data = "Radio_PaztakeRoute_Boilar", message = "Enter", localFunc = "Radio_PazTakeRoute_Boilar" },
			{ data = "Radio_PaztakeRoute_Flag", message = "Enter", localFunc = "Radio_PazTakeRoute_Flag" },
			{ data = "Radio_CliffAttention", message = "Enter", localFunc = "Radio_CliffAttention" },
			{ data = "Radio_Rain", message = "Enter", commonFunc = function() TppRadio.DelayPlayEnqueue("Miller_Rain", "mid" ) end },
			{ data = "Radio_DramaPaz", message = "Enter", commonFunc = function() e20010_require_01.OnVehicleCheckRadioPlayEnqueue( "Miller_DramaPaz1", "long" ) end },
			{ data = "Radio_DiscoveryPaz", message = "Enter", commonFunc = function() e20010_require_01.NextRescuePaz_DiscoveryPaz() end },	--パスのいる檻の前に着いた
			{ data = "ComEne17_RouteChange", message = "Enter", commonFunc = function() e20010_require_01.ComEne17_RouteChange() end },
			{ data = "Talk_SearchSpHostage", message = "Enter", localFunc = "Talk_SearchSpHostage" },
			-- Demo trigger
			{ data = "Demo_EncounterPaz", message = "Enter", commonFunc = function() Demo_eneChecker("paz") end },
			--{ data = "Demo_EncounterPaz", message = "Enter", localFunc = "Seq_RescuePazDemo_OnlyOnce" },
			-- Monologue
			{ data = "ChicoMonologue", message = "Enter", localFunc = "Chico_Monologue" },
			{ data = "ChicoMonologue02", message = "Enter", localFunc = "Chico_Monologue02" },
			{ data = "ChicoMonologue03", message = "Enter", localFunc = "Chico_Monologue03" },
			{ data = "ChicoMonologue04", message = "Enter", localFunc = "Chico_Monologue04" },
		},
		Timer = {
			{ data = "Timer_InterrogationAdvice", message = "OnEnd", commonFunc = function() e20010_require_01.Radio_InterrogationAdvice() end },
		},
		UI = {
			{ message = "PlayWalkMan" , commonFunc = function() e20010_require_01.Common_PlayListenTape() end },		--テープを再生した
		},
		RadioCondition = {
			myMessages.RadioCondition[1],	--CQCチュートリアル
			myMessages.RadioCondition[2],	--エルード無線
		--	myMessages.RadioCondition[3],	--ホフク転がり
		},
		Subtitles = {
				--セリフ３：「管理棟地下の『ボイラー室』から、女の悲鳴が……」
				{ data="enqt1000_1m1310", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.Common_interrogation_B() end },
				{ data="e0010_rtrg1269", commonFunc = function() e20010_require_01.CallTapeReaction0() end },		--チコテープ3への相の手無線1つ目
				{ data="e0010_rtrg1270", commonFunc = function() e20010_require_01.CallTapeReaction1() end },		--チコテープ3への相の手無線1つ目
				{ data="e0010_rtrg1271", commonFunc = function() e20010_require_01.CallTapeReaction2() end },		--チコテープ3への相の手無線2つ目
				{ data="e0010_rtrg1272", commonFunc = function() e20010_require_01.CallTapeReaction3() end },		--チコテープ3への相の手無線3つ目
				{ data="e0010_rtrg1273", commonFunc = function() e20010_require_01.CallTapeReaction4() end },		--チコテープ3への相の手無線4つ目
				{ data="e0010_rtrg1274", commonFunc = function() e20010_require_01.CallTapeReaction5() end },		--チコテープ3への相の手無線5つ目
				{ data="e0010_rtrg1275", commonFunc = function() e20010_require_01.CallTapeReaction6() end },		--チコテープ3への相の手無線6つ目
		--		{ data="tapeEnd_chico03", commonFunc = function() e20010_require_01.CallTapeReaction7() end },		--チコテープ3のend
				{ data="tp_chico_00_03", message = "SubtitlesFinishedEventMessage", commonFunc = function() e20010_require_01.CallTapeReaction7() end },	--聞き終わった
		--		{ data="e0010_rtrg1276", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.CallTapeReaction7() end },		--チコテープ3への相の手無線7つ目
		--		{ data="e0010_rtrg1277", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.CallTapeReaction8() end },		--チコテープ3への相の手無線8つ目
		--		{ data="e0010_rtrg1278", message = "SubtitlesEventMessage", commonFunc = function() e20010_require_01.CallTapeReaction9() end },		--チコテープ3への相の手無線9つ目
		},
	},

	OnEnter = function( manager )
		local LightState	= TppGadgetManager.GetGadgetStatus( "gntn_center_SwitchLight" )
		--ルートセット設定
		Seq_NextRescuePaz_RouteSet()
		--雨さえぎりOFF
		WoodTurret_RainFilter_OFF()
		--前シーケンスルートリアライズ解除
		TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( this.cpID , "S_Sen_HeliPortFrontGate_a" , false )
		TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( this.cpID , "S_Sen_HeliPortFrontGate_b" , false )
		--達成済み写真のチェック
		SetComplatePhoto()
		--先チコ？
		TppMission.SetFlag( "isFirstEncount_Chico", true )
		--カセットテープ５を消す
		TppPickableManager.DisableByLocator( "tp_chico_05" )
		-- デフォルトランディングゾーン設定
		TppSupportHelicopterService.SetDefaultRendezvousPointMarker("RV_SeaSide")
		--共通処理：ミッション圏外
		All_Seq_MissionAreaOut()
		--チコパス扉設定
		ChicoDoor_ON_Open()
		PazDoor_ON_Close()
		--トラップEnable/Disable
		Seq10Trap_Disable()
		Seq10_20Trap_Enable()
		Seq20Trap_Enable()
		Seq30Trap_Disable()
		Seq40Trap_Disable()
		-- パスのモーションをつながれにする
		ChengeChicoPazIdleMotion()
		--輸送トラックにサブマシンガン
		TppNewCollectibleUtility.PutCollectibleOnCharacter{ id = "WP_sm00_v00", count = 330, target = "Cargo_Truck_WEST_004" , attachPoint = "CNP_USERITEM" }
		--諜報無線セット
		SetIntelRadio()
		--任意無線設定
		SetOptionalRadio()
		--フラグセット
		TppMission.SetFlag( "isCenter2F_EneRouteChange", false )
--		TppMission.SetFlag( "isComEne25RouteChange01", false )
--		TppMission.SetFlag( "isComEne25RouteChange02", false )
--		TppMission.SetFlag( "isComEne25RouteChange03", false )
		TppMission.SetFlag( "isSmokingRouteChange", false )
		TppMission.SetFlag( "isCenterBackEnter", false )
		--ガードターゲット設定
		GuardTarget_Setting()
		--キャラEnable/Disable
		Seq10Enemy_Disable()
		Seq20Enemy_Enable()
		Seq30Enemy_Disable()
		Seq40Enemy_Disable()
		-- 先チコ車輌設定
		FirstChico_Vehicle_01()
		-- チコテープ3再生中の無線再生許可判定
		local radioDaemon = RadioDaemon:GetInstance()
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1270") == false or
			radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1271") == false or
			radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1272") == false or
			radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1274") == false) then
			if( TppMission.GetFlag( "isPazMarkJingle" ) == false and TppMission.GetFlag( "isInterrogation_Radio" ) == false ) then
				--チコ3再生中に無線再生できないようにする
				TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( true )
			else
				--チコ3再生中に無線再生できるようにする
				TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( false )
			end
		else
			--チコ3再生中に無線再生できるようにする
			TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( false )
		end

		if( TppMission.GetFlag( "isQuestionChico" ) == true ) then				--チコ回収デモを見ている
			--中間目標設定
			if( TppMission.GetFlag( "isCassetteDemo" ) == false ) and
				( TppMission.GetFlag( "isPlaceOnHeliChico" ) == false )	then
				commonUiMissionSubGoalNo(3)
				ChicoPazQustionDemoAfterReStart()	--チコパス回収デモ後チェックポイント復帰処理
			else
				commonUiMissionSubGoalNo(4)
			end

			if( TppMission.GetFlag( "isCarryOnSpHostage" ) == false ) and			--脱走捕虜を担いだことがある
				( TppMission.GetFlag( "isSpHostage_Dead" ) == false ) and			--脱走捕虜死んでいない
				( TppMission.GetFlag( "isPlaceOnHeliSpHostage" ) == false ) then	--脱走捕虜をヘリで回収していない

				TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_KillSpHostage01", true , false )
			else
			end
			-- カセットテープデモを見ているか否か
			if( TppMission.GetFlag( "isCassetteDemo" ) == false ) then
				e20010_require_01.SpHostageStatus()	--脱走捕虜状態判定
				TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide01b" ) 					--ルート有効
				TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide02b" ) 					--ルート有効
				TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_b" ) 		--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Seeing_Sea" )						--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide01a" )					--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide02a" )					--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide02c" )					--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_Waiting_PC_AsyOut01" )					--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_Waiting_PC_AsyOut02" )					--ルート無効
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_AsylumOutSideGate_b" , -1 , "ComEne09" , "ROUTE_PRIORITY_TYPE_FORCED" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Pat_SeaSide01b" , -1 , "Seq20_04" , "ROUTE_PRIORITY_TYPE_FORCED" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Pat_SeaSide02b" , -1 , "Seq20_03" , "ROUTE_PRIORITY_TYPE_FORCED" )
			else
			end
		else																--チコ回収デモを見ていない
			--中間目標設定
			if( TppMission.GetFlag( "isCassetteDemo" ) == false ) then
				commonUiMissionSubGoalNo(2)
				TppMissionManager.SaveGame("20")	--シーケンスセーブ
			else
				commonUiMissionSubGoalNo(4)
			end
			--共通処理：マーカー
			TppMarkerSystem.DisableMarker{ markerId = "20010_marker_Chico" }
			TppMarkerSystem.DisableMarker{ markerId = "20010_marker_ChicoPinpoint" }
			--海岸ＲＶ表示
			if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == false ) then
				RV_MarkerON()
				AnounceLog_enemyReplacement()
			else
				TppMarkerSystem.DisableMarker{ markerId = "20010_marker_RV" }
			end
			--チコマーカーＯＮ
			Chico_MarkerON()
			--有効ルート
			TppEnemy.EnableRoute( this.cpID , "S_Sen_EastCampCenter_East02" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_WestCamp_NorthGate" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_SeaSideEnter02" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouseBehind" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumBehind" )
			TppEnemy.EnableRoute( this.cpID , "S_Seeing_Sea" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_a" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_EastCamp_NorthLeftGate" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouse_NorthGate" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortFrontGate_a" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortFrontGate_b" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortHouse" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBehind_a" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBehind_b" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPort_Front" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortCenter_b" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_BigGate_a" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_BigGate_b" )
			TppEnemy.EnableRoute( this.cpID , "S_Pre_CenterDoorOut" )
			TppEnemy.EnableRoute( this.cpID , "S_Search_Xof" )
			TppEnemy.EnableRoute( this.cpID , "S_WaitingInBoilar_01" )
			TppEnemy.EnableRoute( this.cpID , "S_WaitingInBoilar_02" )
			TppEnemy.EnableRoute( this.cpID , "S_WaitingInTruck" )
			TppEnemy.EnableRoute( this.cpID , "S_Waiting_PC_AsyOut01" )
			TppEnemy.EnableRoute( this.cpID , "S_Waiting_PC_AsyOut02" )
			TppEnemy.EnableRoute( this.cpID , "S_Waiting_Seq20_05" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortYard" )
			TppEnemy.EnableRoute( this.cpID , "S_Seeing_Sea" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_BoilarFront" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_a" )
			--初期無効ルート
			TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide01a" )
			TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide01b" )
			TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide02a" )
			TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide02b" )
			TppEnemy.DisableRoute( this.cpID , "Seq20_04_Talk_KillHostage" )
			TppEnemy.DisableRoute( this.cpID , "GoToKillHostageArea" )
			TppEnemy.DisableRoute( this.cpID , "KillHostage01" )
			TppEnemy.DisableRoute( this.cpID , "KillHostage02" )
			TppEnemy.DisableRoute( this.cpID , "KillHostage03" )
			TppEnemy.DisableRoute( this.cpID , "KillHostage04" )
			TppEnemy.DisableRoute( this.cpID , "Seq20_02_RideOnTruck" )
			TppEnemy.DisableRoute( this.cpID , "GoToEastcampSouthGate" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_EastCamp_SouthLeftGate" )
			TppEnemy.DisableRoute( this.cpID , "S_Pat_EastCamp_North" )
			TppEnemy.DisableRoute( this.cpID , "OutDoorFromWareHouse" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_WareHousePloofUnder" )
			TppEnemy.DisableRoute( this.cpID , "S_Ret_Center_d" )
			TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_d" )
			TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_2Fto1F" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_e" )
			TppEnemy.DisableRoute( this.cpID , "S_Mov_Smoking_Center" )
			TppEnemy.DisableRoute( this.cpID , "S_GetOut_Boilar01" )
			TppEnemy.DisableRoute( this.cpID , "S_GetOut_Boilar02" )
			TppEnemy.DisableRoute( this.cpID , "S_TalkingDelatetape_After01" )
			TppEnemy.DisableRoute( this.cpID , "S_TalkingDelatetape_After02" )
			TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter01" )
			TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter02" )
			TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter03" )
			TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter04" )
			TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_go" )
			TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_go" )
			TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate01" )
			TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate02" )
			TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_back" )
			TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_back" )
			TppEnemy.DisableRoute( this.cpID , "S_Waiting_Vehicle" )
			TppEnemy.DisableRoute( this.cpID , "GoToWareHouse3Mancell" )
			TppEnemy.DisableRoute( this.cpID , "GoToWareHouse3Mancell" )
			TppEnemy.DisableRoute( this.cpID , "GoToWareHouse3Mancell" )
			TppEnemy.DisableRoute( this.cpID , "GoTo_CenterBuilding" )
			TppEnemy.DisableRoute( this.cpID , "GoToWareHouse_ComEne13" )
			TppEnemy.DisableRoute( this.cpID , "GoToWareHouse_ComEne14" )
			TppEnemy.DisableRoute( this.cpID , "GoToWestCampWestGate_Seq20_03" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_WestCamp_WestGate" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_WareHouseKeeper01" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_WareHouseKeeper02" )
			TppEnemy.DisableRoute( this.cpID , "S_Talk_AboutBoilar" )
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage01" )
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage02" )
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage03" )
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage04" )
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage05a" )
			TppEnemy.DisableRoute( this.cpID , "Seq20_02_RideOnTruck" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_f" )
			TppEnemy.DisableRoute( this.cpID , "S_Mov_CenterHouse_b2" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Bridge" )
			TppEnemy.DisableRoute( this.cpID , "ComEne17_TalkRoute" )
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage05b" )
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage06a" )
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage06b" )
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage07a" )
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage07b" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_AsylumOutSideGate_b" )
			TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret01_Route" )
			TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret05_Route" )
			TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL02_Route" )
			TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL04_Route" )
			TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL05_Route" )
			TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF_v3" )
			TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF_v2" )
			--停電中か否か
			if ( LightState == 2 ) then		--停電中
				TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "SmokingRouteChange", false , false )
				TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Center2F_EneRouteChange", false , false )
				TppEnemy.EnableRoute( this.cpID , "ComEne25_SwitchOFF" )
				TppEnemy.EnableRoute( this.cpID , "ComEne26_SwitchOFF" )
				TppEnemy.EnableRoute( this.cpID , "ComEne27_SwitchOFF" )
				TppEnemy.EnableRoute( this.cpID , "ComEne28_SwitchOFF" )
				TppEnemy.EnableRoute( this.cpID , "ComEne29_SwitchOFF" )
				TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" )
				TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_a" )
				TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_b" )
				TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_c" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "ComEne25_SwitchOFF" , -1 , "ComEne25" , "ROUTE_PRIORITY_TYPE_FORCED" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "ComEne26_SwitchOFF" , -1 , "ComEne26" , "ROUTE_PRIORITY_TYPE_FORCED" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "ComEne27_SwitchOFF" , -1 , "ComEne27" , "ROUTE_PRIORITY_TYPE_FORCED" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "ComEne28_SwitchOFF" , -1 , "ComEne28" , "ROUTE_PRIORITY_TYPE_FORCED" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "ComEne29_SwitchOFF" , -1 , "ComEne29" , "ROUTE_PRIORITY_TYPE_FORCED" )
			else
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" )
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_a" )
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_b" )
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_c" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_Center_d" , -1 , "ComEne25" , "ROUTE_PRIORITY_TYPE_FORCED" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_Center_a" , -1 , "ComEne26" , "ROUTE_PRIORITY_TYPE_FORCED" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_BoilarFront" , -1 , "ComEne27" , "ROUTE_PRIORITY_TYPE_FORCED" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_Center_b" , -1 , "ComEne28" , "ROUTE_PRIORITY_TYPE_FORCED" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_Center_c" , -1 , "ComEne29" , "ROUTE_PRIORITY_TYPE_FORCED" )
			end
			--共通敵兵専用ルートセット
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_EastCampCenter_East02" , -1 , "ComEne01" , "ROUTE_PRIORITY_TYPE_FORCED" )
			if( TppMission.GetFlag( "isWoodTurret04_Break" ) == false ) then
				TppEnemy.EnableRoute( this.cpID , "S_SL_WestCamp" )
				TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret04_Route" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_SL_WestCamp" , -1 , "ComEne02" , "ROUTE_PRIORITY_TYPE_FORCED" )
			else
				TppEnemy.EnableRoute( this.cpID , "Break_WoodTurret04_Route" )
				TppEnemy.DisableRoute( this.cpID , "S_SL_WestCamp" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "Break_WoodTurret04_Route" , -1 , "ComEne02" , "ROUTE_PRIORITY_TYPE_FORCED" )
			end
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_WestCamp_NorthGate" , -1 , "ComEne03" , "ROUTE_PRIORITY_TYPE_FORCED" )
			if( TppMission.GetFlag( "isIronTurretSL01_Break" ) == false ) then
				TppEnemy.EnableRoute( this.cpID , "S_SL_WareHouse01a" )
				TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL01_Route" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_SL_WareHouse01a" , -1 , "ComEne04" , "ROUTE_PRIORITY_TYPE_FORCED" )
			else
				TppEnemy.EnableRoute( this.cpID , "Break_IronTurretSL01_Route" )
				TppEnemy.DisableRoute( this.cpID , "S_SL_WareHouse01a" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "Break_IronTurretSL01_Route" , -1 , "ComEne04" , "ROUTE_PRIORITY_TYPE_FORCED" )
			end
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_SeaSideEnter02" , -1 , "ComEne05" , "ROUTE_PRIORITY_TYPE_FORCED" )
			if( TppMission.GetFlag( "isWoodTurret03_Break" ) == false ) then
				TppEnemy.EnableRoute( this.cpID , "S_SL_EastCamp_North" )
				TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret03_Route" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_SL_EastCamp_North" , -1 , "ComEne06" , "ROUTE_PRIORITY_TYPE_FORCED" )
			else
				TppEnemy.EnableRoute( this.cpID , "Break_WoodTurret03_Route" )
				TppEnemy.DisableRoute( this.cpID , "S_SL_EastCamp_North" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "Break_WoodTurret03_Route" , -1 , "ComEne06" , "ROUTE_PRIORITY_TYPE_FORCED" )
			end
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_WareHouseBehind" , -1 , "ComEne07" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_AsylumBehind" , -1 , "ComEne08" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Seeing_Sea" , -1 , "ComEne09" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_AsylumOutSideGate_a" , -1 , "ComEne10" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_EastCamp_NorthLeftGate" , -1 , "ComEne11" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_WareHouse_NorthGate" , -1 , "ComEne12" , "ROUTE_PRIORITY_TYPE_FORCED" )
			--ComEne13は分岐ルートの為、ここには書かない
			--ComEne14は分岐ルートの為、ここには書かない
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_HeliPortFrontGate_a" , -1 , "ComEne15" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_HeliPortFrontGate_b" , -1 , "ComEne16" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_HeliPortHouse" , -1 , "ComEne17" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_HeliPortBehind_a" , -1 , "ComEne18" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_HeliPortBehind_b" , -1 , "ComEne19" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_HeliPortYard" , -1 , "ComEne20" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_HeliPort_Front" , -1 , "ComEne21" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_HeliPortCenter_b" , -1 , "ComEne22" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_BigGate_a" , -1 , "ComEne23" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Sen_BigGate_b" , -1 , "ComEne24" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Search_Xof" , -1 , "ComEne30" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_WaitingInBoilar_01" , -1 , "ComEne31" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_WaitingInBoilar_02" , -1 , "ComEne32" , "ROUTE_PRIORITY_TYPE_FORCED" )
			if( TppMission.GetFlag( "isWoodTurret02_Break" ) == false ) then
				TppEnemy.EnableRoute( this.cpID , "S_SL_EastCamp_South_in" )
				TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret02_Route" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_SL_EastCamp_South_in" , -1 , "ComEne33" , "ROUTE_PRIORITY_TYPE_FORCED" )
			else
				TppEnemy.EnableRoute( this.cpID , "Break_WoodTurret02_Route" )
				TppEnemy.DisableRoute( this.cpID , "S_SL_EastCamp_South_in" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "Break_WoodTurret02_Route" , -1 , "ComEne33" , "ROUTE_PRIORITY_TYPE_FORCED" )
			end
			if( TppMission.GetFlag( "isCenterTowerSL_Break" ) == false ) then
				TppEnemy.EnableRoute( this.cpID , "S_SL_HeliPortTower" )
				TppEnemy.DisableRoute( this.cpID , "Break_CenterTower_Route" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_SL_HeliPortTower" , -1 , "ComEne34" , "ROUTE_PRIORITY_TYPE_FORCED" )
			else
				TppEnemy.EnableRoute( this.cpID , "Break_CenterTower_Route" )
				TppEnemy.DisableRoute( this.cpID , "S_SL_HeliPortTower" )
				TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "Break_CenterTower_Route" , -1 , "ComEne34" , "ROUTE_PRIORITY_TYPE_FORCED" )
			end
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_WaitingInTruck" , -1 , "Seq20_02" , "ROUTE_PRIORITY_TYPE_FORCED" )
--			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Waiting_PC_AsyOut01" , -1 , "Seq20_03" , "ROUTE_PRIORITY_TYPE_FORCED" )
--			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Waiting_PC_AsyOut02" , -1 , "Seq20_04" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_Waiting_Seq20_05" , -1 , "Seq20_05" , "ROUTE_PRIORITY_TYPE_FORCED" )
			--ピッキングドア１５を開錠してるか否か
			if( TppMission.GetFlag( "isAsyPickingDoor15" ) == false ) then
				TppHostageManager.GsSetStruggleFlag( "Hostage_e20010_003" , true )
				TppHostageManager.GsSetStruggleVoice( "Hostage_e20010_003" , "POWV_0260" )
			else
			end
			--ピッキングドア０５を開錠してるか否か
			if( TppMission.GetFlag( "isAsyPickingDoor05" ) == false ) then
				TppHostageManager.GsSetStruggleFlag( "Hostage_e20010_004" , true )
				TppHostageManager.GsSetStruggleVoice( "Hostage_e20010_004" , "POWV_0270" )
			else
			end
			--脱走捕虜状態判定
			e20010_require_01.SpHostageStatus()
		end
	end,
	--
	Talk_SearchSpHostage = function()
		TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage05b" ) 						--ルート有効
		TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage05a" )						--ルート無効
		TppEnemy.ChangeRoute( this.cpID , "Seq20_04","e20010_Seq20_SneakRouteSet","S_SearchSpHostage05b",0 )	--指定敵兵ルートチェンジ
	end,
	-- 巨大ゲートを通過するトラック
	Seq20_02_ArrivedAtRoutePoint = function()
		local phase				= TppEnemy.GetPhase( this.cpID )
		local RouteName			= TppData.GetArgument(2)
		local RoutePointNumber	= TppData.GetArgument(3)
		local GateState			= TppGadgetManager.GetGadgetStatus( "gntn_BigGateSwitch" )

		if ( RouteName ==  GsRoute.GetRouteId( "GateOpenTruck01" )) then
			if( RoutePointNumber == 5 ) or ( RoutePointNumber == 7 ) then
				--PCが荷台に潜入しているか？否か？
				if( TppMission.GetFlag( "isTruckSneakRideOn" ) == true ) then
					--トラックルートチェンジ
					TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Cargo_Truck_WEST_004" , "GateEnterTruck" , -1 )
					TppMission.SetFlag( "isNoConversation_GateInTruck", true )
				else
				end
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "GateEnterTruck" )) then
			if( RoutePointNumber == 2 ) then
				if( TppMission.GetFlag( "isNoConversation_GateInTruck" ) == true ) then
					if( TppMission.GetFlag( "isTruckSneakRideOn" ) == true ) then
						if ( phase == "sneak" ) and ( GateState == 2 ) then
							local onDemoStart = function()
								TppMusicManager.PostJingleEvent( 'SuspendPhase', 'Play_bgm_gntn_jingle_gate' )
							end
							local onDemoEnd = function()
							end
							TppDemo.Play( "BigGateOpenDemo" , { onStart = onDemoStart, onEnd = onDemoEnd } , {
								disableGame				= false,	--共通ゲーム無効を、キャンセル
								disableDamageFilter		= false,	--エフェクトは消さない
								disableDemoEnemies		= false,	--敵兵は消さないでいい
								disableEnemyReaction	= false,	--敵兵のリアクションを向こうかする
								disableHelicopter		= false,	--支援ヘリは消さないでいい
								disablePlacement		= false, 	--設置物は消さないでいい
								disableThrowing			= false	 	--投擲物は消さないでいい
							})
						else	--sneakフェイズ以外&ゲート閉じている以外
							--トラック荷台ゲート通過演出無し
							GZCommon.Common_CenterBigGateVehicleSetup( this.cpID, "TppGroupVehicleRouteInfo_Seq20_02a", "GateEnterTruck", "GateEnterTruck02", 2, 1 )
							TppMission.SetFlag( "isSeq20_02_DriveEnd", 1 )
						end
					else
						--荷台に乗ってなかったら、トラック荷台ゲート通過演出無し
						GZCommon.Common_CenterBigGateVehicleSetup( this.cpID, "TppGroupVehicleRouteInfo_Seq20_02a", "GateEnterTruck", "GateEnterTruck02", 2, 1 )
						TppMission.SetFlag( "isSeq20_02_DriveEnd", 1 )
					end
				else
					--管理棟巨大ゲート通過車輌設定
					GZCommon.Common_CenterBigGateVehicleSetup( this.cpID, "TppGroupVehicleRouteInfo_Seq20_02b", "GateEnterTruck", "GateEnterTruck02", 2, 1 )
					TppMission.SetFlag( "isSeq20_02_DriveEnd", 1 )
				end
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "GoTo_CenterBuilding" )) then
			if( RoutePointNumber == 7 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Mov_CenterHouse_b2" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "GoTo_CenterBuilding" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq20_02","e20010_Seq20_SneakRouteSet","S_Mov_CenterHouse_b2", 0 )	--指定敵兵ルートチェンジ
			else
			end
		end
	end,

	--管理棟に入るトラック車輌連携終了判定
	EnterCenterTruck = function()
		local VehicleGroupInfo			= TppData.GetArgument(2)
		local VehicleGroupInfoName		= VehicleGroupInfo.routeInfoName
		local VehicleGroupResult		= VehicleGroupInfo.result
		local VehicleGroupReason		= VehicleGroupInfo.reason

		if( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Seq20_02a" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				if( TppMission.GetFlag( "isSeq20_02_DriveEnd" ) == 1 ) then
					TppMission.SetFlag( "isSeq20_02_DriveEnd", 2 )
					TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq20_02" , false )
					TppEnemy.EnableRoute( this.cpID , "GoTo_CenterBuilding" )
					TppEnemy.ChangeRoute( this.cpID , "Seq20_02","e20010_Seq20_SneakRouteSet","GoTo_CenterBuilding", 0 )
				else
					TppEnemy.EnableRoute( this.cpID , "S_Talk_AboutBoilar" )
					TppEnemy.ChangeRoute( this.cpID , "Seq20_02","e20010_Seq20_SneakRouteSet","S_Talk_AboutBoilar", 0 )
				end
			else
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq20_02" , false )
				TppEnemy.EnableRoute( this.cpID , "GoTo_CenterBuilding" )
				TppEnemy.ChangeRoute( this.cpID , "Seq20_02","e20010_Seq20_SneakRouteSet","GoTo_CenterBuilding", -1 )
			end
		elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Seq20_02b" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				TppMission.SetFlag( "isSeq20_02_DriveEnd", 2 )
			else
			end
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq20_02" , false )
			TppEnemy.EnableRoute( this.cpID , "GoTo_CenterBuilding" )
			TppEnemy.ChangeRoute( this.cpID , "Seq20_02","e20010_Seq20_SneakRouteSet","GoTo_CenterBuilding", -1 )
		else
		end
	end,

	--会話終了判定
	local_ConversationEnd = function()
		local label		= TppData.GetArgument(2)
		local judge		= TppData.GetArgument(4)
		if ( label == "CTE0010_0280") then
			if ( judge == true ) then
				if( TppMission.GetFlag( "isCTE0010_0280_NearArea" ) == true ) then
					TppRadio.Play("Miller_LeadSpHostageEscape")
				else
				end
			else
			end
			TppEnemy.EnableRoute( this.cpID , "GoToKillHostageArea" ) 				--ルート有効
			TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide01b" ) 					--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide02b" )					--ルート無効
			TppEnemy.DisableRoute( this.cpID , "Seq20_04_Talk_KillHostage" )		--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "Seq20_03","e20010_Seq20_SneakRouteSet","GoToKillHostageArea",0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "Seq20_04","e20010_Seq20_SneakRouteSet","S_Pat_SeaSide01b",0 )	--指定敵兵ルートチェンジ
		elseif ( label == "CTE0010_0290") then
			TppHostageUtility.SetHostageStatusInCp( "gntn_cp", "SpHostage", "HOSTAGE_STATUS_EXECUTE" )	--脱走捕虜のステータス変更
			TppMission.SetFlag( "isKillingSpHostage", true )
			TppEnemy.EnableRoute( this.cpID , "KillHostage01" ) 					--ルート有効
			TppEnemy.EnableRoute( this.cpID , "KillHostage02" ) 					--ルート有効
			TppEnemy.EnableRoute( this.cpID , "KillHostage03" ) 					--ルート有効
			TppEnemy.EnableRoute( this.cpID , "KillHostage04" ) 					--ルート有効
			TppEnemy.DisableRoute( this.cpID , "KillWaiting_Hostage01" )			--ルート無効
			TppEnemy.DisableRoute( this.cpID , "KillWaiting_Hostage02" )			--ルート無効
			TppEnemy.DisableRoute( this.cpID , "KillWaiting_Hostage03" )			--ルート無効
			TppEnemy.DisableRoute( this.cpID , "GoToKillHostageArea" )				--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "Seq20_01","e20010_Seq20_SneakRouteSet","KillHostage01",0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq20_SneakRouteSet","KillHostage02",0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "ComEne14","e20010_Seq20_SneakRouteSet","KillHostage03",0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "Seq20_03","e20010_Seq20_SneakRouteSet","KillHostage04",0 )	--指定敵兵ルートチェンジ
		elseif ( label == "CTE0010_0300") then
			TppMission.SetFlag( "isKillingSpHostage", false )
			TppEnemy.EnableRoute( this.cpID , "S_Waiting_Vehicle" ) 				--ルート有効
			TppEnemy.EnableRoute( this.cpID , "GoToWareHouse_ComEne13" ) 			--ルート有効
			TppEnemy.EnableRoute( this.cpID , "GoToWareHouse_ComEne14" ) 			--ルート有効
			TppEnemy.EnableRoute( this.cpID , "GoToWestCampWestGate_Seq20_03" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter01" )				--ルート無効
			TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter02" )				--ルート無効
			TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter03" )				--ルート無効
			TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter04" )				--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "Seq20_01","e20010_Seq20_SneakRouteSet","S_Waiting_Vehicle",0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq20_SneakRouteSet","GoToWareHouse_ComEne13",0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "ComEne14","e20010_Seq20_SneakRouteSet","GoToWareHouse_ComEne14",0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "Seq20_03","e20010_Seq20_SneakRouteSet","GoToWestCampWestGate_Seq20_03",0 )	--指定敵兵ルートチェンジ
		elseif ( label == "CTE0010_0340") then
			local LightState	= TppGadgetManager.GetGadgetStatus( "gntn_center_SwitchLight" )

			TppEnemy.EnableRoute( this.cpID , "S_TalkingDelatetape_After01" ) 				--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_GetOut_Boilar01" )						--ルート無効
			TppEnemy.DisableRoute( this.cpID , "S_GetOut_Boilar02" )						--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq20_SneakRouteSet","S_TalkingDelatetape_After01",0 )	--指定敵兵ルートチェンジ
			--停電中か否か
			if ( LightState == 2 ) then		--停電中
				TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF_v2" ) 				--ルート有効
				TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq20_SneakRouteSet","ComEne31_SwitchOFF_v2",0 )	--指定敵兵ルートチェンジ
			else
				TppEnemy.EnableRoute( this.cpID , "S_TalkingDelatetape_After02" ) 				--ルート有効
				TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq20_SneakRouteSet","S_TalkingDelatetape_After02",0 )	--指定敵兵ルートチェンジ
			end
		elseif ( label == "CTE0010_0380") then
			TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage06a" ) 					--ルート有効
			TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage07a" ) 					--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage05b" )					--ルート無効
			TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage03" )					--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "Seq20_04","e20010_Seq20_SneakRouteSet","S_SearchSpHostage06a",0 )	--指定敵兵ルートチェンジ
			TppEnemy.ChangeRoute( this.cpID , "Seq20_01","e20010_Seq20_SneakRouteSet","S_SearchSpHostage07a",0 )	--指定敵兵ルートチェンジ
		elseif ( label == "CTE0010_0390") then
			TppEnemy.EnableRoute( this.cpID , "GoToEastcampSouthGate" ) 				--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Sen_EastCampCenter_East02" )						--ルート無効
			TppEnemy.ChangeRoute( this.cpID , "ComEne01","e20010_Seq20_SneakRouteSet","GoToEastcampSouthGate",0 )	--指定敵兵ルートチェンジ
		end
	end,
	--ComEne18ノードアクション
	ComEne18_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_HeliPort_2manSeparate02" )) then
			if( RoutePointNumber == 12 ) then
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate01" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq20_SneakRouteSet","S_HeliPort_2mancell_back", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate02" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq20_SneakRouteSet","S_HeliPort_2mancell_back", 0 )	--指定敵兵ルートチェンジ
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "S_HeliPort_2mancell_back" )) then
			if( RoutePointNumber == 6 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBehind_a" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBehind_b" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq20_SneakRouteSet","S_Sen_HeliPortBehind_a", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq20_SneakRouteSet","S_Sen_HeliPortBehind_b", 0 )	--指定敵兵ルートチェンジ	--指定敵兵ルートチェンジ
			else
			end
		end
	end,
	--ComEne19ノードアクション
	ComEne19_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Sen_HeliPortBehind_b" )) then
			if( RoutePointNumber == 4 ) then
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortBehind_b" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq20_SneakRouteSet","S_HeliPort_2mancell_go", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortBehind_a" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq20_SneakRouteSet","S_HeliPort_2mancell_go", 0 )	--指定敵兵ルートチェンジ
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "S_HeliPort_2mancell_go" )) then
			if( RoutePointNumber == 9 ) then
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2manSeparate01" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2manSeparate02" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq20_SneakRouteSet","S_HeliPort_2manSeparate02", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq20_SneakRouteSet","S_HeliPort_2manSeparate01", 0 )	--指定敵兵ルートチェンジ
			else
			end
		end
	end,
	--管理棟配電敵兵ノードアクション
	ComEne25_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Mov_Center_d" )) then
			if( RoutePointNumber == 5 ) then										--ノードを通過した時
				if( TppMission.GetFlag( "isCenterBackEnter" ) == true ) then
					TppEnemy.EnableRoute( this.cpID , "S_Ret_Center_d" ) 	--ルート有効
					TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_d" ) 	--ルート無効
					TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq20_SneakRouteSet","S_Ret_Center_d", 0 )	--指定敵兵ルートチェンジ
				else
				end
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "S_Ret_Center_d" )) then
			if( RoutePointNumber == 8 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Ret_Center_d" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne25","e20010_Seq20_SneakRouteSet","S_Sen_Center_d", 0 )	--指定敵兵ルートチェンジ
			else
			end
		end
	end,
	--管理棟キャットウオーク敵兵ノードアクション
	ComEne29_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Mov_Center_2Fto1F" )) then
			if( RoutePointNumber == 15 ) then										--ノードを通過した時
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_e" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Mov_Center_2Fto1F" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne29","e20010_Seq20_SneakRouteSet","S_Sen_Center_e", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--テープ破棄会話敵兵ノードアクション
	ComEne31_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		local LightState	= TppGadgetManager.GetGadgetStatus( "gntn_center_SwitchLight" )
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_TalkingDelatetape_After01" )) then
			if( RoutePointNumber == 13 ) then										--ノードを通過した時
				TppEnemy.DisableRoute( this.cpID , "S_TalkingDelatetape_After01" ) 	--ルート無効
				--停電中か否か
				if ( LightState == 2 ) then		--停電中
					TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF_v3" ) 	--ルート有効
					TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq20_SneakRouteSet","ComEne31_SwitchOFF_v3", 0 )	--指定敵兵ルートチェンジ
				else
					TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_f" ) 	--ルート有効
					TppEnemy.ChangeRoute( this.cpID , "ComEne31","e20010_Seq20_SneakRouteSet","S_Sen_Center_f", 0 )	--指定敵兵ルートチェンジ
				end
			else
			end
		else
		end
	end,
	--Seq20_01ノードアクション
	Seq20_01_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_SearchSpHostage07a" )) then
			if( RoutePointNumber == 7 ) then
				TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage07b" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage07a" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq20_01","e20010_Seq20_SneakRouteSet","S_SearchSpHostage07b",0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--Seq20_03ノードアクション
	Seq20_03_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Pat_SeaSide02a" )) then
			if( RoutePointNumber == 8 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide02c" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide02a" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq20_03","e20010_Seq20_SneakRouteSet","S_Pat_SeaSide02c",0 )	--指定敵兵ルートチェンジ
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "GoToKillHostageArea" )) then
			if( RoutePointNumber == 37 ) then
				TppHostageUtility.SetHostageStatusInCp( "gntn_cp", "SpHostage", "HOSTAGE_STATUS_EXECUTE" )	--脱走捕虜のステータス変更
				TppMission.SetFlag( "isKillingSpHostage", true )
				TppEnemy.EnableRoute( this.cpID , "KillHostage01" ) 					--ルート有効
				TppEnemy.EnableRoute( this.cpID , "KillHostage02" ) 					--ルート有効
				TppEnemy.EnableRoute( this.cpID , "KillHostage03" ) 					--ルート有効
				TppEnemy.EnableRoute( this.cpID , "KillHostage04" ) 					--ルート有効
				TppEnemy.DisableRoute( this.cpID , "KillWaiting_Hostage01" )			--ルート無効
				TppEnemy.DisableRoute( this.cpID , "KillWaiting_Hostage02" )			--ルート無効
				TppEnemy.DisableRoute( this.cpID , "KillWaiting_Hostage03" )			--ルート無効
				TppEnemy.DisableRoute( this.cpID , "GoToKillHostageArea" )				--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq20_01","e20010_Seq20_SneakRouteSet","KillHostage01",0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq20_SneakRouteSet","KillHostage02",0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne14","e20010_Seq20_SneakRouteSet","KillHostage03",0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "Seq20_03","e20010_Seq20_SneakRouteSet","KillHostage04",0 )	--指定敵兵ルートチェンジ
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "GoToWestCampWestGate_Seq20_03" )) then
			if( RoutePointNumber == 4 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_WestCamp_WestGate" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "GoToWestCampWestGate_Seq20_03" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq20_03","e20010_Seq20_SneakRouteSet","S_Sen_WestCamp_WestGate",0 )
			else
			end
		end
	end,
	--Seq20_04ノードアクション
	Seq20_04_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Pat_SeaSide01a" )) then
			if( RoutePointNumber == 5 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide01b" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide01a" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq20_04","e20010_Seq20_SneakRouteSet","S_Pat_SeaSide01b",0 )	--指定敵兵ルートチェンジ
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "S_SearchSpHostage06a" )) then
			if( RoutePointNumber == 5 ) then
				TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage06b" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_SearchSpHostage06a" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq20_04","e20010_Seq20_SneakRouteSet","S_SearchSpHostage06b",0 )	--指定敵兵ルートチェンジ
			else
			end
		end
	end,
	--Seq20_05ノードアクション
	Seq20_05_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "OutDoorFromWareHouse" )) then
			if( RoutePointNumber == 8 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHousePloofUnder" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "OutDoorFromWareHouse" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq20_05","e20010_Seq20_SneakRouteSet","S_Sen_WareHousePloofUnder",0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne01ノードアクション
	ComEne01_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "GoToEastcampSouthGate" )) then
			if( RoutePointNumber == 13 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_EastCamp_SouthLeftGate" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "GoToEastcampSouthGate" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne01","e20010_Seq20_SneakRouteSet","S_Sen_EastCamp_SouthLeftGate",0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne11ノードアクション
	ComEne11_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Pat_EastCamp_North" )) then
			if( RoutePointNumber == 13 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_EastCamp_NorthLeftGate" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Pat_EastCamp_North" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne11","e20010_Seq20_SneakRouteSet","S_Sen_EastCamp_NorthLeftGate",0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne13ノードアクション
	ComEne13_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "GoToWareHouse_ComEne13" )) then
			if( RoutePointNumber == 8 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouseKeeper01" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "GoToWareHouse_ComEne13" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq20_SneakRouteSet","S_Sen_WareHouseKeeper01",0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne14ノードアクション
	ComEne14_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "GoToWareHouse_ComEne14" )) then
			if( RoutePointNumber == 9 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouseKeeper02" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "GoToWareHouse_ComEne14" )	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne14","e20010_Seq20_SneakRouteSet","S_Sen_WareHouseKeeper02",0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	-- 脱走捕虜死亡
	SpHostageIsDead = function()
		local status = TppEnemyUtility.GetLifeStatusByRoute( "gntn_cp" , "KillHostage01" )
		if( TppMission.GetFlag( "isSpHostageKillVersion" ) == true ) then
			if( TppMission.GetFlag( "isKillingSpHostage" ) == true ) and ( status == "Normal" ) then	--処刑執行中に死亡
				TppEnemy.EnableRoute( this.cpID , "SpHostageKillAfter01" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "SpHostageKillAfter02" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "SpHostageKillAfter03" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "SpHostageKillAfter04" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "KillHostage01" ) 	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "KillHostage02" ) 	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "KillHostage03" ) 	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "KillHostage04" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq20_01","e20010_Seq20_SneakRouteSet","SpHostageKillAfter01", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq20_SneakRouteSet","SpHostageKillAfter02", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne14","e20010_Seq20_SneakRouteSet","SpHostageKillAfter03", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "Seq20_03","e20010_Seq20_SneakRouteSet","SpHostageKillAfter04", 0 )	--指定敵兵ルートチェンジ
			else	--それ以外で死亡
				TppEnemy.EnableRoute( this.cpID , "S_Waiting_Vehicle" ) 				--ルート有効
				TppEnemy.EnableRoute( this.cpID , "GoToWareHouse_ComEne13" ) 			--ルート有効
				TppEnemy.EnableRoute( this.cpID , "GoToWareHouse_ComEne14" ) 			--ルート有効
				TppEnemy.EnableRoute( this.cpID , "GoToWestCampWestGate_Seq20_03" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "KillHostage01" ) 					--ルート無効
				TppEnemy.DisableRoute( this.cpID , "KillHostage02" ) 					--ルート無効
				TppEnemy.DisableRoute( this.cpID , "KillHostage03" ) 					--ルート無効
				TppEnemy.DisableRoute( this.cpID , "KillHostage04" ) 					--ルート無効
				TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter01" )				--ルート無効
				TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter02" )				--ルート無効
				TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter03" )				--ルート無効
				TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter04" )				--ルート無効
				TppEnemy.DisableRoute( this.cpID , "GoToKillHostageArea" )				--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "Seq20_01","e20010_Seq20_SneakRouteSet","S_Waiting_Vehicle",0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq20_SneakRouteSet","GoToWareHouse_ComEne13",0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne14","e20010_Seq20_SneakRouteSet","GoToWareHouse_ComEne14",0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "Seq20_03","e20010_Seq20_SneakRouteSet","GoToWestCampWestGate_Seq20_03",0 )	--指定敵兵ルートチェンジ
			end
			TppMission.SetFlag( "isKillingSpHostage", false )
		else
		end
	end,
	-- 脱走捕虜処刑中断設定
	SpHostage_EnemyLost = function()

		TppHostageUtility.SetHostageStatusInCp( "gntn_cp", "SpHostage", "HOSTAGE_STATUS_LOST" )
		TppMission.SetFlag( "isKillingSpHostage", false )
		TppEnemy.EnableRoute( this.cpID , "S_Waiting_Vehicle" ) 				--ルート有効
		TppEnemy.EnableRoute( this.cpID , "GoToWareHouse_ComEne13" ) 			--ルート有効
		TppEnemy.EnableRoute( this.cpID , "GoToWareHouse_ComEne14" ) 			--ルート有効
		TppEnemy.EnableRoute( this.cpID , "GoToWestCampWestGate_Seq20_03" ) 	--ルート有効
		TppEnemy.DisableRoute( this.cpID , "KillHostage01" ) 					--ルート無効
		TppEnemy.DisableRoute( this.cpID , "KillHostage02" ) 					--ルート無効
		TppEnemy.DisableRoute( this.cpID , "KillHostage03" ) 					--ルート無効
		TppEnemy.DisableRoute( this.cpID , "KillHostage04" ) 					--ルート無効
		TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter01" )				--ルート無効
		TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter02" )				--ルート無効
		TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter03" )				--ルート無効
		TppEnemy.DisableRoute( this.cpID , "SpHostageKillAfter04" )				--ルート無効
		TppEnemy.DisableRoute( this.cpID , "GoToKillHostageArea" )				--ルート無効
		TppEnemy.ChangeRoute( this.cpID , "Seq20_01","e20010_Seq20_SneakRouteSet","S_Waiting_Vehicle",0 )	--指定敵兵ルートチェンジ
		TppEnemy.ChangeRoute( this.cpID , "ComEne13","e20010_Seq20_SneakRouteSet","GoToWareHouse_ComEne13",0 )	--指定敵兵ルートチェンジ
		TppEnemy.ChangeRoute( this.cpID , "ComEne14","e20010_Seq20_SneakRouteSet","GoToWareHouse_ComEne14",0 )	--指定敵兵ルートチェンジ
		TppEnemy.ChangeRoute( this.cpID , "Seq20_03","e20010_Seq20_SneakRouteSet","GoToWestCampWestGate_Seq20_03",0 )	--指定敵兵ルートチェンジ
	end,
	--チコをRVに運ぼうとしないとき
	Radio_ChicoRV = function()
--		if( TppMission.GetFlag( "isQuestionChico" ) == false ) then		--チコ回収デモを見ていない
--			if( TppPlayerUtility.IsCarriedCharacter( "Chico" )) then	--チコを担いでいる
--				TppRadio.Play( "Miller_ChicoRV" )
--			else													--チコを担いでいない
--			end
--		else														--チコ回収デモを見ている
--		end
	end,
	--海岸ＲＶに近づいた
	Radio_NearRV = function()
		if( TppMission.GetFlag( "isQuestionChico" ) == false ) then			--チコ回収デモを見ていない
			if( TppPlayerUtility.IsCarriedCharacter( "Chico" )) then		--チコを担いでいる
				TppRadio.DelayPlayEnqueue( "Miller_NearRV", "short" )
			else															--チコを担いでいない
			end

		--[[	if( TppMission.GetFlag( "isFinishOnHeliChico" ) == true ) then	--チコをヘリに乗せた
				if( TppMission.GetFlag( "isChicoTapePlay" ) == false ) then
					TppRadio.Play( "Miller_ChicoTapeReAdvice" )
					e20010_require_01.Check_AlertTapeReAdvice()	--アラート中ならあとで再生
				end
			end]]
		else																--チコ回収デモを見ている
			if( TppMission.GetFlag( "isChicoTapePlay" ) == false ) then		--チコのテープを再生していない
				local radioDaemon = RadioDaemon:GetInstance()
				if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0110") == false ) then
					TppRadio.Play( "Miller_ChicoTapeAdvice02" )
					e20010_require_01.Check_AlertTapeReAdvice()	--アラート中ならあとで再生
				end
			else
			end
		end
	end,
	--海岸ＲＶに到着
	Radio_ArriveRV = function()

		if( TppMission.GetFlag( "isQuestionChico" ) == false ) then		--チコ回収デモを見ていない
			if( TppPlayerUtility.IsCarriedCharacter( "Chico" )) then	--チコを担いでいる
				local phase = TppEnemy.GetPhase( this.cpID )
				if ( phase == "alert" ) then

					--RVの近くにいる敵兵チェック
					local checkPos = Vector3( 127.0,14.5,112.0)
					local size = Vector3( 30.0,24.0,45.0)
					local npcIds = TppNpcUtility.GetNpcByBoxShape( checkPos, size )

					local eneNum = 0
					if npcIds and #npcIds.array > 0 then
						for i,id in ipairs(npcIds.array) do
								local type = TppNpcUtility.GetNpcType( id )
								if type == "Enemy" then
										-- 敵兵だった
										local status = TppEnemyUtility.GetLifeStatus( id )
										if (status =="Dead" or status =="Sleep" or status =="Faint" )then
										else
											eneNum = eneNum + 1
									end
								end
						end
					end
					Fox.Log( eneNum )

					if Check_SafetyArea_enemy("eneCheck_seaside",eneCheckSize_seaside) == true then
						TppRadio.Play( "Miller_ArriveRVChicoNearEnemy" )
					else
						TppRadio.Play( "Miller_ArriveRVChicoAlert" )
					end
					TppRadio.RegisterOptionalRadio( "Optional_RideHeliPaz" )	--0042
				else
					if( TppMission.GetFlag( "isHeliComeToSea" ) == false ) then	--ヘリが海岸に来ていない
						TppRadio.Play( "Miller_ArriveRVChico" )
					--	SetOptionalRadio()
						TppRadio.RegisterOptionalRadio( "Optional_OnRVChico" )	--0019
				--	else
					end
				end
				TppMarkerSystem.DisableMarker{ markerId = "20010_marker_RV" }
			else													--チコを担いでいない
			end
		else														--チコ回収デモを見ている
		end
	end,
	--海岸ＲＶから離れる
	Radio_ArriveRVExit = function()
		if( TppMission.GetFlag( "isQuestionChico" ) == false ) then		--チコ回収デモを見ていない

		else														--チコ回収デモを見ている
		--	TppRadio.Play( "Miller_CareChico" )
		end
	end,
	--パス連行ルート、キャンプ
	Radio_PazTakeRoute_Camp = function()
	--[[	if( TppMission.GetFlag( "isChicoTapeListen" ) == true ) then				--チコテープを聴き終えている
			TppRadio.Play("Miller_PazTakeRouteInCamp")
		else																	--チコテープを入手していない
		end]]
	end,
	--パス連行ルート、ヘリポート
	Radio_PazTakeRoute_HeliPort = function()
		local radioDaemon = RadioDaemon:GetInstance()
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1272") == true ) then
--		if( TppMission.GetFlag( "isChicoTapeListen" ) == true ) then				--チコテープを聴き終えている
			TppRadio.Play("Miller_PazTakeRouteInHeliport")
		else																	--チコテープを入手していない
			if( TppMission.GetFlag( "isCenterEnter" ) == false ) then			--管理棟に入っていないなら
				e20010_require_01.OnVehicleCheckRadioPlay("Miller_InHeliport")
			end
		end
	end,
	--パス連行ルート、ゲート
	Radio_PazTakeRoute_Gate = function()
		local radioDaemon = RadioDaemon:GetInstance()
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1273") == true ) then
--		if( TppMission.GetFlag( "isChicoTapeListen" ) == true ) then				--チコテープを聴き終えている
			TppRadio.Play("Miller_PazTakeRouteInGate")
		else																	--チコテープを入手していない
		end
	end,
	--パス連行ルート、ボイラー室
	Radio_PazTakeRoute_Boilar = function()
		local radioDaemon = RadioDaemon:GetInstance()
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1275") == true ) then
--		if( TppMission.GetFlag( "isChicoTapeListen" ) == true ) then				--チコテープを聴き終えている
		--	TppRadio.Play("Miller_PazTakeRouteInBoilar")
		else																--チコテープを入手していない
		end
	end,
	--パス連行ルート、星条旗
	Radio_PazTakeRoute_Flag = function()
		local radioDaemon = RadioDaemon:GetInstance()
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1271") == true ) then
--		if( TppMission.GetFlag( "isChicoTapeListen" ) == true ) then				--チコテープを聴き終えている
			TppRadio.Play("Miller_PazTakeRouteInFlag")
		else																--チコテープを入手していない
		end
	end,
	--海に落ちるな無線
	Radio_CliffAttention = function()
		if( TppMission.GetFlag( "isQuestionChico" ) == false ) then		--チコ回収デモを見ていない
			TppRadio.Play( "Miller_CliffAttention" )
		end
	end,

	--チコを担いだとき
	ChicoCarriedStart = function()

		local phase = TppEnemy.GetPhase( this.cpID )

	--	TppRadio.DelayPlayEnqueue( "Miller_TakeChicoToRVPoint", "long" )
		TppMission.SetFlag( "isPazChicoDemoArea", false )

		if ( phase == "alert" ) then
			--何もしない
		else
			if( TppMission.GetFlag( "isChicoPaz1stCarry" ) == false ) then
				TppMusicManager.PostJingleEvent( 'SuspendPhase', 'Play_bgm_e20010_jingle_rescue' )
				TppMission.SetFlag( "isChicoPaz1stCarry", true )
			else
			end
		end

	end,

	--チコ回収デモ開始前チェック
	Seq_QuestionChicoDemo_OnlyOnce = function()
		Fox.Log(":: check Seq_QuestionChicoDemo_OnlyOnce ::")

		-- ヘリに乗せられたかチェック
		local status = TppHostageUtility.GetStatus( "Chico" )
		Fox.Log( "chico is "..status )
		if( status == "RideOnHelicopter" )then
			-- テープ回収デモ再生判定 yamamoto 1022
			Fox.Log("statsu is RideOnHelicopter :: Check demo cassette ::")
			local sequence = TppSequence.GetCurrentSequence()
			if( TppMission.GetFlag( "isCassetteDemo" ) == false and sequence == "Seq_NextRescuePaz" and TppMission.GetFlag( "isChicoTapePlay" ) == false )then
				Fox.Log("flag is OK : goto demo sequence")
				TppSequence.ChangeSequence( "Seq_CassetteDemo" )

				return
			end
		end

		--フェイズチェック 		--敵兵チェック
		if( CheckDemoCondition() == true ) then			-- フェイズと敵兵を確認　true =　sneak
			Fox.Log("demo condition is OK")
			if( TppMission.GetFlag( "isQuestionChico" ) == false ) then		--チコ回収デモを見ていない
				Fox.Log("play demo")
				TppHostageManager.GsSetSpecialFaintFlag( "Chico", true ) --デモとの整合性を合わす為に「気絶状態」にする matsushita
				TppSequence.ChangeSequence( "Seq_QuestionChicoDemo" )
			else														--チコ回収デモを見ている
				Fox.Log("no play demo, because watch yet")
				-- 何もしない
			end
		elseif( Check_SafetyArea() == true		--近くに敵兵がいるのかチェック
		and TppMission.GetFlag( "isHeliComeToSea" ) == false ) then
			Fox.Log("no play demo")
			if( TppMission.GetFlag( "isQuestionChico" ) == false ) then		--チコ回収デモを見ていない
				TppMission.SetFlag( "isPazChicoDemoArea", true )
			end
		elseif( TppMission.GetFlag( "isDangerArea" ) == true ) then			--危険エリアにいる
			Fox.Log("no play demo, denger area")
			TppRadio.DelayPlayEnqueue("Miller_CarryDownInDanger", "short")
		end
	end,

	-- チコ・パスに会うデモチェック
	Seq_RescueDemo_OnlyOnce = function()
		--フェイズチェック
		--敵兵チェック

			-- どの扉かのチェック
			if( (TppData.GetArgument( 1 ) == "Paz_PickingDoor00" )) then
				TppMission.SetFlag( "isPazChicoDemoArea", false )
				TppSequence.ChangeSequence( "Seq_RescuePazDemo" )
			end
	end,

-- 独り言
	-- チコの独り言１
	Chico_Monologue = function( manager, messageId, characterId, characterHandle, trapBodyHandle, trapName )

		--チコを担いでいたら
		if( TppPlayerUtility.IsCarriedCharacter( "Chico" )) then

			local obj = Ch.FindCharacterObjectByCharacterId("Chico")

			if not Entity.IsNull(obj) then
				TppHostageManager.GsSetSpecialFaintFlag( "Chico", false )
				TppHostageManager.GsSetSpecialIdleFlag( "Chico", false )
				TppEnemyUtility.CallCharacterMonologue( "CHCD_0010" , 3, obj, true )
				trapBodyHandle:SetInvalid() -- このTrapは用済み
			end
		else
		end
	end,
	-- チコの独り言２
	Chico_Monologue02 = function( manager, messageId, characterId, characterHandle, trapBodyHandle, trapName )

		--チコを担いでいたら
		if( TppPlayerUtility.IsCarriedCharacter( "Chico" )) then

			local obj = Ch.FindCharacterObjectByCharacterId("Chico")

			if not Entity.IsNull(obj) then
				TppHostageManager.GsSetSpecialFaintFlag( "Chico", false )
				TppHostageManager.GsSetSpecialIdleFlag( "Chico", false )
				TppEnemyUtility.CallCharacterMonologue( "CHCD_0020" , 3, obj, true )
				trapBodyHandle:SetInvalid() -- このTrapは用済み
			end
		else
		end
	end,
	-- チコの独り言３
	Chico_Monologue03 = function( manager, messageId, characterId, characterHandle, trapBodyHandle, trapName )

		--チコを担いでいたら
		if( TppPlayerUtility.IsCarriedCharacter( "Chico" )) then

			local obj = Ch.FindCharacterObjectByCharacterId("Chico")

			if not Entity.IsNull(obj) then
				TppHostageManager.GsSetSpecialFaintFlag( "Chico", false )
				TppHostageManager.GsSetSpecialIdleFlag( "Chico", false )
				TppEnemyUtility.CallCharacterMonologue( "CHCD_0030" , 3, obj, true )
				trapBodyHandle:SetInvalid() -- このTrapは用済み
			end
		else
		end
	end,
	-- チコの独り言４
	Chico_Monologue04 = function( manager, messageId, characterId, characterHandle, trapBodyHandle, trapName )

		--チコを担いでいたら
		if( TppPlayerUtility.IsCarriedCharacter( "Chico" )) then

			local obj = Ch.FindCharacterObjectByCharacterId("Chico")

			if not Entity.IsNull(obj) then
				TppHostageManager.GsSetSpecialFaintFlag( "Chico", false )
				TppHostageManager.GsSetSpecialIdleFlag( "Chico", false )
				TppEnemyUtility.CallCharacterMonologue( "CHCD_0040" , 3, obj, true )
				trapBodyHandle:SetInvalid() -- このTrapは用済み
			end
		else
		end
	end,
}
-----------------------------------------------------------------------------------------------------------------
--１人目パスで、チコに会うまで
-----------------------------------------------------------------------------------------------------------------
this.Seq_NextRescueChico = {

	Messages = {
		Character = {
			myMessages.Character[1],
			myMessages.Character[2],
			{ data = "gntn_cp", message = "EndGroupVehicleRouteMove", localFunc = "GoToAsylum_End" },
			{ data = "Paz", message = "MessageHostageCarriedStart", commonFunc = function() e20010_require_01.PazCarryStart() end },
--			{ data = "Paz", message = "MessageHostageCarriedStart", commonFunc = function() TppMission.SetFlag( "isPazChicoDemoArea", false ) end },
			{ data = "Paz", message = "MessageHostageCarriedEnd", localFunc = "Seq_QuestionPazDemo_OnlyOnce" },
			{ data = "Paz", message = "HostageLaidOnVehicle", commonFunc = function() e20010_require_01.Common_HostageOnVehicleInDangerArea() end },
--			{ data = "Paz", message = "HostageLaidOnVehicle", commonFunc = function() TppMission.SetFlag( "isPlaceOnHeliPaz", true ) end },
			{ data = "Player", message = "TryPicking", localFunc = "Seq_RescueDemo_OnlyOnce"  },
			{ data = "ComEne09",	message = "MessageRoutePoint",	localFunc = "ComEne09_NodeAction" },
			{ data = "ComEne10",	message = "MessageRoutePoint",	localFunc = "ComEne10_NodeAction" },
			{ data = "ComEne18",	message = "MessageRoutePoint",	localFunc = "ComEne18_NodeAction" },
			{ data = "ComEne19",	message = "MessageRoutePoint",	localFunc = "ComEne19_NodeAction" },
			{ data = "ComEne24",	message = "MessageRoutePoint",	localFunc = "ComEne24_NodeAction" },
			{ data = "ComEne27",	message = "MessageRoutePoint",	localFunc = "ComEne27_NodeAction" },
			{ data = "ComEne30",	message = "MessageRoutePoint",	localFunc = "ComEne30_NodeAction" },
			{ data = "Seq40_01", message = "MessageRoutePoint",	localFunc = "Seq40_01_NodeAction" },
			{ data = "Seq40_02", message = "MessageRoutePoint",	localFunc = "Seq40_02_NodeAction" },
			{ data = "Seq40_03", message = "MessageRoutePoint",	localFunc = "Seq40_03_NodeAction" },
			{ data = "Seq40_08", message = "MessageRoutePoint",	localFunc = "Seq40_08_NodeAction" },
		},
		Trap = {
			myMessages.Trap[6],
			myMessages.Trap[8],
			myMessages.Trap[9],
			-- Demo trigger
			{ data = "Demo_EncounterChico", message = "Enter", commonFunc = function() Demo_eneChecker("chico") end },
			-- Radio trigger
		--	{ data = "Radio_DiscoveryPaz", message = "Enter", commonFunc = function() TppRadio.Play( "Miller_DiscoveryPaz" ) end },
			{ data = "Radio_NearRV", message = "Enter", localFunc = "Radio_NearRV" },
			{ data = "Radio_ArriveRV", message = "Enter", localFunc = "Radio_ArriveRV" },
			{ data = "Radio_ArriveRV", message = "Exit", localFunc = "Radio_ArriveRVExit" },
			{ data = "toAsylumGroupStart", message = "Enter", localFunc = "toAsylumGroupStart" },
			{ data = "ComEne24_RouteChange", message = "Enter", localFunc = "ComEne24_RouteChange" },
			{ data = "Seq40_ComEne27_RouteChange", message = "Enter", localFunc = "Seq40_ComEne27_RouteChange" },
			{ data = "Seq40_ArmorVehicle_Start", message = "Enter", localFunc = "Seq40_ArmorVehicle_Start" },
			{ data = "Radio_InOldAsylum", message = "Enter", commonFunc = function() e20010_require_01.OptionalRadio_InOldAsylum() end },	--旧収容所の近くに入った
			{ data = "Radio_InOldAsylum", message = "Exit", commonFunc = function() e20010_require_01.OptionalRadio_OutOldAsylum("Optional_RescuePazToRescueChico") end },	--旧収容所から離れた
		},
		Radio = {
		},
		RadioCondition = {
		--	myMessages.RadioCondition[1],	--CQCチュートリアル
			myMessages.RadioCondition[2],	--エルード無線
		--	myMessages.RadioCondition[3],	--ホフク転がり
		},
	},

	OnEnter = function( manager )
		local LightState	= TppGadgetManager.GetGadgetStatus( "gntn_center_SwitchLight" )
		--ルートセット設定
		Seq_NextRescueChico_RouteSet()
		--雨さえぎりOFF
		WoodTurret_RainFilter_OFF()
		--強制リアライズ解除
		TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( this.cpID , "S_Sen_HeliPortFrontGate_a" , false )
		TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( this.cpID , "S_Sen_HeliPortFrontGate_b" , false )
		--達成済み写真のチェック
		SetComplatePhoto()
		--先チコ？
		TppMission.SetFlag( "isFirstEncount_Chico", false )
		--先パス車輌設定
		FirstPaz_Vehicle()
		-- デフォルトランディングゾーン設定
		TppSupportHelicopterService.SetDefaultRendezvousPointMarker("RV_SeaSide")
		--天候設定
		WeatherManager.RequestWeather(2,0)
		--トラップEnable/Disable
		Seq10Trap_Disable()
		Seq10_20Trap_Disable()
		Seq20Trap_Disable()
		Seq30Trap_Disable()
		Seq40Trap_Enable()
		-- パスのモーションをつながれにする
		ChengeChicoPazIdleMotion()
		--リトライ時サイレン処理
		Common_RetryKeepCautionSiren()
		-- チコパス扉設定
		ChicoDoor_ON_Close()
		PazDoor_ON_Open()
		--ミッション圏外処理
		All_Seq_MissionAreaOut()
		--敵兵Disable/Enable
		Seq10Enemy_Disable_Ver2()
		Seq20Enemy_Disable()
		Seq30Enemy_Disable()
		Seq40Enemy_Enable()
		-- 脱走捕虜Disable
		SpHostage_Disable()
		--管理棟巨大ゲートデフォルトオープン
		Common_CenterBigGate_DefaultOpen()
		--ガードターゲット設定
		GuardTarget_Setting()
		--ルート有効
		TppEnemy.EnableRoute( this.cpID , "Seq40_PazCheck01" )
		TppEnemy.EnableRoute( this.cpID , "Seq40_PazCheck02" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_EastCamp_SouthLeftGate" )
		TppEnemy.EnableRoute( this.cpID , "S_Pat_WestCampOutLine" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_SeaSideEnter" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouseBehind" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_EastCamp_NorthLeftGate" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouse_NorthGate" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouseKeeper01" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouseKeeper02" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortFrontGate_a" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortFrontGate_b" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortHouse" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBehind_a" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPort_Outline02" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortCenter_a" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortCenter_b" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortGateSide" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Bridge_3" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_EastCampCenter_East" )
		TppEnemy.EnableRoute( this.cpID , "S_Mov_CenterHouse_a2" )
		TppEnemy.EnableRoute( this.cpID , "S_Mov_CenterHouse_b2" )
		TppEnemy.EnableRoute( this.cpID , "Seq40_03_PreRideOnVehicle" )
		TppEnemy.EnableRoute( this.cpID , "Seq40_04_PreRideOnVehicle" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_SeasideNearBox" )
		TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide_Seq40_06" )
		--ルート無効
		TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_go" )
		TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate01" )
		TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate02" )
		TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_back" )
		TppEnemy.DisableRoute( this.cpID , "GoToCenterB_2F_02" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterB_2F" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterBehind_a" )
		TppEnemy.DisableRoute( this.cpID , "S_GoTo_BoilarFront" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_BoilarFront" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_a" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_c" )
		TppEnemy.DisableRoute( this.cpID , "Seq40_03_RideOnVehicle" )
		TppEnemy.DisableRoute( this.cpID , "Seq40_04_RideOnVehicle" )
		TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret01_Route" )
		TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL02_Route" )
		TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL05_Route" )
		TppEnemy.DisableRoute( this.cpID , "S_Pat_FinalPazCheck" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Bridge" )
		--ルート設定
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "Seq40_PazCheck01" , 0 , "Seq40_01" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "Seq40_PazCheck02" , 0 , "Seq40_02" , "ROUTE_PRIORITY_TYPE_FORCED" )
		-- Seq40_03&Seq40_04はパス回収デモで分岐なのでココには書かない
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_SeasideNearBox" , 0 , "Seq40_05" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Pat_SeaSide_Seq40_06" , 0 , "Seq40_06" , "ROUTE_PRIORITY_TYPE_FORCED" )
		if( TppMission.GetFlag( "isWoodTurret05_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_Asylum" )
			TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret05_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_SL_Asylum" , 0 , "Seq40_07" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_WoodTurret05_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_Asylum" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "Break_WoodTurret05_Route" , 0 , "Seq40_07" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_EastCamp_SouthLeftGate" , 0 , "ComEne01" , "ROUTE_PRIORITY_TYPE_FORCED" )
		if( TppMission.GetFlag( "isWoodTurret04_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_WestCamp" )
			TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret04_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_SL_WestCamp" , 0 , "ComEne02" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_WoodTurret04_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_WestCamp" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "Break_WoodTurret04_Route" , 0 , "ComEne02" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Pat_WestCampOutLine" , 0 , "ComEne03" , "ROUTE_PRIORITY_TYPE_FORCED" )
		if( TppMission.GetFlag( "isIronTurretSL01_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_WareHouse01a" )
			TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL01_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_SL_WareHouse01a" , 0 , "ComEne04" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_IronTurretSL01_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_WareHouse01a" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "Break_IronTurretSL01_Route" , 0 , "ComEne04" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_SeaSideEnter" , 0 , "ComEne05" , "ROUTE_PRIORITY_TYPE_FORCED" )
		if( TppMission.GetFlag( "isWoodTurret03_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_EastCamp_North" )
			TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret03_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_SL_EastCamp_North" , 0 , "ComEne06" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_WoodTurret03_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_EastCamp_North" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "Break_WoodTurret03_Route" , 0 , "ComEne06" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_WareHouseBehind" , 0 , "ComEne07" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_EastCampCenter_East" , 0 , "ComEne08" , "ROUTE_PRIORITY_TYPE_FORCED" )
		-- ComEne09&ComEne10 はパス回収デモで分岐なのでココには書かない
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_EastCamp_NorthLeftGate" , 0 , "ComEne11" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_WareHouse_NorthGate" , 0 , "ComEne12" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_WareHouseKeeper01" , 0 , "ComEne13" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_WareHouseKeeper02" , 0 , "ComEne14" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_HeliPortFrontGate_a" , 0 , "ComEne15" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_HeliPortFrontGate_b" , 0 , "ComEne16" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Bridge_3" , 0 , "ComEne17" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_HeliPortBehind_a" , 0 , "ComEne18" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_HeliPort_Outline02" , 0 , "ComEne19" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_HeliPortHouse" , 0 , "ComEne20" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_HeliPortCenter_a" , 0 , "ComEne21" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_HeliPortCenter_b" , 0 , "ComEne22" , "ROUTE_PRIORITY_TYPE_FORCED" )
		if( TppMission.GetFlag( "isIronTurretSL04_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_HeliPortTurret02" )
			TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL04_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_SL_HeliPortTurret02" , 0 , "ComEne23" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_IronTurretSL04_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_HeliPortTurret02" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "Break_IronTurretSL04_Route" , 0 , "ComEne23" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_HeliPortGateSide" , 0 , "ComEne30" , "ROUTE_PRIORITY_TYPE_FORCED" )
		if( TppMission.GetFlag( "isWoodTurret02_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_EastCamp_South_in" )
			TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret02_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_SL_EastCamp_South_in" , 0 , "ComEne33" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_WoodTurret02_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_EastCamp_South_in" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "Break_WoodTurret02_Route" , 0 , "ComEne33" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		if( TppMission.GetFlag( "isCenterTowerSL_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_HeliPortTower" )
			TppEnemy.DisableRoute( this.cpID , "Break_CenterTower_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_SL_HeliPortTower" , 0 , "ComEne34" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_CenterTower_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_HeliPortTower" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "Break_CenterTower_Route" ,0 , "ComEne34" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Mov_CenterHouse_a2" , 0 , "Seq10_06" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Mov_CenterHouse_b2" , 0 , "Seq10_07" , "ROUTE_PRIORITY_TYPE_FORCED" )

		--停電中か否か
		if ( LightState == 2 ) then		--停電中
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "ComEne24_RouteChange", false , false )
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq40_ComEne27_RouteChange", false , false )
			TppEnemy.EnableRoute( this.cpID , "ComEne24_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne25_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne26_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne27_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne28_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne29_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF_v2" )
			TppEnemy.EnableRoute( this.cpID , "ComEne32_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortBigGate" )
			TppEnemy.DisableRoute( this.cpID , "GoToCenterB_2F_02" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_a" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterBack" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterBack" )
			TppEnemy.DisableRoute( this.cpID , "S_GoTo_BoilarFront" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_Middle2" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_Middle" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne24_SwitchOFF" , 0 , "ComEne24" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne25_SwitchOFF" , 0 , "ComEne25" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne26_SwitchOFF" , 0 , "ComEne26" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne27_SwitchOFF" , 0 , "ComEne27" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne28_SwitchOFF" , 0 , "ComEne28" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne29_SwitchOFF" , 0 , "ComEne29" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne31_SwitchOFF_v2" , 0 , "ComEne31" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne32_SwitchOFF" , 0 , "ComEne32" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBigGate" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_a" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_CenterBack" )
			TppEnemy.EnableRoute( this.cpID , "S_Mov_Smoking_Center" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_e" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_Middle2" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_Middle" )
			TppEnemy.DisableRoute( this.cpID , "ComEne24_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne25_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne26_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne27_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne28_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne29_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF_v2" )
			TppEnemy.DisableRoute( this.cpID , "ComEne32_SwitchOFF" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_HeliPortBigGate" , -1 , "ComEne24" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Center_d" , -1 , "ComEne25" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Center_a" , -1 , "ComEne26" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_CenterBack" , -1 , "ComEne27" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Mov_Smoking_Center" , -1 , "ComEne28" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Center_e" , -1 , "ComEne29" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Boilar_Middle2" , -1 , "ComEne31" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Boilar_Middle" , -1 , "ComEne32" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		--パス回収デモを見たか見てないか？
		if( TppMission.GetFlag( "isQuestionPaz" ) == true ) then				--パス回収デモを見る
			--チコパス回収デモ後チェックポイント復帰処理
			ChicoPazQustionDemoAfterReStart()
			TppMarkerSystem.DisableMarker{ markerId = "20010_marker_RV" }		-- 海岸ＲＶを消す

			if( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then
				commonUiMissionSubGoalNo(1)	--中間目標設定
			else
				commonUiMissionSubGoalNo(7)	--中間目標設定
			end
			--パス回収後、専用ルート設定
			TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide_To_Asylum01" ) 					--ルート有効
			TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide_To_Asylum02" ) 					--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Sen_AsylumOutSideGate_a" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_AsylumOutSideGate_b" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Pat_SeaSide_To_Asylum01" , 0 , "ComEne09" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Pat_SeaSide_To_Asylum02" , 0 , "ComEne10" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else															--パス回収デモを見ていない
			--シーケンスセーブ
			TppMissionManager.SaveGame("30")
			if( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then
				commonUiMissionSubGoalNo(1)	--中間目標設定
			else
				commonUiMissionSubGoalNo(6)	--中間目標設定
			end
			--増員アナウンス
			AnounceLog_enemyReplacement()
			--マーカー処理
			Paz_MarkerON()				--パスマーカーＯＮ
			Asylum_MarkerON()			--旧収容施設マーカー
			RV_MarkerON()				--海岸ＲＶ表示
			TppMarkerSystem.DisableMarker{ markerId = "20010_marker_Paz" }
			TppMarkerSystem.DisableMarker{ markerId = "Marker_Duct" }			--ダクト位置を消す
			--パス回収前、専用ルート設定
			TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_a" ) 					--ルート有効
			TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_b" ) 					--ルート有効
			TppEnemy.EnableRoute( this.cpID , "Seq40_03_PreRideOnVehicle" ) 					--ルート有効
			TppEnemy.EnableRoute( this.cpID , "Seq40_04_PreRideOnVehicle" ) 						--ルート有効
			TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide_To_Asylum01" )
			TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide_To_Asylum02" )
			TppEnemy.DisableRoute( this.cpID , "Seq40_03_RideOnVehicle" )
			TppEnemy.DisableRoute( this.cpID , "Seq40_04_RideOnVehicle" )
			TppEnemy.DisableRoute( this.cpID , "S_Pat_Asylum_OutSideAround" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_AsylumBehind" )
			TppEnemy.DisableRoute( this.cpID , "GoTo_AsylumInside01a" )
			TppEnemy.DisableRoute( this.cpID , "GoTo_AsylumInside02b" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_AsylumOutSideGate_c" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_AsylumOutSideGate_b" , -1 , "ComEne09" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_AsylumOutSideGate_a" , -1 , "ComEne10" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "Seq40_03_PreRideOnVehicle" , -1 , "Seq40_03" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "Seq40_04_PreRideOnVehicle" , -1 , "Seq40_04" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		--諜報無線セット
		SetIntelRadio()
		--任意無線設定
		SetOptionalRadio()

	end,
	-- ビークル、旧収容施設に到着
	GoToAsylum_End = function()
		local VehicleGroupInfo			= TppData.GetArgument(2)
		local VehicleGroupInfoName		= VehicleGroupInfo.routeInfoName
		local VehicleGroupResult		= VehicleGroupInfo.result
		local VehicleGroupReason		= VehicleGroupInfo.reason
		if( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Seq40_0304" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				TppMission.SetFlag( "isSeq40_0304_DriveEnd" , 2 )
			else		-- 車輌失敗判定
			end
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq40_03" , false )
			TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq40_04" , false )
			--VIPとお供ルートチェンジ
			TppEnemy.EnableRoute( this.cpID , "GoTo_AsylumInside01a" )
			TppEnemy.EnableRoute( this.cpID , "GoTo_AsylumInside02b" )
			TppEnemy.ChangeRoute( this.cpID , "Seq40_03","e20010_Seq40_SneakRouteSet","GoTo_AsylumInside01a", 0 )
			TppEnemy.ChangeRoute( this.cpID , "Seq40_04","e20010_Seq40_SneakRouteSet","GoTo_AsylumInside02b", 0 )
		else
		end
	end,
	--ComEne09ノードアクション
	ComEne09_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Pat_SeaSide_To_Asylum01" )) then
			if( RoutePointNumber == 12 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_b" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide_To_Asylum01" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne09","e20010_Seq40_SneakRouteSet","S_Sen_AsylumOutSideGate_b", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne10ノードアクション
	ComEne10_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Pat_SeaSide_To_Asylum02" )) then
			if( RoutePointNumber == 16 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_a" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Pat_SeaSide_To_Asylum02" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne10","e20010_Seq40_SneakRouteSet","S_Sen_AsylumOutSideGate_a", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne18ノードアクション
	ComEne18_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_HeliPort_2manSeparate02" )) then
			if( RoutePointNumber == 12 ) then
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate01" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq40_SneakRouteSet","S_HeliPort_2mancell_back", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2manSeparate02" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq40_SneakRouteSet","S_HeliPort_2mancell_back", 0 )	--指定敵兵ルートチェンジ
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "S_HeliPort_2mancell_back" )) then
			if( RoutePointNumber == 6 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBehind_a" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBehind_b" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_back" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq40_SneakRouteSet","S_Sen_HeliPortBehind_a", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq40_SneakRouteSet","S_Sen_HeliPortBehind_b", 0 )	--指定敵兵ルートチェンジ	--指定敵兵ルートチェンジ
			else
			end
		end
	end,
	--ComEne19ノードアクション
	ComEne19_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Sen_HeliPortBehind_b" )) then
			if( RoutePointNumber == 4 ) then
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortBehind_b" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq40_SneakRouteSet","S_HeliPort_2mancell_go", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortBehind_a" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq40_SneakRouteSet","S_HeliPort_2mancell_go", 0 )	--指定敵兵ルートチェンジ
			else
			end
		elseif ( RouteName ==  GsRoute.GetRouteId( "S_HeliPort_2mancell_go" )) then
			if( RoutePointNumber == 9 ) then
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2manSeparate01" ) 	--ルート有効
				TppEnemy.EnableRoute( this.cpID , "S_HeliPort_2manSeparate02" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート無効
				TppEnemy.DisableRoute( this.cpID , "S_HeliPort_2mancell_go" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne18","e20010_Seq40_SneakRouteSet","S_HeliPort_2manSeparate02", 0 )	--指定敵兵ルートチェンジ
				TppEnemy.ChangeRoute( this.cpID , "ComEne19","e20010_Seq40_SneakRouteSet","S_HeliPort_2manSeparate01", 0 )	--指定敵兵ルートチェンジ
			else
			end
		end
	end,
	--ComEne24ノードアクション
	ComEne24_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "GoToCenterB_2F_02" )) then
			if( RoutePointNumber == 4 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_CenterB_2F" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "GoToCenterB_2F_02" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne24","e20010_Seq40_SneakRouteSet","S_Sen_CenterB_2F", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne27ノードアクション
	ComEne27_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_GoTo_BoilarFront" )) then
			if( RoutePointNumber == 3 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_BoilarFront" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "S_GoTo_BoilarFront" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq40_SneakRouteSet","S_Sen_BoilarFront", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	--ComEne30ノードアクション
	ComEne30_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "GoToCenterB_Door" )) then
			if( RoutePointNumber == 5 ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_CenterBehind_a" ) 	--ルート有効
				TppEnemy.DisableRoute( this.cpID , "GoToCenterB_Door" ) 	--ルート無効
				TppEnemy.ChangeRoute( this.cpID , "ComEne30","e20010_Seq40_SneakRouteSet","S_Sen_CenterBehind_a", 0 )	--指定敵兵ルートチェンジ
			else
			end
		else
		end
	end,
	-- Seq40_01ノードアクション
	Seq40_01_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "Seq40_PazCheck01" )) then
			if( RoutePointNumber == 10 ) then										--ノードを通過した時
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_a" )
				TppEnemy.DisableRoute( this.cpID , "Seq40_PazCheck01" )
				TppEnemy.ChangeRoute( this.cpID , "Seq40_01","e20010_Seq40_SneakRouteSet","S_Sen_Boilar_a", 0 )
			else
			end
		else
		end
	end,
	-- Seq40_02ノードアクション
	Seq40_02_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "Seq40_PazCheck02" )) then
			if( RoutePointNumber == 23 ) then										--ノードを通過した時
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_c" )
				TppEnemy.DisableRoute( this.cpID , "Seq40_PazCheck02" )
				TppEnemy.ChangeRoute( this.cpID , "Seq40_02","e20010_Seq40_SneakRouteSet","S_Sen_Center_c", 0 )
			else
			end
		else
		end
	end,
	-- Seq40_03ノードアクション
	Seq40_03_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "GoTo_AsylumInside01a" )) then
			if( RoutePointNumber == 26 ) then										--ノードを通過した時
				TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_c" )
				TppEnemy.DisableRoute( this.cpID , "GoTo_AsylumInside01a" )
				TppEnemy.ChangeRoute( this.cpID , "Seq40_03","e20010_Seq40_SneakRouteSet","S_Sen_AsylumOutSideGate_c", 0 )
			else
			end
		else
		end
	end,
	-- Seq40_08ノードアクション
	Seq40_08_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)

		if ( RouteName ==  GsRoute.GetRouteId( "ArmorVehicle_onRaid_Seq40_08_02" )) then
			if( RoutePointNumber == 13 ) then
				TppMission.SetFlag( "isArmorVehicle_Start" , 2 )
				TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_002" , "ArmorVehicle_WareHouseWait" , -1 )
			else
			end
		else
		end
	end,
	--ヘリポートから来る敵兵
	ComEne24_RouteChange = function()
		TppEnemy.EnableRoute( this.cpID , "GoToCenterB_2F_02" ) 	--ルート有効
		TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortBigGate" )	--ルート無効
		TppEnemy.ChangeRoute( this.cpID , "ComEne24","e20010_Seq40_SneakRouteSet","GoToCenterB_2F_02", 0 )	--指定敵兵ルートチェンジ
	end,
	--ComEne27ルートチェンジ
	Seq40_ComEne27_RouteChange = function()
		TppEnemy.EnableRoute( this.cpID , "S_GoTo_BoilarFront" ) 	--ルート有効
		TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterB_Stair" )	--ルート無効
		TppEnemy.ChangeRoute( this.cpID , "ComEne27","e20010_Seq40_SneakRouteSet","S_GoTo_BoilarFront", 0 )	--指定敵兵ルートチェンジ
	end,
	--旧収容施設に向かう敵兵スタート
	toAsylumGroupStart = function()
		TppEnemy.EnableRoute( this.cpID , "Seq40_03_RideOnVehicle" ) 	--ルート有効
		TppEnemy.EnableRoute( this.cpID , "Seq40_04_RideOnVehicle" ) 	--ルート有効
		TppEnemy.DisableRoute( this.cpID , "Seq40_03_PreRideOnVehicle" )	--ルート無効
		TppEnemy.DisableRoute( this.cpID , "Seq40_04_PreRideOnVehicle" )	--ルート無効
		TppEnemy.ChangeRoute( this.cpID , "Seq40_03","e20010_Seq40_SneakRouteSet","Seq40_03_RideOnVehicle", 0 )	--指定敵兵ルートチェンジ
		TppEnemy.ChangeRoute( this.cpID , "Seq40_04","e20010_Seq40_SneakRouteSet","Seq40_04_RideOnVehicle", 0 )	--指定敵兵ルートチェンジ
	end,
	--機銃装甲車出動
	Seq40_ArmorVehicle_Start = function()
		TppMission.SetFlag( "isArmorVehicle_Start" , 1 )
		TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_002" , "ArmorVehicle_onRaid_Seq40_08_02" , -1 )
	end,
	--海岸ＲＶに近づいた
	Radio_NearRV = function()
		if( TppMission.GetFlag( "isQuestionPaz" ) == false ) then		--パス回収デモを見ていない
			if( TppPlayerUtility.IsCarriedCharacter( "Paz" )) then		--パスを担いでいる
				TppRadio.DelayPlayEnqueue( "Miller_NearRV", "short" )
			else													--パスを担いでいない
			end
		else														--パス回収デモを見ている
		end
	end,
	--海岸ＲＶに到着
	Radio_ArriveRV = function()
		if( TppMission.GetFlag( "isQuestionPaz" ) == false ) then		--パス回収デモを見ていない
			if( TppPlayerUtility.IsCarriedCharacter( "Paz" )) then		--パスを担いでいる
				if( TppMission.GetFlag( "isHeliComingRV" ) == false ) then
					TppRadio.Play( "Miller_ArriveRV", {onStart = function() SetOptionalRadio() end} )
				else
				end
				TppRadio.RegisterOptionalRadio( "Optional_DiscoveryPaz" )			--0025
				TppMarkerSystem.DisableMarker{ markerId = "20010_marker_RV" }
			else													--パスを担いでいない
			end
		else														--パス回収デモを見ている
		end
	end,

	--パス回収デモ開始前チェック
	Seq_QuestionPazDemo_OnlyOnce = function()
		Fox.Log(":: check Seq_QuestionPazDemo_OnlyOnce ::")

		-- ヘリに乗せられたかチェック
		local status = TppHostageUtility.GetStatus( "Paz" )
		Fox.Log( "paz is "..status )
		if( status == "RideOnHelicopter" )then
			-- ヘリに乗ったときはデモを再生させない
			Fox.Log(" no play demo. becouse paz ride on heli")
			return
		end


		if( CheckDemoCondition() == true
		and TppMission.GetFlag( "isHeliComeToSea" ) == false
--[[		and TppMission.GetFlag( "isSaftyArea02" ) == false
		and TppMission.GetFlag( "isSaftyArea03" ) == false
		and TppMission.GetFlag( "isSaftyArea04" ) == false ]]
		 ) then				--安全エリアにいる
			if( TppMission.GetFlag( "isQuestionPaz" ) == false ) then		--パス回収デモを見ていない
				TppSequence.ChangeSequence( "Seq_QuestionPazDemo" )
			else														--パス回収デモを見ている
			end
		elseif( Check_SafetyArea() == true
--[[		and TppMission.GetFlag( "isSaftyArea02" ) == false
		and TppMission.GetFlag( "isSaftyArea03" ) == false
		and TppMission.GetFlag( "isSaftyArea04" ) == false
		and TppMission.GetFlag( "isHeliComeToSea" ) == false ]]) then				--安全エリアにいる
			if( TppMission.GetFlag( "isQuestionPaz" ) == false ) then		--パス回収デモを見ていない
				TppMission.SetFlag( "isPazChicoDemoArea", true )
			end
		elseif( TppMission.GetFlag( "isDangerArea" ) == true ) then			--危険エリアにいる
			local timer = 0.5
			GkEventTimerManager.Start( "Timer_CarryDownInDanger", timer )
		--	TppRadio.DelayPlayEnqueue("Miller_CarryDownInDanger", "short")
		end
	end,

	-- チコ・パスに会うデモチェック
	Seq_RescueDemo_OnlyOnce = function()
		--フェイズチェック
		--敵兵チェック
			-- どの扉かのチェック
			if( (TppData.GetArgument( 1 ) == "AsyPickingDoor24" )) then
				--回収デモ促し無線用フラグをリセットしておく
				TppMission.SetFlag( "isPazChicoDemoArea", false )

				TppSequence.ChangeSequence( "Seq_RescueChicoDemo02" )
			end
	end,
}
-----------------------------------------------------------------------------------------------------------------
--チコパス順で２人をヘリに乗せるまで
-----------------------------------------------------------------------------------------------------------------
this.Seq_ChicoPazToRV = {

	Messages = {
		Character = {
			{ data = "gntn_cp", message = "EndGroupVehicleRouteMove", localFunc = "Seq30_EnterCenterTruck" },
			{ data = "gntn_cp", message = "ConversationEnd", localFunc = "local_Seq30_ConversationEnd" },
			{ data = "Seq30_01", message = "MessageRoutePoint", localFunc = "Seq30_01_NodeAction" },
			{ data = "Seq30_02", message = "MessageRoutePoint", localFunc = "Seq30_02_NodeAction" },
			{ data = "Seq30_03", message = "MessageRoutePoint", localFunc = "Seq30_03_NodeAction" },
			{ data = "Seq30_04", message = "MessageRoutePoint", localFunc = "Seq30_04_NodeAction" },
			{ data = "Seq30_11", message = "MessageRoutePoint", localFunc = "Seq30_11_NodeAction" },
		},
		Trap = {
			myMessages.Trap[9],
--			myMessages.Trap[4],
			{ data = "Seq30_ArmorVehicle_Start", message = "Enter", localFunc = "Seq30_ArmorVehicle_Start" },
			{ data = "Seq30_02_RouteChange", message = "Enter", localFunc = "Seq30_02_RouteChange" },
			{ data = "Radio_CallHeliAdvice", message = "Enter", localFunc = "Radio_CallHeliAdvice" },
		},
	},

	OnEnter = function( manager )
		local LightState	= TppGadgetManager.GetGadgetStatus( "gntn_center_SwitchLight" )
		--雨さえぎりOFF
		WoodTurret_RainFilter_OFF()
		--強制リアライズ解除
		TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( this.cpID , "S_Sen_HeliPortFrontGate_a" , false )
		TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( this.cpID , "S_Sen_HeliPortFrontGate_b" , false )
		--達成済み写真のチェック
		SetComplatePhoto()
		--先チコ？
		TppMission.SetFlag( "isFirstEncount_Chico", true )
		--カセットテープ５を消す
		TppPickableManager.DisableByLocator( "tp_chico_05" )
		-- デフォルトランディングゾーン設定
		TppSupportHelicopterService.SetDefaultRendezvousPointMarker("no_lz")
		--シーケンスセーブ
		TppMissionManager.SaveGame("30")
		--中間目標設定
		commonUiMissionSubGoalNo(7)
		--増員アナウンスログ
		AnounceLog_enemyReplacement()
		--天候設定
		WeatherManager.RequestWeather(2,0)
		--トラップEnable/Disable
		Seq10Trap_Disable()
		Seq10_20Trap_Disable()
		Seq20Trap_Disable()
		Seq30Trap_Enable()
		Seq40Trap_Disable()
		--管理棟巨大ゲートデフォルトオープン
		Common_CenterBigGate_DefaultOpen()
		-- パスのモーションをつながれにする
		ChengeChicoPazIdleMotion()
		-- パス救出 脱出曲へ変更
		TppMusicManager.ChangeParameter( 'bgm_paz_escape' )
		--ミッション圏外処理
		All_Seq_MissionAreaOut()
		-- チコパス扉設定
		ChicoDoor_ON_Open()
		PazDoor_ON_Open()
		--マーカー処理
		Chico_MarkerON()			--チコマーカーＯＮ
		Paz_MarkerON()				--パスマーカーＯＮ
		TppMarkerSystem.DisableMarker{ markerId = "20010_marker_Chico" }
		TppMarkerSystem.DisableMarker{ markerId = "20010_marker_ChicoPinpoint" }
		TppMarkerSystem.DisableMarker{ markerId = "Marker_Duct" }
		TppMarkerSystem.DisableMarker{ markerId = "20010_marker_Paz" }
		TppMarkerSystem.DisableMarker{ markerId = "20010_marker_RV" }
		--無線処理
		SetIntelRadio()
		--任意無線設定
		SetOptionalRadio()
		--共通処理：キャラDisable
		TppEnemyUtility.SetEnableCharacterId( "ComEne08" , false )
		TppEnemyUtility.SetEnableCharacterId( "ComEne30" , false )
		--敵兵Disable/Enable
		Seq10Enemy_Disable()
		Seq20Enemy_Disable()
		Seq30Enemy_Enable()
		Seq40Enemy_Disable()
		--先チコ車輌設定（後半）
		FirstChico_Vehicle_02()
		--リトライ時サイレン処理
		Common_RetryKeepCautionSiren()
		--ガードターゲット設定
		GuardTarget_Setting()
		--ルートセット設定
		Seq_ChicoPazToRV_RouteSet()
		--初期ルート有効
		TppEnemy.EnableRoute( this.cpID , "GoToCenter_BigGate" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_CenterB_PreTalk" )
		TppEnemy.EnableRoute( this.cpID , "S_Pre_PazCheck_Vip" )
		TppEnemy.EnableRoute( this.cpID , "S_Pre_PazCheck" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_EastCamp_SouthLeftGate" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_WestCampRoom" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_a" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_b" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_EastCamp_NorthLeftGate" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouse_NorthGate" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouseKeeper01" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouseKeeper02" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortFrontGate_a2" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortFrontGate_b2" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Bridge_3" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBehind_a" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortBehind_b" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortCenter_a" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortCenter_b" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_PreTalk" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortHouse" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_SeaSideEnter02" )
		TppEnemy.EnableRoute( this.cpID , "S_SL_WareHouse02a" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_WareHouseBehind" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_SeaSideEnter03" )
		TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide01b" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_SeasideNearBox" )
		TppEnemy.EnableRoute( this.cpID , "S_Pat_SeaSide" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPort_FrontGate01" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPort_FrontGate02" )
		TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_c" )
		--初期無効ルート
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_BigGate" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterB_2F" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortGateSide" )
		TppEnemy.DisableRoute( this.cpID , "GoTo_PazCheck_vip" )
		TppEnemy.DisableRoute( this.cpID , "GoTo_PazCheck" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_Middle" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterB_TalkAfter" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_a" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_b" )
		TppEnemy.DisableRoute( this.cpID , "Seq30_05_RideOnVehicle" )
		TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret01_Route" )
		TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret05_Route" )
		TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL02_Route" )

		--停電中か否か
		if ( LightState == 2 ) then		--停電中
			TppEnemy.EnableRoute( this.cpID , "ComEne25_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne26_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne27_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne28_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne29_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF_v3" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_a" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_BoilarFront" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_b" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_e" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_f" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "ComEne25_SwitchOFF" , -1 , "ComEne25" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "ComEne26_SwitchOFF" , -1 , "ComEne26" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "ComEne27_SwitchOFF" , -1 , "ComEne27" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "ComEne28_SwitchOFF" , -1 , "ComEne28" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "ComEne29_SwitchOFF" , -1 , "ComEne29" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "ComEne31_SwitchOFF_v3" , -1 , "ComEne31" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_a" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_BoilarFront" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_b" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_e" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_f" )
			TppEnemy.DisableRoute( this.cpID , "ComEne25_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne26_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne27_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne28_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne29_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF_v3" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_Center_d" , -1 , "ComEne25" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_Center_a" , -1 , "ComEne26" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_BoilarFront" , -1 , "ComEne27" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_Center_b" , -1 , "ComEne28" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_Center_e" , -1 , "ComEne29" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_Center_f" , -1 , "ComEne31" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		--敵兵専用ルート設定
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "GoToCenter_BigGate" , -1 , "Seq30_01" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_CenterB_PreTalk" , -1 , "Seq30_02" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Pre_PazCheck_Vip" , -1 , "Seq30_03" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Pre_PazCheck" , -1 , "Seq30_04" , "ROUTE_PRIORITY_TYPE_FORCED" )
		--Seq30_05,06は最初から車輌に乗っているのでココには書かない
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Pat_SeaSide01b" , -1 , "Seq30_07" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_SeasideNearBox" , -1 , "Seq30_08" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Pat_SeaSide" , -1 , "Seq30_09" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_SeaSideEnter03" , -1 , "Seq30_10" , "ROUTE_PRIORITY_TYPE_FORCED" )
		--Seq30_11は最初から車輌に乗っているのでココには書かない
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_EastCamp_SouthLeftGate" , -1 , "ComEne01" , "ROUTE_PRIORITY_TYPE_FORCED" )
		if( TppMission.GetFlag( "isWoodTurret04_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_WestCamp" )
			TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret04_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_SL_WestCamp" , -1 , "ComEne02" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_WoodTurret04_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_WestCamp" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "Break_WoodTurret04_Route" , -1 , "ComEne02" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_WestCampRoom" , -1 , "ComEne03" , "ROUTE_PRIORITY_TYPE_FORCED" )
		if( TppMission.GetFlag( "isIronTurretSL01_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_WareHouse01a" )
			TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL01_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_SL_WareHouse01a" , -1 , "ComEne04" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_IronTurretSL01_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_WareHouse01a" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "Break_IronTurretSL01_Route" , -1 , "ComEne04" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_SeaSideEnter02" , -1 , "ComEne05" , "ROUTE_PRIORITY_TYPE_FORCED" )
		if( TppMission.GetFlag( "isWoodTurret03_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_EastCamp_North" )
			TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret03_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_SL_EastCamp_North" , -1 , "ComEne06" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_WoodTurret03_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_EastCamp_North" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "Break_WoodTurret03_Route" , -1 , "ComEne06" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_WareHouseBehind" , -1 , "ComEne07" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_AsylumOutSideGate_a" , -1 , "ComEne09" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_AsylumOutSideGate_b" , -1 , "ComEne10" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_EastCamp_NorthLeftGate" , -1 , "ComEne11" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_WareHouse_NorthGate" , -1 , "ComEne12" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_WareHouseKeeper01" , -1 , "ComEne13" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_WareHouseKeeper02" , -1 , "ComEne14" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_HeliPortFrontGate_a2" , -1 , "ComEne15" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_HeliPortFrontGate_b2" , -1 , "ComEne16" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_Bridge_3" , -1 , "ComEne17" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_HeliPortBehind_a" , -1 , "ComEne18" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_SL_WareHouse02a" , -1 , "ComEne19" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_HeliPortHouse" , -1 , "ComEne20" , "ROUTE_PRIORITY_TYPE_FORCED" )
		if( TppMission.GetFlag( "isIronTurretSL04_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_HeliPortTurret02" )
			TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL04_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_SL_HeliPortTurret02" , -1 , "ComEne21" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_IronTurretSL04_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_HeliPortTurret02" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "Break_IronTurretSL04_Route" , -1 , "ComEne21" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		if( TppMission.GetFlag( "isIronTurretSL05_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_HeliPortTurret01" )
			TppEnemy.DisableRoute( this.cpID , "Break_IronTurretSL05_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_SL_HeliPortTurret01" , -1 , "ComEne22" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_IronTurretSL05_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_HeliPortTurret01" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "Break_IronTurretSL05_Route" , -1 , "ComEne22" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_HeliPort_FrontGate01" , -1 , "ComEne23" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_HeliPort_FrontGate02" , -1 , "ComEne24" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_Sen_Boilar_PreTalk" , -1 , "ComEne32" , "ROUTE_PRIORITY_TYPE_FORCED" )
		if( TppMission.GetFlag( "isWoodTurret02_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_EastCamp_South_in" )
			TppEnemy.DisableRoute( this.cpID , "Break_WoodTurret02_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_SL_EastCamp_South_in" , -1 , "ComEne33" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_WoodTurret02_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_EastCamp_South_in" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "Break_WoodTurret02_Route" , -1 , "ComEne33" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		if( TppMission.GetFlag( "isCenterTowerSL_Break" ) == false ) then
			TppEnemy.EnableRoute( this.cpID , "S_SL_HeliPortTower" )
			TppEnemy.DisableRoute( this.cpID , "Break_CenterTower_Route" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_SL_HeliPortTower" , -1 , "ComEne34" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "Break_CenterTower_Route" )
			TppEnemy.DisableRoute( this.cpID , "S_SL_HeliPortTower" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq30_SneakRouteSet" , "S_SL_HeliPortTower" , -1 , "ComEne34" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		--敵兵強制リアライズ
		TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( this.cpID , "GoTo_PazCheck_vip" , true )
		-- 脱走捕虜Disable
		SpHostage_Disable()
	end,

	Seq30_EnterCenterTruck= function()

		local VehicleGroupInfo			= TppData.GetArgument(2)
		local VehicleGroupInfoName		= VehicleGroupInfo.routeInfoName
		local VehicleGroupResult		= VehicleGroupInfo.result
		local VehicleGroupReason		= VehicleGroupInfo.reason

		if( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Seq30_05" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				--降車が無いので無し
			else	-- 失敗
				TppCommandPostObject.GsSetRealizeFirstPriority( this.cpID , "Seq30_05" , false )
				TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_c" )
				TppEnemy.DisableRoute( this.cpID , "Seq30_05_RideOnVehicle" )
				TppEnemy.ChangeRoute( this.cpID , "Seq30_05","e20010_Seq30_SneakRouteSet","S_Sen_AsylumOutSideGate_c", 0 )
			end
		else
		end
	end,
	--会話終了処理
	local_Seq30_ConversationEnd = function()
		local label		= TppData.GetArgument(2)
		if ( label == "CTE0010_0345") then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_Middle" )
				TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_PreTalk" )
				TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq30_SneakRouteSet","S_Sen_Boilar_Middle", 0 )
				Seq30_PazCheck_Start()	--パス確認敵兵ルートチェンジ
--[[
			if( TppMission.GetFlag( "isPazCheckEnemy_Start" ) == false ) then
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_Middle" )
				TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_PreTalk" )
				TppEnemy.ChangeRoute( this.cpID , "ComEne32","e20010_Seq30_SneakRouteSet","S_Sen_Boilar_Middle", 0 )
				Seq30_PazCheck_Start()	--パス確認敵兵ルートチェンジ
			else
			end
--]]
		elseif ( label == "CTE0010_0050") then
			TppEnemy.EnableRoute( this.cpID , "S_Sen_CenterB_TalkAfter" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterB_PreTalk" )
			TppEnemy.ChangeRoute( this.cpID , "Seq30_02","e20010_Seq30_SneakRouteSet","S_Sen_CenterB_TalkAfter", 0 )
			-- トラップＯＦＦ
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seq30_02_RouteChange", false , false )
		else
		end
	end,
	--Seq30_01ノードアクション
	Seq30_01_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "GoToCenter_BigGate" )) then
			if( RoutePointNumber == 12 ) then										--ノードを通過した時
				TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortGateSide" )
				TppEnemy.DisableRoute( this.cpID , "GoToCenter_BigGate" )
				TppEnemy.ChangeRoute( this.cpID , "Seq30_01","e20010_Seq30_SneakRouteSet","S_Sen_HeliPortGateSide", 0 )
			else
			end
		else
		end
	end,
	--Seq30_02ノードアクション
	Seq30_02_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Sen_CenterB_TalkAfter" )) then
			if( RoutePointNumber == 4 ) then										--ノードを通過した時
				TppEnemy.EnableRoute( this.cpID , "S_Sen_CenterB_2F" )
				TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterB_TalkAfter" )
				TppEnemy.ChangeRoute( this.cpID , "Seq30_02","e20010_Seq30_SneakRouteSet","S_Sen_CenterB_2F", 0 )
			else
			end
		else
		end
	end,
	--Seq30_03ノードアクション
	Seq30_03_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "GoTo_PazCheck_vip" )) then
			if( RoutePointNumber == 18 ) then										--ノードを通過した時
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_a" )
				TppEnemy.DisableRoute( this.cpID , "GoTo_PazCheck_vip" )
				TppEnemy.ChangeRoute( this.cpID , "Seq30_03","e20010_Seq30_SneakRouteSet","S_Sen_Boilar_a", 0 )
			else
			end
		else
		end
	end,
	--Seq30_04ノードアクション
	Seq30_04_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "GoTo_PazCheck" )) then
			if( RoutePointNumber == 18 ) then										--ノードを通過した時
				TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_b" )
				TppEnemy.DisableRoute( this.cpID , "GoTo_PazCheck" )
				TppEnemy.ChangeRoute( this.cpID , "Seq30_04","e20010_Seq30_SneakRouteSet","S_Sen_Boilar_b", 0 )
			else
			end
		else
		end
	end,
	--Seq30_11ノードアクション
	Seq30_11_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)

		if ( RouteName ==  GsRoute.GetRouteId( "ArmorVehicle_onRaid_Seq30_11_2" )) then
			if( RoutePointNumber == 14 ) then
				TppMission.SetFlag( "isArmorVehicle_Start" , 2 )
				TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_003" , "ArmorVehicle_WareHouseWait" , -1 )
			else
			end
		else
		end
	end,
	--機銃装甲車出動
	Seq30_ArmorVehicle_Start = function()
		TppMission.SetFlag( "isArmorVehicle_Start" , 1 )
		TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID , "Armored_Vehicle_WEST_003" , "ArmorVehicle_onRaid_Seq30_11_2" , -1 )
	end,
	--Seq30_02ルートチェンジ
	Seq30_02_RouteChange = function()
		TppEnemy.EnableRoute( this.cpID , "S_Sen_CenterB_TalkAfter" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterB_PreTalk" )
		TppEnemy.ChangeRoute( this.cpID , "Seq30_02","e20010_Seq30_SneakRouteSet","S_Sen_CenterB_TalkAfter", 0 )
	end,
	--ヘリコール促し
	Radio_CallHeliAdvice = function()
		if( TppMission.GetFlag( "isHeliComingRV" ) == false and 				--ヘリが来ていない
			TppPlayerUtility.IsCarriedCharacter( "Paz" ) ) then					--パスを担いでいる
			TppRadio.PlayEnqueue("Miller_CallHeliAdvice")
		end
	end,
}
-----------------------------------------------------------------------------------------------------------------
--パスチコ順で２人目をヘリに乗せるまで
-----------------------------------------------------------------------------------------------------------------
this.Seq_PazChicoToRV = {

	Messages = {
		Character = {
		--	{ data = "Chico", message = "MessageHostageCarriedStart", commonFunc = function() TppRadio.DelayPlayEnqueue( "Miller_TakeChicoOnHeli", "long" ) end },
			{ data = "Chico", message = "MessageHostageCarriedEnd", localFunc = "Seq_CarriedEndChico" },
			{ data = "ComEne34", message = "MessageRoutePoint", localFunc = "ComEne34_NodeAction" },
		},
		Trap = {
--			myMessages.Trap[4],
		},
	},
	OnEnter = function( manager )

		local LightState = TppGadgetManager.GetGadgetStatus( "gntn_center_SwitchLight" )

		--雨さえぎりOFF
		WoodTurret_RainFilter_OFF()
		--達成済み写真のチェック
		SetComplatePhoto()
		--シーケンスセーブ
		TppMissionManager.SaveGame("20")
		--先チコ？
		TppMission.SetFlag( "isFirstEncount_Chico", false )
		--先パス車輌設定
		FirstPaz_Vehicle()
		--カセットテープ５を消す
		TppPickableManager.DisableByLocator( "tp_chico_05" )
		--中間目標設定
		commonUiMissionSubGoalNo(3)
		--増援アナウンス
		AnounceLog_enemyReplacement()
		-- デフォルトランディングゾーン設定
		TppSupportHelicopterService.SetDefaultRendezvousPointMarker("no_lz")
		--ガードターゲット設定
		GuardTarget_Setting()
		--トラップEnable/Disable
		Seq10Trap_Disable()
		Seq10_20Trap_Disable()
		Seq20Trap_Disable()
		Seq30Trap_Disable()
		Seq40Trap_Disable()
		--リトライ時サイレン処理
		Common_RetryKeepCautionSiren()
		--　チコパスのモーション
		ChengeChicoPazIdleMotion()
		--ミッション圏外処理
		All_Seq_MissionAreaOut()
		--BGM変更
		TppMusicManager.ChangeParameter( 'bgm_paz_escape' )
		--天候設定
		WeatherManager.RequestWeather(2,0)
		--管理棟巨大ゲートデフォルトオープン
		Common_CenterBigGate_DefaultOpen()
		--マーカー処理
		Chico_MarkerON()		--チコマーカーＯＮ
		Paz_MarkerON()			--パスマーカーＯＮ
		TppMarkerSystem.DisableMarker{ markerId = "20010_marker_Paz" }
		TppMarkerSystem.DisableMarker{ markerId = "Marker_Duct" }
		TppMarkerSystem.DisableMarker{ markerId = "20010_marker_Chico" }
		TppMarkerSystem.DisableMarker{ markerId = "20010_marker_ChicoPinpoint" }
		TppMarkerSystem.DisableMarker{ markerId = "20010_marker_RV" }
		--無線処理
		SetIntelRadio()
		--任意無線設定
		SetOptionalRadio()
		-- チコパス扉設定
		ChicoDoor_ON_Open()
		PazDoor_ON_Open()
		--敵兵Disable/Enable
		Seq10Enemy_Disable_Ver2()
		Seq20Enemy_Disable()
		Seq30Enemy_Disable()
		Seq40Enemy_Enable()
		--ルートセット設定
		Seq_PazChicoToRV_RouteSet()
		--ComEne17
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Bridge" )
		TppEnemy.DisableRoute( this.cpID , "S_Sen_Bridge_3" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Bridge" , 0 , "ComEne17" , "ROUTE_PRIORITY_TYPE_FORCED" )
		--ComEne34
		TppEnemy.EnableRoute( this.cpID , "S_Pat_FinalPazCheck" )
		TppEnemy.DisableRoute( this.cpID , "S_SL_HeliPortTower" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Pat_FinalPazCheck" , 0 , "ComEne34" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( this.cpID , "S_Pat_FinalPazCheck" , true )
		--Seq40_01
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_a" )
		TppEnemy.DisableRoute( this.cpID , "Seq40_PazCheck01" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Boilar_a" , 0 , "Seq40_01" , "ROUTE_PRIORITY_TYPE_FORCED" )
		--Seq40_02
		TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_c" )
		TppEnemy.DisableRoute( this.cpID , "Seq40_PazCheck02" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Center_c" , 0 , "Seq40_02" , "ROUTE_PRIORITY_TYPE_FORCED" )
		--Seq40_03
		TppEnemy.EnableRoute( this.cpID , "S_Sen_AsylumOutSideGate_c" )
		TppEnemy.DisableRoute( this.cpID , "Seq40_03_PreRideOnVehicle" )
		TppEnemy.DisableRoute( this.cpID , "Seq40_03_RideOnVehicle" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_AsylumOutSideGate_c" , 0 , "Seq40_03" , "ROUTE_PRIORITY_TYPE_FORCED" )
		--Seq40_04
		TppEnemy.EnableRoute( this.cpID , "GoTo_AsylumInside02b" )
		TppEnemy.DisableRoute( this.cpID , "Seq40_04_RideOnVehicle" )
		TppEnemy.DisableRoute( this.cpID , "Seq40_04_PreRideOnVehicle" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "GoTo_AsylumInside02b" , 0 , "Seq40_04" , "ROUTE_PRIORITY_TYPE_FORCED" )

		--停電中か否か
		if ( LightState == 2 ) then		--停電中
			TppEnemy.EnableRoute( this.cpID , "ComEne24_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne25_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne26_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne27_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne28_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne29_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne31_SwitchOFF" )
			TppEnemy.EnableRoute( this.cpID , "ComEne32_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_CenterB_2F" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_d" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_a" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_BoilarFront" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_b" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Center_e" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_Middle2" )
			TppEnemy.DisableRoute( this.cpID , "S_Sen_Boilar_Middle" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne24_SwitchOFF" , 0 , "ComEne24" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne25_SwitchOFF" , 0 , "ComEne25" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne26_SwitchOFF" , 0 , "ComEne26" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne27_SwitchOFF" , 0 , "ComEne27" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne28_SwitchOFF" , 0 , "ComEne28" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne29_SwitchOFF" , 0 , "ComEne29" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne31_SwitchOFF" , 0 , "ComEne31" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "ComEne32_SwitchOFF" , 0 , "ComEne32" , "ROUTE_PRIORITY_TYPE_FORCED" )
		else
			TppEnemy.EnableRoute( this.cpID , "S_Sen_CenterB_2F" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_d" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_a" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_BoilarFront" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_b" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Center_e" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_Middle2" )
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Boilar_Middle" )
			TppEnemy.DisableRoute( this.cpID , "ComEne24_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne25_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne26_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne27_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne28_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne29_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF" )
			TppEnemy.DisableRoute( this.cpID , "ComEne31_SwitchOFF_v2" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_CenterB_2F" , 0 , "ComEne24" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Center_d" , 0 , "ComEne25" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Center_a" , 0 , "ComEne26" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_BoilarFront" , 0 , "ComEne27" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Center_b" , 0 , "ComEne28" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Center_e" , 0 , "ComEne29" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Boilar_Middle2" , 0 , "ComEne31" , "ROUTE_PRIORITY_TYPE_FORCED" )
			TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq40_SneakRouteSet" , "S_Sen_Boilar_Middle" , 0 , "ComEne32" , "ROUTE_PRIORITY_TYPE_FORCED" )
		end
		-- 脱走捕虜Disabl
		SpHostage_Disable()
	end,

	--
	Seq_CarriedEndChico = function()
		if( CheckDemoCondition() == true
--[[		and TppMission.GetFlag( "isSaftyArea02" ) == false
		and TppMission.GetFlag( "isSaftyArea03" ) == false
		and TppMission.GetFlag( "isSaftyArea04" ) == false ]]
		and TppMission.GetFlag( "isHeliComingRV" ) == false ) then	--安全エリアにいる -- 管理棟内ははぶく
			TppRadio.Play("Miller_PazChicoCarriedEndRV")
		end
	end,

	-- ComEne34 NodeAction
	ComEne34_NodeAction = function()
		local RouteName			= TppData.GetArgument(3)
		local RoutePointNumber		= TppData.GetArgument(1)
		--GsRoute.GetRouteIdは6/14以降廃止
		if ( RouteName ==  GsRoute.GetRouteId( "S_Pat_FinalPazCheck" )) then
			if( RoutePointNumber == 31 ) then										--ノードを通過した時
				TppEnemy.EnableRoute( this.cpID , "S_SL_HeliPortTower" )
				TppEnemy.DisableRoute( this.cpID , "S_Pat_FinalPazCheck" )
				TppEnemy.ChangeRoute( this.cpID , "ComEne34","e20010_Seq40_SneakRouteSet","S_SL_HeliPortTower", 0 )
			else
			end
		else
		end
	end,
}
-----------------------------------------------------------------------------------------------------------------
--２人をヘリに乗せて、自分がヘリに乗るまで
-----------------------------------------------------------------------------------------------------------------
this.Seq_PlayerOnHeli = {

	Messages = {
		Character = {
--			{ data = "SupportHelicopter", message = "CloseDoor", localFunc = "HeliCloseDoor_Snake" },
		},
	},

	OnEnter = function( manager )
		--雨さえぎりOFF
		WoodTurret_RainFilter_OFF()
		--強制リアライズ解除
		TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( this.cpID , "GoTo_PazCheck_vip" , false )
		TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( this.cpID , "S_Pat_FinalPazCheck" , false )
		--管理棟巨大ゲートデフォルトオープン
		Common_CenterBigGate_DefaultOpen()
		-- 車輌設定
		if( TppMission.GetFlag( "isFirstEncount_Chico" ) == true ) then
			FirstChico_Vehicle_02()	--先チコ車輌設定
		else
			FirstPaz_Vehicle()		--先パス車輌設定
		end
		--達成済み写真のチェック
		SetComplatePhoto()
		--中間目標設定
		if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) and
			( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then
				commonUiMissionSubGoalNo(8)
		elseif( TppMission.GetFlag( "isPlaceOnHeliChico" ) == true ) and
			( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == false ) then
				commonUiMissionSubGoalNo(7)
		elseif( TppMission.GetFlag( "isPlaceOnHeliChico" ) == false ) and
			( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == true ) then
				commonUiMissionSubGoalNo(3)
		else
			--どっちか絶対にヘリで回収しているはず
		end
		--諜報無線設定
		SetIntelRadio()
		--任意無線設定
		SetOptionalRadio()
		--カセットテープ５を消す
		TppPickableManager.DisableByLocator( "tp_chico_05" )
		--ミッション圏外処理
		All_Seq_MissionAreaOut()
		-- デフォルトランディングゾーン設定
		TppSupportHelicopterService.SetDefaultRendezvousPointMarker("no_lz")
		--トラップEnable/Disable
		Seq10Trap_Disable()
		Seq10_20Trap_Disable()
		Seq20Trap_Disable()
		Seq30Trap_Disable()
		Seq40Trap_Disable()
		--ガードターゲット設定
		GuardTarget_Setting()
		-- チコパス扉設定
		ChicoDoor_ON_Open()
		PazDoor_ON_Open()
		--リトライ時サイレン処理
		Common_RetryKeepCautionSiren()
		-- パス救出 脱出曲へ変更
		TppMusicManager.ChangeParameter( 'bgm_paz_escape' )
	end,
}
-----------------------------------------------------------------------------------------------------------------
--ヘリに乗った
-----------------------------------------------------------------------------------------------------------------
this.Seq_PlayerOnHeliAfter = {

	Messages = {
		Character = {
--			{ data = "SupportHelicopter", message = "CloseDoor", commonFunc = function() TppSequence.ChangeSequence( "Seq_Mission_Telop" ) end },
		},
	},

	OnEnter = function( manager )
		--達成済み写真のチェック
		SetComplatePhoto()
		--ミッション圏外処理
		All_Seq_MissionAreaOut()
		--カセットテープ５を消す
		TppPickableManager.DisableByLocator( "tp_chico_05" )
		--管理棟巨大ゲートデフォルトオープン
		Common_CenterBigGate_DefaultOpen()
		-- 車輌設定
		if( TppMission.GetFlag( "isFirstEncount_Chico" ) == true ) then
			FirstChico_Vehicle_02()	--先チコ車輌設定
		else
			FirstPaz_Vehicle()		--先パス車輌設定
		end
		--トラップEnable/Disable
		Seq10Trap_Disable()
		Seq10_20Trap_Disable()
		Seq20Trap_Disable()
		Seq30Trap_Disable()
		Seq40Trap_Disable()
		--ガードターゲット設定
		GuardTarget_Setting()
		--リトライ時サイレン処理
		Common_RetryKeepCautionSiren()
		-- パス救出 脱出曲へ変更
		TppMusicManager.ChangeParameter( 'bgm_paz_escape' )
	end,
}
---------------------------------------------------------------------------------
-- ミッション失敗
---------------------------------------------------------------------------------
this.Seq_Mission_Failed = {

	MissionState = "failed",

	Messages = {
		Timer = {
			{ data = "MissionFailedProductionTimer",	message = "OnEnd", 	localFunc="OnFinishMissionFailedProduction" },
		},
	},
	-- ミッション失敗演出ウェイト明け
	OnFinishMissionFailedProduction = function( manager )
			-- TppSequence.ChangeSequence( "Seq_Mission_End" )
			TppSequence.ChangeSequence( "Seq_MissionGameOver" )
	end,

	OnEnter = function( manager )
			-- ミッション失敗演出（無線コール、サウンドコール）
			-- TppSound.PlayEvent( "Play_bgm_general_gameover" ) 2013.08.19 SD班依頼により外しました by sahara
			-- ミッション失敗演出中のウェイトを行う
			TppTimer.Start( "MissionFailedProductionTimer", this.CounterList.GameOverFadeTime )
			GzRadioSaveData.ResetSaveRadioId()
			GzRadioSaveData.ResetSaveEspionageId()
			local radioManager = RadioDaemon:GetInstance()
			radioManager:DisableAllFlagIsMarkAsRead()
			radioManager:ResetRadioGroupAndGroupSetAlreadyReadFlag()
			TppRadioConditionManagerAccessor.Unregister( "Tutorial" )
			TppRadioConditionManagerAccessor.Unregister( "Basic" )
	end,
}
---------------------------------------------------------------------------------
-- ゲームオーバー
---------------------------------------------------------------------------------
this.Seq_MissionGameOver = {

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
-- ヘリ墜落
---------------------------------------------------------------------------------
this.Seq_HelicopterDeadNotOnPlayer = {
	MissionState = "failed",
	Messages = {
		Character = {
			{ data = "SupportHelicopter",	message = "Dead",	localFunc = "localChangeSequence" },
		},
	},
	OnEnter = function()
		GZCommon.PlayCameraOnCommonHelicopterGameOver()
		SetGameOverMissionFailed()									-- MissionFailed
		this.CounterList.GameOverRadioName = "Miller_HeliDead"		-- ゲームオーバー音声を登録
	end,
	localChangeSequence = function()
		TppSequence.ChangeSequence( "Seq_MissionGameOver" )
	end,
}
---------------------------------------------------------------------------------
-- ミッション終了
---------------------------------------------------------------------------------
this.Seq_Mission_End = {

	OnEnter = function()
		--全カセットテープの持ってない扱いをやめる
		local uiCommonData = UiCommonDataManager.GetInstance()
		uiCommonData:ShowAllCassetteTapes()

		GZCommon.MissionCleanup()	-- GZ共通ミッション後片付け
		-- ミッション後片付け
		this.commonMissionCleanUp()
		TppMission.ChangeState( "end" )
	end,
}
---------------------------------------------------------------------------------
-- ミッションテロップ
---------------------------------------------------------------------------------
this.Seq_Mission_Telop = {

	MissionState = "clear",
	Messages = {
		UI = {
			-- 終了ミッションテロップのフェードイン
			{ message = "EndMissionTelopFadeIn" ,	localFunc = "OnFinishClearFade" },
		},
	},
	-- クリア画面遷移タイミングでクリア無線コール
	OnFinishClearFade = function()
		-- 終了テロップ～ミッション完全終了まで無線とBGM以外ミュート
		TppSoundDaemon.SetMute( 'Result' )
		-- ジングル再生
		TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_e20010_result" )
	end,

	OnEnter = function()
		Trophy.TrophyUnlock(1)		--実績解除
		RankingFeedBack()			--ランキングによるユーザーへのフィードバック

		--脱走捕虜をヘリ回収していたら
		if( TppMission.GetFlag( "isPlaceOnHeliSpHostage" ) == true ) then
			--ゲームフラグ「カセットテープ」を更新
			TppGameSequence.SetGameFlag( "e20010_cassette" , true )
		else
		end

		local TelopEnd = {
			onEndingStartNextLoading = function()
				TppSequence.ChangeSequence( "Seq_Mission_Clear" )
			end
		}
		GZCommon.StopSirenNormal()	-- サイレンの通常停止（徐々にフェード停止）
		TppUI.ShowTransitionWithFadeOut( "ending", TelopEnd, 2 )
	end,
}
---------------------------------------------------------------------------------
-- ミッションクリア
---------------------------------------------------------------------------------
this.Seq_Mission_Clear = {

	OnEnter = function()
		TppMission.ChangeState( "end" )
		GzRadioSaveData.ResetSaveRadioId()
		GzRadioSaveData.ResetSaveEspionageId()
		local radioManager = RadioDaemon:GetInstance()
		radioManager:DisableAllFlagIsMarkAsRead()
		radioManager:ResetRadioGroupAndGroupSetAlreadyReadFlag()
		TppRadioConditionManagerAccessor.Unregister( "Tutorial" )
		TppRadioConditionManagerAccessor.Unregister( "Basic" )
	end,
}
---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this
