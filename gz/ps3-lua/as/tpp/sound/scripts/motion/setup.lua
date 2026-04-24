-------------------------------------------------------------------------------
-- モーションサウンド設定スクリプト
-------------------------------------------------------------------------------
-- リファレンス設定
--								リファレンス名		デフォルトイベント名
SoundDaemon.RegisterAnimEvent(	"FOOT_GROUND_L",	"Ref_P_Fs_Ground_L"		)
SoundDaemon.RegisterAnimEvent(	"FOOT_GROUND_R",	"Ref_P_Fs_Ground_R"		)
SoundDaemon.RegisterAnimEvent(	"FOOT_LEAVE_L",		"Ref_P_Fs_Leave_L"		)
SoundDaemon.RegisterAnimEvent(	"FOOT_LEAVE_R",		"Ref_P_Fs_Leave_R"		)
SoundDaemon.RegisterAnimEvent(	"ARM_GROUND_L",		"ARM_GROUND_L"			)
SoundDaemon.RegisterAnimEvent(	"ARM_GROUND_R",		"ARM_GROUND_R"			)
SoundDaemon.RegisterAnimEvent(	"ARM_LEAVE_L",		"ARM_LEAVE_L"			)
SoundDaemon.RegisterAnimEvent(	"ARM_LEAVE_R",		"ARM_LEAVE_R"			)
SoundDaemon.RegisterAnimEvent(	"CHEST_GROUND",		"Ref_P_Chest_Ground"	)
SoundDaemon.RegisterAnimEvent(	"RATTLE_WEAPON",	"RATTLE_WEAPON"			)
SoundDaemon.RegisterAnimEvent(	"RATTLE_SUIT",		"RATTLE_SUIT"			)

-- 左右組み合わせ設定
--											左リファレンス名	右リファレンス名
SoundDaemon.MakeLeftRightAnimEventPair(		"FOOT_GROUND_L",	"FOOT_GROUND_R"		)
SoundDaemon.MakeLeftRightAnimEventPair(		"FOOT_LEAVE_L",		"FOOT_LEAVE_R"		)
SoundDaemon.MakeLeftRightAnimEventPair(		"ARM_GROUND_L",		"ARM_GROUND_R"		)
SoundDaemon.MakeLeftRightAnimEventPair(		"ARM_LEAVE_L",		"ARM_LEAVE_R"		)
