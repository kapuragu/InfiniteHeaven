-- DOBUILD: 1
-- TppMain.lua
InfCore.LogFlow"Load TppMain.lua"--tex DEBUG
local this={}
local ApendArray=Tpp.ApendArray
--ORPHAN local DEBUG_StrCode32ToString=Tpp.DEBUG_StrCode32ToString
local IsTypeFunc=Tpp.IsTypeFunc
local IsTypeTable=Tpp.IsTypeTable
local IsSavingOrLoading=TppScriptVars.IsSavingOrLoading
local UpdateScriptsInScriptBlocks=ScriptBlock.UpdateScriptsInScriptBlocks
local GetCurrentMessageResendCount=Mission.GetCurrentMessageResendCount
local InfCore=InfCore--tex

local moduleUpdateFuncs={}
local moduleUpdateFuncNames={}--tex
local numModuleUpdateFuncs=0
local missionScriptOnUpdateFuncs={}
local missionScriptOnUpdateFuncNames={}--tex
local numOnUpdate=0
--ORPHAN local RENAMEsomeupdatetable2={}
--ORPHAN local RENAMEsomeupdate2=0
--ORPHAN local unk1={}
--ORPHAN local unk2=0
local onMessageTable={}
local onMessageNames={}--tex
--ORPHAN local unk3={}
local onMessageTableSize=0
local messageExecTable={}
local messageExecNames={}--tex
--ORPHAN local unk4={}
local messageExecTableSize=0
--NMC: cant actually see this referenced anywhere
local function YieldForQuarkSystemLoad()
  if QuarkSystem.GetCompilerState()==QuarkSystem.COMPILER_STATE_WAITING_TO_LOAD then
    QuarkSystem.PostRequestToLoad()
    coroutine.yield()
    while QuarkSystem.GetCompilerState()==QuarkSystem.COMPILER_STATE_WAITING_TO_LOAD do
      coroutine.yield()
    end
  end
end
function this.DisableGameStatus()
  TppMission.DisableInGameFlag()
  Tpp.SetGameStatus{target="all",enable=false,except={S_DISABLE_NPC=false},scriptName="TppMain.lua"}
end
function this.DisableGameStatusOnGameOverMenu()
  TppMission.DisableInGameFlag()
  Tpp.SetGameStatus{target="all",enable=false,scriptName="TppMain.lua"}
end
function this.EnableGameStatus()
  TppMission.EnableInGameFlag()
  Tpp.SetGameStatus{target={S_DISABLE_PLAYER_PAD=true,S_DISABLE_TARGET=true,S_DISABLE_NPC=true,S_DISABLE_NPC_NOTICE=true,S_DISABLE_PLAYER_DAMAGE=true,S_DISABLE_THROWING=true,S_DISABLE_PLACEMENT=true},enable=true,scriptName="TppMain.lua"}
end
function this.EnableGameStatusForDemo()
  TppDemo.ReserveEnableInGameFlag()
  Tpp.SetGameStatus{target={S_DISABLE_PLAYER_PAD=true,S_DISABLE_TARGET=true,S_DISABLE_NPC=true,S_DISABLE_NPC_NOTICE=true,S_DISABLE_PLAYER_DAMAGE=true,S_DISABLE_THROWING=true,S_DISABLE_PLACEMENT=true},enable=true,scriptName="TppMain.lua"}
end
function this.EnableAllGameStatus()
  TppMission.EnableInGameFlag()
  Tpp.SetGameStatus{target="all",enable=true,scriptName="TppMain.lua"}
end
function this.EnablePlayerPad()
  TppGameStatus.Reset("TppMain.lua","S_DISABLE_PLAYER_PAD")
end
function this.DisablePlayerPad()
  TppGameStatus.Set("TppMain.lua","S_DISABLE_PLAYER_PAD")
end
function this.EnablePause()
  TppPause.RegisterPause"TppMain.lua"
end
function this.DisablePause()
  TppPause.UnregisterPause"TppMain.lua"
end
function this.EnableBlackLoading(showLoadingTips)
  TppGameStatus.Set("TppMain.lua","S_IS_BLACK_LOADING")
  if showLoadingTips then--tex CULL and not Ivars.debugMode:Is"BLANK_LOADING_SCREEN" then--tex added bypass
    TppUI.StartLoadingTips()
  end
end
function this.DisableBlackLoading()
  TppGameStatus.Reset("TppMain.lua","S_IS_BLACK_LOADING")
  TppUI.FinishLoadingTips()
