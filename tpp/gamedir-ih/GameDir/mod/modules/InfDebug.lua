--InfDebug.lua

local this={}

function this.PostAllModulesLoad()
  if Ivars.debug_WriteVscodeHint:Is(1)then
    this.WriteVscodeHint()
  end
end--PostAllModulesLoad

function this.GetRequireLine(filePath)
  local moduleName=InfCore.GetModuleName(filePath)
  local fileNameWithoutExt=string.sub(filePath,1,-string.len(".lua")-1)--tex strip ext
  local line=moduleName..[[=require"]]..fileNameWithoutExt..[["]]
  return line
end--GetRequireLine

--tex TODO: really need to tag IH files so IH/other mods can have their own hint files
--OUT:FILE: GameDir/mod/vscode_hint-mod.lua
function this.WriteLoadedModulesVscodeHint()
  InfCore.LogFlow("WriteLoadedModulesVscodeHint")

  InfCore.PrintInspect(InfCore.loadedModules,"InfCore.loadedModules")
  InfCore.PrintInspect(Tpp.requires,"Tpp.requires")
  InfCore.PrintInspect(Tpp._requireList,"Tpp._requireList")

  if manifest_data_dat==nil then
    InfCore.Log("ERROR: WriteLoadedModulesHint: manifest_data_dat module not loaded")
    return
  end

  local fileName="vscode_hint-mod.lua"
  local hintLines={
    "--"..fileName,
    "--GENERATED: by Debug menu > WriteVscodeHint using InfCore.loadedModules",
    "--module/file hints for vscode lua language server extension",
    "--ASSUMPTION: file paths are somewhere the lua language servers Settings > Lua Runtime: Path can find them",
    "--which by default is anything downstream of the workspace folder", 
    "--this file is not meant to be loaded by game/IH",

  }

  table.insert(hintLines,"--tex WORKAROUND, IH bootstrap stuff that doesnt go through any SetLoaded/.loadedModules")
  table.insert(hintLines,[[InfCore=require"/Assets/tpp/script/ih/InfCore"]])
  table.insert(hintLines,[[InfInit=require"/Assets/tpp/script/ih/InfInit"]])
  table.insert(hintLines,[[InfInitMain=require"/Assets/tpp/script/ih/InfInitMain"]])

  table.insert(hintLines,"--non base game LoadLibrary")
  for fileName,loadInfo in pairs(InfCore.loadedModules.LoadLibrary)do
    if not manifest_data_dat.fileList[fileName] and not manifest_data_dat.fileList["/"..fileName] then--tex 'Tpp/' paths dont have leading slash      
      local line=this.GetRequireLine(fileName)
      table.insert(hintLines,line)
    end
  end--for loadedModules.LoadExternalModule

  --tex for ih this is just InfRequiresStart, which itself doesn't really do anything but log its existance
  table.insert(hintLines,"--Tpp.requires")
  for i,fileName in ipairs(Tpp.requires)do
    if not manifest_data_dat.fileList[fileName]then
      local line=this.GetRequireLine(fileName)
      table.insert(hintLines,line)
    end
  end--for Tpp.requires

  table.insert(hintLines,"--LoadExternalModule")
  for moduleName,loadInfo in pairs(InfCore.loadedModules.LoadExternalModule)do
    --REF LoadExternalModule paths:
    --local externalPath="/Assets/tpp/script/ih/"..moduleName..".lua"    --tex not used?
    --local internalPath=InfCore.gamePath..InfCore.modSubPath.."/modules/"..moduleName..".lua"
    
    --REF InfBodyInfo=require"InfBodyInfo"
    local line=moduleName..[[=require"]]..moduleName..[["]]
    table.insert(hintLines,line)
  end--for loadedModules.LoadExternalModule

  --InfCore.PrintInspect(hintLines,"ihModuleLines")
  --tex depends where I want to put it. as this function is runtime, at most I can put it in GameDir or GameDir\mod without hardcoding path to put it in a repo dir
  --local savePath=[[C:/Projects/MGS/InfiniteHeaven/tpp/]]
  local savePath=InfCore.paths.mod..fileName
  InfCore.Log("Writing "..savePath)
  InfCore.WriteLines(savePath,hintLines)
end--WriteLoadedModulesVscodeHint

