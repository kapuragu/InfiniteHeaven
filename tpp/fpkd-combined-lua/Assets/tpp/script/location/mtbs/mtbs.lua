local mtbs = {}





mtbs.requires = {
	"/Assets/tpp/script/location/mtbs/mtbs_enemy.lua",
	"/Assets/tpp/script/location/mtbs/mtbs_item.lua",
	"/Assets/tpp/script/location/mtbs/mtbs_cluster.lua",
	"/Assets/tpp/script/location/mtbs/mtbs_baseTelop.lua",
	"/Assets/tpp/script/location/mtbs/mtbs_helicopter.lua",
}

function mtbs.OnAllocate()
	Fox.Log("############### mtbs.OnAllocate ###############")
	mvars.loc_locationCommonTable	= mtbs
	mvars.loc_locationBaseTelop		= mtbs_baseTelop
	mtbs_cluster.OnAllocate()
end

function mtbs.OnInitialize()
	Fox.Log("############### mtbs.OnInitialize ###############")
	
	mtbs_enemy.OnInitialize()
	mtbs_item.OnInitialize()
	mtbs_baseTelop.OnInitialize()
	mtbs_helicopter.OnInitialize()
	TppUiCommand.UnRegisterCrackPoints()						
	TppMotherBaseManagement.UnRegisterDataBaseAnimalHabitat()	
end

function mtbs.OnReload()
	
	mtbs_enemy.OnReload()
	mtbs_item.OnReload()
	mtbs_baseTelop.OnReload()
	mtbs_helicopter.OnReload()
end

function mtbs.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText )
	--was: strLogText = "mtbs.lua:".. strLogText--tex NMC see afgh.lua equivalent
	mtbs_enemy.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText )
	mtbs_item.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText )
	mtbs_baseTelop.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText )
	mtbs_helicopter.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText )
end

function mtbs.OnMissionCanStart()
	mtbs_item.OnMissionGameStart()
	mtbs_helicopter.OnMissionGameStart()
end

return mtbs
