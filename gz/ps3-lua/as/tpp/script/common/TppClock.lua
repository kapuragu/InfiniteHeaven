local this = {}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Register clock message
this.RegisterClockMessage = function( time, message, esmType )
	local esmType = esmType or "mission"
	local seqManager = 	TppSequence.GetManager( esmType )
	local hour, min, sec = this._ParseTimeString( time )
	WeatherManager.RegisterClockMessage( hour, min, message, seqManager )
end

-- Get current time
this.GetTime = function( style )
	local time = WeatherManager.GetCurrentClock()

	-- hour
	local hour = math.floor( time / 60 / 60 )
	local h = hour * 60 * 60
	-- minute
	local min = math.floor( ( time - h ) / 60 )
	local m = min * 60
	-- second
	local sec = math.floor( time - h - m )
	local s = sec

	style = style or "time"
	if( style == "time" ) then
		return hour, min, sec
	elseif( style == "number" ) then
		return ( h + m + s )
	else
		Fox.Error( "Cannot execute! [" .. tostring( style ) .. "] is not a valid parse style!" )
		return nil
	end
end

-- Get current time of day
this.GetTimeOfDay = function()
	local times = TppLocation.GetTimes()

	local dayTime = this._ParseTimeString( times.day, "number" )
	local nightTime = this._ParseTimeString( times.night, "number" )
	local currTime = this.GetTime( "number" )

	if( currTime < dayTime or currTime >= nightTime ) then
		return "night"
	elseif( currTime >= dayTime and currTime < nightTime ) then
		return "day"
	end
end

-- Set current time
this.SetTime = function( time )
	local hour, min, sec = this._ParseTimeString( time )
	WeatherManager.SetCurrentClock( hour, min, sec )
end

-- Start clock moving
this.Start = function()
	TppCommon.DeprecatedFunction( "WeatherManager.PauseClock( false )" )
	WeatherManager.PauseClock( false )
end

-- Stop clock from moving
this.Stop = function()
	TppCommon.DeprecatedFunction( "WeatherManager.PauseClock( true )" )
	WeatherManager.PauseClock( true )
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

-- Convert string time to hour / min / sec or number
this._ParseTimeString = function( time, style )
	if( time == nil or type( time ) ~= "string" ) then
		Fox.Error( "Cannot execute! [time] parameter is invalid!" )
		return nil
	end

	local values = TppUtility.SplitString( time, ":" )
	local hour	= tonumber( values[1] )
	local min	= tonumber( values[2] )
	local sec	= tonumber( values[3] )

	style = style or "time"
	if( style == "time" ) then
		return hour, min, sec
	elseif( style == "number" ) then
		local h = hour * 60 * 60
		local m = min * 60
		local s = sec
		return ( h + m + s )
	else
		Fox.Error( "Cannot execute! [" .. tostring( style ) .. "] is not a valid parse style!" )
		return nil
	end
end

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this