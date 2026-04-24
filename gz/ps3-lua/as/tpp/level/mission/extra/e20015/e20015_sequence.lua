
local this = {}
---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------
this.missionID = 20015
this.tmpChallengeString = 0			-- 報酬ポップアップ識別用
this.tmpBestRank = 0				-- ベストクリアランク比較用(5 = RankD)
this.startViewMode = "result"		-- 画面モードによって呼び分けないと進行不能になるから
---------------------------------------------------------------------------------
-- EventSequenceManager
---------------------------------------------------------------------------------
this.RequiredFiles = {
	"/Assets/tpp/script/common/TppCommon.lua",
}

this.Sequences = {
	-- prepare
	{ "Seq_Mission_Prepare" },
	-- exec
	{ "Seq_Mission_Exec" },
	{ "Seq_Game_OpeningDemoLoad" },
	{ "Seq_Wait_EndTelop" },
	{ "Seq_Demo_PazOperate" },
	-- clear
	{ "Seq_Mission_Clear" },
	{ "Seq_MissionClear" },
	{ "Seq_MissionAbort" },
	{ "Seq_MissionFailed" },
	-- end
	{ "Seq_EndRoll" },			--エンドロールシーケンス
	{ "Seq_ShowClearReward" },	--報酬画面シーケンス
	{ "Seq_MissionEnd" },
}


this.OnStart = function( manager )
	TppCommon.Register( this, manager )
	--TppMission.Setup() --delite 0722
	this.startViewMode = "result" -- 画面モードによって呼び分けないと進行不能になるから
end

-- "exec"に向かうべきシーケンスのリスト
this.ChangeExecSequenceList =  {
	"Seq_Demo_PazOperate",
--	"Seq_EndRoll",
}

-- クリアランク報酬テーブル
this.ClearRankRewardList = {

	-- ステージ上に配置した報酬アイテムロケータのLocatorIDを登録
	RankS = "Rank_S_Reward_Assault",
	RankA = "Rank_A_Reward_Sniper",
	RankB = "Rank_B_Reward_Missile",
	RankC = "Rank_C_Reward_SubmachinGun",
}

