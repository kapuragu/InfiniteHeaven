local this = {}

---------------------------------------------------------------------------------
-- Script Common Functions
---------------------------------------------------------------------------------

local onOpeningDemoFadeIn = function()
	TppUI.FadeIn( 60 )
end

local onOpeningDemoStartTransition = function()
	TppUI.ShowTransition( "opening" )
end

------------------------------------------------------------------------
-- MessageList
------------------------------------------------------------------------
this.Messages = {
	Demo = {
		{ message = "Play",			localFunc = "_OnDemoPlay" },
		{ message = "Finish",		localFunc = "_OnDemoEnd" },
		{ message = "Interrupt",	localFunc = "_OnDemoInterrupt" },
		{ message = "Skip",			localFunc = "_OnDemoSkip" },
		{ message = "Disable",		localFunc = "_OnDemoDisable" }, -- disable at preference
	},
	-- For opening demo
	Timer = {
		{ message = "OnEnd", data = "_openingDemoFadeIn",			commonFunc = onOpeningDemoFadeIn },
		{ message = "OnEnd", data = "_openingDemoStartTransition",	commonFunc = onOpeningDemoStartTransition },
	},
}

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------

-- Play demo
this.Play = function( demoID, funcs, flags )
	-- Check if demoID is valid
	local demoName = this.m_list[demoID]
	if( demoName == nil ) then
		Fox.Error( "Cannot play demo! [" .. demoID .. "] is invalid!" )
		return
	end

	-- Set current demo
	this.m_funcs[demoName] = funcs
	this.m_flags[demoName] = flags
	this.m_playedList[demoName] = true

	local checkFlags = this.m_flags[demoName] or {}

	-- Disable Game
	local disableGame = checkFlags.disableGame == nil and true or checkFlags.disableGame
	if( disableGame ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_GAME")
	end

	TppDemoUtility.Play(demoName)
end

-- Play common opening demo
this.PlayOpening = function( funcs )
	local demoID = "_openingDemo"
	local demoName = "p31_020000_000_final"
	this.m_list[demoID] = demoName

	local onOpeningDemoStart = function()
		TppUI.FadeOut()
		TppTimer.Start( "_openingDemoFadeIn", 3 )
		TppTimer.Start( "_openingDemoStartTransition", 7.5 )
	end
	local onOpeningDemoEnd = nil
	if( funcs ~= nil ) then
		onOpeningDemoEnd = funcs.onEnd
	end

	this.Play( demoID, { onStart = onOpeningDemoStart, onEnd = onOpeningDemoEnd } )
end

---------------------------------------------------------------------------------
-- Internal Functions
---------------------------------------------------------------------------------

-- Register demo list
this.Register = function( demoList )
	this.m_list = demoList
end

-- Start
this.Start = function()
	this.m_manager = DemoDaemon
end

-- Execute when a demo is played
this.OnDemoPlay = function( demoName )

	if this.m_playedList[demoName] == nil then
		return
	end

	local flags = this.m_flags[demoName] or {}

	-- Disable damage filter
	local disableDamageFilter = flags.disableDamageFilter == nil and true or flags.disableDamageFilter
	if( disableDamageFilter ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_FILTER_EFFECTS")
	end

	-- Disable target
	local disableTarget = flags.disableTarget == nil and true or flags.disableTarget
	if( disableTarget ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_TARGET")
	end

	-- Disable trap
	local disableTrap = flags.disableTrap == nil and true or flags.disableTrap
	if( disableTrap ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_TRAP")
	end

	-- Disable npc
	local disableDemoEnemies = flags.disableDemoEnemies == nil and true or flags.disableDemoEnemies
	if( disableDemoEnemies ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_NPC")
	end

	-- Disable disableNpcNotice
	local disableNpcNotice = flags.disableNpcNotice == nil and true or flags.disableNpcNotice
	if( disableNpcNotice ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_NPC_NOTICE")
	end

	-- Disable helicopter
	local disableHelicopter = flags.disableHelicopter == nil and true or flags.disableHelicopter
	if( disableHelicopter ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_SUPPORT_HELICOPTER")
	end

	-- Disable HUD
	local disableHUD = flags.disableHUD == nil and true or flags.disableHUD
	if( disableHUD ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_HUD")
	end

	-- Disable terminal
	local disableTerminal = flags.disableTerminal == nil and true or flags.disableTerminal
	if( disableTerminal ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_TERMINAL")
	end

	-- Disable throwing
	local disableThrowing = flags.disableThrowing == nil and true or flags.disableThrowing
	if( disableThrowing ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_THROWING")
	end

	-- Disable placement
	local disablePlacement = flags.disablePlacement == nil and true or flags.disablePlacement
	if( disablePlacement ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_PLACEMENT")
	end

	-- Disable playerPad
	local disablePlayerPad = flags.disablePlayerPad == nil and true or flags.disablePlayerPad
	if( disablePlayerPad ) then
		TppGameStatus.Set("TppDemo.lua","S_DISABLE_PLAYER_PAD")
	end

end

-- Execute when a demo is ended
this.OnDemoEnd = function( demoName )
	if this.m_playedList[demoName] == nil then
		return
	end

	local flags = this.m_flags[demoName] or {}

	-- Enable Game 
	local enableGame = flags.disableGame == nil and true or flags.disableGame
	if( enableGame ) then
		TppGameStatus.Reset("TppDemo.lua","S_DISABLE_GAME")
	end

	-- Enable damage filter
	local enableDamageFilter = flags.disableDamageFilter == nil and true or flags.disableDamageFilter
	if( enableDamageFilter ) then
		TppGameStatus.Reset("TppDemo.lua","S_DISABLE_FILTER_EFFECTS")
	end

	-- Enable target
	local enableTarget = flags.disableTarget == nil and true or flags.disableTarget
	if( enableTarget ) then
		TppGameStatus.Reset("TppDemo.lua", "S_DISABLE_TARGET")
	end

	-- Enable trap
	local enableTrap = flags.disableTrap == nil and true or flags.disableTrap
	if( enableTrap ) then
		TppGameStatus.Reset("TppDemo.lua", "S_DISABLE_TRAP")
	end

	-- Enable npc
	local enableDemoEnemies = flags.disableDemoEnemies == nil and true or flags.disableDemoEnemies
	if( enableDemoEnemies ) then
		TppGameStatus.Reset("TppDemo.lua","S_DISABLE_NPC")
	end

	-- Enable disableNpcNotice
	local enableNpcNotice = flags.disableNpcNotice == nil and true or flags.disableNpcNotice
	if( enableNpcNotice ) then
		TppGameStatus.Reset("TppDemo.lua","S_DISABLE_NPC_NOTICE")
	end

	-- Enable helicopter
	local enableHelicopter = flags.disableHelicopter == nil and true or flags.disableHelicopter
	if( enableHelicopter ) then
		TppGameStatus.Reset("TppDemo.lua","S_DISABLE_SUPPORT_HELICOPTER")
	end

	-- Enable HUD
	local enableHUD = flags.disableHUD == nil and true or flags.disableHUD
	if( enableHUD ) then
		TppGameStatus.Reset("TppDemo.lua","S_DISABLE_HUD")
	end

	-- Enable terminal
	local enableTerminal = flags.disableTerminal == nil and true or flags.disableTerminal
	if( enableTerminal ) then
		TppGameStatus.Reset("TppDemo.lua","S_DISABLE_TERMINAL")
	end

	-- Enable throwing
	local enableThrowing = flags.disableTerminal == nil and true or flags.disableTerminal
	if( enableThrowing ) then
		TppGameStatus.Reset("TppDemo.lua","S_DISABLE_THROWING")
	end

	-- Enable placement
	local enablePlacement = flags.disablePlacement == nil and true or flags.disablePlacement
	if( enablePlacement ) then
		TppGameStatus.Reset("TppDemo.lua","S_DISABLE_PLACEMENT")
	end

	-- Enable playerPad
	local enablePlayerPad = flags.disablePlayerPad == nil and true or flags.disablePlayerPad
	if( enablePlayerPad ) then
		TppGameStatus.Reset("TppDemo.lua","S_DISABLE_PLAYER_PAD")
	end

end

-- Execute when a demo is interrupted
this.OnDemoInterrupt = function( demoName )
	if this.m_playedList[demoName] == nil then
		return
	end
	this.OnDemoEnd( demoName ) --保険処理
end

-- Execute when a demo is skipped
this.OnDemoSkip = function( demoName )
	if this.m_playedList[demoName] == nil then
		return
	end
end

-- Execute when a demo is disabled at preference
this.OnDemoDisable = function( demoName )
	if this.m_playedList[demoName] == nil then
		return
	end
	this.OnDemoEnd( demoName ) --保険処理
end

---------------------------------------------------------------------------------
-- Private Functions
---------------------------------------------------------------------------------

-- On demo play
this._OnDemoPlay = function( manager, message, demoName )
	this.OnDemoPlay( demoName )
	this._DoMessage( demoName, "onStart" )
end

-- On demo end
this._OnDemoEnd = function( manager, message, demoName )
	this.OnDemoEnd( demoName )
	this._DoMessage( demoName, "onEnd" )
	this.m_playedList[demoName] = nil
end

-- On demo interrupt
this._OnDemoInterrupt = function( manager, message, demoName )
	this.OnDemoInterrupt( demoName )
	this._DoMessage( demoName, "onInterrupt" )
end

-- On demo skip
this._OnDemoSkip = function( manager, message, demoName )
	this.OnDemoSkip( demoName )
	this._DoMessage( demoName, "onSkip" )
end

-- On demo disable
this._OnDemoDisable = function( manager, message, demoName )
	this.OnDemoDisable( demoName )
	this._DoMessage( demoName, "onDisable" )
	this.m_playedList[demoName] = nil
end

-- Execute function on message
this._DoMessage = function( demoName, funcName )
	if( this.m_funcs == nil or this.m_funcs[demoName] == nil or this.m_funcs[demoName][funcName] == nil ) then return end
	this.m_funcs[demoName][funcName]()
end

---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------
this.m_manager = nil
this.m_list = nil
this.m_funcs = {}
this.m_flags = {}
this.m_playedList = {}

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this