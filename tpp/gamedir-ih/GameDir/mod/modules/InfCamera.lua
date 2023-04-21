--InfCamera.lua
--tex really just SetAroundCameraManualModeParams, drivein in freecam mode by updating the target position in relation to previous diven by pressed direction
--TODO: whole thing needs a rework, was initially just a more generalized AroundCam, but then just left it as FreeCam when PlayCam was added, since that has better following and more options.
--so either commit to original idea or cull the alternate cam modes and simplify.
local this={}
--LOCALOPT
local InfMain=InfMain
local IsDemoPaused=DemoDaemon.IsDemoPaused
local IsDemoPlaying=DemoDaemon.IsDemoPlaying
local Vector3=Vector3
local Ivars=Ivars
local SetAroundCameraManualModeParams=Player.SetAroundCameraManualModeParams
local UpdateAroundCameraManualModeParams=Player.UpdateAroundCameraManualModeParams
local StageBlockCurrentPositionSetter_SetPosition=StageBlockCurrentPositionSetter.SetPosition

this.moveUpButton=InfButton.DASH
this.moveDownButton=InfButton.ZOOM_CHANGE

this.resetModeButton=InfButton.BINOCULARS
this.verticalModeButton=InfButton.ACTION
this.zoomModeButton=InfButton.FIRE
this.apertureModeButton=InfButton.RELOAD
this.focusDistanceModeButton=InfButton.STANCE
this.distanceModeButton=InfButton.READY_WEAPON
this.speedModeButton=InfButton.ACTION

--tex updateState
this.active="adjustCameraUpdate"
this.execState={
  nextUpdate=0,
}

local cameraOffsetDefault=Vector3(0,0.75,0)
--this.cameraPosition=cameraOffsetDefault--CULL
--this.cameraOffset=cameraOffsetDefault

-->
this.registerIvars={
  "adjustCameraUpdate",
  "cameraMode",
  "moveScale",
  "disableCamText",
  "updateStageBlockLoadPositionToCameraPosition",
  --tex ivars in camIvarPrefixes registered below
}

--tex module active ivar, not user facing
this.adjustCameraUpdate={
  inMission=true,
  nonConfig=true,
  --save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  isMode=true,
  --disableActions=PlayerDisableAction.OPEN_CALL_MENU+PlayerDisableAction.OPEN_EQUIP_MENU,--tex OFF not really needed, padmask is sufficient
  OnModeActivate=function()InfCamera.OnActivateCameraAdjust()end,--tex UNUSED?
  OnChange=function(self,setting)
    InfCore.LogFlow("InfCamera ivar adjustCameraUpdate.OnChange:"..setting)
    if Ivars.warpPlayerUpdate and Ivars.warpPlayerUpdate:Is(1) then--TODO rethink
      self:SetDirect(0)
      this.OnDectivateCameraAdjust()
      Ivars.cameraMode:Set(0)
      InfMenu.PrintLangId"other_control_active"
      return
    end

    if setting==1 then
      --      if Ivars.cameraMode:Is(0) then
      --        InfMenu.PrintLangId"cannot_edit_default_cam"
      --        setting=0
      --        return
      --      else
      InfMenu.PrintLangId"cam_mode_on"
      --InfMain.ResetCamDefaults()
      this.OnActivateCameraAdjust()
      Ivars.cameraMode:Set(1)
      --end
    else
      InfMenu.PrintLangId"cam_mode_off"
      this.OnDectivateCameraAdjust()
      Ivars.cameraMode:Set(0)
    end
    
    if InfMenu.menuOn then
      InfMain.RestoreActionFlag()--TODO only restore those that menu disables that this doesnt
      InfMenu.MenuOff()
    end
  end,
}
--tex was planned for a lot of modes, but now is just OFF, FreeCam
--currently the sole controller of Player.SetAroundCameraManualMode in this module
this.cameraMode={
  inMission=true,
  --save=IvarProc.CATEGORY_EXTERNAL,
  settings={"DEFAULT","CAMERA"},--"PLAYER","CAMERA"},
  OnChange=function(self,setting)
    local active=setting~=0--tex not off
    
    Player.SetAroundCameraManualMode(active)
    
    if active then
      --KLUDGE if cam at 0,0,0 set to player pos
      local currentCamName=this.GetCurrentCamName()
      local currentCamPos=this.ReadPosition(currentCamName)
      --InfCore.DebugPrint(currentCamPos:GetX()..","..currentCamPos:GetY()..","..currentCamPos:GetZ())--DEBUG
      if currentCamPos:GetX()==0 and currentCamPos:GetY()==0 and currentCamPos:GetZ()==0 then
        local currentPos=Vector3(vars.playerPosX,vars.playerPosY,vars.playerPosZ)
        this.WritePosition(currentCamName,currentPos+cameraOffsetDefault)
      end
    
      this.UpdateCameraManualMode()
    end
    
    if Ivars.updateStageBlockLoadPositionToCameraPosition:Is(1) then
      StageBlockCurrentPositionSetter.SetEnable(active)
    end

    InfMain.usingAltCamera=active
  end,
}

