-- InfSecurityCam.lua --DEBUGWIP DEBUGNOW
-- DEBUGNOW crashes on restart if a cam is marked

local this={}

-->
this.registerIvars={
  'enableSecurityCamFREE',
}

this.enableSecurityCamFREE={--WIP
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  MissionCheck=IvarProc.MissionCheckFree,
}
--<

this.packages={
  "/Assets/tpp/pack/mission2/ih/ih_security_camera.fpk",
  "/Assets/tpp/pack/mission2/ih/ih_cam_defloc_pfCamp.fpk",
--"/Assets/tpp/pack/mission2/ih/ih_cam_ly013_cl00.fpk",--DEBUGWIP
}

function this.AddMissionPacks(missionCode,packPaths)
  --DEBUGWIP
  --  if not Ivars.enableSecurityCamFREE:EnabledForMission() then
  --    return
  --  end
  if missionCode~=30020 then
    return--DEBUGNOW
  end

--  --DEBUGWIP
--  if missionCode~=30050 then
--  return
--  end

  for i,packPath in ipairs(this.packages) do
    packPaths[#packPaths+1]=packPath
  end
end

--DEBUGWIP
function this.SetUpEnemy(missionTable)
  --  if not Ivars.enableSecurityCamFREE:EnabledForMission() then
  --    return
  --  end
  --DEBUGWIP
  if vars.missionCode~=30020 then
    return
  end
  

  
  --DEBUGNOW
  if not TppMission.IsMissionStart() then
    return
  end

  this.SetUpSecurityCamera()
end

local camNames = {
  "scamera_pfCamp_0000",
  "scamera_pfCamp_0001",
  "scamera_pfCamp_0002",
  "scamera_pfCamp_0003",
  "scamera_pfCamp_0004",
  "scamera_pfCamp_0005",
}

function this.SetUpSecurityCamera()
  --  local enable=true
  --  GameObject.SendCommand({type="TppSecurityCamera2"},{id="SetEnabled",enabled=enable})
  ----  if this.IsUsingGunCamera()then
  ----    GameObject.SendCommand({type="TppSecurityCamera2"},{id="SetGunCamera"})
  ----  else
  --    GameObject.SendCommand({type="TppSecurityCamera2"},{id="SetNormalCamera"})
  -- -- end
  -- --DEBUGWIP
  --
  --    local developLevel=3
  --    local securityCameras={type="TppSecurityCamera2"}
  --  GameObject.SendCommand(securityCameras,{id="SetDevelopLevel",developLevel=developLevel})

  for index,cameraName in pairs(camNames) do
    local gameObjectId=GameObject.GetGameObjectId(cameraName)
    if gameObjectId==GameObject.NULL_ID then
      InfCore.Log("cam is nullid")--DEBUGNOW
    else
      GameObject.SendCommand(gameObjectId,{id="SetCommandPost",cp="mafr_pfCamp_cp"})
      InfCore.Log("setcam")--DEBUGNOW
    end
  end
end

--REF
--tex cribbed from mtbs_enemy._GetSecurityCameraSetting
this.GetSecurityCameraSetting = function ()
  local eqGrade = InfMain.GetMbsClusterSecuritySoldierEquipGrade()--tex ORIG: TppMotherBaseManagement.GetMbsClusterSecuritySoldierEquipGrade{}
  local isNoKill = InfMain.GetMbsClusterSecurityIsNoKillMode()--tex ORIG: TppMotherBaseManagement.GetMbsClusterSecurityIsNoKillMode()

  local camTypes={
    "CAM",
    "GUN",
  }

  --tex start at max
  local setLevel={
    CAM=3,
    GUN=3,
  }

  local devLevel={
    CAM=TppMotherBaseManagement.GetMbsSecurityCameraLevel{},
    GUN=TppMotherBaseManagement.GetMbsGunCameraLevel{},
  }

  local equipGradeToCamLevel={
    CAM={
      [1]=3,
      [2]=5,
      [3]=6,
    },
    GUN={
      [1]=6,
      [2]=7,
      [3]=8,
    },
  }


  local camType="CAM"
  for i,camType in ipairs(camTypes)do
    --tex cap to equipGrade, 0=not set (so < 3)
    for lvIndex,grade in ipairs(equipGradeToCamLevel[camType])do
      if eqGrade<grade then
        setLevel[camType]=lvIndex-1
      end
    end

    --tex cap to highest developed
    setLevel[camType]=math.min(setLevel[camType],devLevel[camType])
  end

  local isGunMode=setLevel.GUN>0 and not isNoKill
  local setLevelOut = 0
  if isGunMode then
    setLevelOut=setLevel.GUN
  else
    setLevelOut=setLevel.CAM
  end

  return (not isGunMode),setLevelOut
end


--REF CULL from mtbs_enemy.SetupSecurityCamera
--TODO add SetDevelopLevel to revenge system somehow
--NOTE: of interest:
-- SetSneakTarget", target = cameraTable.target } )
--        SendCommand( gameObjectId, {id = "SetCautionTarget", target = cameraTable.target } )
--Cant see any use of it currenlty TODO look again
--but suggests you can have the camera look at something specific in those phases
this.SetupSecurityCamera = function ()
  local numCameraMax = 100
  local numCameraPlaced = 0
  local isSecCameraMode =  false
  local isDevelopedSecCam = false
  local numDevelopLevel = 0

  mvars.mbSecCam_placedCountTotal = 0

  Fox.Log("######## SetupSecurityCamera ####### ")



  isSecCameraMode, numDevelopLevel = mtbs_enemy._GetSecurityCameraSetting()


  if numDevelopLevel == 0 then
    isDevelopedSecCam = false
  else

    isDevelopedSecCam = true
    numDevelopLevel = numDevelopLevel -1
  end


  if not TppGameSequence.IsMaster() then
    if TppEnemy.DEBUG_o50050_memoryDump then
      isSecCameraMode = false
      numDevelopLevel = 2
      isDevelopedSecCam = true
    end
  end

  local isCanSetSecCamMission = function (missionCode)
    if missionCode == 30050 then
      return false
    elseif missionCode == 10115 then
      return false
    else
      return true
    end
  end

  if isCanSetSecCamMission(vars.missionCode) == true then

    local securityCameras = { type="TppSecurityCamera2" }
    SendCommand( securityCameras, {id = "SetDevelopLevel", developLevel = numDevelopLevel } )
  end

  for _, plntName in ipairs( mtbs_enemy.plntNameDefine ) do

    local plntTable = mtbs_enemy.plntParamTable[plntName]
    local numCameraInPlnt = 0
    local enabled = false
    numCameraInPlnt, numCameraPlaced = mtbs_enemy._GetNumOnPlnt(mtbs_enemy._GetSecurityCameraNumOnPlnt, plntName, numCameraPlaced, numCameraMax )
    mvars.mbSecCam_placedCountTotal = mvars.mbSecCam_placedCountTotal + numCameraInPlnt


    for i, cameraTable in ipairs( plntTable.assets.securityCameraList ) do
      if cameraTable.camera then
        local gameObjectId = GameObject.GetGameObjectId("TppSecurityCamera2", cameraTable.camera )
        SendCommand( gameObjectId, {id = "SetCommandPost", cp=mtbs_enemy.cpNameDefine } )


        if cameraTable.target then
          SendCommand( gameObjectId, {id = "SetSneakTarget", target = cameraTable.target } )
          SendCommand( gameObjectId, {id = "SetCautionTarget", target = cameraTable.target } )
        end


        if isDevelopedSecCam == true then
          enabled = (i<=numCameraInPlnt)
        else
          enabled = false
          mvars.mbSecCam_placedCountTotal = 0
        end

        Fox.Log("######## SetupSecurityCamera  Enabled>>".. tostring(enabled))


        if isSecCameraMode == true then
          SendCommand( gameObjectId, {id="NormalCamera"} )
        elseif isSecCameraMode == false then
          SendCommand( gameObjectId, {id="SetGunCamera"} )
        end

        SendCommand( gameObjectId, {id = "SetEnabled", enabled = enabled } )
      end
    end
  end
end


return this
