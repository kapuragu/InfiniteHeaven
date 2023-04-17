local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}







local WALKERGEAR_EQP_MACHINEGUN 	= 0
local WALKERGEAR_EQP_MISSILE 		= 1
local WALKERGEAR_LIFE 				= 6000

local TARGET_HUEY = "TppHuey2GameObjectLocator"


local WALKER_LRRP_GROUP = {
	"sol_walker_lrrp_0000",
	"sol_walker_lrrp_0001",
}


local SOVIETBASE_LRRP_GROUP = {
	"sol_sovietBase_lrrp_0000",
	"sol_sovietBase_lrrp_0001",
}


local SOVIETBASE_WALKER_GROUP = {
	"sol_sovietBase_0003",
	"sol_sovietBase_0006",
}


local WALKER_SEQUENCE = Tpp.Enum{
	"SEQUENCE1",
	"SEQUENCE2",
	"SEQUENCE3",
}

local WALKER_SEQUENCE_ROUTE = {
	{	
		"rts_sovietBase_wkr0_e_0000",
		"rts_sovietBase_wkr1_e_0000",
	},
	{	
		"rts_sovietBase_wkr0_e_0001",
		"rts_sovietBase_wkr1_e_0001",
	},
	{	
		"rts_sovietBase_wkr0_e_0003",
		"rts_sovietBase_wkr1_e_0003",
	},
}





this.USE_COMMON_REINFORCE_PLAN = true





this.walkerGearList = {
	
	{ 			0, 		WALKERGEAR_LIFE, 	WALKERGEAR_EQP_MACHINEGUN,	false,	},
	{ 			1, 		WALKERGEAR_LIFE, 	WALKERGEAR_EQP_MISSILE,		false,	},
	{ 			2, 		WALKERGEAR_LIFE, 	WALKERGEAR_EQP_MACHINEGUN,	false,	},
	{ 			3, 		WALKERGEAR_LIFE, 	WALKERGEAR_EQP_MACHINEGUN,	true,	},	
	nil
}


this.soldierDefine = {
	

	
	
	afgh_sovietBase_cp = {
		
		"sol_sovietBase_0000",
		"sol_sovietBase_0001",
		"sol_sovietBase_0002",
		"sol_sovietBase_0004",
		
		"sol_sovietBase_0005",
		"sol_sovietBase_0007",
		"sol_sovietBase_0008",
		"sol_sovietBase_0009",
		
		"sol_sovietBase_0010",
		"sol_sovietBase_0011",
		"sol_sovietBase_0012",
		"sol_sovietBase_0014",
		
		"sol_sovietBase_0015",
		"sol_sovietBase_0016",
		"sol_sovietBase_0017",
		"sol_sovietBase_0018",
		"sol_sovietBase_0019",

		"sol_sovietBase_0020",
		"sol_sovietBase_0021",

		
		"sol_sovietBase_0003",
		"sol_sovietBase_0006",
		"sol_sovietBase_0013",
		nil
	},
	
	afgh_powerPlant_cp = {
		
		"sol_powerPlant_0000",
		"sol_powerPlant_0001",
		"sol_powerPlant_0002",
		
		"sol_powerPlant_0003",
		"sol_powerPlant_0004",
		"sol_powerPlant_0005",
		
		"sol_powerPlant_0006",
		"sol_powerPlant_0007",
		"sol_powerPlant_0008",
		
		"sol_powerPlant_0009",
		"sol_powerPlant_0010",	
		"sol_powerPlant_0011",	
		
		"sol_powerPlant_0012",
		"sol_powerPlant_0013",
		"sol_powerPlant_0014",	
		nil
	},
	
	
	afgh_plantWest_ob = {
		
		"sol_plantWest_0000",
		"sol_plantWest_0001",
		"sol_plantWest_0002",
		
		nil
	},
	
	afgh_sovietSouth_ob = {
		
		"sol_sovietSouth_0000",
		"sol_sovietSouth_0001",
		"sol_sovietSouth_0002",
		"sol_sovietSouth_0003",
		nil
	},

	
	
	afgh_19_26_lrrp = {
		"sol_powerPlant_lrrp_0000",
		"sol_powerPlant_lrrp_0001",
		lrrpTravelPlan = "travel_powerPlant", 
	},
	
	afgh_27_39_lrrp = {
		"sol_sovietBase_lrrp_0000",
		"sol_sovietBase_lrrp_0001",
		
	},
	afgh_19_39_lrrp = {
		"sol_walker_lrrp_0000",
		"sol_walker_lrrp_0001",
		
	},

	
	
	cp_plantWest_S = {
		"sol_plantWest_S_0000",
		"sol_plantWest_S_0001",
	},
	
	cp_sovietSouth_W = {
		"sol_sovietSouth_W_0000",
		"sol_sovietSouth_W_0001",
		"sol_sovietSouth_W_0002",
	},
	nil
}





