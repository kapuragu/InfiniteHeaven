--InfProgression.lua
--tex options and commands for managing games progression
--TODO: all the aacr stuff might be better in InfGimmick
local this={}

this.debugModule=false

this.dataSetPath32ToAacr={}

--TABLESETUP
--fast lookup from OnBreakGimmick message pathcode32
for gimmickId,gimmickInfo in pairs(TppLandingZone.aacrGimmickInfo) do
  this.dataSetPath32ToAacr[Fox.PathFileNameCode32(gimmickInfo.dataSetName)]=gimmickId
end

function this.Init(missionTable)
  this.messageExecTable=nil

  if Ivars.repopAARadars:Is(0) then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.OnReload(missionTable)
  this.messageExecTable=nil

  if not Ivars.repopAARadars:Is(0) then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.OnMissionCanStart(currentChecks)
  if Ivars.repopulateRadioTapes:Is(1) then
    Gimmick.ForceResetOfRadioCassetteWithCassette()
  end
end--OnMissionCanStart
function this.OnMissionFinalize()
  --tex WORKAROUND dont repop countdown if we are just doing a transition
  if InfTransition.IsTransition() then
    if this.debugModule then
      InfCore.Log"InfProgression.RepopFromFree IsTransition, returning"
    end
    return
  end

  local fromHeliSpace=TppMission.IsHelicopterSpace(Ivars.prevMissionCode)
  local fromFreeMission=TppMission.IsFreeMission(Ivars.prevMissionCode)
  if fromFreeMission then   
    this.AntiAirRadarsRepop()--tex
    this.MbCollectionRepop()--tex isFreeVersion IH repop since -^-
  elseif not fromHeliSpace then
    this.AntiAirRadarsRepop()
  end
end--OnMissionFinalize

function this.Messages()
  return Tpp.StrCode32Table{
    GameObject={
      {msg="BreakGimmick",func=this.OnBreakGimmick},
    },
  }
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end
function this.OnBreakGimmick(gimmickId,locatorS32,dataSetP32,destroyerId)
  local repopMissionElapseCount=ivars.repopAARadars
  if repopMissionElapseCount>0 then
    local gimmickId=this.dataSetPath32ToAacr[dataSetP32]
    if gimmickId then
      local gimmickInfo=TppLandingZone.aacrGimmickInfo[gimmickId]
      --if Fox.StrCode32(info.locatorName)==locatorNameS32 then
      InfCore.Log("InfProgression.OnBreakGimmick repopAntiAirRadar setting "..gimmickId.." to repopMissionElapseCount:"..repopMissionElapseCount)
      igvars[gimmickId]=repopMissionElapseCount
      --end
    end
  end
end--OnBreakGimmick
function this.AntiAirRadarsRepop()
  --tex repop count decrement
  local repopMissionElapse=Ivars.repopAARadars:Get()
  if repopMissionElapse>0 then
    InfCore.LogFlow("InfProgression.AntiAirRadarsRepop "..repopMissionElapse)
    for gimmickId,gimmickInfo in pairs(TppLandingZone.aacrGimmickInfo)do
      if Gimmick.IsBrokenGimmick(gimmickInfo.type,gimmickInfo.locatorName,gimmickInfo.dataSetName) then
        local value=igvars[gimmickId] or repopMissionElapse
        value=value-1
        if value<=0 then
          value=repopMissionElapse
          InfCore.Log("InfProgression.AntiAirRadarRepop "..gimmickId.." decrement/reset")--DEBUG
          InfMenu.PrintLangId"aaradar_reset"
          Gimmick.ForceIndelibleClear(gimmickInfo.type,gimmickInfo.locatorName,gimmickInfo.dataSetName)
        end
        if this.debugModule then
          InfCore.Log("InfProgression.AntiAirRadarRepop "..gimmickId.." changed from "..tostring(igvars[gimmickId]).." to "..value)--DEBUGNOW
        end
        igvars[gimmickId]=value
      end--if IsBrokenGimmick
    end--for aacrGimmickInfo
  end--if repopMissionElapseCount
