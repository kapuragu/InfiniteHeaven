local s10086_enemy = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

s10086_enemy.requires = {}




s10086_enemy.INTERPRETER_NAME =		"sol_interpreter"
s10086_enemy.INTERROGATOR_NAME =	"sol_interrogator"
s10086_enemy.GUARD1_NAME =			"sol_guard1"
s10086_enemy.GUARD2_NAME =			"sol_guard2"
s10086_enemy.GUARD3_NAME =			"sol_guard3"
s10086_enemy.GUARD4_NAME =			"sol_guard4"
s10086_enemy.TARGET_NAME =			"hos_mis_0000"
s10086_enemy.FAKE_TARGET1_NAME =	"hos_mis_0001"
s10086_enemy.FAKE_TARGET2_NAME =	"hos_mis_0002"
s10086_enemy.FAKE_TARGET3_NAME =	"hos_mis_0003"
s10086_enemy.FAKE_TARGETS = { s10086_enemy.FAKE_TARGET1_NAME, s10086_enemy.FAKE_TARGET2_NAME, s10086_enemy.FAKE_TARGET3_NAME }
s10086_enemy.GUARD_TO_HOSTAGE_TABLE = {
	[ s10086_enemy.GUARD1_NAME ] = s10086_enemy.FAKE_TARGET1_NAME,
	[ s10086_enemy.GUARD2_NAME ] = s10086_enemy.FAKE_TARGET2_NAME,
	[ s10086_enemy.GUARD3_NAME ] = s10086_enemy.FAKE_TARGET3_NAME,
	[ s10086_enemy.GUARD4_NAME ] = s10086_enemy.TARGET_NAME,
}





s10086_enemy.soldierDefine = {
	
	mafr_target_ob = {
		s10086_enemy.GUARD4_NAME,
		nil,
	},
	mafr_oe_to_s_lrrp = {
		nil,
	},
	mafr_target_to_s_lrrp = {
		nil,
	},
	
	mafr_swamp_cp = {
		"sol_mis_swamp_0000",
		"sol_mis_swamp_0001",
		"sol_mis_swamp_0002",
		"sol_mis_swamp_0003",
		"sol_mis_swamp_0004",
		"sol_mis_swamp_0005",
		"sol_mis_swamp_0006",
		"sol_mis_swamp_0007",
		"sol_mis_swamp_0008",
		"sol_mis_swamp_0009",
		"sol_mis_swamp_0010",
		"sol_mis_swamp_0011",
		"sol_mis_swamp_0012",
		"sol_mis_swamp_0013",
		"sol_mis_swamp_0014",
		"sol_mis_swamp_0015",
		s10086_enemy.INTERPRETER_NAME,
		s10086_enemy.INTERROGATOR_NAME,
		s10086_enemy.GUARD1_NAME,
		s10086_enemy.GUARD2_NAME,
		s10086_enemy.GUARD3_NAME,
		nil
	},
	mafr_swampWest_ob = {
		"sol_mis_swampWest_0000",
		"sol_mis_swampWest_0001",
		"sol_mis_swampWest_0002",
		"sol_mis_swampWest_0003",
		nil,
	},
	mafr_swampSouth_ob = {
		"sol_mis_swampSouth_0000",
		"sol_mis_swampSouth_0001",
		"sol_mis_swampSouth_0002",
		"sol_mis_swampSouth_0003",
		nil,
	},
	mafr_swampEast_ob = {
		"sol_mis_swampEast_0000",
		"sol_mis_swampEast_0001",
		"sol_mis_swampEast_0002",
		"sol_mis_swampEast_0003",
		nil,
	},
	mafr_outlandEast_ob = {
		"sol_mis_outlandEast_0000",
		"sol_mis_outlandEast_0001",
		"sol_mis_outlandEast_0002",
		nil,
	},
	mafr_05_22_lrrp = {
		"sol_mis_05_22_0000",
		"sol_mis_05_22_0001",
		lrrpTravelPlan = "travel_05_22",
		nil,
	},
	mafr_06_22_lrrp = {
		"sol_mis_06_22_0000",
		"sol_mis_06_22_0001",
		lrrpTravelPlan = "travel_06_22",
		nil,
	},
	nil
}

s10086_enemy.soldierPowerSettings = {
	[ s10086_enemy.INTERPRETER_NAME ] = {},
	[ s10086_enemy.INTERROGATOR_NAME ] = {},
}





