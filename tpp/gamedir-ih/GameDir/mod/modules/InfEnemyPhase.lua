--InfEnemyPhase.lua
--Phase/Alert updates DOC: Phases-Alerts.txt
--TODO alert radius
local this={}

--LOCALOPT
local InfMain=InfMain
local TppLocation=TppLocation
local PHASE_SNEAK=TppGameObject.PHASE_SNEAK
local PHASE_CAUTION=TppGameObject.PHASE_CAUTION
local PHASE_EVASION=TppGameObject.PHASE_EVASION
local PHASE_ALERT=TppGameObject.PHASE_ALERT
local GetGameObjectId=GameObject.GetGameObjectId
local NULL_ID=GameObject.NULL_ID
local SendCommand=GameObject.SendCommand
local random=math.random

--updateState
this.active="phaseUpdate"
this.execCheckTable={inGame=true,inSafeSpace=false}
this.execState={
  nextUpdate=0,
  lastPhase=0,
  alertBump=false,
}

this.phaseSettings={
  "PHASE_SNEAK",
  "PHASE_CAUTION",
  "PHASE_EVASION",
  "PHASE_ALERT",
}

--this.phaseTable={
--  TppGameObject.PHASE_SNEAK,--0
--  TppGameObject.PHASE_CAUTION,--1
--  TppGameObject.PHASE_EVASION,--2
--  TppGameObject.PHASE_ALERT,--3
--}

this.registerIvars={
  "minPhase",
  "maxPhase",
  "keepPhase",
  "phaseUpdateRate",
  "phaseUpdateRange",
  "phaseUpdate",
  "printPhaseChanges",
  "soldierAlertOnHeavyVehicleDamage",
  "cpAlertOnVehicleFulton",
}

this.minPhase={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=this.phaseSettings,
  --settingsTable=this.phaseTable,
  OnChange=function(self,setting)
    if setting>Ivars.maxPhase:Get() then
      Ivars.maxPhase:Set(setting)
    end

    this.execState.nextUpdate=0
  end,
}

this.maxPhase={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=this.phaseSettings,
  default=#this.phaseSettings-1,
  --settingsTable=this.phaseTable,
  OnChange=function(self,setting)
    if setting<Ivars.minPhase:Get() then
      Ivars.minPhase:Set(setting)
    end

    this.execState.nextUpdate=0
  end,
}

this.keepPhase={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.phaseUpdateRate={--seconds
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  default=3,
  range={min=1,max=255},
}
this.phaseUpdateRange={--seconds
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=255},
}

this.phaseUpdate={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function(self,setting)
    this.execState.nextUpdate=0
  end,
}

this.printPhaseChanges={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

this.soldierAlertOnHeavyVehicleDamage={
  inMission=true,
  save=IvarProc.CATEGORY_EXTERNAL,
  settings=this.phaseSettings,
}

this.cpAlertOnVehicleFulton={
  inMission=true,
  --OFF WIP save=IvarProc.CATEGORY_EXTERNAL,
  settings=this.phaseSettings,
}
--<ivar defs
this.registerMenus={
  "phaseMenu",
}

this.phaseMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
  options={
    --InfMenuCommandsTpp.printPlayerPhase",--DEBUG
    "Ivars.phaseUpdate",
    "Ivars.minPhase",
    "Ivars.maxPhase",
    "Ivars.keepPhase",
    "Ivars.phaseUpdateRate",
    "Ivars.phaseUpdateRange",
    "Ivars.soldierAlertOnHeavyVehicleDamage",--tex these>
    --"Ivars.cpAlertOnVehicleFulton",--WIP", NOTE: ivar save is disabled
    "Ivars.printPhaseChanges",--<don"t rely on phaseUpdate
  },
}
--< menu defs
this.langStrings={
  eng={
    phaseMenu="Enemy phases menu",
    phaseUpdate="Enable phase modifications",
    minPhase="Minimum phase",
    maxPhase="Maximum phase",
    keepPhase="Don't downgrade phase",
    phaseUpdateRate="Phase mod update rate (seconds)",
    phaseUpdateRange="Phase mod random variation",
    printPhaseChanges="Print phase changes",
    soldierAlertOnHeavyVehicleDamage="Alert phase on vehicle attack",
  },
  help={
    eng={
      phaseMenu="Adjust minimum and maximum alert phase for enemy Command Posts",
      phaseUpdate="The Minimum, Maximum, and Don't downgrade phase settings are applied on at every update tick according to the Phase update rate and random variation settings",
      minPhase="PHASE_SNEAK - not alert, PHASE_CAUTION - alert, PHASE_EVASION - one step down from combat alert, PHASE_ALERT - combat alert",
      maxPhase="PHASE_SNEAK - not alert, PHASE_CAUTION - alert, PHASE_EVASION - one step down from combat alert, PHASE_ALERT - combat alert",
      phaseUpdateRate="Rate that the CPs phase is adjusted to the minimum and maxium settings.",
      phaseUpdateRange="Random variation of update rate",
      phase_modification_enabled="Phase modifications enabled",
      soldierAlertOnHeavyVehicleDamage="Does not require phase modifications setting to be enabled. The enemy reactions to heavy vehicle attack in the default game are lacking, you can kill someone and they'll act as if it's an unsourced attack. This option changes phase of soldiers command post on damaging the soldier. Setting it to ALERT recommended.",
      printPhaseChanges="Displays when phase changes.",
    },
  }
}

