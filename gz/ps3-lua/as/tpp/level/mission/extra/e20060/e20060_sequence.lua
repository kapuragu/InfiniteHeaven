local this = {}

---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------
this.missionID = 20060
this.cpID = "gntn_cp"
this.tmpBestRank = 0
this.tmpRewardNum = 0				-- 達成率（報酬獲得数）表示用

this.trackWeapon1 = "WP_hg00_v01"
this.trackWeapon2 = "WP_sg01_v00"


this.markRouteBe = "GsRouteData0001"
this.markRouteAf = "GsRouteData0001_mark"


-- 見るはんてい
this.lookHeli = "heli_20060"
this.lookMoai = "e20060_moai"
this.lookCamera = "camera_20060"

this.tmpChallengeString = 0			-- 報酬ポップアップ識別用
--デモ補正カメラの移動時間
this.demoCamRot = 0.15
this.demoCamSpeed = 1.8

-- ドア開けミッション
this.doorMax = 13

this.eneCheckSize_paz = Vector3(27,7,26) -- パスに会うデモ　敵兵を確認する判定のサイズ
this.eneCheckSize_chico = Vector3(24,6,28) -- チコに会うデモ　敵兵を確認する判定のサイズ
-- Logo
local logoMax = 8 --ロゴのクリア総定数
--lang ID
local hudCommonData = HudCommonDataManager.GetInstance()


local langDoor		= "announce_door_unlock"
local langHeli	 	= "announce_mission_40_20060_000_from_0_prio_0"
local langChaff 	= "announce_mission_40_20060_001_from_0_prio_0"
local langCamera 	= "announce_mission_40_20060_002_from_0_prio_0"
local langMoai 		= "announce_mission_40_20060_003_from_0_prio_0"
local langTank 		= "announce_mission_40_20060_004_from_0_prio_0"
local langVehicle 	= "announce_mission_40_20060_005_from_0_prio_0"
local langSwitch 	= "announce_mission_40_20060_006_from_0_prio_0"
local langLogo 		= "announce_mission_40_20060_007_from_0_prio_0"
local langMark 		= "announce_mission_40_20060_008_from_0_prio_0"
local langMarkLA 	= "announce_mission_40_20060_009_from_0_prio_0"
local langXOF		= "announce_allDestroyXOF"	-- 金属中マーカー消し
local langHeliDead	= "announce_destroyed_support_heli"

local langFoxDie000 = "announce_mission_40_20060_100_from_0_prio_0"	--	川西能勢口
local langFoxDie001 = "announce_mission_40_20060_101_from_0_prio_0"	--	絹延橋
local langFoxDie002 = "announce_mission_40_20060_102_from_0_prio_0"	--	滝山
local langFoxDie003 = "announce_mission_40_20060_103_from_0_prio_0"	--	FOXEkruaeogj...aor/ut..ga##rgr:niOEDIH))abp93ng62rfapg.gar,werghga....
local langFoxDie004 = "announce_mission_40_20060_104_from_0_prio_0"	--	鶯の森
local langFoxDie005 = "announce_mission_40_20060_105_from_0_prio_0"	--	鼓滝
local langFoxDie006 = "announce_mission_40_20060_106_from_0_prio_0"	--	FOXENGIfejilfeij000f...fgfellt.943kiidei88723
local langFoxDie007 = "announce_mission_40_20060_107_from_0_prio_0"	--	次は
local langFoxDie008 = "announce_mission_40_20060_108_from_0_prio_0"	--	FOXENGINFOop..griiipa!!!jig#t&amp;halfgnai..3r5348isi?dt..40gaa543gger
local langFoxDie009 = "announce_mission_40_20060_109_from_0_prio_0"	--	まもなく
local langFoxDie010 = "announce_mission_40_20060_110_from_0_prio_0"	--	多田
local langFoxDie011 = "announce_mission_40_20060_111_from_0_prio_0"	--	平野
local langFoxDie012 = "announce_mission_40_20060_112_from_0_prio_0"	--	FOXENGIfe : fejkLl230(jjkfe)89092keiHkeIo..Ekeos230Lke(3k~
local langFoxDie013 = "announce_mission_40_20060_113_from_0_prio_0"	--	FOXENGINE:「FOop..griiipa!!!jig#t&amp;halfgnai..3r5348isi?dt..40gaa543gger
local langFoxDie014 = "announce_mission_40_20060_114_from_0_prio_0"	--	一の鳥居
local langFoxDie015 = "announce_mission_40_20060_115_from_0_prio_0"	--	畦野
local langFoxDie016 = "announce_mission_40_20060_116_from_0_prio_0"	--	山下
local langFoxDie017 = "announce_mission_40_20060_117_from_0_prio_0"	--	F.griiipa!!!jig#t&amp;halfgnai..3r5348isi?dt..40gaa543gger
local langFoxDie018 = "announce_mission_40_20060_118_from_0_prio_0"	--	FO[..QHipa!!kje90fd&amp;hfeklfelk2i..fe7Yuiu_K21Wifn[JKkfamdf=^^
local langFoxDie019 = "announce_mission_40_20060_119_from_0_prio_0"	--	FOop..gefjei94?,.fe$$jioikl%&amp;lferii.ipa!!!jig#t&amp;aq00//feji1?_ae"aef$5%
local langFoxDie020 = "announce_mission_40_20060_120_from_0_prio_0"	--	FOXENE!!!jig#t&amp;h;`:aw^|amk#kfei900_a!feJI0=---Dji!Qs;efe+a
local langFoxDie021 = "announce_mission_40_20060_121_from_0_prio_0"	--	笹部
local langFoxDie022 = "announce_mission_40_20060_122_from_0_prio_0"	--	光風台
local langFoxDie023 = "announce_mission_40_20060_123_from_0_prio_0"	--	FOXENGINE:「FOXDIE」215..73.5///4gaf%rajrig3j4HIDEOt5h$go88))pi
local langFoxDie024 = "announce_mission_40_20060_124_from_0_prio_0"	--	FOXENGINE:「FOXDIE」対u9374u__i-p=khg :-)
local langFoxDie025 = "announce_mission_40_20060_125_from_0_prio_0"	--	ときわ台
local langFoxDie026 = "announce_mission_40_20060_126_from_0_prio_0"	--	FOXENGINE:「FOXDIE」対処afe.?.effj89304:-)
local langFoxDie027 = "announce_mission_40_20060_127_from_0_prio_0"	--	FOXENGINE:「FOXDIE」対処中b84tgd9_ie-)
local langFoxDie028 = "announce_mission_40_20060_128_from_0_prio_0"	--	FOXENGINE:「FOXDIE」対処中c9ji ;-)
local langFoxDie029 = "announce_mission_40_20060_129_from_0_prio_0"	--	妙見口
local langFoxDie030 = "announce_mission_40_20060_130_from_0_prio_0"	--	次はFOXDIE
local langFoxDie031 = "announce_mission_40_20060_131_from_0_prio_0"	--	FOXENGINE:「FOXDIE」対処中
local langFoxDie032 = "announce_mission_40_20060_132_from_0_prio_0"	--	FOXENGINE:「FOXDIE」対処完了
local langFoxDie033 = "announce_mission_40_20060_133_from_0_prio_0"	--	FOXENGINE：Initialization Complete


----チコに会う
this.demoStaPlayer_chico = "Stand"--プレイヤーの位置補正　姿勢・向き
this.demoPosPlayer_chico = Vector3(73.27256, 17.2, 197.36193)--Vector3(73.27256, 17.2, 197.36193)
this.demoRotPlayer_chico = -20.0805
----パスに会う
this.demoStaPlayer_paz = "Stand"---プレイヤーの位置補正　姿勢・向き
this.demoPosPlayer_paz = Vector3(-133.1, 24.5, -10.2)
this.demoRotPlayer_paz = 90

this.foxDieDemoDoorNum = 2	-- 0;チコ、1,パス, 2もう見たよ
this.timeFoxDieBugAnnounce = 1 -- アナウンスログの間隔
this.timeFoxDieBugStart = 2	--FOXエンジンバグ 開始まで時間
this.timeFoxDieBug = 100	--FOXエンジンバグ 終了までの保険処理時間
this.timeEndSeq = 40 -- 保険処理でEndに向かう

---------------------------------------------------------------------------------
-- EventSequenceManager
---------------------------------------------------------------------------------
this.RequiredFiles = {
	"/Assets/tpp/script/common/GZCommon.lua",
}

this.Sequences = {
	--prepare
	{ "Seq_MissionPrepare" },
	--demo
	{ "Seq_MissionSetup" },
	{ "Seq_OpeningDemoLoad" },
	{ "Seq_OpeningShowTransition" },
	{ "Seq_OpeningDemo" },
	{ "Seq_OpeningDemoEnd" },
	--game
	{ "Seq_MissionLoad" },
	{ "Seq_MissionStart" },
	{ "Seq_PlayerRideHelicopter" },
	{ "Seq_EventFoxDie"},
	-- Quiz
	{ "Seq_QuizSetup" },
	{ "Seq_QuizSkip" },
	{ "Seq_Quiz" },
	--Demo
	{ "Seq_DemoFoxDie" },
	--clear
	{ "Seq_MissionClearDemo" },
	{ "Seq_MissionClearDemoAfter" },
	{ "Seq_MissionClearShowTransition" },
	{ "Seq_ShowClearReward" },
	{ "Seq_MissionAbort" },
	{ "Seq_MissionFailed" },
	{ "Seq_MissionGameOver" },
	{ "Seq_MissionEnd" },
}

this.ClearRankRewardList = {

	-- ステージ上に配置した報酬アイテムロケータのLocatorIDを登録
	RankS = "e20060_Assult",
	RankA = "e20060_Misile",
	RankB = "e20060_Sniper",
	RankC = "e20060_HandShotGun",
}
--[[
  ランクC以上		:ハンドショットガン
　ランクB以上		:スナイパーライフル
　ランクA以上		:無反動砲
　ランクS		:アサルトライフル（グレネーダー付き）
]]
this.ClearRankRewardPopupList = {

	-- 報酬アイテム入手ポップアップID
	RankS = "reward_clear_s_rifle",
	RankA = "reward_clear_a_rocket",
	RankB = "reward_clear_b_sniper",
	RankC = "reward_clear_c_pistol",
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
	--"Seq_OpeningShowTransition",
	"Seq_OpeningDemo",
	"Seq_OpeningDemoEnd",
	"Seq_MissionLoad",
	"Seq_MissionStart",
	"Seq_PlayerRideHelicopter",
	--"Seq_MissionClearDemo",
	--"Seq_MissionComplateClear",
	--"Seq_MissionClearShowTransition",
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
	isClear			=	false, --*
	isClearComp		=	false, --*
	-- homage
	isLookHeli 		= false,	--* homage flag
	isGetChaffCase 	= false,	--* homage flag
	isLookCamera 	= false,	--* homage flag
	isLookMoai 		= false,	--* homage flag
	isBombTank 		= false,	--* homage flag
	isRunVehicle 	= false,	--* homage flag
	isTurnOffPanel 	= false,	--* homage flag
	isInCamera		= false,
	isInMoai		= false,
	isInHeli		= false,
	-- failed
	isLookHeliFailed 		= false,	--* homage flag Failed
	isGetChaffCaseFailed 	= false,	--* homage flag Failed
	isLookCameraFailed 		= false,	--* homage flag Failed
	isLookMoaiFailed 		= false,	--* homage flag Failed
	isBombTankFailed 		= false,	--* homage flag Failed
	isRunVehicleFailed 		= false,	--* homage flag Failed
	isTurnOffPanelFailed 	= false,	-- homage flag Failed 近いぞ無線判定で使用
	-- photo
	isLookHeliPhoto 		= false,	--* homage flag Photo
	isGetChaffCasePhoto 	= false,	--* homage flag Photo
	isLookCameraPhoto		= false,	--* homage flag Photo
	isLookMoaiPhoto 		= false,	--* homage flag Photo
	isBombTankPhoto 		= false,	--* homage flag Photo
	isRunVehiclePhoto 		= false,	--* homage flag Photo
	isTurnOffPanelPhoto 	= false,	--* homage flag Photo
	-- charenge
	isCountTitleLogo		= 0,
	isTitleComp				= false,
	isGetWeapon				= false,
	isMakeFox				= false,
	isMakeLA				= false,
	isDoorCounter			= 0,
	-- other
	isPlayerInsideBGM		= false,	--* 外にいるか:false、中にいるか:ture
	isPlayerInsideColor		= false,	--* 外にいるか:false、中にいるか:ture
	-- counter
	isCountClear			= 0,--
	isCountClaymore			= 0,--* クレイモアのカウント
	isFailedClaymore		= false,
	-- fox die
	isFoxDieChico			= false, -- true 見た
	isFoxDiePaz				= false, -- true 見た
	isFoxDieStart			= false,
	isFoxDieEnd				= false, -- true FOXDIE イベントを見た
	isInTankDemo			= false,
	-- ネタ無線のタイミングとり
	isRadioEndOfKonkai		= false,
	isRadioAraskaSay		= false, -- ネタ無線を言ったかどうかの判定
	isRadioAraskaTrap		= false, -- アラスカトラップに入ったかどうか
	isRadioJanai			= false,
	-- weapon
	isGetShotGun			= false, --トラックにアタッチされる武器　フラグで管理
	isGetHandGun			= false,
	-- tutorial
	isCarTutorial			= false, --乗り物チュートリアルのボタン表示をした
	isAVMTutorial			= false, --装甲車チュートリアルのボタン表示をした
	-- Logo mark
	isMarkGZ	= false,--GZ
	isMarkMG	= false,--MG
	isMarkMG2	= false,--MG2
	isMarkMGS	= false,--MGS
	isMarkMGS2	= false,--MGS2
	isMarkMGS3	= false,--MGS3
	isMarkMGSPW	= false,--MGSPW
	isMarkMGS4	= false,--MGS4
	isMarkHeli	= false, -- ヘリのマークについて管理するフラグ

	isHeliLandNow			= false,	-- ヘリが地面にホバリングってるかどうか

	isHeliBreak	= false,	-- ヘリがこわれているかどうか
	isHeliComming = false,

	isDemoChico		= false,
	isDemoPaz		= false,
	isHostageDead1	= false,
	isHostageDead2	= false,

	isPazDoor		= false,

	isBreakWood		= false,
	isJinmon		= false,

	isRouteSerch1	= false,--壊れていたらルートを変えるフラグ
	isRouteSerch2	= false,
	isRouteSerch3	= false,

	isQuizSkip		= false,
	isQuizComp		= false,

	isNinjaReward	= false,
}

---------------------------------------------------------------------------------
-- Mission Counter List
---------------------------------------------------------------------------------
this.CounterList = {
	GameOverRadioName			= "NoRadio",		-- ゲームオーバー無線名
	GameOverFadeTime			= GZCommon.FadeOutTime_MissionFailed,	-- ゲームオーバー時フェードアウト開始までのウェイト
}

---------------------------------------------------------------------------------
-- Demo List
---------------------------------------------------------------------------------
this.DemoList = {
	Demo_Opening 			= "p12_050000_000",		-- オープニングデモa
	Demo_LookHeli			= "p12_050020_010",		-- heli
	Demo_FlashGetChaffCase	= "p12_050020_020",		-- ヘリポートのチャフデモ
	Demo_LookCamera			= "p12_050020_030",		-- 監視カメラ
	Demo_LookMoai			= "p12_050020_040",		-- モアイ像
	Demo_BombTank			= "p12_050020_055",		-- 飛び出す兵士	--p12_050020_050
	Demo_BombTankGns		= "p12_050020_055_gns",		-- 飛び出す兵士	--p12_050020_050
	Demo_RunVehicle			= "p12_050020_060",		-- ビークル
	Demo_RunVehicleRev		= "p12_050020_060_rev",		-- ビークル
	Demo_TurnOffPanel		= "p12_050020_075",		-- ブラックアウト
	Demo_TurnOffPanelJP		= "p12_050020_075_jpn",		-- ブラックアウトEN
	Demo_MissionClear		= "p12_050010_000",		-- ミッションクリアデモ
	Demo_MissionClearComp	= "p12_050010_000",		-- ミッションクリアデモ コンプリート版
	Demo_FoxDieChico		= "p12_050030_000",
	Demo_FoxDiePaz			= "p12_050040_000",		-- FOXダイ　パス
	Demo_FoxDieChicoLow		= "p12_050050_000",
	Demo_FoxDiePazLow		= "p12_050060_000",		-- FOXダイ　パス
	Demo_AreaEscapeNorth	= "p11_020010_000",		-- ミッション圏外離脱カメラデモ：北側
	Demo_AreaEscapeWest		= "p11_020020_000",		-- ミッション圏外離脱カメラデモ：西側
	Demo_FoxLightKJP		= "p12_050070_000",		-- FOXライト　KJP
	Demo_FoxLightLA			= "p12_050070_001",		-- FOXライト　KJP
}

---------------------------------------------------------------------------------
-- Radio List
---------------------------------------------------------------------------------
this.RadioList = {
	--共通
	Miller_MissionAreaOut	= "f0090_rtrg0310",			--0 ミッション圏外警告
	--開始
	Miller_op000			= {"e0060_rtrg0010",1}, 	--**ミッション開始時（デモでスネークが歩いている最中）
	Miller_op002			= {"e0060_rtrg0013",1}, 	--**現地調達
	Near_Hostage			=  "e0060_rtrg0222",		--**捕虜が近くにいる
	Miller_op003			= "e0060_rtrg0011",			-- コンテニューしたとき　もう一度ミッション内容を言う
	-- Homage
	fondHomage1				= "e0060_rtrg0021", 		--**オマージュを見つけた  さすが伝説の男
	fondHomage2				= "e0060_rtrg0020", 		--**オマージュを見つけた
	canClear				= {"e0060_rtrg0022",1}, 	--**オマージュを見つけた
	complateHomage			= "e0060_rtrg0030", 		--**すべてのオマージュを解放した
	Answer_near				= "e0060_rtrg0040", 		--**正解が近いとき
	Answer_toFlase			= "e0060_rtrg0050", 		--正解できなくなりそうなとき
	Answer_failedAlert		= "e0060_rtrg0054", 		--**正解できなくなったとき
	Answer_failed			= "e0060_rtrg0055", 		--**正解できなくなったとき
	Answer_failedTo			= "e0060_rtrg0056", 		--*正解できなくなったときのあとに続ける　--miyataさんに実装をきく
	--Answer_failedTo2		= "e0060_rtrg0057", 		--正解できなくなったときのあとに続ける
	--Answer_failedTo3		= "e0060_rtrg0058", 		--正解できなくなったときのあとに続ける
	Answer_no				= "e0060_rtrg0057", 		--*正解じゃないとき
	Answer_noHeli			= "e0060_rtrg0065", 		--*正解じゃないとき ヘリ用
	Hint_heli				= "e0060_rtrg0070", 		--**正解条件：ハインド
	Hint_chaff				= "e0060_rtrg0071", 		--**正解条件：チャフ
	Hint_moai				= "e0060_rtrg0072", 		--**正解条件：モアイ
	Hint_tank				= "e0060_rtrg0073", 		--**正解条件：戦車兵
	Hint_vehicle			= "e0060_rtrg0074", 		--**正解条件：トンネル
	Hint_camera				= "e0060_rtrg0075", 		--**正解条件：監視カメラ
	Hint_switch				= "e0060_rtrg0079", 		--**正解条件：ブラックアウト
	Hint_switch0			= {"e0060_rtrg0069",1}, 	--**正解条件：ブラックアウト ど忘れ　一回のみ
	Answer_switch			= {"e0060_rtrg0077",1}, 	--ブラックアウト正解時	--デモに入らないか相談
	Clear_normal			= {"e0060_rtrg0110",1}, 	--**クリア時：再現シーンを残してゴールする
	Clear_normal2			= {"e0060_rtrg0120",1}, 	--**なし
	Clear_complate			= "e0060_rtrg0130", 	--**クリア時：全て再現後ゴールする
	-- mission
	radio_Alert				= {"e0060_rtrg0015",1},
	radio_BackAlert			= {"e0060_rtrg0016",1},
	-- 小ネタ
	neta_start				= {"e0060_rtrg0140",1}, 	--**小ネタ：開始直後　あらすか
	neta_start2				= {"e0060_rtrg0141",1}, 	--**小ネタ：開始直後　じゃない！
	neta_door				= {"e0060_rtrg0150",1}, 	--**小ネタ：開かない扉の前で
	neta_vehicle			= {"e0060_rtrg0160",1}, 	--**小ネタ：車に乗ると
	Call_dact				= {"e0060_rtrg0090",1}, 	--**トラップ起動：ダクトに入る
	Call_rat				= {"e0060_rtrg0100",1}, 	--**トラップ起動：ダクトでネズミを見る
	-- チャレンジ要素
	Call_mine				= {"e0060_rtrg0080",1}, 	--**トラップ起動：地雷原
	Metal_getGun			= {"e0060_rtrg0170",1}, 	--*+金属虫マーク：ライトの色の違う銃（拾った）--見た
	Metal_mistakeGun		= {"e0060_rtrg0175",1}, 	--**金属虫マーク：ライトの色の違う銃（構え） -- 装備した
	Metal_mistakeBigMark	= "e0060_rtrg0176", 		--金属虫マーク：大きな金属虫マーク
	Metal_notYet			= "e0060_rtrg0177", 		--まだ金属虫マークを消したことがない場合
	Metal_visibleMark		= "e0060_rtrg0178", 		--金属虫マーク：ライトでマークが出現
	Metal_int				= "e0060_rtrg0180", 		--**金属虫マーク：マーク初消化
	Metal_wrong				= "e0060_rtrg0183", 		--*金属虫マーク：不正解
	Metal_allClear			= {"e0060_rtrg0185",1}, 		--金属虫マーク：マーク全消化
	Metal_bigMarkClear		= "e0060_rtrg0187", 		--金属虫マーク：大きな金属虫マーク
	Metal_Clear				= {"e0060_rtrg0188",1}, 	--*金属虫マーク：感謝（全部消したときなど）
	Light_offMark			= {"e0060_rtrg0189",1}, 	--FOXマークを消すと
	Light_near				= {"e0060_rtrg0190",1}, 	--**バットマンライト：コジプロマーク付近
	Light_clear				= {"e0060_rtrg0200",1}, 	--**バットマンライト：コジプロマーク完成
	Light_clearLA			= {"e0060_rtrg0210",1}, 	--**バットマンライト：LAスタジオマーク完成
	-- クリア無線
	Radio_MissionClearRank_S = "e0060_rtrg0304",
	Radio_MissionClearRank_A = "e0060_rtrg0303",
	Radio_MissionClearRank_B = "e0060_rtrg0302",
	Radio_MissionClearRank_C = "e0060_rtrg0301",
	Radio_MissionClearRank_D = "e0060_rtrg0300",
	-- ヘリ
	Radio_RideHeli_Clear 		="f0090_rtrg0460",
	Radio_MissionAbort_Warning 	="f0090_rtrg0130",
	Miller_HeliAttack			="f0090_rtrg0225",				-- 支援ヘリがプレイヤーから攻撃を受けた
	--FoxDie
	Radio_FoxDie1 			="e0060_rtrg0220",--なんだ？
	Radio_FoxDie2 			="e0060_rtrg0230",--ありがとう
	Radio_FoxDieIDroid 		="e0060_rtrg9010",--能勢電
	Radio_FoxDieFixed 		="e0060_rtrg9020",--機能が回復

	-- 懐かしい声
	Sneak_Natsui00	= "e0060_rtrg1010",--懐かしい
	Sneak_Natsui01	= "e0060_rtrg1013",--懐かしすぎる
	Sneak_Natsui02	= "e0060_rtrg1017",--おお！
	Sneak_Natsui03	= "e0060_rtrg1018",--覚えてないな

	-- クイズ
	Quiz_start1 	= "e0060_rtrg2010",	-- *セリフ１
	Quiz_start2 	= "e0060_rtrg2020",	-- *セリフ１
	Quiz_skinNot	= "e0060_rtrg2030",	-- *セリフ２
	Quiz_skinHave 	= "e0060_rtrg2032",	-- *セリフ３　報酬済み
	Quiz_setumei	= "e0060_rtrg2040",	-- *セリフ４
	Quiz_normal 	= "e0060_rtrg2050",	-- *セリフ５　NORMAL
	Quiz_hard 		= "e0060_rtrg2052",	-- *セリフ６　HARD
	Quiz_areYouRedy = "e0060_rtrg2060",	-- *セリフ７
	Quiz_goToQuiz 	= "e0060_rtrg2070",	-- *セリフ７２
	Quiz_goToTitle 	= "e0060_rtrg2075",	-- *セリフ７３　タイトルへ
	Quiz_failed 	= "e0060_rtrg2120",	-- *セリフ９　タイトルへ
	Quiz_allClear 	= "e0060_rtrg2130",	-- *セリフ１１－１
	Quiz_skinGet 	= "e0060_rtrg2140",	-- *セリフ１１－２　報酬ゲット
	Quiz_skinNoGet 	= "e0060_rtrg2145",	-- *セリフ１１－３　報酬なし
	Quiz_skip		= "e0060_rtrg2011", -- クイズスキップ
	--Quiz_fox		= "e0060_rtrg2150",	-- セリフ１３　FOX、、、、
	Quiz_Die		= "e0060_rtrg2155", -- DIE!!

	--ゲームオーバー　f0033_gmov0190
	Radio_DeadPlayer					= "f0033_gmov0190",		-- プレイヤーが死亡した　f0033_gmov0010
	Radio_RideHeli_Failed				= "f0033_gmov0040",		-- プレイヤーがヘリに乗って離脱した
	Radio_MissionArea_Failed			= "f0033_gmov0020",		-- プレイヤーがミッション圏外に出た

	Miller_BreakSuppressor	= "f0090_rtrg0530",

	-- 捕虜用
	Radio_AlertHostage		= "e0060_rtrg0310", -- **接触はまだやめとけ
	Radio_HostageDead 		= "f0090_rtrg0540",	-- 殺すことはないだろう f0090_rtrg0540
	Radio_HostageOnHeli		= "f0090_rtrg0200",			-- 捕虜をヘリに乗せた「よし、回収した」

	--ヘリ
	Miller_CallHeliHot01		= "e0010_rtrg0376",			--0 支援ヘリ要請時/ホットゾーン
	Miller_CallHeliHot02		= "e0010_rtrg0377",			--0 支援ヘリ要請時/ホットゾーン
	Miller_CallHeli01			= "f0090_rtrg0170",			--支援ヘリを呼んだ
	Miller_CallHeli02			= "f0090_rtrg0171",			--支援ヘリを呼んだ(ポイント変更)
	-- トイレ
	radio_Toilet			= {"e0060_rtrg0240",1},

-- *  スクリプトで書いた
-- ** 実際に再生を確認
}
this.OptionalRadioList = {
	--ミッション
	OptionalRadioSet_001		= "Set_e0060_oprg0010",--**　開始時
	OptionalRadioSet_001snow	= "Set_e0060_oprg0011",--**　開始時(降雪時)
	OptionalRadioSet_003		= "Set_e0060_oprg0015",--**　１こ見た
	OptionalRadioSet_003snow	= "Set_e0060_oprg0016",--**　１こ見た(降雪時)
	OptionalRadioSet_002		= "Set_e0060_oprg0020",--**　１００％
}

