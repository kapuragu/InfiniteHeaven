local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}






local POS_OCELOT_TABLE = {
	X = 8.624683,
	Y = 0.800,
	Z = -16.88259,
}

local ROTATE_OCELOT = 170

local DEMO_SOLDIER_00 =	"sol_plant0_0002"
local DEMO_SOLDIER_01 = "sol_plant0_0006"
local DEMO_SOLDIER_01 = "sol_plant0_0011"	







this.soldierDefine = {
	
	mtbs_commandFacility_cp = {
		"sol_plant0_0002",
		"sol_plant0_0006", 
		"sol_plant0_0011", 

		"sol_plant0_0000",
		"sol_plant0_0001",
		"sol_plant0_0003",
		"sol_plant0_0004",
		"sol_plant0_0005",
		"sol_plant0_0007",
		"sol_plant0_0008",
		"sol_plant0_0009",
		"sol_plant0_0010",

		"sol_reserve_0000",
		"sol_reserve_0001",
		nil
	},
	nil
}




this.DD_SOLDIER_GROUP = {
	"sol_plant0_0000",
	"sol_plant0_0001",
	"sol_plant0_0002",
	"sol_plant0_0003",
	"sol_plant0_0004",
	"sol_plant0_0005",
	"sol_plant0_0006",
	"sol_plant0_0007",
	"sol_plant0_0008",
	"sol_plant0_0009",
	"sol_plant0_0010",
	"sol_plant0_0011",
}

this.TUTORIAL_SOLDIER_GROUP = {	
	"sol_plant0_0002",
	"sol_plant0_0001",
	"sol_plant0_0000",
	"sol_plant0_0003",
	"sol_plant0_0004",
	"sol_plant0_0005",
	"sol_plant0_0006",
	"sol_plant0_0007",
}

this.ALL_TUTORIAL_SOLDIER_GROUP = {	
	"sol_plant0_0002",
	"sol_plant0_0001",
	"sol_plant0_0000",
	"sol_plant0_0003",
	"sol_plant0_0004",
	"sol_plant0_0005",
	"sol_plant0_0006",
	"sol_plant0_0007",
	"sol_reserve_0000",
	"sol_reserve_0001",
}

this.ALL_SOLDIER_GROUP = {
	"sol_plant0_0000",
	"sol_plant0_0001",
	"sol_plant0_0002",
	"sol_plant0_0003",
	"sol_plant0_0004",
	"sol_plant0_0005",
	"sol_plant0_0006",
	"sol_plant0_0007",
	"sol_plant0_0008",
	"sol_plant0_0009",
	"sol_plant0_0010",
	"sol_plant0_0011",
	"sol_reserve_0000",
	"sol_reserve_0001",

}

this.STABLE_SOLDIER_GROUP = {
	"sol_plant0_0008",
	"sol_plant0_0009",
	"sol_plant0_0010",
	"sol_plant0_0011",
}

this.RAT_GROUP = {
	"anml_rat_00",
	"anml_rat_01",
	"anml_rat_02",
	"anml_rat_03",
	"anml_rat_04",
}
this.RAT_ROUTE = {
	"route_rat_0000",
	"route_rat_0001",
	"route_rat_0002",
	"route_rat_0003",
	"route_rat_0004",
}


