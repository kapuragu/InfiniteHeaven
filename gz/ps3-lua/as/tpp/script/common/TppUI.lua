local this = {}

------------------------------------------------------------------------
-- MessageList
------------------------------------------------------------------------
this.Messages = {
	UI = {
		{ message = "StartMissionTelopFadeIn",		localFunc = "_OnOpeningTransitionStart" },
		{ message = "StartMissionTelopFadeOut",		localFunc = "_OnOpeningTransitionEnd" },
		{ message = "StartMissionTelopBgFadeOut",	localFunc = "_OnOpeningTransitionBgEnd" },
		{ message = "EndMissionTelopStartNextLoading",	localFunc = "_OnEndingStartNextLoading" },
		{ message = "EndMissionTelopFadeIn",		localFunc = "_OnEndingTransitionStart" },
		{ message = "EndMissionTelopFadeOut",		localFunc = "_OnEndingTransitionEnd" },
		{ message = "EndMissionTelopRadioStop",		localFunc = "_OnEndingTransitionRadioStop" },
	},
	-- for withFadeOut/withFadeIn/withFadeOutIn
	Timer = {
		{ data = "StartTransitionFadeOut_End",	message = "OnEnd", localFunc = "_OnOpeningTransitionFadeOutEnd" },
		{ data = "EndTransitionFadeOut_End",	message = "OnEnd", localFunc = "_OnEndingTransitionFadeOutEnd" },
		{ data = "StartTransitionFadeIn_End",	message = "OnEnd", localFunc = "_OnOpeningTransitionFadeInEnd" },
		{ data = "EndTransitionFadeIn_End",		message = "OnEnd", localFunc = "_OnEndingTransitionFadeInEnd" },
	},
}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Fade in
this.FadeIn = function( frameNum )
	TppPlayer.DisableControlMode( "LockPadMode" )
	FadeFunction.CallFadeIn( frameNum )
	Fox.Log("TppUI.FadeIn is called.")
end

-- Fade out
this.FadeOut = function( frameNum )
	TppPlayer.EnableControlMode( "LockPadMode" )
	FadeFunction.CallFadeOut( frameNum )
	Fox.Log("TppUI.FadeOut is called.")
end

-- Show transition screen
this.ShowTransition = function( transitionType, funcs )
	this._ShowTransition( transitionType, false, funcs )
end

-- Show transition screen but inGame ( not disable to pad/game/targe... )
this.ShowTransitionInGame = function( transitionType, funcs )
	this._ShowTransition( transitionType, true, funcs )
end

-- Show transition screen with FadeOut ( for Ending )
-- ex
--   game ... fadeout ... transition ... sequence on black screen 
this.ShowTransitionWithFadeOut = function( transitionType, funcs, fadeOutSec )
	if fadeOutSec ~= nil then
		if( transitionType == "opening" ) then
			TppTimer.Start( "StartTransitionFadeOut_End", fadeOutSec )
		elseif( transitionType == "ending" ) then
			TppTimer.Start( "EndTransitionFadeOut_End", fadeOutSec )
		else
			Fox.Error( "Cannot execute! [" .. tostring( transitionType ) .. "] is not a valid transitionType!" )
			return
		end	
		this.m_transitionFuncs[transitionType] = funcs
		this.FadeOut( fadeOutSec )
		this.m_onEndFadeInSec = nil
		this._DisableGameStatusOnFade()
	else
		this._ShowTransition( transitionType, false, funcs )
	end

end

-- Show transition screen with FadeIn ( for Opening )
-- ex
--   sequence on black screen ... transition ... fadein ... game
this.ShowTransitionWithFadeIn = function( transitionType, funcs, fadeInSec )
	this._ShowTransition( transitionType, false, funcs, fadeInSec )
end

-- Show transition screen with FadeOut/FadeIn ( for Opening )
-- ex
--   game ... fadeout ... transition ... fadein ... game
--   demo ... fadeout ... transition ... fadein ... demo
this.ShowTransitionWithFadeOutIn = function( transitionType, funcs, fadeOutSec, fadeInSec )
	if fadeOutSec ~= nil then
		if( transitionType == "opening" ) then
			TppTimer.Start( "StartTransitionFadeOut_End", fadeOutSec )
		elseif( transitionType == "ending" ) then
			TppTimer.Start( "EndTransitionFadeOut_End", fadeOutSec )
		else
			Fox.Error( "Cannot execute! [" .. tostring( transitionType ) .. "] is not a valid transitionType!" )
			return
		end	
		this.m_onEndFadeInSec = fadeInSec
		this.m_transitionFuncs[transitionType] = funcs
		this.FadeOut( fadeOutSec )
		this._DisableGameStatusOnFade()
	else
		this._ShowTransition( transitionType, false, funcs, fadeInSec )
	end
