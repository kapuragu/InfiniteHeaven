local this = {}

---------------------------------------------------------------------------------
-- Lists
---------------------------------------------------------------------------------
this.WeatherNames = {
	sunny		= 0,
	cloudy		= 1,
	rainy		= 2,
	sandstorm	= 3,
	foggy		= 4,
	pouring		= 5,
}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Set current weather
this.SetWeather = function( weather, conversionTime )
	TppCommon.DeprecatedFunction( "WeatherManager.RequestWeather( weather, conversionTime )" )
	conversionTime = conversionTime or 0
	if( this._IsWeatherNameValid( weather ) == false ) then return end
	local _weather = this.WeatherNames[weather]
	WeatherManager.RequestWeather( _weather, conversionTime )
end

-- Set default weather
this.SetDefaultWeather = function( weather )
	TppCommon.DeprecatedFunction( "WeatherManager.SetNewWeatherDefault( weather )" )
	if( this._IsWeatherNameValid( weather ) == false ) then return end
	local _weather = this.WeatherNames[weather]
	WeatherManager.SetNewWeatherDefault( _weather )
end

-- Set randomness of weather
this.SetRandomness = function( changeInterval, changeIntervalAdjustment, changeTime )
	TppCommon.DeprecatedFunction( "WeatherManager.SetNewWeatherChangeRandomParameters( changeInterval, changeIntervalAdjustment, changeTime )" )
	WeatherManager.SetNewWeatherChangeRandomParameters( changeInterval, changeIntervalAdjustment, changeTime )
end

-- Set weather change time
this.SetChangeTime = function( changeTime )
	TppCommon.DeprecatedFunction( "WeatherManager.SetNewNextWeatherChangeTime( changeTime )" )
	WeatherManager.SetNewNextWeatherChangeTime( changeTime )
end

-- Set weather probabilities
this.SetProbabilities = function( probabilities )
	TppCommon.DeprecatedFunction( "WeatherManager.SetNewWeatherProbabilities( type, probabilities )" )
	local probs = {}
	for i = 1, #probabilities do
		local weatherName = probabilities[i][1]
		local percentage = probabilities[i][2]
		if( this._IsWeatherNameValid( weatherName ) == false ) then return end
		local weather = this.WeatherNames[weatherName]
		table.insert( probs, { weather, percentage } )
	end
	WeatherManager.SetNewWeatherProbabilities( "default", probs )
end

-- Start randomization of weather
this.Start = function()
	TppCommon.DeprecatedFunction( "WeatherManager.PauseNewWeatherChangeRandom( false )" )
	WeatherManager.PauseNewWeatherChangeRandom( false )
end

-- Stop randomization of weather
this.Stop = function()
	TppCommon.DeprecatedFunction( "WeatherManager.PauseNewWeatherChangeRandom( true )" )
	WeatherManager.PauseNewWeatherChangeRandom( true )
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

-- Check weather a weatherName is valid
this._IsWeatherNameValid = function( weatherName )
	if( this.WeatherNames[weatherName] == nil ) then
		Fox.Error( "Cannot execute! [" .. weatherName .. "] is not a valid weather name!" )
		return false
	end
	return true
end

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this