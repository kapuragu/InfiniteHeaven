-- InfHelicopter.lua
-- tex support heli stuff
-- CONTROLSET: (not really, should probably be formalized)
--  [STANCE] hold: open door (mission start) or toggle pull out

--RequestHeliLzToLastMarkerAlt / "Support heli to marker" sends heli to nearest custom single point route, see this.packages
--TODO: addon support (and guide on creating the hover routes)

local this={}

--LOCALOPT
local NULL_ID=GameObject.NULL_ID
local GetGameObjectId=GameObject.GetGameObjectId
local SendCommand=GameObject.SendCommand
local IsTimerActive=GkEventTimerManager.IsTimerActive
local InfButton=InfButton

this.debugModule=false

--updateState
this.active=1--"heliUpdate"
this.execCheckTable={inGame=true,inSafeSpace=false}
this.execState={
  nextUpdate=0,
}

--STATE
this.trackForceRoute=0

this.requestedRoute=nil

function this.PostModuleReload(prevModule)
  this.trackForceRoute=prevModule.trackForceRoute

  this.requestedRoute=prevModule.requestedRoute
end--PostModuleReload


local TRACK_FORCEROUTE_NONE=0
local TRACK_FORCEROUTE_WAITFOREXIT=1
local TRACK_FORCEROUTE_EXITED=2

this.registerIvars={
  "disableHeliAttack",
  "defaultHeliDoorOpenTime",
  "enableGetOutHeli",
  "setInvincibleHeli",
  "setTakeOffWaitTime",
  "disablePullOutHeli",
  "setLandingZoneWaitHeightTop",
  "disableDescentToLandingZone",
  "setSearchLightForcedHeli",
}

this.disableHeliAttack={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self)
    local enable=self:Is(0)
    local gameObjectId = GetGameObjectId("TppHeli2", "SupportHeli")
    if gameObjectId~=nil and gameObjectId~=NULL_ID then
      SendCommand(gameObjectId,{id="SetCombatEnabled",enabled=enable})
    end
  end,
}

--support heli
--this.heliUpdate={--tex NONUSER, InfHeli always active to pick up pull out
--  --save=MISSION,
--  nonUser=true,
--  default=1,
--  range=Ivars.switchRange,
--  settingNames="set_switch",
--}

--Dependants: TppMission
this.defaultHeliDoorOpenTime={--seconds
  save=IvarProc.CATEGORY_EXTERNAL,
  default=15,
  range={min=0,max=120},
}

this.enableGetOutHeli={--WIP UNUSED TEST force every frame via update to see if it actually does anything beyond the allow get out when allready at LZ
  inMission=true,
  --OFF save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    local enable=setting==1
    local gameObjectId = GetGameObjectId("TppHeli2", "SupportHeli")
    if gameObjectId ~= nil and gameObjectId ~= NULL_ID then
      SendCommand(gameObjectId,{id="SetGettingOutEnabled",enabled=enable})
    end
  end,
}

this.setInvincibleHeli={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    local enable=setting==1
    local gameObjectId=GetGameObjectId("TppHeli2","SupportHeli")
    if gameObjectId ~= nil and gameObjectId ~= NULL_ID then
      SendCommand(gameObjectId,{id="SetInvincible",enabled=enable})
    end
  end,
}

this.setTakeOffWaitTime={--tex NOTE: 0 is wait indefinately WIP TEST, maybe it's not what I think it is, check the instances that its used and see if its a take-off empty wait or take-off with player in wait
  inMission=true,
  --OFF save=IvarProc.CATEGORY_EXTERNAL,
  default=5,--tex from TppHelicopter.SetDefaultTakeOffTime
  range={min=0,max=15},
  OnChange=function(self,setting)
    local gameObjectId=GetGameObjectId("TppHeli2", "SupportHeli")
    if gameObjectId~=nil and gameObjectId~=NULL_ID then
      SendCommand(gameObjectId,{id="SetTakeOffWaitTime",time=setting})
    end
  end,
}

this.disablePullOutHeli={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    local set=setting==1
    local gameObjectId=GetGameObjectId("TppHeli2", "SupportHeli")
    if gameObjectId~=nil and gameObjectId~=NULL_ID then
      if set then
        SendCommand(gameObjectId,{id="DisablePullOut"})
      else
        --SendCommand(gameObjectId,{id="SetForceRoute",enabled=false})
        SendCommand(gameObjectId,{id="EnablePullOut"})
      end
      InfHelicopter.HeliOrderRecieved()
    end
  end,
}

