--DEBUGNOW
--InfReinforce.lua
local this={}

local GetGameObjectId=GameObject.GetGameObjectId
local GetTypeIndex=GameObject.GetTypeIndex
local SendCommand=GameObject.SendCommand
local NULL_ID=GameObject.NULL_ID

this.reinforceInfo={
  cpId=nil,
  request=0,
  count=0,
}

function this.Messages()
  return Tpp.StrCode32Table{
    GameObject={
      --      {msg="RequestLoadReinforce",func=this._OnRequestLoadReinforce},
      --      {msg="RequestAppearReinforce",func=this._OnRequestAppearReinforce},
      --      {msg="CancelReinforce",func=this._OnCancelReinforce}
      {msg="Dead",func=this.OnDead},
      {msg="Fulton",func=this.OnFultonRecovered},
      {msg="FultonFailedEnd",func=this.OnFultonFailedEnd},
      {msg="CommandPostAnnihilated",func=this.OnCommandPostCleared},
      --tex normal reinforce system
      {msg="RequestLoadReinforce",func=this.OnRequestLoadReinforce},
      {msg="RequestAppearReinforce",func=this.OnRequestAppearReinforce},
      {msg="CancelReinforce",func=this.OnCancelReinforce},
      {msg="ReinforceRespawn",func=this.OnReinforceRespawn},
    }
  }
