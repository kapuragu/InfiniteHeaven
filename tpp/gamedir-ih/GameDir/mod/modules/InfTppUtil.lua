--InfTppUtil.lua
-- utility function dumping ground
-- stuff that doesnt have any dependancies to tpp can go in InfUtil
local this={}

local NULL_ID=GameObject.NULL_ID
local GetGameObjectId=GameObject.GetGameObjectId
local GetTypeIndex=GameObject.GetTypeIndex

--tex DEBUGNOW is this the right spot for this, do I need a InfDefine?
this.MAX_OBJECTS_PER_TYPE=512--LIMIT tex see IHTearDown TearDownGameObjectTypes notes --LIMIT --SYNC soldier/any object max instance/totalCount
--tex maxInstanceCount seems to be totalCount for gameobject in fox2
--see this.RunOnAllObjects
--KLUDGE, would be better if we could grab it from exe
this.maxInstanceCount={ 
  --tex ih bumped totalCount in free roam missions: f300n0_npc.fox2
  TppSoldier2={
    [30010]=330,
    [30020]=330,
    [30050]=280,
  },
}--maxInstanceCount

--tex adds game object names to another table, with a not NULL_ID check
function this.ResetObjectPool(objectType,objectNames)
  local pool={}
  for i=1,#objectNames do
    local objectName=objectNames[i]
    local gameId=GetGameObjectId(objectType,objectName)
    if gameId==NULL_ID then
      InfCore.Log("ResetObjectPool: "..objectName.."==NULL_ID")--DEBUG
    else
      pool[#pool+1]=objectName
    end
  end
  return pool
end

--tex just from Tpp.IsGameObjectType, don't want to change it from local
function this.IsGameObjectType(gameObjectId,checkType)
  if gameObjectId==nil then
    return
  end
  if gameObjectId==NULL_ID then
    return
  end
  local typeIndex=GetTypeIndex(gameObjectId)
  if typeIndex==checkType then
    return true
  else
    return false
  end
end


--DEBUG
--tex loops at 512
--    local count=1100
--    local objectType="TppSoldier2"
--    for index=0,count-1 do
--      local gameId=GameObject.GetGameObjectIdByIndex(objectType,index)
--      --tex GetGameObjectIdByIndex errors on index > instance count: 'instance index range error. index n is larger than maxInstanceCount n.'
--      if gameId==NULL_ID then
--        --tex shouldnt happen
--        InfCore.Log("object index "..index.." ==NULL_ID")
--      else
--        local name=InfLookup.ObjectNameForGameId(gameId)
--        InfCore.Log("Soldier index "..index..": gameId:"..gameId.." name:"..tostring(name))
--        --tex return an 'instance index range error. index <GetGameObjectIdByIndex index> is larger than maxInstanceCount <instance count>.'
--        --which makes little sense since the gameId is the same/is not the index.
--        --errors/non errors seem to loop too (getting out of sync with the actual inputted index)
--        --ex:
----        |765.58408987113|Soldier index 842: gameId:1354 name:nil << tex fine even though index is over instance count
----        |765.58408987113|ERROR:C:/GamesSD/MGS_TPP/mod/InfMenuCommands.lua:770: instance index range error. index 330 is larger than maxInstanceCount 330. << not even reporting correct index
----        |765.58408987113|Soldier index 843: gameId:1355 name:nil
--        some other commands seem to be less safe and will hang or crash the game past max index
--        so will have to either be dead accurate with the max index you supply, reply on GetPosition as a canary/break on error for those gameobjects that support it
--        local pos=InfCore.PCall(function()GameObject.SendCommand(gameId,{id="GetPosition"})end)
--      end
--    end

--GOTCHA: there's some funkyness to GetGameObjectIdByIndex.
--GetMaxInstanceCount only works on a couple of gameobjects, hostages and walker gears (more frustrating kjp inconsistancy)
--GetGameObjectIdByIndex itself doesn't seem to care about inputting index > instance count, it will loop the returned gameobject eturning the same gameobjectids
--but running GameObject.SendCommand on a gameid from an index > instance count will return an 'instance index range error. index <GetGameObjectIdByIndex> is larger than maxInstanceCount <instance count>.'
--which doesn't really make sense, it suggests that the gameid has the index, even though on inspection it seems exactly the same/repeated < index gameid
--and it's only for some commands, others will hang or crash the game (again, this wouldn't be an issue if GetGameObjectIdByIndex didn't have a (seeminly) unsafe implmentation.
function this.RunOnAllObjects(objectType,instanceCount,RunFunc)
  if instanceCount and instanceCount>this.MAX_OBJECTS_PER_TYPE then
    InfCore.Log("WARNING: InfTppUtil.RunOnAllObjects: instanceCount:"..tostring(instanceCount).." > MAX_OBJECTS_PER_TYPE:"..this.MAX_OBJECTS_PER_TYPE)
  end  
  
  local count=GameObject.SendCommand({type=objectType},{id="GetMaxInstanceCount"})
  InfCore.Log(objectType.." maxInstanceCount:"..tostring(count))--DEBUG

  if count==nil then
    count=instanceCount or this.maxInstanceCount[objectType] and this.maxInstanceCount[objectType][vars.missionCode] or this.MAX_OBJECTS_PER_TYPE
  end

  if count>0 then
    for index=0,count-1 do
      local gameId=GameObject.GetGameObjectIdByIndex(objectType,index)
      --tex GetGameObjectIdByIndex errors on index > instance count: 'instance index range error. index n is larger than maxInstanceCount n.'
      --RETAILBUG: even though GetGameObjectIdByIndex says 'larger than' the test seems to be >= since if you give it maxInstace it will still complain.
      --ex 'instance index range error. index 330 is larger than maxInstanceCount 330'
      if gameId==NULL_ID then
        --tex shouldnt happen
        InfCore.Log("object index "..index.." ==NULL_ID")
      else
        local success,ret=pcall(RunFunc,gameId,index)
        if not success then
          InfCore.Log("RunOnAllObjects GetGameObjectIdByIndex > instance count at index "..index..", breaking")
          break
        end
      end--if gameId
    end--for count
  end--if count
end--RunOnAllObjects

--tex general warp function for gameobjects that have warp/position commands
--gameObjectId: object that you want to warp to pos, 0 for player
--pos: {x,y,z,rotY}
--rotY: if nil will try pos[4]
--TODO test hostage
--TODO verify rotY needs to be degrees or rads for each. is rads for vehicle, player?
function this.Warp(gameObjectId,pos,rotY)
  rotY=rotY or pos[4] or 0
  
  local typeIndex=GameObject.GetTypeIndex(gameObjectId)   
  if typeIndex==TppGameObject.GAME_OBJECT_TYPE_PLAYER2 then
    --tex TppPlayer.Warp only allows #pos==3 (so no tacked on rotY)
    rotY=foxmath.NormalizeRadian(foxmath.DegreeToRadian(rotY))
    local command={id="WarpAndWaitBlock",pos=pos,rotY=rotY}
    GameObject.SendCommand(gameObjectId,command)
  elseif typeIndex==TppGameObject.GAME_OBJECT_TYPE_VEHICLE then
    pos=Vector3(pos[1],pos[2],pos[3])
    rotY=foxmath.NormalizeRadian(foxmath.DegreeToRadian(rotY))
    GameObject.SendCommand(gameObjectId,{id="SetPosition",position=pos,rotY=rotY})
  elseif typeIndex==TppGameObject.GAME_OBJECT_TYPE_WALKERGEAR2 or TppGameObject.GAME_OBJECT_TYPE_COMMON_WALKERGEAR2 then--tex buddy walker or enemy walker
    rotY=foxmath.NormalizeRadian(foxmath.DegreeToRadian(rotY))
    GameObject.SendCommand(gameObjectId,{id="SetPosition",pos=pos,rotY=rotY})
  elseif typeIndex==TppDefine.HOSTAGE_GM_TYPE[typeIndex] then
    pos=Vector3(pos[1],pos[2],pos[3])
    GameObject.SendCommand(gameObjectId,{id="Warp",degRotationY=rotY,position=pos})
  else
    local typeName=InfLookup.TppGameObject.typeIndex[typeIndex]
    InfCore.Log("WARNING: InfTppUtil.Warp: does not support gameObject type:"..tostring(typeName),true)
  end--if typeIndex
end--Warp

function this.IsDemoPlaying()
  return DemoDaemon.IsDemoPaused() or DemoDaemon.IsDemoPlaying() or DemoDaemon.GetPlayingDemoId()
end

--REF
--local heliSpaceFlagNames={
--  "SkipMissionPreparetion",
--  "NoBuddyMenuFromMissionPreparetion",
--  "NoVehicleMenuFromMissionPreparetion",
--  "DisableSelectSortieTimeFromMissionPreparetion",
--}
--tex see heli_common_sequence OnRestoreSVars
function this.SetHeliSpaceFlags(heliSpaceFlags,missionCode)
  for flagName,set in pairs(heliSpaceFlags) do
    local mvarName="heliSpace_"..flagName
    if mvars[mvarName]then
      mvars[mvarName][missionCode]=set
    end
  end
end--SetHeliSpaceFlags

--SYNC: heli_common_sequence .OnRestoreSVars
local heliFlagDefaults={
  SkipMissionPreparetion={
    [10010]=true,
    [10020]=false,--ORIG: [10020]=(not TppStory.IsMissionCleard(10020)),--tex cant use TppStory while module is loaded, see GetHeliSpaceFlag for workaround
    [10030]=true,
    [10240]=true,
    [10280]=true,
    [11043]=true,
    [11044]=true,
    [30050]=true,
    [30150]=true,
    [30250]=true,
  },
  NoBuddyMenuFromMissionPreparetion={
    [10020]=true,
    [10115]=true,
    [30050]=true,
    [30250]=true,
    [50050]=true
  },
  NoVehicleMenuFromMissionPreparetion={
    [10115]=true,
    [30050]=true,
    [30150]=true,
    [30250]=true,
    [50050]=true
  },
  DisableSelectSortieTimeFromMissionPreparetion={
    [10020]=true,
    [10080]=true,
  },
}--heliFlagDefaults

--tex get heliSpaceFlag from ivar, or default value
function this.GetHeliSpaceFlag(flagName,missionCode)
  local varName="heliSpace_"..flagName
  if not IvarProc.EnabledForMission(varName,missionCode) then
    InfCore.Log("GetHeliSpaceFlag: "..varName.." not enabledformission "..tostring(missionCode))--DEBUGNOW
    return nil
  end
  
  local setting=IvarProc.GetForMission(varName,missionCode)-1--tex KLUDGE: "DEFAULT","FALSE","TRUE" == 0,1,2 - so shift value so default==-1
  local flag
  --DEFAULT
  if setting==-1 then
    --tex WORKAROUND cant use TppStory while module is loaded so heliFlagDefaults will be wrong
    if missionCode==10020 and flagName=="SkipMissionPreparetion" then
      flag=not TppStory.IsMissionCleard(10020)
    else
      flag=heliFlagDefaults[flagName][missionCode]
    end
  else
    flag=setting==1
  end
  return flag
end--GetHeliSpaceFlag

return this
