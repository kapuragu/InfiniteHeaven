-- InfWalkerGear.lua
local this={}

local InfCore=InfCore
local InfMain=InfMain
local GetGameObjectId=GameObject.GetGameObjectId
local NULL_ID=GameObject.NULL_ID
local SendCommand=GameObject.SendCommand

this.debugModule=false

this.mvar_walkerInfo={}
this.walkerPlats={}

this.walkerPool={}--tex free walkers

function this.PostModuleReload(prevModule)
  this.mvar_walkerInfo=prevModule.mvar_walkerInfo
  this.walkerPlats=prevModule.walkerPlats

  this.walkerPool=prevModule.walkerPool
end--PostModuleReload

this.numLrrpWalkers=5--tex FREE pulled from total
this.walkersPerLrrp=1--tex soldiers done respect each others personal space lol, which is more of an issue with walkers. unless I can set up command SetForceFormationLine
this.numWalkerGears=10--DEBUGNOW--tex dependant on the entity defs, also see see TppEnemy.DeclareSvars/mvars.ene_maxWalkerGearStateCount

this.walkerNames=InfUtil.GenerateNameList("wkr_WalkerGear_%04d",this.numWalkerGears)

this.packages={
  "/Assets/tpp/pack/mission2/common/mis_com_walkergear.fpk",--TppDefine.MISSION_COMMON_PACK.WALKERGEAR
  --DEBUGNOW "/Assets/tpp/pack/mission2/ih/ih_walker_gear_defloc.fpk"
  "/Assets/tpp/pack/mission2/ih/ih_walker_gear_def.fpk",
  afgh={
    "/Assets/tpp/pack/mission2/ih/ih_walker_gear_loc_afgh.fpk",
  },
  mafr={
    "/Assets/tpp/pack/mission2/ih/ih_walker_gear_loc_mafr.fpk",
  },
  mtbs={
    "/Assets/tpp/pack/mission2/ih/ih_walker_gear_loc_mtbs.fpk",
  },
}

local walkerGearEquip={
  WALKERGEAR_EQP_MACHINEGUN=0,
  WALKERGEAR_EQP_MISSILE=1,
}

--tex "SetColoringType" type, from 0
this.walkerGearColorTypeName={
  "SOVIET",--green, default
  "ROGUE_COYOTE",--Blue grey
  "CFA",--tan
  "ZRS",
  "DDOGS",--light grey
  "HUEY_PROTO",--yellow/grey - texure error on side shields since it's used in 10070 : Mission 12 - Hellbound with "SetExtraPartsForSpecialEnemy" which has no side shields
}
local walkerGearColorType=TppDefine.Enum(this.walkerGearColorTypeName)

local cpSubTypeToColor={
  SOVIET_A="SOVIET",
  SOVIET_B="SOVIET",
  PF_A="CFA",
  PF_B="ZRS",
  PF_C="ROGUE_COYOTE",
}

--tex doesn't seem to have an unrealize command, so have to put unused walkers out of the way
--if it's an invalid spawn position it seems it will shift it to a 'safeposition' - in afgh its near the guardpost 11 (near the lz in the middle of map)
--sometimes see lrrp soldiers put there. guess it's nearest nav mesh position thing?
local walkerStorePositions={
  afgh={-2787.008,429.208,-838.168},
  mafr={2881.206,103.251,-851.613},
}

local walkerStartPositions={}