--諜報無線
this.IntelRadioList = {
	intelHomage   	= "e0060_esrg0060", -- オマージュのタネ
	radio_homage_heli 	= "e0060_esrg0060",
	radio_homage_camera = "e0060_esrg0060",
	radio_homage_chaff	= "e0060_esrg0060",
	radio_homage_tank 	= "e0060_esrg0060",
	radio_homage_moai 	= "e0060_esrg0060",

	-- 金属虫マーク
	intelMark_001 	= "e0060_esrg0010",--マークについて
	intelMark_002 	= "e0060_esrg0015",--その他
	intelMark_gz 	= "e0060_esrg0019",--GZ
	intelMark_mg 	= "e0060_esrg0020",--MG
	intelMark_mg2 	= "e0060_esrg0021",--MG2
	intelMark_mgs 	= "e0060_esrg0023",--MGS
	intelMark_104 	= "e0060_esrg0022",--MGS バリエーション？
	intelMark_mgs2	= "e0060_esrg0024",--MGS2
	intelMark_mgs3 	= "e0060_esrg0025",--MGS3
	e20060_logo_001 			= "e0060_esrg0026",--MGSPW
	intelMark_mgs4 				= "e0060_esrg0027",--MGS4
	intelMark_109 				= "e0060_esrg0028",--FOX
	intelMark_110 				= "e0060_esrg0029",--LA
	--FOXライト
	radio_kjpLogo 				= "e0060_esrg0030",--**コジプロマーク
	gntn_serchlight_20060_3 	= "e0060_esrg0040",--**FOXライト
	gntn_serchlight_20060_4 	= "e0060_esrg0040",--**FOXライト
	--FOX旗
	radio_foxFlag				= "e0060_esrg0050",
	radio_foxFlag1				= "e0060_esrg0050",
	--監視カメラ
	camera_20060				= "f0090_esrg0210",

	intel_e0060_esrg0070		= "e0060_esrg0070",						-- 戦車
	intel_e0060_esrg0080		= "e0060_esrg0080",						-- トイレ

	-- 捕虜
	Hostage_e20060_000 			= "e0060_esrg0090",
	Hostage_e20060_001 			= "e0060_esrg0090",
	Hostage_e20060_002 			= "e0060_esrg0090",
	Hostage_e20060_003 			= "e0060_esrg0090",

	-- 汎用無線
	intel_f0090_esrg0110		= "f0090_esrg0110",						-- 収容施設
	intel_f0090_esrg0120		= "f0090_esrg0120",						-- 難民キャンプ
	intel_f0090_esrg0130		= "f0090_esrg0130",						-- 旧収容区画について
	intel_f0090_esrg0140		= "f0090_esrg0140",						-- 管理棟
	intel_f0090_esrg0150		= "f0090_esrg0150",						-- 運搬用ゲート（GZ)について
	intel_f0090_esrg0190		= "f0090_esrg0190",						-- 赤い扉について
	intel_f0090_esrg0220		= "f0090_esrg0220",						-- ゲート開閉スイッチ
}

this.Messages = {
	Mission = {
		{ 								message = "MissionFailure",		 		localFunc = "commonMissionFailure" },
		{ 								message = "MissionClear", 				localFunc = "commonMissionClear" },
		{ 								message = "MissionRestart", 				localFunc = "commonMissionCleanUp" },		-- ミッションリスタート（メニュー）
		{ 								message = "MissionRestartFromCheckPoint", 		localFunc = "commonMissionCleanUp" },		-- ミッションリスタート（チェックポイント）
		{ 								message = "ReturnTitle", 					localFunc = "commonReturnTitle" },		-- タイトル画面へ（メニュー）
	},
	Character = {
		-- CommandPost
		{ data = "gntn_cp",				message = "Alert",		commonFunc = function() this.commonOnAlert() end },
		{ data = "gntn_cp",				message = "Evasion",	commonFunc = function() this.commonOnEvasion() end },
		{ data = "gntn_cp",				message = "Caution",	commonFunc = function() this.commonOnCaution() end },
		{ data = "gntn_cp",				message = "Sneak",		commonFunc = function() GZCommon.StopAlertSirenCheck() end },		-- Alert時用サイレンを通常停止
		{ data = "gntn_cp",				message = "AntiAir",	commonFunc = function() this.ChangeAntiAir() end },	-- 対空行動への切り替え
		-- heli
		{ data = "Player", 				message = "RideHelicopter", commonFunc = function() this.commonPlayerRideHeli() end},	--PCヘリに乗る
		{ data = "SupportHelicopter",	message = "Dead",	commonFunc = function() this.commonHeliDead() end  },		-- 撃墜された
		{ data = "SupportHelicopter",	message = "DepartureToMotherBase",	commonFunc = function() this.commonHeliTakeOff() end  },	-- 離陸開始した
		{ data = "SupportHelicopter",	message = "DamagedByPlayer",		commonFunc = function() this.commonHeliDamagedByPlayer() end },		-- プレイヤーから攻撃を受けた
	},
	Gimmick = {
		-- ドア開けた判定
		{ 								message = "DoorUnlock", commonFunc = function()  this.Common_DoorUnlock() end},
		{ data = "Paz_PickingDoor00",	message = "DoorOpenComplete", commonFunc = function()  this.Common_DoorOpen() end},
	},
}

---------------------------------------------------------------------------------
-- Local Function
---------------------------------------------------------------------------------
local insideBGMSetting = function()
	--カラーlut
	-- デフォルトは外にいるときのBGM
	if (TppMission.GetFlag( "isPlayerInsideBGM" ) == false)then
		-- outside
		Fox.Log(":: outside set BGM ::")
		TppMusicManager.ChangeParameter( 'bgm_mgs1_phase_out' )
	else
		-- inside
		Fox.Log(":: inside set BGM ::")
		TppMusicManager.ChangeParameter( 'bgm_mgs1_phase_in' )
	end
end

local insideColorSetting = function()
	--カラーlut
	-- デフォルトは外にいるときのカラコレ
	if (TppMission.GetFlag( "isPlayerInsideColor" ) == false)then
		-- outside
		Fox.Log(":: outside set ColorCore ::")
		TppEffectUtility.SetColorCorrectionLut( "MGS1_FILTERLUT_r1" )
	else
		-- in side
		Fox.Log(":: inside set ColorCore ::")
		-- グラデーションできないのでオミット
		--TppEffectUtility.SetColorCorrectionLut( "MGS1_FILTERLUT_r2" )
		TppEffectUtility.SetColorCorrectionLut( "MGS1_FILTERLUT_r1" )
	end
end

-- Radio 諜報
local commonSetOptRadio = function()
	--任意無線をクリア状況に応じて切り替える
	Fox.Log(":: set optional radio ::")

	if( TppMission.GetFlag( "isClearComp" ) == true )then
	-- コンプリート
		--クリアしてたらクリアの任意無線セット
		TppRadio.RegisterOptionalRadio( "OptionalRadioSet_002" )
	elseif( TppMission.GetFlag( "isClear" ) == true )then
	-- 一個以上クリア
		--任意無線を切り替える
		if (TppGameSequence.GetGameFlag("playerSkinMode" ) == 0)  then
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_003" )
		else
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_003snow" )
		end
	else
	-- くりあ無し
		if (TppGameSequence.GetGameFlag("playerSkinMode" ) == 0)  then
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_001" )
		else
			TppRadio.RegisterOptionalRadio( "OptionalRadioSet_001snow" )
		end
	end
end


local commonRadioSet = function()
	Fox.Log(":: radio Set!! ::")
	commonSetOptRadio()

	if( TppMission.GetFlag( "isMakeLA" ) == true or TppMission.GetFlag( "isMakeFox" ) == true )then
		TppRadio.DisableIntelRadio( "radio_kjpLogo" )
	else
		TppRadio.EnableIntelRadio( "radio_kjpLogo" )
	end
	TppRadio.EnableIntelRadio( "gntn_serchlight_20060_3" )
	TppRadio.EnableIntelRadio( "gntn_serchlight_20060_4" )
	TppRadio.EnableIntelRadio( "radio_foxFlag" )
	TppRadio.EnableIntelRadio( "radio_foxFlag1" )
	TppRadio.EnableIntelRadio( "camera_20060" )
	TppRadio.EnableIntelRadio( "Hostage_e20060_000" )
	TppRadio.EnableIntelRadio( "Hostage_e20060_001" )
	TppRadio.EnableIntelRadio( "Hostage_e20060_002" )
	TppRadio.EnableIntelRadio( "Hostage_e20060_003" )
	TppRadio.EnableIntelRadio( "intel_e0060_esrg0070" )

	-- Logo Mark
	TppRadio.EnableIntelRadio( "intelMark_gz" )
	TppRadio.EnableIntelRadio( "intelMark_mg" )
	TppRadio.EnableIntelRadio( "intelMark_mg2" )
	TppRadio.EnableIntelRadio( "intelMark_mgs" )
	TppRadio.EnableIntelRadio( "intelMark_mgs2" )
	TppRadio.EnableIntelRadio( "intelMark_mgs3" )
	TppRadio.EnableIntelRadio( "e20060_logo_001" )
	TppRadio.EnableIntelRadio( "intelMark_mgs4" )	--mgs4
	TppRadio.EnableIntelRadio( "intelMark_002" )	--その他

end

local lowPolyPlayer = function()
	Fox.Log(":: Check to low poly  ::")
	-- ローポリモード判定
	local skinFlag = TppGameSequence.GetGameFlag("playerSkinMode" )
	Fox.Log( "skin flag = "..skinFlag )
	if (skinFlag == 1)	then
		-- MGS1スネークに変更する
		Fox.Log(":: Player Change to Low Poly ::")
		TppPlayerUtility.ChangeLocalPlayerType("PLTypeMgs1")
	elseif( skinFlag == 2 )then
		-- 忍者モデル
		Fox.Log(":: Player Change to Raiden ::")
		TppPlayerUtility.ChangeLocalPlayerType("PLTypeNinja")
	else
		--保険処理で通常スネーク
		Fox.Log(":: Player Change to Normal Sneak ::")
		TppPlayerUtility.ChangeLocalPlayerType("PLTypeSneakingSuit")
	end
end
local lowPolyEnemy = function()
	-- ローポリモード判定
	if (TppGameSequence.GetGameFlag("playerSkinMode" ) ~= 0)  then
		Fox.Log(":: Set Low Poly Mode - enemy ::")
		--雪エフェクトを出す
		TppEffect.ShowEffect( "fx_snow" )
		TppEffect.HideEffect( "fx_dst" )
		-- 通常兵非表示
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_000",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_001",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_002",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_003",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_004",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_005",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_006",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_007",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_008",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_009",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_010",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_011",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_012",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_024",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_025",false )
		TppCharacterUtility.SetEnableCharacterId( "USSArmmy_026",false )
		TppCharacterUtility.SetEnableCharacterId( "Hostage_e20060_000",false )--捕虜
		TppCharacterUtility.SetEnableCharacterId( "Hostage_e20060_001",false )--捕虜
		-- ゲノム表示
		TppCharacterUtility.SetEnableCharacterId( "genom_000",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_001",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_002",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_003",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_004",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_005",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_006",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_007",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_008",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_009",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_010",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_011",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_012",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_013",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_014",true )
		TppCharacterUtility.SetEnableCharacterId( "genom_015",true )
		TppCharacterUtility.SetEnableCharacterId( "Hostage_e20060_002",true )--DARP
		TppCharacterUtility.SetEnableCharacterId( "Hostage_e20060_003",true )--社長
		TppHostageManager.GsSetEnableVoice( "Hostage_e20060_002", false ) --しゃべらない設定
		TppHostageManager.GsSetEnableVoice( "Hostage_e20060_003", false )--しゃべらない設定
		--
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_000" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_001" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_002" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_003" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_004" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_005" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_006" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_007" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_008" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_009" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_010" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_011" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_012" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_013" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_014" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "genom_015" )
		GZCommon.EnemyLaidonHeliNoAnnounceSet( "GenomeSoldier_Save" )
	end
end

--ミッションの中間目標を進める
local commonChangeMissionSubGoal = function(add)
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end

	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end

	if( TppMission.GetFlag( "isClear" ) == false )then
		luaData:SetCurrentMissionSubGoalNo( 1 ) -- 中目標番号をその値に設定する
	else
		luaData:SetCurrentMissionSubGoalNo( 2 ) -- 中目標番号をその値に設定する
	end
end


--ミッション圏外
local All_Seq_MissionAreaOut = function()
	-- ヘリシーケンス以外ならミッション圏外処理
	 local sequence = TppSequence.GetCurrentSequence()
		if (sequence ~= "Seq_PlayerRideHelicopter" )then
			TppMission.OnLeaveInnerArea( function() TppRadio.Play( "Miller_MissionAreaOut" ) end )
			TppMission.OnLeaveOuterArea( function() TppMission.ChangeState( "failed", "MissionAreaOut" ) end )	--ミッション失敗
		else
			Fox.Log("no mission area out. becouse Sequence is "..sequence )
		end
end

local heliWindowEffect = function()
	Fox.Log(":: heli window effect ::")
	if TppMission.GetFlag( "isHeliBreak" ) then
		TppEffect.HideEffect( "fx_heliWindow")
	else
		TppEffect.ShowEffect( "fx_heliWindow" )
	end

end

local setHeliMarker = function()
	Fox.Log("set heli marker check")
	if( TppMission.GetFlag( "isMarkMGSPW" ) == false and TppMission.GetFlag( "isJinmon" ) )then

		if( TppMission.GetFlag( "isMarkHeli" ) == true )then
			-- ヘリが来ているなら マーカーをつける
			Fox.Log("set heli marker")
			TppMarkerSystem.DisableMarker{ markerId="e20060_marker_charenge01" }
			TppMarkerSystem.SetMarkerGoalType{ markerId="e20060_logo_001", goalType="GOAL_NONE", radiusLevel=1 }
			TppMarkerSystem.EnableMarker{ markerId="e20060_logo_001", viewType="VIEW_MAP_ICON" }

		else
			-- ヘリが来ていないなら　マーカーはダミーをつける
			Fox.Log("set dummy marker")
			TppMarkerSystem.DisableMarker{ markerId="e20060_logo_001" }
			TppMarkerSystem.SetMarkerGoalType{ markerId="e20060_marker_charenge01", goalType="GOAL_NONE", radiusLevel=1 }
			TppMarkerSystem.EnableMarker{ markerId="e20060_marker_charenge01", viewType="VIEW_MAP_ICON"  }
		end
		return true

	elseif( TppMission.GetFlag( "isJinmon" ) )then
		-- 条件を満たしていないなら両方消しておく
		Fox.Log("disable heli marker")
		TppMarkerSystem.DisableMarker{ markerId="e20060_logo_001" }
		TppMarkerSystem.DisableMarker{ markerId="e20060_marker_charenge01" }

		return false
	end
end

local removeJinmon = function(characterId,characterIdLow)
		-- 尋問を進める
		Fox.Log("set interrogation : "..characterId.." : "..characterIdLow)
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( characterId,1 )
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( characterIdLow,1 ) --ローポリ用
end

local removeAllJinmon = function()
			Fox.Log(":: remove all jinmon ::")
			removeJinmon( "USSArmmy_000","genom_006" )
			removeJinmon( "USSArmmy_011","genom_004" )
			removeJinmon( "USSArmmy_007","genom_008" )
			removeJinmon( "USSArmmy_009","genom_003" )
			removeJinmon( "USSArmmy_012","genom_015" )
			removeJinmon( "USSArmmy_002","genom_005" )
			removeJinmon( "USSArmmy_024","genom_012" )
			removeJinmon( "USSArmmy_005","genom_010" )
end

-- Do all mission setup
local MissionSetup = function()
	--　初期化

	-- 保持すべきリアルタイム無線のフラグを保持
	TppRadio.SetAllSaveRadioId()

	GZCommon.MissionSetup()	-- GZ共通ミッションセットアップ
	--radio
	commonRadioSet()
	--ゲノム兵判定
	lowPolyEnemy()

	-- テクスチャロード待ち処理
	MissionManager.SetMiddleTextureWaitParameter( 0.5, 5 )

	-- Set default time and weather
	WeatherManager.RequestTag("default", 0 )
	TppClock.SetTime( "00:00:00" )
	TppClock.Stop()
	TppWeather.SetWeather( "cloudy" )
	GrTools.SetLightingColorScale(2.0)

	--機銃装甲車に乗れなくしておく
	TppVehicleUtility.SetCannotRide("Armored_Vehicle_WEST_001")

	--トラックに武器を置いておく
	if ( TppMission.GetFlag( "isGetHandGun" ) == false ) then
		TppNewCollectibleUtility.PutCollectibleOnCharacter{ id = this.trackWeapon1, count = 21, target = "Cargo_Truck_WEST_001" , attachPoint = "CNP_USERITEM" }
	end
	if ( TppMission.GetFlag( "isGetShotGun" ) == false ) then
		TppNewCollectibleUtility.PutCollectibleOnCharacter{ id = this.trackWeapon2, count = 15, target = "Cargo_Truck_WEST_002" , attachPoint = "CNP_USERITEM" }
	end

	--戦車の諜報無線
	if( TppMission.GetFlag( "isBombTank" ) == false and TppMission.GetFlag( "isBombTankFailed" ) == false) then
		TppRadio.DisableIntelRadio( "radio_homage_tank" )
		TppRadio.EnableIntelRadio( "intel_e0060_esrg0070" )
	else
		TppRadio.DisableIntelRadio( "intel_e0060_esrg0070" )
		this.damageTank()
	end

	-- ロゴマークをヘリへ
	if ( TppMission.GetFlag( "isMarkMGSPW" ) == false ) then
		TppGadgetUtility.AttachGadgetToChara("e20060_logo_001","SupportHelicopter","CNP_MARK")
	end

	--中間目標を更新
	commonChangeMissionSubGoal()
	-- BGM
	insideBGMSetting()
	-- カラーlut
	insideColorSetting()

	-- 金属虫武器を持っていたらブラックライトエフェクトを消しておく
	if ( TppMission.GetFlag( "isGetWeapon" ) == true ) then
		TppEffect.HideEffect( "fx_weaponLight")
	else
		TppEffect.ShowEffect( "fx_weaponLight" )
	end

	-- やぐらが壊れていたら消しておく
	if ( TppMission.GetFlag( "isBreakWood" ) == true ) then
		TppCharacterUtility.SetEnableCharacterId( "e20060_logo_008", false )
	else
		TppCharacterUtility.SetEnableCharacterId( "e20060_logo_008", true )
	end

	-- ヘリの窓設定
	heliWindowEffect()

	-- あらかじめドアをあけておく
	local angle = 120
	TppGimmick.OpenDoor( "AsyPickingDoor04", angle )
	TppGimmick.OpenDoor( "AsyPickingDoor05", angle )
	TppGimmick.OpenDoor( "AsyPickingDoor07", angle )
	TppGimmick.OpenDoor( "AsyPickingDoor08", angle )
	TppGimmick.OpenDoor( "AsyPickingDoor09", angle )
	TppGimmick.OpenDoor( "AsyPickingDoor13", angle )
	TppGimmick.OpenDoor( "AsyPickingDoor15", angle )
	TppGimmick.OpenDoor( "AsyPickingDoor16", angle )
	TppGimmick.OpenDoor( "AsyPickingDoor22", angle )
	TppGimmick.OpenDoor( "AsyPickingDoor23", angle )


	-- ゴールマーカーを「ゴール」に設定しておく
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end
	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end


	-- マップアイコン　マーカー　設定
	luaData:SetupIconUniqueInformationTable(
		--ミッション
		 { markerId="e20060_marker_GoalPoint", 			langId=	"marker_info_place_02" }
		,{ markerId="e20060_marker_PowerSupply",		langId=	"marker_info_place_00" }				--配電盤
		,{ markerId="e20060_marker_Weapon", 			langId=	"marker_info_weapon" }				--武器
		,{ markerId = "Cargo_Truck_WEST_002", 			langId = "marker_info_truck" }				-- トラック
		,{ markerId = "Cargo_Truck_WEST_001", 			langId = "marker_info_truck" }				-- トラック
		,{ markerId = "Armored_Vehicle_WEST_001",		langId = "marker_info_APC" }				-- 機銃装甲車
		,{ markerId = "Tactical_Vehicle_WEST", 			langId = "marker_info_vehicle_4wd" }		-- ビークル
		,{ markerId = "e20060_marker_Cassette", 		langId = "marker_info_item_tape" }			-- カセットテープ
		,{ markerId="e20060_marker_sniperRifle",		langId="marker_info_weapon_01" }			--スナイパーライフル
		,{ markerId="e20060_marker_Mine",				langId="marker_info_weapon_08" }			--クレイモア
		,{ markerId="e20060_marker_MonlethalWeapon",	langId="marker_info_weapon_00" }			--ハンドガン
		,{ markerId="e20060_marker_HundGun",			langId="marker_info_weapon_00" }			--ハンドガン
		,{ markerId="e20060_marker_ShotGun",			langId="marker_info_weapon_03" }			--ショットガン
		,{ markerId="e20060_marker_SubMachineGun",		langId="marker_info_weapon_04" }			--サブマシンガン
		,{ markerId = "camera_20060",					langId="marker_info_Surveillance_camera" }
		,{ markerId = "e20060_marker_Moai",					langId="marker_info_moai" }
		-- ロゴマーク
		,{ markerId="e20060_logo_101",					langId="marker_info_logo" }
		,{ markerId="e20060_logo_102",					langId="marker_info_logo" }
		,{ markerId="e20060_logo_103",					langId="marker_info_logo" }
		,{ markerId="e20060_logo_104",					langId="marker_info_logo" }
		,{ markerId="e20060_logo_105",					langId="marker_info_logo" }
		,{ markerId="e20060_logo_106",					langId="marker_info_logo" }
		,{ markerId="e20060_logo_107",					langId="marker_info_logo" }
		,{ markerId="e20060_logo_001",					langId="marker_info_logoArea" }
		,{ markerId="e20060_logo_002",					langId="marker_info_logoArea" }
		,{ markerId="e20060_logo_003",					langId="marker_info_logoArea" }
		,{ markerId="e20060_logo_004",					langId="marker_info_logoArea" }
		,{ markerId="e20060_logo_005",					langId="marker_info_logoArea" }
		,{ markerId="e20060_logo_006",					langId="marker_info_logoArea" }
		,{ markerId="e20060_logo_007",					langId="marker_info_logoArea" }
		,{ markerId="e20060_logo_008",					langId="marker_info_logoArea" }
		,{ markerId="e20060_marker_charenge01",			langId="marker_info_logoArea" }
		-- 共通
		,{ markerId="common_marker_Area_HeliPort",		langId="marker_info_area_03" }					--ヘリ発着場
	)

	-- 不要なライトを消す
	TppDataUtility.SetEnableDataFromIdentifier( "id_20130417_132026_266", "20060", false )
	-- サーチライトを消す
	TppCharacterUtility.SetEnableCharacterId( "gntn_area01_searchLight_001",false )-- FOXライト側
	TppCharacterUtility.SetEnableCharacterId( "gntn_area01_searchLight_002",false )-- LAライト

	-- 諜報セットアップ
	this.SetIntelRadio()

	-- 尋問の初期化
	if ( TppMission.GetFlag( "isJinmon" ) == true ) then
		removeAllJinmon()
	end

	-- コンポーネントの登録
	TppRadioConditionManagerAccessor.Register( "Basic", TppRadioConditionPlayerBasic{ time = 0.3 } )

	--雨フィルタのパラメータを上の命令で変更した値を元に戻す、０秒で
	local rainManager = TppRainFilterInterruptManager:GetInstance()
	rainManager:ResetStartEndFadeInDistanceDemo( 0 )

