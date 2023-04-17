local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}






this.ENEMY_NAME = {
	TEACHER1					= "sol_teacher_0000",					
	TEACHER2					= "sol_teacher_0001",					
}	


this.soldierPowerSettings = {
	sol_teacher_0000 = {}, 
	sol_teacher_0001 = {},
}


this.CHILD_NAME = {
	CHILD1					= "sol_child_0000",	
	CHILD2					= "sol_child_0001",	
	CHILD3					= "sol_child_0002",	
	CHILD4					= "sol_child_0003",	
}

this.CHILD_NAME_LIST = {
	this.CHILD_NAME.CHILD1,
	this.CHILD_NAME.CHILD2,
	this.CHILD_NAME.CHILD3,
	this.CHILD_NAME.CHILD4,
}

this.WHITE_NAME = {
	WHITE1					= "sol_flowStation_0000",	
	WHITE2					= "sol_flowStation_0001",	
	WHITE3					= "sol_flowStation_0002",	
	WHITE4					= "sol_flowStation_0003",	
	WHITE5					= "sol_flowStation_0004",	
	WHITE6					= "sol_flowStation_0005",	
	WHITE7					= "sol_flowStation_0006",	
	WHITE8					= "sol_flowStation_0007",	
	WHITE9					= "sol_flowStation_0008",	
	WHITE10					= "sol_flowStation_0009",	
	WHITE11					= "sol_flowStation_0010",	
	WHITE12					= "sol_flowStation_0011",	
	WHITE13					= "sol_flowStation_0012",	
	WHITE14					= "sol_flowStation_0013",	
	WHITE15					= "sol_flowStation_0014",	
	WHITE16					= "sol_flowStation_0015",	
	WHITE17					= "sol_flowStation_0016",	
	WHITE18					= "sol_flowStation_0017",	
	WHITE19					= "sol_swampWest_0000",	
	WHITE20					= "sol_swampWest_0001",	
	WHITE21					= "sol_swampWest_0002",	
	WHITE22					= "sol_swampWest_0003",	
	WHITE23					= "sol_swampWest_0004",	
	WHITE24					= "sol_swampWest_0005",	
	WHITE25					= "sol_walkerGear_0000",	
	WHITE26					= "sol_walkerGear_0001",	
	WHITE27					= "sol_walkerGear_0002",	
	WHITE28					= "sol_walkerGear_0003",	
}

this.BLACK_NAME = {
	BLACK1					= "sol_outland_0000",	
	BLACK2					= "sol_outland_0001",	
	BLACK3					= "sol_outland_0002",	
	BLACK4					= "sol_outland_0003",	
	BLACK5					= "sol_outland_0004",	
	BLACK6					= "sol_outland_0005",	
	BLACK7					= "sol_teacher_0000",	
	BLACK8					= "sol_teacher_0001",	
	BLACK9					= "sol_01_20_0000",
	BLACK10					= "sol_01_20_0001",
	BLACK11					= "sol_outlandEast_0000",
	BLACK12					= "sol_outlandEast_0001",
	BLACK13					= "sol_outlandEast_0002",
	BLACK14					= "sol_outlandEast_0003",
	BLACK15					= "sol_outlandNorth_0000",
	BLACK16					= "sol_outlandNorth_0001",
	BLACK17					= "sol_outlandNorth_0002",
	BLACK18					= "sol_outlandNorth_0003",
}

this.WALKERGEAR_NAME = {
	WALKERGEAR1					= "wkr_s10080_0000",	
	WALKERGEAR2					= "wkr_s10080_0001",	
	WALKERGEAR3					= "wkr_s10080_0002",	
	WALKERGEAR4					= "wkr_s10080_0003",	
}

this.WALKERGEARSOLGER_LIST = {	
	{0,"sol_walkerGear_0000", this.WALKERGEAR_NAME.WALKERGEAR1,	},
	{1,"sol_walkerGear_0001", this.WALKERGEAR_NAME.WALKERGEAR2,	},
	{2,"sol_walkerGear_0002", this.WALKERGEAR_NAME.WALKERGEAR3,	},
	{3,"sol_walkerGear_0003", this.WALKERGEAR_NAME.WALKERGEAR4,	},
}

