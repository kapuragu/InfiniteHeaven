-- InfCameraPlayCam.lua
-- Implements Player.RequestToPlayCameraNonAnimation
-- DEBUGNOW TODO: an enable/disable ivar that runs with a nil (or can it be 0) cam_timeToSleep
-- A started timer on this.PlayCameraNonAnimation that disables the ivar when timed out
-- InfMain.RegisterCameraIvar(ivar)

local this={}

this.registerIvars={
  "cam_focalLength",
  "cam_focusDistance",
  "cam_aperture",
  "cam_isFollowPos",
  "cam_isFollowRot",
  "cam_followTime",
  "cam_followDelayTime",
  "cam_timeToSleep",
  "cam_interpTimeAtStart",
  "cam_fitOnCamera",
  "cam_timeToStartToFitCamera",
  "cam_fitCameraInterpTime",
  "cam_diffFocalLengthToReFitCamera",
  "cam_callSeOfCameraInterp",
  "cam_useLastSelectedIndex",
  "cam_isCollisionCheck",
  "cam_selectListObject",
}

function this.OnChangeCamVars(self,setting)
  this.PlayCameraNonAnimation()
end

--PlayCameraNonAmimation ivars
this.cam_focalLength={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=21,
  range={max=10000,min=0.1,increment=0.1},
  OnChange=this.OnChangeCamVars,
}

this.cam_focusDistance={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0.90,
  range={max=30,min=0.1,increment=0.1},
  OnChange=this.OnChangeCamVars,
}

this.cam_aperture={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1.875,
  range={max=100,min=0.001,increment=0.1},
  OnChange=this.OnChangeCamVars,
}

this.cam_isFollowPos={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=this.OnChangeCamVars,
}

this.cam_isFollowRot={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=this.OnChangeCamVars,
}

this.cam_followTime={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=5,
  range={max=10000,min=0,increment=1},
  OnChange=this.OnChangeCamVars,
}

this.cam_followDelayTime={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0.3,
  range={max=1,min=0,increment=0.1},
  OnChange=this.OnChangeCamVars,
}

this.cam_timeToSleep={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=10,
  range={max=10000,min=0,increment=1},
  OnChange=this.OnChangeCamVars,
}

this.cam_interpTimeAtStart={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0.1,
  range={max=10,min=0,increment=0.1},
  OnChange=this.OnChangeCamVars,
}

this.cam_fitOnCamera={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=this.OnChangeCamVars,
}

this.cam_timeToStartToFitCamera={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0.01,
  range={max=1000,min=0,increment=.01},
  OnChange=this.OnChangeCamVars,
}

this.cam_fitCameraInterpTime={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0.24,
  range={max=5,min=0,increment=.01},
  OnChange=this.OnChangeCamVars,
}

this.cam_diffFocalLengthToReFitCamera={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=16,
  range={max=100,min=0,increment=1},
  OnChange=this.OnChangeCamVars,
}

this.cam_callSeOfCameraInterp={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=this.OnChangeCamVars,
}

this.cam_useLastSelectedIndex={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=this.OnChangeCamVars,
}

this.cam_isCollisionCheck={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=this.OnChangeCamVars,
}

IvarProc.Vector3Ivar(this,"cam_offsetTarget",{
  save=IvarProc.CATEGORY_EXTERNAL,
  OnChange=this.OnChangeCamVars,
})

IvarProc.Vector3Ivar(this,"cam_offsetPos",{
  save=IvarProc.CATEGORY_EXTERNAL,
  OnChange=this.OnChangeCamVars,
})

this.cam_selectListObject={
  inMission=true,
  settings={"NONE"},
  GetSettingText=function(self,setting)
    if #self.settings==0 then
      return InfLangProc.LangString"list_empty"
    end
    
    local objectName=InfObjects.objectNames[setting+1]
    local gameObjectId=GameObject.GetGameObjectId(objectName)
    if gameObjectId==GameObject.NULL_ID then
      return objectName.."==NULL_ID"
    end

    return objectName
  end,
  Init=function(self)
    IvarProc.SetSettings(self,InfObjects.objectNames)
  end,
  OnChange=this.OnChangeCamVars,
}

this.registerMenus={
  "playCamMenu",
}

