--InfMain.lua
--Mostly interface between TppMain / other game modules and IH modules.
InfCore.LogFlow"Load InfMain.lua"
local this={}
this.debugModule=false

--LOCALOPT:
local InfMain=this
local IHH=IHH
local InfCore=InfCore
local IvarProc=IvarProc
local InfButton=InfButton
local InfModules=InfModules
local IsFunc=Tpp.IsTypeFunc
local IsTable=Tpp.IsTypeTable
local IsString=Tpp.IsTypeString
local NULL_ID=GameObject.NULL_ID
local GetGameObjectId=GameObject.GetGameObjectId
local GetTypeIndex=GameObject.GetTypeIndex
local SendCommand=GameObject.SendCommand
local StrCode32=InfCore.StrCode32
local GetPlayingDemoId=DemoDaemon.GetPlayingDemoId
local IsDemoPaused=DemoDaemon.IsDemoPaused
local IsDemoPlaying=DemoDaemon.IsDemoPlaying
local DoMessage=Tpp.DoMessage
local pairs=pairs
local ipairs=ipairs
local IsMbDvcTerminalOpened=TppUiCommand.IsMbDvcTerminalOpened
local IsVarsCurrentItemCBox=Player.IsVarsCurrentItemCBox
local GAME_OBJECT_TYPE_HELI2=TppGameObject.GAME_OBJECT_TYPE_HELI2
local GAME_OBJECT_TYPE_VEHICLE=TppGameObject.GAME_OBJECT_TYPE_VEHICLE
local GAME_OBJECT_TYPE_HORSE2=TppGameObject.GAME_OBJECT_TYPE_HORSE2
local GAME_OBJECT_TYPE_WALKERGEAR2=TppGameObject.GAME_OBJECT_TYPE_WALKERGEAR2
local GetRawElapsedTimeSinceStartUp=Time.GetRawElapsedTimeSinceStartUp
local floor=math.floor
--local vars=vars
--local mvars=mvars--GOTCHA: cant cache as engine kills older table entirely on mission change?
--ditto svars, but thats more obviously changed with onchangesvars

local reloadModulesCombo={
  InfButton.READY_WEAPON,
  InfButton.DASH,
  InfButton.ACTION,
  InfButton.BINOCULARS,
}

--STATE
this.missionCanStart=false--tex false from TppMission.Load, true from OnMissionCanStart
--tex gvars.isContinueFromTitle is cleared in OnAllocate while it could have still been useful,
--this is valid from OnAllocateTop to OnInitializeBottom, till not safeSpace
this.isContinueFromTitle=false

this.appliedProfiles=false

this.usingAltCamera=false--tex IH camera modules flip this on enabled, then it's pulled into checkexec

this.getMissionPackagePathReturnTime={}--

this.execChecks={
  inGame=false,--tex actually loaded game, ie at least 'continued' from title screen
  inSafeSpace=false,--aka heliSpace in tpp
  inMission=false,
  inDemo=false,
  pastTitle=false,
  missionCanStart=false,
  initialAction=false,--tex mission actually started/reached ground, triggers on checkpoint save so might not be valid for some uses
  inGroundVehicle=false,
  inSupportHeli=false,
  onBuddy=false,--tex sexy
  inBox=false,
  inMenu=false,
  inIdroid=false,
  usingAltCamera=false,
}

this.abortToAcc=false--tex

this.messageExecTable=nil

this.startTime=0
this.updateTimes={}--DEBUG

this.menuDisableActions=PlayerDisableAction.OPEN_EQUIP_MENU--+PlayerDisableAction.OPEN_CALL_MENU

--CALLER: TppVarInit.StartTitle, game save actually first loaded
--not super accurate execution timing wise
function this.OnStartTitle()
  InfCore.LogFlow"InfMain.OnStartTitle"
  InfCore.gameSaveFirstLoad=true

  this.CallOnModules("OnStartTitle")
end

--Tpp module hooks/calls>

--tex from TppMission.Load
function this.OnLoad(nextMissionCode,currentMissionCode)
  this.missionCanStart=false

  if this.IsOnlineMission(nextMissionCode)then
    return
  end

  this.CallOnModules("OnLoad",nextMissionCode,currentMissionCode)
  if IHH then
    IHH.Log_Flush()
  end
end

--CALLER: TppEneFova.PreMissionLoad
function this.PreMissionLoad(missionId,currentMissionId)
  InfCore.LogFlow"InfMain.PreMissionLoad"

  if this.IsOnlineMission(missionId)then
    return
  end

  this.CallOnModules("PreMissionLoad",missionId,currentMissionId)
  if IHH then
    IHH.Log_Flush()
  end
end

function this.OnAllocateTop(missionTable)
  --tex DEBUG
  local getMissionPackagePathReturnTime=this.getMissionPackagePathReturnTime[vars.missionCode]
  this.getMissionPackagePathReturnTime[vars.missionCode]=0
  if getMissionPackagePathReturnTime then
    local endTime=os.clock()-getMissionPackagePathReturnTime
    InfCore.Log("GetMissionPackagePath to OnAllocate time: "..endTime)
  end

  --tex enable/disable debug mode depending on ivar, up until this point (from start) InfCore.debugMode==true (see note there)
  local enable=Ivars.debugMode:Is(1)
  this.DebugModeEnable(enable)

  if gvars.isContinueFromTitle then
    this.isContinueFromTitle=true
  end
  
  this.usingAltCamera=false

  this.CallOnModules("OnAllocateTop",missionTable)
  if IHH then
    IHH.Log_Flush()
  end
end
function this.OnAllocate(missionTable)
  if this.IsOnlineMission(vars.missionCode)then
    --DEBUGNOW TPP
    if InfSoldierParams then
      TppSoldier2.ReloadSoldier2ParameterTables(InfSoldierParams.soldierParametersDefaults)
    end
    if InfResources then
      InfResources.DefaultResourceTables()
    end
    return
  end

  if igvars and igvars.inf_levelSeed then
    InfCore.Log("inf_levelSeed "..tostring(igvars.inf_levelSeed))--DEBUG
  end

  this.CallOnModules("OnAllocate",missionTable)
  if IHH then
    IHH.Log_Flush()
  end
end
--tex in OnAllocate, just after sequence.MissionPrepare
function this.MissionPrepare()
  if this.IsOnlineMission(vars.missionCode)then
    return
  end
  
  --tex WORKAROUND: TppSequence is not in build
  if Ivars.debugOnUpdate:Is(1) then
    TppMission.RegisterMissionSystemCallback{OnUpdateWhileMissionPrepare=this.OnUpdateWhileMissionPrepare}--tex this only works out because the callback isnt used anywhere else
  end

  this.CallOnModules("MissionPrepare")
  if IHH then
    IHH.Log_Flush()
  end
end

--tex called at very start of TppMain.OnInitialize, use mostly for hijacking missionTable scripts
function this.OnInitializeTop(missionTable)
  if this.IsOnlineMission(vars.missionCode)then
    return
  end

  if missionTable.enemy then
    if type(missionTable.enemy.soldierDefine)=="table"then
      this.BuildCpPositions(missionTable.enemy.soldierDefine)
    end
  end

  this.CallOnModules("OnInitializeTop",missionTable)
  if IHH then
    IHH.Log_Flush()
  end
end

--tex called about halfway through TppMain.OnInitialize (on all require libs)
function this.Init(missionTable)
  this.abortToAcc=false

  if this.IsOnlineMission(vars.missionCode) then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  this.UpdateExecChecks(this.execChecks)
  this.CallOnModules("Init",missionTable,this.execChecks)
  if IHH then
    IHH.Log_Flush()
  end
end

--CALLER: 2/4 way through TppMain.OnInitialize
--after missionTable.<modules>.OnRestoreSvars calls
function this.OnRestoreSvars()
  this.CallOnModules("OnRestoreSvars")
end

--tex just after mission script_enemy.SetUpEnemy
function this.SetUpEnemy(missionTable)
  InfCore.LogFlow("InfMain.SetUpEnemy "..vars.missionCode)
  if this.IsOnlineMission(vars.missionCode)then
    return
  end
  this.CallOnModules("SetUpEnemy",missionTable)
  if IHH then
    IHH.Log_Flush()
  end
end

function this.OnInitializeBottom(missionTable)
  if this.IsOnlineMission(vars.missionCode)then
    return
  end

  if vars.missionCode>TppDefine.SYS_MISSION_ID.INIT and not this.IsSafeSpace(vars.missionCode) then
    this.isContinueFromTitle=false
  end
  if IHH then
    IHH.Log_Flush()
  end