end

-------------------------------------------------------------------------

-- アナウンスログ本番用
local commonAnnounceLogMission = function( langNo ,count,max)
	Fox.Log(":: common announce Log ::")
	local counter = nil
	local maxNum = nil
	if( count ~= nil )then
		counter = count
	end
	if( max ~= nil )then
		maxNum = max
	end

	if ( langNo ~= nil) then
		hudCommonData:AnnounceLogViewLangId( langNo ,counter,maxNum)
		--hudCommonData:CallAnnounceLogMission( langNo )
	end
end

local checkHostDoor = function()

	if( TppMission.GetFlag( "isHostageDead1" ) == true )then
		Fox.Log("AsyPickingDoor24 : false")
		TppGadgetUtility.SetWillBeOpenedInDemo("AsyPickingDoor24", false)
	else
		Fox.Log("AsyPickingDoor24 : true")
		TppGadgetUtility.SetWillBeOpenedInDemo("AsyPickingDoor24", true)
		TppGadgetUtility.AddDoorEnableCheckInfo("AsyPickingDoor24", Vector3(69,20,204), this.eneCheckSize_chico)
	end

	if( TppMission.GetFlag( "isHostageDead2" ) == true )then
		Fox.Log("PazDoor : false")
		TppGadgetUtility.SetWillBeOpenedInDemo("Paz_PickingDoor00", false)
	else
		Fox.Log("PazDoor : true")
		TppGadgetUtility.SetWillBeOpenedInDemo("Paz_PickingDoor00", true)
		TppGadgetUtility.AddDoorEnableCheckInfo("Paz_PickingDoor00", Vector3(-138, 24, -16), this.eneCheckSize_paz )
	end


end

----------------------------------------------------------------------
local onDemoBlockLoad = function()
	local demoBlockPath = "/Assets/tpp/pack/mission/extra/e20060/e20060_d01.fpk"
	TppMission.LoadDemoBlock( demoBlockPath )

	TppMission.LoadEventBlock("/Assets/tpp/pack/location/gntn/gntn_heli.fpk" )

end

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

	if hudCommonData:IsEndLoadingTips() == false then
			hudCommonData:PermitEndLoadingTips() --終了許可(決定ボタンを押したら消える)
			-- 決定ボタン押されるのを待ってます
			return false
	end

	return true

end

-- ルートセットの初期化
local commonRouteSetMissionSetup = function()

	-- ルートセットの登録
	-- 禁止ルートの登録
	TppCommandPostObject.GsAddDisabledRoutes( this.cpID, this.markRouteAf )

	--TppEnemy.RegisterRouteSet( this.cpID, "sneak_day", "TppRouteSet_s" )
	--TppEnemy.RegisterRouteSet( this.cpID, "sneak_night", "TppRouteSet_s" )
	--TppEnemy.RegisterRouteSet( this.cpID, "caution_day", "TppRouteSet_c" )
	--TppEnemy.RegisterRouteSet( this.cpID, "caution_night", "TppRouteSet_c" )

	--TppEnemy.ChangeRouteSet( this.cpID, "TppRouteSet_n",{forceUpdate=true,forceReload=true} )
end

---------------------------------------------------------------------------------
-- ■■ SearchTarget Function
-------------------------------------------
-- ■ SearchTargetCharacterSetup
this.SearchTargetCharacterSetupCamera = function( manager, CharacterID )
	Fox.Log(":: SearchTargetCharacterSetup ::")
	-- ターゲットマーカー対象登録
	manager.CheckLookingTarget:AddSearchTargetEntity{				-- 登録処理
		mode 						= "CHARACTER",					-- 対象はCharacter
		name						= CharacterID,					-- 対象の名前(この名前がMessageの引数になる)
		--targetId	  				= "id_20060_all",
		targetName					=  CharacterID,					-- 対象のcharacterId
		--skeletonName				= "SKL_004_HEAD",				-- 注視関節名
		offset 						= Vector3(-0.0,	-0.4,	1.0),	-- 注視関節原点からのオフセット
		lookingTime					= 0.8,							-- 注目継続時間
		doWideCheck					= true,							-- 画面に映っている大きさのチェックをするときはtrue
		wideCheckRadius				= 0.60,							-- 画面に映っている大きさチェック用、対象の半径
		wideCheckRange				= 0.05,							-- 画面に映っている大きさチェック用、画面に対する割合
		doDirectionCheck			= true,							-- 向きチェックをするときはtrue
		directionCheckRange			= 15.0,							-- こっちを向いていると判定する角度
		doInMarkerCheckingMode		= false,						-- trueにすると、マーカーチェック有効中のみチェックする
		doCollisionCheck			= true,							-- アタリチェックするときはtrue
		doSendMessage				= true,							-- 条件成立時にmessageを送信するときはtrue。LookingTargetというmessageが送信される
		doNearestCheck				= false							-- trueにすると、登録されているものの内一番近いものだけが選ばれる
	}
end
this.SearchTargetCharacterSetupMoai = function( manager, CharacterID )
	Fox.Log(":: SearchTargetCharacterSetup :: Moai ")
	-- ターゲットマーカー対象登録
	manager.CheckLookingTarget:AddSearchTargetEntity{				-- 登録処理
		mode 						= "CHARACTER",					-- 対象はCharacter
		name						= CharacterID,					-- 対象の名前(この名前がMessageの引数になる)
		targetName					=  CharacterID,					-- 対象のcharacterId
		--skeletonName				= "SKL_004_HEAD",				-- 注視関節名
		offset 						= Vector3(0,0.15,0.8),			-- 注視関節原点からのオフセット
		lookingTime					= 1.1,							-- 注目継続時間
		doWideCheck					= true,							-- 画面に映っている大きさのチェックをするときはtrue
		wideCheckRadius				= 0.20,							-- 画面に映っている大きさチェック用、対象の半径
		wideCheckRange				= 0.08,							-- 画面に映っている大きさチェック用、画面に対する割合
		doDirectionCheck			= true,							-- 向きチェックをするときはtrue
		directionCheckRange			= 90,							-- こっちを向いていると判定する角度
		doInMarkerCheckingMode		= false,						-- trueにすると、マーカーチェック有効中のみチェックする
		doCollisionCheck			= true,							-- アタリチェックするときはtrue
		doSendMessage				= true,							-- 条件成立時にmessageを送信するときはtrue。LookingTargetというmessageが送信される
		doNearestCheck				= false							-- trueにすると、登録されているものの内一番近いものだけが選ばれる
	}
end

this.SearchTargetCharacterSetupHeli = function( manager, CharacterID )
	Fox.Log(":: SearchTargetCharacterSetup :: Heli ")
	-- ターゲットマーカー対象登録
	manager.CheckLookingTarget:AddSearchTargetEntity{				-- 登録処理
		mode 						= "CHARACTER",					-- 対象はCharacter
		name						= CharacterID,					-- 対象の名前(この名前がMessageの引数になる)
		targetName					=  CharacterID,					-- 対象のcharacterId
		--skeletonName				= "SKL_004_HEAD",				-- 注視関節名
		offset 						= Vector3(-2.0,	0.2, 	4.0),	-- 注視関節原点からのオフセット
		lookingTime					= 1.1,							-- 注目継続時間
		doWideCheck					= true,							-- 画面に映っている大きさのチェックをするときはtrue
		wideCheckRadius				= 1.10,							-- 画面に映っている大きさチェック用、対象の半径
		wideCheckRange				= 0.10,							-- 画面に映っている大きさチェック用、画面に対する割合
		doDirectionCheck			= true,							-- 向きチェックをするときはtrue
		directionCheckRange			= 100,							-- こっちを向いていると判定する角度
		doInMarkerCheckingMode		= false,						-- trueにすると、マーカーチェック有効中のみチェックする
		doCollisionCheck			= false,							-- アタリチェックするときはtrue
		doSendMessage				= true,							-- 条件成立時にmessageを送信するときはtrue。LookingTargetというmessageが送信される
		doNearestCheck				= false							-- trueにすると、登録されているものの内一番近いものだけが選ばれる
	}
end

-- commonSearchTargetSetup
local commonSearchTargetSetup = function( manager )
	Fox.Log("commonSearchTargetSetup")
	-- 一旦全登録を削除
	manager.CheckLookingTarget:ClearSearchTargetEntities()

	-- カメラ
	if( TppMission.GetFlag( "isLookCamera" ) == false and TppMission.GetFlag( "isLookCameraFailed" ) == false )  then
		Fox.Log("set serchTarget : camera")
		this.SearchTargetCharacterSetupCamera( manager, this.lookCamera )
	end

	-- Heli
	if( TppMission.GetFlag( "isLookHeli" ) == false and TppMission.GetFlag( "isLookHeliFailed" ) == false )  then
		Fox.Log("set serchTarget : Heli")
		this.SearchTargetCharacterSetupHeli( manager, this.lookHeli )
	end
	-- モアイ
	if( TppMission.GetFlag( "isLookMoai" ) == false and TppMission.GetFlag( "isLookMoaiFailed" ) == false )  then
		Fox.Log("set serchTarget : Moai")
		this.SearchTargetCharacterSetupMoai( manager, this.lookMoai )
	end

end

local commonLookCheck = function()
	local CharacterID = TppData.GetArgument(1)

	if( CharacterID == this.lookCamera and TppMission.GetFlag( "isInCamera" ) == true and TppMission.GetFlag( "isLookCamera" )==false )then	-- カメラを見たとき
		--Fox.Log("Look OK : ID = "..CharacterID )
		this.Seq_MissionStart.FuncCheckLookCamera()

	elseif( CharacterID == this.lookMoai and TppMission.GetFlag( "isInMoai" ) == true and TppMission.GetFlag( "isLookMoai" )==false)then	-- モアイを見たとき
		--Fox.Log("Look OK : ID = "..CharacterID )
		this.Seq_MissionStart.FuncCheckLookMoai()

	elseif( CharacterID == this.lookHeli and TppMission.GetFlag( "isInHeli" ) == true and TppMission.GetFlag( "isLookHeli" )==false)then	-- モアイを見たとき
		--Fox.Log("Look OK : ID = "..CharacterID )
		this.Seq_MissionStart.FuncCheckLookHeli()

	end

end
-- 諜報無線セットアップ
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
----------------------------------------------------------------------------------

this.commonHeliDead = function()
	commonAnnounceLogMission(langHeliDead)
	TppMission.SetFlag( "isMarkHeli", false )
	setHeliMarker()
	local sequence = TppSequence.GetCurrentSequence()
	-- 「ヘリ離脱シーケンス」だったらミッション失敗
	if ( sequence == "Seq_PlayerRideHelicopter" ) then
		TppMission.ChangeState( "failed", "PlayerDeadOnHeli" )
	end

end
---------------------------------------------------------------------------------
-- ■■ System Functions
---------------------------------------------------------------------------------

-- ■ commonMissionFailure
-- ミッション失敗時判定
this.commonMissionFailure = function( manager, messageId, message )
	Fox.Log(":: common Mission Fialure ::")
	-- ミッション失敗原因に応じて分岐させてそれぞれ演出処理を行う
	-- 演出によっては失敗パターンごとにシーケンスを分けてそれぞれで演出を組んだ方が良いかも

	-- デジャブ用に演出変更
	Fox.Log(" set game over ui to dejavu")
	local uiCommonData = UiCommonDataManager.GetInstance()
	uiCommonData:SetGameOverDejavuFailed()

	local radioDaemon = RadioDaemon:GetInstance()

	TppEnemyUtility.IgnoreCpRadioCall(true)	-- 以降の新規無線コールを止める
	TppEnemyUtility.StopAllCpRadio( 0.5 )	-- フェード時間

	-- 再生中の無線停止
	radioDaemon:StopDirectNoEndMessage()
	-- 字幕の停止
	SubtitlesCommand.StopAll()

	-- BGMフェードアウト
	TppSoundDaemon.SetMute( 'GameOver' )

	-- ミッション失敗フェード開始時間を汎用値で初期化しておく（Continue対策）
	this.CounterList.GameOverFadeTime = GZCommon.FadeOutTime_MissionFailed

	-- プレイヤーが死亡した
	if( message == "PlayerDead" )	then
		-- プレイヤー死亡時無線をコール
		this.CounterList.GameOverRadioName = "Radio_DeadPlayer"

	-- プレイヤーが落下死亡した
	elseif( message == "PlayerFallDead" )	then

		-- プレイヤー死亡時無線名を登録しておく
		this.CounterList.GameOverRadioName = "Radio_DeadPlayer"

		-- 落下死亡時はフェード開始時間を変更
		this.CounterList.GameOverFadeTime = GZCommon.FadeOutTime_PlayerFallDead

	--ミッション圏外
	elseif( message == "MissionAreaOut" )  then

		-------- 終了演出：車両に乗っているかで演出が変わる --------
		GZCommon.OutsideAreaCamera()

		this.CounterList.GameOverRadioName = "Radio_MissionArea_Failed"	-- ゲームオーバー音声を登録

		-- ミッション失敗テロップ
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:CallFailedTelop( "gameover_reason_mission_outside" )	  --- 引数はlangIdのメッセージID


	elseif ( message == "PlayerHeli" ) then
		this.CounterList.GameOverRadioName = "Radio_RideHeli_Failed"	-- ゲームオーバー音声を登録

		-- ミッション失敗テロップ
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:CallFailedTelop( "gameover_reason_mission_abort" )

	end
	-- ミッション失敗シーケンスへ
	TppSequence.ChangeSequence( "Seq_MissionFailed" )

end

this.commonMissionClear = function( manager, messageId, message )
	-- ミッションクリア方法に応じて分岐させてそれぞれ演出処理を行う
	TppSequence.ChangeSequence( "Seq_MissionClearDemo" )
	-- 実績解除：「サイドオプスを1つクリア」
	Trophy.TrophyUnlock( 2 )
end

-- ■ commonMissionClearRadio
-- ミッションクリアリアルタイム無線
this.commonMissionClearRadio = function()

	-- PlayRecordからクリアランクを取得
	-- 0：未クリア 1：S 2：A 3：B 4：C 5：D 6：E
	local Rank = PlayRecord.GetRank()

	if( Rank == 0 ) then
		Tpp.Warning( "commonMissionClearRadio:Mission not yet clear!!" )
	elseif( Rank == 1 ) then
		TppRadio.Play( "Radio_MissionClearRank_S" )
		-- 実績解除：「Sランクでミッションをクリア」
		Trophy.TrophyUnlock( 4 )
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

this.commonReturnTitle = function()
	Fox.Log(":: commonReturnTitle ::")
	-- ゴールを開ける
	TppDataUtility.SetVisibleDataFromIdentifier( "asset_base", "TestKey0", true, false )
	TppDataUtility.SetVisibleDataFromIdentifier( "asset_base", "gntn_vent001_0001", false, false )
	-- ミッション後片付け
	this.commonMissionCleanUp()
end
-- ミッション後片付け
this.commonMissionCleanUp = function()
	-- ミッション共通後片付け
	GZCommon.MissionCleanup()

	TppRadioConditionManagerAccessor.Unregister( "Basic" )

	-- 無線のフラグをリセット
	GzRadioSaveData.ResetSaveRadioId()
	local radioManager = RadioDaemon:GetInstance()
	radioManager:DisableAllFlagIsMarkAsRead()
	radioManager:ResetRadioGroupAndGroupSetAlreadyReadFlag()
	--一時的にコメントアウトフォーカスのため
end
-- プレイヤーがヘリに乗り込んだ
this.commonPlayerRideHeli = function()
		-- 汎用のミラー無線：ミッション中断警告
		TppRadio.Play( "Radio_MissionAbort_Warning")
		-- 離陸を少し待つ
		TppSupportHelicopterService.SetEnableGetOffTime( GZCommon.WaitTime_HeliTakeOff )
end
-- ヘリが離陸した
this.commonHeliTakeOff = function()
	TppMission.SetFlag( "isHeliComming", false )

	local isPlayer = TppData.GetArgument(3)
	-- プレイヤーが搭乗していたら
	if ( isPlayer == true ) then
		TppSequence.ChangeSequence( "Seq_PlayerRideHelicopter" )	-- ヘリ離脱シーケンスへ
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

	-- クリアランクに応じた報酬アイテム入手
	while ( Rank < this.tmpBestRank ) do
		Fox.Log("-------OnShowRewardPopupWindow:ClearRankRewardItem-------"..this.tmpBestRank)

		this.tmpBestRank = ( this.tmpBestRank - 1 )
		if ( this.tmpBestRank == 4 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankC, "WP_hg02_v00" )
		elseif ( this.tmpBestRank == 3 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankB, "WP_sr01_v00" )
		elseif ( this.tmpBestRank == 2 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankA, "WP_ms02" )
		elseif ( this.tmpBestRank == 1 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankS, "WP_ar00_v05", { isBarrel=true } )
		end
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

	if	TppGameSequence.GetGameFlag("hardmode") == false and					-- ノーマルクリアかつ
		PlayRecord.GetMissionScore( 20060, "NORMAL", "CLEAR_COUNT" ) == 1 then	-- 初回クリアなら

		hudCommonData:ShowBonusPopupCommon( "reward_extreme" )						-- ハード解放

	end

	if ( TppMission.GetFlag( "isNinjaReward" ) == true ) then
			-- スキン2入手ポップアップ
			Fox.Log("reward Ninja!!")
			hudCommonData:ShowBonusPopupCommon( "reward_open_raiden_b_20060" )
	end

	-- いずれのポップアップも呼ばれなかったら即座に次シーケンスへ
	if ( hudCommonData:IsShowBonusPopup() == false ) then
		Fox.Log("-------OnShowRewardPopupWindow:NoPopup!!-------")
		TppSequence.ChangeSequence( "Seq_MissionEnd" )	-- ST_CLEARから先に進ませるために次シーケンスへ
	end

end

-- 敵兵が乗り物に乗せられた
this.commonOnLaidEnemy = function()

	local sequence				= TppSequence.GetCurrentSequence()
	local EnemyCharacterID		= TppData.GetArgument(1)
	local VehicleCharacterID	= TppData.GetArgument(3)
	local EnemyLife				= TppEnemyUtility.GetLifeStatus( EnemyCharacterID )

	Fox.Log("commonOnLaidEnemy")

	-- そもそも死亡してたら何もしない
	if ( EnemyLife ~= "Dead" ) then
		-- ヘリに乗せた
		if( VehicleCharacterID == "SupportHelicopter" ) then
			-- クリア条件を達成済みなら
			TppRadio.DelayPlay( "Radio_HostageOnHeli", "short" )	-- 捕虜をヘリに乗せた無線と同じものをコール「よし、回収した」

			Fox.Log("check EnemyId : "..EnemyCharacterID )
			local check = string.find(EnemyCharacterID, "genom")

			if( check == 1 ) then
				Fox.Log("check ok : genom : "..check )
				-- 戦績反映
				PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE", "GenomeSoldier_Save" )
			end
		-- ヘリ以外（＝ビークルのみ？）
		else
			-- 今のところ何もなし
		end
	end
end

-- Mission Pict
local commonPhotoMissionSetup = function()
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end
	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end

	luaData:EnableMissionPhotoId(10)
	luaData:EnableMissionPhotoId(20)
	luaData:EnableMissionPhotoId(30)
	luaData:EnableMissionPhotoId(50)
	luaData:EnableMissionPhotoId(60)
	luaData:EnableMissionPhotoId(40)
	luaData:EnableMissionPhotoId(70)

end

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
-- 危険フェイズになった
this.commonOnAlert = function()
	-- サイレン開始
	GZCommon.CallAlertSirenCheck()
	-- エヴァージョン時用任意無線初期化処理
	local radioDaemon = RadioDaemon:GetInstance()
	radioDaemon:DisableFlagIsCallCompleted( "e0060_oprg9020" )
end
-- 捜索フェイズになった
this.commonOnEvasion = function()
	-- サイレン停止
	GZCommon.StopAlertSirenCheck()
	-- アラート時用任意無線初期化処理
	local radioDaemon = RadioDaemon:GetInstance()
	radioDaemon:DisableFlagIsCallCompleted( "e0060_oprg9010" )
end

-- 警戒フェイズになった
this.commonOnCaution = function()
	-- サイレン停止
	GZCommon.StopAlertSirenCheck()
	-- エヴァージョン時用任意無線初期化処理
	local radioDaemon = RadioDaemon:GetInstance()
	radioDaemon:DisableFlagIsCallCompleted( "e0060_oprg9020" )
end

-- 一度見たオマージュの写真を消す
local commonDisablePhoto = function( flagName )
	Fox.Log(":: commonDisablePhoto ::")
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end
	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end

	local flagNum = 0
	local langNo = 0
	local intel = ""

	-- check flag and Set photo
	if (flagName == "isLookHeli")then
		flagNum = 10
		langNo = langHeli
		intel = "radio_homage_heli"
	elseif (flagName == "isGetChaffCase")then
		flagNum = 20
		langNo = langChaff
		intel = "radio_homage_chaff"
	elseif (flagName == "isLookCamera")then
		flagNum = 30
		langNo = langCamera
		intel = "radio_homage_camera"
	elseif (flagName == "isLookMoai" )then
		flagNum = 50
		langNo = langMoai
		intel = "radio_homage_moai"
	elseif (flagName == "isBombTank")then
		flagNum = 60
		langNo = langTank
		intel = "radio_homage_tank"
	elseif (flagName == "isRunVehicle")then
		flagNum = 40
		langNo = langVehicle
	elseif (flagName == "isTurnOffPanel")then
		flagNum = 70
		langNo = langSwitch
	end

	-- 写真にクリアマークをつける
	luaData:SetCompleteMissionPhotoId(flagNum, true)
	commonAnnounceLogMission(langNo)

	-- あれば諜報削除
	if( intel ~= "" )then
		Fox.Log("delite intel radio : "..intel )
		TppRadio.DisableIntelRadio( intel )
	end

end

-- ネタ無線　ビークルのときだけ無線
local checkVehicleRide = function()
	local vehicle	=	TppData.GetArgument(1)
	local VehicleID = TppData.GetArgument(2)
	Fox.Log(":: checkVehicleRide ::")

	if ( vehicle == "Tactical_Vehicle_WEST") then
		TppRadio.Play( "neta_vehicle" )
	end
	if VehicleID == "WheeledArmoredVehicleMachineGun" then						--機銃装甲車の場合
		if( TppMission.GetFlag( "isAVMTutorial" ) == false ) then				--乗り物チュートリアルボタンを表示していないなら
			local hudCommonData = HudCommonDataManager.GetInstance()
			hudCommonData:CallButtonGuide( "tutorial_apc", fox.PAD_SELECT )
			TppMission.SetFlag( "isAVMTutorial", true )							--乗り物チュートリアルボタンを表示した
		end
	elseif VehicleID == "SupportHelicopter" then
		--
	else
--		if( TppMission.GetFlag( "isCarTutorial" ) == false ) then				--乗り物チュートリアルボタンを表示していないなら
			-- RT アクセルボタン
			local hudCommonData = HudCommonDataManager.GetInstance()
			hudCommonData:CallButtonGuide( "tutorial_accelarater", "VEHICLE_TRIGGER_ACCEL" )
			-- LT バックボタン
			local hudCommonData = HudCommonDataManager.GetInstance()
			hudCommonData:CallButtonGuide( "tutorial_brake", "VEHICLE_TRIGGER_BREAK" )
			TppMission.SetFlag( "isCarTutorial", true )							--乗り物チュートリアルボタンを表示した
--		end
	end

end