this.REINFORCEMENT_LIST = {
	this.WHITE_NAME.WHITE19,
	this.WHITE_NAME.WHITE20,
	this.WHITE_NAME.WHITE21,
	this.WHITE_NAME.WHITE22,
	this.WHITE_NAME.WHITE25,
	this.WHITE_NAME.WHITE26,
}

this.VEHICLE_NAME = {
	VEHICLE1					= "veh_vehicle_0000",	
	VEHICLE2					= "veh_vehicle_0001",	
}

this.VEHICLE_SPAWN_LIST = {
	{ id = "Spawn", locator = this.VEHICLE_NAME.VEHICLE1, 
		type = Vehicle.type.WESTERN_LIGHT_VEHICLE , paintType = Vehicle.paintType.FOVA_0, },
	{ id = "Spawn", locator = this.VEHICLE_NAME.VEHICLE2, 
		type = Vehicle.type.WESTERN_LIGHT_VEHICLE , paintType = Vehicle.paintType.FOVA_0, },
}





this.soldierDefine = {
	
	mafr_outland_cp = {
		"sol_outland_0000",
		"sol_outland_0001",
		"sol_outland_0002",
		"sol_outland_0003",
		"sol_outland_0004",
		"sol_outland_0005",
		this.ENEMY_NAME.TEACHER1,
		this.ENEMY_NAME.TEACHER2,
		nil
	},
	mafr_outland_child_cp= {
		this.CHILD_NAME.CHILD1,
		this.CHILD_NAME.CHILD2,
		this.CHILD_NAME.CHILD3,
		this.CHILD_NAME.CHILD4,
		nil
	},
	mafr_flowStation_cp = {
		"sol_flowStation_0000",
		"sol_flowStation_0001",
		"sol_flowStation_0002",
		"sol_flowStation_0003",
		"sol_flowStation_0004",
		"sol_flowStation_0005",
		"sol_flowStation_0006",
		"sol_flowStation_0007",
		"sol_flowStation_0008",
		"sol_flowStation_0009",
		"sol_flowStation_0010",
		"sol_flowStation_0011",
		"sol_flowStation_0012",
		"sol_flowStation_0013",
		"sol_flowStation_0014",
		"sol_flowStation_0015",
		"sol_flowStation_0016",
		"sol_flowStation_0017",
		nil
	},
	
	mafr_outlandEast_ob = {
		"sol_outlandEast_0000",
		"sol_outlandEast_0001",
		"sol_outlandEast_0002",
		"sol_outlandEast_0003",
		nil
	},
	mafr_outlandNorth_ob = {
		"sol_outlandNorth_0000",
		"sol_outlandNorth_0001",
		"sol_outlandNorth_0002",
		"sol_outlandNorth_0003",
		nil
	},
	mafr_swampWest_ob = {
		"sol_swampWest_0000",
		"sol_swampWest_0001",
		"sol_swampWest_0002",
		"sol_swampWest_0003",
		"sol_swampWest_0004",
		"sol_swampWest_0005",
		"sol_walkerGear_0000",
		"sol_walkerGear_0001",
		"sol_walkerGear_0002",		
		"sol_walkerGear_0003",
		nil
	},
	
	
	mafr_01_20_lrrp = {
		"sol_01_20_0000",
		"sol_01_20_0001",
		lrrpTravelPlan = "travelOutland01", 
		nil
	},
	mafr_03_20_lrrp = {
		nil
	},
	
	nil
}


this.soldierTypes = {
	CHILD = {
		this.soldierDefine.mafr_outland_child_cp
	},
}