end
--NMC: via mission_main.lua, is called in order laid out, OnAllocate is before OnInitialize
function this.OnAllocate(missionTable)
  --InfCore.PCallDebug(function(missionTable)--tex can't use consistantly since it triggers yield across c boundary error
  InfCore.LogFlow("OnAllocate Top "..vars.missionCode)--tex
  InfMain.OnAllocateTop(missionTable)--tex
  TppWeather.OnEndMissionPrepareFunction()
  this.DisableGameStatus()
  this.EnablePause()
  TppClock.Stop()
  InfCore.LogFlow"moduleUpdateFuncs cleared"--tex
  moduleUpdateFuncs={}
  moduleUpdateFuncNames={}--tex
  numModuleUpdateFuncs=0
  --ORPHAN: debugUpdateFuncs={}
  --ORPHAN: numDebugUpdateFuncs=0
  TppUI.FadeOut(TppUI.FADE_SPEED.FADE_MOMENT,nil,nil)
  InfCore.LogFlow"TppSave.WaitingAllEnqueuedSaveOnStartMission"--tex only call so logging it here rather than hook/log the actual function
  TppSave.WaitingAllEnqueuedSaveOnStartMission()
  if TppMission.IsFOBMission(vars.missionCode)then
    TppMission.SetFOBMissionFlag()
    TppGameStatus.Set("Mission","S_IS_ONLINE")
  else
    TppGameStatus.Reset("Mission","S_IS_ONLINE")
  end
  InfCore.LogFlow"Mission.Start"--tex
  Mission.Start()
  TppMission.WaitFinishMissionEndPresentation()
  TppMission.DisableInGameFlag()

  --tex REWORKED to allow pcall TODO: should probably lua-hang on error rather than let it continue
  local libAllocateOrder={
    "TppException",
    "TppClock",
    "TppTrap",
    "TppCheckPoint",
    "TppUI",
    "TppDemo",
    "TppScriptBlock",
    "TppSound",
    "TppPlayer",
    "TppMission",
    "TppTerminal",
    "TppEnemy",
    "TppRadio",
    "TppGimmick",
    "TppMarker",
    "TppRevenge",
  }
  --tex in lua pcalls on a yield triggers an 'attempt to yield across metamethod/C-call boundary' error
  local yields={
    TppUI=true,
  }
  for i,libName in ipairs(libAllocateOrder)do
    InfCore.LogFlow(libName..".OnAllocate")
    if not _G[libName].OnAllocate then
      InfCore.Log("ERROR: TppMain.OnAllocate: could not find "..libName..".OnAllocate",false,true)
    else
      if yields[libName] then
        _G[libName].OnAllocate(missionTable)
      else
        InfCore.PCallDebug(_G[libName].OnAllocate,missionTable)
      end
    end
  end
  this.ClearStageBlockMessage()--tex VERIFY that TppQuest, TppAnimal .onallocate needs ClearStageBlockMessage (see ORIG)
  local libAllocateOrderPostBlockMessageClear={
    "TppQuest",
    "TppAnimal",
    "InfMain",--tex
  }
  for i,libName in ipairs(libAllocateOrderPostBlockMessageClear)do
    InfCore.LogFlow(libName..".OnAllocate")
    if not _G[libName].OnAllocate then
      InfCore.Log("ERROR: TppMain.OnAllocate: could not find "..libName..".OnAllocate",false,true)
    else
      if yields[libName] then
        _G[libName].OnAllocate(missionTable)
      else
        InfCore.PCallDebug(_G[libName].OnAllocate,missionTable)
      end
    end
  end

  --ORIG
  --  TppException.OnAllocate(missionTable)
  --  TppClock.OnAllocate(missionTable)
  --  TppTrap.OnAllocate(missionTable)
  --  TppCheckPoint.OnAllocate(missionTable)
  --  TppUI.OnAllocate(missionTable)
  --  TppDemo.OnAllocate(missionTable)
  --  TppScriptBlock.OnAllocate(missionTable)
  --  TppSound.OnAllocate(missionTable)
  --  TppPlayer.OnAllocate(missionTable)
  --  TppMission.OnAllocate(missionTable)
  --  TppTerminal.OnAllocate(missionTable)
  --  TppEnemy.OnAllocate(missionTable)
  --  TppRadio.OnAllocate(missionTable)
  --  TppGimmick.OnAllocate(missionTable)
  --  TppMarker.OnAllocate(missionTable)
  --  TppRevenge.OnAllocate(missionTable)
  --  this.ClearStageBlockMessage()
  --  TppQuest.OnAllocate(missionTable)
  --  TppAnimal.OnAllocate(missionTable)
  --  InfMain.OnAllocate(missionTable)--tex
  --tex reworked
  local locationName=TppLocation.GetLocationName()
  local locationModule=_G[locationName]
  if locationModule then
    locationModule.OnAllocate()
  end--<
  --ORIG
  --  local function LocationOnAllocate()
  --    if TppLocation.IsAfghan()then
  --      if afgh then
  --        afgh.OnAllocate()
  --      end
  --    elseif TppLocation.IsMiddleAfrica()then
  --      if mafr then
  --        mafr.OnAllocate()
  --      end
  --    elseif TppLocation.IsCyprus()then
  --      if cypr then
  --        cypr.OnAllocate()
  --      end
  --    elseif TppLocation.IsMotherBase()then
  --      if mtbs then
  --        mtbs.OnAllocate()
  --      end
  --    end
  --  end
  --  LocationOnAllocate()
  if missionTable.sequence then
    if f30050_sequence then--
      --RETAILPATCH: 1.0.4.1 PATCHUP: in general I understand the need for patch ups, and in cases like this i even admire the method, however the implementation of just shoving them seemingly anywhere... needs better execution.
      function f30050_sequence.NeedPlayQuietWishGoMission()
        local isClearedVisitQuietQuest=TppQuest.IsCleard"mtbs_q99011"
        local isNotPlayDemo=not TppDemo.IsPlayedMBEventDemo"QuietWishGoMission"
        local isCanArrival=TppDemo.GetMBDemoName()==nil
        return(isClearedVisitQuietQuest and isNotPlayDemo)and isCanArrival
      end
    end
    if IsTypeFunc(missionTable.sequence.MissionPrepare)then
      missionTable.sequence.MissionPrepare()
    end
    if IsTypeFunc(missionTable.sequence.OnEndMissionPrepareSequence)then
      TppSequence.SetOnEndMissionPrepareFunction(missionTable.sequence.OnEndMissionPrepareSequence)
    end
  end
  InfMain.MissionPrepare()--tex
  for name,module in pairs(missionTable)do
    if IsTypeFunc(module.OnLoad)then
      InfCore.LogFlow(name..".OnLoad")--tex
      InfCore.PCallDebug(module.OnLoad)--tex wrapped in pcall
    end
  end
  do
    local allSvars={}
    this.allSvars=allSvars--tex DEBUG see Ivars debug thingamy
    for i,lib in ipairs(Tpp._requireList)do
      if _G[lib]then
        local DeclareSVars=_G[lib].DeclareSVars
        if DeclareSVars then
          InfCore.LogFlow(lib..".DeclareSVars")--tex DEBUG
          ApendArray(allSvars,InfCore.PCallDebug(DeclareSVars,missionTable))--tex PCall
        end
      end
    end
    --tex>
    --tex not fob check pretty critical here since svars mismatch actoss clients cause corruption and hangs across clients
    if not InfMain.IsOnlineMission(vars.missionCode)then
      for i,module in ipairs(InfModules)do
        if module.DeclareSVars then
          InfCore.LogFlow(module.name..".DeclareSVars:")
          ApendArray(allSvars,InfCore.PCallDebug(module.DeclareSVars,missionTable))
        end
      end
    end
    --<
    local missionSvars={}
    for name,module in pairs(missionTable)do
      if IsTypeFunc(module.DeclareSVars)then
        ApendArray(missionSvars,module.DeclareSVars())
      end
      if IsTypeTable(module.saveVarsList)then
        ApendArray(missionSvars,TppSequence.MakeSVarsTable(module.saveVarsList))
      end
    end
    if OnlineChallengeTask then--RETAILPATCH 1090>
      ApendArray(missionSvars,OnlineChallengeTask.DeclareSVars())
    end--<
    ApendArray(allSvars,missionSvars)
    TppScriptVars.DeclareSVars(allSvars)
    TppScriptVars.SetSVarsNotificationEnabled(false)
    while IsSavingOrLoading()do
      coroutine.yield()
    end
    TppRadioCommand.SetScriptDeclVars()
    local layoutCode=vars.mbLayoutCode
    if gvars.ini_isTitleMode then
      TppPlayer.MissionStartPlayerTypeSetting()
    else
      if TppMission.IsMissionStart()then
        TppVarInit.InitializeForNewMission(missionTable)
        TppPlayer.MissionStartPlayerTypeSetting()
        if not TppMission.IsFOBMission(vars.missionCode)then
          TppSave.VarSave(vars.missionCode,true)
        end
      else
        TppVarInit.InitializeForContinue(missionTable)
      end
      TppVarInit.ClearIsContinueFromTitle()
    end
    TppUiCommand.ExcludeNonPermissionContents()--RETAILPATCH: 1.0.4.1 --tex trying to lock down dlc mods?
    TppStory.SetMissionClearedS10030()
    if(not TppMission.IsDefiniteMissionClear())then--RETAILPATCH: 1060 check added
      TppTerminal.StartSyncMbManagementOnMissionStart()
    end
    if TppLocation.IsMotherBase()then
      if layoutCode~=vars.mbLayoutCode then
        if vars.missionCode==30050 then
          vars.mbLayoutCode=layoutCode
        else
          vars.mbLayoutCode=TppLocation.ModifyMbsLayoutCode(TppMotherBaseManagement.GetMbsTopologyType())
        end
      end
    end
    TppPlayer.FailSafeInitialPositionForFreePlay()--RETAILPATCH: 1060
    this.StageBlockCurrentPosition(true)
    TppMission.SetSortieBuddy()
    if vars.missionCode~=10260 then--RETAILPATCH 1070 wrapped in check NMC why didnt you add this to the function itself konami?
      TppMission.ResetQuietEquipIfUndevelop()--RETAILPATCH: 1060
    end
    TppStory.UpdateStorySequence{updateTiming="BeforeBuddyBlockLoad"}
    if missionTable.sequence then
      local disableBuddyType=missionTable.sequence.DISABLE_BUDDY_TYPE
      if TppMission.IsMbFreeMissions(vars.missionCode) and Ivars.mbEnableBuddies:Is(1) then--tex no DISABLE_BUDDY_TYPE
        disableBuddyType=nil
      end--
      if disableBuddyType ~= nil then
        local disableBuddyTypes
        if IsTypeTable(disableBuddyType)then
          disableBuddyTypes=disableBuddyType
        else
          disableBuddyTypes={disableBuddyType}
        end
        for n,buddyType in ipairs(disableBuddyTypes)do
          TppBuddyService.SetDisableBuddyType(buddyType)
        end
      end
    end

    --if(vars.missionCode==11043)or(vars.missionCode==11044)then--tex ORIG: changed to issubs check, more robust even without my mod
    if TppMission.IsSubsistenceMission() or IvarProc.GetForMission"heliSpace_NoBuddyMenuFromMissionPreparetion"==2 then--tex added NoBuddyMenu check DEBUGNOW rethink
      TppBuddyService.SetDisableAllBuddy()
    end
    if TppGameSequence.GetGameTitleName()=="TPP"then
      if missionTable.sequence and missionTable.sequence.OnBuddyBlockLoad then
        missionTable.sequence.OnBuddyBlockLoad()
      end
      local locationInfo=InfMission.GetLocationInfo(vars.locationCode)--tex added locationInfo check -v-
      if TppLocation.IsAfghan()or TppLocation.IsMiddleAfrica() or (locationInfo and locationInfo.requestTppBuddy2BlockController)then
        InfCore.LogFlow"TppBuddy2BlockController.Load"--tex DEBUG
        TppBuddy2BlockController.Load()
      end
    end
    TppSequence.SaveMissionStartSequence()
    TppScriptVars.SetSVarsNotificationEnabled(true)
  end
  if missionTable.enemy then
    if IsTypeTable(missionTable.enemy.soldierPowerSettings)then
      TppEnemy.SetUpPowerSettings(missionTable.enemy.soldierPowerSettings)
    end
  end
  TppRevenge.DecideRevenge(missionTable)
  if TppEquip.CreateEquipMissionBlockGroup then
    if(vars.missionCode>6e4)then--NMC the e3/tradeshow demos I think
      TppEquip.CreateEquipMissionBlockGroup{size=(380*1024)*24}--=9338880 -- nearly 5x the max retail block size
    else
      TppPlayer.SetEquipMissionBlockGroupSize()--TppDefine.DEFAULT_EQUIP_MISSION_BLOCK_GROUP_SIZE = 1677721, sequence.EQUIP_MISSION_BLOCK_GROUP_SIZE= max 1887437 (s10054)
    end
  end
  if TppEquip.CreateEquipGhostBlockGroups then
    if TppSystemUtility.GetCurrentGameMode()=="MGO"then
      TppEquip.CreateEquipGhostBlockGroups{ghostCount=16}
    elseif TppMission.IsFOBMission(vars.missionCode) then
      TppEquip.CreateEquipGhostBlockGroups{ghostCount=1}
    end
  end
  TppEquip.StartLoadingToEquipMissionBlock()
  TppPlayer.SetMaxPickableLocatorCount()
  TppPlayer.SetMaxPlacedLocatorCount()
  TppEquip.AllocInstances{instance=60,realize=60}
  TppEquip.ActivateEquipSystem()
  if TppEnemy.IsRequiredToLoadDefaultSoldier2CommonPackage()then
    TppEnemy.LoadSoldier2CommonBlock()
  end
  if missionTable.sequence then
    mvars.mis_baseList=missionTable.sequence.baseList
    TppCheckPoint.RegisterCheckPointList(missionTable.sequence.checkPointList)
  end
  --RETAILPATCH 1.0.11>
  if not TppMission.IsFOBMission(vars.missionCode)then
    TppPlayer.ForceChangePlayerFromOcelot()
  end
  --<
  --end,missionTable)--DEBUG
  InfCore.LogFlow("OnAllocate Bottom "..vars.missionCode)--tex
