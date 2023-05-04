-- DOBUILD: 1
-- InfHooks.lua
-- tex also search HOOK in other modules for some manual hooks
-- Currently most hooks (and direct calls to IH from base game modules functions) go through InfMain > IH modules
-- Upside of this is you can look at InfMain to see of the hooks
-- Downside is its a bit monolythic/at a glance not iding the original function module, 
-- but the alternate would probably be to have Inf versions of all the base game files, which is kind of already true for a lot of the main ones.
local this={}

local InfCore=InfCore
local PCall=InfCore.PCall
local Log=InfCore.Log
local LogFlow=InfCore.LogFlow
local stringFormat=string.format

this.debugHooksEnabled=false

--tex GOTCHA be cautious when hooking scripts that can be reloaded (like scriptblocks or IH external modules)
--scriptblocks are also more likely to cause yield across c-call boundary.
--pre-hooking (calling your hook function before the original function) will allow multiple-return functions to return as normal
--can also isolate your hook function in a pcall to isolate it crashing from impacting the original function
this.hookFuncs={
  TppSave={
    --CULL
    --    VarRestoreOnMissionStart=function()
    --      InfCore.LogFlow("InfHook TppSave.VarRestoreOnMissionStart")
    --      this.TppSave.VarRestoreOnMissionStart()
    --      --post-hook
    --      IvarProc.OnLoadVarsFromSlot()
    --    end,
    VarRestoreOnContinueFromCheckPoint=function()
      InfCore.LogFlow("InfHook TppSave.VarRestoreOnContinueFromCheckPoint")
      this.TppSave.VarRestoreOnContinueFromCheckPoint()

      IvarProc.OnLoadVarsFromSlot()
    end,
    DoSave=function(saveParams,force)
      InfCore.LogFlow("InfHook TppSave.DoSave force:"..tostring(force))--tex dosave is either through the following Save<bleh>Data functions directly(rarely, you see the logging of that function directly above if it is) or enqued by the same functions (where youll see the function names logged higher up) to happen next Update > ProcessSaveQueue or OnAllocate > WaitingAllEnqueuedSaveOnStartMission 
      if TppSave.debugModule then
        InfCore.PrintInspect(saveParams,"TppSave.DoSave saveParams")
      end
      local saveResult=this.TppSave.DoSave(saveParams,force)
      --OFF IvarProc.OnSave(saveParams,force)--tex hookin on this level catches savepersonaldata called in init_sequence can throw spanner in works for some of the stuff we want to do during load, so hooking
      InfCore.LogFlow("/InfHook TppSave.DoSave done")--tex just to make it clear that function completed and not an issue, since this is often one of the last things logged on load hangs.
      return saveResult
    end,
    --tex all DoSave or EnqueSave (which triggers DoSave
    MakeNewGameSaveData=function(acquirePrivilegeInTitleScreen)
      InfCore.LogFlow("InfHook TppSave.MakeNewGameSaveData acquirePrivilegeInTitleScreen:"..tostring(acquirePrivilegeInTitleScreen))
      IvarProc.MakeNewGameSaveData(acquirePrivilegeInTitleScreen)
      this.TppSave.MakeNewGameSaveData(acquirePrivilegeInTitleScreen)
    end,
    SaveGameData=function(missionCode,needIcon,doSaveFunc,reserveNextMissionStartSave,isCheckPoint)
      InfCore.LogFlow("InfHook TppSave.SaveGameData")
      IvarProc.OnSave(missionCode,needIcon,doSaveFunc,reserveNextMissionStartSave,isCheckPoint)--tex don't know if want before or after
      this.TppSave.SaveGameData(missionCode,needIcon,doSaveFunc,reserveNextMissionStartSave,isCheckPoint)
    end,
    SaveConfigData=function(needIcon,doSave,reserveNextMissionStart)
      InfCore.LogFlow("InfHook TppSave.SaveConfigData")
      this.TppSave.SaveConfigData(needIcon,doSave,reserveNextMissionStart)
    end,
    SavePersonalData=function(needIcon,doSave,reserveNextMissionStartSave)
      InfCore.LogFlow("InfHook TppSave.SavePersonalData")
      this.TppSave.SavePersonalData(needIcon,doSave,reserveNextMissionStartSave)
    end,
  --tex no go for some reason.
  --  LoadGameDataFromSaveFile=function(area)
  --    return InfCore.PCall(function(area)--DEBUG
  --    --InfCore.LogFlow("InfHook TppSave.LoadGameDataFromSaveFile("..tostring(area)..")")
  --    local loadResult=this.LoadGameDataFromSaveFile(area)


  --    return loadResult
  --    end,area)--DEBUG
  --  end,
  },
  TppSequence={
    RegisterSequenceTable=function(sequences)--tex hooking just for debugging at the moment, since TppSequence not in buils, also since it builds mvars.seq_sequenceTable could futz with that if needs be
      InfCore.LogFlow("InfHook TppSequence.RegisterSequenceTable")
      this.TppSequence.RegisterSequenceTable(sequences)
      if TppSequence.debugModule then
        InfCore.PrintInspect(mvars.seq_sequenceNames,"mvars.seq_sequenceNames")
        InfCore.PrintInspect(sequences,"<mission>_sequence sequences")
      end
    end,
    SetNextSequence=function(sequenceName,params)
      local currentId=svars.seq_sequence
      local prevName=""
      if currentId then
        prevName=TppSequence.GetSequenceNameWithIndex(currentId)
      end
      InfCore.Log("TppSequence.SetNextSequence from "..prevName.." to "..sequenceName)
      this.TppSequence.SetNextSequence(sequenceName,params)
    end,
  },
  TppRanking={
    UpdateShootingPracticeClearTime=function(questNameAsRankingCategory,scoreTime)
      InfShootingPractice.UpdateShootingPracticeClearTime(questNameAsRankingCategory,scoreTime)
    end,
  },--TppRanking
}--hookFuncs

this.debugPCallHooks={
  TppAnimal={
    OnActivateQuest=true,
    OnDeactivateQuest=true,
    CheckQuestAllTarget=true,
  },
  TppEnemy={
    OnActivateQuest=true,
    OnDeactivateQuest=true,
    CheckQuestAllTarget=true,
    DefineSoldiers=true,
    SetUpSoldiers=true,
    ClearDDParameter=true,
    PrepareDDParameter=true,
    SetUpDDParameter=true,
    ChangeRouteUsingGimmick=true,--tex TODO see if/when this hits
  },
  TppGimmick={
    OnActivateQuest=true,
    OnDeactivateQuest=true,
    CheckQuestAllTarget=true,
  },
  TppMission={
    ExecuteMissionFinalize=true,
    MissionFinalize=true,
    MissionGameEnd=true,
    OnCanMissionClear=true,
    ReserveMissionClear=true,
    UpdateObjective=true,
    ShowUpdateObjective=true,
  },
  TppQuest={
    OnMissionGameEnd=true,
    UnloadCurrentQuestBlock=true,
    UpdateActiveQuest=true,
  },
  TppResult={
    GetMbMissionListParameterTable=true,
  },
  TppRevenge={
    SetUpEnemy=true,
  },
  TppScriptBlock={
    InitScriptBlockState=true,
    FinalizeScriptBlockState=true,
    ActivateScriptBlockState=true,
    DeactivateScriptBlockState=true,
    RequestActivate=true,
    Load=true,
    Unload=true,
    SaveScriptBlockId=true,
    PreloadRequestOnMissionStart=true,
    PreloadSettingOnMissionStart=true,
    ReloadScriptBlock=true,
    ResolveSavedScriptBlockInfo=true,
  },
  TppSequence={
    ReserveNextSequence=true,
  },
  TppUI={
    FadeIn=true,
    FadeOut=true,
  },
}--debugPCallHooks

function this.GetFunction(moduleName,functionName)
  local originalModule=_G[moduleName]
  local originalFunction=nil
  if not originalModule then
    InfCore.Log("WARNING: InfHooks.GetFunction could not find module:"..tostring(moduleName),false,true)
  else
    originalFunction=originalModule[functionName]
    if originalFunction==nil then
      InfCore.Log("WARNING: InfHooks.GetFunction could not find function:"..moduleName.."."..tostring(functionName),false,true)
    end
  end
  return originalModule,originalFunction
end

function this.AddHook(moduleName,functionName,hookFunction)
  local originalModule,originalFunction=this.GetFunction(moduleName,functionName)
  if originalModule and originalFunction then
    if type(hookFunction)~="function" then
      InfCore.Log("ERROR: InfHook.AddHook("..moduleName..","..functionName..") hookFunc is not a function")
    else
      this[moduleName]=this[moduleName]or{}--tex existing or new
      local moduleHooks=this[moduleName]
      if moduleHooks[functionName] then
        --tex TODO: just swap out existing hook using original, but log a warning
        InfCore.Log("ERROR: InfHook.AddHook: attempting to add a hook to a previously hooked function: "..moduleName.."."..functionName)
      else
        moduleHooks[functionName]=originalFunction--tex save original function ref
        originalModule[functionName]=hookFunction--tex override
      end
    end
  end
end

function this.RemoveHook(moduleName,functionName)
  local hookedModule,hookedFunction=this.GetFunction(moduleName,functionName)
  if hookedModule and hookedFunction then
    local moduleHooks=this[moduleName]
    if not moduleHooks then
      InfCore.Log("ERROR: InfHook.RemoveHook cannot find any hooks for module: "..moduleName.."."..functionName)
    else
      local originalFunction=moduleHooks[functionName]
      if not originalFunction then
        InfCore.Log("ERROR: InfHook.RemoveHook cannot find any hook for function: "..moduleName.."."..functionName)
      else
        hookedModule[functionName]=originalFunction--tex restore
        moduleHooks[functionName]=nil--tex clear
      end
    end
  end
end
--UNUSED
function this.CreatePreHookShim(moduleName,functionName,hookFunction)
  local originalModule,originalFunction=this.GetFunction(moduleName,functionName)
  if originalModule and originalFunction then
    local ShimFunction=function(...)
      hookFunction(...)
      return originalFunction(...)
    end
    return ShimFunction
  end
  return nil
end
--UNUSED
--tex TODO: sort out multi return, and original return vs hooked
function this.CreatePostHookDebugShim(moduleName,functionName,hookFunction)
  local flowFmt="HookPost %s.%s(%s)"
  local originalModule,originalFunction=this.GetFunction(moduleName,functionName)
  if originalModule and originalFunction then
    local ShimFunction=function(...)
      local argsStrings={}
      local args=InfUtil.pack2(...)
      for i=1,args.n do
        argsStrings[#argsStrings+1]=tostring(args[i])
      end
      local argsString=table.concat(argsStrings,",")
      InfCore.LogFlow(stringFormat(flowFmt,moduleName,functionName,argsString))
      local ret=PCall(originalFunction,...)
      local hookRet=PCall(hookFunction,...,ret)

      return hookRet or ret
    end
    return ShimFunction
  end
  return nil
end

--tex for wrapping a function in PCall and giving an LogFlow call
--GOTCHA: this tail call setup means names will be eaten in stack dump
function this.CreateDebugWrap(moduleName,functionName)
  local flowFmt="%s.%s(%s) [InfHook Pre]"
  local originalModule,originalFunction=this.GetFunction(moduleName,functionName)
  if not originalModule or not originalFunction then
    return nil
  end
  --upvalue opt
  local argsStrings={}--tex we can reuse table since we are getting args length
  local ShimFunction=function(...)
    local args={...}
    local argsN=select("#",...)--tex gets actual size including nils
    for i=1,argsN do
      argsStrings[i]=tostring(args[i])--tex concat doesnt like nil
    end
    LogFlow(stringFormat(flowFmt,moduleName,functionName,table.concat(argsStrings,",",1,argsN)))
    return PCall(originalFunction,...)
  end
  return ShimFunction
end--CreateDebugWrap

function this.SetupDebugHooks()
  InfCore.LogFlow("InfHooks.SetupDebugHooks:")
  if not this.debugHooksEnabled then
    this.debugHooksEnabled=true
    this.AddDebugHooks(this.debugPCallHooks,true)
  end
end

--hookDef table format: this.debugPCallHooks
function this.AddDebugHooks(hookDef,enable)
  InfCore.LogFlow("InfHooks.AddDebugHooks:")
  for moduleName,moduleHooks in pairs(hookDef)do
    for functionName,hookInfo in pairs(moduleHooks)do
      if hookInfo==true then
        local originalModule,originalFunction=this.GetFunction(moduleName,functionName)
        if originalModule and originalFunction then
          if enable then
            local wrapper=this.CreateDebugWrap(moduleName,functionName)
            this.AddHook(moduleName,functionName,wrapper)
          else
            this.RemoveHook(moduleName,functionName)
          end
        end
      end
    end
  end
end

--IN: this.hookFuncs
function this.AddHooks()
  InfCore.LogFlow("InfHooks.AddHooks:")
  for moduleName,moduleHooks in pairs(this.hookFuncs)do
    for functionName,hookFunction in pairs(moduleHooks)do
      this.AddHook(moduleName,functionName,hookFunction)
    end
  end
end--AddHooks

--this.AnnounceLogView=TppUiCommand.AnnounceLogView
--TppUiCommand.AnnounceLogView=function(message)
--  this.AnnounceLogView(message)
--end
--
--this.AnnounceLogViewLangId=TppUiCommand.AnnounceLogViewLangId
--TppUiCommand.AnnounceLogViewLangId=function(...)
--  this.AnnounceLogViewLangId(...)
--end
--
--this.AnnounceLogViewJoinLangId=TppUiCommand.AnnounceLogViewJoinLangId
--TppUiCommand.AnnounceLogViewJoinLangId=function(...)
--  this.AnnounceLogViewJoinLangId(...)
--end

return this
