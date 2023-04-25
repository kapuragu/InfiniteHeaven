local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}

local BOSS_QUIET	= "BossQuietGameObjectLocator"






this.soldierDefine = {
	nil
}






















this.InitEnemy = function ()
end



this.SetUpEnemy = function ()
end


this.OnLoad = function ()
	Fox.Log("*** s10050 onload ***")
end





this.SetQuietSnipeRoute = function( phase1, phase2 )
	Fox.Log( "#### s10050_enemy.SetQuietSnipeRoute #### phase1Route = " ..phase1.. ", phase2Route = " ..phase2)
	
	local command = {id="SetSnipeRoute", route="route", phase="phase"}
	local gameObjectId = GameObject.GetGameObjectId("TppBossQuiet2", BOSS_QUIET )
	
	
	if gameObjectId ~= GameObject.NULL_ID then
		command.route = phase1
		command.phase = 0
		GameObject.SendCommand(gameObjectId, command)
		command.route = phase2
		command.phase = 1
		GameObject.SendCommand(gameObjectId, command)
	end
	
end


this.SetQuietExtraRoute = function(demo,kill,recovery,antiHeli)
	Fox.Log( "#### s10050_enemy.SetQuietExtraRoute #### demoRoute = " ..demo.. ", killRoute = " ..kill.. ", recoveryRoute = " ..recovery.. ", antiHeliRoute = " ..antiHeli )
	
	local gameObjectId = GameObject.GetGameObjectId("TppBossQuiet2", BOSS_QUIET )

	
	local command = {id="SetDemoRoute", route="route"}
	if gameObjectId ~= GameObject.NULL_ID then
			command.route = demo
			GameObject.SendCommand(gameObjectId, command)
	end

	
	command = {id="SetKillRoute", route="route"}
	if gameObjectId ~= GameObject.NULL_ID then
			command.route = kill
			GameObject.SendCommand(gameObjectId, command)
	end

	
	command = {id="SetRecoveryRoute", route="route"}
	if gameObjectId ~= GameObject.NULL_ID then
			command.route = recovery
			GameObject.SendCommand(gameObjectId, command)
	end
	
	
	command = {id="SetAntiHeliRoute", route="route"}
	if gameObjectId ~= GameObject.NULL_ID then
			command.route = kill
			GameObject.SendCommand(gameObjectId, command)
	end
end


this.SetQuietRelayRoute = function( relay )
	Fox.Log( "#### s10050_enemy.SetQuietRelayRoute #### relayRoute = " ..relay )

	local command = { id="SetLandingRoute", route="route" }
	local gameObjectId = { type="TppBossQuiet2", index=0 }

	command.route = relay	
	GameObject.SendCommand(gameObjectId, command)
end


this.QuietEyeControl = function(eyeFlag)
	local command = {id="SetSightCheck", flag="flag"}
	local gameObjectId = GameObject.GetGameObjectId("TppBossQuiet2", BOSS_QUIET)
	
	if gameObjectId ~= GameObject.NULL_ID then
		
		command.flag = eyeFlag
		GameObject.SendCommand(gameObjectId, command)
		Fox.Log( "#### s10050_enemy.QuietEyeControl #### EyeMode = " ..tostring(eyeFlag) )
	else
		Fox.Log( "#### s10050_enemy.QuietEyeControl #### failed!! " )
	end
end



this.QuietHummingControl = function(hummingFlag)
	local command = {id="SetHumming", flag="flag"}
	local gameObjectId = GameObject.GetGameObjectId("TppBossQuiet2", BOSS_QUIET)
	
	if gameObjectId ~= GameObject.NULL_ID then
		
		command.flag = hummingFlag
		GameObject.SendCommand(gameObjectId, command)
		Fox.Log( "#### s10050_enemy.QuietHummingControl #### HummingMode = " ..tostring(hummingFlag) )
	else
		Fox.Log( "#### s10050_enemy.QuietHummingControl #### failed!!" )
	end
end



this.QuietKillModeChange = function()
	local command = {id="SetKill", flag="flag"}
	local gameObjectId = GameObject.GetGameObjectId("TppBossQuiet2", BOSS_QUIET)
	
	if gameObjectId ~= GameObject.NULL_ID then
		
		command.flag = svars.isKillMode
		GameObject.SendCommand(gameObjectId, command)
		Fox.Log( "#### s10050_enemy.QuietKillModeChange #### KillMode = " ..tostring(svars.isKillMode) )
	else
		Fox.Log( "#### s10050_enemy.QuietKillModeChange #### failed!!" )
	end
end



this.QuietForceCombatMode = function()
	Fox.Log( "#### s10050_enemy.QuietForceCombatMode ####" )
	GameObject.SendCommand( { type="TppBossQuiet2", index=0 }, { id="StartCombat" } )
end


this.StartQuietDeadEffect = function()
	Fox.Log( "#### s10050_enemy.StartQuietDeadEffect ####" )
	local command = { id="StartDeadEffect" }
	local gameObjectId = { type="TppBossQuiet2", index=0 }
	GameObject.SendCommand(gameObjectId, command)
end


this.QuietEyeOpen = function()
	Fox.Log( "#### s10050_enemy.QuietEyeOpen ####" )
	
	
	this.QuietEyeControl(true)
	this.QuietHummingControl(true)	
end


this.QuietKillModeOn = function()

	if ( svars.isQuietDown ) then
		s10050_radio.WhyDoNotYouKillQuiet()	
	else
		svars.isKillMode = true
	
		if (TppQuest.IsOpen("sovietBase_q99020")) then
			TppMission.IgnoreAlertOutOfMissionAreaForBossQuiet(true)
			TppTerminal.EnableTerminalVoice(false)
		end	
		

		s10050_radio.BeCarefulNoCover()	
	end
end


this.QuietKillModeOff = function()
	TppMission.IgnoreAlertOutOfMissionAreaForBossQuiet(false)

	svars.isKillMode = false


end




return this
