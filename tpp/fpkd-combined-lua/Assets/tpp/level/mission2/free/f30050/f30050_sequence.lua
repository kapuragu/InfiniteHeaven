-- DOBUILD: 1
-- ORIGINALQAR: chunk3
-- PACKPATH: \Assets\tpp\pack\mission2\free\f30050\f30050.fpkd
--tex TODO: also in: 
--\Assets\tpp\pack\mission2\free\f30050\f30051.fpkd -- isUseMBDemoStage/missionPackLabelName"DemoStage". not sure i want to mod this (even though good practice is to have all files of same name identical)
--\Assets\tpp\pack\mission2\free\f30050\f30050_hanger_btg00.fpkd to f30050_hanger_btg05.fpkd - battlegear hangar, might be better to patch in changes
--f30050_sequence.lua
InfCore.LogFlow"f30050_sequence Top"
--DEBUGNOW
if false then--tex>
  local fileName="f30050_sequence_dev.lua"
  return InfCore.PCall(function()return InfCore.LoadSimpleModule(InfCore.paths.dev,fileName)end)
end--<

local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local GetGameObjectId = GameObject.GetGameObjectId
local SendCommand = GameObject.SendCommand
local NULL_ID = GameObject.NULL_ID
local SCRIPT_BLOCK_NAME = "demo_block"

local MAX_STAFF_NUM_ON_CLUSTER = 18
--tex SYNC InfMainTpp
if Ivars.mbAdditionalSoldiers:Is()>0 then--tex>
  MAX_STAFF_NUM_ON_CLUSTER = 36
end--<

local sequences = {}

local PlayerDisableActionFlagInPazRoom = PlayerDisableAction.CQC + PlayerDisableAction.RUN + PlayerDisableAction.KILLING_WEAPON + PlayerDisableAction.FULTON + PlayerDisableAction.CARRY + PlayerDisableAction.OPEN_CALL_MENU + PlayerDisableAction.OPEN_EQUIP_MENU
local PlayerDisableActionFlagMtbsDefault = PlayerDisableAction.CQC_KNIFE_KILL + PlayerDisableAction.KILLING_WEAPON

local STAGE_PACK_INDEX = {
  NORMAL = 0,
  DEMO = 1,
  BATTLE_HANGER = 2,
}


local SWITCH_DISABLE = 0
local SWITCH_ENABLE = 1

local QUEST_NAME_LIQUID_CHALLENGE = "mtbs_q99050"
local QUEST_NAME_SHOOTING_GAME = "mtbs_q42010"
local QUEST_NAME_SHOOTING_GAME_MEDICAL = "mtbs_q42050"
local QUEST_NAME_VISIT_QUIET = "mtbs_q99011"
local GAMEOBJECT_LIQUID = "ly003_cl00_npc0000|cl00pl0_uq_0000_npc2|TppLiquid2GameObjectLocator"

local PAZ_SLEEP_TIME = 6*60*60
local PAZ_PHASE_ID_NONE = 0
local PAZ_PHASE_ID_FINISHED = 9
local PAZ_PACK_NAME_LIST = {
  "PazPhantomPain1",
  "PazPhantomPain2",
  "PazPhantomPain3",
  "PazPhantomPain4",
  "PazPhantomPain4_jp",
}
local PAZ_PHOTO_DATA_BASE_ID_LIST = {
  TppMotherBaseManagementConst.PHOTO_1006,
  TppMotherBaseManagementConst.PHOTO_1007,
  TppMotherBaseManagementConst.PHOTO_1009,
  TppMotherBaseManagementConst.PHOTO_1000,
  TppMotherBaseManagementConst.PHOTO_1008,
  TppMotherBaseManagementConst.PHOTO_1002,
  TppMotherBaseManagementConst.PHOTO_1003,
  TppMotherBaseManagementConst.PHOTO_1005,
  TppMotherBaseManagementConst.PHOTO_1004,
  TppMotherBaseManagementConst.PHOTO_1001,
  TppMotherBaseManagementConst.PHOTO_1010,
}

local PAZ_CASSETTE_LIST = {
  "tp_m_99060_01",
  "tp_m_99060_02",
  "tp_m_99060_03",
  "tp_m_99060_04",
  "tp_m_99060_05",
  "tp_sp_01_03",
}

local QUIET_RADIO_TELOP_LANG_LIST = {
  "mtv_Heavens_Divide",
  "mtv_Koi_no_Yokushiryoku",
  "mtv_Gloria",
  "mtv_Kids_In_America",
  "mtv_Rebel_Yell",
  "mtv_The_Final_Countdown",
  "mtv_Nitrogen",
  "mtv_Take_On_Me",
  "mtv_Ride_A_White_Horse",
  "mtv_Maneater",
  "mtv_A_Phantom_Pain",
  "mtv_Only_Time_Will_Tell",
  "mtv_Behind_the_Drapery",
  "mtv_Love_Will_Tear_Us_Apart",
  "mtv_All_the_Sun_Touches",
  "mtv_TRUE",
  "mtv_Take_The_DW",
  "mtv_Friday_Im_In_Love",
  "mtv_Midnight_Mirage",
  "mtv_Dancing_With_Tears_In_My_Eyes",
  "mtv_The_Tangerine",
  "mtv_Planet_Scape",
  "mtv_How_'bout_them_zombies_ey",
  "mtv_Snake_Eater",
  "mtv_204863",
  "mtv_You_Spin_Me_Round",
  "mtv_Quiet_Life",
  "mtv_She_Blinded_Me_With_Science",
  "mtv_Dormant_Stream",
  "mtv_Too_Shy",
}

local FOB_GOAL_DOOR_LIST = {
  [TppDefine.CLUSTER_DEFINE.Command] =
  {
    "ly003_cl00_item0000|cl00pl0_uq_0000_gimmick2|mtbs_door006_door002_gim_n0000|srt_mtbs_door006_door002"
  },
  [TppDefine.CLUSTER_DEFINE.Combat] =
  {
    "ly003_cl01_item0000|cl01pl0_uq_0010_gimmick0002|mtbs_door006_door002_gim_n0000|srt_mtbs_door006_door002"
  },
  [TppDefine.CLUSTER_DEFINE.Develop] =
  {
    "ly003_cl02_item0000|cl02pl0_uq_0020_gimmick2|mtbs_door006_door003_gim_n0000|srt_mtbs_door006_door003",
  },
  [TppDefine.CLUSTER_DEFINE.Support] =
  {
    "ly003_cl03_item0000|cl03pl0_uq_0030_gimmick2|mtbs_door006_door004_gim_n0001|srt_mtbs_door006_door004",
  },
  [TppDefine.CLUSTER_DEFINE.Medical] =
  {
    "ly003_cl04_item0000|cl04pl0_uq_0040_gimmick2|mtbs_door006_door001_gim_n0000|srt_mtbs_door006_door001",
  },
  [TppDefine.CLUSTER_DEFINE.Spy] =
  {
    "ly003_cl05_item0000|cl05pl0_uq_0050_gimmick2|mtbs_door006_door004_gim_n0000|srt_mtbs_door006_door004",
  },
  [TppDefine.CLUSTER_DEFINE.BaseDev] =
  {
    "ly003_cl06_item0000|cl06pl0_uq_0060_gimmick2|mtbs_door006_door002_gim_n0000|srt_mtbs_door006_door002",
  },
}

local DISABLE_INTEL_RADIO_LIST = {
  { type_eleGenerator 	= 	"Invalid"},
  { type_switchboard	=	"Invalid"},
}





this.NO_RESULT = true

this.DISABLE_BUDDY_TYPE = {
  BuddyType.HORSE,
  BuddyType.WALKER_GEAR,
  BuddyType.BATTLE_GEAR,
}

this.MAX_PICKABLE_LOCATOR_COUNT = 64
this.MAX_PLACED_LOCATOR_COUNT = 128


this.SKIP_ADD_STAFF_TO_TEMP_BUFFER = true
this.SKIP_ADD_RESOURCE_TO_TEMP_BUFFER = true

local LANDING_ZONE_USE_SORTIE_DEMO = "ly003_cl00_30050_heli0000|cl00pl0_mb_fndt_plnt_heli_30050|lz_plnt"
local DROP_ROUTE_USE_SORTIE_DEMO = "ly003_cl00_30050_heli0000|cl00pl0_mb_fndt_plnt_heli_30050|rt_apr"


this.CLST_PARAM = {
  {
    CP_NAME = "ly003" .. "_cl00_npc0000|" .. "cl00pl0_uq_0000_npc2|mtbs_command_cp",
    GT_NAME = "",
    CBTSET_NAME = "",
    LANDING_ZONE = {
      {
        LANDING_ZONE_USE_SORTIE_DEMO,
      },
      {
        "ly003_cl00_30050_heli0000|cl00pl1_mb_fndt_plnt_heli_30050|lz_plnt",
        "ly003_cl00_30050_heli0000|cl00pl0_uq_0000_heli_30050|lz_cl00",
      },
      {
        "ly003_cl00_30050_heli0000|cl00pl2_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl00_30050_heli0000|cl00pl3_mb_fndt_plnt_heli_30050|lz_plnt",
      },
    },
  },
  {
    CP_NAME = "ly003" .. "_cl01_npc0000|" .. "cl01pl0_uq_0010_npc2|mtbs_combat_cp",
    GT_NAME = "",
    CBTSET_NAME = "",
    LANDING_ZONE = {
      {
        "ly003_cl01_30050_heli0000|cl01pl0_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl01_30050_heli0000|cl01pl1_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl01_30050_heli0000|cl01pl2_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl01_30050_heli0000|cl01pl3_mb_fndt_plnt_heli_30050|lz_plnt",
      },
    },
  },
  {
    CP_NAME = "ly003" .. "_cl02_npc0000|" .. "cl02pl0_uq_0020_npc2|mtbs_develop_cp",
    GT_NAME = "",
    CBTSET_NAME = "",
    LANDING_ZONE = {
      {
        "ly003_cl02_30050_heli0000|cl02pl0_mb_fndt_plnt_heli_30050|lz_plnt",
        "ly003_cl02_30050_heli0000|cl02pl0_uq_0020_heli_30050|lz_cl02",
      },
      {
        "ly003_cl02_30050_heli0000|cl02pl1_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl02_30050_heli0000|cl02pl2_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl02_30050_heli0000|cl02pl3_mb_fndt_plnt_heli_30050|lz_plnt",
      },
    },
  },
  {
    CP_NAME = "ly003" .. "_cl03_npc0000|" .. "cl03pl0_uq_0030_npc2|mtbs_support_cp",
    GT_NAME = "",
    CBTSET_NAME = "",
    LANDING_ZONE = {
      {
        "ly003_cl03_30050_heli0000|cl03pl0_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl03_30050_heli0000|cl03pl1_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl03_30050_heli0000|cl03pl2_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl03_30050_heli0000|cl03pl3_mb_fndt_plnt_heli_30050|lz_plnt",
      },
    },
  },
  {
    CP_NAME = "ly003" .. "_cl04_npc0000|" .. "cl04pl0_uq_0040_npc2|mtbs_medic_cp",
    GT_NAME = "",
    CBTSET_NAME = "",
    LANDING_ZONE = {
      {
        "ly003_cl04_30050_heli0000|cl04pl0_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl04_30050_heli0000|cl04pl1_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl04_30050_heli0000|cl04pl2_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl04_30050_heli0000|cl04pl3_mb_fndt_plnt_heli_30050|lz_plnt",
      },
    },
  },
  {
    CP_NAME = "ly003" .. "_cl05_npc0000|" .. "cl05pl0_uq_0050_npc2|mtbs_intel_cp",
    GT_NAME = "",
    CBTSET_NAME = "",
    LANDING_ZONE = {
      {
        "ly003_cl05_30050_heli0000|cl05pl0_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl05_30050_heli0000|cl05pl1_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl05_30050_heli0000|cl05pl2_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl05_30050_heli0000|cl05pl3_mb_fndt_plnt_heli_30050|lz_plnt",
      },
    },
  },
  {
    CP_NAME = "ly003" .. "_cl06_npc0000|" .. "cl06pl0_uq_0060_npc2|mtbs_basedev_cp",
    GT_NAME = "",
    CBTSET_NAME = "",
    LANDING_ZONE = {
      {
        "ly003_cl06_30050_heli0000|cl06pl0_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl06_30050_heli0000|cl06pl1_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl06_30050_heli0000|cl06pl2_mb_fndt_plnt_heli_30050|lz_plnt",
      },
      {
        "ly003_cl06_30050_heli0000|cl06pl3_mb_fndt_plnt_heli_30050|lz_plnt",
      },
    },
  },
}

function this.OnUpdate()
  if mvars.f30050_needLoadBuddyController then
    local blockId = ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME)
    local state = ScriptBlock.GetScriptBlockState(blockId)
    if state >= ScriptBlock.SCRIPT_BLOCK_STATE_INACTIVE then
      mvars.f30050_needLoadBuddyController = false
      TppBuddy2BlockController.Load()
      mvars.f30050_needSetupBuddyAfterActivate = true
    end
  end

  if mvars.f30050_needSetupBuddyAfterActivate then
    if TppBuddy2BlockController.IsBlockActive() then
      this.SetDDogArea()
      mvars.f30050_needSetupBuddyAfterActivate = false
    end
  end
end
this.NO_MISSION_TELOP_ON_START_HELICOPTER = true

this.missionStartPosition = {
  helicopterRouteList = {},
  IsUseRoute = function()


    if gvars.heli_missionStartRoute == 0 then
      return false
    end

    local isStartFromHelispace = TppMission.IsStartFromHelispace()

    local demoName = mvars.f30050_demoName
    if not demoName then
      demoName = TppDemo.GetMBDemoName()
    end


    if demoName and this.IsRideOnHeliDemo( demoName )
      and gvars.heli_missionStartRoute == StrCode32(DROP_ROUTE_USE_SORTIE_DEMO) then
      Fox.Log("Ride On Heli Demo:"..tostring(demoName) ..". :HeliStart")
      return true
    end

    local isNotPlayOpeningDemo	= true
    if demoName then
      isNotPlayOpeningDemo = this.IsRideOnHeliDemo(demoName)
    end
    Fox.Log("missionStartPosition.IsUseRoute: isStartFromHelispace:" ..tostring(isStartFromHelispace) .. " :notPlayDemo:".. tostring(isNotPlayOpeningDemo) )
    return isStartFromHelispace and isNotPlayOpeningDemo
  end
}

function this.IsRideOnHeliDemo( demoName )
  local isRideOnHeli = TppDefine.MB_FREEPLAY_RIDEONHELI_DEMO_DEFINE[demoName]
  if isRideOnHeli then
    return true
  else
    return false
  end
end

function this.IsNeedLoadRideOnHeliDemo( clusterId )
  if not this.IsRideOnHeliDemo( mvars.f30050_demoName ) then
    return false
  end
  local demoPlayClusterName = f30050_demo.GetDemoPlayCluster( mvars.f30050_demoName )
  return clusterId == TppDefine.CLUSTER_DEFINE[demoPlayClusterName]
end







function this.GetDebugDemoSequenceName( demoName )
  return "Seq_Demo_DEBUG_" .. demoName
end

function this.GetMemDumpDemoSequenceName( demoName )
  return "Seq_DEMO_MemDump_" .. demoName
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







