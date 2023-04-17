local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}

local TARGET_HOSTAGE_NAME = "hos_hillNorth_0000"
local TARGET_BONUS_HOSTAGE = "hos_hillNorth_0001"
local TARGET_VIP_NAME = "sol_hillNorth_0000"




this.soldierDefine = {

	
	mafr_hillNorth_ob = {
		"sol_hillNorth_0000",
		"sol_hillNorth_0001",
		"sol_hillNorth_0002",
		"sol_hillNorth_0003",
		nil
	},

	
	s10200_Squad01_cp = {
		"sol_hillNorth_0004",
		"sol_hillNorth_0005",
		"sol_hillNorth_0006",
		"sol_hillNorth_0007",
		nil
	},

	s10200_Squad02_cp = {
		"sol_hillNorth_0008",
		"sol_hillNorth_0009",
		"sol_hillNorth_0010",
		"sol_hillNorth_0011",
		nil
	},
	
	
	nil
}


this.soldierTypes = {
        CHILD = {
                this.soldierDefine.mafr_hillNorth_ob,
                this.soldierDefine.s10200_Squad01_cp,
                this.soldierDefine.s10200_Squad02_cp,
        },
}




this.routeSets = {

	mafr_hillNorth_ob = {

		priority = {
			
			"groupA",
			"groupB",
			"groupC",
			"groupD",
			
			"groupE",
			"groupF",
			"groupG",
			"groupH",
			
			"groupI",
			"groupJ",
			"groupK",
			"groupL",
		},

		sneak_day = {
			
			groupA = { "rts_hillNorth_d_0000",},
			groupB = { "rts_hillNorth_d_0001",},
			groupC = { "rts_hillNorth_d_0002",},
			groupD = { "rts_hillNorth_d_0003",},
			
			groupE = { "rts_hillNorth_d_0004",},
			groupF = { "rts_hillNorth_d_0005",},
			groupG = { "rts_hillNorth_d_0006",},
			groupH = { "rts_hillNorth_d_0007",},
			
			groupI = { "rts_hillNorth_d_0008",},
			groupJ = { "rts_hillNorth_d_0009",},
			groupK = { "rts_hillNorth_d_0010",},
			groupL = { "rts_hillNorth_d_0011",},
		},

		sneak_night = {
			
			groupA = { "rts_hillNorth_n_0000",},
			groupB = { "rts_hillNorth_n_0001",},
			groupC = { "rts_hillNorth_n_0002",},
			groupD = { "rts_hillNorth_n_0003",},
			
			groupE = { "rts_hillNorth_n_0004",},
			groupF = { "rts_hillNorth_n_0005",},
			groupG = { "rts_hillNorth_n_0006",},
			groupH = { "rts_hillNorth_n_0007",},
			
			groupI = { "rts_hillNorth_n_0008",},
			groupJ = { "rts_hillNorth_n_0009",},
			groupK = { "rts_hillNorth_n_0010",},
			groupL = { "rts_hillNorth_n_0011",},
		},

		caution = {
			
			groupA = { "rts_hillNorth_c_0000",},
			groupB = { "rts_hillNorth_c_0001",},
			groupC = { "rts_hillNorth_c_0002",},
			groupD = { "rts_hillNorth_c_0003",},
			
			groupE = { "rts_hillNorth_c_0004",},
			groupF = { "rts_hillNorth_c_0005",},
			groupG = { "rts_hillNorth_c_0006",},
			groupH = { "rts_hillNorth_c_0007",},
			
			groupI = { "rts_hillNorth_c_0008",},
			groupJ = { "rts_hillNorth_c_0009",},
			groupK = { "rts_hillNorth_c_0010",},
			groupL = { "rts_hillNorth_c_0011",},
		},

		sleep = { 
			default = {
				"rts_hillNorth_s_0000",
				"rts_hillNorth_s_0001",
			},
        },

		hold = {
			default = {
				"rts_hillNorth_h_0000",
				"rts_hillNorth_h_0001",
			},
		},
		nil
	},



	s10200_Squad01_cp = {
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
				"rts_lrrp_Unit01_Search_0000",
				"rts_lrrp_Unit01_Search_0000",
				"rts_lrrp_Unit01_Search_0000",
				"rts_lrrp_Unit01_Search_0000",
			},
		},

		sneak_night = {
			groupA = {
				"rts_lrrp_Unit01_Search_0000",
				"rts_lrrp_Unit01_Search_0000",
				"rts_lrrp_Unit01_Search_0000",
				"rts_lrrp_Unit01_Search_0000",
			},
		},

		caution = {
			groupA = {
				"rts_lrrp_Unit01_Search_0000",
				"rts_lrrp_Unit01_Search_0000",
				"rts_lrrp_Unit01_Search_0000",
				"rts_lrrp_Unit01_Search_0000",
			},
		},

		travel = {
			lrrp_Unit01 = {
				"rts_lrrp_Unit01_SearchReturn",
				"rts_lrrp_Unit01_SearchReturn",
				"rts_lrrp_Unit01_SearchReturn",
				"rts_lrrp_Unit01_SearchReturn",
			},
		},
		nil
	},
 



	s10200_Squad02_cp = {
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
				"rts_lrrp_Unit02_Search_0000",
				"rts_lrrp_Unit02_Search_0000",
				"rts_lrrp_Unit02_Search_0001",
				"rts_lrrp_Unit02_Search_0002",
			},
		},

		sneak_night = {
			groupA = {
				"rts_lrrp_Unit02_Search_0000",
				"rts_lrrp_Unit02_Search_0000",
				"rts_lrrp_Unit02_Search_0001",
				"rts_lrrp_Unit02_Search_0002",
			},
		},

		caution = {
			groupA = {
				"rts_lrrp_Unit02_Search_0000",
				"rts_lrrp_Unit02_Search_0000",
				"rts_lrrp_Unit02_Search_0001",
				"rts_lrrp_Unit02_Search_0002",
			},
		},

		travel = {
			lrrp_Unit02 = {
				"rts_lrrp_Unit02_SearchReturn",
				"rts_lrrp_Unit02_SearchReturn",
				"rts_lrrp_Unit02_SearchReturn",
				"rts_lrrp_Unit02_SearchReturn",
			},
		},

		nil
	},
	
}