this.routeSets = {
	
	mafr_outland_cp		 	= { USE_COMMON_ROUTE_SETS = true,	},
	mafr_outland_cp = {--RETAILBUG: duplicate key different value, overrides above
		priority = {
			"groupA",
			"groupB",
			"groupC",
			"teacherA",
			"teacherB",
		},
		sneak_day = {
			groupA = {
				"rt_outland_d_0000_no_tower_sub",

				"rt_outland_d_0002",
			},
			groupB = {
				"rt_outland_d_0008",

				"rt_outland_d_0005",
			},
			groupC = {
				"rt_outland_d_0007",
				"rt_outland_d_0006",
			},
			teacherA = {
				"rt_outland_d_0009",
			},
			teacherB = {
				"rt_outland_d_0010",
			},
		},
		sneak_night= {
			groupA = {
				"rt_outland_n_0000_no_search_light_sub",

				"rt_outland_n_0002",
			},
			groupB = {
				"rt_outland_n_0003",
				"rt_outland_n_0004",
			},
			groupC = {
				"rt_outland_n_0005",
				"rt_outland_n_0006",
			},
			teacherA = {
				"rt_outland_n_0009",
			},
			teacherB = {
				"rt_outland_n_0010",
			},
		},
		caution = {
			groupA = {
				"rt_outland_c_0000",
				"rt_outland_c_0002",
			},
			groupB = {
				"rt_outland_c_0003",
				"rt_outland_c_0004",
			},
			groupC = {
				"rt_outland_c_0005",
				"rt_outland_c_0006",
			},
			teacherA = {
				"rt_outland_c_0005",
			},
			teacherB = {
				"rt_outland_c_0001",
			},
		},
		hold = {
			
			
			default = {
				"rt_outland_h_0000",
				"rt_outland_h_0001",
				"rt_outland_h_0002",
				"rt_outland_h_0003",
			},
		},
		sleep = {
			default = {
				"rt_outland_s_0000",
				"rt_outland_s_0001",
				"rt_outland_s_0002",
				"rt_outland_s_0003",
			},
		},
		travel = {
			lrrpHold = {
				"rt_outland_l_0000",
				"rt_outland_l_0001",
			},
		},
		nil
	},


	mafr_flowStation_cp = {
		
		
		
		priority = {
			"groupA",
			"groupB",
			"groupC",
			"groupD",
		},
		sneak_day = {
			groupA = {
				"rts_flowStation_d_0000",
				"rts_flowStation_d_0001",
				"rts_flowStation_d_0002",
			},
			groupB = {
				"rt_flowStation_d_0000",
				"rt_flowStation_d_0002",
				"rt_flowStation_d_0003",
				"rt_flowStation_d_0004",
				"rts_flowStation_d_0004",
			},
			groupC = {
				"rt_flowStation_d_0005",
				"rt_flowStation_d_0007",
				"rt_flowStation_d_0008",
				"rt_flowStation_d_0009",
			},
			groupD = {
				"rt_flowStation_d_0001",
				"rt_flowStation_d_0006",
				"rt_flowStation_d_0010",
				"rt_flowStation_d_0011",
				"rt_flowStation_d_0012",
				"rts_flowStation_d_0003",
			},
		},
		sneak_night= {
			groupA = {
				"rts_flowStation_n_0000",
				"rts_flowStation_n_0001",
				"rts_flowStation_n_0002",
			},
			groupB = {
				"rt_flowStation_n_0000",
				"rt_flowStation_n_0001",
				"rt_flowStation_n_0002",			
				"rt_flowStation_n_0009",
				"rts_flowStation_n_0004",	
			},
			groupC = {
				"rt_flowStation_n_0004",
				"rt_flowStation_n_0005",
				"rt_flowStation_n_0006",		
				"rt_flowStation_n_0010",
			},
			groupD = {
				"rt_flowStation_n_0003",		
				"rt_flowStation_n_0007",
				"rt_flowStation_n_0007",
				"rt_flowStation_n_0008",
				"rt_flowStation_n_0008",
				"rts_flowStation_n_0003",

			},
		},
		caution = {
			groupA = {
				"rt_flowStation_c_0010",
				"rts_flowStation_c_0000",
				"rts_flowStation_c_0001",
				"rts_flowStation_c_0003",
			},
			groupB = {
				"rt_flowStation_c_0000",
				"rt_flowStation_c_0002",
				"rt_flowStation_c_0003",
				"rt_flowStation_c_0004",		
				"rts_flowStation_c_0004",
			},
			groupC = {
				"rt_flowStation_c_0006",	
				"rt_flowStation_c_0007",
				"rt_flowStation_c_0008",
			},
			groupD = {
				"rt_flowStation_c_0001",			
				"rt_flowStation_c_0005",
				"rt_flowStation_c_0005",
				"rt_flowStation_c_0009",
				"rt_flowStation_c_0009",
				"rts_flowStation_c_0002",
			},
		},
		hold = {
			
			
			default = {
				"rt_flowStation_h_0000",
				"rt_flowStation_h_0001",
				"rt_flowStation_h_0002",
				"rt_flowStation_h_0003",
			},
		},
		sleep = {
			default = {
				"rt_flowStation_s_0000",
				"rt_flowStation_s_0001",
				"rt_flowStation_s_0002",
				"rt_flowStation_s_0003",
			},
		},
		nil
	},

	mafr_swampWest_ob		 	= { USE_COMMON_ROUTE_SETS = true,	},
	mafr_outlandEast_ob		 	= { USE_COMMON_ROUTE_SETS = true,	},
	mafr_outlandNorth_ob	 	= { USE_COMMON_ROUTE_SETS = true,	},

	mafr_01_20_lrrp				= { USE_COMMON_ROUTE_SETS = true,	},
	mafr_03_20_lrrp				= { USE_COMMON_ROUTE_SETS = true,	},
	
	nil
}





