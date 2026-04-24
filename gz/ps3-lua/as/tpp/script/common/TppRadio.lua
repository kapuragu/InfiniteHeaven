local this = {}

------------------------------------------------------------------------
-- MessageList
------------------------------------------------------------------------
this.Messages = {
	Radio = {
		{ message = "RadioEventMessage", localFunc = "_MessageHandler" },
		{ message = "EspionageRadioPlayButton", localFunc = "_PlayIntelRadio" },
	},
	Timer = {
		{ data = "debugRadioTimer", message = "OnEnd", localFunc = "_PlayDebugContinue" },
	},
}

---------------------------------------------------------------------------------
-- Lists
---------------------------------------------------------------------------------
this.RadioMessageList = {
	None	= 0,
	Start	= 1,
	End		= 2,
	Request	= 3,
}
this.SFXList = {
	RadioStart	= "Play_sfx_s_codec_NPC_begin",
	RadioEnd	= "Play_sfx_s_codec_NPC_end",
}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Play radio
this.Play = function( radioTag, funcs, radioType, preDelayTimeAtSec, noiseType )
	local radioType = radioType or "realtime"
	local noiseType = noiseType or "both"

	local radioIDs, numPlay = this._GetRadioIDsAndNumPlay( radioTag, radioType )
	local radioName = this._GetRadioName( radioIDs )

	if( radioName == nil ) then return end
	if( this._DoPlayRadio( radioName, radioIDs, numPlay, radioType ) == false ) then return end

	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then

		-- 無線の種類に問わず再生中でなければ
		-- 念のためPlayStrongにしていた優先度をデフォに戻す処理
		-- リアルタイム無線の場合
		this.ResetRealTimeRadioSubPriority()
		-- 諜報無線の場合
		this.ResetEpisonageRadioSubPriority()
		-- 任意無線の場合
		this.ResetOptionalRadioSubPriority()
	end

	-- Set functions
	this.m_funcs[radioName] = funcs
	-- Play radio
	this.m_manager:PlayDirectGroupTable{ tableName = radioName, groupName = radioIDs, preDelayTime = preDelayTimeAtSec, noiseType = noiseType }

end

-- Play radio(High Priority)
-- ※なお、無線再生終了時に下記を呼ばないと優先度が元に戻りませんので注意してください
-- リアルタイム無線の場合
-- this.ResetRealTimeRadioSubPriority()
-- 諜報無線の場合
-- this.ResetEpisonageRadioSubPriority()
-- 任意無線の場合
-- this.ResetOptionalRadioSubPriority()
this.PlayStrong = function( radioTag, funcs, radioType, preDelayTimeAtSec, noiseType )
	local radioType = radioType or "realtime"
	local noiseType = noiseType or "both"

	local radioIDs, numPlay = this._GetRadioIDsAndNumPlay( radioTag, radioType )
	local radioName = this._GetRadioName( radioIDs )

	if( radioName == nil ) then return end
	if( this._DoPlayRadio( radioName, radioIDs, numPlay, radioType ) == false ) then return end
	-- Change Priority
	if( radioType == "realtime" ) then
		-- リアルタイム無線
		SubtitlesCommand:SetSubPriority( "Degault", 6, 5, 10 )
	elseif( radioType == "intel" ) then
		-- 諜報無線
		SubtitlesCommand:SetSubPriority( "Degault", 9, 5, 10 )
	else
		-- 任意無線
		SubtitlesCommand:SetSubPriority( "Degault", 25, 5, 10 )
	end

	-- Set functions
	this.m_funcs[radioName] = funcs
	-- Play radio
	this.m_manager:PlayDirectGroupTable{ tableName = radioName, groupName = radioIDs, preDelayTime = preDelayTimeAtSec, noiseType = noiseType }
end

-- Play radio
this.PlayEnqueue = function( radioTag, funcs, radioType, preDelayTimeAtSec, noiseType )
	local radioType = radioType or "realtime"
	local noiseType = noiseType or "both"

	local radioIDs, numPlay = this._GetRadioIDsAndNumPlay( radioTag, radioType )
	local radioName = this._GetRadioName( radioIDs )

	if( radioName == nil ) then return end
	if( this._DoPlayRadio( radioName, radioIDs, numPlay, radioType ) == false ) then return end
	
	-- Set functions
	this.m_funcs[radioName] = funcs

	-- Play radio
	this.m_manager:PlayDirectGroupTableEnqueue{ tableName = radioName, groupName = radioIDs, preDelayTime = preDelayTimeAtSec, noiseType = noiseType }
