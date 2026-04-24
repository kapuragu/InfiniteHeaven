-------------------------------------------------------------------------------
--[[FDOC
	@id TppTrapExecClimb
	@category TppTrap
	Climb用Trap実行時のScript
]]
--------------------------------------------------------------------------------


TppTrapExecClimb = {

--- 実行関数
Exec = function( info )
	--Fox.Log("Climb Trap Exec ")

	if info.trapFlagString == "GEO_TRAP_S_ENTER" then
		--Fox.Log("Get into Climb Trap!")

		local chara = info.moverHandle
		local plgClimb = chara:FindPlugin( "TppClimbActionPlugin" )

		if not Entity.IsNull( plgClimb ) then
			--Fox.Log("Set Climb Trap Enter")
			plgClimb:SendActionRequest( TppClimbStartRequest(0) )
		end

	elseif info.trapFlagString == "GEO_TRAP_S_OUT" then
		--Fox.Log("Get out from Climb Trap!")

		local chara = info.moverHandle
		local plgClimb = chara:FindPlugin( "TppClimbActionPlugin" )

		if not Entity.IsNull( plgClimb ) then
			--Fox.Log("Set Climb Trap Out")
			plgClimb:SendActionRequest( TppClimbEndRequest(0) )
		end

	end
	return 1
end,

}
