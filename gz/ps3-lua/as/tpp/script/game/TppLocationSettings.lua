local this = {}

---------------------------------------------------------------------------------
-- Lists
---------------------------------------------------------------------------------
this.Times = {
}

this.RouteSets = {
}

---------------------------------------------------------------------------------
-- Internal Functions
---------------------------------------------------------------------------------

-- Get time table
this.GetTimes = function( locationName )
	return this.Times[locationName]
end

-- Get route sets table
this.GetRouteSets = function( locationName )
	return this.RouteSets[locationName]
end

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this