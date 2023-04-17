local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}





this.NO_AQUIRE_GMP = true
this.NO_MISSION_CLEAR_RANK = true
this.HELICOPTER_DOOR_OPEN_TIME_SEC = 28

this.SKIP_ADD_RESOURCE_TO_TEMP_BUFFER = true	




local PHOTO_ID_MOSQUITO = 10	
local MARKER_TARGET_AREA = "Marker_develop"
local TIMER_ENE_START_HOLDUP = 6

local TIMER_RADIO_ELIMINATE_ALL_TARGET = 20
local TIMER_RADIO_ELIMINATE_TARGET_FULTON = 20
local TIMER_RADIO_ELIMINATE_TARGET = 20

local GOAL_DOOR_LIST = {
	[TppDefine.CLUSTER_DEFINE.Develop] =
	{
		"ly003_cl02_item0000|cl02pl0_uq_0020_gimmick2|mtbs_door006_door003_gim_n0000|srt_mtbs_door006_door003",
	},
}



local HOSTAGE_A = GameObject.GetGameObjectId( "hos_s10115_0000" )
local HOSTAGE_B = GameObject.GetGameObjectId( "hos_s10115_0001" )
local HOSTAGE_C = GameObject.GetGameObjectId( "hos_s10115_0002" )
local HOSTAGE_D = GameObject.GetGameObjectId( "hos_s10115_0003" )
local HOSTAGE_E = GameObject.GetGameObjectId( "hos_s10115_0004" )
local HOSTAGE_F = GameObject.GetGameObjectId( "hos_s10115_0005" )

this.HOSTAGELIST ={}

this.lockedStaffs = {}






this.currentClusterSetting = {
	strMissionObjective = "",
	strGoalMarker = "",
	currentCpName = "",
	GuardTargetName = "",
	CbtSetName = "",
	TARGET_ENEMY = {},
	HeliRoutes = {},
	LandingZones ={},
}