end


-- Show all markers without having to open the Terminal menu
this.ShowAllMarkers = function()
	TppCommon.DeprecatedFunction( "HudCommonDataManager.GetInstance():StartWorldMarkerObj()" )
	this.m_hudData:StartWorldMarkerObj()
end

-- Show icon (for radio)
this.ShowIcon = function( tutorialName, iconName )
	TppCommon.DeprecatedFunction( "HudCommonDataManager.GetInstance():CallButtonGuide( tutorialName, iconName )" )
	this.m_hudData:CallButtonGuide( tutorialName, iconName )
end

---------------------------------------------------------------------------------
-- Internal Functions
---------------------------------------------------------------------------------

-- On start
this.Start = function()
	-- Set hud common data
	this.m_hudData = HudCommonDataManager.GetInstance()
	if( this.m_hudData == NULL ) then
		Fox.Error( "Cannot execute TppUI.lua! HudCommonDataManager does not exist!" )
		return
	end

	-- Set ui common data
	this.m_uiData = UiCommonDataManager.GetInstance()
	if( this.m_uiData == NULL ) then
		Fox.Error( "Cannot execute TppUI.lua! UiCommonDataManager does not exist!" )
		return
	end
end

-- Show transition screen ( internal function )
this._ShowTransition = function( transitionType, inGame, funcs, fadeInSec )
	this.m_onEndFadeInSec = fadeInSec
	this.m_transitionFuncs[transitionType] = nil --initialize

	-- Play transition
	if( transitionType == "opening" ) then
		if( inGame == false) then
			TppGameStatus.Set("TppUI.lua","S_DISABLE_GAME")
		end
		this.m_hudData:CallMissionStartTelop()
	elseif( transitionType == "ending" ) then
		if( inGame == false) then
			TppGameStatus.Set("MissionManager","S_DISABLE_GAME")
			TppGameStatus.Set("TppUI.lua","S_DISABLE_GAME")
		end
		this.m_hudData:CallMissionEndTelop()
	else
		Fox.Error( "Cannot execute! [" .. tostring( transitionType ) .. "] is not a valid transitionType!" )
		return
	end	

	-- Set funcs
	if( funcs ~= nil ) then
		this.m_transitionFuncs[transitionType] = funcs
		this._PlayBGM( transitionType, funcs.playBGM )
	end
end

-- Disable GameStatus at transition fade start
this._DisableGameStatusOnFade = function()
	TppGameStatus.Set("TppUI.lua","S_DISABLE_TARGET")
	TppGameStatus.Set("TppUI.lua","S_DISABLE_TRAP")
	TppGameStatus.Set("TppUI.lua","S_DISABLE_PLAYER_PAD")
end
-- Enable GameStatus at transition fade end
this._EnableGameStatusOnFade = function()
	TppGameStatus.Reset("TppUI.lua","S_DISABLE_TARGET")
	TppGameStatus.Reset("TppUI.lua","S_DISABLE_TRAP")
	TppGameStatus.Reset("TppUI.lua","S_DISABLE_PLAYER_PAD")
end

-- Execute when opening transition starts
this.OnOpeningTransitionStart = function()
end

-- Execute when opening transition ends
this.OnOpeningTransitionEnd = function()
	TppGameStatus.Reset("TppUI.lua","S_DISABLE_GAME")
	if this.m_onEndFadeInSec ~= nil then
		this.FadeIn( this.m_onEndFadeInSec )
		TppTimer.Start( "StartTransitionFadeIn_End", this.m_onEndFadeInSec )
		this._DisableGameStatusOnFade()
	else
		this._EnableGameStatusOnFade()
	end
end

-- Execute when opening transition bg ends
this.OnOpeningTransitionBgEnd = function()
end

-- Execute when ending start next loading
this.OnEndingStartNextLoading = function()
end

-- Execute when ending transition starts
this.OnEndingTransitionStart = function()
end

