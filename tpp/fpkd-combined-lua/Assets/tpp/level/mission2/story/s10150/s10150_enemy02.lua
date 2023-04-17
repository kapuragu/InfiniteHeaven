local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}


this.routeChangeTableRoot = {}
local START_EV_TIME = 2
local EVOUT_TIME = 5 
local START_VEHICLE_TIME = 30


local RIDE_EV_MAX_NUM = 4 	
local MAX_RIDE_PEOPLE = 10	

local RELACTIVE_VEHICLE_GROUP = {
	
	vehs_citadel_0000 = 	{
				{ "sol_skull_0006", false },
				{ "sol_skull_0007", false },
				{ "sol_skull_0008", false },
				{ "sol_skull_0009", false },
			},
	vehs_citadel_0001 = 	{
				{ "sol_skull_0000", false },
				{ "sol_skull_0001", false },
			},
	vehs_citadel_0002 = 	{
				{ "sol_skull_0012", false },
				{ "sol_skull_0013", false },
				{ "sol_skull_0010", false },
				{ "sol_skull_0011", false },
			},
}


local EVENT_SOLDEIRS_01 = {
	"sol_event_0000",
	"sol_event_0001",
	"sol_event_0002",
	"sol_event_0003",
	"sol_event_0004",
	"sol_event_0005",
	"sol_event_0006",
	"sol_event_0007",
}
local EVENT_SOLDEIRS_02 = {
	"sol_skull_0014",
	"sol_skull_0015",
	"sol_skull_0016",
	"sol_skull_0017",
	"sol_skull_0018",
	"sol_skull_0019",
	"sol_skull_0020",
	"sol_skull_0021",
	"sol_skull_0022",
	"sol_skull_0023",
}
local EVENT_SOLDEIRS_03 = {
	"sol_skull_0002",
	"sol_skull_0003",
	"sol_skull_0004",
	"sol_skull_0005",
}





this.skullRouteTable = {
	trap_walk_Skull_1000 = {
		progress = 10,
		route = "rts_skull_walk_1000",
		nextPoint = -1,
		disableAdjustMoving = false,
	},
	trap_walk_Skull_2000 = {
		progress = 20,
		route = "rts_skull_walk_2000",
		nextPoint = -1,
		disableAdjustMoving = false,
	},
	trap_walk_Skull_3000 = {
		progress = 30,
		route = "rts_skull_walk_3000",
		nextPoint = -1,
		disableAdjustMoving = false,
	},
	trap_walk_Skull_4000 = {
		progress = 40,
		route = "rts_skull_walk_4000",
		nextPoint = 7,
		disableAdjustMoving = true,
	},
	trap_walk_Skull_5000 = {
		progress = 50,
		route = "rts_skull_walk_5000",
		nextPoint = 15,
		disableAdjustMoving = true,
	},
	trap_walk_Skull_6000 = {
		progress = 60,
		route = "",
		nextPoint = -1,
		disableAdjustMoving = false,
	},
	trap_walk_Skull_7000 = {
		progress = 70,
		route = "",
		nextPoint = -1,
		disableAdjustMoving = false,
	},
	
	










}

this.skullTalkTable = {

	
	trap_talk_Skull04 =  "SFT_04",
	trap_talk_Skull06 =  "SFT_06",
	trap_talk_Skull07 =  "SFT_07",
	trap_talk_Skull08 =  "SFT_08",
	trap_talk_Skull09 =  "SFT_09",
	trap_talk_Skull10 =  "SFT_10",
	trap_talk_Skull11 =  "SFT_11",
	trap_talk_Skull12 =  "SFT_12",
	trap_talk_Skull13 =  "SFT_13",

}


this.syncRouteTable = {
	sync_bringer = {
		"rts_bringer_A",
		"rts_bringer_B",
		script = true,
	},
}

this.bringerRouteTable = {
	trap_walk_Bringer005 = {
		progress = 05,
		syncRouteStep = 1,
	},
	trap_walk_Bringer010 = {
		progress = 10,
		syncRouteStep = 2,
	},
	trap_walk_Bringer020 = {
		progress = 20,
		syncRouteStep = 3,
	},
	trap_walk_Bringer030 = {
		progress = 30,
		syncRouteStep = 4,
	},
	trap_walk_Bringer040 = {
		progress = 40,
		syncRouteStep = 5,
	},
	trap_walk_Bringer050 = {
		progress = 50,
		syncRouteStep = 8,
	},
	trap_walk_Bringer060 = {
		progress = 60,
		routeA = "rts_bringer_06_A",
		routeB = "rts_bringer_06_B",
		isBring = true
	},
	trap_walk_Bringer070 = {
		progress = 70,
		routeA = "rts_skulls_inEV0000",
		routeB = "rts_skulls_inEV0001",
		isBring = false
	
	},
}

this.EventHeliTable = {
	
	trap_heli0000 = {
		heliList =	{ 
			"OtherHeli0001",
			"OtherHeli0002",
			"OtherHeli0003",
		},			
		warpFlag = true,			
		routeList = {
			"rts_heli_h0000_01_hov",
			"rts_heli_h0000_02_hov",
			"rts_heli_h0000_03_hov",	
		},
	},
	trap_heli0100 = {
		heliList =	{ 
			"OtherHeli0001",
		},	
		warpFlag = false,
		routeList = {
			"rts_heli_h0100_01_start",
		},
	},
	trap_heli0200 = {
		heliList =	{ 
			"OtherHeli0002",
		},	
		warpFlag = false,
		routeList = {
			"rts_heli_h0200_02_start",
		},
	},
	trap_heli0300 = {
		heliList =	{ 
			"OtherHeli0003",
		},	
		warpFlag = false,
		routeList = {
			"rts_heli_h0300_03_start",
		},
	},
	trap_heli0400 = {
		heliList =	{ 
			"OtherHeli0001",
			"OtherHeli0002",
			"OtherHeli0004",
			
		},	
		warpFlag = true,
		routeList = {
			"rts_heli_h0400_01_start",
			"rts_heli_h0400_02_start",
			"rts_heli_h0400_04_start",
			
		},
	},	
	trap_heli0500 = {
		heliList =	{ 
			"OtherHeli0003",
		},	
		warpFlag = true,
		routeList = {
			"rts_heli_h0500_03_start",
		},
	},
	trap_heli0600 = {
		heliList =	{ 
			"OtherHeli0001",
			"OtherHeli0002",
			"OtherHeli0003",
			"OtherHeli0004",
			"OtherHeli0005",
		},			
		warpFlag = true,			
		routeList = {
			"rts_heli_h0600_01_hov",
			"rts_heli_h0600_02_hov",
			"rts_heli_h0600_03_hov",
			"rts_heli_h0600_04_hov",
			"rts_heli_h0600_05_hov",
		},
	},	
	trap_heli0700 = {
		heliList =	{ 
			"OtherHeli0001",
			"OtherHeli0002",
			"OtherHeli0003",
			"OtherHeli0004",
			"OtherHeli0005",
		},			
		warpFlag = false,			
		routeList = {
			"rts_heli_h0700_01_start",
			"rts_heli_h0700_02_start",
			"rts_heli_h0700_03_start",
			"rts_heli_h0700_04_start",
			"rts_heli_h0700_05_start",
		},
	},
	trap_heli0800 = {
		heliList =	{ 
			"WestHeli",
		},	
		warpFlag = true,
		routeList = {
			"rts_heli_h0800_sup_start",
		},
	},
	trap_heli0900 = {
		heliList =	{ 
			"OtherHeli0001",
		},	
		warpFlag = true,
		routeList = {
			"rts_heli_h0900_01_start",
		},
	},	
	
}