--DEBUGNOW TODO check positions match clusters
walkerStartPositions.mtbs={
  --Command
  {
    {pos={1.275,0.00,-30.20},rot=0},
    {pos={117.35,0.00,-5.05},rot=-94},
    {pos={233.315,0.00,-57.34},rot=131},
    {pos={323.00,0.00,-51.00},rot=180},
  },
  --Combat
  {
    {pos={1149.00,0.00,-591.00},rot=45},
    {pos={1150.15,0.00,-741.00},rot=0},
    {pos={1253.00,4.00,-809.00},rot=-90},
    {pos={1356.065,0.00,-792.547},rot=90},
  },
  --Develop
  {
    {pos={1199.72,32.00,298.822},rot=135},
    {pos={1317.23,0.00,338.366},rot=-45},
    {pos={1410.00,0.00,231.00},rot=-45},
    {pos={1526.00,0.00,229.00},rot=-180},
  },
  --Support
  {
    {pos={-754.00,8.00,-356.00},rot=0},
    {pos={-821.587,0.00,-473.22},rot=-45},
    {pos={-952.00,0.00,-483.00},rot=0},
    {pos={-1015.132,0.00,-570.126},rot=0},
  },
  --Medical
  {
    {pos={372.00,0.00,875.00},rot=0},
    {pos={464.62,0.00,937.96},rot=135},
    {pos={435.637,0.00,1074.866},rot=90},
    {pos={343.397,0.00,1166.265},rot=45},
  },
  --Spy
  {
    {pos={-654.565,4.00,536.165},rot=89},
    {pos={-693.882,0.00,665.266},rot=0},
    {pos={-794.00,0.00,740.00},rot=-45},
    {pos={-797.00,0.00,853.00},rot=0},
  },
  --BaseDev
  {
    {pos={-143.546,0.00,-973.570},rot=134.5},
    {pos={-121.202,0.00,-1076.245},rot=230},
    {pos={-231.141,0.00,-1169.666},rot=-45},
    {pos={-160.00,0.00,-1306.00},rot=0},
  },
}

walkerStartPositions.afgh={
  afgh_cliffTown_cp={
    {pos={779.312,463.273,-989.820},rot=-177.267},
  },
  afgh_tent_cp={
    {pos={-1763.372,311.495,784.801},rot=178.618},
  },
  afgh_powerPlant_cp={
    {pos={-676.716,533.915,-1474.162},rot=82.7},
  },
  afgh_sovietBase_cp={
    {pos={-2335.55,439.315,-1482.474},rot=-58.77},
  },
  afgh_remnants_cp={
    {pos={-906.802,288.846,1923.874},rot=100.7},--skip
  },
  afgh_field_cp={
    {pos={415.052,270.933,2207.31},rot=-178.46},--skip
  },
  afgh_citadel_cp={
    {pos={-1232.651,600.599,-3098.633},rot=90.475},--skip
  },
  afgh_fort_cp={
    {pos={2144.533,455.413,-1752.163},rot=-31},
  },
  afgh_village_cp={
    {pos={506.986,320.590,1154.721},rot=73},
  },
  afgh_bridge_cp={
    {pos={1941.284,322.766,-528.093},rot=50.1},
  },
  afgh_commFacility_cp={
    {pos={1491.027,357.429,469.534},rot=131.386},
  },
  afgh_slopedTown_cp={
    {pos={541.161,328.605,58.012},rot=8.95},
  },
  afgh_enemyBase_cp={
    {pos={-599.556,344.370,440.566},rot=-21.056},
  },
}

walkerStartPositions.mafr={
  mafr_flowStation_cp={
    {pos={-1016.995,-13.298,-205.649},rot=30.056},
  },
  mafr_banana_cp={
    {pos={252.424,44.181,-1220.282},rot=-77.555},
  },
  mafr_diamond_cp={
    {pos={1356.577,139.196,-1621.228},rot=-105.199},
  },
  mafr_lab_cp={
    {pos={2688.769,174.224,-2423.233},rot=-95.755},
  },
  mafr_swamp_cp={
    {pos={-49.960,-4.169,65.055},rot=155.761},
  },
  mafr_outland_cp={
    {pos={-623.962,-11.043,999.645},rot=141.762},
  },
  mafr_savannah_cp={
    {pos={985.901,26.219,-219.649},rot=-80.459},
  },
  mafr_pfCamp_cp={
    {pos={780.558,-11.102,1179.146},rot=-119.793},
  },--Nova Braga Airport
  mafr_hill_cp={
    {pos={2172.074,56.796,407.998},rot=-29.473},
  },
--{pos={225.789,1.643,-624.561},rotY=71.320,},
}

this.registerIvars={
  "enableWalkerGearsFREE",
  "enableWalkerGearsMB",
  "mbWalkerGearsColor",
  "mbWalkerGearsWeapon",
}

IvarProc.MissionModeIvars(
  this,
  "enableWalkerGears",
  {
    save=IvarProc.CATEGORY_EXTERNAL,
    range=Ivars.switchRange,
    settingNames="set_switch",
  },
  {"FREE","MB"}
)
this.enableWalkerGearsFREE.MissionCheck=IvarProc.MissionCheckFreeVanilla--tex WORKAROUND: want to change the mission mode check but don't want to trample users exising saves with a name change

