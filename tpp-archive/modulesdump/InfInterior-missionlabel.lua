--InfInterior.lua
-- tex implements IH interior addon system
--currently only for motherbase

--TODO: make rest of IH interior aware. I guess: IsMissionPackLabel, but "default" or "Interior"?

--REF clusters {"Command","Combat","Develop","Support","Medical","Spy","BaseDev"}

--REF interior addon module <GameDir>\mod\interiors\ >
--DEBUGNOW
--local this={
--  description="Interior example: BG Hangar",--description for IH
--  missionCode=30050,--missionCode this is an interior for DEBUGNOW do I want to restrict it like that? its needed at some point, and all the outer exit info is a position in the specific mission
--  packs=function(missionCode)--DEBUGNOW?--interior packs
--    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/free/f30050/f30050_hanger_minimal_ih.fpk"
--    --TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/free/f30050/f30050_interior_minimal_void.fpk"
--  end,
--  missionPacks={--tex packs loaded in exterior mission (for missionCode), usually just the extererior entrance switch
--    --mbLayoutCode.
--    [0]={"/Assets/tpp/pack/location/mtbs/pack_area/mtbs_area_ly003_cl00_ih.fpk",},--DEBUGNOW this fpk not in right place, see area packs mtbs_area_ly003_cl00
--  },
--  --tex switch on mb to enter interior. strictly speaking this doesn't need to have anything to do with the interior
--  enterSwitchLocatorName="ext_enter_switch_cl0_plnt0_hangar_ih",--DEBUGNOW
--  enterSwitchDataSet="/Assets/tpp/level/location/mtbs/block_large/ext_switches_ly03_cl00_ih.fox2",--DEBUGNOW this will be dynamic on vars.layout
--  --tex interior to exterior switch, defined in an interior pack
--  exitSwitchLocatorName="int_exit_switch_mtbs_hanger_test_ih",
--  exitDataSetName="/Assets/tpp/level/location/mtbs/block_large/mtbs_hanger_gimmick_test_ih.fox2",
--  startPos={pos={-11.600,-8.000,8.511},rotY=180},--start position, rotation in interior coordinates
--  startCamera={rotX=-10,rotY=200},--optional, initial camera rotation once warped to interior
--  clusterName="Command",--mb specific, the cluster this interior is supposed to be in
--  plant="plnt0",--mb specific, the plant (platform) the interior is supposed to be in
--  outsideExitPos={pos={-30.980, -7.000, 14.779},rotY=0},--DEBUGNOW in relation to platform center?? see GetPositionOuterInterior
--}
--return this
--< REF interior addon module

local this={}

local StrCode32=InfCore.StrCode32

this.infosPath="interiors"

this.names={}
this.infos={}--[name]=info

--[StrCode32(info.enterSwitchLocatorName)]=info
--[StrCode32(info.exitSwitchLocatorName)]=info
this.infoForSwitch={}

--CULL
--function this.DeclareSVars()
----  if not   then
----    return{}
----  end
--  local saveVarsList={
--    interiorId=0,--tex index of interior name, which isn't really safe over sessions if user installs or uninstalls interiors, but we aren't saving while in interior at the moment anyway
--  }
--  return TppSequence.MakeSVarsTable(saveVarsList)
--end--DeclareSVars

function this.PostModuleReload(prevModule)
  this.LoadLibraries()
end--PostAllModulesLoad

function this.LoadLibraries()
  this.LoadInfos()
  this.RegisterInfos()
end--LoadLibraries

function this.LoadInfos()
  --tex load infos
  local names={}
  local infos={}
  
  local files=InfCore.GetFileList(InfCore.files[this.infosPath],".lua")
  for i,fileName in ipairs(files)do
    InfCore.Log("Load info: "..this.infosPath.." "..fileName)
    InfCore.Log("LoadLibraries "..fileName)
    local name=InfUtil.StripExt(fileName)
    local module=InfCore.LoadSimpleModule(InfCore.paths[this.infosPath],fileName)
    if module==nil then
    --tex LoadSimpleModule should give the error
    else
      --TODO VALIDATE
      infos[name]=module
      table.insert(names,name)
    end--if module
  end
  
  this.names=names
  this.infos=infos
end--LoadInteriorInfos

function this.RegisterInfos()
  for name,info in pairs(this.infos)do
    this.infoForSwitch[StrCode32(info.enterSwitchLocatorName)]=info
    this.infoForSwitch[StrCode32(info.exitSwitchLocatorName)]=info
  end--for infos
end--RegisterInfos

