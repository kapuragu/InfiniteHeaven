-- InfTimeScale.lua
local this={}

this.registerIvars={
  "clockTimeScale",
  "clock_setTime",
  --rlc v
  "clock_setMinute",
  "clock_setSecond",
  --rlc ^
  "speedCamContinueTime",
  "speedCamWorldTimeScale",
  "speedCamPlayerTimeScale",
  "speedCamNoDustEffect",
}

this.clockTimeScale={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=20,
  range={max=10000,min=0,increment=1},
  OnChange=function()
    --if not DemoDaemon.IsDemoPlaying() then
    if not mvars.mis_missionStateIsNotInGame then
      TppClock.Start()
    end
    --end
  end
}
if InfCore.gameId=="SSD" then
  this.clockTimeScale.default=15
end

this.clock_setTime={
  inMission=true,
  --save=IvarProc.CATEGORY_EXTERNAL,
  default=12,
  range={max=23,min=0,increment=1},
  --[[ GetSettingText=function(self,setting)
    return "00"--string.format("%02d:00",setting)
  end, ]]
  --OFF tex will trigger when IHExt fills menu
--  OnSelect=function(self)
--    local hour,minute,second=TppClock.GetTime"time"
--    self:Set(hour) 
--  end,
  OnChange=function(self,setting)
     --TppClock.SetTime(string.format("%02d:00:00",setting))
     this.UpdatePreciseTime() --rlc
  end
}

--rlc v
function this.UpdatePreciseTime()
  local hour = Ivars.clock_setTime:Get() or 12
  local minute = Ivars.clock_setMinute:Get() or 0
  local second = Ivars.clock_setSecond:Get() or 0
  TppClock.SetTime(string.format("%02d:%02d:%02d",hour,minute,second))
end
this.clock_setMinute={
  inMission=true,
  default=0,
  range={max=59,min=0,increment=1},
  OnChange=this.UpdatePreciseTime
}
this.clock_setSecond={
  inMission=true,
  default=0,
  range={max=59,min=0,increment=1},
  OnChange=this.UpdatePreciseTime
}
--rlc ^
       

--highspeedcamera/slowmo
this.speedCamContinueTime={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=10,
  range={max=1000,min=0,increment=1},
}
this.speedCamWorldTimeScale={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0.3,
  range={max=100,min=0,increment=0.1},
}
this.speedCamPlayerTimeScale={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=1,
  range={max=100,min=0,increment=0.1},
}

this.speedCamNoDustEffect={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}
--<

--higspeedcamera / slowmo
local highSpeedCamToggle=false
local highSpeedCamStartTime=0
this.HighSpeedCameraToggle=function()
  --GOTCHA: toggle could fail on reload or other cam requestcancel with a long continuetime/highSpeedCamStartTime
  --      local elapsedTime=Time.GetRawElapsedTimeSinceStartUp()
  --      if elapsedTime>highSpeedCamStartTime then--cam timed out
  --        highSpeedCamToggle=true
  --      else
  --        highSpeedCamToggle=false
  --      end

  highSpeedCamToggle=not highSpeedCamToggle

  if highSpeedCamToggle then
    local continueTime=Ivars.speedCamContinueTime:Get()
    local worldTimeRate=Ivars.speedCamWorldTimeScale:Get()
    local localPlayerTimeRate=Ivars.speedCamPlayerTimeScale:Get()
    local timeRateInterpTimeAtStart=0
    local timeRateInterpTimeAtEnd=0
    local cameraSetUpTime=0
    local noDustEffect=Ivars.speedCamNoDustEffect:Is(1)

    --highSpeedCamStartTime=elapsedTime+continueTime

    HighSpeedCamera.RequestEvent{continueTime=continueTime,worldTimeRate=worldTimeRate,localPlayerTimeRate=localPlayerTimeRate,timeRateInterpTimeAtStart=timeRateInterpTimeAtStart,timeRateInterpTimeAtEnd=timeRateInterpTimeAtEnd,cameraSetUpTime=cameraSetUpTime,noDustEffect=noDustEffect}

    --InfMenu.PrintLangId"highspeedcam_on"--DEBUG

    --DEBUGNOW TppPlayer2CallbackScript._SetHighSpeedCamera=this.SetHighSpeedCameraCleared --DEBUGNOW
  else
    highSpeedCamStartTime=0

    HighSpeedCamera.RequestToCancel()

    --DEBUGNOW TppPlayer2CallbackScript._SetHighSpeedCamera=this.SetHighSpeedCameraDefault

    InfMenu.PrintLangId"highspeedcam_cancel"
  end
end
--DEBUGNOW
this.SetHighSpeedCameraCleared=function()end
this.SetHighSpeedCameraDefault=function(decayRate,timeRate)
  HighSpeedCamera.RequestEvent{continueTime=decayRate,worldTimeRate=timeRate,localPlayerTimeRate=timeRate,timeRateInterpTimeAtStart=0,timeRateInterpTimeAtEnd=0,cameraSetUpTime=0}
end


this.registerMenus={
  "timeScaleMenu",
}

this.timeScaleMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu","InfMenuDefs.inDemoMenu"},
  options={
    "InfTimeScale.HighSpeedCameraToggle",
    "Ivars.speedCamContinueTime",
    "Ivars.speedCamWorldTimeScale",
    "Ivars.speedCamPlayerTimeScale",
    "Ivars.speedCamNoDustEffect",
    "Ivars.clockTimeScale",
    "Ivars.clock_setTime",
    --rlc v
    "Ivars.clock_setMinute",
    "Ivars.clock_setSecond",
    --rlc ^
  }
}

this.langStrings={
  eng={
    timeScaleMenu="Time scale menu",
    highSpeedCameraToggle="Toggle TSM",
    speedCamContinueTime="TSM length (seconds)",
    speedCamWorldTimeScale="TSM world time scale",
    speedCamPlayerTimeScale="TSM player time scale",
    speedCamNoDustEffect="No screen effect",
    highspeedcam_cancel="TSM cancel",
    clockTimeScale="Clock time scale",
    --clock_setTime="Set clock time",
    --rlc v
    clock_setTime="Set clock hour",
    clock_setMinute="Set clock minute",
    clock_setSecond="Set clock second",
    --rlc ^
  },
  help={
    eng={
      highSpeedCameraToggle="Lets you manually toggle Time scale mode that's usually used for Reflex/CQC.",
      speedCamContinueTime="The time in seconds of the TSM",
      speedCamWorldTimeScale="Time scale of the world, including soldiers/vehicles during TSM",
      speedCamPlayerTimeScale="Time scale of the player during TSM",
      speedCamNoDustEffect="Does not apply the dust and blur effect while TSM is active.",
      clockTimeScale="Changes the time scale of the day/night/weather system. Does not change the speed of soldiers like the cigar does. Lower for closer to real time, higher for faster.",
    },
  }
}

return this
