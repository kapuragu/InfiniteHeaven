-- DOBUILD: 1
-- ORIGINALQAR: chunk3
-- PACKPATH: \Assets\tpp\pack\mission2\free\f30250\f30250.fpkd
-- f30250_sequence.lua
local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local IsTypeFunc = Tpp.IsTypeFunc
local IsTypeTable = Tpp.IsTypeTable
local IsTypeString = Tpp.IsTypeString
local GetGameObjectId = GameObject.GetGameObjectId
local NULL_ID = GameObject.NULL_ID

local sequences = {}

local VOLGIN_DEMO_GROUP = {
  "hos_volgin_0000",
}

this.NO_MISSION_TELOP_ON_START_HELICOPTER = true

this.missionStartPosition = {
  helicopterRouteList = {},
  IsUseRoute = function()
    if this.isRecoverVolginDemoPlay() then
      return false
    else
      return true
    end
  end
}

function this.OnLoad()
  Fox.Log("#### OnLoad ####")

  TppSequence.RegisterSequences{
    "Seq_Demo_RecoverVolgin",
    "Seq_Game_MainGame",
    "Seq_Game_Escape",
    nil
  }
  TppSequence.RegisterSequenceTable(sequences)
end

this.saveVarsList = {
  isAllEnemyEnable	= false,
  isAllHostageEnable	= false,
}

this.checkPointList = {
  nil
}

function this.MissionPrepare()
  local missionName = TppMission.GetMissionName()
  Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

  local systemCallbackTable ={
    OnEstablishMissionClear			= TppMission.MissionGameEnd,
    OnDisappearGameEndAnnounceLog	= TppMission.MissionFinalize,
    nil
  }

  TppMission.RegisterMissionSystemCallback(systemCallbackTable)
end

this.OnEndMissionPrepareSequence = function ()
  this.UnsetEmergencyAsset()
  if --[[ Ivars.parasite_enableEventFREE:Is(0) and ]] Ivars.mbEnableLethalActions:Is(0) then--tex bypass DEBUGNOW change to MB_ALL
    TppUiStatusManager.SetStatus(	"EquipHudAll", "ALL_KILL_NOUSE" )
  end
end

function this.OnRestoreSVars()
  local missionName = TppMission.GetMissionName()
  Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
  if --[[ Ivars.parasite_enableEventFREE:Is(1) or ]] Ivars.mbEnableLethalActions:Is(1) then--tex> DEBUGNOW change to MB_ALL
    vars.playerDisableActionFlag = PlayerDisableAction.NONE
  else--<
    vars.playerDisableActionFlag = PlayerDisableAction.CQC_KNIFE_KILL + PlayerDisableAction.KILLING_WEAPON
  end

  mvars.parasiteFogCount		= 0
  mvars.parasiteCamoflaCount	= 0
  mvars.parasiteCuringCount	= 0

  mvars.isSetEnemy			= false
  mvars.damageEnemyId			= 0

  mvars.isPlayVolginDemo		= false

  this.SetEmblem()
end

function this.SetEmblem()
  local nShowflag = 0
  if TppUiCommand.HasEmblemTexture( "front7" ) then
    nShowflag = 1
  else
    nShowflag = 0
  end
  TppCollection.RepopCountOperation( "SetAt", "col_develop_MTBS_30250_0000", nShowflag )
end

function this.AcceptMission( missionId )
  local grade = TppLocation.GetMbStageClusterGrade( TppDefine.CLUSTER_DEFINE.Develop + 1 )
  local s10115_heliRouteTable = {
    [1] = { "ly003_cl02_10115_heli0000|cl02pl0_mb_fndt_plnt_heli_10115|rt_apr", Vector3(878.28747558594,-3.498596906662,323.64611816406) },
    [2] = { "ly003_cl02_10115_heli0000|cl02pl1_mb_fndt_plnt_heli_10115|rt_apr", Vector3(974.13403320313,-3.498596906662,326.39437866211) },
    [3] = { "ly003_cl02_10115_heli0000|cl02pl2_mb_fndt_plnt_heli_10115|rt_apr", Vector3(1043.8511962891,-3.498596906662,260.56399536133) },
    [4] = { "ly003_cl02_10115_heli0000|cl02pl3_mb_fndt_plnt_heli_10115|rt_apr", Vector3(1191.4196777344,-3.498596906662,259.04104614258) },
  }

  TppMission.AcceptMissionOnMBFreeMission( missionId, grade, s10115_heliRouteTable )
