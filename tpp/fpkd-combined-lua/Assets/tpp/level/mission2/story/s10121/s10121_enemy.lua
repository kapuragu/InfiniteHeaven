--s10121_enemy.lua
local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}


local TARGET_ENEMY_NAME = "sol_pfCamp_vip_0001"
local SUB_TARGET_ENEMY_NAME = "sol_pfCamp_vip_guard"

local SNIPER_01 = "sol_pfCamp_snp_0000"
local SNIPER_02 = "sol_pfCamp_snp_0001"

local WG_RIDER_01 = "sol_pfCamp_0100"
local WG_RIDER_02 = "sol_pfCamp_0101"
local WG_RIDER_03 = "sol_pfCamp_0102"
local WG_RIDER_04 = "sol_pfCamp_0103" 






this.vehicleDefine = { instanceCount = 5 }
this.USE_COMMON_REINFORCE_PLAN = true


this.soldierPowerSettings = {
	sol_pfCamp_vip_0001 = {},
	sol_pfCamp_vip_guard = { "SMG" },
	sol_pfCamp_snp_0000 = { "SNIPER" },
	sol_pfCamp_snp_0001 = { "SNIPER" },
}





this.soldierDefine = {
	
	mafr_pfCamp_cp = {
	
		
		"sol_pfCamp_0000",
		"sol_pfCamp_0001",
		"sol_pfCamp_0002",
		"sol_pfCamp_0003",
		"sol_pfCamp_0004",
		"sol_pfCamp_0005",
		"sol_pfCamp_0012",
		"sol_pfCamp_0006",

		"sol_pfCamp_0008",
		"sol_pfCamp_0009",
		"sol_pfCamp_0010",

		
		"sol_pfCamp_0012",


	
		
		"sol_pfCamp_vip_0001",
		"sol_pfCamp_vip_guard",

		
		"sol_pfCamp_0100",	
		"sol_pfCamp_0101",
		"sol_pfCamp_0102",
		"sol_pfCamp_0103",

		
		"sol_pfCamp_snp_0000",
		"sol_pfCamp_snp_0001",

	},

	mafr_pfCampEast_ob = {
		"sol_pfCampEast_0000",
		"sol_pfCampEast_0001",
		"sol_pfCampEast_0002",
		"sol_pfCampEast_0003",
		"sol_pfCampEast_0004",
		"sol_pfCampEast_0005",
	},

	mafr_chicoVilWest_ob = {
		"sol_chicoVilWest_0000",
		"sol_chicoVilWest_0001",
		"sol_chicoVilWest_0002",
		"sol_chicoVilWest_0003",
		"sol_chicoVilWest_0004",
		"sol_chicoVilWest_0005",

	},
	
	mafr_15_23_lrrp = {
		nil
	},
	
	mafr_23_33_lrrp = {
		nil
	},
	
}





