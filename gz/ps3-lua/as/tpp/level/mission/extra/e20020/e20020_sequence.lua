local this = {}

-------------------------------------------------------------------------------
-- Member Variables
-------------------------------------------------------------------------------
this.missionID										= 20020
this.cpID											= "e20020_cp"

-- ＭＴ倉庫：見回り時間
this.Timer_MTSquad_wareHouse						= (25)
this.Timer_MTSquad_Asylum							= (125)
this.Timer_MTSquad_Heliport_WoodTurret				= (90)
this.Timer_MTSquad_wareHouse_WoodTurret				= (90)
this.Timer_MTSquad_eastTent							= (180)
this.Timer_MTSquad_Heliport_Conversation			= (120)
this.Timer_MTSquad_DeadLost							= (20)
-- ＭＴ倉庫：見回り時間待機時間
this.Timer_MTSquad_WaitWestTent						= (120)
this.Timer_MTSquad_WaitEastTent						= (120)
-- ＭＴ管理棟：ＭＴ倉庫がいない場合の見回り時間
this.Timer_MTCetner_ControlTower					= (60)
this.Timer_MTCetner_WestCenter						= (120)
this.Timer_MTCetner_EastCenter						= (90)
this.Timer_MTCenter_Heliport_Conversation			= (120)
this.Timer_MTCenter_DeadLost						= (20)
-- エリアマーカー
this.Timer_MTSquad_AreaMarkerOn						= (50)												-- エリアマーカー変更時間（次の場所）
this.Timer_MTCenter_AreaMarkerOn					= (50)												-- エリアマーカー変更時間（次の場所）
this.Timer_MTSquad_AreaMarkerOff					= (30)												-- エリアマーカー変更時間（消す時間）
this.Timer_MTCenter_AreaMarkerOff					= (30)												-- エリアマーカー変更時間（消す時間）
this.Timer_Alert_AreaMakrerOff						= (2)												-- Alert or KeepCaution時にエリアマーカーを消す時間
-- トラック兵
this.Timer_EnemyWestern_MoveStart					= (90)												-- 付き添い兵とトラック兵の待ち合わせ保険時間
-- 増援部隊
this.Timer_EnemyReinforce							= (1)												-- 判定時間
-- シーケンス変更タイマー
this.Timer_SequenceChage							= (0.5)
-- ミッション失敗時ビークルサウンドタイマー
this.Timer_EscapeVehicleSound						= (1)
-- ミッション失敗演出徒歩カメラ開始タイマー
this.Timer_OutsideAreaCamera						= (1.0)
-- ミッション失敗演出徒歩カメラ開始タイマー
this.Timer_FocusMapIcon								= (10)

-- ルートセット名
this.RouteSet_Sneak									= "e20020_route_n01"
this.RouteSet_Caution								= "e20020_route_c01"

-- 敵兵キャラＩＤ
this.CharacterID_MT_Center							= "Enemy_US_MissionTargetCenter000"					-- ＭＴ管理棟
this.CharacterID_E_Center01							= "Enemy_US_MissionTargetCenterSquad000"			-- ＭＴ管理棟付き添い兵
this.CharacterID_E_Center02							= "Enemy_US_MissionTargetCenterSquad001"			-- ＭＴ管理棟付き添い兵
this.CharacterID_MT_Squad							= "Enemy_US_MissionTargetSquad000"					-- ＭＴ倉庫
this.CharacterID_E_Squad							= "Enemy_US_MissionTargetSquad001"					-- ＭＴ倉庫付き添い兵
this.CharacterID_E_Vehicle01						= "Enemy_US_Vehicle000"								-- ビークル兵
this.CharacterID_E_Vehicle02						= "Enemy_US_Vehicle001"								-- ビークル兵
this.CharacterID_E_Western01						= "Enemy_US_Western000"								-- トラック兵
this.CharacterID_E_Imitation						= "Enemy_US_Imitation000"							-- トラック付き添い兵
this.CharacterID_E_ArmoredVehicle					= "Enemy_US_Stryker000"								-- 機銃装甲車
this.CharacterID_E_eastTentNorth01					= "Enemy_US_eastTent_north000"						-- 東側難民キャンプ
this.CharacterID_E_eastTentNorth02					= "Enemy_US_eastTent_north001"						-- 東側難民キャンプ
this.CharacterID_E_Reinforce01						= "Enemy_US_Reinforce000"							-- 増援部隊０１：西側
this.CharacterID_E_Reinforce02						= "Enemy_US_Reinforce001"							-- 増援部隊０２：西側
this.CharacterID_E_Reinforce03						= "Enemy_US_Reinforce002"							-- 増援部隊０３：西側
this.CharacterID_E_Reinforce04						= "Enemy_US_Reinforce003"							-- 増援部隊０４：西側
this.CharacterID_E_Reinforce05						= "Enemy_US_Reinforce004"							-- 増援部隊０１：東側
this.CharacterID_E_Reinforce06						= "Enemy_US_Reinforce005"							-- 増援部隊０２：東側
this.CharacterID_E_Reinforce07						= "Enemy_US_Reinforce006"							-- 増援部隊０３：東側
this.CharacterID_E_Reinforce08						= "Enemy_US_Reinforce007"							-- 増援部隊０４：東側

this.CharacterID_SupportHelicopter					= "SupportHelicopter"								-- 支援ヘリ

-- 捕虜キャラＩＤ
this.CharacterID_Hostage_PickingDoor08				= "Hostage_e20020_000"								-- 捕虜 hostage_b
this.CharacterID_Hostage_PickingDoor22				= "Hostage_e20020_001"								-- 捕虜 hostage_d

-- 車両ＩＤ
this.VehicleID_Vehicle00							= "Tactical_Vehicle_WEST_000"						-- ビークル：管制塔
this.VehicleID_Vehicle01							= "Tactical_Vehicle_WEST_001"						-- ビークル：ビークル兵
this.VehicleID_Vehicle02							= "Tactical_Vehicle_WEST_002"						-- ビークル：要人
this.VehicleID_Western01							= "Cargo_Truck_WEST_000"							-- トラック：倉庫
this.VehicleID_Western02							= "Cargo_Truck_WEST_001"							-- トラック：トラック兵
this.VehicleID_ArmoredVehicle						= "Armored_Vehicle_WEST_001"						-- 機銃装甲車

-- 無線ＩＤ
this.ConversationName_Vehicle						= "CTF0040_0040"									-- e0020covList03	-- 旧収容施設前会話
this.ConversationName_Western						= "CTE0020_0010"									-- e0020covList01	-- トラック前会話
this.ConversationName_MT							= "CTE0020_0020"									-- e0020covList02	-- ２名の要人同士の会話
this.ConversationName_MT_Squad						= "CTE0020_0030"									-- e0020covList05	-- 要人Ｂ（指）の会話
this.ConversationName_MT_Center						= "CTE0020_0040"									-- e0020covList06	-- 要人Ａ（目）の会話
this.ConversationName_Common_01						= "CTF0000_0010"									-- e0020covList04	-- 汎用
this.ConversationName_Common_02						= "CTF0040_0010"									-- e0020covList04	-- 汎用
this.ConversationName_Common_03						= "CTF0040_0045"									-- e0020covList04	-- 汎用

-- 写真ＩＤ
this.PhotoID_MT_Squad								= 10												-- 「指」
this.PhotoID_MT_Center								= 20												-- 「目」

-- カセットのＩＤ
this.CassetteID										= "tp_chico_06"										-- 倉庫の武器庫にあるカセットテープ

-- マーカーＩＤ
this.AreaMarkerID_MT_Squad_westTent					= "20020_marker_MTSquad0000"						-- 倉庫：南＆西側難民キャンプ
this.AreaMarkerID_MT_Squad_Asylum					= "20020_marker_MTSquad0001"						-- 旧収容施設
this.AreaMarkerID_MT_Squad_Heliport					= "20020_marker_MTSquad0002"						-- ヘリポート（やぐら）
this.AreaMarkerID_MT_Squad_wareHouse				= "20020_marker_MTSquad0003"						-- 倉庫：北
this.AreaMarkerID_MT_Squad_eastTent					= "20020_marker_MTSquad0004"						-- 東側難民キャンプ
this.AreaMarkerID_MT_Squad_Heliport_Conversation	= "20020_marker_MTSquad0005"						-- ヘリポート（会話付近）
this.AreaMarkerID_MT_Center_westCenter				= "20020_marker_MTCenter0000"						-- 西側管理棟
this.AreaMarkerID_MT_Center_Heliport_Conversation	= "20020_marker_MTCenter0001"						-- ヘリポート（会話付近）
this.MarkerID_EscapeWest							= "TppMarkerLocator_EscapeWest"						-- 脱出マーカー西側
this.MarkerID_EscapeNorth							= "TppMarkerLocator_EscapeNorth"					-- 脱出マーカー北側

-- アナウンスログＩＤ：ミッション固有
this.AnnounceLogID_MT_Squad_Kill					= "announce_mission_40_20020_001_from_0_prio_0"		-- 「指」を排除
this.AnnounceLogID_MT_Squad_Heli					= "announce_mission_40_20020_003_from_0_prio_0"		-- 「指」を回収
this.AnnounceLogID_MT_Center_Kill					= "announce_mission_40_20020_000_from_0_prio_0"		-- 「目」を排除
this.AnnounceLogID_MT_Center_Heli					= "announce_mission_40_20020_002_from_0_prio_0"		-- 「目」を回収
-- アナウンスログＩＤ：汎用
this.AnnounceLogID_MapUpdate						= "announce_map_update"								-- マップ情報を更新
this.AnnounceLogID_MissionInfoUpdate				= "announce_mission_info_update"					-- ミッション情報を更新
this.AnnounceLogID_MissionAreaWarning				= "announce_mission_area_warning"					-- ミッション圏外警告
this.AnnounceLogID_MissionGoal						= "announce_mission_goal"							-- 目標達成
this.AnnounceLogID_EnemyIncrease					= "announce_enemyIncrease"							-- 敵兵士が増員
this.AnnounceLogID_EnemyDecrease					= "announce_enemyDecrease"							-- 敵兵士がエリア外に移動
this.AnnounceLogID_EnemyCollection					= "announce_collection_enemy"						-- 敵兵回収
this.AnnounceLogID_HeliDestroyed					= "announce_destroyed_support_heli"					-- 味方のヘリが撃墜された

-- ＶＩＰグループＩＤ
this.RegisterVipMemberID_MTSquad					= "RegisterVipMember_MTSquad"						-- ＭＴ倉庫
this.RegisterVipMemberID_MTCenter					= "RegisterVipMember_MTCenter"						-- ＭＴ管理棟

-- トロフィーＩＤ
this.TrophyID_GZ_VipRecovery						= 7													-- 要人を二人ともヘリで回収してクリアした
this.TrophyID_GZ_SideOpsClear						= 2													-- サイドオプスを1つクリア
this.TrophyID_GZ_RankSClear							= 4													-- Sランクでミッションをクリア

-- 中間目標番号
this.MissionSubGoal_VipKillTwo						= 1													-- ２名の要人を排除
this.MissionSubGoal_VipKillOne						= 2													-- 残りの要人を排除
this.MissionSubGoal_Escape							= 3													-- 収容施設から脱出せよ

-- 報酬ポップアップ識別用
this.tmpChallengeString = 0
this.tmpBestRank = 0				-- ベストクリアランク比較用(5 = RankD)
this.tmpRewardNum = 0				-- 達成率（報酬獲得数）表示用

-- 尋問データ名前
this.InterrogationID_TargetA						= "InterrogationID_Target_A"						-- 「目」：「｛視察に来た隊員←ターゲット｝なら……この場所に……」
this.InterrogationID_TargetB						= "InterrogationID_Target_B"						-- 「指」：「｛視察に来た隊員←ターゲット｝は……今ここだ……」
this.InterrogationName_TargetA						= "enqt1000_1r1010"									-- 「目」：「｛視察に来た隊員←ターゲット｝なら……この場所に……」
this.InterrogationName_TargetB						= "enqt1000_1r1110"									-- 「指」：「｛視察に来た隊員←ターゲット｝は……今ここだ……」
this.InterrogationCount_TargetA						= 8													-- 要人Ａ「目」を尋問で教える回数
this.InterrogationCount_TargetB						= 4													-- 要人Ｂ「指」を尋問で教える回数

-- ミッション固有ボーナス
this.RecoveryExternalScore							= (7500)

-- デバッグ
this.DebugPrint2DOn									= false												-- デバッグ文字表示
this.DebugVehicleAllDisable							= false												-- 配置してある全ての車両をオフする
this.DebugMissionAreaOutMTSquadOFF					= false												-- 要人倉庫がミッション圏外へ出てもミッション失敗にならない
this.DebugMissionAreaOutMTCenterOFF					= false												-- 要人管理棟がミッション圏外へ出てもミッション失敗にならない
this.DebugSetSniperRifle							= false												-- 初期武器をスナイパーライフルに変更

--------------------------------------------------------------------------------
-- EventSequenceManager
--------------------------------------------------------------------------------
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
	{ "Seq_Waiting_KillMT_Squad_and_Center" },
	{ "Seq_Waiting_KillMT_Center" },
	{ "Seq_Waiting_KillMT_Squad" },
	{ "Seq_Mission_FailedPlayerRideHelicopter" },
	{ "Seq_Mission_FailedPlayerEscapeMissionArea" },
	{ "Seq_Mission_FailedMTEscapeMissionArea" },
	{ "Seq_Waiting_MissionClearPlayerRideHelicopter" },
	{ "Seq_MissionClearEscapeMissionArea" },
	{ "Seq_MissionClearEscapeMissionAreaEnd" },
	{ "Seq_MissionClearPlayerRideHelicopter" },
	{ "Seq_MissionClearShowTransition" },
	{ "Seq_MissionFailed" },
	{ "Seq_MissionEnd_Radio" },
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
	"Seq_Waiting_KillMT_Squad_and_Center",
	"Seq_Waiting_KillMT_Center",
	"Seq_Waiting_KillMT_Squad",
	"Seq_Mission_FailedPlayerRideHelicopter",
	"Seq_Mission_FailedPlayerEscapeMissionArea",
	"Seq_Mission_FailedMTEscapeMissionArea",
	"Seq_Waiting_MissionClearPlayerRideHelicopter",
	"Seq_MissionClearEscapeMissionArea",
	"Seq_MissionClearPlayerRideHelicopter",
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

---------------------------------------------------------------------------------
-- Mission Flag List
---------------------------------------------------------------------------------
this.MissionFlagList = {

	isSeq_Advance									= 0,									-- シーケンス進行フラグ　１：最初にＭＴ倉庫排除　２：最初にＭＴ管理棟排除
	isSupportHelicopterDead							= false,								-- 支援ヘリ死亡※ヘリで要人を回収した時のみ使用
	---------------------------------------------------------------------------------
	-- 初期化
	---------------------------------------------------------------------------------
	isMissionSetupInit								= false,								-- ミッションセットアップ初期化フラグ
	isMissionPhotoInit								= false,								-- ミッション写真初期化フラグ
	isEnemyMarkerInit								= false,								-- エリアマーカー初期化フラグ
	isEnemyCombatInit								= false,								-- コンバット初期化フラグ
	isEnemyDisableRouteInit							= false,								-- 敵兵ルート初期化フラグ
	---------------------------------------------------------------------------------
	-- 敵兵
	---------------------------------------------------------------------------------
	isPlayerRideSneak								= false,								-- プレイヤーが荷台に乗った
	isPlayerGetTruckSniper							= false,								-- トラックの上のスナイパーライフル取得
	---------------------------------------------------------------------------------
	-- 敵兵
	---------------------------------------------------------------------------------
	isMT_TargetMarker_MTSquad						= false,								-- ターゲットマーカー：ＭＴ倉庫
	isMT_TargetMarker_MTCenter						= false,								-- ターゲットマーカー：ＭＴ管理棟
	isMT_BuildingMarker_MTSquad						= false,								-- 建物に入った時マーカー：ＭＴ倉庫
	isMT_BuildingMarker_MTCenter					= false,								-- 建物に入った時マーカー：ＭＴ管理棟
	isMT_InterroMarker_MTSquad						= false,								-- 尋問マーカー：ＭＴ倉庫
	isMT_InterroMarker_MTCenter						= false,								-- 尋問マーカー：ＭＴ管理棟
	isMT_AreaMarker_MTSquad							= 0,									-- エリアマーカー：ＭＴ倉庫
	isMT_AreaMarker_MTCenter						= 0,									-- エリアマーカー：ＭＴ管理棟
	isMT_SquadKill									= 0,									-- ＭＴ倉庫死亡or回収フラグ
	isMT_CenterKill									= 0,									-- ＭＴ管理棟死亡or回収フラグ
	isAlert											= false,								-- アラートフラグ
	isKeepCaution									= false,								-- キープコーションフラグ
	isMbDvcActOpenTop								= false,								-- 端末開いた
	-- 移動状態
	isAlert											= false,								-- アラートフラグ
	isKeepCaution									= false,								-- キープコーションフラグ
	isMT_Squad_GroupVehicleFailed					= false,								-- 車両連携失敗フラグ
	isMT_Center_GroupVehicleFailed					= false,								-- 車両連携失敗フラグ
	-- 移動状態
	isMT_Squad_StateMove							= 0,									-- ＭＴ倉庫移動状態
	isMT_Center_StateMove							= 0,									-- ＭＴ管理棟移動状態
	isEnemy_Vehicle_StateMove						= 0,									-- ビークル兵移動状態
	isEnemy_Western01_StateMove						= 0,									-- トラック兵移動状態
	isEnemy_Imitation_StateMove						= 0,									-- トラック兵に合流する敵兵移動状態
	isEnemy_eastTent01_StateMove					= 0,									-- 東難民キャンプ敵兵（海岸）
	isEnemy_eastTent02_StateMove					= 0,									-- 東難民キャンプ敵兵（倉庫）
	isEnemy_Reinforce_StateMove						= 0,									-- 増援部隊移動状態
	-- タイミングフラグ
	isMT_WaitVehicleRaid_eastTent					= false,								-- ＭＴ（倉庫）車両連携タイミングフラグ
	isMT_WaitVehicleRaid_westTent					= false,								-- ＭＴ（倉庫）車両連携タイミングフラグ
	isMT_WestTentMoveEnd							= false,								-- ＭＴ（倉庫）東難民キャンプ巡回終了フラグ
	isMT_Center_EastCenterMoveEnd					= false,								-- ＭＴ（管理棟）東管理棟巡回終了フラグ
	---------------------------------------------------------------------------------
	-- ギミック
	---------------------------------------------------------------------------------
	isGimmick_Break_WoodTurret02					= false,								--
	---------------------------------------------------------------------------------
	-- 尋問
	---------------------------------------------------------------------------------
	isInterrogation_Count							= 0,									-- 尋問カウント
	isInterrogation_MTSquad							= false,								-- ＭＴ倉庫初回尋問のみ尋問カウント
	isInterrogation_MTCenter						= false,								-- ＭＴ管制塔初回尋問のみ尋問カウント
	---------------------------------------------------------------------------------
	-- 無線
	---------------------------------------------------------------------------------
	isRadio_MissionStart							= false,								-- ミッション開始時無線
	isRadio_MissionStartPlay						= false,								-- ミッション開始時無線中
	isRadio_MissionOutLine01						= false,								-- ミッション補足無線
	isRadio_MissionOutLine02						= false,								-- ミッション補足無線
	isRadio_CheckMbPhotoTutorial					= false,								-- ミッション補足：写真の見方チュートリアル
	isRadio_MarkerOutFirst							= false,								-- ミッション補足無線
	isRadio_MarkerIn								= false,								-- ミッション補足無線
	isRadio_MbDvcActOpenTop							= false,								-- 端末を開いた
	isRadio_MTMbDvcAct_A_Start						= false,								-- 端末でターゲットAの写真を確認したフラグ
	isRadio_MTMbDvcAct_A_End						= false,								-- 端末でターゲットAの写真を確認したフラグ
	isRadio_MTMbDvcAct_B_Start						= false,								-- 端末でターゲットBの写真を確認したフラグ
	isRadio_MTMbDvcAct_B_End						= false,								-- 端末でターゲットBの写真を確認したフラグ
	isRadio_MTMbDvcAct_AB							= false,								-- 端末でターゲットAの写真とターゲットBの写真の確認後
	isRadio_MTSquadCarried							= false,								-- ＭＴ倉庫担いだ
	isRadio_MTCenterCarried							= false,								-- ＭＴ管理棟担いだ
	isRadio_MarkerOnMissionTargetA					= false,								-- マーカーセット
	isRadio_MarkerOnMissionTargetB					= false,								-- マーカーセット
	isRadio_AlertTargetEscape						= false,								-- アラートorキープコーションになったら
	isRadio_FocusMapIcon							= false,								-- ＭＢ端末のアイコンをフォーカスした
	---------------------------------------------------------------------------------
	-- 諜報無線
	---------------------------------------------------------------------------------
	isIntelRadio_Western							= false,								-- トラックの諜報無線
	---------------------------------------------------------------------------------
	-- デモ
	---------------------------------------------------------------------------------
	isSwitchLightDemo								= false,								-- 停電演出を見たか
	---------------------------------------------------------------------------------
	-- その他
	---------------------------------------------------------------------------------
	isDebug_EscapeArea_West							= false,								-- デバッグ：西ミッション圏外エリアに要人２名設置
	isDebug_EscapeArea_East							= false,								-- デバッグ：西ミッション圏外エリアに要人２名設置
	isPrimaryWPIcon									= false,								-- プライマリウェポン切り替えチュートリアル表示をした
	isCarTutorial									= false,								-- 乗り物チュートリアルのボタン表示をした
	isAVMTutorial									= false,								-- 装甲車チュートリアルのボタン表示をした
	isHeliLandNow									= false,								-- ヘリが地面にホバリングってるかどうか
}

---------------------------------------------------------------------------------
-- Mission Counter List
---------------------------------------------------------------------------------
this.CounterList = {
	DEBUG_commonPrint2DCount						= 0,									-- デバッグ文字用カウント
	-- 敵兵
	VipOnEscapeVehicleID							= "NoRide",								-- ＶＩＰが車両に乗っているＩＤ	⇒ ミッション失敗用
	VipOnEscapeCharacterID							= "NoCharacterID",						-- ＶＩＰのキャラＩＤ			⇒ ミッション失敗用
	VipOnEscapeArea									= "NoArea",								-- ＶＩＰが車両で出たエリア名	⇒ ミッション失敗用
	ForceRoute_MTSquad								= "OFF",								-- ＭＴ倉庫強制ルート行動
	ForceRoute_MTCenter								= "OFF",								-- ＭＴ管理棟強制ルート行動
	IntelRadioBuilding_MTSquad						= false,								-- 建物の諜報無線
	IntelRadioBuilding_MTCenter						= false,								-- 建物の諜報無線
	-- 車両名
	VehicleEndName_Vehicle							= "NoName",								-- ミッション圏外へ出たビークル名
	VehicleEndName_Western							= "NoName",								-- ミッション圏外へ出たトラック名
	-- 共通
	GameOverRadioName								= "NoRadio",							-- ゲームオーバー無線名
	GameOptionalRadioName							= "NoRadio",							-- 現在の任意無線名
	GameOverFadeTime								= GZCommon.FadeOutTime_MissionFailed,	-- ゲームオーバー時フェードアウト開始までのウェイト
	-- シーケンス名
	NextSequenceName								= "NoName",								-- シーケンス名
	HeliRendezvousPointName							= "NoName",								-- ランデブーポイント名
	-- デバッグ
	DEBUG_commonPrint2DCount						= 0,									-- デバッグ文字用カウント
}

---------------------------------------------------------------------------------
-- Demo List
---------------------------------------------------------------------------------
this.DemoList = {
	Demo_Opening 									= "p12_010000_000",						-- オープニングデモ
	Demo_AreaEscapeNorth							= "p11_020010_000",						-- ミッション圏外離脱カメラデモ：北側
	Demo_AreaEscapeWest								= "p11_020020_000",						-- ミッション圏外離脱カメラデモ：西側
	SwitchLightDemo									= "p11_020003_000",
}

---------------------------------------------------------------------------------
-- Radio List
---------------------------------------------------------------------------------
--　リアルタイム無線
this.RadioList = {

	---------------------------------------------------------------------------------
	-- リアルタイム無線
	---------------------------------------------------------------------------------
	-- ミッション
	Radio_MissionStart								= "e0020_rtrg0010",						-- ミッション開始時
	Radio_MissionStartContinue						= "e0020_rtrg0009",						-- ミッション開始時：コンティニュー時
	-- ミッション補足
	Radio_MbDvcActOpenTop							= { "e0020_rtrg0011", 1 },				-- ミッション補足：行動範囲を端末で参照可能
	Radio_MissionOutLine01							= { "e0020_rtrg0030", 1 },				-- ミッション補足：ミッション説明後、追加注意
	Radio_MissionOutLine02							= { "e0020_rtrg0029", 1 },				-- ミッション補足：今回の依頼について
	Radio_CheckMbPhotoTutorial						= "e0020_rtrg0018",						-- ミッション補足：写真の見方チュートリアル
	Radio_CheckMbPhoto								= "e0020_rtrg0019",						-- ミッション補足：端末でターゲットの写真を確認しろ
	Radio_MarkerOutFirst							= "e0020_rtrg0015",						-- ミッション補足（ターゲットは移動した）１回目
	Radio_MarkerOutSecond							= "e0020_rtrg0016",						-- ミッション補足（ターゲットは移動した）２回目
	Radio_MarkerIn									= "e0020_rtrg0017",						-- ミッション補足（ターゲット再補足）
	-- キープコーション時
	Radio_KeepCaution_KillOne						= "e0020_rtrg0050",						-- 警備が強化される事をユーザーに伝えたい※ターゲットの死体が見つかった
	Radio_KeepCaution_KillTwo						= "e0020_rtrg0055",						-- 警備が強化される事をユーザーに伝えたい※ターゲットの死体が見つかった
	-- アラート時
	Radio_AlertTargetEscapeTwo						= "e0020_rtrg0039",						-- ターゲット逃亡開始
	Radio_AlertTargetEscapeOne						= "e0020_rtrg0038",						-- ターゲット逃亡開始
	---------------------------------------------------------------------------------
	-- リアルタイム無線　ミッションクリアorミッションフェイルド
	---------------------------------------------------------------------------------
	-- ミッションクリア
	Radio_MissionClearRank_D						= "e0020_rtrg0090",						-- ミッションランク
	Radio_MissionClearRank_C						= "e0020_rtrg0091",						-- ミッションランク
	Radio_MissionClearRank_B						= "e0020_rtrg0092",						-- ミッションランク
	Radio_MissionClearRank_A						= "e0020_rtrg0093",						-- ミッションランク
	Radio_MissionClearRank_S						= "e0020_rtrg0094",						-- ミッションランク
	-- ミッション失敗警告
	Radio_MissionFailed_Warning_Heli				= "e0020_rtrg0080",						-- 汎用無線を使うようにした※Radio_RideHeli_Warning参照
	Radio_MissionFailed_Warning_OutsideArea			= "f0090_rtrg0310",						-- 汎用無線
	Radio_MissionClear_Warning_OutsideArea			= "f0090_rtrg0315",						-- 汎用無線
	-- ミッション失敗
	Radio_MissionFailed_PlayerDead					= "f0033_gmov0010",						-- ＰＣ死亡：ダメージ、崖落下
	Radio_MissionFailed_PlayerHeliDead				= "f0033_gmov0010",						-- ヘリ墜落：
	Radio_MissionFailed_PlayerEscapeMissionArea		= "f0033_gmov0020",						-- ＰＣミッション圏外移動：ミッション圏外に行ったら
	Radio_MissionFailed_PlayerRideHelicopter		= "f0033_gmov0040",						-- ミッション中止：ターゲットを置いてヘリで離脱した
	Radio_MissionFailed_MTEscapeMissionArea			= "f0033_gmov0130",						-- 要人がミッション圏外へ到達
	Radio_RideHeli_Warning							= "f0090_rtrg0130",						-- ミッション中断警告「どうした？ミッション中止か？」
	Radio_RideHeli_Clear							= "f0090_rtrg0460",						-- ヘリで離脱する「よし、乗ってくれ！離脱する！」
	-- ミッション終了無線
	Radio_MissionClear_Recovery						= { "e0020_rtrg0099", 1 },				-- 黒電話：２名回収
	Radio_MissionClear_Kill							= { "e0020_rtrg0100", 1 },				-- 黒電話：どちらかを排除した
	---------------------------------------------------------------------------------
	-- リアルタイム無線　ミッションターゲット
	---------------------------------------------------------------------------------
	-- 端末で写真確認
	Radio_MbDvcActMissionTargetA					= { "e0020_rtrg0025", 1 },
	Radio_MbDvcActMissionTargetB					= { "e0020_rtrg0020", 1 },
	Radio_MbDvcActMissionTargetAB					= { "e0020_rtrg0027", 1 },
	-- ターゲットを見つけた
	Radio_MarkerOnFirstMissionTargetA				= { "e0020_rtrg0033", 1 },
	Radio_MarkerOnFirstMissionTargetB				= { "e0020_rtrg0031", 1 },
	-- ターゲットを見つけた※２回目以降
	Radio_MarkerOnSecondMissionTargetA				= "e0020_rtrg0035",
	Radio_MarkerOnSecondMissionTargetB				= "e0020_rtrg0035",
	-- ターゲットを担いで見つけた
	Radio_MarkerOnCarriedMissionTargetA				= "e0020_rtrg0036",
	Radio_MarkerOnCarriedMissionTargetB				= "e0020_rtrg0036",
	-- ターゲットを担いで見つけた
	Radio_MarkerOnRestrainMissionTargetA			= "e0020_rtrg0036",
	Radio_MarkerOnRestrainMissionTargetB			= "e0020_rtrg0036",
	-- ターゲット排除
	Radio_MissionTargetKillOne						= "e0020_rtrg0040",
	Radio_MissionTargetKillTwo						= "e0020_rtrg0070",
	-- ターゲットヘリ回収
	Radio_MissionTargetHeliOne						= "e0020_rtrg0045",
	Radio_MissionTargetHeliTwo						= "e0020_rtrg0075",
	-- ターゲット排除orヘリ回収
	Raio_MissionTargetGoalAdvice					= "e0020_rtrg0077",
	-- ターゲットを気絶or睡眠状態にした
	Radio_MissionTargetSleepFaint					= "e0020_rtrg0037",
	-- ターゲットを担いだ
	Radio_MissionTargetCarriedOne					= "e0020_rtrg0079",
	Radio_MissionTargetCarriedTwo					= "e0020_rtrg0078",
	-- ターゲットが建物内に入った
	Radio_MissionTargetInBuilding					= "e0020_rtrg0060",
	-- ＭＢ端末でターゲットアイコンをフォーカスした
	Radio_MissionTargetFocusMapIcon					= "f0090_rtrg0335",
	---------------------------------------------------------------------------------
	-- リアルタイム無線　捕虜
	---------------------------------------------------------------------------------
	--捕虜の居るエリア（旧収容施設）に入ったら
	Radio_DiscoverHostage							= { "f0090_rtrg0470", 1 },				-- 捕虜を見つけた「捕虜か。どうする。助けるか？」
	--捕虜をヘリに乗せたら以下を連続再生
	Radio_HostageOnHeli								= "f0090_rtrg0210",						-- 捕虜をヘリに乗せた
	Radio_HostageDead								= "f0090_rtrg0540",						-- 捕虜死亡（プレイヤー）
	---------------------------------------------------------------------------------
	-- 汎用無線
	---------------------------------------------------------------------------------
	--汎用無線
	Miller_DontSneakPhase							= "f0090_rtrg0110",						-- キープコーション後、スニークフェイズに戻らない
	Miller_ReturnToSneak							= "f0090_rtrg0270",						-- スニークフェイズに戻った
	Miller_RecoveryLifeAdvice						= {"f0090_rtrg0280", 1},				-- 体力回復促し
	Miller_SpRecoveryLifeAdvice						= {"f0090_rtrg0290", 1},				-- 超体力回復促し
	Miller_RevivalAdvice							= {"f0090_rtrg0300", 1},				-- 体力戻った
	Miller_CuarAdvice								= "f0090_rtrg0300",						-- キュア促し
	Miller_EnemyOnHeli								= "f0090_rtrg0210",						-- ターゲット以外をヘリで回収したら
	Miller_BreakSuppressor							= "f0090_rtrg0530",						-- サプレッサー壊れる
	Miller_HeliDead									= "f0090_rtrg0220",						-- ヘリ撃墜
	Miller_HeliDeadSneak							= "f0090_rtrg0155",						-- プレイヤーがヘリ撃墜
	Miller_HeliNoCall								= "f0090_rtrg0166",						-- ヘリを呼べない
	Miller_CallHeli01								= "f0090_rtrg0170",						-- 支援ヘリ要請時
	Miller_CallHeli02								= "f0090_rtrg0171",						-- 支援ヘリ要請時
	Miller_HeliAttack 								= "f0090_rtrg0225",						-- 支援ヘリがプレイヤーから攻撃を受けた
	Miller_HeliLeave 								= "f0090_rtrg0465",						-- 支援ヘリから離れろ促し
	Miller_AllGetTape								= {"f0090_rtrg0560", 1},				-- カセットテープ全取得
	Miller_CallHeliHot01							= "e0010_rtrg0376",						-- 支援ヘリ要請時/ホットゾーン
	Miller_CallHeliHot02							= "e0010_rtrg0377",						-- 支援ヘリ要請時/ホットゾーン
}

-- 任意無線
this.OptionalRadioList = {
	-- セット任意無線
	OptionalRadio_001								= "Set_e0020_oprg0010",					-- ミッション開始からターゲットを一人排除するまでで：
	OptionalRadio_001_TargetOn						= "Set_e0020_oprg0011",					-- ミッション開始からターゲットを一人排除するまでで：（ターゲットどちらも確認済）
	OptionalRadio_001_Alert							= "Set_e0020_oprg0012",					-- 二人未排除でアラートになった
	OptionalRadio_001_Escape						= "Set_e0020_oprg0015",					-- 二人未排除撤退開始
	OptionalRadio_002								= "Set_e0020_oprg0020",					-- 目標を一人排除してからクリア条件を達成するまでで：
	OptionalRadio_002_Escape						= "Set_e0020_oprg0025",					-- 一人排除済撤退開始
	OptionalRadio_003								= "Set_e0020_oprg0030",					-- クリア条件を満たしてからミッションクリアまでで
}

-- 諜報無線
this.IntelRadioList = {
	-- CharacterID
	Enemy_US_MissionTargetSquad000					= "e0020_esrg0010",						-- ターゲットAを双眼鏡で捉えた状態で諜報無線
	Enemy_US_MissionTargetCenter000					= "e0020_esrg0015",						-- ターゲットBを双眼鏡で捉えた状態で諜報無線
	-- ビークル兵
	Enemy_US_Vehicle000								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	-- トラック兵
	Enemy_US_Western								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	-- トラック付き添い兵
	Enemy_US_Imitation000							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	-- その他敵兵
	Enemy_US_Asylum000								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_bridge000								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_center000								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_center001								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_center002								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_center003								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_eastTentGroup_north000					= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Heliport000							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Heliport001							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Heliport002							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Heliport003							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Heliport004							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Imitation000							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_MissionTargetSquad001					= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Seaside000								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Stryker000								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_WareHouse000							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_WareHouse001							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_westTentGroup_north000					= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_westTentGroup_north001					= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_WoodTurret000							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_MissionTargetCenterSquad000			= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_MissionTargetCenterSquad001			= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Vehicle001								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Western000								= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_eastTent_south000						= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_IronTurret000							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_WareHouse002							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_eastTent_north000						= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_eastTent_north001						= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_westTent000							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_westTent001							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_IronTurret001							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Reinforce004							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Reinforce005							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Reinforce006							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Reinforce007							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Reinforce001							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Reinforce000							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Reinforce002							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	Enemy_US_Reinforce003							= "e0020_esrg0020",						-- 目標以外の敵兵を双眼鏡で捉えた状態で諜報無線
	-- トラック
	Cargo_Truck_WEST_000							= "f0090_esrg0050",						-- トラックを双眼鏡で捉えて諜報無線
	Cargo_Truck_WEST_001							= "e0020_esrg0100",						-- トラックを双眼鏡で捉えて諜報無線
	-- 機銃装甲車
	Armored_Vehicle_WEST_001						= "e0020_esrg0050",						-- 機銃装甲車を双眼鏡で捉えて諜報無線
	-- 武器庫
	intel_e0020_esrg0070a							= "e0020_esrg0070",						-- 武器庫を双眼鏡で捉えて諜報無線：倉庫
	intel_e0020_esrg0070b							= "e0020_esrg0070",						-- 武器庫を双眼鏡で捉えて諜報無線：ヘリポート
	intel_e0020_esrg0070c							= "e0020_esrg0070",						-- 武器庫を双眼鏡で捉えて諜報無線：管理棟
	-- 逃げ込んだ建物 要人Ａ
	intel_e0020_esrg0080a_a							= "e0020_esrg0080",						-- ターゲットが逃げ込んだ建物を双眼鏡で捉えて諜報無線 -- 倉庫の武器庫
	intel_e0020_esrg0080a_b							= "e0020_esrg0080",						-- ターゲットが逃げ込んだ建物を双眼鏡で捉えて諜報無線 -- ヘリポートの武器庫
	-- 逃げ込んだ建物 要人Ｂ
	intel_e0020_esrg0080b_a							= "e0020_esrg0080",						-- ターゲットが逃げ込んだ建物を双眼鏡で捉えて諜報無線 -- 管理棟の武器庫
	intel_e0020_esrg0080b_b							= "e0020_esrg0080",						-- ターゲットが逃げ込んだ建物を双眼鏡で捉えて諜報無線 -- ヘリポートの武器庫
	-- 逃げ込んだ建物 ２人
	intel_e0020_esrg0081							= "e0020_esrg0081",						-- ターゲットが逃げ込んだ建物を双眼鏡で捉えて諜報無線 -- ヘリポートの武器庫
	-- 汎用無線
	intel_f0090_esrg0110							= "f0090_esrg0110",						-- 収容施設
	intel_f0090_esrg0120							= "f0090_esrg0120",						-- 難民キャンプ
	intel_f0090_esrg0130							= "f0090_esrg0130",						-- 旧収容区画について
	intel_f0090_esrg0140							= "f0090_esrg0140",						-- 管理棟
	intel_f0090_esrg0150							= "f0090_esrg0150",						-- 運搬用ゲート（GZ)について
	intel_f0090_esrg0190							= "f0090_esrg0190",						-- 赤い扉について
	intel_f0090_esrg0200							= "f0090_esrg0200",						-- 星条旗について
	--やぐら
	WoodTurret01									= "e0020_esrg0090",
	WoodTurret02									= "e0020_esrg0090",
	WoodTurret03									= "e0020_esrg0090",
	WoodTurret04									= "e0020_esrg0090",
	WoodTurret05									= "e0020_esrg0090",
	intel_e0020_esrg0090							= "e0020_esrg0090",
	--ドラム缶
	gntnCom_drum0002								= "f0090_esrg0180",
	gntnCom_drum0005								= "f0090_esrg0180",
	gntnCom_drum0011								= "f0090_esrg0180",
	gntnCom_drum0012								= "f0090_esrg0180",
	gntnCom_drum0015								= "f0090_esrg0180",
	gntnCom_drum0019								= "f0090_esrg0180",
	gntnCom_drum0020								= "f0090_esrg0180",
	gntnCom_drum0021								= "f0090_esrg0180",
	gntnCom_drum0022								= "f0090_esrg0180",
	gntnCom_drum0023								= "f0090_esrg0180",
	gntnCom_drum0024								= "f0090_esrg0180",
	gntnCom_drum0025								= "f0090_esrg0180",
	gntnCom_drum0027								= "f0090_esrg0180",
	gntnCom_drum0028								= "f0090_esrg0180",
	gntnCom_drum0029								= "f0090_esrg0180",
	gntnCom_drum0030								= "f0090_esrg0180",
	gntnCom_drum0031								= "f0090_esrg0180",
	gntnCom_drum0035								= "f0090_esrg0180",
	gntnCom_drum0037								= "f0090_esrg0180",
	gntnCom_drum0038								= "f0090_esrg0180",
	gntnCom_drum0039								= "f0090_esrg0180",
	gntnCom_drum0040								= "f0090_esrg0180",
	gntnCom_drum0041								= "f0090_esrg0180",
	gntnCom_drum0042								= "f0090_esrg0180",
	gntnCom_drum0043								= "f0090_esrg0180",
	gntnCom_drum0044								= "f0090_esrg0180",
	gntnCom_drum0045								= "f0090_esrg0180",
	gntnCom_drum0046								= "f0090_esrg0180",
	gntnCom_drum0047								= "f0090_esrg0180",
	gntnCom_drum0048								= "f0090_esrg0180",
	gntnCom_drum0065								= "f0090_esrg0180",
	gntnCom_drum0066								= "f0090_esrg0180",
	gntnCom_drum0068								= "f0090_esrg0180",
	gntnCom_drum0069								= "f0090_esrg0180",
	gntnCom_drum0070								= "f0090_esrg0180",
	gntnCom_drum0071								= "f0090_esrg0180",
	gntnCom_drum0072								= "f0090_esrg0180",
	gntnCom_drum0101								= "f0090_esrg0180",
	--監視カメラ
	e20020_SecurityCamera_01						= "f0090_esrg0210",
	e20020_SecurityCamera_02						= "f0090_esrg0210",
	e20020_SecurityCamera_03						= "f0090_esrg0210",
	e20020_SecurityCamera_05						= "f0090_esrg0210",
	--ゲート開閉スイッチ
	intel_f0090_esrg0220							= "f0090_esrg0220",
	Tactical_Vehicle_WEST_001						= "f0090_esrg0040", -- 四輪駆動車について
	Tactical_Vehicle_WEST_002						= "f0090_esrg0040", -- 四輪駆動車について
	Tactical_Vehicle_WEST_003						= "f0090_esrg0040", -- 四輪駆動車について
	Tactical_Vehicle_WEST_004						= "f0090_esrg0040", -- 四輪駆動車について
	Tactical_Vehicle_WEST_005						= "f0090_esrg0040", -- 四輪駆動車について
	gntn_area01_antiAirGun_000						= "f0090_esrg0030", -- 対空機関砲について
	gntn_area01_antiAirGun_001						= "f0090_esrg0030", -- 対空機関砲について
	gntn_area01_antiAirGun_002						= "f0090_esrg0030", -- 対空機関砲について
	gntn_area01_antiAirGun_003						= "f0090_esrg0030", -- 対空機関砲について
}

---------------------------------------------------------------------------------
-- Enemy List
---------------------------------------------------------------------------------
this.AllEnemyDisableList = {
	"Enemy_US_Asylum000",
	"Enemy_US_bridge000",
	"Enemy_US_center000",
	"Enemy_US_center001",
	"Enemy_US_center002",
	"Enemy_US_center003",
	"Enemy_US_eastTentGroup_north000",
	"Enemy_US_Heliport000",
	"Enemy_US_Heliport001",
	"Enemy_US_Heliport002",
	"Enemy_US_Heliport003",
	"Enemy_US_Heliport004",
	"Enemy_US_Imitation000",
	"Enemy_US_Seaside000",
	"Enemy_US_Stryker000",
	"Enemy_US_WareHouse000",
	"Enemy_US_WareHouse001",
	"Enemy_US_westTentGroup_north000",
	"Enemy_US_westTentGroup_north001",
	"Enemy_US_WoodTurret000",
	"Enemy_US_Vehicle001",
	"Enemy_US_Western000",
	"Enemy_US_eastTent_south000",
	"Enemy_US_IronTurret000",
	"Enemy_US_WareHouse002",
	"Enemy_US_eastTent_north000",
	"Enemy_US_eastTent_north001",
	"Enemy_US_westTent000",
	"Enemy_US_westTent001",
	"Enemy_US_IronTurret001",
	"Enemy_US_Reinforce000",
	"Enemy_US_Reinforce001",
	"Enemy_US_Reinforce002",
	"Enemy_US_Reinforce003",
	"Enemy_US_Reinforce004",
	"Enemy_US_Reinforce005",
	"Enemy_US_Reinforce006",
	"Enemy_US_Reinforce007",
}
---------------------------------------------------------------------------------
-- ContinueHostageRegisterList Functions
---------------------------------------------------------------------------------
this.ContinueHostageRegisterList = {
	-- ビークル
	CheckList01 = {
		Pos						= "e20020_Vehicle0000",
		VehicleType				= "Vehicle",
		HostageRegisterPoint	= { "e20020_Vehicle0000_H0001", "e20020_Vehicle0000_H0002", },
	},
	CheckList02 = {
		Pos						= "e20020_Vehicle0001",
		VehicleType				= "Vehicle",
		HostageRegisterPoint	= { "e20020_Vehicle0001_H0001", "e20020_Vehicle0001_H0002", },
	},
	CheckList03 = {
		Pos						= "e20020_Vehicle0002",
		VehicleType				= "Vehicle",
		HostageRegisterPoint	= { "e20020_Vehicle0002_H0001", "e20020_Vehicle0002_H0002", },
	},
	-- トラック
	CheckList04 = {
		Pos						= "e20020_Truck0000",
		VehicleType				= "Truck",
		HostageRegisterPoint	= { "e20020_Truck0000_H0001", "e20020_Truck0000_H0002", },
	},
	CheckList05 = {
		Pos						= "e20020_Truck0001",
		VehicleType				= "Truck",
		HostageRegisterPoint	= { "e20020_Truck0001_H0001", "e20020_Truck0001_H0002", },
	},
	-- 機銃装甲車
	CheckList06 = {
		Pos						= "e20020_ArmoredVehicle0000",
		VehicleType				= "Armored_Vehicle",
		HostageRegisterPoint	= { "e20020_ArmoredVehicle0000_H0001", "e20020_ArmoredVehicle0000_H0002", },
	},
	-- トラック兵 旧収容施設
	CheckList07 = {
		Pos						= "e20020_EV00_01_V",
		VehicleType				= "Vehicle",
		HostageRegisterPoint	= { "e20020_EV00_01_V_H0001", "e20020_EV00_01_V_H0002", },
	},
	-- ＭＴ倉庫「指」西難民キャンプ
	CheckList08 = {
		Pos						= "e20020_MT00_01_V",
		VehicleType				= "Vehicle",
		HostageRegisterPoint	= { "e20020_MT00_01_V_H0001", "e20020_MT00_01_V_H0002", },
	},
	-- ＭＴ倉庫「指」旧収容施設
	CheckList09 = {
		Pos						= "e20020_MT00_02_V",
		VehicleType				= "Vehicle",
		HostageRegisterPoint	= { "e20020_MT00_02_V_H0001", "e20020_MT00_02_V_H0002", },
	},
	-- ＭＴ倉庫「指」ヘリポート（やぐら前）
	CheckList10 = {
		Pos						= "e20020_MT00_03_V",
		VehicleType				= "Vehicle",
		HostageRegisterPoint	= { "e20020_MT00_03_V_H0001", "e20020_MT00_03_V_H0002", },
	},
	-- ＭＴ倉庫「指」倉庫
	CheckList11 = {
		Pos						= "e20020_MT00_04_V0000",
		VehicleType				= "Vehicle",
		HostageRegisterPoint	= { "e20020_MT00_04_V0000_H0001", "e20020_MT00_04_V0000_H0002", },
	},
	-- ＭＴ倉庫「指」東難民キャンプ
	CheckList12 = {
		Pos						= "e20020_MT00_04_V0001",
		VehicleType				= "Vehicle",
		HostageRegisterPoint	= { "e20020_MT00_04_V0001_H0001", "e20020_MT00_04_V0001_H0002", },
	},
	-- ＭＴ倉庫「指」ヘリポート（会話前）
	CheckList13 = {
		Pos						= "e20020_MT00_05_V",
		VehicleType				= "Vehicle",
		HostageRegisterPoint	= { "e20020_MT00_05_V_H0001", "e20020_MT00_05_V_H0002", },
	},
}
-- クリアランク報酬テーブル
this.ClearRankRewardList = {

	-- ステージ上に配置した報酬アイテムロケータのLocatorIDを登録
	RankS = "e20020_Assult",
	RankA = "e20020_Sniper",
	RankB = "e20020_ShotGun",
	RankC = "e20020_MachineGun",
}

this.ClearRankRewardPopupList = {

	-- 報酬アイテム入手ポップアップID
	RankS = "reward_clear_s_rifle",
	RankA = "reward_clear_a_sniper",
	RankB = "reward_clear_b_shotgun",
	RankC = "reward_clear_c_submachine",
}
---------------------------------------------------------------------------------
-- Debug Functions
---------------------------------------------------------------------------------
-- commonPrint2D
local commonPrint2D = function( string, num )
	local	params
			string = string or 0
			num = num or 0
	-- デバッグ２Ｄ文字表示
	if( this.DebugPrint2DOn == true ) then
		if( this.CounterList.DEBUG_commonPrint2DCount == 20 ) then
			this.CounterList.DEBUG_commonPrint2DCount = 0
		else
			this.CounterList.DEBUG_commonPrint2DCount = this.CounterList.DEBUG_commonPrint2DCount + 1
		end
		if( num == 0 ) then
			params = {
				life = 150,
				x = 50, y = 200+(this.CounterList.DEBUG_commonPrint2DCount*15) ,
				size = 10, color = Color( 1.0, 0.0, 0.0, 1.0 ),
				args = { string },
			}
		elseif( num == 1 ) then
			params = {
				life = 150,
				x = 50, y = 200+(this.CounterList.DEBUG_commonPrint2DCount*15) ,
				size = 10, color = Color( 0.0, 1.0, 0.0, 1.0 ),
				args = { string },
			}
		elseif( num == 2 ) then
			params = {
				life = 150,
				x = 50, y = 200+(this.CounterList.DEBUG_commonPrint2DCount*15) ,
				size = 10, color = Color( 0.0, 0.0, 1.0, 1.0 ),
				args = { string },
			}
		elseif( num == 3 ) then
			params = {
				life = 150,
				x = 50, y = 200+(this.CounterList.DEBUG_commonPrint2DCount*15) ,
				size = 10, color = Color( 1.0, 1.0, 1.0, 1.0 ),
				args = { string },
			}
		end
		GrxDebug.Print2D( params )
	end
end

---------------------------------------------------------------------------------
-- ■■ Common Functions
---------------------------------------------------------------------------------
-- ■ ユニークキャラルートチェンジ
local commonSetUniqueRouteChange = function( icharacterID, iRouteSetName, iOnRoute, iOffRoute, iRoutePoint )
	if( iOnRoute ~= 0 ) then
		if( iOffRoute ~= -1 ) then
			TppCommandPostObject.GsAddDisabledRoutes(	this.cpID, 								iOffRoute,	false )
		end
		TppCommandPostObject.GsDeleteDisabledRoutes(	this.cpID, 								iOnRoute,	false )
		TppEnemy.ChangeRoute( 							this.cpID, icharacterID, iRouteSetName,	iOnRoute,	iRoutePoint )
	end
end

-- ルートチェンジテーブル
this.TimerRouteChageTable = {}

-- ルートチェンジテーブル最大地
this.TimerRouteChageMax = 20

-- ルートチェンジテーブル初期化
local commonTimerRouteChageTableSetup = function()
	for i=1, 255, 1 do
		this.TimerRouteChageTable[i] = 0
	end
end

-- ■ 時間指定ルートチェンジ
local commonSetTimeRouteChage = function( iTimer, iOnRoute, iOffRoute )
	local isSetTimeRouteChage = false
	if( iTimer == 0 ) then
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID, iOnRoute, iOffRoute )
	else
		for i=1, this.TimerRouteChageMax, 2 do
			if( isSetTimeRouteChage == false ) then
				if( this.TimerRouteChageTable[i] == 0 and this.TimerRouteChageTable[i+1] == 0 ) then
					if( i == 1) then
						Fox.Log("Timer_RouteChageTable01 START " )
						TppTimer.Start("Timer_RouteChageTable01", iTimer )
					elseif( i == 3 ) then
						Fox.Log("Timer_RouteChageTable02 START " )
						TppTimer.Start("Timer_RouteChageTable02", iTimer )
					elseif( i == 5 ) then
						Fox.Log("Timer_RouteChageTable03 START " )
						TppTimer.Start("Timer_RouteChageTable03", iTimer )
					elseif( i == 7 ) then
						Fox.Log("Timer_RouteChageTable04 START " )
						TppTimer.Start("Timer_RouteChageTable04", iTimer )
					elseif( i == 9 ) then
						Fox.Log("Timer_RouteChageTable05 START " )
						TppTimer.Start("Timer_RouteChageTable05", iTimer )
					elseif( i == 11 ) then
						Fox.Log("Timer_RouteChageTable06 START " )
						TppTimer.Start("Timer_RouteChageTable06", iTimer )
					elseif( i == 13 ) then
						Fox.Log("Timer_RouteChageTable07 START " )
						TppTimer.Start("Timer_RouteChageTable07", iTimer )
					elseif( i == 15 ) then
						Fox.Log("Timer_RouteChageTable08 START " )
						TppTimer.Start("Timer_RouteChageTable08", iTimer )
					elseif( i == 17 ) then
						Fox.Log("Timer_RouteChageTable09 START " )
						TppTimer.Start("Timer_RouteChageTable09", iTimer )
					elseif( i == 19 ) then
						Fox.Log("Timer_RouteChageTable10 START " )
						TppTimer.Start("Timer_RouteChageTable10", iTimer )
					end
					this.TimerRouteChageTable[i] = iOnRoute
					this.TimerRouteChageTable[i+1] = iOffRoute
					isSetTimeRouteChage = true
				end
			end
		end
	end
end

local commonTimerRouteChage = function( num )
	if( this.TimerRouteChageTable[num] ~= 0 and this.TimerRouteChageTable[num+1] ~= 0 ) then
		Fox.Log( "TimerRouteChage:"..num.. ":OnRoute:"..this.TimerRouteChageTable[num].. "OFFRoute:"..this.TimerRouteChageTable[num+1].. ":" )
		TppCommandPostObject.GsSetExclusionRoutes( this.cpID, this.TimerRouteChageTable[num], this.TimerRouteChageTable[num+1] )
		this.TimerRouteChageTable[num] = 0
		this.TimerRouteChageTable[num+1] = 0
	end
end

-- ■ サーチターゲット設定
local commonSearchTargetSetup = function( manager )
	Fox.Log("commonSearchTargetSetup")
	-- 一旦全登録を削除
	manager.CheckLookingTarget:ClearSearchTargetEntities()
	-- ＭＴ倉庫
	if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 )  then
		GZCommon.SearchTargetCharacterSetup( manager, this.CharacterID_MT_Squad )
	end
	-- ＭＴ管理棟
	if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 )	then
		GZCommon.SearchTargetCharacterSetup( manager, this.CharacterID_MT_Center )
	end
end

-- Demo&EventBlockのLoad完了確認
local IsDemoAndEventBlockActive = function()
	if( TppMission.IsDemoBlockActive() == false ) then
		return false
	end
	if( TppMission.IsEventBlockActive() == false ) then
		return false
	end
	if( TppVehicleBlockControllerService.IsHeliBlockExist() ) then
		-- HeliBlockあり
		if ( TppVehicleBlockControllerService.IsHeliBlockActivated() == false ) then
			return false
		end
	end
	-- テクスチャロード待ち
	if( MissionManager.IsMissionStartMiddleTextureLoaded() == false ) then
		return false
	end
	-- ローディングTipsの終了を待つ
	local hudCommonData = HudCommonDataManager.GetInstance()
	if( hudCommonData:IsEndLoadingTips() == false ) then
		hudCommonData:PermitEndLoadingTips() --終了許可(決定ボタンを押したら消える)
		-- 決定ボタン押されるのを待ってます
		return false
	end
	return true
end

---------------------------------------------------------------------------------
-- ■■ AnnounceLog Functions
---------------------------------------------------------------------------------

-- ■ アナウンスログ表示
local commonCallAnnounceLog = function( langNo )
	Fox.Log( "commonCallAnnounceLog sequence:"..langNo )
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( langNo )

	-- 戦績への反映
	if( langNo == this.AnnounceLogID_MT_Squad_Heli ) then
		-- 「指」
		PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE", this.CharacterID_MT_Squad )
	elseif( langNo == this.AnnounceLogID_MT_Center_Heli ) then
		-- 「目」
		PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE", this.CharacterID_MT_Center )
	elseif( langNo == this.AnnounceLogID_EnemyCollection ) then
		-- 敵兵
		PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE" )
	end

end

---------------------------------------------------------------------------------
-- ■■ MissionWarningArea Functions
---------------------------------------------------------------------------------

-- ■ ミッション圏外エリア判定
local commonGetMissionEscapeAreaEnemy = function( isClearArea, isCarried, iPlayerVehicleRide, iMissionClearAnnounceLog )
	Fox.Log( "commonGetMissionEscapeAreaEnemy" )
	local pos				= TppPlayerUtility.GetLocalPlayerCharacter():GetPosition()	-- BOX位置
	local size				= Vector3( 20, 12, 20 )										-- BOXサイズ
	local rot				= Quat( 0.0 , 0.50, 0.0, 0.50 )								-- BOX回転
	local npcIds			= TppNpcUtility.GetNpcByBoxShape( pos, size, rot )
	local sequence			= TppSequence.GetCurrentSequence()
	local VipCount			= 0
	local isRideVehicle		= false
	local npctype
	local enemytype
	local status
	local lifestatus
	local CharacterID
	-- プレイヤーの周りに敵兵がいるか
	if( npcIds and #npcIds.array > 0 ) then
		-- 敵兵の人数分ループ
		for i,id in ipairs(npcIds.array) do
			npctype = TppNpcUtility.GetNpcType( id )
			Fox.Log("npc type:"..npctype )
			if( npctype == "Enemy" ) then
				-- クリア判定
				if( iMissionClearAnnounceLog == false ) then
					enemytype = TppEnemyUtility.GetEnemyType( id )
					Fox.Log("enemy type:"..enemytype )
					if( enemytype == "Vip" ) then
						status		= TppEnemyUtility.GetStatus( id )
						lifestatus	= TppEnemyUtility.GetLifeStatus( id )
						Fox.Log("enemy status:"..status )
						Fox.Log("enemy lifestatus:"..lifestatus )
						-- ミッション圏外警告エリア
						if( isCarried == false and iPlayerVehicleRide == false ) then
							if( sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) then
								if( ( lifestatus == "Sleep" or lifestatus == "Faint" ) and ( status == "Carried" or status == "RideVehicle" ) ) then
									if( isClearArea == true ) then
										if( ( status == "RideVehicle" and GZCommon.PlayerOnVehicle ~= "NoRide" ) or ( status == "Carried" and GZCommon.PlayerOnVehicle == "NoRide" ) ) then
											commonPrint2D("【クリア】条件成立:"..sequence )
											return true
										end
									else
										if( ( status == "RideVehicle" and GZCommon.PlayerOnVehicle ~= "NoRide" ) or ( status == "Carried" and GZCommon.PlayerOnVehicle == "NoRide" ) ) then
											commonPrint2D("【クリア】条件成立:"..sequence )
											return true
										end
									end
								end
							elseif( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
								if( ( lifestatus == "Sleep" or lifestatus == "Faint" ) and status == "RideVehicle" ) then
									VipCount = VipCount + 1
									if( VipCount == 2 ) then
										if( isClearArea == true ) then
											if( GZCommon.PlayerOnVehicle ~= "NoRide" ) then
												commonPrint2D("【クリア】条件成立:"..sequence )
												return true
											end
										else
											if( GZCommon.PlayerOnVehicle ~= "NoRide" ) then
												commonPrint2D("【クリア】条件成立:"..sequence )
												return true
											end
										end
									end
								end
							end
						-- 担いだ
						elseif( isCarried == true ) then
							if( sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) then
								if( isCarried == true and status == "Carried" ) then
									commonPrint2D("【クリア】条件成立:"..sequence )
									return true
								end
							end
						-- プレイヤーが車に乗った
						elseif( iPlayerVehicleRide == true ) then
							if( ( lifestatus == "Sleep" or lifestatus == "Faint" ) and status == "RideVehicle" ) then
								VipCount = VipCount + 1
								if( ( sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) and VipCount >= 1 ) then
									commonPrint2D("【クリア】条件成立:"..sequence )
									return true
								elseif( sequence == "Seq_Waiting_KillMT_Squad_and_Center" and VipCount >= 2 ) then
									commonPrint2D("【クリア】条件成立:"..sequence )
									return true
								end
							end
						end
					end
				-- 敵兵アナウンスログ
				else
					Fox.Log( "commonGetMissionEscapeAreaEnemy:AnnounceLogEnemy" )
					enemytype	= TppEnemyUtility.GetEnemyType( id )
					status		= TppEnemyUtility.GetStatus( id )
					lifestatus	= TppEnemyUtility.GetLifeStatus( id )
					Fox.Log("enemy type:"..enemytype )
					Fox.Log("enemy status:"..status )
					Fox.Log("enemy lifestatus:"..lifestatus )
					-- 死亡している敵兵は判定しない
					if( lifestatus ~= "Dead" ) then
						-- 敵兵の状態：【担がれ】【車両搭乗】
						if( status == "RideVehicle" or status == "Carried" ) then
							if( enemytype == "Patrol" ) then
								-- 敵兵回収
								commonCallAnnounceLog( this.AnnounceLogID_EnemyCollection )
							elseif( enemytype == "Vip" ) then
								CharacterID = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
								Fox.Log("enemy CharacterID:"..CharacterID )
								if( CharacterID == this.CharacterID_MT_Squad ) then
									-- 「指」回収
									commonCallAnnounceLog( this.AnnounceLogID_MT_Squad_Heli )
								elseif( CharacterID == this.CharacterID_MT_Center ) then
									-- 「目」回収
									commonCallAnnounceLog( this.AnnounceLogID_MT_Center_Heli )
								end
							end
						end
					end
				end
			-- 捕虜アナウンスログ
			elseif( npctype == "Hostage" ) then
				if( iMissionClearAnnounceLog == true ) then
					Fox.Log( "commonGetMissionEscapeAreaEnemy:AnnounceLogHostage" )
					status = TppHostageUtility.GetStatus( id )
					Fox.Log("hostage status:"..status )
					-- 捕虜の状態：【担がれ】【車両搭乗】
					if( status == "RideOnVehicle" or status == "Carried" ) then
						CharacterID = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
						-- 「アナウンスログ表示」「戦績（PlayRecord）反映」
						GZCommon.NormalHostageRecovery( CharacterID )
					end
				end
			end
		end
	end
	-- 捕虜のアナウンスログの場合はナシ
	if( iMissionClearAnnounceLog == false ) then
		commonPrint2D("【クリア】条件失敗:"..sequence )
		return false
	end
end

---------------------------------------------------------------------------------
-- ■■ Radio Functions
---------------------------------------------------------------------------------

-- ■ 無線コンポーネント登録
local commonRegisterRadioCondition = function( flag )
	Fox.Log( "commonRegisterRadioCondition")
	--コンポーネントの登録
	if( flag == "ON" ) then
		TppRadioConditionManagerAccessor.Register(
			"Tutorial", 	   								-- 登録コンポーネント名
			TppRadioConditionTutorialPlayer{
				time = 1.5,    								-- 更新のInterval時間（秒）→頻繁にチェックする必要なかったら出来れば増やして下さい
				descMessage = {
															-- RadioConditionManagerのメッセージボックスに送るメッセージ、Desc内容
					"PlayerBehind", "Behind",
					"PlayerBinocle", "BinocleHold",
					"PlayerRecovering", "Recovering"
				},
			}
		)
	TppRadioConditionManagerAccessor.Register( "Basic", TppRadioConditionPlayerBasic{ time = 0.3 } )
	--コンポーネントの削除
	else
		TppRadioConditionManagerAccessor.Unregister( "Tutorial" )
		TppRadioConditionManagerAccessor.Unregister( "Basic" )
	end
end

-- ■ 無線コンポーネントセットアップ
local commonRegisterOptionalRadioSetup = function( escape, AlertFlag )
			escape		= escape or false
	local	sequence	= TppSequence.GetCurrentSequence()
	Fox.Log( "commonRegisterOptionalRadioSetup sequence:"..sequence )
	-- 任意無線：要人２名を排除
	if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
		-- 要人Ａと要人Ｂをターゲットした
		if( TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == true and TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == true ) then
			if( this.CounterList.GameOptionalRadioName ~= "OptionalRadio_001_TargetOn" ) then
				Fox.Log( "OptionalRadio_001_TargetOn START")
				TppRadio.RegisterOptionalRadio( "OptionalRadio_001_TargetOn" )
				this.CounterList.GameOptionalRadioName = "OptionalRadio_001_TargetOn"
			end
		-- 初めてアラートになった
		elseif( AlertFlag == true ) then
			if( this.CounterList.GameOptionalRadioName ~= "OptionalRadio_001_Alert" ) then
				Fox.Log( "OptionalRadio_001_Alert START")
				TppRadio.RegisterOptionalRadio( "OptionalRadio_001_Alert" )
				this.CounterList.GameOptionalRadioName = "OptionalRadio_001_Alert"
			end
		-- それ以外
		else
			-- 逃亡前
			if( escape == false ) then
				if( this.CounterList.GameOptionalRadioName ~= "OptionalRadio_001" ) then
					Fox.Log( "OptionalRadio_001 START")
					TppRadio.RegisterOptionalRadio( "OptionalRadio_001" )
					this.CounterList.GameOptionalRadioName = "OptionalRadio_001"
				end
			-- 逃亡開始
			else
				if( this.CounterList.GameOptionalRadioName ~= "OptionalRadio_001_Escape" ) then
					Fox.Log( "OptionalRadio_001_Escape START")
					TppRadio.RegisterOptionalRadio( "OptionalRadio_001_Escape" )
					this.CounterList.GameOptionalRadioName = "OptionalRadio_001_Escape"
				end
			end
		end
	-- 任意無線：残りの要人を排除
	elseif( sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) then
		-- 逃亡前
		if( escape == false ) then
			if( this.CounterList.GameOptionalRadioName ~= "OptionalRadio_002" ) then
				Fox.Log( "OptionalRadio_002 START")
				TppRadio.RegisterOptionalRadio( "OptionalRadio_002" )
				this.CounterList.GameOptionalRadioName = "OptionalRadio_002"
			end
		-- 逃亡開始
		else
			if( this.CounterList.GameOptionalRadioName ~= "OptionalRadio_002_Escape" ) then
				Fox.Log( "OptionalRadio_002_Escape START")
				TppRadio.RegisterOptionalRadio( "OptionalRadio_002_Escape" )
				this.CounterList.GameOptionalRadioName = "OptionalRadio_002_Escape"
			end
		end
	-- 任意無線：脱出せよ
	elseif( sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
		if( this.CounterList.GameOptionalRadioName ~= "OptionalRadio_003" ) then
			Fox.Log( "OptionalRadio_003 START")
			TppRadio.RegisterOptionalRadio( "OptionalRadio_003" )
			this.CounterList.GameOptionalRadioName = "OptionalRadio_003"
		end
	end
end

-- ■ 無線：写真を確認
local commonMbDvcActWatchPhotoRadio = function()
	local PhotoID = TppData.GetArgument(1)
	Fox.Log( "commonMbDvcActWatchPhotoRadio"..PhotoID )
	-- ターゲットＡの写真確認後無線
	local EndMbDvcActA = {
		onEnd = function()
			TppMission.SetFlag( "isRadio_MTMbDvcAct_A_End", true )
			if( TppMission.GetFlag( "isRadio_MTMbDvcAct_A_End" ) == true and TppMission.GetFlag( "isRadio_MTMbDvcAct_B_End" ) == true and TppMission.GetFlag( "isRadio_MTMbDvcAct_AB" ) == false )	then
				TppRadio.DelayPlay( "Radio_MbDvcActMissionTargetAB", "short", "end" )
				TppMission.SetFlag( "isRadio_MTMbDvcAct_AB", true )
			end
		end,
	}
	-- ターゲットＢの写真確認後無線
	local EndMbDvcActB = {
		onEnd = function()
			TppMission.SetFlag( "isRadio_MTMbDvcAct_B_End", true )
			if( TppMission.GetFlag( "isRadio_MTMbDvcAct_A_End" ) == true and TppMission.GetFlag( "isRadio_MTMbDvcAct_B_End" ) == true and TppMission.GetFlag( "isRadio_MTMbDvcAct_AB" ) == false )	then
				TppRadio.DelayPlay( "Radio_MbDvcActMissionTargetAB", "short", "end" )
				TppMission.SetFlag( "isRadio_MTMbDvcAct_AB", true )
			end
		end,
	}
	-- 開始時無線中は開いてない事にする
	if( TppMission.GetFlag( "isRadio_MissionStartPlay" ) == false and TppMission.GetFlag( "isRadio_MbDvcActOpenTop" ) == false ) then
		local radioDaemon = RadioDaemon:GetInstance()
		--無線の種類に問わず再生中ではなければ
		if ( radioDaemon:IsPlayingRadio() == false ) then
			-- 要人Ｂ「指」：写真確認無線
			if( PhotoID == this.PhotoID_MT_Squad ) then
				-- 排除or回収前
				if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 ) then
					if( ( TppMission.GetFlag( "isRadio_MTMbDvcAct_B_Start" ) == false  and TppMission.GetFlag( "isRadio_MTMbDvcAct_B_End" ) == false ) or
						( TppMission.GetFlag( "isRadio_MTMbDvcAct_B_Start" ) == true  and TppMission.GetFlag( "isRadio_MTMbDvcAct_B_End" ) == true ) ) then
						if( TppMission.GetFlag( "isRadio_MTMbDvcAct_A_Start" ) == false )  then
							TppMission.SetFlag( "isRadio_MTMbDvcAct_A_Start", true )
							TppRadio.Play( "Radio_MbDvcActMissionTargetA", EndMbDvcActA )
						end
					end
				else
					TppMission.SetFlag( "isRadio_MTMbDvcAct_A_Start", true )
					TppMission.SetFlag( "isRadio_MTMbDvcAct_A_End", true )
				end
			-- 要人Ａ「目」：写真確認無線
			elseif( PhotoID == this.PhotoID_MT_Center ) then
				-- 排除or回収前
				if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 ) then
					if( ( TppMission.GetFlag( "isRadio_MTMbDvcAct_A_Start" ) == false  and TppMission.GetFlag( "isRadio_MTMbDvcAct_A_End" ) == false ) or
						( TppMission.GetFlag( "isRadio_MTMbDvcAct_A_Start" ) == true  and TppMission.GetFlag( "isRadio_MTMbDvcAct_A_End" ) == true ) ) then
						if( TppMission.GetFlag( "isRadio_MTMbDvcAct_B_Start" ) == false )  then
							TppMission.SetFlag( "isRadio_MTMbDvcAct_B_Start", true )
							TppRadio.Play( "Radio_MbDvcActMissionTargetB", EndMbDvcActB )
						end
					end
				-- 排除or回収後
				else
					TppMission.SetFlag( "isRadio_MTMbDvcAct_B_Start", true )
					TppMission.SetFlag( "isRadio_MTMbDvcAct_B_End", true )
				end
			end
		end
		-- ターゲットＡとターゲットＢの写真確認後無線はどちらかが排除or回収されていたら無線鳴らさない
		if( TppMission.GetFlag( "isMT_SquadKill" ) ~= 0 or TppMission.GetFlag( "isMT_CenterKill" ) ~= 0 ) then
			TppMission.SetFlag( "isRadio_MTMbDvcAct_AB", true )
		end
	end
end

-- ■ 無線：ＭＢ端末開いた
local commonMbDvcActOpenTopRadio = function()
	local sequence = TppSequence.GetCurrentSequence()
	local RaioMbDvcActOpenTop = {
		onStart = function()
			-- 無線開始フラグ
			TppMission.SetFlag( "isRadio_MbDvcActOpenTop", true )
		end,
		onEnd = function()
			-- 無線終了
			TppMission.SetFlag( "isRadio_MbDvcActOpenTop", false )
		end,
	}
	Fox.Log( "commonMbDvcActOpenTopRadio"..sequence )
	-- 開始時無線中は開いてない事にする
	if( TppMission.GetFlag( "isRadio_MissionStartPlay" ) == false ) then
		-- 無線
		if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
			-- 要人が逃亡の場合中の鳴らさない
			if( this.CounterList.ForceRoute_MTSquad == "OFF" and this.CounterList.ForceRoute_MTCenter == "OFF" ) then
				-- 無線
				TppRadio.Play( "Radio_MbDvcActOpenTop", RaioMbDvcActOpenTop )
			end
		end
	else
		-- 端末を始めて開いたら
		if( TppMission.GetFlag( "isMbDvcActOpenTop" ) == false ) then
			-- 無線
			TppRadio.DelayPlayEnqueue( "Radio_MbDvcActOpenTop", "short", "end", RaioMbDvcActOpenTop )
		end
	end
	-- 端末開いた
	if( TppMission.GetFlag( "isMbDvcActOpenTop" ) == false ) then
		TppMission.SetFlag( "isMbDvcActOpenTop", true )
	end
end

-- ■ 無線：「スニーキングミッションだ」
local commonMissionOutlineRadio01 = function()
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log( "commonMissionOutlineRadio01"..sequence)
	-- 無線
	if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" or sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) then
		if( TppMission.GetFlag( "isRadio_MissionOutLine01" ) == false ) then
			TppRadio.DelayPlayEnqueue( "Radio_MissionOutLine01", "short", nil )
			TppMission.SetFlag( "isRadio_MissionOutLine01", true )
		end
	end
end

-- ■ 無線：「今回の依頼」
local commonMissionOutlineRadio02 = function()
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log( "commonMissionOutlineRadio02"..sequence)
	-- 無線
	if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" or sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) then
		if( TppMission.GetFlag( "isRadio_MissionOutLine02" ) == false ) then
			TppRadio.DelayPlayEnqueue( "Radio_MissionOutLine02", "short" )
			TppMission.SetFlag( "isRadio_MissionOutLine02", true )
		end
	end
end

-- ■ 無線：「予測データ無効」
local commonMissionOutlineMarkerOutRadio = function( CharacterID, RadioOff )
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log( "commonMissionOutlineMarkerOutRadio"..sequence )
	local funcs = {
		onEnd = function()
			-- 要人Ａ
			if( CharacterID == this.CharacterID_MT_Center ) then
				if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 and
					TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == false and TppMission.GetFlag( "isMT_InterroMarker_MTCenter" ) == false and TppMission.GetFlag( "isMT_BuildingMarker_MTCenter" ) == false ) then
					-- アナウンスログ
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			-- 要人Ｂ
			elseif( CharacterID == this.CharacterID_MT_Squad ) then
				if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 and
					TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == false and TppMission.GetFlag( "isMT_InterroMarker_MTSquad" ) == false and TppMission.GetFlag( "isMT_BuildingMarker_MTSquad" ) == false ) then
					-- アナウンスログ
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			end
		end,
	}
	if( RadioOff == false ) then
		-- 端末を開いてない場合は無線を流さない
		if( TppMission.GetFlag( "isMbDvcActOpenTop" ) == false ) then
			-- 要人Ａ
			if( CharacterID == this.CharacterID_MT_Center ) then
				if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 and
					TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == false and TppMission.GetFlag( "isMT_InterroMarker_MTCenter" ) == false and TppMission.GetFlag( "isMT_BuildingMarker_MTCenter" ) == false ) then
					-- アナウンスログ
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			-- 要人Ｂ
			elseif( CharacterID == this.CharacterID_MT_Squad ) then
				if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 and
					TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == false and TppMission.GetFlag( "isMT_InterroMarker_MTSquad" ) == false and TppMission.GetFlag( "isMT_BuildingMarker_MTSquad" ) == false ) then
					-- アナウンスログ
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			end
		else
			-- 無線：１回目
			if( TppMission.GetFlag( "isRadio_MarkerOutFirst" ) == false ) then
				if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
					TppRadio.Play( "Radio_MarkerOutFirst", funcs )
				else
					TppRadio.Play( "Radio_MarkerOutSecond", funcs )
				end
				TppMission.SetFlag( "isRadio_MarkerOutFirst", true )
			-- 無線：２回目以降
			else
				TppRadio.Play( "Radio_MarkerOutSecond", funcs )
			end
		end
	end
end

-- ■ 無線：「予測データ有効」
local commonMissionOutlineMarkerInRadio = function( CharacterID, RadioOff )
	Fox.Log( "commonMissionOutlineMarkerInRadio")
	local funcs = {
		onEnd = function()
			-- 要人Ａ
			if( CharacterID == this.CharacterID_MT_Center ) then
				if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 and
					TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == false and TppMission.GetFlag( "isMT_InterroMarker_MTCenter" ) == false and TppMission.GetFlag( "isMT_BuildingMarker_MTCenter" ) == false ) then
					-- アナウンスログ
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			-- 要人Ｂ
			elseif( CharacterID == this.CharacterID_MT_Squad ) then
				if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 and
					TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == false and TppMission.GetFlag( "isMT_InterroMarker_MTSquad" ) == false and TppMission.GetFlag( "isMT_BuildingMarker_MTSquad" ) == false ) then
					-- アナウンスログ
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			end
		end,
	}
	if( RadioOff == false ) then
		-- 端末を開いてない場合は無線を流さない
		if( TppMission.GetFlag( "isMbDvcActOpenTop" ) == false ) then
			-- 要人Ａ
			if( CharacterID == this.CharacterID_MT_Center ) then
				if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 and
					TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == false and TppMission.GetFlag( "isMT_InterroMarker_MTCenter" ) == false and TppMission.GetFlag( "isMT_BuildingMarker_MTCenter" ) == false ) then
					-- アナウンスログ
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			-- 要人Ｂ
			elseif( CharacterID == this.CharacterID_MT_Squad ) then
				if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 and
					TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == false and TppMission.GetFlag( "isMT_InterroMarker_MTSquad" ) == false and TppMission.GetFlag( "isMT_BuildingMarker_MTSquad" ) == false ) then
					-- アナウンスログ
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			end
		else
			-- 無線
			TppRadio.Play( "Radio_MarkerIn", funcs )
			TppMission.SetFlag( "isRadio_MarkerIn", true )
		end
	end
end

-- ■ 無線：「ターゲットが建物内に入った」
local commonMissionTargetInBuildingRadio = function( CharacterID )
	Fox.Log( "commonMissionTargetInBuildingRadio")
	local funcs = {
		onEnd = function()
			if( CharacterID == this.CharacterID_MT_Squad ) then
				if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 and TppMission.GetFlag( "isMT_BuildingMarker_MTSquad" ) == true ) then
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			elseif( CharacterID == this.CharacterID_MT_Center ) then
				if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 and TppMission.GetFlag( "isMT_BuildingMarker_MTCenter" ) == true ) then
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			end
		end,
	}
	-- 同じ無線が２回鳴る可能性があるので
	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadioWithGroupName( "e0020_rtrg0060" ) == false ) then
		-- ＭＴ倉庫
		if( CharacterID == this.CharacterID_MT_Squad ) then
			if( TppMission.GetFlag( "isMT_BuildingMarker_MTSquad" ) == true ) then
				if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 ) then
					TppRadio.DelayPlay( "Radio_MissionTargetInBuilding", "mid", nil, funcs )
				end
			end
		-- ＭＴ管理棟
		elseif( CharacterID == this.CharacterID_MT_Center ) then
			if( TppMission.GetFlag( "isMT_BuildingMarker_MTCenter" ) == true ) then
				if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 ) then
					TppRadio.DelayPlay( "Radio_MissionTargetInBuilding", "mid", nil, funcs )
				end
			end
		end
	end
end

-- ■ 無線：「ターゲット逃亡開始」
local commonTargetEscapeRadio = function( phase )
	local sequence				= TppSequence.GetCurrentSequence()
	local MTCenterStatus		= TppEnemyUtility.GetLifeStatus( this.CharacterID_MT_Center )
	local MTSquadStatus			= TppEnemyUtility.GetLifeStatus( this.CharacterID_MT_Squad )
	local registerOptionalRadio	= false
	Fox.Log( "commonTargetEscapeRadio"..sequence )
	-- 無線：要人逃亡開始
	if( TppMission.GetFlag( "isRadio_AlertTargetEscape" ) == false ) then
		-- ターゲット２人
		if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
			if( MTCenterStatus == "Normal" and MTCenterStatus == "Normal" ) then
				TppRadio.DelayPlay( "Radio_AlertTargetEscapeTwo", "mid" )
				registerOptionalRadio = true
				TppMission.SetFlag( "isRadio_AlertTargetEscape", true )
			elseif( MTCenterStatus == "Normal" or MTCenterStatus == "Normal" ) then
				TppRadio.DelayPlay( "Radio_AlertTargetEscapeOne", "mid" )
				registerOptionalRadio = true
				TppMission.SetFlag( "isRadio_AlertTargetEscape", true )
			end
		-- ターゲット１人（目）
		elseif( sequence == "Seq_Waiting_KillMT_Center" ) then
			if( MTCenterStatus == "Normal" ) then
				TppRadio.DelayPlay( "Radio_AlertTargetEscapeOne", "mid" )
				registerOptionalRadio = true
				TppMission.SetFlag( "isRadio_AlertTargetEscape", true )
			end
		-- ターゲット１人（指）
		elseif( sequence == "Seq_Waiting_KillMT_Squad" ) then
			if( MTSquadStatus == "Normal" ) then
				TppRadio.DelayPlay( "Radio_AlertTargetEscapeOne", "mid" )
				registerOptionalRadio = true
				TppMission.SetFlag( "isRadio_AlertTargetEscape", true )
			end
		end
		-- 【逃亡開始】の無線の鳴らしたら、任意無線も変更する
		if( registerOptionalRadio == true ) then
			if( phase == "Alert" ) then
				commonRegisterOptionalRadioSetup( true, true )
			else
				commonRegisterOptionalRadioSetup( true, false )
			end
		end
		-- エリアマーカーオフタイマースタート
		TppTimer.Start( "Timer_Alert_AreaMarkerOff", this.Timer_Alert_AreaMakrerOff )
	end
end

-- ■ 無線：端末写真確認促し無線タイマー
local commonCheckTargetPhotoTimeSetup = function( Name )
	Fox.Log( "commonCheckTargetPhotoTimeSetup")
	if( Name == "Start" ) then
		-- 端末写真確認促し無線タイマー開始
		TppTimer.Stop( "Timer_CheckTargetPhoto" )
		TppTimer.Start( "Timer_CheckTargetPhoto", GZCommon.Time_HintPhotoCheck )
	elseif( Name == "End" ) then
		-- 端末写真確認促し無線タイマー終了
		TppTimer.Stop( "Timer_CheckTargetPhoto" )
	end
end

-- ■ 無線：端末写真確認促し無線タイマーチェック
local commonCheckTargetPhoto = function()
	Fox.Log( "commonCheckTargetPhoto")
	-- 「写真の見方チュートリアル」無線終了後
	-- 「写真を確認しろ」無線終了後
	local funcs = {
		onEnd = function()
			commonCheckTargetPhotoTimeSetup("Start")
		end,
	}
	if(	-- Sneak状態
		TppEnemy.GetPhase( this.cpID ) == "sneak" and
		(
			-- 要人Ａ「目」
			( TppMission.GetFlag( "isRadio_MTMbDvcAct_B_Start" ) == false and TppMission.GetFlag( "isRadio_MarkerOnMissionTargetB" ) == false and TppMission.GetFlag( "isMT_CenterKill" ) == 0 )
			or
			-- 要人Ｂ「指」
			( TppMission.GetFlag( "isRadio_MTMbDvcAct_A_Start" ) == false and TppMission.GetFlag( "isRadio_MarkerOnMissionTargetA" ) == false and TppMission.GetFlag( "isMT_SquadKill" ) == 0 )
		)
	  ) then
		local radioDaemon = RadioDaemon:GetInstance()
		--無線の種類に問わず再生中ではなければ
		if ( radioDaemon:IsPlayingRadio() == false ) then
			-- 全ての条件を満たしていたら「写真を確認しろ」無線
			TppRadio.PlayEnqueue( "Radio_CheckMbPhoto", funcs )
			-- 写真の見方のチュートリアル
			if( TppMission.GetFlag( "isRadio_CheckMbPhotoTutorial" ) == false ) then
				TppMission.SetFlag( "isRadio_CheckMbPhotoTutorial", true )
				TppRadio.DelayPlayEnqueue( "Radio_CheckMbPhotoTutorial", "short" )
			end
		else
			-- タイマースタート
			commonCheckTargetPhotoTimeSetup("Start")
		end
	end
end

-- ■ サプレッサーが壊れた
local commonSuppressorIsBroken = function()
	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()
	if( VehicleId == "SupportHelicopter" ) then
	else
		TppRadio.DelayPlayEnqueue( "Miller_BreakSuppressor", "short" )
	end
end

---------------------------------------------------------------------------------
-- ■■ MB Functions
---------------------------------------------------------------------------------

-- ■ ＭＢ端末でアイコンをフォーカスした
local commonFocusMapIcon = function()
	local Id_32Bit = TppEventSequenceManagerCollector.GetMessageArg( 0 )
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log( "commonFocusMapIcon:"..Id_32Bit )
	-- ターゲットマーカー
	if( StringId.IsEqual32( Id_32Bit, this.CharacterID_MT_Center ) ) then
		if( TppMission.GetFlag( "isRadio_FocusMapIcon" ) == false ) then
			-- ターゲットマーカー済み
			if( TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == true ) then
				TppRadio.DelayPlay( "Radio_MissionTargetFocusMapIcon", "short" )
				TppMission.SetFlag( "isRadio_FocusMapIcon", true )
				TppTimer.Start( "Timer_FocusMapIcon", this.Timer_FocusMapIcon )
			end
		end
	-- ターゲットマーカー
	elseif( StringId.IsEqual32( Id_32Bit, this.CharacterID_MT_Squad ) ) then
		if( TppMission.GetFlag( "isRadio_FocusMapIcon" ) == false ) then
			-- ターゲットマーカー済み
			if( TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == true ) then
				TppRadio.DelayPlay( "Radio_MissionTargetFocusMapIcon", "short" )
				TppMission.SetFlag( "isRadio_FocusMapIcon", true )
				TppTimer.Start( "Timer_FocusMapIcon", this.Timer_FocusMapIcon )
			end
		end
	-- 脱出
	elseif( StringId.IsEqual32( Id_32Bit, this.MarkerID_EscapeWest ) or StringId.IsEqual32( Id_32Bit, this.MarkerID_EscapeNorth ) ) then
	end
end

-- ■ ＭＢ端末でアイコンの無線を鳴らさないようにする
local commonTimeFocusMapIcon = function()
	Fox.Log( "commonTimeFocusMapIcon")
	TppMission.SetFlag( "isRadio_FocusMapIcon", false )
end

---------------------------------------------------------------------------------
-- ■■ Icon Functions
---------------------------------------------------------------------------------

-- ■「指」のアイコン説明文初期化
local commonMTSquadIconUniqueInformationAllDisable = function( luaData )
	Fox.Log("commonMTSquadIconUniqueInformationAllDisable")
	-- 初期化
	luaData:UnRegisterIconUniqueInformation( this.CharacterID_MT_Squad )
	luaData:UnRegisterIconUniqueInformation( this.AreaMarkerID_MT_Squad_westTent )
	luaData:UnRegisterIconUniqueInformation( this.AreaMarkerID_MT_Squad_Asylum )
	luaData:UnRegisterIconUniqueInformation( this.AreaMarkerID_MT_Squad_Heliport )
	luaData:UnRegisterIconUniqueInformation( this.AreaMarkerID_MT_Squad_wareHouse )
	luaData:UnRegisterIconUniqueInformation( this.AreaMarkerID_MT_Squad_eastTent )
	luaData:UnRegisterIconUniqueInformation( this.AreaMarkerID_MT_Squad_Heliport_Conversation )
end

-- ■「目」のアイコン説明文初期化
local commonMTCenterIconUniqueInformationAllDisable = function( luaData )
	Fox.Log("commonMTCenterIconUniqueInformationAllDisable")
	-- 初期化
	luaData:UnRegisterIconUniqueInformation( this.CharacterID_MT_Center )
	luaData:UnRegisterIconUniqueInformation( this.AreaMarkerID_MT_Center_westCenter )
	luaData:UnRegisterIconUniqueInformation( this.AreaMarkerID_MT_Center_Heliport_Conversation )
end

-- ■「指」のアイコン説明文設定
local commonMTSquadIconUniqueInformation = function()
	Fox.Log("commonMTSquadIconUniqueInformation")
	local marker				= TppMission.GetFlag( "isMT_AreaMarker_MTSquad" )
	local targetmarker			= TppMission.GetFlag( "isMT_TargetMarker_MTSquad" )
	local Buildingmarker		= TppMission.GetFlag( "isMT_BuildingMarker_MTSquad" )
	local Interrogationmarker	= TppMission.GetFlag( "isMT_InterroMarker_MTSquad" )
	local commonDataManager = UiCommonDataManager.GetInstance()
	if( commonDataManager == NULL ) then
		return
	end
	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if( luaData == NULL )then
		return
	end
	-- 初期化
	commonMTSquadIconUniqueInformationAllDisable( luaData )
	-- 現在表示しているエリアマーカーorターゲットマーカーで設定を行う。
	if( targetmarker == true ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.CharacterID_MT_Squad,							langId = "marker_info_finger" }
	elseif( Buildingmarker == true ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.CharacterID_MT_Squad,							langId = "marker_info_mission_targetArea" }
	elseif( Interrogationmarker == true ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.CharacterID_MT_Squad,							langId = "marker_info_mission_targetArea" }
	elseif( marker == 1 ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.AreaMarkerID_MT_Squad_westTent,					langId = "marker_info_mission_targetArea" }
	elseif( marker == 2 ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.AreaMarkerID_MT_Squad_Asylum,					langId = "marker_info_mission_targetArea" }
	elseif( marker == 3 ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.AreaMarkerID_MT_Squad_Heliport,					langId = "marker_info_mission_targetArea" }
	elseif( marker == 4 ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.AreaMarkerID_MT_Squad_wareHouse,					langId = "marker_info_mission_targetArea" }
	elseif( marker == 5 ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.AreaMarkerID_MT_Squad_eastTent,					langId = "marker_info_mission_targetArea" }
	elseif( marker == 6 ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.AreaMarkerID_MT_Squad_Heliport_Conversation,		langId = "marker_info_mission_targetArea" }
	end
end

-- ■「目」のアイコン説明文設定
local commonMTCenterIconUniqueInformation = function()
	Fox.Log("commonMTCenterIconUniqueInformation")
	local marker				= TppMission.GetFlag( "isMT_AreaMarker_MTCenter" )
	local targetmarker			= TppMission.GetFlag( "isMT_TargetMarker_MTCenter" )
	local Buildingmarker		= TppMission.GetFlag( "isMT_BuildingMarker_MTCenter" )
	local Interrogationmarker	= TppMission.GetFlag( "isMT_InterroMarker_MTCenter" )
	local commonDataManager		= UiCommonDataManager.GetInstance()
	if( commonDataManager == NULL ) then
		return
	end
	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if( luaData == NULL )then
		return
	end
	-- 初期化
	commonMTCenterIconUniqueInformationAllDisable( luaData )
	-- 現在表示しているエリアマーカーorターゲットマーカーで設定を行う。
	if( targetmarker == true ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.CharacterID_MT_Center,								langId = "marker_info_eye" }
	elseif( Buildingmarker == true ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.CharacterID_MT_Center,								langId = "marker_info_mission_targetArea" }
	elseif( Interrogationmarker == true ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.CharacterID_MT_Center,								langId = "marker_info_mission_targetArea" }
	elseif( marker == 1 ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.AreaMarkerID_MT_Center_westCenter,					langId = "marker_info_mission_targetArea" }
	elseif( marker == 2 ) then
		luaData:RegisterIconUniqueInformation{ markerId = this.AreaMarkerID_MT_Center_Heliport_Conversation,		langId = "marker_info_mission_targetArea" }
	end
end

-- ■ アイコン表示「端末を開く」
local commonCallButtonGuide = function( num )
	Fox.Log( "commonCallButtonGuide" )
	local hudCommonData = HudCommonDataManager.GetInstance()
	-- ボタン：端末を開く
	if( num == 0 ) then
		hudCommonData:CallButtonGuide( "tutorial_mb_device", "MB_DEVICE" )
	end
end

---------------------------------------------------------------------------------
-- ■■ Marker Functions
---------------------------------------------------------------------------------

-- ■「指」のエリアマーカー初期化
local commonAreaMarkerMTSquadAllDisable = function()
	Fox.Log( "commonAreaMarkerMTSquadAllDisable")
	TppMarker.Disable( this.AreaMarkerID_MT_Squad_westTent )
	TppMarker.Disable( this.AreaMarkerID_MT_Squad_Asylum )
	TppMarker.Disable( this.AreaMarkerID_MT_Squad_Heliport )
	TppMarker.Disable( this.AreaMarkerID_MT_Squad_wareHouse )
	TppMarker.Disable( this.AreaMarkerID_MT_Squad_eastTent )
	TppMarker.Disable( this.AreaMarkerID_MT_Squad_Heliport_Conversation )
end

-- ■「指」のエリアマーカー設定
local commonAreaMarkerMTSquad = function( Compulsionflag, AnnounceLog, MarkerOff, RadioOff, IconNameFlag, InitIconName )
			Compulsionflag	= Compulsionflag or false
	local	IconName		= false
	local	state			= TppMission.GetFlag( "isMT_Squad_StateMove" )
	local	marker			= TppMission.GetFlag( "isMT_AreaMarker_MTSquad" )
	Fox.Log( "commonAreaMarkerMTSquad")
	-- エリアマーカーＯＮ
	if( MarkerOff == false and TppMission.GetFlag( "isMT_SquadKill" ) == 0 and marker ~= 255 ) then
		-- マーカー西難民キャンプ
		if( ( Compulsionflag == true or marker ~= 1 ) and state >= 0 and state <= 5 )  then
			TppMission.SetFlag( "isMT_AreaMarker_MTSquad", 1 )
			-- マーカー初期化
			commonAreaMarkerMTSquadAllDisable()
			-- マーカーＯＮ
			TppMarker.Enable( this.AreaMarkerID_MT_Squad_westTent,					3, "moving", "map", 0, true, true )
			-- アイコン名設定
			IconName = true
			-- 無線＆アナウンスログ
			if( AnnounceLog == true ) then
				commonMissionOutlineMarkerInRadio( this.CharacterID_MT_Squad, RadioOff )
			end
		-- マーカー旧収容施設
		elseif( ( Compulsionflag == true or marker ~= 2 ) and state >= 6 and state <= 7 )  then
			TppMission.SetFlag( "isMT_AreaMarker_MTSquad", 2 )
			-- マーカー初期化
			commonAreaMarkerMTSquadAllDisable()
			-- マーカーＯＮ
			TppMarker.Enable( this.AreaMarkerID_MT_Squad_Asylum,					2, "moving", "map", 0, true, true )
			-- アイコン名設定
			IconName = true
			-- 無線＆アナウンスログ
			if( AnnounceLog == true ) then
				commonMissionOutlineMarkerInRadio( this.CharacterID_MT_Squad, RadioOff )
			end
		-- マーカーヘリポート
		elseif( ( Compulsionflag == true or marker ~= 3 ) and state >=	8 and state <= 9 )	then
			TppMission.SetFlag( "isMT_AreaMarker_MTSquad", 3 )
			-- マーカー初期化
			commonAreaMarkerMTSquadAllDisable()
			-- マーカーＯＮ
			TppMarker.Enable( this.AreaMarkerID_MT_Squad_Heliport,					2, "moving", "map", 0, true, true )
			-- アイコン名設定
			IconName = true
			-- 無線＆アナウンスログ
			if( AnnounceLog == true ) then
				commonMissionOutlineMarkerInRadio( this.CharacterID_MT_Squad, RadioOff )
			end
		-- マーカー倉庫
		elseif( ( Compulsionflag == true or marker ~= 4 ) and state >= 10 and state <= 11 )  then
			TppMission.SetFlag( "isMT_AreaMarker_MTSquad", 4 )
			-- マーカー初期化
			commonAreaMarkerMTSquadAllDisable()
			-- マーカーＯＮ
			TppMarker.Enable( this.AreaMarkerID_MT_Squad_wareHouse,					2, "moving", "map", 0, true, true )
			-- アイコン名設定
			IconName = true
			-- 無線＆アナウンスログ
			if( AnnounceLog == true ) then
				commonMissionOutlineMarkerInRadio( this.CharacterID_MT_Squad, RadioOff )
			end
		-- マーカー東難民キャンプ
		elseif( ( Compulsionflag == true or marker ~= 5 ) and state >= 12 and state <= 14 )  then
			TppMission.SetFlag( "isMT_AreaMarker_MTSquad", 5 )
			-- マーカー初期化
			commonAreaMarkerMTSquadAllDisable()
			-- マーカーＯＮ
			TppMarker.Enable( this.AreaMarkerID_MT_Squad_eastTent,					2, "moving", "map", 0, true, true )
			-- アイコン名設定
			IconName = true
			-- 無線＆アナウンスログ
			if( AnnounceLog == true ) then
				commonMissionOutlineMarkerInRadio( this.CharacterID_MT_Squad, RadioOff )
			end
		-- マーカーヘリポート
		elseif( ( Compulsionflag == true or marker ~= 6 ) and state >= 15 )  then
			TppMission.SetFlag( "isMT_AreaMarker_MTSquad", 6 )
			-- マーカー初期化
			commonAreaMarkerMTSquadAllDisable()
			-- マーカーＯＮ
			TppMarker.Enable( this.AreaMarkerID_MT_Squad_Heliport_Conversation,		2, "moving", "map", 0, true, true )
			-- アイコン名設定
			IconName = true
			-- 無線＆アナウンスログ
			if( AnnounceLog == true ) then
				commonMissionOutlineMarkerInRadio( this.CharacterID_MT_Squad, RadioOff )
			end
		end
	-- エリアマーカーＯＦＦ
	else
		-- マーカー初期化
		commonAreaMarkerMTSquadAllDisable()
		-- 無線＆アナウンスログ
		if( AnnounceLog == true and marker ~= 255 ) then
			commonMissionOutlineMarkerOutRadio( this.CharacterID_MT_Squad, RadioOff )
		end
		if( marker == 255 ) then
			-- アイコン名設定
			IconName = true
		end
	end
	-- アイコン名設定
	if( InitIconName == false and ( IconNameFlag == true or IconName == true ) ) then
		commonMTSquadIconUniqueInformation()
	end
end

-- ■「目」のエリアマーカー初期化
local commonAreaMarkerMTCenterAllDisable = function()
	Fox.Log( "commonAreaMarkerMTSquad")
	TppMarker.Disable( this.AreaMarkerID_MT_Center_westCenter )
	TppMarker.Disable( this.AreaMarkerID_MT_Center_Heliport_Conversation )
end

-- ■「目」のエリアマーカー設定
local commonAreaMarkerMTCenter = function( Compulsionflag, AnnounceLog, MarkerOff, RadioOff, IconNameFlag, InitIconName )
			Compulsionflag	= Compulsionflag or false
	local	IconName		= false
	local	state			= TppMission.GetFlag( "isMT_Center_StateMove" )
	local	marker			= TppMission.GetFlag( "isMT_AreaMarker_MTCenter" )
	Fox.Log( "commonAreaMarkerMTCenter")
	-- エリアマーカーＯＮ
	if( MarkerOff == false and TppMission.GetFlag( "isMT_CenterKill" ) == 0 and marker ~= 255 ) then
		if( ( Compulsionflag == true or  marker ~= 1 ) and state >= 0 and state <= 9 ) then
			TppMission.SetFlag( "isMT_AreaMarker_MTCenter", 1 )
			-- マーカー初期化
			commonAreaMarkerMTCenterAllDisable()
			-- マーカーＯＮ
			TppMarker.Enable( this.AreaMarkerID_MT_Center_westCenter,					4, "moving", "map", 0, true, true )
			-- アイコン名設定
			IconName = true
			-- 無線＆アナウンスログ
			if( AnnounceLog == true ) then
				commonMissionOutlineMarkerInRadio( this.CharacterID_MT_Center, RadioOff )
			end
		elseif( ( Compulsionflag == true or marker ~= 2 ) and state >= 10 and state <= 13 ) then
			TppMission.SetFlag( "isMT_AreaMarker_MTCenter", 2 )
			-- マーカー初期化
			commonAreaMarkerMTCenterAllDisable()
			-- マーカーＯＮ
			TppMarker.Enable( this.AreaMarkerID_MT_Center_Heliport_Conversation,		2, "moving", "map", 0, true, true )
			-- アイコン名設定
			IconName = true
			-- 無線＆アナウンスログ
			if( AnnounceLog == true ) then
				commonMissionOutlineMarkerInRadio( this.CharacterID_MT_Center, RadioOff )
			end
		end
	-- エリアマーカーＯＦＦ
	else
		-- マーカー初期化
		commonAreaMarkerMTCenterAllDisable()
		-- 無線＆アナウンスログ
		if( AnnounceLog == true and marker ~= 255 ) then
			commonMissionOutlineMarkerOutRadio( this.CharacterID_MT_Center, RadioOff )
		end
		if( marker == 255 ) then
			-- アイコン名設定
			IconName = true
		end
	end
	-- アイコン名設定
	if( InitIconName == false and ( IconNameFlag == true or IconName == true ) ) then
		commonMTCenterIconUniqueInformation()
	end
end

-- ■「ターゲット」のマーカー設定
local commonTargetMarker = function( num, CharacterID, CallSEOff )
	local CallSE					= false
	local TargetMarkerFlag			= false
	local BuildingMarkerFlag		= false
	local InterrogationMarkerFlag	= false
	Fox.Log( "commonTargetMarker"..CharacterID )
	-- マーカーＯＮ
	if( num == "ON" ) then
		if( CharacterID == this.CharacterID_MT_Squad ) then
			-- ターゲットマーカー
			if( TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == true ) then
				TargetMarkerFlag			= true
			-- 建物に入った時マーカー
			elseif( TppMission.GetFlag( "isMT_BuildingMarker_MTSquad" ) == true ) then
				BuildingMarkerFlag			= true
			-- 尋問時マーカー
			elseif( TppMission.GetFlag( "isMT_InterroMarker_MTSquad" ) == true ) then
				InterrogationMarkerFlag		= true
			end
		elseif( CharacterID == this.CharacterID_MT_Center ) then
			-- ターゲットマーカー
			if( TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == true ) then
				TargetMarkerFlag			= true
			-- 建物に入った時マーカー
			elseif( TppMission.GetFlag( "isMT_BuildingMarker_MTCenter" ) == true ) then
				BuildingMarkerFlag			= true
			-- 尋問時マーカー
			elseif( TppMission.GetFlag( "isMT_InterroMarker_MTCenter" ) == true ) then
				InterrogationMarkerFlag		= true
			end
		end
		-- ＮＥＷアイコンを表示する
		if( TargetMarkerFlag == true or BuildingMarkerFlag == true or InterrogationMarkerFlag == true ) then
			-- 全てのマーカーの新規フラグを解除する
			TppMarkerSystem.ResetAllNewMarker()
		end
		-- ターゲットマーカー
		if( TargetMarkerFlag == true ) then
			TppMarkerSystem.EnableMarker{ markerId = CharacterID, viewType = { "VIEW_MAP_ICON", "VIEW_WORLD_ICON" } }
			TppMarkerSystem.DisableMarker{ markerId = CharacterID, viewType = { "VIEW_MAP_GOAL", "VIEW_WORLD_GOAL" } }
			TppMarkerSystem.SetMarkerGoalType{ markerId = CharacterID, goalType = "GOAL_NONE", radiusLevel = 0, randomLevel = 0 }
			TppMarkerSystem.SetMarkerImportant{ markerId = CharacterID, isImportant = true }
			TppMarkerSystem.SetMarkerNew{ markerId = CharacterID, isNew = true }
			CallSE = true
		-- 建物に入った時マーカー
		elseif( BuildingMarkerFlag == true ) then
			TppMarkerSystem.EnableMarker{ markerId = CharacterID, viewType = { "VIEW_MAP_GOAL", "VIEW_WORLD_GOAL" } }
			TppMarkerSystem.DisableMarker{ markerId = CharacterID, viewType = { "VIEW_MAP_ICON", "VIEW_WORLD_ICON" } }
			TppMarkerSystem.SetMarkerGoalType{ markerId = CharacterID, goalType = "GOAL_MOVE", radiusLevel = 2, randomLevel = 0 }
			TppMarkerSystem.SetMarkerImportant{ markerId = CharacterID, isImportant = false }
			TppMarkerSystem.SetMarkerNew{ markerId = CharacterID, isNew = true }
			CallSE = false
		-- 尋問時マーカー
		elseif( InterrogationMarkerFlag == true ) then
			TppMarkerSystem.EnableMarker{ markerId = CharacterID, viewType = { "VIEW_MAP_GOAL", "VIEW_WORLD_GOAL" } }
			TppMarkerSystem.DisableMarker{ markerId = CharacterID, viewType = { "VIEW_MAP_ICON", "VIEW_WORLD_ICON" } }
			TppMarkerSystem.SetMarkerGoalType{ markerId = CharacterID, goalType = "GOAL_MOVE", radiusLevel = 1, randomLevel = 0 }
			TppMarkerSystem.SetMarkerImportant{ markerId = CharacterID, isImportant = false }
			TppMarkerSystem.SetMarkerNew{ markerId = CharacterID, isNew = true }
			CallSE = false
		end
	-- マーカーＯＦＦ
	else
		if( CharacterID == this.CharacterID_MT_Squad or CharacterID == this.CharacterID_MT_Center ) then
			-- マーカー初期化
			TppMarkerSystem.EnableMarker{ markerId = CharacterID }
			TppMarkerSystem.SetMarkerGoalType{ markerId = CharacterID, goalType = "GOAL_NONE", radiusLevel = 0, randomLevel = 0 }
			TppMarkerSystem.SetMarkerImportant{ markerId = CharacterID, isImportant = false }
		end
	end
 	-- ターゲットマーカー音
	if( CallSE == true and CallSEOff == false ) then
		GZCommon.CallSearchTarget()
	end
end

-- ■「ターゲット」のマーカーＯＮ
local commonMissionTargetMarkerOn = function( num, InterrogationFlag, RadioOff, InterrogationAnnounceLog )
	local CharacterID
	local EnemyLife
	local phase				= TppCharacterUtility.GetCpPhaseName( this.cpID )
	local AreaMarkerOff		= false
	-- ＭＴ倉庫
	local EndRaioMissionTargetA = {
		onEnd = function()
			if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 ) then
				commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
			end
		end,
	}
	-- ＭＴ管理棟
	local EndRaioMissionTargetB = {
		onEnd = function()
			if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 ) then
				commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
			end
		end,
	}
	Fox.Log( "commonMissionTargetMarkerOn" )
	-- マーカーの場合は無線を鳴らす
	if( num == 0 ) then
		CharacterID = TppData.GetArgument(1)
	-- 尋問の場合はキャラＩＤを設定する
	elseif( num == this.CharacterID_MT_Squad ) then
		CharacterID = this.CharacterID_MT_Squad
	elseif( num == this.CharacterID_MT_Center ) then
		CharacterID = this.CharacterID_MT_Center
	end
	-- ターゲットのライフ状態を取得する
	EnemyLife = TppEnemyUtility.GetLifeStatus( CharacterID )
	-- 死亡してたら何もしない
	if ( EnemyLife ~= "Dead" ) then
		-- ＭＴ倉庫
		if( CharacterID == this.CharacterID_MT_Squad ) then
			-- ターゲットマーカー
			if( InterrogationFlag == false ) then
				if( TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == false ) then
					TppMission.SetFlag( "isMT_TargetMarker_MTSquad", true )
					TppMission.SetFlag( "isMT_InterroMarker_MTSquad", false )
					TppMission.SetFlag( "isMT_BuildingMarker_MTSquad", false )
					commonTargetMarker( "ON", CharacterID, false )
					if( RadioOff == false ) then
						-- 無線
						if( TppMission.GetFlag( "isRadio_MarkerOnMissionTargetA" ) == false ) then
							TppMission.SetFlag( "isRadio_MarkerOnMissionTargetA", true )
							--「ターゲットＡ」を見つけた：１回目
							TppRadio.DelayPlay( "Radio_MarkerOnFirstMissionTargetA", "mid", nil, EndRaioMissionTargetA )
						else
							--「ターゲットＡ」を見つけた：２回目
							TppRadio.DelayPlay( "Radio_MarkerOnSecondMissionTargetA", "mid", nil, EndRaioMissionTargetA )
						end
					else
						if( TppMission.GetFlag( "isRadio_MarkerOnMissionTargetA" ) == false ) then
							TppMission.SetFlag( "isRadio_MarkerOnMissionTargetA", true )
						end
					end
					AreaMarkerOff = true
				end
			-- 尋問マーカー
			else
				-- ターゲットマーカー表示されてない
				if( TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == false and TppMission.GetFlag( "isMT_BuildingMarker_MTSquad" ) == false and TppMission.GetFlag( "isMT_InterroMarker_MTSquad" ) == false ) then
					TppMission.SetFlag( "isMT_InterroMarker_MTSquad", true )
					TppMission.SetFlag( "isMT_TargetMarker_MTSquad", false )
					TppMission.SetFlag( "isMT_BuildingMarker_MTSquad", false )
					commonTargetMarker( "ON", CharacterID, false )
					AreaMarkerOff = true
				end
				-- アナウンスログタイミング変更
				if( TppMission.GetFlag( "isMT_InterroMarker_MTSquad" ) == true and InterrogationAnnounceLog == true ) then
					-- アナウンスログ
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			end
			if( AreaMarkerOff == true ) then
				-- エリアマーカー表示ＯＦＦ
				if( TppMission.GetFlag( "isMT_AreaMarker_MTSquad" ) ~= 255 ) then
					TppMission.SetFlag( "isMT_AreaMarker_MTSquad", 255 )
					commonAreaMarkerMTSquad( false, false, false, true, false, false )
				else
					-- アイコン名のみ変更
					commonMTSquadIconUniqueInformation()
				end
			end
		-- ＭＴ管理棟
		elseif( CharacterID == this.CharacterID_MT_Center ) then
			-- ターゲットマーカー
			if( InterrogationFlag == false ) then
				if( TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == false ) then
					TppMission.SetFlag( "isMT_TargetMarker_MTCenter", true )
					TppMission.SetFlag( "isMT_InterroMarker_MTCenter", false )
					TppMission.SetFlag( "isMT_BuildingMarker_MTCenter", false )
					commonTargetMarker( "ON", CharacterID, false )
					if( RadioOff == false ) then
						-- 無線
						if( TppMission.GetFlag( "isRadio_MarkerOnMissionTargetB" ) == false ) then
							TppMission.SetFlag( "isRadio_MarkerOnMissionTargetB", true )
							--「ターゲットＢ」を見つけた：１回目
							TppRadio.DelayPlay( "Radio_MarkerOnFirstMissionTargetB", "mid", nil, EndRaioMissionTargetB )
						else
							--「ターゲットＢ」を見つけた：２回目
							TppRadio.DelayPlay( "Radio_MarkerOnSecondMissionTargetB", "mid", nil, EndRaioMissionTargetB )
						end
					else
						if( TppMission.GetFlag( "isRadio_MarkerOnMissionTargetB" ) == false ) then
							TppMission.SetFlag( "isRadio_MarkerOnMissionTargetB", true )
						end
					end
					AreaMarkerOff = true
				end
			-- 尋問マーカー
			else
				-- ターゲットマーカー表示されてない
				if( TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == false and TppMission.GetFlag( "isMT_BuildingMarker_MTCenter" ) == false and TppMission.GetFlag( "isMT_InterroMarker_MTCenter" ) == false ) then
					TppMission.SetFlag( "isMT_InterroMarker_MTCenter", true )
					TppMission.SetFlag( "isMT_TargetMarker_MTCenter", false )
					TppMission.SetFlag( "isMT_BuildingMarker_MTCenter", false )
					commonTargetMarker( "ON", CharacterID, false )
					-- アナウンスログ
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
					AreaMarkerOff = true
				end
				-- アナウンスログタイミング変更
				if( TppMission.GetFlag( "isMT_InterroMarker_MTCenter" ) == true and InterrogationAnnounceLog == true ) then
					-- アナウンスログ
					commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
				end
			end
			if( AreaMarkerOff == true ) then
				-- エリアマーカー表示ＯＦＦ
				if( TppMission.GetFlag( "isMT_AreaMarker_MTCenter" ) ~= 255 ) then
					TppMission.SetFlag( "isMT_AreaMarker_MTCenter", 255 )
					commonAreaMarkerMTCenter( false, false, false, true, false, false )
				else
					-- アイコンの名前のみ変更
					commonMTCenterIconUniqueInformation()
				end
			end
		end
		-- 任意無線変更する
		if( phase ~= "Alert" and this.CounterList.ForceRoute_MTSquad == "OFF" and this.CounterList.ForceRoute_MTCenter == "OFF" and TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == true and TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == true ) then
			commonRegisterOptionalRadioSetup( false, false )
		end
	end
end

-- ■「ターゲット」のマーカーＯＦＦ
local commonMissionTargetMarkerOFF = function( CharacterID, BuildingFlag, IntelRadioName )
	Fox.Log( "commonMissionTargetMarkerOFF:"..CharacterID )
	-- ＭＴ倉庫
	if( CharacterID == this.CharacterID_MT_Squad ) then
		-- ターゲットマーカー表示されている
		if( TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == true ) then
			TppMission.SetFlag( "isMT_TargetMarker_MTSquad", false )
			TppMission.SetFlag( "isMT_BuildingMarker_MTSquad", false )
			TppMission.SetFlag( "isMT_InterroMarker_MTSquad", false )
			-- 建物中に入った
			if( BuildingFlag == true ) then
				-- マーカー
				TppMission.SetFlag( "isMT_BuildingMarker_MTSquad", true )
				commonTargetMarker( "ON", CharacterID, false )
				-- 無線
				commonMissionTargetInBuildingRadio( CharacterID )
				-- アイコン名変更
				commonMTSquadIconUniqueInformation()
				if( IntelRadioName ~= "NoIntelRadioName" ) then
					-- 諜報無線オン
					TppRadio.EnableIntelRadio( IntelRadioName )
					-- フラグオン
					this.CounterList.IntelRadioBuilding_MTSquad = true
					if( IntelRadioName == "intel_e0020_esrg0080b_a" ) then
						-- 倉庫武器庫の諜報無線オフ
						TppRadio.DisableIntelRadio( "intel_e0020_esrg0070a" )
					elseif( IntelRadioName == "intel_e0020_esrg0080b_b" ) then
						-- ヘリポート武器庫の諜報無線オフ
						TppRadio.DisableIntelRadio( "intel_e0020_esrg0070b" )
						-- ２人とも同じ武器庫に入った場合
						if( this.CounterList.IntelRadioBuilding_MTCenter == true ) then
							TppRadio.DisableIntelRadio( "intel_e0020_esrg0080b_b" )
							TppRadio.EnableIntelRadio( "intel_e0020_esrg0081" )
						end
					end
				end
			end
		-- ターゲットマーカー表示されていない
		else
			-- 建物の中に入っていない場合の処理
			if( BuildingFlag == false ) then
				if( TppMission.GetFlag( "isMT_AreaMarker_MTSquad" ) ~= 255 ) then
					TppMission.SetFlag( "isMT_AreaMarker_MTSquad", 255 )
					commonAreaMarkerMTSquad( false, false, false, true, false, false )
				end
			end
		end
	-- ＭＴ管理棟
	elseif( CharacterID == this.CharacterID_MT_Center ) then
		-- ターゲットマーカー表示されてる
		if( TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == true ) then
			TppMission.SetFlag( "isMT_TargetMarker_MTCenter", false )
			TppMission.SetFlag( "isMT_BuildingMarker_MTCenter", false )
			TppMission.SetFlag( "isMT_InterroMarker_MTCenter", false )
			-- 建物中に入った
			if( BuildingFlag == true ) then
				-- マーカー
				TppMission.SetFlag( "isMT_BuildingMarker_MTCenter", true )
				commonTargetMarker( "ON", CharacterID, false )
				-- 無線
				commonMissionTargetInBuildingRadio( CharacterID )
				-- アイコン名変更
				commonMTCenterIconUniqueInformation()
				if( IntelRadioName ~= "NoIntelRadioName" ) then
					-- フラグオン
					this.CounterList.IntelRadioBuilding_MTCenter = true
					-- 諜報無線オン
					TppRadio.EnableIntelRadio( IntelRadioName )
					-- 諜報無線オン
					TppRadio.EnableIntelRadio( IntelRadioName )
					if( IntelRadioName == "intel_e0020_esrg0080a_a" ) then
						-- 倉庫武器庫の諜報無線オフ
						TppRadio.DisableIntelRadio( "intel_e0020_esrg0070c" )
					elseif( IntelRadioName == "intel_e0020_esrg0080a_b" ) then
						-- ヘリポート武器庫の諜報無線オフ
						TppRadio.DisableIntelRadio( "intel_e0020_esrg0070b" )
						-- ２人とも同じ武器庫に入った場合
						if( this.CounterList.IntelRadioBuilding_MTSquad == true ) then
							TppRadio.DisableIntelRadio( "intel_e0020_esrg0080a_b" )
							TppRadio.EnableIntelRadio( "intel_e0020_esrg0081" )
						end
					end
				end
			end
		-- ターゲットマーカー表示されていない
		else
			-- 建物の中に入っていない場合の処理
			if( BuildingFlag == false ) then
				if( TppMission.GetFlag( "isMT_AreaMarker_MTCenter" ) ~= 255 ) then
					TppMission.SetFlag( "isMT_AreaMarker_MTCenter", 255 )
					commonAreaMarkerMTCenter( false, false, false, true, false, false )
				end
			end
		end
	end
end

-- ■「指」「目」のエリアマーカーＯＦＦ
local commonAlertAreaMarkerOff = function()
	Fox.Log( "commonAlertAreaMarkerOff")
	local AnnounceLogFlag = false
	-- ＭＴ倉庫
	if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 and TppMission.GetFlag( "isMT_AreaMarker_MTSquad" ) ~= 255 ) then
		commonAreaMarkerMTSquad( false, false, true, true, true, false )
		AnnounceLogFlag = true
	end
	-- ＭＴ管理棟
	if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 and TppMission.GetFlag( "isMT_AreaMarker_MTCenter" ) ~= 255 ) then
		commonAreaMarkerMTCenter( false, false, true, true, true, false )
		AnnounceLogFlag = true
	end
	-- アナウンスログ
	if( AnnounceLogFlag == true ) then
		commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
	end
end

-- ■「脱出」のエリアマーカーＯＮ
local commonEscapeMarker = function()
	Fox.Log( "commonEscapeMarker")
	-- 基地からの脱出ポイントをマーカー表示
	TppMarker.Enable( this.MarkerID_EscapeWest, 1, "moving", "all", 0, true, true )
	-- 基地からの脱出ポイントをマーカー表示
	TppMarker.Enable( this.MarkerID_EscapeNorth, 1, "moving", "all", 0, true, true )

end

---------------------------------------------------------------------------------
-- ■■ Route Functions
---------------------------------------------------------------------------------

-- ■「指」のルート初期化
local commonMTSquadRouteDisable = function( iCheckPointFlag, iAllDisableFlag, iSubRouteEnableFlag )
	iCheckPointFlag		= iCheckPointFlag or false
	iAllDisableFlag		= iAllDisableFlag or false
	local state			= TppMission.GetFlag( "isMT_Squad_StateMove" )
	Fox.Log("commonMTSquadRouteDisable")
	if( iAllDisableFlag == false ) then
		-- ＭＴ倉庫
		if( iCheckPointFlag == true ) then
			if( state == 0 or state == 1 )	then
			else
				TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0000" )
				TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0001" )
				TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0002" )
			end
		end
		if( state == 0 or state == 1 or state == 2 or state == 3 ) then
			TppEnemy.DisableRoute( this.cpID, "gntn_common_d01_route0008" )
		end
	else
		TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0000" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0001" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0002" )
	end
	-- 要人生存時、要人 Sneak
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0000_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0000_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_01_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_01_0002" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0000_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_01_0000_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_01_0001_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_02_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_02_0000_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_02_0000_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_02_0001_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_03_0000" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_03_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_03_0002" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_03_0000_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_03_0001_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0003" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0004" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0005" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0006" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0000_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0000" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0002" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0003" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0004" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0005" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0006" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0000_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0002_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0001_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0002_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_05_0000" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_05_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_06_0000" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_07_0000_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_07_0001_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_05_0000_Con" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_05_0001_Con" )
	-- 要人生存時、要人 Caution
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0000_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_01_0000_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_02_0000_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_03_0000_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0000_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0001_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_05_0000_C" )
	-- 要人死亡時、要人付き添い Sneak
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0000_DE" )
	-- 要人死亡時、要人付き添い Caution
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0000_DEC" )
	-- 要人生存時、要人付き添い Caution
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0000_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_01_0000_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_02_0000_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_03_0000_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0000_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0001_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_05_0000_EC" )
	-- 要人生存時、要人 Alert
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0000_Escape" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_01_0000_Escape" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_02_0000_Escape" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_03_0000_Escape" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0000_Escape" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0001_Escape" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_05_0000_Escape" )
	-- 要人生存時、要人 車両失敗時 Sneak
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0000_VSE" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_01_0000_VSE" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_02_0000_VSE" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_03_0000_VSE" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0000_VSE" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0001_VSE" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_05_0000_VSE" )
	-- 要人と付き添いではないルート
	if( iSubRouteEnableFlag == true ) then
		TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0008" )
		TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0011" )
		TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0008" )
		if( state == 12 or state == 13 or state == 14 ) then
			TppEnemy.EnableRoute( this.cpID, "e20020_route_eastTent01_0002" )
			TppEnemy.EnableRoute( this.cpID, "e20020_route_eastTent02_0002" )
		end
	end
end

-- ■「目」のルート初期化
local commonMTCenterRouteDisable = function( iCheckPointFlag, iAllDisableFlag )
	iCheckPointFlag		= iCheckPointFlag or false
	iAllDisableFlag		= iAllDisableFlag or false
	local state			= TppMission.GetFlag( "isMT_Center_StateMove" )
	Fox.Log("commonMTCenterRouteDisable")
	if( iAllDisableFlag == false ) then
		if( iCheckPointFlag == true ) then
			if( state == 0 ) then
				TppEnemy.EnableRoute( this.cpID, "e20020_route_MT01_00_0000" )
				TppEnemy.EnableRoute( this.cpID, "e20020_route_MT01_00_0001" )
				TppEnemy.EnableRoute( this.cpID, "e20020_route_MT01_00_0002" )
			else
				TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0000" )
				TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0001" )
				TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0002" )
			end
		end
	else
		TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0000" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0001" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0002" )
	end
	-- 要人生存時、要人 Sneak
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_01_0000_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_01_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_01_0002_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_02_0000_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_03_0000_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_03_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_03_0002_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_04_0000" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_04_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_04_0002" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_05_0000" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_05_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_05_0002" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_06_0000_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_06_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_06_0002_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_07_0000_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_08_0000_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_09_0000_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_10_0000" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_10_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_10_0002" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_10_0000_Con" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_10_0001_Con" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_10_0002_Con" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_11_0000" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_12_0000_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_12_0001_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_12_0002_VS" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_13_0000_S" )
	-- 要人生存時、要人 Caution
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0000_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_01_0000_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_02_0000_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_03_0000_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_04_0000_C" )
	-- 要人生存時、要人付き添い Caution
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0000_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0001_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_01_0000_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_01_0001_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_02_0000_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_02_0001_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_03_0000_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_03_0001_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_04_0000_EC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_04_0001_EC" )
	-- 要人生存時、要人 Alert
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0000_Escape" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_01_0000_Escape" )
	-- 要人死亡時、要人付き添い Sneak
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0000_DE" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0001_DE" )
	-- 要人死亡時、要人付き添い Caution
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0000_DEC" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_00_0001_DEC" )
end

-- ■「ビークル兵」のルート初期化
local commonEnemyVehicleRouteDisable = function( iCheckPointFlag, iAllDisableFlag, InitFlag )
	iCheckPointFlag		= iCheckPointFlag or false
	iAllDisableFlag		= iAllDisableFlag or false
	local state			= TppMission.GetFlag( "isEnemy_Vehicle_StateMove" )
	Fox.Log("commonEnemyVehicleRouteDisable")
	if( iAllDisableFlag == false ) then
		if( iCheckPointFlag == true ) then
			if( state == 0 ) then
			else
				TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0000" )
				TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle01_0000" )
			end
		end
		-- Sneak
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0000_VS" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0000_VSE" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0001" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0001_VS" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0001_VSE" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle01_0000_VS" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle01_0001" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle01_0002" )
		-- Caution
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0001_C" )
		TppEnemy.DisableRoute( this.cpID, "gntn_common_c01_route0001" )
	else
		-- Sneak
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0000" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0000_VS" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0000_VSE" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0001" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0001_VS" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0001_VSE" )
		if( InitFlag == false ) then
			TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle01_0000" )
			TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle01_0000_VS" )
			TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle01_0001" )
			TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle01_0002" )
			-- Caution
			TppEnemy.DisableRoute( this.cpID, "e20020_route_Vehicle00_0001_C" )
			TppEnemy.DisableRoute( this.cpID, "gntn_common_c01_route0001" )
		end
	end
end

-- ■「トラック兵」のルート初期化
local commonEnemyWestern01RouteDisable = function( iCheckPointFlag, iAllDisableFlag )
	iCheckPointFlag		= iCheckPointFlag or false
	iAllDisableFlag		= iAllDisableFlag or false
	local state			= TppMission.GetFlag( "isEnemy_Western01_StateMove" )
	Fox.Log("commonEnemyWestern01RouteDisable")
	if( iAllDisableFlag == false ) then
		if( iCheckPointFlag == true ) then
			if( state == 0 or state == 1 ) then
			else
				TppEnemy.DisableRoute( this.cpID, "e20020_route_Western00_0000" )
			end
		end
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Western00_0001")
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Western00_0002_VS01")
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Western00_0002_VS02")
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Western00_0002_VSE")
	else
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Western00_0000" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Western00_0001")
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Western00_0002_VS01")
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Western00_0002_VS02")
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Western00_0002_VSE")
	end
end

-- ■「トラック付き添い兵」のルート初期化
local commonEnemyImitationRouteDisable = function( iCheckPointFlag, iAllDisableFlag )
	iCheckPointFlag		= iCheckPointFlag or false
	iAllDisableFlag		= iAllDisableFlag or false
	local state			= TppMission.GetFlag( "isEnemy_Imitation_StateMove" )
	Fox.Log("commonEnemyImitationRouteDisable")
	if( iAllDisableFlag == false ) then
		if( iCheckPointFlag == true ) then
			if( state == 0 ) then
			else
				TppEnemy.DisableRoute( this.cpID, "e20020_route_Imitation00_0000" )
			end
		end
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Imitation00_0001" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Imitation00_0003_VS" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Imitation00_0003_VSE" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Imitation00_0002" )
	else
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Imitation00_0000" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Imitation00_0001" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Imitation00_0003_VS" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Imitation00_0003_VSE" )
		TppEnemy.DisableRoute( this.cpID, "e20020_route_Imitation00_0002" )
	end
end

-- ■「増援兵」のルート初期化
local commonEnemyReinforceRouteDisable = function( iCheckPointFlag, iAllDisableFlag )
	iCheckPointFlag		= iCheckPointFlag or false
	iAllDisableFlag		= iAllDisableFlag or false
	local state			= TppMission.GetFlag( "isEnemy_Reinforce_StateMove" )
	Fox.Log("commonEnemyReinforceRouteDisable")
	-- 西側増援ルート
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce00_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce01_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce02_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce03_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce00_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce01_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce02_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce03_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce00_0001_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce01_0001_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce02_0001_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce03_0001_C" )
	-- 東側増援ルート
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce04_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce05_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce06_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce07_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce04_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce05_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce06_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce07_0001_S" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce04_0001_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce05_0001_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce06_0001_C" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Reinforce07_0001_C" )
end

-- ■「共通」のルート初期化
local commonEnemyRouteDisable = function( iCheckPointFlag, iAllDisableFlag )
	iCheckPointFlag = iCheckPointFlag or false
	iAllDisableFlag = iAllDisableFlag or false
	Fox.Log("commonEnemyRouteDisable")
	-- 東難民キャンプ：海岸
	TppEnemy.DisableRoute( this.cpID, "e20020_route_eastTent01_0000" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_eastTent01_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_eastTent01_0002" )
	-- 東難民キャンプ：倉庫
	TppEnemy.DisableRoute( this.cpID, "e20020_route_eastTent02_0000" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_eastTent02_0001" )
	TppEnemy.DisableRoute( this.cpID, "e20020_route_eastTent02_0002" )
	-- 西側管理棟内
	TppEnemy.DisableRoute( this.cpID, "gntn_common_d01_route0019" )
	TppEnemy.DisableRoute( this.cpID, "gntn_common_d01_route0020" )
	-- 東側管理棟内
	TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_08_0000" )
	-- 旧収容施設
	TppEnemy.DisableRoute( this.cpID, "e20020_route_Asylum00_0000" )
	-- ヤグラ破壊後ルート
	if( TppMission.GetFlag( "isGimmick_Break_WoodTurret02" ) == false ) then
		TppEnemy.DisableRoute( this.cpID, "gntn_common_d01_route0005" )
		TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0021" )
	else
		TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0005" )
		TppEnemy.DisableRoute( this.cpID, "gntn_common_d01_route0021" )
	end
end

---------------------------------------------------------------------------------
-- ■■ GuardTarget Functions
---------------------------------------------------------------------------------

-- ■「指」のガードターゲット設定
local commonMTSquad_GuardTarget = function()
	Fox.Log( "commonMTSquad_GuardTarget" )
	local StateMove = TppMission.GetFlag( "isMT_Squad_StateMove" )
	if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 )  then
		commonPrint2D("【設定】ＭＴ倉庫：ガードターゲット西ミッション圏外エリア設定" , 3 )
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID,		"TppGuardTargetData_VipA0000", true )
		TppCommandPostObject.GsSetVipPriorityGuardTarget( this.cpID,	"TppGuardTargetData_VipA0000", this.CharacterID_MT_Squad )
	else
		commonPrint2D("【設定】ＭＴ倉庫：ガードターゲット西ミッション圏外エリア設定" , 3 )
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID,		"TppGuardTargetData_VipA0000", true )
	end
end

-- ■「目」のガードターゲット設定
local commonMTCenter_GuardTarget = function()
	Fox.Log( "commonMTCenter_GuardTarget" )
	-- ガードターゲット設定
	if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 )	then
		commonPrint2D("【設定】ＭＴ管理棟：ガードターゲット東ミッション圏外エリア設定" , 3 )
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID,		"TppGuardTargetData_VipB0000", true )
		TppCommandPostObject.GsSetVipPriorityGuardTarget( this.cpID,	"TppGuardTargetData_VipB0000", this.CharacterID_MT_Center )
	else
		commonPrint2D("【設定】ＭＴ管理棟：死亡の為、ガードターゲット東ミッション圏外エリア設定" , 3 )
		TppCommandPostObject.GsSetGuardTargetValidity( this.cpID,		"TppGuardTargetData_VipB0000", true )
	end
end

---------------------------------------------------------------------------------
-- ■■ RegisterPoint Functions
---------------------------------------------------------------------------------

-- ■「指」の復帰ポイント
local commonMT_Sqaud_RegisterPoint = function( manager, iStateMove, iSequenceSkipFlag )
	iStateMove			= iStateMove or 0
	iSequenceSkipFlag	= iSequenceSkipFlag or false
	Fox.Log( "commonMT_Sqaud_RegisterPoint" )
	-- 敵兵の状態で場所を変更する
	if( iStateMove == 0 or iStateMove == 1 or iStateMove == 2 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Squad,		"e20020_MT00_00_S0000" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Squad,		"e20020_MT00_00_S0001" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Vehicle02,		"e20020_MT00_00_V" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Squad,		"e20020_MT00_00_S0000" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Squad,		"e20020_MT00_00_S0001" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Vehicle02,		"e20020_MT00_00_V" )
		end
	elseif( iStateMove == 3 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Squad,		"e20020_MT00_00_S0002" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Squad,		"e20020_MT00_00_S0003" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Vehicle02,		"e20020_MT00_00_V" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Squad,		"e20020_MT00_00_S0002" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Squad,		"e20020_MT00_00_S0003" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Vehicle02,		"e20020_MT00_00_V" )
		end
	elseif( iStateMove == 4 or iStateMove == 5 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Squad,		"e20020_MT00_01_S0000" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Squad,		"e20020_MT00_01_S0001" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Vehicle02,		"e20020_MT00_01_V" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Squad,		"e20020_MT00_01_S0000" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Squad,		"e20020_MT00_01_S0001" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Vehicle02,		"e20020_MT00_01_V" )
		end
	elseif( iStateMove == 6 or iStateMove == 7 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Squad,		"e20020_MT00_02_S0000" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Squad,		"e20020_MT00_02_S0001" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Vehicle02,		"e20020_MT00_02_V" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Squad,		"e20020_MT00_02_S0000" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Squad,		"e20020_MT00_02_S0001" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Vehicle02,		"e20020_MT00_02_V" )
		end
	elseif( iStateMove == 8 or iStateMove == 9 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Squad,		"e20020_MT00_03_S0000" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Squad,		"e20020_MT00_03_S0001" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Vehicle02,		"e20020_MT00_03_V" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Squad,		"e20020_MT00_03_S0000" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Squad,		"e20020_MT00_03_S0001" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Vehicle02,		"e20020_MT00_03_V" )
		end
	elseif( iStateMove == 10 or iStateMove == 11 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Squad,		"e20020_MT00_04_S0000" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Squad,		"e20020_MT00_04_S0001" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Vehicle02,		"e20020_MT00_04_V0000" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Squad,		"e20020_MT00_04_S0000" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Squad,		"e20020_MT00_04_S0001" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Vehicle02,		"e20020_MT00_04_V0000" )
		end
	elseif( iStateMove == 12 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Squad,		"e20020_MT00_04_S0002" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Squad,		"e20020_MT00_04_S0003" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Vehicle02,		"e20020_MT00_04_V0000" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Squad,		"e20020_MT00_04_S0002" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Squad,		"e20020_MT00_04_S0003" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Vehicle02,		"e20020_MT00_04_V0000" )
		end
	elseif( iStateMove == 13 or iStateMove == 14 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Squad,		"e20020_MT00_04_S0004" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Squad,		"e20020_MT00_04_S0005" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Vehicle02,		"e20020_MT00_04_V0001" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Squad,		"e20020_MT00_04_S0004" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Squad,		"e20020_MT00_04_S0005" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Vehicle02,		"e20020_MT00_04_V0001" )
		end
	elseif( iStateMove >= 15 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Squad,		"e20020_MT00_05_S0000" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Squad,		"e20020_MT00_05_S0001" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Vehicle02,		"e20020_MT00_05_V" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Squad,		"e20020_MT00_05_S0000" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Squad,		"e20020_MT00_05_S0001" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Vehicle02,		"e20020_MT00_05_V" )
		end
	end
end

-- ■「目」の復帰ポイント
local commonMT_Center_RegisterPoint = function( manager, iStateMove, iSequenceSkipFlag )
	iStateMove			= iStateMove or 0
	iSequenceSkipFlag	= iSequenceSkipFlag or false
	Fox.Log( "commonMT_Center_RegisterPoint" )
	-- 敵兵の状態で場所を変更する
	if( iStateMove == 0 or iStateMove == 1 or iStateMove == 4 or iStateMove == 5 or iStateMove == 6 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Center, 	"e20020_MT01_00_S0000" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Center01,	"e20020_MT01_00_S0001" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Center02,	"e20020_MT01_00_S0002" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Center,		"e20020_MT01_00_S0000" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Center01,	"e20020_MT01_00_S0001" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Center02,	"e20020_MT01_00_S0002" )
		end
	elseif( iStateMove == 2 or iStateMove == 3 or iStateMove == 7 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Center, 	"e20020_MT01_05_S0000" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Center01,	"e20020_MT01_05_S0001" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Center02,	"e20020_MT01_05_S0002" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Center,		"e20020_MT01_05_S0000" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Center01,	"e20020_MT01_05_S0001" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Center02,	"e20020_MT01_05_S0002" )
		end
	elseif( iStateMove == 8 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Center, 	"e20020_MT01_06_S0000" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Center01,	"e20020_MT01_06_S0001" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Center02,	"e20020_MT01_06_S0002" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Center,		"e20020_MT01_06_S0000" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Center01,	"e20020_MT01_06_S0001" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Center02,	"e20020_MT01_06_S0002" )
		end
	elseif( iStateMove == 9 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Center,		"e20020_MT01_07_S0000" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Center01,	"e20020_MT01_07_S0001" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Center02,	"e20020_MT01_07_S0002" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_MT_Center,		"e20020_MT01_07_S0000" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Center01,	"e20020_MT01_07_S0001" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Center02,	"e20020_MT01_07_S0002" )
		end
	elseif( iStateMove == 10 or iStateMove == 11 or iStateMove == 12 or iStateMove == 13 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_MT_Center,		"e20020_MT01_10_S0000" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Center01,	"e20020_MT01_10_S0001" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Center02,	"e20020_MT01_10_S0002" )
		else
			TppMission.RegisterVipRestorePoint( 					this.CharacterID_MT_Center,		"e20020_MT01_10_S0000" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Center01,	"e20020_MT01_10_S0001" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Center02,	"e20020_MT01_10_S0002" )
		end
	end
end

-- ■「ビークル兵」の復帰ポイント
local commonEnemy_Vehicle_RegisterPoint = function( manager, iStateMove, iSequenceSkipFlag )
	iStateMove			= iStateMove or 0
	iSequenceSkipFlag	= iSequenceSkipFlag or false
	Fox.Log( "commonEnemy_Vehicle_RegisterPoint" )
	-- ビークル兵が移動中で旧収容施設に到着してない場合は、旧収容施設に到着してる事にする。
	if( iSequenceSkipFlag == false ) then
		if( iStateMove == 1 ) then
			iStateMove = 2
		end
	end
	-- 敵兵の状態で場所を変更する
	if( iStateMove == 2 or iStateMove == 3 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Vehicle01,	"e20020_EV00_01_S" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Vehicle02,	"e20020_EV01_01_S" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Vehicle01,		"e20020_EV00_01_V" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Vehicle01,	"e20020_EV00_01_S" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Vehicle02,	"e20020_EV01_01_S" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Vehicle01,		"e20020_EV00_01_V" )
		end
	elseif( iStateMove == 4 or iStateMove == 999 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Vehicle01,	"e20020_EV00_02_S" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Vehicle02,	"e20020_EV01_01_S" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Vehicle01,		"e20020_EV00_02_V" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Vehicle01,	"e20020_EV00_02_S" )
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Vehicle02,	"e20020_EV01_01_S" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Vehicle01,		"e20020_EV00_02_V" )
		end
	end
end

-- ■「ビークル付き添い兵」の復帰ポイント
local commonEnemy_Imitation_RegisterPoint = function( manager, iStateMove, iSequenceSkipFlag )
	iStateMove			= iStateMove or 0
	iSequenceSkipFlag	= iSequenceSkipFlag or false
	Fox.Log( "commonEnemy_Imitation_RegisterPoint" )
	-- ビークル兵付き添い兵が移動中で旧収容施設に到着してない場合は、会話開始してる事にする。
	if( iSequenceSkipFlag == false ) then
		if( iStateMove == 1 ) then
			iStateMove = 2
		end
	end
	-- 敵兵の状態で場所を変更する
	if( iStateMove == 2 or iStateMove == 3 or iStateMove == 4 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Imitation,	"e20020_EI00_01_S" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_Imitation,	"e20020_EI00_01_S" )
		end
	elseif( iStateMove == 5 or iStateMove == 999 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Imitation,	"e20020_EI00_02_S" )
		else
			TppMission.RegisterVipRestorePoint( 					this.CharacterID_E_Imitation,	"e20020_EI00_02_S" )
		end
	end
end

-- ■「トラック兵」の復帰ポイント
local commonEnemy_Western01_RegisterPoint = function( manager, iStateMove, iSequenceSkipFlag )
	iStateMove			= iStateMove or 0
	iSequenceSkipFlag	= iSequenceSkipFlag or false
	Fox.Log( "commonEnemy_Western01_RegisterPoint" )
	-- 敵兵の状態で場所を変更する
	if( iStateMove == 5 or iStateMove == 999 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_Western01,	"e20020_EW00_01_S" )
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.VehicleID_Western02,		"e20020_EW00_01_V" )
		else
			TppMission.RegisterVipRestorePoint( 					this.CharacterID_E_Western01,	"e20020_EW00_01_S" )
			TppMission.RegisterVipRestorePoint(						this.VehicleID_Western02,		"e20020_EW00_01_V" )
		end
	end
end

-- ■「東難民キャンプ敵兵０１」の復帰ポイント
local commonEnemy_eastTent01_RegisterPoint = function( manager, iStateMove, iSequenceSkipFlag )
	iStateMove			= iStateMove or 0
	iSequenceSkipFlag	= iSequenceSkipFlag or false
	Fox.Log( "commonEnemy_eastTent01_RegisterPoint" )
	-- 敵兵の状態で場所を変更する
	if( iStateMove == 2 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_eastTentNorth01,	"e20020_EE00_02_S" )
		else
			TppMission.RegisterVipRestorePoint( 					this.CharacterID_E_eastTentNorth01,	"e20020_EE00_02_S" )
		end
	end
end

-- ■「東難民キャンプ敵兵０２」の復帰ポイント
local commonEnemy_eastTent02_RegisterPoint = function( manager, iStateMove, iSequenceSkipFlag )
	iStateMove			= iStateMove or 0
	iSequenceSkipFlag	= iSequenceSkipFlag or false
	Fox.Log( "commonEnemy_eastTent02_RegisterPoint" )
	-- 敵兵の状態で場所を変更する
	if( iStateMove == 2 ) then
		if( iSequenceSkipFlag == true ) then
			TppPlayer.WarpForDebugStartInVipRestorePoint( manager,	this.CharacterID_E_eastTentNorth02,	"e20020_EE01_02_S" )
		else
			TppMission.RegisterVipRestorePoint(						this.CharacterID_E_eastTentNorth02,	"e20020_EE01_02_S" )
		end
	end
end

---------------------------------------------------------------------------------
-- ■■ RegisterVipMember Functions
---------------------------------------------------------------------------------
-- ■「指」ＶＩＰメンバー設定
local commonRegisterVipMember_MTSquad = function()
	Fox.Log( "commonRegisterVipMember_MTSquad" )
	if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 )  then
		commonPrint2D("【設定】ＭＴ倉庫：グループ設定" , 1 )
		MissionManager.RegisterVipMember( this.RegisterVipMemberID_MTSquad, this.CharacterID_MT_Squad,	"kill", 0 )				-- 要人Ａ
		MissionManager.RegisterVipMember( this.RegisterVipMemberID_MTSquad, this.CharacterID_E_Squad,	"kill", 1 )				-- 要人Ａ付き添い
		MissionManager.RegisterVipMember( this.RegisterVipMemberID_MTSquad, this.VehicleID_Vehicle02,	"kill", 2 )				-- ビークル
	end
end
-- ■「目」ＶＩＰメンバー設定
local commonRegisterVipMember_MTCenter = function()
	Fox.Log( "commonRegisterVipMember_MTCenter" )
	if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 )	then
		commonPrint2D("【設定】ＭＴ管理棟：グループ設定" , 1 )
		MissionManager.RegisterVipMember( this.RegisterVipMemberID_MTCenter, this.CharacterID_MT_Center,	"kill", 0 )			-- 要人Ｂ
		MissionManager.RegisterVipMember( this.RegisterVipMemberID_MTCenter, this.CharacterID_E_Center01,	"kill", 1 )			-- 要人Ｂ付き添い
		MissionManager.RegisterVipMember( this.RegisterVipMemberID_MTCenter, this.CharacterID_E_Center02,	"kill", 2 )			-- 要人Ｂ付き添い
	end
end

---------------------------------------------------------------------------------
-- ■■ Game MT Functions
---------------------------------------------------------------------------------
-- ■ ミッション圏外失敗設定
local commonMissionFailedMTEscapeMissionArea = function( CharacterID, VehicleID, EscapeArea )
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log( "commonMissionFailedMTEscapeMissionArea"..sequence)
	-- デバッグ
	if( ( CharacterID == this.CharacterID_MT_Squad and this.DebugMissionAreaOutMTSquadOFF == true ) or ( CharacterID == this.CharacterID_MT_Center and this.DebugMissionAreaOutMTCenterOFF == true ) ) then
		commonPrint2D("ターゲットがミッション圏外で出ました。"..CharacterID.. "", 1 )
		return
	end
	-- ミッション失敗シーケンスへ
	if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" or sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) then
		-- ミッション失敗演出準備
		this.CounterList.VipOnEscapeVehicleID	= VehicleID
		this.CounterList.VipOnEscapeCharacterID	= CharacterID
		this.CounterList.VipOnEscapeArea		= EscapeArea
		-- ミッション失敗
		TppSequence.ChangeSequence( "Seq_Mission_FailedMTEscapeMissionArea" )
	end
end

-- ■ 敵兵の進行状態により車両をDisable
local commonDisableStateMoveVehicle = function( DisableCharacterID ) 
	Fox.Log( "commonDisableStateMoveVehicle" )
	-- プレイヤーが乗っているビークルＩＤ取得
	local PlayerVehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()
	-- 設定されていたら
	if( DisableCharacterID ~= "NoName" ) then
		-- プレイヤーが非表示しようとしているビークルに乗っていなければ非表示にする
		if( PlayerVehicleId ~= DisableCharacterID ) then
			TppData.Disable( DisableCharacterID )
			TppMarker.Disable( DisableCharacterID )
		end
	end
end

-- ■「指」エリアマーカータイム設定
local commonMT_Squad_AreaMarkerTimeStart = function( num )
	Fox.Log( "commonMT_Squad_AreaMarkerTimeStart" )
	if( num == 0 ) then
		TppTimer.Stop( "Timer_MT_Squad_StateMove_MarkerOn" )
		TppTimer.Start( "Timer_MT_Squad_StateMove_MarkerOn", this.Timer_MTSquad_AreaMarkerOn )
	else
		TppTimer.Stop( "Timer_MT_Squad_StateMove_MarkerOff" )
		TppTimer.Start( "Timer_MT_Squad_StateMove_MarkerOff", this.Timer_MTSquad_AreaMarkerOff )
	end
end

-- ■「指」強制ルート行動開始
local commonMT_Squad_ForceRouteMode = function( state )
	Fox.Log( "commonMT_Squad_ForceRouteMode" )
	-- 強制ルート行動オン
	if( this.CounterList.ForceRoute_MTSquad == "OFF" ) then
		commonPrint2D("【開始】ＭＴ倉庫：ミッション圏外へ逃げる開始" , 1 )
		-- 強制ルートフラグオン※フラグは保存されない
		this.CounterList.ForceRoute_MTSquad = "ON"
		-- 強制ルート行動開始
		TppEnemyUtility.SetForceRouteMode( this.CharacterID_MT_Squad, true )
		-- ＭＴ倉庫使用していたルート全てオフ
		commonMTSquadRouteDisable( false, true, false )
		-- 居場所によって西or東ミッション圏外へむかう
		if( state == 0 or state == 1 or state == 2 )  then
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_00_0000_Escape",			-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_00_0000_Escape",			-1, -1 )
		elseif( state == 3 or state == 4 or state == 5 )  then
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_01_0000_Escape",			-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_01_0000_Escape",			-1, -1 )
		elseif( state == 6 or state == 7 )	then
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_02_0000_Escape",			-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_02_0000_Escape",			-1, -1 )
		elseif( state == 8 or state == 9 )	then
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_03_0000_Escape",			-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_03_0000_Escape",			-1, -1 )
		elseif( state == 10 or state == 11 )  then
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_04_0000_Escape",			-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_04_0000_Escape",			-1, -1 )
		elseif( state == 12 or state == 13 or state == 14 )  then
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_04_0001_Escape",			-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_04_0001_Escape",			-1, -1 )
		elseif( state == 15 or state == 16 or state == 17 )  then
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_05_0000_Escape",			-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_05_0000_Escape",			-1, -1 )
		end
	end
end

-- ■「指」建物の諜報無線ＯＦＦ設定
local commonMT_Squad_DisableIntelRadio = function( AllDisableFlag )
	Fox.Log( "commonMT_Squad_DisableIntelRadio" )
	-- 建物諜報無線がオンになってた場合はオフにする
	if( this.CounterList.IntelRadioBuilding_MTSquad == true or AllDisableFlag == true ) then
		TppRadio.DisableIntelRadio( "intel_e0020_esrg0080b_a" )
		TppRadio.DisableIntelRadio( "intel_e0020_esrg0080b_b" )
		TppRadio.DisableIntelRadio( "intel_e0020_esrg0081" )
		this.CounterList.IntelRadioBuilding_MTSquad = false
	end
end

-- ■「指」進行状態
local commonMT_Squad_StateMove = function( num, manager )
		  manager		= manager or 0
	local sequence		= TppSequence.GetCurrentSequence()
	local phase			= TppCharacterUtility.GetCpPhaseName( this.cpID )
	local state			= TppMission.GetFlag( "isMT_Squad_StateMove" )
	local kill			= TppMission.GetFlag( "isMT_SquadKill" )
	-- 次へ場所へ巡回
	if( num == "Init" or num == "CheckPoint" or num == "SequenceSkip" or num == "MTCenterDead" or num == "Lost" ) then
		-------------------------------------------------------------
		-- ＭＴ倉庫いる
		-------------------------------------------------------------
		if( kill == 0 )  then
			-- 強制ルート行動中は更新しない
			if( this.CounterList.ForceRoute_MTSquad == "OFF" ) then
				-- ＭＴ管理棟死亡後処理※移動できる状態ならば次の移動場所へ移動させる。
				if( num == "MTCenterDead" ) then
					if( state == 0 or state == 1 ) then
						TppMission.SetFlag( "isMT_Squad_StateMove", 2 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					elseif( state == 6 ) then
						TppMission.SetFlag( "isMT_Squad_StateMove", 7 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					elseif( state == 8 ) then
						TppMission.SetFlag( "isMT_Squad_StateMove", 9 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					elseif( state == 10 ) then
						TppMission.SetFlag( "isMT_Squad_StateMove", 11 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					end
					return
				end
				-- ＭＴ倉庫ガードターゲット設定
				if( num == "Init" ) then
					commonMTSquad_GuardTarget()
				end
				-- コンティニュー時
				if( num == "CheckPoint" ) then
					-- アラート状態orキープコーション状態のままだったらルートを初期化を行う
					if( TppMission.GetFlag( "isAlert" ) == true or TppMission.GetFlag( "isKeepCaution" ) == true or TppMission.GetFlag( "isMT_Squad_GroupVehicleFailed" ) == true ) then
						-- 強制ルート行動オフ
						TppEnemyUtility.SetForceRouteMode( this.CharacterID_MT_Squad, false )
						-- 車両連携フラグ初期化
						TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", false )
						-- ＭＴ倉庫使用していたルート全てオフ
						commonMTSquadRouteDisable( false, true, false )
						-- ルート再設定
						num = "CheckPointInit"
					end
				end
				----------------------------------------------------------
				if( state == 0 ) then
					commonPrint2D("【開始】ＭＴ倉庫：倉庫に待機" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_00_0000",			-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_00_0000_C",			-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_00_0001",			-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_00_0000_EC",			-1, 0 )
					end
				-------------------------------------------------------------
				elseif( state == 1 ) then
					commonPrint2D("【開始】ＭＴ倉庫：倉庫に待機：待機時間スタート" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_00_0000",			-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_00_0000_C",			-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_00_0001",			-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_00_0000_EC",			-1, 0 )
					end
					-- 巡回時間スタート
					if( num ~= "MTCenterDead" ) then
						TppTimer.Start( "Timer_MT_Squad_StateMove_Timer", this.Timer_MTSquad_wareHouse )
					end
				-------------------------------------------------------------
				elseif( state == 2 ) then
					commonPrint2D("【開始】ＭＴ倉庫：倉庫から西収容キャンプに移動開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_00_0000_S",			"e20020_route_MT00_00_0000", -1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_00_0000_C",			-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_00_0000_S",			"e20020_route_MT00_00_0001", -1 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_00_0000_EC",			-1, 0 )
						if( num == "Init" ) then
							commonSetTimeRouteChage(  0,												"e20020_route_MT00_00_0000_S",			"e20020_route_MT00_00_0002" )
							commonSetTimeRouteChage( 30,												"e20020_route_MT00_01_0001",			"gntn_common_d01_route0011" )
						else
							commonSetTimeRouteChage(  0,												"e20020_route_MT00_01_0001",			"gntn_common_d01_route0011" )
						end
					end
					if( num == "CheckPoint" or num == "CheckPointInit" ) then
						TppEnemy.DisableRoute( this.cpID, "gntn_common_d01_route0011" )
						TppEnemy.EnableRoute( this.cpID, "e20020_route_MT00_01_0001" )
					end
				-------------------------------------------------------------
				elseif( state == 3 ) then
					commonPrint2D("【開始】ＭＴ倉庫：西収容キャンプ巡回開始" , 1 )
					if( num == "CheckPoint" ) then
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0004" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0008" )
						if( TppMission.GetFlag( "isMT_WaitVehicleRaid_eastTent" ) == true ) then
							TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0005" )
							TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0006" )
							TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_01_0002" )
							num = "CheckPointInit"
						end
					end
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad, 	this.RouteSet_Sneak,	"e20020_route_MT00_00_0001_S",			"e20020_route_MT00_00_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_01_0000_C",			"e20020_route_MT00_00_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_00_0000_VS",			"e20020_route_MT00_00_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_01_0000_EC",			"e20020_route_MT00_00_0000_EC", 0 )
						if( num == "Init" ) then
							commonSetTimeRouteChage(  0,												"e20020_route_MT00_00_0004",			"e20020_route_MT00_00_0000_S" )
							commonSetTimeRouteChage( 20,												"gntn_common_d01_route0008",			"e20020_route_MT00_00_0004" )
						end
						if( num == "SequenceSkip" ) then
							commonSetTimeRouteChage(  0,												"e20020_route_MT00_00_0001_S",		"gntn_common_d01_route0011" )
						else
							commonSetTimeRouteChage(  0, 												"e20020_route_MT00_00_0001_S",		"e20020_route_MT00_01_0001" )
						end
					end
					-- 車両連携タイミング初期化
					TppMission.SetFlag( "isMT_WaitVehicleRaid_eastTent", false )
				-------------------------------------------------------------
				elseif( state == 4 ) then
					commonPrint2D("【開始】ＭＴ倉庫：西収容キャンプから旧収容施設へビークルで移動開始：付き添い待機中" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 1 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_00_0000_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_01_0000_VS",			"e20020_route_MT00_00_0001_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_01_0000_C",			"e20020_route_MT00_00_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_01_0001_VS",			"e20020_route_MT00_01_0002", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_01_0000_EC",			"e20020_route_MT00_00_0000_EC", 0 )
						if( num == "Init" ) then
							commonSetTimeRouteChage(  0, 												"e20020_route_MT00_00_0006",			"e20020_route_MT00_00_0001_S" )
							commonSetTimeRouteChage( 30, 												"gntn_common_d01_route0011",			"e20020_route_MT00_00_0006" )
						else
							commonSetTimeRouteChage(  0, 												"gntn_common_d01_route0011",			"e20020_route_MT00_00_0006" )
						end
					end
					if( num == "CheckPoint" ) then
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0006" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0001_S" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0011" )
					end
				-------------------------------------------------------------
				elseif( state == 5 ) then
					commonPrint2D("【開始】ＭＴ倉庫：西収容キャンプから旧収容施設へビークルで移動開始：要人待機中" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 1 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_00_0000_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_01_0000_VS",			"e20020_route_MT00_00_0005", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_01_0000_C",			"e20020_route_MT00_00_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_01_0001_VS",			"e20020_route_MT00_00_0000_VS", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_01_0000_EC",			"e20020_route_MT00_00_0000_EC", 0 )
						commonSetTimeRouteChage( 25, 													"gntn_common_d01_route0011",			"e20020_route_MT00_00_0006" )
					end
					if( num == "CheckPoint" ) then
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_00_0006" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0011" )
					end
				-------------------------------------------------------------
				elseif( state == 6 )  then
					commonPrint2D("【開始】ＭＴ倉庫：旧収容施設巡回開始" ,1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_01_0000_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_02_0000_S",			"e20020_route_MT00_01_0000_VS", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_02_0000_C",			"e20020_route_MT00_01_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_02_0001",			"e20020_route_MT00_01_0001_VS", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_02_0000_EC",			"e20020_route_MT00_01_0000_EC", 0 )
						commonSetTimeRouteChage(  0, 													"e20020_route_MT00_02_0000_S",			"gntn_common_d01_route0001" )
					end
					-- 巡回時間スタート
					if( num ~= "MTCenterDead" ) then
						TppTimer.Start( "Timer_MT_Squad_StateMove_Timer", this.Timer_MTSquad_Asylum )
					end
				-------------------------------------------------------------
				elseif( state == 7 ) then
					commonPrint2D("【開始】ＭＴ倉庫：旧収容施設からヘリポート櫓へビークル移動開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 1 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_01_0000_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_02_0000_VS",			"e20020_route_MT00_02_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_02_0000_C",			"e20020_route_MT00_01_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_02_0001_VS",			"e20020_route_MT00_02_0001", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_02_0000_EC",			"e20020_route_MT00_01_0000_EC", 0 )
						commonSetTimeRouteChage(  0, 													"gntn_common_d01_route0001",			"e20020_route_MT00_02_0000_S" )
					end
				-------------------------------------------------------------
				elseif( state == 8 ) then
					commonPrint2D("【開始】ＭＴ倉庫：ヘリポート櫓巡回開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_02_0000_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_03_0000",			"e20020_route_MT00_02_0000_VS", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_03_0000_C",			"e20020_route_MT00_02_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_03_0001",			"e20020_route_MT00_02_0001_VS", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_03_0000_EC",			"e20020_route_MT00_02_0000_EC", 0 )
					end
					-- 巡回時間スタート
					if( num ~= "MTCenterDead" ) then
						TppTimer.Start( "Timer_MT_Squad_StateMove_Timer", this.Timer_MTSquad_Heliport_WoodTurret )
					end
				-------------------------------------------------------------
				elseif( state == 9 ) then
					commonPrint2D("【開始】ＭＴ倉庫：ヘリポート櫓から倉庫櫓へビークル移動開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 1 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_02_0000_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_03_0000_VS",			"e20020_route_MT00_03_0000", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_03_0000_C",			"e20020_route_MT00_02_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_03_0001_VS",			"e20020_route_MT00_03_0001", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_03_0000_EC",			"e20020_route_MT00_02_0000_EC", 0 )
					end
				-------------------------------------------------------------
				elseif( state == 10 ) then
					commonPrint2D("【開始】ＭＴ倉庫：倉庫櫓巡回開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_03_0000_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_04_0000",			"e20020_route_MT00_03_0000_VS", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_04_0000_C",			"e20020_route_MT00_03_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_04_0001",			"e20020_route_MT00_03_0001_VS", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_04_0000_EC",			"e20020_route_MT00_03_0000_EC", 0 )
						if( num == "Init" ) then
							commonSetTimeRouteChage( 15, 												"e20020_route_MT00_04_0002",			"gntn_common_d01_route0008" )
						else
							commonSetTimeRouteChage( 0, 												"e20020_route_MT00_04_0002",			"gntn_common_d01_route0008" )
						end
					end
					-- 巡回時間スタート
					if( num ~= "MTCenterDead" ) then
						TppTimer.Start( "Timer_MT_Squad_StateMove_Timer", this.Timer_MTSquad_wareHouse_WoodTurret )
					end
					if( num == "CheckPoint" ) then
						TppEnemy.DisableRoute( this.cpID, "gntn_common_d01_route0008" )
						TppEnemy.EnableRoute( this.cpID, "e20020_route_MT00_04_0002" )
					end
				-------------------------------------------------------------
				elseif( state == 11 ) then
					commonPrint2D("【開始】ＭＴ倉庫：ヘリポート櫓から東側テントへ徒歩で移動開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 1 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_04_0000_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_04_0000_S",			"e20020_route_MT00_04_0000", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_04_0000_C",			"e20020_route_MT00_03_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_04_0000_S",			"e20020_route_MT00_04_0001", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_04_0000_EC",			"e20020_route_MT00_03_0000_EC", 0 )
					end
				-------------------------------------------------------------
				elseif( state == 12 ) then
					commonPrint2D("【開始】ＭＴ倉庫：東側テント巡回開始" , 1 )
					if( num == "CheckPoint" ) then
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0002" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0008" )
						-- 車両連携終了していた場合
						if( TppMission.GetFlag( "isMT_WaitVehicleRaid_westTent" ) == true ) then
							TppMission.SetFlag( "isMT_WaitVehicleRaid_westTent", false )
							TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0003" )
							num = "CheckPointInit"
						end
						-- 東側難民キャンプ巡回終了して場合
						if( TppMission.GetFlag( "isMT_WestTentMoveEnd" ) == true ) then
							TppMission.SetFlag( "isMT_WestTentMoveEnd", false )
							TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0002_S" )
							num = "CheckPointInit"
						end
					end
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_04_0000_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_04_0001_S",			"e20020_route_MT00_04_0000_S", -1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_04_0001_C",			"e20020_route_MT00_04_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_04_0000_VS",			"e20020_route_MT00_04_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_04_0001_EC",			"e20020_route_MT00_04_0000_EC", 0 )
						commonSetTimeRouteChage(  0, 													"e20020_route_MT00_04_0001_S",			"e20020_route_eastTent01_0002" )
						commonSetTimeRouteChage(  0, 													"e20020_route_MT00_04_0001_S",			"e20020_route_eastTent02_0002" )
						if( num ~= "CheckPointInit"  ) then
							commonSetTimeRouteChage( 30, 												"gntn_common_d01_route0008",			"e20020_route_MT00_04_0002" )
						end
					end
					-- 巡回時間スタート
					if( num ~= "MTCenterDead" ) then
						TppTimer.Start( "Timer_MT_Squad_StateMove_Timer", this.Timer_MTSquad_eastTent )
					end
					-- 東側テント巡回終了フラグオフ
					TppMission.SetFlag( "isMT_WestTentMoveEnd", false )
					-- 車両連携タイミング初期化
					TppMission.SetFlag( "isMT_WaitVehicleRaid_westTent", false )
				-------------------------------------------------------------
				elseif( state == 13 ) then
					commonPrint2D("【開始】ＭＴ倉庫：東側テントからヘリポートへビークル移動開始：付き添い待機中" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 1 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_04_0000_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_04_0001_VS",			"e20020_route_MT00_04_0002_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_04_0001_C",			"e20020_route_MT00_04_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_04_0002_VS",			"e20020_route_MT00_04_0003", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_04_0001_EC",			"e20020_route_MT00_04_0000_EC", 0 )
						if( num == "Init" ) then
							commonSetTimeRouteChage(  0, 												"e20020_route_MT00_04_0005",			"e20020_route_MT00_04_0002_S" )
							commonSetTimeRouteChage(  0, 												"e20020_route_MT00_04_0006",			"e20020_route_MT00_04_0002_S" )
							commonSetTimeRouteChage( 25, 												"e20020_route_eastTent01_0002",			"e20020_route_MT00_04_0005" )
							commonSetTimeRouteChage( 25, 												"e20020_route_eastTent02_0002",			"e20020_route_MT00_04_0006" )
						else
							commonSetTimeRouteChage(  0, 												"e20020_route_eastTent01_0002",			"e20020_route_MT00_04_0005" )
							commonSetTimeRouteChage(  0, 												"e20020_route_eastTent02_0002",			"e20020_route_MT00_04_0006" )
						end
					end
				-------------------------------------------------------------
				elseif( state == 14 ) then
					commonPrint2D("【開始】ＭＴ倉庫：東側テントからヘリポートへビークル移動開始：要人待機中" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 1 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_04_0000_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_04_0001_VS",			"e20020_route_MT00_04_0004", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_04_0001_C",			"e20020_route_MT00_04_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_04_0002_VS",			"e20020_route_MT00_04_0000_VS", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_04_0001_EC",			"e20020_route_MT00_04_0000_EC", 0 )
						commonSetTimeRouteChage( 30, 													"e20020_route_eastTent01_0002",			"e20020_route_MT00_04_0005" )
						commonSetTimeRouteChage( 30, 													"e20020_route_eastTent02_0002",			"e20020_route_MT00_04_0006" )
					end
					if( num == "CheckPoint" ) then
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0005" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT00_04_0006" )
						TppEnemy.EnableRoute( this.cpID, "e20020_route_eastTent01_0002" )
						TppEnemy.EnableRoute( this.cpID, "e20020_route_eastTent02_0002" )
					end
				-------------------------------------------------------------
				elseif( state == 15 ) then
					commonPrint2D("【開始】ＭＴ倉庫：ＭＴ管理棟と合流する為ヘリポート前で待機開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_04_0000_VSE", false )
						TppCommandPostObject.GsAddDisabledRoutes( this.cpID, "e20020_route_MT00_04_0001_VSE", false )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_05_0000",			"e20020_route_MT00_04_0001_VS", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_05_0000_C",			"e20020_route_MT00_04_0001_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_05_0001",			"e20020_route_MT00_04_0002_VS", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_05_0000_EC",			"e20020_route_MT00_04_0001_EC", 0 )
					end
					-- 巡回時間スタート
					if( num ~= "MTCenterDead" ) then
						commonPrint2D("【開始】ＭＴ倉庫：ヘリポート前で待機タイマー開始その１" )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Timer", this.Timer_MTSquad_Heliport_Conversation )
					end
				-------------------------------------------------------------
				elseif( state == 16 ) then
					commonPrint2D("【開始】ＭＴ倉庫：会話開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_06_0000",			"e20020_route_MT00_05_0000", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_05_0000_C",			"e20020_route_MT00_05_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_05_0001",			"e20020_route_MT00_04_0002_VS", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_05_0000_EC",			"e20020_route_MT00_04_0001_EC", 0 )
						-- 待機タイマーストップ
						TppTimer.Stop( "Timer_MT_Squad_StateMove_Timer" )
					end
				-------------------------------------------------------------
				elseif( state == 17 ) then
					commonPrint2D("【開始】ＭＴ倉庫：ミッション圏外へ移動開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_07_0000_VS",			"e20020_route_MT00_06_0000", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_05_0000_C",			"e20020_route_MT00_04_0001_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_07_0001_VS",			"e20020_route_MT00_05_0001", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_05_0000_EC",			"e20020_route_MT00_04_0001_EC", 0 )
					end
					if( kill == 0 )  then
						-- 任意無線設定
						commonRegisterOptionalRadioSetup( true, false )
					end
				-------------------------------------------------------------
				elseif( state == 20 ) then
					commonPrint2D("【開始】ＭＴ倉庫：ＭＴ管理棟が来ないので付き添いと会話開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_05_0000_Con",		"e20020_route_MT00_05_0000", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_05_0000_C",			"e20020_route_MT00_04_0001_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_05_0001_Con",		"e20020_route_MT00_05_0001", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_05_0000_EC",			"e20020_route_MT00_04_0001_EC", 0 )
					end
				-------------------------------------------------------------
				elseif( state == 21 ) then
					commonPrint2D("【開始】ＭＴ倉庫：ミッション圏外へ移動開始※ＭＴ管理棟なし" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Squad_AreaMarkerTimeStart( 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_07_0000_VS",			"e20020_route_MT00_05_0000_Con", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_05_0000_C",			"e20020_route_MT00_04_0001_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_07_0001_VS",			"e20020_route_MT00_05_0001_Con", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Caution,	"e20020_route_MT00_05_0000_EC",			"e20020_route_MT00_04_0001_EC", 0 )
					end
				end
			end
		-------------------------------------------------------------
		-- ＭＴ倉庫いない
		-------------------------------------------------------------
		else
			commonPrint2D("【開始】ＭＴ倉庫：死亡の為、敵兵別行動開始" , 1 )
			-- ＭＴ倉庫使用していたルート全てオフ
			commonMTSquadRouteDisable( false, true, true )
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad,		this.RouteSet_Sneak,	"e20020_route_MT00_00_0000",		-1, 0 )
			commonSetUniqueRouteChange( this.CharacterID_MT_Squad,		this.RouteSet_Caution,	"e20020_route_MT00_00_0000_C",		-1, 0 )
			commonSetUniqueRouteChange( this.CharacterID_E_Squad,		this.RouteSet_Sneak,	"e20020_route_MT00_00_0000_DE",		-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_E_Squad,		this.RouteSet_Caution,	"e20020_route_MT00_00_0000_DEC",	-1, -1 )
		end
	-- スニーク
	elseif( num == "Sneak" ) then
		if( kill == 0 )  then
			-- 移動してない場合
			if( state == 0 or state == 1 ) then
				TppMission.SetFlag( "isMT_Squad_StateMove", 2 )
			-- 西難民キャンプ付近だったら
			elseif( state == 3 or state == 4 or state == 5 ) then
				TppMission.SetFlag( "isMT_Squad_StateMove", 4 )
				-- ＭＴ倉庫ルート全初期化
				commonMTSquadRouteDisable( false, true, true )
			end
			-- 状態初期化
			TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
		else
			-- 状態初期化
			TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
		end
	-- コーション
	elseif( num == "Caution" ) then
		-- タイマー停止
		TppTimer.Stop( "Timer_MT_Squad_StateMove_Timer" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_Init" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_MarkerOn" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_MarkerOff" )
		if( kill ~= 0 )  then
			-- 状態初期化
			TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
		end
	-- キープコーション
	elseif( num == "KeepCaution" ) then
		-- タイマー停止
		TppTimer.Stop( "Timer_MT_Squad_StateMove_Timer" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_Init" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_MarkerOn" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_MarkerOff" )
		if( kill == 0 )  then
			-- 強制ルート行動開始⇒ミッション圏外へ
			commonMT_Squad_ForceRouteMode( state )
		end
	-- エヴァージョン
	elseif( num == "Evasion" ) then
		-- タイマー停止
		TppTimer.Stop( "Timer_MT_Squad_StateMove_Timer" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_Init" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_MarkerOn" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_MarkerOff" )
		if( kill ~= 0 )  then
			-- 状態初期化
			TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
		end
	-- アラート
	elseif( num == "Alert" ) then
		-- タイマー停止
		TppTimer.Stop( "Timer_MT_Squad_StateMove_Timer" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_Init" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_MarkerOn" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_MarkerOff" )
		if( kill == 0 )  then
			-- 強制ルート行動開始⇒ミッション圏外へ
			commonMT_Squad_ForceRouteMode( state )
		end
	-- トラップ
	elseif( num == "Trap" ) then
		if( kill == 0 and state == 0 and phase == "Sneak" ) then
			TppMission.SetFlag( "isMT_Squad_StateMove", 1 )
			TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
		end
	-- タイマー
	elseif( num == "Timer" ) then
		if( phase == "Sneak" ) then
			if( kill == 0 )  then
				-- 倉庫待機時間終了
				if( state == 1 ) then
					TppMission.SetFlag( "isMT_Squad_StateMove", 2 )
					TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
				-- 西難民キャンプ付き添い来るまで待機中
				elseif( state == 3 ) then
					TppMission.SetFlag( "isMT_Squad_StateMove", 5 )
					TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
				-- 旧収容施設巡回終了
				elseif( state == 6 ) then
					TppMission.SetFlag( "isMT_Squad_StateMove", 7 )
					TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					-- ＭＴ管理棟生存中ならば
					if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 ) then
						TppMission.SetFlag( "isMT_Center_StateMove", 3 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					end
				-- ヘリポート櫓巡回終了
				elseif( state == 8 ) then
					TppMission.SetFlag( "isMT_Squad_StateMove", 9 )
					TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					-- ＭＴ管理棟生存中ならば
					if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 )	then
						TppMission.SetFlag( "isMT_Center_StateMove", 5 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					end
				-- 倉庫櫓巡回終了
				elseif( state == 10 ) then
					TppMission.SetFlag( "isMT_Squad_StateMove", 11 )
					TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					-- ＭＴ管理棟生存中ならば
					if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 ) then
						TppMission.SetFlag( "isMT_Center_StateMove", 6 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					end
				-- 東難民キャンプ巡回終了
				elseif( state == 12 ) then
					if( TppMission.GetFlag( "isMT_WestTentMoveEnd" ) == false )  then
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, "e20020_route_MT00_04_0002_S",	"e20020_route_MT00_04_0001_S", 0 )
						commonSetTimeRouteChage(  0, 												"e20020_route_MT00_04_0002_S",	"e20020_route_MT00_04_0001_S" )
						commonSetTimeRouteChage(  0, 												"e20020_route_MT00_04_0002_S",	"e20020_route_MT00_04_0001_S" )
						TppMission.SetFlag( "isMT_WestTentMoveEnd", true )
					else
						-- 付き添い兵が来なかったので次へ
						TppMission.SetFlag( "isMT_Squad_StateMove", 14 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					end
				-- 管制塔前待機
				elseif( state == 15 ) then
					if( state ~= 20 ) then
						if( ( TppMission.GetFlag( "isMT_Center_StateMove" ) ~= 9 and TppMission.GetFlag( "isMT_Center_StateMove" ) ~= 10 ) or sequence == "Seq_Waiting_KillMT_Squad" ) then
							TppMission.SetFlag( "isMT_Squad_StateMove", 20 )
							TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
						else
							commonPrint2D("【開始】ＭＴ倉庫：ヘリポート前で待機タイマー開始その２" )
							TppTimer.Start( "Timer_MT_Squad_StateMove_Timer", this.Timer_MTSquad_Heliport_Conversation )
						end
					end
				end
			else
				-- ＭＴ倉庫別行動開始
				TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
			end
		end
	-- 死亡
	elseif( num == "Kill" ) then
		if( kill == 0 )  then
			TppMission.SetFlag( "isMT_SquadKill", 1 )
			-- タイマー停止
			TppTimer.Stop("Timer_MT_Squad_StateMove_Timer")
			TppTimer.Stop("Timer_MT_Squad_StateMove_Init")
			-- ＭＴ倉庫付き添い別行動開始タイマースタート
			TppTimer.Start( "Timer_MT_Squad_StateMove_Lost", this.Timer_MTSquad_DeadLost )
			-- ＭＴ管理棟別行動開始
			TppTimer.Start( "Timer_MT_Squad_StateMove_Dead", 0 )
			-- 諜報無線オフ
			TppRadio.EnableIntelRadio( this.CharacterID_MT_Squad )
			-- 強制ルート行動オフ
			this.CounterList.ForceRoute_MTSquad = "OFF"
		end
	-- 回収
	elseif( num == "Recovery" ) then
		if( kill == 0 )  then
			TppMission.SetFlag( "isMT_SquadKill", 2 )
			-- タイマー停止
			TppTimer.Stop("Timer_MT_Squad_StateMove_Timer")
			TppTimer.Stop("Timer_MT_Squad_StateMove_Init")
			-- ＭＴ倉庫付き添い別行動開始タイマースタート
			TppTimer.Start( "Timer_MT_Squad_StateMove_Lost", this.Timer_MTSquad_DeadLost )
			-- ＭＴ管理棟別行動開始
			TppTimer.Start( "Timer_MT_Squad_StateMove_Dead", 0 )
			-- 諜報無線オフ
			TppRadio.EnableIntelRadio( this.CharacterID_MT_Squad )
			-- 強制ルート行動オフ
			this.CounterList.ForceRoute_MTSquad = "OFF"
		end
	-- 敵兵のルートポイント（ＭＴ）
	elseif( num == "RoutePoint" ) then
		local routeId					= TppData.GetArgument(3)
		local routeNodeIndex			= TppData.GetArgument(1)
		-- 強制ルート行動中は更新しない
		if( this.CounterList.ForceRoute_MTSquad == "OFF" ) then
			---------------------------------------------------------------------------------------
			-- 倉庫から西難民キャンプ
			if( routeId == GsRoute.GetRouteId("e20020_route_MT00_00_0000_S") ) then
				if( routeNodeIndex >= 9 ) then
					if( state ~= 4 )  then
						TppMission.SetFlag( "isMT_Squad_StateMove", 3 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					end
				end
			-- 西側難民キャンプから待機所
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_00_0001_S") ) then
				if( routeNodeIndex >= 7 ) then
					if( TppMission.GetFlag( "isMT_WaitVehicleRaid_eastTent" ) == false )  then
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, "e20020_route_MT00_00_0005", "e20020_route_MT00_00_0001_S", 0 )
						commonSetTimeRouteChage(  0, 												"e20020_route_MT00_00_0006", "e20020_route_MT00_00_0001_S" )
						TppMission.SetFlag( "isMT_WaitVehicleRaid_eastTent", true )
						-- 待機時間スタート
						TppTimer.Start( "Timer_MT_Squad_StateMove_Timer", this.Timer_MTSquad_WaitWestTent )
					else
						-- 付き添い待機中なので次へ
						if( state ~= 4 )  then
							TppMission.SetFlag( "isMT_Squad_StateMove", 4 )
							TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
						end
					end
				end
			-- 倉庫から東難民キャンプ
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0000_S") ) then
				if( routeNodeIndex >= 8 ) then
					if( state ~= 12 )  then
						TppMission.SetFlag( "isMT_Squad_StateMove", 12 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					end
				end
			-- 東難民キャンプから東難民キャンプビークルへ
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0002_S") ) then
				if( routeNodeIndex == 3 ) then
					if( TppMission.GetFlag( "isMT_WaitVehicleRaid_westTent" ) == false )  then
						commonPrint2D("【開始】ＭＴ倉庫：東側テントビークルが来るまで待機" , 1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, "e20020_route_MT00_04_0004",	"e20020_route_MT00_04_0002_S", 0 )
						commonSetTimeRouteChage(  0, 												"e20020_route_MT00_04_0005",	"e20020_route_MT00_04_0002_S" )
						commonSetTimeRouteChage(  0, 												"e20020_route_MT00_04_0006",	"e20020_route_MT00_04_0002_S" )
						TppMission.SetFlag( "isMT_WaitVehicleRaid_westTent", true )
						-- 待機時間スタート
						TppTimer.Start( "Timer_MT_Squad_StateMove_Timer", this.Timer_MTSquad_WaitEastTent )
					else
						-- ビークル待機中ならば移動開始
						if( state ~= 13 ) then
							TppMission.SetFlag( "isMT_Squad_StateMove", 13 )
							TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
						end
					end
				end
			-- ヘリポート待機
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000") ) then
				if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 ) then
					if( routeNodeIndex == 1 ) then
						-- ＭＴ管理棟が既に到着済み
						if( TppMission.GetFlag( "isMT_Center_StateMove" ) == 10 ) then
							TppMission.SetFlag( "isMT_Squad_StateMove", 16 )
							TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
							TppMission.SetFlag( "isMT_Center_StateMove", 11 )
							TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
						end
					end
				end
			-- 管制塔前で付き添いと会話
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_Con") ) then
				if( routeNodeIndex >= 0 ) then
					if( state ~= 21 )  then
						TppMission.SetFlag( "isMT_Squad_StateMove", 21 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					end
				end
			---------------------------------------------------------------------------------------
			-- 車両失敗：西難民キャンプ～旧収容施設
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_01_0000_VSE") ) then
				-- ＭＴ管理棟移動開始
				if( routeNodeIndex >= 13 and routeNodeIndex <= 14 ) then
					-- ＭＴ管理棟生存中ならば
					if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 )	then
						if( TppMission.GetFlag( "isMT_Center_StateMove" ) == 0 )  then
							TppMission.SetFlag( "isMT_Center_StateMove", 1 )
							TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
						end
					end
				-- 旧収容施設到着
				elseif( routeNodeIndex >= 24 ) then
					if( state ~= 6 )  then
						TppMission.SetFlag( "isMT_Squad_StateMove", 6 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					end
				end
			-- 車両失敗：旧収容施設～ヘリポート
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_02_0000_VSE") ) then
				-- ヘリポート到着
				if( routeNodeIndex >= 26 ) then
					if( state ~= 8 )  then
						TppMission.SetFlag( "isMT_Squad_StateMove", 8 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					end
				end
			-- 車両失敗：ヘリポート～倉庫
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_03_0000_VSE") ) then
				-- 倉庫到着
				if( routeNodeIndex >= 17 ) then
					if( state ~= 10 )  then
						TppMission.SetFlag( "isMT_Squad_StateMove", 10 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					end
				end
			-- 車両失敗：東難民キャンプ～ヘリポート
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0001_VSE") ) then
				-- ヘリポート到着
				if( routeNodeIndex >= 13 ) then
					if( state ~= 15 )  then
						TppMission.SetFlag( "isMT_Squad_StateMove", 15 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
						-- ＭＴ管理棟生存中＆東管理棟巡回終了していたら
						if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 and TppMission.GetFlag( "isMT_Center_StateMove" ) == 8 and  TppMission.GetFlag( "isMT_Center_EastCenterMoveEnd" ) == true ) then
							TppMission.SetFlag( "isMT_Center_StateMove", 9 )
							TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
						end
					end
				end
			-- 車両失敗：ヘリポート～ミッション圏外
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_VSE") ) then
				-- ミッション圏外到着
				if( routeNodeIndex >= 8 ) then
					-- ミッション失敗
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, "NoRide", "North" )
				end
			---------------------------------------------------------------------------------------
			-- Caution ターゲットマーカーオフ処理
			-- 倉庫南：部屋の中
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_00_0000_C") ) then
				if( routeNodeIndex >= 1 ) then
					commonMissionTargetMarkerOFF( this.CharacterID_MT_Squad, true, "intel_e0020_esrg0080b_a" )
				end
			-- ヘリポート武器庫
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_03_0000_C") ) then
				if( routeNodeIndex >= 1 ) then
					commonMissionTargetMarkerOFF( this.CharacterID_MT_Squad, true, "intel_e0020_esrg0080b_b" )
				end
			-- ヘリポート武器庫
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_C") ) then
				if( routeNodeIndex >= 1 ) then
					commonMissionTargetMarkerOFF( this.CharacterID_MT_Squad, true, "intel_e0020_esrg0080b_b" )
				end
			end
		else
			---------------------------------------------------------------------------------------
			-- Alert ミッション圏外へダッシュ⇒ミッション失敗
			if( routeId == GsRoute.GetRouteId("e20020_route_MT00_00_0000_Escape") ) then
				if( routeNodeIndex >= 16 ) then
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, "NoRide", "West" )
				end
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_01_0000_Escape") ) then
				if( routeNodeIndex >= 2 ) then
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, "NoRide", "West" )
				end
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_02_0000_Escape") ) then
				if( routeNodeIndex >= 21 ) then
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, "NoRide", "West" )
				end
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_03_0000_Escape") ) then
				if( routeNodeIndex >= 11 ) then
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, "NoRide", "North" )
				end
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0000_Escape") ) then
				if( routeNodeIndex >= 12 ) then
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, "NoRide", "West" )
				end
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0001_Escape") ) then
				if( routeNodeIndex >= 3 ) then
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, "NoRide", "North" )
				end
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_Escape") ) then
				if( routeNodeIndex >= 9 ) then
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, "NoRide", "North" )
				end
			end
		end
	-- 付き添い兵のルートポイント
	elseif( num == "RoutePoint_E_Squad" ) then
		local routeId					= TppData.GetArgument(3)
		local routeNodeIndex			= TppData.GetArgument(1)
		-- 強制ルート行動中は更新しない
		if( this.CounterList.ForceRoute_MTSquad == "OFF" ) then
			-- 車両失敗：倉庫～西難民キャンプ
			if( routeId == GsRoute.GetRouteId("e20020_route_MT00_00_0000_VSE") ) then
				if( routeNodeIndex >= 5 ) then
					-- 要人が来るまで待機開始
					if( TppMission.GetFlag( "isMT_WaitVehicleRaid_eastTent" ) == false )  then
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_01_0002",	"e20020_route_MT00_00_0000_VSE", 0 )
						TppMission.SetFlag( "isMT_WaitVehicleRaid_eastTent", true )
					-- 要人待機中なので次へ
					else
						if( state ~= 5 )  then
							TppMission.SetFlag( "isMT_Squad_StateMove", 5 )
							TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
						end
					end
				end
			-- 車両失敗：倉庫～東難民キャンプ
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0000_VSE") ) then
				if( routeNodeIndex >= 12 ) then
					-- 要人が来るまで待機開始
					if( TppMission.GetFlag( "isMT_WaitVehicleRaid_westTent" ) == false )  then
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_04_0003",	"e20020_route_MT00_04_0000_VSE", 0 )
						TppMission.SetFlag( "isMT_WaitVehicleRaid_westTent", true )
					-- 要人が既に到着済みなので移動開始
					else
						if( state ~= 14 )  then
							TppMission.SetFlag( "isMT_Squad_StateMove", 14 )
							TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
						end
					end
				end
			end
		end
	-- 車両ルートポイント（ＭＴ）
	elseif( num == "VehicleRoutePoint" ) then
		local VehicleGroupInfo		= TppData.GetArgument(2)
		local vehicleCharacterId	= VehicleGroupInfo.vehicleCharacterId	
		local characterIds			= VehicleGroupInfo.memberCharacterIds
		local routeId				= VehicleGroupInfo.vehicleRouteId
		local routeNodeIndex		= VehicleGroupInfo.passedNodeIndex
		local TargetLaioOnVehicle	= false
		-- 強制ルート行動中は更新しない
		if( this.CounterList.ForceRoute_MTSquad == "OFF" ) then
			-- 倉庫～旧収容施設
			if( routeId == GsRoute.GetRouteId("e20020_route_MT00_01_0000_V") ) then
				-- ＭＴ管理棟移動開始
				if( routeNodeIndex >= 11 ) then
					-- ＭＴ管理棟生存中ならば
					if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 )	then
						if( TppMission.GetFlag( "isMT_Center_StateMove" ) == 0 )  then
							TppMission.SetFlag( "isMT_Center_StateMove", 1 )
							TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
						end
					end
				end
			-- ヘリポート～ミッション圏外
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_V") ) then
				if( routeNodeIndex >= 9 ) then
					if( kill == 0 )  then
						commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, vehicleCharacterId, "North" )
					end
				end
			end
		-- 車でミッション圏外へ
		else
			if( kill == 0 )  then
				-- 要人が車両に乗っているかチェック
				for i, memberCharacterId in ipairs( VehicleGroupInfo.memberCharacterIds ) do
					if( memberCharacterId == this.CharacterID_MT_Squad and TargetLaioOnVehicle == false ) then
						TargetLaioOnVehicle = true
					end
				end
				-- 要人が車両に乗っていたら
				if( TargetLaioOnVehicle == true ) then
					-- ルートチェンジ
					-- 倉庫～西難民キャンプ
					if( routeId == GsRoute.GetRouteId("e20020_route_MT00_00_0000_V") ) then
						-- 西ミッション圏外へ
						if( routeNodeIndex == 2 ) then
							TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID, vehicleCharacterId, "e20020_route_MT00_05_0000_V_Escape_West01", 4 )
						end
					-- 倉庫～旧収容施設
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_01_0000_V") ) then
						-- 西ミッション圏外へ
						if( routeNodeIndex == 5 ) then
							TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID, vehicleCharacterId, "e20020_route_MT00_05_0000_V_Escape_West01", 0 )
						-- 東ミッション圏外へ
						elseif( routeNodeIndex == 9 ) then
							TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID, vehicleCharacterId, "e20020_route_MT00_05_0000_V_Escape_East01", 3 )
						-- 西ミッション圏外へ
						elseif( routeNodeIndex == 16 ) then
							TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID, vehicleCharacterId, "e20020_route_MT00_05_0000_V_Escape_West02", 0 )
						end
					-- 旧収容施設～ヘリポート
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_02_0000_V") ) then
						-- 西ミッション圏外へ
						if( routeNodeIndex == 3 ) then
							TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID, vehicleCharacterId, "e20020_route_MT00_05_0000_V_Escape_West02", 4 )
						-- 東ミッション圏外へ
						elseif( routeNodeIndex == 11 ) then
							TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID, vehicleCharacterId, "e20020_route_MT00_05_0000_V_Escape_East01", 0 )
						end
					-- ヘリポート～倉庫
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_03_0000_V") ) then
						-- 東ミッション圏外へ
						if( routeNodeIndex == 2 ) then
							TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID, vehicleCharacterId, "e20020_route_MT00_05_0000_V_Escape_East01", 3 )
						-- 西ミッション圏外へ
						elseif( routeNodeIndex == 6 ) then
							TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID, vehicleCharacterId, "e20020_route_MT00_05_0000_V_Escape_West01", 1 )
						end
					-- 倉庫～東難民キャンプ
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0000_V") ) then
						if( routeNodeIndex == 3 ) then
							TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID, vehicleCharacterId, "e20020_route_MT00_05_0000_V_Escape_West01", 1 )
						end
					-- 東難民キャンプ～ヘリポート
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0001_V") ) then
						-- 東ミッション圏外へ
						if( routeNodeIndex == 6 ) then
							TppCommandPostObject.GsSetGroupVehicleRoute( this.cpID, vehicleCharacterId, "e20020_route_MT00_05_0000_V_Escape_East01", 0 )
						end
					-- ミッション失敗
					-- ヘリポート～ミッション圏外
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_V") ) then
						if( routeNodeIndex >= 9 ) then
							-- ミッション失敗
							commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, vehicleCharacterId, "North" )
						end
					-- 西ミッション圏外へ
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_V_Escape_West01") ) then
						if( routeNodeIndex >= 10 ) then
							-- ミッション失敗
							commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, vehicleCharacterId, "West" )
						end
					-- 西ミッション圏外へ
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_V_Escape_West02") ) then
						if( routeNodeIndex >= 17 ) then
							-- ミッション失敗
							commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, vehicleCharacterId, "West" )
						end
					-- 東ミッション圏外へ
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_V_Escape_East01") ) then
						if( routeNodeIndex >= 7 ) then
							-- ミッション失敗
							commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Squad, vehicleCharacterId, "North" )
						end
					end
				end
			end
		end
	-- 車両連携終了
	elseif( num == "VehicleEnd" ) then
		local VehicleGroupInfo			= TppData.GetArgument(2)
		local VehicleGroupInfoName		= VehicleGroupInfo.routeInfoName
		local vehicleCharacterId		= VehicleGroupInfo.vehicleCharacterId
		local VehicleGroupResult		= VehicleGroupInfo.result
		local VehicleGroupReason		= VehicleGroupInfo.reason
		local routeId					= VehicleGroupInfo.vehicleRouteId
		local routeNodeIndex			= VehicleGroupInfo.passedNodeIndex
		-- 強制ルート行動中は更新しない
		if( this.CounterList.ForceRoute_MTSquad == "OFF" ) then
			-- 西側難民キャンプへ
			if( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_eastTent" ) then
				if( kill == 0 ) then
					if( VehicleGroupResult == "SUCCESS" ) then
						-- 要人が来るまで待機開始
						if( TppMission.GetFlag( "isMT_WaitVehicleRaid_eastTent" ) == false )  then
							commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_01_0002",	"e20020_route_MT00_00_0000_VS", -1 )
							TppMission.SetFlag( "isMT_WaitVehicleRaid_eastTent", true )
						-- 要人待機中なので次へ
						else
							if( state ~= 5 )  then
								TppMission.SetFlag( "isMT_Squad_StateMove", 5 )
								TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
							end
						end
					else
						-- 車両連携失敗フラグオン
						TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
						-- 車両失敗
						commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 		"e20020_route_MT00_00_0000_VSE",	"e20020_route_MT00_00_0000_VS", -1 )
					end
				end
			-- 旧収容施設へ
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Asylum" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- 旧収容施設到着
					if( state ~= 6 )  then
						TppMission.SetFlag( "isMT_Squad_StateMove", 6 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					end
				else
					-- 車両連携失敗フラグオン
					TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
					-- 車両失敗
					commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
					commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,			"e20020_route_MT00_01_0000_VSE",	"e20020_route_MT00_01_0000_VS", -1 )
					commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 			"e20020_route_MT00_01_0000_VSE",	"e20020_route_MT00_01_0001_VS", -1 )
				end
			-- ヘリポートへ
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Heliport01" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ヘリポート到着
					if( state ~= 8 )  then
						TppMission.SetFlag( "isMT_Squad_StateMove", 8 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					end
				else
					-- 車両連携失敗フラグオン
					TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
					-- 車両失敗
					commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
					commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak, 			"e20020_route_MT00_02_0000_VSE", 	"e20020_route_MT00_02_0000_VS", -1 )
					commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 			"e20020_route_MT00_02_0000_VSE",	"e20020_route_MT00_02_0001_VS", -1 )
				end
			-- 倉庫へ
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_wareHouse" ) then
				-- 倉庫到着
				if( VehicleGroupResult == "SUCCESS" ) then
					if( state ~= 10 )  then
						TppMission.SetFlag( "isMT_Squad_StateMove", 10 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
					end
				else
					-- 車両連携失敗フラグオン
					TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
					-- 車両失敗
					commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
					commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak,			"e20020_route_MT00_03_0000_VSE", 	"e20020_route_MT00_03_0000_VS", -1 )
					commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 			"e20020_route_MT00_03_0000_VSE",	"e20020_route_MT00_03_0001_VS", -1 )
				end
			-- 東難民キャンプへ
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_westTent" ) then
				if( kill == 0 ) then
					-- 東難民キャンプ到着
					if( VehicleGroupResult == "SUCCESS" ) then
						-- 要人が到着してないので待機
						if( TppMission.GetFlag( "isMT_WaitVehicleRaid_westTent" ) == false )  then
							commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak,	"e20020_route_MT00_04_0003",		"e20020_route_MT00_04_0000_VS", -1 )
							TppMission.SetFlag( "isMT_WaitVehicleRaid_westTent", true )
						-- 要人が既に到着済みなので次へ
						else
							if( state ~= 14 )  then
								TppMission.SetFlag( "isMT_Squad_StateMove", 14 )
								TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
							end
						end
					else
						-- 車両連携失敗フラグオン
						TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
						-- 車両失敗
						commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,		this.RouteSet_Sneak,	"e20020_route_MT00_04_0000_VSE",	"e20020_route_MT00_04_0000_VS", -1 )
					end
				end
			-- ヘリポートへ
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Heliport02" ) then
				-- ヘリポート到着
				if( VehicleGroupResult == "SUCCESS" ) then
					if( state ~= 15 )  then
						TppMission.SetFlag( "isMT_Squad_StateMove", 15 )
						TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
						-- ＭＴ管理棟生存中＆東管理棟巡回終了していたら
						if( TppMission.GetFlag( "isMT_CenterKill" ) == 0 and TppMission.GetFlag( "isMT_Center_StateMove" ) == 8 and  TppMission.GetFlag( "isMT_Center_EastCenterMoveEnd" ) == true ) then
							TppMission.SetFlag( "isMT_Center_StateMove", 9 )
							TppTimer.Start( "Timer_MT_Center_StateMove_Init", 1 )
						end
					end
				else
					-- 車両連携失敗フラグオン
					TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
					-- 車両失敗
					commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
					commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak, "e20020_route_MT00_04_0001_VSE", 	"e20020_route_MT00_04_0001_VS", -1 )
					commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, "e20020_route_MT00_04_0001_VSE",	"e20020_route_MT00_04_0002_VS", -1 )
				end
			-- ミッション圏外
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Outside06" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない。
				else
					if( kill == 0 ) then
						commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_05_0000_VSE",	"e20020_route_MT00_07_0000_VS", -1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Squad,	this.RouteSet_Caution, 	"e20020_route_MT00_05_0000_Escape",	"e20020_route_MT00_05_0000_C", -1 )
						commonSetUniqueRouteChange( this.CharacterID_E_Squad,	this.RouteSet_Sneak, 	"e20020_route_MT00_05_0000_VSE",	"e20020_route_MT00_07_0001_VS", -1 )
						-- 車両連携失敗フラグオン
						TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
					end
				end
			end
		-- 強制ルート行動中は更新中
		else
			-- 旧収容施設へ行く途中にミッション圏外
			if( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Asylum" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない。
				else
					if( kill == 0 ) then
						commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
						if( VehicleGroupReason ~= "FAILED_TO_START" ) then
							if( routeId == GsRoute.GetRouteId("e20020_route_MT00_01_0000_V") ) then
								if( routeNodeIndex >= 10 ) then
									commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_03_0000_Escape",	"e20020_route_MT00_01_0000_Escape", -1 )
									commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_03_0000_Escape",	"e20020_route_MT00_01_0000_Escape", -1 )
									-- 車両連携失敗フラグオン
									TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
								end
							elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_V_Escape_East01") ) then
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_03_0000_Escape",	"e20020_route_MT00_01_0000_Escape", -1 )
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_03_0000_Escape",	"e20020_route_MT00_01_0000_Escape", -1 )
								-- 車両連携失敗フラグオン
								TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
							end
						end
					end
				end
			-- ヘリポートへ行く途中にミッション圏外
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Heliport01" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない。
				else
					if( kill == 0 ) then
						commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
						if( VehicleGroupReason ~= "FAILED_TO_START" ) then
							if( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_V_Escape_West02") ) then
								commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_01_0000_Escape",	"e20020_route_MT00_02_0000_Escape", -1 )
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_01_0000_Escape",	"e20020_route_MT00_02_0000_Escape", -1 )
								-- 車両連携失敗フラグオン
								TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
							else
								commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_04_0001_Escape",	"e20020_route_MT00_02_0000_Escape", -1 )
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_04_0001_Escape",	"e20020_route_MT00_02_0000_Escape", -1 )
								-- 車両連携失敗フラグオン
								TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
							end
						end
					end
				end
			-- 倉庫へ行く途中にミッション圏外
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_wareHouse" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない。
				else
					if( kill == 0 ) then
						commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
						if( VehicleGroupReason ~= "FAILED_TO_START" ) then
							if( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_V_Escape_West01") ) then
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_01_0000_Escape",	"e20020_route_MT00_03_0000_Escape", -1 )
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_01_0000_Escape",	"e20020_route_MT00_03_0000_Escape", -1 )
								-- 車両連携失敗フラグオン
								TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
							end
						end
					end
				end
			-- ミッション圏外へ
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Outside01" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない。
				else
					if( kill == 0 ) then
						if( VehicleGroupReason ~= "FAILED_TO_START" ) then
							commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
							commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_01_0000_Escape",	"e20020_route_MT00_00_0000_Escape", -1 )
							commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_01_0000_Escape",	"e20020_route_MT00_00_0000_Escape", -1 )
							-- 車両連携失敗フラグオン
							TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
						end
					end
				end
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Outside02" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない。
				else
					if( kill == 0 ) then
						if( VehicleGroupReason ~= "FAILED_TO_START" ) then
							if( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_V_Escape_West02") ) then
								commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_01_0000_Escape",	"e20020_route_MT00_02_0000_Escape", -1 )
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_01_0000_Escape",	"e20020_route_MT00_02_0000_Escape", -1 )
								-- 車両連携失敗フラグオン
								TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
							else
								commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_04_0001_Escape",	"e20020_route_MT00_02_0000_Escape", -1 )
								commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_04_0001_Escape",	"e20020_route_MT00_02_0000_Escape", -1 )
								-- 車両連携失敗フラグオン
								TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
							end
						end
					end
				end
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Outside03" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない。
				else
					if( kill == 0 ) then
						if( VehicleGroupReason ~= "FAILED_TO_START" ) then
							commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
							commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_04_0001_Escape",	"e20020_route_MT00_03_0000_Escape", -1 )
							commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_04_0001_Escape",	"e20020_route_MT00_03_0000_Escape", -1 )
							-- 車両連携失敗フラグオン
							TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
						end
					end
				end
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Outside04" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない。
				else
					if( kill == 0 ) then
						if( VehicleGroupReason ~= "FAILED_TO_START" ) then
							commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
							commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_01_0000_Escape",	"e20020_route_MT00_04_0000_Escape", -1 )
							commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_01_0000_Escape",	"e20020_route_MT00_04_0000_Escape", -1 )
							-- 車両連携失敗フラグオン
							TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
						end
					end
				end
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Outside05" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない。
				else
					if( kill == 0 ) then
						if( VehicleGroupReason ~= "FAILED_TO_START" ) then
							commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
							commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_04_0001_Escape",	"e20020_route_MT00_05_0000_Escape", -1 )
							commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_04_0001_Escape",	"e20020_route_MT00_05_0000_Escape", -1 )
							-- 車両連携失敗フラグオン
							TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
						end
					end
				end
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Outside06" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない。
				else
					if( kill == 0 ) then
						if( VehicleGroupReason ~= "FAILED_TO_START" ) then
							commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
							commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Sneak, 	"e20020_route_MT00_04_0001_Escape",	"e20020_route_MT00_05_0000_Escape", -1 )
							commonSetUniqueRouteChange( this.CharacterID_MT_Squad, this.RouteSet_Caution,	"e20020_route_MT00_04_0001_Escape",	"e20020_route_MT00_05_0000_Escape", -1 )
							-- 車両連携失敗フラグオン
							TppMission.SetFlag( "isMT_Squad_GroupVehicleFailed", true )
						end
					end
				end
			end
		end
	-- 諜報無線
	elseif( num == "Radio" ) then
		local CharacterId						= TppData.GetArgument(1)
		local aiStatus							= TppEnemyUtility.GetAiStatus( CharacterId )
		local routeId							= TppEnemyUtility.GetRouteId( CharacterId )
		local lifestatus						= TppEnemyUtility.GetLifeStatus( CharacterId )
		-- 無線ＩＤ
		local Radio_MTSquad_SniperRifle			= "e0020_esrg0060"			-- スナイパーライフル有効
		local Radio_MTSquad_BuildingEscapeOne	= "e0020_esrg0080"			-- 建物に逃げ込んだ※２人
		local Radio_MTSquad_BuildingEscapeTwo	= "e0020_esrg0081"			-- 建物に逃げ込んだ※１人
		local Radio_MTSquad_OutsideEscapeTwo	= "e0020_esrg0120"			-- 要人脱出通知※２人
		local Radio_MTSquad_OutsideEscapeOne	= "e0020_esrg0121"			-- 要人脱出通知※１人
		local Radio_MTSquad_Conversation		= "e0020_esrg0030"			-- 立ち会話
		local Radio_MTSquad_Target				= "e0020_esrg0010"			-- ターゲットついている
		local Radio_MTSquad_NoTarget			= "e0020_esrg0025"			-- ターゲットついていない
		-- 敵兵行動：会話中
		if( aiStatus == "Conversation" ) then
			-- 会話中
			TppRadio.RegisterIntelRadio( CharacterId, Radio_MTSquad_Conversation, true )
		-- 敵兵行動：それ以外
		else
			-- ターゲットマークＯＦＦ
			if( TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == false ) then
				-- ターゲットマークついてない
				TppRadio.RegisterIntelRadio( CharacterId, Radio_MTSquad_NoTarget, true )
			-- ターゲットマークＯＮ
			else
				-- ＭＴ倉庫が通常状態ならば
				if( lifestatus == "Normal" ) then
					if( routeId == GsRoute.GetRouteId("e20020_route_MT00_03_0000") or routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0000") ) then
						-- スナイパーライフル有効
						TppRadio.RegisterIntelRadio( CharacterId, Radio_MTSquad_SniperRifle, true )
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_07_0000_VS") or
							routeId == GsRoute.GetRouteId("e20020_route_MT00_00_0000_Escape") or routeId == GsRoute.GetRouteId("e20020_route_MT00_01_0000_Escape") or routeId == GsRoute.GetRouteId("e20020_route_MT00_02_0000_Escape") or
							routeId == GsRoute.GetRouteId("e20020_route_MT00_03_0000_Escape") or routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0000_Escape") or routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0001_Escape") or
							routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_Escape") ) then
						if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
							-- 要人脱出通知※２人
							TppRadio.RegisterIntelRadio( CharacterId, Radio_MTSquad_OutsideEscapeTwo, true )
						else
							-- 要人脱出通知※１人
							TppRadio.RegisterIntelRadio( CharacterId, Radio_MTSquad_OutsideEscapeOne, true )
						end
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_00_0000_C") or routeId == GsRoute.GetRouteId("e20020_route_MT00_03_0000_C") or routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0000_C") or routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_C") ) then
						-- 建物に逃げ込んだ
						TppRadio.RegisterIntelRadio( CharacterId, Radio_MTSquad_BuildingEscapeOne, true )
					else
						-- ターゲットついている
						TppRadio.RegisterIntelRadio( CharacterId, Radio_MTSquad_Target, true )
					end
				else
					-- ターゲットついている
					TppRadio.RegisterIntelRadio( CharacterId, Radio_MTSquad_Target, true )
				end
			end
		end
	-- 会話終了
	elseif( num == "ConversationEnd" ) then
		local ConversationEndCharacterID	= TppData.GetArgument(3)
		local ConversationEndName			= TppData.GetArgument(2)
		local ConversationFinsh				= TppData.GetArgument(4)
		if( ConversationEndCharacterID == this.CharacterID_MT_Squad ) then
			if( ConversationEndName == this.ConversationName_MT ) then
				commonPrint2D("ＭＴ会話終了", 2 )
			end
		end
	-- 尋問
	elseif( num == "Interrogation" ) then
		local CharacterID	= TppData.GetArgument(1)
		-- 敵兵の尋問回数を設定して全て話したフラグを初期化
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( CharacterID, 0 )
	-- それ以外
	else

	end
end

-- ■「目」強制ルート行動開始
local commonMT_Center_ForceRouteMode = function( state )
	Fox.Log( "commonMT_Center_ForceRouteMode" )
	if( this.CounterList.ForceRoute_MTCenter == "OFF" ) then
		commonPrint2D("【開始】ＭＴ管理棟：ミッション圏外へ逃げる開始" , 1 )
		-- 強制ルートフラグオン※フラグは保存されない
		this.CounterList.ForceRoute_MTCenter = "ON"
		-- 強制ルート行動オン
		TppEnemyUtility.SetForceRouteMode( this.CharacterID_MT_Center, true )
		-- ＭＴ管制塔使用していたルート全てオフ
		commonMTCenterRouteDisable( false, true )
		-- 居場所によって西or東ミッション圏外へむかう
		if( state >= 0 and state <= 7 )  then
			commonSetUniqueRouteChange( this.CharacterID_MT_Center, this.RouteSet_Sneak, 	"e20020_route_MT01_00_0000_Escape",			-1, 0 )
			commonSetUniqueRouteChange( this.CharacterID_MT_Center, this.RouteSet_Caution,	"e20020_route_MT01_00_0000_Escape",			-1, 0 )
		else
			commonSetUniqueRouteChange( this.CharacterID_MT_Center, this.RouteSet_Sneak, 	"e20020_route_MT01_01_0000_Escape",			-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_MT_Center, this.RouteSet_Caution,	"e20020_route_MT01_01_0000_Escape",			-1, -1 )
		end
	end
end

-- ■「目」エリアマーカータイム設定
local commonMT_Center_AreaMarkerTimeStart = function( num )
	if( num == 0 ) then
		TppTimer.Stop( "Timer_MT_Center_StateMove_MarkerOn" )
		TppTimer.Start( "Timer_MT_Center_StateMove_MarkerOn", this.Timer_MTCenter_AreaMarkerOn )
	else
		TppTimer.Stop( "Timer_MT_Center_StateMove_MarkerOff" )
		TppTimer.Start( "Timer_MT_Center_StateMove_MarkerOff", this.Timer_MTCenter_AreaMarkerOff )
	end
end

-- ■「目」建物の諜報無線ＯＦＦ設定
local commonMT_Center_DisableIntelRadio = function( AllDisableFlag )
	Fox.Log( "commonMT_Center_DisableIntelRadio" )
	-- 建物諜報無線がオンになってた場合はオフにする
	if( this.CounterList.IntelRadioBuilding_MTCenter == true or AllDisableFlag == true ) then
		TppRadio.DisableIntelRadio( "intel_e0020_esrg0080a_a" )
		TppRadio.DisableIntelRadio( "intel_e0020_esrg0080a_b" )
		TppRadio.DisableIntelRadio( "intel_e0020_esrg0081" )
		this.CounterList.IntelRadioBuilding_MTCenter = false
	end
end

-- ■「目」進行状態
local commonMT_Center_StateMove = function( num, manager )
		  manager		= manager or 0
	local isAlert		= false
	local setup			= false
	local sequence		= TppSequence.GetCurrentSequence()
	local phase			= TppCharacterUtility.GetCpPhaseName( this.cpID )
	local state			= TppMission.GetFlag( "isMT_Center_StateMove" )
	local kill			= TppMission.GetFlag( "isMT_CenterKill" )
	-- 設定
	if( num == "Init" or num == "CheckPoint" or num == "SequenceSkip" or num == "MTSquadDead" or num == "Lost" ) then
		-------------------------------------------------------------
		-- ＭＴ管理棟いる
		-------------------------------------------------------------
		if( kill == 0 )  then
			-- 強制ルート行動中は更新しない
			if( this.CounterList.ForceRoute_MTCenter == "OFF" ) then
				-- ＭＴ管理棟ガードターゲット設定
				if( num == "Init" ) then
					commonMTCenter_GuardTarget()
				-- コンティニュー時、アラート状態orキープコーション状態のままだったらルートを初期化を行う
				elseif( num == "CheckPoint" ) then
					if( TppMission.GetFlag( "isAlert" ) == true  or TppMission.GetFlag( "isKeepCaution" ) == true or TppMission.GetFlag( "isMT_Center_GroupVehicleFailed" ) == true )  then
						-- 強制ルート行動オフ
						TppEnemyUtility.SetForceRouteMode( this.CharacterID_MT_Center, false )
						-- 車両連携フラグ初期化
						TppMission.SetFlag( "isMT_Center_GroupVehicleFailed", false )
						-- ＭＴ管制塔使用していたルート全てオフ
						commonMTCenterRouteDisable( false, true )
						-- ルート再設定
						num = "CheckPointInit"
					end
					-- 要人Ａと要人Ｂがいる場合は同期がずれているの場合は同期させる
					if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
						-- 西難民キャンプから旧収容施設へ移動
						if( TppMission.GetFlag( "isMT_Squad_StateMove" ) == 4 or TppMission.GetFlag( "isMT_Squad_StateMove" ) == 5 ) then
							if( state ~= 0 ) then
								TppMission.SetFlag( "isMT_Center_StateMove", 0 )
								state = TppMission.GetFlag( "isMT_Center_StateMove" )
								setup = true
							end
						end
					end
				-- 巡回時間タイマー初期化
				elseif( num == "MTSquadDead" ) then
					if( state ~= 8 ) then
						TppTimer.Stop( "Timer_MT_Center_StateMove_Timer" )
					end
				end
				-------------------------------------------------------------
				if( state == 0 ) then
					commonPrint2D("【開始】ＭＴ管理棟：管理棟に待機" , 1 )
					if( num == "CheckPoint" ) then
						if( setup == true ) then
							-- ＭＴ管理棟全ルート初期化
							commonMTCenterRouteDisable( true, false )
							-- ルート再設定する
							num = "Init"
						end
					end
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonSetUniqueRouteChange( this.CharacterID_MT_Center, 	this.RouteSet_Sneak, 			"e20020_route_MT01_00_0000",		-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_00_0000_C",		-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_00_0001",		-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_00_0000_EC",		-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_00_0002",		-1, 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_00_0001_EC",		-1, 0 )
					end
					-- ＭＴ倉庫死亡後処理
					if( num == "MTSquadDead" or sequence == "Seq_Waiting_KillMT_Center" ) then
						commonPrint2D("【開始】ＭＴ管理棟：ＭＴ倉庫いないので別行動開始" , 1 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Timer", this.Timer_MTCetner_ControlTower )
					end
				-------------------------------------------------------------
				elseif( state == 1 ) then
					commonPrint2D("【開始】ＭＴ管理棟：西側管理棟から移動開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonSetUniqueRouteChange( this.CharacterID_MT_Center, 	this.RouteSet_Sneak, 			"e20020_route_MT01_01_0000_S",		"e20020_route_MT01_00_0000", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center, 	this.RouteSet_Caution,			"e20020_route_MT01_01_0000_C",		"e20020_route_MT01_00_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_01_0001_S",		"e20020_route_MT01_00_0001", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_01_0000_EC",		"e20020_route_MT01_00_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_01_0002_S",		"e20020_route_MT01_00_0002", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_01_0001_EC",		"e20020_route_MT01_00_0001_EC", 0 )
					end
				-------------------------------------------------------------
				elseif( state == 2 ) then
					commonPrint2D("【開始】ＭＴ管理棟：西側管理棟巡回開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_02_0000_S",		"e20020_route_MT01_01_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_01_0000_C",		"e20020_route_MT01_01_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_02_0000_S",		"e20020_route_MT01_01_0001_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_01_0000_EC",		"e20020_route_MT01_01_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_02_0000_S",		"e20020_route_MT01_01_0002_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_01_0001_EC",		"e20020_route_MT01_01_0001_EC", 0 )
					end
					-- ＭＴ倉庫死亡後処理
					if( num == "MTSquadDead" or sequence == "Seq_Waiting_KillMT_Center" ) then
						commonPrint2D("【開始】ＭＴ管理棟：ＭＴ倉庫いないので別行動開始" , 1 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Timer", this.Timer_MTCetner_WestCenter )
					end
				-------------------------------------------------------------
				elseif( state == 3 ) then
					commonPrint2D("【開始】ＭＴ管理棟：管理棟へ移動開始：" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_03_0000_S",		"e20020_route_MT01_02_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_00_0000_C",		"e20020_route_MT01_01_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_03_0001_S",		"e20020_route_MT01_02_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_00_0000_EC",		"e20020_route_MT01_01_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_03_0002_S",		"e20020_route_MT01_02_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_00_0000_EC",		"e20020_route_MT01_01_0001_EC", 0 )
					end
				-------------------------------------------------------------
				elseif( state == 4 ) then
					commonPrint2D("【開始】ＭＴ管理棟：管理棟巡回開始：ヘリポート櫓側" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_04_0000",		"e20020_route_MT01_03_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_00_0000_C",		"e20020_route_MT01_00_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_04_0001",		"e20020_route_MT01_03_0001_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_00_0000_EC",		"e20020_route_MT01_00_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_04_0002",		"e20020_route_MT01_03_0002_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_00_0001_EC",		"e20020_route_MT01_00_0001_EC", 0 )
					end
					-- ＭＴ倉庫死亡後処理
					if( num == "MTSquadDead" or sequence == "Seq_Waiting_KillMT_Center" ) then
						commonPrint2D("【開始】ＭＴ管理棟：ＭＴ倉庫いないので別行動開始" , 1 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Timer", this.Timer_MTCetner_ControlTower )
					end
				-------------------------------------------------------------
				elseif( state == 5 ) then
					commonPrint2D("【開始】ＭＴ管理棟：管理棟巡回開始：倉庫櫓側" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_05_0000",		"e20020_route_MT01_04_0000", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_00_0000_C",		"e20020_route_MT01_00_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_05_0001",		"e20020_route_MT01_04_0001", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_00_0000_EC",		"e20020_route_MT01_00_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_05_0002",		"e20020_route_MT01_04_0002", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_00_0001_EC",		"e20020_route_MT01_00_0001_EC", 0 )
					end
					-- ＭＴ倉庫死亡後処理
					if( num == "MTSquadDead" or sequence == "Seq_Waiting_KillMT_Center" ) then
						commonPrint2D("【開始】ＭＴ管理棟：ＭＴ倉庫いないので別行動開始" , 1 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Timer", this.Timer_MTCetner_ControlTower )
					end
				-------------------------------------------------------------
				elseif( state == 6 ) then
					commonPrint2D("【開始】ＭＴ管理棟：西側管理棟へ移動開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_06_0000_S",		"e20020_route_MT01_05_0000", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_01_0000_C",		"e20020_route_MT01_00_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_06_0001_S",		"e20020_route_MT01_05_0001", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_01_0000_EC",		"e20020_route_MT01_00_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_06_0002_S",		"e20020_route_MT01_05_0002", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_01_0001_EC",		"e20020_route_MT01_00_0001_EC", 0 )
					end
				-------------------------------------------------------------
				elseif( state == 7 ) then
					commonPrint2D("【開始】ＭＴ管理棟：ボイラー室巡回開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_07_0000_S",		"e20020_route_MT01_06_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_02_0000_C",		"e20020_route_MT01_01_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_07_0000_S",		"e20020_route_MT01_06_0001_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_02_0000_EC",		"e20020_route_MT01_01_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_07_0000_S",		"e20020_route_MT01_06_0002_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_02_0001_EC",		"e20020_route_MT01_01_0001_EC", 0 )
					end
					if( num == "CheckPoint" ) then
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0019" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0020" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center01_0000" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center02_0000" )
					end
				-------------------------------------------------------------
				elseif( state == 8 ) then
					commonPrint2D("【開始】ＭＴ管理棟：東側管理棟巡回開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_08_0000_S",		"e20020_route_MT01_07_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_03_0000_C",		"e20020_route_MT01_02_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_08_0000_S",		"e20020_route_MT01_07_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_03_0000_EC",		"e20020_route_MT01_02_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_08_0000_S",		"e20020_route_MT01_07_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_03_0001_EC",		"e20020_route_MT01_02_0001_EC", 0 )
						if( num == "Init" ) then
							-- 東側管理棟にいる敵兵をヘリポートへ移動
							commonSetTimeRouteChage( 15,															"e20020_route_MT01_08_0000",		"gntn_common_d01_route0016" )
						else
							commonSetTimeRouteChage(  0,															"e20020_route_MT01_08_0000",		"gntn_common_d01_route0016" )
						end
					end
					if( num == "CheckPoint" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						-- 西管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0019" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0020" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center01_0000" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center02_0000" )
					end
					if( num ~= "MTSquadDead" ) then
						commonPrint2D("東側管理棟巡回タイマースタート" , 0 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Timer", this.Timer_MTCetner_EastCenter )
					end
				-------------------------------------------------------------
				elseif( state == 9 ) then
					commonPrint2D("【開始】ＭＴ管理棟：ＭＴ倉庫と合流する為ヘリポート前で移動開始" , 1 )
					commonMT_Center_AreaMarkerTimeStart( 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit") then
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_09_0000_S",		"e20020_route_MT01_08_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_04_0000_C",		"e20020_route_MT01_03_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_09_0000_S",		"e20020_route_MT01_08_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_04_0000_EC",		"e20020_route_MT01_03_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_09_0000_S",		"e20020_route_MT01_08_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_04_0001_EC",		"e20020_route_MT01_03_0001_EC", 0 )
					end
					if( num == "CheckPoint" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						-- 西管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0019" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0020" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center01_0000" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center02_0000" )
						-- 東管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0016" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_08_0000" )
					end
				-------------------------------------------------------------
				elseif( state == 10 ) then
					commonPrint2D("【開始】ＭＴ管理棟：ヘリポート前で到着" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Center_AreaMarkerTimeStart( 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_10_0000",		"e20020_route_MT01_09_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_04_0000_C",		"e20020_route_MT01_04_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_10_0001",		"e20020_route_MT01_09_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_04_0000_EC",		"e20020_route_MT01_04_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_10_0002",		"e20020_route_MT01_09_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_04_0001_EC",		"e20020_route_MT01_04_0001_EC", 0 )
						if( num == "Init" ) then
							-- 東側管理棟にいる敵兵をヘリポートへ移動
							commonSetTimeRouteChage( 15,															"gntn_common_d01_route0016",		"e20020_route_MT01_08_0000" )
						else
							commonSetTimeRouteChage(  0,															"gntn_common_d01_route0016",		"e20020_route_MT01_08_0000" )
						end
					end
					if( num == "CheckPoint" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						-- 西管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0019" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0020" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center01_0000" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center02_0000" )
						-- 東管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0016" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_08_0000" )
					end
					-- ＭＴ倉庫死亡後処理
					if( num ~= "MTSquadDead" ) then
						TppTimer.Start( "Timer_MT_Center_StateMove_Timer", this.Timer_MTCenter_Heliport_Conversation )
					end
				-------------------------------------------------------------
				elseif( state == 11 ) then
					commonPrint2D("【開始】ＭＴ管理棟：会話開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Center_AreaMarkerTimeStart( 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_11_0000",		"e20020_route_MT01_10_0000", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_04_0000_C",		"e20020_route_MT01_04_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_10_0001",		"e20020_route_MT01_09_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_04_0000_EC",		"e20020_route_MT01_04_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_10_0002",		"e20020_route_MT01_09_0000_S", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_04_0001_EC",		"e20020_route_MT01_04_0001_EC", 0 )
						-- 待機タイマーストップ
						TppTimer.Stop( "Timer_MT_Center_StateMove_Timer" )
					end
					if( num == "CheckPoint" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						-- 西管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0019" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0020" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center01_0000" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center02_0000" )
						-- 東管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0016" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_08_0000" )
					end
				-------------------------------------------------------------
				elseif( state == 12 ) then
					commonPrint2D("【開始】ＭＴ管理棟：ミッション圏外へ移動開始（ビークル）" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Center_AreaMarkerTimeStart( 1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_12_0000_VS",		"e20020_route_MT01_11_0000", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_04_0000_C",		"e20020_route_MT01_04_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_12_0001_VS",		"e20020_route_MT01_10_0001", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_04_0000_EC",		"e20020_route_MT01_04_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_12_0002_VS",		"e20020_route_MT01_10_0002", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_04_0001_EC",		"e20020_route_MT01_04_0001_EC", 0 )
					end
					if( kill == 0 )  then
						-- 任意無線設定
						commonRegisterOptionalRadioSetup( true, false )
					end
					if( num == "CheckPoint" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						-- 西管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0019" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0020" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center01_0000" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center02_0000" )
						-- 東管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0016" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_08_0000" )
					end
				-------------------------------------------------------------
				elseif( state == 20 ) then
					commonPrint2D("【開始】ＭＴ管理棟：ＭＴ倉庫が来ないので付き添いと会話開始" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Center_AreaMarkerTimeStart( 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_10_0000_Con",	"e20020_route_MT01_10_0000", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_04_0000_C",		"e20020_route_MT01_04_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_10_0001_Con",	"e20020_route_MT01_10_0001", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_04_0000_EC",		"e20020_route_MT01_04_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_10_0002_Con",	"e20020_route_MT01_10_0002", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_04_0001_EC",		"e20020_route_MT01_04_0001_EC", 0 )
					end
					if( num == "CheckPoint" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						-- 西管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0019" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0020" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center01_0000" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center02_0000" )
						-- 東管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0016" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_08_0000" )
					end
				-------------------------------------------------------------
				elseif( state == 21 ) then
					commonPrint2D("【開始】ＭＴ管理棟：ミッション圏外へ移動開始※ＭＴ倉庫なし" , 1 )
					if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						commonMT_Center_AreaMarkerTimeStart( 1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,			"e20020_route_MT01_12_0000_VS",		"e20020_route_MT01_10_0000_Con", 0 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,			"e20020_route_MT01_04_0000_C",		"e20020_route_MT01_04_0000_C", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 			"e20020_route_MT01_12_0001_VS",		"e20020_route_MT01_10_0001_Con", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution,			"e20020_route_MT01_04_0000_EC",		"e20020_route_MT01_04_0000_EC", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 			"e20020_route_MT01_12_0002_VS",		"e20020_route_MT01_10_0002_Con", 0 )
						commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution,			"e20020_route_MT01_04_0001_EC",		"e20020_route_MT01_04_0001_EC", 0 )
					end
					if( num == "CheckPoint" or num == "SequenceSkip" or num == "CheckPointInit" ) then
						-- 西管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0019" )
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0020" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center01_0000" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_Center02_0000" )
						-- 東管理棟
						TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0016" )
						TppEnemy.DisableRoute( this.cpID, "e20020_route_MT01_08_0000" )
					end
				end
			end
		-------------------------------------------------------------
		-- ＭＴ管理棟いない
		-------------------------------------------------------------
		else
			commonPrint2D("【開始】ＭＴ管理棟：死亡の為、敵兵別行動開始" , 1 )
			-- ＭＴ管理棟使用していたルート全てオフ
			commonMTCenterRouteDisable( false, true )
			commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak, 		"e20020_route_MT01_00_0000",		-1, 0 )
			commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution, 		"e20020_route_MT01_00_0000_C",		-1, 0 )
			commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 		"e20020_route_MT01_00_0000_DE",		-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Caution, 		"e20020_route_MT01_00_0000_DEC",	-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Sneak, 		"e20020_route_MT01_00_0001_DE",		-1, -1 )
			commonSetUniqueRouteChange( this.CharacterID_E_Center02,	this.RouteSet_Caution, 		"e20020_route_MT01_00_0001_DEC",	-1, -1 )
		end
	-- スニーク
	elseif( num == "Sneak" ) then
		if( kill == 0 )  then
			-- タイマースタート
			TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
		else
			-- タイマースタート
			TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
		end
	-- コーション
	elseif( num == "Caution" ) then
		-- タイマー停止
		TppTimer.Stop( "Timer_MT_Center_StateMove_Timer" )
		TppTimer.Stop( "Timer_MT_Center_StateMove_Init" )
		TppTimer.Stop( "Timer_MT_Center_StateMove_MarkerOn" )
		TppTimer.Stop( "Timer_MT_Center_StateMove_MarkerOff" )
		if( kill ~= 0 )  then
			-- 状態初期化
			TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
		end
	-- キープコーション
	elseif( num == "KeepCaution" ) then
		-- タイマー停止
		TppTimer.Stop( "Timer_MT_Squad_StateMove_Timer" )
		TppTimer.Stop( "Timer_MT_Squad_StateMove_Init" )
		TppTimer.Stop( "Timer_MT_Center_StateMove_MarkerOn" )
		TppTimer.Stop( "Timer_MT_Center_StateMove_MarkerOff" )
		if( kill == 0 )  then
			-- 強制ルート行動開始⇒ミッション圏外へ
			commonMT_Center_ForceRouteMode( state )
		end
	-- エヴァージョン
	elseif( num == "Evasion" ) then
		-- タイマー停止
		TppTimer.Stop( "Timer_MT_Center_StateMove_Timer" )
		TppTimer.Stop( "Timer_MT_Center_StateMove_Init" )
		TppTimer.Stop( "Timer_MT_Center_StateMove_MarkerOn" )
		TppTimer.Stop( "Timer_MT_Center_StateMove_MarkerOff" )
		if( kill ~= 0 )  then
			-- 状態初期化
			TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
		end
	-- アラート
	elseif( num == "Alert" ) then
		-- タイマー停止
		TppTimer.Stop( "Timer_MT_Center_StateMove_Timer" )
		TppTimer.Stop( "Timer_MT_Center_StateMove_Init" )
		TppTimer.Stop( "Timer_MT_Center_StateMove_MarkerOn" )
		TppTimer.Stop( "Timer_MT_Center_StateMove_MarkerOff" )
		if( kill == 0 )  then
			-- 強制ルート行動開始⇒ミッション圏外へ
			commonMT_Center_ForceRouteMode( state )
		end
	-- トラップ
	elseif( num == "Trap" ) then
	-- タイマー
	elseif( num == "Timer" ) then
		if( phase == "Sneak" ) then
			if( kill == 0 )  then
				-- 管理棟巡回終了
				if( state == 0 )  then
					TppMission.SetFlag( "isMT_Center_StateMove", 1 )
					TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
				-- 西側管理棟巡回終了
				elseif( state == 2 )  then
					TppMission.SetFlag( "isMT_Center_StateMove", 7 )
					TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					-- ルート初期化
					commonMTCenterRouteDisable( true, false )
				-- 管理棟巡回終了
				elseif( state == 4 or state == 5 ) then
					TppMission.SetFlag( "isMT_Center_StateMove", 6 )
					TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					-- ルート初期化
					commonMTCenterRouteDisable( true, false )
				-- 東側管理棟巡回終了
				elseif( state == 8 )  then
					TppMission.SetFlag( "isMT_Center_StateMove", 9 )
					TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					-- 東側管理棟巡回終了フラグ
					TppMission.SetFlag( "isMT_Center_EastCenterMoveEnd", true )
				-- ヘリポート前で待機
				elseif( state == 10 )  then
					if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 ) then
						if( TppMission.GetFlag( "isMT_Squad_StateMove" ) == 15 ) then
							TppMission.SetFlag( "isMT_Center_StateMove", 11 )
							TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
						end
					else
						TppMission.SetFlag( "isMT_Center_StateMove", 20 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					end
				end
			end
		end
	-- 死亡
	elseif( num == "Kill" ) then
		if( kill == 0 )  then
			TppMission.SetFlag( "isMT_CenterKill", 1 )
			-- タイマー停止
			TppTimer.Stop("Timer_MT_Center_StateMove_Timer")
			TppTimer.Stop("Timer_MT_Center_StateMove_Init")
			-- ＭＴ管理棟付き添い別行動開始タイマースタート
			TppTimer.Start( "Timer_MT_Center_StateMove_Lost", this.Timer_MTCenter_DeadLost )
			-- ＭＴ管理棟別行動開始
			TppTimer.Start( "Timer_MT_Center_StateMove_Dead", 0 )
			-- 諜報無線オフ
			TppRadio.EnableIntelRadio( this.CharacterID_MT_Center )
			-- 強制ルート行動オフ
			this.CounterList.ForceRoute_MTCenter = "OFF"
		end
	-- 回収
	elseif( num == "Recovery" ) then
		if( kill == 0 )  then
			TppMission.SetFlag( "isMT_CenterKill", 2 )
			-- タイマー停止
			TppTimer.Stop("Timer_MT_Center_StateMove_Timer")
			TppTimer.Stop("Timer_MT_Center_StateMove_Init")
			-- ＭＴ管理棟付き添い別行動開始タイマースタート
			TppTimer.Start( "Timer_MT_Center_StateMove_Lost", this.Timer_MTCenter_DeadLost )
			-- ＭＴ管理棟別行動開始
			TppTimer.Start( "Timer_MT_Center_StateMove_Dead", 0 )
			-- 諜報無線オフ
			TppRadio.EnableIntelRadio( this.CharacterID_MT_Center )
			-- 強制ルート行動オフ
			this.CounterList.ForceRoute_MTCenter = "OFF"
		end
	-- ルートポイント
	elseif( num == "RoutePoint" ) then
		local routeId					= TppData.GetArgument(3)
		local routeNodeIndex			= TppData.GetArgument(1)
		-- 強制ルート行動中は更新しない
		if( this.CounterList.ForceRoute_MTCenter == "OFF" ) then
			-- Sneak---------------------------------------------------------------
			-- 西側管理棟へ
			if( routeId == GsRoute.GetRouteId("e20020_route_MT01_01_0000_S") ) then
				if( routeNodeIndex >= 7 ) then
					if( state ~= 2 )  then
						TppMission.SetFlag( "isMT_Center_StateMove", 2 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					end
				end
			-- 管理棟へ
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_03_0000_S") ) then
				if( routeNodeIndex >= 7 ) then
					if( state ~= 4 )  then
						TppMission.SetFlag( "isMT_Center_StateMove", 4 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					end
				end
			-- 西側管理棟へ
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_06_0000_S") ) then
				if( routeNodeIndex >= 7 ) then
					if( state ~= 7 )  then
						TppMission.SetFlag( "isMT_Center_StateMove", 7 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					end
				end
			-- 東側管理棟へ
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_07_0000_S") ) then
				if( routeNodeIndex == 2 ) then
					commonPrint2D("【開始】ＭＴ管理棟：西側管理棟にいる共通敵兵を共通ルートへ変更" , 1 )
					commonSetTimeRouteChage(  3, 														"gntn_common_d01_route0019",		"e20020_route_Center01_0000" )
					commonSetTimeRouteChage(  5, 														"gntn_common_d01_route0020",		"e20020_route_Center02_0000" )
				elseif( routeNodeIndex >= 13 ) then
					if( state ~= 8 )  then
						TppMission.SetFlag( "isMT_Center_StateMove", 8 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					end
				end
			-- ヘリポート到着
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_09_0000_S") ) then
				if( routeNodeIndex >= 3 ) then
					if( state ~= 10 )  then
						TppMission.SetFlag( "isMT_Center_StateMove", 10 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					end
				end
			-- 会話開始
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_10_0000") ) then
				if( routeNodeIndex == 1 ) then
					-- ＭＴ倉庫生存中
					if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 ) then
						-- ヘリポート前で待機中
						if( TppMission.GetFlag( "isMT_Squad_StateMove" ) == 15 ) then
							if( state ~= 11 )  then
								TppMission.SetFlag( "isMT_Center_StateMove", 11 )
								TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
								TppMission.SetFlag( "isMT_Squad_StateMove", 16 )
								TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 0 )
							end
						end
					end
				end
			-- ＭＴ管理棟と付き添いの会話
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_10_0000_Con") ) then
				if( routeNodeIndex >= 0 ) then
					if( state ~= 21 )  then
						TppMission.SetFlag( "isMT_Center_StateMove", 21 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
					end
				end
			-- 会話終了
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_11_0000") ) then
				if( routeNodeIndex >= 1 ) then
					if( state ~= 12 )  then
						TppMission.SetFlag( "isMT_Center_StateMove", 12 )
						TppTimer.Start( "Timer_MT_Center_StateMove_Init", 0 )
						-- ＭＴ倉庫生存中ならば
						if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 ) then
							TppMission.SetFlag( "isMT_Squad_StateMove", 17 )
							TppTimer.Start( "Timer_MT_Squad_StateMove_Init", 1 )
						end
					end
				end
			-- ミッション圏外へ
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_13_0000_S") ) then
				if( routeNodeIndex >= 10 ) then
					-- ミッション失敗
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Center, "NoRide", "North" )
				end
			---------------------------------------------------------------------------------------
			-- Caution ターゲットマーカーオフ処理
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_01_0000_C") ) then
				if( routeNodeIndex >= 1 ) then
					commonMissionTargetMarkerOFF( this.CharacterID_MT_Center, true, "intel_e0020_esrg0080a_a" )
				end
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_04_0000_C") ) then
				if( routeNodeIndex >= 1 ) then
					commonMissionTargetMarkerOFF( this.CharacterID_MT_Center, true, "intel_e0020_esrg0080a_b" )
				end
			end
		else
			---------------------------------------------------------------------------------------
			-- Alert ミッション圏外へダッシュ
			if( routeId == GsRoute.GetRouteId("e20020_route_MT01_00_0000_Escape") ) then
				if( routeNodeIndex >= 17 ) then
					-- ミッション失敗
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Center, "NoRide", "North" )
				end
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_01_0000_Escape") ) then
				if( routeNodeIndex >= 12 ) then
					-- ミッション失敗
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Center, "NoRide", "North" )
				end
			elseif( routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0001_Escape") ) then
				if( routeNodeIndex >= 3 ) then
					-- ミッション失敗
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Center, "NoRide", "North" )
				end
			end
		end
	-- 車両ルートポイント
	elseif( num == "VehicleRoutePoint" ) then
		local VehicleGroupInfo		= TppData.GetArgument(2)
		local vehicleCharacterId	= VehicleGroupInfo.vehicleCharacterId
		local characterIds			= VehicleGroupInfo.memberCharacterIds
		local routeId				= VehicleGroupInfo.vehicleRouteId
		local routeNodeIndex		= VehicleGroupInfo.passedNodeIndex
		local TargetLaioOnVehicle	= false
		-- 強制ルート行動中は更新しない
		if( this.CounterList.ForceRoute_MTCenter == "OFF" ) then
			-- Sneak ミッション圏外へ
			if( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_V") ) then
				if( routeNodeIndex >= 9 ) then
					-- ミッション失敗
					commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Center, vehicleCharacterId, "North" )
				end
			end
		else
			if( kill == 0 )  then
				-- 要人が車両に乗っているかチェック
				for i, memberCharacterId in ipairs( VehicleGroupInfo.memberCharacterIds ) do
					if( memberCharacterId == this.CharacterID_MT_Center and TargetLaioOnVehicle == false ) then
						TargetLaioOnVehicle = true
					end
				end
				-- 要人が車両に乗っていたら
				if( TargetLaioOnVehicle == true ) then
					-- ヘリポート～ミッション圏外
					if( routeId == GsRoute.GetRouteId("e20020_route_MT00_05_0000_V") ) then
						if( routeNodeIndex >= 9 ) then
							-- ミッション失敗
							commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Center, vehicleCharacterId, "North" )
						end
					-- 巨大ゲート～ミッション圏外
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_00_0000_V_Escape02") ) then
						if( routeNodeIndex >= 9 ) then
							-- ミッション失敗
							commonMissionFailedMTEscapeMissionArea( this.CharacterID_MT_Center, vehicleCharacterId, "North" )
						end
					end
				end
			end
		end
	-- 車両終了
	elseif( num == "VehicleEnd" ) then
		local VehicleGroupInfo			= TppData.GetArgument(2)
		local vehicleCharacterId		= VehicleGroupInfo.vehicleCharacterId
		local VehicleGroupInfoName		= VehicleGroupInfo.routeInfoName
		local VehicleGroupResult		= VehicleGroupInfo.result
		local VehicleGroupReason		= VehicleGroupInfo.reason
		-- 強制ルート行動中は更新しない
		if( this.CounterList.ForceRoute_MTCenter == "OFF" ) then
			-- Sneak ミッション圏外へ
			if( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Outside06" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない
				else
					commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
					commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Sneak,	"e20020_route_MT01_13_0000_S",		"e20020_route_MT01_12_0000_VS", -1 )
					commonSetUniqueRouteChange( this.CharacterID_MT_Center,		this.RouteSet_Caution,	"e20020_route_MT01_00_0000_Escape",	"e20020_route_MT01_04_0000_C", -1 )
					commonSetUniqueRouteChange( this.CharacterID_E_Center01,	this.RouteSet_Sneak, 	"e20020_route_MT01_13_0000_S",		"e20020_route_MT01_12_0001_VS", -1 )
					-- 車両連携失敗フラグ
					TppMission.SetFlag( "isMT_Center_GroupVehicleFailed", true )
				end
			end
		-- 強制ルート行動中は更新中
		else
			-- Sneak ミッション圏外へ
			if( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT00_to_Outside06" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない
				else
					commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
					if( VehicleGroupReason == "FAILED_TO_NAVIGATION" ) then
						commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center, this.RouteSet_Sneak, 	"e20020_route_MT01_00_0000_Escape",	"e20020_route_MT01_01_0000_Escape", -1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center, this.RouteSet_Caution,	"e20020_route_MT01_00_0000_Escape",	"e20020_route_MT01_01_0000_Escape", -1 )
						-- 車両連携失敗フラグ
						TppMission.SetFlag( "isMT_Center_GroupVehicleFailed", true )
					end
				end
			-- Alert ミッション圏外へ
			elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_VehicleMT01_to_Outside" ) then
				if( VehicleGroupResult == "SUCCESS" ) then
					-- ミッション失敗確定なので何もしない
				else
					if( VehicleGroupReason == "FAILED_TO_NAVIGATION" ) then
						commonPrint2D("ＭＴ車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center, this.RouteSet_Sneak, 	"e20020_route_MT01_01_0000_Escape",	"e20020_route_MT01_00_0000_Escape", -1 )
						commonSetUniqueRouteChange( this.CharacterID_MT_Center, this.RouteSet_Caution,	"e20020_route_MT01_01_0000_Escape",	"e20020_route_MT01_00_0000_Escape", -1 )
						-- 車両連携失敗フラグ
						TppMission.SetFlag( "isMT_Center_GroupVehicleFailed", true )
					end
				end
			end
		end
	-- 諜報無線
	elseif( num == "Radio" ) then
		local CharacterId						= TppData.GetArgument(1)
		local aiStatus							= TppEnemyUtility.GetAiStatus( CharacterId )
		local routeId							= TppEnemyUtility.GetRouteId( CharacterId )
		local lifestatus						= TppEnemyUtility.GetLifeStatus( CharacterId )
		-- 無線ＩＤ
		local Radio_MTCenter_SniperRifle		= "e0020_esrg0060"			-- スナイパーライフル有効
		local Radio_MTCenter_BuildingEscapeOne	= "e0020_esrg0080"			-- 建物に逃げ込んだ※２人
		local Radio_MTCenter_BuildingEscapeTwo	= "e0020_esrg0081"			-- 建物に逃げ込んだ※１人
		local Radio_MTCenter_OutsideEscapeTwo	= "e0020_esrg0120"			-- 要人脱出通知※２人
		local Radio_MTCenter_OutsideEscapeOne	= "e0020_esrg0121"			-- 要人脱出通知※１人
		local Radio_MTCenter_Conversation		= "e0020_esrg0030"			-- 立ち会話
		local Radio_MTCenter_Target				= "e0020_esrg0010"			-- ターゲットついている
		local Radio_MTCenter_NoTarget			= "e0020_esrg0025"			-- ターゲットついていない
		-- 敵兵行動：会話中
		if( aiStatus == "Conversation" ) then
			-- 会話中
			TppRadio.RegisterIntelRadio( CharacterId, Radio_MTCenter_Conversation, true )
		-- 敵兵行動：それ以外
		else
			-- ターゲットマークＯＦＦ
			if( TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == false ) then
				-- ターゲットマークついてない
				TppRadio.RegisterIntelRadio( CharacterId, Radio_MTCenter_NoTarget, true )
			-- ターゲットマークＯＮ
			else
				-- ＭＴ倉庫が通常状態ならば
				if( lifestatus == "Normal" ) then
					if( routeId == GsRoute.GetRouteId("e20020_route_MT01_00_0000") or routeId == GsRoute.GetRouteId("e20020_route_MT01_04_0000") or routeId == GsRoute.GetRouteId("e20020_route_MT01_05_0000") ) then
						-- スナイパーライフル有効
						TppRadio.RegisterIntelRadio( CharacterId, Radio_MTCenter_SniperRifle, true )
					elseif( routeId ==	GsRoute.GetRouteId("e20020_route_MT01_12_0000_VS") or routeId ==  GsRoute.GetRouteId("e20020_route_MT01_13_0000_S") ) then
						if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
							-- 要人脱出通知※２人
							TppRadio.RegisterIntelRadio( CharacterId, Radio_MTCenter_OutsideEscapeTwo, true )
						else
							-- 要人脱出通知※１人
							TppRadio.RegisterIntelRadio( CharacterId, Radio_MTCenter_OutsideEscapeOne, true )
						end
					-- 建物に逃げ込んだ
					elseif( routeId == GsRoute.GetRouteId("e20020_route_MT01_01_0000_C") or routeId == GsRoute.GetRouteId("e20020_route_MT01_02_0000_C") or routeId == GsRoute.GetRouteId("e20020_route_MT00_04_0000_C") or routeId == GsRoute.GetRouteId("e20020_route_MT01_06_0000_C") or
							routeId == GsRoute.GetRouteId("e20020_route_MT01_08_0000_C") or routeId == GsRoute.GetRouteId("e20020_route_MT01_09_0000_C") or routeId == GsRoute.GetRouteId("e20020_route_MT00_10_0000_C") or routeId == GsRoute.GetRouteId("e20020_route_MT01_11_0000_C") or
							routeId == GsRoute.GetRouteId("e20020_route_MT01_12_0000_C") or routeId == GsRoute.GetRouteId("e20020_route_MT01_13_0000_C")
							) then
						-- 建物に逃げ込んだ
						TppRadio.RegisterIntelRadio( CharacterId, Radio_MTCenter_BuildingEscapeOne, true )
					-- ターゲットマークついている
					else
						-- ターゲットついている
						TppRadio.RegisterIntelRadio( CharacterId, Radio_MTCenter_Target, true )
					end
				else
					-- ターゲットついている
					TppRadio.RegisterIntelRadio( CharacterId, Radio_MTCenter_Target, true )
				end
			end
		end
	-- 会話終了
	elseif( num == "ConversationEnd" ) then
		local ConversationEndCharacterID	= TppData.GetArgument(3)
		local ConversationEndName			= TppData.GetArgument(2)
		local ConversationFinsh				= TppData.GetArgument(4)
		if( ConversationEndCharacterID == this.CharacterID_MT_Center ) then
			if( ConversationEndName == this.ConversationName_MT ) then
				commonPrint2D("ＭＴ会話終了", 2 )
			end
		end
	-- 尋問
	elseif( num == "Interrogation" ) then
		local CharacterID	= TppData.GetArgument(1)
		-- 敵兵の尋問回数を設定して全て話したフラグを初期化
		TppEnemyUtility.SetInterrogationCountAndUnsetDoneByCharacterId( CharacterID, 0 )
	-- それ以外
	else

	end
end

-- ■「ビークル兵」進行状態
local commonEnemy_Vehicle_StateMove = function( num, manager )
		  manager		= manager or 0
	local sequence		= TppSequence.GetCurrentSequence()
	local phase			= TppCharacterUtility.GetCpPhaseName( this.cpID )
	local state			= TppMission.GetFlag( "isEnemy_Vehicle_StateMove" )
	-- 設定
	if( num == "Init" or num == "CheckPoint" or num == "SequenceSkip" ) then
		-------------------------------------------------------------
		-- コンティニュー時
		if( num == "CheckPoint" ) then
			-- ビークル兵移動開始の場合は旧収容施設に到着状態にする
			if( state == 1 ) then
				TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 2 )
				state = TppMission.GetFlag( "isEnemy_Vehicle_StateMove" )
				num = "CheckPointInit"
			end
		end
		if( state == 0 )  then
			commonPrint2D("【開始】ビークル兵待機" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				if( num == "Init" ) then
					commonEnemyVehicleRouteDisable( false, true, true )
				else
					commonEnemyVehicleRouteDisable( false, true, false )
				end
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01,		this.RouteSet_Sneak,		"e20020_route_Vehicle00_0000",			-1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01,		this.RouteSet_Caution,		"e20020_route_Vehicle00_0000",			-1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle02,		this.RouteSet_Sneak,		"e20020_route_Vehicle01_0000",			-1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle02,		this.RouteSet_Caution,		"e20020_route_Vehicle01_0000",			-1, 0 )
			end
		-------------------------------------------------------------
		elseif( state == 1 )  then
			commonPrint2D("【開始】ビークル兵移動開始" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				if( num == "Init" ) then
					commonEnemyVehicleRouteDisable( false, true, true )
				else
					commonEnemyVehicleRouteDisable( false, true, false )
				end
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01,		this.RouteSet_Sneak,		"e20020_route_Vehicle00_0000_VS",		 "e20020_route_Vehicle00_0000", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01,		this.RouteSet_Caution,		"e20020_route_Vehicle00_0000_VS",		 "e20020_route_Vehicle00_0000", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle02,		this.RouteSet_Sneak,		"e20020_route_Vehicle01_0000_VS",		 "e20020_route_Vehicle01_0000", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle02,		this.RouteSet_Caution,		"e20020_route_Vehicle01_0000_VS",		 "e20020_route_Vehicle01_0000", 0 )
			end
		-------------------------------------------------------------
		elseif( state == 2 )  then
			commonPrint2D("【開始】ビークル兵収容施設移動開始" , 1 )
			if( num == "Init" or num == "SequenceSkip" or num == "CheckPointInit" ) then
				if( num == "Init" or num == "CheckPointInit" ) then
					commonEnemyVehicleRouteDisable( false, true, true )
				else
					commonEnemyVehicleRouteDisable( false, true, false )
				end
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01,		this.RouteSet_Sneak,		"e20020_route_Vehicle00_0001",			"e20020_route_Vehicle00_0000_VS", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01,		this.RouteSet_Caution,		"e20020_route_Vehicle00_0001_C",		"e20020_route_Vehicle00_0000_VS", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle02,		this.RouteSet_Sneak,		"e20020_route_Vehicle01_0001",			"e20020_route_Vehicle01_0000_VS", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle02,		this.RouteSet_Caution,		"gntn_common_c01_route0001",			"e20020_route_Vehicle01_0000_VS", 0 )
			end
			if( num == "CheckPoint" or num == "CheckPointInit" ) then
				TppEnemy.DisableRoute( this.cpID, "gntn_common_d01_route0001" )
				TppEnemy.EnableRoute( this.cpID, "e20020_route_Asylum00_0000" )
			end
		-------------------------------------------------------------
		elseif( state == 3 )  then
			commonPrint2D("【開始】ビークル兵ミッション圏外へ移動開始" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				if( num == "Init" ) then
					commonEnemyVehicleRouteDisable( false, true, true )
				else
					commonEnemyVehicleRouteDisable( false, true, false )
					-- Sneakルート使用可能
					TppEnemy.EnableRoute( this.cpID, "e20020_route_Vehicle01_0002" )
					-- Cautionルート使用可能
					TppEnemy.EnableRoute( this.cpID, "gntn_common_c01_route0001" )
				end
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, 	this.RouteSet_Sneak,			"e20020_route_Vehicle00_0001_VS",		"e20020_route_Vehicle00_0001", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, 	this.RouteSet_Caution,			"e20020_route_Vehicle00_0001_VS",		"e20020_route_Vehicle00_0001", 0 )
			end
		-------------------------------------------------------------
		elseif( state == 4 )  then
			commonPrint2D("【開始】ビークル兵ミッション圏外へ到着（ビークル）" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				if( num == "Init" ) then
					commonEnemyVehicleRouteDisable( false, true, true )
				else
					commonEnemyVehicleRouteDisable( false, true, false )
					-- Sneakルート使用可能
					TppEnemy.EnableRoute( this.cpID, "e20020_route_Vehicle01_0002" )
					-- Cautionルート使用可能
					TppEnemy.EnableRoute( this.cpID, "gntn_common_c01_route0001" )
				end
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, 	this.RouteSet_Sneak,			 "e20020_route_Vehicle00_0000",			"e20020_route_Vehicle00_0001_VS", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, 	this.RouteSet_Caution,			 "e20020_route_Vehicle00_0000",			"e20020_route_Vehicle00_0001_VS", 0 )
			end
			-- ビークル兵表示ＯＦＦ
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Vehicle01, false )
			-- ビークル表示ＯＦＦ
			if( num == "Init" ) then
				commonDisableStateMoveVehicle( this.CounterList.VehicleEndName_Vehicle )
			else
				commonDisableStateMoveVehicle( this.VehicleID_Vehicle01 )
			end
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_EnemyDecrease )
		-------------------------------------------------------------
		elseif( state == 5 )  then
			commonPrint2D("【開始】ビークル兵ミッション圏外へ到着（徒歩）" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				if( num == "Init" ) then
					commonEnemyVehicleRouteDisable( false, true, true )
				else
					commonEnemyVehicleRouteDisable( false, true, false )
					-- Sneakルート使用可能
					TppEnemy.EnableRoute( this.cpID, "e20020_route_Vehicle01_0002" )
					-- Cautionルート使用可能
					TppEnemy.EnableRoute( this.cpID, "gntn_common_c01_route0001" )
				end
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, 	this.RouteSet_Sneak,			 "e20020_route_Vehicle00_0000",			"e20020_route_Vehicle00_0001_VS", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, 	this.RouteSet_Caution,			 "e20020_route_Vehicle00_0000",			"e20020_route_Vehicle00_0001_VS", 0 )
			end
			-- ビークル兵を表示ＯＦＦ
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Vehicle01, false )
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_EnemyDecrease )
		-------------------------------------------------------------
		elseif( state == 999 )	then
			commonPrint2D("【開始】ビークル兵強制ＯＦＦ" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				if( num == "Init" ) then
					commonEnemyVehicleRouteDisable( false, true, true )
				else
					commonEnemyVehicleRouteDisable( false, true, false )
					-- Sneakルート使用可能
					TppEnemy.EnableRoute( this.cpID, "e20020_route_Vehicle01_0002" )
					-- Cautionルート使用可能
					TppEnemy.EnableRoute( this.cpID, "gntn_common_c01_route0001" )
				end
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, 	this.RouteSet_Sneak,			"e20020_route_Vehicle00_0000",			-1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, 	this.RouteSet_Caution,			"e20020_route_Vehicle00_0000",			-1, 0 )
			end
			-- ビークル兵とビークルを表示ＯＦＦ
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Vehicle01, false )
			-- ビークル表示ＯＦＦ
			if( num == "Init" ) then
				commonDisableStateMoveVehicle( this.CounterList.VehicleEndName_Vehicle )
			else
				commonDisableStateMoveVehicle( this.VehicleID_Vehicle01 )
			end
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_EnemyDecrease )
		end
	-- スニーク
	elseif( num == "Sneak" ) then
		if( state == 2 )  then
			TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 3 )
			TppTimer.Start( "Timer_Enemy_Vehicle_StateMove_Init", 0 )
		end
	-- コーション
	elseif( num == "Caution" ) then
		if( state == 0 )  then
			TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_Vehicle_StateMove_Init", 0 )
		elseif( state == 2 )  then
			TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 3 )
			TppTimer.Start( "Timer_Enemy_Vehicle_StateMove_Init", 0 )
		end
	-- トラップ
	elseif( num == "Trap" ) then
		if( state == 0 )  then
			TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_Vehicle_StateMove_Init", 0 )
		end
	-- タイマー
	elseif( num == "Timer" ) then
	-- ルートポイント
	elseif( num == "RoutePoint" ) then
		local routeId					= TppData.GetArgument(3)
		local routeNodeIndex			= TppData.GetArgument(1)
		if( routeId == GsRoute.GetRouteId("e20020_route_Vehicle01_0001") ) then
			-- ビークル兵ミッション圏外へ
			if( routeNodeIndex == 1 ) then
				if( state ~= 3 )  then
					TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 3 )
					TppTimer.Start( "Timer_Enemy_Vehicle_StateMove_Init", 0 )
				end
			-- 会話終了後
			elseif( routeNodeIndex == 2 ) then
				-- 会話終了後にルート変更
				commonSetTimeRouteChage( 0, 	"gntn_common_d01_route0001",			"e20020_route_Asylum00_0000" )
				commonSetTimeRouteChage( 0, 	"e20020_route_Vehicle01_0002",			"e20020_route_Vehicle01_0001" )
			end
		-- 車両失敗：旧収容施設へ
		elseif( routeId == GsRoute.GetRouteId("e20020_route_Vehicle00_0000_VSE") ) then
			if( routeNodeIndex == 11 ) then
				-- 旧収容施設の敵兵を会話位置へ
				commonSetTimeRouteChage( 0, "e20020_route_Asylum00_0000", "gntn_common_d01_route0001" )
			elseif( routeNodeIndex >= 12 ) then
				if( state ~= 2 )  then
					TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 2 )
					TppTimer.Start( "Timer_Enemy_Vehicle_StateMove_Init", 0 )
				end
			end
		-- 車両失敗：旧収容施設へ
		elseif( routeId == GsRoute.GetRouteId("e20020_route_Vehicle00_0001_VSE") ) then
			if( routeNodeIndex >= 25 ) then
				if( state ~= 5 )  then
					TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 5 )
					TppTimer.Start( "Timer_Enemy_Vehicle_StateMove_Init", 0 )
				end
			end
		end
	-- 車両ルートポイント
	elseif( num == "VehicleRoutePoint" ) then
		local VehicleGroupInfo		= TppData.GetArgument(2)
		local vehicleCharacterId	= VehicleGroupInfo.vehicleCharacterId
		local characterIds			= VehicleGroupInfo.memberCharacterIds
		local routeId				= VehicleGroupInfo.vehicleRouteId
		local routeNodeIndex		= VehicleGroupInfo.passedNodeIndex
		-- 旧収容施設へ
		if( routeId == GsRoute.GetRouteId("e20020_route_EV00_00_0000_V") ) then
			if( routeNodeIndex == 5 ) then
				-- 旧収容施設の敵兵を会話位置へ
				commonSetTimeRouteChage( 0, "e20020_route_Asylum00_0000", "gntn_common_d01_route0001" )
			end
		end
	-- 車両終了
	elseif( num == "VehicleEnd" ) then
		local VehicleGroupInfo			= TppData.GetArgument(2)
		local vehicleCharacterId		= VehicleGroupInfo.vehicleCharacterId
		local characterIds				= VehicleGroupInfo.memberCharacterIds
		local VehicleGroupInfoName		= VehicleGroupInfo.routeInfoName
		local VehicleGroupResult		= VehicleGroupInfo.result
		local VehicleGroupReason		= VehicleGroupInfo.reason
		local TargetLaioOnVehicle		= false
		-- 車両連携：旧収容施設
		if( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Vehicle01_to_Asylum" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				if( state ~= 2 )  then
					-- 進行状態更新して次の進行状態へ
					TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 2 )
					TppTimer.Start( "Timer_Enemy_Vehicle_StateMove_Init", 0 )
				end
			else
				commonPrint2D("ビークル兵車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, this.RouteSet_Sneak,		"e20020_route_Vehicle00_0000_VSE",		"e20020_route_Vehicle00_0000_VS", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, this.RouteSet_Caution,	"e20020_route_Vehicle00_0000_VSE",		"e20020_route_Vehicle00_0000_VS", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle02, this.RouteSet_Sneak,		"e20020_route_Vehicle01_0000_VSE",		"e20020_route_Vehicle01_0000_VS", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle02, this.RouteSet_Caution,	"e20020_route_Vehicle01_0000_VSE",		"e20020_route_Vehicle01_0000_VS", -1 )
			end
		-- 車両連携：ミッション圏外へ
		elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Vehicle01_to_OutSide" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				-- ビークル兵が車両に乗っているかチェック
				for i, memberCharacterId in ipairs( VehicleGroupInfo.memberCharacterIds ) do
					if( memberCharacterId == this.CharacterID_E_Vehicle01 ) then
						TargetLaioOnVehicle = true
					end
				end
				if( TargetLaioOnVehicle == true ) then
					if( state ~= 4 )  then
						-- 進行状態更新して次の進行状態へ
						TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 4 )
						TppTimer.Start( "Timer_Enemy_Vehicle_StateMove_Init", 0 )
						-- 車両連携終了したビークルの名前
						this.CounterList.VehicleEndName_Vehicle = vehicleCharacterId
					end
				end
			else
				commonPrint2D("ビークル兵車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, this.RouteSet_Sneak,		"e20020_route_Vehicle00_0001_VSE",		"e20020_route_Vehicle00_0001_VS", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Vehicle01, this.RouteSet_Caution,	"e20020_route_Vehicle00_0001_VSE",		"e20020_route_Vehicle00_0001_VS", -1 )
			end
		end
	-- 死亡
	elseif( num == "Kill" ) then
	-- 諜報無線
	elseif( num == "Radio" ) then
		local CharacterId					= TppData.GetArgument(1)
		local aiStatus						= TppEnemyUtility.GetAiStatus( CharacterId )
		-- 無線ＩＤ
		local Radio_Enemy_Move				= "e0020_esrg0020"			-- 移動中
		local Radio_Enemy_Conversation		= "e0020_esrg0030"			-- 立ち会話
		-- 敵兵行動：会話中
		if( aiStatus == "Conversation" ) then
			-- 会話中
			TppRadio.RegisterIntelRadio( CharacterId, Radio_Enemy_Conversation, true )
		-- 敵兵行動：それ以外
		else
			-- 移動中
			TppRadio.RegisterIntelRadio( CharacterId, Radio_Enemy_Move, true )
		end
	-- 会話終了
	elseif( num == "ConversationEnd" ) then
		local ConversationEndCharacterID	= TppData.GetArgument(3)
		local ConversationEndName			= TppData.GetArgument(2)
		local ConversationFinsh				= TppData.GetArgument(4)
		if( ConversationEndCharacterID == this.CharacterID_E_Vehicle01 ) then
			if( ConversationEndName == this.ConversationName_Vehicle ) then
				commonPrint2D("【終了】ビークル兵会話終了" , 1 )
			end
		end
	end
end

-- ■「トラック兵」進行状態
local commonEnemy_Western01_StateMove = function( num, manager )
		  manager		= manager or 0
	local sequence		= TppSequence.GetCurrentSequence()
	local phase			= TppCharacterUtility.GetCpPhaseName( this.cpID )
	local state			= TppMission.GetFlag( "isEnemy_Western01_StateMove" )
	-- 設定
	if( num == "Init" or num == "CheckPoint" or num == "SequenceSkip" ) then
		-- コンティニュー時
		if( num == "CheckPoint" ) then
			if( TppMission.GetFlag( "isEnemy_Imitation_StateMove" ) == 2 )	then
				-- トラック兵
				TppMission.SetFlag( "isEnemy_Western01_StateMove", 2 )
				state = TppMission.GetFlag( "isEnemy_Western01_StateMove" )
				num = "Init"
			end
		end
		-------------------------------------------------------------
		if( state == 0 ) then
			commonPrint2D("【開始】トラック兵待機" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Sneak,		"e20020_route_Western00_0000",		-1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Caution,	"e20020_route_Western00_0000",		-1, 0 )
			end
		-------------------------------------------------------------
		elseif( state == 1 ) then
			commonPrint2D("【開始】トラック兵待機タイマースタート" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Sneak,		"e20020_route_Western00_0000",		-1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Caution,	"e20020_route_Western00_0000",		-1, 0 )
			end
			-- 待機タイマー開始
			TppTimer.Start( "Timer_Enemy_Western01_StateMove_Timer", this.Timer_EnemyWestern_MoveStart )
		-------------------------------------------------------------
		elseif( state == 2 ) then
			commonPrint2D("【開始】トラック兵会話開始" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyWestern01RouteDisable()
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Sneak,		"e20020_route_Western00_0001",		"e20020_route_Western00_0000", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Caution,	"e20020_route_Western00_0001",		"e20020_route_Western00_0000", 0 )
			end
		-------------------------------------------------------------
		elseif( state == 3 ) then
			commonPrint2D("【開始】トラック兵ミッショ圏外へ移動開始（会話あり）" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyWestern01RouteDisable()
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Sneak,		"e20020_route_Western00_0002_VS01",	"e20020_route_Western00_0001", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Caution,	"e20020_route_Western00_0002_VS01",	"e20020_route_Western00_0001", 0 )
			end
		-------------------------------------------------------------
		elseif( state == 4 ) then
			commonPrint2D("【開始】トラック兵ミッショ圏外へ移動開始（会話なし）" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyWestern01RouteDisable()
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Sneak,		"e20020_route_Western00_0002_VS02",	"e20020_route_Western00_0000", 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Caution,	"e20020_route_Western00_0002_VS02",	"e20020_route_Western00_0000", 0 )
			end
		-------------------------------------------------------------
		elseif( state == 5 ) then
			commonPrint2D("【開始】トラック兵ミッション圏外へ到着" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyWestern01RouteDisable()
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Sneak,		"e20020_route_Western00_0002_VS01",	-1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Caution,	"e20020_route_Western00_0002_VS01",	-1, 0 )
			end
			-- トラック兵表示ＯＦＦ
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Western01, false )
			-- トラック表示ＯＦＦ
			if( num == "Init" ) then
				commonDisableStateMoveVehicle( this.CounterList.VehicleEndName_Western )
			else
				commonDisableStateMoveVehicle( this.VehicleID_Western02 )
			end
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_EnemyDecrease )
		-------------------------------------------------------------
		elseif( state == 6 ) then
			commonPrint2D("【開始】トラック兵ミッション圏外へ到着（徒歩）" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyWestern01RouteDisable()
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Sneak,		"e20020_route_Western00_0002_VS01",	-1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Caution,	"e20020_route_Western00_0002_VS01",	-1, 0 )
			end
			-- トラック兵ＯＦＦ
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Western01, false )
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_EnemyDecrease )
		-------------------------------------------------------------
		elseif( state == 999 ) then
			commonPrint2D("【開始】トラック兵強制ＯＦＦ" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyWestern01RouteDisable()
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Sneak,		"e20020_route_Western00_0002_VS01",	-1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Caution,	"e20020_route_Western00_0002_VS01",	-1, 0 )
			end
			-- トラック兵表示ＯＦＦ
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Western01, false )
			-- トラック表示ＯＦＦ
			if( num == "Init" ) then
				commonDisableStateMoveVehicle( this.CounterList.VehicleEndName_Western )
			else
				commonDisableStateMoveVehicle( this.VehicleID_Western02 )
			end
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_EnemyDecrease )
		end
	-- スニーク
	elseif( num == "Sneak" ) then
		if( state == 0 )  then
			TppMission.SetFlag( "isEnemy_Western01_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_Western01_StateMove_Init", 0 )
		elseif( state == 2 )  then
			TppMission.SetFlag( "isEnemy_Western01_StateMove", 3 )
			TppTimer.Start( "Timer_Enemy_Western01_StateMove_Init", 0 )
		end
	-- コーション
	elseif( num == "Caution" ) then
		if( state == 0 )  then
			TppMission.SetFlag( "isEnemy_Western01_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_Western01_StateMove_Init", 0 )
		elseif( state == 2 )  then
			TppMission.SetFlag( "isEnemy_Western01_StateMove", 3 )
			TppTimer.Start( "Timer_Enemy_Western01_StateMove_Init", 0 )
		end
	-- トラップ
	elseif( num == "Trap" ) then
		if( state == 0 )  then
			TppMission.SetFlag( "isEnemy_Western01_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_Western01_StateMove_Init", 0 )
		end
	-- タイマー
	elseif( num == "Timer" ) then
		local lifestatus	= TppEnemyUtility.GetLifeStatus( this.CharacterID_E_Imitation )
		local status		= TppEnemyUtility.GetStatus( this.CharacterID_E_Imitation )
		commonPrint2D("トラック付き添い兵のステータス : lifestatus :"..lifestatus )
		commonPrint2D("トラック付き添い兵のステータス : status     :"..status )
		if( lifestatus ~= "Normal" or status ~= "Normal" ) then
			if( state == 1 )  then
				TppMission.SetFlag( "isEnemy_Western01_StateMove", 4 )
				TppTimer.Start( "Timer_Enemy_Western01_StateMove_Init", 0 )
			end
		else
			-- 待機タイマー開始
			TppTimer.Start( "Timer_Enemy_Western01_StateMove_Timer", this.Timer_EnemyWestern_MoveStart )
		end
	-- ルートポイント
	elseif( num == "RoutePoint" ) then
		local routeId					= TppData.GetArgument(3)
		local routeNodeIndex			= TppData.GetArgument(1)
		-- 車両失敗
		if( routeId == GsRoute.GetRouteId("e20020_route_Western00_0002_VSE") ) then
			if( routeNodeIndex >= 5 ) then
				if( state ~= 6 )  then
					TppMission.SetFlag( "isEnemy_Western01_StateMove", 6 )
					TppTimer.Start( "Timer_Enemy_Western01_StateMove_Init", 0 )
				end
			end
		end
	-- 車両終了
	elseif( num == "VehicleEnd" ) then
		local VehicleGroupInfo			= TppData.GetArgument(2)
		local vehicleCharacterId		= VehicleGroupInfo.vehicleCharacterId
		local characterIds				= VehicleGroupInfo.memberCharacterIds
		local VehicleGroupInfoName		= VehicleGroupInfo.routeInfoName
		local VehicleGroupResult		= VehicleGroupInfo.result
		local VehicleGroupReason		= VehicleGroupInfo.reason
		local TargetLaioOnVehicle		= false
		-- 車両連携：ミッション圏外へ：２人乗り
		if( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Western01_to_OutSide" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				-- トラック兵が車両に乗っているかチェック
				for i, memberCharacterId in ipairs( VehicleGroupInfo.memberCharacterIds ) do
					if( memberCharacterId == this.CharacterID_E_Western01 ) then
						TargetLaioOnVehicle = true
					end
				end
				if( TargetLaioOnVehicle == true ) then
					if( state ~= 5 )  then
						-- 進行状態更新して次の進行状態へ
						TppMission.SetFlag( "isEnemy_Western01_StateMove", 5 )
						TppTimer.Start( "Timer_Enemy_Western01_StateMove_Init", 0 )
						-- 車両連携終了したトラックの名前
						this.CounterList.VehicleEndName_Western = vehicleCharacterId
					end
				end
			else
				if( state == 3 ) then
					commonPrint2D("トラック兵車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
					commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Sneak,		"e20020_route_Western00_0002_VSE",	"e20020_route_Western00_0002_VS01", -1 )
					commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Caution,	"e20020_route_Western00_0002_VSE",	"e20020_route_Western00_0002_VS01", -1 )
				end
			end
		-- 車両連携：ミッション圏外へ：１人乗り
		elseif( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Western01_to_OutSideOnly" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				-- トラック兵が車両に乗っているかチェック
				for i, memberCharacterId in ipairs( VehicleGroupInfo.memberCharacterIds ) do
					if( memberCharacterId == this.CharacterID_E_Western01 ) then
						TargetLaioOnVehicle = true
					end
				end
				if( TargetLaioOnVehicle == true ) then
					if( state ~= 5 )  then
						-- 進行状態更新して次の進行状態へ
						TppMission.SetFlag( "isEnemy_Western01_StateMove", 5 )
						TppTimer.Start( "Timer_Enemy_Western01_StateMove_Init", 0 )
						-- 車両連携終了したトラックの名前
						this.CounterList.VehicleEndName_Western = vehicleCharacterId
					end
				end
			else
				if( state == 4 ) then
					commonPrint2D("トラック兵車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
					commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Sneak,		"e20020_route_Western00_0002_VSE",	"e20020_route_Western00_0002_VS02", -1 )
					commonSetUniqueRouteChange( this.CharacterID_E_Western01, this.RouteSet_Caution,	"e20020_route_Western00_0002_VSE",	"e20020_route_Western00_0002_VS02", -1 )
				end
			end
		end
	-- 死亡
	elseif( num == "Kill" ) then
	-- 諜報無線
	elseif( num == "Radio" ) then
		local CharacterId					= TppData.GetArgument(1)
		local aiStatus						= TppEnemyUtility.GetAiStatus( CharacterId )
		-- 無線ＩＤ
		local Radio_Enemy_Move				= "e0020_esrg0020"			-- 移動中
		local Radio_Enemy_Conversation		= "e0020_esrg0030"			-- 立ち会話
		-- 敵兵行動：会話中
		if( aiStatus == "Conversation" ) then
			-- 会話中
			TppRadio.RegisterIntelRadio( CharacterId, Radio_Enemy_Conversation, true )
		-- 敵兵行動：それ以外
		else
			-- 移動中
			TppRadio.RegisterIntelRadio( CharacterId, Radio_Enemy_Move, true )
		end
	-- 会話終了
	elseif( num == "ConversationEnd" ) then
		local ConversationEndCharacterID	= TppData.GetArgument(3)
		local ConversationEndName			= TppData.GetArgument(2)
		local ConversationFinsh				= TppData.GetArgument(4)
		if( ConversationEndCharacterID == this.CharacterID_E_Western01 ) then
			if( ConversationEndName == this.ConversationName_Western ) then
				commonPrint2D("【終了】トラック兵会話終了" , 1 )
				-- 立ち話を最後まで正常に終えた
				if( ConversationFinsh == true ) then
					-- トラックの諜報無線ＯＦＦ
					if( TppMission.GetFlag( "isIntelRadio_Western" ) == false and TppMission.GetFlag( "isPlayerGetTruckSniper" ) == false )  then
						-- 会話
						TppMission.SetFlag( "isIntelRadio_Western", true )
						-- トラックの諜報無線変更
						TppRadio.RegisterIntelRadio( this.VehicleID_Western02, "f0090_esrg0050", true )
					end
				end
			end
		end
	-- それ以外
	else

	end
end

-- ■「トラック付き添い兵」進行状態
local commonEnemy_Imitation_StateMove = function( num, manager )
		  manager		= manager or 0
	local sequence		= TppSequence.GetCurrentSequence()
	local phase			= TppCharacterUtility.GetCpPhaseName( this.cpID )
	local state			= TppMission.GetFlag( "isEnemy_Imitation_StateMove" )
	-- 設定
	if( num == "Init" or num == "CheckPoint" or num == "SequenceSkip" ) then
		-- コンティニュー時
		if( num == "CheckPoint" ) then
			-- トラック付き添い兵移動開始の場合は会話開始状態にする
			if( state == 1 ) then
				-- トラック付き添い兵
				TppMission.SetFlag( "isEnemy_Imitation_StateMove", 2 )
				state = TppMission.GetFlag( "isEnemy_Imitation_StateMove" )
				num = "Init"
			end
		end
		-------------------------------------------------------------
		if( state == 0 ) then
			commonPrint2D("【開始】待ち合わせ兵待機" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyImitationRouteDisable( false, true )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Sneak,			"e20020_route_Imitation00_0000", -1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Caution,		"e20020_route_Imitation00_0000", -1, 0 )
			end
		-------------------------------------------------------------
		elseif( state == 1 ) then
			commonPrint2D("【開始】待ち合わせ兵移動開始" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyImitationRouteDisable( false, true )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Sneak,			"e20020_route_Imitation00_0001", -1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Caution,		"e20020_route_Imitation00_0001", -1, 0 )
			end
		-------------------------------------------------------------
		elseif( state == 2 ) then
			commonPrint2D("【開始】待ち合わせ兵会話開始" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyImitationRouteDisable( false, true )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Sneak,			"e20020_route_Imitation00_0002", -1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Caution,		"e20020_route_Imitation00_0002", -1, 0 )
			end
		-------------------------------------------------------------
		elseif( state == 3 ) then
			commonPrint2D("【開始】トラック兵がいないので移動開始" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyImitationRouteDisable( false, true )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Sneak,			"e20020_route_Imitation00_0003_VSE", -1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Caution,		"e20020_route_Imitation00_0003_VSE", -1, 0 )
			end
		-------------------------------------------------------------
		elseif( state == 4 ) then
			commonPrint2D("【開始】待ち合わせ兵トラック移動開始" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyImitationRouteDisable( false, true )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Sneak,			"e20020_route_Imitation00_0003_VS", -1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Caution,		"e20020_route_Imitation00_0003_VS", -1, 0 )
			end
		-------------------------------------------------------------
		elseif( state == 5 ) then
			commonPrint2D("【開始】待ち合わせ兵ミッション圏外（トラック）" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyImitationRouteDisable( false, true )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Sneak,			"e20020_route_Imitation00_0003_VS", -1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Caution,		"e20020_route_Imitation00_0003_VS", -1, 0 )
			end
			-- トラック付き添い兵表示ＯＦＦ
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Imitation, false )
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_EnemyDecrease )
		-------------------------------------------------------------
		elseif( state == 999 ) then
			commonPrint2D("【開始】待ち合わせ兵強制ＯＦＦ" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonEnemyImitationRouteDisable( false, true )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Sneak,			"e20020_route_Imitation00_0003_VS", -1, 0 )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Caution,		"e20020_route_Imitation00_0003_VS", -1, 0 )
			end
			-- トラック付き添い兵表示ＯＦＦ
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Imitation, false )
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_EnemyDecrease )
		end
	-- スニーク
	elseif( num == "Sneak" ) then
		if( state == 0 or state == 1 ) then
			TppMission.SetFlag( "isEnemy_Imitation_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_Imitation_StateMove_Init", 0 )
		elseif( state == 2 )  then
			TppMission.SetFlag( "isEnemy_Imitation_StateMove", 3 )
			TppTimer.Start( "Timer_Enemy_Imitation_StateMove_Init", 0 )
		end
	-- コーション
	elseif( num == "Caution" ) then
		if( state == 0 or state == 1 ) then
			TppMission.SetFlag( "isEnemy_Imitation_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_Imitation_StateMove_Init", 0 )
		elseif( state == 2 )  then
			TppMission.SetFlag( "isEnemy_Imitation_StateMove", 3 )
			TppTimer.Start( "Timer_Enemy_Imitation_StateMove_Init", 0 )
		end
	-- トラップ
	elseif( num == "Trap" ) then
		if( state == 0 )  then
			TppMission.SetFlag( "isEnemy_Imitation_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_Imitation_StateMove_Init", 0 )
		end
	-- タイマー
	elseif( num == "Timer" ) then
	-- ルートポイント
	elseif( num == "RoutePoint" ) then
		local routeId					= TppData.GetArgument(3)
		local routeNodeIndex			= TppData.GetArgument(1)
		-- トラック兵の所へ移動開始
		if( routeId == GsRoute.GetRouteId("e20020_route_Imitation00_0001") ) then
			if( routeNodeIndex == 7 ) then
				if( TppMission.GetFlag( "isEnemy_Western01_StateMove" ) >= 4 ) then
					-- トラック兵いないのでその付近を移動開始
					TppMission.SetFlag( "isEnemy_Imitation_StateMove", 3 )
					TppTimer.Start( "Timer_Enemy_Imitation_StateMove_Init", 0 )
				else
					-- トラック兵移動開始
					if( TppMission.GetFlag( "isEnemy_Western01_StateMove" ) ~= 2 ) then
						TppMission.SetFlag( "isEnemy_Western01_StateMove", 2 )
						TppTimer.Start( "Timer_Enemy_Western01_StateMove_Init", 0 )
					end
				end
			elseif( routeNodeIndex == 9 ) then
				local lifestatus	= TppEnemyUtility.GetLifeStatus( this.CharacterID_E_Western01 )
				local status		= TppEnemyUtility.GetStatus( this.CharacterID_E_Western01 )
				commonPrint2D("トラック兵のステータス : lifestatus :"..lifestatus )
				commonPrint2D("トラック兵のステータス : status     :"..status )
				if( lifestatus == "Normal" and status == "Normal" ) then
					if( state ~= 2 )  then
						TppMission.SetFlag( "isEnemy_Imitation_StateMove", 2 )
						TppTimer.Start( "Timer_Enemy_Imitation_StateMove_Init", 0 )
					end
				else
					if( state ~= 3 )  then
						TppMission.SetFlag( "isEnemy_Imitation_StateMove", 3 )
						TppTimer.Start( "Timer_Enemy_Imitation_StateMove_Init", 0 )
					end
				end
			end
		-- 会話
		elseif( routeId == GsRoute.GetRouteId("e20020_route_Imitation00_0002") ) then
			if( routeNodeIndex >= 1 ) then
				-- ミッション圏外へ
				if( state ~= 4 and TppMission.GetFlag( "isEnemy_Western01_StateMove" ) ~= 3 )  then
					TppMission.SetFlag( "isEnemy_Imitation_StateMove", 4 )
					TppTimer.Start( "Timer_Enemy_Imitation_StateMove_Init", 0 )
					TppMission.SetFlag( "isEnemy_Western01_StateMove", 3 )
					TppTimer.Start( "Timer_Enemy_Western01_StateMove_Init", 0 )
				end
			end
		end
	-- 車両終了
	elseif( num == "VehicleEnd" ) then
		local VehicleGroupInfo			= TppData.GetArgument(2)
		local vehicleCharacterId		= VehicleGroupInfo.vehicleCharacterId
		local characterIds				= VehicleGroupInfo.memberCharacterIds
		local VehicleGroupInfoName		= VehicleGroupInfo.routeInfoName
		local VehicleGroupResult		= VehicleGroupInfo.result
		local VehicleGroupReason		= VehicleGroupInfo.reason
		local TargetLaioOnVehicle		= false
		if( VehicleGroupInfoName == "TppGroupVehicleRouteInfo_Western01_to_OutSide" ) then
			if( VehicleGroupResult == "SUCCESS" ) then
				-- トラック付き添い兵が車両に乗っているかチェック
				for i, memberCharacterId in ipairs( VehicleGroupInfo.memberCharacterIds ) do
					if( memberCharacterId == this.CharacterID_E_Imitation ) then
						TargetLaioOnVehicle = true
					end
				end
				if( TargetLaioOnVehicle == true ) then
					if( state == 4 and state ~= 5 )  then
						TppMission.SetFlag( "isEnemy_Imitation_StateMove", 5 )
						TppTimer.Start( "Timer_Enemy_Imitation_StateMove_Init", 0 )
					end
				end
			else
				commonPrint2D("トラック付き添い兵車両失敗"..VehicleGroupInfoName..":"..VehicleGroupReason.. ":", 1 )
				commonEnemyImitationRouteDisable( false, true )
				commonSetUniqueRouteChange( this.CharacterID_E_Imitation, this.RouteSet_Sneak,	"e20020_route_Imitation00_0003_VSE", -1, -1 )
			end
		end
	-- 諜報無線
	elseif( num == "Radio" ) then
		local CharacterId					= TppData.GetArgument(1)
		local aiStatus						= TppEnemyUtility.GetAiStatus( CharacterId )
		-- 無線ＩＤ
		local Radio_Enemy_Move				= "e0020_esrg0020"			-- 移動中
		local Radio_Enemy_Conversation		= "e0020_esrg0030"			-- 立ち会話
		-- 敵兵行動：会話中
		if( aiStatus == "Conversation" ) then
			-- 会話中
			TppRadio.RegisterIntelRadio( CharacterId, Radio_Enemy_Conversation, true )
		-- 敵兵行動：それ以外
		else
			-- 移動中
			TppRadio.RegisterIntelRadio( CharacterId, Radio_Enemy_Move, true )
		end
	-- 会話終了
	elseif( num == "ConversationEnd" ) then
		local ConversationEndCharacterID	= TppData.GetArgument(3)
		local ConversationEndName			= TppData.GetArgument(2)
		local ConversationFinsh				= TppData.GetArgument(4)
		if( ConversationEndCharacterID == this.CharacterID_E_Imitation ) then
			if( ConversationEndName == this.ConversationName_Western ) then
				commonPrint2D("【終了】トラック兵会話終了" , 1 )
				-- 立ち話を最後まで正常に終えた
				if( ConversationFinsh == true ) then
					-- トラックの諜報無線ＯＦＦ
					if( TppMission.GetFlag( "isIntelRadio_Western" ) == false and TppMission.GetFlag( "isPlayerGetTruckSniper" ) == false )  then
						-- 会話
						TppMission.SetFlag( "isIntelRadio_Western", true )
						-- トラックの諜報無線変更
						TppRadio.RegisterIntelRadio( this.VehicleID_Western02, "f0090_esrg0050", true )
					end
				end
			end
		end
	-- それ以外
	else

	end
end

-- ■「東難民キャンプ敵兵０１」進行状態
local commonEnemy_eastTent01_StateMove = function( num, manager )
		  manager		= manager or 0
	local sequence		= TppSequence.GetCurrentSequence()
	local phase			= TppCharacterUtility.GetCpPhaseName( this.cpID )
	local state			= TppMission.GetFlag( "isEnemy_eastTent01_StateMove" )
	-- 設定
	if( num == "Init" or num == "CheckPoint" or num == "SequenceSkip" ) then
		if( state == 0 )  then
			commonPrint2D("【開始】東難民キャンプ敵兵（海岸）待機" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonSetUniqueRouteChange( this.CharacterID_E_eastTentNorth01, this.RouteSet_Sneak,			"e20020_route_eastTent01_0000", -1, 0 )
			end
		elseif( state == 1 )  then
			commonPrint2D("【開始】東難民キャンプ敵兵（海岸）移動開始" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonSetUniqueRouteChange( this.CharacterID_E_eastTentNorth01, this.RouteSet_Sneak,			"e20020_route_eastTent01_0001", "e20020_route_eastTent01_0000", 0 )
			end
		elseif( state == 2 )  then
			commonPrint2D("【開始】東難民キャンプ敵兵（海岸）移動到着" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonSetUniqueRouteChange( this.CharacterID_E_eastTentNorth01, this.RouteSet_Sneak,			"e20020_route_eastTent01_0002", "e20020_route_eastTent01_0001", 0 )
			end
		end
	-- スニーク
	elseif( num == "Sneak" ) then
	-- コーション
	elseif( num == "Caution" ) then
		if( state == 0 )  then
			TppMission.SetFlag( "isEnemy_eastTent01_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_eastTent01_StateMove_Init", 0 )
		end
	-- トラップ
	elseif( num == "Trap" ) then
		if( state == 0 )  then
			TppMission.SetFlag( "isEnemy_eastTent01_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_eastTent01_StateMove_Init", 0 )
		end
	-- タイマー
	elseif( num == "Timer" ) then
	-- ルートポイント
	elseif( num == "RoutePoint" ) then
		local routeId					= TppData.GetArgument(3)
		local routeNodeIndex			= TppData.GetArgument(1)
		-- スタート崖の方から
		if( routeId == GsRoute.GetRouteId("e20020_route_eastTent01_0001") ) then
			if( routeNodeIndex >= 9 ) then
				if( state ~= 2 ) then
					TppMission.SetFlag( "isEnemy_eastTent01_StateMove", 2 )
					TppTimer.Start( "Timer_Enemy_eastTent01_StateMove_Init", 0 )
				end
			end
		end
	-- 車両終了
	elseif( num == "VehicleEnd" ) then
	-- 死亡
	elseif( num == "Kill" ) then
	-- 会話終了
	elseif( num == "ConversationEnd" ) then
	-- それ以外
	else

	end
end

-- ■「東難民キャンプ敵兵０２」進行状態
local commonEnemy_eastTent02_StateMove = function( num, manager )
		  manager		= manager or 0
	local sequence		= TppSequence.GetCurrentSequence()
	local phase			= TppCharacterUtility.GetCpPhaseName( this.cpID )
	local state			= TppMission.GetFlag( "isEnemy_eastTent02_StateMove" )
	-- 設定
	if( num == "Init" or num == "CheckPoint" or num == "SequenceSkip" ) then
		if( state == 0 )  then
			commonPrint2D("【開始】東難民キャンプ敵兵（倉庫）待機" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonSetUniqueRouteChange( this.CharacterID_E_eastTentNorth02, this.RouteSet_Sneak,			"e20020_route_eastTent02_0000", -1, 0 )
			end
		elseif( state == 1 )  then
			commonPrint2D("【開始】東難民キャンプ敵兵（倉庫）移動開始" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonSetUniqueRouteChange( this.CharacterID_E_eastTentNorth02, this.RouteSet_Sneak,			"e20020_route_eastTent02_0001", "e20020_route_eastTent02_0000", 0 )
			end
		elseif( state == 2 )  then
			commonPrint2D("【開始】東難民キャンプ敵兵（倉庫）移動到着" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				commonSetUniqueRouteChange( this.CharacterID_E_eastTentNorth02, this.RouteSet_Sneak,			"e20020_route_eastTent02_0002", "e20020_route_eastTent02_0001", 0 )
			end
		end
	-- スニーク
	elseif( num == "Sneak" ) then
	-- コーション
	elseif( num == "Caution" ) then
		if( state == 0 )  then
			TppMission.SetFlag( "isEnemy_eastTent02_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_eastTent02_StateMove_Init", 0 )
		end
	-- トラップ
	elseif( num == "Trap" ) then
		if( state == 0 )  then
			TppMission.SetFlag( "isEnemy_eastTent02_StateMove", 1 )
			TppTimer.Start( "Timer_Enemy_eastTent02_StateMove_Init", 0 )
		end
	-- タイマー
	elseif( num == "Timer" ) then
	-- ルートポイント
	elseif( num == "RoutePoint" ) then
		local routeId					= TppData.GetArgument(3)
		local routeNodeIndex			= TppData.GetArgument(1)
		-- スタート崖の方から
		if( routeId == GsRoute.GetRouteId("e20020_route_eastTent02_0001") ) then
			if( routeNodeIndex >= 8 ) then
				if( state ~= 2 ) then
					TppMission.SetFlag( "isEnemy_eastTent02_StateMove", 2 )
					TppTimer.Start( "Timer_Enemy_eastTent02_StateMove_Init", 0 )
				end
			end
		end
	-- 車両終了
	elseif( num == "VehicleEnd" ) then
	-- 死亡
	elseif( num == "Kill" ) then
	-- 会話終了
	elseif( num == "ConversationEnd" ) then
	-- それ以外
	else

	end
end

-- ■「増援兵」開始設定
local commonEnemy_Reinforce_Move = function( CharacterID, num )
	Fox.Log("commonEnemy_Reinforce_Move"..CharacterID )
	-- 敵兵にボディーアーマー装着させる
	TppEnemyUtility.SetBodyArmor( CharacterID, true )
	-- 表示
	TppEnemyUtility.SetEnableCharacterId( CharacterID, num )
	-- 強制ルート行動
	TppEnemyUtility.SetForceRouteMode( CharacterID, num )
	-- ダメージを受けるたびにEnemyDamageメッセージを送信するようにする
	TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( CharacterID, num )
end

-- ■「増援兵」進行状態
local commonEnemy_Reinforce_StateMove = function( num, manager )
		  manager		= manager or 0
	local isAlert		= false
	local sequence		= TppSequence.GetCurrentSequence()
	local phase			= TppCharacterUtility.GetCpPhaseName( this.cpID )
	local state			= TppMission.GetFlag( "isEnemy_Reinforce_StateMove" )
	-- 設定
	if( num == "Init" or num == "CheckPoint" or num == "SequenceSkip" ) then
		if( state == 0 )  then
			commonPrint2D("【開始】増援部隊待機" , 1 )
			if( num == "Init" or num == "SequenceSkip" or isAlert == true ) then
				-- 西側ルート設定
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce01, this.RouteSet_Sneak, 	"e20020_route_Reinforce00_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce01, this.RouteSet_Caution,	"e20020_route_Reinforce00_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce02, this.RouteSet_Sneak, 	"e20020_route_Reinforce01_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce02, this.RouteSet_Caution,	"e20020_route_Reinforce01_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce03, this.RouteSet_Sneak, 	"e20020_route_Reinforce02_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce03, this.RouteSet_Caution,	"e20020_route_Reinforce02_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce04, this.RouteSet_Sneak, 	"e20020_route_Reinforce03_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce04, this.RouteSet_Caution,	"e20020_route_Reinforce03_0000",			-1, -1 )
				-- 東側ルート設定
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce05, this.RouteSet_Sneak, 	"e20020_route_Reinforce04_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce05, this.RouteSet_Caution,	"e20020_route_Reinforce04_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce06, this.RouteSet_Sneak, 	"e20020_route_Reinforce05_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce06, this.RouteSet_Caution,	"e20020_route_Reinforce05_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce07, this.RouteSet_Sneak, 	"e20020_route_Reinforce06_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce07, this.RouteSet_Caution,	"e20020_route_Reinforce06_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce08, this.RouteSet_Sneak, 	"e20020_route_Reinforce07_0000",			-1, -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce08, this.RouteSet_Caution,	"e20020_route_Reinforce07_0000",			-1, -1 )
			end
			-- 増援部隊表示ＯＦＦ
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Reinforce01, false )
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Reinforce02, false )
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Reinforce03, false )
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Reinforce04, false )
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Reinforce05, false )
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Reinforce06, false )
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Reinforce07, false )
			TppEnemyUtility.SetEnableCharacterId( this.CharacterID_E_Reinforce08, false )
		elseif( state == 1 )  then
			commonPrint2D("【開始】増援部隊移動開始" , 1 )
			if( num == "Init" or num == "SequenceSkip" ) then
				-- 移動開始
				commonEnemy_Reinforce_Move( this.CharacterID_E_Reinforce01, true )
				commonEnemy_Reinforce_Move( this.CharacterID_E_Reinforce02, true )
				commonEnemy_Reinforce_Move( this.CharacterID_E_Reinforce03, true )
				commonEnemy_Reinforce_Move( this.CharacterID_E_Reinforce04, true )
				commonEnemy_Reinforce_Move( this.CharacterID_E_Reinforce05, true )
				commonEnemy_Reinforce_Move( this.CharacterID_E_Reinforce06, true )
				commonEnemy_Reinforce_Move( this.CharacterID_E_Reinforce07, true )
				commonEnemy_Reinforce_Move( this.CharacterID_E_Reinforce08, true )
				-- 西側ルート設定
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce01, this.RouteSet_Sneak, 	"e20020_route_Reinforce00_0001",	"e20020_route_Reinforce00_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce01, this.RouteSet_Caution,	"e20020_route_Reinforce00_0001",	"e20020_route_Reinforce00_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce02, this.RouteSet_Sneak, 	"e20020_route_Reinforce01_0001",	"e20020_route_Reinforce01_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce02, this.RouteSet_Caution,	"e20020_route_Reinforce01_0001",	"e20020_route_Reinforce01_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce03, this.RouteSet_Sneak, 	"e20020_route_Reinforce02_0001",	"e20020_route_Reinforce02_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce03, this.RouteSet_Caution,	"e20020_route_Reinforce02_0001",	"e20020_route_Reinforce02_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce04, this.RouteSet_Sneak, 	"e20020_route_Reinforce03_0001",	"e20020_route_Reinforce03_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce04, this.RouteSet_Caution,	"e20020_route_Reinforce03_0001",	"e20020_route_Reinforce03_0000", -1 )
				-- 東側ルート設定
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce05, this.RouteSet_Sneak, 	"e20020_route_Reinforce04_0001",	"e20020_route_Reinforce04_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce05, this.RouteSet_Caution,	"e20020_route_Reinforce04_0001",	"e20020_route_Reinforce04_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce06, this.RouteSet_Sneak, 	"e20020_route_Reinforce05_0001",	"e20020_route_Reinforce05_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce06, this.RouteSet_Caution,	"e20020_route_Reinforce05_0001",	"e20020_route_Reinforce05_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce07, this.RouteSet_Sneak, 	"e20020_route_Reinforce06_0001",	"e20020_route_Reinforce06_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce07, this.RouteSet_Caution,	"e20020_route_Reinforce06_0001",	"e20020_route_Reinforce06_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce08, this.RouteSet_Sneak, 	"e20020_route_Reinforce07_0001",	"e20020_route_Reinforce07_0000", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce08, this.RouteSet_Caution,	"e20020_route_Reinforce07_0001",	"e20020_route_Reinforce07_0000", -1 )
				-- アナウンスログ：増援開始
				commonCallAnnounceLog( this.AnnounceLogID_EnemyIncrease )
			end
		end
	-- アラート or キープコーション
	elseif( num == "Alert" or num == "KeepCaution") then
		if( state == 0 )  then
			-- 要人Ａor要人Ｂが残っていたら増援開始
			if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 or TppMission.GetFlag( "isMT_CenterKill" ) == 0 )  then
				TppMission.SetFlag( "isEnemy_Reinforce_StateMove", 1 )
				TppTimer.Start( "Timer_Enemy_Reinforce_StateMove_Init", 0 )
			end
		end
	-- ルートポイント
	elseif( num == "RoutePoint" ) then
		local routeId					= TppData.GetArgument(3)
		local routeNodeIndex			= TppData.GetArgument(1)
		local phasename					= TppCharacterUtility.GetCurrentPhaseName()
		-------------------------------------------------------------------------------------------
		-- 西側：増援開始
		if( routeId == GsRoute.GetRouteId("e20020_route_Reinforce00_0001") ) then
			if( routeNodeIndex >= 4 ) then
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce01, this.RouteSet_Sneak, 	"e20020_route_Reinforce00_0001_S",	"e20020_route_Reinforce00_0001", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce01, this.RouteSet_Caution,	"e20020_route_Reinforce00_0001_C",	"e20020_route_Reinforce00_0001", -1 )
				-- 強制ルート行動解除
				TppEnemyUtility.SetForceRouteMode( this.CharacterID_E_Reinforce01, false )
			end
		elseif( routeId == GsRoute.GetRouteId("e20020_route_Reinforce01_0001") ) then
			if( routeNodeIndex >= 4 ) then
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce02, this.RouteSet_Sneak, 	"e20020_route_Reinforce01_0001_S",	"e20020_route_Reinforce01_0001", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce02, this.RouteSet_Caution,	"e20020_route_Reinforce01_0001_C",	"e20020_route_Reinforce01_0001", -1 )
				-- 強制ルート行動解除
				TppEnemyUtility.SetForceRouteMode( this.CharacterID_E_Reinforce02, false )
			end
		elseif( routeId == GsRoute.GetRouteId("e20020_route_Reinforce02_0001") ) then
			if( routeNodeIndex >= 4 ) then
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce03, this.RouteSet_Sneak, 	"e20020_route_Reinforce02_0001_S",	"e20020_route_Reinforce02_0001", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce03, this.RouteSet_Caution,	"e20020_route_Reinforce02_0001_C",	"e20020_route_Reinforce02_0001", -1 )
				-- 強制ルート行動解除
				TppEnemyUtility.SetForceRouteMode( this.CharacterID_E_Reinforce03, false )
			end
		elseif( routeId == GsRoute.GetRouteId("e20020_route_Reinforce03_0001") ) then
			if( routeNodeIndex >= 4 ) then
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce04, this.RouteSet_Sneak, 	"e20020_route_Reinforce03_0001_S",	"e20020_route_Reinforce03_0001", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce04, this.RouteSet_Caution,	"e20020_route_Reinforce03_0001_C",	"e20020_route_Reinforce03_0001", -1 )
				-- 強制ルート行動解除
				TppEnemyUtility.SetForceRouteMode( this.CharacterID_E_Reinforce04, false )
			end
		-------------------------------------------------------------------------------------------
		-- 東側：増援開始
		elseif( routeId == GsRoute.GetRouteId("e20020_route_Reinforce04_0001") ) then
			if( routeNodeIndex >= 3 ) then
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce05, this.RouteSet_Sneak, 	"e20020_route_Reinforce04_0001_S",	"e20020_route_Reinforce04_0001", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce05, this.RouteSet_Caution,	"e20020_route_Reinforce04_0001_C",	"e20020_route_Reinforce04_0001", -1 )
				-- 強制ルート行動解除
				TppEnemyUtility.SetForceRouteMode( this.CharacterID_E_Reinforce05, false )
			end
		elseif( routeId == GsRoute.GetRouteId("e20020_route_Reinforce05_0001") ) then
			if( routeNodeIndex >= 3 ) then
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce06, this.RouteSet_Sneak, 	"e20020_route_Reinforce05_0001_S",	"e20020_route_Reinforce05_0001", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce06, this.RouteSet_Caution,	"e20020_route_Reinforce05_0001_C",	"e20020_route_Reinforce05_0001", -1 )
				-- 強制ルート行動解除
				TppEnemyUtility.SetForceRouteMode( this.CharacterID_E_Reinforce06, false )
			end
		elseif( routeId == GsRoute.GetRouteId("e20020_route_Reinforce06_0001") ) then
			if( routeNodeIndex >= 3 ) then
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce07, this.RouteSet_Sneak, 	"e20020_route_Reinforce06_0001_S",	"e20020_route_Reinforce06_0001", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce07, this.RouteSet_Caution,	"e20020_route_Reinforce06_0001_C",	"e20020_route_Reinforce06_0001", -1 )
				-- 強制ルート行動解除
				TppEnemyUtility.SetForceRouteMode( this.CharacterID_E_Reinforce07, false )
			end
		elseif( routeId == GsRoute.GetRouteId("e20020_route_Reinforce07_0001") ) then
			if( routeNodeIndex >= 3 ) then
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce08, this.RouteSet_Sneak, 	"e20020_route_Reinforce07_0001_S",	"e20020_route_Reinforce07_0001", -1 )
				commonSetUniqueRouteChange( this.CharacterID_E_Reinforce08, this.RouteSet_Caution,	"e20020_route_Reinforce07_0001_C",	"e20020_route_Reinforce07_0001", -1 )
				-- 強制ルート行動解除
				TppEnemyUtility.SetForceRouteMode( this.CharacterID_E_Reinforce08, false )
			end
		end
	end
end

---------------------------------------------------------------------------------
-- ■■ PlayRecord function
---------------------------------------------------------------------------------

-- commonMissionClearRankRadio
local commonMissionClearRankRadio = function()
	local rank = PlayRecord.GetRank()
	Fox.Log( "commonMissionClearRankRadio Rank:"..rank )
	-- 無線
	if( rank == 1 )  then
		TppRadio.Play( "Radio_MissionClearRank_S" )
		-- 実績解除：「Sランクでミッションをクリア」
		Trophy.TrophyUnlock( this.TrophyID_GZ_RankSClear )
	elseif( rank == 2 )  then
		TppRadio.Play( "Radio_MissionClearRank_A" )
	elseif( rank == 3 )  then
		TppRadio.Play( "Radio_MissionClearRank_B" )
	elseif( rank == 4 )  then
		TppRadio.Play( "Radio_MissionClearRank_C" )
	else
		TppRadio.Play( "Radio_MissionClearRank_D" )
	end
end

-- ■ チャレンジ登録
local commonSetMissionChallenge = function()
	Fox.Log("commonSetMissionChallenge")
	local hardmode = TppGameSequence.GetGameFlag("hardmode")	-- 現在の難易度を取得
	if( hardmode == true ) then									-- 難易度がハードだったら
		-- チャレンジ要素登録
		PlayRecord.RegistPlayRecord( "VIP_RESCUE" )
	end
end

-- ■ チャレンジ失敗
local commonUnsetMissionChallenge = function()
	Fox.Log("commonUnsetMissionChallenge")
	local hardmode = TppGameSequence.GetGameFlag("hardmode")	-- 現在の難易度を取得
	if( hardmode == true ) then									-- 難易度がハードだったら
		-- チャレンジ失敗
		PlayRecord.UnsetMissionChallenge( "VIP_RESCUE" )
	end
end

-- ■ ミッション固有ボーナス
local commonMissionExternalScore = function()
	Fox.Log("commonMissionExternalScore")
	if( TppMission.GetFlag( "isMT_SquadKill" ) == 2 and TppMission.GetFlag( "isMT_CenterKill" ) == 2 and TppMission.GetFlag( "isSupportHelicopterDead" ) == false ) then
		-- ２名の要人を回収した
		PlayRecord.PlusExternalScore( this.RecoveryExternalScore )
	end
end

---------------------------------------------------------------------------------
-- ■■ sequence change Functions
---------------------------------------------------------------------------------
-- ■ シーケンス変更設定
local commonSequenceChage = function( CharacterID, KillName )
	local sequence		= TppSequence.GetCurrentSequence()
	Fox.Log("commonSequenceChage"..sequence)
	-- エリアマーカーＯＦＦ
	commonMissionTargetMarkerOFF( CharacterID, false, "NoIntelRadioName" )
	-- ＳＥ再生
	TppSoundDaemon.PostEvent( "sfx_s_mission_qualify" )
	-- ＭＴ倉庫
	if( CharacterID == this.CharacterID_MT_Squad ) then
		-- ＭＴ倉庫排除
		commonMT_Squad_StateMove( KillName )
	-- ＭＴ管制塔
	elseif( CharacterID == this.CharacterID_MT_Center ) then
		-- ＭＴ倉庫管理棟
		commonMT_Center_StateMove( KillName )
	end
	-- 排除
	if( KillName == "Kill" ) then
		-- ミッションチャレンジ失敗
		commonUnsetMissionChallenge()
	-- 回収
	elseif( KillName == "Recovery" ) then
		-- ランデブーポイント設定
		this.CounterList.HeliRendezvousPointName = TppSupportHelicopterService.GetRendezvousPointNameWhichHelicopterIsWaitingOn( this.CharacterID_SupportHelicopter )
	end
	-- シーケンス変更
	if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
		if( CharacterID == this.CharacterID_MT_Squad ) then
			-- 次のシーケンスへ
			TppSequence.ChangeSequence( "Seq_Waiting_KillMT_Center" )
		elseif( CharacterID == this.CharacterID_MT_Center ) then
			-- 次のシーケンスへ
			TppSequence.ChangeSequence( "Seq_Waiting_KillMT_Squad" )
		end
	elseif( sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) then
		-- 次のシーケンスへ
		TppSequence.ChangeSequence( "Seq_Waiting_MissionClearPlayerRideHelicopter" )
	elseif( sequence == "Seq_Mission_FailedPlayerRideHelicopter" ) then
		-- 進行フラグ
		if( TppMission.GetFlag( "isSeq_Advance" ) == 0 )  then
			if( CharacterID == this.CharacterID_MT_Squad ) then
				-- 次のシーケンスへ
				TppSequence.ChangeSequence( "Seq_Waiting_KillMT_Center" )
			elseif( CharacterID == this.CharacterID_MT_Center ) then
				-- 次のシーケンスへ
				TppSequence.ChangeSequence( "Seq_Waiting_KillMT_Squad" )
			end
			-- 次のシーケンスへ行った後に次のシーケンス変更する
			this.CounterList.NextSequenceName = "Seq_Mission_FailedPlayerRideHelicopter"
		else
			-- 次のシーケンスへ
			TppSequence.ChangeSequence( "Seq_Waiting_MissionClearPlayerRideHelicopter" )
			-- 次のシーケンスへ行った後に次のシーケンス変更する
			this.CounterList.NextSequenceName = "Seq_MissionClearPlayerRideHelicopter"
		end
	end
end

-- ■ タイムスタートシーケンス変更設定
local commonSequenceChageTimerStart = function()
	Fox.Log("commonSequenceChage")
	if( this.CounterList.NextSequenceName ~= "NoName" ) then
		TppTimer.Stop("Timer_SequenceChage")
		TppTimer.Start( "Timer_SequenceChage", this.Timer_SequenceChage )
	end
end

-- ■ タイムエンドシーケンス変更設定
local commonSequenceChageTimerEnd = function()
	Fox.Log("commonSequenceChage")
	if( this.CounterList.NextSequenceName ~= "NoName" ) then
		TppSequence.ChangeSequence( this.CounterList.NextSequenceName )
		this.CounterList.NextSequenceName = "NoName"
	end
end

---------------------------------------------------------------------------------
-- ■■ Enemy Functions
---------------------------------------------------------------------------------
-- ■ スニーク状態になった
local commonPhase_Sneak = function()
	local PhaseState = TppData.GetArgument( 2 )
	Fox.Log("commonPhase_Sneak"..PhaseState)
	---------------------------------------------------------------------------------
	-- ミッション共通処理
	-- 汎用無線
	-- サイレンの通常停止（徐々にフェード停止）
	GZCommon.StopAlertSirenCheck()
	---------------------------------------------------------------------------------
	-- ミッション専用処理
	-- フェイズ状態で切り替え
	commonEnemy_Vehicle_StateMove( "Sneak" )
	commonEnemy_Imitation_StateMove( "Sneak" )
	commonEnemy_Western01_StateMove( "Sneak" )
	commonMT_Squad_StateMove( "Sneak" )
	commonMT_Center_StateMove( "Sneak" )
	commonEnemy_Reinforce_StateMove( "Sneak" )
	-- 逃げ込む建物諜報無線オフ
	commonMT_Squad_DisableIntelRadio( false )
	commonMT_Center_DisableIntelRadio( false )
	-- ルートセット変更
	TppCommandPostObject.GsSetCurrentRouteSet( this.cpID, this.RouteSet_Sneak, false, false, false, false, false )
end

-- ■ コーション状態になった
local commonPhase_Caution = function()
	local PhaseState = TppData.GetArgument( 2 )
	Fox.Log("commonPhase_Caution"..PhaseState)
	---------------------------------------------------------------------------------
	-- ミッション共通処理
	-- 汎用無線
	if( PhaseState == "Down" ) then --フェイズが下がった時
		if( TppMission.GetFlag( "isKeepCaution" ) == true ) then
			TppRadio.Play("Miller_DontSneakPhase")
		end
	end
	-- サイレンの通常停止（徐々にフェード停止）
	GZCommon.StopAlertSirenCheck()
	---------------------------------------------------------------------------------
	-- ミッション専用処理
	-- フェイズ状態で切り替え
	commonEnemy_Vehicle_StateMove( "Caution" )
	commonEnemy_Imitation_StateMove( "Caution" )
	commonEnemy_Western01_StateMove( "Caution" )
	commonMT_Squad_StateMove( "Caution" )
	commonMT_Center_StateMove( "Caution" )
	commonEnemy_Reinforce_StateMove( "Caution" )
	-- 逃げ込む建物諜報無線オフ
	commonMT_Squad_DisableIntelRadio( false )
	commonMT_Center_DisableIntelRadio( false )
	-- ルートセット変更
	TppCommandPostObject.GsSetCurrentRouteSet( this.cpID, this.RouteSet_Caution, false, false, false, false, false )
end

-- ■ エヴァージョン状態になった
local commonPhase_Evasion = function()
	local PhaseState = TppData.GetArgument( 2 )
	Fox.Log("commonPhase_Evasion"..PhaseState)
	---------------------------------------------------------------------------------
	-- ミッション共通処理
	-- 汎用無線
	-- サイレンの通常停止（徐々にフェード停止）
	GZCommon.StopAlertSirenCheck()
	---------------------------------------------------------------------------------
	-- ミッション専用処理
	-- フェイズ状態で切り替え
	commonMT_Squad_StateMove( "Evasion" )
	commonMT_Center_StateMove( "Evasion" )
	commonEnemy_Reinforce_StateMove( "Evasion" )
	-- 逃げ込む建物諜報無線オフ
	commonMT_Squad_DisableIntelRadio( false )
	commonMT_Center_DisableIntelRadio( false )
	-- ルートセット変更
	TppCommandPostObject.GsSetCurrentRouteSet( this.cpID, this.RouteSet_Caution, false, false, false, false, false )
end

-- ■ キープアラート設定
local commonKeepPhaseAlert = function( num )
	-- キープアラートにする
	if( num == "ON" ) then
		TppCommandPostObject.GsSetKeepPhaseName( this.cpID, "Alert" )
	-- フェイズを初期状態にする
	else
		TppCommandPostObject.GsSetKeepPhaseName( this.cpID, "Sneak" )
	end
end

-- ■ アラート状態になった
local commonPhase_Alert = function()
	local sequence	= TppSequence.GetCurrentSequence()
	Fox.Log("commonPhase_Alert"..sequence)
	---------------------------------------------------------------------------------
	-- ミッション共通処理
	-- Alert用サイレンのコール開始
	GZCommon.CallAlertSirenCheck()
	---------------------------------------------------------------------------------
	-- ミッション専用処理
	-- フェイズで状態切り替え
	if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" or sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) then
		commonMT_Squad_StateMove( "Alert" )
		commonMT_Center_StateMove( "Alert" )
		commonEnemy_Reinforce_StateMove( "Alert" )
		-- アラートフラグ
		if( TppMission.GetFlag( "isAlert" ) == false ) then
			TppMission.SetFlag( "isAlert", true )
		end
		-- キープアラート
		commonKeepPhaseAlert( "ON" )
	end
	-- 無線
	commonTargetEscapeRadio( "Alert" )
	-- 逃げ込む建物諜報無線オフ
	commonMT_Squad_DisableIntelRadio( false )
	commonMT_Center_DisableIntelRadio( false )
end

-- ■ 対空ＡＩ開始
local commonChangeAntiAir = function()
	Fox.Log("commonChangeAntiAir")
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

-- ■ 要人の死体を見つけた
local commonEnemyFindComrade = function()
	local EnemyCharacterID			= TppData.GetArgument(1)
	local ComradeEnemyCharacterID	= TppData.GetArgument(2)
	local ComradeEnemyState			= TppData.GetArgument(3)
	local sequence					= TppSequence.GetCurrentSequence()
	Fox.Log( "commonEnemyFindComrade" )
	Fox.Log( "1:"..EnemyCharacterID.. ": 2:"..ComradeEnemyCharacterID.. ": 3:"..ComradeEnemyState.. "" )
	-- キープコーション無線
	if( sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" or sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
		-- 死亡した要人Ａor要人Ｂを発見した
		if( ComradeEnemyState == "Dead" ) then
			if( ComradeEnemyCharacterID == this.CharacterID_MT_Center or ComradeEnemyCharacterID == this.CharacterID_MT_Squad ) then
				TppRadio.DelayPlay("Radio_KeepCaution_KillOne", "mid")
				TppMission.SetFlag( "isKeepCaution", true )
			end
		end
	elseif( sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
		if( ComradeEnemyState == "Dead" ) then
			if( ComradeEnemyCharacterID == this.CharacterID_MT_Center or ComradeEnemyCharacterID == this.CharacterID_MT_Squad ) then
				TppRadio.DelayPlay("Radio_KeepCaution_KillTwo", "mid")
				TppMission.SetFlag( "isKeepCaution", true )
			end
		end
	end
	-- キープコーション時の処理
	if( TppMission.GetFlag( "isKeepCaution" ) ==  true ) then
		-- ＭＴ管理棟が死亡発見
		if( ComradeEnemyCharacterID == this.CharacterID_MT_Center ) then
			-- ＭＴ倉庫ミッション圏外へ
			commonMT_Squad_StateMove( "KeepCaution" )
		-- ＭＴ倉庫が死亡発見
		elseif( ComradeEnemyCharacterID == this.CharacterID_MT_Squad ) then
			-- ＭＴ倉庫ミッション圏外へ
			commonMT_Center_StateMove( "KeepCaution" )
		end
		-- 増援部隊登場
		commonEnemy_Reinforce_StateMove( "KeepCaution" )
		-- 無線
		commonTargetEscapeRadio( "Caution" )
	end
end

-- ■ 敵兵を担いだ
local commonCarriedEnemy = function( num )
	local EnemyCharacterID			= TppData.GetArgument(1)
	local EnemyLife					= TppEnemyUtility.GetLifeStatus( EnemyCharacterID )
	local sequence					= TppSequence.GetCurrentSequence()
	local clearflag					= false
	local funcs = {
		onEnd = function()
			commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
		end,
	}
	Fox.Log( "commonCarriedEnemy :"..num )
	Fox.Log( "commonCarriedEnemy EnemyID:"..EnemyCharacterID.. " LifeStatus:"..EnemyLife )
	-- 敵兵を担いだ
	if( num == "Start" ) then
		-- 死亡してたら何もしない
		if ( EnemyLife ~= "Dead" ) then
			if( EnemyCharacterID == this.CharacterID_MT_Squad ) then
				-- ターゲットしてない
				if( TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == false ) then
					-- 無線
					TppRadio.DelayPlayEnqueue( "Radio_MarkerOnCarriedMissionTargetB", "mid", nil, funcs )
					-- マーカーオン
					commonMissionTargetMarkerOn( this.CharacterID_MT_Squad, false, true, false )
				-- ターゲットしている
				else
					if( sequence == "Seq_Waiting_KillMT_Squad" ) then
						if( TppMission.GetFlag( "isRadio_MTSquadCarried" ) == false ) then
							if( EnemyLife == "Sleep" or EnemyLife == "Faint" ) then
								TppRadio.DelayPlayEnqueue( "Radio_MissionTargetCarriedOne", "mid" )
								TppMission.SetFlag( "isRadio_MTSquadCarried", true )
							end
						end
					end
				end
			elseif( EnemyCharacterID == this.CharacterID_MT_Center ) then
				-- ターゲットしてない
				if( TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == false ) then
					-- 無線
					TppRadio.DelayPlayEnqueue( "Radio_MarkerOnCarriedMissionTargetA", "mid", nil, funcs )
					-- マーカーオン
					commonMissionTargetMarkerOn( this.CharacterID_MT_Center, false, true, false )
				-- ターゲットしている
				else
					if( sequence == "Seq_Waiting_KillMT_Center" ) then
						if( TppMission.GetFlag( "isRadio_MTCenterCarried" ) == false ) then
							if( EnemyLife == "Sleep" or EnemyLife == "Faint" ) then
								TppRadio.DelayPlayEnqueue( "Radio_MissionTargetCarriedOne", "mid" )
								TppMission.SetFlag( "isRadio_MTCenterCarried", true )
							end
						end
					end
				end
			end
		end
	end
	if( num == "Start" or num == "End" ) then
		-- ミッション進行中のみ
		if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" or sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" or sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
			-- 死亡してたら何もしない
			if ( EnemyLife ~= "Dead" ) then
				-- ミッション圏外警告エリア判定
				if( EnemyCharacterID == this.CharacterID_MT_Squad or EnemyCharacterID == this.CharacterID_MT_Center ) then
					-- プレイヤーがミッション圏外警告エリアにいる
					if( GZCommon.isPlayerWarningMissionArea == true ) then
						if( num == "Start" ) then
							-- ミッションクリア判定
							clearflag = commonGetMissionEscapeAreaEnemy( false, true, false, false )
						end
						if( clearflag == false ) then
							if( GZCommon.isOutOfMissionEffectEnable == false ) then
								-- クリア条件を満たしていない場合圏外エフェクトは有効
								GZCommon.isOutOfMissionEffectEnable = true
								-- ミッション圏外警告エフェクト有効
								GZCommon.OutsideAreaEffectEnable()
								-- ミッション圏外iDoroid音声再生開始
								GZCommon.OutsideAreaVoiceStart()
							end
						else
							if( GZCommon.isOutOfMissionEffectEnable == true ) then
								-- クリア条件を満たしていない場合圏外エフェクトは無効
								GZCommon.isOutOfMissionEffectEnable = false
								-- ミッション圏外警告エフェクト無効
								GZCommon.OutsideAreaEffectDisable()
								-- ミッション圏外iDoroid音声再生停止
								GZCommon.OutsideAreaVoiceEnd()
							end
						end
					end
				end
			end
		end
	end
end

-- ■ 敵兵が拘束
local commonRestraintEnemy = function( )
	local EnemyCharacterID			= TppData.GetArgument(1)
	local EnemyLife					= TppEnemyUtility.GetLifeStatus( EnemyCharacterID )
	local funcs = {
		onEnd = function()
			commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
		end,
	}
	Fox.Log( "commonRestraintEnemy EnemyID:"..EnemyCharacterID.. " LifeStatus:"..EnemyLife )
	-- 死亡してたら何もしない
	if ( EnemyLife ~= "Dead" ) then
		-- ＭＴ倉庫
		if( EnemyCharacterID == this.CharacterID_MT_Squad ) then
			-- ターゲットしてない
			if( TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == false ) then
				-- 無線
				TppRadio.DelayPlayEnqueue( "Radio_MarkerOnRestrainMissionTargetA", "short", nil, funcs )
				-- マーカーオン
				commonMissionTargetMarkerOn( this.CharacterID_MT_Squad, false, true, false )
			end
		-- ＭＴ管制塔
		elseif( EnemyCharacterID == this.CharacterID_MT_Center ) then
			-- ターゲットしてない
			if( TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == false ) then
				-- 無線
				TppRadio.DelayPlayEnqueue( "Radio_MarkerOnRestrainMissionTargetB", "short", nil, funcs )
				-- マーカーオン
				commonMissionTargetMarkerOn( this.CharacterID_MT_Center, false, true, false )
			end
		end
	end
end

-- ■ 敵兵のアナウンスログ
local commonCallAnnounceLogEnemy = function( iRadio, isEnemy )
	Fox.Log( "commonCallAnnounceLogEnemy")
	local AnnounceLog = 255
	-- 無線終了後
	local EndMissonTargetTwo = {
		onEnd = function()
			local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()
			-- 支援ヘリに乗っていなかったら
			if( VehicleId ~= this.CharacterID_SupportHelicopter ) then
				TppRadio.DelayPlay( "Raio_MissionTargetGoalAdvice", "short", "end" )
			else
				-- 再生開始同様無線のコール音は別途独立してコール
				TppSoundDaemon.PostEvent( "Play_sfx_s_codec_NPC_end" )
			end
		end,
	}
	-- アナウンスログ設定
	if( isEnemy == this.CharacterID_MT_Squad ) then
		if( TppMission.GetFlag( "isMT_SquadKill" ) == 2 ) then
			AnnounceLog = 0
		else
			AnnounceLog = 1
		end
	elseif( isEnemy == this.CharacterID_MT_Center ) then
		if( TppMission.GetFlag( "isMT_CenterKill" ) == 2 ) then
			AnnounceLog = 2
		else
			AnnounceLog = 3
		end
	end
	if( AnnounceLog ~= 255 ) then
		if( iRadio ~= "NoRadio" ) then
			-- 無線：１回目
			if( iRadio == 0 ) then
				if( AnnounceLog == 0 or AnnounceLog == 2 ) then
					TppRadio.DelayPlay( "Radio_MissionTargetHeliOne", "mid" )
				else
					TppRadio.DelayPlay( "Radio_MissionTargetKillOne", "mid" )
				end
			-- 無線：２回目
			else
				if( AnnounceLog == 0 or AnnounceLog == 2 ) then
					TppRadio.DelayPlay( "Radio_MissionTargetHeliTwo", "mid", "begin", EndMissonTargetTwo )
				else
					TppRadio.DelayPlay( "Radio_MissionTargetKillTwo", "mid", "begin", EndMissonTargetTwo )
				end
			end
		end
		-- アナウンスログ
		if( AnnounceLog == 0 ) then
			-- アナウンスログ：指を回収
			commonCallAnnounceLog( this.AnnounceLogID_MT_Squad_Heli )
		elseif( AnnounceLog == 1 ) then
			-- アナウンスログ：指を排除
			commonCallAnnounceLog( this.AnnounceLogID_MT_Squad_Kill )
		elseif( AnnounceLog == 2 ) then
			-- アナウンスログ：目を回収
			commonCallAnnounceLog( this.AnnounceLogID_MT_Center_Heli )
		elseif( AnnounceLog == 3 ) then
			-- アナウンスログ：目を排除
			commonCallAnnounceLog( this.AnnounceLogID_MT_Center_Kill )
		end
	end
end

-- ■ 敵兵が睡眠＆気絶
local commonSleepFaintEnemy = function()
	local EnemyCharacterID = TppData.GetArgument(1)
	Fox.Log( "commonSleepFaintEnemy"..EnemyCharacterID )
	--　ミッションターゲット
	if( EnemyCharacterID == this.CharacterID_MT_Center ) then
		-- ターゲットマーカーが付いている。
		if( TppMission.GetFlag( "isMT_TargetMarker_MTCenter" ) == true ) then
			-- 無線
			TppRadio.DelayPlay( "Radio_MissionTargetSleepFaint", "mid" )
		end
	elseif( EnemyCharacterID == this.CharacterID_MT_Squad ) then
		-- ターゲットマーカーが付いている。
		if( TppMission.GetFlag( "isMT_TargetMarker_MTSquad" ) == true ) then
			-- 無線
			TppRadio.DelayPlay( "Radio_MissionTargetSleepFaint", "mid" )
		end
	end

end

-- ■ 敵兵が車両に乗った
local commonOnLaidEnemy = function()
	local sequence				= TppSequence.GetCurrentSequence()
	local EnemyCharacterID		= TppData.GetArgument(1)
	local VehicleCharacterID	= TppData.GetArgument(3)
	local EnemyLife				= TppEnemyUtility.GetLifeStatus( EnemyCharacterID )
	Fox.Log( "commonOnLaidEnemy" )
	-- 死亡してたら何もしない
	if ( EnemyLife ~= "Dead" ) then
		-- ヘリに乗せた
		if( VehicleCharacterID == this.CharacterID_SupportHelicopter ) then
			-- ターゲット
			if( ( TppMission.GetFlag( "isMT_SquadKill" ) == 0 and EnemyCharacterID == this.CharacterID_MT_Squad ) or ( TppMission.GetFlag( "isMT_CenterKill" ) == 0 and EnemyCharacterID == this.CharacterID_MT_Center ) ) then
				commonSequenceChage( EnemyCharacterID, "Recovery" )
			-- ターゲット以外
			else
				-- 無線
				TppRadio.Play("Miller_EnemyOnHeli")
			end
		-- ビークルに乗せた ※ミッションにおかれている全てビークル指定する事
		elseif( VehicleCharacterID == "Tactical_Vehicle_WEST_001" or VehicleCharacterID == "Tactical_Vehicle_WEST_002" or VehicleCharacterID == "Tactical_Vehicle_WEST_003" ) then
			-- 要人が２人いる
			if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
				-- 要人：管理棟
				if( EnemyCharacterID == this.CharacterID_MT_Center ) then
					-- 要人：倉庫が車両に乗っている状態
					if( TppEnemyUtility.GetStatus( this.CharacterID_MT_Squad ) == "RideVehicle" ) then
						-- 無線
						TppRadio.DelayPlayEnqueue( "Radio_MissionTargetCarriedTwo", "mid" )
					end
				-- 要人：倉庫
				elseif( EnemyCharacterID == this.CharacterID_MT_Squad ) then
					-- 要人：倉庫が車両に乗っている状態
					if( TppEnemyUtility.GetStatus( this.CharacterID_MT_Center ) == "RideVehicle" ) then
						-- 無線
						TppRadio.DelayPlayEnqueue( "Radio_MissionTargetCarriedTwo", "mid" )
					end
				end
			end
		end
	end
end

-- ■ 敵兵死亡
local commonDeadEnemy = function()
	local EnemyCharacterID = TppData.GetArgument(1)
	Fox.Log( "commonDeadEnemy"..EnemyCharacterID )
	-- ターゲット
	if( ( TppMission.GetFlag( "isMT_SquadKill" ) == 0 and EnemyCharacterID == this.CharacterID_MT_Squad ) or ( TppMission.GetFlag( "isMT_CenterKill" ) == 0 and EnemyCharacterID == this.CharacterID_MT_Center ) ) then
		commonSequenceChage( EnemyCharacterID, "Kill" )
	end
end

-- ■ 敵兵尋問
local commonInterrogationEnemy = function( iCheckPointFlag )
	Fox.Log( "commonInterrogationEnemy")
	local EnemyCharacterID
	local CountFlag				= false
	local CountInterrogation	= TppMission.GetFlag( "isInterrogation_Count" )
	-- 指定回数以上尋問を行っていたらやらない
	if( iCheckPointFlag == false ) then
		-- 尋問した敵兵のＩＤ取得
		EnemyCharacterID = TppData.GetArgument(1)
		-- ＭＴ倉庫とＭＴ管理棟は初回尋問のみカウントする
		if( EnemyCharacterID == this.CharacterID_MT_Center and TppMission.GetFlag( "isInterrogation_MTCenter" ) == false ) then
			TppMission.SetFlag( "isInterrogation_MTCenter", true )
			CountFlag = true
		elseif( EnemyCharacterID == this.CharacterID_MT_Squad and TppMission.GetFlag( "isInterrogation_MTSquad" ) == false ) then
			TppMission.SetFlag( "isInterrogation_MTSquad", true )
			CountFlag = true
		end
		-- ＭＴ倉庫とＭＴ管理棟ならばカウント増加しない
		if( CountFlag == true or ( EnemyCharacterID ~= this.CharacterID_MT_Center and EnemyCharacterID ~= this.CharacterID_MT_Squad ) ) then
			-- カウント増加
			TppMission.SetFlag( "isInterrogation_Count", ( CountInterrogation + 1 ) )
			CountInterrogation = CountInterrogation + 1
			CountFlag = true
		end
	end
	-- コンティニュー時orカウントした場合のみ
	if( iCheckPointFlag == true or CountFlag == true ) then
		---------------------------------------------------------------------------
		-- ４人目を「指」の居場所を教える
		if( CountInterrogation == ( this.InterrogationCount_TargetB - 1 ) ) then
			-- 全ての敵兵の尋問データを変更
			TppEnemyUtility.SetInterrogationForceCharaIdAllCharacter( this.InterrogationID_TargetB )
			-- 要人の尋問データを下に戻す
			TppEnemyUtility.UnsetInterrogationForceCharaIdByCharacterId( this.CharacterID_MT_Center )
			TppEnemyUtility.UnsetInterrogationForceCharaIdByCharacterId( this.CharacterID_MT_Squad )
		elseif( CountInterrogation == this.InterrogationCount_TargetB ) then
			-- 初期化
			TppEnemyUtility.UnsetInterrogationForceCharaIdAllCharacter()
		---------------------------------------------------------------------------
		-- ８人目を「指」の居場所を教える
		elseif( CountInterrogation == ( this.InterrogationCount_TargetA - 1 ) ) then
			-- 全ての敵兵の尋問データを変更
			TppEnemyUtility.SetInterrogationForceCharaIdAllCharacter( this.InterrogationID_TargetA )
			-- 要人の尋問データを下に戻す
			TppEnemyUtility.UnsetInterrogationForceCharaIdByCharacterId( this.CharacterID_MT_Center )
			TppEnemyUtility.UnsetInterrogationForceCharaIdByCharacterId( this.CharacterID_MT_Squad )
		elseif( CountInterrogation == this.InterrogationCount_TargetA ) then
			-- 初期化
			TppEnemyUtility.UnsetInterrogationForceCharaIdAllCharacter()
		end
	end
end

-- ■ 敵兵ダメージ
local commonDamagenEnemy = function()
	local EnemyCharacterID	= TppData.GetArgument(1)
	local DamageType		= TppData.GetArgument(3)
	Fox.Log( "commonDamagenEnemy")
	-- ライフダメージ or 気絶ダメージ or 睡眠ダメージ
	if( DamageType == 1 or DamageType == 2 or DamageType == 3 ) then
		commonPrint2D("ダメージ食らったの強制ルート行動をオフします:"..EnemyCharacterID.."", 1 )
		-- 強制ルート行動オフ
		TppEnemyUtility.SetForceRouteMode( EnemyCharacterID, false )
		-- ダメージを受けるたびにEnemyDamageメッセージを送信しない
		TppEnemyUtility.SetFlagSendMessageOnReceiveDamage( EnemyCharacterID, false )
	end
end

-- ■諜報アイコン表示Check
local commonIntelCheck = function(CharacterID)
	local type = TppNpcUtility.GetNpcType( CharacterID )

	-- 見ている対象が敵兵か捕虜だったら判定処理を実行
	if type == "Enemy" then
		local lifeStatus = TppEnemyUtility.GetLifeStatus( CharacterID )	-- 見ている対象のライフ状態を取得する
		if lifeStatus == "Normal" then
			TppRadio.EnableIntelRadio( characterID )
		else	-- 相手が通常状態でない
			TppRadio.DisableIntelRadio( CharacterID )
		end
	end
end

---------------------------------------------------------------------------------
-- ■■ Hostage Functions
---------------------------------------------------------------------------------
-- ■ 捕虜いるかチェック
local commonCheckHostateArea = function( CharacterID )
	Fox.Log( "commonHostateArea" )
	local pos
	local size
	local rot
	local npcIds
	-- 捕虜がいる場所をボックス値座標設定
	if( CharacterID == this.CharacterID_Hostage_PickingDoor08 ) then
		pos		= Vector3( 73.1, 18, 219.2 )
		size	= Vector3( 3, 4, 3 )
		rot		= Quat( 0.0 , 0.0, 0.0, 1.0 )
	elseif( CharacterID == this.CharacterID_Hostage_PickingDoor22 ) then
		pos		= Vector3( 64.5, 19, 200.575 )
		size	= Vector3( 3, 4, 3 )
		rot		= Quat( 0.0 , 0.0, 0.0, 1.0 )
	else
		-- キャラＩＤがまちがっていたら終了
		return false
	end
	-- BOX内にいる捕虜を検索
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos, size, rot )
	-- 檻の中に捕虜がいるか？
	if( npcIds and #npcIds.array > 0 ) then
		for i,id in ipairs(npcIds.array) do
			local type					= TppNpcUtility.GetNpcType( id )
			local HostageCharacterID	= TppCharacterUtility.GetCharacterIdFromUniqueId( id )
			Fox.Log("npc type:"..type )
			if( type == "Hostage" and HostageCharacterID == CharacterID ) then
				return true
			end
		end
	end
	return false
end

-- ■ 捕虜あばれる設定
local commonHostageHelp = function( num )
	local HostageCharacterID01 = TppHostageUtility.GetStatus( this.CharacterID_Hostage_PickingDoor08 )
	local HostageCharacterID02 = TppHostageUtility.GetStatus( this.CharacterID_Hostage_PickingDoor22 )
	Fox.Log( "commonHostageHelp" )
	-- 捕虜エリアに入った
	if( num == "Enter" ) then
		if( HostageCharacterID01 == "Normal" or HostageCharacterID02 == "Normal" ) then
			-- 無線
			TppRadio.DelayPlay("Radio_DiscoverHostage", "mid" )
		end
		-- 捕虜あばれる開始
		if( HostageCharacterID01 == "Normal" and commonCheckHostateArea( this.CharacterID_Hostage_PickingDoor08 ) == true ) then
			TppHostageManager.GsSetStruggleFlag( this.CharacterID_Hostage_PickingDoor08, true )
		end
		if( HostageCharacterID02 == "Normal" and commonCheckHostateArea( this.CharacterID_Hostage_PickingDoor22 ) == true ) then
			TppHostageManager.GsSetStruggleFlag( this.CharacterID_Hostage_PickingDoor22, true )
		end
	-- 捕虜エリアから出た
	else
		-- 捕虜あばれる終了
		if( HostageCharacterID01 == "Normal" and commonCheckHostateArea( this.CharacterID_Hostage_PickingDoor08 ) == true ) then
			TppHostageManager.GsSetStruggleFlag( this.CharacterID_Hostage_PickingDoor08, false )
		end
		if( HostageCharacterID02 == "Normal" and commonCheckHostateArea( this.CharacterID_Hostage_PickingDoor22 ) == true ) then
			TppHostageManager.GsSetStruggleFlag( this.CharacterID_Hostage_PickingDoor22, false )
		end
	end
end

-- ■ 捕虜を車両に乗せた
local commonOnLaidHostage = function()
	Fox.Log( "commonOnLaidHostage" )
	local HostageCharacterID	= TppData.GetArgument(1)
	local VehicleCharacterID	= TppData.GetArgument(3)
	local sequence				= TppSequence.GetCurrentSequence()
	-- 支援ヘリ
	if( VehicleCharacterID == this.CharacterID_SupportHelicopter ) then
		-- 無線
		TppRadio.DelayPlay( "Radio_HostageOnHeli", "mid", nil )
		-- 捕虜回収処理（アナウンスログ表示、戦績反映）
		GZCommon.NormalHostageRecovery( HostageCharacterID )
	end
end

-- ■ 捕虜死亡
local commonOnDeadHostage = function()
	Fox.Log( "commonOnDeadHostage" )
	local HostageCharacterID	= TppData.GetArgument(1)
	local PlayerDead			= TppData.GetArgument(4)
	-- 無線
	if( PlayerDead == true ) then
		TppRadio.DelayPlay( "Radio_HostageDead", "mid" )
	end
end

--------------------------------------------------------------------------------
-- ■■ Player Functions
---------------------------------------------------------------------------------

-- ■ ピッキングドア
local commonOnPickingDoor = function()
	local characterId = TppData.GetArgument(1)
	Fox.Log( "commonOnPickingDoor: PickingDoorID"..characterId	)
	-- 捕虜が暴れるのを止める
	if( characterId == "AsyPickingDoor08" )then
		TppHostageManager.GsSetStruggleFlag( this.CharacterID_Hostage_PickingDoor08, false )
	elseif( characterId == "AsyPickingDoor22" )then
		TppHostageManager.GsSetStruggleFlag( this.CharacterID_Hostage_PickingDoor22, false )
	end
end

-- ■ プレイヤー車両に乗った
local commonOnVehicleRide = function( num )
	local VehicleCharacterID	= TppData.GetArgument(1)
	local VehicleID				= TppData.GetArgument(2)
	local sequence				= TppSequence.GetCurrentSequence()
	local clearflag				= false
	local hudCommonData			= HudCommonDataManager.GetInstance()
	Fox.Log( "commonOnVehicleRide"..VehicleCharacterID)
	if( num == "Start" or num == "End" ) then
		-- チュートリアル表示判定
		if( VehicleID == "WheeledArmoredVehicleMachineGun" ) then				--機銃装甲車の場合
			if( num == "Start" ) then
				if( TppMission.GetFlag( "isAVMTutorial" ) == false ) then			--乗り物チュートリアルボタンを表示していないなら
					-- 初回
					hudCommonData:CallButtonGuide( "tutorial_pause", fox.PAD_SELECT )
					hudCommonData:CallButtonGuide( "tutorial_apc", fox.PAD_Y )
					TppMission.SetFlag( "isAVMTutorial", true )						--乗り物チュートリアルボタンを表示した
				else
					-- ２回目
					hudCommonData:CallButtonGuide( "tutorial_vehicle_attack", fox.PAD_L1 )
				end
			end
		elseif( VehicleID == "SupportHelicopter" ) then							-- 支援ヘリ

		else
			if( num == "Start" ) then
--			if( TppMission.GetFlag( "isCarTutorial" ) == false ) then			--乗り物チュートリアルボタンを表示していないなら
				-- RT アクセルボタン
				hudCommonData:CallButtonGuide( "tutorial_accelarater", "VEHICLE_TRIGGER_ACCEL" )
				-- LT バックボタン
				hudCommonData:CallButtonGuide( "tutorial_brake", "VEHICLE_TRIGGER_BREAK" )
				TppMission.SetFlag( "isCarTutorial", true )						--乗り物チュートリアルボタンを表示した
--			end
			end
		end
		-- ミッション進行中のみ
		if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" or sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" or sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
			-- プレイヤーがミッション圏外警告エリアにいる
			if( GZCommon.isPlayerWarningMissionArea == true ) then
				-- ミッション達成
				if ( sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
					clearflag = true
				else
					if( num == "Start" ) then
						-- ミッションクリア判定
						clearflag = commonGetMissionEscapeAreaEnemy( false, false, true, false )
					end
				end
				if( clearflag == false ) then
					if( GZCommon.isOutOfMissionEffectEnable == false ) then
						-- クリア条件を満たしていない場合圏外エフェクトは有効
						GZCommon.isOutOfMissionEffectEnable = true
						-- ミッション圏外警告エフェクト有効
						GZCommon.OutsideAreaEffectEnable()
						-- ミッション圏外iDoroid音声再生開始
						GZCommon.OutsideAreaVoiceStart()
					end
				else
					if( GZCommon.isOutOfMissionEffectEnable == true ) then
						-- クリア条件を満たしていない場合圏外エフェクトは無効
						GZCommon.isOutOfMissionEffectEnable = false
						-- ミッション圏外警告エフェクト無効
						GZCommon.OutsideAreaEffectDisable()
						-- ミッション圏外iDoroid音声再生停止
						GZCommon.OutsideAreaVoiceEnd()
					end
				end
			end
		end
	end
	-- 荷台に乗ったor降りた
	if( num == "SneakStart") then
		TppMission.SetFlag( "isPlayerRideSneak", true )
	elseif( "SneakEnd" ) then
		TppMission.SetFlag( "isPlayerRideSneak", false )
	end
end

-- commonTutorial_2Button
local commonTutorial_2Button = function( textInfo, buttonIcon1, buttonIcon2 )
	-- 2ボタン
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:CallButtonGuide( textInfo, buttonIcon1, buttonIcon2 )
end

-- commonPickUpWeaopn
local commonPickUpWeaopn = function()
	-- 武器ID取得
	local weaponID = TppData.GetArgument( 1 )
	Fox.Log( "commonPickUpWeaopn : "..weaponID )
	-- 無反動砲
	if( weaponID == "WP_ms02" ) then
		-- チュートリアルアイコン
		if( TppMission.GetFlag( "isPrimaryWPIcon" ) == false ) then
			commonTutorial_2Button("tutorial_primary_wp_select", fox.PAD_U, "RStick")
			TppMission.SetFlag( "isPrimaryWPIcon", true )
		end
	-- スナイパーライフル
	elseif( weaponID == "WP_sr01_v00" ) then
		-- チュートリアルアイコン
		if( TppMission.GetFlag( "isPrimaryWPIcon" ) == false ) then
			commonTutorial_2Button("tutorial_primary_wp_select", fox.PAD_U, "RStick")
			TppMission.SetFlag( "isPrimaryWPIcon", true )
		end
		-- トラックの荷台のスナイパーライフル取得
		if( TppMission.GetFlag( "isPlayerRideSneak" ) == true ) then
			if( TppMission.GetFlag( "isIntelRadio_Western" ) == false ) then
				-- トラックの諜報無線変更
				TppRadio.RegisterIntelRadio( this.VehicleID_Western02, "f0090_esrg0050", true )
				-- トラックの上のスナイパーライフル取得
				TppMission.SetFlag( "isPlayerGetTruckSniper", true )
			end
		end
	end
end

-- commonPlayerPickItem
local commonPlayerPickItem = function()
	local ItemID			= TppData.GetArgument(1)
	local Index				= TppData.GetArgument(2)
	Fox.Log( "commonPlayerPickItem : "..ItemID )
	-- カセットテープを入手した
	if ( ItemID == "IT_Cassette" ) then
		if ( Index == 5 ) then
			-- カセット入手処理
			local uiCommonData = UiCommonDataManager.GetInstance()
			uiCommonData:GetBriefingCassetteTape( this.CassetteID )
		end
	end
end

---------------------------------------------------------------------------------
-- ■■ PhotoID Functions
---------------------------------------------------------------------------------

-- commonUiMissionSubGoalNo
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
	luaData:SetCurrentMissionSubGoalNo(id)
end

-- commonUiMissionPhotoChange
local commonUiMissionPhotoChange = function( characterID )
	Fox.Log("commonUiMissionPhotoChange"..characterID)
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end
	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end	-- 要人Ａ：目
	-- キャラＩＤで判定
	if( characterID == this.CharacterID_MT_Center ) then
		if( luaData:IsMissionPhotoIdEnable( this.PhotoID_MT_Center ) ) then
			-- 達成済みにする
			luaData:SetCompleteMissionPhotoId( this.PhotoID_MT_Center, true )
		end
	-- 要人Ａ：指
	elseif( characterID == this.CharacterID_MT_Squad ) then
		if( luaData:IsMissionPhotoIdEnable( this.PhotoID_MT_Squad ) ) then
			-- 達成済みにする
			luaData:SetCompleteMissionPhotoId( this.PhotoID_MT_Squad, true )
		end
	end

end

---------------------------------------------------------------------------------
-- ■■ Heli Functions
---------------------------------------------------------------------------------
-- ■ヘリがＲＶ到着
local commonHeliArrive = function()
	local timer = 55 --「ヘリから離れろよ」という促しをするまでの時間
	Fox.Log(":: commonHeliArrive :: ")
	-- 離れるよう促すタイマー開始
	TppMission.SetFlag( "isHeliLandNow", true )						-- ヘリが着陸してる
	GkEventTimerManager.Start( "Timer_pleaseLeaveHeli", timer )
end

-- ■ヘリが離陸
local commonHeliTakeOff = function()
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log("commonHeliTakeOff"..sequence)
	local isPlayer = TppData.GetArgument(3)
	-- プレイヤーが搭乗していたら
	if ( isPlayer == true ) then
		if( sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
			-- ミッション成功シーケンスへ
			TppSequence.ChangeSequence( "Seq_MissionClearPlayerRideHelicopter" )
		elseif( sequence == "Seq_MissionClearPlayerRideHelicopter" or sequence == "Seq_Mission_FailedPlayerRideHelicopter" ) then
			-- 何もしない
		else
			-- ミッション失敗シーケンスへ
			TppSequence.ChangeSequence( "Seq_Mission_FailedPlayerRideHelicopter" )
		end
	end
	-- ヘリが離陸してる
	TppMission.SetFlag( "isHeliLandNow", false )
end

-- ■プレイヤーがヘリに乗った
local commonPlayerRideHelicopter = function( num )
	Fox.Log("commonPlayerRideHelicopter")
	-- ミッション失敗
	if( num == 0 ) then
		-- 汎用のミラー無線：ミッション中断警告
		TppRadio.DelayPlay( "Radio_RideHeli_Warning", "mid" )
		-- 離陸を少し待つ
		TppSupportHelicopterService.SetEnableGetOffTime( GZCommon.WaitTime_HeliTakeOff )
	-- ミッション成功
	else
		-- 汎用のミラー無線：ヘリで離脱
		TppRadio.Play( "Radio_RideHeli_Clear" )
		-- ミッションクリアシーケンスへ
		TppSequence.ChangeSequence( "Seq_MissionClearPlayerRideHelicopter" )
	end
end

-- ■ヘリ破壊
local commonHeliDead = function()
	local sequence = TppSequence.GetCurrentSequence()
	local killerCharacterId = TppData.GetArgument(2)
	Fox.Log( "commonHeliDead"..sequence )
	-- 「ヘリ離脱シーケンス」だったらミッション失敗
	if ( sequence == "Seq_MissionClearPlayerRideHelicopter" or sequence == "Seq_Mission_FailedPlayerRideHelicopter" ) then
		TppMission.ChangeState( "failed", "PlayerDeadOnHeli" )
	else
		-- 無線
		if( killerCharacterId == "Player" ) then
			TppRadio.Play( "Miller_HeliDeadSneak" )
		else
			TppRadio.Play( "Miller_HeliDead" )
		end
		-- １人目の要人を回収していたら
		if( sequence == "Seq_Waiting_KillMT_Center" ) then
			if( TppMission.GetFlag( "isMT_SquadKill" ) == 2 ) then
				-- ＭＴ倉庫死亡フラグ
				TppMission.SetFlag( "isMT_SquadKill", 1 )
				-- アナウンスログ
				commonCallAnnounceLogEnemy( "NoRadio", this.CharacterID_MT_Squad )
				-- 支援ヘリ死亡フラグ
				TppMission.SetFlag( "isSupportHelicopterDead", true )
			end
		-- １人目の要人を回収していたら
		elseif ( sequence == "Seq_Waiting_KillMT_Squad" ) then
			if( TppMission.GetFlag( "isMT_CenterKill" ) == 2 ) then
				-- ＭＴ管制塔死亡フラグ
				TppMission.SetFlag( "isMT_CenterKill", 1 )
				-- アナウンスログ
				commonCallAnnounceLogEnemy( "NoRadio", this.CharacterID_MT_Center )
				-- 支援ヘリ死亡フラグ
				TppMission.SetFlag( "isSupportHelicopterDead", true )
			end
		-- ２名の要人を回収していたら
		elseif ( sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
			-- 要人どちらかを回収していたら
			if( TppMission.GetFlag( "isMT_SquadKill" ) == 2 or TppMission.GetFlag( "isMT_CenterKill" ) == 2 ) then
				-- ＭＴ管制塔回収していたら
				if( TppMission.GetFlag( "isMT_CenterKill" ) == 2 ) then
					-- ＭＴ管制塔死亡フラグ
					TppMission.SetFlag( "isMT_CenterKill", 1 )
					-- アナウンスログ
					commonCallAnnounceLogEnemy( "NoRadio", this.CharacterID_MT_Center )
				end
				-- ＭＴ倉庫回収していたら
				if( TppMission.GetFlag( "isMT_SquadKill" ) == 2 ) then
					-- ＭＴ倉庫死亡フラグ
					TppMission.SetFlag( "isMT_SquadKill", 1 )
					-- アナウンスログ
					commonCallAnnounceLogEnemy( "NoRadio", this.CharacterID_MT_Squad )
				end
				-- 支援ヘリ死亡フラグ
				TppMission.SetFlag( "isSupportHelicopterDead", true )
			end
		end
	end
	-- アナウンスログ：味方のヘリが撃墜された
	commonCallAnnounceLog( this.AnnounceLogID_HeliDestroyed )
end

-- ■ヘリのランデブーポイント設定
local commonHeliRendezvousPointMarker = function( RVname )
	Fox.Log("commonHeliRendezvousPointMarker:"..RVname)
	-- ランデブーポイント設定しなくする。
--	TppSupportHelicopterService.SetDefaultRendezvousPointMarker( RVname )
end

-- ■ＭＢ端末で支援ヘリを呼ぶ
local commonMbDvcActCallRescueHeli = function(characterId, type)
	local radioDaemon	= RadioDaemon:GetInstance()
	local emergency		= TppData.GetArgument(2)
	local charaObj		= Ch.FindCharacterObjectByCharacterId("SupportHelicopter")
	local plgHeli		= charaObj:GetCharacter():FindPlugin("TppSupportHelicopterPlugin")
	Fox.Log("MbDvcActCallRescueHeli:")
	Fox.Log( "=================================" )
	Fox.Log( "===  mbDvaActCall(Type:" .. tostring(type) .. ") !!!   ===" )
	Fox.Log( "=================================" )
	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()
	if( VehicleId == "SupportHelicopter" ) then
	else
		if ( type == "MbDvc" ) then
			Fox.Log( "=================================" )
			Fox.Log( "===  mbDvaActCall(emergencyRank:" .. tostring(emergency) .. ") !!!   ===" )
			Fox.Log( "=================================" )
			if ( radioDaemon:IsPlayingRadio() == false ) then
				--無線の種類に問わず再生中でない
				if( TppSupportHelicopterService.IsDueToGoToLandingZone( characterId ) ) then
					--これからＬＺに行く予定がある
					if( emergency == 2 ) then
						TppRadio.DelayPlay( "Miller_CallHeliHot02", "long" )
					else
						TppRadio.DelayPlay( "Miller_CallHeli02", "long" )
					end
				else
					--特にＬＺに行く予定はない
					if( plgHeli:GetAiStatus() ~= "AI_STATUS_RETURN" ) then
						if( emergency == 2 ) then
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
						if( plgHeli:GetAiStatus() ~= "AI_STATUS_RETURN" ) then
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
					if( plgHeli:GetAiStatus() ~= "AI_STATUS_RETURN" ) then
						TppRadio.DelayPlay( "Miller_CallHeli01", "long" )
					end
				end
			end
		end
	end
end

-- プレイヤーに攻撃された
local commonHeliDamagedByPlayer = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then
		--無線の種類に問わず再生中でなければ
		TppRadio.PlayEnqueue( "Miller_HeliAttack" )
	end
end

-- ヘリから離れろって促すかどうか
local commonHeliLeaveJudge = function()
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

-- ヘリから離れろって促すのを延長
local commonHeliLeaveExtension = function()
	local timer = 55 --「ヘリから離れろよ」という促しをするまでの時間
	-- 一回止めて同じタイマーを回す
	GkEventTimerManager.Stop( "Timer_pleaseLeaveHeli" )
	GkEventTimerManager.Start( "Timer_pleaseLeaveHeli", timer )
end

---------------------------------------------------------------------------------
-- ■■ Gimmick Functions
---------------------------------------------------------------------------------

-- CharacterIdとアナウンスログの組み合わせ定義
this.destroyAnnounceLogMap = {}
this.destroyAnnounceLogMap["gntn_area01_antiAirGun_000"]	= "announce_destroy_AntiAirCraftGun"	-- 対空機関砲
this.destroyAnnounceLogMap["gntn_area01_antiAirGun_001"]	= "announce_destroy_AntiAirCraftGun"	-- 対空機関砲
this.destroyAnnounceLogMap["gntn_area01_antiAirGun_002"]	= "announce_destroy_AntiAirCraftGun"	-- 対空機関砲
this.destroyAnnounceLogMap["gntn_area01_antiAirGun_003"]	= "announce_destroy_AntiAirCraftGun"	-- 対空機関砲
this.destroyAnnounceLogMap["WoodTurret01"]					= "announce_destroy_tower"				-- 木製櫓
this.destroyAnnounceLogMap["WoodTurret02"]					= "announce_destroy_tower"				-- 木製櫓
this.destroyAnnounceLogMap["WoodTurret03"]					= "announce_destroy_tower"				-- 木製櫓
this.destroyAnnounceLogMap["WoodTurret04"]					= "announce_destroy_tower"				-- 木製櫓
this.destroyAnnounceLogMap["WoodTurret05"]					= "announce_destroy_tower"				-- 木製櫓
this.destroyAnnounceLogMap["Tactical_Vehicle_WEST_001"]		= "announce_destroy_vehicle"			-- ビークル
this.destroyAnnounceLogMap["Tactical_Vehicle_WEST_002"]		= "announce_destroy_vehicle"			-- ビークル
this.destroyAnnounceLogMap["Tactical_Vehicle_WEST_003"]		= "announce_destroy_vehicle"			-- トラック
this.destroyAnnounceLogMap["Cargo_Truck_WEST_000"]			= "announce_destroy_truck"				-- トラック
this.destroyAnnounceLogMap["Cargo_Truck_WEST_001"]			= "announce_destroy_truck"				-- トラック
this.destroyAnnounceLogMap["Armored_Vehicle_WEST_001"]		= "announce_destroy_APC"				-- 機銃装甲車

-- ■ characterIdに対応したアナウンスログを取得
local commonGetDestroyAnnounceLogId = function( characterId )
	return this.destroyAnnounceLogMap[ characterId ]
end

-- ■ 共通ギミック破壊時
local commonGimmickBroken = function( AnnounceLogOFF )
	Fox.Log( "commonGimmickBroken")
	local CharacterID		= TppData.GetArgument(1)						-- 破壊されたキャラＩＤ取得
	local AnnounceLogID		= commonGetDestroyAnnounceLogId( CharacterID )	-- キャラＩＤからアナウンスログＩＤ取得
	commonPrint2D("ギミック破壊"..CharacterID )
	-- ルート変更する
	if( CharacterID == "WoodTurret01" ) then
		-- 敵兵がいないので何もしない
	elseif( CharacterID == "WoodTurret02" ) then
		if( TppMission.GetFlag( "isGimmick_Break_WoodTurret02" ) == false ) then
			TppEnemy.DisableRoute( this.cpID, "gntn_common_d01_route0021" )
			TppEnemy.EnableRoute( this.cpID, "gntn_common_d01_route0005" )
			TppMission.SetFlag( "isGimmick_Break_WoodTurret02", true )
		end
	elseif( CharacterID == "WoodTurret03" ) then
		-- 敵兵がいないので何もしない
	elseif( CharacterID == "WoodTurret04" ) then
		-- 敵兵がいないので何もしない
	elseif( CharacterID == "WoodTurret05" ) then
		-- 敵兵がいないので何もしない
	end
	-- アナウンスログ
	if( AnnounceLogOFF == "ON" and AnnounceLogID ~= nil ) then
		commonCallAnnounceLog( AnnounceLogID )
	end
end

-- ■ 監視カメラギミック
local commonSecurityCamera = function( num )
	local characterID = TppData.GetArgument( 1 )
	Fox.Log( "commonSecurityCamera"..characterID )
	if( num == "Dead" ) then
		TppRadio.DisableIntelRadio( characterID )
	elseif( num == "Poweroff" ) then
		TppRadio.DisableIntelRadio( characterID )
	elseif( num == "Poweron" ) then
		TppRadio.EnableIntelRadio( characterID)
	end
end

---------------------------------------------------------------------------------
-- ■■ Demo function
---------------------------------------------------------------------------------

-- ■ 配電盤スイッチオフ（デモ後）
local After_SwitchOff = function()
	Fox.Log("commonCallEscapMusic")
	-- 敵兵停電挙動トラップＯＮ
	TppDataUtility.SetEnableDataFromIdentifier( "gntn_Trap", "SwitchLightArea", true , false )
	-- 管理棟内全監視カメラ無効化
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20020_SecurityCamera_02" , false )
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20020_SecurityCamera_03" , false )
	-- 停電ルートチェンジ
end

-- ■ 配電盤スイッチオフ（デモ前）
local SwitchLight_OFF = function()
	Fox.Log("SwitchLight_OFF")
	local phase = TppEnemy.GetPhase( this.cpID )
	-- 演出デモを見てなく、アラート以外の時のみ停電演出デモが流れる
	if( TppMission.GetFlag( "isSwitchLightDemo" ) == false ) and ( phase == "sneak" or phase == "caution" or phase == "evasion" ) then
		-- デモ開始
		local onDemoStart = function()
			-- 再生中の無線停止
			local radioDaemon = RadioDaemon:GetInstance()
			radioDaemon:StopDirect()
			-- 字幕の停止
			SubtitlesCommand.StopAll()
			-- カメラに映らない監視カメラを無効化する
			TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20020_SecurityCamera_02", false )
			-- ボイラー室エフェクトＯＮ
			TppDataUtility.CreateEffectFromGroupId( "wtrdrpbil" )
			TppDataUtility.CreateEffectFromGroupId( "dstcomviw" )
		end
		-- デモスキップ
		local onDemoSkip = function()
			-- 照明を消す
			TppGadgetUtility.SetSwitch("gntn_center_SwitchLight",false)
		end
		-- デモ終了
		local onDemoEnd = function()
			-- フラグ更新
			TppMission.SetFlag( "isSwitchLightDemo", true )
			-- 停電後処理
			After_SwitchOff()
			-- ボイラー室エフェクトＯＦＦ
			TppDataUtility.DestroyEffectFromGroupId( "wtrdrpbil" )
			TppDataUtility.DestroyEffectFromGroupId( "dstcomviw" )
		end
		-- デモ再生開始
		TppDemo.Play( "SwitchLightDemo", { onStart = onDemoStart, onSkip = onDemoSkip ,onEnd = onDemoEnd },
			{
				disableGame				= false,	--共通ゲーム無効を、キャンセル
				disableDamageFilter		= false,	--エフェクトは消さない
				disableDemoEnemies		= false,	--敵兵は消さないでいい
				disableEnemyReaction	= true,		--敵兵のリアクションを向こうかする
				disableHelicopter		= false,	--支援ヘリは消さないでいい
				disablePlacement		= false, 	--設置物は消さないでいい
				disableThrowing			= false	 	--投擲物は消さないでいい
			}
		)
	-- 演出デモを見たか、アラートフェイズの時
	else
		-- 停電後処理
		After_SwitchOff()
	end
end

-- ■ 配電盤スイッチオフ
local SwitchLight_ON = function()
	Fox.Log("SwitchLight_ON")
	-- 敵兵停電ノーティストラップＯＦＦ
	TppDataUtility.SetEnableDataFromIdentifier( "gntn_Trap", "SwitchLightArea", false , false )
	-- 管理棟全監視カメラ有効化
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20020_SecurityCamera_02" , true )
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20020_SecurityCamera_03" , true )
	-- 停電復帰ルートチェンジ
end

-- ■ ミッション失敗デモ再生
local commonMissionFailureDemo = function( EscapeAreaName )
	Fox.Log( "commonMissionFailureDemo" )
	local DemoName = "NoName"
	-- 圏外カメラデモ設定
	if( EscapeAreaName == "North" ) then
		DemoName = "Demo_AreaEscapeNorth"
	elseif( EscapeAreaName == "West" ) then
		DemoName = "Demo_AreaEscapeWest"
	end
	-- 圏外カメラデモ再生
	if( DemoName ~= "NoName" ) then
		TppDemo.Play( DemoName,
						{
						-- disableGame = false,			--共通ゲーム無効を、キャンセル
						  disableDemoEnemies = false,	--敵兵無効を、キャンセル
						  disableHelicopter = false,	--支援ヘリ無効かを、キャンセル
						} )
	end
end

-- ■ ミッション圏外演出
local commonTimeOutsideAreaCamera = function()
	Fox.Log( "TimecommonOutsideAreaCamera" )
	-- ミッション失敗テロップ
	local hudCommonData = HudCommonDataManager.GetInstance()
	-- 徒歩ミッション失敗演出
	if( this.CounterList.VipOnEscapeArea == "NoArea" ) then
		-- ミッション圏外演出
		GZCommon.OutsideAreaCamera_Human( this.CounterList.VipOnEscapeCharacterID )
	else
		-- ミッション圏外演出
		GZCommon.OutsideAreaCamera_Human( this.CounterList.VipOnEscapeCharacterID, this.CounterList.VipOnEscapeArea )
	end
	-- ミッション失敗テロップ
	hudCommonData:CallFailedTelop( "gameover_reason_target_outside" )
end

---------------------------------------------------------------------------------
-- ■■ BGM function
---------------------------------------------------------------------------------

-- ■ミッション脱出ＢＧＭ設定
local commonCallEscapMusic = function( num )
	Fox.Log("commonCallEscapMusic")
	if( num == "Start" ) then
		-- シーンモード開始
		TppMusicManager.StartSceneMode()
		-- シーンミュージック開始イベント
		TppMusicManager.PlaySceneMusic( "Play_bgm_gntn_escape" )
	elseif( num == "Fade" ) then
		-- シーンミュージック終了イベント
		TppMusicManager.PlaySceneMusic( "Stop_bgm_gntn_escape" )
	elseif( num == "End" ) then
		-- シーンモード終了
		TppMusicManager.EndSceneMode()
	end
end

-- ■ミッション失敗時にビークルサウンドを鳴らす。
local commonEscapeVehicleSound = function()
	Fox.Log("commonEscapeVehicleSound")
	local characterObject = Ch.FindCharacterObjectByCharacterId( this.CounterList.VipOnEscapeVehicleID )
	local pos = characterObject:GetPosition()
	TppSoundDaemon.PostEvent3D( "Play_sfx_c_horn_escape", pos )
end

---------------------------------------------------------------------------------
-- ■■ MissionCleanUp function
---------------------------------------------------------------------------------
-- commonMissionFlagRestore
local commonMissionFlagRestore = function( )
	Fox.Log( "commonMissionFlagRestore" )
	-- デバッグ文字用カウント初期化
	this.CounterList.DEBUG_commonPrint2DCount		= 0
	-- ＶＩＰが車両に乗っているＩＤ	⇒ ミッション失敗用
	this.CounterList.VipOnEscapeVehicleID			= "NoRide"
	-- ＶＩＰのキャラＩＤ			⇒ ミッション失敗用
	this.CounterList.VipOnEscapeCharacterID			= "NoCharacterID"
	-- ＶＩＰが車両で出たエリア名	⇒ ミッション失敗用
	this.CounterList.VipOnEscapeArea				= "NoArea"
	-- ＭＴ倉庫強制ルート行動
	this.CounterList.ForceRoute_MTSquad				= "OFF"
	-- ＭＴ管理棟強制ルート行動
	this.CounterList.ForceRoute_MTCenter			= "OFF"
	-- 建物の諜報無線
	this.CounterList.IntelRadioBuilding_MTSquad		= false
	-- 建物の諜報無線
	this.CounterList.IntelRadioBuilding_MTCenter	= false
	-- ゲームオーバー無線名
	this.CounterList.GameOverRadioName				= "NoRadio"
	-- 現在の任意無線名
	this.CounterList.GameOptionalRadioName			= "NoRadio"
	-- シーケンス名
	this.CounterList.NextSequenceName				= "NoName"
	-- ランデブーポイント名
	this.CounterList.HeliRendezvousPointName		= "NoName"
end

-- commonMissionCleanUp
this.commonMissionCleanUp = function()
	Fox.Log( "commonMissionCleanUp" )
	-- ミッション共通後片付け
	GZCommon.MissionCleanup()
	-- 保存したくないミッションフラグを初期化
	commonMissionFlagRestore()
	-- 汎用無線登録解除
	commonRegisterRadioCondition( "OFF" )
	-- 脱出曲設定
	commonCallEscapMusic( "End" )
	-- 無線のフラグをリセット
	GzRadioSaveData.ResetSaveRadioId()
	GzRadioSaveData.ResetSaveEspionageId()
	local radioManager = RadioDaemon:GetInstance()
	radioManager:DisableAllFlagIsMarkAsRead()
	radioManager:ResetRadioGroupAndGroupSetAlreadyReadFlag()
end

---------------------------------------------------------------------------------
-- MissionArea Messages
---------------------------------------------------------------------------------

-- commonOutsideMissionWarningArea
local commonOutsideMissionWarningArea = function()
	local sequence	= TppSequence.GetCurrentSequence()
	local clearflag = false
	Fox.Log( "commonOutsideMissionWarningArea:::::"..sequence )
	if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" or sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) then
		-- クリア条件判定
		clearflag = commonGetMissionEscapeAreaEnemy( false, false, false, false )
		-- クリア条件成立していたら、ミッション圏外無線鳴らさない
		if( clearflag == false ) then
			-- ミッション失敗圏外無線
			TppRadio.Play("Radio_MissionFailed_Warning_OutsideArea")
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_MissionAreaWarning )
			if( GZCommon.isOutOfMissionEffectEnable == false ) then
				-- クリア条件を満たしていない場合圏外エフェクトは有効
				GZCommon.isOutOfMissionEffectEnable = true
				-- ミッション圏外警告エフェクト有効
				GZCommon.OutsideAreaEffectEnable()
				-- ミッション圏外iDoroid音声再生開始
				GZCommon.OutsideAreaVoiceStart()
			end
		else
			-- ミッションクリア圏外無線
			TppRadio.Play("Radio_MissionClear_Warning_OutsideArea")
			if( GZCommon.isOutOfMissionEffectEnable == true ) then
				-- クリア条件を満たしていれば圏外エフェクトは無効
				GZCommon.isOutOfMissionEffectEnable = false
				-- ミッション圏外警告エフェクト無効
				GZCommon.OutsideAreaEffectDisable()
				-- ミッション圏外iDoroid音声再生停止
				GZCommon.OutsideAreaVoiceEnd()
			end
		end
	else
		-- ミッションクリア圏外無線
		TppRadio.Play("Radio_MissionClear_Warning_OutsideArea")
		if( GZCommon.isOutOfMissionEffectEnable == true ) then
			-- クリア条件を満たしていれば圏外エフェクトは無効
			GZCommon.isOutOfMissionEffectEnable = false
			-- ミッション圏外警告エフェクト無効
			GZCommon.OutsideAreaEffectDisable()
			-- ミッション圏外iDoroid音声再生停止
			GZCommon.OutsideAreaVoiceEnd()
		end
	end
end

-- commonOutsideMissionEscapeArea
local commonOutsideMissionEscapeArea = function()
	local sequence	= TppSequence.GetCurrentSequence()
	local clearflag = false
	Fox.Log( "commonOutsideMissionEscapeArea"..sequence )
	-- ミッション
	if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" or sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) then
		-- クリア条件判定
		clearflag = commonGetMissionEscapeAreaEnemy( true, false, false, false )
		if( clearflag == true ) then
			-- 敵兵士＆捕虜アナウンスログ
			commonGetMissionEscapeAreaEnemy( false, false, false, true )
			-- ミッション達成アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_MissionGoal )
			-- 要人２名を回収した
			if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
				TppMission.SetFlag( "isMT_SquadKill", 2 )
				TppMission.SetFlag( "isMT_CenterKill", 2 )
			elseif( sequence == "Seq_Waiting_KillMT_Center") then
				TppMission.SetFlag( "isMT_CenterKill", 2 )
			elseif( sequence == "Seq_Waiting_KillMT_Squad") then
				TppMission.SetFlag( "isMT_SquadKill", 2 )
			end
			-- ミッションクリア
			TppSequence.ChangeSequence( "Seq_MissionClearEscapeMissionArea" )
		else
			-- ミッション失敗
			TppSequence.ChangeSequence( "Seq_Mission_FailedPlayerEscapeMissionArea" )
		end
	-- ミッションクリア
	elseif( sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
		-- アナウンスログ
		commonGetMissionEscapeAreaEnemy( false, false, false, true )
		-- ミッションクリア
		TppSequence.ChangeSequence( "Seq_MissionClearEscapeMissionArea" )
	end
end

-- commonSequenceChangeMissionWarningArea
local commonSequenceChangeMissionWarningArea = function()
	local sequence	= TppSequence.GetCurrentSequence()
	local clearflag = false
	Fox.Log( "commonSequenceChangeMissionWarningArea"..sequence )
	-- プレイヤーがミッション圏外警告エリアにいる
	if( GZCommon.isPlayerWarningMissionArea == true ) then
		if( sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
			clearflag = true
		else
			-- クリア条件判定
			clearflag = commonGetMissionEscapeAreaEnemy( true, false, false, false )
		end
		if( clearflag == false ) then
			if( GZCommon.isOutOfMissionEffectEnable == false ) then
				-- クリア条件を満たしていない場合圏外エフェクトは有効
				GZCommon.isOutOfMissionEffectEnable = true
				-- ミッション圏外警告エフェクト有効
				GZCommon.OutsideAreaEffectEnable()
				-- ミッション圏外iDoroid音声再生開始
				GZCommon.OutsideAreaVoiceStart()
			end
		else
			if( GZCommon.isOutOfMissionEffectEnable == true ) then
				-- クリア条件を満たしていれば圏外エフェクトは無効
				GZCommon.isOutOfMissionEffectEnable = false
				-- ミッション圏外警告エフェクト無効
				GZCommon.OutsideAreaEffectDisable()
				-- ミッション圏外iDoroid音声再生停止
				GZCommon.OutsideAreaVoiceEnd()
			end
		end
	end
end

---------------------------------------------------------------------------------
-- ■■ MissionSetup Functions
---------------------------------------------------------------------------------
-- commononMissionPrepare
local commonMissionPrepare = function( manager )
	local sequence = TppSequence.GetCurrentSequence()
	local weapons = GZWeapon.e20020_SetWeapons
	local hardmode = TppGameSequence.GetGameFlag("hardmode")	-- 現在の難易度を取得
	if( hardmode == true ) then
		weapons = GZWeapon.e20020_SetWeaponsHard
	end
	Fox.Log("commonMissionPrepare sequence:"..sequence )
	if( sequence == "Seq_MissionPrepare" or manager:IsStartingFromResearvedForDebug() ) then
		-- 初期装備品設定
		if( this.DebugSetSniperRifle == true ) then
			weapons = GZWeapon.e20020_SetWeaponsDebugSetSniperRifle
		end
		TppPlayer.SetWeapons( weapons )
		-- 難易度別にこれまでの戦績に応じて報酬アイテムを設置。同時にミッション開始時点でのBestRankを保持しておく
		this.tmpBestRank = GZCommon.CheckClearRankReward( this.missionID, this.ClearRankRewardList )
		Fox.Log("***e20020.tmpBestRank_IS__"..this.tmpBestRank)
	end
end
-- commonMissionSetup
local commonMissionSetup = function()
	Fox.Log("CommonMissionSetup")
	-- 時間、天候は固定
	TppClock.SetTime( "14:00:00" )
	TppClock.Stop()
	TppWeather.SetWeather( "sunny" )
	WeatherManager.RequestTag("default", 0 )
	-- マッハバンド軽減
	GrTools.SetLightingColorScale(4.0)
	-- 天候システムでLUTを指定する対処するスクリプト
	TppEffectUtility.SetColorCorrectionLut( "common_clearSky_a_FILTERLUT" )
	-- テクスチャロード待ち処理
	MissionManager.SetMiddleTextureWaitParameter( 0.5, 5 )
	-- 保持したくないフラグを初期化
	commonMissionFlagRestore()
	-- パスのドアを開けておく
	TppGimmick.OpenDoor( "Paz_PickingDoor00", 270 )
	-- 保持すべきリアルタイム無線のフラグを保持
	TppRadio.SetAllSaveRadioId()
	-- 管理棟巨大ゲート車両セットアップ
	GZCommon.Common_CenterBigGateVehicleSetup( this.cpID, "TppGroupVehicleRouteInfo_VehicleMT01_to_Outside", "e20020_route_MT01_00_0000_V_Escape01", "e20020_route_MT01_00_0000_V_Escape02", 0, "NotClose" )
	-- プレイヤーがミッション圏外警告エリアに入ってる初期化
	GZCommon.isPlayerWarningMissionArea = false
	-- ミッションセットアップ
	if( TppMission.GetFlag( "isMissionSetupInit" ) == false ) then
		-- トラックの上にスナイパーライフル設置
		TppNewCollectibleUtility.PutCollectibleOnCharacter{ id = "WP_sr01_v00", count = 20, target = this.VehicleID_Western02, attachPoint = "CNP_USERITEM" }
		-- 初期化完了
		TppMission.SetFlag( "isMissionSetupInit", true )
	end
end
-- commonDemoBlockSetup
local commonDemoBlockSetup = function()
	Fox.Log("commonDemoBlockSetup")
	local demoBlockPath = "/Assets/tpp/pack/mission/extra/e20020/e20020_d01.fpk"
	TppMission.LoadDemoBlock( demoBlockPath )
	TppMission.LoadEventBlock("/Assets/tpp/pack/location/gntn/gntn_heli.fpk" )
end
-- commonUiMissionPhotoSetup
local commonUiMissionPhotoSetup = function()
	Fox.Log("commonUiMissionPhotoSetup")
	local sequence = TppSequence.GetCurrentSequence()
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
		return
	end
	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
		return
	end
	-- ミッション写真
	if( TppMission.GetFlag( "isMissionPhotoInit" ) == false ) then
		-- ミッション写真初期化
		luaData:ClearAllMissionPhotoIds()
		-- 要人Ａ：目
		luaData:EnableMissionPhotoId( this.PhotoID_MT_Center )
		-- ミッション写真付加写真
		if( luaData:IsMissionPhotoIdEnable( this.PhotoID_MT_Center ) ) then
			luaData:SetAdditonalMissionPhotoId( this.PhotoID_MT_Center, true ,false )	-- 右に付加写真
		end
		-- 要人Ｂ：指
		luaData:EnableMissionPhotoId( this.PhotoID_MT_Squad )
		-- ミッション写真付加写真
		if( luaData:IsMissionPhotoIdEnable( this.PhotoID_MT_Squad ) ) then
			luaData:SetAdditonalMissionPhotoId( this.PhotoID_MT_Squad, false ,true )	-- 左に付加写真
		end
		-- 初期化完了
		TppMission.SetFlag( "isMissionPhotoInit", true )
	end
	-- ミッション写真達成済み
	if( TppMission.GetFlag( "isMT_CenterKill" ) ~= 0 ) then
		-- ミッション達成済みにする
		commonUiMissionPhotoChange( this.CharacterID_MT_Center )
	end
	if( TppMission.GetFlag( "isMT_SquadKill" ) ~= 0 ) then
		-- ミッション達成済みにする
		commonUiMissionPhotoChange( this.CharacterID_MT_Squad )
	end
	-- 中間目標設定
	if( sequence == "Seq_Waiting_KillMT_Squad_and_Center" ) then
		-- ２名の要人を排除
		commonUiMissionSubGoalNo( this.MissionSubGoal_VipKillTwo )
	elseif( sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_KillMT_Squad" ) then
		-- 残りの要人を排除
		commonUiMissionSubGoalNo( this.MissionSubGoal_VipKillOne )
	elseif( sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
		-- 収容施設から脱出せよ
		commonUiMissionSubGoalNo( this.MissionSubGoal_Escape )
	end
	-- マップアイコンの説明文
	luaData:SetupIconUniqueInformationTable(
		-- 脱出
		 { markerId = this.MarkerID_EscapeWest,								langId = "marker_info_place_02" }				-- 脱出ポイント
		,{ markerId = this.MarkerID_EscapeNorth,							langId = "marker_info_place_02" }				-- 脱出ポイント
		-- 車両
		,{ markerId = "Tactical_Vehicle_WEST_001", 							langId = "marker_info_vehicle_4wd" }			-- ビークル
		,{ markerId = "Tactical_Vehicle_WEST_002", 							langId = "marker_info_vehicle_4wd" }			-- ビークル
		,{ markerId = "Tactical_Vehicle_WEST_003", 							langId = "marker_info_vehicle_4wd" }			-- ビークル
		,{ markerId = "Armored_Vehicle_WEST_001", 							langId = "marker_info_APC" }					-- 機銃装甲車
		,{ markerId = "Cargo_Truck_WEST_000", 								langId = "marker_info_truck" }					-- トラック
		,{ markerId = "Cargo_Truck_WEST_001", 								langId = "marker_info_truck" }					-- トラック
		-- 尋問用：汎用アイテム類
		,{ markerId = "e20020_marker_Ammo", 								langId = "marker_info_bullet_tranq" }			-- 非殺傷弾
		,{ markerId = "e20020_marker_C4_01", 								langId = "marker_info_weapon_06" }				-- Ｃ４
		,{ markerId = "e20020_marker_C4_02", 								langId = "marker_info_weapon_06" }				-- Ｃ４
		,{ markerId = "e20020_marker_Claymore", 							langId = "marker_info_weapon_08" }				-- クレイモア
		,{ markerId = "e20020_marker_Grenade", 								langId = "marker_info_weapon_07" }				-- グレネード
		,{ markerId = "e20020_marker_Handgun_01", 							langId = "marker_info_weapon_00" }				-- ハンドガン
		,{ markerId = "e20020_marker_Handgun_02", 							langId = "marker_info_weapon_00" }				-- ハンドガン
		,{ markerId = "e20020_marker_MonlethalWeapon",						langId = "marker_info_weapon" }					-- リボルバーショットガン
		,{ markerId = "e20020_marker_Missile", 								langId = "marker_info_weapon_02" }				-- 無反動砲
		,{ markerId = "e20020_marker_SmokeGrenades", 						langId = "marker_info_weapon_05" }				-- スモークグレネード
		,{ markerId = "e20020_marker_SniperRifle", 							langId = "marker_info_weapon_01" }				-- スナイパーライフル
		,{ markerId = "e20020_marker_SubAmmo01", 							langId = "marker_info_bullet_tranq" }			-- 非殺傷弾
		,{ markerId = "e20020_marker_SubAmmo02", 							langId = "marker_info_bullet_artillery" }		-- 砲弾
		,{ markerId = "e20020_marker_SubmachineGun", 						langId = "marker_info_weapon_04" }				-- サブマシンガン
		,{ markerId = "e20020_marker_ShotGun", 								langId = "marker_info_weapon_03" }				-- ショットガン
		,{ markerId = "e20020_marker_Cassette", 							langId = "marker_info_item_tape" }				-- カセットテープ
		-- 尋問用：エリア
		,{ markerId = "common_marker_Area_Asylum", 							langId = "marker_info_area_05" }				-- 旧収容施設
		,{ markerId = "common_marker_Area_EastCamp", 						langId = "marker_info_area_00" }				-- 東難民キャンプ
		,{ markerId = "common_marker_Area_WestCamp", 						langId = "marker_info_area_01" }				-- 西難民キャンプ
		,{ markerId = "common_marker_Area_Center", 							langId = "marker_info_area_04" }				-- 管理棟
		,{ markerId = "common_marker_Area_HeliPort", 						langId = "marker_info_area_03" }				-- ヘリポート
		,{ markerId = "common_marker_Area_WareHouse", 						langId = "marker_info_area_02" }				-- 倉庫
		-- 尋問用：武器庫
		,{ markerId = "common_marker_Armory_Center", 						langId = "marker_info_place_armory" }			-- 武器庫
		,{ markerId = "common_marker_Armory_HeliPort", 						langId = "marker_info_place_armory" }			-- 武器庫
		,{ markerId = "common_marker_Armory_WareHouse", 					langId = "marker_info_place_armory" }			-- 武器庫
		-- 尋問用：監視カメラ
		,{ markerId = "e20020_SecurityCamera_01", 							langId = "marker_info_Surveillance_camera" }	-- 監視カメラ
		,{ markerId = "e20020_SecurityCamera_02", 							langId = "marker_info_Surveillance_camera" }	-- 監視カメラ
		,{ markerId = "e20020_SecurityCamera_03", 							langId = "marker_info_Surveillance_camera" }	-- 監視カメラ
		,{ markerId = "e20020_SecurityCamera_05", 							langId = "marker_info_Surveillance_camera" }	-- 監視カメラ
	)
	-- 要人Ｂのマップアイコン説明文
	commonMTSquadIconUniqueInformation()
	-- 要人Ａのマップアイコン説明文
	commonMTCenterIconUniqueInformation()
end
-- commonRadioMissionSetup
local commonRadioMissionSetup = function()
	Fox.Log("commonRadioMissionSetup")
	-- ユニーク敵兵の諜報無線
	TppRadio.EnableIntelRadio( this.CharacterID_MT_Center )
	TppRadio.EnableIntelRadio( this.CharacterID_MT_Squad )
	TppRadio.EnableIntelRadio( this.CharacterID_E_Vehicle01 )
	TppRadio.EnableIntelRadio( this.CharacterID_E_Imitation )
	TppRadio.EnableIntelRadio( this.CharacterID_E_Imitation )
	-- 敵兵の諜報無線
	TppRadio.EnableIntelRadio( "Enemy_US_Asylum000" )
	TppRadio.EnableIntelRadio( "Enemy_US_bridge000" )
	TppRadio.EnableIntelRadio( "Enemy_US_center000" )
	TppRadio.EnableIntelRadio( "Enemy_US_center001" )
	TppRadio.EnableIntelRadio( "Enemy_US_center002" )
	TppRadio.EnableIntelRadio( "Enemy_US_center003" )
	TppRadio.EnableIntelRadio( "Enemy_US_eastTentGroup_north000" )
	TppRadio.EnableIntelRadio( "Enemy_US_Heliport000" )
	TppRadio.EnableIntelRadio( "Enemy_US_Heliport001" )
	TppRadio.EnableIntelRadio( "Enemy_US_Heliport002" )
	TppRadio.EnableIntelRadio( "Enemy_US_Heliport003" )
	TppRadio.EnableIntelRadio( "Enemy_US_Heliport004" )
	TppRadio.EnableIntelRadio( "Enemy_US_MissionTargetSquad001" )
	TppRadio.EnableIntelRadio( "Enemy_US_Seaside000" )
	TppRadio.EnableIntelRadio( "Enemy_US_Stryker000" )
	TppRadio.EnableIntelRadio( "Enemy_US_WareHouse000" )
	TppRadio.EnableIntelRadio( "Enemy_US_WareHouse001" )
	TppRadio.EnableIntelRadio( "Enemy_US_westTentGroup_north000" )
	TppRadio.EnableIntelRadio( "Enemy_US_westTentGroup_north001" )
	TppRadio.EnableIntelRadio( "Enemy_US_WoodTurret000" )
	TppRadio.EnableIntelRadio( "Enemy_US_MissionTargetCenterSquad000" )
	TppRadio.EnableIntelRadio( "Enemy_US_MissionTargetCenterSquad001" )
	TppRadio.EnableIntelRadio( "Enemy_US_Vehicle001" )
	TppRadio.EnableIntelRadio( "Enemy_US_Western000" )
	TppRadio.EnableIntelRadio( "Enemy_US_eastTent_south000" )
	TppRadio.EnableIntelRadio( "Enemy_US_IronTurret000" )
	TppRadio.EnableIntelRadio( "Enemy_US_WareHouse002" )
	TppRadio.EnableIntelRadio( "Enemy_US_eastTent_north000" )
	TppRadio.EnableIntelRadio( "Enemy_US_eastTent_north001" )
	TppRadio.EnableIntelRadio( "Enemy_US_westTent000" )
	TppRadio.EnableIntelRadio( "Enemy_US_westTent001" )
	TppRadio.EnableIntelRadio( "Enemy_US_IronTurret001" )
	TppRadio.EnableIntelRadio( "Enemy_US_Reinforce004" )
	TppRadio.EnableIntelRadio( "Enemy_US_Reinforce005" )
	TppRadio.EnableIntelRadio( "Enemy_US_Reinforce006" )
	TppRadio.EnableIntelRadio( "Enemy_US_Reinforce007" )
	TppRadio.EnableIntelRadio( "Enemy_US_Reinforce001" )
	TppRadio.EnableIntelRadio( "Enemy_US_Reinforce000" )
	TppRadio.EnableIntelRadio( "Enemy_US_Reinforce002" )
	TppRadio.EnableIntelRadio( "Enemy_US_Reinforce003" )
	-- やぐら
	TppRadio.EnableIntelRadio( "WoodTurret01" )
	TppRadio.EnableIntelRadio( "WoodTurret02" )
	TppRadio.EnableIntelRadio( "WoodTurret03" )
	TppRadio.EnableIntelRadio( "WoodTurret04" )
	TppRadio.EnableIntelRadio( "WoodTurret05" )
	-- ドラム缶
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
	TppRadio.EnableIntelRadio( "e20020_SecurityCamera_01" )
	TppRadio.EnableIntelRadio( "e20020_SecurityCamera_02" )
	TppRadio.EnableIntelRadio( "e20020_SecurityCamera_03" )
	TppRadio.EnableIntelRadio( "e20020_SecurityCamera_05" )
	-- トラック
	if( TppMission.GetFlag( "isIntelRadio_Western" ) == false and TppMission.GetFlag( "isPlayerGetTruckSniper" ) == false ) then
		-- 諜報無線オン
		TppRadio.EnableIntelRadio( this.VehicleID_Western02 )
		-- トラックの諜報無線
		TppRadio.RegisterIntelRadio( this.VehicleID_Western02, "e0020_esrg0100", true )
	else
		-- 諜報無線オン
		TppRadio.EnableIntelRadio( this.VehicleID_Western02 )
		-- トラックの諜報無線
		TppRadio.RegisterIntelRadio( this.VehicleID_Western02, "f0090_esrg0050", true )
	end
	-- 倉庫にあるトラック
	TppRadio.EnableIntelRadio( "Cargo_Truck_WEST_000" )
	-- 機銃装甲車
	TppRadio.EnableIntelRadio( this.VehicleID_ArmoredVehicle )
	-- 汎用無線
	commonRegisterRadioCondition( "ON" )
	-- 逃げ込む建物 要人Ａ
	commonMT_Center_DisableIntelRadio( true )
	-- 逃げ込む建物 要人Ｂ
	commonMT_Squad_DisableIntelRadio( true )
end

-- commonEnemyMissionSetup
local commonEnemyMissionSetup = function( manager, iCheckPointFlag, iAfterRestoreFlag )
	Fox.Log("commonEnemyMissionSetup")
			iCheckPointFlag		= iCheckPointFlag or false
			iAfterRestoreFlag	= iAfterRestoreFlag or false
	local	state				= TppMission.GetFlag( "isMT_Squad_StateMove" )
	local	sequence			= TppSequence.GetCurrentSequence()
	-----------------------------------------------------------------------------------------------
	-- キープアラート設定
	commonKeepPhaseAlert( "OFF" )
	-- タイムルートチェンジテーブル初期化
	commonTimerRouteChageTableSetup()
	-- ＶＩＰグループ設定
	commonRegisterVipMember_MTSquad()
	commonRegisterVipMember_MTCenter()
	-- 増援発生時の武器設定
	TppCommandPostObject.GsAddRespawnRandomWeaponId( this.cpID, "WP_sg01_v00",	30 )	-- 30%でショットガン
	TppCommandPostObject.GsAddRespawnRandomWeaponId( this.cpID, "WP_ms02",		10 )	-- 10%で無反動砲
	-- ＭＴ敵兵をリスポンの対象外にする
	TppCommandPostObject.GsSetDisableRespawn( this.cpID, this.CharacterID_MT_Center )
	TppCommandPostObject.GsSetDisableRespawn( this.cpID, this.CharacterID_MT_Squad )
	-- 尋問データ
	commonInterrogationEnemy( true )
	-- ヘリ回収時に共通のアナウンスログを出さない設定
	GZCommon.EnemyLaidonHeliNoAnnounceSet( this.CharacterID_MT_Center )
	GZCommon.EnemyLaidonHeliNoAnnounceSet( this.CharacterID_MT_Squad )
	-- ミッション圏外で車両連携終了した名前を初期化
	this.CounterList.VehicleEndName_Vehicle = "NoName"
	this.CounterList.VehicleEndName_Western = "NoName"
	-----------------------------------------------------------------------------------------------
	-- シーケンススキップ時or初期化時
	if( iCheckPointFlag == false or TppMission.GetFlag( "isEnemyDisableRouteInit" ) == false ) then
		-- シーケンスキップ時初回時のみ
		if( iCheckPointFlag == true ) then
			-- ＭＴ倉庫のフラグでＭＴ管理棟フラグ状態の変更を行う。
			-- 待機
			if( state >= 0 and state <= 5 ) then
				TppMission.SetFlag( "isMT_Center_StateMove", 0 )
			-- 収容施設巡回
			elseif( state == 6 ) then
				TppMission.SetFlag( "isMT_Center_StateMove", 2 )
			-- ヘリポートへ移動開始
			elseif( state >= 7 and state <= 8 ) then
				TppMission.SetFlag( "isMT_Center_StateMove", 4 )
			-- 倉庫へ移動開始
			elseif( state >= 9 and state <= 10 ) then
				TppMission.SetFlag( "isMT_Center_StateMove", 5 )
			-- 東側テントへ移動開始
			elseif( state == 11 ) then
				TppMission.SetFlag( "isMT_Center_StateMove", 6 )
			-- 東側テントへ巡回開始
			elseif( state == 12 ) then
				TppMission.SetFlag( "isMT_Center_StateMove", 7 )
			-- ヘリポートへ移動開始
			elseif( state >= 13 and state <= 14 ) then
				TppMission.SetFlag( "isMT_Center_StateMove", 8 )
			-- ヘリポート前待機開始
			elseif( state == 15 ) then
				TppMission.SetFlag( "isMT_Center_StateMove", 9 )
			-- ヘリポート会話開始
			elseif( state == 16 ) then
				TppMission.SetFlag( "isMT_Center_StateMove", 11 )
			-- ミッション圏外へ移動開始
			elseif( state == 17 ) then
				TppMission.SetFlag( "isMT_Center_StateMove", 12 )
			-- ＭＴ倉庫１人でミッション圏外へ移動開始
			elseif( state >= 20 ) then
				TppMission.SetFlag( "isMT_Center_StateMove", 9 )
			end
			-- ＭＴ倉庫が移動していた場合
			if( state >= 2 or TppMission.GetFlag( "isMT_SquadKill"	) ~= 0 or TppMission.GetFlag( "isMT_CenterKill" ) ~= 0 ) then
				TppMission.SetFlag( "isEnemy_eastTent01_StateMove", 2 )		-- 海岸
				TppMission.SetFlag( "isEnemy_eastTent02_StateMove", 2 )		-- 倉庫
			end
			-- ＭＴ倉庫がビークル移動した場合は、ビークル兵＆トラック兵を強制ＯＦＦする
			if( state >= 3 or sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" ) then
				TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 999 )
				TppMission.SetFlag( "isEnemy_Western01_StateMove", 999 )
				TppMission.SetFlag( "isEnemy_Imitation_StateMove", 999 )
			end
			if( TppMission.GetFlag( "isDebug_EscapeArea_West" ) == true or TppMission.GetFlag( "isDebug_EscapeArea_East" ) == true ) then
				TppMission.SetFlag( "isEnemy_Vehicle_StateMove", 999 )
				TppMission.SetFlag( "isEnemy_Western01_StateMove", 999 )
				TppMission.SetFlag( "isEnemy_Imitation_StateMove", 999 )
			end
			-- トラック兵のフラグで付き添い兵フラグ状態の変更を行う。
			if( TppMission.GetFlag( "isEnemy_Western01_StateMove" ) == 3 ) then
				TppMission.SetFlag( "isEnemy_Imitation_StateMove", 4 )
			end
			-- 要人Ａを殺す
			if( sequence == "Seq_Waiting_KillMT_Squad" or sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" or TppMission.GetFlag( "isMT_CenterKill" ) ~= 0 ) then
				TppEnemy.KillEnemy( this.CharacterID_MT_Center )
				TppMission.SetFlag( "isMT_CenterKill", 1 )
				if( TppMission.GetFlag( "isMT_SquadKill" ) == 1 ) then
					TppEnemyUtility.KillEnemy( this.CharacterID_MT_Center )
				elseif( TppMission.GetFlag( "isMT_SquadKill" ) == 2 ) then
					TppEnemyUtility.SetEnableCharacterId( this.CharacterID_MT_Center, false )
				end
			end
			-- 要人Ｂを殺す
			if( sequence == "Seq_Waiting_KillMT_Center" or sequence == "Seq_Waiting_MissionClearPlayerRideHelicopter" or TppMission.GetFlag( "isMT_SquadKill" ) ~= 0 ) then
				if( TppMission.GetFlag( "isMT_SquadKill" ) == 0 ) then
					TppMission.SetFlag( "isMT_SquadKill", 1 )
				end
				if( TppMission.GetFlag( "isMT_SquadKill" ) == 1 ) then
					TppEnemyUtility.KillEnemy( this.CharacterID_MT_Squad )
				elseif( TppMission.GetFlag( "isMT_SquadKill" ) == 2 ) then
					TppEnemyUtility.SetEnableCharacterId( this.CharacterID_MT_Squad, false )
				end
			end
			-- ビークル兵：ミッション圏外からスタートの場合はミッション圏外へ出たビークル名を設定
			if( TppMission.GetFlag( "isEnemy_Vehicle_StateMove" ) == 4 or TppMission.GetFlag( "isEnemy_Vehicle_StateMove" ) == 999 ) then
				-- 車両連携終了したビークルの名前
				this.CounterList.VehicleEndName_Vehicle = this.VehicleID_Vehicle01
			end
			-- トラック兵：ミッション圏外からスタートの場合はミッション圏外へ出たビークル名を設定
			if( TppMission.GetFlag( "isEnemy_Western01_StateMove" ) == 5 or TppMission.GetFlag( "isEnemy_Western01_StateMove" ) == 999 ) then
				-- 車両連携終了したビークルの名前
				this.CounterList.VehicleEndName_Western = this.VehicleID_Western02
			end
		end
		-- ルート初期化
		commonMTSquadRouteDisable(			iCheckPointFlag, false, false )
		commonMTCenterRouteDisable(			iCheckPointFlag, false )
		commonEnemyVehicleRouteDisable(		iCheckPointFlag, false, false )
		commonEnemyImitationRouteDisable(	iCheckPointFlag, false )
		commonEnemyWestern01RouteDisable(	iCheckPointFlag, false )
		commonEnemyReinforceRouteDisable(	iCheckPointFlag, false )
		commonEnemyRouteDisable(			iCheckPointFlag, false )
		-- シーケンスキップ時初回時のみ
		if( iCheckPointFlag == true ) then
			commonPrint2D("シーケンススキップしました。" , 2 )
			-- 敵兵座標変更
			commonMT_Sqaud_RegisterPoint(			manager, TppMission.GetFlag( "isMT_Squad_StateMove" ),			true )
			commonMT_Center_RegisterPoint(			manager, TppMission.GetFlag( "isMT_Center_StateMove" ),			true )
			commonEnemy_Vehicle_RegisterPoint(		manager, TppMission.GetFlag( "isEnemy_Vehicle_StateMove" ),		true )
			commonEnemy_Western01_RegisterPoint(	manager, TppMission.GetFlag( "isEnemy_Western01_StateMove" ),	true )
			commonEnemy_Imitation_RegisterPoint(	manager, TppMission.GetFlag( "isEnemy_Imitation_StateMove" ),	true )
			commonEnemy_eastTent01_RegisterPoint( 	manager, TppMission.GetFlag( "isEnemy_eastTent01_StateMove" ),	true )
			commonEnemy_eastTent02_RegisterPoint(	manager, TppMission.GetFlag( "isEnemy_eastTent02_StateMove" ),	true )
			-- ルート設定
			commonEnemy_Vehicle_StateMove(			"SequenceSkip", manager )
			commonEnemy_Imitation_StateMove(		"SequenceSkip", manager )
			commonEnemy_Western01_StateMove(		"SequenceSkip", manager )
			commonEnemy_eastTent01_StateMove(		"SequenceSkip", manager )
			commonEnemy_eastTent02_StateMove(		"SequenceSkip", manager )
			commonEnemy_Reinforce_StateMove(		"SequenceSkip", manager )
			-- ターゲットは最後に設定
			commonMT_Squad_StateMove(				"SequenceSkip", manager )
			commonMT_Center_StateMove(				"SequenceSkip", manager )
			-- 敵兵ルートセット設定※スニークルート設定
			TppCommandPostObject.GsSetCurrentRouteSet( this.cpID , this.RouteSet_Sneak, true, true, true, true )
		else
			-- ルート設定
			commonEnemy_Vehicle_StateMove(			"Init", manager )
			commonEnemy_Imitation_StateMove(		"Init", manager )
			commonEnemy_Western01_StateMove(		"Init", manager )
			commonEnemy_eastTent01_StateMove(		"Init", manager )
			commonEnemy_eastTent02_StateMove(		"Init", manager )
			commonEnemy_Reinforce_StateMove(		"Init", manager )
			-- ターゲットは最後に設定
			commonMT_Squad_StateMove(				"Init", manager )
			commonMT_Center_StateMove(				"Init", manager )
			-- 敵兵ルートセット設定※スニークルート設定
			TppCommandPostObject.GsSetCurrentRouteSet( this.cpID , this.RouteSet_Sneak, false, false, false, false )
		end
		-- 初期化完了
		TppMission.SetFlag( "isEnemyDisableRouteInit", true )
	-- コンティニュー時
	else
		-- 更新可能の時に敵兵の状態を行う
		if( iAfterRestoreFlag == false ) then
			commonPrint2D("コンティニューしました。※更新不可" , 2 )
			-- 敵兵座標変更
			commonMT_Sqaud_RegisterPoint(			manager, TppMission.GetFlag( "isMT_Squad_StateMove" ),			false )
			commonMT_Center_RegisterPoint(			manager, TppMission.GetFlag( "isMT_Center_StateMove" ),			false )
			commonEnemy_Vehicle_RegisterPoint(		manager, TppMission.GetFlag( "isEnemy_Vehicle_StateMove" ),		false )
			commonEnemy_Western01_RegisterPoint(	manager, TppMission.GetFlag( "isEnemy_Western01_StateMove" ),	false )
			commonEnemy_Imitation_RegisterPoint(	manager, TppMission.GetFlag( "isEnemy_Imitation_StateMove" ),	false )
			commonEnemy_eastTent01_RegisterPoint(	manager, TppMission.GetFlag( "isEnemy_eastTent01_StateMove" ),	false )
			commonEnemy_eastTent02_RegisterPoint(	manager, TppMission.GetFlag( "isEnemy_eastTent02_StateMove" ),	false )
		else
			commonPrint2D("コンティニューしました。※更新可能" , 2 )
			-- ユニークキャラステータス状態設定
			commonEnemy_Vehicle_StateMove(		"CheckPoint", manager )
			commonEnemy_Imitation_StateMove(	"CheckPoint", manager )
			commonEnemy_Western01_StateMove(	"CheckPoint", manager )
			commonEnemy_eastTent01_StateMove(	"CheckPoint", manager )
			commonEnemy_eastTent02_StateMove(	"CheckPoint", manager )
			commonEnemy_Reinforce_StateMove(	"CheckPoint", manager )
			-- ターゲットは最後に設定
			commonMT_Squad_StateMove(			"CheckPoint", manager )
			commonMT_Center_StateMove(			"CheckPoint", manager )
			-- 敵兵ルートセット設定※スニークに戻す
			TppCharacterUtility.ResetPhase()
			TppCommandPostObject.GsSetCurrentRouteSet( this.cpID , this.RouteSet_Sneak, true, true, true, true )
		end
	end
	-----------------------------------------------------------------------------------------------
	-- シーケンススキップ時or初期化時
	if( iCheckPointFlag == false or TppMission.GetFlag( "isEnemyMarkerInit" ) == false )  then
		-- エリアマーカー設定
		commonAreaMarkerMTSquad( true, false, false, true, true, true )
		commonAreaMarkerMTCenter( true, false, false, true, true, true )
		-- 初期化完了
		TppMission.SetFlag( "isEnemyMarkerInit", true )
	else
		if( iAfterRestoreFlag == true ) then
			-- エリアマーカー設定
			commonAreaMarkerMTSquad( true, false, false, true, true, true )
			commonAreaMarkerMTCenter( true, false, false, true, true, true )
		end
	end
	-- ターゲットマーカー
	if( iCheckPointFlag == true ) then
		-- ＭＴ倉庫
		commonTargetMarker( "ON", this.CharacterID_MT_Squad, true )
		-- ＭＴ管理棟
		commonTargetMarker( "ON", this.CharacterID_MT_Center, true )
	end
	-----------------------------------------------------------------------------------------------
	-- シーケンススキップ時or初期化時
	if( iCheckPointFlag == false or TppMission.GetFlag( "isEnemyCombatInit" ) == false )  then
		-- ガードターゲット設定
		commonMTCenter_GuardTarget()
		commonMTSquad_GuardTarget()
		-- 初期化完了
		TppMission.SetFlag( "isEnemyCombatInit", true )
	else
		if( iAfterRestoreFlag == true ) then
			-- ガードターゲット設定
			commonMTCenter_GuardTarget()
			commonMTSquad_GuardTarget()
		end
	end
	-----------------------------------------------------------------------------------------------
	--要人排除では優先OFF
	TppCommandPostObject.GsSetPriorityCombatLocator( this.cpID, "TppCombatLocatorData0167", false )
	TppCommandPostObject.GsSetPriorityCombatLocator( this.cpID, "TppCombatLocatorData0095", false )
	TppCommandPostObject.GsSetPriorityCombatLocator( this.cpID, "TppCombatLocatorData0000", false )
	TppCommandPostObject.GsSetPriorityCombatLocator( this.cpID, "TppCombatLocatorData0106", false )
	TppCommandPostObject.GsSetPriorityCombatLocator( this.cpID, "TppCombatLocatorData0057", false )
	--要人排除では優先ON
	TppCommandPostObject.GsSetPriorityCombatLocator( this.cpID, "TppCombatLocatorData0010", true )
	TppCommandPostObject.GsSetPriorityCombatLocator( this.cpID, "TppCombatLocatorData0121", true )
end

-- commonMissionLoadSetup
local commonMissionLoadSetup = function( manager, iCheckPointFlag, iAfterRestoreFlag )
	Fox.Log("commonMissionLoadSetup")
	iCheckPointFlag = iCheckPointFlag or false
	-- 保存したくないミッションフラグを初期化
	commonMissionFlagRestore()
	-- 無線セットアップ
	commonRadioMissionSetup()
	-- 敵兵セットアップ
	commonEnemyMissionSetup( manager, iCheckPointFlag, iAfterRestoreFlag )
	-- ＵＩセットアップ
	commonUiMissionPhotoSetup()
end

---------------------------------------------------------------------------------
-- ■■ Skip Functions
---------------------------------------------------------------------------------
-- this.OnSkipEnterCommon
this.OnSkipEnterCommon = function( manager )
	Fox.Log("this.OnSkipEnterCommon")
	local sequence = TppSequence.GetCurrentSequence()
	-- do prepare
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionPrepare" ) ) then
		commonMissionPrepare( manager )
	end
	-- Set all mission states
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionFailed" ) ) then
		TppMission.ChangeState( "failed" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionPrepare" ) ) then
		commonDemoBlockSetup()
	elseif( sequence == "Seq_MissionPrepare" ) then
		-- デモブロックはここで読み込んでおく
		commonDemoBlockSetup()
	end
end

-- this.OnSkipUpdateCommon
this.OnSkipUpdateCommon = function( manager )
	Fox.Log("this.OnSkipUpdateCommon")
	return IsDemoAndEventBlockActive()
end

-- this.OnSkipLeaveCommon
this.OnSkipLeaveCommon = function( manager )
	Fox.Log("this.OnSkipLeaveCommon")
	local sequence = TppSequence.GetCurrentSequence()
	-- ミッション共通処理
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionLoad" ) ) then
		-- GZ共通ミッションセットアップ
		GZCommon.MissionSetup()
		-- 共通ミッションセットアップ
		commonMissionSetup()
		-- 共通ミッションロードセットアップ
		commonMissionLoadSetup( manager, true, false )
	end
	-- デバッグ：西側ミッション圏外警告エリア前に要人２人とビークル配置
	if( TppMission.GetFlag( "isDebug_EscapeArea_West" ) == true ) then
		-- 敵兵
		TppPlayer.WarpForDebugStartInVipRestorePoint( manager, this.CharacterID_MT_Squad, 				"e20020_debug_west0000" )
		TppPlayer.WarpForDebugStartInVipRestorePoint( manager, this.CharacterID_MT_Center, 				"e20020_debug_west0001" )
		-- ビークル
		TppPlayer.WarpForDebugStartInVipRestorePoint( manager, this.VehicleID_Vehicle02, 				"e20020_debug_west0002" )
		-- 捕虜
		TppPlayer.WarpForDebugStartInVipRestorePoint( manager, this.CharacterID_Hostage_PickingDoor08, 	"e20020_debug_west0003" )
		TppPlayer.WarpForDebugStartInVipRestorePoint( manager, this.CharacterID_Hostage_PickingDoor22, 	"e20020_debug_west0004" )
		-- 敵兵を睡眠状態にする
		TppEnemyUtility.ChangeStatus( this.CharacterID_MT_Squad, "Sleep" )
		TppEnemyUtility.ChangeStatus( this.CharacterID_MT_Center, "Sleep" )
	-- デバッグ：東側ミッション圏外警告エリア前に要人２人とビークル配置
	elseif( TppMission.GetFlag( "isDebug_EscapeArea_East" ) == true ) then
		-- 敵兵
		TppPlayer.WarpForDebugStartInVipRestorePoint( manager, this.CharacterID_MT_Squad, 				"e20020_debug_east0000" )
		TppPlayer.WarpForDebugStartInVipRestorePoint( manager, this.CharacterID_MT_Center,			 	"e20020_debug_east0001" )
		-- ビークル
		TppPlayer.WarpForDebugStartInVipRestorePoint( manager, this.VehicleID_Vehicle02, 				"e20020_debug_east0002" )
		-- 捕虜
		TppPlayer.WarpForDebugStartInVipRestorePoint( manager, this.CharacterID_Hostage_PickingDoor08, 	"e20020_debug_east0003" )
		TppPlayer.WarpForDebugStartInVipRestorePoint( manager, this.CharacterID_Hostage_PickingDoor22, 	"e20020_debug_east0004" )
		-- 敵兵を睡眠状態にする
		TppEnemyUtility.ChangeStatus( this.CharacterID_MT_Squad, "Sleep" )
		TppEnemyUtility.ChangeStatus( this.CharacterID_MT_Center, "Sleep" )
	end
	-- デバッグ：配置してある全ての車両をオフする
	if( this.DebugVehicleAllDisable == true ) then
		commonPrint2D("配置してある全ての車両を表示ＯＦＦ")
		TppData.Disable( "Tactical_Vehicle_WEST_001" )
		TppData.Disable( "Tactical_Vehicle_WEST_002" )
		TppData.Disable( "Tactical_Vehicle_WEST_003" )
		TppData.Disable( "Armored_Vehicle_WEST_001" )
		TppData.Disable( "Cargo_Truck_WEST_000" )
		TppData.Disable( "Cargo_Truck_WEST_001" )
	end
end

-- this.OnAfterRestore
this.OnAfterRestore = function( manager )
	Fox.Log("this.OnAfterRestore")
	local sequence = TppSequence.GetCurrentSequence()
	-- ミッション共通処理
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionLoad" ) ) then
		-- 共通ミッションロードセットアップ
		commonMissionLoadSetup( manager, true, true )
		-- コンティニュー時車両がある場所に捕虜がいる場合にワープさせる
		GZCommon.CheckContinueHostageRegister( this.ContinueHostageRegisterList )
	end
	-- アラートフラグ初期化
	if( TppMission.GetFlag( "isAlert" ) == true )  then
		TppMission.SetFlag( "isAlert", false )
	end
	-- アラート無線フラグ初期化
	if( TppMission.GetFlag( "isRadio_AlertTargetEscape" ) == true )  then
		TppMission.SetFlag( "isRadio_AlertTargetEscape", false )
	end
	-- キープコーションフラグ初期化
	if( TppMission.GetFlag( "isKeepCaution" ) == true )  then
		TppMission.SetFlag( "isKeepCaution", false )
	end
	-- ＭＢ端末でアイコンの無線を鳴らさないフラグ初期化
	if( TppMission.GetFlag( "isRadio_FocusMapIcon" ) == true )	then
		TppMission.SetFlag( "isRadio_FocusMapIcon", false )
	end
	-- ミッション圏外エフェクトを無効
	if( GZCommon.isOutOfMissionEffectEnable == true ) then
		GZCommon.isOutOfMissionEffectEnable = false
	end

	-- 保存した諜報無線の内容をロードする
	TppRadio.RestoreIntelRadio()
end

---------------------------------------------------------------------------------
-- ■■ SequenceSave function
---------------------------------------------------------------------------------

-- ■シーケンスセーブ設定
local commonSequenceSave = function( AutoFlag, CheckPointId )
	CheckPointId	= CheckPointId or "10"
	Fox.Log( "commonSequenceSave:GZCommon.PlayerAreaName illegality:".. GZCommon.PlayerAreaName )
	-- シーケンスセーブ手動設定
	if( AutoFlag == false ) then
		-- チェックセーブ
		TppMissionManager.SaveGame( CheckPointId )
	-- シーケンスセーブ自動設定
	else
		-- ヘリで要人回収
		if( this.CounterList.HeliRendezvousPointName == "RV_HeliPort" ) then
			TppMissionManager.SaveGame("30")
		elseif( this.CounterList.HeliRendezvousPointName == "RV_SeaSide" ) then
			TppMissionManager.SaveGame("31")
		elseif( this.CounterList.HeliRendezvousPointName == "RV_StartCliff" ) then
			TppMissionManager.SaveGame("32")
		elseif( this.CounterList.HeliRendezvousPointName == "RV_WareHouse" ) then
			TppMissionManager.SaveGame("33")
		-- プレイヤーの現在地から復帰位置を決定する
		elseif( GZCommon.PlayerAreaName == "WareHouse" ) then
			TppMissionManager.SaveGame("20")
		elseif( GZCommon.PlayerAreaName == "Asylum" ) then
			TppMissionManager.SaveGame("21")
		elseif( GZCommon.PlayerAreaName == "EastCamp" ) then
			TppMissionManager.SaveGame("22")
		elseif( GZCommon.PlayerAreaName == "WestCamp" ) then
			TppMissionManager.SaveGame("23")
		elseif( GZCommon.PlayerAreaName == "Heliport" ) then
			TppMissionManager.SaveGame("24")
		elseif( GZCommon.PlayerAreaName == "ControlTower_East" ) then
			TppMissionManager.SaveGame("25")
		elseif( GZCommon.PlayerAreaName == "ControlTower_West" ) then
			TppMissionManager.SaveGame("26")
		elseif( GZCommon.PlayerAreaName == "SeaSide" ) then
			TppMissionManager.SaveGame("27")
		else
			-- 保険処理：スタート地点
			TppMissionManager.SaveGame( CheckPointId )
		end
	end
	-- ランデブーポイント名を初期化する
	this.CounterList.HeliRendezvousPointName	= "NoName"
end

---------------------------------------------------------------------------------
-- ■■ MissionClear function
---------------------------------------------------------------------------------

-- ■ミッションクリアリクエスト
local commonMissionClearRequest = function( clearType )
	Fox.Log("commonMissionClearRequest"..clearType )
	-- クリア要求前にスコア計算テーブルを設定しておく必要があるのでここでまとめる
	-- 実績解除：「サイドオプスを1つクリア」
	Trophy.TrophyUnlock( this.TrophyID_GZ_SideOpsClear )
	-- スコア計算テーブルの設定
	GZCommon.ScoreRankTableSetup( this.missionID )
	-- ミッション固有ボーナス設定
	commonMissionExternalScore()
	-- 脱出曲フェード設定
	commonCallEscapMusic( "Fade" )
	-- MissionManagerにクリアリクエストを送る
	TppMission.ChangeState( "clear", clearType )
end

-- ■ポップアップウィンドウ処理
local OnShowRewardPopupWindow = function()
	Fox.Log("OnShowRewardPopupWindow")
	-- チャレンジ要素によってアンロックされた報酬表示
	local hudCommonData = HudCommonDataManager.GetInstance()
	local challengeString = PlayRecord.GetOpenChallenge()
	local uiCommonData = UiCommonDataManager.GetInstance()
	local AllHardClear = PlayRecord.IsAllMissionClearHard()
	local AllChicoTape = GZCommon.CheckReward_AllChicoTape()
	local Rank = PlayRecord.GetRank()
	Fox.Log("-------RANK_IS__"..Rank.."__BESTRANK_IS__"..this.tmpBestRank )

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
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankC, "WP_sm00_v00", { isSup=true, isLight=true } )
		elseif ( this.tmpBestRank == 3 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankB, "WP_sg01_v00" )
		elseif ( this.tmpBestRank == 2 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankA, "WP_sr01_v00" )
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
	-- ハードモード開放
	if ( TppGameSequence.GetGameFlag("hardmode") == false and PlayRecord.GetMissionScore( 20020, "NORMAL", "CLEAR_COUNT" ) == 1 ) then -- 初回クリアなら
		-- ハード解放
		hudCommonData:ShowBonusPopupCommon( "reward_extreme" )
	end
	-- いずれのポップアップも呼ばれなかったら即座に次シーケンスへ
	if ( hudCommonData:IsShowBonusPopup() == false ) then
		Fox.Log("-------OnShowRewardPopupWindow:NoPopup!!-------")
		TppSequence.ChangeSequence( "Seq_MissionEnd" )	-- ST_CLEARから先に進ませるために次シーケンスへ
	end
end

-- ■ポップアップクローズ時の判定（今のところ報酬表示ポップアップ用）
local OnClosePopupWindow = function()
	Fox.Log("OnClosePopupWindow")
	-- CloseされたポップアップのLangIdハッシュ値
	local LangIdHash = TppData.GetArgument(1)
	-- Closeされたポップアップが報酬用のものかどうかを識別
	if ( LangIdHash == this.tmpChallengeString ) then
		-- 報酬ポップアップ表示実行
		OnShowRewardPopupWindow()
	end
end

---------------------------------------------------------------------------------
-- ■■ local Messages
---------------------------------------------------------------------------------
-- ヘリメッセージ
local SupportHeliMessages = {
	Character = {
		{ data = "Player",																message = "RideHelicopter",							commonFunc = function() commonPlayerRideHelicopter( 0 ) end },
		{ data = "Player",																message = "RideHelicopter",							commonFunc = function() commonPlayerRideHelicopter( 1 ) end },
	},
}

-- 敵兵リアライズメッセージ
local EnemyMessages = {
	Enemy = {
		{																				message = "EnemyFindComrade",						commonFunc = function() commonEnemyFindComrade() end },
	},
}

-- Markerメッセージ ※保留
local MarkerMessages = {
	Marker = {
		{																				message = "ChangeToEnable",							commonFunc = function() commonMissionTargetMarkerOn( 0, false, false, false ) end },
	},
}

-- SearchTargetメッセージ
local SearchTargetMessages = {
	Myself = {
		{ data = this.CharacterID_MT_Squad,												message = "LookingTarget",							commonFunc = function() commonMissionTargetMarkerOn( 0, false, false, false ) end },
		{ data = this.CharacterID_MT_Center,											message = "LookingTarget",							commonFunc = function() commonMissionTargetMarkerOn( 0, false, false, false ) end },
	},
}

---------------------------------------------------------------------------------
-- ■■ this Messages
---------------------------------------------------------------------------------

this.Messages = {
	Mission = {
		{ 																				message = "MissionFailure",							localFunc = "commonMissionFailure" },		-- ミッション失敗
		{ 																				message = "MissionClear",							localFunc = "commonMissionClear" },			-- ミッションクリア
		{																				message = "MissionRestart", 						localFunc = "commonMissionCleanUp" },		-- ミッションリスタート（メニュー）
		{																				message = "MissionRestartFromCheckPoint", 			localFunc = "commonMissionCleanUp" },		-- ミッションリスタート（チェックポイント）
		{																				message = "ReturnTitle", 							localFunc = "commonMissionCleanUp" },		-- タイトル画面へ（メニュー）
	},
	Character = {
		-- Phase
		{ data = this.cpID,																message = "Alert",									commonFunc = function() commonPhase_Alert() end  },
		{ data = this.cpID,																message = "Evasion",								commonFunc = function() commonPhase_Evasion() end  },
		{ data = this.cpID,																message = "Caution",								commonFunc = function() commonPhase_Caution() end  },
		{ data = this.cpID,																message = "Sneak",									commonFunc = function() commonPhase_Sneak() end  },
		-- 対空行動
		{ data = this.cpID,																message = "AntiAir",								commonFunc = function() commonChangeAntiAir() end  },
		-- ビークル兵
		{ data = { this.CharacterID_E_Vehicle01, this.CharacterID_E_Vehicle02 },		message = "MessageRoutePoint",						commonFunc = function() commonEnemy_Vehicle_StateMove( "RoutePoint" ) end  },
		{ data = this.cpID,																message = "EndGroupVehicleRouteMove",				commonFunc = function() commonEnemy_Vehicle_StateMove( "VehicleEnd" ) end  },
		{ data = this.cpID,																message = "VehicleMessageRoutePoint",				commonFunc = function() commonEnemy_Vehicle_StateMove( "VehicleRoutePoint" ) end  },
		{ data = this.cpID,																message = "ConversationEnd",		 				commonFunc = function() commonEnemy_Vehicle_StateMove( "ConversationEnd" ) end	},
		-- トラック兵
		{ data = this.CharacterID_E_Western01, 											message = "MessageRoutePoint",						commonFunc = function() commonEnemy_Western01_StateMove( "RoutePoint" ) end  },
		{ data = this.cpID,																message = "EndGroupVehicleRouteMove", 				commonFunc = function() commonEnemy_Western01_StateMove( "VehicleEnd" ) end  },
		{ data = this.cpID,																message = "ConversationEnd", 						commonFunc = function() commonEnemy_Western01_StateMove( "ConversationEnd" ) end  },
		-- トラック付き添い兵
		{ data = this.CharacterID_E_Imitation, 											message = "MessageRoutePoint",						commonFunc = function() commonEnemy_Imitation_StateMove( "RoutePoint" ) end  },
		{ data = this.cpID,																message = "EndGroupVehicleRouteMove", 				commonFunc = function() commonEnemy_Imitation_StateMove( "VehicleEnd" ) end  },
		{ data = this.cpID,																message = "ConversationEnd", 						commonFunc = function() commonEnemy_Imitation_StateMove( "ConversationEnd" ) end  },
		-- ＭＴ倉庫
		{ data = this.CharacterID_MT_Squad,												message = "MessageRoutePoint",						commonFunc = function() commonMT_Squad_StateMove( "RoutePoint" ) end  },
		{ data = this.CharacterID_MT_Squad,												message = "EnemyInterrogation",						commonFunc = function() commonMT_Squad_StateMove( "Interrogation" ) end  },
		{ data = this.CharacterID_E_Squad,												message = "MessageRoutePoint",						commonFunc = function() commonMT_Squad_StateMove( "RoutePoint_E_Squad" ) end  },
		{ data = this.cpID,																message = "EndGroupVehicleRouteMove", 				commonFunc = function() commonMT_Squad_StateMove( "VehicleEnd" ) end  },
		{ data = this.cpID,																message = "ConversationEnd", 						commonFunc = function() commonMT_Squad_StateMove( "ConversationEnd" ) end  },
		{ data = this.cpID,																message = "VehicleMessageRoutePoint",				commonFunc = function() commonMT_Squad_StateMove( "VehicleRoutePoint" ) end  },
		-- ＭＴ管理棟
		{ data = this.CharacterID_MT_Center,											message = "MessageRoutePoint",						commonFunc = function() commonMT_Center_StateMove( "RoutePoint" ) end  },
		{ data = this.CharacterID_MT_Center,											message = "EnemyInterrogation",						commonFunc = function() commonMT_Center_StateMove( "Interrogation" ) end  },
		{ data = this.cpID,																message = "EndGroupVehicleRouteMove",			 	commonFunc = function() commonMT_Center_StateMove( "VehicleEnd" ) end  },
		{ data = this.cpID,																message = "ConversationEnd", 						commonFunc = function() commonMT_Center_StateMove( "ConversationEnd" ) end	},
		{ data = this.cpID,																message = "VehicleMessageRoutePoint",				commonFunc = function() commonMT_Center_StateMove( "VehicleRoutePoint" ) end  },
		-- 難民キャンプ兵
		{ data = { "Enemy_US_eastTent_north000", "Enemy_US_eastTent_north001" },		message = "MessageRoutePoint",						commonFunc = function() commonEnemy_eastTent01_StateMove( "RoutePoint" ) end  },
		{ data = { "Enemy_US_eastTent_north000", "Enemy_US_eastTent_north001" },		message = "MessageRoutePoint",						commonFunc = function() commonEnemy_eastTent02_StateMove( "RoutePoint" ) end  },
		-- 増援部隊
		{ data = {	this.CharacterID_E_Reinforce01, this.CharacterID_E_Reinforce02, this.CharacterID_E_Reinforce03, this.CharacterID_E_Reinforce04,
					this.CharacterID_E_Reinforce05, this.CharacterID_E_Reinforce06, this.CharacterID_E_Reinforce07, this.CharacterID_E_Reinforce08 },
																						message = "MessageRoutePoint",						commonFunc = function() commonEnemy_Reinforce_StateMove( "RoutePoint" ) end  },
		-- Player
		{ data = "Player",																message = "TryPicking",								commonFunc = function() commonOnPickingDoor() end  },
		{ data = "Player",																message = "OnVehicleRide_End",						commonFunc = function() commonOnVehicleRide("Start") end  },								--
		{ data = "Player",																message = "OnVehicleGetOff_End",					commonFunc = function() commonOnVehicleRide("End") end	},									--
		{ data = "Player",																message = "OnVehicleRideSneak_End",					commonFunc = function() commonOnVehicleRide("SneakStart") end  },							-- 荷台
		{ data = "Player",																message = "OnVehicleGetOffSneak_End",				commonFunc = function() commonOnVehicleRide("SneakEnd") end	},								-- 荷台
		{ data = "Player",																message = "OnPickUpItem", 							commonFunc = function() commonPlayerPickItem() end },										-- アイテムを取得した
		{ data = "Player",																message = "OnPickUpWeapon" ,						commonFunc = function() commonPickUpWeaopn() end  },										-- 武器を入手した時
		{ data = "Player",																message = "NotifyStartWarningFlare",				commonFunc = function() commonMbDvcActCallRescueHeli("SupportHelicopter", "flare") end },	-- フレアグレネードを使った
			-- 捕虜
		{ data = { "Hostage_e20020_000", "Hostage_e20020_001" },						message = "HostageLaidOnVehicle",					commonFunc = function() commonOnLaidHostage() end  },
		{ data = { "Hostage_e20020_000", "Hostage_e20020_001" },						message = "Dead",									commonFunc = function() commonOnDeadHostage() end  },
		-- Heli
		{ data = this.CharacterID_SupportHelicopter,									message = "ArriveToLandingZone",					commonFunc = function() commonHeliArrive() end },				--ヘリがＲＶに到着
		{ data = this.CharacterID_SupportHelicopter,									message = "DepartureToMotherBase",					commonFunc = function() commonHeliTakeOff() end  },
		{ data = this.CharacterID_SupportHelicopter,									message = "Dead",									commonFunc = function() commonHeliDead() end  },
		{ data = this.CharacterID_SupportHelicopter,									message = "DamagedByPlayer",						commonFunc = function() commonHeliDamagedByPlayer() end },		--プレイヤーから攻撃を受けた
		-- ビークル
		{ data = { "Tactical_Vehicle_WEST_001", "Tactical_Vehicle_WEST_002", "Tactical_Vehicle_WEST_003" },
																						message = "VehicleBroken",							commonFunc = function() commonGimmickBroken( "OFF" ) end },
		-- トラック
		{ data = { "Cargo_Truck_WEST_000", "Cargo_Truck_WEST_001" },
																						message = "VehicleBroken",							commonFunc = function() commonGimmickBroken( "OFF" ) end },
		-- 機銃装甲車
		{ data = { "Armored_Vehicle_WEST_001", },
																						message = "StrykerDestroyed",						commonFunc = function() commonGimmickBroken( "OFF" ) end },
		-- 巨大ゲート
		{ data = this.cpID,																message = "VehicleMessageRoutePoint", 				commonFunc = function() GZCommon.Common_CenterBigGateVehicle( ) end  },
		{ data = this.cpID,																message = "EndRadio"				, 				commonFunc = function() GZCommon.Common_CenterBigGateVehicleEndCPRadio( ) end  },
		-- 監視カメラ
		{ data = { "e20020_SecurityCamera_01", "e20020_SecurityCamera_02", "e20020_SecurityCamera_03", "e20020_SecurityCamera_05" },
																						message = "PowerON",								commonFunc = function() commonSecurityCamera("Poweron") end },
		{ data = { "e20020_SecurityCamera_01", "e20020_SecurityCamera_02", "e20020_SecurityCamera_03", "e20020_SecurityCamera_05" },
																						message = "PowerOFF",								commonFunc = function() commonSecurityCamera("Poweroff") end },
		{ data = { "e20020_SecurityCamera_01", "e20020_SecurityCamera_02", "e20020_SecurityCamera_03", "e20020_SecurityCamera_05" },
																						message = "Dead",									commonFunc = function() commonSecurityCamera("Dead") end },
	},
	Enemy = {
		{																				message = "MessageHumanEnemyCarriedStart",			commonFunc = function() commonCarriedEnemy("Start") end },
		{																				message = "MessageHumanEnemyCarriedEnd",			commonFunc = function() commonCarriedEnemy("End") end },
		{																				message = "EnemyRestraint",							commonFunc = function() commonRestraintEnemy() end },
		{																				message = { "EnemySleep", "EnemyFaint" },			commonFunc = function() commonSleepFaintEnemy() end },
		{																				message = "HostageLaidOnVehicle",					commonFunc = function() commonOnLaidEnemy() end },
		{																				message = "EnemyDead",								commonFunc = function() commonDeadEnemy() end },
		{																				message = "EnemyInterrogation",						commonFunc = function() commonInterrogationEnemy( false ) end },
		{																				message = "EnemyDamage",							commonFunc = function() commonDamagenEnemy() end },
	},
	Timer = {
		--
		{ data = "Timer_SequenceChage",													message = "OnEnd", 									commonFunc = function() commonSequenceChageTimerEnd() end },
		-- common
		{ data = "Timer_RouteChageTable01",												message = "OnEnd", 									commonFunc = function() commonTimerRouteChage( 1 ) end },
		{ data = "Timer_RouteChageTable02",												message = "OnEnd", 									commonFunc = function() commonTimerRouteChage( 3 ) end },
		{ data = "Timer_RouteChageTable03",												message = "OnEnd", 									commonFunc = function() commonTimerRouteChage( 5 ) end },
		{ data = "Timer_RouteChageTable04",												message = "OnEnd", 									commonFunc = function() commonTimerRouteChage( 7 ) end },
		{ data = "Timer_RouteChageTable05",												message = "OnEnd", 									commonFunc = function() commonTimerRouteChage( 9 ) end },
		{ data = "Timer_RouteChageTable06",												message = "OnEnd", 									commonFunc = function() commonTimerRouteChage( 11 ) end },
		{ data = "Timer_RouteChageTable07",												message = "OnEnd", 									commonFunc = function() commonTimerRouteChage( 13 ) end },
		{ data = "Timer_RouteChageTable08",												message = "OnEnd", 									commonFunc = function() commonTimerRouteChage( 15 ) end },
		{ data = "Timer_RouteChageTable09",												message = "OnEnd", 									commonFunc = function() commonTimerRouteChage( 17 ) end },
		{ data = "Timer_RouteChageTable10",												message = "OnEnd", 									commonFunc = function() commonTimerRouteChage( 19 ) end },
		-- ビークル兵
		{ data = "Timer_Enemy_Vehicle_StateMove_Timer",									message = "OnEnd",									commonFunc = function() commonEnemy_Vehicle_StateMove( "Timer" ) end  },
		{ data = "Timer_Enemy_Vehicle_StateMove_Init",									message = "OnEnd",									commonFunc = function() commonEnemy_Vehicle_StateMove( "Init" ) end  },
		-- トラック付き添い兵
		{ data = "Timer_Enemy_Imitation_StateMove_Timer",								message = "OnEnd",									commonFunc = function() commonEnemy_Imitation_StateMove( "Timer" ) end	},
		{ data = "Timer_Enemy_Imitation_StateMove_Init",								message = "OnEnd",									commonFunc = function() commonEnemy_Imitation_StateMove( "Init" ) end  },
		-- トラック兵
		{ data = "Timer_Enemy_Western01_StateMove_Timer",								message = "OnEnd",									commonFunc = function() commonEnemy_Western01_StateMove( "Timer" ) end	},
		{ data = "Timer_Enemy_Western01_StateMove_Init",								message = "OnEnd",									commonFunc = function() commonEnemy_Western01_StateMove( "Init" ) end  },
		-- ＭＴ倉庫
		{ data = "Timer_MT_Squad_StateMove_Timer", 										message = "OnEnd",									commonFunc = function() commonMT_Squad_StateMove( "Timer" ) end  },
		{ data = "Timer_MT_Squad_StateMove_Init", 										message = "OnEnd",									commonFunc = function() commonMT_Squad_StateMove( "Init" ) end	},
		{ data = "Timer_MT_Squad_StateMove_Dead", 										message = "OnEnd",									commonFunc = function() commonMT_Center_StateMove( "MTSquadDead" ) end	},
		{ data = "Timer_MT_Squad_StateMove_Lost", 										message = "OnEnd",									commonFunc = function() commonMT_Squad_StateMove( "Lost" ) end	},
		{ data = "Timer_MT_Squad_StateMove_MarkerOn",									message = "OnEnd",									commonFunc = function() commonAreaMarkerMTSquad( false, true, false, false, false, false ) end },
		{ data = "Timer_MT_Squad_StateMove_MarkerOff",									message = "OnEnd",									commonFunc = function() commonAreaMarkerMTSquad( false, true, true, false, false, false ) end },
		-- ＭＴ管理棟
		{ data = "Timer_MT_Center_StateMove_Timer", 									message = "OnEnd",									commonFunc = function() commonMT_Center_StateMove( "Timer" ) end  },
		{ data = "Timer_MT_Center_StateMove_Init", 										message = "OnEnd",									commonFunc = function() commonMT_Center_StateMove( "Init" ) end  },
		{ data = "Timer_MT_Center_StateMove_Dead", 										message = "OnEnd",									commonFunc = function() commonMT_Squad_StateMove( "MTCenterDead" ) end	},
		{ data = "Timer_MT_Center_StateMove_Lost", 										message = "OnEnd",									commonFunc = function() commonMT_Center_StateMove( "Lost" ) end  },
		{ data = "Timer_MT_Center_StateMove_MarkerOn",									message = "OnEnd",									commonFunc = function() commonAreaMarkerMTCenter( false, true, false, false, false, false ) end  },
		{ data = "Timer_MT_Center_StateMove_MarkerOff",									message = "OnEnd",									commonFunc = function() commonAreaMarkerMTCenter( false, true, true, false, false, false ) end	},
		-- 東難民キャンプ兵
		{ data = "Timer_Enemy_eastTent01_StateMove_Timer",							 	message = "OnEnd",									commonFunc = function() commonEnemy_eastTent01_StateMove( "Timer" ) end  },
		{ data = "Timer_Enemy_eastTent01_StateMove_Init", 								message = "OnEnd",									commonFunc = function() commonEnemy_eastTent01_StateMove( "Init" ) end	},
		-- 東難民キャンプ兵
		{ data = "Timer_Enemy_eastTent02_StateMove_Timer",							 	message = "OnEnd",									commonFunc = function() commonEnemy_eastTent02_StateMove( "Timer" ) end  },
		{ data = "Timer_Enemy_eastTent02_StateMove_Init", 								message = "OnEnd",									commonFunc = function() commonEnemy_eastTent02_StateMove( "Init" ) end	},
		-- 増援部隊
		{ data = "Timer_Enemy_Reinforce_StateMove_Timer",							 	message = "OnEnd",									commonFunc = function() commonEnemy_Reinforce_StateMove( "Timer" ) end	},
		{ data = "Timer_Enemy_Reinforce_StateMove_Init", 								message = "OnEnd",									commonFunc = function() commonEnemy_Reinforce_StateMove( "Init" ) end  },
		-- マーカー
		{ data = "Timer_Alert_AreaMarkerOff", 											message = "OnEnd",									commonFunc = function() commonAlertAreaMarkerOff() end	},
		-- 端末写真確認促し無線再生チェックタイマー
		{ data = "Timer_CheckTargetPhoto",												message = "OnEnd",									commonFunc = function() commonCheckTargetPhoto() end },
		-- ヘリ
		{ data = "Timer_pleaseLeaveHeli",												message = "OnEnd",									commonFunc = function() commonHeliLeaveJudge() end },
		-- ミッション失敗
		{ data = "Timer_EscapeVehicleSound",											message = "OnEnd",									commonFunc = function() commonEscapeVehicleSound() end },
		-- ミッション失敗デモ
		{ data = "Timer_OutsideAreaCamera",												message = "OnEnd",									commonFunc = function() commonTimeOutsideAreaCamera() end },
		-- ＭＢ端末のアイコンを連続で鳴らない
		{ data = "Timer_FocusMapIcon",													message = "OnEnd",									commonFunc = function() commonTimeFocusMapIcon() end },
	},
	Trap = {
		-- 敵兵移動スタート
		{ data = "Trap_MTEventStart",													message = "Enter",									commonFunc = function() commonMT_Squad_StateMove( "Trap" ) end	},
		{ data = "Trap_VeicleEventStart",												message = "Enter",									commonFunc = function() commonEnemy_Vehicle_StateMove( "Trap" ) end  },
		{ data = "Trap_WesternEventStart",												message = "Enter",									commonFunc = function() commonEnemy_Imitation_StateMove( "Trap" ) end  },
		{ data = "Trap_WesternEventStart",												message = "Enter",									commonFunc = function() commonEnemy_Western01_StateMove( "Trap" ) end  },
		{ data = "Trap_eastTent01EventStart",											message = "Enter",									commonFunc = function() commonEnemy_eastTent01_StateMove( "Trap" ) end	},
		{ data = "Trap_eastTent02EventStart",											message = "Enter",									commonFunc = function() commonEnemy_eastTent02_StateMove( "Trap" ) end	},
		-- ミッション補足無線
		{ data = "Trap_RadioMissionOutline01",											message = "Enter",									commonFunc = function() commonMissionOutlineRadio01() end },
		{ data = "Trap_RadioMissionOutline02",											message = "Enter",									commonFunc = function() commonMissionOutlineRadio02() end },
		-- ミッション圏外
		{ data = "Trap_WarningMissionArea",												message = "Enter", 									commonFunc = function() commonOutsideMissionWarningArea() end },
		{ data = "Trap_EscapeMissionArea",											 	message = "Enter", 									commonFunc = function() commonOutsideMissionEscapeArea() end },
		-- 捕虜
		{ data = "Trap_HostageCallHelp",											 	message = "Enter", 									commonFunc = function() commonHostageHelp("Enter") end },
		{ data = "Trap_HostageCallHelp",											 	message = "Exit", 									commonFunc = function() commonHostageHelp("Exit") end },
		-- 捕虜担ぎ台詞
		{ data = "Trap_Monologue_Hostage01",										 	message = "Enter", 									commonFunc = function() GZCommon.CallMonologueHostage( this.CharacterID_Hostage_PickingDoor08, "hostage_b", "e20020_trap", "Trap_Monologue_Hostage01" ) end },
		{ data = "Trap_Monologue_Hostage02",										 	message = "Enter", 									commonFunc = function() GZCommon.CallMonologueHostage( this.CharacterID_Hostage_PickingDoor22, "hostage_d", "e20020_trap", "Trap_Monologue_Hostage02" ) end },
		-- ＲＶマーカー
		{ data = "Trap_Area_campEast", 													message = "Enter",									commonFunc = function() commonHeliRendezvousPointMarker( "RV_SeaSide" ) end },
		{ data = "Trap_Area_campWest", 													message = "Enter",									commonFunc = function() commonHeliRendezvousPointMarker( "RV_WareHouse" ) end },
		{ data = "Trap_Area_ControlTower", 												message = "Enter",									commonFunc = function() commonHeliRendezvousPointMarker( "RV_HeliPort" ) end },
		{ data = "Trap_Area_StartCliff", 												message = "Enter",									commonFunc = function() commonHeliRendezvousPointMarker( "RV_StartCliff" ) end },
	},
	Radio = {
		-- 諜報無線
		{ data = this.CharacterID_MT_Squad,												message = "EspionageRadioCandidate",				commonFunc = function() commonMT_Squad_StateMove( "Radio" ) end  },
		{ data = this.CharacterID_MT_Center,											message = "EspionageRadioCandidate",				commonFunc = function() commonMT_Center_StateMove( "Radio" ) end  },
		{ data = "Enemy_US_Seaside000",													message = "EspionageRadioCandidate",				commonFunc = function() commonEnemy_Vehicle_StateMove( "Radio" ) end  },
		{ data = this.CharacterID_E_Vehicle01,											message = "EspionageRadioCandidate",				commonFunc = function() commonEnemy_Vehicle_StateMove( "Radio" ) end  },
		{ data = this.CharacterID_E_Western01,											message = "EspionageRadioCandidate",				commonFunc = function() commonEnemy_Western01_StateMove( "Radio" ) end	},
		{ data = this.CharacterID_E_Imitation,											message = "EspionageRadioCandidate",				commonFunc = function() commonEnemy_Imitation_StateMove( "Radio" ) end	},
		{ data = "Enemy_US_Asylum000",													message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Asylum000") end},
		{ data = "Enemy_US_bridge000",													message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_bridge000") end},
		{ data = "Enemy_US_center000",													message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_center000") end},
		{ data = "Enemy_US_center001",													message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_center001") end},
		{ data = "Enemy_US_center002",													message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_center002") end},
		{ data = "Enemy_US_center003",													message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_center003") end},
		{ data = "Enemy_US_eastTentGroup_north000",										message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_eastTentGroup_north000") end},
		{ data = "Enemy_US_Heliport000",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Heliport000") end},
		{ data = "Enemy_US_Heliport001",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Heliport001") end},
		{ data = "Enemy_US_Heliport002",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Heliport002") end},
		{ data = "Enemy_US_Heliport003",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Heliport003") end},
		{ data = "Enemy_US_Heliport004",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Heliport004") end},
		{ data = "Enemy_US_MissionTargetSquad001",										message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_MissionTargetSquad001") end},
		{ data = "Enemy_US_Seaside000",													message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Seaside000") end},
		{ data = "Enemy_US_Stryker000",													message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Stryker000") end},
		{ data = "Enemy_US_WareHouse000",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_WareHouse000") end},
		{ data = "Enemy_US_WareHouse001",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_WareHouse001") end},
		{ data = "Enemy_US_westTentGroup_north000",										message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_westTentGroup_north000") end},
		{ data = "Enemy_US_westTentGroup_north001",										message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_westTentGroup_north001") end},
		{ data = "Enemy_US_WoodTurret000",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_WoodTurret000") end},
		{ data = "Enemy_US_MissionTargetCenterSquad000",								message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_MissionTargetCenterSquad000") end},
		{ data = "Enemy_US_MissionTargetCenterSquad001",								message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_MissionTargetCenterSquad001") end},
		{ data = "Enemy_US_Vehicle001",													message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Vehicle001") end},
		{ data = "Enemy_US_Western000",													message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Western000") end},
		{ data = "Enemy_US_eastTent_south000",											message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_eastTent_south000") end},
		{ data = "Enemy_US_IronTurret000",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_IronTurret000") end},
		{ data = "Enemy_US_WareHouse002",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_WareHouse002") end},
		{ data = "Enemy_US_eastTent_north000",											message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_eastTent_north000") end},
		{ data = "Enemy_US_eastTent_north001",											message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_eastTent_north001") end},
		{ data = "Enemy_US_westTent000",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_westTent000") end},
		{ data = "Enemy_US_westTent001",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_westTent001") end},
		{ data = "Enemy_US_IronTurret001",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_IronTurret001") end},
		{ data = "Enemy_US_Reinforce004",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Reinforce004") end},
		{ data = "Enemy_US_Reinforce005",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Reinforce005") end},
		{ data = "Enemy_US_Reinforce006",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Reinforce006") end},
		{ data = "Enemy_US_Reinforce007",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Reinforce007") end},
		{ data = "Enemy_US_Reinforce001",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Reinforce001") end},
		{ data = "Enemy_US_Reinforce000",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Reinforce000") end},
		{ data = "Enemy_US_Reinforce002",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Reinforce002") end},
		{ data = "Enemy_US_Reinforce003",												message = "EspionageRadioCandidate",				commonFunc = function() commonIntelCheck("Enemy_US_Reinforce003") end},
		-- 無線
		{ data = "f0090_rtrg0130",														message = "RadioEventMessage",						commonFunc = function() commonHeliLeaveExtension() end },
		{ data = "f0090_rtrg0200",														message = "RadioEventMessage",						commonFunc = function() commonHeliLeaveExtension() end },
		{ data = "f0090_rtrg0210",														message = "RadioEventMessage",						commonFunc = function() commonHeliLeaveExtension() end },
	},
	Terminal = {
		{ 																				message = "MbDvcActWatchPhoto",						commonFunc = function() commonMbDvcActWatchPhotoRadio() end },
		{ 																				message = "MbDvcActOpenTop",						commonFunc = function() commonMbDvcActOpenTopRadio() end },
		{																				message = "MbDvcActFocusMapIcon",					commonFunc = function() commonFocusMapIcon() end },
		{																				message = "MbDvcActCallRescueHeli",					commonFunc = function() commonMbDvcActCallRescueHeli("SupportHelicopter", "MbDvc") end },
	},
	Gimmick = {
		-- 木製櫓
		{ data = "WoodTurret01",														message = "BreakGimmick",							commonFunc = function() commonGimmickBroken( "OFF" ) end },
		{ data = "WoodTurret02",														message = "BreakGimmick",							commonFunc = function() commonGimmickBroken( "OFF" ) end },
		{ data = "WoodTurret03",														message = "BreakGimmick", 							commonFunc = function() commonGimmickBroken( "OFF" ) end },
		{ data = "WoodTurret04",														message = "BreakGimmick", 							commonFunc = function() commonGimmickBroken( "OFF" ) end },
		{ data = "WoodTurret05",														message = "BreakGimmick", 							commonFunc = function() commonGimmickBroken( "OFF" ) end },
		-- 対空機関砲
		{ data = "gntn_area01_antiAirGun_000",											message = "AntiAircraftGunBroken",					commonFunc = function() commonGimmickBroken( "OFF" ) end },
		{ data = "gntn_area01_antiAirGun_001",											message = "AntiAircraftGunBroken",					commonFunc = function() commonGimmickBroken( "OFF" ) end },
		{ data = "gntn_area01_antiAirGun_002",											message = "AntiAircraftGunBroken",					commonFunc = function() commonGimmickBroken( "OFF" ) end },
		{ data = "gntn_area01_antiAirGun_003",											message = "AntiAircraftGunBroken",					commonFunc = function() commonGimmickBroken( "OFF" ) end },
		-- 配電盤
		{ data = "gntn_center_SwitchLight",												message = "SwitchOn",								commonFunc = SwitchLight_ON },	--管理棟配電盤ＯＮ
		{ data = "gntn_center_SwitchLight",												message = "SwitchOff",								commonFunc = SwitchLight_OFF },	--管理棟配電盤ＯＦＦ
	},
	Subtitles = {
		-- チュートリアルアイコン
		{ data = "suvv1000_101710",														message = "SubtitlesEventMessage",					commonFunc = function() commonCallButtonGuide( 0 ) end },
		-- ミッション達成
		{ data = "suvv1000_191010",														message = "SubtitlesFinishedEventMessage",			commonFunc = function() commonCallEscapMusic( "Start" ) end },
		{ data = "suvv1000_1a1010",														message = "SubtitlesFinishedEventMessage",			commonFunc = function() commonCallEscapMusic( "Start" ) end },
		-- 尋問
		{ data = this.InterrogationName_TargetA,										message = "SubtitlesEventMessage",					commonFunc = function() commonMissionTargetMarkerOn( this.CharacterID_MT_Center, true, true, false ) end },
		{ data = this.InterrogationName_TargetB,										message = "SubtitlesEventMessage",					commonFunc = function() commonMissionTargetMarkerOn( this.CharacterID_MT_Squad, true, true, false ) end },
		{ data = this.InterrogationName_TargetA,										message = "SubtitlesFinishedEventMessage",			commonFunc = function() commonMissionTargetMarkerOn( this.CharacterID_MT_Center, true, true, true ) end },
		{ data = this.InterrogationName_TargetB,										message = "SubtitlesFinishedEventMessage",			commonFunc = function() commonMissionTargetMarkerOn( this.CharacterID_MT_Squad, true, true, true ) end },
	},
	-- 汎用無線
	RadioCondition = {
		{																				message = "PlayerLifeLessThanHalf",					commonFunc = function() TppRadio.Play( "Miller_SpRecoveryLifeAdvice" ) end },
		{																				message = "PlayerHurt",								commonFunc = function() TppRadio.Play( "Miller_CuarAdvice" ) end },
		{																				message = "PlayerCureComplete",						commonFunc = function() TppRadio.Play( "Miller_SpRecoveryLifeAdvice" ) end },
		{																				message = "SuppressorIsBroken",						commonFunc = function() commonSuppressorIsBroken() end },
	},
	-- カセットテープ
	UI = {
		{																				message = "GetAllCassetteTapes" ,					commonFunc = function() TppRadio.DelayPlayEnqueue("Miller_AllGetTape", "mid" ) end },	--カセットテープ全取得
	},
	-- 停電演出
	Demo = {
		{ data = "p11_020003_000",														message="invis_cam",								commonFunc = function() TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20020_SecurityCamera_03", false ) end },
		{ data = "p11_020003_000",														message="lightOff",									commonFunc = function() TppGadgetUtility.SetSwitch( "gntn_center_SwitchLight", false ) end },
		{ data = "p11_020003_000",														message="lightOn",									commonFunc = function() TppGadgetUtility.SetSwitch( "gntn_center_SwitchLight", true ) end },
		{ data = "p11_020003_000",														message="under",									commonFunc = function() TppWeatherManager:GetInstance():RequestTag("under", 0 ) end },
		{ data = "p11_020003_000",														message="default",									commonFunc = function() TppWeatherManager:GetInstance():RequestTag("default", 0 ) end },
	},

}

---------------------------------------------------------------------------------
-- ■■ SystemSequences
---------------------------------------------------------------------------------
-- this.Seq_MissionPrepare
this.Seq_MissionPrepare = {
	OnEnter = function( manager )
		-- ミッション開始準備
		commonMissionPrepare( manager )

		-- これまでに獲得している報酬数を保持
		local uiCommonData = UiCommonDataManager.GetInstance()
		this.tmpRewardNum = uiCommonData:GetRewardNowCount( this.missionID )
		Fox.Log("***e20020_MissionPrepare.tmpRewardNum_IS___"..this.tmpRewardNum)

		-- 次のシーケンスへ
		TppSequence.ChangeSequence( "Seq_MissionSetup" )
	end,
}

-- this.Seq_MissionSetup
this.Seq_MissionSetup = {
	OnEnter = function()
		-- GZ共通ミッションセットアップ
		GZCommon.MissionSetup()
		-- 共通ミッションセットアップ
		commonMissionSetup()
		-- 次のシーケンスへ
		TppSequence.ChangeSequence( "Seq_OpeningDemoLoad" )
	end,
}

-- this.Seq_OpeningDemoLoad
this.Seq_OpeningDemoLoad = {
	OnEnter = function()
		commonDemoBlockSetup()
	end,
	OnUpdate = function()
		if( IsDemoAndEventBlockActive() ) then
			TppSequence.ChangeSequence( "Seq_OpeningShowTransition" )
		end
	end,
}

-- this.Seq_OpeningShowTransition
this.Seq_OpeningShowTransition = {
	OnEnter = function()
		local localChangeSequence = {
			onOpeningBgEnd = function()
				TppSequence.ChangeSequence( "Seq_OpeningDemo" ) --テロップの絵が消えるくらいで関数を実行
			end,
		}
		-- デモ中でも例外的にリアライズ指定するChara
		MissionManager.RegisterNotInGameRealizeCharacter( "Enemy_US_Seaside000" )
		-- ミッション開始ジングル再生
		TppMusicManager.PostJingleEvent( "MissionStart", "Play_bgm_gntn_op_default" )
		-- ミッション開始テロップ開始
		TppUI.ShowTransition( "opening", localChangeSequence )
	end,
}

--　this.Seq_MissionLoad
this.Seq_MissionLoad = {
	OnEnter = function( manager )
		-- 共通ミッションロードセットアップ
		commonMissionLoadSetup( manager, false, false )
		-- 次のシーケンスへ
		TppSequence.ChangeSequence( "Seq_Waiting_KillMT_Squad_and_Center" )
	end,
}

-- this.Seq_MissionClearShowTransition
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
		-- 終了テロップ～ミッション完全終了まで無線とBGM以外ミュート
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
		-- 強字幕設定にする
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )
		-- ミッションクリア無線をコール
		commonMissionClearRankRadio()
	end,
	OnEnter = function()
		local TelopEnd = {
			onEnd = function()
				TppSequence.ChangeSequence( "Seq_MissionEnd_Radio" )
			end,
		}
		-- 汎用無線登録解除
		commonRegisterRadioCondition( "OFF" )
		-- 終了テロップ開始
		TppUI.ShowTransitionWithFadeOut( "ending", TelopEnd, 2 )
	end,
}

-- this.Seq_Mission_Failed
this.Seq_MissionFailed = {
	MissionState = "failed",
	Messages = {
		Timer = {
			{ data = "MissionFailedProductionTimer",	message = "OnEnd", 	localFunc="OnFinishMissionFailedProduction" },
		},
	},
	OnEnter = function( manager )
		-- ミッション失敗演出中のウェイトを行う
		TppTimer.Start( "MissionFailedProductionTimer", this.CounterList.GameOverFadeTime )
	end,
	-- ミッション失敗演出ウェイト明け
	OnFinishMissionFailedProduction = function( manager )
		-- ゲームオーバーシーケンスへ
		TppSequence.ChangeSequence( "Seq_MissionGameOver" )
	end,
}

-- Seq_MissionGameOver
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
		commonPrint2D("ゲームオーバー無線再生 RadioName:"..this.CounterList.GameOverRadioName )
		-- 強字幕設定にする
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )
		-- ミッション失敗内容に応じた無線をコール
		TppRadio.DelayPlay( this.CounterList.GameOverRadioName, nil, "none" )
	end,
	OnEnter = function()
		-- この後の処理はMissionManagerからのmessage（RestartやReturnToTitleなど）に引っ掛けて行うのでここには記述不要
	end,
}

-- this.Seq_MissionEnd_Radio
this.Seq_MissionEnd_Radio = {
	MissionState = "clear",
	OnEnter = function()
		-- 強字幕設定にする
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )
		local funcs = {
			onStart = function() TppMusicManager.PostJingleEvent( 'SingleShot', 'Set_Switch_bgm_gntn_ed_default_lp' ) end,
			onEnd = function()
				TppSequence.ChangeSequence( "Seq_ShowClearReward" )
				-- 強字幕設定にしない
				SubtitlesCommand.SetIsEnabledUiPrioStrong( false )
			end,
		}
		-- ２名要人を回収
		if( ( TppMission.GetFlag( "isMT_SquadKill" ) == 2 and TppMission.GetFlag( "isMT_CenterKill" ) == 2 and TppMission.GetFlag( "isSupportHelicopterDead" ) == false ) )  then
			TppRadio.Play( "Radio_MissionClear_Recovery", funcs, nil, nil, "none" )
		-- 要人を排除
		else
			TppRadio.Play( "Radio_MissionClear_Kill", funcs, nil, nil, "none" )
		end
	end,
	-- スキップ処理
	OnUpdate = function()
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

-- Seq_ShowClearReward
this.Seq_ShowClearReward = {
	MissionState = "clear",
	Messages = {
		UI = {
			-- ポップアップの終了メッセージ
			--{ message = "PopupClose",		commonFunc = function() OnClosePopupWindow() end },
			-- 全ての報酬ポップアップが閉じられたら次シーケンスへ
			{ message = "BonusPopupAllClose", commonFunc = function() TppSequence.ChangeSequence( "Seq_MissionEnd" ) end },
		},
	},
	OnEnter = function()
		-- 報酬ポップアップの表示
		OnShowRewardPopupWindow()
	end,
}

-- this.Seq_MissionEnd
this.Seq_MissionEnd = {
	-- ここに入ってくるのはMissionClear時のみ。
	-- 入ってきた時点で自動的にMissionMangaerがST_CLEARの先に処理を運んでくれる
	OnEnter = function()
		-- ミッション共通後片付け
		GZCommon.MissionCleanup()
		-- ミッション後片付け
		this.commonMissionCleanUp()
		-- ジングルフェード終了
		TppMusicManager.PostJingleEvent( "SingleShot", "Stop_bgm_gntn_ed_default" )
		TppMissionManager.SaveGame()		-- Btk14449対応：報酬獲得Sequenceで獲得した報酬をSaveする
		--ミッションを終了させる（アンロード）
		TppMission.ChangeState( "end" )
	end,
}

---------------------------------------------------------------------------------
-- ■■ Mission Failed Sequences
---------------------------------------------------------------------------------
-- ■ ミッション失敗
this.commonMissionFailure = function( manager, messageId, message )
	Fox.Log( "commonMissionFailure" )
	-- ミッション失敗テロップ
	local hudCommonData = HudCommonDataManager.GetInstance()
	local radioDaemon = RadioDaemon:GetInstance()
	-- BGMフェードアウト
	TppSoundDaemon.SetMute( 'GameOver' )
	-- ミッション失敗フェード開始時間を汎用値で初期化しておく（Continue対策）
	this.CounterList.GameOverFadeTime = GZCommon.FadeOutTime_MissionFailed
	commonPrint2D("Mission Failed"..message.."" , 1 )
	-- 再生中の無線停止
	radioDaemon:StopDirectNoEndMessage()
	-- 字幕の停止
	SubtitlesCommand.StopAll()
	-- CP無線をフェードアウトしつつ全停止
	TppEnemyUtility.IgnoreCpRadioCall( true )	-- 以降の新規無線コールを止める
	TppEnemyUtility.StopAllCpRadio( 0.5 )		-- フェード時間
	-- 要人２人排除前にヘリに乗った
	if( message == "FailedPlayerRideHelicopter" )  then
		-- ミッション失敗音声
		this.CounterList.GameOverRadioName = "Radio_MissionFailed_PlayerRideHelicopter"
		-- ミッション失敗テロップ
		hudCommonData:CallFailedTelop( "gameover_reason_mission_abort" )
	-- プレイヤーが死亡した
	elseif( message == "PlayerDead" ) then
		-- ミッション失敗音声
		this.CounterList.GameOverRadioName = "Radio_MissionFailed_PlayerDead"
	-- プレイヤーが落下死亡した
		elseif( message == "PlayerFallDead" )	then
		-- プレイヤー死亡時無線名を登録しておく
		this.CounterList.GameOverRadioName = "Radio_MissionFailed_PlayerDead"
		-- 落下死亡時はフェード開始時間を変更
		this.CounterList.GameOverFadeTime = GZCommon.FadeOutTime_PlayerFallDead
	-- ヘリが墜落した
	elseif( message == "PlayerDeadOnHeli" ) then
		this.CounterList.GameOverRadioName = "Radio_MissionFailed_PlayerHeliDead"
		-- ミッション失敗テロップ
		hudCommonData:CallFailedTelop( "gameover_reason_heli_destroyed" )
	-- 要人２人排除前にミッション圏外へ行った
	elseif( message == "FailedPlayerEscapeMissionArea" )  then
		-- ミッション失敗ジングルを鳴らす為にtrueにする
		GZCommon.isOutOfMissionEffectEnable = true
		-- ミッション失敗音声
		this.CounterList.GameOverRadioName = "Radio_MissionFailed_PlayerEscapeMissionArea"
		-- ミッション失敗演出
		GZCommon.OutsideAreaCamera()
		-- ミッション失敗テロップ
		hudCommonData:CallFailedTelop( "gameover_reason_mission_outside" )
	-- 要人がミッション圏外へ行った
	elseif( message == "FailedMTEscapeMissionArea" )  then
		-- ミッション失敗ジングルを鳴らす為にtrueにする
		GZCommon.isOutOfMissionEffectEnable = true
		-- ミッション失敗音声
		this.CounterList.GameOverRadioName = "Radio_MissionFailed_MTEscapeMissionArea"
		-- ミッション失敗演出
		if ( this.CounterList.VipOnEscapeVehicleID ~= "NoRide" ) then
			-- 車ミッション失敗演出
			if( this.CounterList.VipOnEscapeArea == "NoArea" ) then
				-- ミッション圏外演出
				GZCommon.OutsideAreaCamera_Vehicle( this.CounterList.VipOnEscapeVehicleID, this.CounterList.VipOnEscapeCharacterID )
				-- プープー音
				TppTimer.Start( "Timer_EscapeVehicleSound", this.Timer_EscapeVehicleSound )
			else
				-- ミッション圏外演出
				GZCommon.OutsideAreaCamera_Vehicle( this.CounterList.VipOnEscapeVehicleID, this.CounterList.VipOnEscapeCharacterID, this.CounterList.VipOnEscapeArea )
				-- プープー音
				TppTimer.Start( "Timer_EscapeVehicleSound", this.Timer_EscapeVehicleSound )
			end
			-- ミッション失敗テロップ
			hudCommonData:CallFailedTelop( "gameover_reason_target_outside" )
		else
			if( TppMission.GetFlag( "isAlert" ) == true ) then
				-- 徒歩ミッション失敗演出
				if( this.CounterList.VipOnEscapeArea == "NoArea" ) then
					-- ミッション圏外演出
					GZCommon.OutsideAreaCamera_Human( this.CounterList.VipOnEscapeCharacterID )
				else
					-- ミッション圏外演出
					GZCommon.OutsideAreaCamera_Human( this.CounterList.VipOnEscapeCharacterID, this.CounterList.VipOnEscapeArea )
				end
				-- ミッション失敗テロップ
				hudCommonData:CallFailedTelop( "gameover_reason_target_outside" )
			else
				-- 要人と付き添い以外表示ＯＦＦ
				for i,id in ipairs( this.AllEnemyDisableList ) do
					TppEnemyUtility.SetEnableCharacterId( this.AllEnemyDisableList[i], false )
				end
				-- ミッション圏外演出
				TppTimer.Start( "Timer_OutsideAreaCamera", this.Timer_OutsideAreaCamera )
			end
		end
	end
	-- ミッション失敗シーケンスへ
	TppSequence.ChangeSequence( "Seq_MissionFailed" )
end

-- this.Seq_Mission_FailedPlayerRideHelicopter
this.Seq_Mission_FailedPlayerRideHelicopter = {
	Messages = {
		Character = {
			{ data = this.CharacterID_SupportHelicopter,	message = "CloseDoor",		localFunc = "localCloseDoor" },
		},
	},
	localCloseDoor = function()
		Fox.Log("Seq_Mission_FailedPlayerRideHelicopter:localCloseDoor")
		-- ミッション失敗通知
		TppMission.ChangeState( "failed", "FailedPlayerRideHelicopter" )
	end,
}
-- this.Seq_Mission_FailedPlayerEscapeMissionArea
this.Seq_Mission_FailedPlayerEscapeMissionArea = {
	OnEnter = function()
		-- ミッション失敗通知
		TppMission.ChangeState( "failed", "FailedPlayerEscapeMissionArea" )
	end,
}
-- this.Seq_Mission_FailedMTEscapeMissionArea
this.Seq_Mission_FailedMTEscapeMissionArea = {
	OnEnter = function()
		-- アナウンスログ
		commonCallAnnounceLog( this.AnnounceLogID_EnemyDecrease )
		-- ミッション失敗通知
		TppMission.ChangeState( "failed", "FailedMTEscapeMissionArea" )
	end,
}

---------------------------------------------------------------------------------
-- ■■ Mission Clear Sequences
---------------------------------------------------------------------------------

-- commonMissionClear
this.commonMissionClear = function( manager, messageId, message )
	Fox.Log("commonMissionClear"..message )
	local radioDaemon = RadioDaemon:GetInstance()
	-- 再生中の無線停止
	radioDaemon:StopDirectNoEndMessage()
	-- 字幕の停止
	SubtitlesCommand.StopAll()
	-- CP無線をフェードアウトしつつ全停止
	TppEnemyUtility.IgnoreCpRadioCall( true )	-- 以降の新規無線コールを止める
	TppEnemyUtility.StopAllCpRadio( 0.5 )		-- フェード時間
	-- ヘリに乗った
	if( message == "RideHeli_Clear" )  then
		-- ミッションテロップシーケンスへ
		TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" )
	-- ミッション圏外に出た
	elseif( message == "ClearPlayerEscapeMissionArea" )  then
		-- ミッションクリアジングルを鳴らす為にfalseにする
		GZCommon.isOutOfMissionEffectEnable = false
		-- ミッションクリア演出
		GZCommon.OutsideAreaCamera()
		-- ミッションクリアシーケンスへ
		TppSequence.ChangeSequence( "Seq_MissionClearEscapeMissionAreaEnd" )
	end
end

-- this.Seq_MissionClearEscapeMissionArea
this.Seq_MissionClearEscapeMissionArea = {
	OnEnter = function()
		-- 要人２名を回収していたら
		if( TppMission.GetFlag( "isMT_SquadKill" ) == 2 and TppMission.GetFlag( "isMT_CenterKill" ) == 2 ) then
			-- チャレンジ要素登録
			commonSetMissionChallenge()
			-- 実績解除：「要人を二人ともヘリで回収してクリアした」
			Trophy.TrophyUnlock( this.TrophyID_GZ_VipRecovery )
		end
		-- ミッションクリア要求
		commonMissionClearRequest( "ClearPlayerEscapeMissionArea" )
	end,
}

-- this.Seq_MissionClearEscapeMissionAreaEnd
this.Seq_MissionClearEscapeMissionAreaEnd = {
	MissionState = "clear",
	Messages = {
		Timer = {
			{ data = "MissionClearProductionTimer",		message = "OnEnd", 	localFunc = "OnFinishMissionClearProduction" },
		},
	},
	OnEnter = function()
		-- クリア演出はFailedもClearも共通で呼んでしまっているのでここではウェイトだけ
		-- ミッションクリア演出中のウェイトを行う
		TppTimer.Start( "MissionClearProductionTimer", GZCommon.FadeOutTime_MissionClear )
	end,
	-- ミッションクリア演出ウェイト明け
	OnFinishMissionClearProduction = function()
		Fox.Log("Seq_MissionClearEscapeMissionAreaEnd:OnFinishMissionClearProduction")
		TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" )
	end,
}

-- this.Seq_MissionClearPlayerRideHelicopter
this.Seq_MissionClearPlayerRideHelicopter = {
	Messages = {
		Character = {
			{ data = this.CharacterID_SupportHelicopter,		message = "CloseDoor",		localFunc = "localCloseDoor" },
		},
	},
	localCloseDoor = function()
		Fox.Log("Seq_MissionClearPlayerRideHelicopter:localCloseDoor")
		-- 要人２名を回収していたら
		if( TppMission.GetFlag( "isMT_SquadKill" ) == 2 and TppMission.GetFlag( "isMT_CenterKill" ) == 2 ) then
			-- チャレンジ要素登録
			commonSetMissionChallenge()
			-- 実績解除：「要人を二人ともヘリで回収してクリアした」
			Trophy.TrophyUnlock( this.TrophyID_GZ_VipRecovery )
		end
		-- ミッションクリア要求
		commonMissionClearRequest( "RideHeli_Clear" )
	end,
}

---------------------------------------------------------------------------------
-- DemoSequences
---------------------------------------------------------------------------------
-- this.Seq_OpeningDemo
this.Seq_OpeningDemo = {
	OnEnter = function()
		TppDemo.Play( "Demo_Opening", { onStart = function() TppUI.FadeIn( 0.7 ) end, onEnd = function() TppSequence.ChangeSequence( "Seq_MissionLoad" ) end } )
	end,
}

---------------------------------------------------------------------------------
-- GameSequences
---------------------------------------------------------------------------------

-- this.Seq_Waiting_KillMT_Squad_and_Center
this.Seq_Waiting_KillMT_Squad_and_Center = {
	--CheckLookingTargetの使用を宣言
	checkingsOnThisSequence = {
		"CheckLookingTarget"
	},
	Messages = {
		Character = {
			SupportHeliMessages.Character[1],			-- ヘリに乗ったメッセージ
		},
		Myself = {
			SearchTargetMessages.Myself[1],				-- ＭＴ倉庫「指」
			SearchTargetMessages.Myself[2],				-- ＭＴ管理棟「目」
		},
	},
	OnEnter = function( manager )
		local funcs = {
			onStart = function()
				TppMission.SetFlag( "isRadio_MissionStartPlay", true )
			end,
			onEnd = function()
				TppMusicManager.PostJingleEvent( "SingleShot", "Stop_bgm_gntn_op_default" )
				TppMission.SetFlag( "isRadio_MissionStartPlay", false )
				-- 端末写真確認促し無線タイマーセットアップ
				commonCheckTargetPhotoTimeSetup( "Start" )
			end,
		}
		-- 任意無線設定
		commonRegisterOptionalRadioSetup( false, false )
		-- ミッション開始時無線
		if( TppMission.GetFlag( "isRadio_MissionStart" ) == false )  then
			-- 無線
			TppRadio.DelayPlay( "Radio_MissionStart", nil, "end", funcs )
			TppMission.SetFlag( "isRadio_MissionStart", true )
		else
			-- 無線：コンティニュー時
			TppRadio.DelayPlay( "Radio_MissionStartContinue", "mid", nil, funcs )
		end
		-- チェックセーブ：スタートポイント
		commonSequenceSave( false, "10" )
		-- ミッション中目標設定
		commonUiMissionSubGoalNo( this.MissionSubGoal_VipKillTwo )
		-- サーチターゲット設定
		commonSearchTargetSetup( manager )
	end,
}

------------------------------------------------------------------------------------------------------------------------------------------
-- this.Seq_Waiting_KillMT_Center
this.Seq_Waiting_KillMT_Center = {
	--CheckLookingTargetの使用を宣言
	checkingsOnThisSequence = {
		"CheckLookingTarget"
	},
	Messages = {
		Character = {
			SupportHeliMessages.Character[1],			-- ヘリに乗ったメッセージ
		},
		Enemy = {
			EnemyMessages.Enemy[1],						-- 状態異状仲間発見
		},
		Myself = {
			SearchTargetMessages.Myself[2],				-- ＭＴ管理棟「目」
		},
	},
	OnEnter = function( manager )
		local lifeStaus = TppEnemyUtility.GetLifeStatus( this.CharacterID_MT_Center )
		-- シーケンス進行フラグ
		TppMission.SetFlag( "isSeq_Advance", 1 )
		-- ＭＴ倉庫グループ解散
		commonRegisterVipMember_MTSquad()
		-- ミッション写真切り替え
		commonUiMissionPhotoChange( this.CharacterID_MT_Squad )
		-- このシーケンスに入った瞬間に死亡していた場合
		if( lifeStaus == "Dead" ) then
			-- 排除or回収：無線＆アナウンスログ
			commonCallAnnounceLogEnemy( "NoRadio", this.CharacterID_MT_Squad )
			-- ＭＴ管理棟排除
			commonMT_Center_StateMove( "Kill" )
			-- ミッションチャレンジ失敗
			commonUnsetMissionChallenge()
			-- 次のシーケンスへ
			TppSequence.ChangeSequence( "Seq_Waiting_MissionClearPlayerRideHelicopter" )
			-- 初期化
			if( this.CounterList.NextSequenceName ~= "NoName" ) then
				this.CounterList.NextSequenceName = "Seq_MissionClearPlayerRideHelicopter"
			end
		else
			-- 排除or回収：無線＆アナウンスログ
			commonCallAnnounceLogEnemy( 0, this.CharacterID_MT_Squad )
			-- 任意無線設定
			commonRegisterOptionalRadioSetup( false, false )
			-- 端末写真確認促し無線タイマーセットアップ
			commonCheckTargetPhotoTimeSetup( "Start" )
			-- チェックセーブ
			commonSequenceSave( true )
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_MissionInfoUpdate )
			--ミッション中目標設定
			commonUiMissionSubGoalNo( this.MissionSubGoal_VipKillOne )
			-- サーチターゲット設定
			commonSearchTargetSetup( manager )
			-- 保険処理で次のシーケンスへ
			commonSequenceChageTimerStart()
			-- ミッション圏外警告エリアにいた場合の処理
			commonSequenceChangeMissionWarningArea()
		end
	end,
}
------------------------------------------------------------------------------------------------------------------------------------------
-- this.Seq_Waiting_KillMT_Squad
this.Seq_Waiting_KillMT_Squad = {
	--CheckLookingTargetの使用を宣言
	checkingsOnThisSequence = {
		"CheckLookingTarget"
	},
	Messages = {
		Character = {
			SupportHeliMessages.Character[1],			-- ヘリに乗ったメッセージ
		},
		Enemy = {
			EnemyMessages.Enemy[1],						-- 状態異状仲間発見
		},
		Myself = {
			SearchTargetMessages.Myself[1],				-- ＭＴ倉庫「指」
		},
	},
	OnEnter = function( manager )
		local lifeStaus = TppEnemyUtility.GetLifeStatus( this.CharacterID_MT_Squad )
		-- シーケンス進行フラグ
		TppMission.SetFlag( "isSeq_Advance", 2 )
		-- ＭＴ管理棟グループ解散
		commonRegisterVipMember_MTCenter()
		-- ミッション写真切り替え
		commonUiMissionPhotoChange( this.CharacterID_MT_Center )
		-- このシーケンスに入った瞬間に死亡していた場合
		if( lifeStaus == "Dead" ) then
			-- 排除or回収：無線＆アナウンスログ
			commonCallAnnounceLogEnemy( "NoRadio", this.CharacterID_MT_Center )
			-- ＭＴ倉庫排除
			commonMT_Squad_StateMove( "Kill" )
			-- ミッションチャレンジ失敗
			commonUnsetMissionChallenge()
			-- 次のシーケンスへ
			TppSequence.ChangeSequence( "Seq_Waiting_MissionClearPlayerRideHelicopter" )
			if( this.CounterList.NextSequenceName ~= "NoName" ) then
				this.CounterList.NextSequenceName = "Seq_MissionClearPlayerRideHelicopter"
			end
		else
			-- 排除or回収：無線＆アナウンスログ
			commonCallAnnounceLogEnemy( 0, this.CharacterID_MT_Center )
			-- 任意無線設定
			commonRegisterOptionalRadioSetup( false, false )
			-- 端末写真確認促し無線タイマーセットアップ
			commonCheckTargetPhotoTimeSetup( "Start" )
			-- チェックセーブ
			commonSequenceSave( true )
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
			-- アナウンスログ
			commonCallAnnounceLog( this.AnnounceLogID_MissionInfoUpdate )
			--ミッション中目標設定
			commonUiMissionSubGoalNo( this.MissionSubGoal_VipKillOne )
			-- サーチターゲット設定
			commonSearchTargetSetup( manager )
			-- 保険処理で次のシーケンスへ
			commonSequenceChageTimerStart()
			-- ミッション圏外警告エリアにいた場合の処理
			commonSequenceChangeMissionWarningArea()
		end
	end,
}
---------------------------------------------------------------------------------
-- this.Seq_Waiting_MissionClearPlayerRideHelicopter
this.Seq_Waiting_MissionClearPlayerRideHelicopter = {
	Messages = {
		Character = {
			SupportHeliMessages.Character[2],			-- ヘリに乗ったメッセージ
		},
		Enemy = {
			EnemyMessages.Enemy[1],						-- 状態異状仲間発見
		},
	},
	OnEnter = function( manager )
		-- 任意無線設定
		commonRegisterOptionalRadioSetup( false, false )
		-- チェックセーブ
		commonSequenceSave( true )
		-- キープアラート設定
		commonKeepPhaseAlert( "OFF" )
		-- 最初にＭＴ倉庫
		if( TppMission.GetFlag( "isSeq_Advance" ) == 1 )  then
			-- ＭＴ管理棟グループ解散
			commonRegisterVipMember_MTCenter()
			-- 排除or回収：無線＆アナウンスログ
			commonCallAnnounceLogEnemy( 1, this.CharacterID_MT_Center )
			-- ミッション写真切り替え
			commonUiMissionPhotoChange( this.CharacterID_MT_Center )
		-- 最初に管理棟
		elseif( TppMission.GetFlag( "isSeq_Advance" ) == 2 )  then
			-- ＭＴ倉庫グループ解散
			commonRegisterVipMember_MTSquad()
			-- 排除or回収：無線＆アナウンスログ
			commonCallAnnounceLogEnemy( 1, this.CharacterID_MT_Squad )
			-- ミッション写真切り替え
			commonUiMissionPhotoChange( this.CharacterID_MT_Squad )
		end
		-- 端末写真確認促し無線タイマーセットアップ
		commonCheckTargetPhotoTimeSetup( "End" )
		-- ミッション達成アナウンスログ
		commonCallAnnounceLog( this.AnnounceLogID_MissionGoal )
		-- アナウンスログ
		commonCallAnnounceLog( this.AnnounceLogID_MapUpdate )
		-- アナウンスログ
		commonCallAnnounceLog( this.AnnounceLogID_MissionInfoUpdate )
		-- 脱出ポイントにマーカー表示
		commonEscapeMarker()
		--ミッション中目標設定
		commonUiMissionSubGoalNo( this.MissionSubGoal_Escape )
		-- サーチターゲット設定
		commonSearchTargetSetup( manager )
		-- 保険処理で次のシーケンスへ
		commonSequenceChageTimerStart()
		-- ミッション圏外警告エリアにいた場合の処理
		commonSequenceChangeMissionWarningArea()
	end,
}

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this
