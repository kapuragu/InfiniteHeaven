-- InfReinforce.lua
local this={}

this.registerIvars={
  "forceSuperReinforce",
  "forceReinforceRequest",
  "enableHeliReinforce",
  "enableSoldiersWithVehicleReinforce",
  "disableReinforceHeliPullOut",
  --rlc v
  "overrideReinforceColoring",
  "unloadReinforceOnFinish",
  --rlc ^
}

--reinforce stuff DOC: Reinforcements Soldier Vehicle Heli.txt
this.forceSuperReinforce={
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={"OFF","ON_CONFIG","FORCE_CONFIG"},
}

this.forceReinforceRequest={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.enableHeliReinforce={--tex chance of heli being chosen for a reinforce, also turns off heli quests
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function()
    InfQuest.RerollQuestSelection()--tex update since quests may have changed
  end,
}

this.enableSoldiersWithVehicleReinforce={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.disableReinforceHeliPullOut={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--this.currentReinforceCount={--NONUSER
--  save=IvarProc.CATEGORY_EXTERNAL,
--  range={max=100},
--}
--<

--rlc v
this.overrideReinforceColoring={
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={"PREP","NONE","BLACK","RED"},
}

this.unloadReinforceOnFinish={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}
--rlc ^

this.registerMenus={
  "enemyReinforceMenu",
}

this.enemyReinforceMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu"},
  options={
    "Ivars.forceSuperReinforce",
    "Ivars.enableHeliReinforce",
    "Ivars.forceReinforceRequest",
    "Ivars.disableReinforceHeliPullOut",
    "Ivars.enableSoldiersWithVehicleReinforce",
    "Ivars.overrideReinforceColoring",
    "Ivars.unloadReinforceOnFinish",
  },
}
--< menu defs
this.langStrings={
  eng={
    enemyReinforceMenu="Enemy reinforcements menu",
    forceSuperReinforce="Vehicle reinforcements",
    forceSuperReinforceSettings={"Off","Enemy Prep","Force Prep"},
    forceReinforceRequest="Force reinforce request for heli",
    enableHeliReinforce="Force enable enemy heli reinforce (disables heli sideops)",
    disableReinforceHeliPullOut="Disable reinforce heli pull-out",
    enableSoldiersWithVehicleReinforce="Soldier reinforce with all vehicle reinforce types",
    overrideReinforceColoring="Reinforcement class",--rlc v
    overrideReinforceColoringSettings={"Enemy prep","None","Black","Red"},
    unloadReinforceOnFinish="Despawn eliminated reinforcement",--rlc ^
  },
  help={
    eng={
      forceSuperReinforce="In the normal game vehicle reinforcments through this system is only used for two missions, this enables it for more. Only heli will appear in certain outposts.",
      enableSoldiersWithVehicleReinforce="Allows an extra set of reinforce soldiers with all vehicle reinforce types instead of just Wheeled Armored Vehicles.",
      enableHeliReinforce="Since the enemy heli reinforce feature re-uses the sideops heli, enabling this will disable sideops that have a heli in them so that the reinforce can use it.",
      overrideReinforceColoring="Override the coloring type of the reinforcement helicopter or vehicle. Vanilla only uses None or Black.",
      unloadReinforceOnFinish="Despawn eliminated reinforcement vehicles so they can be spawned again later in the same session.",
    },
  }
}
--<

--rlc v
local StrCode32=Fox.StrCode32
local GetGameObjectId=GameObject.GetGameObjectId
--Reinforce unload system, extension of TppReinforceBlock
--There's a CancelReinforce message in TppReinforceBlock, but I'm not sure it's ever used
--So here's a custom system tracking whether the reinforce block's main target is destroyed or fultoned
--So it can be despawned and unloaded, ready to be restarted in the same session

function this.IsDespawnReinforce()
  if Ivars.unloadReinforceOnFinish:Get()>0 then
    return true
  end
  return false
end

this.END_REINFORCE_TIMER_NAME="InfReinforce_EndReinforce"

function this.IsReinforceBlockInactive()
  if mvars.reinforce_lastReinforceInactiveToActive then
    return true
  end
  return false
end

function this.EndReinforce()
  if this.IsReinforceBlockInactive() then
    return
  end
  InfCore.Log("InfReinforce: EndReinforce "..tostring(mvars.reinforce_reinforceCpId))
  TppReinforceBlock.FinishReinforce(mvars.reinforce_reinforceCpId)
  TppReinforceBlock.UnloadReinforceBlock(mvars.reinforce_reinforceCpId)
end

function this.StartReinforceUnloadTimer(timerDuration)
  InfCore.Log("InfReinforce: StartReinforceUnloadTimer "..tostring(timerDuration))
  GkEventTimerManager.Start(this.END_REINFORCE_TIMER_NAME,timerDuration or 0)
end

this.UNLOAD_TIMER_DURATION={
  HELI_DESTROYED=20,
  HELI_RETURNED=5,
  VEHICLE_DISAPPEARED=40,--vfx is super long
  VEHICLE_FULTON=10,
}

--Vehicle
function this.IsReinforceOnlyVehicle()
  return TppReinforceBlock._HasVehicle()
end

function this.EndReinforceVehicle(vehicleGameObjectId,timerDuration)
  InfCore.Log("InfReinforce: EndReinforceVehicle "..tostring(vehicleGameObjectId))
  if this.IsReinforceOnlyVehicle() then
    this.StartReinforceUnloadTimer(timerDuration)
  end
end

function this.OnReinforceVehicleBroken(vehicleGameObjectId,state)
  if this.IsReinforceBlockInactive() then
    return
  end
  InfCore.Log("InfReinforce: OnReinforceVehicleBroken "..tostring(vehicleGameObjectId)..", "..tostring(state))
  if state==StrCode32"End" then
    mvars.ih_InfReinforce_VehicleDisappearedWait=true
  end
end

function this.OnReinforceVehicleDisappeared(vehicleGameObjectId)
  if this.IsReinforceBlockInactive() then
    return
  end
  InfCore.Log("InfReinforce: OnReinforceVehicleDisappeared "..tostring(vehicleGameObjectId))
  if mvars.ih_InfReinforce_VehicleDisappearedWait then
    this.EndReinforceVehicle(vehicleGameObjectId,this.UNLOAD_TIMER_DURATION.VEHICLE_DISAPPEARED)
    mvars.ih_InfReinforce_VehicleDisappearedWait=nil
  end
end

function this.OnReinforceVehicleFulton(vehicleGameObjectId,gimmickInstance,gimmickDataSet,stafforResourceId)
  if this.IsReinforceBlockInactive() then
    return
  end
  InfCore.Log("InfReinforce: OnReinforceVehicleFulton "..tostring(vehicleGameObjectId))
  this.EndReinforceVehicle(vehicleGameObjectId,this.UNLOAD_TIMER_DURATION.VEHICLE_FULTON)
end

--Heli
function this.IsReinforceOnlyHeli()
  return TppReinforceBlock._HasHeli()
end

function this.EndReinforceHeli(heliGameObjectId,timerDuration)
  InfCore.Log("InfReinforce: EndReinforceHeli "..tostring(heliGameObjectId))
  if this.IsReinforceOnlyHeli() then
    this.StartReinforceUnloadTimer(timerDuration)
  end
end

function this.OnReinforceHeliLostControl(heliGameObjectId,state,attackerId)
  if this.IsReinforceBlockInactive() then
    return
  end
  if not GetGameObjectId(TppReinforceBlock.REINFORCE_HELI_NAME)==heliGameObjectId then
    return
  end
  InfCore.Log("InfReinforce: OnReinforceHeliLostControl "..tostring(heliGameObjectId)..", "..tostring(state)..", "..tostring(attackerId))
  if state==StrCode32"End" then
    this.EndReinforceHeli(heliGameObjectId,this.UNLOAD_TIMER_DURATION.HELI_DESTROYED)
  end
end

function this.OnReinforceHeliReturned(heliGameObjectId)
  if this.IsReinforceBlockInactive() then
    return
  end
  if not GetGameObjectId(TppReinforceBlock.REINFORCE_HELI_NAME)==heliGameObjectId then
    return
  end
  InfCore.Log("InfReinforce: OnReinforceHeliReturned "..tostring(heliGameObjectId))
  this.EndReinforceHeli(heliGameObjectId,this.UNLOAD_TIMER_DURATION.HELI_RETURNED)
end

function this.Messages()
  return Tpp.StrCode32Table{
    GameObject={
      --Vehicle
      {msg="VehicleBroken", sender=TppReinforceBlock.REINFORCE_VEHICLE_NAME, func=this.OnReinforceVehicleBroken},
      {msg="VehicleDisappeared", sender=TppReinforceBlock.REINFORCE_VEHICLE_NAME, func=this.OnReinforceVehicleDisappeared},
      {msg="Fulton", sender=TppReinforceBlock.REINFORCE_VEHICLE_NAME, func=this.OnReinforceVehicleFulton},
      --Heli
      {msg="LostControl", func=this.OnReinforceHeliLostControl},
      {msg="Returned", func=this.OnReinforceHeliReturned},
    },
    Timer={
      {msg="Finish", sender=this.END_REINFORCE_TIMER_NAME,func=this.EndReinforce,}
    },
  }
end

function this.Init(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnReload(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  if not this.IsDespawnReinforce() then
    return
  end
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end
--rlc ^

return this