function this.OnLoad()
  Fox.Log("#### OnLoad ####")

  local sequenceNameList = {

      "Seq_Demo_SetupCluster",
      "Seq_Demo_Opening",
      "Seq_Demo_SetupScriptBlock",
      "Seq_Demo_End",

      "Seq_Game_HeliStart",


      "Seq_Game_Setup",
      "Seq_Game_MainGame",


      "Seq_Game_PazWaitMainGameFinish",
      "Seq_Game_PazDemoBlockUnload",
      "Seq_Game_PazDemoBlockLoad",
      "Seq_Demo_PazPlayDemo",
      "Seq_Demo_PazRoomOnEnter",
      "Seq_Game_PazRoom",
      "Seq_Game_PazRoomOnLeave",

      "Seq_Game_PazAvatarLoad",



      "Seq_Game_BattleHanger",
      "Seq_Demo_BattleHanger",



      "Seq_Demo_Ending_Epigraph",
      "Seq_Demo_Ending_OnlineUser",
      "Seq_Demo_Nuclear_Abolition_Telop",


      "Seq_Demo_RewardAfterDemo",


      "Seq_Demo_WaitBuddyLoaded",


      "Seq_Demo_End_Warp_Cluster",

      "Seq_Demo_End_Wait_Player_Warp",


      "Seq_Demo_Wait_FadeOut_Sortie",
      "Seq_Demo_Wait_Loading_Sortie",
      "Seq_Demo_Play_Sortie",
  }




  if not TppGameSequence.IsMaster() then
    for demoName, demoId in pairs(f30050_demo.demoList) do
      local debugDemoSequenceName = this.GetDebugDemoSequenceName( demoName )
      Fox.Log("Add debug demo seqeunce = ".. tostring(debugDemoSequenceName) )
      table.insert( sequenceNameList, debugDemoSequenceName )
      sequences[debugDemoSequenceName] = {
        OnEnter = function()
          TppSequence.SetNextSequence("Seq_Demo_SetupCluster")
        end,
      }
    end
    do
      local sequenceName = this.GetDebugDemoSequenceName( "NoDemo" )
      table.insert( sequenceNameList, sequenceName )
      sequences[sequenceName] = {
        OnEnter = function()
          TppDemo.SetNextMBDemo()
          TppSequence.SetNextSequence("Seq_Demo_SetupCluster")
        end,
      }
    end
    do
      local sequenceName = this.GetDebugDemoSequenceName( "RideOnHeliDemo" )
      table.insert( sequenceNameList, sequenceName )
      sequences[sequenceName] = {
        OnEnter = function()
          svars.isArrivedLandingzoneHeli = true
          if entry_free_mission then
            if entry_free_mission.f30050_WarpToHelicopter then
              entry_free_mission.f30050_WarpToHelicopter()
            end
            if entry_free_mission.f30050_GetDemoNameRideOnHeli then
              mvars.f30050_demoName = entry_free_mission.f30050_GetDemoNameRideOnHeli()
            end
          end
        end,
        OnUpdate = function()
          local blockId = ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME)
          if blockId == ScriptBlock.SCRIPT_BLOCK_ID_INVALID then

            Fox.Error(SCRIPT_BLOCK_NAME .. " is not found")
            TppSequence.SetNextSequence("Seq_Game_MainGame")
            return
          end
          local state = ScriptBlock.GetScriptBlockState(blockId)
          local waitState = ScriptBlock.SCRIPT_BLOCK_STATE_INACTIVE
          if state >= waitState then
            TppSequence.SetNextSequence("Seq_Game_MainGame")
          end
        end,
      }
    end
    do
      local sequenceName = "Seq_DEBUG_GimmickCheck"
      table.insert( sequenceNameList, sequenceName )
      sequences[sequenceName] = {
        OnEnter = function()
          TppDemo.SetNextMBDemo()

          TppUiStatusManager.UnsetStatus( "EquipHudAll", "ALL_KILL_NOUSE" )
          vars.playerDisableActionFlag = PlayerDisableAction.NONE
          TppSequence.SetNextSequence("Seq_Demo_SetupCluster")
        end,
      }
    end
    do
      local sequenceName = "Seq_DEBUG_BattleGearHanger"
      table.insert( sequenceNameList, sequenceName )
      sequences[sequenceName] = {
        OnEnter = function()
          TppDemo.SetNextMBDemo()
          TppSequence.SetNextSequence("Seq_Demo_BattleHanger")
        end,
      }
    end
    do
      local sequenceName = "Seq_DEBUG_PazPlayDemo"
      table.insert( sequenceNameList, sequenceName )
      sequences[sequenceName] = {
        OnEnter = function()
          TppSequence.SetNextSequence("Seq_Game_Setup")
        end,

        Messages = function( self )
          return
            StrCode32Table {
              Demo = {
                {
                  msg = "DisablePhantomRoom",
                  func = function()
                    this.EnablePazRoom( false )

                    TppDataUtility.SetVisibleEffectFromGroupId("PazRoomFx",false, false)
                  end,
                  option = { isExecDemoPlaying = true },
                },
              },
            }
        end,
        OnLeave = function()
          TppMission.UpdateCheckPoint{
            checkPoint = "CHK_PazRoom",
            atCurrentPosition = true,
          }
        end,
      }
    end
    do
      for demoName, demoId in pairs(f30050_demo.demoList) do
        local debugDemoSequenceName = this.GetMemDumpDemoSequenceName( demoName )
        Fox.Log("Add debug demo seqeunce = ".. tostring(debugDemoSequenceName) )
        table.insert( sequenceNameList, debugDemoSequenceName )
        sequences[debugDemoSequenceName] = {
          OnEnter = function()
            mvars.f30050_finishSetupScriptBlock = true
            this.RegisterFovaFpk(MotherBaseStage.GetCurrentCluster())
            f30050_demo.UpdatePackList( demoName )
            TppScriptBlock.LoadDemoBlock( demoName, true )
            TppSequence.SetNextSequence("Seq_Game_MainGame")

            TppDataUtility.SetVisibleDataFromIdentifier( "uq_0040_paz_room_AssetIdentifier", "paz_room_phantom", true, false)
            TppDataUtility.SetVisibleDataFromIdentifier( "uq_0040_paz_room_AssetIdentifier", "paz_room_real", false, false)
            TppDataUtility.SetVisibleDataFromIdentifier( "uq_0040_paz_room_bed_AssetIdentifier", "paz_room_bed", true, false )
          end,
          OnUpdate = function()
            local blockId = ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME)
            if blockId == ScriptBlock.SCRIPT_BLOCK_ID_INVALID then
              TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "OnEndGameStartFadeIn" )
              return
            end
            local state = ScriptBlock.GetScriptBlockState(blockId)
            local waitState = ScriptBlock.SCRIPT_BLOCK_STATE_INACTIVE
            if TppDemo.GetMBDemoName() then
              waitState = ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE
            end
            if state >= waitState then
              TppSequence.SetNextSequence("Seq_Demo_Opening")
            end
          end,
          OnLeave = function()
            mtbs_enemy.OnActivateDemoBlock( )
          end,
        }
      end
    end
  end

  TppSequence.RegisterSequences(sequenceNameList)
  TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
  canReceivePicture				= true,
  isArrivedLandingzoneHeli		= false,
  isEnterTrapRideOnHeliDemo		= false,
  isPlayedFreeHeliRadio			= false,
  requestPlayAfterDemoRadio		= false,
  isRequestToDropCbox				= false,
  isVisibleBrokenHanger			= false,
  isLeaveBattleHanger				= false,
  requestPlayAfterDemoRadioIndex	= 0,
  isPazRoomStart					= false,
  isPlayedAfterDeathFactory		= false,
  restartClusterId				= 255,


  isCollect_Injury			= false,
  isCollect_YellowHood		= false,
  isCollect_Aflo				= false,
  isCollect_ShortAflo			= false,
  isCollect_BlackCoat			= false,


}


this.checkPointList = {
  "CHK_MainGame",
  "CHK_PazRoom",
  "CHK_BattleHanger",
  nil
}

this.baseList = {
  nil
}













function this.OnBuddyBlockLoad()
  if vars.initialPlayerFlag == 0 then
    StageBlockCurrentPositionSetter.SetEnable( true )
    StageBlockCurrentPositionSetter.SetPosition( 0, 0 )

    TppPlayer.SetInitialPosition( {9, 0.8, -42}, 0 )
    vars.playerCameraRotation[0] = 0
    vars.playerCameraRotation[1] = 0
    vars.mbClusterId = 0
  end
end




function this.MissionPrepare()
  if Ivars.mbEnableLethalActions:Is(1) then--tex>
    PlayerDisableActionFlagMtbsDefault = PlayerDisableAction.NONE
  end--<

  do
    local missionName = TppMission.GetMissionName()
    Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")
  end


  mvars.f30050_buddyTypeOnMissionStart = vars.buddyType


  mtbs_enemy.SetupClusterParam( this.CLST_PARAM )


  local demoName = TppDemo.GetMBDemoName()

  if this.NeedPlayQuietWishGoMission() then
    demoName = "QuietWishGoMission"
  end
  Fox.Log("demoName:OnMissionPrepare: " ..tostring(demoName) )
  if demoName then
    mvars.f30050_needReload = TppDemo.IsUseMBDemoStage(demoName)
    if mvars.f30050_needReload then

      f30050_demo.UpdatePackList( demoName )
      TppScriptBlock.PreloadRequestOnMissionStart{
        { demo_block = demoName },
      }
    else
      mvars.f30050_needDemoLoad = true
    end

    local demoTime = f30050_demo.GetDemoTime(demoName)
    if demoTime then
      TppClock.SaveMissionStartClock( demoTime )
    end
  end
  mvars.f30050_demoName = demoName



  local systemCallbackTable ={
    OnEstablishMissionClear = function( missionClearType )
      TppMission.MissionGameEnd()
    end,
    OnDisappearGameEndAnnounceLog = function()
      Player.SetPause()
      TppMission.ShowMissionReward()
    end,
    OnEndMissionReward = function()
      if TppSequence.GetCurrentSequenceName() == "Seq_Demo_RewardAfterDemo" then
        mvars.f30050_onEndMissionReward = true
        TppMission.ResetMissionClearState()
      else
        TppMission.MissionFinalize{ isNoFade = true }
      end
    end,
    OnGameOver = function()
      if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then
        TppMission.ShowGameOverMenu{ delayTime = 0.2 }
        if GameObject.GetGameObjectId( GAMEOBJECT_LIQUID ) == mvars.f30050_deadGameObjectId then
          TppUiCommand.SetGameOverType('TimeParadox')
        end
        return true
      end
    end,
    nil,
  }


  TppMission.RegisterMissionSystemCallback(systemCallbackTable)
end

function this.IsFemale( staffId )
  local faceId = TppMotherBaseManagement.StaffIdToFaceId{ staffId=staffId }
  local faceTypeList = TppSoldierFace.CheckFemale{ face={faceId  } }
  return faceTypeList and faceTypeList[1] == 1