this.EventSolTable = {
	
	trap_0000_EV2 = {
		enemyList =	EVENT_SOLDEIRS_02,

		routeList = {
			"rts_e0000_0000",
			"rts_e0000_0001",
			"rts_e0000_0002",
			"rts_e0000_0003",
			"rts_e0000_0004",
			"rts_e0000_0005",
			"rts_e0000_0006",
			"rts_e0000_0007",
			"rts_e0000_0008",
			"rts_e0000_0009",
		},

		ignoreDisableNpc = true,
	},

	trap_0100_EV3 = {
		enemyList =	EVENT_SOLDEIRS_03,

		routeList = {
			"rts_e0100_0000",
			"rts_e0100_0001",
			"rts_e0100_0002",
			"rts_e0100_0003",
		},
	},
	
	trap_0200_EV1 = {
		enemyList =	EVENT_SOLDEIRS_01,

		routeList = {
			"rts_e0200_0000",
			"rts_e0200_0001",
			"rts_e0200_0002",
			"rts_e0200_0003",
			"rts_e0200_0004",
			"rts_e0200_0005",
			"rts_e0200_0006",
			"rts_e0200_0007",
		},
	},
	
	trap_0300_EV2 = {
		enemyList =	EVENT_SOLDEIRS_02,

		routeList = {
			"rts_e0300_0000",
			"rts_e0300_0001",
			"rts_e0300_0002",
			"rts_e0300_0003",
			"rts_e0300_0004",
			"rts_e0300_0005",
			"rts_e0300_0006",
			"rts_e0300_0007",
			"rts_eventdummy",
			"rts_eventdummy",
		},
	},
	
	trap_0400_EV3 = {
		enemyList =	EVENT_SOLDEIRS_03,

		routeList = {
			"rts_e0400_0000",
			"rts_e0400_0001",
			"rts_e0400_0002",
			"rts_e0400_0003",
		},
	},
	
	trap_0500_EV1 = {
		enemyList =	EVENT_SOLDEIRS_01,

		routeList = {
			"rts_e0500_0000",
			"rts_e0500_0001",
			"rts_e0500_0002",
			"rts_e0500_0003",
			"rts_eventdummy",
			"rts_eventdummy",
			"rts_eventdummy",
			"rts_eventdummy",
		},
	},
	
	trap_0600_EV2 = {
		enemyList =	EVENT_SOLDEIRS_02,

		routeList = {
			"rts_e0600_0000",
			"rts_e0600_0001",
			"rts_e0600_0002",
			"rts_e0600_0003",
			"rts_e0600_0004",
			"rts_e0600_0005",
			"rts_e0600_0006",
			"rts_e0600_0007",
			"rts_e0600_0008",
			"rts_e0600_0009",
		},
	},

	trap_0700_EV3 = {
		enemyList =	EVENT_SOLDEIRS_03,

		routeList = {
			"rts_e0700_0000",
			"rts_e0700_0001",
			"rts_e0700_0002",
			"rts_e0700_0003",
		},
	},

	trap_0800_EV1 = {
		enemyList =	EVENT_SOLDEIRS_01,

		routeList = {
			"rts_e0800_0000",
			"rts_e0800_0001",
			"rts_e0800_0002",
			"rts_e0800_0003",
			"rts_e0800_0004",
			"rts_e0800_0005",
			"rts_e0800_0006",
			"rts_e0800_0007",
		},
	},
	
	trap_0900_EV2 = {
		enemyList =	EVENT_SOLDEIRS_02,

		routeList = {
			"rts_e0900_0000",
			"rts_e0900_0001",
			"rts_e0900_0002",
			"rts_e0900_0003",
			"rts_e0900_0004",
			"rts_e0900_0005",
			"rts_e0900_0006",
			"rts_eventdummy",
			"rts_eventdummy",
			"rts_eventdummy",
		},
	},

}





this.soldierDefine = {
	
	afgh_skull_cp = {
		
		"sol_skull_0000",
		"sol_skull_0001",
		"sol_skull_0002",
		"sol_skull_0003",
		"sol_skull_0004",
		"sol_skull_0005",

		
		"sol_skull_0006",
		"sol_skull_0007",
		"sol_skull_0008",
		"sol_skull_0009",

		"sol_skull_0010",
		"sol_skull_0011",
		"sol_skull_0012",
		"sol_skull_0013",


		
		"sol_skull_0014",
		"sol_skull_0015",
		"sol_skull_0016",
		"sol_skull_0017",
		"sol_skull_0018",
		"sol_skull_0019",
		"sol_skull_0020",
		"sol_skull_0021",
		"sol_skull_0022",
		"sol_skull_0023",



		"sol_event_0000",
		"sol_event_0001",
		"sol_event_0002",
		"sol_event_0003",
		"sol_event_0004",
		"sol_event_0005",
		"sol_event_0006",
		"sol_event_0007",
		nil
	},

	afgh_event_cp = {

		nil,
	},
	nil
}





this.routeSets = {
	
	afgh_skull_cp = {
		priority = {
			"groupA",
		},
		sneak_day = {
			groupA = {
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",	
				
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",	
				
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",	
				
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",
				"rts_eventdummy",	
			},
			nil
		},
		sneak_night = sneak_day,--RETAILBUG undefined
		caution = sneak_day,--RETAILBUG undefined
		nil
	},
	
	nil
}







this.routeChangeTableRoot[ StrCode32( "rideEV" ) ] = {

	{ 	func = function()

			
			
			

			TppEnemy.SetSneakRoute( "sol_skull_0010" , "rts_skulls_inEV0002")
			TppEnemy.SetSneakRoute( "sol_skull_0011" , "rts_skulls_inEV0003")

			
			
			
			
		end
	},
}
this.routeChangeTableRoot[ StrCode32( "rideEvPlayer" ) ] = {

	{ 	func = function()

			
			this.SetUpSkullSolBringPlayer(false)

			
			TppEnemy.SetSneakRoute( "sol_skull_0000" , "rts_skulls_inEV0000")
			TppEnemy.SetSneakRoute( "sol_skull_0001" , "rts_skulls_inEV0001")


		end
	},
}

this.routeChangeTableRoot[ StrCode32( "rideEvSol" ) ] = {

	{ 	func = function()
			mvars.RideEvNum = mvars.RideEvNum + 1
			mvars.SkullFaceState = 9999
			this.SetSkullRoute( "rts_skull_ev_idle" )
			Fox.Log( "rideEV //// mvars.RideEvNum: " .. mvars.RideEvNum )
			this.StartEv()
		end
	},
}



