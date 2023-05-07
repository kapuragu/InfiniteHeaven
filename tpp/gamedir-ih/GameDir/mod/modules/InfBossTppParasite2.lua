--InfBossTppParasite2.lua
--tex theres a bunch of duplication between boss type modules, 
--but its a trade off between brevity and flexibility

--REF CULL
--SetParameters
--local PARASITE_PARAMETERS={
--  EASY={--10020
--    sightDistance = 20,
--    sightVertical = 36.0,
--    sightHorizontal = 48.0,
--  },
--
--  --ARMOR
--  --o50050_enemy
--  HARD = {
--    sightDistance = 30,
--    sightVertical = 55.0,
--    sightHorizontal = 48.0,
--  },
--
--
--  --10090
--  NORMAL = {
--    sightDistance                 = 25,
--    sightDistanceCombat           = 75,
--    sightVertical                 = 40,
--    sightHorizontal               = 60,
--    noiseRate                     = 8,
--    avoidSideMin                  = 8,
--    avoidSideMax                  = 12,
--    areaCombatBattleRange         = 50,
--    areaCombatBattleToSearchTime  = 1,
--    areaCombatLostSearchRange     = 1000,
--    areaCombatLostToGuardTime     = 120,
--    --areaCombatGuardDistance
--    throwRecastTime               = 10,
--  },
--  --10090
--  EXTREME={
--    sightDistance                 = 25,
--    sightDistanceCombat           = 100,
--    sightVertical                 = 60,
--    sightHorizontal               = 100,
--    noiseRate                     = 10,
--    avoidSideMin                  = 8,
--    avoidSideMax                  = 12,
--    areaCombatBattleRange         = 50,
--    areaCombatBattleToSearchTime  = 1,
--    areaCombatLostSearchRange     = 1000,
--    areaCombatLostToGuardTime     = 60,
--    --areaCombatGuardDistance
--    throwRecastTime               = 10,
--  },
--}--PARASITE_PARAMETERS
--
----SetCombatGrade
----o50050_enemy
--local PARASITE_GRADE={
--  NORMAL={
--    --DEBUGNOW where did I get these values from, did I log fob?
--    defenseValueMain=4000,
--    defenseValueArmor=7000,
--    defenseValueWall=8000,
--    offenseGrade=2,
--    defenseGrade=7,
--  },
--  HARD={
--    defenseValueMain=4000,
--    defenseValueArmor=8400,
--    defenseValueWall=9600,
--    offenseGrade=5,
--    defenseGrade=7,
--  },
--}

--TODO: scrape all refs to game object again
--REF interesting functions/commands not doing anythig with yet
--armor, from fob
--this.StartSearchParasite = function ()
--  Fox.Log("***** this.StartSearchParasite *****")
--
--  for k, parasiteName in pairs(this.PARASITE_NAME_LIST) do
--    local gameObjectId = GameObject.GetGameObjectId(parasiteName)
--    if gameObjectId ~= nil then
--      GameObject.SendCommand( gameObjectId, { id="StartSearch" })
--    end
--  end
--end

local this={}

local InfCore=InfCore
local InfMain=InfMain
local GetGameObjectId=GameObject.GetGameObjectId
local GetTypeIndex=GameObject.GetTypeIndex
local NULL_ID=GameObject.NULL_ID
local SendCommand=GameObject.SendCommand
local TimerStart=GkEventTimerManager.Start
local TimerStop=GkEventTimerManager.Stop
local IsTimerActive=GkEventTimerManager.IsTimerActive
local GAME_OBJECT_TYPE_PARASITE2=TppGameObject.GAME_OBJECT_TYPE_PARASITE2
local GAME_OBJECT_TYPE_BOSSQUIET2=TppGameObject.GAME_OBJECT_TYPE_BOSSQUIET2
local GAME_OBJECT_TYPE_HOSTAGE2=TppGameObject.GAME_OBJECT_TYPE_HOSTAGE2
local GAME_OBJECT_TYPE_PLAYER2=TppGameObject.GAME_OBJECT_TYPE_PLAYER2

this.gameObjectType="TppParasite2"
this.gameObjectTypeIndex=TppGameObject.GAME_OBJECT_TYPE_PARASITE2

--current event, set by InfBossEvent
this.currentSubType="ARMOR"

this.subTypes={
  ARMOR=true,
  MIST=true,
}

this.packages={
  ARMOR={
    "/Assets/tpp/pack/mission2/online/o50050/o50055_parasite_metal.fpk",
  --OFF script block WIP "/Assets/tpp/pack/mission2/ih/parasite_scriptblock.fpk",
  },
  MIST={
    "/Assets/tpp/pack/mission2/ih/ih_parasite_mist.fpk",
  --OFF script block WIP "/Assets/tpp/pack/mission2/ih/parasite_scriptblock.fpk",
  },
}--packages

