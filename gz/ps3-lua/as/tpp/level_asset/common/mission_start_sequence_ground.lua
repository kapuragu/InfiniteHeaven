mission_start_sequence_ground = {

SEQ_OPENING_DEMO = {

	OnEnter = function( manager )

		Fox.Log("mission_start_sequence_SEQ_OPENING_DEMO")
		missionCommon_functionSet.SetSequenceIdToSkip( manager,"SEQ_TELOP" )

		--開始時デモの再生
		manager:PlayDemo( "p41_020000" )
	end,

	OnReceiveMessageRegistered = function( manager, messageId, arg0 )
		--デモ終了時にテロップに向かう
		if messageId == "DemoTelopTiming" and arg0 == "p41_020000" then
		missionCommon_functionSet.PlayMissionOpeningTelop()
			--TppEventSequenceManagerCollector.GoNextSequence( "TppEventSequenceManagerData_mission_start", "SEQ_TELOP" )
		end
	end,

},

SEQ_TELOP = {

	OnEnter = function( manager )

		Fox.Log("mission_start_sequence_SEQ_TELOP")
		missionCommon_functionSet.SetSequenceIdToSkip( manager,"SEQ_END" )

		--開始時テロップの再生
		missionCommon_functionSet.PlayMissionOpeningTelop()
	end,

},


}