this.mbWalkerGearsColor={
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={
    "SOVIET",--green, default
    "ROGUE_COYOTE",--Blue grey
    "CFA",--tan
    "ZRS",
    "DDOGS",--light grey
    "HUEY_PROTO",--yellow/grey - texure error on side shields
    "RANDOM",--all of one type
    "RANDOM_EACH",--each random
  },
}

this.mbWalkerGearsWeapon={
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={
    "DEFAULT",--dont apply specific value, seems to alternate to give an even count of miniguns and missiles
    "MINIGUN",
    "MISSILE",
    "RANDOM",--all of one type
    "RANDOM_EACH",
  },
}
--<
this.langStrings={
  eng={
    enableWalkerGearsMB="Walker gears in MB",
    enableWalkerGearsFREE="Walker gears in free roam",
    mbWalkerGearsColor="Walker gears type",
    mbWalkerGearsColorSettings={
      "Soviet",
      "Rogue Coyote",
      "CFA",
      "ZRS",
      "Diamond Dogs",
      "Hueys Prototype (texture issues)",
      "All one random type",
      "Each gear random type",
    },
    mbWalkerGearsWeapon="Walker gears weapons",
    mbWalkerGearsWeaponSettings={
      "Even split of weapons",
      "Minigun",
      "Missiles",
      "All one random type",
      "Each gear random type",
    },
  },
  help={
    eng={
      enableWalkerGearsFREE="Adds a Walker gear to each main base.",
    },
  },
}

function this.OnAllocate(missionTable)
  if not IvarProc.EnabledForMission("enableWalkerGears") then
    return
  end
  
  if missionTable.enemy and missionTable.enemy.MAX_WALKER_GEAR_STATE_COUNT then
    InfCore.Log("WARNING: InfWalkerGear.OnAllocate missionTable.enemy.MAX_WALKER_GEAR_STATE_COUNT=="..tostring(missionTable.enemy.MAX_WALKER_GEAR_STATE_COUNT))
  end
  mvars.ene_maxWalkerGearStateCount=this.numWalkerGears
end

function this.Init()
  if not IvarProc.EnabledForMission("enableWalkerGears") then
    return
  end

  if vars.missionCode==30050 then
    this.SetupGearsMB()
  else
    this.SetupGearsFREE(this.mvar_walkerInfo,this.walkerPool)
  end
end

function this.SetUpEnemy(missionTable)
  this.SetUpEnemyGear(missionTable,InfMainTpp.lrrpDefines)
end

