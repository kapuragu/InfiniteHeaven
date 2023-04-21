--RealTimeScaleAndLocalTimeIH.lua
local this={}
local varsclockTimeScale=-1

function this.PostAllModulesLoad()
	TppClock.SetTimeFromHelicopterSpace=function(deployTime,fromLocation,toLocation)
	end
end

function this.Update()

  if mvars.mis_missionStateIsNotInGame then
    varsclockTimeScale=-1
    return
  end
  
  if mvars.mis_loadRequest then
    varsclockTimeScale=-1
    return
  end

  if vars.missionCode==50050 then return end

  --tex handle pause.
  if bit.band(PlayerVars.scannedButtonsDirect,InfButton.ESCAPE)==InfButton.ESCAPE then
    varsclockTimeScale=-1
  end
  
  if varsclockTimeScale~=vars.clockTimeScale then
--    TppPlayer.TUPPMPrint("vars.clockTimeScale: "..tostring(vars.clockTimeScale))
    
    local todaysDate=os.date("*t")
    local todaysTime=todaysDate.hour*60*60+todaysDate.min*60+todaysDate.sec
  
    if
      vars.clockTimeScale==3600 
--      or (vars.clockTimeScale>=0 and vars.clockTimeScale<1) --Not necessary - high speed cam is safe
    then
--      TppPlayer.TUPPMPrint("Using cigar")
--    TppCommand.Weather.SetClockTimeScale(vars.clockTimeScale) --this defines actual time scale
    else
--      TppPlayer.TUPPMPrint("Normal gameplay so setting time scale")
      vars.clock=todaysTime
      vars.clockTimeScale=1
--      TppCommand.Weather.SetClockTimeScale(vars.clockTimeScale) --this defines actual time scale
    end
    varsclockTimeScale=vars.clockTimeScale
  end
end

return this