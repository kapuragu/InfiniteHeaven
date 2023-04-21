--tex used for AutoDoc to create Features and Options documents
local this={
  {
    title="Infinite Heaven features",
    {link="https://www.youtube.com/@TinManSquad","YouTube channel demonstrating many features"},
    "All options in Infinite Heaven start set to game defaults and can be adjusted in the Infinite Heaven menus.",
  },
  {
    title="Discrete features",
    {
      featureDescription="Disables self on FOB.",
      featureHelp="FOB mode automatically uses defaults/unmodified, this does not affect saved settings on return.",
    },
    {
      featureDescription="Abort to ACC from title continue.",
      featureHelp="At the title screen hold down ESCAPE for 1.5 seconds, the KJP logo will flash, clicking Continue will load ACC instead of continuing mission.",
    },
    {
      featureDescription="Equip 'NONE' for primary and secondary via the normal mission prep equipment select screen.",
      featureHelp="The entries will show as a white square with '---' as the text. WARNING: Do not equip these on FOB as there is an equipment check."
    },
    {
      featureDescription="Manually trigger Skulls attack on Quarantine platform.",
      featureHelp="After you have captures some Skulls attack the in their cages to trigger an attack."
    },
    {
      featureDescription="Toggle Disable pull-out in support heli.",
      featureHelp="Pressing [Change Stance] while support heli will toggle Disable pull-out. If changing from pull-out to pull-out disabled you'll still have to exit and enter the heli, but while pull-out is disabled pressing it will cause heli to pull-out."
    },
    {
      featureDescription="Manually trigger open heli door at mission start.",
      featureHelp="Pressing [Change Stance] while support heli at mission start. Mostly useful with the 'Mission start time till open door' so you can control how long you stay sitting in heli on mission start."
    },
    {
      featureDescription="Pause and restart cutscenes.",
      featureHelp="Pressing [Change Stance] when a cutscene is playing will toggle pause/resume. Pressing [Reload] will restart the cutscene."
    },
    {
      featureDescription="Quick menu commands.",
      featureHelp="(Must be enabled via option in IH system menu, or by editing InfQuickMenuDefs.lua)\r\nShortcut key combinations to activate IH features. See Infinite Heaven readme or InfQuickMenuDefs.lua in mod folder."
    },
    {
      featureDescription="Settings save file.",
      featureHelp="IH writes its settings to ih_save.lua in the MGS_TPP\\mod\\saves folder.\r\nWhile the file is editable, editing an inMission save is likely to cause issues."
    },
    {
      featureDescription="Profiles.",
      featureHelp="Editable lists of options as an alternative to using the in game IH menu, see the \\mod\\profiles folder in your MGS_TPP game folder."
    },
    {
      featureDescription="Reload lua scripts in MGS_TPP without exiting game.",
      featureHelp="Hold [Stance],[Action],[Ready weapon],[Binoculars] (Can also use the loadExternalModules command in the Debug menu)"
    },
    {
      featureDescription="New sideops for Mother Base.",
      featureHelp="(Optional Files) Adds 3 new animal capture sideops for Mother Base. Make sure you've cleared the target training sidops for the clusters or they may not show."
    },
    {
      featureDescription="IHHook proxy dll.",
      featureHelp="Installed seperately. For extending IHs capabilities (similar concept to SKSE), and providing a dear-Imgui version of IH menu (to supersede IHExt).\r\n"
    },
--    {
--      featureDescription="IHExt overlay",
--      featureHelp="IHExt is an overlay app that Infinite Heaven can launch to act as the menu when MGSV is in Borderless Fullscreen mode.\r\nThe normal IH activation and navigation of the menu remains the same, but if you alt-tab to the overlay you can use mouse and keyboard to more quickly navigate and change settings. It can also display more descriptive help text for the current option. Can also search by selecting the menu line below the menu list, typing something and pressing enter.\r\nEnable via the IH System menu.\r\nSource can be found at https://github.com/TinManTex/IHExt/"
--    },
  },
  {
    title="Menu, Options and Settings",
[[How to Open the menu:
While in ACC Heli (Safe-space menu), or in-mission (In-mission menu)
Press and hold [Switch Zoom] (V key or RStick click) then press [Dash] (shift key or LStick click) to toggle the mod menu when in the ACC or in-mission.
Or if IHHook is working, press F3

Basic terms used in the Infinite Heaven menu:
[Option] : [Setting(s)] ]],
  },
}
return this
