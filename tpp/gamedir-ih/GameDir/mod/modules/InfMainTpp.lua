-- InfMainTpp.lua
--tex tpp specific stuff and stuff I've shifted out of lib\InfMain
local this={}

local InfMain=InfMain
local InfUtil=InfUtil
local ipairs=ipairs
local pairs=pairs
local GetTypeIndex=GameObject.GetTypeIndex
local SendCommand=GameObject.SendCommand

this.reserveSoldierNames={}
this.soldierPool={}
this.emptyCpPool={}
this.lrrpDefines={}--tex from AddLrrps

this.MAX_STAFF_NUM_ON_CLUSTER=18--DYNAMIC onallocate--LIMIT

--reserve soldierpool
--tex number of soldier locators in fox2s
this.reserveSoldierCounts={
  [30010]=40,
  [30020]=40,
  [30050]=140,
}

this.packages={
  [30010]={
    "/Assets/tpp/pack/mission2/ih/ih_soldier_loc_free.fpk",--DEPENDENCY mission fox2 Soldier2GameObject totalCount
  },
  [30020]={
    "/Assets/tpp/pack/mission2/ih/ih_soldier_loc_free.fpk"--DEPENDENCY mission fox2 Soldier2GameObject totalCount
  },
}

this.soldierTypeForSubtypes={
  DD_A=EnemyType.TYPE_DD,
  DD_PW=EnemyType.TYPE_DD,
  DD_FOB=EnemyType.TYPE_DD,
  SKULL_CYPR=EnemyType.TYPE_SKULL,
  SKULL_AFGH=EnemyType.TYPE_SKULL,
  SOVIET_A=EnemyType.TYPE_SOVIET,
  SOVIET_B=EnemyType.TYPE_SOVIET,
  PF_A=EnemyType.TYPE_PF,
  PF_B=EnemyType.TYPE_PF,
  PF_C=EnemyType.TYPE_PF,
  CHILD_A=EnemyType.TYPE_CHILD,
}

--tex a few demo files force their own snake heads which naturally goes badly if DD female and use current soldier in cutscenes
this.noSkipIsSnakeOnly={--tex>
  Demo_Funeral=true,--PATCHUP: shining lights end cinematic forces snake head with ash
  --volgin recovery quest, demo forces snake head with bandages
  Demo_RecoverVolgin=true,
  p31_080100_000_final=true,
}

function this.PostModuleReload(prevModule)
  this.reserveSoldierNames=prevModule.reserveSoldierNames
  this.soldierPool=prevModule.soldierPool
  this.emptyCpPool=prevModule.emptyCpPool
  this.lrrpDefines=prevModule.lrrpDefines
end

function this.PreMissionLoad(missionId,currentMissionId)
  this.ClearXRay()--DEBUGNOW DEBUGNOW test this still works now that premissionload is before fova funcs
end

function this.OnAllocateTop(missionTable)
  --DEBUGNOW TODO: needed here or can be shifted to OnAllocate?
  this.MAX_STAFF_NUM_ON_CLUSTER=18--SYNC f30050_sequence
  if Ivars.mbAdditionalSoldiers:Is()>0 then
    this.MAX_STAFF_NUM_ON_CLUSTER=36
  end
end

function this.OnAllocate(missionTable)
  --local equipOnTrucks=Ivars.vehiclePatrolProfile:EnabledForMission() and Ivars.vehiclePatrolTruckEnable:Is(1) and Ivars.putEquipOnTrucks:Is(1)
  --tex not sure how TppPickable.DropItem is implemented, but bunging it in case it creates locators.
  --local increasedWeapons=IvarProc.EnabledForMission("customWeaponTable") or Ivars.itemDropChance:Is()>0 or Ivars.enableWildCardFreeRoam:EnabledForMission() or equipOnTrucks

  --REF TppPlayer.OnAllocate
  --e3 demos (380*1024)*24}--=9338880 -- nearly 5x the max retail block size
  --TppDefine.DEFAULT_EQUIP_MISSION_BLOCK_GROUP_SIZE = 1677721,
  --sequence.EQUIP_MISSION_BLOCK_GROUP_SIZE= max 1887437 (s10054)
  --  if(missionTable and missionTable.sequence)and missionTable.sequence.EQUIP_MISSION_BLOCK_GROUP_SIZE then
  --    mvars.ply_equipMissionBlockGroupSize=missionTable.sequence.EQUIP_MISSION_BLOCK_GROUP_SIZE
  --  else
  --    mvars.ply_equipMissionBlockGroupSize=TppDefine.DEFAULT_EQUIP_MISSION_BLOCK_GROUP_SIZE
  --  end
  --  if(missionTable and missionTable.sequence)and missionTable.sequence.MAX_PICKABLE_LOCATOR_COUNT then
  --    mvars.ply_maxPickableLocatorCount=missionTable.sequence.MAX_PICKABLE_LOCATOR_COUNT--free = 100,100,64 (afgh,mafr,mtbs)
  --  else
  --    mvars.ply_maxPickableLocatorCount=TppDefine.PICKABLE_MAX--16
  --  end
  --  if(missionTable and missionTable.sequence)and missionTable.sequence.MAX_PLACED_LOCATOR_COUNT then
  --    mvars.ply_maxPlacedLocatorCount=missionTable.sequence.MAX_PLACED_LOCATOR_COUNT--free = 200,220,128
  --  else
  --    mvars.ply_maxPlacedLocatorCount=TppDefine.PLACED_MAX--8
  --  end

  --tex seems to be hitting pickable limit in afgh free even with all IH features off? weird.
  --if increasedWeapons then
  --FLOW: set: TppMain.OnAllocate  (before ih modules .OnAllocate) > TppPlayer.OnAllocate
  --FLOW: usage: TppMain.OnAllocate (near end / after modules .OnAllocate) > TppPlayer.SetMaxPickableLocatorCount > TppPickable.OnAllocate
  mvars.ply_maxPlacedLocatorCount=mvars.ply_maxPlacedLocatorCount+20
  mvars.ply_maxPickableLocatorCount=mvars.ply_maxPickableLocatorCount+100
  mvars.ply_equipMissionBlockGroupSize=mvars.ply_equipMissionBlockGroupSize*2
  --end