this.SetClusterDefine = function ( clusterId )
	
	local numLayout = 0
	if (vars.mbLayoutCode >= 0) and (vars.mbLayoutCode <= 3) then
		numLayout = 3
	else
		Fox.Error("this Layout is not MOTHER BASE: layoutCode:: " .. tostring(vars.mbLayoutCode))
	end

	
	local clstId = clusterId - 1

	
	local uqLasId = string.format("%04d", clstId * 10 )

	
	
	this.CLST_PARAM = {
		{ 
			MISSION_OBJECTIVE = string.format("clst%01d_goalOfCurrentCluster", clstId ),
			GOAL_MARKER = "Marker_develop",
			CP_NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|mtbs_develop_cp",
			GT_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|TppCombatLocatorSetData", numLayout, clstId, clstId, 0, clstId * 10 ),
			GT_NAME_00 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME_00 = string.format("cs_cl%02dpl%01d", clstId, 0 ),
			GT_NAME_01 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 1),
			CBTSET_NAME_01 = string.format("cs_cl%02dpl%01d", clstId, 1 ),
			GT_NAME_02 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 2),
			CBTSET_NAME_02 = string.format("cs_cl%02dpl%01d", clstId, 2 ),
			GT_NAME_03 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 3),
			CBTSET_NAME_03 = string.format("cs_cl%02dpl%01d", clstId, 3 ),
			TARGET_ENEMY = {
				NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|sol_plnt0_0000",
				ROUTE_SNEAK = "uq_0020_enemy_10115|rts_target_d_0001",
				ROUTE_CAUTION = "uq_0020_enemy_10115|rts_target_c_0001",
			},
			HELI_ROUTE_ON_CLEAR ={
				HELI_0 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_1 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0001", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_2 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0002", numLayout, clstId, clstId, 0, clstId * 10 ),
			},
		},
		{
			MISSION_OBJECTIVE = string.format("clst%01d_goalOfCurrentCluster", clstId ),
			GOAL_MARKER = "Marker_develop",
			CP_NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|mtbs_develop_cp",
			GT_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|TppCombatLocatorSetData", numLayout, clstId, clstId, 0, clstId * 10 ),
			GT_NAME_00 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME_00 = string.format("cs_cl%02dpl%01d", clstId, 0 ),
			GT_NAME_01 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 1),
			CBTSET_NAME_01 = string.format("cs_cl%02dpl%01d", clstId, 1 ),
			GT_NAME_02 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 2),
			CBTSET_NAME_02 = string.format("cs_cl%02dpl%01d", clstId, 2 ),
			GT_NAME_03 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 3),
			CBTSET_NAME_03 = string.format("cs_cl%02dpl%01d", clstId, 3 ),
			TARGET_ENEMY = {
				NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|sol_plnt0_0000",
				ROUTE_SNEAK = "uq_0020_enemy_10115|rts_target_d_0001",
				ROUTE_CAUTION = "uq_0020_enemy_10115|rts_target_c_0001",
			},
			HELI_ROUTE_ON_CLEAR ={
				HELI_0 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_1 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0001", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_2 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0002", numLayout, clstId, clstId, 0, clstId * 10 ),
			},
		},
		{
			MISSION_OBJECTIVE = string.format("clst%01d_goalOfCurrentCluster", clstId ),
			GOAL_MARKER = "Marker_develop",
			CP_NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|mtbs_develop_cp",
			GT_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME = string.format("cs_cl%02d_0000", clstId ),
			
			
			GT_NAME_00 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME_00 = string.format("cs_cl%02dpl%01d", clstId, 0 ),
			GT_NAME_01 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 1),
			CBTSET_NAME_01 = string.format("cs_cl%02dpl%01d", clstId, 1 ),
			GT_NAME_02 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 2),
			CBTSET_NAME_02 = string.format("cs_cl%02dpl%01d", clstId, 2 ),
			GT_NAME_03 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 3),
			CBTSET_NAME_03 = string.format("cs_cl%02dpl%01d", clstId, 3 ),
			TARGET_ENEMY = {
				NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|sol_plnt0_0000",
				ROUTE_SNEAK = "uq_0020_enemy_10115|rts_target_d_0001",
				ROUTE_CAUTION = "uq_0020_enemy_10115|rts_target_c_0001",
			},
			HELI_ROUTE_ON_CLEAR ={
				string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
				string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0001", numLayout, clstId, clstId, 0, clstId * 10 ),
				string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0002", numLayout, clstId, clstId, 0, clstId * 10 ),
			},
		},
		{
			MISSION_OBJECTIVE = string.format("clst%01d_goalOfCurrentCluster", clstId ),
			GOAL_MARKER = "Marker_develop",
			CP_NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|mtbs_develop_cp",
			GT_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|TppCombatLocatorSetData", numLayout, clstId, clstId, 0, clstId * 10 ),
			GT_NAME_00 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME_00 = string.format("cs_cl%02dpl%01d", clstId, 0 ),
			GT_NAME_01 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 1),
			CBTSET_NAME_01 = string.format("cs_cl%02dpl%01d", clstId, 1 ),
			GT_NAME_02 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 2),
			CBTSET_NAME_02 = string.format("cs_cl%02dpl%01d", clstId, 2 ),
			GT_NAME_03 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 3),
			CBTSET_NAME_03 = string.format("cs_cl%02dpl%01d", clstId, 3 ),
			TARGET_ENEMY = {
				NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|sol_plnt0_0000",
				ROUTE_SNEAK = "uq_0020_enemy_10115|rts_target_d_0001",
				ROUTE_CAUTION = "uq_0020_enemy_10115|rts_target_c_0001",
			},
			HELI_ROUTE_ON_CLEAR ={
				HELI_0 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_1 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0001", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_2 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0002", numLayout, clstId, clstId, 0, clstId * 10 ),
			},
		},
		{
			MISSION_OBJECTIVE = string.format("clst%01d_goalOfCurrentCluster", clstId ),
			GOAL_MARKER = "Marker_develop",
			CP_NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|mtbs_develop_cp",
			GT_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|TppCombatLocatorSetData", numLayout, clstId, clstId, 0, clstId * 10 ),
			GT_NAME_00 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME_00 = string.format("cs_cl%02dpl%01d", clstId, 0 ),
			GT_NAME_01 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 1),
			CBTSET_NAME_01 = string.format("cs_cl%02dpl%01d", clstId, 1 ),
			GT_NAME_02 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 2),
			CBTSET_NAME_02 = string.format("cs_cl%02dpl%01d", clstId, 2 ),
			GT_NAME_03 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 3),
			CBTSET_NAME_03 = string.format("cs_cl%02dpl%01d", clstId, 3 ),
			TARGET_ENEMY = {
				NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|sol_plnt0_0000",
				ROUTE_SNEAK = "uq_0020_enemy_10115|rts_target_d_0001",
				ROUTE_CAUTION = "uq_0020_enemy_10115|rts_target_c_0001",
			},
			HELI_ROUTE_ON_CLEAR ={
				HELI_0 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_1 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0001", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_2 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0002", numLayout, clstId, clstId, 0, clstId * 10 ),
			},
		},
		{
			MISSION_OBJECTIVE = string.format("clst%01d_goalOfCurrentCluster", clstId ),
			GOAL_MARKER = "Marker_develop",
			CP_NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|mtbs_develop_cp",
			GT_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|TppCombatLocatorSetData", numLayout, clstId, clstId, 0, clstId * 10 ),
			GT_NAME_00 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME_00 = string.format("cs_cl%02dpl%01d", clstId, 0 ),
			GT_NAME_01 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 1),
			CBTSET_NAME_01 = string.format("cs_cl%02dpl%01d", clstId, 1 ),
			GT_NAME_02 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 2),
			CBTSET_NAME_02 = string.format("cs_cl%02dpl%01d", clstId, 2 ),
			GT_NAME_03 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 3),
			CBTSET_NAME_03 = string.format("cs_cl%02dpl%01d", clstId, 3 ),
			TARGET_ENEMY = {
				NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|sol_plnt0_0000",
				ROUTE_SNEAK = "uq_0020_enemy_10115|rts_target_d_0001",
				ROUTE_CAUTION = "uq_0020_enemy_10115|rts_target_c_0001",
			},
			HELI_ROUTE_ON_CLEAR ={
				HELI_0 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_1 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0001", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_2 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0002", numLayout, clstId, clstId, 0, clstId * 10 ),
			},
		},
		{
			MISSION_OBJECTIVE = string.format("clst%01d_goalOfCurrentCluster", clstId ),
			GOAL_MARKER = "Marker_develop",
			CP_NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|mtbs_develop_cp",
			GT_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|TppCombatLocatorSetData", numLayout, clstId, clstId, 0, clstId * 10 ),
			GT_NAME_00 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_uq_%04d_cbtlct|gt_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
			CBTSET_NAME_00 = string.format("cs_cl%02dpl%01d", clstId, 0 ),
			GT_NAME_01 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 1),
			CBTSET_NAME_01 = string.format("cs_cl%02dpl%01d", clstId, 1 ),
			GT_NAME_02 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 2),
			CBTSET_NAME_02 = string.format("cs_cl%02dpl%01d", clstId, 2 ),
			GT_NAME_03 = string.format("ly%03d_cl%02d_combat0000|cl%02dpl%01d_mb_fndt_plnt_cbtlct|gt_plnt", numLayout, clstId, clstId, 3),
			CBTSET_NAME_03 = string.format("cs_cl%02dpl%01d", clstId, 3 ),
			TARGET_ENEMY = {
				NAME = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|sol_plnt0_0000",
				ROUTE_SNEAK = "uq_0020_enemy_10115|rts_target_d_0001",
				ROUTE_CAUTION = "uq_0020_enemy_10115|rts_target_c_0001",
			},
			HELI_ROUTE_ON_CLEAR ={
				HELI_0 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0000", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_1 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0001", numLayout, clstId, clstId, 0, clstId * 10 ),
				HELI_2 = string.format("ly%03d_cl%02d_10115_heli0000|cl%02dpl%01d_uq_%04d_heli_10115|rts_apr_clear_0002", numLayout, clstId, clstId, 0, clstId * 10 ),
			},
		},
	}

