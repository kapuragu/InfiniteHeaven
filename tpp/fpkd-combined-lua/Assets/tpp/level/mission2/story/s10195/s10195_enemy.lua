local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}


this.routeChangeTableRoot = {}


this.USE_COMMON_REINFORCE_PLAN = true


local TRANSFER_TIME = 1


local MISSION_VIP_GROUP = {
	"sol_vip",
	"sol_vip_driver",
	"sol_vip_pass0000",
	"sol_vip_pass0001",
}

local VIP_ROUTES = {
	SE_STAY = 	{ 	
					"rts_vip_stay",
					"rts_driver_stay",
					"rts_pass_stay0001",
					"rts_pass_stay0002",
				},
	SE_MOVE = 	{ 	
					"rts_vip_walk",
					"rts_vip_walk",
					"rts_pass_stay0001",
					"rts_pass_stay0002",
				},

	MA_WAIT = 	{ 	
					"rts_vip_meeting_wait",
					"rts_vip_meeting_wait",
					"rts_pass_meeting0001",
					"rts_pass_meeting0002",
				},

	MA_MOVE = 	{ 	
					"rts_vip_meeting",
					"rts_driver_meeting",
					"rts_pass_meeting0001",
					"rts_pass_meeting0002",
				},
	MA_MEETING = { 	
					"rts_vip_meetingNow",
					"rts_driver_meeting",
					"rts_pass_meeting0001",
					"rts_pass_meeting0002",
				},
	MA_RIDE_CAR = { 
					"rts_vip_endMeeting_ride",
					"rts_driver_endMeeting",
					"rts_pass_meeting0001",
					"rts_pass_meeting0002",
				},
}

local MISSION_DEALER_GROUP = {
		"sol_dealer",
		"sol_dealer_0000",
		"sol_dealer_0001",
		"sol_dealer_0002",
		"sol_dealer_0003",
		"sol_dealer_0004",
		"sol_dealer_0005",
		"sol_dealer_0006",
}

local DEALER_ROUTES = {
	MA_STAY		 = {
						"rts_dealer_meeting" ,
						"rts_dealer_wait0000" ,
						"rts_dealer_wait0001" ,
						"rts_dealer_wait0002",
						"rts_dealer_wait0003",
						"rts_dealer_wait0004",
						"rts_dealer_wait0005" ,
						"rts_dealer_wait0006" ,
					}, 				
	MA_TALK		 = {
						"rts_dealer_meetingNow" ,
						"rts_dealer_meetingNow0004" ,
						"rts_dealer_meetingNow0005" ,
						"rts_dealer_wait0002",
						"rts_dealer_meetingNow0000" ,
						"rts_dealer_meetingNow0001" ,
						"rts_dealer_meetingNow0002" ,
						"rts_dealer_meetingNow0003" ,
					},
	MA_CAUTION 	 = {
						"rts_dealer_meeting" ,
						"rts_dealer_wait0000" ,
						"rts_dealer_wait0001" ,
						"rts_dealer_wait0002",
						"rts_dealer_wait0003",
						"rts_dealer_wait0004",
						"rts_dealer_wait0005" ,
						"rts_dealer_wait0006" ,
					},
	MA_RETURN	 = {
						"rts_dealer_return" ,
						"rts_dealer_return" ,
						"rts_dealer_return" ,
						"rts_dealer_return" ,
						"rts_dealer_return" ,
						"rts_dealer_return" ,
						"rts_dealer_return" ,
						"rts_dealer_return" ,
					},
	DS_CAUTION	 = {
						"rts_diamondSouth_escape" ,			
						"rts_diamondSouth_dealer0000" ,
						"rts_diamondSouth_dealer0001" ,
						"rts_diamondSouth_dealer0002" ,
						"rts_diamondSouth_dealer0003" ,
						"rts_diamondSouth_dealer0004" ,
						"rts_diamondSouth_dealer0005" ,
						"rts_diamondSouth_dealer0006" ,
					},
}

local RELACTIVE_VEHICLE_GROUP = {
	
	Vehs_lv_savannahEast_0000 = 	{
				"sol_vip_driver",
				"sol_vip_pass0000",
				"sol_vip_pass0001",
				"sol_vip",
			},
	Vehs_lv_dealer_0000 = 	{
				"sol_dealer_0000",
				"sol_dealer_0001",
				"sol_dealer_0002",
				"sol_dealer",
			},
	Vehs_lv_dealer_0001 = 	{
				"sol_dealer_0003",
				"sol_dealer_0004",
				"sol_dealer_0005",
				"sol_dealer_0006",
			},

	
	Vehs_lv_hillNorth_0000 = 	{
				"sol_vip_driver",
				"sol_vip_pass0000",
				"sol_vip_pass0001",
				"sol_vip",
			},
}





this.soldierDefine = {

	
	mafr_dealer_cp = {
		"sol_dealer",
		"sol_dealer_0000",
		"sol_dealer_0001",
		"sol_dealer_0002",
		"sol_dealer_0003",
		"sol_dealer_0004",
		"sol_dealer_0005",
		"sol_dealer_0006",
		nil
	},


	
	mafr_pfCampNorth_ob = {
		"sol_pfCampNorth_0000",
		"sol_pfCampNorth_0001",
		"sol_pfCampNorth_0002",
		"sol_pfCampNorth_0003",
		nil
	},

	mafr_pfCampEast_ob = {
		"sol_pfCampEast_0000",
		"sol_pfCampEast_0001",
		"sol_pfCampEast_0002",
		"sol_pfCampEast_0003",
		nil
	},

	mafr_savannahEast_ob = {
		"sol_savannahEast_0000",
		"sol_savannahEast_0001",
		"sol_savannahEast_0002",
		"sol_savannahEast_0003",
		"sol_savannahEast_0004",
		"sol_savannahEast_0005",

		
		"sol_vip",
		"sol_vip_driver",
		"sol_vip_pass0000",
		"sol_vip_pass0001",
		nil
	},

	mafr_hillWest_ob = {
		"sol_hillWest_0000",
		"sol_hillWest_0001",
		"sol_hillWest_0002",
		"sol_hillWest_0003",
		"sol_hillWest_0004",
		"sol_hillWest_0005",
		"sol_hillWest_0006",
		"sol_hillWest_0007",
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
		"sol_hillNorth_0008",
		"sol_hillNorth_0009",
	
		nil
	},

	mafr_diamondSouth_ob = {
		"sol_diamondSouth_0000",
		"sol_diamondSouth_0001",
		"sol_diamondSouth_0002",
		"sol_diamondSouth_0003",
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
		nil
	},

	
	mafr_11_12_lrrp = { nil },
	mafr_12_14_lrrp = { nil },
	mafr_13_14_lrrp = { nil },
	mafr_06_24_lrrp = { nil },
	mafr_13_24_lrrp = { nil },

	nil
}