function this.Init(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnReload(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.Messages()
  return Tpp.StrCode32Table{
    GameObject={
      {msg="ChangePhase",func=this.OnPhaseChange},
    },
  }
end

function this.Update(currentChecks,currentTime,execChecks,execState)
  local Ivars=Ivars
  local mvars=mvars

  if mvars.ene_soldierDefine==nil then
    --InfCore.DebugPrint"WARNING: InfEnemyPhase.Update - ene_soldierDefine==nil"
    return
  end

  local currentPhase=vars.playerPhase
  local minPhase=Ivars.minPhase:Get()
  local maxPhase=Ivars.maxPhase:Get()
  local keepPhase=Ivars.keepPhase:Is(1)

  --tex don't allow hostile if hostile not allowed
  if (TppLocation.IsMotherBase() or TppLocation.IsMBQF()) and Ivars.mbHostileSoldiers:Is(0) then
    if minPhase==PHASE_EVASION or minPhase==PHASE_ALERT then
      minPhase=PHASE_CAUTION
    end
    if maxPhase==PHASE_EVASION or maxPhase==PHASE_ALERT then
      maxPhase=PHASE_CAUTION
    end
  end

  --tex OFF TODO: MB cppositions
  --  local playerPosition={vars.playerPosX,vars.playerPosY,vars.playerPosZ}
  --  local closestCp,cpDistance,cpPosition=InfMain.GetClosestCp(playerPosition)
  --  if closestCp==nil then
  --    return
  --  end

  for cpName,soldierList in pairs(mvars.ene_soldierDefine)do
    if #soldierList>0 then
      local cpId=GetGameObjectId(cpName)
      local cpPhase=SendCommand(cpId,{id="GetPhase",cpName=cpName})
      --      if cpPhase==PHASE_ALERT then
      --        this.inf_cpLastAlert[cpName]=currentTime
      --      end

      if currentPhase<minPhase then
        this.ChangePhase(cpName,minPhase)--gvars.minPhase)
      end
      if currentPhase>maxPhase then
        this.ChangePhase(cpName,maxPhase)
      end

      if keepPhase then
        this.SetKeepAlert(cpName,true)
      else
      --InfMain.SetKeepAlert(cpName,false)--tex this would trash any vanilla setting, but updating this to off would only be important if ivar was updated at mission time
      end

      --tex keep forcing ALERT so that last know pos updates, otherwise it would take till the alert>evasion cooldown
      --doesnt really work well, > alert is set last know pos, take cover and suppress last know pos
      --evasion is - is no last pos, downgrade to caution, else group advance on last know pos
      --ideally would be able to set last know pos independant of phase
      --if minPhase==PHASE_ALERT then
      --debugMessage="phase<min setting to "..PhaseName(gvars.minPhase)
      --if currentPhase==PHASE_ALERT and execState.lastPhase==PHASE_ALERT then
      --this.ChangePhase(cpName,minPhase-1)--gvars.minPhase)
      --end
      --end
      if minPhase==PHASE_EVASION then
        if execState.alertBump then
          execState.alertBump=false
          this.ChangePhase(cpName,PHASE_EVASION)
        end
      end
      if currentPhase<minPhase then
        if minPhase==PHASE_EVASION then
          this.ChangePhase(cpName,PHASE_ALERT)
          execState.alertBump=true
        end
      end
    end
  end

  if execState.lastPhase~=currentPhase and Ivars.printPhaseChanges:Is(1)  then
    InfMenu.Print("Phase change from:"..this.phaseSettings[execState.lastPhase+1].." to:"..this.phaseSettings[currentPhase+1])
  end

  execState.lastPhase=currentPhase

  execState.nextUpdate=currentTime+this.GetUpdateRate()
end

function this.GetUpdateRate()
  local updateRate=Ivars.phaseUpdateRate:Get()
  local updateRange=Ivars.phaseUpdateRange:Get()
  if updateRange then
    local updateMin=updateRate-updateRange*0.5
    local updateMax=updateRate+updateRange*0.5
    if updateMin<0 then
      updateMin=0
    end

    updateRate=random(updateMin,updateMax)
  end

  return updateRate
end
function this.ChangePhase(cpName,phase)
  local gameId=GetGameObjectId("TppCommandPost2",cpName)
  if gameId==NULL_ID then
    InfCore.DebugPrint("Could not find cp "..cpName)
    return
  end
  local command={id="SetPhase",phase=phase}
  SendCommand(gameId,command)
end

function this.SetKeepAlert(cpName,enable)
  local gameId=GetGameObjectId("TppCommandPost2",cpName)
  if gameId==NULL_ID then
    InfCore.DebugPrint("Could not find cp "..cpName)
    return
  end
  local command={id="SetKeepAlert",enable=enable}
  GameObject.SendCommand(gameId,command)
end

local function PhaseName(index)
  return InfEnemyPhase.phaseSettings[index+1]
end
function this.OnPhaseChange(gameObjectId,phase,oldPhase)
  if Ivars.printPhaseChanges:Is(1) and Ivars.phaseUpdate:Is(0) then
    InfMenu.Print("cpId:"..gameObjectId.." cpName:"..tostring(InfLookup.CpNameForCpId(gameObjectId)).."Phase change from:"..PhaseName(oldPhase).." to:"..PhaseName(phase))--InfLangProc.LangString("phase_changed"..":"..PhaseName(phase)))--ADDLANG
  end
end

return this
