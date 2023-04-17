local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local IsTypeFunc = Tpp.IsTypeFunc
local IsTypeTable = Tpp.IsTypeTable
local IsTypeString = Tpp.IsTypeString
local GetGameObjectId = GameObject.GetGameObjectId
local NULL_ID = GameObject.NULL_ID

this.requires = {}

local spawnList = {
        { id = "Spawn", locator = "veh_s10045_0000", type = Vehicle.type.EASTERN_LIGHT_VEHICLE, },		
		{ id = "Spawn", locator = "veh_s10045_0001", type = Vehicle.type.EASTERN_LIGHT_VEHICLE, },		
}

local SOL_WALKERGEAR_NAME = "sol_WG_0000"
local SOL_RECOVERY_NAME = "sol_recovery_0000"
local VIP_NAME = "hos_vip_0000"






this.HOSTAGE_NAME = {
	VIP						= "hos_vip_0000",						
}


this.WALKERGEAR_SOL_LIST = {
	"sol_WG_0000",
	"sol_WG_0001",
	"sol_WG_0002",
	"sol_WG_0003",
}


this.vehicleDefine = {
	instanceCount   = #spawnList + 1,
}





this.soldierDefine = {
	
	
	afgh_Vip_point_cp = {
		"sol_WG_0000",
		"sol_WG_0001",
		"sol_WG_0002",
		"sol_WG_0003",
	},
	
	
	afgh_field_cp = {
		"sol_field_0000",
		"sol_field_0001",
		"sol_field_0002",
		"sol_field_0003",
		"sol_field_0004",
		"sol_field_0005",
		"sol_field_0006",
		"sol_field_0007",
		"sol_field_0008",
		"sol_field_0009",
		"sol_field_0010",
		"sol_field_0011",
		nil
	},
	
	
	afgh_remnants_cp = {
		"sol_recovery_0000",	
		"sol_remnants_0000",
		"sol_remnants_0001",
		"sol_remnants_0002",
		"sol_remnants_0003",
		"sol_remnants_0004",
		"sol_remnants_0005",
		"sol_remnants_0006",
		"sol_remnants_0007",
		"sol_remnants_0008",
		"sol_remnants_0009",
		"sol_remnants_0010",
		"sol_remnants_0011",
		nil
	},
	
	
	afgh_fieldEast_ob = {
		"sol_fieldEast_0000",
		"sol_fieldEast_0001",
		"sol_fieldEast_0002",
		nil
	},
	
	
	afgh_fieldWest_ob = {
		"sol_fieldWest_0000",
		"sol_fieldWest_0001",
		"sol_fieldWest_0002",
		"sol_fieldWest_0003",
		"sol_fieldWest_0004",
		nil
	},
	
	
	afgh_remnantsNorth_ob = {
		"sol_executioner_0000",	
		nil
	},
	
	
	afgh_16_29_lrrp = {
		nil
	},
	
	
	afgh_20_29_lrrp = {
		"sol_20_29_0000",
		"sol_20_29_0001",
		lrrpTravelPlan = "travelfieldWest", 
	},
	
	
	afgh_21_28_lrrp = {
		nil
	},
	
	
	afgh_28_29_lrrp = {
		nil
	},
	
	nil
}


this.soldierPowerSettings = {
        sol_executioner_0000 = {}, 
}






this.USE_COMMON_REINFORCE_PLAN = true





