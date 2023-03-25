-- InfQuickMenuDefs.lua
-- When enabled via the 'Enable Quick menu'/enableQuickMenu option or forceEnable below, 
-- activate by holding [CALL] Radio - (Q key or Left bumper) + the key/button for the defined command.

--If you want to edit this it may be better to copy off to InfQuickMenuDefs_User.lua 
--so it doesn't get overwritten on new IH versions, 
--but you'll have to check InfQuickMenuDefs.lua on new IH versions to see if there's any changes.

--Quick Buttons/Keys reference.
--(see /Assets/tpp/script/ih/InfButton for full list)
--Some buttons are combined, and in different ways on keyboard vs gamepad

--InfButton name - Description - (default key / button)
--InfButton.ACTION - (E key or Y button)
--InfButton.RELOAD - (R key or B button)
--InfButton.EVADE - Quick dive - (space key or X button)
--InfButton.READY_WEAPON - (Right mouse or Left Trigger)
--InfButton.FIRE - (Left mouse or Right Trigger)
--InfButton.CALL - Call radio/interrogate - (Q or Left bumper)
--InfButton.BINOCULARS - (F or Right bumper)

--InfButton.UP - (Arrow/Dpad Up)
--InfButton.DOWN - (Arrow/Dpad Down)
--InfButton.RIGHT - (Arrow/Dpad Right)
--InfButton.LEFT - (Arrow/Dpad Left)

--InfButton.LIGHT_SWITCH - (X key,Dpad Right)

local this={}

--this.forceEnable=true--tex overrides the Enable quick menu option in the IH system menu

--tex button to hold to enable the quick menu command buttons
--make sure this doesn't conflict with any of the menu command buttons below
this.quickMenuHoldButton=InfButton.CALL

this.inSafeSpace={
  [InfButton.RELOAD]={Command='InfCamera.ToggleFreeCam'},
}
this.inMission={
  --tex just comment if you want to disable a command
  --[InfButton.BINOCULARS]={Command='InfQuickMenuDefs_User.ExampleCommand'},--Example of command using own function in this module (see function below)
  [InfButton.LIGHT_SWITCH]={Command='InfMenuCommandsTpp.DropCurrentEquip'},
  [InfButton.READY_WEAPON]={Command='InfUserMarker.WarpToLastUserMarker'},
  [InfButton.ACTION]={immediate=true,Command='InfTimeScale.HighSpeedCameraToggle'},--tex TSM, immediate because: It's on a key that is less likely to be accidentally triggered. Need the responsiveness. TSM actually affects timing of deactivation lol (same issue with phantom cigar and menu activation) 
  [InfButton.RELOAD]={Command='InfCamera.ToggleFreeCam'},
  [InfButton.STANCE]={Command='InfMenuCommandsTpp.QuietMoveToLastMarker'},
}
--tex cutscenes
--In addition to this IH has commands for pause and reset without using the quickmenu
--see mod\modules\InfDemo.lua to see those binds
this.inDemo={ 
  [InfButton.RELOAD]={Command='InfCamera.ToggleFreeCam'},
  [InfButton.DASH]={Command='InfCamera.ToggleCamMode'},
  [InfButton.ACTION]={immediate=true,Command='InfTimeScale.HighSpeedCameraToggle'},
}

function this.ExampleCommand()
  TppUiCommand.AnnounceLogView("Activated ExampleCommand")
end

return this