this.ClearRankRewardPopupList = {

	-- 報酬アイテム入手ポップアップID
	RankS = "reward_clear_s_rifle",
	RankA = "reward_clear_a_sniper",
	RankB = "reward_clear_b_rocket",
	RankC = "reward_clear_c_submachine",
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
--[[
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
--]]
---------------------------------------------------------------------------------
-- ■ OnShowRewardPopupWindow
-- 報酬ポップアップの表示
this.OnShowRewardPopupWindow = function()

	Fox.Log("-------OnShowRewardPopupWindow--------")

	-- チャレンジ要素によってアンロックされた報酬表示
	local hudCommonData = HudCommonDataManager.GetInstance()
	local challengeString = PlayRecord.GetOpenChallenge()

	--カセットテープ取得確認
	local uiCommonData = UiCommonDataManager.GetInstance()
	local AllHardClear = PlayRecord.IsAllMissionClearHard()
	local count = TppStorage.GetXOFEmblemCount()	--取得済みＸＯＦワッペン数の取得

	--20010クリア回数取得
	local clear_cnt = PlayRecord.GetMissionScore( 20010, "NORMAL", "CLEAR_COUNT" )

	local hardmode = TppGameSequence.GetGameFlag("hardmode") --以下20010の最高ランクを取ってくる
	local Rank = 0
	if ( hardmode ) then
		-- 難易度HARD
		Rank = PlayRecord.GetMissionScore( 20010, "HARD", "BEST_RANK")
	else
		-- 難易度NORMAL
		Rank = PlayRecord.GetMissionScore( 20010, "NORMAL", "BEST_RANK")
	end

	this.tmpBestRank = TppGameSequence.GetGameFlag("e20010_beforeBestRank")	--20010開始当時の最高ランク

	--全カセットテープの持ってない扱いをやめる
	local uiCommonData = UiCommonDataManager.GetInstance()
	uiCommonData:ShowAllCassetteTapes()

	-- **** ミッション達成率の表示 ****
	local RewardAllCount = uiCommonData:GetRewardAllCount( 20010 )
	local tmpRewardCount = TppGameSequence.GetGameFlag("rewardNumOfMissionStart")	-- 20010開始時の獲得報酬数
	Fox.Log("**** ShowRewardAllCount::"..RewardAllCount)

	-- 報酬の獲得状況（達成率）表示
	hudCommonData:SetBonusPopupCounter( tmpRewardCount, RewardAllCount )

	--------------------------------------------------------------------------------------
	-- 汎用報酬
	--------------------------------------------------------------------------------------
	-- 空文字になるまで繰り返す
	while ( challengeString ~= "" ) do
		Fox.Log("-------OnShowRewardPopupWindow:challengeString:::"..challengeString)
		-- PopUpの表示。表示終了メッセージを受けたら再度実行
		hudCommonData:ShowBonusPopupCommon( challengeString )
		-- PlayRecordに問い合わせ
		challengeString = PlayRecord.GetOpenChallenge()
	end
	--------------------------------------------------------------------------------------
	-- ① クリアランク報酬
	--------------------------------------------------------------------------------------
	-- クリアランクに応じた報酬アイテム入手
	while ( Rank < this.tmpBestRank ) do
		Fox.Log("-------OnShowRewardPopupWindow:ClearRankRewardItem-------"..this.tmpBestRank)
		this.tmpBestRank = ( this.tmpBestRank - 1 )
		if ( this.tmpBestRank == 4 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankC , "WP_sm00_v00" , { isSup = true } )
		elseif ( this.tmpBestRank == 3 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankB , "WP_ms02" )
		elseif ( this.tmpBestRank == 2 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankA , "WP_sr01_v00" )
		elseif ( this.tmpBestRank == 1 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankS , "WP_ar00_v05" , { isBarrel = true })
		end
	end
	--------------------------------------------------------------------------------------
	-- ② ミッション固有（テープ入手）
	--------------------------------------------------------------------------------------
	-- チコテープ３
	if uiCommonData:IsHaveCassetteTape( "tp_chico_03" ) then
		if ( PlayRecord.GetMissionScore( 20010, "NORMAL", "CLEAR_COUNT" ) == 1 and 	-- NORMALクリア1かつHARDクリア0＝初回クリア
			 PlayRecord.GetMissionScore( 20010, "HARD", "CLEAR_COUNT" ) == 0 ) then
			Fox.Log( "OnShowRewardPopupWindow:Chico_Tape3_PopUp_Only" )
			--持っていてかつ初回プレイだったら入手ポップアップだけ表示（報酬取得数カウントのため）
			hudCommonData:ShowBonusPopupItemTape( "reward_get_tape_tp_chico_03" )
		end
	else
		--チコからのカセット入手ポップアップ
		hudCommonData:ShowBonusPopupItemTape( "reward_get_tape_tp_chico_03" )
--			this.tmpChallengeString = hudCommonData:ShowPopup( "reward_get_tape_tp_chico_03" )
		--チコのテープ３入手
		uiCommonData:GetBriefingCassetteTape( "tp_chico_03" )
		Fox.Log("------------------ tp_chico_03 Get ------------------")
	end
	-- チコテープ４
	if TppGameSequence.GetGameFlag( "e20010_cassette" ) == true then
		if uiCommonData:IsHaveCassetteTape( "tp_chico_04" ) then
			--持ってたら無視する
		else
			--脱走捕虜からのカセット入手ポップアップ
			hudCommonData:ShowBonusPopupItemTape( "reward_get_tape_20010" )
--				this.tmpChallengeString = hudCommonData:ShowPopup( "reward_get_tape_20010" )
			--チコのテープ４入手
			uiCommonData:GetBriefingCassetteTape( "tp_chico_04" )
			Fox.Log("------------------ tp_chico_04 Get ------------------")
		end
	end
	-- 全ての「チコの記録」入手で「チコの記録（完全版）」入手
	local AllChicoTape = GZCommon.CheckReward_AllChicoTape()
	if ( AllChicoTape == true and
			 uiCommonData:IsHaveCassetteTape( "tp_chico_08" ) == false ) then
		Fox.Log("-------OnShowRewardPopupWindow:GetCompChico-------")
		-- 「チコの記録（完全版）」カセット入手ポップアップ
		hudCommonData:ShowBonusPopupItemTape( "reward_get_tape_allchico" )
		-- 「チコの記録（完全版）」カセット入手処理
		uiCommonData:GetBriefingCassetteTape( "tp_chico_08" )
	end
	-- 全てのHardモードクリアで「ANUBISテーマ」入手
	if ( AllHardClear == true and
			 uiCommonData:IsHaveCassetteTape( "tp_bgm_01" ) == false ) then
		Fox.Log("-------OnShowRewardPopupWindow:GetAnubis-------")
		-- 「ANUBISテーマ」カセット入手ポップアップ
		hudCommonData:ShowBonusPopupItemTape( "reward_get_tape_tp_bgm_01" )
		-- 「ANUBISテーマ」カセット入手処理
		uiCommonData:GetBriefingCassetteTape( "tp_bgm_01" )
	end
	--------------------------------------------------------------------------------------
	-- ④　GroundZeros、HARD-MODE解放＆サイドＯＰＳミッション解放
	--------------------------------------------------------------------------------------
	if	TppGameSequence.GetGameFlag("hardmode") == false and					-- ノーマルクリアかつ
		PlayRecord.GetMissionScore( 20010, "NORMAL", "CLEAR_COUNT" ) == 1 then	-- 初回クリアなら

		hudCommonData:ShowBonusPopupCommon( "reward_extreme" )					-- ハード解放
	end
	-- e20010クリア回数が１回目なら、SIDE-OPS解放
	if ( hardmode ) then
		-- ハードモードだったら出さない
	else
		if ( clear_cnt == 1 ) then
			--　クリアした際にサイドＯＰＳ４ミッションを解放
	--		hudCommonData:ShowBonusPopupMission( "reward_open_side_ops", 1 )
			hudCommonData:ShowBonusPopupMission( "reward_open_side_ops_20020", 2 )
			hudCommonData:ShowBonusPopupMission( "reward_open_side_ops_20040", 4 )
			hudCommonData:ShowBonusPopupMission( "reward_open_side_ops_20030", 3 )
			hudCommonData:ShowBonusPopupMission( "reward_open_side_ops_20050", 5 )
		else
			--　２回目からは無し
		end
	end
	--------------------------------------------------------------------------------------
	-- ⑤　ＸＯＦワッペン
	--------------------------------------------------------------------------------------
	-- ＸＯＦ全取得ミッションが解放されたら表示しないようにする
	if StoryFlags.GetFlag("gzXofWappen") == "notCleared" then
	-- if オマージュが解放されているか否か
		-- 取得数を表示
		if ( count == 1 ) then
			hudCommonData:ShowBonusPopupItemXOF( "reward_xof_num_01", 0 )
		elseif ( count == 2 ) then
			hudCommonData:ShowBonusPopupItemXOF( "reward_xof_num_02", 0 )
		elseif ( count == 3 ) then
			hudCommonData:ShowBonusPopupItemXOF( "reward_xof_num_03", 0 )
		elseif ( count == 4 ) then
			hudCommonData:ShowBonusPopupItemXOF( "reward_xof_num_04", 0 )
		elseif ( count == 5 ) then
			hudCommonData:ShowBonusPopupItemXOF( "reward_xof_num_05", 0 )
		elseif ( count == 6 ) then
			hudCommonData:ShowBonusPopupItemXOF( "reward_xof_num_06", 0 )
		elseif ( count == 7 ) then
			hudCommonData:ShowBonusPopupItemXOF( "reward_xof_num_07", 0 )
		elseif ( count == 8 ) then
			hudCommonData:ShowBonusPopupItemXOF( "reward_xof_num_08", 0 )
		-- 全取得時ミッション解放
		elseif ( count == 9 ) then
			hudCommonData:ShowBonusPopupItemXOF( "reward_xof_num_09", 0 )
			if ( TppGameSequence.IsEnableSkull() == true ) then
				hudCommonData:ShowBonusPopupMission( "reward_open_side_ops_20070", 13 )
			else
				hudCommonData:ShowBonusPopupMission( "reward_open_side_ops_20060", 6 )
			end
			-- ミッション解放
			StoryFlags.SetFlag("gzXofWappen","cleared")
		end
	end
	--実績をユーザーが削除しない限り何度でも実績を出す
	if ( count == 9 ) then
		Trophy.TrophyUnlock( 15 )		-- ＸＯＦ全て集めた実績
	end
	--------------------------------------------------------------------------------------

	-- いずれのポップアップも呼ばれなかったら即座に次シーケンスへ
	if ( hudCommonData:IsShowBonusPopup() == false ) then
		Fox.Log("-------OnShowRewardPopupWindow:NoPopup!!-------")
		TppSequence.ChangeSequence( "Seq_MissionEnd" )	-- ST_CLEARから先に進ませるために次シーケンスへ
	end
end
---------------------------------------------------------------------------------
-- Mission Flag List
---------------------------------------------------------------------------------
this.MissionFlagList = {

}
---------------------------------------------------------------------------------
-- Demo List
---------------------------------------------------------------------------------
this.DemoList = {
	MotherbaseDestroyed	= "p11_010200_000",
	PazOperate = "p11_010180_000",
	PazOperate_JP = "p11_010185_000",
}


---------------------------------------------------------------------------------
-- Mission Functions
---------------------------------------------------------------------------------

local onMissionPrepare = function()
	-- テクスチャロード待ち処理
	MissionManager.SetMiddleTextureWaitParameter( 0.5, 5 )
end

local onMissionExec = function()
	-- Set lut
	-- TODO: delete this!!
--	local colorCorrectionLUTPath = "/Assets/tpp/effect/gr_pic/lut/ombs_demo_r8_FILTERLUT.ftex"
	local colorCorrectionLUTPath = "ombs_demo_r8_FILTERLUT"
	TppEffectUtility.SetColorCorrectionLut( colorCorrectionLUTPath )

	--パスミッションのプローブのレンジ
	GrTools.SetLightingColorScale(4.0)

	-- Set default time and weather
	TppClock.SetTime( "06:35:00" )
	TppClock.Stop()
	TppWeather.SetWeather( "sunny" )
	TppWeather.Stop()
end

local onDemoBlockLoad = function()
		-- Load demo block
		local demoBlockPath = "/Assets/tpp/pack/mission/extra/e20010/e20010_d03.fpk"
		TppMission.LoadDemoBlock( demoBlockPath )
end
---------------------------------------------------------------------------------
-- Sequences
---------------------------------------------------------------------------------
this.Messages = {
	UI = {
		-- ポップアップの終了メッセージ（予定）
		-- { message = "PopupClose", commonFunc = function() this.OnShowRewardPopupWindow() end },
	},
}
---------------------------------------------------------------------------------
this.Seq_Mission_Prepare = {

	OnEnter = function()
		onMissionPrepare()

		--このミッション開始時に画面がどうであるかをみて、進行を処理するため
		local hudCommonData = HudCommonDataManager.GetInstance()
		if hudCommonData:IsEndLoadingTips() == false then
			this.startViewMode = "tips" -- tipsモード
		else
			this.startViewMode = "result" -- resultモード
		end

		TppSequence.ChangeSequence( "Seq_Mission_Exec" )
	end,
}

---------------------------------------------------------------------------------
this.Seq_Mission_Exec = {

	OnEnter = function()
		onMissionExec()
		TppSequence.ChangeSequence( "Seq_Game_OpeningDemoLoad" )
	end,
}
---------------------------------------------------------------------------------
-- Demo&EventBlockのLoad完了確認
local IsDemoAndEventBlockActive = function()
	if ( TppMission.IsDemoBlockActive() == false ) then
		return false
	end
	if ( MissionManager.IsMissionStartMiddleTextureLoaded() == false ) then
		return false
	end

	return true

end

this.Seq_Game_OpeningDemoLoad = {

	OnEnter = function()
		onDemoBlockLoad()
	end,

	OnUpdate = function()
		--if( TppMission.IsDemoBlockActive() ) then
		if( IsDemoAndEventBlockActive() ) then
			--Fox.Log("********** Call - Seq_Demo_PazOperate ********** ")
			--TppSequence.ChangeSequence( "Seq_Demo_PazOperate" )
			TppSequence.ChangeSequence( "Seq_Wait_EndTelop" )
		end
	end,
}

---------------------------------------------------------------------------------

this.Seq_Wait_EndTelop = {

	OnEnter = function()
		Fox.Log("********** Call - Seq_Wait_EndTelop ********** ")
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:SetMissionEndTelopButtonDisp()
	end,

	OnUpdate = function()
		if ( this.startViewMode == "tips" ) then -- tipsモード
			local hudCommonData = HudCommonDataManager.GetInstance()
			if hudCommonData:IsEndLoadingTips() == false then
				hudCommonData:PermitEndLoadingTips() --終了許可(決定ボタンを押したら消える)
			else
				TppSequence.ChangeSequence( "Seq_Demo_PazOperate" )
			end
		end
	end,

	Messages = {
		UI = {
			{ message = "EndMissionTelopFadeOut" , commonFunc = function() TppSequence.ChangeSequence( "Seq_Demo_PazOperate" ) end },	--エンドロール終了後、報酬画面に遷移
		},
	},
}

---------------------------------------------------------------------------------
this.Seq_Demo_PazOperate = {

	OnEnter = function()
		if (TppGameSequence.GetTargetArea() == "Japan" ) then		--日本版だったら
			TppDemo.Play( "PazOperate_JP", {
				onStart = function() TppUI.FadeIn( 2 ) end,
				onEnd = function()
					TppUI.FadeOut( 0 )
					TppDemo.Play( "MotherbaseDestroyed", {
						onStart = function() TppUI.FadeIn(2) end,
						onEnd = function()
							TppPlayerUtility.SetPause()
							TppSequence.ChangeSequence( "Seq_EndRoll" )	--エンドロールシーケンスに遷移
							TppUI.FadeOut(0)
						end,
					} )
				end
			} )
		else														--海外版だったら
			TppDemo.Play( "PazOperate", {
				onStart = function() TppUI.FadeIn( 2 ) end,
				onEnd = function()
					TppUI.FadeOut( 0 )
					TppDemo.Play( "MotherbaseDestroyed", {
						onStart = function() TppUI.FadeIn(2) end,
						onEnd = function()
							TppPlayerUtility.SetPause()
							TppSequence.ChangeSequence( "Seq_EndRoll" )	--エンドロールシーケンスに遷移
							TppUI.FadeOut(0)
						end,
					} )
				end
			} )
		end
	end,
}
---------------------------------------------------------------------------------
this.Seq_EndRoll = {

	MissionState = "clear",

	Messages = {
		UI = {
			{ message = "GzEndingFinish" , commonFunc = function() TppSequence.ChangeSequence( "Seq_ShowClearReward" ) end },	--エンドロール終了後、報酬画面に遷移
		},
	},

	OnEnter = function()
		--エンドロール開始
		GzEnding.Start()
		Fox.Warning("----------------- Seq_EndRoll -----------------")
	end,

}
---------------------------------------------------------------------------------
this.Seq_Mission_Clear = {

	OnEnter = function()
--		TppMissionManager.SaveGame()
		TppSequence.ChangeSequence( "Seq_MissionEnd" )
	end,
}

---------------------------------------------------------------------------------
this.Seq_MissionAbort = {
	OnEnter = function()
		TppMission.ChangeState( "abort" )
		TppSequence.ChangeSequence( "Seq_MissionEnd" )
	end,
}
---------------------------------------------------------------------------------
this.Seq_MissionFailed = {
	OnEnter = function()
		TppMission.ChangeState( "failed" )
		TppSequence.ChangeSequence( "Seq_MissionEnd" )
	end,
}
---------------------------------------------------------------------------------
-- 報酬シーケンス
---------------------------------------------------------------------------------
-- ■ Seq_ShowClearReward
-- ミッションクリア後の報酬表示シーケンス
this.Seq_ShowClearReward = {
--[[
	Messages = {
		UI = {
			-- ポップアップの終了メッセージ
			{ message = "PopupClose", commonFunc = function() this.OnClosePopupWindow() end },
		},
	},
--]]

	Messages = {
		UI = {
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
this.Seq_MissionEnd = {

	OnEnter = function()
		TppMissionManager.SaveGame()
		TppMission.ChangeState( "end" )
	end,
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Skip Functions
------------------------------------------------------------------------------------------------------------------------------------------------------------------
this.OnSkipEnterCommon = function()
	local sequence = TppSequence.GetCurrentSequence()

	onDemoBlockLoad()

	-- Set all mission states
	if( TppSequence.IsGreaterThan( sequence, "Seq_MissionFailed" ) ) then
		TppMission.ChangeState( "failed" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionAbort" ) ) then
		TppMission.ChangeState( "abort" )
	elseif( TppSequence.IsGreaterThan( sequence, "Seq_MissionClear" ) ) then
		TppMission.ChangeState( "clear" )
	--elseif( TppSequence.IsGreaterThan( sequence, "Seq_Mission_Prepare" ) ) then
	--	TppMission.ChangeState( "exec" )
	end
end

this.OnSkipUpdateCommon = function()
	return IsDemoAndEventBlockActive()
end

this.OnSkipLeaveCommon = function()

end
---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this