this.routeSets = {
	

	
	afgh_sovietBase_cp = {
		priority = {
			"groupSniper",

			"groupA",
			"groupB",
			"groupC",
			"groupD",
		},
		
		fixedShiftChangeGroup = {
			"groupSniper",

		},
		
		walkergearpark = {
			"rts_sovietBase_walkerGearPark0000",
			"rts_sovietBase_walkerGearPark0001",
			"rts_sovietBase_walkerGearPark0002",
		},
		sneak_day = {
			groupSniper = {
				{ "rt_sovietBase_snp_0000", attr = "SNIPER" },
				{ "rt_sovietBase_snp_0001", attr = "SNIPER" },
				{ "rt_sovietBase_snp_0002", attr = "SNIPER" },
			},







			groupA = {
				"rt_sovietBase_d_0000",
				"rt_sovietBase_d_0001",
				"rts_hueyGuard_d_0002",
				"rt_sovietBase_d_0003",
				
			},
			groupB = {
				"rts_hueyGuard_0000",
				"rt_sovietBase_d_0004",
				"rt_sovietBase_d_0016",
				
				"rt_sovietBase_d_0007",
				
			},
			groupC = {
				"rts_hueyGuard_0001",
				"rt_sovietBase_d_0008",
				
				"rts_sovietBase_d_0010",
				"rt_sovietBase_d_0011",
				
			},
			groupD = {
				"rt_sovietBase_d_0012",
				"rt_sovietBase_d_0013",
				"rt_sovietBase_d_0019",
				
				"rt_sovietBase_d_0015",
			},
		},
		sneak_night= {
			groupSniper = {
				{ "rt_sovietBase_snp_0000", attr = "SNIPER" },
				{ "rt_sovietBase_snp_0001", attr = "SNIPER" },
				{ "rt_sovietBase_snp_0002n", attr = "SNIPER" },
			},







			groupA = {
				"rt_sovietBase_n_0000",
				"rt_sovietBase_n_0001",
				"rts_hueyGuard_n_0002",
				
				"rt_sovietBase_n_0016",
			},
			groupB = {
				"rt_sovietBase_n_0004",
				
				"rt_sovietBase_n_0006",
				"rt_sovietBase_n_0009",
				"rt_sovietBase_n_0007",
			},
			groupC = {
				"rts_hueyGuard_0000",
				"rt_sovietBase_n_0008",
				
				"rts_sovietBase_n_0010",
				
				"rt_sovietBase_n_0018",
			},
			groupD = {
				"rts_hueyGuard_0001",
				"rt_sovietBase_n_0012",
				"rt_sovietBase_n_0019",
				
				
				"rt_sovietBase_n_0015",
			},
		},
		caution = {
			groupSniper = {
				{ "rt_sovietBase_snp_0000c", attr = "SNIPER" },
				{ "rt_sovietBase_snp_0001c", attr = "SNIPER" },
				{ "rt_sovietBase_snp_0002c", attr = "SNIPER" },
			},







			groupA = {
				"rts_hueyGuard_c_0000",
				"rts_hueyGuard_c_0001",
				"rt_sovietBase_c_0000",
				"rt_sovietBase_c_0001",
				"rt_sovietBase_c_0002",
				"rt_sovietBase_c_0007",
				"rt_sovietBase_c_0003",
				"rt_sovietBase_c_0004",
				"rt_sovietBase_c_0005",
				"rt_sovietBase_c_0006",
				"rt_sovietBase_c_0009",
				"rts_sovietBase_c_0010",
				"rt_sovietBase_c_0011",
				"rt_sovietBase_c_0019",
				"rt_sovietBase_c_0012",
				"rt_sovietBase_c_0013",
				"rt_sovietBase_c_0014",
				"rt_sovietBase_c_0015",
				"rt_sovietBase_c_0016",
				"rt_sovietBase_c_0017",
				"rt_sovietBase_c_0018",
				"rt_sovietBase_c_0008",

			},
			groupB = {
			},
			groupC = {
			},
			groupD = {
			},
		},
		hold = {
			groupSniper = {},

			default = {
				"rt_sovietBase_h_0000",
				"rt_sovietBase_h_0001",
				"rt_sovietBase_h_0002",
				"rt_sovietBase_h_0003",
				"rt_sovietBase_h_0004",
			},
		},
		sleep = {
			groupSniper = {},

			default = {
				"rt_sovietBase_s_0000",
				"rt_sovietBase_s_0001",
				"rt_sovietBase_s_0002",
				"rt_sovietBase_s_0003",
				"rt_sovietBase_s_0004",
			},
		},
		travel = {
			lrrpHold = {
				"rt_sovietBase_l_0000",
				"rt_sovietBase_l_0001",
			},
			lrrpStart = {
				"rts_sovietBase_l_0000",
				"rts_sovietBase_l_0001",
			}
		},
		outofrain = {
			"rt_sovietBase_r_0000",
			"rt_sovietBase_r_0001",
			"rt_sovietBase_r_0002",
			"rt_sovietBase_r_0003",
			"rt_sovietBase_r_0004",
			"rt_sovietBase_r_0005",
			"rt_sovietBase_r_0006",
			"rt_sovietBase_r_0007",
			"rt_sovietBase_r_0008",
			"rt_sovietBase_r_0009",
			"rt_sovietBase_r_0010",
			"rt_sovietBase_r_0011",
			"rt_sovietBase_r_0012",
			"rt_sovietBase_r_0013",
			"rt_sovietBase_r_0014",
			"rt_sovietBase_r_0015",
			"rt_sovietBase_r_0016",
			"rt_sovietBase_r_0017",
			"rt_sovietBase_r_0018",
			"rt_sovietBase_r_0019",
		},
		nil
	},

	
	afgh_powerPlant_cp = {
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
				{ "rt_powerPlant_snp_0000", attr = "SNIPER" },
				{ "rt_powerPlant_snp_0001", attr = "SNIPER" },
			},
			groupA = {
				"rt_powerPlant_d_0000",
				"rt_powerPlant_d_0005",
				"rts_hunger_d_0000",
			},
			groupB = {
				"rt_powerPlant_d_0001",
				"rt_powerPlant_d_0006",
				"rts_hunger_d_0001",
			},
			groupC = {
				"rt_powerPlant_d_0002",
				"rt_powerPlant_d_0007",
				"rts_powerPlant_d_0000",
			},
			groupD = {
				"rt_powerPlant_d_0003",
				"rt_powerPlant_d_0008",
				"rt_powerPlant_n_0010",
			},
			groupE = {
				"rt_powerPlant_d_0004",
				"rt_powerPlant_d_0009",
				"rt_powerPlant_d_0001",
			},
		},
		sneak_night= {
			groupSniper = {
				{ "rt_powerPlant_snp_0001", attr = "SNIPER" },
				{ "rt_powerPlant_snp_0000", attr = "SNIPER" },
			},
			groupA = {
				"rt_powerPlant_n_0000",
				"rt_powerPlant_n_0005",
				"rts_hunger_d_0000",
			},
			groupB = {
				"rt_powerPlant_n_0001_sub",
				"rt_powerPlant_n_0006",
				"rt_powerPlant_n_0010",
			},
			groupC = {
				"rt_powerPlant_n_0002",
				"rt_powerPlant_n_0010",
				"rts_powerPlant_d_0000",
			},
			groupD = {
				"rt_powerPlant_n_0003",
				"rt_powerPlant_n_0008",
				"rts_hunger_d_0001",
			},
			groupE = {
				"rt_powerPlant_n_0004",
				"rt_powerPlant_n_0009",
				"rt_powerPlant_d_0001",
			},
		},
		caution = {
			groupSniper = {
				{ "rt_powerPlant_snp_0000c", attr = "SNIPER" },
				{ "rt_powerPlant_snp_0001c", attr = "SNIPER" },
			},
			groupA = {
				"rt_powerPlant_c_0004",
				"rt_powerPlant_c_0005",
				"rt_powerPlant_c_0000",
				"rt_powerPlant_c_0001",
				"rt_powerPlant_c_0002",
				"rts_hunger_c_0000",
				"rts_hunger_c_0001",
				"rt_powerPlant_c_0003",
				"rt_powerPlant_c_0006",
				"rt_powerPlant_c_0007",
				"rt_powerPlant_c_0008",
				"rt_powerPlant_c_0009",
				"rt_powerPlant_c_0000",
				"rt_powerPlant_c_0001",
				"rt_powerPlant_c_0002",
				"rt_powerPlant_c_0003",
				"rt_powerPlant_c_0009",
			},
			groupB = {},
			groupC = {},
			groupD = {},
			groupE = {},
		},
		hold = {
			default = {
				"rt_powerPlant_h_0000",
				"rt_powerPlant_h_0001",
				"rt_powerPlant_h_0002",
				"rt_powerPlant_h_0003",
			},
		},
		sleep = {
			default = {
				"rt_powerPlant_s_0000",
				"rt_powerPlant_s_0001",
				"rt_powerPlant_s_0002",
				"rt_powerPlant_s_0003",
			},
		},
		travel = {
			lrrpHold = {
				"rt_powerPlant_l_0000",
				"rt_powerPlant_l_0001",
			},
			in_lrrpHold_S = {
				"rt_powerPlant_lin_S",
				"rt_powerPlant_lin_S",
			},
			out_lrrpHold_B01 = {
				"rt_powerPlant_lout_B01",
				"rt_powerPlant_lout_B01",
			},
			out_lrrpHold_B02 = {
				"rt_powerPlant_lout_B02",
				"rt_powerPlant_lout_B02",
			},
			out_lrrpHold_B03 = {
				"rt_powerPlant_lout_B03",
				"rt_powerPlant_lout_B03",
			},
		},
		outofrain = {
			"rt_powerPlant_r_0000",
			"rt_powerPlant_r_0001",
			"rt_powerPlant_r_0002",
			"rt_powerPlant_r_0003",
			"rt_powerPlant_r_0004",
			"rt_powerPlant_r_0005",
			"rt_powerPlant_r_0006",
			"rt_powerPlant_r_0007",
			"rt_powerPlant_r_0008",
			"rt_powerPlant_r_0009",
			"rt_powerPlant_r_0010",
			"rt_powerPlant_r_0011",
			"rt_powerPlant_r_0012",
			"rt_powerPlant_r_0013",
			"rt_powerPlant_r_0014",
			"rt_powerPlant_r_0015",
		},
	},

	
	afgh_plantWest_ob =  { USE_COMMON_ROUTE_SETS = true,	},
	
	afgh_sovietSouth_ob =  { USE_COMMON_ROUTE_SETS = true,
		travel = {
			lrrpHold_walker = {
				"rts_sovietSouth_l_0000",
				"rts_sovietSouth_l_0001",
			},
		},
	},

	afgh_19_26_lrrp =  { USE_COMMON_ROUTE_SETS = true,	},

	afgh_27_39_lrrp =  { USE_COMMON_ROUTE_SETS = true,
		
		sneak_day = {
			groupA = {
				"rts_sovietBase_l_0000",
				"rts_sovietBase_l_0001",
			},
		},
		sneak_night = {
			groupA = {
				"rts_sovietBase_l_0000",
				"rts_sovietBase_l_0001",
			},
		},
		caution = {
			groupA = {
				"rts_sovietBase_l_0000",
				"rts_sovietBase_l_0001",
			},
		},
		hold = {
			default = {
			},
		},
		travel = {
			lrrp_39to27_walker = {
				"rts_wkr39to27_0000",
				"rts_wkr39to27_0000",
			},
			lrrp_27to39 = {
				"rt_27to39_0000",
				"rt_27to39_0000",
			},
		},
	},

	afgh_19_39_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
		
		sneak_day = {
			groupA = {
				"rts_19to39_d_0000",
				"rts_19to39_d_0001",
			},
		},
		sneak_night = {
			groupA = {
				"rts_19to39_n_0000",
				"rts_19to39_n_0001",
			},
		},
		caution = {
			groupA = {
				"rts_19to39_c_0000",
				"rts_19to39_c_0001",
			},
		},
		hold = {
			default = {
			},
		},
		travel = {
			lrrp_19to39_walker = {
				"rts_wkr19to39_0000",
				"rts_wkr19to39_0000",
			},
		},
	},
	
	cp_plantWest_S = {
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
				"rts_plantWest_S_d_0000",
				"rts_plantWest_S_d_0001",
			},
		},
		sneak_night = {
			groupA = {
				"rts_plantWest_S_n_0000",
				"rts_plantWest_S_n_0001",
			},
		},
		caution = {
			groupA = {
				"rts_plantWest_S_c_0000",
				"rts_plantWest_S_c_0000",
			},
		},
		hold = {
			default = {
			},
		},
		travel = {
		},
	},
	
	cp_sovietSouth_W = {
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
				"rts_sovietSouth_W_d_0000",
				"rts_sovietSouth_W_d_0001",
				"rts_sovietSouth_W_d_0002",
			},
		},
		sneak_night = {
			groupA = {
				"rts_sovietSouth_W_d_0000",
				"rts_sovietSouth_W_d_0001",
				"rts_sovietSouth_W_d_0002",
			},
		},
		caution = {
			groupA = {
				"rts_sovietSouth_W_c_0000",
				"rts_sovietSouth_W_c_0001",
				"rts_sovietSouth_W_c_0001",
			},
		},
		hold = {
			default = {
			},
		},
		travel = {
		},
	},
	nil
}