this.routeChangeTableRoot[ StrCode32( "outEV" ) ] = {

	{ 	func = function()
			Fox.Log("______________outEV")

			mvars.SkullFaceState = 100
			mvars.PlayerStateForSkull = 100

			mvars.BringerAState = 100
			mvars.BringerBState = 100

			TppEnemy.SetSneakRoute( "SkullFace" , "rts_skull_walk_afterEV")

			TppEnemy.SetSneakRoute( "sol_skull_0010" , "rts_skullsC_walk_afterEV_0010", nil, { isRelaxed=true } )
			TppEnemy.SetSneakRoute( "sol_skull_0011" , "rts_skullsC_walk_afterEV_0011", nil, { isRelaxed=true } )

			TppEnemy.SetSneakRoute( "sol_skull_0008" , "rts_skullsA_walk_afterEV_0008", nil, { isRelaxed=true } )
			TppEnemy.SetSneakRoute( "sol_skull_0009" , "rts_skullsA_walk_afterEV_0009", nil, { isRelaxed=true } )

			
			
		end
	},
}


this.routeChangeTableRoot[ StrCode32( "outEV2" ) ] = {

	{ 	func = function()

		
		TppEnemy.SetSneakRoute( "sol_skull_0000" , "rts_skullsB_toVehicle_0000" )
		TppEnemy.SetSneakRoute( "sol_skull_0001" , "rts_skullsB_toVehicle_0001" )

		
		TppEnemy.SetSneakRoute( "sol_skull_0008" , "rts_skullsA_ride_0008")
		TppEnemy.SetSneakRoute( "sol_skull_0009" , "rts_skullsA_ride_0009")

		end
	},
}

this.routeChangeTableRoot[ StrCode32( "setBring" ) ] = {

	{ 	func = function()
			
			
		end
	},
}




this.routeChangeTableRoot[ StrCode32( "rideSkull" ) ] = {

	{ 	func = function()
			Fox.Log( "rideSkull playerState:" .. mvars.PlayerStateForSkull .. " skullState:" .. mvars.SkullFaceState )
			if mvars.PlayerStateForSkull >= 110 then
				Fox.Log( "rideSkull DIRECT" )
				
				this.SetSkullFaceRideVehicleAction()
				mvars.SkullFaceState = 120
			elseif mvars.SkullFaceState < 110 then
				Fox.Log( "rideSkull WAIT PLAYER" )
				
				this.SetSkullFaceWarnsPlayerSpecialAction( "stateStandActionD" )
				this.TalkSkullFace( "SFT_05" )
				GkEventTimerManager.Start( "SkullWarnsPlayerTimer110", 30 )
				mvars.SkullFaceState = 110
			end

			
			TppEnemy.SetSneakRoute( "sol_skull_0000" , "rts_skullsB_toVehicle_0000" )
			TppEnemy.SetSneakRoute( "sol_skull_0001" , "rts_skullsB_toVehicle_0001" )

			
			TppEnemy.SetSneakRoute( "sol_skull_0010" , "rts_skullsC_ride_0010")
			TppEnemy.SetSneakRoute( "sol_skull_0011" , "rts_skullsC_ride_0011")
			TppEnemy.SetSneakRoute( "sol_skull_0013" , "rts_skullsC_ride_0013")

			
			
			if not svars.isPlayerInEV then
				Fox.Log( "____rideSkull playerState: svars.isPlayerInEV == false" ) 
				s10150_sequence.UnsetHoldPlayer()
				svars.isPlayerInEV = true
			end
		end
	},
}


this.routeChangeTableRoot[ StrCode32( "rideCar" ) ] = {

	{ 	func = function()

			mvars.RideMemberNum = mvars.RideMemberNum + 1
			Fox.Log( "rideCar //// mvars.RideMemberNum: " .. mvars.RideMemberNum .. " svars.isPlayerRidingOn:" ..tostring(svars.isPlayerRidingOn) )

			
			if svars.isPlayerRidingOn then
				if mvars.RideMemberNum ==MAX_RIDE_PEOPLE then
					this.SkullDrive()
				elseif mvars.RideMemberNum == MAX_RIDE_PEOPLE-1 then
					
					TppEnemy.SetSneakRoute( "sol_skull_0000" , "rts_skullsB_ride_0000")
				end
			end
		end
	},
}



this.routeChangeTableRoot[ StrCode32( "startVehicle" ) ] = {

	{ 	func = function()
			
			TppEnemy.SetSneakRoute( "sol_skull_0000" , "rts_skulls_drive")
			TppEnemy.SetSneakRoute( "sol_skull_0001" , "rts_skulls_drive")

			
			TppEnemy.SetSneakRoute( "sol_skull_0002" , "rts_skulls_drive")
			TppEnemy.SetSneakRoute( "sol_skull_0003" , "rts_skulls_drive")
			TppEnemy.SetSneakRoute( "sol_skull_0004" , "rts_skulls_drive")
			TppEnemy.SetSneakRoute( "sol_skull_0005" , "rts_skulls_drive")

		end
	},
}



this.routeChangeTableRoot[ StrCode32( "talk_skull01" ) ] = {
	{ 	func = function()
			this.TalkSkullFace("SFT_01")
		end
	},
}
this.routeChangeTableRoot[ StrCode32( "talk_skull02" ) ] = {
	{ 	func = function()
			this.TalkSkullFace("SFT_02")
		end
	},
}
this.routeChangeTableRoot[ StrCode32( "talk_skull03" ) ] = {
	{ 	func = function()
			this.TalkSkullFace("SFT_03")
		end
	},
}



this.routeChangeTableRoot[ StrCode32( "wait_player" ) ] = {
	{ 	func = function()
			GkEventTimerManager.Start( "SkullWarnsPlayerTimer" .. tostring( mvars.SkullFaceState ), 30 )
		end
	},
}









