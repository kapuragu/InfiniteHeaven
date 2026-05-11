-- DOBUILD: 1
-- ORIGINALQAR: chunk3
-- PACKPATH: \Assets\tpp\pack\location\mtbs\pack_common\mtbs_script.fpkd
-- mtbs_enemy.lua
local FACE_SOLDIER_NUM = 36--LIMIT

local mtbs_enemy = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local GetGameObjectId = GameObject.GetGameObjectId
local NULL_ID = GameObject.NULL_ID
local SendCommand = GameObject.SendCommand

-- RETAILPATCH 1090>
local TIMER_NAME_SWITCH_ROUTE_FOCUS_AREA = "SwitchRouteFocusArea"
-- ^

local FOCUS_AREA_DEFINE = { "A", "B", "C", "D", "E", "F", "G", "H", }




mtbs_enemy.routeChangeProbability = 50

mtbs_enemy.cpNameDefine = nil
mtbs_enemy.plntNameDefine = {
  "plnt0","plnt1","plnt2","plnt3",
}
mtbs_enemy.cpNameToClsterIdList = {}
mtbs_enemy.useUiSetting = true--tex NMC f30050_enemy sets false, 10115 sets false. Seems to be whether to use FOB settings







mtbs_enemy.plntParamTable = {
  plnt0 = {
    plntDefine 	= "Special",
    soldierNum 	= { 0 },
    placeWepNum = { 0 },
    uavNum		= { 0 },
    securityCameraNum = { 0 },

    assets = {
      soldierList = {},
      soldierRouteList = {
        Sneak = { { inPlnt = {}, outPlnt = {} }, },
        Night = { { inPlnt = {}, outPlnt = {} }, },
        Caution = { { inPlnt = {}, outPlnt = {} }, },
      },
      uavList = {},
      uavSneakRoute = {},
      uavCombatRoute = {},
      mineList = {},
      decyList = {},
      securityCameraList = {},
    },
  },
  plnt1 = {
    plntDefine 	= "Common1",
    soldierNum 	= { 0 },
    placeWepNum = { 0 },
    uavNum		= { 0 },
    securityCameraNum = { 0 },

    assets = {
      soldierList = {},
      soldierRouteList = {
        Sneak = { { inPlnt = {}, outPlnt = {} }, },
        Night = { { inPlnt = {}, outPlnt = {} }, },
        Caution = { { inPlnt = {}, outPlnt = {} }, },
      },
      uavList = {},
      uavSneakRoute = {},
      uavCombatRoute = {},
      mineList = {},
      decyList = {},
      securityCameraList = {},
    },
  },
  plnt2 = {
    plntDefine 	= "Common2",
    soldierNum	= { 0 },
    placeWepNum	= { 0 },
    uavNum		= { 0 },
    securityCameraNum = { 0 },

    assets = {
      soldierList = {},
      soldierRouteList = {
        Sneak = { { inPlnt = {}, outPlnt = {} }, },
        Night = { { inPlnt = {}, outPlnt = {} }, },
        Caution = { { inPlnt = {}, outPlnt = {} }, },
      },
      uavList = {},
      uavSneakRoute = {},
      uavCombatRoute = {},
      mineList = {},
      decyList = {},
      securityCameraList = {},
    },
  },
  plnt3 = {
    plntDefine 	= "Common3",
    soldierNum 	= { 0 },
    placeWepNum = { 0 },
    uavNum		= { 0 },
    securityCameraNum = { 0 },

    assets = {
      soldierList = {},
      soldierRouteList = {
        Sneak = { { inPlnt = {}, outPlnt = {} }, },
        Night = { { inPlnt = {}, outPlnt = {} }, },
        Caution = { { inPlnt = {}, outPlnt = {} }, },
      },
      uavList = {},
      uavSneakRoute = {},
      uavCombatRoute = {},
      mineList = {},
      decyList = {},
      securityCameraList = {},
    }
  },
}

function mtbs_enemy.InitSecurityNumTableFromRank()
  for plntName, plntTable in pairs( mtbs_enemy.plntParamTable ) do
    local securityDefine = TppDefine.SECURITY_SETTING.numInCommonPlatform
    if plntTable.plntDefine == "Special" then
      securityDefine = TppDefine.SECURITY_SETTING.numInSpecialPlatform
    end
    plntTable.soldierNum = {0}
    plntTable.placeWepNum = {0}
    plntTable.uavNum = {0}
    plntTable.securityCameraNum = {0}

    if TppMotherBaseManagement.GetMbsSecuritySectionRank{ type = "Staff" } == TppMotherBaseManagementConst.SECTION_FUNC_RANK_NONE then
      for i=1,3 do
        table.insert( plntTable.soldierNum, 0 )
        table.insert( plntTable.placeWepNum, 0 )
        table.insert( plntTable.uavNum, 0 )
        table.insert( plntTable.securityCameraNum, 0 )
      end
    else
      for i=1,3 do
        do
          local index = 3 * ( TppMotherBaseManagement.GetMbsSecuritySectionRank{ type = "Staff" } - 1 ) + i
          table.insert( plntTable.soldierNum, securityDefine.soldier[index] )
        end
        do
          local index = 3 * ( TppMotherBaseManagement.GetMbsSecuritySectionRank{ type = "Machine" } - 1 ) + i
          table.insert( plntTable.placeWepNum, securityDefine.mine[index] )
          table.insert( plntTable.uavNum, securityDefine.uav[index] )
          table.insert( plntTable.securityCameraNum, securityDefine.camera[index] )
        end
      end
    end
  end
end

local SHOCK_DECY_INDEX = 1
local ACTIVE_DECY_INDEX = 2
local NORMAL_DECY_INDEX = 3
local DMINE_INDEX = 1
local SLEEPING_MINE_INDEX = 2



mtbs_enemy.InitDevelopGradeTable = function()

  mvars.mbEnemy_decyEquipIdList = {}
  do
    mvars.mbEnemy_decyEquipIdList[SHOCK_DECY_INDEX] = {}
    local level = TppMotherBaseManagement.GetMbsShockdecoyLevel{}
    if level >= 3 then
      mvars.mbEnemy_decyEquipIdList[SHOCK_DECY_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11018)] = TppEquip.EQP_SWP_ShockDecoy_G02
    end
    if level >= 2 then
      mvars.mbEnemy_decyEquipIdList[SHOCK_DECY_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11017)] = TppEquip.EQP_SWP_ShockDecoy_G01
    end
    if level >= 1 then
      mvars.mbEnemy_decyEquipIdList[SHOCK_DECY_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11016)] = TppEquip.EQP_SWP_ShockDecoy
    end
  end
  do
    mvars.mbEnemy_decyEquipIdList[ACTIVE_DECY_INDEX] = {}
    local level = TppMotherBaseManagement.GetMbsActivedecoyLevel{}
    if level >= 3 then
      mvars.mbEnemy_decyEquipIdList[ACTIVE_DECY_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11015)] = TppEquip.EQP_SWP_ActiveDecoy_G02
    end
    if level >= 2 then
      mvars.mbEnemy_decyEquipIdList[ACTIVE_DECY_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11014)] = TppEquip.EQP_SWP_ActiveDecoy_G01
    end
    if level >= 1 then
      mvars.mbEnemy_decyEquipIdList[ACTIVE_DECY_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11013)] = TppEquip.EQP_SWP_ActiveDecoy
    end
  end
  do
    mvars.mbEnemy_decyEquipIdList[NORMAL_DECY_INDEX] = {}
    local level = TppMotherBaseManagement.GetMbsDecoyLevel{}
    if level >= 3 then
      mvars.mbEnemy_decyEquipIdList[NORMAL_DECY_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11012)] = TppEquip.EQP_SWP_Decoy_G02
    end
    if level >= 2 then
      mvars.mbEnemy_decyEquipIdList[NORMAL_DECY_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11011)] = TppEquip.EQP_SWP_Decoy_G01
    end
    if level >= 1 then
      mvars.mbEnemy_decyEquipIdList[NORMAL_DECY_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11010)] = TppEquip.EQP_SWP_Decoy
    end
  end


  mvars.mbEnemy_mineEquipIdListSortByEquipGrade = {}
  do
    mvars.mbEnemy_mineEquipIdListSortByEquipGrade[DMINE_INDEX] = {}
    local level = TppMotherBaseManagement.GetMbsDMineLevel{}
    if level >= 4 then
      mvars.mbEnemy_mineEquipIdListSortByEquipGrade[DMINE_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11043)] = TppEquip.EQP_SWP_DMine_G03
    end
    if level >= 3 then
      mvars.mbEnemy_mineEquipIdListSortByEquipGrade[DMINE_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11042)] = TppEquip.EQP_SWP_DMine_G02
    end
    if level >= 2 then
      mvars.mbEnemy_mineEquipIdListSortByEquipGrade[DMINE_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11041)] = TppEquip.EQP_SWP_DMine_G01
    end
    if level >= 1 then
      mvars.mbEnemy_mineEquipIdListSortByEquipGrade[DMINE_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11040)] = TppEquip.EQP_SWP_DMine
    end
  end
  do
    mvars.mbEnemy_mineEquipIdListSortByEquipGrade[SLEEPING_MINE_INDEX] = {}
    local level = TppMotherBaseManagement.GetMbsSleepingGasMineLevel{}
    if level >= 3 then
      mvars.mbEnemy_mineEquipIdListSortByEquipGrade[SLEEPING_MINE_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11052)] = TppEquip.EQP_SWP_SleepingGusMine_G02
    end
    if level >= 2 then
      mvars.mbEnemy_mineEquipIdListSortByEquipGrade[SLEEPING_MINE_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11051)] = TppEquip.EQP_SWP_SleepingGusMine_G01
    end
    if level >= 1 then
      mvars.mbEnemy_mineEquipIdListSortByEquipGrade[SLEEPING_MINE_INDEX][TppMotherBaseManagement.GetEquipDevelopRank(11050)] = TppEquip.EQP_SWP_SleepingGusMine
    end
  end
end


mtbs_enemy.soldierDefine = {
  }


mtbs_enemy.soldierNameToCpName = {}

