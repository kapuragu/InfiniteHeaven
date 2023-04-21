--InfCamHook.lua
--tex manages IHHook FOV hook
-- which is an implementation of the same change-focal length target on update camera lerp as
-- https://github.com/mon/MGSV-TPP-FoV
--TODO: may eventually be expanded to other player camera settings, but InfCamera was taken by FreeCam
--the various params of
--SetAroundCameraManualModeParams
--SetAroundCameraManualModeShakeParams
--StartTargetConstrainCamera
--RequestToPlayCameraNonAnimation
--RequestToSetCameraRotation
--ChangeCameraParameter
--
--might be in the same camera structure that fov hook / UpdateFOVLerp gets passed in.
--maybe test by setting the params, breakpointing UpdateFOVLerp and looking at what the pointer is at

local this={}

--LOCALOPT:
local IHH=IHH


local hookEnabled=false

this.registerMenus={
  "camhookMenu",
}

this.camhookMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu","InfMenuDefs.inDemoMenu"},--DEBUGNOW
  requiresIHHook=true,
  options={
    "Ivars.camhook_enable",
    "Ivars.camhook_focalLength_NORMAL",
    "Ivars.camhook_focalLength_AIMING",
    "Ivars.camhook_focalLength_HIDING",
    "Ivars.camhook_focalLength_CQC",
    "Ivars.camhook_ApplyFOV",
  },
}

this.registerIvars={
  "camhook_enable",
  "camhook_focalLength_NORMAL",
  "camhook_focalLength_AIMING",
  "camhook_focalLength_HIDING",
  "camhook_focalLength_CQC",
  "camhook_ApplyFOV",
}

this.camhook_enable={
  requiresIHHook=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    if not IHH then
      InfMenu.PrintLangId"requires_ihhook"
      return
    end
    
    hookEnabled=setting==1--MODULE LOCAL
    this.UpdateCamHookFromIvars()
    IHH.SetCamHook(setting)
  end,
}--camhook_enable


this.camModes={
  "NORMAL",
  "AIMING",--Button.HOLD
  "HIDING",--PlayerStatusEx "STEALTH_MODE"
  "CQC",
}
this.camModesEnum=TppDefine.Enum(this.camModes)--tex index from 0 to match IHHook/C enum

function this.UpdateCamHook(self,setting)
  if not IHH then
    InfMenu.PrintLangId"requires_ihhook"
    return
  end

  local camMode=self.camMode
  local focalLength=setting
  IHH.UpdateCamHook(camMode,focalLength)
end

local focalLengthRange={max=3500,min=0.01,increment=1}--tex only reason max is silly high is so very low fov wont trigger out of range warnings
this.camhook_focalLength_NORMAL={
  requiresIHHook=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  camMode=this.camModesEnum.NORMAL,
  default=21,
  range=focalLengthRange,
  OnChange=this.UpdateCamHook,
}
this.camhook_focalLength_AIMING={
  requiresIHHook=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  camMode=this.camModesEnum.AIMING,
  default=22,
  range=focalLengthRange,
  OnChange=this.UpdateCamHook,
}
this.camhook_focalLength_HIDING={
  requiresIHHook=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  camMode=this.camModesEnum.HIDING,
  default=26,
  range=focalLengthRange,
  OnChange=this.UpdateCamHook,
}
this.camhook_focalLength_CQC={
  requiresIHHook=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  camMode=this.camModesEnum.CQC,
  default=32,
  range=focalLengthRange,
  OnChange=this.UpdateCamHook,
}
this.camhook_ApplyFOV={
  requiresIHHook=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  camMode=this.camModesEnum.CQC,
  default=81,
  range={max=179,min=1,increment=1},
  OnChange=function(self,setting)
    local defaultFocalLength=21--tex or camhook_focalLength_NORMAL.default
    for i,camMode in ipairs(this.camModes)do
      local ivarName="camhook_focalLength_"..camMode
      local ivar=Ivars[ivarName]
      if ivar then
        local newFocalLength=this.CalculateFocalLength(setting,defaultFocalLength,ivar.default)
        ivar:Set(newFocalLength)
      end--if ivar
    end--for camModes
    InfMenu.DisplayCurrentMenu()--tex update the rest of the menu since the ivars value changed
  end,--OnActivate
}--camhook_ApplyFOV

