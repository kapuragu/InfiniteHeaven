local this = {}

---------------------------------------------------------------------------------
-- Messages
---------------------------------------------------------------------------------
this.Messages = {
	Mission = {
		{ message = "CrossOfInnerArea", localFunc = "_execInnerCrossing" },
		{ message = "CrossOfOuterArea", localFunc = "_execOuterCrossing" },
	},
	Timer = {
		{ data = "_whileInsideBaseTimer", message = "OnEnd", localFunc = "OnEnterClearAreaTrap" },
		{ data = "_whileOutsideBaseTimer", message = "OnEnd", localFunc = "_onEndEndingSequence" },
	},
}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Setup
this.Setup = function()
	-- common scripts
	TppEnemy.Setup()
	TppMarker.Setup()
	TppTerminal.Setup()
	TppTimer.Setup()

	-- reset endingSequenceParams
	this.m_endingSequenceParams = nil

	-- reset doOnInnerCrossing/doOnOuterCrossing
	this.m_doOnInnerCrossing = nil
	this.m_doOnOuterCrossing = nil
end

-- Get current mission ID
this.GetMissionID = function()
	return this.m_missionID
end

-- Get current mission name
this.GetMissionName = function()
	return this.m_missionName
end

-- Change mission state
this.ChangeState = function( state, stateMessage, flags )
	TppSequence.ChangeMissionState( this.m_manager, state, stateMessage, flags )
end

-- Set mission flag
this.SetFlag = function( flagID, value )
	TppCommon.DeprecatedFunction( "MissionManager.SetFlag( flagID, value )" )
	this.m_manager.SetFlag( flagID, value )
end

-- Get mission flag
this.GetFlag = function( flagID )
	TppCommon.DeprecatedFunction( "MissionManager.GetFlag( flagID )" )
	return this.m_manager.GetFlag( flagID )
end

-- Register vip restore point
this.RegisterVipRestorePoint = function( characterId, keyName )
	-- @todo 名前きめうちするのか、emsに持たせるのか、要検討 y.ogaito
	MissionManager.RegisterVipRestorePoint( characterId, "id_vipRestorePoint", keyName )
end

-- Unregister vip restore point
this.UnregisterVipRestorePoint = function( characterId )
	-- @todo 名前きめうちするのか、emsに持たせるのか、要検討 y.ogaito
	MissionManager.UnregisterVipRestorePoint( characterId )
end

-- Enable accept mission while in a mission
this.EnableAcceptMission = function()
	TppCommon.DeprecatedFunction( "MissionManager.SetEnableAcceptOnNormalMission()" )
	this.m_manager.SetEnableAcceptOnNormalMission()
end

-- Load demo block
this.LoadDemoBlock = function( path )
	TppCommon.DeprecatedFunction( "MissionManager.RequestLoadBlockAndWaitState()" )
	this.m_manager.RequestLoadDemoBlockLua( path )
end

-- Check to see if demo block is active
this.IsDemoBlockActive = function()
	TppCommon.DeprecatedFunction( "MissionManager.IsDemoBlockActive()" )
	return this.m_manager.IsDemoBlockActiveLua()
end

-- Load event block
this.LoadEventBlock = function( path )
	TppCommon.DeprecatedFunction( "MissionManager.RequestLoadBlockAndWaitState()" )
	this.m_manager.RequestLoadEventBlockLua( path )
end

-- Check to see if event block is active
this.IsEventBlockActive = function()
	TppCommon.DeprecatedFunction( "MissionManager.IsEventBlockActive()" )
	return this.m_manager.IsEventBlockActiveLua()
end

-- Set InGame or NotInGame because of demo, loading or setup phase
this.SetInGame = function( inGame )
	--TppGameSequence.SetWorldActive(inGame)
	--TppGameSequence.SetInGame(inGame)
end

-- Register function when crossing inner area
this.OnLeaveInnerArea = function( doFunc )
	if( type( doFunc ) ~= "function" ) then
		Fox.Error( "Cannot execute! [OnLeaveInnerArea] parameter needs to be a function!" )
		return
	end
	this.m_doOnInnerCrossing = doFunc
end

-- Register function when crossing outer area
this.OnLeaveOuterArea = function( doFunc )
	if( type( doFunc ) ~= "function" ) then
		Fox.Error( "Cannot execute! [OnLeaveOuterArea] parameter needs to be a function!" )
		return
	end
	this.m_doOnOuterCrossing = doFunc
end

