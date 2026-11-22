-- DOBUILD: 1
-- InfCore.lua
local this={}
--LOCALOPT
local pcall=pcall
local type=type
local open=io.open
local tostring=tostring
local concat=table.concat
local string=string
--CULL local GetElapsedTime=Time.GetRawElapsedTimeSinceStartUp
local GetElapsedTime=os.clock--GOTCHA: os.clock wraps at ~4,294 seconds
local isMockFox=isMockFox
local luaHostType=luaHostType

local InfCore=this

this.modVersion=7
this.modName="Lost Heaven"

this.gameId="SSD"
this.gameDirectory="METAL GEAR SURVIVE"
this.gameProcessName="mgv"
this.modSubPath="mod"

--STATE
this.debugModule=false

this.session=os.time()--tex using os.time as session id
this.extSession=0

this.debugMode=true--tex (See GOTCHA below -v-)
--tex TODO combine into loadState
this.doneStartup=false
this.modDirFail=false
this.ihSaveFirstLoad=false
this.gameSaveFirstLoad=false
this.mainModulesOK=false
this.otherModulesOK=false

this.log={}

this.mgsvToExtCommands={}

this.mgsvToExtComplete=0--tex min/confirmed executed by ext, only commands above this should be written out

this.extToMgsvComplete=0--tex min/confirmed executed by mgsv

this.logErr=""
this.str32ToString={}
this.unknownStr32={}
this.unknownMessages={}
this.gameIdToName={}
--
local nl="\r\n"

local stringType="string"
local functionType="function"

