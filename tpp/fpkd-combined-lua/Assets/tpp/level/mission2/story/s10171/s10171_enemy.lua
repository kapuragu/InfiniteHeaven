local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}


local IsTypeString = Tpp.IsTypeString
local NULL_ID = GameObject.NULL_ID

this.ENEMY_TANK1_SOLDIER = "sol_pfCamp_tank1"
this.ENEMY_TANK2_SOLDIER = "sol_pfCamp_tank2"
this.ENEMY_WAV_SOLDIER = "sol_pfCamp_wav"
this.ENEMY_WAV_ADD_SOLDIER = "sol_savannah_0004"
this.ENEMY_VIP = "sol_pfCamp_vip"

this.ENEMY_HELI = "EnemyHeli"
this.ENEMY_TANK1 = "veh_s10171_tank1"
this.ENEMY_TANK2 = "veh_s10171_tank2"
this.ENEMY_WAV = "veh_s10171_wav"
this.ENEMY_WAV_ADD = "veh_s10171_wav_add"


this.driverVehicleMatchIdTable = {}

this.INITIAL_CONVOY_LEAD = this.ENEMY_WAV
this.TRAVEL_TYPE = {
	SWAMP = 0,
	HILL =  1,
	SAVANNAH_SAVANNAH_EAST = 2,
	SAVANNAH_SWAMP_EAST = 3,
	SAVANNAH_EAST_PFCAMP = 4,
	SWAMP_EAST_PFCAMP = 5,
}


this.INTERROGATION_TYPE = {
	INTEL = "enqt1000_094538",		
	AIRPORT = "enqt1000_103726",	
	HELI = "enqt1000_103723",		
	GREAT = "enqt1000_103722",		
}





this.soldierPowerSettings = {
	
	sol_pfCamp_0000 = { "SNIPER" },
	sol_pfCamp_0001 = { "SNIPER" },
	sol_pfCamp_0002 = { "SNIPER" },
	sol_pfCamp_0003 = { "SNIPER" },
	
	sol_pfCamp_vip = {},
}


this.USE_COMMON_REINFORCE_PLAN = true





this.soldierDefine = {
	
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
		this.ENEMY_VIP,
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
	mafr_pfCampEast_ob = {
		"sol_pfCampEast_0000",
		"sol_pfCampEast_0001",
		"sol_pfCampEast_0002",
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
		nil
	},
	mafr_swampSouth_ob = {
		"sol_swampSouth_0000",
		"sol_swampSouth_0001",
		"sol_swampSouth_0002",
		"sol_swampSouth_0003",
		nil
	},
	mafr_swampEast_ob = {
		"sol_swampEast_0000",
		"sol_swampEast_0001",
		"sol_swampEast_0002",
		"sol_swampEast_0003",
		nil
	},
	mafr_swampWest_ob = {
		"sol_swampWest_0000",
		"sol_swampWest_0001",
		"sol_swampWest_0002",
		"sol_swampWest_0003",
		this.ENEMY_TANK1_SOLDIER,
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
		this.ENEMY_WAV_SOLDIER,
		this.ENEMY_TANK2_SOLDIER,
		nil
	},
	mafr_hillWest_ob = {
		"sol_hillWest_0000",
		"sol_hillWest_0001",
		"sol_hillWest_0002",
		"sol_hillWest_0003",
		nil
	},
	mafr_hillWestNear_ob = {
		"sol_hillWestNear_0000",
		"sol_hillWestNear_0001",
		"sol_hillWestNear_0002",
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
		nil
	},
	mafr_savannahEast_ob = {
		"sol_savannahEast_0000",
		"sol_savannahEast_0001",
		"sol_savannahEast_0002",
		"sol_savannahEast_0003",
		nil
	},
	
	mafr_02_22_lrrp = {
		nil,	
	},
	mafr_06_22_lrrp = {
		nil,	
	},
	mafr_06_16_lrrp = {
		nil,	
	},
	mafr_15_27_lrrp = {
		nil,	
	},
	mafr_13_15_lrrp = {
		nil,	
	},
	mafr_13_16_lrrp = {
		nil,	
	},
	mafr_16_23_lrrp = {
		nil,	
	},
	
	mafr_06_24_lrrp = {
		nil,
	},
	mafr_13_24_lrrp = {
		nil,
	},
	mafr_27_30_lrrp = {
		nil,
	},
	nil
}