end
--tex NMC mostly to set up mvars.f30050_staffIdList which is used in RegisterFovaFpk
--and do some other setup at the end of function.
function this.SetupStaffList()
  InfCore.LogFlow("SetupStaffList")--tex DEBUG
  --tex made local to module --OFF local MAX_STAFF_NUM_ON_CLUSTER = 18
  local staffList = {}
  math.randomseed(TppScriptVars.GetTotalPlayTime())

  for i = TppMotherBaseManagementConst.SECTION_COMBAT, TppMotherBaseManagementConst.SECTION_SECURITY do
    local tmpList = TppMotherBaseManagement.GetOutOnMotherBaseStaffs{sectionId=i}
    staffList[i] = {}
    while(#tmpList > 0)do
      local index = math.random(1,#tmpList)
      table.insert( staffList[i], tmpList[index] )
      table.remove( tmpList,index )
    end
  end

  if Ivars.mbPrioritizeFemale:Is"DISABLE" then--tex> clear staff list of female
    local newList={}
    for sectionId = TppMotherBaseManagementConst.SECTION_COMBAT, TppMotherBaseManagementConst.SECTION_SECURITY do
      newList[sectionId]={}
      for i,staffId in ipairs(staffList[sectionId])do
        if not this.IsFemale(staffId) then
          table.insert(newList[sectionId],staffId)
        end
      end
    end
    staffList=newList
  end
  --<
  mvars.f30050_staffIdList = {}

  --NMC command staff are pulled from each section
  local commandStaffList = {}
  for i = 1, MAX_STAFF_NUM_ON_CLUSTER do
    for j = TppMotherBaseManagementConst.SECTION_COMBAT, TppMotherBaseManagementConst.SECTION_SECURITY do
      local staffId = staffList[j][1]
      if staffId then        
        --tex just debugging to see if all prioity staff are accounted for>
        if InfMBStaff.IsPriorityStaff(staffId) then
          InfCore.Log("SetupStaffList command cluster found priority staff "..staffId)--tex DEBUG
        end--<
        table.insert( commandStaffList, staffId )
        table.remove( staffList[j], 1 )
      end
      if #commandStaffList >= MAX_STAFF_NUM_ON_CLUSTER then break end
    end
    if #commandStaffList >= MAX_STAFF_NUM_ON_CLUSTER then break end
  end
  mvars.f30050_staffIdList[TppDefine.CLUSTER_DEFINE.Command+1] = commandStaffList

  local _SetupStaffIdOnCluster = function(staffListOnCluster, clusterIndex)
    mvars.f30050_staffIdList[clusterIndex+1] = {}

    --tex priority staff>
    local numFemales=0
    local priorityStaffForCluster={}
    for i=#staffListOnCluster,1,-1 do
      local staffId=staffListOnCluster[i]
      if InfMBStaff.IsPriorityStaff(staffId) then
        table.remove(staffListOnCluster,i)
        table.insert(priorityStaffForCluster,staffId)
        InfCore.Log("SetupStaffList cluster "..clusterIndex.. " found priority staff "..staffId)--tex DEBUG
      end
    end

    for i,staffId in ipairs(priorityStaffForCluster)do
      table.insert(mvars.f30050_staffIdList[clusterIndex+1],staffId)

      if this.IsFemale(staffId) then
        numFemales=numFemales+1
      end

      if i==MAX_STAFF_NUM_ON_CLUSTER then
        break
      end
    end
    --<

    local minFemaleStaffOnCluster = 2--tex> game default=2
    if Ivars.mbPrioritizeFemale:Is"MAX" then
      minFemaleStaffOnCluster=MAX_STAFF_NUM_ON_CLUSTER
    elseif Ivars.mbPrioritizeFemale:Is"HALF" then
      minFemaleStaffOnCluster=math.ceil(MAX_STAFF_NUM_ON_CLUSTER/2)
    end--<
    --NMC: force select some females
    if not Ivars.mbPrioritizeFemale:Is"DISABLE" then--tex was do
      local staffNum = #staffListOnCluster
      local staffListIndex = 1
      for staffListIndex = 1, staffNum do
        local staffId = staffListOnCluster[staffListIndex]
        if staffId == nil then
          break
        end
        if this.IsFemale( staffId ) then
          table.insert( mvars.f30050_staffIdList[clusterIndex+1], staffId )
          table.remove( staffListOnCluster, staffListIndex )
          staffListIndex = staffListIndex - 1
          numFemales=numFemales+1--tex added
          if numFemales >= minFemaleStaffOnCluster or numFemales>=MAX_STAFF_NUM_ON_CLUSTER then--tex changed to account for priorityStaff, might be +1 female, but oh well
            --tex WAS if #mvars.f30050_staffIdList[clusterIndex+1] >= minFemaleStaffOnCluster then--tex was 2
            break
          end
        end
        staffListIndex = staffListIndex + 1
      end
    end

    do
      local staffNum = MAX_STAFF_NUM_ON_CLUSTER - #mvars.f30050_staffIdList[clusterIndex+1]
      for i = 1, staffNum do
        local staffId = staffListOnCluster[1]
        if staffId == nil then
          return
        end
        table.insert( mvars.f30050_staffIdList[clusterIndex+1], staffId )
        table.remove( staffListOnCluster, 1 )
      end
    end
  end

  _SetupStaffIdOnCluster( staffList[TppMotherBaseManagementConst.SECTION_COMBAT],TppDefine.CLUSTER_DEFINE.Combat )

  _SetupStaffIdOnCluster( staffList[TppMotherBaseManagementConst.SECTION_DEVELOP],TppDefine.CLUSTER_DEFINE.Develop )

  _SetupStaffIdOnCluster( staffList[TppMotherBaseManagementConst.SECTION_SUPPORT],TppDefine.CLUSTER_DEFINE.Support )

  _SetupStaffIdOnCluster( staffList[TppMotherBaseManagementConst.SECTION_MEDICAL],TppDefine.CLUSTER_DEFINE.Medical )

  _SetupStaffIdOnCluster( staffList[TppMotherBaseManagementConst.SECTION_SPY],TppDefine.CLUSTER_DEFINE.Spy )

  _SetupStaffIdOnCluster( staffList[TppMotherBaseManagementConst.SECTION_BASE_DEV],TppDefine.CLUSTER_DEFINE.BaseDev )



  if mvars.f30050_demoName then
    local uniqueTypeId = 1
    local clusterIdDemoPlay = mtbs_cluster.GetClusterId( f30050_demo.GetDemoPlayCluster( mvars.f30050_demoName ) )
    local demoSolNum = #f30050_demo.GetSoldierListInDemo( mvars.f30050_demoName )
    local addSolNum = demoSolNum - #mvars.f30050_staffIdList[clusterIdDemoPlay]
    local staffListOnDemoCluster = mvars.f30050_staffIdList[clusterIdDemoPlay]
    for i = 1,addSolNum do
      table.insert( staffListOnDemoCluster, TppMotherBaseManagement.GenerateStaffParameter{ staffType="Unique", uniqueTypeId=uniqueTypeId } )
      uniqueTypeId = uniqueTypeId + 1
    end

    local needMaleStaffNum = #f30050_demo.GetForceMaleSoldierList(mvars.f30050_demoName)
    do
      local tmpMaleStaffId = {}
      local tmpFemaleIndex = {}
      local tmpListIndex = {}
      for i, maleStaffId in ipairs( staffListOnDemoCluster ) do
        if needMaleStaffNum <= 0 then
          break
        end
        if not this.IsFemale( maleStaffId ) then
          for j = 1,i-1 do
            local femaleStaffId = staffListOnDemoCluster[j]
            if this.IsFemale( femaleStaffId ) then
              staffListOnDemoCluster[j] = maleStaffId
              staffListOnDemoCluster[i] = femaleStaffId
              break
            end
          end
          needMaleStaffNum = needMaleStaffNum - 1
        end
      end
    end

    for i = TppMotherBaseManagementConst.SECTION_COMBAT, TppMotherBaseManagementConst.SECTION_SECURITY do
      if needMaleStaffNum <= 0 then break end
      for _, maleStaffId in ipairs( staffList[i] ) do
        if needMaleStaffNum <= 0 then break end
        if not this.IsFemale( maleStaffId ) then

          if #staffListOnDemoCluster >= MAX_STAFF_NUM_ON_CLUSTER then
            for femaleStaffIndex, femaleStaffId in ipairs( staffListOnDemoCluster ) do
              if this.IsFemale( femaleStaffId ) then
                staffListOnDemoCluster[femaleStaffIndex] = maleStaffId
                break
              end
            end
          else
            table.insert(staffListOnDemoCluster, maleStaffId )
          end
          needMaleStaffNum = needMaleStaffNum - 1
        end
      end
    end


    for i = 1, needMaleStaffNum do
      table.insert( staffListOnDemoCluster,1, TppMotherBaseManagement.GenerateStaffParameter{ staffType="Unique", uniqueTypeId=uniqueTypeId } )
      uniqueTypeId = uniqueTypeId + 1
      if #staffListOnDemoCluster > MAX_STAFF_NUM_ON_CLUSTER then
        table.remove( staffListOnDemoCluster )
      end
    end
  end

  for i, staffIdList in ipairs(mvars.f30050_staffIdList) do
    mtbs_enemy.SetSecurityStaffIdList(i,staffIdList)
    mtbs_enemy.UpdateEnableSoldier(i)
  end
end

function this.OnEndMissionPrepareSequence()
  if Ivars.mbEnableLethalActions:Is(0) then--tex added check
    TppUiStatusManager.SetStatus(	"EquipHudAll", "ALL_KILL_NOUSE" )
  end

  TppUiStatusManager.SetStatus( "QuestAreaAnnounce", "INVALID" )


  if svars.isLeaveBattleHanger then
    local soundPos = this.GetPositionOuterBattleHangerDoor()
    TppSoundDaemon.PostEvent3D( "sfx_m_hanger_door_close", Vector3(soundPos[1],soundPos[2],soundPos[3]), 'Loading')
    svars.isLeaveBattleHanger = false
  end

end




function this.OnRestoreSVars()
  local missionName = TppMission.GetMissionName()
  Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")


  if TppDemo.IsQuestStart() and (not this.IsRideOnHeliDemo( mvars.f30050_demoName ) ) then
    mvars.f30050_demoName = nil
  end


  TppDemo.SetNextMBDemo(mvars.f30050_demoName)

  local demoName = TppDemo.GetMBDemoName()
  Fox.Log("DemoName:OnStoreSvars: " ..tostring(demoName) )
  if demoName then
    local demoTime = f30050_demo.GetDemoTime(demoName)
    if demoTime then
      TppClock.SetTime( demoTime )
    end
  end


  local clusterId = svars.restartClusterId
  if clusterId > #TppDefine.CLUSTER_NAME then
    clusterId = MotherBaseStage.GetCurrentCluster()
  end
  if clusterId > #TppDefine.CLUSTER_NAME then
    clusterId = MotherBaseStage.GetFirstCluster()
  end

  if demoName and (not this.IsRideOnHeliDemo( demoName ) ) then
    clusterId = TppDefine.CLUSTER_DEFINE[ f30050_demo.GetDemoPlayCluster( demoName ) ]
  end


  if gvars.f30050_missionPackIndex == STAGE_PACK_INDEX.NORMAL then
    TppQuest.HideAllShootingPracticeForUi()
  end



  if f30050_enemy.NeedSetup() then
    this.SetupStaffList()
    this.RegisterFovaFpk(clusterId)

    f30050_demo.SetupEnemy(mvars.f30050_demoName)
  end

  if gvars.f30050_missionPackIndex ~= STAGE_PACK_INDEX.BATTLE_HANGER then

    this.LoadBlockOnRestoreSvars( clusterId )
  end


  if mvars.f30050_needLoadBuddyController then
    TppBuddy2BlockController.ReserveCallBuddy(vars.buddyType,BuddyInitStatus.RIDE,Vector3( 0, 0, 0 ), 0.0 )
  end

  if not svars.canReceivePicture then

    this.SetPazSleepTime()
  end


  MotherBaseConstructConnector.SetSahelanLodVisibility( TppStory.CanArrivalSahelanInMB() )


  this.EnableQuietMarker()
  this.EnableBattleHangerMarker()


  mvars.f30050_IsPlayedNuclearAbolitionDemo = TppDemo.IsPlayedMBEventDemo("NuclearEliminationCeremony")


  this.UpdateCommonCollection()


  this.EnableDistributionCenter()


  for clusterId = 1, #TppDefine.CLUSTER_NAME do
    mtbs_enemy.SetEnableSoldierInCluster( clusterId, false )
  end


  mtbs_cluster.UnlockCluster( )


  this.DisableIntelRadio()
end




local MAX_STAFF_NUM_IN_CLUSTER = MAX_STAFF_NUM_ON_CLUSTER--tex was 18
--tex OFF unused local MAX_FACE_NUM_IN_CLUSTER = 18
--IN: mvars.f30050_soldierStaffIdList: SetupStaffList
--IN: mvars.f30050_soldierListFovaApplyPriority: mtbs_enemy.SetupSoldierListFovaApplyPriority, SetSoldierForDemo
--OUT: fovaPackList > mvars.f30050demo_fovaPackList (via f30050_demo.RegisterFovaPack)
this.RegisterFovaFpk = function( clusterId )
  Fox.Log("RegisterFovaFpk! clusterId:" ..tostring(clusterId) )
  if clusterId >= 7 then
    return
  end
  if not f30050_enemy.NeedSetup() then
    return
  end
  mvars.f30050_currentFovaClusterId = clusterId
  local fovaPackList = {}
  mvars.f30050_soldierFaceIdListPriority = {}
  mvars.f30050_soldierFaceIdList = {}
  mvars.f30050_soldierBalaclavaFaceIdList = {}
  mvars.f30050_soldierBalaclavaLocatorList = {}
  mvars.f30050_soldierStaffIdList = {}
  local securityStaffFaceIds = {}
  local staffIdList = mvars.f30050_staffIdList[clusterId+1]
  for i = 1,MAX_STAFF_NUM_IN_CLUSTER do
    local locatorName = mvars.f30050_soldierListFovaApplyPriority[clusterId+1][i]
    if staffIdList[i] == nil then
      local faceId = 222
      securityStaffFaceIds[i] = faceId
      table.insert( mvars.f30050_soldierBalaclavaFaceIdList, faceId)
      table.insert( mvars.f30050_soldierBalaclavaLocatorList, locatorName )
    else
      securityStaffFaceIds[i] = TppMotherBaseManagement.StaffIdToFaceId{ staffId=staffIdList[i] }
      Fox.Log("Load Staff FaceId : " ..tostring(securityStaffFaceIds[i]) )
      mvars.f30050_soldierStaffIdList[securityStaffFaceIds[i]] = staffIdList[i]


      local faceTypeList = TppSoldierFace.CheckFemale{ face={securityStaffFaceIds[i]} }
      if (faceTypeList == nil) or (faceTypeList[1] == 2) then
        Fox.Error( "face Id is invalid:" ..tostring(securityStaffFaceIds[i]) )
        Fox.Error( "staffId:" ..tostring(staffIdList[i]) )
        securityStaffFaceIds[i] = 222
      end


      if f30050_demo.IsBalaclava( mvars.f30050_demoName, locatorName ) then
        table.insert( mvars.f30050_soldierBalaclavaLocatorList, locatorName )
        table.insert( mvars.f30050_soldierBalaclavaFaceIdList, securityStaffFaceIds[i])
      else
        table.insert( mvars.f30050_soldierFaceIdList, securityStaffFaceIds[i])
      end
    end
    table.insert(mvars.f30050_soldierFaceIdListPriority, securityStaffFaceIds[i])
  end


  if TppEneFova.IsUseGasMaskInMBFree(mvars.f30050_currentFovaClusterId) then
    Tpp.ApendArray( fovaPackList, TppSoldierFace.GetFaceFpkFileCodeList{ face={TppEnemyFaceId.dds_balaclava6, TppEnemyFaceId.dds_balaclava7} } )
    Tpp.ApendArray( mvars.f30050_soldierBalaclavaFaceIdList, mvars.f30050_soldierFaceIdList )
    mvars.f30050_soldierBalaclavaLocatorList = {}
    Tpp.ApendArray( mvars.f30050_soldierBalaclavaLocatorList, mvars.f30050_soldierListFovaApplyPriority[clusterId+1] )
    mvars.f30050_soldierFaceIdList = {}
  elseif #mvars.f30050_soldierBalaclavaFaceIdList > 0 then
    Tpp.ApendArray( fovaPackList, TppSoldierFace.GetFaceFpkFileCodeList{ face={TppEnemyFaceId.dds_balaclava5, TppEnemyFaceId.dds_balaclava2} } )
  end

  if Ivars.mbNonStaff:Is(1) then--tex> for wargames, set up list of non staff/enemy faces
    mvars.f30050_soldierStaffIdList={}
    local securityStaffFaceIds={}
    InfMain.RandomSetToLevelSeed()
    local faceBags=InfEneFova.BuildFaceBags(InfEneFova.faceIds)
    local categoryBags={
      MALE=InfEneFova.GetCategoryBag(InfEneFova.categoryChances,"MALE",{"COMMON","UNCOMMON","UNIQUE"}),
      FEMALE=InfEneFova.GetCategoryBag(InfEneFova.categoryChances,"FEMALE",{"COMMON","UNIQUE"}),
    }
    local mbWargameFemales=Ivars.mbWargameFemales:Get()
    for i=1,MAX_STAFF_NUM_ON_CLUSTER do
      if (mbWargameFemales>0 and math.random(0,100)<mbWargameFemales) or mbWargameFemales==100 then
        table.insert(securityStaffFaceIds,InfEneFova.RandomFaceId(faceBags,"FEMALE",categoryBags.FEMALE))
      else
        table.insert(securityStaffFaceIds,InfEneFova.RandomFaceId(faceBags,"MALE",categoryBags.MALE))
      end
    end
    InfMain.RandomResetToOsTime()
    mvars.f30050_soldierFaceIdListPriority=securityStaffFaceIds
    mvars.f30050_soldierFaceIdList=securityStaffFaceIds
    mvars.f30050_soldierBalaclavaLocatorList={}
    mvars.f30050_soldierBalaclavaFaceIdList={}
  end--<
  --tex NMC just some kjp debugging func
  if TppEnemy.MB_SET_FEMALE_ALL_STAFF or TppEnemy.MB_SET_MEMORY_DUMP then
    local securityStaffFaceIds = {}
    if TppEnemy.MB_SET_FEMALE_ALL_STAFF then
      securityStaffFaceIds = {479,479,479,479,479,479,479,479,479,479,479,479,479,479,479,479,479,479}
    elseif TppEnemy.MB_SET_MEMORY_DUMP then
      securityStaffFaceIds = {108,129,137,99,162,350,355,365,450,465,472,463,501,602,618,621,628,646}
    end
    mvars.f30050_soldierFaceIdListPriority = securityStaffFaceIds
    mvars.f30050_soldierFaceIdList = securityStaffFaceIds
    mvars.f30050_soldierBalaclavaLocatorList = {}
    mvars.f30050_soldierBalaclavaFaceIdList = {}--RETAILBUG even though is just used for debug, was f30050_soldierBalaclavaLocatorList which is already above
  end
  --tex NMC GetFaceFpkFileCodeList is also how quests load their faces in RegisterQuestPackList
  local faceFovaFpk = TppSoldierFace.GetFaceFpkFileCodeList{ face=mvars.f30050_soldierFaceIdList, deco = mvars.f30050_soldierBalaclavaFaceIdList, useHair=true }
  if faceFovaFpk then
    Tpp.ApendArray( fovaPackList, faceFovaFpk )
  end
  f30050_demo.RegisterFovaPack( fovaPackList )--tex NMC just sets mvars.f30050demo_fovaPackList
end--RegisterFovaFpk

--tex>
local gameOverKillTypes={
  [TppGameObject.GAME_OBJECT_TYPE_SOLDIER2]=true,
  [TppGameObject.GAME_OBJECT_TYPE_HOSTAGE2]=true,
  [TppGameObject.GAME_OBJECT_TYPE_HOSTAGE_UNIQUE]=true,
  [TppGameObject.GAME_OBJECT_TYPE_HOSTAGE_UNIQUE2]=true,
}
--<

function this.Messages()
  return
    StrCode32Table {
      Weather = {
        {
          msg = "Clock",	sender = "PazWakeUp",
          func = function( sender, time )
            Fox.Log("Paz wake up")
            svars.canReceivePicture = true
            TppClock.UnregisterClockMessage("PazWakeUp")
          end
        },
      },
      Radio = {
        {
          msg = "Finish", sender = "f2000_rtrg1345",
          func = function()
            this.EnableQuietMarker()
          end,
        },
      },
      GameObject = {
        {
          msg = "RequestedHeliTaxi",
          func = function( gameObjectId, currentLandingZoneName, nextLandingZoneName )
            Fox.Log( "### RequestHeliTaxi ###" )
            mtbs_helicopter.RequestHeliTaxi( gameObjectId, currentLandingZoneName, nextLandingZoneName )
          end
        },

        {
          msg = "Dead",
          func = function(gameObjectId)
            if not Tpp.IsPlayer(gameObjectId) then
              --tex> NDBD
              local typeIndex=GameObject.GetTypeIndex(gameObjectId)
              if gameOverKillTypes[typeIndex]then
                if Ivars.mbNonStaff:Is(0) then--tex added check --<
                  mvars.f30050_deadGameObjectId = gameObjectId
                  TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.PLAYER_KILL_DD )
                end
              end
            end
          end,
        },
        {
          msg = "Dying",
          func = function(gameObjectId)
            if not Tpp.IsPlayer(gameObjectId) then
              --tex> NDBD
              local typeIndex=GameObject.GetTypeIndex(gameObjectId)
              if gameOverKillTypes[typeIndex]then
                if Ivars.mbNonStaff:Is(0) then--tex added check--<
                  mvars.f30050_deadGameObjectId = gameObjectId
                  TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.PLAYER_KILL_DD )
                end
              end
            end
          end,
        },
        {
          msg = "SwitchGimmick",
          func = function(gameObjectId, gameObjectName, name, switchFlag)
            if gameObjectName == StrCode32("ly003_cl04_item0000|cl04pl0_uq_0040_gimmick2|gntn_swtc001_vrtn001_gim_n0001|srt_gntn_swtc001_vrtn001") then

              do
                local pos = Tpp.GetLocator("mtbs_pazRoom_Locator", "enter")
                local distance = (pos[1] - vars.playerPosX) * ( pos[1] - vars.playerPosX ) + ( pos[2] - vars.playerPosY ) * (pos[2] - vars.playerPosY) + (pos[3] - vars.playerPosZ) * ( pos[3] - vars.playerPosZ )
                if distance > 9.0 then
                  return
                end
              end
              TppSequence.SetNextSequence("Seq_Game_PazRoomOnLeave")
            elseif gameObjectName == StrCode32("gntn_swtc001_vrtn001_gim_n0000|srt_gntn_swtc001_vrtn001") then

              this.PushSwitchOnLeaveBattleHanger()
            end
          end,
        },
      },
      Trap = {
        {
          msg = "Enter",
          sender = { "trap_bridge0000","trap_bridge0001","trap_bridge0002", },
          func = function( trapName, gameObjectId )
            Fox.Log( " ### Enter : HeliSoundTrap ### " )
            TppSoundDaemon.PostEvent( "sfx_m_mtbs_taxi_wind" )
          end,
        },
      },
      Player = {
        {
          msg = "PlayerSwitchStart",
          func = function(playerGameObjectId, switchGameObjectId )
            if TppStory.GetBattleGearDevelopLevel() >= 0 then
              do
                local _, gameObjectId = Gimmick.GetGameObjectId(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "gntn_swtc001_vrtn001_gim_n0000|srt_gntn_swtc001_vrtn001","/Assets/tpp/level/location/mtbs/block_large/mtbs_hanger_gimmick.fox2" )
                if gameObjectId == switchGameObjectId then
                  this.SetCameraPushSwitch()
                  return
                end
              end
              do
                local gimmickName = "ly003_cl02_item0000|cl02pl0_uq_0020_gim_onlymb2|gntn_swtc001_vrtn001_gim_n0000|srt_gntn_swtc001_vrtn001"
                local dataSetName = "/Assets/tpp/level/location/mtbs/block_area/ly00" ..tostring(vars.mbLayoutCode) .."/cl02/mtbs_ly00" ..tostring(vars.mbLayoutCode).. "_cl02_item.fox2"
                local _, gameObjectId = Gimmick.GetGameObjectId(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, gimmickName , dataSetName)
                if gameObjectId == switchGameObjectId then
                  this.SetCameraPushSwitch()
                  return
                end
              end
            end
            if this.CanEnterPazRoom() then
              do
                local layoutCode = vars.mbLayoutCode
                local dataSetName = "/Assets/tpp/level/location/mtbs/block_area/ly00".. tostring(layoutCode) .. "/cl04/mtbs_ly00" ..tostring(layoutCode) .."_cl04_item.fox2"
                local switchOnEnterPazRoom = "ly003_cl04_item0000|cl04pl0_uq_0040_gimmick2|gntn_swtc001_vrtn001_gim_n0000|srt_gntn_swtc001_vrtn001"
                local _, gameObjectId = Gimmick.GetGameObjectId(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, switchOnEnterPazRoom , dataSetName)
                if gameObjectId == switchGameObjectId then
                  this.SetCameraPushSwitch()
                  return
                end
              end
              do
                local dataSetName = "/Assets/tpp/level/location/mtbs/block_area/ly00".. tostring(layoutCode) .. "/cl04/mtbs_ly00" ..tostring(layoutCode) .."_cl04_item.fox2"--RETAILBUG? the 'do' means the layoutCode would be out of scope/undefined?
                local switchOnLeavePazRoom = "ly003_cl04_item0000|cl04pl0_uq_0040_gimmick2|gntn_swtc001_vrtn001_gim_n0001|srt_gntn_swtc001_vrtn001"
                local _ , gameObjectId = Gimmick.GetGameObjectId(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, switchOnLeavePazRoom , dataSetName)
                if gameObjectId == switchGameObjectId then
                  this.SetCameraPushSwitch()
                  return
                end
              end
            end
          end,
        },
        {
          msg = "OnPlayerHeliHatchOpen",
          func = function()

            this.SetUniqueCharaVisibility( true )
          end,
        },
        {
          msg = "PlayerHeliGetOff",
          func = function( gameObjectId )
            if Tpp.IsPlayer( gameObjectId ) then

              this.SetUniqueCharaVisibility( false )
            end
          end,
        },
        {
          msg = "RideHelicopter",
          func = function( gameObjectId )
            if Tpp.IsPlayer( gameObjectId ) then

              this.SetUniqueCharaVisibility( true )

              mtbs_baseTelop.DisableBaseName()
            end
          end,
        },
      },
    }
end

function this.SetDefaultPlayerDisableAction()
  if mvars.f30050_defaultDisableActionFlag == nil then
    mvars.f30050_defaultDisableActionFlag = PlayerDisableActionFlagMtbsDefault
  end
  if this.IsRideOnHeliDemo( mvars.f30050_demoName )then

    TppUiCommand.SetMbTopMenuItemActive( TppTerminal.MBDVCMENU.MSN_MISSIONLIST, false)
  end
  vars.playerDisableActionFlag = mvars.f30050_defaultDisableActionFlag
end





function this.SetPlayerDisableActionSIDEOPS( playerDisableActionFlag )
  mvars.f30050_defaultDisableActionFlag = playerDisableActionFlag
  this.SetDefaultPlayerDisableAction()
end

function this.ResetPlayerDisableActionSIDEOPS()
  mvars.f30050_defaultDisableActionFlag = PlayerDisableActionFlagMtbsDefault
  this.SetDefaultPlayerDisableAction()
end


function this.LoadBlockOnRestoreSvars( clusterId )
  local demoName = TppDemo.GetMBDemoName()
  this.RegisterFovaFpk(clusterId)
  if svars.isPazRoomStart then
    f30050_demo.RegisterFovaPack( {} )
    local packName = this.GetCurrentPazPackName()
    f30050_demo.UpdatePackList( packName )
    TppScriptBlock.LoadDemoBlock( packName, true )
  elseif demoName and this._IsClusterDemoPlay( demoName, clusterId ) then
    if mvars.f30050_needDemoLoad then
      f30050_demo.UpdatePackList( demoName )
      TppScriptBlock.LoadDemoBlock( demoName, true )
      mvars.f30050_needDemoLoad = false
    end
  else
    TppQuest.SetQuestBlockName( SCRIPT_BLOCK_NAME )
    TppQuest.InitializeQuestLoad(clusterId+1)
    if not TppQuest.GetCurrentQuestName() then
      f30050_demo.UpdatePackList( "Empty" )
      TppScriptBlock.LoadDemoBlock( "Empty", true )
    end
  end