s10086_enemy.routeSets = {
	
	mafr_target_ob = {
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
			},
			nil
		},
		sneak_night = {
			groupA = {
			},
			nil
		},
		caution = {
			groupA = {
			},
			nil
		},
		hold = {
			default = {
			},
		},
		nil
	},
	
	mafr_swamp_cp = {
		USE_COMMON_ROUTE_SETS = true,
		priority = {
			"groupSniper",
			"groupA",
			"groupB",
			"groupC",
			"groupSwampNear",
		},
		fixedShiftChangeGroup = {
			"groupSniper",
			"groupSwampNear",
		},
		sneak_day = {
			groupSniper = {
				{ "rt_swamp_snp_0000", attr = "SNIPER" },
				{ "rt_swamp_snp_0001", attr = "SNIPER" },
			},
			groupA = {
				"rt_swamp_d_0003",
				"rt_swamp_d_0006",
				"rt_swamp_d_0009",
				"rt_swamp_d_0012",
				"rt_swamp_d_0015",
				"rt_swamp_d_0018",
			},
			groupB = {
				"rt_swamp_d_0001",
				"rt_swamp_d_0004",
				"rt_swamp_d_0007",
				"rt_swamp_d_0010",
				"rt_swamp_d_0013",
				"rt_swamp_d_0016",
				"rt_swamp_d_0019",
			},
			groupC = {
				"rt_swamp_d_0005",
				"rt_swamp_d_0008",
				"rt_swamp_d_0011",
				"rt_swamp_d_0014",
				"rt_swamp_d_0017",
			},
			groupSwampNear = {	
				"rts_swamp_d_0000",
				"rt_SwampNear_d_0002_no_watchtower_sub",
				"rt_SwampNear_d_0003",
				"rt_SwampNear_d_0004",
			},
		},
		sneak_night= {
			groupSniper = {
				{ "rt_swamp_snp_0000", attr = "SNIPER" },
				{ "rt_swamp_snp_0001", attr = "SNIPER" },
			},
			groupA = {
				"rt_swamp_n_0000",
				"rt_swamp_n_0003_no_searchlight_sub",
				"rt_swamp_n_0006",
				"rt_swamp_n_0009_no_searchlight_sub",
				"rt_swamp_n_0012",
			},
			groupB = {
				"rt_swamp_n_0001_no_searchlight_sub",
				"rt_swamp_n_0004",
				"rt_swamp_n_0007",
				"rt_swamp_n_0010",
				"rt_swamp_n_0013",
			},
			groupC = {
				"rt_swamp_n_0002",
				"rt_swamp_n_0005_no_searchlight_sub",
				"rt_swamp_n_0008_no_searchlight_sub",
				"rt_swamp_n_0011",
				"rt_swamp_n_0014",
			},
			groupSwampNear = {	
				"rt_SwampNear_n_0000_no_searchlight_sub",		
				"rt_SwampNear_n_0001_no_searchlight_sub",		
				"rt_SwampNear_n_0002",
				"rt_SwampNear_n_0003",
				"rt_SwampNear_n_0004",
			},
		},
		caution = {
			groupSniper = {
				{ "rt_swamp_snp_0000", attr = "SNIPER" },
				{ "rt_swamp_snp_0001", attr = "SNIPER" },
			},
			groupA = {
				"rt_swamp_c_0000",
				"rt_SwampNear_c_0000",
				"rt_swamp_c_0001",
				"rt_SwampNear_c_0001_no_searchlight_sub",
				"rt_swamp_c_0002",
				"rt_SwampNear_c_0002",
				"rt_swamp_c_0003",
				"rt_SwampNear_c_0003",
				"rt_swamp_c_0004_no_searchlight_sub",
				"rt_SwampNear_c_0004",
				"rt_swamp_c_0005",
				"rt_swamp_c_0006",
				"rt_swamp_c_0007",
				"rt_swamp_c_0008",
				"rt_swamp_c_0009",
				"rt_swamp_c_0010",
				"rt_swamp_c_0011",
				"rt_swamp_c_0012",
				"rt_swamp_c_0013",
				"rt_swamp_c_0014",
				"rt_swamp_c_0015",
				"rt_swamp_c_0016",
			},
			groupB = {},
			groupC = {},
			groupSwampNear = {},
		},
		hold = {
			
			
			default = {
				"rt_swamp_h_0000",
				"rt_swamp_h_0001",
				"rt_swamp_h_0002",
				"rt_swamp_h_0003",
				"rts_swamp_h_0000",
				"rts_swamp_h_0001",
				"rts_swamp_h_0002",
			},
		},
		sleep = {
			default = {
				"rt_swamp_s_0000",
				"rt_swamp_s_0001",
				"rt_swamp_s_0002",
				"rt_swamp_s_0003",
			},
		},
		nil
	},
	mafr_oe_to_s_lrrp = {
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
			lrrp_oe_to_s = {
				"rts_guard1_to_fake_target1_0000",
			},
		},
	},
	mafr_target_to_s_lrrp = {
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
			lrrp_target_to_s = {
				"rts_target_to_target_0000",
			},
		},
	},
	mafr_swampWest_ob = {
		USE_COMMON_ROUTE_SETS = true,
	},
	mafr_swampSouth_ob = {
		USE_COMMON_ROUTE_SETS = true,
	},
	mafr_swampEast_ob = {
		USE_COMMON_ROUTE_SETS = true,
	},
	mafr_outlandEast_ob = {
		USE_COMMON_ROUTE_SETS = true,
	},
	mafr_05_22_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
	},
	mafr_06_22_lrrp = {
		USE_COMMON_ROUTE_SETS = true,
	},
	nil,
}

s10086_enemy.syncRouteTable = {
	interrogation1 = {
		"rts_guard1_interrogation1_0000",
		"rts_interpreter_interrogation1_0000",
		"rts_interrogator_interrogation1_0000",
	},
	interrogation1_caution = {
		"rts_guard1_interrogation1_c_0000",
		"rts_interpreter_interrogation1_c_0000",
		"rts_interrogator_interrogation1_c_0000",
	},
	interrogation2 = {
		"rts_interpreter_interrogation2_0000",
		"rts_interrogator_interrogation2_0000",
	},
	interrogation2_caution = {
		"rts_interpreter_interrogation2_c_0000",
		"rts_interrogator_interrogation2_c_0000",
	},
	interrogation3 = {
		"rts_interpreter_interrogation3_0000",
		"rts_interrogator_interrogation3_0000",
	},
	interrogation3_caution = {
		"rts_interpreter_interrogation3_c_0000",
		"rts_interrogator_interrogation3_c_0000",
	},
	interrogation4 = {
		"rts_interpreter_interrogation4_0000",
		"rts_interrogator_interrogation4_0000",
	},
	interrogation4_caution = {
		"rts_interpreter_interrogation4_c_0000",
		"rts_interrogator_interrogation4_c_0000",
	},
}