this.routeSets = {
	
	mafr_pfCamp_cp = {
		priority = {
			"groupA",
			"groupB",
			"groupC",
			"groupD",
			"groupE",
			"groupF",
		},
		sneak_day = {
			groupA = {
				"rts_pfCamp_0000",
				"rts_vehicle_0000",
			},

			groupB = {
				"rts_pfCamp_0001",
				"rts_pfCamp_0006",
			},

			groupC = {
				"rts_pfCamp_0002",
				"rts_pfCamp_0008",
			},

			groupD = {
				"rts_pfCamp_0003",
				"rts_pfCamp_0009",
			},

			groupE = {
				"rts_pfCamp_0004",
				"rts_pfCamp_0010",
			},

			groupF = {
				"rts_pfCamp_0005",
				"rts_pfCamp_0012",
			},

			nil
		},

		sneak_night = {

			groupA = {
				"rts_pfCamp_n_0000_sub",
				"rts_vehicle_0000",
			},

			groupB = {
				"rts_pfCamp_n_0001_sub",
				"rts_pfCamp_0006",
			},

			groupC = {
				"rts_pfCamp_0002",
				"rts_pfCamp_0008",
			},

			groupD = {
				"rts_pfCamp_0003",
				"rts_pfCamp_0009",
			},

			groupE = {
				"rts_pfCamp_0004",
				"rts_pfCamp_0010",
			},

			groupF = {
				"rts_pfCamp_0005",
				"rts_pfCamp_0012",
			},
			nil
		},

		caution = {
			groupA = {
				"rts_pfCamp_c_0011",
				"rts_pfCamp_c_0002",
				"rts_pfCamp_c_0003",
				"rts_pfCamp_c_0004",
				"rts_pfCamp_c_0005",
				"rts_pfCamp_c_0005",
				"rts_pfCamp_c_0006",
				"rts_pfCamp_c_0007",
				"rts_pfCamp_c_0007",
				"rts_pfCamp_c_0009",
				"rts_pfCamp_c_0010",
				"rts_pfCamp_c_0000",
				"rts_pfCamp_c_0001",
				"rts_pfCamp_c_0008",
			},

			groupB = {
			},

			groupC = {
			},

			groupD = {
			},

			groupE = {
			},

			groupF = {
			},

			nil
		},
		hold = {
			default = {
				"rt_pfCamp_h_0000",
				"rt_pfCamp_h_0001",
			},
		},
		walkergearpark = {
			"rts_pfCamp_walkergearpark0000",
			"rts_pfCamp_walkergearpark0001",
			"rts_pfCamp_walkergearpark0002",
			"rts_pfCamp_walkergearpark0003",
		},
		nil
	},


	mafr_chicoVilWest_ob	=	{ USE_COMMON_ROUTE_SETS = true,	},
	mafr_pfCampEast_ob		=	{ USE_COMMON_ROUTE_SETS = true,	},


	mafr_15_23_lrrp		=	{ USE_COMMON_ROUTE_SETS = true,	},
	mafr_23_33_lrrp		=	{ USE_COMMON_ROUTE_SETS = true,	},
}

this.travelPlans = {
	
	respawn_01 ={
		{ cp="mafr_15_23_lrrp", 	routeGroup={ "travel", "rp_15to23" } },
		{ cp="mafr_pfCamp_cp" },
	},
	respawn_02 ={
		{ cp="mafr_23_33_lrrp", 	routeGroup={ "travel", "rp_33to23" } },
		{ cp="mafr_pfCamp_cp" },
	},
}





this.cpGroups = {

	group_Area2 = {
		
		"mafr_pfCamp_cp",

		
		"mafr_pfCampEast_ob",
		"mafr_chicoVilWest_ob",

		
		"mafr_15_23_lrrp",
		"mafr_23_33_lrrp",

	},
}





this.combatSetting = {
	mafr_pfCamp_cp = {
		combatAreaList = {
			area1 = {
        		{ guardTargetName = "gt_pfCamp_0001", locatorSetName = "cs_pfCamp_0001", },
			},
			area2 = {
    	    	{ guardTargetName = "gt_pfCamp_0002", locatorSetName = "cs_pfCamp_0002", },
			},
		},
	},
}





this.VEHICLE_SPAWN_LIST = {
	{ id = "Spawn", locator = "TppVehicleLocator0000", type = Vehicle.type.WESTERN_LIGHT_VEHICLE, subType = Vehicle.subType.NONE, paintType=Vehicle.paintType.FOVA_0, },
	{ id = "Spawn", locator = "TppVehicleLocator0001", type = Vehicle.type.WESTERN_TRUCK, subType = Vehicle.subType.NONE, paintType=Vehicle.paintType.FOVA_0, },
	{ id = "Spawn", locator = "TppVehicleLocator0002", type = Vehicle.type.WESTERN_LIGHT_VEHICLE, subType = Vehicle.subType.NONE, paintType=Vehicle.paintType.FOVA_0, },

}

