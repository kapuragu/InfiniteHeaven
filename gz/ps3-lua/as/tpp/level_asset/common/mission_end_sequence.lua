--[[
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--        Author          ：       Tanimoto_Hayato
--        Outline         ：       ミッション地上クリア時の共通演出シーケンス
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--]]

mission_end_sequence = {

--******************************************************************************
-- シーケンス初期化
--******************************************************************************

sequences = {
	{ "SEQ_START",			},	-- ■ クリア時演出の開始（初期化処理）
	{ "SEQ_TELOP",		"/Assets/tpp/level_asset/common/mission_end_sequence_ground.lua"	},		-- ■ テロップ表示
	{ "SEQ_TELOP_HELI",	"/Assets/tpp/level_asset/common/mission_end_sequence_heli.lua"	},	-- ■ テロップ表示
	{ "SEQ_END",				},	-- ■ クリア時演出の終了（開放処理）
},

--******************************************************************************
-- 各フェーズ毎の処理
--******************************************************************************

--------------------------------------------------------------------------------
SEQ_START = {

	OnEnter = function( manager )

		Fox.Log("mission_end_sequence_SEQ_START")


		--プレイヤーがヘリに乗っているかで次のシーケンスIDを呼び分ける
		if missionCommon_functionSet.IsFromHelicopter() == false then
			--テロップ関連の初期化
			--missionCommon_functionSet.SetEndTelopCallBackSetting("/Assets/tpp/level_asset/common/mission_end_sequence.lua", "FuncEndTelopEnd")
			TppEventSequenceManagerCollector.GoNextSequence( "TppEventSequenceManagerData_mission_end", "SEQ_TELOP" )
		else
			--テロップ関連の初期化
			--missionCommon_functionSet.SetEndTelopCallBackSetting("/Assets/tpp/level_asset/common/mission_end_sequence.lua", "FuncEndTelopHeliEnd")
			TppEventSequenceManagerCollector.GoNextSequence( "TppEventSequenceManagerData_mission_end", "SEQ_TELOP_HELI" )

		end

		--コールバックタイミングを、黒背景が消える前に変更
		--local hudCommonData = HudCommonDataManager.GetInstance()
		--hudCommonData:SetMissionTelopCallBackPreFade()
	end,

},

SEQ_END = {

	OnEnter = function( manager )

		Fox.Log("mission_end_sequence_SEQ_END")
		--シーケンスの破棄とmissionStateの進行
		manager:AllSequencesIsEnded()
	end,

},

--******************************************************************************
-- クリア時演出シーケンス専用関数
--******************************************************************************
--[[
-- * テロップ終了時処理
FuncEndTelopEnd = function()
	Fox.Log("FuncEndTelopEnd ")
	TppEventSequenceManagerCollector.GoNextSequence( "TppEventSequenceManagerData_mission_end", "SEQ_END" )
end,

-- * テロップ終了時処理
FuncEndTelopHeliEnd = function()
	Fox.Log("FuncEndTelopHeliEnd ")
	TppEventSequenceManagerCollector.GoNextSequence( "TppEventSequenceManagerData_mission_end", "SEQ_END" )
end,
]]--
}

