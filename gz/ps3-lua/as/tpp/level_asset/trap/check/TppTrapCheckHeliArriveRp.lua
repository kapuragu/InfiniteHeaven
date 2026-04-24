TppTrapCheckHeliArriveRp = {

------------------------------------------------------------
-- パラメタを追加
------------------------------------------------------------
AddParam = function( condition )
	condition:AddConditionParam( "String", "arriveRendezvousTag" )
end,

------------------------------------------------------------
-- 条件関数
------------------------------------------------------------
Check = function( info )

	local manager = TppSupportHelicopterManager.GetInstance()
	local heliObj = manager:GetCharacterObject()
	if not Entity.IsNull(heliObj) then
		local heliChara = heliObj:GetCharacter()
		if not Entity.IsNull(heliChara) then
			local heliDesc = heliChara:GetCharacterDesc()
			if not Entity.IsNull(heliDesc) and heliDesc:IsArrivingToRendezvousPoint() then
				local rendezvousPoint = heliDesc:GetRendezvousPoint()
				if not Entity.IsNull(rendezvousPoint) then
					if rendezvousPoint:FindTag(info.conditionHandle.arriveRendezvousTag) then
						return 1
					end
				end
			end
		end
	end
	
	return 0

end,

}