this.soldierSubTypes = {
	
	PF_C = {
		this.soldierDefine.mafr_dealer_cp,
	},
}

this.soldierPowerSettings = {

	sol_vip = {},		
	sol_dealer = {},	
	
	sol_vip_driver	 = 	{"SOFT_ARMOR","HELMET","SHOTGUN"},

	sol_vip_pass0000 =	{"SOFT_ARMOR","HELMET",},
	sol_vip_pass0001 =	{"SOFT_ARMOR","HELMET","MG"},

	sol_dealer_0000 =	{"SOFT_ARMOR","HELMET","SHOTGUN"},
	sol_dealer_0001 = 	{"SOFT_ARMOR","HELMET",},
	sol_dealer_0002 = 	{"SOFT_ARMOR","HELMET",},
	sol_dealer_0003 = 	{"SOFT_ARMOR","HELMET","MG"},
	sol_dealer_0004 = 	{"SOFT_ARMOR","HELMET",},
	sol_dealer_0005 = 	{"SOFT_ARMOR","HELMET",},
	sol_dealer_0006 = 	{"SOFT_ARMOR","HELMET",},

}





this.routeSets = {

	mafr_pfCampNorth_ob = 	{ USE_COMMON_ROUTE_SETS = true,	},
	mafr_pfCampEast_ob = 	{ USE_COMMON_ROUTE_SETS = true,	},

	
	mafr_06_24_lrrp =	{ USE_COMMON_ROUTE_SETS = true, },
	mafr_13_24_lrrp =	{ USE_COMMON_ROUTE_SETS = true, },

	
	mafr_savannah_cp = { USE_COMMON_ROUTE_SETS = true,	},

	
	mafr_savannahEast_ob = {
		USE_COMMON_ROUTE_SETS = true,
		priority = {
			"groupA",
			"groupB",
			"groupC",
			"groupD",
			"groupE",
		},
		sneak_day = {
			groupA = {
				"rt_savannahEast_d_0000_sub",
				"rt_savannahEast_d_0005",
			},
			groupB = {
				"rt_savannahEast_d_0002",
				"rts_savannahEast_d_0000",
			},
			groupC = {
				"rt_savannahEast_d_0004",
				"rts_savannahEast_d_0002",
			},
			groupD = {
				"rt_savannahEast_d_0001_sub",	
				"rts_savannahEast_d_0001",
			},
			groupE = {
				"rt_savannahEast_d_0003",
				"rts_savannahEast_d_0003",
			},
		},

		sneak_night = {
			groupA = {
				"rt_savannahEast_n_0000_sub",
				"rt_savannahEast_n_0005",
			},
			groupB = {
				"rt_savannahEast_n_0002",
				"rts_savannahEast_d_0000",
			},
			groupC = {
				"rt_savannahEast_n_0004",
				"rts_savannahEast_d_0001",
			},
			groupD = {
				"rt_savannahEast_n_0001_sub",
				"rts_savannahEast_d_0002",
			},
			groupE = {
				"rt_savannahEast_n_0003",
				"rts_savannahEast_d_0003",
			},
		},

		caution = {
			groupA = {
				"rt_savannahEast_c_0000",
				"rt_savannahEast_c_0001",
				"rt_savannahEast_c_0002",
				"rt_savannahEast_c_0003",
				"rt_savannahEast_c_0004",
				"rt_savannahEast_c_0005",
				"rt_savannahEast_c_0003",
				"rt_savannahEast_c_0004",
				"rt_savannahEast_c_0006",
				"rt_savannahEast_c_0003",
			},
			groupB = {},
			groupC = {},
			groupD = {},
			groupE = {},
		},
		travel = {
			rideVehicle = {
				"rts_v_svannahEast",
				"rts_v_svannahEast",
				"rts_v_svannahEast",
				"rts_v_svannahEast",
			},
		},

	},


	mafr_hillWest_ob = {
		USE_COMMON_ROUTE_SETS = true,
		priority = {
			"groupA",
			"groupB",
			"groupC",
		},
		sneak_day = {
			groupA = {
				"rt_hillWest_d_0000",
				"rt_hillWest_d_0001_sub",
				"rts_hillWest_d_0000",
				"rts_hillWest_d_0002",
			},
			groupB = {
				"rt_hillWest_d_0002",
				"rt_hillWest_d_0003_sub",
				"rts_hillWest_d_0002",
				"rts_hillWest_d_0000",
			},
			groupC = {
				"rts_hillWest_d_0001",
				"rt_hillWest_d_0005",
				"rts_hillWest_d_0001",
				"rts_hillWest_d_0001",
			},

		},

		sneak_night = {
			groupA = {
				"rt_hillWest_n_0000_sub",
				"rt_hillWest_n_0001_sub",
				"rts_hillWest_n_0000",
				"rts_hillWest_n_0001",
			},
			groupB = {
				"rt_hillWest_n_0002",
				"rt_hillWest_n_0003",
				"rts_hillWest_n_0001",
				"rt_hillWest_n_0004",
			},
			groupC = {
				"rts_hillWest_n_0000",	
				"rt_hillWest_n_0004",
				"rt_hillWest_n_0003",
				"rts_hillWest_n_0000",	
			},
		},

		caution = {
			groupA = {
				"rts_hillWest_c_0000",
				"rt_hillWest_c_0001",
				"rt_hillWest_c_0002",
				"rt_hillWest_c_0003",
				"rt_hillWest_c_0004",
				"rt_hillWest_c_0005",
				"rts_hillWest_c_0001",
				"rts_hillWest_c_0002",
				"rt_hillWest_c_0000",
				"rt_hillWest_c_0000",
				"rts_hillWest_c_0001",
				"rts_hillWest_c_0002",
			},
			groupB = {},
			groupC = {},
		},

		sleep = {
			default = {
				"rt_hillWest_s_0000",
				"rt_hillWest_s_0001",
				"rts_hillWest_s_0000",
				"rts_hillWest_s_0001",
			},
		},

		travel = {
			lrrpRelay = {
				"rts_v_hillWest",
				"rts_v_hillWest",
				"rts_v_hillWest",
				"rts_v_hillWest",
			},
		},


	},

	mafr_hillNorth_ob = {
		USE_COMMON_ROUTE_SETS = true,
		priority = {
			"groupA",
			"groupB",
			"groupC",
			"groupD",
		},
		sneak_day = {
			groupA = {
				"rt_hillNorth_d_0000_sub",
				"rt_hillNorth_d_0004",
				"rts_hillNorth_d_0000",
				"rts_hillNorth_d_0000",
			},
			groupB = {
				"rt_hillNorth_d_0001_sub",
				"rt_hillNorth_d_0005",
				"rts_hillNorth_d_0001",
				"rts_hillNorth_d_0001",			
			},
			groupC = {
				"rt_hillNorth_d_0002",
				"rt_hillNorth_d_0006",
				"rt_hillNorth_d_0004",
				"rt_hillNorth_d_0003",				
			},
			groupD = {
				"rt_hillNorth_d_0003",
				"rt_hillNorth_d_0007",		
				"rt_hillNorth_d_0007",
				"rt_hillNorth_d_0004",
			},
		},
		
		sneak_night = {
			groupA = {
				"rt_hillNorth_n_0000_sub",
				"rt_hillNorth_n_0001_sub",
				"rts_hillNorth_d_0000",
				"rts_hillNorth_d_0000",
			},
			groupB = {
				"rt_hillNorth_n_0002",
				"rt_hillNorth_n_0003",
				"rts_hillNorth_d_0001",
				"rts_hillNorth_d_0001",		
			},
			groupC = {
				"rt_hillNorth_n_0004",
				"rt_hillNorth_n_0005",
				"rt_hillNorth_n_0003",
				"rt_hillNorth_n_0003",
			},
			groupD = {
				"rt_hillNorth_n_0006",
				"rt_hillNorth_n_0007",
				"rt_hillNorth_n_0005",
				"rt_hillNorth_n_0005",
			},
		},
		caution = {
			groupA = {
				"rt_hillNorth_c_0000",
				"rt_hillNorth_c_0001",
				"rt_hillNorth_c_0002",
				"rt_hillNorth_c_0003",
				"rt_hillNorth_c_0004",
				"rt_hillNorth_c_0003",
				"rt_hillNorth_c_0004",
				"rt_hillNorth_c_0005",
				"rt_hillNorth_c_0005",
				"rts_hillNorth_c_0000",
				"rt_hillNorth_c_0006",
				"rt_hillNorth_c_0007",
				"rt_hillNorth_c_0002",
				"rt_hillNorth_c_0003",
				"rt_hillNorth_c_0004",
				"rt_hillNorth_c_0005",				
			},
			groupB = {},
			groupC = {},
			groupD = {},
		},
		hold = {
			default = {
			},
		},
		sleep = {
			default = {
			},
		},
		travel = {
			lrrpRelay = {
				"rts_v_hillNorth",
				"rts_v_hillNorth",
				"rts_v_hillNorth",
				"rts_v_hillNorth",
			},
			toNextCar = {
				"rts_hillNorth_toNextCar",
				"rts_hillNorth_toNextCar",
				"rts_hillNorth_toNextCar",
				"rts_hillNorth_toNextCar",
			},
		},

	},

	mafr_diamondSouth_ob = 	{
		USE_COMMON_ROUTE_SETS = true,

		travel = {
			lrrpRelay = {
				"rts_v_diamondSouth",
				"rts_v_diamondSouth",
				"rts_v_diamondSouth",
				"rts_v_diamondSouth",
				"rts_v_diamondSouth",
				"rts_v_diamondSouth",
				"rts_v_diamondSouth",
				"rts_v_diamondSouth",
			},
		},
	},

	mafr_dealer_cp = 	{
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
			},
		},
		
		sneak_night = {
			groupA = {
			},

		},
		caution = {
			groupA = {},
		},
		hold = {
			default = {
			},
		},
		sleep = {
			default = {
			},
		},
		travel = {
			lrrpRelay = {
				"rts_dealer_return",
				"rts_dealer_return",
				"rts_dealer_return",
				"rts_dealer_return",
				"rts_dealer_return",
				"rts_dealer_return",
				"rts_dealer_return",
				"rts_dealer_return",
			},
		},
	},

	



	
	mafr_11_12_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
			},
		},
		sneak_night = {
			groupA = {
			},
		},
		caution = {
			groupA = {
			},
		},
		hold = {
			default = {
			},
		},
		travel = {
			lrrp_11to12 = {
				"rt_11to12_0000",
				"rt_11to12_0000",
			},
			lrrp_12to11 = {
				"rt_12to11_0000",
				"rt_12to11_0000",
			},


			lrrp_v_12toMA = {
				"rts_v_toMeetingArea",
				"rts_v_toMeetingArea",
				"rts_v_toMeetingArea",
				"rts_v_toMeetingArea",

			},


			lrrp_v_MAto12 = {
				"rts_v_toHillNorthBack",
				"rts_v_toHillNorthBack",
				"rts_v_toHillNorthBack",
				"rts_v_toHillNorthBack",

			},

			rp_11to12 = {
				"rt_11to12_0000",
				"rt_11to12_0000",
				"rt_11to12_0000",
				"rt_11to12_0000",
			},
			rp_12to11 = {
				"rt_12to11_0000",
				"rt_12to11_0000",
				"rt_12to11_0000",
				"rt_12to11_0000",
			},
		},
		nil
	},

	
	mafr_12_14_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
			},
		},
		sneak_night = {
			groupA = {
			},
		},
		caution = {
			groupA = {
			},
		},
		hold = {
			default = {
			},
		},
		travel = {
			lrrp_12to14 = {
				"rt_12to14_0000",
				"rt_12to14_0000",
			},
			lrrp_14to12 = {
				"rt_14to12_0000",
				"rt_14to12_0000",
			},

			lrrp_v_14to12 = {
				"rts_v_14to12_0000",
				"rts_v_14to12_0000",
				"rts_v_14to12_0000",
				"rts_v_14to12_0000",
			},



			rp_12to14 = {
				"rt_12to14_0000",
				"rt_12to14_0000",
				"rt_12to14_0000",
				"rt_12to14_0000",
			},
			rp_14to12 = {
				"rt_14to12_0000",
				"rt_14to12_0000",
				"rt_14to12_0000",
				"rt_14to12_0000",
			},
		},
		nil
	},

	
	mafr_13_14_lrrp = {
		USE_COMMON_ROUTE_SETS = false,
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
			},
		},
		sneak_night = {
			groupA = {
			},
		},
		caution = {
			groupA = {
			},
		},
		hold = {
			default = {
			},
		},
		travel = {
			lrrp_13to14 = {
				"rt_13to14_0000",
				"rt_13to14_0000",
			},
			lrrp_14to13 = {
				"rt_14to13_0000",
				"rt_14to13_0000",
			},

			lrrp_v_13to14 = {
				"rts_v_13to14_0000",
				"rts_v_13to14_0000",
				"rts_v_13to14_0000",
				"rts_v_13to14_0000",
			},

			rp_13to14 = {
				"rt_13to14_0000",
				"rt_13to14_0000",
				"rt_13to14_0000",
				"rt_13to14_0000",
			},
			rp_14to13 = {
				"rt_14to13_0000",
				"rt_14to13_0000",
				"rt_14to13_0000",
				"rt_14to13_0000",
			},
		},
		nil
	},

	nil
}