end

function this._IsClusterDemoPlay( demoName, clusterId )
  local demoPlayClusterName = f30050_demo.GetDemoPlayCluster( demoName )
  return clusterId == TppDefine.CLUSTER_DEFINE[demoPlayClusterName]
end



sequences.Seq_Demo_SetupCluster = {
  Messages = function( self )
    return
      StrCode32Table {
        MotherBaseStage = {
          {
            msg = "MotherBaseCurrentClusterActivated",
            func = function(clusterId)
              TppSequence.SetNextSequence("Seq_Demo_SetupScriptBlock")
            end,
          },
        },
      }
  end,
  OnEnter = function()


    TppUiStatusManager.SetStatus( "AnnounceLog", "INVALID_LOG" )

    this.SetEnableQuestUI(false)

    local demoName = TppDemo.GetMBDemoName()

    if gvars.f30050_missionPackIndex == STAGE_PACK_INDEX.BATTLE_HANGER then
      this.WarpToBattleHanger()
      TppSequence.SetNextSequence("Seq_Demo_BattleHanger")
      return
    end

    if demoName and (not this.IsRideOnHeliDemo(demoName) )then
      local currentClusterId = MotherBaseStage.GetCurrentCluster()
      local clusterName, plntName = f30050_demo.GetDemoPlayCluster( demoName )
      local nextDemoClusterId = TppDefine.CLUSTER_DEFINE[clusterName]

      TppUiStatusManager.UnsetStatus( "QuestAreaAnnounce", "INVALID" )
      if nextDemoClusterId ~= currentClusterId then
        mtbs_cluster.LockCluster(clusterName)
        return
      end
      TppSequence.SetNextSequence("Seq_Demo_SetupScriptBlock")
    else

      TppSequence.SetNextSequence("Seq_Game_Setup")
    end
  end,
  OnLeave = function()
    this.EnableAssetsOnCluster( MotherBaseStage.GetCurrentCluster() )
  end,
}

sequences.Seq_Demo_SetupScriptBlock = {
  OnUpdate = function()
    local blockId = ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME)
    if blockId == ScriptBlock.SCRIPT_BLOCK_ID_INVALID then
      TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "OnEndGameStartFadeIn" )
      return
    end
    local state = ScriptBlock.GetScriptBlockState(blockId)
    local waitState = ScriptBlock.SCRIPT_BLOCK_STATE_INACTIVE
    if TppDemo.GetMBDemoName() then
      waitState = ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE
    end
    if state >= waitState then
      TppSequence.SetNextSequence("Seq_Demo_WaitBuddyLoaded")
    end
    TppUI.ShowAccessIconContinue()
  end,
  OnLeave = function()
    mtbs_enemy.OnActivateDemoBlock( )
    mvars.f30050_finishSetupScriptBlock = true
  end,
}

sequences.Seq_Demo_WaitBuddyLoaded = {
  OnEnter = function(self)
    local demoName = TppDemo.GetMBDemoName()
    if f30050_demo.NeedLoadBuddyBlock( demoName ) then
      f30050_demo.SetupBuddy( demoName )
    else
      self.SetNextSequence(demoName)
    end
  end,
  OnUpdate = function(self)
    if TppBuddy2BlockController.IsBlockActive() then
      self.SetNextSequence()
    end
    TppUI.ShowAccessIconContinue()
  end,
  SetNextSequence = function(demoName)
    if demoName == "NuclearEliminationCeremony" then
      TppSequence.SetNextSequence("Seq_Demo_Nuclear_Abolition_Telop")
    else
      TppSequence.SetNextSequence("Seq_Demo_Opening")
    end
  end,
}

sequences.Seq_Demo_End_Wait_Player_Warp = {
  Messages = function( self )
    return
      StrCode32Table {
        Player = {
          {
            msg = "WarpEnd",
            func = function()

              GkEventTimerManager.Start( "WaitCameraMoveEnd", 0.5 )
            end,
          },
        },
        Timer = {
          {
            msg = "Finish",
            sender = "WaitCameraMoveEnd",
            func = function ( )
              TppSequence.SetNextSequence("Seq_Demo_End")
            end,
          },
        },
      }
  end,
}

sequences.Seq_Demo_End_Warp_Cluster = {
  Messages = function( self )
    return
      StrCode32Table {
        MotherBaseStage = {
          {
            msg = "MotherBaseCurrentClusterLoadStart",
            func = function(clusterId)
              mvars.f30050_seq_warp_isActivateDemoBlock = false
              TppQuest.SetQuestBlockName( SCRIPT_BLOCK_NAME )
              this.DoLoadStartCluster(clusterId)
            end,
          },
          {
            msg = "MotherBaseCurrentClusterActivated",
            func = function(clusterId)
              mvars.f30050_isActivateStageBlock = true
              this.DoActivatedCluster(clusterId)
            end,
          },
        },
      }
  end,
  OnEnter = function()
    mvars.f30050_prevScriptBlockState = ScriptBlock.GetScriptBlockState(ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME))
  end,
  OnUpdate = function()

    local state = ScriptBlock.GetScriptBlockState(ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME))
    if state == ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE and state > mvars.f30050_prevScriptBlockState then
      mtbs_enemy.OnActivateDemoBlock()
      mvars.f30050_seq_warp_isActivateDemoBlock = true
    end
    mvars.f30050_prevScriptBlockState = state
    if mvars.f30050_isActivateStageBlock and mvars.f30050_seq_warp_isActivateDemoBlock then
      svars.restartClusterId = MotherBaseStage.GetCurrentCluster()
      TppSequence.SetNextSequence("Seq_Demo_End")
    end
  end,
}

sequences.Seq_Demo_Opening = {
  Messages = function( self )
    return
      StrCode32Table {
        UI = {
          {
            msg = "EndFadeIn", sender = "OnEndGameStartFadeIn",
            func = function ()
              TppSequence.SetNextSequence("Seq_Game_MainGame")
            end,
            option = { isExecDemoPlaying = true },
          },
        },
        GameObject = {
          {
            msg = "RoutePoint2",
            func = function(gameObjectId, routeId, routeNode, message)
              Fox.Log("route:" ..routeId)
              if message == StrCode32("DisableOcelot") then
                f30050_demo.DisableOcelot()
              elseif message == StrCode32("DisableDemoEndRoute") then
                local command = { id = "SwitchRoute", route = "" }
                SendCommand( gameObjectId, command )
              end
            end,
            option = { isExecDemoPlaying = true },
          },
        },
        Timer = {
          {
            msg = "Finish",
            sender = "TelopStartOnDemo",
            func = function ( )
              this.ShowTelopInDemo()
            end,
            option = { isExecDemoPlaying = true },
          },
        },
        Demo = {
          {
            msg = "brake_room",
            func = function()
              TppDataUtility.SetVisibleDataFromIdentifier( "id_20150116_131237_710", "p61_010030_demo_hide", false, false)
              TppDataUtility.SetVisibleDataFromIdentifier( "id_20150116_174108_802", "p61_010030_demo_show", true, false)
            end,
            option = { isExecDemoPlaying = true },
          },
          {
            msg = "refresh_player",
            func = function()
              if mvars.f30050_demoName == "SnakeHasBadSmell_WithoutQuiet"
                or mvars.f30050_demoName == "QuietOnHeliInRain" then
                Player.OnPlayerRefresh()
              else
                TppPlayer.Refresh(false)
              end
            end,
            option = { isExecDemoPlaying = true },
          },

          {
            msg = "nwvocn",
            func = function()
              TppEffectUtility.RestoreOceanParameters()
            end,
            option = { isExecDemoPlaying = true },
          },
          {
            msg = "qwvocn",
            func = function()
              TppEffectUtility.SetOceanBaseHeight(-24.5)
              TppEffectUtility.SetOceanProjectionScale(64)
              TppEffectUtility.SetOceanBlendEnd(384.0)
              TppEffectUtility.SetOceanFarProjectionAmplitude(0.0)
              TppEffectUtility.SetOceanSpecularIntensity(0.0)
              TppEffectUtility.SetOceanDisplacementStrength(0.01)
              TppEffectUtility.SetOceanWaveAmplitude(0.05)
            end,
            option = { isExecDemoPlaying = true },
          },
          {
            msg = "nwvocn02",
            func = function()
              TppEffectUtility.RestoreOceanParameters()
            end,
            option = { isExecDemoPlaying = true },
          },

          {
            msg = "p51_010060_mtbs_bord_on",
            func = function()
              local dataSetName = "/Assets/tpp/level/mission2/free/f30050/f30050_gimmick_target.fox2"
              Gimmick.ResetGimmickData("mtbs_bord001_vrtn003_gim_i0000|TppSharedGimmick_mtbs_bord001_vrtn003", dataSetName )
              local bord = "mtbs_bord001_vrtn003_gim_n0003|srt_mtbs_bord001_vrtn003"
              Gimmick.InvisibleGimmick( -1, bord, dataSetName, true )
            end,
            option = { isExecDemoPlaying = true },
          },

          {
            msg = "p51_010270_001_HBDbox_on",
            func = function()
              TppDataUtility.SetVisibleDataFromIdentifier( "birthday_demo_after", "birthday_asset", true, false)
              TppDataUtility.SetEnableDataFromIdentifier("mtbs_plant0","HappyBirthdayBoxNavBounder",true, false )
            end,
            option = { isExecDemoPlaying = true },
          },

          {
            msg = "Finish",
            func = function()
              if f30050_demo.IsShowReward(mvars.f30050_demoName) then
                TppSoundDaemon.SetMute( 'Reward' )
              end
            end,
            option = { isExecDemoPlaying = true },
          },
        },
      }
  end,

  OnEnter = function()

    local currentDemoName = TppDemo.GetMBDemoName()
    if currentDemoName then
      f30050_demo.PlayMtbsEventDemo{
        demoName = currentDemoName,
        onEnd = function()
          Fox.Log("On end MB free mission opening demo.")
          local currentDemoName = TppDemo.GetMBDemoName()
          local nextDemo = f30050_demo.GetNextDemo( currentDemoName )
          if nextDemo then
            TppSequence.SetNextSequence("Seq_Demo_SetupCluster")
            TppDemo.SetNextMBDemo( nextDemo )
          else

            svars.restartClusterId = MotherBaseStage.GetCurrentCluster()


            if mvars.f30050_demoName == "NuclearEliminationCeremony" then
              TppSequence.SetNextSequence("Seq_Demo_Ending_Epigraph")
            elseif f30050_demo.IsShowReward(currentDemoName) then
              TppSequence.SetNextSequence("Seq_Demo_RewardAfterDemo")
            elseif mvars.f30050_demoName == "QuietReceivesPersecution" then
              TppSequence.SetNextSequence("Seq_Demo_End_Warp_Cluster")
            elseif mvars.f30050_demoName == "QuietHasFriendshipWithChild" then
              TppSequence.SetNextSequence("Seq_Demo_End_Wait_Player_Warp")
            else
              TppSequence.SetNextSequence("Seq_Demo_End")
            end
          end
        end,
      }
    else
      Fox.Error("demo not found. but enter Seq_Demo_Opening")
      TppSequence.SetNextSequence("Seq_Demo_End")
    end
  end,

  OnLeave = function ()
    mtbs_cluster.UnlockCluster()
  end,
}


function this.ShowTelopInDemo()
  if not TppMission.IsStartFromHelispace()
    and mvars.f30050_demoTelopLangIdList ~= nil then
    local index = 4
    for _, langId in ipairs( mvars.f30050_demoTelopLangIdList ) do
      if langId == "birthday" then
        TppUiCommand.RegistInfoTypingText( langId,  3 )
      else
        TppUiCommand.RegistInfoTypingText( "lang",  index, langId )
        index = index + 1
      end
    end
    TppUiCommand.ShowInfoTypingText()
  end
end


sequences.Seq_Demo_Nuclear_Abolition_Telop = {
  OnEnter = function()
    TppUiCommand.SetStrongPrioTelopCast( true )
    TppUiCommand.RegistTelopCast( "CenterCommon", 7.0, "", "cmmn_MMDD_hhmm", "nuclear_zero", 1.0, 0.0 )
    TppUiCommand.StartTelopCast()
  end,
  Messages = function( self )
    return
      StrCode32Table {
        UI = {
          {
            msg = "EndTelopCast",
            func = function ()
              TppSequence.SetNextSequence("Seq_Demo_Opening")
            end,
          },
        },
      }
  end,
}


local EpigraphTable = {
  { time = 10, epigraphLangid = "tpp_epigraph_mgs1_01", quoteLangid = "", quoteOffsetY = nil },
  { time = 10, epigraphLangid = "tpp_epigraph_mgs1_02", quoteLangid = "", quoteOffsetY = nil },
  { time = 10, epigraphLangid = "tpp_epigraph_mgs1_03", quoteLangid = "tpp_epigraph_mgs1_quote", quoteOffsetY = 15 },
  { time =  9, epigraphLangid = "tpp_epigraph_obama_01", quoteLangid = "", quoteOffsetY = nil },
  { time =  9, epigraphLangid = "tpp_epigraph_obama_02", quoteLangid = "", quoteOffsetY = nil },
  { time = 15, epigraphLangid = "tpp_epigraph_obama_03", quoteLangid = "", quoteOffsetY = nil },
  { time = 15, epigraphLangid = "tpp_epigraph_obama_04", quoteLangid = "tpp_epigraph_obama_quote", quoteOffsetY = 15 },
  { time =  8, epigraphLangid = "tpp_epigraph_obama_05", quoteLangid = "", quoteOffsetY = nil },
}
sequences.Seq_Demo_Ending_Epigraph = {
  OnEnter = function()
    Player.SetPause()
    TppSoundDaemon.SetMute( 'Result' )
    this.StartEpigraph()
  end,
  Messages = function( self )
    return
      StrCode32Table {
        UI = {
          {
            msg = "EndTelopCast",
            func = function ()
              TppSound.StopSceneBGM()
              TppSequence.SetNextSequence("Seq_Demo_Ending_OnlineUser")
            end,
          },
        },
      }
  end,
  OnLeave = function()
  end,
}
function this.StartEpigraph()
  mvars.f30050_epigraphIndex = 1
  for _, epigraph in ipairs( EpigraphTable ) do
    TppUiCommand.RegistTelopCast( "Epigraph", epigraph.time, epigraph.epigraphLangid,epigraph.quoteLangid , 1.0, 0, epigraph.quoteOffsetY )
    TppUiCommand.RegistTelopCast( "PageBreak" )
  end
  TppUiCommand.SetStrongPrioTelopCast( true )
  TppUiCommand.StartTelopCast()
end

sequences.Seq_Demo_Ending_OnlineUser = {
  OnEnter = function()
    TppUiStatusManager.SetStatus( "AnnounceLog", "INVALID_LOG" )
    Player.SetPause()

    TppEnding.Start( "Nuke_OnlineUser", 59.0, 		2.0, 		3.0, 				2.0, 			"", 				  "nuclear_for_all_dd" )
    SubtitlesCommand.SetIsEnabledUiPrioStrong( true )
    TppSoundDaemon.PostEventAndGetHandle( 'Play_p51_020050', 'Loading' )
  end,
  OnLeave = function()
    SubtitlesCommand.SetIsEnabledUiPrioStrong( false )
  end,
  Messages = function( self )
    return
      StrCode32Table {
        UI = {
          {
            msg = "GzEndingFinish",
            func = function ()
              this.FinishNuclearAbolitionEndint()
            end,
          },
          {
            msg = "TppEndingFinish",
            func = function ()
              this.FinishNuclearAbolitionEndint()
            end,
          },
        },
      }
  end,
}


function this.FinishNuclearAbolitionEndint()
  TppUiStatusManager.UnsetStatus( "AnnounceLog", "INVALID_LOG" )
  PlatformConfiguration.SetShareScreenEnabled( true )
  TppSoundDaemon.ResetMute( 'Result' )

  this.ReserveMissionClear()
  if not mvars.f30050_IsPlayedNuclearAbolitionDemo then

    TppHero.SetAndAnnounceHeroicOgrePoint( TppHero.NuclearAbolition , nil, "announce_nuclear_zero")
  end
end

sequences.Seq_Demo_End = {
  OnEnter = function()
    local demoName = TppDemo.GetMBDemoName()
    if this.IsRideOnHeliDemo( demoName ) then
      Fox.Log("Mission clear : on Demo:" ..tostring(demoName) )
      this.ReserveMissionClear()
      return
    end

    if TppMission.IsStartFromHelispace() then
      gvars.ply_initialPlayerState = TppDefine.INITIAL_PLAYER_STATE.RIDEON_HELICOPTER
    end
    do
      local saveAtCurrentPosition = true
      if mvars.f30050_isOverwriteDemoEndPos then
        saveAtCurrentPosition = false
      end

      if mvars.f30050_needReload then
        TppScriptBlock.Unload( SCRIPT_BLOCK_NAME )
        local nextSequence = "Seq_Game_Setup"
        TppDemo.SetNextMBDemo()
        TppMission.Reload{
          missionPackLabelName = "AfterDemo",
          clusterId = MotherBaseStage.GetCurrentCluster(),
          OnEndFadeOut = function()
            TppSequence.ReserveNextSequence( nextSequence )
          end,
        }
      else
        TppDemo.SetNextMBDemo()
        TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED )
        TppMain.EnableAllGameStatus()

        mtbs_baseTelop.DispBaseNameNoTelop()
        TppSequence.SetNextSequence("Seq_Game_MainGame")


        if mtbs_cluster.GetCurrentClusterName() == "Command" then
          TppQuest.RegisterClusterForceDeactiveOnMBTerminal( MotherBaseStage.GetCurrentCluster() )
        end
        this.SetEnableQuestUI(false)
      end
      TppMission.UpdateCheckPoint{
        checkPoint = "CHK_MainGame",
        atCurrentPosition = saveAtCurrentPosition,
      }
    end
  end,
}