this.routeSets = {
	
	
	mafr_pfCamp_cp = {
		USE_COMMON_ROUTE_SETS = true,
		priority = {
			"groupSniper",
			"groupA",
			"groupB",
			"groupC",
		},
		fixedShiftChangeGroup = {
			"groupSniper",          
		},
		sneak_day = {
			groupSniper = {
				{ "rt_pfCamp_snp_0000", attr = "SNIPER", },
				{ "rt_pfCamp_snp_0001", attr = "SNIPER", },
				{ "rt_pfCamp_snp_0002", attr = "SNIPER", },
				{ "rt_pfCamp_snp_0003", attr = "SNIPER", },
			},
			groupA = {
				"rts_pfCamp_d_0005",
				"rts_pfCamp_d_0004",
				"rts_pfCamp_d_0000",
				"rt_pfCamp_d_0008",
			},
			groupB = {
				"rts_pfCamp_d_0001",
				"rts_pfCamp_d_0007",
				"rts_pfCamp_d_0003",
				"rt_pfCamp_d_0009",
			},
			groupC = {
				"rts_pfCamp_d_0002",
				"rts_pfCamp_d_0006",
				"rt_pfCamp_d_0010",
				"rt_pfCamp_d_0011",
			},
		},
		sneak_night = {
			groupSniper = {
				{ "rt_pfCamp_snp_0000", attr = "SNIPER", },
				{ "rt_pfCamp_snp_0001", attr = "SNIPER", },
				{ "rt_pfCamp_snp_0002", attr = "SNIPER", },
				{ "rt_pfCamp_snp_0003", attr = "SNIPER", },
			},
			groupA = {
				"rts_pfCamp_n_0000",
				"rts_pfCamp_n_0002",
				"rts_pfCamp_n_0005",
				"rt_pfCamp_n_0007",
			},
			groupB = {
				"rts_pfCamp_n_0004_sub",
				"rts_pfCamp_n_0003",
				"rts_pfCamp_n_0007",
				"rt_pfCamp_n_0008",
			},
			groupC = {
				"rts_pfCamp_n_0001",
				"rts_pfCamp_n_0006",
				"rt_pfCamp_n_0009",
				"rt_pfCamp_n_0011",
			},
		},
		caution = {
			groupSniper = {
				{ "rt_pfCamp_snp_0000", attr = "SNIPER", },
				{ "rt_pfCamp_snp_0001", attr = "SNIPER", },
				{ "rt_pfCamp_snp_0002", attr = "SNIPER", },
				{ "rt_pfCamp_snp_0003", attr = "SNIPER", },
			},
			groupA = {
				"rts_pfCamp_c_0000",
				"rts_pfCamp_c_0001_sub",
				"rts_pfCamp_c_0002",
				"rts_pfCamp_c_0003",
				"rts_pfCamp_c_0004",
				"rts_pfCamp_c_0005",
				"rts_pfCamp_c_0006",
				"rts_pfCamp_c_0007",
				"rt_pfCamp_c_0002",
				"rt_pfCamp_c_0008",				
				"rt_pfCamp_c_0010",
				"rt_pfCamp_c_0011",
			},
			groupB = {},
			groupC = {},
		},
		travel = {
			lrrp_pfCampNorthToPfCamp = {
				"rts_veh_to_pfCamp_from_16_23_lrrp",
				"rts_veh_to_pfCamp_from_16_23_lrrp",
				"rts_veh_to_pfCamp_from_16_23_lrrp",
			},
			lrrp_savannahEastToPfCamp = {
				"rts_veh_16_23_lrrp_pfCamp_add",
			},
			lrrp_swampEastToPfCamp = {
				"rts_veh_16_23_lrrp_pfCamp_add2",
			},
		},
		nil
	},

	
	mafr_swamp_cp = {
		priority = {
			"groupSniper",		
			"groupA",
			"groupB",
			"groupC",
			"groupD",
			"groupE",
		},
		fixedShiftChangeGroup = {
			"groupSniper",		
		},
		sneak_day = {
			groupSniper = {
				{ "rt_swamp_snp_0000", attr = "SNIPER" },
				{ "rt_swamp_snp_0001", attr = "SNIPER" },
			},
			groupA = {
				"rt_swamp_d_0000",
				"rt_swamp_d_0015", 
				"rt_swamp_d_0011",
				"rt_SwampNear_d_0000",
			},
			groupB = {
				"rt_swamp_d_0001",
				"rt_swamp_d_0008",
				"rt_swamp_d_0012",
				"rt_SwampNear_d_0001",
			},
			groupC = {
				"rt_swamp_d_0002",
				"rt_swamp_d_0009",
				"rt_SwampNear_d_0002_no_watchtower_sub",
				"rt_SwampNear_d_0004",
			},
			groupD = {
				"rt_swamp_d_0003",
				"rt_swamp_d_0005",
				"rt_swamp_d_0010",
				"rt_swamp_d_0013",
			},
			groupE = {
				"rt_swamp_d_0004",
				"rt_swamp_d_0006",
				"rt_swamp_d_0014",
				"rt_SwampNear_d_0003",
			},
		},
		sneak_night = {
			groupSniper = {
				{ "rt_swamp_snp_0000", attr = "SNIPER" },
				{ "rt_swamp_snp_0001", attr = "SNIPER" },
			},
			groupA = {
				"rt_swamp_n_0000",
				"rt_swamp_n_0007",
				"rt_swamp_n_0011",
				"rt_SwampNear_n_0000_no_searchlight_sub",
			},
			groupB = {
				"rt_swamp_n_0001_no_searchlight_sub",
				"rt_swamp_n_0008_no_searchlight_sub",
				"rt_swamp_n_0012",
				"rt_SwampNear_n_0001_no_searchlight_sub",
			},
			groupC = {
				"rt_swamp_n_0002",
				"rt_swamp_n_0009_no_searchlight_sub",
				"rt_SwampNear_n_0002",
				"rt_SwampNear_n_0004",
			},
			groupD = {
				"rt_swamp_n_0003_no_searchlight_sub",
				"rt_swamp_n_0005_no_searchlight_sub",
				"rt_swamp_n_0010",
				"rt_swamp_n_0013",
			},
			groupE = {
				"rt_swamp_n_0004",
				"rt_swamp_n_0006",
				"rt_swamp_n_0014",
				"rt_SwampNear_n_0003",
			},
		},
		caution = {
			groupSniper = {
				{ "rt_swamp_snp_0000", attr = "SNIPER" },
				{ "rt_swamp_snp_0001", attr = "SNIPER" },
			},
			groupA = {
				"rt_swamp_c_0000",
				"rt_swamp_c_0001",
				"rt_swamp_c_0002",
				"rt_swamp_c_0003",
				"rt_swamp_c_0004_searchlight",
				"rt_swamp_c_0005",
				"rt_swamp_c_0006",
				"rt_swamp_c_0007",
				"rt_swamp_c_0008",
				"rt_swamp_c_0009",
				"rt_swamp_c_0010",
				"rt_swamp_c_0000",		
				"rt_swamp_c_0011",
				"rt_swamp_c_0012",
				"rt_swamp_c_0013",
				"rt_swamp_c_0014",
				"rt_swamp_c_0015",
				"rt_SwampNear_c_0000",
				"rt_SwampNear_c_0001_searchlight",
				"rt_SwampNear_c_0002",
				"rt_SwampNear_c_0003",
				"rt_SwampNear_c_0004",
			},
			groupB = {},
			groupC = {},
			groupD = {},
			groupE = {},
		},
		hold = {
			groupSniper = {		
			},
			default = {
				"rt_swamp_h_0000",
				"rt_swamp_h_0001",
				"rt_swamp_h_0002",
				"rt_swampNear_h_0000",
				"rt_swampNear_h_0001",
			},
		},
		sleep = {
			groupSniper = {		
			},
			default = {
				"rt_swamp_s_0000",
				"rt_swamp_s_0001",
				"rt_swamp_s_0002",
				"rt_swampNear_s_0000",
				"rt_swampNear_s_0001",
			},
		},
		travel = {
			lrrpHold = {
				"rt_swamp_l_0000",
				"rt_swamp_l_0001",
			},
			lrrpHold_01 = {
				"rt_swamp_l_0002",
				"rt_swamp_l_0003",
			},
			in_lrrpHold_N = {
				"rt_swamp_lin_N",
				"rt_swamp_lin_N",
			},
			in_lrrpHold_E = {
				"rt_swamp_lin_E",
				"rt_swamp_lin_E",
			},
			out_lrrpHold_B01 = {
				"rt_swamp_lout_B01",
				"rt_swamp_lout_B01",
			},
			out_lrrpHold_B02 = {
				"rt_swamp_lout_B02",
				"rt_swamp_lout_B02",
			},
			out_lrrpHold_B03 = {
				"rt_swamp_lout_B03",
				"rt_swamp_lout_B03",
			},
			out_lrrpHold_B04 = {
				"rt_swamp_lout_B04",
				"rt_swamp_lout_B04",
			},
		},
		outofrain = {
			"rt_swamp_r_0000",
			"rt_swamp_r_0001",
			"rt_swamp_r_0002",
			"rt_swamp_r_0003",
			"rt_swamp_r_0004",
			"rt_swamp_r_0005",
			"rt_swamp_r_0006",
			"rt_swamp_r_0007",
			"rt_swamp_r_0008",
			"rt_swamp_r_0009",
			"rt_swamp_r_0010",
			"rt_swamp_r_0011",
			"rt_swamp_r_0012",
			"rt_swamp_r_0013",
			"rt_swamp_r_0014",
			"rt_swamp_r_0015",
			"rt_swamp_r_0016",
			"rt_swamp_r_0017",
			"rt_swamp_r_0018",
			"rt_swamp_r_0019",
		},
		nil
	},
	
	
	mafr_pfCampNorth_ob			= {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_swampWestToPfCampNorth = {
				"rts_veh_to_pfCampNorth_from_06_16_lrrp",
			},
			lrrp_hillToPfCampNorth = {
				"rts_veh_to_pfCampNorth_from_13_16_lrrp",
				"rts_veh_to_pfCampNorth_from_13_16_lrrp",
			},
			lrrp_pfCampNorthToPfCamp = {
				"rts_veh_pfCampNorth_16_23_lrrp",
				"rts_veh_pfCampNorth_16_23_lrrp",
				"rts_veh_pfCampNorth_16_23_lrrp",
			},
			lrrp_savannahEastToPfCamp = {
				"rts_veh_13_16_lrrp_pfCampNorth_add",
			},
			lrrp_swampEastToPfCamp = {
				"rts_veh_06_16_lrrp_pfCampNorth_add",
			},
		},
		nil,
	},
	mafr_pfCampEast_ob			= {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_hillToPfCampNorth = {
				"rts_veh_pfCampEast_13_15_lrrp",
				"rts_veh_pfCampEast_13_15_lrrp",
			},
		},
		nil,
	},
	mafr_swamp_cp				= {--RETAILBUG: duplicate key differnt value
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_swampWestToPfCampNorth = {
				"rts_veh_swamp_06_22_lrrp",
			},
		},
		nil,
	},
	mafr_swampSouth_ob			= { USE_COMMON_ROUTE_SETS = true,	},
	mafr_swampEast_ob			= {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_swampWestToPfCampNorth = {
				"rts_veh_swampEast_06_16_lrrp",
			},
			lrrp_swampEastToPfCamp = {
				"rts_veh_fromSwampEast_add",
			},
			lrrp_savannahToSwampEast = {
				"rts_veh_toSwampEast_add",
			},
		},
		nil,
	},
	mafr_swampWest_ob			= {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_swampWestToPfCampNorth = {
				"rts_veh_swampWest_02_22_lrrp",
			},
		},
		nil,
	},
	mafr_hill_cp				= {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_hillToPfCampNorth = {
				"rts_veh_hill_15_27_lrrp",
				"rts_veh_hill_15_27_lrrp",
			},
		},
		nil,
	},
	mafr_hillWest_ob			= { USE_COMMON_ROUTE_SETS = true,	},
	mafr_hillWestNear_ob		= { USE_COMMON_ROUTE_SETS = true,	},
	mafr_savannah_cp			= { USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_savannahToSavannahEast = {
				"rts_veh_fromSavannahToSavannahEast",
			},
			lrrp_savannahToSwampEast = {
				"rts_veh_fromSavannahToSwampEast",
			},
		},
		nil,
	},
	mafr_savannahEast_ob		= {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_hillToPfCampNorth = {
				"rts_veh_savannahEast_13_16_lrrp",
				"rts_veh_savannahEast_13_16_lrrp",
			},
			lrrp_savannahEastToPfCamp = {
				"rts_veh_from_SavannahEast_add",
			},
			lrrp_savannahToSavannahEast = {
				"rts_veh_toSavannahEast_add",
			},
		},
		nil,
	},
	
	
	mafr_02_22_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_swampWestToPfCampNorth = {
				"rts_veh_02_22_lrrp_swamp",
			},
		},
		nil,
	},
	mafr_06_22_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_swampWestToPfCampNorth = {
				"rts_veh_06_22_lrrp_swampEast",
			},
		},
		nil,
	},
	mafr_06_16_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_swampWestToPfCampNorth = {
				"rts_veh_06_16_lrrp_pfCampNorth",
			},
			lrrp_swampEastToPfCamp = {
				"rts_veh_swampEast_06_16_lrrp_add",
			},
		},
		nil,
	},
	mafr_15_27_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_hillToPfCampNorth = {
				"rts_veh_15_27_lrrp_pfCampEast",
				"rts_veh_15_27_lrrp_pfCampEast",
			},
		},
		nil,
	},
	mafr_13_15_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_hillToPfCampNorth = {
				"rts_veh_13_15_lrrp_savannahEast",
				"rts_veh_13_15_lrrp_savannahEast",
			},
		},
		nil,
	},
	mafr_13_16_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_hillToPfCampNorth = {
				"rts_veh_13_16_lrrp_pfCampNorth",
				"rts_veh_13_16_lrrp_pfCampNorth",
			},
			lrrp_savannahEastToPfCamp = {
				"rts_veh_savannahEast_13_16_lrrp_add",
			},
		},
		nil,
	},
	mafr_16_23_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrp_pfCampNorthToPfCamp = {
				"rts_veh_16_23_lrrp_pfCamp",
				"rts_veh_16_23_lrrp_pfCamp",
				"rts_veh_16_23_lrrp_pfCamp",
			},
			lrrp_savannahEastToPfCamp = {
				"rts_veh_pfCampNorth_16_23_lrrp_add",
			},
			lrrp_swampEastToPfCamp = {
				"rts_veh_pfCampNorth_16_23_lrrp_add2",
			},
		},
		nil,
	},
	
	mafr_06_24_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
	},
	mafr_13_24_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
	},
	mafr_27_30_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
	},
	
	nil
}