end--AntiAirRadarsRepop
--CALLER: ExecuteMissionFinalize if freemission just before regular repop
function this.MbCollectionRepop()
  --tex repop count decrement for plants
  if Ivars.mbCollectionRepop:Is(1) then
    local fromMotherBase=Ivars.prevLocationCode==50
    local fromZoo=Ivars.prevMissionCode==30150

    if fromZoo then
      TppGimmick.DecrementCollectionRepopCount()
    elseif fromMotherBase then
      --tex dont want it too OP
      local defaultValue=IvarsPersist.mbRepopDiamondCountdown
      local value=igvars.mbRepopDiamondCountdown or defaultValue
      value=value-1
      if value<=0 then
        value=defaultValue
        --InfCore.Log("mbCollectionRepop decrement/reset")--DEBUG
        TppGimmick.DecrementCollectionRepopCount()
      end
      --InfCore.Log("mbRepopDiamondCountdown decrement from "..igvars.mbRepopDiamondCountdown.." to "..value)--DEBUG
      igvars.mbRepopDiamondCountdown=value
    end
  end
end--MbCollectionRepop

this.ivarsPersist={
  mbRepopDiamondCountdown=4,
}
for gimmickId,gimmickInfo in pairs(TppLandingZone.aacrGimmickInfo)do
  this.ivarsPersist[gimmickId]=-1--indicator for those already broken before ivar repopAARadars is turned on
end

this.registerIvars={
  "repopulateRadioTapes",
  "mbCollectionRepop",
  "repopAARadars",
  "mbForceBattleGearDevelopLevel",
}

this.repopulateRadioTapes={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}
this.mbCollectionRepop={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}
this.repopAARadars={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0,
  range={max=100,min=0},
--DEBUGNOW MissionCheck=
}
this.mbForceBattleGearDevelopLevel={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={max=5,min=0,increment=1},
}

this.UnlockPlayableAvatar=function()
  if vars.isAvatarPlayerEnable==1 then
    InfMenu.PrintLangId"allready_unlocked"
  else
    vars.isAvatarPlayerEnable=1
  end
end
this.UnlockWeaponCustomization=function()
  if vars.mbmMasterGunsmithSkill==1 then
    InfMenu.PrintLangId"allready_unlocked"
  else
    vars.mbmMasterGunsmithSkill=1
  end
end
this.ResetPaz=function()
  gvars.pazLookedPictureCount=0
  gvars.pazEventPhase=0

  local demoNames = {
    "PazPhantomPain1",
    "PazPhantomPain2",
    "PazPhantomPain3",
    "PazPhantomPain4",
    "PazPhantomPain4_jp",
  }
  for i,demoName in ipairs(demoNames)do
    TppDemo.ClearPlayedMBEventDemoFlag(demoName)
  end
  InfMenu.PrintLangId"paz_reset"
end
this.ReturnQuiet=function()
  if not TppBuddyService.CheckBuddyCommonFlag(BuddyCommonFlag.BUDDY_QUIET_LOST)then
    InfMenu.PrintLangId"quiet_already_returned"--"Quiet has already returned."
  else
    InfMenu.PrintLangId"quiet_return"
    --InfPatch.QuietReturn()
    TppStory.RequestReunionQuiet()
  end
end
this.ShowQuietReunionMissionCount=function()
  TppUiCommand.AnnounceLogView("quietReunionMissionCount: "..gvars.str_quietReunionMissionCount)
