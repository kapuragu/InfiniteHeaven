--InfHeliSpace.lua
--implements heli_common_sequence stuff and helispace addon specific stuff
--the majority of heli space addons is handled by InfMission addon system

local StrCode32=InfCore.StrCode32

local this={}

--heli_common_sequence>
local SelectCameraParameter = {

	[ StrCode32( "MissionPrep_FocusTarget_Weapon" ) ]
		= { "WeaponPosition", 1.5, rotX = -10, rotY = 170, interpTime = 0.3,},

	[ StrCode32( "MissionPrep_FocusTarget_PrimaryWeapon" ) ]
		= { "PlayerPosition", 3.0, rotX = 5, rotY = 230, interpTime = 0.4 },

	[ StrCode32( "MissionPrep_FocusTarget_PrimaryWeapon_HIP" ) ]
		= { "PlayerPosition", 2.5, rotX = 5, rotY = 220, interpTime = 0.4 },

	[ StrCode32( "MissionPrep_FocusTarget_PrimaryWeapon_BACK" ) ]
		= { "PlayerPosition_Up", 3.0, rotX = 5, rotY = 320, interpTime = 0.4 },

	[ StrCode32( "MissionPrep_FocusTarget_SecondaryWeapon" ) ]
		= { "PlayerPosition", 3.0 , rotX = -5, rotY = 160, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_SecondaryWeapon_WEAPON" ) ]
		= { "PlayerPosition", 2.0 , rotX = -5, rotY = 150, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_SecondaryWeapon_ARM" ) ]
		= { "PlayerPosition_Up", 2.0 , rotX = -5, rotY = 230, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_SupportWeapon" ) ]
		= { "PlayerPosition_Up", 1.8 , rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_Item" ) ]
		= { "PlayerPosition_Up", 3.3 , rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_Suit" ) ]
		= { "PlayerPosition_Up", 3.3, rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_HeadOption" ) ]
		= { "PlayerHeadPosition", 2.3, rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_Player" ) ]
		= { "PlayerPosition_Up", 3.3, rotX = -5, rotY = 170, interpTime = 0.3 },


	
	[ StrCode32( "MissionPrep_FocusTarget_BuddyQuiet" ) ]
		= { "BuddyQuietPosition", 3.6, rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_BuddyQuietEquip" ) ]
		= { "BuddyQuietPosition_Up", 3.2, rotX = -5, rotY = 270, interpTime = 0.4 },

	[ StrCode32( "MissionPrep_FocusTarget_BuddyDog" ) ]
		= { "BuddyDogPosition", 3.8, rotX = -5, rotY = 182, interpTime = 0.3 },


	[ StrCode32( "MissionPrep_FocusTarget_BuddyHorse" ) ]
		= { "BuddyHorsePosition_2", 5.3, rotX = -5, rotY = 180, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_BuddyWalker" ) ]
		= { "BuddyPosition", 4.0, rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_BuddyBattleGear" ) ]
		= { "BuddyPosition", 5.8, rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "MissionPrep_FocusTarget_Vehicle" ) ]
		= { "VehicleCameraPosition", 9.0, rotX = 24, rotY = 65, interpTime = 0.6 },

	[ StrCode32( "MissionPrep_FocusTarget_None" ) ]
		= { "StageCenter", 3.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Weapon" ) ]
		= { "CustomizeWeaponPosition", 1.7, rotX = -5, rotY = 170, interpTime = 0.3},
	[ StrCode32( "Customize_Target_Buddy" ) ]
		= { "CustomizeBuddyPosition", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },

	
	[ StrCode32( "Customize_Weapon_Handgun" ) ]
		= { "CustomizeWeaponPosition", 1.0, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_SubMachinegun" ) ]
		= { "CustomizeWeaponPosition", 1.4, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_AssaultRifle" ) ]
		= { "CustomizeWeaponPosition", 1.5, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_ShotGun" ) ]
		= { "CustomizeWeaponPosition", 1.5, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_GrenadeLauncher" ) ]
		= { "CustomizeWeaponPosition", 1.5, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_SniperRifle" ) ]
		= { "CustomizeWeaponPosition", 1.7, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_MachineGun" ) ]
		= { "CustomizeWeaponPosition", 1.7, rotX = 0, rotY = 180, interpTime = 0.3 },
	[ StrCode32( "Customize_Weapon_Missile" ) ]
		= { "CustomizeWeaponPosition", 1.7, rotX = 0, rotY = 180, interpTime = 0.3 },


	
	[ StrCode32( "Customize_Target_BuddyDog" ) ]
		= { "CustomizeBuddyPosition", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Dog_Body" ) ]
		= { "CustomizeBuddyPosition", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Dog_Eye" ) ]
		= { "CustomizeBuddyPosition", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },

	
	[ StrCode32( "Customize_Target_BuddyHorse" ) ]
		= { "CustomizeBuddyPosition_HorsePos", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Horse_Body" ) ]
		= { "CustomizeBuddyPosition_HorsePos", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Horse_Head" ) ]
		= { "CustomizeBuddyPosition_HorsePos", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Horse_Leg" ) ]
		= { "CustomizeBuddyPosition_HorsePos", 4.5, rotX = -5, rotY = 170, interpTime = 0.3 },

	
	[ StrCode32( "Customize_Target_BuddyWalker" ) ]
		= { "CustomizeBuddyPosition_DWPos", 4.8, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_Body" ) ]
		= { "CustomizeBuddyPosition_DWPos", 4.8, rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_Manipulator" ) ]
		= { "CustomizeBuddyPosition_DWPos", 4.0, rotX = -5, rotY = 120, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_MainWeapon" ) ]
		= { "CustomizeBuddyPosition_Head", 3.0, rotX = 7, rotY = 185, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_SubWeapon" ) ]
		= { "CustomizeBuddyPosition_Head", 3.0, rotX = 3, rotY = 115, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_Head" ) ]
		= { "CustomizeBuddyPosition_Head", 3.0, rotX = 25, rotY = 90, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_DW_Color" ) ]
		= { "CustomizeBuddyPosition_DWPos", 4.8, rotX = -5, rotY = 170, interpTime = 0.3 },

	
	[ StrCode32( "Customize_Target_Heli_Body" ) ]
		= { "CustomizeHelicopterCameraPosition", 16 , rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Heli_Main" ) ]
		= { "CustomizeHelicopterCameraPosition_MainWeapon", 10 , rotX = 25, rotY = 150, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Heli_OpFlare" ) ]
		= { "CustomizeHelicopterCameraPosition", 16 , rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Heli_OpArmor" ) ]
		= { "CustomizeHelicopterCameraPosition", 16 , rotX = -5, rotY = 170, interpTime = 0.3 },
	[ StrCode32( "Customize_Target_Heli_Color" ) ]
		= { "CustomizeHelicopterCameraPosition", 16 , rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "Customize_Target_Helicopter" ) ]
		= { "CustomizeHelicopterCameraPosition", 16 , rotX = -5, rotY = 170, interpTime = 0.3 },

	[ StrCode32( "Customize_Target_Vehicle" ) ]
		= { "CustomizeVehicleCameraPosition", 12, rotX = 15, rotY = 150, interpTime = 0.2 },
}

function this.UpdateCameraParameter( focusTarget, immediately )
	if true then--tex OVERRIDE -- kludgy since it isn't easy to override fpk luas
		return InfCore.PCall(InfHeliSpace.UpdateCameraParameter,focusTarget,immediately)
	end--<

	local cameraParameter = SelectCameraParameter[ focusTarget ]
	if not cameraParameter then
		Fox.Error("Invalid focus target. focusTarget = " .. tostring(focusTarget) )
		return
	end
	local locatorName, distance, rotX, rotY, interpTime = cameraParameter[1], cameraParameter[2], cameraParameter.rotX, cameraParameter.rotY, cameraParameter.interpTime
	Fox.Log("MissionPrepare.UpdateCameraParameter: locatorName = " .. tostring(locatorName) .. ", distance = " .. tostring(distance) )
	local target = Tpp.GetLocatorByTransform( "PreparationStageIdentifier", locatorName )
	
	local ignoreCollision
	if focusTarget == StrCode32( "Customize_Target_Buddy" ) 
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyQuiet" )
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyQuietEquip" )
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyDog" )
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyHorse" )
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyWalker" ) 
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_BuddyBattleGear" )  then
		ignoreCollision = GameObject.CreateGameObjectId( "TppWalkerGear2", 0 )
	elseif focusTarget == StrCode32( "Customize_Target_Vehicle" ) 
	or focusTarget == StrCode32( "MissionPrep_FocusTarget_Vehicle" ) then
		ignoreCollision = GameObject.CreateGameObjectId( "TppVehicle2", 0 )
	end
	
	local targetInterpTime = 0.3
	
	if immediately then
		targetInterpTime = 0.0
		
	end
	
	if focusTarget == Fox.StrCode32( "MissionPrep_FocusTarget_Weapon" ) then

		Player.SetAroundCameraManualModeParams{
			distance = distance,		
			target = target,			
			focusDistance = 1.5,
			aperture = 1.6,                 
			targetInterpTime = targetInterpTime,         
			targetIsPlayer = false,
			ignoreCollisionGameObjectId = ignoreCollision,
			interpImmediately = immediately,
		}

		Player.SetPadMask {
		        settingName = "WeaponCamera",
		        except = true,
		        sticks = PlayerPad.STICK_L,
		}


	else
		if TppSequence.GetCurrentSequenceName() == "Seq_Game_WeaponCustomize" then
			
			Player.SetAroundCameraManualModeParams{
				distance = distance,		
				target = target,			
				focusDistance = 8.175,
				aperture = 100,				
				targetInterpTime = targetInterpTime,		
				ignoreCollisionGameObjectId = ignoreCollision,
				interpImmediately = immediately,
			}
		else

			Player.SetAroundCameraManualModeParams{
				distance = distance,		
				target = target,			
				focusDistance = 8.175,
				targetInterpTime = targetInterpTime,		
				ignoreCollisionGameObjectId = ignoreCollision,
				interpImmediately = immediately,
			}
		end

	end
	Player.UpdateAroundCameraManualModeParams()
	Player.RequestToSetCameraRotation { rotX = rotX, rotY = rotY, interpTime = interpTime }
end
--heli_common_sequence<

return this