-- InfModules.lua
-- tex lists references to the modules (that succesfully loaded) via InfMain.LoadExternalModules/moduleNames table
-- see InfMain.LoadExternalModules to see how this is set up, and other references to InfModules to see how it's used
local this={}

--STATE
this.moduleNames={}
--this[n]=module--tex modules in above order, added to by LoadExternalModules, a bit of an odd setup, but saves having an extra index of a sub table

this.externalModules={}--set in InfMain.LoadExternalModules

--tex while most modules are just loaded in whatever order dir > returns, still need to handle order of these -v- since there's some depenancies between them
this.dependentOrder={
  --InfInit:
  "InfInspect",
  "InfUtil",
  "InfHooks",
  "IvarProc",
  "Ivars",
  "IvarsPersist",
  "InfSoldierFaceAndBody",
  --InfInitMain:
  "InfButton",
  --
  "InfLangProc",
  "InfLang",
  "InfMenu",
  "InfMenuDefs",
  "InfMenuCommands",
  "InfQuickMenuDefs",
}

--TABLESETUP
this.isOrderedModule={}
for i,moduleName in ipairs(this.dependentOrder)do
  this.isOrderedModule[moduleName]=true
end

return this