local DEFAULT_ROUTE_TABLE = {	
	"rts_dd_stnd0000",
	"rts_dd_stnd0001",
	"rts_dd_def_0002",
	"rts_dd_stnd0003",
	"rts_dd_stnd0004",
	"rts_dd_stnd0005",
	"rts_dd_def_0006",
	"rts_dd_stnd0007",
	"rts_dd_stnd0008",
	"rts_dd_stnd0009",
	"rts_dd_stnd0010",
	"rts_dd_stnd0011",
	"rts_reserve_0000",
	"rts_reserve_0001",

}
local IDLE_ROUTE_TABLE = {	
	"rts_dd_stnd0000",
	"rts_dd_stnd0001",
	"rts_dd_stnd0002",
	"rts_dd_stnd0003",
	"rts_dd_stnd0004",
	"rts_dd_stnd0005",
	"rts_dd_stnd0006",
	"rts_dd_stnd0007",
	"rts_dd_stnd0008",
	"rts_dd_stnd0009",
	"rts_dd_stnd0010",
	"rts_dd_stnd0011",
}
local TUTORIAL_ROUTE_TABLE = {	
	[1]		=	"rts_dd_fight0004",	
	[2]		=	"rts_dd_fight0005",	
	[3]		=	"rts_dd_fight0006",	
	[4]		=	"rts_dd_fight0007",	
	[5]		=	"rts_dd_fight0000",	
	[6]		=	"rts_dd_fight0001",	
	[7]		=	"rts_dd_fight0002",	
	[8]		=	"rts_dd_fight0003",	
	[9]		=	"rts_dd_fight0008",	
	[10]		=	"rts_dd_fight0009",	
	[11]		=	"rts_dd_fight0010",	
	[12]		=	"rts_dd_fight0011",	


}
local CLEARED_ROUTE_TABLE = {	
	[1]	=	"rts_dd_cleared_0000",	
	[2]	=	"rts_dd_cleared_0001",	
	[3]	=	"rts_dd_cleared_0002",	
	[4]	=	"rts_dd_cleared_0003",	
	[5]	=	"rts_dd_cleared_0004",	
	[6]	=	"rts_dd_cleared_0005",	
	[7]	=	"rts_dd_cleared_0006",	
	[8]	=	"rts_dd_cleared_0007",	
	[9]	=	"rts_dd_cleared_0008",	
	[10]	=	"rts_dd_cleared_0009",	


}
local RIDE_HELI_ROUTE_TABLE = {	
	[1]	=	"rts_dd_rideheli_0000",	
	[2]	=	"rts_dd_rideheli_0001",	
	[3]	=	"rts_dd_rideheli_0002",	
	[4]	=	"rts_dd_rideheli_0003",	
	[5]	=	"rts_dd_rideheli_0004",	
	[6]	=	"rts_dd_rideheli_0005",	
	[7]	=	"rts_dd_rideheli_0006",	
	[8]	=	"rts_dd_rideheli_0007",	
	[9]	=	"rts_dd_rideheli_0008",	
	[10]	=	"rts_dd_rideheli_0009",	
}


local GOODBYE_ROUTE_TABLE = {	
	[1]	=	"rts_dd_goodbye_0000",	
	[2]	=	"rts_dd_goodbye_0001",	
	[3]	=	"rts_dd_goodbye_0002",	
	[4]	=	"rts_dd_goodbye_0003",	
	[5]	=	"rts_dd_goodbye_0004",	
	[6]	=	"rts_dd_goodbye_0005",	
	[7]	=	"rts_dd_goodbye_0006",	
	[8]	=	"rts_dd_goodbye_0007",	
	[9]	=	"rts_dd_goodbye_0008",	
	[10]	=	"rts_dd_goodbye_0009",	
}

local GOODBYE_ROUTE_TABLE_STABLE = {	
	[1]	=	"rts_dd_goodbye_0010",	
	[2]	=	"rts_dd_goodbye_0011",	
	[3]	=	"rts_dd_goodbye_0012",	
	[4]	=	"rts_dd_goodbye_0013",	
}

local CQC_ROUTE_TABLE = {	
	[1]	=	"rts_dd_cqc_0000",	
	[2]	=	"rts_dd_cqc_0001",	
	[3]	=	"rts_dd_cqc_0002",	
	[4]	=	"rts_dd_cqc_0003",	
	[5]	=	"rts_dd_cqc_0004",	
	[6]	=	"rts_dd_cqc_0005",	
	[7]	=	"rts_dd_cqc_0006",	
	[8]	=	"rts_dd_cqc_0007",	
}








