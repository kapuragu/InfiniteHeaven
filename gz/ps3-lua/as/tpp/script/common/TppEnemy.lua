local this = {}

---------------------------------------------------------------------------------
-- Messages
---------------------------------------------------------------------------------
this.Messages = {
	CommandPost = {
		{ message = "Sneak", commonFunc = function() this._ChangeRouteSetOnPhase( "sneak" ) end },
		{ message = "Caution", commonFunc = function() this._ChangeRouteSetOnPhase( "caution" ) end },
	},
	Weather = {
		{ message = "_locationDayTime",		commonFunc = function() this._ChangeRouteSetOnTime( "day" ) end },
		{ message = "_locationNightTime",	commonFunc = function() this._ChangeRouteSetOnTime( "night" ) end },
	},
}

---------------------------------------------------------------------------------
-- Lists
---------------------------------------------------------------------------------
this.PhaseNames = {
	sneak	= "Sneak",
	caution	= "Caution",
	alert	= "Alert",
}

this.RouteSetTypes = {
	"sneak_day",
	"sneak_night",
	"caution_day",
	"caution_night",
	"hold",
}

this.EnemyStatusList = {
	dead			= "Dead",
	dying			= "Dying",
	sleep			= "Sleep",
	faint			= "Faint",
	broken_leftArm	= "BrokenLArm",
	broken_rightArm	= "BrokenRArm",
	broken_leftLeg	= "BrokenLLeg",
	broken_rightLeg	= "BrokenRLeg",
	dropWeapon		= "DropWeapon",
	holdUp			= "HoldUp",
	lieDown			= "HoldUpDown",
}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Setup
this.Setup = function()
	Fox.Log( "TppEnemy : [Setup] function called!" )
	
	-- set default route sets
	local defaultRouteSets = TppLocation.GetDefaultRouteSets()
	this.SetRouteSets( defaultRouteSets, { warpEnemy = true } )
end

------------------------------------------
-- Character
------------------------------------------

-- Get character
this.GetCharacter = function( characterID )
	TppCommon.DeprecatedFunction( "Ch.FindCharacterObjectByCharacterId( characterID )" )
	return Ch.FindCharacterObjectByCharacterId( characterID )
end

-- Get character's position
this.GetPosition = function( characterID )
	TppCommon.DeprecatedFunction( "character:GetPosition()" )
	local character = this.GetCharacter( characterID )
	if( character == nil ) then return end
	return character:GetPosition()
end

-- Set character's position
this.SetPosition = function( characterID, position )
	TppCommon.DeprecatedFunction( "character:SetPosition( position )" )
	local character = this.GetCharacter( characterID )
	if( character == nil ) then return end
	character:SetPosition( position )
end

-- Get character's rotation
this.GetRotation = function( characterID )
	TppCommon.DeprecatedFunction( "character:GetRotation()" )
	local character = this.GetCharacter( characterID )
	if( character == nil ) then return end
	return character:GetRotation()
end

-- Set character's rotation
this.SetRotation = function( characterID, rotation )
	TppCommon.DeprecatedFunction( "character:SetRotation( rotation )" )
	local character = this.GetCharacter( characterID )
	if( character == nil ) then return end
	character:SetRotation( rotation )
end

-- Warp character to warp locator
this.Warp = function( characterID, warpLocator )
	TppCommon.DeprecatedFunction( "TppCharacterUtility.WarpCharacterIdFromIdentifier( characterID, dataIdentifierID, keyName )" )
	local missionName = TppMission.GetMissionName()
	local warpLocatorID = missionName .. "_warpLocators"
	TppCharacterUtility.WarpCharacterIdFromIdentifier( characterID, warpLocatorID, warpLocator )
end

-- Check whether two characters are within a certain distance of each other
this.IsWithinDistance = function( chara01, chara02, distance )
	local pos1 = this.GetPosition( chara01 )
	local pos2 = this.GetPosition( chara02 )
	local dist = TppUtility.FindDistance( pos1, pos2 )

	-- Check if within distance
	if( dist <= (distance * distance) ) then
		return true
	else
		return false
	end
end

-- Set form variation
this.SetFormVariation = function( characterID, fovaKey )
	return TppCharacterUtility.ChangeFormVariationWithCharacterId( characterID, fovaKey, 0)
