local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}






this.ENEMY_NAME = {
	VEHICLE					= "sol_vehicle_0000",					
	ELITE					= "sol_enemyBase_0014",					
}

this.VEHICLE_NAME = {
	TRUCK					= "veh_truck_0000",						
}

this.VEHICLE_SPAWN_LIST = {
	{ id = "Spawn", locator = this.VEHICLE_NAME.TRUCK, type = Vehicle.type.EASTERN_TRUCK, subType = Vehicle.subType.EASTERN_TRUCK_CARGO_MATERIAL, },
}

this.soldierPowerSettings = {
	sol_vehicle_0000 = {}, 
	[ this.ENEMY_NAME.ELITE ] = { },
}






this.USE_COMMON_REINFORCE_PLAN = true





this.soldierDefine = {
	
	afgh_village_cp = {
		"sol_village_0000",
		"sol_village_0001",
		"sol_village_0002",
		"sol_village_0003",
		"sol_village_0004",
		"sol_village_0005",
		"sol_village_0006",
		this.ENEMY_NAME.VEHICLE,



		nil
	},
	afgh_slopedTown_cp = {
		"sol_slopedTown_0000",
		"sol_slopedTown_0001",
		"sol_slopedTown_0002",
		"sol_slopedTown_0003",
		"sol_slopedTown_0004",
		"sol_slopedTown_0005",
		"sol_slopedTown_0006",
		"sol_slopedTown_0007",
		"sol_slopedTown_0008",
		"sol_slopedTown_0009",
		"sol_slopedTown_0010",

		nil
	},
	
	afgh_commFacility_cp = {
		"sol_commFacility_0000",
		"sol_commFacility_0001",
		"sol_commFacility_0002",
		"sol_commFacility_0003",
		"sol_commFacility_0004",
		"sol_commFacility_0005",
		"sol_commFacility_0006",
		"sol_commFacility_0007",
		"sol_commFacility_0008",
		nil
	},
	afgh_enemyBase_cp = {
		"sol_enemyBase_0000",
		"sol_enemyBase_0001",
		"sol_enemyBase_0002",
		"sol_enemyBase_0003",
		"sol_enemyBase_0004",
		"sol_enemyBase_0005",
		"sol_enemyBase_0006",
		"sol_enemyBase_0007",
		"sol_enemyBase_0008",
		"sol_enemyBase_0009",
		"sol_enemyBase_0010",
		"sol_enemyBase_0011",
		"sol_enemyBase_0012",
		"sol_enemyBase_0013",
		this.ENEMY_NAME.ELITE,
		"sol_enemyBase_0015",
		"sol_enemyBase_0016",
		"sol_enemyBase_0017",
		"sol_enemyBase_0018",
		nil
	},	

	
	afgh_commWest_ob = {
		"sol_commWest_0000",
		"sol_commWest_0001",
		"sol_commWest_0002",
		"sol_commWest_0003",
		nil
	},
	afgh_ruinsNorth_ob = {
		"sol_ruinsNorth_0000",
		"sol_ruinsNorth_0001",
		"sol_ruinsNorth_0002",
		nil
	},
	afgh_slopedWest_ob = {
		"sol_slopedWest_0000",
		"sol_slopedWest_0001",
		"sol_slopedWest_0002",
		nil
	},
	afgh_villageNorth_ob = {
		"sol_villageNorth_0000",
		"sol_villageNorth_0001",
		"sol_villageNorth_0002",
		"sol_villageNorth_0003",
		nil
	},
	afgh_villageWest_ob = {
		"sol_villageWest_0000",
		"sol_villageWest_0001",
		"sol_villageWest_0002",
		"sol_villageWest_0003",
		nil
	},
	afgh_villageEast_ob = {
		"sol_villageEast_0000",
		"sol_villageEast_0001",
		nil
	},
	
	
	afgh_01_13_lrrp= {
		nil
	},	
	afgh_01_32_lrrp= {
		nil
	},	
	
	afgh_02_14_lrrp = {
		"sol_02_14_0000",
		"sol_02_14_0001",
		lrrpTravelPlan = "travelSlopedTown02", 
		nil
	},
	
	afgh_02_34_lrrp= {
		"sol_02_34_0000",
		"sol_02_34_0001",
		lrrpTravelPlan = "travelCommFacility01", 
		nil
	},
	afgh_02_35_lrrp= {
		nil
	},	
	afgh_04_32_lrrp= {
		nil
	},	
	afgh_04_36_lrrp= {
		nil
	},	
	afgh_13_34_lrrp= {
		nil
	},	
	afgh_14_32_lrrp= {
		nil
	},		
	
	afgh_14_35_lrrp = {
		"sol_14_35_0000",
		"sol_14_35_0001",
		lrrpTravelPlan = "travelSlopedTown01", 
		nil
	},
	afgh_15_35_lrrp= {
		nil
	},
	
	afgh_15_36_lrrp= {
		"sol_15_36_0000",
		"sol_15_36_0001",
		lrrpTravelPlan = "travelEnemyBase01", 
		nil
	},

	nil
}





