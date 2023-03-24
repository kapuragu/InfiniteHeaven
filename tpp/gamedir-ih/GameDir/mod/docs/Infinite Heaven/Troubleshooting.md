Troubleshooting:

Check the FAQ Known Issues document.

If you have issues with Snakebite try the suggestions on the stickied post on the snakebite nexus posts.

If you're using IHHook make sure it's updated to a version compatible with the version of IH you're using.

For other issues, in general when asking for help you want to provide as much information, in as much detail as possible:

What your were doing leading up to the issue.

What you expected to happen.

What happened instead.

What version of IH you are using.

If it happened after updating IH, what was the previous version you were using that it worked on.

What mods you have installed.

And provide some files (saves and logs) so anyone trying to help has yet more information:

Your save game that's at the point it's having issues.
The save files are in:
<steam path>\userdata\<user id>\311340\remote
(Default install path of steam is C:\Program Files\Steam)

Usually TPP_GAME_DATA alone is sufficient.

Some files from the MGS_TPP game folder 
Usually game folder is in Steam\SteamApps\common\MGS_TPP
You can also open it (if snakebite is set up correctly) via 
SnakeBite > Mods > File Menu > Open Game directory.

The files:
MGS_TPP\snakebite.xml
MGS_TPP\ihhook_log.txt (If you have IHHook installed)
The entire MGS_TPP\mod folder (as this contains the ih_save as well as debug logs).

Whole SnakBite folder\Logs\ folder
You can find this via
SnakeBite > Mods > Open Debug Logs

If you need a place to upload mega.co.nz works well, as does dropbox.
You can message me the link if you wish.


After you have done so there's a couple of things you can try:

Abort to ACC from title:
At the title screen hold down the Escape key for a couple of seconds, the Fox logo will flash up breifly, upon selecting continue the game will load into ACC instead of the mission the save was on.

Clear IH settings completely:
Exit the game and delete MGS_TPP\mod\saves\ih_save.lua

Resetting from scratch:
1: Pressing the 'Restore original game files' button in snakebites settings page.
2: Verifying game cache through the properties for the game in steam.
3: Delete the entire MGS_TPP\mod (you may want to copy off the ih_save.lua in MGs\mod\saves first)
At this point MGSV will be considered unmodded, but verify by loading the game.

Re-rerun snakebite and go through it's steps.
Again test to see if the game loads.

Install Infinite Heaven only.
Test again to see if the issue still occurs.

Copy MGS_TPP\mod\docs\ih_save-with-debug\ih_save.lua to MGS_TPP\mod\saves and test again.
Send the MGS_TPP\mod\ih_log.txt if you hit the problem again.
You should delete this save from MGS_TPP\mod\saves after your testing.

If the game save is in-mission and not in ACC you may need to Abort to ACC from title (see above).
