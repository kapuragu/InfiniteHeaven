

--REF
--this.OFFLINE_MOHTER_BASE_LAYOUT_CODE=0
--this.STORY_MISSION_LAYOUT_CODE={
--  [10030]=this.OFFLINE_MOHTER_BASE_LAYOUT_CODE,
--  [10115]=this.OFFLINE_MOHTER_BASE_LAYOUT_CODE,
--  [11115]=this.OFFLINE_MOHTER_BASE_LAYOUT_CODE,
--  [10240]=this.OFFLINE_MOHTER_BASE_LAYOUT_CODE,
--  [30050]=this.OFFLINE_MOHTER_BASE_LAYOUT_CODE,
--  [30051]=this.OFFLINE_MOHTER_BASE_LAYOUT_CODE,
--  [30150]=500,
--  [30250]=this.OFFLINE_MOHTER_BASE_LAYOUT_CODE
--}
--this.INVALID_LAYOUT_CODE=65535
--this.STORY_MISSION_CLUSTER_ID={
--  [10030]=0,
--  [10115]=2,
--  [11115]=2,
--  [10240]=7,
--  [30050]=0,
--  [30150]=0,
--  [30250]=7
--}

function this.AddFOBLayoutPack(missionCode)
  local missionTypeName,missionCodeName=this.GetMissionTypeAndMissionName(missionCode)
  if missionCode==50050 then
  end
  if(missionCode==50050)or(missionCode==10115)or(missionCode==30050 and vars.mbLayoutCode>3)then--tex DEBUGNOW added or 30050 passthrough
    local layoutPath="/Assets/tpp/pack/mission2/"..(missionTypeName..("/"..(missionCodeName..("/"..(missionCodeName..string.format("_area_ly%03d",vars.mbLayoutCode))))))
    local layoutPack=layoutPath..".fpk"
    local clusterId=vars.mbClusterId
    if(missionCode==10115)then
      clusterId=TppDefine.CLUSTER_DEFINE.Develop
    end
    local clusterLayoutPack=layoutPath..(string.format("_cl%02d",clusterId)..".fpk")
    this.AddMissionPack(layoutPack)
    this.AddMissionPack(clusterLayoutPack)
  elseif missionCode==30050 then
    local layoutPack="/Assets/tpp/pack/mission2/"..(missionTypeName..("/"..(missionCodeName..("/"..(missionCodeName..string.format("_ly%03d",vars.mbLayoutCode))))))
    local fpkPath=layoutPack..".fpk"
    this.AddMissionPack(fpkPath)
  end
end

function this.GoToEmergencyMission()
  local emergencyMissionCode=gvars.mis_nextMissionCodeForEmergency
  local startRoute
  if emergencyMissionCode~=TppDefine.SYS_MISSION_ID.FOB then
    if gvars.mis_nextMissionStartRouteForEmergency~=0 then
      startRoute=gvars.mis_nextMissionStartRouteForEmergency
      --tex DEBUGNOW HACK OFF
      --    else
      --      return
    end
  end
  local mbLayoutCode
  if gvars.mis_nextLayoutCodeForEmergency~=TppDefine.INVALID_LAYOUT_CODE then
    mbLayoutCode=gvars.mis_nextLayoutCodeForEmergency
  else
    mbLayoutCode=TppDefine.STORY_MISSION_LAYOUT_CODE[vars.missionCode]or TppDefine.OFFLINE_MOHTER_BASE_LAYOUT_CODE--RETAILBUG: since day0, was TppDefine.STORY_MISSION_LAYOUT_CODE[missionCode]
  end
  local clusterId=2
  if gvars.mis_nextClusterIdForEmergency~=TppDefine.INVALID_CLUSTER_ID then
    clusterId=gvars.mis_nextClusterIdForEmergency
  end
  this.ReserveMissionClear{missionClearType=TppDefine.MISSION_CLEAR_TYPE.FROM_HELISPACE,nextMissionId=emergencyMissionCode,nextHeliRoute=startRoute,nextLayoutCode=mbLayoutCode,nextClusterId=clusterId}
end

this.setSTORY_MISSION_LAYOUT_CODE={
  --save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=1000},
  OnChange=function(self,setting,previousSetting)

    InfCore.DebugPrint"terrible hack"
    InfCore.Log("setSTORY_MISSION_LAYOUT_CODE")
    TppPackList.AddFOBLayoutPack=this.AddFOBLayoutPack
    TppMission.GoToEmergencyMission=this.GoToEmergencyMission
    TppDefine.STORY_MISSION_LAYOUT_CODE[10115]=setting
    TppDefine.STORY_MISSION_LAYOUT_CODE[30050]=setting

    gvars.mis_nextMissionCodeForEmergency=30050
    gvars.mis_nextMissionStartRouteForEmergency=nil
    gvars.mis_nextLayoutCodeForEmergency=setting
    gvars.mis_nextClusterIdForEmergency=0
    InfCore.Log("setSTORY_MISSION_LAYOUT_CODE done")
  end,
}--setSTORY_MISSION_LAYOUT_CODE

