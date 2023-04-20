# About the Infinite Heaven repo vscode setup
For the Lua Language Server Extension by sumneko

## \tpp\tpp.code-workspace:
A vscode workspace for the dev (Infinite Heaven repo\tpp) folder.

## tpp/vscode_hint-*: 
The vscode lua language server extension needs a bit of help making sense of mgsv/IHs setup,
these lua files are parsed by the extension to map the files to their global modules (not used by IH mod itself).
As the IH repo includes all the base game lua files in data1_dat-lua and fpkd-combined-lua this will let the lua extensions popup and go to definitions work.

See the header in the files, or Infinite Heaven repo\vscode.md for more info.

IH > Debug menu > Vscode Menu:
"Commands to generate files to support using vscode with a mgsv project."
debug_WriteVscodeHintOnPostLoad - "Runs WriteVscodeHint on PostAllModulesLoad"
WriteVscodeHint - "Writes GameDir/mod/vscode/vscode_hint-mod.lua,vscode_hint-base_game.lua , writes a hint files for vscode lua language server extension of mod lua files loaded."
debug_WriteVarsOnSave - "Runs WriteVars on IH save (which includes close IH menu)"
WriteVars - "Writes vars, svars, gvars, mvars to GameDir/mod/vscode/, for manual perusal or use with vscode"
  
## Mock Modules:
The MockFox project 
https://github.com/TinManTex/MockFox
Has mock modules for the lua modules defined by the exe:
`MockFox repo\Generated\tpp\mockModulesAsGlobal`

To use them with the vscode lua extension
Download the MockFox repo and add those two folders in vscode Settings > Lua > Workspace: Libraries

Though this will give the extension a heavier workload, and chew on a lot of ram, it will squelch a bunch of warnings and let you jump to the module definition to look up the enums it provides for example.