--InfBossTppParasite2.lua
--Boss type for InfBossEvent
--For TppParasite2 gameObject
--tex bunch of duplication with InfBossTppBossQuiet2, if common stuff extends to yet another, and changes are an issue
--subType (my name), various ways game refers to them)
--ARMOR, parasite_metal, wmu3, ParasiteHard, PARASITE_CURING, Metal (GetParasiteType)
--s10090,s10140
--parasite_metal.fox2 TppParasite2Parameter

--wmu3_main0_def_v00.parts

--fv2 - TODO: dont know how these are applied,
--apart from partsFiles Main .parts, these are the only difference between: 
--TppParasite2Parameter in parasite_metal.fox2 (has them) and parasite_fog (does not have them)
-- <value key="FovaHard">/Assets/tpp/fova/chara/wmu/wmu3_v00.fv2</value>
-- <value key="FovaNormal">/Assets/tpp/fova/chara/wmu/wmu3_v01.fv2</value>


--MIST, parasite_fog, wmu0, ParasiteFog, ParasiteCommon, PARASITE_FOG, Fog (GetParasiteType)
--s10020,s10040 - loaded by demoblock for some reason (or at least their packs are _d0N like demo packs)
--parasite_fog.fox2 TppParasite2Parameter

--wmu0_main0_def_v00.parts

--only difference between wmu0/3 .parts beyond poiting to the respective fmdl/other parts related files is
--is EffectDescription fx_tpp_chrwmueye01_s0

--TODO: I'm not even sure how ARMOR,MIST are diffrentiated, is it simply having the FovaHard,FovaNormal keys

--Behaviors/Quirks
--AI seems to be hard coded to use 4 instances in most cases
--even if theres only two locators, StartAppearance still uses entity totalcount
--if totalcount is less than 4, totalcount will appear but the ai will break/just stand there and not react to player
--if totalcount is greater than 4, totalcount will appear but those over toalcount will only react intermittanly, 
--moving to initiall attack pos with the others, ocasionally retreating out of range
--facing the player, 
--but not actually walking or fighting
--See submods/boss for split locator packs of diffrent counts used while debugging this

--health bars break when TppBossQuiet2 also loaded TODO: is this just a scripblock issue, or also a loaded at missionpack issue



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

local this={}
this.name="InfBossTppParasite2"

this.gameObjectType="TppParasite2"
this.gameObjectTypeIndex=TppGameObject.GAME_OBJECT_TYPE_PARASITE2
this.bossStatesName="bossEvent_"..this.gameObjectType.."State"
local bossStatesName=this.bossStatesName
this.blockName=this.gameObjectType.."_block"
this.blockNameS32=InfCore.StrCode32(this.blockName)

this.hardcodedCount=true--tex see Behaviors/Quirks

--SetBossSubType
this.currentSubType=nil--tex while there is IsEnabled, this is a more accurate check whether this is chosen/active for an event (InfBossEvent.ChooseBossTypes)
this.currentInfo=nil
this.currentParams=nil

this.gameIdToNameIndex={}--InitEvent

--addons>
this.names={
  "ARMOR",
  "MIST",
}
this.infos={
  ARMOR={
    packages={"/Assets/tpp/pack/mission2/online/o50050/o50055_parasite_metal.fpk",},
    objectNames={
      "Parasite0",
      "Parasite1",
      "Parasite2",
      "Parasite3",
    },
  },--ARMOR
  MIST={
    packages={"/Assets/tpp/pack/mission2/ih/ih_parasite_mist.fpk",},--TODO: pftxs,
    objectNames={
      "wmu_mist_ih_0000",
      "wmu_mist_ih_0001",
      "wmu_mist_ih_0002",
      "wmu_mist_ih_0003",
    },
  },--MIST
}--infos
--<

this.enableSubTypeIvarNames={}

this.packages={
  --missionPack
  scriptBlockData="/Assets/tpp/pack/mission2/boss/ih/"..this.gameObjectType.."_scriptblockdata.fpk",
}--packages

this.eventParams={
  DEFAULT={
    spawnRadius=40,--ivar
    zombifies=true,--TODO: set false and test the boss objects zombifying ability
    fultonable=true,
  },
  ARMOR={
    spawnRadius=40,--ivar
    zombifies=true,--TODO: set false and test the boss objects zombifying ability
    fultonable=true,
  },
  MIST={
    spawnRadius=20,--ivar
    zombifies=true,
    fultonable=true,
  }
}--eventParams