s10086_enemy.travelPlans = {
	travel_05_22 = {
		{ base="mafr_swampSouth_ob", },
		{ base="mafr_swamp_cp", },
	},
	travel_06_22 = {
		{ base="mafr_swampEast_ob", },
		{ base="mafr_swamp_cp", },
	},
	travel_oe_to_s = {
		ONE_WAY = true,
		{ cp = "mafr_oe_to_s_lrrp", routeGroup = { "travel", "lrrp_oe_to_s" } },
		{ cp = "mafr_swamp_cp" },
	},
	travel_target_to_s = {
		ONE_WAY = true,
		{ cp = "mafr_target_to_s_lrrp", routeGroup = { "travel", "lrrp_target_to_s" } },
		{ cp = "mafr_swamp_cp" },
	},
}






s10086_enemy.USE_COMMON_REINFORCE_PLAN = true





s10086_enemy.combatSetting = {
	
	mafr_swamp_cp = {
		"gt_swamp_0000",
		"cs_swamp_0000",
		"gt_swamp_0001",
		"cs_swamp_0001",
	},
	
	mafr_outlandEast_ob = {
		"gt_outlandEast_0000",
	},
	
	mafr_swampEast_ob = {
		"gt_swampEast_0000",
	},
	
	mafr_swampSouth_ob = {
		"gt_swampSouth_0000",
	},
	
	mafr_swampWest_ob = {
		"gt_swampWest_0000",
	},
}




s10086_enemy.UniqueInterStart_Interpreter = function( soldier2GameObjectId, cpId )

	Fox.Log( "s10086_enemy.UniqueInterStart_Interpreter()" )

	local interrogationId
	if svars.interpreterInterrogationCount == 0 then
		interrogationId = "enqt2000_101010"
	elseif svars.interpreterInterrogationCount == 1 then
		interrogationId = "enqt2000_111010"
	elseif svars.interpreterInterrogationCount == 2 then
		interrogationId = "enqt2000_121010"
	else
		Fox.Log( "s10086_enemy.UniqueInterStart_Interpreter(): There is no UniqueInterrogation" )
	end

	if interrogationId then
		TppInterrogation.UniqueInterrogation( cpId, interrogationId )
		svars.interpreterInterrogationCount = svars.interpreterInterrogationCount + 1
	end

	return true

end

s10086_enemy.UniqueInterEnd_Interpreter = function( soldier2GameObjectId, cpId, interName )

	Fox.Log( "s10086_enemy.UniqueInterEnd_Interpreter(): interName:" .. tostring( interName ) )

	if interName == "enqt2000_101010" then	
	elseif interName == "enqt2000_111010" then	
	elseif interName == "enqt2000_121010" then	
		s10086_sequence.OnInterrogationLocationDetected()
	end

	if svars.interpreterInterrogationCount == 1 then
		s10086_sequence.OnInterpreterInterrogated()
	elseif svars.interpreterInterrogationCount > 2 then
		s10086_radio.OnInterpreterInterrogated()
	end

end

s10086_enemy.uniqueInterrogation = {
	unique = {	
		{ name = "enqt2000_101010", func = s10086_enemy.UniqueInterEnd_Interpreter, },
		{ name = "enqt2000_111010", func = s10086_enemy.UniqueInterEnd_Interpreter, },
		{ name = "enqt2000_121010", func = s10086_enemy.UniqueInterEnd_Interpreter, },
		nil
	},
	uniqueChara = {	
		{ name = s10086_enemy.INTERPRETER_NAME, func = s10086_enemy.UniqueInterStart_Interpreter, },
		nil
	},
	nil
}

s10086_enemy.useGeneInter = {
	mafr_swamp_cp = true,
	mafr_swamp_vip_cp = false,
	nil,
}

s10086_enemy.InterCall_Intel = function( soldier2GameObjectId, cpID, interName )

	Fox.Log( "s10086_enemy.InterCall_Intel()" )

	TppMission.UpdateObjective{ objectives = { "marker_intel", }, }

	TppInterrogation.RemoveHighInterrogation(
		GameObject.GetGameObjectId( "mafr_swamp_cp" ),
		{
			{ name = "enqt1000_101524", func = s10086_enemy.InterCall_Intel, },
		}
	)

end

s10086_enemy.interrogation = {
	
	mafr_swamp_cp = {
		high = {	
			{ name = "enqt1000_101524", func = s10086_enemy.InterCall_Intel, },
			nil
		},
		nil
	},
	nil
}