this.combatSetting = {

	mafr_hillNorth_ob = {
		"TppGuardTargetData0000",
		"TppCombatLocatorSetData0000",
	},
	nil

}





this.VEHICLE_SPAWN_LIST = {
	{ id = "Spawn", locator = "TppVehicleLocator0000", type = Vehicle.type.WESTERN_LIGHT_VEHICLE, subType = Vehicle.subType.NONE, },
}





this.travelPlans = {
	travel_lrrp_Unit01 ={
		ONE_WAY = true,
		{ cp="s10200_Squad01_cp", 		routeGroup={ "travel", "lrrp_Unit01" } },
		{ cp="mafr_hillNorth_ob", finishTravel=true },
	},

	travel_lrrp_Unit02 ={
		ONE_WAY = true,
		{ cp="s10200_Squad02_cp", 		routeGroup={ "travel", "lrrp_Unit02" } },
		{ cp="mafr_hillNorth_ob", finishTravel=true },
	},
}







this.Interrogation_LocateLeader = function()
	Fox.Log("*** Success Interrogation_LocateLeader ***")
	TppMission.UpdateObjective { objectives = { "default_Target_Leader" },}
	s10200_sequence.FoundLeader()
end

this.Interrogation_LocateHostage = function()
	Fox.Log("*** Success Interrogation_LocateHostage ***")
	TppMission.UpdateObjective { objectives = { "default_Target_Hostage" },}
	s10200_sequence.FoundHostage()
end

this.Interrogation_LocateFlowers = function()
	Fox.Log("*** Success Interrogation_LocateFlowers ***")
	TppMission.UpdateObjective { objectives = { "default_itemArea" },}
end



this.HighInterrogation = function()
	if TppMission.IsMissionStart() then
		Fox.Log("*** HighInterrogation ***")
		TppInterrogation.AddHighInterrogation(
			GameObject.GetGameObjectId( "mafr_hillNorth_ob" ),
			{ 
				{ name = "enqt1000_101528", func = this.Interrogation_LocateLeader},
				{ name = "enqt1000_1i1210", func = this.Interrogation_LocateHostage},
				{ name = "enqt1000_107051", func = this.Interrogation_LocateFlowers},
			}
		)
	end
end



this.DisableHighInterrogation_LocateLeader = function( IntelName,objectiveName )
	Fox.Log("*** DisableHighInterrogation_LocateLeader ***")
	TppInterrogation.RemoveHighInterrogation(
		GameObject.GetGameObjectId( "mafr_hillNorth_ob" ),
		{ 
			{ name = "enqt1000_101528", func = this.Interrogation_LocateLeader},
		}
	)
end

this.DisableHighInterrogation_LocateHostage = function( IntelName,objectiveName )
	Fox.Log("*** DisableHighInterrogation_LocateHostage ***")
	TppInterrogation.RemoveHighInterrogation(
		GameObject.GetGameObjectId( "mafr_hillNorth_ob" ),
		{ 
			{ name = "enqt1000_1i1210", func = this.Interrogation_LocateHostage},
		}
	)
end

this.DisableHighInterrogation_LocateFlowers = function( IntelName,objectiveName )
	Fox.Log("*** DisableHighInterrogation_LocateFlowers ***")
	TppInterrogation.RemoveHighInterrogation(
		GameObject.GetGameObjectId( "mafr_hillNorth_ob" ),
		{ 
			{ name = "enqt1000_107051", func = this.Interrogation_LocateFlowers},
		}
	)