mtbs_enemy.SoldierCombatAbirityRank = {
  [TppMotherBaseManagementConst.STAFF_SECTION_RANK_G] = "LOW",
  [TppMotherBaseManagementConst.STAFF_SECTION_RANK_F] = "LOW",
  [TppMotherBaseManagementConst.STAFF_SECTION_RANK_E] = "LOW",
  [TppMotherBaseManagementConst.STAFF_SECTION_RANK_D] = "MID",
  [TppMotherBaseManagementConst.STAFF_SECTION_RANK_C] = "MID",
  [TppMotherBaseManagementConst.STAFF_SECTION_RANK_B] = "MID2",
  [TppMotherBaseManagementConst.STAFF_SECTION_RANK_A] = "HIGH",
  [TppMotherBaseManagementConst.STAFF_SECTION_RANK_S] = "SPECIAL1",
  [TppMotherBaseManagementConst.STAFF_SECTION_RANK_SP] = "SPECIAL2",
  [TppMotherBaseManagementConst.STAFF_SECTION_RANK_SPP] = "SPECIAL3",
}



mtbs_enemy.SoldierCombatAbirity = {
  LOW = {
    shot	= "low",
    grenade = "low",
    reload	= "low",
    hp		= "low",
    cure	= "low",
    speed	= "low",
    notice	= "low",
    holdup	= "low",
    reflex	= "low",
    fulton	= "low",
  },
  MID = {
    shot	= "mid",
    grenade = "mid",
    reload	= "mid",
    hp		= "mid",
    cure	= "mid",
    speed	= "mid",
    notice	= "mid",
    holdup	= "mid",
    reflex	= "mid",
    fulton	= "mid",
  },
  MID2 = {
    shot	= "high",
    grenade = "mid",
    reload	= "mid",
    hp		= "mid",
    cure	= "mid",
    speed	= "mid",
    notice	= "high",
    holdup	= "high",
    reflex	= "high",
    fulton	= "high",
  },
  HIGH = {
    shot	= "high",
    grenade = "high",
    reload	= "high",
    hp		= "high",
    cure	= "high",
    speed	= "high",
    notice	= "high",
    holdup	= "high",
    reflex	= "high",
    fulton	= "high",
  },
  SPECIAL1 = {
    shot	= "high",
    grenade = "sp",
    reload	= "high",
    hp		= "high",
    cure	= "sp",
    speed	= "high",
    notice	= "high",
    holdup	= "high",
    reflex	= "high",
    fulton	= "high",
  },
  SPECIAL2 = {
    shot	= "sp",
    grenade = "sp",
    reload	= "high",
    hp		= "sp",
    cure	= "sp",
    speed	= "high",
    notice	= "sp",
    holdup	= "high",
    reflex	= "high",
    fulton	= "sp",
  },
  SPECIAL3 = {
    shot	= "sp",
    grenade = "sp",
    reload	= "sp",
    hp		= "sp",
    cure	= "sp",
    speed	= "sp",
    notice	= "sp",
    holdup	= "sp",
    reflex	= "sp",
    fulton	= "sp",
  }
}





mtbs_enemy.soldierSubTypes = {
  DD_FOB = {

  },
}









































mtbs_enemy.routeSets = {}








mtbs_enemy.SetupUAV = function ( clstID )
  Fox.Log("######## SetupUAV ########")
  local numUavMax = 100
  local numUavPlaced = 0
  local numDevelopType = 0
  local isDevelopedUav = false
  local isEnabled = false

  mvars.mbUav_placedCountTotal = 0


  isDevelopedUav, numDevelopType = mtbs_enemy._GetUavSetting()
	
	--RETAILPATCH 1090>
	local uavCombatGrade, empLevel = TppEneFova.GetUavCombatGradeAndEmpLevel(
		TppMotherBaseManagement.GetMbsClusterSecuritySoldierEquipGrade(),
		TppMotherBaseManagement.GetMbsClusterSecurityIsNoKillMode(),
		TppMotherBaseManagement.GetMbsUavLevel(),
		TppMotherBaseManagement.GetMbsUavSleepingGusGrenadeLevel()
	)
  --^

  for _, plntName in ipairs( mtbs_enemy.plntNameDefine ) do

    local plntTable = mtbs_enemy.plntParamTable[plntName]
    local plntAssetsTable = plntTable.assets
    local numUavInPlnt = 0

    numUavInPlnt, numUavPlaced = mtbs_enemy._GetNumOnPlnt(mtbs_enemy._GetUavNumOnPlnt, plntName, numUavPlaced, numUavMax )
    mvars.mbUav_placedCountTotal = mvars.mbUav_placedCountTotal + numUavInPlnt

    for i, uavName in ipairs( plntAssetsTable.uavList ) do
      local gameObjectId = GetGameObjectId( uavName )
      if isDevelopedUav == true then
        isEnabled = i<=numUavInPlnt
      else
        isEnabled = false
        mvars.mbUav_placedCountTotal = 0
      end
      Fox.Log("######## SetupUAV  Enabled>>".. tostring(isEnabled))
      SendCommand( gameObjectId, {id = "SetEnabled", enabled = isEnabled } )
      SendCommand( gameObjectId, {id = "SetPatrolRoute", route=plntAssetsTable.uavSneakRoute[i] } )
      SendCommand( gameObjectId, {id = "SetCombatRoute", route=plntAssetsTable.uavCombatRoute[i] } )
      SendCommand( gameObjectId, {id = "SetCommandPost", cp=mtbs_enemy.cpNameDefine } )
      SendCommand( gameObjectId, {id = "WarpToNearestPatrolRouteNode"} )
      SendCommand( gameObjectId, {id = "SetDevelopLevel", developLevel = numDevelopType, empLevel = empLevel } )
			--RETAILPATCH 1090>
			if uavCombatGrade then
				SendCommand( gameObjectId, {id = "SetCombatGrade", defenseGrade = uavCombatGrade } )
			end
      --^
    end
  end
end


mtbs_enemy._GetSecurityCameraSetting = function ()
  Fox.Log("######## _GetSecurityCameraSetting ######")
  local numCameraMax = 100
  local numCameraPlaced = 0
  local eqGrade = InfMainTpp.GetMbsClusterSecuritySoldierEquipGrade()--tex ORIG: TppMotherBaseManagement.GetMbsClusterSecuritySoldierEquipGrade{}
  local numDevSecCamLv = TppMotherBaseManagement.GetMbsSecurityCameraLevel{}
  local numDevGunCamLv = TppMotherBaseManagement.GetMbsGunCameraLevel{}
  local numSetSecCamLv = 0
  local numSetGunCamLv = 0
  local isNoKill = InfMainTpp.GetMbsClusterSecurityIsNoKillMode()--tex ORIG: TppMotherBaseManagement.GetMbsClusterSecurityIsNoKillMode()
  local isDevelopedSecCam = false
  local isSecCameraMode = true
  local numSetLevel = 0
  local NOT_SET = 0
  local INIT_GRADE_SEC_CAMERA = 3
  local INIT_GRADE_GUN_CAMERA = 4


  local CAM_GRADE_Lv1 = 3
  local CAM_GRADE_Lv2 = 5
  local CAM_GRADE_Lv3 = 6

  if eqGrade < CAM_GRADE_Lv1 then
    numSetSecCamLv = NOT_SET
  else
    if numDevSecCamLv == 1 then
      numSetSecCamLv = 1
    elseif numDevSecCamLv == 2 then
      if eqGrade >= CAM_GRADE_Lv2 then
        numSetSecCamLv = 2
      else
        numSetSecCamLv = 1
      end
    elseif numDevSecCamLv == 3 then
      if eqGrade >= CAM_GRADE_Lv3 then
        numSetSecCamLv = 3
      elseif eqGrade >= CAM_GRADE_Lv2 then
        numSetSecCamLv = 2
      else
        numSetSecCamLv = 1
      end
    end
  end


  local GUN_CAM_GRADE_Lv1 = 6
  local GUN_CAM_GRADE_Lv2 = 7
  local GUN_CAM_GRADE_Lv3 = 8

  if eqGrade < GUN_CAM_GRADE_Lv1 then
    numSetGunCamLv = NOT_SET
  else
    if numDevGunCamLv == 1 then
      numSetGunCamLv = 1
    elseif numDevGunCamLv == 2 then
      if eqGrade >= GUN_CAM_GRADE_Lv2 then
        numSetGunCamLv = 2
      else
        numSetGunCamLv = 1
      end
    elseif numDevGunCamLv == 3 then
      if eqGrade >= GUN_CAM_GRADE_Lv3 then
        numSetGunCamLv = 3
      elseif eqGrade >= GUN_CAM_GRADE_Lv2 then
        numSetGunCamLv = 2
      else
        numSetGunCamLv = 1
      end
    end
  end



  if (numSetGunCamLv == NOT_SET) and (numSetSecCamLv == NOT_SET) then
    numSetLevel = NOT_SET
  else
    if isNoKill == false then

      if numSetGunCamLv == NOT_SET then
        isSecCameraMode = true
        numSetLevel = numSetSecCamLv
      else
        isSecCameraMode = false
        numSetLevel = numSetGunCamLv
      end
    else
      isSecCameraMode = true
      if numSetSecCamLv == NOT_SET then
        numSetLevel = NOT_SET
      else
        numSetLevel = numSetSecCamLv
      end
    end
  end










  return isSecCameraMode, numSetLevel
end



mtbs_enemy.SetupSecurityCamera = function ()
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