--tex GOTCHA: if adjustCameraUpdate is on then these will be set via Update which will call UpdateCameraManualMode to do them in one go
--so we're guarding against that
function this.UpdateCameraManualModeFromMenu()
  if ivars.cameraMode~=0 and ivars.adjustCameraUpdate==0 then
    this.UpdateCameraManualMode()
  end
end

this.updateStageBlockLoadPositionToCameraPosition={--DEBUGNOW addlang, add a warning about player falling through world if terrain is unloaded?
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    local enable=setting==1
    if Ivars.cameraMode:Is(1) then
      StageBlockCurrentPositionSetter.SetEnable(enable)
    end
  end,
}

this.moveScale={--Set
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0.5,
  range={max=10,min=0.01,increment=0.1},
}

this.disableCamText={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.camNames={
  "FreeCam",
--  "PlayerStand",
--  "PlayerSquat",
--  "PlayerCrawl",
--  "PlayerDash",
}
this.camIvarPrefixes={
  "focalLength",
  "focusDistance",
  "aperture",
  "distance",
  "positionX",
  "positionY",
  "positionZ",
  "targetInterpTime",
  "rotationLimitMinX",
  "rotationLimitMaxX",
  "alphaDistance",
}

for i,camName in ipairs(this.camNames) do
  this["focalLength"..camName]={
    inMission=true,
    save=IvarProc.CATEGORY_EXTERNAL,
    default=21,
    range={max=10000,min=0.1,increment=1},
    OnChange=this.UpdateCameraManualModeFromMenu,
  }

  this["focusDistance"..camName]={
    inMission=true,
    save=IvarProc.CATEGORY_EXTERNAL,
    default=8.175,
    range={max=1000,min=0.01,increment=0.1},
    OnChange=this.UpdateCameraManualModeFromMenu,
  }

  this["aperture"..camName]={
    inMission=true,
    save=IvarProc.CATEGORY_EXTERNAL,
    default=1.875,
    range={max=100,min=0.001,increment=0.1},
    OnChange=this.UpdateCameraManualModeFromMenu,
  }

  this["distance"..camName]={
    inMission=true,
    save=IvarProc.CATEGORY_EXTERNAL,
    default=0,--WIP TODO need seperate default for playercam and freemode (player wants to be about 5, free 0)
    range={max=100,min=0,increment=0.1},
    OnChange=this.UpdateCameraManualModeFromMenu,
  }

  this["positionX"..camName]={
    inMission=true,
    --OFF save=IvarProc.CATEGORY_EXTERNAL,
    default=0,
    range={max=100000,min=-100000,increment=1},
    noBounds=true,
    OnChange=this.UpdateCameraManualModeFromMenu,
  }
  this["positionY"..camName]={
    inMission=true,
    --OFF save=IvarProc.CATEGORY_EXTERNAL,
    default=0,
    range={max=100000,min=-100000,increment=1},
    noBounds=true,
    OnChange=this.UpdateCameraManualModeFromMenu,
  }
  this["positionZ"..camName]={
    inMission=true,
    --OFF save=IvarProc.CATEGORY_EXTERNAL,
    default=0,
    range={max=100000,min=-100000,increment=1},
    noBounds=true,
    OnChange=this.UpdateCameraManualModeFromMenu,
  }

  this["targetInterpTime"..camName]={
    inMission=true,
    save=IvarProc.CATEGORY_EXTERNAL,
    default=0,--WIP TODO need seperate default for playercam and freemode (player wants to be about 5, free 0)
    range={max=100,min=0,increment=0.1},
    OnChange=this.UpdateCameraManualModeFromMenu,
  }
  this["rotationLimitMinX"..camName]={
    inMission=true,
    save=IvarProc.CATEGORY_EXTERNAL,
    default=-90,--WIP TODO need seperate default for playercam and freemode (player wants to be about 5, free 0)
    range={max=0,min=-90,increment=1},
    OnChange=this.UpdateCameraManualModeFromMenu,
  }
  this["rotationLimitMaxX"..camName]={
    inMission=true,
    save=IvarProc.CATEGORY_EXTERNAL,
    default=90,--WIP TODO need seperate default for playercam and freemode (player wants to be about 5, free 0)
    range={max=90,min=0,increment=1},
    OnChange=this.UpdateCameraManualModeFromMenu,
  }
  this["alphaDistance"..camName]={
    inMission=true,
    save=IvarProc.CATEGORY_EXTERNAL,
    default=0,--WIP TODO need seperate default for playercam and freemode (player wants to be about 5, free 0)
    range={max=10,min=0,increment=0.1},--0--.1,--3--.5,1,3
    OnChange=this.UpdateCameraManualModeFromMenu,
  }


  for i,prefix in ipairs(this.camIvarPrefixes)do
    this.registerIvars[#this.registerIvars+1]=prefix..camName
  end
end
--< ivar defs
--menuCommands
this.ResetCameraToPlayerPos=function()
  local currentCamName=this.GetCurrentCamName()
  local currentPos=Vector3(vars.playerPosX,vars.playerPosY,vars.playerPosZ)
  this.WritePosition(currentCamName,currentPos+cameraOffsetDefault)
  
  this.UpdateCameraManualModeFromMenu()
end

this.WarpToCamPos=function()
  local warpPos=this.ReadPosition"FreeCam"
  if this.debugModule then
    InfCore.DebugPrint("warp pos:".. warpPos:GetX()..",".. warpPos:GetY().. ","..warpPos:GetZ())
  end
  --tex WORKAROUND: see WORKAROUND in InfUserMarker.WarpToLastUserMarker
  --otherwise would probably still keep the debugprint above to provide feedback in case the user is repeatedly WarpToCamPos and wondering why camera hasnt moved (you're already there dude)
  if InfMenu.menuOn and ivars.enableIHExt==0 and IHH==nil then
    InfMenu.MenuOff()
  end
  TppPlayer.Warp{pos={warpPos:GetX(),warpPos:GetY(),warpPos:GetZ()},rotY=vars.playerCameraRotation[1]}
end

this.positions={}
this.positionsXML={}
this.ShowFreeCamPosition=function()
  local currentCamName=this.GetCurrentCamName()
  local movePosition=this.ReadPosition(currentCamName)

  --tex TODO: dump to seperate file
  local x,y,z=movePosition:GetX(),movePosition:GetY(),movePosition:GetZ()
  local rotY=vars.playerCameraRotation[1]
  local positionTable=string.format("{pos={%.3f,%.3f,%.3f},rotY=%.3f,},",x,y,z,rotY)
  local positionXML=string.format('<value x="%.3f" y="%.3f" z="%.3f" w="0" />',x,y,z)
  table.insert(this.positions,positionTable)
  table.insert(this.positionsXML,positionXML)

  --    InfCore.Log(positionTable)
  --    InfCore.Log(positionXML)
  InfCore.Log("positions:\n"..table.concat(this.positions,"\n"),false,true)
  InfCore.Log("positionsxml:\n"..table.concat(this.positionsXML,"\n"),false,true)
  InfCore.DebugPrint("Position written to ih_log")
end
--quickmenu commands
this.ToggleCamMode=function()
  InfMenu.PrintLangId"freecam_non_adjust"
  InfCore.LogFlow"ToggleCamMode"
  if Ivars.cameraMode:Is(0) then
    Ivars.cameraMode:Set(1)
  else
    Ivars.cameraMode:Set(0)
  end
end

this.ToggleFreeCam=function()
  --InfCore.DebugPrint"quickmenu RELOAD"--DEBUG
  InfCore.LogFlow"ToggleFreeCam"
  if Ivars.adjustCameraUpdate:Is(0) then
    Ivars.adjustCameraUpdate:Set(1)
  else
    Ivars.adjustCameraUpdate:Set(0)
  end
end
--< menu commands
-->
this.registerMenus={
  "cam_aroundcamMenu",
}

this.cam_aroundcamMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu","InfMenuDefs.inDemoMenu"},
  options={
    "Ivars.adjustCameraUpdate",
    "Ivars.cameraMode",
    "InfCamera.ResetCameraToPlayerPos",
    "InfCamera.WarpToCamPos",
    "Ivars.updateStageBlockLoadPositionToCameraPosition",
    "Ivars.positionXFreeCam",--DEBUGNOW ADDLANG
    "Ivars.positionYFreeCam",
    "Ivars.positionZFreeCam",
    "Ivars.moveScale",--DEBUGNOW ADDLANG
    "Ivars.focalLengthFreeCam",--DEBUGNOW ADDLANG
    "Ivars.focusDistanceFreeCam",--DEBUGNOW ADDLANG
    "Ivars.apertureFreeCam",--DEBUGNOW ADDLANG
    "Ivars.distanceFreeCam",--DEBUGNOW ADDLANG
    "Ivars.targetInterpTimeFreeCam",--DEBUGNOW ADDLANG
    "Ivars.rotationLimitMinXFreeCam",--DEBUGNOW ADDLANG
    "Ivars.rotationLimitMaxXFreeCam",--DEBUGNOW ADDLANG
    "Ivars.alphaDistanceFreeCam",--DEBUGNOW ADDLANG
    "Ivars.disableCamText",--DEBUGNOW ADDLANG
    --"InfMenuCommands.SetStageBlockPositionToFreeCam",
    "InfCamera.ShowFreeCamPosition",--DEBUGNOW ADDLANG help
  }
}--cam_aroundcamMenu
--< menu defs
this.langStrings={
  eng={
    adjustCameraUpdate="Adjust-cam [Mode]",
    cam_mode_on="Adjust-cam mode on",
    cam_mode_off="Adjust-cam mode off",
    moveScale="Cam move speed scale",
    cameraMode="AroundCam mode",
    cameraModeSettings={"Off","Free cam"},--"Player","Free cam"},
    cam_aroundcamMenu="Cam - AroundCam - FreeCam - menu",
    focal_length_mode="Focal length mode",
    aperture_mode="Aperture mode",
    focus_distance_mode="Focus distance mode",
    vertical_mode="Vertical mode",
    speed_mode="Speed mode",
    reset_mode="Reset mode",
    resetCameraSettings="Set cam to near player",
    other_control_active="Another control mode is active",
    cannot_edit_default_cam="Cannot adjust Camera mode Default",
    distance_mode="Distance mode",
    disableCamText="Disable Adjust-cam text",
    resetCameraToPlayerPos="Reset camera position to player",
    warpToCamPos="Warp body to FreeCam position",
    showFreeCamPosition="Show freecam position",
    freecam_non_adjust="Static cam mode",
    setStageBlockPositionToFreeCam="Set stage position to camera",
    updateStageBlockLoadPositionToCameraPosition="Update stage position with camera",
  },
  help={
    eng={
      cam_aroundMenu="Lets you move a detached camera, use the main movement stick/keys in combination with other keys/buttons to adjust camera settings, including Zoom, aperture, focus distance.",
      adjustCameraUpdate=[[Turning this on sets AroundCam mode to Free cam, and lets you use keys/buttons to adjust the options.
  Move cam with normal move keys   
  
  [DASH] (Shift or Left stick click) to move up  
  [SWITCH_ZOOM](Middle mouse or Right stick click) to move down  
  
  Hold the following and move left stick up/down to increase/decrease the settings:  
  
  [FIRE] - Zoom/focal length   
  [RELOAD] - Aperture (DOF)  
  [STANCE] - Focus distance (DOF)   
  [ACTION] - Cam move speed  
  [AIM] - Camera orbit distance  
  
  Or hold [BINOCULARS] and press the above to reset that setting.  
  
  Hold [BINOCULARS] and press [DASH] to move free cam position to the player position]],
      cameraMode="Lets you turn on freecam, if Adjust-cam mode is off ",
      moveScale="Movement speed scale when in Adjust-cam mode",
      setStageBlockPositionToFreeCam="Sets the map loading position to the free cam position.",
      updateStageBlockLoadPositionToCameraPosition="Sets the map loading position to the free cam position as it moves. Warning: As the LOD changes away from player position your player may fall through the terrain.",
      disableCamText="Disables Adjust-cams repeating announce log of the current 'hold button to adjust' settings.",
    },--eng
  }
}--langStrings

--function this.ResetCamDefaults()--CULL
--  local currentPos = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
--  this.cameraPosition=currentPos+cameraOffsetDefault
--end

--function this.ResetCamPosition()--CULL
--  local currentPos = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
--  this.cameraPosition=currentPos+cameraOffsetDefault
--end
--SYNC: Ivars camNames
function this.GetCurrentCamName()
  --WIP
  --  if Ivars.cameraMode:Is"PLAYER" then
  --    if PlayerInfo.OrCheckStatus{PlayerStatus.STAND}then
  --      return "PlayerStand"
  --    elseif PlayerInfo.OrCheckStatus{PlayerStatus.SQUAT}then
  --      return "PlayerSquat"
  --    elseif  PlayerInfo.OrCheckStatus{PlayerStatus.CRAWL}then
  --      return "PlayerCrawl"
  --    elseif  PlayerInfo.OrCheckStatus{PlayerStatus.DASH}then
  --      return "PlayerDash"
  --    else
  --      InfCore.DebugPrint"UpdateCameraManualMode: unknow PlayerStatus"
  --    end
  --  else
  return "FreeCam"
    --  end
end

local positionXStr="positionX"
local positionYStr="positionY"
local positionZStr="positionZ"
function this.ReadPosition(camName)
  local ivars=ivars
  return Vector3(ivars[positionXStr..camName],ivars[positionYStr..camName],ivars[positionZStr..camName])
end

function this.WritePosition(camName,position)
  local ivars=ivars
  ivars[positionXStr..camName]=position:GetX()
  ivars[positionYStr..camName]=position:GetY()
  ivars[positionZStr..camName]=position:GetZ()
end

--REF params from all vanilla uses compiled
--Player.SetAroundCameraManualModeParams{
--  offset=,--Vector3 --(-.2,.7,0), (-0.25,0.35,0), (0.5,0.7,0), (0,0.75,0)
--  distance=0,--1.2,1.5,3.0,4.0,4.5,8.175,
--  focalLength=,--19,21,
--  focusDistance=,--1.5,2,8.175,
--  aperture=,--1.6,100,
--  target=,Vector3,--DEBUGNOW only if not targetIsPlayer? (but paz visit has targetIsPlayer and target)--Vector3(0,1000,0),--Vector3(2,10,10),
--  targetInterpTime=,--0.2,0.6,1.5,
--  targetIsPlayer=,--bool true,false
--  targetOffsetFromPlayer=Vector3,--only if targetIsPlayer? (0,0.05,0),
--  targetInstanceIndex=,int player Index, SSD
--  rotationBasedOnPlayer=true,--tex only 1 use
--  ignoreCollisionGameObjectName="Player",
--  ignoreCollisionGameObjectId=,--
--  rotationLimitMinX=,---6,-50,-90,
--  rotationLimitMaxX=,--30,50,90
--  rotationLimitMinY=,--180 ? no uses, but try anyway
--  rotationLimitMaxY=,--180 ? no uses, but try anyway
--  alphaDistance=,--.5,1.0
--  interpImmediately=,--bool true,false
--  enableStockChangeSe=,--bool true,false
--  rotationBasedOnPlayer=,--bool true,false--only used once skullface drive
--  useShakeParam=,--bool true,false--only used once skullface drive
--}--SetAroundCameraManualModeParams

function this.UpdateCameraManualMode()
  local Ivars=Ivars
  local currentCamName=this.GetCurrentCamName()
  local focalLength=Ivars["focalLength"..currentCamName]
  local aperture=Ivars["aperture"..currentCamName]
  local focusDistance=Ivars["focusDistance"..currentCamName]
  local cameraDistance=Ivars["distance"..currentCamName]
  local targetInterpTime=Ivars["targetInterpTime"..currentCamName]
  local rotationLimitMinX=Ivars["rotationLimitMinX"..currentCamName]
  local rotationLimitMaxX=Ivars["rotationLimitMaxX"..currentCamName]
  local alphaDistance=Ivars["alphaDistance"..currentCamName]

  local movePosition=this.ReadPosition(currentCamName)
  
  if Ivars.updateStageBlockLoadPositionToCameraPosition:Is(1)then
    local currentCamName=this.GetCurrentCamName()
    local movePosition=this.ReadPosition(currentCamName)
    StageBlockCurrentPositionSetter_SetPosition(movePosition:GetX(),movePosition:GetZ())   
  end
  
  --WIP
  --  if Ivars.cameraMode:Is"PLAYER" then
  --    SetCameraParams{
  --  offset=,--Vector3 --(-.2,.7,0), (-0.25,0.35,0), (0.5,0.7,0), (0,0.75,0)
  --  distance=0,--1.2,1.5,3.0,4.0,4.5,8.175,
  --  focalLength=,--19,21,
  --  focusDistance=,--1.5,2,8.175,
  --  aperture=,--1.6,100,
  --  target=,Vector3,--DEBUGNOW only if not targetIsPlayer? (but paz visit has targetIsPlayer and target)--Vector3(0,1000,0),--Vector3(2,10,10),
  --  targetInterpTime=,--0.2,0.6,1.5,
  --  targetIsPlayer=,--bool true,false
  --  targetOffsetFromPlayer=Vector3,--only if targetIsPlayer? (0,0.05,0),
  --  targetInstanceIndex=,int player Index, SSD
  --  rotationBasedOnPlayer=true,--tex only 1 use
  --  ignoreCollisionGameObjectName="Player",
  --  ignoreCollisionGameObjectId=,--
  --  rotationLimitMinX=,---6,-50,-90,
  --  rotationLimitMaxX=,--30,50,90
  --  rotationLimitMinY=,--180 ? no uses, but try anyway
  --  rotationLimitMaxY=,--180 ? no uses, but try anyway
  --  alphaDistance=,--.5,1.0
  --  interpImmediately=,--bool true,false
  --  enableStockChangeSe=,--bool true,false
  --  rotationBasedOnPlayer=,--bool true,false--only used once skullface drive
  --  useShakeParam=,--bool true,false--only used once skullface drive
  --    }
  --  else
  SetAroundCameraManualModeParams{
    target=movePosition,
    distance=cameraDistance:Get(),
    focalLength=focalLength:Get(),
    focusDistance=focusDistance:Get(),
    aperture=aperture:Get(),
    targetInterpTime=targetInterpTime:Get(),
    ignoreCollisionGameObjectName="Player",
    rotationLimitMinX=rotationLimitMinX:Get(),
    rotationLimitMaxX=rotationLimitMaxX:Get(),
    alphaDistance=alphaDistance:Get(),
  }
  -- end
  UpdateAroundCameraManualModeParams()
end--UpdateCameraManualMode

function this.OnActivateCameraAdjust()

  --this.DisableAction(Ivars.adjustCameraUpdate.disableActions)--tex OFF not really needed, padmask is sufficient
  Player.SetPadMask(InfMain.allButCamPadMask)
end

function this.OnDectivateCameraAdjust()
  --this.EnableAction(Ivars.adjustCameraUpdate.disableActions)--tex OFF not really needed, padmask is sufficient
  Player.ResetPadMask {
    settingName = "allButCam",
  }
end

--tex gated by adjustCameraUpdate (see this.active)
--update cam ivars using keys, then update aroundcam with them
--changing the cam ivars via the menu not use this update, they update aroundcam directly (assuming cameraMode not off)
function this.Update(currentChecks,currentTime,execChecks,execState)
  --InfCore.PCall(function(currentChecks,currentTime,execChecks,execState)--DEBUG
  local Ivars=Ivars

  if not currentChecks.inGame and (not currentChecks.inSafeSpace and not currentChecks.missionCanStart) then
    if not IsDemoPaused() and not IsDemoPlaying() then
      if Ivars.adjustCameraUpdate:Is(1) then
        Ivars.adjustCameraUpdate:Set(0)
      end
      return
    end
  end
 
  --tex Default, ie off.
  if Ivars.cameraMode:Is(0) then
    --OFF    InfMenu.PrintLangId"cannot_edit_default_cam"
    Ivars.adjustCameraUpdate:Set(0)
    return
  end

  this.DoControlSet(currentChecks)
  
  this.UpdateCameraManualMode()
  --end,currentChecks,currentTime,execChecks,execState)--DEBUG
end--Update

function this.DoControlSet(currentChecks)
  --InfCore.PCall(function(currentChecks)--DEBUG
  local Ivars=Ivars
  local InfButton=InfButton

  local isFreeCam=Ivars.cameraMode:Is"CAMERA"

  local moveAmount=1
  local zoomAmount=4
  local deadZone=0

  local moveX=0
  local moveY=0
  local moveZ=0

  local leftStickX=PlayerVars.leftStickXDirect
  local leftStickY=PlayerVars.leftStickYDirect

  local didMove=false
  if math.abs(leftStickX)>deadZone or math.abs(leftStickY)>deadZone then--tex seem like game already handles deadzone?
    didMove=true
  end

  local currentCamName=this.GetCurrentCamName()
  local focalLength=Ivars["focalLength"..currentCamName]
  local aperture=Ivars["aperture"..currentCamName]
  local focusDistance=Ivars["focusDistance"..currentCamName]
  local cameraDistance=Ivars["distance"..currentCamName]
  local movePosition=this.ReadPosition(currentCamName)
  local moveScale=Ivars.moveScale

  local currentMoveScale=moveScale:Get()
  if not isFreeCam then
    currentMoveScale=currentMoveScale*0.1
  end
  --tex TUNE pretty much doing voodoo to tune these
  local adjustScaleVerySlow=focalLength:Get()/1000--1
  local adjustScaleSlow=focalLength:Get()/100--1
  local adjustScaleMed=aperture:Get()/50--0.1
  local adjustScaleFast=focusDistance:Get()/10--0.1

  moveX=-leftStickX*currentMoveScale
  moveZ=-leftStickY*currentMoveScale

  local moveAmount=1
  --tex reusing these buttons in reset mode
  if not InfButton.ButtonDown(this.resetModeButton) then
    if InfButton.ButtonDown(this.moveUpButton)
      or InfButton.OnButtonRepeat(this.moveUpButton) then
      moveY=moveAmount*currentMoveScale
      didMove=true
    end
    --KLUDGE moving down when trying to use menu is annoying
    if this.moveDownButton~=InfMenu.menuAltButton or not currentChecks.inMenu then
      if InfButton.ButtonDown(this.moveDownButton)
        or InfButton.OnButtonRepeat(this.moveDownButton) then
        moveY=-moveAmount*currentMoveScale
        didMove=true
      end
    end
  end

  if not currentChecks.inMenu then
    local function IvarClamp(ivar,value)
      if value>ivar.range.max then
        value=ivar.range.max
      elseif value<ivar.range.min then
        value=ivar.range.min
      end
      return value
    end

    if didMove then
      if InfButton.ButtonDown(this.zoomModeButton) then
        local newValue=focalLength:Get()-leftStickY*adjustScaleSlow
        newValue=IvarClamp(focalLength,newValue)
        focalLength:Set(newValue)
      elseif InfButton.ButtonDown(this.apertureModeButton) then
        local newValue=aperture:Get()-leftStickY*adjustScaleMed
        newValue=IvarClamp(aperture,newValue)
        aperture:Set(newValue)
      elseif InfButton.ButtonDown(this.focusDistanceModeButton) then
        local newValue=focusDistance:Get()-leftStickY*adjustScaleFast
        newValue=IvarClamp(focusDistance,newValue)
        focusDistance:Set(newValue)
        --CULL
        --      elseif InfButton.ButtonDown(this.verticalModeButton) then
        --        moveY=moveZ
        --        moveZ=0
        --        local vMoveDir=Vector3(moveX,moveY,moveZ)
        --        local rotYQuat=Quat.RotationY(TppMath.DegreeToRadian(vars.playerCameraRotation[1]))
        --        local camMoveDir=rotYQuat:Rotate(vMoveDir)
        --        movePosition=movePosition+camMoveDir
      elseif InfButton.ButtonDown(this.speedModeButton) then
        local newValue=moveScale:Get()-leftStickY*adjustScaleVerySlow--WIP TODO own scale
        newValue=IvarClamp(moveScale,newValue)
        moveScale:Set(newValue)
      elseif InfButton.ButtonDown(this.distanceModeButton) then
        local newValue=cameraDistance:Get()+leftStickY*adjustScaleFast--WIP TODO own scale
        newValue=IvarClamp(cameraDistance,newValue)
        cameraDistance:Set(newValue)
      else
        local vMoveDir=Vector3(moveX,moveY,moveZ)
        local rotY=0
        if vars.playerCameraRotation~=nil then--TODO find altenate
          rotY=vars.playerCameraRotation[1]
        end
        local rotYQuat=Quat.RotationY(TppMath.DegreeToRadian(rotY))
        local camMoveDir=rotYQuat:Rotate(vMoveDir)
        movePosition=movePosition+camMoveDir
      end
    end--didmove
    --
    if InfButton.ButtonDown(this.resetModeButton) and not InfMenu.quickMenuOn then
      if InfButton.OnButtonDown(this.zoomModeButton) then
        focalLength:Reset()
      elseif InfButton.OnButtonDown(this.apertureModeButton) then
        aperture:Reset()
      elseif InfButton.OnButtonDown(this.focusDistanceModeButton) then
        focusDistance:Reset()
      elseif InfButton.OnButtonDown(this.moveUpButton) then
        if isFreeCam then
          local currentPos = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
          movePosition=currentPos+cameraOffsetDefault
        else
          movePosition=cameraOffsetDefault
        end
      elseif InfButton.ButtonDown(this.speedModeButton) then
        moveScale:Reset()
      elseif InfButton.OnButtonDown(this.distanceModeButton) then
        if isFreeCam then--tex KLUDGE
          cameraDistance:Set(0)
        else
          cameraDistance:Reset()
        end
      end
    end
    --
    if Ivars.disableCamText:Is(0) then
      if InfButton.OnButtonDown(this.zoomModeButton) or InfButton.OnButtonUp(this.zoomModeButton) then
        InfMenu.Print(currentCamName.." "..InfLangProc.LangString"focal_length_mode".." "..focalLength:Get())
      end
      if InfButton.OnButtonDown(this.apertureModeButton) or InfButton.OnButtonUp(this.apertureModeButton) then
        InfMenu.Print(currentCamName.." "..InfLangProc.LangString"aperture_mode".." "..aperture:Get())
      end
      if InfButton.OnButtonDown(this.focusDistanceModeButton) or InfButton.OnButtonUp(this.focusDistanceModeButton) then
        InfMenu.Print(currentCamName.." "..InfLangProc.LangString"focus_distance_mode".." "..focusDistance:Get())
      end
      --CULL
      --      if InfButton.OnButtonDown(InfMain.verticalModeButton) then
      --        InfMenu.Print(currentCamName.." "..InfLangProc.LangString"vertical_mode")
      --      end
      if InfButton.OnButtonDown(this.speedModeButton) or InfButton.OnButtonUp(this.speedModeButton) then
        InfMenu.Print(currentCamName.." "..InfLangProc.LangString"speed_mode".." "..moveScale:Get())
      end
      if InfButton.OnButtonDown(this.distanceModeButton) or InfButton.OnButtonUp(this.distanceModeButton) then
        InfMenu.Print(currentCamName.." "..InfLangProc.LangString"distance_mode".." "..cameraDistance:Get())
      end
      if InfButton.OnButtonDown(this.resetModeButton) then
        InfMenu.Print(currentCamName.." "..InfLangProc.LangString"reset_mode")
      end
    end
    --inmenu-v-
  else
    if didMove then
      local vMoveDir=Vector3(moveX,moveY,moveZ)
      local rotY=0
      if vars.playerCameraRotation~=nil then--TODO find altenate
        rotY=vars.playerCameraRotation[1]
      end
      local rotYQuat=Quat.RotationY(TppMath.DegreeToRadian(rotY))
      local camMoveDir=rotYQuat:Rotate(vMoveDir)
      movePosition=movePosition+camMoveDir
      --InfCore.DebugPrint("movePosition "..movePosition:GetX()..","..movePosition:GetY()..","..movePosition:GetZ())
    end
  end

  this.WritePosition(currentCamName,movePosition)
  return movePosition
  --end,currentChecks)--DEBUG
end--DoControlSet

--tex: DEBUGNOW any other mission changes we need to catch
function this.AbortMissionTop(abortInfo)
  --tex game doesnt like cam being on during mission change DEBUGNOW figure out what exactly
  --just firing without check so we get cameraMode turned off reguardless
  Ivars.adjustCameraUpdate:Set(0)
end

return this