end







function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		
		
		"Seq_Game_MainGame",
		"Seq_Game_EliminatedAll",
		"Seq_Game_EliminatedTarget",
		"Seq_Mission_Clear",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end


function this.OnTerminate()
	Fox.Log("s10115_sequence.OnTerminate")
	
	Player.ResetPadMask{
		settingName = "toClearMission",
	}
end







this.missionStartPosition = {
		helicopterRouteList = {},
}





this.missionVarsList = {
	isPhaseOverCaution = false,
	isRecognizedTarget = false,
	isSuccessFultonTarget = false,
	--RETAILBUG undefined 
	numClusterId,
	numCurrentClusterGrade,
	numHostageRecovered,
	numHostageKilled,
	--
	deadStaffList = {},
	isMarkedTargetByIntel = false,
	canClearMission_10115 = false,
	isCallRadioElmTarget = false,
	isFultonedLastHostage = false,
	deadCauseHostage = {},
	isFuloneFailedHostage = {},
}



this.saveVarsList = {
	
	isMonologue_A	= false,
	isMonologue_B	= false,
	isMonologue_C	= false,
	isMonologue_D	= false,
	isMonologue_E	= false,
	isMonologue_F	= false,
}


this.checkPointList = {}











this.missionObjectiveDefine = {
	
	default_area_develop = {
		gameObjectName = "Marker_develop", goalType = "moving", viewType = "all", visibleArea = 2, randomRange = 0, setImportant = true, setNew = false, announceLog = "updateMap", mapRadioName = "s0115_mprg1010",
	},

	
	default_area_hostage = {
		gameObjectName = "hos_s10115_0000", viewType = "map", visibleArea = 1, randomRange = 1, setImportant = false, setNew = false, announceLog = "updateMap",
	},

	
	target_area = {
		gameObjectName = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|sol_plnt0_0000", goalType = "attack", viewType = "map_and_world_only_icon", setNew = false, announceLog = "updateMap", langId="marker_info_mission_target",
	},

	
	target_recognized = {
		gameObjectName = "ly003_cl02_10115_npc0000|cl02pl0_uq_0020_npc|sol_plnt0_0000", goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, setNew = false, announceLog = "updateMap",
	},

	
	default_subGoal = {
		subGoalId= 0,
	},

	
	default_photo_target = {
		photoId = PHOTO_ID_MOSQUITO, addFirst = true, photoRadioName = "s0115_mirg0010",
		missionTask = { taskNo=0, isNew=true, isComplete=false },	
	},

	
	complete_photo = {
		photoId	= PHOTO_ID_MOSQUITO,
		missionTask = { taskNo=0, isComplete=true }, 
	},

	
	hud_photo_target = {
		hudPhotoId = PHOTO_ID_MOSQUITO 
	},

	
	bonus_Hostage = {
		gameObjectName = "hos_s10115_0000", goalType = "defend", viewType = "map_and_world_only_icon", setNew = false, announceLog = "updateMap", langId="marker_staff_hostage",
	},

	bonus_Hostage_plant2 = {
		gameObjectName = "hos_s10115_0003", viewType = "map", visibleArea = 1, randomRange = 0, setImportant = false, setNew = false, announceLog = "updateMap",
	},

	bonus_Hostage_0 = {
		gameObjectName = "hos_s10115_0000", goalType = "defend", viewType = "map_and_world_only_icon", setNew = false, announceLog = "updateMap", langId="marker_staff_hostage",
	},
	bonus_Hostage_1 = {
		gameObjectName = "hos_s10115_0001", goalType = "defend", viewType = "map_and_world_only_icon", setNew = false, announceLog = "updateMap", langId="marker_staff_hostage",
	},
	bonus_Hostage_2 = {
		gameObjectName = "hos_s10115_0002", goalType = "defend", viewType = "map_and_world_only_icon", setNew = false, announceLog = "updateMap", langId="marker_staff_hostage",
	},
	bonus_Hostage_3 = {
		gameObjectName = "hos_s10115_0003", goalType = "defend", viewType = "map_and_world_only_icon", setNew = false, announceLog = "updateMap", langId="marker_staff_hostage",
	},
	bonus_Hostage_4 = {
		gameObjectName = "hos_s10115_0004", goalType = "defend", viewType = "map_and_world_only_icon", setNew = false, announceLog = "updateMap", langId="marker_staff_hostage",
	},
	bonus_Hostage_5 = {
		gameObjectName = "hos_s10115_0005", goalType = "defend", viewType = "map_and_world_only_icon", setNew = false, announceLog = "updateMap", langId="marker_staff_hostage",
	},
	
	default_area_hostage_plnt2 = {
		gameObjectName = "hos_s10115_0003", viewType = "map", visibleArea = 1, randomRange = 0, setImportant = false, setNew = false, announceLog = "updateMap",
	},


}











this.missionObjectiveTree = {
	target_recognized = {
		target_area = {
			default_area_develop = {},
		},
	},
	
	complete_photo = {
		default_photo_target = {},
	},
	
	hud_photo_target = {},
	bonus_Hostage = {},
	bonus_Hostage_plant2 = {},
	bonus_Hostage_0 = {
		bonus_Hostage = {},
	},
	bonus_Hostage_1 = {
		bonus_Hostage = {},
	},
	bonus_Hostage_2 = {
		bonus_Hostage = {},
	},
	bonus_Hostage_3 = {
		default_area_hostage = {},
	},
	bonus_Hostage_4 = {
		default_area_hostage = {},
	},
	bonus_Hostage_5 = {
		default_area_hostage = {},
	},
}

