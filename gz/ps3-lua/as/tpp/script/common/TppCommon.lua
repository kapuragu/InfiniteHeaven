local this = {}

------------------------------------------------------------------------
-- RequireList
------------------------------------------------------------------------
this.RequiredFiles = {
	"/Assets/tpp/script/common/TppClock.lua",
	"/Assets/tpp/script/common/TppData.lua",
--	"/Assets/tpp/script/common/TppDebug.lua",
	"/Assets/tpp/script/common/TppDemo.lua",
	"/Assets/tpp/script/common/TppEffect.lua",
	"/Assets/tpp/script/common/TppEnemy.lua",
	"/Assets/tpp/script/common/TppGimmick.lua",
	"/Assets/tpp/script/common/TppHelicopter.lua",
	"/Assets/tpp/script/common/TppLocation.lua",
	"/Assets/tpp/script/common/TppMarker.lua",
	"/Assets/tpp/script/common/TppMission.lua",
	"/Assets/tpp/script/common/TppPlayer.lua",
	"/Assets/tpp/script/common/TppRadio.lua",
	"/Assets/tpp/script/common/TppSequence.lua",
	"/Assets/tpp/script/common/TppSound.lua",
	"/Assets/tpp/script/common/TppStaticModel.lua",
	"/Assets/tpp/script/common/TppTerminal.lua",
	"/Assets/tpp/script/common/TppTimer.lua",
	"/Assets/tpp/script/common/TppUI.lua",
	"/Assets/tpp/script/common/TppUtility.lua",
	"/Assets/tpp/script/common/TppWeather.lua",
}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Register necessary data
this.Register = function( script, manager, type )
	type = type or "mission"

	-- Do for any type
	TppSequence.Register( script, manager, type )
	TppTerminal.Start()

	-- Only do for location
	if( type == "location" ) then
		TppLocation.Register( script )

	-- Only do for mission
	elseif( type == "mission" ) then
		TppDemo.Register( script.DemoList )
		TppMission.Register( script.missionID, script.MissionFlagList )
		TppRadio.Register( script.RadioList, script.OptionalRadioList, script.IntelRadioList )

		-- Start initialization procedures for other common scripts
		TppDemo.Start()
		TppMission.Start()
		TppRadio.Start()
		TppSound.Start()
		TppUI.Start()
	end
end

-- Show deprecated function errors
this.ShowDeprecatedFunctionErrors = false
this.DeprecatedFunction = function( useFunc )
	if( not DEBUG ) then return end
	if( this.ShowDeprecatedFunctionErrors == false ) then return end

	-- stack trace for calling deprecated functions
	Fox.Warning( "Start Deprecated Function Trace --" )
	local level = 2
	while( true ) do
		local info = debug.getinfo( level )
		if( info == nil ) then break end

		if( info.what == "C" ) then
			print( "Calling function: C function" )
		else
			local gTable = TppUtility.SplitString( info.source, "/" )
			gTable = gTable[#gTable]
			gTable = TppUtility.SplitString( gTable, "%." )
			gTable = gTable[1]
			local name = info.name
			if( name ~= nil ) then
				Fox.Error( "Calling function: " .. gTable .. "." .. tostring( name ) .. "()" )
			else
				Fox.Error( "Calling deprecated function in " .. gTable )
			end
		end
		level = level + 1
	end
	Fox.Warning( "-- End Deprecated Function Trace" )
end

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this