end
--NOTE: GameObjects loaded after OnAllocate and are gettable by OnInitialize
function this.OnInitialize(missionTable)--NMC: see onallocate for notes
  --InfCore.PCallDebug(function(missionTable)--tex off till I can verify doesn't run into same issue as OnAllocate
  InfCore.LogFlow("OnInitialize Top "..vars.missionCode)--tex
  InfMain.OnInitializeTop(missionTable)--tex
  if TppMission.IsFOBMission(vars.missionCode)then
    TppMission.SetFobPlayerStartPoint()
  elseif TppMission.IsNeedSetMissionStartPositionToClusterPosition()then
    TppMission.SetMissionStartPositionMtbsClusterPosition()
    this.StageBlockCurrentPosition(true)
  else
    TppCheckPoint.SetCheckPointPosition()
  end
  if TppEnemy.IsRequiredToLoadSpecialSolider2CommonBlock()then
    TppEnemy.LoadSoldier2CommonBlock()
  end
  if TppMission.IsMissionStart()then
    TppTrap.InitializeVariableTraps()
  else
    TppTrap.RestoreVariableTrapState()
  end
  TppAnimalBlock.InitializeBlockStatus()
  if TppQuestList then
    TppQuest.RegisterQuestList(TppQuestList.questList)
    TppQuest.RegisterQuestPackList(TppQuestList.questPackList)
  end
  TppHelicopter.AdjustBuddyDropPoint()
  if missionTable.sequence then
    local settings=missionTable.sequence.NPC_ENTRY_POINT_SETTING
    if IsTypeTable(settings)then
      TppEnemy.NPCEntryPointSetting(settings)
    end
  end
  TppLandingZone.OverwriteBuddyVehiclePosForALZ()
  --InfMainTpp.OverwriteBuddyPosForMb()--tex no go CULL
  if missionTable.enemy then
    if IsTypeTable(missionTable.enemy.vehicleSettings)then
      TppEnemy.SetUpVehicles()
    end
    if IsTypeFunc(missionTable.enemy.SpawnVehicleOnInitialize)then
      missionTable.enemy.SpawnVehicleOnInitialize()
    end
    TppReinforceBlock.SetUpReinforceBlock()
  end
  for name,module in pairs(missionTable)do
    if IsTypeFunc(module.Messages)then
      missionTable[name]._messageExecTable=Tpp.MakeMessageExecTable(module.Messages())
    end
  end
  if mvars.loc_locationCommonTable then
    mvars.loc_locationCommonTable.OnInitialize()
  end
  TppLandingZone.OnInitialize()
  for i,lib in ipairs(Tpp._requireList)do
    local Init=_G[lib].Init
    if Init then
      InfCore.LogFlow(lib..".Init")--tex DEBUG
      InfCore.PCallDebug(Init,missionTable)--tex wrapped in pcall
    end
  end
  if OnlineChallengeTask then--RETAILPATCH 1090>
    OnlineChallengeTask.Init()
  end--<
  if missionTable.enemy then
    if GameObject.DoesGameObjectExistWithTypeName"TppSoldier2"then
      GameObject.SendCommand({type="TppSoldier2"},{id="CreateFaceIdList"})
    end
    if IsTypeTable(missionTable.enemy.soldierDefine)then
      TppEnemy.DefineSoldiers(missionTable.enemy.soldierDefine)
    end
    if missionTable.enemy.InitEnemy and IsTypeFunc(missionTable.enemy.InitEnemy)then
      missionTable.enemy.InitEnemy()
    end
    if IsTypeTable(missionTable.enemy.soldierPersonalAbilitySettings)then
      TppEnemy.SetUpPersonalAbilitySettings(missionTable.enemy.soldierPersonalAbilitySettings)
    end
    if IsTypeTable(missionTable.enemy.travelPlans)then
      TppEnemy.SetTravelPlans(missionTable.enemy.travelPlans)
    end
    TppEnemy.SetUpSoldiers()
    if IsTypeTable(missionTable.enemy.soldierDefine)then
      TppEnemy.InitCpGroups()
      TppEnemy.RegistCpGroups(missionTable.enemy.cpGroups)
      TppEnemy.SetCpGroups()
      if mvars.loc_locationGimmickCpConnectTable then
        TppGimmick.SetCommunicateGimmick(mvars.loc_locationGimmickCpConnectTable)
      end
    end
    if IsTypeTable(missionTable.enemy.interrogation)then
      TppInterrogation.InitInterrogation(missionTable.enemy.interrogation)
    end
    if IsTypeTable(missionTable.enemy.useGeneInter)then
      TppInterrogation.AddGeneInter(missionTable.enemy.useGeneInter)
    end
    if IsTypeTable(missionTable.enemy.uniqueInterrogation)then
      TppInterrogation.InitUniqueInterrogation(missionTable.enemy.uniqueInterrogation)
    end
    do
      local routeSets
      if IsTypeTable(missionTable.enemy.routeSets)then
        routeSets=missionTable.enemy.routeSets
        for cpName,n in pairs(routeSets)do
          if not IsTypeTable(mvars.ene_soldierDefine[cpName])then
          end
        end
      end
      if routeSets then
        TppEnemy.RegisterRouteSet(routeSets)
        TppEnemy.MakeShiftChangeTable()
        TppEnemy.SetUpCommandPost()
        TppEnemy.SetUpSwitchRouteFunc()
      end
    end
    if missionTable.enemy.soldierSubTypes then
      if missionTable.enemy.soldierDefine and type(missionTable.enemy.soldierSubTypes)=="boolean" and missionTable.enemy.cpSubTypes~=nil then--tex> use missionTable.enemy.cpSubTypes
        local soldierSubTypes={}
        for cpName,cpSoldiers in pairs(missionTable.enemy.soldierDefine)do
          local soldierSubType=type(missionTable.enemy.cpSubTypes)~="table" and missionTable.enemy.cpSubTypes or missionTable.enemy.cpSubTypes[cpName]
          if soldierSubType==nil then
          else
            soldierSubTypes[soldierSubType]=soldierSubTypes[soldierSubType] or {}
            table.insert(soldierSubTypes[soldierSubType],cpSoldiers)
          end 
        end--for soldierDefine
        TppEnemy.SetUpSoldierSubTypes(soldierSubTypes)
      else--<
      TppEnemy.SetUpSoldierSubTypes(missionTable.enemy.soldierSubTypes)
      end
    end
    TppRevenge.SetUpEnemy()
    TppEnemy.ApplyPowerSettingsOnInitialize()
    TppEnemy.ApplyPersonalAbilitySettingsOnInitialize()
    TppEnemy.SetOccasionalChatList()
    TppEneFova.ApplyUniqueSetting()
    if missionTable.enemy.SetUpEnemy and IsTypeFunc(missionTable.enemy.SetUpEnemy)then
      InfCore.LogFlow("missionTable.enemy.SetUpEnemy")--tex
      InfCore.PCallDebug(missionTable.enemy.SetUpEnemy)--tex wrapped in pcall
    end
    InfMain.SetUpEnemy(missionTable)--tex
    if TppMission.IsMissionStart()then
      TppEnemy.RestoreOnMissionStart2()
    else
      TppEnemy.RestoreOnContinueFromCheckPoint2()
    end
    --< if missionTable.enemy
  end
  if not TppMission.IsMissionStart()then
    TppWeather.RestoreFromSVars()
    TppMarker.RestoreMarkerLocator()
  end
  TppPlayer.RestoreSupplyCbox()
  TppPlayer.RestoreSupportAttack()
  TppTerminal.MakeMessage()
  if missionTable.sequence then
    local SetUpRoutes=missionTable.sequence.SetUpRoutes
    if SetUpRoutes and IsTypeFunc(SetUpRoutes)then
      SetUpRoutes()
    end
    TppEnemy.RegisterRouteAnimation()
    local SetUpLocation=missionTable.sequence.SetUpLocation
    if SetUpLocation and IsTypeFunc(SetUpLocation)then
      SetUpLocation()
    end
  end
  for name,module in pairs(missionTable)do
    if module.OnRestoreSVars then
      if vars.missionCode==10010 or vars.missionCode==10280 then--tex> WORKAROUND, s10010_sequence.OnRestoreSvars has a coroutine.yield()
        module.OnRestoreSVars()
      else--<
        InfCore.LogFlow(name..".OnRestoreSVars")
        InfCore.PCallDebug(module.OnRestoreSVars)--tex wrapped in pcall
      end
    end
  end
  InfMain.OnRestoreSvars()--tex
  TppMission.RestoreShowMissionObjective()
  TppRevenge.SetUpRevengeMine()
  if TppPickable.StartToCreateFromLocators then
    TppPickable.StartToCreateFromLocators()
  end
  if TppPlaced and TppPlaced.StartToCreateFromLocators then
    TppPlaced.StartToCreateFromLocators()
  end
  if TppMission.IsMissionStart()then
    TppRadioCommand.RestoreRadioState()
  else
    TppRadioCommand.RestoreRadioStateContinueFromCheckpoint()
  end
  TppMission.SetPlayRecordClearInfo()--RETAILPATCH 1070
  TppChallengeTask.RequestUpdateAllChecker()--RETAILPATCH 1070
  TppMission.PostMissionOrderBoxPositionToBuddyDog()
  this.SetUpdateFunction(missionTable)
  this.SetMessageFunction(missionTable)
  TppQuest.UpdateActiveQuest()
  TppDevelopFile.OnMissionCanStart()
  --tex ORIG if TppMission.GetMissionID()==30010 or TppMission.GetMissionID()==30020 then
  if TppMission.IsFreeMission(vars.missionCode) and not TppMission.IsMbFreeMissions(vars.missionCode) then--tex enable for addon free roam missions TODO rethink, enable for wargames?
    if TppQuest.IsActiveQuestHeli()then
      TppEnemy.ReserveQuestHeli()
    end
  end
  TppDemo.UpdateNuclearAbolitionFlag()
  TppQuest.AcquireKeyItemOnMissionStart()
  InfMain.OnInitializeBottom(missionTable)--tex
  InfCore.LogFlow("OnInitialize Bottom "..vars.missionCode)--tex
  --end,missionTable)--tex DEBUG
