-- InfMainTppIvars.lua
local this={}

this.registerIvars={
  "playerHealthScale",
  "mbEnableLethalActions",
  "mbqfEnableSoldiers",
  "mbEnableBuddies",
  "mbPrioritizeFemale",
  "disableLzs",
  "disableSpySearch",
  "disableHerbSearch",
  "disableHeadMarkers",
  "disableWorldMarkers",
  "disableXrayMarkers",
  "disableFulton",
  "dontOverrideFreeLoadout",
  "clearItems",
  "clearSupportItems",
  "setSubsistenceSuit",
  "setDefaultHand",
  "disableMenuDrop",
  "disableMenuBuddy",
  "disableMenuAttack",
  "disableMenuHeliAttack",
  "disableSupportMenu",
  "abortMenuItemControl",
  "disableRetry",
  "gameOverOnDiscovery",
  "disableOutOfBoundsChecks",
  "disableKillChildSoldierGameOver",
  "disableGameOver",
  "disableTranslators",
  "handLevelSonar",
  "handLevelPhysical",
  "handLevelPrecision",
  "handLevelMedical",
  "itemLevelFulton",
  "itemLevelWormhole",
  "itemLevelIntScope",
  "itemLevelIDroid",
  "primaryWeaponOsp",
  "secondaryWeaponOsp",
  "tertiaryWeaponOsp",
  "randomizeMineTypes",
  "additionalMineFields",
  "quietRadioMode",
  "telopMode",
  "mbUnlockGoalDoors",
  "playerHandTypeDirect",
  "playerHandEquip",
  "cam_disableCameraAnimations",
}

this.playerHealthScale={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=100,
  range={max=650,min=0,increment=10},--tex GOTCHA see InfMain.ChangeMaxLife,http://wiki.tesnexus.com/index.php/Life
  isPercent=true,
  OnChange=function(self)
    if mvars.mis_missionStateIsNotInGame then
    --DEBUGNOW return
    end
    InfMainTpp.ChangeMaxLife(true)
  end,
}

--mb>
--InfEneFova