-- 逃げるネズミ　ダクトネタ
local ratEscape = function()

	local characters = Ch.FindCharacters( "Rat" )
	for i=1, #characters.array do
		local chara = characters.array[i]
		local plgAction = chara:FindPlugin("TppRatActionPlugin")
		plgAction:SetForceEscape()
	end
	TppRadio.Play( "Call_rat" )

end

local ibikiOnOff = function( flag )
-- いびきの設定
-- ture: オン、 flase: オフ
	if( flag == true )then
		Fox.Log(" sound on IBIKI ")
		local daemon = TppSoundDaemon.GetInstance()
		daemon:RegisterSourceEvent{
						sourceName = 'Source_tanksleep',
						tag = "Loop",
						playEvent = 'sfx_m_e20060_tank_sleep',
						stopEvent = 'Stop_sfx_m_e20060_tank_sleep',
		}

	elseif( flag == false )then
		Fox.Log(" sound off IBIKI ")
		local daemon = TppSoundDaemon.GetInstance()
		daemon:UnregisterSourceEvent{
						sourceName = 'Source_tanksleep',
						tag = "Loop",
						playEvent = 'sfx_m_e20060_tank_sleep',
				stopEvent = 'Stop_sfx_m_e20060_tank_sleep',
		}
	end

end

-- 戦車のふたをあけてアタリを作成
local tankOpen = function( flag )
	Fox.Log(":: tank Open ::")
	local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Armored_Vehicle_WEST_001" )
	if( vehicleObject ~= nil ) then--すでに壊れていたら存在しないので処理を飛ばす
		local vehicleCharacter = vehicleObject:GetCharacter()
		local plgBasicAction = vehicleCharacter:FindPluginByName( "TppStrykerBasicAction" )

		-- open
		plgBasicAction:SetBoneRotation( Vector3( -130, 0, 0 ) )

		if( TppMission.GetFlag( "isBombTankFailed" ) == false and TppMission.GetFlag( "isBombTank" ) == false )then
			Fox.Log(" open hatch")
			-- creat geo
			plgBasicAction:AddDefenseTargetResponsiveToGrenadeHit( "SKL_011_HATCHL1", Vector3( 0.0, -0.65, 0.3 ), 0.8 )
			-- サウンド　いびきON
			ibikiOnOff(true)
		else
			--消す処理
			plgBasicAction:RemoveDefenseTargetResponsiveToGrenadeHit()
			ibikiOnOff(false)
		end
	else-- なんでか壊れている感じなのでいびきを消す
		ibikiOnOff(false)
	end
end

this.damageTank = function()
	local vehicleObject = Ch.FindCharacterObjectByCharacterId( "Armored_Vehicle_WEST_001" ) --目的とする車両のCharacterIdを指定する

	if( vehicleObject ~= nil ) then--すでに壊れていたら存在しないので処理を飛ばす
		local vehicle = vehicleObject:GetCharacter()
		local plgLife = vehicle:FindPluginByName( "Life" ) --車両のライフプラグインは全て"Life"という名称です

		local life = 5000
		-- ライフを変更する
		plgLife:RequestSetLife( "Life", life )
		vehicle:SendMessage( ChDamageActionRequest() )
	end
end

local getDemoStartPos = function( demoId )
	Fox.Log(":: get demo start position ::")
	if( demoId ~= nil )then
		Fox.Log( demoId )
		local body = DemoDaemon.FindDemoBody( demoId )
		local data = body.data
		local controlCharacters = data.controlCharacters
		for k, controlCharacter in pairs(controlCharacters) do
			local characterId = controlCharacter.characterId
			Fox.Log("id = " .. characterId )
			local translation = controlCharacter.startTranslation
			Fox.Log("x = " .. translation:GetX() .. " y = ".. translation:GetY() .. " z = " .. translation:GetZ())
			local rotation = controlCharacter.startRotation
			Fox.Log("x = " .. Quat.GetX(rotation) .. " y = ".. Quat.GetY(rotation) .. " z = " .. Quat.GetZ(rotation) .. " w = ".. Quat.GetW(rotation))
			-- プレイヤーの値のみを返す
			if( characterId == "Player")then

				local direction = rotation:Rotate( Vector3( 0.0, 0.0, 1.0 ) )
				local angle = foxmath.Atan2( direction:GetX(), direction:GetZ() )
				local degree = foxmath.RadianToDegree( angle )

				return translation, degree
			end
		end
	end
end


-- 写真を見て、近くにきたらヒント無線
local hint_radio = function()
	Fox.Log( "Hint Radio")
	-- いずれかの無線が再生中であれば今回はスキップ
	local radioDaemon = RadioDaemon:GetInstance()

	--無線の種類に問わず再生中ではない
	if ( radioDaemon:IsPlayingRadio() == false ) then
		TppRadio.Play( "Answer_near" )
	end
end

-- オマージュヘリ用の敵兵チェック
local checkEnemyStatusAndPositon = function()
	Fox.Log(":: start check enemy status and positon ::")
	-- 所定の位置に敵兵がいる数をカウント
	local checkPos0 = TppData.GetPosition( "check_enePos0000" )
	local checkPos1 = TppData.GetPosition( "check_enePos0001" )

	local checkSize = Vector3(5, 5, 5)
	-- 範囲内に何人いるか判定
	local eneCheck0 = TppEnemyUtility.GetNumberOfActiveSoldierByBoxShape( checkPos0,checkSize )
	local eneCheck1 = TppEnemyUtility.GetNumberOfActiveSoldierByBoxShape( checkPos1,checkSize )

	-- それぞれに1体以上いればOK（かけ算で1以上なら）
	local eneCheck = eneCheck0 * eneCheck1
	Fox.Log(eneCheck0)
	Fox.Log(eneCheck1)
	Fox.Log(eneCheck)
	if( eneCheck == 0 )then
		return 0
	else
		return 1
	end

end

local chengeRouteSneak = function( warp )
	if( warp == "warp" )then
		Fox.Log("chenge routeset sneak warp")
		TppCommandPostObject.GsSetCurrentRouteSet( "gntn_cp", "TppRouteSet_n", true, true, true, true )
	else
		Fox.Log("chenge routeset sneak")
		TppCommandPostObject.GsSetCurrentRouteSet( "gntn_cp", "TppRouteSet_n", false, false, false, false )
	end
	if( TppMission.GetFlag( "isRouteSerch1" ) )then
		Fox.Log("isRouteSerch1 is true")
		TppCommandPostObject.GsAddDisabledRoutes( "gntn_cp", "GsRouteData", false )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0006"		, 0, "USSArmmy_000", "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0006"		, 0, "genom_006", "ROUTE_PRIORITY_TYPE_FORCED" )
	else
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData"		, 0, "USSArmmy_000", "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData"		, 0, "genom_006", "ROUTE_PRIORITY_TYPE_FORCED" )
	end
	if( TppMission.GetFlag( "isRouteSerch2" ) )then
		Fox.Log("isRouteSerch2 is true")
		TppCommandPostObject.GsAddDisabledRoutes( "gntn_cp", "GsRouteData0000", false )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0001"	, 0, "USSArmmy_001", "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0001"	, 0, "genom_007", "ROUTE_PRIORITY_TYPE_FORCED" )
	else
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0000"	, 0, "USSArmmy_001", "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0000"	, 0, "genom_007", "ROUTE_PRIORITY_TYPE_FORCED" )
	end
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0002"	, 0, "USSArmmy_008" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0002"	, 0, "genom_002"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0003"	, 0, "USSArmmy_006" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0003"	, 0, "genom_011"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0004"	, 0, "USSArmmy_005" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0004"	, 0, "genom_010"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0005"	, 0, "USSArmmy_004" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0005"	, 0, "genom_001"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0006"	, 0, "USSArmmy_003" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0006"	, 0, "genom_000"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0007"	, 0, "USSArmmy_002" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0007"	, 0, "genom_005"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0008"	, 0, "USSArmmy_025" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0008"	, 0, "genom_013"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0009"	, 0, "USSArmmy_024" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0009"	, 0, "genom_012"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0010"	, 0, "USSArmmy_012" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0010"	, 0, "genom_015"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	if( TppMission.GetFlag( "isRouteSerch3" ) )then
		Fox.Log("isRouteSerch3 is true")
		TppCommandPostObject.GsAddDisabledRoutes( "gntn_cp", "GsRouteData0010_serch", false )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0009"	, 0, "USSArmmy_026" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0009"	, 0, "genom_014"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	else
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0010_serch"	, 0, "USSArmmy_026" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0010_serch"	, 0, "genom_014"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	end

	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0011"	, 0, "USSArmmy_010" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0011"	, 0, "genom_009"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0012"	, 0, "USSArmmy_007" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0012"	, 0, "genom_008"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n",  "GsRouteData0013"	, 0, "USSArmmy_011" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0013"	, 0, "genom_004"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	if( TppMission.GetFlag( "isGetWeapon" ) )then
		 TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0001_mark"	, 0, "USSArmmy_009", "ROUTE_PRIORITY_TYPE_FORCED" )
		 TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0001_mark"	, 0, "genom_003", "ROUTE_PRIORITY_TYPE_FORCED" )
	else
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0001"	, 0, "USSArmmy_009", "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_n", "GsRouteData0001"	, 0, "genom_003", "ROUTE_PRIORITY_TYPE_FORCED" )
	end
end

local chengeRouteCaution = function()
	Fox.Log("chenge routeset caution")
	TppCommandPostObject.GsSetCurrentRouteSet( "gntn_cp", "TppRouteSet_c", false, false, false, false )
	if( TppMission.GetFlag( "isRouteSerch1" ) )then
		Fox.Log("isRouteSerch1 is true")
		TppCommandPostObject.GsAddDisabledRoutes( "gntn_cp", "GsRouteData", false )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0016"		, 0, "USSArmmy_000", "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0016"		, 0, "genom_006", "ROUTE_PRIORITY_TYPE_FORCED" )
	else
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData"		, 0, "USSArmmy_000", "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData"		, 0, "genom_006", "ROUTE_PRIORITY_TYPE_FORCED" )
	end
	if( TppMission.GetFlag( "isRouteSerch2" ) )then
		Fox.Log("isRouteSerch2 is true")
		TppCommandPostObject.GsAddDisabledRoutes( "gntn_cp", "GsRouteData0000", false )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0015"	, 0, "USSArmmy_001", "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0015"	, 0, "genom_007", "ROUTE_PRIORITY_TYPE_FORCED" )
	else
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0000"	, 0, "USSArmmy_001", "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0000"	, 0, "genom_007", "ROUTE_PRIORITY_TYPE_FORCED" )
	end
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0015"	, 0, "USSArmmy_008" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0015"	, 0, "genom_002"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0022"	, 0, "USSArmmy_006" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0022"	, 0, "genom_011"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0022"	, 0, "USSArmmy_005" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0022"	, 0, "genom_010"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0018"	, 0, "USSArmmy_004" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0018"	, 0, "genom_001"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0017"	, 0, "USSArmmy_003" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0017"	, 0, "genom_000"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0014"	, 0, "USSArmmy_002" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0014"	, 0, "genom_005"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0024"	, 0, "USSArmmy_025" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0024"	, 0, "genom_013"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0023"	, 0, "USSArmmy_024" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0023"	, 0, "genom_012"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0021"	, 0, "USSArmmy_012" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0021"	, 0, "genom_015"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	if( TppMission.GetFlag( "isRouteSerch3" ) )then
		Fox.Log("isRouteSerch3 is true")
		TppCommandPostObject.GsAddDisabledRoutes( "gntn_cp", "GsRouteData0010_serch", false )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0023"	, 0, "USSArmmy_026" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0023"	, 0, "genom_014"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	else
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0010_serch"	, 0, "USSArmmy_026" , "ROUTE_PRIORITY_TYPE_FORCED" )
		TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0010_serch"	, 0, "genom_014"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	end
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0019"	, 0, "USSArmmy_010" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0019"	, 0, "genom_009"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0020"	, 0, "USSArmmy_007" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0020"	, 0, "genom_008"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0014"	, 0, "USSArmmy_011" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0014"	, 0, "genom_004"	, "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0016"	, 0, "USSArmmy_009", "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( "gntn_cp", "TppRouteSet_c", "GsRouteData0016"	, 0, "genom_003", "ROUTE_PRIORITY_TYPE_FORCED" )
end


local routeSetChangeFromSerchLight = function()
	Fox.Log("route set change form serch light")
	local phase = TppEnemy.GetPhase( "gntn_cp" )
	if ( phase == "sneak" ) then
		chengeRouteSneak()
	else
		chengeRouteCaution()
	end
end

--localFunc :  failed
local FuncEventFailed = function( flag1)
	local flag2 = flag1.."Failed"
	local chara = TppData.GetArgument( 1 )
	Fox.Log(":: start lFuncEventFailed ::")
	Fox.Log( chara )

	-- サーチライトのルートフラグ
	if ( chara == "gntn_serchlight_20060_1" ) then
		Fox.Log("set flag true : isRoutSet1 ")
		TppMission.SetFlag( "isRouteSerch1", true )
		routeSetChangeFromSerchLight()
	elseif ( chara == "gntn_serchlight_20060_2" ) then
		Fox.Log("set flag true : isRoutSet2")
		TppMission.SetFlag( "isRouteSerch2", true )
		routeSetChangeFromSerchLight()
	end

	if ( TppMission.GetFlag( flag1 ) == false and TppMission.GetFlag( flag2 ) == false) then
		Fox.Log(":: flag is false ::")
		--失敗フラグをたてる
		TppMission.SetFlag( flag2, true )
		--もうダメだ無線
		local phase = TppEnemy.GetPhase( this.cpID )
		if( phase == "sneak")then
			TppRadio.DelayPlay( "Answer_failed","long" ,{onEnd = function()	TppRadio.Play( "Answer_failedTo" ) end} ) --miyata3 に問い詰める
		else
			TppRadio.DelayPlay( "Answer_failedAlert","long" ,{onEnd = function()	TppRadio.Play( "Answer_failedTo" ) end} ) --miyata3 に問い詰める
		end

	end

	if( flag1 == "isBombTank" )then
		Fox.Log(" tank is bomb. close tank hatch")
		tankOpen("close")
	end

	if( flag1 == "isLookMoai" )then
		Fox.Log(" moai is gone. sound")
		-- モアイの破壊音
		local position = Vector3( -158.456, 26.300, -52.760 )
		TppSoundDaemon.PostEvent3D( 'sfx_m_e20060_moai', position )
	end

	if ( flag1 == "isLookHeli" ) then
		Fox.Log(" heli is bomb")
		TppMission.SetFlag( "isHeliBreak", true )
		heliWindowEffect()
	end

	local intel = ""
	-- check flag and Set photo
	if (flag1 == "isLookHeli")then
		intel = "radio_homage_heli"
	elseif (flag1 == "isGetChaffCase")then
		intel = "radio_homage_chaff"
	elseif (flag1 == "isLookCamera")then
		intel = "radio_homage_camera"
	elseif (flag1 == "isLookMoai" )then
		intel = "radio_homage_moai"
	elseif (flag1 == "isBombTank")then
		intel = "radio_homage_tank"
	end

	-- あれば諜報削除
	if( intel ~= "" )then
		Fox.Log("delite intel radio : "..intel )
		TppRadio.DisableIntelRadio( intel )
	end



	Fox.Log(":: end FuncEventFailed ::")
end

--localFunc : near or to fail
local FuncNearRadio = function( flag1,type)
	--フラグの確認
	local failed = flag1.."Failed"
	local photo = flag1.."Photo"

	if( TppMission.GetFlag( flag1 ) == false and TppMission.GetFlag( failed ) == false) then
		Fox.Log(":: local FuncNearRadio :: failed :: "..type)

		if( type == "near" )then
			if ( TppMission.GetFlag( photo ) == true ) then
			Fox.Log(":: local FuncNearRadio :: NEAR ::")
			--近いぞ無線
			hint_radio()
			end
		else
			Fox.Log(":: local FuncNearRadio :: OHTER ::")
		end
	end
end

-- common func for event ------------------------
local challengeChancel = function()
	Fox.Log("challenge chansel")
	if ( TppMission.GetFlag( "isMarkMGS3" ) == false )then

		local mark = PlayRecord.IsMissionChallenge( "DELETE_XOF_MARK" )
		if mark == true then
			TppCharacterUtility.SetEnableCharacterId( "e20060_logo_008", false )
			-- チャレンジ失敗のリクエスト
			PlayRecord.UnsetMissionChallenge( "DELETE_XOF_MARK" )
		end
	end

	TppMission.SetFlag( "isBreakWood", true )

end

local challengeChancelFox = function()
	Fox.Log("challenge chansel FOX")
	if( TppMission.GetFlag( "isMakeFox" ) == false )then

		local mark = PlayRecord.IsMissionChallenge( "CREATE_FOX_MARK" )
		if mark == true then
			-- チャレンジ失敗のリクエスト
			PlayRecord.UnsetMissionChallenge( "CREATE_FOX_MARK" )
		end
	end
end

local challengeChancelLA = function()
	Fox.Log("challenge chansel LA")
	if( TppMission.GetFlag( "isMakeLA" ) == false )then
		Fox.Log("set flag true : isRoutSet3")
		TppMission.SetFlag( "isRouteSerch3", true )
		routeSetChangeFromSerchLight()

		local mark = PlayRecord.IsMissionChallenge( "CREATE_FOX_MARK" )
		if mark == true then
			-- チャレンジ失敗のリクエスト
			PlayRecord.UnsetMissionChallenge( "CREATE_FOX_MARK" )
		end
	end
end

-- フェイズチェック
local PhaseCheck = function()
	Fox.Log(":: phase check ::")
	local phase = TppEnemy.GetPhase( this.cpID )
	if( phase == "alert")then
		Fox.Log(":: phase is false - "..phase)
		return false
	else
		Fox.Log(":: phase is true - "..phase)
		return true
	end
end

-- クリアフラグを数えて無線を流す
local EventClearRadio = function(flagName,checkPointId)

		local voice = ""
		local radioId = ""
		local delay = "short" -- ミラー無線のディレイ

		-- 懐かしいセリフの選定　どのオマージュかで判定
		-- プレイヤー音声
		if (flagName == "isLookHeli")then
			voice = "Sneak_Natsui00"-- 懐かしい
		elseif (flagName == "isGetChaffCase" )then
			voice = "Sneak_Natsui01"-- 懐かしすぎる
		elseif (flagName == "isLookMoai" )then
			voice = "Sneak_Natsui03"-- 覚えてないな
		elseif (flagName == "isBombTank" )then
			voice = "Sneak_Natsui02"-- おお！
		end

		-- check clear flag for first time
		if( TppMission.GetFlag( "isClear" ) == false ) then
			Fox.Log(":: EventClearRadio 1 ::")
			TppMission.SetFlag( "isClear", true)
			--1なら無線を鳴らす（クリア可能ですよ）
			radioId = "fondHomage1"

			-- ゴールマーカー
			TppMarkerSystem.EnableMarker{ markerId="e20060_marker_GoalPoint", viewType="VIEW_MAP_GOAL" }

			commonAnnounceLogMission("announce_mission_goal")
			commonAnnounceLogMission("announce_mission_info_update")

			-- 任意無線を切り替える
			commonSetOptRadio()

			--中間目標を更新
			commonChangeMissionSubGoal()
			-- ゴールを開ける
			TppDataUtility.SetVisibleDataFromIdentifier( "asset_base", "TestKey0", false, false )
			TppDataUtility.SetVisibleDataFromIdentifier( "asset_base", "gntn_vent001_0001", true, false )
			--TppData.HideModel( "goalFuta" )
		else
			--2回目以降
			Fox.Log(":: EventClearRadio 2-::")
			radioId = "fondHomage2"

		end

		-- check complate of homage flag
		if (	TppMission.GetFlag( "isLookHeli" ) == true and
				TppMission.GetFlag( "isGetChaffCase" ) == true and
				TppMission.GetFlag( "isLookCamera" ) == true and
				TppMission.GetFlag( "isLookMoai" ) == true and
				TppMission.GetFlag( "isBombTank" ) == true and
				TppMission.GetFlag( "isRunVehicle" ) == true and
				TppMission.GetFlag( "isTurnOffPanel" ) == true
			) then
			Fox.Log(":: EventClearRadio Comp ::")
			-- コンプリートしたときの処理
			radioId = "complateHomage"
			delay = "long"

			TppMission.SetFlag( "isClearComp", true)
			--任意無線を切り替える
			commonSetOptRadio()
			--ミッション失敗演出（無線コール、サウンドコール）
			TppMusicManager.PostJingleEvent( 'SuspendPhase', 'Play_bgm_e20060_jingle_item' ) 
			--TppSound.PlayEvent( "Play_bgm_e20060_jingle_item" )	--2013.10.04 SD班依頼により追加 by yamamoto
		end

		-- 懐かしいセリフがあれば再生
		if( voice ~= "" )then
			Fox.Log(":: EventClearRadio Player voice::")
			if ( delay ~= "long" ) then --コンプリート時は言わない
				Fox.Log("na tsu ka shi!!! "..voice.." : delay = "..delay )
				TppRadio.DelayPlay( voice, delay, "none" )
			end
		end


		-- 無線を流す
		Fox.Log(":: play radio ::")
		Fox.Log(radioId)

		TppRadio.DelayPlayEnqueue( radioId,delay,"both" )

		--check point
		TppMissionManager.SaveGame(checkPointId)
end

-- フラッシュバックデモが終わったら呼ばれるチェック関数
local clearFlagCheck = function( flagName,checkPointId )
	Fox.Log(":: playDemoForHomage clearFlagCheck::")
	--set flag
	local count = TppMission.GetFlag( "isCountClear" )
	count = count+1
	TppMission.SetFlag( "isCountClear", count )

	Fox.Log(count)
	--photo reload
	commonDisablePhoto( flagName )

	EventClearRadio(flagName,checkPointId)

	if( flagName == "isBombTank" )then
		-- ライフ変更
		this.damageTank()
	end

	if( flagName == "isTurnOffPanel") then
		--敵兵停電挙動用トラップＯＮ
		TppDataUtility.SetEnableDataFromIdentifier( "gntn_Trap", "SwitchLightArea", true , false )
	end

	-- add score, homage BONUS. mini 0 max 14000
	PlayRecord.PlusExternalScore( 5000 )

	-- 天候タグを変えているときがあるので戻す
	WeatherManager.RequestTag("default", 0 )

	-- ルートの初期化
	if(flagName == "isLookHeli")then
		chengeRouteSneak()
	else
		chengeRouteSneak("warp")
	end

	TppUI.FadeIn(0)
end

-- プレイヤーの位置補正
local playerPositonSetForDemo = function(r)

	Fox.Log("::  player Pos :: r = "..r)
	--　安全のため一旦オフ
	--TppPlayerUtility.RequestToStartTransition{stance="Stand",direction=r,doKeep=false}

end

--敵兵をデモで消えないようにする
local notRealizeCharacter = function(route)
	Fox.Log(":: not Realize character ::")
	--指定したルート上にいる敵兵をデモで消えないようにする
	-- デモ前に呼ばれる

	local eneId1,eneId2 = TppEnemyUtility.GetCharacterIdByRoute( this.cpID, route )
	if ( eneId1 ~= nil)then
		Fox.Log( "eneId1 = "..eneId1 )
		MissionManager.RegisterNotInGameRealizeCharacter( eneId1 )
	end
	if ( eneId2 ~= nil)then
		Fox.Log( "eneId2 = "..eneId2 )
		MissionManager.RegisterNotInGameRealizeCharacter( eneId2 )
	end

end


-- 条件を満たしたときに実行-- デモの再生-- フラグの処理
local playDemoForHomage = function( demoName, flagName,checkPointId,r )
	Fox.Log(":: playDemoForHomage ::")

	-- 角度調整指定あれば変更
	if ( r ~= nil ) then
		Fox.Log(":: change transition ::")
		playerPositonSetForDemo(r)
	end

	GZCommon.StopAlertSirenCheck()

	Fox.Log(":: playDemoForHomage - check flag ::")
	if( TppMission.GetFlag( flagName ) == false  ) then
		TppMission.SetFlag( flagName, true)


		if( flagName == "isLookHeli" )then
			Fox.Log("not Realize : Heli")
			notRealizeCharacter("GsRouteData0013")
			notRealizeCharacter("GsRouteData0007")
		end
		if( flagName == "isLookCamera" )then
			Fox.Log("not Realize : Camera")
			notRealizeCharacter("GsRouteData0002")
		end

		-- デモのセットアップ
		local demoInterpCameraId = this.DemoList[demoName]
		Fox.Log(demoInterpCameraId)
		TppDemoUtility.Setup(demoInterpCameraId)

		TppDemo.Play( demoName,{onEnd = function() clearFlagCheck(flagName,checkPointId) end} )
	end

end

