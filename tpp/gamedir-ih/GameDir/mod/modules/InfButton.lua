--InfButton.lua
--tex GOTCHA: the games elapsed time (via GetRawElapsedTimeSinceStartUp) actually runs to the game time update rate, which means it decreases/slows down during highspeedcam/slowmo
-- which means InfButtons (and other Inf stuff using GetElapsed) wont really respond during slowmo
-- unfortunately os.time only resturns in seconds which isn't enough granularity
-- currently using os.clock, GOTCHA: os.clock wraps at ~4,294 seconds
--GOTCHA: TODO RESEARCH: I there may be some game states where PlayerVars.scannedButtonsDirect is not updated by the exe, yet normal calls to lua Update continue
--most clear example being when doing player 'warp to latest marker' (before code was changed to close menu, disable that WORKAROUND to test) via activating via pressing right menu.
--button.RIGHT on PlayerVars.scannedButtonsDirect will remain set, but lua updates continue, which will repeatedly trigger the menu option via InfMenu.Update till scannedButtonsDirect is updated again after TppPlayer.Warp is done 
--one solution would be to see if there's some unique flag/status set during TppPlayer.Warp to check, ideally something generic/that covers other states so that you can skip InfMenu.Update while its on
-- NODEPS
local this={}
--LOCALOPT:
local bit=bit
local band=bit.band
local Time=Time
local PlayerVars=PlayerVars
local pairs=pairs
local ipairs=ipairs
--CULL local ElapsedTime=Time.GetRawElapsedTimeSinceStartUp
local ElapsedTime=os.clock--tex using os.clock since Time.GetRawElapsedTimeSinceStartUp is affected by game time scale (highspeedcam etc) GOTCHA: os.clock wraps at ~4,294 seconds

local maxIncrementMult=50
local defaultIncrementMult=1
--STATE:
this.incrementMultIncrementMult=1.5--tex i r good at naming
local currentIncrementMult=defaultIncrementMult
this.buttonStates={}

--buttonMasks: expanded alternative to PlayerPad
--these masks are folded back into InfButton, so you can use them like InfButton.DASH etc
--DOC: \BUTTON BITMASKS.TXT \buttonmasks.ods
--tex Note: There were a bunch of bitmasks not identified in PlayerPad.<MASKNAME>.
--Currently either labeled UNKOWN, as seen from the existing codes it's possible that there's multiple buttons triggering/sharing one bitmask, so even after 'finding it' copy off instead of rename
--fox engine seems to be using bitops http://bitop.luajit.org
--converted in-place from index to mask in TABESETUP below
--GOTCHA: there's some identical button masks here, most are just what PlayerPad has, but there's a couple I just added as alternate names.
this.buttonMasks={
  DECIDE=0,
  STANCE=1,
  DASH=2,
  HOLD=3,--tex ready weapon
  READY_WEAPON=3,--tex added as friendly alternate to HOLD (based on what its called in games Controls menu)
  FIRE=4,
  ACTION=5,
  MOVE_ACTION=5,
  JUMP=5,
  RIDE_ON=5,
  RIDE_OFF=5,
  CQC_KNIFE_KILL=5,
  RELOAD=6,
  CARRY=6,
  STOCK=7,--tex recenter cam
  ZOOM_CHANGE=7,
  VEHICLE_CHANGE_SIGHT=7,
  MB_DEVICE=8,
  CALL=9,
  INTERROGATE=9,
  SUBJECT=10,--tex tap:recenter 3rd person view, hold: binoculars/First person view --TODO see if trigger on binocular, and see if disable butttons is the same
  BINOCULARS=10,--tex added as friendly alternate to SUBJECT (based on what its called in games Controls menu)
  UP=11,
  PRIMARY_WEAPON=11,
  DOWN=12,
  SECONDARY_WEAPON=12,
  LEFT=13,
  RIGHT=14,
  VEHICLE_LIGHT_SWITCH=14,
  VEHICLE_TOGGLE_WEAPON=14,
  CQC=15,
  SIDE_ROLL=16,
  LIGHT_SWITCH=17,
  EVADE=18,
  DIVE=18,--tex added as friendly alternate to EVADE (based on what its called in games Controls menu)
  SKILL=18,--SSD
  VEHICLE_FIRE=19,
  VEHICLE_CALL=20,
  VEHICLE_DASH=21,
  BUTTON_PLACE_MARKER=22,
  PLACE_MARKER=22,
  ESCAPE=23,--tex Not in PlayerPad, own name. Keyboard
  UNKNOWN7=24,--tex triggered with Space/Quick dive, and RS click (which also triggers zoom change, stock, decide,vehicle_change_sight), don't know what it's supposed to indicate
  --
  WALK=25,--tex not in PlayerPad, Keyboard
  UNKNOWN9=26,
  UNKNOWN10=27,
  UNKNOWN11=28,
  UNKNOWN12=29,
  UNKNOWN13=30,
  
  --tex Also in PlayerPad, for PlayerVars.leftStickDirect, rightbleh
  --don't where triggers are, wouldnt think scannedButtonsDirect
  STICK_L=0,
  STICK_R=1,
  TRIGGER_BREAK=0,
  TRIGGER_ACCEL=1,
  TRIGGER_L=0,
  TRIGGER_R=1,
--MAX=2^31,--tex max_int=(2^31)-1, guess at a sane enough limit, though should check bitops to figure out actual.
}
this.NONE=0
this.ALL=-1

