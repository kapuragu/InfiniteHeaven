local this = {}

---------------------------------------------------------------------------------
-- Lists
---------------------------------------------------------------------------------
this.StartStatusList = {
	rideHeli_sit		= "ACTION_STATUS_RIDE_HELI",
	rideHeli_standLeft	= "ACTION_STATUS_RIDE_HELI_LEFT",
	rideHeli_standRight	= "ACTION_STATUS_RIDE_HELI_RIGHT",
}

this.DisableAbilityList = {
	Stand	= "DIS_ACT_STAND",
	Squat	= "DIS_ACT_SQUAT",
	Crawl	= "DIS_ACT_CRAWL",
	Dash	= "DIS_ACT_DASH",
}

this.ControlModeList = {
	LockPadMode					= "All",
	LockMBTerminalOpenCloseMode	= "MB_Disable",
	MBTerminalOnlyMode			= "MB_OnlyMode",
}

this.StockDirectionRight = 0
this.StockDirectionLeft = 1

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Get the player object
this.GetPlayer = function()
	TppCommon.DeprecatedFunction( "TppPlayerUtility.GetLocalPlayerCharacter()" )
	return TppPlayerUtility.GetLocalPlayerCharacter()
end

-- Set player start point
this.SetStartStatus = function( startStatus )
	TppCommon.DeprecatedFunction( "TppPlayerUtility.SetActionStatusOnStartMission( startStatus )" )
	if( this._IsStartStatusValid( startStatus ) == false ) then return end
	TppPlayerUtility.SetActionStatusOnStartMission( this.StartStatusList[startStatus] )
end

-- Set player event state
this.SetEventStatus = function( eventStatus )
	PlayerManager:SetEventState( eventStatus )
end

-- Get the player's position
this.GetPosition = function()
	TppCommon.DeprecatedFunction( "player:GetPosition()" )
	local player = this.GetPlayer()
	return player:GetPosition()
end

-- Set the player's position
this.SetPosition = function( position )
	TppCommon.DeprecatedFunction( "player:SetPosition( position )" )
	local player = this.GetPlayer()
	player:SetPosition( position )
end

-- Get the player's rotation
this.GetRotation = function()
	TppCommon.DeprecatedFunction( "player:GetRotation()" )
	local player = this.GetPlayer()
	return player:GetRotation()
end

-- Set the player's rotation
this.SetRotation = function( rotation )
	TppCommon.DeprecatedFunction( "player:SetRotation( rotation )" )
	local player = this.GetPlayer()
	player:SetRotation( rotation )
end

-- Warp player to warp locator
this.Warp = function( warpLocator )
	local pos = TppData.GetPosition( warpLocator )
	local rot = TppData.GetRotation( warpLocator )
	this.SetPosition( pos )
	this.SetRotation( rot )
	TppPlayerUtility.SetCameraToPlayerDirection()
end

-- Set form variation
this.SetFormVariation = function( fovaKey )
	return TppCharacterUtility.ChangeFormVariationWithCharacterId( "player", fovaKey, 0 )
end

-- Enable ability of the player
this.EnableAbility = function( abilityName )
	TppCommon.DeprecatedFunction( "TppPlayerUtility.ResetDisableActionsWithName( name )" )
	--if( this._IsAbilityNameValid( abilityName ) == false ) then return end
	local disabledName = "DisabledPlayer_" .. abilityName
	TppPlayerUtility.ResetDisableActionsWithName( disabledName )
end

-- Disable ability of the player
this.DisableAbility = function( abilityName )
	TppCommon.DeprecatedFunction( "TppPlayerUtility.SetDisableActionsWithName{ name = name, disableActions = { abilityName } }" )
	--if( this._IsAbilityNameValid( abilityName ) == false ) then return end
	local disabledName = "DisabledPlayer_" .. abilityName
	TppPlayerUtility.SetDisableActionsWithName{ name = disabledName, disableActions = { this.DisableAbilityList[abilityName] } }
end

-- Enable control mode
this.EnableControlMode = function( controlMode )
	TppCommon.DeprecatedFunction( "TppPadOperatorUtility.SetMasksForPlayer( 0, controlMode )" )
	if( this._IsControlModeValid( controlMode ) == false ) then return end
	TppPadOperatorUtility.SetMasksForPlayer( 0, this.ControlModeList[controlMode] )
end

-- Disable control mode
this.DisableControlMode = function( controlMode )
	TppCommon.DeprecatedFunction( "TppPadOperatorUtility.ResetMasksForPlayer( 0, controlMode )" )
	if( this._IsControlModeValid( controlMode ) == false ) then return end
	TppPadOperatorUtility.ResetMasksForPlayer( 0, this.ControlModeList[controlMode] )
end

-- Set player's weapons
this.SetWeapons = function( weapons )
	TppCommon.DeprecatedFunction( "TppPlayerUtility.SetWeaponIdsOnStartMission( weapons )" )
	if( type( weapons ) ~= "table" ) then
		Fox.Error( "Cannot execute! [weapons] parameter is not a table!" )
		return
	end

	TppPlayerUtility.SetWeaponIdsOnStartMission( weapons )
end

-- Add a weapon to a player's weapons
this.AddWeapons = function( weapons )
	if( type( weapons ) ~= "table" ) then
		Fox.Error( "Cannot execute! [weapons] parameter is not a table!" )
		return
	end

	for i = 1, #weapons do
		local weaponID = weapons[i]
		TppPlayerUtility.AddWeaponIdOnStartMissionLua( weaponID )
	end
end

-- Set default facial motion
this.SetDefaultFacialMotion = function( facialMotionName )
	TppPlayerUtility.SetDefaultFacialMotion( facialMotionName )
end

-- メニューからシーケンス開始したときにだけワープさせる
this.WarpForDebugStartInVipRestorePoint = function( manager, characterID, warpLocatorKey )
	if manager:IsStartingFromResearvedForDebug() then
		TppCharacterUtility.WarpCharacterIdFromIdentifier( characterID, "id_vipRestorePoint", warpLocatorKey )
	end
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

this._IsStartStatusValid = function( startStatus )
	if( this.StartStatusList[startStatus] == nil ) then
		Fox.Error( "Cannot execute! [" .. tostring( startStatus ) .. "] is not a valid start status!" )
		return false
	end
	return true
end

this._IsAbilityNameValid = function( abilityName )
	if( this.DisableAbilityList[abilityName] == nil ) then
		Fox.Error( "Cannot execute! [" .. tostring( abilityName ) .. "] is not a valid ability name!" )
		return false
	end
	return true
end

this._IsControlModeValid = function( controlMode )
	if( this.ControlModeList[controlMode] == nil ) then
		Fox.Error( "Cannot execute! [" .. tostring( controlMode ) .. "] is not a valid control mode!" )
		return false
	end
	return true
end

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this