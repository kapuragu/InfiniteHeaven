-------------------------------------------------------------------------------
--[[FDOC
	@id TppTrapExecIntrude
	@category TppTrap
	Intrude用Trap実行時のScript
]]
--------------------------------------------------------------------------------


TppTrapExecIntrude = {

--- 実行関数
Exec = function( info )
	--Fox.Log("Trap Exec ")

	if info.trapFlagString == "GEO_TRAP_S_ENTER" then
		--Fox.Log("Get into Intrude Trap!")

		local chara = info.moverHandle
		local playerInternalWork = chara:FindPlugin( "TppPlayerInternalWorkPlugin" )

		if not Entity.IsNull( playerInternalWork ) then
			--Fox.Log("Set IntrudeState Enter")
			--playerInternalWork:SetIntrude()
			playerInternalWork.intrudeState:Set( "Enter" )
			--Fox.Log( "playerInternalWork " .. playerInternalWork.intrudeState:GetStatusString() )
		end

	elseif info.trapFlagString == "GEO_TRAP_S_OUT" then
		--Fox.Log("Get out from Intrude Trap!")

		local chara = info.moverHandle
		local playerInternalWork = chara:FindPlugin( "TppPlayerInternalWorkPlugin" )

		if not Entity.IsNull( playerInternalWork ) then
			--Fox.Log("UnsetIntrude")
			--playerInternalWork:UnsetIntrude()
			--Fox.Log("Set IntrudeState Out")
			playerInternalWork.intrudeState:Set( "Out" )
			--Fox.Log( "playerInternalWork " .. playerInternalWork.intrudeState:GetStatusString() )
		end

	end
	return 1
end,

}