sequences.Seq_Game_Setup = {
  OnEnter = function()
    local clusterId = MotherBaseStage.GetCurrentCluster()
    if clusterId > #TppDefine.CLUSTER_NAME then
      clusterId = MotherBaseStage.GetFirstCluster()
    end
    this.RegisterFovaFpk(clusterId)
    if this.IsNeedLoadRideOnHeliDemo(clusterId) then


      TppQuest.RegisterClusterForceDeactiveOnMBTerminal(clusterId)
      this.SetEnableQuestUI(false)
    end
  end,
  OnUpdate = function()
    local blockId = ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME)
    if blockId == ScriptBlock.SCRIPT_BLOCK_ID_INVALID then
      Fox.Error(SCRIPT_BLOCK_NAME .. " is not found")
      TppSequence.SetNextSequence("Seq_Game_MainGame")
      return
    end
    local state = ScriptBlock.GetScriptBlockState(blockId)
    local waitState = ScriptBlock.SCRIPT_BLOCK_STATE_INACTIVE
    if state >= waitState then
      TppSequence.SetNextSequence("Seq_Game_MainGame")
    end
  end,
  OnLeave = function()

    this.SetUniqueCharaVisibility( false )
    local clusterId = MotherBaseStage.GetCurrentCluster()
    if clusterId > #TppDefine.CLUSTER_NAME then
      clusterId = MotherBaseStage.GetFirstCluster()
    end

    if TppQuest.GetCurrentQuestName() then
      TppQuest.InitializeQuestActiveStatus( clusterId + 1 )
      this.SetEnableQuestUI(true)
    end

    this.EnableAssetsOnCluster(clusterId)
    mtbs_enemy.OnActivateDemoBlock( )
    mvars.f30050_finishSetupScriptBlock = true
    if not mvars.f30050_isHeliStart then
      TppMain.EnableAllGameStatus()
      TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "OnEndGameStartFadeIn" )
    end
  end,
}

sequences.Seq_Game_HeliStart = {
  OnEnter = function()

    f30050_enemy.SetupSalutationEnemy()

    TppSequence.SetNextSequence("Seq_Game_Setup")

    mvars.f30050_isHeliStart = true
  end,
}

this.SetDDogArea = function(  )
  if vars.buddyType == BuddyType.DOG then
    local clusterName = mtbs_cluster.GetCurrentClusterName()
    local plntName = mtbs_cluster.GetCurrentPlnt()
    local pos = mtbs_cluster.GetDemoCenter( clusterName, plntName )
    local gameObjectId = { type = "TppBuddyDog2", index = 0 }
    local radius=45.0--tex shifted out from command
    if Ivars.mbEnableBuddies:Is(1) then--tex>
      radius=3000
    end--<
    GameObject.SendCommand( gameObjectId, { id = "SetMotherBaseCenterAndRadius", center = pos, radius = radius } )
  end
end

sequences.Seq_Game_MainGame = {
  Messages = function( self )
    return
      StrCode32Table {
        Player = {
          {
            msg = "LandingFromHeli",
            func = function()

              f30050_enemy.UnsetSalutationEnemy()


              mtbs_baseTelop.DispBaseName()

              this.SetDDogArea()
            end
          },
          {
            msg = "OnPickUpCollection",
            func = function( gameObjectId, collectionUniqueId, collectionTypeId )
              if collectionUniqueId == TppCollection.GetUniqueIdByLocatorName( "ly003_cl04_collct0000|cl04pl0_uq_0040_collct|col_photo_paz" ) then
                TppTerminal.AcquireKeyItem{
                  dataBaseId			= TppMotherBaseManagementConst.PHOTO_1010,
                  isShowAnnounceLog	= true,
                }
                TppUI.ShowAnnounceLog("quest_get_photo", "key_photo_1010" )
              end
            end
          },
        },
        GameObject = {
          {
            msg = "HeliDoorClosed", sender = "SupportHeli",
            func = function ()
              Fox.Log("Mission clear : on Heli")
              this.ReserveMissionClear()
            end
          },
          {
            msg = "LandedAtLandingZone", sender = "SupportHeli",
            func = function()
              svars.isArrivedLandingzoneHeli = true
              this.FadeOutIfCanPlayRideOnHeliDemo()
            end
          },
          {
            msg = "SwitchGimmick",
            func = function(gameObjectId, gameObjectName, name, switchFlag)

              if gameObjectName == StrCode32("ly003_cl04_item0000|cl04pl0_uq_0040_gimmick2|gntn_swtc001_vrtn001_gim_n0000|srt_gntn_swtc001_vrtn001") then
                this.PushSwitchOnEnterPazRoom()
                return
              end

              if gameObjectName == StrCode32("ly003_cl02_item0000|cl02pl0_uq_0020_gim_onlymb2|gntn_swtc001_vrtn001_gim_n0000|srt_gntn_swtc001_vrtn001") then
                this.PushSwitchOnEnterBattleHanger()
                return
              end
            end,
          },
          {
            msg = "RoutePoint2",
            func = function(gameObjectId, routeId, routeNode, message)
              Fox.Log("route:" ..routeId)
              if message == StrCode32("DisableOcelot") then
                f30050_demo.DisableOcelot()
              elseif message == StrCode32("DisableDemoEndRoute") then
                local command = { id = "SetSneakRoute", route = "" }
                SendCommand( gameObjectId, command )
              end
            end,
          },
        },
        UI = {
          {
            msg = "EndFadeOut",sender = "OnEndFadeOutPlayRideOnHeliDemo",
            func = function ()
              f30050_demo.PlayMtbsEventDemo{
                demoName = mvars.f30050_demoName,
              }
            end,
          },
        },
        Terminal = {
          {
            msg = "MbDvcActAcceptMissionList", func = this.AcceptMission,
          },
          {
            msg = "MbDvcActCallRescueHeli" , func = this.CallRescueHeli,
          },
          {
            msg = "MbDvcActSelectLandPointTaxi", func = this.OnSelectLandPointTaxi,
          },
        },
        MotherBaseStage = {
          {
            msg = "MotherBaseCurrentClusterLoadStart",
            func = function(clusterId)
              this.DoLoadStartCluster(clusterId)
            end,
          },
          {
            msg = "MotherBaseCurrentClusterActivated",
            func = function(clusterId)
              this.DoActivatedCluster(clusterId)
            end,
          },
          {
            msg = "MotherBaseCurrentClusterDeactivated",
            func = function(clusterId)
              this.DeactivatedCluster(clusterId)
            end,
          },
        },
        Trap = {
          {
            msg = "Enter",
            sender = "mtbs_uq0040_plnt0000|uq_00400000|uq_0040_path0000|trap_toQuietPrison",
            func = function()
              if not TppQuest.IsActive("mtbs_q99011")
                and TppStory.CanArrivalQuietInMB(false)
                and (not isPlayedAfterDeathFactory) then--RETAILBUG TYPO should be svars.isPlayedAfterDeathFactory
                GameObject.SendCommand( { type="TppMbQuiet", index=0 }, { id="StartWakeUp", isLoop=true, isAll=false } )
              end
            end,
          },
          {
            msg = "Enter",
            sender = "mtbs_uq0040_plnt0000|uq_00400000|uq_0040_asset|QuietAudioAreaTrap",
            func = function()
              this.PlayMusicFromQuietRoom()
            end,
          },
          {
            msg = "Exit",
            sender = "mtbs_uq0040_plnt0000|uq_00400000|uq_0040_asset|QuietAudioAreaTrap",
            func = function()
              this.StopMusicFromQuietRoom()
            end,
          },
          {
            msg = "Enter",
            sender = "mtbs_uq0040_plnt0000|uq_00400000|uq_0040_asset|QuietAudioTelopAreaTrap",
            func = function()
              mvars.f30050_isInQuietAudioTelopArea = true
              this.ShowMusicTeropInQuietRoom( mvars.f30050_quietRadioName )
            end,
          },
          {
            msg = "Exit",
            sender = "mtbs_uq0040_plnt0000|uq_00400000|uq_0040_asset|QuietAudioTelopAreaTrap",
            func = function()
              mvars.f30050_isInQuietAudioTelopArea = false
            end,
          },
          {
            msg = "Enter",
            sender = "TrapRideOnHeliDemo",
            func = function()
              svars.isEnterTrapRideOnHeliDemo = true
              this.FadeOutIfCanPlayRideOnHeliDemo()
            end,
          },
          {
            msg = "Exit",
            sender = "TrapRideOnHeliDemo",
            func = function()
              svars.isEnterTrapRideOnHeliDemo = false
            end,
          },
          {
            msg = "Enter",
            sender = {
              "trap_RequestToDropCbox0000",
              "trap_RequestToDropCbox0001",
              "trap_RequestToDropCbox0002",
            },
            func = function( trapId )
              this.EnterRequestToDropCbox( trapId )
            end,
          },
          {
            msg = "Exit",
            sender = {
              "trap_RequestToDropCbox0000",
              "trap_RequestToDropCbox0001",
              "trap_RequestToDropCbox0002",
            },
            func = function( trapId )
              this.ExitRequestToDropCbox( trapId )
            end,
          },
          {
            msg = "Enter",
            sender = "trap_sol_fulton",
            func = function( trapName, gameObjectId )
              if Tpp.IsSoldier( gameObjectId ) then
                Fox.Log(" ForceFulton: " ..tostring(gameObjectId) )
                if InfMainTpp.IsMbEvent() then--tex added bypass
                  GameObject.SendCommand( gameObjectId, { id = "RequestForceFulton" } )
                end
              end
            end,
          },
        },
        Timer = {
          {
            msg = "Finish",
            sender = "TimerRequestToDropCbox",
            func = function()
              this.StartRequestToDropCbox()
            end,
          },
        },
      }
  end,
  OnEnter = function()
    if not mvars.f30050_finishSetupScriptBlock then

      TppSequence.SetNextSequence("Seq_Game_Setup")
      return
    end
    Fox.Log("MB Free Game Start!")
    TppDemo.EnableInGameFlagIfResereved()


    TppUiStatusManager.UnsetStatus( "MbMap", "BLOCK_TAXI_CHANGE_LOCATION" )

    this.SetDefaultPlayerDisableAction()


    TppMusicManager.ResumeMusicPlayer()

    TppQuest.SetQuestBlockName( SCRIPT_BLOCK_NAME )


    GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetAutoWithdrawalEnabled", enabled=false } )



    this.DisableLandingZoneForSeparationPlatform()

    if InfNPCHeli then InfNPCHeli.enabledLzs={} end--tex
    for clusterId, clusterName in ipairs( TppDefine.CLUSTER_NAME ) do
      mtbs_cluster.SetUpLandingZone( this.CLST_PARAM[clusterId].LANDING_ZONE, clusterId )
    end

    this.PlayRadioAfterDemo()


    if not svars.isPlayedFreeHeliRadio then
      TppFreeHeliRadio.OnEnter()
      svars.isPlayedFreeHeliRadio = true
    end

    mvars.f30050_scriptBlockIndex = ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME)
    mvars.f30050_prevScriptBlockState = ScriptBlock.GetScriptBlockState(mvars.f30050_scriptBlockIndex)

    f30050_radio.SetOptionalRadioFromSituation()

    this.GetCassetTape()


    if not mvars.f30050_isHeliStart then
      mtbs_baseTelop.DispBaseName()
    end
  end,
  OnUpdate = function()

    local state = ScriptBlock.GetScriptBlockState(mvars.f30050_scriptBlockIndex)
    if state == ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE and state > mvars.f30050_prevScriptBlockState then
      if not mvars.f30050_isSkipEnemyActivatePazRoomFromMainGame then
        mtbs_enemy.OnActivateDemoBlock()
      end
      mvars.f30050_isSkipEnemyActivatePazRoomFromMainGame = nil
    end
    mvars.f30050_prevScriptBlockState = state


    this.UpdateQuietRadio()
  end,
  OnLeave = function()
    TppFreeHeliRadio.OnLeave()

    TppUiCommand.HideMusicTelop()
  end,
}

function this.OnSelectLandPointTaxi(nextMissionId, routeName, layout, clusterId)
  if nextMissionId == 30250 then
    clusterId = 7
  end
  Fox.Log("missionId: " ..tostring(nextMissionId)  .. " :routeName: " ..tostring(routeName) .. " :layout:" .. tostring(layout) .. " :clusterId: " .. tostring(clusterId) )
  this.ReserveMissionClear(nextMissionId, routeName, layout, clusterId )
end


function this.CallRescueHeli()
  if this.IsRideOnHeliDemo( mvars.f30050_demoName ) then
    TppSequence.SetNextSequence("Seq_Demo_Wait_FadeOut_Sortie")
  end
end

function this.GetCassetTape()

  local storySeqeunce = TppStory.GetCurrentStorySequence()
  if storySeqeunce >= TppDefine.STORY_SEQUENCE.CLEARD_OKB_ZERO then
    TppCassette.Acquire{
      cassetteList = { "tp_bgm_11_33" },
      isShowAnnounceLog = { delayTimeSec = 2.0 },
    }
  end

end

function this.PlayRadioAfterDemo()
  if svars.requestPlayAfterDemoRadioIndex ~= 0 then
    local radioNames = TppStory.GetStoryRadioListFromIndex( "afterMBDemo", svars.requestPlayAfterDemoRadioIndex )
    TppRadio.Play( radioNames, {isEnqueue = true, delayTime = TppRadio.PRESET_DELAY_TIME.long } )
    svars.requestPlayAfterDemoRadioIndex = 0
    if radioNames and radioNames[1] then
      if radioNames[1] == "f2000_rtrg8350" then
        TppCassette.Acquire{ cassetteList = {"tp_m_10160_11"}, isShowAnnounceLog = { delayTimeSec = 2.0 } }
      end
    end
  end
end

function this.DoActivatedCluster(clusterId)

  if TppQuest.GetCurrentQuestName() then
    TppQuest.InitializeQuestActiveStatus(clusterId+1)
  else
    mtbs_enemy.OnActivateDemoBlock(clusterId+1)
  end

  if clusterId == TppDefine.CLUSTER_DEFINE.Medical then
    this.UpdatePazPhase()
  end

  this.EnableAssetsOnCluster(clusterId)

  if clusterId ~= TppDefine.CLUSTER_DEFINE.Medical then
    this.StopMusicFromQuietRoom()
  end
end

function this.DeactivatedCluster(clusterId)
  if clusterId > #TppDefine.CLUSTER_NAME then
    return
  end
  TppQuest.DeactivateCurrentQuestBlock()
  TppQuest.ClearBlockStateRequest()
  mtbs_enemy.OnDeactivateDemoBlock(clusterId+1)

  this.SwitchSahelanModel(false)
end

function this.DoLoadStartCluster(clusterId)
  this.RegisterFovaFpk(clusterId)
  if this.IsNeedLoadRideOnHeliDemo(clusterId) then
    f30050_demo.UpdatePackList( mvars.f30050_demoName )
    TppScriptBlock.LoadDemoBlock( mvars.f30050_demoName, true )
  else
    local loadQuestName = TppQuest.OnUpdateClusterIndex( clusterId + 1 )
    if not loadQuestName then
      f30050_demo.UpdatePackList( "Empty" )
      TppScriptBlock.LoadDemoBlock( "Empty", true )
    end
  end

  if this.IsRideOnHeliDemo( mvars.f30050_demoName ) then
    this.SetEnableQuestUI( clusterId ~= TppDefine.CLUSTER_DEFINE.Command )
  else

    this.SetEnableQuestUI( true )
    TppQuest.UnregisterClusterForceDeactiveOnMBTerminal( )
  end
end

this.SetEnableQuestUI = function( isEnable )
  if isEnable then
    TppUiStatusManager.UnsetStatus( "QuestAreaAnnounce", "INVALID" )
    TppUiStatusManager.UnsetStatus( "SideFobInfo", "INVALID" )
  else
    TppUiStatusManager.SetStatus( "QuestAreaAnnounce", "INVALID" )
    TppUiStatusManager.SetStatus( "SideFobInfo", "INVALID" )
  end
end


function this.UpdateQuietRadio()
  if mvars.f30050_quietRadioName then
    this.ShowMusicTeropInQuietRoom( mvars.f30050_quietRadioName )
    if not TppMusicManager.IsPlayingPositionalMusic( mvars.f30050_quietRadioName ) then

      this.PlayMusicFromQuietRoom()
    end
  end
end


function this.PlayMusicFromQuietRoom()
  if TppStory.CanArrivalQuietInMB( false ) and not TppQuest.IsActive("mtbs_q99011") then
    local totalPlayTime = TppScriptVars.GetTotalPlayTime()
    local radioIndex = totalPlayTime%(#QUIET_RADIO_TELOP_LANG_LIST) + 1
    if Ivars.quietRadioMode:Is()>0 then--tex
      radioIndex=Ivars.quietRadioMode:Get()
    end--
    mvars.f30050_quietRadioName = string.format("sfx_m_prison_radio_%02d",radioIndex )
    mvars.f30050_requestShowUIQuietRadioName = QUIET_RADIO_TELOP_LANG_LIST[radioIndex]
    local position = Tpp.GetLocator("quiet_AssetIdentifier", "radio_pos")
    if position == nil then
      return
    end
    TppMusicManager.PlayPositionalMusic( mvars.f30050_quietRadioName, Vector3(position[1], position[2], position[3]) )

    mvars.f30050_requestShowUIQuietRadio = true
    Fox.Log("PlayQuietRadio:"..tostring(mvars.f30050_quietRadioName) )
  end
end
function this.StopMusicFromQuietRoom()
  if mvars.f30050_quietRadioName then
    TppMusicManager.StopPositionalMusic()
    mvars.f30050_quietRadioName = nil
    mvars.f30050_requestShowUIQuietRadioName = nil
  end
end


function this.ShowMusicTeropInQuietRoom( radioName )
  if mvars.f30050_requestShowUIQuietRadioName and mvars.f30050_isInQuietAudioTelopArea then

    if TppMusicManager.IsPlayingPositionalMusic( radioName ) then

      TppUiCommand.ShowMusicTelop( mvars.f30050_requestShowUIQuietRadioName, 10.0 )
      mvars.f30050_requestShowUIQuietRadioName = nil
      return
    end
  end
end

function this.PushSwitchOnEnterBattleHanger()
  do
    local pos = { -30.980, -7.500, 14.779 }
    local rotY = 0
    local pos, rotY = mtbs_cluster.GetPosAndRotY( "Develop", "plnt0", pos, rotY )
    local distance = (pos[1] - vars.playerPosX) * ( pos[1] - vars.playerPosX ) + ( pos[2] - vars.playerPosY ) * (pos[2] - vars.playerPosY) + (pos[3] - vars.playerPosZ) * ( pos[3] - vars.playerPosZ )
    if distance > 9.0 then
      return
    end
  end
  if TppStory.GetBattleGearDevelopLevel() >= 0 then

    TppSound.HaltSceneBGM()

    this.SetEnableQuestUI(false)

    local dataSetName = "/Assets/tpp/level/location/mtbs/block_area/ly00" ..tostring(vars.mbLayoutCode) .."/cl02/mtbs_ly00" ..tostring(vars.mbLayoutCode).. "_cl02_item.fox2"
    local dataName = "ly003_cl02_item0000|cl02pl0_uq_0020_gim_onlymb2|mtbs_door006_door002_ev_gim_n0000|srt_mtbs_door006_door002_ev"
    Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, dataName, dataSetName, false)

    local soundPos = this.GetPositionOuterBattleHangerDoor()
    TppSoundDaemon.PostEvent3D( "sfx_m_hanger_door_open", Vector3(soundPos[1],soundPos[2],soundPos[3]), 'Loading')

    TppMission.Reload{
      missionPackLabelName = "BattleHanger",
      clusterId = TppDefine.CLUSTER_DEFINE.Command,
      OnEndFadeOut = function()
        svars.restartClusterId = TppDefine.CLUSTER_DEFINE.Command
        TppSave.ReserveVarRestoreForContinue()
        this.SetPlayerInitialPositionInBattleHanger()
        TppSequence.ReserveNextSequence( "Seq_Demo_BattleHanger" )
      end,
    }
  else
    local playerPos = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
    local soundPos = playerPos + Quat.RotationY( vars.playerRotY ):Rotate( Vector3(-0.65,0.35,0.3) )
    TppSoundDaemon.PostEvent3D( "sfx_m_door_buzzer", soundPos )
  end
