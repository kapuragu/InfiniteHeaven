
CommandAi = {
    FORCE_SHOOT = 1,--Shoot at the player for a game over sequence
    FORCE_WAIT = 2,--Conduct combat at the current position
    GIVE_WARNING = 3,--Warn the player
    SHOOT_PRACTICE = 4,--Shoot forward or at player (Cyprus gun tutorial) commandIndex = 0, 1
    LIQUID_ASSIST = 5,--Shoot the player fighting Liquid
    SHOOT_ROCKET = 6,--Shoot driving vehicle's tank rocket at position (A Quiet Exit) x=x, y=y, z=z,
    INFANTRY = 7,--Come out of armored vehicle as infantry, vehicle=vehicle, sol01=sol01, sol02=sol02, sol03=sol03
    ESCORT = 8,--Escort a vehicle, vehicle = VehicleId, formationIndex = 0, 1, 2, 3
    FORCE_REMOVE = 9,--Unused
},

GameObject.SendCommand( gameObjectId, { id = "SetCommandAi", commandType = CommandAi.FORCE_SHOOT, } )
GameObject.SendCommand( GameObject.GetGameObjectId("TppSoldier2", "sol_p21_010490_0001" ), { id="SetCommandAi", commandType = CommandAi.SHOOT_PRACTICE, commandIndex = 0, } )
GameObject.SendCommand( GameObject.GetGameObjectId("TppSoldier2", "sol_p21_010490_0002" ), { id="SetCommandAi", commandType = CommandAi.SHOOT_PRACTICE, commandIndex = 1, } )

local command = { id="SetCommandAiStep", step = 1, }

local command = { id="SetCommandAi", commandType = CommandAi.ESCORT, vehicle = VehicleId, formationIndex = 2 }
local command = { id="SetCommandAi", commandType = CommandAi.ESCORT, vehicle = VehicleId, formationIndex = 2 }
local command = { id="SetCommandAi", commandType = CommandAi.ESCORT, vehicle = VehicleId, formationIndex = 2 }
local command = { id="SetCommandAi", commandType = CommandAi.ESCORT, vehicle = VehicleId, formationIndex = 2 }

local command = { id="SetCommandAi", commandType = CommandAi.ESCORT, vehicle = targetVehicle, formationIndex = driverPos } 
command = { id="SetCommandAi", commandType = CommandAi.ESCORT, vehicle = targetVehicle, formationIndex = guardPos } 
command = { id="SetCommandAi", commandType = CommandAi.ESCORT, vehicle = GUARD_VEHICLE, formationIndex = 0 } 

command = { id="SetCommandAi", commandType = CommandAi.FORCE_WAIT }	


command = { id="SetCommandAi", commandType = CommandAi.FORCE_WAIT }
--else
command = { id="RemoveCommandAi" }
    
local command		= { id="SetCommandAi", commandType = CommandAi.ESCORT, vehicle = targetVehicle, formationIndex = 0 } 
    
local command = { id="SetCommandAi", commandType = CommandAi.LIQUID_ASSIST, }


if eventType == TppGameObject.BRING_PLAYER_WARNING then
    command = { id="SetCommandAi", commandType = CommandAi.GIVE_WARNING }
elseif eventType == TppGameObject.BRING_PLAYER_RECOVERED then
    command = { id="RemoveCommandAi" }
else
    Fox.Log("_______s10150_enemy02.WarningPlayer() : Execute Player")
end


local command = { id="SetCommandAi", commandType = CommandAi.INFANTRY, vehicle=vehicle, sol01=sol01, sol02=sol02, }

local command = { id="SetCommandAi", commandType = CommandAi.SHOOT_ROCKET, x=x, y=y, z=z, }