this.routeSets = {
	
	
	afgh_Vip_point_cp = {
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
				"rts_sol_WG_wait_0000",
				"rts_sol_WG_wait_0001",
				"rts_sol_WG_wait_0002",
				"rts_sol_WG_wait_0003",
			},
		},
		sneak_night= {
			groupA = {
				"rts_sol_WG_wait_0000",
				"rts_sol_WG_wait_0001",
				"rts_sol_WG_wait_0002",
				"rts_sol_WG_wait_0003",
			},
		},
		caution = {
			groupA = {
				"rts_sol_WG_wait_0000",
				"rts_sol_WG_wait_0001",
				"rts_sol_WG_wait_0002",
				"rts_sol_WG_wait_0003",
			},
		},
		hold = {
		},
		travel = {
		Vip_point = {
				"rts_Vehicle_travel0002",
			},
			
		Vip_point_back = {
				"rts_Vehicle_travel_b0000",
			},
		},
		nil
	},
	
	
	afgh_field_cp			= { USE_COMMON_ROUTE_SETS = true,	},
	
	
	afgh_remnants_cp = {
		priority = {
			"groupA",
			"groupB",
			"groupC",
		},
		sneak_day = {
			groupA = {
				"rts_sol_recovery_0000",
				"rts_Hutgard_d_0000",
				"rt_remnants_d_0000",
				"rt_remnants_d_0001",
				"rt_remnants_d_0002",
				"rt_remnants_d_0003",
			},
			groupB = {
				"rt_remnants_d_0004",
				"rt_remnants_d_0005",
				"rt_remnants_d_0006",
				"rt_remnants_d_0007",
			},
			groupC = {
				"rt_remnants_d_0008",
				"rt_remnants_d_0009",
				"rt_remnants_d_0010",
				"rt_remnants_d_0011",
			},
		},
		sneak_night= {
			groupA = {
				"rts_sol_recovery_0000",
				"rts_Hutgard_n_0000",
				"rt_remnants_n_0000_sub",
				"rt_remnants_n_0001_sub",
				"rt_remnants_n_0002_sub",
				"rt_remnants_n_0003",
			},
			groupB = {
				"rt_remnants_n_0004",
				"rt_remnants_n_0005",
				"rt_remnants_n_0006_sub",
				"rt_remnants_n_0007",
			},
			groupC = {
				"rt_remnants_n_0008",
				"rt_remnants_n_0009",
				"rt_remnants_n_0010",
				"rt_remnants_n_0011",
			},
		},
		caution = {
			groupA = {
				"rt_remnants_c_0000_sub",
				"rt_remnants_c_0001",
				"rt_remnants_c_0002_sub",
				"rt_remnants_c_0003",
			},
			groupB = {
				"rt_remnants_c_0004",
				"rt_remnants_c_0005",
				"rt_remnants_c_0006_sub",
				"rt_remnants_c_0007",
			},
			groupC = {
				"rt_remnants_c_0008",
				"rt_remnants_c_0009_sub",
				"rt_remnants_c_0010",
				"rt_remnants_c_0011",
			},
		},
		hold = {
			default = {
				"rt_remnants_h_0000",
				"rt_remnants_h_0001",
				"rt_remnants_h_0002",
				"rt_remnants_h_0003",
			},
		},
			
		travel = {
			rideVehicle = {
				"rts_Vehicle_travel0000",
			},
			
			rideVehicle_back = {
				"rts_Vehicle_travel_b0002",
			},
			executioner_travel_03 = {
				"rts_travel_executioner_0002",
			},
		},
		nil
	},

	
	afgh_fieldEast_ob		= { USE_COMMON_ROUTE_SETS = true,	},
	
	
	afgh_fieldWest_ob		= { USE_COMMON_ROUTE_SETS = true,	},
	
	
	afgh_remnantsNorth_ob	= {
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
				"rts_sol_executioner_0000",
			},
		},
		sneak_night= {
			groupA = {
				"rts_sol_executioner_0000",
			},
		},
		caution = {
			groupA = {
				"rts_sol_executioner_0000",
			},
		},
		hold = {
		},
		travel = {
			executioner_travel_01 = {
				"rts_travel_executioner_0000",
			},
		},
		nil
	},
	
	
	afgh_16_29_lrrp			= { USE_COMMON_ROUTE_SETS = true,	},
	
	
	afgh_20_29_lrrp			= { USE_COMMON_ROUTE_SETS = true,	},
	
	
	afgh_21_28_lrrp	= {
	USE_COMMON_ROUTE_SETS = true,
	priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
			},
		},
		sneak_night= {
			groupA = {
			},
		},
		caution = {
			groupA = {
			},
		},
		hold = {
			groupA = {
			},
		},
	
		travel = {
		
			executioner_travel_02 = {
				"rts_travel_executioner_0001",
			},
		},
	},
	
	
	afgh_28_29_lrrp	= { 
	USE_COMMON_ROUTE_SETS = true,
	priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
			},
		},
		sneak_night= {
			groupA = {
			},
		},
		caution = {
			groupA = {
			},
		},
		hold = {
			groupA = {
			},
		},
		travel = {
		
			laap_point = {
				"rts_Vehicle_travel0001",
			},
			
			laap_point_back = {
				"rts_Vehicle_travel_b0001",
			},
		},
		nil
	},
	
	nil
}