s10086_enemy.CallConversation = function( speakerGameObjectId, friendGameObjectId, speechLabel )

	Fox.Log("s10086_enemy.CallConversation(): speakerGameObjectId:" .. tostring( speakerGameObjectId ) .. ", friendGameObjectId:" .. tostring( friendGameObjectId )
		.. ", speechLabel:" .. tostring( speechLabel ) )

	if Tpp.IsTypeString( speakerGameObjectId ) then
		speakerGameObjectId = GameObject.GetGameObjectId( speakerGameObjectId )
	end
	if Tpp.IsTypeString( friendGameObjectId ) then
		friendGameObjectId = GameObject.GetGameObjectId( friendGameObjectId )
	end

	local hostage
	if Tpp.IsHostage( friendGameObjectId ) then
		hostage = friendGameObjectId
		friendGameObjectId = nil
	end

	Fox.Log("s10086_enemy.CallConversation(): speakerGameObjectId:" .. tostring( speakerGameObjectId ) .. ", friendGameObjectId:" .. tostring( friendGameObjectId )
		.. ", speechLabel:" .. tostring( speechLabel ) .. ", hostage:" .. tostring( hostage ) )

	local command = { id = "CallConversation", label = speechLabel, friend	= friendGameObjectId, hostage = hostage }
	GameObject.SendCommand( speakerGameObjectId, command )

end





s10086_enemy.CallConversationCondition = function( speakerGameObjectId, friendGameObjectId, speechLabel, checkFunc )

	Fox.Log( "s10086_enemy.CallConversationCondition()" )

	if checkFunc() then
		Fox.Log( "s10086_enemy.CallConversationCondition(): start conversation" )
		s10086_enemy.CallConversation( speakerGameObjectId, friendGameObjectId, speechLabel )
	else
		Fox.Log( "s10086_enemy.CallConversationCondition(): ignore process" )
	end

end




s10086_enemy.CallMonologue = function( speakerId, speechLabel, friendId )

	Fox.Log("s10086_enemy.CallMonologue(): speakerId:" .. tostring( speakerId ) .. ", speechLabel:" .. tostring( speechLabel ) .. ", friendId:" .. tostring( friendId ) )

	if not speakerId then
		return
	end

	if Tpp.IsTypeString( speakerId ) then
		speakerId = GameObject.GetGameObjectId( speakerId )
	end

	if not friendId then
		friendId = speakerId
	else
		friendId = GameObject.GetGameObjectId( friendId )
	end

	local command
	if Tpp.IsHostage( speakerId ) then
		command = { id="CallMonologue", label = speechLabel, }
	else
		command = { id = "CallConversation", label = speechLabel, friend = speakerId, }
	end
	GameObject.SendCommand( speakerId, command )

	mvars.currentMonologueTable[ speakerId ] = speechLabel

end





local spawnList = {
	{ id = "Spawn", locator = "veh_s10086_0000", type = Vehicle.type.WESTERN_LIGHT_VEHICLE, paintType = Vehicle.paintType.FOVA_0, },
	{ id = "Spawn", locator = "veh_s10086_0001", type = Vehicle.type.WESTERN_LIGHT_VEHICLE, paintType = Vehicle.paintType.FOVA_0, },
	{ id = "Spawn", locator = "veh_s10086_0002", type = Vehicle.type.WESTERN_LIGHT_VEHICLE, paintType = Vehicle.paintType.FOVA_0, },
}

s10086_enemy.vehicleDefine = {
	instanceCount = 4,
}






s10086_enemy.InitEnemy = function ()

	Fox.Log( "s10086_enemy.InitEnemy()" )

end




s10086_enemy.SetVehicleRelativity = function( vehicleName, npcName, rideFromBeginning, isMust )

	local npcId = GameObject.GetGameObjectId( npcName )
	local vehicleId = GameObject.GetGameObjectId( "TppVehicle2", vehicleName )
	local command = { id = "SetRelativeVehicle", targetId = vehicleId , rideFromBeginning = rideFromBeginning, isMust = isMust,  }
	GameObject.SendCommand( npcId, command )

end



