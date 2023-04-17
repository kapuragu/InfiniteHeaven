local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}


this.cpList = {}










this.MAX_SOLDIER_STATE_COUNT = 360


this.USE_COMMON_REINFORCE_PLAN = true


this.soldierPowerSettings = {
	sol_quest_0004 = { "SNIPER" },
	sol_quest_0005 = { "SNIPER" },
	sol_quest_0006 = { "SHIELD" },
	sol_quest_0007 = { "MISSILE" },
}






this.VEHICLE_SPAWN_LIST = {
	
	{	
		id = "Spawn",
		locator = "veh_lv_0000",	type = Vehicle.type.WESTERN_LIGHT_VEHICLE,
		paintType = Vehicle.paintType.FOVA_1
	},
	{	
		id = "Spawn",
		locator = "veh_lv_0001",	type = Vehicle.type.WESTERN_LIGHT_VEHICLE,
		paintType = Vehicle.paintType.FOVA_1
	},
	{	
		id = "Spawn",
		locator = "veh_lv_0002",	type = Vehicle.type.WESTERN_LIGHT_VEHICLE,
		paintType = Vehicle.paintType.FOVA_1
	},
	{	
		id = "Spawn",
		locator = "veh_lv_0003",	type = Vehicle.type.WESTERN_LIGHT_VEHICLE,
		paintType = Vehicle.paintType.FOVA_1
	},
	{	
		id = "Spawn",
		locator = "veh_lv_0004",	type = Vehicle.type.WESTERN_LIGHT_VEHICLE,
		paintType = Vehicle.paintType.FOVA_1
	},
	{	
		id = "Spawn",
		locator = "veh_lv_0005",	type = Vehicle.type.WESTERN_LIGHT_VEHICLE,
		paintType = Vehicle.paintType.FOVA_0
	},
	{	
		id = "Spawn",
		locator = "veh_lv_0006",	type = Vehicle.type.WESTERN_LIGHT_VEHICLE,
		paintType = Vehicle.paintType.FOVA_0
	},
	{	
		id = "Spawn",
		locator = "veh_lv_0007",	type = Vehicle.type.WESTERN_LIGHT_VEHICLE,
		paintType = Vehicle.paintType.FOVA_0
	},
	{	
		id = "Spawn",
		locator = "veh_lv_0008",	type = Vehicle.type.WESTERN_LIGHT_VEHICLE,
		paintType = Vehicle.paintType.FOVA_2
	},
	{	
		id = "Spawn",
		locator = "veh_lv_0009",	type = Vehicle.type.WESTERN_LIGHT_VEHICLE,
		paintType = Vehicle.paintType.FOVA_0
	},
	{	
		id = "Spawn",
		locator = "veh_lv_0010",	type = Vehicle.type.WESTERN_LIGHT_VEHICLE,
		paintType = Vehicle.paintType.FOVA_0
	},
	
	{	
		id = "Spawn",
		locator = "veh_trc_0000",	type = Vehicle.type.WESTERN_TRUCK,	subType = Vehicle.subType.WESTERN_TRUCK_CARGO_ITEM_BOX,
		paintType = Vehicle.paintType.FOVA_1
	},
	{	
		id = "Spawn",
		locator = "veh_trc_0001",	type = Vehicle.type.WESTERN_TRUCK,	subType = Vehicle.subType.WESTERN_TRUCK_CARGO_ITEM_BOX,
		paintType = Vehicle.paintType.FOVA_1
	},
	{	
		id = "Spawn",
		locator = "veh_trc_0002",	type = Vehicle.type.WESTERN_TRUCK,	subType = Vehicle.subType.WESTERN_TRUCK_CARGO_ITEM_BOX,
		paintType = Vehicle.paintType.FOVA_1
	},
	{	
		id = "Spawn",
		locator = "veh_trc_0003",	type = Vehicle.type.WESTERN_TRUCK,	subType = Vehicle.subType.WESTERN_TRUCK_CARGO_CONTAINER,
		paintType = Vehicle.paintType.FOVA_1
	},
	{	
		id = "Spawn",
		locator = "veh_trc_0004",	type = Vehicle.type.WESTERN_TRUCK,	subType = Vehicle.subType.WESTERN_TRUCK_CARGO_CONTAINER,
		paintType = Vehicle.paintType.FOVA_0
	},
	{	
		id = "Spawn",
		locator = "veh_trc_0005",	type = Vehicle.type.WESTERN_TRUCK,	subType = Vehicle.subType.WESTERN_TRUCK_CARGO_CISTERN,
		paintType = Vehicle.paintType.FOVA_0
	},
	{	
		id = "Spawn",
		locator = "veh_trc_0006",	type = Vehicle.type.WESTERN_TRUCK,	subType = Vehicle.subType.WESTERN_TRUCK_CARGO_CISTERN,
		paintType = Vehicle.paintType.FOVA_2
	},
	{	
		id = "Spawn",
		locator = "veh_trc_0007",	type = Vehicle.type.WESTERN_TRUCK,
		paintType = Vehicle.paintType.FOVA_0
	},
	{	
		id = "Spawn",
		locator = "veh_trc_0008",	type = Vehicle.type.WESTERN_TRUCK,	subType = Vehicle.subType.WESTERN_TRUCK_CARGO_ITEM_BOX,
		paintType = Vehicle.paintType.FOVA_1
	},
	{	
		id = "Spawn",
		locator = "veh_trc_0009",	type = Vehicle.type.WESTERN_TRUCK,	subType = Vehicle.subType.WESTERN_TRUCK_CARGO_CONTAINER,
		paintType = Vehicle.paintType.FOVA_1
	},
}