end

-- DelayPlay radio
this.DelayPlay = function( radioTag, delayTime, noiseType, funcs, radioType )
	local radioType = radioType or "realtime"
	local noiseType = noiseType or "both"

	local radioIDs, numPlay = this._GetRadioIDsAndNumPlay( radioTag, radioType )
	local radioName = this._GetRadioName( radioIDs )

	if( radioName == nil ) then return end
	if( this._DoPlayRadio( radioName, radioIDs, numPlay, radioType ) == false ) then return end

	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then
		-- 無線の種類に問わず再生中でなければ
		-- 念のためPlayStrongにしていた優先度をデフォに戻す処理
		-- リアルタイム無線の場合
		this.ResetRealTimeRadioSubPriority()
		-- 諜報無線の場合
		this.ResetEpisonageRadioSubPriority()
		-- 任意無線の場合
		this.ResetOptionalRadioSubPriority()
	end
	
	-- Set functions
	this.m_funcs[radioName] = funcs

	-- Random
	local preDelayTimeAtSec
	if( type( delayTime ) == "string" ) then
		-- １０倍しているよ！
		local times = {
			short	= { 0.4, 0.8 },
			mid		= { 1.3, 1.9 },
			long	= { 2.6, 3.2 },
		}
		if( times[delayTime] == nil ) then
			Fox.Log( "Be careful! [" .. tostring( delayTime) .. "] does not exist!" )
		end
		local minTime = times[delayTime][1] * 10
		local maxTime = times[delayTime][2] * 10
		preDelayTimeAtSec = ( math.random( minTime, maxTime ) / 10 )
	elseif( type( delayTime ) == "number" ) then
		preDelayTimeAtSec = delayTime
	end

	-- Play radio
	this.m_manager:PlayDirectGroupTable{ tableName = radioName, groupName = radioIDs, preDelayTime = preDelayTimeAtSec, noiseType = noiseType }
end

-- Play radio
this.DelayPlayEnqueue = function( radioTag, delayTime, noiseType, funcs, radioType )
	local radioType = radioType or "realtime"
	local noiseType = noiseType or "both"

	local radioIDs, numPlay = this._GetRadioIDsAndNumPlay( radioTag, radioType )
	local radioName = this._GetRadioName( radioIDs )

	if( radioName == nil ) then return end
	if( this._DoPlayRadio( radioName, radioIDs, numPlay, radioType ) == false ) then return end
	
	-- Set functions
	this.m_funcs[radioName] = funcs

	-- Random
	local preDelayTimeAtSec
	if( type( delayTime ) == "string" ) then
		-- １０倍しているよ！
		local times = {
			short	= { 0.4, 0.8 },
			mid		= { 1.3, 1.9 },
			long	= { 2.6, 3.2 },
		}
		if( times[delayTime] == nil ) then
			Fox.Log( "Be careful! [" .. tostring( delayTime) .. "] does not exist!" )
		end
		local minTime = times[delayTime][1] * 10
		local maxTime = times[delayTime][2] * 10
		preDelayTimeAtSec = ( math.random( minTime, maxTime ) / 10 )
	elseif( type( delayTime ) == "number" ) then
		preDelayTimeAtSec = delayTime
	end

	-- Play radio
	this.m_manager:PlayDirectGroupTableEnqueue{ tableName = radioName, groupName = radioIDs, preDelayTime = preDelayTimeAtSec, noiseType = noiseType }
end

-- Play debug radio
this.PlayDebug = function( radioTag, funcs )
	if( radioTag == nil or this.m_radioList[radioTag] == nil ) then
		Fox.Error( "Cannot execute! [radioTag] is invalid!" )
		return
	end

	this.m_debugRadioID = radioTag
	this.m_funcs[this.m_debugRadioID] = funcs
	this._PlayDebugStart()
end

-- リアルタイム無線の優先度をデフォルトに戻す
this.ResetRealTimeRadioSubPriority = function( optionalRadioID, radioData, index )
	SubtitlesCommand:ResetSubPriority( 6 )