this.travelPlans = {

	










	
	
	travel_toHillWest = {
		{ cp ="mafr_savannahEast_ob",		routeGroup={ "travel", "rideVehicle" } },
		{ cp = "mafr_13_14_lrrp",			routeGroup={ "travel", "lrrp_v_13to14" } },
		{ cp = "mafr_hillWest_ob" }
	},

	
	travel_toHillNorth = {
		ONE_WAY = true,
		{ cp ="mafr_hillWest_ob",			routeGroup={ "travel", "lrrpRelay" } },
		{ cp = "mafr_12_14_lrrp",			routeGroup={ "travel", "lrrp_v_14to12" } },
		{ cp = "mafr_hillNorth_ob" }

	},

	
	travel_toMeetingArea = {
		{ cp ="mafr_hillNorth_ob", 			routeGroup={ "travel", "lrrpRelay" } },
		{ cp ="mafr_hillNorth_ob",			routeGroup={ "travel", "toNextCar" } },
		{ cp = "mafr_11_12_lrrp",			routeGroup={ "travel", "lrrp_v_12toMA" } },
		{ cp ="mafr_dealer_cp" }
	},

	
	travel_toHillNorthBack = {
		ONE_WAY = true,
		{ cp ="mafr_11_12_lrrp", 			routeGroup={ "travel", "lrrp_v_MAto12" } },
		{ cp ="mafr_hillNorth_ob" },
	},

	
	
	travel_meetingCancelToSavannahEast = {
		ONE_WAY = true,
		{ base = "mafr_savannahEast_ob" }
	},
	
	travel_meetingCancelToHillWest = {
		ONE_WAY = true,
		{ base = "mafr_hillWest_ob" }
	},

	
	travel_meetingCancelToHillNorth = {
		ONE_WAY = true,
		{ base = "mafr_hillNorth_ob" }
	},

	
	travel_toDiamondSouthHeliBroken = {
		ONE_WAY = true,
		{ base = "mafr_diamondSouth_ob" }
	},

	
	travel_escapeDealer = {
		ONE_WAY = true,
		{ cp = "mafr_dealer_cp",			routeGroup={ "travel", "lrrpRelay" } },
		{ cp = "mafr_diamondSouth_ob",		routeGroup={ "travel", "lrrpRelay" } },
		{ cp = "mafr_diamondSouth_ob" }
	},

}