this.WalkerGearRelation = {
	{ enemyId = "sol_pfCamp_0100",  walkerGearId  = "WalkerGearGameObjectLocator", },
	{ enemyId = "sol_pfCamp_0101",  walkerGearId  = "WalkerGearGameObjectLocator0000", },
	{ enemyId = "sol_pfCamp_0102",  walkerGearId  = "WalkerGearGameObjectLocator0001", },
	{ enemyId = "sol_pfCamp_0103",  walkerGearId  = "WalkerGearGameObjectLocator0002", },
}






this.UniqueInterStart_sol_pfCamp_vip_0001 = function( soldier2GameObjectId, cpID )

	if	mvars.vipInter == nil then
		mvars.vipInter = 0
	else
		mvars.vipInter = mvars.vipInter + 1
	end

	if mvars.vipInter == 0 then
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_106989")
	elseif mvars.vipInter == 1 then
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_106997")
	elseif mvars.vipInter == 2 then
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_106998")
	else
		TppInterrogation.UniqueInterrogation( cpID, "ENQT1000_161010")
	end
	return true
end


this.UniqueInterStart_sol_pfCamp_vip_guard = function( soldier2GameObjectId, cpID )

	if	mvars.subvipInter == nil then
		mvars.subvipInter = 0
	else
		mvars.subvipInter = mvars.subvipInter + 1
	end

	if mvars.subvipInter == 0 then
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_107002")
	elseif mvars.subvipInter == 1 then
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_107009")
	elseif mvars.subvipInter == 2 then
		TppInterrogation.UniqueInterrogation( cpID, "enqt1000_107013")
	else
		TppInterrogation.UniqueInterrogation( cpID, "ENQT1000_161010")
	end
	return true

end



this.UniqueInterEnd_sol_pfCamp_vip_0001 = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("###  s10121_enemy.UniqueInterEnd_TARGET_ENEMY_NAME ### ")
end

this.UniqueInterEnd_pfCamp_vip_guard = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("###  s10121_enemy.UniqueInterEnd_SUB_TARGET_ENEMY_NAME ### ")
end


this.InterCall_Target = function( soldier2GameObjectId, cpID, interName )
	Fox.Log("###  s10121_enemy.InterCall_Hostage() ### ")
	TppMission.UpdateObjective{
		objectives = { "Inspection_route" },
	}
end


this.uniqueInterrogation = {

	unique = {
		{ name = "enqt1000_106989", func = this.UniqueInterEnd_sol_pfCamp_vip_0001, },
		{ name = "enqt1000_106997", func = this.UniqueInterEnd_sol_pfCamp_vip_0001, },
		{ name = "enqt1000_106998", func = this.UniqueInterEnd_sol_pfCamp_vip_0001, },
		{ name = "enqt1000_107002", func = this.UniqueInterEnd_pfCamp_vip_guard, },
		{ name = "enqt1000_107009", func = this.UniqueInterEnd_pfCamp_vip_guard, },
		{ name = "enqt1000_107013", func = this.UniqueInterEnd_pfCamp_vip_guard, },
		nil
	},
	
	uniqueChara = {
		{ name = "sol_pfCamp_vip_0001", func = this.UniqueInterStart_sol_pfCamp_vip_0001, },
		{ name = "sol_pfCamp_vip_guard", func = this.UniqueInterStart_sol_pfCamp_vip_guard, },
		nil
	},
	nil
}

this.HighInterrogation = function()
	if TppMission.IsMissionStart() then
		Fox.Log("*** HighInterrogation ***")
		TppInterrogation.AddHighInterrogation(
			GameObject.GetGameObjectId( "mafr_pfCamp_cp" ),
			{ 
				{ name = "enqt1000_106984", func = this.InterCall_Target, },
			
			}
		)
	end
end