s10086_enemy.SetUpEnemy = function ()

	Fox.Log("*** s10086_enemy.SetUpEnemy() ***")

	TppEnemy.RegisterCombatSetting( s10086_enemy.combatSetting )

	
	local gameObjectId = { type="TppCommandPost2" } 
	
	local combatAreaList = {
		area1 = {
			{ guardTargetName="gt_swamp_0000", locatorSetName="cs_swamp_0000",}, 
		},
		area2 = {
			{ guardTargetName="gt_swamp_0001", locatorSetName="cs_swamp_0001",},
		},
	}
	local command = { id = "SetCombatArea", cpName = "mafr_swamp_cp", combatAreaList = combatAreaList }
	GameObject.SendCommand( gameObjectId, command )

	TppEnemy.SetRescueTargets{ s10086_enemy.TARGET_NAME }

	
	s10086_enemy.ChangeVipRouteToMorning()

	
	for i, command in ipairs( spawnList ) do
		GameObject.SendCommand( { type = "TppVehicle2", }, command )
	end

	s10086_enemy.SetVehicleRelativity( "veh_s10086_0000", s10086_enemy.GUARD1_NAME, true, true )
	s10086_enemy.SetVehicleRelativity( "veh_s10086_0000", s10086_enemy.FAKE_TARGET1_NAME )
	s10086_enemy.SetVehicleRelativity( "veh_s10086_0001", s10086_enemy.INTERPRETER_NAME, false, true )
	s10086_enemy.SetVehicleRelativity( "veh_s10086_0001", s10086_enemy.INTERROGATOR_NAME, false, true )

	TppEnemy.RegistHoldRecoveredState( s10086_enemy.TARGET_NAME )
	TppEnemy.RegistHoldRecoveredState( s10086_enemy.FAKE_TARGET1_NAME )
	TppEnemy.RegistHoldRecoveredState( s10086_enemy.FAKE_TARGET2_NAME )
	TppEnemy.RegistHoldRecoveredState( s10086_enemy.FAKE_TARGET3_NAME )
	TppEnemy.RegistHoldRecoveredState( s10086_enemy.INTERPRETER_NAME )

	
	TppEnemy.AssignUniqueStaffType{
		locaterName = s10086_enemy.TARGET_NAME,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10086_HOSTAGE_A,
		alreadyExistParam = { staffTypeId = 6, randomRangeId = 6, skill = "BigMouth", },
	}
	TppEnemy.AssignUniqueStaffType{
		locaterName = s10086_enemy.FAKE_TARGET1_NAME,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10086_HOSTAGE_B,
		alreadyExistParam = { staffTypeId = 43, randomRangeId = 4, skill = nil, },
	}
	TppEnemy.AssignUniqueStaffType{
		locaterName = s10086_enemy.FAKE_TARGET2_NAME,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10086_HOSTAGE_C,
		alreadyExistParam = { staffTypeId = 42, randomRangeId = 4, skill = "MaterialEngineer", },
	}
	TppEnemy.AssignUniqueStaffType{
		locaterName = s10086_enemy.FAKE_TARGET3_NAME,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10086_HOSTAGE_D,
		alreadyExistParam = { staffTypeId = 44, randomRangeId = 4, skill = "Zoologist", },
	}
	TppEnemy.AssignUniqueStaffType{
		locaterName = s10086_enemy.INTERPRETER_NAME,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10086_INTERPRETER,
		alreadyExistParam = { staffTypeId = 5, randomRangeId = 6, skill = "TranslateAfrikaans", },
	}

	
	do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", s10086_enemy.INTERROGATOR_NAME )
		GameObject.SendCommand( gameObjectId, { id = "SetVipSpecial" } )
		GameObject.SendCommand( gameObjectId, { id = "SetVoiceType", voiceType="ene_b" } )
	end

	do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", s10086_enemy.INTERPRETER_NAME )
		GameObject.SendCommand( gameObjectId, { id = "SetVipSpecial" } )
		GameObject.SendCommand( gameObjectId, { id = "SetVoiceType", voiceType="ene_a" } )
	end

	do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", s10086_enemy.GUARD1_NAME )
		GameObject.SendCommand( gameObjectId, { id = "SetVoiceType", voiceType="ene_c" } )
	end

	do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", s10086_enemy.GUARD2_NAME )
		GameObject.SendCommand( gameObjectId, { id = "SetVoiceType", voiceType="ene_a" } )
	end

	do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", s10086_enemy.GUARD3_NAME )
		GameObject.SendCommand( gameObjectId, { id = "SetVoiceType", voiceType="ene_b" } )
	end

	do
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", s10086_enemy.GUARD4_NAME )
		GameObject.SendCommand( gameObjectId, { id = "SetVoiceType", voiceType="ene_d" } )
	end

	
	do
		local gameObjectId = GameObject.GetGameObjectId( s10086_enemy.TARGET_NAME )
		GameObject.SendCommand( gameObjectId, { id = "SetVoiceType", voiceType = "hostage_c" } )
		GameObject.SendCommand( gameObjectId, { id = "SetLangType", langType="english", } )
	end
	do
		local gameObjectId = GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET1_NAME )
		GameObject.SendCommand( gameObjectId, { id = "SetVoiceType", voiceType = "hostage_a" } )
		GameObject.SendCommand( gameObjectId, { id = "SetLangType", langType="english", } )
	end
	do
		local gameObjectId = GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET2_NAME )
		GameObject.SendCommand( gameObjectId, { id = "SetVoiceType", voiceType = "hostage_b" } )
		GameObject.SendCommand( gameObjectId, { id = "SetLangType", langType="english", } )
	end
	do
		local gameObjectId = GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET3_NAME )
		GameObject.SendCommand( gameObjectId, { id = "SetVoiceType", voiceType = "hostage_d" } )
		GameObject.SendCommand( gameObjectId, { id = "SetLangType", langType="english", } )
	end

	local voiceTable = {
		"CT10086_02_004", 
		"CT10086_02_007", 
		"CT10086_02_008", 
		"CT10086_02_011", 
		"CT10086_02_012", 
		"CT10086_02_015", 
		"CT10086_02_017", 
		"CT10086_02_019", 
		"CT10086_02_020", 
		"CT10086_02_023", 
		"CT10086_02_024", 
		"CT10086_03_002", 
		"CT10086_03_004", 
		"CT10086_03_005", 
		"CT10086_03_007", 
		"CT10086_03_009", 
		"CT10086_03_010", 
		"CT10086_03_011", 
		"CT10086_03_013", 
		"CT10086_03_016", 
		"CT10086_03_018", 
		"CT10086_03_019", 
		"CT10086_03_020", 
		"CT10086_03_024", 
		"CT10086_03_025", 
		"CT10086_03_026", 
		"CT10086_03_004", 
		"CT10086_03_103", 
		"CT10086_03_009", 
		"CT10086_03_010", 
		"CT10086_03_011", 
		"CT10086_03_013", 
		"CT10086_03_016", 
		"CT10086_03_018", 
		"CT10086_03_024", 
		"CT10086_03_025", 
		"CT10086_03_004", 
		"CT10086_03_104", 
		"CT10086_03_107", 
		"CT10086_03_009", 
		"CT10086_03_108", 
		"CT10086_03_020", 
		"CT10086_03_024", 
		"CT10086_03_110", 
		"CT10086_04_002", 
		"CT10086_04_003", 
		"CT10086_04_006", 
		"CT10086_04_007", 
		"CT10086_04_010", 
		"CT10086_04_012", 
		"CT10086_04_014", 
		"CT10086_04_015", 
		"CT10086_04_017", 
		"CT10086_04_020", 
		"CT10086_04_021", 
		"CT10086_04_023", 
		"CT10086_04_026", 
		"CT10086_04_027", 
	}
	TppSoldier2.SetEnglishVoiceIdTable{ voice = voiceTable }