this.vehicleDefine = { instanceCount = 2 + 10 + 11 + 1 }--NMC: Quest + Truck + Jeep + Player





this.soldierDefine = {

	
	
	

	
	mafr_outland_cp = {
		"sol_outland_0000",
		"sol_outland_0001",
		"sol_outland_0002",
		"sol_outland_0003",
		"sol_outland_0004",
		"sol_outland_0005",
		"sol_outland_0006",
		"sol_outland_0007",
		"sol_outland_0008",
		"sol_outland_0009",
		"sol_outland_0010",
		"sol_outland_0011",
		nil
	},

	
	
	

	
	mafr_outlandEast_ob = {
		"sol_outlandEast_0000",
		"sol_outlandEast_0001",
		"sol_outlandEast_0002",
		"sol_outlandEast_0003",
		"sol_outlandEast_0004",
		"sol_outlandEast_0005",
		nil
	},

	
	mafr_outlandNorth_ob = {
		"sol_outlandNorth_0000",
		"sol_outlandNorth_0001",
		"sol_outlandNorth_0002",
		"sol_outlandNorth_0003",
		"sol_outlandNorth_0004",
		"sol_outlandNorth_0005",
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
		nil
	},

	
	mafr_pfCamp_cp = {
		"sol_pfCamp_0000",
		"sol_pfCamp_0001",
		"sol_pfCamp_0002",
		"sol_pfCamp_0003",
		"sol_pfCamp_0004",
		"sol_pfCamp_0005",
		"sol_pfCamp_0006",
		"sol_pfCamp_0007",
		"sol_pfCamp_0008",
		"sol_pfCamp_0009",
		"sol_pfCamp_0010",
		"sol_pfCamp_0011",
		nil
	},

	
	mafr_savannah_cp = {
		"sol_savannah_0000",
		"sol_savannah_0001",
		"sol_savannah_0002",
		"sol_savannah_0003",
		"sol_savannah_0004",
		"sol_savannah_0005",
		"sol_savannah_0006",
		"sol_savannah_0007",
		"sol_savannah_0008",
		"sol_savannah_0009",
		"sol_savannah_0010",
		"sol_savannah_0011",
		nil
	},

	
	mafr_swamp_cp = {
		"sol_swamp_0000",
		"sol_swamp_0001",
		"sol_swamp_0002",
		"sol_swamp_0003",
		"sol_swamp_0004",
		"sol_swamp_0005",
		"sol_swamp_0006",
		"sol_swamp_0007",
		"sol_swamp_0008",
		"sol_swamp_0009",
		"sol_swamp_0010",
		"sol_swamp_0011",
		nil
	},

	
	
	

	
	mafr_chicoVilWest_ob = {
		"sol_chicoVilWest_0000",
		"sol_chicoVilWest_0001",
		"sol_chicoVilWest_0002",
		"sol_chicoVilWest_0003",
		"sol_chicoVilWest_0004",
		"sol_chicoVilWest_0005",
		nil
	},

	
	mafr_hillSouth_ob = {
		"sol_hillSouth_0000",
		"sol_hillSouth_0001",
		"sol_hillSouth_0002",
		"sol_hillSouth_0003",
		"sol_hillSouth_0004",
		"sol_hillSouth_0005",
		nil
	},

	
	mafr_pfCampEast_ob = {
		"sol_pfCampEast_0000",
		"sol_pfCampEast_0001",
		"sol_pfCampEast_0002",
		"sol_pfCampEast_0003",
		"sol_pfCampEast_0004",
		"sol_pfCampEast_0005",
		nil
	},

	
	mafr_pfCampNorth_ob = {
		"sol_pfCampNorth_0000",
		"sol_pfCampNorth_0001",
		"sol_pfCampNorth_0002",
		"sol_pfCampNorth_0003",
		"sol_pfCampNorth_0004",
		"sol_pfCampNorth_0005",
		nil
	},

	
	mafr_savannahEast_ob = {
		"sol_savannahEast_0000",
		"sol_savannahEast_0001",
		"sol_savannahEast_0002",
		"sol_savannahEast_0003",
		"sol_savannahEast_0004",
		"sol_savannahEast_0005",
		nil
	},

	
	mafr_savannahWest_ob = {
		"sol_savannahWest_0000",
		"sol_savannahWest_0001",
		"sol_savannahWest_0002",
		"sol_savannahWest_0003",
		"sol_savannahWest_0004",
	
		nil
	},

	
	mafr_swampEast_ob = {
		"sol_swampEast_0000",
		"sol_swampEast_0001",
		"sol_swampEast_0002",
		"sol_swampEast_0003",
		"sol_swampEast_0004",
		"sol_swampEast_0005",
		nil
	},

	
	mafr_swampSouth_ob = {
		"sol_swampSouth_0000",
		"sol_swampSouth_0001",
		"sol_swampSouth_0002",
		"sol_swampSouth_0003",
		"sol_swampSouth_0004",

		nil
	},

	
	mafr_swampWest_ob = {
		"sol_swampWest_0000",
		"sol_swampWest_0001",
		"sol_swampWest_0002",
		"sol_swampWest_0003",
		"sol_swampWest_0004",
		"sol_swampWest_0005",
		nil
	},

	
	
	

	
	mafr_banana_cp = {
		"sol_banana_0000",
		"sol_banana_0001",
		"sol_banana_0002",
		"sol_banana_0003",
		"sol_banana_0004",
		"sol_banana_0005",
		"sol_banana_0006",
		"sol_banana_0007",
		"sol_banana_0008",
		"sol_banana_0009",
		"sol_banana_0010",
		"sol_banana_0011",
		nil
	},

	
	mafr_diamond_cp = {
		"sol_diamond_0000",
		"sol_diamond_0001",
		"sol_diamond_0002",
		"sol_diamond_0003",
		"sol_diamond_0004",
		"sol_diamond_0005",
		"sol_diamond_0006",
		"sol_diamond_0007",
		"sol_diamond_0008",
		"sol_diamond_0009",
		"sol_diamond_0010",
		"sol_diamond_0011",
		nil
	},

	
	mafr_hill_cp = {
		"sol_hill_0000",
		"sol_hill_0001",
		"sol_hill_0002",
		"sol_hill_0003",
		"sol_hill_0004",
		"sol_hill_0005",
		"sol_hill_0006",
		"sol_hill_0007",
		"sol_hill_0008",
		"sol_hill_0009",
		"sol_hill_0010",
		"sol_hill_0011",
		nil
	},

	
	
	

	
	mafr_bananaEast_ob = {
		"sol_bananaEast_0000",
		"sol_bananaEast_0001",
		"sol_bananaEast_0002",
		"sol_bananaEast_0003",
		"sol_bananaEast_0004",

		nil
	},

	
	mafr_bananaSouth_ob = {
		"sol_bananaSouth_0000",
		"sol_bananaSouth_0001",
		"sol_bananaSouth_0002",
		"sol_bananaSouth_0003",
		"sol_bananaSouth_0004",
		"sol_bananaSouth_0005",
		nil
	},

	
	mafr_diamondNorth_ob = {
		"sol_diamondNorth_0000",
		"sol_diamondNorth_0001",
		"sol_diamondNorth_0002",
		"sol_diamondNorth_0003",
		"sol_diamondNorth_0004",
		"sol_diamondNorth_0005",
		nil
	},

	
	mafr_diamondSouth_ob = {
		"sol_diamondSouth_0000",
		"sol_diamondSouth_0001",
		"sol_diamondSouth_0002",
		"sol_diamondSouth_0003",
		"sol_diamondSouth_0004",
		"sol_diamondSouth_0005",
		nil
	},

	
	mafr_diamondWest_ob = {
		"sol_diamondWest_0000",
		"sol_diamondWest_0001",
		"sol_diamondWest_0002",
		"sol_diamondWest_0003",
		"sol_diamondWest_0004",
		"sol_diamondWest_0005",
		nil
	},

	
	mafr_factorySouth_ob = {
		"sol_factorySouth_0000",
		"sol_factorySouth_0001",
		"sol_factorySouth_0002",
		"sol_factorySouth_0003",
		"sol_factorySouth_0004",
		"sol_factorySouth_0005",
		nil
	},

	
	mafr_hillNorth_ob = {
		"sol_hillNorth_0000",
		"sol_hillNorth_0001",
		"sol_hillNorth_0002",
		"sol_hillNorth_0003",
		"sol_hillNorth_0004",
		"sol_hillNorth_0005",
		"sol_hillNorth_0006",
		"sol_hillNorth_0007",
		nil
	},

	
	mafr_hillWest_ob = {
		"sol_hillWest_0000",
		"sol_hillWest_0001",
		"sol_hillWest_0002",
		"sol_hillWest_0003",
		"sol_hillWest_0004",
		"sol_hillWest_0005",
		nil
	},

	
	mafr_hillWestNear_ob = {
		"sol_hillWestNear_0000",
		"sol_hillWestNear_0001",
		"sol_hillWestNear_0002",
		"sol_hillWestNear_0003",
		"sol_hillWestNear_0004",
		"sol_hillWestNear_0005",
		nil
	},

	
	mafr_savannahNorth_ob = {
		"sol_savannahNorth_0000",
		"sol_savannahNorth_0001",
		"sol_savannahNorth_0002",
		"sol_savannahNorth_0003",
		"sol_savannahNorth_0004",

		nil
	},

	
	
	

	
	mafr_factory_cp = {
		nil
	},

	
	
	

	
	mafr_factoryWest_ob = {
		"sol_factoryWest_0000",
		"sol_factoryWest_0001",
		"sol_factoryWest_0002",
		"sol_factoryWest_0003",
		"sol_factoryWest_0004",
		"sol_factoryWest_0005",
	},

	
	
	

	
	mafr_lab_cp = {
		"sol_lab_0000",
		"sol_lab_0001",
		"sol_lab_0002",
		"sol_lab_0003",
		"sol_lab_0004",
		"sol_lab_0005",
		"sol_lab_0006",
		"sol_lab_0007",
		"sol_lab_0008",
		"sol_lab_0009",
		"sol_lab_0010",
		"sol_lab_0011",
		nil
	},

	
	
	

	
	mafr_labWest_ob = {
		"sol_labWest_0000",
		"sol_labWest_0001",
		"sol_labWest_0002",
		"sol_labWest_0003",
		"sol_labWest_0004",

		nil
	},

	
	
	

	mafr_01_20_lrrp = {
	},

	mafr_02_21_lrrp = {
		"sol_02_21_0000",
		"sol_02_21_0001",
		lrrpTravelPlan	= "travelArea2_02",
		lrrpVehicle		= "veh_trc_0001",
	},

	mafr_02_22_lrrp = {
		nil,
	},

	mafr_03_20_lrrp = {
		"sol_03_20_0000",
		"sol_03_20_0001",
		lrrpTravelPlan	= "travelArea1_01",
		lrrpVehicle		= "veh_trc_0000",
	},

	mafr_04_09_lrrp = {
		nil,
	},

	mafr_04_25_lrrp = {
		nil,
	},

	mafr_05_16_lrrp = {
		nil,
	},

	mafr_05_22_lrrp = {
		nil,
	},

	mafr_05_23_lrrp = {
		nil,
	},

	mafr_06_16_lrrp = {
		nil,
	},

	mafr_06_22_lrrp = {
		"sol_06_22_0000",
		"sol_06_22_0001",
		lrrpTravelPlan	= "travelArea2_03",
		lrrpVehicle		= "veh_trc_0002",
	},

	mafr_06_24_lrrp = {
		nil,
	},

	mafr_08_10_lrrp = {
		nil,
	},

	mafr_08_25_lrrp = {
		"sol_08_25_0000",
		"sol_08_25_0001",
		lrrpTravelPlan	= "travelArea3_01",
		lrrpVehicle		= "veh_trc_0005",
	},

	mafr_09_25_lrrp = {
		nil,
	},

	mafr_10_11_lrrp = {
		nil,
	},

	mafr_10_26_lrrp = {
		nil,
	},

	mafr_11_12_lrrp = {
		nil,
	},

	mafr_12_14_lrrp = {
		nil,
	},

	mafr_13_15_lrrp = {
		nil,
	},

	mafr_13_16_lrrp = {
		nil,
	},

	mafr_13_24_lrrp = {
		nil,
	},

	mafr_14_27_lrrp = {
		"sol_14_27_0000",
		"sol_14_27_0001",
		lrrpTravelPlan	= "travelArea3_02",
		lrrpVehicle		= "veh_trc_0004",
	},

	mafr_15_16_lrrp = {
		nil,
	},

	mafr_15_23_lrrp = {
		"sol_15_23_0000",
		"sol_15_23_0001",
		lrrpTravelPlan	= "travelArea2_01",
		lrrpVehicle		= "veh_trc_0003",
	},

	mafr_15_31_lrrp = {
		nil,
	},

	mafr_16_23_lrrp = {
		nil,
	},

	mafr_16_24_lrrp = {
		nil,
	},

	mafr_17_27_lrrp = {
		nil,
	},

	mafr_18_26_lrrp = {
		nil,
	},

	mafr_19_29_lrrp = {
		"sol_19_29_0000",
		"sol_19_29_0001",
		lrrpTravelPlan	= "travelArea5_01",
		lrrpVehicle		= "veh_trc_0006",
	},

	mafr_23_33_lrrp = {
		nil,
	},

	mafr_27_30_lrrp = {
		nil,
	},

	mafr_31_33_lrrp = {
		nil,
	},

	
	
	
	quest_cp = {
		"sol_quest_0000",
		"sol_quest_0001",
		"sol_quest_0002",
		"sol_quest_0003",
		"sol_quest_0004",
		"sol_quest_0005",
		"sol_quest_0006",
		"sol_quest_0007",
		nil
	},

	nil
}





