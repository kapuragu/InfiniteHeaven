-------------------------------------------------------------------------------
--[[FDOC
	@id TppTrapExecRainFilter
	@category TppTrap
	カメラがトラップに入ったら雨フィルタを非表示にする、出ていれば表示
]]
--------------------------------------------------------------------------------


TppTrapExecRainFilter = {

--- 実行関数
Exec = function( info )

	if info.trapFlagString == "GEO_TRAP_S_ENTER" then
			Fox.Log("TppRainFilter: Inside Trap")
			local data = info.conditionHandle.tppRainFilterData
			if data:IsKindOf( TppRainFilter ) then
			    local dataBody = data:GetDataBodyWithReferrer( info.conditionBodyHandle )
			    if dataBody ~= nil then
					dataBody:SetForceEnableFlag(false)
			    end
			end
			
	elseif info.trapFlagString == "GEO_TRAP_S_OUT" then
			Fox.Log("TppRainFilter: Outside Trap")
			local data = info.conditionHandle.tppRainFilterData			
			if data:IsKindOf( TppRainFilter ) then
			    local dataBody = data:GetDataBodyWithReferrer( info.conditionBodyHandle )
			    if dataBody ~= nil then
					dataBody:SetForceEnableFlag(true)
			    end
			end
	end
	
	return 1
end,

--- パラメータの追加
AddParam = function( condition )
	condition:AddConditionParam("EntityHandle", "tppRainFilterData")
end,

}