end


s10086_enemy.OnLoad = function ()

	Fox.Log("*** s10086_enemy.OnLoad() ***")

end




s10086_enemy.MoveCommandPost = function( soldierList, travelPlan )

	if not Tpp.IsTypeTable( soldierList ) then
		soldierList = { soldierList }
	end

	for i, soldierName in ipairs( soldierList ) do
		local gameObjectId
		if Tpp.IsTypeString( soldierName ) then
			gameObjectId = GameObject.GetGameObjectId( soldierName )
		else
			gameObjectId = soldierName
		end
		local command = { id = "StartTravel", travelPlan = travelPlan }
		GameObject.SendCommand( gameObjectId, command )
	end

end




s10086_enemy.ChangeEnemyRoutes = function( routeTables )

	for enemyName, routeTable in pairs( routeTables ) do
		if routeTable.sneakRouteId then
			TppEnemy.SetSneakRoute( enemyName, routeTable.sneakRouteId, routeTable.sneakRouteNodeIndex )
		end
		if routeTable.cautionRouteId then
			s10086_enemy.SetCautionRoute( enemyName, routeTable.cautionRouteId, routeTable.cautionRouteNodeIndex )
		end
	end

end




s10086_enemy.ChangeVipRouteToMorning = function()

	Fox.Log( "s10086_enemy.ChangeVipRouteToMorning()" )

	local routeTables = {
		[ s10086_enemy.INTERPRETER_NAME ] = { sneakRouteId = "rts_interpreter_to_fake_target1_0000", cautionRouteId = "rts_interpreter_to_fake_target1_c_0000", },
		[ s10086_enemy.INTERROGATOR_NAME ] = { sneakRouteId = "rts_interrogator_to_fake_target1_0000", cautionRouteId = "rts_interrogator_to_fake_target1_c_0000", },
		[ s10086_enemy.GUARD2_NAME ] = { sneakRouteId = "rts_guard2_wait_0000", cautionRouteId = "rts_guard2_wait_c_0000", },
		[ s10086_enemy.GUARD3_NAME ] = { sneakRouteId = "rts_guard3_wait_0000", cautionRouteId = "rts_guard3_wait_c_0000", },
		[ s10086_enemy.GUARD4_NAME ] = { sneakRouteId = "rts_guard4_wait_0000", cautionRouteId = "rts_guard4_wait_c_0000", },
	}
	s10086_enemy.ChangeEnemyRoutes( routeTables )

	
	
	TppEnemy.SetSneakRoute( s10086_enemy.GUARD1_NAME, "rts_guard1_to_fake_target1_0000" )
	s10086_enemy.SetCautionRoute( s10086_enemy.GUARD1_NAME, "rts_guard1_to_fake_target1_0000" )

	
	

end




s10086_enemy.ChangeInterrogatorsRoute = function()

	Fox.Log( "s10086_enemy.ChangeInterrogaterRoute" )

	local routeTables = {
		[ s10086_enemy.INTERPRETER_NAME ] = { sneakRouteId = "rts_interpreter_to_fake_target4_0000", sneakRouteNodeIndex = svars.reservedNumber0000, cautionRouteId = "rts_interpreter_to_fake_target4_c_0000", },
		[ s10086_enemy.INTERROGATOR_NAME ] = { sneakRouteId = "rts_interpreter_to_fake_target4_0000", sneakRouteNodeIndex = svars.reservedNumber0000, cautionRouteId = "rts_interpreter_to_fake_target4_c_0000", },
	}
	s10086_enemy.ChangeEnemyRoutes( routeTables )

end




s10086_enemy.ChangeVipRouteToNight = function()

	Fox.Log( "s10086_enemy.ChangeVipRouteToNight()" )

	local soldierOnSneakRouteList = GameObject.SendCommand( { type="TppSoldier2", }, { id = "GetGameObjectIdUsingRoute", route = "rts_interpreter_to_fake_target3_0000", } )
	local soldierOnCautionRouteList = GameObject.SendCommand( { type="TppSoldier2", }, { id = "GetGameObjectIdUsingRoute", route = "rts_interpreter_to_fake_target3_c_0000", } )
	if #soldierOnSneakRouteList == 0 and #soldierOnCautionRouteList == 0 then
		s10086_enemy.ChangeInterrogatorsRoute()
	end

	GkEventTimerManager.Start( "Timer_WaitInterpreter", 1200 )
	GkEventTimerManager.Start( "Timer_WaitInterrogator", 1200 )

	
	local noticeState = GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.TARGET_NAME ), { id = "GetNoticeState" } )
	if noticeState == TppGameObject.HOSTAGE_NOTICE_STATE_NORMAL then
		s10086_enemy.MoveCommandPost( s10086_enemy.GUARD4_NAME, "travel_target_to_s" )
		GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.TARGET_NAME ), { id = "SetFollowed", enable = true, } )
		TppEnemy.SetSneakRoute( s10086_enemy.TARGET_NAME, "rts_target_to_target_0000" )
	end