this.routeSets = {

	
	
	

	
	mafr_outland_cp				= { USE_COMMON_ROUTE_SETS = true, },

	
	
	

	
	mafr_outlandEast_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_outlandNorth_ob		= { USE_COMMON_ROUTE_SETS = true, },

	
	
	

	
	mafr_flowStation_cp			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_pfCamp_cp				= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_savannah_cp			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_swamp_cp				= { USE_COMMON_ROUTE_SETS = true, },

	
	
	

	
	mafr_chicoVilWest_ob		= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_hillSouth_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_pfCampEast_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_pfCampNorth_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_savannahEast_ob		= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_savannahWest_ob		= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_swampEast_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_swampSouth_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_swampWest_ob			= { USE_COMMON_ROUTE_SETS = true, },

	
	
	

	
	mafr_banana_cp				= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_diamond_cp				= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_hill_cp				= { USE_COMMON_ROUTE_SETS = true, },

	
	
	

	
	mafr_bananaEast_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_bananaSouth_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_diamondNorth_ob		= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_diamondSouth_ob		= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_diamondWest_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_factorySouth_ob		= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_hillNorth_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_hillWest_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_hillWestNear_ob		= { USE_COMMON_ROUTE_SETS = true, },
	
	--DUPLICATE: mafr_hillSouth_ob			= { USE_COMMON_ROUTE_SETS = true, },
	
	mafr_savannahNorth_ob		= { USE_COMMON_ROUTE_SETS = true, },

	
	
	

	
	mafr_factory_cp				= { USE_COMMON_ROUTE_SETS = true, },

	
	
	

	
	mafr_factoryWest_ob			= { USE_COMMON_ROUTE_SETS = true, },

	
	
	

	
	mafr_lab_cp					= { USE_COMMON_ROUTE_SETS = true, },

	
	
	

	
	mafr_labWest_ob				= { USE_COMMON_ROUTE_SETS = true, },

	
	
	

	mafr_01_20_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_02_21_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_02_22_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_03_20_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_04_09_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_04_25_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_05_16_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_05_22_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_05_23_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_06_16_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_06_22_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_06_24_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_08_10_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_08_25_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_09_25_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_10_11_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_10_26_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_11_12_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_12_14_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_13_15_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_13_16_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_13_24_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_14_27_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_15_16_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_15_23_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_15_31_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_16_23_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_16_24_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_17_27_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_18_26_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_19_29_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_23_33_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_27_30_lrrp				= { USE_COMMON_ROUTE_SETS = true, },
	mafr_31_33_lrrp				= { USE_COMMON_ROUTE_SETS = true, },

	
	
	

	
	quest_cp					= { USE_COMMON_ROUTE_SETS = true, },

	nil
}





