--InfBossTppVolgin2.lua
--WIP / not in build, see Behavior/Quirks

--s10010
--\Assets\tpp\pack\mission2\story\s10010\s10010_s04_fpkd
--s10010_s04_npc.fox2

--s10110
--\Assets\tpp\pack\mission2\story\s10110\s10110_area02_fpkd
--s10110_npc_sp.fox2

--TODO: what sound pack volgin use?

--TODO: is mantis automagically part of the system

--TODO:msges to clear status

--get rid of msgs that dont apply to TppVolgin2

--Behavior/Quirks:
--Its pretty much impossible to outrun him on foot. SetChasePlayerMode false doesnt seem to do anything?
--appearance warp can put him in water, instantly eliminating him. if the game had a normal sdk I could just trace down to ground and test what surface
--TODOif in short period of appear if taking VOLGIN_DAMAGED_TYPE_PUDDLE, VOLGIN_DAMAGED_TYPE_LAKE then rewarp somewhere

--TODO dont choose type volgin if raining? ditto if multi boss types dont choose rain if volgin 

--TODO SetFireballMode false doesnt do anything?

local InfCore=InfCore
local InfMain=InfMain
local GetGameObjectId=GameObject.GetGameObjectId

local GetTypeIndex=GameObject.GetTypeIndex
local NULL_ID=GameObject.NULL_ID
local SendCommand=GameObject.SendCommand
local TimerStart=GkEventTimerManager.Start
local TimerStop=GkEventTimerManager.Stop
local IsTimerActive=GkEventTimerManager.IsTimerActive
local GAME_OBJECT_TYPE_PLAYER2=TppGameObject.GAME_OBJECT_TYPE_PLAYER2

local this={}
this.name="InfBossTppVolgin2"

this.gameObjectType="TppVolgin2"
this.gameObjectTypeIndex=TppGameObject.GAME_OBJECT_TYPE_VOLGIN2
this.bossStatesName="bossEvent_"..this.gameObjectType.."State"
local bossStatesName=this.bossStatesName
this.blockName=this.gameObjectType.."_block"
this.blockNameS32=InfCore.StrCode32(this.blockName)

--this.hardcodedCount=true--tex see Behaviors/Quirks TODO: is it? test

--SetBossSubType
this.currentSubType=nil--tex while there is IsEnabled, this is a more accurate check whether this is chosen/active for an event (InfBossEvent.ChooseBossTypes)
this.currentInfo=nil
this.currentParams=nil

this.gameIdToNameIndex={}--InitEvent

this.appearedTime=0
this.appearInWaterEscapeTime=10

this.names={}
this.infos={}

this.enableSubTypeIvarNames={}

this.packages={
  --missionPack
  scriptBlockData="/Assets/tpp/pack/mission2/boss/ih/"..this.gameObjectType.."_scriptblockdata.fpk",
}--packages

this.stateTypes={
  READY=0,
  DOWNED=1,
  FULTONED=2,
}

function this.DeclareSVars()
  if not InfBossEvent.BossEventEnabled() then
    return{}
  end

  --tex this is load time, so needs to be on if you want to toggle subtype at runtime
  -- if not this.IsEnabled() then
  --   return{}
  -- end

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
      {msg="VolginDamagedByType",func=this.VolginDamagedByType},
      {msg="VolginLifeStatusChanged",func=this.VolginLifeStatusChanged}
    },--GameObject
    Player={
      {msg="PlayerDamaged",func=this.OnPlayerDamaged},
    },--Player
  }
end--Messages

function this.PostModuleReload(prevModule)

end

function this.OnModuleLoad(prevModule)
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

--tex enable stuff thats usually blocked if not enabled during runtime (that actually can be)
function this.EnableInMission()
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.DisableInMission()
  this.messageExecTable=nil
end

