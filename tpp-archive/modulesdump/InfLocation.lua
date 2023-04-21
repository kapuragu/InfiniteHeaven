-- DOBUILD: 0 --DEBUGWIP
-- InfLocation.lua
local this={}

function this.StartTitle(unknown1)
  vars.locationCode=TppDefine.LOCATION_ID.AFGH
  vars.missionCode=40010
  TppMission.ResetNeedWaitMissionInitialize()
  gvars.ini_isTitleMode=true
  gvars.ini_isReturnToTitle=false
  TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
  vars.initialPlayerAction=PlayerInitialAction.STAND
  TppPlayer.ResetDisableAction()
  TppPlayer.ResetInitialPosition()
  TppPlayer.ResetMissionStartPosition()
  TppMission.ResetIsStartFromHelispace()
  TppMission.ResetIsStartFromFreePlay()
  TppMission.VarResetOnNewMission()
--  if clock then
--    TppClock.SetTime(clock)
--    TppClock.SaveMissionStartClock()
--  end
--  TppSimpleGameSequenceSystem.Start()
local currentMissionCode=nil
  TppMission.Load(vars.missionCode,currentMissionCode,{force=true})
--  local actMode=Fox.GetActMode()
--  if(actMode=="EDIT")then
--    Fox.SetActMode"GAME"
--    end
end

return this