this.routeSets = {
	
	mtbs_commandFacility_cp = {
		priority = {
			"rg_DdSoldier"
		},
		sneak_day = {
			rg_DdSoldier = {
				"rts_dd_stnd0000",
				"rts_dd_stnd0001",
				"rts_dd_stnd0002",
				"rts_dd_stnd0003",
				"rts_dd_stnd0004",
				"rts_dd_stnd0005",
				"rts_dd_stnd0006",
				"rts_dd_stnd0007",
				"rts_dd_stnd0008",
				"rts_dd_stnd0009",
				"rts_dd_stnd0010",
				"rts_dd_stnd0011",
				"rts_reserve_0000",
				"rts_reserve_0001",
			},
			
			nil
		},
		sneak_night = {
			rg_DdSoldier = {
				"rts_dd_stnd0000",
				"rts_dd_stnd0001",
				"rts_dd_stnd0002",
				"rts_dd_stnd0003",
				"rts_dd_stnd0004",
				"rts_dd_stnd0005",
				"rts_dd_stnd0006",
				"rts_dd_stnd0007",
				"rts_dd_stnd0008",
				"rts_dd_stnd0009",
				"rts_dd_stnd0010",
				"rts_dd_stnd0011",
				"rts_reserve_0000",
				"rts_reserve_0001",
			},
			nil
		},
		caution = {
			rg_DdSoldier = {
				"rts_dd_stnd0000",
				"rts_dd_stnd0001",
				"rts_dd_stnd0002",
				"rts_dd_stnd0003",
				"rts_dd_stnd0004",
				"rts_dd_stnd0005",
				"rts_dd_stnd0006",
				"rts_dd_stnd0007",
				"rts_dd_stnd0008",
				"rts_dd_stnd0009",
				"rts_dd_stnd0010",
				"rts_dd_stnd0011",
				"rts_reserve_0000",
				"rts_reserve_0001",
			},
			nil
		},
		hold = {
			default = {
				"rts_dd_stnd0000",
				"rts_dd_stnd0001",
				"rts_dd_stnd0002",
				"rts_dd_stnd0003",
				"rts_dd_stnd0004",
				"rts_dd_stnd0005",
				"rts_dd_stnd0006",
				"rts_dd_stnd0007",
				"rts_dd_stnd0008",
				"rts_dd_stnd0009",
				"rts_dd_stnd0010",
				"rts_dd_stnd0011",
				"rts_reserve_0000",
				"rts_reserve_0001",
			},
		},
		nil
	},
	nil
}





this.combatSetting = {
	nil
}






this.InitEnemy = function ()
end



this.SetUpEnemy = function ()




	TppEnemy.RegisterCombatSetting( this.combatSetting )

	
	this.SetDefaultRoute()

	
	TppEnemy.SetSneakRoute( "Ocelot", "rts_oc_stnd" )

	this.SetDisableChatAll()

	

	this.SetReserveSoldierDisable()

	
	local gameObjectId = { type="TppCommandPost2", index=0 }
	local command = { id = "SetFriendlyCp" }
	GameObject.SendCommand( gameObjectId, command )

	this.SetFriend( this.soldierDefine.mtbs_commandFacility_cp )


	
	this.SetAllEnemyStaffParam()
	
	
	this.SetupSoldierFace()
	
	
	this.SetupOcelotFace()

	
	this.SetRatRoute()
	
	
	mtbs_enemy.SetupEmblem()

end


this.OnLoad = function ()
	Fox.Log("*** s10211 onload ***")
end





this.SetFriend = function ( soldierList )
	Fox.Log("#### s10030_enemy.SetFriend ####")

	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local command = { id="SetFriendly" }
	local command2 = { id="SetSaluteMoraleDisable" }

	for idx = 1, table.getn(soldierList) do
		local gameObjectId = GetGameObjectId("TppSoldier2", soldierList[idx])
		if gameObjectId ~= NULL_ID then--RETAILBUG: NULL_ID undefined
			SendCommand( gameObjectId, command )
			SendCommand( gameObjectId, command2 )
		end
	end
end

function this.SetupSoldierFace()
	for index, soldierName in ipairs( this.soldierDefine.mtbs_commandFacility_cp ) do
		local faceId = TppEneFova.S10030_FaceIdList[index]
		if faceId == nil then
			Fox.Error("faceId not found! check TppEneFova.S10030_FaceIdList")
			return
		end

		local gameObjectId = GameObject.GetGameObjectId("TppSoldier2", soldierName )
		if gameObjectId == DEMO_SOLDIER_00 	
				or gameObjectId == DEMO_SOLDIER_01 
				or gameObjectId == DEMO_SOLDIER_02 then--RETAILBUG DEMO_SOLDIER_02 not defined
			TppEneFova.ApplyMTBSUniqueSetting( gameObjectId, faceId, true )
		elseif gameObjectId ~= NULL_ID then--RETAILBUG NULL_ID not defined
			TppEneFova.ApplyMTBSUniqueSetting( gameObjectId, faceId, false )
		end
	end
end

function this.SetupOcelotFace()
	local gameObjectId = GameObject.GetGameObjectId( "TppOcelot2", "Ocelot" )
	local command = { id = "ChangeFova", bodyId = TppEnemyBodyId.oce0_main0_v00, }
	GameObject.SendCommand( gameObjectId, command )
end

