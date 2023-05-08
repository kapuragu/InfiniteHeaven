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
this.bossStatesName="bossEvent_"..this.gameObjectType.."State"
local bossStatesName=this.bossStatesName

--SetBossSubType
this.currentSubType="ARMOR"
this.currentBossNames=nil
this.currentParams=nil

this.gameIdToNameIndex={}--InitEvent

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
    spawnRadius=40,--ivar
    escapeDistance=250,--ivar
    escapeDistanceSqr=250^2,
    timeOut=1*60,--ivar
    zombifies=true,--TODO: set false and test the boss objects zombifying ability
  },
  MIST={
    spawnRadius=20,--ivar
    escapeDistance=250^2,--ivar
    timeOut=1*60,--ivar
    zombifies=true,
  }
}--eventParams

this.stateTypes={
  READY=0,
  DOWNED=1,
  FULTONED=2,
}

function this.DeclareSVars()
  if not InfBossEvent.BossEventEnabled() then
    return{}
  end

  --DEBUGNOW only if boss type enabled

  local saveVarsList = {
    --GOTCHA: svar arrays are from 0, but I'm +1 so I can index it lua style +1 since the rest of InfBoss uses that as bossNames 'nameIndex'
    [this.bossStatesName]={name=this.bossStatesName,type=TppScriptVars.TYPE_INT8,arraySize=InfBossEvent.MAX_BOSSES_PER_TYPE+1,value=this.stateTypes.READY,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},
    --tex engine sets svars.parasiteSquadMarkerFlag when camo parasite marked, will crash if svar not defined
    --DEBUGNOW only if camo enabled? TEST
    --parasiteSquadMarkerFlag={name="parasiteSquadMarkerFlag",type=TppScriptVars.TYPE_BOOL,arraySize=InfBossEvent.MAX_BOSSES_PER_TYPE,value=false,save=true,sync=true,wait=true,category=TppScriptVars.CATEGORY_RETRY},
  }
  return TppSequence.MakeSVarsTable(saveVarsList)
end--DeclareSVars

function this.Messages()
  return Tpp.StrCode32Table{
    GameObject={
      {msg="Damage",func=this.OnDamage},
      {msg="Dying",func=this.OnDying},
      --tex TODO: "FultonInfo" instead of fulton and fultonfailed
      {msg="Fulton",--tex fulton success i think
        func=function(gameId,gimmickInstance,gimmickDataSet,stafforResourceId)
          this.OnFulton(gameId)
        end
      },
      {msg="FultonFailed",
        func=function(gameId,locatorName,locatorNameUpper,failureType)
          if failureType==TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
            this.OnFulton(gameId)
          end
        end
      },
    },--GameObject
    Player={
      {msg="PlayerDamaged",func=this.OnPlayerDamaged},
    },--Player
    --InfBossTppParasite2
    Timer={
      {msg="Finish",sender="Timer_BossCombat",func=this.Timer_BossCombat},
    },
  }
end--Messages

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

function this.PostModuleReload(prevModule)

end

function this.Init(missionTable)
  this.messageExecTable=nil

  if not InfBossEvent.BossEventEnabled() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnReload(missionTable)
  this.messageExecTable=nil

  if not InfBossEvent.BossEventEnabled() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

