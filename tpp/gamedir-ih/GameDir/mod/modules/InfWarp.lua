-- InfWarp.lua
local this={}

local InfButton=InfButton
local InfMain=InfMain

this.moveRightButton=InfButton.RIGHT
this.moveLeftButton=InfButton.LEFT
this.moveForwardButton=InfButton.UP
this.moveBackButton=InfButton.DOWN
this.moveUpButton=InfButton.DASH
this.moveDownButton=InfButton.ZOOM_CHANGE

--updateState
this.active="warpPlayerUpdate"
this.execCheckTable={inGame=true,inSafeSpace=false}
this.execState={
  nextUpdate=0,
}


this.registerIvars={
  "warpPlayerUpdate",
}

this.warpPlayerUpdate={
  inMission=true,
  nonConfig=true,
  --save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  isMode=true,
  --tex WIP OFF disableActions=PlayerDisableAction.OPEN_CALL_MENU+PlayerDisableAction.OPEN_EQUIP_MENU,
  OnModeActivate=function()InfMain.OnActivateWarpPlayer()end,
  OnChange=function(self,setting)
    if Ivars.adjustCameraUpdate:Is(1) then
      self:SetDirect(0)
      InfMenu.PrintLangId"other_control_active"
    end

    if setting==1 then
      InfMenu.PrintLangId"warp_mode_on"
      InfWarp.OnActivate()
    else
      InfMenu.PrintLangId"warp_mode_off"
      InfWarp.OnDeactivate()
    end

    if InfMenu.menuOn then
      InfMain.RestoreActionFlag()
      InfMenu.MenuOff()
    end
  end,
}
--< ivar defs
this.langStrings={
  eng={
    warpPlayerUpdate="Warp [Mode]",
    warp_mode_on="Warp mode on",
    warp_mode_off="Warp mode off",
  },
  help={
    eng={
      warpPlayerUpdate="Essentially no-clip mode (for those that remember what that means). It teleports your player a small distance each update of which warp direction button you press or hold. Will move you through walls/geometry. The menu navigation/dpad/arrow keys will warp you in that direction, [STANCE] will warp you down and [CALL] will warp you up.",
    },
  },
}
--<

function this.OnActivate()
  this.ActivateControlSet()
end

function this.ActivateControlSet()
  InfButton.buttonStates[this.moveRightButton].decrement=0.1
  InfButton.buttonStates[this.moveLeftButton].decrement=0.1
  InfButton.buttonStates[this.moveForwardButton].decrement=0.1
  InfButton.buttonStates[this.moveBackButton].decrement=0.1
  InfButton.buttonStates[this.moveUpButton].decrement=0.1
  InfButton.buttonStates[this.moveDownButton].decrement=0.1

  local repeatRate=0.06
  local repeatRateUp=0.04
  InfButton.buttonStates[this.moveRightButton].repeatRate=repeatRate
  InfButton.buttonStates[this.moveLeftButton].repeatRate=repeatRate
  InfButton.buttonStates[this.moveForwardButton].repeatRate=repeatRate
  InfButton.buttonStates[this.moveBackButton].repeatRate=repeatRate
  InfButton.buttonStates[this.moveUpButton].repeatRate=repeatRateUp
  InfButton.buttonStates[this.moveDownButton].repeatRate=repeatRate

  --WIP this.DisableAction(Ivars.warpPlayerUpdate.disableActions)
end

function this.OnDeactivate()
--this.EnableAction(Ivars.warpPlayerUpdate.disableActions)
end

function this.Update(currentChecks,currentTime,execChecks,execState)
  if currentChecks.inMenu then
    return
  end

  if not currentChecks.inGame or currentChecks.inSafeSpace then
    if Ivars.warpPlayerUpdate:Is(1) then
      Ivars.warpPlayerUpdate:Set(0)
    end
    return
  end

  if Ivars.warpPlayerUpdate:Is(0) then
    return
  end

  this.DoControlSet(currentChecks)
end

function this.DoControlSet(currentChecks)
  local warpAmount=1
  local warpUpAmount=1

  local moveDir={}
  moveDir[1]=0
  moveDir[2]=0
  moveDir[3]=0

  local didMove=false

  if InfButton.OnButtonDown(this.moveForwardButton)
    or InfButton.OnButtonRepeat(this.moveForwardButton) then
    moveDir[3]=warpAmount
    didMove=true
  end

  if InfButton.OnButtonDown(this.moveBackButton)
    or InfButton.OnButtonRepeat(this.moveBackButton) then
    moveDir[3]=-warpAmount
    didMove=true
  end

  if InfButton.OnButtonDown(this.moveRightButton)
    or InfButton.OnButtonRepeat(this.moveRightButton) then
    moveDir[1]=-warpAmount
    didMove=true
  end

  if InfButton.OnButtonDown(this.moveLeftButton)
    or InfButton.OnButtonRepeat(this.moveLeftButton) then
    moveDir[1]=warpAmount
    didMove=true
  end

  if InfButton.OnButtonDown(this.moveUpButton)
    or InfButton.OnButtonRepeat(this.moveUpButton) then
    moveDir[2]=warpUpAmount
    didMove=true
  end

  if InfButton.OnButtonDown(this.moveDownButton)
    or InfButton.OnButtonRepeat(this.moveDownButton) then
    moveDir[2]=-warpAmount
    didMove=true
  end

  if didMove then
    local currentPos = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
    local vMoveDir=Vector3(moveDir[1],moveDir[2],moveDir[3])
    local rotYQuat=Quat.RotationY(TppMath.DegreeToRadian(vars.playerRotY))
    local playerMoveDir=rotYQuat:Rotate(vMoveDir)
    local warpPos=currentPos+playerMoveDir
    --OFF TppPlayer.Warp{pos={warpPos:GetX(),warpPos:GetY(),warpPos:GetZ()},rotY=vars.playerCameraRotation[1]}
    
    --tex TODO: something not right about vehicle warp
    local rotY=vars.playerCameraRotation[1]
    
    local warperId=0--player
    if vars.playerVehicleGameObjectId~=GameObject.NULL_ID then
      warperId=vars.playerVehicleGameObjectId
    end
    
    InfTppUtil.Warp(warperId,TppMath.Vector3toTable(warpPos),rotY)
  end
end--DoControlSet

return this
