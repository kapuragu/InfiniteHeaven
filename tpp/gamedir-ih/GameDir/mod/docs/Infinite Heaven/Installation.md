Infinite Heaven installation:

Preparation/insurance:
------------------------------
End/Abort any mission back to ACC before upgrading Infinite Heaven, upgrading a save that's mid-mission is likely to cause issues.

(Default install path of steam is C:\Program Files\Steam)
Back up your save files for safety:
<steam path>\userdata\<user id>\287700 and
<steam path>\userdata\<user id>\311340

MGSV uses two save folders
- 311340 is Ground Zeros steam id, but used by MGSV for save data even if GZ is not installed.
- 287700 is TPP steam id, most of the files here seem to be just backup, except for TPP_GRAPHICS_CONFIG

Copy both folders to a safe place.

You may want to back up periodically as you play in case you come across save breaking issues with the mod.

First-time prep:
Snakebite should do this, but it's good to have your own backups.
Back up TPPs original 00.dat and 01.dat in
<steam path>\steamapps\common\MGS_TPP\master\0\
This does not apply if you've already modded it.

Already modded:
Either find and restore your original game 00/01.dat backup or revalidate the game through steam:

Right click on the game in steam library, choose properties from bottom of menu, local files tab, verify integrity of game cache button.
or paste this to File Explorer or your browser steam://validate/287700

If it gets stuck at 0% for more than a few minutes steam is being stupid, validate one of the valve games first, hl2, portal etc then try validating mgsv again.

It should say 1 or two files need to be redownloaded, so go to steam downloads and make sure that is happening.

Install Snakebite:
Get the latest SnakeBite Mod Manager from 
[url=http://nexusmods.com/metalgearsolidvtpp/mods/106/]http://nexusmods.com/metalgearsolidvtpp/mods/106/[/url]
and run through its setup.

Click on the Mods menu item on Snakebites main screen.

Uninstall any earlier version of Infinite Heaven from the Installed Mods tab.

Extract the Infinite Heaven zip files somewhere.

Click Install .MGSV on the Installed Mods tab in Snakebite
Browse to the Infinite Heaven.msgv from the Infinite Heaven zip file.

This step should only take a minute or so if no other mods installed (longer with other mods installed, basically proportional to the size of 00.dat).
See log.txt in the snakebite folder which is updated with the installs progress.
If it takes an excessively long time refer to the sticky on the snakebite posts page for possible fixes.

Troubleshooting: See Troubleshooting.txt.

Note:
------------------------------
By design I try to keep the initial install to all regular game settings and only changed via infinite heavens in-game mod menu.
All settings are reset to off on doing a FOB mission. But I suggest you play offline while the mod is installed. Snakebite mod manager allows easy toggling of mods.

Using alongside other mods:
------------------------------
Infinite Heaven modifies a lot of the core game lua scripts, combining with mods that have their own versions of those files will break things in either obvious or subtle ways.
Mods that shouldn't have a conflict with Infinite Heaven are: Model swaps, data table mods like development unlocks or times.

Ask the mod author for a snakebite install package.

You can also convert many mods to snakebite yourself either by trying the Install .ZIP option in the Installed Mods tab of Snakebite
Or by using makebite (comes with snakebite) to create a Snakebite package (.MGSV)
[youtube]tYPi_kj3F8g[/youtube]
https://www.youtube.com/watch?v=tYPi_kj3F8g

If you want to manually check to see if a mod conflicts unzip the Infinite Heaven .mgsv with the zip tool of your choice and check to see if any of the files match files in the other mod.

Uninstallation:
------------------------------
Exit any missions, return to the ACC.
The mod saves some varables to the save file, but on initial testing (I welcome feedback on this) there is no issue with loading a save from this mod after the mod has been removed (provided you have exited to ACC)
Use uninstall in SnakeBite.
Delete the MGS_TPP\mod folder