this.travelPlans = {
	
	travelfieldWest = {
		{ base = "afgh_fieldWest_ob", },
		{ base = "afgh_field_cp", },
	},
	
	
	travel_recovery = {
		ONE_WAY = true,
		{ cp = "afgh_remnants_cp", 	routeGroup={ "travel", "rideVehicle" }},
		{ cp = "afgh_28_29_lrrp",  routeGroup={ "travel", "laap_point" }},
		{ cp = "afgh_Vip_point_cp", routeGroup={ "travel", "Vip_point" }},
		{ cp = "afgh_Vip_point_cp",},	
	},
	
	
	travel_recovery_back = {
		ONE_WAY = true,
		{ cp = "afgh_Vip_point_cp", routeGroup={ "travel", "Vip_point_back" } },
		{ cp = "afgh_28_29_lrrp", routeGroup={ "travel", "laap_point_back" } },
		{ cp = "afgh_remnants_cp", routeGroup={ "travel", "rideVehicle_back" } },
		{ cp = "afgh_remnants_cp",},
	},
	
	travel_executioner = {
		ONE_WAY = true,
		{ cp = "afgh_remnantsNorth_ob", routeGroup={ "travel", "executioner_travel_01" } },
		{ cp = "afgh_21_28_lrrp", routeGroup={ "travel", "executioner_travel_02" } },
		{ cp = "afgh_remnants_cp", routeGroup={ "travel", "executioner_travel_03" } },
		{ cp = "afgh_remnants_cp",},
	},
}





this.combatSetting = {
afgh_field_cp = {
		USE_COMMON_COMBAT = true,
	},
	afgh_fieldEast_ob = {
		USE_COMMON_COMBAT = true,
	},
	afgh_fieldWest_ob = {
		USE_COMMON_COMBAT = true,
	},
	afgh_remnants_cp = {
		USE_COMMON_COMBAT = true,
	},
	
	afgh_field_cp = {--RETAILBUG: duplicate key, different value
		"gt_field_0000",
		"cs_field_0000",
	},
	afgh_fieldEast_ob = {--RETAILBUG: duplicate key, different value
		"gt_fieldEast_0000",
		"cs_fieldEast_0000",
	},
	afgh_fieldWest_ob = {--RETAILBUG: duplicate key, different value
		"gt_fieldWest_0000",
		"cs_fieldWest_0000",
	},
	afgh_remnants_cp = {--RETAILBUG: duplicate key, different value
		"gt_remnants_0000",
		"cs_remnants_0000",
	},
	nil
}




this.UniqueInterStart_sol_executioner_0000 = function( soldier2GameObjectId, cpID )
	Fox.Log("CallBack : Unique : InterStart_sol_executioner_0000")
		TppInterrogation.UniqueInterrogation( cpID, "sand1000_099067") 

		return true   
end




this.uniqueInterrogation = {
        
        unique = {
                
                { name = "sand1000_099067", func = this.UniqueInterEnd_sol_executioner_0000, },

        },
        
        uniqueChara = {
                { name = "sol_executioner_0000", func = this.UniqueInterStart_sol_executioner_0000, }
        },
}





