
mission_end_sequence_ground = {

SEQ_TELOP = {

	OnEnter = function( manager )

		Fox.Log("mission_end_sequence_SEQ_TELOP")
		missionCommon_functionSet.SetSequenceIdToSkip( manager,"SEQ_END" )

		--開始時テロップの再生
		missionCommon_functionSet.PlayMissionEndTelop()
		TppEventSequenceManagerCollector.GoNextSequence( "TppEventSequenceManagerData_mission_end", "SEQ_END" )
	end,

},

}