--InfBossEvent.AddMissionPacks
function this.AddPacks(missionCode,packPaths)
  --tex see note in InfBossEvent
  -- if not this.IsEnabled() then
  --   return packPaths
  -- end

  packPaths[#packPaths+1]=this.packages.scriptBlockData
end--AddPacks

--tex addons>
function this.LoadInfos()
  InfCore.LogFlow(this.name..".LoadInfos")

  local files=InfCore.GetFileListInModFolder("bosses/"..this.gameObjectType.."/")
  InfCore.PrintInspect(files,"bosses/"..this.gameObjectType.."/")--
  for i,fileName in ipairs(files)do
    if fileName:find(".lua") then
    InfCore.Log(this.name..".LoadInfos: "..fileName)
      local info=InfCore.LoadSimpleModule(fileName)
    if not info then
        --InfCore.Log("")
    else
        this.infos[info.name]=info
        table.insert(this.names,info.name)
    end
    end--if .lua
  end--for files

 -- if this.debugModule then
    InfCore.PrintInspect(this.names,"names")
    --InfCore.PrintInspect(this.infos,"infos")
 -- end
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
  -- if missionCode==30050 then
  --   return{}
  -- end

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
  this.currentParams=this.currentInfo.eventParams
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

function this.ClearStates()
  for index=1,InfBossEvent.MAX_BOSSES_PER_TYPE do
    svars[bossStatesName][index]=this.stateTypes.READY
  end
end

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

  this.appearedTime=0
end--InitBoss

function this.EndEvent()
  if this.currentSubType==nil then
    return
  end
  
  this.ClearStates()

  local gameId={type="TppVolgin2",index=0}
  SendCommand(gameId,{id="DisableCombat"})
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
  local gameId=GetGameObjectId("TppVolgin2",name)
  if gameId==NULL_ID then
    return
  end

  SendCommand(gameId,{id="DisableCombat"})
end--DisableByName

--InfBossEvent
--IN: this.params
--IN: this.combatGrade  
function this.SetupParasites()
  InfCore.LogFlow(this.name..".Setup")

 -- SendCommand({type="TppParasite2"},{id="SetFultonEnabled",enabled=true})

  
end--Setup

local phases={
  "caution",
  "sneak_day",
  "sneak_night",
}
local groups={
  "groupSniper",
  "groupA",
  "groupB",
  "groupC",
  --mb
  "plnt0",
  "plnt1",
  "plnt2",
  "plnt3",
}
local groupSniper="groupSniper"

--IN: mvars.ene_routeSetsDefine
function this.GetRoutes(cpName)
  local routeSets=mvars.ene_routeSetsDefine[cpName]
  if not routeSets then
    InfCore.Log"WARNING: InfBossEvent.GetRoutes: no routesets found, aborting"
    return
  end

  local cpRoutes={}
  --tex TODO prioritze picking sniper group first?
  if routeSets==nil then
    InfCore.Log("WARNING: InfBossEvent.GetRoutes: no routesets for "..cpName,true)--DEBUG
    return
  end

  if this.debugModule then
    InfCore.PrintInspect(routeSets,"InfBossTppBossQuiet.GetRoutes: routeSets: "..cpName)
  end

  local routeCount=0
  for i,phaseName in ipairs(phases)do
    local phaseRoutes=routeSets[phaseName]
    if phaseRoutes then
      for i,groupName in ipairs(groups)do--tex TODO read groups from routeSet .priority instead
        local group=phaseRoutes[groupName]
        if group then
          --tex some groups have duplicate groups
          for i,route in ipairs(group)do
            if groupName==groupSniper then
              cpRoutes[route[1]]=true
            else
              cpRoutes[route]=true
            end
            routeCount=routeCount+1
          end--for group
        end--if group
      end--for groups
    end--if phaseRoutes
  end--for phases
  return routeCount,cpRoutes
end--GetRoutes

--InfBossEvent
function this.Appear(appearPos,closestCp,closestCpPos,spawnRadius)
  InfCore.Log(this.name..".Appear: spawnRadius:"..spawnRadius)
  if this.debugModule then
    InfCore.PrintInspect(appearPos,"appearPos")
  end

  --tex unfortunately StartAppearance always uses totalcount instances - Behaviors/Quirks
  --so cant only init those that are not cleared (on checkpoin reload)
  --we can at least check if all were cleared
  --TODO do I want to do this earlier?
  if this.IsAllCleared() then
    InfCore.Log(this.name..".Appear: IsAllCleared, aborting appear")
    return
  end
  --tex and should clear states to reflect that all are on in play again
  --TODO: could possibly turn off fulton for those already, but would probably just be confusing to player
  --if this.hardcodedCount then
  this.ClearStates()

  for index=1,this.numBosses do
    local name=this.currentInfo.objectNames[index]
    local gameId=GetGameObjectId(name)
    if gameId==NULL_ID then
      InfCore.Log("WARNING: "..name.. " not found",true)
    end
  end

  
  local gameObjectId={type="TppVolgin2",index=0}

  --SendCommand(gameObjectId, { id = "SetCyprusMode", })  
  SendCommand(gameObjectId,{id="EnableCombat",})
  SendCommand(gameObjectId,{id="SetChasePlayerMode",chasePlayer=false,})


  local command = {id="SetFireballMode", enable=false}
   GameObject.SendCommand(gameObjectId, command)

  local routeCount,cpRoutes=this.GetRoutes(closestCp)

  if this.debugModule then
    InfCore.PrintInspect(cpRoutes,"cpRoutes")
  end

  if routeCount<this.numBosses then--this.numParasites then--DEBUGNOW
    InfCore.Log("WARNING: "..this.name..".".."Appear: - routeCount< #TppBossQuiet2 instances",true)
    --return
  end

  this.routeBag=InfUtil.ShuffleBag:New()
  for route,bool in pairs(cpRoutes) do
    this.routeBag:Add(route)
  end

  local route=this.routeBag:Next()
  InfCore.Log("route:"..tostring(route))

  --SendCommand(gameObjectId,{id="SetRoute", route=route, point=0})



  local angle=math.random(360)--tex TODO fuzz with rnd
  local spawnPos=InfUtil.PointOnCircle(appearPos,spawnRadius,angle)
  local rotY=InfUtil.YawTowardsLookPos(spawnPos,appearPos)

  SendCommand(gameObjectId,{id="Warp", position=Vector3(spawnPos), rotationY=rotY})

  this.appearedTime=Time.GetRawElapsedTimeSinceStartUp()
end--Appear

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
  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=this.gameObjectTypeIndex then
    return
  end

  local nameIndex=this.gameIdToNameIndex[gameId]
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

  --tex CULL Timer_BossEventMonitor should handle this
  -- if InfBossEvent.IsAllCleared() then
  --   InfCore.Log("InfBossEvent OnDying: all eliminated")--DEBUG
  --   InfBossEvent.EndEvent()
  --   InfBossEvent.StartCountdown()
  -- end
end--OnDying

function this.VolginDamagedByType(gameId,damageType)
  --tex NOTE theres no attackId to filter this
  InfBossEvent.SetFocusOnPlayerPos()

  if damageType==TppVolgin2.VOLGIN_DAMAGED_TYPE_PUDDLE
  or damageType==TppVolgin2.VOLGIN_DAMAGED_TYPE_LAKE then
    if this.appearedTime>0 and this.appearedTime+this.appearInWaterEscapeTime>Time.GetRawElapsedTimeSinceStartUp() then
      --OFF its pretty much a crapshoot anyway: TimerStart("Timer_BossAppear",0.1)--DEBUGNOW this does all, just need this bosstype
      --better to set a reappear in VolginLifeStatusChanged, or event restart if event is clearing with a minute or so delay
    end
  end
end--VolginDamagedByType

function this.VolginLifeStatusChanged(gameId,newLifeStatus)
  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=this.gameObjectTypeIndex then
    return
  end

  local nameIndex=this.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  if (newLifeStatus == TppVolgin2.VOLGIN_LIFE_STATUS_VANISHED_FOREVER) then 
    InfCore.Log("VOLGIN_LIFE_STATUS_VANISHED_FOREVER setting DOWNED")
    svars[bossStatesName][nameIndex]=this.stateTypes.DOWNED
  elseif (newLifeStatus == TppVolgin2.VOLGIN_LIFE_STATUS_VANISHED) then 

  elseif (newLifeStatus == TppVolgin2.VOLGIN_LIFE_STATUS_NORMAL) then

  else

  end
end--VolginLifeStatusChanged

function this.OnFulton(gameId,gimmickInstance,gimmickDataSet,stafforResourceId)
  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=this.gameObjectTypeIndex then
    return
  end

  local nameIndex=this.gameIdToNameIndex[gameId]
  if nameIndex==nil then
    return
  end

  svars[bossStatesName][nameIndex]=this.stateTypes.FULTONED

  --InfCore.PrintInspect(this.states,{varName="states"})--DEBUGNOW

  if this.debugModule then
    InfCore.Log("OnFulton is "..this.gameObjectType,true)
  end

  --tex CULL Timer_BossEventMonitor should handle this
  -- if InfBossEvent.IsAllCleared() then
  --   InfCore.Log("InfBossEvent OnFulton: all eliminated")--DEBUG
  --   InfBossEvent.EndEvent()
  --   InfBossEvent.StartCountdown()
  -- end
end--OnFulton

function this.OnPlayerDamaged(playerIndex,attackId,attackerId)
  local gameId=attackerId

  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=this.gameObjectTypeIndex then
    return
  end

  local nameIndex=this.gameIdToNameIndex[gameId]
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

this.OnChangeEnable=function(self,setting)
  if TppMission.IsMissionStart()then
    if setting==1 then
      this.EnableInMission()
    else
      this.DisableInMission()
    end
  end
end

local ivarName=this.name.."_enable"
local ivar={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=this.OnChangeEnable,
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
      description=this.infos[subType].description and this.infos[subType].description.." Enable",
      save=IvarProc.CATEGORY_EXTERNAL,
      default=1,
      range=Ivars.switchRange,
      settingNames="set_switch",
      OnChange=this.OnChangeEnable,
    }--ivar
    IvarProc.AddIvarToModule(ivarName,this,ivar,menuName)
    
    table.insert(registerIvars,ivarName)

    this.enableSubTypeIvarNames[subType]=ivarName
  end--for subTypeNames
end--AddSubTypeIvars
--Ivars, menu<

return this