end

--CALLER: TppMissionList.GetMissionPackagePath
--IN/OUT packPath  
--tex GOTCHA: will need another method if want to add missionpacks earlier than title
function this.AddMissionPacks(missionCode,packPaths)
  InfCore.LogFlow("InfMain.AddMissionPacks "..missionCode)
  if this.IsOnlineMission(missionCode)then
    return
  end

  if not this.IsPastTitle(missionCode) then
    return
  end

  --  local packages=this.packages[missionCode]
  --  if packages then
  --    for i,packPath in ipairs(packages) do
  --      packPaths[#packPaths+1]=packPath
  --    end
  --  end

  for i,module in ipairs(InfModules) do
    if IsFunc(module.AddMissionPacks) then
      InfCore.LogFlow(module.name..".AddMissionPacks:")
      InfCore.PCallDebug(module.AddMissionPacks,missionCode,packPaths)
    end
  end
  if IHH then
    IHH.Log_Flush()
  end
  this.getMissionPackagePathReturnTime[missionCode]=os.clock()--tex DEBUGNOW
end--AddMissionPacks

--tex called via TppSequence Seq_Mission_Prepare.OnUpdate > TppMain.OnMissionCanStart
function this.OnMissionCanStartBottom()
  InfCore.LogFlow"InfMain.OnMissionCanStartBottom"

  this.missionCanStart=true

  if this.IsOnlineMission(vars.missionCode)then
    return
  end

  this.UpdateExecChecks(this.execChecks)
  this.CallOnModules("OnMissionCanStart",this.execChecks)
  if IHH then
    IHH.Log_Flush()
  end
end

--tex called from TppMain.OnReload (TODO: caller of that?) on all require libs
function this.OnReload(missionTable)
  if this.IsOnlineMission(vars.missionCode) then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  this.CallOnModules("OnReload",missionTable)
  if IHH then
    IHH.Log_Flush()
  end
end

--tex called from TppMission.OnMissionGameEndFadeOutFinish2nd
function this.OnMissionGameEndTop()
  if this.IsOnlineMission(vars.missionCode)then
    return
  end

  this.CallOnModules("OnMissionGameEnd")
  if IHH then
    IHH.Log_Flush()
  end
end

function this.EstablishedMissionAbortTop()
  if this.IsOnlineMission(vars.missionCode)then
    return
  end
  this.CallOnModules("EstablishedMissionAbortTop")
end--EstablishedMissionAbortTop
function this.EstablishedMissionClearTop()
  if this.IsOnlineMission(vars.missionCode)then
    return
  end
  this.CallOnModules("EstablishedMissionClearTop")
end--EstablishedMissionClearTop
function this.EstablishedGameOverTop()
  if this.IsOnlineMission(vars.missionCode)then
    return
  end
  this.CallOnModules("EstablishedGameOverTop")
end--EstablishedGameOver

--tex called from TppMission.AbortMission (TODO: caller of that?)
function this.AbortMissionTop(abortInfo)
  if this.IsOnlineMission(abortInfo.nextMissionId)then
    return
  end

  --InfCore.Log("AbortMissionTop "..vars.missionCode)--DEBUG
  InfMain.RegenSeed(vars.missionCode,abortInfo.nextMissionId)

  this.CallOnModules("AbortMissionTop",abortInfo)
end

--CALLERS TppMission.MissionFinalize/OnEndMissionReward < called from in sequence when decided mission is ended
function this.ExecuteMissionFinalizeTop()
  if this.IsOnlineMission(gvars.mis_nextMissionCodeForMissionClear)then
    return
  end

  this.RegenSeed(vars.missionCode,gvars.mis_nextMissionCodeForMissionClear)
  if InfGameEvent then
    InfGameEvent.DisableEvent()--DEBUGNOW: InfMainTpp
    InfCore.PCall(InfGameEvent.GenerateEvent,gvars.mis_nextMissionCodeForMissionClear)--DEBUGNOW: InfMainTpp
  end
end

function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  local CheckMessageOption=TppMission.CheckMessageOption
  DoMessage(this.messageExecTable,CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.Messages()
  return Tpp.StrCode32Table{
    UI={
      {msg="EndFadeIn",sender="FadeInOnGameStart",func=this.FadeInOnGameStart},--fires on: most mission starts, on-foot free and story missions, not mb on-foot, but does mb heli start
      {msg="EndFadeIn",sender="FadeInOnStartMissionGame",func=this.FadeInOnGameStart},--fires on: returning to heli from mission
      {msg="EndFadeIn",sender="OnEndGameStartFadeIn",func=this.FadeInOnGameStart},--fires on: on-foot mother base, both initial and continue
    },
    Block={
      {msg="StageBlockCurrentSmallBlockIndexUpdated",func=function(blockIndexX,blockIndexY,clusterIndex)
        if Ivars.printOnBlockChange:Is(1) then
          InfCore.DebugPrint("OnSmallBlockIndex - x:"..blockIndexX..", y:"..blockIndexY.." clusterIndex:"..tostring(clusterIndex))
        end
      end},
      {msg="OnChangeLargeBlockState",func=function(blockNameStr32,blockStatus)
        if Ivars.printOnBlockChange:Is(1) then
          InfCore.DebugPrint("OnChangeLargeBlockState - blockNameStr32:"..blockNameStr32.." blockStatus:"..blockStatus)
        end
      end},
    },
  }
end

--CALLER: TppUI.FadeIn
function this.OnFadeInDirect(msgName)
  InfCore.LogFlow("InfMain.OnFadeInDirect:"..tostring(msgName))
  if vars.missionCode > 5 and this.IsOnlineMission(vars.missionCode)then
    return
  end

  this.CallOnModules("OnFadeInDirect",msgName)
end

--CALLER: TppUI.FadeOut
function this.OnFadeOutDirect(msgName)
  InfCore.LogFlow("InfMain.OnFadeOutDirect:"..tostring(msgName))
  if vars.missionCode > 5 and this.IsOnlineMission(vars.missionCode)then
    return
  end

  this.CallOnModules("OnFadeOutDirect",msgName)
end

--msg called fadeins
function this.FadeInOnGameStart()
  InfCore.LogFlow"InfMain.FadeInOnGameStart"
  this.WeaponVarsSanityCheck()--DEBUGNOW TODO this wont actually be called since messages are off in FOB?, but it was working when I wrote it, so did I only block messages in fob after?

  if this.IsOnlineMission(vars.missionCode)then
    return
  end

  --TppUiStatusManager.ClearStatus"AnnounceLog"
  --InfMenu.ModWelcome()
end

function this.OnMenuOpen()

end
function this.OnMenuClose(skipSave)
  local activeControlMode=this.GetActiveControlMode()
  if activeControlMode then
    if IsFunc(activeControlMode.OnActivate) then
      activeControlMode.OnActivate()
    end
  end
  if not skipSave then
    InfCore.PCallDebug(IvarProc.SaveAll)
  end
  if InfCore.debugMode then
    if IHH then
      IHH.Log_Flush()
    end
  end
end

--Caller heli_common_sequence.Seq_Game_MainGame.OnEnter
function this.OnEnterACC()
  if not InfCore.mainModulesOK then
    this.ModuleErrorMessage()
  else
    InfMenu.ModWelcome()

    --tex dummy/EQUIP_NONE hangun/assault CULL
    --    local developIds={
    --      900,
    --      901,
    --    }
    --    for i,developId in ipairs(developIds) do
    --      if not TppMotherBaseManagement.IsEquipDevelopedFromDevelopID{equipDevelopID=developId} then
    --        InfCore.Log("SetEquipDeveloped "..developId)
    --        TppMotherBaseManagement.SetEquipDeveloped{equipDevelopID=developId}
    --      end
    --    end

    --tex only want this on enter ACC because changing vars on a mission is not a good idea
    if not this.appliedProfiles then
      this.appliedProfiles=true
      IvarProc.ApplyInfProfiles(Ivars.profileNames)
    end
  end
end


local function IsSysMission(missionCode)
  local isSysMission=false
  for missionId,sysMissionCode in pairs(TppDefine.SYS_MISSION_ID)do
    if missionCode==sysMissionCode then
      isSysMission=true
    end
  end

  return isSysMission
end
--CALLER: title_sequence OnSelectContinue
function this.ShouldAbortToACC(locationCode,missionCode)
  local shouldAbort=InfMain.abortToAcc or (ih_save and ih_save.loadToACC)
  if not shouldAbort then
    --tex valid location?
    if InfMission then
      local vanillaLocations={
        [1]=true,
        [10]=true,
        [20]=true,
        [30]=true,
        [50]=true,
        [55]=true,
        [60]=true,
      }
      if not vanillaLocations[locationCode] and InfMission.locationInfo[locationCode]==nil then
        InfCore.Log("WARNING: ShouldAbortToACC: locationCode not recognised as vanilla or addon")
        shouldAbort=true
      end
    end--if InfMission
    --tex valis mission?
    if InfMission then
      --tex if not in vanilla mission list and not an addon mission then wtf
      if TppDefine.MISSION_ENUM[tostring(missionCode)]==nil and not IsSysMission(missionCode) then
        if InfMission.missionInfo[missionCode]==nil then
          InfCore.Log("WARNING: ShouldAbortToACC: missionCode not recognised as vanilla or addon")
          shouldAbort=true
        end
      end
    end--if InfMission
  end--if not shouldAbort
  if shouldAbort then
    InfCore.Log("InfMain.ShouldAbortToACC location:"..tostring(locationCode).." mission:"..tostring(missionCode)..": "..tostring(shouldAbort))
    InfCore.DebugPrint("IH: Aborting to ACC")
  end
  return shouldAbort
end

--tex on holding esc at title
function this.ClearOnAbortToACC()
  igvars.inf_event=false
end

--DEBUGNOW
function this.IsPastTitle(missionCode)
  return missionCode>5 and missionCode<65535
end
--tex WORKAROUND: currently just replicating Seq_Mission_Prepare.OnUpdate and logging progress since TppSequence is not in build
--as this is called using TppMission SystemCallBack 
--though a lot of it is already logged via the TppMain calls is does
--currently gated by debugOnUpdate - TODO: debugLoadingOnUpdate/debugMissionPrepareUpdate or something
--(see this.MissionPrepare)
--Seq_Mission_Prepare is first sequence (prepended to mission _sequence sequences), set in TppSequence.Init
--and essentially the loading progression

local IsEndedMBMgmtSyncControl=TppMotherBaseManagement.IsEndedSyncControl
local MissionCanStart=TppMission.CanStart
local GetElapsedTime=Time.GetRawElapsedTimeSinceStartUp
function this.OnUpdateWhileMissionPrepare()
  local textureLoadedRate=Mission.GetTextureLoadedRate()
  if mvars.seq_skipTextureLoadingWait then
    textureLoadedRate=1
  end

  if not IsEndedMBMgmtSyncControl() then
    InfCore.Log("OnUpdateWhileMissionPrepare not TppMotherBaseManagement.IsEndedSyncControl")--tex 
    return
  end

  if not MissionCanStart() then
    InfCore.Log("OnUpdateWhileMissionPrepare not TppMission.CanStart")--tex 
    return
  end

  local maxTextureLoadWaitStartTime=30
  local maxTextureLoadedRate=.35  
  local continueMissionPrepare=false
  --tex timing may be a bit hinky due to stuff being set in actual Seq_Mission_Prepare.OnUpdate
  local textureLoadStartDelta=GetElapsedTime()-mvars.seq_textureLoadWaitStartTime
  local textureLoadWaitTimeLeft=maxTextureLoadWaitStartTime-textureLoadStartDelta
  if(textureLoadedRate>maxTextureLoadedRate)or(textureLoadWaitTimeLeft<0)then
    continueMissionPrepare=true
  end
  
  if not continueMissionPrepare then
    InfCore.Log("TppSequence Seq_Mission_Prepare.OnUpdate not continueMissionPrepare")--tex DEBUGNOW
    InfCore.Log("textureLoadedRate:"..textureLoadedRate.." textureLoadWaitTimeLeft:"..textureLoadWaitTimeLeft)
    return
  end
  --GOTCHA: textureLoadedRate gets set to 0 somewhere past this point so it gets caught back into continueMissionPrepare for a while
  
  --tex the TppMain calls that are logged should handle most logging since there no blocking of the stage advancement past this point
    
  --tex trying to think my way through replicating Seq_Mission_Prepare.OnUpdate since the call to this callback it near the top of that
  --and at about this equivalent point Seq_Mission_Prepare.OnUpdate jumps through a few states (and continueMissionPrepare if SkipTextureLoadingWait) in one frame
  --so I can't really give it the proper order, so this will fire before
  --TppMain.OnTextureLoadingWaitStart
  --TppMain.OnMissionStartSaving
  --TppMain.OnMissionCanStart
  --when its usually checked after OnMissionCanStart
  if(mvars.seq_missionPrepareState<TppSequence.MISSION_PREPARE_STATE.END_TEXTURE_LOADING)then
    if TppUiCommand.IsEndLoadingTips()then
      InfCore.Log("TppSequence Seq_Mission_Prepare.OnUpdate TppUiCommand.IsEndLoadingTips")
    else
      if gvars.waitLoadingTipsEnd then
        InfCore.Log("TppSequence Seq_Mission_Prepare.OnUpdate gvars.waitLoadingTipsEnd true: TppUiCommand.PermitEndLoadingTips()")
      end
    end
  end
end--OnUpdateWhileMissionPrepare
--IN/OUT SIDE: currentchecks
function this.UpdateExecChecks(currentChecks)
  local missionCode=vars.missionCode
  currentChecks.inGame=not mvars.mis_missionStateIsNotInGame
  currentChecks.inSafeSpace=missionCode and this.IsSafeSpace(missionCode)
  currentChecks.inMission=currentChecks.inGame and not currentChecks.inSafeSpace
  currentChecks.inDemo=not currentChecks.inGame and (IsDemoPaused() or IsDemoPlaying() or GetPlayingDemoId())--DEBUGNOW inDemo is mis_missionStateIsNotInGame?
  currentChecks.pastTitle=missionCode>5 and missionCode~=65535
  currentChecks.missionCanStart=this.missionCanStart
  currentChecks.initialAction=false
  currentChecks.inGroundVehicle=false
  currentChecks.inSupportHeli=false
  currentChecks.onBuddy=false
  currentChecks.inBox=false
  currentChecks.inMenu=false
  currentChecks.inIdroid=IsMbDvcTerminalOpened()
  currentChecks.usingAltCamera=this.usingAltCamera

  if currentChecks.inGame then
    local playerVehicleId=vars.playerVehicleGameObjectId
    if not currentChecks.inSafeSpace then
      currentChecks.initialAction=svars.ply_isUsedPlayerInitialAction--VERIFY that start on ground catches this (it's triggered on checkpoint save DOESNT catch motherbase ground start
      --if not initialAction then--DEBUG
      --InfCore.DebugPrint"not initialAction"
      --end
      if playerVehicleId~=NULL_ID then
        local playerVehicleType=GetTypeIndex(playerVehicleId)
        currentChecks.inSupportHeli=playerVehicleType==GAME_OBJECT_TYPE_HELI2
        currentChecks.inGroundVehicle=playerVehicleType==GAME_OBJECT_TYPE_VEHICLE --or GAME_OBJECT_TYPE_COMMON_WALKERGEAR2 ??
        currentChecks.onBuddy=playerVehicleType==GAME_OBJECT_TYPE_HORSE2 or playerVehicleType==GAME_OBJECT_TYPE_WALKERGEAR2
      end
      currentChecks.inBox=IsVarsCurrentItemCBox()
    end
  end

  return currentChecks
end
--CALLER: TppMain.OnUpdate (1st entry in moduleUpdateFuncs)
function this.UpdateTop(missionTable)
  if IHH then
    IHH.OnUpdate(missionTable)
  end
end

--CALLER: TppMain.OnUpdate (last entry in moduleUpdateFuncs)
--OUT: this.execChecks
function this.UpdateBottom(missionTable)
  local InfMenu=InfMenu
  if this.IsOnlineMission(vars.missionCode) then
    return
  end

  if this.debugModule then
    this.startTime=os.clock()--DEBUG
  end
  local currentChecks=this.execChecks
  this.UpdateExecChecks(currentChecks)
  local currentTime=GetRawElapsedTimeSinceStartUp()--tex in seconds, with decimal for < second

  InfButton.UpdateHeld()
  InfButton.UpdateRepeatReset()


  this.DoControlSet(currentChecks)

  --Update modules
  if not InfCore.mainModulesOK then
    if InfButton.OnButtonHoldTime(InfMenu.toggleMenuButton) then
      this.ModuleErrorMessage()
    end
  else
    for i,module in ipairs(InfModules) do
      if module.Update then
        if this.debugModule then
          this.updateTimes[module.name]=this.updateTimes[module.name] or {}
          this.startTime=os.clock()--DEBUG
        end

        --tex <module>.active is either number or ivar
        local active=this.ValueOrIvarValue(module.active)
        if module.active==nil or active>0 then
          --tex only update outside of game/safespace if module asks
          --this is to cut down on non IH modules that have just been using Update without any checks
          if currentChecks.inGame or currentChecks.inSafeSpace or module.updateOutsideGame or module.execState then--DEBUGNOW
            --InfCore.Log("ExecUpdate for "..tostring(module.name))--DEBUG
            local updateRate=this.ValueOrIvarValue(module.updateRate)--tex nextUpdate=currentTime+updateRate, in seconds, with decimal for < second
            this.ExecUpdate(currentChecks,currentTime,module.execCheckTable,module.execState,updateRate,module.Update)
          end
        end

        currentChecks.inMenu=InfMenu.menuOn--KLUDGE InfMenu is set at start of Modules, so update inMenu for following modules this frame

        if this.debugModule then
          if this.updateTimes[module.name] then
            table.insert(this.updateTimes[module.name],os.clock()-this.startTime)
          end
        end
      end--if module.Update
    end--for InfModules
  end--if mainModulesOK
  ---
  InfButton.UpdatePressed()--tex GOTCHA: should be after all key reads, sets current keys to prev keys for onbutton checks

  if this.debugModule then
  --    this.updateTimes[#this.updateTimes+1]=os.clock()-this.startTime
  end
end--Update

function this.ExecUpdate(currentChecks,currentTime,execChecks,execState,updateRate,ExecUpdateFunc)
  --tex modules may set their own update rate
  if execState and execState.nextUpdate>currentTime then
    return
  end

  if execChecks then
    for check,ivarCheck in pairs(execChecks) do
      if currentChecks[check]~=ivarCheck then
        return
      end
    end
  end

  --  if not IsFunc(ExecUpdateFunc) then
  --    InfCore.DebugPrint"ExecUpdateFunc is not a function"
  --    return
  --  end

  InfCore.PCallDebug(ExecUpdateFunc,currentChecks,currentTime,execChecks,execState)
  --DEBUG ExecUpdateFunc(currentChecks,currentTime,execChecks,execState)

  if updateRate>0 then
    if execState==nil then
      InfCore.Log("ERROR: InfMain.ExecUpdate execState==nil",false,true)
    else
      execState.nextUpdate=currentTime+updateRate
    end
  end

  --DEBUG
  --if currentChecks.inGame then
  -- InfCore.DebugPrint("currentTime: "..tostring(currentTime).." updateRate:"..tostring(updateRate) .." nextUpdate:"..tostring(execState.nextUpdate))
  --end
end

function this.DoControlSet(currentChecks)
  local InfButton=InfButton

  local abortButton=InfButton.ESCAPE
  InfButton.buttonStates[abortButton].holdTime=1.6

  if InfButton.OnButtonHoldTime(abortButton) then
    if gvars.ini_isTitleMode then
      local splash=SplashScreen.Create("abortsplash","/Assets/tpp/ui/ModelAsset/sys_logo/Pictures/common_kjp_logo_clp_nmp.ftex",640,640)
      SplashScreen.Show(splash,0,0.3,0)
      this.abortToAcc=true
      this.ClearOnAbortToACC()
    else--elseif currentChecks.inGame then--WIP
    --this.ClearStatus()
    end
  end

  if currentChecks.inGame then
    if InfButton.OnComboActive(reloadModulesCombo) then
      InfCore.DebugPrint("LoadExternalModules")
      InfMenu.MenuOff()
      this.LoadExternalModules(true)
      if not InfCore.mainModulesOK then
        this.ModuleErrorMessage()
      end
    end
  end
end

function this.RegenSeed(currentMission,nextMission)
  local currentMission=currentMission or vars.missionCode
  local nextMission=nextMission or vars.missionCode
  --tex hard to find a line to draw in the sand between one mission and the next, so i'm just going for if you've gone to acc then that you're new levelseed set
  -- this does mean that free roam<>mission wont get a change though, but that may be useful in some circumstances
  if this.IsHelicopterSpace(nextMission) and currentMission>5 then
    this.RandomResetToOsTime()
    igvars.inf_levelSeed=math.random(0,2147483647)
    InfCore.Log("InfMain.RegenSeed new seed "..tostring(igvars.inf_levelSeed))--DEBUG
  end
end

function this.RandomSetToLevelSeed()
  --  InfCore.Log("RandomSetToLevelSeed:"..tostring(igvars.inf_levelSeed))--DEBUG
  --  InfCore.Log("caller:"..InfCore.DEBUG_Where(2))--DEBUG
  igvars.inf_levelSeed=igvars.inf_levelSeed or 1
  math.randomseed(igvars.inf_levelSeed)
  math.random()
  math.random()
  math.random()
end

function this.RandomResetToOsTime()
  --  InfCore.Log"RandomResetToOsTime"--DEBUG
  --  InfCore.Log("caller:"..InfCore.DEBUG_Where(2))--DEBUG
  math.randomseed(os.time())
  math.random()
  math.random()
  math.random()
end



function this.MinMaxIvarRandom(ivarName)
  local ivarMin=Ivars[ivarName.."_MIN"]
  local ivarMax=Ivars[ivarName.."_MAX"]
  return math.random(ivarMin:Get(),ivarMax:Get())
end

this.SetFriendlyCp = function()
  local gameObjectId = { type="TppCommandPost2", index=0 }
  local command = { id="SetFriendlyCp" }
  GameObject.SendCommand( gameObjectId, command )
end

this.SetFriendlyEnemy = function()
  local gameObjectId = { type="TppSoldier2" }
  local command = { id="SetFriendly", enabled=true }
  GameObject.SendCommand( gameObjectId, command )
end

--tex built by BuildCpPositions, but has vanilla positions to tide over till that kicks in
--DEBUGNOW but then you'd want some alternate from mission addons too
this.cpPositions={
  afgh={
    afgh_citadelSouth_ob={-1682.557,536.637,-2409.226},
    afgh_sovietSouth_ob={-1558.834,414.159,-1159.438},
    afgh_plantWest_ob={-1173.101,458.269,-1392.586},
    afgh_waterwayEast_ob={-1358.766,398.534,-742.015},
    afgh_tentNorth_ob={-1758.428,336.844,211.112},
    afgh_enemyNorth_ob={-182.129,411.550,-454.07},
    afgh_cliffWest_ob={302.273,415.153,-860.780},
    afgh_tentEast_ob={-1169.6,302.742,938.917},
    afgh_enemyEast_ob={-361.562,356.97,114.79},
    afgh_cliffEast_ob={1259.04,479.846,-1345.574},
    afgh_slopedWest_ob={99.113,334.220,89.654},
    afgh_remnantsNorth_ob={-1065.079,291.448,1467.447},
    afgh_cliffSouth_ob={1040.302,379.051,-505.49},
    afgh_fortWest_ob={1825.444,465.684,-1252.843},
    afgh_villageWest_ob={-258.249,298.451,927.591},
    afgh_slopedEast_ob={977.664,318.965,-169.445},
    afgh_fortSouth_ob={2194.072,429.323,-1271},
    afgh_villageNorth_ob={504.530,329.411,702.308},
    afgh_commWest_ob={983.531,347.594,665.96},
    afgh_bridgeWest_ob={1584.864,347.409,48.656},
    afgh_bridgeNorth_ob={2394.559,369.135,-517.208},
    afgh_fieldWest_ob={8.862,274.866,1992.816},
    afgh_villageEast_ob={939.176,318.845,1259.34},
    afgh_ruinsNorth_ob={1623.511,323.038,1062.995},
    afgh_fieldEast_ob={1101.482,318.458,1828.101},

    --afgh_plantSouth_ob--Only references in generic setups",-- no actual missions
    --afgh_waterway_cp--Only references in generic setups",-- no actual missions

    afgh_cliffTown_cp={787,466,-994},
    afgh_tent_cp={-1761.73,317.69,806.51},
    afgh_powerPlant_cp={-685,533,-1487},
    afgh_sovietBase_cp={-2197,443,-1474},
    afgh_remnants_cp={-905.605,288.846,1922.272},
    afgh_field_cp={425.95,270.16,2198.39},
    afgh_citadel_cp={-1251.708,595.181,-2936.821},
    afgh_fort_cp={2106.16,463.64,-1747.21},
    afgh_village_cp={508,319,1171},
    afgh_bridge_cp={1920,322,-475},
    afgh_commFacility_cp={1488.730,357.429,459.287},
    afgh_slopedTown_cp={514.191,331.173,43.403},
    afgh_enemyBase_cp={-596.89,353.02,497.40},
  },
  mafr={
    mafr_swampWest_ob={-561.458,1.203,-189.687},--Guard Post 01, NW Kiziba Camp
    mafr_diamondNorth_ob={1326.073,152.667,-1899.799},--Guard Post 02, NE Kungenga Mine
    mafr_bananaEast_ob={570.117,79.988,-1071.741},--Guard Post 03, SE Bampeve Plantation
    mafr_bananaSouth_ob={232.093,3.048,-653.531},--Guard Post 04, SW Bampeve Plantation
    mafr_savannahNorth_ob={707.557,34.091,-913.209},--Guard Post 05, NE Ditadi Abandoned Village
    mafr_outlandNorth_ob={-806.758,1.056,690.615},--Guard Post 06, North Masa Village
    mafr_diamondWest_ob={1047.941,121.694,-1170.218},--Guard Post 07, West Kungenga Mine
    mafr_labWest_ob={2146.880,192.241,-2177.558},--Guard Post 08, NW Lufwa Valley
    mafr_savannahWest_ob={713.843,3.120,-547.492},--Guard Post 09, North Ditadi Abandoned Village
    mafr_swampEast_ob={344.727,-5.164,-7.508},--Guard Post 10, SE Kiziba Camp
    mafr_outlandEast_ob={-275.585,-7.796,767.962},--Guard Post 11, East Masa Village
    mafr_swampSouth_ob={316.517,-5.944,369.979},--Guard Post 12, South Kiziba Camp
    mafr_diamondSouth_ob={1439.533,99.656,-720.559},--Guard Post 13, SW Kungenga Mine
    mafr_pfCampNorth_ob={928.184,-4.859,372.320},--Guard Post 14, NE Nova Braga Airport
    mafr_savannahEast_ob={1197.290,8.719,78.842},--Guard Post 15, South Ditadi Abandoned Village
    mafr_hillNorth_ob={1915.400,60.799,-230.770},--Guard Post 16, NE Munoko ya Nioka Station
    mafr_factoryWest_ob={2515.327,71.937,-814.150},--Guard Post 17, West Ngumba Industrial Zone
    mafr_pfCampEast_ob={1196.617,-4.470,567.516},--Guard Post 18, East Nova Braga Airport
    mafr_hillWest_ob={1673.172,24.406,137.511},--Guard Post 19, NW Munoko ya Nioka Station
    mafr_factorySouth_ob={2349.303,68.733,-113.923},--Guard Post 20, SW Ngumba Industrial Zone
    mafr_hillWestNear_ob={1799.202,-4.737,711.536},--Guard Post 21, West Munoko ya Nioka Station
    mafr_chicoVilWest_ob={1549.457,-10.819,1776.419},--Guard Post 22, South Nova Braga Airport
    mafr_hillSouth_ob={2012.754,-10.564,1376.297},--Guard Post 23, SW Munoko ya Nioka Station
    --mafr_swampWestNear_ob--Only references in generic setups, no actual missions

    mafr_flowStation_cp={-1001.38,-7.20,-199.16},--Mfinda Oilfield
    mafr_banana_cp={277.078,42.670,-1160.725},--Bampeve Plantation
    mafr_diamond_cp={1243.253,139.279,-1524.267},--Kungenga Mine
    mafr_lab_cp={2707.418,174.801,-2428.483},--Lufwa Valley
    mafr_swamp_cp={-55.823,-3.758,55.400},--Kiziba Camp
    mafr_outland_cp={-596.105,-16.714,1094.863},--Masa Village
    mafr_savannah_cp={979.923,26.267,-201.705},--Ditadi Abandoned Village
    mafr_pfCamp_cp={846.46,-4.97,1148.62},--Nova Braga Airport
    mafr_hill_cp={2154.83,63.09,366.70},--Munoko ya Nioka Station --redo

  --mafr_factory_cp={},--Ngumba Industrial Zone - no soldiers  NOTE in interrog
  --mafr_swampWestNear_ob={},--Only references in generic setups, no actual missions

  --mafr_chicoVil_cp={},--??
  },
  mbqf={
    mbqf_mtbs_cp={-158.183,0.801,-2076.006},
  },
  mtbs={

    mbqf_mtbs_cp={-158.183,0.801,-2076.006},--tex mbqf free (f30250) (loc 55) actually comes up as location 50/mtbs
    ["ly003_cl00_npc0000|cl00pl0_uq_0000_npc2|mtbs_command_cp"]={9.430,0.800,-24.179},
    ["ly003_cl01_npc0000|cl01pl0_uq_0010_npc2|mtbs_combat_cp"]={1141.248,8.800,-604.406},
    ["ly003_cl02_npc0000|cl02pl0_uq_0020_npc2|mtbs_develop_cp"]={1189.571,20.798,314.824},
    ["ly003_cl03_npc0000|cl03pl0_uq_0030_npc2|mtbs_support_cp"]={372.656,0.800,860.953},
    ["ly003_cl04_npc0000|cl04pl0_uq_0040_npc2|mtbs_medic_cp"]={-137.282,0.800,-964.455},
    ["ly003_cl05_npc0000|cl05pl0_uq_0050_npc2|mtbs_intel_cp"]={-668.973,4.925,524.886},
    ["ly003_cl06_npc0000|cl06pl0_uq_0060_npc2|mtbs_basedev_cp"]={-744.900,8.800,-360.478},
  }
}--cpPositions
--CALLER: InfMain.OnInitializeTop
--OUT/SIDE: this.cpPositions
--tex TODO: consider, this adds lrrp cps
local stringfind=string.find
function this.BuildCpPositions(soldierDefine)
  InfCore.LogFlow("InfMain.BuildCpPositions")
  local locationName=TppLocation.GetLocationName()
  this.cpPositions[locationName]=this.cpPositions[locationName] or {}

  for cpName,cpDefine in pairs(soldierDefine)do
    if not stringfind(cpName,"_lrrp") then
    if cpName~="quest_cp"then--tex DEBUGNOW check pos isn't 0,0,0 instead?
      local cpId=GetGameObjectId(cpName)
      if not cpId or cpId==NULL_ID then
          InfCore.Log("WARNING: InfMain.BuildCpPositions: cpId==NULL_ID for soldierDefine cpName:"..tostring(cpName))
      else
        local cpPos=SendCommand(cpId,{id="GetCpPosition"})
        if this.debugModule then
            local existingPos=this.cpPositions[locationName][cpName]
            if existingPos then
              local existPosStr=InfInspect.Inspect(existingPos)
              local newPostStr=InfInspect.Inspect(cpPos)
              InfCore.Log("cpPos for "..cpName.." replacing existing "..existPosStr.." with "..newPostStr)
            else
              InfCore.PrintInspect(cpPos,"cpPos for "..cpName.." no existing in cpPositions")
            end
        end
        this.cpPositions[locationName][cpName]=cpPos
      end--if cpId
    end--~="quest_cp"
    end--if not _lrrp
  end--for ene_cpList
end--BuildCpPositions
local FindDistance=TppMath.FindDistance
function this.GetClosestCp(position)
  local playerPos={vars.playerPosX,vars.playerPosY,vars.playerPosZ}
  position=position or playerPos

  local locationName=TppLocation.GetLocationName()
  local cpPositions=this.cpPositions[locationName]
  if cpPositions==nil then
    InfCore.Log("WARNING: GetClosestCp no cpPositions for locationName "..locationName,false,true)--DEBUGNOW
    return nil,nil,nil
  end

  local closestCp=nil
  local closestDist=9999999999999999
  local closestPosition=nil
  for cpName,cpPosition in pairs(cpPositions)do
    if cpPosition==nil then
      InfCore.Log("ERROR: GetClosestCp cpPosition==nil for "..tostring(cpName),true,true)
    elseif #cpPosition~=3 then
      InfCore.Log("ERROR: GetClosestCp #cpPosition~=3 for "..tostring(cpName),true,true)
      InfCore.PrintInspect(cpPosition,cpName.." cpPosition")
    else
      local distSqr=FindDistance(position,cpPosition)
      --InfCore.DebugPrint(cpName.." dist:"..math.sqrt(distSqr))--DEBUG
      if distSqr<closestDist then
        closestDist=distSqr
        closestCp=cpName
        closestPosition=cpPosition
      end
    end--if cpPos ok
  end--for cpPositions
  --InfCore.DebugPrint("Closest cp "..InfLangProc.CpNameString(closestCp,locationName)..":"..closestCp.." ="..math.sqrt(closestDist))--DEBUG
  local cpId=GetGameObjectId(closestCp)
  if cpId and cpId~=NULL_ID then
    return closestCp,closestDist,closestPosition
  else
    return
  end
end--GetClosestCp
--<cp stuff

--actionflags
function this.RestoreActionFlag()
  --local activeControlMode=this.GetActiveControlMode()
  -- WIP
  --  if activeControlMode then
  --    if bit.band(vars.playerDisableActionFlag,menuDisableActions)==menuDisableActions then
  --    else
  --      this.EnableAction(menuDisableActions)
  --    end
  --  else
  this.EnableAction(this.menuDisableActions)
  --  end
end

function this.DisableAction(actionFlag)
  if not this.ActionIsDisabled(actionFlag) then
    vars.playerDisableActionFlag=vars.playerDisableActionFlag+actionFlag
  end
end
function this.EnableAction(actionFlag)
  if this.ActionIsDisabled(actionFlag) then
    vars.playerDisableActionFlag=vars.playerDisableActionFlag-actionFlag
  end
end

function this.ActionIsDisabled(actionFlag)
  if bit.band(vars.playerDisableActionFlag,actionFlag)==actionFlag then
    return true
  end
  return false
end

--
this.allButCamPadMask={
  settingName="allButCam",
  except=true,
  --buttons=PlayerPad.STANCE,
  sticks=PlayerPad.STICK_R,
}
--CULL REF
--local commonControlPadMask={
--  settingName="controlMode",
--  except=false,
--  buttons=PlayerPad.ALL,
--  sticks=PlayerPad.STICK_L,--+PlayerPad.STICK_R,
--  triggers=PlayerPad.TRIGGER_L+PlayerPad.TRIGGER_R,
--}

function this.GetActiveControlMode()
  local controlModes={
    Ivars.warpPlayerUpdate,
    Ivars.adjustCameraUpdate,
  }
  for i,ivar in ipairs(controlModes)do
    if ivar:Is(1) then
      return ivar
    end
  end
  return nil
end
--

--tex duplication of TppDefine with outer clusters defined
--Separation is Quarantine,Ward,mbqf
--Zoo ly500, don't think it's officially cluster 8, but I'm making it so
this.CLUSTER_NAME={"Command","Combat","Develop","Support","Medical","Spy","BaseDev","Separation","Zoo"}
--this.CLUSTER_DEFINE=InfUtil.EnumFrom0(this.CLUSTER_NAME)-- InfUtil
--this.PLNT_NAME={"Special","Common1","Common2","Common3"}--or plat0-plat3
--this.PLNT_DEFINE=this.Enum(this.PLNT_NAME)

--lrrp plus
this.baseNames={
  afgh={
    --TODO HANG "afgh_citadelSouth_ob",--Guard Post 01, East Afghanistan Central Base Camp
    "afgh_sovietSouth_ob",--Guard Post 02, South Afghanistan Central Base Camp
    "afgh_plantWest_ob",--Guard Post 03, NW Serak Power Plant
    "afgh_waterwayEast_ob",--Guard Post 04, East Aabe Shifap Ruins
    "afgh_tentNorth_ob",--Guard Post 05, NE Yakho Oboo Supply Outpost--note: not in 30010 interrogate
    "afgh_enemyNorth_ob",--Guard Post 06, NE Wakh Sind Barracks
    "afgh_cliffWest_ob",--Guard Post 07, NW Sakhra Ee Village
    "afgh_tentEast_ob",--Guard Post 08, SE Yakho Oboo Supply Outpost
    "afgh_enemyEast_ob",--Guard Post 09, East Wakh Sind Barracks
    "afgh_cliffEast_ob",--Guard Post 10, East Sakhra Ee Village
    "afgh_slopedWest_ob",--Guard Post 11, NW Ghwandai Town
    "afgh_remnantsNorth_ob",--Guard Post 12, North Lamar Khaate Palace
    "afgh_cliffSouth_ob",--Guard Post 13, South Sakhra Ee Village
    "afgh_fortWest_ob",--Guard Post 14, West Smasei Fort
    "afgh_villageWest_ob",--Guard Post 15, NW Wialo Village
    "afgh_slopedEast_ob",--Guard Post 16, SE Da Ghwandai Khar
    "afgh_fortSouth_ob",--Guard Post 17, SW Smasei Fort
    "afgh_villageNorth_ob",--Guard Post 18, NE Wailo Village
    "afgh_commWest_ob",--Guard Post 19, West Eastern Communications Post
    "afgh_bridgeWest_ob",--Guard Post 20, West Mountain Relay Base
    "afgh_bridgeNorth_ob",--Guard Post 21, SE Mountain Relay Base
    "afgh_fieldWest_ob",--Guard Post 22, North Shago Village
    "afgh_villageEast_ob",--Guard Post 23, SE Wailo Village
    "afgh_ruinsNorth_ob",--Guard Post 24, East Spugmay Keep
    "afgh_fieldEast_ob",--Guard Post 25, East Shago Village

    --"afgh_plantSouth_ob",--Only references in generic setups, no actual missions
    --"afgh_waterway_cp",--Only references in generic setups, no actual missions

    "afgh_cliffTown_cp",--Qarya Sakhra Ee
    "afgh_tent_cp",--Yakho Oboo Supply Outpost
    "afgh_powerPlant_cp",--Serak Power Plant
    "afgh_sovietBase_cp",--Afghanistan Central Base Camp
    "afgh_remnants_cp",--Lamar Khaate Palace
    "afgh_field_cp",--Da Shago Kallai
    "afgh_citadel_cp",--OKB Zero
    "afgh_fort_cp",--Da Smasei Laman
    "afgh_village_cp",--Da Wialo Kallai
    "afgh_bridge_cp",--Mountain Relay Base
    "afgh_commFacility_cp",--Eastern Communications Post
    "afgh_slopedTown_cp",--Da Ghwandai Khar
    "afgh_enemyBase_cp",--Wakh Sind Barracks
  },--#39

  mafr={
    "mafr_swampWest_ob",--Guard Post 01, NW Kiziba Camp
    "mafr_diamondNorth_ob",--Guard Post 02, NE Kungenga Mine
    "mafr_bananaEast_ob",--Guard Post 03, SE Bampeve Plantation
    "mafr_bananaSouth_ob",--Guard Post 04, SW Bampeve Plantation
    "mafr_savannahNorth_ob",--Guard Post 05, NE Ditadi Abandoned Village
    "mafr_outlandNorth_ob",--Guard Post 06, North Masa Village
    "mafr_diamondWest_ob",--Guard Post 07, West Kungenga Mine
    "mafr_labWest_ob",--Guard Post 08, NW Lufwa Valley
    "mafr_savannahWest_ob",--Guard Post 09, North Ditadi Abandoned Village
    "mafr_swampEast_ob",--Guard Post 10, SE Kiziba Camp
    "mafr_outlandEast_ob",--Guard Post 11, East Masa Village
    "mafr_swampSouth_ob",--Guard Post 12, South Kiziba Camp
    "mafr_diamondSouth_ob",--Guard Post 13, SW Kungenga Mine
    "mafr_pfCampNorth_ob",--Guard Post 14, NE Nova Braga Airport
    "mafr_savannahEast_ob",--Guard Post 15, South Ditadi Abandoned Village
    "mafr_hillNorth_ob",--Guard Post 16, NE Munoko ya Nioka Station
    --TODO HANG addlrrp  "mafr_factoryWest_ob",--Guard Post 17, West Ngumba Industrial Zone
    "mafr_pfCampEast_ob",--Guard Post 18, East Nova Braga Airport
    "mafr_hillWest_ob",--Guard Post 19, NW Munoko ya Nioka Station
    "mafr_factorySouth_ob",--Guard Post 20, SW Ngumba Industrial Zone
    "mafr_hillWestNear_ob",--Guard Post 21, West Munoko ya Nioka Station
    "mafr_chicoVilWest_ob",--Guard Post 22, South Nova Braga Airport
    "mafr_hillSouth_ob",--Guard Post 23, SW Munoko ya Nioka Station
    --"mafr_swampWestNear_ob",--Only references in generic setups, no actual missions
    "mafr_flowStation_cp",--Mfinda Oilfield
    "mafr_banana_cp",--Bampeve Plantation
    "mafr_diamond_cp",--Kungenga Mine
    "mafr_lab_cp",--Lufwa Valley
    "mafr_swamp_cp",--Kiziba Camp
    "mafr_outland_cp",--Masa Village
    "mafr_savannah_cp",--Ditadi Abandoned Village
    "mafr_pfCamp_cp",--Nova Braga Airport
    "mafr_hill_cp",--Munoko ya Nioka Station

  --"mafr_factory_cp",--Ngumba Industrial Zone - no soldiers  NOTE in interrog
  --"mafr_chicoVil_cp",--??
  },--#34
  mbqf={
    "mbqf_mtbs_cp",
  },
  mtbs={
    "mbqf_mtbs_cp",--tex WORKAROUND mbqf free (f30250) (loc 55) actually comes up as location 50/mtbs
    "ly003_cl00_npc0000|cl00pl0_uq_0000_npc2|mtbs_command_cp",
    "ly003_cl01_npc0000|cl01pl0_uq_0010_npc2|mtbs_combat_cp",
    "ly003_cl02_npc0000|cl02pl0_uq_0020_npc2|mtbs_develop_cp",
    "ly003_cl03_npc0000|cl03pl0_uq_0030_npc2|mtbs_support_cp",
    "ly003_cl04_npc0000|cl04pl0_uq_0040_npc2|mtbs_medic_cp",
    "ly003_cl05_npc0000|cl05pl0_uq_0050_npc2|mtbs_intel_cp",
    "ly003_cl06_npc0000|cl06pl0_uq_0060_npc2|mtbs_basedev_cp",
  },
}

--tex in the mission soldierDefine tables there's a bunch of empty _lrrp cps that I'm repurposing
local lrrpInd="_lrrp"
function this.BuildEmptyCpPool(soldierDefine)
  local cpPool={}
  for cpName,cpDefine in pairs(soldierDefine)do
    local cpId=GetGameObjectId("TppCommandPost2",cpName)
    if cpId==NULL_ID then
      InfCore.DebugPrint("BuildEmptyCpPool: soldierDefine "..cpName.."==NULL_ID")--DEBUG
    else
      if #cpDefine==0 then
        --tex cp is labeled _lrrp
        if string.find(cpName,lrrpInd) then
          if not cpDefine.lrrpVehicle and not cpDefine.travelPlan then
            cpPool[#cpPool+1]=cpName
          end
        end
      end
    end
  end
  --  InfCore.Log"cpPool"--DEBUG
  --  InfCore.PrintInspect(cpPool)--DEBUG
  return cpPool
end

function this.BuildBaseCpPool(soldierDefine)
  local cpPool={}
  for cpName,cpDefine in pairs(soldierDefine)do
    local cpId=GetGameObjectId("TppCommandPost2",cpName)
    if cpId==NULL_ID then
      InfCore.DebugPrint("BuildCpPool: soldierDefine "..cpName.."==NULL_ID")--DEBUG
    else
      if #cpDefine>0 then
        if not cpDefine.lrrpVehicle and not cpDefine.travelPlan then
          cpPool[#cpPool+1]=cpName
        end
      end
    end
  end
  --  InfCore.Log"cpPool"--DEBUG
  --  InfCore.PrintInspect(cpPool)--DEBUG
  return cpPool
end

--IN-SIDE: InfVehicle.inf_patrolVehicleConvoyInfo
function this.BuildCpPoolWildCard(soldierDefine)
  local baseNamePool={}
  for cpName,cpDefine in pairs(soldierDefine)do
    if #cpDefine>0 then
      local cpId=GetGameObjectId("TppCommandPost2",cpName)
      if cpId==NULL_ID then
        InfCore.Log("BuildCpPoolWildCard: soldierDefine cpId==NULL",true)--DEBUG
      else
        --tex TODO: allow quest_cp, but regenerate soldier on quest load
        if cpName=="quest_cp" then
        --tex TODO: consider if you want to  have wilcards in lrrps
        elseif cpDefine.lrrpVehicle==nil and cpDefine.lrrpTravelPlan~=nil then
        elseif cpDefine.lrrpVehicle~=nil then
          if #cpDefine>1 then--ASSUMPTION only armored vehicles have 1 occupant
            --WORKAROUND the ordering of convoy setup/filling previously empty cpDefines on checkpoint restart
            local isConvoy=InfVehicle.inf_patrolVehicleConvoyInfo[cpDefine.lrrpTravelPlan]
            if isConvoy==false then
              baseNamePool[#baseNamePool+1]=cpName
            end
          end
        else
          baseNamePool[#baseNamePool+1]=cpName
        end
      end
    end
  end
  return baseNamePool
end
---
function this.MarkObject(gameId)
  if gameId==NULL_ID then
    return
  end

  local radiusLevel=0--0-9
  local goalType="none"--TppMarker.GoalTypes
  local viewType="all"--TppMarker.ViewTypes
  local randomLevel=0--0-9 randoms to radiuslevel I guess
  local setImportant=true
  local setNew=false
  TppMarker.Enable(gameId,0,"moving","all",0,setImportant,setNew)
end
---

function this.ClearStatus()
  InfCore.PCall(function()
    local splash=SplashScreen.Create("abortsplash","/Assets/tpp/ui/ModelAsset/sys_logo/Pictures/common_kjp_logo_clp_nmp.ftex",640,640)
    SplashScreen.Show(splash,0,0.3,0)

    vars.playerDisableActionFlag=PlayerDisableAction.NONE
    Player.SetPadMask{settingName="AllClear"}
    Tpp.SetGameStatus{target="all",enable=true,scriptName="InfMain.lua"}
    InfCore.DebugPrint"Cleared status"
  end)
end

local startOnFootStr="startOnFoot"
function this.IsStartOnFoot(missionCode,isAssaultLz)
  local missionCode=missionCode or vars.missionCode
  local enabled=IvarProc.EnabledForMission(startOnFootStr,missionCode)

  local assault=IvarProc.IsForMission(startOnFootStr,"NOT_ASSAULT",missionCode)
  if isAssaultLz and assault then
    return false
  else
    return enabled
  end
end

--ORPHAN
function this.ReadSaveVar(name,category)
  local category=category or TppScriptVars.CATEGORY_GAME_GLOBAL
  local globalSlotForSaving={TppDefine.SAVE_SLOT.SAVING,TppDefine.SAVE_FILE_INFO[category].slot}
  return TppScriptVars.GetVarValueInSlot(globalSlotForSaving,"gvars",name,0)
end

function this.IsContinue()
  return gvars.sav_varRestoreForContinue and not this.isContinueFromTitle
end

function this.WeaponVarsSanityCheck()
  --tex throw on some default weapons if using dummy/equip none so to not run afoul of CheckPlayerEquipmentServerItemCorrect
  --see SetSubsistenceSettings for alt attempt that doesn't seem to work.
  --TODO: currently the weapons arent added via RequestLoadToEquipMissionBlock so weapons wont be usable, but since the user would have had decided to go into fob with equip_none instead of changing to a proper loadout whatev
  if this.IsOnlineMission(vars.missionCode) then
    local changedWeapon=vars.weapons[TppDefine.WEAPONSLOT.PRIMARY_HIP]==TppEquip.EQP_None or vars.weapons[TppDefine.WEAPONSLOT.SECONDARY]==TppEquip.EQP_None
    if changedWeapon then
      InfMenu.PrintLangId"fob_weapon_change"
    end
    if vars.weapons[TppDefine.WEAPONSLOT.PRIMARY_HIP]==TppEquip.EQP_None then
      --SVG-76 grade 1
      Player.ChangeEquip{
        equipId=TppEquip.EQP_WP_East_ar_010,
        stock=31,
        stockSub=0,
        ammo=180,
        ammoSub=0,
        dropPrevEquip = false,
      }
    end
    if vars.weapons[TppDefine.WEAPONSLOT.SECONDARY]==TppEquip.EQP_None then
      --Wu S grade 1
      Player.ChangeEquip{
        equipId=TppEquip.EQP_WP_West_thg_010,
        stock=8,
        stockSub=0,
        ammo=14,
        ammoSub=0,
        suppressorLife=100,
        isSuppressorOn=true,
        isLightOn=false,
        dropPrevEquip=false,
      }
    end
  end
end

function this.IsOnlineMission(missionCode)
  --tex TODO: revisit if ever return to SSD
  --  if InfCore.gameId=="TPP" then
  --    return this.IsFOBMission(missionCode)
  --  else--SSD
  --    return this.IsMultiPlayMission(missionCode)
  --  end
  --tex just do isfobmission for tpp
  local firstDigit=floor(missionCode/1e4)--DEBUGNOW *0.0001)
  if firstDigit==5 then
    return true
  else
    return false
  end
end

--tpp
function this.IsFOBMission(missionCode)
  local firstDigit=math.floor(missionCode/1e4)
  if firstDigit==5 then
    return true
  else
    return false
  end
end
function this.IsHelicopterSpace(missionCode)
  local firstDigit=math.floor(missionCode/1e4)
  if firstDigit==4 then
    return true
  else
    return false
  end
end
function this.IsSafeSpace(missionCode)
  if InfCore.gameId=="TPP" then
    return this.IsHelicopterSpace(missionCode)
  else
    return missionCode==TppDefine.SYS_MISSION_ID.TITLE
  end
end
--ssd
function this.IsMultiPlayMission(missionCode)
  if missionCode==TppDefine.SYS_MISSION_ID.TITLE then
  -- return true--DEBUGNOW OFF, a departure from SSDs IsMultiPlayMission, but otherwise would block IsSafeSpace
  end
  local firstDigit=math.floor(missionCode/1e4)
  if firstDigit==2 then
    return true
  else
    return false
  end
end
function this.IsMatchingRoom(missionCode)
  if missionCode==TppDefine.SYS_MISSION_ID.TITLE then
    return true
  end
  local first2Digits=math.floor(missionCode/1e3)
  return first2Digits==21
end

function this.ValueOrIvarValue(value)
  local value=value or 0
  if value and IsTable(value) then--IsIvar--DEBUGNOW
    value=value:Get()
  end
  return value
end

function this.DisplayFox32(foxString)
  local str32 = StrCode32(foxString)
  TppUiCommand.AnnounceLogView("string :"..foxString .. "="..str32)
end

--CALLERs: InfMain.OnAllocateTop, InfMain.PostAllModulesLoad, Ivar debugMode, all with enable param being current Ivar debugMode setting
function this.DebugModeEnable(enable)
  local prevMode=InfCore.debugMode

  if enable then
    InfCore.logLevel=InfCore.level_trace
    InfCore.Log("DebugModeEnable:"..tostring(enable),false)
    if InfHooks then
      InfCore.PCall(InfHooks.SetupDebugHooks)
    end
    if IHDebugVars then
      IHDebugVars.AddDevMenus()
    end
  else
    InfCore.logLevel=InfCore.level_warn
    InfCore.Log("Further non critical logging disabled while debugMode is off")
  end

  if IHH then
    --tex TODO: play nice with log_SetFlushLevel
    --IHH.Log_SetFlushLevel(InfCore.logLevel)--TODO: only when shifted to .Log with level param (see LogWIP)
    IHH.Log_Flush()
  end
  InfCore.debugMode=enable
end

--modules
--SIDE: modules,this.modulesOK
--SIDE: InfCore.files
--SIDE: this.moduleNames
--isReload = user initiated
--CALLER: InfInitMain, also by command or key combo with isReload set
--GOTCHA: loaded after Tpp, before TppVarInit, TppGVars. TODO: bump it down so those are up too?
function this.LoadExternalModules(isReload)
  local isReload=isReload or false
  InfCore.Log("InfMain.LoadExternalModules "..tostring(isReload))

  local count=collectgarbage("count")
  InfCore.Log("Lua memory usage start: "..count.." KB")

  InfCore.mainModulesOK=true
  InfCore.otherModulesOK=true

  --tex clear InfModules
  InfModules.moduleNames={}
  for i=1,#InfModules do
    InfModules[i]=nil
  end

  for i,moduleName in ipairs(InfModules.dependentOrder)do
    table.insert(InfModules.moduleNames,moduleName)
  end

  --tex get other external modules
  if isReload then
    InfCore.PCallDebug(InfCore.RefreshFileList)
  end
  InfModules.externalModules={}
  local moduleFiles=InfCore.GetFileList(InfCore.files.modules,".lua",true)
  for i,moduleName in ipairs(moduleFiles)do
    InfModules.externalModules[moduleName]=true
    if not InfModules.isOrderedModule[moduleName] then
      table.insert(InfModules.moduleNames,moduleName)
    end
  end
  InfCore.PrintInspect(InfModules.moduleNames,"InfModules.moduleNames")--DEBUG

  local clock=os.clock
  for i,moduleName in ipairs(InfModules.moduleNames) do
    if not isReload or InfModules.externalModules[moduleName] then--tex don't try and reload internal
      local startTime=clock()
      InfCore.LoadExternalModule(moduleName,isReload)
      local endTime=clock()-startTime
      --InfCore.Log("Loaded in "..endTime)
    end

    local module=_G[moduleName]
    if module then
      --InfCore.Log("Loaded "..moduleName)--DEBUG
      module.name=moduleName
      table.insert(InfModules,module)
    else
      if InfModules.isOrderedModule[moduleName] then
        InfCore.mainModulesOK=false
      else
        InfCore.otherModulesOK=false
      end
    end
  end

  InfCore.LogFlow("PostAllModulesLoad")--DEBUG
  InfCore.PCallDebug(this.PostAllModulesLoad)
  --NOTE: On first load only InfMain has been loaded at this point, so can't reference other IH lib modules.
  this.CallOnModules("PostAllModulesLoad",isReload)

  --tex profiles
  local ret=InfCore.PCall(IvarProc.SetupInfProfiles)
  --WORKAROUND PCall
  if ret and Ivars then
    Ivars.profileNames=ret[1]
    Ivars.profiles=ret[2]
  end
  --DEBUG
  --  InfCore.Log"--------------"
  --  InfCore.PrintInspect(Ivars.profileNames)
  --  InfCore.PrintInspect(Ivars.profiles)

  count=collectgarbage("count")
  InfCore.Log("Lua memory usage end: "..count.." KB")
  local startTime=os.clock()
  collectgarbage()
  local endTime=os.clock()-startTime
  InfCore.Log("collectgarbage time: "..endTime)
  count=collectgarbage("count")
  InfCore.Log("Lua memory usage post collect: "..count.." KB")
end--LoadExternalModules

--tex runs a function on all IH modules, used as the main message/event propogation to ih modules
function this.CallOnModules(functionName,...)
  InfCore.LogFlow("InfMain.CallOnModules: "..functionName)
  local clock=os.clock
  for i,module in ipairs(InfModules) do
    if IsFunc(module[functionName]) then
      local startTime=clock()
      if this.debugModule then
        InfCore.LogFlow(module.name.."."..functionName..":")
      end
      local ok,err=pcall(module[functionName],...)
      if not ok then
        InfCore.Log("ERROR: "..module.name.."."..functionName..": "..err)
      end
      local endTime=clock()-startTime
      --InfCore.Log("Run in "..endTime)--tex DEBUG
    end
  end--for InfModules
end--CallOnModules

function this.ModDirErrorMessage()
  --tex TODO: if InfLang then printlangid else -v-
  local msg="Infinite Heaven: Could not find MGS_TPP\\mod\\. See FAQ Known issues.txt"
  InfCore.DebugPrint(msg)
  InfCore.Log(msg,false,true)
end

function this.ModuleErrorMessage()
  --tex TODO: if InfLang then printlangid else -v-
  InfCore.DebugPrint"Infinite Heaven: Could not load modules from MGS_TPP\\mod\\. See FAQ Known issues.txt"
  InfCore.Log("Infinite Heaven: Could not load modules from MGS_TPP\\mod\\. See FAQ Known issues.txt",false,true)
end

function this.PostModuleReloadMain(module,prevModule)
  --tex rather than have to deal with it in each module
  if prevModule and prevModule.messageExecTable then
    module.messageExecTable=Tpp.MakeMessageExecTable(module.Messages())
  end
end

function this.PostAllModulesLoad()
  local enable=Ivars.debugMode:Is(1)
  this.DebugModeEnable(enable)
end

--CALLER end of start2nd.lua
--tex all base game init and start scripts, including lib/ modules have been loaded by this point 
--tex named after that, a more accurate name might be LoadInfos since I'm most commonly using it to load addon/Info files of modules
function this.LoadLibraries()
  InfCore.LogFlow"InfMain.LoadLibraries"

  InfMain.CallOnModules("LoadLibraries")
  InfMain.CallOnModules("LoadSave")
  
  InfCore.LogFlow"/InfMain.LoadLibraries done"
end

InfCore.LogFlow"/InfMain.lua done"

return this