-- commonMbDvcActWatchPhoto
local commonMbDvcActWatchPhoto = function()
--写真を見たときにヒントを言う
	local PhotoID = TppData.GetArgument(1)
	local radioNum = ""
	local flagNum = ""
	local intel = ""

	Fox.Log( "commonMbDvcActWatchPhoto"..PhotoID )

	if( PhotoID == 10 ) then
		if( TppMission.GetFlag( "isLookHeli" ) == false )then -- オマージュ達成前なら値をいれる
			radioNum = "Hint_heli"
			flagNum = "isLookHeliPhoto"
			intel = "radio_homage_heli"
		end
	elseif( PhotoID == 20 ) then
		if(TppMission.GetFlag( "isGetChaffCase" ) == false)then -- オマージュ達成前なら値をいれる
			radioNum = "Hint_chaff"
			flagNum = "isGetChaffCasePhoto"
			intel = "radio_homage_chaff"
		end
	elseif( PhotoID == 30 ) then
		if( TppMission.GetFlag( "isLookCamera" ) == false )then -- オマージュ達成前なら値をいれる
			radioNum = "Hint_camera"
			flagNum = "isLookCameraPhoto"
			intel = "radio_homage_camera"
		end
	elseif( PhotoID == 40 ) then
		if( TppMission.GetFlag( "isRunVehicle" ) == false )then -- オマージュ達成前なら値をいれる
			radioNum = "Hint_vehicle"
			flagNum = "isRunVehiclePhoto"
		end
	elseif( PhotoID == 50 ) then
		if( TppMission.GetFlag( "isLookMoai" ) == false )then -- オマージュ達成前なら値をいれる
			radioNum = "Hint_moai"
			flagNum = "isLookMoaiPhoto"
			intel = "radio_homage_moai"
		end
	elseif( PhotoID == 60 ) then
		if( TppMission.GetFlag( "isBombTank" ) == false )then -- オマージュ達成前なら値をいれる
			radioNum = "Hint_tank"
			flagNum = "isBombTankPhoto"
			--intel = "radio_homage_tank"
		end
	elseif( PhotoID == 70 ) then
		if( TppMission.GetFlag( "isTurnOffPanel" ) == false )then -- オマージュ達成前なら値をいれる
			radioNum = "Hint_switch"
			flagNum = "isTurnOffPanelPhoto"
		end
	end

	-- あれば諜報無線の適応
	if ( intel ~= "") then
		TppRadio.EnableIntelRadio( intel )
	end

	if( radioNum == "Hint_switch" )then
		--　黒写真のときだけ特別扱い（無線の順番がある）
		if( TppMission.GetFlag( "isTurnOffPanelPhoto" ) == false )then
			TppRadio.Play( "Hint_switch0")
			TppMission.SetFlag( "isTurnOffPanelPhoto", true )
		else
			TppRadio.Play( "Hint_switch" )

		end
	elseif ( radioNum ~= nil) then -- その他もの。 nil のときはすでにオマージュを見ていたとき（鳴らない）
		-- ラジオ再生
		TppRadio.Play( radioNum )
		-- 見たフラグを立てる
		TppMission.SetFlag( flagNum, true )
	end

end

-- クレイモアを拾ったら実行
local charengeClaymoreCount = function()
	if(TppData.GetArgument( 1 ) == "WP_Claymore")then

		-- トライアル有効時のみ
		local crymore = PlayRecord.IsMissionChallenge( "CLAYMORE_RECOVERY" )
		if crymore == true then

			local count = TppMission.GetFlag( "isCountClaymore" )
			count = count + 1
			TppMission.SetFlag( "isCountClaymore", count )

			commonAnnounceLogMission("announce_allGetClaymore",	count,	5)

			--判定によってログを出したい
			if (count == 5) then
				PlayRecord.RegistPlayRecord( "CLAYMORE_RECOVERY" )
			end
		end

	end

end

-- クレイモアを設置したら発動　カウントを戻す
local charengeClaymorePut = function()
	if(TppData.GetArgument( 1 ) == "WP_Claymore")then

		local count = TppMission.GetFlag( "isCountClaymore" )
		count = count - 1
		if ( count < -9 ) then
			count = -9
		end
		TppMission.SetFlag( "isCountClaymore", count )
	end
end


------------- チャレンジ ------------

-- 武器やチャフを拾ったとき
local checkPickUpAmmo = function()
	Fox.Log(":: check pick up ammo ::")
	if(TppData.GetArgument( 1 ) == "WP_SmokeGrenade" )then
		-- グレネードだったら（チャフの条件）

		local cPos = TppData.GetPosition( "check_pos" )
		local player = Ch.FindCharacterObjectByCharacterId( "Player")
		local pPos = player:GetPosition()

		local dist = TppUtility.FindDistance( pPos, cPos )
		Fox.Log(dist)

		-- プレイヤーが所定の位置以内にいたら（他のグレネードと区別するため距離で判定）
		if( dist < 10 )then
			Fox.Log("dist OK")
			-- フラグを確認して実行
			if( TppMission.GetFlag( "isGetChaffCase" ) == false and TppMission.GetFlag( "isGetChaffCaseFailed" ) == false ) then
				Fox.Log("flag OK")
				local phase = TppEnemy.GetPhase( this.cpID )
				if( phase == "alert")then
					--アラートだったら失敗
					Fox.Log("phase NG")
					FuncEventFailed("isGetChaffCase")
				else
					-- アラートで内ならデモ発動
					Fox.Log("phase OK")
					playDemoForHomage( "Demo_FlashGetChaffCase", "isGetChaffCase","1200" )
				end
			end
		end
	elseif (TppData.GetArgument( 1 ) == "WP_ar00_v03b" ) then
		-- 金属中マーカー用の武器なら
		TppRadio.Play( "Metal_mistakeGun" )
		TppMission.SetFlag( "isGetWeapon", true )
		TppEffect.HideEffect( "fx_weaponLight")

		-- ルートの割り当てを変更する
		Fox.Log("change route")
		TppCommandPostObject.GsDeleteDisabledRoutes( 	this.cpID, this.markRouteAf )
		TppCommandPostObject.GsAddDisabledRoutes( 		this.cpID, this.markRouteBe )


	elseif (TppData.GetArgument( 1 ) == this.trackWeapon1 ) then
		-- トラックのハンドガンだったら
		TppMission.SetFlag( "isGetHandGun", true )

	elseif (TppData.GetArgument( 1 ) == this.trackWeapon2 ) then
		-- トラックのショットガン
		--フラグを立ててコンテニューででないようにする
		TppMission.SetFlag( "isGetShotGun", true )

	end
end

--金属虫マーカー　タイトルロゴ消し
local findTitleLogoMark = function(num)
	Fox.Log(":: find Mark ::")

	if( num ~= 10 ) then
		--正解の時
		local count = TppMission.GetFlag( "isCountTitleLogo" )
		count = count + 1
		if (count >= 8) then
			count = 8
		end
		TppMission.SetFlag( "isCountTitleLogo", count )

		local text = "debug "..count
		Fox.Log( "HitLight : "..count)

		-- radio play
		if ( count == logoMax ) then
			-- クリアした
			TppMission.SetFlag( "isTitleComp", true )

			TppRadio.Play( "Metal_allClear")
			--問題ないなら以下のコメントアウトを外して貰う（miyata 2013/11/17）
			TppRadio.DelayPlayEnqueue( "Metal_Clear", "mid" )

			-- 尋問、マーカーを初期化
			Fox.Log("Jinmon remove from find title logo mark")
			removeAllJinmon()

			local mark = PlayRecord.IsMissionChallenge( "DELETE_XOF_MARK" )
			if mark == true then
				-- announce log
				commonAnnounceLogMission(langXOF,8,logoMax)
				--commonAnnounceLogMission(langLogo)
				PlayRecord.RegistPlayRecord( "DELETE_XOF_MARK" )
			end
		else
			Fox.Log("count under 8.")
			local mark = PlayRecord.IsMissionChallenge( "DELETE_XOF_MARK" )
			if mark == true then
				Fox.Log("announce log"..count )
				-- announceLog
				commonAnnounceLogMission(langXOF,count,logoMax)
			end
			-- 正解ラジオ
			TppRadio.DelayPlay( "Metal_int","short" )
		end

		-- マーカーを消す
		local disMark = "e20060_logo_00"..num
		Fox.Log("Hide marker : "..disMark )

		TppMarkerSystem.DisableMarker{ markerId=disMark }
		-- 対応する尋問を制御
		Fox.Log("setting JinMon enemy")
		local characterId = ""
		local characterIdLow = ""

		-- num から対応する敵兵を設定 delite this
		local flagID = ""
		local locatorID = ""
		if( num == 1)then
			flagID = "isMarkMGSPW"
			characterId, characterIdLow = "USSArmmy_000","genom_006"
		elseif( num == 2)then
			locatorID = "intelMark_mgs"
			flagID = "isMarkMGS"
			characterId, characterIdLow = "USSArmmy_011","genom_004"
		elseif( num == 3)then
			locatorID = "intelMark_mg"
			flagID = "isMarkMG"
			characterId, characterIdLow = "USSArmmy_007","genom_008"
		elseif( num == 4)then
			locatorID = "intelMark_mgs4"
			flagID = "isMarkMGS4"
			characterId, characterIdLow = "USSArmmy_009","genom_003"
		elseif( num == 5)then
			locatorID = "intelMark_mgs2"
			flagID = "isMarkMGS2"
			characterId, characterIdLow = "USSArmmy_012","genom_015"
		elseif( num == 6)then
			locatorID = "intelMark_gz"
			flagID = "isMarkGZ"
			characterId, characterIdLow = "USSArmmy_002","genom_005"
		elseif( num == 7)then
			locatorID = "intelMark_mg2"
			flagID = "isMarkMG2"
			characterId, characterIdLow = "USSArmmy_024","genom_012"
		elseif( num == 8)then
			locatorID = "intelMark_mgs3"
			flagID = "isMarkMGS3"
			characterId, characterIdLow = "USSArmmy_005","genom_010"
		end
		--flag の更新
		TppMission.SetFlag( flagID, true )
		-- 諜報無線の削除
		TppRadio.DisableIntelRadio( locatorID )
		-- ヘリのマーカーについて更新
		setHeliMarker()
	else
		--不正解のとき
		TppRadio.Play( "Metal_wrong" )
	end
end


------------- チャレンジ2 ------------
--KJPマークを見つけた時に無線
local findFoxLogo = function()
	if( TppMission.GetFlag( "isMakeFox" ) == false and TppMission.GetFlag( "isMakeLA" ) == false )then
		TppRadio.Play( "Light_near" )
	end
end

--サーチライトを当てたときに判定
local highlightFoxLogo = function(type)
	Fox.Log(":: highLight fox logo ::")
	-- 判定したサーチライトによって判定、FOXorLA

	if ( PhaseCheck() == true ) then
		Fox.Log(type)

		local demo = ""
		local radio = ""
		local flag = ""
		if( type == "fox" and TppMission.GetFlag( "isMakeFox" ) == false )then
			flag = "isMakeFox"
			radio = "Light_clear"
			demo = "Demo_FoxLightKJP"

		elseif(type=="la" and TppMission.GetFlag( "isMakeLA" ) == false)then
			flag = "isMakeLA"
			radio = "Light_clearLA"
			demo = "Demo_FoxLightLA"
		end

		local onDemoStart = function()
		end
		local onDemoEnd = function()
			Fox.Log("on dmeo end")
			TppMission.SetFlag( flag, true )

			if (TppMission.GetFlag( "isMakeLA" ) == true and TppMission.GetFlag( "isMakeFox" ) == true) then
				-- クリアした
				Fox.Log("clear !!")
				--　トライアル有効時のみ
				local mark = PlayRecord.IsMissionChallenge( "CREATE_FOX_MARK" )
				if mark == true then
					commonAnnounceLogMission(langMarkLA)
					PlayRecord.RegistPlayRecord( "CREATE_FOX_MARK" )
				end
			elseif (TppMission.GetFlag( "isMakeLA" ) == true or TppMission.GetFlag( "isMakeFox" ) == true) then
				local mark = PlayRecord.IsMissionChallenge( "CREATE_FOX_MARK" )
				if mark == true then
					commonAnnounceLogMission(langMark)
				end
			end

		   --TppMissionManager.SaveGame()
		end

		if( demo ~= "")then
			Fox.Log(":: play fox light demo ::")
			TppDemo.Play( demo ,{ onStart = onDemoStart, onEnd = onDemoEnd},{
			  disableGame = false,			--共通ゲーム無効を、キャンセル
			  disableDamageFilter = false,	--エフェクトは消さない
			  disableDemoEnemies = false,	--敵兵は消さないでいい
			  disableHelicopter = false,	--支援ヘリは消さないでいい
			  disablePlacement = false, 	--設置物は消さないでいい
			  disableThrowing = false	 --投擲物は消さないでいい
			})
		end

	TppRadio.DisableIntelRadio( "radio_kjpLogo" )
		--クリアの判定
	end
end

-- クレイモアでダメージを受けた
local DamagedOnClaymore = function()
	-- フラグを見て判定
	Fox.Log(":: Damaged claymore ::")
	if( (TppData.GetArgument( 1 ) == "WP_Claymore" ) and TppMission.GetFlag( "isFailedClaymore" ) == false) then

		local crymore = PlayRecord.IsMissionChallenge( "CLAYMORE_RECOVERY" )
		if crymore == true then
			Fox.Log("charenge failed - flag On!!")
			-- チャレンジ失敗フラグを立てる
			TppMission.SetFlag( "isFailedClaymore", true )
			-- チャレンジ失敗のリクエスト
			PlayRecord.UnsetMissionChallenge( "CLAYMORE_RECOVERY" )
		end
	end
end

-- アイテムをひろった　カセットテープの入手
local Common_PickUpItem = function()
	--　カセットテープだったら
	if TppData.GetArgument( 1 ) == "IT_Cassette" then
		Fox.Log(":: Pick up Cassette ::")
		local uiCommonData = UiCommonDataManager.GetInstance()
		uiCommonData:GetBriefingCassetteTape( "tp_bgm_04" )
	end
end

this.Common_DoorOpen = function()
	Fox.Log(" Open the door Paz. ")
	TppGadgetUtility.SetDoor{ id = "Paz_PickingDoor00", isVisible = true, isEnableBounder = true, isEnableTacticalActionEdge = true , angle = -90, isOpen = true }
end

this.Common_DoorUnlock = function( flag )
	Fox.Log(":: Common Door Unlock ::")

	local id = TppData.GetArgument( 1 )

	if ( id == "AsyPickingDoor24" and TppMission.GetFlag( "isHostageDead1" ) == true )then
		-- チコパスなら例外対応　フラグ見て通すかどうか
		flag = "chico"
	end
	if ( id == "Paz_PickingDoor00" and TppMission.GetFlag( "isHostageDead2" ) == true and TppMission.GetFlag( "isPazDoor" ) == false )then
		-- チコパスなら例外対応　フラグ見て通すかどうか
		TppMission.SetFlag( "isPazDoor", true )
		flag = "paz"
	end


	if(    id == "Asy_PickingDoor"
		or id == "AsyPickingDoor01"
		or id == "AsyPickingDoor17"
		or id == "AsyPickingDoor21"
		or id == "StartCliff_PickingDoor01"
		or id == "WareHousePickingDoor01"
		or id == "Center_PickingDoor01"
		or id == "Center_PickingDoor02"
		or id == "WP_HouseDoor01"
		or id == "WP_HouseDoor02"
		or id == "WP_HouseDoor03"
		or flag == "chico"
		or flag == "paz"
	)then

		if ( flag ~= nil )then
			Fox.Log("Open the door Demo :"..flag )
		else
			Fox.Log( "Open the door : "..id )
		end


		local counter = TppMission.GetFlag( "isDoorCounter" )
		counter = counter + 1
		TppMission.SetFlag( "isDoorCounter", counter )

		Fox.Log("Unlock Door : "..counter )

		-- トライアル有効時のみ　結果を出す
		local door = PlayRecord.IsMissionChallenge( "OPEN_DOOR" )
		if door == true then
			if (counter == this.doorMax)then
				Fox.Log("clear")
				PlayRecord.RegistPlayRecord( "OPEN_DOOR" )

			elseif (counter < this.doorMax	) then
				Fox.Log("count")
				commonAnnounceLogMission(langDoor,	counter,	this.doorMax)

			end
		end
	end
end
-------------------------------------------------------------------------------
-- 開始無線制御
------------------------------------------------------------------------------
-- 今回のミッションについてしゃべりおえた！
local radioStartCheckEndOfKonkai = function()
	Fox.Log(":: radioStartCheckEndOfKonkai ::")
	this.SetIntelRadio()
	TppMission.SetFlag( "isRadioEndOfKonkai",true )

	-- アラスカこえてたら　アラスカを言う、　じゃないまで来てたら何もしない
	if( TppMission.GetFlag( "isRadioJanai" ) == false and TppMission.GetFlag( "isRadioAraskaTrap" ) == true )then
		-- アラスカ～じゃなーい無線
		if ( TppMission.GetFlag( "isRadioJanai" ) == false )then
			TppRadio.DelayPlayEnqueue( "neta_start","short","begin" ,{onEnd=function()TppRadio.DelayPlay( "neta_start2",nil,"end" ) end})
		end
	end
end

-- 「アラスカ」トラップに入った
local radioStartCheckAraska = function()
	Fox.Log(":: radioStartCheckAraska ::")
	TppMission.SetFlag( "isRadioAraskaTrap",true )
	TppMission.SetFlag( "isRadioAraskaSay",false )

	-- 今回の　を言い終わっていたら
	if ( TppMission.GetFlag( "isRadioEndOfKonkai" ) ) then
		-- アラスカ～じゃなーい無線
		if ( TppMission.GetFlag( "isRadioJanai" ) == false )then
			TppRadio.DelayPlayEnqueue( "neta_start",nil,"begin" ,{onEnd=function()TppRadio.DelayPlay( "neta_start2",nil,"end" ) end})
		end
	end
end

-- 「じゃない」トラップに入った
local radioNetaCheckJanai = function()
	Fox.Log(":: radioStartCheckJanai ::")
	TppMission.SetFlag( "isRadioJanai",true )

	-- アラスカを言っている
	if( TppMission.GetFlag( "isRadioAraskaSay" ) == true )then
		-- 今回の　が終わってないなら「いつもの」をスタック
		if( TppMission.GetFlag( "isRadioEndOfKonkai" ) == false )then
			TppRadio.DelayPlayEnqueue( "Miller_op002","short" )
		elseif( TppMission.GetFlag( "isRadioEndOfKonkai" ) == true and TppMission.GetFlag( "isRadioAraskaTrap" ) == true )then
			-- 今回のが終わってたら　じゃなーい
			TppRadio.DelayPlay( "neta_start2",nil,"end" )
		end
	end
end

local radioStartCheck = function()
	Fox.Log(":: radio start check ::")
	local check = TppData.GetArgument( 1 )
	-- アラスカの無線だったらフラグを立てる
	if ( check == "e0060_rtrg0140" ) then
		TppMission.SetFlag( "isRadioAraskaSay",true )
	else
		TppMission.SetFlag( "isRadioAraskaSay",false )
	end

end

local netaDoor = function()
	local player = Ch.FindCharacterObjectByCharacterId( "Player")
	local pPos = player:GetPosition()

	TppSoundDaemon.PostEvent3D( 'Play_sfx_s_norm_ng_buzzer_1', pPos )
	TppRadio.DelayPlay( "neta_door","short" )

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- radio
------------------------------------------------------------------------------------------------------------------------------------------------------------------
local RadioNearHostage = function( num )
	Fox.Log(":: Radio near hostage ::")
	-- 捕虜が近い無線
	--捕虜が死んでいたら流さない
	local status = "Normal"
	if (num == 1) then
		-- チコ側
		if (TppGameSequence.GetGameFlag("playerSkinMode" ) ~= 0)  then
			status = TppHostageUtility.GetStatus( "Hostage_e20060_002" )
		else
			status = TppHostageUtility.GetStatus( "Hostage_e20060_000" )
		end

	elseif (num  ==2 ) then
		-- パス側
		if (TppGameSequence.GetGameFlag("playerSkinMode" ) ~= 0)  then
			status = TppHostageUtility.GetStatus( "Hostage_e20060_003" )
		else
			status = TppHostageUtility.GetStatus( "Hostage_e20060_001" )
		end

	end

	Fox.Log(status)

	if (status == "Normal" )then
		if( PhaseCheck() == true )then
			-- not alert
			TppRadio.DelayPlayEnqueue( "Near_Hostage", "short" )
		else
			-- alert
			TppRadio.DelayPlayEnqueue( "Radio_AlertHostage", "short" )
		end
	end
end

local checkHostageStatus = function( num )
	Fox.Log(":: checkHostageStatus ::")
	--該当の捕虜が死んでいたらデモを流さない
	local status = "Normal"

	-- num でチコ檻かパス檻を区別
	if (num == 1) then		-- チコ側
		-- ローポリかどうか区別
		if (TppGameSequence.GetGameFlag("playerSkinMode" ) ~= 0)  then
			status = TppHostageUtility.GetStatus( "Hostage_e20060_002" )
		else
			status = TppHostageUtility.GetStatus( "Hostage_e20060_000" )
		end
	elseif (num  ==2 ) then		-- パス側
		if (TppGameSequence.GetGameFlag("playerSkinMode" ) ~= 0)  then
			status = TppHostageUtility.GetStatus( "Hostage_e20060_003" )
		else
			status = TppHostageUtility.GetStatus( "Hostage_e20060_001" )
		end
	end
	Fox.Log(status)
	-- 死亡以外は Normal を返す
	if( status == "Dead" )then
		return "Dead"
	else
		return "Normal"
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SetUp
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ミッションセットアップ
this.onMissionPrepare = function()
	-- 装備品設定
	TppPlayer.SetWeapons( GZWeapon.e20060_SetWeapons )

end
---------------------------------------------------------------------------------
-- Sequences
---------------------------------------------------------------------------------
-- ミッション起動前
this.Seq_MissionPrepare = {
	OnEnter = function()
		this.onMissionPrepare()

		-- 難易度別にこれまでの戦績に応じて報酬アイテムを設置。同時にミッション開始時点でのBestRankを保持しておく
		this.tmpBestRank = GZCommon.CheckClearRankReward( this.missionID, this.ClearRankRewardList )
		Fox.Log( ":: e20060.tmpBestRank_IS__"..this.tmpBestRank )


		lowPolyPlayer()--ローポリスネーク　判定あれば切り替える

		-- これまでに獲得している報酬数を保持
		local uiCommonData = UiCommonDataManager.GetInstance()
		this.tmpRewardNum = uiCommonData:GetRewardNowCount( this.missionID )
		Fox.Log("***e20060_MissionPrepare.tmpRewardNum_IS___"..this.tmpRewardNum)

		TppSequence.ChangeSequence( "Seq_MissionSetup" )
	end,

}
---------------------------------------------------------------------------------
this.Seq_MissionSetup = {

	OnEnter = function()
		MissionSetup()
		TppSequence.ChangeSequence( "Seq_OpeningDemoLoad" )
	end,
}

---------------------------------------------------------------------------------
this.Seq_OpeningDemoLoad = {

	OnEnter = function()
		onDemoBlockLoad()
	end,

	OnUpdate = function()
		-- デモブロックをロードするまで待機
		--if( TppMission.IsDemoBlockActive() ) then --フォーカス用
		if( IsDemoAndEventBlockActive() ) then
			TppSequence.ChangeSequence( "Seq_OpeningShowTransition" )
		end
	end,
}

---------------------------------------------------------------------------------
this.Seq_OpeningShowTransition = {
	OnEnter = function()
		local localChangeSequence = {
			onOpeningBgEnd = function()
				TppSequence.ChangeSequence( "Seq_OpeningDemo" ) --テロップの絵が消えるくらいで関数を実行
			end,
		}
		TppUI.ShowTransition( "opening", localChangeSequence )
		TppMusicManager.PostJingleEvent( "MissionStart", "Play_bgm_gntn_op_default_intro" )
	end,
}
---------------------------------------------------------------------------------
this.Seq_OpeningDemo = {
	Messages = {
		Timer = {
			{ data = "delayFadeIn", message = "OnEnd", commonFunc = function() TppUI.FadeIn(0.7) end },
		}
	},
	OnEnter = function()

		TppDemo.Play( "Demo_Opening", { 
			onStart = function() 
				TppTimer.Start( "delayFadeIn", 0.2 )
				--TppUI.FadeIn(0.7) 
			end, 
			onEnd = function()
			 	TppSequence.ChangeSequence( "Seq_OpeningDemoEnd" ) 
			end
		 } )
	end,
}
---------------------------------------------------------------------------------
this.Seq_OpeningDemoEnd = {
	OnEnter = function()
		--checkpoint
		TppMissionManager.SaveGame(1000)

		TppSequence.ChangeSequence( "Seq_MissionLoad" )
	end,
}
---------------------------------------------------------------------------------
--Demo