end
--CALLER: OnInitialize (near bottom), OnReload
--moduleUpdateFuncs also cleared at top of OnAllocate, but missionScriptOnUpdateFuncs not cleared then? 
function this.SetUpdateFunction(missionTable)
  InfCore.LogFlow"TppMain.SetUpdateFunction"--tex
  --moduleUpdateFuncs={}
  numModuleUpdateFuncs=0
  missionScriptOnUpdateFuncs={}
  missionScriptOnUpdateFuncNames={}--tex
  numOnUpdate=0
  --ORPHAN: debugUpdateFuncs={}
  --ORPHAN: numDebugUpdateFuncs=0
  InfCore.LogFlow"moduleUpdateFuncs set"--tex
  moduleUpdateFuncs={
    InfMain.UpdateTop,--tex
    TppMission.Update,
    TppSequence.Update,
    TppSave.Update,
    TppDemo.Update,
    TppPlayer.Update,
    TppMission.UpdateForMissionLoad,
    InfMain.UpdateBottom,--tex
  }
  moduleUpdateFuncNames={--tex>
    "InfMain.UpdateTop",--tex
    "TppMission.Update",
    "TppSequence.Update",
    "TppSave.Update",
    "TppDemo.Update",
    "TppPlayer.Update",
    "TppMission.UpdateForMissionLoad",
    "InfMain.UpdateBottom",--tex"
  }--<

  numModuleUpdateFuncs=#moduleUpdateFuncs

  for name,module in pairs(missionTable)do
    if IsTypeFunc(module.OnUpdate)then
      numOnUpdate=numOnUpdate+1
      missionScriptOnUpdateFuncs[numOnUpdate]=module.OnUpdate
      missionScriptOnUpdateFuncNames[numOnUpdate]=name..".OnUpdate"--tex
    end
  end
end
function this.OnEnterMissionPrepare()
  InfCore.LogFlow"TppMain.OnEnterMissionPrepare"--tex
  if TppMission.IsMissionStart()then
    TppScriptBlock.PreloadSettingOnMissionStart()
  end
  TppScriptBlock.ReloadScriptBlock()
end
function this.OnTextureLoadingWaitStart()
  InfCore.LogFlow"TppMain.OnTextureLoadingWaitStart"--tex
  if not TppMission.IsHelicopterSpace(vars.missionCode)then
    StageBlockCurrentPositionSetter.SetEnable(false)
  end
  gvars.canExceptionHandling=true
end
function this.OnMissionStartSaving()
  InfCore.LogFlow"TppMain.OnMissionStartSaving"--tex
end
--CALLER: TppSequence Seq_Mission_Prepare.OnUpdate END_SAVING_FILE
function this.OnMissionCanStart()
  InfCore.LogFlow"TppMain.OnMissionCanStart"--tex
  if TppMission.IsMissionStart()then
    TppWeather.SetDefaultWeatherProbabilities()
    TppWeather.SetDefaultWeatherDurations()
    if(not gvars.ini_isTitleMode)and(not TppMission.IsFOBMission(vars.missionCode))then
      TppSave.VarSave(nil,true)
    end
  end
  TppLocation.ActivateBlock()
  TppWeather.OnMissionCanStart()
  TppMarker.OnMissionCanStart()
  TppResult.OnMissionCanStart()
  TppQuest.InitializeQuestLoad()
  TppRatBird.OnMissionCanStart()
  TppMission.OnMissionStart()
  if mvars.loc_locationCommonTable then
    mvars.loc_locationCommonTable.OnMissionCanStart()
  end
  TppLandingZone.OnMissionCanStart()
  TppOutOfMissionRangeEffect.Disable(0)
  if TppLocation.IsMiddleAfrica()then
    TppGimmick.MafrRiverPrimSetting()
  end
  if MotherBaseConstructConnector.RefreshGimmicks then
    if vars.locationCode==TppDefine.LOCATION_ID.MTBS then
      MotherBaseConstructConnector.RefreshGimmicks()
    end
  end
  if vars.missionCode==10240 and TppLocation.IsMBQF()then--PATCHUP:
    Player.AttachGasMask()
  end
  if(vars.missionCode==10150)then--PATCHUP:
    local missionStartSequenceIndex=TppSequence.GetMissionStartSequenceIndex()
    if(missionStartSequenceIndex~=nil)and(missionStartSequenceIndex<TppSequence.GetSequenceIndex"Seq_Game_SkullFaceToPlant")then
      if(svars.mis_objectiveEnable[17]==false)then
        Gimmick.ForceResetOfRadioCassetteWithCassette()
      end
    end
  end
  InfMain.OnMissionCanStartBottom()--tex