this.travelPlans = {

	

	travelArea1_01 = {--trc 0000
		{ cp="mafr_03_20_lrrp",			routeGroup={ "travel", "lrrp_20to03" }, },
		{ cp="mafr_outlandEast_ob",		routeGroup={ "travel", 					"in_lrrpHold_S" }, },
		{ cp="mafr_outlandEast_ob",		routeGroup={ "travel", 					"out_lrrpHold_B01" }, },
		{ cp="mafr_outlandEast_ob",		routeGroup={ "travel", 					"out_lrrpHold_B02" }, },
		{ cp="mafr_outlandEast_ob",		routeGroup={ "travel", 					"out_lrrpHold_B03" }, },
		{ cp="mafr_03_20_lrrp",			routeGroup={ "travel", "lrrp_03to20" }, },
		{ cp="mafr_outland_cp",			routeGroup={ "travel", 					"in_lrrpHold_S" }, },
		{ cp="mafr_outland_cp",			routeGroup={ "travel", "lrrpHold" }, },
		{ cp="mafr_outland_cp",			routeGroup={ "travel", 					"out_lrrpHold_N" }, },
		{ cp="mafr_01_20_lrrp",			routeGroup={ "travel", "lrrp_20to01" }, },
		{ cp="mafr_outlandNorth_ob",	routeGroup={ "travel", 					"in_lrrpHold_S" }, },
		{ cp="mafr_outlandNorth_ob",	routeGroup={ "travel", 					"out_lrrpHold_B01" }, },
		{ cp="mafr_outlandNorth_ob",	routeGroup={ "travel", 					"out_lrrpHold_B02" }, },
		{ cp="mafr_outlandNorth_ob",	routeGroup={ "travel", 					"out_lrrpHold_B03" }, },
		{ cp="mafr_01_20_lrrp",			routeGroup={ "travel", "lrrp_01to20" }, },
		{ cp="mafr_outland_cp",			routeGroup={ "travel", 					"in_lrrpHold_N" }, },
		{ cp="mafr_outland_cp",			routeGroup={ "travel", 					"out_lrrpHold_S" }, },
	},

	

	travelArea2_01 = {--veh_trc_0003
		{ cp="mafr_15_23_lrrp",			routeGroup={ "travel", "lrrp_23to15_01" }, },
		{ cp="mafr_pfCampEast_ob",		routeGroup={ "travel", 					"in_lrrpHold_E" }, },
		{ cp="mafr_pfCampEast_ob",		routeGroup={ "travel", 					"out_lrrpHold_B01" }, },
		{ cp="mafr_pfCampEast_ob",		routeGroup={ "travel", 					"out_lrrpHold_B02" }, },
		{ cp="mafr_15_23_lrrp",			routeGroup={ "travel", "lrrp_15to23" }, },
		{ cp="mafr_pfCamp_cp",			routeGroup={ "travel", 					"in_lrrpHold_S" }, },
		{ cp="mafr_pfCamp_cp",			routeGroup={ "travel", "lrrpHold" }, },
		{ cp="mafr_pfCamp_cp",			routeGroup={ "travel", 					"out_lrrpHold_S" }, },
	},

	travelArea2_02 = {--veh_trc_0001
		{ cp="mafr_02_21_lrrp",			routeGroup={ "travel", "lrrp_02to21" }, },
		{ cp="mafr_flowStation_cp",		routeGroup={ "travel", 					"in_lrrpHold_W" }, },
		{ cp="mafr_flowStation_cp",		routeGroup={ "travel", "lrrpHold" }, },
		{ cp="mafr_flowStation_cp",		routeGroup={ "travel", 					"out_lrrpHold_B01" }, },
		{ cp="mafr_flowStation_cp",		routeGroup={ "travel", 					"out_lrrpHold_B02" }, },
		{ cp="mafr_02_21_lrrp",			routeGroup={ "travel", "lrrp_21to02" }, },
		{ cp="mafr_swampWest_ob",		routeGroup={ "travel", 					"in_lrrpHold_N" }, },
		{ cp="mafr_swampWest_ob",		routeGroup={ "travel", 					"out_lrrpHold_S" }, },
		{ cp="mafr_02_22_lrrp",			routeGroup={ "travel", "lrrp_02to22" }, },
		{ cp="mafr_swamp_cp",			routeGroup={ "travel", 					"in_lrrpHold_N" }, },
		{ cp="mafr_swamp_cp",			routeGroup={ "travel", "lrrpHold_01" }, },
		{ cp="mafr_swamp_cp",			routeGroup={ "travel", 					"out_lrrpHold_B01" }, },
		{ cp="mafr_swamp_cp",			routeGroup={ "travel", 					"out_lrrpHold_B02" }, },
		{ cp="mafr_02_22_lrrp",			routeGroup={ "travel", "lrrp_22to02" }, },
		{ cp="mafr_swampWest_ob",		routeGroup={ "travel", 					"in_lrrpHold_S" }, },
		{ cp="mafr_swampWest_ob",		routeGroup={ "travel", 					"out_lrrpHold_N" }, },
	},

	travelArea2_03 = {--veh_trc_0002
		{ cp="mafr_06_22_lrrp",			routeGroup={ "travel", "lrrp_22to06" }, },
		{ cp="mafr_swampEast_ob",		routeGroup={ "travel", 					"in_lrrpHold_W" }, },
		{ cp="mafr_swampEast_ob",		routeGroup={ "travel", 					"out_lrrpHold_E" }, },
		{ cp="mafr_06_24_lrrp",			routeGroup={ "travel", "lrrp_06to24" }, },
		{ cp="mafr_savannah_cp",		routeGroup={ "travel", 					"in_lrrpHold_W" }, },
		{ cp="mafr_savannah_cp",		routeGroup={ "travel", "lrrpHold" }, },
		{ cp="mafr_savannah_cp",		routeGroup={ "travel", 					"in_lrrpHold_E" }, },
		{ cp="mafr_13_24_lrrp",			routeGroup={ "travel", "lrrp_24to13" }, },
		{ cp="mafr_savannahEast_ob",	routeGroup={ "travel", 					"in_lrrpHold_N" }, },
		{ cp="mafr_savannahEast_ob",	routeGroup={ "travel", 					"out_lrrpHold_W" }, },
		{ cp="mafr_13_16_lrrp",			routeGroup={ "travel", "lrrp_13to16" }, },
		{ cp="mafr_pfCampNorth_ob",		routeGroup={ "travel", 					"in_lrrpHold_E" }, },
		{ cp="mafr_pfCampNorth_ob",		routeGroup={ "travel", 					"out_lrrpHold_W" }, },
		{ cp="mafr_06_16_lrrp",			routeGroup={ "travel", "lrrp_16to06" }, },
		{ cp="mafr_swampEast_ob",		routeGroup={ "travel", 					"in_lrrpHold_E" }, },
		{ cp="mafr_swampEast_ob",		routeGroup={ "travel", 					"out_lrrpHold_W" }, },
		{ cp="mafr_06_22_lrrp",			routeGroup={ "travel", "lrrp_06to22" }, },
		{ cp="mafr_swamp_cp",			routeGroup={ "travel", 					"in_lrrpHold_E" }, },
		{ cp="mafr_swamp_cp",			routeGroup={ "travel", "lrrpHold" }, },
		{ cp="mafr_swamp_cp",			routeGroup={ "travel", 					"out_lrrpHold_B03" }, },
		{ cp="mafr_swamp_cp",			routeGroup={ "travel", 					"out_lrrpHold_B04" }, },
	},

	

	travelArea3_01 = {--veh_trc_0005
		{ cp="mafr_08_25_lrrp",			routeGroup={ "travel", "lrrp_25to08" }, },
		{ cp="mafr_bananaEast_ob",		routeGroup={ "travel", 					"in_lrrpHold_N" }, },
		{ cp="mafr_bananaEast_ob",		routeGroup={ "travel", 					"out_lrrpHold_S" }, },
		{ cp="mafr_08_10_lrrp",			routeGroup={ "travel", "lrrp_08to10" }, },
		{ cp="mafr_diamondWest_ob",		routeGroup={ "travel", 					"in_lrrpHold_S" }, },
		{ cp="mafr_diamondWest_ob",		routeGroup={ "travel", 					"out_lrrpHold_N" }, },
		{ cp="mafr_10_26_lrrp",			routeGroup={ "travel", "lrrp_10to26" }, },
		{ cp="mafr_diamond_cp",			routeGroup={ "travel", 					"in_lrrpHold_S" }, },
		{ cp="mafr_diamond_cp",			routeGroup={ "travel", "lrrpHold" }, },
		{ cp="mafr_diamond_cp",			routeGroup={ "travel", 					"out_lrrpHold_B01" }, },
		{ cp="mafr_diamond_cp",			routeGroup={ "travel", 					"out_lrrpHold_B02" }, },
		{ cp="mafr_diamond_cp",			routeGroup={ "travel", 					"out_lrrpHold_B03" }, },
		{ cp="mafr_10_26_lrrp",			routeGroup={ "travel", "lrrp_26to10" }, },
		{ cp="mafr_diamondWest_ob",		routeGroup={ "travel", 					"in_lrrpHold_N" }, },
		{ cp="mafr_diamondWest_ob",		routeGroup={ "travel", 					"out_lrrpHold_S" }, },
		{ cp="mafr_08_10_lrrp",			routeGroup={ "travel", "lrrp_10to08" }, },
		{ cp="mafr_bananaEast_ob",		routeGroup={ "travel", 					"in_lrrpHold_S" }, },
		{ cp="mafr_bananaEast_ob",		routeGroup={ "travel", 					"out_lrrpHold_N" }, },
		{ cp="mafr_08_25_lrrp",			routeGroup={ "travel", "lrrp_08to25" }, },
		{ cp="mafr_banana_cp",			routeGroup={ "travel", 					"in_lrrpHold_N" }, },
		{ cp="mafr_banana_cp",			routeGroup={ "travel", "lrrpHold" }, },
		{ cp="mafr_banana_cp",			routeGroup={ "travel", 					"out_lrrpHold_B01" }, },
		{ cp="mafr_banana_cp",			routeGroup={ "travel", 					"out_lrrpHold_B02" }, },
	},

	travelArea3_02 = {--veh_trc_0004
		{ cp="mafr_14_27_lrrp",			routeGroup={ "travel", "lrrp_27to14" }, },
		{ cp="mafr_hillWest_ob",		routeGroup={ "travel", 					"in_lrrpHold_S" }, },
		{ cp="mafr_hillWest_ob",		routeGroup={ "travel", 					"out_lrrpHold_N" }, },
		{ cp="mafr_12_14_lrrp",			routeGroup={ "travel", "lrrp_14to12" }, },
		{ cp="mafr_hillNorth_ob",		routeGroup={ "travel", 					"in_lrrpHold_S" }, },
		{ cp="mafr_hillNorth_ob",		routeGroup={ "travel", 					"out_lrrpHold_N" }, },
		{ cp="mafr_11_12_lrrp",			routeGroup={ "travel", "lrrp_12to11" }, },
		{ cp="mafr_diamondSouth_ob",	routeGroup={ "travel", 					"in_lrrpHold_W" }, },
		{ cp="mafr_diamondSouth_ob",	routeGroup={ "travel", "lrrpHold" }, },
		{ cp="mafr_diamondSouth_ob",	routeGroup={ "travel", 					"out_lrrpHold_B01" }, },
		{ cp="mafr_diamondSouth_ob",	routeGroup={ "travel", 					"out_lrrpHold_B02" }, },
		{ cp="mafr_11_12_lrrp",			routeGroup={ "travel", "lrrp_11to12" }, },
		{ cp="mafr_hillNorth_ob",		routeGroup={ "travel", 					"in_lrrpHold_N" }, },
		{ cp="mafr_hillNorth_ob",		routeGroup={ "travel", 					"out_lrrpHold_S" }, },
		{ cp="mafr_12_14_lrrp",			routeGroup={ "travel", "lrrp_12to14" }, },
		{ cp="mafr_hillWest_ob",		routeGroup={ "travel", 					"in_lrrpHold_N" }, },
		{ cp="mafr_hillWest_ob",		routeGroup={ "travel", 					"out_lrrpHold_S" }, },
		{ cp="mafr_14_27_lrrp",			routeGroup={ "travel", "lrrp_14to27" }, },
		{ cp="mafr_hill_cp",			routeGroup={ "travel", 					"in_lrrpHold_S" }, },
		{ cp="mafr_hill_cp",			routeGroup={ "travel", "lrrpHold" }, },
		{ cp="mafr_hill_cp",			routeGroup={ "travel", 					"out_lrrpHold_B01" }, },
		{ cp="mafr_hill_cp",			routeGroup={ "travel", 					"out_lrrpHold_B02" }, },
	},

	

	

	travelArea5_01 = {--veh_trc_0006
		{ cp="mafr_19_29_lrrp",			routeGroup={ "travel", "lrrp_29to19" }, },
		{ cp="mafr_labWest_ob",			routeGroup={ "travel", 					"in_lrrpHold_W" }, },
		{ cp="mafr_labWest_ob",			routeGroup={ "travel", 					"out_lrrpHold_B01" }, },
		{ cp="mafr_labWest_ob",			routeGroup={ "travel", 					"out_lrrpHold_B02" }, },
		{ cp="mafr_labWest_ob",			routeGroup={ "travel", 					"out_lrrpHold_B03" }, },
		{ cp="mafr_19_29_lrrp",			routeGroup={ "travel", "lrrp_19to29" }, },
		{ cp="mafr_lab_cp",				routeGroup={ "travel", 					"in_lrrpHold_W" }, },
		{ cp="mafr_lab_cp",				routeGroup={ "travel", "lrrpHold" }, },
		{ cp="mafr_lab_cp",				routeGroup={ "travel", 					"out_lrrpHold_W" }, },
	},

}