this.travelPlans = {
	
	travel_swampToPfCampNorth = {
		ONE_WAY = true,
		{ cp = "mafr_swampWest_ob", 		routeGroup={ "travel", "lrrp_swampWestToPfCampNorth" } },
		{ cp = "mafr_02_22_lrrp", 			routeGroup={ "travel", "lrrp_swampWestToPfCampNorth" } },
		{ cp = "mafr_swamp_cp", 			routeGroup={ "travel", "lrrp_swampWestToPfCampNorth" } },
		{ cp = "mafr_06_22_lrrp", 			routeGroup={ "travel", "lrrp_swampWestToPfCampNorth" } },
		{ cp = "mafr_swampEast_ob", 		routeGroup={ "travel", "lrrp_swampWestToPfCampNorth" } },
		{ cp = "mafr_06_16_lrrp", 			routeGroup={ "travel", "lrrp_swampWestToPfCampNorth" } },
		{ cp = "mafr_pfCampNorth_ob", 		routeGroup={ "travel", "lrrp_swampWestToPfCampNorth" } },
		{ cp = "mafr_pfCampNorth_ob" },
	},
	
	travel_hillToPfCampNorth = {
		ONE_WAY = true,
		{ cp = "mafr_hill_cp", 				routeGroup={ "travel", "lrrp_hillToPfCampNorth" } },
		{ cp = "mafr_15_27_lrrp", 			routeGroup={ "travel", "lrrp_hillToPfCampNorth" } },
		{ cp = "mafr_pfCampEast_ob", 		routeGroup={ "travel", "lrrp_hillToPfCampNorth" } },
		{ cp = "mafr_13_15_lrrp", 			routeGroup={ "travel", "lrrp_hillToPfCampNorth" } },
		{ cp = "mafr_savannahEast_ob", 		routeGroup={ "travel", "lrrp_hillToPfCampNorth" } },
		{ cp = "mafr_13_16_lrrp", 			routeGroup={ "travel", "lrrp_hillToPfCampNorth" } },
		{ cp = "mafr_pfCampNorth_ob", 		routeGroup={ "travel", "lrrp_hillToPfCampNorth" } },
		{ cp = "mafr_pfCampNorth_ob" },
	},
	
	travel_pfCampNorthToPfCamp = {
		ONE_WAY = true,
		{ cp = "mafr_pfCampNorth_ob", 		routeGroup={ "travel", "lrrp_pfCampNorthToPfCamp" } },
		{ cp = "mafr_16_23_lrrp", 			routeGroup={ "travel", "lrrp_pfCampNorthToPfCamp" } },
		{ cp = "mafr_pfCamp_cp", 			routeGroup={ "travel", "lrrp_pfCampNorthToPfCamp" } },	
		{ cp = "mafr_pfCamp_cp" },	
	},

	
	
	travel_savannahToSavannahEast = {
		ONE_WAY = true,
		{ cp = "mafr_savannah_cp", 			routeGroup={ "travel", "lrrp_savannahToSavannahEast" } },
		{ cp = "mafr_savannahEast_ob", 		routeGroup={ "travel", "lrrp_savannahToSavannahEast" } },
		{ cp = "mafr_savannahEast_ob" },
	},
	
	travel_savannahToSwampEast = {
		ONE_WAY = true,
		{ cp = "mafr_savannah_cp", 			routeGroup={ "travel", "lrrp_savannahToSwampEast" } },
		{ cp = "mafr_swampEast_ob", 		routeGroup={ "travel", "lrrp_savannahToSwampEast" } },
		{ cp = "mafr_swampEast_ob" },	
	},
	
	travel_savannahEastToPfCamp = {
		ONE_WAY = true,
		{ cp = "mafr_savannahEast_ob", 		routeGroup={ "travel", "lrrp_savannahEastToPfCamp" } },
		{ cp = "mafr_13_16_lrrp", 			routeGroup={ "travel", "lrrp_savannahEastToPfCamp" } },
		{ cp = "mafr_pfCampNorth_ob", 		routeGroup={ "travel", "lrrp_savannahEastToPfCamp" } },
		{ cp = "mafr_16_23_lrrp", 			routeGroup={ "travel", "lrrp_savannahEastToPfCamp" } },
		{ cp = "mafr_pfCamp_cp", 			routeGroup={ "travel", "lrrp_savannahEastToPfCamp" } },	
		{ cp = "mafr_pfCamp_cp" },	
	},
	
	travel_swampEastToPfCamp = {
		ONE_WAY = true,
		{ cp = "mafr_swampEast_ob", 		routeGroup={ "travel", "lrrp_swampEastToPfCamp" } },
		{ cp = "mafr_06_16_lrrp", 			routeGroup={ "travel", "lrrp_swampEastToPfCamp" } },
		{ cp = "mafr_pfCampNorth_ob",		routeGroup={ "travel", "lrrp_swampEastToPfCamp" } },
		{ cp = "mafr_16_23_lrrp", 			routeGroup={ "travel", "lrrp_swampEastToPfCamp" } },
		{ cp = "mafr_pfCamp_cp", 			routeGroup={ "travel", "lrrp_swampEastToPfCamp" } },
		{ cp = "mafr_pfCamp_cp" },	
	},
}