end
--CALLER: TppSequence. Seq_Mission_Prepare OnLeave
function this.OnMissionGameStart(sequenceName)
  InfCore.LogFlow"TppMain.OnMissionGameStart"--tex
  TppClock.Start()
  if not gvars.ini_isTitleMode then
    PlayRecord.RegistPlayRecord"MISSION_START"
  end
  TppQuest.InitializeQuestActiveStatus()
  if mvars.seq_demoSequneceList[mvars.seq_missionStartSequence]then
    this.EnableGameStatusForDemo()
  else
    this.EnableGameStatus()
  end
  if Player.RequestChickenHeadSound~=nil then
    Player.RequestChickenHeadSound()
  end
  TppTerminal.OnMissionGameStart()
  if TppSequence.IsLandContinue()then
    TppMission.EnableAlertOutOfMissionAreaIfAlertAreaStart()
  end
  TppSoundDaemon.ResetMute"Telop"
end
function this.ClearStageBlockMessage()
  StageBlock.ClearLargeBlockNameForMessage()
  StageBlock.ClearSmallBlockIndexForMessage()
end
--tex broken out from ReservePlayerLoadingPosition
local function HasHeliRoute()
  return gvars.heli_missionStartRoute~=0
end
--NMC from MISSION_FINALIZE
local function LoadingPositionToHeliSpace()
  InfCore.LogFlow"LoadingPositionToHeliSpace"--tex
  TppHelicopter.ResetMissionStartHelicopterRoute()
  TppPlayer.ResetInitialPosition()
  TppPlayer.ResetMissionStartPosition()
  TppPlayer.ResetNoOrderBoxMissionStartPosition()
  TppMission.ResetIsStartFromHelispace()
  TppMission.ResetIsStartFromFreePlay()
end
--NMC from MISSION_FINALIZE
local function LoadingPositionFromHeliSpace(nextIsFreeMission,fromFreeMission)
  InfCore.LogFlow"LoadingPositionFromHeliSpace"--tex
  if HasHeliRoute() then
    --TppPlayer.SetStartStatusRideOnHelicopter()--tex <broken out for clarity-v-
    TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.RIDEON_HELICOPTER)
    TppPlayer.ResetInitialPosition()
    TppPlayer.ResetMissionStartPosition()--^
    if mvars.mis_helicopterMissionStartPosition then
      TppPlayer.SetInitialPosition(mvars.mis_helicopterMissionStartPosition,0)
      TppPlayer.SetMissionStartPosition(mvars.mis_helicopterMissionStartPosition,0)
    end
    this.SetStartOnFootPosition(fromFreeMission,nextIsFreeMission)--tex calls SetInitialPosition,SetMissionStartPosition, to basically just override the above with the IH start on ground pos
  else--no heli start
    TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
    local noHeliMissionStartPos=TppDefine.NO_HELICOPTER_MISSION_START_POSITION[vars.missionCode]
    if noHeliMissionStartPos then
      TppPlayer.SetInitialPosition(noHeliMissionStartPos,0)
      TppPlayer.SetMissionStartPosition(noHeliMissionStartPos,0)
    else
      TppPlayer.ResetInitialPosition()
      TppPlayer.ResetMissionStartPosition()
    end
  end
  TppPlayer.ResetNoOrderBoxMissionStartPosition()
  TppMission.SetIsStartFromHelispace()
  TppMission.ResetIsStartFromFreePlay()
end--LoadingPositionFromHeliSpace
--NMC from MISSION_FINALIZE, not to/from helispace, to a free mission
--which in vanilla means from a mission to free roam - afgh,mafr, mb and outer plats
--which is either ending mission by out of hot-zone, or mission specifically putting you back in free
--with IH transitions means it can also be free roam to an addon free roam map, or visa versa
local function LoadingPositionToFree(nextIsFreeMission,fromFreeMission)
  InfCore.LogFlow"LoadingPositionToFree"--tex
  if TppLocation.IsMotherBase()then--NMC to MB
    --TppPlayer.SetStartStatusRideOnHelicopter()--tex <broken out for clarity-v-
    TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.RIDEON_HELICOPTER)
    TppPlayer.ResetInitialPosition()
    TppPlayer.ResetMissionStartPosition()--^
  else
    TppPlayer.ResetInitialPosition()
    TppHelicopter.ResetMissionStartHelicopterRoute()
    TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
    TppPlayer.SetMissionStartPositionToCurrentPosition()
  end
  TppPlayer.ResetNoOrderBoxMissionStartPosition()
  TppMission.ResetIsStartFromHelispace()
  TppMission.ResetIsStartFromFreePlay()
  --TppLocation.MbFreeSpecialMissionStartSetting(TppMission.GetMissionClearType())-v-NMC: broken out for clarity>
  if TppMission.GetMissionClearType()==TppDefine.MISSION_CLEAR_TYPE.HELI_TAX_MB_FREE_CLEAR then
    if mvars.mis_helicopterMissionStartPosition then
      TppPlayer.SetInitialPosition(mvars.mis_helicopterMissionStartPosition,0)
      TppPlayer.SetMissionStartPosition(mvars.mis_helicopterMissionStartPosition,0)
    end
    TppMission.SetIsStartFromHelispace()
    TppMission.ResetIsStartFromFreePlay()
  end--^
  if HasHeliRoute() then--tex startOnFoot mb zoo/qntn transfer, heliLandPoint>
    InfCore.LogFlow("LoadingPositionToFree HasHeliRoute")--DEBUGNOW
    this.SetStartOnFootPosition(fromFreeMission,nextIsFreeMission)--tex calls SetInitialPosition,SetMissionStartPosition, to basically just override the above with the IH start on ground pos
  elseif fromFreeMission then--tex shouldn't happen in vanilla, but we supporting it for more map transitions
    InfCore.LogFlow("LoadingPositionToFree !HasHeliRoute")--DEBUGNOW
    if mvars.mis_transitionMissionStartPosition then
    	TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
      TppPlayer.SetInitialPosition(mvars.mis_transitionMissionStartPosition,0)
      TppPlayer.SetMissionStartPosition(mvars.mis_transitionMissionStartPosition,0)
    else
      TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
      local noHeliMissionStartPos=TppDefine.NO_HELICOPTER_MISSION_START_POSITION[vars.missionCode]
      if noHeliMissionStartPos then
        TppPlayer.SetInitialPosition(noHeliMissionStartPos,0)
        TppPlayer.SetMissionStartPosition(noHeliMissionStartPos,0)
      end
    end
  end--<
end--LoadingPositionToFree
--NMC from MISSION_FINALIZE
local function LoadingPositionFromFreeToMB()
  InfCore.LogFlow"LoadingPositionFromFreeToMB"--tex
  if HasHeliRoute() then
    --TppPlayer.SetStartStatusRideOnHelicopter()--tex <broken out for clarity-v-
    TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.RIDEON_HELICOPTER)
    TppPlayer.ResetInitialPosition()
    TppPlayer.ResetMissionStartPosition()--^
  else
    TppPlayer.ResetInitialPosition()
    TppPlayer.ResetMissionStartPosition()
  end
  TppPlayer.ResetNoOrderBoxMissionStartPosition()
  TppMission.SetIsStartFromHelispace()
  TppMission.ResetIsStartFromFreePlay()