this.combatSetting = {

	
	
	

	
	mafr_outland_cp				= { USE_COMMON_COMBAT = true, },

	
	
	

	
	mafr_outlandEast_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_outlandNorth_ob		= { USE_COMMON_COMBAT = true, },

	
	
	

	
	mafr_flowStation_cp			= { USE_COMMON_COMBAT = true, },
	
	mafr_pfCamp_cp				= { USE_COMMON_COMBAT = true, },
	
	mafr_savannah_cp			= { USE_COMMON_COMBAT = true, },
	
	mafr_swamp_cp				= { USE_COMMON_COMBAT = true, },

	
	
	

	
	mafr_chicoVilWest_ob		= { USE_COMMON_COMBAT = true, },
	
	mafr_hillSouth_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_pfCampEast_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_pfCampNorth_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_savannahEast_ob		= { USE_COMMON_COMBAT = true, },
	
	mafr_savannahWest_ob		= { USE_COMMON_COMBAT = true, },
	
	mafr_swampEast_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_swampSouth_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_swampWest_ob			= { USE_COMMON_COMBAT = true, },

	
	
	

	
	mafr_banana_cp				= { USE_COMMON_COMBAT = true, },
	
	mafr_diamond_cp				= { USE_COMMON_COMBAT = true, },
	
	mafr_hill_cp				= { USE_COMMON_COMBAT = true, },

	
	
	

	
	mafr_bananaEast_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_bananaSouth_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_diamondNorth_ob		= { USE_COMMON_COMBAT = true, },
	
	mafr_diamondSouth_ob		= { USE_COMMON_COMBAT = true, },
	
	mafr_diamondWest_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_factorySouth_ob		= { USE_COMMON_COMBAT = true, },
	
	mafr_hillNorth_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_hillWest_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_hillWestNear_ob		= { USE_COMMON_COMBAT = true, },
	
	--DUPLICATE: mafr_hillSouth_ob			= { USE_COMMON_COMBAT = true, },
	
	mafr_savannahNorth_ob		= { USE_COMMON_COMBAT = true, },

	
	
	

	
	mafr_factory_cp				= { USE_COMMON_COMBAT = true, },

	
	
	

	
	mafr_factoryWest_ob			= { USE_COMMON_COMBAT = true, },

	
	
	

	
	mafr_lab_cp					= { USE_COMMON_COMBAT = true, },

	
	
	

	
	mafr_labWest_ob				= { USE_COMMON_COMBAT = true, },

	nil
}





