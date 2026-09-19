-- InfEneFova.lua
local this={}

-->
this.registerIvars={
  "mbDDHeadGear",
}

IvarProc.MissionModeIvars(
  this,
  "customSoldierType",
  {
    save=IvarProc.CATEGORY_EXTERNAL,
    settings={"NONE"},--DYNAMIC via addon
    --tex the ivar.settings only used for range max really, 
    --all uses of the ivar should get the value and test against InfBodyInfo directly
    OnSelect=function(self)
      IvarProc.SetSettings(self,InfBodyInfo.bodies.MALE)
    end,
    GetSettingText=function(self,setting)
      local bodyType=self.settings[setting+1]
      return InfBodyInfo.bodyInfo[bodyType].description or bodyType
    end,
  },
  {
    "FREE",
    "MISSION",--TODO: missions a bit more complicated with a bunch of specific body setup
    "MB_ALL",
  }
)

IvarProc.MissionModeIvars(
  this,
  "customSoldierTypeFemale",
  {
    save=IvarProc.CATEGORY_EXTERNAL,
    settings={"NONE"},--DYNAMIC via addon
    Init=function(self)
      IvarProc.SetSettings(self,InfBodyInfo.bodies.FEMALE)
    end,
    GetSettingText=function(self,setting)
      local bodyType=self.settings[setting+1]
      return InfBodyInfo.bodyInfo[bodyType].description or bodyType
    end,
  },
  {
    --"FREE",
    --"MISSION",--TODO: missions a bit more complicated with a bunch of specific body setup
    "MB_ALL",
  }
)

this.mbDDHeadGear={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  MissionCheck=IvarProc.MissionCheckMbAll,
}
--< ivar defs
this.langStrings={
  eng={
    mbDDHeadGear="DD Head gear",
    mbDDHeadGearSettings={"Off","Current prep"},
    customSoldierTypeFREE="Custom soldier type in Free roam",
    customSoldierTypeMISSION="Custom soldier type in Missions",
    customSoldierTypeMB_ALL="Custom DD type in MB",
    customSoldierTypeFemaleMB_ALL="Custom DD female type in MB",
    setting_only_for_dd="This setting is only for DD soldiers",
  },
  help={
    eng={
      customSoldierTypeFREE="Override the soldier type of enemy soldiers in Free Roam.\nNew soldier types can be added via the bodyInfo addon system.",
      customSoldierTypeMISSION="WARNING: Unique soldiers in the mission are likely to either be the default body from the selected custom soldier, or have visual issues if there isn't one.",
      customSoldierTypeMB_ALL="New body types can be added via the bodyInfo addon system.",
      customSoldierTypeFemaleMB_ALL="New body types can be added via the bodyInfo addon system.",
    },
  }
}
--< lang strings

return this