end--LoadingPositionFromFreeToMB
--NMC from MISSION_FINALIZE
local function LoadingPositionFromFree(nextIsFreeMission,fromFreeMission)
  InfCore.LogFlow"LoadingPositionFromFree"--tex
  if mvars.mis_transitionMissionStartPosition then--tex>
    TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
    TppPlayer.SetInitialPosition(mvars.mis_transitionMissionStartPosition,0)
    TppPlayer.SetMissionStartPosition(mvars.mis_transitionMissionStartPosition,0)
    TppPlayer.ResetNoOrderBoxMissionStartPosition()
    --DEBUGNOW
    TppMission.ResetIsStartFromHelispace()
    TppMission.SetIsStartFromFreePlay()
    return
    --<
  elseif mvars.mis_orderBoxName then
    TppMission.SetMissionOrderBoxPosition()
    TppPlayer.ResetNoOrderBoxMissionStartPosition()
  else
    TppPlayer.ResetInitialPosition()
    TppPlayer.ResetMissionStartPosition()
    local posrot=TppDefine.NO_BOX_MISSION_START_POSITION[vars.missionCode]--tex was local table, shifted to TppDefine
    if TppDefine.NO_ORDER_BOX_MISSION_ENUM[tostring(vars.missionCode)]and posrot then
      TppPlayer.SetNoOrderBoxMissionStartPosition(posrot,posrot[4])
    else
      TppPlayer.ResetNoOrderBoxMissionStartPosition()
    end
  end
  local noOrderFixHeliRoute=TppDefine.NO_ORDER_FIX_HELICOPTER_ROUTE[vars.missionCode]
  if noOrderFixHeliRoute then
    --TppPlayer.SetStartStatusRideOnHelicopter()--tex <broken out for clarity-v-
    TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.RIDEON_HELICOPTER)
    TppPlayer.ResetInitialPosition()
    TppPlayer.ResetMissionStartPosition()--^
    TppMission.SetIsStartFromHelispace()
    TppMission.ResetIsStartFromFreePlay()
  else
    TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
    TppHelicopter.ResetMissionStartHelicopterRoute()
    TppMission.ResetIsStartFromHelispace()
    TppMission.SetIsStartFromFreePlay()
  end
  local missionClearType=TppMission.GetMissionClearType()
  TppQuest.SpecialMissionStartSetting(missionClearType)
end--LoadingPositionFromFree
--NMC: GOTCHA: at this point mission/location vars have been changed to next mission (so next is really current)
local loadPositionFuncs={}
--
loadPositionFuncs[TppDefine.MISSION_LOAD_TYPE.MISSION_FINALIZE]=function(missionLoadType,fromHeliSpace,fromFreeMission,nextIsHeliSpace,nextIsFreeMission,abortWithSave,isLocationChange)
  InfCore.LogFlow("loadPositionFuncs MISSION_FINALIZE")--tex
  if nextIsHeliSpace then
    LoadingPositionToHeliSpace()
  elseif fromHeliSpace then
    LoadingPositionFromHeliSpace(nextIsFreeMission,fromFreeMission)
  elseif nextIsFreeMission then
    LoadingPositionToFree(nextIsFreeMission,fromFreeMission)
  elseif(fromFreeMission and TppLocation.IsMotherBase())then
    LoadingPositionFromFreeToMB()
  elseif fromFreeMission then
    LoadingPositionFromFree(nextIsFreeMission,fromFreeMission)
  else
    InfCore.LogFlow"LoadingPositionNone"--tex TODO: when is this actually hit?
    --NMC not free mission
    TppPlayer.ResetInitialPosition()
    TppPlayer.ResetMissionStartPosition()
    TppPlayer.ResetNoOrderBoxMissionStartPosition()
    TppMission.ResetIsStartFromHelispace()
    TppMission.ResetIsStartFromFreePlay()
  end
end--loadPositionFuncs MISSION_FINALIZE<
--
loadPositionFuncs[TppDefine.MISSION_LOAD_TYPE.MISSION_ABORT]=function(missionLoadType,fromHeliSpace,fromFreeMission,nextIsHeliSpace,nextIsFreeMission,abortWithSave,isLocationChange)
  InfCore.LogFlow("loadPositionFuncs MISSION_ABORT")--tex
  TppPlayer.ResetInitialPosition()
  --tex TODO:[a] ResetMissionStartPosition? only if safe for below
  TppHelicopter.ResetMissionStartHelicopterRoute()
  TppMission.ResetIsStartFromHelispace()
  TppMission.ResetIsStartFromFreePlay()
  if abortWithSave then
    if nextIsFreeMission then
      TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
      TppHelicopter.ResetMissionStartHelicopterRoute()
      TppPlayer.SetMissionStartPositionToCurrentPosition()
      TppPlayer.ResetNoOrderBoxMissionStartPosition()
    elseif nextIsHeliSpace then
      TppPlayer.ResetMissionStartPosition()
    elseif vars.missionCode~=5 then
      InfCore.Log("DOCUMENT ReservePlayerLoadingPosition MISSION_LOAD_TYPE.MISSION_ABORT fall through case 1. missionCode:"..tostring(vars.missionCode))--DEBUGNOW
      --DOCUMENT: what mission would this actually be?
      --TODO:[a] MissionStartPosition?
    end
  else
    --not abortWithSave
    if nextIsHeliSpace then
      TppHelicopter.ResetMissionStartHelicopterRoute()
      TppPlayer.ResetInitialPosition()
      TppPlayer.ResetMissionStartPosition()
    elseif nextIsFreeMission then
      TppMission.SetMissionOrderBoxPosition()
    elseif vars.missionCode~=5 then
      InfCore.Log("DOCUMENT ReservePlayerLoadingPosition MISSION_LOAD_TYPE.MISSION_ABORT fall through case 2. missionCode:"..tostring(vars.missionCode))--DEBUGNOW
      --DOCUMENT: what mission would this actually be?
      --TODO:[a] MissionStartPosition?
    end
  end--abortWithSave
end--loadPositionFuncs MISSION_ABORT<
--
loadPositionFuncs[TppDefine.MISSION_LOAD_TYPE.MISSION_RESTART]=function(missionLoadType,isHeliSpace,isFreeMission,nextIsHeliSpace,nextIsFreeMission,abortWithSave,isLocationChange)
  InfCore.LogFlow("loadPositionFuncs MISSION_RESTART")--tex
end
loadPositionFuncs[TppDefine.MISSION_LOAD_TYPE.CONTINUE_FROM_CHECK_POINT]=function(missionLoadType,isHeliSpace,isFreeMission,nextIsHeliSpace,nextIsFreeMission,abortWithSave,isLocationChange)
  InfCore.LogFlow("loadPositionFuncs CONTINUE_FROM_CHECK_POINT")--tex