this.SwitchEnableSoldier = function ( soldierName, switch )
	Fox.Log("*** s10211 SwitchEnableSoldier ***")

	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand

	local gameObjectId = GameObject.GetGameObjectId("TppSoldier2", soldierName)
	local command = { id="SetEnabled", enabled = switch }

	SendCommand( gameObjectId, command )
end

                                      




this.SetEnemyDisableDamage = function ( soldierName, switch )
	Fox.Log("*** s10211 SetEnemyDisableDamage ***")
	Fox.Log("*** soldierName ***" .. soldierName)

	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local gameObjectId = GetGameObjectId("TppSoldier2", soldierName)

	if ( switch == true ) then
		
		local command = { id = "SetDisableDamage", life = false, faint = true, sleep = true }
		local actionState = SendCommand( gameObjectId, command )
	else
		
		local command = { id = "SetDisableDamage", life = false, faint = false, sleep = false }
		local actionState = SendCommand( gameObjectId, command )
	end
end


this.SetEnemyDisableDamageAll = function ( soldierName, switch )
	for index, enemyName in pairs(this.ALL_SOLDIER_GROUP ) do
		this.SetEnemyDisableDamage( enemyName ,true)
	end
end


this.ResetEnemyDisableDamageAll = function ( soldierName, switch )
	for index, enemyName in pairs(this.ALL_SOLDIER_GROUP ) do
		this.SetEnemyDisableDamage( enemyName ,false)

	end	
end

this.SetEnemyWakeUp = function( soldierName )
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand

	local gameObjectId = GetGameObjectId("TppSoldier2", soldierName)
	local command = { id = "RecoveryAll" }

	SendCommand( gameObjectId, command )
end


this.SetEnemyWakeUpAll = function()
	for index, enemyName in pairs(this.ALL_SOLDIER_GROUP ) do
		this.SetEnemyWakeUp( enemyName ,false)
	end	
end






this.SetDefaultRoute = function ()
	Fox.Log("#### s10030_enemy.SetDefaultRoute ####")
	TppEnemy.SetSneakRoute( "sol_plant0_0000", "rts_dd_def_0002" )
	TppEnemy.SetSneakRoute( "sol_plant0_0001", "rts_dd_def_0006" )
	TppEnemy.SetSneakRoute( "sol_plant0_0002", "rts_dd_stnd0000" )
	TppEnemy.SetSneakRoute( "sol_plant0_0003", "rts_dd_stnd0003" )
	TppEnemy.SetSneakRoute( "sol_plant0_0004", "rts_dd_stnd0004" )
	TppEnemy.SetSneakRoute( "sol_plant0_0005", "rts_dd_stnd0005" )
	TppEnemy.SetSneakRoute( "sol_plant0_0006", "rts_dd_stnd0006" )
	TppEnemy.SetSneakRoute( "sol_plant0_0007", "rts_dd_stnd0007" )
	TppEnemy.SetSneakRoute( "sol_plant0_0008", "rts_dd_stnd0008" )
	TppEnemy.SetSneakRoute( "sol_plant0_0009", "rts_dd_stnd0009" )
	TppEnemy.SetSneakRoute( "sol_plant0_0010", "rts_dd_stnd0010" )
	TppEnemy.SetSneakRoute( "sol_plant0_0011", "rts_dd_stnd0011" )
	TppEnemy.SetSneakRoute( "sol_reserve_0000", "rts_reserve_0000" )
	TppEnemy.SetSneakRoute( "sol_reserve_0001", "rts_reserve_0001" )
end


this.SetIdleRoute = function ()
	Fox.Log("#### s10030_enemy.SetIdleRoute ####")
	TppEnemy.SetSneakRoute( "sol_plant0_0000", "rts_dd_stnd0000", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_plant0_0001", "rts_dd_stnd0001", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_plant0_0002", "rts_dd_stnd0002", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_plant0_0003", "rts_dd_stnd0003", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_plant0_0004", "rts_dd_stnd0004", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_plant0_0005", "rts_dd_stnd0005", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_plant0_0006", "rts_dd_stnd0006", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_plant0_0007", "rts_dd_stnd0007", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_plant0_0008", "rts_dd_stnd0008", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_plant0_0009", "rts_dd_stnd0009", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_plant0_0010", "rts_dd_stnd0010", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_plant0_0011", "rts_dd_stnd0011", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_reserve_0000", "rts_reserve_0000", 0, { isRelaxed=true, } )
	TppEnemy.SetSneakRoute( "sol_reserve_0001", "rts_reserve_0001", 0, { isRelaxed=true, } )
