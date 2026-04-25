InfiniteHeaven

A fork of TinManTex's mod, fixing bugs and adding new features.

tex:
Mod for MGSV, and the lua files for gz, mgo, ssd and some scattered analysis and external scripts and other mess.

repo was built from uploading manual snapshots I had of IH up to r233, has most of the release versions (and a few in-between), but have a few missing.

Due to that history includes evolution of mockfox to current (though actual project has since been moved to its own repo).

Beyond being my source control and possible future collaboration a public repo gives me options to optimise IH release builds (like running it through a minifier) and still allow community members to poke at the code.

Currently for your personal research and archiving purposes, I retain control over public releases.

Assets that are duplicates or modifications of MGSV assets may only be used in MGSV.

Rough layout:
tpp,tpp-release:
Actual Infinite Heaven mod 

foxkitutils:
Various Unity util scripts and the IHook<>Game IPC scripts

nongamelua:
mostly just (ancient) bespoke random scripts to process certain things into other things.

autodoc:
Builds the IH 'Features and Options' documents by using MockFox to load IH and process the menus.

Infinite Heaven mod is built via a seperate program mgsv_buildmod 
https://github.com/kapuragu/mgsv_buildmod
Using either tpp\build-infinite_heaven.json for dev build (with the futher kink of not including the GameDir\mod folder since I symlink that to the MGS_TPP folder on my machine)
or tpp\build-infinite_heaven-release.json for release build.

Only recently (Oct 2021) started using the Issues system to track TODOs