end
--tex IH start on foot >
function this.SetStartOnFootPosition(fromFreeMission,nextIsFreeMission)
  InfCore.LogFlow"TppMain.SetStartOnFootPosition"
  local groundStartPosition=InfLZ.GetGroundStartPosition(gvars.heli_missionStartRoute)
  local isAssaultLz=TppLandingZone.IsAssaultDropLandingZone(gvars.heli_missionStartRoute)
  local startOnFoot=InfMain.IsStartOnFoot(vars.missionCode,isAssaultLz)
  local isMbFree=TppMission.IsMbFreeMissions(vars.missionCode) and (nextIsFreeMission or fromFreeMission)
  local isMbDemo=gvars.mbFreeDemoPlayNextIndex~=0 and vars.missionCode==30050-- see ForceGoToMbFreeIfExistMbDemo for how it decides to force demo 
  --GOTCHA: mbFreeDemoPlayNextIndex will still be set if you IH ESC abort to ACC
  --tex tent_q99040 repop f30250 hang on load when play with ih startonfoot (this is a different bug than 'tent_q99040 repop f30250 demo play fix'), as go to mb on sideop clear usually plays a demo this is the same issue noted in isMbDemo WORKAROUND
  local isMBOnSideopsClear=(vars.missionCode==30050 or vars.missionCode==30250) and svars.mis_missionClearType==TppDefine.MISSION_CLEAR_TYPE.FORCE_GO_TO_MB_ON_SIDE_OPS_CLEAR
  if not startOnFoot then
    InfCore.Log("startOnFoot not set")--tex just info rather than a warning, a normal start position should have already been set before calling SetStartOnFootPosition
  elseif not groundStartPosition then
    InfCore.Log("no groundStartPosition found for heli_missionStartRoute:"..InfLookup.StrCode32ToString(gvars.heli_missionStartRoute))--tex as above
  elseif isMbDemo or isMBOnSideopsClear then
    --tex WORKAROUND: some mission ends hang with the ih start on foot, seems to be mostly forced mbdemos that are relying on needing player in heli triggering its specfic traps
    --TODO: there might potentially be other cases, 
    --most normal mission starts are fine since they can be started on foot normally via free roam (TODO check the following start on foot setup is the same as normal)
    --but there might be other unique mission to mission starts that also rely on heli traps
    InfCore.Log("isMbDemo or isMBOnSideopsClear, skipping startOnFoot")
  else
    local pos=groundStartPosition.pos
    InfCore.PrintInspect(groundStartPosition,"groundStartPosition")--DEBUG
    if pos==nil then
      InfCore.Log("ERROR: TppMain SetStartOnFootPosition pos==nil for "..InfLookup.StrCode32ToString(gvars.heli_missionStartRoute))--
      return
    elseif type(pos)~="table"then
      InfCore.Log("ERROR: TppMain SetStartOnFootPosition pos type not table for "..InfLookup.StrCode32ToString(gvars.heli_missionStartRoute))--
      return
    end
    
    --tex BUG SIDESTEP: I used to stuff rotY into pos[4], which since groundStartPosition.pos is table from InfLZ groundStartPositions would bump it from {x,y,z}, to {x,y,z,yaw}, 
    --which would be fine if I hadn't had some data format guards specifically checking for exactly 3 components (in GetClosestLZ). 
    --so apart from fixing that, now using seperate rotY
    
    --tex TODO: fill out actuall decent rotYs for groundPositions, 
    --or to closest cp center (are entities loaded at this point in execution? Otherwise there is GetClosestCp which covers vanilla)
    --precompute if possible (where InfLZ groundStartPositions is set up), but then GetClosesCp should get actual cp positons at runtime when cp entities are up?
    
    --is currently defaulting to yawing towards center/0,0,0 of map
    --oddly I think this is often less confusing than starting player with yaw 0 everywhere
    --or to nearest cp pos which might not actually be a good line of sight
    --and sometimes even less confusing that pointing toward a hand picked view
    --mainly because I think player eventually builds up a mental model of the map bounds and kind of groks where the center is no matter where they are
    --at least thats kind of how it works for me, and this kind of worked out this way for similar things in my old quakewars mods which was also a big playspace
    local lookPos={0,0,0}
    local rotY=groundStartPosition.rotY or InfUtil.YawTowardsLookPos(pos,lookPos)
   
    TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
    --TppHelicopter.ResetMissionStartHelicopterRoute()
    if not isMbFree then
      --tex WORKAROUND mission timers fix see TppMission.IsStartFromHelispace note
      igvars.mis_isGroundStart=true
    end
    mvars.mis_helicopterMissionStartPosition=pos
    TppPlayer.SetInitialPosition(pos,rotY)
    TppPlayer.SetMissionStartPosition(pos,rotY)
    InfCore.PrintInspect(pos,"SetStartOnFootPosition")
  end--<
end--SetStartOnFootPosition--<
--NMC: tex most commonly only called with just missionLoadType, so the params are really just specific to the call with the missionLoadType that actually passes them in.
function this.ReservePlayerLoadingPosition(missionLoadType,fromHeliSpace,fromFreeMission,nextIsHeliSpace,nextIsFreeMission,abortWithSave,isLocationChange)
  InfCore.LogFlow("ReservePlayerLoadingPosition")--tex
  igvars.mis_isGroundStart=false--tex WORKAROUND
  this.DisableGameStatus()
  loadPositionFuncs[missionLoadType](missionLoadType,fromHeliSpace,fromFreeMission,nextIsHeliSpace,nextIsFreeMission,abortWithSave,isLocationChange)--tex broke out from this functions
  if fromHeliSpace and isLocationChange then
    Mission.AddLocationFinalizer(function()
      InfCore.LogFlow"Mission fromHeliSpace and isLocationChange LocationFinalizer"--tex
      this.StageBlockCurrentPosition()
    end)
  else
    this.StageBlockCurrentPosition()
  end
end
function this.StageBlockCurrentPosition(yieldTillEmpty)
  if vars.initialPlayerFlag==PlayerFlag.USE_VARS_FOR_INITIAL_POS then
    StageBlockCurrentPositionSetter.SetEnable(true)
    StageBlockCurrentPositionSetter.SetPosition(vars.initialPlayerPosX,vars.initialPlayerPosZ)
  else
    StageBlockCurrentPositionSetter.SetEnable(false)
  end
  if TppMission.IsHelicopterSpace(vars.missionCode)then
    StageBlockCurrentPositionSetter.SetEnable(true)
    StageBlockCurrentPositionSetter.DisablePosition()
    if yieldTillEmpty then
      while not StageBlock.LargeAndSmallBlocksAreEmpty()do
        coroutine.yield()
      end
    end
  end
end
function this.OnReload(missionTable)
  InfCore.LogFlow("OnReload Top "..vars.missionCode)--tex
  for name,module in pairs(missionTable)do
    if IsTypeFunc(module.OnLoad)then
      module.OnLoad()
    end
    if IsTypeFunc(module.Messages)then
      missionTable[name]._messageExecTable=Tpp.MakeMessageExecTable(module.Messages())
    end
  end
  if OnlineChallengeTask then--RETAILPATCH 1090>
    OnlineChallengeTask.OnReload()
  end--<
  if missionTable.enemy then
    if IsTypeTable(missionTable.enemy.routeSets)then
      TppClock.UnregisterClockMessage"ShiftChangeAtNight"
      TppClock.UnregisterClockMessage"ShiftChangeAtMorning"
      TppEnemy.RegisterRouteSet(missionTable.enemy.routeSets)
      TppEnemy.MakeShiftChangeTable()
    end
  end
  for i,lib in ipairs(Tpp._requireList)do
    local OnReload=_G[lib].OnReload
    if OnReload then
      InfCore.LogFlow(lib..".OnReload")--tex DEBUG
      InfCore.PCallDebug(OnReload,missionTable)--tex PCall
    end
  end
  if mvars.loc_locationCommonTable then
    mvars.loc_locationCommonTable.OnReload()
  end
  if missionTable.sequence then
    TppCheckPoint.RegisterCheckPointList(missionTable.sequence.checkPointList)
  end
  this.SetUpdateFunction(missionTable)
  this.SetMessageFunction(missionTable)
end
function this.OnUpdate(missionTable)
  --ORPHAN: local e
  local moduleUpdateFuncs=moduleUpdateFuncs--NMC set in SetUpdateFunction
  local missionScriptOnUpdateFuncs=missionScriptOnUpdateFuncs
  --ORPHAN: local debugUpdateFuncs=debugUpdateFuncs
  --tex
  if InfCore.debugMode and InfCore.debugOnUpdate then
    for i=1,numModuleUpdateFuncs do
      local ok,err=pcall(moduleUpdateFuncs[i],missionTable)--tex added missionTable param
      if not ok then
        InfCore.Log("ERROR: "..moduleUpdateFuncNames[i]..": "..err)
      end
    end
    for i=1,numOnUpdate do
      local ok,err=pcall(missionScriptOnUpdateFuncs[i])
      if not ok then
        InfCore.Log("ERROR: "..missionScriptOnUpdateFuncNames[i]..": "..err)
      end
    end
    --ORIG>
  else
    for i=1,numModuleUpdateFuncs do
      moduleUpdateFuncs[i](missionTable)--tex added missionTable param
    end
    for i=1,numOnUpdate do
      missionScriptOnUpdateFuncs[i]()
    end
  end
  UpdateScriptsInScriptBlocks()
end
--NMC: called via mission_main
function this.OnChangeSVars(subScripts,varName,key)
  InfCore.LogFlow("mission_main > TppMain.OnChangeSVars "..tostring(varName).." key:"..tostring(key))--tex
  for i,lib in ipairs(Tpp._requireList)do
    local OnChangeSVars=_G[lib].OnChangeSVars
    if OnChangeSVars then
      InfCore.LogFlow(lib..".OnChangeSVars")--tex DEBUG
      InfCore.PCallDebug(OnChangeSVars,varName,key)--tex PCALL
    end
  end
  InfCore.LogFlow("TppMain.OnChangeSVars done")--tex