end

function this.Messages()
  return
    StrCode32Table {
      GameObject = {
        {
          msg = "HeliDoorClosed", sender = "SupportHeli",
          func = function ()
            Fox.Log("Mission clear : on Heli")

            this.ReserveMissionClear()
          end
        },
        --tex> added, kill staff game over support
        {
          msg = "Dead",
          func = function(gameObjectId)
            if GameObject.GetTypeIndex(gameObjectId)==TppGameObject.GAME_OBJECT_TYPE_SOLDIER2 then
              if Ivars.mbNonStaff:Is(0) then
                TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.PLAYER_KILL_DD )
              end
            end
          end,
        },
        {
          msg = "Dying",
          func = function(gameObjectId)
            if GameObject.GetTypeIndex(gameObjectId)==TppGameObject.GAME_OBJECT_TYPE_SOLDIER2 then
              if Ivars.mbNonStaff:Is(0) then
                TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.PLAYER_KILL_DD )
              end
            end
          end,
        },
      --<
      },
      Terminal = {
        {
          msg = "MbDvcActSelectLandPointTaxi", func = this.OnSelectLandPointTaxi,
        },
      },
      nil
    }
end

function this.OnSelectLandPointTaxi(nextMissionId, routeName, layout, clusterId)
  Fox.Log("missionId: " ..tostring(nextMissionId)  .. " :routeName: " ..tostring(routeName) .. " :layout:" .. tostring(layout) .. " :clusterId: " .. tostring(clusterId) )
  this.ReserveMissionClear(nextMissionId, routeName, layout, clusterId )
  TppMission.SetIsStartFromHelispace()
  TppMission.ResetIsStartFromFreePlay()
end

function this.ReserveMissionClear(nextMissionId, nextHeliRoute, nextLayoutCode, nextClusterId )
  local missionClearType = TppDefine.MISSION_CLEAR_TYPE.HELI_TAX_MB_FREE_CLEAR
  if nextMissionId == nil then
    nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_HELI
    missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER
    nextLayoutCode = nil
    nextClusterId = nil
  end

  TppMission.ReserveMissionClear{
    missionClearType = missionClearType,
    nextMissionId = nextMissionId,
    nextHeliRoute = nextHeliRoute,
    nextLayoutCode = nextLayoutCode,
    nextClusterId = nextClusterId,
  }
end

sequences.Seq_Demo_RecoverVolgin = {
  OnEnter = function()
    if this.isRecoverVolginDemoPlay() then
      Fox.Log("######## Seq_Demo_RecoverVolgin.OnEnter ########")
      mvars.isPlayVolginDemo = true
      local startFunc = function()
      end
      local endFunc = function()
        TppSequence.SetNextSequence("Seq_Game_MainGame")
      end

      TppDemo.SpecifyIgnoreNpcDisable( VOLGIN_DEMO_GROUP )

      f30250_demo.PlayRecoverVolgin( startFunc, endFunc )
    else
      TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "FadeInOnGameStart")
      TppMain.EnableGameStatus()
      TppSequence.SetNextSequence("Seq_Game_MainGame")
    end
    InfQuest.qst_volginQuestDone=false--tex tent_q99040 repop f30250 demo play fix reset
  end,

  OnLeave = function()
    if mvars.isPlayVolginDemo then
      TppQuest.ClearWithSave( TppDefine.QUEST_CLEAR_TYPE.CLEAR, "tent_q99040" )
    end
  end,
}

sequences.Seq_Game_MainGame = {
  Messages = function( self )
    return
      StrCode32Table {
        Terminal = {
          {
            msg = "MbDvcActAcceptMissionList", func = this.AcceptMission,
          },
        },
      }
  end,

  OnEnter = function()

    TppUiStatusManager.UnsetStatus( "MbMap", "BLOCK_TAXI_CHANGE_LOCATION" )
  end,

  OnLeave = function ()
  end,
}

sequences.Seq_Game_Escape = {

    OnEnter = function()
    end,
}

