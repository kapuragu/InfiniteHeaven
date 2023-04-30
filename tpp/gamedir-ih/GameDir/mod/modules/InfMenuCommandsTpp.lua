-- InfMenuCommandsTpp.lua
local this={}

local SendCommand=GameObject.SendCommand
local NULL_ID=GameObject.NULL_ID
local GetGameObjectId=GameObject.GetGameObjectId
local GetTypeIndex=GameObject.GetTypeIndex

this.ShowMbEquipGrade=function()
  local soldierGrade = TppMotherBaseManagement.GetMbsClusterSecuritySoldierEquipGrade{}
  local infGrade = InfMainTpp.GetMbsClusterSecuritySoldierEquipGrade()
  TppUiCommand.AnnounceLogView("Security Grade: "..soldierGrade)--ADDLANG
  TppUiCommand.AnnounceLogView("Inf Grade: "..soldierGrade)--ADDLANG
end

this.DoEnemyReinforce=function()--WIP
--TODO: GetClosestCp
--  _OnRequestLoadReinforce(reinforceCpId)--NMC game message "RequestLoadReinforce"

--or

--  TppReinforceBlock.LoadReinforceBlock(reinforceType,reinforceCpId,reinforceColoringType)
end

--print stuff
this.PrintSightFormParameter=function()
  InfSoldierParams.ApplySightIvarsToSoldierParams()
  InfSoldierParams.PrintSightForm()
end

this.PrintHearingTable=function()
  InfSoldierParams.ApplyHearingIvarsToSoldierParams()
  InfCore.PrintInspect(InfSoldierParams.soldierParameters.hearingRangeParameter,{varName="hearingRangeParameter",announceLog=true,force=true})
end

this.PrintHealthTableParameter=function()
  InfSoldierParams.ApplyHealthIvarsToSoldierParams()
  InfCore.PrintInspect(InfSoldierParams.lifeParameterTable,{varName="lifeParameterTable",announceLog=true,force=true})
end

this.PrintCustomRevengeConfig=function()
  local revengeConfig=InfRevenge.CreateCustomRevengeConfig()
  InfCore.PrintInspect(revengeConfig,{varName="revengeConfig",announceLog=true,force=true})
end
--debug commands
this.PrintCurrentAppearance=function()
  InfMenu.Print("playerType: " .. tostring(vars.playerType))
  InfMenu.Print("playerCamoType: " .. tostring(vars.playerCamoType))
  InfMenu.Print("playerPartsType: " .. tostring(vars.playerPartsType))
  InfMenu.Print("playerFaceEquipId: " .. tostring(vars.playerFaceEquipId))
  InfMenu.Print("playerFaceId: " .. tostring(vars.playerFaceId))
  InfMenu.Print("playerHandType: " .. tostring(vars.playerHandType))
end

this.PrintFultonSuccessBonus=function()
  local mbFultonRank=TppMotherBaseManagement.GetSectionFuncRank{sectionFuncId=TppMotherBaseManagementConst.SECTION_FUNC_ID_SUPPORT_FULTON}
  local mbSectionSuccess=TppPlayer.mbSectionRankSuccessTable[mbFultonRank]or 0
  InfMenu.Print(InfLangProc.LangString"fulton_mb_support"..":"..mbSectionSuccess)
  local mbFultonRank=TppMotherBaseManagement.GetSectionFuncRank{sectionFuncId=TppMotherBaseManagementConst.SECTION_FUNC_ID_MEDICAL_STAFF_EMERGENCY}
  local mbSectionSuccess=TppPlayer.mbSectionRankSuccessTable[mbFultonRank]or 0
  InfMenu.Print(InfLangProc.LangString"fulton_mb_medical"..":"..mbSectionSuccess)
end

this.PrintBodyInfo=function()
  InfFova.GetCurrentFovaTable(true)
end

this.PrintFaceInfo=function()
  InfFovaIvars.PrintFaceInfo(vars.playerFaceId)
end