end
-- 諜報無線の優先度をデフォルトに戻す
this.ResetEpisonageRadioSubPriority = function( optionalRadioID, radioData, index )
	SubtitlesCommand:ResetSubPriority( 9 )
end
-- 任意無線の優先度をデフォルトに戻す
this.ResetOptionalRadioSubPriority = function( optionalRadioID, radioData, index )
	SubtitlesCommand:ResetSubPriority( 25 )
end

-- Register optional radio
this.RegisterOptionalRadio = function( optionalRadioID )
	-- Check if optionalRadioID is valid
	local optionalRadioName = this.m_optionalRadioList[optionalRadioID]
	if( optionalRadioName == nil ) then
		Fox.Error( "Cannot register optional radio! [" .. optionalRadioID .. "] is invalid!" )
		return
	end

	this.m_manager:RegisterRadioGroupSetOverwrite( optionalRadioName )
end

-- Insert data into optional radio set
this.InsertOptionalRadio = function( optionalRadioID, radioData, index )
	local optionalRadioName = this.m_optionalRadioList[optionalRadioID]
	if( optionalRadioName == nil ) then
		Fox.Error( "Cannot insert optional radio! [" .. optionalRadioID .. "] is invalid!" )
		return
	end

	if( index == nil ) then
		this.m_manager:RegisterRadioGroupToRadioGroupSetPushback( radioData, optionalRadioName )
	else
		this.m_manager:RegisterRadioGroupToRadioGroupSetInsert( radioData, optionalRadioName, index )
	end
end

-- Delete data from optional radio set
this.DeleteOptionalRadio = function( optionalRadioID, radioData )
	local optionalRadioName = this.m_optionalRadioList[optionalRadioID]
	if( optionalRadioName == nil ) then
		Fox.Error( "Cannot insert optional radio! [" .. optionalRadioID .. "] is invalid!" )
		return
	end

	this.m_manager:UnregisterRadioGroupFromRadioGroupSet( radioData, optionalRadioName )
end

-- Register intel radio
this.RegisterIntelRadio = function( intelRadioID, radioData, isSave )
	this.m_intelRadioList[intelRadioID] = radioData
	if( isSave == true ) then
		GzRadioSaveData.SetSaveEspionageId( intelRadioID, radioData )
	end
end

-- Restore intel radio
this.RestoreIntelRadio = function()
	if( this.m_intelRadioList == nil ) then
		return
	end

	for key, id in pairs(this.m_intelRadioList) do
		local radioID = GzRadioSaveData.GetEspionageRadioId( key )
		if( radioID ~= 0 ) then
			this.m_intelRadioList[key] = radioID
		end
	end
end

-- Enable intel radio locator
this.EnableIntelRadio = function( locatorID )
	if( this._IsRadioLocatorIDValid( locatorID ) == false ) then return end
	TppPlayerUtility.SetPlayerSightSearchInfoRadioEnable( locatorID, true )
end

-- Disable intel radio locator
this.DisableIntelRadio = function( locatorID )
	if( this._IsRadioLocatorIDValid( locatorID ) == false ) then return end
	TppPlayerUtility.SetPlayerSightSearchInfoRadioEnable( locatorID, false )
end

-- Enable intel radio per character type
this.EnableIntelRadioCharacterType = function( characterType )
	TppPlayerUtility.SetPlayerSightSearchInfoRadioEnable{ type = characterType, enable = true }
end

-- Disable intel radio per character type
this.DisableIntelRadioCharacterType = function( characterType )
	TppPlayerUtility.SetPlayerSightSearchInfoRadioEnable{ type = characterType, enable = false }
end

this.SetAllSaveRadioId = function()
	if( this.m_radioList == nil ) then
		Fox.Error( "TppRadio::SetAllSaveRadioId:  RadioList is nil!" )
		return
	end

	for key, id in pairs(this.m_radioList) do
		if( type(id) == "table" ) then
			GzRadioSaveData.SetSaveRadioId( id[1] )
		end
	end
end

-- 無線が再生可能な状況か
-- (無線の再生をあきらめる、または遅らせる判断のために使用)
this.IdRadioPlayable = function()
	-- 判断基準、判断材料は随時改善
	local isPlayable = true

	-- (全ての音声ではなく)字幕が表示されるような音声が再生されているかを、字幕の表示状態から判断する
	if ( SubtitlesCommand.IsPlayingSubtitles() ) then
		isPlayable = false
	end

	return isPlayable