end
function this.RepopAntiAirRadar()
  --tex needs to be called in-mission when the specific gimmicks are loaded (so running on all like how currently below no good)
  --not sure how the persistant data that the assault LZ dissabling system uses works.
  --tex doesn't save/apply fully if abort to acc? fine if exit via heli (normal mission exit)?
  local aacrGimmickInfo=TppLandingZone.aacrGimmickInfo
  for gimmickId,gimmickInfo in pairs(aacrGimmickInfo)do
    Gimmick.ForceIndelibleClear(gimmickInfo.type,gimmickInfo.locatorName,gimmickInfo.dataSetName)
    --Gimmick.ResetGimmick(gimmickInfo.type,gimmickInfo.locatorName,gimmickInfo.dataSetName)
  end

  --DEBUGNOW
  --      for i, gimmickId in pairs( resetGimmickIdTable_Tank ) do
  --      Fox.Log("TppGimmick.s10080.ResetGimmick"..gimmickId)
  --      TppGimmick.ResetGimmick{ gimmickId = gimmickId, searchFromSaveData = false }
  --    end
end--RepopAntiAirRadar

--tex Cribbed from TppTerminal.AcquireDlcItemKeyItem
local MBMConst=TppMotherBaseManagementConst
this.dlcItemKeyItemList={
  WEAPON_MACHT_P5_WEISS=MBMConst.EXTRA_4000,
  WEAPON_RASP_SB_SG_GOLD=MBMConst.EXTRA_4001,
  WEAPON_PB_SHIELD_SIL=MBMConst.EXTRA_4002,
  WEAPON_PB_SHIELD_OD=MBMConst.EXTRA_4003,
  WEAPON_PB_SHIELD_WHT=MBMConst.EXTRA_4004,
  WEAPON_PB_SHIELD_GLD=MBMConst.EXTRA_4005,
  ITEM_CBOX_APD=MBMConst.EXTRA_4006,
  ITEM_CBOX_RT=MBMConst.EXTRA_4007,
  ITEM_CBOX_WET=MBMConst.EXTRA_4008,
  SUIT_FATIGUES_APD=MBMConst.EXTRA_4015,
  SUIT_FATIGUES_GRAY_URBAN=MBMConst.EXTRA_4016,
  SUIT_FATIGUES_BLUE_URBAN=MBMConst.EXTRA_4017,
  SUIT_FATIGUES_BLACK_OCELOT=MBMConst.EXTRA_4018,
  WEAPON_ADAM_SKA_SP=MBMConst.EXTRA_4024,
  WEAPON_WU_S333_CB_SP=MBMConst.EXTRA_4025,
  SUIT_MGS3_NORMAL=MBMConst.EXTRA_4019,
  SUIT_MGS3_SNEAK=MBMConst.EXTRA_4022,
  SUIT_MGS3_TUXEDO=MBMConst.EXTRA_4023,
  SUIT_THE_BOSS=MBMConst.EXTRA_4026,
  SUIT_EVA=MBMConst.EXTRA_4027,
  HORSE_WESTERN=MBMConst.EXTRA_4028,
  HORSE_PARADE=MBMConst.EXTRA_4009,
  ARM_GOLD=MBMConst.EXTRA_6000,--RETAILPATCH 1.10 added
}--dlcItemKeyItemList
--tex even when 1.0.4.1 stuff removed (ExcludeNonPermissionContents, EraseDlcItem) messagelog lists everything being unlocked, but dont acutally show in dev ui or equipment select, 
--so I guess its doing CheckDlcFlag in exe or something.
function this.UnlockDLC()
  local function AddDlcItem(dlcId,dlcType)
    local dataBaseId=this.dlcItemKeyItemList[dlcType]
    TppMotherBaseManagement.DirectAddDataBase{dataBaseId=dataBaseId,isNew=true}
    return true
  end
  --  local function RemoveDlcItem(dlcId,dlcType)--RETAILPATCH: 1060
  --    local platform=Fox.GetPlatformName()
  --    local dataBaseId=this.dlcItemKeyItemList[dlcType]
  --    if platform=="Xbox360"or platform=="XboxOne"then
  --      if((dataBaseId==NULL_ID.EXTRA_4025)or(dataBaseId==NULL_ID.EXTRA_4003))or(dataBaseId==NULL_ID.EXTRA_4008)then
  --        return false
  --      end
  --    end
  --    TppMotherBaseManagement.DirectRemoveDataBase{dataBaseId=dataBaseId}
  --    return true
  --  end--
  for dlcType,databaseId in pairs(this.dlcItemKeyItemList)do
    local dlcItem=DlcItem[dlcType]
    --InfCore.Log("AcquireDlcItemKeyItem dlcType:"..tostring(dlcType).." databaseId:"..tostring(databaseId).." dlcId:"..tostring(databaseId))--dlcId == databaseId
    if dlcItem then
      --tex OFF this.EraseDlcItem(dlcItem,RemoveDlcItem,dlcType)--RETAILPATCH: 1.0.4.1
      this.AcquireDlcItem(dlcItem,AddDlcItem,dlcType)
    end
  end

  TppSave.CheckAndSavePersonalData()--DEBUGNOW
  --TODO: lang success or fail (allready aquired)
