-- DOBUILD: 1
-- InfInitMain.lua
-- tex loaded in start.lua, as an alternative to Tpp.requires
-- is module since it's Script.LoadLibraryed to break start.luas boxing
-- DEBUGNOW this does lead to an unknown since (in release build) it will be Script.LoadLibrarying more modules below while the module itself hasn't finished it's loading via Script.LoadLibrary
local this={}

InfCore.Log("InfInitMain:")
if IHH then
  IHH.InitMain(InfCore.modVersion)
end

InfCore.LoadLibrary"/Assets/tpp/script/ih/InfModules.lua"
--tex InfMain currenly has localopt dependancy on InfButton. 
--TODO: a standard solution would be to 'require' in infmain, but would probably want to add out own LoadExternalModule loader to packages
--see also LoadExternalModule GOTCHA: in InInit
InfCore.LoadExternalModule"InfButton"
InfCore.LoadLibrary"/Assets/tpp/script/ih/InfMain.lua"
InfMain.OnModuleLoad()
InfCore.doneStartup=true

table.insert(Tpp._requireList,"InfMain")

return this