function this.Messages()

	local messageTable = {
		GameObject = {
			{	
				msg = "RoutePoint2",sender ="SkullFace",
				func = function (id,routeId,routeNode,sendM)
				
					local skullRouteTable = this.skullRouteTable
					
					for i, tName in pairs(skullRouteTable) do
						if sendM == StrCode32( i ) then
							this.UpdateProgressSkullFace(id,sendM)
							return
						end
					end
				
					this.OnRoutePoint(id,routeId,routeNode,sendM)
				end
			},
			{	
				msg = "RoutePoint2",
				func = function (id,routeId,routeNode,sendM)
					if sendM == StrCode32("rideCar") then
						Fox.Log("id : "..tostring(id))
						this.OnRoutePoint(nil,nil,nil,sendM)

					elseif sendM == StrCode32("rideEvSol") then
						this.OnRoutePoint(nil,nil,nil,sendM)
						
					elseif sendM == StrCode32("setBring") then
						this.OnRoutePoint(nil,nil,nil,sendM)
					elseif sendM == StrCode32("startSecondStep") then
						this.SkullFaceWalkSecondStep()
					else
						
						this.UpdateProgress(id,sendM)
					
					end
					
				end,
				option = { isExecMissionPrepare = true } 	
			},

			{
				
				msg = "VehicleAction",
				func = function ( rideMemberId, vehicleId, actionType )
					Fox.Log("_____VehicleAction___ memberID:" .. tostring(rideMemberId))
					
					local driverId = GameObject.GetGameObjectId("sol_skull_0000")
					
					if ( actionType == TppGameObject.VEHICLE_ACTION_TYPE_GOT_IN_VEHICLE) then
						if rideMemberId == driverId then 
							
							this.ResisterVehicleSE("vehs_citadel_0001","Play_sfx_c_okb_lv_00_00") 
							this.ResisterVehicleSE("vehs_citadel_0000","Play_sfx_c_okb_lv_01_01") 
							this.ResisterVehicleSE("vehs_citadel_0002","Play_sfx_c_okb_lv_02_01") 
							
							




						end
					end
									
				end
			
			},

			{	
				msg = "EventGimmickFinish",
				func = function ( GameObjectId, placedId )
				
					if placedId == StrCode32("afgh_elvt001_gim_n0000|srt_afgh_elvt001") then
						this.OnRoutePoint(nil,nil,nil,StrCode32( "outEV" ))
					end
				end
			},
			{	
				msg = "BringPlayerEvent",
				func = function ( GameObjectId, eventType,eventType2 )
					Fox.Log("_____________BringPlayerEvent______________")
					Fox.Log(GameObjectId)
					Fox.Log(eventType)

					this.WarningPlayer(eventType)


				end
			},
			{	
				msg = "SpecialActionEnd",
				func = function ( GameObjectId, actionId,commandId )
					Fox.Log("_____________SpecialActionEnd______________")
					Fox.Log("____________actionId : "..tostring(actionId))
					Fox.Log("____________commandId : "..tostring(commandId))
					GkEventTimerManager.Start( "SkullWarnsPlayerTimer" .. tostring( commandId ), 30 )
					mvars.SkullFaceState = commandId
				end
			},			
			
			


		},
		Timer = {
			{ msg = "Finish",sender = "StartEvTimer",
				func = function()
					this.StartEv()
				end
			},
			{ msg = "Finish",sender = "StartVehicleTimer",
				func = function()
					
				end
			},
			{ msg = "Finish",sender = "SkullRouteFirstTalkTimer",
				func = function()
					this.TalkSkullFace("SFT_01")
				end
			},
			{ msg = "Finish",sender = "SkullWarnsPlayerTimer20",
				func = function()
					Fox.Log("_____________SkullWarnsPlayerTimer20 Finish______________")
					if mvars.SkullFaceState >= 20 and mvars.PlayerStateForSkull <= 10 then
						this.SetSkullFaceWarnsPlayerSpecialAction20()
						GkEventTimerManager.Start( "SkullWarnsPlayerTimer20", 20 + 2 * math.random( 5 ) )
					else
						GkEventTimerManager.Stop("SkullWarnsPlayerTimer20")
					end
				end
			},
			{ msg = "Finish",sender = "SkullWarnsPlayerTimer30",
				func = function()
					Fox.Log("_____________SkullWarnsPlayerTimer30 Finish______________")
					if mvars.SkullFaceState >= 30 and mvars.PlayerStateForSkull <= 20 then
						this.SetSkullFaceWarnsPlayerSpecialAction20()
						GkEventTimerManager.Start( "SkullWarnsPlayerTimer30", 20 + 2 * math.random( 5 ) )
					else
						GkEventTimerManager.Stop("SkullWarnsPlayerTimer30")
					end
				end
			},
			{ msg = "Finish",sender = "SkullWarnsPlayerTimer40",
				func = function()
					Fox.Log("_____________SkullWarnsPlayerTimer40 Finish______________")
					if mvars.SkullFaceState >= 40 and mvars.PlayerStateForSkull <= 30 then
						this.SetSkullFaceWarnsPlayerSpecialAction20()
						GkEventTimerManager.Start( "SkullWarnsPlayerTimer40", 20 + 2 * math.random( 5 ) )
					else
						GkEventTimerManager.Stop( "SkullWarnsPlayerTimer40" )
					end
				end
			},
			{ msg = "Finish",sender = "SkullWarnsPlayerTimer50",
				func = function()
					Fox.Log("_____________SkullWarnsPlayerTimer50 Finish______________")
					if mvars.SkullFaceState >= 50 and mvars.PlayerStateForSkull <= 40 then
						this.SetSkullFaceWarnsPlayerSpecialAction50()
						GkEventTimerManager.Start( "SkullWarnsPlayerTimer50", 20 + 2 * math.random( 5 ) )
					else
						GkEventTimerManager.Stop( "SkullWarnsPlayerTimer50" )
					end
				end
			},
			{ msg = "Finish",sender = "SkullWarnsPlayerTimer110",
				func = function()
					Fox.Log("_____________SkullWarnsPlayerTimer110 Finish______________")
					if mvars.SkullFaceState <= 110 and mvars.PlayerStateForSkull <= 100 then
						this.SetSkullFaceWarnsPlayerSpecialAction110()
						GkEventTimerManager.Start( "SkullWarnsPlayerTimer110", 20 + 2 * math.random( 5 ) )
					else
						GkEventTimerManager.Stop( "SkullWarnsPlayerTimer110" )
					end
				end
			},
			
			nil
		},
		Trap = {
			
			{ msg = "Enter", sender = "trap_EvOurPlayer",	func = function() this.OnRoutePoint(nil,nil,nil,StrCode32( "outEV2" )) end },
			{ msg = "Enter", sender = "trap_rideVehiclePlayerCheck",
				func = function()
					Fox.Log( "Enter trap_rideVehiclePlayerCheck skullState:" .. mvars.SkullFaceState )
					mvars.PlayerStateForSkull = 110
					if 100 < mvars.SkullFaceState and mvars.SkullFaceState < 120 then
						
						this.SetSkullFaceRideVehicleAction()
					end
				end
			},
			nil
		},
		nil
	}

	for trapName,skullRoute in pairs ( this.skullRouteTable ) do
		local trapTableRoute = {
			msg = "Enter",	sender = trapName,
			func = function ()
				this.UpdatePlayerStateForSkull( trapName )	
				
			end
		}
		table.insert( messageTable.Trap, trapTableRoute )
	end

	for trapName,labelName in pairs ( this.skullTalkTable ) do
		local trapTableTalk = {
			msg = "Enter",	sender = trapName,
			func = function ()	this.TalkSkullFace( labelName )	end
		}
		table.insert( messageTable.Trap, trapTableTalk )
	end

	
	for trapName,routeGroups in pairs ( this.EventSolTable ) do
		local trapTableTalk = {
			msg = "Enter",	sender = trapName,
			func = function ()	this.WarpSetRoute(trapName)	end
		}
		table.insert( messageTable.Trap, trapTableTalk )
	end


	
	for trapName,routeGroups in pairs ( this.EventHeliTable ) do
		local trapTableTalk = {
			msg = "Enter",	sender = trapName,
			func = function ()	this.WarpSetHeli(trapName)	end
		}
		table.insert( messageTable.Trap, trapTableTalk )
	end

	
	for trapName,routeGroups in pairs ( this.bringerRouteTable ) do
		local trapTableRoute = {
			msg = "Enter",	sender = trapName,
			func = function ()
				this.UpdatePlayerState( trapName )
			end
		}
		table.insert( messageTable.Trap, trapTableRoute )
	end

	return
	StrCode32Table( messageTable )