this.missionObjectiveEnum = Tpp.Enum{
	"default_area_develop",
	"default_area_hostage",
	"target_area",
	"target_recognized",
	"default_subGoal",
	"default_photo_target",
	"complete_photo",
	"hud_photo_target",
	"bonus_Hostage",
	"default_area_hostage_plnt2",
	"bonus_Hostage_plant2",
	"bonus_Hostage_0",
	"bonus_Hostage_1",
	"bonus_Hostage_2",
	"bonus_Hostage_3",
	"bonus_Hostage_4",
	"bonus_Hostage_5",
}





function this.SetPlayerDisableActionOnClear()
	Fox.Log("s10115_sequence.SetPlayerDisableActionOnClear")
	
	vars.playerDisableActionFlag = PlayerDisableAction.SUBJECTIVE_CAMERA
	
	TppUiStatusManager.SetStatus( "EquipHud", "INVALID" )
	TppUiStatusManager.SetStatus( "EquipPanel", "INVALID" )
end

function this.SetPlayerMaskOnClear()
	Fox.Log("s10115_sequence.SetPlayerMask")
	
	Player.SetPadMask{
		settingName = "toClearMission",
		except = true,
		
		sticks = PlayerPad.STICK_R,
	}
end




function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	 
	
	
	mvars.numClusterId = 2 + 1
	mvars.numCurrentClusterGrade = mtbs_cluster.GetClusterConstruct( mvars.numClusterId )

	mvars.targetInterCount = 0

	
	this.SetClusterDefine(mvars.numClusterId)

	

	this.currentClusterSetting.strGoalMarker = 			this.CLST_PARAM[mvars.numClusterId].GOAL_MARKER
	this.currentClusterSetting.currentCpName = 			this.CLST_PARAM[mvars.numClusterId].CP_NAME
	this.currentClusterSetting.GuardTargetName = 		this.CLST_PARAM[mvars.numClusterId].GT_NAME
	this.currentClusterSetting.CbtSetName = 			this.CLST_PARAM[mvars.numClusterId].CBTSET_NAME
	this.currentClusterSetting.HeliRoutes = 			this.CLST_PARAM[mvars.numClusterId].HELI_ROUTE_ON_CLEAR
	this.currentClusterSetting.LandingZones = 			this.CLST_PARAM[mvars.numClusterId].LANDING_ZONE
	this.currentClusterSetting.TARGET_ENEMY = 			this.CLST_PARAM[mvars.numClusterId].TARGET_ENEMY


	
	mtbs_enemy.SetupClusterParam( this.CLST_PARAM )
	s10115_enemy.TARGET_ENEMY = this.currentClusterSetting.TARGET_ENEMY

	
	if mvars.numCurrentClusterGrade >= 3 then
		this.HOSTAGELIST = {
			"hos_s10115_0000",
			"hos_s10115_0001",
			"hos_s10115_0002",
			"hos_s10115_0003",
			"hos_s10115_0004",
			"hos_s10115_0005",
		}
	else
		this.HOSTAGELIST = {
			"hos_s10115_0000",
			"hos_s10115_0001",
			"hos_s10115_0002",
		}
	end
	s10115_enemy.HOSTAGELIST = this.HOSTAGELIST

	
	s10115_enemy.SetCPIgnoreHeli(true)

	
	
	local systemCallbackTable ={
		OnEstablishMissionClear = function()
			
			this.RemoveDeadStaffs()
			
			TppMotherBaseManagement.UnlockedStaffsS10115()

			if mvars.isSuccessFultonTarget == true then
				s10115_radio.BlackScreenRadio()
			else
				TppMission.RegisterMissionSystemCallback{
					OnEndMissionCredit = TppMission.ShowMissionReward,
				}
			end
			TppMission.MissionGameEnd{loadStartOnResult = true}
		end,
		
		OnOutOfMissionArea = function ()
			Fox.Log("OnOutOfMissionArea::")
			
			local isNearByTarget = TppEnemy.CheckAllTargetClear()
			
			if isNearByTarget == true then
				
				this.SetPlayerMaskOnClear()
				TppSequence.SetNextSequence( "Seq_Game_EliminatedTarget" )
			else
				
				TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.OUTSIDE_OF_MISSION_AREA, TppDefine.GAME_OVER_RADIO.OUT_OF_MISSION_AREA )
			end
		end,
		OnDisappearGameEndAnnounceLog = function()
			TppMission.ShowMissionResult()
		end,
		
		OnReturnToMission = function()
			Fox.Log("Return to mission on s10115")
			TppStory.FailedRetakeThePlatform()
		end,
		CheckMissionClearOnRideOnFultonContainer = function ()
			Fox.Log("CheckMissionClearOnRideOnFultonContainer")
			
			return true
		end,
		OnFultonContainerMissionClear = function ()
			Fox.Log("OnFultonContainerMissionClear")
			local canClearMission = TppEnemy.IsEliminated( s10115_enemy.TARGET_ENEMY.NAME )
			
			if canClearMission == true then
				this.ReserveMissionClear{ isContainerClear = true }	
			else
				TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.OUTSIDE_OF_MISSION_AREA, TppDefine.GAME_OVER_RADIO.OUT_OF_MISSION_AREA )
			end
		end,
		nil
	}

	
	TppMission.RegiserMissionSystemCallback(systemCallbackTable)

	
 	TppMarker.SetUpSearchTarget{
		{
			gameObjectName = this.currentClusterSetting.TARGET_ENEMY.NAME,
			gameObjectType = "TppSoldier2",
			skeletonName = "SKL_004_HEAD",
			objectives = { "target_recognized", "hud_photo_target" },
			func = this.commonUpdateMarkerTargetFound
		},
	}

end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	
	
end