end


this.SetTutorialRoute = function (routeId)	
	Fox.Log("#### s10030_enemy.SetTutorialRoute ####")

	
	local i = 1
	for index, enemyName in pairs(this.TUTORIAL_SOLDIER_GROUP) do
		
		if TppEnemy.IsEliminated(enemyName) == false and TppEnemy.GetLifeStatus( enemyName ) == TppEnemy.LIFE_STATUS.NORMAL then
			if i == 1 then
				TppEnemy.SetSneakRoute( enemyName, routeId)
				Fox.Log("#### found dd soldier  ####")
				return true	
			end
		end
	end
	Fox.Log("#### not found dd soldier  ####")
	return false	
end


this.SetTutorialRouteTwin = function (routeId)	
	Fox.Log("#### s10030_enemy.SetTutorialRoute ####")

	
	local i = 1
	for index, enemyName in pairs(this.TUTORIAL_SOLDIER_GROUP) do
		
		if TppEnemy.IsEliminated(enemyName) == false and TppEnemy.GetLifeStatus( enemyName ) == TppEnemy.LIFE_STATUS.NORMAL then
			if i == 1 then
				Fox.Log("#### arleady found dd soldier first  ####")
			elseif i == 2 then
				TppEnemy.SetSneakRoute( enemyName, routeId)
				Fox.Log("#### found dd soldier second ####")
				return true	
			end
		end
	end
	Fox.Log("#### not found dd soldier  ####")
	return false	
end


this.CheckConciousSoldier = function ()
	Fox.Log("#### s10030_enemy.CheckConciousSoldier ####")
	local i = 1
	for index, enemyName in pairs(this.ALL_SOLDIER_GROUP) do
		if	TppEnemy.IsEliminated(enemyName) == false then
			if (TppEnemy.GetLifeStatus(enemyName) == TppEnemy.LIFE_STATUS.SLEEP) 
					or (TppEnemy.GetLifeStatus(enemyName) == TppEnemy.LIFE_STATUS.FAINT) 		then
				Fox.Log("#### Some Soldier Down not stop fulton timer ####")	
				return nil
			end
			i = i + 1
		end
	end
	Fox.Log("#### all soldier concious stop fulton timer ####")
	GkEventTimerManager.Stop( "Timer_NeverFulton" )	
end


this.SetClearedRoute = function ()
	Fox.Log("#### s10030_enemy.SetClearedRoute ####")
	local i = 1
	for index, enemyName in pairs(this.ALL_TUTORIAL_SOLDIER_GROUP) do
		if TppEnemy.IsNeutralized(enemyName) == false and TppEnemy.IsEliminated(enemyName) == false then	
			this.SetNoSalute(enemyName)
			TppEnemy.SetSneakRoute( enemyName, CLEARED_ROUTE_TABLE[i])
			i = i + 1
		end
	end
	for index, enemyName in pairs(this.ALL_TUTORIAL_SOLDIER_GROUP) do
		if TppEnemy.IsNeutralized(enemyName) == true then	
			this.SetNoSalute(enemyName)
			TppEnemy.SetSneakRoute( enemyName, CLEARED_ROUTE_TABLE[i])
			i = i + 1
		end
	end
end




this.SetRideHeliRoute = function ()
	Fox.Log("#### s10030_enemy.SetRideHeliRoute ####")

	svars.isReserve_05 = true	
	TppEnemy.SetSneakRoute( "Ocelot", "rts_oc_goodbye" )	
	local i = 1
	for index, enemyName in pairs(this.ALL_TUTORIAL_SOLDIER_GROUP) do
		if TppEnemy.IsNeutralized(enemyName) == false and TppEnemy.IsEliminated(enemyName) == false then	
			this.SetNoSalute(enemyName)
			TppEnemy.SetSneakRoute( enemyName, RIDE_HELI_ROUTE_TABLE[i])
			i = i + 1
		end
	end
	for index, enemyName in pairs(this.ALL_TUTORIAL_SOLDIER_GROUP) do
		if TppEnemy.IsNeutralized(enemyName) == true then	
			this.SetNoSalute(enemyName)
			TppEnemy.SetSneakRoute( enemyName, RIDE_HELI_ROUTE_TABLE[i])
			i = i + 1
		end
	end
end



