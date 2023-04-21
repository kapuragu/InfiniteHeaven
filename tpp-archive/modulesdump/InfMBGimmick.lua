--InfMBGimmick.lua --DEBUGNOW
local this={}

--LOCALOPT
local InfMain=InfMain
local NULL_ID=GameObject.NULL_ID
local GetGameObjectId=GameObject.GetGameObjectId
local SendCommand=GameObject.SendCommand

this.debugModule=false

function this.Init(missionTable)
  this.messageExecTable=nil


  --DEBUGNOW
  if vars.missionCode~=30050 then
    return
  end
  --  if not Ivars.mbAdditionalNpcs:EnabledForMission() then
  --    return
  --  end
  --
  --  if InfMain.IsMbEvent() then
  --    return
  --  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  this.InitCluster()
end

function this.OnReload(missionTable)
  this.messageExecTable=nil
  --DEBUGNOW
  if vars.missionCode~=30050 then
    return
  end
  --DEBUGNOW
  --  if not Ivars.mbAdditionalNpcs:EnabledForMission() then
  --    return
  --  end
  --
  --  if InfMain.IsMbEvent() then
  --    return
  --  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  this.InitCluster()
end

function this.Messages()
  return Tpp.StrCode32Table{
    GameObject={
      {msg="BreakGimmick",func=this.OnBreakGimmick},
      {msg="BreakGimmickBurglarAlarm",func=this.OnBreakGimmickBurglarAlarm},
      {msg="BurglarAlarmTrap",func=function(bAlarmId,bAlarmHash,bAlarmDataSetName,gameObjectId)
        this.RequestNoticeGimmick(bAlarmId,gameObjectId)
      end},
      {msg="Fulton",func=function(gameObjectId,arg1,arg2,arg3)
        --TppTerminal.OnFultonMessage( gameObjectId, arg1, arg2, arg3 )
        mvars.fultonInfo=mvars.fultonInfo or {}
        mvars.fultonInfo[gameObjectId]={gameObjectId,arg1,arg2,arg3}
      end},
      {msg="FultonInfo",func=function(gameObjectId,fultonedPlayer)
        --TppTerminal.OnFultonInfoMessage( gameObjectId, fultonedPlayer )
        mvars.fultonInfo=mvars.fultonInfo or {}
        local fultonInfo=mvars.fultonInfo[gameObjectId]
        if fultonInfo==nil then
          InfCore.Log("### FultonInfo :: Not Fulton Success ")
          return
        end
        if Tpp.IsFultonContainer(gameObjectId) then
          if Gimmick.CallBurglarAlarm(gameObjectId,this.burgularAlarmRange,this.burgularAlarmTime)==true then
            InfCore.Log("CallBurglarAlarm / Fulton")
            this.RequestNoticeGimmick(gameObjectId, fultonedPlayer)
          end
        end
        if Tpp.IsGatlingGun(gameObjectId) then
          if Gimmick.CallBurglarAlarm(gameObjectId,this.burgularAlarmRange,this.burgularAlarmTime)==true then
            InfCore.Log("CallBurglarAlarm / Fulton")
            this.RequestNoticeGimmick(gameObjectId,fultonedPlayer)
          end
        end
        mvars.fultonInfo[gameObjectId]=nil
      end},
      {msg="FultonFailed",
        func=function(gameObjectId)
          if Tpp.IsFultonContainer(gameObjectId) or Tpp.IsGatlingGun(gameObjectId)then
            InfCore.Log("CallBurglarAlarm / FultonFailed ")
            if Gimmick.CallBurglarAlarm(gameObjectId,this.burgularAlarmRange,this.burgularAlarmTime)==true then
              this.RequestNoticeGimmick(gameObjectId,0)
            end
          end
        end
      },
      {msg="WarningGimmick",func=function(irSensorId,irHash,irDataSetName,gameObjectId)
        this.RequestNoticeGimmick(irSensorId,gameObjectId)
      end},
    },
    MotherBaseStage={
      --{msg="MotherBaseCurrentClusterLoadStart",func=this.MotherBaseCurrentClusterLoadStart},
      {msg="MotherBaseCurrentClusterActivated",func=this.MotherBaseCurrentClusterActivated},
    },
  }
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.MotherBaseCurrentClusterActivated(clusterId)
  this.InitCluster(clusterId)
end