end

function this.MissionPrepare()
  --tex OFF if TppMission.IsStoryMission(vars.missionCode) then
  if Ivars.gameOverOnDiscovery:Is(1) then
    TppMission.RegistDiscoveryGameOver()
  end
  --end
end

function this.OnInitializeTop(missionTable)
  if InfMain.IsOnlineMission(vars.missionCode)then
    return
  end

  --tex modify missionTable before it's acted on
  if missionTable.enemy then
    local enemyTable=missionTable.enemy
    if Tpp.IsTypeTable(enemyTable.soldierDefine) then
      if not InfMain.IsContinue() then
        local numReserveSoldiers=this.reserveSoldierCounts[vars.missionCode] or 0
        this.reserveSoldierNames=InfUtil.GenerateNameList("sol_ih_%04d",numReserveSoldiers)
        this.soldierPool=InfTppUtil.ResetObjectPool("TppSoldier2",this.reserveSoldierNames)

        this.emptyCpPool=InfMain.BuildEmptyCpPool(enemyTable.soldierDefine)
        this.lrrpDefines={}

        InfWalkerGear.walkerPool=InfTppUtil.ResetObjectPool("TppCommonWalkerGear2",InfWalkerGear.walkerNames)
        InfWalkerGear.mvar_walkerInfo={}

        --        InfCore.Log("numReserveSoldiers:"..numReserveSoldiers)--tex DEBUG
        --        InfCore.PrintInspect(this.reserveSoldierNames,"reserveSoldierNames")--tex DEBUG
        --        InfCore.PrintInspect(this.soldierPool,"soldierPool")--tex DEBUG
      end
      InfCore.PCallDebug(InfSoldier.ModMissionTableTop,missionTable,this.emptyCpPool)--DEBUG

      InfCore.PCallDebug(InfVehicle.ModifyVehiclePatrol,enemyTable.VEHICLE_SPAWN_LIST,enemyTable.soldierDefine,enemyTable.travelPlans,this.emptyCpPool)

      enemyTable.soldierTypes=enemyTable.soldierTypes or {}
      enemyTable.soldierSubTypes=enemyTable.soldierSubTypes or {}
      enemyTable.soldierPowerSettings=enemyTable.soldierPowerSettings or {}
      enemyTable.soldierPersonalAbilitySettings=enemyTable.soldierPersonalAbilitySettings or {}

      InfCore.PCallDebug(InfSoldier.AddLrrps,enemyTable.soldierDefine,enemyTable.travelPlans,this.lrrpDefines,this.emptyCpPool)
      InfCore.PCallDebug(InfWalkerGear.AddLrrpWalkers,this.lrrpDefines,InfWalkerGear.walkerPool)
      InfCore.PCallDebug(InfSoldier.ModifyLrrpSoldiers,enemyTable.soldierDefine,this.soldierPool)

      InfCore.PCallDebug(InfSoldier.AddWildCards,enemyTable.soldierDefine,enemyTable.soldierSubTypes,enemyTable.soldierPowerSettings,enemyTable.soldierPersonalAbilitySettings)

      InfCore.PCallDebug(InfSoldier.ModMissionTableBottom,missionTable,this.emptyCpPool)--DEBUG

      --tex DEBUG unassign soldiers from vehicle lrrp so you dont have to chase driving vehicles
      local ejectVehiclesSoldiers=false
      if ejectVehiclesSoldiers then
        for cpName,cpDefine in pairs(enemyTable.soldierDefine)do
          cpDefine.lrrpVehicle=nil
        end
      end
    end
  end
end

