--InfLang.lua
-- NODEPS
local this={}
--game localizations known:
--eng,fre,ger,ita,jpn,por,rus,spa
--english, french, german, italian, japanese, portuguese, russian, spanish
--unconfirmed lang codes:
--ara, cht, kor
--arabic, chinese traditional, korean
--if your current games language is on the unconfirmed list use the 'Debug menu' > 'Show game language code' option in infinite heaven to get the language code and contact me on nexus

--tex if the lang function cant find a langid/string pair for a language it will default to eng, if it can't find in eng it will return the langId
--if translating only edit the text within the quotation marks.
this.eng={--english
  test="Ativações Советский ФОНАРЬ 你还不错  munición 侵入者をCQCにより無力化 ",
  menu_open_help="(Press Up/Down,Left/Right to navigate menu)",
  menuOffItem="Turn off menu",
  setting_defaults="Setting options for current menu to defaults...",
  setting_default="Setting to default..",
  setting_minimum="Setting to minimum..",
  resetSettingsItem="Reset current menu",
  setting_disallowed="is currently disallowed",
  goBackItem="Menu Back",
  menu_off="Menu Off",
  set_switch={"Off","On"},
  set_do={">",">"},
  safeSpaceMenu="In-ACC menu",
  inMissionMenu="In-mission menu",
  showLangCode="Show game language code",
  language_code="Language code",
  showPosition="Show position",
  langOverride="Mod Menu translation override",
  langOverrideSettings={"Off","Chinese override Japanese"},
  setting_all_defaults="Setting all settings to default...",
  resetAllSettingsItem="Reset all IH settings",
  showMissionCode="Show missionCode",
  startOffline="Start offline",
  debugInMissionMenu="Debug stuff menu",
  menu_keys="Hold [SWITCH_ZOOM] then press [DASH] to open menu",
  done="Done",
  min="min",
  max="max",
  no_marker_found="No marker found",
  debugMode="Debug IH mode",
  debugMenu="Debug menu",
  set_default_off_on={"Default","Off","On"},
  selectProfile="Select profile",
  applySelectedProfile="Apply profile",
  resetSelectedProfile="Set profile options to game defaults",
  no_profiles_installed="No profiles installed",
  applying_profile="Applying profile",
  viewProfile="Apply and view profile",
  revertProfile="Revert profile and return",
  saveToProfile="Save to UserSaved profile",
  fob_weapon_change="Cannot use Equip none on FOB",
  enableQuickMenu="Enable Quick Menu",
  systemMenu="IH system menu",
  skipLogos="Skip startup logos",
  ihMissionsPercentageCount="Include addon missions in completion percentage",
  loadAddonMission="Load addon mission",
  enableIHExt="Enable IHExt",
  takeFocus="Give IHExt focus",
  ihext_not_installed_settings={"Not installed","Not installed"},
  menu_enableHelp="Enable help text",
  menu_disableToggleMenuHold="Disable hold menu toggle",
  menu_enableCursorOnMenuOpen="Enable mouse cursor on menu open",
  loadExternalModules="Reload IH modules",
  sys_increaseMemoryAlloc="Increase memory allocation",
  searchMenu="Search menu",
  searchItem="Search",
  goBackTopItem="Back to main menu",
  list_empty="list is empty",
  exited_sideop_area="Exited sideop area",
  type_to_search="<Type and Enter to search>",
  inDemoMenu="In-cutscene menu",
  demo_cannot_restart_while_paused="Cannot restart cutscene while it is paused",
  missionModes={
    FREE="Free Roam",
    MISSION="Story Mission",
    MB="MB",
    MB_ALL="MB",
  },
  generalHelpItem="General Help",
  general_help_cmd="See MGS_TPP/mod/docs/ for documentation",
  showStyleEditor="UI Style Editor",
  systemMenuMission="IH system menu",
  requires_ihhook="Requires IHHook to function",
  command_for_in_mission="Use this command in-mission",
  objectListsMenu="Object lists menu",
}--eng end