this.DEBUG_PrintInterrogationInfo=function()
  --tex roll back one since warpto advances after it's done
  local index= this.currentWarpIndex-1
  if index==0 then--tex except if there's only 1 in the object list
    index=this.currentWarpIndex
  end
  local objectName=this.warpObjecList[index]
  local gameId=objectName
  if type(objectName)=="string" then
    gameId=GameObject.GetGameObjectId(objectName)
  end
  if gameId==nil or gameId==GameObject.NULL_ID then
    InfCore.DebugPrint"gameId== nil or NULL_ID"
    return
  end

  local soldierICPQId=InfInterrogation.GetInterCpQuestId(gameId)
  if soldierICPQId==nil then
    InfCore.DebugPrint"cannot find cpQuestId for soldier"--DEBUG
    return
  end

  local cpName=InfInterrogation.interCpQuestSoldiersCps[soldierICPQId]
  if cpName==nil then
    InfCore.DebugPrint"cpName==nil"--DEBUG
    return
  end
  InfCore.DebugPrint("quest cpName:"..cpName)
end

this.DEBUG_PrintRevengePoints=function()
  --tex from TppRevenge. , cutting out dummy, max, and reordering to ui order
  local REVENGE_TYPE_NAME={"FULTON","HEAD_SHOT","STEALTH","COMBAT","NIGHT_S","NIGHT_C","LONG_RANGE","VEHICLE","TRANQ","SMOKE","M_STEALTH","M_COMBAT"}

  --      InfCore.DebugPrint"Revenge Levels"
  local revengeLevelsStr=""
  --      for i,revengeTypeName in ipairs(REVENGE_TYPE_NAME)do
  --        revengeLevelsStr=revengeLevelsStr..revengeTypeName..":"..tostring(TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE[revengeTypeName]))
  --        revengeLevelsStr=revengeLevelsStr.." "
  --      end
  --      InfCore.DebugPrint(revengeLevelsStr)

  InfCore.DebugPrint"Revenge points:"
  InfCore.Log("Revenge points:",false,true)
  local revengeLevelsStr=""
  for i,revengeTypeName in ipairs(REVENGE_TYPE_NAME)do
    revengeLevelsStr=revengeLevelsStr..revengeTypeName..":"..tostring(TppRevenge.GetRevengePoint(TppRevenge.REVENGE_TYPE[revengeTypeName]))
    revengeLevelsStr=revengeLevelsStr.." "
  end
  InfCore.DebugPrint(revengeLevelsStr)
  InfCore.Log(revengeLevelsStr,false,true)
end

this.DEBUG_ShowRevengeConfig=function()
  --InfCore.DebugPrint("RevRandomValue: "..gvars.rev_revengeRandomValue)
  InfCore.DebugPrint("RevengeType:")
  InfCore.PrintInspect(mvars.revenge_revengeType,{varName="mvars.revenge_revengeType"})

  InfCore.DebugPrint("RevengeConfig:")
  InfCore.PrintInspect(mvars.revenge_revengeConfig,{varName="mvars.revenge_revengeConfig"})
end

this.DEBUG_PrintSoldierDefine=function()
  InfCore.PrintInspect(mvars.ene_soldierDefine,{varName="mvars.ene_soldierDefine"})
end

this.DEBUG_PrintSoldierIDList=function()
  InfCore.PrintInspect(mvars.ene_soldierIDList,{varName="mvars.ene_soldierIDList"})
end

this.DEBUG_PrintReinforceVars=function()
  InfCore.DebugPrint("reinforce_activated: "..tostring(mvars.reinforce_activated))
  InfCore.DebugPrint("reinforceType: "..mvars.reinforce_reinforceType)
  InfCore.DebugPrint("reinforceCpId: "..mvars.reinforce_reinforceCpId)
  InfCore.DebugPrint("isEnabledSoldiers: "..tostring(mvars.reinforce_isEnabledSoldiers))
  InfCore.DebugPrint("isEnabledVehicle: "..tostring(mvars.reinforce_isEnabledVehicle))
end