this.Seq_MissionLoad = {
	OnEnter = function()
		-- Mission Photo
		commonPhotoMissionSetup()

		--TppRadio.Play( "Miller_op000" )
		TppRadio.DelayPlay( "Miller_op000", "short",nil,{onEnd =function() radioStartCheckEndOfKonkai() end })

		TppSequence.ChangeSequence( "Seq_MissionStart" )
	end,
}

--Game
---------------------------------------------------------------------------------
this.Seq_MissionStart = {

	-- イベント条件クリアチェック処理 --
	--localFunc ：　ヘリのチェック（ヘリを見たとき）
	FuncCheckLookHeli = function()
		--フラグとフェイズの確認 isHeli
		if ( PhaseCheck() == true ) then
			if( TppMission.GetFlag( "isLookHeli" ) == false and TppMission.GetFlag( "isLookHeliFailed" ) == false) then
				--if
				local checkA = checkEnemyStatusAndPositon()
				Fox.Log(checkA)
				if( checkA ~= 0) then
					--playerPositonSetForDemo( "Demo_LookHeli", "isLookHeli","1100",-30 )
					playDemoForHomage( "Demo_LookHeli", "isLookHeli","1100",-30 )
				else
					TppRadio.Play( "Answer_no" )
				end
			end
		end
	end,
	FuncFailedHeli = function()
		if( TppMission.GetFlag( "isLookHeli" ) == false and TppMission.GetFlag( "isLookHeliFailed" ) == false) then
				TppRadio.Play( "Answer_noHeli" )
		end
	end,

	--localFunc : カメラのチェック(カメラを見たとき)
	FuncCheckLookCamera = function()
		Fox.Log(":: FuncCheckLookCamera ::")
		--フラグの確認 isCamera
		if ( PhaseCheck() == true ) then
			if( TppMission.GetFlag( "isLookCamera" ) == false and TppMission.GetFlag( "isLookCameraFailed" ) == false) then

				playDemoForHomage( "Demo_LookCamera", "isLookCamera","1300",-90 )
			end
		end
	end,

	--localFunc : 戦車（グレネードを入れたとき）
	FuncCheckBombTank = function()
		--フラグの確認 isTank
		if ( PhaseCheck() == true ) then
			if( TppMission.GetFlag( "isBombTank" ) == false and TppMission.GetFlag( "isBombTankFailed" ) == false) then
				tankOpen("close")
				local demoNameTank = "Demo_BombTank"

				--プレイヤーの向きを計算　4方向
				local r = 0
				local enePos = Vector3(-195.208, 26.346, 235.094)
				local player = Ch.FindCharacterObjectByCharacterId( "Player")
				local pos = player:GetPosition()

				local hikaku = pos - enePos

				if (hikaku:GetX() > 0 )then
					if (hikaku:GetZ() > 0 )then
						r = 215
					else
						r = 315
					end
				else
					if (hikaku:GetZ() > 0 )then
						r = 135
					else
						r = 45
					end
				end

				local bombEnemyId = "USSArmmy_100"

				if (TppGameSequence.GetGameFlag("playerSkinMode" ) ~= 0)  then
					--ローポリなら
					bombEnemyId = "genom_100"
					demoNameTank = "Demo_BombTankGns"
				end

				-- プレイヤーワープ、デモの演技範囲にいたら
				if ( TppMission.GetFlag( "isInTankDemo" ) == true ) then
					TppPlayer.Warp( "warp_tankDemo" )
				end
				-- のっとる敵兵を表示
				TppCharacterUtility.SetEnableCharacterId( bombEnemyId,true )
				-- デモで消えないように設定
				MissionManager.RegisterNotInGameRealizeCharacter( bombEnemyId )
				-- デモ明けに内通者を「気絶」状態にしておく
				TppEnemyUtility.ChangeStatus( bombEnemyId, "Faint" )
				-- 気絶回復停止
				TppEnemyUtility.SetLifeFlagByCharacterId( bombEnemyId, "NoRecoverFaint" )
				TppEnemyUtility.SetLifeFlagByCharacterId( bombEnemyId, "NoRecoverSleep" )
				TppEnemyUtility.SetLifeFlagByCharacterId( bombEnemyId, "NoDamageSleep" )
				TppEnemyUtility.SetLifeFlagByCharacterId( bombEnemyId, "NoDamageFaint" )

				-- いびきOff
				ibikiOnOff(false)
				-- グレネードの入った音
				local position = Vector3( -193.837, 26.770, 233.847 )
				TppSoundDaemon.PostEvent3D( 'sfx_m_grenade_holein', position )

				--戦車の諜報無線OFF
				TppRadio.DisableIntelRadio( "intel_e0060_esrg0070" )

				playDemoForHomage( demoNameTank, "isBombTank","1400",r )
			end
		end
	end,

	-- localFunc : モアイ像（見たとき）
	FuncCheckLookMoai = function()
		--フラグの確認 isMoai
		if ( PhaseCheck() == true ) then
			if( TppMission.GetFlag( "isLookMoai" ) == false and TppMission.GetFlag( "isLookMoaiFailed" ) == false ) then

				playDemoForHomage( "Demo_LookMoai", "isLookMoai","1500",-180 )
			end
		end
	end,

	--localFunc : ジープ（車両が通ったとき）
	FuncCheckRunVehicle = function()
		--フラグの確認 isVehicle
		if ( PhaseCheck() == true ) then
			if( TppMission.GetFlag( "isRunVehicle" ) == false and TppMission.GetFlag( "isRunVehicleFailed" ) == false) then
				-- 車のドライバーをチェック
				local chObj = Ch.FindCharacterObjectByCharacterId( "Tactical_Vehicle_WEST")
				local driverObj = chObj:GetDriver()

				if (driverObj:FindTag("Player")) then
					--プレイヤーの状態チェック（車両に乗っている）
					playDemoForHomage( "Demo_RunVehicle", "isRunVehicle","1600" )
				end
			end
		end
	end,
	--localFunc : ジープ（車両が通ったとき）
	FuncCheckRunVehicleRev = function()
		--フラグの確認 isVehicle
		if ( PhaseCheck() == true ) then
			if( TppMission.GetFlag( "isRunVehicle" ) == false and TppMission.GetFlag( "isRunVehicleFailed" ) == false) then

				-- 車のドライバーをチェック
				local chObj = Ch.FindCharacterObjectByCharacterId( "Tactical_Vehicle_WEST")
				local driverObj = chObj:GetDriver()

				if (driverObj:FindTag("Player")) then
					--プレイヤーの状態チェック（車両に乗っている）
					playDemoForHomage( "Demo_RunVehicleRev", "isRunVehicle","1600" )
				end
			end
		end
	end,

	--localFunc : ブラックアウト演出用にスイッチ押すときに暗くする
	FuncLightOffTag = function()
		local charaID = TppData.GetArgument( 1 )
		local status = TppGadgetManager.GetGadgetStatus( "gntn_center_SwitchLight" )

		if( charaID == "gntn_center_SwitchLight" )then	-- スイッチを押した
			--停電前
			if( status == 1 )then	-- 停電になった
				-- カメラを止める
				TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "camera_20060", false )

				-- デモがあるときは暗くする
				if( TppMission.GetFlag( "isTurnOffPanel" ) == false and PhaseCheck() == true) then
					WeatherManager.RequestTag("e20060_lightOff", 0.2 )
				end
			else -- 停電戻った
				-- カメラを戻す
				TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "camera_20060", true )
				--敵兵停電挙動用トラップＯFF
				TppDataUtility.SetEnableDataFromIdentifier( "gntn_Trap", "SwitchLightArea", false , false )
			end
		end
	end,

	--localFunc : ブラックアウト（スイッチをオフにしたとき）
	FuncCheckTurnOffPanel = function()
		--フラグの確認 isBlackOut
		if ( PhaseCheck() == true ) then
			if( TppMission.GetFlag( "isTurnOffPanel" ) == false) then
				--日米でデモを分岐
				local demoName = "Demo_TurnOffPanel"
				local useLang = AssetConfiguration.GetDefaultCategory( "Language" )
				if useLang == "jpn" then
					demoName = "Demo_TurnOffPanelJP"
				end
				playDemoForHomage( demoName, "isTurnOffPanel","1700" )
			end
		end
		--敵兵停電挙動用トラップＯＮ
		if( TppMission.GetFlag( "isTurnOffPanel" ) == true )then--デモを見ていたらトラップをオンにしない
			TppDataUtility.SetEnableDataFromIdentifier( "gntn_Trap", "SwitchLightArea", true , false )
		end
	end,

	--localFunc ：　ミッションクリア
	FuncMissionClear = function()
		if( TppMission.GetFlag( "isClear" ) == true ) then
			-- スコア計算テーブルの設定
			GZCommon.ScoreRankTableSetup( this.missionID )
			insideColorSetting() -- 念のためカラコレを戻す
			if( TppMission.GetFlag( "isClearComp" ) == true ) then
				TppMission.ChangeState( "clear", "inDactComplate" )
			else
				TppMission.ChangeState( "clear", "inDactNormal" )
			end
		end
	end,

	--localFunc : Chenge Inside Setting
	InsideSettingBGM = function()
		TppMission.SetFlag( "isPlayerInsideBGM", true )
		insideBGMSetting()
	end,
	--localFunc : Chenge Outside Setting
	OutsideSettingBGM = function()
		TppMission.SetFlag( "isPlayerInsideBGM", false )
		insideBGMSetting()
	end,
	--localFunc : Chenge Inside Setting
	InsideSettingColor = function()
		TppMission.SetFlag( "isPlayerInsideColor", true )
		insideColorSetting()
	end,
	--localFunc : Chenge Outside Setting
	OutsideSettingColor = function()
		TppMission.SetFlag( "isPlayerInsideColor", false )
		insideColorSetting()
	end,

	--localFunc ： Charenge Event
	CharengeStart = function()
		-- ファンの一人だよ無線
		if( PhaseCheck() == true )then
			TppSound.PlayEvent( "sfx_s_mgsomg_codec_call" )
			TppRadio.DelayPlay( "Call_mine","mid","both" )
		end
	end,

	DemoFoxDieCheck = function()

		if ( PhaseCheck() == true ) then

			Fox.Log(":: DemoFoxDieCheck function ::")
			local status = "Dead"

			if( (TppData.GetArgument( 1 ) == "AsyPickingDoor24" ) ) then
				--　チコ
				Fox.Log(":: chico")
				status = checkHostageStatus(1)

				--捕虜 元気ならフラグ見て判定
				if(status == "Normal")then
					Fox.Log(":: Status is Normal ::")
					if( TppMission.GetFlag("isFoxDieChico")== true )then
						this.foxDieDemoDoorNum = 2
					else
						this.foxDieDemoDoorNum = 0
						this.Common_DoorUnlock("chico")
						TppMission.SetFlag( "isDemoChico", true )
						TppSequence.ChangeSequence( "Seq_DemoFoxDie" )
					end
				end
			elseif( (TppData.GetArgument( 1 ) == "Paz_PickingDoor00" ) )then
				-- パス
				Fox.Log(":: paz")
				status = checkHostageStatus(2)
				if(status == "Normal")then
					Fox.Log(":: Status is Normal ::")
					--捕虜 元気ならフラグ見て判定
					if( TppMission.GetFlag("isFoxDiePaz") == true)then
						this.foxDieDemoDoorNum = 2
					else
						this.foxDieDemoDoorNum = 1
						this.Common_DoorUnlock("paz")
						TppMission.SetFlag( "isDemoPaz", true )
						TppSequence.ChangeSequence( "Seq_DemoFoxDie" )
					end
				end
			end

		end
	end,

	-- クリアできるときに端末を開いたらゴールを促す
   -- コンプのときは
	openMbDvc = function()
		if( TppMission.GetFlag( "isClear" ) == true and TppMission.GetFlag( "isClearComp" ) == false)then
			TppRadio.Play("canClear")
		end
	end,

	-- 捕虜が死んだ時の処理
	hostageDead1 = function()
		-- 無線トラップを無効にする
		Fox.Log(":: kill hostage ::")
		if( TppData.GetArgument( 4 ) == true ) then
			Fox.Log("Player Killed")
			TppRadio.PlayEnqueue( "Radio_HostageDead" )
		end
		TppDataUtility.SetEnableDataFromIdentifier( "id_20060_all", "radioHostage1", false, true )

		TppMission.SetFlag( "isHostageDead1", true )
		-- 扉を開放するならここ！
		checkHostDoor()

	end,
	hostageDead2 = function()
		-- 無線トラップを無効にする
		Fox.Log(":: kill hostage ::")
		if( TppData.GetArgument( 4 ) == true ) then
			Fox.Log("Player Killed")
			TppRadio.PlayEnqueue( "Radio_HostageDead" )
		end
		TppDataUtility.SetEnableDataFromIdentifier( "id_20060_all", "radioHostage2", false, true )

		TppMission.SetFlag( "isHostageDead2", true )
		-- 扉を開放するならここ！
		checkHostDoor()

	end,

	-- ゴールのダクトが開いてなかったら開ける
	dactHoken = function()
		if( TppMission.GetFlag( "isClear" ) == true)then
			-- ゴールを開ける
			TppDataUtility.SetVisibleDataFromIdentifier( "asset_base", "TestKey0", false, false )
			TppDataUtility.SetVisibleDataFromIdentifier( "asset_base", "gntn_vent001_0001", true, false )
		else
			TppDataUtility.SetVisibleDataFromIdentifier( "asset_base", "TestKey0", true, false )
			TppDataUtility.SetVisibleDataFromIdentifier( "asset_base", "gntn_vent001_0001", false, false )
		end
	end,

	-- アラート時の警告無線
	cpAlert = function()
		if ( TppMission.GetFlag( "isClearComp" ) == false ) then
			TppRadio.DelayPlay( "radio_Alert","short" )
		end
	end,

	cpCaution = function()
		chengeRouteCaution()
	end,
	cpEvasion = function()
		TppRadio.DelayPlay( "radio_BackAlert","short" )
		chengeRouteCaution()
	end,
	cpSneak = function()
		chengeRouteSneak()
	end,

	jinmonHeliCheck = function()
		setHeliMarker()
	end,

	-- 不要なマーカーを消す。尋問内容を更新
	jinmonMarkCheck = function()
		Fox.Log(":: jinmon mark check ::")
		-- 他の敵兵の尋問内容を更新
		if( TppMission.GetFlag( "isJinmon" ) == false )then
			local charaid = TppData.GetArgument( 1 )
			Fox.Log( charaid )

			if( charaid == "USSArmmy_000" or charaid == "genom_006"
				or charaid == "USSArmmy_011" or charaid == "genom_004"
				or charaid == "USSArmmy_007" or charaid == "genom_008"
				or charaid == "USSArmmy_009" or charaid == "genom_003"
				or charaid == "USSArmmy_012" or charaid == "genom_015"
				or charaid == "USSArmmy_002" or charaid == "genom_005"
				or charaid == "USSArmmy_024" or charaid == "genom_012"
				or charaid == "USSArmmy_005" or charaid == "genom_010"
			) then
				Fox.Log("Jinmon remove from jinmon mark check")
				TppMission.SetFlag( "isJinmon" ,true )
				removeAllJinmon()
			end


			if ( TppMission.GetFlag( "isMarkMGS" ) )then
				TppMarkerSystem.DisableMarker{ markerId="e20060_logo_002" }
			end
			if ( TppMission.GetFlag( "isMarkMG" ) )then
				TppMarkerSystem.DisableMarker{ markerId="e20060_logo_003" }
			end
			if ( TppMission.GetFlag( "isMarkMGS4" ) )then
				TppMarkerSystem.DisableMarker{ markerId="e20060_logo_004" }
			end
			if ( TppMission.GetFlag( "isMarkMGS2" ) )then
				TppMarkerSystem.DisableMarker{ markerId="e20060_logo_005" }
			end
			if ( TppMission.GetFlag( "isMarkGZ" ) )then
				TppMarkerSystem.DisableMarker{ markerId="e20060_logo_006" }
			end
			if ( TppMission.GetFlag( "isMarkMG2" ) )then
				TppMarkerSystem.DisableMarker{ markerId="e20060_logo_007" }
			end
			if ( TppMission.GetFlag( "isMarkMGS3" ) )then
				TppMarkerSystem.DisableMarker{ markerId="e20060_logo_008" }
			end
		end
	end,

	callHeli = function()
		Fox.Log("call heli")

		--無線の処理
		local radioDaemon = RadioDaemon:GetInstance()
		local emergency = TppData.GetArgument(2)
		local charaObj = Ch.FindCharacterObjectByCharacterId("SupportHelicopter")
		local plgHeli = charaObj:GetCharacter():FindPlugin("TppSupportHelicopterPlugin")
		if ( radioDaemon:IsPlayingRadio() == false ) then

			if(TppSupportHelicopterService.IsDueToGoToLandingZone("SupportHelicopter")) then
			--これからＬＺに行く予定がある
				if(emergency == 2) then
					TppRadio.DelayPlay( "Miller_CallHeli02", "long" )
				else
					TppRadio.DelayPlay( "Miller_CallHeli02", "long" )
				end
			else
			--特にＬＺに行く予定はない
				if plgHeli:GetAiStatus() ~= "AI_STATUS_RETURN" then
					if(emergency == 2) then
						TppRadio.DelayPlay( "Miller_CallHeli01", "long" )
					else
						TppRadio.DelayPlay( "Miller_CallHeli01", "long" )
					end
				end
			end
		end

		-- ロゴマークをヘリへ
		TppGadgetUtility.AttachGadgetToChara("e20060_logo_001","SupportHelicopter","CNP_MARK")

		if( TppMission.GetFlag( "isMarkHeli" ) == true )then
			return
		else
			TppMission.SetFlag( "isMarkHeli", true )
		end

		setHeliMarker()

	end,

	--CheckLookingTargetの使用を宣言
	checkingsOnThisSequence = {
		"CheckLookingTarget"
	},
	Messages = {
		Character = {
			-- Phase CP
			{ data = "gntn_cp",		message = "Alert",				localFunc = "cpAlert" },		-- Alert ミッションできない警告
			{ data = "gntn_cp",		message = "Evasion",			localFunc = "cpEvasion" },		-- Alert 終わりミッションできる警告
			{ data = "gntn_cp",		message = "Caution",			localFunc = "cpCaution" },		-- Alert 終わりミッションできる警告
			{ data = "gntn_cp",		message = "Sneak",				localFunc = "cpSneak" },		-- ルートを戻す
			-- 汎用プレイヤー
			{ data = "Player", 		message = "OnPickUpItem" , 		commonFunc = Common_PickUpItem },	--アイテムを入手した時　カセット用
			-- オマージュ
			{ data = "Player", 		message = "SwitchPushButton", 	localFunc = "FuncLightOffTag" },	--スイッチを押す
			--ネタ
			{ data = "Player", 		message = "OnVehicleRide_End", 	commonFunc = function() checkVehicleRide() end },	--乗り物に乗る
			-- 金属虫
			{ data = "Player", 		message = "OnPickUpWeapon", 	commonFunc = function() checkPickUpAmmo() end },--
			{ data = "Player", 		message = "OnPickUpAmmo", 		commonFunc = function() checkPickUpAmmo() end },-- グレネードを拾った
			--クレイモア
			{ data = "Player", 		message = "OnPickUpPlaced", 	commonFunc = function()charengeClaymoreCount() end },	--クレイモア拾う
			{ data = "Player", 		message = "WeaponPutPlaced", 	commonFunc = function()charengeClaymorePut() end },	--クレイモア置く
			{ data = "Player", 		message = "OnActivatePlaced", 			commonFunc = function() DamagedOnClaymore() end },	-- クレイモアが壊れた
			--Demo
			{ data = "Player", 		message = "TryPicking", 		localFunc = "DemoFoxDieCheck"  },
			-- 成功条件
			{ data = "Armored_Vehicle_WEST_001", message = "GrenadeDroppedIn", localFunc = "FuncCheckBombTank"},
			-- 失敗条件
			{ data = "Armored_Vehicle_WEST_001", message = "StrykerDestroyed", commonFunc = function()	FuncEventFailed("isBombTank") end},
			{ data = "Tactical_Vehicle_WEST", 	message = "VehicleBroken", 	commonFunc = function()  FuncEventFailed("isRunVehicle") end},
			{ data = "camera_20060", 			message = "Dead", 			commonFunc = function()	FuncEventFailed("isLookCamera") end}, --監視カメラを壊した
			--{ data = "camera_20060", message = "Alert", localFunc = "FuncCheckLookCamera"}, --監視カメラに見つかった
			{ data = "Hostage_e20060_000", message = "Dead", localFunc = "hostageDead1"}, --チコ檻の捕虜を殺した
			{ data = "Hostage_e20060_001", message = "Dead", localFunc = "hostageDead2"}, --パス檻の捕虜を殺した
			{ data = "Hostage_e20060_002", message = "Dead", localFunc = "hostageDead1"}, --チコ檻の捕虜を殺した
			{ data = "Hostage_e20060_003", message = "Dead", localFunc = "hostageDead2"}, --パス檻の捕虜を殺した
		},
		Trap = {
			-- ミッションクリアトラップ
			{ data = "Trap_MissionClear", 	message = "Enter", localFunc = "FuncMissionClear" },	--クリア
			{ data = "Trap_ratEscape", 		message = "Enter", commonFunc = function()	ratEscape() end },			-- rat
			{ data = "Trap_dact", 			message = "Enter", commonFunc = function() 	TppRadio.Play("Call_dact")	end },			--dact
			-- ミッション　クリア条件チェック
			--{ data = "Trap_homage_heli", 	message = "Enter", localFunc = "FuncCheckLookHeli"	},
			{ data = "Trap_homage_heli", 	message = "Enter", commonFunc = function() TppMission.SetFlag( "isInHeli", true )  end },
			{ data = "Trap_homage_heli", 	message = "Exit",  commonFunc = function() TppMission.SetFlag( "isInHeli", false )	end },
			{ data = "Trap_homage_camera", 	message = "Enter", commonFunc = function() TppMission.SetFlag( "isInCamera", true )  end },
			{ data = "Trap_homage_camera", 	message = "Exit",  commonFunc = function() TppMission.SetFlag( "isInCamera", false )  end },
			{ data = "Trap_homage_moai", 	message = "Enter", commonFunc = function() TppMission.SetFlag( "isInMoai", true )  end },
			{ data = "Trap_homage_moai", 	message = "Exit",  commonFunc = function() TppMission.SetFlag( "isInMoai", false )	end },
			{ data = "Trap_homage_vehicle", message = "Enter", localFunc = "FuncCheckRunVehicle" },
			{ data = "Trap_homage_vehicle_Rev", message = "Enter", localFunc = "FuncCheckRunVehicleRev" },
			-- クリア条件に近いけど違う位置
			{ data = "Trap_failed_heli", 	message = "Enter", localFunc = "FuncFailedHeli"  },
			-- tank open
			{ data = "trap_tankOpen", 		message = "Enter", commonFunc = function() tankOpen() end },
			-- Near Radio 近づいたときにでる
			{ data = "Trap_hint_heli", 		message = "Enter", commonFunc = function() FuncNearRadio( "isLookHeli" , "near" ) end },
			{ data = "Trap_hint_camera", 	message = "Enter", commonFunc = function() FuncNearRadio( "isLookCamera", "near"  ) end },
			{ data = "Trap_hint_chaff",		message = "Enter", commonFunc = function() FuncNearRadio( "isGetChaffCase", "near"	) end },
			{ data = "Trap_hint_vehicle",	message = "Enter", commonFunc = function() FuncNearRadio( "isRunVehicle", "near"  ) end },
			{ data = "Trap_hint_tank",		message = "Enter", commonFunc = function() FuncNearRadio( "isBombTank", "near"	) end },
			{ data = "Trap_hint_switch",	message = "Enter", commonFunc = function() FuncNearRadio( "isTurnOffPanel", "near"	) end },
			--BGM change  in or out
			{ data = "trap_BGMArea",		message = "Enter", localFunc = "InsideSettingBGM" },
			{ data = "trap_BGMArea",		message = "Exit", localFunc = "OutsideSettingBGM" },
			{ data = "trap_colorArea",		message = "Enter", localFunc = "InsideSettingColor" },
			{ data = "trap_colorArea",		message = "Exit", localFunc = "OutsideSettingColor" },
			-- 金属虫マーカー
			{ data = "trap_merker_01", 		message = "Enter", commonFunc = function()TppRadio.Play( "Metal_getGun" ) end },
			-- ロゴライト
			{ data = "trap_logo", 			message = "Enter", commonFunc = function() findFoxLogo() end },
			-- 無線・ネタ
			{ data = "trap_op01", 			message = "Enter", commonFunc = function()TppRadio.PlayEnqueue( "Miller_op002") end },
			{ data = "trap_netaStart", 		message = "Enter", commonFunc = function() radioStartCheckAraska() end },
			{ data = "trap_netaStart2", 	message = "Enter", commonFunc = function() radioNetaCheckJanai() end },
			{ data = "trap_DoorRadio", 		message = "Enter", commonFunc = function() netaDoor() end },
			{ data = "trap_CharengeStart", 	message = "Enter", localFunc = "CharengeStart" },			--call radio from a fan
			{ data = "trap_radioHostage1", 	message = "Enter", commonFunc = function()RadioNearHostage(1) end },--「捕虜か？」無線
			{ data = "trap_radioHostage2", 	message = "Enter", commonFunc = function()RadioNearHostage(2) end },--「捕虜か？」無線
			{ data = "trap_JohnnyRadio", 	message = "Enter", commonFunc = function()TppRadio.PlayEnqueue("radio_Toilet") end },
			-- tankでもの判定
			{ data = "trap_TankCheckPos", 	message = "Enter", commonFunc = function() TppMission.SetFlag( "isInTankDemo", true ) end },
			{ data = "trap_TankCheckPos", 	message = "Exit", commonFunc = function() TppMission.SetFlag( "isInTankDemo", false ) end },
			-- 保険処理
			{ data = "trap_DactHoken", 		message = "Enter", localFunc = "dactHoken" },--捕虜？
		},
		Terminal = {
			{		message = "MbDvcActWatchPhoto",commonFunc = commonMbDvcActWatchPhoto },
			{		message = "MbDvcActOpenTop", localFunc = "openMbDvc"},--クリア可能無線
			{ 		message = "MbDvcActCallRescueHeli", localFunc = "callHeli" },	--支援ヘリ要請
		},
		Gimmick = {
			--成功
			{ data = "gntn_center_SwitchLight", message = "SwitchOff", localFunc =	"FuncCheckTurnOffPanel" },
			--失敗
			{ data = this.lookHeli, 			message = "BreakGimmick", commonFunc = function()  FuncEventFailed("isLookHeli") end},
			{ data = "e20060_moai", 			message = "BreakGimmick", commonFunc = function()  FuncEventFailed("isLookMoai") end},
			{ data = "gntn_serchlight_20060_1", message = "BreakGimmick", commonFunc = function()  FuncEventFailed("isGetChaffCase") end},
			{ data = "gntn_serchlight_20060_2", message = "BreakGimmick", commonFunc = function()  FuncEventFailed("isGetChaffCase") end},
			-- Fox Light
			{ data = "charenge_20060_KJP", message = "HitLight", commonFunc =	function() highlightFoxLogo("fox")	end },
			{ data = "charenge_20060_LA",  message = "HitLight", commonFunc =	function() highlightFoxLogo("la")  end },
			{ data = "gntn_serchlight_20060_3", message = "SwitchOff", commonFunc = function()	TppRadio.DelayPlayEnqueue( "Light_offMark", "short" ) end},
			{ data = "gntn_serchlight_20060_4", message = "SwitchOff", commonFunc = function()	TppRadio.DelayPlayEnqueue( "Light_offMark", "short" ) end},
			{ data = "gntn_serchlight_20060_3", message = "BreakGimmick", commonFunc = function()	challengeChancelFox() end},
			{ data = "gntn_serchlight_20060_4", message = "BreakGimmick", commonFunc = function()	challengeChancelLA() end},
			--成功
			{ data = "WoodTurret04", message = "BreakGimmick", commonFunc = function() challengeChancel()  end },
			-- 金属虫マーカー
			{ data = "e20060_logo_001", message = "HitLight", commonFunc = function()  findTitleLogoMark(1) end},
			{ data = "e20060_logo_002", message = "HitLight", commonFunc = function()  findTitleLogoMark(2) end},
			{ data = "e20060_logo_003", message = "HitLight", commonFunc = function()  findTitleLogoMark(3) end},
			{ data = "e20060_logo_004", message = "HitLight", commonFunc = function()  findTitleLogoMark(4) end},
			{ data = "e20060_logo_005", message = "HitLight", commonFunc = function()  findTitleLogoMark(5) end},
			{ data = "e20060_logo_006", message = "HitLight", commonFunc = function()  findTitleLogoMark(6) end},
			{ data = "e20060_logo_007", message = "HitLight", commonFunc = function()  findTitleLogoMark(7) end},
			{ data = "e20060_logo_008", message = "HitLight", commonFunc = function()  findTitleLogoMark(8) end},
			{ data = "e20060_logo_101", message = "HitLight", commonFunc = function()  findTitleLogoMark(10) end},
			{ data = "e20060_logo_102", message = "HitLight", commonFunc = function()  findTitleLogoMark(10) end},
			{ data = "e20060_logo_103", message = "HitLight", commonFunc = function()  findTitleLogoMark(10) end},
			{ data = "e20060_logo_104", message = "HitLight", commonFunc = function()  findTitleLogoMark(10) end},
			{ data = "e20060_logo_105", message = "HitLight", commonFunc = function()  findTitleLogoMark(10) end},
			{ data = "e20060_logo_106", message = "HitLight", commonFunc = function()  findTitleLogoMark(10) end},
			{ data = "e20060_logo_107", message = "HitLight", commonFunc = function()  findTitleLogoMark(10) end},
		},
		Radio = {
			{ data = "e0060_rtrg0140",		message = "RadioEventMessage", commonFunc = function() radioStartCheck() end },
		},
		Marker = {
			--{data = "e20060_logo_002",		message = "ChangeToEnable",	   localFunc = "jinmonMarkCheck"},
		},
		Enemy = {
			-- 乗り物に乗せられた
			{ message = "HostageLaidOnVehicle",			commonFunc = function() this.commonOnLaidEnemy() end  },
			{ message = "EnemyInterrogation", 			localFunc = "jinmonMarkCheck"},


		},
		-- 見た判定用
		Myself = {
			{ data = this.lookCamera,	message = "LookingTarget",		commonFunc = function() commonLookCheck() end },
			{ data = this.lookMoai,		message = "LookingTarget",		commonFunc = function() commonLookCheck() end },
			{ data = this.lookHeli,		message = "LookingTarget",		commonFunc = function() commonLookCheck() end },
		},
	},

	OnEnter = function( manager )
		-- Route Set
		commonRouteSetMissionSetup()
		--ミッション圏外
		All_Seq_MissionAreaOut()
		-- MB端末を封じる　を解除
		TppPadOperatorUtility.ResetMasksForPlayer( 0, "MB_Disable")
		-- サーチターゲット
		commonSearchTargetSetup( manager )
		--DemoDoor設定
		checkHostDoor()
		-- カラーlut
		insideColorSetting()
		-- 諜報セットアップ
		this.SetIntelRadio()
	end,
}