end






this.OnRoutePoint = function( gameObjectId, routeId, routeNodeIndex, messageId )
	Fox.Log( "___________s10150_enemy02.OnRoutePoint():  messageId : " .. tostring(messageId) )
	local routeChangeTables = this.routeChangeTableRoot[ messageId ]
	if routeChangeTables then
		for i, routeChangeTable in ipairs( routeChangeTables ) do
			if routeChangeTable.func then
				routeChangeTable.func()
			end
		end
	else
		Fox.Log( "___________s10150_enemy02.OnRoutePoint(): There is no routeChangeTables!" )
	end
end

this.OnRouteTalkSkull = function( gameObjectId, routeId, routeNodeIndex, messageId )
	if messageId == StrCode32( "talk_skull01" )then
		this.TalkSkullFace("SFT_01")
	elseif messageId == StrCode32( "talk_skull02" )then
		this.TalkSkullFace("SFT_02")
	elseif messageId == StrCode32( "talk_skull02" )then
		this.TalkSkullFace("SFT_02")
	end
end
this.TalkSkullFace = function(labelName)
	local gameObjectId = GameObject.GetGameObjectId("SkullFace")
	local command = {
		id="CallMonologue",
		label = labelName
	}
	GameObject.SendCommand( gameObjectId, command )
end



this.StartEv = function()
	if mvars.RideEvNum == RIDE_EV_MAX_NUM then
		local GameObjectType = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION
		Gimmick.BreakGimmick(GameObjectType,"afgh_elvt001_gim_n0000|srt_afgh_elvt001","/Assets/tpp/level/location/afgh/block_large/citadel/afgh_citadel_gimmick.fox2",0)
	end
end







this.WarpSetRoute = function(trapName)
	Fox.Log("_______s10150_enemy02.WarpSetRoute() : " .. tostring(trapName))

	local solGroup = this.EventSolTable[trapName].enemyList
	local ignoreDisableNpc = this.EventSolTable[trapName].ignoreDisableNpc

	local cmdDisable	= { id="SetEnabled", enabled=false, noAssignRoute=true }
	local cmdEnable		= { id="SetEnabled", enabled=true, noAssignRoute=true }
	local cmdIgnoreDisableNpc = { id="SetIgnoreDisableNpc", enable=true }

	
	for i, enemyName in ipairs( solGroup ) do
		local gameObjectId = GameObject.GetGameObjectId( enemyName )
		GameObject.SendCommand( gameObjectId, cmdDisable )
		TppEnemy.SetSneakRoute( enemyName , this.EventSolTable[trapName].routeList[i])
		GameObject.SendCommand( gameObjectId, cmdEnable )
		if ignoreDisableNpc then
			GameObject.SendCommand( gameObjectId, cmdIgnoreDisableNpc )
		end
	end
end



this.WarningPlayer = function(eventType)
	Fox.Log("_______s10150_enemy02.WarningPlayer() : " .. tostring(eventType))


	local command = { id="RemoveCommandAi" }
	
	if eventType == TppGameObject.BRING_PLAYER_WARNING then
		command = { id="SetCommandAi", commandType = CommandAi.GIVE_WARNING }
	elseif eventType == TppGameObject.BRING_PLAYER_RECOVERED then
		command = { id="RemoveCommandAi" }
	else
		Fox.Log("_______s10150_enemy02.WarningPlayer() : Execute Player")
	end


	for i, name in ipairs( EVENT_SOLDEIRS_02 ) do
		local gameObjectId = GameObject.GetGameObjectId( name )
		GameObject.SendCommand( gameObjectId, command )
	end
end




this.WarpSetHeli = function(trapName)
	Fox.Log("_______s10150_enemy02.WarpSetHeli() : " .. tostring(trapName))

	local heliGroup = this.EventHeliTable[trapName].heliList
	
	
	for i, heliName in ipairs( heliGroup ) do
		Fox.Log(heliName)
		local gameObjectId = GameObject.GetGameObjectId( heliName )
		local cmdSetRoute	= { id="SetForceRoute", route = this.EventHeliTable[trapName].routeList[i], point = 0 ,warp = this.EventHeliTable[trapName].warpFlag }
		GameObject.SendCommand( gameObjectId, cmdSetRoute )
	end
end


this.SetUpOtherHeli2Sound = function()
	local heliGroup = {
		"OtherHeli0001",
		"OtherHeli0002",
		"OtherHeli0003",
		"OtherHeli0004",
		"OtherHeli0005",
	}

	for i, heliName in ipairs( heliGroup ) do
		local gameObjectId = GameObject.GetGameObjectId( heliName )
		local cmdSound	= { id="SetRotorSoundEnabled", enabled=false }
		GameObject.SendCommand( gameObjectId, cmdSound )
	end
end


this.SetUpHeliSkull = function()
	local gameObjectId = GameObject.GetGameObjectId("WestHeli" )
	GameObject.SendCommand( gameObjectId, { id="SetMeshType" , typeName="uth_v01"})				
	
	GameObject.SendCommand( GameObject.GetGameObjectId( "WestHeli" ), { id="SetForceRoute" , route = "rts_h_heli_skull_talk_beforeEV" })
end







this.SkullWalk = function()
	

	TppEnemy.SetSneakRoute( "sol_skull_0000" , "rts_bringer_A")
	TppEnemy.SetSneakRoute( "sol_skull_0001" , "rts_bringer_B")

	TppEnemy.SetSneakRoute( "sol_skull_0002" , "rts_skull_wait_beforeEV0000")
	TppEnemy.SetSneakRoute( "sol_skull_0003" , "rts_skull_wait_beforeEV0001")
	TppEnemy.SetSneakRoute( "sol_skull_0004" , "rts_skull_wait_beforeEV0002")
	TppEnemy.SetSneakRoute( "sol_skull_0005" , "rts_skull_wait_beforeEV0003")

	
	
	
	TppEnemy.SetSneakRoute( "sol_skull_0008" , "rts_skullsA_walk_afterEV0002")
	TppEnemy.SetSneakRoute( "sol_skull_0009" , "rts_skullsA_walk_afterEV0003")

	
	TppEnemy.SetSneakRoute( "sol_skull_0013" , "rts_skullsA_walk_afterEV0000")

	
	TppEnemy.SetSneakRoute( "sol_skull_0010" , "rts_skull_wait_beforeEV0004")
	TppEnemy.SetSneakRoute( "sol_skull_0011" , "rts_skull_wait_beforeEV0005")

	
	
	TppEnemy.SetSneakRoute( "sol_skull_0006" , "rts_skullsA_ride_0006")
	TppEnemy.SetSneakRoute( "sol_skull_0007" , "rts_skullsA_ride_0007")

	
	TppEnemy.SetSneakRoute( "sol_skull_0012" , "rts_skullsC_ride")

end