function this.InitCluster(clusterId)
  --DEBUGNOW
  if vars.missionCode~=30050 then
    return
  end

  --  if not Ivars.mbAdditionalNpcs:EnabledForMission() then
  --    return
  --  end

  clusterId=clusterId or MotherBaseStage.GetCurrentCluster()
  if this.debugModule then
    InfCore.Log("InfMBGimmick.InitCluster "..tostring(clusterId).." "..tostring(InfMain.CLUSTER_NAME[clusterId+1]))
  end

  local grade=TppLocation.GetMbStageClusterGrade(clusterId)
  --tex no plats on cluster
  if grade==0 then
    return
  end

  --tex mbqf,zoo
  if vars.missionCode~=30050 then
    grade=1
  end
  --zoo
  if vars.missionCode==30150 then
    clusterId=8
  end
  if vars.missionCode==30250 then
    clusterId=7
  end

  InfCore.Log("-------urrrp")--DEBUGNOW
  if mvars.mbItem_funcGetAssetTable then
    InfCore.Log("-------eeeeeeeeeeeeep")--DEBUGNOW
    local layoutCode=vars.mbLayoutCode
    local dataSet = string.format( "/Assets/tpp/level/location/mtbs/block_area/ly%03d/cl%02d/mtbs_ly%03d_cl%02d_item.fox2", layoutCode, clusterId, layoutCode, clusterId )
    local assetTable = mvars.mbItem_funcGetAssetTable( clusterId + 1 )
    if assetTable then
      InfCore.Log("-------ooooooop")--DEBUGNOW
      --DEBUGNOW TODO Ivar
      for k,v in ipairs(assetTable.containers)do
        --if (k % 4) == 0 then
        if type(v)=="string" then
          --InfCore.DebugPrint(tostring(v))
          Gimmick.InvisibleGimmick(TppGameObject.GAME_OBJECT_TYPE_FULTONABLE_CONTAINER,v,dataSet,true)
        end
        --end
      end
      --DEBUGNOW TODO Ivar
      for k,v in ipairs(assetTable.eastAAGs)do
        --if (k % 4) == 0 then
        if type(v)=="string" then
          --InfCore.DebugPrint(tostring(v))
          Gimmick.InvisibleGimmick(TppGameObject.GAME_OBJECT_TYPE_GATLINGGUN,v,dataSet,true)
        end
        --end
      end
      --DEBUGNOW TODO Ivar
      for k,v in ipairs(assetTable.westAAGs)do
        --if (k % 4) == 0 then
        if type(v)=="string" then
          --InfCore.DebugPrint(tostring(v))
          Gimmick.InvisibleGimmick(TppGameObject.GAME_OBJECT_TYPE_GATLINGGUN,v,dataSet,true)
        end
        --end
      end
      --DEBUGNOW
      for k,v in ipairs(assetTable.irsensors)do
        --if (k % 4) == 0 then
        if type(v)=="string" then
          --InfCore.DebugPrint(tostring(v))
          Gimmick.InvisibleGimmick(TppGameObject.GAME_OBJECT_TYPE_IR_SENSOR,v,dataSet,false)
        end
        --end
      end--<
      for k,v in ipairs(assetTable.stolenAlarms)do
        --if (k % 4) == 0 then
        if type(v)=="string" then
          --InfCore.DebugPrint(tostring(v))
          Gimmick.InvisibleGimmick(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,v,dataSet,false)
        end
        --end
      end--<
    end
  end



  local RANGE_ALRM_LV01=2
  local RANGE_ALRM_LV03=3
  local TIME_ALRM_LV01=10
  local TIME_ALRM_LV03=10

  this.burgularAlarmRange=RANGE_ALRM_LV01
  this.burgularAlarmTime=TIME_ALRM_LV01
end


this.OnBreakGimmick=function(gameObjectId,locatorNameHash,dataSetNameHash,AttackerId)

end


this.OnBreakGimmickBurglarAlarm=function(attackerId)

end


function this.RequestNoticeGimmick(gimmickId, playerId)
  InfCore.Log("########RequestNoticeGimmick########gimmickId::"..gimmickId.." playerId::"..playerId)
  --DEBUGNOW TODO ISHOSTILE if this.IsOffencePlayer(playerId)then
  local cp=GetGameObjectId(mtbs_enemy.cpNameDefine)
  local command={id="RequestNotice",type=0,targetId=gimmickId,sourceId=playerId}--DEBUGNOW type was 0
  SendCommand(cp,command)
  --end
end

return this