--InfBossEvent.AddMissionPacks
function this.AddPacks(missionCode,packPaths)
  for j,packagePath in ipairs(this.packages[this.currentSubType])do
    packPaths[#packPaths+1]=packagePath
  end
end--AddPacks

--InfBossEvent
function this.SetBossSubType(bossSubType)
  if not this.subTypes[bossSubType] then
    InfCore.Log("ERROR: InfBossTppParasite2.SetBossSubType: has no subType "..tostring(bossSubType))
    return
  end
  InfCore.Log("SetBossSubType "..bossSubType)
  this.currentSubType=bossSubType
  this.currentBossNames=this.bossObjectNames[bossSubType]
  --TODO shift BuildGameIdToNameIndex here if you move ChosseBossTypes/SetBossSubType from pre load
  this.currentParams=this.eventParams[bossSubType]
end--SetBossSubType

--InfBossEvent
--OUT: this.gameIdToNameIndex
function this.InitEvent()
  local bossNames=this.bossObjectNames[this.currentSubType]
  InfUtil.ClearTable(this.gameIdToNameIndex)
  InfBossEvent.BuildGameIdToNameIndex(bossNames,this.gameIdToNameIndex)

  this.DisableAll()
  this.SetupParasites()
end--InitEvent

function this.DisableAll()
  local bossNames=this.bossObjectNames[this.currentSubType]
  for i,name in ipairs(bossNames) do
    this.DisableByName(name)
  end  
end--DisableAll

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


  --tex WORKAROUND once one armor parasite has been fultoned the rest will be stuck in some kind of idle ai state on next appearance
  --forcing combat bypasses this TODO VERIFY again
  local isFultoned=false
  for index=1,this.numBosses do
    if svars[bossStatesName][index]==InfBossEvent.stateTypes.FULTONED then
      isFultoned=true
      break
    end
  end
  if isFultoned and this.bossSubType=="ARMOR" then
    --InfCore.Log("Timer_BossCombat start",true)--DEBUG
    TimerStart("Timer_BossCombat",4)
  end
end--Appear

--Started by Timer_BossAppear soley as a workaround
function this.Timer_BossCombat()
  SendCommand({type="TppParasite2"},{id="StartCombat"})
end

--Messages>
function this.OnDamage(gameId,attackId,attackerId)
  local BossModule=this

  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=BossModule.gameObjectTypeIndex then
    return
  end

  local nameIndex=BossModule.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  local attackerIndex=GetTypeIndex(attackerId)
  --tex player damaged by boss
  if typeIndex==GAME_OBJECT_TYPE_PLAYER2 and attackerIndex==BossModule.gameObjectTypeIndex then
    InfBossEvent.SetFocusOnPlayerPos(BossModule.currentParams.timeOut)
    return
  end

  --tex boss damaged by player
  if typeIndex==BossModule.gameObjectTypeIndex and attackerIndex==GAME_OBJECT_TYPE_PLAYER2 then
    InfBossEvent.SetFocusOnPlayerPos(BossModule.currentParams.timeOut)
    return
  end

  BossModule.OnTakeDamage(nameIndex,gameId)
end--OnDamage

function this.OnTakeDamage(nameIndex,gameId)
end--OnTakeDamage

function this.OnDying(gameId)
  local BossModule=this

  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=BossModule.gameObjectTypeIndex then
    return
  end

  local nameIndex=BossModule.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  --KLUDGE DEBUGNOW don't know why OnDying keeps triggering repeatedly
  if svars[bossStatesName][nameIndex]==InfBossEvent.stateTypes.DOWNED then
    InfCore.Log"WARNING: InfBossEvent.OnDying state already ==DOWNED"
    return
  end

  svars[bossStatesName][nameIndex]=InfBossEvent.stateTypes.DOWNED

  if this.debugModule then
    InfCore.Log("OnDying is para",true)
  end
  --InfCore.PrintInspect(this.states,{varName="states"})--DEBUGNOW InspectVars

  if InfBossEvent.IsAllCleared() then
    InfCore.Log("InfBossEvent OnDying: all eliminated")--DEBUG
    InfBossEvent.EndEvent()
  end
end--OnDying

function this.OnFulton(gameId,gimmickInstance,gimmickDataSet,stafforResourceId)
  local BossModule=this

  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=BossModule.gameObjectTypeIndex then
    return
  end

  local nameIndex=BossModule.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  svars[bossStatesName][nameIndex]=InfBossEvent.stateTypes.FULTONED

  --InfCore.PrintInspect(this.states,{varName="states"})--DEBUGNOW

  if InfBossEvent.IsAllCleared() then
    InfCore.Log("InfBossEvent OnFulton: all eliminated")--DEBUG
    InfBossEvent.EndEvent()
  end
end--OnFulton

function this.OnPlayerDamaged(playerIndex,attackId,attackerId)
  local BossModule=this
  local gameId=attackerId

  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=BossModule.gameObjectTypeIndex then
    return
  end

  local nameIndex=BossModule.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  InfBossEvent.SetFocusOnPlayerPos(BossModule.currentParams.timeOut)
end--OnPlayerDamaged
--<

function this.IsAllCleared()
  local allCleared=true

  for index=1,this.numBosses do
    if svars[bossStatesName][index]==InfBossEvent.stateTypes.READY then
      allCleared=false
    end
  end
  return allCleared
end--IsAllCleared

function this.IsReady(nameIndex)
  return svars[bossStatesName][nameIndex]==this.stateTypes.READY
end--IsReady

return this