end

---------------------------------------------------------------------------------
-- Internal Functions
---------------------------------------------------------------------------------

-- Register demo list
this.Register = function( radioList, optionalRadioList, intelRadioList )
	this.m_radioList = radioList
	this.m_optionalRadioList = optionalRadioList
	this.m_intelRadioList = intelRadioList
end

-- Start radio script
this.Start = function()
	this.m_manager = RadioDaemon:GetInstance()
end

-- Execute when a radio is played
this.OnRadioPlay = function()
end

-- Execute when a radio is ended
this.OnRadioEnd = function()
end

-- Execute when a radio is requested
this.OnRadioRequest = function()
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

-- Get radio data from name
this._GetDataFromName = function( radioName, radioType )
	local radioID
	if( radioType == "realtime" ) then
		radioID = this.m_radioList[radioName]
	elseif( radioType == "intel" ) then
		radioID = this.m_intelRadioList[radioName]
	end

	if( radioID == nil ) then
		Fox.Error( "Cannot execute! [" .. tostring( radioName ) .. "] is an invalid radio name!" )
		return nil
	end

	local numPlay = nil
	if( type( radioID ) == "table" ) then
		numPlay = radioID[2]
		radioID = radioID[1]
	end
	return { radioID }, numPlay
end

-- Get radio data from table
this._GetDataFromTable = function( radioGroup, radioType )
	local radioIDs = {}
	local numPlay = nil

	if( type( radioGroup[1] ) == "string" ) then
		for i = 1, #radioGroup do
			local radioID = this._GetDataFromName( radioGroup[i], radioType )
			if( radioID == nil ) then return end
			table.insert( radioIDs, radioID[1] )
		end
	elseif( type( radioGroup[1] ) == "table" ) then
		for i = 1, #radioGroup[1] do
			local radioID = this._GetDataFromName( radioGroup[1][i], radioType )
			if( radioID == nil ) then return end
			table.insert( radioIDs, radioID[1] )
		end
		numPlay = radioGroup[2]
	end
	return radioIDs, numPlay
end

-- Get table of all radio ids and numPlay
this._GetRadioIDsAndNumPlay = function( radioTag, radioType )
	if( type( radioTag ) == "string" ) then
		return this._GetDataFromName( radioTag, radioType )
	elseif( type( radioTag ) == "table" ) then
		return this._GetDataFromTable( radioTag, radioType )
	else
		Fox.Error( "Cannot execute! [" .. tostring( radioTag ) .. "] is invalid!" )
		return nil
	end
end

-- Get radio name
this._GetRadioName = function( radioIDs )
	if( radioIDs == nil ) then return nil end
	return radioIDs[1]
end

-- Check if
this._DoPlayRadio = function( radioName, radioIDs, numPlay, radioType )
	if( numPlay == nil ) then return true end

	-- Init first time
	if( this.m_numPlay[radioName] == nil ) then
		this.m_numPlay[radioName] = 0
	end
	-- 回数指定があったらセーブデータも見る
	if( this.m_manager:IsRadioGroupMarkAsRead( radioIDs[1] ) == true ) then
		-- 既読だったら何もしない
		return false
	end

	-- Check if able to play radio
--	if( this.m_numPlay[radioName] >= numPlay ) then
--		return false
--	else
--		this.m_numPlay[radioName] = this.m_numPlay[radioName] + 1
--	end
	return true
end

-- Handles messages from Radio system
this._MessageHandler = function( manager, data, radioName, message )
	if( message == this.RadioMessageList.Start ) then
		this._OnRadioPlay( radioName )
	elseif( message == this.RadioMessageList.End ) then
		this._OnRadioEnd( radioName )
	elseif( message == this.RadioMessageList.Request ) then
		this._OnRadioRequest( radioName )
	end
end

-- On radio play
this._OnRadioPlay = function( radioName )
	this.OnRadioPlay()
	this._DoMessage( radioName, "onStart" )
end

-- On radio end
this._OnRadioEnd = function( radioName )
	this.OnRadioEnd()
	this._DoMessage( radioName, "onEnd" )
end

-- On radio request
this._OnRadioRequest = function( radioName )
	this.OnRadioRequest()
	this._DoMessage( radioName, "onRequest" )