this.DEBUG_PrintVehicleTypes=function()
  InfCore.DebugPrint("Vehicle.type.EASTERN_LIGHT_VEHICLE="..Vehicle.type.EASTERN_LIGHT_VEHICLE)
  InfCore.DebugPrint("Vehicle.type.WESTERN_LIGHT_VEHICLE="..Vehicle.type.WESTERN_LIGHT_VEHICLE)
  InfCore.DebugPrint("Vehicle.type.EASTERN_TRUCK="..Vehicle.type.EASTERN_TRUCK)
  InfCore.DebugPrint("Vehicle.type.WESTERN_TRUCK="..Vehicle.type.WESTERN_TRUCK)
  InfCore.DebugPrint("Vehicle.type.EASTERN_WHEELED_ARMORED_VEHICLE="..Vehicle.type.EASTERN_WHEELED_ARMORED_VEHICLE)
  InfCore.DebugPrint("Vehicle.type.WESTERN_WHEELED_ARMORED_VEHICLE="..Vehicle.type.WESTERN_WHEELED_ARMORED_VEHICLE)
  InfCore.DebugPrint("Vehicle.type.EASTERN_TRACKED_TANK="..Vehicle.type.EASTERN_TRACKED_TANK)
  InfCore.DebugPrint("Vehicle.type.WESTERN_TRACKED_TANK="..Vehicle.type.WESTERN_TRACKED_TANK)
end

this.DEBUG_PrintVehiclePaint=function()
  InfCore.DebugPrint("Vehicle.class.DEFAULT="..Vehicle.class.DEFAULT)
  InfCore.DebugPrint("Vehicle.class.DARK_GRAY="..Vehicle.class.DARK_GRAY)
  InfCore.DebugPrint("Vehicle.class.OXIDE_RED="..Vehicle.class.OXIDE_RED)
  InfCore.DebugPrint("Vehicle.paintType.NONE="..Vehicle.paintType.NONE)
  InfCore.DebugPrint("Vehicle.paintType.FOVA_0="..Vehicle.paintType.FOVA_0)
  InfCore.DebugPrint("Vehicle.paintType.FOVA_1="..Vehicle.paintType.FOVA_1)
  InfCore.DebugPrint("Vehicle.paintType.FOVA_2="..Vehicle.paintType.FOVA_2)
end

this.DEBUG_PrintRealizedCount=function()
  InfCore.DebugPrint("MAX_REALIZED_COUNT:"..EnemyFova.MAX_REALIZED_COUNT)
end
this.DEBUG_PrintEnemyFova=function()
  InfCore.PrintInspect(EnemyFova)
  InfCore.PrintInspect(getmetatable(EnemyFova))
end

this.DEBUG_PrintPowersCount=function()
  --InfCore.PrintInspect(mvars.ene_soldierPowerSettings)
  local totalPowerSettings={}

  local totalSoldierCount=0
  local armorCount=0
  local lrrpCount=0
  for soldierId, powerSettings in pairs(mvars.ene_soldierPowerSettings) do
    totalSoldierCount=totalSoldierCount+1
    for powerType,setting in pairs(powerSettings)do
      if totalPowerSettings[powerType]==nil then
        totalPowerSettings[powerType]=0
      end

      totalPowerSettings[powerType]=totalPowerSettings[powerType]+1
    end
  end
  InfCore.DebugPrint("totalSoldierCount:"..totalSoldierCount)
  InfCore.PrintInspect(totalPowerSettings)
end

this.DEBUG_PrintCpPowerSettings=function()
  --InfCore.PrintInspect(mvars.ene_soldierPowerSettings)
  if Ivars.selectedCp:Is()>0 then
    local soldierList=mvars.ene_soldierIDList[Ivars.selectedCp:Get()]
    if soldierList then
      for soldierId,cpDefineIndex in pairs(soldierList)do
        InfCore.PrintInspect(mvars.ene_soldierPowerSettings[soldierId])
      end
    end
  end
end

