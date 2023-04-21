## Infinite Heaven features
[https://www.youtube.com/@TinManSquad](https://www.youtube.com/@TinManSquad)  
  
All options in Infinite Heaven start set to game defaults and can be adjusted in the Infinite Heaven menus.
  
## Discrete features
Disables self on FOB.  
FOB mode automatically uses defaults/unmodified, this does not affect saved settings on return.
  
Abort to ACC from title continue.  
At the title screen hold down ESCAPE for 1.5 seconds, the KJP logo will flash, clicking Continue will load ACC instead of continuing mission.
  
Equip 'NONE' for primary and secondary via the normal mission prep equipment select screen.  
The entries will show as a white square with '---' as the text. WARNING: Do not equip these on FOB as there is an equipment check.
  
Manually trigger Skulls attack on Quarantine platform.  
After you have captures some Skulls attack the in their cages to trigger an attack.
  
Toggle Disable pull-out in support heli.  
Pressing [Change Stance] while support heli will toggle Disable pull-out. If changing from pull-out to pull-out disabled you'll still have to exit and enter the heli, but while pull-out is disabled pressing it will cause heli to pull-out.
  
Manually trigger open heli door at mission start.  
Pressing [Change Stance] while support heli at mission start. Mostly useful with the 'Mission start time till open door' so you can control how long you stay sitting in heli on mission start.
  
Pause and restart cutscenes.  
Pressing [Change Stance] when a cutscene is playing will toggle pause/resume. Pressing [Reload] will restart the cutscene.
  
Quick menu commands.  
(Must be enabled via option in IH system menu, or by editing InfQuickMenuDefs.lua)
Shortcut key combinations to activate IH features. See Infinite Heaven readme or InfQuickMenuDefs.lua in mod folder.
  
Settings save file.  
IH writes its settings to ih_save.lua in the MGS_TPP\mod\saves folder.
While the file is editable, editing an inMission save is likely to cause issues.
  
Profiles.  
Editable lists of options as an alternative to using the in game IH menu, see the \mod\profiles folder in your MGS_TPP game folder.
  
Reload lua scripts in MGS_TPP without exiting game.  
Hold [Stance],[Action],[Ready weapon],[Binoculars] (Can also use the loadExternalModules command in the Debug menu)
  
New sideops for Mother Base.  
(Optional Files) Adds 3 new animal capture sideops for Mother Base. Make sure you've cleared the target training sidops for the clusters or they may not show.
  
IHHook proxy dll.  
Installed seperately. For extending IHs capabilities (similar concept to SKSE), and providing a dear-Imgui version of IH menu (to supersede IHExt).

  
## Menu, Options and Settings
How to Open the menu:
While in ACC Heli (Safe-space menu), or in-mission (In-mission menu)
Press and hold [Switch Zoom] (V key or RStick click) then press [Dash] (shift key or LStick click) to toggle the mod menu when in the ACC or in-mission.
Or if IHHook is working, press F3

Basic terms used in the Infinite Heaven menu:
[Option] : [Setting(s)] 
  
### In-ACC menu

2: [IH system menu](#ih-system-menu) >   

3: General Help >>   
- General Help:  
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
  

4: [Appearance menu](#appearance-menu) >   

5: [Cam - AroundCam - FreeCam - menu](#cam---aroundcam---freecam---menu) >   

6: [Cam - PlayCam menu](#cam---playcam-menu) >   

7: [Cam - Player FOV hook menu](#cam---player-fov-hook-menu) >   

8: [Customize menu](#customize-menu) >   

9: [Cutscenes menu](#cutscenes-menu) >   

10: [Debug menu](#debug-menu) >   

11: [Enemy Prep menu](#enemy-prep-menu) >   

12: [Enemy phases menu](#enemy-phases-menu) >   

13: [Enemy reinforcements menu](#enemy-reinforcements-menu) >   

14: [Events menu](#events-menu) >   

15: [Fulton menu](#fulton-menu) >   

16: [Mission-prep features menu](#mission-prep-features-menu) >   

17: [Mother Base menu](#mother-base-menu) >   

18: [Patrols and deployments menu](#patrols-and-deployments-menu) >   

19: [Player restrictions menu](#player-restrictions-menu) >   

20: [Player settings menu](#player-settings-menu) >   

21: [Progression menu](#progression-menu) >   

22: [RouteSet menu](#routeset-menu) >   

23: [Side ops menu](#side-ops-menu) >   

24: [Soldier parameters menu](#soldier-parameters-menu) >   

25: [Support heli menu](#support-heli-menu) >   

26: [Time scale menu](#time-scale-menu) >   

27: [Weather menu](#weather-menu) >   

# 

### IH system menu

1: Enable IHExt <> Not installed, Not installed  
- IHExt is a windows program that acts as an gui overlay if MGSV is running in Windowed Borderless.  

2: Enable help text <> Off, On  
- Shows help text for some options.  

3: Give IHExt focus >>   

4: Enable mouse cursor on menu open = Off, On  
- Automatically enable mouse cursor when IHMenu opens. The cursor can also be seperately toggled with F2  

5: Disable hold menu toggle = Off, On  
- Disables the legacy hold [EVADE] to open menu, the two button menu combo [ZOOM_CHANGE] + [DASH] will still work.  

6: UI Style Editor >>  (Requires IHHook)  
- Toggles the IMGui Style Editor to load, change and save the style for IHHook IMGUI.  

7: Select profile >! All_Options_Example.lua, CustomPrep_Max.lua, CustomPrep_Min.lua, CustomPrep_Wide.lua, Fulton_Heaven.lua, MotherBase_Heaven.lua, Parasite_Hard.lua, Revenge_Heaven.lua, Subsistence_Bounder.lua, Subsistence_Game.lua, Subsistence_Pure.lua  
- Selects a profile from MGS_TPP\mod\profiles folder. Press the [ACTION] button to apply the settings of the selected profile.  

8: Set profile options to game defaults >>   
- Sets the options described in the selected profile to their default setting.  

9: Save to UserSaved profile >>   
- Saves current IH settings to UserSaved profile at MGS_TPP\profiles\UserSaved.lua.  

10: Enable Quick Menu = Off, On  
- Shortcut key combinations to activate IH features. See Infinite Heaven readme or InfQuickMenuDefs.lua in mod folder.  

11: Start offline = Off, On  
- Start the game in offline mode, this also removes the connect option from the pause menu.  

12: Skip startup logos = Off, On  
- Stops the konami/kjp/fox/nvidia logos from showing.  

13: Load addon mission >! <Addon mission names>  

14: Include addon missions in completion percentage <> Off, On  

15: Run AutoDoc >>   
- AutoDoc creates the Features and Options txt and html in docs folder, and profiles/All_Options_Example based on the current menus and options, including any added by other mod IH modules. It will overwrite any existing files.  

16: Reset all IH settings >]   

# 

### Appearance menu

1: Player type <> SNAKE, AVATAR, DD_MALE, DD_FEMALE, OCELOT, QUIET  
- Change main player type. WARNING: Ocelot and Quiet player types have side effect when used due to trying to work around them being restricted to FOB. The Pause menu will be disabled and the game may hit an infinite load if you complete a mission while they are used. Use nexusmods.com/metalgearsolidvtpp/mods/518 by BobDoleOwndU to fix sound issues with using these player types.  

2: Suit type <> NORMAL, NORMAL_SCARF, NAKED, SNEAKING_SUIT_TPP, SNEAKING_SUIT, SNEAKING_SUIT_BB, BATTLEDRESS, PARASITE, LEATHER, SWIMWEAR, SWIMWEAR_G, SWIMWEAR_H, RAIDEN, HOSPITAL, MGS1, NINJA, GOLD, SILVER, MGS3, MGS3_NAKED, MGS3_SNEAKING, MGS3_TUXEDO, EVA_CLOSE, EVA_OPEN, BOSS_CLOSE, BOSS_OPEN, OCELOT, QUIET  

3: Camo type <>   

4: Headgear <> 0-100  

5: Filter faces = Show all, Headgear (cosmetic), Unique, Head fova addons  

6: Face <> 0-0  

7: Skip developed checks = Off, On  
- Allows items that haven't been developed to be selected.  

8: Load avatar >! <list of \mod\avatars>  
- Load avatar from MGS_TPP\mod\avatars  

9: Save avatar >! New,<list of \mod\avatars>  
- Save avatar to MGS_TPP\mod\avatars  

10: Print face info >>   

11: Print appearance info >>   

12: [Form Variation menu](#form-variation-menu) >   

# 

### Form Variation menu
- Form Variation support for player models (requires model swap to support it), the fova system is how the game shows and hides sub-models.

1: Use selected fova <> Off, On  

2: fovaSelection <> 0-255  

3: Print current body info >>   

# 

### Cam - AroundCam - FreeCam - menu

1: Adjust-cam [Mode] <> Off, On  
- Turning this on sets AroundCam mode to Free cam, and lets you use keys/buttons to adjust the options.
  Move cam with normal move keys   
  
  [DASH] (Shift or Left stick click) to move up  
  [SWITCH_ZOOM](Middle mouse or Right stick click) to move down  
  
  Hold the following and move left stick up/down to increase/decrease the settings:  
  
  [FIRE] - Zoom/focal length   
  [RELOAD] - Aperture (DOF)  
  [STANCE] - Focus distance (DOF)   
  [ACTION] - Cam move speed  
  [AIM] - Camera orbit distance  
  
  Or hold [BINOCULARS] and press the above to reset that setting.  
  
  Hold [BINOCULARS] and press [DASH] to move free cam position to the player position  

2: AroundCam mode <> Off, Free cam  
- Lets you turn on freecam, if Adjust-cam mode is off   

3: Reset camera position to player >>   

4: Warp body to FreeCam position >>   

5: Update stage position with camera <> Off, On  
- Sets the map loading position to the free cam position as it moves. Warning: As the LOD changes away from player position your player may fall through the terrain.  

6: positionXFreeCam <> -100000-100000  

7: positionYFreeCam <> -100000-100000  

8: positionZFreeCam <> -100000-100000  

9: Cam move speed scale = 0.01-10  
- Movement speed scale when in Adjust-cam mode  

10: focalLengthFreeCam <> 0.1-10000  

11: focusDistanceFreeCam <> 0.01-1000  

12: apertureFreeCam <> 0.001-100  

13: distanceFreeCam <> 0-100  

14: targetInterpTimeFreeCam <> 0-100  

15: rotationLimitMinXFreeCam <> -90-0  

16: rotationLimitMaxXFreeCam <> 0-90  

17: alphaDistanceFreeCam <> 0-10  

18: Disable Adjust-cam text = Off, On  
- Disables Adjust-cams repeating announce log of the current 'hold button to adjust' settings.  

19: Show freecam position >>   

# 

### Cam - PlayCam menu
- An alternate camera than the one used by freecam. WARNING: is sometimes unstable and may crash the game.

1: Start PlayCam >>   
- Starts PlayCam with current settings. Changing any setting also automatically starts the PlayCam.  

2: Stop PlayCam >>   

3: Camera target <> Player  
- Selects game object for camerat to target. You can add more game objects via the Objects menu in the main Mission menu.  

4: Focal length <> 0.1-10000  
- DOF variable  

5: Focus distance <> 0.1-30  
- DOF variable  

6: Apeture <> 0.001-100  
- DOF variable  

7: Follow Position <> Off, On  
- Follows position of Camera target. Overrides Follow Rotation.  

8: Follow Rotation <> Off, On  
- Follows rotation of Camera target.  

9: Target offset X <> -1000-1000  
- Adjusts X axis of camera target  

10: Target offset Y <> -1000-1000  
- Adjusts Y axis of camera target  

11: Target offset Z <> -1000-1000  
- Adjusts Z axis of camera target  

12: Position offset X <> -1000-1000  
- Adjusts X axis of camera position  

13: Position offset Y <> -1000-1000  
- Adjusts Y axis of camera position  

14: Position offset Z <> -1000-1000  
- Adjusts Z axis of camera position  

15: Follow time <> 0-10000  
- Time in seconds before camera follow turns off. See Follow Position and Follow Rotation.  

16: Follow delay time <> 0-1  
- Delay before camera follows. Acts more like interpolation time than one-off. See Follow Position and Follow Rotation.  

17: Time till end <> 0-10000  
- Time in seconds before PlayCam turns off. Set to high number if you don't want it to end.  

18: Fit on camera <> Off, On  
- Unknown  

19: Fit start time <> 0-1000  
- For Fit on camera.  

20: Fit interp time <> 0-5  
- Interpolation time for Fit on camera.  

21: Fit diff focal length <> 0-100  
- Fit diff focal length  

22: Call Se of Camera Interp <> Off, On  
- Unknown  

23: Use last selected index <> Off, On  
- Unknown  

24: Collision check <> Off, On  
- Checks between camera and target and moves camera in if there is something in the way.  

# 

### Cam - Player FOV hook menu
- Uses IHHook to adjust the player camera focal length.
 Same method as the FOV mod d3d11.dll

1: Enable Player Cam hook <> Off, On (Requires IHHook)  

2: FocalLength Normal <> 0.01-3500 (Requires IHHook)  
- Only updates after changing cam mode.
Focal lengths between modes not equivalent (some other factor being applied)
Lower focal length = wider FOV,
Higher focal length = lower FOV  

3: FocalLength Aiming <> 0.01-3500 (Requires IHHook)  
- Only updates after changing cam mode.
Focal lengths between modes not equivalent (some other factor being applied)
Lower focal length = wider FOV,
Higher focal length = lower FOV  

4: FocalLength Hiding <> 0.01-3500 (Requires IHHook)  
- Only updates after changing cam mode.
Focal lengths between modes not equivalent (some other factor being applied)
Lower focal length = wider FOV,
Higher focal length = lower FOV  

5: FocalLength CQC <> 0.01-3500 (Requires IHHook)  
- Only updates after changing cam mode.
Focal lengths between modes not equivalent (some other factor being applied)
Lower focal length = wider FOV,
Higher focal length = lower FOV  

6: Apply FOV <> 1-179 (Requires IHHook)  
- Applies FOV(degrees) proportionally to the different cam mode focal length options.  

# 

### Customize menu
- Options for saving/loading to items in the idroid Customize menu

1: [Chimera menu](#chimera-menu) >   

2: Load emblem >! <list of \mod\emblems>  
- Load emblem from MGS_TPP\mod\emblems . After loading emblem you must go to the normal Customize emblem system and OK it for it to reapply it. It will also regenerate it next time game is started.  

3: Save emblem >! New,<list of \mod\bionicHand>  
- Save emblem to MGS_TPP\mod\emblems  

4: Load avatar >! <list of \mod\avatars>  
- Load avatar from MGS_TPP\mod\avatars  

5: Save avatar >! New,<list of \mod\avatars>  
- Save avatar to MGS_TPP\mod\avatars  

# 

### Chimera menu
- Chimera is MGSVs weapon cusomization system, this menu lets you save/load from the Customize > Weapons idroid menu

1: Weapon category = HANDGGUN, SMG, ASSAULT, SHOTGUN, GRENADELAUNCHER, SNIPER, MG, MISSILE  
- Changes which weapon category the slots refer to.  

2: Load to slot 1 >! <list of \mod\chimeras>  
- Load chimera from MGS_TPP\mod\chimeras to specified slot  

3: Load to slot 2 >! <list of \mod\chimeras>  

4: Load to slot 3 >! <list of \mod\chimeras>  

5: Save from slot 1 >! New,<list of \mod\bionicHand>  
- Save chimera of specified slot for to MGS_TPP\mod\chimeras   

6: Save from slot 2 >! New,<list of \mod\bionicHand>  

7: Save from slot 3 >! New,<list of \mod\bionicHand>  

8: Clear slot >! SLOT1, SLOT2, SLOT3  

# 

### Cutscenes menu

1: Use selected soldier in all cutscenes and missions = Off, On  

2: MB cutscene play mode = Default, Play selected, Cutscenes disabled  
- Forces or Disables cutscenes that trigger under certain circumstances on returning to Mother Base  

3: Select MB cutscene (REQ: Play selected) = GoToMotherBaseAfterQuietBattle, ArrivedMotherBaseAfterQuietBattle, ArrivedMotherBaseFromDeathFactory, ArrivedMotherBaseLiquid, QuietReceivesPersecution, TheGreatEscapeLiquid, ParasiticWormCarrierKill, AnableDevBattleGear, DevelopedBattleGear1, QuietHasFriendshipWithChild, QuietOnHeliInRain, InterrogateQuiet, DecisionHuey, EntrustDdog, DdogComeToGet, DdogGoWithMe, HappyBirthDayWithQuiet, HappyBirthDay, AttackedFromOtherPlayer_KnowWhereFrom, AttackedFromOtherPlayer_UnknowWhereFrom, QuietWishGoMission, NuclearEliminationCeremony, ForKeepNuclearElimination, SacrificeOfNuclearElimination, MoraleOfMBIsLow, EliLookSnake, LiquidAndChildSoldier, OcelotIsPupilOfSnake, CodeTalkerSunBath, LongTimeNoSee_DdogSuperHighLikability, LongTimeNoSee_DdogHighLikability, LongTimeNoSee_DdogLowLikability, LongTimeNoSee_DdogPup, LongTimeNoSee_DDSoldier, SnakeHasBadSmell_000, SnakeHasBadSmell_001, SnakeHasBadSmell_WithoutQuiet, PazPhantomPain1, PazPhantomPain2, PazPhantomPain4, PazPhantomPain4_jp, DetailsNuclearDevelop, EndingSacrificeOfNuclear, DevelopedBattleGear2, DevelopedBattleGear4, DevelopedBattleGear5, ArrivedMotherBaseChildren  

4: Force allow actions = Off, On  
- Prevents disabling of player actions during cutscene, but most cutscenes require the Disable cutscene camera mod from the IH files page.  

5: Override time = Cutscene default, Current, Custom  

6: Hour = 0-23  

7: Minute = 0-59  

8: Override weather = Cutscene default, Current, Sunny, Cloudy, Rainy, Sandstorm, Foggy, Pouring  

# 

### Debug menu

1: Debug IH mode <> Off, On  
- Switches on logging messages to ih_log.txt (at the cost of longer load times) and enables the announce-log during loading.  

2: debugMessages = Off, On  
- Logs game message system, requires Debug IH mode to be on.  

3: debugFlow = Off, On  
- Logs some script execution flow, requires Debug IH mode to be on.  

4: debugOnUpdate <> Off, On  

5: log_SetFlushLevel <> trace, debug, info, warn, error, critical, off (Requires IHHook)  

6: Reload IH modules >]   

7: copyLogToPrev >>   

8: printPressedButtons = Off, On  

9: Show freecam position >>   

10: Show position >>   

11: Show missionCode >>   

12: Show game language code >>   

13: [appearanceDebugMenu](#appearancedebugmenu) >   

14: Disable mission intro credits = Off, On  

15: manualMissionCode >!   

16: manualSequence >! <seq_sequenceNames>  

17: [Vscode menu](#vscode-menu) >   

18: [debugQuestsMenu](#debugquestsmenu) >   

# 

### appearanceDebugMenu

1: faceFovaDirect >! 0-1000  

2: faceDecoFovaDirect >! 0-1000  

3: hairFovaDirect >! 0-1000  

4: hairDecoFovaDirect >! 0-1000  

5: playerTypeDirect >! 0-255  

6: playerPartsTypeDirect >! 0-255  

7: playerCamoTypeDirect >! 0-255  

8: playerFaceIdDirect >! 0-730  

9: playerFaceEquipIdDirect >! 0-100  

10: Print face info >>   

11: Print appearance info >>   

12: faceFova = 0-1000  

13: faceDecoFova = 0-1000  

14: hairFova = 0-1000  

15: hairDecoFova = 0-1000  

16: faceFovaUnknown1 >! 0-50  

17: faceFovaUnknown2 >! 0-1  

18: eyeFova >! 0-4  

19: skinFova >! 0-5  

20: faceFovaUnknown5 >! 0-1  

21: uiTextureCount >! 0-3  

22: faceFovaUnknown7 >! 0-303  

23: faceFovaUnknown8 >! 0-303  

24: faceFovaUnknown9 >! 0-303  

25: faceFovaUnknown10 >! 0-3  

26: applyFaceFova >>   

27: applyCurrentFovaFace >>   

28: [Form Variation menu](#form-variation-menu) >   

# 

### Vscode menu
- Commands to generate files to support using vscode with a mgsv project.

1: debug_WriteVscodeHintOnTitle = Off, On  
- Runs WriteVscodeHint when loading has reached Title  

2: writeVscodeHint >>   

3: debug_WriteVarsOnSave = Off, On  
- Runs WriteVars on IH save (which includes close IH menu)  

4: writeVars >>   

# 

### debugQuestsMenu
- WARNING: don't use these unless you know exactly what they do.

1: Force Open <> Off, On  
- Lets you force sideops open sideops before the usual progression.  

2: Force Repop <> Off, On  
- Lets you force story and one-time sideops to be replayable.  

3: printCurrentFlags >>   

# 

### Enemy Prep menu
- Ways to modify the Enemy preparedness system that equips the enemy in response to your actions.

1: Free roam prep mode <> Enemy prep levels, Custom prep, Prep levels + Custom overrides  
- Enemy prep levels - the normal games enemy prep levels, Custom prep - uses all the settings in the Custom prep menu, Prep levels + Custom overrides - overrides the Enemy prep levels config with any Custom prep settings that aren't set to their default setting.  

2: Missions prep mode <> Enemy prep levels, Custom prep, Prep levels + Custom overrides  

3: Mother base prep mode <> Off, FOB style, Enemy prep levels, Custom prep, Prep levels + Custom overrides  

4: [Custom prep menu](#custom-prep-menu) >   

5: [Prep system menu](#prep-system-menu) >   

6: [Custom soldier equip menu](#custom-soldier-equip-menu) >   

7: Custom soldier type in Free roam = NONE  
- Override the soldier type of enemy soldiers in Free Roam.
New soldier types can be added via the bodyInfo addon system.  

8: Custom soldier type in Missions = NONE  
- WARNING: Unique soldiers in the mission are likely to either be the default body from the selected custom soldier, or have visual issues if there isn't one.  

9: Reset enemy preparedness levels >>   
- Resets enemy prep levels to 0  

10: Print enemy prep levels >>   

11: Force CP type in Free Roam = Default, Soviet, American, Afrikaans  

12: Force CP type in Missions = Default, Soviet, American, Afrikaans  
- Changes Command Post Type, which controls the language spoken by CP and HQ.
WARNING: Will break subtitles.
WARNING: some CP types don't have responses for certain soldier call-ins for different languages.  

13: Force CP type in MB = Default, Soviet, American, Afrikaans  

14: Random CP subtype in free roam <> Off, On  
- Randomizes the CP subtype - PF types in middle Affrica, urban vs general camo types in Afghanistan  

15: Random CP subtype in missions <> Off, On  
- Randomizes the CP subtype - PF types in middle Affrica, urban vs general camo types in Afghanistan  

16: IH interrogation in free roam = Off, On  
- Adds some interrogations to soldiers: Travel plan of foot patrol, Location of wild card soldier, Location of walker gear. Inter CP quest: Sets up pairs of soldiers in different cps, interrogating one will give CP of other, interrogating him will give a reward of unprocessed resources (around a couple of containers worth) or a skull soldier/parasite on the next extraction (reaching checkpoint etc)  

# 

### Custom prep menu
- Lets you set the individual values that go into an enemy prep configuration (does not use the enemy prep levels), a random value between MIN and MAX for each setting is chosen on mission start. The order of items in the menu is generally order the equipment is allocated to each soldier in a CP.

1: Print example current config (look in iDroid Log>All tab) >>   

2: [Weapon deployment](#weapon-deployment) >   

3: [Armor deployment](#armor-deployment) >   

4: [Headgear deployment](#headgear-deployment) >   

5: [CP deterrent deployment](#cp-deterrent-deployment) >   

6: [Soldier abilities](#soldier-abilities) >   

7: [Weapon strength menu](#weapon-strength-menu) >   

8: [CP equip strength menu](#cp-equip-strength-menu) >   

9: Reinforce calls min <> 1-99  
- Number of reinforcement calls a CP has.  

10: Reinforce calls max <> 1-99  
- Number of reinforcement calls a CP has.  

11: Vehicle reinforcement level min <> NONE, SUPER_REINFORCE, BLACK_SUPER_REINFORCE  

12: Vehicle reinforcement level max <> NONE, SUPER_REINFORCE, BLACK_SUPER_REINFORCE  

13: Ignore combat-deploy supply blocks min <> Off, On  
- Ignores the current results of the Combat Deployment/Dispatch/'cut off the supply' missions that affect enemy prep.  

14: Ignore combat-deploy supply blocks max <> Off, On  

# 

### Weapon deployment

1: SNIPER_MIN <> 0-100%  

2: SNIPER_MAX <> 0-100%  

3: MISSILE_MIN <> 0-100%  

4: MISSILE_MAX <> 0-100%  

5: MG_MIN <> 0-100%  

6: MG_MAX <> 0-100%  

7: SHOTGUN_MIN <> 0-100%  

8: SHOTGUN_MAX <> 0-100%  

9: SMG_MIN <> 0-100%  

10: SMG_MAX <> 0-100%  

11: ASSAULT_MIN <> 0-100%  

12: ASSAULT_MAX <> 0-100%  

13: GUN_LIGHT_MIN <> 0-100%  

14: GUN_LIGHT_MAX <> 0-100%  

# 

### Armor deployment

1: ARMOR_MIN <> 0-100%  

2: ARMOR_MAX <> 0-100%  

3: SOFT_ARMOR_MIN <> 0-100%  

4: SOFT_ARMOR_MAX <> 0-100%  

5: SHIELD_MIN <> 0-100%  

6: SHIELD_MAX <> 0-100%  

# 

### Headgear deployment

1: HELMET_MIN <> 0-100%  

2: HELMET_MAX <> 0-100%  

3: NVG_MIN <> 0-100%  

4: NVG_MAX <> 0-100%  

5: GAS_MASK_MIN <> 0-100%  

6: GAS_MASK_MAX <> 0-100%  

# 

### CP deterrent deployment

1: DECOY_MIN <> 0-100%  

2: DECOY_MAX <> 0-100%  

3: MINE_MIN <> 0-100%  

4: MINE_MAX <> 0-100%  

5: CAMERA_MIN <> 0-100%  

6: CAMERA_MAX <> 0-100%  

# 

### Soldier abilities

1: STEALTH_MIN <> NONE, LOW, HIGH, SPECIAL  
- Adjusts enemy soldiers notice,cure,reflex and speed ablilities.  

2: STEALTH_MAX <> NONE, LOW, HIGH, SPECIAL  

3: COMBAT_MIN <> NONE, LOW, HIGH, SPECIAL  
- Adjusts enemy soldiers shot,grenade,reload,hp and speed abilities.  

4: COMBAT_MAX <> NONE, LOW, HIGH, SPECIAL  

5: HOLDUP_MIN <> NONE, LOW, HIGH, SPECIAL  

6: HOLDUP_MAX <> NONE, LOW, HIGH, SPECIAL  

7: FULTON_MIN <> NONE, LOW, HIGH, SPECIAL  

8: FULTON_MAX <> NONE, LOW, HIGH, SPECIAL  

# 

### Weapon strength menu
- Whether to deploy the stronger weapon class for the weapon type

1: STRONG_WEAPON_MIN <> Off, On  

2: STRONG_WEAPON_MAX <> Off, On  

3: STRONG_SNIPER_MIN <> Off, On  

4: STRONG_SNIPER_MAX <> Off, On  

5: STRONG_MISSILE_MIN <> Off, On  

6: STRONG_MISSILE_MAX <> Off, On  

# 

### CP equip strength menu

1: ACTIVE_DECOY_MIN <> Off, On  

2: ACTIVE_DECOY_MAX <> Off, On  

3: GUN_CAMERA_MIN <> Off, On  

4: GUN_CAMERA_MAX <> Off, On  

# 

### Prep system menu

1: Resupply in #missions = 0-10  
- The number of missions the enemy dispatch/resupply with unlock after your last successful dispatch mission for that type.  

2: Apply enemy prep to guard posts = Off, On  

3: Apply enemy prep to patrol soldiers = Off, On  

4: Allow heavy armor in free roam (may have issues) = Off, On  

5: Allow heavy armor in all missions (may have issues) = Off, On  

6: Disable weapon restrictions in certain missions = Off, On  
- Missions 2, 12, 13, 16, 26, 31 normally prevent the application of shields, missiles, shotguns and MGs to the general CP enemy prep (though some may have custom enemy prep).  

7: Allow Enemy Prep change from free roam = Off, On  
- By default enemy prep only changes in response to actual missions, this option allows enemy prep changes to be applied after leaving Free roam (but not via abort)  

8: Enemy prep decrease on long MB visit = Off, On  
- Spend a number of game days (break out that cigar) during a mother base visit and enemy prep levels will decrease on leaving. Currently reduces after 3 days (stacking), reduces the same as chicken hat   

9: Allow helmet and NVG or Gas mask combo = Off, On  

10: Ballance heavy armor and head gear distribution = Off, On  
- Adjusts application percentages of the normally mutally exclusive options of heavy armor and the different headgear pieces, not nessesary if Allow helmet and NVG or Gas mask combo option is on  

11: Allow missile combo with other weapons = Off, On  
- In the default game soldiers with missiles only have SMGs, this allows them to have MGs, shotguns or assault rifles assigned to them.  

12: Mg vs Shotgun variation = Off, On  
- In the default game the enemy prep config chooses randomly either MG or Shotguns which is applied for all CPs in the whole mission. This setting allows mixed MGs and Shotguns (but still with the enemy prep total) and also applies them per CP.  

13: Balance small CPs = Off, On  
- Adds limits and some randomisation to small cp/lrrps enemy prep application  

14: Disable convert armor to shield (if armor off) = Off, On  
- Where heavy armor is disabled (free roam by default) the normal game converts armor to shields in addition to the normal shield application, this often leads to it feeling like there's just too many.  

15: Randomize minefield mine types = Off, On  
- Randomizes the types of mines within a minfield from the default anti-personel mine to gas, anti-tank, electromagnetic. While the placing the mines may not be ideal for the minetype, it does enable OSP of items that would be impossible to get otherwise.  

16: Enable additional minefields = Off, On  
- In the game many bases have several mine fields but by default only one is enabled at a time, this option lets you enable all of them. Still relies on enemy prep level to be high enough for minefields to be enabled.  

# 

### Custom soldier equip menu
- Allow soldiers to have equipment from other locations/types, including DD equipment usually only used on FOB. Soldiers are assigned a random weapon of the type the prep system assigns them, so you'll see more weapon variation

1: Global soldier weapon table in FreeRoam = <list of \mod\weaponIdTables>  
- Base soldier weapon table, either the games default or an addon table. Combined soldier weapon table builds from this.  

2: Global soldier weapon table in Missions = <list of \mod\weaponIdTables>  
- Base soldier weapon table, either the games default or an addon table. Combined soldier weapon table builds from this.  

3: Global soldier weapon table in MB = <list of \mod\weaponIdTables>  
- Base soldier weapon table, either the games default or an addon table. Combined soldier weapon table builds from this.  

4: Enemy use custom weapon table in free roam = Off, On  

5: Enemy use custom equip table in missions = Off, On  

6: MB staff use custom equip table = Off, On  

7: Weapon stengths = NORMAL, STRONG, Combined  
- The game weapon tables have Normal and Strong lists that the Enemy prep system will pick from, this setting allows you to select either, or combine them.  

8: Include Soviet weapons = Off, On  

9: Include PF weapons = Off, On  

10: Include XOF weapons = Off, On  

11: Include DD weapons = Off, On  
- Add the DD weapons table that's usually used for FOB, the following grade and developed settings control how this table is built  

12: DD weapons grade MIN <> 1-15  
- A grade will be chosen between MIN and MAX at mission start. Note: Equip grade 3 is the minimum grade that has all types of weapons.  

13: DD weapons grade MAX <> 1-15  

14: Allow undeveloped DD weapons = Off, On  
- Whether to limit the selection to equipment you have developed or allow all equipment. Restriction does not apply to Enemies using DD weapons.  

15: DD equipment non-lethal = Off, On  

# 

### Enemy phases menu
- Adjust minimum and maximum alert phase for enemy Command Posts

1: Enable phase modifications <> Off, On  
- The Minimum, Maximum, and Don't downgrade phase settings are applied on at every update tick according to the Phase update rate and random variation settings  

2: Minimum phase <> PHASE_SNEAK, PHASE_CAUTION, PHASE_EVASION, PHASE_ALERT  
- PHASE_SNEAK - not alert, PHASE_CAUTION - alert, PHASE_EVASION - one step down from combat alert, PHASE_ALERT - combat alert  

3: Maximum phase <> PHASE_SNEAK, PHASE_CAUTION, PHASE_EVASION, PHASE_ALERT  
- PHASE_SNEAK - not alert, PHASE_CAUTION - alert, PHASE_EVASION - one step down from combat alert, PHASE_ALERT - combat alert  

4: Don't downgrade phase = Off, On  

5: Phase mod update rate (seconds) = 1-255  
- Rate that the CPs phase is adjusted to the minimum and maxium settings.  

6: Phase mod random variation = 0-255  
- Random variation of update rate  

7: Alert phase on vehicle attack = PHASE_SNEAK, PHASE_CAUTION, PHASE_EVASION, PHASE_ALERT  
- Does not require phase modifications setting to be enabled. The enemy reactions to heavy vehicle attack in the default game are lacking, you can kill someone and they'll act as if it's an unsourced attack. This option changes phase of soldiers command post on damaging the soldier. Setting it to ALERT recommended.  

8: Print phase changes = Off, On  
- Displays when phase changes.  

# 

### Enemy reinforcements menu

1: Vehicle reinforcements = Off, Enemy Prep, Force Prep  
- In the normal game vehicle reinforcments through this system is only used for two missions, this enables it for more. Only heli will appear in free roam, vehicles depend on mission.  

2: Force enable enemy heli reinforce (disables heli sideops) <> Off, On  
- Since the enemy heli reinforce feature re-uses the sideops heli, enabling this will disable sideops that have a heli in them so that the reinforce can use it.  

3: Force reinforce request for heli = Off, On  

4: Disable reinforce heli pull-out = Off, On  

5: Soldier reinforce with all vehicle reinforce types = Off, On  
- Allows an extra set of reinforce soldiers with all vehicle reinforce types instead of just Wheeled Armored Vehicles.  

# 

### Events menu
- Events are temporary combinations of IH settings for free roam and mother base.  
Free roam events (can stack):  
Crashland: Starts you on foot in at a random start point and randomly selects OSP options - cleared primary, secondary, back weapons, items, support items.  
Lost-coms: Disables most mother base support menus and disables all heli landing zones except from main bases/towns.  
Hunted: Sets the enemy to combat alert every 15-45 seconds (this also sets the player spotted position right on you), and also disables heli landing zones in a 2k radius from your start position, so you'll have to travel if you want to 'get out'.  
MB events (only one active):  
DD Training wargame,  
Soviet attack,  
Rogue Coyote attack,  
XOF attack,  
DD Infection outbreak,  
Zombie Obliteration (non DD)  

1: Hunted event chance = 0-100%  
- Chance to start event Hunted on starting free roam. Hunted: Sets the enemy to combat alert every 15-45 seconds (this also sets the player spotted position right on you), and also disables heli landing zones in a 2k radius from your start position, so you'll have to travel if you want to 'get out'.   

2: Crashland event chance = 0-100%  
- Chance to start event Crashland on starting free roam. Crashland: Starts you on foot in at a random start point and randomly selects OSP options - cleared primary, secondary, back weapons, items, support items.  

3: Lost Coms event chance = 0-100%  
- Chance to start event Lost-coms on starting free roam. Disables most mother base support menus and disables all heli landing zones except from main bases/towns.   

4: DD Training wargame event chance = 0-100%  
- Chance to randomly trigger DD Training wargame on returning to MB.  

5: Invasion event chance = 0-100%  
- Chance to randomly trigger an Invasion event on returning to MB.  

6: DD Infection event chance = 0-100%  
- Chance to randomly trigger DD Infection outbreak on returning to MB.  

7: Zombie Obliteration event chance = 0-100%  
- Chance to randomly trigger Zombie Obliteration (non DD) on returning to MB.  

8: [Skulls event menu](#skulls-event-menu) >   

# 

### Skulls event menu

1: Enable Skull attacks in Free roam = Off, On  
- Skulls attack at a random time (in minutes) between Skull attack min and Skull attack max settings.  

2: Allow armor skulls = Off, On  

3: Allow mist skulls = Off, On  

4: Allow sniper skulls = Off, On  

5: Skull attack min (minutes) <> 0-180  

6: Skull attack max (minutes) <> 0-180  

7: Weather on Skull attack = None, Parasite fog, Random  

8: parasite_zombieLife = 0-10000  

9: parasite_zombieStamina = 0-10000  

10: parasite_msfRate = 0-100  
- Percentage chance a zombified soldier will have msf zombie behaviour  

11: parasite_msfCombatLevel_MIN <> 0-9  

12: parasite_msfCombatLevel_MAX <> 0-9  

13: parasite_playerRange = 0-1000  

14: parasite_sightDistance = 0-1000  

15: parasite_sightDistanceCombat = 0-1000  

16: parasite_sightVertical = 0-1000  

17: parasite_sightHorizontal = 0-1000  

18: parasite_noiseRate = 0-100  

19: parasite_avoidSideMin = 0-100  

20: parasite_avoidSideMax = 0-100  

21: parasite_areaCombatBattleRange = 0-1000  

22: parasite_areaCombatBattleToSearchTime = 0-100  

23: parasite_areaCombatLostSearchRange = 0-10000  

24: parasite_areaCombatLostToGuardTime = 0-1000  

25: parasite_throwRecastTime = 0-1000  

26: parasite_defenseValueMain = 0-100000  

27: parasite_defenseValueArmor = 0-100000  

28: parasite_defenseValueWall = 0-100000  

29: parasite_offenseGrade = 0-100  

30: parasite_defenseGrade = 0-100  

31: parasite_defenseValueCAMO = 0-100000  

32: parasite_offenseGradeCAMO = 0-100  

33: parasite_defenseGradeCAMO = 0-100  

34: parasite_escapeDistanceARMOR = 0-10000  

35: parasite_escapeDistanceMIST = 0-10000  

36: parasite_escapeDistanceCAMO = 0-10000  

37: parasite_spawnRadiusARMOR = 0-1000  

38: parasite_spawnRadiusMIST = 0-1000  

39: parasite_spawnRadiusCAMO = 0-1000  

40: parasite_timeOutARMOR = 0-1000  

41: parasite_timeOutMIST = 0-1000  

42: parasite_timeOutCAMO = 0-1000  

# 

### Fulton menu

1: Extraction team in Free Roam = Off, On  
- Extraction team will recover enemies you have neutralized after you've traveled some distance from them (usually to next command post), using the same success rate as manual fultoning. This lets you do low/no fulton runs without having to sacrifice the recruitment side of gameplay.  

2: Extraction team in Missions = Off, On  

3: Extraction recover critical = Off, On  
- Requires Extraction team option enabled. Extraction team will recover critically shot soldiers (ie 'dead' soldiers). Depending on medical section success. This lets you play with more lethal weapons while still keeping up with the recruitment gameplay.  

4: Disable fulton action = Off, On  
- Disables fulton at the player-action level  

5: [Fulton levels menu](#fulton-levels-menu) >   

6: [Fulton success menu](#fulton-success-menu) >   

# 

### Fulton levels menu

1: Fulton Level <> Don't override, Grade 1, Grade 2, Grade 3, Grade 4  

2: Wormhole Level <> Don't override, Disable, Enable  

# 

### Fulton success menu
- Adjust the success rate of fultoning

1: Fulton success variation = 0-100  
- Subtracts the purcentage from fulton success in a periodic fashion.  

2: Soldier fulton success variation = 0-100  

3: Fulton variation inv rate = 1-1000  
- Inverse rate (higher slower) of fulton variation cycle  

4: MB fulton support scale = 0-400%  
- Scales the success bonus from mother base support section (which itself scales by section level). In the base game this is mostly used to counter weather penalty.  

5: MB fulton medical scale = 0-400%  
- Scales the success bonus from mother base medical section (which itself scales by section level). In the base game this used to counter injured target penalty  

6: Target dying penalty = 0-100  

7: Target sleeping penalty = 0-100  

8: Target holdup penalty = 0-100  

9: Hostage handling = Default, Must extract (0%)  

10: Print mb fulton success bonus >>   

# 

### Mission-prep features menu
- Only affects the mission-prep screen, not the in-mission equivalents.

1: Skip mission prep for Free Roam = DEFAULT, FALSE, TRUE  
- Go straight to mission, skipping the mission prep screen.  

2: Skip mission prep for Story Mission = DEFAULT, FALSE, TRUE  
- Go straight to mission, skipping the mission prep screen.  

3: Skip mission prep for MB = DEFAULT, FALSE, TRUE  
- Go straight to mission, skipping the mission prep screen.  

4: Disable select-buddy for Free Roam = DEFAULT, FALSE, TRUE  
- Prevents selection of buddies during mission prep.  

5: Disable select-buddy for Story Mission = DEFAULT, FALSE, TRUE  
- Prevents selection of buddies during mission prep.  

6: Disable select-buddy for MB = DEFAULT, FALSE, TRUE  
- Prevents selection of buddies during mission prep.  

7: Disable select-vehicle for Free Roam = DEFAULT, FALSE, TRUE  
- WARNING: Selecting a vehicle if the mission does not have player vehicle support means there will be no vehicle recovered on mission exit (effecively losing the vehicle you attempted to deploy).  

8: Disable select-vehicle for Story Mission = DEFAULT, FALSE, TRUE  
- WARNING: Selecting a vehicle if the mission does not have player vehicle support means there will be no vehicle recovered on mission exit (effecively losing the vehicle you attempted to deploy).  

9: Disable select-vehicle for MB = DEFAULT, FALSE, TRUE  
- WARNING: Selecting a vehicle if the mission does not have player vehicle support means there will be no vehicle recovered on mission exit (effecively losing the vehicle you attempted to deploy).  

10: Disable select-sortie time for Free Roam = DEFAULT, FALSE, TRUE  
- Only allows ASAP at mission prep  

11: Disable select-sortie time for Story Mission = DEFAULT, FALSE, TRUE  
- Only allows ASAP at mission prep  

12: Disable select-sortie time for MB = DEFAULT, FALSE, TRUE  
- Only allows ASAP at mission prep  

# 

### Mother Base menu

1: Mother base prep mode <> Off, FOB style, Enemy prep levels, Custom prep, Prep levels + Custom overrides  

2: [Custom soldier equip menu](#custom-soldier-equip-menu) >   

3: MB Equip Range Type (MB Prep mode FOB only) = Short-range, Medium-range, Long-range, Random range  

4: Custom DD type in MB = NONE  
- New body types can be added via the bodyInfo addon system.  

5: Custom DD female type in MB = OFF, RANDOM, DRAB_FEMALE, TIGER_FEMALE, SNEAKING_SUIT_FEMALE, BATTLE_DRESS_FEMALE, SWIMWEAR_FEMALE, SWIMWEAR2_FEMALE, SWIMWEAR3_FEMALE  
- New body types can be added via the bodyInfo addon system.  

6: DD Head gear = Off, Current prep  

7: NPC support heli patrols in MB = 0-3  
- Spawns some npc support helis that roam around mother base.  

8: Attack heli patrols in MB = No helis, 1 heli, 2 helis, 3 helis, 4 helis, Enemy prep  
- Spawns some npc attack helis that roam around mother base.  

9: Attack heli type in MB = HP-48 Krokodil, UTH-66 Blackfoot  

10: Attack heli class in MB = DEFAULT, BLACK, RED, RANDOM, RANDOM_EACH, ENEMY_PREP  

11: Walker gears in MB = Off, On  

12: Walker gears type = Soviet, Rogue Coyote, CFA, ZRS, Diamond Dogs, Hueys Prototype (texture issues), All one random type, Each gear random type  

13: Walker gears weapons = Even split of weapons, Minigun, Missiles, All one random type, Each gear random type  

14: Repopulate plants and diamonds = Off, On  
- Regenerates plants on Zoo platform and diamonds on Mother base over time.  

15: Enemy prep decrease on long MB visit = Off, On  
- Spend a number of game days (break out that cigar) during a mother base visit and enemy prep levels will decrease on leaving. Currently reduces after 3 days (stacking), reduces the same as chicken hat   

16: Enable all buddies = Off, On  
- Does not clear D-Horse and D-Walker if set from deploy screen and returning to mother base, they may however spawn inside building geometry, use the call menu to have them respawn near. Also allows buddies on the Zoo platform, now you can take D-Dog or D-Horse to visit some animals.  

17: More soldiers on MB plats = Off, On  
- Increases soldiers on platforms from 4 soldiers to 9.  

18: Force enable Quaranine platform soldiers = Off, On  
- Normally game the Qurantine platform soldiers are disabled once you capture Skulls. This option re-enables them.  

19: Soldiers move between platforms = Off, On  
- Soldiers will periodically move between platforms (only within the same cluster).  

20: [Staff menu](#staff-menu) >   

21: [Show characters menu](#show-characters-menu) >   

22: [Show assets menu](#show-assets-menu) >   

23: Allow lethal actions = Off, On  
- Enables lethal weapons and actions on Mother Base. You will still get a game over if you kill staff.  

24: Women in Enemy Invasion mode = 0-100%  

25: Mother Base War Games <> Off, DD Training, Enemy Invasion, DD Infection, Zombie Obliteration (non DD)  
- Profiles that sets many of the wargames event settings, but just the underlying categories, see 'MB event random trigger chance' actually themed/flavorful versions  

# 

### Staff menu

1: Add player staff to MB priority >>   
- Add the last sortie selected DD member to the Mother Base priority staff list to have them appear on MB  

2: Remove player staff to MB priority >>   
- Removes the last sortie selected DD member to the Mother Base priority staff list  

3: Clear MB staff priority list >>   
- Clears MB staff priority list entirely  

4: Female staff selection = Default, None, All available, Half  
- By default the game tries to assign a minimum of 2 females per cluster from the females assigned to the clusters section, All available and Half will select females first when trying to populate a MB section, None will prevent any females from showing on mother base  

5: Staff-wide morale boost for good visit = Off, On  
- Gives a staff-wide morale boost on having a number of soldiers salute (most of a cluster), visiting a number of clusters (with at least one salute on each), or staying in base a number of game days (break out that cigar). Must leave the base via heli for it to apply.  

6: Add more salute reactions = Off, On  
- Adds additional reactions from MB staff when they salute you.  

# 

### Show characters menu

1: Enable Ocelot = Off, On  
- Enables Ocelot to roam the command platform.  

2: Puppy DDog = Off, Missing eye, Normal eyes  
- Note: Requires you to actually get and complete the base game ddog puppy sequence.  

3: Show Code Talker = Off, On  

4: Show Eli = Off, On  

5: Show Huey = Off, On  
- Shows Huey in BattleGear hangar and in cutscenes even before he's arrived or after he's left story-wise.  

6: Enable Birds = Off, On  

7: [Additional NPCs menu](#additional-npcs-menu) >   

8: Reset Paz state to beginning >>   

9: Return Quiet after mission 45 >>   
- Instantly return Quiet, runs same code as the Reunion mission 11 replay.  

10: showQuietReunionMissionCount >>   

# 

### Additional NPCs menu

1: Female nurse = Off, On  

2: Male doctor = Off, On  

3: Male researcher = Off, On  

4: Female researcher = Off, On  

5: Male groundcrew = Off, On  

6: Children = Off, On  

7: Kaz Miller = Off, On  

# 

### Show assets menu

1: Show Big Boss posters = Off, On  

2: Show nuke elimination monument = Off, On  

3: Show Sahelanthropus = Off, On  

4: Show ships = Off, On  

5: Enable asset alarms = Off, On  
- Enables anti fulton theft alarms on containers and AA guns. Only partially working, will only trigger alarm once.  

6: Enable IR sensors = Off, On  
- Enable IR sensor gates. Only partially working, will only trigger alarm once, and will only show one or no beam.  

7: Hide containers = Off, On  

8: Hide AA cannons = Off, On  

9: Hide AA gatlings = Off, On  

10: Hide turret machineguns = Off, On  

11: Hide mortars = Off, On  

12: Unlock goal doors = Off, On  

13: Force BattleGear built level = 0-5  
- Changes the build state of BattleGear in it's hangar, 0 is use the regular story progression.  

14: Replay story cutscene when entering BattleGear hangar = Off, On  
- Will play the cutscene that goes with the BattleGear built level.  

# 

### Patrols and deployments menu

1: Foot patrols in free roam = Off, On  
- Foot patrols will travel between random CPs and will cross the field to get there.  

2: Wildcard soldiers Free roam = Off, On  
- Changes a few soldiers throughout the CPs to have unique models and high end weapons.  

3: Attack heli patrols in free roam = No helis, 1 heli, 2 helis, 3 helis, 4 helis, Enemy prep  
- Allows multiple enemy helicopters that travel between larger CPs. Due to limitations their current position will not be saved/restored so may 'dissapear/appear' on reload.  

4: Attack heli patrols in MB = No helis, 1 heli, 2 helis, 3 helis, 4 helis, Enemy prep  
- Spawns some npc attack helis that roam around mother base.  

5: Attack heli type in FreeRoam = HP-48 Krokodil, UTH-66 Blackfoot  

6: Attack heli type in MB = HP-48 Krokodil, UTH-66 Blackfoot  

7: Attack heli class in FreeRoam = DEFAULT, BLACK, RED, RANDOM, RANDOM_EACH, ENEMY_PREP  
- Combined appearance and health  

8: Attack heli class in MB = DEFAULT, BLACK, RED, RANDOM, RANDOM_EACH, ENEMY_PREP  

9: Walker gears in free roam = Off, On  
- Adds a Walker gear to each main base.  

10: Walker gears in MB = Off, On  

11: Vehicle patrols in free roam = Game default - trucks only, All of one type, Each vehicle differing type  
- Replaces the patrolling trucks in free roam with other vehicles, picked randomly from enabled types.  

12: Vehicle patrol class = Default, Dark grey, Red, All one random type, Each vehicle random type, Enemy prep  

13: Allow jeeps = Off, On  

14: Allow trucks = Off, On  

15: Allow wheeled armored vehicles = Off, On  

16: Allow heavy wheeled armored vehicles = Off, On  

17: Allow tanks = Off, On  

18: Equipment on trucks = Off, On  
- Puts a random piece of equipment on the back of patrol trucks.  

# 

### Player restrictions menu
- Settings to customize the game challenge, including subsistence and OSP.

1: Disable support heli attack <> Off, On  
- Stops support heli from engaging targets.  

2: Disable fulton action = Off, On  
- Disables fulton at the player-action level  

3: Force subsistence suit (Olive Drab, no headgear) = Off, On  

4: Set hand type to default = Off, On  

5: Disable abort mission from pause menu = Off, On  

6: Disable retry on mission fail = Off, On  

7: Game over on combat alert <> Off, On  

8: Disable game over on killing child soldier = Off, On  

9: Disable out of bounds checks <> Off, On  

10: Disable game over = Off, On  

11: Disable Intel team enemy spotting = Off, On  
- Stops the Intel teams enemy spotting audio notification and indication on the idroid map.  

12: Disable Intel team herb spotting (requires game restart) <> Off, On  
- Stops the Intel teams plant spotting audio notification and indication on the idroid map. Since the variable is only read once on game startup this setting requires a game restart before it will activate/deactivate.  

13: Keep equipment Free<>Mission = Off, On  
- Prevents equipment and weapons being reset when going between free-roam and missions.  

14: [Marking display menu](#marking-display-menu) >   

15: [Disable mission support-menus menu](#disable-mission-support-menus-menu) >   

16: [Item level menu](#item-level-menu) >   

17: [Hand abilities levels menu](#hand-abilities-levels-menu) >   

18: [Fulton levels menu](#fulton-levels-menu) >   

19: [Fulton success menu](#fulton-success-menu) >   

20: [OSP menu](#osp-menu) >   

21: [Mission-prep features menu](#mission-prep-features-menu) >   

# 

### Marking display menu
- Toggles for marking in main view. Does not effect marking on iDroid map

1: Disable head markers <> Off, On  
- Disables markers above soldiers and objects  

2: Disable Xray marking <> Off, On  
- Disables the 'X-ray' effect of marked soldiers. Note: Buddies that mark still cause the effect.  

3: Disable world markers <> Off, On  
- Disables objective and placed markers  

# 

### Disable mission support-menus menu
- Disables mission support menus in iDroid

1: Disable Supply drop support-menu = Off, On  

2: Disable Buddies support-menu = Off, On  

3: Disable Attack support-menu = Off, On  

4: Disable Heli attack support-menu = Off, On  

5: Disable Support-menu = Off, On  

# 

### Item level menu

1: Int-Scope level <> Don't override, Grade 1, Grade 2, Grade 3, Grade 4  

2: IDroid level <> Don't override, Grade 1, Grade 2, Grade 3, Grade 4  

# 

### Hand abilities levels menu

1: Sonar level <> Don't override, Disable, Grade 2, Grade 3, Grade 4  

2: Mobility level <> Don't override, Disable, Grade 2, Grade 3, Grade 4  

3: Precision level <> Don't override, Disable, Grade 2, Grade 3, Grade 4  

4: Medical level <> Don't override, Disable, Grade 2, Grade 3, Grade 4  

# 

### OSP menu
- Allows you to enter a mission with primary, secondary, back weapons set to none, individually settable. Separate from subsistence mode (but subsistence uses it). LEGACY You should set equip none via mission prep instead.

1: Primary weapon OSP = Use selected weapon, Clear weapon  

2: Secondary weapon OSP = Use selected weapon, Clear weapon  

3: Back Weapon OSP = Use selected weapon, Clear weapon  

4: Items OSP = Off, On  

5: Support items OSP = Off, On  

# 

### Player settings menu

1: Player life scale <> 0-650%  

2: Subtract demon points >>   
- Subtracts 999999 points from demon score  

3: Add demon points >>   
- Adds 999999 points to demon score  

4: Don't subtract hero points = Off, On  
- Actions that usually subtract hero points don't.  

5: Don't add demon points = Off, On  
- Actions that usually add demon points don't.  

6: Hero points subtract demon points = Off, On  
- Actions that add hero points subtract the same amount of demon points  

7: Use selected soldier in all cutscenes and missions = Off, On  

# 

### Progression menu

1: [Resource scale menu](#resource-scale-menu) >   

2: Repopulate music tape radios = Off, On  

3: Repopulate plants and diamonds = Off, On  
- Regenerates plants on Zoo platform and diamonds on Mother base over time.  

4: Repopulate AA Radars = 0-100  
- Number of mission completes before destroyed Anti Air Radars are rebuilt.  

5: Force BattleGear built level = 0-5  
- Changes the build state of BattleGear in it's hangar, 0 is use the regular story progression.  

6: Replay story cutscene when entering BattleGear hangar = Off, On  
- Will play the cutscene that goes with the BattleGear built level.  

7: Unlock playable avatar >>   
- Unlock avatar before mission 46  

8: Unlock weapon customization >>   
- Unlock without having to complete legendary gunsmith missions  

9: Reset Paz state to beginning >>   

10: Return Quiet after mission 45 >>   
- Instantly return Quiet, runs same code as the Reunion mission 11 replay.  

11: showQuietReunionMissionCount >>   

# 

### Resource scale menu

1: Enable resource amount scales <> Off, On  
- Enables the resource scale options that scale the amount of resources when gathered (material case resources, containers, diamonds, plants)  

2: Material case scale = 10-1000%  

3: Plant scale = 10-1000%  

4: Poster scale = 10-1000%  

5: Diamond scale = 10-1000%  

6: Container scale = 10-1000%  

# 

### RouteSet menu
- Options to randomize what routes soldiers use in a Command Post.

1: Randomize RouteSets in missions = Off, On  
- Enables all following options. Also randomizes current routeSet on mission load/reload. WARNING: may mess up scripted mission routes.  

2: Randomize RouteSets in free roam = Off, On  
- Enables all following options. Also randomizes current routeSet on mission load/reload. Requires randomize group priority or group routes to be on.  

3: Randomize on shift change = Off, On  
- Randomize current routeSet on morning and night shift changes.  

4: Randomize on phase change = Off, On  
- Randomize current routeSet when enemy phase changes in any way, Sneak, Caution, Alert, Evasion. Up or down.  

5: Randomize group priority = Off, On  
- Each routeSet for a CP has a number of groups of routes, this will change the order the groups are picked from.  

6: Randomize group routes = Off, On  
- Each routeSet for a CP has a number of groups of routes, this will change the order within the group.  

7: Randomize RouteSet now >>   
- Randomize current routeset right now. (Use the command in-mission).  

# 

### Side ops menu

1: Reroll sideops selection >>   
- Note: You may not see any change unless you use 'Selection for Area mode' set to Random. Many of the other IH sideop options allready run this after you change them.  

2: Force specific sideop # <> 0-157  
- WARNING: This allows opening a sideop outside of normal progression. Unlocks the sideop with the quest number that shows in the UI. Since the sideops shown in the UI are limited, try 'Show on UI mode' and other filtering settings to show other sideops.  

3: Repop one-time sideops <> Off, On  
- Lets you force story and one-time sideops to be replayable.  

4: Selection for Area mode <> First found (default), Random, Random Addon  
- Sideops are broken into areas to stop overlap, this option lets you control the choice which repop sideop will be selected to be Active for the area.  
'Random Addon' will prioritize Addon sideops first.  
All selection is still prioritized by uncompleted story sideops, then other uncompleted sideops, then repop sideops selected by this option.  

5: Repop mode <> On none left, Allways  
- Lets you choose the behaviour of how repeatable sideops are repopulated. The update is run for the sideop area of a sideop you just finished, or for all areas when changing many of the IH sideops options or rerolling sideops.  
The default 'None left' will only repopulate sideops when there are no other uncompleted sideops, and all other repeatable sideops have been completed.  
'Allways' will refresh repeatable sideops every time the update is called.  
Best use with Select for Area mode set to Random.  

6: [Sideops category selection menu](#sideops-category-selection-menu) >   

7: [Show on UI menu](#show-on-ui-menu) >   

8: Force enable enemy heli reinforce (disables heli sideops) <> Off, On  
- Since the enemy heli reinforce feature re-uses the sideops heli, enabling this will disable sideops that have a heli in them so that the reinforce can use it.  

9: Include add-on sideops in completion percentage <> Off, On  

10: Enable Shooting Practice Retry = Off, On  
- Does not hide the starting point when Shooting Practice starts or finishes, and allows you to cancel while in progress and start again.  

11: Set Shooting Practice caution time to best time = Off, On  
- Sets the caution time/time when the timer turns red to the current best time (rounded up to the second) so you have a clearer idea when going for best time.  

12: [Side ops in missions menu](#side-ops-in-missions-menu) >   

# 

### Sideops category selection menu
- Per category selection of which sidops can be Active.

1: Story/unique <> All, None, Addon only  

2: Extract interpreter <> All, None, Addon only  

3: Secure blueprint <> All, None, Addon only  

4: Extract highly-skilled soldier <> All, None, Addon only  

5: Prisoner extraction <> All, None, Addon only  

6: Capture animals <> All, None, Addon only  

7: Extract wandering Mother Base soldier <> All, None, Addon only  

8: Unlucky Dog <> All, None, Addon only  

9: Eliminate heavy infantry <> All, None, Addon only  

10: Mine clearing <> All, None, Addon only  

11: Eliminate the armored vehicle unit <> All, None, Addon only  

12: Extract the Legendary Gunsmith <> All, None, Addon only  

13: Eliminate tank unit <> All, None, Addon only  

14: Eliminate wandering puppets <> All, None, Addon only  

15: Target practice <> All, None, Addon only  

16: No category assigned <> All, None, Addon only  

# 

### Show on UI menu
- Settings for what sideops to show and how they should be sorted depedending on various parameters for sideops on the idroid sideops list.  
The vanilla behavior just shows current Active and Cleared sideops, in index order, which lets you see past progression/completion,  
Though since uncleared sideops do have priority, one will be selected for Active.  
So if there's multiple uncleared for an area they will not be shown, which gives you less of an idea of future progression.  
These option give you individual control for showing sideops depending on their conditions.  
For a given sideop multiple of the underlying conditions may be true at one time and either depend on your progress through the game, or from other IH settings.  
There is however a limit of 192 entries for the sideop list (there's 157 sideops in the base game), which some settings might push over if you have addon sideops, in which case some Cleared entries be randomly dropped from the list.  
See the notes for each option for more info.  
Sorting:  
Sorting will proceed through all flags that have a sorting setting (not set to None). So sort is in respect to the option above it.  
None: Will not apply any specific sort, so will just be in index order, but may be moved around if other flags sort it.  
The other settings, Top, Bottom or Ascending, Descending depending on the flag type, will sort as the settings suggest, but in relation to the prior flags.  
Since the final sort is by sideop index (the number on the left of the entry in the sideop list) you can use that to see where the list sections from one sorted flag type to the next.  


1: Show Active = Hide, Show  
- Default is Show. Sideops that are Active are the ones actually currently in play and start when you arrive in the sideop area. Independent of Cleared. You normally wouldn't set this setting to Hide.  

2: Show Activable = Hide, Show  
- Only shows those sideops in the selection for being Activated (which includes Active). Usually the best setting to show what sideops are being considered depending on all the underlying conditions and IH settings.  

3: Show Uncleared = Hide, Show  

4: Show Cleared = Hide, Show  
- Default is Show. Quests that have been completed.  

5: Show Open = Hide, Show  
- Will try and show all Open sideops, which is usually every sideop as soon as they are introduced through game progression. Most likely to hit the UI limit entries when a lot of addon sideops are installed.  

6: Sort Active = None, Top, Bottom  

7: Sort Activable = None, Top, Bottom  

8: Sort Uncleared = None, Top, Bottom  

9: Sort Cleared = None, Top, Bottom  

10: Sort Open = None, Top, Bottom  

11: Sort by Location = None, Ascending, Descending  

12: Sort by sideop area = None, Ascending, Descending  
- Each main location of the game (Afgh, Africa) is sectioned into about 8 sideops areas to stop overlap and manage loading. You can look at the sideop index to clarify where the list goes from one area to the next (the numbers within an area will be increasing, then be lower for the first sideop in another area). You may want to use in combination with Sort by Location.  

13: Sort by Category = None, Ascending, Descending  
- The base game sideops are more or less ordered by category already, however addon sideops are added to the end, this sorts by a similar order but puts Story sideops first.  

# 

### Side ops in missions menu
- Change settings related to side ops in story missions.

1: Enable side ops in missions = Off, On  
- Enable side ops in missions using a hand-picked selection of side ops in specific story missions.  

2: Force use all side ops in missions = Off, On  
- WARNING: The side ops enabled with this option can cause instability or simply won't be clearable. Enables all side ops to be included in all story missions when using the 'Enable side ops in missions' setting.  

# 

### Soldier parameters menu

1: Enable soldier parameter settings = Off, On  
- Turn this on to enable the life, sight and hearing enemy param options, turn this off if you have another mod that modifies Soldier2ParameterTables.lua (ie Hardcore mod).",
      "Any of the following option only apply on map load or checkpoint restart.  

2: Soldier life scale = 0-900%  
- 0% will kill off all enemies  

3: Soldier sight scale = 0-400%  
- A rough scale over all the soldier sight distances, except for night sight distance, use the command 'Print sight param table (look in iDroid Log>All tab)' to see exact values.  

4: Soldier night sight scale = 0-400%  

5: Soldier hearing distance scale = 0-400%  

6: Soldier item drop chance = 0-100%  
- Chance soldier will drop an item when eliminated.  

7: Print health param table (look in iDroid Log>All tab) >>   

8: Print sight param table (look in iDroid Log>All tab) >>   

9: Print hearing distance table (look in iDroid Log>All tab) >>   

# 

### Support heli menu

1: Disable support heli attack <> Off, On  
- Stops support heli from engaging targets.  

2: Set heli invincible <> Off, On  

3: Force searchlight <> Default, Off, On  

4: Disable pull-out <> Off, On  
- Prevents heli from leaving when you jump on-board, so you can use the gun from a stationary position, or just change your mind and jump out again. Press [STANCE] while in the heli to get it to pull-out again (or use menu). NOTE: Disable pull-out will prevent the mother base helitaxi selection menu, press [STANCE] to re-enable or use the mod menu.  

5: Set LZ wait height <> 5-50  
- Set the height at which the heli hovers in wait mode (not landing mode).  

6: Mission start time till open door = 0-120  
- Time from mission start to you opening the door to sit on the side. You can set this lower or 0 to do it immediately, or longer to ride the heli in first person. Press [STANCE] to manually open the door.  

7: Disable landing zones = Off, Assault, Regular  
- Disables Assault Landing Zones (those usually in the center of a base that the support heli will circle before landing), or all LZs but Assault LZs  

8: Start free roam on foot = Off, All but assault LZs, All LZs  

9: Start missions on foot = Off, All but assault LZs, All LZs  

10: Start Mother base on foot = Off, All but assault LZs, All LZs  

# 

### Time scale menu

1: Toggle TSM >>   
- Lets you manually toggle Time scale mode that's usually used for Reflex/CQC.  

2: TSM length (seconds) = 0-1000  
- The time in seconds of the TSM  

3: TSM world time scale = 0-100  
- Time scale of the world, including soldiers/vehicles during TSM  

4: TSM player time scale = 0-100  
- Time scale of the player during TSM  

5: No screen effect = Off, On  
- Does not apply the dust and blur effect while TSM is active.  

6: Clock time scale <> 1-10000  
- Changes the time scale of the day/night/weather system. Does not change the speed of soldiers like the cigar does. Lower for closer to real time, higher for faster.  

7: Set clock time <> 0-23  

# 

### Weather menu

1: Force weather <> NONE, SUNNY, CLOUDY, RAINY, SANDSTORM, FOGGY  

2: Fog density <> 0-1  

3: Fog type <> NORMAL, PARASITE, EERIE  

4: RequestTag >! default, indoor, indoor_noSkySpe, indoor_noSkySpe_RLR, indoor_RLR, indoor_RLR_paz, fort_shadow_inside, foggy_20, qntnFacility, pitchDark, avatar_space, sortie_space, sortie_space_ShadowShort, sortie_space_heli, citadel_indoor, soviet_hanger, soviet_hanger2, Sahelan_fog, Sahelan_RedFog, factory_fog, factory_fog_indoor, VolginRide, mafr_forest, uq0040_p31_030020, heli_space, tunnel, diamond_tunnel, fort_shadow_outside, ruins_shadow, slopedTown_shadow, shadow_middle, shadow_long, citadel_color_shadowMiddle, citadel_color_shadowLong, temp_CaptureLongShadow, citadel_redDoor, factory_Volgin_shadow_middle, factory_Volgin_shadow_long, bridge_shadow, cypr_day, cypr_title, kypr_indoor, group_photo, edit, probe_check, exposureAdd_1, citadel_color, exposureSub_1, bloomAdd_1, cypr_Night_RLR, cypr_Night_RLR2, edit_1, citadel_color2, edit_2, kypr_drizzle  
- A collection of sky, lighting settings bundled under a 'tag' name in the locations weatherParameters file. Only applies when you press activate (not persitant over sessions). Game may reset or change it at different points.  

5: RequestTag interp time = 0-100  
- Interpolation time between the prior tag and the one requested.  

6: Apply Sky Parameters >>   

7: Unapply Sky Parameters >>   
- Stops the IH sky parameters from being applied.  

8: Upper clouds scale <> 0-100  
- Scale of main clouds overhead  

9: Horizon clouds height <> -1000-1000  
- Height of horizon clouds  

10: Horizon clouds speed <> -100000-100000  
- Scrolling speed of horizon clouds  

# 

### In-mission menu

2: Support heli to marker >]   
- Sends Support heli to Landing Zone closest to the last placed user marker while riding it.  

3: Force exit helicopter >]   
- Lets you exit the helicopter while riding it, mind the fall.  

4: Drop current equip >>   

5: Warp [Mode] <> Off, On  
- Essentially no-clip mode (for those that remember what that means). It teleports your player a small distance each update of which warp direction button you press or hold. Will move you through walls/geometry. The menu navigation/dpad/arrow keys will warp you in that direction, [STANCE] will warp you down and [CALL] will warp you up.  

6: Warp to latest marker >>   

7: General Help >>   
- General Help:  
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
  

8: [IH system menu](#ih-system-menu) >   

9: [Appearance menu](#appearance-menu) >   

10: [Buddy menu](#buddy-menu) >   

11: [Cam - AroundCam - FreeCam - menu](#cam---aroundcam---freecam---menu) >   

12: [Cam - PlayCam menu](#cam---playcam-menu) >   

13: [Cam - Player FOV hook menu](#cam---player-fov-hook-menu) >   

14: [Debug stuff menu](#debug-stuff-menu) >   

15: [Enemy phases menu](#enemy-phases-menu) >   

16: [Fulton success menu](#fulton-success-menu) >   

17: [MB Ocean menu](#mb-ocean-menu) >   

18: [Markers menu](#markers-menu) >   

19: [Misc menu](#misc-menu) >   

20: [Motions menu](#motions-menu) >   

21: [Object lists menu](#object-lists-menu) >   

22: [Player restrictions menu](#player-restrictions-menu) >   

23: [RouteSet menu](#routeset-menu) >   

24: [Soldier parameters menu](#soldier-parameters-menu) >   

25: [Staff menu](#staff-menu) >   

26: [Support heli menu](#support-heli-menu) >   

27: [Time scale menu](#time-scale-menu) >   

28: [Weather menu](#weather-menu) >   

30: [reloadTableMenu](#reloadtablemenu) >   

# 

  
### IH system menu
- See IH system menu while in ACC for full options.

1: Enable IHExt <> Not installed, Not installed  
- IHExt is a windows program that acts as an gui overlay if MGSV is running in Windowed Borderless.  

2: Enable help text <> Off, On  
- Shows help text for some options.  

3: Give IHExt focus >>   

4: Enable mouse cursor on menu open = Off, On  
- Automatically enable mouse cursor when IHMenu opens. The cursor can also be seperately toggled with F2  

5: Disable hold menu toggle = Off, On  
- Disables the legacy hold [EVADE] to open menu, the two button menu combo [ZOOM_CHANGE] + [DASH] will still work.  

6: UI Style Editor >>  (Requires IHHook)  
- Toggles the IMGui Style Editor to load, change and save the style for IHHook IMGUI.  

7: Enable Quick Menu = Off, On  
- Shortcut key combinations to activate IH features. See Infinite Heaven readme or InfQuickMenuDefs.lua in mod folder.  

# 

  
### Appearance menu

1: Player type <> SNAKE, AVATAR, DD_MALE, DD_FEMALE, OCELOT, QUIET  
- Change main player type. WARNING: Ocelot and Quiet player types have side effect when used due to trying to work around them being restricted to FOB. The Pause menu will be disabled and the game may hit an infinite load if you complete a mission while they are used. Use nexusmods.com/metalgearsolidvtpp/mods/518 by BobDoleOwndU to fix sound issues with using these player types.  

2: Suit type <> NORMAL, NORMAL_SCARF, NAKED, SNEAKING_SUIT_TPP, SNEAKING_SUIT, SNEAKING_SUIT_BB, BATTLEDRESS, PARASITE, LEATHER, SWIMWEAR, SWIMWEAR_G, SWIMWEAR_H, RAIDEN, HOSPITAL, MGS1, NINJA, GOLD, SILVER, MGS3, MGS3_NAKED, MGS3_SNEAKING, MGS3_TUXEDO, EVA_CLOSE, EVA_OPEN, BOSS_CLOSE, BOSS_OPEN, OCELOT, QUIET  

3: Camo type <>   

4: Headgear <> 0-100  

5: Filter faces = Show all, Headgear (cosmetic), Unique, Head fova addons  

6: Face <> 0-0  

7: Skip developed checks = Off, On  
- Allows items that haven't been developed to be selected.  

8: Load avatar >! <list of \mod\avatars>  
- Load avatar from MGS_TPP\mod\avatars  

9: Save avatar >! New,<list of \mod\avatars>  
- Save avatar to MGS_TPP\mod\avatars  

10: Print face info >>   

11: Print appearance info >>   

12: [Form Variation menu](#form-variation-menu) >   

# 

  
### Form Variation menu
- Form Variation support for player models (requires model swap to support it), the fova system is how the game shows and hides sub-models.

1: Use selected fova <> Off, On  

2: fovaSelection <> 0-255  

3: Print current body info >>   

# 

  
### Buddy menu

1: Buddy Equipment >! <Equipment for current buddy>  
- Buddy equiment is changed to selected setting when [ACTION] is pressed.  

2: Quiet move to last marker >]   
- Sets a position similar to the Quiet attack positions, but can be nearly anywhere. Quiet will still abort from that position if it's too close to enemies.  

3: Quiets MB radio track <> [Autoplay], Heavens Divide, Koi no Yokushiryoku, Gloria, Kids In America, Rebel Yell, The Final Countdown, Nitrogen, Take On Me, Ride A White Horse, Maneater, A Phantom Pain, Only Time Will Tell, Behind the Drapery, Love Will Tear Us Apart, All the Sun Touches, TRUE, Take The DW, Friday Im In Love, Midnight Mirage, Dancing With Tears In My Eyes, The Tangerine, Planet Scape, How 'bout them zombies ey, Snake Eater, 204863, You Spin Me Round, Quiet Life, She Blinded Me With Science, Dormant Stream, Too Shy, Peace Walker  
- Changes the music track of the radio played in Quiets cell on the medical platform in mother base.  

# 

  
### Cam - AroundCam - FreeCam - menu

1: Adjust-cam [Mode] <> Off, On  
- Turning this on sets AroundCam mode to Free cam, and lets you use keys/buttons to adjust the options.
  Move cam with normal move keys   
  
  [DASH] (Shift or Left stick click) to move up  
  [SWITCH_ZOOM](Middle mouse or Right stick click) to move down  
  
  Hold the following and move left stick up/down to increase/decrease the settings:  
  
  [FIRE] - Zoom/focal length   
  [RELOAD] - Aperture (DOF)  
  [STANCE] - Focus distance (DOF)   
  [ACTION] - Cam move speed  
  [AIM] - Camera orbit distance  
  
  Or hold [BINOCULARS] and press the above to reset that setting.  
  
  Hold [BINOCULARS] and press [DASH] to move free cam position to the player position  

2: AroundCam mode <> Off, Free cam  
- Lets you turn on freecam, if Adjust-cam mode is off   

3: Reset camera position to player >>   

4: Warp body to FreeCam position >>   

5: Update stage position with camera <> Off, On  
- Sets the map loading position to the free cam position as it moves. Warning: As the LOD changes away from player position your player may fall through the terrain.  

6: positionXFreeCam <> -100000-100000  

7: positionYFreeCam <> -100000-100000  

8: positionZFreeCam <> -100000-100000  

9: Cam move speed scale = 0.01-10  
- Movement speed scale when in Adjust-cam mode  

10: focalLengthFreeCam <> 0.1-10000  

11: focusDistanceFreeCam <> 0.01-1000  

12: apertureFreeCam <> 0.001-100  

13: distanceFreeCam <> 0-100  

14: targetInterpTimeFreeCam <> 0-100  

15: rotationLimitMinXFreeCam <> -90-0  

16: rotationLimitMaxXFreeCam <> 0-90  

17: alphaDistanceFreeCam <> 0-10  

18: Disable Adjust-cam text = Off, On  
- Disables Adjust-cams repeating announce log of the current 'hold button to adjust' settings.  

19: Show freecam position >>   

# 

  
### Cam - PlayCam menu
- An alternate camera than the one used by freecam. WARNING: is sometimes unstable and may crash the game.

1: Start PlayCam >>   
- Starts PlayCam with current settings. Changing any setting also automatically starts the PlayCam.  

2: Stop PlayCam >>   

3: Camera target <> Player  
- Selects game object for camerat to target. You can add more game objects via the Objects menu in the main Mission menu.  

4: Focal length <> 0.1-10000  
- DOF variable  

5: Focus distance <> 0.1-30  
- DOF variable  

6: Apeture <> 0.001-100  
- DOF variable  

7: Follow Position <> Off, On  
- Follows position of Camera target. Overrides Follow Rotation.  

8: Follow Rotation <> Off, On  
- Follows rotation of Camera target.  

9: Target offset X <> -1000-1000  
- Adjusts X axis of camera target  

10: Target offset Y <> -1000-1000  
- Adjusts Y axis of camera target  

11: Target offset Z <> -1000-1000  
- Adjusts Z axis of camera target  

12: Position offset X <> -1000-1000  
- Adjusts X axis of camera position  

13: Position offset Y <> -1000-1000  
- Adjusts Y axis of camera position  

14: Position offset Z <> -1000-1000  
- Adjusts Z axis of camera position  

15: Follow time <> 0-10000  
- Time in seconds before camera follow turns off. See Follow Position and Follow Rotation.  

16: Follow delay time <> 0-1  
- Delay before camera follows. Acts more like interpolation time than one-off. See Follow Position and Follow Rotation.  

17: Time till end <> 0-10000  
- Time in seconds before PlayCam turns off. Set to high number if you don't want it to end.  

18: Fit on camera <> Off, On  
- Unknown  

19: Fit start time <> 0-1000  
- For Fit on camera.  

20: Fit interp time <> 0-5  
- Interpolation time for Fit on camera.  

21: Fit diff focal length <> 0-100  
- Fit diff focal length  

22: Call Se of Camera Interp <> Off, On  
- Unknown  

23: Use last selected index <> Off, On  
- Unknown  

24: Collision check <> Off, On  
- Checks between camera and target and moves camera in if there is something in the way.  

# 

  
### Cam - Player FOV hook menu
- Uses IHHook to adjust the player camera focal length.
 Same method as the FOV mod d3d11.dll

1: Enable Player Cam hook <> Off, On (Requires IHHook)  

2: FocalLength Normal <> 0.01-3500 (Requires IHHook)  
- Only updates after changing cam mode.
Focal lengths between modes not equivalent (some other factor being applied)
Lower focal length = wider FOV,
Higher focal length = lower FOV  

3: FocalLength Aiming <> 0.01-3500 (Requires IHHook)  
- Only updates after changing cam mode.
Focal lengths between modes not equivalent (some other factor being applied)
Lower focal length = wider FOV,
Higher focal length = lower FOV  

4: FocalLength Hiding <> 0.01-3500 (Requires IHHook)  
- Only updates after changing cam mode.
Focal lengths between modes not equivalent (some other factor being applied)
Lower focal length = wider FOV,
Higher focal length = lower FOV  

5: FocalLength CQC <> 0.01-3500 (Requires IHHook)  
- Only updates after changing cam mode.
Focal lengths between modes not equivalent (some other factor being applied)
Lower focal length = wider FOV,
Higher focal length = lower FOV  

6: Apply FOV <> 1-179 (Requires IHHook)  
- Applies FOV(degrees) proportionally to the different cam mode focal length options.  

# 

  
### Debug stuff menu

1: Debug IH mode <> Off, On  
- Switches on logging messages to ih_log.txt (at the cost of longer load times) and enables the announce-log during loading.  

2: debugMessages = Off, On  
- Logs game message system, requires Debug IH mode to be on.  

3: debugFlow = Off, On  
- Logs some script execution flow, requires Debug IH mode to be on.  

4: debugOnUpdate <> Off, On  

5: log_SetFlushLevel <> trace, debug, info, warn, error, critical, off (Requires IHHook)  

6: Reload IH modules >]   

7: copyLogToPrev >>   

8: selectedCp = 0-0  

9: setSelectedCpToMarkerObjectCp >>   

10: setSelectedCpToMarkerClosestCp >>   

11: dEBUG_ShowRevengeConfig >>   

12: [appearanceDebugMenu](#appearancedebugmenu) >   

13: printPressedButtons = Off, On  

14: printOnBlockChange = Off, On  

15: Disable game over = Off, On  

16: Disable game over on killing child soldier = Off, On  

17: Disable out of bounds checks <> Off, On  

18: setAllFriendly >>   

19: setAllZombie >>   

20: dEBUG_ToggleParasiteEvent >>   

21: resetStageBlockPosition >>   

22: setStageBlockPositionToMarkerClosest >>   

23: Set stage position to camera >>   
- Sets the map loading position to the free cam position.  

24: Show freecam position >>   

25: Show position >>   

26: checkPointSave >>   

27: manualMissionCode >!   

28: manualSequence >! <seq_sequenceNames>  

29: [Vscode menu](#vscode-menu) >   

30: [debugPrintMenu](#debugprintmenu) >   

31: [debugStuffMenu](#debugstuffmenu) >   

# 

  
### appearanceDebugMenu

1: faceFovaDirect >! 0-1000  

2: faceDecoFovaDirect >! 0-1000  

3: hairFovaDirect >! 0-1000  

4: hairDecoFovaDirect >! 0-1000  

5: playerTypeDirect >! 0-255  

6: playerPartsTypeDirect >! 0-255  

7: playerCamoTypeDirect >! 0-255  

8: playerFaceIdDirect >! 0-730  

9: playerFaceEquipIdDirect >! 0-100  

10: Print face info >>   

11: Print appearance info >>   

12: faceFova = 0-1000  

13: faceDecoFova = 0-1000  

14: hairFova = 0-1000  

15: hairDecoFova = 0-1000  

16: faceFovaUnknown1 >! 0-50  

17: faceFovaUnknown2 >! 0-1  

18: eyeFova >! 0-4  

19: skinFova >! 0-5  

20: faceFovaUnknown5 >! 0-1  

21: uiTextureCount >! 0-3  

22: faceFovaUnknown7 >! 0-303  

23: faceFovaUnknown8 >! 0-303  

24: faceFovaUnknown9 >! 0-303  

25: faceFovaUnknown10 >! 0-3  

26: applyFaceFova >>   

27: applyCurrentFovaFace >>   

28: [Form Variation menu](#form-variation-menu) >   

# 

  
### Vscode menu
- Commands to generate files to support using vscode with a mgsv project.

1: debug_WriteVscodeHintOnTitle = Off, On  
- Runs WriteVscodeHint when loading has reached Title  

2: writeVscodeHint >>   

3: debug_WriteVarsOnSave = Off, On  
- Runs WriteVars on IH save (which includes close IH menu)  

4: writeVars >>   

# 

  
### debugPrintMenu
- Dump various things to log

1: dEBUG_PrintCpPowerSettings >>   

2: dEBUG_PrintPowersCount >>   

3: dEBUG_PrintReinforceVars >>   

4: dEBUG_PrintSoldierDefine >>   

# 

  
### debugStuffMenu

1: selectSpeechSoldier =   
- Selects a soldier from Object list (see Objects menu) as a target for debug_CallVoice, debug_CallConversation  

2: selectSpeechSoldier2 =   

3: debug_CallVoice >!   

4: debug_CallConversation >! MB_story_01, MB_story_02, MB_story_03, MB_story_04, MB_story_05, MB_story_06, MB_story_07, MB_story_08, MB_story_09, MB_story_10, MB_story_11, MB_story_12, MB_story_13, MB_story_14, MB_story_15, MB_story_16, MB_story_17, MB_story_18, MB_story_19  
- Requires a valid selectSpeechSoldier, selectSpeechSoldier2 of a nearby soldier  

# 

  
### Enemy phases menu
- Adjust minimum and maximum alert phase for enemy Command Posts

1: Enable phase modifications <> Off, On  
- The Minimum, Maximum, and Don't downgrade phase settings are applied on at every update tick according to the Phase update rate and random variation settings  

2: Minimum phase <> PHASE_SNEAK, PHASE_CAUTION, PHASE_EVASION, PHASE_ALERT  
- PHASE_SNEAK - not alert, PHASE_CAUTION - alert, PHASE_EVASION - one step down from combat alert, PHASE_ALERT - combat alert  

3: Maximum phase <> PHASE_SNEAK, PHASE_CAUTION, PHASE_EVASION, PHASE_ALERT  
- PHASE_SNEAK - not alert, PHASE_CAUTION - alert, PHASE_EVASION - one step down from combat alert, PHASE_ALERT - combat alert  

4: Don't downgrade phase = Off, On  

5: Phase mod update rate (seconds) = 1-255  
- Rate that the CPs phase is adjusted to the minimum and maxium settings.  

6: Phase mod random variation = 0-255  
- Random variation of update rate  

7: Alert phase on vehicle attack = PHASE_SNEAK, PHASE_CAUTION, PHASE_EVASION, PHASE_ALERT  
- Does not require phase modifications setting to be enabled. The enemy reactions to heavy vehicle attack in the default game are lacking, you can kill someone and they'll act as if it's an unsourced attack. This option changes phase of soldiers command post on damaging the soldier. Setting it to ALERT recommended.  

8: Print phase changes = Off, On  
- Displays when phase changes.  

# 

  
### Fulton success menu
- Adjust the success rate of fultoning

1: Fulton success variation = 0-100  
- Subtracts the purcentage from fulton success in a periodic fashion.  

2: Soldier fulton success variation = 0-100  

3: Fulton variation inv rate = 1-1000  
- Inverse rate (higher slower) of fulton variation cycle  

4: MB fulton support scale = 0-400%  
- Scales the success bonus from mother base support section (which itself scales by section level). In the base game this is mostly used to counter weather penalty.  

5: MB fulton medical scale = 0-400%  
- Scales the success bonus from mother base medical section (which itself scales by section level). In the base game this used to counter injured target penalty  

6: Target dying penalty = 0-100  

7: Target sleeping penalty = 0-100  

8: Target holdup penalty = 0-100  

9: Hostage handling = Default, Must extract (0%)  

10: Print mb fulton success bonus >>   

# 

  
### MB Ocean menu

1: mbEnableOceanSettings <> Off, On  

2: mbSetOceanBaseHeight <> -100-100  

3: mbSetOceanProjectionScale <> 0-2000  

4: mbSetOceanBlendEnd <> 0-2000  

5: mbSetOceanFarProjectionAmplitude <> -100-100  

6: mbSetOceanSpecularIntensity <> -30-30  

7: mbSetOceanDisplacementStrength <> 0-10  

8: mbSetOceanWaveAmplitude <> 0-10  

9: mbSetOceanWindDirectionP1 <> -10-10  

10: mbSetOceanWindDirectionP2 <> -10-10  

# 

  
### Markers menu

1: Disable head markers <> Off, On  
- Disables markers above soldiers and objects  

2: Disable world markers <> Off, On  
- Disables objective and placed markers  

# 

  
### Misc menu

1: Soldier item drop chance = 0-100%  
- Chance soldier will drop an item when eliminated.  

2: Player life scale <> 0-650%  

# 

  
### Motions menu
- Play different animations on player. A motion group may contain several related animations (usually lead-in, idle, lead-out)

1: Motion group >! NONE  
- Press [ACTION] to play the selected animation.  

2: Motion number >! NONE  
- Press [ACTION] to play the selected animation.  

3: Hold motion = Off, On  
- Holds motion, requires stop motion to stop.  

4: Repeat motion = Off, On  
- Repeat motion at end, some animations don't support this.  

5: Close menu on Playing motion <> Off, On  

6: Print motion name on play = Off, On  

7: Warp to original position after play = Off, On  
- Since some animations move player position through geometry this may help to recover  

8: Stop motion >>   
- Use to stop motions with motion hold or motion repeat.  

9: Play motion >>   
- Closes menu and plays current selected motion.  

# 

  
### Object lists menu

1: warpToListPosition >! 0-0  

2: warpToListObject >! 0-0  

3: setCamToListObject >! 0-0  

4: [Objects menu](#objects-menu) >   

5: [Positions menu](#positions-menu) >   

6: [Routes menu](#routes-menu) >   

7: [User marker menu](#user-marker-menu) >   

# 

  
### Objects menu
- For adding game object names in the game to a Objects List, and writing/loading them to files.

1: Add marked objects to list >>   
- Adds current marked game object names to objects list, objects list can be written to file with Write Objects List command.  

2: Add lookup list >! <lookup list names>  
- Lets you cycle through a number of lookup lists IH uses and add all items from it to the main object list.  

3: Clear Objects List >>   
- Clears Objects List  

4: Write Objects List >>   
- Writes Objects List to file in MGS_TPP\mod\  

5: Load Objects List >>   
- Loads objects list from file in MGS_TPP\mod\  

6: Browse object list = Player  

# 

  
### Positions menu
- For adding positions in the game to a Positions List, and writing/loading them to files.

1: Add current position to Positions List >>   
- Add current player or freecam position to Positions List, positions list can be written to file with Write Positons List command.  

2: Add markers to Positions List >>   
- Adds current user markers to positions list, positions list can be written to file with Write Positons List command.  

3: Clear Positions List >>   
- Clears Positions List  

4: Write Positions List >>   
- Writes Positions List to files in MGS_TPP\mod\  

5: Load positions from file >>   
- Loads positions from MGS_TPP\mod\positions.txt  

6: Select position =   
- Selects a position from positions list, mostly just used to browse positions at the moment.  

# 

  
### Routes menu
- For adding route names in the game to a Routes List, and writing/loading them to files.

1: Clear Routes List >>   
- Clears Routes List  

2: Write Routes List >>   
- Writes Routes List to file in MGS_TPP\mod\  

3: Load Routes List >>   
- Loads routes list from file in MGS_TPP\mod\  

4: setMarkerSneakRoute >!   

# 

  
### User marker menu

1: Warp to latest marker >>   

2: Print latest marker >>   

3: Print all markers >>   

4: Add markers to Positions List >>   
- Adds current user markers to positions list, positions list can be written to file with Write Positons List command.  

5: Write Positions List >>   
- Writes Positions List to files in MGS_TPP\mod\  

6: Clear Positions List >>   
- Clears Positions List  

# 

  
### Player restrictions menu

1: Disable head markers <> Off, On  
- Disables markers above soldiers and objects  

2: Disable world markers <> Off, On  
- Disables objective and placed markers  

3: Game over on combat alert <> Off, On  

4: Disable game over on killing child soldier = Off, On  

5: Disable out of bounds checks <> Off, On  

6: Disable game over = Off, On  

# 

  
### RouteSet menu
- Options to randomize what routes soldiers use in a Command Post.

1: Randomize RouteSets in missions = Off, On  
- Enables all following options. Also randomizes current routeSet on mission load/reload. WARNING: may mess up scripted mission routes.  

2: Randomize RouteSets in free roam = Off, On  
- Enables all following options. Also randomizes current routeSet on mission load/reload. Requires randomize group priority or group routes to be on.  

3: Randomize on shift change = Off, On  
- Randomize current routeSet on morning and night shift changes.  

4: Randomize on phase change = Off, On  
- Randomize current routeSet when enemy phase changes in any way, Sneak, Caution, Alert, Evasion. Up or down.  

5: Randomize group priority = Off, On  
- Each routeSet for a CP has a number of groups of routes, this will change the order the groups are picked from.  

6: Randomize group routes = Off, On  
- Each routeSet for a CP has a number of groups of routes, this will change the order within the group.  

7: Randomize RouteSet now >>   
- Randomize current routeset right now. (Use the command in-mission).  

# 

  
### Soldier parameters menu

1: Enable soldier parameter settings = Off, On  
- Turn this on to enable the life, sight and hearing enemy param options, turn this off if you have another mod that modifies Soldier2ParameterTables.lua (ie Hardcore mod).",
      "Any of the following option only apply on map load or checkpoint restart.  

2: Soldier life scale = 0-900%  
- 0% will kill off all enemies  

3: Soldier sight scale = 0-400%  
- A rough scale over all the soldier sight distances, except for night sight distance, use the command 'Print sight param table (look in iDroid Log>All tab)' to see exact values.  

4: Soldier night sight scale = 0-400%  

5: Soldier hearing distance scale = 0-400%  

6: Soldier item drop chance = 0-100%  
- Chance soldier will drop an item when eliminated.  

7: Print health param table (look in iDroid Log>All tab) >>   

8: Print sight param table (look in iDroid Log>All tab) >>   

9: Print hearing distance table (look in iDroid Log>All tab) >>   

# 

  
### Staff menu

1: Add player staff to MB priority >>   
- Add the last sortie selected DD member to the Mother Base priority staff list to have them appear on MB  

2: Remove player staff to MB priority >>   
- Removes the last sortie selected DD member to the Mother Base priority staff list  

3: Add marked staff to MB priority >>   
- Adds the most recently marked staff member to the MB priority list  

4: Remove marked staff from MB priority >>   
- Removes the most recently marked staff member from the MB priority list  

5: Clear MB staff priority list >>   
- Clears MB staff priority list entirely  

# 

  
### Support heli menu

1: Disable support heli attack <> Off, On  
- Stops support heli from engaging targets.  

2: Set heli invincible <> Off, On  

3: Force searchlight <> Default, Off, On  

4: Disable pull-out <> Off, On  
- Prevents heli from leaving when you jump on-board, so you can use the gun from a stationary position, or just change your mind and jump out again. Press [STANCE] while in the heli to get it to pull-out again (or use menu). NOTE: Disable pull-out will prevent the mother base helitaxi selection menu, press [STANCE] to re-enable or use the mod menu.  

5: Set LZ wait height <> 5-50  
- Set the height at which the heli hovers in wait mode (not landing mode).  

6: Mission start time till open door = 0-120  
- Time from mission start to you opening the door to sit on the side. You can set this lower or 0 to do it immediately, or longer to ride the heli in first person. Press [STANCE] to manually open the door.  

7: Disable landing zones = Off, Assault, Regular  
- Disables Assault Landing Zones (those usually in the center of a base that the support heli will circle before landing), or all LZs but Assault LZs  

8: Start free roam on foot = Off, All but assault LZs, All LZs  

9: Start missions on foot = Off, All but assault LZs, All LZs  

10: Start Mother base on foot = Off, All but assault LZs, All LZs  

# 

  
### Time scale menu

1: Toggle TSM >>   
- Lets you manually toggle Time scale mode that's usually used for Reflex/CQC.  

2: TSM length (seconds) = 0-1000  
- The time in seconds of the TSM  

3: TSM world time scale = 0-100  
- Time scale of the world, including soldiers/vehicles during TSM  

4: TSM player time scale = 0-100  
- Time scale of the player during TSM  

5: No screen effect = Off, On  
- Does not apply the dust and blur effect while TSM is active.  

6: Clock time scale <> 1-10000  
- Changes the time scale of the day/night/weather system. Does not change the speed of soldiers like the cigar does. Lower for closer to real time, higher for faster.  

7: Set clock time <> 0-23  

# 

  
### Weather menu

1: Force weather <> NONE, SUNNY, CLOUDY, RAINY, SANDSTORM, FOGGY  

2: Fog density <> 0-1  

3: Fog type <> NORMAL, PARASITE, EERIE  

4: RequestTag >! default, indoor, indoor_noSkySpe, indoor_noSkySpe_RLR, indoor_RLR, indoor_RLR_paz, fort_shadow_inside, foggy_20, qntnFacility, pitchDark, avatar_space, sortie_space, sortie_space_ShadowShort, sortie_space_heli, citadel_indoor, soviet_hanger, soviet_hanger2, Sahelan_fog, Sahelan_RedFog, factory_fog, factory_fog_indoor, VolginRide, mafr_forest, uq0040_p31_030020, heli_space, tunnel, diamond_tunnel, fort_shadow_outside, ruins_shadow, slopedTown_shadow, shadow_middle, shadow_long, citadel_color_shadowMiddle, citadel_color_shadowLong, temp_CaptureLongShadow, citadel_redDoor, factory_Volgin_shadow_middle, factory_Volgin_shadow_long, bridge_shadow, cypr_day, cypr_title, kypr_indoor, group_photo, edit, probe_check, exposureAdd_1, citadel_color, exposureSub_1, bloomAdd_1, cypr_Night_RLR, cypr_Night_RLR2, edit_1, citadel_color2, edit_2, kypr_drizzle  
- A collection of sky, lighting settings bundled under a 'tag' name in the locations weatherParameters file. Only applies when you press activate (not persitant over sessions). Game may reset or change it at different points.  

5: RequestTag interp time = 0-100  
- Interpolation time between the prior tag and the one requested.  

6: Apply Sky Parameters >>   

7: Unapply Sky Parameters >>   
- Stops the IH sky parameters from being applied.  

8: Upper clouds scale <> 0-100  
- Scale of main clouds overhead  

9: Horizon clouds height <> -1000-1000  
- Height of horizon clouds  

10: Horizon clouds speed <> -100000-100000  
- Scrolling speed of horizon clouds  

# 

  
### reloadTableMenu

# 

  