end

------------------------------------------
-- Enemy / Hostage
------------------------------------------

-- Get enemy's status
this.GetEnemyStatus = function( characterID )
	TppCommon.DeprecatedFunction( "TppEnemyUtility.GetLifeStatus( characterID )" )
	Fox.Log( "TppEnemy : [GetEnemyStatus] function called!" )
	return TppEnemyUtility.GetLifeStatus( characterID )
end

-- Set enemy's status
this.SetEnemyStatus = function( characterID, status )
	TppCommon.DeprecatedFunction( "TppEnemyUtility.ChangeStatus( characterID, status )" )
	Fox.Log( "TppEnemy : [GetEnemyStatus] function called!" )
	local _status = this.EnemyStatusList[status]
	if( _status == nil ) then
		Fox.Error( "Cannot execute! [" .. tostring( status ) .. "] is not a valid enemy status!" )
		return
	end
	TppEnemyUtility.ChangeStatus( characterID, _status )
end

-- Get hostage's status
this.GetHostageStatus = function( characterID )
	TppCommon.DeprecatedFunction( "TppHostageUtility.GetStatus( characterID )" )
	Fox.Log( "TppEnemy : [GetHostageStatus] function called!" )
	return TppHostageUtility.GetStatus( characterID )
end

-- Get enemy's type
this.GetEnemyType = function( characterID )
	TppCommon.DeprecatedFunction( "TppEnemyUtility.GetEnemyType( characterID )" )
	Fox.Log( "TppEnemy : [GetEnemyType] function called!" )
	return TppEnemyUtility.GetEnemyType( characterID )
end

-- Get number of realized enemies within the set radius of a character
this.GetEnemyCountNearEnemy = function( characterID, radius )
	TppCommon.DeprecatedFunction( "TppEnemyUtility.GetNumberOfActiveSoldierByCharacterId( characterID, radius )" )
	Fox.Log( "TppEnemy : [GetEnemyCountNearEnemy] function called!" )
	return TppEnemyUtility.GetNumberOfActiveSoldierByCharacterId( characterID, radius )
end

-- Realize enemy
this.RealizeEnemy = function( cpID, characterID, options )
	Fox.Log( "TppEnemy : [RealizeEnemy] function called!" )
	options = options or {}

	if( options.setPriority == true ) then
		TppCommandPostObject.GsSetRealizeFirstPriority( cpID, characterID, true )
	else
		TppCommandPostObject.GsSetRealizeEnable( cpID, characterID, true )
	end
end

-- Unrealize enemy
this.UnrealizeEnemy = function( cpID, characterID, options )
	Fox.Log( "TppEnemy : [UnrealizeEnemy] function called!" )
	options = options or {}

	if( options.setPriority == true ) then
		TppCommandPostObject.GsSetRealizeFirstPriority( cpID, characterID, false )
	else
		TppCommandPostObject.GsSetRealizeEnable( cpID, characterID, false )
	end
end

-- Kill enemy
this.KillEnemy = function( characterID )
	TppCommon.DeprecatedFunction( "TppEnemyUtility.KillEnemy( characterID )" )
	Fox.Log( "TppEnemy : [KillEnemy] function called!" )
	TppEnemyUtility.KillEnemy( characterID )
end

-- Kill Command Post
this.KillCommandPost = function( cpID )
	TppCommon.DeprecatedFunction( "TppEnemyUtility.GetNumberOfActiveSoldierByCharacterId( characterID, radius )" )
	Fox.Log( "TppEnemy : [KillCommandPost] function called!" )
	TppEnemyUtility.KillAllEnemiesInCp( cpID )
end

------------------------------------------
-- Phase
------------------------------------------

-- Get phase
this.GetPhase = function( cpID )
	Fox.Log( "TppEnemy : [GetPhase] function called!" )

	-- Return player phase if no cpID is set
	local phase
	if( cpID == nil ) then
		phase = TppCharacterUtility.GetCurrentPhaseName()
	else
		phase = TppCharacterUtility.GetCpPhaseName( cpID )
	end
	return string.lower( phase )
end