function this.UnsetEmergencyAsset()
  local assetFlag = false
  local gimmickFlag = true

  local IDEN_ASSET_ID = "uq_0020_demo_hide_AssetIdentifier"
  local IDEN_ASSET_KEY = {"emergency_obj"}

  TppDataUtility.SetVisibleDataFromIdentifier( IDEN_ASSET_ID, "emergency_obj" , assetFlag )
  TppDataUtility.SetVisibleDataFromIdentifier( IDEN_ASSET_ID, "close_door" , not assetFlag )

  if gvars.qst_volginQuestCleared then
    TppDataUtility.SetVisibleDataFromIdentifier( IDEN_ASSET_ID, "inside_cage" , not assetFlag )
  end

  TppDataUtility.VisibleMeshFromIdentifier(IDEN_ASSET_ID,"floor","MESH_usually_IV")
  TppDataUtility.InvisibleMeshFromIdentifier(IDEN_ASSET_ID,"floor","MESH_emergency")

  local IDEN_PATH_ID 	= "uq07_path_Identifier"
  local IDEN_PATH_KEY_TABLE	= {
    "GeoxPath20003",	"GeoxPath20004",	"GeoxPath20005",	"GeoxPath20006",
    "GeoxPath20007",	"GeoxPath20008",	"GeoxPath20009",	"GeoxPath20010",
    "GeoxPath20011",	"GeoxPath20012",	"GeoxPath20013",	"GeoxPath20014",
    "GeoxPath20015",	"GeoxPath20016",	"GeoxPath20017",	"GeoxPath20018",
    "GeoxPath20019",	"GeoxPath20022",
    "GeoxPathWall0000",	"GeoxPathWall0001",
    "pathWall_0000",	"pathWall_0008",	"pathWall_0012",
    "pathBehind_0013",	"pathBehind_0014",	"pathBehind_0015",	"pathBehind_0024",
    "pathBehind_0064",	"pathStepOn_0012",	"pathElude_0007_after",
    "pathBehind_0016_after0000",	"pathBehind_0016_after0001",
  }
  for i,key in pairs(IDEN_PATH_KEY_TABLE)do
    TppDataUtility.SetEnableDataFromIdentifier( IDEN_PATH_ID, key, assetFlag, true)
  end

  TppDataUtility.SetVisibleDataFromIdentifier( "uq07_item_Identifier", "off0000", assetFlag, true)
  TppDataUtility.SetVisibleDataFromIdentifier( "uq07_item_Identifier", "off0001", assetFlag, true)
  TppDataUtility.SetVisibleDataFromIdentifier( "uq07_item_Identifier", "off0002", assetFlag, true)

  local type = -1
  local layout = MotherBaseStage.GetCurrentLayout()
  local GIMMICK_PATH = string.format("/Assets/tpp/level/location/mtbs/block_area/ly%03d/cl07/mtbs_ly%03d_cl07_item.fox2", layout, layout)
  local GIMMICK_NAME_TABLE = {
    "ly003_cl07_item0000|cl07pl0_uq_0070_gimmick2|mtbs_tent001_gim_n0001|srt_mtbs_tent001",
    "ly003_cl07_item0000|cl07pl0_uq_0070_gimmick2|mafr_tent002_vrtn003_gim_n0001|srt_mafr_tent002_vrtn003",
    "ly003_cl07_item0000|cl07pl0_uq_0070_light2|afgh_lght007_vrtn002_gim_n0001|srt_afgh_lght007_vrtn002",
    "ly003_cl07_item0000|cl07pl0_uq_0070_light2|mtbs_lght007_emit001_gim_n0001|srt_mtbs_lght007_emit001",
    "ly003_cl07_item0000|cl07pl0_uq_0070_light2|mtbs_lght007_emit001_gim_n0002|srt_mtbs_lght007_emit001",
  }
  for i, keyName in pairs(GIMMICK_NAME_TABLE)do
    Gimmick.InvisibleGimmick( type, keyName, GIMMICK_PATH, gimmickFlag)
  end
end

function this.isRecoverVolginDemoPlay()
  --tex PATCHUP repopped tent_q99040 fix>
  --InfCore.Log("isRecoverVolginDemoPlay InfQuest.qst_volginQuestDone:"..tostring(InfQuest.qst_volginQuestDone))
  --qst_volginQuestDone added by PATCHUP in InfQuest.OnAllocateQuestPatchup > PlayRecoverVolgin  
  if gvars.qst_volginQuestCleared and TppQuest.IsCleard("tent_q99040") and InfQuest.qst_volginQuestDone then
    return true
  end--<
  
  if gvars.qst_volginQuestCleared and TppQuest.IsCleard("tent_q99040") == false then
    return true
  else
    return false
  end
end

return this
