-------------------------------------------------------------------------------
--[[FDOC
	@id TppTrapExecDisableTrap
	@category TppTrap
	・トラップから出た時、トラップを無効にする
]]
--------------------------------------------------------------------------------

TppTrapExecDisableTrap = {

-- 実行関数
Exec = function( info )

	-- トラップから出た時実行
	if info.trapFlagString ~= "GEO_TRAP_S_OUT" then
		return 1
	end

	Fox.Log("######## Trap / TppTrapExecDisableTrap.Exec() ################################")

	-- プレイヤーの操作制限を解除する
	TppPadOperatorUtility.ResetMasksForPlayer( 0, "Hospital_IshmaelStopSign" )

	-- トラップを無効にする
	info.trapBodyHandle.enable = false

	return 1
end,

}