this.lrrpHoldTime = 15

this.travelPlans = {
	
	
	travelOutland01 = {
		{ cp="mafr_01_20_lrrp", 		routeGroup={ "travel", "lrrp_01to20" } },	
		{ cp="mafr_outland_cp", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="mafr_03_20_lrrp", 		routeGroup={ "travel", "lrrp_20to03" } },	
		{ cp="mafr_outlandEast_ob", 	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="mafr_03_20_lrrp", 		routeGroup={ "travel", "lrrp_03to20" } },	
		{ cp="mafr_outland_cp",			routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="mafr_01_20_lrrp",			routeGroup={ "travel", "lrrp_20to01" } },	
		{ cp="mafr_outlandNorth_ob", 	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
	},

}






this.UniqueInterEnd_sol_teacher_0000 = function( soldier2GameObjectId, cpID )
	Fox.Log("s10080:CallBack : Unique : End sol_teacher_0000")
	
end

this.UniqueInterStart_sol_teacher_0000 = function( soldier2GameObjectId, cpID )
	Fox.Log("s10080:CallBack : Unique : start sol_teacher_0000" )

	TppInterrogation.UniqueInterrogation( cpID, "enqt1000_108344")
	return true	
	
end


this.uniqueInterrogation = {
        
		unique = {
                
				{ name = "enqt1000_108344", func = this.UniqueInterEnd_sol_teacher_0000, },
                nil
		},
        
		uniqueChara = {
				{ name = "sol_teacher_0000", func = this.UniqueInterStart_sol_teacher_0000, },
                nil
		},
        nil
}



this.useGeneInter = {

	mafr_outland_cp			 	= true,
	mafr_flowStation_cp		 	= true,
	mafr_swampWest_ob		 	= true,
	mafr_outlandEast_ob		 	= true,
	mafr_outlandNorth_ob	 	= true,
	mafr_01_20_lrrp				= true,
	nil
}

this.interrogation = {

}


this.HighInterrogation = function()
	Fox.Log("*** HighInterrogation ***")
	TppInterrogation.AddHighInterrogation(
		GameObject.GetGameObjectId( "mafr_flowStation_cp" ),
		{ 
		}
	)
end




this.SwitchEnableCpSoldiers =  function(soldierList, switch)
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local command = { id="SetEnabled", enabled = switch }

	for idx = 1, table.getn(soldierList) do
		local gameObjectId = GetGameObjectId("TppSoldier2", soldierList[idx])
		if gameObjectId ~= NULL_ID then--RETAILBUG: undefined
			Fox.Log("s10080:SwitchEnableCpSoldiers : " .. soldierList[idx]  )
			SendCommand( gameObjectId, command )
		end
	end
end		
		

this.spawnVehicle = function()
	TppEnemy.SpawnVehicles( this.VEHICLE_SPAWN_LIST )
end
	

this.setupWalkerGear = function(gearIndex,solName,wkrName)
	
	local soldierId = GameObject.GetGameObjectId("TppSoldier2", solName )
	local vehicleId = GameObject.GetGameObjectId("TppCommonWalkerGear2", wkrName )
	local relation_command = { id="SetRelativeVehicle", targetId=vehicleId, rideFromBeginning=false }
	GameObject.SendCommand( soldierId, relation_command )
	
	local changecolor_command = { id = "SetColoringType", type = 2 }
	GameObject.SendCommand( vehicleId, changecolor_command )
end	



this.childDemoRouteCheck = function()

	local isOnRoute_CHILD1 = GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", this.CHILD_NAME.CHILD1 ), { id = "IsOnRoute", route="rts_outland_d_0002", } )
	local isOnRoute_CHILD2 = GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", this.CHILD_NAME.CHILD2 ), { id = "IsOnRoute", route="rts_outland_d_0003", } )
	local isOnRoute_CHILD3 = GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", this.CHILD_NAME.CHILD3 ), { id = "IsOnRoute", route="rts_outland_d_0004", } )
	local isOnRoute_CHILD4 = GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", this.CHILD_NAME.CHILD4 ), { id = "IsOnRoute", route="rts_outland_d_0005", } )
	local isOnRoute_TEACHER1 = GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", this.ENEMY_NAME.TEACHER1 ), { id = "IsOnRoute", route="rts_outland_d_0000", } )	
	local isOnRoute_TEACHER2 = GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", this.ENEMY_NAME.TEACHER2 ), { id = "IsOnRoute", route="rts_outland_d_0001", } )

	if isOnRoute_CHILD1 and isOnRoute_CHILD2 and isOnRoute_CHILD3 and isOnRoute_CHILD4 and isOnRoute_TEACHER1 and isOnRoute_TEACHER2 then
		return true		
	else
		return false	
	end

end

	

this.mountainHunting = function()
	TppEnemy.SetSneakRoute( "sol_swampWest_0002" , "rts_mountainHunting_0000")
	TppEnemy.SetSneakRoute( "sol_swampWest_0003" , "rts_mountainHunting_0000")
	TppEnemy.SetCautionRoute( "sol_swampWest_0002" , "rts_mountainHunting_0000")
	TppEnemy.SetCautionRoute( "sol_swampWest_0003" , "rts_mountainHunting_0000")
end


this.reinforcement_normal = function()

	TppEnemy.SetSneakRoute( "sol_walkerGear_0000" , "rts_reinforcement_hum_0000")
	TppEnemy.SetSneakRoute( "sol_walkerGear_0001" , "rts_reinforcement_hum_0001")
	TppEnemy.SetSneakRoute( "sol_walkerGear_0002" , "rts_reinforcement_hum_0002")
	TppEnemy.SetSneakRoute( "sol_walkerGear_0003" , "rts_reinforcement_hum_0003")	
	TppEnemy.SetCautionRoute( "sol_walkerGear_0000" , "rts_reinforcement_hum_c_0000")
	TppEnemy.SetCautionRoute( "sol_walkerGear_0001" , "rts_reinforcement_hum_c_0001")
	TppEnemy.SetCautionRoute( "sol_walkerGear_0002" , "rts_reinforcement_hum_c_0002")
	TppEnemy.SetCautionRoute( "sol_walkerGear_0003" , "rts_reinforcement_hum_c_0003")
end


this.reinforcement_ready = function()
	
	for i, value in pairs( this.WALKERGEARSOLGER_LIST ) do
		this.setupWalkerGear(value[1],value[2],value[3])
	end
end


this.reinforcement_start = function(sol1_rtPoint,sol2_rtPoint,wkr_rtPoint)
	
	TppEnemy.SetSneakRoute( "sol_swampWest_0000" , "rts_reinforcement1_0000", sol1_rtPoint)
	TppEnemy.SetSneakRoute( "sol_swampWest_0001" , "rts_reinforcement1_0001", sol1_rtPoint)
	TppEnemy.SetSneakRoute( "sol_swampWest_0002" , "rts_reinforcement2_0000" , sol2_rtPoint)
	TppEnemy.SetSneakRoute( "sol_swampWest_0003" , "rts_reinforcement2_0001" , sol2_rtPoint)
	TppEnemy.SetSneakRoute( "sol_swampWest_0004" , "rts_reinforcement2_0002" , sol2_rtPoint)
	
	TppEnemy.SetCautionRoute( "sol_swampWest_0000" , "rts_reinforcement1_0000")
	TppEnemy.SetCautionRoute( "sol_swampWest_0001" , "rts_reinforcement1_0001")
	TppEnemy.SetCautionRoute( "sol_swampWest_0002" , "rts_reinforcement2_0000")
	TppEnemy.SetCautionRoute( "sol_swampWest_0003" , "rts_reinforcement2_0001")
	TppEnemy.SetCautionRoute( "sol_swampWest_0004" , "rts_reinforcement2_0002")

	
	TppEnemy.SetSneakRoute( "sol_walkerGear_0000" , "rts_reinforcement_wkr_0000",wkr_rtPoint)
	TppEnemy.SetSneakRoute( "sol_walkerGear_0001" , "rts_reinforcement_wkr_0001",wkr_rtPoint)
	TppEnemy.SetSneakRoute( "sol_walkerGear_0002" , "rts_reinforcement_wkr_0002")
	TppEnemy.SetSneakRoute( "sol_walkerGear_0003" , "rts_reinforcement_wkr_0003")
	
	TppEnemy.SetCautionRoute( "sol_walkerGear_0000" , "rts_reinforcement_wkr_0000")
	TppEnemy.SetCautionRoute( "sol_walkerGear_0001" , "rts_reinforcement_wkr_0001")
	TppEnemy.SetCautionRoute( "sol_walkerGear_0002" , "rts_reinforcement_wkr_0002")
	TppEnemy.SetCautionRoute( "sol_walkerGear_0003" , "rts_reinforcement_wkr_0003")

end


this.reinforcement_loop = function()
	TppEnemy.SetSneakRoute( "sol_walkerGear_0000" , "rts_reinforcement_wkr_0000_loop")
	TppEnemy.SetSneakRoute( "sol_walkerGear_0001" , "rts_reinforcement_wkr_0001_loop")	
	
	TppEnemy.SetCautionRoute( "sol_walkerGear_0000" , "rts_reinforcement_wkr_0000_loop")
	TppEnemy.SetCautionRoute( "sol_walkerGear_0001" , "rts_reinforcement_wkr_0001_loop")	
end


this.flowStation_clearing_start = function()
	TppEnemy.SetCautionRoute( "sol_flowStation_0000" , "rt_flowStation_c_0001")
	TppEnemy.SetCautionRoute( "sol_flowStation_0001" , "rt_flowStation_c_0002")
	TppEnemy.SetCautionRoute( "sol_flowStation_0002" , "rt_flowStation_c_0003")
	TppEnemy.SetCautionRoute( "sol_flowStation_0003" , "rt_flowStation_c_0003")
	TppEnemy.SetCautionRoute( "sol_flowStation_0004" , "rt_flowStation_c_0005")
	TppEnemy.SetCautionRoute( "sol_flowStation_0005" , "rt_flowStation_c_0007")
	TppEnemy.SetCautionRoute( "sol_flowStation_0006" , "rt_flowStation_c_0009")
	TppEnemy.SetCautionRoute( "sol_flowStation_0007" , "rt_flowStation_c_0009")
	TppEnemy.SetCautionRoute( "sol_flowStation_0008" , "rt_flowStation_c_0010")
	TppEnemy.SetCautionRoute( "sol_flowStation_0009" , "rt_flowStation_c_0010")
	TppEnemy.SetCautionRoute( "sol_flowStation_0010" , "rt_flowStation_c_0012")
	TppEnemy.SetCautionRoute( "sol_flowStation_0011" , "rt_flowStation_c_0004")
	TppEnemy.SetCautionRoute( "sol_flowStation_0012" , "rts_flowStation_c_0001")
	TppEnemy.SetCautionRoute( "sol_flowStation_0013" , "rts_flowStation_c_0002")
	TppEnemy.SetCautionRoute( "sol_flowStation_0014" , "rts_flowStation_c_0003")
	TppEnemy.SetCautionRoute( "sol_flowStation_0015" , "rts_flowStation_c_0004")
	TppEnemy.SetCautionRoute( "sol_flowStation_0016" , "rts_flowStation_c_escape_0000")
	TppEnemy.SetCautionRoute( "sol_flowStation_0017" , "rts_flowStation_c_escape_0000")
end


this.setupRace_white = function()
	for i, value in pairs( this.WHITE_NAME ) do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", value )
		local command = { id = "ChangeFova", faceId=EnemyFova.INVALID_FOVA_VALUE, race=0 }
		GameObject.SendCommand( gameObjectId, command )
	end
end

this.setupRace_black = function()
	for i, value in pairs( this.BLACK_NAME ) do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", value )
		local command = { id = "ChangeFova", faceId=EnemyFova.INVALID_FOVA_VALUE, race=2 }
		GameObject.SendCommand( gameObjectId, command )
	end
end

this.setupChild = function()
	for i, value in pairs( this.CHILD_NAME ) do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", value ) 
		
		local command = { id = "UseExtendParts" , enabled = true }
		GameObject.SendCommand( gameObjectId, command )
		




		
		local command = { id = "SetEnableDyingState", enabled = false }
		GameObject.SendCommand( gameObjectId, command )
		
		local command = { id = "SetChildCp" }
		GameObject.SendCommand( gameObjectId, command )
		
		
		TppEnemy.SetEnableRestrictNotice( value )
	end
end	


this.TeacherRouteChange_normal = function()
	TppEnemy.InitialRouteSetGroup{
        cpName = "mafr_outland_cp",
        soldierList = { this.ENEMY_NAME.TEACHER1 },
        groupName = "teacherA"
	}
	TppEnemy.InitialRouteSetGroup{
        cpName = "mafr_outland_cp",
        soldierList = { this.ENEMY_NAME.TEACHER2 },
        groupName = "teacherB"
	}
end


this.teacherRouteSet_training_day = function()
	TppEnemy.SetSneakRoute( this.ENEMY_NAME.TEACHER1, "rts_outland_d_0000")
	TppEnemy.SetSneakRoute( this.ENEMY_NAME.TEACHER2, "rts_outland_d_0001")
end
this.teacherRouteSet_training_night = function()
	TppEnemy.SetSneakRoute( this.ENEMY_NAME.TEACHER1, "rts_outland_n_0000")
	TppEnemy.SetSneakRoute( this.ENEMY_NAME.TEACHER2, "rts_outland_n_0001")
end

this.teacherRouteSet_normal_day = function()
	TppEnemy.SetSneakRoute( this.ENEMY_NAME.TEACHER1, "rt_outland_d_0009")
	TppEnemy.SetSneakRoute( this.ENEMY_NAME.TEACHER2, "rt_outland_d_0010")
end
this.teacherRouteSet_normal_night = function()
	TppEnemy.SetSneakRoute( this.ENEMY_NAME.TEACHER1, "rt_outland_n_0009")
	TppEnemy.SetSneakRoute( this.ENEMY_NAME.TEACHER2, "rt_outland_n_0010")
end

this.teacherRouteSet_caution = function()
	TppEnemy.SetCautionRoute( this.ENEMY_NAME.TEACHER1, "rts_outland_c_0000")
	TppEnemy.SetCautionRoute( this.ENEMY_NAME.TEACHER2, "rts_outland_c_0000")
end


this.childRouteSet_training_day = function()
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD1, "rts_outland_d_0002")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD2, "rts_outland_d_0003")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD3, "rts_outland_d_0004")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD4, "rts_outland_d_0005")	
end
this.childRouteSet_training_night = function()
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD1, "rts_outland_n_0002")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD2, "rts_outland_n_0003")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD3, "rts_outland_n_0004")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD4, "rts_outland_n_0005")	
end