this.interrogation = {
	
	mafr_banana_cp = {nil},
	mafr_diamond_cp = {nil},
	mafr_factory_cp = {nil},
	mafr_flowStation_cp = {nil},
	mafr_hill_cp = {nil},
	mafr_lab_cp = {nil},
	mafr_outland_cp = {nil},
	mafr_pfCamp_cp = {nil},
	mafr_savannah_cp = {nil},
	mafr_swamp_cp = {nil},
	
	mafr_bananaEast_ob = {nil},
	mafr_bananaSouth_ob = {nil},
	mafr_chicoVilWest_ob = {nil},
	mafr_diamondNorth_ob = {nil},
	mafr_diamondSouth_ob = {nil},
	mafr_diamondWest_ob = {nil},
	mafr_factorySouth_ob = {nil},
	mafr_factoryWest_ob = {nil},
	mafr_hillNorth_ob = {nil},
	mafr_hillSouth_ob = {nil},
	mafr_hillWest_ob = {nil},
	mafr_hillWestNear_ob = {nil},
	mafr_labWest_ob = {nil},
	mafr_outlandEast_ob = {nil},
	mafr_outlandNorth_ob = {nil},
	mafr_pfCampEast_ob = {nil},
	mafr_pfCampNorth_ob = {nil},
	mafr_savannahEast_ob = {nil},
	mafr_savannahNorth_ob = {nil},
	mafr_savannahWest_ob = {nil},
	mafr_swampEast_ob = {nil},
	mafr_swampSouth_ob = {nil},
	mafr_swampWest_ob = {nil},

	quest_cp = {nil},
	nil
}