end




s10086_enemy.ExecuteHostage = function( soldierId, hostageId )

	Fox.Log( "s10086_enemy.ExecuteHostage()" )

	if Tpp.IsTypeString( soldierId ) then
		soldierId = GameObject.GetGameObjectId( soldierId )
	end
	if Tpp.IsTypeString( hostageId ) then
		hostageId = GameObject.GetGameObjectId( hostageId )
	end

	if s10086_enemy.GetNoticeState( hostageId ) == TppGameObject.HOSTAGE_NOTICE_STATE_NORMAL then
		Fox.Log( "s10086_enemy.ExecuteHostage(): Execute Hostage" )
		local command = { id = "SetExecuteHostage", targetId = hostageId }
		GameObject.SendCommand( soldierId, command )
	end

end







function s10086_enemy.IsFakeTarget( gameObjectId )

	Fox.Log( "s10086_enemy.IsFakeTarget()" )

	if Tpp.IsTypeString( gameObjectId ) then
		gameObjectId = GameObject.GetGameObjectId( gameObjectId )
	end

	for i, name in ipairs( s10086_enemy.FAKE_TARGETS ) do
		if	gameObjectId == GameObject.GetGameObjectId( name ) then
			Fox.Log( "s10086_enemy.IsFakeTarget(): found gameObjectId in FAKE_TARGETS." )
			return true
		end
	end

	return false

end







s10086_enemy.GetFakeTargetName = function( gameObjectId )

	for i, fakeTargetName in ipairs( s10086_enemy.FAKE_TARGETS ) do
		if gameObjectId == GameObject.GetGameObjectId( fakeTargetName ) then
			return fakeTargetName
		end
	end

	return nil

end





s10086_enemy.ChangeHostageRoute = function( hostageId, routeId, guardSoldierId )

	if not hostageId or not routeId then
		Fox.Error( "s10086_enemy.ChangeHostageRoute(): INVALID ARGUMENT!" )
		return
	end

	if Tpp.IsTypeString( hostageId ) then
		hostageId = GameObject.GetGameObjectId( hostageId )
	end

	if not guardSoldierId or s10086_enemy.IsEnemyNormal( guardSoldierId ) then

		Fox.Log( "s10086_enemy.ChangeHostageRoute( hostageId:" .. hostageId .. ", routeId:" .. routeId .. " )" )

		local command = {
			id = "SetSneakRoute",
			route = routeId,
		}
		GameObject.SendCommand( hostageId, command )

	else
		Fox.Log( "s10086_enemy.ChangeHostageRoute(): Ignore to change route because GuardSoldier is abnormal state." )
	end

end







s10086_enemy.GetNpcName = function( gameObjectId )

	Fox.Log( "s10086_enemy.GetNpcName(): gameObjectId:" .. tostring( gameObjectId ) )

	local name = s10086_enemy.GetFakeTargetName( gameObjectId )
	if name then
		return name
	end
	if gameObjectId == GameObject.GetGameObjectId( s10086_enemy.TARGET_NAME ) then
		return s10086_enemy.TARGET_NAME
	end
	if gameObjectId == GameObject.GetGameObjectId( s10086_enemy.INTERPRETER_NAME ) then
		return s10086_enemy.INTERPRETER_NAME
	end

	return nil

end




s10086_enemy.IsEnemyNormal = function( gameObjectIdList )

	Fox.Log( "s10086_enemy.IsEnemyNormal()" )

	if not Tpp.IsTypeTable( gameObjectIdList ) then
		gameObjectIdList = { gameObjectIdList }
	end

	for i, gameObjectId in ipairs( gameObjectIdList ) do
		Fox.Log( "s10086_enemy.IsEnemyNormal(): gameObjectId:" .. gameObjectId )

		if Tpp.IsTypeString( gameObjectId ) then
			gameObjectId = GameObject.GetGameObjectId( gameObjectId )
		end

		local lifeStatus = TppEnemy.GetLifeStatus( gameObjectId )
		Fox.Log( "s10086_enemy.IsEnemyNormal(): lifeStatus:" .. lifeStatus )
		if lifeStatus ~= TppGameObject.NPC_LIFE_STATE_NORMAL then
			return false
		end

		if s10086_sequence.IsRecovered( gameObjectId ) then
			return false
		end
	end

	return true

end