mtbs_enemy.SetupDecy = function()
  local numPlaced = 0
  local numMax = 999
  local equipGrade = InfMainTpp.GetMbsClusterSecuritySoldierEquipGrade()--tex ORIG: TppMotherBaseManagement.GetMbsClusterSecuritySoldierEquipGrade{}
  local equipId = mtbs_enemy._GetDecyEquipId( equipGrade )

  mvars.mbDecoy_placedCountTotal = 0

  for plntName, plntTable in pairs( mtbs_enemy.plntParamTable ) do
    local numInPlnt = 0
    numInPlnt, numPlaced = mtbs_enemy._GetNumOnPlnt(mtbs_enemy._GetDecyNumOnPlnt, plntName, numPlaced, numMax )
    mvars.mbDecoy_placedCountTotal = mvars.mbDecoy_placedCountTotal + numInPlnt

    for i, locatorName in ipairs(mtbs_enemy.plntParamTable[plntName].assets.decyList) do
      if equipId then
        TppPlaced.ChangeEquipIdByLocatorName( locatorName, equipId )
        TppPlaced.SetEnableByLocatorName( locatorName , ( numInPlnt >= i ) )
      else
        TppPlaced.SetEnableByLocatorName( locatorName , false )
        mvars.mbDecoy_placedCountTotal = 0
      end
    end
  end
end

mtbs_enemy.SetupMine = function()
  local numPlaced = 0
  local numMax 	= 999
  local isNoKillMode = InfMainTpp.GetMbsClusterSecurityIsNoKillMode()--tex ORIG: TppMotherBaseManagement.GetMbsClusterSecurityIsNoKillMode()
  local equipGrade = InfMainTpp.GetMbsClusterSecuritySoldierEquipGrade()--tex ORIG: TppMotherBaseManagement.GetMbsClusterSecuritySoldierEquipGrade{}
  local mineEquipId = mtbs_enemy._GetMineEquipId( isNoKillMode, equipGrade )

  mvars.mbMine_placedCountTotal = 0

  for plntName, plntTable in pairs( mtbs_enemy.plntParamTable ) do
    local numInPlnt = 0
    numInPlnt, numPlaced =mtbs_enemy._GetNumOnPlnt(mtbs_enemy._GetMineNumOnPlnt, plntName, numPlaced, numMax )
    mvars.mbMine_placedCountTotal = mvars.mbMine_placedCountTotal + numInPlnt
    for i, locatorName in ipairs(mtbs_enemy.plntParamTable[plntName].assets.mineList) do
      if mineEquipId then
        TppPlaced.ChangeEquipIdByLocatorName( locatorName, mineEquipId )
        TppPlaced.SetEnableByLocatorName( locatorName , ( numInPlnt >= i ) )
      else
        TppPlaced.SetEnableByLocatorName( locatorName , false )
        mvars.mbMine_placedCountTotal = 0
      end
    end
  end
end

mtbs_enemy.SetupFocusArea = function()
  mvars.mbSoldier_focusArea = {}
  mvars.mbSoldier_currentFocusArea = {}
  for _,plntName in ipairs( mtbs_enemy.plntNameDefine ) do
    mvars.mbSoldier_focusArea[plntName] = {}
    mvars.mbSoldier_currentFocusArea[plntName] = 0
    --[[ for i = 0,7 do
			local plntDefine = mtbs_enemy.plntParamTable[plntName].plntDefine
			local area = TppMotherBaseManagement.GetMbsPlatformSecurityImportantCautionArea{ platform=plntDefine, slot = i } 
			if 0 < area and area <= 8 then 
				table.insert( mvars.mbSoldier_focusArea[plntName], FOCUS_AREA_DEFINE[area] )
			end
		end ]]
    --RETAILPATCH 1090 from ^>
    for i , area in ipairs(FOCUS_AREA_DEFINE) do
      local areaIndex = i-1
      local plntDefine = mtbs_enemy.plntParamTable[plntName].plntDefine
      if TppMotherBaseManagement.GetMbsPlatformSecurityImportantCautionArea{ platform=plntDefine, area=areaIndex } == 1 then
        table.insert( mvars.mbSoldier_focusArea[plntName], area )
      end
    end
    --^
  end
end


mtbs_enemy.SetupEmblem = function()
  local emblemType = 1
  if TppServerManager.FobIsSneak() then
    if not TppMotherBaseManagement.IsMbsOwner{} then
      emblemType = 2
    end
  else

    if not TppMotherBaseManagement.IsMbsOwner{} then
      return
    end
  end


  local gameObjectId = { type="TppSoldier2" }
  local command = { id = "SetEmblemType", type = emblemType }
  GameObject.SendCommand( gameObjectId, command )
end



















mtbs_enemy.SetupSortieSoldiers = function(clusterId )
  local solList = mtbs_enemy.soldierDefine[mtbs_enemy.cpNameDefine]
  if not solList then
    return 0
  end

  local staffIdList = mtbs_enemy.GetSecurityStaffIdList( clusterId )
  InfCore.PrintInspect(staffIdList,"SetupSortieSoldiers staffIdList")--tex DEBUGNOW
  if not staffIdList then
    return 0
  end

  if not mtbs_enemy.useUiSetting then
    return 0
  end

  if InfEneFova.IsCustomSoldierTypeEnabled() then--tex>
    InfMain.RandomSetToLevelSeed()
  end--<

  local sortieSolNum = 0
  for i, locatorName in ipairs(mvars.mbSoldier_enableSoldierLocatorList[clusterId]) do
    local staffId = staffIdList[i]
    if not staffId then
      break
    end
    sortieSolNum = sortieSolNum + 1
    local gameObjectId = GetGameObjectId("TppSoldier2", locatorName)
    if gameObjectId ~= NULL_ID then
      mtbs_enemy.SetStaffId( gameObjectId, staffId )
      local faceId = TppMotherBaseManagement.StaffIdToFaceId{ staffId=staffId }
      TppEneFova.ApplyMTBSUniqueSetting( gameObjectId, faceId, i>FACE_SOLDIER_NUM )
    end
  end

  if #staffIdList == 0 then

    for i, locatorName in ipairs(mvars.mbSoldier_enableSoldierLocatorList[clusterId]) do
      local gameObjectId = GetGameObjectId("TppSoldier2", locatorName)
      if gameObjectId ~= NULL_ID then
        TppEneFova.ApplyMTBSUniqueSetting( gameObjectId, i, i>FACE_SOLDIER_NUM )
      end
    end
  end


  if not TppGameSequence.IsMaster()
    and TppEnemy.DEBUG_o50050_memoryDump then
    mtbs_enemy.SetupSortieSoldierFovaForMemoryDump( clusterId )
  end

  if InfEneFova.IsCustomSoldierTypeEnabled() then--tex>
    InfMain.RandomResetToOsTime()
  end--<

  return sortieSolNum
end





mtbs_enemy.combatSetting = {

  }



mtbs_enemy.SetEnableSoldierInCluster = function( clusterId , isEnable )
  if mvars.mbSoldier_enableSoldierLocatorList and	mvars.mbSoldier_enableSoldierLocatorList[clusterId] then
    local solList = mvars.mbSoldier_enableSoldierLocatorList[clusterId]
    if solList then
      for _, name in ipairs(solList) do
        local gameObjectId = GetGameObjectId(name)
        SendCommand( gameObjectId, { id = "SetEnabled", enabled = isEnable, noAssignRoute = false } )
      end
    end
  end

  if mvars.mbEnemyDisableSoldierList then
    for _, solName in ipairs( mvars.mbEnemyDisableSoldierList ) do
      local gameObjectId = GetGameObjectId(solName)
      SendCommand( gameObjectId, { id = "SetEnabled", enabled = false, noAssignRoute = false } )
    end
  end
end


mtbs_enemy.SetDisableSoldier = function ( soldierName )
  Fox.Log("#### SetDisableSoldier ####" .. soldierName)
  TppEnemy.SetDisable( soldierName, true )
end

mtbs_enemy.SetupClusterParam = function ( paramList )
  mvars.mbSoldier_clusterParamList = paramList
end



