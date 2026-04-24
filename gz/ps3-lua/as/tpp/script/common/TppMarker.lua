local this = {}

---------------------------------------------------------------------------------
-- Lists
---------------------------------------------------------------------------------
this.GoalTypes = {
	none	= "GOAL_NONE",
	moving	= "GOAL_MOVE",
	attack	= "GOAL_ATTACK",
	defend	= "GOAL_DEFENSE",
}

this.ViewTypes = {
	map		= { "VIEW_MAP_GOAL" },
	all		= { "VIEW_MAP_GOAL", "VIEW_WORLD_GOAL" },
	map_only_icon = { "VIEW_MAP_ICON" },
	map_and_world_only_icon = { "VIEW_MAP_ICON", "VIEW_WORLD_ICON" },
}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Setup
this.Setup = function()
	-- Turn off all markers
	TppMarkerSystem.DisableAllMarker()
end

-- Enable marker object
this.Enable = function( markerID, visibleArea, goalType, viewType, randomRange, setImportant, setNew)
	-- Set default value
	visibleArea = visibleArea or 0
	goalType = goalType or "moving"
	viewType = viewType or "map"
	randomRange = randomRange or 9

	if( type( visibleArea ) ~= "number" ) then
		Fox.Error( "Cannot execute! visibleArea is not a number!" )
		return
	end
	if( visibleArea < 0 or visibleArea > 9 ) then
		Fox.Error( "Cannot execute! visibleArea needs to be between 0 and 9!" )
		return
	end

	if( type( randomRange ) ~= "number" ) then
		Fox.Error( "Cannot execute! randomRange is not a number!" )
		return
	end
	if( randomRange < 0 or randomRange > 9 ) then
		Fox.Error( "Cannot execute! randomRange needs to be between 0 and 9!" )
		return
	end

	local _goalType = this.GoalTypes[goalType]
	if( _goalType == nil ) then
		Fox.Error( "Cannot execute! [" .. tostring( goalType ) .. "] is not a valid goalType!" )
		return
	end

	local _viewType = this.ViewTypes[viewType]
	if( _viewType == nil ) then
		Fox.Error( "Cannot execute! [" .. tostring( viewType ) .. "] is not a valid viewType!" )
		return
	end

	-- enable marker
	for i = 1, #_viewType do
		local marker_enabled = {
			markerId = markerID,
			viewType = _viewType[i]
		}
		TppMarkerSystem.EnableMarker( marker_enabled )
	end

	-- Set markerType
	local marker_setting = {
		markerId = markerID,
		radiusLevel = visibleArea,
		goalType = _goalType,
		randomLevel = randomRange
	}
	TppMarkerSystem.SetMarkerGoalType( marker_setting )

	-- Set Important
	local marker_setimportant = {
		markerId = markerID,
		isImportant = setImportant
	}
	if ( setImportant ~= nil) then
		TppMarkerSystem.SetMarkerImportant(marker_setimportant)
	end

	-- Set New
	local marker_setNew = {
		markerId = markerID,
		isNew = setNew
	}
	if ( setNew ~= nil) then
		TppMarkerSystem.SetMarkerNew(marker_setNew)
	end




end

-- Disable marker object
this.Disable = function( markerID )
	TppCommon.DeprecatedFunction( "TppMarkerSystem.DisableMarker{ markerId = markerID }" )
	TppMarkerSystem.DisableMarker{ markerId = markerID }
end

-- Disable all marker objects
this.DisableAll = function()
	TppCommon.DeprecatedFunction( "TppMarkerSystem.DisableAllMarker()" )
	TppMarkerSystem.DisableAllMarker()
end

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this