this.SkullRideCars = function()

	
	GameObject.SendCommand( { type="TppVehicle2", },
	{
		id = "RegisterConvoy",
		convoyId =
		{
			GameObject.GetGameObjectId( "TppVehicle2", "vehs_citadel_0000" ),
			GameObject.GetGameObjectId( "TppVehicle2", "vehs_citadel_0001" ),
			GameObject.GetGameObjectId( "TppVehicle2", "vehs_citadel_0002" ),
		},
	} )

	
	
	TppEnemy.SetSneakRoute( "sol_skull_0008" , "rts_skullsA_ride_0008")
	TppEnemy.SetSneakRoute( "sol_skull_0009" , "rts_skullsA_ride_0009")

	
	TppEnemy.SetSneakRoute( "sol_skull_0010" , "rts_skullsC_ride_0010")
	TppEnemy.SetSneakRoute( "sol_skull_0011" , "rts_skullsC_ride_0011")
	TppEnemy.SetSneakRoute( "sol_skull_0013" , "rts_skullsC_ride_0013")

	
	if mvars.RideMemberNum == MAX_RIDE_PEOPLE-1 then
		TppEnemy.SetSneakRoute( "sol_skull_0000" , "rts_skullsB_ride_0000")
	end

end


local sol_skulls_drive = {
	"sol_skull_0000",
	"sol_skull_0001",
	"sol_skull_0006",
	"sol_skull_0007",
	"sol_skull_0008",
	"sol_skull_0009",
	"sol_skull_0010",
	"sol_skull_0011",
	"sol_skull_0012",
	"sol_skull_0013",
}

this.SkullDrive = function()
	Fox.Log( "### s10150_enemy02.SkullDrive()" )
	for index, enemyName in pairs(sol_skulls_drive) do
		local gameObjectId = GameObject.GetGameObjectId(enemyName)
		TppEnemy.SetSneakRoute( gameObjectId , "rts_skulls_drive")
	end
end

this.SkullDriveHoken = function()
	Fox.Log( "### s10150_enemy02.SkullDriveHoken()" )
	local command = { id="SetSneakRoute", route="rts_skulls_drive", point=0 }
	GameObject.SendCommand( GameObject.GetGameObjectId("sol_skull_0000"), command )
	GameObject.SendCommand( GameObject.GetGameObjectId("sol_skull_0001"), command )
	GameObject.SendCommand( GameObject.GetGameObjectId("sol_skull_0006"), command )
	GameObject.SendCommand( GameObject.GetGameObjectId("sol_skull_0007"), command )
	GameObject.SendCommand( GameObject.GetGameObjectId("sol_skull_0008"), command )
	GameObject.SendCommand( GameObject.GetGameObjectId("sol_skull_0009"), command )
	GameObject.SendCommand( GameObject.GetGameObjectId("sol_skull_0010"), command )
	GameObject.SendCommand( GameObject.GetGameObjectId("sol_skull_0011"), command )
	GameObject.SendCommand( GameObject.GetGameObjectId("sol_skull_0012"), command )
	GameObject.SendCommand( GameObject.GetGameObjectId("sol_skull_0013"), command )
	GkEventTimerManager.Stop("RideOnDriverTimer")	
end

this.SetUpSkullSol = function()
	Fox.Log("_________s10150_enemy02.SetUpSkullSol()")
	for index, enemyName in pairs(this.soldierDefine.afgh_skull_cp) do
		local gameObjectId = GameObject.GetGameObjectId(enemyName)
		local command = { id="SetPuppet", enabled=true }
		GameObject.SendCommand( gameObjectId, command )
	end
end

this.SetUpEventSoldiers = function()
	Fox.Log("_________s10150_enemy02.SetUpEventSoldiers()")
	for i, soldierName in ipairs( EVENT_SOLDEIRS_01 ) do
		local gameObjectId = GameObject.GetGameObjectId( soldierName )
		local command = { id="SetEnabled", enabled=false }
		GameObject.SendCommand( gameObjectId, command )
	end
end

local playerBringer = { "sol_skull_0000","sol_skull_0001" }
this.SetUpSkullSolBringPlayer = function( flag )
	Fox.Log("_________s10150_enemy02.SetUpSkullSolBringPlayer(flag)  flag /" .. tostring(flag))
	for index, enemyName in pairs(playerBringer) do
		local gameObjectId = GameObject.GetGameObjectId(enemyName)
		local command = { id="SetBringPlayerAsPrisoner", enabled=flag }
		GameObject.SendCommand( gameObjectId, command )
	end
end





--DUPLICATE:
-- this.TalkSkullFace = function(labelName)
-- 	local gameObjectId = GameObject.GetGameObjectId( "SkullFace" )
-- 	local command = {
-- 		id="CallMonologue",
-- 		label = labelName,
-- 	}
-- 	GameObject.SendCommand( gameObjectId, command )
-- end






















this.SetSkullRoute = function( routeName, nodePoint )
	Fox.Log("*** s10150_enemy02.SetSkullRoute() point:" .. tostring( nodePoint ) .. " ***")
	TppEnemy.SetSneakRoute( "SkullFace" , routeName, nodePoint)
end

this.SetSkullDisableAdjustMoving = function( isDisable )
	Fox.Log("*** s10150_enemy02.SetSkullDisableAdjustMoving(" .. tostring( isDisable ) .. ") ***")
	local gameObjectId = GameObject.GetGameObjectId( "SkullFace" )
	local command = { id = "SetHostage2Flag", flag = "disableAdjustMoving", on = isDisable }
	GameObject.SendCommand( gameObjectId, command )
end





this.UpdateSkullRoute = function( skullProgress )
	Fox.Log("_____________s10150_enemy02.UpdateSkullRoute()  skullProgress/ ".. skullProgress )
	local skullRouteTable = this.skullRouteTable
	
	for i, tName in pairs(skullRouteTable) do
		if tName.progress == skullProgress then
			if not this.CheckOnRoute("SkullFace" , tName.route)  then
				this.SetSkullRoute(tName.route)
				this.SetSkullDisableAdjustMoving(tName.disableAdjustMoving)
			end
			return
		end
	end
end

this.UpdatePlayerStateForSkull = function( trapName )

	Fox.Log("_____________s10150_enemy02.UpdatePlayerStateForSkull() / "..trapName )
	
	local skullRouteTable = this.skullRouteTable
	
	
	for i, tName in pairs(skullRouteTable) do
		
		if i == trapName then
			Fox.Log("trapName:"..tostring(trapname).." tName[progress]/ "..tostring(tName.progress) )
			mvars.PlayerStateForSkull = tName.progress
			
			
			if mvars.PlayerStateForSkull == 30 then
				mvars.SkullFaceState = tName.progress
	
				
			end
			
			return
		end
	end
end


this.UpdateProgressSkullFace = function(id,sendM) 
	Fox.Log("_____________s10150_enemy02.UpdateProgressSkullFace() / ID : " ..tostring(id) .. " / sendM : " .. tostring(sendM))
	
	local SkullID = GameObject.GetGameObjectId( "SkullFace" )
	local skullRouteTable = this.skullRouteTable

	
	for i, tName in pairs(skullRouteTable) do
		if sendM == StrCode32( i ) then
			mvars.SkullFaceState = tName.progress
			return
		end
	end	