function this.targetPhote_ON()
	if TppMarker.GetSearchTargetIsFound( s10115_enemy.TARGET_ENEMY.NAME ) == true		 then
		Fox.Log("already Important Marker ... Nothing Done !!")
	else
		TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
		TppMission.UpdateObjective{ objectives = { "hud_photo_target" }, }
	end
end







function this.Messages()
	return
	StrCode32Table {
		GameObject = {
			{ msg = "Fulton", func = function( arg0, arg1 ) Fox.Log(arg0) Fox.Log(arg1) end, },
			{	
				msg = "Carried",
				func = function ( gameObjectId , carriedState )

					local monologue_A  = { id="CallMonologue", label = "speech115_carry050", carry = true }	
					local monologue_B  = { id="CallMonologue", label = "speech115_carry060", carry = true }	
					local monologue_C  = { id="CallMonologue", label = "speech115_carry070", carry = true }	
					local monologue_D  = { id="CallMonologue", label = "speech115_carry080", carry = true }	
					local monologue_E  = { id="CallMonologue", label = "speech115_carry090", carry = true }	
					local monologue_F  = { id="CallMonologue", label = "speech115_carry100", carry = true }	

					Fox.Log("carried gameObjectId = "..gameObjectId.." !!")
					
					if gameObjectId == HOSTAGE_A and carriedState == TppGameObject.NPC_CARRIED_STATE_START and svars.isMonologue_A == false then
						svars.isMonologue_A = true
						GameObject.SendCommand( HOSTAGE_A , monologue_A )
					elseif gameObjectId == HOSTAGE_B and carriedState == TppGameObject.NPC_CARRIED_STATE_START and svars.isMonologue_B == false then
						svars.isMonologue_B = true
						GameObject.SendCommand( HOSTAGE_B , monologue_B )
					elseif gameObjectId == HOSTAGE_C and carriedState == TppGameObject.NPC_CARRIED_STATE_START and svars.isMonologue_C == false then
						svars.isMonologue_C = true
						GameObject.SendCommand( HOSTAGE_C , monologue_C )
					elseif gameObjectId == HOSTAGE_D and carriedState == TppGameObject.NPC_CARRIED_STATE_START and svars.isMonologue_D == false then
						svars.isMonologue_D = true
						GameObject.SendCommand( HOSTAGE_D , monologue_D )
					elseif gameObjectId == HOSTAGE_E and carriedState == TppGameObject.NPC_CARRIED_STATE_START and svars.isMonologue_E == false then
						svars.isMonologue_E = true
						GameObject.SendCommand( HOSTAGE_E , monologue_E )
					elseif gameObjectId == HOSTAGE_F and carriedState == TppGameObject.NPC_CARRIED_STATE_START and svars.isMonologue_F == false then
						svars.isMonologue_F = true
						GameObject.SendCommand( HOSTAGE_F , monologue_F )
					else
						Fox.Log("MSG:Carried No Setting Character ... ")
					end
				end
			},
		},
		Trap = {
			{
				msg = "Exit",
				sender = "trap_StartArea",
				func = function ()
					Fox.Log("s10211_mission message do!!")
				end
			}
		},
		GameObject = {--RETAILBUG duplicate key name different value
			{
				msg		= "SwitchGimmick",
				func = function(gameObjectId, gameObjectName, name, switchFlag)
					
					if gameObjectName == StrCode32("ly003_cl02_item0000|cl02pl0_uq_0020_gim_onlymb2|gntn_swtc001_vrtn001_gim_n0000|srt_gntn_swtc001_vrtn001") then
						this.PushSwitchOnEnterBattleHanger()
						return
					end					
				end,
				option = { isExecMissionPrepare = true },
			},
		},
		nil
	}
end





function this.PushSwitchOnEnterBattleHanger()
	if vars.missionCode == 30050 then return end 
	do 
		local pos = { -30.980, -7.500, 14.779 }
		local rotY = 0
		local pos, rotY = mtbs_cluster.GetPosAndRotY( "Develop", "plnt0", pos, rotY )
		local distance = (pos[1] - vars.playerPosX) * ( pos[1] - vars.playerPosX ) + ( pos[2] - vars.playerPosY ) * (pos[2] - vars.playerPosY) + (pos[3] - vars.playerPosZ) * ( pos[3] - vars.playerPosZ )
		if distance > 9.0 then
			return
		end
	end
	
	local playerPos = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
	local soundPos = playerPos + Quat.RotationY( vars.playerRotY ):Rotate( Vector3(-0.65,0.35,0.3) )
	TppSoundDaemon.PostEvent3D( "sfx_m_door_buzzer", soundPos )
end


this.SetRouteHeli = function ( heliName, routeName )
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", heliName)
	GameObject.SendCommand(gameObjectId, { id="RequestRoute ", routeName })
end


this.ReserveMissionClear = function ( param )
	Fox.Log("#### ReserveMissionClear #### ")

	if param.isContainerClear == true then
		if TppMission.IsEmergencyMission() then
			TppMission.ResetEmegerncyMissionSetting()
			TppMission.ReserveMissionClear{
				nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_HELI,
				missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_FULTON_CONTAINER,
			}
		else
			TppMission.ReserveMissionClear{
				nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_HELI,
				missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_FULTON_CONTAINER,
			}
		end
	else
		if TppMission.IsEmergencyMission() then
			TppMission.ResetEmegerncyMissionSetting()
			TppMission.ReserveMissionClear{
				nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_HELI
			}
		else
			local nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_FREE
			if not TppTerminal.IsCleardRetakeThePlatform() then
				nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_HELI
			end
			TppMission.ReserveMissionClear{
				nextMissionId = nextMissionId,
				missionClearType = TppDefine.MISSION_CLEAR_TYPE.ON_FOOT,
			}
		end
	end
	
end