local buttonMasks=this.buttonMasks

--TABLESETUP: buttonMasks --tex convert mask index to bitmask
for name,maskIndex in pairs(buttonMasks) do
  buttonMasks[name]=2^maskIndex
end

--TABLESETUP: InfButton --tex for convenience of external reference fold back into this./InfButton
for name,maskIndex in pairs(buttonMasks) do
  this[name]=maskIndex
end

--TABLESETUP: buttonStates REFACTOR: check which vars dont really need to be per button
local buttonStates=this.buttonStates
for name,buttonMask in pairs(buttonMasks) do
  local buttonState={}
  buttonStates[buttonMask]=buttonState
  buttonState.name=name
  buttonState.isPressed=false
  buttonState.holdTime=0.9--REFACTOR: this vs repeatrate
  buttonState.repeatRate=0.85
  --button.minRate=0.3
  buttonState.decrement=0
  buttonState.repeatStart=0--tex used for repeat
  buttonState.heldStart=0--tex delay between actually being pressed and considered being 'held'
  buttonState.onHoldStart=0--tex as above, but resets
end

function this.DEBUG_PrintPressed()
  if Ivars and Ivars.printPressedButtons:Is(1) then
    for name,buttonMask in pairs(buttonMasks) do
      if this.OnButtonDown(buttonMask) then
        --TppUiCommand.AnnounceLogView("scannedButtonsDirect: ".. PlayerVars.scannedButtonsDirect)
        --TppUiCommand.AnnounceLogView("scannedButtons: ".. PlayerVars.scannedButtons)
        --if band(PlayerVars.scannedButtonsDirect,buttonMask)==buttonMask then--DEBUG: scannedbuttons instead of direct
        InfCore.Log(name.."="..buttonMask,true)
      end
    end
  end
end
function this.UpdateHeld()
  local elapsedTime=ElapsedTime()
  for name,buttonMask in pairs(buttonMasks) do
    local buttonState=buttonStates[buttonMask]
    if (band(PlayerVars.scannedButtonsDirect,buttonMask)==buttonMask) then
      --OnButtonDown
      if not buttonState.isPressed then
        buttonState.repeatStart=elapsedTime
        if buttonState.holdTime~=0 then
          buttonState.heldStart=elapsedTime
          buttonState.onHoldStart=elapsedTime
        end
      end
    else
      buttonState.repeatStart=0
      buttonState.heldStart=0
      buttonState.onHoldStart=0
    end
  end
end
function this.UpdatePressed()
  this.DEBUG_PrintPressed()
  local scannedButtonsDirect=PlayerVars.scannedButtonsDirect
  for name,buttonMask in pairs(buttonMasks) do
    buttonStates[buttonMask].isPressed=band(scannedButtonsDirect,buttonMask)==buttonMask--this.ButtonDown(buttonMask)
  end
