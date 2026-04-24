local this = {}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Get current sequence name
this.GetCurrentSequence = function( esmType )
	TppCommon.DeprecatedFunction( "manager:GetCurrentSequence()" )
	esmType = esmType or "mission"
	return this.GetManager( esmType ):GetCurrentSequence()
end

-- Leave current sequence and change to a different sequence
this.ChangeSequence = function( seqName, esmType )
	TppCommon.DeprecatedFunction( "manager:GoNextSequence( seqName )" )
	esmType = esmType or "mission"
	if( this._IsSequenceValid( seqName, esmType ) == false ) then return end
	this.GetManager( esmType ):GoNextSequence( seqName )
end

-- Check if a sequence is greater than another
this.IsGreaterThan = function( seq1, seq2, esmType )
	TppCommon.DeprecatedFunction( "manager:IsLargerThan( seq1, seq2 )" )
	esmType = esmType or "mission"
	return this.GetManager( esmType ):IsLargerThan( seq1, seq2 )
end

-- Check current sequence is A to B
this.IsCurrentSequenceAtoB = function( seq1, seq2, esmType )

	local currentSeq = this.GetCurrentSequence(esmType)

	if ( this.IsGreaterThan( currentSeq, seq1 ) and this.IsGreaterThan( seq2, currentSeq ) ) then
		return true
	else
		return false
	end
end

---------------------------------------------------------------------------------
-- Internal Functions
---------------------------------------------------------------------------------

-- Register manager list
this.Register = function( script, manager, esmType )
	esmType = esmType or "mission"

	-- Overwrite type (if existing)
	for i = 1, #this.esmData do
		if( esmType == this.esmData[i].esmType ) then
			this.esmData[i].manager = manager
			this.esmData[i].script = script
			return
		end
	end

	local temp = {}
	temp.script = script
	temp.manager = manager
	temp.esmType = esmType

	table.insert( this.esmData, temp )
end

-- Get an entity linked data body
this.GetData = function( keyName, esmType )
	esmType = esmType or "mission"

	local data = this.GetManager( esmType ):GetDataBodyFromEntityLink( keyName )
	if( data == nil or data == Entity.Null() ) then
		Fox.Error( "Cannot execute! [" .. tostring( keyName ) .. "] does not exist!" )
		return nil
	end
	return data
end

-- Get the correct manager
this.GetManager = function( esmType )
	if( this._IsTypeValid( esmType ) == false ) then return nil end
	for i = 1, #this.esmData do
		if( esmType == this.esmData[i].esmType ) then
			return this.esmData[i].manager
		end
	end
	Fox.Error( "Cannot execute! Manager does not exist with type [" .. tostring( esmType ) .. "]!" )
	return nil
end

