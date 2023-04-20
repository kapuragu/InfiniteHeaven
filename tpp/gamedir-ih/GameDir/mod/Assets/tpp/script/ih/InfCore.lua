-- InfCore.lua
local this={}
--LOCALOPT
local pcall=pcall
local type=type
local open=io.open
local tostring=tostring
local table=table
local concat=table.concat
local string=string
local unpack=unpack
--CULL local GetElapsedTime=Time.GetRawElapsedTimeSinceStartUp
local GetElapsedTime=os.clock--GOTCHA: os.clock wraps at ~4,294 seconds
--tex not gonna change at runtime so can cache
local _IHHook=_IHHook
local IHH=IHH
local isMockFox=isMockFox
local luaHostType=luaHostType

local InfCore=this

this.modVersion=262
this.modName="Infinite Heaven"
this.hookVersion=17--tex for version check

this.gameId="TPP"
this.gameDirectory="MGS_TPP"
this.gameProcessName="mgsvtpp"
this.modSubPath="mod"
this.defaultGamePath="C:\\Program Files (x86)\\Steam\\steamapps\\common\\MGS_TPP\\"--tex only covers english windows installs, but it's better than nothing
--
this.saveName="ih_save.lua"
this.logFileName="ih_log"
this.toExtCmdsFileName="ih_toextcmds"
this.toMgsvCmdsFileName="ih_tomgsvcmds"
this.prev="_prev"

--STATE
this.debugModule=false

this.session=os.time()--tex using os.time as session id
this.extSession=0

this.debugMode=true--tex starts on so some debug logging can be done at startup, and before Ivars is actually running, set via InfMain.DebugModeEnable, and later set by the Ivar value in InfMain.OnAllocateTop
--tex TODO combine into loadState
this.doneStartup=false
this.modDirFail=false
this.ihSaveFirstLoad=false
this.gameSaveFirstLoad=false
this.mainModulesOK=false
this.otherModulesOK=false

this.log={}--tex non IHH logging
--tex old, non IHH, IPC via text
this.mgsvToExtCommands={}
this.mgsvToExtCount=0
this.mgsvToExtComplete=0--tex min/confirmed executed by ext, only commands above this should be written out
this.extToMgsvComplete=0--tex min/confirmed executed by mgsv

this.logErr=""
this.str32ToString={}
this.path32ToString={}
this.unknownStr32={}
this.unknownPath32={}
this.unknownMessages={}
this.gameIdToName={}
--tex set up during EXEC at end
this.ihFiles=nil
this.paths=nil
this.files=nil
this.filesFull=nil
--tex loaded modules just so we can take stocktake
--per method [path]="loaded" or loadError
this.loadedModules={
  DoFile={},
  LoadLibrary={},
  LoadExternalModule={},
  LoadSimpleModule={},
}--loadedModules
--
this.gamePath=nil
--
this.logFilePath=nil
this.logFilePathPrev=nil
this.toExtCmdsFilePath=nil
this.toMgsvCmdsFilePath=nil
--
local nl="\r\n"

local stringType="string"
local functionType="function"

--tex logging
this.logLevels = {
  [0]="trace",
  [1]="debug",
  [2]="info",
  [3]="warn",
  [4]="error",
  [5]="critical",
  [6]="off",
}
this.level_trace=0--tex since ipairs is from 1
for level,name in ipairs(this.logLevels)do
  this["level_"..name]=level
  -- this.logLevels[name]=level--tex folding it back in/giving it lookup would be nicer, but adds another level of indirection for something thats called often
end

this.logLevel=this.level_trace--SYNC: ihhooks default tex starts at lowish level/verbose, then switches down to warn only unless debugmode on (in InfMain.DebugModeEnable)

