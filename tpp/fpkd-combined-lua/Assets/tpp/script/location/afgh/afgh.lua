-- ORIGINALQAR: chunk2
-- PACKPATH: \Assets\tpp\pack\location\afgh\pack_common\afgh_script.fpkd
-- Referenced via AddLocationCommonScriptPack
local afgh = {}





afgh.requires = {
	"/Assets/tpp/script/location/afgh/afgh_checkPoint.lua",
	"/Assets/tpp/script/location/afgh/afgh_animal.lua",
	"/Assets/tpp/script/location/afgh/afgh_gimmick.lua",
	"/Assets/tpp/script/location/afgh/afgh_routeSets.lua",
	"/Assets/tpp/script/location/afgh/afgh_cpGroups.lua",
	"/Assets/tpp/script/location/afgh/afgh_travelPlans.lua",
	"/Assets/tpp/script/location/afgh/afgh_combat.lua",
	"/Assets/tpp/script/location/afgh/afgh_baseTelop.lua",
	"/Assets/tpp/script/location/afgh/afgh_base.lua",
	"/Assets/tpp/script/location/afgh/afgh_siren.lua",
	"/Assets/tpp/level/location/afgh/block_common/afgh_luxury_block_list.lua",
}

function afgh.OnAllocate()
	Fox.Log("############### afgh.OnAllocate ###############")
	mvars.loc_locationCommonTable = afgh
	mvars.loc_locationCommonCheckPointList = afgh_checkPoint.CheckPointList
	mvars.loc_locationCommonRouteSets = afgh_routeSets
	mvars.loc_locationCommonCpGroups = afgh_cpGroups
	mvars.loc_locationCommonTravelPlans = afgh_travelPlans
	mvars.loc_locationCommonCombat = afgh_combat
	mvars.loc_locationGimmickCpConnectTable = afgh_gimmick.gimmickCpConnectTable
	mvars.loc_locationBaseTelop = afgh_baseTelop
	mvars.loc_locationSiren = afgh_siren
	afgh_animal.OnAllocate()
end

function afgh.OnInitialize()
	Fox.Log("############### afgh.OnInitialize ###############")
	afgh_gimmick.OnInitialize()
	afgh_base.OnInitialize()
	
end

function afgh.OnReload()
	
	afgh_base.OnReload()
end

function afgh.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText )
	--tex RETAILBUG: (not really, just marking it for future reconsideration)
	--NMC this, mafr and mtbs equivalents seem to be the only vanilla uses of strLogText, 
	--was: strLogText = "afgh.lua:".. strLogText--tex NMC see Tpp.OnMessage for notes
	
	if afgh_animal.OnMessage then
		afgh_animal.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText )
	end
	
	afgh_gimmick.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText )
end

function afgh.OnMissionCanStart()
	afgh_luxury_block_list.RegistLuxuryBlock()
	afgh_animal.OnMissionCanStart()
end

return afgh
