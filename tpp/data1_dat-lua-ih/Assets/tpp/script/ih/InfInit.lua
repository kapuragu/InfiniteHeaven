-- DOBUILD: 1
-- InfInit.lua
-- tex loaded in init.lua
-- is module since it's Script.LoadLibraryed to break init.luas boxing
-- this does lead to an unknown since (in release build) it will be Script.LoadLibrarying more modules below while the module itself hasn't finished it's loading via Script.LoadLibrary
-- see also InfInitMain
local this={}

if IHH then
  IHH.Init()
end

local modSubPath="mod"
local corePath="/Assets/tpp/script/ih/InfCore"

local exists=true
if IHH then
  exists=IHH.FileExists("./"..modSubPath..corePath..".lua")--WORKAROUND: now that IHHook is catching errors we want to skip just blindly require ing
end
if exists then
  --tex try loading external first. messy, but it's chicken and egg, once InfCore is up and running it has tidier functions that could do this
  local sucess,ret=pcall(require,modSubPath..corePath)--GOTCHA modPath. relying on default package.paths having game dir DEBUGNOW if IHH then could use gamepath
  if sucess then
    InfCore=ret
    InfCore.Log("Loaded InfCore externally")
  else
    exists=false
  end
end

if not exists then
  --TODO I don't think there's really any option here to log if InfCore fails and IHHook isn't installed.
  --also, this is only really an error if -v- InfCore doesn't exist internally
  --does loadlibrary raise errors that we can catch?
  if IHH then
    --IHH.Log(5,ret)--level_critical
  end
  Script.LoadLibrary(corePath..".lua")
  InfCore.Log("Loaded InfCore internally")
end

if InfCore and not InfCore.modDirFail then
  InfCore.LoadExternalModule"InfInspect"
  InfCore.LoadExternalModule"InfUtil"
  InfCore.LoadExternalModule"InfHooks"

  --STATE GLOBAL
  ivars={}
  evars={}
  igvars={}
  ih_save={}

  --tex these (and the above) need to be booted up pretty much as early as it can, but they are InfModules/using that system so they can be reloaded
  --though in theory using Script.LoadLibrary and whatever management that provides is 'the proper way', 
  --I dont know enough about that, and the rest of the IH module system/having it reloadable is too convenient, 
  --theres no compelling case for handling these as InfCore.LoadLibrary
  --GOTCHA: but LoadExternalModule doesn't currently have the pre and post load management of InfMain.LoadExternalModules
  InfCore.LoadExternalModule"IvarProc"
  InfCore.LoadExternalModule"Ivars"
  InfCore.LoadExternalModule"IvarsPersist"
  
  if Ivars==nil then
    InfCore.Log"Ivars==nil"--DEBUG
  else
    --CULL IvarsPersist.SetupVars()
    IvarProc.LoadEvars()
    if ivars.enableIHExt==1 then
      InfCore.StartIHExt()
    else
      if IHH then--DEBUGNOW WORKAROUND use IHHMenu
        InfCore.extSession=1
      end
    end
  end

  --InfCore.PrintInspect(evars)--DEBUG
  --tex needs to be up for Soldier2FaceAndBodyData
  InfCore.LoadExternalModule"InfSoldierFaceAndBody"

  InfCore.PCall(InfSoldierFaceAndBody.LoadFovaInfo)

  InfCore.Log"/InfInit.lua done"
end

return this