this.useGeneInter = {
	
	nil
}






this.SpawnVehicleOnInitialize = function()
	TppEnemy.SpawnVehicles( this.VEHICLE_SPAWN_LIST )
end


this.InitEnemy = function ()

end



this.SetUpEnemy = function ()
	Fox.Log("Set up enemy")
	TppEnemy.RegisterCombatSetting( this.combatSetting )

	
	local cpList = {
		mafr_cpGroups.group_Area1,
		mafr_cpGroups.group_Area2,
		mafr_cpGroups.group_Area3,
		mafr_cpGroups.group_Area4,
		mafr_cpGroups.group_Area5,
	}
	this.cpList = cpList

	


	
	TppEnemy.SetupQuestEnemy()

end


this.OnLoad = function ()
	Fox.Log("*** f30020 onload ***")
end






function this.UpdateOutOfAreaSetting( currentArea )
	Fox.Log("*** f30010 UpdateOutOfAreaSetting:currentArea::" .. currentArea )
	
	local currentCpList = this.cpList[ currentArea ]
	
	for cpName, soldiersInCp in pairs( this.soldierDefine ) do
		if currentCpList[cpName] or cpName == "quest_cp" then	
			TppEnemy.SetOutOfArea( soldiersInCp, false )
		else
			TppEnemy.SetOutOfArea( soldiersInCp, true )
		end
	end

end




return this
