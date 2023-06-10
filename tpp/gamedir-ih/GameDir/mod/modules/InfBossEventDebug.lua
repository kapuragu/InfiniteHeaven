--InfBossEventDebug.lua

local SendCommand=GameObject.SendCommand
local GetGameObjectId=GameObject.GetGameObjectId

local this={}

this.registerIvars={
  "bossEvent_offenseGrade",
  "bossEvent_defenseGrade",
}
this.registerMenus={
  'bossEventDebugMenu',
}

--DEBUGNOW
this.bossEventDebugMenu={
  parentRefs={"InfBossEvent.bossEventMenu"},--tex is really only for inmission
  options={
    "InfBossEventDebug.DEBUG_ToggleBossEvent",
    "InfBossEventDebug.DEBUG_TppBossQuiet2_SetWithdrawal",
    "InfBossEventDebug.DEBUG_TppBossQuiet2_NoNotice",
    "InfBossEventDebug.DEBUG_TppBossQuiet2_SetForceUnrealze",    
    
    "InfBossEventDebug.DEBUG_TppParasite2_StartWithdrawal",

        --DEBUGNOW
        "Ivars.bossEvent_offenseGrade",
        "Ivars.bossEvent_defenseGrade",
  }
}

--DEBUGNOW
this.bossEvent_offenseGrade={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0,
  range={min=0,max=10,},
}
this.bossEvent_defenseGrade={
  save=IvarProc.CATEGORY_EXTERNAL,
  default=0,
  range={min=0,max=10,},
}

local parasiteToggle=false
this.DEBUG_ToggleBossEvent=function()
  if not InfBossEvent.BossEventEnabled() then
    InfCore.Log("DEBUG_ToggleBossEvent BossEventEnabled false",true)--DEBUG
    return
  end

  if svars.bossEvent_attackCountdown==nil then
    InfCore.Log("DEBUG_ToggleBossEvent bossEvent_attackCountdown == nil",true)--DEBUG
  end

  if svars.bossEvent_attackCountdown==0 then
    InfCore.Log("DEBUG_ToggleBossEvent off",false,true)
    InfBossEvent.EndEvent()
  else
    InfCore.Log("DEBUG_ToggleBossEvent on",false,true)
    InfBossEvent.StartCountdown(true)
  end
end--DEBUG_ToggleBossEvent

function this.DEBUG_TppBossQuiet2_SetWithdrawal()
  SendCommand({type="TppBossQuiet2"},{id="SetWithdrawal",enabled=true})
end
function this.DEBUG_TppBossQuiet2_NoNotice()
  for i,name in ipairs(InfBossTppBossQuiet2.currentInfo.objectNames)do
    local gameId=GetGameObjectId("TppBossQuiet2",name)
    SendCommand(gameId,{id="SetSightCheck",flag=false})
    SendCommand(gameId,{id="SetNoiseNotice",flag=false})  
  end
end
function this.DEBUG_TppBossQuiet2_SetForceUnrealze()
  for i,name in ipairs(InfBossTppBossQuiet2.currentInfo.objectNames)do
    local gameId=GetGameObjectId("TppBossQuiet2",name)
    SendCommand(gameId,{id="SetForceUnrealze",flag=true})
  end
end

function this.DEBUG_TppParasite2_StartWithdrawal()
  SendCommand({type="TppParasite2"},{id="StartWithdrawal"})
end

return this