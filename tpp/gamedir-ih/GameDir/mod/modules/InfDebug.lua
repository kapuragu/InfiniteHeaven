--InfDebug.lua

local this={}

function this.PostAllModulesLoad()
  if Ivars.debug_WriteLoadedModulesHint:Is(1)then
    this.WriteLoadedModulesHint()
  end
end--PostAllModulesLoad

--tex TODO: really need to tag IH files so IH/other mods can have their own hint files
--OUT:FILE: GameDir/mod/vscode_hint-mod.lua
function this.WriteLoadedModulesHint()
  InfCore.LogFlow("WriteLoadedModulesHint")

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
    "--GENERATED: by WriteLoadedModulesHint from InfCore.loadedModules.LoadExternalModule",
    "--module/file hints for vscode lua language server extension",
    "--ASSUMPTION: file paths are somewhere the lua language servers Settings > Lua Runtime: Path can find them",
    "--which by default is anything downstream of the workspace folder", 
    "--this file is not meant to be loaded by game/IH",

  }
  table.insert(hintLines,"--non base game LoadLibrary")
  for fileName,loadInfo in pairs(InfCore.loadedModules.LoadLibrary)do
    if not manifest_data_dat.fileList[fileName] and not manifest_data_dat.fileList["/"..fileName] then--tex 'Tpp/' paths dont have leading slash      
      local moduleName=InfCore.GetModuleName(fileName)
      local fileNameWithoutExt=string.sub(fileName,1,-string.len(".lua")-1)--tex strip ext
      local line=moduleName..[[=require"]]..fileNameWithoutExt..[["]]
      table.insert(hintLines,line)
    end
  end--for loadedModules.LoadExternalModule

  --tex for ih this is just InfRequiresStart, which itself doesn't really do anything but log its existance
  table.insert(hintLines,"--Tpp.requires")
  for i,fileName in ipairs(Tpp.requires)do
    if not manifest_data_dat.fileList[fileName]then
      local moduleName=InfCore.GetModuleName(fileName)
      local fileNameWithoutExt=string.sub(fileName,1,-string.len(".lua")-1)--tex strip ext
      local line=moduleName..[[=require"]]..fileNameWithoutExt..[["]]
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
end--WriteLoadedModulesHint

--tex in debugMenu
this.debug_WriteLoadedModulesHint={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
}

this.registerIvars={
  "debug_WriteLoadedModulesHint",
}

this.langStrings={
  eng={
  },
  help={
    eng={
      debug_WriteLoadedModulesHint="Runs WriteLoadedModulesHint on PostAllModulesLoad",
      writeLoadedModulesHint="Writes GameDir/mod/vscode_hint-mod.lua",
    },
  },
}--langStrings


return this