-- Execute when ending transition ends
this.OnEndingTransitionEnd = function()

	-- 保険処理でエンドテロップ終了時にラジオ止めちゃう。
	local radioDaemon = RadioDaemon:GetInstance()
	radioDaemon:StopDirect()

	TppGameStatus.Reset("TppUI.lua","S_DISABLE_GAME")
	if this.m_onEndFadeInSec ~= nil then
		this.FadeIn( this.m_onEndFadeInSec )
		TppTimer.Start( "EndTransitionFadeIn_End", this.m_onEndFadeInSec )
		this._DisableGameStatusOnFade()
	else
		this._EnableGameStatusOnFade()
	end
end

-- Enable HUD
this.EnableHUD = function()
	TppCommon.DeprecatedFunction( "UiCommonDataManager.GetInstance():ResetDemoSettingForHud()" )
	UiCommonDataManager.GetInstance():ResetDemoSettingForHud()
end

-- Disable HUD
this.DisableHUD = function()
	TppCommon.DeprecatedFunction( "UiCommonDataManager.GetInstance():SetDemoSettingForHud()" )
	UiCommonDataManager.GetInstance():SetDemoSettingForHud()
end

-- Enable Terminal
this.EnableTerminal = function()
	TppCommon.DeprecatedFunction( "UiCommonDataManager.GetInstance():ResetDemoSettingForMBDvc()" )
	UiCommonDataManager.GetInstance():ResetDemoSettingForMBDvc()
end

-- Disable Terminal
this.DisableTerminal = function()
	TppCommon.DeprecatedFunction( "UiCommonDataManager.GetInstance():SetDemoSettingForMBDvc()" )
	UiCommonDataManager.GetInstance():SetDemoSettingForMBDvc()
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

-- On opening transition start
this._OnOpeningTransitionStart = function()
	this.OnOpeningTransitionStart()
	this._DoMessage( "opening", "onStart" )
end

-- On opening transition end
this._OnOpeningTransitionEnd = function()
	this.OnOpeningTransitionEnd()
	this._DoMessage( "opening", "onEnd" )
end

-- On opening transition bg end
this._OnOpeningTransitionBgEnd = function()
	this.OnOpeningTransitionBgEnd()
	this._DoMessage( "opening", "onOpeningBgEnd" )
end

-- On ending transition start next loading
this._OnEndingStartNextLoading = function()
	this.OnEndingStartNextLoading()
	this._DoMessage( "ending", "onEndingStartNextLoading" )
end

-- On ending transition start
this._OnEndingTransitionStart = function()
	this.OnEndingTransitionStart()
	this._DoMessage( "ending", "onStart" )
end

-- On ending transition end
this._OnEndingTransitionEnd = function()
	this.OnEndingTransitionEnd()
	this._DoMessage( "ending", "onEnd" )
end

-- On ending transition radio stop
this._OnEndingTransitionRadioStop = function()
	--リザルトボタンを押したらラジオ止める仕様。
	local radioDaemon = RadioDaemon:GetInstance()
	radioDaemon:StopDirect()
end

-- On opening fadeout's end 
this._OnOpeningTransitionFadeOutEnd = function()
	this._ShowTransition( "opening", false, this.m_transitionFuncs["opening"],this.m_onEndFadeInSec )
end

-- On ending fadeout's end 
this._OnEndingTransitionFadeOutEnd = function()
	this._ShowTransition( "ending", false, this.m_transitionFuncs["ending"],this.m_onEndFadeInSec )
end

-- On opening fadein's end 
this._OnOpeningTransitionFadeInEnd = function()
	this._EnableGameStatusOnFade()
end

-- On ending fadein's end 
this._OnEndingTransitionFadeInEnd = function()
	this._EnableGameStatusOnFade()
end

-- Execute function on message
this._DoMessage = function( transitionName, funcName )
	if( this.m_transitionFuncs == nil or this.m_transitionFuncs[transitionName] == nil or this.m_transitionFuncs[transitionName][funcName] == nil ) then return end
	this.m_transitionFuncs[transitionName][funcName]()
	--同じ関数を二度と起動しないように
	this.m_transitionFuncs[transitionName][funcName] = nil
end

-- Play BGM
this._PlayBGM = function( transitionType, bgmName )
	if( bgmName ~= nil ) then
		TppSoundDaemon.PostEvent( bgmName )
	end
end

---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------
this.m_hudData = nil
this.m_uiData = nil
this.m_transitionFuncs = {}
this.m_onEndFadeInSec = nil -- fadein sec after transition

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this