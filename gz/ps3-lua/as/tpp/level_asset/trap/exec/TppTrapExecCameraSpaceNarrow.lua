-------------------------------------------------------------------------------
--[[FDOC
	@id TppTrapExecCameraSpeceNarrow
	@category TppTrap
	Camera用Trap実行時のScript
]]
--------------------------------------------------------------------------------


TppTrapExecCameraSpaceNarrow = {

--- 実行関数
Exec = function( info )
--	Fox.Log("TppTrapExecCameraSpaceNarrow:Exec ")

	if info.trapFlagString == "GEO_TRAP_S_ENTER" then
--		Fox.Log("Get into CameraSpace Trap!")


	elseif info.trapFlagString == "GEO_TRAP_S_INSIDE" then
--		Fox.Log("Set CameraSpace Inside")

		local chara = info.moverHandle
		local playerInternalWork = chara:FindPlugin( "TppPlayerInternalWorkPlugin" )

		if not Entity.IsNull( playerInternalWork ) then
			playerInternalWork.spaceState:Set( "Narrow" )
--			Fox.Log("Set CameraSpace Narrow")
		end

	elseif info.trapFlagString == "GEO_TRAP_S_OUT" then
--		Fox.Log("Get out from CameraSpace Trap!")

		local chara = info.moverHandle
		local playerInternalWork = chara:FindPlugin( "TppPlayerInternalWorkPlugin" )

		if not Entity.IsNull( playerInternalWork ) then
			playerInternalWork.spaceState:Reset( "Narrow" )
--			Fox.Log("Reset CameraSpace Narrow")
		end


	end
	return 1
end,

}