end
function this.Init(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.OnReload(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end


function this.OnDead(gameId,attackerId,phase,damageFlag)
  local typeIndex=GetTypeIndex(gameId)
  if gameId~=TppGameObject.GAME_OBJECT_TYPE_SOLDIER2 then
    return
  end

  --TODO:add to soldierpool
  --    not quest soliders
  --  allways lrrp soldiers
  --cp soldier if cp is cleared or reinforce count for cp is 0

  --TODO: clear from cp list
end

function this.OnFultonRecovered(gameId)
  local typeIndex=GetTypeIndex(gameId)
  if gameId~=TppGameObject.GAME_OBJECT_TYPE_SOLDIER2 then
    return
  end

end

function this.OnFultonFailedEnd(gameId,arg1,arg2,fultonFailesType)
  local typeIndex=GetTypeIndex(gameId)
  if gameId~=TppGameObject.GAME_OBJECT_TYPE_SOLDIER2 then
    return
  end
  if fultonFailesType~=TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
    return
  end

end

function this.OnCommandPostCleared(cpId,unk1,unk2)

end

function this.OnRequestLoadReinforce(cpId)
  InfCore.Log("OnRequestLoadReinforce",false,true)--DEBUGNOW
  if this.reinforceInfo.cpId~=cpId then
    this.reinforceInfo.cpId=cpId
    this.reinforceInfo.count=0
    this.reinforceInfo.request=0
  end
  this.reinforceInfo.request=this.reinforceInfo.request+1
end
function this.OnRequestAppearReinforce(cpId)
  InfCore.Log("OnRequestAppearReinforce",false,true)--DEBUGNOW
  this.reinforceInfo.count=this.reinforceInfo.count+1
end
function this.OnCancelReinforce(cpId)
  InfCore.Log("OnCancelReinforce",false,true)--DEBUGNOW
end

function this.OnReinforceRespawn(soldierIds)
  InfCore.Log("OnReinforceRespawn",false,true)--DEBUGNOW
end

function this.GetNormalCpSize(cpName)
  if type(cpName)=="number" then
    cpName=InfLookup.CpNameForCpId(cpName)
  end

  if cpName then
    local soldierDefine=mvars.ene_soldierDefine
    if soldierDefine[cpName] then
      return #soldierDefine[cpName]
    end
  end

  return nil
end

function this.GetCurrentCpSize(cpId)
  if type(cpId)=="string" then
    cpId=GetGameObjectId("TppCommandPost2",cpId)
  end

  local soldierCount
  local soldierList=mvars.ene_soldierIDList[cpId]
  if soldierList then
    soldierCount=0
    for i,soldierId in ipairs(soldierList)do
      local status=SendCommand(soldierId,{id="GetStatus"})
      local lifeStatus=SendCommand(soldierId,{id="GetLifeStatus"})
      --DEBUGNOW TODO see what state fultoned soliders are
      if status~=TppGameObject.NPC_STATE_DISABLE and lifeStatus~=TppGameObject.NPC_LIFE_STATE_DEAD then
        soldierCount=soldierCount+1
      end
    end
  end

  return soldierCount
end
--REF
--mvars.ene_travelPlans[planName]={{cp=lrrpCp,routeGroup={"travel",lrrpRoute}},{cp=toCp,finishTravel=true}}
--mvars.ene_reinforcePlans[planName]={{toCp=toCp,fromCp=fromCp,type="respawn"}}
function this.GetReinforcePlansForCp(cpName)
  local travelPlans={}
  for planName,reinforcePlan in pairs(mvars.ene_reinforcePlans)do
    if reinforcePlan[1].toCp==cpName then
      travelPlans[#travelPlans+1]=planName
    end
  end
  return travelPlans
end

function this.Reinforce(cpId,soldierId)
  if soldierId==NULL_ID then
    return
  end

  local cpName=cpId
  if type(cpId)=="string" then
    cpId=GetGameObjectId("TppCommandPost2",cpId)
  end

  if type(cpName)=="number" then
    cpName=InfLookup.CpNameForCpId(cpId)
  end

  SendCommand(soldierId,{id="SetCommandPost",cp=cpName})
  --TODO DEBUGNOW add to cp list

  --DEBUGNOW TppRevenge.ApplyPowerSettingsForReinforce{soldierId}

  local plans=this.GetReinforcePlansForCp(cpName)
  InfCore.PrintInspect(plans,"plans")--DEBUGNOW
  local travelPlan=plans[1]--TODO:
  
 
  
  --REF mvars.ene_travelPlans[planName]={{cp=lrrpCp,routeGroup={"travel",lrrpRoute}},{cp=toCp,finishTravel=true}}
  local route=mvars.ene_travelPlans[travelPlan][1].routeGroup[2]

local noAssignRoute=true--DEBUGNOW
  --tex respawn. aparently dead soldiers are still enabled? jiggling enabled false first works though.
  SendCommand(soldierId,{id="SetLrrp",travelPlan=""})
  SendCommand(soldierId,{id="SetEnabled",enabled=false,noAssignRoute=noAssignRoute})
  
  local point=2
  local warp=true
  local relaxed=false
--  SendCommand(soldierId,{id="SetSneakRoute",route=route,point=point,isRelaxed=relaxed,warp=warp})--DEBUGNOW
--  SendCommand(soldierId,{id="SetCautionRoute",route=route,point=point,isRelaxed=relaxed,warp=warp})
--  SendCommand(soldierId,{id="SetAlertRoute",enabled=true,route=route,point=point,isRelaxed=relaxed,warp=warp})--DEBUGNOW
--SendCommand(soldierId,{id="SetLrrp",travelPlan=travelPlan})
  SendCommand(soldierId,{id="SetEnabled",enabled=true,noAssignRoute=noAssignRoute})
  

  InfCore.Log("InfReinforce.Reinforce cpName:"..tostring(cpName).." soldierId:"..tostring(soldierId).." plan:"..tostring(travelPlan).." route:"..tostring(route),false,true)--DEBUGNOW annoucelog
end

--DEBUGNOW REF
this.WarpSetRoute = function(trapName)
  local ignoreDisableNpc = this.EventSolTable[trapName].ignoreDisableNpc

  local cmdDisable  = { id="SetEnabled", enabled=false, noAssignRoute=true }
  local cmdEnable   = { id="SetEnabled", enabled=true, noAssignRoute=true }
  local cmdIgnoreDisableNpc = { id="SetIgnoreDisableNpc", enable=true }

  SendCommand( gameObjectId, cmdDisable )
  TppEnemy.SetSneakRoute( enemyName , this.EventSolTable[trapName].routeList[i])
  SendCommand( gameObjectId, cmdEnable )
  if ignoreDisableNpc then
    SendCommand( gameObjectId, cmdIgnoreDisableNpc )
  end
end


return this