--------------------------------------------------------------------------------
-- FOXDIE のときのシーケンス
this.Seq_EventFoxDie = {
	Messages = {
		Character = {
			-- 汎用プレイヤー
			{ data = "Player", 		message = "OnPickUpItem" , 		commonFunc = Common_PickUpItem },	--アイテムを入手した時　カセット用
			--クレイモア
			{ data = "Player", 		message = "OnPickUpPlaced", 	commonFunc = function()charengeClaymoreCount() end },	--クレイモア拾う
			{ data = "Player", 		message = "WeaponPutPlaced", 	commonFunc = function()charengeClaymorePut() end },	--クレイモア置く
			{ data = "Player", 		message = "OnActivatePlaced", 			commonFunc = function() DamagedOnClaymore() end },	-- クレイモアが壊れた
			-- 失敗条件
			{ data = "Armored_Vehicle_WEST_001", message = "StrykerDestroyed", commonFunc = function()	FuncEventFailed("isBombTank") end},
			{ data = "Tactical_Vehicle_WEST", 	message = "VehicleBroken", 	commonFunc = function()  FuncEventFailed("isRunVehicle") end},
			{ data = "camera_20060", 			message = "Dead", 			commonFunc = function()	FuncEventFailed("isLookCamera") end}, --監視カメラを壊した
		},
		Trap = {
			-- ミッションクリアトラップ
			{ data = "Trap_MissionClear", 	message = "Enter", commonFunc =  function() this.Seq_MissionStart.FuncMissionClear() end },	--クリア
			{ data = "Trap_ratEscape", 		message = "Enter", commonFunc = function()	ratEscape() end },			-- rat
			-- tank open
			{ data = "trap_tankOpen", 		message = "Enter", commonFunc = function() tankOpen() end },
			--BGM change  in or out
			{ data = "trap_BGMArea",		message = "Enter",commonFunc = function() this.Seq_MissionStart.InsideSettingBGM() end },
			{ data = "trap_BGMArea",		message = "Exit", commonFunc = function() this.Seq_MissionStart.OutsideSettingBGM() end },
			-- 保険処理
			{ data = "trap_DactHoken", 		message = "Enter", commonFunc = function() this.Seq_MissionStart.dactHoken() end },--捕虜？
		},
		Gimmick = {
			--失敗
			{ data = this.lookHeli, 			message = "BreakGimmick", commonFunc = function()  FuncEventFailed("isLookHeli") end},
			{ data = "e20060_moai", 			message = "BreakGimmick", commonFunc = function()  FuncEventFailed("isLookMoai") end},
			{ data = "gntn_serchlight_20060_1", message = "BreakGimmick", commonFunc = function()  FuncEventFailed("isGetChaffCase") end},
			{ data = "gntn_serchlight_20060_2", message = "BreakGimmick", commonFunc = function()  FuncEventFailed("isGetChaffCase") end},
			-- Fox Light
			{ data = "charenge_20060_KJP", message = "HitLight", commonFunc =	function() highlightFoxLogo("fox")	end },
			{ data = "charenge_20060_LA",  message = "HitLight", commonFunc =	function() highlightFoxLogo("la")  end },
			{ data = "gntn_serchlight_20060_3", message = "BreakGimmick", commonFunc = function()	challengeChancelFox() end},
			{ data = "gntn_serchlight_20060_4", message = "BreakGimmick", commonFunc = function()	challengeChancelLA() end},
			{ data = "WoodTurret04", message = "BreakGimmick", commonFunc = function() challengeChancel()  end },
			-- 金属虫マーカー
			{ data = "e20060_logo_001", message = "HitLight", commonFunc = function()  findTitleLogoMark(1) end},
			{ data = "e20060_logo_002", message = "HitLight", commonFunc = function()  findTitleLogoMark(2) end},
			{ data = "e20060_logo_003", message = "HitLight", commonFunc = function()  findTitleLogoMark(3) end},
			{ data = "e20060_logo_004", message = "HitLight", commonFunc = function()  findTitleLogoMark(4) end},
			{ data = "e20060_logo_005", message = "HitLight", commonFunc = function()  findTitleLogoMark(5) end},
			{ data = "e20060_logo_006", message = "HitLight", commonFunc = function()  findTitleLogoMark(6) end},
			{ data = "e20060_logo_007", message = "HitLight", commonFunc = function()  findTitleLogoMark(7) end},
			{ data = "e20060_logo_008", message = "HitLight", commonFunc = function()  findTitleLogoMark(8) end},
		},
		Timer = {
			{ data = "Timer_foxDieBugEnd", message = "OnEnd", localFunc = "foxDieBugEnd" },
			{ data = "Timer_foxDieBugEndHoken", message = "OnEnd", localFunc = "foxDieBugEnd" },
			{ data = "Timer_foxDieFadeOut", message = "OnEnd", localFunc = "foxDieBugFadeOut" },
			{ data = "Timer_foxDieFadeIn", message = "OnEnd", localFunc = "foxDieBugFadeIn" },
			{ data = "Timer_foxDieAnnounce0", message = "OnEnd", localFunc = "foxDieBugAnnounce0" },
			{ data = "Timer_foxDieAnnounce1", message = "OnEnd", localFunc = "foxDieBugAnnounce1" },
			{ data = "Timer_foxDieAnnounce2", message = "OnEnd", localFunc = "foxDieBugAnnounce2" },
			{ data = "Timer_foxDieAnnounce3", message = "OnEnd", localFunc = "foxDieBugAnnounce3" },
			{ data = "Timer_foxDieAnnounce4", message = "OnEnd", localFunc = "foxDieBugAnnounce4" },
			{ data = "Timer_foxDieAnnounce5", message = "OnEnd", localFunc = "foxDieBugAnnounce5" },
			{ data = "Timer_foxDieAnnounce6", message = "OnEnd", localFunc = "foxDieBugAnnounce6" },
			{ data = "Timer_foxDieAnnounce7", message = "OnEnd", localFunc = "foxDieBugAnnounce7" },
			{ data = "Timer_foxDieAnnounce8", message = "OnEnd", localFunc = "foxDieBugAnnounce8" },
			{ data = "Timer_foxDieAnnounce9", message = "OnEnd", localFunc = "foxDieBugAnnounce9" },
			{ data = "Timer_foxDieAnnounce10", message = "OnEnd", localFunc = "foxDieBugAnnounce10" },
		},
	},

	OnEnter = function()

		-- すでにイベントを見ていたらスキップして戻す（不正なコンテニュー対策）
		if ( TppMission.GetFlag( "isFoxDieStart" ) == true ) then
			Fox.Log(":: Sequence is back. Becouse You watched event allredy ::")
			insideColorSetting() -- 念のためカラコレを戻す
			TppUI.FadeIn( 0 ) -- 念のためフェードイン
			TppSequence.ChangeSequence( "Seq_MissionStart" )

			-- MB端末を封じる　を解除
			TppPadOperatorUtility.ResetMasksForPlayer( 0, "MB_Disable")
		else

			Fox.Log(":: FOXDIE START ::")
			-- MB端末を封じる
			TppPadOperatorUtility.SetMasksForPlayer( 0, "MB_Disable")

			-- 1度しか発動しないようにフラグをたてる
			TppMission.SetFlag( "isFoxDieStart", true )

			--バグ表現のための各種タイマーをだす
			GkEventTimerManager.Start( "Timer_foxDieBugEndHoken", this.timeFoxDieBug ) -- End までの保険処理
			-- フェード
			GkEventTimerManager.Start( "Timer_foxDieFadeOut", 6 )

			-- アナウンスログ
			commonAnnounceLogMission(langFoxDie023)
			commonAnnounceLogMission(langFoxDie019)
			commonAnnounceLogMission(langFoxDie017)
		end
		-- 諜報セットアップ
		this.SetIntelRadio()
	end,

	foxDieBugFadeOut = function()
		-- フェードアウト
		TppUI.FadeOut( 0.2 )

		-- 駅名音声 nose 能勢電
		TppRadio.Play( "Radio_FoxDieIDroid")
		TppSound.PlayEvent( "Set_State_FoxDie" )

		GkEventTimerManager.Start( "Timer_foxDieFadeIn", 1 )
	end,
	foxDieBugFadeIn = function()
		TppUI.FadeIn( 1 )
		TppEffectUtility.SetColorCorrectionLut( "gntn_bug_a_FILTERLUT" )

		GkEventTimerManager.Start( "Timer_foxDieAnnounce0", 2 )
	end,


	foxDieBugAnnounce0 = function()
		-- アナウンスログ連打
		commonAnnounceLogMission(langFoxDie002)
		GkEventTimerManager.Start( "Timer_foxDieAnnounce1", this.timeFoxDieBugAnnounce )
	end,

	foxDieBugAnnounce1 = function()
		GkEventTimerManager.Start( "Timer_foxDieAnnounce2", this.timeFoxDieBugAnnounce )
	end,

	foxDieBugAnnounce2 = function()
		commonAnnounceLogMission(langFoxDie008)--
		GkEventTimerManager.Start( "Timer_foxDieAnnounce3", this.timeFoxDieBugAnnounce )
	end,

	foxDieBugAnnounce3 = function()
		GkEventTimerManager.Start( "Timer_foxDieAnnounce4", this.timeFoxDieBugAnnounce )
	end,

	foxDieBugAnnounce4 = function()
		commonAnnounceLogMission(langFoxDie012)
		GkEventTimerManager.Start( "Timer_foxDieAnnounce5", this.timeFoxDieBugAnnounce )
	end,

	foxDieBugAnnounce5 = function()
		--commonAnnounceLogMission(langFoxDie015)
		--commonAnnounceLogMission(langFoxDie016)
		--commonAnnounceLogMission(langFoxDie017)--
		GkEventTimerManager.Start( "Timer_foxDieAnnounce6", this.timeFoxDieBugAnnounce )
	end,

	foxDieBugAnnounce6 = function()
		commonAnnounceLogMission(langFoxDie018)--
		--commonAnnounceLogMission(langFoxDie019)--
		--commonAnnounceLogMission(langFoxDie020)--
		GkEventTimerManager.Start( "Timer_foxDieAnnounce7", this.timeFoxDieBugAnnounce )
	end,

	foxDieBugAnnounce7 = function()
		--commonAnnounceLogMission(langFoxDie021)
		--commonAnnounceLogMission(langFoxDie022)
		commonAnnounceLogMission(langFoxDie024)
		GkEventTimerManager.Start( "Timer_foxDieAnnounce8", this.timeFoxDieBugAnnounce )
	end,

	foxDieBugAnnounce8 = function()
		--commonAnnounceLogMission(langFoxDie025)
		commonAnnounceLogMission(langFoxDie026)--
		--commonAnnounceLogMission(langFoxDie027)--
		GkEventTimerManager.Start( "Timer_foxDieAnnounce9", this.timeFoxDieBugAnnounce )
	end,

	foxDieBugAnnounce9 = function()
		--commonAnnounceLogMission(langFoxDie028)
		--commonAnnounceLogMission(langFoxDie029)
		--commonAnnounceLogMission(langFoxDie030)
		GkEventTimerManager.Start( "Timer_foxDieAnnounce10", 3)
	end,

	foxDieBugAnnounce10 = function()
		commonAnnounceLogMission(langFoxDie031)
		commonAnnounceLogMission(langFoxDie032)
		commonAnnounceLogMission(langFoxDie033)

		-- 表現終わりまでのカウント
		GkEventTimerManager.Start( "Timer_foxDieBugEnd", 3 )
	end,

	-- バグ表現 戻す
	foxDieBugEnd = function()

		TppMission.SetFlag( "isFoxDieEnd", true )
		-- iDroid 音声
		--TppSoundDaemon.PostDialogue{ event = "DD_vox_iDroid", argument = { "iDroid", "IDV_002" }, delay=0 }
		--TppSoundDaemon.PlayDialogue()
		TppSound.PlayEvent( "sfx_s_mgsomg_rader_clear" )
		TppRadio.DelayPlay( "Radio_FoxDieFixed","mid","none")

		insideColorSetting()

		TppSound.PlayEvent( "p12_Set_State_none" )

		TppRadio.DelayPlayEnqueue( "Radio_FoxDie2","long",nil,{onEnd =function() TppSequence.ChangeSequence( "Seq_MissionStart" ) end } )

	end,



}
--------------------------------------------------------------------------------
this.Seq_DemoFoxDie = {
	Messages = {
	   Character = {
			{ data="Player", message="TransitionActionEnd", localFunc="DemoStart" },
		},
		Demo = {
			{ data="p12_050030_000", message="visibleGate", localFunc="onDemoVisibleGateChico" },
			{ data="p12_050040_000", message="visibleGate", localFunc="onDemoVisibleGate" },--paz
			{ data="p12_050050_000", message="visibleGate", localFunc="onDemoVisibleGateChico" },
			{ data="p12_050060_000", message="visibleGate", localFunc="onDemoVisibleGate" },--paz
		},
	},

	demoId = "Demo_FoxDieChico",
	doorName = "AsyPickingDoor24",

	onDemoVisibleGate = function()
		Fox.Log(":: on demo visible gate ::")
			--扉をしめる
			TppGadgetUtility.SetDoor{ id = this.Seq_DemoFoxDie.doorName, isVisible = true, isEnableBounder = true, isEnableTacticalActionEdge = true , angle = 240, isOpen = true }
	end,

	onDemoVisibleGateChico = function()
		Fox.Log(":: on demo visible gate ::")
			--扉をしめる チコ
			TppGadgetUtility.SetDoor{ id = this.Seq_DemoFoxDie.doorName, isVisible = true, isEnableBounder = true, isEnableTacticalActionEdge = true , angle = -110, isOpen = true }
	end,

	DemoStart = function()


		local onDemoStart = function()
			Fox.Log(":: Door disable ::")
			--TppData.Disable( doorName )--チコ扉
			TppGadgetUtility.SetDoor{ id = this.Seq_DemoFoxDie.doorName, isVisible = false, isEnableBounder = true, isEnableTacticalActionEdge = false , angle = 0, isOpen = false }

			if( this.foxDieDemoDoorNum == 0 ) then
				TppMission.SetFlag( "isFoxDieChico", true )--チコのFOX代でも
				TppDataUtility.SetEnableDataFromIdentifier( "id_20060_all", "radioHostage1", false, true )

				TppHostageManager.GsSetDeadFlag( "Hostage_e20060_000", true)
				TppHostageManager.GsSetDeadFlag( "Hostage_e20060_002", true)
			else
				TppMission.SetFlag( "isFoxDiePaz", true )--チコのFOX代でも
				TppDataUtility.SetEnableDataFromIdentifier( "id_20060_all", "radioHostage2", false, true )

				TppHostageManager.GsSetDeadFlag( "Hostage_e20060_001", true)
				TppHostageManager.GsSetDeadFlag( "Hostage_e20060_003", true)
			end

		end


		local onDemoEnd = function()
			Fox.Log(":: Door Open ::")
			Fox.Log(this.Seq_DemoFoxDie.doorName)

			--扉をしめる
			--TppGadgetUtility.SetDoor{ id = this.Seq_DemoFoxDie.doorName, isVisible = true, isEnableBounder = true, isEnableTacticalActionEdge = true , angle = 240, isOpen = true }

			if( TppMission.GetFlag( "isFoxDieChico" ) == true and TppMission.GetFlag( "isFoxDiePaz" ) )then
				-- 2つともみたらFOXDIEイベント
				TppSequence.ChangeSequence( "Seq_EventFoxDie" )
			else
				-- 1回目なら戻る
				TppSequence.ChangeSequence( "Seq_MissionStart" )
			end
		end


		TppDemo.Play( this.Seq_DemoFoxDie.demoId, { onStart = onDemoStart, onEnd = onDemoEnd } )

	end,

	OnEnter = function()
		Fox.Log(":: Fox Die Demo Start ::")
		GZCommon.StopAlertSirenCheck()

		-- デモの種類を取
		Fox.Log(":check foxDieDemoDoorNum ")
		Fox.Log(this.foxDieDemoDoorNum)
		if( this.foxDieDemoDoorNum == 0 ) then
			-- チコだったら
			this.Seq_DemoFoxDie.doorName = "AsyPickingDoor24"

			--ローポリなら
			if (TppGameSequence.GetGameFlag("playerSkinMode" ) ~= 0)  then
				this.Seq_DemoFoxDie.demoId = "Demo_FoxDieChicoLow"
			else
				this.Seq_DemoFoxDie.demoId = "Demo_FoxDieChico"
			end

		elseif( this.foxDieDemoDoorNum == 1 ) then
			--パスだった
			this.Seq_DemoFoxDie.doorName = "Paz_PickingDoor00"
			if (TppGameSequence.GetGameFlag("playerSkinMode" ) ~= 0) then
				--ローポリなら
				this.Seq_DemoFoxDie.demoId = "Demo_FoxDiePazLow"
			else
				this.Seq_DemoFoxDie.demoId = "Demo_FoxDiePaz"
			end
		end

		local demoInterpCameraId = this.DemoList[this.Seq_DemoFoxDie.demoId]
		Fox.Log(this.Seq_DemoFoxDie.demoId)
		Fox.Log(demoInterpCameraId)
		Fox.Log(this.Seq_DemoFoxDie.doorName)

		-- プレイヤーの向きを補正（デモの入り口に）
		local demoPos = 0
		local demoRot = 0
		demoPos, demoRot = getDemoStartPos( demoInterpCameraId )
		Fox.Log(":: get !! ::")
		Fox.Log("x = " .. demoPos:GetX() .. " y = ".. demoPos:GetY() .. " z = " .. demoPos:GetZ())
		Fox.Log(demoRot)

		-- デモの初期設定
		if( this.foxDieDemoDoorNum == 0 ) then
			--チコ檻
			TppPlayerUtility.RequestToStartTransition{stance=this.demoStaPlayer_chico,position=demoPos,direction=demoRot}
			--TppPlayerUtility.RequestToStartTransition{stance=this.demoStaPlayer_chico,position=this.demoPosPlayer_chico,direction=this.demoRotPlayer_chico}

		elseif( this.foxDieDemoDoorNum == 1 ) then
			--パス檻
			TppPlayerUtility.RequestToStartTransition{stance=this.demoStaPlayer_paz,position=demoPos,direction=demoRot}
		else
			TppSequence.ChangeSequence( "Seq_MissionStart" )--なにかあったら戻す（ここには絶対にこないはず）
		end

		GZCommon.SetGameStatusForDemoTransition()

		-- デモのセットアップ、プレイヤーの向きを補正、カメラの補正
		TppDemoUtility.Setup(demoInterpCameraId)
		TppPlayerUtility.RequestToInterpCameraToDemo(demoInterpCameraId,this.demoCamRot,this.demoCamSpeed)

	end,

	OnLeave = function()
		-- ルートを初期化
		chengeRouteSneak("warp")
		--TppEnemy.ChangeRouteSet( "gntn_cp", "TppRouteSet_n",{ warpEnemy = true, startAtZero = true} )

		-- おわったら　無線
		TppRadio.DelayPlay( "Radio_FoxDie1","mid" )
	end,
}