this.DEBUG_PrintCpSizes=function()
  local cpTypesCount={
    cp=0,
    ob=0,
    lrrp=0,
  }
  local cpTypesTotal={
    cp=0,
    ob=0,
    lrrp=0,
  }
  local cpTypesAverage={
    cp=0,
    ob=0,
    lrrp=0,
  }

  local cpSizes={}
  for cpName,cpDefine in pairs(mvars.ene_soldierDefine)do
    local soldierCount=0


    for key,value in ipairs(cpDefine)do
      if type(value)=="string" then
        soldierCount=soldierCount+1
      end
    end

    if soldierCount~=0 then
      if string.find(cpName, "_cp")~=nil then
        cpTypesCount.cp=cpTypesCount.cp+1
        cpTypesTotal.cp=cpTypesTotal.cp+soldierCount
      elseif string.find(cpName, "_ob")~=nil then
        cpTypesCount.ob=cpTypesCount.cp+1
        cpTypesTotal.ob=cpTypesTotal.ob+soldierCount
      elseif string.find(cpName, "_lrrp")~=nil then
        cpTypesCount.lrrp=cpTypesCount.lrrp+1
        cpTypesTotal.lrrp=cpTypesTotal.lrrp+soldierCount
      end

      cpSizes[cpName]=soldierCount
    end
  end

  for cpType,total in pairs(cpTypesTotal)do
    if cpTypesCount[cpType]~=0 then
      cpTypesAverage[cpType]=total/cpTypesCount[cpType]
    end
  end

  InfCore.PrintInspect(cpSizes)
  InfCore.PrintInspect(cpTypesAverage)
end

--phase
this.DEBUG_ChangePhase=function()
  InfCore.DebugPrint("Changephase b")
  for cpName,soldierList in pairs(mvars.ene_soldierDefine)do
    InfMain.ChangePhase(cpName,Ivars.maxPhase:Get())
  end
  InfCore.DebugPrint("Changephase e")
end

this.DEBUG_KeepPhaseOn=function()
  InfCore.DebugPrint("DEBUG_KeepPhaseOn b")
  for cpName,soldierList in pairs(mvars.ene_soldierDefine)do
    InfMain.SetKeepAlert(cpName,true)
  end
  InfCore.DebugPrint("DEBUG_KeepPhaseOn e")
end

this.DEBUG_KeepPhaseOff=function()
  InfCore.DebugPrint("DEBUG_KeepPhaseOff b")
  for cpName,soldierList in pairs(mvars.ene_soldierDefine)do
    InfMain.SetKeepAlert(cpName,false)
  end
  InfCore.DebugPrint("DEBUG_KeepPhaseOff e")
end

this.PrintPlayerPhase=function()
  InfCore.DebugPrint("vars.playerPhase=".. vars.playerPhase ..":".. InfEnemyPhase.phaseSettings[vars.playerPhase+1])
end

this.DEBUG_SetPlayerPhaseToIvar=function()
  vars.playerPhase=Ivars.maxPhase:Get()
end

this.DEBUG_ShowPhaseEnums=function()
  for n, phaseName in ipairs(Ivars.maxPhase.settings) do
    InfCore.DebugPrint(phaseName..":".. Ivars.maxPhase.settingsTable[n])
  end
end

--buddy
InfMenuCommands.quietMoveToLastMarker={
  isMenuOff=true,
}
function this.QuietMoveToLastMarker()
  if vars.buddyType~=BuddyType.QUIET then
    InfMenu.Print(InfLangProc.LangString"current_buddy_not"..InfLangProc.LangString"buddy_quiet")
    return
  end

  local lastMarkerIndex=InfUserMarker.GetLastAddedUserMarkerIndex()
  if lastMarkerIndex==nil then
    InfMenu.PrintLangId"no_marker_found"
  else
    local moveToPosition=InfUserMarker.GetMarkerPosition(lastMarkerIndex)
    local rotationY=TppMath.DegreeToRadian(vars.playerRotY)
    local gameId={type="TppBuddyQuiet2",index=0}
    if gameId==NULL_ID then
      InfMenu.PrintLangId"cant_find_quiet"
    else
      SendCommand(gameId,{id="MoveToPosition",position=Vector3(moveToPosition),rotationY=rotationY})--,index=99,disableAim=true})
    end
  end
  InfMenu.MenuOff()
end