this.lrrpHoldTime = 15

this.travelPlans = {

	travel_powerPlant = {
		{ cp="afgh_19_26_lrrp", 		routeGroup={ "travel", "lrrp_26to19" } },	
		{ cp="afgh_plantWest_ob", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_19_39_lrrp", 		routeGroup={ "travel", "lrrp_19to39" } },	
		{ cp="afgh_sovietSouth_ob", 	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_27_39_lrrp", 		routeGroup={ "travel", "lrrp_39to27" } },	
		{ cp="afgh_sovietBase_cp", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_27_39_lrrp", 		routeGroup={ "travel", "lrrp_27to39" } },	
		{ cp="afgh_sovietSouth_ob", 	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_19_39_lrrp", 		routeGroup={ "travel", "lrrp_39to19" } },	
		{ cp="afgh_plantWest_ob", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_19_26_lrrp", 		routeGroup={ "travel", "lrrp_19to26" } },	
		{ cp="afgh_powerPlant_cp", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
	},

	travel_sovietBase = {
		
		{ cp="afgh_27_39_lrrp", 		routeGroup={ "travel", "lrrp_27to39" } },	
		{ cp="afgh_sovietSouth_ob", 	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_19_39_lrrp", 		routeGroup={ "travel", "lrrp_39to19" } },	
		{ cp="afgh_plantWest_ob", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_19_26_lrrp", 		routeGroup={ "travel", "lrrp_19to26" } },	
		{ cp="afgh_powerPlant_cp", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_19_26_lrrp", 		routeGroup={ "travel", "lrrp_26to19" } },	
		{ cp="afgh_plantWest_ob", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_19_39_lrrp", 		routeGroup={ "travel", "lrrp_19to39" } },	
		{ cp="afgh_sovietSouth_ob", 	routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
		{ cp="afgh_27_39_lrrp", 		routeGroup={ "travel", "lrrp_39to27" } },	
		{ cp="afgh_sovietBase_cp", 		routeGroup={ "travel", "lrrpHold" },wait=this.lrrpHoldTime },	
	},

	travel_walker = {
		ONE_WAY = true,
		{ cp="afgh_19_39_lrrp", 		routeGroup={ "travel", "lrrp_19to39_walker" } },	
		{ cp="afgh_sovietSouth_ob", 	routeGroup={ "travel", "lrrpHold_walker" },wait=this.lrrpHoldTime },	
		{ cp="afgh_27_39_lrrp", 		routeGroup={ "travel", "lrrp_39to27_walker" } },	
		{ cp="afgh_sovietBase_cp", },
	},

}





this.combatSetting = {
	afgh_sovietBase_cp = {
		
		"gt_sovietBase_0001",
		"cs_sovietBase_0001",
		
		"gt_sovietBase_0000",
		"cs_sovietBase_0000",
		
		"gt_sovietBase_0002",
		"cs_sovietBase_0002",
	},
	afgh_powerPlant_cp = {
		USE_COMMON_COMBAT = true,
	},
	afgh_plantWest_ob = {
		USE_COMMON_COMBAT = true,
	},
	afgh_sovietSouth_ob = {
		USE_COMMON_COMBAT = true,
	},

	nil
}


this.soldierPowerSettings = {
		sol_sovietBase_0005 = { "SNIPER", },
		sol_sovietBase_0008 = { "SNIPER", },
		sol_sovietBase_0021 = { "SNIPER", },
		sol_sovietBase_0007 = { "SOFT_ARMOR", "SHOTGUN", },
		sol_sovietBase_0019 = { "SOFT_ARMOR", "MG", },
		sol_sovietBase_0012 = { "SOFT_ARMOR", "HELMET", },
		sol_sovietBase_0017 = { "SOFT_ARMOR", "HELMET", },
		sol_sovietBase_0000 = { "SOFT_ARMOR", "HELMET", },
		sol_sovietBase_0010 = { "SOFT_ARMOR", "HELMET", },
		sol_powerPlant_0014 = { "SNIPER", },
}


this.disablePowerSettings = {
	"MISSILE",
	"SMG",
}





this.useGeneInter = {
	
	afgh_sovietBase_cp = false,
	afgh_powerPlant_cp = true,
	afgh_plantWest_ob = true,
	afgh_sovietSouth_ob = true,
	nil
}

this.InterCall_huey_pos01 = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("CallBack : InterCall_huey_pos01")

	
	s10070_sequence.GotHueyHungerPos()

end

this.InterCall_huey_pos02 = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("CallBack : InterCall_huey_pos02")

	
	SubtitlesCommand.DisplayText( "[dbg]研究室前の警備は厳重だ・・・", "Default", 3000 )

end



this.interrogation = {

	
	afgh_sovietBase_cp = {
		
		high = {
		
			{ name = "svhy1000_094979", func = this.InterCall_huey_pos01, },
			nil
		},
		nil
	},
	nil
}







this.InitEnemy = function ()
end



this.SetUpEnemy = function ()
	
	TppEnemy.RegisterCombatSetting( this.combatSetting )

	
	this.RegisterCombatAreaSetting()

	this.SetMarchCp("cp_plantWest_S")
	this.SetMarchCp("cp_sovietSouth_W")

	
	for k, v in pairs(this.walkerGearList) do
		this.SetUpWalkergear( v[1], v[2], v[3], v[4] )
	end

	
	this.SetRelativeVehicle( SOVIETBASE_WALKER_GROUP[1], "wkr_s10070_0000")
	this.SetRelativeVehicle( SOVIETBASE_WALKER_GROUP[2], "wkr_s10070_0001")
	this.SetRelativeVehicle( "sol_sovietBase_0013", "wkr_s10070_0002")

	
	this.SetWalkerRoute( WALKER_SEQUENCE.SEQUENCE1 )

	TppEnemy.SetSneakRoute( "sol_sovietBase_0013", "rts_sovietBase_wkr2_d_0000" )	
	TppEnemy.SetCautionRoute( "sol_sovietBase_0013", "rts_sovietBase_wkr2_c_0000" )	





	

	



end


this.OnLoad = function ()
	Fox.Log("*** s10070 onload ***")
end









this.RegisterCombatAreaSetting = function ()

	local gameObjectId = { type="TppCommandPost2" } 

	local combatAreaList = {
		
		area2 = {
			{ guardTargetName="gt_sovietBase_0000", locatorSetName="cs_sovietBase_0000",}, 
		},
		area1 = {
			{ guardTargetName="gt_sovietBase_0001", locatorSetName="cs_sovietBase_0001",},
		},
		area3 = {
			{ guardTargetName="gt_sovietBase_0002", locatorSetName="cs_sovietBase_0002",},
		},
	}

	local command1 = { id = "SetCombatArea", cpName="afgh_sovietBase_cp", combatAreaList=combatAreaList }
	GameObject.SendCommand( gameObjectId, command1 )

	local command2 = { id = "SetUseAreaBalance" }
	GameObject.SendCommand( gameObjectId, command2 )	


end


this.GetGameObjectIdUsingRoute = function( routeName )
	local soldiers = GameObject.SendCommand( { type = "TppSoldier2" }, { id = "GetGameObjectIdUsingRoute", route = routeName } )
	for i, soldier in ipairs( soldiers ) do
		return soldier
	end
	return nil
end

local IsTypeTable = Tpp.IsTypeTable--RETAILFIX:
this.GetGameObjectIdUsingRouteTable = function( routeNameTable )
	if not IsTypeTable( routeNameTable ) then--RETAILBUG: undefined, function not called anyway?
		routeNameTable = { routeNameTable }
	end
	for i, routeName in ipairs( routeNameTable ) do
		local soldiers = this.GetGameObjectIdUsingRoute( routeName )
		for i, soldier in ipairs( soldiers ) do
			return soldier
		end
	end
	return nil
end


this.ChangeRouteHungerGuard = function()
	Fox.Log("*** s10070_enemy02.ChangeRouteHungerGuard ***")

	
	local guard00Id = this.GetGameObjectIdUsingRoute( "rts_hueyGuard_0000" )
	local guard01Id = this.GetGameObjectIdUsingRoute( "rts_hueyGuard_0001" )

	
	if guard00Id ~= nil then
		GameObject.SendCommand( guard00Id, { id = "SetSneakRoute", route = "rts_hueyGuard_1000", } )
	end
	if guard01Id ~= nil then
		GameObject.SendCommand( guard01Id, { id = "SetSneakRoute", route = "rts_sovietBase_d_0010", } )
	end

end



this.SetUpWalkergear = function ( gearIndex, lifeMax, eqpID, spParts )

	local gameObjectId = { type="TppCommonWalkerGear2", index=gearIndex }

	local command1 = { id = "SetMainWeapon", weapon = eqpID }						
	local command2 = { id = "SetMaxLife", life = lifeMax }							

	GameObject.SendCommand( gameObjectId, command1 )

	if spParts == true then
		s10070_sequence.SetUpSPwalkerGear(gameObjectId)
	end

end



this.SetWalkerRoute = function( sequence )
	Fox.Log("*** s10070_enemy02.SetWalkerRoute ***")
	for index, enemyName in pairs(SOVIETBASE_WALKER_GROUP) do
		this.SetAllRoute( enemyName, WALKER_SEQUENCE_ROUTE[sequence][index] )
	end
end

this.UpdateWalkerRoute_Seq2 = function()
	this.SetWalkerRoute( WALKER_SEQUENCE.SEQUENCE2 )
end
this.UpdateWalkerRoute_Seq3 = function()
	this.SetWalkerRoute( WALKER_SEQUENCE.SEQUENCE3 )
end



this.SetAllRoute = function( enemyName, routeName )
	Fox.Log("*** s10070_enemy02.SetAllRoute ***")
	TppEnemy.SetSneakRoute( enemyName, routeName )
	TppEnemy.SetCautionRoute( enemyName, routeName )
	
end


this.TransferCp = function(travelMember,planName)

	
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


this.SetMarchCp = function( cpName )
	Fox.Log("*** s10070_enemy02.SetMarchCp ***"..cpName)
	local gameObjectId = GameObject.GetGameObjectId( cpName )
	local command = { id = "SetMarchCp" }
	GameObject.SendCommand( gameObjectId, command )
end


this.WalkerGearLRRPStart = function()
	Fox.Log("*** s10070_enemy02.WalkerGearLRRPStart ***")

	
	s10070_enemy02.TransferCp( WALKER_LRRP_GROUP,"travel_walker")

end


this.sovietBaseLRRPStart = function()
	Fox.Log("*** s10070_enemy02.sovietBaseLRRPStart ***")

	
	s10070_enemy02.TransferCp( SOVIETBASE_LRRP_GROUP,"travel_sovietBase")

end


this.SetRelativeVehicle = function(soldierName, walkerName)
	Fox.Log("#### s10070_enemy02.SetRelativeVehicle #### soldierName = " ..tostring(soldierName).. ", walkerName = " ..tostring(walkerName))

	local soldierId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
	local walkerId = GameObject.GetGameObjectId( "TppCommonWalkerGear2", walkerName )

	local command = { id = "SetRelativeVehicle", targetId = walkerId, rideFromBeginning = true	}
	GameObject.SendCommand( soldierId, command )

end


this.SwitchChargemode = function(soldierName, flag)
	Fox.Log("#### s10070_enemy02.SwitchChargemode ####")

	local soldierId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
	local command = { id="SetChargeMode", enable = flag }

	if soldierId ~= nil then
		GameObject.SendCommand( soldierId, command )
	end

end






this.CheckUsingRouteName_EnemyHeli = function( routeName )
	Fox.Log("*** s10070_enemy02.CheckUsingRouteName_EnemyHeli ***")

	local gameObjectId = GameObject.GetGameObjectId("EnemyHeli" )
	local usingRoute = GameObject.SendCommand( gameObjectId, { id="GetUsingRoute" } ) 

	if usingRoute == StrCode32(routeName) then
		return true
	else
		return false
	end
end



this.sovietEnemyHeliStart = function()
	Fox.Log("*** s10070_enemy02.sovietEnemyHeliStart ***")

	local gameObjectId = GameObject.GetGameObjectId("EnemyHeli" )
	local heliBroken = GameObject.SendCommand( gameObjectId, { id="IsBroken" } ) 

	
	if heliBroken then
		GameObject.SendCommand(gameObjectId, { id="Recover" })
	end
	
	if this.CheckUsingRouteName_EnemyHeli("rts_ptr_e_powerPlant_0003") then
		this.UpdateEnemyHeliRoute( "rts_ptr_e_sovietBase_1000", "rts_ptr_e_sovietBase_1000" )
	else
		this.ChangeEnableEnemyHeli(false)
	end

end

this.sovietEnemyHeliMove = function()
	Fox.Log("*** s10070_enemy02.sovietEnemyHeliMove ***")

	local gameObjectId = GameObject.GetGameObjectId("EnemyHeli" )
	local heliBroken = GameObject.SendCommand( gameObjectId, { id="IsBroken" } ) 

	
	if heliBroken then
		GameObject.SendCommand(gameObjectId, { id="Recover" })
	end

	this.ChangeEnableEnemyHeli( true )
	this.UpdateEnemyHeliRoute( "rts_ptr_e_sovietBase_1001", "rts_ptr_e_sovietBase_1001" )

end

this.EnemyHeliForceExit = function( routeName )
	Fox.Log("*** s10070_enemy02.EnemyHeliForceExit ***")

	
	local gameObjectId = GameObject.GetGameObjectId("EnemyHeli" )
	if gameObjectId ~= nil then
		GameObject.SendCommand(gameObjectId, { id="SetSneakRoute", route=routeName })
		GameObject.SendCommand(gameObjectId, { id="SetCautionRoute", route=routeName })
		GameObject.SendCommand(gameObjectId, { id="SetAlertRoute", route=routeName })
		GameObject.SendCommand(gameObjectId, { id="SetForceRoute", route=routeName })
	end
end

this.UpdateEnemyHeliRoute = function( sneakRoute, cautionRoute )
	Fox.Log("*** s10070_enemy02.UpdateEnemyHeliRoute ***")

	local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
	if gameObjectId then
		GameObject.SendCommand(gameObjectId, { id="SetSneakRoute", route= sneakRoute })
		GameObject.SendCommand(gameObjectId, { id="SetCautionRoute", route= cautionRoute })
	else
		Fox.Warning("*** UpdateEnemyHeliRoute::gameObject is nil !! ***")
	end
end


this.ChangeEnableEnemyHeli = function( flag )
	Fox.Log("*** s10070_enemy02.ChangeEnableEnemyHeli ***")

	local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
	local heliBroken = false

	if flag == false and gameObjectId then
		
		heliBroken = GameObject.SendCommand( gameObjectId, { id="IsBroken" } ) 
	end

	if gameObjectId and heliBroken == false then
		GameObject.SendCommand(gameObjectId, { id="SetEnabled", enabled= flag })
	else
		Fox.Warning("*** UpdateEnemyHeliRoute::gameObject is nil !! ***")
	end
end






this.SetUpEnemySettingOnEscapeSequence = function()
	Fox.Log("*** s10070_enemy02.SetUpEnemySettingOnEscapeSequence ***")

	local sniperList = { "sol_sovietBase_0005", "sol_sovietBase_0008", }

	for k, soldierName in ipairs( sniperList ) do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
		if gameObjectId ~= nil then
			TppEnemy.ApplyPowerSetting( gameObjectId, { } )
		end
	end

	local riderList = { SOVIETBASE_WALKER_GROUP[1], SOVIETBASE_WALKER_GROUP[2], "sol_sovietBase_0013", }
	local walkerList = { "wkr_s10070_0000", "wkr_s10070_0001", "wkr_s10070_0002", }
	local walkerPosList = {
		{ -2116.389, 441.596, -1748.224 },
		{ -2107.019, 437.588, -1602.937 },
		{ -2207.090, 443.142, -1614.786 },
	}

	for k, soldierName in ipairs( riderList ) do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
		if gameObjectId ~= nil then
			GameObject.SendCommand( gameObjectId, { id = "UnsetRelativeVehicle" } )
			GameObject.SendCommand( gameObjectId, { id="SetEnabled", enabled=false, } )
		end
	end

	for k, walkerName in ipairs( walkerList ) do
		local walkerId = GameObject.GetGameObjectId( "TppCommonWalkerGear2", walkerName )
		if walkerId ~= nil then
			
			local isEnemyRide = GameObject.SendCommand( walkerId, { id = "IsEnemyRiding" } )
			
			
				local command = { id = "SetPosition", pos=walkerPosList[k], rotY=270 }
				GameObject.SendCommand( walkerId, command )
			
		end
	end

end




return this