-- Set minimum phase for the cp
this.SetMinimumPhase = function( cpID, phase )
	TppCommon.DeprecatedFunction( "TppCommandPostObject.GsSetKeepPhaseName( cpID, phase )" )
	Fox.Log( "TppEnemy : [SetMinimumPhase] function called!" )
	if( this._IsPhaseNameValid( phase ) == false ) then return end
	local _phase = this.PhaseNames[phase]
	TppCommandPostObject.GsSetKeepPhaseName( cpID, _phase )
end

------------------------------------------
-- Route
------------------------------------------

-- Get characterID from routeID
this.GetCharacterOnRoute = function( cpID, routeID )
	TppCommon.DeprecatedFunction( "TppEnemyUtility.GetCharacterIdByRoute( cpID, routeID )" )
	Fox.Log( "TppEnemy : [GetCharacterOnRoute] function called!" )
	return TppEnemyUtility.GetCharacterIdByRoute( cpID, routeID )
end

-- Change an enemy's route within the current routeSet
this.ChangeRoute = function( cpID, enemyID, routeSetName, routeName, nodeNum, options )
	TppCommon.DeprecatedFunction( "TppCommandPostObject.GsSetPriorityEnemyForRoute( cpID, routeSetName, routeName, nodeNum, enemyID, priorityType )" )
	Fox.Log( "TppEnemy : [ChangeRoute] function called!" )
	options = options or {}

	local priorityType
	if( options.forceChange == true ) then
		priorityType = "ROUTE_PRIORITY_TYPE_FORCED"
	else
		priorityType = "ROUTE_PRIORITY_TYPE_NORMAL"
	end

	TppCommandPostObject.GsSetPriorityEnemyForRoute( cpID, routeSetName, routeName, nodeNum, enemyID, priorityType )
end

-- Enable an enemy's route
this.EnableRoute = function( cpID, routeName, options )
	TppCommon.DeprecatedFunction( "TppCommandPostObject.GsDeleteDisabledRoutes( cpID, routeName, noForceUpdate )" )
	Fox.Log( "TppEnemy : [EnableRoute] function called!" )
	options = options or {}
	local noForceUpdate = options.noForceUpdate or false

	TppCommandPostObject.GsDeleteDisabledRoutes( cpID, routeName, noForceUpdate )
end

-- Disable an enemy's route
this.DisableRoute = function( cpID, routeName, options )
	TppCommon.DeprecatedFunction( "TppCommandPostObject.GsAddDisabledRoutes( cpID, routeName, noForceUpdate )" )
	Fox.Log( "TppEnemy : [DisableRoute] function called!" )
	options = options or {}
	local noForceUpdate = options.noForceUpdate or false

	TppCommandPostObject.GsAddDisabledRoutes( cpID, routeName, noForceUpdate )
end

------------------------------------------
-- Route Set
------------------------------------------

-- Change current route set immediately
this.ChangeRouteSet = function( cpID, routeSetName, options )
	Fox.Log( "TppEnemy : [ChangeRouteSet] function called!" )
	options = options or {}
	local forceUpdate = options.forceUpdate or false
	local forceReload = options.forceReload or false
	local startAtZero = options.startAtZero or false
	local warpEnemy = options.warpEnemy or false

	-- Need to reset phase in order for enemy warping to work
	if( warpEnemy == true ) then
		TppCharacterUtility.ResetPhase()
	end

	TppCommandPostObject.GsSetCurrentRouteSet( cpID, routeSetName, forceUpdate, forceReload, startAtZero, warpEnemy )
end

-- Set routeSets
this.SetRouteSets = function( routeSets, options )
	Fox.Log( "TppEnemy : [SetRouteSets] function called!" )	
	for i = 1, #routeSets do
		local cpID = routeSets[i].cpID
		local holdTime = routeSets[i].holdTime
		local sets = routeSets[i].sets
		for routeSetType, routeSetName in pairs( sets ) do
			TppEnemy.RegisterRouteSet( cpID, routeSetType, routeSetName )
		end
		TppEnemy.RegisterHoldTime( cpID, holdTime )
		TppEnemy.SetStartingRouteSet( cpID, options )
	end
end

-- Register holdTime
this.RegisterHoldTime = function( cpID, holdTime )
	Fox.Log( "TppEnemy : [RegisterHoldTime] function called!" )
	this.m_holdTimes[cpID] = holdTime
end

