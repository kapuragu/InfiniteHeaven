-- InfModules.lua
-- tex lists references to the modules (that succesfully loaded) via InfMain.LoadExternalModules/moduleNames table
-- see InfMain.LoadExternalModules to see how this is set up, and other references to InfModules to see how it's used
local this={}

--STATE
this.moduleNames={}
--this[n]=module--tex modules in above order, added to by LoadExternalModules, a bit of an odd setup, but saves having an extra index of a sub table

this.externalModules={}--set in InfMain.LoadExternalModules

--tex while most modules are just loaded in whatever order dir > returns, still need to handle order of these -v- since there's some depenancies between them
this.coreModules={
  "Ivars",
  "IvarsPersist",
  "InfLangProc",
  "InfLang",
  "InfMenu",
  "InfMenuDefs",
  "InfMenuCommands",
  "InfQuickMenuDefs",
}

--TABLESETUP
this.isCoreModule={}
for i,moduleName in ipairs(this.coreModules)do
  this.isCoreModule[moduleName]=true
end

--tex base modules for ih, listed so they can be loaded internally with release build
this.baseModules={
  InfAnimal=true,
  InfBodyInfo=true,
  InfBuddy=true,
  InfCamera=true,
  InfCameraPlayCam=true,
  InfDemo=true,
  InfEneFova=true,
  InfEneFovaIvars=true,
  InfEnemyPhase=true,
  InfEquip=true,
  InfExtToMgsv=true,
  InfFova=true,
  InfFovaIvars=true,
  InfGameEvent=true,
  InfHelicopter=true,
  InfInterrogation=true,
  InfLangCpNames=true,
  InfLookup=true,
  InfLZ=true,
  InfMainTpp=true,
  InfMainTppIvars=true,
  InfMBAssets=true,
  InfMBGimmick=true,
  InfMBStaff=true,
  InfMBVisit=true,
  InfMenuCommandsTpp=true,
  InfMgsvToExt=true,
  InfMission=true,
  InfMotion=true,
  InfNPC=true,
  InfNPCHeli=true,
  InfNPCOcelot=true,
  InfObjects=true,
  InfParasite=true,
  InfPositions=true,
  InfPuppy=true,
  InfQuest=true,
  InfQuestIvars=true,
  InfReinforce=true,
  InfResources=true,
  InfRevenge=true,
  InfRevengeIvars=true,
  InfRoutes=true,
  InfSoldier=true,
  InfSoldierParams=true,
  InfTimeScale=true,
  InfUserMarker=true,
  InfVehicle=true,
  InfWalkerGear=true,
  InfWarp=true,
  InfWeather=true,
}

return this