this.interrogation = {
	
	mafr_pfCamp_cp = {
		high = {
			{ name = "enqt1000_106984", func = this.InterCall_Target, },
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
    mafr_pfCampEast_ob = true,
    mafr_chicoVilWest_ob = true,
    nil
}





function this.DisableHelmet( enemyId )
	local gameObjectId = GameObject.GetGameObjectId( enemyId )
	local command = { id = "UnequipArmorHelmet" }
	local lifeState = GameObject.SendCommand( gameObjectId, command )
end

function this.fixRoute ( enemyId, routeId )
	TppEnemy.SetSneakRoute( enemyId, routeId )
	TppEnemy.SetCautionRoute( enemyId, routeId )
end


function this.EnemyHeliSetCp ( cpName )
	local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id="SetCommandPost", cp = cpName })
end


function this.HeliDisablePullOut()
	Fox.Log(" #### s10121_sequence.HeliDIsablePullOut #### ")	
	local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })
end


function this.SetReinforce()
	local gameObjectId = { type="TppCommandPost2" }
	local reinforcePlan = {
		respawn_01 = {
			{ toCp="mafr_pfCamp_cp", fromCp="mafr_pfCampEast_ob", type="respawn", },
		},
		respawn_02 = {
			{ toCp="mafr_pfCamp_cp", fromCp="mafr_chicoVilWest_ob", type="respawn", },
		},
	}
	local command = { id = "SetReinforcePlan", reinforcePlan=reinforcePlan }
	local position = GameObject.SendCommand( gameObjectId, command )
end


function this.SetAsVip ( enemyId )
	local gameObjectId = GameObject.GetGameObjectId( enemyId )
	local command = { id="SetVipSpecial" }
	GameObject.SendCommand( gameObjectId, command )
end


function this.SetRouteFront( enemyId )
	local gameObjectId = GameObject.GetGameObjectId( enemyId )
	local command = { id="SetRouteFront" }
	GameObject.SendCommand( gameObjectId, command )
end

this.SetVehicleSpawn = function( spawnList )
	Fox.Log("*** SetVehicleSpawn ***")
	for i, command in ipairs( spawnList ) do
		GameObject.SendCommand( { type="TppVehicle2", }, command )
	end
end


this.SetRelativeVehicle = function( enemyId, vehicleId )
	local gameObjectId = GameObject.GetGameObjectId( enemyId )
	local vehicleId = GameObject.GetGameObjectId( vehicleId )
	local command = { id = "SetRelativeVehicle", targetId = vehicleId, rideFromBeginning=false, isMust=true, isVigilance=true }
	GameObject.SendCommand( gameObjectId, command )
	Fox.Log("SetRelativeVehicle")
end


this.SetRelativeWalkerGear = function()
	for i, walkergearTable in ipairs( this.WalkerGearRelation ) do
		local gameObjectId = GameObject.GetGameObjectId( walkergearTable.enemyId )
		local walkerGearId = GameObject.GetGameObjectId( walkergearTable.walkerGearId )
		local command = { id = "SetRelativeVehicle", targetId = walkerGearId, rideFromBeginning = true }
		GameObject.SendCommand( gameObjectId, command )
		Fox.Log("SetRelativeVehicle")
	end
end


this.SetColoringWalkerGear = function()
	for i, walkergearTable in pairs( this.WalkerGearRelation ) do
		local walkergearId = GameObject.GetGameObjectId( walkergearTable.walkerGearId )
		local command = { id = "SetColoringType", type = 2 }
		GameObject.SendCommand( walkergearId, command )
	end
end

local scamera_citadel = {
	"scamera_pfCamp_0000",
	"scamera_pfCamp_0001",
	"scamera_pfCamp_0002",
	"scamera_pfCamp_0003",
	"scamera_pfCamp_0004",
	"scamera_pfCamp_0005",
}

this.SetUpSecurityCamera = function()
	
	for index, cameraName in pairs(scamera_citadel) do
		local gameObjectId = GameObject.GetGameObjectId(cameraName)
		if gameObjectId ~= GameObject.NULL_ID then
				GameObject.SendCommand( gameObjectId, { id="SetCommandPost" , cp="mafr_pfCamp_cp"})
		end
	end

end