-- Change current route set gradually
this.ShiftRouteSet = function( cpID, routeSets, holdTime, options )
	Fox.Log( "TppEnemy : [ShiftRouteSet] function called!" )
	options = options or {}
	local doReverseShift = options.doReverseShift or false

	if( routeSets.routeSetStartToHold ~= nil ) then
		TppCommandPostObject.GsAddRouteSetConnection( cpID, routeSets.routeSetStart, routeSets.routeSetHold, routeSets.routeSetStartToHold )
	end
	if( routeSets.routeSetHoldToEnd ~= nil ) then
		TppCommandPostObject.GsAddRouteSetConnection( cpID, routeSets.routeSetHold, routeSets.routeSetEnd, routeSets.routeSetHoldToEnd )
	end
	TppCommandPostObject.GsSetRouteSetShift( cpID, routeSets.routeSetEnd, routeSets.routeSetHold, not doReverseShift, holdTime )
end

------------------------------------------
-- Guard Target
------------------------------------------

-- Enable guard target
this.EnableGuardTarget = function( cpID, guardTarget )
	TppCommon.DeprecatedFunction( "TppCommandPostObject.GsSetGuardTargetValidity( cpID, guardTarget, true )" )
	Fox.Log( "TppEnemy : [EnableGuardTarget] function called!" )
	TppCommandPostObject.GsSetGuardTargetValidity( cpID, guardTarget, true )
end

-- Disable guard target
this.DisableGuardTarget = function( cpID, guardTarget )
	TppCommon.DeprecatedFunction( "TppCommandPostObject.GsSetGuardTargetValidity( cpID, guardTarget, false )" )
	Fox.Log( "TppEnemy : [DisableGuardTarget] function called!" )
	TppCommandPostObject.GsSetGuardTargetValidity( cpID, guardTarget, false )
end

------------------------------------------
-- Combat Locator
------------------------------------------

-- Enable combat locator
this.EnableCombatLocator = function( cpID, combatLocator )
	TppCommon.DeprecatedFunction( "TppCommandPostObject.GsSetCombatLocatorValidity( cpID, combatLocator, true )" )
	Fox.Log( "TppEnemy : [EnableCombatLocator] function called!" )
	TppCommandPostObject.GsSetCombatLocatorValidity( cpID, combatLocator, true )
end

-- Disable combat locator
this.DisableCombatLocator = function( cpID, combatLocator )
	TppCommon.DeprecatedFunction( "TppCommandPostObject.GsSetCombatLocatorValidity( cpID, combatLocator, false )" )
	Fox.Log( "TppEnemy : [DisableCombatLocator] function called!" )
	TppCommandPostObject.GsSetCombatLocatorValidity( cpID, combatLocator, false )
end

---------------------------------------------------------------------------------
-- Internal Functions
---------------------------------------------------------------------------------

-- Turn on all enemies' reactions
this.EnableEnemyReaction = function()
	TppCommon.DeprecatedFunction( "TppEnemyUtility.SetNoReactionModeForCutScene( false )" )
	Fox.Log( "TppEnemy : [EnableEnemyReaction] function called!" )
	TppEnemyUtility.SetNoReactionModeForCutScene( false )
end

-- Turn off all enemies' reactions
this.DisableEnemyReaction = function()
	TppCommon.DeprecatedFunction( "TppEnemyUtility.SetNoReactionModeForCutScene( true )" )
	Fox.Log( "TppEnemy : [DisableEnemyReaction] function called!" )
	TppEnemyUtility.SetNoReactionModeForCutScene( true )
end

-- Enable enemies from demo
this.EnableDemoEnemies = function( demoName )
	TppCommon.DeprecatedFunction( "TppEnemyUtility.SetForcedUnrealizeOutOfCutScene( false )" )
	TppEnemyUtility.SetForcedUnrealizeOutOfCutScene( false )
end

-- Disable enemies from demo
this.DisableDemoEnemies = function( demoName )
	TppCommon.DeprecatedFunction( "TppEnemyUtility.SetForcedUnrealizeOutOfCutScene( true, demoName )" )
	TppEnemyUtility.SetForcedUnrealizeOutOfCutScene( true, demoName )
end

-- Enable security camera
this.EnableSecurityCamera = function()
	TppCommon.DeprecatedFunction( "TppEnemyUtility.StopSecurityCamera( false )" )
	TppEnemyUtility.StopSecurityCamera( false )