end--UnlockDLC
--tex Cribbed from TppTerminal
--param==emblemType or dlcType
function this.AcquireDlcItem(databaseId,FuncOnAquire,param)
  --OFF
  --  if not TppUiCommand.CheckDlcFlag(databaseId)then
  --    return
  --  end
  if TppUiCommand.CheckDlcAcquiredFlag(databaseId)then
    return
  end
  if not Tpp.IsTypeFunc(FuncOnAquire)then
    return
  end
  local aquired=FuncOnAquire(databaseId,param)
  if aquired then
    TppUiCommand.SetDlcAcquired(databaseId)
  end
end--AcquireDlcItem

this.registerMenus={
  "progressionMenu",
}
this.progressionMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu"},
  options={
    "InfResources.resourceScaleMenu",
    "Ivars.repopulateRadioTapes",
    "Ivars.mbCollectionRepop",--tex also in motherBaseMenu
    "Ivars.repopAARadars",
    "Ivars.mbForceBattleGearDevelopLevel",--tex also in motherBaseShowAssetsMenu
    "InfProgression.UnlockPlayableAvatar",
    "InfProgression.UnlockWeaponCustomization",
    --"InfProgression.UnlockDLC",
    "InfProgression.ResetPaz",--tex also in motherBaseShowCharactersMenu
    "InfProgression.ReturnQuiet",--tex also in motherBaseShowCharactersMenu
    "InfProgression.ShowQuietReunionMissionCount",
  --"InfQuest.ForceAllQuestOpenFlagFalse",
  }
}--progressionMenu

this.langStrings={
  eng={
    progressionMenu="Progression menu",
    repopulateRadioTapes="Repopulate music tape radios",
    mbCollectionRepop="Repopulate MB plants and diamonds",
    repopAARadars="Repopulate AA Radars",
    mbForceBattleGearDevelopLevel="Force BattleGear built level",
    resetPaz="Reset Paz state to beginning",
    paz_reset="Paz reset",
    unlockPlayableAvatar="Unlock playable avatar",
    returnQuiet="Return Quiet after mission 45",
    quiet_already_returned="Quiet has already returned.",
    quiet_return="Quiet has returned.",
    unlockDLC="Unlock DLC",
    aaradar_reset="[Intel] an AA Radar has been replaced in the field",
  },--eng
  help={
    eng={
      mbCollectionRepop="Regenerates plants on Zoo platform and diamonds on Mother base over time.",
      repopAARadars="Number of mission completes before destroyed Anti Air Radars are rebuilt.",
      mbForceBattleGearDevelopLevel="Changes the build state of BattleGear in it's hangar, 0 is use the regular story progression.",
      unlockPlayableAvatar="Unlock avatar before mission 46",
      unlockWeaponCustomization="Unlock without having to complete legendary gunsmith missions",
      returnQuiet="Instantly return Quiet, runs same code as the Reunion mission 11 replay.",
    },--eng
  },--help
}--langStrings

return this
