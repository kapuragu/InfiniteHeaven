local this={}

local StrCode32=Fox.StrCode32
local SendCommand=GameObject.SendCommand

this.STR32_CAN_USE_SEARCH_LIGHT=StrCode32"CanUseSearchLight"
this.STR32_CAN_NOT_USE_SEARCH_LIGHT=StrCode32"CanNotUseSearchLight"
this.STR32_IS_GIMMICK_BROKEN=StrCode32"IsGimmickBroken"
this.STR32_IS_NOT_GIMMICK_BROKEN=StrCode32"IsNotGimmickBroken"

this.SWITCH_ROUTE_FUNC_TABLE={
	[this.STR32_CAN_USE_SEARCH_LIGHT]=function(soldierId,funcNameS32,gimmickNameS32,routeS32,unk5)
		local gimmickId=mvars.gim_gimmackNameStrCode32Table[gimmickNameS32]
		if TppGimmick.IsBroken{gimmickId=gimmickId}then
		  	return false
		else
			if TppClock.GetTimeOfDay()~="night"then
				return false
			end
			return true
		end
	end,
	[this.STR32_CAN_NOT_USE_SEARCH_LIGHT]=function(soldierId,funcNameS32,gimmickNameS32,routeS32,unk5)
		local gimmickId=mvars.gim_gimmackNameStrCode32Table[gimmickNameS32]
		if TppGimmick.IsBroken{gimmickId=gimmickId}then
			return true
		else
			if TppClock.GetTimeOfDay()~="night"then
				return true
			end
			return false
		end
	end,
	[this.STR32_IS_GIMMICK_BROKEN]=function(soldierId,funcNameS32,gimmickNameS32,routeS32,unk5)
		local gimmickId=mvars.gim_gimmackNameStrCode32Table[gimmickNameS32]
		if TppGimmick.IsBroken{gimmickId=gimmickId}then
		  	return true
		else
		  	return false
		end
	end,
	[this.STR32_IS_NOT_GIMMICK_BROKEN]=function(soldierId,funcNameS32,gimmickNameS32,routeS32,unk5)
		local gimmickId=mvars.gim_gimmackNameStrCode32Table[gimmickNameS32]
		if TppGimmick.IsBroken{gimmickId=gimmickId}then
		  	return false
		else
		  	return true
		end
	end,
}

--NMC called from engine (when?) (set up in SetUpSwitchRouteFunc, right there -^-)
--unk4
function this.SwitchRouteFunc(soldierId,funcNameS32,argumentS32,routeS32,unk5)
	if this.debugModule then--tex>
		InfCore.LogFlow("TppEnemy.SwitchRouteFunc "..InfLookup.ObjectNameForGameId(soldierId).." "..InfLookup.StrCode32ToString(funcNameS32).." "..InfLookup.StrCode32ToString(argumentS32).." "..InfLookup.StrCode32ToString(argumentS32).." "..InfLookup.StrCode32ToString(routeS32).." "..InfLookup.StrCode32ToString(unk5))--DEBUGNOW
	end--<
	local func=this.SWITCH_ROUTE_FUNC_TABLE[funcNameS32]
	if func then
		return func(soldierId,funcNameS32,argumentS32,routeS32,unk5)
	end
	return true
end--SwitchRouteFunc

function this.SetUpEnemy()
	if not GameObject.DoesGameObjectExistWithTypeName"TppSoldier2"then
		return
	end
	--SendCommand({type="TppSoldier2"},{id="SetSwitchRouteFunc",func=this.SwitchRouteFunc})
end

return this