local spawnList = {
	{ id="Spawn", locator="Vehs_lv_dealer_0001", 		type=Vehicle.type.WESTERN_LIGHT_VEHICLE, paintType=Vehicle.paintType.FOVA_0	},
	{ id="Spawn", locator="Vehs_lv_dealer_0000", 		type=Vehicle.type.WESTERN_LIGHT_VEHICLE, paintType=Vehicle.paintType.FOVA_0	},
	{ id="Spawn", locator="Vehs_lv_hillNorth_0000",	type=Vehicle.type.WESTERN_LIGHT_VEHICLE, paintType=Vehicle.paintType.FOVA_0	},
	{ id="Spawn", locator="Vehs_lv_hillWest_0000", 	type=Vehicle.type.WESTERN_LIGHT_VEHICLE, paintType=Vehicle.paintType.FOVA_0	},
	{ id="Spawn", locator="Vehs_lv_pfCampNorth_0000",	type=Vehicle.type.WESTERN_LIGHT_VEHICLE, paintType=Vehicle.paintType.FOVA_1	},
	{ id="Spawn", locator="Vehs_lv_savannahEast_0000",	type=Vehicle.type.WESTERN_LIGHT_VEHICLE, paintType=Vehicle.paintType.FOVA_1	},	
}

this.vehicleDefine = {
	instanceCount   = #spawnList + 1,
}

this.SpawnVehicleOnInitialize = function()
	TppEnemy.SpawnVehicles( spawnList )
end










function this.Messages()
	return
	StrCode32Table {
		GameObject = {

			{
				msg = "RoutePoint2",
				func = function (id,routeId,routeNode,sendM)
					this.OnRoutePoint(id,routeId,routeNode,sendM)
				end
			},

			{	
				msg = "RouteEventFaild",sender = TARGET_VIP_NAME,--RETAILBUG TARGET_VIP_NAME undefined
				func = function (id,routeId,failType)
					if failType == TppGameObject.ROUTE_EVENT_FAILED_TYPE_VEHICLE_GET_IN then

					end
				end
			},

			
			{
				msg = "GetInEnemyHeli",
				func = function (id,routeId,routeNode,sendM)
					svars.isTakeOff = true
					this.DealerTakeOff()
				end
			},

			

		},
		Timer = {
			{ msg = "Finish",sender = "TranferTimer",func = this.Transfer_StopGo },
			{ 
				msg = "Finish",sender = "CheckHeliLifeTimer",
				func = function()
					local heliId = GameObject.GetGameObjectId("EnemyHeli" )
					local isBroken = GameObject.SendCommand( heliId, { id="IsBroken" } ) 
					if isBroken then
						this.SetDealerRouteForBreakHeli()
					else
						
						GkEventTimerManager.Start( "CheckHeliLifeTimer", 3 )
					end
				end
			},
			nil
		},
		nil
	}
