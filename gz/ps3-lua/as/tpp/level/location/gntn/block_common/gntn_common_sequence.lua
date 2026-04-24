local this = {}

---------------------------------------------------------------------------------
-- EventSequenceManager
---------------------------------------------------------------------------------
this.RequiredFiles = {
	"/Assets/tpp/script/common/TppCommon.lua",
}

this.Sequences = {
	{ "Seq_LocationSetup" },
	{ "Seq_MainSequence" },
}

this.OnStart = function( manager )
	TppCommon.Register( this, manager, "location" )
	TppLocation.Setup()
end

this.OnEnterCommon = function()
	local sequence = TppSequence.GetCurrentSequence( "location" )
	Fox.Log( "=== " .. sequence .. " : OnEnter ===" )
end

this.OnLeaveCommon = function()
	local sequence = TppSequence.GetCurrentSequence( "location" )
	Fox.Log( "=== " .. sequence .. " : OnLeave ===" )
end

---------------------------------------------------------------------------------
-- Location Data
---------------------------------------------------------------------------------

this.LocationName = "gntn"

this.Times = {
	day		= "5:00:00",
	night	= "19:00:00",
}

this.CommandPostNames = {
}

this.OuterBaseNames = {
}

this.DefaultRouteSets = {
	-----------------------------------------------------------------------------
	-- Command Posts
	{	cpID = "gntn_cp",
		holdTime = 1,
		sets = {
		},
	},
}

---------------------------------------------------------------------------------
-- Location Flags
---------------------------------------------------------------------------------
this.LocationFlagList = {
}

---------------------------------------------------------------------------------
-- Sequences
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
this.Seq_LocationSetup = {

	OnEnter = function()
		TppSequence.ChangeSequence( "Seq_MainSequence", "location" )
	end,
}

---------------------------------------------------------------------------------
this.Seq_MainSequence = {

	OnEnter = function()
	end,
}

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this