this.playCamMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu","InfMenuDefs.inDemoMenu"},
  options={
    "InfCameraPlayCam.PlayCameraNonAnimation",
    "InfCameraPlayCam.StopPlayCamera",
    "Ivars.cam_selectListObject",
    "Ivars.cam_focalLength",
    "Ivars.cam_focusDistance",
    "Ivars.cam_aperture",
    "Ivars.cam_isFollowPos",
    "Ivars.cam_isFollowRot",
    "Ivars.cam_offsetTargetX",
    "Ivars.cam_offsetTargetY",
    "Ivars.cam_offsetTargetZ",
    "Ivars.cam_offsetPosX",
    "Ivars.cam_offsetPosY",
    "Ivars.cam_offsetPosZ",
    "Ivars.cam_followTime",
    "Ivars.cam_followDelayTime",
    "Ivars.cam_timeToSleep",
    "Ivars.cam_fitOnCamera",
    "Ivars.cam_timeToStartToFitCamera",
    "Ivars.cam_fitCameraInterpTime",
    "Ivars.cam_diffFocalLengthToReFitCamera",
    "Ivars.cam_callSeOfCameraInterp",
    "Ivars.cam_useLastSelectedIndex",
    "Ivars.cam_isCollisionCheck",
  }
}

this.langStrings={
  eng={
    playCamMenu="Cam - PlayCam menu",
    playCameraNonAnimation="Start PlayCam",
    stopPlayCamera="Stop PlayCam",
    cam_selectListObject="Camera target",
    cam_focalLength="Focal length",
    cam_focusDistance="Focus distance",
    cam_aperture="Apeture",
    cam_isFollowPos="Follow Position",
    cam_isFollowRot="Follow Rotation",
    cam_offsetTargetX="Target offset X",
    cam_offsetTargetY="Target offset Y",
    cam_offsetTargetZ="Target offset Z",
    cam_offsetPosX="Position offset X",
    cam_offsetPosY="Position offset Y",
    cam_offsetPosZ="Position offset Z",
    cam_followTime="Follow time",
    cam_followDelayTime="Follow delay time",
    cam_timeToSleep="Time till end",
    cam_fitOnCamera="Fit on camera",
    cam_timeToStartToFitCamera="Fit start time",
    cam_fitCameraInterpTime="Fit interp time",
    cam_diffFocalLengthToReFitCamera="Fit diff focal length",
    cam_callSeOfCameraInterp="Call Se of Camera Interp",
    cam_useLastSelectedIndex="Use last selected index",
    cam_isCollisionCheck="Collision check",
  },
  help={
    eng={
      playCamMenu="An alternate camera than the one used by freecam. WARNING: is sometimes unstable and may crash the game.",
      playCameraNonAnimation="Starts PlayCam with current settings. Changing any setting also automatically starts the PlayCam.",
      --stopPlayCamera="Stop PlayCam",
      cam_selectListObject="Selects game object for the camera to target. You can add more game objects via the Objects menu in the main Mission menu.",
      cam_focalLength="DOF variable",
      cam_focusDistance="DOF variable",
      cam_aperture="DOF variable",
      cam_isFollowPos="Follows position of Camera target. Overrides Follow Rotation.",
      cam_isFollowRot="Follows rotation of Camera target.",
      cam_offsetTargetX="Adjusts X axis of camera target",
      cam_offsetTargetY="Adjusts Y axis of camera target",
      cam_offsetTargetZ="Adjusts Z axis of camera target",
      cam_offsetPosX="Adjusts X axis of camera position",
      cam_offsetPosY="Adjusts Y axis of camera position",
      cam_offsetPosZ="Adjusts Z axis of camera position",
      cam_followTime="Time in seconds before camera follow turns off. See Follow Position and Follow Rotation.",
      cam_followDelayTime="Delay before camera follows. Acts more like interpolation time than one-off. See Follow Position and Follow Rotation.",
      cam_timeToSleep="Time in seconds before PlayCam turns off. Set to high number if you don't want it to end.",
      cam_fitOnCamera="Unknown",
      cam_timeToStartToFitCamera="For Fit on camera.",
      cam_fitCameraInterpTime="Interpolation time for Fit on camera.",
      cam_diffFocalLengthToReFitCamera="Fit diff focal length",
      cam_callSeOfCameraInterp="Unknown",
      cam_useLastSelectedIndex="Unknown",
      cam_isCollisionCheck="Checks between camera and target and moves camera in if there is something in the way.",
    },
  }
}