this.help={}
this.help.eng={
  simple_help=[[Navigate menu: Arrow keys or Dpad.  
Activate or advance setting: Press Right key or Dpad or double-click option.  
  ]],--tex default help text for option with none. should be short so that imgui doesn't scroll with default window size
  generalHelpItem=[[General Help:  
Press F2 to toggle mouse cursor.  
Navigate menu: Arrow keys or Dpad.  
Activate or advance setting: Press Right key or Dpad or double-click option in menu.  
Search for settings: Click on the setting text below the menu list, type what you want and press Enter.  
Change a numerical setting: Click on the setting value below the menu list, type what you want and press Enter.  
Menu item type symbols:  
`>` Sub-menu  
`>>` Command  
`>]` Command that closes menu when done  
`<>` Option that applies change when setting selectected/cycled to  
`>!` Option that has an action activated by pressing [ACTION]  
Some settings apply when selected or just set the value when the a feature is triggered by another command or during mission load.  
See ReadMe or Features and Options for more info.  
]],
  debugMode="Switches on logging messages to ih_log.txt (at the cost of longer load times) and enables the announce-log during loading.",
  startOffline="Start the game in offline mode, this also removes the connect option from the pause menu.",
  enableQuickMenu="Shortcut key combinations to activate IH features. See Infinite Heaven readme or InfQuickMenuDefs.lua in mod folder.",
  debugFlow="Logs some script execution flow, requires Debug IH mode to be on.",
  debugMessages="Logs game message system, requires Debug IH mode to be on.",
  skipLogos="Stops the konami/kjp/fox/nvidia logos from showing.",
  selectProfile=[[Selects a profile from MGS_TPP\mod\profiles folder. Press the [ACTION] button to apply the settings of the selected profile.]],
  resetSelectedProfile="Sets the options described in the selected profile to their default setting.",
  saveToProfile=[[Saves current IH settings to UserSaved profile at MGS_TPP\profiles\UserSaved.lua.]],
  enableIHExt="IHExt is a windows program that acts as an gui overlay if MGSV is running in Windowed Borderless.",
  menu_enableHelp="Shows help text for some options.",
  menu_disableToggleMenuHold="Disables the legacy hold [EVADE] to open menu, the two button menu combo [ZOOM_CHANGE] + [DASH] will still work.",
  menu_enableCursorOnMenuOpen="Automatically enable mouse cursor when IHMenu opens. The cursor can also be seperately toggled with F2",
  sys_increaseMemoryAlloc="Experimental: Increses the memory values for various allocation variables/functions",
  showStyleEditor="Toggles the IMGui Style Editor to load, change and save the style for IHHook IMGUI.",
  systemMenuMission="See IH system menu while in ACC for full options.",
  dEBUG_RandomizeAllIvars="WARNING: Sets all settings across all of IH to a random value, which may include WIP, commented out or abandoned options. May also include  Back up your save before using this. This is used as debug coverage to see if anything breaks and not intended for general use.",
  dEBUG_SetIvarsToNonDefault="WARNING: Sets all settings across all of IH to a non default value. Back up your save before using this. This is used as debug coverage to see if anything breaks.",
}--help.eng

this.ara={--arabic, unconfirmed lang code, use the Patchup > Show language code option to get the language code and contact me on nexus, untranslated, copy lines from eng to start on
  test="TestAra",
}

this.cht={--chinese traditional,  unconfirmed lang code, use the Patchup > Show language code option to get the language code and contact me on nexus
  test="TestCht",
}

this.fre={--french, untranslated, untranslated, copy lines from eng to start on
  test="TestFre",
}

this.ger={--german, untranslated, untranslated, copy lines from eng to start on
  test="TestGer",
}

this.ita={--italian, untranslated, untranslated, copy lines from eng to start on
  test="TestIta",
}

this.jpn={--japanese, untranslated, untranslated, copy lines from eng to start on
  test="TestJpn",
}

this.kor={--korean, unconfirmed lang code, use the Patchup > Show language code option to get the language code and contact me on nexus, untranslated, copy lines from eng to start on
  test="TestKor",
}

this.por={--portugese, untranslated, copy lines from eng to start on
  test="TestPor",
}

this.rus={--russian, untranslated, copy lines from eng to start on
  test="TestRus",
}

this.spa={--spanish, untranslated, copy lines from eng to start on
  test="TesSpa",
}

return this