this.childRouteSet_normal_day = function()
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD1, "rts_outland_n_0002")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD2, "rts_outland_n_0003")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD3, "rts_outland_n_0004")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD4, "rts_outland_n_0005")	
end

this.childRouteSet_caution = function()
	TppEnemy.SetCautionRoute( this.CHILD_NAME.CHILD1, "rts_outland_c_0002")
	TppEnemy.SetCautionRoute( this.CHILD_NAME.CHILD2, "rts_outland_c_0003")
	TppEnemy.SetCautionRoute( this.CHILD_NAME.CHILD3, "rts_outland_c_0004")
	TppEnemy.SetCautionRoute( this.CHILD_NAME.CHILD4, "rts_outland_c_0005")	
end
this.childRouteSet_alert = function()
	TppEnemy.SetAlertRoute( this.CHILD_NAME.CHILD1, "rts_outland_c_0002")
	TppEnemy.SetAlertRoute( this.CHILD_NAME.CHILD2, "rts_outland_c_0003")
	TppEnemy.SetAlertRoute( this.CHILD_NAME.CHILD3, "rts_outland_c_0004")
	TppEnemy.SetAlertRoute( this.CHILD_NAME.CHILD4, "rts_outland_c_0005")	
end
this.childRouteSet_Escape = function()
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD1, "rts_outland_c_0002")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD2, "rts_outland_c_0003")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD3, "rts_outland_c_0004")
	TppEnemy.SetSneakRoute( this.CHILD_NAME.CHILD4, "rts_outland_c_0005")	