end
function this.SetMessageFunction(missionTable)--RENAME:
  onMessageTable={}
  onMessageNames={}--tex
  onMessageTableSize=0
  messageExecTable={}
  messageExecNames={}--tex
  messageExecTableSize=0
  for n,lib in ipairs(Tpp._requireList)do
    if _G[lib].OnMessage then
      onMessageTableSize=onMessageTableSize+1
      onMessageTable[onMessageTableSize]=_G[lib].OnMessage
      onMessageNames[onMessageTableSize]=lib--tex
    end
  end
  --tex>
  if not InfMain.IsOnlineMission(vars.missionCode)then
    for i,module in ipairs(InfModules)do
      if module.OnMessage then
        InfCore.LogFlow("SetMessageFunction:"..module.name)
        onMessageTableSize=onMessageTableSize+1
        onMessageTable[onMessageTableSize]=module.OnMessage--tex InfModules
        onMessageNames[onMessageTableSize]=module.name--tex
      end
    end
  end
  --<
  for name,module in pairs(missionTable)do
    if missionTable[name]._messageExecTable then
      messageExecTableSize=messageExecTableSize+1
      messageExecTable[messageExecTableSize]=missionTable[name]._messageExecTable
      messageExecNames[messageExecTableSize]=name--tex
    end
  end
end
--tex called by the exe (via mission_main.OnMessage) TODO: describe when OnMessage is called 
--messages are exclusively fired by code in the engine as a mechanism for lua to respond to events
--sender and messageClass are actually str32 of the original messageexec creation definitions
--GOTCHA: sender is actuall the message class (Player,MotherBaseManagement,UI etc), not to be confused with the sender defined in the messageexec definitions.
--args are lua type number, but may represent enum,int,float, StrCode32, whatever.
--arg0 may match sender (not messageClass) in messageexec definition (see Tpp.DoMessage)
--messages are re-sent until they hit a resend count, and only then is the message actually sent to those subscribed to the messages
--pretty much always defaults to 1/the second time the message is resent (except for Fulton and VehicleBroken which is on the first send)
--can only assume this is to give a frame leeway of the code that fires the message/avoid race conditions

--tex debugMessages, messageDebug.recievers > PrintOnMessage
--since messageExecTables are direct message function references shorn of their origin,
--i'm using messageDebug table to recover information about the recievers/subscribers of messages and pass it to PrintOnMessage
--my initial implementation was to reuse strLogText, which by coincidence I found might have been used for a similar idea (see TppRadio._PlayDebugContinue)
--however the location scripts (afgh.lua etc) put a scarper to that by being the only vanilla use of it, and concatting it as a string, 
--so my use of a table to corral the data I want doesnt work (or rather it works for pretty much everything but mvars.loc_locationCommonTable)
--I'll just sidestep all that with a module member
--TODO: add support to _DoRoutePointMessage, its the only other vanilla use of Tpp.DoMessageAct, but it juggles the attribs a bit
--NOTE: TppRatBird has a rare OnMessage function that doesn anything but always call Tpp.DoMessage with no guard (there's no actuall issue with this though)
--GOTCHA: the main loc_locationCommonTable / location scripts (afgh.lua etc) use their OnMessage to call sub scripts OnMessage functions 
--(mafr_animal,mafr_gimmick), no real issue, just that all these messages will be lumped under 'loc_locationCommonTable'
--GOTCHA: see InfLookup.bannedIdentities for messages that arent PrintOnMessage'd
--tex>
this.messageDebug={
  name="",--tex set OnMessage -v- to the owner/reciever of the messageExecTable
  recievers={}--all the recievers (that DoMessageAct actually finds as recievers/to exec message) for the OnMessage call.
}
function this.ClearMessageDebug()
  this.messageDebug.name=""
  InfUtil.ClearArray(this.messageDebug.recievers)
end--<
function this.OnMessage(missionTable,sender,messageId,arg0,arg1,arg2,arg3)
  local messageDebug=this.messageDebug--tex
  local mvars=mvars--LOCALOPT
  local strLogTextEmpty=""
  --ORPHAN local T
  local DoMessage=Tpp.DoMessage--LOCALOPT
  local CheckMessageOption=TppMission.CheckMessageOption--LOCALOPT
  --ORPHAN local T=TppDebug
  --ORPHAN local T=unk3
  --ORPHAN local T=unk4
  local resendCount=TppDefine.MESSAGE_GENERATION[sender]and TppDefine.MESSAGE_GENERATION[sender][messageId]--0 for Fulton,VehicleBroken
  if not resendCount then
    resendCount=TppDefine.DEFAULT_MESSAGE_GENERATION--1
  end
  local currentResendCount=GetCurrentMessageResendCount()--NMC: tex counts up from 0
  if this.debugModule and InfCore.debugMode and ivars.debugMessages>0 then--tex>
    InfCore.Log("OnMessage "..messageId.." "..sender.." resendCount:"..resendCount.." currentResendCount:"..currentResendCount.." ON_MESSAGE_RESULT_RESEND:"..Mission.ON_MESSAGE_RESULT_RESEND)
  end--<
  if currentResendCount<resendCount then
    return Mission.ON_MESSAGE_RESULT_RESEND--NMC: tex was 1 when dumped, don't think it changes, but who knows
  end  
  local debugMode=InfCore.debugMode--tex>
  local perfStart=0--tex profiling
  local identity=""
  local messageInfoString=""
  if debugMode and ivars.debugMessages>0 then
    this.ClearMessageDebug()

    if InfLookup then
      perfStart=os.clock()
      identity,messageInfoString=InfCore.PCall(InfLookup.PrintOnMessage,sender,messageId,arg0,arg1,arg2,arg3)--pre r262, now called at end: 
      --tex PerfTest, might as well see how heavy this is.
      if this.debugModule then
        local perfTime=os.clock()-perfStart 
        if perfTime>0 then
          InfCore.LogFlow("InfLookup.PrintOnMessage perfTime:"..perfTime)--tex
        end
      end
    end--if InfLookup
  end--if debugMode and debugMessages
  perfStart=os.clock()--tex the rest<
  for i=1,onMessageTableSize do
    local strLogText=strLogTextEmpty
    messageDebug.name=onMessageNames[i]--tex
    onMessageTable[i](sender,messageId,arg0,arg1,arg2,arg3,strLogText)--tex NMC: module.OnMessage, which pretty much all just call Tpp.DoMessage
  end
  --missionTable modules _messageExecTable s
  for i=1,messageExecTableSize do
    local strLogText=strLogTextEmpty
    messageDebug.name=messageExecNames[i]--tex
    DoMessage(messageExecTable[i],CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  end
  if OnlineChallengeTask then--RETAILPATCH 1090>
    messageDebug.name="OnLineChallengeTask"--tex
    OnlineChallengeTask.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogTextEmpty)
  end--<
  if mvars.loc_locationCommonTable then
    messageDebug.name="loc_locationCommonTable"--tex
    mvars.loc_locationCommonTable.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogTextEmpty)
  end
  if mvars.order_box_script then
    messageDebug.name="order_box_script"--tex
    mvars.order_box_script.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogTextEmpty)
  end
  if mvars.animalBlockScript and mvars.animalBlockScript.OnMessage then
    messageDebug.name="animalBlockScript"--tex
    mvars.animalBlockScript.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogTextEmpty)
  end
  if debugMode and ivars.debugMessages>0 then--tex>
    local recieversString="None"
    if #messageDebug.recievers>0 then
      recieversString=table.concat(messageDebug.recievers,', ')
    end
    --tex may have been bunch of other logging between the PrintOnMessage at the start and here
    --PrintOnMessage has a bannedIdentities table, in which case identity will be nil and message wont have neen logged
    if identity then
      InfCore.Log("/OnMessage: "..identity.." recievers: "..recieversString)
    end
    if this.debugModule then
      local perfTime=os.clock()-perfStart
      if perfTime>0 then
        InfCore.LogFlow("OnMessage Bottom: perfTime:"..perfTime)--tex having it always Log can be useful to get an idea if the message is calling a bunch of stuff, but I'll gate it behind perftime for now, since messages that are going through functions that are also flow logged are also likely to be heavy anyway
      end
    end
  end--if debugMessages <
end--OnMessage
function this.OnTerminate(missionTable)
  if missionTable.sequence then
    if IsTypeFunc(missionTable.sequence.OnTerminate)then
      missionTable.sequence.OnTerminate()
    end
  end
end
return this
