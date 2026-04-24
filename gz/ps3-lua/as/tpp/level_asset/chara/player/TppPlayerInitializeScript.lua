TppPlayerInitializeScript = {

Initialize = function()

	--Fox.Log("Initialize Player")

	local funcTable = {
		"StartCameraAnimation",
		"StartCameraAnimationNoRecover",
		"StartCameraAnimationNoRecoverNoCollsion",
		"StartCameraAnimationForSnatchWeapon",
		"StopCameraAnimation",
		"StartCureDemoEffectStart",
		"SetCameraNoise",
		"SetCameraNoiseElude",
		"SetCameraNoiseLadder",
		"SetCameraNoiseDamageBend",
		"SetCameraNoiseDamageBlow",
		"SetCameraNoiseDamageDeadStart",
		"SetCameraNoiseFallDamage",
		"SetCameraNoiseDashToWallStop",
		"SetCameraNoiseStepOn",
		"SetCameraNoiseStepDown",
		"SetCameraNoiseStepJumpEnd",
		"SetCameraNoiseStepJumpToElude",
		"SetCameraNoiseVehicleCrash",
		"SetCameraNoiseCqcHit",
		"SetCameraNoiseOnMissileFire",
		"SetCameraNoiseOnRideOnAntiAircraftGun",
		"SetHighSpeeCameraOnCQCDirectThrow",
		"SetHighSpeeCameraOnCQCComboFinish",
		"SetHighSpeeCameraAtCQCSnatchWeapon",
	}
	TppPlayerUtility.RegisterScriptFunc( "/Assets/tpp/level_asset/chara/player/TppPlayerCallbackScript.lua", funcTable )
	

	local cameraAnimationTable =  {
		--------------------------------------------------------
		-- CQC立ち直投げ4方向
		--------------------------------------------------------
		{
			name = "CqcStandThrowFront",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_thw_s_com_f_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_thw_s_com_f_02.cani",
			},
		},
				{
			name = "CqcStandThrowBack",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_thw_s_com_b_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_thw_s_com_b_02.cani",
			},
		},
		{
			name = "CqcStandThrowRight",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_thw_s_com_r_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_thw_s_com_r_02.cani",
			},
		},
		{
			name = "CqcStandThrowLeft",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_thw_s_com_l_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_thw_s_com_l_02.cani",
			},
		},
		--------------------------------------------------------
		-- ビハインドCQC立ち
		--------------------------------------------------------
		{
			name = "CqcBehindThrowStandFrontLeft",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_beh_l_thw_ef_01.cani",
			},
		},
		{
			name = "CqcBehindThrowStandFrontRight",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_beh_r_thw_ef_01.cani",
			},
		},
		{
			name = "CqcBehindThrowStandBackLeft",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_beh_l_thw_eb_01.cani",
			},
		},
		{
			name = "CqcBehindThrowStandBackRight",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_beh_r_thw_eb_01.cani",
			},
		},
		--------------------------------------------------------
		-- ビハインドCQCしゃがみ
		--------------------------------------------------------
		{
			name = "CqcBehindThrowSquatFrontLeft",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_q_beh_l_thw_ef_01.cani",
			},
		},
		{
			name = "CqcBehindThrowSquatFrontRight",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_q_beh_r_thw_ef_01.cani",
			},
		},
		{
			name = "CqcBehindThrowSquatBackLeft",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_q_beh_l_thw_eb_01.cani",
			},
		},
		{
			name = "CqcBehindThrowSquatBackRight",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_q_beh_r_thw_eb_01.cani",
			},
		},
		--------------------------------------------------------
		-- ビハインド上CQC
		--------------------------------------------------------
		{

			name = "CqcBehindCovetThrowSquatLeft",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_q_lbh_l_thw_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_q_lbh_l_thw_02.cani",
			},
		},
		{
			name = "CqcBehindCovetThrowSquatRight",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_q_lbh_r_thw_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_q_lbh_r_thw_02.cani",
			},
		},
		--------------------------------------------------------
		-- CQC拘束投げ
		--------------------------------------------------------
		{
			name = "CqcSeizeThrowFront",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_cke_nea_thw_f_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_cke_nea_thw_f_02.cani",
			},
		},
		{
			name = "CqcSeizeThrowBack",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_cke_nea_thw_b_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_cke_nea_thw_b_02.cani",
			},
		},
		--------------------------------------------------------
		-- CQC武器奪い
		--------------------------------------------------------
		{
			name = "CqcSnatchAssaultLeft",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_hld_asr_f_01.cani",
			},
		},
		{
			name = "CqcSnatchAssaultRight",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_hld_asr_f_02.cani",
			},
		},
		--------------------------------------------------------
		-- CQCコンボフィニッシュ
		--------------------------------------------------------
		{
			name = "CqcComboFinishFront",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_new_com_asr_f5_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_new_com_asr_f5_02.cani",
			},
		},
		{
			name = "CqcComboFinishBack",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_new_com_asr_b3_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_new_com_asr_b3_02.cani",
			},
		},
		--------------------------------------------------------
		-- 梯子CQC
		--------------------------------------------------------
		{
			name = "CqcLadderFront",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_lad_r_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_lad_r_02.cani",
			},
		},
		{
			name = "CqcLadderBack",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_lad_l_b_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_lad_l_b_02.cani",
			},
		},
		--------------------------------------------------------
		-- 壁ビターンCQC
		--------------------------------------------------------
		{
			name = "CqcWallThrowCommon",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_wal_com_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_wal_com_01.cani",
			},
		},
		{
			name = "CqcWallThrowFront",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_wal_atk_f_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_wal_atk_f_02.cani",
			},
		},
		{
			name = "CqcWallThrowBack",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_wal_atk_b_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_wal_atk_b_02.cani",
			},
		},
		{
			name = "CqcWallThrowNearFront",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_wal_atk_nea_f_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_wal_atk_nea_f_02.cani",
			},
		},
		{
			name = "CqcWallThrowNearBack",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_wal_atk_nea_b_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cqc/gcam_cqc_s_wal_atk_nea_b_02.cani",
			},
		},
		--------------------------------------------------------
		-- CURE胴体の銃創の治療
		--------------------------------------------------------
		{
			name = "CureGunShotWoundBodyLeft",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cue/gcam_cue_q_bdy_cue_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cue/gcam_cue_q_bdy_cue_02.cani",
			},
		},
		{
			name = "CureGunShotWoundBodyRight",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cue/gcam_cue_q_bdy_cue_r_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cue/gcam_cue_q_bdy_cue_r_02.cani",
			},
		},
		{
			name = "CureGunShotWoundBodyCrawl",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cue/gcam_cue_c_bdy_cue_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cue/gcam_cue_c_bdy_cue_02.cani",
			},
		},
		{
			name = "CureGunShotWoundBodySupine",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cue/gcam_cue_p_bdy_cue_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_cue/gcam_cue_p_bdy_cue_02.cani",
			},
		},
		--------------------------------------------------------
		-- ビークル乗り込み
		--------------------------------------------------------
		{
			name = "RideOnVehicle",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_plv/gcam_plv_s_rde_st_r_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_plv/gcam_plv_s_rde_st_r_02.cani",
			},
		},
		{
			name = "RideOnVehicleFromAssistantDriversSeat",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_plv/gcam_plv_s_rde_sid_st_l_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_plv/gcam_plv_s_rde_sid_st_l_02.cani",
			},

		},
		--------------------------------------------------------
		-- トラック乗り込み
		--------------------------------------------------------
		{
			name = "RideOnTruck",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_nmt/gcam_nmt_s_rde_drv_st_l_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_nmt/gcam_nmt_s_rde_drv_st_l_02.cani",
			},
		},
		{
			name = "RideOnTruckFromAssistantDriversSeat",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_nmt/gcam_nmt_s_rde_sid2_st_l_02.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_nmt/gcam_nmt_s_rde_sid2_st_l_01.cani",
			},

		},
		--------------------------------------------------------
		-- 機銃装甲車
		--------------------------------------------------------
		{
			name = "RideOnArmoredVehicle",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_wav/gcam_wav_s_rid_on_l_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_wav/gcam_wav_s_rid_on_l_02.cani",
				
			},
		},
		--------------------------------------------------------
		-- ヘリ
		--------------------------------------------------------
		{
			name = "RideOnHelicopter",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_sbh/gcam_sbh_q_rid_pos_l_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_sbh/gcam_sbh_q_rid_pos_l_02.cani",
			},
		},
		{
			name = "GiveCharaterRideHelicopter",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_sbh/gcam_cry_s_ene_sbh_dwn_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_sbh/gcam_cry_s_ene_sbh_dwn_02.cani",
			},

		},
		{
			name = "GiveCharaterRideHelicopterAndRideOn",
			filePath = {
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_sbh/gcam_s_ene_sbh_dwn_sit_01.cani",
				"/Assets/tpp/motion/SI_game/fani/cameras/gcam_sbh/gcam_s_ene_sbh_dwn_sit_01.cani",
			},
		},
	}
	TppPlayerUtility.RegisterCameraAnimationFilePaths( cameraAnimationTable )
end,

}