end




this.interrogation = {
	
	mafr_hillNorth_ob = {
		high = {
			{ name = "enqt1000_101528", func = this. Interrogation_LocateLeader},
			{ name = "enqt1000_1i1210", func = this.Interrogation_LocateHostage},
			{ name = "enqt1000_107051", func = this.Interrogation_LocateFlowers},
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
        
        mafr_hillNorth_ob = true,
        s10200_Squad01_cp = true,
        s10200_Squad02_cp = true,
        nil
}








this.UnitMember = {
	Unit01 = {
		"sol_hillNorth_0004",
		"sol_hillNorth_0005",
		"sol_hillNorth_0006",
		"sol_hillNorth_0007",
	},

	Unit02 = {
		"sol_hillNorth_0008",
		"sol_hillNorth_0009",
		"sol_hillNorth_0010",
		"sol_hillNorth_0011",
	},
}


this.BanRouteSet = {
	
	"rts_hillNorth_d_0004",
	"rts_hillNorth_d_0005",
	"rts_hillNorth_d_0006",
	"rts_hillNorth_d_0007",
	"rts_hillNorth_d_0008",
	"rts_hillNorth_d_0009",
	"rts_hillNorth_d_0010",
	"rts_hillNorth_d_0011",
	
	"rts_hillNorth_n_0004",
	"rts_hillNorth_n_0005",
	"rts_hillNorth_n_0006",
	"rts_hillNorth_n_0007",
	"rts_hillNorth_n_0008",
	"rts_hillNorth_n_0009",
	"rts_hillNorth_n_0010",
	"rts_hillNorth_n_0011",
}


this.AllChildSoldier = {
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
	"sol_hillNorth_0010",
	"sol_hillNorth_0011",
}


this.UnitStart = function(UnitTableName,travelPlanName)
	Fox.Log("Func: s10200_enemy.UnitStart")
	for i, enemyName in ipairs(UnitTableName) do
		local gameObjectId = GameObject.GetGameObjectId("TppSoldier2", enemyName)
		local command = { id = "StartTravel", travelPlan = travelPlanName }
		local actionState = GameObject.SendCommand( gameObjectId, command )
	end
end


function this.HostageFlagSetUp()
	Fox.Log("Func: HostageFlagSetUp")
	local locatorName = "hos_hillNorth_0000"
	local gameObjectType = "TppHostage2"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local command = {
		id = "SetHostage2Flag",
		flag = "disableFulton",
		on = true,
	}
	GameObject.SendCommand( gameObjectId, command )
end


function this.RouteSetEnable( bool, routeSet )
	Fox.Log("Func: RouteSetEnable/Disable")
	local locatorName = "mafr_hillNorth_ob"
	local gameObjectType = "TppCommandPost2"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local routes = routeSet
	local command = { id = "SetRouteEnabled", routes = routes, enabled = bool }
	GameObject.SendCommand( gameObjectId, command )
end


function this.InitialRouteSetGroup(UnitTableName, groupId)
	Fox.Log("Func: InitialRouteSetGroup")
	TppEnemy.InitialRouteSetGroup{
	    cpName = "mafr_hillNorth_ob",
	    soldierList = UnitTableName,
	    groupName = groupId
	}
end


function this.BonusHostageReadyExecution()
	Fox.Log("Func: BonusHostageReadyExecution")
	local gameObjectId = GameObject.GetGameObjectId( TARGET_BONUS_HOSTAGE )
	local command = { id = "SetNoticeState", state = TppGameObject.HOSTAGE_NOTICE_STATE_EXECUTE_READY }
	GameObject.SendCommand( gameObjectId, command )
end


function this.SetHostageLanguage( gameObjectId, languageType )
	local gameObjectId = GameObject.GetGameObjectId( gameObjectId )
	local command = { id = "SetLangType", langType=languageType }
	local command2 = { id = "SetVoiceType", voiceType = "hostage_b" }
	GameObject.SendCommand( gameObjectId, command )
	GameObject.SendCommand( gameObjectId, command2 )
end


function this.DisableDying()
	for i, enemyName in ipairs(this.AllChildSoldier) do
		local gameObjectId = GameObject.GetGameObjectId( enemyName )
		local command = { id = "SetEnableDyingState", enabled = false }
		GameObject.SendCommand( gameObjectId, command )
	end
end


function this.SetMaxLife()







end


function this.SetAsVip ( enemyId )
	local gameObjectId = GameObject.GetGameObjectId( enemyId )
	local command = { id="SetVip" }
	GameObject.SendCommand( gameObjectId, command )
end


this.SetVehicleSpawn = function( spawnList )
	Fox.Log("*** SetVehicleSpawn ***")
	for i, command in ipairs( spawnList ) do
		GameObject.SendCommand( { type="TppVehicle2", }, command )
	end
end




this.GetSoldierNameFromGameObjectId = function( gameObjectId )
	Fox.Log("############# GetSoldierNameFromGameObjectId ##############")
	for cpName, soldierList in pairs( this.soldierDefine ) do
		for i, soldierName in pairs( soldierList ) do
			if gameObjectId == GameObject.GetGameObjectId( "TppSoldier2", soldierName ) then
				return soldierName
			end
		end
	end
end


function this.HeliStopFire()
	local gameObjectId = GameObject.GetGameObjectId( "SupportHeli" )
	GameObject.SendCommand(gameObjectId, { id="SetCombatEnabled", enabled=false }) 
end


function this.SetTargetFova()
	local gameObjectId = GameObject.GetGameObjectId( TARGET_VIP_NAME )
	local command = { id = "ChangeFova", faceId =  NO_FOVA, bodyId = TppEnemyBodyId.chd0_v04 }--RETAILBUG NO_FOVA undefined
	if gameObjectId ~= GameObject.NULL_ID then
		GameObject.SendCommand( gameObjectId, command )
	else
		Fox.Error( "Fova setting is failed. because " .. fova.name .. " is not found." )--RETAILBUG fova undefined
	end
end


function this.SetOuterBaseCp(obId)
	local gameObjectId = GameObject.GetGameObjectId( obId )
	local command = { id = "SetOuterBaseCp" }
	GameObject.SendCommand( gameObjectId, command )
end


function this.SetlrrpCommandPost(lrrpCpId)
	local gameObjectId = GameObject.GetGameObjectId( lrrpCpId )
	local command = { id = "SetLrrpCp" }
	GameObject.SendCommand( gameObjectId, command )
end


this.RegistHoldRecoveredStateForMissionTask = function( targetList )
	Fox.Log("###*** MissionTask register beginning ***")
	for index, targetName in pairs(targetList) do
		TppEnemy.RegistHoldRecoveredState( targetName )
	end
end


function this.SetJackalNotice( DISTANCE )
	local gameObjectId = { type = "TppWolf", index = 0 }
	local command = { id = "SetNoticeDistance", name = "anml_wolf_00", distance = DISTANCE }
	GameObject.SendCommand( gameObjectId, command )
end


function this.SetJackalRoute( routeId )
	local gameObjectId = { type = "TppWolf", index = 0 }
	local command = { id = "SetHerdEnabledCommand", name = "anml_wolf_00", route = routeId }
	GameObject.SendCommand( gameObjectId, command )
end







this.InitEnemy = function ()
end




this.SetUpEnemy = function ()

	TppEnemy.RegisterCombatSetting( this.combatSetting )

	
	this.SetOuterBaseCp("mafr_hillNorth_ob") 
	this.SetlrrpCommandPost("s10200_Squad01_cp") 
	this.SetlrrpCommandPost("s10200_Squad02_cp") 

	
	this.SetTargetFova() 
	this.HostageFlagSetUp() 
	this.SetAsVip ( "sol_hillNorth_0000" ) 
	TppEnemy.SetRescueTargets( { "hos_hillNorth_0000", "sol_hillNorth_0000"} ) 
	TppEnemy.RegistHoldRecoveredState( TARGET_BONUS_HOSTAGE ) 

	
	TppEnemy.AssignUniqueStaffType{
		locaterName = TARGET_VIP_NAME,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10200_CHILD_COMMANDER,
	}

	TppEnemy.AssignUniqueStaffType{
		locaterName = TARGET_HOSTAGE_NAME,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10200_TARGET_HOSTAGE,
		alreadyExistParam = { staffTypeId =46, randomRangeId =4, skill ="TroublemakerIntemperately" },
	}

	TppEnemy.AssignUniqueStaffType{
		locaterName = TARGET_BONUS_HOSTAGE,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10200_BONUS_HOSTAGE,
		alreadyExistParam = { staffTypeId =3, randomRangeId =6, skill ="SleepingGasEngineer" },
	}

	this.BonusHostageReadyExecution() 

	this.SetHostageLanguage( TARGET_HOSTAGE_NAME, "kikongo" )
	this.SetHostageLanguage( TARGET_BONUS_HOSTAGE, "afrikaans" )

	this.SetMaxLife() 
	this.DisableDying() 
	this.RouteSetEnable(false, this.BanRouteSet) 

	
	this.SetJackalRoute("rts_anml_wolf_0000")


	
	this.SetVehicleSpawn( this.VEHICLE_SPAWN_LIST )
	this.HeliStopFire()

	
	this.RegistHoldRecoveredStateForMissionTask( this.AllChildSoldier )

	
	this.HighInterrogation()
	
end


this.OnLoad = function ()
	Fox.Log("*** s10200 onload ***")
end




return this