end

function this.SetPlayerInitialPositionInBattleHanger()
  TppPlayer.SetInitialPosition({-11.600, -8.000, 8.511}, 180 )
  vars.playerCameraRotation[0] = -10
  vars.playerCameraRotation[1] = 200
end

function this.WarpToBattleHanger()
  TppPlayer.Warp{ pos = {-11.600, -8.000, 8.511}, rotY = 180}
  Player.RequestToSetCameraRotation{rotX =-10 , rotY = 200 }
end

function this.SetCameraPushSwitch( )
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
end

function this.PushSwitchOnEnterPazRoom()
  do
    local pos = Tpp.GetLocator("mtbs_pazRoom_Locator", "out")
    local distance = (pos[1] - vars.playerPosX) * ( pos[1] - vars.playerPosX ) + ( pos[2] - vars.playerPosY ) * (pos[2] - vars.playerPosY) + (pos[3] - vars.playerPosZ) * ( pos[3] - vars.playerPosZ )
    if distance > 9.0 then
      return
    end
  end
  this.UpdatePazPhase()
  if this.CanEnterPazRoom() then
    TppSequence.SetNextSequence("Seq_Game_PazWaitMainGameFinish")
  else
    local playerPos = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
    local soundPos = playerPos + Quat.RotationY( vars.playerRotY ):Rotate( Vector3(-0.65,0.35,0.3) )
    TppSoundDaemon.PostEvent3D( "sfx_m_door_buzzer", soundPos )
  end
end

function this.FadeOutIfCanPlayRideOnHeliDemo()
  if this.CanPlayRideOnHeliDemo() then
    TppUI.FadeOut(TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "OnEndFadeOutPlayRideOnHeliDemo")
  end
end

function this.CanPlayRideOnHeliDemo()
  return this.IsRideOnHeliDemo( mvars.f30050_demoName )
    and svars.isArrivedLandingzoneHeli
    and svars.isEnterTrapRideOnHeliDemo
end

function this.DisableLandingZoneForDemo()

  local gameObjectId = GameObject.GetGameObjectId( "SupportHeli" )
  for clusterId, clusterName in ipairs( TppDefine.CLUSTER_NAME ) do
    for _, landingZoneNameList in ipairs( this.CLST_PARAM[clusterId].LANDING_ZONE ) do
      for __, landingZoneName in ipairs( landingZoneNameList ) do
        if LANDING_ZONE_USE_SORTIE_DEMO ~= landingZoneName then
          GameObject.SendCommand( gameObjectId, { id = "DisableLandingZone", name = landingZoneName })
        end
      end
    end
  end
end

function this.DisableLandingZoneForSeparationPlatform()
  local gameObjectId = GameObject.GetGameObjectId( "SupportHeli" )
  GameObject.SendCommand( gameObjectId, { id = "DisableLandingZone", name = "ly003_cl07_30050_heli0000|cl07pl0_mb_fndt_plnt_heli_30050|lz_plnt" })
end

function this.ReserveMissionClear(nextMissionId, nextHeliRoute, nextLayoutCode, nextClusterId )
  local missionClearType = TppDefine.MISSION_CLEAR_TYPE.HELI_TAX_MB_FREE_CLEAR
  if nextMissionId == nil then
    nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_HELI
    missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER
    nextLayoutCode = nil
    nextClusterId = nil
  end
  TppDemo.SetNextMBDemo()

  TppMission.ReserveMissionClear{
    missionClearType = missionClearType,
    nextMissionId = nextMissionId,
    nextHeliRoute = nextHeliRoute,
    nextLayoutCode = nextLayoutCode,
    nextClusterId = nextClusterId,
  }
end

function this.EnableDistributionCenter()
  if gvars.f30050_missionPackIndex ~= STAGE_PACK_INDEX.NORMAL then return end
  for clusterName, clusterId in pairs(TppDefine.CLUSTER_DEFINE) do
    local grade = TppLocation.GetMbStageClusterGrade( clusterId+1 )
    local isEnable = grade > 0
    TppDataUtility.SetVisibleDataFromIdentifier( "DataIdentifierDistributionCenter",clusterName,isEnable, false )
  end
end

function this.EnableQuietMarker()
  local  markerName = "QuietMarkerLocator_ly00" ..tostring(vars.mbLayoutCode)
  if TppRadio.IsPlayed( "f2000_rtrg1345" ) and TppStory.CanArrivalQuietInMB( false ) then
    TppMarker.Enable(markerName,1,"none", "map_and_world_only_icon", 0, false, true , nil, "marker_q_jailcell")
  else
    TppMarker.Disable(markerName)
  end
end

function this.EnableBattleHangerMarker()
  local  markerName = "BattleHangerMarkerLocator_ly00" ..tostring(vars.mbLayoutCode)
  if TppStory.GetBattleGearDevelopLevel() >= 0 then
    TppMarker.Enable(markerName,1,"none", "map_and_world_only_icon", 0, false, true , nil, "marker_bg_hangar")
  else
    TppMarker.Disable(markerName)
  end
end


function this.EnableAssetsOnCluster(clusterId)
  Fox.Log("EnableClusterAssets:clusterId: " ..tostring(clusterId) )
  if clusterId >= #TppDefine.CLUSTER_NAME
    or MotherBaseStage.GetCurrentCluster() >= #TppDefine.CLUSTER_NAME then
    Fox.Log("Skip EnableAssetOnCluster: clusterId " ..tostring(clusterId) )
    return
  end
  if clusterId == TppDefine.CLUSTER_DEFINE.Command then
    this.EnableBiggBossPosters()
    this.EnableNuclearEliminationMonument()
    TppDataUtility.SetVisibleDataFromIdentifier( "mtbs_plant0", "p61_010030_after", svars.isVisibleBrokenHanger, false)
  elseif clusterId == TppDefine.CLUSTER_DEFINE.Medical then
    this.EnableQuietSolitaryConfinementAssets()
    this.ChangeLightColorOnPazRoom()
    this.ChangeSignboardVisibilityOnPazRoom()

    TppDataUtility.SetVisibleDataFromIdentifier( "peacesymbol_AssetIdentifier", "peacesymbol", true, false)

    this.EnablePazRoom( false )

    this.UpdatePazPhotoCollection()
  elseif clusterId == TppDefine.CLUSTER_DEFINE.Develop then
    this.EnableSwitchBatlleHanger()
  end
  this.SwitchSahelanModel(clusterId == TppDefine.CLUSTER_DEFINE.Develop)

  if Ivars.mbUnlockGoalDoors:Get()~=1 then--tex added mbunlock
    this.LockGoalDoor( clusterId )
  end
end


function this.EnableSwitchBatlleHanger()
  if TppStory.GetBattleGearDevelopLevel() >= 0 then
    TppDataUtility.SetVector4EffectFromId("BattleHangerDoorLightOnEnter", "Color", 0.0, 1.0, 0.5, 0.5 )
  else
    TppDataUtility.SetVector4EffectFromId("BattleHangerDoorLightOnEnter", "Color", 1.0, 0.0, 0.0, 1.0 )
  end
end


function this.SwitchSahelanModel(isHighModel)
  if not TppStory.CanArrivalSahelanInMB() then

    TppDataUtility.SetVisibleDataFromIdentifier( "MtbsCommon", "sahelan_spl", false, false )
    return
  end


  TppDataUtility.SetVisibleDataFromIdentifier( "MtbsCommon", "sahelan_spl", not isHighModel, false )

  if isHighModel then
    if gvars.f30050_missionPackIndex == STAGE_PACK_INDEX.NORMAL then
      TppDataUtility.SetVisibleDataFromIdentifier( "sahelanIdentifier", "sahelanA", isHighModel, false )
      TppDataUtility.SetVisibleDataFromIdentifier( "sahelanIdentifier", "sahelanB", isHighModel, false )
      TppDataUtility.SetVisibleDataFromIdentifier( "sahelanIdentifier", "sahelanC", isHighModel, false )
      TppDataUtility.SetVisibleDataFromIdentifier( "sahelanIdentifier", "sahelanD", isHighModel, false )
      TppDataUtility.SetVisibleDataFromIdentifier( "sahelanIdentifier", "sahelanE", isHighModel, false )
    end
  end
end


function this.LockGoalDoor( clusterId )
  local layoutCode = vars.mbLayoutCode
  local dataSetPath = "/Assets/tpp/level/location/mtbs/block_area/ly00" .. tostring(layoutCode) .. "/cl0" .. tostring(clusterId).."/mtbs_ly00" .. tostring(layoutCode) .. "_cl0"..tostring(clusterId).."_item.fox2"
  local goalDoorList = FOB_GOAL_DOOR_LIST[clusterId]
  if goalDoorList == nil then
    Fox.Log("goalDoorList is nil. Skip LockGoalDoor:" ..tostring(clusterId) )
    return
  end
  for i, doorName in ipairs(goalDoorList) do
    Gimmick.SetEventDoorLock( doorName, dataSetPath, true, 0 )
  end
end


function this.UpdatePazPhotoCollection()
  if this.GetPazLookedPictureCount() >= 10 and not TppMotherBaseManagement.IsGotDataBase{ dataBaseId=TppMotherBaseManagementConst.PHOTO_1010 } then
    TppCollection.SetDisabledInGame( "ly003_cl04_collct0000|cl04pl0_uq_0040_collct|col_photo_paz", false )
  else
    TppCollection.SetDisabledInGame( "ly003_cl04_collct0000|cl04pl0_uq_0040_collct|col_photo_paz", true )
  end
end


function this.UpdateCommonCollection()
  if gvars.f30050_missionPackIndex == 0 then

    if TppQuest.IsCleard("commFacility_q80060") then
      TppCollection.RepopCountOperation( "SetAt", "ly003_cl00_collct0000|cl00pl0_uq_0000_collct|col_POSTER_MTBS_H_0000", 0 )
      TppCollection.RepopCountOperation( "SetAt", "ly003_cl00_collct0000|cl00pl0_uq_0000_collct|col_POSTER_MTBS_V_0000", 0 )
    else
      TppCollection.RepopCountOperation( "SetAt", "ly003_cl00_collct0000|cl00pl0_uq_0000_collct|col_POSTER_MTBS_H_0000", 1 )
      TppCollection.RepopCountOperation( "SetAt", "ly003_cl00_collct0000|cl00pl0_uq_0000_collct|col_POSTER_MTBS_V_0000", 1 )
    end

    if TppQuest.IsActive("mtbs_q99011") and (not TppUiCommand.HasEmblemTexture( "front9" ) ) then
      TppCollection.RepopCountOperation( "SetAt", "ly003_cl04_collct0000|cl04pl0_uq_0040_collct|col_emblem_quiet", 0 )
    else
      TppCollection.RepopCountOperation( "SetAt", "ly003_cl04_collct0000|cl04pl0_uq_0040_collct|col_emblem_quiet", 1 )
    end

    local nShowflag = 0
    if TppUiCommand.HasEmblemTexture( "front8" ) then
      nShowflag = 1
    else
      nShowflag = 0
    end
    TppCollection.RepopCountOperation( "SetAt", "ly003_cl00_collct0000|cl00pl0_uq_0000_collct|col_develop_MTBS_0000", nShowflag )

    if TppUiCommand.HasEmblemTexture( "front10" ) then
      nShowflag = 1
    else
      nShowflag = 0
    end
    TppCollection.RepopCountOperation( "SetAt", "ly003_cl00_collct0000|cl00pl0_uq_0000_collct|col_develop_MTBS_0001", nShowflag )

    if TppUiCommand.HasEmblemTexture( "front15" ) then
      nShowflag = 1
    else
      nShowflag = 0
    end
    TppCollection.RepopCountOperation( "SetAt", "ly003_cl00_collct0000|cl00pl0_uq_0000_collct|col_develop_MTBS_0002", nShowflag )

    if TppUiCommand.HasEmblemTexture( "front16" ) then
      nShowflag = 1
    else
      nShowflag = 0
    end
    TppCollection.RepopCountOperation( "SetAt", "ly003_cl00_collct0000|cl00pl0_uq_0000_collct|col_develop_MTBS_0003", nShowflag )
  end
end


function this.EnableNuclearEliminationMonument()
  if TppDemo.IsPlayedMBEventDemo("NuclearEliminationCeremony") or Ivars.mbShowMbEliminationMonument:Is(1) then--tex added mbshow
    TppDataUtility.SetVisibleDataFromIdentifier( "mtbs_plant0", "p51_020010_after", true, false)
  end
end

function this.EnableQuietSolitaryConfinementAssets()
  local isEnable = TppStory.CanArrivalQuietInMB( true ) or Ivars.mbShowQuietCellSigns:Is(1)--tex added mbshow
  TppDataUtility.SetVisibleDataFromIdentifier( "quiet_AssetIdentifier", "only_motherbase", isEnable, false)
end


function this.EnableBiggBossPosters()
  if 	(TppDefine.STORY_SEQUENCE.CLEARD_OKB_ZERO <= TppStory.GetCurrentStorySequence()
    and not TppStory.IsMissionCleard( 10240 ))
    or Ivars.mbShowBigBossPosters:Is(1) then--tex added mbshow
    local plantCount = MotherBaseStage.GetCompletionPlantCount()
    if plantCount >= 1 then
      TppDataUtility.SetVisibleDataFromIdentifier( "mtbs_plant0", "bwy00", true, false)
      TppDataUtility.SetVisibleDataFromIdentifier( "mtbs_plant0", "bwy01", true, false)
    end
    if plantCount >= 2 then
      TppDataUtility.SetVisibleDataFromIdentifier( "mtbs_plant1", "bwy00", true, false)
    end
    if plantCount >= 3 then
      TppDataUtility.SetVisibleDataFromIdentifier( "mtbs_plant2", "bwy00", true, false)
    end
    if plantCount >= 4 then
      TppDataUtility.SetVisibleDataFromIdentifier( "mtbs_plant3", "bwy00", true, false)
    end
  end
end


function this.ChangeLightColorOnPazRoom()
  this.UpdatePazPhase()
  if this.CanEnterPazRoom() then
    TppDataUtility.SetVector4EffectFromId("PazRoomDoorLight", "Color", 0.0, 1.0, 0.5, 0.5 )
  else
    TppDataUtility.SetVector4EffectFromId("PazRoomDoorLight", "Color", 1.0, 0.0, 0.0, 1.0 )
  end
end


function this.ChangeSignboardVisibilityOnPazRoom()
  this.UpdatePazPhase()
  TppDataUtility.SetVisibleDataFromIdentifier( "uq_0040_paz_room_AssetIdentifier", "paz_room_signboard", not this.CanEnterPazRoom(), false )
end


function this.SetUniqueCharaVisibility( enable )
  if mvars.f30050_isSetLiquid == true or Ivars.mbShowEli:Is(1) then--tex added mbshow
    if Ivars.mbShowEli:Is(1) then enable = true end--tex
    if InfMainTpp.IsMbEvent() then enable = false end--tex

    TppDataUtility.SetVisibleDataFromIdentifier( "f30050_liquid_DataIdentifier",		 "Liquid",		enable, false )
  end
  if mvars.f30050_isSetCodeTalker == true or Ivars.mbShowCodeTalker:Is(1) then--tex added mbshow
    if Ivars.mbShowCodeTalker:Is(1) then enable = true end--tex
    if InfMainTpp.IsMbEvent() then enable = false end--tex
    TppDataUtility.SetVisibleDataFromIdentifier( "f30050_codeTolker_DataIdentifier",	"CodeTalker",	enable, false )
  end
end


local requestToDropCboxTable = {
  { trapName = "trap_RequestToDropCbox0000", time = 5, clusterConstruct = 2, position = Vector3( -27.911, 0.000, 2.630 ),		height = 25.0, },
  { trapName = "trap_RequestToDropCbox0001", time = 5, clusterConstruct = 2, position = Vector3( -16.651, 0.000, 12.570 ),	height = 25.0, },
  { trapName = "trap_RequestToDropCbox0002", time = 5, clusterConstruct = 3, position = Vector3( 16.883, 0.002, -11.817 ),	height = 25.0, },
}


function this.EnterRequestToDropCbox( trapId )
  local timerName = "TimerRequestToDropCbox"
  for i, params in ipairs( requestToDropCboxTable ) do
    if svars.isRequestToDropCbox == false then
      if trapId == StrCode32( params.trapName ) then
        mvars.requestToDropCboxIndex = i
        local clusterConstruct = mtbs_cluster.GetClusterConstruct( 1 )
        if clusterConstruct <= params.clusterConstruct then
          if not GkEventTimerManager.IsTimerActive( timerName ) then
            GkEventTimerManager.Start( timerName, params.time )
          end
        end
      end
    end
  end
end


