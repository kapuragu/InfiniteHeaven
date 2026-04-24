local enemies = Ch.FindCharacters( "Enemy" )
for i,enemy in ipairs(enemies.array) do
	local plgPhase = enemy:FindPlugin( "AiPhasePlugin" )
	-- print( plgPhase:GetPhaseController():GetCurrentPhase():GetName() )
	if plgPhase:GetPhaseController():GetCurrentPhase():GetName()=="Alert" then
		TppGameSequence.ExecScriptGameOver()
	end
end