function this.AddMissionPacks(missionCode,packPaths)
  if not InfMain.IsPastTitle(missionCode) then
    return
  end

  for interiorName,interiorInfo in pairs(this.infos)do
    if interiorInfo.missionCode==missionCode then
      local missionPacks=interiorInfo.missionPacks
      if missionPacks then
        if missionCode==30050 then
          missionPacks=missionPacks[vars.mbLayoutCode] or missionPacks[0]--tex layout 0 can act as an all-layouts pack
        end
        for i,packPath in ipairs(missionPacks)do
          packPaths[#packPaths+1]=packPath
        end
      end--if packs
    end--if missionCode
  end--for infor
end--AddMissionPacks
--CALLER: missionPackTable[30050] MissionPackLabel "Interior"
function this.AddInteriorMissionPacks(missionCode)
  --DEBUGNOW get missionCode/ base pack for mission
  if missionCode==30050 then
    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/free/f30050/f30050_interior_base.fpk"
  end
  --
  local interiorInfo=this.infos.mtbs_test_hangar--DEBUGNOW how do we know what interior??
  --
  if type(interiorInfo.packs)=="function"then
    interiorInfo.packs(missionCode)
  end
end
--CALLER: f30050_sequence msg = "SwitchGimmick"
--REF PushSwitchOnLeaveBattleHanger
function this.PushSwitchOnLeave(gameObjectId,locatorNameS32,name,switchFlag)
  InfCore.Log"InfInterior.PushSwitchOnLeave"--tex DEBUG

  local interiorInfo=this.infoForSwitch[locatorNameS32]
  if interiorInfo==nil then
    InfCore.Log("ERROR: InfInterior.PushSwitchOnLeave infoForSwitch["..InfLookup.StrCode32ToString(locatorNameS32).." S32]==nil")
    return false
  end

  if locatorNameS32~=StrCode32(interiorInfo.exitSwitchLocatorName) then
    InfCore.Log("ERROR: InfInterior.PushSwitchOnLeave locatorName ~= "..tostring(interiorInfo.exitSwitchLocatorName))
    return false
  end

  --tex TODO? (interior def optional) open interior door
  --  local dataSetName = "/Assets/tpp/level/location/mtbs/block_large/mtbs_hanger_gimmick.fox2"
  --  local dataName = "mtbs_door006_door004_ev_gim_n0000|srt_mtbs_door006_door004_ev"
  --  Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, dataName, dataSetName, false)
  --tex TODO -^- open door sound, just play at info outsideExitPos?
  --  local soundPos = this.GetPositionInInteriorDoor()
  --  TppSoundDaemon.PostEvent3D( "sfx_m_hanger_door_open", Vector3(soundPos[1],soundPos[2],soundPos[3]), 'Loading')
  local clusterId=TppDefine.CLUSTER_DEFINE[interiorInfo.clusterName]
  TppMission.Reload{
    missionPackLabelName="AfterDemo",
    clusterId=clusterId,
    OnEndFadeOut=function()
      svars.restartClusterId=clusterId
      TppSequence.ReserveNextSequence("Seq_Game_Setup")
      local pos,rotY=this.GetPositionOuterInterior(interiorInfo)
      TppPlayer.SetInitialPosition(pos,rotY)
      mtbs_cluster.LockCluster(interiorInfo.clusterName)
      --svars.isLeaveInterior=true--tex ala isLeaveBattleHanger, just to play sfx_m_hanger_door_close OnEndMissionPrepareSequence
    end,
  }
  return true
end--PushSwitchOnLeave
--CALLER: f30050_sequence msg = "PlayerSwitchStart"
function this.PlayerSwitchStart(playerGameObjectId, switchGameObjectId)
--tex just run camera
--tex exit switch
--  do
--    local _, gameObjectId = Gimmick.GetGameObjectId(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "gntn_swtc001_vrtn001_gim_n0000|srt_gntn_swtc001_vrtn001","/Assets/tpp/level/location/mtbs/block_large/mtbs_hanger_gimmick.fox2" )
--    if gameObjectId == switchGameObjectId then
--      this.SetCameraPushSwitch()
--      return
--    end
--  end
--  --tex enter switch
--  do
--    local gimmickName = "ly003_cl02_item0000|cl02pl0_uq_0020_gim_onlymb2|gntn_swtc001_vrtn001_gim_n0000|srt_gntn_swtc001_vrtn001"
--    local dataSetName = "/Assets/tpp/level/location/mtbs/block_area/ly00" ..tostring(vars.mbLayoutCode) .."/cl02/mtbs_ly00" ..tostring(vars.mbLayoutCode).. "_cl02_item.fox2"
--    local _, gameObjectId = Gimmick.GetGameObjectId(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, gimmickName , dataSetName)
--    if gameObjectId == switchGameObjectId then
--      this.SetCameraPushSwitch()
--      return
--    end
--  end
end--PlayerSwitchStart