function this.Log(message,announceLog,forceLog)
  if not this.debugMode and not forceLog then
    return
  end

  if announceLog then
    this.DebugPrint(message)
  end

  if IHH then
    IHH.Log(this.level_info,message)
    return
  end

  --tex legacy/non ihhook lua-side log
  local elapsedTime=GetElapsedTime()

  local line="|"..elapsedTime.."|"..message
  this.log[#this.log+1]=line

  if isMockFox and luaPrintIHLog then
    print(line)
  end

  this.WriteLog(this.logFilePath,this.log)
end

--tex WIP handling of log levels
--string message: message to log
--int level: logLevel as above, can use InfCore.level_<level name> as enum
--will default to level_info if nil
--WAS bool announceLog, see handling below for note on change
--bool forceLog: force logging reguardless of current logLevel - mostly used for user initiated logging of stuff like positions and other dev stuff
--TODO: still need to decide where to slap level into this, if and what order to have the legacy params
function this.LogWip(message,level,forceLog,announceLog)
  if level==nil then--tex the majority of InfCore.Log calls don't have level param set (log levels were only added after IHHook started dev)
    level=this.level_info
  elseif type(level)=="boolean" then--tex LEGACY level was bool announceLog, now warn and error are automatically announceLogged
    if level==true then
      level=this.level_warn--tex this fallback is close to the old behaviour
    else
      level=this.level_info
    end
    InfCore.Log("Developers: InfCore.Log announceLog bool is depreciated, either set to InfCore.level_warn or level_error to also announceLog this message, or manually do a DebugPrint/announcelog with your message.",InfCore.level_warn)
    --TODO: DEBUG_Where to help user locate the call?
    end

  if level<this.logLevel and not forceLog then
    return
  end

  --tex level_error, level_warn gets announcelogged to notify the user
  --TODO: this.announceLogLevel counterpart to logLevel, would only really useful for warn, error, off since anything lower would kill from spam
  if announceLog or level==4 or level==3 then
    this.DebugPrint(message)
  end

  if IHH then
    IHH.Log(level,message)
    return
  end

  --tex lua side log
  --TODO: match ihhooks no timestamp unless option turned on
  local elapsedTime=GetElapsedTime()
  local levelStr=this.logLevels[level]

  local line="|"..elapsedTime.."|"..levelStr..": "..message
  this.log[#this.log+1]=line

  if isMockFox and luaPrintIHLog then
    print(line)
  end

  this.WriteLog(this.logFilePath,this.log)
end--Log

--tex TODO convert to log level trace
function this.LogFlow(message)
  if not this.debugMode then
    return false
  end
  if ivars and ivars.debugFlow==0 then
    return
  end
  --  local stackLevel=2
  --  local stackInfo=debug.getinfo(stackLevel,"n")
  --  this.Log(tostring(stackInfo.name).."| "..message)
  this.Log(message)
end

function this.ClearLog()
  this.log={}
end

--GOTCHA since io open append doesnt appear to work ('Domain error') I'm writing the whole log to file on every Add
--which is naturally bad performance for a lot of frequent Adds.
function this.WriteLog(filePath,log)
  --tex cant log error to log if log doesnt log lol
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
  filePath=InfCore.UnfungePath(filePath)
  local logFile,openError=open(filePath,"w")
  if not logFile or openError then
    this.Log("ERROR: WriteStringTable:"..openError)
    return
  end

  logFile:write(concat(stringTable,nl))
  logFile:close()
end

this.WriteLines=this.WriteStringTable
-- function this.WriteLines(fileName,lines)
--   local f,err = io.open(fileName,"w")
--   if f==nil then
--     InfCore.Log("InfCore.Writelines ERROR: "..err)
--     return
--   else
--     for i,line in ipairs(lines)do
--       local t = f:write(line.."\n")
--     end
--     f:close()
--   end
-- end--WriteLines

--tex CULL unused
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
  --tex: trying to call to announcelog before its initialized will cause a hard crash. It's probably up during/before the init missions (1,5), just checking vars.missioncode suits purposes for now
  if vars.missionCode==nil or vars.missionCode==65535 then
    return
  end

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

--tex GOTCHA: Unlike regular pcall, handles returns of a successful call like a normal call, or nil on fail
--GOTCHA: but at the cost of more stuff falling into tail calls/function names being eaten when viewing stack dump, see PCallSingle
--real solution aparently is to disable tail calls in interpreterwhen debugging, but that's rocket surgery since its in the exe
--also see note below about stack traces
--SYNC: with PCallDebug if you edit either
function this.PCall(func,...)
  local result={pcall(func,...)}--tex NOTE: though this packs multiple returns into an array, you can't guarantee iterating via ipairs since a return value might be nil (ie non contiguous array)
  local sucess=table.remove(result,1)

  if not sucess then
    --tex do we want to do trace dump immediately, before anything happens to stack?
    --though really you're supposed to use xpcall if you want an accurate stack dump, but that's even more of a pain to use
    --since it's so limited in lua 5.1, not really usable in this generic setup we have here
    --NOTE: because of this, source line number is actually of function in line prior, as the first is the debug.traceback() call
    --NOTE: traceback is heavy perf (but then if you're erroring that's not really a consideration)
    local trace = debug.traceback() 
  
    local err=result[1]--tex on pcall fail only the error string in result[1] will exist

    if not IHH then--tex ihhook hooks pcall to log the error
      InfCore.Log("PCall: ERROR: "..err,false,true)
    end
    this.DebugPrint("PCall: ERROR: "..err)--tex since we cant roll it into the above Log call

    --tex TODO toggle this with a 'verbose' setting
    InfCore.Log("trace: "..tostring(trace),false,true)
    --tex simpler/alernative to full stack trace, see DEBUG_Where for explanation of why stack level 2 (really 3)
    --InfCore.Log("caller:"..this.DEBUG_Where(2))

    return--tex all current uses of InfCore.PCall with returns expect nil on fail
    --DEBUGNOW ej was saying some of the stuff he was trying to do has an issue with that?
    --https://github.com/TinManTex/InfiniteHeaven/issues/41
    --return sucess,err

    --tex WORKAROUND avoid tail call to help debugging, pcall is already heavy, so throwing in more indexing wont matter
  elseif this.debugMode and #result<=5 then
    return result[1],result[2],result[3],result[4],result[5]
  else
    return unpack(result)--returns multi return values--GOTCHA: this setup means in stack dump function will disapear into tail call (assuming this is somewhere in exec of an outer pcall fail)
  end
end--PCall

--tex: (pre 259 style) only handles single return, but name doesnt disapear into tail call on stack dump
--function this.PCallSingle(func,...)
--  local sucess,result=pcall(func,...)
--  if not sucess then
--    --tex do we want to do trace dump immediately, before anything happens to stack?
--    --though really you're supposed to use xpcall if you want an accurate stack dump, but that's even more of a pain to use
--    --NOTE: because of this, source line number is actually of function in line prior, as the first is the debug.traceback() call
--    --NOTE: traceback is heavy perf (but then if you're erroring that's not really a consideration)
--    local trace = debug.traceback() 
--
--    if not IHH then--tex ihhook hooks pcall to log the error
--      InfCore.Log("PCall: ERROR: "..result,false,true)
--    end
--    this.DebugPrint("PCall: ERROR: "..result)--tex since we cant roll it into the above Log call
--
--    --tex TODO toggle this with a 'verbose' setting
--    InfCore.Log("trace: "..tostring(trace),false,true)
--    --tex simpler/alernative to full stack trace, see DEBUG_Where for explanation of why stack level 2 (really 3)
--    --InfCore.Log("caller:"..this.DEBUG_Where(2))
--
--    return--tex all current uses of InfCore.PCall with returns expect nil on fail
--  else
--    return result
--  end
--end--PCall

--tex as above but intended to pass through unless debugmode on
--NOTE: this is implemented as a copy of PCall (except for the not debugmode early out) rather than just calling it,
--because returning function call eats debug info, see GOTCHA: on this.PCall above
--so SYNC: with PCall if you edit either
function this.PCallDebug(func,...)
  if not this.debugMode then
    return func(...)
  end

  --PCall
  local result={pcall(func,...)}--tex NOTE: though this packs multiple returns into an array, you can't guarantee iterating via ipairs since a return value might be nil (ie non contiguous array)
  local sucess=table.remove(result,1)

  if not sucess then
    --tex do we want to do trace dump immediately, before anything happens to stack?
    --though really you're supposed to use xpcall if you want an accurate stack dump, but that's even more of a pain to use
    --NOTE: because of this, source line number is actually of function in line prior, as the first is the debug.traceback() call
    --NOTE: traceback is heavy perf (but then if you're erroring that's not really a consideration)
    local trace = debug.traceback() 
  
    local err=result[1]--tex on pcall fail only the error string in result[1] will exist

    if not IHH then--tex ihhook hooks pcall to log the error
      InfCore.Log("PCall: ERROR: "..err,false,true)
    end
    this.DebugPrint("PCall: ERROR: "..err)--tex since we cant roll it into the above Log call

    --tex TODO toggle this with a 'verbose' setting
    InfCore.Log("trace: "..tostring(trace),false,true)
    --tex simpler/alernative to full stack trace, see DEBUG_Where for explanation of why stack level 2 (really 3)
    --InfCore.Log("caller:"..this.DEBUG_Where(2))

    return--tex all current uses of InfCore.PCall with returns expect nil on fail
    --DEBUGNOW ej was saying some of the stuff he was trying to do has an issue with that?
    --https://github.com/TinManTex/InfiniteHeaven/issues/41
    --return sucess,err
    --tex WORKAROUND avoid tail call to help debugging, pcall is already heavy, so throwing in more indexing wont matter
  elseif this.debugMode and #result<=5 then
    return result[1],result[2],result[3],result[4],result[5]
  else
    return unpack(result)--returns multi return values--GOTCHA: this setup means in stack dump function will disapear into tail call (assuming this is somewhere in exec of an outer pcall fail)
  end
  --PCall
end--PCallDebug
--tex (pre 259 style) single return, but name doesnt disapear into tail call on stack dump
--function this.PCallDebugSingle(func,...)
--  local result
--  if not this.debugMode then
--    result=func(...)--tex avoid tail call
--    return result
--  else
--    --tex avoid tail call
--    result=this.PCallSingle(func,...)
--    return result 
--  end
--end

local emptyTable={}
function this.PrintInspect(var,options)
  if not this.debugMode and (not options or not options.force) then
    return
  end
  options=options or emptyTable
  local varName=options.varName or options
  local ins=InfInspect.Inspect(var)
  if type(varName)=="string" then
    ins=varName.."=" ..ins
--tex TODO perf test on large strings
--    local pre=varName.."=" 
--    local post=""
--    if ins:len()>500 then--tex magic number
--      post="--"..varName.." <end"
--    end
--    ins=table.concat({varName,"=",ins,post})
  end
  this.Log(ins,options.announceLog)
end--PrintInspect
--tex duplicated from InfUtil because I need it before its up
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
  this.extSession=1--tex WORKAROUND: will get updated when IHExt has started, but must be non 0 for IH to actually run ProcessCommands. Wasn't nessesary when I was pulling line 1 messageId as the sessionId, but that has been shifted to a extSession command from IHExt

  if IHH then
    local announceLogPrint=true
    InfCore.Log("Use IHHook menu instead",announceLogPrint)
    return
  end

  local programPath = this.paths.mod.."IHExt.exe"
  --programPath = [["D:\GitHub\IHExt\IHExt\bin\Debug\IHExt.exe"]]--DEBUG

  if not programPath then
    this.extSession=0
    InfCore.Log("WARNING: StartIHExt: Could not find IHExt.exe in "..this.gameDirectory.."\\"..this.modSubPath.."\\",false,true)
    return
  end

  local strCmd = 'start "" "'..programPath..'" "'..this.gamePath..'" '..this.modSubPath..' '..this.gameProcessName
  InfCore.Log(strCmd,false,true)
  this.PCall(function()os.execute(strCmd)end)
end--StartIHExt

function this.UseAdvancedMenu()
  if IHH and IHH.menuInitialized then
    return true
  else--tex IHExt DEBUGNOW KILL once IHHook takes over
    return ivars and ivars.enableIHExt>0 and this.extSession~=0
  end
end

--DEBUGNOW replace with above and have a seperate usepipe function just running of extSession check
function this.IHExtRunning()
  --KLUDGE
  if IHH then
    if IHH.menuInitialized then
      return true
    end
  else
    return ivars and ivars.enableIHExt>0 and this.extSession~=0
  end
  return false
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


-- WIP UNUSED
function this.IHHMenuCommand(cmd,...)
  if not IHH and IHH.menuInitialized then
    return
  end
  
  local args={...}--tex GOTOCHA doesnt catch intermediary params that are nil
  local mgsvToExtCurrent=1--DEBUGNOW cull once you've shifted all menuCommands away from parsing first arg as mgsvToExtCurrent, or add a replacement so you're not trampling pipes
  local message=mgsvToExtCurrent..'|'..cmd
  if #args>0 then
    message=message..'|'..concat(args,'|')
  end

  if this.debugModule then
    InfCore.Log("IHHMenuCommand: cmd:"..tostring(cmd).."<> message:"..tostring(message))
  end
  
  IHH.MenuMessage(cmd,message)
end--IHHMenuCommand

--KLUDGE DEBUGNOW cull once shifted to using .IHHMenuCommand()
local menuCommands={
  --Shutdown
  --TakeFocus
  --CanvasVisible
  --CreateUiElement
  --RemoveUiElement
  SetContent=true,
  SetText=true,
  SetTextBox=true,
  UiElementVisible=true,
  ClearTable=true,
  AddToTable=true,
  UpdateTable=true,
  SelectItem=true,
  ClearCombo=true,
  AddToCombo=true,
  SelectCombo=true,
  SelectAllText=true,
  EnableCursor=true,
}

--tex queues up cmd, use WriteToExtTxt to actually write/sends
function this.ExtCmd(cmd,...)
  if not IHH and not this.IHExtRunning() then--DEBUGNOW
    return
  end
  
  local useIHHMenu = IHH and IHH.menuInitialized
  --tex ihExt hasnt started
  if this.extSession==0 and not useIHHMenu then
    return
  end

  local mgsvToExtCurrent=this.mgsvToExtCount+1

  local args={...}--tex GOTOCHA doesnt catch intermediary params that are nil
  local message=mgsvToExtCurrent..'|'..cmd
  if #args>0 then
    message=message..'|'..concat(args,'|')
  end

  if this.debugModule then
    InfCore.Log("ExtCmd: cmd:"..tostring(cmd).."<> message:"..tostring(message))
  end
  
  if IHH then
    if useIHHMenu and menuCommands[cmd] then
      IHH.MenuMessage(cmd,message)
    else
      IHH.QueuePipeOutMessage(message)
    end
  else
    this.mgsvToExtCount=mgsvToExtCurrent
    this.mgsvToExtCommands[mgsvToExtCurrent]=message
  end
end

function this.MenuCmd(cmd,...)
  if not IHH and not IHH.menuInitialized then
    return
  end
  
  local mgsvToExtCurrent=this.mgsvToExtCount+1--DEBUGNOW

  local args={...}--tex GOTOCHA doesnt catch intermediary params that are nil
  local message=mgsvToExtCurrent..'|'..cmd
  if #args>0 then
    message=message..'|'..concat(args,'|')
  end

  if this.debugModule then
    InfCore.Log("MenuCmd: cmd:"..tostring(cmd).."<> message:"..tostring(message))
  end
  
  IHH.MenuMessage(cmd,message)
end

--tex LEGACY, InfProcessExt was deleted r218 but the file may linger if the user didnt uninstall correctly using snakebite (or if snakebite messed up)
function this.DoToMgsvCommands()
end

local concat=table.concat
local nl="\r\n"
function this.WriteToExtTxt()
  --tex uses pipe
  if IHH then
    return
  end

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
--GOTCHA: still using debug_wheres stackLevel+1
--stack levels (with the +1 this func gives, still don't understand kjps reasoning with that):
-- -1 the debug.getinfo call itself
--0 Debug_Where
--1 the line that calls Debug_Where
--2 the function that calls Debug_Where (thus the common usage of DEBUG_Where(2))
--problem is when code gets fancy and is pcalling or something will likely just return the caller name as tail call
--at that point its better to just do a whole debug.traceback
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

--tex simple type validation, format is just {key name in data=(string)expected data type,...}
--TODO: expand to specify multi data types
--TODO: expand to specify required keys
function this.Validate(format,data,name)
  if format==nil or type(format)~="table" then
    InfCore.Log("InfCore.Validate "..tostring(name)..": Failed, is not a table" )
    return false
  end

  local valid=true
  for keyName,valueType in pairs(data)do
    local expectedType=format[keyName]
    if expectedType and type(data[keyName])~=expectedType then
      InfCore.Log("InfCore.Validate "..tostring(name)..": ERROR: Key \'"..tostring(keyName).."\' is a "..type(data[keyName]).." expected a "..tostring(expectedType))
      valid=false
    end
  end
  return valid
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
end--StrCode32

local PathFileNameCode32=Fox.PathFileNameCode32
function this.PathFileNameCode32(encodeString)
  local pathCode=PathFileNameCode32(encodeString)
  if this.debugMode then
   if type(encodeString)~="string" then
      InfCore.Log("WARNING: InfCore.PathFileNameCode32: Attempting to encode a "..type(encodeString)..": "..tostring(encodeString))
      InfCore.Log("caller: "..this.DEBUG_Where(2))
    else
      local storedString=this.path32ToString[pathCode]
      if storedString and storedString~=encodeString then
        InfCore.Log("WARNING: InfCore.PathFileNameCode32: Collision "..tostring(storedString).." and "..tostring(encodeString).." both hash to "..tostring(pathCode))
      else
        this.path32ToString[pathCode]=encodeString
      end
    end    
  end
  return pathCode
end--PathFileNameCode32

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
  moduleName=string.sub(moduleName,1,-string.len(".lua")-1)--tex strip ext
  return moduleName
end

--tex load non core module, in mod/modules, or internal /Assets/script/ih/ for release version (on the theory that loading it 'properly' using fox engines Script.LoadLibrary is better).
--tex TODO bit of a misnomer now that they can be loaded internally
--IN/SIDE: InfModules.externalModules
function this.LoadExternalModule(moduleName,isReload,skipPrint)
  InfCore.Log("LoadExternalModule "..tostring(moduleName).." isReload:"..tostring(isReload))
  local prevModule=_G[moduleName]
  if prevModule then
    if not isReload then
      InfCore.Log("Module "..moduleName.." already loaded and not isReload, so will not reload it",true)
      return
    elseif prevModule.PreModuleReload then
      InfCore.Log(moduleName..".PreModuleReload")
      InfCore.PCallDebug(prevModule.PreModuleReload)
    end
  end--if prevModule

  local loadMessage=nil
  local isExternal=false
  local module=nil
  local scriptPath=InfCore.gamePath..InfCore.modSubPath.."/modules/"..moduleName..".lua"
  if InfCore.FileExists(scriptPath)then--tex load external
    isExternal=true
    loadMessage="loaded external"
    --tex clear so require reloads file, kind of defeats purpose of using require, but requires path search is more useful
    --DEBUGNOW I'm building the path anyway now for FileExists check, so maybe change to a loadfile
    package.loaded[moduleName]=nil
    local sucess
    sucess,module=pcall(require,moduleName)
    if not sucess then
      loadMessage="require fail: "..tostring(module)
      module=nil--tex since we are falling through
      if not IHH then--tex ihhook already logs the error to ih_log (as well as its ihh_log)
        InfCore.Log("InfCore.LoadExternalModule ERROR: "..loadMessage,false,true)
      end
      this.DebugPrint(loadMessage)--tex since we cant roll it into the above Log call
      
      --tex suppress on startup so it doesnt crowd out ModuleErrorMessage for user.
      if InfCore.doneStartup and not skipPrint then
        InfCore.Log("Could not load module "..moduleName)
      end
    elseif type(module)=="table" then
      _G[moduleName]=module
    else
      --GOTCHA: making this a hard error
      InfCore.Log("InfCore.LoadExternalModule: ERROR: "..tostring(moduleName).. " is type "..type(module),true,true)
      loadMessage="module not a table"
      module=nil
    end
  else--tex load internal
    loadMessage="loaded internal"
    InfCore.Log("Found internal for "..tostring(moduleName))
    Script.LoadLibrary("/Assets/tpp/script/ih/"..moduleName..".lua")
    module=_G[moduleName]
    if not module then
      InfCore.Log("InfCore.LoadExternalModule: ERROR: module "..moduleName.." not in globals",true,true)
      loadMessage="Script.LoadLibrary did not set module Global"
    end
  end--if internal or external

  this.SetLoaded("LoadExternalModule",moduleName,loadMessage,isExternal)
  
  if not module then
    --InfCore.Log("ERROR: !module for "..moduleName,true,true)--tex should all be covered by above
    return
  end

  if isReload then
    if InfMain then
      InfMain.PostModuleReloadMain(module,prevModule)
    end
    if module.PostModuleReload then
      InfCore.Log(moduleName..".PostModuleReload")
      InfCore.PCallDebug(module.PostModuleReload,prevModule,isReload)
    end
  end

  return module
end--LoadExternalModule

--UNUSED CULL
--tex just load via script.loadlibrary, cant reload it
-- function this.LoadInternalModule(moduleName,isReload,skipPrint)
--   local path="/Assets/tpp/script/ih/module/"..moduleName..".lua"
--   Script.LoadLibrary(path)
-- end

--tex for simple data modules without all the 'IH module' stuff
function this.LoadSimpleModule(path,fileName,box)
  local filePath=fileName and path..fileName or path

  local moduleChunk,loadMessage=LoadFile(filePath)--tex WORKAROUND Mock
  if loadMessage then
    local doDebugPrint=this.doneStartup--WORKAROUND: InfModelRegistry setup in start.lua is too early for debugprint
    InfCore.Log("ERROR: InfCore.LoadSimpleModule: "..filePath..":"..loadMessage,doDebugPrint,true,true)
  else
    loadMessage="loaded external"
    if box then
      local sandboxEnv={}
      if setfenv then--tex not in 5.2/MoonSharp, wasn't particularly rigorous about it anyway
        setfenv(moduleChunk,sandboxEnv)
      end
    end
  end

  local module=moduleChunk()

  if module==nil then
    InfCore.Log("ERROR:"..filePath.." returned nil",true,true)
    loadMessage="chunk exec error"
  end

  local isExternal=true--tex TODO hmm
  this.SetLoaded("LoadSimpleModule",filePath,loadMessage,isExternal)

  return module
end--LoadSimpleModule
--UNUSED CULL
-- function this.RequireSimpleModule(moduleName)
--   package.loaded[moduleName]=nil
--   local module=require(moduleName)
--   _G[moduleName]=module
--   return module
-- end

--tex with external alternate, only used by init,start(2nd) and other mgsv bootup scripts
function this.DoFile(path)
  local scriptPath=InfCore.gamePath..InfCore.modSubPath.."/"..path
  local isExternal=false
  local loadMessage
  local ModuleChunk
  if InfCore.FileExists(scriptPath) then
    InfCore.Log("InfCore.DoFile: Found external for "..scriptPath)
    isExternal=true
  else
    scriptPath=path--tex just load what we were asked to
  end--DoFile

  --tex original just uses dofile, but might as well push everything through loadfile and log the errors
  ModuleChunk,loadMessage=LoadFile(scriptPath)--tex WORKAROUND Mock
  if loadMessage then
    InfCore.Log("Error loading "..scriptPath..":"..loadMessage,false,true)
  elseif isExternal then
    loadMessage="loaded external"
  else
    loadMessage="loaded internal"
  end

  this.SetLoaded("DoFile",path,loadMessage,isExternal)

  if ModuleChunk then
    return ModuleChunk()--tex DEBUGNOW this is standard dobuild, but that means we're not catching potential errors here
  end
end--DoFile

--tex with alternate external loading, fox engine does a bunch more management of scripts via LoadLibrary,
--so this probably should only be used for developing edits to the existing libraries externally, then moving them back internally when done.
--(though I'm currently using it to load IH Core to break start luas boxing or something?)
--OUT: _G[moduleName]=Module
function this.LoadLibrary(path)
  this.Log("InfCore.LoadLibrary "..tostring(path),false,true)
  local scriptPath=InfCore.paths.mod..path
  local isExternal=false
  local ModuleChunk
  local loadMessage=""

  if InfCore.FileExists(scriptPath) then
    InfCore.Log("Found external for "..path,false,true)--scriptPath)
    ModuleChunk,loadMessage=LoadFile(scriptPath)--tex WORKAROUND Mock
    if loadMessage then
      InfCore.Log("ERROR: InfCore.LoadLibrary:"..scriptPath..":"..loadMessage,false,true)
    else
      local Module=this.PCall(ModuleChunk)
      if Module then
        local moduleName=this.GetModuleName(scriptPath)
        _G[moduleName]=Module
        isExternal=true
        loadMessage="loaded external"
      else
        loadMessage="load external failed running ModuleChunk "
        --tex will fall back to internal
      end--if Module
    end--if LoadFile
  end--if FileExists
  if not isExternal then
    loadMessage=loadMessage.."loaded internal"
    Script.LoadLibrary(path)
  end
  --tex DEBUGNOW here isExternal represents if it managed to load, where other loaders its just if external exists
  this.SetLoaded("LoadLibrary",path,loadMessage,isExternal)
end--LoadLibrary
--tex just keeping tabs on what loaded for now
--OUT: this.loadedModules
--DEBUGNOW decide what you want isExternal to represent, at what point you want to set it
function this.SetLoaded(loaderName,path,loadMessage,isExternal)
  local existingEntry=this.loadedModules[loaderName][path]
  if existingEntry then
    InfCore.Log("SetLoaded "..loaderName.." "..path)
    InfCore.Log("existing loadedModules entry: "..existingEntry)
  end
  if loadMessage then
    this.loadedModules[loaderName][path]=loadMessage
  else
    InfCore.Log("WARNING: InfCore.SetLoaded: "..loaderName.." "..path..": no loadMessage")
    this.loadedModules[loaderName][path]="no loadMessage given"
  end
end--SetLoaded
function this.OnLoadEvars()
  --  this.debugMode=ivars.debugMode==1--tex handled via DebugModeEnalbe
  this.debugOnUpdate=ivars.debugOnUpdate==1
  --tex TODO: this is not firing
  if not this.ihSaveFirstLoad then
    this.ihSaveFirstLoad=true
    if not this.debugMode then
      InfCore.Log("Further non critical logging disabled while debugMode is off",false,true)
    else
      InfCore.Log("Non debug log cut-off point")
    end
  end
end

--loads and return lines of file into an array
--returns nil on error
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
end--GetLines

--tex writes a table out to file with text header
function this.WriteTable(fileName,header,t)
  if t==nil then
    return
  end
  InfCore.Log("WriteTable "..fileName)

  local lines={}
  if header then
    for i,line in ipairs(header)do
      table.insert(lines,line)
    end
  end
  local ins=InfInspect.Inspect(t)
  table.insert(lines,"local this="..ins)
  table.insert(lines,"return this")

  this.WriteStringTable(fileName,lines)
end--WriteTable

function this.UnfungePath(path)
  path=string.gsub(path,"\\","/")
  path=string.gsub(path,"//","/")
  return path
end--UnfungePath

--SIDE: this.paths, this.files, this.filesFull, this.ihFiles
function this.RefreshFileList()
  InfCore.LogFlow"InfCore.RefreshFileList"
  local modPath=this.paths.mod

  if IHH then
    this.ihFiles=IHH.GetModFilesList();
  --DEBUG
  --    InfCore.Log("getmodfiles")
  --    InfCore.Log("ihFiles:"..tostring(this.ihFiles))
  --    InfCore.Log("ipairs")
  --    for i,fileName in ipairs(this.ihFiles)do
  --      InfCore.Log(fileName)
  --    end
  --    InfCore.Log("pairs")
  --    for i,fileName in pairs(this.ihFiles)do
  --      InfCore.Log(i)
  --      InfCore.Log(fileName)
  --    end
  elseif luaHostType=="MoonSharp" then
    this.ihFiles=io.GetFiles(modPath, "*.*")
  else
    local ihFilesName=modPath..[[ih_files.txt]]
    local stdErrName=modPath..[[cmd_stderr.txt]]
    --tex GOTACHA dir doesnt like alternate path seperators
    --DEBUGNOW CULL local cmd=[[cmd.exe /c dir /b /s "]]..string.gsub(modPath,"/","\\")..[[*.*" > "]]..string.gsub(ihFilesName,"/","\\")..[["]]
    --tex DEBUGNOW for some people cmd is failing for some reason (actually running the command at a command prompt has no issue (for AtlasPhantom that tested)
    --piping out stderr (2>) shows:
    --'cmd.exe' is not recognized as an internal or external command, operable program or batch file.
    --(again AtlasPhantom), he was running with admin rights
    local cmd=[[cmd.exe /c dir /b /s "]]..string.gsub(modPath..[[*.*" > "]]..ihFilesName..[[" 2> "]]..stdErrName..[["]],"/","\\")
    InfCore.Log(cmd)

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
    mod=this.gamePath..this.modSubPath.."/",
  }
  this.files={
    mod={},
  }
  this.filesFull={
    mod={},
  }


  local stripLen=string.len(modPath)
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
    --DEBUGNOW Inspect wont be up when this is first run
    if InfInspect then
      InfCore.PrintInspect(this.ihFiles,"ihFiles")
      InfCore.PrintInspect(this.paths,"paths")
      InfCore.PrintInspect(this.files,"files")
      InfCore.PrintInspect(this.filesFull,"filesFull")
    end
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
--IN: package.path,this.gameDirectory,this.defaultGamePath,this.modSubPath,
local function GetGamePath()
  if IHH then
    IHH.GetGamePath()
  end

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
    local fallbackTest=this.defaultGamePath..this.modSubPath.."\\modules\\ih_files.txt"
    if this.FileExists(fallbackTest) then
      gamePath=this.defaultGamePath
      gamePath=string.gsub(gamePath,"\\","/")
      return gamePath
    end
    
    return[[C:/]]
  end

  local stripLength=10--tex length "\lua\?.lua"
  gamePath=gamePath:sub(1,-stripLength)
  return gamePath
end

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
if isMockFox then
  print("InfCore.gamePath:"..tostring(this.gamePath))
end
--tex full paths of each subfolder of MGS_TPP\mod (and mod itself), no subfolders of subfolders
this.paths={
  mod=this.gamePath..this.modSubPath.."/",
}
--tex filenames (incl extension) by subfolder name
this.files={
  mod={},
}
--tex pathfilenames by subfolder name
this.filesFull={
  mod={},
}
this.ihFiles=nil--tex pure list of pathfilenames, only created and used in RefreshFileList, only module member so it can be debug logged

--tex would only keep last error, but they'd all be the same anyway
local error=false
if not _IHHook then
  this.logFilePath=this.paths.mod..this.logFileName..".txt"
  this.logFilePathPrev=this.paths.mod..this.logFileName..this.prev..".txt"

  this.CopyFileToPrev(this.paths.mod,this.logFileName,".txt")
  error=this.ClearFile(this.paths.mod,this.logFileName,".txt")
end

this.toExtCmdsFilePath=this.paths.mod..this.toExtCmdsFileName..".txt"
this.toMgsvCmdsFilePath=this.paths.mod..this.toMgsvCmdsFileName..".txt"

if not IHH then
  error=this.ClearFile(this.paths.mod,this.toExtCmdsFileName,".txt")
  error=this.ClearFile(this.paths.mod,this.toMgsvCmdsFileName,".txt")
end

if error then
  if isMockFox then
    print(error)
  end
  this.modDirFail=true
else
  local time=os.date("%x %X")
  this.Log("InfCore Started: "..time)
  this.Log(this.modName.." r"..this.modVersion)

  --tex currently no hard depedancy on IHHook
  if _IHHook then 
    if _IHHook < this.hookVersion then
      this.Log("ERROR: IHHook version mismatch. IHHook version: "..tostring(_IHHook)..". Required version "..this.hookVersion,false,true);
    elseif _IHHook > this.hookVersion then
      this.Log("WARNING: IHHook version mismatch. IHHook version: "..tostring(_IHHook)..". Requested version "..this.hookVersion,false,true);
      this.Log("While IH will run on this version of IHHook fine, it may mean there's a more up to date version of IH available",false,true);
      this.Log("Check the 'Compatable IHHook version' on the IH nexus description page or readme",false,true);
    else
      this.Log("IHHook version "..tostring(_IHHook))
    end
  else
    this.Log("WARNING: IHHook not initialized")
  end
  
  this.Log("gamePath: "..this.gamePath)

  this.PCall(this.RefreshFileList)
  --tex TODO: critical halt on stuff that should exist, \mod, saves
  if this.ihFiles==nil then
  --while(true)do
  --coroutine.yield()--tex init isnt a coroutine
  --end
  end

  --tex a bit overkill since we're just adding mod/modules to paths
  local packagePaths={
    "modules",
  }
  local modulePaths={}--tex for moonsharp
  local addPaths=""
  for i,packagePath in ipairs(packagePaths)do
    if not this.paths[packagePath]then
      this.Log("ERROR: could not find paths["..packagePath.."]",false,true)
    else
      addPaths=addPaths..";"..this.paths[packagePath].."?.lua"
      modulePaths[#modulePaths+1]=this.paths[packagePath].."?.lua"--tex for moonsharp
    end
  end
  this.Log("package.path:"..package.path)
  package.path=package.path..addPaths
  package.path=string.gsub(package.path,"\\","/")
  this.Log("package.path modified:"..package.path)

  --tex isMockFox
  if luaHostType=="MoonSharp" then
    SetModulePaths(modulePaths)
  end
  --tex WORKAROUND Mock
  if not LoadFile then
    LoadFile=loadfile
  end

  this.CopyFileToPrev(this.paths.saves,"ih_save",".lua")--tex TODO rethink, shift to initial load maybe
  if not IHH then
    local error=this.ClearFile(this.paths.mod,this.toExtCmdsFileName,".txt")
  end
end

return this