end

this.childRouteSet_check  = function()
	if TppClock.GetTimeOfDay() == "day" then
		Fox.Log("s10080:childRouteSet_training_day")
		this.childRouteSet_training_day()
		this.teacherRouteSet_training_day()
	else
		Fox.Log("s10080:childRouteSet_training_night")
		this.teacherRouteSet_training_night()
		this.childRouteSet_training_night()
	end
end


this.RegistHoldRecoveredStateForMissionTask = function( targetList )
	Fox.Log("###*** MissionTask register beginning ***")
	for index, targetName in pairs(targetList) do
		TppEnemy.RegistHoldRecoveredState( targetName )
	end
end




this.combatSetting = {
	mafr_flowStation_cp = {
		combatAreaList = {
			area1 = {
				{ guardTargetName = "gts_flowStation_pump", locatorSetName = "cs_flowStation_pump", },
			},
			area2 = {
				{ guardTargetName = "gts_flowStation_tank", locatorSetName = "cs_flowStation_tank", },
			},
		}
	},
	mafr_outland_cp = {
		"gts_outland_0000", 
		"cs_outland_f01",
	},
	mafr_outlandEast_ob = {
		USE_COMMON_COMBAT = true,
	},
	mafr_outlandNorth_ob = {
		USE_COMMON_COMBAT = true,
	},
	mafr_swampWest_ob = {
		USE_COMMON_COMBAT = true,
	},
	nil
}