this.commonUpdateMarkerTargetFound = function ()
	Fox.Log("#### commonUpdateMarkerTargetFound ####")

	mvars.isRecognizedTarget = true

	
	s10115_radio.RecognizedTarget()

	
	s10115_radio.ChangeIntelRadio_targetActive()

	
	TppRadio.SetOptionalRadio( "Set_s0115_oprg0020" )

end






this.AddUniqueMapIconText = function ()
	Fox.Log("#### AddUniqueMapIconText ####")
	
	TppUiCommand.RegisterIconUniqueInformation{ markerId = GameObject.GetGameObjectId(MARKER_TARGET_AREA) , langId="marker_info_mission_targetArea" }

	
	TppUiCommand.RegisterIconUniqueInformation{ markerId = GameObject.GetGameObjectId(s10115_enemy.TARGET_ENEMY.NAME), langId = "marker_info_mission_target" }

	
	for idx = 1, table.getn(s10115_enemy.HOSTAGELIST) do
		TppUiCommand.RegisterIconUniqueInformation{ markerId = GameObject.GetGameObjectId(s10115_enemy.HOSTAGELIST[idx]), langId = "marker_staff_hostage" }
	end
end






this.IsLockedStaff = function ( staffId )
	Fox.Log("#### IsLockedStaff :: StaffId ".. staffId )
	for k, lockedStaffId in pairs(this.lockedStaffs) do
		if staffId == lockedStaffId then
			Fox.Log("#### This Staff is Locked ####")
			return true
		end
	end
	Fox.Log("#### This Staff is Not Locked ####")
	return false
end




this.RemoveDeadStaffs = function()
	Fox.Log("#### RemoveDeadStaffs ####")
	
	if #mvars.deadStaffList == 0 then
		Fox.Log("#### No Remove ####")
		return
	end
	Fox.Log("#### Remove StaffList is ↓↓↓####")
	if DEBUG then
		Tpp.DEBUG_DumpTable(mvars.deadStaffList)
	end
	
	TppMotherBaseManagement.RemoveStaffsS10115{ staffIds = mvars.deadStaffList }
end


this.IsHostageDamegedByPlayer = function ( damageId )
	Fox.Log("================== IsHostageDamegedByPlayer ================== ")
	if (damageId == TppDamage.ATK_FallDeath) or (damageId == TppDamage.ATK_FallBoundDeath) then
		return true
	else
		return false
	end
end