this.StartTravelPlan = function( soldierTable, travelOption )
	local isKeepInAlert = true
	local travelPlanName = "travel_pfCampNorthToPfCamp"
	if travelOption == this.TRAVEL_TYPE.SWAMP then
		travelPlanName = "travel_swampToPfCampNorth"
	elseif travelOption == this.TRAVEL_TYPE.HILL then
		travelPlanName = "travel_hillToPfCampNorth"
	
	elseif travelOption == this.TRAVEL_TYPE.SAVANNAH_SAVANNAH_EAST then
		travelPlanName = "travel_savannahToSavannahEast"
	elseif travelOption == this.TRAVEL_TYPE.SAVANNAH_SWAMP_EAST then
		travelPlanName = "travel_savannahToSwampEast"
	elseif travelOption == this.TRAVEL_TYPE.SAVANNAH_EAST_PFCAMP then
		travelPlanName = "travel_savannahEastToPfCamp"
		isKeepInAlert = false 
	elseif travelOption == this.TRAVEL_TYPE.SWAMP_EAST_PFCAMP then
		travelPlanName = "travel_swampEastToPfCamp"
		isKeepInAlert = false 
	end

	local command = { id = "StartTravel", travelPlan = travelPlanName, keepInAlert=isKeepInAlert }
	for i, soldierName in pairs( soldierTable ) do
		local gameObjectId = NULL_ID
		if IsTypeString( soldierName ) then
			gameObjectId = GameObject.GetGameObjectId( soldierName )
		else
			gameObjectId = soldierName
		end
		if gameObjectId ~= NULL_ID then
			GameObject.SendCommand( gameObjectId, command )
		end
	end
