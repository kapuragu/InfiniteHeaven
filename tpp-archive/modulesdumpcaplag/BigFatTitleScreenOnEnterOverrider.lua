--the fuckin title screen camera overrrider
local this={}

function this.TitleModeOnEnterFunction()
  TppEffectUtility.SetFxCutLevelMaximum(5)
  GrTools.SetSubSurfaceScatterFade(1.0)    
  SimDaemon.SetForceStopSimWindEffect(true) 
  Player.RequestToPlayCameraNonAnimation {
    focalLength = 10.0,
    aperture = 2.0,
    focusDistance = 1.0,
    positionAndTargetMode = true,
    position = Vector3{ 0.2113, 1198.266, 0.206},
    target = Vector3{ -0.122, 1198.26, -0.45},
  }
  TppClock.Stop()
end

function this.MissionPrepare()
  if TppMission.IsHelicopterSpace(vars.missionCode) then
    --mvars.title_titleModeOnEnterFunction=this.TitleModeOnEnterFunction
  end
end

--[[ function this.SetVarsTitleHeliSpace()
  TppMission.VarResetOnNewMission()
  gvars.title_nextMissionCode=30010
  gvars.title_nextLocationCode=10
  vars.missionCode=30010
  vars.locationCode=10
  TppUiCommand.LoadoutSetForStartFromHelicopter()
  TppHelicopter.ResetMissionStartHelicopterRoute()
  TppPlayer.ResetInitialPosition()
  TppPlayer.ResetMissionStartPosition()
end

function this.LoadLibraries()
  TppVarInit.SetVarsTitleHeliSpace=this.SetVarsTitleHeliSpace
end ]]

return this