this.InterCall_targetNextLocation = function( soldier2GameObjectId, cpID, interName )
    Fox.Log("CallBack : InterCall_targetNextLocation")
    TppMission.UpdateObjective{
		objectives = { "area_remnants" }
	}
	s10045_radio.TargetRemnants()
	TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_fieldWest_ob" ),{ { name = "enqt1000_101528", func = this.Interrogation_LocateFlowers},	})
	TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_field_cp" ),{ { name = "enqt1000_101528", func = this.Interrogation_LocateFlowers},	})
	TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_remnants_cp" ),{ { name = "enqt1000_101528", func = this.Interrogation_LocateFlowers},	})

end


this.InterCall_afgh_field_cp = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("CallBack : InterCall_afgh_field_cp")
	TppMission.UpdateObjective{
		objectives = { "on_hostage_00" }
	}
	TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_field_cp" ),{ { name = "enqt1000_1i1210", func = this.InterCall_afgh_field_cp},	})
end

this.InterCall_afgh_remnants_cp = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("CallBack : InterCall_afgh_remnants_cp")
	TppMission.UpdateObjective{
		objectives = { "on_hostage_01" }
	}
	TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_remnants_cp" ),{ { name = "enqt1000_1i1210", func = this.InterCall_afgh_remnants_cp},	})
end





this.interrogation = {
	
	afgh_fieldWest_ob = {
		
		high = {
			{ name = "enqt1000_101528", func = this.InterCall_targetNextLocation, },
		nil
		},
	nil
	},
	afgh_field_cp = {
		
		high = {
			{ name = "enqt1000_101528", func = this.InterCall_targetNextLocation, },
			{ name = "enqt1000_1i1210", func = this.InterCall_afgh_field_cp, },
		nil
		},
	nil
	},
	afgh_remnants_cp = {
		
		high = {
			{ name = "enqt1000_101528", func = this.InterCall_targetNextLocation, },
			{ name = "enqt1000_1i1210", func = this.InterCall_afgh_remnants_cp, },
		nil
		},
	nil
	},
}


this.useGeneInter = {
	
	afgh_field_cp = true,
	afgh_fieldWest_ob = true, 
	afgh_remnants_cp = true,
nil
}





this.SpawnVehicleOnInitialize = function()
        TppEnemy.SpawnVehicles( spawnList )
end


this.InitEnemy = function ()
end



this.SetUpEnemy = function ()
	local obSetCommand = { id = "SetOuterBaseCp" }
	
	GameObject.SendCommand( GameObject.GetGameObjectId( "afgh_Vip_point_cp" ) , obSetCommand ) 

	
	TppEnemy.RegisterCombatSetting( this.combatSetting )
	
	
	TppEnemy.SetRescueTargets( { VIP_NAME } )

	
	
	TppEnemy.RegistHoldRecoveredState( "sol_WG_0000" )
	TppEnemy.RegistHoldRecoveredState( "sol_WG_0001"  )
	TppEnemy.RegistHoldRecoveredState( "sol_WG_0002"  )
	TppEnemy.RegistHoldRecoveredState( "sol_WG_0003"  )
	TppEnemy.RegistHoldRecoveredState( "hos_s10045_0000"  )
	TppEnemy.RegistHoldRecoveredState( "hos_s10045_0001"  )
	TppEnemy.RegistHoldRecoveredState( "sol_recovery_0000"  )
	TppEnemy.RegistHoldRecoveredState( "sol_executioner_0000"  )
	
	
	
	
	this.SetRelativeWalkerGear_00()
	this.SetRelativeWalkerGear_01()
	this.SetRelativeWalkerGear_02()
	this.SetRelativeWalkerGear_03()
	

	
	this.SetRelativeVehicle_recovery()
	this.SetRelativeVehicle_executioner()
	
	
	this.ExecutionerDisable()
	
	this.HostageSetMovingNotice()
	
	this.HostageSetNotice()
	
	this.SetAllEnemyStaffParam()
	
	this.setfova_executioner()
	
	this.DisableDamage()
	
	this.SetVipLangType()
	this.SetHostageLangType00()
	this.SetHostageLangType01()
	
	this.SetVoiceType()
	
	this.SetDisableChatAll()

end


this.OnLoad = function ()
	Fox.Log("*** s10211 onload ***")
end