sequences.Seq_Game_MainGame = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Player = {
				{
					msg = "LandingFromHeli",
					func = function ()
						
						
						s10115_enemy.SetCPIgnoreHeli(false)
						
						mtbs_item.SwitchingLockGoalDoor(TppDefine.CLUSTER_DEFINE.Develop, GOAL_DOOR_LIST, true)
					end
				},
			},
			Marker = {
				{	
					msg = "ChangeToEnable", sender = s10115_enemy.TARGET_ENEMY.NAME,
					func = function ()
						if mvars.isRecognizedTarget == false then
							if mvars.isMarkedTargetByIntel ~= true then
								s10115_radio.MarkingTarget()
							end
							TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId(mtbs_enemy.cpNameDefine),
								{
									s10115_enemy.INTER_BOSS,
								}
							)
						else
							Fox.Log(" You already recognized Target ")
						end
					end
				},
				{	
					msg = "ChangeToEnable", sender = s10115_enemy.HOSTAGELIST,
					func = function ()
						Fox.Log("#### ChangeToEnable :: Hostage ####")
						TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId(mtbs_enemy.cpNameDefine),
							{
								s10115_enemy.INTER_HOSTAGE_PLNT2,
							}
						)
					end
				},
			},
			Radio = {
				{
					msg = "Finish", sender = "s0115_rtrg1010",
					func = function () self.MissionStart() end
				},
				{
					msg = "Finish", sender = "s0115_rtrg3000",
					func = function () 
						if s10115_enemy.isEmiliatedAllEnemy(mtbs_enemy.soldierDefine[mtbs_enemy.cpNameDefine]) then
							self.TargetEliminated()
						else
							
							s10115_radio.EliminateTarget()
						end
					end
				},
				{
					msg = "Finish", sender = "s0115_rtrg3010",
					func = function () 
						self.TargetEliminated()
					end
				},
				{
					msg = "Finish", sender = "s0115_rtrg3015",
					func = function ()
						
						TppSequence.SetNextSequence("Seq_Game_EliminatedTarget")
					end
				},
				
				{	
					msg = "Finish", sender = "s0115_esrg1010",
					func = function () s10115_radio.ChangeIntelRadio_gunMountInvalid() end
				},
				{	
					msg = "Finish", sender = "s0115_esrg1020",
					func = function () s10115_radio.ChangeIntelRadio_mortarInvalid() end
				},
				{	
					msg = "Finish", sender = "s0115_esrg1030",
					func = function () s10115_radio.ChangeIntelRadio_antiAirGunInvalid() end
				},
				{	
					msg = "Finish", sender = "s0115_esrg1080",
					func = function () s10115_radio.ChangeIntelRadio_eleGeneratorInvalid() end
				},
				{	
					msg = "Finish", sender = "s0115_esrg1070",
					func = function () s10115_radio.ChangeIntelRadio_allPipeInvalid() end
				},
				{	
					msg = "Finish", sender = "s0115_esrg1090",
					func = function () s10115_radio.ChangeIntelRadio_enemy2nd() end
				},
				{	
					msg = "Finish", sender = "s0115_esrg1100",
					func = function ()
						s10115_radio.ChangeIntelRadio_enemyInvalid()	
					end
				},
				{	
					msg = "Finish", sender = "s0115_esrg1040",
					func = function () s10115_radio.ChangeIntelRadio_hostage2nd() end
				},
				{	
					msg = "Finish", sender = "s0115_esrg1050",
					func = function () s10115_radio.ChangeIntelRadio_hostage3rd() end
				},
				{	
					msg = "Finish", sender = "s0115_esrg1060",
					func = function ()
						s10115_radio.ChangeIntelRadio_hostageInvalid()	
					end
				},
				{	
					msg = "Finish", sender = "s0115_esrg2010",
					func = function () s10115_radio.ChangeIntelRadio_targetInvalid() end
				},
			},
			GameObject = {
				{ 
					msg = "Dead", sender = s10115_enemy.TARGET_ENEMY.NAME,
					func = function ()
						
						this.targetPhote_ON()
						
						TppMission.UpdateObjective{
							objectives = { "complete_photo",}
						}
						
						TppRadioCommand.ClearEspionageRadioTable()

						
						if s10115_enemy.isEmiliatedAllEnemy(mtbs_enemy.soldierDefine[mtbs_enemy.cpNameDefine]) == true then
							
							TppSequence.SetNextSequence("Seq_Game_EliminatedAll")
						else
							
							s10115_radio.EliminateTarget()
						end
					end
				},
				{ 
					msg = "Fulton", sender = s10115_enemy.TARGET_ENEMY.NAME,
					func = function ()
						
						this.targetPhote_ON()
						
						
						TppMission.UpdateObjective{
							objectives = { "complete_photo",}
						}
						
						TppRadioCommand.ClearEspionageRadioTable()

						
						mvars.isSuccessFultonTarget = true

						local isNoticeTarget = TppMarker.GetSearchTargetIsFound( s10115_enemy.TARGET_ENEMY.NAME )
						
						s10115_radio.RecoveredTarget( isNoticeTarget )
					end
				},
				{ 
					msg = "ChangePhase", sender = this.currentClusterSetting.currentCpName,
					func = function (gameObjectId, phaseName)
						Fox.Log("mtbs_develop_cp PHASE CHANGE=============================================")
						if phaseName >= TppGameObject.PHASE_EVASION then
							Fox.Log("mtbs_develop_cp PHASE CHANGE:isPhaseOverCaution")
							mvars.isPhaseOverCaution = true
						end
						if mvars.isPhaseOverCaution == true and phaseName == TppGameObject.PHASE_CAUTION then
							Fox.Log("mtbs_develop_cp PHASE CHANGE:isNOtPhaseOverCaution")
							s10115_enemy.killHostage(s10115_enemy.TARGET_ENEMY.NAME ,s10115_enemy.HOSTAGELIST[1])
							mvars.isPhaseOverCaution = false
						end
					end
				},
				{ 
					msg = "Damage", sender = s10115_enemy.HOSTAGELIST,
					func = function (gameObjectId, attackId)
						mvars.deadCauseHostage[gameObjectId] = attackId
					end
				},
				{ 
					msg = "FultonFailed", sender = s10115_enemy.HOSTAGELIST,
					func = function (gameObjectId, locatorName, locatorNameUpper, failureType)
						
						if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
							mvars.isFuloneFailedHostage[gameObjectId] = true
						end
					end
				},
				
				
				{ 
					msg = "Dead", sender = s10115_enemy.HOSTAGELIST,
					func = function (gameObjectId, attackerId)
						self.HostageKilled(gameObjectId, attackerId)
					end
				},
				{ 
					msg = "Fulton", sender = s10115_enemy.HOSTAGELIST,
					func = function ()
						
						self.HostageRecovered()
					end
				},
			},
			Timer = {
				{
					msg = "Finish", sender = "radio_s0115_rtrg3000",
					func = function () 
						if s10115_enemy.isEmiliatedAllEnemy(mtbs_enemy.soldierDefine[mtbs_enemy.cpNameDefine]) then
							self.TargetEliminated()
						else
							
							s10115_radio.EliminateTarget()
						end
					end
				},
				{
					msg = "Finish", sender = "radio_s0115_rtrg3010",
					func = function () 
						self.TargetEliminated()
					end
				},
				{
					msg = "Finish", sender = "radio_s0115_rtrg3015",
					func = function ()
						
						TppSequence.SetNextSequence("Seq_Game_EliminatedTarget")
					end
				},
				{
					msg = "Finish",
					sender = "Timer_waitForEnemyHoldup",
					func = function ()
						s10115_enemy.AdmonishEnemy(mtbs_enemy.soldierDefine[mtbs_enemy.cpNameDefine])
					end
				},
			},
			nil
		}
	end,


	OnEnter = function()
		
		mvars.isPhaseOverCaution = false
		mvars.isRecognizedTarget = false
		mvars.numHostageRecovered = 0
		mvars.numHostageKilled = 0
		mvars.deadStaffList = {}
		mvars.deadCauseHostage = {}
		mvars.isFuloneFailedHostage = {}


		
		TppRadio.SetOptionalRadio( "Set_s0115_oprg0010" )

		s10115_radio.MissionStart()

		
		TppTelop.StartCastTelop()

		
		vars.playerDisableActionFlag = PlayerDisableAction.RIDE_HELI

		
		TppTerminal.UnSetUsageRestriction(false)

		
		this.AddUniqueMapIconText()

		
		this.lockedStaffs = TppMotherBaseManagement.GetStaffsS10115()

		
		mtbs_item.SwitchingLockGoalDoor(TppDefine.CLUSTER_DEFINE.Develop, GOAL_DOOR_LIST, true)

	end,

	OnLeave = function ()
	end,


	
	MissionStart = function ()
		Fox.Log("================== Mission Start! ================== ")
		
		
		
		this.missionObjectiveDefine.default_area_develop.gameObjectName = this.currentClusterSetting.strGoalMarker
		if mvars.numCurrentClusterGrade > 1 then
			
		end
		
		if (mvars.numCurrentClusterGrade > 2) then
			
			this.missionObjectiveDefine.default_area_hostage.gameObjectName = this.HOSTAGELIST[4]
			TppMission.UpdateObjective{
				objectives = {
					"default_area_develop",
					"default_subGoal",
					"default_photo_target",
					"default_area_hostage",
				}
			}

			
			TppInterrogation.AddHighInterrogation(
				GameObject.GetGameObjectId( mtbs_enemy.cpNameDefine ),
				{
					s10115_enemy.INTER_HOSTAGE_PLNT2,
					s10115_enemy.INTER_BOSS,
				}
			)
		elseif (mvars.numCurrentClusterGrade > 0) then
			
			TppMission.UpdateObjective{
				objectives = {
					"default_area_develop",
					"default_subGoal",
					"default_photo_target",
				}
			}

			
			TppInterrogation.AddHighInterrogation(
				GameObject.GetGameObjectId( mtbs_enemy.cpNameDefine ),
				{
					s10115_enemy.INTER_BOSS,
				}
			)
		else
			Fox.Log("================== Has No Platform! ================== ")
		end
		
	end,

	
	TargetEliminated = function ()
		if s10115_enemy.isEmiliatedAllEnemy(mtbs_enemy.soldierDefine[mtbs_enemy.cpNameDefine]) then
			TppSequence.SetNextSequence("Seq_Game_EliminatedAll")
		else
			TppSequence.SetNextSequence("Seq_Game_EliminatedTarget")
		end
	end,

	
	HostageKilled = function ( hostageId, attackerId )
		
		local deadStaffId = TppMotherBaseManagement.GetStaffIdFromGameObject{ gameObjectId = hostageId }
		if this.IsLockedStaff(deadStaffId) then
			table.insert(mvars.deadStaffList, deadStaffId)
		end
	
		local CallRadioKilledByPlayer = function ()
			
			if s10115_enemy.isLastHostage(s10115_enemy.HOSTAGELIST) == true then
				
				s10115_radio.KilledLastHostageByPlayer()
			else
				
				
				s10115_radio.KilledHostageByPlayer()
			end
		end

		local CallRadioKilledByEnemy = function ()
			
			if s10115_enemy.isLastHostage(s10115_enemy.HOSTAGELIST) == true then
				if mvars.numHostageRecovered > 0 then
					
					s10115_radio.KilledLastHostageByEnemy()
				else
					
					s10115_radio.KilledAllHostageByEnemy()
				end
			else
				
				s10115_radio.KilledHostageByEnemy()
			end
		end

		
		if Tpp.IsPlayer( attackerId ) == true then 
			CallRadioKilledByPlayer()
		elseif Tpp.IsSoldier( attackerId ) == true then 
			CallRadioKilledByEnemy()
		else	
			
			if this.IsHostageDamegedByPlayer(mvars.deadCauseHostage[hostageId]) == true then
				CallRadioKilledByPlayer()
			else
				
				
				if mvars.isFuloneFailedHostage[hostageId] ~= true then
					CallRadioKilledByEnemy()
				end
			end
		end

		
		mvars.numHostageKilled = mvars.numHostageKilled + 1
	end,

	
	
	HostageRecovered = function ( )
		if s10115_enemy.isLastHostage(s10115_enemy.HOSTAGELIST) == true then
			mvars.isFultonedLastHostage = true









		end
		
		mvars.numHostageRecovered = mvars.numHostageRecovered + 1
	end,

}