end

this.FinishTravelPlan = function( gameObjectId )
	Fox.Log( "FinishTravelPlan: GameObjectId is " .. tostring(gameObjectId) )
	local command = { id = "StartTravel", travelPlan = "", keepInAlert=false }
	if gameObjectId ~= NULL_ID then
		GameObject.SendCommand( gameObjectId, command )
	end
end





this.combatSetting = {
	mafr_pfCamp_cp = {
		combatAreaList = {
			area1 = {
				{ guardTargetName = "gts_pfCamp_0000", locatorSetName = "css_pfCamp_0000", },
			},
			area2 = {
				{ guardTargetName = "gts_pfCamp_0000", locatorSetName = "css_pfCamp_0001", },
			},
		},
	},
	mafr_pfCampNorth_ob = {
		USE_COMMON_COMBAT = true,
	},
	mafr_pfCampEast_ob = {
		USE_COMMON_COMBAT = true,
	},
	mafr_swamp_cp = {
		USE_COMMON_COMBAT = true,
	},
	mafr_swampSouth_ob = {
		USE_COMMON_COMBAT = true,
	},
	mafr_swampEast_ob = {
		USE_COMMON_COMBAT = true,
	},
	mafr_swampWest_ob = {
		USE_COMMON_COMBAT = true,
	},
	mafr_hill_cp = {
		USE_COMMON_COMBAT = true,
	},
	mafr_hillWest_ob = {
		USE_COMMON_COMBAT = true,
	},
	mafr_hillWestNear_ob = {
		USE_COMMON_COMBAT = true,
	},
	mafr_savannah_cp = {
		USE_COMMON_COMBAT = true,
	},
	mafr_savannahEast_ob = {
		USE_COMMON_COMBAT = true,
	},
	nil
}