this.routeSets = {
	afgh_slopedTown_cp	 	= 		{ USE_COMMON_ROUTE_SETS = true,	},

	afgh_enemyBase_cp	 	= 
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_enemyBase_0000",
			},
		},
	},
	afgh_commFacility_cp	=
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_commFacility_0000",
			},
		},
	},

	afgh_commWest_ob	 	= 
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_commWest_0000",
			},
		},
	},
	afgh_slopedWest_ob	 	= 	
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_slopedWest_0000",
			},
		},
	},
	afgh_villageWest_ob	 	= 	
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_villageWest_0000",
			},
		},
	},
	afgh_ruinsNorth_ob	 	= 	
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_ruinsNorth_0000",
			},
		},
	},
	
	afgh_04_32_lrrp		 	= 	
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_32to04_0000",
			},
		},
	},
	afgh_04_36_lrrp		 	= 	
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_04to36_0000",
			},
		},
	},
	afgh_15_36_lrrp		 	= 	
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_36to15_0000",
			},
		},
	},
	afgh_15_35_lrrp		 	= 	
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_15to35_0000",
			},
		},
	},
	afgh_02_35_lrrp		 	= 	
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_35to02_0000",
			},
		},
	},
	afgh_02_34_lrrp		 	=
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_02to34_0000",
			},
		},
	},
	afgh_13_34_lrrp		 	= 	
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_34to13_0000",
			},
		},
	},
	afgh_01_13_lrrp		 	= 	
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_13to01_0000",
			},
		},
	},
	afgh_01_32_lrrp		 	= 	
		{ USE_COMMON_ROUTE_SETS = true,			
		travel = {
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_01to32_0000",
			},
		},
	},
	
	afgh_villageNorth_ob	= { USE_COMMON_ROUTE_SETS = true,	},
	afgh_02_14_lrrp		 	= { USE_COMMON_ROUTE_SETS = true,	},
	afgh_14_32_lrrp		 	= { USE_COMMON_ROUTE_SETS = true,	},	
	afgh_14_35_lrrp		 	= { USE_COMMON_ROUTE_SETS = true,	},
	
	
	afgh_village_cp = {
		USE_COMMON_ROUTE_SETS = true,
		priority = {
			"groupA",
			"groupB",
			"groupC",
			"groupD",
		},
		sneak_day = {
			
			groupA = {
				"rt_village_d_0000",
				"rt_village_d_0001",
				"rt_village_d_0007",
			},
			
			groupB = {
				"rt_village_d_0002",
				"rt_village_d_0005",
			},
			groupC = {
				"rt_village_d_0003",
			},
			groupD = {
				"rt_village_d_0006",
			},
		},
		sneak_night= {
			groupA = {
				"rt_village_n_0002",	
				"rt_village_n_0003",
				"rt_village_n_0005",
			},
			groupB = {
				"rt_village_n_0000",
				"rt_village_n_0008",				
			},
			groupC = {
				"rt_village_n_0001",
			},
			groupD = {
				"rt_village_n_0009",
			},
		},
		caution = {
			groupA = {
				"rt_village_c_0000",
				"rt_village_c_0003",
				"rt_village_c_0007",
				"rt_village_c_0004",
				"rt_village_c_0006",
				"rt_village_c_0005",				
				"rt_village_c_0001",
				"rt_village_c_0002",
				"rt_village_c_0008",
				"rt_village_c_0009",
			},
			groupB = {
			},
			groupC = {
			},
			groupD = {
			},
		},
		travel = {
			lrrpHold = {
				"rt_village_l_0000",
				"rt_village_l_0001",
			},
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_village_0000",
			},
		},
	},

	afgh_slopedTown_cp = {--RETAILBUG duplicate key different value
		priority = {
			"groupA",
			"groupB",
			"groupC",
			"groupD",
		},
		sneak_day = {
			
			groupA = {
				"rt_slopedTown_d_0004",
				"rts_slopedTown_d_0000",

			},
			
			groupB = {
				"rt_slopedTown_d_0000",
				"rt_slopedTown_d_0001",
				"rt_slopedTown_d_0009",
			},
			
			groupC = {
				"rt_slopedTown_d_0006",
				"rt_slopedTown_d_0008",
				"rt_slopedTown_d_0011",
			},
			
			groupD = {
				"rt_slopedTown_d_0002",
				"rt_slopedTown_d_0003",
				"rt_slopedTown_d_0010",
			},
		},
		sneak_night= {
			
			groupA = {
				"rts_slopedTown_n_0001",
				"rt_slopedTown_n_0006",
			},
			
			groupB = {
				"rt_slopedTown_n_0000",
				"rts_slopedTown_n_0000",
				"rt_slopedTown_n_0010",

			},
			
			groupC = {
				"rt_slopedTown_n_0002",		
				"rt_slopedTown_n_0009",
				"rt_slopedTown_n_0001",
			},
			
			groupD = {
				"rt_slopedTown_n_0003",
				"rt_slopedTown_n_0004",
				"rt_slopedTown_n_0008",

			},
		},
		caution = {
			groupA = {
				"rts_slopedTown_c_0000",
				"rt_slopedTown_c_0004",
				"rt_slopedTown_c_0009",
				"rt_slopedTown_c_0005",
			},
			groupB = {
				"rt_slopedTown_c_0006",
				"rt_slopedTown_c_0003",			
				"rt_slopedTown_c_0000",
				"rt_slopedTown_c_0001",
			},
			groupC = {
				"rt_slopedTown_c_0002",
				"rt_slopedTown_c_0007",
			},
			groupD = {
				"rt_slopedTown_c_0008",
				"rt_slopedTown_c_0009",
			},
		},
		hold = {
			default = {
				"rt_slopedTown_h_0000",
				"rt_slopedTown_h_0001",
				"rt_slopedTown_h_0002",
				"rt_slopedTown_h_0003",
			},
		},
		sleep = {
			default = {
				"rt_slopedTown_s_0000",
				"rt_slopedTown_s_0001",
				"rt_slopedTown_s_0002",
				"rt_slopedTown_s_0003",
			},
		},
		travel = {
			lrrpHold = {
				"rt_slopedTown_l_0000",
				"rt_slopedTown_l_0001",
			},
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_slopedTown_0000",
			},
		},	
		nil
	},	

	afgh_villageEast_ob = {
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
				"rts_villageEast_d_0000",
				"rts_villageEast_d_0001",
			},
		},
		sneak_night= {
			groupA = {
				"rts_villageEast_d_0000",
				"rts_villageEast_d_0001",
			},
		},
		caution = {
			groupA = {
				"rt_villageEast_c_0002",
				"rt_villageEast_c_0003",
			},
		},
		hold = {
			default = {
			},
		},
		sleep = {
			default = {
				"rts_villageEast_d_0000",
				"rts_villageEast_d_0001",
			},
		},
		travel = {
			lrrpHold = {
				"rt_villageEast_l_0000",
				"rt_villageEast_l_0001",
			},
			lrrp_vehicle_mission_rts_01 = {
				"rts_v_villageEast_0000",
			},
		},
		nil
	},	
}