-- Start ending sequence for mission
this.StartEndingSequence = function( params )
	this.m_endingSequenceParams = params or {}

	if( TppLocation.GetFlag( "_isPlayerInClearAreaTrap" ) == true ) then
		if( this.m_endingSequenceParams.onInsideBase ~= nil ) then
			this.m_endingSequenceParams.onInsideBase()
		end
		local insideTime = this.m_endingSequenceParams.insideTime or 1
		GkEventTimerManager.Start( "_whileInsideBaseTimer", insideTime )
	else
		local phase = TppEnemy.GetPhase()
		if( phase == "neutral" or phase == "sneak" ) then
			if( this.m_endingSequenceParams.onOutsideBase_Sneak ~= nil ) then
				this.m_endingSequenceParams.onOutsideBase_Sneak()
			end
		else
			if( this.m_endingSequenceParams.onOutsideBase_Alert ~= nil ) then
				this.m_endingSequenceParams.onOutsideBase_Alert()
			end
		end
		local outsideTime = this.m_endingSequenceParams.outsideTime or 1
		GkEventTimerManager.Start( "_whileOutsideBaseTimer", outsideTime )
	end
end

---------------------------------------------------------------------------------
-- Internal Functions
---------------------------------------------------------------------------------

-- Register mission flag list
this.Register = function( missionID, missionFlagList )
	this.m_missionID = missionID
	this.m_missionName = this._CreateMissionName( missionID )
	this.m_flagList = missionFlagList
end

-- On start
this.Start = function()
	this.m_manager = MissionManager

	-- Register MissionFlags
	local seqManager = TppSequence.GetManager( "mission" )
	this.m_manager.RegisterFlags( this.m_flagList, seqManager )
end

-- Get current mission state
this.GetCurrentState = function()
	TppCommon.DeprecatedFunction( "MissionManager.GetMissionState()" )
	return this.m_manager.GetMissionState()
end

-- When entering a clear area trap
this.OnEnterClearAreaTrap = function()
	GkEventTimerManager.Stop( "_whileOutsideBaseTimer" )
	if( this.m_endingSequenceParams == nil ) then return end

	if( this.m_endingSequenceParams.onEnterBase ~= nil ) then
		this.m_endingSequenceParams.onEnterBase()

		local insideTime = this.m_endingSequenceParams.insideTime or 1
		GkEventTimerManager.Start( "_whileInsideBaseTimer", insideTime )
	end
end

-- When exiting a clear area trap
this.OnExitClearAreaTrap = function()
	GkEventTimerManager.Stop( "_whileInsideBaseTimer" )
	if( this.m_endingSequenceParams == nil ) then return end

	local phase = TppEnemy.GetPhase()
	if( phase == "neutral" or phase == "sneak" ) then
		if( this.m_endingSequenceParams.onExitBase_Sneak ~= nil ) then
			this.m_endingSequenceParams.onExitBase_Sneak()
		end
	else
		if( this.m_endingSequenceParams.onExitBase_Alert ~= nil ) then
			this.m_endingSequenceParams.onExitBase_Alert()
		end
	end

	local outsideTime = this.m_endingSequenceParams.outsideTime or 1
	GkEventTimerManager.Start( "_whileOutsideBaseTimer", outsideTime )
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

-- Create mission name from mission ID
this._CreateMissionName = function( missionID )
	local missionTypeNum = string.sub( tostring( missionID ), 1, 1 )
	local missionType

	if( missionTypeNum == "1" ) then
		missionType = "s"
	elseif( missionTypeNum == "2" ) then
		missionType = "e"
	elseif( missionTypeNum == "3" ) then
		missionType = "f"
	elseif( missionTypeNum == "4" ) then
		missionType = "h"
	else
		Fox.Error( "Cannot execute! [" .. tostring( missionID ) .. "] is an invalid missionID!" )
		return nil
	end

	return missionType .. missionID
end

-- Execute function when crossing inner area
this._execInnerCrossing = function()
	if( this.m_doOnInnerCrossing ~= nil ) then
		this.m_doOnInnerCrossing()
	end
end

-- Execute function when crossing outer area
this._execOuterCrossing = function()
	if( this.m_doOnOuterCrossing ~= nil ) then
		this.m_doOnOuterCrossing()
	end
end

-- End ending sequence
this._onEndEndingSequence = function()
	if( this.m_endingSequenceParams == nil ) then return end

	if( this.m_endingSequenceParams.onEnd ~= nil ) then
		this.m_endingSequenceParams.onEnd()
	end
end

---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------
this.m_manager = nil
this.m_missionID = nil
this.m_missionName = nil
this.m_flagList = nil
this.m_doOnInnerCrossing = nil
this.m_doOnOuterCrossing = nil
this.m_endingSequenceParams = nil

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this