--tex currently just unmodded copy of f30050_sequence SetCameraPushSwitch
--which in vanilla is used for outside and inside switches for both battlegear and paz room so probably dont even need to change this
function this.SetCameraPushSwitch()
  Player.RequestToPlayCameraNonAnimation {
    characterId = GameObject.GetGameObjectIdByIndex("TppPlayer2", 0),
    isFollowPos = true,
    isFollowRot = true,
    followTime = 4,
    followDelayTime = 0.1,
    candidateRots = { {6,10}, {6,-10} },
    skeletonNames = {"SKL_004_HEAD", "SKL_031_LLEG", "SKL_041_RLEG" },
    skeletonCenterOffsets = { Vector3( 0.0, 0.2, 0.0), Vector3( -0.15, 0.0, 0.0), Vector3( -0.15, 0.0, 0.0) },
    skeletonBoundings = { Vector3( 0.1, 0.125, 0.1), Vector3( 0.15, 0.1, 0.05), Vector3( 0.15, 0.1, 0.05) },
    offsetPos = Vector3(0.0,0.0,-3.0),
    focalLength = 28.0,
    aperture = 1.875,
    timeToSleep = 100,
    interpTimeAtStart = 0.5,
    fitOnCamera = false,
    timeToStartToFitCamera = 1,
    fitCameraInterpTime = 0.3,
    diffFocalLengthToReFitCamera = 16,
  }
end--SetCameraPushSwitch

--CALLER: PushSwitchOnLeave > TppMission.Reload > OnEndFadeOut
function this.GetPositionOuterInterior(interiorInfo)
  return mtbs_cluster.GetPosAndRotY(interiorInfo.clusterName,interiorInfo.plant,interiorInfo.outsideExitPos.pos,interiorInfo.outsideExitPos.rotY)
end--GetPositionOuterInterior

--tex DEBUGNOW need info on what switch or interior it is
--CALLER: f30050_sequence Seq_Demo_SetupCluster  --UNUSED
function this.WarpToInterior()
--  TppPlayer.Warp{ pos = {-11.600, -8.000, 8.511}, rotY = 180}
--  Player.RequestToSetCameraRotation{rotX =-10 , rotY = 200 }
end
--tex really PushSwitchToEnterInterior, but keeping naming similar to other uses
--CALLER: f30050_sequence Seq_Game_MainGame msg = "SwitchGimmick"
--REF PushSwitchOnEnterBattleHanger
function this.PushSwitchOnEnter(gameObjectId,locatorNameS32,name,switchFlag)
  InfCore.LogFlow"PushSwitchOnEnter"

  local interiorInfo=this.infoForSwitch[locatorNameS32]
  if interiorInfo==nil then
    InfCore.Log("ERROR: InfInterior.PushSwitchOnEnter infoForSwitch["..InfLookup.StrCode32ToString(locatorNameS32).." S32]==nil")
    return false
  end

  if locatorNameS32~=StrCode32(interiorInfo.enterSwitchLocatorName) then
    InfCore.Log("ERROR: InfInterior.PushSwitchOnEnter locatorName ~= "..tostring(interiorInfo.enterSwitchLocatorName))
    return false
  end

  --DEBUGNOW
  do
    local triggerDistance=9.0
    local pos,rotY=mtbs_cluster.GetPosAndRotY(interiorInfo.clusterName,interiorInfo.plant,interiorInfo.outsideExitPos.pos,0)--GOTCHA DEBUGNOW why rotY = 0 instead of interiorInfo.outsideExitPos.rotY???
    local distance=(pos[1]-vars.playerPosX)*(pos[1]-vars.playerPosX)+(pos[2]-vars.playerPosY)*(pos[2]-vars.playerPosY)+(pos[3]-vars.playerPosZ)*(pos[3]-vars.playerPosZ)
    if distance>triggerDistance then
      InfCore.Log("WARNING: player>triggerDistance")
      --DEBUGNOW return
    end
  end


  TppSound.HaltSceneBGM()--DEBUGNOW

  --f30050_sequence.SetEnableQuestUI(false)--DEBUGNOW

  --tex DEBUGNOW (interiorInfo optional) door open and sound
  --  local dataSetName = "/Assets/tpp/level/location/mtbs/block_area/ly00" ..tostring(vars.mbLayoutCode) .."/cl02/mtbs_ly00" ..tostring(vars.mbLayoutCode).. "_cl02_item.fox2"
  --  local dataName = "ly003_cl02_item0000|cl02pl0_uq_0020_gim_onlymb2|mtbs_door006_door002_ev_gim_n0000|srt_mtbs_door006_door002_ev"
  --  Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, dataName, dataSetName, false)
  --
  --  local soundPos = this.GetPositionOuterInteriorDoor()
  --  TppSoundDaemon.PostEvent3D( "sfx_m_hanger_door_open", Vector3(soundPos[1],soundPos[2],soundPos[3]), 'Loading')
  local clusterId=TppDefine.CLUSTER_DEFINE[interiorInfo.clusterName]-- was TppDefine.CLUSTER_DEFINE.Command, could be MotherBaseStage.GetCurrentCluster(), but keeping it consistant with PushSwitchOnLeave
  TppMission.Reload{
    missionPackLabelName="Interior",
    clusterId=clusterId,
    OnEndFadeOut=function()
      svars.restartClusterId=clusterId,
      TppSave.ReserveVarRestoreForContinue()
      this.SetPlayerInitialPositionInInterior(interiorInfo)
      TppSequence.ReserveNextSequence"Seq_Game_Interior"
    end,
  }
