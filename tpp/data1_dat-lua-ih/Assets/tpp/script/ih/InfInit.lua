-- DOBUILD: 1
-- InfInit.lua
-- tex loaded in init.lua
-- is module since it's Script.LoadLibraryed to break init.luas boxing
-- this does lead to an unknown since (in release build) it will be Script.LoadLibrarying more modules below while the module itself hasn't finished it's loading via Script.LoadLibrary
-- see also InfInitMain
local this={}

--tex a lot of chicken egging here to load InfCore externally
local function CmdEcho(message)
  --tex cmd /k will keep cmd open. I haven't had much luck getting pause to work outside of a batch file
  --problem with /k is mgsv wont start again unless its closed.
  local strCmd=[[cmd.exe /k echo ]]..message
  os.execute(strCmd)
end
local function LogError(message)
  if IHH then
    IHH.Log(message)
  else
    CmdEcho(message)
  end
end

if IHH then
  IHH.Log("InfInit.lua")
  IHH.Init()
end

local modSubPath="mod"
local corePath="/Assets/tpp/script/ih/InfCore"

--tex try and load InfCore externally
--currently InfCore is only external on dev build
--IH release has it internal

--tex using require at this point relies on default package.path (
--or LUA_PATH with ;; which will insert default path, but that's a lot more chicken egging to parse to check, just to do it again in InfCore
-- local luaPathEnv=os.getenv("LUA_PATH")
-- if luaPathEnv then

-- end

local externalExists=true
local extSuccess=false
local externalRet=nil
if IHH then
  externalExists=IHH.FileExists("./"..modSubPath..corePath..".lua")--WORKAROUND: now that IHHook is catching errors we want to skip just blindly require ing
end
if externalExists then
  --tex try loading external first. messy, but it's chicken and egg, once InfCore is up and running it has tidier functions that could do this
  extSuccess,externalRet=pcall(require,modSubPath..corePath)--GOTCHA modPath. relying on default package.paths having game dir DEBUGNOW if IHH then could use gamepath
  if extSuccess then
    InfCore=externalRet
    --tex InfCore.Log still not up till OnModuleLoad
    if IHH then
      IHH.Log("Loaded InfCore externally")
    end
  else
    externalExists=false
  end
end

if not extSuccess then
  --TODO: does loadlibrary raise errors that we can catch?
  if IHH then
    --IHH.Log(5,ret)--level_critical
  end
  Script.LoadLibrary(corePath..".lua")
  if IHH then
    IHH.Log("Loaded InfCore internally")
  end
end

if not InfCore then
  if externalExists and not extSuccess then
    --tex a bit twisty due to the above. basically InfCore failed to load external or internal,
    --if theres an external then its a dev build, so we can log the earlier fail
    --release build doesnt have external, so its externalRet will just be complaining about it being missing
    --TODO: so we arent actually catching the case for release where internal InfCore load fails
    --but I'm not sure we have enough info to figure that out unless we have some build step flag what's expected (there being an external or not)
    LogError("ERROR: require "..tostring(modSubPath..corePath).." did not succeed: "..tostring(externalRet))
  else
    LogError("ERROR: InfCore did not load")
  end
else
  local success,ret=pcall(InfCore.OnModuleLoad)
  if not success then
    LogError("ERROR: InfCore.OnModuleLoad: "..tostring(ret))
  end
end

if InfCore and not InfCore.modDirFail then
  --tex non IHH log should now be available
  InfCore.LoadExternalModule"InfInspect"
  InfCore.LoadExternalModule"InfUtil"
  InfCore.LoadExternalModule"InfHooks"

  --STATE GLOBAL
  ivars={}
  evars={}
  igvars={}
  ih_save={}

  --tex GOTCHA: aparently zeta r20 overrides IvarProc via InfCore.LoadLibrary load external so reverting this from using LoadExternalModule like below. 
  --Still will break/will conflict with ih dev build which does actually have IvarProc external, which means I can't easily test zeta
  --whats with my currrent setup of gamedir\mod via symlink snakebite wont even catch the conflict (because ih gamedir\mod isn't actually in makebite build)
  --https://github.com/TinManTex/SnakeBite/issues/20
  --also zeta doesnt have its Init (which is loaded by its hijacked IvarProc) external, so I can't exist check and load that (and inQar/snakebite.xml parse isn't built at this point of exec)
  InfCore.LoadLibrary"/Assets/tpp/script/ih/IvarProc.lua"

  --tex these (and the above) need to be booted up pretty much as early as it can, but they are InfModules/using that system so they can be reloaded
  --though in theory using Script.LoadLibrary and whatever management that provides is 'the proper way', 
  --I dont know enough about that, and the rest of the IH module system/having it reloadable is too convenient, 
  --theres no compelling case for handling these as InfCore.LoadLibrary
  --GOTCHA: but LoadExternalModule doesn't currently have the pre and post load management of InfMain.LoadExternalModules
  --InfCore.LoadExternalModule"IvarProc"
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
