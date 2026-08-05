--InfMBAssets.lua
local this={}

this.registerIvars={
  "mbShowBigBossPosters",
  "mbShowQuietCellSigns",
  "mbShowMbEliminationMonument",
  "mbShowSahelan",
  "mbShowAiPod",
  "mbShowShips",
  "mbShowEli",
  "mbShowCodeTalker",
  "mbShowHuey",
  "mbEnableOceanSettings",
  "mbSetOceanBaseHeight",
  "mbSetOceanProjectionScale",
  "mbSetOceanBlendEnd",
  "mbSetOceanFarProjectionAmplitude",
  "mbSetOceanSpecularIntensity",
  "mbSetOceanDisplacementStrength",
  "mbSetOceanWaveAmplitude",
  "mbSetOceanWindDirectionP1",
  "mbSetOceanWindDirectionP2",
}

this.mbShowBigBossPosters={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.mbShowQuietCellSigns={
  --OFF save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.mbShowMbEliminationMonument={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.mbShowSahelan={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.mbShowAiPod={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.mbShowShips={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  MissionCheck=IvarProc.MissionCheckMb,
}

this.mbShowEli={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.mbShowCodeTalker={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.mbShowHuey={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--mb ocean
this.oceanIvars={
  "mbSetOceanBaseHeight",
  "mbSetOceanProjectionScale",
  "mbSetOceanBlendEnd",
  "mbSetOceanFarProjectionAmplitude",
  "mbSetOceanSpecularIntensity",
  "mbSetOceanDisplacementStrength",
  "mbSetOceanWaveAmplitude",
  "mbSetOceanWindDirectionP1",
  "mbSetOceanWindDirectionP2",
}

this.mbEnableOceanSettings={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    if not self:MissionCheck(vars.missionCode) then
      return
    end
    if setting==0 then
      TppEffectUtility.RestoreOceanParameters()
    else
      for i,ivarName in ipairs(this.oceanIvars)do
        local current=Ivars[ivarName]:Get()
        Ivars[ivarName]:Set(current)
      end
    end
  end,
  MissionCheck=IvarProc.MissionCheckMbAll,
}
this.mbSetOceanBaseHeight={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=-100,max=100,increment=5},
  default=-23,
  OnChange=function(self,setting)
    if not self:MissionCheck(vars.missionCode) then
      return
    end
    if not Ivars.mbEnableOceanSettings:Is(1) then
      return
    end
    TppEffectUtility.SetOceanBaseHeight(setting)
  end,
  MissionCheck=IvarProc.MissionCheckMbAll,
}
this.mbSetOceanProjectionScale={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=2000,increment=10},
  default=60,
  OnChange=function(self,setting)
    if not self:MissionCheck(vars.missionCode) then
      return
    end
    if not Ivars.mbEnableOceanSettings:Is(1) then
      return
    end
    TppEffectUtility.SetOceanProjectionScale(setting)
  end,
  MissionCheck=IvarProc.MissionCheckMbAll,
}
this.mbSetOceanBlendEnd={-- Distance high frequency wave mesh ends
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=2000,increment=10},
  default=380,
  OnChange=function(self,setting)
    if not self:MissionCheck(vars.missionCode) then
      return
    end
    if not Ivars.mbEnableOceanSettings:Is(1) then
      return
    end
    TppEffectUtility.SetOceanBlendEnd(setting)
  end,
  MissionCheck=IvarProc.MissionCheckMbAll,
}
this.mbSetOceanFarProjectionAmplitude={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=-100,max=100,increment=1},
  default=0,
  OnChange=function(self,setting)
    if not self:MissionCheck(vars.missionCode) then
      return
    end
    if not Ivars.mbEnableOceanSettings:Is(1) then
      return
    end
    TppEffectUtility.SetOceanFarProjectionAmplitude(setting)
  end,
  MissionCheck=IvarProc.MissionCheckMbAll,
}
this.mbSetOceanSpecularIntensity={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=-30,max=30,increment=1},
  default=1,
  OnChange=function(self,setting)
    if not self:MissionCheck(vars.missionCode) then
      return
    end
    if not Ivars.mbEnableOceanSettings:Is(1) then
      return
    end
    TppEffectUtility.SetOceanSpecularIntensity(setting)
  end,
  MissionCheck=IvarProc.MissionCheckMbAll,
}
this.mbSetOceanDisplacementStrength={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=10,increment=0.005},
  default=0.01,
  OnChange=function(self,setting)
    if not self:MissionCheck(vars.missionCode) then
      return
    end
    if not Ivars.mbEnableOceanSettings:Is(1) then
      return
    end
    TppEffectUtility.SetOceanDisplacementStrength(setting)
  end,
  MissionCheck=IvarProc.MissionCheckMbAll,
}
this.mbSetOceanWaveAmplitude={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=10,increment=0.100},
  default=0.500,
  OnChange=function(self,setting)
    if not self:MissionCheck(vars.missionCode) then
      return
    end
    if not Ivars.mbEnableOceanSettings:Is(1) then
      return
    end
    TppEffectUtility.SetOceanWaveAmplitude(setting)
  end,
  MissionCheck=IvarProc.MissionCheckMbAll,
}
this.mbSetOceanWindDirectionP1={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=-10,max=10,increment=0.1},
  default=0.1,
  OnChange=function(self,setting)
    if not self:MissionCheck(vars.missionCode) then
      return
    end
    if not Ivars.mbEnableOceanSettings:Is(1) then
      return
    end
    local p2=Ivars.mbSetOceanWindDirectionP2:Get()
    TppEffectUtility.SetOceanWindDirection(setting,p2)
  end,
  MissionCheck=IvarProc.MissionCheckMbAll,
}
this.mbSetOceanWindDirectionP2={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=-10,max=10,increment=0.1},
  default=0.1,
  OnChange=function(self,setting)
    if not self:MissionCheck(vars.missionCode) then
      return
    end
    if not Ivars.mbEnableOceanSettings:Is(1) then
      return
    end
    local p1=Ivars.mbSetOceanWindDirectionP1:Get()
    TppEffectUtility.SetOceanWindDirection(p1,setting)
  end,
  MissionCheck=IvarProc.MissionCheckMbAll,
}