function this.Init(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  this.ModifyMinesAndDecoys()

  if (vars.missionCode==30050 --[[WIP or vars.missionCode==30250--]]) and Ivars.mbEnableFultonAddStaff:Is(1) then
    mvars.trm_isAlwaysDirectAddStaff=false
  end
end

function this.AddMissionPacks(missionCode,packPaths)
  local packages=this.packages[missionCode]
  if packages then
    for i,packPath in ipairs(packages) do
      packPaths[#packPaths+1]=packPath
    end
  end
end

function this.OnMissionCanStart(currentChecks)
  --tex WORKAROUND invasion mode extract from mb weirdness, just disable for now
  --  if Ivars.mbWarGamesProfile:Is"INVASION" and vars.missionCode==30050 then
  --    Player.SetItemLevel(TppEquip.EQP_IT_Fulton_WormHole,0)
  --  end

  local locationName=TppLocation.GetLocationName()
  if Ivars.disableLzs:Is"ASSAULT" then
    InfLZ.DisableLzs(TppLandingZone.assaultLzs[locationName])
  elseif Ivars.disableLzs:Is"REGULAR" then
    InfLZ.DisableLzs(TppLandingZone.missionLzs[locationName])
  end

  if Ivars.disableOutOfBoundsChecks:Is(1) then
    mvars.mis_ignoreAlertOfMissionArea=true
    local trapName="trap_mission_failed_area"
    local enable=false
    TppTrap.ChangeNormalTrapState(trapName,enable)
    TppTrap.ChangeTriggerTrapState(trapName,enable)
  end
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
      {msg="Damage",func=this.OnDamage},
    },
    Player={
      {msg="FinishOpeningDemoOnHeli",func=this.ClearMarkers},--tex xray effect off doesn't stick if done on an endfadein, possibly because TppMission FinishOpeningDemoOnHeli listener clears status on them, messages calls seem to respect registration order? (TppMission messages are registered before IH modules ?) so slapping this on same msg seems to work VERIFY
    },
    Timer={
      {msg="Finish",sender="Timer_WaitStartingGame",func=this.OnGameStart},
    },
    UI={
      {msg="EndFadeIn",sender="FadeInOnGameStart",func=this.FadeInOnGameStart},--fires on: most mission starts, on-foot free and story missions, not mb on-foot, but does mb heli start
      {msg="EndFadeIn",sender="FadeInOnStartMissionGame",func=this.FadeInOnGameStart},--fires on: returning to heli from mission
      {msg="EndFadeIn",sender="OnEndGameStartFadeIn",func=this.FadeInOnGameStart},--fires on: on-foot mother base, both initial and continue
    },
  }
end

--TODO: VERIFY, add vehicle machineguns
local vehicleAttacks={
  [TppDamage.ATK_VehicleHit]=true,
  [TppDamage.ATK_Tankgun_20mmAutoCannon]=true,
  [TppDamage.ATK_Tankgun_30mmAutoCannon]=true,
  [TppDamage.ATK_Tankgun_105mmRifledBoreGun]=true,
  [TppDamage.ATK_Tankgun_120mmSmoothBoreGun]=true,
  [TppDamage.ATK_Tankgun_125mmSmoothBoreGun]=true,
  [TppDamage.ATK_Tankgun_82mmRocketPoweredProjectile]=true,
  [TppDamage.ATK_Tankgun_30mmAutoCannon]=true,
  [TppDamage.ATK_Wav1]=true,
  [TppDamage.ATK_WavCannon]=true,
  [TppDamage.ATK_TankCannon]=true,
  [TppDamage.ATK_WavRocket]=true,
  [TppDamage.ATK_HeliMiniGun]=true,
  [TppDamage.ATK_HeliChainGun]=true,
}
function this.OnDamage(gameId,attackId,attackerId)
  local typeIndex=GetTypeIndex(gameId)
  if typeIndex~=TppGameObject.GAME_OBJECT_TYPE_SOLDIER2 then--and typeIndex~=TppGameObject.GAME_OBJECT_TYPE_HELI2 then
    return
  end

  if Tpp.IsPlayer(attackerId) then
    --InfCore.DebugPrint"OnDamage attacked by player"
    local soldierAlertOnHeavyVehicleDamage=Ivars.soldierAlertOnHeavyVehicleDamage:Get()
    if soldierAlertOnHeavyVehicleDamage>0 then
      if vehicleAttacks[attackId] then
        --InfCore.DebugPrint"OnDamage AttackIsVehicle"
        for cpId,soldierIds in pairs(mvars.ene_soldierIDList)do--tex TODO:find or build a better soldierid>cpid lookup
          if soldierIds[gameId]~=nil then
            if TppEnemy.GetPhaseByCPID(cpId)<soldierAlertOnHeavyVehicleDamage then
              --InfCore.DebugPrint"OnDamage found soldier in idlist"
              local command={id="SetPhase",phase=soldierAlertOnHeavyVehicleDamage}
              SendCommand(cpId,command)
              break
            end
          end--if cp not phase
        end--for soldieridlist
      end--attackisvehicle
    end--gvar
  end--player is attacker
end

--msg called fadeins
function this.FadeInOnGameStart()
  this.ClearMarkers()

  this.ChangeMaxLife()
end

--Callers: msgs
function this.ClearMarkers()
  if Ivars.disableHeadMarkers:Is(1) then
    TppUiStatusManager.SetStatus("HeadMarker","INVALID")
  end
  if Ivars.disableWorldMarkers:Is(1) then
    TppUiStatusManager.SetStatus("WorldMarker","INVALID")
  end
