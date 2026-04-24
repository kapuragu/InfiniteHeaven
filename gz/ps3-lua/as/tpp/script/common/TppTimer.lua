local this = {}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Setup
this.Setup = function()
	-- stop all timers
	GkEventTimerManager.StopAll()
end

-- Start timer
this.Start = function( timerName, timerTime )
	TppCommon.DeprecatedFunction( "GkEventTimerManager.Start( timerName, timerTime )" )
	GkEventTimerManager.Start( timerName, timerTime )
end

-- Stop timer
this.Stop = function( timerName )
	TppCommon.DeprecatedFunction( "GkEventTimerManager.Stop( timerName )" )
	GkEventTimerManager.Stop( timerName )
end

-- Stop all currently active timers
this.StopAll = function()
	TppCommon.DeprecatedFunction( "GkEventTimerManager.StopAll()" )
	GkEventTimerManager.StopAll()
end

-- Check if timer is active or not
this.IsTimerActive = function( timerName )
	TppCommon.DeprecatedFunction( "GkEventTimerManager.IsTimerActive( timerName )" )
	return GkEventTimerManager.IsTimerActive( timerName )
end

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this