this.UniqueInterStart_sol_pfCamp_vip = function( soldier2GameObjectId, cpID )
	Fox.Log("CallBack : Unique : UniqueInterStart_sol_pfCamp_vip .. flag: " .. tostring(mvars.vipInterrogationOrder))
	local order = mvars.vipInterrogationOrder
	mvars.vipInterrogationOrder = order + 1	
	if order == 0 then
		Fox.Log("UniqueInterrogation: enqt1000_103729")
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_103729") 
		return true
	elseif order == 1 then
		Fox.Log("UniqueInterrogation: enqt1000_103730")
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_103730") 
		return true
	elseif order == 2 then
		Fox.Log("UniqueInterrogation: enqt1000_103731")
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_103731") 
		return true
	elseif order == 3 then
		Fox.Log("UniqueInterrogation: enqt1000_103732")
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_103732") 
		return true
	elseif order == 4 then
		Fox.Log("UniqueInterrogation: enqt1000_1f1k10")
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_1f1k10") 
		TppMission.UpdateObjective{
			objectives = { "Area_task_diamond" },	
		}
		return true
	end
	Fox.Log("UniqueInterrogation: completed. not playing unique interrogation narration. return true")
	return false    
end

this.UniqueInterEnd_sol_pfCamp_vip = function( soldier2GameObjectId, cpID, interName )
	Fox.Log( "UniqueInterEnd_sol_pfCamp_vip" .. tostring(interName) )	
end


this.uniqueInterrogation = {
	
	unique = {
		{ name = "enqt1000_103729",	func = this.UniqueInterEnd_sol_pfCamp_vip,},			
		{ name = "enqt1000_103730",	func = this.UniqueInterEnd_sol_pfCamp_vip,},			
		{ name = "enqt1000_103731",	func = this.UniqueInterEnd_sol_pfCamp_vip,},			
		{ name = "enqt1000_103732",	func = this.UniqueInterEnd_sol_pfCamp_vip,},			
		{ name = "enqt1000_1f1k10",	func = this.UniqueInterEnd_sol_pfCamp_vip,},			
	},
	
	uniqueChara = {
		{ name = this.ENEMY_VIP,	func = this.UniqueInterStart_sol_pfCamp_vip,},			
	},
}


this.InterCall_TellIntelligenceFile = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("CallBack : InterCall_TellIntelligenceFile")
	TppMission.UpdateObjective{
		objectives = { "area_Intel", nil  },
	}
	return true
end

this.InterCall_VipSchedule = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("CallBack : InterCall_VipSchedule")
	
	s10171_sequence.RemoveMissionInterrogation( this.INTERROGATION_TYPE.AIRPORT, this.InterCall_VipSchedule )
	return true
end

this.InterCall_VipRideOnHeli = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("CallBack : InterCall_VipRideOnHeli")
	
	s10171_sequence.RemoveMissionInterrogation( this.INTERROGATION_TYPE.HELI, this.InterCall_VipRideOnHeli )
	return true
end

this.InterCall_VipGreat = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("CallBack : InterCall_VipGreat")
	
	s10171_sequence.RemoveMissionInterrogation( this.INTERROGATION_TYPE.GREAT, this.InterCall_VipGreat )
	return true
end