end








this.routeChangeTableRoot[ StrCode32( "rideVehicleInSE" ) ] = {

	{ 	func = function()
			this.UnsetRouteGroup()
			this.SetRelativeVehicle("Vehs_lv_savannahEast_0000")		
			this.TransferCp( MISSION_VIP_GROUP,"travel_toHillWest")
		end
	},
}

this.routeChangeTableRoot[ StrCode32( "arrival_hillWest" ) ] = {

	{ 	func = function()
			svars.VipArea = s10195_sequence.AREA_STATUS.HILL_WEST
			this.Transfer_StopGo()
		end
	},
}

this.routeChangeTableRoot[ StrCode32( "arrival_hillNorth" ) ] = {

	{ 	func = function()
			svars.VipArea = s10195_sequence.AREA_STATUS.HILL_NORTH
			this.Transfer_StopGo()
		end
	},
}


this.routeChangeTableRoot[ StrCode32( "changeVehicle" ) ] = {

	{ 	func = function()
			svars.isChangeVehicle = true
			this.SetRelativeVehicle("Vehs_lv_hillNorth_0000")
		end
	},
}





this.routeChangeTableRoot[ StrCode32( "arrival_meetingArea" ) ] = {

	{ 	func = function()
			svars.VipArea = s10195_sequence.AREA_STATUS.MEETING_AREA
			this.SetVipRoute( "MA_WAIT" )
			this.SetDealerRoute( "MA_TALK" )
		end
	},
}

this.routeChangeTableRoot[ StrCode32( "getout_meetingArea" ) ] = {

	{ 	func = function()
			this.Transfer_StopGo()
		end
	},
}


this.routeChangeTableRoot[ StrCode32( "walkEndMeetingArea" ) ] = {

	{ 	func = function()
			
			TppEnemy.SetSneakRoute( "sol_vip", "rts_vip_meetingNow" )
			TppEnemy.SetSneakRoute( "sol_dealer", "rts_dealer_meetingNew" )
			TppEnemy.SetCautionRoute( "sol_vip", "rts_vip_meetingNow" )
			TppEnemy.SetCautionRoute( "sol_dealer", "rts_dealer_meetingNew" )
			svars.VipArea = s10195_sequence.AREA_STATUS.NOW_MEETING
			
			
			
			if svars.isKnowVIP and not svars.isKnowDealer then
				TppRadio.SetOptionalRadio( "Set_s0195_oprg0030" )
			end
		end
	},
}




this.routeChangeTableRoot[ StrCode32( "startMeeting" ) ] = {

	{ 	func = function()
			local isVipStatus	 = TppEnemy.GetStatus("sol_vip")
			local isDealerStatus = TppEnemy.GetStatus("sol_dealer")

			if isVipStatus == TppGameObject.NPC_STATE_NORMAL and isDealerStatus == TppGameObject.NPC_STATE_NORMAL and svars.isMeeting == false then

				svars.isMeeting = true
				
				this.CallConversation()


			else
				this.SetVipRoute( "MA_RIDE_CAR" )
				this.DealerReturn()	
			end
		end
	},
}


this.routeChangeTableRoot[ StrCode32( "endMeeting" ) ] = {

	{ 	func = function()
			this.SetVipRoute( "MA_RIDE_CAR" )
			this.DealerReturn()	

		end
	},
}


this.routeChangeTableRoot[ StrCode32( "rideVehicleInMA" ) ] = {

	{ 	func = function()
			
			this.UnsetRouteGroup()
			this.TransferCp( MISSION_VIP_GROUP,"travel_toHillNorthBack")

		end
	},
}


this.routeChangeTableRoot[ StrCode32( "CancelMeetingVIP" ) ] = {

	{ 	func = function()

			local travelName

			
			
			if svars.VipArea < s10195_sequence.AREA_STATUS.HILL_WEST then
				travelName = "travel_meetingCancelToSavannahEast"
			
			elseif svars.VipArea < s10195_sequence.AREA_STATUS.NOW_MEETING then
				travelName = "travel_meetingCancelToHillWest"

			else
				travelName = "travel_meetingCancelToHillNorth"
			end

			
			this.UnsetRouteGroup()

			
			this.TransferCp( MISSION_VIP_GROUP,travelName)
		end
	},
}


this.routeChangeTableRoot[ StrCode32( "GuardDiamondSouth" ) ] = {

	{ 	func = function()
		
			if not svars.isArrivalDS then
				svars.isArrivalDS = true
				this.SetDealersRoutesInDiamondSouth()
			end

		end
	},
}









this.routeNameChangeOneSolName = function(routeName)

	local gameObjectId = { type="TppSoldier2" } 
	local command = { id="GetGameObjectIdUsingRoute", route=routeName }
	local soldiers = GameObject.SendCommand( gameObjectId, command )

	if soldiers then
		return soldiers[1]
	else
		return nil
	end
end


this.routeNameChageSolNames = function(routeName)

	local gameObjectId = { type="TppSoldier2" } 
	local command = { id="GetGameObjectIdUsingRoute", route=routeName }
	local soldiers = GameObject.SendCommand( gameObjectId, command )

	return soldiers
end