sequences.Seq_Game_EliminatedTarget = {
	Messages = function ( self ) 
		return
		StrCode32Table {
			Radio = {
				{
					msg = "Finish", sender = "s0115_rtrg3030",
					func = function ()
						mvars.canClearMission_10115 = true
					end
				},
			},
			Timer = {
				{
					msg = "Finish", sender = "radio_s0115_rtrg3030",
					func = function ()
						mvars.canClearMission_10115 = true
					end
				},
				{
					msg = "Finish",
					sender = "Timer_waitForEnemyHoldup",
					func = function ()
						
						
						this.SetPlayerMaskOnClear()
						
						s10115_enemy.AdmonishEnemy(mtbs_enemy.soldierDefine[mtbs_enemy.cpNameDefine])
					end
				},
			},
		}
	end,

	OnEnter = function ()
		Fox.Log("*** s10115 Seq_Game_EliminatedTarget ***")
		
		this.SetPlayerDisableActionOnClear()
		s10115_radio.AdmonishEnemy()
		s10115_enemy.AppearClearHeli(this.currentClusterSetting.HeliRoutes)
		GkEventTimerManager.Start( "Timer_waitForEnemyHoldup", TIMER_ENE_START_HOLDUP )

	end,

	OnLeave = function ()
	end,

	OnUpdate = function ()
		
		local canPlay = Player.CanPlayDemo(0)
		
		if mvars.canClearMission_10115 == true then
			if canPlay == true then
				this.ReserveMissionClear{ isContainerClear = false }	
			else
				Fox.Log("now waiting of the player can play demo...")
			end
		end
	end,
}


sequences.Seq_Game_EliminatedAll = {
	Messages = function ( self ) 
		return
		StrCode32Table {
			Timer = {
				{
					msg = "Finish", sender = "radio_s0115_rtrg3020",
					func = function ()
						mvars.canClearMission_10115 = true
					end
				},
			},
			Radio = {
				{
					msg = "Finish", sender = "s0115_rtrg3020",
					func = function ()
						mvars.canClearMission_10115 = true
					end
				},
			},
		}
	end,

	OnEnter = function ()
		Fox.Log("*** s10115 Seq_Game_EliminatedAll ***")
		this.SetPlayerDisableActionOnClear()
		this.SetPlayerMaskOnClear()
		s10115_radio.EliminateAllEnemy()
	end,


	OnLeave = function ()
	end,
	
	OnUpdate = function ()
		
		local canPlay = Player.CanPlayDemo(0)
		
		if mvars.canClearMission_10115 == true then
			if canPlay == true then
				this.ReserveMissionClear{ isContainerClear = false }	
			else
				Fox.Log("now waiting of the player can play demo...")
			end
		end
	end,
}



sequences.Seq_Mission_Clear = {
	OnEnter = function()
	end,

	OnLeave = function ()
	end,
}





return this