end


this.SkullFaceWalkFirstStep = function()
	Fox.Log("_____________s10150_enemy02.SkullFaceWalkFirstStep()") 
	
	
	GkEventTimerManager.Start( "SkullRouteFirstTalkTimer", 20 ) 
	
	local gameObjectId = GameObject.GetGameObjectId( "SkullFace" )
	GameObject.SendCommand( gameObjectId, {
		id="SpecialAction",
		action="PlayMotion",
		path="/Assets/tpp/motion/SI_game/fani/bodies/wsp0/wsp0/wsp0_str_okb_a.gani",
		startPosition=Vector3(-1305.224,647.269,-3285.512),		
		startAngleY=TppMath.DegreeToRadian( 0.0 ),
		enableGravity=false,
		enableCollision=false,
		enableMessage = true,
		commandId = 20,
		autoFinish=true,
		
	} )
end

this.SkullFaceWalkSecondStep = function()
	Fox.Log("_____________s10150_enemy02.SkullFaceWalkSecondStep()") 
	
	mvars.isSkullStepSecondMotion = true

	TppEnemy.UnsetSneakRoute("SkullFace")
	
	local gameObjectId = GameObject.GetGameObjectId( "SkullFace" )
	GameObject.SendCommand( gameObjectId, {
		id="SpecialAction",
		action="PlayMotion",
		path="/Assets/tpp/motion/SI_game/fani/bodies/wsp0/wsp0/wsp0_str_okb_b.gani",
		startPosition=Vector3(-1303.46465,637.84239,-3265.53262),
		startAngleY=TppMath.DegreeToRadian( -9.2427 ),
		enableGravity=false,
		enableCollision=false,
		enableMessage = true,
		commandId = 30,
		interpFrame = 16.0,
		autoFinish=true,
	} )
	
end

this.SetSkullFaceRideVehicleAction = function()

	local gameObjectId = GameObject.GetGameObjectId( "SkullFace" )
	GameObject.SendCommand( gameObjectId, {
		id="RideVehicle",
		vehicleId = GameObject.GetGameObjectId( "vehs_citadel_0001" ),
		off = false,
		seatIndex = 3,
	} )

end

this.SetSkullFaceWarnsPlayerSpecialAction20 = function()

	local randomIndex = math.random( 3 )
	local stateName = ""
	local labelName = ""

	if randomIndex == 1 then
		stateName = "stateStandActionBA_M"
		labelName = "SFT_21" 
	elseif randomIndex == 2 then
		stateName = "stateStandActionO_R"
		labelName = "SFT_22" 
	else
		stateName = "stateStandActionJ"
		labelName = "SFT_20" 
	end

	Fox.Log("_____________s10150_enemy02.SetSkullFaceWarnsPlayerSpecialAction20() randomIndex:" .. randomIndex .. " stateName:" .. tostring( stateName ) .. " labelName:" .. tostring( labelName ) )
	this.SetSkullFaceWarnsPlayerSpecialAction( stateName )
	this.TalkSkullFace( labelName )

end

this.SetSkullFaceWarnsPlayerSpecialAction50 = function()

	local randomIndex = math.random( 4 )
	local stateName = ""
	local labelName = ""

	if randomIndex == 1 then
		stateName = "stateStandActionBA_M"
		labelName = "SFT_21" 
	elseif randomIndex == 2 then
		stateName = "stateStandActionO_R"
		labelName = "SFT_22" 
	elseif randomIndex == 3 then
		stateName = "stateStandActionL_M"
		labelName = "SFT_23" 
	else
		stateName = "stateStandActionJ"
		labelName = "SFT_20" 
	end

	Fox.Log("_____________s10150_enemy02.SetSkullFaceWarnsPlayerSpecialAction50() randomIndex:" .. randomIndex .. " stateName:" .. tostring( stateName ) .. " labelName:" .. tostring( labelName ) )
	this.SetSkullFaceWarnsPlayerSpecialAction( stateName )
	this.TalkSkullFace( labelName )

end

this.SetSkullFaceWarnsPlayerSpecialAction110 = function()

	local randomIndex = math.random( 5 )
	local stateName = ""
	local labelName = ""

	if randomIndex == 1 then
		stateName = "stateStandActionD"
		labelName = "SFT_05" 
	elseif randomIndex == 2 then
		stateName = "stateStandActionG"
		labelName = "SFT_21" 
	elseif randomIndex == 3 then
		stateName = "stateStandActionO"
		labelName = "SFT_22" 
	elseif randomIndex == 4 then
		stateName = "stateStandActionG"
		labelName = "SFT_23" 
	else
		stateName = "stateStandActionJ"
		labelName = "SFT_20" 
	end

	Fox.Log("_____________s10150_enemy02.SetSkullFaceWarnsPlayerSpecialAction50() randomIndex:" .. randomIndex .. " stateName:" .. tostring( stateName ) .. " labelName:" .. tostring( labelName ) )
	this.SetSkullFaceWarnsPlayerSpecialAction( stateName )
	this.TalkSkullFace( labelName )

end

this.SetSkullFaceWarnsPlayerSpecialAction = function( stateName )
	local gameObjectId = GameObject.GetGameObjectId( "SkullFace" )
	GameObject.SendCommand( gameObjectId, {
		id = "SpecialAction",
		action = "PlayState",
		state = stateName,
		enableGravity = true,
		enableCollision = true,
		enableAim = true,
		interpFrame = 16.0,
		autoFinish = true,
	} )
end





this.UpdatePlayerState = function( trapName )

	Fox.Log("_____________s10150_enemy02.UpdatePlayerState() / "..trapName )
	
	local bringerRouteTable = this.bringerRouteTable
	
	
	local tName = bringerRouteTable[ trapName ]
	if tName then
		Fox.Log("trapName:"..tostring(trapname).." tName[progress]/ "..tostring(tName.progress) )

		mvars.PlayerState = tName.progress

		local syncRouteStep = tName.syncRouteStep
		if syncRouteStep and SyncRouteManager.SetScriptStep then
			SyncRouteManager.SetScriptStep( "sync_bringer", syncRouteStep )
		end
			
		
		if(mvars.PlayerState == bringerRouteTable.trap_walk_Bringer070.progress ) then
			mvars.BringerAState = mvars.PlayerState
			mvars.BringerBState = mvars.PlayerState
		end

		return

	end
	
end


this.UpdateBringerRoute = function( solProgress,solName,solRouteType )
	Fox.Log("_____________s10150_enemy02.UpdateBringerRoute()  solProgress/ ".. solProgress )

	local bringerRouteTable = this.bringerRouteTable

	
	for i, tName in pairs(bringerRouteTable) do
		
		if tName.progress == solProgress then
			Fox.Log("_____________routeName[routeA]/ "..tostring(tName["routeA"]).." /_____________routeName[routeB]/ "..tostring(tName["routeB"])  )
			Fox.Log("_____________routeName[isBring]/ "..tostring(tName.isBring))
			
			local routeName = tName[ solRouteType ]
			if routeName and not this.CheckOnRoute( solName , routeName )  then
				this.SetUpSkullSolBringPlayer( tName.isBring )
				TppEnemy.SetSneakRoute( solName, routeName )
			end
			
			return
		end
	end