--tex doesn't really need to be written each time, but on the off chance theres a game updated (and manifest luas updated to reflect changes)
function this.WriteBaseGameVscodeHint()
  if manifest_data_dat==nil then
    InfCore.Log("ERROR: WriteBaseGameVscodeHint: manifest_data_dat module not loaded")
    return
  end

  local fileName="vscode_hint-base_game.lua"
  local hintLines={
    "--"..fileName,
    "--GENERATED: by Debug menu > WriteVscodeHint using manifest_data_dat, manifest_fpk_combined",
    "--hint file for vscode lua language server extension by sumneko",
    "--this is not acually used in actual IH mod, the vscode lua extension needs a bit of help figuring out what modules are loaded through the games (and IHs) convoluted loading process",
    "--Assumes the files are somewhere downstream of workspace folder, ",
    "--you can hover mouse over path and see if the popup finds the actual file path",
    "--else would have to add to vscode Settings > Lua > Runtime: Path",
    "--downside of not specifiying actual subfolder (ex data1_dat-lua/Assets/bleh) means it will pick up every file of the same name but in diffent folders",
    "--(in the case of IH this might be a base file in data1_dat-lua and externally loaded one I'm kicking around in gamedir-ih/GameDir/mod)",
    "--and I'm not sure how it actually resolves in that case",

  }
  table.insert(hintLines,"--data1_dat-lua")
  for i,filePath in ipairs(manifest_data_dat.fileList)do
    local line=this.GetRequireLine(filePath)
    table.insert(hintLines,line)
  end--for fileList
  table.insert(hintLines,"--fpk_combined-lua")
  for i,filePath in ipairs(manifest_fpkd_combined.fileList)do
    local line=this.GetRequireLine(filePath)
    table.insert(hintLines,line)
  end--for fileList

  local savePath=InfCore.paths.mod..fileName
  InfCore.Log("Writing "..savePath)
  InfCore.WriteLines(savePath,hintLines)
end--WriteBaseGameVscodeHint

function this.WriteVscodeHint()
  this.WriteBaseGameVscodeHint()
  this.WriteLoadedModulesVscodeHint()
end--WriteVscodeHint

--tex in debugMenu
this.debug_WriteVscodeHint={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.registerIvars={
  "debug_WriteVscodeHint",
}

this.registerMenus={
  "debugMenu",
  "debugInMissionMenu",
}

this.debugMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu"},
  options={
    "Ivars.debugMode",
    "Ivars.debugMessages",
    "Ivars.debugFlow",
    "Ivars.debugOnUpdate",
    "Ivars.log_SetFlushLevel",
    "InfMenuCommands.LoadExternalModules",
    "InfMenuCommands.CopyLogToPrev",
    "Ivars.printPressedButtons",
    "InfCamera.ShowFreeCamPosition",
    "InfMenuCommands.ShowPosition",
    "InfMenuCommands.ShowMissionCode",
    "InfMenuCommands.ShowLangCode",
    "InfFovaIvars.appearanceDebugMenu",
    --OFF: TODO: "InfFovaIvars.characterDebugMenu",
    "Ivars.telopMode",--tex TODO move, odd one out, mission/presentation?
    "Ivars.manualMissionCode",
    "Ivars.manualSequence",
    "Ivars.debug_WriteVscodeHint",
    "InfDebug.WriteVscodeHint",
  }
}--debugMenu

this.debugInMissionMenu={
  parentRefs={"InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.debugMode",
    "Ivars.debugMessages",
    "Ivars.debugFlow",
    "Ivars.debugOnUpdate",
    "Ivars.log_SetFlushLevel",
    "InfMenuCommands.LoadExternalModules",
    "InfMenuCommands.CopyLogToPrev",
    "Ivars.selectedCp",
    "InfMenuCommands.SetSelectedCpToMarkerObjectCp",
    "InfMenuCommands.SetSelectedCpToMarkerClosestCp",
    "InfMenuCommandsTpp.DEBUG_ShowRevengeConfig",
    "InfFovaIvars.appearanceDebugMenu",
    --OFF: TODO: "InfFovaIvars.characterDebugMenu",
    --"InfMenuCommandsTpp.DEBUG_ChangePhase",
    --"InfMenuCommandsTpp.DEBUG_KeepPhaseOn",
    --"InfMenuCommandsTpp.DEBUG_KeepPhaseOff",
    --"InfMenuCommandsTpp.printPlayerPhase",
    --"InfMenuCommandsTpp.DEBUG_SetPlayerPhaseToIvar",
    --"InfMenuCommandsTpp.DEBUG_PrintVarsClock",
    --"InfMenuCommands.ShowMissionCode",
    --"InfMenuCommandsTpp.ShowMbEquipGrade",
    "Ivars.printPressedButtons",
    "Ivars.printOnBlockChange",
    "Ivars.disableGameOver",
    "Ivars.disableKillChildSoldierGameOver",--DEBUGNOW move these
    "Ivars.disableOutOfBoundsChecks",
    "InfMenuCommands.SetAllFriendly",
    "InfMenuCommands.SetAllZombie",
    "InfParasite.DEBUG_ToggleParasiteEvent",
    "InfMenuCommands.ResetStageBlockPosition",
    "InfMenuCommands.SetStageBlockPositionToMarkerClosest",
    "InfMenuCommands.SetStageBlockPositionToFreeCam",
    "InfCamera.ShowFreeCamPosition",
    "InfMenuCommands.ShowPosition",
    "InfMenuCommands.CheckPointSave",
    --"InfMenuCommands.DEBUG_ClearAnnounceLog",
    "Ivars.manualMissionCode",
    "Ivars.manualSequence",
  }
}--debugInMissionMenu


this.langStrings={
  eng={
  },
  help={
    eng={
      debug_WriteVscodeHint="Runs WriteLoadedModulesHint on PostAllModulesLoad",
      writeVscodeHint="Writes GameDir/mod/vscode_hint-mod.lua,vscode_hint-base_game.lua , writes a hint files for vscode lua language server extension of mod lua files loaded.",
    },
  },
}--langStrings


return this