--Heli
--CULL: UI system overrides it :(
this.HeliMenuOnTest=function()
  local dvcMenu={
    {menu=TppTerminal.MBDVCMENU.MSN_HELI,active=true},
    {menu=TppTerminal.MBDVCMENU.MSN_HELI_RENDEZVOUS,active=true},
    {menu=TppTerminal.MBDVCMENU.MSN_HELI_ATTACK,active=true},
    {menu=TppTerminal.MBDVCMENU.MSN_HELI_DISMISS,active=true},
  }
  InfCore.DebugPrint("blih")--DEBUG
  TppTerminal.EnableDvcMenuByList(dvcMenu)
  InfCore.DebugPrint("bleh")--DEBUG
end



local routeIndex=1
this.heliRoute=nil
local heliRoutes={}
this.DEBUG_CycleHeliRoutes=function()
  local StrCode32=Fox.StrCode32
  local heliName="SupportHeli"--EnemyHeli0000"
  local heliIndex=1
  local heliObjectId = GetGameObjectId(heliName)
  if heliObjectId==NULL_ID then
  --InfCore.DebugPrint(heliName.."==NULL_ID")--DEBUG
  else
    if #heliRoutes==0 then
      --heliRoutes=this.ResetLzPool()
      heliRoutes=InfUtil.CopyList(InfNPCHeli.heliRoutes.afgh)
    end
    --InfCore.PrintInspect(heliRoutes)--DEBUG
    this.heliRoute=StrCode32(heliRoutes[routeIndex])
    routeIndex=routeIndex+1
    if routeIndex>#heliRoutes then
      routeIndex=1
    end

    InfNPCHeli.SetRoute(this.heliRoute,heliIndex)
    --InfCore.DebugPrint(heliName.." setting route: "..tostring(InfLookup.str32LzToLz[this.heliRoute]))--DEBUG
    --GameObject.SendCommand(heliObjectId,{id="SetForceRoute",route=this.heliRoute,point=0,warp=true})
  end
  local groundStartPosition=InfLZ.GetGroundStartPosition(this.heliRoute)
  if groundStartPosition==nil then
    InfCore.DebugPrint" groundStartPosition==nil"
  else
    InfCore.DebugPrint("warped to "..tostring(InfLookup.str32LzToLz[this.heliRoute]))--DEBUG
    TppPlayer.Warp{pos={groundStartPosition.pos[1],groundStartPosition.pos[2],groundStartPosition.pos[3]},rotY=vars.playerCameraRotation[1]}
  end
end

local fovaIndex=1
this.DEBUG_FovaTest=function()
  Player.SetPartsInfoAtInstanceIndex("/Assets/tpp/parts/chara/sna/sna1_main0_def_v00.parts")
  --Player.RequestToUnloadAllPartsBlock()
  --Player.RequestToLoadPartsBlock("PLTypeHospital")
end

this.DropCurrentEquip=function()
  if vars.playerVehicleGameObjectId~=NULL_ID and not InfTppUtil.IsGameObjectType(vars.playerVehicleGameObjectId,TppGameObject.GAME_OBJECT_TYPE_HORSE2) then
    return
  end

  local slotType=vars.currentInventorySlot
  local subIndex=nil
  --tex NOTE: currentInventorySlot doesn't seem to ever be set to PlayerSlotType.ITEM
  if slotType==PlayerSlotType.ITEM then
    subIndex=vars.currentItemIndex
  elseif slotType==PlayerSlotType.SUPPORT then
    subIndex=vars.currentSupportWeaponIndex
  elseif slotType==PlayerSlotType.STOLE then
  -- return --tex allow it since
  elseif slotType==PlayerSlotType.HAND then
  -- return --tex think I'll allow it so user can quick dump hand to default
  end

  InfCore.Log("dropCurrentEquip currentInventorySlot"..vars.currentInventorySlot.."currentItemIndex "..vars.currentItemIndex.." currentSupportWeaponIndex "..vars.currentSupportWeaponIndex)

  Player.UnsetEquip{
    slotType=slotType,
    subIndex=subIndex,
    dropPrevEquip=true,
  }
end

return this