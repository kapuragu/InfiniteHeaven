local mafr = {}





mafr.requires = {
	"/Assets/tpp/script/location/mafr/mafr_checkPoint.lua",
	"/Assets/tpp/script/location/mafr/mafr_animal.lua",
	"/Assets/tpp/script/location/mafr/mafr_gimmick.lua",
	"/Assets/tpp/script/location/mafr/mafr_routeSets.lua",
	"/Assets/tpp/script/location/mafr/mafr_cpGroups.lua",
	"/Assets/tpp/script/location/mafr/mafr_travelPlans.lua",
	"/Assets/tpp/script/location/mafr/mafr_combat.lua",
	"/Assets/tpp/script/location/mafr/mafr_baseTelop.lua",
	"/Assets/tpp/script/location/mafr/mafr_base.lua",
	"/Assets/tpp/script/location/mafr/mafr_siren.lua",
	"/Assets/tpp/level/location/mafr/block_common/mafr_luxury_block_list.lua",
}

function mafr.OnAllocate()
	Fox.Log("############### mafr.OnAllocate ###############")
	mvars.loc_locationCommonTable = mafr
	mvars.loc_locationCommonCheckPointList = mafr_checkPoint.CheckPointList
	mvars.loc_locationCommonRouteSets = mafr_routeSets
	mvars.loc_locationCommonCpGroups = mafr_cpGroups
	mvars.loc_locationCommonTravelPlans = mafr_travelPlans
	mvars.loc_locationCommonCombat = mafr_combat
	mvars.loc_locationGimmickCpConnectTable = mafr_gimmick.gimmickCpConnectTable
	mvars.loc_locationBaseTelop = mafr_baseTelop
	mvars.loc_locationSiren = mafr_siren
	mafr_animal.OnAllocate()
end

function mafr.OnInitialize()
	Fox.Log("############### mafr.OnInitialize ###############")
	mafr_gimmick.OnInitialize()
	mafr_base.OnInitialize()
	
end

function mafr.OnReload()
	
end

function mafr.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText )
	--was: strLogText = "mafr.lua:".. strLogText--tex NMC see afgh.lua equivalent
	
	if mafr_animal.OnMessage then
		mafr_animal.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText )
	end
	mafr_gimmick.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText )
end

function mafr.OnMissionCanStart()
	mafr_luxury_block_list.RegistLuxuryBlock()
	mafr_animal.OnMissionCanStart()
end

return mafr