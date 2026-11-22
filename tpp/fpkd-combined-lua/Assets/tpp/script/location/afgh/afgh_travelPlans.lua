local afgh_travelPlans = {}








afgh_travelPlans.lrrpNumberDefine = Tpp.Enum{
	"afgh_villageEast_ob",--1
	"afgh_commWest_ob",--2
	"afgh_cliffSouth_ob",--3
	"afgh_villageWest_ob",--4
	"afgh_bridgeWest_ob",--5
	"afgh_tentEast_ob",--6
	"afgh_enemyNorth_ob",--7
	"afgh_cliffWest_ob",--8
	"afgh_cliffEast_ob",--9
	"afgh_fortWest_ob",--10
	"afgh_slopedEast_ob",--11
	"afgh_fortSouth_ob",--12
	"afgh_ruinsNorth_ob",--13
	"afgh_villageNorth_ob",--14
	"afgh_slopedWest_ob",--15
	"afgh_fieldEast_ob",--16
	"afgh_plantSouth_ob",	--17	
	"afgh_waterwayEast_ob",--18
	"afgh_plantWest_ob",--19
	"afgh_fieldWest_ob",--20
	"afgh_remnantsNorth_ob",--21
	"afgh_tentNorth_ob",--22
	"afgh_cliffTown_cp",--23
	"afgh_tent_cp",--24
	"afgh_waterway_cp",--25
	"afgh_powerPlant_cp",--26
	"afgh_sovietBase_cp",--27
	"afgh_remnants_cp",--28
	"afgh_field_cp",--29
	"afgh_citadel_cp",--30
	"afgh_fort_cp",--31
	"afgh_village_cp",--32
	"afgh_bridge_cp",--33
	"afgh_commFacility_cp",--34
	"afgh_slopedTown_cp",--35
	"afgh_enemyBase_cp",--36
	"afgh_bridgeNorth_ob",--37
	"afgh_enemyEast_ob",--38
	"afgh_sovietSouth_ob",--39
}




afgh_travelPlans.cpLinkMatrix = {
	"0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	0	0	0	0",
	"0	0	0	0	0	0	0	1	0	0	1	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0",
	"0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0",
	"0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0",
	"0	0	1	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	1	0	0",
	"1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0",
	"0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	1	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	0	0	0",
	"1	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	1",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	1	1	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	1	0	0	0	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	0	0	0	0	0	1	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"1	0	0	1	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0",
	"0	1	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	1	0	0	0	0	0	0	0	0	1	0	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0",
	"0	0	0	1	0	1	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0",
	"0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0",
	"0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0",
	"0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0",
}












afgh_travelPlans.reinforceTravelPlan = {
	
	
	
	afgh_field_cp = {
		"afgh_fieldEast_ob",
		"afgh_fieldWest_ob",
	},
	afgh_tent_cp = {
		"afgh_tentNorth_ob",
		"afgh_tentEast_ob",
	},
	afgh_remnants_cp = {
		"afgh_remnantsNorth_ob",
		"afgh_field_cp",
	},
	
	
	
	afgh_commFacility_cp = {
		"afgh_ruinsNorth_ob",
		"afgh_commWest_ob",
	},
	afgh_village_cp = {
		"afgh_villageWest_ob",
		"afgh_villageNorth_ob",
	},
	afgh_enemyBase_cp = {
		"afgh_villageWest_ob",
		"afgh_slopedWest_ob",
	},
	afgh_slopedTown_cp = {
		"afgh_commWest_ob",
		"afgh_villageNorth_ob",
	},
	
	
	
	afgh_cliffTown_cp = {
		"afgh_cliffEast_ob",
		"afgh_cliffWest_ob",
	},
	afgh_fort_cp = {
		"afgh_fortWest_ob",
		"afgh_fortSouth_ob",
	},
	afgh_bridge_cp = {
		"afgh_bridgeNorth_ob",
		"afgh_bridgeWest_ob",
	},
	
	
	
	afgh_powerPlant_cp = {
		"afgh_plantWest_ob",
	},
	afgh_sovietBase_cp = {
		"afgh_sovietSouth_ob",
	},
	
	
	
}

afgh_travelPlans.defaultTravelRouteGroup = {
	afgh_villageWest_ob = {
		afgh_enemyBase_cp = {
			"travel", "in_lrrpHold_S"
		},
	},
	afgh_enemyEast_ob = {
		afgh_enemyBase_cp = {
			"travel", "in_lrrpHold_N"
		},
	},
}

return afgh_travelPlans