this.OnRoutePoint = function( gameObjectId, routeId, routeNodeIndex, messageId )

	Fox.Log( "s10195_sequence.OnRoutePoint( gameObjectId:" .. tostring(gameObjectId) .. ", routeId:" .. tostring(routeId) ..
			", routeNodeIndex:" .. tostring(routeNodeIndex) .. ", messageId:" .. tostring(messageId) ..  " )" )

	local routeChangeTables = this.routeChangeTableRoot[ messageId ]
	if routeChangeTables then
		for i, routeChangeTable in ipairs( routeChangeTables ) do
			local enemyNames = {} 

			if routeChangeTable.enemyName then
				enemyNames =  { routeChangeTable.enemyName }
			elseif routeChangeTable.beforeRouteName then
				enemyNames = this.routeNameChageSolNames(routeChangeTable.beforeRouteName)
			end

			local afterRouteName = routeChangeTable.afterRouteName
			if not Tpp.IsTypeTable( afterRouteName ) then
				afterRouteName = { afterRouteName }
			end

			if enemyNames and next( enemyNames ) and afterRouteName and next( afterRouteName ) then

				for i,enemyName in pairs(enemyNames) do
					Fox.Log(enemyName .. " / " .. afterRouteName[i % #afterRouteName +1])

					TppEnemy.SetSneakRoute( enemyName , afterRouteName[i % #afterRouteName +1 ])
					TppEnemy.SetCautionRoute( enemyName , afterRouteName[i % #afterRouteName +1 ])
				end

			else
				Fox.Log( "s10195_sequence.OnRoutePoint(): There is no enemyName or routeId!" )
			end
			if routeChangeTable.func then
				routeChangeTable.func()
			end
		end
	else
		Fox.Log( "s10195_sequence.OnRoutePoint(): There is no routeChangeTables!" )
	end

end


this.SetVipRoute = function( status )
	for index, enemyName in ipairs(MISSION_VIP_GROUP) do
		TppEnemy.SetSneakRoute( enemyName, VIP_ROUTES[status][index] )
		TppEnemy.SetCautionRoute( enemyName, VIP_ROUTES[status][index] )
	end
end


this.UnsetRouteGroup = function()
	for index, enemyName in pairs(MISSION_VIP_GROUP) do
		TppEnemy.UnsetSneakRoute( enemyName )
		TppEnemy.UnsetCautionRoute( enemyName )
	end
end




this.SetDealerRoute = function( status )
	for index, enemyName in pairs(MISSION_DEALER_GROUP) do
		TppEnemy.SetSneakRoute( enemyName, DEALER_ROUTES[status][index] )
		TppEnemy.SetCautionRoute( enemyName, DEALER_ROUTES[status][index] )
	
	end
end




local DEALERS_DIAMONDSOUTH_ROUTES = {
	
	sol_diamondSouth_0000 	= 	"rt_diamondSouth_c_0000",
	sol_diamondSouth_0001 	= 	"rt_diamondSouth_c_0001",
	sol_diamondSouth_0002 	= 	"rt_diamondSouth_c_0002",
	sol_diamondSouth_0003 	= 	"rt_diamondSouth_c_0003",
	sol_dealer_0000 		= 	"rt_diamondSouth_c_0005",
	sol_dealer_0001 		= 	"rt_diamondSouth_c_0006",
	sol_dealer_0002 		= 	"rt_diamondSouth_c_0006",
	sol_dealer_0003 		= 	"rts_diamondSouth_c_0000",
	sol_dealer_0004 		= 	"rts_diamondSouth_c_0001",
	sol_dealer_0005 		= 	"rts_diamondSouth_c_0002",
	sol_dealer_0006 		= 	"rts_diamondSouth_c_0003",
}

this.SetDealersRoutesInDiamondSouth = function()
	Fox.Log("__________s10195_enemy.SetDealersRoutesInDiamondSouth()")
	
	this.TransferCp( MISSION_DEALER_GROUP,"")

	
	TppEnemy.SetSneakRoute	( "sol_dealer", "rts_diamondSouth_escape" )
	TppEnemy.SetCautionRoute( "sol_dealer", "rts_diamondSouth_escape" )
	TppEnemy.SetAlertRoute	( "sol_dealer", "rts_diamondSouth_escape" )

	
	for enemyName, routeName in pairs(DEALERS_DIAMONDSOUTH_ROUTES) do
		TppEnemy.SetSneakRoute( enemyName, routeName )
		TppEnemy.SetCautionRoute( enemyName, routeName )
	end
	
	
	GkEventTimerManager.Start( "CheckHeliLifeTimer", 3 )
	
	
	this.SetHeliRouteDealerInDiamondSouth()
end


this.SetDealerRouteForBreakHeli = function()
	Fox.Log("__________s10195_enemy.SetDealerRouteForBreakHeli()")
	
	
	if not svars.isTakeOff then
		TppEnemy.SetSneakRoute	( "sol_dealer", "rts_diamondSouth_c_0004" )
		TppEnemy.SetCautionRoute( "sol_dealer", "rts_diamondSouth_c_0004" )
		TppEnemy.UnsetAlertRoute( "sol_dealer")
	end
	
	
end


this.TransferCp = function(travelMember,planName)
	Fox.Log("__________s10195_enemy.TransferCp() / PlanName is "..tostring(planName))

	
	local command = { id = "StartTravel", travelPlan = planName }

	
	if not Tpp.IsTypeTable( travelMember ) then
		travelMember = { travelMember }
	end

	if travelMember and next(travelMember) then
		for i,enemyName in pairs(travelMember) do
			local gameObjectId = GameObject.GetGameObjectId(enemyName)
			GameObject.SendCommand( gameObjectId, command )
		end
	end
end



this.Transfer_StopGo = function()

		GkEventTimerManager.Stop( "TranferTimer")

		if svars.VipArea <= svars.PlayerArea then
		
			this.UnsetRouteGroup()
		
			if svars.VipArea == s10195_sequence.AREA_STATUS.HILL_WEST then
				this.TransferCp( MISSION_VIP_GROUP,"travel_toHillNorth")
			elseif svars.VipArea == s10195_sequence.AREA_STATUS.HILL_NORTH then
				this.TransferCp( MISSION_VIP_GROUP,"travel_toMeetingArea")
			elseif svars.VipArea == s10195_sequence.AREA_STATUS.MEETING_AREA then
				this.SetVipRoute( "MA_MOVE" )
			else
				Fox.Log("*** s10195_enemy.lua Transfer_StopGo caution   : ")
			end
		else
			GkEventTimerManager.Start( "TranferTimer", TRANSFER_TIME )
		end

end





this.VipStartMove = function()

	this.SetVipRoute( "SE_MOVE" )
end

this.VipEndMeeting = function()

	this.SetVipRoute( "MA_RIDE_CAR" )

end




this.DealerReturn = function()
	Fox.Log("________________s10195_enemy.DealerReturn")
	
	
	s10195_sequence.OffCheckPointSave()

	
	


	if svars.DelearLifeStatus == TppGameObject.NPC_LIFE_STATE_NORMAL then
	
		this.SetRelativeVehicle("Vehs_lv_dealer_0000")	
		this.SetRelativeVehicle("Vehs_lv_dealer_0001")	
	
		local gameObjectId = GameObject.GetGameObjectId("EnemyHeli" )
		GameObject.SendCommand(gameObjectId, { id="SetSneakRoute", 	route="rts_apr_e_daimondSouth_I_0000" })
		GameObject.SendCommand(gameObjectId, { id="SetCautionRoute",	route="rts_apr_e_daimondSouth_I_0000" })
		
		
		GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })

		
		GameObject.SendCommand( { type="TppVehicle2", },
		{
			id = "RegisterConvoy",
			convoyId =
			{
				GameObject.GetGameObjectId( "TppVehicle2", "Vehs_lv_dealer_0001" ),
				GameObject.GetGameObjectId( "TppVehicle2", "Vehs_lv_dealer_0000" ),
			},
		} )

		this.TransferCp( MISSION_DEALER_GROUP,"travel_escapeDealer")

	
	else

	end
end

this.DealerTakeOff = function()
	Fox.Log("________________s10195_enemy.DealerTakeOff()")
	local gameObjectId = GameObject.GetGameObjectId("EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id="SetSneakRoute", route="rts_rtn_e_daimondSouth_I_0000" })
	GameObject.SendCommand(gameObjectId, { id="SetCautionRoute", route="rts_rtn_e_daimondSouth_I_0000" })
	GameObject.SendCommand(gameObjectId, { id="SetAlertRoute", route="rts_rtn_e_daimondSouth_I_0000" })
	GameObject.SendCommand(gameObjectId, { id="SetRestrictNotice", enabled = true })
	GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })
end

this.SetHeliRouteDealerInDiamondSouth = function()
	Fox.Log("________________s10195_enemy.SetHeliRouteDealerInDiamondSouth()")
	local gameObjectId = GameObject.GetGameObjectId("EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id="SetSneakRoute", 	route="rts_apr_e_daimondSouth_I_0000" })
	GameObject.SendCommand(gameObjectId, { id="SetCautionRoute",	route="rts_apr_e_daimondSouth_I_0000" })
	GameObject.SendCommand(gameObjectId, { id="SetAlertRoute",		route="rts_apr_e_daimondSouth_I_0000" })
	GameObject.SendCommand(gameObjectId, { id="SetRestrictNotice", enabled = true })
	GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })
end


this.FuncRestoreRoute = function()


end





this.SetRelativeVehicle = function(vehicleName)
	for index, enemyName in ipairs(RELACTIVE_VEHICLE_GROUP[vehicleName]) do
		local soldierName = RELACTIVE_VEHICLE_GROUP[vehicleName][index]
		local soldierId = GameObject.GetGameObjectId("TppSoldier2", soldierName )
		local vehicleId = GameObject.GetGameObjectId("TppVehicle2", vehicleName )
		local isMust = false
		if soldierName == "sol_vip" or soldierName == "sol_dealer" then
			isMust = true
		end
		
		local command = { id="SetRelativeVehicle", targetId=vehicleId ,isMust = isMust  }
		GameObject.SendCommand( soldierId, command )
	end
end



this.SetUpRelativeVehicle = function(vehicleName)
	this.SetRelativeVehicle("Vehs_lv_dealer_0000")
	this.SetRelativeVehicle("Vehs_lv_dealer_0001")
	this.SetRelativeVehicle("Vehs_lv_savannahEast_0000")
end


this.SetUpRegisterMessage = function()
	local CHECK_PHASE_MEMBER =	{
		"sol_vip",
		"sol_dealer",
	}
	local command = { id = "RegisterMessage", message="ChangePhase", isRegistered=true }

	for i , enemyName in pairs(CHECK_PHASE_MEMBER) do
		local gameObjectId = GameObject.GetGameObjectId( enemyName )
		GameObject.SendCommand( gameObjectId, command )
	end
end





this.CallConversation = function( speakerGameObjectId, friendGameObjectId, speechLabel )

	Fox.Log("s10195_enemy.CallConversation()")

	local speakerGameObjectId	= "sol_vip"
	local friendGameObjectId	= "sol_dealer"
	local speechLabel = "CT10195_01"


	if Tpp.IsTypeString( speakerGameObjectId ) then
		speakerGameObjectId = GameObject.GetGameObjectId( speakerGameObjectId )
	end
	if Tpp.IsTypeString( friendGameObjectId ) then
		friendGameObjectId = GameObject.GetGameObjectId( friendGameObjectId )
	end

	local command = { id = "CallConversation", label = speechLabel, friend	= friendGameObjectId, }
	GameObject.SendCommand( speakerGameObjectId, command )

end





this.SetUpUniqueStaff = function()
	




	
	
	TppEnemy.AssignUniqueStaffType{
		locaterName = "sol_dealer",
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10195_TARGET,
		alreadyExistParam = { staffTypeId =5, randomRangeId =6, skill =nil },
	}
	
	
	TppEnemy.AssignUniqueStaffType{
		locaterName = "sol_vip",
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10195_TRACER,
		alreadyExistParam = { staffTypeId =3, randomRangeId =6, skill ="GunsmithAssultRifle" },
	}
	
	
	TppEnemy.AssignUniqueStaffType{
		locaterName = "hos_hillNorth",
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10195_HOSTAGE,
		alreadyExistParam = { staffTypeId =3, randomRangeId =6, skill ="MissileHomingEngineer" },
	}
end







this.combatSetting = {

	
	mafr_pfCampNorth_ob = {
		"gt_pfCampNorth_0000",
	},

	mafr_pfCampEast_ob = {
		"gt_pfCampEast_0000",
	},

	mafr_savannahEast_ob = {
		"gt_savannahEast_0000",
	},
	mafr_hillWest_ob = {
		"gt_hillWest_0000",
	},
	mafr_hillNorth_ob = {
		"gt_hillNorth_0000",
		"cs_hillNorth_0000",
	},
	mafr_diamondSouth_ob = {
		"gt_diamondSouth_0000",
	},

	
	mafr_savannah_cp = {
		"gt_savannah_0000",
		"cs_savannah_0000",
	},

	nil
}






this.UniqueInterStart_sol_vip = function( soldier2GameObjectId, cpID )
	Fox.Log("CallBack : Unique : start")

	
	if svars.isCancelMeeting == true then
		if svars.VipInterCount % 2 == 0 then
			TppInterrogation.UniqueInterrogation( cpID, "enqt1000_2g1a10")
		else
			TppInterrogation.UniqueInterrogation( cpID, "enqt1000_2h1a10")
		end
	else
		if svars.VipInterCount % 4 == 0 then
			TppInterrogation.UniqueInterrogation( cpID, "enqt1000_2c1a10")
		elseif svars.VipInterCount % 4 == 1 then
			TppInterrogation.UniqueInterrogation( cpID, "enqt1000_2d1a10")
		elseif svars.VipInterCount % 4 == 2 then
			TppInterrogation.UniqueInterrogation( cpID, "enqt1000_2e1a10")
		else
			TppInterrogation.UniqueInterrogation( cpID, "enqt1000_2f1a10")
		end
	end

	svars.VipInterCount = svars.VipInterCount +1

	return true
end

this.UniqueInterEnd_sol_vip = function( soldier2GameObjectId, cpID )
	Fox.Log("CallBack : Unique : End")
	s10195_sequence.UpdateObjectives("InterVip")
end


this.UniqueInterStart_sol_dealer = function( soldier2GameObjectId, cpID )
	Fox.Log("CallBack : Unique : start")

	if svars.DealerInterCount % 4 == 0 then
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_281a10")
	elseif svars.DealerInterCount % 4 == 1 then
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_291a10")
	elseif svars.DealerInterCount % 4 == 2 then
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_2a1a10")
	else
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_2b1a10")
	end

	svars.DealerInterCount = svars.DealerInterCount +1








	return true
end

this.UniqueInterEnd_sol_dealer = function( soldier2GameObjectId, cpID )
	Fox.Log("CallBack : Unique : End")
	svars.isInfo = true
end

this.InterCall_Hostage = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("_________s10195_enemy.InterCall_Hostage()")
	TppMission.UpdateObjective{
		objectives = { "bonus_Hostage", nil },
	}
end

this.UniqueInterEnd_haven = function( soldier2GameObjectId, cpID )
	Fox.Log("s10195_enemy.UniqueInterEnd_haven : Unique : End")
end


this.uniqueInterrogation = {
	unique = {
		{ name = "enqt1000_2f1a10", func = this.UniqueInterEnd_sol_vip, },
		{ name = "enqt1000_2h1a10", func = this.UniqueInterEnd_sol_vip, },
		{ name = "enqt1000_2b1a10", func = this.UniqueInterEnd_sol_dealer, },
	
		
		{ name = "enqt1000_281a10", func = this.UniqueInterEnd_haven, },	
		{ name = "enqt1000_291a10", func = this.UniqueInterEnd_haven, },	
		{ name = "enqt1000_2a1a10", func = this.UniqueInterEnd_haven, },	
		{ name = "enqt1000_2g1a10", func = this.UniqueInterEnd_haven, },	
		{ name = "enqt1000_2c1a10", func = this.UniqueInterEnd_haven, },	
		{ name = "enqt1000_2d1a10", func = this.UniqueInterEnd_haven, },	
		{ name = "enqt1000_2e1a10", func = this.UniqueInterEnd_haven, },	
				
		nil
	},
	uniqueChara = {
		{ name = "sol_vip", func = this.UniqueInterStart_sol_vip, },
		{ name = "sol_dealer", func = this.UniqueInterStart_sol_dealer, },
		nil
	},
	nil
}


this.interrogation = {
	
	mafr_hillNorth_ob = {
		high = {
			{ name = "enqt1000_1i1210", func = this.InterCall_Hostage, },
			nil
		},
		normal = {
			nil
		},
		nil
	},
	nil
}



this.HighInterrogation = function()
	Fox.Log("*** HighInterrogation ***")
	TppInterrogation.AddHighInterrogation(
		GameObject.GetGameObjectId( "mafr_hillNorth_ob" ),
		{ 
			{ name = "enqt1000_1i1210", func = this.InterCall_Hostage, },
		
		}
	)
end




this.useGeneInter = {
	mafr_savannah_cp = true,	
	mafr_savannahEast_ob = true,	
	mafr_hillWest_ob = true,	
	mafr_hillNorth_ob = true,	
	mafr_diamondSouth_ob = true,	
	nil
}




this.SetUpOB = function()
	local gameObjectId = GameObject.GetGameObjectId( "mafr_dealer_cp" )
	local command = { id = "SetOuterBaseCp" }
	GameObject.SendCommand( gameObjectId, command )
end




this.SetUpCharaMarkingName = function()
	for i,enemyName in ipairs(MISSION_VIP_GROUP) do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyName )
		local command = { id="SetMarkerTextType", type="rc", on=true }
		GameObject.SendCommand( gameObjectId, command )
	end
end





this.SetUpHillNorthHostage = function()
	
	this.SetUpLanguage()
end




this.SetUpLanguage = function()
	local hosID = GameObject.GetGameObjectId( "hos_hillNorth" )
	local cmdSetLangType = { id = "SetLangType", langType="afrikaans" }
	GameObject.SendCommand( hosID, cmdSetLangType )
end







this.InitEnemy = function ()


end



this.SetUpEnemy = function ()
	TppEnemy.RegisterCombatSetting( this.combatSetting )

	
	TppEnemy.SetEliminateTargets(
		{ "sol_dealer","sol_vip"  },
		
		{ exceptMissionClearCheck = { "sol_vip" } }
	)

	
	TppEnemy.RegistHoldRecoveredState("hos_hillNorth")

	this.SetUpRegisterMessage()

	this.SetUpOB()
	
	
	this.HighInterrogation()
	
	this.SetUpUniqueStaff()

	this.SetVipRoute( "SE_STAY" )
	this.SetDealerRoute( "MA_STAY" )


	
	local gameObjectId = GameObject.GetGameObjectId("EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id="SetSneakRoute", route="rts_ptr_e_savannah_E_0000" })
	GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })	
	
	GameObject.SendCommand( gameObjectId, { id="SetCommandPost" , cp="mafr_diamondSouth_ob"})	
		
	this.SetUpCharaMarkingName()
	
	this.SetUpHillNorthHostage()

end


this.OnLoad = function ()
	Fox.Log("*** s10195 onload ***")
end




return this