-- REF
this.bones={
  npc={--enemy,hostage
    candidateRots={{10,0},{10,45},{10,90},{10,135},{10,180},{10,225},{10,270}},
    skeletonNames={"SKL_004_HEAD","SKL_011_LUARM","SKL_021_RUARM","SKL_032_LFOOT","SKL_042_RFOOT"},
    skeletonCenterOffsets={Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0)},
    skeletonBoundings={Vector3(0,.45,0),Vector3(0,0,0),Vector3(0,0,0),Vector3(0,-.3,0),Vector3(0,-.3,0)},
    offsetPos=Vector3(.3,.2,-4.6),
  },
  heli={
    candidateRots={{10,0}},
    skeletonNames={"SKL_011_RLWDOOR"},
    skeletonCenterOffsets={Vector3(0,0,0)},
    skeletonBoundings={Vector3(0,.45,0)},
    offsetPos=Vector3(.3,.2,-4.6),
  },
  truck={
    candidateRots={{10,0},{10,45},{10,90},{10,135},{10,180},{10,225},{10,270}},
    skeletonNames={"SKL_005_WIPERC"},
    skeletonCenterOffsets={Vector3(0,-.75,-2)},
    skeletonBoundings={Vector3(1.5,2,4)},
    offsetPos=Vector3(2.5,3,7.5),
  },
}

function this.PlayCameraNonAnimation()
  --tex have yet to do an exhaustive search of all uses so there may be more variables.
  local setting=Ivars.cam_selectListObject:Get()
  local selectedObjectName=InfObjects.objectNames[setting+1]
  local selectedObject=GameObject.GetGameObjectId(selectedObjectName)
  if selectedObject==GameObject.NULL_ID then
    return
  end
  local typeIndex=GameObject.GetTypeIndex(selectedObject)
  --TODO: game crashes when trying to target heli
  if typeIndex==GameObject.GAME_OBJECT_TYPE_ENEMY_HELI then
    return
  end

  Player.RequestToPlayCameraNonAnimation{
    characterId=selectedObject,--tex camera target
    isFollowPos=Ivars.cam_isFollowPos:Get()==1,--tex camera follows position of target, ?is it just target origin? or something to do with other settings
    isFollowRot=Ivars.cam_isFollowRot:Get()==1,--tex camera follows rotations of target, is overridden by isFollowPos
    followTime=Ivars.cam_followTime:Get(),--tex time in seconds camera follows target, will stop following after this time
    followDelayTime=Ivars.cam_followDelayTime:Get(),--tex time before camera starts following target. no noticable difference above 1.0, vanilla values 0,0.1,0.5
    candidateRots={{3,160},{3,-160}},--tex ?
    --skeletonNames={"SKL_004_HEAD",},--tex ?bones on target to keep in camera view?
    --skeletonCenterOffsets={Vector3(0,0,0)},--tex offsets of bones in skeletonNames, ?what is the effect?
    --skeletonBoundings={Vector3(0,0.45,0)},--tex as above, ?what is the effect?
    offsetTarget=Ivars.cam_offsetTargetX:GetVector3(),--tex ?offset camera target position?
    offsetPos=Ivars.cam_offsetPosX:GetVector3(),--tex offset of camera position ?what is default camera position?
    focalLength=Ivars.cam_focalLength:Get(),--tex dof setting
    focusDistance=Ivars.cam_focusDistance:Get(),--tex dof setting
    aperture=Ivars.cam_aperture:Get(),--tex dof setting
    timeToSleep=Ivars.cam_timeToSleep:Get(),--tex time in seconds before camera ends
    interpTimeAtStart=Ivars.cam_interpTimeAtStart:Get(),--tex ?time in seconds to interpolate from game camera to these settings?
    fitOnCamera=Ivars.cam_fitOnCamera:Get()==1,--tex ?
    timeToStartToFitCamera=Ivars.cam_timeToStartToFitCamera:Get(),--tex 0,0.001,0.01,1
    fitCameraInterpTime=Ivars.cam_fitCameraInterpTime:Get(),--tex time that camera settings are interpolated to fitCamera, 0,0.24,0.3
    diffFocalLengthToReFitCamera=Ivars.cam_fitCameraInterpTime:Get(),--tex ?
    callSeOfCameraInterp=Ivars.cam_callSeOfCameraInterp:Get()==1,--tex ?
    useLastSelectedIndex=Ivars.cam_useLastSelectedIndex:Get()==1,--tex ?
    isCollisionCheck=Ivars.cam_isCollisionCheck:Get()==1,
  }

  --REF simpler mode
  --  Player.RequestToPlayCameraNonAnimation{
  --    focalLength=14.7,
  --    aperture=1.05,
  --    focusDistance=0.9,
  --    positionAndTargetMode=true,
  --    position=Vector3{0.213,1198.166,0.106},
  --    target=Vector3{-0.222,1198.16,-0.35},
  --  }
end

--tex for Player.RequestToPlayCameraAnimation VERIFY, Player.RequestToPlayCameraNonAnimation
function this.StopPlayCamera()
  Player.RequestToStopCameraAnimation{}
end

return this