this.lrrpHoldTime = 15

this.travelPlans = {

	
	
	travelCommFacility01 = {
		{ cp="afgh_02_34_lrrp", 		routeGroup={ "travel", "lrrp_02to34" } },	
		{ cp="afgh_commFacility_cp", 	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_13_34_lrrp", 		routeGroup={ "travel", "lrrp_34to13" } },	
		{ cp="afgh_ruinsNorth_ob", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_13_34_lrrp", 		routeGroup={ "travel", "lrrp_13to34" } },	
		{ cp="afgh_commFacility_cp",	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_02_34_lrrp",			routeGroup={ "travel", "lrrp_34to02" } },	
		{ cp="afgh_commWest_ob", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
	},
	
	
	travelSlopedTown01 = {
		{ cp="afgh_14_35_lrrp", 		routeGroup={ "travel", "lrrp_35to14" } },	
		{ cp="afgh_villageNorth_ob", 	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_14_32_lrrp", 		routeGroup={ "travel", "lrrp_14to32" } },	
		{ cp="afgh_village_cp", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_14_32_lrrp", 		routeGroup={ "travel", "lrrp_32to14" } },	
		{ cp="afgh_villageNorth_ob", 	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_14_35_lrrp", 		routeGroup={ "travel", "lrrp_14to35" } },	
		{ cp="afgh_slopedTown_cp", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
	},
	
	
	travelSlopedTown02 = {
		{ cp="afgh_02_14_lrrp", 		routeGroup={ "travel", "lrrp_14to02" } },	
		{ cp="afgh_commWest_ob", 	 	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_02_35_lrrp", 		routeGroup={ "travel", "lrrp_02to35" } },	
		{ cp="afgh_slopedTown_cp", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_02_35_lrrp", 		routeGroup={ "travel", "lrrp_35to02" } },	
		{ cp="afgh_commWest_ob", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_02_14_lrrp", 		routeGroup={ "travel", "lrrp_02to14" } },	
		{ cp="afgh_villageNorth_ob",	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
	},
	
	
	travelEnemyBase01 = {
		{ cp="afgh_15_36_lrrp", 		routeGroup={ "travel", "lrrp_36to15" } },	
		{ cp="afgh_slopedWest_ob", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_15_35_lrrp", 		routeGroup={ "travel", "lrrp_15to35" } },	
		{ cp="afgh_slopedTown_cp", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_15_35_lrrp", 		routeGroup={ "travel", "lrrp_35to15" } },	
		{ cp="afgh_slopedWest_ob", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_15_36_lrrp", 		routeGroup={ "travel", "lrrp_15to36" } },	
		{ cp="afgh_enemyBase_cp", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
	},
	
	travelVehicle = {
		{ cp="afgh_village_cp", 		routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_04_32_lrrp",			routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_villageWest_ob",		routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },	
		{ cp="afgh_04_36_lrrp",			routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_enemyBase_cp", 		routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },	
		{ cp="afgh_15_36_lrrp",			routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_slopedWest_ob",		routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },		
		{ cp="afgh_15_35_lrrp",			routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_slopedTown_cp", 		routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },	
		{ cp="afgh_02_35_lrrp",			routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_commWest_ob",		routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_02_34_lrrp",			routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_commFacility_cp",	routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_13_34_lrrp",			routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_ruinsNorth_ob",		routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_01_13_lrrp",			routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },
		{ cp="afgh_villageEast_ob",		routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },	
		{ cp="afgh_01_32_lrrp",			routeGroup={ "travel", "lrrp_vehicle_mission_rts_01" } },		
	},
	
















}





this.combatSetting = {
	afgh_village_cp = {
		USE_COMMON_COMBAT = true,
	},
	afgh_slopedTown_cp = {
		"gts_slopedTown_0000",
		"cs_slopedTown_0000",
	},
	afgh_commFacility_cp = {
		USE_COMMON_COMBAT = true,
	},
	afgh_enemyBase_cp = {
		USE_COMMON_COMBAT = true,
	},
	afgh_commWest_ob = {
		USE_COMMON_COMBAT = true,
	},
	afgh_ruinsNorth_ob = {
		USE_COMMON_COMBAT = true,
	},
	afgh_villageEast_ob = {
		USE_COMMON_COMBAT = true,
	},
	afgh_villageNorth_ob = {
		USE_COMMON_COMBAT = true,
	},	
	afgh_villageWest_ob = {
		USE_COMMON_COMBAT = true,
	},	
	afgh_slopedWest_ob = {
		USE_COMMON_COMBAT = true,
	},	
	nil
}





this.InterCall_TargetPlace_enemyBase = function( soldier2GameObjectId, cpID, interName )
		Fox.Log("s10020:CallBack : Unique : start "..interName )
		
		
		TppMarker.Enable(  this.ENEMY_NAME.ELITE, 0, "none", "map_and_world_only_icon", 0,false, true )

end

this.interrogation = {
	
	afgh_enemyBase_cp = {
		high = {
			{ name = "enqt1000_106939", func = this.InterCall_TargetPlace_enemyBase, },
			nil
		},
		normal = {
			nil
		},
		nil
	},
	nil
}


this.useGeneInter = {

	afgh_slopedTown_cp = true,
	afgh_village_cp = true,
	afgh_commFacility_cp = true,
	afgh_enemyBase_cp = true,

	afgh_commWest_ob = true,
	afgh_ruinsNorth_ob = true,
	afgh_villageNorth_ob = true,
	afgh_villageWest_ob = true,
	afgh_slopedWest_ob = true,
	nil
}





this.SetAllEnemyDisable = function()
	for key, cpName in pairs( this.soldierDefine ) do
		this.SwitchEnableCpSoldiers( cpName , 	false)
	end
end


this.SetAllEnemyAbility = function()
	for key, cpName in pairs( this.soldierDefine ) do
		for key, enemyName in ipairs( cpName ) do
			local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyName )
			local ability = {
				shot    = "low",
				grenade = "low",
				hp      = "low",
				cure    = "low",
				speed   = "low",
				notice  = "low",
				reflex  = "low",
				reload  = "low",
				holdup  = "low",
			}
			local command = { id = "SetPersonalAbility", ability=ability }
			GameObject.SendCommand( gameObjectId, command )
		end
	end
end


this.SetVehicleSpawn = function( spawnList )
	Fox.Log("*** SetVehicleSpawn ***")
	for i, command in ipairs( spawnList ) do
		GameObject.SendCommand( { type="TppVehicle2", }, command )
	end
end


this.SetRelativeVehicle_Track = function()
	local soldierId = GameObject.GetGameObjectId("TppSoldier2", this.ENEMY_NAME.VEHICLE	 )
	local vehicleId = GameObject.GetGameObjectId("TppVehicle2", this.VEHICLE_NAME.TRUCK )
	local relation_command = { id="SetRelativeVehicle", targetId=vehicleId, rideFromBeginning=false }
	GameObject.SendCommand( soldierId, relation_command )
end


this.StartTravel = function( )
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", this.ENEMY_NAME.VEHICLE )
	GameObject.SendCommand( gameObjectId, { id = "StartTravel", travelPlan = "travelVehicle" } )
end


this.RegistHoldRecoveredStateForMissionTask = function( targetList )
	Fox.Log("###*** MissionTask register beginning ***")
	for index, targetName in pairs(targetList) do
		TppEnemy.RegistHoldRecoveredState( targetName )
	end
end



this.SpawnVehicleOnInitialize = function()
	Fox.Log("*** SetVehicleSpawn ***")
	TppEnemy.SpawnVehicles( this.VEHICLE_SPAWN_LIST )
end


this.InitEnemy = function ()

	
	local targetList = {
			this.ENEMY_NAME.ELITE,				
			this.ENEMY_NAME.VEHICLE,			
	}
	this.RegistHoldRecoveredStateForMissionTask( targetList )

end



this.SetUpEnemy = function ()
	TppEnemy.RegisterCombatSetting( this.combatSetting )
	TppEnemy.SetSneakRoute(  this.ENEMY_NAME.VEHICLE , "rts_village_d_0000" ) 

	this.SetRelativeVehicle_Track()
	
	
	TppEnemy.AssignUniqueStaffType{
		locaterName = this.ENEMY_NAME.ELITE,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10020_ENEMY_BASE_COMMANDER,
		alreadyExistParam = { staffTypeId =2, randomRangeId =6, skill ="QuickDraw" },
	}
	TppEnemy.AssignUniqueStaffType{
		locaterName = this.ENEMY_NAME.VEHICLE,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10020_DRIVER,
		alreadyExistParam = { staffTypeId =2, randomRangeId =6, skill ="FultonExpert" },
	}
	
	this.SetAllEnemyAbility()
end


this.OnLoad = function ()
	Fox.Log("*** s10020 onload ***")
end




return this