mtbs_enemy.GetRouteSetPriority = function( cpGameObjectId, routeSetListInPlants, plantTables, sysPhase )
  local retRouteList = {}


  local cpName = mvars.ene_cpList[cpGameObjectId]
  local clusterId = mtbs_enemy.cpNameToClsterIdList[cpName]
  mtbs_enemy._SetAssetsTable(clusterId)

  if not mvars.mbSoldier_useRouteList then
    mvars.mbSoldier_useRouteList = {}

  end

  for i, plntHash in ipairs( plantTables[cpGameObjectId] ) do
    local routeSets = routeSetListInPlants[plntHash]
    if routeSets then
      local plntName = mvars.mbSoldier_strCodeToStr[plntHash]
      local sortieSolderNum = 0
      if mtbs_enemy.useUiSetting then
        sortieSolderNum = mtbs_enemy._GetSoldierNumOnPlatformFromUiSetting( plntName )
      else
        sortieSolderNum = #mtbs_enemy.plntParamTable[plntName].assets.soldierList
      end

      local tmpRouteList = {}

      local routeSetList, routeType = mtbs_enemy._GetRouteSetList( cpGameObjectId, plntName, sysPhase )
      for _, devRouteSet in ipairs(routeSetList) do
        for __, routeName in ipairs(devRouteSet.inPlnt) do

          table.insert(tmpRouteList, routeName)
        end
        if routeType == "Caution" then
          for __, routeName in ipairs(devRouteSet.outPlnt) do

            table.insert(tmpRouteList, routeName)
          end
        end
      end

      if DEBUG and #tmpRouteList < sortieSolderNum then
        Fox.Warning("enemy route is very few. enemy on plnt: " .. tostring(sortieSolderNum) .. " route on plnt: " .. tostring(#tmpRouteList) .. " :cpName: " ..tostring(cpName) )
      end




      local notSniperRouteList = {}
      local sortieSniperNum = mtbs_enemy.GetSortieSniperNumInPlnt( clusterId, plntName )
      local addSniperRouteNum = 0
      for index, route in ipairs(tmpRouteList) do
        if Tpp.IsTypeTable(route) and route.attr == "SNIPER" then
          if addSniperRouteNum < sortieSniperNum then
            table.insert( retRouteList, route )
            addSniperRouteNum = addSniperRouteNum + 1
            Fox.Log("AddSniperRoute:Group:" ..tostring(plntName) .. " :routeName:" ..tostring(route) )
          end
        elseif Tpp.IsTypeString(route) then
          table.insert( notSniperRouteList, route)
        end
      end



      local normalRouteSoldierNum = sortieSolderNum - addSniperRouteNum
      for j = 1, normalRouteSoldierNum do
        if #notSniperRouteList == 0 then
          break
        end

        local routeIndex = 1
        if j > 6 then
          routeIndex = math.random(1,#notSniperRouteList)
        end

        local routeName = notSniperRouteList[routeIndex]
        if DEBUG and not Tpp.IsTypeString(routeName) then
          Fox.Error("route is invalid.")
        end
        table.remove(notSniperRouteList, routeIndex)
        mvars.mbSoldier_useRouteList[StrCode32(routeName)] = true
        table.insert( retRouteList, routeName )
        Fox.Log("plntName:" ..tostring(plntName) .. " :insert routeName : " .. tostring(routeName) )
      end
    else
      Fox.Warning( "TppEnemy.GetPrioritizedRouteTable(): There is no group! cpGameObjectId:" .. tostring(cpGameObjectId) .. ", plntName:" .. tostring(plntName) )
    end
  end
  return retRouteList
end
--CALLERS: InitEnemy, UpdateEnableSoldier < f30050_sequence.SetupStaffList
mtbs_enemy.SetDisableSoldierUserSettings = function()
  if not mvars.mbSoldier_enableSoldierLocatorList then
    mvars.mbSoldier_enableSoldierLocatorList = {}
  end
  mvars.mbSoldier_enableSoldierLocatorList[mvars.mbSoldier_currentClusterId] = {}
  local enableSoldierCount = 0
  local maxSolNum = 100--LIMIT tex NMC a bit magic numbery being burried here in the function tex TODO: see if this plays nice with ih additional soldiers
  local staffIdIndex = 1
  local staffIdList = mtbs_enemy.GetSecurityStaffIdList( mvars.mbSoldier_currentClusterId )
  if staffIdList then
    maxSolNum = #staffIdList
    if TppEnemy.DEBUG_o50050_memoryDump then
      if maxSolNum == 0 then
        maxSolNum = 100
        Fox.Log("staff Id List is empty!")
      end
    end
  end

  for priority, plntName in ipairs( mtbs_enemy.plntNameDefine ) do
    local plntTable = mtbs_enemy.plntParamTable[plntName]
    local plntAssetsTable = plntTable.assets
    local solNum = 0
    local GetSolNum = function(plntName)
      local listNum = #mtbs_enemy.plntParamTable[plntName].assets.soldierList
      local maxNum = listNum
      if mtbs_enemy.useUiSetting then
        maxNum = TppMotherBaseManagement.GetMbsPlatformSecuritySoldierNum{ platform = plntTable.plntDefine }
      end
      if maxNum > listNum then
        return listNum
      else
        return maxNum
      end
    end
    solNum, enableSoldierCount = mtbs_enemy._GetNumOnPlnt(GetSolNum, plntName, enableSoldierCount, maxSolNum)

    for i , soldierName in ipairs(plntAssetsTable.soldierList) do
      if i>solNum then
        mtbs_enemy.SetDisableSoldier( soldierName )
      else
        if staffIdList then
          local staffId = staffIdList[staffIdIndex]
          local gameObjectId = GetGameObjectId("TppSoldier2", soldierName)
          mtbs_enemy.SetStaffAbirity( staffId , gameObjectId )
        end
        table.insert(mvars.mbSoldier_enableSoldierLocatorList[mvars.mbSoldier_currentClusterId], soldierName)
        staffIdIndex = staffIdIndex + 1
      end
    end
  end
end



mtbs_enemy.SetupLayoutSetting = function( clusterId )
  mtbs_enemy._SetAssetsTable(clusterId)
  if not mtbs_enemy.cpNameDefine then
    Fox.Error( "Cp is nil. please set!" )
    return
  end


  mtbs_enemy.soldierDefine[mtbs_enemy.cpNameDefine] = {}



  mtbs_enemy.combatSetting[mtbs_enemy.cpNameDefine] =
    {




      mtbs_enemy.plnt0_gtNameDefine,
      mtbs_enemy.plnt0_cbtSetNameDefine,
      mtbs_enemy.plnt1_gtNameDefine,
      mtbs_enemy.plnt1_cbtSetNameDefine,
      mtbs_enemy.plnt2_gtNameDefine,
      mtbs_enemy.plnt2_cbtSetNameDefine,
      mtbs_enemy.plnt3_gtNameDefine,
      mtbs_enemy.plnt3_cbtSetNameDefine,
    }

  mtbs_enemy.routeSets[mtbs_enemy.cpNameDefine] =
    {



      priority = mtbs_enemy.plntNameDefine,
      fixedShiftChangeGroup = { "plnt0","plnt1","plnt2","plnt3" },

      sneak_day = {
        plnt0 = {},
        plnt1 = {},
        plnt2 = {},
        plnt3 = {},
      },
      sneak_night= {
        plnt0 = {},
        plnt1 = {},
        plnt2 = {},
        plnt3 = {},
      },
      caution = {
        plnt0 = {},
        plnt1 = {},
        plnt2 = {},
        plnt3 = {},
      },
    }



  local routeSetCp = mtbs_enemy.routeSets[mtbs_enemy.cpNameDefine]
  for _, plntName in pairs( mtbs_enemy.routeSets[mtbs_enemy.cpNameDefine].priority ) do
    local plntRouteSets = mtbs_enemy.routeSets[mtbs_enemy.cpNameDefine]
    local plntAssets = mtbs_enemy.plntParamTable[plntName].assets
    if plntAssets then
      for _, devRouteSets in ipairs( plntAssets.soldierRouteList.Sneak ) do
        for __, routeName in ipairs( devRouteSets.inPlnt ) do

          table.insert( plntRouteSets.sneak_day[plntName],routeName)
        end
        if DEBUG then
          for __, routeName in ipairs( devRouteSets.inPlnt ) do
            mvars.DEBUG_MbEnemy_routeName[StrCode32(routeName)] = routeName
          end
          for __, routeName in ipairs( devRouteSets.outPlnt ) do
            mvars.DEBUG_MbEnemy_routeName[StrCode32(routeName)] = routeName
          end
        end
      end
      for _, devRouteSets in ipairs( plntAssets.soldierRouteList.Night ) do
        for __, routeName in ipairs( devRouteSets.inPlnt ) do
          table.insert( plntRouteSets.sneak_night[plntName], routeName )
        end
        if DEBUG then
          for __, routeName in ipairs( devRouteSets.inPlnt ) do
            mvars.DEBUG_MbEnemy_routeName[StrCode32(routeName)] = routeName
          end
          for __, routeName in ipairs( devRouteSets.outPlnt ) do
            mvars.DEBUG_MbEnemy_routeName[StrCode32(routeName)] = routeName
          end
        end
      end
      for _, devRouteSets in ipairs( plntAssets.soldierRouteList.Caution ) do
        for __, routeName in ipairs( devRouteSets.inPlnt ) do

          table.insert( plntRouteSets.caution[plntName], routeName )
        end
        for __, routeName in ipairs( devRouteSets.outPlnt ) do
          table.insert( plntRouteSets.caution[plntName], routeName )
        end

        if DEBUG then
          for __, routeName in ipairs( devRouteSets.inPlnt ) do
            mvars.DEBUG_MbEnemy_routeName[StrCode32(routeName)] = routeName
          end
          for __, routeName in ipairs( devRouteSets.outPlnt ) do
            mvars.DEBUG_MbEnemy_routeName[StrCode32(routeName)] = routeName
          end
        end
      end


      for _, soldierName in ipairs( plntAssets.soldierList ) do
        
        table.insert( mtbs_enemy.soldierDefine[mtbs_enemy.cpNameDefine], soldierName )
        mtbs_enemy.soldierNameToCpName[soldierName] = mtbs_enemy.cpNameDefine
      end
    end
  end


  mvars.mbSoldier_strCodeToStr = {}
  for _, plntName in ipairs( mtbs_enemy.plntNameDefine ) do
    mvars.mbSoldier_strCodeToStr[StrCode32(plntName)] = plntName
  end

  mtbs_enemy.soldierSubTypes = {

      DD_FOB = {
        mtbs_enemy.soldierDefine[mtbs_enemy.cpNameDefine],
      },
  }

end




mtbs_enemy.SetEnemyLocationType = function ()
  Fox.Log("#### mtbs_enemy.SetEnemyLocationType ####")


  if EnemyType ~= nil then
    local gameObjectId = { type="TppSoldier2" }

    --tex> the helmet model that pops off seems to be in-engine coded to soldier type (and also requires the relevant fpk),
    --even though I override soldier type during soldier setup it's somewhere after this set command and there
    --it also controls language, so bypassing it to keep soldier salute callouts
    --GOTCHA seems a one type deal, so cant take female into account.
    if IvarProc.EnabledForMission"customSoldierType" then
      local bodyInfo=InfEneFova.GetMaleBodyInfo()
      local soldierType=EnemyType.TYPE_DD
      if bodyInfo and bodyInfo.soldierSubType and InfMainTpp.IsMbEvent() then
        soldierType=InfMainTpp.soldierTypeForSubtypes[bodyInfo.soldierSubType]
      end
      local command = { id = "SetSoldier2Type", type = soldierType }
      SendCommand( gameObjectId, command )
      --<
    else
      local command = { id = "SetSoldier2Type", type = EnemyType.TYPE_DD }
      SendCommand( gameObjectId, command )
    end


  end

  if CpType ~= nil then
    local gameObjectId = { type="TppCommandPost2" }
    local command = { id = "SetCpType", type = CpType.TYPE_AMERICA }
    SendCommand( gameObjectId, command )
  end
end





mtbs_enemy.SetUseUiSettings = function( flag )
  mtbs_enemy.useUiSetting = flag
end











mtbs_enemy.GetSoldierForQuest = function( clusterName, plntName, num )
  local clusterId = mtbs_cluster.GetClusterId( clusterName )
  mtbs_enemy._SetAssetsTable(clusterId)
  local plntSoldierList = mtbs_enemy.plntParamTable[plntName].assets.soldierList
  local enableSoldierList = mvars.mbSoldier_enableSoldierLocatorList[clusterId]
  if not num or num<1 then
    num = 1
  end
  local soldierList = {}
  for i,soldierName in ipairs(plntSoldierList) do
    for _,enableSoldierName in ipairs( enableSoldierList ) do
      if enableSoldierName == soldierName then
        table.insert( soldierList, soldierName )
        break
      end
    end
    if num == #soldierList then
      break
    end
  end
  return soldierList
end







mtbs_enemy.GetSoldierForSalutation = function( clusterName, plntName, num )
  local clusterId = mtbs_cluster.GetClusterId( clusterName )
  mtbs_enemy._SetAssetsTable(clusterId)
  local refSoldierList = mtbs_enemy.plntParamTable[plntName].assets.soldierList
  return refSoldierList
end







mtbs_enemy.SetSecurityStaffIdList = function( clusterId, staffIdList )
  if not mvars.mbSoldier_MB_staffIdList then
    mvars.mbSoldier_MB_staffIdList = {}
  end
  mvars.mbSoldier_placedCountTotal = 0

  mvars.mbSoldier_MB_staffIdList[clusterId] = staffIdList
  mvars.mbSoldier_placedCountTotal = #staffIdList--NMC not actually accurate, would only be the count of the cluster SetSecurityStaffIdList is last called with, o50050 where it's used overrides it though and as that only uses one cluster its not an issue there

end

mtbs_enemy.GetSecurityStaffIdList = function( clusterId )
  if mvars.mbSoldier_MB_staffIdList then
    return mvars.mbSoldier_MB_staffIdList[clusterId]
  end
  return nil
end


mtbs_enemy.InitEnemy = function ( clusterId )
  if not mtbs_enemy.cpNameDefine then
    Fox.Error( "Cp is nil. please set!" )
    return
  end
  mvars.mbEnemy_initializedEnemy = true

  mtbs_enemy.InitDevelopGradeTable()

  mtbs_enemy.InitSecurityNumTableFromRank()


  mtbs_enemy._SetAssetsTable(clusterId)
  mtbs_enemy.SetDisableSoldierUserSettings( )
end

function mtbs_enemy.UpdateEnableSoldier(clusterId)

  mtbs_enemy._SetAssetsTable(clusterId)
  mtbs_enemy.SetDisableSoldierUserSettings( )
end




mtbs_enemy.SetupEnemy = function ( clusterId )
  if not mtbs_enemy.cpNameDefine then
    Fox.Error( "Cp is nil. please set! : clusterId: " .. tostring(clusterId) )
    return 0
  end


  mtbs_enemy.SetEnemyLocationType()

  TppEnemy.RegisterCombatSetting( mtbs_enemy.combatSetting )

  mtbs_enemy._SetAssetsTable(clusterId)


  if TppEnemy.IsSpecialEventFOB() then--RETAILPATCH: 1070
    mvars.mbSecCam_placedCountTotal = 0
    mvars.mbUav_placedCountTotal = 0
  else--<

    mtbs_enemy.SetupSecurityCamera()

    mtbs_enemy.SetupUAV()
  end


  mtbs_enemy.SetupDecy()
  mtbs_enemy.SetupMine()

  local sortieSoldierNum = mtbs_enemy.SetupSortieSoldiers( clusterId)

  mtbs_enemy.SetupFocusArea()

  mtbs_enemy.SetupEmblem()

  return sortieSoldierNum
end


mtbs_enemy.OnLoad = function ( clusterId, isNoUseRevenge )
  if DEBUG and (not mvars.DEBUG_MbEnemy_routeName) then
    mvars.DEBUG_MbEnemy_routeName = {}
  end

  Fox.Log("*** mtbs_enemy onload ***")
  if TppEnemy.GetMBEnemyAssetTable then
    mvars.mbSoldier_funcGetAssetTable = TppEnemy.GetMBEnemyAssetTable
  elseif mvars.mbSoldier_funcGetAssetTable then
    TppEnemy.GetMBEnemyAssetTable = mvars.mbSoldier_funcGetAssetTable
  end
  mvars.mbSoldier_currentClusterId = nil
  mvars.mbEnemyDisableSoldierList = {}

  mtbs_enemy.SetupLayoutSetting( clusterId )

  if not isNoUseRevenge then

    local grade = InfMainTpp.GetMbsClusterSecuritySoldierEquipGrade()--tex ORIG: TppMotherBaseManagement.GetMbsClusterSecuritySoldierEquipGrade()
    local range = InfMainTpp.GetMbsClusterSecuritySoldierEquipRange()--ORIG: TppMotherBaseManagement.GetMbsClusterSecuritySoldierEquipRange()
    local isNoKill = InfMainTpp.GetMbsClusterSecurityIsNoKillMode()--tex ORIG: TppMotherBaseManagement.GetMbsClusterSecurityIsNoKillMode()

    local revengeType = mtbs_enemy._GetEquipTable( grade, range, isNoKill )
    TppRevenge.SetForceRevengeType( revengeType )
  end


  mvars.rad_debugRadioLineTable["DBG_MTBS_ENEMY_FOCUS_CHECK"] = {"各員、特別警戒。所定の位置を防衛せよ"}
end




mtbs_enemy.StartCheckFocusArea = function( clusterId )

  --RETAILPATCH 1090>
	mvars.mbSoldier_focusArea_solList = {}
	mvars.mbSoldier_focusArea_routeNameList = {}
  --^

  local needCpRadio = false

  mtbs_enemy._SetAssetsTable( clusterId )
  for _, plntName in ipairs( mtbs_enemy.plntNameDefine ) do
    if mtbs_enemy._SetFocusAreaInPlnt( plntName ) then
      needCpRadio = true
    end
  end



  if needCpRadio then
    local gameObjectId = { type="TppCommandPost2", index=0 }
    local command = { id = "RequestRadio", label="CPR0570FOB" }
    GameObject.SendCommand( gameObjectId, command )
		
		--RETAILPATCH 1090>
		GkEventTimerManager.Start(TIMER_NAME_SWITCH_ROUTE_FOCUS_AREA,0.1)
    --^
  end
end





mtbs_enemy._SetFocusAreaInPlnt = function( plntName )
  local isSwitchRoute = false
  local focusAreaList = mvars.mbSoldier_focusArea[plntName]
  if not focusAreaList or #focusAreaList == 0 then
    return isSwitchRoute
  end
  local curentFocusArea = mvars.mbSoldier_currentFocusArea[plntName]

  local plntTable = mtbs_enemy.plntParamTable[plntName]
  local plntAsset = plntTable.assets
  if plntAsset and plntAsset.soldierList then
    local cpId = GetGameObjectId( mtbs_enemy.cpNameDefine )
    local routeList = mtbs_enemy._GetRouteSetList( cpId, plntName )
    local plntSolList = mtbs_enemy._GetSolListEquipSort( plntAsset.soldierList, routeList )
    local solIndex = 1

    local areaIndex = curentFocusArea + 1
    if areaIndex > #focusAreaList then
      areaIndex = 1
    end
    mvars.mbSoldier_currentFocusArea[plntName] = areaIndex

    local focusAreaRouteList = plntAsset.soldierRouteList.FocusArea[focusAreaList[areaIndex]]
    if not focusAreaRouteList then
      return
    end

    for _, routeName in ipairs( focusAreaRouteList ) do
			while( plntSolList[solIndex] ) do
				local gameObjectId = plntSolList[solIndex]
				solIndex = solIndex + 1
				if not TppEnemy.IsEliminated(gameObjectId) then
					
					local command = { id = "SwitchRoute", route = "" }
					SendCommand( gameObjectId, command )
					
					table.insert(mvars.mbSoldier_focusArea_solList, gameObjectId )
					table.insert(mvars.mbSoldier_focusArea_routeNameList, routeName )
					isSwitchRoute = true
					break
				end
			end
      --RETAILPATCH 1090 from ^>
      --[[ local gameObjectId = plntSolList[solIndex]
      if not gameObjectId then
        return
      end
      if not TppEnemy.IsEliminated(gameObjectId) then
        local command = { id = "SwitchRoute", route = routeName }
        SendCommand( gameObjectId, command )
        Fox.Log("Switch Route sol: " ..tostring(gameObjectId) )
        Fox.Log("Switch Route route: " ..tostring(routeName) )
        isSwitchRoute = true
      end
      solIndex = solIndex + 1 ]]
      --^
    end
  end
  return isSwitchRoute
end







mtbs_enemy._GetSolListEquipSort = function( solList, routeSets )

  local shortRangeSol = {}
  local middleRangeSol = {}
  local farRangeSol = {}

  local solGameObjectId = { type="TppSoldier2" }
  for _, devRouteList in ipairs(routeSets) do
    for __, inoutRouteList in pairs( devRouteList ) do
      --for ___, routeName in pairs(inoutRouteList) do
      --RETAILPATCH from ^>
			for ___, routeNameOrTable in pairs(inoutRouteList) do
				local routeName
				if Tpp.IsTypeTable(routeNameOrTable) then
					routeName = routeNameOrTable[1] 
				else 
					routeName = routeNameOrTable
				end			
        --^
			
        local command = { id="GetGameObjectIdUsingRoute", route=routeName }
        local soldiers = SendCommand( solGameObjectId, command )
        for _, gameObjectId in ipairs( soldiers ) do
          local insertTable = nil
          if TppEnemy.IsSniper( gameObjectId ) then
            insertTable = farRangeSol
          elseif TppEnemy.IsMissile( gameObjectId ) then
            insertTable = farRangeSol
          else
            insertTable = shortRangeSol
          end
          table.insert( insertTable, gameObjectId )
        end
      end
    end
  end

  local ApendArray = function( outArray, inArray )
    local maxArray = #inArray
    for i = 1, maxArray do
      local index = math.random(1, #inArray)
      table.insert(outArray, inArray[index])
      table.remove(inArray, index)
    end
  end

  local outList = {}
  ApendArray( outList, shortRangeSol )
  ApendArray( outList, middleRangeSol )
  ApendArray( outList, farRangeSol )
  return outList
end




mtbs_enemy._SetAssetsTable = function( clusterId )
  if mvars.mbSoldier_currentClusterId and mvars.mbSoldier_currentClusterId == clusterId then
    return
  end
  mvars.mbSoldier_currentClusterId = clusterId

  mtbs_enemy._SetClusterParam(clusterId)

  if mvars.mbSoldier_funcGetAssetTable then
    local clasterAssetTable = mvars.mbSoldier_funcGetAssetTable( clusterId )
    if clasterAssetTable then
      for _, plntName in ipairs( mtbs_enemy.plntNameDefine ) do
        mtbs_enemy.plntParamTable[plntName].assets = clasterAssetTable[plntName]
      end
    end
  end
end






mtbs_enemy._SetClusterParam = function( clusterId )
  if mvars.mbSoldier_clusterParamList and mvars.mbSoldier_clusterParamList[clusterId] then
    local clusterParam = mvars.mbSoldier_clusterParamList[clusterId]
    mtbs_enemy.cpNameDefine = clusterParam.CP_NAME
    mtbs_enemy.gtNameDefine = clusterParam.GT_NAME
    mtbs_enemy.cbtSetNameDefine = clusterParam.CBTSET_NAME

    mtbs_enemy.plnt0_gtNameDefine = clusterParam.GT_NAME_00
    mtbs_enemy.plnt0_cbtSetNameDefine = clusterParam.CBTSET_NAME_00
    mtbs_enemy.plnt1_gtNameDefine = clusterParam.GT_NAME_01
    mtbs_enemy.plnt1_cbtSetNameDefine = clusterParam.CBTSET_NAME_01
    mtbs_enemy.plnt2_gtNameDefine = clusterParam.GT_NAME_02
    mtbs_enemy.plnt2_cbtSetNameDefine = clusterParam.CBTSET_NAME_02
    mtbs_enemy.plnt3_gtNameDefine = clusterParam.GT_NAME_03
    mtbs_enemy.plnt3_cbtSetNameDefine = clusterParam.CBTSET_NAME_03
    mtbs_enemy.cpNameToClsterIdList[mtbs_enemy.cpNameDefine] = clusterId
  else
    Fox.Error("cluster param cannot set: clusterId:" ..tostring(clusterId) )
  end
end




mtbs_enemy._GetNumOnPlnt = function( funcGetNumOnPlntFromMtb, plntName, numPlaced, numMax )
  local numOnPlnt = 0
  if mtbs_enemy._HasPlatform(plntName) then
    numOnPlnt = funcGetNumOnPlntFromMtb(plntName)
  end
  if (numPlaced + numOnPlnt) > numMax then
    numOnPlnt = numMax - numPlaced
    numPlaced = numMax
  else
    numPlaced = numPlaced + numOnPlnt
  end
  return numOnPlnt, numPlaced
end




mtbs_enemy._HasPlatform = function( plntName )
  for priority, name in ipairs( mtbs_enemy.plntNameDefine ) do
    if name == plntName then
      local clusterConstruct = mtbs_cluster.GetClusterConstruct( mvars.mbSoldier_currentClusterId )
      Fox.Log( tostring(plntName) .. " PlntNum : " .. tostring(clusterConstruct) )
      return priority <= clusterConstruct
    end
  end
  return false
end




mtbs_enemy._FOB_RemoveEnemy = function( gameObjectId )
  if Tpp.IsSoldier( gameObjectId ) then
    local cpName = mtbs_enemy._GetCpNameFromSoldierId(gameObjectId)
    mtbs_enemy._ChangeAssetsFromCpName(cpName)
    if not mtbs_enemy.routeSets[mtbs_enemy.cpNameDefine] then
      return
    end
    for categoryName, routeSets in pairs( mtbs_enemy.routeSets[mtbs_enemy.cpNameDefine] ) do
      for plntName, routeSet in pairs( routeSets ) do
        if Tpp.IsTypeTable(routeSet) then
          for _, routeName in pairs( routeSet ) do
            local objId = { type="TppSoldier2" }
            local command = { id="GetGameObjectIdUsingRoute", route=routeName }
            local soldiers = SendCommand( objId, command )
            for __, soldier in ipairs(soldiers) do
              if gameObjectId == soldier then
                mvars.mbSoldier_useRouteList[StrCode32(routeName)] = nil
              end
            end
          end
        end
      end
    end

    TppEnemy.UnsetSneakRoute(gameObjectId)
    TppEnemy.UnsetCautionRoute(gameObjectId)
  end
end




mtbs_enemy._GetMineNumOnPlnt = function( plntName )
  local plntTable = mtbs_enemy.plntParamTable[plntName]
  local listNum = #plntTable.assets.mineList
  local maxNum = listNum
  if mtbs_enemy.useUiSetting then
    maxNum = TppMotherBaseManagement.GetMbsPlatformSecurityMineNum{ platform=plntTable.plntDefine }
    Fox.Log("MineNumUiSetting:"..tostring(plntTable.plntDefine) .. ":num:"..tostring(maxNum) )
  end
  if (maxNum > listNum) then
    return listNum
  else
    return maxNum
  end
end




mtbs_enemy._GetDecyNumOnPlnt = function( plntName )
  local plntTable = mtbs_enemy.plntParamTable[plntName]
  local listNum = #plntTable.assets.decyList
  local maxNum = listNum
  if mtbs_enemy.useUiSetting then
    maxNum = TppMotherBaseManagement.GetMbsPlatformSecurityDecoyNum{ platform=plntTable.plntDefine }
    Fox.Log("DecoyNumUiSetting:"..tostring(plntTable.plntDefine) .. ":num:"..tostring(maxNum) )
  end
  if (maxNum > listNum) then
    return listNum
  else
    return maxNum
  end
end




mtbs_enemy._GetSecurityCameraNumOnPlnt = function( plntName )
  local plntTable = mtbs_enemy.plntParamTable[plntName]
  local listNum = #plntTable.assets.securityCameraList
  local maxNum = listNum
  if mtbs_enemy.useUiSetting then
    maxNum = TppMotherBaseManagement.GetMbsPlatformSecurityCameraNum{ platform=plntTable.plntDefine }
    Fox.Log("CameraNumUiSetting:"..tostring(plntTable.plntDefine) .. ":num:"..tostring(maxNum) )
  end
  if maxNum > listNum then
    return listNum
  else
    return maxNum
  end
end




mtbs_enemy._GetUavNumOnPlnt = function( plntName )
  local plntTable = mtbs_enemy.plntParamTable[plntName]
  local listNum = #plntTable.assets.uavList
  local maxNum = listNum
  if mtbs_enemy.useUiSetting then
    maxNum = TppMotherBaseManagement.GetMbsPlatformSecurityUavNum{ platform=plntTable.plntDefine }
  end
  if maxNum > listNum then
    return listNum
  else
    return maxNum
  end
end






mtbs_enemy._GetUavSetting = function()

  return TppEneFova.GetUavSetting()
end





mtbs_enemy._GetRouteNameNextDivision = function( plntName, devIndex, routeType )
  local routeTable = mtbs_enemy.plntParamTable[plntName].assets.soldierRouteList[routeType]
  local nextDevIndex = devIndex+1
  if not routeTable[nextDevIndex] then
    nextDevIndex = 1
  end
  local routeSets = routeTable[nextDevIndex]

  local freeRouteList = {}

  local InsertFreeRouteList = function( routeSets, freeRouteList )
    for _, routeName in ipairs(routeSets) do

      if Tpp.IsTypeString( routeName )
        and not mvars.mbSoldier_useRouteList[StrCode32(routeName)] then
        table.insert( freeRouteList, routeName )
      end
    end
  end
  InsertFreeRouteList( routeSets.inPlnt, freeRouteList )
  InsertFreeRouteList( routeSets.outPlnt, freeRouteList )

  if #freeRouteList == 0 then
    Fox.Log("All Route Used. plnt: " .. tostring(plntName) .. " dev: " .. tostring(devIndex) )
    return nil
  end
  return freeRouteList[math.random(1,#freeRouteList)]
end







mtbs_enemy._GetRouteGroupName = function( cpId, routeId )
  local hasSameRoute = function( routeSets, routeId )
    for _, routeName in pairs( routeSets ) do
      if StrCode32(routeName) == routeId then
        return true
      end
    end
    return false
  end

  for _, plntName in pairs( mtbs_enemy.plntNameDefine ) do
    local searchRouteSets, routeType = mtbs_enemy._GetRouteSetList( cpId, plntName )
    for i, devRouteSets in ipairs( searchRouteSets ) do
      if hasSameRoute( devRouteSets.inPlnt, routeId ) or
        hasSameRoute( devRouteSets.outPlnt, routeId ) then
        return plntName, i, routeType
      end
    end
  end

  do
    local cpName = mvars.ene_cpList[cpId]
    local routeName
    if DEBUG then
      routeName = mvars.DEBUG_MbEnemy_routeName[routeId]
    end
    if routeName == nil then
      routeName = routeId
    end
    Fox.Warning("Not found routeId :[cp:  " ..tostring(cpName) .. "] [route:" .. tostring(routeName) .. "]" )
  end

  return nil
end






mtbs_enemy._GetRouteSetList = function( cpId, plntName, sysPhase )
  local routesetType = "route_sneak_day"
  local phase = TppEnemy.GetPhaseByCPID( cpId )
  if sysPhase == StrCode32("SYS_Sneak") then
    phase = TppEnemy.PHASE.SNEAK
  elseif sysPhase == StrCode32("SYS_Caution") then
    phase = TppEnemy.PHASE.CAUTION
  end

  local searchRouteSets = {}
  local plntRouteList = mtbs_enemy.plntParamTable[plntName].assets.soldierRouteList
  if phase == TppEnemy.PHASE.SNEAK then
    local timeOfDay = TppClock.GetTimeOfDay()
    if timeOfDay == "day" then
      searchRouteSets = plntRouteList.Sneak
      routesetType = "Sneak"
    else
      searchRouteSets = plntRouteList.Night
      routesetType = "Night"
    end
  elseif phase == TppEnemy.PHASE.CAUTION then
    searchRouteSets = plntRouteList.Caution
    routesetType = "Caution"
  end
  return searchRouteSets, routesetType
end





mtbs_enemy._GetEquipTable = function( grade, range, isNoKill )
  local gradeIndex = grade
  local rangeIndex = mtbs_enemy._GetArrayIndexFromDefine(range)
  local rangeTable = { "FOB_ShortRange", "FOB_MiddleRange", "FOB_LongRange", }

  local equipTable = {}
  table.insert( equipTable, "FOB_EquipGrade_"..gradeIndex )
  table.insert( equipTable, rangeTable[ rangeIndex ] )
  if isNoKill then
    table.insert( equipTable, "FOB_NoKill" )
    Fox.Log( "Grade:"..equipTable[1].." Range:"..equipTable[2].." isNoKillMode" )
  else
    Fox.Log( "Grade:"..equipTable[1].." Range:"..equipTable[2] )
  end
  return equipTable
end




mtbs_enemy._GetSoldierNumOnPlatformFromUiSetting = function( plntName )
  local solNumTable = mtbs_enemy.plntParamTable[plntName]
  return TppMotherBaseManagement.GetMbsPlatformSecuritySoldierNum{ platform= solNumTable.plntDefine }
end


mtbs_enemy._GetArrayIndexFromDefine = function( quantityDefine )
  return quantityDefine + 1
end

mtbs_enemy._GetMineEquipId = function(isNoKillMode, equipGrade)

  if not TppGameSequence.IsMaster() then
    if TppEnemy.DEBUG_o50050_memoryDump then
      return TppEquip.EQP_SWP_SleepingGusMine_G02
    end
  end

  local mineType = DMINE_INDEX
  if isNoKillMode then
    mineType = SLEEPING_MINE_INDEX
  end
  for i = equipGrade, 1, -1 do
    local equipId = mvars.mbEnemy_mineEquipIdListSortByEquipGrade[mineType][i]
    if equipId then
      return equipId
    end
  end

  return nil
end


mtbs_enemy._GetDecyEquipId = function(equipGrade)

  if not TppGameSequence.IsMaster() then
    if TppEnemy.DEBUG_o50050_memoryDump then
      return TppEquip.EQP_SWP_ShockDecoy_G02
    end
  end


  for i = equipGrade, 1, -1 do
    for _,equipIdList in ipairs(mvars.mbEnemy_decyEquipIdList) do
      local equipId = equipIdList[i]
      if equipId then
        return equipId
      end
    end
  end

  return nil
end




mtbs_enemy._GetCpNameFromSoldierId = function( soldierGameObjectId )
  for cpName, soldierList in pairs( mtbs_enemy.soldierDefine ) do
    for _, soldierName in ipairs( soldierList ) do
      local gameObjectId = GetGameObjectId(soldierName)
      if gameObjectId == soldierGameObjectId then
        return cpName
      end
    end
  end
end

mtbs_enemy._ChangeAssetsFromCpName = function( cpName )
  local clusterId = mtbs_enemy.cpNameToClsterIdList[cpName]
  if clusterId then
    mtbs_enemy._SetAssetsTable(clusterId)
  end
end




mtbs_enemy.SetStaffAbirity = function( staffId, gameObjectId )
  local abirityRank = mtbs_enemy.SoldierCombatAbirityRank[TppMotherBaseManagement.GetMbsStaffCombatRank{ staffId = staffId }]
  local commandAvirity = { id = "SetPersonalAbility", ability=mtbs_enemy.SoldierCombatAbirity[abirityRank] }
  SendCommand( gameObjectId, commandAvirity )
  if DEBUG then
    Fox.Log("avirity: " ..tostring(abirityRank) )
  end
end


function mtbs_enemy.SetStaffId( gameObjectId , staffId )
  local command = { id = "SetStaffId", staffId = staffId }
  SendCommand( gameObjectId, command )
end

function mtbs_enemy.GetSortieSniperNumInPlnt( clusterId, plntName )
  local plntTable = mtbs_enemy.plntParamTable[plntName]
  local sniperCount = 0
  for _, soldierName in ipairs( plntTable.assets.soldierList ) do
    if mtbs_enemy._IsSortieSoldier( clusterId, soldierName ) then
      local gameObjectId = GetGameObjectId(soldierName)
      if TppEnemy.IsSniper( gameObjectId ) then
        sniperCount = sniperCount + 1
      end
    end
  end
  return sniperCount
end


function mtbs_enemy._IsSortieSoldier( clusterId, soldierName )
  if mvars.mbSoldier_enableSoldierLocatorList and mvars.mbSoldier_enableSoldierLocatorList[clusterId] then
    for _, sortieSolName in ipairs(mvars.mbSoldier_enableSoldierLocatorList[clusterId]) do
      if sortieSolName == soldierName then
        return true
      end
    end
  end
  return false
end



mtbs_enemy.Messages = function()
  return
    Tpp.StrCode32Table{
		--RETAILPATCH 1090>
		Timer = {
			{
				msg = "Finish",
				sender = TIMER_NAME_SWITCH_ROUTE_FOCUS_AREA,
				func = function()
					GkEventTimerManager.Stop(TIMER_NAME_SWITCH_ROUTE_FOCUS_AREA)
					for i, gameObjectId in ipairs( mvars.mbSoldier_focusArea_solList ) do
						local routeName = mvars.mbSoldier_focusArea_routeNameList[i]
						local command = { id = "SwitchRoute", route = routeName }
						SendCommand( gameObjectId, command )
						if ( Tpp.IsQARelease() or DEBUG ) then
							if mvars.fobDebug and mvars.fobDebug.showImportantRoute then
								local pos = SendCommand(gameObjectId, { id="GetPosition" })
								GrxDebug.Print3D{
									life = 60*30,
									pos = pos,
									size = 24,
									color = Color(1,1,1,1),
									args={ tostring(routeName) } }
							end
						end
						Fox.Log("Switch Route sol: " ..tostring(gameObjectId) )
						Fox.Log("Switch Route route: " ..tostring(routeName) )
					end
				end,
			}
		},
      --^
		GameObject = {
        {
          msg = "RoutePoint2",
          func = function(gameObjectId, routeId, routeNode, message)
            if message == StrCode32("FOBRouteChange") then
              if not TppMission.IsFOBMission(vars.missionCode) then
                return
              end
              if mvars.mbSoldier_PermitRouteChange == true then
                if math.random(0,99) < mtbs_enemy.routeChangeProbability then
                  local cpName = mtbs_enemy._GetCpNameFromSoldierId(gameObjectId)
                  mtbs_enemy._ChangeAssetsFromCpName(cpName)

                  local cpId = GetGameObjectId( cpName )
                  local plntName, devIndex, routeType = mtbs_enemy._GetRouteGroupName( cpId, routeId )
                  if not plntName then
                    return
                  end
                  local nextRouteName = mtbs_enemy._GetRouteNameNextDivision( plntName, devIndex, routeType )
                  if not nextRouteName then
                    return
                  end
                  mvars.mbSoldier_useRouteList[StrCode32(nextRouteName)] = true
                  mvars.mbSoldier_useRouteList[routeId] = nil

                  local command = { id = "SwitchRoute", route = nextRouteName }
                  SendCommand( gameObjectId, command )
                end
              end
            elseif message == StrCode32("FOBSwitchEnd") then
              local command = { id = "SwitchRoute", route = "" }
              SendCommand( gameObjectId, command )
            end
          end
        },
        {
          msg = "Dead",
          func = mtbs_enemy._FOB_RemoveEnemy,
        },
        {
          msg = "Fulton",
          func = mtbs_enemy._FOB_RemoveEnemy,
        },
      },
    }
end


mtbs_enemy.OnInitialize = function( subScripts )
  mtbs_enemy.messageExecTable = Tpp.MakeMessageExecTable( mtbs_enemy.Messages() )
end

mtbs_enemy.OnReload = function( subScripts )
  mtbs_enemy.messageExecTable = Tpp.MakeMessageExecTable( mtbs_enemy.Messages() )
end

mtbs_enemy.OnMessage = function( sender, messageId, arg0, arg1, arg2, arg3, strLogText )
  Tpp.DoMessage( mtbs_enemy.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText )
end






mtbs_enemy.OnAllocateDemoBlock = function()
  InfCore.LogFlow("mtbs_enemy.OnAllocateDemoBlock:")--tex DEBUG
  if not mvars.mbEnemy_initializedEnemy then
    return
  end




  if mvars.f30050demo_fovaPackList == nil then--RETAILPATCH: 1070
    return
  end--<

  if #mvars.f30050demo_fovaPackList == 0 then
    return
  end
  local MAX = EnemyFova.MAX_REALIZED_COUNT
  local bodyTable = {}
  local faceTable = {}

  local faceIdList = {}

  if DEBUG then
    if mvars.f30050_soldierBalaclavaFaceIdList==nil then
      mvars.f30050_soldierBalaclavaFaceIdList = {}
      Fox.Error("LD","mvars.f30050_soldierBalaclavaFaceIdList is nil")
    end
    if mvars.f30050_soldierFaceIdList==nil then
      mvars.f30050_soldierFaceIdList = {}
      Fox.Error("LD","mvars.f30050_soldierFaceIdList is nil")
    end
  end


  for _, faceId in pairs(mvars.f30050_soldierBalaclavaFaceIdList) do
    faceIdList[faceId] = 0
  end

  for _, faceId in pairs(mvars.f30050_soldierFaceIdList) do
    if faceIdList[faceId] == nil then
      faceIdList[faceId] = 1
    else
      faceIdList[faceId] = faceIdList[faceId] + 1
    end
  end
  for faceId, num in pairs( faceIdList ) do
    table.insert( faceTable, { faceId, num } )
  end

  if #mvars.f30050_soldierBalaclavaFaceIdList > 0 then
    local resultList = TppSoldierFace.CheckFemale{ face = mvars.f30050_soldierBalaclavaFaceIdList }
    if resultList ~= nil then
      local maleNum = 0
      local femaleNum = 0
      for index, maleIndex in ipairs( resultList ) do
        if maleIndex == 0 then
          maleNum = maleNum + 1
        elseif maleIndex == 1 then
          femaleNum = femaleNum + 1
        else
          Fox.Error("invalid faceId: " ..tostring(mvars.f30050_soldierFaceIdList[index]) )
        end
      end
      if TppEneFova.IsUseGasMaskInMBFree(mvars.f30050_currentFovaClusterId) then
        if maleNum ~= 0 then
          Tpp.ApendArray( faceTable, {{TppEnemyFaceId.dds_balaclava6, maleNum}}  )
        end
        if femaleNum ~= 0 then
          Tpp.ApendArray( faceTable, {{TppEnemyFaceId.dds_balaclava7, femaleNum}}  )
        end
      else
        if maleNum ~= 0 then
          Tpp.ApendArray( faceTable, {{TppEnemyFaceId.dds_balaclava2, maleNum}}  )
        end
        if femaleNum ~= 0 then
          Tpp.ApendArray( faceTable, {{TppEnemyFaceId.dds_balaclava5, femaleNum}}  )
        end
      end
    else
      Fox.Error("TppSoldierFace.CheckFemale is return nil!")
    end
  end

  TppEnemy.OnAllocateQuest( bodyTable, faceTable )
  Fox.Log("Allocate")
end

mtbs_enemy.OnActivateDemoBlock = function()
  if not mvars.mbEnemy_initializedEnemy then
    return
  end
  if not mvars.f30050_soldierListFovaApplyPriority then
    return
  end

  local clusterId = mvars.f30050_currentFovaClusterId + 1
  mtbs_enemy._SetAssetsTable(clusterId)

  local faceIdList = mvars.f30050_soldierFaceIdListPriority
  local normalFaceSoldierNum = #mvars.f30050_soldierFaceIdList
  local faceIdListIndex = 1
  if InfEneFova.IsCustomSoldierTypeEnabled() then--tex>
    InfMain.RandomSetToLevelSeed()
  end--<
  for _, solName in ipairs( mvars.f30050_soldierListFovaApplyPriority[clusterId] ) do
    local faceId = faceIdList[faceIdListIndex]
    if faceId ~= nil then
      local useBalaclava = false
      for _, balaclavaLocatorName in ipairs( mvars.f30050_soldierBalaclavaLocatorList ) do
        if balaclavaLocatorName == solName then
          useBalaclava = true
          break
        end
      end
      local gameObjectId = GetGameObjectId("TppSoldier2", solName)
      local staffId = mvars.f30050_soldierStaffIdList[faceId]
      if staffId then
        mtbs_enemy.SetStaffId( gameObjectId, staffId )
      end
      TppEneFova.ApplyMTBSUniqueSetting( gameObjectId, faceId, useBalaclava )
    end
    faceIdListIndex = faceIdListIndex + 1
  end
  if InfEneFova.IsCustomSoldierTypeEnabled() then--tex>
    InfMain.RandomResetToOsTime()
  end--<
  mtbs_enemy.SetEnableSoldierInCluster( clusterId, true )
  mvars.mbEnemy_activateClusterIdFova = clusterId
  Fox.Log("Activate: " ..tostring(clusterId))
end

mtbs_enemy.OnDeactivateDemoBlock = function(clusterId)
  if not mvars.mbEnemy_initializedEnemy then
    return
  end
  if not mvars.f30050_soldierListFovaApplyPriority then
    return
  end

  mtbs_enemy._SetAssetsTable(clusterId)
  if InfEneFova.IsCustomSoldierTypeEnabled() then--tex>
    InfMain.RandomSetToLevelSeed()
  end--<
  for _, solName in ipairs( mvars.f30050_soldierListFovaApplyPriority[clusterId] ) do
    TppEneFova.ApplyMTBSUniqueSetting( GetGameObjectId("TppSoldier2", solName), 22, false , false )
  end
  if InfEneFova.IsCustomSoldierTypeEnabled() then--tex>
    InfMain.RandomResetToOsTime()
  end--<
  mtbs_enemy.SetEnableSoldierInCluster( clusterId, false )

  local gameObjectId = { type="TppCorpse" }
  local command = { id = "RequestVanish", all = true }
  GameObject.SendCommand( gameObjectId, command )

  mvars.mbEnemy_activateClusterIdFova = nil
  Fox.Log("Deactivate: " ..tostring(clusterId) )
end

mtbs_enemy.OnTerminateDemoBlock = function()

  if mvars.mbEnemy_activateClusterIdFova then
    Fox.Log("DeactivateSoldiersOnTerminate:clusterId:" ..tostring(mvars.mbEnemy_activateClusterIdFova) )
    mtbs_enemy.SetEnableSoldierInCluster( mvars.mbEnemy_activateClusterIdFova, false )

    local gameObjectId = { type="TppCorpse" }
    local command = { id = "RequestVanish", all = true }
    GameObject.SendCommand( gameObjectId, command )
    mvars.mbEnemy_activateClusterIdFova = nil
  end
  if not mvars.mbEnemy_initializedEnemy then
    return
  end
  local gameObjectId = { type="TppSoldier2" }
  local corpseObjectId = { type="TppCorpse" }
  local command = { id = "FreeExtendFova" }
  GameObject.SendCommand( gameObjectId, command )
  GameObject.SendCommand( corpseObjectId, command )
  TppSoldierFace.ClearExtendFova()
  Fox.Log("OnTerminate")
end




mtbs_enemy.SetFriendly = function( )
  for cpName, soldierNameList in pairs( mtbs_enemy.soldierDefine ) do
    do
      local gameObjectId = GetGameObjectId(cpName)
      if gameObjectId ~= NULL_ID then
        local command = { id = "SetFriendlyCp" }
        SendCommand( gameObjectId, command )
      end
    end
    local command = { id = "SetFriendly" }
    for _, soldierName in pairs( soldierNameList ) do
      local gameObjectId = GetGameObjectId("TppSoldier2", soldierName)
      if gameObjectId ~= NULL_ID then
        SendCommand( gameObjectId, command )
      end
    end
  end
  --tex TODO ivar, if uavs
  --  for _, plntName in ipairs( mtbs_enemy.plntNameDefine ) do
  --
  --    local plntTable = mtbs_enemy.plntParamTable[plntName]
  --    local plntAssetsTable = plntTable.assets
  --
  --    for i, uavName in ipairs( plntAssetsTable.uavList ) do
  --      local gameObjectId = GameObject.GetGameObjectId( uavName )
  --      SendCommand( gameObjectId, {id = "SetFriendly"} )
  --    end
  --  end
end


mtbs_enemy.SetupSoldierListFovaApplyPriority = function( clusterId )
  if mvars.f30050_soldierListFovaApplyPriority == nil then
    mvars.f30050_soldierListFovaApplyPriority = {}
  end
  mvars.f30050_soldierListFovaApplyPriority[clusterId] = {}
  mtbs_enemy._SetAssetsTable(clusterId)
  for _, plntName in ipairs(mtbs_enemy.plntNameDefine) do
    for __, solName in ipairs( mtbs_enemy.plntParamTable[plntName].assets.soldierList ) do
      table.insert( mvars.f30050_soldierListFovaApplyPriority[clusterId], solName )
    end
  end
end









mtbs_enemy.SetSoldierForDemo = function( clusterId, demoSoldirNameList )

  local enableSoldierList = mvars.f30050_soldierListFovaApplyPriority[clusterId]
  local demoSoldierNum = #demoSoldirNameList
  for i = demoSoldierNum, 1, -1 do
    local demoSoldierName = demoSoldirNameList[i]
    for index, soldierName in ipairs( enableSoldierList ) do
      if demoSoldierName == soldierName then
        table.remove( enableSoldierList, index )
        table.insert( enableSoldierList, 1, demoSoldierName )
        break
      end
    end
  end

  local enableLocatorNum = #mvars.mbSoldier_enableSoldierLocatorList[clusterId]
  mvars.mbSoldier_enableSoldierLocatorList[clusterId] = {}
  for i = 1, enableLocatorNum do
    table.insert( mvars.mbSoldier_enableSoldierLocatorList[clusterId], mvars.f30050_soldierListFovaApplyPriority[clusterId][i] )
  end
end

mtbs_enemy.SetForceBalaclavaLocator = function( soldierList )
  mvars.f30050_forceBalaclavaSoldierList = soldierList
end

mtbs_enemy.IsForceBalaclava = function( soldierName )
  if mvars.f30050_forceBalaclavaSoldierList then
    for _, balaclavaSoldierName in ipairs( mvars.f30050_forceBalaclavaSoldierList ) do
      if balaclavaSoldierName == soldierName then
        return true
      end
    end
  end
  return false
end


function mtbs_enemy.RegisterDisableSoldierForQuest(soldierName)
  table.insert( mvars.mbEnemyDisableSoldierList , soldierName )
end
function mtbs_enemy.UnregisterDisableSoldierForQuest(soldierName)
  for index, solName in ipairs( mvars.mbEnemyDisableSoldierList ) do
    if solName == soldierName then
      table.remove( mvars.mbEnemyDisableSoldierList, index )
    end
  end
end

if not TppGameSequence.IsMaster() then

  function mtbs_enemy.SetupSortieSoldierFovaForMemoryDump( clusterId )
    Fox.Log("Setup Fova for memory dump")
    local faceIdList ={
      350,
      363,
      376,
      390,
      450,
      461,
      472,
      500,
      508,
      516,
      10,
      21,
      31,
      42,
      53,
      75,
      65,
      86,
      116,
      146,
      127,
      160,
      139,
      98,
      109,
      174,
      158,
      185,
      200,
      274,
      266,
      296,
      239,
      345,
      328,
      335,
    }
    for i, locatorName in ipairs(mvars.mbSoldier_enableSoldierLocatorList[clusterId]) do
      local faceId = faceIdList[i]
      if not faceId then
        break
      end
      local gameObjectId = GetGameObjectId("TppSoldier2", locatorName)
      if gameObjectId ~= NULL_ID then
        TppEneFova.ApplyMTBSUniqueSetting( gameObjectId, faceId, false )
        Fox.Log("ApplyFova for memory Dump: faceId: " ..tostring(faceId) )
      end
    end
  end

end

return mtbs_enemy