end
function this.UpdateRepeatReset()
  for name,buttonMask in pairs(buttonMasks) do
    local buttonState=buttonStates[buttonMask]
    if buttonState.decrement~=0 then
      if buttonState.isPressed and not (band(PlayerVars.scannedButtonsDirect,buttonMask)==buttonMask) then--tex OnButtonUp reset
        currentIncrementMult=defaultIncrementMult
      end
    end
  end
end

function this.ButtonDown(buttonMask)
  --  if band(PlayerVars.scannedButtonsDirect,buttonMask)==buttonMask then
  --    TppUiCommand.AnnounceLogView("ButtonDown:" .. buttonMask)--tex DEBUG
  --  end
  return band(PlayerVars.scannedButtonsDirect,buttonMask)==buttonMask
end
--tex GOTCHA: OnButton functions will have a gameframe of latency, sorry to dissapoint all the pro gamers
function this.OnButtonDown(buttonMask)
  return not buttonStates[buttonMask].isPressed and (band(PlayerVars.scannedButtonsDirect,buttonMask)==buttonMask)
end
function this.OnButtonUp(buttonMask)
  return buttonStates[buttonMask].isPressed and not (band(PlayerVars.scannedButtonsDirect,buttonMask)==buttonMask)
end
--tex button has been down for holdTime
function this.ButtonHeld(buttonMask)
  local buttonState=buttonStates[buttonMask]
  if buttonState.holdTime~=0 and buttonState.heldStart~=0 then
    if buttonState.isPressed then
      if ElapsedTime()>buttonState.heldStart+buttonState.holdTime then
        return true
      end
    end
  end
  return false
end
--tex button has been down for holdTime, only true once per hold
function this.OnButtonHoldTime(buttonMask)
  local buttonState=buttonStates[buttonMask]
  if buttonState.isPressed then
    if buttonState.holdTime~=0 and buttonState.onHoldStart~=0 then
      if ElapsedTime()>buttonState.onHoldStart+buttonState.holdTime then
        buttonState.onHoldStart=0
        return true
      end
    end
  end
  return false
end
function this.OnButtonRepeat(buttonMask)
  local buttonState=buttonStates[buttonMask]
  if buttonState.decrement~=0 then
    if buttonState.isPressed and not (band(PlayerVars.scannedButtonsDirect,buttonMask)==buttonMask) then--tex OnButtonUp reset
      --buttonState.repeatRate=buttonState.holdTime
      currentIncrementMult=defaultIncrementMult
      return false
    end
    --local repeatRate=buttonState.repeatRate
    --if repeatRate~=0 and
    if buttonState.repeatStart~=0 then
      if ElapsedTime()-buttonState.repeatStart>buttonState.repeatRate then
        buttonState.repeatStart=ElapsedTime()
        --OFF:    if repeatRate > buttonState.minRate then
        --          repeatRate=repeatRate-buttonState.decrement
        --        end
        --        buttonState.repeatRate=repeatRate--]]
        currentIncrementMult=currentIncrementMult*this.incrementMultIncrementMult
        --TppUiCommand.AnnounceLogView("DBG:MNU: currentIncrementMult:".. currentIncrementMult)--tex DEBUG
        if currentIncrementMult>maxIncrementMult then
          currentIncrementMult=maxIncrementMult
        end
        return true
      end
    end
  end
  return false
end

function this.GetRepeatMult()
  return currentIncrementMult
end

--tex all buttons in combo must be held TODO: some weirdness with trying to check multiple combos
function this.OnComboActive(combo)
  local comboActive=true
  for i,button in ipairs(combo)do
    if not this.ButtonHeld(button) then
      comboActive=false
      break
    end
  end

  if comboActive then
    for i,button in ipairs(combo)do
      buttonStates[button].heldStart=0
    end
    return true
  end

  return false
end

function this.ResetRepeat(buttonMask)
  local buttonState=buttonStates[buttonMask]
  buttonState.repeatStart=0
  buttonState.heldStart=0
  buttonState.onHoldStart=0
end

return this