this.setLandingZoneWaitHeightTop={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=20,--tex the command is only used in sahelan mission, so don't know if this is actual default,
  range={min=5,max=50,increment=5},
  OnChange=function(self,setting)
    local gameObjectId=GetGameObjectId("TppHeli2", "SupportHeli")
    if gameObjectId~=nil and gameObjectId~=NULL_ID then
      SendCommand(gameObjectId,{id="SetLandingZoneWaitHeightTop",height=setting})
    end
  end,
}

this.disableDescentToLandingZone={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    local set=setting==1
    local gameObjectId=GetGameObjectId("TppHeli2", "SupportHeli")
    if gameObjectId~=nil and gameObjectId~=NULL_ID then
      local command
      if set then
        command="DisableDescentToLandingZone"
      else
        command="EnableDescentToLandingZone"
      end
      SendCommand(gameObjectId,{id=command})
    end
  end,
}

this.setSearchLightForcedHeli={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={"DEFAULT","OFF","ON"},
  settingNames="set_default_off_on",
  OnChange=function(self,setting)
    local gameObjectId=GetGameObjectId("TppHeli2","SupportHeli")
    if gameObjectId~=nil and gameObjectId~=NULL_ID then
      local command
      if setting==1 then
        command={id="SetSearchLightForcedType",type="On"}
      elseif setting==2 then
        command={id="SetSearchLightForcedType",type="Off"}
      end
      if command then
        SendCommand(gameObjectId,command)
        InfHelicopter.HeliOrderRecieved()
      end
    end
  end,
}
--< ivar defs
this.registerMenus={
  "supportHeliMenu",
}

this.supportHeliMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
  options={
    --"Ivars.setTakeOffWaitTime",
    --"InfHelicopter.PullOutHeli",
    --"InfHelicopter.ChangeToIdleStateHeli",
    "Ivars.disableHeliAttack",
    "Ivars.setInvincibleHeli",
    "Ivars.setSearchLightForcedHeli",
    "Ivars.disablePullOutHeli",
    "Ivars.setLandingZoneWaitHeightTop",
    "Ivars.defaultHeliDoorOpenTime",
    "Ivars.disableLzs",
    --tex LEGACY position, new location is in helispaceSettingsMenu
    "Ivars.startOnFootFREE",
    "Ivars.startOnFootMISSION",
    "Ivars.startOnFootMB_ALL",
  --"Ivars.disableDescentToLandingZone",
  --"Ivars.enableGetOutHeli",--WIP
  },
}
--< menu defs
this.langStrings={
  eng={
    supportHeliMenu="Support heli menu",
    setInvincibleHeli="Set heli invincible",
    disablePullOutHeli="Disable pull-out",
    setLandingZoneWaitHeightTop="Set LZ wait height",
    defaultHeliDoorOpenTime="Mission start time till open door",
    setSearchLightForcedHeli="Force searchlight",
    set_disable={"On","Off"},
    heli_pulling_out="Pulling out in 5",
    heli_hold_pulling_out="Holding",
    order_recieved="Order recieved",
    must_be_in_helicopter="Must be in helicopter",
    cannot_use_at_mission_start="Cannot use during mission start",
    requestHeliLzToLastMarker="Support heli to latest marker",
    requestHeliLzToLastMarkerAlt="Support heli to marker",
    no_lz_found="No landing zone found",
    forceExitHeli="Force exit helicopter",
    forceExitHeliAlt="Force exit helicopter",
    not_in_heli="You are not in the helicopter",
    not_for_location="This command is not enabled for this location",
    already_heading_to_lz="Already heading to that lz";
    heading_to_lz="Heading to lz";
    disableHeliAttack="Disable support heli attack",
  },
  help={
    eng={
      setLandingZoneWaitHeightTop="Set the height at which the heli hovers in wait mode (not landing mode).",
      defaultHeliDoorOpenTime="Time from mission start to you opening the door to sit on the side. You can set this lower or 0 to do it immediately, or longer to ride the heli in first person. Press [STANCE] to manually open the door.",
      disablePullOutHeli="Prevents heli from leaving when you jump on-board, so you can use the gun from a stationary position, or just change your mind and jump out again. Press [STANCE] while in the heli to get it to pull-out again (or use menu). NOTE: Disable pull-out will prevent the mother base helitaxi selection menu, press [STANCE] to re-enable or use the mod menu.",
      requestHeliLzToLastMarkerAlt="Sends Support heli to Landing Zone closest to the last placed user marker while riding it.",
      forceExitHeliAlt="Lets you exit the helicopter while riding it, mind the fall.",
      disableHeliAttack="Stops support heli from engaging targets.",
    },
  },
}