--tex locatorNames from packs
this.bossObjectNames={
  ARMOR={
    "Parasite0",
    "Parasite1",
    "Parasite2",
    "Parasite3",
  },
  MIST={
    "wmu_mist_ih_0000",
    "wmu_mist_ih_0001",
    "wmu_mist_ih_0002",
    "wmu_mist_ih_0003",
  },
}--bossObjectNames

this.eventParams={
  ARMOR={
    zombifies=true,--TODO: set false and test the boss objects zombifying ability
  },
  MIST={
    zombifies=true,
  }
}--eventParams

--Ivars>
local parasiteStr="parasite_"

--SetParameters, mist/armor
local parasiteParamNames={
  "sightDistance",
  "sightDistanceCombat",
  "sightVertical",
  "sightHorizontal",
  "noiseRate",
  "avoidSideMin",
  "avoidSideMax",
  "areaCombatBattleRange",
  "areaCombatBattleToSearchTime",
  "areaCombatLostSearchRange",
  "areaCombatLostToGuardTime",
  --"areaCombatGuardDistance"
  "throwRecastTime",
}--parasiteParamNames

local parasiteGradeNames={
  "defenseValueMain",
  "defenseValueArmor",
  "defenseValueWall",
  "offenseGrade",
  "defenseGrade",
}--parasiteGradeNames
--<

--InfBossEvent.AddMissionPacks
function this.AddPacks(missionCode,packPaths)
  for j,packagePath in ipairs(this.packages[this.currentSubType])do
    packPaths[#packPaths+1]=packagePath
  end
end--AddPacks

--InfBossEvent
function this.InitEvent()
  for i,name in ipairs(this.bossObjectNames[this.currentSubType]) do
    this.DisableByName(name)
  end
  this.SetupParasites()
end--InitEvent

function this.DisableByName(name)
  local gameId=GetGameObjectId("TppParasite2",name)
  if gameId==NULL_ID then
    return
  end

  SendCommand(gameId,{id="Unrealize"})
end--DisableByName

--InfBossEvent
--IN: parasiteStr
--IN: parasiteParamNames
--IN: parasiteGradeNames  
function this.SetupParasites()
  InfCore.LogFlow("InfBossTppParasite2.Setup")

  SendCommand({type="TppParasite2"},{id="SetFultonEnabled",enabled=true})

  local parasiteParameters={}
  for i,paramName in ipairs(parasiteParamNames)do
    local ivarName=parasiteStr..paramName
    parasiteParameters[paramName]=Ivars[ivarName]:Get()
  end
  SendCommand({type="TppParasite2"},{id="SetParameters",params=parasiteParameters})

  local combatGradeCommand={id="SetCombatGrade",}
  for i,paramName in ipairs(parasiteGradeNames)do
    local ivarName=parasiteStr..paramName
    combatGradeCommand[paramName]=Ivars[ivarName]:Get()
  end
  SendCommand({type="TppParasite2"},combatGradeCommand)

  if this.debugModule then
    InfCore.PrintInspect(parasiteParameters,"SetParameters")
    InfCore.PrintInspect(combatGradeCommand,"SetCombatGrade")
  end
end--Setup

--InfBossEvent
function this.Appear(appearPos,closestCp,closestCpPos,spawnRadius)
  InfCore.Log("InfBossTppParasite2.Appear: spawnRadius:"..spawnRadius)
  if this.debugModule then
    InfCore.PrintInspect(appearPos,"appearPos")
  end
  --tex after fultoning armor parasites don't appear, try and reset
  --doesnt work, parasite does appear, but is in fulton pose lol
  --  if numFultonedThisMap>0 then
  --    for k,parasiteName in pairs(this.parasiteNames.ARMOR) do
  --      local gameId=GetGameObjectId(parasiteName)
  --      if gameId~=NULL_ID then
  --        SendCommand(gameId,{id="Realize"})
  --      end
  --    end
  --  end

  for k,parasiteName in pairs(this.bossObjectNames[this.currentSubType]) do
    local gameId=GetGameObjectId(parasiteName)
    if gameId==NULL_ID then
      InfCore.Log("WARNING: "..parasiteName.. " not found",true)
    end
  end

  --tex Armor parasites appear all at once, distributed in a circle
  SendCommand({type="TppParasite2"},{id="StartAppearance",position=Vector3(appearPos[1],appearPos[2],appearPos[3]),radius=spawnRadius})
end--Appear



return this