end

-- Execute function on message
this._DoMessage = function( radioName, funcName )
	if( this.m_funcs == nil or this.m_funcs[radioName] == nil or this.m_funcs[radioName][funcName] == nil ) then return end
	this.m_funcs[radioName][funcName]()
end

-- Play debug radio
this._PlayDebugStart = function()
	if( TppTimer.IsTimerActive( "debugRadioTimer" ) == true ) then return end

	-- Play radio
	this.m_debugRadioFlag = 1
	if( DEBUG ) then
		SoundCommand.PostEvent( this.SFXList.RadioStart )
	end
	this._OnRadioPlay( this.m_debugRadioID )
	this._PlayDebugContinue()
end

-- Play radio table
this._PlayDebugContinue = function()
	-- Play text
	if( this.m_debugRadioFlag <= #this.m_radioList[this.m_debugRadioID] ) then
		local line = this.m_radioList[this.m_debugRadioID][this.m_debugRadioFlag]
		
		--[[
			Calculates how long to display each line of debug radio text.
			Each Japanese character in a string is a length of "3",
			so to get the amount of characters, divide by 3.
			Then, multiply by 0.2 to set the formula of "One Japanese character = Two-tenths of a second"
			So, 10 characters will show for 2 seconds.
			Yes, I know if you pass in English characters, this will show very quickly.
			However, because this is debug, it is (probably) only used for Japanese characters.
			Then, make sure the display time is at least 0.8s
		--]]
		local displayTime = math.ceil( string.len( line ) / 3 ) * 0.2
		displayTime = math.max( displayTime, 0.8 )
		this._PlayDebugLine( line, displayTime )

		-- Set timer time to displayTime + spacer time until next subtitle
		local spacerTime = 0.2
		TppTimer.Start( "debugRadioTimer", displayTime + spacerTime )

		this.m_debugRadioFlag = this.m_debugRadioFlag + 1

	-- Finish playing
	else
		if( DEBUG ) then
			SoundCommand.PostEvent( this.SFXList.RadioEnd )
		end
		this._OnRadioEnd( this.m_debugRadioID )
	end
end

-- Show only one line of text
this._PlayDebugLine = function( text, time )
	-- Set display time to ms
	SubtitlesCommand.DisplayText( text, "Default", time * 1000 )
end

-- Check if intel radio locator ID is valid or not
this._IsRadioLocatorIDValid = function( radioLocatorID )
	for _radioLocatorID, data in pairs( this.m_intelRadioList ) do
		if( radioLocatorID == _radioLocatorID ) then
			return true
		end
	end
	return false
end

-- Play intel radio
this._PlayIntelRadio = function()
	local radioType = "intel"
	local radioLocatorID = TppData.GetArgument( 1 )
	if( this._IsRadioLocatorIDValid( radioLocatorID ) == false ) then return end
	
	-- Get numPlay
	local radioData = this.m_intelRadioList[radioLocatorID]
	local radioName = nil
	local numPlay = nil

	if( type( radioData ) == "string" ) then
		radioName = radioData
	elseif( type( radioData ) == "number" ) then
		radioName = radioData
	elseif( type( radioData ) == "table" ) then
		radioName = radioData[1]
		numPlay = radioData[2]
	end

	-- Init table if not done before
	if( this.m_numPlay[radioName] == nil ) then
		this.m_numPlay[radioName] = 0
	end

	-- Set functions
	local onIntelRadioStart = function()
		print( "start intel radio." )
		--this.DisableIntelRadio( radioLocatorID )
	end
	local onIntelRadioEnd = nil
	if( numPlay == nil or ( numPlay - 1 ) > this.m_numPlay[radioName] ) then
		onIntelRadioEnd = function()
			print( "end intel radio." )
			--this.EnableIntelRadio( radioLocatorID )
		end
	end

	-- Play radio
	TppRadio.Play( radioLocatorID, { onStart = onIntelRadioStart, onEnd = onIntelRadioEnd }, radioType )
end

---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------
this.m_manager = nil
this.m_radiolist = nil
this.m_optionalRadioList = nil
this.m_intelRadioList = nil
this.m_funcs = {}
this.m_numPlay = {}

this.m_debugRadioID = nil
this.m_debugRadioFlag = 1

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this