--REF
--s10020 - 
-- local params = {
--   sightDistance = 20,
--   sightVertical = 36.0,--tex not listed in other missions (except for online), suggesting theres defaults in the exe?
--   sightHorizontal = 48.0,
-- }

--s10090 - ARMOR
-- this.PARASITES_PARAMETERS_LIST_NORMAL = {
-- 	sightDistance					= 25,							
-- 	sightDistanceCombat				= 75,							
-- 	sightHorizontal					= 60,							
-- 	noiseRate						= 8,							
-- 	avoidSideMin					= 8,							
-- 	avoidSideMax					= 12,							
-- 	areaCombatBattleRange			= 50,							
-- 	areaCombatBattleToSearchTime	= 1,							
-- 	areaCombatLostSearchRange		= 1000,							
-- 	areaCombatLostToGuardTime		= 120,							
-- 	throwRecastTime					= 10,							
-- }

-- this.PARASITES_PARAMETERS_LIST_EXSTREME = {
-- 	sightDistance					= 25,							
-- 	sightDistanceCombat				= 100,							
-- 	sightHorizontal					= 100,							
-- 	noiseRate						= 10,							
-- 	avoidSideMin					= 8,							
-- 	avoidSideMax					= 12,							
-- 	areaCombatBattleRange			= 50,							
-- 	areaCombatBattleToSearchTime	= 1,							
-- 	areaCombatLostSearchRange		= 1000,							
-- 	areaCombatLostToGuardTime		= 60,							
-- 	throwRecastTime					= 10,							
-- }

--o50050
-- local PARASITE_PARAM = {
-- 	HARD = {
-- 		sightDistance = 30,
-- 		sightVertical = 55.0,
-- 		sightHorizontal = 48.0,
-- 	},
-- }

--o50050
--combat grade is via
--combatGrade = TppNetworkUtil.GetEventFobSkullsParam()
-- {
--   id="SetCombatGrade",
--   defenseValueMain = combatGrade.defenseValueMain,
--   defenseValueArmor = combatGrade.defenseValueArmor,
--   defenseValueWall = combatGrade.defenseValueWall,
--   offenseGrade = combatGrade.offenseGrade,
--   defenseGrade = combatGrade.defenseGrade,
-- }
--apart from o50050, vanilla missions dont actually set SetCombatGrade for TppParasite2

--tex the main mist mission 10040 doesnt even call SetParameters, 
--not setting it at all is defaults I guess
--TODO: any way to figure out the values so they can be listed for reference?

this.params={--SetParameters
  ARMOR={
    --s10090
    sightDistance=25,--[[20,25,30,]]
    sightDistanceCombat=75,--[[75,100]]
    sightVertical=40,--[[36,40,55,60]]
    sightHorizontal=60,--[[48,60,100]]
    noiseRate=8,--[[10]]
    avoidSideMin=8,
    avoidSideMax=12,
    areaCombatBattleRange=50,
    areaCombatBattleToSearchTime=1,
    areaCombatLostSearchRange=1000,
    areaCombatLostToGuardTime=120,--[[120,60]]
    --DEBUGNOW no idea of what a good value is
    --areaCombatGuardDistance=120,
    throwRecastTime=10,
  },
  ARMOR_EXTREME={
    --s11090
    sightDistance=25,
    sightDistanceCombat=100,
    sightVertical=40,--[[36,40,55,60]]
    sightHorizontal=100,
    noiseRate=10,
    avoidSideMin=8,
    avoidSideMax=12,
    areaCombatBattleRange=50,
    areaCombatBattleToSearchTime=1,
    areaCombatLostSearchRange=1000,
    areaCombatLostToGuardTime=60,
    --areaCombatGuardDistance=120,
    throwRecastTime=10,
  },
}--params
--tex the no mission apart from o50050 call SetCombatGrade
--not setting it at all is defaults I guess
this.combatGrade={--SetCombatGrade
  ARMOR={
    --tex uhh where did I get these values?
    defenseValueMain=4000,
    defenseValueArmor=7000,--[[8400]]
    defenseValueWall=8000,--[[9600]]
    offenseGrade=2,--[[5]]
    defenseGrade=7,
  },
}--combatGrade

this.stateTypes={
  READY=0,
  DOWNED=1,
  FULTONED=2,
}

function this.DeclareSVars()
  if not InfBossEvent.BossEventEnabled() then
    return{}
  end

  if not this.IsEnabled() then
    return{}
  end

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
    Block={
      {msg="OnScriptBlockStateTransition",func=this.OnScriptBlockStateTransition},
    },
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
    Timer={
      {msg="Finish",sender="Timer_BossCombat",func=this.Timer_BossCombat},
    },
  }
