--IHDebugVars.lua
--tex for turning on .debugModules and a trashbag of debugging or testing stuff as I develop
--as well as supplying my dev menu

--tex GOTCHA: TODO: some modules have some debug logging gated behind a if this.debugModule condition.
--PostAllModulesLoad below will set debugModule to true for the modules named in this list.
--this however won't catch modules that use this.debugModule while loading,
--or stuff that the module has run before PostAllModulesLoad
--only real way round that would be to push .debugModules outside the module (like this list, but would need to be loaded before anything), 
--and have modules check that instead
--TODO: a runtime debugAllModules Ivar (don't forget vanilla modules too)
local debugModules={
  'TppMain',
  'TppPlayer',
  'InfFulton',
  'TppHero',
  'InfLookup',
  --'InfWeaponIdTable',
  'InfCore',
  --'InfExtToMgsv',
  --'InfMgsvToExt',
  'InfMain',
  --'InfMenu',
  --'InfMenuDefs',
  'IvarProc',
  --  'InfNPC',
  --'InfSoldierFaceAndBody',--GOTCHA: is loaded before this module, so you'll have to manually set debugMode in the file
  'InfQuest',
  'TppQuest',
  --  'TppQuest',
  'InfInterrogation',
  --  'InfMBGimmick',
  --'InfLookup',
  'InfMission',
  --'InfEquip',
  --'InfWalkerGear',
  --'InfSoldier',
  --'InfEneFova',
  --'InfMission',
  'InfNPC',
  'InfMainTpp',
  'Ivars',
  'TppEnemy',
  --'InfRouteSet',
  'TppRevenge',
  --'InfLZ',
  --'TppLandingZone',
  --'InfParasite',
  'InfGameEvent',
  'InfWeather',
  'InfLookup',
  'InfEmblem',
  'InfAvatar',
  'InfChimera',
  'InfEneFova',
  'InfTransition',
  'TppSave',
  'InfProgression',
  'InfPlayerParts',
  'InfPlayerCamo',
  'InfBodyInfo',
}

local this={}

this.packages={
  --[30050]="/Assets/tpp/pack/mission2/free/f30050/f30050_ly000_q30210.fpk",--DEBUGNOW
  --[30050]="/Assets/tpp/pack/mission2/ih/bgm_fob_ih.fpk",--DEBUGNOW
  --[30050]="/Assets/tpp/pack/mission2/free/f30050/f30050_ly000_q30210.fpk",--DEBUGNOW
  [30010]={
  --"/Assets/tpp/pack/mission2/ih/mgo_bgm.fpk",
  -- "/Assets/tpp/pack/mission2/ih/bgm_fob_ih.fpk",
  },--DEBUG    "C:\\Projects\\MGS\\InfiniteHeaven\\tpp\\fpk-mod-bgm-mgo",
  [30050]={
  --"/Assets/tpp/pack/mission2/ih/mgo_bgm.fpk",
  --  "/Assets/tpp/pack/mission2/ih/bgm_fob_ih.fpk",
  },--DEBUG    "C:\\Projects\\MGS\\InfiniteHeaven\\tpp\\fpk-mod-bgm-mgo",
--[30010]="/Assets/tpp/pack/mission2/ih/ih_extra_sol_test.fpk",
-- [30020]="/Assets/tpp/pack/mission2/ih/ih_extra_sol_test.fpk",
}

function this.AddMissionPacks(missionCode,packPaths)
  if this.packages[missionCode] then
    for i,path in ipairs(this.packages[missionCode])do
      packPaths[#packPaths+1]=path
    end
  end
end

--DEBUGNOW
function this.DumpSomething()
  local lines={
    }

  local function AddLine(line)
    table.insert(lines,line)
  end

  local WriteLines = function(fileName,lines)
    
    if not (io and io.open) then
      InfCore.Log("ERROR: IHDebugVars.DumpSomething io.open doesn't exist")
      return
    end
    local f,err = io.open(fileName,"w")
    if f==nil then
      InfCore.Log("ERROR: "..err)
      return
    else
      for i,line in ipairs(lines)do
        local t = f:write(line.."\n")
      end
      f:close()
    end
  end
  ---------

  ------------
  local fileName=[[C:\Projects\MGS\InfiniteHeaven\tpp\mod-gamedir\dumpsomething.txt]]

  WriteLines(fileName,lines)
end--DumpSomething


--DEBUGNOW
local GetGameObjectId=GameObject.GetGameObjectId
local SendCommand=GameObject.SendCommand

function this.PostAllModulesLoad()
  if isMockFox then
    InfCore.Log("isMockFox, returning:")
    return
  end

  this.SetDebugModules()

  InfCore.Log("mvars.mis_missionStateIsNotInGame"..tostring("mvars.mis_missionStateIsNotInGame"))
  --InfCore.PrintInspect(mvars.qst_questScriptBlockMessageExecTable,"mvars.qst_questScriptBlockMessageExecTable")

  --  InfCore.Log("getregistry")
  --  local registry=debug.getregistry()
  --  -- InfCore.PrintInspect(registry,"lua registry")--tex memory explosion, whatever Inspect is doing it dont like registry
  --
  --  for k,v in pairs(registry)do
  --    InfCore.Log("registry."..tostring(k).."="..tostring(v))
  --    if type(v)=="table"then
  --      for k2,v2 in pairs(v)do
  --        InfCore.Log("\t"..k.."."..tostring(k2).."="..tostring(v2))
  --      end
  --    end
  --  end
  --  InfCore.Log("registry end")

  --DEBUGNOW!!!!!!!!! use this.DebugAction instead

  --this.DumpSoldierInfo()

  --  TppEnemy.SetSaluteVoiceList=InfSoldier.SetMBSaluteVoiceList--DEBUGNOW
  --  InfSoldier.SetMBSaluteVoiceList()

  -- InfObjects.objectNames[1]="sol_ih_0135"
  --InfObjects.objectNames[2]="sol_ih_0128"
  --Ivars.selectSpeechSoldier:Set(0)
  --Ivars.selectSpeechSoldier2:Set(1)

  --  this.DumpSomething()


  --  TppEnemy.GetWeaponId=this.GetWeaponId
  --  TppEnemy.weaponIdTable.PF_A=weaponIdTable
  --  TppEnemy.weaponIdTable.PF_B=weaponIdTable
  --  TppEnemy.weaponIdTable.PF_C=weaponIdTable
  --  TppEnemy.weaponIdTable.DD=weaponIdTable
  --  TppEnemy.weaponIdTable.SOVIET_A=weaponIdTable
  --  TppEnemy.weaponIdTable.SOVIET_B=weaponIdTable
  --  TppEnemy.weaponIdTable.SKULL=weaponIdTable
  --  TppEnemy.weaponIdTable.MARINES_A=weaponIdTable
  --  TppEnemy.weaponIdTable.MARINES_B=weaponIdTable
  --  TppEnemy.weaponIdTable.MARINES_MIXED=weaponIdTable

  InfCore.PrintInspect("IHH")
  InfCore.PrintInspect(imgui,"imgui")

  this.SetDebugVars()

  -- InfCore.Log("IHDebugVars.PostAllModulesLoad:")
  -- print("testerino");

  --DEBUGNOW
  --https://www.lua.org/tests/
  local testPath="C:/Games/Steam/steamapps/common/MGS_TPP/mod/lua-test"
  _U=true--tex simple mode
  InfCore.PCallDebug(function()LoadFile(testPath.."/all.lua")end)

  -- winapi.shell_exec('open','C:/Games/Steam/steamapps/common/MGS_TPP/mod/')

  --= "currdirtest.lua"
  --  local f = loadfile(filename)
  -- return f(filename)
  --dofile()

  --DEBUGNOW
  local opentest = function(filename)
    if not (io and io.open) then
      InfCore.Log("ERROR: IHDebugVars.PostAllModulesLoad opentest io.open doesn't exist")
      return
    end
    local f,err = io.open(filename,"w")
    if f==nil then
      InfCore.Log("ERROR: "..err)
    else
      local t = f:write("blurgg")
      f:close()
    end
  end


  --tex relative paths cause an error 'Result too large',
  --I guess kjp has some kind of relative path==internal path? thing going on?
  --  InfCore.PCallDebug(opentest,"c:/temp/curredirtext1.txt")
  --  InfCore.PCallDebug(opentest,"/temp/curredirtext2.txt")
  --  InfCore.PCallDebug(opentest,"temp/curredirtext3.txt")
  --  InfCore.PCallDebug(opentest,"curredirtext4.txt")
  --  InfCore.PCallDebug(opentest,"./curredirtext5.txt")
  --  InfCore.PCallDebug(opentest,".curredirtext6.txt")
  --  InfCore.PCallDebug(opentest,"./temp/curredirtext7.txt")






  InfCore.PrintInspect(InfCore.ihFiles,"ihFiles")
  InfCore.PrintInspect(InfCore.paths,"paths")
  InfCore.PrintInspect(InfCore.files,"files")
  InfCore.PrintInspect(InfCore.filesFull,"filesFull")


  this.PrintUpdateTimes()

  --this.FileBenchMark()

  --
  -- InfCore.PrintInspect(_IHHook, "_IHHook")
  -- InfCore.PrintInspect(_GameDir, "_GameDir")
  -- InfCore.PrintInspect(_IHHook_TestTable,"_IHHook_TestTable");

  --

  InfCore.Log("TppEquip.IsExistFile test:")
  local fileNamesTest={
    "/Assets/tpp/level_asset/weapon/ParameterTables/parts/EquipParameters.lua",
    "/Assets/tpp/script/lib/Tpp.lua",
    "/Assets/tpp/script/lib/InfInit.lua",
    "/Assets/tpp/script/ih/InfInit.lua",
    "/Assets/tpp/pack/fova/common_source/chara/cm_head/face/cm_m0_h0_v000_eye0.fpk",
    "/Assets/tpp/pack/mission2/init/init.fpk",
    "/Assets/tpp/pack/blurgespurgen.fpk",
    "/Assets/tpp/level_asset/weapon/ParameterTables/parts/EquipParameters",
    "/Assets/tpp/level_asset/weapon/ParameterTables/parts/EquipParameters.lua",
    "hurrrg",
  }
  for i,fileName in ipairs(fileNamesTest)do
    local fileExists = TppEquip.IsExistFile(fileName)
    InfCore.Log(fileName.." : "..tostring(fileExists))
  end




  local blockNames={
    "mission_block",
    "quest_block",
    "demo_block",
    "reinforce_block",
    "npc_block",
    "animal_block",
    "TppResidentBlockGroup",
    "CommonStageBlockGroup",
  }
  for i,blockName in ipairs(blockNames)do
    local blockId=ScriptBlock.GetScriptBlockId(blockName)
    InfCore.Log(blockName.." blockId="..tostring(blockId))
  end

  local staffVarNames={
    "mbmStaffSvarsHeaders",
    "mbmStaffSvarsSeeds",
    "mbmStaffSvarsStatusesNoSync",
    "mbmStaffSvarsStatusesSync",
  }

  local staffVarsHex={}

  local arrayLength=3500
  for i,varName in ipairs(staffVarNames)do
    staffVarsHex[varName]={}
    for index=0,arrayLength-1 do
      staffVarsHex[varName][index+1]=bit.tohex(vars[varName][index])
    end
  end
  --InfCore.PrintInspect(staffVarsHex,"staffVarsHex")

  --

  --this.PrintStrCodes()


end

function this.Init()
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  this.SetDebugModules()
end

function this.OnReload(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

end--OnReload

function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.Messages()
  return Tpp.StrCode32Table{

    }--StrCode32Table message table
end--Messages

function this.OnAllocate(missionTable)
end

function this.SetDebugVars()
  InfCore.LogFlow("IHDebugVars.PostAllModulesLoad: setting debug vars")

  Ivars.debugMode:Set(1)
  Ivars.debugMessages:Set(1)
  Ivars.debugFlow:Set(1)
  Ivars.debugOnUpdate:Set(1)

  Ivars.enableQuickMenu:Set(1)

  this.SetDebugModules()

  if IHH then
    IHH.Log_SetFlushLevel(InfCore.level_trace)
  end
end--SetDebugVars

function this.SetDebugModules()
  for i,moduleName in ipairs(debugModules)do
    local module=_G[moduleName]
    if not module then
      InfCore.Log("WARNING: IHDebugVars.SetDebugModules module "..tostring(moduleName).."==nil")
    else
      InfCore.Log("IHDebugVars.SetDebugModules "..tostring(moduleName))
      module.debugModule=true
    end
  end
end--SetDebugModules

function this.PrintUpdateTimes()
  InfCore.PrintInspect(InfMain.updateTimes,"updateTimes")

  local averageTimes={}
  for k,v in pairs(InfMain.updateTimes)do
    averageTimes[k]=0
  end
  for k,times in pairs(InfMain.updateTimes)do
    for i,timer in ipairs(times)do
      averageTimes[k]=averageTimes[k]+timer
    end
  end

  for k,times in pairs(InfMain.updateTimes)do
    averageTimes[k]=string.format("%.12f",averageTimes[k]/#times)
  end

  InfCore.PrintInspect(averageTimes,"averageTimes")


  local maxTimes={}
  for k,v in pairs(InfMain.updateTimes)do
    maxTimes[k]=0
  end
  for k,times in pairs(InfMain.updateTimes)do
    for i,timer in ipairs(times)do
      if timer>maxTimes[k] then
        maxTimes[k]=timer
      end
    end
  end

  InfCore.PrintInspect(maxTimes,"maxTimes")

  InfMain.updateTimes={}
end

function this.PrintStrCodes()
  InfCore.Log"IHDebugVars.PrintStrCodes---------------"
  local str32s={
    1500257626,
  --routeEvent types
  --      104983832,
  --      1500257626,
  --      4019510599,
  --      4258228081,
  --      1974185602,
  --      2265318157,
  --      4202868537,
  --      561913624,
  --      --reoute even params
  --      1004142592,
  --      889322046,
  --    6452720,
  --    1631872372,
  --    825241651,
  --    573317666,
  --    975332717,
  --    1936614772,
  --    741358114,
  --routeids
  --      132331158,
  --      205387598,
  --      587733603,
  --      2615639494,
  --      2763127077,
  --      3507759117,
  --      2265318157,
  --      1004142592,
  --      18529,
  --      889322046,
  --      574235246,
  --      104983832,
  --
  --   1631872372,
  }

  --AiRtEvSoldier
  --quest frts aparently have some corruption from json route or whatever they have and has 4 bytes of plain text

  for i,str32 in ipairs(str32s)do
    local str=InfLookup.StrCode32ToString(str32)
    InfCore.Log(str32.."="..str)
  end

  local strings={
    --'rt_heli_quest_0000',
    -- 'rt_quest_heli_d_0000',
    "Wait",
    "Stop",
    "stop",
    "hold",
    "look",
    "face",
    "aim",
    "walk",
    "Hold",
    "Point",
    "Look",
    "Face",
    "Aim",
    "AimPoint",
    "AimPoi",
    "Poi",
    "Walk",
  }

  for i,str in ipairs(strings)do
    local str32=Fox.StrCode32(str)
    InfCore.Log(str.."="..tostring(str32))
  end

end


function this.FileBenchMark()
  InfCore.Log("IHDebugVars: process toMgsvCmdsFilePath benchmark")
  local startTime=os.clock()
  if not (io and io.open) then
    InfCore.Log("ERROR: IHDebugVars.FileBenchMark io.open doesn't exist")
    return
  end
  local file,openError=io.open(InfCore.toMgsvCmdsFilePath,"r")
  local openTime=os.clock()-startTime
  local startTime=os.clock()
  local lines=file:read("*all")
  local readTime=os.clock()-startTime
  file:close()
  local startTime=os.clock()
  lines=InfUtil.Split(lines,"\n")
  local splitTime=os.clock()-startTime
  InfCore.Log("openTime:"..openTime)
  InfCore.Log("readTime:"..readTime)
  InfCore.Log("splitTime:"..splitTime)
  InfCore.Log("totalTime:"..openTime+readTime+splitTime)
end

function this.AnalyseUserDataShiz()
--REF init.lua
--  local mainApplication=Application{name="MainApplication"}
--  local game=Game{name="MainGame"}
--  mainApplication:AddGame(game)
--  mainApplication:SetMainGame(game)
--  local mainScene=game:CreateScene"MainScene"
--  local mainBucket=game:CreateBucket("MainBucket",mainScene)
--  game:SetMainBucket(mainBucket)
--REF start.lua
--local setupBucket=mainGame:CreateBucket("SetupBucket",mainScene)

--  local tppGameSequenceInstance=TppGameSequence:GetInstance()
--  tppGameSequenceInstance:SetPhaseController(TppPhaseController.Create())

--local phDaemon=PhDaemon.GetInstance()
--some phD setup

--REF gmpEarnMissions.lua
--local motherbaseManager=TppMotherBaseManager:GetInstance()
--local GmpEarn=motherbaseManager:GetGmpEarn()
--GmpEarn:CreateMissions{

--REF TppUI.lua
--UiCommonDataManager.GetInstance()

--REF start2nd.lua
--local subtitlesDaemon=SubtitlesDaemon.GetInstance()

--REF TppUiBootInit.lua
--UiCommonDataManager.Create()
--HudCommonDataManager.Create()
--local uiCommonDataManager=UiCommonDataManager.GetInstance()
--local uiDaemonInstance=UiDaemon.GetInstance()
--whole bunch of uiDaemonInstance usage

--_radio scripts
--RadioDaemon:GetInstance()

--o50050_sound
--  function this.PlayAlertSiren( switch )
--    local source = "asiren"
--    local tag  = "Loop"
--    local pEvent = "sfx_m_mtbs_siren"
--    local sEvent = "Stop_sfx_m_mtbs_siren"
--    local daemon = TppSoundDaemon.GetInstance()
--
--    if switch == true then
--      daemon:RegisterSourceEvent{
--        sourceName = source,
--        tag = tag,
--        playEvent = pEvent,
--        stopEvent = sEvent,
--      }
--    elseif switch == false then
--      daemon:UnregisterSourceEvent{
--        sourceName = source,
--        tag = tag,
--        playEvent = pEvent,
--        stopEvent = sEvent,
--      }
--    end
--  end



end


function this.AnalizeShiz()
  InfCore.ClearLog()

  local knownKeyNames={
    TppScriptVars={
      CATEGORY_CONFIG = true,
      CATEGORY_GAME_GLOBAL = true,
      CATEGORY_MB_MANAGEMENT = true,
      CATEGORY_MGO = true,
      CATEGORY_MISSION = true,
      CATEGORY_MISSION_RESTARTABLE = true,
      CATEGORY_PERSONAL = true,
      CATEGORY_QUEST = true,
      CATEGORY_RETRY = true,
      CopySlot = true,
      CreateSaveSlot = true,
      DeclareGVars = true,
      DeclareSVars = true,
      DeleteFile = true,
      FileExists = true,
      GROUP_BIT_ALL = true,
      GROUP_BIT_GVARS = true,
      GROUP_BIT_VARS = true,
      GetElapsedTimeSinceLastPlay = true,
      GetFileExistence = true,
      GetFreeStorageSpaceSize = true,
      GetLastResult = true,
      GetNecessaryStorageSpaceSize = true,
      GetProgramVersionTable = true,
      GetSaveState = true,
      GetScriptVersionFromSlot = true,
      GetTotalPlayTime = true,
      GetVarValueInSlot = true,
      InitForNewGame = true,
      InitForNewMission = true,
      IsSavingOrLoading = true,
      IsShowingNoSpaceDialog = true,
      LoadVarsFromSlot = true,
      PLAYER_AMMO_STOCK_TYPE_COUNT = true,
      READ_FAILED = true,
      RESULT_ERROR_FILE_CORRUPT = true,
      RESULT_ERROR_INVALID_STORAGE = true,
      RESULT_ERROR_LOAD_BACKUP = true,
      RESULT_ERROR_NOSPACE = true,
      RESULT_ERROR_OWNER = true,
      RESULT_OK = true,
      ReadSlotFromAreaFile = true,
      ReadSlotFromFile = true,
      RequestAreaFileExistence = true,
      RequestFileExistence = true,
      RequestNecessaryStorageSpace = true,
      STATE_LOADING = true,
      STATE_PROCESSING = true,
      STATE_SAVING = true,
      SVarsIsSynchronized = true,
      SaveVarsToSlot = true,
      SetFileSizeList = true,
      SetSVarsNotificationEnabled = true,
      SetUpSlotAsCompositSlot = true,
      SetVarValueInSlot = true,
      ShowNoSpaceDialog = true,
      StoreUtcTimeToScriptVars = true,
      TYPE_BOOL = true,
      TYPE_FLOAT = true,
      TYPE_INT32 = true,
      TYPE_INT8 = true,
      TYPE_UINT16 = true,
      TYPE_UINT32 = true,
      TYPE_UINT8 = true,
      WRITE_FAILED = true,
      WriteSlotToFile = true
    }
  }

  local moduleName="TppScriptVars"
  local module=_G[moduleName]

  local str32Keys={}
  for key,exists in pairs(knownKeyNames[moduleName])do
    str32Keys[key]=Fox.StrCode32(key)
  end
  InfCore.PrintInspect(str32Keys,moduleName.." str32Keys")

  local moduleValues={}
  for key,exists in pairs(knownKeyNames[moduleName])do
    moduleValues[key]=InfInspect.Inspect(module[key])
  end
  InfCore.PrintInspect(moduleValues,moduleName.." moduleValues")

  local arrayValues={}
  local arrayCountIdent=-285212672
  local arrayCount=module[arrayCountIdent]
  InfCore.PrintInspect(arrayCount,moduleName.." arrayCount")
  if arrayCount then
    for i=0,arrayCount do--tex not sure if index from 0 or 1
      arrayValues[i]=InfInspect.Inspect(module[i])
    end
  end
  InfCore.PrintInspect(arrayValues,moduleName.." arrayValues")


  local tableInfo={
    stringKeys={},
    numberKeys={},
  }
  local function GetTableKeys(checkTable,tableInfo)
    for key,value in pairs(checkTable)do
      if type(key)=="string" then
        tableInfo.stringKeys[key]=true
      elseif type(key)=="number" then
        tableInfo.numberKeys[key]=true
        if type(value)=="table" then
          GetTableKeys(value,tableInfo)
        end
      end
    end
  end

  GetTableKeys(module,tableInfo)
  InfCore.PrintInspect(tableInfo,moduleName.." tableInfo")


  InfCore.PrintInspect(module,moduleName)


  for knownKeyName,str32 in pairs(str32Keys)do
    local foundKey=tableInfo.numberKeys[str32]
    InfCore.Log(knownKeyName.." "..str32.." key in module:"..tostring(foundKey))
  end
end

--tex from IHTearDown
function this.DumpVars()
  local vars=vars

  local rootArrayIdent=-285212671

  local arrayIdent=-285212665
  local arrayCountIdent=-285212666

  local varsTable={}

  for k,v in pairs(vars[rootArrayIdent])do
    varsTable[k]=vars[k]
  end

  local skipKeys={
    __index=true,
    __newindex=true,
  }

  for k,foxTable in pairs(vars)do
    --tex is actually a foxTable
    if type(foxTable)=="table" then
      if foxTable[arrayCountIdent] then
        --InfCore.Log("found foxTable "..k)--DEBUGNOW
        if type(k)=="string" then
          if not skipKeys[k] then
            local foxTableArray=foxTable[arrayIdent]
            if foxTableArray then
              varsTable[k]={}
              local arrayCount=foxTable[arrayCountIdent]
              --InfCore.Log("arrayCount="..arrayCount)--DEBUGNOW
              for i=0,arrayCount-1 do
                varsTable[k][i]=vars[k][i]
              end
            end--if foxTableArray
          end--not skipKeys
        end--k==type string
      end--if foxTable[arrayCountIndex]
    end--foxTable==type table
  end--for vars

  return varsTable
end--DumpVars

--tex dumped vars (via DumpVars()) are key, var, with var either being int or float, or indexed from 0 list of int or float
local nl="\n"
function this.PrintVars(dumpedVars)
  InfCore.Log("PrintVars:")
  local outputPath=[[C:\Projects\MGS\ToolOutput\dump-vars.txt]]

  local printLines={}

  local namesSorted={}

  for varName, var in pairs(dumpedVars)do
    namesSorted[#namesSorted+1]=varName
  end

  table.sort(namesSorted)

  if not (io and io.open) then
    InfCore.Log("ERROR: IHDebugVars.PrintVars io.open doesn't exist")
    return
  end
  local file,error=io.open(outputPath,"w")
  if not file then
    InfCore.Log(error)
    return
  end
  file:write("--Dumped vars via IHDebugVars.DumpVars,PrintVars",nl)
  file:write("--Note: arrays are indexed from 0",nl)
  for i, varName in ipairs(namesSorted)do
    local line=varName
    local var = dumpedVars[varName]
    if type(var)=="table"then
      line=line.."["..#var.."]"
      line=line.."= { "
      for j=0, #var do
        local currentVar=var[j]
        line=line..tostring(currentVar)..", "
      end
      line=line.."},"
    else
      line=line.." = "..tostring(var)..","
    end
    file:write(line,nl)
  end

  file:close()
end

function this.Dump_ui_isTaskLastCompleted()
  local taskCompletedInfo={}
  local maxMissionTasks={}
  for missionCodeStr,missionEnum in pairs(TppDefine.MISSION_ENUM)do
    local missionCode=tonumber(missionCodeStr)
    local maxMissionTask=TppUI.GetMaxMissionTask(missionCode) or 0
    local info={}
    taskCompletedInfo[missionCode]=info
    maxMissionTasks[missionCode]=maxMissionTask
    InfCore.Log(missionCode..": maxMissionTask: "..maxMissionTask..", isTaskCompleted:")
    local ui_isTaskLastComletedStr="["
    for taskIndex=0,TppDefine.MAX_MISSION_TASK_COUNT-1 do
      local missionTaskIndex=missionEnum*TppDefine.MAX_MISSION_TASK_COUNT+taskIndex

      local isTaskLastCompleted=0
      if gvars.ui_isTaskLastComleted[missionTaskIndex] then
        isTaskLastCompleted=1
      end
      info[taskIndex+1]=isTaskLastCompleted
      ui_isTaskLastComletedStr=ui_isTaskLastComletedStr..tostring(isTaskLastCompleted)..","
    end
    ui_isTaskLastComletedStr=ui_isTaskLastComletedStr.."]"
    InfCore.Log(ui_isTaskLastComletedStr)
  end
  InfCore.PrintInspect(taskCompletedInfo,"taskCompletedInfo")--DEBUG
  InfCore.PrintInspect(maxMissionTasks,"maxMissionTasks")--DEBUG

  --tex dumped from a 100% completed using above
  --alternatively could hand compile from <mission>_sequence .missionObjectiveDefine s
  --    local vanillaTasks={
  --      [10010] = { 1, 1, 0, 0, 0, 0, 0, 0 },
  --      [10020] = { 1, 1, 1, 1, 1, 1, 0, 0 },
  --      [10030] = { 1, 1, 1, 1, 1, 0, 0, 0 },
  --      [10033] = { 1, 1, 1, 1, 1, 0, 0, 0 },
  --      [10036] = { 1, 1, 1, 1, 1, 0, 0, 0 },
  --      [10040] = { 1, 1, 1, 1, 1, 1, 0, 0 },
  --      [10041] = { 1, 1, 1, 1, 1, 1, 1, 0 },
  --      [10043] = { 1, 1, 1, 1, 1, 1, 0, 0 },
  --      [10044] = { 1, 0, 1, 1, 1, 1, 1, 1 },
  --      [10045] = { 0, 1, 1, 1, 1, 1, 1, 0 },
  --      [10050] = { 1, 1, 1, 0, 0, 1, 0, 0 },
  --      [10052] = { 0, 1, 1, 1, 1, 1, 0, 0 },
  --      [10054] = { 1, 1, 1, 1, 1, 1, 1, 1 },
  --      [10070] = { 1, 1, 1, 1, 1, 1, 0, 0 },
  --      [10080] = { 1, 1, 1, 1, 1, 1, 0, 0 },
  --      [10081] = { 0, 1, 1, 1, 0, 0, 0, 0 },
  --      [10082] = { 0, 1, 1, 1, 1, 1, 0, 0 },
  --      [10085] = { 1, 1, 1, 1, 1, 1, 1, 0 },
  --      [10086] = { 1, 1, 1, 1, 1, 1, 1, 0 },
  --      [10090] = { 1, 1, 1, 1, 1, 1, 1, 1 },
  --      [10091] = { 0, 1, 0, 1, 1, 1, 1, 1 },
  --      [10093] = { 1, 0, 1, 1, 1, 1, 1, 0 },
  --      [10100] = { 1, 1, 1, 1, 1, 1, 1, 1 },
  --      [10110] = { 1, 1, 1, 1, 1, 1, 0, 0 },
  --      [10115] = { 1, 0, 0, 0, 0, 0, 0, 0 },
  --      [10120] = { 0, 1, 1, 1, 1, 1, 0, 0 },
  --      [10121] = { 1, 1, 1, 1, 1, 1, 1, 1 },
  --      [10130] = { 1, 1, 1, 1, 1, 1, 0, 0 },
  --      [10140] = { 1, 1, 1, 1, 0, 0, 0, 0 },
  --      [10150] = { 1, 1, 1, 1, 1, 1, 0, 0 },
  --      [10151] = { 1, 1, 1, 0, 0, 0, 0, 0 },
  --      [10156] = { 1, 1, 1, 1, 1, 0, 0, 0 },
  --      [10171] = { 1, 1, 0, 1, 1, 1, 1, 1 },
  --      [10195] = { 1, 1, 1, 1, 1, 1, 1, 0 },
  --      [10200] = { 0, 0, 1, 1, 1, 1, 1, 1 },
  --      [10211] = { 1, 0, 1, 1, 1, 1, 1, 0 },
  --      [10230] = { 0, 0, 0, 0, 0, 0, 0, 0 },
  --      [10240] = { 1, 1, 0, 0, 0, 0, 0, 0 },
  --      [10260] = { 1, 1, 1, 1, 1, 0, 0, 0 },
  --      [10280] = { 1, 1, 0, 0, 0, 0, 0, 0 },
  --      [11033] = { 1, 1, 1, 1, 1, 0, 0, 0 },
  --      [11036] = { 0, 0, 0, 0, 0, 0, 0, 0 },
  --      [11041] = { 0, 0, 0, 0, 0, 0, 0, 0 },
  --      [11043] = { 1, 1, 1, 1, 1, 1, 0, 0 },
  --      [11044] = { 1, 0, 1, 1, 1, 1, 1, 1 },
  --      [11050] = { 1, 1, 1, 0, 0, 1, 0, 0 },
  --      [11052] = { 0, 0, 0, 0, 0, 0, 0, 0 },
  --      [11054] = { 1, 1, 1, 1, 1, 1, 1, 1 },
  --      [11080] = { 1, 1, 1, 1, 1, 1, 0, 0 },
  --      [11082] = { 0, 1, 1, 1, 1, 1, 0, 0 },
  --      [11085] = { 0, 0, 0, 0, 0, 0, 0, 0 },
  --      [11090] = { 1, 1, 1, 1, 1, 1, 1, 1 },
  --      [11091] = { 0, 0, 0, 0, 0, 0, 0, 0 },
  --      [11115] = { 0, 0, 0, 0, 0, 0, 0, 0 },
  --      [11121] = { 1, 1, 1, 1, 1, 1, 1, 1 },
  --      [11130] = { 1, 1, 1, 1, 1, 1, 0, 0 },
  --      [11140] = { 1, 1, 1, 1, 0, 0, 0, 0 },
  --      [11151] = { 1, 1, 1, 0, 0, 0, 0, 0 },
  --      [11171] = { 0, 0, 0, 0, 0, 0, 0, 0 },
  --      [11195] = { 0, 0, 0, 0, 0, 0, 0, 0 },
  --      [11200] = { 0, 0, 0, 0, 0, 0, 0, 0 },
  --      [11211] = { 0, 0, 0, 0, 0, 0, 0, 0 }
  --    }
end

--menus
this.registerMenus={
  "devInAccMenu",
  "devInMissionMenu",
}

this.registerIvars={
  "debug_GrTools_SetLodScale",
  "debug_GrTools_SetVertexLodScale",
  "debug_GrTools_SetModelLodScale",
  "debug_GrTools_SetModelVertexLodScale",
  "debug_GrTools_SetLodFactorResolution",
  "debug_GrTools_SetOccluderEffectiveRange",
  "debug_GrTools_SetOccluderLimit",
  "debug_Player_SetAroundCameraMaxDistanceForAlphaExamination",
  "debug_vars_playerType",
  "UnSetStandMoveSpeedLimit",
  "setStandMoveSpeedLimit",
}

this.devInAccMenu={
  noDoc=true,
  nonConfig=true,
  options={
    "Ivars.debug_vars_playerType",
    "InfMenuCommands.RefreshPlayer",--DEBUGNOW
    "InfMenuCommands.ShowImguiDemo",
    "Ivars.quest_useAltForceFulton",--DEBUGNOW
    "Ivars.sys_increaseMemoryAlloc",--DEBUGNOW
    "IHDebugVars.DEBUG_SomeShiz",
    "IHDebugVars.DEBUG_SomeShiz2",
    "IHDebugVars.DEBUG_SomeShiz3",
    --"Ivars.customBodyTypeMB_ALL",--DEBUGNOW
    --"Ivars.customSoldierTypeMISSION",--TODO:
    "Ivars.manualSequence",
    "Ivars.allowUndevelopedDDEquip",
    "InfLookup.DumpValidStrCode",
    --TODO: debugmodeall command/profile
    --"Ivars.enableWildCardHostageFREE",--WIP
    --"Ivars.enableSecurityCamFREE",
    "InfMenuCommands.ForceRegenSeed",
    "Ivars.debugValue",
    "Ivars.debugMode",
    "Ivars.debugMessages",
    "Ivars.debugFlow",
    "Ivars.debugOnUpdate",
    "Ivars.log_SetFlushLevel",
    "InfMenuCommands.DEBUG_RandomizeAllIvars",
    "Ivars.debugMessagesVerbose",
  }
}--devInAccMenu

this.devInMissionMenu={
  noDoc=true,
  nonConfig=true,
  options={
    "IHDebugVars.UnSetStandMoveSpeedLimit",
    "Ivars.setStandMoveSpeedLimit",

    "InfMenuCommands.RefreshPlayer",--DEBUGNOW
    "Ivars.debug_GrTools_SetLodScale",
    "Ivars.debug_GrTools_SetVertexLodScale",
    "Ivars.debug_GrTools_SetModelLodScale",
    "Ivars.debug_GrTools_SetModelVertexLodScale",
    "Ivars.debug_GrTools_SetLodFactorResolution",
    "Ivars.debug_GrTools_SetOccluderEffectiveRange",
    "Ivars.debug_GrTools_SetOccluderLimit",
    "Ivars.debug_Player_SetAroundCameraMaxDistanceForAlphaExamination",
    "InfMenuCommands.ShowImguiDemo",
    "Ivars.cam_disableCameraAnimations",
    "IHDebugVars.DEBUG_SomeShiz",
    "IHDebugVars.DEBUG_SomeShiz2",
    "IHDebugVars.DEBUG_SomeShiz3",
    "InfMenuCommands.DEBUG_WarpToObject",
    --    "InfHelicopter.RequestHeliLzToLastMarker",
    --    "InfHelicopter.RequestHeliLzToLastMarkerAlt",
    --    "InfHelicopter.ForceExitHeli",
    --    "InfHelicopter.ForceExitHeliAlt",
    --    "InfHelicopter.PullOutHeli",
    --    "InfHelicopter.ChangeToIdleStateHeli",
    --"Ivars.selectedCp",
    --"InfMenuCommands.SetSelectedCpToMarkerObjectCp",
    "InfMenuCommands.SetSelectedCpToMarkerClosestCp",
    "Ivars.selectedCp",
    "InfUserMarker.PrintLatestUserMarker",
    --"InfMenuCommands.CheckPointSave",
    "Ivars.warpToListPosition",
    "Ivars.warpToListObject",
    "Ivars.setCamToListObject",
    "Ivars.dropLoadedEquip",
    "Ivars.dropTestEquip",
    "Ivars.debugValue",
    "InfMenuCommandsTpp.DEBUG_PrintSoldierDefine",
    --"Ivars.parasitePeriod_MIN",
    --"Ivars.parasitePeriod_MAX",

    "InfLookup.DumpValidStrCode",
    "InfCore.ClearLog",
  }
}--devInMissionMenu

--DEBUGNOW CULL
local addedMenus=false
function this.AddDevMenus()
  if addedMenus then
    return
  end
  addedMenus=true

  InfCore.Log"AddDevMenus"
  local safeSpaceMenu=InfMenuDefs.safeSpaceMenu.options
  local inMissionMenu=InfMenuDefs.inMissionMenu.options
  if not isMockFox then
    table.insert(safeSpaceMenu,1,'IHDebugVars.devInAccMenu')
    table.insert(inMissionMenu,1,'IHDebugVars.devInMissionMenu')
  end
end--AddDevMenus
--< menus

function this.ClearEnabledMarkers()--tex theres already a ClearMarkers in this module
  if mvars.ene_soldierDefine then
    for cpName,cpSoldiers in pairs(mvars.ene_soldierDefine)do
      for i,soldierName in ipairs(cpSoldiers)do
        local gameId=GameObject.GetGameObjectId("TppSoldier2",soldierName)
        if gameId~=GameObject.NULL_ID then
          TppMarker.Disable(gameId,true,true)
        end--~=NULL_ID
      end--for cpSoldiers
    end--for ene_soldierDefine
end--if ene_soldierDefine

local hostages=TppEnemy.GetAllHostages()
for i,gameId in ipairs(hostages)do
  TppMarker.Disable(gameId,true,true)
end

--TODO gimmicks

--TODO vehicles

local walkerGears=TppEnemy.GetAllActiveEnemyWalkerGear()
for i,gameId in ipairs(walkerGears)do
  TppMarker.Disable(gameId,true,true)
end
end--ClearEnabledMarkers

--DEBUGNOW
this.SLOTS_PER_CATEROGRY=3
this.PARTS_COUNT=12--tex chimera parts slots per weapon, includes color
this.weaponCategories={
  "HANDGGUN",
  "SMG",
  "ASSAULT",
  "SHOTGUN",
  "GRENADELAUNCHER",
  "SNIPER",
  "MG",
  "MISSILE",
}--weaponCategories
this.weaponCategoriesEnum=Tpp.Enum(this.weaponCategories)
this.slots={
  "SLOT1",
  "SLOT2",
  "SLOT3",
}--slots
this.slotsEnum=Tpp.Enum(this.slots)
--VERIFY, just cribbing from TppDebug DEBUG_ChangeChimeraWeapon chimeraInfo
--comments are edit mode
this.parts={
  "equipId",--recieverId?--'Base'
  "barrel",
  "ammo",--'Magazine'
  "stock",
  "muzzle",
  "muzzleOption",--'muzzle accessory'
  "rearSight",--'Optics 1'
  "frontSight",--'Optics 2'
  "option1",--'Flashlight'
  "option2",--'Laser Sight'
  "underBarrel",
  "underBarrelAmmo",
}--parts
this.partsEnum=Tpp.Enum(this.parts)

--menuCommands
local toggle1=true
local index1Min=1
local index1Max=4
local index1=index1Min
local count=0
local increment=1
this.log=""
this.DEBUG_SomeShiz=function()
  count=count+1
  InfCore.Log("---------------------DEBUG_SomeShiz---------------------"..count,true,true)

  InfCore.DebugPrint("index1:"..index1)
  InfCore.DebugPrint("toggle1:"..tostring(toggle1))
  index1=index1+increment
  if index1>index1Max then
    index1=index1Min
  end
  toggle1=not toggle1

  InfCore.PrintInspect(vars.playerType,"playerType")
  InfCore.PrintInspect(vars.playerPartsType,"playerPartsType")
  InfCore.PrintInspect(vars.playerCamoType,"playerCamoType")
  InfCore.PrintInspect(vars.playerFaceId,"playerFaceId")
  InfCore.PrintInspect(vars.playerFaceEquipId,"playerFaceEquipId")
  InfCore.PrintInspect(vars.playerHandType,"playerHandType")
  InfCore.PrintInspect(vars.handEquip,"handEquip")
  InfCore.PrintInspect(vars.playerSkillId,"playerSkillId")


  --  --DEBUGNOW TESTING
  --  local handInfo={
  --    description="unifiedHands",
  --    fpkPath="/Assets/tpp/pack/player/fova/plfova_sna0_arm3_v00_uni.fpk",
  --    fv2Path="/Assets/tpp/fova/chara/sna/sna0_arm3_v00.fv2",
  --  }
  --  local handType=PlayerHandType.STUN_ARM
  --  InfCore.PrintInspect(handType,"PlayerHandType.STUN_ARM")
  --  --hand=2
  --  IHH.SetOverrideHandSystem(true)
  --  IHH.SetBionicHandFpkPath(handType,handInfo.fpkPath)
  --  IHH.SetBionicHandFv2Path(handType,handInfo.fv2Path)


  if true then return end
  IHTearDown.DumpModules({buildFromScratch=false})

  if true then return end
  if IHH then
    --    IHH.SetPlayerPartsFpk(PlayerType.SNAKE,InfFova.PlayerPartsType.MGS1,"/Assets/tpp/pack/player/parts/plparts_ninja.fpk")
    --    IHH.SetPlayerPartsPart(PlayerType.SNAKE,InfFova.PlayerPartsType.MGS1,"/Assets/tpp/parts/chara/nin/nin0_main0_def_v00.parts")
    --    --IHH.SetPlayerPartsFpk(PlayerType.AVATAR,InfFova.PlayerPartsType.MGS1,"/Assets/tpp/pack/player/parts/plparts_ninja.fpk")
    --    --IHH.SetPlayerPartsPart(PlayerType.AVATAR,InfFova.PlayerPartsType.MGS1,"/Assets/tpp/parts/chara/nin/nin0_main0_def_v00.parts")
    --
    --    IHH.SetPlayerPartsFpk(PlayerType.DD_MALE,28,"/Assets/tpp/pack/player/parts/plparts_ocelot.fpk")
    --    IHH.SetPlayerPartsPart(PlayerType.DD_MALE,28,"/Assets/tpp/parts/chara/ooc/ooc0_main1_def_v00.parts")
    --    IHH.SetPlayerPartsFpk(PlayerType.AVATAR,28,"/Assets/tpp/pack/player/parts/plparts_ocelot.fpk")
    --    IHH.SetPlayerPartsPart(PlayerType.AVATAR,28,"/Assets/tpp/parts/chara/ooc/ooc0_main1_def_v00.parts")

    IHH.SetPlayerPartsFpk(PlayerType.DD_MALE,24,"/Assets/tpp/pack/player/parts/plparts_dd_male_svs.fpk")
    IHH.SetPlayerPartsPart(PlayerType.DD_MALE,24,"/Assets/tpp/parts/chara/sna/dds5_svs0_ply_v00.parts")

    local svsPartsInfo={
      description="Soviet",
      fpkPath="/Assets/tpp/pack/player/parts/plparts_dd_male_svs.fpk",
      partsPath="/Assets/tpp/parts/chara/sna/dds5_svs0_ply_v00.parts"
    }



    local svsPartsInfo={
      description="Soviet",
      fpkPath="/Assets/tpp/pack/player/parts/plparts_dd_male.fpk",
      partsPath="/Assets/tpp/parts/chara/sna/dds5_main0_ply_v00.parts"
    }


    local playerPartsInfo=svsPartsInfo
    IHH.SetPlayerPartsFpkPath(playerPartsInfo.fpkPath)
    IHH.SetPlayerPartsPartsPath(playerPartsInfo.partsPath)
  end


  if true then return end

  if toggle1 then
    TppSoundDaemon.PostEvent("sfx_m_fulton_heli_success","Loading")
  else
    TppSoundDaemon.PostEvent("sfx_m_heli_fly_return","Loading")
  end
  if true then return end
  --mvars.helispacePlayerTransform.pos =
  -- mvars.helispacePlayerTransform.rotY =

  TppPlayer.Warp{
    pos = mvars.helispacePlayerTransform.pos,
    rotY = mvars.helispacePlayerTransform.rotY
  }


  --InfCore.Log"zzzzzzzzt"
  --InfProgression.RepopAntiAirRadar()

  if true then return end

  local markerName="ly003_cl04_npc0000|cl04pl2_q30210|Marker_shootingPractice"

  local GetGameObjectId=GameObject.GetGameObjectId
  local NULL_ID=GameObject.NULL_ID

  local gameId=GetGameObjectId(markerName)
  if gameId==NULL_ID then
    InfCore.Log(markerName.."==NULL_ID")
  else
    InfCore.Log(markerName.." gameId:"..tostring(gameId))
    TppMarker.Enable(markerName)
  end

  local trapName="ly003_cl04_npc0000|cl04pl2_q30210|trap_shootingPractice_start"
  local gameId=GetGameObjectId(markerName)
  if gameId==NULL_ID then
    InfCore.Log(trapName.."==NULL_ID")
  end

  --InfCore.PrintInspect(EquipIdTable,"EquipIdTable")
  --InfCore.PrintInspect(InfInit,"InfInit insp")--DEBUGNOW
  --
  local filePath="Tpp/Scripts/Equip/EquipIdTable.lua"
  --InfCore.DoFile(filePath)

  --local equipDevelopID={
  --11080,
  --11081,
  --11082,
  --11083,
  --}
  --
  --
  --  for t,equipDevelopID in ipairs(equipDevelopID)do
  --    InfCore.DebugPrint(equipDevelopID)
  --    TppMotherBaseManagement.SetEquipDeveloped{equipDevelopID=equipDevelopID}
  --  end


  --  local InterrogateQuiet="p51_010210"
  --
  --  local demoId=InterrogateQuiet
  --  DemoDaemon.Play(demoId)

  ---InfCore.PrintInspect(mvars.mis_transitionMissionStartPosition,"mvars.mis_transitionMissionStartPosition")

  local missionCode=33003
  --TppMission.ReserveMissionClear{nextMissionId=missionCode,missionClearType=TppDefine.MISSION_CLEAR_TYPE.FREE_PLAY_NO_ORDER_BOX}

  --MotherBaseStage.LockCluster(8)--DEBUGNOW

  --InfCore.PrintInspect(TppEquip,"TppEquip")

  if true then return end

  local userPresetChimeraParts={}
  --={
  --15, 5, 7, 0, 0, 1, 0, 0, 2, 0, 0, 0,
  --29, 11, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  --32, 16, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0,

  --59, 23, 47, 4, 0, 17, 3, 0, 0, 0, 1, 0,
  --0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  --0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

  --65, 30, 54, 11, 2, 24, 4, 1, 0, 0, 0, 0,
  --68, 40, 56, 15, 1, 32, 3, 0, 4, 8, 11, 86,
  --0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

  --196, 63, 148, 23, 11, 0, 1, 0, 5, 0, 0, 0,
  --88, 57, 73, 21, 0, 0, 0, 0, 0, 0, 0, 0,
  --0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

  --116, 71, 0, 28, 0, 0, 9, 0, 0, 9, 11, 86,
  --142, 77, 101, 10, 0, 0, 12, 0, 0, 0, 0, 0,
  --0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

  --163, 88, 113, 39, 19, 33, 19, 0, 0, 9, 3, 0,
  --150, 81, 106, 36, 25, 33, 5, 1, 0, 9, 0, 0,
  --145, 84, 104, 28, 17, 33, 16, 0, 0, 0, 0, 0,

  --170, 96, 120, 0, 0, 20, 3, 0, 4, 8, 0, 0,
  --208, 99, 152, 18, 25, 0, 3, 0, 0, 0, 0, 0,
  --0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

  --210, 0, 157, 0, 0, 0, 22, 0, 3, 8, 0, 0,
  --0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  --0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  --}

  local chimera={}
  local chimera2={}
  InfCore.Log("idx:")
  for i,category in ipairs(this.weaponCategories)do
    chimera[category]={}
    chimera2[category]={}
    for j,slot in ipairs(this.slots) do
      chimera[category][slot]={}
      chimera2[category][slot]={}
      for k,part in ipairs(this.parts)do
        local idx=InfChimera.From3Dto1D(k-1,j-1,i-1,#this.parts,#this.slots)
        InfCore.Log(idx)
        chimera2[category][slot][part]=vars.userPresetChimeraParts[idx]
      end
    end
  end

  local varsSize=#this.weaponCategories*this.SLOTS_PER_CATEROGRY*this.PARTS_COUNT
  for i=0,varsSize-1 do
    local part,slot,cat=InfChimera.From1Dto3D(i,#this.parts,#this.slots)
    local catName=this.weaponCategoriesEnum[cat+1]
    local slotName=this.slotsEnum[slot+1]
    local partName=this.partsEnum[part+1]
    InfCore.Log("cat: "..cat.." slot:"..slot.." part:"..part)
    InfCore.Log("catName: "..tostring(catName).." slotName:"..tostring(slotName).." partName:"..tostring(partName))

    table.insert(userPresetChimeraParts,vars.userPresetChimeraParts[i])
    chimera[catName][slotName][partName]=vars.userPresetChimeraParts[i]
  end
  InfCore.PrintInspect(userPresetChimeraParts,"userPresetChimeraParts")
  InfCore.PrintInspect(chimera,"chimera")
  InfCore.PrintInspect(chimera2,"chimera2")

  if true then return end
  this.ClearEnabledMarkers()

  if true then return end

  for revengeTypeIndex=0,TppRevenge.REVENGE_TYPE.MAX-1 do
    local revengeTypeName=TppRevenge.REVENGE_TYPE_NAME[revengeTypeIndex+1]
    local revengePoint=gvars.rev_revengePoint[revengeTypeIndex]
    InfCore.Log("rev_revengePoint["..revengeTypeName.."]".."="..tostring(revengePoint))

    local revengeLv=gvars.rev_revengeLv[revengeTypeIndex]
    InfCore.Log("rev_revengeLv["..revengeTypeName.."]".."="..tostring(revengeLv))
  end
  for blockedTypeIndex=0,TppRevenge.BLOCKED_TYPE.MAX-1 do
    local blockedCount=gvars.rev_revengeBlockedCount[blockedTypeIndex]
    InfCore.Log("rev_revengeBlockedCount["..blockedTypeIndex.."]".."="..tostring(blockedCount))
  end

  --InfCore.PrintInspect(player2_camouf_param,"player2_camouf_param")
  --InfCore.Log("elapsedTime:"..Time.GetRawElapsedTimeSinceStartUp())
  --tex example usage of the cammoTypes and materialTypes tables I added
  --local camoType=this.camoTypes.SWIMWEAR_C00
  --local materialType=this.materialTypes.MTR_WOOD_A
  --local camoMaterialValue=this.cammoTable[camoType][materialType] --get value
  --this.camoTable[camoType][materialType]=50 --set value

  --or conversely, printing out
  --for cammoType,cammoStrengths in ipairs(this.cammoTable)do
  --  InfCore.Log(this.playerCammoTypeNames[cammoType])
  --  for materialType,cammoStrength in ipairs(cammoStrengths)do
  --    InfCore.Log(this.materialTypeNames[materialType]..":"..cammoStrength)
  --  end
  --end




  --  local displayTimeSec=1*50
  --  local cautionTimeSec=30
  --  if index1==1 then
  --    TppUiCommand.StartDisplayTimer(displayTimeSec,cautionTimeSec)
  --    InfCore.Log("DisplayTimer start:"..tostring(displayTimeSec*1000),true,true)
  --  elseif index1==2 then
  --    --InfCore.Log("DisplayTimer stop",true,true)
  --    --TppUiStatusManager.SetStatus("DisplayTimer","STOP_VISIBLE")
  --  elseif index1==3 then
  --    local leftTime=TppUiCommand.GetLeftTimeFromDisplayTimer()
  --    InfCore.Log("DisplayTimer leftTime:"..tostring(leftTime),true,true)
  --  else
  --    --InfCore.Log("DisplayTimer erase",true,true)
  --    --TppUiStatusManager.UnsetStatus("DisplayTimer","STOP_VISIBLE")
  --    --TppUiCommand.EraseDisplayTimer()
  --
  --  end

  local time=1234
  --  TppRanking._ShowScoreTimeAnnounceLog(time)
  -- InfCore.PrintInspect(TppEquip.EQP_SWP_WormholePortal_G02,"EQP_SWP_WormholePortal_G02")

  -- TppMotherBaseManagement.SetEquipDeveloped{equipDevelopID=TppEquip.EQP_SWP_WormholePortal_G02}

  --GrTools.SetLodScale(index1)
  -- GrTools.SetModelLodScale(index1)
  -- GrTools.SetLodFactorResolution(index1) --??
  -- GrTools.SetEnableNoRejectOnShadow(toggle1)

  --GrTools.SetEnableShadowedLightLimit(toggle1)


  --TppEffectUtility.SetTppAtmosphereSunLightEnable(toggle1)--works
  --TppEffectUtility.SetTppAtmosphereShadowEnable(toggle1)--works, world shadows

  --GrTools.SetCloudShadowTexture(??)--havent trues
  --TppWeatherEffectManager.SetCloudShadowVisibility(toggle1)--no aprent change
  --TppWeatherEffectManager.SetSunMoonDecorationDistance(10000*index1)--no aprent change
  -- TppWeatherEffectManager.SetSunMoonDecorationVisible(toggle1)--no aprent change
  --TppWeatherEffectManager.SetWeatherThunderAutoGeneration(toggle1)


  ---

  --  InfCore.Log("mbLayoutCode:"..vars.mbLayoutCode)
  --
  --gvars.mis_nextMissionCodeForEmergency=30050
  --gvars.mis_nextMissionStartRouteForEmergency=nil
  --gvars.mis_nextLayoutCodeForEmergency=30
  --gvars.mis_nextClusterIdForEmergency=0


  if true then return end

  InfCore.Log("vars.playerSkillId:"..tostring(vars.playerSkillId))

  InfCore.PrintInspect(PlayerStatus,"PlayerStatus")
  PlayerStatus.TEST=999
  InfCore.PrintInspect(PlayerStatusEx[PlayerStatusEx.DASH])

  InfCore.PrintInspect(PlayerStatusEx,"PlayerStatusEx")

  --mockmod gen ssd
  --  PlayerStatus = {
  --    CARRY = 148,
  --    CRAWL = 6,
  --    DEAD = 71,
  --    NORMAL_ACTION = 7,
  --    PARTS_ACTIVE = 158,
  --    SQUAT = 5,
  --    STAND = 4,
  --    __index = "<function>",
  --    __newindex = "<function>"
  --  }
  --
  --  --tpp
  --    PlayerStatus = {
  --    BINOCLE = 58,
  --    CARRY = 134,
  --    CRAWL = 6,
  --    CURTAIN = 140,
  --    DASH = 23,
  --    NORMAL_ACTION = 7,
  --    PARTS_ACTIVE = 145,
  --    SQUAT = 5,
  --    STAND = 4,
  --    __index = "<function>",
  --    __newindex = "<function>"
  --  },

  local testValues={
    "STAND",
    "SQUAT",
    "CRAWL",
    "NORMAL_ACTION",
    "DASH",
    "BINOCLE",
    "CARRY",
    "CURTAIN",
    "PARTS_ACTIVE",

    "DEAD",
    --
    --MGO ?
    "REALIZED",
    "UNCONSCIOUS",
    "CQC_HOLD_BY_ENEMY",
    "FULTONED",
    "CHARMED",
    --SSD
    "REQUEST_EMOTION_COMBINATION",
    --wiki bbb
    "PARALLEL_MOVE",
    "IDLE",
    "GUN_FIRE",
    "GUN_FIRE_SUPPRESSOR",
    "STOP",
    "WALK",
    "RUN",
    "ON_HORSE",
    "ON_VEHICLE",
    "ON_HELICOPTER",
    "HORSE_STAND",
    "HORSE_HIDE_R",
    "HORSE_HIDE_L",
    "HORSE_IDLE",
    "HORSE_TROT",
    "HORSE_CANTER",
    "HORSE_GALLOP",
    "SUBJECT",
    "INTRUDE",
    "LFET_STOCK",
    "CUTIN",
    "DEAD_FRESH",
    "NEAR_DEATH",
    "NEAR_DEAD",
    "FALL",
    "CBOX",
    "CBOX_EVADE",
    "TRASH_BOX",
    "TRASH_BOX_HALF_OPEN",
    --
    "INJURY_LOWER",
    "INJURY_UPPER",
    "CURE",
    "CQC_CONTINUOUS",
    "BEHIND",
    "ENABLE_TARGET_MARKER_CHECK",
    "VOLGIN_CHASE",
    "TEST",
  }

  local statuses={}

  for i,playerStatus in ipairs(testValues)do
    table.insert(statuses,"PlayerStatus."..playerStatus.."="..tostring(PlayerStatus[playerStatus]))
  end
  InfCore.PrintInspect(statuses,"statuses")

  if true then return end

  local NULL_ID=GameObject.NULL_ID
  local GetGameObjectId=GameObject.GetGameObjectId
  local GetTypeIndex=GameObject.GetTypeIndex
  local SendCommand=GameObject.SendCommand

  for n=1,#InfNPCHeli.heliList do
    local heliName=InfNPCHeli.heliList[n]
    local heliObjectId = GetGameObjectId(heliName)
    InfCore.Log("bluuurg "..heliName)--DEBUGNOW
    if heliObjectId==NULL_ID then
      InfCore.Log(heliName.."==NULL_ID")--DEBUG, will trigger in battlegear hangar since it's a different pack --DEBUG
    else
      InfCore.Log("blooorg "..heliName)--DEBUGNOW
      local typeIndex=GetTypeIndex(heliObjectId)
      if typeIndex==TppGameObject.GAME_OBJECT_TYPE_ENEMY_HELI then
        InfCore.Log("spuuurg "..heliName)--DEBUGNOW

        --DEBUGNOW
        local heliMeshTypes={
          "uth_v00",
          "uth_v02",
          "uth_v03",
        }
        --DEBUGNOW local meshType=heliMeshTypes[math.random(#heliMeshTypes)]
        local meshType=heliMeshTypes[index1]

        GameObject.SendCommand(heliObjectId,{id="SetMeshType",typeName=meshType})
      end--if GAME_OBJECT_TYPE_ENEMY_HELI
    end--if heliname
  end--for heliList


  if true then return end

  local customSoldierType=IvarProc.GetForMission("customSoldierType",vars.missionCode)
  InfCore.Log("customSoldierType:"..tostring(customSoldierType))

  --for i=1,100 do
  --InfCore.Log(i)
  ---InfExtToMgsv.GetPlayerPos()
  --end

  if true then return end

  local markerPos=InfUserMarker.GetMarkerPosition(0)
  InfCore.PrintInspect(markerPos,"markerPos")
  local markerPos=InfUserMarker.GetMarkerPosition(nil)
  InfCore.PrintInspect(markerPos,"markerPos 2nd")

  local markerIndex=0
  vars.userMarkerPosX[markerIndex]=0+index1
  vars.userMarkerPosY[markerIndex]=0+index1
  vars.userMarkerPosZ[markerIndex]=0+index1

  InfCore.PrintInspect(vars.userMarkerGameObjId[markerIndex],"userMarkerGameObjId")

  --local dumpedVars=IHDebugVars.DumpVars()
  --IHDebugVars.PrintVars(dumpedVars)


  if true then return end

  local scriptBlockNames={
    "animal_block",
    "demo_block",
    "quest_block",
    "mission_block",
    "npc_block",
    "reinforce_block",
    "cypr_small_mission_block_1",
    "cypr_small_mission_block_2",
    "cypr_small_mission_block_3",
    "cypr_demo_block",
  }

  for i,blockName in ipairs(scriptBlockNames)do
    InfCore.PrintInspect(ScriptBlock.GetScriptBlockId(blockName),blockName)
  end

  if true then return end


  InfCore.PrintInspect(Time,"Time")
  local timeResult={
    deltaGameTime=Time.GetDeltaGameTime(),
    gameTimeRate=Time.GetGameTimeRate(),
    frameTime=Time.GetFrameTime(),
    rawElapsedTimeSinceStartUp=Time.GetRawElapsedTimeSinceStartUp(),
    frameIndex=Time.GetFrameIndex(),
  }

  for name,result in pairs(timeResult)do
    InfCore.Log(name..":"..tostring(result))
  end

  if true then return end

  InfUAV.SetupUAV()
  if true then return end
  local fileList=File.GetFileListTable("/Assets/tpp/pack/player/motion/player2_location_motion.fpk")
  InfCore.PrintInspect(fileList,"fileList")


  --    GetBlockPackagePath = "<function>",
  --    GetFileListTable = "<function>",
  --    GetReferenceCount = "<function>",

  local identifier="HelispaceLocatorIdentifier"
  --  local locatorName="BuddyQuietLocator"
  local key="BuddyDDogLocator"
  local data=DataIdentifier.GetDataWithIdentifier(identifier,key)
  local dataSet=Data.GetDataSet(data)
  local dataSetFile=DataSet.GetDataSetFile(dataSet)
  local  blockPackagePath=File.GetBlockPackagePath(dataSetFile)

  -- local  blockPackagePath=File.GetBlockPackagePath("/Assets/tpp/pack/player/motion/player2_location_motion.fpk")

  -- local  blockPackagePath=File.GetBlockPackagePath(data)
  InfCore.PrintInspect(blockPackagePath,"blockPackagePath")

  --local  referenceCount=File.GetReferenceCount("/Assets/tpp/pack/player/motion/player2_location_motion.fpk")
  local  referenceCount=File.GetReferenceCount("Tpp/Scripts/Equip/EquipMotionData.lua")
  InfCore.PrintInspect(referenceCount,"referenceCount")

end

local index2Min=300
local index2Max=334
local index2=index2Min
this.DEBUG_SomeShiz2=function()
  InfCore.Log("---DEBUG_SomeShiz2---",true,true)


  Gimmick.StoreSaveDataPermanentGimmickForMissionClear()
  Gimmick.StoreSaveDataPermanentGimmickFromMissionAfterClear()

  if true then return end

  --REF
  --this.SAVE_SLOT={
  --  GLOBAL=0,
  --  CHECK_POINT=1,
  --  RETRY=2,
  --  MB_MANAGEMENT=3,
  --  QUEST=4,
  --  MISSION_START=5,
  --  CHECK_POINT_RESTARTABLE=6,
  --  CONFIG=7,
  --  SAVING=8,
  --  CONFIG_SAVE=9,
  --  PERSONAL=10,
  --  PERSONAL_SAVE=11,
  --  MGO=12,
  --  MGO_SAVE=13
  --}

  local varName="totalNeutralizeCount"
  local value = TppScriptVars.GetVarValueInSlot(TppDefine.SAVE_SLOT.GLOBAL, "gvars", varName )

  InfCore.PrintInspect(value,varName)

  local varsType="gvars"
  local varName="inf_interCpQuestStatus"
  local category=TppDefine.SAVE_SLOT.CATEGORY_MISSION
  local value = TppScriptVars.GetVarValueInSlot(category,varsType,varName)
  InfCore.PrintInspect(value,varName)

  local varsType="gvars"
  local varName="initAmmoStockIds"
  local category=TppDefine.SAVE_SLOT.CATEGORY_MISSION
  local value = TppScriptVars.GetVarValueInSlot(category,varsType,varName)
  InfCore.PrintInspect(value,varName)



  if true then return end

  local varsSize=#this.weaponCategories*this.SLOTS_PER_CATEROGRY*this.PARTS_COUNT
  for i=0,varsSize-1 do
    vars.userPresetChimeraParts[i]=0
  end
  if true then return end

  -- vars.missionCode=12345--

  local function PrintInfo(object,objectName)
    InfCore.Log("PrintInfo "..objectName..":")
    InfCore.PrintInspect(object,objectName.." Inspect")
    InfCore.PrintInspect(getmetatable(object),objectName.." Inspect metatable")
    InfCore.Log(objectName.." tostring:"..tostring(object))
  end

  --  --tex in helispace \chunk3_dat\Assets\tpp\pack\mission2\heli\h40050\h40050_area_fpkd\Assets\tpp\level\mission2\heli\h40050\h40050_sequence.fox2 (or equivalent h40010,h40020 fox2) is loaded
  --  --it has a DataIdentifier named HelispaceLocatorIdentifier
  --  --DataIdentifier have key / nameInfArchive paths to other Data / Entities, this is what DataIdentifier.GetDataWithIdentifier used to return a Data entity.
  --  local identifier="HelispaceLocatorIdentifier"
  --  --  local locatorName="BuddyQuietLocator"
  --  local key="BuddyDDogLocator"
  --  InfCore.Log("identifier: "..identifier)
  --  InfCore.Log("key: "..key)
  --  local data=DataIdentifier.GetDataWithIdentifier(identifier,key)
  --  PrintInfo(data,"data")
  --  --OUTPUT
  --  --PrintInfo data:
  --  --data Inspect=<userdata 1>
  --  --data Inspect metatable={
  --  --  __index = <function 1>,
  --  --  __newindex = <function 2>,
  --  --  __tostring = <function 3>
  --  --}
  --  --data tostring:Locator: 0x000000011624FF40
  --
  --  InfCore.PrintInspect(data:GetClassName(),"data:GetClassName()")
  --  --data:GetClassName()="Locator"
  --  InfCore.PrintInspect(data:GetPropertyList(),"data:GetPropertyList()")
  --  --data:GetPropertyList()={ "name", "referencePath", "parent", "transform", "shearTransform", "pivotTransform", "inheritTransform", "visibility", "selection", "worldMatrix", "worldTransform", "size" }
  --  InfCore.PrintInspect(data:GetPropertyInfo("name"),"data:GetPropertyInfo('name')")
  --  --data:GetPropertyInfo('name')={
  --  --  arraySize = 1,
  --  --  container = "StaticArray",
  --  --  dynamic = false,
  --  --  export = "RW",
  --  --  name = "name",
  --  --  storage = "Instance",
  --  --  type = "String"
  --  --}
  --  --tex as you can see the properties of entites can be accessed with dot notation
  --  InfCore.PrintInspect(data.name,"data.name")
  --  --data.name="BuddyDDogLocator"
  --  InfCore.PrintInspect(data.referencePath,"data.referencePath")
  --  --data.referencePath="BuddyDDogLocator"

  ---
  InfCore.Log("---------")
  local identifier="PlayerDataIdentifier"
  --  local locatorName="BuddyQuietLocator"
  local key="PlayerGameObject"
  InfCore.Log("identifier: "..identifier)
  InfCore.Log("key: "..key)

  local data=DataIdentifier.GetDataWithIdentifier(identifier,key)
  PrintInfo(data,"data")
  --OUTPUT
  --PrintInfo data:
  --data Inspect=<userdata 1>
  --data Inspect metatable={
  --  __index = <function 1>,
  --  __newindex = <function 2>,
  --  __tostring = <function 3>
  --}
  --data tostring:Locator: 0x000000011624FF40

  InfCore.PrintInspect(data:GetClassName(),"data:GetClassName()")
  --data:GetClassName()="GameObject"
  InfCore.PrintInspect(data:GetPropertyList(),"data:GetPropertyList()")
  --data:GetPropertyList()={ "name", "referencePath", "typeName", "groupId", "totalCount", "realizedCount", "parameters" }
  InfCore.PrintInspect(data:GetPropertyInfo("name"),"data:GetPropertyInfo('name')")
  --data:GetPropertyInfo('name')={
  --  arraySize = 1,
  --  container = "StaticArray",
  --  dynamic = false,
  --  export = "RW",
  --  name = "name",
  --  storage = "Instance",
  --  type = "String"
  --}
  --tex as you can see the properties of entites can be accessed with dot notation
  InfCore.PrintInspect(data.name,"data.name")
  --data.name="PlayerGameObject"
  InfCore.PrintInspect(data.referencePath,"data.referencePath")
  --data.referencePath="PlayerGameObject"

  ---
  InfCore.PrintInspect(data:GetPropertyInfo("parameters"),"data:GetPropertyInfo('parameters')")
  --data:GetPropertyInfo('parameters')={
  --  arraySize = 1,
  --  container = "StaticArray",
  --  dynamic = false,
  --  export = "RW",
  --  name = "name",
  --  storage = "Instance",
  --  type = "String"
  --}
  --tex as you can see the properties of entites can be accessed with dot notation
  InfCore.PrintInspect(data.parameters,"data.parameters")
  --data.parameters=
  local parameters=data.parameters
  InfCore.PrintInspect(tostring(parameters),"tostring(parameters)")


  -- InfCore.PrintInspect(parameters:GetPropertyList(),"parameters:GetPropertyList()")
  IHH.TestCallToIHHook(data)
  --DEBUGNOW

  InfCore.DebugPrint("index2:"..index2)
  index2=index2+1
  if index2>index2Max then
    index2=index2Min
  end
end

local index3Min=1
local index3Max=10
local index3=index3Min
local toggle3=false
this.DEBUG_SomeShiz3=function()
  InfCore.Log("---DEBUG_SomeShiz3---",true,true)
  local camoFv2Path="/Asset/stpp/fova/chara/svs/svs0_unq_v09.fv2"--
  local fovaFile=camoFv2Path
  Player.ApplyFormVariationWithFile(fovaFile)

  if true then return end

  local routes={
    --      "rt_slopedWest_d_0000_sub",
    --        "rt_slopedWest_d_0004",
    --        "rt_slopedWest_d_0003",
    "rt_slopedWest_d_0002",
    --        "rt_slopedWest_d_0001",
    "rt_slopedWest_d_0005",

    --        "rt_slopedWest_n_0000",
    "rt_slopedWest_n_0004",
    --        "rt_slopedWest_n_0003",
    --        "rt_slopedWest_n_0002",
    --        "rt_slopedWest_n_0001",
    --        "rt_slopedWest_n_0005",

    --        "rt_slopedWest_c_0000",
    --        "rt_slopedWest_c_0003",
    --        "rt_slopedWest_c_0001",
    --        "rt_slopedWest_c_0004",
    --        "rt_slopedWest_c_0002",
    "rt_slopedWest_c_0004",

    "rt_slopedWest_s_0000",
  --"rt_slopedWest_s_0001",
  }
  index3Max=#routes

  local soldierName="sol_slopedWest_0000"
  local routeName=routes[index3]
  InfCore.DebugPrint(routeName)
  InfSoldier.WarpSetRoute(soldierName,routeName)

  --  local objectName = "sol_slopedWest_0000"
  --  local gameId=GetGameObjectId(objectName)
  --  local objectPos=GameObject.SendCommand(gameId,{id="GetPosition"})
  --  if objectPos==nil then
  --    InfCore.Log("GetPosition nil for "..objectName,true)
  --  else
  --    InfCore.Log(objectName.." pos:".. objectPos:GetX()..",".. objectPos:GetY().. ","..objectPos:GetZ(),true)
  --  end
  --
  --  if true then return end
  --
  --  InfCore.PrintInspect(TppLandingZone.assaultLzs,"assaultLzs")
  --  InfCore.PrintInspect(TppLandingZone.missionLzs,"missionLzs")
  --
  --  local lastMarkerIndex=InfUserMarker.GetLastAddedUserMarkerIndex()
  --  local closestRoute
  --  if lastMarkerIndex==nil then
  --    InfMenu.PrintLangId"no_marker_found"
  --    return
  --  else
  --    local markerPostion=InfUserMarker.GetMarkerPosition(lastMarkerIndex)
  --    markerPostion={markerPostion:GetX(),markerPostion:GetY(),markerPostion:GetZ()}
  --
  --    closestRoute=InfLZ.GetClosestLz(markerPostion)
  --  end
  --
  --  InfCore.PrintInspect(closestRoute,"closestRoute")

  InfCore.DebugPrint("index3:"..index3)
  index3=index3+1
  if index3>index3Max then
    index3=index3Min
  end
  toggle3=not toggle3
end
--< menuCommands





--tex called from QuickMenuDefs_User <CALL> + <ACTION>
function this.DebugAction()
  InfCore.Log("IHDebugVars.DebugAction",true,true)



  -- TppSound.SetPhaseBGM( "bgm_fob_neutral" )

  --  InfCore.PrintInspect(vars,"vars")
  --  local metaTable=getmetatable(vars)
  --  InfCore.PrintInspect(metaTable,"vars metaTable")

  --this.DumpSoldierInfo()
  --InfCore.Log("Fox.ClassInfo")
  --Fox.ClassInfo()--tex PrintClassInfoSimple
  --Fox.ClassInfo("Rotation")--className --TODO: any other params?
  --InfCore.Log("Fox.GenSid")
  --Fox.GenSid("something")
end--DebugAction

--DEBUGNOW
--function this.AddMissionPacks(missionCode,packPaths)
--    if missionCode==30010 then
--    packPaths[#packPaths+1]="/Assets/tpp/somemissing.fpk"
--  end
--end

this.debug_GrTools_SetLodScale={
  --save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range={min=0,max=10000,increment=0.1},
  OnChange=function(self,setting)
    GrTools.SetLodScale(setting)
  end,
}

this.debug_GrTools_SetVertexLodScale={
  --save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range={min=0,max=10000,increment=0.1},
  OnChange=function(self,setting)
    GrTools.SetVertexLodScale(setting)
  end,
}




this.debug_GrTools_SetModelLodScale={
  --save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=10000,increment=0.1},
  OnChange=function(self,setting)
    GrTools.SetModelLodScale(setting)
  end,
}

this.debug_GrTools_SetModelVertexLodScale={
  --save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=10000,increment=0.1},
  OnChange=function(self,setting)
    GrTools.SetModelVertexLodScale(setting)
  end,
}
--tex set to screen resolution or higher?, more effective in increasing lod than others
--ADDLANG set to screen resolution for default, and higher for higher lods loaded further, scales logarythimically
--warning at high levels hitching will occur as it loads if you are travelling at high speed speed via freecam (happens somewhat even without using this, this just accecerbates it
--help grTools_SetLodFactorResolution="Sets how Level Of Detail of loaded world models scale to disatance vs screen resolution. Set it to your screen reolution for default or higher for higher LOD. Scales logarythmically.",
this.debug_GrTools_SetLodFactorResolution={
  --save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=100000,increment=1000},
  OnChange=function(self,setting)
    GrTools.SetLodFactorResolution(setting)
  end,
}

this.debug_GrTools_SetOccluderEffectiveRange={
  --save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=1000000,increment=0.1},
  OnChange=function(self,setting)
    GrTools.SetOccluderEffectiveRange(setting)
  end,
}

this.debug_GrTools_SetOccluderLimit={
  --save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=1000000,increment=0.1},
  OnChange=function(self,setting)
    GrTools.SetOccluderLimit(setting)
  end,
}

--sets for default camera, SetCameraParams already has alphaDistance, DEBUGNOW but do we want this for all?
this.debug_Player_SetAroundCameraMaxDistanceForAlphaExamination={
  --save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=1000000,increment=0.1},
  OnChange=function(self,setting)
    Player.SetAroundCameraMaxDistanceForAlphaExamination(setting)
  end,
}

this.debug_vars_playerType={
  --save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=6,},
  OnActivate=function(self,setting)
    vars.playerType=setting
  end,
}

this.UnSetStandMoveSpeedLimit=function()
  GameObject.SendCommand( { type="TppPlayer2", index=PlayerInfo.GetLocalPlayerIndex() }, { id="SetStandMoveSpeedLimit", speedRateLimit = -1 } )
end

this.setStandMoveSpeedLimit={
  --save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=60,increment=0.1},
  OnChange=function(self,setting)
    --tex speedRateLimit 0-1 - controls normal run speed (not slow walk or sprint) 0 = slow walk speed - 1(max) = normal speed
    GameObject.SendCommand({type="TppPlayer2",index=PlayerInfo.GetLocalPlayerIndex()},{id="SetStandMoveSpeedLimit",speedRateLimit=setting})
  end,
}



return this
