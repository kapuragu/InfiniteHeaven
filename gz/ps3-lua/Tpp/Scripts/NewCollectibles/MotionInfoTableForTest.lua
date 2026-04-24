--
--	武器のモーションリスト初期化スクリプト
--
MotionInfoTableForTest = {

InitTable = function()

	TppEquipmentParameterManager.ClearAllMotionInfo()

	----------------------------------------------------------------------------
	-- ハンドガン
	----------------------------------------------------------------------------
	TppEquipmentParameterManager.AddShootMotionInfo(
		"hg00_main0_aw0", "Shoot", 0.0
		, { "SKL_001_SLIDE", "TYPE_SLIDE_Z_ROUND", 0.0, 0.10, -0.033 }
		, { "SKL_004_HAMMER", "TYPE_ROT_X_ONEWAY", 0.0, 0.05, -62 }
		, { "SKL_007_TRIGGER", "TYPE_ROT_X_ROUND", 0.0, 0.10, 30 } )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"hg00_main0_aw0", "ShootLast", 0.0
		, { "SKL_001_SLIDE", "TYPE_SLIDE_Z_ONEWAY", 0.0, 0.05, -0.033 }
		, { "SKL_004_HAMMER", "TYPE_ROT_X_ONEWAY", 0.0, 0.05, -62 } )
	TppEquipmentParameterManager.AddMotionInfo( "hg00_main0_aw0", "Reload", "/Assets/tpp/motion/SI_game/fani/props/hg00/hg00snap/hg00snap_s_fre_emp_rld.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "hg00_main0_aw0", "ReloadFast", "/Assets/tpp/motion/SI_game/fani/props/hg00/hg00snap/hg00snap_s_fre_rld.gani" )
	TppEquipmentParameterManager.AddShootPoseInfo( "hg00_main0_aw0", "Default"
		, { "SKL_004_HAMMER", "TYPE_ROT_X", -62 } )
	TppEquipmentParameterManager.AddShootPoseInfo( "hg00_main0_aw0", "Empty"
		, { "SKL_001_SLIDE", "TYPE_SLIDE_Z", -0.033 }
		, { "SKL_004_HAMMER", "TYPE_ROT_X", -62 } )

	TppEquipmentParameterManager.AddMotionInfo( "hg01_main0_aw0", "Shoot", "/Assets/tpp/motion/SI_game/fani/props/hg01/hg01snap/hg01snap_s_fre.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "hg01_main0_aw0", "Reload", "/Assets/tpp/motion/SI_game/fani/props/hg01/hg01snap/hg01snap_s_fre_rld.gani" )
	TppEquipmentParameterManager.AddShootPoseInfo( "hg01_main0_aw0", "Default" )
	TppEquipmentParameterManager.AddShootPoseInfo( "hg01_main0_aw0", "Empty" )

	TppEquipmentParameterManager.AddMotionInfo( "hg02_main0_def", "Reload", "/Assets/tpp/motion/SI_game/fani/props/hg02/hg02snap/hg02snap_s_fre_rld.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "hg02_main0_def", "ReloadStart", "/Assets/tpp/motion/SI_game/fani/props/hg02/hg02snap/hg02snap_s_fre_rld_st.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "hg02_main0_def", "ReloadLoop", "/Assets/tpp/motion/SI_game/fani/props/hg02/hg02snap/hg02snap_s_fre_rld_lp.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "hg02_main0_def", "ReloadLoop2nd", "/Assets/tpp/motion/SI_game/fani/props/hg02/hg02snap/hg02snap_s_fre_rld_lp_2nd.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "hg02_main0_def", "ReloadEnd", "/Assets/tpp/motion/SI_game/fani/props/hg02/hg02snap/hg02snap_s_fre_rld_ed.gani" )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"hg02_main0_def", "Shoot", -1.0
		, { "SKL_002_CYLINDER", "TYPE_ROT_Z_ONEWAY", 0.0, 0.10, 72 }
		, { "SKL_006_HAMMER", "TYPE_ROT_X_ROUND", 0.0, 0.10, -27 } )
	TppEquipmentParameterManager.AddShootPoseInfo( "hg02_main0_def", "Default", { "SKL_002_CYLINDER", "TYPE_ROT_Z", 72 } )
	TppEquipmentParameterManager.AddShootPoseInfo( "hg02_main0_def", "Empty", { "SKL_002_CYLINDER", "TYPE_ROT_Z", 72 } )

	if TppGameSequence.GetGameTitleName() == "TPP" then

	TppEquipmentParameterManager.AddShootMotionInfo(
		"hg04_main0_def", "Shoot", 0.0
		, { "SKL_001_SLIDE", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.028 } )

	TppEquipmentParameterManager.AddShootMotionInfo(
		"hg07_main0_def", "Shoot", 0.0
		, { "SKL_003_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.045 } )

	end

	----------------------------------------------------------------------------
	-- サブマシンガン
	----------------------------------------------------------------------------

	TppEquipmentParameterManager.AddMotionInfo( "sm00_main0_aw0", "Reload", "/Assets/tpp/motion/SI_game/fani/props/sm00/sm00/sm00_aw0_s_fre_rld.gani" )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"sm00_main0_aw0", "Shoot", 0.0
		, { "SKL_001_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.0415 } )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"sm00_main0_aw0", "ShootLast", 0.0
		, { "SKL_001_BOLT", "TYPE_SLIDE_Z_ONEWAY", 0.0, 0.05, -0.0415 } )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"sm00_main0_aw0", "ShootCloseStock", 0.0
		, { "SKL_001_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.0415 }
		, { "SKL_003_FSTOCK", "TYPE_ROT_X_ONEWAY", 0.0, 0.0, 195 } )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"sm00_main0_aw0", "ShootCloseStockLast", 0.0
		, { "SKL_001_BOLT", "TYPE_SLIDE_Z_ONEWAY", 0.0, 0.05, -0.0415 }
		, { "SKL_003_FSTOCK", "TYPE_ROT_X_ONEWAY", 0.0, 0.0, 195 } )
	TppEquipmentParameterManager.AddShootPoseInfo( "sm00_main0_aw0", "Default" )
	TppEquipmentParameterManager.AddShootPoseInfo( "sm00_main0_aw0", "Empty", { "SKL_001_BOLT", "TYPE_SLIDE_Z", -0.0415 } )
	TppEquipmentParameterManager.AddShootPoseInfo( "sm00_main0_aw0", "CloseStock", { "SKL_003_FSTOCK", "TYPE_ROT_X", 195 } )
	TppEquipmentParameterManager.AddShootPoseInfo( "sm00_main0_aw0", "CloseStockEmpty"
		, { "SKL_003_FSTOCK", "TYPE_ROT_X", 195 }
		, { "SKL_001_BOLT", "TYPE_SLIDE_Z", -0.0415 } )

	if TppGameSequence.GetGameTitleName() == "TPP" then

	TppEquipmentParameterManager.AddShootMotionInfo(
		"sm00_main0_def", "Shoot", 0.0
		, { "SKL_001_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.0415 } )

	TppEquipmentParameterManager.AddShootMotionInfo(
		"sm01_main0_def", "Shoot", 0.0
		, { "SKL_001_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.051 } )

	end

	----------------------------------------------------------------------------
	-- アサルトライフル
	----------------------------------------------------------------------------
	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar00_main0_aw0", "Shoot", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.088 } )
	TppEquipmentParameterManager.AddShootPoseInfo( "ar00_main0_aw0", "Default" )
	TppEquipmentParameterManager.AddShootPoseInfo( "ar00_main0_aw0", "Empty", { "SKL_002_BOLT", "TYPE_SLIDE_Z", -0.088 } )

	TppEquipmentParameterManager.AddMotionInfo( "ar00_main0_aw1", "Reload", "/Assets/tpp/motion/SI_game/fani/props/ar00/ar00/ar00_aw0_s_fre_rld.gani" )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar00_main0_aw1", "Shoot", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.088 } )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar00_main0_aw1", "ShootLast", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ONEWAY", 0.0, 0.05, -0.088 } )
	TppEquipmentParameterManager.AddShootPoseInfo( "ar00_main0_aw1", "Default" )
	TppEquipmentParameterManager.AddShootPoseInfo( "ar00_main0_aw1", "Empty", { "SKL_002_BOLT", "TYPE_SLIDE_Z", -0.088 } )

	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar00_main0_aw2", "Shoot", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.088 } )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar00_main0_aw2", "ShootLast", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ONEWAY", 0.0, 0.05, -0.088 } )
	TppEquipmentParameterManager.AddShootPoseInfo( "ar00_main0_aw2", "Default" )
	TppEquipmentParameterManager.AddShootPoseInfo( "ar00_main0_aw2", "Empty", { "SKL_002_BOLT", "TYPE_SLIDE_Z", -0.088 } )

	TppEquipmentParameterManager.AddMotionInfo( "ar00_main0_aw3", "Reload", "/Assets/tpp/motion/SI_game/fani/props/ar00/ar00/ar00_aw1_s_fre_rld.gani" )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar00_main0_aw3", "Shoot", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.088 } )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar00_main0_aw3", "ShootLast", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ONEWAY", 0.0, 0.05, -0.088 } )
	TppEquipmentParameterManager.AddShootPoseInfo( "ar00_main0_aw3", "Default" )
	TppEquipmentParameterManager.AddShootPoseInfo( "ar00_main0_aw3", "Empty", { "SKL_002_BOLT", "TYPE_SLIDE_Z", -0.088 } )

	TppEquipmentParameterManager.AddMotionInfo( "ar00_main0_aw5", "Reload", "/Assets/tpp/motion/SI_game/fani/props/ar00/ar00/ar00_aw0_s_fre_rld.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "ar00_main0_aw5", "ReloadUnderBarrel", "/Assets/tpp/motion/SI_game/fani/props/ar00/ar00/ar00_aw5_snap_s_fre_rld.gani" )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar00_main0_aw5", "Shoot", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.088 } )
	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar00_main0_aw5", "ShootLast", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ONEWAY", 0.0, 0.05, -0.088 } )
	TppEquipmentParameterManager.AddShootPoseInfo( "ar00_main0_aw5", "Default" )
	TppEquipmentParameterManager.AddShootPoseInfo( "ar00_main0_aw5", "Empty", { "SKL_002_BOLT", "TYPE_SLIDE_Z", -0.088 } )

	if TppGameSequence.GetGameTitleName() == "TPP" then

	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar00_main0_def", "Shoot", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.088 } )

	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar01_main0_def", "Shoot", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.092 } )

	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar01_main1_def", "Shoot", 0.0
		, { "SKL_001_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.092 } )

	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar02_main0_def", "Shoot", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.089 } )

	TppEquipmentParameterManager.AddShootMotionInfo(
		"ew00_main0_def", "Shoot", 0.0
		, { "SKL_001_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.088 } )

	TppEquipmentParameterManager.AddShootMotionInfo(
		"ar01_main1_aw0", "Shoot", 0.0
		, { "SKL_001_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.088 } )

	end

	----------------------------------------------------------------------------
	-- スナイパーライフル
	----------------------------------------------------------------------------

	TppEquipmentParameterManager.AddMotionInfo( "sr01_main0_aw1", "Shoot", "/Assets/tpp/motion/SI_game/fani/props/sr01/sr01snap/sr01snap_s_fre.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "sr01_main0_aw1", "Reload", "/Assets/tpp/motion/SI_game/fani/props/sr01/sr01snap/sr01snap_s_fre_emp_rld.gani" )
	TppEquipmentParameterManager.AddShootPoseInfo( "sr01_main0_aw1", "Default" )
	TppEquipmentParameterManager.AddShootPoseInfo( "sr01_main0_aw1", "Empty" )

	if TppGameSequence.GetGameTitleName() == "TPP" then

	TppEquipmentParameterManager.AddShootMotionInfo(
		"sr00_main0_def", "Shoot", 0.0
		, { "SKL_002_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.088 } )

	TppEquipmentParameterManager.AddShootMotionInfo(
		"sr01_main0_def", "Shoot", 0.0 )

	end

	----------------------------------------------------------------------------
	-- マシンガン
	----------------------------------------------------------------------------

	if TppGameSequence.GetGameTitleName() == "TPP" then

	TppEquipmentParameterManager.AddShootMotionInfo(
		"mg01_main0_def", "Shoot", 0.0
		, { "SKL_005_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.073 } )

	TppEquipmentParameterManager.AddShootMotionInfo(
		"mg02_main0_def", "Shoot", 0.0
		, { "SKL_003_BOLT", "TYPE_SLIDE_Z_ROUND", 0.0, 0.05, -0.082 } )

	end

	----------------------------------------------------------------------------
	-- ショットガン
	----------------------------------------------------------------------------
	TppEquipmentParameterManager.AddMotionInfo( "sg01_main0_aw0", "Shoot", "/Assets/tpp/motion/SI_game/fani/props/sg01/sg01snap/sg01snap_s_fre.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "sg01_main0_aw0", "Reload", "/Assets/tpp/motion/SI_game/fani/props/sg01/sg01snap/sg01snap_fre_rld_1.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "sg01_main0_aw0", "ReloadEne", "/Assets/tpp/motion/SI_game/fani/props/sg01/sg01ene/sg01ene_s_rdy_rld_st.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "sg01_main0_aw0", "ReloadEneSquat", "/Assets/tpp/motion/SI_game/fani/props/sg01/sg01ene/sg01ene_q_rdy_rld_st.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "sg01_main0_aw0", "ReloadEneSquatCoverR", "/Assets/tpp/motion/SI_game/fani/props/sg01/sg01ene/sg01ene_q_cov_rld_r_st.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "sg01_main0_aw0", "ReloadEneSquatCoverL", "/Assets/tpp/motion/SI_game/fani/props/sg01/sg01ene/sg01ene_q_cov_rld_l_st.gani" )
	TppEquipmentParameterManager.AddShootPoseInfo( "sg01_main0_aw0", "Default" )
	TppEquipmentParameterManager.AddShootPoseInfo( "sg01_main0_aw0", "Empty" )

	if TppGameSequence.GetGameTitleName() == "TPP" then

	TppEquipmentParameterManager.AddShootMotionInfo(
		"sg00_main0_def", "Shoot", 0.0 )

	end

	----------------------------------------------------------------------------
	-- グレネードランチャー
	----------------------------------------------------------------------------

	if TppGameSequence.GetGameTitleName() == "TPP" then

	TppEquipmentParameterManager.AddShootMotionInfo(
		"gl01_main0_def", "Shoot", 0.0 )

	end

	----------------------------------------------------------------------------
	-- ミサイル
	----------------------------------------------------------------------------

	TppEquipmentParameterManager.AddMotionInfo( "ms02_main0_def", "Reload", "/Assets/tpp/motion/SI_game/fani/props/ms02/ms02snap/ms02snap_s_fre_rld.gani" )
	TppEquipmentParameterManager.AddMotionInfo( "ms02_main0_def", "ReloadEne", "/Assets/tpp/motion/SI_game/fani/props/ms02/ms02ene/ms02ene_s_rdy_rld.gani" )
	TppEquipmentParameterManager.AddShootPoseInfo( "ms02_main0_def", "Default" )
	TppEquipmentParameterManager.AddShootPoseInfo( "ms02_main0_def", "Empty" )

	----------------------------------------------------------------------------
	-- 車載武器など
	----------------------------------------------------------------------------
	if TppGameSequence.GetGameTitleName() == "TPP" then

	TppEquipmentParameterManager.AddShootMotionInfo( "hw01_main0_def", 0.0 )

	end

end,

}