function this.AddMissionPacks(missionCode,packPaths)
  if not IvarProc.EnabledForMission("enableWalkerGears",missionCode) then
    return
  end

  for i,packPath in ipairs(this.packages) do
    packPaths[#packPaths+1]=packPath
  end

  local locationName=TppLocation.GetLocationName()
  if this.packages[locationName] then
    for i,packPath in ipairs(this.packages[locationName]) do
      packPaths[#packPaths+1]=packPath
    end
  end
end

--IN/OUT: walkerPool,walkerInfos
--IN-SIDE: this.walkerNames
function this.SetupGearsFREE(walkerInfos,walkerPool)
  local locationName=TppLocation.GetLocationName()
  --tex shift too 'off' position

  if TppMission.IsMissionStart() then
    for i,walkerName in ipairs(this.walkerNames) do
      local walkerId=GetGameObjectId("TppCommonWalkerGear2",walkerName)
      if walkerId==NULL_ID then
        InfCore.DebugPrint("WARNING NULL_ID for "..walkerName)
      else
        local storePos=walkerStorePositions[locationName]
        local command={id="SetPosition",pos={storePos[1]+i,storePos[2],storePos[3]},rotY=0}
        --OFF DEBUGNOW SendCommand(walkerId,command)
        --TODO: breaks when other locators loaded (quest for example), possible solution is to run this at a later stage (do so for mtbs too).
      end
    end
  end

  InfMain.RandomSetToLevelSeed()

  local positions=walkerStartPositions[locationName]

  local positionCps={}
  for cpName,coordList in pairs(positions)do
    local cpId=GetGameObjectId("TppCommandPost2",cpName)
    if cpId==NULL_ID then
      InfCore.Log("InfWalker.positions "..tostring(cpName).." cpId==NULL_ID")--DEBUG
    else
      positionCps[#positionCps+1]=cpName
    end
  end

  local numSetup=0
  local numWalkers=#this.walkerPool
  InfCore.Log("SetupGearsFREE #walkerNames="..#this.walkerNames.."#walkerPool="..numWalkers)--tex may be -numLrrpWalkers
  for i=1,numWalkers do
    if #walkerPool==0 then
      InfCore.Log("SetupGearsFREE: #walkerPool==0")
      break
    end

    if #positionCps==0 then
      InfCore.Log("SetupGearsFREE: #positionCps==0")
      break
    end

    local walkerName=walkerPool[#walkerPool]
    walkerPool[#walkerPool]=nil
    local walkerInfo={}

    local walkerId=GetGameObjectId("TppCommonWalkerGear2",walkerName)
    --ASSUMPTION only one pos per cp
    local cpName=InfUtil.GetRandomPool(positionCps)
    walkerInfo.cpName=cpName

    if TppMission.IsMissionStart() then
      local coord=positions[cpName][1]
      local command={id="SetPosition",pos=coord.pos,rotY=coord.rot}
      SendCommand(walkerId,command)
    end

    local cpId=GetGameObjectId("TppCommandPost2",cpName)
    local cpSubType=TppEnemy.subTypeOfCp[cpName]
    local colorName=cpSubTypeToColor[cpSubType]
    local walkerColorType=walkerGearColorType[colorName]
    walkerInfo.colorType=walkerColorType

    local command={id="SetColoringType",type=walkerColorType}
    SendCommand(walkerId,command)

    walkerInfos[walkerName]=walkerInfo
    walkerInfos[#walkerInfos+1]=walkerName

    numSetup=i
  end
  InfMain.RandomResetToOsTime()

  if this.debugModule then
    InfCore.Log("SetupGearsFREE: "..numSetup.." of "..tostring(#this.walkerNames).." walker gears set")
    InfCore.PrintInspect(walkerPool,"walkerPool")
  end
end

function this.SetupGearsMB()
  InfMain.RandomSetToLevelSeed()

  local numClusters=0
  for clusterId, clusterName in ipairs(TppDefine.CLUSTER_NAME) do--DEBUGNOW
    local grade=TppLocation.GetMbStageClusterGrade(clusterId)
    if grade>0 then
      numClusters=numClusters+1
    end
  end

  local numWalkers=#this.walkerNames
  local numAssigned=0
  local walkersPerCluster=math.floor(numWalkers/numClusters)

  local totalPlats=0
  local platsPool={}
  for clusterId, clusterName in ipairs(TppDefine.CLUSTER_NAME) do
    local grade=TppLocation.GetMbStageClusterGrade(clusterId)
    if grade>0 then
      platsPool[clusterId]={}
      for i=1,grade do
        table.insert(platsPool[clusterId],i)
        totalPlats=totalPlats+1
      end
    end
  end

  if numWalkers>totalPlats then
    numWalkers=totalPlats
  end

  --tex don't want to bother with this case
  if numWalkers<#platsPool then
    InfCore.DebugPrint"SetupWalkerGearPositions - WANRING: less walkers than clusters, aborting"
    return
  end

  --tex first pass, get at lease one per cluster
  this.walkerPlats={}

  local walkerIndex=1
  for clusterId,plats in ipairs(platsPool)do
    this.walkerPlats[clusterId]={}

    for i=1,walkersPerCluster do
      if numAssigned==numWalkers then
        --InfCore.DebugPrint"numAssigned==numWalkers"--DEBUG
        break
      end
      if #plats>0 then
        local plat=InfUtil.GetRandomPool(plats)
        this.walkerPlats[clusterId][plat]=walkerIndex
        numAssigned=numAssigned+1
        walkerIndex=walkerIndex+1
      end
    end
  end

  --InfCore.DebugPrint("numWalkers:"..numWalkers.." walkersPerCluster: "..walkersPerCluster.." numAssigned:"..numAssigned)--DEBUG
  --InfCore.PrintInspect(this.walkerPlats)--DEBUG

  --tex assign unassigned
  while numAssigned<numWalkers do
    local clusters={}
    for clusterId,plats in ipairs(platsPool)do
      if #plats>0 then
        clusters[#clusters+1]=clusterId
      end
    end

    if #clusters==0 then
      break
    end

    local clusterId=clusters[math.random(1,#clusters)]
    local plats=platsPool[clusterId]
    local plat=InfUtil.GetRandomPool(plats)
    this.walkerPlats[clusterId][plat]=walkerIndex
    numAssigned=numAssigned+1
    walkerIndex=walkerIndex+1
  end

  --InfCore.DebugPrint("numWalkers:"..numWalkers.." numAssigned:"..numAssigned)--DEBUG
  --InfCore.PrintInspect(this.walkerPlats)--DEBUG

  local function GetRandomColorType()
    return math.random(0,4)--tex NOTE leaving out HUEY_PROTO because of texure error
  end
  local walkerColorType=GetRandomColorType()

  local function GetRandomWeaponType()
    return math.random(0,1)
  end
  local walkerGearWeapon=GetRandomWeaponType()

  for clusterId,plats in ipairs(this.walkerPlats) do
    for platId,walkerIndex in pairs(plats)do
      local walkerName=this.walkerNames[walkerIndex]
      local walkerId=GetGameObjectId("TppCommonWalkerGear2",walkerName)
      if walkerId==NULL_ID then
        InfCore.Log("WARNING NULL_ID for "..walkerName,true)
      else

        local coord=walkerStartPositions.mtbs[clusterId][platId]
        if TppMission.IsMissionStart() then
          local command={id="SetPosition",pos=coord.pos,rotY=coord.rot}
          SendCommand(walkerId,command)
        end

        if Ivars.mbWalkerGearsWeapon:Is()>0 then
          if Ivars.mbWalkerGearsWeapon:Is"RANDOM" then
          --tex outside loop
          elseif Ivars.mbWalkerGearsWeapon:Is"RANDOM_EACH" then
            walkerGearWeapon=GetRandomWeaponType()
          else
            walkerGearWeapon=Ivars.mbWalkerGearsWeapon:Get()-1
          end
          local command={id="SetMainWeapon",weapon=walkerGearWeapon}
          SendCommand(walkerId,command)
        end

        if Ivars.mbWalkerGearsColor:Is"RANDOM" then
        --tex outside loop
        elseif Ivars.mbWalkerGearsColor:Is"RANDOM_EACH" then
          walkerColorType=GetRandomColorType()
        else
          walkerColorType=Ivars.mbWalkerGearsColor:Get()
        end


        --tex hueys prototype from 10070 : Mission 12
        -- no side sheilds, small dwalker head, arm
        -- but has bugs, arm hangs down straight/unanimated, pickup up body make them dissapear, and reappear in wrong pos on drop
        --TODO possibly needs data from 10070 pack
        --        local command={id="SetExtraPartsForSpecialEnemy",enabled=true}
        --        GameObject.SendCommand(walkerId,command)

        local command={id="SetColoringType",type=walkerColorType}
        SendCommand(walkerId,command)
      end
    end
  end

  InfMain.RandomResetToOsTime()
end

function this.AddLrrpWalkers(lrrpDefines,walkerPool)
  if InfMain.IsContinue() then
    return
  end

  if not lrrpDefines or #lrrpDefines==0 then
    return
  end

  if not IvarProc.EnabledForMission("enableWalkerGears",vars.missionCode) then
    return
  end

  --    InfCore.Log"AddLrrpWalkers - walkerpool:--"--DEBUG
  --  InfCore.PrintInspect(walkerPool)

  InfMain.RandomSetToLevelSeed()

  for i=1,this.numLrrpWalkers do
    if #walkerPool==0 then
      InfCore.Log"AddLrrpWalkers #walkerPool==0"
      return
    end
    local walkerName=walkerPool[#walkerPool]
    walkerPool[#walkerPool]=nil
    InfCore.Log("AddLrrpWalkers #"..i.." "..walkerName)
    local lrrpName=lrrpDefines[math.random(#lrrpDefines)]
    local cpDefine=lrrpDefines[lrrpName].cpDefine
    cpDefine.lrrpWalker=walkerName
  end

  InfMain.RandomResetToOsTime()
end

function this.GetNumDDWalkers()
  --tex what is the resource name for WG.PP?
  local walkerResourceNames={
    --"SovietWalkerGear1",--1 seems to be dup of 2
    "SovietWalkerGear2",
    "SovietWalkerGear3",
    --"CfaWalkerGear1",--1 seems to be dup of 2
    "CfaWalkerGear2",
    "CfaWalkerGear3",
  --DEBUG OFF seems to have a count even though they dont list?
  --they seem to print with the count of some of the others?
  --          "RogueCoyoteWalkerGear1",
  --          "RogueCoyoteWalkerGear2",
  --          "RogueCoyoteWalkerGear3",
  --          "ZrsWalkerGear1",
  --          "ZrsWalkerGear2",
  --          "ZrsWalkerGear3",
  }
  local totalGears=0
  for i,resourceName in ipairs(walkerResourceNames)do

    local gearCount=TppMotherBaseManagement.GetResourceUsableCount{resource=resourceName}
    InfCore.DebugPrint(resourceName..":"..gearCount)
    totalGears=totalGears+gearCount
  end
  InfCore.DebugPrint("totalGears:"..totalGears)
end

function this.SetUpEnemyGear(missionTable,lrrpDefines)
  if not missionTable or not missionTable.enemy then
    return
  end
  --walkers for lrrp
  if not Ivars.enableLrrpFreeRoam:EnabledForMission() then
    return
  end
  
  local locationName=TppLocation.GetLocationName()
  local baseNames=InfMain.baseNames[locationName]
  if baseNames==nil or #baseNames<2 then
    InfCore.Log("InfWalkerGear.SetUpEnemyGear baseNames==nil or #baseNames<2, returning")
    return
  end  

  if not Ivars.enableWalkerGearsFREE:EnabledForMission() then
    return
  end

  InfCore.LogFlow"InfWalkerGear.SetUpEnemyGear"

  local walkerIndex=1
  local numWalkers=#InfWalkerGear.walkerNames

  local enemyTable=missionTable.enemy
  local soldierDefine=enemyTable.soldierDefine
  for cpName,cpDefine in pairs(soldierDefine)do
    local cpId=GetGameObjectId("TppCommandPost2",cpName)
    if cpId==NULL_ID then
    else
      local walkerName=cpDefine.lrrpWalker
      if walkerName then
        --ASSUMPTION cp define has valid walker and soldier gameobjects
        local walkerId=GetGameObjectId("TppCommonWalkerGear2",walkerName)

        local soldierName=cpDefine[1]--tex ASSUMPTION only 1 walker/soldier per lrrp
        local soldierId=GetGameObjectId("TppSoldier2",soldierName)
        InfCore.Log("Setup walker gear: "..walkerName..", soldier:"..soldierName)
        if TppMission.IsMissionStart() then
          local locationName=TppLocation.GetLocationName()
          --OFF local cpPositions=walkerStartPositions[locationName]
          local cpPositions=InfMain.cpPositions[locationName]
          local lrrpDefine=lrrpDefines[cpName]
          --tex currently soldiers will get off when they reach lrrp hold, so better to have them start at the oposite base position
          local cpPos=cpPositions[lrrpDefine.base2]

          InfCore.Log("IsMissionStart: "..cpName..", base1:"..lrrpDefine.base1..", base2:"..lrrpDefine.base2)--DEBUG
          --InfCore.PrintInspect(cpPos)--DEBUG

          local rotY=0
          --tex the start soldier positions are more often than not no good for walker and it pushes the walker to nav mesh safe position instead
          --local soldierPos=SendCommand(soldierId,{id="GetPosition"})
          --local setPos={id="SetPosition",pos={soldierPos:GetX(),soldierPos:GetY(),soldierPos:GetZ()},rotY=rotY}
          local setPos={id="SetPosition",pos=cpPos,rotY=rotY}
          SendCommand(soldierId,setPos)

          SendCommand(walkerId,setPos)
        end
        local setVehicle={id="SetRelativeVehicle",targetId=walkerId,rideFromBeginning=true}
        SendCommand(soldierId,setVehicle)
        --
        local cpSubType=TppEnemy.subTypeOfCp[cpName]
        local colorName=cpSubTypeToColor[cpSubType]
        local walkerColorType=walkerGearColorType[colorName]

        local command={id="SetColoringType",type=walkerColorType}
        SendCommand(walkerId,command)

      end

    end
  end
end

return this
