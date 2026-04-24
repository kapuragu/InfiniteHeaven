local this = {}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Play BGM
this.PlayBGM = function( bgmName )
	TppMusicManager.StartSceneMode()
	TppMusicManager.PlaySceneMusic( bgmName )
end

-- Stop BGM
this.StopBGM = function( bgmName )
	TppMusicManager.PlaySceneMusic( bgmName )
	TppMusicManager.EndSceneMode()
end

-- Play Event
this.PlayEvent = function( eventName )
	TppCommon.DeprecatedFunction( "TppSoundDaemon.PostEvent( eventName )" )
	TppSoundDaemon.PostEvent( eventName )
end

-- Register source event
this.RegisterSourceEvent = function( name, tag, playEvent, stopEvent )
	TppCommon.DeprecatedFunction( "TppSoundDaemon.GetInstance():RegisterSourceEvent( event )" )
	this.m_manager:RegisterSourceEvent{
		sourceName	= name,
		tag			= tag,
		playEvent	= playEvent,
		stopEvent	= stopEvent,
	}
end

-- Unregister source event
this.UnregisterSourceEvent = function( name, tag )
	TppCommon.DeprecatedFunction( "TppSoundDaemon.GetInstance():UnregisterSourceEvent( event )" )
	this.m_manager:UnregisterSourceEvent{
		sourceName	= name,
		tag			= tag,
	}
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------
this.Start = function()
	this.m_manager = TppSoundDaemon.GetInstance()
end

---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------
this.m_manager = nil

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this