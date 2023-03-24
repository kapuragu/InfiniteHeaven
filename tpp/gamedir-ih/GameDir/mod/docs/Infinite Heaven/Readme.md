# Infinite heaven
r261 - 2023-03-24  
by tin man tex  
For MGSV version 1.15 (in title screen), 1.0.15.3 in exe  
Compatible IHHook version: r17 or later  

A mod for Metal Gear Solid V: The Phantom Pain intended to extend gameplay through customizable settings and features, as well as providing addon systems to support other mods.

Addon systems include allowing custom sidops, missions, enemy soldier types.

Has several hundred toggleable options ranging from Subsistence mode for all missions, replay side-ops, Mother base invasions with multiple attack helicopters, Skull attacks in Free roam, Free-cam, skip heli rides, customization of enemy and mother base gear, foot, heavy vehicle and heli patrols in free roam, and much more.

It is highly recommended to use IHHook, which is a script extender and graphical menu that has mouse and keyboard support, alongside IH.  
[IHHook on NexusMods](https://www.nexusmods.com/metalgearsolidvtpp/mods/1226)

All IH documents can be found in MGS_TPP\mod\docs\Infinite Heaven\ (once installed), or the  
[Infinite Heaven GitHub repo](https://github.com/TinManTex/InfiniteHeaven/tree/master/tpp-release/gamedir-ih/GameDir/mod/docs/Infinite%20Heaven)  

See the youtube channel for demonstrations of many features:  
[ youtube.com/@TinManSquad ](https://www.youtube.com/@TinManSquad)

For description of all see  
['Features and Options.md'](https://github.com/TinManTex/InfiniteHeaven/blob/master/tpp-release/gamedir-ih/GameDir/mod/docs/Infinite%20Heaven/Change%20Log.md)

## Recent changes/additions:
For older updates see  
['Change Log.md'](https://github.com/TinManTex/InfiniteHeaven/blob/master/tpp-release/gamedir-ih/GameDir/mod/docs/Infinite%20Heaven/Change%20Log.md)

### r261 - 2023-03-24  
---------------------
'Warp to latest marker' now works when driving vehicle or walker gear.  
[youtube]FVc0bw9ooFs[/youtube]  
https://youtu.be/FVc0bw9ooFs  

Fix: disableHerbSearch possibly not working correctly.  

Fix: Randomize RouteSets being called despite individual options being off (though not if main setting was off).  
thanks caplag for a related report.  

Fix: "Custom soldier type in Free/Mission" resetting to off after game is next restarted. Was broken as of r247 - thanks Spectral for the report and troubleshooting files. 

Fix: enemy soldier type addons with multiple bodies not working, was broken as of r258 - thanks Spectral for the report.  

Fix: Some cases of Player Cam hook (FOV) not applying.  

Fix: InfSoldierFaceAndBody not retaining its data on script reload. Affected Apearance menu > Face option when Filter set to Head fova addons.  

Fix: Back in the dark ages I changed mvars.ene_soldierIDList itself from its original [cpId][soldierId]=cpDefine index to [cpId][soldierId]=soldierName as the value didnt seem to be used anywhere, and I wanted a lookup. Didn't really end up using it much, it was better to just iterate soldierDefine again, so its been reverted.  
(and API/dev warning I guess if anyone was using it as its modified form in their scripts)

Fix: TppRevenge.SetEnableSoldierLocatorList (actually broken out by IH from _ApplyRevengeToCp) not applying in MB. Don't think it affected anything since it failed in a way that it was still applying revenge for all soliders in a cluster, just that it was applying multiple times (with exact same values).  
See the NOTE: in SetEnableSoldierLocatorList for my puzzlement about it.  

Fix: Custom DD female type no longer dependant on Custom DD (male) type being set. Either of them will default to normal DD mb body if setting is OFF.  

Motherbase menu > 'DD Suit', 'DD Suit female' renamed 'Custom DD type in MB' in line with 'Custom Soldier type in mission/free'.  
The underlying Ivars already were named customSoldierTypeMB_ALL, so you shouln't have to re-set the setting.  

AroundCam (FreeCam):  
When AroundCam on, but with Adjust-mode off, changing settings via will now update AroundCam.  

Fix: FreeCam hang if on when Abort mission.  

API: addon missionInfo (See notes in InfMission)  
clearExistingMissionStartSettings - only for use when overriding a vanilla mission, clears all the mission start data so the following options you set can work cleanly  
noBoxMissionHeliRoute / NO_ORDER_FIX_HELICOPTER_ROUTE support, requires isNoOrderBoxMission to be set

clearMissionStartHeliRoute is to give actual support for NO_HELICOPTER_ROUTE_MISSION_LIST, before it was just riding on the assumption that if the addon author gave a startPos they wouldn't have heli routes/starts set up, this gives the same support as the base game for those missions.  

isNoOrderBoxMission, likewise giving explicit setting for NO_ORDER_BOX_MISSION

- thanks caplag for the suggestions

API: LoadExternalModule: Don't reload module if prevModule and not isReload.  
This was causing the early InfInit LoadExternalModuled modules Ivars,IvarsPersist and InfSoldierFaceAndBody to be reloaded.  
In the case of InfSoldierFaceAndBody it would loose all its data since those functions were called manually rather than PostAllModulesLoad.  

API: InfUserMarker.GetMarkerPosition return type changed from Vector3 to {x,y,z} as it's more commonly used through other IH functions.  

### r260 - 2023-03-10  
---------------------
Fix: quest adding their missionPacks in helispace - thanks CapLag for an unrelated report that made me test something related.  

Fix: Repop of sideop 144 tent_q99040 "Secure the Remains of the Man on Fire" arival on quarantine platform leaving player stuck in helipad.  

Fix: Infinite load screen when IH startOnFoot used when force go to mb on quest clear > demo play. Another case of the prior fix in r259 for start on foot, which Repop of sideop 144 is also a case of. 

Fix: Several bugs setting quest flags incorrectly. Could result in some of the hidden/managed quests activating or not.  
Could also cause the all sideops disabled bug.  
A manual fix is to run "Reroll sideops selection" with "Repop mode" set to Allways.  

Ancillary ih saves (addon mission and quest states) are now cleared on new game.  

InfQuest / IH Sideops menu:  
[youtube]2UUXDfMfrso[/youtube]  
https://youtu.be/2UUXDfMfrso  

Renamed unlockSideOpNumber to quest_forceQuestNumber, just an internal name change to be more consistant and accurate. Though you will have to set the setting again.  

Renamed ihSideopsPercentageCount to quest_addonsCountForCompletion, just an internal name change to be more consistant and accurate. Though you will have to set the setting again.  

quest_updateRepopMode="Repop mode": "On none left"|"Allways"
Lets you choose the behaviour of how repeatable sideops are refreshed. 
The update is run for the sideop area of a quest you just finished, 
or for all areas when changing many of the IH sideops options or rerolling sideops. 
The default behaviour 'On none left' will only repopulate sideops when there are no other uncompleted sideops, and all other repeatable sideops have been completed. 
'Allways' will refresh repeatable quests every time the update is called.  

quest_setIsOnceToRepop="Repop one-time sideops"
"Lets you force story and one-time sideops to be replayable."
Replaces "Unlock Sideops mode".  

quest_selectForArea="Selection for Area mode"
Renamed from sideOpsSelectionMode
Categories removed, use the Sideops category filter menu instead. 
'Random Addon' setting added to prioritize Addon sideops.  
Sideops are broken into areas to stop overlap, this setting lets you control the choice which repop sideop will be selected to be Active for the area.  
'Random Addon' will prioritize Addon sideops first.  
All selection is still prioritized by uncompleted story sideops, then other uncompleted sideops, then repop sideops selected by this option.  

"Show on UI menu"  
Replaces "Show all open sideops"  
Settings for what sideops to show and how they should be sorted depedending on various parameters for sideops on the idroid sideops list.  
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

quest_uiShow_Active="Active" - "Default is Show. Sideops that are Active are the ones actually currently in play and start when you arrive in the sideop area. Independent of Cleared. You normally wouldn't set this setting to Hide."
quest_uiShow_Cleared="Cleared" - "Default is Show. Quests that have been completed."
quest_uiShow_Uncleared="Uncleared" - "Quests that have not been completed."
quest_uiShow_Activable="Activable" - Only shows those sideops in the selection for being Activated (which includes Active). Usually the best setting to show what sideops are being considered depending on all the underlying conditions and IH settings."
quest_uiShow_Open="Open" - "Will try and show all Open sideops, which is usually every sideop as soon as they are introduced through game progression. Most likely to hit the UI limit entries when a lot of addon sideops are installed."

quest_uiSort_Active="Sort Active" - Top|Bottom
quest_uiSort_Cleared="Sort Cleared" - Top|Bottom
quest_uiSort_Uncleared="Sort Uncleared" - Top|Bottom
quest_uiSort_Activable="Sort Activable" - Top|Bottom
quest_uiSort_Open="Sort Open" - Top|Bottom
quest_uiSort_category="Sort by Category" - Ascending|Descending - "The base game sideops are more or less ordered by category already, however addon sideops are added to the end, this sorts by a similar order but puts Story sideops first."
quest_uiSort_locationId="Sort by Location" - Ascending|Descending -
quest_uiSort_questArea="Sort by sideop area" - Ascending|Descending -"Each main location of the game (Afgh, Africa) is sectioned into about 8 sideops areas to stop overlap and manage loading. You can look at the sideop index to clarify where the list goes from one area to the next (the numbers within an area will be increasing, then be lower for the first sideop in another area). You may want to use in combination with Sort by Location."

Sideops selection menu:  
ivars renamed from sideop_<CATEGORY> to quest_category_<CATEGORY>
Settings changed from OFF, ON to "ALL","NONE","ADDON_ONLY"
This lets you have per catergory selection of only Addon sidops.  

Quest Addon questInfo: 
Added canActiveQuest=function(questName) --Optional. All quests repop by default (are available to repeat), returning false will stop it from being considered for selection. Use this if you need to stop the quest from Active selection after the initial canOpenQuest.  

### r259 - 2023-02-18
---------------------
Fix: InfPositions Loadposistions, thanks cap for fix.  
Fix: ih_mission_states not restoring, thanks cap for report.  
Fix: Start missions on foot hang on mission end if MB demo triggered. This is an anchient bug that has unfortunately likely been around almost as long as IH itself. Thanks OldBoss for the report and save files.  
Fix: profiles breaking due to help strings with newlines. thanks EntranceJew for the report.  
InfLookup: A lot of Message signatures, and general message logging rework from EntranceJew
Debugging: Bunch of flow logging to get a better understanding of infinite loading screen, though the answer there is most often just 'the exe is loading stuff and it didn't like something aboout one of the data files'
Fix: InfWeather losing addon weather info on script reload, thanks EntranceJew for the report.  
Fix: appearanceDebugMenu fova ivars fix. They still don't do anything, but they were breaking the menu. And due to the exe crash issue after applying several times it's still of limited use. Thanks retali8 for the report.  
Fix: 'Warp to last user marker' and Warp body to FreeCam position remove announcelog spam that queues when warping - Thanks SinovialVermin8 for the report
Fix: 'Support heli to marker' failing with '#coords.pos~=3' warning. Seems feature was broken as of last version - thanks Dr Solus for the report.  

InfMotion|Motions menu > motionWarpToOrig|"Warp to original position after play". Since some animations move player position through geometry this may help to recover - thanks caplag for implementation.  

Mission Addons: various features that were limited to vanilla freeroam now work in addons.  

IH Saves: ih_mission_states, ih_quest_states, ih_priority_staff now only save if the related features are used. So possibly slight better performance when saving.  
Existing files will still hang around even if they have no meaningful data in them though.  
Are also now checked to see if they exist first before loading them, so no potentially confusing error message it used to log when trying to load them reguardless.  

InfAutoDoc:  
Features and Options docs using same option type indicator as menus. Commands no longer show a 0-1 range.  

Debugging and dev stuff:  
ivars GettSettingText calls wrapped in PCallDebug, and log a warning to make it easier to track down broken functions (and not have them break the menu).  

Some loading logging, probably won't catch much since most load hangs will be inside exe and lua will just be waiting for TppMission.CanStart which will never come.  

InfCore.PCall correct multi returns - thanks EntranceJew for the method.  

PCall and LoadExternalModule announceLogs errors.  

Disclaimer:
------------------------------
Use the mod at you own risk (which can be mitigated by backing up saves and files replaced by mod)  
Often options may have limited testing, so detailed feedback at Nexus page welcome.

Installation
------------------------------
See ['Installation.md'](https://github.com/TinManTex/InfiniteHeaven/blob/master/tpp-release/gamedir-ih/GameDir/mod/docs/Infinite%20Heaven/Installation.md)

Troubleshooting
------------------------------
See ['Troubleshooting.md'](https://github.com/TinManTex/InfiniteHeaven/blob/master/tpp-release/gamedir-ih/GameDir/mod/docs/Infinite%20Heaven/Troubleshooting.md)

Usage:
------------------------------
Opening the Infinite Heaven menu:
While in ACC Heli (Safe-space menu), or in-mission (In-mission menu)
Press and hold [Switch Zoom] (V key or RStick click) then press [Dash] (shift key or LStick click) to toggle the mod menu when in the ACC or in-mission.

Or hold [Evade] (Space key or X button)
This can be disabled (via IH system menu > Disable hold menu toggle) if it interferes with your play, the above key combo will still work.

Also, if IHHook is installed, press F3 key.

Using the menu:
If you do not have IHHook installed, or IHExt enabled, Infinite Heaven menu will use the Announce Log on the lower left, which is very limited due to its update rate.
While the menu it will repeatedly show just the current menu option.

Description of menu items:  
`[#]: [Option name] [Effect/ item type symbol] [Setting value or description] `  
Example:  
`4: Mobility level = 2:Grade 2`

Effect symbols:  
`<>` Applies change or command when setting is selected/cycled to  
`>>` Applies change or command when pressing [Action]

Menu item type symbols:  
`>`  Sub-menu  
`>>` Command  
`>]` Command that closes menu when done

Some settings apply when selected or just set the value when the a feature is triggered by another command or during mission load.

While menu is open:  
Use Arrow keys or Dpad to navigate the menu  
or  
Hold [Switch Zoom] (V key or RStick click) and press movement keys or Left Stick to navigate the menu.

Up/Down to select option.  
Left/Right to change setting or open sub menu.

The size/step of the setting change can be made bigger/smaller by holding [Ready weapon] or [Fire]. 

Press [Binoculars] button to reset current setting.

Press [Reload] button to set the current setting to it's minimum.
Press [Change Stance] button to go to previous menu.

By design I try to keep the initial install to all regular game settings and only changed via infinite heavens in-game mod menu.  
All settings are reset to off on doing a FOB mission. But I suggest you play offline while the mod is installed. Snakebite mod manager allows easy toggling of mods.

Quick Menu:  
A way to quickly trigger certain Infinite Heaven commands.  
(Must be enabled via option in IH system menu, or by editing InfQuickMenuDefs.lua)

When enabled hold the [Call Radio] (Q key or Left bumper) button then hold one of the following:

[Ready weapon] (Right mouse or Left Trigger) to warp to last placed usermarker  
[Fire] (Left mouse or Right Trigger) to open the menu to heli-to last usermarker (a kludge, but necesary to activate the inter landingzone ride on heli)  
[Action] (E key or Y button) to activate TSM  
[Reload] (R key or B button) to activate Free cam  
[Dash] (Shift or Left stick click) to activate Static camera  
[Change Stance] (C key or A button) to have Quiet move to last usermarker  

Profiles:  
Profiles are lists of settings for IH options, can be used as an alternative, or in conjunction with IHs in-game menu.  
See MGS_TPP\mod\profiles\All_Options_Example.lua for more info.

Settings save file:  
IH writes its settings to ih_save.lua in the MGS_TPP\mod\saves folder.  
While the file is editable, editing an inMission save is likely to cause issues.

Known Issues
------------------------------
See ['FAQ Known issues.md'](https://github.com/TinManTex/InfiniteHeaven/blob/master/tpp-release/gamedir-ih/GameDir/mod/docs/Infinite%20Heaven/FAQ%20Known%20issues.md)

Thanks:
------------------------------
Kojima Productions for the great game  
Sergeanur for qartool  
atvaark for your fox tools  
ThreeSocks3 for finding the custom text output for Announce log  
emoose for cracking lua in fpks  
jRavens for your early testing  
Shigu for your specific testing and discussions  
Topher for your great mod manager Snakebite  
NasaNhak for your voluminous questions and suggestions  
unknown123 for the MGSV research.  
sai for FoxLib and further MGSV research.  
Morbidslinky for creating Side Ops companion and his poking at the quest system as well as his work on Snakebite.  
Various people for their donations, including: Domenico, Jeong, Lee, Nicholas, Gary, Joseph, Lisa, Надежда, Ian, WolfJack, Oliver, Daniel, Domenico, Ryuta.  
Thanks a lot.  
All the mod users on nexus for trying the mod and bug reports.  
All the other MGSV mod authors past and current for adding to the community.  
You for reading this.