this.SetGoodbyeRoute = function ()
	Fox.Log("#### s10030_enemy.SetRideHeliRoute ####")
	local i = 1
	for index, enemyName in pairs(this.ALL_TUTORIAL_SOLDIER_GROUP) do
		if TppEnemy.IsNeutralized(enemyName) == false and TppEnemy.IsEliminated(enemyName) == false then	
			this.SetNoSalute(enemyName)
			TppEnemy.SetSneakRoute( enemyName, GOODBYE_ROUTE_TABLE[i])
			i = i + 1
		end
	end
	for index, enemyName in pairs(this.ALL_TUTORIAL_SOLDIER_GROUP) do
		if TppEnemy.IsNeutralized(enemyName) == true then	
			this.SetNoSalute(enemyName)
			TppEnemy.SetSneakRoute( enemyName, GOODBYE_ROUTE_TABLE[i])
			i = i + 1
		end
	end

	
	i = 1
	for index, enemyName in pairs(this.STABLE_SOLDIER_GROUP) do
		this.SetNoSalute(enemyName)
		TppEnemy.SetSneakRoute( enemyName, GOODBYE_ROUTE_TABLE_STABLE[i])
		i = i + 1
	end
end


this.SetCqcRoute = function ()
	Fox.Log("#### s10030_enemy.SetCqcRoute ####")

	if svars.isReserve_05 == true then	
		TppEnemy.SetSneakRoute( "Ocelot", "rts_oc_stnd" )	
	end

	local i = 1
	for index, enemyName in pairs(this.TUTORIAL_SOLDIER_GROUP) do
		if TppEnemy.IsNeutralized(enemyName) == false and TppEnemy.IsEliminated(enemyName) == false then	
			this.SetNoSalute(enemyName)
			TppEnemy.SetSneakRoute( enemyName, CQC_ROUTE_TABLE[i])
			i = i + 1
		end
	end
	for index, enemyName in pairs(this.TUTORIAL_SOLDIER_GROUP) do
		if TppEnemy.IsNeutralized(enemyName) == true then	
			this.SetNoSalute(enemyName)
			TppEnemy.SetSneakRoute( enemyName, CQC_ROUTE_TABLE[i])
			i = i + 1
		end
	end
end


this.SetDDSoldierFultonFlag = function ()
	Fox.Log("#### s10030_enemy.SetDDSoldierFultonFlag ####")
	local i = 1
	local sequence = TppSequence.GetCurrentSequenceName() 
	for index, enemyName in pairs(this.ALL_SOLDIER_GROUP) do
		if	TppEnemy.IsEliminated(enemyName) == true then
			if i == 1 then
				Fox.Log("#### Eliminated sol_plant0_0000 ####" .. index)
				svars.isFulton_sol_plant0_0000 = true
			elseif i == 2 then
				Fox.Log("#### Eliminated sol_plant0_0001 ####" .. index)
				svars.isFulton_sol_plant0_0001 = true
			elseif i == 3 then
				Fox.Log("#### Eliminated sol_plant0_0002 ####" .. index)
				svars.isFulton_sol_plant0_0002 = true
			elseif i == 4 then
				Fox.Log("#### Eliminated sol_plant0_0003 ####" .. index)
				svars.isFulton_sol_plant0_0003 = true
			elseif i == 5 then
				Fox.Log("#### Eliminated sol_plant0_0004 ####" .. index)
				svars.isFulton_sol_plant0_0004 = true

			elseif i == 6 then
				Fox.Log("#### Eliminated sol_plant0_0005 ####" .. index)
				svars.isFulton_sol_plant0_0005 = true

			elseif i == 7 then
				Fox.Log("#### Eliminated sol_plant0_0006 ####" .. index)
				svars.isFulton_sol_plant0_0006 = true

			elseif i == 8 then
				Fox.Log("#### Eliminated sol_plant0_0007 ####" .. index)
				svars.isFulton_sol_plant0_0007 = true

			elseif i == 9 then
				Fox.Log("#### Eliminated sol_plant0_0008 ####" .. index)
				svars.isFulton_sol_plant0_0008 = true

			elseif i == 10 then
				Fox.Log("#### Eliminated sol_plant0_0009 ####" .. index)
				svars.isFulton_sol_plant0_0009 = true

			elseif i == 11 then
				Fox.Log("#### Eliminated sol_plant0_0010 ####" .. index)
				svars.isFulton_sol_plant0_0010 = true

			elseif i == 12 then
				Fox.Log("#### Eliminated sol_plant0_0011 ####" .. index)
				svars.isFulton_sol_plant0_0011 = true

			
			elseif i == 13 then
				if ( sequence == "Seq_Game_TutorialCQC20" ) 
						or  ( sequence == "Seq_Game_TutorialCQC20" ) 
						or  ( sequence == "Seq_Game_TutorialCQC30" ) then

					Fox.Log("#### Eliminated sol_reserve_0000 ####" .. index)
					svars.isFulton_sol_reserve_0000 = true
				else
					Fox.Log("#### now disable sol_reserve_0000 ####" .. index)
				end
			elseif i == 14 then
				if ( sequence == "Seq_Game_TutorialCQC20" ) 
						or  ( sequence == "Seq_Game_TutorialCQC20" ) 
						or  ( sequence == "Seq_Game_TutorialCQC30" ) then
					Fox.Log("#### Eliminated sol_reserve_0001 ####" .. index)
					svars.isFulton_sol_reserve_0001 = true
				else
					Fox.Log("#### now disable sol_reserve_0001 ####" .. index)
				end
			else
				Fox.Log("#### Append Tutorial Soldier or  illegal Eliminated id ####" .. index)
			end
		end
		i = i +1
	end