this.SetDisableChatAll = function ()
	Fox.Log("#### s10030_enemy.SetDisableChatAll ####")
	local gameObjectId = { type="TppCommandPost2" } 
	local command = { id="SetChatEnable", enabled=false } 
	GameObject.SendCommand( gameObjectId, command )
end


this.SetRelativeWalkerGear_00 = function()
	local soldierName = "sol_WG_0000"
	local soldierId = GameObject.GetGameObjectId("TppSoldier2", soldierName )
	local WalkerGearName ="wkr_WalkerGear_0000"
	local WalkerGearId = GameObject.GetGameObjectId("TppCommonWalkerGear2", WalkerGearName )
	local command = { id="SetRelativeVehicle", targetId=WalkerGearId, rideFromBeginning=true }
	GameObject.SendCommand( soldierId, command )
end

this.SetRelativeWalkerGear_01 = function()
	local soldierName = "sol_WG_0001"
	local soldierId = GameObject.GetGameObjectId("TppSoldier2", soldierName )
	local WalkerGearName = "wkr_WalkerGear_0001"
	local WalkerGearId = GameObject.GetGameObjectId("TppCommonWalkerGear2", WalkerGearName )
	local command = { id="SetRelativeVehicle", targetId=WalkerGearId, rideFromBeginning=true }
	GameObject.SendCommand( soldierId, command )
end

this.SetRelativeWalkerGear_02 = function()
	local soldierName = "sol_WG_0002"
	local soldierId = GameObject.GetGameObjectId("TppSoldier2", soldierName )
	local WalkerGearName = "wkr_WalkerGear_0002"
	local WalkerGearId = GameObject.GetGameObjectId("TppCommonWalkerGear2", WalkerGearName )
	local command = { id="SetRelativeVehicle", targetId=WalkerGearId, rideFromBeginning=true }
	GameObject.SendCommand( soldierId, command )
end

this.SetRelativeWalkerGear_03 = function()
	local soldierName = "sol_WG_0003"
	local soldierId = GameObject.GetGameObjectId("TppSoldier2", soldierName )
	local WalkerGearName = "wkr_WalkerGear_0003"
	local WalkerGearId = GameObject.GetGameObjectId("TppCommonWalkerGear2", WalkerGearName )
	local command = { id="SetRelativeVehicle", targetId=WalkerGearId, rideFromBeginning=true }
	GameObject.SendCommand( soldierId, command )
end

this.SetRelativeVehicle_recovery = function()
	local soldierName = "sol_recovery_0000"
	local soldierId = GameObject.GetGameObjectId("TppSoldier2", soldierName )
	local vehicleName = "veh_s10045_0000"
	local vehicleId = GameObject.GetGameObjectId("TppVehicle2", vehicleName )
	local command = { id="SetRelativeVehicle", targetId=vehicleId, rideFromBeginning=true, isMust=true, isVigilance=true }
	GameObject.SendCommand( soldierId, command )
end


this.SetRelativeVehicle_executioner = function()
	local soldierName = "sol_executioner_0000"
	local soldierId = GameObject.GetGameObjectId("TppSoldier2", soldierName )
	local vehicleName = "veh_s10045_0001"
	local vehicleId = GameObject.GetGameObjectId("TppVehicle2", vehicleName )
	local command = { id="SetRelativeVehicle", targetId=vehicleId, rideFromBeginning=true, isMust=true, isVigilance=true }
	GameObject.SendCommand( soldierId, command )
end


this.SetRelativeVehicle_Hostage = function()
	local gameObjectId = GameObject.GetGameObjectId( "hos_vip_0000" )
	local vehicleId = GameObject.GetGameObjectId( "veh_s10045_0000" )
	local command = { id="SetRelativeVehicle", targetId=vehicleId }
	GameObject.SendCommand( gameObjectId, command )
end


this.ExecutionerDisable = function()
	local isSucceeded = GameObject.SendCommand( { type="TppVehicle2", },	
	{
			id                      = "Despawn",
			name            = "veh_s10045_0001",
	} )
	TppEnemy.SetDisable( "sol_executioner_0000" )