end

function this.ChangeMaxLife(setOn1)
  --tex player life values for difficulty. Difficult to track down the best place for this, player.changelifemax hangs anywhere but pretty much in game and ready to move, Anything before the ui ending fade in in fact, why.
  --which i don't like, my shitty code should be run in the shadows, not while player is getting viewable frames lol, this is at least just before that
  --RETRY: push back up again, you may just have fucked something up lol, the actual one use case is in sequence.OnEndMissionPrepareSequence which is the middle of tppmain.onallocate

  --default player life is defined as 6000 in *player(s)_game_obj.fox2/TppPlayer2Parameter/lifeMax
  --however this is only the value during the early game
  --after mission 2 it bumps up to 6600 (6000*1.1?)
  --with medical hand grade 2 or higher (as snake or avatar), or with a DD soldier with the tough guy skill this increases to
  --7801, which is a bit over 6000*1.3, which is strange.

  --vars.playerLifeMax is uint16 (ta NasaNhak) so just capping max at 50k (*1.3=65k) to avoid the overflow
  --Ivar max (6.5 scale) is actually a bit over 50k, but I'll cap here for sanity

  -- see wiki for more info http://wiki.tesnexus.com/index.php/Life
  local healthScale=Ivars.playerHealthScale:Get()/100
  if healthScale~=1 or setOn1 then
    Player.ResetLifeMaxValue()
    local newMax=vars.playerLifeMax
    newMax=newMax*healthScale
    newMax=math.max(10,newMax)
    --newMax=math.min(2^16-1,newMax)--unint16 max
    newMax=math.min(50000,newMax)
    Player.ChangeLifeMaxValue(newMax)
  end
end

function this.OnFultonVehicle(vehicleId)
--WIP CULL
--tex not actually that useful, need to alert nearby cps instead
--  local cpAlertOnVehicleFulton=Ivars.cpAlertOnVehicleFulton:Get()
--  if cpAlertOnVehicleFulton>0 then--tex
--    InfCore.DebugPrint"cpAlertOnVehicleFulton>0"--DEBUG
--    local riderIdArray=SendCommand(vehicleId,{id="GetRiderId"})
--    for seatIndex,riderId in ipairs(riderIdArray) do
--      if seatIndex==1 then
--        if riderId~=NULL_ID then
--          InfCore.DebugPrint"vehicle has driver"--DEBUG
--          for cpId,soldierIds in pairs(mvars.ene_soldierIDList)do
--            if soldierIds[riderId]~=nil then
--              InfCore.DebugPrint"found rider cp"--DEBUG
--              if TppEnemy.GetPhaseByCPID(cpId)<cpAlertOnVehicleFulton then
--                local command={id="SetPhase",phase=cpAlertOnVehicleFulton}
--                SendCommand(cpId,command)
--                break
--              end
--            end
--          end
--        end
--      end
--    end
--  end--<
end

--TppSequence msg Timer_WaitStartingGame finish
function this.OnGameStart()
  --tex WORKAROUND, vars.mbLayout (also TppMotherBaseManagement.GetMbsClusterGrade) isn't updated on a command cluster plat built till after TppMain.ReservePlayerLoadingPosition
  if vars.missionCode==30050 then
    if gvars.ply_initialPlayerState==TppDefine.INITIAL_PLAYER_STATE.ON_FOOT then
      --InfCore.Log("playerposfailsafe ON_FOOT playerY="..vars.playerPosY)--DEBUG
      if vars.playerPosY<-9 then
        InfCore.Log("PlayerPos Failsafe")
        --tex TODO could store vars.mbLayout during load and compare to see if it's changed?
        if gvars.heli_missionStartRoute then
          local groundStartPosition=InfLZ.GetGroundStartPosition(gvars.heli_missionStartRoute)
          --InfCore.PrintInspect(groundStartPosition)--DEBUG
          TppPlayer.Warp{pos=groundStartPosition.pos,rotY=vars.playerRotY}
        end
      end
    end
  end
end
--< messages

function this.ClearXRay()
  if Ivars.disableXrayMarkers:Is(1) then
    --TppSoldier2.DisableMarkerModelEffect()
    TppSoldier2.SetDisableMarkerModelEffect{enabled=true}
  end
end

local mineFieldMineTypes={
  {TppEquip.EQP_SWP_DMine,3},--tex bias toward original minefield intentsion/anti personal mines
  TppEquip.EQP_SWP_SleepingGusMine,
  TppEquip.EQP_SWP_AntitankMine,
  TppEquip.EQP_SWP_ElectromagneticNetMine,
}