end--Messages

function this.PostModuleReload(prevModule)

end

function this.PostAllModulesLoad()
  this.LoadInfos()
  this.AddSubTypeIvars()
end

function this.Init(missionTable)
  this.messageExecTable=nil

  if not InfBossEvent.BossEventEnabled() then
    return
  end

  if not this.IsEnabled() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnReload(missionTable)
  this.messageExecTable=nil

  if not InfBossEvent.BossEventEnabled() then
    return
  end

  if not this.IsEnabled() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

--InfBossEvent.AddMissionPacks
function this.AddPacks(missionCode,packPaths)
  if not this.IsEnabled() then
    return packPaths
  end

  packPaths[#packPaths+1]=this.packages.scriptBlockData
end--AddPacks

--tex addons>
function this.LoadInfos()
  InfCore.LogFlow("InfBossTppParasite2.LoadInfos")

  local infoPath=this.gameObjectType
  local files=InfCore.GetFileList(InfCore.files[infoPath],".lua")
  for i,fileName in ipairs(files)do
    InfCore.Log("InfBossTppParasite2.LoadInfos: "..fileName)
    local infoName=InfUtil.StripExt(fileName)
    local info=InfCore.LoadSimpleModule(InfCore.paths[infoPath],fileName)
    if not info then
      InfCore.Log("")
    else
      this.infos[infoName]=info
      table.insert(this.names,infoName)
    end
  end--for files
end--LoadInfos
--<addons

function this.IsEnabled()
  return Ivars[this.ivarNames.enable]:Is(1)
end--IsEnabled

function this.GetEnabledSubTypes(missionCode)
  --tex TODO: forMission?
  --TODO: addon opt in or out?

  local enabledSubTypes=IvarProc.GetIvarKeyNameValues(this.enableSubTypeIvarNames)

  --tex WORKAROUND mb crashes on armor/mist
  if missionCode==30050 then
    enabledSubTypes.ARMOR=false
    enabledSubTypes.MIST=false
  end

  return enabledSubTypes
end--GetEnabledSubTypes

--InfBossEvent
function this.SetBossSubType(bossSubType,numBosses)
  if not this.infos[bossSubType] then
    InfCore.Log("ERROR: "..this.name..".SetBossSubType: has no subType "..tostring(bossSubType))
    return
  end
  InfCore.Log(this.name..".SetBossSubType: "..bossSubType.." numBosses:"..numBosses)
  this.currentSubType=bossSubType
  this.currentInfo=this.infos[bossSubType]
  this.numBosses=numBosses
  this.currentParams=this.eventParams[bossSubType] or this.eventParams.DEFAULT
end--SetBossSubType

function this.ClearBossSubType()
  this.currentSubType=nil
end

--blockState: ScriptBlock.TRANSITION_* enums
--note: ScriptBlock.SCRIPT_BLOCK_STATE_* is for ScriptBlock.GetScriptBlockState
function this.OnScriptBlockStateTransition(blockNameS32,blockState)
  if blockNameS32~=this.blockNameS32 then
    return
  end
  if blockState==ScriptBlock.TRANSITION_DEACTIVATED then
    
  elseif blockState==ScriptBlock.TRANSITION_ACTIVATED then
    this.InitBoss()
  end
end--OnScriptBlockStateTransition

--CALLER: OnScriptBlockStateTransition above. 
--once scriptblock loaded the boss gameobjects are actually loaded
--OUT: this.gameIdToNameIndex
function this.InitBoss()
  if this.currentSubType==nil then
    return
  end
  InfCore.Log(this.name..".InitBoss")

  InfUtil.ClearTable(this.gameIdToNameIndex)
  InfBossEvent.BuildGameIdToNameIndex(this.currentInfo.objectNames,this.gameIdToNameIndex)

  this.DisableAll()
  this.SetupParasites()
end--InitBoss

function this.EndEvent()
  if this.currentSubType==nil then
    return
  end
  
  for index=1,#this.currentInfo.objectNames do
    svars[bossStatesName][index]=this.stateTypes.READY
  end
  
  SendCommand({type="TppParasite2"},{id="StartWithdrawal"})
end--EndEvent

function this.DisableAll()
  if this.currentSubType==nil then
    return
  end

  for i,name in ipairs(this.currentInfo.objectNames) do
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
--IN: this.params
--IN: this.combatGrade  
function this.SetupParasites()
  InfCore.LogFlow("InfBossTppParasite2.Setup")

  SendCommand({type="TppParasite2"},{id="SetFultonEnabled",enabled=true})

  local parasiteParams=this.params[this.currentSubType] or this.params.DEFAULT
  if parasiteParams then
    SendCommand({type="TppParasite2"},{id="SetParameters",params=parasiteParams})
  end
  if this.debugModule then
    InfCore.PrintInspect(parasiteParams,"SetParameters")
  end

  local combatGradeCommand=this.combatGrade[this.currentSubType] or this.combatGrade.DEFAULT
  if combatGradeCommand then
    combatGradeCommand.id="SetCombatGrade"
    SendCommand({type="TppParasite2"},combatGradeCommand)
  end
  if this.debugModule then
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

  for index=1,this.numBosses do
    local name=this.currentInfo.objectNames[index]
    local gameId=GetGameObjectId(name)
    if gameId==NULL_ID then
      InfCore.Log("WARNING: "..name.. " not found",true)
    end
  end

  --tex totalCount parasites appear all at once, distributed in a circle (see Behaviors/Quirks in header) 
  SendCommand({type="TppParasite2"},{id="StartAppearance",position=Vector3(appearPos),radius=spawnRadius})

  --tex WORKAROUND once one armor parasite has been fultoned the rest will be stuck in some kind of idle ai state on next appearance
  --forcing combat bypasses this TODO VERIFY again
  local isFultoned=false
  for index=1,this.numBosses do
    if svars[bossStatesName][index]==this.stateTypes.FULTONED then
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
    InfBossEvent.SetFocusOnPlayerPos()
    return
  end

  --tex boss damaged by player
  if typeIndex==BossModule.gameObjectTypeIndex and attackerIndex==GAME_OBJECT_TYPE_PLAYER2 then
    InfBossEvent.SetFocusOnPlayerPos()
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
  if svars[bossStatesName][nameIndex]==this.stateTypes.DOWNED then
    InfCore.Log"WARNING: InfBossEvent.OnDying state already ==DOWNED"
    return
  end

  svars[bossStatesName][nameIndex]=this.stateTypes.DOWNED

  if this.debugModule then
    InfCore.Log("OnDying is "..this.gameObjectType,true)
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

  svars[bossStatesName][nameIndex]=this.stateTypes.FULTONED

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

  InfBossEvent.SetFocusOnPlayerPos()
end--OnPlayerDamaged
--Messages<

function this.IsAllCleared()
  if this.currentSubType==nil then
    return true
  end

  local allCleared=true

  for index=1,this.numBosses do
    if svars[bossStatesName][index]==this.stateTypes.READY then
      if this.debugModule then
        InfCore.Log(this.name..".IsAllCleared: boss index "..index.." not cleared")
      end
      allCleared=false
    end
  end
  return allCleared
end--IsAllCleared

function this.IsReady(nameIndex)
  return svars[bossStatesName][nameIndex]==this.stateTypes.READY
end--IsReady

--Ivars, menu>
this.registerIvars={}
this.registerMenus={}

local ivarPrefix="boss_"..this.gameObjectType
local bossMenuName=this.name.."_Menu"
table.insert(this.registerMenus,bossMenuName)

this[bossMenuName]={
  parentRefs={"InfBossEvent.bossEventMenu"},
  options={
  }
}

this.ivarNames={}

local ivarName=this.name.."_enable"
local ivar={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
}--ivar
IvarProc.AddIvarToModule(ivarName,this,ivar,bossMenuName)
this.ivarNames.enable=ivarName

local ivarName=ivarPrefix.."_variableBossCount"
local ivar={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
}--ivar
IvarProc.AddIvarToModule(ivarName,this,ivar,bossMenuName)
this.ivarNames.variableBossCount=ivarName

function this.AddSubTypeIvars()
  local registerIvars={}
  local menuName=bossMenuName
  --REF boss_TppParasite2_ARMOR_enable
  for i,subType in ipairs(this.names)do
    local ivarName=table.concat({ivarPrefix,subType,"enable"},"_")
    local ivar={
      save=IvarProc.CATEGORY_EXTERNAL,
      default=1,
      range=Ivars.switchRange,
      settingNames="set_switch",
    }--ivar
    IvarProc.AddIvarToModule(ivarName,this,ivar,menuName)
    
    table.insert(registerIvars,ivarName)

    this.enableSubTypeIvarNames[subType]=ivarName
  end--for subTypeNames
  this[menuName].options=InfMenuDefs.ResortBottomItems(this[menuName].options)
  Ivars.RegisterIvars(this,registerIvars)
end
--Ivars, menu<

return this