this.SpawnVehicleOnInitialize = function()
	Fox.Log("*** SetVehicleSpawn ***")
	TppEnemy.SpawnVehicles( this.VEHICLE_SPAWN_LIST )
end


this.InitEnemy = function ()

	
	TppEnemy.NoShifhtChangeGruopSetting( "mafr_outland_cp", "teacherA" )
	TppEnemy.NoShifhtChangeGruopSetting( "mafr_outland_cp", "teacherB" )
	
end



this.SetUpEnemy = function ()
	Fox.Log("*** s10080 SetUpEnemy ***")
	







	TppEnemy.AssignUniqueStaffType{
		locaterName = this.ENEMY_NAME.TEACHER2,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10080_ENGINEER,
		alreadyExistParam = { staffTypeId =3, randomRangeId =6, skill ="HaulageEngineer" },
	}
	
	TppEnemy.RegisterCombatSetting( this.combatSetting )

	
	this.reinforcement_normal()
	
	
	this.setupRace_black()
	this.setupRace_white()	
	
	
	this.childRouteSet_check()
	this.teacherRouteSet_caution()
	this.childRouteSet_caution()
	this.childRouteSet_alert()
	
	if TppPackList.IsMissionPackLabel( "afterPumpStopDemo" ) then

		
		local targetList = {
			this.WALKERGEAR_NAME.WALKERGEAR1,
			this.WALKERGEAR_NAME.WALKERGEAR2,
			this.WALKERGEAR_NAME.WALKERGEAR3,
			this.WALKERGEAR_NAME.WALKERGEAR4,			
		}
		this.RegistHoldRecoveredStateForMissionTask( targetList )	
		
		this.reinforcement_ready()
	else
		
		this.setupChild()
		
		this.SwitchEnableCpSoldiers(this.REINFORCEMENT_LIST,false)
		
		
		local targetList = {
			
			this.CHILD_NAME.CHILD1,
			this.CHILD_NAME.CHILD2,	
			this.CHILD_NAME.CHILD3,	
			this.CHILD_NAME.CHILD4,
		}
		this.RegistHoldRecoveredStateForMissionTask( targetList )
		
	end

end


this.OnLoad = function ()
	Fox.Log("*** s10080 onload ***")
end




return this