--CALLER: TppMain.OnInitialize, just after loc_locationCommonTable.OnInitialize()
function this.ModifyMinesAndDecoys()
  if Ivars.randomizeMineTypes:Is(0) then
    return
  end

  local mineTypeBag=InfUtil.ShuffleBag:New(mineFieldMineTypes)
  if mvars.rev_revengeMineList then
    InfMain.RandomSetToLevelSeed()
    for cpName,mineFields in pairs(mvars.rev_revengeMineList)do
      for i,mineField in ipairs(mineFields)do
        if mineField.mineLocatorList then
          for i,locatorName in ipairs(mineField.mineLocatorList)do
            TppPlaced.ChangeEquipIdByLocatorName(locatorName,mineTypeBag:Next())
          end
        end
        --tex WIP no go
        --          if mineField.decoyLocatorList then
        --            for i,locatorName in ipairs(mineField.decoyLocatorList)do
        --              TppPlaced.ChangeEquipIdByLocatorName(locatorName,TppEquip.EQP_SWP_SleepingGusMine)
        --            end
        --          end
      end
    end
    InfMain.RandomResetToOsTime()
  end
end

function this.ResetCpTableToDefault()
  local subTypeOfCp=TppEnemy.subTypeOfCp
  local subTypeOfCpDefault=TppEnemy.subTypeOfCpDefault
  if subTypeOfCpDefault then
    for cp, subType in pairs(subTypeOfCp)do
      subTypeOfCp[cp]=subTypeOfCpDefault[cp]
    end
  end