this.interrogation = {
	mafr_pfCamp_cp = {
		
		high = {
			{ name = this.INTERROGATION_TYPE.AIRPORT, func = this.InterCall_VipSchedule, },		
			{ name = this.INTERROGATION_TYPE.HELI, func = this.InterCall_VipRideOnHeli, },			
			{ name = this.INTERROGATION_TYPE.GREAT, func = this.InterCall_VipGreat, },				
			nil
		},
		
		normal = {
			
			nil
		},
		nil
	},
	mafr_pfCampNorth_ob = {
		
		high = {
			{ name = this.INTERROGATION_TYPE.INTEL, func = this.InterCall_TellIntelligenceFile, },	
			{ name = this.INTERROGATION_TYPE.AIRPORT, func = this.InterCall_VipSchedule, },		
			{ name = this.INTERROGATION_TYPE.HELI, func = this.InterCall_VipRideOnHeli, },			
			{ name = this.INTERROGATION_TYPE.GREAT, func = this.InterCall_VipGreat, },				
			nil
		},

		
		normal = {
			
			nil
		},
		nil
	},
	mafr_pfCampEast_ob = {
		
		high = {
			{ name = this.INTERROGATION_TYPE.AIRPORT, func = this.InterCall_VipSchedule, },		
			{ name = this.INTERROGATION_TYPE.HELI, func = this.InterCall_VipRideOnHeli, },			
			{ name = this.INTERROGATION_TYPE.GREAT, func = this.InterCall_VipGreat, },				
			nil
		},
		
		normal = {
			
			nil
		},
		nil
	},
	mafr_swamp_cp = {
		
		high = {
			{ name = this.INTERROGATION_TYPE.AIRPORT, func = this.InterCall_VipSchedule, },		
			{ name = this.INTERROGATION_TYPE.HELI, func = this.InterCall_VipRideOnHeli, },			
			{ name = this.INTERROGATION_TYPE.GREAT, func = this.InterCall_VipGreat, },				
			nil
		},
		
		normal = {
			
			nil
		},
		nil
	},
	mafr_swampSouth_ob = {
		
		high = {
			{ name = this.INTERROGATION_TYPE.AIRPORT, func = this.InterCall_VipSchedule, },		
			{ name = this.INTERROGATION_TYPE.HELI, func = this.InterCall_VipRideOnHeli, },			
			{ name = this.INTERROGATION_TYPE.GREAT, func = this.InterCall_VipGreat, },				
			nil
		},
		
		normal = {
			
			nil
		},
		nil
	},
	mafr_swampEast_ob = {
		
		high = {
			{ name = this.INTERROGATION_TYPE.AIRPORT, func = this.InterCall_VipSchedule, },		
			{ name = this.INTERROGATION_TYPE.HELI, func = this.InterCall_VipRideOnHeli, },			
			{ name = this.INTERROGATION_TYPE.GREAT, func = this.InterCall_VipGreat, },				
			nil
		},
		
		normal = {
			
			nil
		},
		nil
	},
	mafr_swampWest_ob = {
		
		high = {
			{ name = this.INTERROGATION_TYPE.AIRPORT, func = this.InterCall_VipSchedule, },		
			{ name = this.INTERROGATION_TYPE.HELI, func = this.InterCall_VipRideOnHeli, },			
			{ name = this.INTERROGATION_TYPE.GREAT, func = this.InterCall_VipGreat, },				
			nil
		},
		
		normal = {
			
			nil
		},
		nil
	},
	mafr_hill_cp = {
		
		high = {
			nil
		},
		
		normal = {
			
			nil
		},
		nil
	},
	mafr_hillWest_ob = {
		
		high = {
			nil
		},
		
		normal = {
			
			nil
		},
		nil
	},
	mafr_hillWestNear_ob = {
		
		high = {
			nil
		},
		
		normal = {
			
			nil
		},
		nil
	},
	mafr_savannah_cp = {
		
		high = {
			{ name = this.INTERROGATION_TYPE.AIRPORT, func = this.InterCall_VipSchedule, },		
			{ name = this.INTERROGATION_TYPE.HELI, func = this.InterCall_VipRideOnHeli, },			
			{ name = this.INTERROGATION_TYPE.GREAT, func = this.InterCall_VipGreat, },				
			nil
		},
		
		normal = {
			
			nil
		},
		nil
	},
	mafr_savannahEast_ob = {
		
		high = {
			{ name = this.INTERROGATION_TYPE.AIRPORT, func = this.InterCall_VipSchedule, },		
			{ name = this.INTERROGATION_TYPE.HELI, func = this.InterCall_VipRideOnHeli, },			
			{ name = this.INTERROGATION_TYPE.GREAT, func = this.InterCall_VipGreat, },				
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
	mafr_pfCamp_cp = true,	
	mafr_pfCampNorth_ob = true,
	mafr_pfCampEast_ob = true,
	mafr_swamp_cp = true,
	mafr_swampSouth_ob = true,
	mafr_swampEast_ob = true,
	mafr_swampWest_ob = true,
	mafr_hill_cp = true,
	mafr_hillWest_ob = true,
	mafr_hillWestNear_ob = true,
	mafr_savannah_cp = true,
	mafr_savannahEast_ob = true,
	nil
}






this.InitEnemy = function ()
end





local spawnList = {
	{ id="Spawn", locator=this.ENEMY_TANK1, type=Vehicle.type.WESTERN_TRACKED_TANK, class = Vehicle.class.DARK_GRAY },
	{ id="Spawn", locator=this.ENEMY_TANK2, type=Vehicle.type.WESTERN_TRACKED_TANK, paintType=Vehicle.paintType.FOVA_0 },
	{ id="Spawn", locator=this.ENEMY_WAV, type=Vehicle.type.WESTERN_WHEELED_ARMORED_VEHICLE, subType = Vehicle.subType.WESTERN_WHEELED_ARMORED_VEHICLE_TURRET_MACHINE_GUN, paintType=Vehicle.paintType.FOVA_0 },
}
local despawnList = {
	{ id="Despawn", locator=this.ENEMY_WAV_ADD, type=Vehicle.type.WESTERN_WHEELED_ARMORED_VEHICLE, subType = Vehicle.subType.WESTERN_WHEELED_ARMORED_VEHICLE_TURRET_CANNON, class = Vehicle.class.DARK_GRAY },
}

this.vehicleDefine = {
	instanceCount = #spawnList + #despawnList,
}

this.SpawnVehicleOnInitialize = function()
	TppEnemy.SpawnVehicles( spawnList )
	TppEnemy.DespawnVehicles( despawnList ) 
end



this.SetUpEnemy = function ()
	TppEnemy.RegisterCombatSetting( this.combatSetting )
	
	
	TppEnemy.SetEliminateTargets( { this.ENEMY_HELI, this.ENEMY_TANK1, this.ENEMY_TANK2, this.ENEMY_WAV, this.ENEMY_WAV_ADD } ) 
	
	
	TppEnemy.AssignUniqueStaffType{
		locaterName = this.ENEMY_VIP,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10171_BONUS_SOLIDER,
		alreadyExistParam = { staffTypeId =2, randomRangeId =6, skill ="Grappler" },
	}	
	
	this.SetAsVip( this.ENEMY_VIP )
	
	TppEnemy.RegistHoldRecoveredState( this.ENEMY_VIP )
	
	
	s10171_sequence.SetSneakCautionRouteSoldier( this.ENEMY_TANK1_SOLDIER, "rts_idle_solTank1" )
	s10171_sequence.SetSneakCautionRouteSoldier( this.ENEMY_TANK2_SOLDIER, "rts_idle_solTank2" )
	s10171_sequence.SetSneakCautionRouteSoldier( this.ENEMY_WAV_SOLDIER, "rts_idle_solWAV" )
	s10171_sequence.SetSneakCautionRouteSoldier( this.ENEMY_WAV_ADD_SOLDIER, "rts_idle_solWAV_add" )
	
	
	TppEnemy.SetDisable( this.ENEMY_WAV_ADD_SOLDIER )
	
	
	this.SetEnemyVehicle( { this.ENEMY_TANK1_SOLDIER }, this.ENEMY_TANK1, true )
	this.SetEnemyVehicle( { this.ENEMY_TANK2_SOLDIER }, this.ENEMY_TANK2, true )
	this.SetEnemyVehicle( { this.ENEMY_WAV_SOLDIER }, this.ENEMY_WAV, true )
	
	
	this.SetVehicleConvoy( { this.INITIAL_CONVOY_LEAD, this.ENEMY_TANK2 }, true )

	
	this.StartTravelPlan( { this.ENEMY_TANK1_SOLDIER }, this.TRAVEL_TYPE.SWAMP )
	this.StartTravelPlan( { this.ENEMY_WAV_SOLDIER, this.ENEMY_TANK2_SOLDIER }, this.TRAVEL_TYPE.HILL )
	
	s10171_sequence.SetAllPhaseRouteSoldier( this.ENEMY_VIP, "rts_vipStart" )	
	
	
	this.driverVehicleMatchIdTable[ GameObject.GetGameObjectId( this.ENEMY_TANK1_SOLDIER ) ] = GameObject.GetGameObjectId("TppVehicle2", this.ENEMY_TANK1 )
	this.driverVehicleMatchIdTable[ GameObject.GetGameObjectId( this.ENEMY_TANK2_SOLDIER ) ] = GameObject.GetGameObjectId("TppVehicle2", this.ENEMY_TANK2 )
	this.driverVehicleMatchIdTable[ GameObject.GetGameObjectId( this.ENEMY_WAV_SOLDIER ) ] = GameObject.GetGameObjectId("TppVehicle2", this.ENEMY_WAV )
	
	
	TppEnemy.InitialRouteSetGroup{ cpName = "mafr_pfCamp_cp", soldierList = { "sol_pfCamp_0000", "sol_pfCamp_0001", "sol_pfCamp_0002", "sol_pfCamp_0003" }, groupName = "groupSniper" }
		
	
	this.EnemyHeliDisablePullOut()
	
	
	this.UnsetUseFlearAtPfCamp()
	
	
	TppHelicopter.SetEnemyColoring( TppDefine.ENEMY_HELI_COLORING_TYPE.BLACK ) 
end


this.OnLoad = function ()
	Fox.Log("*** s10171 onload ***")
end


this.EnemyHeliSetRoute = function(routeId)
	Fox.Log("change route Enemy Heli "..routeId )
	local gameObjectId =  GameObject.GetGameObjectId("TppEnemyHeli","EnemyHeli")
	GameObject.SendCommand(gameObjectId, { id="SetSneakRoute", 	route=routeId })
	
	
end


this.EnemyHeliDisablePullOut = function()
	Fox.Log("EnemyHeli　DisablePullOut")
	local gameObjectId =  GameObject.GetGameObjectId("TppEnemyHeli","EnemyHeli")
	GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })
end


this.SetEnemyVehicle = function( soldierNameTable, vehicleName, isRideFromBegin )
	local vehicleId = GameObject.GetGameObjectId("TppVehicle2", vehicleName )
	for i, soldierName in pairs( soldierNameTable ) do
		local soldierId = GameObject.GetGameObjectId("TppSoldier2", soldierName )
		local command = { id="SetRelativeVehicle", targetId=vehicleId, rideFromBeginning=isRideFromBegin, isVigilance=true }
		GameObject.SendCommand( soldierId, command )
	end
end


this.SetVehicleConvoy = function( vehicleNameTable, isSet )
	
	local GetGameObjectId = GameObject.GetGameObjectId
	local vehicleIdTable = {}
	for i, vehicleName in pairs( vehicleNameTable ) do
		local gameObjId = NULL_ID
		if IsTypeString( vehicleName ) then
			gameObjId = GetGameObjectId( "TppVehicle2", vehicleName )
		else
			gameObjId = vehicleName
		end
		Fox.Log( "SetVehicleConvoy " .. vehicleName .. " isSet " .. tostring(isSet) )
		table.insert( vehicleIdTable, gameObjId )
	end
	
	if isSet then
		GameObject.SendCommand( { type="TppVehicle2", },{ id = "RegisterConvoy", convoyId = vehicleIdTable,} )
	else
		
		for i, vehicleId in pairs( vehicleIdTable ) do
			GameObject.SendCommand( { type="TppVehicle2", },{ id = "UnregisterConvoy", convoyId = vehicleId,} )
		end		
	end
end


this.SetAsVip = function( enemyId )
	local gameObjectId = GameObject.GetGameObjectId( enemyId )
	local command = { id="SetVip" }
	GameObject.SendCommand( gameObjectId, command )
end


this.UnsetUseFlearAtPfCamp = function()
	local gameObjectId =  GameObject.GetGameObjectId( "mafr_pfCamp_cp" )
	local command = { id = "IgnoreFlear", ignore=true }
	GameObject.SendCommand( gameObjectId, command )
end



return this