--GOTCHA since io open append doesnt appear to work ('Domain error') I'm writing the whole log to file on every Add
--which is naturally bad performance for a lot of frequent Adds.
function this.Log(message,announceLog,force)
  if not this.debugMode and not force then
    return
  end

  --tex: trying to call to announcelog before its initialized will cause a hard crash. It's probably up during/before the init missions (1,5), just checking vars.missioncode suits purposes for now
  if announceLog and vars.missionCode then
    this.DebugPrint(message)
  end

  local elapsedTime=GetElapsedTime()

  local line="|"..elapsedTime.."|"..message
  this.log[#this.log+1]=line

  if isMockFox and luaPrintIHLog then
    print(line)
  end

  this.WriteLog(this.logFilePath,this.log)
end

function this.ClearLog()
  this.log={}
end

--tex cant log error to log if log doesnt log lol
function this.WriteLog(filePath,log)
  local logFile,openError=open(filePath,"w")
  if not logFile or openError then
    --this.DebugPrint("Create log error: "..tostring(openError))
    this.logErr=tostring(openError)
    return
  end

  logFile:write(concat(log,nl))
  logFile:close()
end

function this.WriteStringTable(filePath,stringTable)
  local logFile,openError=open(filePath,"w")
  if not logFile or openError then
    this.Log(openError)
    return
  end

  logFile:write(concat(stringTable,nl))
  logFile:close()
end

function this.WriteLogLine(message)
  local filePath=this.logFilePath

  --tex NOTE io open append doesnt appear to work - 'Domain error'
  --TODO think which would be better, just appending to string then writing that
  --or (doing currently) reading exising and string append/write that
  --either way performance will decrease as log size increases
  local logFile,openError=open(filePath,"r")
  local logText=""
  if logFile then
    logText=logFile:read("*all")
    logFile:close()
  end

  local logFile,openError=open(filePath,"w")
  if not logFile or openError then
    --this.DebugPrint("Create log error: "..tostring(error))
    return
  end

  local elapsedTime=GetElapsedTime()
  --tex TODO os time?


  if type(message)~=stringType then
    message=tostring(message)
  end

  local line="|"..elapsedTime.."|"..message
  logFile:write(logText..line,nl)
  logFile:close()
end


function this.FileExists(filePath)
  local file,openError=open(filePath,"r")
  if file and not openError then
    file:close()
    return true
  end
  return false
end

function this.CopyFileToPrev(path,fileName,ext)
  local filePath=path..fileName..ext
  local file,openError=open(filePath,"r")
  if file and not openError then
    local fileText=file:read("*all")
    file:close()

    local filePathPrev=path..fileName..this.prev..ext
    local filePrev,openError=open(filePathPrev,"w")
    if not filePrev or openError then
      return
    end

    filePrev:write(fileText)
    filePrev:close()
  end
end

function this.ClearFile(path,fileName,ext)
  local filePath=path..fileName..ext
  local logFile,openError=open(filePath,"w")
  if logFile then
    logFile:write""
    logFile:close()
  else
    return openError
  end
end
--

local MAX_ANNOUNCE_STRING=255 --288--tex sting length announce log can handle before crashing the game, a bit worried that it's actually kind of a random value at 288 (and yeah I manually worked this value out by adjusting a string and reloading and crashing the game till I got it exact lol).
function this.DebugPrint(message,...)
  if message==nil then
    TppUiCommand.AnnounceLogView("nil")
    return
  elseif type(message)~=stringType then
    message=tostring(message)
  end

  if ... then
    message=string.format(message,...)
  end

  while string.len(message)>MAX_ANNOUNCE_STRING do
    local printMessage=string.sub(message,0,MAX_ANNOUNCE_STRING)
    TppUiCommand.AnnounceLogView(printMessage)
    message=string.sub(message,MAX_ANNOUNCE_STRING+1)
  end

  TppUiCommand.AnnounceLogView(message)
end

function this.PCall(func,...)
  if func==nil then
    this.Log("PCall func == nil")
    return
  elseif type(func)~=functionType then
    this.Log("PCall func~=function")
    return
  end

  local sucess,result=pcall(func,...)
  if not sucess then
    this.Log("ERROR:"..result,false,true)
    this.Log("caller:"..this.DEBUG_Where(2),false,true)
    return
  else
    return result
  end
end

--tex as above but intended to pass through unless debugmode on
function this.PCallDebug(func,...)
  --  if func==nil then
  --    this.Log("PCallDebug func == nil")
  --    return
  --  elseif type(func)~=functionType then
  --    this.Log("PCallDebug func~=function")
  --    return
  --  end

  if not this.debugMode then
    return func(...)
  end

  local sucess, result=pcall(func,...)
  if not sucess then
    this.Log("ERROR:"..result,false,true)
    this.Log("caller:"..this.DEBUG_Where(2),false,true)
    return
  else
    return result
  end
end

local emptyTable={}
function this.PrintInspect(var,options)
  if not this.debugMode and (not options or not options.force) then
    return
  end
  options=options or emptyTable
  local varName=options.varName or options
  local ins=InfInspect.Inspect(var)
  if type(varName)=="string" then
    ins=varName.."="..ins
  end
  this.Log(ins,options.announceLog)
end

--tex NMC from lua wiki
function this.Split(self,sep)
  local sep = sep or " "
  local fields = {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

function this.FindLast(searchString,findString)
  --Set the third arg to false to allow pattern matching
  local found=searchString:reverse():find(findString:reverse(),nil,true)
  if found then
    return searchString:len()-findString:len()-found+2
  else
    return found
  end
end

function this.StartIHExt()
  local programPath

  for i,filePath in ipairs(this.filesFull.mod)do
    if string.find(filePath,"IHExt.exe") then
      programPath=filePath
      break
    end
  end

  --programPath = [["D:\GitHub\IHExt\IHExt\bin\Debug\IHExt.exe"]]--DEBUG

  if not programPath then
    InfCore.Log("WARNING: StartIHExt: Could not find IHExt.exe in "..this.gameDirectory.."\\"..this.modSubPath.."\\",false,true)
    return
  end

  local strCmd = 'start "" "'..programPath..'" "'..this.gamePath..'" '..this.modSubPath..' '..this.gameProcessName
  InfCore.Log(strCmd,false,true)
  this.PCall(function()os.execute(strCmd)end)
end

function this.IHExtRunning()
  return ivars and ivars.enableIHExt>0 and this.extSession~=0
end

function this.IHExtInstalled()
  local foundIHExt=false
  for i,filePath in ipairs(this.filesFull.mod)do
    if string.find(filePath,"IHExt.exe") then
      foundIHExt=true
      break
    end
  end
  return foundIHExt
end

--tex queues up cmd, use WriteToExtTxt to actually write/sends
function this.ExtCmd(cmd,...)
  if not this.IHExtRunning() then
    return
  end

  --tex ihExt hasnt started
  if this.extSession==0 then
    return
  end

  local mgsvToExtCurrent=#this.mgsvToExtCommands+1

  local args={...}--tex GOTOCHA doesnt catch intermediary params that are nil
  local message=mgsvToExtCurrent..'|'..cmd
  if #args>0 then
    message=message..'|'..concat(args,'|')
  end

  if this.debugModule then
    InfCore.PrintInspect(message,"ExtCmd message")
  end

  this.mgsvToExtCommands[mgsvToExtCurrent]=message
end

--tex LEGACY, InfProcessExt was deleted r218 but the file may linger if the user didnt uninstall correctly using snakebite (or if snakebite messed up)
function this.DoToMgsvCommands()
end

local concat=table.concat
local nl="\r\n"
function this.WriteToExtTxt()
  if this.debugModule then
    InfCore.Log("InfCore.WriteToExtTxt")
      --InfCore.PrintInspect(this.mgsvToExtCommands)--DEBUG
  end
  
  local filePath=this.toExtCmdsFilePath
  local file,openError=open(filePath,"w")
  if not file or openError then
    this.Log("WriteToExtTxt: ERROR: "..tostring(openError))
    return
  end
  --tex completed ext to mgsv commands completed index is written to mgsv to ext file since
  --since mgsv should only read incomming and write outgoing file
  --(and visa versa for whatever is writing ext to mgsv commands).
  local sessionInfo=this.session.."|extToMgsvComplete|"..this.extToMgsvComplete

  --tex only write from mgsvToExtComplete to end
  if #this.mgsvToExtCommands>0 then
    file:write(sessionInfo,nl,concat(this.mgsvToExtCommands,nl,this.mgsvToExtComplete+1))
  else
    file:write(sessionInfo)
  end
  file:close()
end

--tex altered from Tpp.DEBUG_Where
function this.DEBUG_Where(stackLevel)
  --tex MoonSharp does not support
  if debug==nil or debug.getinfo==nil then
    return"(getinfo not supported)"
  end

  --defining second param of getinfo can help peformance a bit
  --`n´ selects fields name and namewhat
  --`f´ selects field func
  --`S´ selects fields source, short_src, what, and linedefined
  --`l´ selects field currentline
  --`u´ selects field nup
  local stackInfo=debug.getinfo(stackLevel+1,"Snl")
  if stackInfo then
    return stackInfo.short_src..(":"..stackInfo.currentline.." - "..(stackInfo and stackInfo.name or ""))
  end
  return"(unknown)"
end

function this.LogFlow(message)
  if not this.debugMode then
    return false
  end
  if ivars and not ivars.debugFlow then
    return
  end
  --  local stackLevel=2
  --  local stackInfo=debug.getinfo(stackLevel,"n")
  --  this.Log(tostring(stackInfo.name).."| "..message)
  this.Log(message)
end

function this.Validate(format,profile,name)
  for keyName,valueType in pairs(profile) do
    if format[keyName] and type(profile[keyName])~=format[keyName] then
      InfCore.Log("InfCore.Validate "..tostring(name)..": Failed - "..tostring(keyName).." =="..type(keyName).." expected "..tostring(format[keyName]))
      return false
    end
  end
  return true
end

--tex TODO: could be in InfLookup, but fine here for now to keep as depenancies on InfLookup low
--tex registers string for InfLookup.StrCode32ToString
--have to manually replace usage in a module since Fox.StrCode32 cant be dynamically hooked
local StrCode32=Fox.StrCode32
function this.StrCode32(encodeString)
  local strCode=StrCode32(encodeString)
  if this.debugMode then
    if type(encodeString)~="string" then
      InfCore.Log("WARNING: InfCore.StrCode32: Attempting to encode a "..type(encodeString)..": "..tostring(encodeString))
      InfCore.Log("caller: "..this.DEBUG_Where(2))
    else
      local storedString=this.str32ToString[strCode]
      if storedString and storedString~=encodeString then
        InfCore.Log("WARNING: InfCore.StrCode32: Collision "..tostring(storedString).." and "..tostring(encodeString).." both hash to "..tostring(strCode))
      else
        this.str32ToString[strCode]=encodeString
      end
    end
  end
  return strCode
end

local GetGameObjectId=GameObject.GetGameObjectId
local NULL_ID=GameObject.NULL_ID
--SIDE: gameIdToName
--tex TODO: split gameIdToName into [objectType]={[name]=gameId]}
function this.GetGameObjectId(nameOrType,name)
  local gameId=NULL_ID
  if name then
    gameId=GetGameObjectId(nameOrType,name)--tex aparently doesnt work if param2 is null even if param1 is valis
  else
    gameId=GetGameObjectId(nameOrType)
  end
  local name=name or nameOrType
  if this.debugMode then
    if gameId~=NULL_ID then
      if type(name)~="string" then
        InfCore.Log("WARNING: InfCore.GetGameObjectId: Attempting to get gameId of a "..type(name)..": "..tostring(name))
        InfCore.Log("caller: "..this.DEBUG_Where(2))
      else
        local storedName=this.gameIdToName[gameId]
        if storedName and storedName~=name then
          InfCore.Log("WARNING: InfCore.GetGameObjectId: gameObjectId collision "..tostring(storedName).." and "..tostring(name))
        else
          this.gameIdToName[gameId]=name
        end
      end
    end
  end
  return gameId
end

--tex parses a string reference (SomeModule.someVar) and returns var
function this.GetStringRef(strReference)
  if type(strReference)~="string" then
    InfCore.Log("WARNING: InfCore.GetStringRef: strReference~=string",false,true)
    return nil,nil
  end
  local split=this.Split(strReference,".")
  if #split<2 then--tex <module>.<name>
    InfCore.Log("WARNING: InfCore.GetStringRef: #split<2 for "..tostring(strReference),false,true)
    return nil,nil
  end
  local moduleName=split[1]
  local module=_G[moduleName]
  if module==nil then
    InfCore.Log("WARNING: InfCore.GetStringRef: could not find module "..tostring(moduleName),false,true)
    return nil,nil
  end

  local referenceName=split[2]
  local reference=module[referenceName]
  if reference==nil then
    InfCore.Log("WARNING: InfCore.GetStringRef: could not find reference "..strReference,false,true)
    return nil,nil
  end
  --tex TODO: could probably keep recursing down split for nested references

  return reference,referenceName,moduleName
end

function this.GetModuleName(scriptPath)
  local split=this.Split(scriptPath,"/")
  local moduleName=split[#split]
  return string.sub(moduleName,1,-string.len(".lua")-1)
end

function this.LoadExternalModule(moduleName,isReload,skipPrint)
  this.Log("LoadExternalModule "..tostring(moduleName))
  local prevModule=_G[moduleName]
  if isReload then
    if prevModule and prevModule.PreModuleReload then
      InfCore.PCallDebug(prevModule.PreModuleReload)
    end
  end

  --tex clear so require reloads file, kind of defeats purpose of using require, but requires path search is more useful
  package.loaded[moduleName]=nil
  local sucess,module=pcall(require,moduleName)
  if not sucess then
    InfCore.Log("ERROR: "..module,false,true)
    --tex suppress on startup so it doesnt crowd out ModuleErrorMessage for user.
    if InfCore.doneStartup and not skipPrint then
      InfCore.Log("Could not load module "..moduleName)
    end
    return nil
  elseif type(module)=="table" then
    _G[moduleName]=module
  else
    InfCore.Log("InfCoreLoadExternalModule: ERROR: "..tostring(moduleName).. " is type "..type(module),false,true)
  end

  if isReload then
    if InfMain then
      InfMain.PostModuleReloadMain(module,prevModule)
    end
    if module.PostModuleReload then
      InfCore.PCallDebug(module.PostModuleReload,prevModule)
    end
  end

  return module
end

--tex for simple data modules without all the 'IH module' stuff
function this.LoadSimpleModule(path,fileName,box)
  local filePath=fileName and path..fileName or path

  local moduleChunk,loadError=LoadFile(filePath)--tex WORKAROUND Mock
  if loadError then
    local doDebugPrint=this.doneStartup--WORKAROUND: InfModelRegistry setup in start.lua is too early for debugprint
    InfCore.Log("Error loading "..filePath..":"..loadError,doDebugPrint,true,true)
    return
  end

  if box then
    local sandboxEnv={}
    if setfenv then--tex not in 5.2/MoonSharp, wasn't particularly rigorous about it anyway
      setfenv(moduleChunk,sandboxEnv)
    end
  end

  local module=moduleChunk()

  if module==nil then
    InfCore.Log("Error:"..filePath.." returned nil",true,true)
    return
  end

  return module
end

function this.RequireSimpleModule(moduleName)
  package.loaded[moduleName]=nil
  local module=require(moduleName)
  _G[moduleName]=module
  return module
end

--tex with external alternate
function this.DoFile(path)
  local scriptPath=InfCore.paths.mod..path

  local externLoaded=false
  if InfCore.FileExists(scriptPath) then
    InfCore.Log("Found external for "..scriptPath)
    local ModuleChunk,loadError=LoadFile(scriptPath)--tex WORKAROUND Mock
    if loadError then
      InfCore.Log("Error loading "..scriptPath..":"..loadError)
    else
      local Module=ModuleChunk()
      externLoaded=true
    end
  end
  if not externLoaded then
    dofile(path)
  end
end

--tex with alternate external loading
function this.LoadLibrary(path)
  this.Log("InfCore.LoadLibrary "..tostring(path),false,true)
  local scriptPath=InfCore.paths.mod..path
  local externLoaded=false
  if InfCore.FileExists(scriptPath) then
    InfCore.Log("Found external for "..path,false,true)--scriptPath)
    local ModuleChunk,loadError=LoadFile(scriptPath)--tex WORKAROUND Mock
    if loadError then
      InfCore.Log("ERROR: InfCore.LoadLibrary:"..scriptPath..":"..loadError,false,true)
    else
      local Module=this.PCall(ModuleChunk)
      if Module then
        local moduleName=this.GetModuleName(scriptPath)
        _G[moduleName]=Module
      end
      externLoaded=true
    end
  end
  if not externLoaded then
    Script.LoadLibrary(path)
  end
end

function this.OnLoadEvars()
  --  this.debugMode=ivars.debugMode==1--tex handled via DebugModeEnalbe
  this.debugOnUpdate=ivars.debugOnUpdate==1
  --tex TODO: this is not firing
  if not this.ihSaveFirstLoad then
    this.ihSaveFirstLoad=true
    if not this.debugMode then
      InfCore.Log("Further logging disabled while debugMode is off",false,true)
    end
  end
end

function this.GetLines(fileName,ignoreError)
  return InfCore.PCall(function(fileName,ignoreError)
    local lines
    local file,openError=open(fileName,"r")
    if not file or openError then
      if ignoreError then
      else
        --DEBUGNOW this.Log("ERROR: InfCore.GetLines: "..openError)
      end
      return
    end

    if file then
      if not openError then
        --tex lines crashes with no error, dont know what kjp did to io
        --      for line in file:lines() do
        --        if line then
        --          table.insert(lines,line)
        --        end
        --      end

        lines=file:read("*all")
      end
      file:close()
      if lines then
        if luaHostType=="LDT" then--KLUDGE differences in line end between implementations
          lines=this.Split(lines,"\n")
        else
          lines=this.Split(lines,"\r\n")
        end
        if lines[#lines]=="" then
          lines[#lines]=nil
        end
      end
    end
    return lines
  end,fileName)
end

--SIDE: this.paths, this.files, this.filesFull, this.ihFiles
function this.RefreshFileList()
  InfCore.LogFlow"InfCore.RefreshFileList"
  local path=this.paths.mod
  local ihFilesName=path..[[ih_files.txt]]
  --tex GOTACHA dir doesnt like alternate path seperators
  local cmd=[[cmd.exe /c dir /b /s "]]..string.gsub(path,"/","\\")..[[*.*" > "]]..string.gsub(ihFilesName,"/","\\")..[["]]
  InfCore.Log(cmd)
  if luaHostType=="MoonSharp" then
    this.ihFiles=io.GetFiles(path, "*.*")
  else
    this.PCall(function()os.execute(cmd)end)
    this.ihFiles=this.GetLines(ihFilesName)
  end
  if this.ihFiles==nil then
    InfCore.Log("ERROR: InfCore.RefreshFileList: this.ihFiles==nil",false,true)
    return
  end
  if #this.ihFiles==0 then
    InfCore.Log("ERROR: InfCore.RefreshFileList: #this.ihFiles==0",false,true)
    this.ihFiles=nil
    return
  end

    this.paths={
      mod=this.modPath,
    }
    this.files={
      mod={},
    }
    this.filesFull={
      mod={},
    }

    local stripLen=string.len(path)
    for i,line in ipairs(this.ihFiles)do
      this.ihFiles[i]=string.gsub(line,"\\","/")
    end
    for i,line in ipairs(this.ihFiles)do
      local subPath=string.sub(line,stripLen+1)
      local isFile=this.FindLast(subPath,".")~=nil
      local split=this.Split(subPath,"/")
      local isRoot=#split==1
      local subFolder=split[1]
      --InfCore.Log(subFolder)--tex DEBUG
      --InfCore.PrintInspect(split)--tex DEBUG
      if isRoot then
        subFolder="mod"
      end

      this.files[subFolder]=this.files[subFolder] or {}
      this.filesFull[subFolder]=this.filesFull[subFolder] or {}
      if not this.paths[subFolder] then
        local path=this.paths.mod..subFolder.."\\"
        path=string.gsub(path,"\\","/")
        this.paths[subFolder]=path
      end

      --tex MOCK, unity I think the real issue may be multiple periods
      if string.find(line,".meta") then
        isFile=false
      end

      if isFile then
        table.insert(this.files[subFolder],split[#split])
        line=string.gsub(line,"\\","/")
        table.insert(this.filesFull[subFolder],line)
      end
    end

  if this.debugModule then
    InfCore.PrintInspect(this.ihFiles,"ihFiles")
    InfCore.PrintInspect(this.paths,"paths")
    InfCore.PrintInspect(this.files,"files")
    InfCore.PrintInspect(this.filesFull,"filesFull")
  end
end

function this.GetFileList(files,filter,stripFilter)
  local fileNames={}
  if files==nil then
    InfCore.Log"ERROR: InfCore.GetFileList: files==nil"
    return fileNames
  end

  for i,fileName in ipairs(files) do
    local index=string.find(fileName,filter)
    if index then
      if stripFilter then
        fileNames[#fileNames+1]=string.sub(fileName,1,index-1)
      else
        fileNames[#fileNames+1]=fileName
      end
    end
  end
  return fileNames
end

local function GetGamePath()
  local gamePath=nil
  local paths=this.Split(package.path,";")
  for i,path in ipairs(paths) do
    if string.find(path,this.gameDirectory) then
      gamePath=path
      gamePath=string.gsub(gamePath,"\\","/")
      break
    end
  end
  --tex fallback if MGS_TPP\ couldnt be found in package.path
  if gamePath==nil then
    return[[C:/]]
  end

  local stripLength=10--tex length "\lua\?.lua"
  gamePath=gamePath:sub(1,-stripLength)
  return gamePath
end

this.saveName="ih_save.lua"
this.logFileName="ih_log"
this.toExtCmdsFileName="ih_toextcmds"
this.toMgsvCmdsFileName="ih_tomgsvcmds"
this.prev="_prev"

--hook
--tex no dice
--this.FoxLog=Fox.Log
--Fox.Log=function(message)
--  this.LogMessage(message)
--  this.FoxLog(message)
--end

--local print=print
--print=function(...)
--  InfCore.Log(...,true)
--  print(...)
--end

--EXEC
--package.path=""--DEBUG kill path for fallback testing
this.gamePath=GetGamePath()
this.modPath=this.gamePath..this.modSubPath.."/"
this.paths={
  mod=this.modPath,
}
this.files={
  mod={},
}
this.filesFull={
  mod={},
}
this.ihFiles=nil

this.logFilePath=this.paths.mod..this.logFileName..".txt"
this.logFilePathPrev=this.paths.mod..this.logFileName..this.prev..".txt"

this.toExtCmdsFilePath=this.paths.mod..this.toExtCmdsFileName..".txt"
this.toMgsvCmdsFilePath=this.paths.mod..this.toMgsvCmdsFileName..".txt"
local error=this.ClearFile(this.paths.mod,this.toExtCmdsFileName,".txt")
local error=this.ClearFile(this.paths.mod,this.toMgsvCmdsFileName,".txt")

this.CopyFileToPrev(this.paths.mod,this.logFileName,".txt")
local error=this.ClearFile(this.paths.mod,this.logFileName,".txt")

if error then
  if isMockFox then
    print(error)
  end
  this.modDirFail=true
else
  local time=os.date("%x %X")
  this.Log("InfCore start "..time)
  this.Log(this.modName.." r"..this.modVersion)

  this.PCall(this.RefreshFileList)
  if this.ihFiles==nil then
  --while(true)do
  --coroutine.yield()--tex init isnt a coroutine
  --end
  end
  --tex TODO: critical halt on stuff that should exist, \mod, saves

  local packagePaths={
    "modules",
  }
  local modulePaths={}
  local addPaths=""
  for i,packagePath in ipairs(packagePaths)do
    if not this.paths[packagePath]then
      this.Log("ERROR: could not find paths["..packagePath.."]",false,true)
    else
      addPaths=addPaths..";"..this.paths[packagePath].."?.lua"
      modulePaths[#modulePaths+1]=this.paths[packagePath].."?.lua"
    end
  end
  package.path=package.path..addPaths
  package.path=string.gsub(package.path,"\\","/")
  this.Log("package.path:"..package.path)

  --tex isMockFox
  if luaHostType=="MoonSharp" then
    SetModulePaths(modulePaths)
  end
  --tex WORKAROUND Mock
  if not LoadFile then
    LoadFile=loadfile
  end

  this.CopyFileToPrev(this.paths.saves,"ih_save",".lua")--tex TODO rethink, shift to initial load maybe
  local error=this.ClearFile(this.paths.mod,this.toExtCmdsFileName,".txt")
end

return this
