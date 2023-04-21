function this.Init()
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

end





function this.OnReload(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  if IvarProc.EnabledForMission"routeset_randomizeRouteSets" then
    this.RandomizeCurrentRouteSet()
  end
end--OnReload

function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.Messages()
  return Tpp.StrCode32Table{
    Weather={
      {msg="Clock",sender="IH-00-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-01-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-02-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-03-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-04-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-05-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-06-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-07-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-08-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-09-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-10-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-11-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-12-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-13-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-14-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-15-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-16-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-17-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-18-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-19-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-20-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-21-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-22-00",func=this.IHDebugHourClock},
      {msg="Clock",sender="IH-23-00",func=this.IHDebugHourClock},
    },--Weather
  }--StrCode32Table message table
end--Messages


this.soldierInfo={}

this.day=0

function this.SetupDumpSoldier()

  local incrementHours=3

  for hour=0,24,incrementHours do

    TppClock.RegisterClockMessage(string.format("IH-%02d-00",hour),string.format("%02d:00:00",hour))

  end

end

local levelSeed=0

function this.DumpSoldierInfoForHour(sender,time)

  if vars.missionCode~=30010 then

    return

  end



  local lines={}

  local function AddLine(line)

    table.insert(lines,line)

  end



  local WriteLines = function(fileName,lines)

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



  --afgh_enemyBase_cp="Wakh Sind Barracks",

  local cpName="afgh_enemyBase_cp"

  local cpId=GameObject.GetGameObjectId("TppCommandPost2",cpName)

  local hours,minutes,seconds=TppClock.GetTime()

  local worldTime=string.format("%02d-%02d-%02d",hours,minutes,seconds)

  local senderStr=InfLookup.StrCode32ToString(sender)



  InfCore.Log("IHDebugVars.DumpSoldierInfoForHour "..senderStr.." - "..worldTime)





  TppCheckPoint.Update{safetyCurrentPosition=true}

  --    while TppSave.IsSaving()do

  --      InfCore.Log"waiting saving end..."

  --      coroutine.yield()

  --    end



  AddLine("IHDebugVars.DumpSoldierInfoForHour")

  AddLine("inf_levelSeed: "..igvars.inf_levelSeed)

  AddLine("cpName: "..cpName)







  if levelSeed~=igvars.inf_levelSeed then

    this.soldierInfo={}

  end

  levelSeed=igvars.inf_levelSeed



  local soldiers={

    afgh_enemyBase_cp = {

      "sol_enemyBase_0000",

      "sol_enemyBase_0001",

      "sol_enemyBase_0002",

      "sol_enemyBase_0003",

      "sol_enemyBase_0004",

      "sol_enemyBase_0005",

      "sol_enemyBase_0006",

      "sol_enemyBase_0007",

      "sol_enemyBase_0008",

      "sol_enemyBase_0009",

      "sol_enemyBase_0010",

      "sol_enemyBase_0011",

      "sol_enemyBase_0012",

      "sol_enemyBase_0013",

      nil

    },

  }--soldiers







  for i,soldierName in ipairs(soldiers[cpName])do

    local svarIndex=InfLookup.SoldierSvarIndexForName(soldierName)

    if svarIndex==nil then

      InfCore.Log("Could not find svarIndex")

    else



      local soldierInfo=this.soldierInfo[soldierName] or {}

      this.soldierInfo[soldierName]=soldierInfo

      local soldierTime=soldierInfo[senderStr] or {}--soldier routes for world time, using sender/clock name since actual clock time varies

      soldierInfo[senderStr]=soldierTime

      table.insert(soldierTime,InfLookup.StrCode32ToString(svars.solCpRoute[svarIndex]))

    end

  end

  InfCore.PrintInspect(this.soldierInfo,"dump soldierInfo")





  AddLine("soldierInfo=")

  AddLine(InfInspect.Inspect(this.soldierInfo))





  local fileName=[[C:\Projects\MGS\InfiniteHeaven\tpp\mod-gamedir\dump-soldierinfo-]]..igvars.inf_levelSeed..[[-.txt]]



  WriteLines(fileName,lines)

end--DumpSoldierInfoForHour



function this.DumpSoldierInfo()

  if vars.missionCode~=30010 then

    return

  end



  ---

  local lines={}

  local function AddLine(line)

    table.insert(lines,line)

  end



  local WriteLines = function(fileName,lines)

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









  InfCore.PrintInspect(this.soldierInfo,"soldierInfo")



  --afgh_enemyBase_cp="Wakh Sind Barracks",

  local cpName="afgh_enemyBase_cp"

  local cpId=GameObject.GetGameObjectId("TppCommandPost2",cpName)



  AddLine(InfInspect.Inspect(mvars.ene_shiftChangeTable))

  local fileName=[[C:\Projects\MGS\InfiniteHeaven\tpp\mod-gamedir\dump-ene_shiftChangeTable-inspect-]]..igvars.inf_levelSeed..[[.txt]]

  WriteLines(fileName,lines)



  lines={}



  -- InfCore.PrintInspect(mvars.ene_holdTimes,"mvars.ene_holdTimes")



  -- InfCore.PrintInspect(mvars.ene_shiftChangeTable[cpId],"mvars.ene_shiftChangeTable[cpId]")--DEBUGNOW

  --REF

  --  mvars.ene_shiftChangeTable[cpId]={

  --  shiftAtMidNight = {

  --    {

  --      { "night", 1825487102 },

  --      <1>{ "sleep", "default" },

  --        holdTime = 300

  --    },

  --    {

  --      <table 1>,

  --      { "night", 1825487102 }

  --    },

  --    {

  --      { "night", 405073021 },

  --      <2>{ "sleep", "default" },

  --      holdTime = 300

  --    },

  --    {

  --      <table 2>,

  --      { "night", 405073021 }

  --    },

  --    {

  --      { "night", 1574494500 },

  --      <3>{ "sleep", "default" },

  --    holdTime = 300

  --    },

  --    { <table 3>, { "night", 1574494500 } }, { { "night", 2257358364 }, <4>{ "sleep", "default" },

  --      holdTime = 300

  --    },

  --    { <table 4>, { "night", 2257358364 } }, { { "night", 1894115093 }, <5>{ "sleep", "default" },

  --      holdTime = 300

  --    },

  --    { <table 5>, { "night", 1894115093 } } },

  --  shiftAtMorning = { { { "midnight", 1825487102 }, <6>{ "hold", "default" },

  AddLine("inf_levelSeed: "..igvars.inf_levelSeed)

  AddLine("os.clock: "..os.clock())

  AddLine("day: "..this.day)

  AddLine("Clock Time: "..TppClock.GetTime"string")

  AddLine("")

  AddLine("TppClock.NIGHT_TO_DAY: "..TppClock.NIGHT_TO_DAY)

  AddLine("TppClock.DAY_TO_NIGHT: "..TppClock.DAY_TO_NIGHT)

  AddLine("TppClock.NIGHT_TO_MIDNIGHT: "..TppClock.NIGHT_TO_MIDNIGHT)

  AddLine("")

  AddLine(cpName)

  AddLine"mvars.ene_shiftChangeTable[cpId]={"

  for cpId,cpShifts in pairs(mvars.ene_shiftChangeTable)do  --DEBUGNOW all

    local cpName=mvars.ene_cpList[cpId]

    AddLine("["..cpName .." cpId:"..cpId.."]={")--DEBUGNOW all

    --for shiftName,shifts in pairs(mvars.ene_shiftChangeTable[cpId])do

    for shiftName,shifts in pairs(cpShifts)do

      AddLine("\t"..shiftName.."={")

      for i,shiftUnit in ipairs(shifts)do

        if type(shiftUnit)~="table"then

          AddLine('\t\t['..i..']="'..tostring(shiftUnit)..'"')

        else

          AddLine("\t\t["..i.."]={")

          for k,v in pairs(shiftUnit)do

            if type(v)=="table"then

              AddLine('\t\t\t['..k..']={"'..v[1]..'","'..InfLookup.StrCode32ToString(v[2])..'"},')

            else

              AddLine("\t\t\t"..k.."="..tostring(v)..",")

            end

          end--for k,v

          AddLine("\t\t},")

        end

      end--for shifts

      AddLine("\t},")

    end--for ene_shiftChangeTable

    AddLine("},")--DEBUGNOW all

  end--DEBUGNOW

  AddLine("}--mvars.ene_shiftChangeTable[cpId]")

  AddLine""



  --  for i,line in ipairs(lines)do

  --    InfCore.Log(line)

  --  end





  local fileName=[[C:\Projects\MGS\InfiniteHeaven\tpp\mod-gamedir\dump-ene_shiftChangeTable]]..igvars.inf_levelSeed..[[.txt]]



  WriteLines(fileName,lines)



  local cpId=GameObject.GetGameObjectId("TppCommandPost2",cpName)

  local soldiers={

    afgh_enemyBase_cp = {

      "sol_enemyBase_0000",

      "sol_enemyBase_0001",

      "sol_enemyBase_0002",

      "sol_enemyBase_0003",

      "sol_enemyBase_0004",

      "sol_enemyBase_0005",

      "sol_enemyBase_0006",

      "sol_enemyBase_0007",

      "sol_enemyBase_0008",

      "sol_enemyBase_0009",

      "sol_enemyBase_0010",

      "sol_enemyBase_0011",

      "sol_enemyBase_0012",

      "sol_enemyBase_0013",

      nil

    },

  }--soldiers







  for i,soldierName in ipairs(soldiers[cpName])do

    local gameObjectId=GameObject.GetGameObjectId("TppSoldier2",soldierName)

    local radius=0

    local goalType="none"

    local viewType="map_and_world_only_icon"

    local randomRange=0

    local setImportant=false

    local setNew=false

    TppMarker.Enable(gameObjectId,radius,goalType,viewType,randomRange,setImportant,setNew)

    --TppMarker.Enable(gameObjectName,visibleArea,goalType,viewType,randomRange,setImportant,setNew,mapRadioName,langId,goalLangId,setInterrogation)

  end





  if true then return end



  ------------------------------



  --DEBUGNOW

  TppCheckPoint.Update{safetyCurrentPosition=true}

  --    while TppSave.IsSaving()do

  --      InfCore.Log"waiting saving end..."

  --      coroutine.yield()

  --    end











  local lines={}

  local function AddLine(line)

    table.insert(lines,line)

  end



  local WriteLines = function(fileName,lines)

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



  ----



  AddLine("inf_levelSeed: "..igvars.inf_levelSeed)

  AddLine("os.clock: "..os.clock())

  AddLine("day: "..this.day)

  AddLine("Clock Time: "..TppClock.GetTime"string")

  AddLine("")

  AddLine("TppClock.NIGHT_TO_DAY: "..TppClock.NIGHT_TO_DAY)

  AddLine("TppClock.DAY_TO_NIGHT: "..TppClock.DAY_TO_NIGHT)

  AddLine("TppClock.NIGHT_TO_MIDNIGHT: "..TppClock.NIGHT_TO_MIDNIGHT)

  AddLine("")







  --

  local hours,minutes,seconds=TppClock.GetTime()

  local worldTime=string.format("%02d-%02d-%02d",hours,minutes,seconds)



  for i,soldierName in ipairs(soldiers[cpName])do

    local svarIndex=InfLookup.SoldierSvarIndexForName(soldierName)

    if svarIndex==nil then

      InfCore.Log("Could not find svarIndex")

    else





      local soldierSvarName={

        "solName",

        "solState",

        "solFlagAndStance",

        "solWeapon",

        "solLocation",

        "solMarker",

        "solFovaSeed",

        "solFaceFova",

        "solBodyFova",

        "solCp",

        "solCpRoute",

        "solScriptSneakRoute",

        "solScriptCautionRoute",

        "solScriptAlertRoute",

        "solRouteNodeIndex",

        "solRouteEventIndex",

        "solTravelName",

        "solTravelStepIndex",

      }--soldierSvarName



      --DEBUGNOW these are seperate? have to iterate to find matching solOptName?

      --    {name="solOptName",arraySize=TppDefine.DEFAULT_SOLDIER_OPTION_VARS_COUNT,type=TppScriptVars.TYPE_UINT32,value=0,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},

      --    {name="solOptParam1",arraySize=TppDefine.DEFAULT_SOLDIER_OPTION_VARS_COUNT,type=TppScriptVars.TYPE_UINT32,value=0,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},

      --    {name="solOptParam2",arraySize=TppDefine.DEFAULT_SOLDIER_OPTION_VARS_COUNT,type=TppScriptVars.TYPE_UINT32,value=0,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},



      AddLine(soldierName)

      AddLine("Soldier svar index: "..tostring(svarIndex))

      AddLine("solCpRoute: "..InfLookup.StrCode32ToString(svars.solCpRoute[svarIndex]))

      --AddLine("solScriptSneakRoute: "..InfLookup.StrCode32ToString(svars.solScriptSneakRoute[svarIndex]))--tex DEBUGNOW not sure why these arent finding their strings

      --AddLine("solScriptCautionRoute: "..InfLookup.StrCode32ToString(svars.solScriptCautionRoute[svarIndex]))

      --AddLine("solScriptAlertRoute: "..InfLookup.StrCode32ToString(svars.solScriptAlertRoute[svarIndex]))

      --AddLine("solRouteNodeIndex: "..svars.solRouteNodeIndex[svarIndex])

      --AddLine("solRouteEventIndex: "..svars.solRouteEventIndex[svarIndex])

      AddLine("")

    end--if svarIndex

  end--for soldiers.afgh_enemyBase_cp





  local fileName=[[C:\Projects\MGS\InfiniteHeaven\tpp\mod-gamedir\dumpsoldierinfo-]]..worldTime.."-"..os.clock()..[[.txt]]



  WriteLines(fileName,lines)

end--DumpSoldierInfo

function this.IHDebugHourClock(sender,time)
  this.DumpSoldierInfoForHour(sender,time)
end