end


this.SetReserveSoldierDisable = function ()
	Fox.Log("#### s10030_enemy.SetReserveSoldierEnable ####")

	this.SwitchEnableSoldier( "sol_reserve_0000", false )
	this.SwitchEnableSoldier( "sol_reserve_0001", false )


end


this.WarpSoldierToTutorialPosition = function(soldierName)
	Fox.Log("#### s10030_enemy.WarpSoldierToTutorialPosition ####")
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
	local pos =  Vector3(
		28.114,
		0.8,
		-10.375
	)
	SendCommand( gameObjectId, { id="Warp", position = pos } )--RETAILBUG: orphan, SendCommand not localopt. no references to function anyway.
end

function this.OcelotAction()
	local gameObjectId = GameObject.GetGameObjectId( "Ocelot" )
	local command = { id = "SetRandomActing", actions = { "ocelot_aa", "ocelot_b", "ocelot_c", }, intervalMax = 20.0, intervalMin = 10.0, }
	GameObject.SendCommand( gameObjectId, command )
end

function this.OcelotGoodbye()
	local gameObjectId = GameObject.GetGameObjectId( "Ocelot" )
	GameObject.SendCommand( gameObjectId, {
			id="SpecialAction",
			action = "ocelot_go_heli",
	} )
end


this.SetSaluteAll = function ()
	Fox.Log("#### s10030_enemy.SetSaluteAll ####")
	local i = 1
	for index, enemyName in pairs(this.ALL_SOLDIER_GROUP) do
		if	TppEnemy.IsEliminated(enemyName) == false then	
			this.SetSalute(enemyName)
			i = i + 1
		end
	end
end

this.SetSaluteCQCAll = function ()
	Fox.Log("#### s10030_enemy.SetSaluteCQCAll ####")
	local i = 1
	for index, enemyName in pairs(this.ALL_SOLDIER_GROUP) do
		if	TppEnemy.IsEliminated(enemyName) == false then	
			this.SetSaluteToCqc(enemyName)
			i = i + 1
		end
	end
end

this.SetSaluteNormalAll = function ()
	Fox.Log("#### s10030_enemy.SetSaluteNormalAll ####")
	local i = 1
	for index, enemyName in pairs(this.ALL_SOLDIER_GROUP) do
		if	TppEnemy.IsEliminated(enemyName) == false then	
			this.SetSaluteToNormal(enemyName)
			i = i + 1
		end
	end
end


this.SetSalute = function (soldierName)
	Fox.Log("#### s10030_enemy.SetSalute ####")
	local SendCommand = GameObject.SendCommand

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
	local command = { id="SetSaluteDisable", enabled = false }
	GameObject.SendCommand( gameObjectId, command )

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
	local command = { id="SetSaluteToCqc", enabled = false }
	GameObject.SendCommand( gameObjectId, command )
end


this.SetNoSalute = function (soldierName)
	Fox.Log("#### s10030_enemy.SetNoSalute ####")
	local SendCommand = GameObject.SendCommand

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
	local command = { id="SetSaluteDisable", enabled = true }
	GameObject.SendCommand( gameObjectId, command )

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
	local command = { id="SetSaluteToCqc", enabled = false }
	GameObject.SendCommand( gameObjectId, command )
end