-- Change mission state
this.ChangeMissionState = function( missionManager, state, stateMessage, flags )
	local seqManager = this.GetManager( "mission" )
	local currentState = MissionManager.GetMissionState()
	if stateMessage == nil then
		stateMessage = ""
	end

	local request = false

	-- Go to "ST_EXEC"
	if( state == "exec" ) then
		seqManager:ExitMissionStatePrepareRestore()
		seqManager:WaitMissionStateToExec()

	-- Go to "ST_CLEAR"
	elseif( state == "clear" ) then
		if( currentState == "ST_PREPARE" ) then
			seqManager:ExitMissionStatePrepareRestore()
		elseif( currentState == "ST_EXEC" ) then
			request = missionManager.RequestMissionClear(stateMessage)
		end
		seqManager:WaitMissionStateToClear()

	-- Go to "ST_FAILED"
	elseif( state == "failed" ) then
		if( currentState == "ST_PREPARE" ) then
			seqManager:ExitMissionStatePrepareRestore()
		elseif( currentState == "ST_EXEC" ) then
			request = missionManager.RequestMissionFailure(stateMessage)
		end
		seqManager:WaitMissionStateToFailed()

	-- Go to "ST_ABORT"
	elseif( state == "abort" ) then
		if( currentState == "ST_PREPARE" ) then
			seqManager:ExitMissionStatePrepareRestore()
		elseif( currentState == "ST_EXEC" ) then
			request = missionManager.RequestMissionAbort(stateMessage)
		end
		seqManager:WaitMissionStateToAbort()

	-- Go to "ST_GAMEOVER"
	elseif( state == "gameOver" ) then
		if( currentState == "ST_PREPARE" ) then
			seqManager:ExitMissionStatePrepareRestore()
		elseif( currentState == "ST_EXEC" ) then
			request = missionManager.RequestMissionFailure(stateMessage)
		elseif( currentState == "ST_FAILED" ) then
			seqManager:ExitMissionStateFailed()
		end
		seqManager:WaitMissionStateToGameOver()

	-- finish mission by unloading
	elseif( state == "end" ) then
		if( currentState == "ST_CLEAR" ) then
			seqManager:ExitMissionStateClear()
		elseif( currentState == "ST_FAILED" ) then
			seqManager:ExitMissionStateFailed()
		elseif( currentState == "ST_ABORT" ) then
			seqManager:ExitMissionStateAbort()
		elseif( currentState == "ST_GAMEOVER" ) then
			seqManager:ExitMissionStateGameOver()
		end

	else
		Fox.Error( "Cannot execute! [" .. tostring( state ) .. "] is not a valid mission state!" )
	end

	if (request == true) then
		local checkFlags = flags or {}
		-- Disable Game
		local disableGame = checkFlags.disableGame == nil and true or checkFlags.disableGame
		if( disableGame ) then
			TppGameStatus.Set("MissionManager","S_DISABLE_TARGET")
			TppGameStatus.Set("MissionManager","S_DISABLE_TRAP")
			TppGameStatus.Set("MissionManager","S_DISABLE_PLAYER_PAD")
			TppGameStatus.Set("MissionManager","S_DISABLE_TERMINAL")
			TppGameStatus.Set("MissionManager","S_DISABLE_HUD")
			TppGameStatus.Set("MissionManager","S_DISABLE_SYSTEM_UI_PAD")
		end
		-- Disable Target
		local disableTarget = checkFlags.disableTarget == nil and true or checkFlags.disableTarget
		if( disableTarget ) then
			TppGameStatus.Set("MissionManager","S_DISABLE_TARGET")
		end
		-- Disable Trap
		local disableTrap = checkFlags.disableTrap == nil and true or checkFlags.disableTrap
		if( disableTrap ) then
			TppGameStatus.Set("MissionManager","S_DISABLE_TRAP")
		end
		-- Disable PlayerPad
		local disablePlayerPad = checkFlags.disablePlayerPad == nil and true or checkFlags.disablePlayerPad
		if( disablePlayerPad ) then
			TppGameStatus.Set("MissionManager","S_DISABLE_PLAYER_PAD")
		end
		-- Disable Terminal
		local disableTerminal = checkFlags.disableTerminal == nil and true or checkFlags.disableTerminal
		if( disableTerminal ) then
			TppGameStatus.Set("MissionManager","S_DISABLE_TERMINAL")
		end
		-- Disable HUD
		local disableHUD = checkFlags.disableHUD == nil and true or checkFlags.disableHUD
		if( disableHUD ) then
			TppGameStatus.Set("MissionManager","S_DISABLE_HUD")
		end
		-- Disable SystemUIPad
		local disableSystemUIPad = checkFlags.disableSystemUIPad == nil and true or checkFlags.disableSystemUIPad
		if( disableSystemUIPad ) then
			TppGameStatus.Set("MissionManager","S_DISABLE_SYSTEM_UI_PAD")
		end
	end
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

-- Check if type is valid
this._IsTypeValid = function( esmType )
	local esmTypes = {
		"location",
		"mission",
	}
	for i = 1, #esmTypes do
		if( esmType == esmTypes[i] ) then
			return true
		end
	end
	Fox.Error( "Cannot execute! Type [" .. tostring( esmType ) .. "] is incorrect!" )
	return false
end

-- Check if sequence is valid
this._IsSequenceValid = function( seqName, esmType )
	local script = this._GetScript( esmType )
	if( script == nil ) then return end

	-- Check if registered in "Sequences" table
	local function IsInSequences( name )
		for i = 1, #script.Sequences do
			if( name == script.Sequences[i][1] ) then
				return true
			end
		end
		return false
	end

	-- Check if table actually exists
	local function IsExist( name )
		local path = nil
		for i = 1, #script.Sequences do
			if( name == script.Sequences[i][1] ) then
				path = script.Sequences[i][2]
			end
		end

		if( path == nil ) then
			if( script[name] == nil ) then
				return false
			end
			return true
		else
			-- Can't really check if the sequences is in another file,
			-- so just return true and let the system handle it
			return true
		end
	end

	if( IsInSequences( seqName ) == false ) then
		Fox.Error( "Cannot exectue! Sequence [" .. tostring( seqName ) .. "] does not exist in \"Sequences\"!" )
		return false
	end

	if( IsExist( seqName ) == false ) then
		Fox.Error( "Cannot execute! Sequence [" .. tostring( seqName ) .. "] does not exist in script!" )
		return false
	end

	return true
end

-- Get the correct script
this._GetScript = function( esmType )
	if( this._IsTypeValid( esmType ) == false ) then return nil end

	for i = 1, #this.esmData do
		if( esmType == this.esmData[i].esmType ) then
			return this.esmData[i].script
		end
	end
	Fox.Error( "Cannot execute! Script does not exist with type [" .. tostring( esmType ) .. "]!" )
	return nil
end

---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------
this.esmData = {}

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this