this.packages={
  afgh={
    "/Assets/tpp/pack/mission2/ih/ih_support_heli_hover_routes_afgh.fpk",--tex for RequestHeliLzToLastMarkerAlt
  },
  mafr={
    "/Assets/tpp/pack/mission2/ih/ih_support_heli_hover_routes_mafr.fpk",--tex for RequestHeliLzToLastMarkerAlt
  },
}

function this.AddMissionPacks(missionCode,packPaths)
  if InfMain.IsSafeSpace(missionCode) then
    return
  end
  --DEBUGNOW some kind of limiter to free / missions

  for i,packPath in ipairs(this.packages) do
    packPaths[#packPaths+1]=packPath
  end

  local locationName=TppLocation.GetLocationName()
  if this.packages[locationName] then
    for i,packPath in ipairs(this.packages[locationName]) do
      packPaths[#packPaths+1]=packPath
    end
  end
end

function this.Init()
  if InfMain.IsOnlineMission(vars.missionCode) then
    return
  end

  --update heli vars
  --texcalled from TppMain.Onitiialize, so should only be 'enable/change from default', VERIFY it's in the right spot to override each setting
  local heliId=GetGameObjectId("TppHeli2","SupportHeli")
  if heliId==nil or heliId==NULL_ID then
    return
  end

  if Ivars.disableHeliAttack:Is(1) then--tex disable heli be fightan
    SendCommand(heliId,{id="SetCombatEnabled",enabled=false})
  end
  if Ivars.setInvincibleHeli:Is(1) then
    SendCommand(heliId,{id="SetInvincible",enabled=true})
  end
  if not Ivars.setTakeOffWaitTime:IsDefault() then
    SendCommand(heliId,{id="SetTakeOffWaitTime",time=Ivars.setTakeOffWaitTime:Get()})
  end
  if Ivars.disablePullOutHeli:Is(1) then
    --if not TppLocation.IsMotherBase() and not TppLocation.IsMBQF() then--tex aparently disablepullout overrides the mother base taxi service TODO: not sure if I want to turn this off to save user confusion, or keep consistant behaviour
    SendCommand(heliId,{id="DisablePullOut"})
    --end
  end
  if not Ivars.setLandingZoneWaitHeightTop:IsDefault() then
    SendCommand(heliId,{id="SetLandingZoneWaitHeightTop",height=Ivars.setLandingZoneWaitHeightTop:Get()})
  end
  if Ivars.disableDescentToLandingZone:Is(1) then
    SendCommand(heliId,{id="DisableDescentToLandingZone"})
  end
  if Ivars.setSearchLightForcedHeli:Is"ON" then
    SendCommand(heliId,{id="SetSearchLightForcedType",type="On"})
  elseif Ivars.setSearchLightForcedHeli:Is"OFF" then
    SendCommand(heliId,{id="SetSearchLightForcedType",type="Off"})
  end

  --if TppMission.IsMbFreeMissions(vars.missionCode) then--TEST no aparent result on initial testing, in-engine pullout check must be overriding
  --  TppUiStatusManager.UnsetStatus( "MbMap", "BLOCK_TAXI_CHANGE_LOCATION" )
  --end
  
  --tex clear RequestHeliLzToLastMarkerAlt stuff
  this.requestedRoute=nil
  this.trackForceRoute=0
end

function this.Update(currentChecks,currentTime,execChecks,execState)
  --local Ivars=Ivars

  if currentChecks.inIdroid then
    return
  end

  local heliId=GetGameObjectId("TppHeli2","SupportHeli")
  if heliId==nil or heliId==NULL_ID then
    return
  end

  --tex for RequestHeliLzToLastMarkerAlt to turn off SetForceRoute when done (exited heli)
  if this.trackForceRoute==TRACK_FORCEROUTE_WAITFOREXIT then
    --tex waits till -v-
    if not currentChecks.inSupportHeli then
      --tex cant CallToLandingZoneAtName on the same frame as cancelling forceroute
      this.trackForceRoute=TRACK_FORCEROUTE_EXITED

      InfCore.Log("InfHeliCopter trackForceRoute not inSupportHeli, disabling forceroute")

      SendCommand(heliId,{id="SetForceRoute",enabled=false})
    end
  elseif this.trackForceRoute==TRACK_FORCEROUTE_EXITED then
    --tex likewise SetForceRoute doesn't seem to actually (game)update unless pullout is forced.
    this.trackForceRoute=TRACK_FORCEROUTE_NONE

    InfCore.Log("InfHeliCopter trackForceRoute EXITING")--DEBUG

    --GOTCHA: once heli is released from setforceroute it will return to its actually set LZ.
    --WORKAROUND: just dismiss it DEBUGNOW see if you need both
    --SendCommand(heliId,{id="EnablePullOut"})
    SendCommand(heliId,{id="PullOut",forced=true})

    --CallToLandingZoneAtName will only update if player not in heli and heli not forceroute, which is why it wasn't via RequestHeliLzToLastMarkerAlt
    --tex DEBUGNOW TODO OFF till VERIFY CallToLandingZoneAtName pretty much locks the heli into the lz till dismissed?
    --and make it an option between this-v- and just pulling out -^-
    --DEBUGNOW surely I have a simpler way of getting (simply sending to closestroute doesnt work, figure it out and document what CallToLandingZoneAtName actually wants)
--    local locationName=TppLocation.GetLocationName()
--    if this.packages[locationName]==nil then
--      InfCore.Log("InfHeliCopter .trackForceRoute - not for location")
--    else
--      local currentPos={vars.playerPosX,vars.playerPosY,vars.playerPosZ}
--      local closestRoute=InfLZ.GetClosestLz(currentPos)  
--      if closestRoute==nil then
--        InfCore.Log("InfHeliCopter .trackForceRoute - no lz found")
--      else
--        if not TppLandingZone.assaultLzs[locationName] and not TppLandingZone.missionLzs[locationName] then
--          InfCore.Log("InfHeliCopter .trackForceRoute - no lzs for location")
--        else
--          local lzName=TppLandingZone.assaultLzs[locationName][closestRoute] or TppLandingZone.missionLzs[locationName][closestRoute]
--          if lzName==nil then
--            InfCore.Log("lzName==nil")
--          else
--            local lzInfo=InfLZ.lzInfo[lzName]
--            if not lzInfo then
--              InfCore.Log("InfHeliCopter .trackForceRoute - no lzInfo for "..tostring(lzName))
--            else
--              closestRoute=lzInfo.returnRoute
--              --closestRoute=lzInfo.approachRoute
--              --closestRoute=lzInfo.dropRoute
--            end
--
--            SendCommand(heliId,{id="CallToLandingZoneAtName",name=lzName})
--          end--if lzName
--        end--lzs for location
--      end--if closestroute
--    end--if location

  end--trackForceRoute

  --if Ivars.enableGetOutHeli:Is(1) then--TEST not that useful
  -- SendCommand(heliId, { id="SetGettingOutEnabled", enabled=true })
  --end

  --tex TODO some kind of periodic print if player in heli and pullout disabled (in any way, by temporary button press or actual ivar set)

  if not currentChecks.inMenu and currentChecks.inSupportHeli then
    --tex WORKAROUND TODO why isnt this firing if set to 0.9 or above
    InfButton.buttonStates[InfButton.STANCE].holdTime=0.85
    --tex TODO also make so disablepullout ivar doesnt apply in mother base, or do seperate ivar
    if InfButton.OnButtonHoldTime(InfButton.STANCE) then
      --InfCore.DebugPrint"STANCE"--DEBUG
      --if not currentChecks.initialAction then--tex heli ride in TODO: RETRY: A reliable mission start parameter
      if IsTimerActive"Timer_MissionStartHeliDoorOpen" then
        --InfCore.DebugPrint"IsTimerActive"--DEBUG
        SendCommand(heliId,{id="RequestSnedDoorOpen"})
      else
        if Ivars.disablePullOutHeli:Is(1) then
          --CULL SendCommand(heliId,{id="PullOut",forced=true})--tex even with forced wont go with player in heli
          Ivars.disablePullOutHeli:Set(0,true)--tex overrules all, but we can tell it to not save so that's ok
          InfMenu.PrintLangId"heli_pulling_out"
        else
          Ivars.disablePullOutHeli:Set(1,true)
          InfMenu.PrintLangId"heli_hold_pulling_out"
        end
      end
    end--button down
  end--not menu, insupportheli
end--Update

function this.HeliOrderRecieved()
  if InfMain.execChecks.inGame and not InfMain.execChecks.inSafeSpace then
    InfMenu.PrintLangId"order_recieved"
  end
end

this.PullOutHeli=function()
  local gameObjectId=GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
  if gameObjectId~=nil and gameObjectId~=GameObject.NULL_ID then
    SendCommand(gameObjectId,{id="PullOut",forced=true})
  end
end

this.ChangeToIdleStateHeli=function()--tex seems to set heli into 'not called'/invisible/wherever it goes after it's 'left'
  local gameObjectId=GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
  if gameObjectId~=nil and gameObjectId~=GameObject.NULL_ID then
    SendCommand(gameObjectId,{id="ChangeToIdleState"})
  end
end

--MenuCommands
--WORKAROUND: Commands are mutated into normal options with undercase first letter, setting a menu system setting here for the following menu command
InfMenuCommands.forceExitHeli={
  isMenuOff=true,
}
this.ForceExitHeli=function()
  if not Tpp.IsHelicopter(vars.playerVehicleGameObjectId)then
    InfMenu.PrintLangId"not_in_heli"
  else
    Player.HeliSideToFOBStartPos()
    InfMenu.MenuOff()
  end
end

InfMenuCommands.forceExitHeliAlt={
  isMenuOff=true,
}
this.ForceExitHeliAlt=function()
  if not Tpp.IsHelicopter(vars.playerVehicleGameObjectId)then
    InfMenu.PrintLangId"not_in_heli"
  else
    Player.RequestToPlayDirectMotion{
      "nothing",
      {
        "",
        false,
        "",
        "",
        "",
        false
      }
    }

    --tex TODO need to wait for RequestToPlayDirectMotion to stop before can warp

    local currentPos={vars.playerPosX,vars.playerPosY,vars.playerPosZ}
    local closestRoute,closestDist,closestPos=InfLZ.GetClosestLz(currentPos)
    TppPlayer.Warp{pos=closestPos,rotY=vars.playerCameraRotation[1]}
    InfMenu.MenuOff()
  end
end

--WIP UNUSED (requestHeliLzToLastMarkerAlt is the current one being used in release)
InfMenuCommands.requestHeliLzToLastMarker={
  isMenuOff=true,
}
this.RequestHeliLzToLastMarker=function()
  local locationName=TppLocation.GetLocationName()
  if locationName~="afgh" and locationName~="mafr" then
    InfMenu.PrintLangId"not_for_location"
    return
  end

  local lastMarkerIndex=InfUserMarker.GetLastAddedUserMarkerIndex()
  if lastMarkerIndex==nil then
    InfMenu.PrintLangId"no_marker_found"
  else
    local markerPostion=InfUserMarker.GetMarkerPosition(lastMarkerIndex)

    local closestRoute=InfLZ.GetClosestLz(markerPostion)
    if closestRoute==nil then
      InfMenu.PrintLangId"no_lz_found"
      return
    end

    --closestRoute=InfLZ.str32LzToLz[closestRoute]--CULL
    if not TppLandingZone.assaultLzs[locationName] then
      InfCore.DebugPrint"WARNING: TppLandingZone.assaultLzs[locationName]==nil"--DEBUG
    end
    local lzName=TppLandingZone.assaultLzs[locationName][closestRoute] or TppLandingZone.missionLzs[locationName][closestRoute]
    --InfCore.DebugPrint("Pos Lz Name:"..tostring(closestRoute).." ArpName for lz name:"..tostring(aprRoute))--DEBUG

    local heliId=GetGameObjectId("TppHeli2","SupportHeli")
    if heliId==NULL_ID then
      --InfCore.DebugPrint"heliId==NULL_ID"--DEBUG
      return
    end
    SendCommand(heliId,{id="CallToLandingZoneAtName",name=lzName})
  end

  InfMenu.MenuOff()
end

--tex SetForceRoute on support to IH hover route, which is simple one node route (see this.packages)
--TODO: either support heli ignores the route speed an uses it's own (likely since heli speed can be upgraded),
--or just an edge isnt enough for speed (tried with MoveFast, VehicleMoveFast, CautionDash all listed on heli routes)
InfMenuCommands.requestHeliLzToLastMarkerAlt={
  isMenuOff=true,
}
this.RequestHeliLzToLastMarkerAlt=function()
  InfCore.LogFlow"RequestHeliLzToLastMarkerAlt"
  local heliId=GetGameObjectId("TppHeli2","SupportHeli")
  if heliId==NULL_ID then
    InfCore.Log("WARNING: SupportHeli heliId==NULL_ID",true)--DEBUG
    return
  end

  --tex a number of issues with usablility when doing force route outside of helicopter.
  if not Tpp.IsHelicopter(vars.playerVehicleGameObjectId)then
    InfMenu.PrintLangId"must_be_in_helicopter"
    InfMenu.MenuOff()
    return
  end

  --tex mtbs already has heli taxi system
  local locationName=TppLocation.GetLocationName()
  if locationName~="afgh" and locationName~="mafr" then
    InfMenu.PrintLangId"not_for_location"
    return
  end

  --tex heli is expecting something during mission start
  --exit heli action will not appear
  --if force player exit from heli, forceroute enable false will not work
  --force pull-out will not work
  --WORKAROUND: just prevent player from using this while mission start
  if gvars.heli_missionStartRoute~=0 then
    if not svars.ply_isUsedPlayerInitialAction then
      InfMenu.PrintLangId"cannot_use_at_mission_start"
      InfMenu.MenuOff()
      return
    end
  end

  --DEBUGNOW if supportheli getusingroute == mis_startroute ?
  --

  local lastMarkerIndex=InfUserMarker.GetLastAddedUserMarkerIndex()
  InfCore.Log("RequestHeliLzToLastMarkerAlt: lastMarkerIndex:"..lastMarkerIndex)--DEBUGNOW
  local closestRoute
  if lastMarkerIndex==nil then
    InfMenu.PrintLangId"no_marker_found"
    return
  else
    local markerPostion=InfUserMarker.GetMarkerPosition(lastMarkerIndex)
    closestRoute=InfLZ.GetClosestLz(markerPostion)
  end

  if closestRoute==nil then
    InfMenu.PrintLangId"no_lz_found"
    InfCore.Log("RequestHeliLzToLastMarkerAlt no lz found")
    return
  end

  local lzName=TppLandingZone.assaultLzs[locationName][closestRoute] or TppLandingZone.missionLzs[locationName][closestRoute]
  if lzName==nil then
    InfMenu.PrintLangId"no_lz_found"
    InfCore.Log("RequestHeliLzToLastMarkerAlt lzName==nil no lz found")
    return
  end

  InfCore.Log("RequestHeliLzToLastMarkerAlt Pos Lz Name:"..tostring(closestRoute).." ArpName for lz name:"..tostring(lzName),this.debugModule)--DEBUG
  --  local lzInfo=InfLZ.lzInfo[lzName]
  --  if not lzInfo then
  --    InfCore.Log("no lzInfo for "..tostring(lzName))
  --  else
  --    closestRoute=lzInfo.returnRoute
  --    --closestRoute=lzInfo.approachRoute
  --    --closestRoute=lzInfo.dropRoute
  --  end

  --tex ih hover route name is lz name with _hover suffix
  --these are single point routes I created for each lz, see this.packages
  closestRoute=lzName.."_hover"

  --DEBUGNOW
  --  local heliRouteS32=SendCommand(heliId,{id="GetUsingRoute"})--DEBUGNOW find out precisely what this is returning
  --  if InfCore.StrCode32(closestRoute)==heliRouteS32 then
  --    InfMenu.PrintLangId"already_heading_to_lz"
  --    InfCore.Log("allready heading to lz")
  --  else
  --    InfMenu.PrintLangId"heading_to_lz"
  --  end

  --DEBUGNOW
  if closestRoute==this.requestedRoute then
    InfMenu.PrintLangId"already_heading_to_lz"
  else
    InfMenu.PrintLangId"heading_to_lz"
  end
  this.requestedRoute=closestRoute

  --tex see Update(
  this.trackForceRoute=TRACK_FORCEROUTE_WAITFOREXIT

  --tex if called to landing before it being in map it will warp to point and realize
  --but if manually realize first it just kind of doesnt turn up
  --SendCommand(heliId,{id="Realize"})

  --SendCommand(heliId,{id="CallToLandingZoneAtName",name=lzName})

  --tex if no point (route node index) is supplied it will path to the nearest point
  --this is an issue if thats past the node at the lz
  --point 0 is first node, which can be an issue for dropRoute,approachRoute which has a starting point away from lz
  --but good for returnRoute which starts at lz
  --can use warp to figure out where the points are

  --DEBUGNOW SendCommand(heliId,{id="DisablePullOut"})--tex sometimes pullout triggers while player inside and heli waiting at forced route DEBUGNOW this means disablepullout ivar will need to be reaplied, see Update DEBUGNOW note

  SendCommand(heliId,{id="SetForceRoute",route=closestRoute})--,point=0})--,warp=true})--DEBUG

  InfMenu.MenuOff()
end

return this