--------------------------------------------------------------------------------
this.Seq_MissionClearDemo = {
-- クリアした！　クリア判定
	MissionState = "clear",

	OnEnter = function()
		-- ゴールのフタをしめる
		TppDataUtility.SetVisibleDataFromIdentifier( "asset_base", "TestKey0", true, false )
		TppDataUtility.SetVisibleDataFromIdentifier( "asset_base", "gntn_vent001_0001", false, false )

		if ( TppMission.GetFlag( "isClearComp" ) == false ) then
			TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" )
		else
			Trophy.TrophyUnlock(11)--トロフィー コンプリートクリア
			TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" )
		end
	end,
}

--------------------------------------------------------------------------------
this.Seq_MissionClearShowTransition = {
-- 実績表示
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
		--TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default" )
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
				if ( TppMission.GetFlag( "isClearComp" ) == true )then
					Fox.Log("go to Quiz becaouse Complate")
					TppSequence.ChangeSequence( "Seq_QuizSetup" )
				else
					Fox.Log("go to DemoAfter because not Complate")
					TppSequence.ChangeSequence( "Seq_MissionClearDemoAfter" )
				end
			end,
		}

		TppUI.ShowTransitionWithFadeOut( "ending", TelopEnd, 2 )

		--TppMusicManager.PostJingleEvent( 'MissionEnd', 'Play_bgm_e20060_ed' )

	end,
}

--------------------------------------------------------------------------------
-- クイズ開始シーケンス　ロードまで
this.Seq_QuizSetup = {
	MissionState = "clear",

	Messages = {
		UI = {
			{ message = "MgsQuizLoaded",		localFunc = "QuizLoaded"  },

		},
	},

	OnEnter = function()
		Fox.Log(":: Enter MGS QUIZ ::")

		-- 難易度で問題の定義を変更
		if TppGameSequence.GetGameFlag("hardmode") then
			Fox.Log("setup Quiz table - HARD ")
			--MGSクイズのテーブルセットアップ(ハードモード)
			local uiCommonData = UiCommonDataManager.GetInstance()
			uiCommonData :SetupMgsQuizItemTable(
			  { quizId=11, answerId=1, questionRadioId="e0060_rtrg2080", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId=12, answerId=3, questionRadioId="e0060_rtrg2080", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId=13, answerId=4, questionRadioId="e0060_rtrg2080", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId=14, answerId=3, questionRadioId="e0060_rtrg2082", correctRadioId="e0060_rtrg2102" }
			 ,{ quizId=15, answerId=5, questionRadioId="e0060_rtrg2082", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId=16, answerId=2, questionRadioId="e0060_rtrg2082", correctRadioId="e0060_rtrg2104" }
			 ,{ quizId=17, answerId=4, questionRadioId="e0060_rtrg2084", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId=18, answerId=4, questionRadioId="e0060_rtrg2084", correctRadioId="e0060_rtrg2106" }
			 ,{ quizId=19, answerId=3, questionRadioId="e0060_rtrg2086", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId=20, answerId=5, questionRadioId="e0060_rtrg2090", correctRadioId="e0060_rtrg2108" }
			 )
		else
			Fox.Log("setup Quiz table - NORMAL ")
			--MGSクイズのテーブルセットアップ
			local uiCommonData = UiCommonDataManager.GetInstance()
			uiCommonData :SetupMgsQuizItemTable(
			  { quizId= 1, answerId=4, questionRadioId="e0060_rtrg2080", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId= 2, answerId=3, questionRadioId="e0060_rtrg2080", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId= 3, answerId=3, questionRadioId="e0060_rtrg2080", correctRadioId="e0060_rtrg2102" }
			 ,{ quizId= 4, answerId=4, questionRadioId="e0060_rtrg2082", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId= 5, answerId=2, questionRadioId="e0060_rtrg2082", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId= 6, answerId=3, questionRadioId="e0060_rtrg2082", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId= 7, answerId=1, questionRadioId="e0060_rtrg2082", correctRadioId="e0060_rtrg2104" }
			 ,{ quizId= 8, answerId=2, questionRadioId="e0060_rtrg2084", correctRadioId="e0060_rtrg2100" }
			 ,{ quizId= 9, answerId=2, questionRadioId="e0060_rtrg2086", correctRadioId="e0060_rtrg2106" }
			 ,{ quizId=10, answerId=5, questionRadioId="e0060_rtrg2090", correctRadioId="e0060_rtrg2108" }
			)
		end


		Fox.Log(":: Quiz Load ::")

		-- ミュート設定を変更
		TppMusicManager.PostJingleEvent( "MissionEnd", "Stop_bgm_gntn_ed_default" )

		-- ロード開始
		local uiCommonData = UiCommonDataManager.GetInstance()
		uiCommonData:LoadMgsQuiz()

	end,

	QuizLoaded = function()
		TppSound.PlayEvent( "sfx_s_e20060_quiz_env" )	--fx スタジオ環境音
		TppSequence.ChangeSequence( "Seq_QuizSkip" )
	end,
}

-- クイズ　スキップ可能領域
this.Seq_QuizSkip = {
	MissionState = "clear",

	Messages = {
		UI = {
			{ message = "MgsQuizDisplayed",		localFunc = "QuizDisplayed"  },
		},
		Radio = {
			{ data = "e0060_rtrg2010",		message = "RadioEventMessage", commonFunc = function()
				if ( TppData.GetArgument( 2 ) == 1 )then
					Fox.Log("sfx_s_e20060_quiz_env,sfx_s_e20060_quiz01")
					--TppSound.PlayEvent( "sfx_s_e20060_quiz_env" )	--fx スタジオ環境音
					TppSound.PlayEvent( "sfx_s_e20060_quiz01" )	--fx ドア、歓声
				end
			end },
			{ data = "e0060_rtrg2040",		message = "RadioEventMessage", commonFunc = function()
				if ( TppData.GetArgument( 2 ) == 1 )then
					Fox.Log("sfx_s_e20060_quiz13")
					TppSound.PlayEvent( "sfx_s_e20060_quiz13" )
				end
			end },
			{ data = "e0060_rtrg2060",		message = "RadioEventMessage", commonFunc = function()
				if ( TppData.GetArgument( 2 ) == 1 )then
					Fox.Log("sfx_s_e20060_quiz14")
					TppSound.PlayEvent( "sfx_s_e20060_quiz14" )
				end
			end },
			--特別報酬を与えよう
			{ data = "e0060_rtrg2030",		message = "RadioEventMessage", commonFunc = function()
				if ( TppData.GetArgument( 2 ) == 1 )then
					Fox.Log("sfx_s_e20060_quiz02")
					TppSound.PlayEvent( "sfx_s_e20060_quiz02" )
				end
			end },
			-- ただし報酬はもう
			{ data = "e0060_rtrg2030",		message = "RadioEventMessage", commonFunc = function()
				if ( TppData.GetArgument( 2 ) == 1 )then
					Fox.Log("sfx_s_e20060_quiz15")
					TppSound.PlayEvent( "sfx_s_e20060_quiz15" )
				end
			end },
		},

	},

	OnEnter = function()
		-- 強字幕設定にする
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )

		local uiCommonData = UiCommonDataManager.GetInstance()
		uiCommonData:StartMgsQuizDisplay()
	end,

	-- 表示がおわったら
	QuizDisplayed = function()
		Fox.Log("displayed")
		local skin = false
		-- 難易度とフラグを確認
		if ( TppGameSequence.GetGameFlag("hardmode") == true) then -- ハードモードはスキン確認
			Fox.Log(" Hard mode ")
			if	(TppGameSequence.GetGameFlag("isLowSkin2Enabled") == false ) then
				Fox.Log("no have Skin2")
			else
				Fox.Log("have Skin2")
				skin = true
			end
		else
			Fox.Log(" Normal mode ")
			if	(TppGameSequence.GetGameFlag("isLowSkin1Enabled") == false )then --ノーマルモード
				Fox.Log("no have Skin1")
			else
				Fox.Log("have Skin1")
				skin = true
			end
		end

		local func = {
			onEnd = function()
				this.Seq_QuizSkip.QuizLoaded()
			end
		}

		TppRadio.DelayPlay("Quiz_start1","short" ,	"none")


		if( skin == true )then
			Fox.Log("No reward, have skin")
			Fox.Log("radio : 3")
			TppRadio.DelayPlayEnqueue( "Quiz_skinHave","short" ,"none",func)
		else
			Fox.Log("A reward, no skin")
			Fox.Log("radio : 2")
			TppRadio.DelayPlayEnqueue( "Quiz_skinNot","short" ,"none",func )
		end

	end,


	-- 表示が終わったら
	QuizLoaded = function()
		Fox.Log(":: QuizLoaded ::")
		--クイズ前振り
		local radioId = "Quiz_normal"

		Fox.Log("radio : 4")
		-- 無線のあとにチャレンジするか問いかける
		if( TppMission.GetFlag( "isQuizSkip" ) == false )then
			TppRadio.DelayPlayEnqueue( "Quiz_setumei","mid" ,"none")
		end

		Fox.Log("check Hard mode")

		-- 難易度とフラグを確認
		if ( TppGameSequence.GetGameFlag("hardmode") == true) then -- ハードモード
			Fox.Log(" Hard mode ")
			radioId = "Quiz_hard"
		else
			Fox.Log(" Normal mode ")
			radioId = "Quiz_normal"
		end

		Fox.Log("radio : 5 normal or 6 hard : Enqueue")

		if( TppMission.GetFlag( "isQuizSkip" ) == false )then
			TppRadio.DelayPlayEnqueue( radioId,"short" ,"none" ,{onEnd = function() this.Seq_QuizSkip.QuizSelect()	end})
		end

	end,

	--　チャレンジするか聞く
	QuizSelect = function()
		local funcs = {
			onStart = function() Fox.Log("radio : 7 r u redy?") end,
			onEnd = function()
				TppSequence.ChangeSequence( "Seq_Quiz" )
			end,
		}
		-- 無線のあとにチャレンジするか問いかける
		if( TppMission.GetFlag( "isQuizSkip" ) == false )then
			TppRadio.DelayPlayEnqueue( "Quiz_areYouRedy","short" ,"none",	funcs )
		end
	end,

	OnUpdate = function()
		local hudCommonData = HudCommonDataManager.GetInstance()
		if hudCommonData:IsPushRadioSkipButton() then
			Fox.Log("Skip")
			--MGSクイズの表示開始->デフォルト画面表示まで
			local uiCommonData = UiCommonDataManager.GetInstance()
			uiCommonData:StartMgsQuizDisplay()
			--TppRadio.DelayPlay( "Quiz_skip", nil , "none" )

			-- 再生中の無線停止
			local radioDaemon = RadioDaemon:GetInstance()
			radioDaemon:StopDirectNoEndMessage()
			-- 字幕の停止
			SubtitlesCommand.StopAll()

			TppSequence.ChangeSequence( "Seq_Quiz" )
			TppMission.SetFlag( "isQuizSkip", true )
		end
	end,
}

this.Seq_Quiz = {
-- はい/いいえ　をえらぶ

	MissionState = "clear",

	Messages = {
		UI = {
			{ message = "MgsQuizChallengeYes", 	localFunc = "QuizStart"	},
			{ message = "MgsQuizChallengeNo", 	localFunc = "QuizEnd"  },
			{ message = "MgsQuizFailed", 		localFunc = "QuizFailed"	},
			{ message = "MgsQuizClear", 		localFunc = "QuizClear"  },
			{ message = "MgsQuizFoxDieOK", 		localFunc = "QuizFoxDie"  },
			{ message = "MgsQuizFoxDieNG", 		localFunc = "FoxDieNg"	},
			{ message = "MgsQuizEnd", 			localFunc = "WaitEnd"  },
			{ message = "MgsQuizUnLoaded", 		localFunc = "WaitEnd"  },
		},
		Radio = {
			{ 	message = "RadioEventMessage", commonFunc = function() Fox.Log( TppData.GetArgument( 1 ) ) end },
			-- よしいくぞスネーク
			{ data = "e0060_rtrg2070",		message = "RadioEventMessage", commonFunc = function()
				if ( TppData.GetArgument( 2 ) == 1 )then
					Fox.Log("sfx_s_e20060_quiz03")
					TppSound.PlayEvent( "sfx_s_e20060_quiz03" )
				end
			end },
			-- あとで約束の特別報酬をやろう
			{ data = "e0060_rtrg2140",		message = "RadioEventMessage", commonFunc = function()
				if ( TppData.GetArgument( 2 ) == 1 )then
					Fox.Log("sfx_s_e20060_quiz05")
					TppSound.PlayEvent( "sfx_s_e20060_quiz05" )
				end
			end },
		},
	},

	OnEnter = function()
		Fox.Log("Select challenge")

		-- サウンドを止める
		TppSound.PlayEvent( "Stop_sfx_s_e20060_quiz01" )
		TppSound.PlayEvent( "Stop_sfx_s_e20060_quiz02" )
		TppSound.PlayEvent( "Stop_sfx_s_e20060_quiz13" )
		TppSound.PlayEvent( "Stop_sfx_s_e20060_quiz14" )
		TppSound.PlayEvent( "Stop_sfx_s_e20060_quiz15" )

		local uiCommonData = UiCommonDataManager.GetInstance()
		uiCommonData:StartMgsQuizChallenge()
	end,

	QuizStart = function()
		local funcs = {
			onEnd = function()
				Fox.Log(":: QuizStart ::")
				local uiCommonData = UiCommonDataManager.GetInstance()
				uiCommonData:StartMgsQuizMain()
			end,
		}

		Fox.Log("radio : 7-2 quiz start")
		TppRadio.DelayPlay( "Quiz_goToQuiz",nil ,"none",	funcs )

	end,

	QuizClear = function()
		Fox.Log(":: Quiz Clear ::")

		local radioId = "Quiz_skinGet"
		local funcs = {
			onEnd = function()

				-- 難易度に応じて報酬
				Fox.Log(" check hard mode ")
				if ( TppGameSequence.GetGameFlag("hardmode") == true) then -- ハードモードはスキン2開放
					Fox.Log(" Hard mode ")
					if	(TppGameSequence.GetGameFlag("isLowSkin2Enabled") == false ) then
						Fox.Log(" Set Skin2 flag ")
						TppGameSequence.SetGameFlag("isLowSkin2Enabled", true)
			   			--TppMissionManager.SaveGame() --スキン2開放をセーブ
						radioId = "Quiz_skinGet"
						-- リワード表示のためにフラグを立てる
						TppMission.SetFlag( "isNinjaReward", true )
					else
						Fox.Log(" Skin2 fag is geted allredy")
						radioId = "Quiz_skinNoGet"
		   			end
				else
					Fox.Log(" Normal mode ")
					if	(TppGameSequence.GetGameFlag("isLowSkin1Enabled") == false )then --ノーマルモードはスキン1開放
						Fox.Log(" Set Skin1 flag ")
				  		TppGameSequence.SetGameFlag("isLowSkin1Enabled", true)
						TppGameSequence.SetGameFlag("titleBlackOut", true )
						--TppMissionManager.SaveGame() --スキン1開放をセーブ
						radioId = "Quiz_skinGet"
					else
						Fox.Log(" Skin1 fag is geted allredy")
						radioId = "Quiz_skinNoGet"
		  			end
				end

				Fox.Log("radio : 11-2 or 11-3")
				TppRadio.DelayPlayEnqueue( radioId,"short" ,"none",	{onEnd= function()
					Fox.Log("call ui FOX...")
					local uiCommonData = UiCommonDataManager.GetInstance()
					uiCommonData:StartMgsQuizFoxDie()
				 end} )

			end
		}

		Fox.Log("radio : 11-1 CONGRATULATION !!")
		--TppSound.PlayEvent( "Play_bgm_e20060_quiz_daiseikai" )
		TppRadio.DelayPlayEnqueue( "Quiz_allClear","mid" ,"none",	funcs )

	end,

	QuizFoxDie = function()
		Fox.Log("DIE!!")
		local funcs = {
			onEnd = function()
				--TppSequence.ChangeSequence( "Seq_MissionClearDemoAfter" )
				local uiCommonData = UiCommonDataManager.GetInstance()
				uiCommonData:EndMgsQuiz()

			end
		}
		TppMission.SetFlag( "isQuizComp", true )
		TppRadio.DelayPlayEnqueue( "Quiz_Die",nil ,"none",	funcs )

	end,

	QuizFailed = function()
		Fox.Log(":: Quiz failed ::")

		Fox.Log("radio : 9 failed")
		TppRadio.DelayPlayEnqueue( "Quiz_failed","short" ,"none",	{ onEnd = function()
			Fox.Log("sfx_s_e20060_quiz17")
			TppSound.PlayEvent( "sfx_s_e20060_quiz17" )
			this.Seq_Quiz.NextSeq()
		end} )

	end,

	QuizEnd = function()
		Fox.Log(":: Quiz abort ::")

		Fox.Log("radio : 7-3 quiz cancel")
		TppRadio.DelayPlay( "Quiz_goToTitle","short" ,"none",	{ onEnd = function()
			Fox.Log("sfx_s_e20060_quiz16")
			TppSound.PlayEvent( "sfx_s_e20060_quiz16" )
			this.Seq_Quiz.NextSeq()
		end})
	end,

	FoxDieNg = function()
		Fox.Log(":: Fox Die is NG ::")
	 	TppSound.PlayEvent( "sfx_s_e20060_quiz09" )
		this.Seq_Quiz.NextSeq()
	end,

	NextSeq = function()
		Fox.Log(":: Quiz end ::")
		-- ミュート設定を変更
		TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_lp" )

		local uiCommonData = UiCommonDataManager.GetInstance()
		uiCommonData:EndMgsQuiz()


	end,

	WaitEnd = function()

		Fox.Log("go to Seq_ShowClearReward")
		TppSequence.ChangeSequence( "Seq_MissionClearDemoAfter" )
	end,


}
--------------------------------------------------------------------------------
this.Seq_MissionClearDemoAfter = {

	MissionState = "clear",

	Messages = {
		Timer = {
			{ data = "Timer_endSeq", message = "OnEnd", commonFunc = function() TppSequence.ChangeSequence( "Seq_ShowClearReward" ) end },
		},
	},


	OnEnter = function()

		local func = {
			onStart = function() TppMusicManager.PostJingleEvent( 'SingleShot', 'Set_Switch_bgm_gntn_ed_default_lp' ) end,
			onEnd = function()
				if ( TppMission.GetFlag( "isClearComp" ) == false ) then
					--TppSound.PlayEvent( "sfx_s_e20060_quiz09" )
				end

				TppSequence.ChangeSequence( "Seq_ShowClearReward" )
			end,
		}

		-- 強字幕設定にする
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )

		-- クリア後黒電話
		if ( TppMission.GetFlag( "isClearComp" ) == false ) then
			TppRadio.DelayPlayEnqueue( "Clear_normal2", "short", "none",func )
		else
			if( TppMission.GetFlag( "isQuizComp" ) == true )then
				TppSound.PlayEvent( "sfx_s_e20060_quiz08" )
				TppRadio.DelayPlay( "Clear_complate", 1.5, "none",func )
			else
				TppSequence.ChangeSequence( "Seq_ShowClearReward" )
			end
		end

		-- 保険処理のタイマー　無線が鳴っても進まないときはタイマーで進む
		--GkEventTimerManager.Start( "Timer_endSeq", this.timeEndSeq )

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


--------------------------------------------------------------------------
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

-- ■ Seq_ShowClearReward
-- ミッションクリア後の報酬表示シーケンス
this.Seq_ShowClearReward = {
-- リワードポップアップ
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


--------------------------------------------------------------------------
this.Seq_MissionFailed = {
	MissionState = "failed",
	Messages = {
		Timer = {
		{ data = "MissionFailedProductionTimer",	message = "OnEnd", 	localFunc="OnFinishMissionFailedProduction" },
		},
	},

	-- ミッション失敗演出ウェイト明け
	OnFinishMissionFailedProduction = function( manager )

			--manager:ExitMissionStateFailed()	-- St_FAILEDから抜ける
			TppSequence.ChangeSequence( "Seq_MissionGameOver" )
	end,


	OnEnter = function()
		-- ミッション失敗演出中のウェイトを行う
		TppTimer.Start( "MissionFailedProductionTimer", this.CounterList.GameOverFadeTime )

	end,
}

---------------------------------------------------------------------------------
this.Seq_MissionEnd = {

	OnEnter = function()
		-- ミッション後片付け
		this.commonMissionCleanUp()

		-- ジングルフェード終了
		TppMusicManager.PostJingleEvent( "SingleShot", "Stop_bgm_gntn_ed_default" )

		TppMissionManager.SaveGame()		-- Btk14449対応：報酬獲得Sequenceで獲得した報酬をSaveする
		--ミッションを終了させる（アンロード）
		TppMission.ChangeState( "end" )
	end,
}

this.Seq_PlayerRideHelicopter = {
	Messages = {
		Character = {
			{ data = "SupportHelicopter",		message = "CloseDoor",		localFunc = "FuncMissionClearDemo" },
			{ data = "SupportHelicopter", 		message = "LostControl", commonFunc = function() GZCommon.PlayCameraOnCommonHelicopterGameOver() end },
		},
	},

	OnEnter = function()
		--this.commonMissionClearRadio()
	end,

	FuncMissionClearDemo = function()
		-- ヘリに乗ったらミッション中断
		TppMission.ChangeState( "failed", "PlayerHeli" )

		TppMission.SetFlag( "isMarkHeli", false )
		setHeliMarker()
	end,
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

		Fox.Log(":: onEnter GameOver ::")
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )	-- 強字幕設定にする
		TppRadio.DelayPlay( this.CounterList.GameOverRadioName, nil, "none" )	-- ミッション失敗内容に応じた無線をコール

	end,

	OnEnter = function()
		-- この後の処理はMissionManagerからのmessage（RestartやReturnToTitleなど）に引っ掛けて行うのでここには記述不要
	end,
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Skip Functions
------------------------------------------------------------------------------------------------------------------------------------------------------------------
this.OnSkipEnterCommon = function()

	local sequence = TppSequence.GetCurrentSequence()

	-- do prepare
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionPrepare" ) ) then
		Fox.Log(":: OnSkipeEnterCommon Skip  ::")
		this.onMissionPrepare()
		lowPolyPlayer()--ローポリスネーク　判定あれば切り替える
	end

	-- Set all mission states
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionFailed" ) ) then
		TppMission.ChangeState( "failed" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionAbort" ) ) then
		TppMission.ChangeState( "abort" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionClearDemo" ) ) then
		TppMission.ChangeState( "clear" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionPrepare" ) ) then
		onDemoBlockLoad()
	elseif( sequence == "Seq_MissionPrepare" ) then
		-- デモブロックはここで読み込んでおく
		onDemoBlockLoad()
	end
end

this.OnSkipUpdateCommon = function()
	-- デモブロックが読み込み終わるまで待機
	--return TppMission.IsDemoBlockActive()
	return IsDemoAndEventBlockActive()
end

this.OnSkipLeaveCommon = function()

	local sequence = TppSequence.GetCurrentSequence()

	-- シーケンスごとのセットアップがあればここに書いておく
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionLoad" ) 
		or sequence == "Seq_OpeningDemoEnd" ) then
		MissionSetup()	--Seq_MissionSetup
		-- Mission Photo
		commonPhotoMissionSetup()
		-- Route Set
		commonRouteSetMissionSetup()

		-- コンテニュー時に目的無線を流す
		if( TppMission.GetFlag( "isClearComp" ) == false )then
			TppMission.SetFlag( "isRadioAraskaSay",false )
			TppRadio.DelayPlay( "Miller_op003", "long",nil,{onStart = function() 	this.SetIntelRadio() end,onEnd =function() radioStartCheckEndOfKonkai() end })
		end

	end

end

--復帰処理
this.OnAfterRestore = function()
	chengeRouteSneak("warp")
	TppMission.SetFlag( "isMarkHeli", false )
	setHeliMarker()
	TppMarkerSystem.ResetAllNewMarker()
	--TppEnemy.ChangeRouteSet( "gntn_cp", "TppRouteSet_n",{ warpEnemy = true, startAtZero = true} )

end
---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this
