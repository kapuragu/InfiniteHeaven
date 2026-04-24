local this = {}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Call helicopter to RV point
this.Call = function( rvPointName )
	TppCommon.DeprecatedFunction( "TppSupportHelicopterService.CallSupportHelicopter( rvPointName )" )
	TppSupportHelicopterService.CallSupportHelicopter( rvPointName )
end

-- Change helicopter RV point
this.ChangeRVPoint = function( rvPointName )
	TppCommon.DeprecatedFunction( "TppSupportHelicopterService.RequestToChangeRendezvousPoint( rvPointName )" )
	TppSupportHelicopterService.RequestToChangeRendezvousPoint( rvPointName )
end

-- Enable auto return
this.EnableAutoReturn = function()
	TppCommon.DeprecatedFunction( "TppSupportHelicopterService.EnableAutoReturn()" )
	TppSupportHelicopterService.EnableAutoReturn()
end

-- Disable auto return
this.DisableAutoReturn = function()
	TppCommon.DeprecatedFunction( "TppSupportHelicopterService.DisableAutoReturn()" )
	TppSupportHelicopterService.DisableAutoReturn()
end

-- Set helicopter route
this.SetRoute = function( routeID, speed, options )
	options = options or {}

	local doWarp = options.doWarp or false
	local useNode = options.useNode or 0
	TppSupportHelicopterService.RequestRouteModeWithNodeIndex( routeID, useNode, doWarp, speed )
	TppSupportHelicopterService.ChangeTargetSpeed( speed, 0 )
end

-- Change helicopter route
this.ChangeRoute = function( routeID )
	TppCommon.DeprecatedFunction( "TppSupportHelicopterService.ChangeRoute( routeID )" )
	TppSupportHelicopterService.ChangeRoute( routeID )
end

-- Set helicopter status
this.SetStatus = function( statusName )
	if( statusName == "leftDoor_open" ) then
		TppCommon.DeprecatedFunction( "TppSupportHelicopterService.OpenLeftDoor()" )
		TppSupportHelicopterService.OpenLeftDoor()
	elseif( statusName == "leftDoor_close" ) then
		TppCommon.DeprecatedFunction( "TppSupportHelicopterService.CloseLeftDoor()" )
		TppSupportHelicopterService.CloseLeftDoor()
	elseif( statusName == "rightDoor_open" ) then
		TppCommon.DeprecatedFunction( "TppSupportHelicopterService.OpenRightDoor()" )
		TppSupportHelicopterService.OpenRightDoor()
	elseif( statusName == "rightDoor_close" ) then
		TppCommon.DeprecatedFunction( "TppSupportHelicopterService.CloseRightDoor()" )
		TppSupportHelicopterService.CloseRightDoor()
	elseif( statusName == "landingGear_up" ) then
		TppCommon.DeprecatedFunction( "TppSupportHelicopterService.TakeInLandingGear()" )
		TppSupportHelicopterService.TakeInLandingGear()
	elseif( statusName == "landingGear_down" ) then
		TppCommon.DeprecatedFunction( "TppSupportHelicopterService.PutDownLandingGear()" )
		TppSupportHelicopterService.PutDownLandingGear()
	else
		Fox.Error( "Cannot execute! [" .. tostring( statusName ) .. "] is not a valid status name!" )
		return
	end
end

---------------------------------------------------------------------------------
-- Internal Functions
---------------------------------------------------------------------------------

-- Enable helicopter
this.EnableHelicopter = function()
	TppCommon.DeprecatedFunction( "TppSupportHelicopterService.ResetStopAndInvisible()" )
	TppSupportHelicopterService.ResetStopAndInvisible()
end

-- Disable helicopter
this.DisableHelicopter = function()
	TppCommon.DeprecatedFunction( "TppSupportHelicopterService.StopAndInvisible()" )
	TppSupportHelicopterService.StopAndInvisible()
end

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this