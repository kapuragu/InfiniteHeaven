--[[
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--        Author          ：       Tanimoto_Hayato
--        Outline         ：       ミッション地上開始時の共通演出シーケンス
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--]]

mission_start_sequence = {

--******************************************************************************
-- シーケンス初期化
--******************************************************************************

sequences = {
	{ "SEQ_START",			},	-- ■ 開始時演出の開始（初期化処理）
	{ "SEQ_OPENING_DEMO",	"/Assets/tpp/level_asset/common/mission_start_sequence_ground.lua"	},	-- ■ 開始時デモ再生
	{ "SEQ_TELOP",		"/Assets/tpp/level_asset/common/mission_start_sequence_ground.lua"	},	-- ■ テロップ表示
	{ "SEQ_TELOP_HELI",	"/Assets/tpp/level_asset/common/mission_start_sequence_heli.lua"	},	-- ■ テロップ表示
	{ "SEQ_END",				},	-- ■ 開始時演出の終了（開放処理）
},

--******************************************************************************
-- 各フェーズ毎の処理
--******************************************************************************

--------------------------------------------------------------------------------
SEQ_START = {

	OnEnter = function( manager )

		Fox.Log("mission_start_sequence_SEQ_START")


		--プレイヤーがヘリに乗っているかで次のシーケンスIDを呼び分ける
		if missionCommon_functionSet.IsFromHelicopter() == false then

			--テロップ関連の初期化
			missionCommon_functionSet.SetOpeningTelopCallBackSetting("/Assets/tpp/level_asset/common/mission_start_sequence.lua", "FuncStartTelopEnd")

			--開始時デモからの受信メッセージを登録
			manager:RegisterReceiveMessageFromDemo( "DemoTelopTiming" )
			TppEventSequenceManagerCollector.GoNextSequence( "TppEventSequenceManagerData_mission_start", "SEQ_OPENING_DEMO" )
		else

			--テロップ関連の初期化
			missionCommon_functionSet.SetOpeningTelopCallBackSetting("/Assets/tpp/level_asset/common/mission_start_sequence.lua", "FuncStartTelopHeliEnd")

			TppEventSequenceManagerCollector.GoNextSequence( "TppEventSequenceManagerData_mission_start", "SEQ_TELOP_HELI" )

		end

		--コールバックタイミングを、黒背景が消える前に変更
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:SetMissionTelopCallBackPreFade()

	end,

},

SEQ_END = {

	OnEnter = function( manager )

		Fox.Log("mission_start_sequence_SEQ_END")
		--シーケンスの破棄とmissionStateの進行
		manager:AllSequencesIsEnded()
	end,

},

--******************************************************************************
-- 開始時演出シーケンス専用関数
--******************************************************************************
-- * テロップ終了時処理
FuncStartTelopEnd = function()
	Fox.Log("FuncStartTelopEnd ")
	TppEventSequenceManagerCollector.GoNextSequence( "TppEventSequenceManagerData_mission_start", "SEQ_END" )
end,

-- * テロップ終了時処理
FuncStartTelopHeliEnd = function()
	Fox.Log("FuncStartTelopEnd ")
	TppEventSequenceManagerCollector.GoNextSequence( "TppEventSequenceManagerData_mission_start", "SEQ_END" )
end,

}