end



this.CheckUpdateRoute = function()
	Fox.Log("*********************************************************************************************")
	Fox.Log("_____________s10150_enemy02.CheckUpdateRoute() / ")
	
	
	Fox.Log("_____________mvars.PlayerStateForSkull / "..tostring(mvars.PlayerStateForSkull ))
	
	
	Fox.Log("_____________mvars.SkullFaceState / "..tostring(mvars.SkullFaceState ))
	
	
	
	if mvars.BringerAState <= mvars.PlayerState then
		this.UpdateBringerRoute(mvars.BringerAState ,"sol_skull_0000","routeA")
	end
	
	if mvars.BringerBState <= mvars.PlayerState then
		this.UpdateBringerRoute(mvars.BringerBState ,"sol_skull_0001","routeB")
	end

	local skullFaceState = mvars.SkullFaceState
	local playerStateForSkull = mvars.PlayerStateForSkull

	if skullFaceState >= 100 and playerStateForSkull >= 100 then
		
	elseif skullFaceState <= playerStateForSkull then
		
		if playerStateForSkull == 20 then
			if not mvars.isSkullStepSecondMotion then
				this.UpdateSkullRoute( skullFaceState )
			end			
		elseif skullFaceState >= 40 then
			local skullRouteTable = this.skullRouteTable
			local nextPoint = -1
			for i, tName in pairs( skullRouteTable ) do
				if tName.progress == skullFaceState then
					nextPoint = tName.nextPoint
				end
			end
			if nextPoint > 0 then
				Fox.Log("___________________route continue :rts_skull_walk_3000 point:" .. nextPoint )
				this.SetSkullRoute( "rts_skull_walk_3000", nextPoint )
			else
				Fox.Log("___________________route continue :rts_skull_walk_3000 ")
				this.SetSkullRoute( "rts_skull_walk_3000" )
			end
			this.SetSkullDisableAdjustMoving( false )
		else
			this.UpdateSkullRoute( skullFaceState )
		end
	else
		if skullFaceState >= 40 then
			this.UpdateSkullRoute( skullFaceState )
		end
	end
	


end


this.UpdateProgress = function(id,sendM) 
	
	local SolAID = GameObject.GetGameObjectId( "sol_skull_0000" )
	local SolBID = GameObject.GetGameObjectId( "sol_skull_0001" )
	
	local bringerRouteTable = this.bringerRouteTable
	
	
	for i, tName in pairs(bringerRouteTable) do
		
		if sendM == StrCode32( i ) then
			if id == SolAID then
				mvars.BringerAState = tName.progress
			elseif id == SolBID then
				mvars.BringerBState = tName.progress
			end
			return
		end
	end	
end


this.CheckOnRoute = function(solName,routeName)
	
	local gameObjectId = GameObject.GetGameObjectId( solName )
	local command = { id = "IsOnRoute", route=routeName }
	local isOnRoute = GameObject.SendCommand( gameObjectId, command )
	
	Fox.Log("_____________s10150_enemy02.CheckOnRoute() / isOnRoute :" .. tostring(isOnRoute))
	
	return isOnRoute
end





this.SkullPassangerAction = function()
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_skull_0000" )
	local command = { id = "SetVehicleSpecialAct", }
	GameObject.SendCommand( gameObjectId, command )
end






this.combatSetting = {
	nil
}






this.SetRelativeVehicle = function(vehicleName)
	for index, enemyName in ipairs(RELACTIVE_VEHICLE_GROUP[vehicleName]) do
		local soldierName = RELACTIVE_VEHICLE_GROUP[vehicleName][index][1]
		local isBeginning = RELACTIVE_VEHICLE_GROUP[vehicleName][index][2]
		local soldierId = GameObject.GetGameObjectId("TppSoldier2", soldierName )
		local vehicleId = GameObject.GetGameObjectId("TppVehicle2", vehicleName )
		local command = { id="SetRelativeVehicle", targetId=vehicleId , rideFromBeginning = isBeginning }
		GameObject.SendCommand( soldierId, command )
	end
end



this.SetUpRelativeVehicle = function(vehicleName)
	this.SetRelativeVehicle("vehs_citadel_0000")
	this.SetRelativeVehicle("vehs_citadel_0001")
	this.SetRelativeVehicle("vehs_citadel_0002")
end



this.SetUpVehicleSound = function()
	this.ResisterVehicleSE("vehs_citadel_0000","Play_sfx_c_okb_lv_01_00") 
	this.ResisterVehicleSE("vehs_citadel_0002","Play_sfx_c_okb_lv_02_00") 
end

this.ResisterVehicleSE = function(vehicleId,soundId)
	GameObject.SendCommand( 
		{ 	type="TppVehicle2", }, 
		{ 	id="RegisterSpecialEngineSfx", 
			targetId = GameObject.GetGameObjectId(vehicleId),
			eventName = soundId 
		} )
end

this.ConstrainVehicleOnRail = function(vehicleId)
	GameObject.SendCommand( 
		GameObject.GetGameObjectId(vehicleId), 
		{ 	id="Constrain", 
		} )
end





this.vehicleDefine = { instanceCount = 4 }	

this.SpawnVehicleOnInitialize = function()

	
	local despawnList = {
		{ id="Despawn", locator="vehs_citadel_tank_0000", type=Vehicle.type.EASTERN_WHEELED_ARMORED_VEHICLE, index = 1 },
		{ id="Despawn", locator="vehs_citadel_tank_0001", type=Vehicle.type.EASTERN_WHEELED_ARMORED_VEHICLE, index = 2 },
		{ id="Despawn", locator="vehs_citadel_tank_0002", type=Vehicle.type.EASTERN_WHEELED_ARMORED_VEHICLE, index = 3 },
	
	}
	TppEnemy.DespawnVehicles( despawnList )

	local spawnList = {
		{ id="Spawn", locator="vehs_citadel_0000", type=Vehicle.type.EASTERN_LIGHT_VEHICLE, index = 5 },
		{ id="Spawn", locator="vehs_citadel_0001", type=Vehicle.type.EASTERN_LIGHT_VEHICLE, index = 6 },
		{ id="Spawn", locator="vehs_citadel_0002", type=Vehicle.type.EASTERN_LIGHT_VEHICLE, index = 7 },
	}
	TppEnemy.SpawnVehicles( spawnList )
end


this.InitEnemy = function ()

end



this.SetUpEnemy = function ()

	this.SetUpSkullSol()
	this.SetUpEventSoldiers()
	mvars.RideMemberNum = 0 
	mvars.RideEvNum = 0			
	this.SetUpHeliSkull()		
	this.SkullWalk()

	this.SetUpOtherHeli2Sound()
	this.SetUpVehicleSound()

	this.SetUpRelativeVehicle() 

end


this.OnLoad = function ()
	Fox.Log("*** s10150 onload ***")
end




return this