local default_tpp_fov = 21;
local default_shoulder_fov = 22;
local default_hiding_fov = 26;
local default_cqc_fov = 32;

local deg2rad = 3.1415926/180;
local frameWidth=36;
--ex new_tpp_fov =  (90, default_tpp_fov, default_tpp_fov)
--ex new_shoulder_fov =  (90, default_tpp_fov, default_shoulder_fov)
--NMC fov is in focal length of a 24mm x 36mm camera lens and is locked horizontally
--fov in degrees to focalLength, ex 90,100
function this.CalculateFocalLength(fov,defaultFocalLength,defaultModeFocalLength)
  local fovTan=math.tan(fov*deg2rad/2);
  --REF CULL
  --new_tpp_fov = frame_width / tpp_fov_tan / 2.F;
  --new_shoulder_fov = frame_width / (tpp_fov_tan * (default_tpp_fov / default_shoulder_fov)) / 2.F;
  --new_hiding_fov = frame_width / (tpp_fov_tan * (default_tpp_fov / default_hiding_fov)) / 2.F;
  --new_cqc_fov = frame_width / (tpp_fov_tan * (default_tpp_fov / default_cqc_fov)) / 2.F;

  local newFocalLength=frameWidth/(fovTan*(defaultFocalLength/defaultModeFocalLength))/2;
  return newFocalLength;
end--CalculateFocalLength

this.langStrings={
  eng={
    camhookMenu="Cam - Player FOV hook menu",
    camhook_enable="Enable Player Cam hook",
    camhook_focalLength_NORMAL="FocalLength Normal",
    camhook_focalLength_AIMING="FocalLength Aiming",
    camhook_focalLength_HIDING="FocalLength Hiding",
    camhook_focalLength_CQC="FocalLength CQC",
    camhook_ApplyFOV="Apply FOV",
  },
  help={
    eng={
      camhookMenu="Uses IHHook to adjust the player camera focal length.\n Same method as the FOV mod d3d11.dll",
      camhook_focalLength_NORMAL="Only updates after changing cam mode.\nFocal lengths between modes not equivalent (some other factor being applied)\nLower focal length = wider FOV,\nHigher focal length = lower FOV",
      camhook_focalLength_AIMING="Only updates after changing cam mode.\nFocal lengths between modes not equivalent (some other factor being applied)\nLower focal length = wider FOV,\nHigher focal length = lower FOV",
      camhook_focalLength_HIDING="Only updates after changing cam mode.\nFocal lengths between modes not equivalent (some other factor being applied)\nLower focal length = wider FOV,\nHigher focal length = lower FOV",
      camhook_focalLength_CQC="Only updates after changing cam mode.\nFocal lengths between modes not equivalent (some other factor being applied)\nLower focal length = wider FOV,\nHigher focal length = lower FOV",
      camhook_ApplyFOV="Applies FOV(degrees) proportionally to the different cam mode focal length options."
    },
  },
}--langStrings

function this.PostAllModulesLoad()
  if not IHH then
    return
  end

  this.UpdateCamHookFromIvars()
  --tex this.Update() handles enabling
end--PostAllModulesLoad

function this.UpdateCamHookFromIvars()
  if not IHH then
    return
  end

  InfCore.Log("InfCamHook.UpdateCamHookFromIvars")
  for i,camMode in ipairs(this.camModes)do
    local ivarName="camhook_focalLength_"..camMode
    local ivar=Ivars[ivarName]
    if ivar then
      local camMode=ivar.camMode
      local focalLength=ivar:Get()
      IHH.UpdateCamHook(camMode,focalLength)
    end
  end  
end--UpdateCamHookFromIvars

function this.Update(currentChecks,currentTime,execChecks,execState)
  if not IHH then
    return
  end

  if currentChecks.pastTitle==false or currentChecks.inDemo or currentChecks.inSafeSpace or currentChecks.usingAltCamera then
    if hookEnabled and ivars.camhook_enable==1 then--MODULE LOCAL
      hookEnabled=false
      IHH.SetCamHook(0)
    end
  else
    if not hookEnabled and ivars.camhook_enable==1 then--MODULE LOCAL
      hookEnabled=true
      this.UpdateCamHookFromIvars()
      IHH.SetCamHook(1)
    end
  end
end--Update

return this