s10086_enemy.IsEnemyOnRoute = function( soldierId, routeName )

	Fox.Log( "s10086_enemy.IsEnemyOnRoute(): soldierId:" .. tostring( soldierId ) .. ", routeName:" .. tostring( routeName ) )

	if Tpp.IsTypeString( soldierId ) then
		soldierId = GameObject.GetGameObjectId( soldierId )
	end

	if not Tpp.IsSoldier( soldierId ) then
		return true
	end

	local gameObjectId = { type = "TppSoldier2" } 
	local command = { id = "GetGameObjectIdUsingRoute", route = routeName }
	local soldiers = GameObject.SendCommand( gameObjectId, command )
	for i, soldier in ipairs( soldiers ) do
		Fox.Log( "s10086_enemy.IsEnemyOnRoute(): soldier:" .. tostring( soldier ) )
		if soldier == soldierId then
			return true
		end
	end

	return false

end





s10086_enemy.SetHostageFlee = function( hostageName )

	if not hostageName then
		Fox.Error( "s10086_enemy.SetHostageFlee(): invalid hostageName!" )
		return
	end

	local gameObjectId
	if Tpp.IsTypeString( hostageName ) then
		gameObjectId = GameObject.GetGameObjectId( hostageName )
	else
		gameObjectId = hostageName
	end

	if not gameObjectId or gameObjectId == NULL_ID then--RETAILBUG: NULL_ID undefined
		Fox.Error( "s10086_enemy.SetHostageFlee(): invalid hostageName!" )
		return
	end
	local command = { id = "SetNoticeState", state = TppGameObject.HOSTAGE_NOTICE_STATE_FLEE }
	GameObject.SendCommand( gameObjectId, command )
	TppEnemy.SetSneakRoute( hostageName, "" )

end




s10086_enemy.GetGuardNameFromHostageName = function( targetHostageName )

	if Tpp.IsTypeString( targetHostageName ) then
		targetHostageName = GameObject.GetGameObjectId( targetHostageName )
	end

	for guardName, hostageName in pairs( s10086_enemy.GUARD_TO_HOSTAGE_TABLE ) do
		if targetHostageName == GameObject.GetGameObjectId( hostageName ) then
			return guardName
		end
	end

end




s10086_enemy.GetHostageNameFromGuradName = function( targetGuardName )

	if Tpp.IsTypeString( targetGuardName ) then
		targetGuardName = GameObject.GetGameObjectId( targetGuardName )
	end

	for guardName, hostageName in pairs( s10086_enemy.GUARD_TO_HOSTAGE_TABLE ) do
		if targetGuardName == GameObject.GetGameObjectId( guardName ) then
			return hostageName
		end
	end

end




s10086_enemy.HostageRideVehicle = function( hostageId, vehicleId )
	s10086_enemy._HostageRideVehicle( hostageId, vehicleId, false )
end




s10086_enemy.HostageGetOffVehicle = function( hostageId, vehicleId )
	s10086_enemy._HostageRideVehicle( hostageId, vehicleId, true )
end

s10086_enemy._HostageRideVehicle = function( hostageId, vehicleId, getOff )

	if Tpp.IsTypeString( hostageId ) then
		hostageId = GameObject.GetGameObjectId( hostageId )
	end

	if Tpp.IsTypeString( vehicleId ) then
		vehicleId = GameObject.GetGameObjectId( vehicleId )
	end

	GameObject.SendCommand( hostageId, { id = "RideVehicle", vehicleId = vehicleId, off = getOff, } )

end




s10086_enemy.SetCautionPhase = function()



end




s10086_enemy.SetExecuteHostageRoute = function( enemyName, routeName, hostageName )

	Fox.Log( "s10086_enemy.SetExecuteHostageRoute()" )

	if s10086_enemy.GetNoticeState( hostageName ) == TppGameObject.HOSTAGE_NOTICE_STATE_NORMAL then

		Fox.Log( "s10086_enemy.SetExecuteHostageRoute(): ExecuteHostage." )

		TppEnemy.SetSneakRoute( enemyName, routeName )
		s10086_enemy.SetCautionRoute( enemyName, routeName )
		TppEnemy.SetAlertRoute( enemyName, routeName )

	end

end




s10086_enemy.GetNoticeState = function( gameObjectId )

	Fox.Log( "s10086_enemy.GetNoticeState()" )

	if Tpp.IsTypeString( gameObjectId ) then
		gameObjectId = GameObject.GetGameObjectId( gameObjectId )
	end

	local command = { id = "GetNoticeState" }
	local noticeState = GameObject.SendCommand( gameObjectId, command )

	return noticeState

end




s10086_enemy.CallCpRadio = function( gameObjectId, label )

	if Tpp.IsTypeString( gameObjectId ) then
		gameObjectId = GameObject.GetGameObjectId( gameObjectId )
	end

	local command = { id = "RequestRadio", label = label }
	GameObject.SendCommand( gameObjectId, command )

end




s10086_enemy.SetCautionRoute = function( gameObjectId, routeName, routeNodeIndex )

	Fox.Log( "s10086_enemy.SetCautionRoute(): gameObjectId:" .. tostring( gameObjectId ) .. ", routeName:" .. tostring( routeName ) .. ", routeNodeIndex:" .. tostring( routeNodeIndex ) )

	if not gameObjectId then
		return
	end

	if Tpp.IsTypeString( gameObjectId ) then
		gameObjectId = GameObject.GetGameObjectId( gameObjectId )
	end

	if gameObjectId and gameObjectId ~= GameObject.NULL_ID then
		GameObject.SendCommand( gameObjectId, { id = "SetCautionRoute", route = routeName, point = routeNodeIndex } )
	end

end




return s10086_enemy
