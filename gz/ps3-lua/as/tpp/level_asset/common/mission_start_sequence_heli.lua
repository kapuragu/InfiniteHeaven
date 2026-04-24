
mission_start_sequence_heli = {

SEQ_TELOP_HELI = {

	OnEnter = function( manager )

		Fox.Log("mission_start_sequence_SEQ_TELOP_HELI")
		missionCommon_functionSet.SetSequenceIdToSkip( manager,"SEQ_END" )

		--開始時テロップの再生
		missionCommon_functionSet.PlayMissionOpeningTelop()
	end,

},

}