this.mbEnableLethalActions={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.mbqfEnableSoldiers={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.mbEnableBuddies={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.mbPrioritizeFemale={
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={"OFF","DISABLE","MAX","HALF"},
}

this.disableLzs={
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={"OFF","ASSAULT","REGULAR"},
}

--spysearch
local function RequireRestartMessage(self)
  --if self:Get()==1 then
  local settingName = self.description or InfLangProc.LangString(self.name)
  InfMenu.Print(settingName..InfLangProc.LangString"restart_required")
  --end
end
--tex not happy with the lack of flexibility as GetLocationParameter is only read once on init,
--now just bypassing on trap enter/exit, doesnt give control of search type though
this.disableSpySearch={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}
this.disableHerbSearch={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=RequireRestartMessage,
}

--mission prep
this.disableHeadMarkers={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    if setting==1 then
      TppUiStatusManager.SetStatus("HeadMarker","INVALID")
    else
      TppUiStatusManager.ClearStatus("HeadMarker")
    end
  end,
}

this.disableWorldMarkers={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    if setting==1 then
      TppUiStatusManager.SetStatus("WorldMarker","INVALID")
    else
      TppUiStatusManager.ClearStatus("WorldMarker")
    end
  end,
}

this.disableXrayMarkers={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    local enabled=setting==1
    TppSoldier2.SetDisableMarkerModelEffect{enabled=enabled}
  end,
}

this.disableFulton={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.dontOverrideFreeLoadout={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--tex TODO: RENAME RETRY this is OSP shiz
local ospSlotClearSettings={
  "OFF",
  "EQUIP_NONE",
}
this.clearItems={
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=ospSlotClearSettings,
  settingNames="set_switch",
  settingsTable={
    OFF=nil,
    EQUIP_NONE={"EQP_None","EQP_None","EQP_None","EQP_None","EQP_None","EQP_None","EQP_None"},
  },
}

this.clearSupportItems={
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=ospSlotClearSettings,
  settingNames="set_switch",
  settingsTable={
    OFF=nil,
    EQUIP_NONE={{support="EQP_None"},{support="EQP_None"},{support="EQP_None"},{support="EQP_None"},{support="EQP_None"},{support="EQP_None"},{support="EQP_None"},{support="EQP_None"}},
  },
}

this.setSubsistenceSuit={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.setDefaultHand={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.disableMenuDrop={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  menuId="MSN_DROP",
}
this.disableMenuBuddy={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  menuId="MSN_BUDDY",
}
this.disableMenuAttack={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  menuId="MSN_ATTACK",
}
this.disableMenuHeliAttack={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  menuId="MSN_HELI_ATTACK",
}

this.disableMenuIvars={
  "disableMenuDrop",
  "disableMenuBuddy",
  "disableMenuAttack",
  "disableMenuHeliAttack",
}

this.disableSupportMenu={--tex doesnt use dvcmenu, RESEARCH, not sure actually what it is
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.abortMenuItemControl={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.disableRetry={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.gameOverOnDiscovery={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    mvars.mis_isExecuteGameOverOnDiscoveryNotice=setting==1
  end,
}

this.disableOutOfBoundsChecks={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    local enable=setting==0
    mvars.mis_ignoreAlertOfMissionArea=not enable
    local trapName="trap_mission_failed_area"
    TppTrap.ChangeNormalTrapState(trapName,enable)
    TppTrap.ChangeTriggerTrapState(trapName,enable)
  end
}

this.disableKillChildSoldierGameOver={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.disableGameOver={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--tex no go
this.disableTranslators={
  --OFF save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    if setting==1 then
      InfCore.DebugPrint"removing tranlatable"--DEBUG
      vars.isRussianTranslatable=0
      vars.isAfrikaansTranslatable=0
      vars.isKikongoTranslatable=0
      vars.isPashtoTranslatable=0
    elseif setting==0 then
      InfCore.DebugPrint"adding tranlatable"--DEBUG
      --tex don't really need to do this, is handled by TppQuest.AcquireKeyItemOnMissionStart
      if TppQuest.IsCleard"ruins_q19010"then
        vars.isRussianTranslatable=1
      end
      if TppQuest.IsCleard"outland_q19011"then
        vars.isAfrikaansTranslatable=1
      end
      if TppQuest.IsCleard"hill_q19012"then
        vars.isKikongoTranslatable=1
      end
      if TppQuest.IsCleard"commFacility_q19013"then
        vars.isPashtoTranslatable=1
      end
    end
  end,
}

--item levels>
local function OnChangeItemLevel(self,setting)
  if setting>0 then
    --tex itemlevel == grade, but ivar setting 0 = don't set, so shifting down 1.
    Player.SetItemLevel(self.equipId,setting-1)
  end
end
--tex doesnt set item level to grade 0, most items don't seem to disable at grade 0 anyway.
local function OnChangeItemLevelNoZero(self,setting)
  if setting>0 then
    Player.SetItemLevel(self.equipId,setting)
  end
end

local itemLevelSettings={"DEFAULT","GRADE1","GRADE2","GRADE3","GRADE4"}
local handLevelSettings={"DEFAULT","DISABLE","GRADE2","GRADE3","GRADE4"}--tex functionally the same as itemlevelsettings, but being clear that grade 1 is disable since they have no grade 1
this.handLevelSonar={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=handLevelSettings,
  settingNames="handLevelSettings",
  equipId=TppEquip.EQP_HAND_ACTIVESONAR,
  OnChange=OnChangeItemLevelNoZero,
}

this.handLevelPhysical={--tex called Mobility in UI
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=handLevelSettings,
  settingNames="handLevelSettings",
  equipId=TppEquip.EQP_HAND_PHYSICAL,
  OnChange=OnChangeItemLevelNoZero,
}

this.handLevelPrecision={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=handLevelSettings,
  settingNames="handLevelSettings",
  equipId=TppEquip.EQP_HAND_PRECISION,
  OnChange=OnChangeItemLevelNoZero,
}

this.handLevelMedical={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=handLevelSettings,
  settingNames="handLevelSettings",
  equipId=TppEquip.EQP_HAND_MEDICAL,
  OnChange=OnChangeItemLevelNoZero,
}

this.itemLevelFulton={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=itemLevelSettings,
  settingNames="itemLevelSettings",
  equipId=TppEquip.EQP_IT_Fulton,
  OnChange=OnChangeItemLevelNoZero,
}
--tex wormhole grade 0 = disable, > 0 = enabled.
this.itemLevelWormhole={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  --range={max=4,min=0,increment=1},
  settings={"DEFAULT","DISABLE","ENABLE"},
  settingNames="itemLevelWormholeSettings",
  equipId=TppEquip.EQP_IT_Fulton_WormHole,
  OnChange=OnChangeItemLevel,
}

this.itemLevelIntScope={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=itemLevelSettings,
  settingNames="itemLevelSettings",
  equipId=TppEquip.EQP_IT_Binocle,
  OnChange=OnChangeItemLevelNoZero,
}
this.itemLevelIDroid={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=itemLevelSettings,
  settingNames="itemLevelSettings",
  equipId=TppEquip.EQP_IT_IDroid,
  OnChange=OnChangeItemLevelNoZero,
}
--<item levels

this.primaryWeaponOsp={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settings=ospSlotClearSettings,
  settingNames="weaponOspSettings",
  settingsTable={
    OFF=nil,
    EQUIP_NONE={{primaryHip="EQP_None"}},
  },
}
this.secondaryWeaponOsp={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settings=ospSlotClearSettings,
  settingNames="weaponOspSettings",
  settingsTable={
    OFF=nil,
    EQUIP_NONE={{secondary="EQP_None"}},
  },
}
this.tertiaryWeaponOsp={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settings=ospSlotClearSettings,
  settingNames="weaponOspSettings",
  settingsTable={
    OFF=nil,
    EQUIP_NONE={{primaryBack="EQP_None"}},
  },
}

--mines
this.randomizeMineTypes={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.additionalMineFields={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--mb
--see PlayMusicFromQuietRoom, QUIET_RADIO_TELOP_LANG_LIST
local quietRadioNames={
  "[Autoplay]",
  "Heavens Divide",
  "Koi no Yokushiryoku",
  "Gloria",
  "Kids In America",
  "Rebel Yell",
  "The Final Countdown",
  "Nitrogen",
  "Take On Me",
  "Ride A White Horse",
  "Maneater",
  "A Phantom Pain",
  "Only Time Will Tell",
  "Behind the Drapery",
  "Love Will Tear Us Apart",
  "All the Sun Touches",
  "TRUE",
  "Take The DW",
  "Friday Im In Love",
  "Midnight Mirage",
  "Dancing With Tears In My Eyes",
  "The Tangerine",
  "Planet Scape",
  "How 'bout them zombies ey",
  "Snake Eater",
  "204863",
  "You Spin Me Round",
  "Quiet Life",
  "She Blinded Me With Science",
  "Dormant Stream",
  "Too Shy",
  "Peace Walker",--sfx_m_prison_radio_31? not in QUIET_RADIO_TELOP_LANG_LIST, so I guess it's just an easter-egg
}--quietRadioNames

this.quietRadioMode={
  save=IvarProc.CATEGORY_EXTERNAL,
  --range={min=0,max=31},
  --range = 0=OFF,#list
  settings=quietRadioNames,
  OnChange=function(self,setting,previousSetting)
    --if setting>0 or previousSetting~=0 then
      if f30050_sequence and mvars.f30050_quietRadioName then
        f30050_sequence.PlayMusicFromQuietRoom()
      end
    --end
  end,
}--quietRadioMode

this.telopMode={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--motherbase
this.mbUnlockGoalDoors={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--
IvarProc.MissionModeIvars(
  this,
  "startOnFoot",
  {
    save=IvarProc.CATEGORY_EXTERNAL,
    settings={"OFF","NOT_ASSAULT","ALL"},
    settingNames="onFootSettingsNames",
  },
  {"FREE","MISSION","MB_ALL"}
)

--tex CULL
--this.forceSoldierSubType={--DEPENDENCY soldierTypeForced WIP
--  save=IvarProc.CATEGORY_EXTERNAL,
--  settings={
--    "DEFAULT",
--    "DD_A",
--    "DD_PW",
--    "DD_FOB",
--    "SKULL_CYPR",
--    "SKULL_AFGH",
--    "SOVIET_A",
--    "SOVIET_B",
--    "PF_A",
--    "PF_B",
--    "PF_C",
--    "CHILD_A",
--  },
--  --settingNames=InfEneFova.enemySubTypes,
--  OnChange=function(self,setting)
--    if setting==0 then
--      InfMainTpp.ResetCpTableToDefault()
--    end
--  end,
--}

this.cpTypeNames = {
  "TYPE_SOVIET",--=0, 
  "TYPE_AMERICA",--=1,
  "TYPE_AFRIKAANS",--=2,
}  

IvarProc.MissionModeIvars(
  this,
  "changeCpType",
  {
    save=IvarProc.CATEGORY_EXTERNAL,
    settings={
      "DEFAULT",
      "TYPE_SOVIET",--=0, 
      "TYPE_AMERICA",--=1,
      "TYPE_AFRIKAANS",--=2,
    },
    settingNames="changeCpTypeSettingsNames",
  },
  {"FREE","MISSION","MB_ALL",}
)


IvarProc.MissionModeIvars(
  this,
  "changeCpSubType",
  {
    save=IvarProc.CATEGORY_EXTERNAL,
    range=Ivars.switchRange,
    settingNames="set_switch",
    OnChange=function(self,setting)
      if setting==0 then
        InfMainTpp.ResetCpTableToDefault()
      end
    end,
  },
  {"FREE","MISSION",}
)


local playerHandTypes={
  "NONE",--0
  "NORMAL",--1
  "STUN_ARM",--2
  "JEHUTY",--3
  "STUN_ROCKET",--4
  "KILL_ROCKET",--5
}

this.playerHandTypeDirect={
  --save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=255},
  OnChange=function(self,setting)
    vars.playerHandType=setting
  end,
}

--TppEquip.
local playerHandEquipTypes={
  "EQP_HAND_NORMAL",
  "EQP_HAND_STUNARM",
  "EQP_HAND_JEHUTY",
  "EQP_HAND_STUN_ROCKET",
  "EQP_HAND_SILVER",
  "EQP_HAND_GOLD",
}
local handEquipTypeToHandType={
  EQP_HAND_NORMAL="NORMAL",
  EQP_HAND_STUNARM="STUNARM",
  EQP_HAND_JEHUTY="JEHUTY",
  EQP_HAND_STUN_ROCKET="STUN_ROCKET",
  EQP_HAND_KILL_ROCKET="KILL_ROCKET",
  EQP_HAND_SILVER="NORMAL",--VERIFY
  EQP_HAND_GOLD="NORMAL",--VERIFY
}

local playerHandEquipIds={}
for n,equipType in ipairs(playerHandEquipTypes)do
  playerHandEquipIds[#playerHandEquipIds+1]=TppEquip[equipType]
end

this.playerHandEquip={
  --OFF save=IvarProc.CATEGORY_EXTERNAL,
  settings=playerHandEquipTypes,

  settingsTable=playerHandEquipIds,
  --settingNames="set_",
  --OnSelect=function(self)
  -- self:Set(vars.handEquip,true)
  --end,
  OnChange=function(self,setting)
    if setting>0 then--TODO: add off/default/noset setting
      --DEBUG OFF vars.playerHandType=handEquipTypeToHandType[playerHandEquipTypes[setting]]
      vars.handEquip=self.settingsTable[setting]
    end
  end,
}

this.cam_disableCameraAnimations={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.cam_disableGameHighSpeedCam={--DEBUGNOW
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--< ivar defs

this.registerMenus={
  "miscInMissionMenu",
  "playerRestrictionsMenu",
  "playerRestrictionsInMissionMenu",
  "markersInMissionMenu",
  "disableSupportMenuMenu",
  "markersMenu",
  "enemyPatrolMenu",
  "motherBaseMenu",
  "playerSettingsMenu",
  "ospMenu",
  "itemLevelMenu",
  "handLevelMenu",
  "fultonLevelMenu",
  "customizeMenu",
}

this.miscInMissionMenu={
  parentRefs={"InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.itemDropChance",
    "Ivars.playerHealthScale",
  }
}

this.playerRestrictionsMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu"},
  options={
    "Ivars.disableHeliAttack",
    "Ivars.disableFulton",
    "Ivars.setSubsistenceSuit",
    "Ivars.setDefaultHand",
    "Ivars.abortMenuItemControl",
    "Ivars.disableRetry",
    "Ivars.gameOverOnDiscovery",
    "Ivars.disableKillChildSoldierGameOver",
    "Ivars.disableOutOfBoundsChecks",
    "Ivars.disableGameOver",
    "Ivars.disableSpySearch",
    "Ivars.disableHerbSearch",
    "Ivars.dontOverrideFreeLoadout",
    "InfMainTppIvars.markersMenu",
    "InfMainTppIvars.disableSupportMenuMenu",
    "InfMainTppIvars.itemLevelMenu",
    "InfMainTppIvars.handLevelMenu",
    "InfMainTppIvars.fultonLevelMenu",--DEBUGNOW
    "InfFulton.fultonSuccessMenu",
    "InfMainTppIvars.ospMenu",
  }
}

this.playerRestrictionsInMissionMenu={
  parentRefs={"InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.disableHeadMarkers",
    --"Ivars.disableXrayMarkers",--tex doesn"t seem to work realtime
    "Ivars.disableWorldMarkers",
    "Ivars.gameOverOnDiscovery",
    "Ivars.disableKillChildSoldierGameOver",
    "Ivars.disableOutOfBoundsChecks",
    "Ivars.disableGameOver",
  },
}


this.markersInMissionMenu={
  parentRefs={"InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.disableHeadMarkers",
    --"Ivars.disableXrayMarkers",--tex doesn"t seem to work realtime
    "Ivars.disableWorldMarkers",
  },
}

this.disableSupportMenuMenu={
  options={
    "Ivars.disableMenuDrop",
    "Ivars.disableMenuBuddy",
    "Ivars.disableMenuAttack",
    "Ivars.disableMenuHeliAttack",
    "Ivars.disableSupportMenu",
  }
}

this.markersMenu={
  options={
    "Ivars.disableHeadMarkers",
    "Ivars.disableXrayMarkers",
    "Ivars.disableWorldMarkers",
  }
}

this.enemyPatrolMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu"},
  options={
    "Ivars.enableLrrpFreeRoam",
    "Ivars.enableWildCardFreeRoam",
    "Ivars.attackHeliPatrolsFREE",
    "Ivars.attackHeliPatrolsMB",
    "Ivars.attackHeliTypeFREE",
    "Ivars.attackHeliTypeMB",
    "Ivars.attackHeliFovaFREE",
    "Ivars.attackHeliFovaMB",
    "Ivars.enableWalkerGearsFREE",
    "Ivars.enableWalkerGearsMB",
    "Ivars.vehiclePatrolProfile",
    "Ivars.vehiclePatrolClass",
    "Ivars.vehiclePatrolLvEnable",
    "Ivars.vehiclePatrolTruckEnable",
    "Ivars.vehiclePatrolWavEnable",
    "Ivars.vehiclePatrolWavHeavyEnable",
    "Ivars.vehiclePatrolTankEnable",
    "Ivars.putEquipOnTrucks",
  }
}

this.motherBaseMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu"},
  options={
    "Ivars.revengeModeMB_ALL",
    "InfEquip.customEquipMenu",
    "Ivars.mbSoldierEquipRange",
    "Ivars.customSoldierTypeMB_ALL",
    "Ivars.customSoldierTypeFemaleMB_ALL",
    "Ivars.mbDDHeadGear",
    --"Ivars.disableMotherbaseWeaponRestriction",--WIP
    "Ivars.supportHeliPatrolsMB",
    "Ivars.attackHeliPatrolsMB",
    "Ivars.attackHeliTypeMB",
    "Ivars.attackHeliFovaMB",
    "Ivars.enableWalkerGearsMB",
    "Ivars.mbWalkerGearsColor",
    "Ivars.mbWalkerGearsWeapon",
    "Ivars.mbCollectionRepop",
    "Ivars.revengeDecayOnLongMbVisit",
    "Ivars.mbEnableBuddies",
    "Ivars.mbAdditionalSoldiers",
    "Ivars.mbqfEnableSoldiers",
    "Ivars.mbNpcRouteChange",
    "InfMBStaff.mbStaffMenu",
    "InfMBAssets.motherBaseShowCharactersMenu",
    "InfMBAssets.motherBaseShowAssetsMenu",
    "Ivars.mbEnableLethalActions",
    "Ivars.mbWargameFemales",
    "Ivars.mbWarGamesProfile",
  }
}

this.playerSettingsMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu"},
  options={
    "Ivars.playerHealthScale",
    "InfHero.RemoveDemon",
    "InfHero.SetDemon",
    "Ivars.hero_dontSubtractHeroPoints",
    "Ivars.hero_dontAddOgrePoints",
    "Ivars.hero_heroPointsSubstractOgrePoints",
    "Ivars.useSoldierForDemos",
  }
}

this.ospMenu={
  options={
    "Ivars.primaryWeaponOsp",
    "Ivars.secondaryWeaponOsp",
    "Ivars.tertiaryWeaponOsp",--tex user can set in UI, but still have it for setting the profile changes", and also if they want to set it while they"re doing the other settings
    "Ivars.clearItems",
    "Ivars.clearSupportItems",
  }
}

this.itemLevelMenu={
  options={
    "Ivars.itemLevelIntScope",
    "Ivars.itemLevelIDroid",
  }
}

this.handLevelMenu={
  options={
    "Ivars.handLevelSonar",
    "Ivars.handLevelPhysical",
    "Ivars.handLevelPrecision",
    "Ivars.handLevelMedical",
  }
}

this.fultonLevelMenu={
  options={
    "Ivars.itemLevelFulton",
    "Ivars.itemLevelWormhole",
  }
}

this.customizeMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu"},
  options={
    'InfChimera.chimeraMenu',    
    'Ivars.emblem_load',
    'Ivars.emblem_save',
    'Ivars.avatar_load',
    'Ivars.avatar_save',
  },
}--customizeMenu

--< menu defs
this.langStrings={
  eng={
    miscInMissionMenu="Misc menu",
    motherBaseMenu="Mother Base menu",
    playerHealthScale="Player life scale",
    forceSoldierSubType="Force enemy CP sub type",
    primaryWeaponOsp="Primary weapon OSP",
    secondaryWeaponOsp="Secondary weapon OSP",
    tertiaryWeaponOsp="Back Weapon OSP",
    weaponOspSettings={"Use selected weapon","Clear weapon"},
    playerRestrictionsMenu="Player restrictions menu",
    disableHeadMarkers="Disable head markers",
    disableFulton="Disable fulton action",
    clearItems="Items OSP",
    clearSupportItems="Support items OSP",
    setSubsistenceSuit="Force subsistence suit (Olive Drab, no headgear)",
    setDefaultHand="Set hand type to default",
    handLevelMenu="Hand abilities levels menu",
    fultonLevelMenu="Fulton levels menu",
    ospMenu="OSP menu",
    disableSupportMenuMenu="Disable mission support-menus menu",
    disableMenuDrop="Disable Supply drop support-menu",
    disableMenuBuddy="Disable Buddies support-menu",
    disableMenuAttack="Disable Attack support-menu",
    disableMenuHeliAttack="Disable Heli attack support-menu",
    disableSupportMenu="Disable Support-menu",
    itemLevelFulton="Fulton Level",
    itemLevelFultonSettings={"Don't override","Grade 1","Grade 2","Grade 3","Grade 4"},--CULL
    itemLevelWormhole="Wormhole Level",
    itemLevelWormholeSettings={"Don't override","Disable","Enable"},
    handLevelSonar="Sonar level",
    handLevelPhysical="Mobility level",
    handLevelPrecision="Precision level",
    handLevelMedical="Medical level",
    handLevelSettings={"Don't override","Disable","Grade 2","Grade 3","Grade 4"},
    showMbEquipGrade="Show MB equip grade",
    disableLzs="Disable landing zones",
    disableLzsSettings={"Off","Assault","Regular"},
    mbEnableBuddies="Enable all buddies",
    abortMenuItemControl="Disable abort mission from pause menu",
    telopMode="Disable mission intro credits",
    unlockWeaponCustomization="Unlock weapon customization",
    allready_unlocked="Allready unlocked",
    disableXrayMarkers="Disable Xray marking",
    quietRadioMode="Quiets MB radio track",
    playerSettingsMenu="Player settings menu", 
    changeCpTypeMISSION="Force CP type in Missions",
    changeCpTypeFREE="Force CP type in Free Roam",
    changeCpTypeMB_ALL="Force CP type in MB",
    changeCpTypeSettingsNames={"Default","Soviet","American","Afrikaans"},
    changeCpSubTypeFREE="Random CP subtype in free roam",
    changeCpSubTypeMISSION="Random CP subtype in missions",
    disableRetry="Disable retry on mission fail",
    gameOverOnDiscovery="Game over on combat alert",
    mbPrioritizeFemale="Female staff selection",
    mbPrioritizeFemaleSettings={"Default","None","All available","Half"},
    enemyPatrolMenu="Patrols and deployments menu",
    disableWorldMarkers="Disable world markers",
    playerRestrictionsInMissionMenu="Player restrictions menu",
    markersMenu="Marking display menu",
    startOnFootFREE="Start free roam on foot",
    startOnFootMISSION="Start missions on foot",
    startOnFootMB_ALL="Start Mother base on foot",
    onFootSettingsNames={"Off","All but assault LZs","All LZs"},
    quietMoveToLastMarker="Quiet move to last marker",
    buddy_not_quiet="Current buddy is not Quiet",
    cpAlertOnVehicleFulton="CP alert on vehicle fulton",
    disableSpySearch="Disable Intel team enemy spotting",
    disableHerbSearch="Disable Intel team herb spotting (requires game restart)",
    restart_required=" will apply on next game restart",
    cant_find_quiet="Can't find Quiet",
    randomizeMineTypes="Randomize minefield mine types",
    additionalMineFields="Enable additional minefields",
    dontOverrideFreeLoadout="Keep equipment Free<>Mission",
    mbqfEnableSoldiers="Force enable Quaranine platform soldiers",
    mbEnableLethalActions="Allow lethal actions",
    disableOutOfBoundsChecks="Disable out of bounds checks",
    disableKillChildSoldierGameOver="Disable game over on killing child soldier",
    disableGameOver="Disable game over",
    itemLevelSettings={"Don't override","Grade 1","Grade 2","Grade 3","Grade 4"},
    itemLevelMenu="Item level menu",
    itemLevelIntScope="Int-Scope level",
    itemLevelIDroid="IDroid level",
    dropCurrentEquip="Drop current equip",
    markersInMissionMenu="Markers menu",
    customizeMenu="Customize menu",
  },--eng
  help={
    eng={
      playerRestrictionsMenu="Settings to customize the game challenge, including subsistence and OSP.",
      disableLzs="Disables Assault Landing Zones (those usually in the center of a base that the support heli will circle before landing), or all LZs but Assault LZs",
      disableHeadMarkers="Disables markers above soldiers and objects",
      disableWorldMarkers="Disables objective and placed markers",
      disableXrayMarkers="Disables the 'X-ray' effect of marked soldiers. Note: Buddies that mark still cause the effect.",
      disableSupportMenuMenu="Disables mission support menus in iDroid",
      ospMenu="Allows you to enter a mission with primary, secondary, back weapons set to none, individually settable. Separate from subsistence mode (but subsistence uses it). LEGACY You should set equip none via mission prep instead.",
      fovaModMenu="Form Variation support for player models (requires model swap to support it), the fova system is how the game shows and hides sub-models.",
      changeCpTypeMISSION="Changes Command Post Type, which controls the language spoken by CP and HQ.\nWARNING: Will break subtitles.\nWARNING: some CP types don't have responses for certain soldier call-ins for different languages.",
      --changeCpTypeFREE="Force CP type in Free Roam",
      --changeCpTypeMB_ALL="Force CP type in MB",
      changeCpSubTypeFREE="Randomizes the CP subtype - PF types in middle Affrica, urban vs general camo types in Afghanistan",
      changeCpSubTypeMISSION="Randomizes the CP subtype - PF types in middle Affrica, urban vs general camo types in Afghanistan",
      mbPrioritizeFemale="By default the game tries to assign a minimum of 2 females per cluster from the females assigned to the clusters section, All available and Half will select females first when trying to populate a MB section, None will prevent any females from showing on mother base",
      markersMenu="Toggles for marking in main view. Does not effect marking on iDroid map",
      mbEnableBuddies="Does not clear D-Horse and D-Walker if set from deploy screen and returning to mother base, they may however spawn inside building geometry, use the call menu to have them respawn near. Also allows buddies on the Zoo platform, now you can take D-Dog or D-Horse to visit some animals.",
      quietMoveToLastMarker="Sets a position similar to the Quiet attack positions, but can be nearly anywhere. Quiet will still abort from that position if it's too close to enemies.",
      randomizeMineTypes="Randomizes the types of mines within a minfield from the default anti-personel mine to gas, anti-tank, electromagnetic. While the placing the mines may not be ideal for the minetype, it does enable OSP of items that would be impossible to get otherwise.",
      additionalMineFields="In the game many bases have several mine fields but by default only one is enabled at a time, this option lets you enable all of them. Still relies on enemy prep level to be high enough for minefields to be enabled.",
      disableSpySearch="Stops the Intel teams enemy spotting audio notification and indication on the idroid map.",
      disableHerbSearch="Stops the Intel teams plant spotting audio notification and indication on the idroid map. Since the variable is only read once on game startup this setting requires a game restart before it will activate/deactivate.",
      quietRadioMode="Changes the music track of the radio played in Quiets cell on the medical platform in mother base.",
      dontOverrideFreeLoadout="Prevents equipment and weapons being reset when going between free-roam and missions.",
      mbqfEnableSoldiers="Normally game the Qurantine platform soldiers are disabled once you capture Skulls. This option re-enables them.",
      mbEnableLethalActions="Enables lethal weapons and actions on Mother Base. You will still get a game over if you kill staff.",
      customizeMenu="Options for saving/loading to items in the idroid Customize menu",
    },--eng
  }--help
}--langStrings
--< lang strings

return this