end

-- Disable security camera
this.DisableSecurityCamera = function()
	TppCommon.DeprecatedFunction( "TppEnemyUtility.StopSecurityCamera( true )" )
	TppEnemyUtility.StopSecurityCamera( true )
end

-- Register routeSet
this.RegisterRouteSet = function( cpID, routeSetType, routeSetName )
	Fox.Log( "TppEnemy : [RegisterRouteSet] function called!" )
	if( this._IsRouteSetTypeValid( routeSetType ) == false ) then return end
	if( this.m_routeSets[cpID] == nil ) then
		this.m_routeSets[cpID] = {}
	end
	this.m_routeSets[cpID][routeSetType] = routeSetName
end

-- Set a command post's starting routeSet
this.SetStartingRouteSet = function( cpID, options )
	Fox.Log( "TppEnemy : [SetStartingRouteSet] function called!" )
	if( this._IsCharacterIDValid( cpID ) == false ) then return end
	local phase = this.GetPhase( cpID )
	local timeOfDay = TppClock.GetTimeOfDay()
	local routeSetType = phase .. "_" .. timeOfDay

	-- nil check
	if( this.m_routeSets == nil or
		this.m_routeSets[cpID] == nil or
		this.m_routeSets[cpID][routeSetType] == nil ) then return end

	this.ChangeRouteSet( cpID, this.m_routeSets[cpID][routeSetType], options )
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

-- Check if characterID is valid (existing)
this._IsCharacterIDValid = function( characterID )
	local character = Ch.FindCharacterObjectByCharacterId( characterID )
	if( character == nil ) then
		return false
	else
		return true
	end
end

-- Check if phaseName is valid
this._IsPhaseNameValid = function( phaseName )
	if( phaseName == nil or type( phaseName ) ~= "string" ) then
		Fox.Error( "Cannot execute! phaseName is invalid!" )
		return false
	end

	for k, v in pairs( this.PhaseNames ) do
		if( phaseName == k ) then
			return true
		end
	end

	Fox.Error( "Cannot execute! [" .. phaseName .. "] is not a valid phaseName!" )
	return false
end

-- Check if routeSetType is valid
this._IsRouteSetTypeValid = function( routeSetType )
	if( routeSetType == nil or type( routeSetType ) ~= "string" ) then
		Fox.Error( "Cannot execute! routeSetType is invalid!" )
		return false
	end

	for i = 1, #this.RouteSetTypes do
		if( routeSetType == this.RouteSetTypes[i] ) then
			return true
		end
	end

	Fox.Error( "Cannot execute! [" .. routeSetType .. "] is not a valid routeSetType!" )
	return false
end

-- Change route set depending on phase
this._ChangeRouteSetOnPhase = function( phase )
	local cpID = TppEventSequenceManagerCollector.GetMessageArg( 0 )
	if( this._IsCharacterIDValid( cpID ) == false ) then return end
	if( this.m_routeSets[cpID] == nil ) then return end

	local timeOfDay = TppClock.GetTimeOfDay()
	local routeSetType = phase .. "_" .. timeOfDay
	this.ChangeRouteSet( cpID, this.m_routeSets[cpID][routeSetType] )
end

-- Change route set depending on time
this._ChangeRouteSetOnTime = function( time )
	for cpID, routeSets in pairs( this.m_routeSets ) do
		if( this._IsCharacterIDValid( cpID ) == true ) then
			local sets = {}

			local phase = this.GetPhase( cpID )
			if( phase == "sneak" or phase == "caution" ) then
				local dayRoute = phase .. "_day"
				local nightRoute = phase .. "_night"

				if( time == "day" ) then
					sets.routeSetStart = routeSets[nightRoute]
					sets.routeSetEnd = routeSets[dayRoute]
				elseif( time == "night" ) then
					sets.routeSetStart = routeSets[dayRoute]
					sets.routeSetEnd = routeSets[nightRoute]
				end
				sets.routeSetHold = routeSets.hold
				local holdTime = this.m_holdTimes[cpID]

				this.ShiftRouteSet( cpID, sets, holdTime )
			end
		end
	end
end

---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------
this.m_routeSets = {}
this.m_holdTimes = {}

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this