end
--TODO: and soldier sub types?
local changeCpSubTypeStr="changeCpSubType"
function this.RandomizeCpSubTypeTable(missionTable)
  if InfMain.IsOnlineMission(vars.missionCode)then
    return
  end

  if not IvarProc.EnabledForMission(changeCpSubTypeStr) then
    this.ResetCpTableToDefault()
    return
  end

  if missionTable.enemy==nil then
    return
  end

  local soldierDefine=missionTable.enemy.soldierDefine
  if soldierDefine==nil or next(soldierDefine)==nil then
    return
  end
  --tex cant use missionTable.enemy.cpSubTypes since that will only be on some addon missions
  --TODO: this way only randomizes the defined subtypes for the mission rather than all possible subtypes for the type
  local subTypeOfCpDefault=TppEnemy.subTypeOfCpDefault
  local locationSubTypesTable={}
  for cpName,soldierNameList in pairs(soldierDefine) do
    local subType=subTypeOfCpDefault[cpName]
    if not subType then
      InfCore.Log("RandomizeCpSubTypeTable no subTypeOfCpDefault for "..tostring(cpName))--DEBUGNOW
    else
      locationSubTypesTable[subType]=true
    end
  end
  local locationSubTypes={}
  for subType,bool in pairs(locationSubTypesTable)do
    table.insert(locationSubTypes,subType)
  end
  InfCore.PrintInspect(locationSubTypes,"InfMainTpp.RandomizeCpSubTypeTable locationSubTypes")--
  if #locationSubTypes<2 then
    InfCore.Log("InfMainTpp.RandomizeCpSubTypeTable: #locationSubTypes<2, returning")
    return
  end
  InfMain.RandomSetToLevelSeed()--tex set to a math.random on OnMissionClearOrAbort so a good base for a seed to make this constand on mission loads. Soldiers dont care since their subtype is saved but other functions read subTypeOfCp
  local subTypeOfCp=TppEnemy.subTypeOfCp
  for cp, subType in pairs(subTypeOfCp)do
    local subType=subTypeOfCp[cp]

    local rnd=math.random(1,#locationSubTypes)
    subTypeOfCp[cp]=locationSubTypes[rnd]
  end
  InfMain.RandomResetToOsTime()
end--RandomizeCpSubTypeTable

function this.SetSubsistenceSettings()
  --tex no go, see OnMissionCanStartBottom for alt solution
  --  if InfMain.IsOnlineMission(vars.missionCode) then
  --    if vars.weapons[TppDefine.WEAPONSLOT.PRIMARY_HIP]==TppEquip.EQP_None then
  --      --InfCore.Log("TppDefine.WEAPONSLOT.PRIMARY_HIP]==TppEquip.EQP_None")--DEBUG
  --      TppPlayer.SetInitWeapons({{primaryHip="EQP_WP_30001"}},true)
  --    end
  --    if vars.weapons[TppDefine.WEAPONSLOT.SECONDARY]==TppEquip.EQP_None then
  --      --InfCore.Log("TppDefine.WEAPONSLOT.SECONDARY]==TppEquip.EQP_None")--DEBUG
  --      TppPlayer.SetInitWeapons({{secondary="EQP_WP_10101"}},true)
  --    end
  --    return
  --  end


  --TppPlayer.SetInitWeapons(initSetting,true)

  if InfMain.IsOnlineMission(vars.missionCode) then
    return
  end

  if TppMission.IsHelicopterSpace(vars.missionCode) then
    return
  end

  if vars.missionCode<=TppDefine.SYS_MISSION_ID.TITLE then
    return
  end

  local Ivars=Ivars

  if Ivars.disableFulton:Is(1) then
    vars.playerDisableActionFlag=vars.playerDisableActionFlag+PlayerDisableAction.FULTON--tex RETRY:, may have to replace instances with a SetPlayerDisableActionFlag if this doesn't stick
  end

  --tex: DEF: Player.SetItemLevel(equipId,itemGrade)
  --itemGrade is grade as shown in idroid item development
  --it's kind of a case by case to how the items deal with the levels and if they disable

  --tex hands have no grade 1 entry shown in dev, will disable at grade 1
  local handLevelIvars={
    Ivars.handLevelSonar,
    Ivars.handLevelPhysical,
    Ivars.handLevelPrecision,
    Ivars.handLevelMedical,
  }
  for i,itemIvar in ipairs(handLevelIvars) do
    if itemIvar:Is()>0 then
      --TODO: check against developed
      --local currentLevel=Player.GetItemLevel(equip)
      --InfCore.DebugPrint(itemIvar.name..":"..itemIvar.setting)--DEBUG
      --tex levels = grades in dev menu, so 1=off since there's no grade 1 for these
      Player.SetItemLevel(itemIvar.equipId,itemIvar:Get())
    end
  end

  --tex fulton does not disable at grade 0, will be overridden if wormhole grade > 0.
  if Ivars.itemLevelFulton:Is()>0 then
    --TODO: check against developed
    --REF local currentLevel=Player.GetItemLevel(equip)
    Player.SetItemLevel(Ivars.itemLevelFulton.equipId,Ivars.itemLevelFulton:Get())
  end
  --tex wormhole grade 0 = disabled/use fulton grade, > 0 = enabled
  if Ivars.itemLevelWormhole:Is()>0 then
    --TODO: check against developed
    --REF local currentLevel=Player.GetItemLevel(equip)
    --tex levels = 0 off, 1 on, but since ivar uses 0 as default, shift by 1.
    Player.SetItemLevel(Ivars.itemLevelWormhole.equipId,Ivars.itemLevelWormhole:Get()-1)
  end

  --tex pretty normal grade wise (code could be merged with hands), grade 0 does not disable.
  local itemLevelIvars={
    Ivars.itemLevelIntScope,
    Ivars.itemLevelIDroid,
  }
  for i,itemIvar in ipairs(itemLevelIvars) do
    if itemIvar:Is()>0 then
      --TODO: check against developed
      --local currentLevel=Player.GetItemLevel(equip)
      --InfCore.DebugPrint(itemIvar.name..":"..itemIvar.setting)--DEBUG
      --tex levels = grades in dev menu, so itemlevel 0=off, but shifting since ivar 0 = dont set.
      Player.SetItemLevel(itemIvar.equipId,itemIvar:Get())
    end
  end

  if TppMission.IsSubsistenceMission()then
    return
  end

  if Ivars.setSubsistenceSuit:Is(1) then
    local playerSettings={partsType=PlayerPartsType.NORMAL,camoType=PlayerCamoType.OLIVEDRAB,handEquip=TppEquip.EQP_HAND_NORMAL,faceEquipId=0}
    TppPlayer.RegisterTemporaryPlayerType(playerSettings)
  end
  if Ivars.setDefaultHand:Is(1) then
    mvars.ply_isExistTempPlayerType=true
    mvars.ply_tempPlayerHandEquip={handEquip=TppEquip.EQP_HAND_NORMAL}
  end

  --tex bail on free<>mission to preserver your equip
  --tex not MB
  local free={
    [30010]=true,
    [30020]=true,
  }
  if not Ivars.prevMissionCode then
    return
  end

  if Ivars.dontOverrideFreeLoadout:Is(1) then
    if (free[Ivars.prevMissionCode] and TppMission.IsStoryMission(vars.missionCode))
      or (free[vars.missionCode] and TppMission.IsStoryMission(Ivars.prevMissionCode)) then
      return
    end
  end

  local ospIvars={
    Ivars.primaryWeaponOsp,
    Ivars.secondaryWeaponOsp,
    Ivars.tertiaryWeaponOsp,
    Ivars.clearSupportItems,
    Ivars.clearItems,
  }

  for i,ivar in ipairs(ospIvars) do
    if igvars.inf_event==false then
      IvarProc.UpdateSettingFromGvar(ivar)
    end

    local initSetting=ivar:GetTableSetting()
    if initSetting then
      if ivar==Ivars.clearItems then
        TppPlayer.SetInitItems(initSetting,true)
      else
        TppPlayer.SetInitWeapons(initSetting,true)
      end
    end
  end
end


--UTIL TODO: maybe actually move to util
function this.WarpRat(gameObjectName,pos,rotY)
  local gameObjectId={type="TppRat",index=0}
  local route=""
  local command={id="Warp",name=gameObjectName,ratIndex=0,position=pos,degreeRotationY=rotY,route=route,nodeIndex=0}
  GameObject.SendCommand(gameObjectId,command)
end

--tex used to counteract sendcommand IsDD in TppHero / stop dd staff killed message and point loss
--TODO: not handling hostage
--(ie should be used in conjunction with, unless you want to throw a IsDD or maybe EnemyType.TYPE_DD in)
--currently only used in TppHero to manage mb_staff_died
--currently soldiers only
--REF base game DD soldiers
--MB Free soldiers - your staff
--Fob soldiers:
--defense - your staff
--attack - enemy dd
--Fob Hostages, but only on event?
--10115 : Mission 22 - Retake the Platform
--soldiers - enemy dd
--hostages - your staff
--10240 : shining lights -- your staff
--some sideops hostages (which ones exactly?) - your staff
--sideops wandering mb soldiers - your staff

--sendcommand IsDD seems to return true when soldierType==EnemyType.TYPE_DD -- VERIFY
--seems to have an exception (return false) for 10115 soldiers VERIFY
--what about FOB?

--DEBUGNOW reworked to just assume anything outside of vanilla usage for DD soldiers means DD are from an addon where DD type is used as enemy,
--but may eventually want authors to more explicitly define if the DD type is enemy or staff
function this.IsDDEnemy(gameId)
  local missionCode=vars.missionCode
  if TppMission.IsFOBMission(missionCode) then
    return false
  end

  --if Tpp.IsHostage(gameId)then
  --elseif Tpp.IsSoldier(gameId)then--tex current usage already has this check
  --tex mb invasion TODO can't remember if I mbqf can have invasion lol
  if (missionCode==30050 or missionCode==30250) and Ivars.mbNonStaff:Is(0) then
    return false
  end

  if missionCode==10240 then
    return false
  end

  if true then
    return true
  end
  -----


  if missionCode==10115 then
    return true--tex see note about IsDD exception above
  end

  if Ivars.customSoldierTypeFREE:Is()>0 and Ivars.customSoldierTypeFREE:MissionCheck() then
    return true
  end
  if Ivars.customSoldierTypeMISSION:Is()>0 and Ivars.customSoldierTypeMISSION:MissionCheck() then
    return true
  end

  --tex problem: some community sideops (caplags for ex) set the soldier type to TYPE_DD to have the soldiers talk english (VERIFY some languae setting in exe keying off soldierType?)
  --and to workaround some soldierType>weaponIdTable issues.
  --TODO some way of indicating quest soldier is enemy
  --but the recover old msf soldiers quests are actual legit flagged as TYPE_DD so also need to cover that
  --would take a bit of effort to get working as:
  --(unless I've missed something) currently there's no way of knowing if soldier is part of a quest using just their gameId
  --(the assumption that they are only sol_quest* soldiers isn't always true for some sideops that use existing soldiers)
  --the best spot to flag them as ddenemy would be the quest script, but that also has no easy way to reference
  --KLUDGE, as above TODO is not implemented
  if TppMission.IsFreeMission(missionCode)and(missionCode~=30050 and missionCode~=30250)then
    local soldierType=mvars.ene_soldierTypes[gameId]
    if soldierType==EnemyType.TYPE_DD then
      local subType=mvars.ene_soldierSubType[gameId]
      --ASSUMPTION: vanilla game TYPE_DD at this point (which should only be quest dd wandering soldiers) have correct sub type (looks like they don't have explicitly set subtype but default to DD_A)
      --so incorrect subtype would be from a community sideop
      if not InfEneFova.IsSubTypeCorrectForType(soldierType)then
        return true
      end
    end
  end--isFreeMission

  --tex revisit this if you ever fix wildcard females
  --if Ivars.enableWildCardFreeRoam:Is()>0 and Ivars.enableWildCardFreeRoam:MissionCheck() then
  --(would need an is female check)
  --  return
  --end
  --end--hostage or soldier
end

-- mb dd equip
--tex TODO: don't like how this is still tied up both with weapon table and .GetMbs ranks
--CULL and all uses off
local enableDDEquipStr="enableDDEquip"
function this.IsDDEquip(missionId)
  local missionCode=missionId or vars.missionCode
  if not InfMain.IsOnlineMission(missionId) and missionCode >5 then--tex IsFreeMission hangs on startup? TODO retest
    return IvarProc.EnabledForMission(enableDDEquipStr)
  end
  return false
end

function this.GetMbsClusterSecuritySoldierEquipGrade(missionId)--SYNC: soldierEquipGrade
  local missionCode=missionId or vars.missionCode
  local grade = TppMotherBaseManagement.GetMbsClusterSecuritySoldierEquipGrade{}
  if this.IsDDEquip(missionCode) then
    InfMain.RandomSetToLevelSeed()
    grade=InfMain.MinMaxIvarRandom"soldierEquipGrade"
    InfMain.RandomResetToOsTime()
  end
  --TppUiCommand.AnnounceLogView("GetEquipGrade: gvar:".. Ivars.soldierEquipGrade:Get() .." grade: ".. grade)--DEBUG
  --TppUiCommand.AnnounceLogView("Caller: ".. tostring(debug.getinfo(2).name) .." ".. tostring(debug.getinfo(2).source))--DEBUG
  return grade
end

function this.GetMbsClusterSecuritySoldierEquipRange(missionId)
  local missionCode=missionId or vars.missionCode
  if this.IsDDEquip(missionCode) then
    if Ivars.mbSoldierEquipRange:Is"RANDOM" then
      return math.random(0,2)--REF:{ "FOB_ShortRange", "FOB_MiddleRange", "FOB_LongRange", }, but range index from 0
    else
      return Ivars.mbSoldierEquipRange:Get()
    end
  end
  return TppMotherBaseManagement.GetMbsClusterSecuritySoldierEquipRange()
end

function this.GetMbsClusterSecurityIsNoKillMode(missionId)
  local missionCode=missionId or vars.missionCode
  if this.IsDDEquip(missionCode) then
    return Ivars.mbDDEquipNonLethal:Is(1)
  end
  return TppMotherBaseManagement.GetMbsClusterSecurityIsNoKillMode()
end

function this.GetAverageRevengeLevel()
  local stealthLevel=TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.STEALTH)
  local combatLevel=TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT)

  return math.floor((stealthLevel+combatLevel)/2)
end

function this.IsNonCombatMission(missionCode)
  missionCode=missionCode or vars.missionCode
  --tex KLUDGE TODO: really need a good way to indicate this is a non combat mission,
  --also may need to expand this to other stuff (see what else is being called where this function is called, or rather whats calling that)
  local mbMissions={[30050]=true,[30150]=true,[30250]=true}--tex>
  if mbMissions[vars.missionCode] and not this.IsMbEvent(vars.missionCode) then
    return true
  end
end--IsNonCombatMission
function this.IsMbEvent(missionCode)
  missionCode=missionCode or vars.missionCode
  return missionCode==30050 and (Ivars.mbWarGamesProfile:Is()>0 or igvars.inf_event~=false)
end

--UTIL CULL not used, if used then should be moved to TppUtil or something
function this.IsMBDemoStage()
  if vars.missionCode~=30050 then
    return false
  end

  return (not TppPackList.IsMissionPackLabel"default") or TppDemo.IsBattleHangerDemo(TppDemo.GetMBDemoName())
end

--tex CULL doesn't seem to work, either I'm doing something wrong or the buddy system doesnt use it for mb
function this.OverwriteBuddyPosForMb()
  if TppMission.IsMbFreeMissions(vars.missionCode) and Ivars.mbEnableBuddies:Is(1)then
    if gvars.heli_missionStartRoute~=0 then
      local groundStartPosition=InfLZ.GetGroundStartPosition(gvars.heli_missionStartRoute)
      if groundStartPosition then
        local mbBuddyEntrySettings={}
        local pos=Vector3(groundStartPosition.pos[1],groundStartPosition.pos[2],groundStartPosition.pos[3])
        local entryEntry={}
        entryEntry[EntryBuddyType.BUDDY]={pos,0}
        --entryEntry[EntryBuddyType.VEHICLE]={pos,0}
        mbBuddyEntrySettings[gvars.heli_missionStartRoute]=entryEntry
        TppEnemy.NPCEntryPointSetting(mbBuddyEntrySettings)
      end
    end
  end
end

--CALLER start2nd
--tex messy, but lets user still use MbmCommonSetting/EquipDevelopConstSetting/EquipDevelopFlowSetting mods
function this.MBManagementSettings()
  InfCore.LogFlow("InfMainTpp.MBManagementSettings")
  --MbmCommonSetting
  TppMotherBaseManagement.RegisterMissionBaseStaffTypes{missionId=30050,staffTypes={2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}}--tex to give proper stats/skills spread on MB invasion
  --EquipDevelopConstSetting
  --key for games NONE lang strings has not been discovered, so adding to IH till/if then.
  TppMotherBaseManagement.RegCstDev{p00=900,p01=TppEquip.EQP_None,p02=TppMbDev.EQP_DEV_TYPE_Handgun,p03=0,p04=0,p05=65535,p06="equip_none",p07="info_wp_none",p08="/Assets/tpp/ui/texture/EquipIcon/equip_blank_icon_alp",p09=TppMbDev.EQP_DEV_GROUP_WEAPON_010,p10="cmmn_wp_none",p30="cmmn_wp_none",p31=0,p32=0,p33=0,p34=0,p35=0,p36=0}
  TppMotherBaseManagement.RegCstDev{p00=901,p01=TppEquip.EQP_None,p02=TppMbDev.EQP_DEV_TYPE_Assault,p03=0,p04=0,p05=65535,p06="equip_none",p07="info_wp_none",p08="/Assets/tpp/ui/texture/EquipIcon/equip_blank_icon_alp",p09=TppMbDev.EQP_DEV_GROUP_WEAPON_010,p10="cmmn_wp_none",p30="cmmn_wp_none",p31=0,p32=0,p33=0,p34=0,p35=0,p36=0}
  --EquipDevelopFlowSetting
  --tex SYNC p50 to last EquipDevelopFlowSetting entry p50 +1, or to 0 - but that gives a 'Development requirements met' message each startup, even if item is developed.
  TppMotherBaseManagement.RegFlwDev{p50=920,p51=0,p52=1,p53=0,p54=0,p55=0,p56=0,p57=0,p58="",p59=0,p60="",p61=0,p62=1,p63=0,p64=0,p65="",p66=0,p67="",p68=0,p69=0,p70=0,p71=0,p72=0,p73=0,p74=1}
  TppMotherBaseManagement.RegFlwDev{p50=921,p51=0,p52=1,p53=0,p54=0,p55=0,p56=0,p57=0,p58="",p59=0,p60="",p61=0,p62=1,p63=0,p64=0,p65="",p66=0,p67="",p68=0,p69=0,p70=0,p71=0,p72=0,p73=0,p74=1}
end

return this