end--PushSwitchOnEnter
function this.SetPlayerInitialPositionInInterior(interiorInfo)
  TppPlayer.SetInitialPosition(interiorInfo.startPos.pos,interiorInfo.startPos.rotY)
  vars.playerCameraRotation[0]=interiorInfo.startCamera.rotX or 0
  vars.playerCameraRotation[1]=interiorInfo.startCamera.rotY or 0
end--SetPlayerInitialPositionInInterior

--DEBUGNOW need interiorInfo
--CALLER: Seq_Game_Interior OnEnter
function this.SetupInterior()
  TppWeather.ForceRequestWeather(TppDefine.WEATHER.SUNNY,0)

  --DEBUGNOW
--    local playerPos = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
--    local soundPos = playerPos + Quat.RotationY( vars.playerRotY ):Rotate( Vector3(0.794681, 0, 0.831533) )
--    TppSoundDaemon.PostEvent3D( "sfx_m_hanger_door_close", soundPos, 'Loading')
  --DEBUGNOW TppDataUtility.SetVector4EffectFromId("BattleHangerDoorLightOnLeave", "Color", 0.0, 1.0, 0.5, 0.5 )--DEBUGNOW
  --DEBUGNOW
  --  TppUiStatusManager.SetStatus( "EquipHud" ,"INVALID")
  --  TppUiStatusManager.SetStatus( "EquipPanel","INVALID")
  --  TppUI.OverrideFadeInGameStatus{
  --    EquipHud = false,
  --    EquipPanel = false,
  --  }
  --  f30050_sequence.SetEnableQuestUI(false)--DEBUGNOW
  
     --DEBUGNOW
     --if interiorInfo.locationLang then
    --TppUiCommand.RegistInfoTypingText("lang",5,interiorInfo.locationLang)--DEBUGNOW
    --TppUiCommand.ShowInfoTypingText() 
    --end

    --this.SetPlayerInitialPositionInInterior(interiorInfo)--tex DEBUGNOW need info on what interior
    svars.restartClusterId=MotherBaseStage.GetCurrentCluster()   

    TppUI.FadeIn(TppUI.FADE_SPEED.FADE_NORMALSPEED,"OnEnterInterior")
    TppMain.EnableAllGameStatus()
    this.SetupPadMaskInInterior()
end--SetupInterior
--Seq_Game_Interior OnEnter
--DEBUGNOW unused
function this.SetupPadMaskInInterior()
--  Player.SetPadMask{
--    settingName = "Interior",
--    except = false,
--    buttons = PlayerPad.MB_DEVICE
--    + PlayerPad.HOLD
--    + PlayerPad.RELOAD
--  }
end--SetupPadMaskInInterior
--CALLER: Seq_Game_Interior OnLeave
--terrible name i know
function this.UnSetupInterior()
--DEBUGNOW undoes SetupInterior
    TppWeather.CancelForceRequestWeather()

    --DEBUGNOW  Player.ResetPadMask{settingName = "Interior"}
    
    --DEBUGNOW  TppUiStatusManager.UnsetStatus( "EquipHud" ,"INVALID")
    --DEBUGNOW  TppUiStatusManager.UnsetStatus( "EquipPanel","INVALID")
    --DEBUGNOW   TppUI.UnsetOverrideFadeInGameStatus()
    --DEBUGNOW   this.SetEnableQuestUI(true)
end--UnSetupInterior

return this