--< ivar defs
this.registerMenus={
  "motherBaseShowCharactersMenu",
  "motherBaseShowAssetsMenu",
  "mbOceanMenu",
}

this.motherBaseShowCharactersMenu={
  options={
    "Ivars.mbEnableOcelot",
    "Ivars.mbOcelotRailMode",
    "Ivars.mbOcelotRailVoice",
    "Ivars.mbEnablePuppy",
    "Ivars.mbShowCodeTalker",
    "Ivars.mbShowEli",
    "Ivars.mbShowHuey",
    "Ivars.mbEnableBirds",
    "InfNPC.mbAdditionalNpcsMenu",
    "InfProgression.ResetPaz",
    "InfProgression.ReturnQuiet",
    "InfProgression.ShowQuietReunionMissionCount",
  }
}

this.motherBaseShowAssetsMenu={
  options={
    "Ivars.mbShowBigBossPosters",
    --"Ivars.mbShowQuietCellSigns",--tex not that interesting
    "Ivars.mbShowMbEliminationMonument",
    "Ivars.mbShowSahelan",
    "Ivars.mbShowShips",
    "Ivars.enableFultonAlarmsMB",
    "Ivars.enableIRSensorsMB",
    "Ivars.hideContainersMB",
    "Ivars.hideAACannonsMB",
    "Ivars.hideAAGatlingsMB",
    "Ivars.hideTurretMgsMB",
    "Ivars.hideMortarsMB",
    "Ivars.mbUnlockGoalDoors",
    "Ivars.mbForceBattleGearDevelopLevel",
  }
}

this.mbOceanMenu={
  parentRefs={"InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.mbEnableOceanSettings",
    "Ivars.mbSetOceanBaseHeight",
    "Ivars.mbSetOceanProjectionScale",
    "Ivars.mbSetOceanBlendEnd",
    "Ivars.mbSetOceanFarProjectionAmplitude",
    "Ivars.mbSetOceanSpecularIntensity",
    "Ivars.mbSetOceanDisplacementStrength",
    "Ivars.mbSetOceanWaveAmplitude",
    "Ivars.mbSetOceanWindDirectionP1",
    "Ivars.mbSetOceanWindDirectionP2",
  },
}
--< menu defs
this.langStrings={
  eng={
    motherBaseShowAssetsMenu="Show assets menu",--r73-v-
    mbShowBigBossPosters="Show Big Boss posters",
    mbShowQuietCellSigns="Show quiet cell signs",
    mbShowMbEliminationMonument="Show nuke elimination monument",
    mbShowSahelan="Show Sahelanthropus",
    mbShowEli="Show Eli",
    mbShowCodeTalker="Show Code Talker",
    mbUnlockGoalDoors="Unlock goal doors",
    mbOceanMenu="MB Ocean menu",
    motherBaseShowCharactersMenu="Show characters menu",
    mbShowShips="Show ships",
    mbShowHuey="Show Huey",
  },
  help={
    eng={
      mbShowHuey="Shows Huey in BattleGear hangar and in cutscenes even before he's arrived or after he's left story-wise.",
    },
  },
}

function this.AddMissionPacks(missionCode,packPaths)
  if not Ivars.mbShowShips:EnabledForMission(missionCode) then
    return
  end

  packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_ships.fpk"
end

function this.Init(missionTable)
  this.ModifyOcean()
end

function this.ModifyOcean()
  if not Ivars.mbEnableOceanSettings:EnabledForMission() then
    return
  end

  for i,ivarName in ipairs(this.oceanIvars)do
    local current=Ivars[ivarName]:Get()
    Ivars[ivarName]:Set(current)
  end
end

return this