this.SetIgnoreFlear = function()
	local cpName =  GameObject.GetGameObjectId( "mafr_pfCamp_cp" )
	local command = { id = "IgnoreFlear", ignore=true }
	GameObject.SendCommand( cpName, command )
end






this.InitEnemy = function ()
end



this.SetUpEnemy = function ()

	
	if missionName == "s11121" then --RETAILBUG undefined
	 TppHelicopter.SetEnemyColoring( TppDefine.ENEMY_HELI_COLORING_TYPE.BLACK ) 
	else
	 TppHelicopter.SetEnemyColoring( TppDefine.ENEMY_HELI_COLORING_TYPE.DEFAULT ) 
	end
	
	
	this.SetAsVip ( TARGET_ENEMY_NAME )
	this.SetAsVip ( SUB_TARGET_ENEMY_NAME )
	this.SetRouteFront( TARGET_ENEMY_NAME )
	TppEnemy.AssignUniqueStaffType{
        locaterName = TARGET_ENEMY_NAME,
        uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10121_PF_OPERATOR,
		alreadyExistParam = { staffTypeId =41, randomRangeId =4, skill ="Athlete" },
	}

	TppEnemy.AssignUniqueStaffType{
        locaterName = SUB_TARGET_ENEMY_NAME,
        uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.S10121_WEAPON_DEALER,
		alreadyExistParam = { staffTypeId =3, randomRangeId =6, skill ="MissileHomingEngineer" },
	}
	
	this.DisableHelmet( TARGET_ENEMY_NAME )

	
	TppEnemy.SetSneakRoute( TARGET_ENEMY_NAME,	"rts_vip_start" )
	TppEnemy.SetCautionRoute( TARGET_ENEMY_NAME,"rts_vip_c_0000" )

	TppEnemy.SetSneakRoute( SUB_TARGET_ENEMY_NAME,	"rts_sub_vip_start" )
	TppEnemy.SetCautionRoute( SUB_TARGET_ENEMY_NAME,"rts_sub_vip_start" )
	TppEnemy.SetAlertRoute( SUB_TARGET_ENEMY_NAME,"rts_sub_vip_start" )

	
	this.fixRoute( SNIPER_01,	"rts_pfCamp_snp_0000"  )
	this.fixRoute( SNIPER_02,	"rts_pfCamp_snp_0001"  )

	
	TppEnemy.SetSneakRoute( WG_RIDER_01,"rts_walkergear_0000" )
	TppEnemy.SetCautionRoute( WG_RIDER_01,"rts_walkergear_c_0000" )

	TppEnemy.SetSneakRoute( WG_RIDER_02,"rts_walkergear_0001" )
	TppEnemy.SetCautionRoute( WG_RIDER_02,"rts_walkergear_c_0001" )

	TppEnemy.SetSneakRoute( WG_RIDER_03,"rts_walkergear_0002" )
	TppEnemy.SetCautionRoute( WG_RIDER_03,"rts_walkergear_c_0002" )

	TppEnemy.SetSneakRoute( WG_RIDER_04,"rts_walkergear_0003" )
	TppEnemy.SetCautionRoute( WG_RIDER_04,"rts_walkergear_c_0003" )

	TppEnemy.SetEliminateTargets( { TARGET_ENEMY_NAME } ) 
	TppEnemy.RegistHoldRecoveredState( SUB_TARGET_ENEMY_NAME ) 
	TppEnemy.RegisterCombatSetting( this.combatSetting )

	
	this.SetVehicleSpawn( this.VEHICLE_SPAWN_LIST )

	
	this.SetRelativeWalkerGear()
	this.SetColoringWalkerGear()

	
	this.SetUpSecurityCamera()

	
	this.EnemyHeliSetCp( "mafr_pfCamp_cp" )
	this.SetReinforce()
	
	
	this.SetIgnoreFlear()
	
	this.HighInterrogation()

end


this.OnLoad = function ()
	Fox.Log("*** s10121 onload ***")
end




return this