this.SetSaluteToCqc = function (soldierName)
	Fox.Log("#### s10030_enemy.SetSaluteToCqc ####")
	local SendCommand = GameObject.SendCommand

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
	local command = { id="SetSaluteToCqc", enabled = true }
	GameObject.SendCommand( gameObjectId, command )
end


this.SetSaluteToNormal = function (soldierName)
	Fox.Log("#### s10030_enemy.SetSaluteToCqc ####")
	local SendCommand = GameObject.SendCommand

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
	local command = { id="SetSaluteToCqc", enabled = false }
	GameObject.SendCommand( gameObjectId, command )
end

this.SetDisableChatAll = function ()
	Fox.Log("#### s10030_enemy.SetDisableChatAll ####")
	local gameObjectId = { type="TppCommandPost2" } 
	local command = { id="SetChatEnable", enabled=false } 
	GameObject.SendCommand( gameObjectId, command )
end



this.SetRouteAfterDemo = function ()
	
	

end





this.PopUpSoldier = function ( soldierName, popUpRoute )
	Fox.Log("#### s10030_enemy.PopUpSoldier ####")

	
	TppEnemy.SetSneakRoute( soldierName, popUpRoute )

	
	this.SwitchEnableSoldier( soldierName, true )

end






this.SetEnemyLifeState = function ( gameObjectId, soldierState )
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local gameObjectId = soldierState.soldierName
	
	local command = { id = "ChangeLifeState", state = soldierState.lifeState } 
	local actionState = GameObject.SendCommand( gameObjectId, command )
end





this.SetEnemyDownWithAttackId = function ( gameObjectId, attackId, allowDownAttackId )
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	

	if ( attackId == allowDownAttackId ) then
		Fox.Log("*** attackId" .. attackId .. " allowDownAttackId" .. allowDownAttackId .. "***")
		
		local command = { id = "SetDisableDamage", life = false, faint = false, sleep = false }
		local actionState = GameObject.SendCommand( gameObjectId, command )

		
		local command = { id = "ChangeLifeState", state = 2 } 
		local actionState = GameObject.SendCommand( gameObjectId, command )
	end
end


this.SetEnemyStaffParameter = function( soldierName, uniqueTypeId )
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local gameObjId = GetGameObjectId(soldierName)

	
	TppEnemy.AssignUniqueStaffType{	locaterName = soldierName,	uniqueStaffTypeId = uniqueTypeId,	}

end


this.SetAllEnemyStaffParam = function ()
	Fox.Log("#### s10030_enemy.SetAllEnemyStaffParam ####")

	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[1], 3 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[2], 4 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[3], 5 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[4], 6 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[5], 7 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[6], 8 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[7], 9 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[8], 10 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[9], 33 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[10], 34 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[11], 35 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[12], 36 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[13], 45 )
	this.SetEnemyStaffParameter(this.soldierDefine.mtbs_commandFacility_cp[14], 46 )


end




this.SetRatRoute = function ()
	Fox.Log("#### s10030_enemy.SetRatRoute ####")
	local SendCommand = GameObject.SendCommand

	local gameObjectId 
	local command 
	gameObjectId = {type = "TppRat", index = 0}
	command = {
			id="SetRoute",                  
			name="anml_rat_00",    
			ratIndex = 0,                   
			route="route_rat_0000",             
	}
	GameObject.SendCommand( gameObjectId, command )

	command = {
			id="SetRoute",                  
			name="anml_rat_01",    
			ratIndex = 0,                   
			route="route_rat_0001",             
	}
	GameObject.SendCommand( gameObjectId, command )

	command = {
			id="SetRoute",                  
			name="anml_rat_02",    
			ratIndex = 0,                   
			route="route_rat_0002",             
	}
	GameObject.SendCommand( gameObjectId, command )
	command = {
			id="SetRoute",                  
			name="anml_rat_03",    
			ratIndex = 0,                   
			route="route_rat_0000",             
	}
	GameObject.SendCommand( gameObjectId, command )
	command = {
			id="SetRoute",                  
			name="anml_rat_04",    
			ratIndex = 0,                   
			route="route_rat_0004",             
	}
	GameObject.SendCommand( gameObjectId, command )
	--RETAILBUG: theres no rat 5
	command = {
			id="SetRoute",                  
			name="anml_rat_05",    
			ratIndex = 0,                   
			route="route_rat_0005",             
	}
	GameObject.SendCommand( gameObjectId, command )
end







return this