function this.ExitRequestToDropCbox( trapId )
  local timerName = "TimerRequestToDropCbox"
  GkEventTimerManager.Stop( timerName )
end


function this.StartRequestToDropCbox()
  if svars.isRequestToDropCbox == false and mvars.requestToDropCboxIndex ~= 0 then
    svars.isRequestToDropCbox = true
    local requestToDropCboxData = requestToDropCboxTable[ mvars.requestToDropCboxIndex ]
    Player.RequestToDropCbox{ aimPosition = requestToDropCboxData.position, height = requestToDropCboxData.height }
  end
end






















local pazPhaseList = {
  [0] = {
    Update = function()
      if this.HasNewPicture() then

        return 1
      else
        return 0
      end
    end,
    packIndex = 3,
  },
  [1] = {
    Update = function()
      if TppDemo.IsPlayedMBEventDemo( PAZ_PACK_NAME_LIST[1] ) then
        return 2
      else
        return 1
      end
    end,
    packIndex = 1,
  },
  [2] = {
    Update = function()
      if svars.canReceivePicture then
        return 3
      else
        return 2
      end
    end,
    packIndex = 3,
  },
  [3] = {
    Update = function()
      if not svars.canReceivePicture then
        if this.GetPazLookedPictureCount() < 6 then
          return 2
        else
          return 4
        end
      else
        return 3
      end
    end,
    packIndex = 3,
  },
  [4] = {
    Update = function()
      if TppDemo.IsPlayedMBEventDemo( PAZ_PACK_NAME_LIST[2] ) then
        return 5
      else
        return 4
      end
    end,
    packIndex = 2,
  },
  [5] = {
    Update = function()
      if svars.canReceivePicture then
        return 6
      else
        return 5
      end
    end,
    packIndex = 3,
  },
  [6] = {
    Update = function()
      if not svars.canReceivePicture then
        if this.GetPazLookedPictureCount() < 10 then
          return 5
        else
          return 7
        end
      else
        return 6
      end
    end,
    packIndex = 3,
  },
  [7] = {
    Update = function()
      if svars.canReceivePicture and this.GetPlayerHasPictureNum() >= 11 then
        return 8
      else
        return 7
      end
    end,
    packIndex = 3,
  },
  [8] = {
    Update = function()
      if TppDemo.IsPlayedMBEventDemo( PAZ_PACK_NAME_LIST[4] )
        or TppDemo.IsPlayedMBEventDemo( PAZ_PACK_NAME_LIST[5] ) then
        return 9
      else
        return 8
      end
    end,
    packIndex = 4,
  },
}

function this.UpdatePazPhase()
  if gvars.pazEventPhase >= PAZ_PHASE_ID_FINISHED then
    return
  end
  gvars.pazEventPhase = pazPhaseList[gvars.pazEventPhase].Update()
end

function this.CanEnterPazRoom()
  return gvars.pazEventPhase > PAZ_PHASE_ID_NONE and gvars.pazEventPhase < PAZ_PHASE_ID_FINISHED
end

function this.GetCurrentPazPackName()
  local packIndex = pazPhaseList[gvars.pazEventPhase].packIndex

  if packIndex == 4 and TppGameSequence.GetTargetArea() == "Japan" then
    packIndex = 5
  end

  if DEBUG and TppDemo.DEBUG_TargetArea then
    if packIndex == 5 then
      packIndex = 4
    end
    if packIndex == 4 and TppDemo.DEBUG_TargetArea == "Japan" then
      packIndex = 5
    end
  end

  return PAZ_PACK_NAME_LIST[packIndex]
end

function this.EnablePazRoom( isEnable )

  TppDataUtility.SetVisibleDataFromIdentifier( "uq_0040_paz_room_AssetIdentifier", "paz_room_real", not isEnable, false)

  TppDataUtility.SetVisibleDataFromIdentifier( "uq_0040_paz_room_AssetIdentifier", "paz_room_phantom", isEnable, false)
  TppDataUtility.SetVisibleDataFromIdentifier( "uq_0040_paz_room_bed_AssetIdentifier", "paz_room_bed", isEnable, false )
  this.EnablePazRoomSwitch( isEnable )

  TppDataUtility.SetVisibleDataFromIdentifier( "uq_0040_paz_room_AssetIdentifier", "paz_room_phantom_door", true, false )

  local PAZ_PHOTO_LIST = { "photo01", "photo02", "photo03", "photo04", "photo05", "photo06", "photo07", "photo08", "photo09", "photo10", }
  for i=1, gvars.pazLookedPictureCount do
    TppDataUtility.SetVisibleDataFromIdentifier( "uq_0040_paz_room_AssetIdentifier", PAZ_PHOTO_LIST[i], isEnable, false )
  end

  TppDataUtility.SetEnableDataFromIdentifier( "mtbs_uni0040_155641_587", "Light_PazRoom", isEnable, false )
  TppDataUtility.SetEnableDataFromIdentifier( "mtbs_uni0040_155641_587", "Probe_PazRoom", isEnable, false )
  TppDataUtility.SetEnableDataFromIdentifier( "mtbs_uni0040_155641_587", "Trap_PazRoom", isEnable, false )

  local gameObjectId = GameObject.GetGameObjectId( "mtbs_uq0040_plnt0000|uq_00400000|uq_0040_asset|TppPazLocator" )
  if gameObjectId ~= NULL_ID then
    local command = { id="SetEnabled", enabled=isEnable }
    GameObject.SendCommand( gameObjectId, command )
  end


  if isEnable then
    TppWeather.RequestWeather( TppDefine.WEATHER.SUNNY, 0 )
  else
    TppWeather.CancelRequestWeather()
  end


  if isEnable then
    TppUiStatusManager.SetStatus( "QuestAreaAnnounce", "INVALID" )
  else
    TppUiStatusManager.UnsetStatus( "QuestAreaAnnouncsoe", "INVALID" )
  end


  if isEnable then
    GrTools.SetSubSurfaceScatterFade( 1.0 )
  else
    GrTools.SetSubSurfaceScatterFade( 0.0 )
  end
end

function this.EnablePazRoomSwitch( isEnable )
  local layoutCode = vars.mbLayoutCode
  local dataSetName = "/Assets/tpp/level/location/mtbs/block_area/ly00".. tostring(layoutCode) .. "/cl04/mtbs_ly00" ..tostring(layoutCode) .."_cl04_item.fox2"
  local switchOnLeavePazRoom = "ly003_cl04_item0000|cl04pl0_uq_0040_gimmick2|gntn_swtc001_vrtn001_gim_n0001|srt_gntn_swtc001_vrtn001"
  local switchOnEnterPazRoom = "ly003_cl04_item0000|cl04pl0_uq_0040_gimmick2|gntn_swtc001_vrtn001_gim_n0000|srt_gntn_swtc001_vrtn001"

  Gimmick.InvisibleGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, switchOnLeavePazRoom, dataSetName, not isEnable )
  Gimmick.InvisibleGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, switchOnEnterPazRoom, dataSetName, isEnable )
end


function this.SetPazMode()
  local pazFlag
  if svars.canReceivePicture then
    if this.HasNewPicture() then
      pazFlag = TppPaz.START_TYPE_PICTURE
    else
      pazFlag = TppPaz.START_TYPE_NO_PICTURE
    end
  else
    pazFlag = TppPaz.START_TYPE_DOWN
  end
  TppPaz.SetStartType(pazFlag)
  TppPaz.OnEnter(mvars.paz_isSkipPlayerInit)
end

function this.GetPazLookedPictureCount()
  return gvars.pazLookedPictureCount
end

function this.HasNewPicture()
  return gvars.pazLookedPictureCount < this.GetPlayerHasPictureNum()
end

function this.GetPlayerHasPictureNum()
  local hasPictureNum = 0
  for _ , dataBaseId in ipairs( PAZ_PHOTO_DATA_BASE_ID_LIST ) do
    if TppMotherBaseManagement.IsGotDataBase{ dataBaseId=dataBaseId } then
      hasPictureNum = hasPictureNum + 1
    end
  end
  return hasPictureNum
end

function this.SetPazSleepTime()
  local pazWakeTime = TppClock.GetTime("number") + PAZ_SLEEP_TIME
  TppClock.RegisterClockMessage("PazWakeUp", pazWakeTime )
end

function this.SetPazDone()
  svars.canReceivePicture = false
  this.SetPazSleepTime()
  this.UpdatePazPhase()
end

function this.DoPazGetPicture()
  gvars.pazLookedPictureCount = gvars.pazLookedPictureCount + 1
  this.SetPazDone()
end

function this.WarpPlayerEnterPazRoom()
  local pos, rotY = Tpp.GetLocator("mtbs_pazRoom_Locator", "enter")
  TppPlayer.Warp{ pos = pos, rotY = rotY }
end
function this.WarpPlayerOutPazRoom()
  local pos, rotY = Tpp.GetLocator("mtbs_pazRoom_Locator", "out")
  TppPlayer.Warp{ pos = pos, rotY = rotY }
end

function this.GetPazCassette()

  local pazLookPictureNum = this.GetPazLookedPictureCount()
  local cassetteList = { }
  if pazLookPictureNum >= 2 then
    table.insert( cassetteList, PAZ_CASSETTE_LIST[1] )
  end
  if pazLookPictureNum >= 4 then
    table.insert( cassetteList, PAZ_CASSETTE_LIST[2] )
  end
  if pazLookPictureNum >= 6 then
    table.insert( cassetteList, PAZ_CASSETTE_LIST[3] )
  end
  if pazLookPictureNum >= 8 then
    table.insert( cassetteList, PAZ_CASSETTE_LIST[4] )
  end
  if TppDemo.IsPlayedMBEventDemo( PAZ_PACK_NAME_LIST[4] )
    or TppDemo.IsPlayedMBEventDemo( PAZ_PACK_NAME_LIST[5] ) then
    table.insert( cassetteList, PAZ_CASSETTE_LIST[5] )
  end


  table.insert( cassetteList, PAZ_CASSETTE_LIST[6] )

  if #cassetteList > 0 then
    TppCassette.Acquire{ cassetteList = cassetteList, isShowAnnounceLog = true }
  end
end


function this.PazRoomOnLeave()
  mvars.f30050_finishSetupScriptBlock = true
  this.EnablePazRoom(false)
  this.ChangeLightColorOnPazRoom()
  this.ChangeSignboardVisibilityOnPazRoom()
  TppQuest.SetQuestBlockName( SCRIPT_BLOCK_NAME )
  local clusterId = mtbs_cluster.GetCurrentClusterId()
  this.RegisterFovaFpk(clusterId)
  TppQuest.InitializeQuestLoad( clusterId )
  TppQuest.InitializeQuestActiveStatus( clusterId )
  if not TppQuest.GetCurrentQuestName() then
    f30050_demo.UpdatePackList( "Empty" )
    TppScriptBlock.LoadDemoBlock( "Empty", true )
  end
  this.GetPazCassette()
  mtbs_enemy.SetEnableSoldierInCluster(TppDefine.CLUSTER_DEFINE.Medical+1 , false )
  Player.ResetPadMask {
    settingName = "PazRoom"
  }
  this.UpdatePazPhotoCollection()
  TppGameStatus.Reset("f30050_PazRoom","S_DISABLE_THROWING")
  TppGameStatus.Reset("f30050_PazRoom","S_DISABLE_PLACEMENT")
  TppGameStatus.Reset("f30050_PazRoom","S_IS_DEMO_CAMERA")

  this.SetEnableQuestUI(true)
  if Ivars.mbEnableLethalActions:Is(0) then--tex added check
    TppUiStatusManager.SetStatus( "EquipHudAll", "ALL_KILL_NOUSE" )
  end
  TppPaz.OnLeave()
  svars.isPazRoomStart = false
end







sequences.Seq_Game_PazWaitMainGameFinish = {
  OnEnter = function()

    Player.SetPadMask{
      settingName = "PazRoom",
      except = true,
    }
    TppUI.FadeOut(TppUI.FADE_SPEED.FADE_HIGHSPEED, "FadeOutEnterPazRoom" )

    TppGameStatus.Set("f30050_PazRoom","S_DISABLE_THROWING")
    TppGameStatus.Set("f30050_PazRoom","S_DISABLE_PLACEMENT")
    TppGameStatus.Set("f30050_PazRoom","S_IS_DEMO_CAMERA")
  end,
  Messages = function( self )
    return
      StrCode32Table {
        UI = {
          {
            msg = "EndFadeOut", sender = "FadeOutEnterPazRoom",
            func = function ()
              TppSequence.SetNextSequence("Seq_Game_PazDemoBlockUnload")

              if this.GetCurrentPazPackName() == PAZ_PACK_NAME_LIST[3] then
                TppSoundDaemon.PostEvent( "sfx_m_auto_door_paz" )
              end
            end,
          },
        },
      }
  end,
}




sequences.Seq_Game_PazDemoBlockUnload = {
  OnEnter = function()
    mvars.f30050_unloadingWaitCount = 1
    TppQuest.DeactivateCurrentQuestBlock()
    TppQuest.ClearBlockStateRequest()

    f30050_demo.RegisterFovaPack( {} )
    mtbs_enemy.OnDeactivateDemoBlock(mtbs_cluster.GetCurrentClusterId())
    mvars.f30050_isSkipEnemyActivatePazRoomFromMainGame = true

    this.WarpPlayerEnterPazRoom()

    Player.RequestToStopCameraAnimation{}

    svars.isPazRoomStart = true

    TppWeather.RequestWeather( TppDefine.WEATHER.SUNNY, 0 )

    this.EnablePazRoom(true)
  end,
  OnUpdate = function()
    if mvars.f30050_unloadingWaitCount > 0 then
      mvars.f30050_unloadingWaitCount = mvars.f30050_unloadingWaitCount - 1
    else
      TppSequence.SetNextSequence("Seq_Game_PazDemoBlockLoad")
    end
  end,
}

sequences.Seq_Game_PazDemoBlockLoad = {
  OnEnter = function()
    local packName = this.GetCurrentPazPackName()
    f30050_demo.UpdatePackList( packName )
    TppScriptBlock.LoadDemoBlock( packName, true )
  end,
  OnUpdate = function()
    local blockId = ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME)
    if ScriptBlock.GetScriptBlockState(blockId) == ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE then
      local packName = this.GetCurrentPazPackName()
      if packName == PAZ_PACK_NAME_LIST[1] then

        TppSequence.SetNextSequence("Seq_Game_PazAvatarLoad")
      else
        TppSequence.SetNextSequence("Seq_Demo_PazPlayDemo")
      end
    end
  end,
}

sequences.Seq_Game_PazAvatarLoad = {
  OnEnter = function()
    Fox.Log("Create Avatar for Demo")
  end,
  OnUpdate = function()
    if true then
      TppSequence.SetNextSequence("Seq_Demo_PazPlayDemo")
    end
  end,
}







sequences.Seq_Demo_PazPlayDemo = {
  OnEnter = function()
    local nextSequenceName = "Seq_Demo_PazRoomOnEnter"
    local packName = this.GetCurrentPazPackName()
    if packName == PAZ_PACK_NAME_LIST[3] then
      TppSequence.SetNextSequence(nextSequenceName)
    else
      f30050_demo.PlayMtbsEventDemo{
        demoName = packName,
        onEnd = function()
          if packName == PAZ_PACK_NAME_LIST[4] or packName == PAZ_PACK_NAME_LIST[5] then
            this.PazRoomOnLeave()
            TppSequence.SetNextSequence("Seq_Game_MainGame")
          else
            if DEBUG then
              if  packName ~= PAZ_PACK_NAME_LIST[1]
                and packName ~= PAZ_PACK_NAME_LIST[2] then
                Fox.Error("unknown pack name:" .. tostring(packName) )
              end
            end
            TppSequence.SetNextSequence(nextSequenceName)
            mvars.paz_isSkipPlayerInit = true
          end
        end,
        exceptGameStatus = {
          EquipHud = false,
          EquipPanel = false,
          AnnounceLog = false,
        },
      }
      mvars.f30050_skipPazRoomFadeIn = true
    end
  end,

  Messages = function( self )
    return
      StrCode32Table {
        Demo = {
          {
            msg = "DisablePhantomRoom",
            func = function()
              this.EnablePazRoom( false )

              TppDataUtility.SetVisibleEffectFromGroupId("PazRoomFx",false, false)
            end,
            option = { isExecDemoPlaying = true },
          },
        },
      }
  end,

  OnLeave = function()
    svars.restartClusterId = MotherBaseStage.GetCurrentCluster()
    TppMission.UpdateCheckPoint{
      checkPoint = "CHK_PazRoom",
      atCurrentPosition = true,
    }
  end,
}

sequences.Seq_Demo_PazRoomOnEnter = {
  OnEnter = function()
    Fox.Log("Enter PazRoomSetup")
    mvars.f30050_waitPazBlockLoad = true
    vars.playerDisableActionFlag = PlayerDisableActionFlagInPazRoom
    Player.ResetPadMask {
      settingName = "PazRoom"
    }
    Player.SetPadMask {

      settingName = "PazRoom",

      except = false,

      buttons = PlayerPad.CQC
      + PlayerPad.HOLD
      + PlayerPad.FIRE
      + PlayerPad.STANCE
      + PlayerPad.RELOAD
      + PlayerPad.EVADE
      + PlayerPad.CALL
      + PlayerPad.MB_DEVICE
      + PlayerPad.UP
      + PlayerPad.DOWN
      + PlayerPad.LEFT
      + PlayerPad.RIGHT,
    }
    mtbs_enemy.OnDeactivateDemoBlock(mtbs_cluster.GetCurrentClusterId())
    if not mvars.paz_isSkipPlayerInit then
      TppPaz.InitPlayer()
    end
    TppWeather.RequestWeather( TppDefine.WEATHER.SUNNY, 0 )


    this.EnablePazRoom(true)
  end,
  OnUpdate = function(self)
    if mvars.f30050_waitPazBlockLoad then
      TppUI.ShowAccessIconContinue()
      local blockId = ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME)
      if ScriptBlock.GetScriptBlockState(blockId) == ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE and not TppSoundDaemon.IsAssetLoading() then
        this.SetPazMode()
        if mvars.f30050_skipPazRoomFadeIn then


          TppSequence.SetNextSequence("Seq_Game_PazRoom")
          mvars.f30050_skipPazRoomFadeIn = false
        else


          TppMain.EnableAllGameStatus()
          TppUI.FadeIn(TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "FadeInPazRoomOnEnter" )
        end
        mvars.f30050_waitPazBlockLoad = false
      end
    end
  end,

  Messages = function( self )
    return
      StrCode32Table {
        UI = {
          {
            msg = "EndFadeIn", sender = "FadeInPazRoomOnEnter",
            func = function ()
              TppSequence.SetNextSequence("Seq_Game_PazRoom")
            end,
          },
        }
      }
  end,
}

