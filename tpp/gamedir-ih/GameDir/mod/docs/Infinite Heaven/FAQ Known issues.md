FAQ Known issues:
(See Troubleshooting.txt to work through other issues).

Crash to desktop on start:
Uninstall IHHook to see if the issue is specific to it, or IH.

Crash to desktop on start:
Try disabling any overlay programs (ex nvidia overlay).

Crash to desktop on start:
Check you virus software isn't quaranting MGSV, some are a bit too paranoid of IH running a command prompt on startup (which it does to get a list of files in the IH directory and start IHExt).

Hang on exiting free roam: This may occur if you previously had an additional sideops mod installed but reset 00.dat or snakebite without uninstalling the mod first.
Solution: Either reinstall the sideops mod or delete all files in MGS_TPP\mod\quests except: ih_quest_q30100.lua, ih_quest_q30101.lua, ih_quest_q30102.lua, ih_quest_q30103.lua, ih_quest_q30155.lua

The Announce Log used for the IH default menu display has a delay on entries, so slow down your button presses when changing the settings.
Solution: Use the IHExt overlay.

SideOps:
Every sideop being greyed out.
Solution: Change the Unlock Sideops mode to any setting, this should refresh the list, after the change you can change the setting back to what it was or off if you wish.

Replaying sideop 144: Remains of Man on Fire, will leave your character stuck in the Quarantine helipad and unable to abort the mission and requiring you to restore your save. Avoid completing the mission (extracting body).

Sideops for addon locations:
Can not start sidop from ACC sideops list, sideop will still start if you load the location normally.

Sideop start text doesn't show.

Sideop will show it's active radius in afghanistan. A bug due to the UI not supporting addon locations.

With Walker gears in free roam in Africa a walker gear model will appear hovering in Kiziba Camp next to the delivery pad (it's the 0,0,0 point). This is a bug in the original game (you can confirm by playing Footprints of Phantoms unmodded.)

Same issue as above with Skull sniper.

Enemy Life percentage doesn't seem to affect stun.

Enable soldier parameter settings:
When setting this option to Off you must exit to title to have the setting save, then restart the game to have it load the default (or other mods) enemy parameters.

Vehicle reinforcements:
Currently if the heli leaves the reinforce variable will stay active so you will not have further vehicle reinforcements for the mission.
Reinforce heli will spawn with combat alert, you'll hear the ! and it doing a round of attack even though it's far away.

DD equip:
Some weapons will not give the proper name when picked up and have a blank icon, some weapons scopes will be blacked out.

Patrol helicopters: 
Heli state is not saved and will reset on checkpoint reload, so helis may vanish (to another place on the map).
This may be mitigated in future versions, but not fully fixed since KJP optimized a bit too far so can only save/load one heli.
Heli in side ops may travel from one sideop to the next (if first sideop is loaded and second is also heli sideop), have yet to test to see if it does switch the sideop it counts towards on death.
Heli sideop loading may be delayed until very near resulting in sudden pop in of sideop vehicles/soldiers.
Heli patrol known bug: support heli cannot target helis when there's multiple helis in the world. This won't be fixable as the AI is in the game engine/untouchable.

Wildcard soldiers:
Attempting to exit the map from an area that has both a female wildcard soldier and a female prisoner sideop will cause in infinite load. Restarting the game will put you back in the map before the attempted exit, clear the sideop and leave the area before attempting to exit the map again.