end


this.HostageSetMovingNotice = function()
	local gameObjectId = GameObject.GetGameObjectId( "hos_vip_0000" )
	local command = { id = "SetMovingNoticeTrap", enable = true } 
	GameObject.SendCommand( gameObjectId, command )
end


this.HostageSetNotice = function()
	local gameObjectId = GameObject.GetGameObjectId( "hos_vip_0000" )
	local command = { id = "SetNoticeState", state = TppGameObject.HOSTAGE_NOTICE_STATE_FLEE }
	GameObject.SendCommand( gameObjectId, command )
end
this.DisableDamage = function()
	
	local gameObjectId = GameObject.GetGameObjectId( "hos_vip_0000" )
	local command = { id = "SetDisableDamage", life = false, faint = true, sleep = false }
	GameObject.SendCommand( gameObjectId, command )
end

this.Conversation_TargetDiscovered = function( gameObjectId ) 
	local hostageId = GameObject.GetGameObjectId("TppHostage2", "hos_vip_0000")
	GameObject.SendCommand( gameObjectId, {
        id="CallConversation",
        label = "speech045_EV010",
        voiceType="ene_d",
        hostage = hostageId,
	} )
end


this.Conversation_Targetrecovery = function( gameObjectId )
	local friendId = GameObject.GetGameObjectId("TppSoldier2", "sol_recovery_0000")
	GameObject.SendCommand( gameObjectId, {
        id="CallConversation",
        label = "speech045_EV020",
        friend = friendId,
	} )
end


this.CallMonologue = function( speakerId, speechLabel )
	Fox.Log("###########s10041_enemy.CallMonologue()################")

	if Tpp.IsTypeString( speakerId ) then
		speakerId = GameObject.GetGameObjectId( speakerId )
	end
	local command = {
		id="CallMonologue",
		label = speechLabel,
	}
	GameObject.SendCommand( speakerId, command )

end

this.cp_radio_TargetDiscovered = function( gameObjectId )
	local command = { id="CallRadio", label="CPRSP040", stance="Stand",voiceType="ene_d", isHqRadio=false } 
	GameObject.SendCommand( gameObjectId, command ) 
end


this.cp_radio_TargetRecovery = function( gameObjectId )
	local command = { id="CallRadio", label="CPRSP060", stance="Stand", voiceType="ene_d", isHqRadio=false }
	GameObject.SendCommand( gameObjectId, command ) 
end


this.cp_radio_LoseContact = function( gameObjectId )
	local command = { id="CallRadio", label="CPRSP050", stance="Stand", voiceType= "ene_d", isHqRadio=false } 
	GameObject.SendCommand( gameObjectId, command ) 
end


this.hq_radio_ExecutionerSpown = function()
	local gameObjectId = GameObject.GetGameObjectId( "afgh_remnants_cp" )
	local command = { id = "RequestRadio", label="HQSP010", memberId=memberGameObjectId }--RETAILBUG: memberGameObjectId undefined
	GameObject.SendCommand( gameObjectId, command )
end


this.SetNormalCp = function()
	local gameObjectId = GameObject.GetGameObjectId( "afgh_Vip_point_cp" )
	local command = { id = "SetNormalCp" }
	GameObject.SendCommand( gameObjectId, command )
end


this.SetMarchCp = function()
	local obSetCommand = { id = "SetMarchCp" }
	GameObject.SendCommand( GameObject.GetGameObjectId( "afgh_Vip_point_cp" ) , obSetCommand ) 
end
	
this.SetAllEnemyStaffParam = function()
	TppEnemy.AssignUniqueStaffType{
		
        locaterName = "hos_vip_0000",
        uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10045_HOSTAGE_TARGET,
        alreadyExistParam = { staffTypeId =56, randomRangeId =4, skill =nil },
	}
	
	TppEnemy.AssignUniqueStaffType{
		
        locaterName = "sol_executioner_0000",
        uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10045_EXECUTION,
        alreadyExistParam = { staffTypeId =57, randomRangeId =4, skill ="Ninja" },
        
	}
	
	TppEnemy.AssignUniqueStaffType{
		
        locaterName = "hos_s10045_0000",
        uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10045_HOSTAGE_A,
		alreadyExistParam = { staffTypeId =3, randomRangeId =6, skill ="ElectromagneticNetEngineer" },
        
	}
	
	TppEnemy.AssignUniqueStaffType{
		
        locaterName = "hos_s10045_0001",
        uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10045_HOSTAGE_B,
		alreadyExistParam =  { staffTypeId =3, randomRangeId =6, skill ="RocketControlEngineer" },
	}
	