sequences.Seq_Game_PazRoom = {
  OnEnter = function()
  end,
  Messages = function( self )
    return
      StrCode32Table {
        GameObject = {
          {
            msg = "PazGotPicture",
            func = function()
              this.DoPazGetPicture()
            end,
          },
        },
      }
  end,
  OnUpdate = function(self)

    if mvars.paz_isSkipPlayerInit
      and self.IsAnyStickDown() then
      mvars.paz_isSkipPlayerInit = false
      TppPaz.InitPlayer()
    end
  end,
  OnLeave = function()
    this.SetDefaultPlayerDisableAction()
  end,
  IsAnyStickDown = function()
    return math.abs( PlayerVars.leftStickXDirect ) > 0.1 or math.abs( PlayerVars.leftStickYDirect ) > 0.1 or
      math.abs( PlayerVars.rightStickXDirect ) > 0.1 or math.abs( PlayerVars.rightStickYDirect ) > 0.1 or
      math.abs( PlayerVars.rightStickXDirect ) > 0.1 or math.abs( PlayerVars.rightStickYDirect ) > 0.1
  end
}

sequences.Seq_Game_PazRoomOnLeave = {
  OnEnter = function()
    mvars.f30050_hasCalledFadeOutOnLeave = false
    Player.SetPadMask {
      settingName = "PazRoomOnLeave",
      except = true,
    }
  end,
  OnUpdate = function()
    if not mvars.f30050_hasCalledFadeOutOnLeave and not TppPaz.NeedsToWaitLeave() then
      TppUI.FadeOut(TppUI.FADE_SPEED.FADE_HIGHSPEED, "FadeOutPazRoomOnLeave" )
      mvars.f30050_hasCalledFadeOutOnLeave = true
    end
  end,
  Messages = function( self )
    return
      StrCode32Table {
        UI = {
          {
            msg = "EndFadeOut", sender = "FadeOutPazRoomOnLeave",
            func = function ()
              this.PazRoomOnLeave()
              this.WarpPlayerOutPazRoom()

              Player.RequestToStopCameraAnimation{}

              TppSoundDaemon.PostEvent( "sfx_m_auto_door_paz" )
              GkEventTimerManager.Start( "TimerWaitFadeInPazRoomOnLeave", 0.5 )
            end,
          },
          {
            msg = "EndFadeIn", sender = "FadeInPazRoomOnLeave",
            func = function ()
              TppSequence.SetNextSequence("Seq_Game_MainGame")
            end,
          },
        },
        Timer = {
          {
            msg = "Finish", sender = "TimerWaitFadeInPazRoomOnLeave",
            func = function()
              TppUI.FadeIn(TppUI.FADE_SPEED.FADE_HIGHESTSPEED, "FadeInPazRoomOnLeave" )
            end,
          },
        },
      }
  end,
  OnLeave = function()
    this.EnableAssetsOnCluster(MotherBaseStage.GetCurrentCluster())
    svars.restartClusterId = MotherBaseStage.GetCurrentCluster()
    TppMission.UpdateCheckPoint{
      checkPoint = "CHK_MainGame",
      atCurrentPosition = true,
    }
    Player.ResetPadMask {
      settingName = "PazRoomOnLeave",
    }
  end,
}






local BATTLE_GEAR_DEVELOP_DEMO_LIST = {
  "DevelopedBattleGear1",
  "DevelopedBattleGear2",
  nil,
  "DevelopedBattleGear4",
  "DevelopedBattleGear5",
}

sequences.Seq_Demo_BattleHanger = {
  Messages = function( self )
    return
      StrCode32Table {
        Timer = {
          {
            msg = "Finish",
            sender = "TelopStartOnDemo",
            func = function ( )
              this.ShowTelopInDemo()
            end,
            option = { isExecDemoPlaying = true },
          },
        },
        Demo = {
          {
            msg = "p51_010145_001_stageObj_ON",
            func = function()
              TppDataUtility.SetVisibleDataFromIdentifier( "id_20150225_190602_103", "btg01_demo_hide_group", true, false)
            end,
            option = { isExecDemoPlaying = true },
          },
          {
            msg = "p51_010145_002_stageObj_ON",
            func = function()
              TppDataUtility.SetVisibleDataFromIdentifier( "id_20150225_191810_465", "btg02_demo_hide_group", true, false)
            end,
            option = { isExecDemoPlaying = true },
          },
          {
            msg = "p51_010145_004_stageObj_ON",
            func = function()
              TppDataUtility.SetVisibleDataFromIdentifier( "id_20150225_192737_376", "btg04_demo_hide_group", true, false)
            end,
            option = { isExecDemoPlaying = true },
          },
          {
            msg = "p51_010145_005_stageObj_ON",
            func = function()
              TppDataUtility.SetVisibleDataFromIdentifier( "id_20150225_193056_215", "btg05_demo_hide_group", true, false)
            end,
            option = { isExecDemoPlaying = true },
          },
          {
            msg = "p51_010145_hyu_warp",
            func = function()
              this.WarpHuyeToGamePos()
            end,
            option = { isExecDemoPlaying = true },
          },
        },
      }
  end,
  --tex HOOK See InfProgression Seq_Demo_BattleHanger
  OnEnter = function()
    InfCore.Log("Enter Demo ButtleGear Hanger:" ..tostring(TppStory.GetBattleGearDevelopLevel()) )--tex was Fox.Log
    this.SetupBattleHanger()

    local demoName = BATTLE_GEAR_DEVELOP_DEMO_LIST[TppStory.GetBattleGearDevelopLevel()]
    if demoName and ((not TppDemo.IsPlayedMBEventDemo(demoName)) or Ivars.mbDemoSelection:Is"PLAY" or Ivars.mbReplayBattleGearDemo:Is(1)) then--tex added ivar bypass
      InfCore.Log("Seq_Demo_BattleHanger Playing "..tostring(demoName))--tex
      f30050_demo.PlayMtbsEventDemo{
        demoName = demoName,
        onEnd = function()
          TppSequence.SetNextSequence("Seq_Game_BattleHanger")
          mvars.btlhng_isLookedDemo = true
        end,
      }
    else

      TppSequence.SetNextSequence("Seq_Game_BattleHanger")

      local playerPos = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
      local soundPos = playerPos + Quat.RotationY( vars.playerRotY ):Rotate( Vector3(0.794681, 0, 0.831533) )
      TppSoundDaemon.PostEvent3D( "sfx_m_hanger_door_close", soundPos, 'Loading')

      TppUiCommand.RegistInfoTypingText( "lang",  5, "area_demo_battle_gear" )
      TppUiCommand.ShowInfoTypingText()
    end
  end,
  OnLeave = function()
    this.SetPlayerInitialPositionInBattleHanger()
    svars.restartClusterId = MotherBaseStage.GetCurrentCluster()
    TppMission.UpdateCheckPoint{checkPoint = "CHK_BattleHanger"}
  end,
}




function this.SetupBattleHanger()

  TppWeather.ForceRequestWeather( TppDefine.WEATHER.SUNNY, 0 )

  TppDataUtility.SetVector4EffectFromId("BattleHangerDoorLightOnLeave", "Color", 0.0, 1.0, 0.5, 0.5 )

  this.SetupHuey()

  this.WarpHuyeToGamePos()


  TppUiStatusManager.SetStatus( "EquipHud" ,"INVALID")
  TppUiStatusManager.SetStatus( "EquipPanel","INVALID")
  TppUI.OverrideFadeInGameStatus{
    EquipHud = false,
    EquipPanel = false,
  }
  this.SetEnableQuestUI(false)
end

function this.WarpHuyeToGamePos()
  local gameObjectId = GameObject.GetGameObjectId( "TppHuey2GameObjectLocator" )
  local command = { id="Warp", degRotationY=-92.8, position=Vector3(-18.6,-3.22,-0.5) }
  GameObject.SendCommand( gameObjectId, command )
end

function this.SetupHuey()
  local gameObjectId = GameObject.GetGameObjectId( "TppHuey2GameObjectLocator" )
  GameObject.SendCommand( gameObjectId, { id = "SetHostage2Flag", flag="demoUnlock", on=false } )
  GameObject.SendCommand( gameObjectId, { id = "SetHostage2Flag", flag= "disableMarker", on=true } )
  GameObject.SendCommand( gameObjectId, { id = "SetDisableDamage", life = true, faint = true, sleep = true } )
end

sequences.Seq_Game_BattleHanger = {
  Messages = function( self )
    return
      StrCode32Table {
        UI = {
          {
            msg = "EndFadeIn", sender = "OnEnterBattleHanger",
            func = function ()
              this.HueyLookSnake()
            end,
          }
        },
      }
  end,
  OnEnter = function()
    Fox.Log("Enter ButtleGear Hanger:" ..tostring(TppStory.GetBattleGearDevelopLevel())  )
    TppUI.FadeIn(TppUI.FADE_SPEED.FADE_NORMALSPEED,"OnEnterBattleHanger")
    TppMain.EnableAllGameStatus()
    this.SetupBattleHanger()

    this.DisableHueyInBattleHanger()

    this.SetupPadMaskInBattleHanger()

    this.PlayRadioAfterDemo()
  end,
  OnLeave = function()

    TppWeather.CancelForceRequestWeather()

    Player.ResetPadMask {settingName = "BattleHanger"}

    TppUiStatusManager.UnsetStatus( "EquipHud" ,"INVALID")
    TppUiStatusManager.UnsetStatus( "EquipPanel","INVALID")
    TppUI.UnsetOverrideFadeInGameStatus()
    this.SetEnableQuestUI(true)
  end,
}

function this.HueyLookSnake()
  if not mvars.btlhng_isLookedDemo then
    local gameObjectId = GameObject.GetGameObjectId( "TppHuey2GameObjectLocator" )

    GameObject.SendCommand( gameObjectId, { id="CallVoice", dialogueName="DD_Huey", parameter="HYV_1010" } )
    GameObject.SendCommand( gameObjectId, {
      id="SpecialAction",
      action="PlayMotion",
      path="/Assets/tpp/motion/SI_game/fani/bodies/hyui/hyui/hyui_s_sna_look_act1.gani",
      autoFinish=true,
      enableMessage=true,
      commandId=StrCode32("FinishLookSnake"),
      enableGravity=false,
      enableCollision=false,
    } )
  end
end

function this.SetupPadMaskInBattleHanger()
  Player.SetPadMask {

    settingName = "BattleHanger",

    except = false,

    buttons = PlayerPad.MB_DEVICE
    + PlayerPad.HOLD
    + PlayerPad.RELOAD
  }
end

function this.PushSwitchOnLeaveBattleHanger()

  local dataSetName = "/Assets/tpp/level/location/mtbs/block_large/mtbs_hanger_gimmick.fox2"
  local dataName = "mtbs_door006_door004_ev_gim_n0000|srt_mtbs_door006_door004_ev"
  Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, dataName, dataSetName, false)

  local soundPos = this.GetPositionInBattleHangerDoor()
  TppSoundDaemon.PostEvent3D( "sfx_m_hanger_door_open", Vector3(soundPos[1],soundPos[2],soundPos[3]), 'Loading')

  TppMission.Reload{
    missionPackLabelName = "AfterDemo",
    clusterId = TppDefine.CLUSTER_DEFINE.Develop,
    OnEndFadeOut = function()
      svars.restartClusterId = TppDefine.CLUSTER_DEFINE.Develop
      TppSequence.ReserveNextSequence( "Seq_Game_Setup" )
      local pos, rotY = this.GetPositionOuterBattleHanger()
      TppPlayer.SetInitialPosition( pos,rotY )
      mtbs_cluster.LockCluster("Develop")
      svars.isLeaveBattleHanger = true
    end,
  }
end

function this.GetPositionInBattleHangerDoor()
  local pos = {-11.512, -6.922, 10.334}
  local rotY = 0
  return mtbs_cluster.GetPosAndRotY( "Command", "plnt0", pos, rotY )
end

function this.GetPositionOuterBattleHangerDoor()
  local pos = {-30.078, -6.922, 15.039 }
  local rotY = 0
  return mtbs_cluster.GetPosAndRotY( "Develop", "plnt0", pos , rotY )
end

function this.GetPositionOuterBattleHanger()
  local pos = { -30.980, -7.000, 14.779 }
  local rotY = 180
  return mtbs_cluster.GetPosAndRotY( "Develop", "plnt0", pos , rotY )
end

function this.DisableHueyInBattleHanger()
  if not TppStory.CanArrivalHueyInMB() then
    local gameObjectId = GameObject.GetGameObjectId( "TppHuey2GameObjectLocator" )
    local command = { id="SetEnabled", enabled=false }
    if gameObjectId ~= GameObject.NULL_ID then
      GameObject.SendCommand( gameObjectId, command )
    end
  end
end


sequences.Seq_Demo_RewardAfterDemo = {
  OnEnter = function()
  end,
  OnUpdate = function()
    if mvars.f30050_onEndMissionReward then
      TppSequence.SetNextSequence("Seq_Demo_End")
      mvars.f30050_onEndMissionReward = nil
    end
  end,
  OnLeave = function()
    Player.UnsetPause()
  end,
}


sequences.Seq_Demo_Wait_FadeOut_Sortie = {
  OnEnter = function(self)

    TppUI.FadeOut(TppUI.FADE_SPEED.FADE_NORMALSPEED,"FadeOutOnSortieDemo")
  end,
  Messages = function( self )
    return
      StrCode32Table {
        UI = {
          {
            msg = "EndFadeOut", sender = "FadeOutOnSortieDemo",
            func = function ()
              TppSequence.SetNextSequence("Seq_Demo_Wait_Loading_Sortie")
            end,
          },
        },
      }
  end,
}


sequences.Seq_Demo_Wait_Loading_Sortie = {
  Messages = function( self )
    return
      StrCode32Table {
        MotherBaseStage = {
          {
            msg = "MotherBaseCurrentClusterLoadStart",
            func = function(clusterId)
              mvars.f30050_seq_warp_isActivateDemoBlock = false
              TppQuest.SetQuestBlockName( SCRIPT_BLOCK_NAME )
              this.DoLoadStartCluster(clusterId)
            end,
          },
          {
            msg = "MotherBaseCurrentClusterActivated",
            func = function(clusterId)
              mvars.f30050_isActivateStageBlock = true
              this.DoActivatedCluster(clusterId)
            end,
          },
        },
      }
  end,
  OnEnter = function()

    local clusterId = MotherBaseStage.GetCurrentCluster()
    if clusterId == TppDefine.CLUSTER_DEFINE.Command then
      TppSequence.SetNextSequence("Seq_Demo_Play_Sortie")
    else

      mtbs_enemy.OnDeactivateDemoBlock(mvars.f30050_currentFovaClusterId+1)
      if clusterId == 255 and mvars.f30050_currentFovaClusterId == TppDefine.CLUSTER_DEFINE.Command then

        mvars.f30050_seq_warp_isActivateDemoBlock = true
      end
      if Tpp.IsVehicle( vars.playerVehicleGameObjectId ) then
        GameObject.SendCommand( vars.playerVehicleGameObjectId, { id="SetPosition", position=Vector3(9,0.8,-42), rotY=0, } )
      else
        TppPlayer.Warp{ pos={9,0.8,-42}, rotY=0}
      end
      mvars.f30050_prevScriptBlockState = ScriptBlock.GetScriptBlockState(ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME))
    end
  end,
  OnUpdate = function()

    local state = ScriptBlock.GetScriptBlockState(ScriptBlock.GetScriptBlockId(SCRIPT_BLOCK_NAME))
    if state == ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE and state > mvars.f30050_prevScriptBlockState then
      mtbs_enemy.OnActivateDemoBlock()
      mvars.f30050_seq_warp_isActivateDemoBlock = true
    end
    mvars.f30050_prevScriptBlockState = state
    if mvars.f30050_isActivateStageBlock and mvars.f30050_seq_warp_isActivateDemoBlock then
      TppSequence.SetNextSequence("Seq_Demo_Play_Sortie")
    end
    TppUI.ShowAccessIconContinue()
  end,
}


sequences.Seq_Demo_Play_Sortie = {
  OnEnter = function(self)
    f30050_demo.PlayMtbsEventDemo{
      demoName = mvars.f30050_demoName,
    }
  end,
}

function this.GetFemaleSoldierList( clusterId , num )
  local retFemaleSoldierList = {}
  if num == nil then
    num =  MAX_STAFF_NUM_IN_CLUSTER
  end
  for _, soldierName in ipairs(mvars.mbSoldier_enableSoldierLocatorList[clusterId]) do
    local command = { id = "GetStaffId" }
    local staffId = SendCommand( GameObject.GetGameObjectId(soldierName), command )
    if this.IsFemale(staffId) then
      table.insert( retFemaleSoldierList, soldierName )
      if #retFemaleSoldierList == num then
        break
      end
    end
  end
  return retFemaleSoldierList
end


function this.ClearVisitQuiet()
  if this.NeedPlayQuietWishGoMission() then
    mvars.f30050_demoName = "QuietWishGoMission"
    this.SetDefaultPlayerDisableAction()
  end
end

function this.NeedPlayQuietWishGoMission()
  local isClearedVisitQuietQuest = TppQuest.IsCleard("mtbs_q99011")
  local isNotPlayDemo = not TppDemo.IsPlayedMBEventDemo( "QuietWishGoMission" )
  local isCanArrival = TppStory.CanArrivalQuietInMB()
  Fox.Log("NeedPlayQuietWishGoMission:isClearedSideOps: ".. tostring(isClearedVisitQuietQuest)  .. " isNotPlayDemo: " ..tostring(isNotPlayDemo) .. " canArrival: " ..tostring(isCanArrival) )
  return isClearedVisitQuietQuest and isNotPlayDemo and isCanArrival
end


function this.DisableIntelRadio()
  for _, radioGroup in ipairs(DISABLE_INTEL_RADIO_LIST) do
    TppRadio.ChangeIntelRadio(radioGroup)
  end
end



return this