end

this.IsWalkerGearSolider = function( s_gameObjectId )
	for i, enemyName in ipairs( this.WALKERGEAR_SOL_LIST ) do
		local gameObjectId = GameObject.GetGameObjectId( enemyName )
		if s_gameObjectId == gameObjectId then
			return true
		end
	end
	return false
end


this.setfova_executioner = function()
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_executioner_0000" )
	local command = { id = "ChangeSpecialFova", faceIndex=0, bodyIndex=0, balaclavaFaceId=TppEnemyFaceId.svs_balaclava }
	GameObject.SendCommand( gameObjectId, command )
end


this.SetVipLangType = function()
	local gameObjectId = GameObject.GetGameObjectId( "hos_vip_0000" )
	local command = { id = "SetLangType", langType="english" }
	GameObject.SendCommand( gameObjectId, command )
end

this.SetHostageLangType00 = function()
	local gameObjectId = GameObject.GetGameObjectId( "hos_s10045_0000" )
	local command = { id = "SetLangType", langType="russian" }
	GameObject.SendCommand( gameObjectId, command )
end

this.SetHostageLangType01 = function()
	local gameObjectId = GameObject.GetGameObjectId( "hos_s10045_0001" )
	local command = { id = "SetLangType", langType="russian" }
	GameObject.SendCommand( gameObjectId, command )
end


this.SetVoiceType = function()
	local gameObjectId = GameObject.GetGameObjectId( "hos_vip_0000" )
	local command = { id = "SetVoiceType", voiceType = "hostage_a" }
	GameObject.SendCommand( gameObjectId, command )
end


this.GetLifeStatus = function( enemyName )
	if IsTypeString( enemyName ) then
		enemyName = GetGameObjectId( enemyName )
	end
	
	local lifeState = GameObject.SendCommand( enemyName, { id = "GetLifeStatus" } )
	
	return lifeState
end



this.GetStatus = function( enemyName )

	if IsTypeString( enemyName ) then
		enemyName = GetGameObjectId( enemyName )
	end
	
	local Status = GameObject.SendCommand( enemyName, { id = "GetStatus" } )
	
	return Status
end


this.GetWalkerGearSoliderId = function()
	for i, enemyName in ipairs( this.WALKERGEAR_SOL_LIST ) do
		local lifeState = this.GetLifeStatus( enemyName )
		local Status = this.GetStatus( enemyName )
		if lifeState == TppGameObject.NPC_LIFE_STATE_NORMAL and Status == TppGameObject.NPC_STATE_NORMAL then
			return enemyName
		end
	end
	return nil
end


this.GetGameObjectIdUsingRoute = function( routeName )
	local soldiers = GameObject.SendCommand( { type = "TppSoldier2" }, { id = "GetGameObjectIdUsingRoute", route = routeName } )
	return soldiers
end


this.GetGameObjectIdUsingRouteTable = function( routeNameTable )
	if not IsTypeTable( routeNameTable ) then
		routeNameTable = { routeNameTable }
	end
	for i, routeName in ipairs( routeNameTable ) do
		local soldiers = this.GetGameObjectIdUsingRoute( routeName )
		for i, soldier in ipairs( soldiers ) do
			local lifeState = this.GetLifeStatus( soldier )
			local Status = this.GetStatus( soldier )
			if lifeState == TppGameObject.NPC_LIFE_STATE_NORMAL and Status == TppGameObject.NPC_STATE_NORMAL then
				return soldier
			end
		end
	end
	return nil
end




return this
