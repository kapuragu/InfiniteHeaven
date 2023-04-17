-- DOBUILD: 0 --OFF
-- ORIGINALQAR: chunk0
-- PACKPATH: \Assets\tpp\pack\mission2\story\s10010\s10010_l01.fpkd
-- NOTE: also \Assets\tpp\pack\mission2\story\s10010\s10010_l02.fpkd

local s10010_sequence = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}

s10010_sequence.requires = {
	"/Assets/tpp/script/location/cypr/cypr_player_rail.lua",
	"/Assets/tpp/script/location/cypr/cypr_player_volgin_ride.lua",
	"/Assets/tpp/script/location/cypr/cypr_player_bed_and_corridor.lua",
}


if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
	s10010_sequence.SKIP_TEXTURE_LOADING_WAIT = true
end





s10010_sequence.locationTelopLangIdTable = Tpp.Enum{
	{ location = "area_mission_30_10010", },
	{ location = "sub_location_30", base = "tpp_cyprus_xylotymvou", },
}





s10010_sequence.GetLocationTelopLangId = function( index )

	Fox.Log( "s10010_sequence.GetLocationTelopLangId(): index:" .. tostring( index ) )
	local locationTelopIdTable = s10010_sequence.locationTelopLangIdTable[ index ]
	if locationTelopIdTable and Tpp.IsTypeTable( locationTelopIdTable ) then
		return locationTelopIdTable.location, locationTelopIdTable.base
	end

end






s10010_sequence.DEFAULT_OVERRIDE_SYSTEM_EXCEPT_GAME_STATUS = {
	CallMenu = false,
	EquipHud = false,
	EquipPanel = true,
	CqcIcon = false,
	AnnounceLog = false,
	BaseName = false,
	PauseMenu = true,
}

local MAX_FOCUS_DISTANCE_LIMIT = 5	
local MAX_APERTURE = 1.8	
local MAX_CAMERA_RATE = 1	





s10010_sequence.GAME_OVER_DEMO_SEQUENCE_LIST = {
	"Seq_Game_EnterSmokeRoom",
	"Seq_Game_AfterHeliKillMobDemo",
	"Seq_Game_EscapeFromHeli",
	"Seq_Game_Stairway",
}






s10010_sequence.CreateOffsetVector3 = function( x, y, z )

	Fox.Log( "s10010_sequence.CreateOffsetVector3(): x:" .. tostring( x ) .. ", y:" .. tostring( y ) .. ", z:" .. tostring( z ) )
	return Vector3( x - 52.85397, y, z - 1690.13796 )

end




local routeChangeTableRoot = {
	[ StrCode32( "end_of_ish0non_q_title_look_idl" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_title_idl.gani",
			specialActionName = "end_of_ish0non_q_title_idl",
			idle = true,
			again = true,
		},
		{ func = function() s10010_sequence.StartIshmaelLookTimer() end, }
	},
	[ StrCode32( "end_of_ish0non_s_lok_wgn" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_s_dr_patidl.gani",
			specialActionName = "end_of_ish0non_s_dr_patidl",
			idle = true,
			again = true,
			position = Vector3( -42.72912, 106.177, -1712.35928 ),
			rotationY = 0,
		},
	},
	[ StrCode32( "end_of_ish0non_s_lok_cir" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_s_dr_patidl_ver2.gani",
			specialActionName = "end_of_ish0non_s_dr_patidl",
			idle = true,
			again = true,
			position = Vector3( -42.72912, 106.177, -1712.35928 ),
			rotationY = 0,
		},
	},
	[ StrCode32( "end_of_ish0non_s_1st_mov" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_idl_l.gani",
			specialActionName = "end_of_ish0non_q_idl_l",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_sof_2s_beh" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_s_beh_idl.gani",
			specialActionName = "end_of_ish0non_s_beh_idl",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_s_beh_lok_2rn_new" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_lok_l180.gani",
			specialActionName = "end_of_ish0non_q_lok_l180",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_lok_l180" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pep_fr.gani",
			specialActionName = "end_of_ish0non_q_pep_fr",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pep_fr" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_idl_come_l_a.gani",
			specialActionName = "end_of_ish0non_q_idl_come_l_a",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_idl_come_l_a" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_lok_l180.gani",
			specialActionName = "end_of_ish0non_q_lok_l180",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_s_to_vol_demo" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_idl_come_l_a.gani",
			specialActionName = "end_of_ish0non_q_idl_come_l_a",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_4f_pnt1_to_pnt2" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pep_l_a.gani",
			specialActionName = "end_of_ish0non_q_pep_l_a",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pep_l_a" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_lok_r090.gani",
			specialActionName = "end_of_ish0non_q_lok_r090",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_lok_r090" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pep_l_a.gani",
			specialActionName = "end_of_ish0non_q_pep_l_a",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_lok_bom_st" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_lok_bom_idl.gani",
			specialActionName = "end_of_ish0non_q_lok_bom_idl",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_lok_bom_ed" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pep_fr.gani",
			specialActionName = "end_of_ish0non_q_pep_fr",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_4f_pnt2_to_pnt3" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_lok_l180.gani",
			specialActionName = "end_of_ish0non_q_lok_l180",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_4f_pnt3_to_pnt4" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pep_fr.gani",
			specialActionName = "end_of_ish0non_q_pep_fr",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_4f_pnt4_to_pnt5" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_lok_l180.gani",
			specialActionName = "end_of_ish0non_q_lok_l180",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_rts_skull_after_p21_010310_0000" ) ] = {
		{ routeId = "rts_skull_after_p21_010310_0003", },
	},
	[ StrCode32( "end_of_rts_skull_after_p21_010310_0001" ) ] = {
		{ routeId = "rts_skull_after_p21_010310_0004", },
	},
	[ StrCode32( "end_of_rts_skull_after_p21_010310_0002" ) ] = {
		{ routeId = "rts_skull_after_p21_010310_0005", },
	},
	[ StrCode32( "end_of_rts_ishmael_to_ev0000" ) ] = {
		{ eventName = "end_of_rts_ishmael_to_ev0000", },
	},
	[ StrCode32( "end_of_ish0non_q_pnt1_come" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt1_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt1_idl",
			position = Vector3( -36.82696, 106.175, -1706.85758 ),
			rotationY = 0,
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt1_to_pnt2" ) ] = {
		{
			locatorName = "ishmael",
			action = "PlayState",
			state = "stateIshmael_q_pnt2_come",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt2_come.gani",
			specialActionName = "end_of_ish0non_q_pnt2_come",
			idle = true,
			enableAim = true,
			position = Vector3( -37.98294, 106.175, -1705.24456 ),
			rotationY = 0,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt2_come" ) ] = {

		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt2_to_pnt3.gani",
			specialActionName = "end_of_ish0non_q_pnt2_to_pnt3",
			idle = true,
			position = Vector3( -37.98294, 106.175, -1705.24456 ),
			rotationY = 0,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt4_come" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt4_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt4_idl",
			idle = true,
			position = Vector3( -53.34735, 106.175, -1697.54702 ),
			rotationY = 0,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt4_to_pnt5" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt5_come.gani",
			specialActionName = "end_of_ish0non_q_pnt5_come",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt5_come" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt5_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt5_idl",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt5_to_pnt6" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt6_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt6_idl",
			idle = true,
			position = Vector3( -55.054, 106.175, -1683.53623 ),
			rotationY = 0,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt6_to_pnt8" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt8_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt8_idl",
			idle = true,
			position = Vector3( -76.103111, 106.175, -1680.79017 ),
			rotationY = -90,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt8_to_pnt9" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt9_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt9_idl",
			idle = true,
			position = Vector3( -101.10983, 106.175, -1682.33594 ),
			rotationY = 44.0203,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt9_to_pnt10" ) ] = {	
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt10_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt10_idl",
			idle = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt10_to_pnt11" ) ] = {	
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt11_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt11_idl",
			position = Vector3( -115.54205, 104.175, -1678.01565 ),
			rotationY = 90,
			idle = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt11_to_pnt12" ) ] = {	
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt12_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt12_idl",
			position = Vector3( -106.46072, 102.17706, -1678.96771 ),
			rotationY = -82.8431,
			idle = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt12_to_pnt13" ) ] = {	
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt13_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt13_idl",
			position = Vector3( -110.87982, 101.17467, -1682.82547 ),
			rotationY = -90,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt13_to_pnt14" ) ] = {	
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt14_hold.gani",
			specialActionName = "end_of_ish0non_q_pnt14_hold",
			position = Vector3( -100.63428, 102.175, -1676.6675 ),
			rotationY = -24.7984,
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_dct0_guilty_a_come_1" ) ] = {	
		{
			locatorName = "dct_p21_010410_0000",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_guilty_a_idl.gani",
			specialActionName = "end_of_dct0_guilty_a_idl",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_dct0_guilty_a_come_2" ) ] = {	
		{
			locatorName = "dct_p21_010410_0000",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_guilty_a_idl.gani",
			specialActionName = "end_of_dct0_guilty_a_idl",
			idle = true,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt14_hold" ) ] = {	
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt14_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt14_idl",
			idle = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt15_to_pnt17" ) ] = {	

	},
	[ StrCode32( "end_of_ish0non_q_pnt19_to_pnt20" ) ] = {	
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt20_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt20_idl",
			idle = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt20_to_pnt21" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt21_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt21_idl",
			position = Vector3( -101.55172, 102.175, -1674.91001 ),
			rotationY = 0,
			idle = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt22_cure" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt22_demo_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt22_demo_idl",
			idle = true,
			position = Vector3( -101.55172, 102.175, -1674.91001 ),
			rotationY = 0,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt22_d2g_02" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt23_idl.gani",
			specialActionName = "ish0non_q_pnt23_idl",
			idle = true,
			position = Vector3( -106.30401, 102.175, -1683.57134 ),
			rotationY = -90,
		},
		{
			func = function()
				s10010_sequence.SetModelVisibility( { identifier = "cypr_l01_other_DataIdentifier", key = "p21_010410_cypr_grat001_door001_open", visible = true, }, true, false )
			end,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt23_to_pnt23" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt23_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt23_idl",
			idle = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt23_to_pnt24" ) ] = {
		{
			locatorName = "ishmael",
			action = "PlayState",
			state = "stateIshmael_q_pnt24_idl",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt24_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt24_idl",
			idle = true,
			enableAim = true,
			position = Vector3( -115.449303, 100.175, -1677.808594 ),
			rotationY = 90,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt24_to_pnt25" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt25_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt25_idl",
			position = Vector3( -105.06871, 98.175, -1677.47275 ),
			rotationY = 135,
			idle = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt25_to_pnt26" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt26_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt26_idl",
			position = Vector3( -100.44339, 98.175, -1683.60173 ),
			rotationY = 180,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt26_idl" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt26_come.gani",
			specialActionName = "end_of_ish0non_q_pnt26_come",
			position = Vector3( -100.44339, 98.175, -1683.60173 ),
			rotationY = 180,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt26_come" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt26_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt26_idl",
			position = Vector3( -100.44339, 98.175, -1683.60173 ),
			rotationY = 180,
			again = true,
		},
	},
	[ StrCode32( "end_of_rts_skull_curtain_0002" ) ] = {
		{ eventName = "curtainKill1", },
	},
	[ StrCode32( "end_of_rts_skull_curtain_0004" ) ] = {
		{ eventName = "curtainKill2", },
	},
	[ StrCode32( "end_of_rts_skull_curtain_0006" ) ] = {
		{ eventName = "curtainKill3", },
	},
	[ StrCode32( "end_of_rts_skull_curtain_0008_fire" ) ] = {
		{ eventName = "curtainKill4", },
	},
	[ StrCode32( "end_of_rts_skull_curtain_0008" ) ] = {
		{
			func = function()
				if TppSequence.GetCurrentSequenceName() == "Seq_Game_CurtainRoom" then
					mvars.curtainRoomEnabled = true
					s10010_sequence.ProhibitMove( true )
				end
			end,
		},
	},
	[ StrCode32( "end_of_rts_skull_corridor_0000" ) ] = {
		{
			func = function()
				if TppSequence.GetCurrentSequenceName() == "Seq_Game_AfterCurtainRoom" then
					TppSequence.SetNextSequence( "Seq_Demo_VolginVsSkullSoldier" )
				end
			end,
		},
	},
	[ StrCode32( "end_of_rts_skull_curtain_0014" ) ] = {
		{
			locatorName = "sol_p21_010420_0000",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetsmw/enetsmw_s_cypr_crtn_rom_01.gani",
			specialActionName = "end_of_rts_skull_curtain_0008",
			startPos = Vector3( -105.262, 101.375, -1655.585 ),
			startRot = TppMath.DegreeToRadian( -90 ),
			enableGravity = false,
			enableCollision = false,
		},
	},
	[ StrCode32( "end_of_rts_skull_curtain_0009" ) ] = {
		{ routeId = "rts_skull_curtain_0012", },
	},
	[ StrCode32( "end_of_rts_skull_curtain_0011" ) ] = {
		{ routeId = "rts_skull_curtain_0013", },
	},
	[ StrCode32( "end_of_ish0non_q_pnt26_to_pnt27" ) ] = {	
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt27_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt27_idl",
			idle = true,
			position = Vector3( -99.44943, 98.175, -1691.38935 ),
			rotationY = 180,
		},
		{ func = function() s10010_sequence.OnEventFinished( "enter2F" ) end, },
	},
	[ StrCode32( "end_of_rts_skull_2F_0003" ) ] = {	
		{
			func = function()
				s10010_sequence.OnEventPlayed( "enemy2fAppear" )
				s10010_sequence.OnEventFinished( "enemy2fAppear" )
				GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "SetTargetId", targetId = GameObject.GetGameObjectId( "TppSoldier2", "sol_p21_010490_0000" ), headShot = true, } )
			end,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt27_fre" ) ] = {	
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt27_to_pnt28.gani",
			specialActionName = "end_of_ish0non_q_pnt27_to_pnt28",
			position = Vector3( -99.44943, 98.175, -1691.38935 ),
			rotationY = 180,
		},
		{
			func = function()
				local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_p21_010490_0000" )
				local command = { id="AddDamage", attackId = TppDamage.ATK_10004, ownerGameObjectId = 0, isOneHitKill = true, isHeadShot = true, }
				GameObject.SendCommand( gameObjectId, command )
			end,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt27_to_pnt28" ) ] = {	
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt28_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt28_idl",
			idle = true,
			position = Vector3( -100.57097, 98.175, -1703.6334 ),
			rotationY = -152.6906,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt28_to_pnt29" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt29_to_pnt30.gani",
			specialActionName = "end_of_ish0non_q_pnt29_to_pnt30",
			position = Vector3( -99.74345, 98.17499, -1703.71292 ),
			rotationY = 180,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt29_to_pnt30" ) ] = {








		{
			func = function()
				s10010_sequence.OnEventPlayed( "twoEnemyAppear" )
				s10010_sequence.OnEventFinished( "twoEnemyAppear" )
			end,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt30_to_pnt31" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt31_sign.gani",
			specialActionName = "end_of_ish0non_q_pnt31_sign",
			idle = true,
			position = Vector3( -97.88792, 98.175, -1718.32215 ),
			rotationY = 90,
			again = true,
		},
		{
			func = function()
				sequences.Seq_Game_GunTutorial.StartPlayer()
				GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_072", } )
			end,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt31_sign" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt31_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt31_idl",
			idle = true,
			position = Vector3( -97.88792, 98.175, -1718.32215 ),
			rotationY = 90,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt31_fre" ) ] = {	
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt31_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt31_idl",
			idle = true,
			position = Vector3( -97.88792, 98.175, -1718.32215 ),
			rotationY = 90,
			again = true,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt31_to_pnt32" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt32_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt32_idl",
			idle = true,
			position = Vector3( -84.57645, 98.175, -1717.36061 ),
			rotationY = 90,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt32_to_pnt33" ) ] = {
		{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt33_idl.gani",
			specialActionName = "end_of_ish0non_q_pnt33_idl",
			idle = true,
			position = Vector3( -78.54692, 98.175, -1722.10939 ),
			rotationY = 142.6893,
		},
		{
			func = function()
				mvars.playerStop2f0002 = false
				s10010_sequence.ProhibitMove( false )
			end,
		},
	},
	[ StrCode32( "end_of_ish0non_q_pnt33_to_pnt34" ) ] = {
		{
			func = function()
				mvars.playerStop2f0003 = false
				s10010_sequence.ProhibitMove( false )
			end,
		},
	},
	[ StrCode32( "end_of_rts_volgin_start" ) ] = {
		{ eventName = "volginRideVanish", },
	},
	[ StrCode32( "end_of_rts_volgin_vanish" ) ] = {
		{ eventName = "volginRideAppear", },
	},
	[ StrCode32( "end_of_rts_skull_after_p21_010500_d_0000" ) ] = {
		{ routeId = "rts_skull_after_p21_010500_d_0006", },
	},
	[ StrCode32( "end_of_rts_skull_after_p21_010500_d_0007" ) ] = {
		{ routeId = "rts_skull_after_p21_010500_d_0008", },
	},
	[ StrCode32( "trap_Entrance_fall" ) ] = {
		{ routeId = "rts_skull_after_p21_010500_d_0007", },
	},
}




s10010_sequence.timerFunctionTable = {
}





s10010_sequence.monologueMotionTable = {
	
	
	end_of_ish0non_q_pnt2_to_pnt3 = "ISHM_022",
	end_of_ish0non_q_pnt5_to_pnt6 = "ISHM_031",
	end_of_ish0non_q_pnt8_to_pnt9 = "ISHM_033",
	
	end_of_ish0non_q_pnt13_to_pnt14 = { "ISHM_052", "ISHM_053", },
	end_of_ish0non_q_pnt14_hold = "ISHM_054",
	
	end_of_ish0non_q_pnt19_idl = "ISHM_016",
	end_of_ish0non_q_idl_l = "ISHM_016",
	
	
	end_of_ish0non_q_pnt23_to_pnt24 = "ISHM_066",
	end_of_ish0non_q_pnt28_to_pnt29 = "ISHM_068",
	
	
	
	end_of_ptn0_cutn_01_ded = "MOB_001",
	end_of_ptn0_cutn_02_ded = "MOB_002",
	end_of_ptn0_cutn_03_ded = "MOB_003",
	end_of_dct0_guilty_a_come_2 = "MOB_007",
	end_of_dct0_guilty_a_come_1 = "MOB_006",
}








function s10010_sequence.OnLoad()
	Fox.Log( "#### OnLoad ####" )

	local sequenceNameList = title_sequence.AddTitleSequences{
		
		"Seq_Demo_Flashback",
		"Seq_Game_Load21",
		"Seq_Demo_BeforeOpening",
		"Seq_Demo_Opening",
		"Seq_Demo_FewDaysLater0",
		"Seq_Game_FewDaysLater0",
		"Seq_Demo_FewDaysLater1",
		"Seq_Game_FewDaysLater1",
		"Seq_Demo_FewDaysLater1_NG0",
		"Seq_Demo_FewDaysLater1_NG1",
		"Seq_Demo_FewDaysLater1_NG2",
		"Seq_Demo_FewDaysLater2",
		"Seq_Demo_FewDaysLater2_NG0",
		"Seq_Demo_FewDaysLater2_NG1",
		"Seq_Demo_FewDaysLater2_NG2",
		"Seq_Demo_FewDaysLater2_NG3",
		"Seq_Game_FewDaysLater2",
		"Seq_Demo_FewDaysLater3",
		"Seq_Demo_OneWeekLater",
		"Seq_Game_PrepareBeforeTwoWeekLater",
		"Seq_Demo_TwoWeekLater",
		"Seq_Game_Load13",
		"Seq_Game_LoadAvatarPlayer1",
		"Seq_Game_LoadAvatarEdit",
		"Seq_Demo_SouvenirPhotograph",
		"Seq_Game_AvatarEdit",
		"Seq_Demo_LoadAvatarPlayer2",
		"Seq_Game_Load1",
		"Seq_Game_Load34",
		"Seq_Game_Load21_2",
		"Seq_Demo_PrepareBeforeQuietAppear",
		"Seq_Game_WaitCreatingBlendTexture1",
		"Seq_Demo_QuietAppear",
		"Seq_Demo_IshmaelAppear",
		"Seq_Demo_QuietExit",
		"Seq_Game_Load2",
		"Seq_Game_EscapeFromAwakeRoom",
		"Seq_Demo_Heli",
		"Seq_Game_AfterHeliDemo",
		"Seq_Demo_Volgin",
		"Seq_Game_Load3",
		"Seq_Game_AfterVolginDemo",
		"Seq_Demo_Cure",
		"Seq_Game_EnterSmokeRoom",
		"Seq_Game_GameOverBeforeSmokeRoom",
		"Seq_Demo_UnderBed",
		"Seq_Game_UnderBed",
		"Seq_Demo_UnderBed2",
		"Seq_Game_Load4",
		"Seq_Game_EscapeFromSmokeRoom",
		"Seq_Game_GameOverSmokeRoom",
		"Seq_Demo_HeliKillMob",
		"Seq_Game_AfterHeliKillMobDemo",
		"Seq_Game_GameOver_AfterSmokeRoom",
		"Seq_Demo_SoldierKillMob",
		"Seq_Game_EscapeFromHeli",
		"Seq_Game_GameOver_HeliCorridor",
		"Seq_Demo_Stairway",
		"Seq_Game_Load5",
		"Seq_Game_Stairway",
		"Seq_Game_GameOver_Stairway",
		"Seq_Demo_Corridor0",
		"Seq_Game_Corridor1",
		"Seq_Demo_Corridor1",
		"Seq_Game_Corridor2",
		"Seq_Demo_Corridor2",
		"Seq_Game_Corridor3",
		"Seq_Demo_Corridor3",
		"Seq_Game_Corridor4",
		"Seq_Demo_Corridor4",
		"Seq_Game_Corridor5",
		"Seq_Demo_Corridor5",
		"Seq_Game_Corridor6",
		"Seq_Demo_Corridor6",
		"Seq_Demo_Corridor7",
		"Seq_Game_Load6",
		"Seq_Game_CurtainRoom",
		"Seq_Game_GameOverCurtainRoom",
		"Seq_Demo_CurtainRoom",
		"Seq_Demo_CurtainRoom2",
		"Seq_Game_AfterCurtainRoom",
		"Seq_Game_GameOverCorridor",
		"Seq_Demo_VolginVsSkullSoldier",
		"Seq_Game_Load7",
		"Seq_Game_AfterCorridor",
		"Seq_Game_GameOverAfterCorridor",
		"Seq_Demo_GetGun",
		"Seq_Game_Load8",
		"Seq_Game_GunTutorial",
		"Seq_Game_GameOverGunTutorial",
		"Seq_Demo_BeforeEntrance",
		"Seq_Demo_Entrance",
		"Seq_Game_Load9",
		"Seq_Game_Entrance",
		"Seq_Demo_HijackAmbulance",
		"Seq_Game_VolginInEntrance",
		"Seq_Game_QTE_Entrance",
		"Seq_Demo_HeliRotor",
		"Seq_Demo_VolginVsTank",
		"Seq_Game_EscapeFromEntrance",
		"Seq_Demo_EscapeFromEntrance",
		"Seq_Game_Load10",
		"Seq_Demo_EscapeFromHospital",	
		"Seq_Game_Load11",
		"Seq_Game_Load35",
		"Seq_Game_LoadAvatarPlayerBeforePassport",
		"Seq_Demo_TakePassportPhotograph",
		"Seq_Game_LoadAvatarPlayerAfterPassport",
		"Seq_Game_Load31",
		"Seq_Game_WaitCreatingBlendTexture2",
		"Seq_Demo_FireWhaleTruth",
		"Seq_Game_Load32",
		"Seq_Game_PrepareBeforeMirrorPlayerLoad",
		"Seq_Game_LoadMirrorPlayer",
		"Seq_Game_History1",
		"Seq_Demo_TwoBigBoss",
		"Seq_Game_EndRoll",
		"Seq_Game_History2",
		"Seq_Game_BlackTelephone",
		"Seq_Demo_FireWhale",
		"Seq_Game_VolginRide",
		"Seq_Demo_Bridge",
		"Seq_Game_Load11_2",
		"Seq_Demo_Bridge2",
		"Seq_Game_LoadMovie",
		"Seq_Game_Telop",
		"Seq_Game_Movie",
		nil,
	}
	TppSequence.RegisterSequences( sequenceNameList )
	sequences = title_sequence.AddTitleSequenceTable(sequences)
	TppSequence.RegisterSequenceTable(sequences)
end






s10010_sequence.saveVarsList = {
	blockStep = 0,
	initialPlayerAction = PlayerInitialAction.SQUAT,
	reservedNumber0000 = 0,	
	reservedNumber0001 = 0,	
	reservedNumber0002 = 0,	
	reservedNumber0003 = 0,
	reservedNumber0004 = 0,
	reservedNumber0005 = 0,
	reservedNumber0006 = 0,
	reservedNumber0007 = 0,
	reservedNumber0008 = 0,
	reservedNumber0009 = 0,
	reservedBoolean0000 = false,	
	reservedBoolean0001 = false,	
	reservedBoolean0002 = false,	
	reservedBoolean0003 = false,	
	reservedBoolean0004 = false,	
	reservedBoolean0005 = false,
	reservedBoolean0006 = false,
	reservedBoolean0007 = false,
	reservedBoolean0008 = false,
	reservedBoolean0009 = false,
}


s10010_sequence.checkPointList = {
	"CHK_AfterAwakeRoom",
	"CHK_AfterVolgin",
	"CHK_AfterCure",
	"CHK_SmokeRoom",
	"CHK_HeliKill",
	"CHK_SoldierKill",
	"CHK_BeforeStairway",
	"CHK_Stairway",
	"CHK_CurtainRoom",
	"CHK_AfterCurtainRoom",
	"CHK_AfterCorridor",
	"CHK_GunTutorial",
	"CHK_Entrance",
	"CHK_AfterAmbulance",
	"CHK_EntranceVolgin",
	"CHK_EntranceHeli",
	"CHK_AfterEntrance",
	"CHK_AfterWhale",
	"CHK_AfterBridge",
	nil,
}







s10010_sequence.missionObjectiveDefine = {
	
	missionTask_noReflex = {	
		missionTask = { taskNo = 0, isNew = true, isComplete = false, isFirstHide = false, },
	},
	missionTask_noDamageForVolginRide = {	
		missionTask = { taskNo = 1, isNew = true, isComplete = false, isFirstHide = false, },
	},
	missionTask_killAll = {	
		missionTask = { taskNo = 0, isNew = true, isComplete = false, isFirstHide = false, },
	},
	missionTask_attackVolgin = {	
		missionTask = { taskNo = 1, isNew = true, isComplete = false, isFirstHide = false, },
	},

	
	missionTask_clear_noReflex = {	
		missionTask = { taskNo = 0, isNew = false, isComplete = true, },
	},
	missionTask_clear_noDamageForVolginRide = {	
		missionTask = { taskNo = 1, isNew = false, isComplete = true, },
	},
	missionTask_clear_killAll = {	
		missionTask = { taskNo = 0, isNew = false, isComplete = true, },
	},
	missionTask_clear_attackVolgin = {	
		missionTask = { taskNo = 1, isNew = false, isComplete = true, },
	},
}











s10010_sequence.missionObjectiveTree = {
	
	missionTask_clear_noReflex = {	
		missionTask_noReflex = {},
	},
	missionTask_clear_noDamageForVolginRide = {	
		missionTask_noDamageForVolginRide = {},
	},
	missionTask_clear_killAll = {	
		missionTask_killAll = {},
	},
	missionTask_clear_attackVolgin = {	
		missionTask_attackVolgin = {},
	},
}

s10010_sequence.missionObjectiveEnum = Tpp.Enum{
	
	"missionTask_noReflex",
	"missionTask_noDamageForVolginRide",
	"missionTask_killAll",
	"missionTask_attackVolgin",

	
	"missionTask_clear_noReflex",
	"missionTask_clear_noDamageForVolginRide",
	"missionTask_clear_killAll",
	"missionTask_clear_attackVolgin",
}


s10010_sequence.specialBonus = {
	first = {
		missionTask = { taskNo = 0, },
	},
	second = {
		missionTask = { taskNo = 1, },
	}
}








function s10010_sequence.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log( "*** " .. tostring(missionName) .. " MissionPrepare ***" )

	if missionName == "s10280" then
		PlatformConfiguration.SetShareScreenEnabled( false )	
	end

	if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
		
		
		if Mission.SetStageLoadLateEnabled then
			Mission.SetStageLoadLateEnabled(false)
		end
	end

	
	TppUiCommand.SetGameOverType( "Cyprus" )

	
	TppEffectUtility.ClearFxCutLevelMaximum()

	TppUI.OverrideFadeInGameStatus( s10010_sequence.DEFAULT_OVERRIDE_SYSTEM_EXCEPT_GAME_STATUS )

	TppTerminal.EnableTerminalVoice( false )	

	
	if cypr_mission_block then
		cypr_mission_block.OnInitialize()
	end

	
	mvars.reservedDemoSequenceList = {}	
	mvars.doesPlayerRailAction = false	
	mvars.isNotFinishedRailAction = nil	
	mvars.doesEquipInitialize = false	
	mvars.initialEquipTable = nil	
	mvars.reverseYSettingsFinished = false	
	mvars.bedActionStance = nil	
	mvars.visibilityChangedEffect = {}	
	mvars.doesHeliFire = false	
	mvars.gameObjectIdDiscoveryingPlayer = nil
	mvars.motionPlaying = {}	
	mvars.specialActioinName = {}	
	mvars.initialMotioinTable = {}	
	mvars.playerEnter = {}	
	mvars.ishmaelEnter = {}	
	mvars.executedSubEvent = {}	
	mvars.initialMobFova = {}

	
	title_sequence.MissionPrepare()
	title_sequence.RegisterMissionGameSequenceName( "Seq_Demo_Flashback" )
	title_sequence.RegisterGameStatusFunction( s10010_sequence.EnableGameStatusFunction, s10010_sequence.DisableGameStatusFunction )
	title_sequence.RegisterTitleModeOnEnterFunction( s10010_sequence.TitleModeOnEnterFunction )
	title_sequence.RegisterMessageFunction( s10010_sequence.TitleModeMessages )
	
	title_sequence.HideTitleOnInitialize()
	
	
	TppEquip.RequestLoadToEquipMissionBlock{
		TppEquip.EQP_WP_Volgin_sg_010,
	}
	local missionName = TppMission.GetMissionName()
	if missionName == "s10280" then
		
		Player.SetDoesCreateAvatarResourceBeforeMissionStart( true )
	end

	
	local playerType, parsType
	local handEquip = PlayerHandType.NORMAL
	if vars.missionCode == 10010 then
		Fox.Log( "s10010_sequence.MissionPrepare(): missionCode: 10010" )
		playerType = PlayerType.SNAKE
		parsType = PlayerPartsType.NORMAL
	elseif vars.missionCode == 10280 then
		Fox.Log( "s10010_sequence.MissionPrepare(): missionCode: 10280" )
		playerType = PlayerType.SNAKE
		parsType = PlayerPartsType.NORMAL
	else
		playerType = PlayerType.SNAKE
		parsType = PlayerPartsType.NORMAL
		Fox.Error("Invalide mission code. vars.missionCode = " .. tostring(vars.missionCode))
	end
	TppPlayer.RegisterTemporaryPlayerType{
		partsType = parsType,
		camoType = PlayerCamoType.HOSPITAL,
		playerType = playerType,
		handEquip = handEquip
	}

	
	TppMission.RegisterMissionSystemCallback{
		OnGameOver = function( gameOverType )
			Fox.Log( "s10010_sequence.MissionPrepare(): OnGameOver()" )
			if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.PLAYER_DEAD ) and s10010_sequence.DoesSequenceNeedGameOverDemo( TppSequence.GetCurrentSequenceName() ) then
				TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
				return true
			elseif TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then	
				
				TppPlayer.SetTargetDeadCamera{ gameObjectName = "ishmael", announceLog = "", }

				
				TppUiCommand.SetGameOverType( 'TimeParadox' )
				TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }

				return true
			elseif TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.PLAYER_DEAD ) and mvars.killedByVolgin then	
				local gameObjectId = GameObject.GetGameObjectId( "volgin" )
				Player.RequestToPlayCameraNonAnimation{
					characterId = gameObjectId, 
					isFollowPos = false,	
					isFollowRot = false,	
					followTime = 7,	
					followDelayTime = 0.1,	
					




					candidateRots = { { 120, -45, }, { 120, -90, }, { 120, -135, }, { 120, 180, }, { 120, 135, }, { 120, 90, } },
					skeletonNames = {"SKL_004_HEAD",},	
					



					skeletonCenterOffsets = { Vector3(0,0,0), Vector3(0,0,0), Vector3(0,0,0), Vector3(0,0,0), Vector3(0,0,0) },
					skeletonBoundings = { Vector3(0,0.45,0), Vector3(0,0,0), Vector3(0,0,0), Vector3(0, -0.3,0), Vector3(0, -0.3, 0) },
					offsetPos = Vector3( 0.4, 1.3, -2.0 ),	
					focalLength = 30.0,	
					aperture = 10.000,	
					timeToSleep = 10,	
					fitOnCamera = false,	
					timeToStartToFitCamera = 0.01,	
					fitCameraInterpTime = 0.24,	
					diffFocalLengthToReFitCamera = 16,	
				}
			end
		end,
		OnEndMissionCredit = function()
			local missionName = TppMission.GetMissionName()
			if missionName == "s10010" then
				TppSequence.SetNextSequence( "Seq_Demo_Bridge2", { isExecMissionClear = true } )
			elseif missionName == "s10280" then
				TppSequence.SetNextSequence( "Seq_Game_Load35", { isExecMissionClear = true } )
			end
		end,
		OnEndMissionReward = function()
			TppMission.MissionFinalize{ isNoFade = true, }
		end,
		OnEstablishMissionClear = function()

			Fox.Log( "s10010_sequence.MissionPrepare(): OnEstablishMissionClear()" )

			TppUiStatusManager.SetStatus( "MissionTelop", "RESULT_SKIP_GMP" )
			TppUiStatusManager.SetStatus( "MissionTelop", "RESULT_SKIP_CAST" )

			local missionName = TppMission.GetMissionName()
			if missionName == "s10280" then
				
				TppTerminal.AcquireKeyItem{
					dataBaseId = TppMotherBaseManagementConst.DESIGN_3008,
					pushReward = true,
				}
				
				TppTerminal.AcquireKeyItem{
					dataBaseId = TppMotherBaseManagementConst.DESIGN_3010,
					pushReward = true,
				}
			end
			
			
			vars.playerInjuryCount = 0
			TppMission.MissionGameEnd()
		end,
		OnSetMissionFinalScore = function()
			local missionName = TppMission.GetMissionName()
			if missionName == "s10010" then
				if not svars.reservedBoolean0000 then
					
					TppResult.AcquireSpecialBonus{ first = { isComplete = true, }, }
				end
				if not svars.reservedBoolean0001 then
					
					TppResult.AcquireSpecialBonus{ second = { isComplete = true, }, }
				end
			elseif missionName == "s10280" then
				if svars.reservedBoolean0002 then
					
					TppResult.AcquireSpecialBonus{ first = { isComplete = true, }, }
				end
				if svars.reservedNumber0000 > 19 then
					
					TppResult.AcquireSpecialBonus{ second = { isComplete = true, }, }
				end
			end
		end,
	}

	
	TppTutorial.SetIgnoredGuideInMission( 10010, "RELOAD", true )

	
	TppUiStatusManager.SetStatus( "AtTime", "INVALID" )

	
	if TppMission.GetMissionName() == "s10010" then
		SubtitlesCommand.SetIsEnableToDisplaySubtitlesLanguage( 6, false )	
	end

end




function s10010_sequence.OnRestoreSVars()

	local missionName = TppMission.GetMissionName()
	Fox.Log( "*** " .. tostring(missionName) .. " OnRestoreSVars ***" )
	Fox.Log( "s10010_sequence.OnRestoreSVars(): sequence:" .. TppSequence.GetCurrentSequenceName() )

	if not svars.reservedBoolean0003 then
		
		TppPlayer.Refresh( true )
		svars.reservedBoolean0003 = true
	else
	end

	
	if not s10010_sequence.DoesIdentifierExist( "s10010_l01_sequence_DataIdentifier" ) then	
		StageBlockCurrentPositionSetter.SetEnable( true )
		StageBlockCurrentPositionSetter.SetPosition( 1492.759, 1608.639 )
	end

	
	if svars.initialPlayerAction then
		vars.initialPlayerAction = svars.initialPlayerAction
	else
		vars.initialPlayerAction = PlayerInitialAction.SQUAT
	end

	TppSound.StopSceneBGM()
	TppSound.ResetPhaseBGM()

	
	if svars.blockStep ~= 0 then
		s10010_sequence.LoadCyprusBlock( svars.blockStep )
	else
		local missionName = TppMission.GetMissionName()
		local step
		if missionName == "s10010" then
			step = 1
		elseif missionName == "s10280" then
			step = 33
		else
			Fox.Error( "s10010_sequence.OnRestoreSVars(): This mission name is invalid! missionName:" .. missionName )
		end
		s10010_sequence.LoadCyprusBlock( step )
	end

	
	while not s10010_sequence.IsCompleteLoading() do
		if DEBUG then
			DebugText.Print( DebugText.NewContext(), {0.5, 0.5, 1.0}, "s10010_sequence.OnRestoreSVars(): Loading...")
		end
		coroutine.yield()
	end
	Fox.Log( "s10010_sequence.OnRestoreSVars(): Complete Loading" )

	coroutine.yield()

	
	if s10010_enemy then
		for mobListName, mobList in pairs( s10010_enemy.mobListTable ) do
			for i, mobLocatorName in ipairs( mobList ) do
				s10010_enemy.SetMobEnabled( mobLocatorName, false )
			end
		end
	end

	local sequenceName = TppSequence.GetMissionStartSequenceName()

	
	local eventCount = #s10010_sequence.eventList
	for i = 0, eventCount - 1 do
		local eventName = s10010_sequence.eventList[ eventCount - i ]

		if not s10010_sequence.IsEventFinished( eventName, sequenceName ) then
			local executed = false

			
			s10010_sequence.ExecSubEvent( eventName, "after", executed, true )
			if s10010_sequence.eventTableRoot[ eventName ] then
				for subEventName, subEventTable in pairs( s10010_sequence.eventTableRoot[ eventName ] ) do
					if subEventName ~= "before" and subEventName ~= "after" then
						s10010_sequence.ExecSubEvent( eventName, subEventName, executed, true )
					end
				end
			end
			s10010_sequence.ExecSubEvent( eventName, "before", executed, true )

		end

	end

	
	for i, eventName in ipairs( s10010_sequence.eventList ) do

		if s10010_sequence.IsEventFinished( eventName, sequenceName ) then
			local executed = true

			
			s10010_sequence.ExecSubEvent( eventName, "before", executed, true )
			if s10010_sequence.eventTableRoot[ eventName ] then
				for subEventName, subEventTable in pairs( s10010_sequence.eventTableRoot[ eventName ] ) do
					if subEventName ~= "before" and subEventName ~= "after" then
						s10010_sequence.ExecSubEvent( eventName, subEventName, executed, true )
					end
				end
			end
			s10010_sequence.ExecSubEvent( eventName, "after", executed, true )

		end

	end

	
	if mvars.initialEffectCreation then
		for effectName, creation in pairs( mvars.initialEffectCreation ) do
			if creation then
				s10010_sequence.CreateEffect( { func = s10010_sequence.CreateEffect, effectName = effectName, }, true, false )
			end
		end
		mvars.initialEffectCreation = {}
	end

	
	TppWeather.RequestWeather( TppDefine.WEATHER.SUNNY )

	
	if mvars.initialVolginRealize then
		s10010_sequence.RealizeVolgin( mvars.initialVolginRealize, true, false )
	end

	
	if mvars.initialPlayerCameraRotationX then
		vars.playerCameraRotation[ 0 ] = mvars.initialPlayerCameraRotationX
	end
	if mvars.initialPlayerCameraRotationY then
		vars.playerCameraRotation[ 1 ] = mvars.initialPlayerCameraRotationY
	end

	local sequenceIndex = TppSequence.GetSequenceIndex( sequenceName )
	if sequenceIndex >= TppSequence.GetSequenceIndex( "Seq_Game_GunTutorial" ) and sequenceIndex <= TppSequence.GetSequenceIndex( "Seq_Demo_EscapeFromEntrance" ) then
		
		TppEffectUtility.SetDirtyModelMemoryStrategy( "Default" )
	else
		
		TppEffectUtility.SetDirtyModelMemoryStrategy( "AllHuman" )
	end

end




function s10010_sequence.OnEndMissionPrepareSequence()

	Fox.Log( "s10010_sequence.OnEndMissionPrepareSequence()" )

	
	if mvars.doesPlayerBedAction then
		s10010_sequence.StartBedAction( { stance = mvars.bedActionStance, }, true, false )
	elseif mvars.reservedRailIndex then
		s10010_sequence.StartRailAction( { railIndex =  mvars.reservedRailIndex, }, true, false )
	elseif mvars.doesPlayerVolginRide then
		s10010_sequence.StartVolginRide( nil, true, false )
	end

	
	if vars.weapons[ 0 ] == TppEquip.EQP_None and vars.weapons[ 1 ] == TppEquip.EQP_None and vars.weapons[ 2 ] == TppEquip.EQP_None and mvars.doesEquipInitialize and mvars.initialEquipTable then
		Player.ChangeEquip{
			equipId = TppEquip[ mvars.initialEquipTable.equipId ],
			stock = mvars.initialEquipTable.stock,
			ammo = mvars.initialEquipTable.ammo,
			suppressorLife = mvars.initialEquipTable.suppressorLife,
			isSuppressorOn = mvars.initialEquipTable.isSuppressorOn,
			toActive = mvars.initialEquipTable.toActive,
			dropPrevEquip = false,
			isLightOn = false,
		}
	end

	
	for instanceName, visibility in pairs( mvars.visibilityChangedEffect ) do
		s10010_sequence.SetEffectVisiblityLazily( instanceName, visibility, true )
	end

	
	for locatorName, motionTable in pairs( mvars.initialMotioinTable ) do
		s10010_sequence.PushMotionOnSubEvent( motionTable, true, false )
	end

	
	if mvars.initialPlayerFova then
		s10010_sequence.ChangePlayerFova( { filePath = mvars.initialPlayerFova, }, true, false )
	else
		Fox.Log( "s10010_sequence.OnEndMissionPrepareSequence(): Plyaer fova is not set because there is no request." )
	end

	
	if mvars.initialPlayerInjury then
		s10010_sequence.SetInjury( mvars.initialPlayerInjury, true, false )
	end

	
	if mvars.initialUiStatus then
		for uiName, enable in pairs( mvars.initialUiStatus ) do
			s10010_sequence.EnableUI( { uiName = uiName, enable = enable }, true, false )
		end
	else
		Fox.Log( "s10010_sequence.OnEndMissionPrepareSequence(): UI is not changed because there is no request." )
	end

	
	if mvars.initialPhaseBGM then
		s10010_sequence.SetPhaseBGM( mvars.initialPhaseBGM, true, false )
	end
	if mvars.initialSceneBGM then
		s10010_sequence.SetSceneBGM( mvars.initialSceneBGM, true, false )
	end
	if mvars.initialSceneBGMSwitch then
		s10010_sequence.SetSceneBGMSwitch( mvars.initialSceneBGMSwitch, true, false )
	end

	
	local sequenceName = TppSequence.GetMissionStartSequenceName()
	local sequence = sequences[ sequenceName ]
	if sequence and sequence.OnContinue then
		sequence:OnContinue()
	end

	
	if mvars.initialPadMaskNormal then
		s10010_sequence.EnablePadMaskNormal( mvars.initialPadMaskNormal )
	end
	if mvars.initialPadMaskBeforeGetGun then
		s10010_sequence.EnablePadMaskBeforeGetGun( mvars.initialPadMaskNormal )
	end
	if mvars.initialPadMaskCombat then
		s10010_sequence.EnablePadMaskCombat( mvars.initialPadMaskCombat )
	end

	
	if mvars.initialPlayerMotionSpeed then
		s10010_sequence.SetPlayerMotionSpeed( { motionSpeed = mvars.initialPlayerMotionSpeed, }, true, false )
	end

	
	if mvars.initialMobFova and Tpp.IsTypeTable( mvars.initialMobFova ) then
		for locatorName, mobFovaTable in pairs( mvars.initialMobFova ) do
			s10010_sequence.SetUpMob( mobFovaTable )
		end
		mvars.initialMobFova = nil
	end

	if mvars.initialStartSoundEffect and Tpp.IsTypeTable( mvars.initialStartSoundEffect ) then
		for soundSourceName, soundEffectTable in pairs( mvars.initialStartSoundEffect ) do
			s10010_sequence.PlaySoundEffect( soundEffectTable, true, false )
		end
		mvars.initialStartSoundEffect = nil
	end

	if mvars.initialStopSoundEffect and Tpp.IsTypeTable( mvars.initialStopSoundEffect ) then
		for soundSourceName, soundEffectTable in pairs( mvars.initialStopSoundEffect ) do
			s10010_sequence.StopSoundEffect( soundEffectTable, true, false )
		end
		mvars.initialStopSoundEffect = nil
	end

	
	if mvars.initialHorseRoute then
		for locatorName, horseRouteTable in pairs( mvars.initialHorseRoute ) do
			s10010_sequence.ChangeHorseRoute( horseRouteTable, true, false )
		end
		mvars.initialHorseRoute = nil
	end

	
	if s10010_sequence.DoesIdentifierExist( "s10010_l01_sequence_DataIdentifier" ) then	
		Player.SetCyprPlayerPushedId( { targetId = GameObject.GetGameObjectId( "ishmael" ), isOn = 1})
	end

	
	if mvars.initialHeliSoundRequested then
		GameObject.SendCommand( GameObject.GetGameObjectId( "WestHeli" ), { id = "CallSound", eventName = "sfx_m_cypr_heli" } )	
	end

	
	if s10010_sequence.DoesIdentifierExist( "cypr_l01_other_DataIdentifier" ) then
		Gimmick.ResetGimmickData( "cypr_char005_gim_i0000|TppSharedGimmick_cypr_char005", "/Assets/tpp/level/location/cypr/block_large/block_l_stage_01/cypr_l_stage_01_env.fox2" )
	end
	if s10010_sequence.DoesIdentifierExist( "cypr_s01_other_DataIdentifier" ) then
		Gimmick.ResetGimmickData( "cypr_wndw001_glas001_gim_i0000|TppSharedGimmick_cypr_wndw001_glas001", "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2" )
		Gimmick.ResetGimmickData( "cypr_wndw001_glas002_gim_i0000|TppSharedGimmick_cypr_wndw001_glas002", "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2" )
		Gimmick.ResetGimmickData( "cypr_wndw001_glas003_gim_i0000|TppSharedGimmick_cypr_wndw001_glas003", "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2" )
		Gimmick.ResetGimmickData( "cypr_wndw001_glas004_gim_i0000|TppSharedGimmick_cypr_wndw001_glas004", "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2" )
	end

	
	if mvars.initialGimmickVisibility and next( mvars.initialGimmickVisibility ) then
		for i, initialGimmickSettingTable in ipairs( mvars.initialGimmickVisibility ) do
			s10010_sequence.SetSharedGimmickVisibility( initialGimmickSettingTable, true, false )
		end
	end

	
	s10010_sequence.SetAndStopTime( "00:00:00" )

	
	s10010_sequence.StartTimer( "Timer_LocationTelop", 1 )

	
	if Tpp.IsTypeTable( mvars.initialBloodStain ) then
		for i, bloodSettingTable in ipairs( mvars.initialBloodStain ) do
			s10010_sequence.SetBloodStain( bloodSettingTable, true, false )
		end
		mvars.initialBloodStain = {}
	end

end




function s10010_sequence.OnTerminate()

	Fox.Log( "s10010_sequence.OnTerminate()" )

	
	GrTools.SetDofControll{ enableScatter = false, nearCocLimitSize = 256.0, farCocLimitSize = 256.0, gen7MaxFarOnlyModeParam = 0.0, }

	
	if s10010_sequence.DoesIdentifierExist( "s10010_l01_sequence_DataIdentifier" ) then	
		CyprusMissionController.SendCommand{ id = "Clear", }
	end

	
	

	
	GrTools.SetSubSurfaceScatterFade( 0.0 )

	
	TppEffectUtility.ClearFxCutLevelMaximum()

	
	TppUiCommand.ResetGameOverType()

	
	TppUiStatusManager.UnsetStatus( "TelopCast", "INVALID" )
	TppUiStatusManager.UnsetStatus( "AtTime", "INVALID" )

	DemoxUi.SetDemoUiTriggerInvalid( false )

	local missionName = TppMission.GetMissionName()
	if missionName == "s10280" then
		PlatformConfiguration.SetShareScreenEnabled( true )	
	end

	
	TppEffectUtility.SetDirtyModelMemoryStrategy( "Default" )

	
	TppSoundDaemon.ResetCutSceneMute( 3536485690 )

	
	if TppMission.GetMissionName() == "s10010" then
		SubtitlesCommand.SetIsEnableToDisplaySubtitlesLanguage( 6, true )	
	end

	
	TppUiCommand.HideDemoKeyHelp()

	
	TppUiCommand.SetButtonGuideDispTime( TppTutorial.DISPLAY_TIME.DEFAULT )

end

s10010_sequence.playerInitialWeaponTable = TppDefine.CYPR_PLAYER_INITIAL_WEAPON_TABLE

s10010_sequence.playerInitialItemTable = TppDefine.CYPR_PLAYER_INITIAL_ITEM_TABLE

function s10010_sequence.ReserveMissionClear()

	Fox.Log( "s10010_sequence.ReserveMissionClear()" )

	local nextMissionId
	local missionName = TppMission.GetMissionName()
	if missionName == "s10010" then

		
		if TppStory.GetCurrentStorySequence() < TppDefine.STORY_SEQUENCE.CLEARD_TO_MATHER_BASE then
			nextMissionId = 10020
		else
			nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_HELI
		end

	elseif missionName == "s10280" then
		Fox.Log( "s10010_sequence.ReserveMissionClear(): nextMissioinId is TppDefine.SYS_MISSION_ID.MTBS_HELI" )
		nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_HELI
	else
		Fox.Error( "s10010_sequence.ReserveMissionClear(): This mission name is invalid! missionName:" .. missionName )
	end

	TppMission.ReserveMissionClear{
		missionClearType = TppDefine.MISSION_CLEAR_TYPE.CYPRUS_GOAL,
		nextMissionId = nextMissionId,
	}

end







s10010_sequence.IsEventFinished = function( eventName, currentSequence )

	Fox.Log( "s10010_sequence.IsEventFinished()" )

	if not currentSequence then
		currentSequence = TppSequence.GetCurrentSequenceName()
	end

	local currentSequenceIndex
	if currentSequence == "Seq_Demo_StartHasTitleMission" then
		currentSequenceIndex = TppSequence.GetSequenceIndex( "Seq_Demo_Flashback" )
	else
		currentSequenceIndex = TppSequence.GetSequenceIndex( currentSequence )
	end
	local eventSequenceIndex = TppSequence.GetSequenceIndex( s10010_sequence.eventSequenceTable[ eventName ] )

	Fox.Log( "s10010_sequence.IsEventFinished(): eventName:" .. tostring( eventName ) .. ", currentSequence:" .. tostring( currentSequence ) ..
		", currentSequenceIndex:" .. tostring( currentSequenceIndex ) .. ", eventSequenceIndex:" .. tostring( eventSequenceIndex ) )

	if eventSequenceIndex then
		return currentSequenceIndex > eventSequenceIndex
	end
	return true

end




s10010_sequence.LoadCyprusBlock = function( step )

	TppCyprusBlockControl.SetCyprusStep( step )
	if cypr_mission_block then
		cypr_mission_block.SetLoadStep( step )
	end
	svars.blockStep = step

end

s10010_sequence.LocatorNameUsingSpecialActionList = {
	"ishmael",
	"sol_p21_010420_0000",
	"dct_p21_010410_0000",
}

s10010_sequence.Messages = function()

	local messageTable = {
		GameObject = {
			{
				msg = "RoutePoint2",
				func = s10010_sequence.OnRoutePoint
			},
			{
				msg = "SpecialActionEnd",
				func = function( gameObjectId, actionId )
					Fox.Log( "s10010_sequence.Messages(): GameObject:SpecialActionEnd: gameObjectId:" .. tostring( gameObjectId ) .. ", actionId:" ..
						tostring( actionId ) )

					local locatorName
					for i, locatorNameInList in ipairs( s10010_sequence.LocatorNameUsingSpecialActionList ) do
						if gameObjectId == GameObject.GetGameObjectId( locatorNameInList ) then
							locatorName = locatorNameInList
							break
						end
					end

					if locatorName then
						mvars.motionPlaying[ locatorName ] = false

						if mvars.motionList[ locatorName ] and #mvars.motionList[ locatorName ] > 0 then
							s10010_sequence.PlayMotion{ locatorName = locatorName, }
						else
							s10010_sequence.OnRoutePoint( gameObjectId, nil, 0, StrCode32( mvars.specialActioinName[ locatorName ] ) )
						end
					end

				end,
			},
			{
				msg = "Dead",
				func = function( gameObjectId )

					Fox.Log( "s10010_sequence.Messages(): GameObject: Dead: gameObjectId:" .. tostring( gameObjectId ) )

					if gameObjectId ~= GameObject.GetGameObjectId( "ishmael" ) or TppSequence.GetCurrentSequenceName() == "Seq_Demo_EscapeFromHospital" then
						Fox.Log( "s10010_sequence.Messages(): ignore operation because current sequence is Seq_Demo_EscapeFromHospital." )
						return
					end

					s10010_sequence.PlayMotion{
						locatorName = "ishmael",
						motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapdam/snapdam_s_die_idl_l.gani",
						specialActionName = "end_of_snapdam_s_die_idl_l",
						override = true,
						enableCollision = true,
						enableSubCollision = true,
						enableGravity = true,
					}
					GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_094", } )

					TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )

					
					TppUiCommand.SetButtonGuideDispTime( 0.01 )

				end,
			},
			{
				msg = "Damage",
				func = function( gameObjectId, attackId, attackerGameObjectId )

					Fox.Log( "s10010_sequence.Messages(): GameObject: Damage: gameObjectId:" .. tostring( gameObjectId ) .. ", attackId:" ..
						tostring( attackId ) .. ", attackerGameObjectId" .. tostring( attackerGameObjectId ) )

					if gameObjectId ~= GameObject.GetGameObjectId( "ishmael" ) or TppSequence.GetCurrentSequenceName() == "Seq_Demo_EscapeFromHospital" then
						Fox.Log( "s10010_sequence.Messages(): ignore operation because current sequence is Seq_Demo_EscapeFromHospital." )
						return
					end

					if ( attackId == TppDamage.ATK_10001 or attackId == TppDamage.ATK_10004 or attackId == TppDamage.ATK_10006 or attackId == TppDamage.ATK_10015 or
						attackId == TppDamage.ATK_10024 or attackId == TppDamage.ATK_10035 or attackId == TppDamage.ATK_20002 or attackId == TppDamage.ATK_20006 or
						attackId == TppDamage.ATK_20015 ) and Tpp.IsPlayer( attackerGameObjectId ) then

						s10010_sequence.PlayMotion{
							locatorName = "ishmael",
							motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapdam/snapdam_s_die_idl_l.gani",
							specialActionName = "end_of_snapdam_s_die_idl_l",
							override = true,
							enableCollision = true,
							enableSubCollision = true,
							enableGravity = true,
						}
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_094", } )

						TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )

						
						TppUiCommand.SetButtonGuideDispTime( 0.01 )

					end

				end,
			},
			{
				msg = "Damage",
				sender = "sol_p21_010420_0000",
				func = function( gameObjectId )
					Fox.Log( "s10010_sequence.Messages(): GameObject: Damage: sol_p21_010420_0000" )
					GameObject.SendCommand( gameObjectId, { id="SpecialAction", isDisable = true, } )
				end,
			},
		},
		Demo = {
			{	
				msg = "PlayInit",
				func = function( demoId )

					Fox.Log( "s10010_sequence.Messages(): Demo: received PlayInit message" )

					local demoName = s10010_demo.GetDemoNameFromDemoId( demoId )
					s10010_sequence.OnEventPlayed( demoName )

				end,
				option = { isExecDemoPlaying = true, isExecMissionClear = true, },
			},
			{	
				msg = "FinishMotion",
				func = function( demoId )

					Fox.Log( "s10010_sequence.Messages(): Demo: received FinishMotion message" )

					local demoName = s10010_demo.GetDemoNameFromDemoId( demoId )
					s10010_sequence.OnEventFinished( demoName )

				end,
				option = { isExecDemoPlaying = true, isExecMissionClear = true, },
			},
			{	
				msg = "Skip",
				func = function( demoId )

					Fox.Log( "s10010_sequence.Messages(): Demo: received Skip message" )

					
					
					
					
					local eventName = s10010_demo.GetDemoNameFromDemoId( demoId )
					if s10010_sequence.eventTableRoot[ eventName ] then
						
						for subEventName, subEventTable in pairs( s10010_sequence.eventTableRoot[ eventName ] ) do
							if ( not mvars.executedSubEvent[ eventName ] or not mvars.executedSubEvent[ eventName ][ subEventName ] ) and
								( subEventName ~= "before" and subEventName ~= "after" ) then

								s10010_sequence.ExecSubEvent( eventName, subEventName, true, false, true )

							end
						end
						if s10010_sequence.eventTableRoot[ eventName ].after then
							s10010_sequence.ExecSubEvent( eventName, "after", true, false, true )
						end
					end

				end,
				option = { isExecDemoPlaying = true, isExecMissionClear = true, },
			},
		},
		Player = {
			{	
				msg = "NotifyChangedPlayerRailAction",
				func = function( gameObjectId, actionType )
					local railIndex = cypr_player_rail.GetRailIndex()
					Fox.Log( "s10010_sequence.Messages(): Player.NotifyChangedPlayerRailAction: gameObjectId:" ..
						tostring( gameObjectId ) .. ", actionType:" .. actionType .. ", railIndex:" .. railIndex )
					local eventName = s10010_sequence.RAIL_EVENT_TABLE[ railIndex ]
					Fox.Log( "s10010_sequence.Messages(): Player.NotifyChangedPlayerRailAction: eventName:" .. tostring( eventName ) )
					if eventName then
						if actionType == cypr_player_rail.Notify.FORWARD_START then
							s10010_sequence.OnEventPlayed( eventName )
						elseif actionType == cypr_player_rail.Notify.FORWARD_END then
							s10010_sequence.OnEventFinished( eventName )
						end
					end
				end,
			},
			{	
				msg = "PlayerHoldWeapon",
				func = function()
					if TppSequence.GetCurrentSequenceName() ~= "Seq_Game_VolginRide" then
						TppUI.ShowControlGuide{
							actionName = "SNIPER_RIFLE",	
							continue = false,
							isOnce = true,
						}
					end
				end,
			},
			{	
				msg = "OnAmmoLessInMagazine",
				func = function()
					Fox.Log( "s10010_sequence.Messages(): Player: OnAmmoLessInMagazine" )
					if TppSequence.GetCurrentSequenceName() ~= "Seq_Demo_EscapeFromHospital" and not svars.reservedBoolean0004 then
						TppUI.ShowTipsGuide{
							contentName = "RELOAD",	
							isOnce = false,
							isOnceThisGame = false,
						}
						svars.reservedBoolean0004 = true
					end
				end,
			},
			{	
				msg = "FinishReflexMode",
				func = function()
					Fox.Log( "s10010_sequence.Messages(): Player: FinishReflexMode" )
					svars.reservedBoolean0000 = true
				end,
			},
		},
		Trap = {
			{	
				msg = "Enter",
				func = function( trapName, gameObjectId )
					Fox.Log( "s10010_sequence.Messages(): Trap: Enter: trapName:" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )
					s10010_sequence.OnGameObjectEnterTrap( trapName, gameObjectId )
				end,
			},
			{	
				msg = "Exit",
				func = function( trapName, gameObjectId )
					Fox.Log( "s10010_sequence.Messages(): Trap: Exit: trapName:" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )
					s10010_sequence.OnGameObjectExitTrap( trapName, gameObjectId )
				end,
			},
			{
				msg = "Enter",
				sender = { "trap_Curtain_0000", "trap_Curtain_0001", "trap_Curtain_0002", "trap_Curtain_0003", "trap_Curtain_0004", },
				func = function( trapName, gameObjectId )
					Fox.Log( "s10010_sequence.Messages(): Trap: Enter: trap_Curtain_: trapName:" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )
					local position = Vector3( vars.playerPosX, vars.playerPosY, vars.playerPosZ )
					TppSoundDaemon.PostEvent3D( "sfx_m_door_curtain_int", position )
				end,
			},
			{
				msg = "Exit",
				sender = { "trap_Curtain_0000", "trap_Curtain_0001", "trap_Curtain_0002", "trap_Curtain_0003", "trap_Curtain_0004", },
				func = function( trapName, gameObjectId )
					Fox.Log( "s10010_sequence.Messages(): Trap: Exit: trap_Curtain_: trapName:" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )
					
				end,
			},
		},
		Timer = {
			{
				msg = "Finish",
				func = function( timerName )
					local Func = s10010_sequence.timerFunctionTable[ timerName ]
					if Func then
						Func()
					end
				end,
			},
			{	
				msg = "Finish",
				sender = "Timer_HandsGun0000",
				func = function()
					Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_HandsGun0000" )

					GameObject.SendCommand( { type = "TppPlayerHorse2forVr", group = 0, index = 0}, { id = "RequestHandsGunToPlayer" } )
					s10010_sequence.ChangePlayerEquip( { equipId = "EQP_WP_Volgin_sg_010", stock = 100, ammo = 6, isSuppressorOn = false, toActive = true, }, true, false )

					GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_001", } )
					GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_003", } )
					GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_004", } )

					s10010_sequence.StartTimer( "Timer_HandsGun0001", 1 )
				end,
			},
			{	
				msg = "Finish",
				sender = "Timer_HandsGun0001",
				func = function()
					Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_HandsGun0001" )
					TppUI.ShowTipsGuide{
						contentName = "STOCK_CHANGE",	
						isOnce = false,
						isOnceThisGame = false,
					}
				end,
			},
			{	
				msg = "Finish",
				sender = "Timer_LocationTelop",
				func = function()
					Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_LocationTelop" )
					if svars.reservedNumber0001 and svars.reservedNumber0001 ~= 0 then
						local locationTelopLangId, baseTelopLangId = s10010_sequence.GetLocationTelopLangId( svars.reservedNumber0001 )
						if locationTelopLangId and Tpp.IsTypeString( locationTelopLangId ) then
							TppUiCommand.CallMissionTelopTyping( locationTelopLangId, baseTelopLangId )
						end
					end
				end,
			},
		},
		UI = {
			{
				msg = "TitleMenu",
				sender = "PressStart",
				func = function()
					Fox.Log( "s10010_sequence.Messages(): UI: TitleMenu: PressStart" )
				end,
			},
			{
				msg = "GameStart",
				func = function()
					Fox.Log( "s10010_sequence.Messages(): UI: GameStart" )
				end,
			},
		},
		nil
	}

	
	for eventName, eventTable in pairs( s10010_sequence.eventTableRoot ) do
		if s10010_demo.IsDemoName( eventName ) then
			for subEventName, subEventTable in pairs( eventTable ) do
				if subEventName ~= "before" and subEventName ~= "after" then
					local demoId = s10010_demo.GetDemoIdFromDemoName( eventName )
					table.insert( messageTable.Demo, {
						msg = subEventName,
						sender = demoId,
						func = function( demoId )
							Fox.Log( "s10010_sequence.Messages(): Demo: received sub event message: subEventName:" .. tostring( subEventName ) )
							local demoName = s10010_demo.GetDemoNameFromDemoId( demoId )
							s10010_sequence.ExecSubEvent( demoName, subEventName, true, false )
						end,
						option = { isExecDemoPlaying = true },
					} )
				end
			end
		end
	end

	return
	StrCode32Table( messageTable )

end




s10010_sequence.OnGameObjectEnterTrap = function( trapName, gameObjectId )

	Fox.Log( "s10010_sequence.OnGameObjectEnterTrap(): trapName" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

	if mvars.gameObjectIdInTrap == nil then
		mvars.gameObjectIdInTrap = {}
	end
	if mvars.gameObjectIdInTrap[ trapName ] == nil then
		mvars.gameObjectIdInTrap[ trapName ] = {}
	end
	mvars.gameObjectIdInTrap[ trapName ][ gameObjectId ] = true

end




s10010_sequence.OnGameObjectExitTrap = function( trapName, gameObjectId )

	Fox.Log( "s10010_sequence.OnGameObjectExitTrap(): trapName" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

	if mvars.gameObjectIdInTrap == nil then
		mvars.gameObjectIdInTrap = {}
	end
	if mvars.gameObjectIdInTrap[ trapName ] == nil then
		mvars.gameObjectIdInTrap[ trapName ] = {}
	end

	mvars.gameObjectIdInTrap[ trapName ][ gameObjectId ] = nil	

end





s10010_sequence.StartTimer = function( timerName, timerTime )

	Fox.Log( "s10010_sequence.StartTimer(): timerName:" .. tostring( timerName ) .. ", timerTime:" .. tostring( timerTime ) )

	if GkEventTimerManager.IsTimerActive( timerName ) then
		GkEventTimerManager.Stop( timerName )
	end

	GkEventTimerManager.Start( timerName, timerTime )

end




s10010_sequence.SetAndStopTime = function( time )

	TppClock.Stop()
	TppClock.SetTime( time )

end





s10010_sequence.restraintMonologueLabelList = {
	"ISHM_046",
	"ISHM_047",
	"ISHM_048",
	"ISHM_049",
	"ISHM_050",
	"ISHM_051",
}

s10010_sequence.CallRestraintMonologue = function()

	Fox.Log( "s10010_sequence.CallRestraintMonologue()" )

	if not mvars.restraintMonologueCount then
		mvars.restraintMonologueCount = 0
	end
	local label = s10010_sequence.restraintMonologueLabelList[ mvars.restraintMonologueCount % #s10010_sequence.restraintMonologueLabelList + 1 ]
	GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = label, } )

	mvars.restraintMonologueCount = mvars.restraintMonologueCount + 1

end





s10010_sequence.DoesIdentifierExist = function( identifier )

	Fox.Log( "s10010_sequence.DoesIdentifierExist(): identifier:" .. tostring( identifier ) )

	return DataIdentifier.GetDataWithIdentifier( identifier, identifier ) ~= NULL

end





s10010_sequence.SetModelVisibility = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetModelVisibility()" )

	
	if s10010_sequence.DoesIdentifierExist( subEventTable.identifier ) then
		Fox.Log( "s10010_sequence.SetModelVisibility(): identifier:" .. tostring( subEventTable.identifier ) .. ", key:" .. tostring( subEventTable.key ) ..
			", visible:" .. tostring( subEventTable.visible ) )
		local visible = subEventTable.visible
		if not executed then
			visible = not visible	
		end
		TppDataUtility.SetVisibleDataFromIdentifier( subEventTable.identifier, subEventTable.key, visible, true )
	end

end





s10010_sequence.SetMeshVisibility = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetMeshVisibility(): ididentifier" .. tostring( subEventTable.identifier ) .. ", key:" .. tostring( subEventTable.key ) ..
		", meshName:" .. tostring( subEventTable.meshName ) .. ", visible:" .. tostring( subEventTable.visible ) )

	
	if s10010_sequence.DoesIdentifierExist( subEventTable.identifier ) then
		local visible = subEventTable.visible
		if not executed then
			visible = not visible
		end
		if visible then
			TppDataUtility.VisibleMeshFromIdentifier( subEventTable.identifier, subEventTable.key, subEventTable.meshName )
		else
			TppDataUtility.InvisibleMeshFromIdentifier( subEventTable.identifier, subEventTable.key, subEventTable.meshName )	
		end
	end

end





s10010_sequence.SetGimmickVisibility = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetGimmickVisibility(): identifier:" .. tostring( subEventTable.identifier ) .. ", type:" .. tostring( subEventTable.type ) ..
		", datasetName:" .. tostring( subEventTable.datasetName ) .. ", locatorName:" .. tostring( subEventTable.locatorName ) .. ", visible:" ..
		tostring( subEventTable.visible ) )

	
	if s10010_sequence.DoesIdentifierExist( subEventTable.identifier ) then
		local visible = not subEventTable.visible
		if not executed then
			visible = not visible
		end
		Gimmick.InvisibleGimmick( subEventTable.type, subEventTable.locatorName, subEventTable.datasetName, visible )
	end

end













s10010_sequence.SetSharedGimmickVisibility = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetGimmickVisibility(): identifier:" .. tostring( subEventTable.identifier ) .. ", datasetName:" .. tostring( subEventTable.datasetName ) ..
		", iReferencePath:" .. tostring( subEventTable.iReferencePath ) .. ", nReferencePath:" .. tostring( subEventTable.nReferencePath ) .. ", visible:" ..
		tostring( subEventTable.visible ) )

	if not skipped then
		if s10010_sequence.DoesIdentifierExist( subEventTable.identifier ) then
			local visible = subEventTable.visible
			if not executed then
				visible = not visible
			end

			if visible then	
				Gimmick.ResetGimmickData( subEventTable.iReferencePath, subEventTable.datasetName )
			else	
				Gimmick.InvisibleGimmick( -1, subEventTable.nReferencePath, subEventTable.datasetName, true )
			end
		end
	else
		if not Tpp.IsTypeTable( mvars.initialGimmickVisibility ) then
			mvars.initialGimmickVisibility = {}
		end
		table.insert( mvars.initialGimmickVisibility, subEventTable )
	end

end





s10010_sequence.EnableEnemy = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.EnableEnemy(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", enable:" .. tostring( subEventTable.enable ) )

	local enable = subEventTable.enable
	if executed then
		local gameObjectId = GameObject.GetGameObjectId( subEventTable.locatorName )

		if gameObjectId == GameObject.NULL_ID then
			
			Fox.Log( "s10010_sequence.EnableEnemy(): gameObjectId is GameObject.NULL_ID." )
			return
		end

		
		if subEventTable.locatorName == "WestHeli" then
			if enable == true then
				
				GameObject.SendCommand( gameObjectId, { id = "SetMeshType", typeName = "uth_v00", } )
				GameObject.SendCommand( gameObjectId, { id = "SetRotorSoundEnabled", enabled = false } )	
				if not skipped then
					GameObject.SendCommand( gameObjectId, { id = "CallSound", eventName = "sfx_m_cypr_heli" } )	
				else
					mvars.initialHeliSoundRequested = true
				end
			else
				mvars.initialHeliSoundRequested = false
			end
		end

		GameObject.SendCommand( gameObjectId, { id = "SetEnabled", enabled = enable, } )

		
		if subEventTable.locatorName == "ishmael" then
			if enable == true then
				GameObject.SendCommand( gameObjectId, { id = "SetHostage2Flag", flag = "commonNpc", on = true, } )
				GameObject.SendCommand( gameObjectId, { id = "SetHostage2Flag", flag = "disableDamageReaction", on = true, } )
				GameObject.SendCommand( gameObjectId, { id = "SetVoiceType", voiceType = "Ishmael", } )
				mvars.ishmaelExists = true
				TppRadio.SetGameOverRadio( TppDefine.GAME_OVER_RADIO.PLAYER_DEAD, "s0010_gmov0000" )
			else
				mvars.ishmaelExists = false
				TppRadio.SetGameOverRadio( TppDefine.GAME_OVER_RADIO.PLAYER_DEAD, TppRadio.COMMON_GAME_OVER_RADIO_LIST[ TppDefine.GAME_OVER_RADIO.PLAYER_DEAD ] )
			end
		elseif Tpp.IsSoldier( gameObjectId ) then
			GameObject.SendCommand( gameObjectId, { id = "SetForceRealize", forceRealize = enable, } )
			if enable then
				
				local light, castShadow = s10010_enemy.IsAllowedToSwitch( subEventTable.locatorName )
				GameObject.SendCommand( gameObjectId, { id = "SetGunLightSwitch", isOn = light, useCastShadow = castShadow, } )

				
				local suppressor = s10010_enemy.IsAllowedSuppressor( subEventTable.locatorName )
				GameObject.SendCommand( gameObjectId, { id = "SetVisibleSuppressor", isVisible = suppressor, } )

				
				GameObject.SendCommand( gameObjectId, { id = "SetSkull", enabled = true, } )

				
				GameObject.SendCommand( gameObjectId, { id = "SetChickenwingGunAim", enabled = true, } )
			elseif mvars.gameObjectIdInTrap then
				
				for trapName, gameObjectIdTable in pairs( mvars.gameObjectIdInTrap ) do
					if mvars.gameObjectIdInTrap[ trapName ][ gameObjectId ] then
						mvars.gameObjectIdInTrap[ trapName ][ gameObjectId ] = false
					end
				end
			end
		elseif Tpp.IsHostage( gameObjectId ) then
			GameObject.SendCommand( gameObjectId, { id = "SetHostage2Flag", flag = "disableDamageReaction", on = true, } )
		end

	end

end





s10010_sequence.ChangeEnemyRoute = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.ChangeEnemyRoute(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", sneakRouteName:" ..
		tostring( subEventTable.sneakRouteName ) .. ", cautionRouteName:" .. tostring( subEventTable.cautionRouteName ) )

	if not s10010_enemy then
		Fox.Log( "s10010_sequence.ChangeEnemyRoute(): ignore operation because s10010_enemy is not defined." )
		return
	end

	if executed and subEventTable.locatorName then
		if subEventTable.sneakRouteName then
			TppEnemy.SetSneakRoute( subEventTable.locatorName, subEventTable.sneakRouteName, 0, 0 )
		end
		if subEventTable.cautionRouteName then
			TppEnemy.SetCautionRoute( subEventTable.locatorName, subEventTable.cautionRouteName, 0, 0 )
		end
	end

end





s10010_sequence.ChangeHeliRoute = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.ChangeHeliRoute(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", routeName:" ..
		tostring( subEventTable.routeName ) )

	if executed then
		local gameObjectId = GameObject.GetGameObjectId( subEventTable.locatorName )
		if gameObjectId == GameObject.NULL_ID then
			
			Fox.Log( "s10010_sequence.ChangeHeliRoute(): gameObjectId is GameObject.NULL_ID." )
			return
		end
		local command = { id = "SetForceRoute", route = subEventTable.routeName }
		GameObject.SendCommand( gameObjectId, command )
	end

end





s10010_sequence.ChangeHorseRoute = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.ChangeHorseRoute(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", routeName:" .. tostring( subEventTable.routeName ) )

	if executed then
		if skipped then
			if not mvars.initialHorseRoute then
				mvars.initialHorseRoute = {}
			end
			subEventTable.warp = 1	
			mvars.initialHorseRoute[ subEventTable.locatorName ] = subEventTable
		else
			local warp
			if subEventTable.warp then
				warp = subEventTable.warp
			else
				warp = 0	
			end
			local gameObjectId = GameObject.GetGameObjectId( subEventTable.locatorName )
			if gameObjectId and gameObjectId ~= GameObject.NULL_ID then
				GameObject.SendCommand( gameObjectId, { id = "SetRoute", route = subEventTable.routeName, warp = warp, } )
			end
		end
	end

end





s10010_sequence.SetEffectVisibility = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetEffectVisibility(): effectName:" .. tostring( subEventTable.effectName ) .. ", visible:" .. tostring( subEventTable.visible ) )

	local visible = subEventTable.visible
	if not executed then
		visible = not visible
	end
	s10010_sequence.SetEffectVisiblityLazily( subEventTable.effectName, visible, not skipped )

end






s10010_sequence.SetEffectSize = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetEffectSize(): effectName:" .. tostring( subEventTable.effectName ) .. ", size:" .. tostring( subEventTable.size ) )

	
	if not TppDataUtility.IsReadyEffectFromGroupId( subEventTable.effectName ) then
		Fox.Log( "s10010_sequence.SetEffectSize(): ignore operation because effect does not exist. effectName:" .. tostring( subEventTable.effectName ) )
		return
	end

	if executed then
		TppDataUtility.SetVector4EffectFromGroupId( subEventTable.effectName, "Size", subEventTable.size[ 1 ], subEventTable.size[ 2 ], subEventTable.size[ 3 ], subEventTable.size[ 4 ] )
	end

end






s10010_sequence.CreateEffect = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.CreateEffect(): effectName:" .. tostring( subEventTable.effectName ) )

	if not TppDataUtility.IsReadyEffectFromGroupId( subEventTable.effectName ) then
		Fox.Log( "s10010_sequence.CreateEffect(): ignore operation because effect does not exist. effectName:" .. tostring( subEventTable.effectName ) )
		return
	end

	if executed then
		if skipped then
			if not mvars.initialEffectCreation then
				mvars.initialEffectCreation = {}
			end
			mvars.initialEffectCreation[ subEventTable.effectName ] = true
		else
			TppDataUtility.CreateEffectFromGroupId( subEventTable.effectName )
		end
	end

end





s10010_sequence.DestroyEffect = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.DestroyEffect(): effectName:" .. tostring( subEventTable.effectName ) )

	if not TppDataUtility.IsReadyEffectFromGroupId( subEventTable.effectName ) then
		Fox.Log( "s10010_sequence.DestroyEffect(): ignore operation because effect does not exist. effectName:" .. tostring( subEventTable.effectName ) )
		return
	end

	if executed then
		if skipped then
			if not mvars.initialEffectCreation then
				mvars.initialEffectCreation = {}
			end
			mvars.initialEffectCreation[ subEventTable.effectName ] = false
		else
			TppDataUtility.DestroyEffectFromGroupId( subEventTable.effectName )
		end
	end

end





s10010_sequence.EnableUI = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.EnableUI(): uiName:" .. tostring( subEventTable.uiName ) .. ", enable:" .. tostring( subEventTable.enable ) )

	local enable = subEventTable.enable
	if not executed then
		enable = not enable
	end

	if not skipped then
		if enable then
			TppUiStatusManager.UnsetStatus( subEventTable.uiName, "INVALID" )
		else
			TppUiStatusManager.SetStatus( subEventTable.uiName, "INVALID" )
		end
	else
		if not mvars.initialUiStatus then
			mvars.initialUiStatus = {}
		end
		mvars.initialUiStatus[ subEventTable.uiName ] = enable
	end

end





s10010_sequence.EnableDataBody = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.EnableDataBody()" )

	if s10010_sequence.DoesIdentifierExist( subEventTable.identifier ) then
		local enable = subEventTable.enable
		if not executed then
			enable = not enable
		end

		Fox.Log( "s10010_sequence.EnableDataBody(): identifier:" .. tostring( subEventTable.identifier ) .. ", key:" .. tostring( subEventTable.key ) ..
			", enable:" .. tostring( enable ) )

		TppDataUtility.SetEnableDataFromIdentifier( subEventTable.identifier, subEventTable.key, enable, true )
	end

end












s10010_sequence.StartRailAction = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.StartRailAction(): railIndex:" .. tostring( subEventTable.railIndex ) )

	local railPathIndex = subEventTable.railIndex
	local immediately = not skipped
	local timeOutCount = subEventTable.timeOutCount

	if not mvars.isNotFinishedRailAction then
		Fox.Log( "s10010_sequence.StartRailAction(): Cancel to start rail action because rail action is not finished." )
		return
	end

	if executed then
		if immediately then	

			local count = 30 * 5
			if timeOutCount and Tpp.IsTypeNumber( timeOutCount ) then
				count = timeOutCount
			end
			while not cypr_player_rail.Init() and count > 0 do	
				Fox.Log( "s10010_sequence.StartRailAction(): waiting cypr_player_rail.Init(): count:" .. tostring( count ) )
				count = count - 1
				coroutine.yield()
			end

			cypr_player_rail.StartAction2( railPathIndex )
			mvars.reservedRailIndex = nil

			mvars.doesPlayerRailAction = true
			mvars.isNotFinishedRailAction = true

		else

			mvars.reservedRailIndex = railPathIndex

		end
	else
		Fox.Log( "s10010_sequence.StartRailAction(): ignore operation because rail action is not executed." )
	end

end







s10010_sequence.StopRailAction = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.StopRailAction()" )

	if executed then
		if immediately then--RETAILBUG: immediately undefined
			cypr_player_rail.ForceEnd()
			mvars.doesPlayerRailAction = false
			mvars.isNotFinishedRailAction = false
		end
		mvars.reservedRailIndex = nil
	else
		mvars.isNotFinishedRailAction = true
	end

end





s10010_sequence.StartVolginRide = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.StartVolginRide()" )

	if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
		return
	end

	local immediately = not skipped
	if executed then
		if immediately and cypr_player_volgin_ride.Init() then

			cypr_player_volgin_ride.StartAction()

			local gameObjectId = GameObject.GetGameObjectId( "ocelot" )
			GameObject.SendCommand( gameObjectId, { id = "SetDemoToRideHorse", horseId = GameObject.GetGameObjectId( "ocelot_horse" ), } )

		end
		mvars.doesPlayerVolginRide = true
	else
		mvars.doesPlayerVolginRide = false
	end

end





s10010_sequence.StopVolginRide = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.StopVolginRide()" )

	local immediately = not skipped
	if executed and immediately then
		cypr_player_volgin_ride.ForceEnd()
		mvars.doesPlayerVolginRide = false
	else
		mvars.doesPlayerVolginRide = true
	end

end





s10010_sequence.SetNextSequence = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetNextSequence(): sequenceName:" .. tostring( subEventTable.sequenceName ) )

	if not skipped and executed and TppSequence.GetCurrentSequenceIndex() < TppSequence.GetSequenceIndex( subEventTable.sequenceName ) then
		TppSequence.SetNextSequence( subEventTable.sequenceName )
	end

end





s10010_sequence.SetTime = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetTime(): time:" .. tostring( subEventTable.time ) )

	
	if executed then
		s10010_sequence.SetAndStopTime( subEventTable.time )
	end

end










s10010_sequence.ChangeNpcRoute = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.ChangeNpcRoute(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", routeName:" ..
		tostring( subEventTable.routeName ) .. ", moveMotionPath:" .. tostring( subEventTable.moveMotionPath ) )

	
	if executed then

		
		local gameObjectId = GameObject.GetGameObjectId( subEventTable.locatorName )
		local command = { id = "SetSneakRoute", route = subEventTable.routeName, }
		GameObject.SendCommand( gameObjectId, command )

	end

end




s10010_sequence.PushMotion = function( motionTable )

	Fox.Log( "s10010_sequence.PushMotion(): motionTable:" .. tostring( motionTable ) )

	if not mvars.motionPlayed then
		mvars.motionPlayed = {}
	end

	if motionTable.specialActionName and not motionTable.again then
		if not mvars.motionPlayed[ motionTable.specialActionName ] then
			mvars.motionPlayed[ motionTable.specialActionName ] = true
		else
			return
		end
	end

	if motionTable.locatorName and ( motionTable.motionPath or motionTable.state ) then

		if not mvars.motionList then
			mvars.motionList = {}
		end
		if not mvars.motionList[ motionTable.locatorName ] then
			mvars.motionList[ motionTable.locatorName ] = {}
		end

		
		if motionTable.override then
			mvars.motionPlaying[ motionTable.locatorName ] = nil
			mvars.motionList[ motionTable.locatorName ] = nil
			s10010_sequence.PlayMotion( motionTable )
		elseif not mvars.motionPlaying[ motionTable.locatorName ] and not next( mvars.motionList[ motionTable.locatorName ] ) then
			s10010_sequence.PlayMotion( motionTable )
		else
			
			table.insert( mvars.motionList[ motionTable.locatorName ], motionTable )
		end

	else
		Fox.Log( "s10010_sequence.PushMotion(): locatorName or motionPath is not defined." )
	end

end





s10010_sequence.PlayMotion = function( inMotionTable )

	Fox.Log( "s10010_sequence.PlayMotion(): locatorName:" .. tostring( inMotionTable.locatorName ) .. ", motionPath:" .. tostring( inMotionTable.motionPath ) ..
		", specialActionName:" .. tostring( inMotionTable.specialActionName ) .. ", position:" .. tostring( inMotionTable.position ) .. ", rotationY:" ..
		tostring( inMotionTable.rotationY ) .. ", idle:" .. tostring( inMotionTable.idle ) .. ", enableGunFire:" .. tostring( inMotionTable.enableGunFire ) )

	local motionTable = inMotionTable
	if not motionTable or not motionTable.locatorName then
		Fox.Error( "s10010_sequence.PlayMotion(): inMotionTable or inMotionTable.locatorName is nil! This function cannot continue operation!" )
		return
	end

	
	if not motionTable.motionPath and not motionTable.state then
		if mvars.motionList and mvars.motionList[ motionTable.locatorName ] and mvars.motionList[ motionTable.locatorName ][ 1 ] then
			motionTable = mvars.motionList[ motionTable.locatorName ][ 1 ]
			table.remove( mvars.motionList[ motionTable.locatorName ], 1 )
		else
			Fox.Log( "s10010_sequence.PlayMotion(): ignore operation because there is no motionTable." )
			return
		end
	end

	local locatorName = motionTable.locatorName
	local motionPath = motionTable.motionPath
	local specialActionName = motionTable.specialActionName
	local position = motionTable.position
	local rotationY = motionTable.rotationY
	local idle = motionTable.idle
	local enableGunFire = motionTable.enableGunFire
	local OnStart = motionTable.OnStart
	local action = motionTable.actioin
	if not action then
		action = "PlayMotion"
	end
	local state = motionTable.state
	local enableAim = motionTable.enableAim
	local charaControl = motionTable.charaControl
	local startPos = motionTable.startPos
	local startRot = motionTable.startRot
	local interpFrame = motionTable.interpFrame
	local enableCollision = motionTable.enableCollision or false
	local enableSubCollision = motionTable.enableSubCollision or false
	local enableGravity = motionTable.enableGravity or false
	local enableCurtain = motionTable.enableCurtain

	local gameObjectId = GameObject.GetGameObjectId( locatorName )

	local autoFinish = false

	if position or rotationY then
		if gameObjectId ~= GameObject.NULL_ID then
			GameObject.SendCommand( gameObjectId, { id = "Warp", degRotationY = rotationY, position = position, demoEnd = true, interpTime = 0.1, control = charaControl, } )
		end
	else
		Fox.Log( "s10010_sequence.PlayMotion(): position or rotationY is not defined." )
	end

	
	if Tpp.IsTypeTable( motionPath ) then
		motionPath = motionPath[ math.random( #motionPath ) ]
		Fox.Log( "s10010_sequence.PlayMotion(): random motionPath:" .. tostring( motionPath ) )
	end

	if gameObjectId ~= GameObject.NULL_ID then
		GameObject.SendCommand( gameObjectId, {
			id = "SpecialAction",
			action = action,
			path = motionPath,
			state = state,
			autoFinish = autoFinish,
			enableMessage = true,
			enableGravity = motionTable.enableGravity,
			enableCollision = enableCollision,
			enableSubCollision = enableSubCollision,
			enableGunFire = enableGunFire,
			enableAim = enableAim,
			startPos = startPos,
			startRot = startRot,
			enableCurtain = enableCurtain,
		} )
	end

	mvars.specialActioinName[ locatorName ] = specialActionName
	if not idle then
		mvars.motionPlaying[ locatorName ] = true
	end

	
	local voiceIdList = s10010_sequence.monologueMotionTable[ specialActionName ]
	if voiceIdList then
		if not Tpp.IsTypeTable( voiceIdList ) then
			voiceIdList = { voiceIdList }
		end
		for i, voiceId in ipairs( voiceIdList ) do
			GameObject.SendCommand( GameObject.GetGameObjectId( locatorName ), { id = "CallMonologue", label = voiceId, } )
		end
	end

	
	if OnStart and Tpp.IsTypeFunc( OnStart ) then
		OnStart()
	end

end












s10010_sequence.PushMotionOnSubEvent = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.PushMotionOnSubEvent(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", motionPath:" ..
		tostring( subEventTable.motionPath ) .. ", specialActionName:" .. tostring( subEventTable.specialActionName ) )

	if executed then
		if not skipped then
			s10010_sequence.PushMotion( subEventTable )
		else
			mvars.initialMotioinTable[ subEventTable.locatorName ] = subEventTable
		end
	end

end





s10010_sequence.EnableMob = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.EnableMob(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", enable:" .. tostring( subEventTable.enable ) )

	if not s10010_enemy then
		Fox.Log( "s10010_sequence.EnableMob(): ignore operation because s10010_enemy is not defined." )
		return
	end

	local enable = subEventTable.enable
	if not executed then
		enable = not enable
	end
	s10010_enemy.SetMobEnabled( subEventTable.locatorName, enable )

	if not Tpp.IsTypeTable( mvars.mobEnabled ) then
		mvars.mobEnabled = {}
	end
	mvars.mobEnabled[ subEventTable.locatorName ] = enable

end




s10010_sequence.SetUpMob = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetUpMob(): locatorName:" .. tostring( subEventTable.locatorName ) )

	if not s10010_enemy then
		Fox.Log( "s10010_sequence.SetUpMob(): ignore operation because s10010_enemy is not defined." )
		return
	end

	if executed then
		if not skipped then
			s10010_enemy.SetUpMobFova( subEventTable.locatorName )
		else
			mvars.initialMobFova[ subEventTable.locatorName ] = subEventTable
		end
	end

end





s10010_sequence.StartBedAction = function( subEventTable, executed, skipped )

	local stance = subEventTable.stance

	if Tpp.IsTypeString( stance ) then
		stance = cypr_player_bed_and_corridor.ActionState[ stance ]
	end

	if not stance then
		stance = cypr_player_bed_and_corridor.ActionState.BED_FLAT
	end

	Fox.Log( "s10010_sequence.StartBedAction(): stance:" .. tostring( stance ) )

	if executed then
		if not skipped then
			if cypr_player_bed_and_corridor.Init() then

				Fox.Log( "s10010_sequence.StartBedAction(): execute immediately." )

				cypr_player_bed_and_corridor.Start( stance )
				cypr_player_bed_and_corridor.SetEyelidFilterState( cypr_player_bed_and_corridor.EyelidFilterState.CLOSE )
				cypr_player_bed_and_corridor.FadeInEyelidFilter()
				cypr_player_bed_and_corridor.SetFocalLength( 20.785 )

			end
		else
			Fox.Log( "s10010_sequence.StartBedAction(): execute before starting mission." )
			mvars.doesPlayerBedAction = true	
		end
	end

end





s10010_sequence.ChangeBedActionStance = function( subEventTable, executed, skipped )

	local stance = subEventTable.stance

	if Tpp.IsTypeString( stance ) then
		stance = cypr_player_bed_and_corridor.ActionState[ stance ]
	end
	if not stance then
		stance = cypr_player_bed_and_corridor.ActionState.BED_FLAT
	end

	Fox.Log( "s10010_sequence.ChangeBedActionStance(): stance:" .. tostring( stance ) )

	if executed then
		if not skipped then
			cypr_player_bed_and_corridor.Start( stance )
		else
			mvars.bedActionStance = stance
		end
	end

end





s10010_sequence.StopBedAction = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.StopBedAction()" )

	if executed then
		if not skipped then
			cypr_player_bed_and_corridor.End()
		else
			mvars.doesPlayerBedAction = false
		end
	end

end







s10010_sequence.ChangePlayerEquip = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.ChangePlayerEquip(): equipId:" .. tostring( subEventTable.equipId ) .. ", stock:" .. tostring( subEventTable.stock ) ..
		", ammo:" .. tostring( subEventTable.ammo ) .. ", isSuppressorOn:" .. tostring( subEventTable.isSuppressorOn ) ..
		", suppressorLife:" .. tostring( subEventTable.suppressorLife ) .. ", toActive:" .. tostring( subEventTable.toActive ) )

	if executed then
		if not skipped then
			Player.ChangeEquip{
				equipId = TppEquip[ subEventTable.equipId ],
				stock = subEventTable.stock,
				ammo = subEventTable.ammo,
				suppressorLife = subEventTable.suppressorLife,
				isSuppressorOn = subEventTable.isSuppressorOn,
				isLightOn = false,
				toActive = subEventTable.toActive,
				dropPrevEquip = false,
			}
		else
			mvars.doesEquipInitialize = true
			mvars.initialEquipTable = subEventTable
		end
	end

end





s10010_sequence.UnsetEquip = function( subEventTable, executed, skipped )

	if executed then
		if not skipped then
			Player.UnsetEquip{
				slotType = subEventTable.slot,    
				dropPrevEquip = false,  
			}
		else
			mvars.doesEquipInitialize = false
			mvars.initialEquipTable = nil
		end
	end

end





s10010_sequence.RealizeVolgin = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.RealizeVolgin(): realize:" .. tostring( subEventTable.realize ) )

	if not skipped then
		local gameObjectId = GameObject.GetGameObjectId( "volgin" )
		if gameObjectId ~= GameObject.NULL_ID then
			local realize = subEventTable.realize
			GameObject.SendCommand( gameObjectId, { id = "SetForceRealize", forceRealize = realize, } )
			GameObject.SendCommand( gameObjectId, { id = "SetForceUnrealize", forceUnrealize = not realize, } )
			Fox.Log( "s10010_sequence.RealizeVolgin(): executed!" )
		end
		mvars.initialVolginRealize = nil
	else
		mvars.initialVolginRealize = subEventTable
	end

end





s10010_sequence.WarpVolgin = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.WarpVolgin(): identifier:" .. tostring( subEventTable.identifier ) .. ", key:" .. tostring( subEventTable.key ) )

	local gameObjectId = GameObject.GetGameObjectId( "volgin" )
	if executed and gameObjectId ~= GameObject.NULL_ID then
		local translation, rotQuat = Tpp.GetLocatorByTransform( subEventTable.identifier, subEventTable.key )
		GameObject.SendCommand( gameObjectId, { id = "Warp", position = translation, rotationY = Tpp.GetRotationY( rotQuat ), } )
	end

end





s10010_sequence.ChangeVolginRoute = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.ChangeVolginRoute(): routeName:" .. tostring( subEventTable.routeName ) )

	if executed then
		




	end

end





s10010_sequence.SetEnemyPuppet = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetEnemyPuppet(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", puppet:" ..
		tostring( subEventTable.puppet ) )

	local puppet = subEventTable.puppet
	if not executed then
		puppet = not puppet
	end

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", subEventTable.locatorName )
	if gameObjectId ~= GameObject.NULL_ID then
		GameObject.SendCommand( gameObjectId, { id = "SetPuppet", enabled = puppet, } )
	end

end




s10010_sequence.SetPlayerMotionSpeed = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetPlayerMotionSpeed(): motionSpeed:" .. tostring( subEventTable.motionSpeed ) )

	if not s10010_sequence.DoesIdentifierExist( "s10010_l01_sequence_DataIdentifier" ) then	
		Fox.Log( "s10010_sequence.ChangePlayerFova(): ignore operation because player instance does not exist in this sequence." )
		return
	end

	if executed then
		if skipped then
			mvars.initialPlayerMotionSpeed = subEventTable.motionSpeed
		else
			GameObject.SendCommand( GameObject.GetGameObjectId( "Player" ), { id = "SetBaseMotionSpeedRate", speedRate = subEventTable.motionSpeed, } )
		end
	end

end






s10010_sequence.BreakGimmick = function( subEventTable, executed, skipped, demoSkipped )

	Fox.Log( "s10010_sequence.BreakGimmick(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", datasetPath:" .. tostring( subEventTable.datasetPath )
		.. ", executed:" .. tostring( executed ) .. ", skipped:" .. tostring( skipped ) .. ", demoSkipped:" .. tostring( demoSkipped ) )

	if executed and not skipped and not demoSkipped then
		Gimmick.BreakGimmick( TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, subEventTable.locatorName, subEventTable.datasetPath, false )
	end

end





s10010_sequence.SetInjury = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetInjury(): type:" .. tostring( subEventTable.type ) )

	if executed then
		if not skipped then
			Player.SetForceInjury{ type = subEventTable.type, }
		else
			mvars.initialPlayerInjury = subEventTable
		end
	end

end






s10010_sequence.CureIfSkipped = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.CureIfSkipped(): cure:" .. tostring( subEventTable.cure ) )

	local cure = subEventTable.cure
	if not executed then
		cure = not cure
	end

	if skipped and cure then
		mvars.initialPlayerInjury = nil
	end

end





s10010_sequence.ChangePlayerFova = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.ChangePlayerFova(): filePath:" .. tostring( subEventTable.filePath ) )

	if not s10010_sequence.DoesIdentifierExist( "s10010_l01_sequence_DataIdentifier" ) then	
		Fox.Log( "s10010_sequence.ChangePlayerFova(): ignore operation because player instance does not exist in this sequence." )
		return
	end

	if executed then
		if skipped then
			mvars.initialPlayerFova = subEventTable.filePath	
		else
			Fox.Log( "s10010_sequence.ChangePlayerFova(): executed!" )
			Player.ApplyFormVariationWithFile( subEventTable.filePath )
		end
	end

end





s10010_sequence.StartVolginShooting = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.StartVolginShooting()" )

	if executed and not skipped then
		GameObject.SendCommand( GameObject.GetGameObjectId( "Player" ), { id = "SetSpecialAttackMode", enabled = true, type = "AttackVolgin" } )
		Player.ChangeEquip{
			equipId = TppEquip.EQP_WP_East_sm_030,     
			stock = 30,	
			stockSub = 0,	
			ammo = 30,	
			ammoSub = 0,	
			suppressorLife = 0,	
			isSuppressorOn = false,	
			isLightOn = false,	
			dropPrevEquip = false,	
			
		}
	else
		Fox.Log( "s10010_sequence.StartVolginShooting(): ignore operation because the sequence is skipped." )
	end

end





s10010_sequence.StopVolginShooting = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.StopVolginShooting()" )
	if executed and not skipped then
		GameObject.SendCommand( { type = "TppPlayer2", index = PlayerInfo.GetLocalPlayerIndex() }, { id = "SetSpecialAttackMode", enabled = false, type = "AttackVolgin" } )
	end

end





s10010_sequence.EnablePadMaskNormalOnSubEvent = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.EnablePadMaskNormalOnSubEvent(): enable:" .. tostring( subEventTable.enable ) )

	local enable = subEventTable.enable
	if not executed then
		enable = not enable
	end

	if skipped then
		mvars.initialPadMaskNormal = enable
	else
		s10010_sequence.EnablePadMaskNormal( enable )
	end

end





s10010_sequence.EnablePadMaskBeforeGetGunOnSubEvent = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.EnablePadMaskBeforeGetGunOnSubEvent(): enable:" .. tostring( subEventTable.enable ) )

	local enable = subEventTable.enable
	if not executed then
		enable = not enable
	end

	if skipped then
		mvars.initialPadMaskBeforeGetGun = enable
	else
		s10010_sequence.EnablePadMaskBeforeGetGun( enable )
	end

end





s10010_sequence.EnablePadMaskCombatOnSubEvent = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.EnablePadMaskCombatOnSubEvent(): enable:" .. tostring( subEventTable.enable ) )

	local enable = subEventTable.enable
	if not executed then
		enable = not enable
	end

	if skipped then
		mvars.initialPadMaskCombat = enable
	else
		s10010_sequence.EnablePadMaskCombat( enable )
	end

end





s10010_sequence.ProhibitMoveOnSubEvent = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.ProhibitMoveOnSubEvent(): enable:" .. tostring( subEventTable.enable ) )

	local enable = subEventTable.enable

	if not executed then
		enable = not enable
	end
	s10010_sequence.ProhibitMove( enable )

end





s10010_sequence.SetDisabledPlayerAction = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetDisabledPlayerAction(): value:" .. tostring( subEventTable.value ) )

	if executed then	
		vars.playerDisableActionFlag = subEventTable.value
	end

end





s10010_sequence.RespawnVehicle = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.RespawnVehicle(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", respawn:" .. tostring( subEventTable.respawn ) )

	if not s10010_enemy then
		Fox.Log( "s10010_sequence.RespawnVehicle(): ignore operation because s10010_enemy is not defined." )
		return
	end

	local respawn = subEventTable.respawn
	if not executed then
		respawn = not respawn
	end

	if respawn then
		s10010_enemy.RespawnVehicle( subEventTable.locatorName )
	else
		s10010_enemy.DespawnVehicle( subEventTable.locatorName )
	end

end





s10010_sequence.SetNpcEquipId = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetNpcEquipId(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", primaryEquipId:" .. tostring( subEventTable.primaryEquipId ) )

	if not s10010_enemy then
		Fox.Log( "s10010_sequence.SetNpcEquipId(): ignore operation because s10010_enemy is not defined." )
		return
	end

	if executed then
		local gameObjectId = GameObject.GetGameObjectId( subEventTable.locatorName )
		if gameObjectId and gameObjectId ~= GameObject.NULL_ID then
			GameObject.SendCommand( gameObjectId , { id = "SetEquipId", primary = TppEquip[ subEventTable.primaryEquipId ], } )
		else
			Fox.Warning( "s10010_sequence.SetNpcEquipId(): gameObjectId is not found. locatorName:" .. tostring( subEventTable.locatorName ) .. ", primaryEquipId:" .. tostring( subEventTable.primaryEquipId ) )
		end
	end

end





s10010_sequence.SetSceneBGM = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetSceneBGM(): bgmName:" .. tostring( subEventTable.bgmName ) )

	if executed then
		if skipped then
			mvars.initialSceneBGM = subEventTable
		else
			TppSound.SetSceneBGM( subEventTable.bgmName )
		end
	end

end





s10010_sequence.SetSceneBGMSwitch = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetSceneBGMSwitch(): switchName:" .. tostring( subEventTable.switchName ) )

	if executed then
		if skipped then
			mvars.initialSceneBGMSwitch = subEventTable
		else
			TppSound.SetSceneBGMSwitch( subEventTable.switchName )
		end
	end

end





s10010_sequence.StopSceneBGM = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.StopSceneBGM()" )

	if executed then
		if skipped then
			mvars.initialSceneBGM = nil
			mvars.initialSceneBGMSwitch = nil
		else
			TppSound.StopSceneBGM()
		end
	end

end





s10010_sequence.SetPhaseBGM = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.StopSceneBGM(): phaseTag:" .. tostring( subEventTable.phaseTag ) )

	if executed then
		if skipped then
			mvars.initialPhaseBGM = subEventTable
		else
			TppSound.SetPhaseBGM( subEventTable.phaseTag )
		end
	end

end





s10010_sequence.EnableCorpse = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.EnableCorpse(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", enable:" .. tostring( subEventTable.enable ) )

	if executed then	
		local gameObjectId = GameObject.GetGameObjectId( "TppCorpse", subEventTable.locatorName )
		if gameObjectId ~= GameObject.NULL_ID then
			GameObject.SendCommand( gameObjectId, { id = "SetForceUnreal", enabled = not subEventTable.enable } )
		end
	end

end





s10010_sequence.SetInitialPlayerAction = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.EnableCorpse(): action:" .. tostring( subEventTable.action ) )

	if executed then
		svars.initialPlayerAction = subEventTable.action
	end

end





s10010_sequence.PlaySoundEffect = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.PlaySoundEffect(): soundSourceName:" .. tostring( subEventTable.soundSourceName ) .. ", eventName:" .. tostring( subEventTable.eventName )
		.. ", singleShot:" .. tostring( subEventTable.singleShot ) )

	if executed then
		if not skipped and not onlyIfSkipped then--RETAILBUG: onlyIfSkipped undefined
			local tag
			if subEventTable.singleShot then
				tag = "SingleShot"
			else
				tag = "Loop"
			end

			local daemon = TppSoundDaemon.GetInstance()
			if subEventTable.soundSourceName then
				daemon:RegisterSourceEvent{
					sourceName = subEventTable.soundSourceName,
					tag = tag,
					playEvent = subEventTable.eventName,
				}
			else
				local option
				if subEventTable.title then
					option = "Loading"
				end
				TppSoundDaemon.PostEvent( subEventTable.eventName, option )
			end
		else
			if not mvars.initialStartSoundEffect then
				mvars.initialStartSoundEffect = {}
			end
			local soundSourceName = subEventTable.soundSourceName
			if not soundSourceName then
				soundSourceName = subEventTable.eventName
			end
			mvars.initialStartSoundEffect[ soundSourceName ] = subEventTable
		end
	end

end





s10010_sequence.StopSoundEffect = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.StopSoundEffect(): soundSourceName:" .. tostring( subEventTable.soundSourceName ) .. ", eventName:" ..
		tostring( subEventTable.eventName ) .. ", explicitly:" .. tostring( subEventTable.explicitly ) )

	if executed then
		if not skipped then
			local daemon = TppSoundDaemon.GetInstance()
			daemon:UnregisterSourceEvent{
				sourceName = subEventTable.soundSourceName,
				eventName = subEventTable.eventName,
			}
		else
			if not mvars.initialStartSoundEffect then
				mvars.initialStartSoundEffect = {}
			end
			local soundSourceName = subEventTable.soundSourceName
			if not soundSourceName then
				soundSourceName = subEventTable.eventName	
			end
			mvars.initialStartSoundEffect[ soundSourceName ] = nil

			if subEventTable.explicitly then	
				if not mvars.initialStopSoundEffect then
					mvars.initialStopSoundEffect = {}
				end
				mvars.initialStopSoundEffect[ soundSourceName ] = subEventTable
			end
		end
	end

end





s10010_sequence.WarpPlayer = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.WarpPlayer(): position:" .. tostring( subEventTable.position ) .. ", rotationY:" .. tostring( subEventTable.rotationY ) )

	if executed and not skipped then
		local gameObjectId = { type = "TppPlayer2", index = 0 }
		GameObject.SendCommand( gameObjectId, { id = "Warp", pos = subEventTable.position, rotY = TppMath.DegreeToRadian( subEventTable.rotationY ), } )
	end

end





s10010_sequence.SetScatterDofEnabled = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetScatterDofEnabled(): enabled:" .. tostring( subEventTable.enabled ) .. ", ignoreGen7:" .. tostring( subEventTable.ignoreGen7 ) )

	local gen7MaxFarOnlyModeParam
	if not subEventTable.ignoreGen7 then
		if subEventTable.enabled then
			gen7MaxFarOnlyModeParam = 7.0
		else
			gen7MaxFarOnlyModeParam = 0.0
		end
	end

	if executed then
		GrTools.SetDofControll{ enableScatter = subEventTable.enabled, nearCocLimitSize = 4.0, gen7MaxFarOnlyModeParam = gen7MaxFarOnlyModeParam,  }
	end

end





s10010_sequence.SetScatterDofEnabledForGen7 = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetScatterDofEnabledForGen7(): enabled:" .. tostring( subEventTable.enabled ) )

	local gen7MaxFarOnlyModeParam
	if subEventTable.enabled then
		gen7MaxFarOnlyModeParam = 7.0
	else
		gen7MaxFarOnlyModeParam = 0.0
	end

	if executed then
		GrTools.SetDofControll{ gen7MaxFarOnlyModeParam = gen7MaxFarOnlyModeParam,  }
	end

end





s10010_sequence.CallMonologue = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.CallMonologue(): locatorName:" .. tostring( subEventTable.locatorName ) .. ", voiceId:" .. tostring( subEventTable.label ) )

	if executed and not skipped then
		GameObject.SendCommand( GameObject.GetGameObjectId( subEventTable.locatorName ), { id = "CallMonologue", label = subEventTable.label, } )
	end

end





s10010_sequence.SetWeatherTag = function( subEventTable, executed, skipped )

	if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
		return
	end

	Fox.Log( "s10010_sequence.SetWeatherTag(): tag:" .. tostring( subEventTable.tag ) .. ", interpTime:" .. tostring( subEventTable.interpTime ) )

	if executed then
		local interpTime = subEventTable.interpTime
		if not interpTime then
			if not skipped then
				interpTime = 8
			else
				interpTime = 0
			end
		end
		WeatherManager.RequestTag( subEventTable.tag, interpTime )
	end

end





s10010_sequence.SetSceneReflectionParameter = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetSceneReflectionParameter(): texturePath:" .. tostring( subEventTable.texturePath ) )

	if executed then
		GrTools.SetSceneReflectionParameter( subEventTable.texturePath )
	end

end





s10010_sequence.SetLocalReflectionEnabled = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetSceneReflectionParameter(): enabled:" .. tostring( subEventTable.enabled ) )

	if executed then
		if subEventTable.enabled then
			GrTools.SetFadeValueLocalReflection( 1.0 )
		else
			GrTools.SetFadeValueLocalReflection( 0.0 )
		end
		GrTools.SetMaskValueLocalReflection( 0.5 )
	end

end





s10010_sequence.SetSubSurfaceScatterEnabled = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetSubSurfaceScatterEnabled(): enabled: " .. tostring( subEventTable.enabled ) )

	if executed then
		local fade
		if enabled then--RETAILBUG: enabledUndefined
			fade = 1.0
		else
			fade = 0.0
		end
		GrTools.SetSubSurfaceScatterFade( fade )
	end

end





s10010_sequence.SetInitialCameraRotation = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetInitialCameraRotation(): rotationX:" .. tostring( subEventTable.rotationX ) .. ", rotationY:" .. tostring( subEventTable.rotationY ) )

	if executed then
		mvars.initialPlayerCameraRotationX = subEventTable.rotationX
		mvars.initialPlayerCameraRotationY = subEventTable.rotationY
	end

end





s10010_sequence.SetBloodStain = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetBloodStain(): locatorName:" .. tostring( subEventTable.locatorName ) )

	if executed then
		if not skipped then
			if mvars.mobEnabled and Tpp.IsTypeTable( mvars.mobEnabled ) and mvars.mobEnabled[ subEventTable.locatorName ] then
				local gameObjectId = GameObject.GetGameObjectId( subEventTable.locatorName )
				if gameObjectId and gameObjectId ~= GameObject.NULL_ID then
					Fox.Log( "s10010_sequence.SetBloodStain(): bloodSetting: gameObjectId:" .. tostring( gameObjectId ) )
					GameObject.SendCommand( gameObjectId, { id = "SetFaceBloodMode", enabled = true, } )
				end
			end
		else
			if not mvars.initialBloodStain then
				mvars.initialBloodStain = {}
			end
			table.insert( mvars.initialBloodStain, subEventTable )
		end
	end

end





s10010_sequence.SetLocationTelopLangId = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.SetLocationTelopLangId(): locationTelopIndex:" .. tostring( subEventTable.locationTelopIndex ) )

	if executed and not skipped and subEventTable.locationTelopIndex and Tpp.IsTypeNumber( subEventTable.locationTelopIndex ) then
		svars.reservedNumber0001 = subEventTable.locationTelopIndex
	end

end





s10010_sequence.ChangeIshmaelFova = function( subEventTable, executed, skipped )

	Fox.Log( "s10010_sequence.ChangeIshmaelFova(): bodyId:" .. tostring( subEventTable.bodyId ) )

	if executed then
		local gameObjectId = GameObject.GetGameObjectId( "ishmael" )
		if gameObjectId and gameObjectId ~= GameObject.NULL_ID then
			GameObject.SendCommand( gameObjectId, { id = "ChangeFova", bodyId = subEventTable.bodyId, } )
		end
	end

end










s10010_sequence.ExecSubEvent = function( eventName, subEventName, executed, skipped, demoSkipped )

	Fox.Log( "s10010_sequence.ExecSubEvent(): eventName:" .. tostring( eventName ) .. ", subEventName:" .. tostring( subEventName ) ..
		", executed:" .. tostring( executed ) .. ", skipped:" .. tostring( skipped ) .. ", demoSkipped:" .. tostring( demoSkipped ) )

	local eventChangeTable = s10010_sequence.eventTableRoot[ eventName ]
	if eventChangeTable and eventChangeTable[ subEventName ] then
		for index, subEventTable in pairs( eventChangeTable[ subEventName ] ) do

			if subEventTable and subEventTable.func and Tpp.IsTypeFunc( subEventTable.func ) then
				subEventTable.func( subEventTable, executed, skipped, demoSkipped )
			else
				Fox.Warning( "s10010_sequence.ExecSubEvent(): subEventTable.func is INVALID!" )
			end

			if executed then
				if not mvars.executedSubEvent[ eventName ] then
					mvars.executedSubEvent[ eventName ] = {}
				end
				mvars.executedSubEvent[ eventName ][ subEventName ] = true
			end

		end
	end

end





s10010_sequence.OnEventPlayed = function( eventName, skipped )

	s10010_sequence.ExecSubEvent( eventName, "before", true, skipped )

end





s10010_sequence.OnEventFinished = function( eventName, skipped )

	s10010_sequence.ExecSubEvent( eventName, "after", true, skipped )

end





s10010_sequence.OnRoutePoint = function( gameObjectId, routeId, routeNodeIndex, messageId )

	Fox.Log( "s10010_sequence.OnRoutePoint( gameObjectId:" .. tostring( gameObjectId ) ..
				", routeId:" .. tostring( routeId ) .. ", routeNodeIndex:" .. tostring( routeNodeIndex ) .. ", messageId:" .. tostring( messageId ) ..  " )" )

	if Tpp.IsTypeString( gameObjectId ) then
		gameObjectId = GameObject.GetGameObjectId( gameObjectId )
	end

	local routeChangeTables = routeChangeTableRoot[ messageId ]
	if routeChangeTables then
		for i, routeChangeTable in ipairs( routeChangeTables ) do

			Fox.Log( "s10010_sequence.OnRoutePoint()" )

			local funcCheck = not routeChangeTable.checkFunc or routeChangeTable.checkFunc()
			local routeCheck = not routeChangeTable.locatorNameOnTheRoute or GameObject.GetGameObjectId( routeChangeTable.locatorNameOnTheRoute ) == gameObjectId
			if funcCheck and routeCheck then

				local locatorName
				if routeChangeTable.locatorName then
					locatorName = routeChangeTable.locatorName
				else
					locatorName = gameObjectId
				end

				
				if routeChangeTable.routeId then
					Fox.Log( "s10010_sequence.OnRoutePoint(): SetSneakRoute" )
					TppEnemy.SetSneakRoute( locatorName, routeChangeTable.routeId )
				end
				if routeChangeTable.cautionRouteId then
					TppEnemy.SetCautionRoute( locatorName, routeChangeTable.cautionRouteId )
				end
				if routeChangeTable.alertRouteId then
					TppEnemy.SetAlertRoute( locatorName, routeChangeTable.alertRouteId )
				end

				
				if routeChangeTable.locatorName and routeChangeTable.motionPath and routeChangeTable.specialActionName then
					Fox.Log( "s10010_sequence.OnRoutePoint(): Play NPC Motion" )
					s10010_sequence.PushMotion( routeChangeTable )
				end

				
				if routeChangeTable.eventName then
					s10010_sequence.OnEventPlayed( routeChangeTable.eventName )
					s10010_sequence.OnEventFinished( routeChangeTable.eventName )
				end

				
				if routeChangeTable.func then
					routeChangeTable.func()
				end

			end

		end
	else
		Fox.Log( "s10010_sequence.OnRoutePoint(): There is no routeChangeTables!" )
	end

end




s10010_sequence.IsCompleteLoading = function()

	

	if cypr_mission_block and not cypr_mission_block.IsCompleteLoading() then
		return false
	end

	

	if TppCyprusBlockControl.IsCyprusLoading() then
		return false
	end

	

	return true

end




s10010_sequence.ReserveDemoSequence = function( demoSequenceName )

	mvars.reservedDemoSequenceList[ demoSequenceName ] = true

end




s10010_sequence.IsDemoSequenceReserved = function( demoSequenceName )

	return mvars.reservedDemoSequenceList[ demoSequenceName ]

end





s10010_sequence.EnablePadMaskNormal = function( enabled )

	Fox.Log( "s10010_sequence.EnablePadMaskNormal(): enabled" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_normal",			
			except = false,
			buttons =	PlayerPad.MB_DEVICE +
						PlayerPad.CALL +
						PlayerPad.UP +
						PlayerPad.DOWN +
						PlayerPad.LEFT +
						PlayerPad.RIGHT +
						PlayerPad.CQC +
						PlayerPad.SIDE_ROLL +
						PlayerPad.LIGHT_SWITCH +
						PlayerPad.EVADE +
						PlayerPad.VEHICLE_FIRE +
						PlayerPad.VEHICLE_CALL +
						PlayerPad.VEHICLE_DASH,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_normal"
		}
	end

end





s10010_sequence.EnablePadMaskBeforeGetGun = function( enabled )

	Fox.Log( "s10010_sequence.EnablePadMaskBeforeGetGun(): enabled" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_beforeGetGun",
			except = false,
			buttons = PlayerPad.HOLD,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_beforeGetGun"
		}
	end

end





s10010_sequence.EnablePadMaskCombat = function( enabled )

	Fox.Log( "s10010_sequence.EnablePadMaskCombat(): enabled" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_combat",
			except = false,
			buttons =	PlayerPad.MB_DEVICE +
						PlayerPad.CALL +
						PlayerPad.CQC +
						PlayerPad.SIDE_ROLL +
						PlayerPad.LIGHT_SWITCH +
						PlayerPad.VEHICLE_FIRE +
						PlayerPad.VEHICLE_CALL +
						PlayerPad.VEHICLE_DASH,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_combat"
		}
	end

end





s10010_sequence.ProhibitMove = function( enabled )

	Fox.Log( "s10010_sequence.ProhibitMove(): enabled:" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_demo",
			except = false,
			sticks = PlayerPad.STICK_L,
		}
		mvars.prohibitMoveEnabled = true
	elseif mvars.prohibitMoveEnabled then
		Player.ResetPadMask {
			settingName = "cypr_demo"
		}
		mvars.prohibitMoveEnabled = false
	end
	

end




s10010_sequence.StopPlayerAndStartNearCamera = function( enabled, targetLocatorName, identifierName, keyName, zoomTime, zoomFocalLength )

	Fox.Log( "s10010_sequence.StopPlayerAndStartNearCamera(): enabled:" .. tostring( enabled ) .. ", targetLocatorName:" .. tostring( targetLocatorName ) ..
		", identifierName:" .. tostring( identifierName ) .. ", keyName:" .. tostring( keyName ) )

	local interpTime = zoomTime
	if not interpTime then
		interpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME
	end

	local focalLength = zoomFocalLength
	if not focalLength then
		focalLength = 31.0
	end

	if enabled then
		
		s10010_sequence.ProhibitMove( true )

		if targetLocatorName or ( identifierName and keyName ) then
			
			Player.StartTargetConstrainCamera {
				cameraType = PlayerCamera.Around,	
				force = true,	
				fixed = false,	
				recoverPreOrientation = false,	
				gameObjectName = targetLocatorName,	
				skeletonName = "SKL_004_HEAD",	
				dataIdentifierName = identifierName,	
				keyName = keyName,
				interpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,	
				interpTimeToRecover = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,	
				areaSize = 0.5,	
				time = 10,	
				
				
				
				
				focalLength = focalLength,	
				focalLengthInterpTime = interpTime,	
				minDistance = 0.0,	
				maxDistanve = 50.0,	
			}
		else
			Player.SetAroundCameraManualMode( true )
			Player.SetAroundCameraManualModeParams{
				offset = Vector3( -0.25, 0.35, 0 ),	
				target = targetPosition,--RETAILBUG: targetPosition not defined
				distance = 1.5,	
				focalLength = focalLength,	
				targetIsPlayer = true,	
				targetInterpTime = interpTime,
				ignoreCollisionGameObjectName = "Player",	
				alphaDistance = 1.0,	
			}
			Player.UpdateAroundCameraManualModeParams()
		end

		
		TppSoundDaemon.PostEvent( "sfx_s_force_camera_in" )
	else
		s10010_sequence.ProhibitMove( false )
		Player.SetAroundCameraManualMode( false )
		Player.StopTargetConstrainCamera()
		
		TppSoundDaemon.PostEvent( "sfx_s_force_camera_out" )
	end

end





s10010_sequence.SetPadMaskLoading = function( enabled )

	Fox.Log( "s10010_sequence.SetPadMaskLoading(): enabled:" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_loading",
			except = false,
			sticks = PlayerPad.STICK_L,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_loading"
		}
	end

end





s10010_sequence.SetPadMaskAvatarEdit = function( enabled )

	Fox.Log( "s10010_sequence.SetPadMaskAvatarEdit(): enabled:" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_avatar",
			except = true,
			sticks = PlayerPad.STICK_R,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_avatar"
		}
	end

end




s10010_sequence.SetPadMaskEntranceQTE = function( enabled )

	Fox.Log( "s10010_sequence.SetPadMaskEntranceQTE(): enabled:" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_entrance_qte",
			except = true,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_entrance_qte"
		}
	end

end





s10010_sequence.SetPadMaskCorridor = function( enabled )

	Fox.Log( "s10010_sequence.SetPadMaskCorridor(): enabled:" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_corridor",
			except = true,
			sticks = PlayerPad.STICK_R,
			buttons = PlayerPad.ZOOM_CHANGE,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_corridor"
		}
	end

end





s10010_sequence.SetPadMaskBed = function( enabled )

	Fox.Log( "s10010_sequence.SetPadMaskBed(): enabled:" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_bed",
			sticks = PlayerPad.STICK_R,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_bed"
		}
	end

end





s10010_sequence.SetPadMaskGameOver = function( enabled )

	Fox.Log( "s10010_sequence.SetPadMaskGameOver(): enabled:" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_gameOver",
			except = false,
			sticks = PlayerPad.STICK_L,
			buttons = PlayerPad.HOLD + PlayerPad.FIRE,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_gameOver"
		}
	end

end





s10010_sequence.SetPadMask2f = function( enabled )

	Fox.Log( "s10010_sequence.SetPadMask2f(): enabled:" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_2f",
			except = false,
			sticks = PlayerPad.STICK_L,
			buttons = PlayerPad.HOLD + PlayerPad.FIRE + PlayerPad.STANCE,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_2f"
		}
	end

end





s10010_sequence.SetPadMaskCamera = function( enabled )

	Fox.Log( "s10010_sequence.SetPadMaskCamera(): enabled:" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_camera",
			except = false,
			sticks = PlayerPad.STICK_R,
			buttons = PlayerPad.SUBJECT,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_camera"
		}
	end

end




s10010_sequence.SetPadMaskAll = function( enabled )

	Fox.Log( "s10010_sequence.SetPadMaskAll(): enabled:" .. tostring( enabled ) )

	if enabled then
		Player.SetPadMask {
			settingName = "cypr_all",
			except = true,
		}
	else
		Player.ResetPadMask {
			settingName = "cypr_all"
		}
	end

end




s10010_sequence.CallRandomMonologue = function( gameObjectId, monologueList )

	Fox.Log( "s10010_sequence.CallRandomMonologue(): monologueList:" .. tostring( monologueList ) )

	if Tpp.IsTypeString( gameObjectId ) then
		gameObjectId = GameObject.GetGameObjectId( gameObjectId )
	end

	local index = math.random( 1, #monologueList )
	GameObject.SendCommand( gameObjectId, { id = "CallMonologue", label = monologueList[ index ], } )

end





s10010_sequence.OnLoadFinished = function( step )

	Fox.Log( "s10010_sequence.OnLoadFinished(): step:" .. step )

	if s10010_enemy then
		local doctorAndNurseLoadStepList = {
		}
		for i, doctorAndNurseLoadStep in ipairs( doctorAndNurseLoadStepList ) do
			if step == doctorAndNurseLoadStep then
				for j, doctorOrNurseLocatorName in ipairs( s10010_enemy.mobListTable.doctorAndNurseList ) do
					s10010_enemy.SetMobEnabled( doctorOrNurseLocatorName, false )
				end
				break
			end
		end

		local patientLoadStepList = {
			3,
		}
		for i, patientLoadStep in ipairs( patientLoadStepList ) do
			if step == patientLoadStep then
				for j, patientLocatorName in ipairs( s10010_enemy.mobListTable.patientList ) do
					s10010_enemy.SetMobEnabled( patientLocatorName, false )
				end
				break
			end
		end
	end

end




s10010_sequence.MakeLoadSequenceTable = function( demoTrapName, demoSequenceName, step, nextSequenceName, checkPointName, option, inMessageTable )

	Fox.Log( "s10010_sequence.MakeLoadSequenceTable(): demoTrapName:" .. tostring( demoTrapName ) .. ", demoSequenceName:" .. tostring( demoSequenceName ) ..
		", step:" .. tostring( step ) .. ", nextSequenceName:" .. tostring( nextSequenceName ) .. ", checkPointName:" .. tostring( checkPointName ) ..
		", option:" .. tostring( option ) .. ", inMessageTable:" .. tostring( inMessageTable ) )

	local loadEventName = "load" .. step

	local mergedMessageTable
	if demoTrapName and demoSequenceName then
		mergedMessageTable = {
			Trap = {
				{	
					msg = "Enter",
					sender = demoTrapName,
					func = function()
						s10010_sequence.ReserveDemoSequence( demoSequenceName )
					end,
				},
			},
		}
	end

	if inMessageTable then
		mergedMessageTable = s10010_sequence.MergeMessageTable( mergedMessageTable, inMessageTable )
	end

	local MakeMessageTable
	if mergedMessageTable then
		MakeMessageTable = function( self )
			return StrCode32Table( mergedMessageTable )
		end
	end

	return {

		Messages = MakeMessageTable,

		OnEnter = function()

			Fox.Log( "s10010_sequence.MakeLoadSequenceTable(): OnEnter()" )

			s10010_sequence.OnEventPlayed( loadEventName )
			s10010_sequence.LoadCyprusBlock( step )

		end,

		OnUpdate = function()

			

			if s10010_sequence.IsCompleteLoading() then
				TppSequence.SetNextSequence( nextSequenceName, option )
			end

			TppUI.ShowAccessIconContinue()

		end,

		OnLeave = function()

			Fox.Log( "s10010_sequence.MakeLoadSequenceTable(): OnLeave()" )

			if checkPointName then
				s10010_sequence.UpdateCheckPoint{ checkPoint = checkPointName, ignoreAlert = true, }
			end
			s10010_sequence.OnLoadFinished( step )
			s10010_sequence.OnEventFinished( loadEventName )

		end,

	}

end





s10010_sequence.SetEffectVisiblityLazily = function( instanceName, visibility, immediately )

	Fox.Log( "s10010_sequence.SetEffectVisiblityLazily(): instanceName:" .. tostring( instanceName ) .. ", visibility:" ..
		tostring( visibility ) .. ", immediately:" .. tostring( immediately ) )

	
	if not TppDataUtility.IsReadyEffectFromGroupId( instanceName ) then
		Fox.Log( "s10010_sequence.SetEffectVisiblityLazily(): ignore operation because effect does not exist. effectName:" .. tostring( instanceName ) )
		return
	end

	if immediately then
		TppDataUtility.SetVisibleEffectFromGroupId( instanceName, visibility )
	else
		mvars.visibilityChangedEffect[ instanceName ] = visibility
	end

end




s10010_sequence.AddSearchTarget = function( identifier, key )

	Fox.Log( "s10010_sequence.AddSearchTarget(): identifier:" .. tostring( identifier ) .. ", key:" .. tostring( key ) )

	Player.AddSearchTarget {
		name = key,	
		dataIdentifierName = identifier,
		keyName = key,
		centerRange = 0.4,	
		lookingTime = 1,	
		distance = 100,	
		doDirectionCheck = false,	
		directionCheckRange = 90,	
		doCollisionCheck = false,	
	}

end








s10010_sequence.StartTimers = function( timerTable )

	Fox.Log( "s10010_sequence.StartTimers(): timerTable:" .. tostring( timerTable ) )

	for timerName, timerInformationTable in pairs( timerTable ) do
		s10010_sequence.StartTimer( timerInformationTable.name, timerInformationTable.time )
	end

end




s10010_sequence.StopTimers = function( timerTable )

	Fox.Log( "s10010_sequence.StartTimers(): timerTable:" .. tostring( timerTable ) )

	for timerName, timerInformationTable in pairs( timerTable ) do
		GkEventTimerManager.Stop( timerInformationTable.name )
	end

end




s10010_sequence.MergeMessageTable = function( lhsTable, rhsTable )

	Fox.Log( "s10010_sequence.MergeMessageTable(): lhsTable:" .. tostring( lhsTable ) .. ", rhsTable:" .. tostring( rhsTable ) )

	if not lhsTable then
		lhsTable = {}
	end
	if not rhsTable then
		rhsTable = {}
	end

	for messageTag, messageUnitTable in pairs( rhsTable ) do
		if lhsTable[ messageTag ] then
			for i, messageUnit in ipairs( messageUnitTable ) do
				table.insert( lhsTable[ messageTag ], messageUnit )
			end
		else
			lhsTable[ messageTag ] = messageUnitTable
		end
	end

	return lhsTable

end




s10010_sequence.MakeAwakeRoomSequenceMessages = function( self )

	Fox.Log( "s10010_sequence.MakeAwakeRoomSequenceMessages()" )

	local messageTable = {
		Timer = {
			{
				msg = "Finish",
				func = function ( timerName )
					Fox.Log( "sequences.Seq_Demo_Opening: Timer: Finish: timerName:" .. tostring( timerName ) )
					if self.timerTable and self.timerTable[ timerName ] and self.timerTable[ timerName ].Func then
						self.timerTable[ timerName ].Func()
					end
				end
			},
		},
		nil,
	}

	local mergedMessageTable
	if self.uncommonMessageTable then
		mergedMessageTable = s10010_sequence.MergeMessageTable( messageTable, self.uncommonMessageTable )
	else
		mergedMessageTable = messageTable
	end

	return StrCode32Table( mergedMessageTable )

end

s10010_sequence.IsDemoPlaying = function( demoNameList )

	

	if not Tpp.IsTypeTable( demoNameList ) then
		demoNameList = { demoNameList, }
	end

	for i, demoName in ipairs( demoNameList ) do
		local demoId = s10010_demo.demoList[ demoName ]
		if demoId and DemoDaemon.IsPlayingDemoId( demoId ) then
			return true
		elseif not demoId then
			
		else
			
		end
	end

	return false

end




s10010_sequence.IsAnyDemoNotPlaying = function( targetDemoIdList )

	

	local playingDemoIdList = DemoDaemon.GetPlayingDemoId()
	if not playingDemoIdList or not next( playingDemoIdList ) then
		return true
	end

	return false

end




s10010_sequence.ResetCameraRotatioinWhileBedAction = function( rotX, rotY, rotZ, interpTime, se )

	rotX = rotX or 0
	rotY = rotY or 0
	rotZ = rotZ or 0
	interpTime = interpTime or 0.75

	Player.RequestToSetCameraRotation {
		rotX = rotX,
		rotY = rotY,
		
		interpTime = interpTime,
	}

	
	if se then
		TppSoundDaemon.PostEvent( "sfx_p_bed_creak_force" )
	end

end




s10010_sequence.DoesSequenceNeedGameOverDemo = function( targetSequenceName )

	Fox.Log( "s10010_sequence.DoesSequenceNeedGameOverDemo(): targetSequenceName:" .. tostring( targetSequenceName ) )

	for i, sequenceName in ipairs( s10010_sequence.GAME_OVER_DEMO_SEQUENCE_LIST ) do
		if sequenceName == targetSequenceName then
			return true
		end
	end

	return false

end




s10010_sequence.IsPlayerAndSoldierInSameTrap = function()

	Fox.Log( "s10010_sequence.IsPlayerAndSoldierInSameTrap()" )

	if DEBUG and DEBUG.GetDebugMenuValue( "Soldier2", "Eye" ) == "Close" then
		return false
	end

	for trapName, gameObjectIdTable in pairs( mvars.gameObjectIdInTrap ) do

		Fox.Log( "s10010_sequence.IsPlayerAndSoldierInSameTrap(): trapName:" .. tostring( trapName ) )

		local playerIn = false
		local soldierIn = false

		for gameObjectId, inTrap in pairs( gameObjectIdTable ) do

			Fox.Log( "s10010_sequence.IsPlayerAndSoldierInSameTrap(): gameObjectId:" .. tostring( gameObjectId ) .. ", inTrap:" .. tostring( inTrap ) )

			if inTrap then
				if Tpp.IsPlayer( gameObjectId ) then
					playerIn = true
				elseif Tpp.IsSoldier( gameObjectId ) then
					
					local lifeState = GameObject.SendCommand( gameObjectId, { id = "GetLifeStatus" } )
					if lifeState ~= TppGameObject.NPC_LIFE_STATE_DEAD then
						soldierIn = true
					end
				end
			end

		end

		if playerIn and soldierIn then	
			
			for gameObjectId, inTrap in pairs( gameObjectIdTable ) do
				if Tpp.IsSoldier( gameObjectId ) then
					mvars.gameObjectIdDiscoveryingPlayer = gameObjectId
				end
			end
			return true
		end

	end

	return false

end




s10010_sequence.IsGameObjectInTrap = function( gameObjectId, trapName )

	Fox.Log( "s10010_sequence.IsGameObjectInTrap()" )

	if not mvars.gameObjectIdInTrap then
		return false
	end

	local gameObjectIdTable = mvars.gameObjectIdInTrap[ trapName ]
	if gameObjectIdTable then
		return gameObjectIdTable[ gameObjectId ]
	end

end




s10010_sequence.IsAnyStickDown = function()

	

	return math.abs( PlayerVars.leftStickXDirect ) > 0.1 or math.abs( PlayerVars.leftStickYDirect ) > 0.1 or
		math.abs( PlayerVars.rightStickXDirect ) > 0.1 or math.abs( PlayerVars.rightStickYDirect ) > 0.1

end




s10010_sequence.IsRightStickDown = function()

	

	return math.abs( PlayerVars.rightStickXDirect ) > 0.1 or math.abs( PlayerVars.rightStickYDirect ) > 0.1

end




s10010_sequence.IsIshmaelExists = function()

	Fox.Log( "s10010_sequence.IsIshmaelExists()" )

	if mvars.ishmaelExists then
		return true
	end
	return false

end




s10010_sequence.SetNextGameOverSequence = function( nextSequenceName, option )

	Fox.Log( "s10010_sequence.SetNextGameOverSequence(): nextSequenceName:" .. tostring( nextSequenceName ) .. ", option:" .. tostring( option ) )

	mvars.isNextSequenceGameOverSequence = true
	TppSequence.SetNextSequence( nextSequenceName, option )

end





s10010_sequence.UpdateCheckPoint = function( checkPointSetiings )

	Fox.Log( "s10010_sequence.UpdateCheckPoint(): checkPointSetiings:" .. tostring( checkPointSetiings ) )

	if not mvars.isNextSequenceGameOverSequence then
		TppMission.UpdateCheckPoint( checkPointSetiings )
	end

end










sequences.Seq_Demo_Flashback = {

	Messages = function( self )
		return
		StrCode32Table {
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_ChangeSequence",
					func = function()
					end
				}
			},
		}
	end,

	OnEnter = function( self )

		TppUI.FadeOut( 0.0 )
		local missionName = TppMission.GetMissionName()
		if missionName == "s10010" then
			
			s10010_sequence.OnEventPlayed( "flashback" )
			s10010_sequence.OnEventFinished( "flashback" )
			s10010_sequence.OnEventPlayed( "beforeOpening" )
			s10010_sequence.OnEventFinished( "beforeOpening" )
			s10010_sequence.OnEventPlayed( "opening" )
			s10010_sequence.OnEventFinished( "opening" )
			TppSequence.SetNextSequence( "Seq_Demo_FewDaysLater0" )
		elseif missionName == "s10280" then
			
			s10010_demo.PlayFlashBackDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_Load21" ) end, } )
		end

	end,

	OnLeave = function( self )

	end

}

sequences.Seq_Game_Load21 = s10010_sequence.MakeLoadSequenceTable( nil, "Seq_Demo_Opening", 21, "Seq_Demo_Opening", "CHK_AfterAwakeRoom" )





function s10010_sequence.EnableGameStatusFunction()
	Fox.Log( "s10010_sequence.EnableGameStatusFunction" )
	Tpp.SetGameStatus{
		target = "all",
		enable = true,
		except = {
			AnnounceLog = false,
		},
		scriptName = "s10010_sequence.lua",
	}
	TppUI.OverrideFadeInGameStatus( s10010_sequence.DEFAULT_OVERRIDE_SYSTEM_EXCEPT_GAME_STATUS )
end


function s10010_sequence.DisableGameStatusFunction()
	Fox.Log( "s10010_sequence.DisableGameStatusFunction" )
	Tpp.SetGameStatus{
		target = "all",
		enable = false,
		scriptName = "s10010_sequence.lua",
	}
	TppUI.OverrideFadeInGameStatus{
		CallMenu = false,
		PauseMenu = false,
		EquipHud = false,
		EquipPanel = false,
		CqcIcon = false,
		ActionIcon = false,
		AnnounceLog = false,
		BaseName = false,
	}
end

function s10010_sequence.ShowTitle()

	Fox.Log( "s10010_sequence.ShowTitle()" )

	if not mvars.titleShown then
		s10010_sequence.StartTimer( "Timer_GoToTitle", 4.78 )	
		s10010_sequence.DisableGameStatusFunction()

		s10010_sequence.PlaySoundEffect( { eventName = "sfx_m_cypr_int", singleShot = false, title = true, }, true, false )

		
		Player.RequestToPlayCameraNonAnimation {
			positionAndTargetMode = true,
			position = Vector3{ -41.672, 108.36, -1716.827, },	
			target = Vector3{ -38.999, 106.54, -1719.002, },
			focalLength = 19.0,	
			aperture = 0.5,	
			timeToSleep = 60 * 60 * 24 * 365,	
			isCollisionCheck = false,
			focusDistance = 0.98,
		}

		cypr_player_bed_and_corridor.FadeOutEyelidFilter()
		cypr_player_bed_and_corridor.SetEyelidFilterState( cypr_player_bed_and_corridor.EyelidFilterState.OPEN )

		
		TppEffectUtility.SetFxCutLevelMaximum( 0 )

		mvars.titleShown = true
	end

end


function s10010_sequence.TitleModeOnEnterFunction()

	Fox.Log( "s10010_sequence.TitleModeOnEnterFunction()" )

	s10010_sequence.OnEnterOpeningDemo(
		sequences.Seq_Demo_Opening,
		function()
			Fox.Log( "s10010_sequence.TitleModeOnEnterFunction(): Finish OnEnterOpeningDemo" )
			s10010_sequence.ShowTitle()
		end
	)

end


function s10010_sequence.TitleModeMessages()

	Fox.Log( "s10010_sequence.TitleModeMessages()" )
	return s10010_sequence.MakeAwakeRoomSequenceMessages( sequences.Seq_Demo_Opening, true )

end





s10010_sequence.OnEnterOpeningDemo = function( self, OnDemoEnd )

	Fox.Log( "s10010_sequence.OnEnterOpeningDemo()" )

	mvars.OnOpeningDemoEnd = OnDemoEnd

	TppUiCommand.LyricTexture( "regist_cyprus" )

	local missionName = TppMission.GetMissionName()
	if missionName == "s10010" then

		TppSoundDaemon.ResetMute( 'Title' )

		
		s10010_sequence.OnEventPlayed( "flashback" )
		s10010_sequence.OnEventFinished( "flashback" )

		
		if TppSave.IsNewGame() and not gvars.ini_isReturnToTitle then	

			
			TppSoundDaemon.PostEvent( "State_s_intermission_int" )

			TppUiCommand.SetStrongPrioTelopCast( true )
			TppUiCommand.ShowTextureLogo( "fiction", 5.0 )
			TppUiCommand.StartTelopCast()

			s10010_sequence.StartTimer( "Timer_PlayBeforeOpeningDemo", 9 )

		else	
			s10010_sequence.OnEventPlayed( "beforeOpening" )
			s10010_sequence.OnEventFinished( "beforeOpening" )
			s10010_sequence.OnEventPlayed( "opening" )
			s10010_sequence.ExecSubEvent( "opening", "p21_010000_cyprtitle_on", true, false )	
			s10010_sequence.OnEventFinished( "opening" )
			s10010_sequence.OnOpeningDemoFinished( self )
		end

	elseif missionName == "s10280" then
		s10010_sequence.OnEventPlayed( "beforeOpening" )
		s10010_sequence.OnEventFinished( "beforeOpening" )

		

		
		s10010_demo.PlayOpeningDemo( {
			onStart = function()
				s10010_sequence.ResetCameraRotatioinWhileBedAction()

				
				
			end,
			onEnd = function()
				if TppSequence.GetCurrentSequenceName() == "Seq_Demo_StartHasTitleMission" then
					s10010_sequence.OnEventFinished( "opening" )
				end
				OnDemoEnd()
				s10010_sequence.StopTimers( self.timerTable )

				
				TppUiStatusManager.UnsetStatus( "TelopCast", "INVALID" )
				DemoxUi.SetDemoUiTriggerInvalid( false )

				TppUiCommand.LyricTexture( "hide" )
			end,
		} )
	end

	mvars.searchTargetPlayed = {}

end





s10010_sequence.OnLeaveOpeningDemo = function( self )

	Fox.Log( "s10010_sequence.OnLeaveOpeningDemo()" )

	
	

end






s10010_sequence.StartIshmaelLookTimer = function()

	Fox.Log( "s10010_sequence.StartIshmaelLookTimer()" )

	local time = math.random( 20, 30 )
	s10010_sequence.StartTimer( "Timer_IshmaelLook", time )

end





s10010_sequence.OnEnterTitleMenu = function()

	Fox.Log( "s10010_sequence.OnTitleEnter()" )

	s10010_sequence.StartIshmaelLookTimer()

end




s10010_sequence.OnOpeningDemoFinished = function( self )

	Fox.Log( "s10010_sequence.OnOpeningDemoFinished()" )

	if TppSequence.GetCurrentSequenceName() == "Seq_Demo_StartHasTitleMission" then
		if gvars.ini_isReturnToTitle then
			TppSequence.SetNextSequence( "Seq_Game_PushStart" )
		end
	end

	
	s10010_sequence.StopTimers( self.timerTable )

	if mvars.OnOpeningDemoEnd then
		mvars.OnOpeningDemoEnd()
		mvars.OnOpeningDemoEnd = nil
	end

end

sequences.Seq_Demo_Opening = {

	




	timerTable = {
		[ StrCode32( "opening_before" ) ] = {
			name = "opening_before",
			time = 0.1,
			Func = function()
				
				cypr_player_bed_and_corridor.SetAperture( 0.33, 0 )
				cypr_player_bed_and_corridor.SetFocusDistanceLimit( 0.2, 0 )
				cypr_player_bed_and_corridor.SetCameraRotationSpeedRate( MAX_CAMERA_RATE / 3.5 )
			end,
		},
		
		[ StrCode32( "opening_awake" ) ] = {
			name = "opening_awake",
			time = 2,
			Func = function()
				
				
				cypr_player_bed_and_corridor.SetAperture( 0.5, 1 )
				cypr_player_bed_and_corridor.SetFocusDistanceLimit( 0.33, 1 )
			end,
		},
		[ StrCode32( "opening_open" ) ] = {
			name = "opening_open",
			time = 5,
			Func = function()
				
				
			end,
		},
		[ StrCode32( "opening_eyelid" ) ] = {
			name = "opening_eyelid",
			time = 8,
			Func = function()
				
				
			end,
		},
		[ StrCode32( "opening_open2" ) ] = {
			name = "opening_open2",
			time = 10,
			Func = function()
				
				
				
				cypr_player_bed_and_corridor.SetAperture( 0.75, 125 )
				cypr_player_bed_and_corridor.SetFocusDistanceLimit( 0.50, 125 )
			end,
		},
	},







	uncommonMessageTable = {
		Timer = {
			{	
				msg = "Finish",
				sender = "Timer_ChangeSequence",
				func = function()
					TppSequence.SetNextSequence( "Seq_Demo_FewDaysLater0" )
				end
			},
			{	
				msg = "Finish",
				sender = "Timer_GoToTitle",
				func = function()

					Fox.Log( "sequences.Seq_Demo_Opening.uncommonMessageTable: Timer: Finish: Timer_GoToTitle" )

					if not mvars.titleStarted then
						TppUI.FadeIn( 1.0 )

						s10010_sequence.OnEnterTitleMenu()
						if gvars.ini_isReturnToTitle then
							title_sequence.StartTitleMenu()
						else
							title_sequence.StartPressStartMenu()
						end
						mvars.titleStarted = true
					end

				end,
			},
			{	
				msg = "Finish",
				sender = "Timer_IshmaelLook",
				func = function()
					s10010_sequence.PushMotion{
						locatorName = "ishmael",
						motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_title_look_idl.gani",
						specialActionName = "end_of_ish0non_q_title_look_idl",
						again = true,
					}
				end,
			},
			{
				msg = "Finish",
				sender = "Timer_StickDownTimeOut",
				func = function()
					if mvars.doesShowDemoKeyHelp then
						TppUiCommand.HideDemoKeyHelp()
						mvars.doesShowDemoKeyHelp = nil	
					end
				end,
			},
			{	
				msg = "Finish",
				sender = "Timer_PlayBeforeOpeningDemo",
				func = function()

					Fox.Log( "sequences.Seq_Demo_Opening.uncommonMessageTable: Timer: Finish: Timer_PlayBeforeOpeningDemo" )

					s10010_sequence.SetPadMaskBed( true )

					TppUiCommand.SetStrongPrioTelopCast( false )

					s10010_demo.PlayBeforeOpeningDemo( {
						onStart = function()
							if TppSequence.GetCurrentSequenceName() == "Seq_Demo_StartHasTitleMission" then
								s10010_sequence.OnEventPlayed( "beforeOpening" )
							end
							s10010_sequence.EnableGameStatusFunction()
						end,
						onEnd = function()

							if TppSequence.GetCurrentSequenceName() == "Seq_Demo_StartHasTitleMission" then
								s10010_sequence.OnEventFinished( "beforeOpening" )
							end

							s10010_demo.PlayOpeningDemo( {
								onStart = function()
									s10010_sequence.ResetCameraRotatioinWhileBedAction()
									if TppSequence.GetCurrentSequenceName() == "Seq_Demo_StartHasTitleMission" then
										s10010_sequence.OnEventPlayed( "opening" )
										Tpp.SetGameStatus{
											target = "all",
											enable = true,
											except = {
												AnnounceLog = false,
											},
											scriptName = "s10010_sequence.lua",
										}
									end
								end,
								onEnd = function()
									s10010_sequence.OnEventFinished( "opening" )
									s10010_sequence.OnOpeningDemoFinished( sequences.Seq_Demo_Opening )
									TppUiCommand.LyricTexture( "hide" )
								end,
							} )

						end,
					} )

				end,
			},
		},
		Demo = {
			{
				msg = "p21_010000_openeyelids",
				sender = "p21_010000",
				func = function()
					Fox.Log( "sequences.Seq_Demo_Opening.uncommonMessageTable: Demo: p21_010000_openeyelids" )
					s10010_sequence.StartTimers( sequences.Seq_Demo_Opening.timerTable )
					cypr_player_bed_and_corridor.FadeOutEyelidFilter()
				end,
				option = { isExecDemoPlaying = true },
			},
			{
				msg = "p21_010000_iconon01",
				sender = "p21_010000",
				func = function()
					TppUiCommand.ShowDemoKeyHelp()
					TppUiCommand.ActiveDemoKeyHelp( true )
					mvars.doesShowDemoKeyHelp = true
					s10010_sequence.StartTimer( "Timer_StickDownTimeOut", 10 )
				end,
			},
			{
				msg = "p21_010000_missiontelop_on",
				sender = "p21_010000",
				func = function()
					local missionName = TppMission.GetMissionName()
					if missionName == "s10010" then
					elseif missionName == "s10280" then
						TppUI.StartMissionTelop( 10280, true, true )
					end
				end,
			},
			{
				msg = "p21_010000_epigraph_on",
				sender = "p21_010000",
				func = function()
					local missionName = TppMission.GetMissionName()
					if missionName == "s10010" then
					elseif missionName == "s10280" then
						TppUiCommand.SetStrongPrioTelopCast( true )
						TppUiCommand.RegistTelopCast( "Epigraph", 5.0, "tpp_epigraph_nietzsche", "tpp_epigraph_nietzsche_quote", 1.0, 1.0, 20.0 )
						TppUiCommand.StartTelopCast()
					end
				end,
			},
			{
				msg = "p21_010000_casttelop_on",
				sender = "p21_010000",
				func = function()
					local missionName = TppMission.GetMissionName()
					if missionName == "s10010" then
					elseif missionName == "s10280" then
						TppUiStatusManager.SetStatus( "TelopCast", "INVALID" )
					end
				end,
			},
			{
				msg = "Play",
				sender = "p21_010000",
				func = function()
					local missionName = TppMission.GetMissionName()
					if missionName == "s10010" then
					elseif missionName == "s10280" then
						TppUI.StartLyricCyprus( 13.57 )
					end
					s10010_sequence.SetPadMaskBed( false )
				end,
			},
			{
				msg = "p21_010000_telop_kde_on",
				sender = "p21_010000",
				func = function()
					Fox.Log( "sequences.Seq_Demo_Opening: uncommonMessageTable: Demo: p21_010000_telop_kde_on" )

					local missionName = TppMission.GetMissionName()
					if missionName == "s10010" then
						TppUiCommand.SetStrongPrioTelopCast( true )
						TppUiCommand.RegistTelopCast( "Center", 2.5, "telop_kde_presents", 1.5 )
						TppUiCommand.StartTelopCast()
					elseif missionName == "s10280" then
					end
				end,
			},
			{
				msg = "p21_010000_telop_kde_off",
				sender = "p21_010000",
				func = function()
					Fox.Log( "sequences.Seq_Demo_Opening: uncommonMessageTable: Demo: p21_010000_telop_kde_off" )

					local missionName = TppMission.GetMissionName()
					if missionName == "s10010" then
					elseif missionName == "s10280" then
					end
				end,
			},
			{
				msg = "p21_010000_telop_kjp_on",
				sender = "p21_010000",
				func = function()
					Fox.Log( "sequences.Seq_Demo_Opening: uncommonMessageTable: Demo: p21_010000_telop_kjp_on" )

					local missionName = TppMission.GetMissionName()
					if missionName == "s10010" then
						TppUiCommand.SetStrongPrioTelopCast( true )
						TppUiCommand.RegistTelopCast( "Center", 2.5, "telop_kjp", 1.5 )
						TppUiCommand.StartTelopCast()
					elseif missionName == "s10280" then
					end
				end,
			},
			{
				msg = "p21_010000_telop_kjp_off",
				sender = "p21_010000",
				func = function()
					Fox.Log( "sequences.Seq_Demo_Opening: uncommonMessageTable: Demo: p21_010000_telop_kjp_off" )

					local missionName = TppMission.GetMissionName()
					if missionName == "s10010" then
					elseif missionName == "s10280" then
					end
				end,
			},
			{
				msg = "p21_010000_telop_game_on",
				sender = "p21_010000",
				func = function()
					Fox.Log( "sequences.Seq_Demo_Opening: uncommonMessageTable: Demo: p21_010000_telop_game_on" )

					local missionName = TppMission.GetMissionName()
					if missionName == "s10010" then
						TppUiCommand.SetStrongPrioTelopCast( true )
						TppUiCommand.RegistTelopCast( "Center", 2.5, "telop_hideo_kojima_game", 1.5 )
						TppUiCommand.StartTelopCast()
					elseif missionName == "s10280" then
					end
				end,
			},
			{
				msg = "p21_010000_telop_game_off",
				sender = "p21_010000",
				func = function()
					Fox.Log( "sequences.Seq_Demo_Opening: uncommonMessageTable: Demo: p21_010000_telop_game_off" )

					local missionName = TppMission.GetMissionName()
					if missionName == "s10010" then
						TppUiCommand.SetStrongPrioTelopCast( false )
					elseif missionName == "s10280" then
					end
				end,
			},
			{
				msg = "Finish",
				sender = "p21_010000",
				func = function()
					Fox.Log( "sequences.Seq_Demo_Opening: uncommonMessageTable: Demo: Finish: sender: p21_010000" )

					
					if TppMission.GetMissionName() == "s10280" then
						TppSoundDaemon.SetMuteInstant( "Loading" )
					end
				end,
			},
			{
				msg = "FinishMotion",
				sender = "p21_010000",
				func = function()
					TppUiStatusManager.UnsetStatus( "TelopCast", "INVALID" )
					s10010_sequence.SetScatterDofEnabled( { enabled = true, }, true, false )
				end,
			},
			{
				msg = "p21_010000_focusdistanceoff_ps3xbox360",
				sender = "p21_010000",
				func = function()
					s10010_sequence.SetScatterDofEnabled( { enabled = false, }, true, false )
				end,
			},
			{
				msg = "p21_010000_cyprtitle_on",
				sender = "p21_010000",
				func = function()
					Fox.Log( "sequences.Seq_Demo_Opening.uncommonMessageTable: msg: p21_010000_cyprtitle_on: sender: p21_010000" )

					if TppMission.GetMissionName() == "s10010" then
						
						TppUiCommand.StartPressStartCyprusTitle( "LogoOnly" )

						
						s10010_sequence.ShowTitle()
					end

					s10010_sequence.SetScatterDofEnabled( { enabled = true, }, true, false )
				end,
			},
		},
	},

	Messages = s10010_sequence.MakeAwakeRoomSequenceMessages,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_Opening.OnEnter()" )
		s10010_sequence.OnEnterOpeningDemo( self, function() s10010_sequence.StartTimer( "Timer_ChangeSequence", 3 ) end )
		cypr_player_bed_and_corridor.SetEyelidFilterState( cypr_player_bed_and_corridor.EyelidFilterState.DEMO_CONTROL )
		cypr_player_bed_and_corridor.FadeOutEyelidFilter()

	end,

	OnUpdate = function()

		if mvars.doesShowDemoKeyHelp and s10010_sequence.IsAnyStickDown() then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_Opening.OnLeave()" )

		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

		s10010_sequence.OnLeaveOpeningDemo( self )

	end

}

sequences.Seq_Demo_FewDaysLater0 = {

	timerTable = {
		[ StrCode32( "fewDaysLater0_before" ) ] = {
			name = "fewDaysLater0_before",
			time = 0.1,
			Func = function()
				cypr_player_bed_and_corridor.SetAperture( MAX_APERTURE / 10, 0 )
				cypr_player_bed_and_corridor.SetFocusDistanceLimit( MAX_FOCUS_DISTANCE_LIMIT / 10, 0 )
				cypr_player_bed_and_corridor.SetCameraRotationSpeedRate( MAX_CAMERA_RATE / 10 )
				TppUI.FadeIn( 10.0 )
				s10010_sequence.SetPadMaskBed( false )
			end,
		},
		[ StrCode32( "fewDaysLater0_open" ) ] = {
			name = "fewDaysLater0_open",
			time = 3,
			Func = function()
				cypr_player_bed_and_corridor.SetEyelidFilterState( cypr_player_bed_and_corridor.EyelidFilterState.IDLING )
				cypr_player_bed_and_corridor.SetEyelidFilterAverageTime( 10000 )
			end
		},
		[ StrCode32( "fewDaysLater0_eyelid" ) ] = {
			name = "fewDaysLater0_eyelid",
			time = 15,
			Func = function()
				cypr_player_bed_and_corridor.SetEyelidFilterAverageTime( 1 )
			end
		},
		[ StrCode32( "fewDaysLater0_eyelid2" ) ] = {
			name = "fewDaysLater0_eyelid2",
			time = 20,
			Func = function()
				cypr_player_bed_and_corridor.SetAperture( 4, 25 )
				cypr_player_bed_and_corridor.SetFocusDistanceLimit( MAX_FOCUS_DISTANCE_LIMIT / 4, 25 )
			end
		},
		[ StrCode32( "fewDaysLater0_open2" ) ] = {
			name = "fewDaysLater0_open2",
			time = 25,
			Func = function()
				cypr_player_bed_and_corridor.SetEyelidFilterState( cypr_player_bed_and_corridor.EyelidFilterState.OPEN )
				cypr_player_bed_and_corridor.SetEyelidFilterAverageTime( 7 )
				cypr_player_bed_and_corridor.SetCameraRotationSpeedRate( MAX_CAMERA_RATE / 1.5 )
				cypr_player_bed_and_corridor.FadeOutEyelidFilter()
			end
		},
	},

	Messages = s10010_sequence.MakeAwakeRoomSequenceMessages,

	uncommonMessageTable = {
		Demo = {
			{
				msg = "p21_010050_chaptertelop_on",
				func = function( targetName, gameObjectId )
					Fox.Log( "sequences.Seq_Demo_FewDaysLater0.uncommonMessageTable.Demo: p21_010050_chaptertelop_on" )
					local missionName = TppMission.GetMissionName()
					if missionName == "s10010" then
						TppUiCommand.ShowChapterTelop( 0, 3 )
						TppSoundDaemon.PostEvent( "Play_chapter_telop02" )
					elseif missionName == "s10280" then
					end
				end,
				option = { isExecDemoPlaying = true },
			},
			{
				msg = "p21_010050_start_recognition",
				func = function( targetName, gameObjectId )
					TppSequence.SetNextSequence( "Seq_Game_FewDaysLater0" )
				end,
				option = { isExecDemoPlaying = true },
			},
			{
				msg = "Skip",
				func = function()
					TppSequence.SetNextSequence( "Seq_Game_FewDaysLater0" )
				end,
				option = { isExecDemoPlaying = true },
			},
			{
				msg = "Play",
				func = function()
					TppSoundDaemon.ResetMute( "Loading" )
				end,
				option = { isExecDemoPlaying = true },
			},
		},
	},

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_FewDaysLater0.OnEnter()" )

		s10010_demo.PlayFewDaysLater0()
		s10010_sequence.StartTimers( self.timerTable )
		s10010_sequence.ResetCameraRotatioinWhileBedAction( 5, -15, 0 )
		s10010_sequence.SetPadMaskBed( true )

		cypr_player_bed_and_corridor.SetEyelidFilterState( cypr_player_bed_and_corridor.EyelidFilterState.DEMO_CONTROL )
		cypr_player_bed_and_corridor.FadeOutEyelidFilter()
		
		

		TppUiCommand.LyricTexture( "release" )
		TppUiCommand.ShowChapterTelop( "pre", 0 )

	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Demo_FewDaysLater0.OnLeave()" )
		s10010_sequence.SetPadMaskBed( true )
	end

}

s10010_sequence.leftStickXHistory = {}
s10010_sequence.leftStickYHistory = {}
s10010_sequence.rightStickXHistory = {}
s10010_sequence.rightStickYHistory = {}

local DIRECTION = Tpp.Enum{
	"UP",
	"DOWN",
	"LEFT",
	"RIGHT",
	"NO_DIRECTION",
}

local DIRECTION_CHECK_UPDATE_TIME = 1.0




s10010_sequence.OnEnterStickObservationSequence = function( self )

	Fox.Log( "s10010_sequence.OnEnterStickObservationSequence()" )

	s10010_sequence.leftStickXHistory = {}
	s10010_sequence.leftStickYHistory = {}
	s10010_sequence.rightStickXHistory = {}
	s10010_sequence.rightStickYHistory = {}

	if not self.updateTime then
		self.updateTime = DIRECTION_CHECK_UPDATE_TIME
	end
	s10010_sequence.StartTimer( "Timer_CheckUpdate", self.updateTime )

	if self.OnEnterUncommon then
		self.OnEnterUncommon( self )
	end

end




local MAX_HISTORY = 120






s10010_sequence.AddStickHistory = function( historyList, value )

	if #historyList > MAX_HISTORY or Time.GetDeltaGameTime() <= 0.0 then
		return
	end

	table.insert( historyList, value )

end




s10010_sequence.OnUpdateStickObservationSequence = function( self )

	

	local leftStickX = PlayerVars.leftStickXDirect	
	local leftStickY = PlayerVars.leftStickYDirect	
	local rightStickX = PlayerVars.rightStickX	
	local rightStickY = PlayerVars.rightStickY	

	if leftStickX ~= 0 or leftStickY ~= 0 then
		
		if self.OnLeftStickDown then
			self.OnLeftStickDown( self, leftStickX, leftStickY )
		end
	end

	if rightStickX ~= 0 or rightStickY ~= 0 then
		
		if self.OnRightStickDown then
			self.OnRightStickDown( self, rightStickX, rightStickY )
		end
	end

	s10010_sequence.AddStickHistory( s10010_sequence.leftStickXHistory, leftStickX )
	s10010_sequence.AddStickHistory( s10010_sequence.leftStickYHistory, leftStickY )
	s10010_sequence.AddStickHistory( s10010_sequence.rightStickXHistory, rightStickX )
	s10010_sequence.AddStickHistory( s10010_sequence.rightStickYHistory, rightStickY )

	if self.OnUpdateUncommon then
		self.OnUpdateUncommon( self )
	end

end




s10010_sequence.OnLeaveStickObservationSequence = function( self )

	Fox.Log( "s10010_sequence.OnLeaveStickObservationSequence()" )

	if self.OnLeaveUncommon then
		self.OnLeaveUncommon( self )
	end

	s10010_sequence.StopAwakeRoomTimer( self )

	mvars.stickCheckSucceeded = false

end




s10010_sequence.StopAwakeRoomTimer = function( self )

	Fox.Log( "s10010_sequence.StopAwakeRoomTimer()" )

	GkEventTimerManager.Stop( "Timer_CheckUpdate" )

end




s10010_sequence.GetLeftStickDirection = function( self )

	Fox.Log( "s10010_sequence.GetLeftStickDirection()" )

	return s10010_sequence.GetStickDirection( self, s10010_sequence.leftStickXHistory, s10010_sequence.leftStickYHistory, false, false )

end






s10010_sequence.GetRightStickDirection = function( self )

	Fox.Log( "s10010_sequence.GetRightStickDirection()" )

	return s10010_sequence.GetStickDirection( self, s10010_sequence.rightStickXHistory, s10010_sequence.rightStickYHistory, GameConfig.GetCameraLRIsReversed(), GameConfig.GetCameraUDIsReversed() )

end






s10010_sequence.GetStickDirection = function( self, stickXHistory, stickYHistory, xReverse, yReverse )

	



	local CalcAverage = function( numberList, plus )
		local sum = 0
		for i, value in ipairs( numberList ) do
			if ( plus and value > 0 ) or ( not plus and value < 0 ) then
				sum = sum + value
			end
		end
		sum = math.abs( sum )
		return sum / #numberList
	end

	local yDownAverage = CalcAverage( stickYHistory, true )
	local yUpAverage = CalcAverage( stickYHistory, false )
	local xDownAverage = CalcAverage( stickXHistory, false )
	local xUpAverage = CalcAverage( stickXHistory, true )

	if yReverse then
		local tmp = yDownAverage
		yDownAverage = yUpAverage
		yUpAverage = tmp
	end
	if xReverse then
		local tmp = xDownAverage
		xDownAverage = xUpAverage
		xUpAverage = tmp
	end

	return yDownAverage, yUpAverage, xDownAverage, xUpAverage

end




s10010_sequence.MakeStickObservatioinSequenceMessage = function( self )
	local basicMessageTable = {
		Timer = {
			{	
				msg = "Finish",
				sender = "Timer_CheckUpdate",
				func = function ( timerName )
					

					if self.OnStickUpdated then
						local leftStickDown, leftStickUp, leftStickLeft, leftStickRight = s10010_sequence.GetLeftStickDirection()
						local rightStickDown, rightStickUp, rightStickLeft, rightStickRight = s10010_sequence.GetRightStickDirection()

						Fox.Log( "s10010_sequence.MakeStickObservatioinSequenceMessage(): Timer: rightStickDown:" .. tostring( rightStickDown ) .. ", rightStickUp:" .. tostring( rightStickUp ) )

						self.OnStickUpdated( self, leftStickDown, leftStickUp, leftStickLeft, leftStickRight ,rightStickDown, rightStickUp, rightStickLeft, rightStickRight )
					end

					s10010_sequence.leftStickXHistory = {}
					s10010_sequence.leftStickYHistory = {}
					s10010_sequence.rightStickXHistory = {}
					s10010_sequence.rightStickYHistory = {}
					if not self.updateTime then
						self.updateTime = DIRECTION_CHECK_UPDATE_TIME
					end
					s10010_sequence.StartTimer( "Timer_CheckUpdate", self.updateTime )
				end,
			},
		},
	}
	local messageTable
	if self.uncommonMessageTable then
		messageTable = s10010_sequence.MergeMessageTable( basicMessageTable, self.uncommonMessageTable )
	else
		messageTable = basicMessageTable
	end
	return StrCode32Table( messageTable )
end

sequences.Seq_Game_FewDaysLater0 = {

	Messages = s10010_sequence.MakeStickObservatioinSequenceMessage,

	uncommonMessageTable = {
		Timer = {
			{	
				msg = "Finish",
				sender = "Timer_TimeOut",
				func = function( timerName )
					s10010_sequence.StartTimer( "Timer_ChangeSequence", 1 )
					s10010_sequence.SetPadMaskCamera( true )
				end,
			},
			{	
				msg = "Finish",
				sender = "Timer_ChangeSequence_NG1",
				func = function( timerName )
					TppSequence.SetNextSequence( "Seq_Demo_FewDaysLater1_NG1" )
				end,
			},
			{	
				msg = "Finish",
				sender = "Timer_ChangeSequence",
				func = function( timerName )
					TppSequence.SetNextSequence( "Seq_Demo_FewDaysLater1" )
					mvars.reverseYSettingsFinished = false
				end,
			},
			{	
				msg = "Finish",
				sender = "Timer_PlayerOperationEnabled",
				func = function( timerName )
					Fox.Log( "sequences.Seq_Game_FewDaysLater1.uncommonMessageTable: Timer: Finish: Timer_PlayerOperationEnabled" )

					s10010_sequence.SetPadMaskBed( false )

					TppSoundDaemon.PostEvent( "sfx_s_terminal_winopen" )
					mvars.doesShowDemoKeyHelp = true

					TppUiCommand.ShowDemoKeyHelp()
					TppUiCommand.ActiveDemoKeyHelp( true )

				end,
			},
		},
	},

	OnEnter = s10010_sequence.OnEnterStickObservationSequence,

	OnEnterUncommon = function( self )

		Fox.Log( "sequences.Seq_Game_FewDaysLater0.OnEnterUncommon()" )

		s10010_sequence.StartTimer( "Timer_TimeOut", 7 )
		mvars.doesShowDemoKeyHelp = nil	
		mvars.reverseYSettingsFinished = false	

		s10010_sequence.PushMotion{
			locatorName = "awake_doctor",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_tuto_idl.gani",
			specialActionName = "end_of_dct0_tuto_idl",
		}
		s10010_sequence.PushMotion{
			locatorName = "awake_nurse",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_tuto_idl.gani",
			specialActionName = "end_of_nrs0_tuto_idl",
		}

		s10010_sequence.SetPadMaskBed( true )
		s10010_sequence.ResetCameraRotatioinWhileBedAction( 7, -20, 0, 1.40, true )
		s10010_sequence.StartTimer( "Timer_PlayerOperationEnabled", 1.4 )

		TppUI.ShowControlGuide{
			actionName = "CAMERA_MOVE",
			continue = false,
			time = 5,
		}

	end,

	OnUpdate = s10010_sequence.OnUpdateStickObservationSequence,

	OnUpdateUncommon = function( self )

		if mvars.doesShowDemoKeyHelp then
		end

	end,

	OnStickUpdated = function( self, leftStickDown, leftStickUp, leftStickLeft, leftStickRight ,rightStickDown, rightStickUp, rightStickLeft, rightStickRight )

		Fox.Log( "s10010_sequence.sequences.Seq_Game_FewDaysLater0.OnStickUpdated(): direction:" .. tostring( direction ) )

		if ( rightStickDown > 0.5 or rightStickUp > 0.5 or rightStickLeft > 0.5 or rightStickRight > 0.5 ) or mvars.stickCheckSucceeded then
			if not s10010_sequence.IsDemoPlaying( { "fewDaysLater0", "fewDaysLater1_NG0", "fewDaysLater1_NG1", "fewDaysLater1_NG2", } ) then
				mvars.stickCheckSucceeded = false
			else
				mvars.stickCheckSucceeded = true
			end
			return
		end

	end,

	OnRightStickDown = function( self, rightStickX, rightStickY )

		
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end

	end,

	OnLeave = s10010_sequence.OnLeaveStickObservationSequence,

	OnLeaveUncommon = function( self )

		Fox.Log( "sequences.Seq_Game_FewDaysLater0.OnLeaveUncommon()" )

		s10010_sequence.SetPadMaskCamera( false )

	end,

}

sequences.Seq_Demo_FewDaysLater1_NG0 = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010050_cmn_react000_start_recognition",
					func = function( targetName, gameObjectId )
						TppSequence.SetNextSequence( "Seq_Game_FewDaysLater0" )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_FewDaysLater1_NG0.OnEnter()" )

		s10010_demo.PlayFewDaysLater1_NG0()
		s10010_sequence.SetPadMaskBed( true )
		s10010_sequence.ResetCameraRotatioinWhileBedAction( 7, -20, 0, 1.40, true )

	end,

}

sequences.Seq_Demo_FewDaysLater1_NG1 = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010050_cmn_react001_start_recognition",
					func = function( targetName, gameObjectId )
						TppSequence.SetNextSequence( "Seq_Game_FewDaysLater0" )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_FewDaysLater1_NG1.OnEnter()" )

		s10010_demo.PlayFewDaysLater1_NG1()
		s10010_sequence.SetPadMaskBed( true )
		s10010_sequence.ResetCameraRotatioinWhileBedAction( 7, -20, 0, 1.40, true )

	end,

}

sequences.Seq_Demo_FewDaysLater1_NG2 = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010050_cmn_react002_start_recognition",
					func = function( targetName, gameObjectId )
						TppSequence.SetNextSequence( "Seq_Game_FewDaysLater0" )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_FewDaysLater1_NG2.OnEnter()" )

		s10010_demo.PlayFewDaysLater1_NG2()
		s10010_sequence.SetPadMaskBed( true )
		s10010_sequence.ResetCameraRotatioinWhileBedAction( 7, -20, 0, 1.40, true )

	end,

}

sequences.Seq_Demo_FewDaysLater1 = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010050_001_start_recognition",
					func = function()
						TppSequence.SetNextSequence( "Seq_Game_FewDaysLater1" )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function()

		Fox.Log( "sequences.Seq_Demo_FewDaysLater1.OnEnter()" )

		s10010_demo.PlayFewDaysLater1()
		s10010_sequence.SetPadMaskBed( true )
		s10010_sequence.ResetCameraRotatioinWhileBedAction( 7, -20, 0, 1.40, true )

	end,

	OnLeave = function()
		mvars.ngCount = 0
		s10010_sequence.SetPadMaskBed( false )
	end,

}

sequences.Seq_Game_FewDaysLater1 = {

	Messages = s10010_sequence.MakeStickObservatioinSequenceMessage,

	uncommonMessageTable = {
		Timer = {
			{	
				msg = "Finish",
				sender = "Timer_TimeOut",
				func = function( timerName )
					Fox.Log( "sequences.Seq_Game_FewDaysLater1.uncommonMessageTable: Timer: Finish: Timer_TimeOut" )
					s10010_sequence.StartTimer( "Timer_ChangeSequence_NG", 1.0 )
					s10010_sequence.SetPadMaskCamera( true )
				end,
			},
			{	
				msg = "Finish",
				sender = "Timer_ChangeSequence",
				func = function( timerName )
					Fox.Log( "sequences.Seq_Game_FewDaysLater1.uncommonMessageTable: Timer: Finish: Timer_ChangeSequence" )
					TppSequence.SetNextSequence( "Seq_Demo_FewDaysLater2" )
				end,
			},
			{	
				msg = "Finish",
				sender = "Timer_ChangeSequence_NG",
				func = function( timerName )
					Fox.Log( "sequences.Seq_Game_FewDaysLater1.uncommonMessageTable: Timer: Finish: Timer_ChangeSequence_NG0" )
					local sequenceName
					if mvars.ngCount % 3 == 0 then
						sequenceName = "Seq_Demo_FewDaysLater2_NG0"
					elseif mvars.ngCount % 3 == 1 then
						sequenceName = "Seq_Demo_FewDaysLater2_NG2"
					else
						sequenceName = "Seq_Demo_FewDaysLater2_NG3"
					end
					TppSequence.SetNextSequence( sequenceName )
					mvars.ngCount = mvars.ngCount + 1
				end,
			},
		},
		nil
	},

	OnEnter = s10010_sequence.OnEnterStickObservationSequence,

	OnEnterUncommon = function( self )

		Fox.Log( "sequences.Seq_Game_FewDaysLater1.OnEnterUncommon()" )

		s10010_sequence.StartTimer( "Timer_TimeOut", 16 )
		mvars.reverseYSettingsFinished = false	
		mvars.stickCheckSucceeded = false	

		TppSoundDaemon.PostEvent( "sfx_s_terminal_winopen" )

		TppUiCommand.ShowDemoKeyHelp()
		TppUiCommand.ActiveDemoKeyHelp( true )
		mvars.doesShowDemoKeyHelp = true

		s10010_sequence.SetPadMaskBed( false )

		TppUI.ShowControlGuide{
			actionName = "CAMERA_MOVE",
			continue = false,
			time = 5,
		}

	end,

	OnUpdate = s10010_sequence.OnUpdateStickObservationSequence,

	OnStickCheckSucceeded = function( self )

		Fox.Log( "sequences.Seq_Game_FewDaysLater1.OnStickCheckSucceeded" )

		GkEventTimerManager.Stop( "Timer_TimeOut" )
		s10010_sequence.StopAwakeRoomTimer( self )
		s10010_sequence.StartTimer( "Timer_ChangeSequence", 1.0 )
		mvars.stickCheckSucceeded = false
		TppSoundDaemon.PostEvent( "sfx_s_act_icon_choose" )
		s10010_sequence.SetPadMaskCamera( true )
		Player.CallVoice( "snak_down_normal_01", nil, "DD_vox_Snake_reaction" )

	end,

	OnUpdateUncommon = function( self )

		if not s10010_sequence.IsDemoPlaying( { "fewDaysLater1", "fewDaysLater2_NG0", "fewDaysLater2_NG1", "fewDaysLater2_NG2", "fewDaysLater1_NG1", } ) and mvars.stickCheckSucceeded then
			self.OnStickCheckSucceeded( self )
		end

		if mvars.doesShowDemoKeyHelp then
		end

	end,

	OnStickUpdated = function( self, leftStickDown, leftStickUp, leftStickLeft, leftStickRight ,rightStickDown, rightStickUp, rightStickLeft, rightStickRight )
		local direction = s10010_sequence.GetRightStickDirection( self )
		Fox.Log( "sequences.Seq_Game_FewDaysLater1.OnStickUpdated(): direction:" .. tostring( direction ) )
		if rightStickUp > 0.5 then
			if not s10010_sequence.IsDemoPlaying( { "fewDaysLater1", "fewDaysLater2_NG0", "fewDaysLater2_NG1", "fewDaysLater2_NG2", "fewDaysLater1_NG1", } ) then
				self.OnStickCheckSucceeded( self )
			else
				mvars.stickCheckSucceeded = true
			end
			return
		elseif not s10010_sequence.IsDemoPlaying( { "fewDaysLater1", "fewDaysLater2_NG0", "fewDaysLater2_NG1", "fewDaysLater2_NG2", "fewDaysLater1_NG1", } ) and ( rightStickDown > 0.5 or rightStickLeft > 0.5 or rightStickRight > 0.5 ) then
			s10010_sequence.StartTimer( "Timer_ChangeSequence_NG", 1.0 )
			s10010_sequence.SetPadMaskCamera( true )
			mvars.ngCount = mvars.ngCount + 1
		end
	end,

	OnRightStickDown = function( self, rightStickX, rightStickY )

		if mvars.doesShowDemoKeyHelp and not mvars.reverseYSettingsFinished and math.abs( rightStickY ) > 0.0 then
			GameConfig.SetCameraUDIsReversed( rightStickY > 0 )	

			
			TppSave.VarSave()
			TppSave.VarSaveConfig()
			TppSave.SaveConfigData()

			mvars.reverseYSettingsFinished = true
		end

		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end

	end,

	OnLeave = s10010_sequence.OnLeaveStickObservationSequence,

	OnLeaveUncommon = function( self )

		Fox.Log( "sequences.Seq_Game_FewDaysLater1.OnLeaveUncommon()" )

		s10010_sequence.SetPadMaskCamera( false )

	end,

}

sequences.Seq_Demo_FewDaysLater2_NG0 = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010050_001_react000_start_recognition",
					func = function( targetName, gameObjectId )
						TppSequence.SetNextSequence( "Seq_Game_FewDaysLater1" )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_FewDaysLater2_NG0.OnEnter()" )

		s10010_demo.PlayFewDaysLater2_NG0()
		s10010_sequence.SetPadMaskBed( true )
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end
		s10010_sequence.ResetCameraRotatioinWhileBedAction( 7, -20, 0, 1.40, true )

	end,

}

sequences.Seq_Demo_FewDaysLater2_NG1 = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010050_cmn_react000_start_recognition",
					func = function( targetName, gameObjectId )
						TppSequence.SetNextSequence( "Seq_Game_FewDaysLater1" )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_FewDaysLater2_NG0.OnEnter()" )

		s10010_demo.PlayFewDaysLater2_NG1()
		s10010_sequence.SetPadMaskBed( true )
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end
		s10010_sequence.ResetCameraRotatioinWhileBedAction( 7, -20, 0, 1.40, true )

	end,

}

sequences.Seq_Demo_FewDaysLater2_NG2 = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010050_cmn_react002_start_recognition",
					func = function( targetName, gameObjectId )
						TppSequence.SetNextSequence( "Seq_Game_FewDaysLater1" )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_FewDaysLater2_NG2.OnEnter()" )

		s10010_demo.PlayFewDaysLater2_NG2()
		s10010_sequence.SetPadMaskBed( true )
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end
		s10010_sequence.ResetCameraRotatioinWhileBedAction( 7, -20, 0, 1.40, true )

	end,

}

sequences.Seq_Demo_FewDaysLater2_NG3 = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010050_cmn_react001_start_recognition",
					func = function( targetName, gameObjectId )
						TppSequence.SetNextSequence( "Seq_Game_FewDaysLater1" )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_FewDaysLater2_NG3.OnEnter()" )

		s10010_demo.PlayFewDaysLater1_NG1()
		s10010_sequence.SetPadMaskBed( true )
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end
		s10010_sequence.ResetCameraRotatioinWhileBedAction( 7, -20, 0, 1.40, true )

	end,

}

sequences.Seq_Demo_FewDaysLater2 = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_FewDaysLater2.OnEnter()" )

		local missionName = TppMission.GetMissionName()
		if missionName == "s10010" then
			s10010_demo.PlayFewDaysLater2( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_FewDaysLater2" ) end, } )
		elseif missionName == "s10280" then
			s10010_demo.PlayFewDaysLater2_Truth( { onEnd = function() TppSequence.SetNextSequence( "Seq_Demo_FewDaysLater3" ) end, } )
		end

		s10010_sequence.ResetCameraRotatioinWhileBedAction( 7, -20, 0, 1.40, true )
		s10010_sequence.SetPadMaskBed( true )
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end

	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Demo_FewDaysLater2.OnLeave()" )
		s10010_sequence.SetPadMaskBed( false )
	end,

}

sequences.Seq_Game_FewDaysLater2 = {

	Messages = function( self )
		return
		StrCode32Table {
			UI = {
				{
					msg = "NameEntryClose",
					func = function()
						TppUI.FadeOut( TppUI.FADE_SPEED.FADE_NORMALSPEED )
					end,
				},
				{
					msg = "EndFadeOut",
					func = function()
						if TppUiCommand.EndNameEntry then
							TppUiCommand.EndNameEntry()
						end
						TppSequence.SetNextSequence( "Seq_Demo_FewDaysLater3" )
					end,
				},
			},
			nil,
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_FewDaysLater2.OnEnter()" )

		TppUI.OverrideFadeInGameStatus{
			CallMenu = false,
			PauseMenu = false,
			EquipHud = false,
			EquipPanel = false,
			CqcIcon = false,
			ActionIcon = false,
			AnnounceLog = false,
			BaseName = false,
		}

		TppUiCommand.StartNameEntry()

		
		TppEffectUtility.CreateHighSpeedFilter_NameEntrySpecial( 200 )

		TppUI.FadeIn( TppUI.FADE_SPEED.FADE_HIGHESTSPEED )

	end,

	OnLeave = function()

		Fox.Log( "sequences.Seq_Game_FewDaysLater2.OnLeave()" )

		
		TppEffectUtility.DeleteHighSpeedFilter_NameEntrySpecial()

		TppUI.OverrideFadeInGameStatus( s10010_sequence.DEFAULT_OVERRIDE_SYSTEM_EXCEPT_GAME_STATUS )

		s10010_sequence.UpdateCheckPoint{ checkPoint = "CHK_AfterAwakeRoom", ignoreAlert = true, }

	end,

}

sequences.Seq_Demo_FewDaysLater3 = {

	HideControlGuide = function()
		
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end
	end,

	Messages = function( self )
		return
		StrCode32Table {
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_StickDownTimeOut",
					func = function( targetName, gameObjectId )
						Fox.Log( "sequences.Seq_Demo_FewDaysLater3.Messages(): Timer: Finish: Timer_StickDownTimeOut" )
						self.HideControlGuide()
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_FewDaysLater3.OnEnter()" )

		local missionName = TppMission.GetMissionName()
		if missionName == "s10010" then
			s10010_demo.PlayFewDaysLater3( { onEnd = function() TppSequence.SetNextSequence( "Seq_Demo_OneWeekLater" ) end, } )
			TppUI.FadeIn( TppUI.FADE_SPEED.FADE_HIGHESTSPEED )
		elseif missionName == "s10280" then
			s10010_demo.PlayFewDaysLater3_Truth( { onEnd = function() TppSequence.SetNextSequence( "Seq_Demo_OneWeekLater" ) end, } )
		end

		cypr_player_bed_and_corridor.SetEyelidFilterState( cypr_player_bed_and_corridor.EyelidFilterState.OPEN )
		cypr_player_bed_and_corridor.SetEyelidFilterAverageTime( 7 )
		cypr_player_bed_and_corridor.SetCameraRotationSpeedRate( MAX_CAMERA_RATE / 1.5 )
		cypr_player_bed_and_corridor.FadeOutEyelidFilter()
		cypr_player_bed_and_corridor.SetAperture( 4, 25 )
		cypr_player_bed_and_corridor.SetFocusDistanceLimit( MAX_FOCUS_DISTANCE_LIMIT / 4, 25 )

		TppUiCommand.ShowDemoKeyHelp()
		TppUiCommand.ActiveDemoKeyHelp( true )
		mvars.doesShowDemoKeyHelp = true

		s10010_sequence.StartTimer( "Timer_StickDownTimeOut", 5 )

	end,

	OnContinue = function( self )
		Fox.Log( "sequences.Seq_Demo_FewDaysLater3.OnContinue()" )
	end,

	OnUpdate = s10010_sequence.OnUpdateStickObservationSequence,

	OnRightStickDown = function( self, rightStickX, rightStickY )
		self.HideControlGuide()
	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Demo_FewDaysLater3.OnLeave()" )
		self.HideControlGuide()
		s10010_sequence.SetPadMaskBed( true )
	end

}

sequences.Seq_Demo_OneWeekLater = {

	timerTable = {
		[ StrCode32( "OneWeekLater_before" ) ] = { name = "OneWeekLater_before", time = 1, Func = function()
			cypr_player_bed_and_corridor.SetAperture( MAX_APERTURE / 4, 1 )
			cypr_player_bed_and_corridor.SetFocusDistanceLimit( MAX_FOCUS_DISTANCE_LIMIT / 4, 1 )
			cypr_player_bed_and_corridor.SetCameraRotationSpeedRate( MAX_CAMERA_RATE / 1.5 )
			s10010_sequence.SetPadMaskBed( false )
		end },
		[ StrCode32( "OneWeekLater_open" ) ] = { name = "OneWeekLater_open", time = 3, Func = function()
			
			
		end },
		[ StrCode32( "OneWeekLater_eyelid" ) ] = { name = "OneWeekLater_eyelid", time = 10, Func = function()
			
		end },
		[ StrCode32( "OneWeekLater_open2" ) ] = { name = "OneWeekLater_open2", time = 12, Func = function()
			
			
			cypr_player_bed_and_corridor.SetAperture( MAX_APERTURE / 2, 1 )
			cypr_player_bed_and_corridor.SetFocusDistanceLimit( MAX_FOCUS_DISTANCE_LIMIT / 2, 1 )
			cypr_player_bed_and_corridor.SetCameraRotationSpeedRate( MAX_CAMERA_RATE / 1.5 )
			
		end },
	},

	Messages = s10010_sequence.MakeAwakeRoomSequenceMessages,

	OnReceivedIconMessage = function()

		Fox.Log( "sequences.Seq_Demo_OneWeekLater.OnReceivedIconMessage()" )

		TppUiCommand.ShowDemoKeyHelp()
		TppUiCommand.ActiveDemoKeyHelp( true )
		mvars.doesShowDemoKeyHelp = true
		s10010_sequence.StartTimer( "Timer_StickDownTimeOut", 10 )

	end,

	uncommonMessageTable = {
		Timer = {
			{
				msg = "Finish",
				sender = "Timer_StickDownTimeOut",
				func = function()
					if mvars.doesShowDemoKeyHelp then
						TppUiCommand.HideDemoKeyHelp()
						mvars.doesShowDemoKeyHelp = nil	
					end
				end,
			},
		},
		Demo = {
			{
				msg = "p21_010100_iconon01",
				func = function()
					Fox.Log( "sequences.Seq_Demo_OneWeekLater.uncommonMessageTable: Demo: p21_010100_iconon01" )
					sequences.Seq_Demo_OneWeekLater.OnReceivedIconMessage()
				end,
				option = { isExecDemoPlaying = true },
			},
			{
				msg = "p21_010100_iconon02",
				func = function()
					Fox.Log( "sequences.Seq_Demo_OneWeekLater.uncommonMessageTable: Demo: p21_010100_iconon02" )
					sequences.Seq_Demo_OneWeekLater.OnReceivedIconMessage()
				end,
				option = { isExecDemoPlaying = true },
			},
		},
	},

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_OneWeekLater.OnEnter()" )

		s10010_demo.PlayOneWeekLaterDemo( {
			onEnd = function()
				local missionName = TppMission.GetMissionName()
				if missionName == "s10010" then
					TppSequence.SetNextSequence( "Seq_Demo_TwoWeekLater" )
				elseif missionName == "s10280" then
					TppSequence.SetNextSequence( "Seq_Game_PrepareBeforeTwoWeekLater" )
				end
			end,
		} )
		s10010_sequence.StartTimers( self.timerTable )
		s10010_sequence.ResetCameraRotatioinWhileBedAction()

		

	end,

	OnUpdate = function()

		
		if mvars.doesShowDemoKeyHelp and s10010_sequence.IsAnyStickDown() then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_OneWeekLater.OnLeave()" )

		
		

		s10010_sequence.StopTimers( self.timerTable )

		
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

		s10010_sequence.SetPadMaskBed( false )

	end

}

sequences.Seq_Game_PrepareBeforeTwoWeekLater = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_PrepareBeforeTwoWeekLater.OnEnter()" )
		Player.SetDoesAvatarResourceBorrow( true )

	end,

	OnUpdate = function( self )

		if Player.UpdateCanStartMission() then
			TppSequence.SetNextSequence( "Seq_Demo_TwoWeekLater" )
		end

		TppUI.ShowAccessIconContinue()

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_PrepareBeforeTwoWeekLater.OnLeave()" )

	end,

}

sequences.Seq_Demo_TwoWeekLater = {

	timerTable = {
		[ StrCode32( "TwoWeekLater_before" ) ] = { name = "TwoWeekLater_before", time = 1, Func = function()
			
			cypr_player_bed_and_corridor.SetFocusDistanceLimit( MAX_FOCUS_DISTANCE_LIMIT / 2, 1 )
			cypr_player_bed_and_corridor.SetCameraRotationSpeedRate( MAX_CAMERA_RATE / 1.5 )
			s10010_sequence.SetPadMaskBed( false )
		end },
		[ StrCode32( "TwoWeekLater_open" ) ] = { name = "TwoWeekLater_open", time = 3, Func = function()
			
			
		end },
		[ StrCode32( "TwoWeekLater_eyelid" ) ] = { name = "TwoWeekLater_eyelid", time = 10, Func = function()
			
		end },
		[ StrCode32( "TwoWeekLater_open2" ) ] = { name = "TwoWeekLater_open2", time = 12, Func = function()
			
			
			cypr_player_bed_and_corridor.SetAperture( MAX_APERTURE / 2, 1 )
			cypr_player_bed_and_corridor.SetFocusDistanceLimit( MAX_FOCUS_DISTANCE_LIMIT / 2, 1 )
			cypr_player_bed_and_corridor.SetCameraRotationSpeedRate( MAX_CAMERA_RATE / 1.5 )
			
		end },
	},

	Messages = s10010_sequence.MakeAwakeRoomSequenceMessages,

	uncommonMessageTable = {
		Timer = {
			{	
				msg = "Finish",
				sender = "Timer_ChangeSequence",
				func = function( timerName )
					
				end,
			},
			{
				msg = "Finish",
				sender = "Timer_StickDownTimeOut",
				func = function()
					if mvars.doesShowDemoKeyHelp then
						TppUiCommand.HideDemoKeyHelp()
						mvars.doesShowDemoKeyHelp = nil	
					end
				end,
			},
		},
		Demo = {
			{
				msg = "p21_010200_iconon01",
				func = function()
					Fox.Log( "sequences.Seq_Demo_TwoWeekLater.uncommonMessageTable: Demo: p21_010200_iconon01" )

					TppUiCommand.ShowDemoKeyHelp()
					TppUiCommand.ActiveDemoKeyHelp( true )
					mvars.doesShowDemoKeyHelp = true
					s10010_sequence.StartTimer( "Timer_StickDownTimeOut", 10 )
				end,
				option = { isExecDemoPlaying = true },
			},
		},
		nil
	},

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_TwoWeekLater.OnEnter()" )

		local missionName = TppMission.GetMissionName()
		if missionName == "s10010" then
			s10010_demo.PlayTwoWeekLaterDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_Load13" ) end, } )
		elseif missionName == "s10280" then
			s10010_demo.PlayTwoWeekLaterDemo_Truth( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_Load34" ) end, } )
			s10010_sequence.SetScatterDofEnabled( { enabled = true, ignoreGen7 = true, }, true, false )
		end

		s10010_sequence.StartTimers( self.timerTable )

		s10010_sequence.ResetCameraRotatioinWhileBedAction()
		s10010_sequence.SetPadMaskBed( true )

		cypr_player_bed_and_corridor.SetEyelidFilterState( cypr_player_bed_and_corridor.EyelidFilterState.OPEN )
		cypr_player_bed_and_corridor.FadeOutEyelidFilter()

	end,

	OnUpdate = function()

		
		if mvars.doesShowDemoKeyHelp and s10010_sequence.IsAnyStickDown() then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_TwoWeekLater.OnLeave()" )

		s10010_sequence.StopTimers( self.timerTable )

		
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

		cypr_player_bed_and_corridor.DeleteEyelidFilter()

		local missionName = TppMission.GetMissionName()
		if missionName == "s10280" then
			s10010_sequence.SetScatterDofEnabled( { enabled = false, ignoreGen7 = true, }, true, false )

			
			Player.SetAllInstanceActiveMode( false )
			Player.SetOtherInstanceIsForMirrorMode( false )
		end

		s10010_sequence.SetPadMaskBed( false )

	end

}

sequences.Seq_Game_Load13 = s10010_sequence.MakeLoadSequenceTable( nil, "Seq_Game_LoadAvatarPlayer1", 13, "Seq_Game_LoadAvatarPlayer1", "CHK_AfterAwakeRoom" )

sequences.Seq_Game_Load34 = s10010_sequence.MakeLoadSequenceTable( nil, "Seq_Game_LoadAvatarPlayer1", 34, "Seq_Game_LoadAvatarPlayer1", "CHK_AfterAwakeRoom" )

sequences.Seq_Game_LoadAvatarPlayer1 = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_LoadAvatarPlayer1.OnEnter()" )

		TppUI.FadeOut( 0.0 )

		local missionName = TppMission.GetMissionName()
		if missionName == "s10010" then
			
			local position, rotationY = Tpp.GetLocator( "CheckPointIdentifier", "warp_avatarEdit" )
			GameObject.SendCommand( GameObject.GetGameObjectId( "TppPlayer2", "Player" ), { id = "Warp", pos = position, rotY = rotationY } )

			
			s10010_sequence.SetPadMaskAvatarEdit( true )

			
			Player.SetAroundCameraManualMode( true )
			Player.SetAroundCameraManualModeParams{
				target = Vector3(0,0,0),
			}
			Player.UpdateAroundCameraManualModeParams()

			mvars.oldPlayerFaceEquipId = vars.playerFaceEquipId

			
			vars.playerType = PlayerType.SNAKE
			vars.playerCamoType =PlayerCamoType.AVATAR_EDIT_MAN
			vars.playerPartsType = PlayerPartsType.AVATAR_EDIT_MAN
			
			vars.playerFaceEquipId = 0
		elseif missionName == "s10280" then
			
			vars.playerType = PlayerType.AVATAR
			vars.playerCamoType = PlayerCamoType.OLIVEDRAB
			vars.playerPartsType = PlayerPartsType.NORMAL
			
			
		end

		mvars.playerCheckCount = 0

	end,

	OnUpdate = function( self )

		if mvars.playerCheckCount > 3 then	
			if PlayerInfo.OrCheckStatus and PlayerInfo.OrCheckStatus{ PlayerStatus.PARTS_ACTIVE, } then
				Fox.Log( "sequences.Seq_Game_LoadAvatarPlayer.OnUpdate(): Finish PlayerInfo.OrCheckStatus{ PlayerStatus.PARTS_ACTIVE, }" )

				local missionName = TppMission.GetMissionName()
				if missionName == "s10010" then
					TppSequence.SetNextSequence( "Seq_Game_LoadAvatarEdit" )
				elseif missionName == "s10280" then
					TppSequence.SetNextSequence( "Seq_Demo_SouvenirPhotograph" )
				end
			end
		else
			mvars.playerCheckCount = mvars.playerCheckCount + 1
		end

		TppUI.ShowAccessIconContinue()

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_LoadAvatarPlayer1.OnLeave()" )

	end,

}

sequences.Seq_Game_LoadAvatarEdit = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_LoadAvatarEdit.OnEnter()" )

		
		TppUiCommand.LoadAvatarEdit( { type=AvatarEdit.AVATAR_IN_DEMO, presets=avatar_presets.presets }  )

	end,

	OnUpdate = function( self )

		if TppUiCommand.IsAvatarEditReady and TppUiCommand.IsAvatarEditReady() then
			Fox.Log( "sequences.Seq_Game_LoadAvatarEdit.OnUpdate(): AvatarEditReady." )
			TppSequence.SetNextSequence( "Seq_Game_AvatarEdit" )
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_LoadAvatarEdit.OnLeave()" )

	end,

}

sequences.Seq_Game_AvatarEdit = {

	Messages = function( self )
		return
		StrCode32Table {
			UI = {
				{	
					msg = "AvatarEditEnd",
					func = function()
						Fox.Log( "sequences.Seq_Game_AvatarEdit.Messages(): UI: AvatarEditEnd" )
						TppSequence.SetNextSequence( "Seq_Demo_LoadAvatarPlayer2" )
					end,
				},
			},
			nil,
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_AvatarEdit.OnEnter()" )

		TppUI.OverrideFadeInGameStatus{
			CallMenu = false,
			PauseMenu = false,
			EquipHud = false,
			EquipPanel = false,
			CqcIcon = false,
			ActionIcon = false,
			AnnounceLog = false,
			BaseName = false,
		}

		if TppUiCommand.StartAvatarEdit then
			TppUiCommand.StartAvatarEdit()
		end

		GrTools.SetSubSurfaceScatterFade( 0.6 )
		TppUI.FadeIn( 0.5 )

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_AvatarEdit.OnLeave()" )

		TppUI.FadeOut( 0.0 )

		
		s10010_sequence.SetPadMaskAvatarEdit( false )

		
		TppUiCommand.EndAvatarEdit()

		
		TppSave.SaveAvatarData()
		

		GrTools.SetSubSurfaceScatterFade( 0.0 )

		TppUI.OverrideFadeInGameStatus( s10010_sequence.DEFAULT_OVERRIDE_SYSTEM_EXCEPT_GAME_STATUS )

	end,

}

sequences.Seq_Demo_SouvenirPhotograph = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_SouvenirPhotograph.OnEnter()" )
		s10010_demo.PlaySouvenirPhotograph( { onEnd = function() TppSequence.SetNextSequence( "Seq_Demo_LoadAvatarPlayer2" ) end, } )

		s10010_sequence.SetEffectVisibility( { effectName = "FxLocatorGroup_fx_tpp_cldcypInside", visible = false, }, true, false )
		WeatherManager.RequestTag( "group_photo", 0 )

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_SouvenirPhotograph.OnLeave()" )

		WeatherManager.RequestTag( "cypr_Night_RLR", 0 )
		s10010_sequence.SetEffectVisibility( { effectName = "FxLocatorGroup_fx_tpp_cldcypInside", visible = true, }, true, false )

	end,

}




sequences.Seq_Demo_LoadAvatarPlayer2 = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_LoadAvatarPlayer2.OnEnter()" )

		TppUI.FadeOut( 0.0 )

		
		vars.playerType = PlayerType.SNAKE
		vars.playerCamoType = PlayerCamoType.HOSPITAL
		vars.playerPartsType = PlayerPartsType.HOSPITAL
		
		vars.playerFaceEquipId = mvars.oldPlayerFaceEquipId

		
		local position, rotationY = Tpp.GetLocator( "CheckPointIdentifier", "warp_bed" )
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppPlayer2", "Player" ), { id = "Warp", pos = position, rotY = rotationY } )

		local missionName = TppMission.GetMissionName()
		if missionName == "s10010" then
			
			Player.SetAroundCameraManualMode( false )
		elseif missionName == "s10280" then
		end

		mvars.playerCheckCount = 0

	end,

	OnUpdate = function( self )

		if mvars.playerCheckCount > 3 then	
			if PlayerInfo.OrCheckStatus and PlayerInfo.OrCheckStatus{ PlayerStatus.PARTS_ACTIVE } then
				Fox.Log( "sequences.Seq_Demo_LoadAvatarPlayer2.OnUpdate(): Finish PlayerInfo.OrCheckStatus{ PlayerStatus.PARTS_ACTIVE " )
				local missionName = TppMission.GetMissionName()
				if missionName == "s10010" then
					TppSequence.SetNextSequence( "Seq_Game_Load1" )
				elseif missionName == "s10280" then
					TppSequence.SetNextSequence( "Seq_Game_Load21_2" )
				end
			end
		else
			mvars.playerCheckCount = mvars.playerCheckCount + 1
		end

		TppUI.ShowAccessIconContinue()

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_LoadAvatarPlayer2.OnLeave()" )

	end,

}

sequences.Seq_Game_Load1 = s10010_sequence.MakeLoadSequenceTable( nil, "Seq_Demo_PrepareBeforeQuietAppear", 1, "Seq_Demo_PrepareBeforeQuietAppear", "CHK_AfterAwakeRoom" )

sequences.Seq_Game_Load21_2 = s10010_sequence.MakeLoadSequenceTable( nil, "Seq_Game_WaitCreatingBlendTexture1", 21, "Seq_Game_WaitCreatingBlendTexture1", nil )

sequences.Seq_Demo_PrepareBeforeQuietAppear = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_PrepareBeforeQuietAppear.OnEnter()" )
		Player.SetDoesAvatarResourceBorrow( true )

	end,

	OnUpdate = function( self )

		if Player.UpdateCanStartMission() then
			TppSequence.SetNextSequence( "Seq_Demo_QuietAppear" )
		end

		TppUI.ShowAccessIconContinue()

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_PrepareBeforeQuietAppear.OnLeave()" )

	end,

}

sequences.Seq_Game_WaitCreatingBlendTexture1 = {

	Messages = function( self )
		return
		StrCode32Table {
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_Telop",
					func = function()
						Fox.Log( "sequences.Seq_Game_WaitCreatingBlendTexture1.Messages(): Timer: Timer_Telop" )
						mvars.telopFinished = true
					end,
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_WaitCreatingBlendTexture1.OnEnter()" )
		TppUiCommand.CreateBlendTexture( "PhotoBack" )	
		mvars.telopFinished = false

		
		TppUiCommand.CallMissionTelopTyping( "date_mission_30_10280_01" )

		s10010_sequence.StartTimer( "Timer_Telop", 2 )

	end,

	OnUpdate = function( self )
		if mvars.telopFinished and not TppUiCommand.IsCreatingBlendTexture() then	
			TppSequence.SetNextSequence( "Seq_Demo_QuietAppear" )
		end

		TppUI.ShowAccessIconContinue()
	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_WaitCreatingBlendTexture1.OnLeave()" )

	end,

}

sequences.Seq_Demo_QuietAppear = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010230_iconon01",
					func = function()

						Fox.Log( "sequences.Seq_Demo_QuietAppear.Messages(): Demo: p21_010230_iconon01" )

						TppUiCommand.ShowDemoKeyHelp()
						TppUiCommand.ActiveDemoKeyHelp( true )
						mvars.doesShowDemoKeyHelp = true
						s10010_sequence.StartTimer( "Timer_StickDownTimeOut", 10 )

					end,
					option = { isExecDemoPlaying = true },
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_StickDownTimeOut",
					func = function()

						Fox.Log( "sequences.Seq_Demo_QuietAppear.Messages(): Timer: Timer_StickDownTimeOut" )

						if mvars.doesShowDemoKeyHelp then
							TppUiCommand.HideDemoKeyHelp()
							mvars.doesShowDemoKeyHelp = nil	
						end

					end,
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_QuietAppear.OnEnter()" )

		local missionName = TppMission.GetMissionName()
		if missionName == "s10010" then
			s10010_demo.PlayQuietAppearDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Demo_IshmaelAppear" ) end, } )
		elseif missionName == "s10280" then
			s10010_demo.PlayQuietAppearTruthDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Demo_IshmaelAppear" ) end, } )
		end

		cypr_player_bed_and_corridor.SetEyelidFilterState( cypr_player_bed_and_corridor.EyelidFilterState.DEMO_CONTROL )
		cypr_player_bed_and_corridor.FadeInEyelidFilter()

		
		TppSoundDaemon.ResetMute( "Outro" )

	end,

	OnUpdate = function()

		
		if mvars.doesShowDemoKeyHelp and s10010_sequence.IsRightStickDown() then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_QuietAppear.OnLeave()" )

		
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

		
		local missionName = TppMission.GetMissionName()
		if missionName == "s10010" then
			Player.SetAllInstanceActiveMode( false )
			Player.SetOtherInstanceIsForMirrorMode( false )
		end

		
		TppUiCommand.DeleteBlendTexture( "PhotoBack" )

	end,

}

sequences.Seq_Demo_IshmaelAppear = {

	Messages = function( self )
		return
		StrCode32Table {
			Timer = {
				{	
					msg = "Finish",
					sender = "Timer_QuietExit",
					func = function()
						TppSequence.SetNextSequence( "Seq_Demo_QuietExit" )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_StickDownTimeOut",
					func = function()

						Fox.Log( "sequences.Seq_Demo_QuietAppear.Messages(): Timer: Timer_StickDownTimeOut" )

						if mvars.doesShowDemoKeyHelp then
							TppUiCommand.HideDemoKeyHelp()
							mvars.doesShowDemoKeyHelp = nil	
						end

					end,
				},
			},
			Demo = {
				{
					msg = "p21_010240_iconon01",
					func = function()
						Fox.Log( "sequences.Seq_Demo_IshmaelAppear.Messages(): Demo: p21_010240_iconon01" )

						TppUiCommand.ShowDemoKeyHelp()
						TppUiCommand.ActiveDemoKeyHelp( true )
						mvars.doesShowDemoKeyHelp = true
						s10010_sequence.StartTimer( "Timer_StickDownTimeOut", 10 )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			nil,
		}
	end,

	OnEnter = function()

		Fox.Log( "sequences.Seq_Demo_IshmaelAppear.OnEnter()" )

		s10010_demo.PlayIshmaelAppearDemo( { onEnd = function() s10010_sequence.StartTimer( "Timer_QuietExit", 3 ) end, } )

		s10010_sequence.SetScatterDofEnabled( { enabled = true, }, true, false )

	end,

	OnUpdate = function()

		
		if mvars.doesShowDemoKeyHelp and s10010_sequence.IsRightStickDown() then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_IshmaelAppear.OnLeave()" )

		
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

		s10010_sequence.SetScatterDofEnabled( { enabled = false, }, true, false )

	end,

}

sequences.Seq_Demo_QuietExit = {

	OnEnter = function()

		s10010_demo.PlayQuietExitDemo( {
			onEnd = function()
				TppSequence.SetNextSequence( "Seq_Game_Load2" )
				TppUI.ShowControlGuide{
					actionName = "PLAY_MOVE",
					continue = false,
				}
				mvars.moveControlGuideShown = true
			end,
		} )

	end,

}

sequences.Seq_Game_Load2 = s10010_sequence.MakeLoadSequenceTable( "trap_HeliDemo", "Seq_Demo_Heli", 2, "Seq_Game_EscapeFromAwakeRoom", "CHK_AfterAwakeRoom" )

sequences.Seq_Game_EscapeFromAwakeRoom = {

	Messages = function( self )
		return
		StrCode32Table {
			Player = {
				{	
					msg = "NotifyCyprusMotionEvent",
					func = function( gameObjectId, motionEventName )
						Fox.Log( "sequences.Seq_Game_EscapeFromAwakeRoom.Messages(): Player: NotifyCyprusMotionEvent: gameObjectId:" ..
							tostring( gameObjectId ) .. ", motionEventName:" .. tostring( motionEventName ) )
						if motionEventName == StrCode32( "MTEV_RAIL_ACTION_KNOCK_THE_CART_OVER" ) then	
							Fox.Log( "sequences.Seq_Game_EscapeFromAwakeRoom.Messages(): Player: NotifyCyprusMotionEvent: MTEV_RAIL_ACTION_KNOCK_THE_CART_OVER" )
							s10010_sequence.PushMotion{
								locatorName = "ishmael",
								motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_s_lok_wgn.gani",
								specialActionName = "end_of_ish0non_s_lok_wgn",
							}
						elseif motionEventName == StrCode32( "MTEV_RAIL_ACTION_KNOCK_THE_CHAIR_OVER" ) then	
							Fox.Log( "sequences.Seq_Game_EscapeFromAwakeRoom.Messages(): Player: NotifyCyprusMotionEvent: MTEV_RAIL_ACTION_KNOCK_THE_CHAIR_OVER" )
							s10010_sequence.PushMotion{
								locatorName = "ishmael",
								motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_s_lok_cir.gani",
								specialActionName = "end_of_ish0non_s_lok_cir",
							}
							s10010_sequence.StartTimer( "Timer_StopAfterChairDown", 3 )
							s10010_sequence.ProhibitMove( true )
						end
					end,
				},
			},
			Timer = {
				{	
					msg = "Finish",
					sender = "Timer_StopAfterChairDown",
					func = function()
						s10010_sequence.ProhibitMove( false )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0001",
					func = function()
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_001", } )
					end,
				},
			},
			nil,
		}
	end,

	nextSequenceName = "Seq_Demo_Heli",

	OnEnter = function( self )

		if s10010_sequence.IsDemoSequenceReserved( self.nextSequenceName ) then
			self.SetNextSequence( self )
		end

		if not mvars.moveControlGuideShown then
			TppUI.ShowControlGuide{
				actionName = "PLAY_MOVE",
				continue = false,
			}
			mvars.moveControlGuideShown = true
		end

		s10010_sequence.StartTimer( "Timer_IshmaelMonologue0001", 4 )

		
		TppUiCommand.CallMissionTelopTyping( "area_mission_30_10010", "date_mission_30_10010" )

	end,

	SetNextSequence = function( self )
		TppSequence.SetNextSequence( self.nextSequenceName )
	end,

}

sequences.Seq_Demo_Heli = {

	OnEnter = function( self )
		if s10010_sequence.IsCompleteLoading() then
			self.PlayDemo()
		else
			mvars.demoFinished = false
		end
	end,

	OnUpdate = function( self )
		if not mvars.demoFinished and s10010_sequence.IsCompleteLoading() then
			self.PlayDemo()
		end
	end,

	OnLeave = function( self )
		mvars.demoFinished = false
	end,

	PlayDemo = function()
		s10010_demo.PlayHeliDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_AfterHeliDemo" ) end, } )
		mvars.demoFinished = true
	end,

}

sequences.Seq_Game_AfterHeliDemo = {

	Messages = function( self )
		return
		StrCode32Table {
			Player = {
				{	
					msg = "NotifyCyprusMotionEvent",
					func = function( gameObjectId, motionEventName )
						Fox.Log( "sequences.Seq_Game_AfterHeliDemo.Messages(): Player: NotifyCyprusMotionEvent: gameObjectId:" ..
							tostring( gameObjectId ) .. ", motionEventName:" .. tostring( motionEventName ) )
						if motionEventName == StrCode32( "MTEV_RAIL_ACTION_ASHTRAY_WAS_TOPPLED" ) then	
							s10010_sequence.PushMotion{
								locatorName = "ishmael",
								motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_s_beh_lok_2rn_new.gani",
								specialActionName = "end_of_ish0non_s_beh_lok_2rn_new",
								positioin = Vector3( -60.10466, 106.175, -1713.12754 ),
							}
							s10010_sequence.OnEventPlayed( "ashtrayDown" )
							s10010_sequence.OnEventFinished( "ashtrayDown" )

							s10010_sequence.StartTimer( "Timer_StopAfterAshtrayDown", 5 )
							s10010_sequence.ProhibitMove( true )
						end
					end,
				},
			},
			Timer = {
				{	
					msg = "Finish",
					sender = "Timer_StopAfterAshtrayDown",
					func = function()
						Fox.Log( "sequences.Seq_Game_AfterHeliDemo.Messages(): Timer: Finish: Timer_StopAfterAshtrayDown" )
						s10010_sequence.ProhibitMove( false )
					end,
				},
			},
			nil,
		}
	end,

	OnEnter = function()
	end,

}

sequences.Seq_Demo_Volgin = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010270_iconon01",
					func = function()
						TppUiCommand.ShowDemoKeyHelp()
						TppUiCommand.ActiveDemoKeyHelp( true )
						mvars.doesShowDemoKeyHelp = true
						s10010_sequence.StartTimer( "Timer_StickDownTimeOut", 10 )
					end,
					option = { isExecDemoPlaying = true },
				},
				{
					msg = "PlayerOverrideOff",
					func = function()
						Fox.Log( "sequences.Seq_Demo_Volgin.Messages(): Demo: PlayerOverrideOff" )
						s10010_sequence.StartBedAction( { stance = "VOLGIN_CORRIDOR", }, true, false )
					end,
					option = { isExecDemoPlaying = true },
				},
				{
					msg = "PlayerOverrideOn",
					func = function()
						Fox.Log( "sequences.Seq_Demo_Volgin.Messages(): Demo: PlayerOverrideOn" )
						s10010_sequence.StopBedAction( {}, true, false )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_StickDownTimeOut",
					func = function()
						if mvars.doesShowDemoKeyHelp then
							TppUiCommand.HideDemoKeyHelp()
							mvars.doesShowDemoKeyHelp = nil	
						end
					end,
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_Volgin.OnEnter()" )

		s10010_demo.PlayVolginDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_Load3" ) end, } )

	end,

	OnUpdate = function()

		if mvars.doesShowDemoKeyHelp and s10010_sequence.IsAnyStickDown() then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_Volgin.OnLeave()" )

		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

	end,

}

sequences.Seq_Game_Load3 = s10010_sequence.MakeLoadSequenceTable( "trap_Cure", "Seq_Demo_Cure", 3, "Seq_Game_AfterVolginDemo", "CHK_AfterVolgin" )

sequences.Seq_Game_AfterVolginDemo = {

	Messages = function( self )
		return
		StrCode32Table {
			Player = {
				{	
					msg = "NotifyCyprusMotionEvent",
					func = function( gameObjectId, motionEventName )
						Fox.Log( "sequences.Seq_Game_AfterVolginDemo.Messages(): Player: NotifyCyprusMotionEvent: gameObjectId:" ..
							tostring( gameObjectId ) .. ", motionEventName:" .. tostring( motionEventName ) )
						if motionEventName == StrCode32( "MTEV_RAIL_ACTION_BENCH_EXPLOSION" ) then	
							s10010_sequence.OnEventPlayed( "explosion" )
							s10010_sequence.OnEventFinished( "explosion" )
							s10010_sequence.StartTimer( "Timer_IshmaelSpeak", 2 )
							s10010_sequence.StartTimer( "Timer_IshmaelMove", 4 )
							s10010_sequence.StartTimer( "Timer_PlayerMove", 6 )
							s10010_sequence.ProhibitMove( true )
						elseif motionEventName == StrCode32( "MTEV_TO_DEMO" ) then	
							Fox.Log( "sequences.Seq_Game_AfterVolginDemo.Messages(): Player: NotifyCyprusMotionEvent: MTEV_to_DEMO" )
							TppSequence.SetNextSequence( "Seq_Demo_Cure" )
						end
					end,
				},
			},
			Timer = {
				{	
					msg = "Finish",
					sender = "Timer_IshmaelSpeak",
					func = function()
						Fox.Log( "sequences.Seq_Game_AfterVolginDemo.Messages(): Timer: Finish: Timer_IshmaelSpeak" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_089", } )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_IshmaelMove",
					func = function()
						Fox.Log( "sequences.Seq_Game_AfterVolginDemo.Messages(): Timer: Finish: Timer_IshmaelMove" )
						s10010_sequence.PushMotion{
							locatorName = "ishmael",
							motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_lok_bom_ed.gani",
							specialActionName = "end_of_ish0non_q_lok_bom_ed",
						}
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_PlayerMove",
					func = function()
						Fox.Log( "sequences.Seq_Game_AfterVolginDemo.Messages(): Timer: Finish: Timer_PlayerMove" )
						s10010_sequence.ProhibitMove( false )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0000",
					func = function()
						Fox.Log( "sequences.Seq_Game_AfterVolginDemo.Messages(): Timer: Finish: Timer_IshmaelMonologue0000" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_019", } )
					end,
				},
			},
			nil,
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_AfterVolginDemo.OnEnter()" )

		s10010_sequence.StartTimer( "Timer_IshmaelMonologue0000", 90 )

	end,

}

sequences.Seq_Demo_Cure = {

	OnEnter = function()
		s10010_demo.PlayCureDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_EnterSmokeRoom" ) end, } )
	end,

	OnLeave = function()
		s10010_sequence.UpdateCheckPoint{ checkPoint = "CHK_AfterCure", ignoreAlert = true, }
	end,

}

sequences.Seq_Game_EnterSmokeRoom = {

	enemyList = {
		"sol_p21_010310_0000",
		"sol_p21_010310_0001",
		"sol_p21_010310_0002",
	},

	Messages = function( self )
		return
		StrCode32Table {
			Trap = {
				{	
					msg = "Enter",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_EnterSmokeRoom.Messages(): Trap: Enter: trapName:" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

						if mvars.smokeRoomDoorClosed then
							Fox.Log( "s10010_sequence.sequences.Seq_Game_EnterSmokeRoom.Messages(): ignore operation because mvars.smokeRoomDoorClosed is true." )
						else
							s10010_sequence.OnGameObjectEnterTrap( trapName, gameObjectId )	
							if s10010_sequence.IsPlayerAndSoldierInSameTrap() then
								s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOverBeforeSmokeRoom" )
							end
						end

					end,
				},
				{	
					msg = "Enter",
					sender = "trap_UnderBed",
					func = function()
						TppSequence.SetNextSequence( "Seq_Demo_UnderBed" )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_SmokeRoom_0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_EnterSmokeRoom.Messages(): Trap: Enter: trap_IshmaelRouteChange_SmokeRoom_0000" )
						if Tpp.IsPlayer( gameObjectId ) then
							s10010_sequence.PushMotion{
								locatorName = "ishmael",
								action = "PlayState",
								state = "stateIshmael_q_pnt1_to_pnt2",
								motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt1_to_pnt2.gani",
								specialActionName = "end_of_ish0non_q_pnt1_to_pnt2",
								position = Vector3( -36.82696, 106.175003, -1706.85758 ),
								rotationY = 0,
								enableAim = true,
							}
							s10010_sequence.ProhibitMove( true )
							s10010_sequence.OnEventPlayed( "enterSmokeRoom" )
							mvars.smokeRoomDoorClosed = true
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_ProhibitPlayerMove",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_EnterSmokeRoom.Messages(): Trap: Enter: trap_CancelProhibitingPlayerMove: gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "ishmael" ) then
							if not PlayerInfo.AndCheckStatus{ PlayerStatus.CRAWL, } then
								s10010_sequence.StopPlayerAndStartNearCamera( true, "ishmael" )
							end	
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_CancelProhibitingPlayerMove",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_EnterSmokeRoom.Messages(): Trap: Enter: trap_CancelProhibitingPlayerMove: gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "ishmael" ) then
							if not PlayerInfo.AndCheckStatus{ PlayerStatus.CRAWL, } then
								s10010_sequence.StartTimer( "Timer_IshmaelMonologue0002", 4 )	
								s10010_sequence.StartTimer( "Timer_IshmaelMonologue0003", 12 )
								s10010_sequence.StartTimer( "Timer_IshmaelMonologue0004", 36 )
							end	
							mvars.permitToCancelProhibitingPlayerMove = true
							mvars.needToCheck = true
						end
						s10010_sequence.OnEventFinished( "enterSmokeRoom" )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelMonologue0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_EnterSmokeRoom.Messages(): Trap: Enter: trap_IshmaelMonologue0000: gameObjectId:" .. tostring( gameObjectId ) )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_020", } )
					end,
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0009",
					func = function()
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_005", } )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0002",
					func = function()
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_027", } )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0003",
					func = function()
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_026", } )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0004",
					func = function()
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_025", } )
					end,
				},
			},
			nil
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_EnterSmokeRoom.OnEnter()" )

		for i, enemyName in ipairs( self.enemyList ) do
			s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_BeforeSmokeRoom_0000" ), GameObject.GetGameObjectId ( enemyName ) )
		end
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_BeforeSmokeRoom_0001" ), GameObject.GetGameObjectId( "Player" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_BeforeSmokeRoom_0006" ), GameObject.GetGameObjectId( "Player" ) )

		

		mvars.smokeRoomDoorClosed = false

		s10010_sequence.StartTimer( "Timer_IshmaelMonologue0009", 4 )

	end,

	OnUpdate = function( self )

		if mvars.needToCheck and mvars.permitToCancelProhibitingPlayerMove and PlayerInfo.AndCheckStatus{ PlayerStatus.CRAWL, } then
			s10010_sequence.ProhibitMove( false )
			GkEventTimerManager.Stop( "Timer_IshmaelMonologue0002" )
			GkEventTimerManager.Stop( "Timer_IshmaelMonologue0003" )
			GkEventTimerManager.Stop( "Timer_IshmaelMonologue0004" )
			mvars.needToCheck = nil
		elseif mvars.needToCheck and mvars.permitToCancelProhibitingPlayerMove and Time.GetDeltaGameTime() > 0.0 then
			TppUI.ShowControlGuide{
				actionName = "STANCE_CRAWL",
				continue = true,
			}
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_EnterSmokeRoom.OnLeave()" )

	end,

}

s10010_sequence.MakeGameOverSequenceTable = function( enemyList )

	return {

		Messages = function( self )
			return
			StrCode32Table {
				Timer = {
					{	
						msg = "Finish",
						sender = "Timer_GameOver",
						func = function()
							Player.OnPlayerDeath()
						end,
					},
					{	
						msg = "Finish",
						sender = "Timer_GameOver_Before",
						func = function()
							Fox.Log( "s10010_sequence.MakeGameOverSequenceTable(): Messages(): Timer: Finish: Timer_GameOver_Before" )

							local gameObjectId = mvars.gameObjectIdDiscoveryingPlayer
							if Tpp.IsSoldier( gameObjectId ) then
								GameObject.SendCommand( gameObjectId, { id = "SetCommandAi", commandType = CommandAi.FORCE_SHOOT, } )
							end

							

							s10010_sequence.StartTimer( "Timer_GameOver", 1 )

						end,
					},
				},
				Player = {
					{
						msg = "PlayerDamaged",
						func = function( gameObjectId, attackId, offenceGameObjectId )
							Fox.Log( "s10010_sequence.MakeGameOverSequenceTable(): Messages(): Player: PlayerDamaged: gameObjectId:" ..
								tostring( gameObjectId ) .. ", attackId:" .. tostring( attackId ) .. ", offenceGameObjectId:" .. tostring( offenceGameObjectId ) )
							Player.OnPlayerDeath()
						end,
					},
				},
				nil
			}
		end,

		OnEnter = function( self )

			Fox.Log( "s10010_sequence.MakeGameOverSequenceTable(): OnEnter()" )

			for i, enemyName in ipairs( enemyList ) do
				local gameObjectId = GameObject.GetGameObjectId( enemyName )
				if Tpp.IsSoldier( gameObjectId ) then
					GameObject.SendCommand( gameObjectId, { id = "SetPuppet", enabled = false, } )

					
					GameObject.SendCommand( gameObjectId, { id = "SetDisableDamage", life = true, faint = true, sleep = true } )
				end
			end
			s10010_sequence.StartTimer( "Timer_GameOver_Before", 0.5 )

			local gameObjectId
			if mvars.gameObjectIdDiscoveryingPlayer then	
				gameObjectId = mvars.gameObjectIdDiscoveryingPlayer
			else
				mvars.gameObjectIdDiscoveryingPlayer = GameObject.GetGameObjectId( enemyList[ 1 ] )
				gameObjectId = GameObject.GetGameObjectId( enemyList[ 1 ] )
			end
			local position = GameObject.SendCommand( gameObjectId, { id = "GetPosition", } )
			if position then
				local degree = TppMath.RadianToDegree( math.atan2( position:GetX() - vars.playerPosX, position:GetZ() - vars.playerPosZ ) )
				local degreeX
				if gameObjectId == GameObject.GetGameObjectId( "WestHeli" ) then
					
					TppSoundDaemon.PostEvent3D( "sfx_s_bikkuri", position )

					degreeX = -TppMath.RadianToDegree( math.atan2( position:GetY() - vars.playerPosY, position:GetZ() - vars.playerPosZ ) )
				else
					degreeX = 5
				end
				Player.RequestToSetCameraRotation {
					rotX = degreeX,	
					rotY = degree,
					interpTime = 0.25,	
				}
				Player.RequestToSetCameraFocalLengthAndDistance {
					focalLength = 31, 
					distance = 2, 
					interpTime = 0.25 
				}
			end

			if Tpp.IsSoldier( gameObjectId ) then
				GameObject.SendCommand( gameObjectId, { id = "SetDiscoveryPlayer", } )
			end

			if gameObjectId == GameObject.GetGameObjectId( "WestHeli" ) then
				GameObject.SendCommand( gameObjectId, { id = "SetActionCommandFireToPlayer", time = 3 } )
			end

			
			s10010_sequence.SetPadMaskGameOver( true )

		end,

		OnLeave = function( self )

			Fox.Log( "s10010_sequence.MakeGameOverSequenceTable(): OnLeave()" )

			s10010_sequence.ProhibitMove( false )

		end,

	}

end

sequences.Seq_Game_GameOverBeforeSmokeRoom = s10010_sequence.MakeGameOverSequenceTable( sequences.Seq_Game_EnterSmokeRoom.enemyList )

sequences.Seq_Demo_UnderBed = {

	OnEnter = function()
		s10010_demo.PlayUnderBedDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_UnderBed" ) end, } )
		s10010_sequence.ProhibitMove( true )
		s10010_sequence.SetPadMaskCamera( true )
	end,

	OnLeave = function( self )
		s10010_sequence.ProhibitMove( false )
	end,

}

sequences.Seq_Game_UnderBed = {

	Messages = s10010_sequence.MakeStickObservatioinSequenceMessage,

	OnEnter = s10010_sequence.OnEnterStickObservationSequence,

	OnUpdate = s10010_sequence.OnUpdateStickObservationSequence,

	OnLeftStickDown = function( self, leftStickX, leftStickY )

		Fox.Log( "s10010_sequence.sequences.Seq_Game_UnderBed.OnLeftStickDown(): leftStickX:" .. tostring( leftStickX ) .. ", leftStickY:" .. tostring( leftStickY ) )
		TppSequence.SetNextSequence( "Seq_Demo_UnderBed2" )

	end,

	OnLeave = s10010_sequence.OnLeaveStickObservationSequence,

	OnLeaveUncommon = function( self )

		Fox.Log( "sequences.Seq_Game_UnderBed.OnLeaveUncommon()" )
		s10010_sequence.SetPadMaskCamera( false )

	end,

}

sequences.Seq_Demo_UnderBed2 = {

	OnEnter = function()
		s10010_demo.PlayUnderBed2Demo( { onEnd = function()
			TppSequence.SetNextSequence( "Seq_Game_Load4" )
		end, } )
	end,

}

sequences.Seq_Game_Load4 = s10010_sequence.MakeLoadSequenceTable( "trap_HeliKillMob", "Seq_Demo_HeliKillMob", 4, "Seq_Game_EscapeFromSmokeRoom", "CHK_SmokeRoom" )

sequences.Seq_Game_EscapeFromSmokeRoom = {

	enemyList = {
		"sol_p21_010340_0000",
	},

	Messages = function( self )
		return
		StrCode32Table {
			Trap = {
				{	
					msg = "Enter",
					sender = "trap_HeliKillMob",
					func = function()
						self.SetNextSequence( self )
					end,
				},
				{	
					msg = "Enter",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_EscapeFromSmokeRoom.Messages(): Trap: Enter: trapName:" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

						s10010_sequence.OnGameObjectEnterTrap( trapName, gameObjectId )	

						if s10010_sequence.IsPlayerAndSoldierInSameTrap() then
							TppEnemy.SetSneakRoute( "sol_p21_010340_0000", "rts_skull_after_p21_010340_0001" )
							s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOverSmokeRoom" )
						end
					end,
				},
			},
			nil
		}
	end,

	nextSequenceName = "Seq_Demo_HeliKillMob",

	OnEnter = function( self )

		if s10010_sequence.IsDemoSequenceReserved( self.nextSequenceName ) then
			self.SetNextSequence( self )
		end

		s10010_sequence.ProhibitMove( true )

		GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_010", } )

		for i, enemyName in ipairs( self.enemyList ) do
			s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_SmokeRoom_0000" ), GameObject.GetGameObjectId ( enemyName ) )
			s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_SmokeRoom_0001" ), GameObject.GetGameObjectId ( enemyName ) )
		end

	end,

	SetNextSequence = function( self )
		TppSequence.SetNextSequence( self.nextSequenceName )
	end,

	OnUpdate = function( self )
		if PlayerInfo.AndCheckStatus{ PlayerStatus.CRAWL, } then
			s10010_sequence.ProhibitMove( false )
		end
	end,

}

sequences.Seq_Game_GameOverSmokeRoom = s10010_sequence.MakeGameOverSequenceTable( sequences.Seq_Game_EscapeFromSmokeRoom.enemyList )

sequences.Seq_Demo_HeliKillMob = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010360_iconon01",
					func = function()
						Fox.Log( "sequences.Seq_Demo_HeliKillMob.Messages(): Demo: p21_010360_iconon01" )

						TppUiCommand.ShowDemoKeyHelp()
						TppUiCommand.ActiveDemoKeyHelp( true )
						s10010_sequence.StartTimer( "Timer_StickDownTimeOut", 5 )
						mvars.doesShowDemoKeyHelp = true
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_StickDownTimeOut",
					func = function()
						if mvars.doesShowDemoKeyHelp then
							TppUiCommand.HideDemoKeyHelp()
							mvars.doesShowDemoKeyHelp = nil
						end
					end,
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_HeliKillMob.OnEnter()" )

		s10010_demo.PlayHeliKillMobDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_AfterHeliKillMobDemo" ) end, } )
		s10010_sequence.ProhibitMove( true )

		Player.RequestToSetTargetStance( PlayerStance.CRAWL )

		Player.SetCyprPlayerPushedId( { targetId = GameObject.GetGameObjectId( "ishmael" ), isOn = 0, } )

	end,

	OnUpdate = function( self )

		if mvars.doesShowDemoKeyHelp and s10010_sequence.IsAnyStickDown() then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_HeliKillMob.OnLeave()" )

		s10010_sequence.ProhibitMove( false )
		s10010_sequence.UpdateCheckPoint{ checkPoint = "CHK_HeliKill", ignoreAlert = true, }
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end

	end,

}

sequences.Seq_Game_AfterHeliKillMobDemo = {

	enemyList = {
		"WestHeli",
	},

	ishmaelVoiceLabelList = {
		"ISHM_038",
		"ISHM_039",
		"ISHM_040",
	},

	Messages = function( self )
		return
		StrCode32Table {
			GameObject = {
				{	
					msg = "InSight",
					
					func = function( heliGameObjectId, targetGameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterHeliKillMobDemo.Messages(): GameObject: InSight: heliGameObjectId:" ..
							tostring( heliGameObjectId ) .. ", targetGameObjectId:" .. tostring( targetGameObjectId ) )
						mvars.gameObjectIdDiscoveryingPlayer = heliGameObjectId
						s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOver_AfterSmokeRoom" )
					end,
				},
				{	
					msg = "RoutePoint2",
					func = function( gameObjectId, routeId, routeNodeIndex, messageId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterHeliKillMobDemo.Messages(): GameObject: RoutePoint2: WestHeli" )
						if messageId == StrCode32( "end_of_rts_heli_4F_0000" ) and mvars.searchLightGameStarted then
							if not mvars.ishmaelVoiceCount then
								mvars.ishmaelVoiceCount = 0
							end
							local label = self.ishmaelVoiceLabelList[ mvars.ishmaelVoiceCount % 3 + 1 ]
							GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = label, } )
							mvars.ishmaelVoiceCount = mvars.ishmaelVoiceCount + 1
						end
					end,
				},
			},
			Trap = {
				{	
					msg = "Enter",
					sender = "trap_SoldierKillMob",
					func = function()
						
						local gameObjectId = GameObject.GetGameObjectId( "ptn_p21_010370_0000" )
						GameObject.SendCommand( gameObjectId, { id = "Warp", position = Vector3( -54.026, 105.376, -1684.387 ), control = charaControl, } )--RETAILBUG: ORPHAN, probably from copy paste
						GameObject.SendCommand( gameObjectId, { id = "CallMonologue", label = "MOB_008", } )

						s10010_sequence.ProhibitMove( true )

						s10010_sequence.StartTimer( "Timer_ChangeSequence", 1 )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_Blackout",
					func = function()
						
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = false, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = true, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = true, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_Foot_isolate", enable = true, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_on", visible = false, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_off", visible = true, }, true, false )

						s10010_sequence.StartTimer( "Timer_Blackout_0000", 0.125 )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_AfterSmokeRoom_0000",
					func = function()
						s10010_sequence.PushMotion{
							locatorName = "ishmael",
							motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt6_to_pnt8.gani",
							specialActionName = "end_of_ish0non_q_pnt6_to_pnt8",
							position = Vector3( -55.03106, 106.175, -1683.50847 ),
							rotationY = 0,
						}
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_037", } )
						mvars.searchLightGameStarted = true
						TppUI.ShowTipsGuide{
							contentName = "COVER",	
							isOnce = false,
							isOnceThisGame = false,
						}
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_CloseSmokeRoomDoor0001",
					func = function()

					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelMonologue",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterHeliKillMobDemo.Messages(): Trap: Enter: trap_IshmaelMonologue" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_028", } )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelMonologue0001",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterHeliKillMobDemo.Messages(): Trap: Enter: trap_IshmaelMonologue0001" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_029", } )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelMonologue0002",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterHeliKillMobDemo.Messages(): Trap: Enter: trap_IshmaelMonologue0002" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_030", } )
					end,
				},
				{	
					msg = "Enter",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_EscapeFromHeli.Messages(): Trap: Enter: trapName:" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

						s10010_sequence.OnGameObjectEnterTrap( trapName, gameObjectId )	

						if s10010_sequence.IsPlayerAndSoldierInSameTrap() then
							s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOver_AfterSmokeRoom" )
						end
					end,
				},
			},
			Timer = {
				{	
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0005",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterHeliKillMobDemo.Messages(): Timer: Finish: Timer_IshmaelMonologue0005" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_033", } )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0006",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterHeliKillMobDemo.Messages(): Timer: Finish: Timer_IshmaelMonologue0005" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_034", } )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0007",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterHeliKillMobDemo.Messages(): Timer: Finish: Timer_IshmaelMonologue0005" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_035", } )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_Blackout_0000",
					func = function()
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = true, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = false, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = false, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_Foot_isolate", enable = false, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_on", visible = true, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_off", visible = false, }, true, false )

						s10010_sequence.StartTimer( "Timer_Blackout_0001", 0.25 )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_Blackout_0001",
					func = function()
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = false, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = true, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = true, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_Foot_isolate", enable = true, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_on", visible = false, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_off", visible = true, }, true, false )

						s10010_sequence.StartTimer( "Timer_Blackout_0002", 0.125 )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_Blackout_0002",
					func = function()
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = true, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = false, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = false, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_Foot_isolate", enable = false, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_on", visible = true, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_off", visible = false, }, true, false )

						s10010_sequence.StartTimer( "Timer_Blackout_0003", 0.05 )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_Blackout_0003",
					func = function()
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = false, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = true, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = true, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_Foot_isolate", enable = true, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_on", visible = false, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_off", visible = true, }, true, false )

						s10010_sequence.StartTimer( "Timer_Blackout_0004", 0.125 )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_Blackout_0004",
					func = function()
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = true, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = false, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = false, }, true, false )
						s10010_sequence.EnableDataBody( { identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_Foot_isolate", enable = false, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_on", visible = true, }, true, false )
						s10010_sequence.SetModelVisibility( { identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_off", visible = false, }, true, false )

						s10010_sequence.StartTimer( "Timer_Blackout_Last", 0.5 )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_Blackout_Last",
					func = function()
						s10010_sequence.OnEventPlayed( "blackout", false )
						s10010_sequence.OnEventFinished( "blackout", false )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_ChangeSequence",
					func = function()
						TppSequence.SetNextSequence( "Seq_Demo_SoldierKillMob" )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_ResumeIshmaelPush",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterHeliKillMobDemo.Messages(): Timer: Finish: Timer_ResumeIshmaelPush" )
						Player.SetCyprPlayerPushedId( { targetId = GameObject.GetGameObjectId( "ishmael" ), isOn = 1, } )
					end,
				},
			},
			nil
		}
	end,

	OnEnter = function()

		mvars.doesHeliFire = false

		s10010_sequence.StartTimer( "Timer_IshmaelMonologue0005", 12 )
		s10010_sequence.StartTimer( "Timer_IshmaelMonologue0006", 36 )
		s10010_sequence.StartTimer( "Timer_IshmaelMonologue0007", 90 )

		GameObject.SendCommand( GameObject.GetGameObjectId( "WestHeli" ), { id = "CallSound", eventName = "sfx_m_cypr_heli" } ) 

		TppUI.ShowControlGuide{
			actionName = "STANCE_SQUAT",
			continue = false,
		}

		Player.SetCyprPlayerPushedId( { targetId = GameObject.GetGameObjectId( "ishmael" ), isOn = 0, } )
		s10010_sequence.StartTimer( "Timer_ResumeIshmaelPush", 1 )

	end,

	OnLeave = function()

		mvars.doesHeliFire = false

		GkEventTimerManager.Stop( "Timer_IshmaelMonologue0005" )
		GkEventTimerManager.Stop( "Timer_IshmaelMonologue0006" )
		GkEventTimerManager.Stop( "Timer_IshmaelMonologue0007" )

	end,

	OnContinue = function( self )

		Fox.Log( "sequences.Seq_Game_AfterHeliKillMobDemo.OnContinue()" )

	end,

}

sequences.Seq_Game_GameOver_AfterSmokeRoom = s10010_sequence.MakeGameOverSequenceTable( sequences.Seq_Game_AfterHeliKillMobDemo.enemyList )

sequences.Seq_Demo_SoldierKillMob = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{	
					msg = "p21_010370_padon",
					func = function( demoId )
						Fox.Log( "s10010_sequence.sequences.Seq_Demo_SoldierKillMob.Messages(): Demo: p21_010370_padon" )
						TppUI.ShowControlGuide{
							actionName = "PLAY_DASH",
							continue = false,
						}
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_044", } )
						s10010_sequence.ProhibitMove( false )
						TppSequence.SetNextSequence( "Seq_Game_EscapeFromHeli" )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			nil,
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_SoldierKillMob.OnEnter()" )

		s10010_demo.PlaySoldierKillMobDemo( {
			onStart = function()
			end,
			onEnd = function()
			end,
		} )
		s10010_sequence.ProhibitMove( true )

		
		Player.RequestToSetTargetStance( PlayerStance.SQUAT )

		
		Player.RequestToMoveToPosition{
			name = "p21_010370",  
			position = Vector3( vars.playerPosX, vars.playerPosY, vars.playerPosZ ),    
			direction = 180,        
			
			moveType = PlayerMoveType.WALK, 
			timeout = 10,   
		}

		
		local gameObjectId = GameObject.GetGameObjectId( "WestHeli" )
		local position = GameObject.SendCommand( gameObjectId, { id = "GetPosition", } )
		TppSoundDaemon.PostEvent3D( "sfx_m_cypr_heli_bye", position )

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_SoldierKillMob.OnLeave()" )

		s10010_sequence.ProhibitMove( false )
		s10010_sequence.UpdateCheckPoint{ checkPoint = "CHK_SoldierKill", ignoreAlert = true, }

	end,

}

sequences.Seq_Game_EscapeFromHeli = {

	enemyList = {
		"sol_p21_010370_0000",
		"sol_p21_010370_0001",
	},

	Messages = function( self )
		return
		StrCode32Table {
			GameObject = {
				{	
					msg = "InSight",
					
					func = function( heliGameObjectId, targetGameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_EscapeFromHeli.Messages(): GameObject: InSight: heliGameObjectId:" .. tostring( heliGameObjectId ) ..
							", targetGameObjectId:" .. tostring( targetGameObjectId ) )
						s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOver_HeliCorridor" )
					end,
				},
			},
			Trap = {
				{	
					msg = "Enter",
					sender = "trap_Stairway",
					func = function()
						TppSequence.SetNextSequence( "Seq_Demo_Stairway" )
					end,
				},
				{	
					msg = "Enter",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_EscapeFromHeli.Messages(): Trap: Enter: trapName:" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

						s10010_sequence.OnGameObjectEnterTrap( trapName, gameObjectId )	

						if s10010_sequence.IsPlayerAndSoldierInSameTrap() then
							s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOver_HeliCorridor" )
						end
					end,
				},
			},
			nil
		}
	end,

	OnEnter = function( self )

		for i, enemyName in ipairs( self.enemyList ) do
			s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_AfterSmokeRoom_0001" ), GameObject.GetGameObjectId ( enemyName ) )
		end

		
		Player.SetCyprBreathSoundLevel{ soundLevel = 1, }

	end,

	OnContinue = function( self )

		Fox.Log( "sequences.Seq_Game_EscapeFromHeli.OnContinue()" )

		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_AfterSmokeRoom_0010" ), GameObject.GetGameObjectId( "Player" ) )

		TppUI.ShowControlGuide{
			actionName = "PLAY_DASH",
			continue = false,
		}
		GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_044", } )

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_EscapeFromHeli.OnLeave()" )
		Player.SetCyprBreathSoundLevel{ soundLevel = 0, }

		s10010_sequence.UpdateCheckPoint{ checkPoint = "CHK_BeforeStairway", ignoreAlert = true, }

	end,

}

sequences.Seq_Game_GameOver_HeliCorridor = s10010_sequence.MakeGameOverSequenceTable( sequences.Seq_Game_EscapeFromHeli.enemyList )

sequences.Seq_Demo_Stairway = {

	Messages = function( self )
		return
		StrCode32Table( s10010_sequence.stairwayMessageTable )
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_Stairway.OnEnter()" )

		for i, enemyName in ipairs( sequences.Seq_Game_EscapeFromHeli.enemyList ) do
			local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyName )
			if gameObjectId ~= GameObject.NULL_ID then
				GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDisableNpc", enable = true, } )
			end
		end

		DemoDaemon.SkipAtDemoPlay( "p21_010370", "p21_010380" )
		s10010_demo.PlayStairwayDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_Load5" ) end, } )
		s10010_sequence.ProhibitMove( true )

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_Stairway.OnLeave()" )

		for i, enemyName in ipairs( sequences.Seq_Game_EscapeFromHeli.enemyList ) do
			local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyName )
			if gameObjectId ~= GameObject.NULL_ID then
				GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDisableNpc", enable = false, } )
			end
		end

	end,

}

s10010_sequence.OnIshmaelToCorridor = function()

	Fox.Log( "s10010_sequence.OnIshmaelToCorridor()" )

	if not mvars.ish0non_q_pnt13_to_pnt14_Finished then
		s10010_sequence.PushMotion{
			locatorName = "ishmael",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt13_to_pnt14.gani",
			specialActionName = "end_of_ish0non_q_pnt13_to_pnt14",
			position = Vector3( -110.87982, 101.17467, -1682.82547 ),
			rotationY = -90,
			OnStart = function()
				s10010_sequence.StartTimer( "Timer_IshmaelToCorridor0000", 2 )
				TppEnemy.SetSneakRoute( "sol_p21_010380_0000", "rts_skull_stairway_0006" )
				TppEnemy.SetSneakRoute( "sol_p21_010380_0001", "rts_skull_stairway_0007" )
				TppEnemy.SetSneakRoute( "sol_p21_010380_0002", "rts_skull_stairway_0002" )
				TppEnemy.SetSneakRoute( "sol_p21_010380_0003", "rts_skull_stairway_0003" )
			end,
		}
		mvars.ish0non_q_pnt13_to_pnt14_Finished = true
	end

end

s10010_sequence.stairwayMessageTable = {
	Trap = {
		{	
			msg = "Enter",
			func = function( trapName, gameObjectId )
				Fox.Log( "s10010_sequence.sequences.Seq_Game_Stairway.Messages(): Trap: Enter: trapName:" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

				s10010_sequence.OnGameObjectEnterTrap( trapName, gameObjectId )	

				if	s10010_sequence.IsPlayerAndSoldierInSameTrap() and
					mvars.gameObjectIdDiscoveryingPlayer ~= GameObject.GetGameObjectId( "TppSoldier2", "sol_p21_010370_0000" ) and
					mvars.gameObjectIdDiscoveryingPlayer ~= GameObject.GetGameObjectId( "TppSoldier2", "sol_p21_010370_0001" ) then

					s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOver_Stairway" )

				else
					Fox.Log( "s10010_sequence.stairwayMessageTable.Trap: mvars.gameObjectIdDiscoveryingPlayer:" .. tostring( mvars.gameObjectIdDiscoveryingPlayer ) )
				end
			end,
			option = { isExecDemoPlaying = true },
		},
		{	
			msg = "Enter",
			sender = "trap_IshmaelRouteChange_Stairway_0000",
			func = function( trapName, gameObjectId )
				Fox.Log( "s10010_sequence.sequences.Seq_Game_Stairway.Messages(): Trap: Enter: trap_IshmaelRouteChange_Stairway_0000: gameObjectId:" .. tostring( gameObjectId ) )

				if not mvars.trap_IshmaelRouteChange_Stairway_0000_Finished then
					s10010_sequence.PushMotion{
						locatorName = "ishmael",
						motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt11_to_pnt12.gani",
						specialActionName = "end_of_ish0non_q_pnt11_to_pnt12",
						position = Vector3( -115.54205, 104.17284, -1678.01565 ),
						rotationY = 90,
					}
					mvars.trap_IshmaelRouteChange_Stairway_0000_Finished = true
				end

			end,
			option = { isExecDemoPlaying = true },
		},
		{	
			msg = "Enter",
			sender = "trap_IshmaelRouteChange_Stairway_0001",
			func = function( trapName, gameObjectId )
				Fox.Log( "s10010_sequence.sequences.Seq_Game_Stairway.Messages(): Trap: Enter: trap_IshmaelRouteChange_Stairway_0001: gameObjectId:" .. tostring( gameObjectId ) )

				if not mvars.trap_IshmaelRouteChange_Stairway_0001_Finished then
					s10010_sequence.PushMotion{
						locatorName = "ishmael",
						motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt12_to_pnt13.gani",
						specialActionName = "end_of_ish0non_q_pnt12_to_pnt13",
						position = Vector3( -106.46072, 102.17706, -1678.96771 ),
						rotationY =-82.8431,
					}
					s10010_sequence.StartTimer( "Timer_WaitIshmaelToCorridor0000", 30 )
					mvars.trap_IshmaelRouteChange_Stairway_0001_Finished = true
				end

			end,
			option = { isExecDemoPlaying = true },
		},
		{	
			msg = "Enter",
			sender = "trap_IshmaelRouteChange_Stairway_0002",
			func = function( trapName, gameObjectId )
				Fox.Log( "s10010_sequence.sequences.Seq_Game_Stairway.Messages(): Trap: Enter: trap_IshmaelRouteChange_Stairway_0001: gameObjectId:" .. tostring( gameObjectId ) )

				if not mvars.trap_IshmaelRouteChange_Stairway_0002_Finished then
					s10010_sequence.OnIshmaelToCorridor()
					mvars.trap_IshmaelRouteChange_Stairway_0002_Finished = true
				end
			end,
			option = { isExecDemoPlaying = true },
		},
		{	
			msg = "Enter",
			sender = "trap_Corridor",
			func = function( trapName, gameObjectId )
				Fox.Log( "s10010_sequence.sequences.Seq_Game_Stairway.Messages(): Trap: Enter: trap_Corridor: gameObjectId:" .. tostring( gameObjectId ) )

				if Tpp.IsPlayer( gameObjectId ) then
					mvars.playerInCorridorDemoTrap = true
				elseif gameObjectId == GameObject.GetGameObjectId( "ishmael" ) then
					mvars.ishmaelInCorridorDemoTrap = true
				end

				if mvars.playerInCorridorDemoTrap and mvars.ishmaelInCorridorDemoTrap then
					sequences.Seq_Game_Stairway.SetNextSequence( sequences.Seq_Game_Stairway )
				end
			end,
			option = { isExecDemoPlaying = true },
		},
		{	
			msg = "Exit",
			sender = "trap_Corridor",
			func = function( trapName, gameObjectId )
				Fox.Log( "s10010_sequence.sequences.Seq_Game_Stairway.Messages(): Trap: Exit: trap_Corridor: gameObjectId:" .. tostring( gameObjectId ) )

				if Tpp.IsPlayer( gameObjectId ) then
					mvars.playerInCorridorDemoTrap = false
				elseif gameObjectId == GameObject.GetGameObjectId( "ishmael" ) then
					mvars.ishmaelInCorridorDemoTrap = false
				end
			end,
			option = { isExecDemoPlaying = true },
		},
		{	
			msg = "Enter",
			sender = "trap_DoctorMonologue_0000",
			func = function( trapName, gameObjectId )
				Fox.Log( "s10010_sequence.sequences.Seq_Game_Stairway.Messages(): Trap: Enter: trap_DoctorMonologue_0000: gameObjectId:" .. tostring( gameObjectId ) )

				if not mvars.doctorMonologue0000_Finished then
					s10010_sequence.PushMotion{
						locatorName = "dct_p21_010410_0000",
						motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_guilty_a_come_2.gani",
						specialActionName = "end_of_dct0_guilty_a_come_2",
						position = Vector3( -102.245049, 102.175000, -1675.197266 ),
						rotationY = 175.2128,
						again = true,
						override = true,
						idle = true,
					}
					mvars.doctorMonologue0000_Finished = true
				end
			end,
			option = { isExecDemoPlaying = true },
		},
	},
	Timer = {
		{
			msg = "Finish",
			sender = "Timer_IshmaelMonologue0011",
			func = function()
				Fox.Log( "s10010_sequence.sequences.Seq_Game_Stairway.Messages(): Timer: Finish: Timer_IshmaelMonologue0011" )
				GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_010", } )
			end,
			option = { isExecDemoPlaying = true },
		},
		{
			msg = "Finish",
			sender = "Timer_IshmaelToCorridor0000",
			func = function()
				Fox.Log( "s10010_sequence.sequences.Seq_Game_Stairway.Messages(): Timer: Finish: Timer_IshmaelToCorridor0000" )
				s10010_sequence.PushMotion{
					locatorName = "dct_p21_010410_0000",
					motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_guilty_a_come_1.gani",
					specialActionName = "end_of_dct0_guilty_a_come_1",
					position = Vector3( -102.245049, 102.175000, -1675.197266 ),
					rotationY = 175.2128,
					again = true,
					override = true,
					idle = true,
				}
			end,
			option = { isExecDemoPlaying = true },
		},
		{
			msg = "Finish",
			sender = "Timer_WaitIshmaelToCorridor0000",
			func = function()
				Fox.Log( "s10010_sequence.sequences.Seq_Game_Stairway.Messages(): Timer: Finish: Timer_IshmaelToCorridor0000" )
				s10010_sequence.OnIshmaelToCorridor()
			end,
			option = { isExecDemoPlaying = true },
		},
	},
	Demo = {
		{
			msg = "Skip",
			sender = "p21_010380",
			func = function()
				Fox.Log( "s10010_sequence.stairwayMessageTable: Demo: Skip: p21_010380" )
				s10010_sequence.PushMotion{
					locatorName = "ptn_p21_010380_0000",
					motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_entra_b_ded_p.gani",
					specialActionName = "end_of_ptn0_entra_b_ded_p",
					position = Vector3( -112.000, 94.175, -1677.326 ),
				}
			end,
			option = { isExecDemoPlaying = true },
		},
	},
}

sequences.Seq_Game_Load5 = s10010_sequence.MakeLoadSequenceTable( nil, "Seq_Demo_Corridor0", 5, "Seq_Game_Stairway", "CHK_Stairway", nil, s10010_sequence.stairwayMessageTable )

sequences.Seq_Game_Stairway = {

	Messages = function( self )
		return
		StrCode32Table( s10010_sequence.stairwayMessageTable )
	end,

	nextSequenceName = "Seq_Demo_Corridor0",

	OnEnter = function( self )

		if s10010_sequence.IsDemoSequenceReserved( self.nextSequenceName ) then
			self.SetNextSequence( self )
		end

		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Stairway_0015" ), GameObject.GetGameObjectId( "TppSoldier2", "sol_p21_010380_0000" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Stairway_0015" ), GameObject.GetGameObjectId( "TppSoldier2", "sol_p21_010380_0001" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Stairway_0000" ), GameObject.GetGameObjectId( "TppSoldier2", "sol_p21_010380_0002" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Stairway_0000" ), GameObject.GetGameObjectId( "TppSoldier2", "sol_p21_010380_0003" ) )

		s10010_sequence.StartTimer( "Timer_IshmaelMonologue0011", 1 )

	end,

	SetNextSequence = function( self )
		TppSequence.SetNextSequence( self.nextSequenceName )
	end,

	OnContinue = function( self )

		Fox.Log( "sequences.Seq_Game_Stairway().OnContinue()" )

		
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Stairway_0012" ), GameObject.GetGameObjectId( "TppPlayer2", "Player" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Stairway_0019" ), GameObject.GetGameObjectId( "TppPlayer2", "Player" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Stairway_0021" ), GameObject.GetGameObjectId( "TppPlayer2", "Player" ) )

		s10010_sequence.PushMotion{
			locatorName = "ptn_p21_010380_0000",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_entra_b_ded_p.gani",
			specialActionName = "end_of_ptn0_entra_b_ded_p",
			position = Vector3( -112.000, 94.175, -1677.326 ),
		}
	end,

}

sequences.Seq_Game_GameOver_Stairway = s10010_sequence.MakeGameOverSequenceTable( { "sol_p21_010380_0000", "sol_p21_010380_0001", "sol_p21_010380_0002", "sol_p21_010380_0003" } )





s10010_sequence.OnUpdateCorridor = function( self )







	if Player.RequestToFixCameraFocalLength ~= nil then
		Player.RequestToFixCameraFocalLength(21)
	end
end

sequences.Seq_Demo_Corridor0 = {

	OnEnter = function()
		Fox.Log( "sequences.Seq_Demo_Corridor0.OnEnter()" )
		s10010_sequence.SetPadMaskCorridor( true )
		s10010_demo.PlayCorridor0Demo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_Corridor1" ) end, } )
		Player.SetAroundCameraMaxDistanceForAlphaExamination( 0.1 )

		
		TppEffectUtility.SetFxCutLevelMaximum( 0 )

	end,

	OnUpdate = s10010_sequence.OnUpdateCorridor,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Demo_Corridor0.OnLeave()" )
	end,

}

sequences.Seq_Game_Corridor1 = {

	Messages = s10010_sequence.MakeStickObservatioinSequenceMessage,

	uncommonMessageTable = {
		Timer = {
			{
				msg = "Finish",
				sender = "Timer_Guide",
				func = function()
					TppUI.ShowControlGuide{
						actionName = "PLAY_MOVE",
						continue = false,
					}
				end,
			},
		},
	},

	OnEnter = s10010_sequence.OnEnterStickObservationSequence,

	OnEnterUncommon = function( self )
		s10010_sequence.StartTimer( "Timer_Guide", 8 )
	end,

	OnUpdate = s10010_sequence.OnUpdateStickObservationSequence,

	OnUpdateUncommon = s10010_sequence.OnUpdateCorridor,

	OnLeftStickDown = function( self, leftStickX, leftStickY )

		Fox.Log( "s10010_sequence.sequences.Seq_Game_Corridor1.OnLeftStickDown(): leftStickX:" .. tostring( leftStickX ) .. ", leftStickY:" .. tostring( leftStickY ) )
		TppSequence.SetNextSequence( "Seq_Demo_Corridor1" )

	end,

	OnLeave = s10010_sequence.OnLeaveStickObservationSequence,

}




s10010_sequence.MakeCorridorSequence = function( PlayDemo, sequenceDemoId, demoInterruptionMessage, nextDemoId, nextSequenceName )

	return {

		Messages = s10010_sequence.MakeStickObservatioinSequenceMessage,

		uncommonMessageTable = {
			Demo = {
				{	
					msg = demoInterruptionMessage,
					sender = sequenceDemoId,
					func = function( demoId )
						Fox.Log( "s10010_sequence.MakeCorridorSequence(): Message Received:" .. tostring( demoInterruptionMessage ) )
						if demoId == StrCode32( sequenceDemoId ) then
							mvars.canSkip = true
						end
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "FinishMotion",
					sender = sequenceDemoId,
					func = function( demoId )
						Fox.Log( "s10010_sequence.MakeCorridorSequence(): Message Received: FinishMotion" )
						if demoId == StrCode32( sequenceDemoId ) then
							mvars.canSkip = true
						end
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		},

		OnEnter = s10010_sequence.OnEnterStickObservationSequence,

		OnEnterUncommon = function( self )

			Fox.Log( "s10010_sequence.MakeCorridorSequence(): OnEnterUncommon()" )

			mvars.canSkip = false	
			Player.RequestToSetTargetStance( PlayerStance.STAND )		
			PlayDemo()

		end,

		OnUpdate = s10010_sequence.OnUpdateStickObservationSequence,

		OnUpdateUncommon = s10010_sequence.OnUpdateCorridor,

		OnLeftStickDown = function( self, leftStickX, leftStickY )

			
			if mvars.canSkip then
				if DemoDaemon.IsPlayingDemoId( sequenceDemoId ) then
					DemoDaemon.SkipAtDemoPlay( sequenceDemoId, nextDemoId )
				end
				TppSequence.SetNextSequence( nextSequenceName )
			end

		end,

		OnLeave = s10010_sequence.OnLeaveStickObservationSequence,

		OnLeaveUncommon = function( self )
			mvars.canSkip = false
		end

	}

end

sequences.Seq_Demo_Corridor1 = s10010_sequence.MakeCorridorSequence( s10010_demo.PlayCorridor1Demo, "p21_010410_001", "p21_010410_001_Interruption", "p21_010410_002", "Seq_Demo_Corridor2" )

sequences.Seq_Game_Corridor2 = {

	Messages = s10010_sequence.MakeStickObservatioinSequenceMessage,

	OnEnter = s10010_sequence.OnEnterStickObservationSequence,

	OnUpdate = s10010_sequence.OnUpdateStickObservationSequence,

	OnUpdateUncommon = s10010_sequence.OnUpdateCorridor,

	OnLeftStickDown = function( self, leftStickX, leftStickY )

		Fox.Log( "s10010_sequence.sequences.Seq_Game_Corridor2.OnLeftStickDown(): leftStickX:" .. tostring( leftStickX ) .. ", leftStickY:" .. tostring( leftStickY ) )
		TppSequence.SetNextSequence( "Seq_Demo_Corridor2" )

	end,

	OnLeave = s10010_sequence.OnLeaveStickObservationSequence,

}

sequences.Seq_Demo_Corridor2 = s10010_sequence.MakeCorridorSequence( s10010_demo.PlayCorridor2Demo, "p21_010410_002", "p21_010410_002_Interruption", "p21_010410_003", "Seq_Demo_Corridor3" )

sequences.Seq_Game_Corridor3 = {

	Messages = s10010_sequence.MakeStickObservatioinSequenceMessage,

	OnEnter = s10010_sequence.OnEnterStickObservationSequence,

	OnUpdate = s10010_sequence.OnUpdateStickObservationSequence,

	OnUpdateUncommon = s10010_sequence.OnUpdateCorridor,

	OnLeftStickDown = function( self, leftStickX, leftStickY )

		Fox.Log( "s10010_sequence.sequences.Seq_Game_Corridor3.OnLeftStickDown(): leftStickX:" .. tostring( leftStickX ) .. ", leftStickY:" .. tostring( leftStickY ) )
		TppSequence.SetNextSequence( "Seq_Demo_Corridor3" )

	end,

	OnLeave = s10010_sequence.OnLeaveStickObservationSequence,

}

sequences.Seq_Demo_Corridor3 = s10010_sequence.MakeCorridorSequence( s10010_demo.PlayCorridor3Demo, "p21_010410_003", "p21_010410_003_Interruption", "p21_010410_004", "Seq_Demo_Corridor4" )

sequences.Seq_Game_Corridor4 = {

	Messages = s10010_sequence.MakeStickObservatioinSequenceMessage,

	OnEnter = s10010_sequence.OnEnterStickObservationSequence,

	OnUpdate = s10010_sequence.OnUpdateStickObservationSequence,

	OnUpdateUncommon = s10010_sequence.OnUpdateCorridor,

	OnLeftStickDown = function( self, leftStickX, leftStickY )

		Fox.Log( "s10010_sequence.sequences.Seq_Game_Corridor4.OnLeftStickDown(): leftStickX:" .. tostring( leftStickX ) .. ", leftStickY:" .. tostring( leftStickY ) )
		TppSequence.SetNextSequence( "Seq_Demo_Corridor4" )

	end,

	OnLeave = s10010_sequence.OnLeaveStickObservationSequence,

}

sequences.Seq_Demo_Corridor4 = s10010_sequence.MakeCorridorSequence( s10010_demo.PlayCorridor4Demo, "p21_010410_004", "p21_010410_004_Interruption", "p21_010410_005", "Seq_Demo_Corridor5" )

sequences.Seq_Game_Corridor5 = {

	Messages = s10010_sequence.MakeStickObservatioinSequenceMessage,

	OnEnter = s10010_sequence.OnEnterStickObservationSequence,

	OnUpdate = s10010_sequence.OnUpdateStickObservationSequence,

	OnUpdateUncommon = s10010_sequence.OnUpdateCorridor,

	OnLeftStickDown = function( self, leftStickX, leftStickY )

		Fox.Log( "s10010_sequence.sequences.Seq_Game_Corridor5.OnLeftStickDown(): leftStickX:" .. tostring( leftStickX ) .. ", leftStickY:" .. tostring( leftStickY ) )
		TppSequence.SetNextSequence( "Seq_Demo_Corridor5" )

	end,

	OnLeave = s10010_sequence.OnLeaveStickObservationSequence,

}

sequences.Seq_Demo_Corridor5 = s10010_sequence.MakeCorridorSequence( s10010_demo.PlayCorridor5Demo, "p21_010410_005", "p21_010410_005_Interruption", "p21_010410_006", "Seq_Demo_Corridor6" )

sequences.Seq_Game_Corridor6 = {

	OnEnter = function()
		TppSequence.SetNextSequence( "Seq_Demo_Corridor6" )
	end,

}

sequences.Seq_Demo_Corridor6 = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_Corridor6.OnEnter()" )

		s10010_demo.PlayCorridor6Demo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Demo_Corridor7" ) end, } )

		s10010_sequence.SetPadMaskCorridor( true )	

		local gameObjectId = GameObject.GetGameObjectId( "ishmael" )
		local result, targetId = Gimmick.GetGameObjectId( TppGameObject.GAME_OBJECT_TYPE_DOOR, "cypr_crtn001_vrtn015_gim_n0001|srt_cypr_crtn001_vrtn015", "/Assets/tpp/level/location/cypr/block_small/02/cypr_02_asset.fox2" )
		GameObject.SendCommand( gameObjectId, { id = "SetTargetId", targetId = targetId, curtain = true, } )

	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Demo_Corridor6.OnLeave()" )
		Player.UnsetAroundCameraMaxDistanceForAlphaExamination()

		
		TppEffectUtility.ClearFxCutLevelMaximum()
	end,

}

sequences.Seq_Demo_Corridor7 = {

	Messages = function( self )
		return
		StrCode32Table {
			Timer = {
				{	
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0013",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Demo_Corridor7.Messages(): Timer: Finish: Timer_IshmaelMonologue0013" )
						
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			nil
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_Corridor7.OnEnter()" )
		s10010_demo.PlayCorridor7Demo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_Load6" ) end, } )
		s10010_sequence.StartTimer( "Timer_IshmaelMonologue0013", 6 )

	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Demo_Corridor7.OnLeave()" )
		GkEventTimerManager.Stop( "Timer_IshmaelMonologue0013" )
		s10010_sequence.SetPadMaskCorridor( false )

		local gameObjectId = GameObject.GetGameObjectId( "ishmael" )
		GameObject.SendCommand( gameObjectId, { id = "SetTargetId", } )
	end,

}

sequences.Seq_Game_Load6 = s10010_sequence.MakeLoadSequenceTable( "trap_CurtainRoom", "Seq_Demo_CurtainRoom", 6, "Seq_Game_CurtainRoom", "CHK_CurtainRoom" )

sequences.Seq_Game_CurtainRoom = {

	enemyList = {
		"sol_p21_010420_0000",
		"sol_p21_010420_0001",
	},

	deadMotionTable = {
		{
			locatorName = "ptn_p21_010420_0000",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_01_ded.gani",
			specialActionName = "end_of_ptn0_cutn_01_ded",
		},
		{
			locatorName = "ptn_p21_010420_0001",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_02_ded.gani",
			specialActionName = "end_of_ptn0_cutn_02_ded",
		},
		{
			locatorName = "ptn_p21_010420_0002",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_03_ded.gani",
			specialActionName = "end_of_ptn0_cutn_03_ded",
		},
		{
			locatorName = "ptn_p21_010420_0003",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_01_ded.gani",
			specialActionName = "end_of_ptn0_cutn_01_ded",
		},
	},

	GetMotionTable = function( gameObjectId )
		Fox.Log( "sequences.Seq_Game_CurtainRoom.GetMotionTable(): gameObjectId:" .. tostring( gameObjectId ) )
		for i, motionTable in ipairs( sequences.Seq_Game_CurtainRoom.deadMotionTable ) do
			if gameObjectId == GameObject.GetGameObjectId( motionTable.locatorName ) then
				return motionTable
			end
		end
	end,

	Messages = function( self )
		return
		StrCode32Table {
			Trap = {
				{	
					msg = "Enter",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_CurtainRoom.Messages(): Trap: Enter: trapName:" .. tostring( trapName ) ..
							", gameObjectId:" .. tostring( gameObjectId ) )

						s10010_sequence.OnGameObjectEnterTrap( trapName, gameObjectId )	

						if s10010_sequence.IsPlayerAndSoldierInSameTrap() then
							GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_p21_010420_0000" ), { id = "SpecialAction", isDisable = true, } )
							s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOverCurtainRoom" )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelMonologue_0000",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_CurtainRoom.Messages(): Trap: Enter: trap_IshmaelMonologue_0000" )
						if not mvars.ISHISHM_055_Finished then
							GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_055", } )
							mvars.ISHISHM_055_Finished = true
						end
					end,
				},
			},
			GameObject = {
				{
					msg = "Damage",
					func = function( gameObjectId )

						Fox.Log( "s10010_sequence.sequences.Seq_Game_CurtainRoom.Messages(): GameObject: Damage: gameObjectId:" .. tostring( gameObjectId ) )

						if not mvars.patientDead[ gameObjectId ] then
							local motionTable = self.GetMotionTable( gameObjectId )
							if motionTable then
								s10010_sequence.PushMotion{
									locatorName = motionTable.locatorName,
									motionPath = motionTable.motionPath,
									specialActionName = motionTable.specialActionName,
									idle = true,
									again = true,
								}
							end
							mvars.patientDead[ gameObjectId ] = true
						end

					end,
				},
			},
			nil
		}
	end,

	nextSequenceName = "Seq_Demo_CurtainRoom",

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_CurtainRoom.OnEnter()" )

		
		

		





		for i, enemyName in ipairs( self.enemyList ) do
			s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_CurtainRoom_0000" ), GameObject.GetGameObjectId ( enemyName ) )
			s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_CurtainRoom_0009" ), GameObject.GetGameObjectId ( enemyName ) )
		end

		TppEnemy.SetSneakRoute( "sol_p21_010420_0000", "rts_skull_curtain_0014", 0 )
		TppEnemy.SetSneakRoute( "sol_p21_010420_0001", "rts_skull_curtain_0010", 0 )

		mvars.patientDead = {}

		mvars.curtainRoomEnabled = false	

	end,

	SetNextSequence = function( self )
		TppSequence.SetNextSequence( self.nextSequenceName )
	end,

	OnContinue = function( self )
		Fox.Log( "sequences.Seq_Game_CurtainRoom.OnContinue()" )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_CurtainRoom_0008" ), GameObject.GetGameObjectId( "Player" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_DemoCurtain_0003" ), GameObject.GetGameObjectId( "Player" ) )
	end,

	OnUpdate = function( self )
		if mvars.curtainRoomEnabled and ( not PlayerStatus.CURTAIN or not PlayerInfo.OrCheckStatus{ PlayerStatus.CURTAIN, } ) then
			TppSequence.SetNextSequence( "Seq_Demo_CurtainRoom" )
		end
	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Game_CurtainRoom.OnLeave()" )
		mvars.patientDead = nil
	end,

}

sequences.Seq_Game_GameOverCurtainRoom = s10010_sequence.MakeGameOverSequenceTable( sequences.Seq_Game_CurtainRoom.enemyList )

sequences.Seq_Demo_CurtainRoom = {

	warpPointTable = {
		trap_DemoCurtain_0000 = "warp_CurtainRoomDemo_0000",
		trap_DemoCurtain_0001 = "warp_CurtainRoomDemo_0001",
		trap_DemoCurtain_0002 = "warp_CurtainRoomDemo_0002",
		trap_DemoCurtain_0003 = "warp_CurtainRoomDemo_0003",
		
	},

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{	
					msg = "PlayInit",
					func = function( demoId )
						Fox.Log( "s10010_sequence.sequences.Seq_Demo_CurtainRoom.Messages(): Demo: PlayInit: demoId:" .. tostring( demoId ) )

						local playerGameObjectId = GameObject.GetGameObjectId( "Player" )
						for trapName, warpPointName in pairs( self.warpPointTable ) do
							if s10010_sequence.IsGameObjectInTrap( playerGameObjectId, StrCode32( trapName ) ) then
								mvars.targetWarpPointName = warpPointName
								break
							end
						end
						if mvars.targetWarpPointName then
							Fox.Log( "s10010_sequence.sequences.Seq_Demo_CurtainRoom.Messages(): PlayInit: Play: TppDemoUtility.AddSubjectMapping" )

							TppDemoUtility.AddSubjectMapping( "Player", "" )
						end
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "Playing",
					func = function( demoId )
						Fox.Log( "s10010_sequence.sequences.Seq_Demo_CurtainRoom.Messages(): Demo: Play: demoId:" .. tostring( demoId ) )

						
						local position, rotationY = Tpp.GetLocator( "CheckPointIdentifier", "warp_outerCurtainRoom" )
						rotationY = TppMath.DegreeToRadian( rotationY )
						GameObject.SendCommand( GameObject.GetGameObjectId( "TppPlayer2", "Player" ), { id = "Warp", pos = position, rotY = rotationY } )

						
						Player.RequestToSetTargetStance( PlayerStance.CRAWL )

						
						vars.playerDisableActionFlag = vars.playerDisableActionFlag + PlayerDisableAction.BEHIND
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "p21_010420_playercrawling",
					func = function( demoId )
						Fox.Log( "s10010_sequence.sequences.Seq_Demo_CurtainRoom.Messages(): Demo: p21_010420_playercrawling" )

						if mvars.targetWarpPointName then
							local position, rotationY = Tpp.GetLocator( "CheckPointIdentifier", mvars.targetWarpPointName )
							rotationY = TppMath.DegreeToRadian( rotationY )
							GameObject.SendCommand( GameObject.GetGameObjectId( "TppPlayer2", "Player" ), { id = "Warp", pos = position, rotY = rotationY } )
						end
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "FinishMotion",
					func = function( demoId )
						Fox.Log( "s10010_sequence.sequences.Seq_Demo_CurtainRoom.Messages(): Demo: FinishMotion: demoId:" .. tostring( demoId ) )

						
						vars.playerDisableActionFlag = vars.playerDisableActionFlag - PlayerDisableAction.BEHIND
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "Skip",
					func = function( demoId )
						Fox.Log( "s10010_sequence.sequences.Seq_Demo_CurtainRoom.Messages(): Demo: Skip: demoId:" .. tostring( demoId ) )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			nil
		}
	end,

	OnEnter = function()

		Fox.Log( "sequences.Seq_Demo_CurtainRoom.OnEnter()" )

		s10010_demo.PlayCurtainRoomDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Demo_CurtainRoom2" ) end, } )

	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Demo_CurtainRoom.OnLeave()" )
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_p21_010420_0000" )
		if gameObjectId and gameObjectId ~= GameObject.NULL_ID then
			GameObject.SendCommand( gameObjectId, { id="SpecialAction", isDisable = true, } )
		end
	end,

}

sequences.Seq_Demo_CurtainRoom2 = {

	Messages = function( self )
		return
		StrCode32Table {
			Trap = {
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_CurtainRoom_0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Demo_CurtainRoom2.Messages(): Trap: Enter: trap_IshmaelRouteChange_CurtainRoom_0000: gameObjectId:" .. tostring( gameObjectId ) )
						mvars.reservedIshmaelMoveAfterCurtainRoom = true
						s10010_sequence.StopPlayerAndStartNearCamera( true, "ishmael" )
					end,
				},
			},
			Demo = {
				{	
					msg = "Play",
					func = function( demoId )
						Fox.Log( "s10010_sequence.sequences.Seq_Demo_CurtainRoom.Messages(): Demo: Play: demoId:" .. tostring( demoId ) )

						local playerGameObjectId = GameObject.GetGameObjectId( "Player" )
						if s10010_sequence.IsGameObjectInTrap( playerGameObjectId, StrCode32( "trap_DemoCurtain_0004" ) ) then
							local position, rotationY = Tpp.GetLocator( "CheckPointIdentifier", "warp_CurtainRoomDemo_0004" )
							local rotationYRadian = TppMath.DegreeToRadian( rotationY )
							GameObject.SendCommand( GameObject.GetGameObjectId( "TppPlayer2", "Player" ), { id = "Warp", pos = position, rotY = rotationYRadian } )

							Player.RequestToSetCameraRotation {
								rotX = 0,	
								rotY = rotationY,
								interpTime = 0.1,
							}
						end
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			nil
		}
	end,

	OnEnter = function()

		Fox.Log( "sequences.Seq_Demo_CurtainRoom2.OnEnter()" )

		s10010_demo.PlayCurtainRoomDemo2( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_AfterCurtainRoom" ) end, } )

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_CurtainRoom2.OnLeave()" )

		s10010_sequence.UpdateCheckPoint{ checkPoint = "CHK_AfterCurtainRoom", ignoreAlert = true, }

	end,

}

sequences.Seq_Game_AfterCurtainRoom = {

	Messages = s10010_sequence.MakeStickObservatioinSequenceMessage,

	OnEnter = s10010_sequence.OnEnterStickObservationSequence,

	OnUpdate = s10010_sequence.OnUpdateStickObservationSequence,

	ishmaelVoiceLabelList = {
		"ISHM_062",
		"ISHM_063",
	},

	updateTime = 1.5,

	OnStickUpdated = function( self, leftStickDown, leftStickUp, leftStickLeft, leftStickRight ,rightStickDown, rightStickUp, rightStickLeft, rightStickRight )

		Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCurtainRoom.OnLeftStickDown(): leftStickX:" .. tostring( leftStickX ) .. ", leftStickY:" .. tostring( leftStickY ) )

		if mvars.corpseCorridorStart and ( leftStickDown > 0.33 or leftStickUp > 0.33 or leftStickLeft > 0.33 or leftStickRight > 0.33 ) then
			if not mvars.ishmaelVoiceCount then
				mvars.ishmaelVoiceCount = 0
			end

			if mvars.ishmaelVoiceCount > 2 then
				s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOverCorridor" )
			elseif mvars.ishmaelVoiceCount > 0 then
				GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = self.ishmaelVoiceLabelList[ mvars.ishmaelVoiceCount % #self.ishmaelVoiceLabelList + 1 ], } )
			end
			mvars.ishmaelVoiceCount = mvars.ishmaelVoiceCount + 1
		end

	end,

	OnLeave = s10010_sequence.OnLeaveStickObservationSequence,

	enemyList = {
		"sol_p21_010440_0002",
		"sol_p21_010440_0003",
		"sol_p21_010440_0000",
		"sol_p21_010440_0001",
		"sol_p21_010420_0000",
		"sol_p21_010420_0001",
	},

	uncommonMessageTable = {
		Trap = {
			{	
				msg = "Enter",
				sender = "trap_VolginVsSkullSoldier",
				func = function()

					if not mvars.corpseCorridorStart then
						local enemyAndRouteTable = {
							sol_p21_010440_0000 = "rts_skull_corridor_0000",
							sol_p21_010440_0001 = "rts_skull_corridor_0001",
							sol_p21_010440_0002 = "rts_skull_corridor_0003",
							sol_p21_010440_0003 = "rts_skull_corridor_0002",
							sol_p21_010420_0000 = "rts_skull_curtain_0012",
							sol_p21_010420_0001 = "rts_skull_curtain_0013",
						}
						for enemyName, routeName in pairs( enemyAndRouteTable ) do
							TppEnemy.SetSneakRoute( enemyName, routeName )
						end

						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_061", } )

						mvars.corpseCorridorStart = true
					end

				end,
			},
			{	
				msg = "Enter",
				sender = "trap_IshmaelRouteChange_CurtainRoom_0000",
				func = function( trapName, gameObjectId )
					Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCurtainRoom.Messages(): Trap: Enter: trap_IshmaelRouteChange_CurtainRoom_0000: gameObjectId:" .. tostring( gameObjectId ) )

					if not mvars.corpseCorridorStart then
						if not mvars.ishmaelCorridorRouteStarted then
							s10010_sequence.StartTimer( "Timer_StartIshmael", 5 )
							GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_058", } )
							GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_027", } )
							s10010_sequence.StopPlayerAndStartNearCamera( true, "ishmael" )
							mvars.ishmaelCorridorRouteStarted = true
						end

						if not mvars.curtainSoldierStarted then
							TppEnemy.SetSneakRoute( "sol_p21_010420_0000", "rts_skull_curtain_0009" )
							TppEnemy.SetSneakRoute( "sol_p21_010420_0001", "rts_skull_curtain_0011" )

							GameObject.SendCommand( GameObject.GetGameObjectId( "sol_p21_010420_0000" ), { id = "SetGunLightSwitch", isOn = false, useCastShadow = false, } )
							GameObject.SendCommand( GameObject.GetGameObjectId( "sol_p21_010440_0000" ), { id = "SetGunLightSwitch", isOn = true, useCastShadow = true, } )

							mvars.curtainSoldierStarted = true
						end
					else
						s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOverCorridor" )
					end
				end,
			},
			{	
				msg = "Enter",
				sender = "trap_Corridor0000",
				func = function( trapName, gameObjectId )
					Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCurtainRoom.Messages(): Trap: Enter: trap_Corridor0000: gameObjectId:" .. tostring( gameObjectId ) )

					vars.playerDisableActionFlag = PlayerDisableAction.STEALTHASSIST +
						PlayerDisableAction.REFLEXMODE +
						PlayerDisableAction.CARRY +
						PlayerDisableAction.FULTON +
						PlayerDisableAction.CHANGE_STANCE_FROM_CRAWL +
						PlayerDisableAction.MARKING +
						PlayerDisableAction.RIDE_VEHICLE +
						PlayerDisableAction.BINOCLE +
						PlayerDisableAction.CQC +
						PlayerDisableAction.OPEN_EQUIP_MENU

				end,
			},
			{	
				msg = "Exit",
				sender = "trap_Corridor0000",
				func = function( trapName, gameObjectId )
					Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCurtainRoom.Messages(): Trap: Enter: trap_Corridor0000: gameObjectId:" .. tostring( gameObjectId ) )

					vars.playerDisableActionFlag = PlayerDisableAction.STEALTHASSIST +
						PlayerDisableAction.REFLEXMODE +
						PlayerDisableAction.CARRY +
						PlayerDisableAction.FULTON +
						PlayerDisableAction.MARKING +
						PlayerDisableAction.RIDE_VEHICLE +
						PlayerDisableAction.BINOCLE +
						PlayerDisableAction.CQC +
						PlayerDisableAction.OPEN_EQUIP_MENU

				end,
			},
			{	
				msg = "Enter",
				func = function( trapName, gameObjectId )
					Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCurtainRoom.Messages(): Trap: Enter: trapName:" .. tostring( trapName ) ..
						", gameObjectId:" .. tostring( gameObjectId ) )

					s10010_sequence.OnGameObjectEnterTrap( trapName, gameObjectId )	

					if s10010_sequence.IsPlayerAndSoldierInSameTrap() then
						s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOverCorridor" )
					end
				end,
			},
		},
		Timer = {
			{	
				msg = "Finish",
				sender = "Timer_StartIshmael",
				func = function()
					sequences.Seq_Game_AfterCurtainRoom.MoveIshmael( self )--RETAILBUG: self undefined
					s10010_sequence.StopPlayerAndStartNearCamera( false )
				end,
			},
			{	
				msg = "Finish",
				sender = "Timer_StartCurtainSoldiers_0000",
				func = function()
					if not mvars.curtainSoldierStarted then
						TppEnemy.SetSneakRoute( "sol_p21_010420_0000", "rts_skull_curtain_0009" )
						TppEnemy.SetSneakRoute( "sol_p21_010420_0001", "rts_skull_curtain_0011" )
						mvars.curtainSoldierStarted = true
					end
				end,
			},
		},
		nil
	},

	OnEnterUncommon = function( self )

		Fox.Log( "sequences.Seq_Game_AfterCurtainRoom.OnEnterUncommon()" )

		if mvars.reservedIshmaelMoveAfterCurtainRoom then
			if not mvars.ishmaelCorridorRouteStarted then
				s10010_sequence.StartTimer( "Timer_StartIshmael", 5 )
				GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_058", } )
				GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_027", } )
				mvars.ishmaelCorridorRouteStarted = true
			end

			if not mvars.curtainSoldierStarted then
				TppEnemy.SetSneakRoute( "sol_p21_010420_0000", "rts_skull_curtain_0009" )
				TppEnemy.SetSneakRoute( "sol_p21_010420_0001", "rts_skull_curtain_0011" )

				GameObject.SendCommand( GameObject.GetGameObjectId( "sol_p21_010420_0000" ), { id = "SetGunLightSwitch", isOn = false, useCastShadow = false, } )
				GameObject.SendCommand( GameObject.GetGameObjectId( "sol_p21_010440_0000" ), { id = "SetGunLightSwitch", isOn = true, useCastShadow = true, } )

				mvars.curtainSoldierStarted = true
			end
		end

		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Corridor_0000" ), GameObject.GetGameObjectId ( "sol_p21_010420_0000" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Corridor_0001" ), GameObject.GetGameObjectId ( "sol_p21_010420_0000" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Corridor_0002" ), GameObject.GetGameObjectId ( "sol_p21_010420_0000" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Corridor_0000" ), GameObject.GetGameObjectId ( "sol_p21_010420_0001" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Corridor_0001" ), GameObject.GetGameObjectId ( "sol_p21_010420_0001" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Corridor_0000" ), GameObject.GetGameObjectId ( "sol_p21_010440_0002" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Corridor_0000" ), GameObject.GetGameObjectId ( "sol_p21_010440_0003" ) )

		

		TppEffectUtility.SetFxCutLevelMaximum( 0 )

	end,

	OnContinue = function( self )

		Fox.Log( "sequences.Seq_Game_AfterCurtainRoom.OnContinue()" )

		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_CurtainRoom_0007" ), GameObject.GetGameObjectId ( "Player" ) )

	end,

	MoveIshmael = function( self )

		Fox.Log( "sequences.Seq_Game_AfterCurtainRoom.MoveIshmael()" )

		s10010_sequence.PushMotion{
			locatorName = "ishmael",
			action = "PlayState",
			state = "stateIshmael_q_pnt19_to_pnt20",
			motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt19_to_pnt20.gani",
			specialActionName = "end_of_ish0non_q_pnt19_to_pnt20",
			enableAim = true,
			position = Vector3( -104.9, 102.175, -1655.03 ),
			rotationY = 90,
		}
		TppUI.ShowControlGuide{
			actionName = "STANCE_CRAWL",
			continue = false,
		}

	end,

	OnLeaveUncommon = function( self )

		Fox.Log( "sequences.Seq_Game_AfterCurtainRoom.OnLeaveUncommon()" )

		s10010_sequence.SetPadMaskCorridor( true )

	end,

}

sequences.Seq_Game_GameOverCorridor = s10010_sequence.MakeGameOverSequenceTable( sequences.Seq_Game_AfterCurtainRoom.enemyList )

sequences.Seq_Demo_VolginVsSkullSoldier = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010440_iconon01",
					func = function()

						Fox.Log( "sequences.Seq_Demo_HeliKillMob.Messages(): Demo: p21_010360_iconon01" )

						TppUiCommand.ShowDemoKeyHelp()
						TppUiCommand.ActiveDemoKeyHelp( true )
						mvars.doesShowDemoKeyHelp = true
						s10010_sequence.StartTimer( "Timer_StickDownTimeOut", 5 )

					end,
				},
				{
					msg = "p21_010440_iconon02",
					func = function()

						Fox.Log( "sequences.Seq_Demo_HeliKillMob.Messages(): Demo: p21_010360_iconon01" )

						TppUiCommand.ShowDemoKeyHelp()
						TppUiCommand.ActiveDemoKeyHelp( true )
						mvars.doesShowDemoKeyHelp = true
						s10010_sequence.StartTimer( "Timer_StickDownTimeOut", 5 )

					end,
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_StickDownTimeOut",
					func = function()
						if mvars.doesShowDemoKeyHelp then
							TppUiCommand.HideDemoKeyHelp()
							mvars.doesShowDemoKeyHelp = nil
						end
					end,
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_VolginVsSkullSoldier.OnEnter()" )

		s10010_demo.PlayVolginVsSkullSoldierDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_Load7" ) end, } )
		s10010_sequence.ProhibitMove( true )

	end,

	OnUpdate = function( self )

		if mvars.doesShowDemoKeyHelp and s10010_sequence.IsAnyStickDown() then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_VolginVsSkullSoldier.OnEnter()" )

		s10010_sequence.ProhibitMove( false )
		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil
		end

		TppEffectUtility.ClearFxCutLevelMaximum()

		s10010_sequence.SetPadMaskCorridor( false )

		vars.playerDisableActionFlag = PlayerDisableAction.STEALTHASSIST +
			PlayerDisableAction.REFLEXMODE +
			PlayerDisableAction.CARRY +
			PlayerDisableAction.FULTON +
			PlayerDisableAction.MARKING +
			PlayerDisableAction.RIDE_VEHICLE +
			PlayerDisableAction.BINOCLE +
			PlayerDisableAction.CQC +
			PlayerDisableAction.OPEN_EQUIP_MENU

	end,

}

sequences.Seq_Game_Load7 = s10010_sequence.MakeLoadSequenceTable( "trap_GetGun", "Seq_Demo_GetGun", 7, "Seq_Game_AfterCorridor", "CHK_AfterCorridor" )

sequences.Seq_Game_AfterCorridor = {

	enemyList = {
		"sol_p21_010490_0000",
		"sol_p21_010490_0003",
	},

	Messages = function( self )
		return
		StrCode32Table {
			Trap = {
				{	
					msg = "Enter",
					sender = "trap_GetGun",
					func = function()
						if mvars.soldierBeforeGetGunDead then
							self.SetNextSequence( self )
						else
							mvars.reserveToPlayGetGunDemo = true
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_AfterCorridor_0000",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCorridor.Messages(): Trap: Enter: trap_IshmaelRouteChange_AfterCorridor_0000" )
						if not mvars.playerEnter[ "trap_IshmaelRouteChange_AfterCorridor_0000" ] then
							s10010_sequence.PushMotion{
								locatorName = "ishmael",
								motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt23_to_pnt24.gani",
								specialActionName = "end_of_ish0non_q_pnt23_to_pnt24",
								position = Vector3( -106.30401, 102.175, -1683.57134 ),
								rotationY = -90,
							}
							mvars.playerEnter[ "trap_IshmaelRouteChange_AfterCorridor_0000" ] = true
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_AfterCorridor_0001",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCorridor.Messages(): Trap: Enter: trap_IshmaelRouteChange_AfterCorridor_0001" )
						if not mvars.playerEnter[ "trap_IshmaelRouteChange_AfterCorridor_0001" ] then
							s10010_sequence.PushMotion{
								locatorName = "ishmael",
								motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt24_to_pnt25.gani",
								specialActionName = "end_of_ish0non_q_pnt24_to_pnt25",
								position = Vector3( -115.49928, 100.175, -1677.80852 ),
								rotationY = 90,
							}
							mvars.playerEnter[ "trap_IshmaelRouteChange_AfterCorridor_0001" ] = true
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_AfterCorridor_0002",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCorridor.Messages(): Trap: Enter: trap_IshmaelRouteChange_AfterCorridor_0002" )
						if not mvars.playerEnter[ "trap_IshmaelRouteChange_AfterCorridor_0002" ] then
							s10010_sequence.PushMotion{
								locatorName = "ishmael",
								motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt25_to_pnt26.gani",
								specialActionName = "end_of_ish0non_q_pnt25_to_pnt26",
								position = Vector3( -105.06871, 98.175, -1677.47275 ),
								rotationY = 135,
							}
							mvars.playerEnter[ "trap_IshmaelRouteChange_AfterCorridor_0002" ] = true
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_AfterCorridor_0003",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCorridor.Messages(): Trap: Enter: trap_IshmaelRouteChange_AfterCorridor_0003" )

						if Tpp.IsPlayer( gameObjectId ) then
							mvars.playerEnter[ "trap_IshmaelRouteChange_AfterCorridor_0003" ] = true
						elseif gameObjectId == GameObject.GetGameObjectId( "ishmael" ) then
							mvars.ishmaelEnter[ "trap_IshmaelRouteChange_AfterCorridor_0003" ] = true
						end

						self.OnEnter2F()

					end,
				},
				{	
					msg = "Exit",
					sender = "trap_IshmaelRouteChange_AfterCorridor_0003",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCorridor.Messages(): Trap: Exit: trap_IshmaelRouteChange_AfterCorridor_0003" )

						if Tpp.IsPlayer( gameObjectId ) then
							mvars.playerEnter[ "trap_IshmaelRouteChange_AfterCorridor_0003" ] = false
						elseif gameObjectId == GameObject.GetGameObjectId( "ishmael" ) then
							mvars.ishmaelEnter[ "trap_IshmaelRouteChange_AfterCorridor_0003" ] = false
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_AfterCorridor_0005",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCorridor.Messages(): Trap: Enter: trap_IshmaelRouteChange_AfterCorridor_0005" )
						if not mvars.playerEnter[ "trap_IshmaelRouteChange_AfterCorridor_0005" ] then
							TppEnemy.SetSneakRoute( "sol_p21_010490_0000", "rts_skull_2F_0003" )
							mvars.playerEnter[ "trap_IshmaelRouteChange_AfterCorridor_0005" ] = true
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_BgmChange_AfterCorridor_0000",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCorridor.Messages(): Trap: Enter: trap_BgmChange_AfterCorridor_0000" )
						if not mvars.bgmChangedAfter2ndVolgin then
							s10010_sequence.OnEventPlayed( "bgmChange2f" )
							s10010_sequence.OnEventFinished( "bgmChange2f" )
							mvars.bgmChangedAfter2ndVolgin = true
						end
					end,
				},
				{	
					msg = "Enter",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCorridor.Messages(): Trap: Enter: trapName:" .. tostring( trapName ) ..
							", gameObjectId:" .. tostring( gameObjectId ) )

						s10010_sequence.OnGameObjectEnterTrap( trapName, gameObjectId )	

						if s10010_sequence.IsPlayerAndSoldierInSameTrap() then
							s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOverAfterCorridor" )
						end
					end,
				},
			},
			Player = {
				{	
					msg = "PlayerCureStart",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCorridor.Messages(): Player: PlayerCureStart" )
						s10010_sequence.OnEventPlayed( "cureGame" )
					end,
				},
				{	
					msg = "PlayerCureComplete",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCorridor.Messages(): Player: PlayerCureComplete" )
						s10010_sequence.ExecSubEvent( "cureGame", "cureSuccess", true, false )
					end,
				},
				{	
					msg = "PlayerCureCompleteMotEnd",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_AfterCorridor.Messages(): Player: PlayerCureCompleteMotEnd" )
						s10010_sequence.OnEventFinished( "cureGame" )
						mvars.cureFinished = true
						self.OnEnter2F()
						s10010_sequence.StartTimer( "Timer_Open3fDoor", 6 )
					end,
				},
			},
			GameObject = {
				{
					msg = "Dead",
					func = function( gameObjectId )
						if gameObjectId ~= GameObject.GetGameObjectId( "sol_p21_010490_0000" ) then
							return
						end

						if mvars.reserveToPlayGetGunDemo then
							self.SetNextSequence( self )
						else
							mvars.soldierBeforeGetGunDead = true
						end
						s10010_sequence.OnEventPlayed( "enemy2fDown" )
						s10010_sequence.OnEventFinished( "enemy2fDown" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "SetTargetId", } )
						TppPickable.ClearAllDroppedInstance()
					end,
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_Close2fDoor",
					func = function()
						s10010_sequence.OnEventPlayed( "close2fDoor" )
						s10010_sequence.OnEventFinished( "close2fDoor" )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Open3fDoor",
					func = function()
						s10010_sequence.OnEventPlayed( "open3fDoor" )
						s10010_sequence.OnEventFinished( "open3fDoor" )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0008",
					func = function()
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_067", } )
					end,
				},
			},
			TppSystem = {
				{
					msg = "NotifyCyprusTargetHit",
					func = function( targetName )

						Fox.Log( "s10010_sequence.sequences.Seq_Game_EscapeFromEntrance.Messages(): TppSystem: NotifyCyprusTargetHit" )

						if targetName == StrCode32( "offenceTarget_3f_0000" ) or targetName == StrCode32( "offenceTarget_1f_0003" ) then
							vars.playerLife = 0
						end

					end,
				},
			},
			nil
		}
	end,

	nextSequenceName = "Seq_Demo_GetGun",

	offenceTargetTable = {
		"offenceTarget_3f_0000",
		"offenceTarget_3f_0001",
		"offenceTarget_1f_0002",
		"offenceTarget_1f_0003",
	},

	OnEnter = function( self )

		if s10010_sequence.IsDemoSequenceReserved( self.nextSequenceName ) then
			self.SetNextSequence( self )
		end

		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_2F_0004" ), GameObject.GetGameObjectId ( "sol_p21_010490_0000" ) )
		s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_Stairway_0012" ), GameObject.GetGameObjectId ( "sol_p21_010490_0003" ) )

		for i, offenceTargetName in ipairs( self.offenceTargetTable ) do
			local dataBody = DataIdentifier.GetDataBodyWithIdentifier( "s10010_l01_sequence_DataIdentifier", offenceTargetName )
			local translation = dataBody.data.transform.translation
			local scale = dataBody.data.transform.scale
			CyprusMissionController.SendCommand{
				id = "RegisterOffenseTraget",
				name = offenceTargetName,
				position = translation,
				size = scale,
				rotation = Quat( 0, 0, 0, 1 ),
				type = "NormalFireWall",
			}
			CyprusMissionController.SendCommand{ id = "ActiveOffenseTraget", name = offenceTargetName, }
		end

		s10010_sequence.StartTimer( "Timer_IshmaelMonologue0008", 0.25 )

		TppUI.ShowTipsGuide{
			contentName = "INJURY_2",	
			isOnce = false,
			isOnceThisGame = false,
		}

	end,

	SetNextSequence = function( self )
		TppSequence.SetNextSequence( self.nextSequenceName )
	end,

	OnEnter2F = function()

		Fox.Log( "sequences.Seq_Game_AfterCorridor.OnEnter2F()" )

		if	not mvars.enter2fFinished and
			mvars.playerEnter[ "trap_IshmaelRouteChange_AfterCorridor_0003" ] and
			mvars.ishmaelEnter[ "trap_IshmaelRouteChange_AfterCorridor_0003" ] and
			mvars.cureFinished then

			s10010_sequence.OnEventPlayed( "enter2F" )
			mvars.enter2fFinished = true

			
			s10010_sequence.StartTimer( "Timer_Close2fDoor", 11 )

		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_AfterCorridor.OnLeave()" )

		for i, offenceTargetName in ipairs( self.offenceTargetTable ) do
			CyprusMissionController.SendCommand{ id = "InactiveOffenseTraget", name = offenceTargetName, }
			CyprusMissionController.SendCommand{ id = "UngisterOffenseTraget", name = offenceTargetName, }
		end

	end,

}

sequences.Seq_Game_GameOverAfterCorridor = s10010_sequence.MakeGameOverSequenceTable( sequences.Seq_Game_AfterCorridor.enemyList )

sequences.Seq_Demo_GetGun = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_010490_EneChange",
					func = function()
						TppPickable.ClearAllDroppedInstance()
					end,
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_GetGun.OnEnter()" )

		s10010_demo.PlayGetGunDemo(
			{
				onStart = function()
					Player.RequestToSetCameraStock{ 
						direction = "right", 
					}
				end,
				onEnd = function()
					TppSequence.SetNextSequence( "Seq_Game_Load8" )
				end,
			}
		)

		s10010_sequence.ProhibitMove( true )

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_GetGun.OnLeave()" )

		s10010_sequence.ProhibitMove( false )

		
		s10010_sequence.SetPadMaskCamera( true )

	end,

}

sequences.Seq_Game_Load8 = s10010_sequence.MakeLoadSequenceTable( "trap_Entrance", "Seq_Demo_BeforeEntrance", 8, "Seq_Game_GunTutorial", "CHK_GunTutorial" )

sequences.Seq_Game_GunTutorial = {

	enemyList = {
		"sol_p21_010490_0001",
		"sol_p21_010490_0002",
	},

	
















	fireList = {
		{
			fireEffectList = {
				"DemoOn",
			},
			needToCreateEffect = false,
			offenceTargetTable = {
				wall_0004 = {
					identifierId = "s10010_l01_sequence_DataIdentifier",
					key = "offenceTarget_2f_0004",
					type = "SmallFireWall",
					instantDeath = true,
				},
				wall_0005 = {
					identifierId = "s10010_l01_sequence_DataIdentifier",
					key = "offenceTarget_2f_0005",
					type = "NormalFireWall",
				},
				wall_0006 = {
					identifierId = "s10010_l01_sequence_DataIdentifier",
					key = "offenceTarget_2f_0006",
					type = "NormalFireWall",
				},
			},
		},
		{
			extinguisherName = "cypr_extn001_gim_n0002|srt_cypr_extn001",
			fireEffectList = {
				"FxLocatorGroup_Effect2fFire_0000",
			},
			needToCreateEffect = true,
			offenceTargetTable = {
				wall_0002 = {
					identifierId = "s10010_l01_sequence_DataIdentifier",
					key = "offenceTarget_2f_0002",
					type = "SmallFireWall",
					instantDeath = true,
				},
				wall_0003 = {
					identifierId = "s10010_l01_sequence_DataIdentifier",
					key = "offenceTarget_2f_0003",
					type = "NormalFireWall",
				},
			},
			timerTable = {
				timerName = "Timer_2fFire0000",
				timerCount = 1,
			},
		},
		{
			
			fireEffectList = {
				"cyprus_2F_fire_0000",
			},
			needToCreateEffect = true,
			offenceTargetTable = {
				wall_0007 = {
					identifierId = "s10010_l01_sequence_DataIdentifier",
					key = "offenceTarget_2f_0007",
					type = "NormalFireWall",
				},
				wall_0008 = {
					identifierId = "s10010_l01_sequence_DataIdentifier",
					key = "offenceTarget_2f_0008",
					type = "NormalFireWall",
				},
				wall_0009 = {
					identifierId = "s10010_l01_sequence_DataIdentifier",
					key = "offenceTarget_2f_0009",
					type = "NormalFireWall",
				},
			},
			timerTable = {
				timerName = "Timer_2fFire0001",
				timerCount = 4,
			},
		},
		{
			extinguisherName = "cypr_extn001_gim_n0002|srt_cypr_extn001",
			fireEffectList = {
				"2F_fire_ext",
			},
			needToCreateEffect = true,
			offenceTargetTable = {
				wall_0000 = {
					identifierId = "s10010_l01_sequence_DataIdentifier",
					key = "offenceTarget_2f_0000",
					type = "SmallFireWall",
					instantDeath = true,
				},
				wall_0001 = {
					identifierId = "s10010_l01_sequence_DataIdentifier",
					key = "offenceTarget_2f_0001",
					type = "NormalFireWall",
				},
			},
			timerTable = {
				timerName = "Timer_2fFire0001",
				timerCount = 4,
			},
		},
	},

	Messages = function( self )
		return
		StrCode32Table {
			Trap = {
				{	
					msg = "Enter",
					sender = "trap_Entrance",
					func = function()
						self.SetNextSequence( self )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_AfterGetGun_0000",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Trap: Enter: trap_IshmaelRouteChange_AfterGetGun_0000" )
						self.MoveIshmael()
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_AfterGetGun_0001",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Trap: Enter: trap_IshmaelRouteChange_AfterGetGun_0001" )
						if not mvars.trap_IshmaelRouteChange_AfterGetGun_0001_Finished then

							s10010_sequence.OnEventPlayed( "twoEnemyAppear" )
							s10010_sequence.OnEventFinished( "twoEnemyAppear" )

							mvars.trap_IshmaelRouteChange_AfterGetGun_0001_Finished = true
							s10010_sequence.StartTimer( "Timer_IshmaelFire0000", 60 )

							
							GameObject.SendCommand( GameObject.GetGameObjectId("TppSoldier2", "sol_p21_010490_0001" ), { id="SetCommandAi", commandType = CommandAi.SHOOT_PRACTICE, commandIndex = 0, } )
							GameObject.SendCommand( GameObject.GetGameObjectId("TppSoldier2", "sol_p21_010490_0002" ), { id="SetCommandAi", commandType = CommandAi.SHOOT_PRACTICE, commandIndex = 1, } )
							s10010_sequence.StartTimer( "Timer_EnemyForward", 30 )

							s10010_sequence.StartTimer( "Timer_IshmaelMonologue0012", 20 )

						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_CameraChangeTutorial_0000",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Trap: Enter: trap_CameraChangeTutorial_0000" )
						if not mvars.enemiesAfterGetGunKilled then






						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_AfterGetGun_0002",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Trap: Enter: trap_IshmaelRouteChange_AfterGetGun_0002" )
						if mvars.enemiesAfterGetGunKilled then
							s10010_sequence.PushMotion{
								locatorName = "ishmael",
								actioin = "PlayState",
								state = "stateIshmael_q_pnt32_to_pnt33",
								motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt32_to_pnt33.gani",
								specialActionName = "end_of_ish0non_q_pnt32_to_pnt33",
								enableAim = true,
								position = Vector3( -84.57645, 98.175, -1717.36061 ),
								rotationY = 90,
							}
							s10010_sequence.OnEventPlayed( "toEntrance" )
							s10010_sequence.OnEventFinished( "toEntrance" )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelRouteChange_AfterGetGun_0003",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Trap: Enter: trap_IshmaelRouteChange_AfterGetGun_0003" )
						if not mvars.trap_IshmaelRouteChange_AfterGetGun_0003_Finished then
							s10010_sequence.PushMotion{
								locatorName = "ishmael",
								action = "PlayState",
								state = "stateIshmael_q_pnt33_to_pnt34",
								motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt33_to_pnt34.gani",
								specialActionName = "end_of_ish0non_q_pnt33_to_pnt34",
								enableAim = true,
								position = Vector3( -78.54692, 98.175, -1722.10939 ),
								rotationY = 142.6893,
							}
							mvars.trap_IshmaelRouteChange_AfterGetGun_0003_Finished = true
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_StopPlayer_0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Trap: Enter: trapName: trap_StopPlayer_0000" )
						if mvars.playerStop2f0000 then
							s10010_sequence.StopPlayerAndStartNearCamera( true, "ishmael" )
							s10010_sequence.StartTimer( "Timer_StartPlayer0000", 6 )
							s10010_sequence.CallRestraintMonologue()
							
							s10010_sequence.SetModelVisibility( { identifier = "cypr_s03_other_DataIdentifier", key = "cypr_door001_door002_close_geom_0000", visible = true, }, true, false )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelMonologue0003",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Trap: Enter: trapName: trap_IshmaelMonologue0003" )
						if not mvars.ISHM_075Finished then
							GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_075", } )
							mvars.ISHM_075Finished = true
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_IshmaelMonologue0004",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Trap: Enter: trapName: trap_IshmaelMonologue0004" )
						if not mvars.ISHM_076Finished then
							GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_076", } )
							mvars.ISHM_076Finished = true
						end
					end,
				},
				{	
					msg = "Enter",
					func = function( trapName, gameObjectId )
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Trap: Enter: trapName:" .. tostring( trapName ) ..
							", gameObjectId:" .. tostring( gameObjectId ) )

						s10010_sequence.OnGameObjectEnterTrap( trapName, gameObjectId )	

						if s10010_sequence.IsPlayerAndSoldierInSameTrap() then
							s10010_sequence.SetNextGameOverSequence( "Seq_Game_GameOverGunTutorial" )
						end
					end,
				},
			},
			GameObject = {
				{	
					msg = "Dead",
					func = function( gameObjectId, offenceGameObjectId )

						if gameObjectId ~= GameObject.GetGameObjectId( "sol_p21_010490_0001" ) and gameObjectId ~= GameObject.GetGameObjectId( "sol_p21_010490_0002" ) then
							return
						end

						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): GameObject: Dead: gameObjectId:" .. tostring( gameObjectId ) )

						local alive = false
						for i, enemyName in ipairs( self.enemyList ) do
							local lifeState = GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", enemyName ), { id = "GetLifeStatus" } )
							if lifeState ~= TppGameObject.NPC_LIFE_STATE_DEAD then
								alive = true
							end
						end

						if not alive then	
							if offenceGameObjectId == GameObject.GetGameObjectId( "Player" ) then
								s10010_sequence.StartTimer( "Timer_WaitEnemyDownMonologue", 1 )
							end
							s10010_sequence.StartTimer( "Timer_WaitEnemyDown", 1 )
							mvars.enemiesAfterGetGunKilled = true
							mvars.ISHM_075Finished = true
							mvars.ISHM_076Finished = true
							GkEventTimerManager.Stop( "Timer_IshmaelMonologue0012" )

							s10010_sequence.PushMotionOnSubEvent( {
								locatorName = "ishmael",
								motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt31_to_pnt32.gani",
								specialActionName = "end_of_ish0non_q_pnt31_to_pnt32",
								override = true,
								position = Vector3( -97.88792, 98.175, -1718.32215 ),
								rotationY = 90,
							}, true, false )
						else	
							if offenceGameObjectId == GameObject.GetGameObjectId( "Player" ) then
								GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_073", } )
							end
						end

					end
				},
				{	
					msg = "BreakGimmick",
					func = function( gameObjectId, locatorName, upperLocatorName )

						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): GameObject: BreakGimmick: gameObjectId:" ..
							tostring( gameObjectId ) .. ", locatorName:" .. tostring( locatorName ) .. ", upperLocatorName:" .. tostring( upperLocatorName ) )

						for i, fireTable in ipairs( self.fireList ) do
							if fireTable and StrCode32( fireTable.extinguisherName ) == locatorName then
								
								if Tpp.IsTypeTable( fireTable.fireEffectList ) then
									for j, fireEffectName in ipairs( fireTable.fireEffectList ) do
										s10010_sequence.DestroyEffect( { effectName = fireEffectName, }, true, false )
									end
									local position, rotationY = Tpp.GetLocator( "s10010_l01_sequence_DataIdentifier", "extinguisher" )
									TppSoundDaemon.PostEvent3D( "sfx_m_cypr_2F_fire_off", Vector3( position[ 1 ], position[ 2 ], position[ 3 ] ) )
								end
								
								if Tpp.IsTypeTable( fireTable.offenceTargetTable ) then
									for offenceTargetName, offenceTargetTable in pairs( fireTable.offenceTargetTable ) do
										CyprusMissionController.SendCommand{ id = "InactiveOffenseTraget", name = offenceTargetName, }
										CyprusMissionController.SendCommand{ id = "UngisterOffenseTraget", name = offenceTargetName, }
									end
								end
								
								if Tpp.IsTypeFunc( fireTable.OnVanish ) then
									fireTable.OnVanish( self )
								end
								
								if Tpp.IsTypeTable( fireTable.timerTable ) then
									if fireTable.timerTable.timerName and GkEventTimerManager.IsTimerActive( fireTable.timerTable.timerName ) then
										GkEventTimerManager.Stop( fireTable.timerTable.timerName )
									end
								end
							end
						end

						
						if locatorName == StrCode32( "cypr_extn001_gim_n0002|srt_cypr_extn001" ) then
							TppMarker.Disable( "marker_extinguisher" )
						end

					end,
				},
			},
			TppSystem = {
				{
					msg = "NotifyCyprusTargetHit",
					func = function( targetName )

						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): TppSystem: NotifyCyprusTargetHit: targetName:" .. tostring( targetName ) )

						for i, fireTable in ipairs( self.fireList ) do
							if Tpp.IsTypeTable( fireTable.offenceTargetTable ) then
								for offenceTargetName, offenceTargetTable in pairs( fireTable.offenceTargetTable ) do
									if StrCode32( offenceTargetName ) == targetName and offenceTargetTable.instantDeath then
										vars.playerLife = 1
									end
								end
							end
						end

					end,
				},
			},
			Timer = {
				{
					msg = "Finish",
					func = function( timerName )

						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Timer: Finish: timerName:" .. tostring( timerName ) )

						for i, fireTable in ipairs( self.fireList )do
							if Tpp.IsTypeTable( fireTable.timerTable ) and StrCode32( fireTable.timerTable.timerName ) == timerName then
								self.ActivateFire( fireTable, true )
							end
						end

					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_StopCamera",
					func = function()
						s10010_sequence.SetPadMaskCamera( false )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_Tutorial",
					func = function()
						s10010_sequence.SetPadMask2f( false )
						s10010_sequence.StopPlayerAndStartNearCamera( false )

						s10010_sequence.PushMotion{
							locatorName = "ishmael",
							motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt30_idl.gani",
							specialActionName = "end_of_ish0non_q_pnt30_idl",
							position = Vector3( -100.75936, 98.17499, -1714.75637 ),
							rotationY = 180,
							override = true,
						}
						TppUI.ShowControlGuide{
							actionName = "ATTACK",
							continue = false,
						}

					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_StartPlayer0000",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Timer: Finish: timerName: Timer_StartPlayer0000" )
						self.StartPlayer()
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_StartPlayer0001",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Timer: Finish: timerName: Timer_StartPlayer0001" )
						s10010_sequence.ProhibitMove( false )
						mvars.playerStop2f0001 = false
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_StartPlayer0002",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Timer: Finish: timerName: Timer_StartPlayer0002" )
						s10010_sequence.ProhibitMove( false )
						mvars.playerStop2f0002 = false
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_StartPlayer0003",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Timer: Finish: timerName: Timer_StartPlayer0003" )
						s10010_sequence.ProhibitMove( false )
						mvars.playerStop2f0003 = false
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_EnemyForward",
					func = function()
						local gameObjectId = { type="TppSoldier2" }	
						local command = { id="SetCommandAiStep", step = 1, }	
						GameObject.SendCommand( gameObjectId, command )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_IshmaelFire0000",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Timer: Finish: timerName: Timer_IshmaelFire0000" )
						local targetName
						for i, enemyName in ipairs( self.enemyList ) do
							local lifeState = GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", enemyName ), { id = "GetLifeStatus" } )
							if lifeState ~= TppGameObject.NPC_LIFE_STATE_DEAD then
								targetName = enemyName
							end
						end
						if targetName then
							GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "SetTargetId", targetId = GameObject.GetGameObjectId( targetName ), headShot = true, } )
							s10010_sequence.PushMotion{
								locatorName = "ishmael",
								motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt31_fre.gani",
								specialActionName = "end_of_ish0non_q_pnt31_fre",
								enableGunFire = true,
								override = true,
								position = Vector3( -97.88792, 98.175, -1718.32215 ),
								rotationY = 90,
								again = true,
							}
							s10010_sequence.StartTimer( "Timer_IshmaelFire0000", 5 )
						end
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_IshmaelMonologue0012",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Timer: Finish: timerName: Timer_IshmaelMonologue0012" )
						local label = self.ishmaelShootingLoopVoiceList[ mvars.ishmaelShootingLoopVoiceCount % #self.ishmaelShootingLoopVoiceList ]
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = label, } )
						mvars.ishmaelShootingLoopVoiceCount = mvars.ishmaelShootingLoopVoiceCount + 1
						s10010_sequence.PushMotion{
							locatorName = "ishmael",
							motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt31_sign.gani",
							specialActionName = "end_of_ish0non_q_pnt31_sign",
							idle = true,
							position = Vector3( -97.88792, 98.175, -1718.32215 ),
							rotationY = 90,
							again = true,
						}
						s10010_sequence.StartTimer( "Timer_IshmaelMonologue0012", 10 )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_WaitEnemyDown",
					func = function()
						s10010_sequence.OnEventPlayed( "twoEnemyDown" )
						s10010_sequence.OnEventFinished( "twoEnemyDown" )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_WaitEnemyDownMonologue",
					func = function()
						GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_074", } )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_EnableMarker",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Timer: Finish: timerName: Timer_EnableMarker" )
						TppMarker.Enable( "marker_extinguisher", 0, "none", "map_and_world_only_icon", 0, true, false )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_StartCamera",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Timer: Finish: timerName: Timer_StartCamera" )

						
						Player.RequestToSetCameraStock{ 
							direction = "right", 
						}

						s10010_sequence.SetPadMaskCamera( true )
						Player.RequestToSetCameraRotation {
							rotX = 5,
							rotY = 10,
							interpTime = 1
						}
						s10010_sequence.StopPlayerAndStartNearCamera( true, nil, "s10010_l01_sequence_DataIdentifier", "extinguisher", 3, 24 )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_StartCamera0001",
					func = function()
						Fox.Log( "s10010_sequence.sequences.Seq_Game_GunTutorial.Messages(): Timer: Finish: timerName: Timer_StartCamera0001" )

						s10010_sequence.StopPlayerAndStartNearCamera( true, nil, "s10010_l01_sequence_DataIdentifier", "extinguisher", 1, 50 )

						local position, rotationY = Tpp.GetLocator( "s10010_l01_sequence_DataIdentifier", "extinguisher" )
						TppSoundDaemon.PostEvent3D( "sfx_m_cypr_2F_fire_on", Vector3( position[ 1 ], position[ 2 ], position[ 3 ] ) )
					end,
				},
			},
			nil
		}
	end,

	ishmaelShootingLoopVoiceList = {
		"ISHM_089",
		"ISHM_091",
		"ISHM_092",
	},

	nextSequenceName = "Seq_Demo_BeforeEntrance",

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_GunTutorial.OnEnter()" )

		if s10010_sequence.IsDemoSequenceReserved( self.nextSequenceName ) then
			self.SetNextSequence( self )
		end

		for i, enemyName in ipairs( self.enemyList ) do
			local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyName )
			local command = { id = "SetEnableDyingState", enabled = false }
			GameObject.SendCommand( gameObjectId, command )
		end

		for i, enemyName in ipairs( self.enemyList ) do
			s10010_sequence.OnGameObjectEnterTrap( StrCode32( "trap_GameOver_2F_0003" ), GameObject.GetGameObjectId ( enemyName ) )
		end

		
		for i, fireTable in ipairs( self.fireList ) do
			if fireTable.offenceTargetTable and Tpp.IsTypeTable( fireTable.offenceTargetTable ) then
				if not Tpp.IsTypeTable( fireTable.timerTable ) then
					self.ActivateFire( fireTable )
				elseif Tpp.IsTypeString( fireTable.timerTable.timerName ) and Tpp.IsTypeNumber( fireTable.timerTable.timerCount ) then
					s10010_sequence.StartTimer( fireTable.timerTable.timerName, fireTable.timerTable.timerCount )
				end
			end
		end

		s10010_sequence.StartTimer( "Timer_StartCamera", 2 )
		s10010_sequence.StartTimer( "Timer_StartCamera0001", 5 )
		s10010_sequence.StartTimer( "Timer_EnableMarker", 6 )
		s10010_sequence.StartTimer( "Timer_StopCamera", 8 )
		s10010_sequence.StartTimer( "Timer_Tutorial", 8 )

		s10010_sequence.SetPadMask2f( true )

		GameObject.SendCommand( GameObject.GetGameObjectId( "ishmael" ), { id = "CallMonologue", label = "ISHM_070", } )

		
		mvars.playerStop2f0000 = true
		mvars.playerStop2f0001 = true
		mvars.playerStop2f0002 = true
		mvars.playerStop2f0003 = true

		
		mvars.ishmaelShootingLoopVoiceCount = 0

		
		TppEffectUtility.SetDirtyModelMemoryStrategy( "Default" )
	end,

	SetNextSequence = function( self )
		TppSequence.SetNextSequence( self.nextSequenceName )
	end,

	MoveIshmael = function()

		Fox.Log( "sequences.Seq_Game_GunTutorial.MoveIshmael()" )

		if not mvars.extinguisherFinished then
			mvars.extinguisherFinished = true
		end

	end,

	ActivateFire = function( fireTable, executedByTimer )

		Fox.Log( "sequences.Seq_Game_GunTutorial.ActivateFire(): fireTable:" .. tostring( fireTable ) )

		
		if fireTable.needToCreateEffect and executedByTimer and Tpp.IsTypeTable( fireTable.fireEffectList ) then
			for i, fireEffectName in ipairs( fireTable.fireEffectList ) do
				Fox.Log( "sequences.Seq_Game_GunTutorial.ActivateFire(): fireEffectName:" .. tostring( fireEffectName ) )
				s10010_sequence.CreateEffect( { effectName = fireEffectName, }, true, false )
			end
		else
			Fox.Log( "sequences.Seq_Game_GunTutorial.ActivateFire(): This function does not create effect." )
		end

		
		for offenceTargetName, offenceTargetTable in pairs( fireTable.offenceTargetTable ) do
			local dataBody = DataIdentifier.GetDataBodyWithIdentifier( offenceTargetTable.identifierId, offenceTargetTable.key )
			local translation = dataBody.data.transform.translation
			local scale = dataBody.data.transform.scale
			CyprusMissionController.SendCommand{
				id = "RegisterOffenseTraget",
				name = offenceTargetName,
				position = translation,
				size = scale,
				rotation = Quat( 0, 0, 0, 1 ),
				type = offenceTargetTable.type,
			}
			CyprusMissionController.SendCommand{ id = "ActiveOffenseTraget", name = offenceTargetName, }
		end

	end,

	StartPlayer = function()
		Fox.Log( "sequences.Seq_Game_GunTutorial.StartPlayer()" )

		if mvars.playerStop2f0000 then
			s10010_sequence.StopPlayerAndStartNearCamera( false )
			mvars.playerStop2f0000 = false
			s10010_sequence.SetModelVisibility( { identifier = "cypr_s03_other_DataIdentifier", key = "cypr_door001_door002_close_geom_0000", visible = false, }, true, false )

			TppUI.ShowTipsGuide{
				contentName = "COVER",	
				isOnce = false,
				isOnceThisGame = false,
			}
		end
	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_GunTutorial.OnLeave()" )

		for i, fireTable in ipairs( self.fireList ) do
			if fireTable.offenceTargetTable and Tpp.IsTypeTable( fireTable.offenceTargetTable ) then
				for offenceTargetName, offenceTargetTable in pairs( fireTable.offenceTargetTable ) do
					CyprusMissionController.SendCommand{ id = "InactiveOffenseTraget", name = offenceTargetName, }
					CyprusMissionController.SendCommand{ id = "UngisterOffenseTraget", name = offenceTargetName, }
				end
			end
		end

		
		TppMarker.Disable( "marker_extinguisher" )

	end,

}

sequences.Seq_Game_GameOverGunTutorial = s10010_sequence.MakeGameOverSequenceTable( sequences.Seq_Game_GunTutorial.enemyList )

sequences.Seq_Demo_BeforeEntrance = {

	OnEnter = function( self )
		Fox.Log( "sequences.Seq_Demo_BeforeEntrance.OnEnter()" )
		s10010_sequence.ProhibitMove( true )
		s10010_demo.PlayBeforeEntranceDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Demo_Entrance" ) end, } )
	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Demo_BeforeEntrance.OnLeave()" )
	end,

}

sequences.Seq_Demo_Entrance = {

	OnEnter = function( self )
		Fox.Log( "sequences.Seq_Demo_Entrance.OnEnter()" )
		s10010_demo.PlayEntranceDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_Load9" ) end, } )
	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Demo_Entrance.OnLeave()" )
		s10010_sequence.ProhibitMove( false )
	end,

}

sequences.Seq_Game_Load9 = s10010_sequence.MakeLoadSequenceTable( "trap_VolginInEntrance", "Seq_Demo_HijackAmbulance", 9, "Seq_Game_Entrance", "CHK_Entrance" )

sequences.Seq_Game_Entrance = {

	enemyList = {
		"sol_p21_010500_0006",
		"sol_p21_010500_0007",
		"sol_p21_010500_0008",
		"sol_p21_010500_0009",
		"sol_p21_010500_0010",
		"sol_p21_010500_0011",
	},

	Messages = function( self )
		return
		StrCode32Table {
			Trap = {
				{	
					msg = "Enter",
					sender = "trap_Entrance_fall",
					func = function()
						s10010_sequence.OnRoutePoint( GameObject.GetGameObjectId( "TppSoldier2", "sol_p21_010500_0009" ), StrCode32( "rts_skull_after_p21_010500_d_0003" ), 0, StrCode32( "trap_Entrance_fall" ) )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_VolginInEntrance",
					func = function()
						self.SetNextSequence( self )
					end,
				},
			},
			nil
		}
	end,

	nextSequenceName = "Seq_Demo_HijackAmbulance",

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_Entrance.OnEnter()" )

		if s10010_sequence.IsDemoSequenceReserved( self.nextSequenceName ) then
			self.SetNextSequence( self )
		end

	end,

	SetNextSequence = function( self )
		TppSequence.SetNextSequence( self.nextSequenceName )
	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_Entrance.OnLeave()" )

		local gameObjectId = GameObject.GetGameObjectId( "cypr_cp" )
		if gameObjectId ~= GameObject.NULL_ID then
			GameObject.SendCommand( gameObjectId, { id = "SetPhase", phase = TppGameObject.PHASE_SNEAK } )
		end

		local alive = false
		for i, enemyName in ipairs( self.enemyList ) do
			local lifeState = GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", enemyName ), { id = "GetLifeStatus" } )
			if lifeState == TppGameObject.NPC_LIFE_STATE_NORMAL then
				alive = true
			end
		end
		if not alive then	
			svars.reservedBoolean0002 = true
		end

	end,

}

sequences.Seq_Demo_HijackAmbulance = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_HijackAmbulance.OnEnter()" )


		TppBullet.ClearBulletMark()
		s10010_demo.PlayVolginInEntranceDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_VolginInEntrance" ) end, } )

		for i, enemyName in ipairs( s10010_enemy.ENTRANCE_ENEMY_LIST ) do
			local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyName )
			GameObject.SendCommand( gameObjectId, { id = "SetPuppet", enabled = true, } )
		end

		

		

		for i, enemyName in ipairs( s10010_enemy.ENTRANCE_ENEMY_LIST2 ) do
			local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyName )
			if gameObjectId ~= GameObject.NULL_ID then
				GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDisableNpc", enable = true, } )
			end
		end

	end,

	OnLeave = function()

		Fox.Log( "sequences.Seq_Demo_HijackAmbulance.OnLeave()" )
		s10010_sequence.UpdateCheckPoint{ checkPoint = "CHK_EntranceVolgin", ignoreAlert = true, }

		for i, enemyName in ipairs( s10010_enemy.ENTRANCE_ENEMY_LIST ) do
			local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyName )
			if gameObjectId ~= GameObject.NULL_ID then
				GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDisableNpc", enable = false, } )
			end
		end

	end,

}

sequences.Seq_Game_VolginInEntrance = {

	Messages = function( self )
		return
		StrCode32Table {
			Timer = {
				{	
					msg = "Finish",
					sender = "Timer_VolginBattle",
					func = function()
						
					end,
				},
			},
			Trap = {
				{	
					msg = "Enter",
					sender = "trap_HeliRotor",
					func = function()
						TppSequence.SetNextSequence( "Seq_Game_QTE_Entrance" )
					end,
				},
			},
			GameObject = {
				{
					msg = "VolginGameOverAttackSuccess",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginInEntrance.Messages(): GameObject: VolginGameOverAttackSuccess" )
						mvars.killedByVolgin = true
					end
				},
				{	
					msg = "VolginDamagedByType",
					func = function( gameObjectId, damageType )
						Fox.Log( "sequences.Seq_Game_VolginInEntrance.Messages(): GameObject: VolginDamagedByType" )
						svars.reservedNumber0000 = svars.reservedNumber0000 + 1
					end,
				},
			},
			nil
		}
	end,

	OnEnter = function()

		s10010_sequence.StartTimer( "Timer_VolginBattle", 30 )

		GameObject.SendCommand( { type = "TppVolgin2", index = 0, }, { id = "SetCyprusMode", })  
		GameObject.SendCommand( { type = "TppVolgin2", index = 0, }, { id = "EnableCombat", } )
		GameObject.SendCommand( { type = "TppVolgin2", index = 0, }, { id = "SetChasePlayerMode", chasePlayer = true, } )

		for i, enemyName in ipairs( s10010_enemy.ENTRANCE_ENEMY_LIST ) do
			local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyName )
			local command = { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_DEAD, }
			GameObject.SendCommand( gameObjectId, command )
		end

	end,

}

sequences.Seq_Game_QTE_Entrance = {

	Messages = function( self )
		return
		StrCode32Table {
			Timer = {
				{	
					msg = "Finish",
					sender = "Timer_QTE",
					func = function()
						TppSequence.SetNextSequence( "Seq_Demo_HeliRotor" )
					end,
				},
			},
			nil
		}
	end,

	OnEnter = function()

		Fox.Log( "sequences.Seq_Game_QTE_Entrance.OnEnter()" )

		s10010_sequence.SetPadMaskEntranceQTE( true )
		Player.RequestToSetTargetStance( PlayerStance.STAND )

		
		TppUI.ShowControlGuide{
			actionName = "PLAY_EVADE",
			continue = false,
		}

		
		Player.RequestToSetCameraNoise {
			levelX = 0.75,
			levelY = 0.75,
			time = 10.0,
			decayRate = 0.5,
		}

		
		Player.RequestToSetCameraRotation {
			rotX = 0,
			rotY = 0,
			rotZ = 0,
			interpTime = 1,
		}

		
		s10010_sequence.StartTimer( "Timer_QTE", 10 )

		
		s10010_sequence.PlaySoundEffect( { eventName = "sfx_m_cypr_1Frumble", singleShot = true, }, true, false )

	end,

	OnUpdate = function()

		if bit.band( PlayerVars.scannedButtonsDirect, PlayerPad.EVADE ) == PlayerPad.EVADE then
			TppSequence.SetNextSequence( "Seq_Demo_HeliRotor" )
			GkEventTimerManager.Stop( "Timer_QTE" )
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_QTE_Entrance.OnLeave()" )

		
		Player.RequestToSetCameraNoise {
			levelX = 0.0,
			levelY = 0.0,
			time = 1.0,
			decayRate = 0.5,
		}

	end,

}

sequences.Seq_Demo_HeliRotor = {

	OnEnter = function()

		Fox.Log( "sequences.Seq_Demo_HeliRotor.OnEnter()" )

		TppBullet.ClearBulletMark()
		s10010_demo.PlayHeliRotorDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Demo_VolginVsTank" ) end, } )

	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Demo_HeliRotor.OnLeave()" )
		s10010_sequence.UpdateCheckPoint{ checkPoint = "CHK_EntranceHeli", ignoreAlert = true, }

		s10010_sequence.SetPadMaskEntranceQTE( false )
	end,

}

sequences.Seq_Demo_VolginVsTank = {

	OnEnter = function()
		Fox.Log( "sequences.Seq_Demo_VolginVsTank.OnEnter()" )
		s10010_demo.PlayTankDemo( { onStart = function() TppSequence.SetNextSequence( "Seq_Game_EscapeFromEntrance") end, } )
	end,

	OnLeave = function()
		Fox.Log( "sequences.Seq_Demo_VolginVsTank.OnLeave()" )
	end,

}

sequences.Seq_Game_EscapeFromEntrance = {

	Messages = function( self )
		return
		StrCode32Table {
			Trap = {
				{
					msg = "Enter",
					sender = "trap_EscapeFromEntrance",
					func = function()
						mvars.DoesTankDemoNotNeed = true
						TppSequence.SetNextSequence( "Seq_Demo_EscapeFromEntrance")
					end,
				},
			},
			Timer = {
				{	
					msg = "Finish",
					sender = "Timer_EscapeFromEntrance",
					func = function()
						
					end,
				},
			},
			Demo = {
				{	
					msg = "PlayInit",
					func = function()
					end,
				},
				{	
					msg = "FinishMotion",
					func = function()
						
					end,
				},
			},
			TppSystem = {
				{
					msg = "NotifyCyprusTargetHit",
					func = function( targetName )

						Fox.Log( "s10010_sequence.sequences.Seq_Game_EscapeFromEntrance.Messages(): TppSystem: NotifyCyprusTargetHit" )

						if targetName == StrCode32( "offenceTarget_1f_0000" ) or targetName == StrCode32( "offenceTarget_1f_0004" ) or targetName == StrCode32( "offenceTarget_1f_0006" ) then
							vars.playerLife = 1
						end

					end,
				},
			},
			nil,
		}
	end,

	offenceTargetTable = {
		"offenceTarget_1f_0000",
		"offenceTarget_1f_0001",
		"offenceTarget_1f_0004",
		"offenceTarget_1f_0005",
		"offenceTarget_1f_0006",
		"offenceTarget_1f_0007",
		"offenceTarget_1f_0008",
	},

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_EscapeFromEntrance" )

		s10010_sequence.StartTimer( "Timer_EscapeFromEntrance", 20 )
		mvars.DoesTankDemoNotNeed = false

		for i, offenceTargetName in ipairs( self.offenceTargetTable ) do
			local dataBody = DataIdentifier.GetDataBodyWithIdentifier( "s10010_l01_sequence_DataIdentifier", offenceTargetName )
			local translation = dataBody.data.transform.translation
			local scale = dataBody.data.transform.scale
			CyprusMissionController.SendCommand{
				id = "RegisterOffenseTraget",
				name = offenceTargetName,
				position = translation,
				size = scale,
				rotation = Quat( 0, 0, 0, 1 ),
				type = "NormalFireWall",
			}
			CyprusMissionController.SendCommand{ id = "ActiveOffenseTraget", name = offenceTargetName, }
		end

	end,

	OnUpdate = function( self )

		if not mvars.DoesTankDemoNotNeed and not s10010_sequence.IsDemoPlaying( "tank" ) then
			
		end

	end,

	OnLeave = function( self )

		

		DemoDaemon.SkipAtDemoPlay( "p21_010530", "p21_010550" )

		for i, offenceTargetName in ipairs( self.offenceTargetTable ) do
			CyprusMissionController.SendCommand{ id = "InactiveOffenseTraget", name = offenceTargetName, }
			CyprusMissionController.SendCommand{ id = "UngisterOffenseTraget", name = offenceTargetName, }
		end

	end,

}

sequences.Seq_Demo_EscapeFromEntrance = {

	OnEnter = function()

		TppBullet.ClearBulletMark()

		s10010_demo.PlayEscapeFromEntranceDemo( { onEnd = function()
			TppSequence.SetNextSequence( "Seq_Game_Load10" )
		end, } )
	end,

	OnLeave = function( self )
	end,

}

sequences.Seq_Game_Load10 = s10010_sequence.MakeLoadSequenceTable( nil, nil, 10, "Seq_Demo_EscapeFromHospital", "CHK_AfterEntrance" )

sequences.Seq_Demo_EscapeFromHospital = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "p21_020010_iconon01",
					func = function()
						TppUiCommand.ShowDemoKeyHelp()
						TppUiCommand.ActiveDemoKeyHelp( true )
						mvars.doesShowDemoKeyHelp = true
						s10010_sequence.StartTimer( "Timer_StickDownTimeOut", 10 )
					end,
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_StickDownTimeOut",
					func = function()
						if mvars.doesShowDemoKeyHelp then
							TppUiCommand.HideDemoKeyHelp()
							mvars.doesShowDemoKeyHelp = nil	
						end
					end,
				},
			},
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Demo_EscapeFromHospital.OnEnter()" )

		s10010_demo.PlayEscapeFromHospital( { onEnd = function()
			local missionName = TppMission.GetMissionName()
			if missionName == "s10010" then
				
				TppSoundDaemon.SetMuteInstant( "Loading" )

				TppSequence.SetNextSequence( "Seq_Game_Load11" )
			elseif missionName == "s10280" then
				
				TppMission.EnableInGameFlag()
				s10010_sequence.ReserveMissionClear()	
			end
		end, } )

	end,

	OnUpdate = function()

		if mvars.doesShowDemoKeyHelp and bit.band( PlayerVars.scannedButtonsDirect, PlayerPad.FIRE ) == PlayerPad.FIRE then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_EscapeFromHospital.OnLeave()" )

		if mvars.doesShowDemoKeyHelp then
			TppUiCommand.HideDemoKeyHelp()
			mvars.doesShowDemoKeyHelp = nil	
		end
	end,

}

sequences.Seq_Game_Load11 = s10010_sequence.MakeLoadSequenceTable( nil, nil, 11, "Seq_Demo_FireWhale", "CHK_AfterWhale" )
sequences.Seq_Game_Load35 = s10010_sequence.MakeLoadSequenceTable( nil, nil, 35, "Seq_Game_LoadAvatarPlayerBeforePassport", nil, { isExecMissionClear = true } )

sequences.Seq_Game_LoadAvatarPlayerBeforePassport = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_LoadAvatarPlayerBeforePassport.OnEnter()" )

		TppUI.FadeOut( 0.0 )

		mvars.oldPlayerFaceEquipId = vars.playerFaceEquipId

		
		vars.playerType = PlayerType.AVATAR
		vars.playerCamoType = PlayerCamoType.OLIVEDRAB
		vars.playerPartsType = PlayerPartsType.NORMAL
		
		
		vars.playerFaceEquipId = 0

		mvars.playerCheckCount = 0

	end,

	OnUpdate = function( self )

		if mvars.playerCheckCount > 3 then	
			if PlayerInfo.OrCheckStatus and PlayerInfo.OrCheckStatus{ PlayerStatus.PARTS_ACTIVE } then
				Fox.Log( "sequences.Seq_Game_LoadAvatarPlayerBeforePassport.OnUpdate(): Finish PlayerInfo.OrCheckStatus{ PlayerStatus.PARTS_ACTIVE " )
				TppSequence.SetNextSequence( "Seq_Demo_TakePassportPhotograph", { isExecMissionClear = true } )
			end
		else
			mvars.playerCheckCount = mvars.playerCheckCount + 1
		end

		TppUI.ShowAccessIconContinue()

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_LoadAvatarPlayerBeforePassport.OnLeave()" )

	end,

}

sequences.Seq_Demo_TakePassportPhotograph = {

	OnEnter = function()

		Fox.Log( "sequences.Seq_Demo_TakePassportPhotograph.OnEnter()" )
		s10010_demo.PlayPassportPhotographDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_LoadAvatarPlayerAfterPassport", { isExecMissionClear = true } ) end, } )

	end,

	OnUpdate = function()
		TppUI.ShowAccessIconContinue()
	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_TakePassportPhotograph.OnLeave()" )

	end,

}




sequences.Seq_Game_LoadAvatarPlayerAfterPassport = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_LoadAvatarPlayerAfterPassport.OnEnter()" )

		TppUI.FadeOut( 0.0 )

		
		vars.playerType = PlayerType.SNAKE
		vars.playerCamoType = PlayerCamoType.HOSPITAL
		vars.playerPartsType = PlayerPartsType.HOSPITAL
		vars.playerFaceEquipId = mvars.oldPlayerFaceEquipId

		
		local position, rotationY = Tpp.GetLocator( "CheckPointIdentifier", "CHK_AfterWhale_Player" )
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppPlayer2", "Player" ), { id = "Warp", pos = position, rotY = rotationY } )

		mvars.playerCheckCount = 0

	end,

	OnUpdate = function( self )

		if mvars.playerCheckCount > 3 then	
			if PlayerInfo.OrCheckStatus and PlayerInfo.OrCheckStatus{ PlayerStatus.PARTS_ACTIVE } then
				Fox.Log( "sequences.Seq_Game_LoadAvatarPlayerAfterPassport.OnUpdate(): Finish PlayerInfo.OrCheckStatus{ PlayerStatus.PARTS_ACTIVE " )
				TppSequence.SetNextSequence( "Seq_Game_Load31", { isExecMissionClear = true } )
			end
		else
			mvars.playerCheckCount = mvars.playerCheckCount + 1
		end

		TppUI.ShowAccessIconContinue()

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_LoadAvatarPlayerAfterPassport.OnLeave()" )

	end,

}

sequences.Seq_Game_Load31 = s10010_sequence.MakeLoadSequenceTable( nil, nil, 31, "Seq_Game_WaitCreatingBlendTexture2", nil, { isExecMissionClear = true } )

sequences.Seq_Demo_FireWhale = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "Play",
					func = function()
						Fox.Log( "sequences.Seq_Demo_FireWhale.Messages(): Demo: Play" )
						Player.SetCameraRotationForDemoToGameInterp( 13.53, 150.3885 )

						
						TppSoundDaemon.ResetMute( "Loading" )
					end,
					option = { isExecDemoPlaying = true, },
				},
				{
					msg = "p21_020030_ChangeGameMot",
					func = function()
					end,
					option = { isExecDemoPlaying = true, },
				},
				{
					msg = "Skip",
					func = function()
						Fox.Log( "sequences.Seq_Demo_FireWhale.Messages(): Demo: Skip" )
						mvars.fireWhaleDemoSkipped = true
					end,
					option = { isExecDemoPlaying = true, },
				},
			},
			nil
		}
	end,

	OnEnter = function()

		Fox.Log( "sequences.Seq_Demo_FireWhale.OnEnter()" )

		
		local gameObjectId = GameObject.GetGameObjectId( "ocelot" )
		GameObject.SendCommand( gameObjectId, { id = "SetHostage2Flag", flag = "disableDamageReaction", on = true, } )

		s10010_demo.PlayFireWhaleDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_VolginRide" ) end, } )

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Demo_FireWhale.OnLeave()" )
		s10010_sequence.UpdateCheckPoint{ checkPoint = "CHK_AfterWhale", ignoreAlert = true, }

		
		if not mvars.volginRideStarted then
			local waitTime = 0.1
			if mvars.fireWhaleDemoSkipped then
				waitTime = 0.5
			end
			s10010_sequence.StartTimer( "Timer_HandsGun0000", waitTime )
			mvars.volginRideStarted = true
		end

	end,

}

sequences.Seq_Game_WaitCreatingBlendTexture2 = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_WaitCreatingBlendTexture2.OnEnter()" )
		TppUiCommand.CreateBlendTexture( "PassPort" )	
		mvars.textureCheckCount = 0

	end,

	OnUpdate = function( self )
		if mvars.playerCheckCount > 3 and not TppUiCommand.IsCreatingBlendTexture() then	
			TppSequence.SetNextSequence( "Seq_Demo_FireWhaleTruth", { isExecMissionClear = true } )
		end
		mvars.textureCheckCount = mvars.textureCheckCount + 1

		TppUI.ShowAccessIconContinue()
	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_WaitCreatingBlendTexture2.OnLeave()" )

	end,

}

sequences.Seq_Demo_FireWhaleTruth = {

	OnEnter = function()
		Fox.Log( "sequences.Seq_Demo_FireWhaleTruth.OnEnter()" )
		s10010_demo.PlayFireWhaleTruthDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_Load32", { isExecMissionClear = true } ) end, } )

		s10010_sequence.EnableEnemy( { locatorName = "ishmael", enable = false, }, true, false )
		TppUI.OverrideFadeInGameStatus{
			CallMenu = false,
			EquipHud = false,
			EquipPanel = false,
			CqcIcon = false,
			ActionIcon = false,
			AnnounceLog = false,
			BaseName = false,
		}
	end,

	OnLeave = function()
		Fox.Log( "sequences.Seq_Demo_FireWhaleTruth.OnLeave()" )
		TppUiCommand.DeleteBlendTexture( "PassPort" )
	end,

}

sequences.Seq_Game_VolginRide = {

	Messages = function( self )
		return
		StrCode32Table {
			Trap = {
				{	
					msg = "Enter",
					sender = "trap_Bridge",
					func = function( trapName, gameObjectId )
						self.SetNextSequence( self )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_BgmChange0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_BgmChange0000, gameObjectId:" .. tostring( gameObjectId ) )
						if Tpp.IsPlayer( gameObjectId ) then	
							s10010_sequence.OnEventPlayed( "bgmChangeVolginRide" )
							s10010_sequence.OnEventFinished( "bgmChangeVolginRide" )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_VolginRideVanish",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_VolginRideVanish, gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "ocelot_horse" ) then	
							GameObject.SendCommand( GameObject.GetGameObjectId( "volgin_horse" ), { id = "SetRoute", route = "rts_volgin_vanish", warp = 1, })	
							GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_006", } )
							s10010_sequence.StartTimer( "Timer_OCLT_07", 4 )
						else
							Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trap_VolginRideVanish: gameObjectId is not volgin_horse" )
						end

						
						do
							local gameObjectId = { type = "TppCritterBird", index = 0, }
							local command = {
								id = "SetEnabled",
								name = "CritterBirdGameObjectLocator0001",
								enabled = false,
							}
							GameObject.SendCommand(gameObjectId, command)
						end
						do
							local gameObjectId = { type = "TppCritterBird", index = 0, }
							local command = {
								id = "SetEnabled",
								name = "CritterBirdGameObjectLocator0002",
								enabled = true,
							}
							GameObject.SendCommand(gameObjectId, command)
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_VolginRideAppear",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_VolginRideAppear, gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "ocelot_horse" ) then	
							GameObject.SendCommand( GameObject.GetGameObjectId( "volgin_horse" ), { id = "SetRoute", route = "rts_volgin_appear", warp = 1, })	
							s10010_sequence.StartTimer( "Timer_OCLT_011", 2 )
						else
							Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trap_VolginRideAppear: gameObjectId is not ocelot_horse" )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_VolginSe0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_VolginSe0000, gameObjectId:" .. tostring( gameObjectId ) )

						if gameObjectId == GameObject.GetGameObjectId( "ocelot_horse" ) then	
							local position = Vector3( vars.playerPosX, vars.playerPosY, vars.playerPosZ )
							TppSoundDaemon.PostEvent3D( "sfx_e_vol_horse_dash", position )
						else
							Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trap_VolginSe0000: gameObjectId is not ocelot_horse" )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = { "trap_VolginAttack0000", "trap_VolginAttack0001", },
					func = function( trapName, gameObjectId )

						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_VolginAttack1, gameObjectId:" .. tostring( gameObjectId ) )
						if Tpp.IsPlayer( gameObjectId ) then	
							GameObject.SendCommand( GameObject.GetGameObjectId( "volgin_vr" ), { id = "RequestAttack", attackType = StrCode32( "ChargeAttack" ), } )
						end

					end,
				},
				{	
					msg = "Enter",
					sender = "trap_VolginAttackByFireWall0000",
					func = function( trapName, gameObjectId )

						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_VolginAttack1, gameObjectId:" .. tostring( gameObjectId ) )
						if Tpp.IsPlayer( gameObjectId ) then	
							self.AttackByFireWall{
								{ delay = 0.0, offset = Vector3( 2.0, 0.0, 5.0 ), },
								{ delay = 0.5, offset = Vector3( 1.5, 0.0, 3.0 ), },
								{ delay = 0.5, offset = Vector3( 0.0, 0.0, 2.0 ), },
							}
						end

					end,
				},
				{	
					msg = "Enter",
					sender = "trap_VolginAttackByFireWall0001",
					func = function( trapName, gameObjectId )

						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_VolginAttack1, gameObjectId:" .. tostring( gameObjectId ) )
						if Tpp.IsPlayer( gameObjectId ) then	
							self.AttackByFireWall{
								{ delay = 0.0, offset = Vector3( 2.0, 0.0, 5.0 ), },
								{ delay = 0.5, offset = Vector3( 1.0, 0.0, 3.0 ), },
								{ delay = 0.5, offset = Vector3( 0.0, 0.0, 1.0 ), },
							}
						end

					end,
				},
				{	
					msg = "Enter",
					sender = "trap_VolginAttackByFireWall0002",
					func = function( trapName, gameObjectId )

						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_VolginAttack1, gameObjectId:" .. tostring( gameObjectId ) )
						if Tpp.IsPlayer( gameObjectId ) then	
							self.AttackByFireWall{
								{ delay = 0.0, offset = Vector3( 2.0, 0.0, 5.0 ), },
								{ delay = 0.5, offset = Vector3( 1.0, 0.0, 3.0 ), },
								{ delay = 0.5, offset = Vector3( 0.0, 0.0, 1.0 ), },
							}
						end

					end,
				},
				{	
					msg = "Enter",
					sender = "trap_VolginAttackByFireWall0003",
					func = function( trapName, gameObjectId )

						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_VolginAttack1, gameObjectId:" .. tostring( gameObjectId ) )
						if Tpp.IsPlayer( gameObjectId ) then	
							self.AttackByFireWall{
								{ delay = 0.0, offset = Vector3( 2.0, 0.0, 5.0 ), },
								{ delay = 0.5, offset = Vector3( 1.0, 0.0, 3.0 ), },
								{ delay = 0.5, offset = Vector3( 0.0, 0.0, 1.0 ), },
							}
						end

					end,
				},
				{	
					msg = "Enter",
					sender = { "trap_DisableChargeAttack0000", "trap_DisableChargeAttack0001", },
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_DisableChargeAttack0000, gameObjectId:" .. tostring( gameObjectId ) )
						if Tpp.IsPlayer( gameObjectId ) then	
							GameObject.SendCommand( GameObject.GetGameObjectId( "volgin_vr" ), { id = "SetEnableAiAttacking", enable = false, } )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_EnableChargeAttack0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_EnableChargeAttack0000, gameObjectId:" .. tostring( gameObjectId ) )
						if Tpp.IsPlayer( gameObjectId ) then	
							GameObject.SendCommand( GameObject.GetGameObjectId( "volgin_vr" ), { id = "SetEnableAiAttacking", enable = true, } )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_VolginInvincible",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_VolginInvincible, gameObjectId:" .. tostring( gameObjectId ) )
						if Tpp.IsPlayer( gameObjectId ) then	
							local command = { id = "SetInvincibleMode", enable = true, }
							GameObject.SendCommand( GameObject.GetGameObjectId( "volgin_vr" ), command )
							GameObject.SendCommand( GameObject.GetGameObjectId( "volgin_horse" ), command )

							GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_012", } )
							s10010_sequence.StartTimer( "Timer_OCLT_013", 4 )
							local position = Vector3( vars.playerPosX, vars.playerPosY, vars.playerPosZ )
							TppSoundDaemon.PostEvent3D( "sfx_e_vol_horse_dash", position )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_TreeDown0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeDown0000, gameObjectId:" .. tostring( gameObjectId ) )
						s10010_sequence.OnEventPlayed( "treeDown0000" )
						s10010_sequence.StartTimer( "Timer_TreeExplosion0000", 2.5 )

						
						do
							local gameObjectId = { type = "TppCritterBird", index = 0, }
							local command = {
								id = "SetEnabled",
								name = "CritterBirdGameObjectLocator0000",
								enabled = false,
							}
							GameObject.SendCommand(gameObjectId, command)
						end
						do
							local gameObjectId = { type = "TppCritterBird", index = 0, }
							local command = {
								id = "SetEnabled",
								name = "CritterBirdGameObjectLocator0001",
								enabled = true,
							}
							GameObject.SendCommand(gameObjectId, command)
						end
					end,
				},
				{	
					msg = "Exit",
					sender = "trap_TreeDown0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeDown0000, gameObjectId:" .. tostring( gameObjectId ) )
						s10010_sequence.OnEventFinished( "treeDown0000" )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_TreeDown0001",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeDown0001, gameObjectId:" .. tostring( gameObjectId ) )
						s10010_sequence.OnEventPlayed( "treeDown0001" )
						s10010_sequence.StartTimer( "Timer_TreeExplosion0001", 2.5 )
					end,
				},
				{	
					msg = "Exit",
					sender = "trap_TreeDown0001",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeDown0001, gameObjectId:" .. tostring( gameObjectId ) )
						s10010_sequence.OnEventFinished( "treeDown0001" )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_TreeDown0002",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeDown0002, gameObjectId:" .. tostring( gameObjectId ) )
						s10010_sequence.OnEventPlayed( "treeDown0002" )
						s10010_sequence.StartTimer( "Timer_OCLT_045", 3 )
						mvars.ocelotMonologueDisabled = true
						s10010_sequence.StartTimer( "Timer_TreeExplosion0002", 2.5 )
					end,
				},
				{	
					msg = "Exit",
					sender = "trap_TreeDown0002",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeDown0002, gameObjectId:" .. tostring( gameObjectId ) )
						s10010_sequence.OnEventFinished( "treeDown0002" )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_TreeDown0003",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeDown0003, gameObjectId:" .. tostring( gameObjectId ) )
						s10010_sequence.OnEventPlayed( "treeDown0003" )
						s10010_sequence.StartTimer( "Timer_TreeExplosion0003", 2.5 )
					end,
				},
				{	
					msg = "Exit",
					sender = "trap_TreeDown0003",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeDown0003, gameObjectId:" .. tostring( gameObjectId ) )
						s10010_sequence.OnEventFinished( "treeDown0003" )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_TreeExplosion0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeExplosion0000, gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "volgin_horse" ) and mvars.treeExplosion[ 1 ] then
							s10010_sequence.OnEventPlayed( "treeExplosion0000" )
						end
					end,
				},
				{	
					msg = "Exit",
					sender = "trap_TreeExplosion0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Exit: trapName:trap_TreeExplosion0000, gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "volgin_horse" ) and mvars.treeExplosion[ 1 ] then
							s10010_sequence.OnEventFinished( "treeExplosion0000" )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_TreeExplosion0001",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeExplosion0001, gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "volgin_horse" ) and mvars.treeExplosion[ 2 ] then
							s10010_sequence.OnEventPlayed( "treeExplosion0001" )
						end
					end,
				},
				{	
					msg = "Exit",
					sender = "trap_TreeExplosion0001",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Exit: trapName:trap_TreeExplosion0001, gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "volgin_horse" ) and mvars.treeExplosion[ 2 ] then
							s10010_sequence.OnEventFinished( "treeExplosion0001" )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_TreeExplosion0002",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeExplosion0002, gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "volgin_horse" ) and mvars.treeExplosion[ 3 ] then
							s10010_sequence.OnEventPlayed( "treeExplosion0002" )
						end
					end,
				},
				{	
					msg = "Exit",
					sender = "trap_TreeExplosion0002",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Exit: trapName:trap_TreeExplosion0002, gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "volgin_horse" ) and mvars.treeExplosion[ 3 ] then
							s10010_sequence.OnEventFinished( "treeExplosion0002" )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_TreeExplosion0003",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_TreeExplosion0003, gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "volgin_horse" ) and mvars.treeExplosion[ 4 ] then
							s10010_sequence.OnEventPlayed( "treeExplosion0003" )
						end
					end,
				},
				{	
					msg = "Exit",
					sender = "trap_TreeExplosion0003",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Exit: trapName:trap_TreeExplosion0003, gameObjectId:" .. tostring( gameObjectId ) )
						if gameObjectId == GameObject.GetGameObjectId( "volgin_horse" ) and mvars.treeExplosion[ 4 ] then
							s10010_sequence.OnEventFinished( "treeExplosion0003" )
						end
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_PlayerVoice0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_PlayerVoice0000" )
						Player.CallVoice( "PLA0130_001", "SNAK", "DD_Player" )
					end,
				},
				{	
					msg = "Enter",
					sender = "trap_VolginVoice0000",
					func = function( trapName, gameObjectId )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Trap: Enter: trapName:trap_VolginVoice0000" )
						GameObject.SendCommand( { type = "TppVolgin2forVr", group = 0, index = 0, }, { id = "EnableFinalScream", } )
					end,
				},
			},
			GameObject = {
				{
					msg = "VolginGameOverAttackSuccess",
					func = function()

						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): GameObject: VolginGameOverAttackSuccess" )

						if mvars.volginGameOverAttackEnabled then
							
							Player.OnPlayerDeath()
							TppDataUtility.SetVisibleEffectFromGroupId( "volginRide_gameOver", true )
							TppDataUtility.CreateEffectFromGroupId( "volginRide_gameOver" )
						end

					end,
				},
				{	
					msg = "VolginAttack",
					func = function( gameObjectId, attackType )
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): GameObject: VolginAttack" )
						s10010_sequence.StartTimer( "Timer_VolginAttack0000", 1 )
						mvars.volginAttackType = attackType

						if attackType == TppVolgin2forVr.ATTACK_MESSAGE_TYPE_CHARGE_RELEASE then
							svars.reservedBoolean0001 = true
						end
					end,
				},
			},
			Timer = {
				{	
					msg = "Finish",
					sender = "Timer_VolginGameOverEnabled",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_VolginGameOverEnabled" )
						mvars.volginGameOverAttackEnabled = true
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_OCLT_07",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_OCLT_07" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_007", } )
						s10010_sequence.StartTimer( "Timer_OCLT_08", 2 )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_OCLT_08",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_OCLT_08" )
						
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_OCLT_11",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_OCLT_11" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_011", } )
						s10010_sequence.StartTimer( "Timer_OCLT_10", 2 )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_OCLT_10",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_OCLT_10" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_010", } )
						s10010_sequence.StartTimer( "Timer_OCLT_09", 3 )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_OCLT_09",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_OCLT_09" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_009", } )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_OCLT_013",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_OCLT_013" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_013", } )
						s10010_sequence.StartTimer( "Timer_OCLT_14", 5 )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_OCLT_14",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_OCLT_14" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_014", } )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_OCLT_045",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_OCLT_045" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_045", } )
						s10010_sequence.StartTimer( "Timer_OCLT_46", 3 )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_OCLT_46",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_OCLT_46" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_046", } )
						s10010_sequence.StartTimer( "Timer_OCLT_47", 5 )
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_OCLT_47",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_OCLT_47" )
						GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_047", } )
						s10010_sequence.StartTimer( "Timer_OCLT_48", 3 )
						mvars.ocelotMonologueDisabled = nil	
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Damaged",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_Damaged" )
						if not mvars.ocelotMonologueDisabled then
							s10010_sequence.CallRandomMonologue( "ocelot", self.damegeMonologueList )
						end
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TreeExplosion0000",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_TreeExplosion0000" )
						mvars.treeExplosion[ 1 ] = true
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TreeExplosion0001",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_TreeExplosion0001" )
						mvars.treeExplosion[ 2 ] = true
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TreeExplosion0002",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_TreeExplosion0002" )
						mvars.treeExplosion[ 3 ] = true
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TreeExplosion0003",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_TreeExplosion0003" )
						mvars.treeExplosion[ 4 ] = true
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_VolginAttack0000",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Timer: Finish: Timer_VolginAttack0000" )
						local monologueList = self.attackedMonologueListTable[ mvars.volginAttackType ]
						if monologueList and not mvars.ocelotMonologueDisabled then
							s10010_sequence.CallRandomMonologue( "ocelot", monologueList )
						end
						mvars.volginAttackType = nil
					end,
				},
			},
			Player = {
				{	
					msg = "OnAmmoLessInMagazine",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Player: OnAmmoLessInMagazine" )
						if not mvars.OCLT_005_finished and not mvars.ocelotMonologueDisabled then
							GameObject.SendCommand( GameObject.GetGameObjectId( "ocelot" ), { id = "CallMonologue", label = "OCLT_005", } )
							mvars.OCLT_005_finished = true
						end
					end,
				},
				{
					msg = "PlayerDamaged",
					func = function()
						Fox.Log( "sequences.Seq_Game_VolginRide.Messages(): Player: PlayerDamaged" )
						s10010_sequence.StartTimer( "Timer_Damaged", 2 )
					end,
				},
			},
			nil
		}
	end,

	damegeMonologueList = {
		"OCLT_015",
		"OCLT_016",
		"OCLT_020",
		"OCLT_021",
		"OCLT_027",
		"OCLT_028",
	},

	attackedMonologueListTable = {
		[ TppVolgin2forVr.ATTACK_MESSAGE_TYPE_CHARGE_START ] = {
			"OCLT_019",
			"OCLT_020",
			"OCLT_021",
			"OCLT_022",
			"OCLT_025",
			"OCLT_026",
		},
		[ TppVolgin2forVr.ATTACK_MESSAGE_TYPE_GAME_OVER_1 ] = {
			"OCLT_017",
			"OCLT_018",
			"OCLT_024",
		},
	},

	AttackByFireWall = function( fireWallInfo )

		Fox.Log( "sequences.Seq_Game_VolginRide.AttackByFireWall()" )

		local volginGameObjectId = GameObject.GetGameObjectId( "volgin_vr" )
		GameObject.SendCommand( volginGameObjectId, { id = "SetFirewallInfo", firewallInfo= fireWallInfo, } )
		GameObject.SendCommand( volginGameObjectId, { id = "RequestAttack", attackType = StrCode32( "FirewallAttack"), } )

	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_VolginRide.OnEnter()" )

		
		s10010_sequence.OnEventPlayed( "volginRideStart" )
		s10010_sequence.OnEventFinished( "volginRideStart" )

		mvars.volginGameOverAttackEnabled = false
		s10010_sequence.StartTimer( "Timer_VolginGameOverEnabled", 10 )	

		mvars.treeExplosion = {}

		
		local birdLocatorNameList = {
			"CritterBirdGameObjectLocator0000",
			"CritterBirdGameObjectLocator0001",
			"CritterBirdGameObjectLocator0002",
		}
		for i, birdLocatorName in ipairs( birdLocatorNameList ) do
			local gameObjectId = { type = "TppCritterBird", index = 0, }
			local command = {
				id = "WarpOnGround",
				name = birdLocatorName,
			}
			GameObject.SendCommand(gameObjectId, command)
			if birdLocatorName ~= "CritterBirdGameObjectLocator0000" then
				local command = {
					id = "SetEnabled",
					name = birdLocatorName,
					enabled = false,
				}
				GameObject.SendCommand(gameObjectId, command)
			end
		end

		
		if not mvars.volginRideStarted then
			s10010_sequence.StartTimer( "Timer_HandsGun0000", 1 )
			mvars.volginRideStarted = true
		end

		
		TppMission.EnableInGameFlag()

	end,

	nextSequenceName = "Seq_Demo_Bridge",

	SetNextSequence = function( self )

		Fox.Log( "sequences.Seq_Game_VolginRide.SetNextSequence()" )

		TppSequence.SetNextSequence( self.nextSequenceName )

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_VolginRide.OnLeave()" )

		mvars.treeExplosion = nil
		s10010_sequence.UpdateCheckPoint{ checkPoint = "CHK_AfterWhale", ignoreAlert = true, }

		s10010_sequence.OnEventPlayed( "volginRideFinish" )
		s10010_sequence.OnEventFinished( "volginRideFinish" )

	end,

	OnContinue = function( self )

		Fox.Log( "sequences.Seq_Game_VolginRide.OnContinue()" )

		
		local gameObjectId = GameObject.GetGameObjectId( "ocelot" )
		GameObject.SendCommand( gameObjectId, { id = "SetHostage2Flag", flag = "disableDamageReaction", on = true, } )

	end,

}

sequences.Seq_Demo_Bridge = {

	OnEnter = function()
		s10010_demo.PlayBridgeDemo( { onEnd = function() s10010_sequence.ReserveMissionClear() end, } )
	end,

}

sequences.Seq_Game_Load11_2 = s10010_sequence.MakeLoadSequenceTable( nil, nil, 11, "Seq_Demo_Bridge2", nil, { isExecMissionClear = true } )

sequences.Seq_Demo_Bridge2 = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "weatherTagChange_kypr_drizzle",
					func = function()
						Fox.Log( "sequences.Seq_Game_EndRoll.Messages(): UI: TppEndingFinish" )
						WeatherManager.RequestTag( "kypr_drizzle", 8 )
					end,
					option = { isExecMissionClear = true, isExecDemoPlaying = true, },
				},
				{
					msg = "weatherTagChange_kypr_default",
					func = function()
						Fox.Log( "sequences.Seq_Game_EndRoll.Messages(): UI: TppEndingFinish" )
						WeatherManager.RequestTag( "default", 8 )
					end,
					option = { isExecMissionClear = true, isExecDemoPlaying = true, },
				},
			},
			nil
		}
	end,

	OnEnter = function()
		s10010_demo.PlayBridgeDemo2( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_LoadMovie", { isExecMissionClear = true } ) end, } )
	end,

}

sequences.Seq_Game_Load32 = s10010_sequence.MakeLoadSequenceTable( nil, nil, 32, "Seq_Game_PrepareBeforeMirrorPlayerLoad", nil, { isExecMissionClear = true } )




sequences.Seq_Game_PrepareBeforeMirrorPlayerLoad = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_PrepareBeforeMirrorPlayerLoad.OnEnter()" )

		mvars.playerCheckCount  = 0

	end,

	OnUpdate = function( self )

		if mvars.playerCheckCount > 3 then	
			TppSequence.SetNextSequence( "Seq_Game_LoadMirrorPlayer", { isExecMissionClear = true } )
		else
			mvars.playerCheckCount = mvars.playerCheckCount + 1
		end

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_PrepareBeforeMirrorPlayerLoad.OnLeave()" )

	end,

}




sequences.Seq_Game_LoadMirrorPlayer = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_LoadMirrorPlayer.OnEnter()" )

		mvars.oldPlayerFaceEquipId = vars.playerFaceEquipId

		
		vars.playerType = PlayerType.AVATAR
		vars.playerCamoType = PlayerCamoType.OLIVEDRAB
		vars.playerPartsType = PlayerPartsType.NORMAL
		vars.playerFaceEquipId = 0

		mvars.playerCheckCount = 0

	end,

	OnUpdate = function( self )

		if mvars.playerCheckCount > 3 then	
			if PlayerInfo.OrCheckStatus and PlayerInfo.OrCheckStatus{ PlayerStatus.PARTS_ACTIVE } then
				Fox.Log( "sequences.Seq_Game_LoadAvatarPlayer.OnUpdate(): Finish PlayerInfo.OrCheckStatus{ PlayerStatus.PARTS_ACTIVE " )
				TppSequence.SetNextSequence( "Seq_Game_History1", { isExecMissionClear = true } )
			end
		else
			mvars.playerCheckCount = mvars.playerCheckCount + 1
		end

		TppUI.ShowAccessIconContinue()

	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Game_LoadMirrorPlayer.OnLeave()" )
	end,

}

sequences.Seq_Game_History1 = {

	Messages = function( self )
		return
		StrCode32Table {
			UI = {
				{
					msg = "TppEndingHistoryStart",
					func = function()
						Fox.Log( "sequences.Seq_Game_History1.Messages(): UI: TppEndingHistoryStart" )
					end,
					option = { isExecMissionClear = true, },
				},
				{
					msg = "TppEndingHistoryFinish",
					func = function()
						Fox.Log( "sequences.Seq_Game_History1.Messages(): UI: TppEndingHistoryFinish" )
						TppSequence.SetNextSequence( "Seq_Demo_TwoBigBoss", { isExecMissionClear = true } )
					end,
					option = { isExecMissionClear = true, },
				},
				{
					msg = "TppEndingFinish",	
					func = function()
						Fox.Log( "sequences.Seq_Game_History1.Messages(): UI: TppEndingFinish" )
						TppSequence.SetNextSequence( "Seq_Demo_TwoBigBoss", { isExecMissionClear = true } )
					end,
					option = { isExecMissionClear = true, },
				},
			},
			nil
		}
	end,

	OnEnter = function( self )
		Fox.Log( "sequences.Seq_Game_History1.OnEnter()" )

		TppUI.OverrideFadeInGameStatus{
			CallMenu = false,
			PauseMenu = false,
			EquipHud = false,
			EquipPanel = false,
			CqcIcon = false,
			ActionIcon = false,
			AnnounceLog = false,
			BaseName = false,
		}
		s10010_sequence.SetPadMaskAll( true )

		TppEnding.Start( "Truth_History" )
	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Game_History1.OnLeave()" )
	end,

}

sequences.Seq_Demo_TwoBigBoss = {

	OnEnter = function( self )
		Fox.Log( "sequences.Seq_Demo_TwoBigBoss.OnEnter()" )

		TppUI.OverrideFadeInGameStatus{
			PauseMenu = true,
		}

		TppPlayer.Refresh()
		s10010_demo.PlayTwoBigBossDemo( { onEnd = function() TppSequence.SetNextSequence( "Seq_Game_EndRoll", { isExecMissionClear = true } ) end, } )

		TppDemoUtility.SetUseBlackDiamond( true )
	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Demo_TwoBigBoss.OnLeave()" )

		
		vars.playerFaceEquipId = mvars.oldPlayerFaceEquipId

		TppUI.OverrideFadeInGameStatus{
			PauseMenu = false,
		}

		TppDemoUtility.SetUseBlackDiamond( false )
	end,

}

sequences.Seq_Game_EndRoll = {

	Messages = function( self )
		return
		StrCode32Table {
			UI = {
				{
					msg = "TppEndingMainStaffStart",
					func = function()
						Fox.Log( "sequences.Seq_Game_EndRoll.Messages(): UI: TppEndingMainStaffStart" )
						local waitTime = 13.57
						TppUI.StartLyricCyprus( 0.733 + waitTime )	
					end,
					option = { isExecMissionClear = true, },
				},
				{
					msg = "TppEndingFinish",
					func = function()
						Fox.Log( "sequences.Seq_Game_EndRoll.Messages(): UI: TppEndingFinish" )
						TppSequence.SetNextSequence( "Seq_Game_History2", { isExecMissionClear = true } )
					end,
					option = { isExecMissionClear = true, },
				},
			},
			nil
		}
	end,

	OnEnter = function( self )
		Fox.Log( "sequences.Seq_Game_EndRoll.OnEnter()" )

		TppUiCommand.LyricTexture( "regist_cyprus" )	
		TppEnding.Start( "Truth_StaffRoll" )
	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Game_EndRoll.OnLeave()" )
		TppUiCommand.LyricTexture( "hide" )
	end,

}

sequences.Seq_Game_History2 = {

	Messages = function( self )
		return
		StrCode32Table {
			UI = {
				{
					msg = "TppEndingHistoryStart",
					func = function()
						Fox.Log( "sequences.Seq_Game_History2.Messages(): UI: TppEndingHistoryStart" )
					end,
					option = { isExecMissionClear = true, },
				},
				{
					msg = "TppEndingHistoryFinish",
					func = function()
						Fox.Log( "sequences.Seq_Game_History2.Messages(): UI: TppEndingHistoryFinish" )
						TppSequence.SetNextSequence( "Seq_Game_BlackTelephone", { isExecMissionClear = true } )
					end,
					option = { isExecMissionClear = true, },
				},
				{
					msg = "TppEndingFinish",	
					func = function()
						Fox.Log( "sequences.Seq_Game_History2.Messages(): UI: TppEndingHistoryFinish" )
						TppSequence.SetNextSequence( "Seq_Game_BlackTelephone", { isExecMissionClear = true } )
					end,
					option = { isExecMissionClear = true, },
				},
			},
			nil
		}
	end,

	OnEnter = function( self )
		Fox.Log( "sequences.Seq_Game_History2.OnEnter()" )
		TppEnding.Start( "Truth_History2" )
	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Game_History2.OnLeave()" )
	end,

}

sequences.Seq_Game_BlackTelephone = {

	Messages = function( self )
		return
		StrCode32Table {
			UI = {
				{
					msg = "PauseMenuSkipTutorial",
					func = function()
						Fox.Log( "sequences.Seq_Game_BlackTelephone.Messages(): UI: PauseMenuSkipTutorial" )

						
						TppSoundDaemon.PostEventAndGetHandle( "Stop_endroll03_04", "Loading" )

						
						TppUiCommand.HideTextureLogo()

						
						TppGameStatus.Reset( "s10280","S_ENABLE_TUTORIAL_PAUSE" )
						TppUiStatusManager.SetStatus( "PauseMenu", "INVALID" )
					end,
					option = { isExecMissionClear = true, },
				},
			},
			nil
		}
	end,

	Finalize = function( self )
		Fox.Log( "sequences.Seq_Game_BlackTelephone.Finalize()" )

		SubtitlesCommand.SetIsEnabledUiPrioStrong( false )
		TppRadioCommand.SetEnableIgnoreGamePause( false )
		TppUiCommand.HideTextureLogo()
		TppUI.OverrideFadeInGameStatus( s10010_sequence.DEFAULT_OVERRIDE_SYSTEM_EXCEPT_GAME_STATUS )

		TppUiCommand.LyricTexture( "release" )

		
		TppGameStatus.Reset( "s10280","S_ENABLE_TUTORIAL_PAUSE" )
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_BlackTelephone.OnEnter()" )

		
		TppSoundDaemon.SetMute( "Result" )
		TppRadioCommand.SetEnableIgnoreGamePause( true )
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )

		
		TppUiCommand.ShowTextureLogo( "/Assets/tpp/ui/ModelAsset/sys_logo/Pictures/common_title_logo_clp_nmp.ftex", 0.0, "full" )

		
		
		mvars.blackTelephoneHandle = TppSoundDaemon.PostEventAndGetHandle( "Play_endroll03_04", "Loading" )

		Tpp.SetGameStatus{
			target = { "PauseMenu", },
			enable = false,
			scriptName = "s10010_sequence.lua",
		}

		
		TppGameStatus.Set( "s10280","S_ENABLE_TUTORIAL_PAUSE" )

		mvars.blackTelephoneCount = 0

	end,

	OnUpdate = function( self )

		if mvars.blackTelephoneCount > 5 and not TppSoundDaemon.IsEventPlaying( "Play_endroll03_04", mvars.blackTelephoneHandle ) then
			if not mvars.missionRewardShown then
				self:Finalize()
				TppMission.ShowMissionReward()
				mvars.missionRewardShown = true
			end
		else
			mvars.blackTelephoneCount = mvars.blackTelephoneCount + 1
		end

	end,

	OnLeave = function( self )
		Fox.Log( "sequences.Seq_Game_BlackTelephone.OnEnter()" )
		self:Finalize()
	end,

}

sequences.Seq_Game_LoadMovie = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_LoadMovie.OnEnter()" )

		TppSequence.ReserveNextSequence( "Seq_Game_Telop", { isExecMissionClear = true, } )

		TppUiCommand.ShowChapterTelop( "pre", 1 )
		TppMission.Reload{
			missionPackLabelName = "afterMissionClearMovie",
			isNoFade = true,
			showLoadingTips = false,
			locationCode = TppDefine.LOCATION_ID.AFGH,	
		}

	end,

}

sequences.Seq_Game_Telop = {

	Messages = function( self )
		return
		StrCode32Table {
			UI = {
				{
					msg = "EndChapterTelop",
					func = function()
						Fox.Log( "sequences.Seq_Game_Telop.Messages(): UI: EndChapterTelop" )
						TppSequence.SetNextSequence( "Seq_Game_Movie", { isExecMissionClear = true } )
					end,
					option = { isExecMissionClear = true, },
				},
			},
			nil
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_Telop.OnEnter()" )

		TppUI.FadeOut( 0 )
		TppUiCommand.ShowChapterTelop( 1, 3 )
		TppSoundDaemon.PostEvent( "Play_chapter_telop02", "Loading" )

	end,

}

sequences.Seq_Game_Movie = {

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_Movie.OnEnter()" )

		
		vars.requestFlagsAboutEquip = 0

		TppMovie.Play{
			videoName = "p21_030010_movie",
			
			isLoop = false,
			onEnd = function()
				TppMission.ShowMissionReward()
			end,
			memoryPool = "p21_030010_movie",
		}

	end,

}









s10010_sequence.eventList = {
	"flashback",
	"beforeOpening",
	"opening",
	"fewDaysLater0",
	"fewDaysLater1",
	"fewDaysLater2",
	"fewDaysLater3",
	"oneWeekLater",
	"twoWeekLater",
	"load13",
	"load1",
	"quietAppear",
	"ishmaelAppear",
	"quietExit",
	"load2",
	"tableDown",
	"chairDown",
	"startHeliDemo",
	"heli",
	"end_of_rts_ishmael_to_ev0000",
	"ishmaelRouteChange0000",
	"ishmaelRouteChange0001",
	"ishmaelRouteChange0002",
	"ashtrayDown",
	"ishmaelRouteChange0003",
	"startVolginDemo",
	"volgin",
	"load3",
	"explosion",
	"ishmaelRouteChange0004",
	"ishmaelRouteChange0005",
	"ishmaelRouteChange0006",
	"startCureDemo",
	"cure",
	"enterSmokeRoom",
	"underBed",
	"underBed2",
	"load4",
	"heliKillMob",
	"blackout",
	"soldierKillMob",
	"stairway",
	"load5",
	"corridor0",
	"corridor6",
	"corridor7",
	"load6",
	"curtainKill1",
	"curtainKill2",
	"curtainKill3",
	"curtainKill4",
	"curtainRoom",
	"curtainRoom2",
	"enterCorridor",
	"volginVsSkullSoldier",
	"load7",
	"bgmChange2f",
	"cureGame",
	"open3fDoor",
	"enter2F",
	"close2fDoor",
	"enemy2fAppear",
	"enemy2fDown",
	"getGun",
	"load8",
	"twoEnemyAppear",
	"twoEnemyDown",
	"toEntrance",
	"entrance",
	"load9",
	"ambulance",
	"heliRotor",
	"escapeFromEntrance",
	"load10",
	"escapeFromHospital",
	"load11",
	"load31",
	"load32",
	"fireWhaleTruth",
	"twoBigBoss",
	"fireWhale",
	"volginRideStart",
	"bgmChangeVolginRide",
	"volginRideVanish",
	"volginRideAppear",
	"volginRideFinish",
	"bridge",
	"bridge2",
}




s10010_sequence.RAIL_EVENT_TABLE = {
	[ 9 ] = "startHeliDemo",
	[ 15 ] = "ishmaelRouteChange0000",
	[ 22 ] = "ishmaelRouteChange0001",
	[ 25 ] = "ishmaelRouteChange0002",
	[ 37 ] = "ishmaelRouteChange0003",
	[ 41 ] = "startVolginDemo",
	[ 47 ] = "ishmaelRouteChange0004",
	[ 55 ] = "ishmaelRouteChange0005",
	[ 57 ] = "ishmaelRouteChange0006",
	[ 61 ] = "startCureDemo",
}






s10010_sequence.eventSequenceTable = {
	flashback = "Seq_Demo_Flashback",
	beforeOpening = "Seq_Demo_Flashback",	
	opening = "Seq_Demo_Opening",
	fewDaysLater0 = "Seq_Demo_FewDaysLater0",
	fewDaysLater1 = "Seq_Demo_FewDaysLater1",
	fewDaysLater2 = "Seq_Demo_FewDaysLater2",
	fewDaysLater3 = "Seq_Demo_FewDaysLater3",
	oneWeekLater = "Seq_Demo_OneWeekLater",
	twoWeekLater = "Seq_Demo_TwoWeekLater",
	load2 = "Seq_Game_Load13",
	load2 = "Seq_Game_Load1",--RETAILBUG duplicate key, different value
	quietAppear = "Seq_Demo_QuietAppear",
	ishmaelAppear = "Seq_Demo_IshmaelAppear",
	quietExit = "Seq_Demo_QuietExit",
	load2 = "Seq_Game_Load2",--RETAILBUG duplicate key, different value
	tableDown = "Seq_Game_EscapeFromAwakeRoom",
	chairDown = "Seq_Game_EscapeFromAwakeRoom",
	startHeliDemo = "Seq_Game_EscapeFromAwakeRoom",
	heli = "Seq_Demo_HeliKillMob",
	end_of_rts_ishmael_to_ev0000 = "Seq_Game_AfterHeliDemo",
	ishmaelRouteChange0000 = "Seq_Game_AfterHeliDemo",
	ishmaelRouteChange0001 = "Seq_Game_AfterHeliDemo",
	ishmaelRouteChange0002 = "Seq_Game_AfterHeliDemo",
	ashtrayDown = "Seq_Game_AfterHeliDemo",
	ishmaelRouteChange0003 = "Seq_Game_AfterHeliDemo",
	startVolginDemo = "Seq_Game_AfterHeliDemo",
	volgin = "Seq_Demo_Volgin",
	load3 = "Seq_Game_Load3",
	explosion = "Seq_Game_AfterVolginDemo",
	ishmaelRouteChange0004 = "Seq_Game_AfterVolginDemo",
	ishmaelRouteChange0005 = "Seq_Game_AfterVolginDemo",
	ishmaelRouteChange0006 = "Seq_Game_AfterVolginDemo",
	startCureDemo = "Seq_Game_AfterVolginDemo",
	cure = "Seq_Demo_Cure",
	enterSmokeRoom = "Seq_Game_EnterSmokeRoom",
	underBed = "Seq_Demo_UnderBed",
	underBed2 = "Seq_Demo_UnderBed2",
	load4 = "Seq_Game_Load4",
	heliKillMob = "Seq_Demo_HeliKillMob",
	blackout = "Seq_Game_AfterHeliKillMobDemo",
	soldierKillMob = "Seq_Demo_SoldierKillMob",
	stairway = "Seq_Demo_Stairway",
	load5 = "Seq_Game_Load5",
	corridor0 = "Seq_Demo_Corridor0",
	corridor6 = "Seq_Demo_Corridor6",
	corridor7 = "Seq_Demo_Corridor7",
	load6 = "Seq_Game_Load6",
	curtainKill1 = "Seq_Game_CurtainRoom",
	curtainKill2 = "Seq_Game_CurtainRoom",
	curtainKill3 = "Seq_Game_CurtainRoom",
	curtainKill4 = "Seq_Game_CurtainRoom",
	curtainRoom = "Seq_Demo_CurtainRoom",
	curtainRoom2 = "Seq_Demo_CurtainRoom2",
	enterCorridor = "Seq_Game_AfterCorridor",
	volginVsSkullSoldier = "Seq_Demo_VolginVsSkullSoldier",
	load7 = "Seq_Game_Load7",
	bgmChange2f = "Seq_Game_AfterCorridor",
	cureGame = "Seq_Game_AfterCorridor",
	open3fDoor = "Seq_Game_AfterCorridor",
	enter2F = "Seq_Game_AfterCorridor",
	close2fDoor = "Seq_Game_AfterCorridor",
	enemy2fAppear = "Seq_Game_AfterCorridor",
	enemy2fDown = "Seq_Game_AfterCorridor",
	getGun = "Seq_Demo_GetGun",
	load8 = "Seq_Game_Load8",
	twoEnemyAppear = "Seq_Game_GunTutorial",
	twoEnemyDown = "Seq_Game_GunTutorial",
	toEntrance = "Seq_Game_GunTutorial",
	entrance = "Seq_Demo_Entrance",
	load9 = "Seq_Game_Load9",
	ambulance = "Seq_Demo_HijackAmbulance",
	heliRotor = "Seq_Demo_HeliRotor",
	escapeFromEntrance = "Seq_Demo_EscapeFromEntrance",
	load10 = "Seq_Game_Load10",
	escapeFromHospital = "Seq_Demo_EscapeFromHospital",
	load11 = "Seq_Game_Load11",
	fireWhaleTruth = "Seq_Demo_FireWhaleTruth",
	twoBigBoss = "Seq_Demo_TwoBigBoss",
	fireWhale = "Seq_Demo_FireWhale",
	volginRideStart = "Seq_Game_VolginRide",
	bgmChangeVolginRide = "Seq_Game_VolginRide",
	volginRideVanish = "Seq_Game_VolginRide",
	volginRideAppear = "Seq_Game_VolginRide",
	volginRideFinish = "Seq_Game_VolginRide",
	bridge = "Seq_Demo_Bridge",
	bridge2 = "Seq_Demo_Bridge2",
}













s10010_sequence.eventTableRoot = {
	flashback = {
		before = {
			{ func = s10010_sequence.SetLocationTelopLangId, locationTelopIndex = 0, },
			{ func = s10010_sequence.SetWeatherTag, tag = "default", interpTime = 0, },
			{ func = s10010_sequence.SetSceneReflectionParameter, texturePath = "/Assets/tpp/common_source/cubemap/environ/cyprus/cm_cypr_cb_room001/sourceimages/cm_cypr_cb_room001_cbm.ftex", },
			{ func = s10010_sequence.SetPlayerMotionSpeed, motionSpeed = 1.0, },
			{ func = s10010_sequence.EnableUI, uiName = "EquipHud", enable = false, },
			{ func = s10010_sequence.SetTime, time = "00:00:00", },
			{
				func = s10010_sequence.SetDisabledPlayerAction,
				value = PlayerDisableAction.STEALTHASSIST +
					PlayerDisableAction.REFLEXMODE +
					PlayerDisableAction.CARRY +
					PlayerDisableAction.FULTON +
					PlayerDisableAction.MARKING + 
					PlayerDisableAction.RIDE_VEHICLE +
					PlayerDisableAction.BINOCLE +
					PlayerDisableAction.CQC +
					PlayerDisableAction.OPEN_EQUIP_MENU,
			},
			
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_1F_Entr_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_All_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_A_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Minato_Isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight_Sub", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireON", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireOFF", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_OutDoor", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_SunShadow", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartSun_Isolate", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_SunSub", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_SunSpot", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_SunSpot", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_OutDark", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_OutDark", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_Foot_isolate", enable = false, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD", visible = true, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD_Turbulence", visible = false, },
			{
				func = s10010_sequence.SetSharedGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				iReferencePath = "cypr_asht001_gim_i0000|TppSharedGimmick_cypr_asht001",
				nReferencePath = "cypr_asht001_gim_n0000|srt_cypr_asht001",
				visible = false,
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010050_cypr_cart001", visible = false, },
		},



		hrtwvnm = {	
		},
		hrtwvdng = {	
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s09_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/09/cypr_09_asset.fox2",
				locatorName = "cypr_mdeq006_wave001_gim_n0000|srt_cypr_mdeq006_wave001",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s09_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/09/cypr_09_asset.fox2",
				locatorName = "cypr_mdeq006_wave002_gim_n0000|srt_cypr_mdeq006_wave002",
				visible = true,
			},
		},
		hrtwvflt = {	
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s09_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/09/cypr_09_asset.fox2",
				locatorName = "cypr_mdeq006_wave002_gim_n0000|srt_cypr_mdeq006_wave002",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s09_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/09/cypr_09_asset.fox2",
				locatorName = "cypr_mdeq006_wave003_gim_n0000|srt_cypr_mdeq006_wave003",
				visible = true,
			},
		},
		hrtwvnmb = {	
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s09_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/09/cypr_09_asset.fox2",
				locatorName = "cypr_mdeq006_wave003_gim_n0000|srt_cypr_mdeq006_wave003",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s09_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/09/cypr_09_asset.fox2",
				locatorName = "cypr_mdeq006_wave001_gim_n0000|srt_cypr_mdeq006_wave001",
				visible = true,
			},
		},
	},
	beforeOpening = {
		before = {
			{ func = s10010_sequence.SetLocalReflectionEnabled, enabled = true, },
		},
	},
	opening = {	
		before = {
			{ func = s10010_sequence.SetSubSurfaceScatterEnabled, enabled = true, },
			{ func = s10010_sequence.SetWeatherTag, tag = "cypr_day", interpTime = 0, },
			{ func = s10010_sequence.SetPlayerMotionSpeed, motionSpeed = 1.0, },
			{ func = s10010_sequence.EnableUI, uiName = "EquipHud", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "ishmael", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "awake_nurse", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "WestHeli", enable = false, },
			{ func = s10010_sequence.ChangePlayerFova, filePath = "/Assets/tpp/fova/chara/sna/sna1_v03.fv2", },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_radi001_gim_n0001|srt_cypr_radi001",
				visible = false,
			},
			{ func = s10010_sequence.StartBedAction, stance = "BED_FLAT", },	
			{ func = s10010_sequence.EnablePadMaskNormalOnSubEvent, enable = true, },
			{ func = s10010_sequence.EnablePadMaskBeforeGetGunOnSubEvent, enable = true, },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_title_idl.gani",
				specialActionName = "end_of_ish0non_q_title_idl",
				position = Vector3( -34.950, 106.200, -1719.650 ),
				rotationY = 315,
				idle = true,
				again = true,
			},
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_room001_vrtn001_0000", meshName = "MESH_Sunlight_IV", visible = true, },
			{ func = s10010_sequence.SetScatterDofEnabled, enabled = true, },
			
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave002_gim_n0001|srt_cypr_mdeq006_wave002",
				visible = true,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave004_gim_n0000|srt_cypr_mdeq006_wave004",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave005_gim_n0000|srt_cypr_mdeq006_wave005",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave003_gim_n0001|srt_cypr_mdeq006_wave003",
				visible = false,
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_pstr003_vrtn001", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_pstr003_vrtn002", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_flrs001_arousal_room_on_day", visible = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "awake_doctor", enable = false, },
			{ func = s10010_sequence.ChangeIshmaelFova, bodyId = TppEnemyBodyId.ish0_v00, },
			{ func = s10010_sequence.CreateEffect, effectName = "FxLocatorGroup_TitleDust", },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_TitleDust", visible = true, },
			{ func = s10010_sequence.SetEffectSize, effectName = "FxLocatorGroup_TitleDust", size = { 1.0, 1.0, 1.0, 1.0, }, },
		},
		p21_010000_radio_visOff = {
		},
		p21_010000_curtainswing = {
			{
				func = s10010_sequence.BreakGimmick,
				locatorName = "cypr_crtn001_vrtn001_gim_n0001|srt_cypr_crtn001_vrtn001",
				datasetPath = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
			},
		},
		p21_010000_focusdistanceoff_ps3xbox360 = {
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_TitleDust", visible = false, },
		},
		p21_010000_cyprtitle_on = {
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_radi001_gim_n0001|srt_cypr_radi001",
				visible = true,
			},

			
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_flrs001_vrtn002_title", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_crtn001_vrtn005_title", visible = false, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_crtn001_vrtn001_gim_n0001|srt_cypr_crtn001_vrtn001",
				visible = false,
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "title_assets", visible = true, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_fann001_vrtn001_gim_n_title|srt_cypr_fann001_vrtn001",
				visible = true,
			},
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_1F_Entr_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_All_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_A_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Minato_Isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight_Sub", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireON", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireOFF", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_OutDoor", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_SunShadow", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartSun_Isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_SunSub", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_SunSpot", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Title", enable = true, },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_title_idl.gani",
				specialActionName = "end_of_ish0non_q_title_idl",
				position = Vector3( -34.950, 106.200, -1719.650 ),
				rotationY = 315,
				idle = true,
				again = true,
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010050_cypr_flwr002", visible = true, },
			{ func = s10010_sequence.SetWeatherTag, tag = "cypr_title", interpTime = 0.0, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_TitleDust", visible = true, },
			{ func = s10010_sequence.SetEffectSize, effectName = "FxLocatorGroup_TitleDust", size = { 0.4, 0.4, 0.4, 0.4, }, },
			{ func = s10010_sequence.CreateEffect, effectName = "FxLocatorGroup_TitlePetal", },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_TitlePetal", visible = true, },
		},
		after = {
			
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_flrs001_vrtn002_title", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_crtn001_vrtn005_title", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "title_assets", visible = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_1F_Entr_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_All_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_A_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Minato_Isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight_Sub", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireON", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireOFF", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_OutDoor", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_SunShadow", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartSun_Isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_SunSub", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_SunSpot", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Title", enable = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010050_cypr_flwr002", visible = true, },
			{ func = s10010_sequence.SetWeatherTag, tag = "cypr_title", interpTime = 0.0, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_TitleDust", visible = true, },
			{ func = s10010_sequence.SetEffectSize, effectName = "FxLocatorGroup_TitleDust", size = { 0.4, 0.4, 0.4, 0.4, }, },
			{ func = s10010_sequence.CreateEffect, effectName = "FxLocatorGroup_TitlePetal", },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_TitlePetal", visible = true, },
		},
	},
	fewDaysLater0 = {
		before = {
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_TitleDust", visible = false, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_TitlePetal", visible = false, },
			{ func = s10010_sequence.DestroyEffect, effectName = "FxLocatorGroup_TitleDust", },
			{ func = s10010_sequence.DestroyEffect, effectName = "FxLocatorGroup_TitlePetal", },
			{ func = s10010_sequence.SetWeatherTag, tag = "cypr_day", interpTime = 0, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "ishmael", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_1F_Entr_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_All_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_A_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Minato_Isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight_Sub", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireON", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireOFF", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_OutDoor", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartSun_Isolate", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_SunSub", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_SunShadow", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_SunSpot", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Title", enable = false, },

			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_pstr003_vrtn002", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_pstr003_vrtn003", visible = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "awake_doctor", enable = true, },

			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_radi001_gim_n0001|srt_cypr_radi001",
				visible = false,
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_radi001_off", visible = true, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_radi001_off", meshName = "MESH_on", visible = false, },

			
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_flrs001_vrtn002_title", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_crtn001_vrtn005_title", visible = true, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_crtn001_vrtn001_gim_n0001|srt_cypr_crtn001_vrtn001",
				visible = true,
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "title_assets", visible = false, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_fann001_vrtn001_gim_n_title|srt_cypr_fann001_vrtn001",
				visible = false,
			},
		},
		after = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010050_cypr_cart001", visible = true, },
		},
	},
	fewDaysLater1 = {
		before = {
		},
	},
	fewDaysLater2 = {
		before = {
		},
		after = {
			{ func = s10010_sequence.SetScatterDofEnabled, enabled = false, },
		},
	},
	fewDaysLater3 = {
		before = {
		},
		after = {
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_room001_vrtn001_0000", meshName = "MESH_Sunlight_IV", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010050_cypr_cart001", visible = false, },
		},
	},
	oneWeekLater = {
		before = {
			{ func = s10010_sequence.SetSubSurfaceScatterEnabled, enabled = false, },
			{ func = s10010_sequence.SetWeatherTag, tag = "cypr_Night_RLR", interpTime = 0, },
			{ func = s10010_sequence.SetSceneReflectionParameter, texturePath = "/Assets/tpp/common_source/cubemap/environ/cyprus/cm_cypr_cb_room002/sourceimages/cm_cypr_cb_room002_cbm.ftex", },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_pstr003_vrtn003", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_pstr003_vrtn004", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "curtain_rail_shadow", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_flrs001_arousal_room_off", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "curtain_rail_noshadow", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_flrs001_arousal_room_on", visible = true, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_flrs003_arousal_room", meshName = "MESH_on_IV", visible = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartSun_Isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_SunSub", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_SunShadow", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_SunSpot", enable = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_mdeq005_arousal_room", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_radi001_off", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_radi001_off", meshName = "MESH_on", visible = true, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_radi001_gim_n0001|srt_cypr_radi001",
				visible = true,
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_flrs001_arousal_room_on_day", visible = false, },
		},
		p21_010100_playerRise = {
			{ func = s10010_sequence.ChangeBedActionStance, stance = "BED_INCLINED", },
		},
		p21_010100_radiooff = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_radi001_off", visible = true, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_radi001_off", meshName = "MESH_on", visible = false, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_radi001_gim_n0001|srt_cypr_radi001",
				visible = false,
			},
		},
		p21_010100_beatup01 = {
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave002_gim_n0001|srt_cypr_mdeq006_wave002",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave004_gim_n0000|srt_cypr_mdeq006_wave004",
				visible = true,
			},
		},
		p21_010100_beatup02 = {
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave004_gim_n0000|srt_cypr_mdeq006_wave004",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave005_gim_n0000|srt_cypr_mdeq006_wave005",
				visible = true,
			},
		},
		after = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_mdeq005_arousal_room", visible = true, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave002_gim_n0001|srt_cypr_mdeq006_wave002",
				visible = true,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave003_gim_n0001|srt_cypr_mdeq006_wave003",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave004_gim_n0000|srt_cypr_mdeq006_wave004",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave005_gim_n0000|srt_cypr_mdeq006_wave005",
				visible = false,
			},
		},
	},
	souvenirPhotograph = {
		before = {
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD", visible = false, },
		},
		after = {
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD", visible = true, },
		},
	},
	twoWeekLater = {
		before = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_pstr003_vrtn004", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_pstr003_vrtn001", visible = true, },










			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "bed_flat", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "bed_up", visible = true, },
		},
		after = {
			{ func = s10010_sequence.StopBedAction, },
			{
				func = s10010_sequence.SetDisabledPlayerAction,
				value = PlayerDisableAction.STEALTHASSIST +
					PlayerDisableAction.REFLEXMODE +
					PlayerDisableAction.CARRY +
					PlayerDisableAction.FULTON +
					PlayerDisableAction.LOOK_CAMERA_DIR +
					PlayerDisableAction.MARKING + 
					PlayerDisableAction.RIDE_VEHICLE +
					PlayerDisableAction.BINOCLE +
					PlayerDisableAction.CQC +
					PlayerDisableAction.OPEN_EQUIP_MENU,
			},
			{ func = s10010_sequence.SetWeatherTag, tag = "default", interpTime = 0, },
		},
	},
	quietAppear = {
		before = {
			{ func = s10010_sequence.SetWeatherTag, tag = "cypr_Night_RLR", interpTime = 0, },
			{ func = s10010_sequence.ChangePlayerFova, filePath = "/Assets/tpp/fova/chara/sna/sna1_v00.fv2", },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_pstr003_vrtn001", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_pstr003_vrtn005", visible = true, },
		},
		p21_010230_beatup01 = {	
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave002_gim_n0001|srt_cypr_mdeq006_wave002",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave004_gim_n0000|srt_cypr_mdeq006_wave004",
				visible = true,
			},

		},
		p21_010230_beatup02 = {	
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave004_gim_n0000|srt_cypr_mdeq006_wave004",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave005_gim_n0000|srt_cypr_mdeq006_wave005",
				visible = true,
			},

		},
		p21_010230_beatup03 = {	
		},
		p21_010230_beatup04 = {	
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave005_gim_n0000|srt_cypr_mdeq006_wave005",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave003_gim_n0001|srt_cypr_mdeq006_wave003",
				visible = true,
			},

		},
		p21_010230_sheetchange = {
			{
				func = s10010_sequence.SetMeshVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				key = "sht0_main0_def_0000",
				meshName = "MESH_sh_a",
				visible = false,
			},
			{
				func = s10010_sequence.SetMeshVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				key = "sht0_main0_def_0000",
				meshName = "MESH_sh_d_IV",
				visible = true,
			},
		},
		after = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "awake_nurse",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_wake_ded_p.gani",
				specialActionName = "end_of_nrs0_wake_ded_p",
				position = Vector3( -42.000, 106.175, -1718.712 ),
				rotationY = -90,
				idle = true,
				override = true,
				again = true,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave002_gim_n0001|srt_cypr_mdeq006_wave002",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave004_gim_n0000|srt_cypr_mdeq006_wave004",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave005_gim_n0000|srt_cypr_mdeq006_wave005",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_mdeq006_wave003_gim_n0001|srt_cypr_mdeq006_wave003",
				visible = true,
			},
		},
	},
	ishmaelAppear = {
		before = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "ishmael", enable = true, },
			{
				func = s10010_sequence.SetDisabledPlayerAction,
				value =	PlayerDisableAction.STEALTHASSIST +
						PlayerDisableAction.REFLEXMODE +
						PlayerDisableAction.CARRY +
						PlayerDisableAction.FULTON +
						PlayerDisableAction.MARKING +
						PlayerDisableAction.RIDE_VEHICLE +
						PlayerDisableAction.BINOCLE +
						PlayerDisableAction.CQC +
						PlayerDisableAction.OPEN_EQUIP_MENU,
			},
		},
		after = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "awake_doctor",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_wake_ded_p.gani",
				specialActionName = "end_of_dct0_wake_ded_p",
				position = Vector3( -40.108, 106.175, -1718.953 ),
				rotationY = 90,
				idle = true,
				override = true,
				again = true,
			},
		},
	},
	quietExit = {
		before = {
			{ func = s10010_sequence.SetGimmickVisibility, identifier = "cypr_s01_other_DataIdentifier", type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2", locatorName = "cypr_char001_vrtn001_gim_n0000|srt_cypr_char001_vrtn001", visible = true, },
			
		},
		p21_010250_windowbreak02 = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010250_cypr_wndw003_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010250_cypr_wndw003_vrtn001_after", visible = true, },
		},
		p21_010250_gim_cartON = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010250_fell_flower", visible = true, },
			{ func = s10010_sequence.SetGimmickVisibility, identifier = "cypr_s01_other_DataIdentifier", type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2", locatorName = "cypr_cart001_gim_n0000|srt_cypr_cart001", visible = true, },
			{ func = s10010_sequence.SetGimmickVisibility, identifier = "cypr_s01_other_DataIdentifier", type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2", locatorName = "cypr_mdeq004_vrtn009_gim_n0000|srt_cypr_mdeq004_vrtn009", visible = true, },
		},
		p21_010250_ishstart = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_s_dr_patidl.gani",
				specialActionName = "end_of_ish0non_s_dr_patidl",
				position = Vector3( -42.72912, 106.177, -1712.35928 ),
				rotationY = 0,
				idle = true,
				again = true,
			},
			{ func = s10010_sequence.StartRailAction, railIndex = 0, },
		},
		after = {
			{ func = s10010_sequence.SetEffectVisibility, effectName = "Effect_4F_AwakeToVolginDemo", visible = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight_Sub", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_A_isolate", enable = true, },
			{ func = s10010_sequence.PlaySoundEffect, soundSourceName = "SS_4FHeli", eventName = "sfx_m_cypr_heli_far", },
			
			{ func = s10010_sequence.SetSceneReflectionParameter, texturePath = "/Assets/tpp/common_source/cubemap/environ/cyprus/cm_cypr_cb_room002/sourceimages/cm_cypr_cb_room002_cbm.ftex", },
			{ func = s10010_sequence.CreateEffect, effectName = "FxLocatorGroup_CurtainFire", },
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 12.871343612671, rotationY = -59.464687347412, },
		},
	},
	load2 = {
		after = {
			{ func = s10010_sequence.RealizeVolgin, realize = false, },
		},
	},
	tableDown = {
		after = {
		},
	},
	chairDown = {
		after = {
		},
	},
	startHeliDemo = {
		before = {
			{ func = s10010_sequence.ProhibitMoveOnSubEvent, enable = true, },
		},
		after = {
			{ func = s10010_sequence.SetNextSequence, sequenceName = "Seq_Demo_Heli", },
		},
	},
	heli = {
		after = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_s_1st_idl.gani",
				specialActionName = "end_of_ish0non_s_1st_idl",
				position = Vector3( -45.929, 106.175, -1709.84516 ),
				rotationY = -90,
				idle = true,
				override = true,
				again = true,
			},
			{ func = s10010_sequence.ProhibitMoveOnSubEvent, enable = false, },
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_4th_floor", },
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_01", },
		},
	},
	ishmaelRouteChange0000 = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_s_1st_mov.gani",
				specialActionName = "end_of_ish0non_s_1st_mov",
				position = Vector3( -45.929, 106.175, -1709.84516 ),
			},
		},
	},
	ishmaelRouteChange0001 = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_sof_stp.gani",
				specialActionName = "end_of_ish0non_q_sof_stp",
				position = Vector3( -51.11223, 106.175, -1711.56012 ),
			},
		},
	},
	ishmaelRouteChange0002 = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_sof_2s_beh.gani",
				specialActionName = "end_of_ish0non_q_sof_2s_beh",
				position = Vector3( -56.4, 106.175, -1711.9 ),
			},
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_02", },
		},
	},
	ashtrayDown = {
		after = {
			{ func = s10010_sequence.CreateEffect, effectName = "effect_ashtray", },
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_03", },
		},
	},
	ishmaelRouteChange0003 = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_s_to_vol_demo.gani",
				specialActionName = "end_of_ish0non_s_to_vol_demo",
				position = Vector3( -58.02167, 106.175, -1719.40116 ),
			},
		},
	},
	startVolginDemo = {
		before = {
			{ func = s10010_sequence.StopSceneBGM, },
			{ func = s10010_sequence.ProhibitMoveOnSubEvent, enable = true, },
		},
		after = {
			{ func = s10010_sequence.SetNextSequence, sequenceName = "Seq_Demo_Volgin", },
		},
	},
	volgin = {
		before = {
			{ func = s10010_sequence.ProhibitMoveOnSubEvent, enable = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_door003_door001_arousal_room_open", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_door003_door001_arousal_room_close", visible = true, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "Effect_4F_AwakeToVolginDemo", visible = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_StartNight_Sub", enable = false, },
			{ func = s10010_sequence.DestroyEffect, effectName = "effect_ashtray", },
		},
		Play = {
		},
		p21_010270_elvtlamp_on = {
			{
				func = s10010_sequence.BreakGimmick,
				locatorName = "cypr_elvt001_lamp001_gim_n0000|srt_cypr_elvt001_lamp001",
				datasetPath = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
			},
		},
		p21_010270_elvtdef_off = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010270_cypr_elvt001_door001", visible = false, },
		},
		p21_010270_elvtdoor = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010270_cypr_door001_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010270_cypr_door001_after", visible = true, },
		},
		p21_010270_envbreak = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010270_light_on", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010270_light_off", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010270_passage_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010270_passage_after", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010270_rubble", visible = true, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_asht001_anim_gim_n0000|srt_cypr_asht001_anim",
				visible = false,
			},
			
			{
				func = s10010_sequence.SetSharedGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				iReferencePath = "cypr_asht001_gim_i0000|TppSharedGimmick_cypr_asht001",
				nReferencePath = "cypr_asht001_gim_n0000|srt_cypr_asht001",
				visible = true,
			},
			{ func = s10010_sequence.CreateEffect, effectName = "cyprus_effect_4F_FireLight", },
			{ func = s10010_sequence.CreateEffect, effectName = "Effect_4F_Sprinkler", },
			{ func = s10010_sequence.CreateEffect, effectName = "Effect_4F_SprinklerPuddle", },
			{ func = s10010_sequence.CreateEffect, effectName = "Effect_4F_SprinklerSplash", },
			{ func = s10010_sequence.CreateEffect, effectName = "cyprus_4F_0000", },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "elevater_before_fx", visible = true, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "cyprus_4F_0000", visible = true, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "cyprus_effect_4F_FireLight", visible = true, },
		},
		p21_010270_emergencybell = {
			{ func = s10010_sequence.PlaySoundEffect, soundSourceName = "SS_4FFA", eventName = "sfx_m_cypr_fire_siren", singleShot = false, onlyIfSkipped = true, },
		},
		after = {
			
			
			

			
			{ func = s10010_sequence.StartRailAction, railIndex = 1, },
			{ func = s10010_sequence.EnableMob, locatorName = "awake_nurse", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "awake_doctor", enable = false, },
			{ func = s10010_sequence.ChangePlayerFova, filePath = "/Assets/tpp/fova/chara/sna/sna1_v01.fv2", },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_4f_pnt1_to_pnt2.gani",
				specialActionName = "end_of_ish0non_q_4f_pnt1_to_pnt2",
				position = Vector3( -58.08454, 106.175000, -1713.2794 ),
				rotationY = 29.1921,
				override = true,
			},
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_volgin_gone", },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_A_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = true, },
			{ func = s10010_sequence.PlaySoundEffect, eventName = "sfx_m_cypr_6_int", singleShot = false, onlyIfSkipped = true, },
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 5.0513000488281, rotationY = 84.002403259277, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "outside_window_4f", visible = true, },
			{ func = s10010_sequence.CreateEffect, effectName = "4F_Sprinkler", },
			{ func = s10010_sequence.CreateEffect, effectName = "4F_Puddle", },
			{ func = s10010_sequence.SetLocationTelopLangId, locationTelopIndex = 1, },
			{ func = s10010_sequence.ChangeIshmaelFova, bodyId = TppEnemyBodyId.ish0_v01, },
		},
	},
	load3 = {
		after = {
		},
	},
	explosion = {
		before = {
			{ func = s10010_sequence.CreateEffect, effectName = "cyprus_explosion_at_chair", },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "cyprus_explosion_at_chair", visible = true, },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_lok_bom_st.gani",
				specialActionName = "end_of_ish0non_q_lok_bom_st",
				override = true,
			},
		},
		after = {

		},
	},
	ishmaelRouteChange0004 = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_4f_pnt2_to_pnt3.gani",
				specialActionName = "end_of_ish0non_q_4f_pnt2_to_pnt3",
				
				again = true,
			},
		},
	},
	ishmaelRouteChange0005 = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_4f_pnt3_to_pnt4.gani",
				specialActionName = "end_of_ish0non_q_4f_pnt3_to_pnt4",
				
			},
			{ func = s10010_sequence.CallMonologue, locatorName = "ishmael", label = "ISHM_021", },
		},
	},
	ishmaelRouteChange0006 = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_4f_pnt4_to_pnt5.gani",
				specialActionName = "end_of_ish0non_q_4f_pnt4_to_pnt5",
				
			},
		},
	},
	startCureDemo = {
		before = {
			{ func = s10010_sequence.StopSceneBGM, },
			{ func = s10010_sequence.ProhibitMoveOnSubEvent, enable = true, },
		},
		after = {
			{ func = s10010_sequence.SetNextSequence, sequenceName = "Seq_Demo_Cure", },
		},
	},
	cure = {
		before = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010310_0000", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010310_0001", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010310_0002", enable = true, },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010310_0000", sneakRouteName = "rts_skull_after_p21_010310_0000", },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010310_0001", sneakRouteName = "rts_skull_after_p21_010310_0001", },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010310_0002", sneakRouteName = "rts_skull_after_p21_010310_0002", },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_door003_door001_smoke_room_close", visible = false, },
			{ func = s10010_sequence.StopRailAction, },
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_soldiers_corridor", },
		},
		p21_010310_wssstart = {
		},
		after = {
			{ func = s10010_sequence.SetPlayerMotionSpeed, motionSpeed = 0.7, },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt1_come.gani",
				specialActionName = "end_of_ish0non_q_pnt1_come",
				position = Vector3( -36.850, 106.175, -1706.850 ),
				rotationY = 0,
				idle = true,
				override = true,
				again = true,
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_door003_door001_smoke_room_open", visible = true, },
			{ func = s10010_sequence.ProhibitMoveOnSubEvent, enable = false, },
			{ func = s10010_sequence.DestroyEffect, effectName = "Effect_4F_Sprinkler", },
			{ func = s10010_sequence.DestroyEffect, effectName = "Effect_4F_SprinklerPuddle", },
			{ func = s10010_sequence.DestroyEffect, effectName = "Effect_4F_SprinklerSplash", },
			{
				func = s10010_sequence.SetDisabledPlayerAction,
				value = PlayerDisableAction.STEALTHASSIST +
					PlayerDisableAction.REFLEXMODE +
					PlayerDisableAction.CARRY +
					PlayerDisableAction.FULTON +
					PlayerDisableAction.MARKING +
					PlayerDisableAction.RIDE_VEHICLE +
					PlayerDisableAction.BINOCLE +
					PlayerDisableAction.CQC +
					PlayerDisableAction.OPEN_EQUIP_MENU +
					PlayerDisableAction.STAND,
			},
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 1.7429848909378, rotationY = -3.6800100803375, },
		},
	},
	enterSmokeRoom = {
		before = {
			{
				func = s10010_sequence.SetDisabledPlayerAction,
				value = PlayerDisableAction.STEALTHASSIST +
					PlayerDisableAction.REFLEXMODE +
					PlayerDisableAction.CARRY +
					PlayerDisableAction.FULTON +
					PlayerDisableAction.CHANGE_STANCE_FROM_CRAWL +
					PlayerDisableAction.MARKING +
					PlayerDisableAction.RIDE_VEHICLE +
					PlayerDisableAction.BINOCLE +
					PlayerDisableAction.CQC +
					PlayerDisableAction.OPEN_EQUIP_MENU +
					PlayerDisableAction.STAND,
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "smoke_room_door_geom", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_door003_door001_smoke_room_open", visible = false, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_door003_anim001_gim_n0000|srt_cypr_door003_anim001",
				visible = true,
			},
			{
				func = s10010_sequence.BreakGimmick,
				locatorName = "cypr_door003_anim001_gim_n0000|srt_cypr_door003_anim001",
				datasetPath = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
			},
			{ func = s10010_sequence.PlaySoundEffect, soundSourceName = "SS_DOOR1", eventName = "sfx_m_cypr_door1", singleShot = true, },
		},
		after = {
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/01/cypr_01_asset.fox2",
				locatorName = "cypr_door003_anim001_gim_n0000|srt_cypr_door003_anim001",
				visible = false,
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_door003_door001_smoke_room_close", visible = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010340_0000", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010340_0001", enable = true, },
		},
	},
	underBed = {
		before = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010310_0000", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010310_0001", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010310_0002", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010340_0000", enable = true, },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010340_0000", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010340_0001", },
			{ func = s10010_sequence.DestroyEffect, effectName = "cyprus_effect_4F_FireLight", },
			{ func = s10010_sequence.DestroyEffect, effectName = "cyprus_explosion_at_chair", },
			{ func = s10010_sequence.StopSceneBGM, },
		},
		p21_010340_corpse_on = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010340_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_smok_01_ded_p.gani",
				specialActionName = "end_of_ptn0_smok_01_ded_p",
				position = Vector3( -43.3009, 106.175, -1698.0348 ),
				rotationY = 175,
				idle = true,
				override = true,
				again = true,
			},
		},
		after = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt4_come.gani",
				specialActionName = "end_of_ish0non_q_pnt4_come",
				position = Vector3( -53.34735, 106.175, -1697.54702 ),
				rotationY = 0,
			},
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010340_0000", sneakRouteName = "rts_skull_after_p21_010340_0000", },
		},
	},
	underBed2 = {
		after = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010340_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_smok_02_ded_p.gani",
				specialActionName = "end_of_ptn0_smok_01_ded_p",
				position = Vector3( -36.400, 106.175, -1696.613 ),
				rotationY = -90,
				idle = true,
				again = true,
			},
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010360_0000", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "nrs_p21_010360_0000", enable = true, },
			{ func = s10010_sequence.SetInitialPlayerAction, action = PlayerInitialAction.CRAWL, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_OutDark", enable = true, },
			{ func = s10010_sequence.CreateEffect, effectName = "smk_room_blood", },
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = -0.77989, rotationY = -82.97999, },
		},
	},
	heliKillMob = {
		before = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "WestHeli", enable = true, },
			{ func = s10010_sequence.ChangeHeliRoute, locatorName = "WestHeli", routeName = "rts_heli_4F_0000", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010360_0000", },
			{ func = s10010_sequence.SetUpMob, locatorName = "nrs_p21_010360_0000", },
		},
		p21_010360_window_brk01 = {	
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas001_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas001_b_after", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas002_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas002_b_after", visible = true, },
			{ func = s10010_sequence.WarpPlayer, position = { -53.266, 105.375, -1697.359, }, rotationY = 0, },
		},
		p21_010360_window_brk02 = {	
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas003_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas003_b_after", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas004_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas004_b_after", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_vrtn004_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_vrtn004_gm_after", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_pssg001_flor001", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_pssg001_flor001_br", visible = true, },
		},
		p21_010360_window_brk03 = {	
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas005_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas005_b_after", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas006_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010360_cypr_wndw001_glas006_b_after", visible = true, },
		},
		after = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt5_to_pnt6.gani",
				specialActionName = "end_of_ish0non_q_pnt5_to_pnt6",
				position = Vector3( -53.97301, 106.175, -1692.81799 ),
				rotationY = 0,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010360_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_heli_ded_p.gani",
				specialActionName = "end_of_ptn0_heli_ded_p",
				position = Vector3( -53.930, 106.175, -1684.694 ),
				rotationY = 135,
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "nrs_p21_010360_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_heli_ded_p.gani",
				specialActionName = "end_of_nrs0_heli_ded_p",
				position = Vector3( -54.587, 106.175, -1682.323 ),
				rotationY = -90,
				idle = true,
				again = true,
			},
			{ func = s10010_sequence.PlaySoundEffect, eventName = "sfx_m_cypr_7_int", singleShot = false, onlyIfSkipped = true, },
			{ func = s10010_sequence.StopSceneBGM, },
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_patient_02", },
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_01", },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD", visible = false, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD_Turbulence", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_door004_door001_smoke_room_open", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "cypr_door004_door001_smoke_room_close", visible = true, },
			{
				func = s10010_sequence.SetDisabledPlayerAction,
				value = PlayerDisableAction.STEALTHASSIST +
					PlayerDisableAction.REFLEXMODE +
					PlayerDisableAction.CARRY +
					PlayerDisableAction.FULTON +
					PlayerDisableAction.MARKING +
					PlayerDisableAction.RIDE_VEHICLE +
					PlayerDisableAction.BINOCLE +
					PlayerDisableAction.CQC +
					PlayerDisableAction.OPEN_EQUIP_MENU +
					PlayerDisableAction.STAND,
			},
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = -4.82004737854, rotationY = -6.5339770317078, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010370_0000", enable = true, },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010370_0000", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010360_0000", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "nrs_p21_010360_0000", },
		},
	},
	blackout = {
		before = {
		},
		after = {
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_B_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_Foot_isolate", enable = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_on", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "p21_010370_light_off", visible = true, },
		},
	},
	soldierKillMob = {
		before = {
			{ func = s10010_sequence.StopSceneBGM, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010340_0000", enable = false, },
			{ func = s10010_sequence.ChangeHeliRoute, locatorName = "WestHeli", routeName = "rts_heli_4F_0003", },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010370_0000", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010370_0001", enable = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "before_p21_010370", visible = true, },
		},
		p21_010370_padon = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt9_idl.gani",
				specialActionName = "end_of_ish0non_q_pnt9_idl",
				idle = true,
				position = Vector3( -101.10983, 106.175, -1682.33594 ),
				rotationY = 44.0203,
			},
			{
				func = s10010_sequence.SetDisabledPlayerAction,
				value = PlayerDisableAction.STEALTHASSIST +
					PlayerDisableAction.REFLEXMODE +
					PlayerDisableAction.CARRY +
					PlayerDisableAction.FULTON +
					PlayerDisableAction.MARKING +
					PlayerDisableAction.RIDE_VEHICLE +
					PlayerDisableAction.BINOCLE +
					PlayerDisableAction.CQC +
					PlayerDisableAction.OPEN_EQUIP_MENU,
			},
		},
		after = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010370_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_4flor_ded_p.gani",
				specialActionName = "end_of_ptn0_4flor_ded_p",
				position = Vector3( -53.245, 106.175, -1681.321 ),
				rotationY = -64.8627,
				idle = true,
				again = true,
			},
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_patient_02", },
			{ func = s10010_sequence.SetInitialPlayerAction, action = PlayerInitialAction.SQUAT, },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010370_0000", sneakRouteName = "rts_skull_after_p21_010370_0000", },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010370_0001", sneakRouteName = "rts_skull_after_p21_010370_0001", },
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 1.4404321908951, rotationY = 95.598915100098, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "WestHeli", enable = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s01_other_DataIdentifier", key = "before_p21_010370", visible = false, },
		},
	},
	stairway = {
		before = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0000", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0001", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010340_0000", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010340_0001", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010360_0000", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "nrs_p21_010360_0000", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010370_0000", enable = false, },
			{ func = s10010_sequence.ProhibitMoveOnSubEvent, enable = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_open", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_halfopen", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_close", visible = false, },
			{ func = s10010_sequence.StopSceneBGM, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010380_0000", enable = true, },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010380_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_a_idl.gani",
				specialActionName = "end_of_ptn0_guilty_a_idl",
				position = Vector3( -100.8533, 106.175, -1679.241 ),
				idle = true,
				again = true,
			},
			{ func = s10010_sequence.EnableMob, locatorName = "dct_p21_010410_0000", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "dct_p21_010410_0001", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "nrs_p21_010410_0000", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "nrs_p21_010410_0001", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "nrs_p21_010410_0002", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ish_p21_010410_0000", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0000", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0001", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0002", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0003", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0004", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0005", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0006", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0007", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0008", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0009", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0010", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0011", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0012", enable = true, },
			{ func = s10010_sequence.DestroyEffect, effectName = "cyprus_4F_0000", },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_OutDark", enable = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010410_cypr_grat001_door001_open", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010410_cypr_grat001_door001_close", visible = true, },
			{ func = s10010_sequence.SetPlayerMotionSpeed, motionSpeed = 0.85, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD", visible = true, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD_Turbulence", visible = false, },
		},
		Play = {
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010380_0000", sneakRouteName = "rts_skull_stairway_0000", },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010380_0001", sneakRouteName = "rts_skull_stairway_0001", },
		},
		p21_010380dooroff = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010380_cypr_door002_open", visible = false, },
		},
		p21_010380_ish = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt10_to_pnt11.gani",
				specialActionName = "end_of_ish0non_q_pnt10_to_pnt11",
				position = Vector3( -106.95483, 106.175, -1683.81792 ),
				rotationY = -90,
				override = true,
			},
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_stairs_01", },
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_01", },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010370_0000", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010370_0001", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0002", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0003", enable = true, },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010380_0002", sneakRouteName = "rts_skull_stairway_0004", },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010380_0003", sneakRouteName = "rts_skull_stairway_0005", },
		},
		p21_010380_door = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010380_cypr_door002_close", visible = true, },
		},
		p21_010380_padon = {
			{ func = s10010_sequence.ProhibitMoveOnSubEvent, enable = false, },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_a_idl.gani",
				specialActionName = "end_of_ptn0_guilty_a_idl",
				position = Vector3( -101.977997, 102.175000, -1674.468872 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_b_idl.gani",
				specialActionName = "end_of_ptn0_guilty_b_idl",
				position = Vector3( -102.622482, 102.175000, -1673.884888 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0002",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_c_idl.gani",
				specialActionName = "end_of_ptn0_guilty_c_idl",
				position = Vector3( -101.045341, 102.175000, -1673.582031 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0003",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_d_idl.gani",
				specialActionName = "end_of_ptn0_guilty_d_idl",
				position = Vector3( -102.250633, 102.175000, -1672.571777 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0004",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_e_idl.gani",
				specialActionName = "end_of_ptn0_guilty_e_idl",
				position = Vector3( -102.816933, 102.175000, -1672.175659 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0005",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_f_idl.gani",
				specialActionName = "end_of_ptn0_guilty_f_idl",
				position = Vector3( -101.705223, 102.175000, -1671.819214 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0006",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_g_idl.gani",
				specialActionName = "end_of_ptn0_guilty_g_idl",
				position = Vector3( -102.224541, 102.175000, -1670.964722 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0007",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_h_idl.gani",
				specialActionName = "end_of_ptn0_guilty_h_idl",
				position = Vector3( -102.783768, 102.175000, -1670.304199 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0008",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_i_idl.gani",
				specialActionName = "end_of_ptn0_guilty_i_idl",
				position = Vector3( -100.855095, 102.175000, -1670.159424 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0009",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_j_idl.gani",
				specialActionName = "end_of_ptn0_guilty_j_idl",
				position = Vector3( -101.246498, 102.175000, -1669.561157 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0010",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_k_idl.gani",
				specialActionName = "end_of_ptn0_guilty_k_idl",
				position = Vector3( -102.361778, 102.175000, -1668.384033 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0011",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_l_idl.gani",
				specialActionName = "end_of_ptn0_guilty_l_idl",
				position = Vector3( -101.045410, 102.175000, -1667.730957 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0012",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_m_idl.gani",
				specialActionName = "end_of_ptn0_guilty_m_idl",
				position = Vector3( -102.322762, 102.175000, -1667.145996 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ish_p21_010410_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_ish_idl.gani",
				specialActionName = "end_of_ptn0_guilty_ish_idl",
				idle = true,
				position = Vector3( -101.702194, 102.175000, -1667.854004 ),
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "nrs_p21_010410_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_guilty_a_idl.gani",
				specialActionName = "end_of_nrs0_guilty_a_idl",
				position = Vector3( -101.848816, 102.175000, -1673.265869 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "nrs_p21_010410_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_guilty_b_idl.gani",
				specialActionName = "end_of_nrs0_guilty_b_idl",
				position = Vector3( -102.133018, 102.175000, -1669.248657 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "nrs_p21_010410_0002",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_guilty_c_idl.gani",
				specialActionName = "end_of_nrs0_guilty_c_idl",
				position = Vector3( -101.315948, 102.175000, -1667.002808 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "dct_p21_010410_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_guilty_a_idl.gani",
				specialActionName = "end_of_dct0_guilty_a_idl",
				position = Vector3( -102.240601, 102.175000, -1675.260986 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "dct_p21_010410_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_guilty_b_idl.gani",
				specialActionName = "end_of_dct0_guilty_b_idl",
				position = Vector3( -101.243515, 102.175000, -1668.491943 ),
				idle = true,
				again = true,
			},
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010380_0000", },
			{ func = s10010_sequence.SetUpMob, locatorName = "dct_p21_010410_0000", },
			{ func = s10010_sequence.SetUpMob, locatorName = "dct_p21_010410_0001", },
			{ func = s10010_sequence.SetUpMob, locatorName = "nrs_p21_010410_0000", },
			{ func = s10010_sequence.SetUpMob, locatorName = "nrs_p21_010410_0001", },
			{ func = s10010_sequence.SetUpMob, locatorName = "nrs_p21_010410_0002", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ish_p21_010410_0000", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0000", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0001", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0002", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0003", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0004", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0005", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0006", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0007", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0008", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0009", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0010", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0011", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010410_0012", },
		},
		p21_010380_cutter = {
			{ func = s10010_sequence.CreateEffect, effectName = "FxLocatorGroup_Stairway_0000", },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010380_cypr_lckr001", visible = true, },
		},
		after = {
			
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_OutDark", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_Foot_isolate", enable = false, },
			{ func = s10010_sequence.StopSoundEffect, soundSourceName = "SS_4FFA", },
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 0.61394309997559, rotationY = -85.114204406738, },

			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_a_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_a_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas002_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas002_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas003_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas003_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas004_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas004_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas005_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas005_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas006_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas006_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010380_cypr_door001_door002_close_geom", visible = false, },
		},
	},
	corridor0 = {
		before = {
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_02", },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010380_0000", enable = false, },
			{ func = s10010_sequence.DestroyEffect, effectName = "FxLocatorGroup_Stairway_0000", },
		},
		p21_010410_dooroff = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010410_cypr_grat001_door001_close", visible = false, },
		},
		after = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010410_cypr_grat001_door001_close", visible = true, },
			{	
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_s_dr_patidl.gani",
				specialActionName = "end_of_ish0non_s_dr_patidl",
				override = true,
				again = true,
				position = Vector3( -110.736, 90.136, -1664.226 ),
				rotationY = 0,
			},
		},
	},
	corridor1 = {
	},
	corridor2 = {
	},
	corridor3 = {
	},
	corridor4 = {
	},
	corridor5 = {
	},
	corridor6 = {
		before = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0000", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0001", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0002", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0003", enable = false, },
			{ func = s10010_sequence.StopSceneBGM, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010420_0000", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010420_0001", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010420_0002", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010420_0003", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010420_0004", enable = true, },
		},
		after = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt15_to_pnt17.gani",
				specialActionName = "end_of_ish0non_q_pnt15_to_pnt17",
				position = Vector3( -106.045715, 102.175000, -1669.895264 ),
				rotationY = -90,
				override = true,
				enableCurtain = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt17_idl.gani",
				specialActionName = "end_of_ish0non_q_pnt17_idl",
				idle = true,
				position = Vector3( -111.16212, 102.175, -1666.30211 ),
				rotationY = 90,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_f_ded_be_p.gani",
				specialActionName = "end_of_ptn0_3flor_f_ded_be_p",
				position = Vector3( -101.38001, 102.15, -1652.59064 ),
				rotationY = -38.4766,
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_e_ded_be_p.gani",
				specialActionName = "end_of_ptn0_3flor_e_ded_be_p",
				position = Vector3( -102.71620000, 102.175, -1650.42500000 ),
				rotationY = 360.000,
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0002",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_g_ded_be_p.gani",
				specialActionName = "end_of_ptn0_3flor_g_ded_be_p",
				position = Vector3( -102.62, 102.175, -1652.38700000 ),
				rotationY = 275.444,
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0003",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_c_ded_be_p.gani",
				specialActionName = "end_of_ptn0_3flor_c_ded_be_p",
				position = Vector3( -100.56610000, 102.175, -1649.81200000 ),
				rotationY = 275.444,
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0004",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_d_ded_be_p.gani",
				specialActionName = "end_of_ptn0_3flor_d_ded_be_p",
				position = Vector3( -101.37080000, 102.175, -1651.11300000 ),
				rotationY = 206.961,
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0005",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_b_ded_be_p.gani",
				specialActionName = "end_of_ptn0_3flor_b_ded_be_p",
				position = Vector3( -103.39210000, 102.175, -1647.67300000 ),
				rotationY = 332.536,
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0006",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_a_ded_be_p.gani",
				specialActionName = "end_of_ptn0_3flor_a_ded_be_p",
				position = Vector3( -101.23040000, 102.175, -1648.63200000 ),
				rotationY = 121.114,
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0007",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_a_ded_be_p.gani",
				specialActionName = "end_of_ptn0_3flor_a_ded_be_p",
				position = Vector3( -101.18994, 102.175, -1656.64376 ),
				rotationY = 75.4441,
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0008",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_c_ded_be_p.gani",
				specialActionName = "end_of_ptn0_3flor_c_ded_be_p",
				position = Vector3( -101.65795, 102.175, -1656.99688 ),
				rotationY = -85.4059,
				idle = true,
				again = true,
			},
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0009", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0010", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0011", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0012", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "dct_p21_010410_0000", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "dct_p21_010410_0001", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ish_p21_010410_0000", enable = false, },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "nrs_p21_010410_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_3flor_a_ded_be_p.gani",
				specialActionName = "end_of_nrs0_3flor_a_ded_be_p",
				position = Vector3( -100.81118, 102.175, -1655.81666 ),
				rotationY = 111.6,
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "nrs_p21_010410_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_3flor_b_ded_be_p.gani",
				specialActionName = "end_of_nrs0_3flor_b_ded_be_p",
				position = Vector3( -102.59430000, 102.175, -1658.46900000 ),
				rotationY = 12.250,
				idle = true,
				again = true,
			},
			{ func = s10010_sequence.EnableMob, locatorName = "nrs_p21_010410_0002", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "s10010_l01_sequence_DataIdentifier", key = "GeoTriggerTrap0002", enable = false, },
			{ func = s10010_sequence.ChangePlayerFova, filePath = "/Assets/tpp/fova/chara/sna/sna1_v02.fv2", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010420_0000", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010420_0001", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010420_0002", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010420_0003", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010420_0004", },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = false, },
			{
				func = s10010_sequence.SetMeshVisibility,
				identifier = "cypr_s02_other_DataIdentifier",
				key = "cypr_pssg001_vrtn023_0000",
				meshName = "MESH_blood_IV",
				visible = true,
			},
			{
				func = s10010_sequence.SetMeshVisibility,
				identifier = "cypr_s02_other_DataIdentifier",
				key = "cypr_pssg001_vrtn022_0000",
				meshName = "MESH_blood_IV",
				visible = true,
			},
			{
				func = s10010_sequence.SetMeshVisibility,
				identifier = "cypr_s02_other_DataIdentifier",
				key = "cypr_pssg001_vrtn031_0000",
				meshName = "MESH_blood_IV",
				visible = true,
			},
			{ func = s10010_sequence.PlaySoundEffect, eventName = "sfx_m_cypr_walla_kill_int", singleShot = false, onlyIfSkipped = true, },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_01_idl.gani",
				specialActionName = "end_of_ptn0_cutn_01_idl",
				position = Vector3( -104.8328, 102.9841, -1660.197 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_02_idl.gani",
				specialActionName = "end_of_ptn0_cutn_02_idl",
				position = Vector3( -104.8194,102.9841,-1664.037 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0002",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_03_idl.gani",
				specialActionName = "end_of_ptn0_cutn_03_idl",
				position = Vector3( -110.7841,102.9841,-1663.856 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0003",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_01_idl.gani",
				specialActionName = "end_of_ptn0_cutn_01_idl",
				position = Vector3( -104.7958,102.9841,-1667.789 ),
				idle = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0004",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_02_idl.gani",
				specialActionName = "end_of_ptn0_cutn_02_idl",
				position = Vector3( -110.8451,102.9841,-1667.285 ),
				idle = true,
				again = true,
			},
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010410_0000", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010410_0001", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010410_0002", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010410_0003", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010410_0004", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010410_0005", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010410_0006", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010410_0007", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010410_0008", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "nrs_p21_010410_0000", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "nrs_p21_010410_0001", },
		},
	},
	corridor7 = {
		Play = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010420_0000", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010420_0001", enable = true, },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010420_0000", sneakRouteName = "rts_skull_curtain_0015", },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010420_0001", sneakRouteName = "rts_skull_curtain_0016", },
		},
		p21_010420_01_closedoor = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_open", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_close", visible = true, },
		},
		after = {
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 11.770016670227, rotationY = -82.149932861328, },
		},
	},
	load6 = {
		before = {
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_3rd_floor", },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_strt001", visible = false, },
		},
		after = {
			{ func = s10010_sequence.RealizeVolgin, realize = false, },
		},
	},
	curtainKill1 = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_01_ded.gani",
				specialActionName = "end_of_ptn0_cutn_01_ded",
				position = Vector3( -104.8328, 102.9841, -1660.197 ),
				idle = true,
				again = true,
			},
		},
		after = {
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010420_0000", },
		},
	},
	curtainKill2 = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_02_ded.gani",
				specialActionName = "end_of_ptn0_cutn_02_ded",
				position = Vector3( -104.8194,102.9841,-1664.037 ),
				idle = true,
				again = true,
			},
		},
		after = {
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010420_0001", },
		},
	},
	curtainKill3 = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0002",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_03_ded.gani",
				specialActionName = "end_of_ptn0_cutn_03_ded",
				position = Vector3( -110.7841,102.9841,-1663.856 ),
				idle = true,
				again = true,
			},
		},
		after = {
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010420_0002", },
		},
	},
	curtainKill4 = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0003",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_01_ded.gani",
				specialActionName = "end_of_ptn0_cutn_01_ded",
				position = Vector3( -104.7958,102.9841,-1667.789 ),
				idle = true,
				again = true,
			},
		},
		after = {
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010420_0003", },
		},
	},
	curtainRoom = {
		before = {
			{ func = s10010_sequence.ProhibitMoveOnSubEvent, enable = true, },
		},
		Play = {
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s02_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/02/cypr_02_asset.fox2",
				locatorName = "cypr_crtn001_vrtn013_gim_n0001|srt_cypr_crtn001_vrtn013",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s02_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_DOOR,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/02/cypr_02_asset.fox2",
				locatorName = "cypr_crtn001_vrtn014_gim_n0000|srt_cypr_crtn001_vrtn014",
				visible = false,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s02_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_DOOR,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/02/cypr_02_asset.fox2",
				locatorName = "cypr_crtn001_vrtn015_gim_n0001|srt_cypr_crtn001_vrtn015",
				visible = false,
			},
		},
		p21_010420_breakcurtainon = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_cypr_crtn001_vrtn016_an", visible = true, },
		},
		after = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_01_ded_p.gani",
				specialActionName = "end_of_ptn0_cutn_01_ded_p",
				position = Vector3( -104.8328, 102.9841, -1660.197 ),
				idle = true,
				override = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_02_ded_p.gani",
				specialActionName = "end_of_ptn0_cutn_02_ded_p",
				position = Vector3( -104.8194,102.9841,-1664.037 ),
				idle = true,
				override = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0002",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_03_ded_p.gani",
				specialActionName = "end_of_ptn0_cutn_03_ded_p",
				position = Vector3( -110.7841,102.9841,-1663.856 ),
				idle = true,
				override = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0003",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_01_ded_p.gani",
				specialActionName = "end_of_ptn0_cutn_01_ded_p",
				position = Vector3( -104.7958,102.9841,-1667.789 ),
				idle = true,
				override = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010420_0004",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_02_ded_p.gani",
				specialActionName = "end_of_ptn0_cutn_02_ded_p",
				position = Vector3( -110.728, 102.175, -1668.916 ),
				rotationY = 45,
				idle = true,
				override = true,
				again = true,
			},
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010420_0004", },
		},
	},
	curtainRoom2 = {
		before = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_open", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_halfopen", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_close", visible = false, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s02_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_DOOR,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/02/cypr_02_asset.fox2",
				locatorName = "cypr_crtn001_vrtn014_gim_n0000|srt_cypr_crtn001_vrtn014",
				visible = true,
			},
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s02_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_DOOR,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/02/cypr_02_asset.fox2",
				locatorName = "cypr_crtn001_vrtn015_gim_n0001|srt_cypr_crtn001_vrtn015",
				visible = false,
			},
		},
		p21_010420_curtainon = {
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s02_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_DOOR,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/02/cypr_02_asset.fox2",
				locatorName = "cypr_crtn001_vrtn015_gim_n0001|srt_cypr_crtn001_vrtn015",
				visible = true,
			},
		},
		p21_010420_padon = {
			{ func = s10010_sequence.ProhibitMoveOnSubEvent, enable = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_b_open", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_b_close", visible = false, },
			{ func = s10010_sequence.StopSceneBGM, },
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_3rd_floor_02", },
		},
		after = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_open", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_halfopen", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_close", visible = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0000", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0001", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0002", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0003", enable = true, },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010420_0000", sneakRouteName = "rts_skull_curtain_0017", },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010420_0001", sneakRouteName = "rts_skull_curtain_0018", },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010440_0000", sneakRouteName = "rts_skull_corridor_0010", },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010440_0001", sneakRouteName = "rts_skull_corridor_0011", },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010440_0002", sneakRouteName = "rts_skull_corridor_0008", },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010440_0003", sneakRouteName = "rts_skull_corridor_0009", },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_idl_l.gani",
				specialActionName = "end_of_ish0non_q_pnt19_idl",
				position = Vector3( -104.9, 102.175, -1655.03 ),
				rotationY = 90,
				idle = true,
				override = true,
				again = true,
			},
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = -2.6158754825592, rotationY = 40.947296142578, },
		},
	},
	enterCorridor = {
		before = {
		},
	},
	volginVsSkullSoldier = {
		before = {
			{ func = s10010_sequence.StopSceneBGM, },
			{ func = s10010_sequence.RealizeVolgin, realize = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010420_0000", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010420_0001", enable = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_open", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_halfopen", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010420_door003_door001_a_close", visible = true, },

			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_a_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_a_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas002_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas002_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas003_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas003_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas004_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas004_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas005_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas005_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas006_b_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas006_b_after", visible = false, },
		},
		p21_010440_breakwindow = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_a_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_a_after", visible = true, },
		},
		p21_010440_volginattack = {
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "cypr_pssg001_vrtn023_0000", meshName = "MESH_bullet_after_IV", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_afgh_pctr001_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_afgh_pctr001_after", visible = true, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "cypr_pssg001_vrtn031_0000", meshName = "MESH_bullet_after_IV", visible = true, },
		},
		p21_010440_heliattack01 = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_b_after", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas002_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas002_b_after", visible = true, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "cypr_pssg001_vrtn031_0000", meshName = "MESH_bullet_a_before", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "cypr_pssg001_vrtn031_0000", meshName = "MESH_bullet_a_after_IV", visible = true, },
		},
		p21_010440_heliattack02 = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas003_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas003_b_after", visible = true, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "cypr_pssg001_vrtn031_0000", meshName = "MESH_bullet_b_before", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "cypr_pssg001_vrtn031_0000", meshName = "MESH_bullet_b_after_IV", visible = true, },
		},
		p21_010440_heliattack03 = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas004_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas004_b_after", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas006_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas006_b_after", visible = true, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "cypr_pssg001_vrtn031_0000", meshName = "MESH_bullet_c_before", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "cypr_pssg001_vrtn031_0000", meshName = "MESH_bullet_c_after_IV", visible = true, },
		},
		p21_010440_heliattack04 = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas005_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas005_b_after", visible = true, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "cypr_pssg001_vrtn031_0000", meshName = "MESH_bullet_d_after_IV", visible = true, },
		},
		p21_010440_breakwall = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_common_other_DataIdentifier", key = "p21_010440_cypr_buld001_wall004_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_passage_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_passage_after", visible = true, },

			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_a_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas002_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas003_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas004_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas005_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas006_b_after", visible = false, },
		},
		p21_010440_breakspkr = {
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_pipe001_sprk001", meshName = "MESH_before", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_pipe001_sprk001", meshName = "MESH_break_IV", visible = true, },
		},
		p21_010440_corpse_on = {
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_corridor_0000", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0000", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0001", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0002", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010380_0003", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0000", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0001", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0002", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0003", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0006", enable = false, },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_a_ded_af_p.gani",
				specialActionName = "end_of_ptn0_3flor_a_ded_af_p",
				position = Vector3( -100.612083, 102.175, -1659.982910 ),
				rotationY = 80.6289,
				idle = true,
				again = true,
				interpFrame = 0,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_e_ded_af_p.gani",
				specialActionName = "end_of_ptn0_3flor_e_ded_af_p",
				position = Vector3( -102.55, 102.2, -1668.911987 ),
				rotationY = 8.8371,
				idle = true,
				again = true,
				interpFrame = 0,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0002",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_g_ded_af_p.gani",
				specialActionName = "end_of_ptn0_3flor_g_ded_af_p",
				position = Vector3( -100.821304, 102.175, -1667.776001 ),
				rotationY = -80.5559,
				idle = true,
				again = true,
				interpFrame = 0,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0003",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_c_ded_af_p.gani",
				specialActionName = "end_of_ptn0_3flor_c_ded_af_p",
				position = Vector3( -100.60, 102.175, -1666.280762 ),
				rotationY = -40.5559,
				idle = true,
				again = true,
				interpFrame = 0,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0004",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_d_ded_af_p.gani",
				specialActionName = "end_of_ptn0_3flor_d_ded_af_p",
				position = Vector3( -100.907661, 102.21, -1664.016724 ),
				rotationY = 36.9614,
				idle = true,
				again = true,
				interpFrame = 0,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010410_0005",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_3flor_a_ded_af_p.gani",
				specialActionName = "end_of_ptn0_3flor_a_ded_af_p",
				position = Vector3( -101.2, 102.175, -1661.997925 ),
				rotationY = 131.1141,
				idle = true,
				again = true,
				interpFrame = 0,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "nrs_p21_010410_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_3flor_a_ded_af_p.gani",
				specialActionName = "end_of_nrs0_3flor_a_ded_af_p",
				position = Vector3( -100.908852, 102.175, -1669.921265 ),
				rotationY = 90.0,
				idle = true,
				again = true,
				interpFrame = 0,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "nrs_p21_010410_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_3flor_b_ded_af_p.gani",
				specialActionName = "end_of_nrs0_3flor_b_ded_af_p",
				position = Vector3( -102.2, 102.175, -1656.689331 ),
				rotationY = 12.25,
				idle = true,
				again = true,
				interpFrame = 0,
			},
		},
		after = {
			
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010420_0000", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010420_0001", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010420_0002", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010420_0003", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010420_0004", enable = false, },
			{ func = s10010_sequence.SetInjury, type = 1, },
			{ func = s10010_sequence.RealizeVolgin, realize = false, },
			{ func = s10010_sequence.SetNpcEquipId, locatorName = "ishmael", primaryEquipId = "EQP_WP_West_hg_020", },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt22_cure.gani",
				specialActionName = "end_of_ish0non_q_pnt22_cure",
				position = Vector3( -101.55172, 102.175, -1674.91001 ),
				rotationY = 0,
			},
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireOFF", enable = true, },
			{ func = s10010_sequence.PlaySoundEffect, soundSourceName = "SS_3FFA", eventName = "sfx_m_cypr_fire_siren", },
			{ func = s10010_sequence.CreateEffect, effectName = "2Fto1F", },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "2Fto1F", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010410_cypr_grat001_door001_open", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_grat001_door001_close_coll", visible = true, },
			{ func = s10010_sequence.PlaySoundEffect, eventName = "sfx_m_cypr_8_int", singleShot = false, onlyIfSkipped = true, },
			{
				func = s10010_sequence.SetDisabledPlayerAction,
				value = PlayerDisableAction.STEALTHASSIST +
					PlayerDisableAction.REFLEXMODE +
					PlayerDisableAction.CARRY +
					PlayerDisableAction.FULTON +
					PlayerDisableAction.MARKING +
					PlayerDisableAction.RIDE_VEHICLE +
					PlayerDisableAction.BINOCLE +
					PlayerDisableAction.CQC +
					PlayerDisableAction.OPEN_EQUIP_MENU,
			},
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "cypr_star001_flor001_0000", meshName = "MESH_blood_IV", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_a_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_a_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas001_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas002_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas002_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas003_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas003_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas004_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas004_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas005_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas005_b_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas006_b_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_wndw001_glas006_b_after", visible = false, },
			{ func = s10010_sequence.DestroyEffect, effectName = "cyprus_3F_0001", },
			{ func = s10010_sequence.DestroyEffect, effectName = "cyprus_3F_0005", },
			{ func = s10010_sequence.CreateEffect, effectName = "DemoEnd_001", },
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 12.619423866272, rotationY = 13.540781021118, },
		},
	},
	load7 = {
		after = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010490_0000", enable = true, },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010490_0000", sneakRouteName = "rts_skull_2F_0000", },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010490_0003", enable = true, },
			{ func = s10010_sequence.ChangeEnemyRoute, locatorName = "sol_p21_010490_0003", sneakRouteName = "rts_skull_2F_0006", },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_All_isolate", enable = true, },
		},
	},
	cureGame = {
		before = {
		},
		cureSuccess = {
			{ func = s10010_sequence.CureIfSkipped, cure = true, },
		},
		after = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010410_cypr_grat001_door001_close", visible = false, },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt22_d2g_02.gani",
				specialActionName = "end_of_ish0non_q_pnt22_d2g_02",
				override = true,
				enableGunFire = true,
				position = Vector3( -101.55172, 102.175, -1674.91001 ),
				rotationY = 0,
			},
			{
				func = s10010_sequence.BreakGimmick,
				locatorName = "cypr_grat001_ev_gim_n0000|srt_cypr_grat001_ev",
				datasetPath = "/Assets/tpp/level/location/cypr/block_small/02/cypr_02_asset.fox2",
			},
		},
	},
	open3fDoor = {
		before = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s02_other_DataIdentifier", key = "p21_010440_cypr_grat001_door001_close_coll", visible = false, },
		},
	},
	bgmChange2f = {
		before = {
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_stairs_02", },
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_01", },
		},
		after = {
		},
	},
	enter2F = {
		before = {
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_l01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_large/block_l_stage_01/cypr_l_stage_01_env.fox2",
				locatorName = "cypr_door001_door002_ev_gim_n0000|srt_cypr_door001_door002_ev",
				visible = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt26_to_pnt27.gani",
				specialActionName = "end_of_ish0non_q_pnt26_to_pnt27",
				position = Vector3( -100.44339, 98.175, -1683.60173 ),
				rotationY = 180,
				OnStart = function()
					s10010_sequence.BreakGimmick( {
						locatorName = "cypr_door001_door002_ev_gim_n0000|srt_cypr_door001_door002_ev",
						datasetPath = "/Assets/tpp/level/location/cypr/block_large/block_l_stage_01/cypr_l_stage_01_env.fox2",
					}, true, false )
					s10010_sequence.PlaySoundEffect( { func = s10010_sequence.PlaySoundEffect, soundSourceName = "SS_DOOR4", eventName = "sfx_m_cypr_door4", singleShot = true, }, true, false )
				end,
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010480_cypr_door001_door002_close", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010480_cypr_door001_door002_close_geom", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010480_cypr_door001_door002_open", visible = true, },
		},
		after = {
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_02", },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_l01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_large/block_l_stage_01/cypr_l_stage_01_env.fox2",
				locatorName = "cypr_door001_door002_ev_gim_n0000|srt_cypr_door001_door002_ev",
				visible = false,
			},
		},
	},
	close2fDoor = {
		before = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010480_cypr_door001_door002_close_geom", visible = false, },
		},
	},
	enemy2fAppear = {
		before = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt27_fre.gani",
				specialActionName = "end_of_ish0non_q_pnt27_fre",
				enableGunFire = true,
				position = Vector3( -99.44943, 98.175, -1691.38935 ),
				rotationY = 180,
			},
		},
	},
	enemy2fDown = {
		before = {
			{ func = s10010_sequence.StopSceneBGM, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0000", enable = true, },
			
		},
	},
	getGun = {
		before = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010480_cypr_door001_door002_open", visible = true, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_l01_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_large/block_l_stage_01/cypr_l_stage_01_env.fox2",
				locatorName = "cypr_door001_door002_ev_gim_n0000|srt_cypr_door001_door002_ev",
				visible = false,
			},
			{ func = s10010_sequence.EnableMob, locatorName = "dct_p21_010410_0000", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "dct_p21_010410_0001", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "nrs_p21_010410_0000", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "nrs_p21_010410_0001", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "nrs_p21_010410_0002", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0000", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0001", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0002", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0003", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0004", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0005", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0006", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0007", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0008", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0009", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0010", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0011", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010410_0012", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0000", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0001", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0002", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010440_0003", enable = false, },
			{ func = s10010_sequence.DestroyEffect, effectName = "cyprus_3F_0001", },
			{ func = s10010_sequence.DestroyEffect, effectName = "cyprus_3F_0005", },
			
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_OutDark", enable = false, },
		},
		p21_010490_IshRouteStart = {
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt28_to_pnt29.gani",
				specialActionName = "end_of_ish0non_q_pnt28_to_pnt29",
				position = Vector3( -100.77626, 98.15912, -1704.02373 ),
				rotationY = 7.9698,
				override = true,
			},
		},
		p21_010490_EneChange = {
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0000", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_corridor_0000", enable = false, },
		},
		p21_010490_CloseDoor = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010480_cypr_door001_door002_close", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_l01_other_DataIdentifier", key = "p21_010480_cypr_door001_door002_open", visible = false, },
		},
		after = {
			
			{ func = s10010_sequence.ChangePlayerEquip, equipId = "EQP_WP_West_hg_020", stock = 63, ammo = 7, isSuppressorOn = true, suppressorLife = 100, toActive = true, },

			
			{ func = s10010_sequence.CreateEffect, effectName = "cyprus_1F_2F_0000", },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "cyprus_1F_2F_0000", visible = true, },
			{ func = s10010_sequence.CreateEffect, effectName = "DemoOn", },

			
			{ func = s10010_sequence.EnableUI, uiName = "equipUi", enable = true, },
			{ func = s10010_sequence.EnableUI, uiName = "EquipHud", enable = true, },
			{ func = s10010_sequence.SetPlayerMotionSpeed, motionSpeed = 1.0, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010490_0000", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010490_0003", enable = false, },
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_fire", },
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_01", },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireOFF", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireON", enable = true, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_1F_Entr_isolate", enable = true, },
			
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_2f_0000", enable = true, },
			{ func = s10010_sequence.PlaySoundEffect, soundSourceName = "SS_2FFA", eventName = "sfx_m_cypr_fire_siren", },
			{ func = s10010_sequence.StopSoundEffect, soundSourceName = "SS_3FFA", },
			{ func = s10010_sequence.EnablePadMaskBeforeGetGunOnSubEvent, enable = false, },
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 0.12678594887257, rotationY = 0.61936151981354, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s03_other_DataIdentifier", key = "cypr_door001_door002_close_geom_0001", visible = false, },
		},
	},
	load8 = {
		after = {
			{ func = s10010_sequence.RealizeVolgin, realize = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010490_0001", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010490_0002", enable = true, },
			{ func = s10010_sequence.ChangeEnemyRoute, sneakRouteName = "rts_skull_2F_0004", locatorName = "sol_p21_010490_0001", },
			{ func = s10010_sequence.ChangeEnemyRoute, sneakRouteName = "rts_skull_2F_0005", locatorName = "sol_p21_010490_0002", },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0000", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0001", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0002", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0003", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0004", enable = true, },
		},
	},
	twoEnemyAppear = {
		before = {
			{ func = s10010_sequence.ChangeEnemyRoute, sneakRouteName = "rts_skull_2F_0001", locatorName = "sol_p21_010490_0001", },
			{ func = s10010_sequence.ChangeEnemyRoute, sneakRouteName = "rts_skull_2F_0002", locatorName = "sol_p21_010490_0002", },
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ishmael",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ish0/ish0non/ish0non_q_pnt30_to_pnt31.gani",
				specialActionName = "end_of_ish0non_q_pnt30_to_pnt31",
				override = true,
				position = Vector3( -100.75936, 98.17499, -1714.75637 ),
				rotationY = 180,
			},
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_shoot_him", },
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_01", },
		},
	},
	twoEnemyDown = {
		before = {
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_02", },
		},
	},
	toEntrance = {
		before = {
			{ func = s10010_sequence.StopSceneBGM, },
		},
		after = {
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010500_0000", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010500_0001", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010500_0002", enable = true, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010500_0003", enable = true, },
		},
	},
	entrance = {
		before = {
			{ func = s10010_sequence.SetWeatherTag, tag = "default", },
			{ func = s10010_sequence.SetNpcEquipId, locatorName = "ishmael", primaryEquipId = "EQP_None", },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010490_0001", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010490_0002", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0006", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0007", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0008", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0009", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0010", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0011", enable = true, },
			{ func = s10010_sequence.ChangeEnemyRoute, sneakRouteName = "rts_skull_after_p21_010500_d_0000", cautionRouteName = "rts_skull_after_p21_010500_c_0000", locatorName = "sol_p21_010500_0006", },
			{ func = s10010_sequence.ChangeEnemyRoute, sneakRouteName = "rts_skull_after_p21_010500_d_0001", cautionRouteName = "rts_skull_after_p21_010500_c_0001", locatorName = "sol_p21_010500_0007", },
			{ func = s10010_sequence.ChangeEnemyRoute, sneakRouteName = "rts_skull_after_p21_010500_d_0002", cautionRouteName = "rts_skull_after_p21_010500_c_0002", locatorName = "sol_p21_010500_0008", },
			{ func = s10010_sequence.ChangeEnemyRoute, sneakRouteName = "rts_skull_after_p21_010500_d_0003", cautionRouteName = "rts_skull_after_p21_010500_c_0003", locatorName = "sol_p21_010500_0009", },
			{ func = s10010_sequence.ChangeEnemyRoute, sneakRouteName = "rts_skull_after_p21_010500_d_0004", cautionRouteName = "rts_skull_after_p21_010500_c_0004", locatorName = "sol_p21_010500_0010", },
			{ func = s10010_sequence.ChangeEnemyRoute, sneakRouteName = "rts_skull_after_p21_010500_d_0005", cautionRouteName = "rts_skull_after_p21_010500_c_0005", locatorName = "sol_p21_010500_0011", },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_2f_0000", enable = false, },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010500_0000", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010500_0001", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010500_0002", },
			{ func = s10010_sequence.SetUpMob, locatorName = "ptn_p21_010500_0003", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010500_0000", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010500_0001", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010500_0002", },
			{ func = s10010_sequence.SetBloodStain, locatorName = "ptn_p21_010500_0003", },
			{ func = s10010_sequence.DestroyEffect, effectName = "DemoOn", },
			{ func = s10010_sequence.DestroyEffect, effectName = "FxLocatorGroup_Effect2fFire_0000", },
			{ func = s10010_sequence.DestroyEffect, effectName = "cyprus_2F_fire_0000", },
			
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_4F_OutDark", enable = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_uth0_geom", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010520_uth0_geom", visible = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_OutDoor", enable = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_wndw002_before", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_wndw002_after", visible = false, },
			{ func = s10010_sequence.DestroyEffect, effectName = "DemoEnd_001", },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "2Fto1F", visible = false, },
			{ func = s10010_sequence.DestroyEffect, effectName = "2Fto1F", },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD", visible = false, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD_Turbulence", visible = false, },
			{ func = s10010_sequence.DestroyEffect, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD", },
			{ func = s10010_sequence.DestroyEffect, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD_Turbulence", },
		},
		after = {
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010500_0006", puppet = false, },
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010500_0007", puppet = false, },
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010500_0008", puppet = false, },
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010500_0009", puppet = false, },
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010500_0010", puppet = false, },
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010500_0011", puppet = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "ishmael", enable = false, },
			{
				func = s10010_sequence.SetDisabledPlayerAction,
				value = PlayerDisableAction.STEALTHASSIST +
					PlayerDisableAction.CARRY +
					PlayerDisableAction.FULTON +
					PlayerDisableAction.RIDE_VEHICLE +
					PlayerDisableAction.BINOCLE +
					PlayerDisableAction.CQC +
					PlayerDisableAction.OPEN_EQUIP_MENU,
			},
			{ func = s10010_sequence.EnablePadMaskNormalOnSubEvent, enable = false, },
			{ func = s10010_sequence.EnablePadMaskCombatOnSubEvent, enable = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010500_cypr_door002_open", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010500_cypr_door002_close", visible = true, },
			{ func = s10010_sequence.SetPhaseBGM, phaseTag = "bgm_hospital_lobby", },
			{ func = s10010_sequence.SetNpcEquipId, locatorName = "ishmael", primaryEquipId = "EQP_None", },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_common_other_DataIdentifier", key = "cypr_pssg001_dsvw001", visible = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0005", enable = true, },
			{ func = s10010_sequence.StopSoundEffect, soundSourceName = "SS_2FFA", },
			
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010500_0000",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_entra_a_ded_p.gani",
				specialActionName = "end_of_ptn0_entra_a_ded_p",
				position = Vector3( -70.2, 94.200, -1706.4 ),
				rotationY = -151.1,
				override = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010500_0001",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_entra_b_ded_p.gani",
				specialActionName = "end_of_ptn0_entra_b_ded_p",
				position = Vector3( -70.6, 94.205, -1704.1 ),
				rotationY = 28.5,
				override = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010500_0002",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_entra_c_ded_p.gani",
				specialActionName = "end_of_ptn0_entra_c_ded_p",
				position = Vector3( -72.000, 94.205, -1704.3 ),
				rotationY = -139.7,
				override = true,
				again = true,
			},
			{
				func = s10010_sequence.PushMotionOnSubEvent,
				locatorName = "ptn_p21_010500_0003",
				motionPath = "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_entra_d_ded_p.gani",
				specialActionName = "end_of_ptn0_entra_d_ded_p",
				position = Vector3( -71.1, 94.215, -1705.5 ),
				rotationY = 64.8,
				override = true,
				again = true,
			},
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 23.748027801514, rotationY = 77.340042114258, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_All_isolate", enable = false },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireON", enable = false },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireOFF", enable = false },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_1F_Entr_isolate", enable = true, },
			{ func = s10010_sequence.CreateEffect, effectName = "FxLocatorGroup_1F_2F_0000", },
			{ func = s10010_sequence.SetLocalReflectionEnabled, enabled = false, },
		},
	},
	load9 = {
		after = {
			{ func = s10010_sequence.RealizeVolgin, realize = false, },
		},
	},
	ambulance = {
		before = {
			{ func = s10010_sequence.RealizeVolgin, realize = true, },
			{ func = s10010_sequence.WarpVolgin, identifier = "CheckPointIdentifier", key = "warp_volginInEntrance0001", },
			{ func = s10010_sequence.ChangeVolginRoute, routeName = "rts_volgin_entrance0000", },
			{ func = s10010_sequence.EnableEnemy, locatorName = "ishmael", enable = true, },
			{ func = s10010_sequence.RespawnVehicle, locatorName = "veh_p21_010510_0000", respawn = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0000", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0001", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0002", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0003", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0004", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_0005", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0000", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0001", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0002", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0003", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0004", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0005", enable = true, },
		},
		p21_010510_enemychange = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0006", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0007", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0008", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0009", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0010", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0011", enable = false, },
		},
		p21_010510_BreakExit = {
			{ func = s10010_sequence.BreakGimmick, locatorName = "cypr_entr001_rbbl001_gim_n0000|srt_cypr_entr001_rbbl001", datasetPath = "/Assets/tpp/level/location/cypr/block_small/04/cypr_04_asset.fox2", },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_common_other_DataIdentifier", key = "p21_010510_cypr_entr001_vrtn001", meshName = "MESH_before", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_common_other_DataIdentifier", key = "p21_010510_cypr_entr001_vrtn001", meshName = "MESH_break_IV", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_entr001_vrtn002", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_after", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_add_rubble", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_entrance_recoil_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_entrance_recoil_after", visible = true, },
		},
		p21_010510_BreakDoor = {
			{ func = s10010_sequence.BreakGimmick, locatorName = "cypr_door006_rbbl001_gim_n0000|srt_cypr_door006_rbbl001", datasetPath = "/Assets/tpp/level/location/cypr/block_small/04/cypr_04_asset.fox2", },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_common_other_DataIdentifier", key = "p21_010510_cypr_door006_drfr001", meshName = "MESH_before", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_common_other_DataIdentifier", key = "p21_010510_cypr_door006_drfr001", meshName = "MESH_break_IV", visible = true, },
		},
		p21_010510_GlassDestruction = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_wndw002_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_wndw002_after", visible = true, },
		},
		after = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_uth0_geom", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010520_uth0_geom", visible = false, },
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_volgin", },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0000", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0001", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0002", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0003", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0004", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010500_0005", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0000", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0001", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0002", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0003", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0004", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0005", enable = true, },
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 2.8415968418121, rotationY = 137.22998046875, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_1F_Entr_isolate", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "ishmael", enable = false, },
		},
	},
	heliRotor = {
		before = {
			{ func = s10010_sequence.StopSceneBGM, },
		},
		Play = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0000", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0001", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0002", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0003", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0004", enable = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0005", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0000", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0001", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0002", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0003", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0004", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0005", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010500_0000", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010500_0001", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010500_0002", enable = false, },
			{ func = s10010_sequence.EnableMob, locatorName = "ptn_p21_010500_0003", enable = false, },
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010520_0000", puppet = true, },
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010520_0001", puppet = true, },
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010520_0002", puppet = true, },
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010520_0003", puppet = true, },
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010520_0004", puppet = true, },
			{ func = s10010_sequence.SetEnemyPuppet, locatorName = "sol_p21_010520_0005", puppet = true, },
		},
		p21_010520_breakhelioff = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010540_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_uth0_geom", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_after", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_add_rubble", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_pillar_recoil_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_pillar_recoil_after", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_wndw002_after", visible = false, },
		},
		p21_010520_BreakPillar = {
			{
				func = s10010_sequence.BreakGimmick,
				locatorName = "cypr_hall001_rbbl001_gim_n0000|srt_cypr_hall001_rbbl001",
				datasetPath = "/Assets/tpp/level/location/cypr/block_small/04/cypr_04_asset.fox2",
			},
			{
				func = s10010_sequence.BreakGimmick,
				locatorName = "cypr_hall001_rbbl002_gim_n0000|srt_cypr_hall001_rbbl002",
				datasetPath = "/Assets/tpp/level/location/cypr/block_small/04/cypr_04_asset.fox2",
			},
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_wndw002_vrtn001_gm", meshName = "MESH_before", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_wndw002_vrtn001_gm", meshName = "MESH_break_IV", visible = true, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_wndw002_vrtn002_gm", meshName = "MESH_before", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_wndw002_vrtn002_gm", meshName = "MESH_break_IV", visible = true, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_hall001_pllr021", meshName = "MESH_before", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_hall001_pllr021", meshName = "MESH_break_IV", visible = true, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_hall001_pllr011", meshName = "MESH_before", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_hall001_pllr011", meshName = "MESH_break_IV", visible = true, },
		},
		p21_010520_RubbleOn = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010540_after", visible = true, },
		},
		after = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_uth0_geom", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010520_uth0_geom", visible = true, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0000", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0001", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0002", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0003", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0004", enable = false, },
			{ func = s10010_sequence.EnableEnemy, locatorName = "sol_p21_010520_0005", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0006", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0007", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0008", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0009", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0010", enable = true, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0011", enable = true, },
			{ func = s10010_sequence.CreateEffect, effectName = "Demo_End", },
			{ func = s10010_sequence.PlaySoundEffect, eventName = "sfx_m_cypr_9_int", singleShot = false, onlyIfSkipped = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_hall001_pllr012", visible = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "p21_010510_cypr_hall001_pllr022", visible = true, },
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 2.2590324878693, rotationY = 115.59019470215, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_1F_Entr_isolate", enable = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s04_other_DataIdentifier", key = "after_p21_010520", visible = true, },
		},
	},
	escapeFromEntrance = {
		before = {
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_All_Foot_isolate", enable = false },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Slope_Foot_isolate", enable = false },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_3F_All_isolate", enable = false },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0006", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0007", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0008", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0009", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0010", enable = false, },
			{ func = s10010_sequence.EnableCorpse, locatorName = "corpse_entrance_0011", enable = false, },
		},
		after = {
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_2F_FireON", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_1F_Entr_isolate", enable = false, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_OutDoor", enable = true, },
			{ func = s10010_sequence.DestroyEffect, effectName = "Demo_End", },
		},
	},
	load10 = {
		before = {
			{ func = s10010_sequence.RespawnVehicle, locatorName = "veh_p21_010510_0000", respawn = false, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_cldcypInside", visible = false, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_cldcypOutside", visible = true, },
		},
	},
	escapeFromHospital = {
		before = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "ishmael", enable = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_common_other_DataIdentifier", key = "p21_010550_cypr_hall001_marg001", visible = true, },
			{ func = s10010_sequence.UnsetEquip, slot = PlayerSlotType.SECONDARY, },
		},
		Play = {
			{ func = s10010_sequence.StartVolginShooting, },
		},
		p21_020010_ShootVolginStart = {
		},
		p21_020010_ShootVolginEnd = {
		},
		p21_020010_hospwall_brk_on = {
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_common_other_DataIdentifier", key = "p21_010550_buld001_wall_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_common_other_DataIdentifier", key = "p21_010550_buld001_wall_after", visible = true, },
		},
		p21_020010_breakTunnel = {
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s06_other_DataIdentifier", key = "cypr_tnnl001_0000", meshName = "MESH_before", visible = false, },
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s06_other_DataIdentifier", key = "cypr_tnnl001_0000", meshName = "MESH_after_IV", visible = true, },
			{
				func = s10010_sequence.SetGimmickVisibility,
				identifier = "cypr_s05_other_DataIdentifier",
				type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION,
				datasetName = "/Assets/tpp/level/location/cypr/block_small/05/cypr_05_asset.fox2",
				locatorName = "cypr_tnnl001_gim_n0000|srt_cypr_tnnl001",
				visible = true,
			},
			{
				func = s10010_sequence.BreakGimmick,
				locatorName = "cypr_tnnl001_gim_n0000|srt_cypr_tnnl001",
				datasetPath = "/Assets/tpp/level/location/cypr/block_small/05/cypr_05_asset.fox2",
			},
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s05_other_DataIdentifier", key = "p21_020010_tunnel_before", visible = false, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s05_other_DataIdentifier", key = "p21_020010_tunnel_after", visible = true, },
		},
		after = {
			{ func = s10010_sequence.UnsetEquip, slot = PlayerSlotType.SECONDARY, },
			{ func = s10010_sequence.StopVolginShooting, },
		},
	},
	load11 = {
		before = {
		},
		after = {
			{ func = s10010_sequence.SetSceneReflectionParameter, texturePath = "/Assets/tpp/common_source/cubemap/environ/cyprus/cm_cypr_cb_road001/sourceimages/cm_cypr_cb_road001_cbm.ftex", },
		},
	},
	fireWhale = {
		before = {
			{ func = s10010_sequence.EnableEnemy, locatorName = "ishmael", enable = false, },
			{ func = s10010_sequence.ChangePlayerFova, filePath = "/Assets/tpp/fova/chara/sna/sna1_v04.fv2", },
		},
		p21_020030_ChangeGameMotVol = {
			{ func = s10010_sequence.ChangeHorseRoute, locatorName = "volgin_horse", routeName = "rts_volgin_start", warp = false, },
		},
		p21_020030_ChangeGameMot = {
			{ func = s10010_sequence.StartVolginRide, },
			{ func = s10010_sequence.ChangeHorseRoute, locatorName = "ocelot_horse", routeName = "rts_ocelotHorce", warp = false, },
		},
		after = {
			
			{ func = s10010_sequence.SetSceneBGM, bgmName = "bgm_volgin_ride", },
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_02", },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_common_other_DataIdentifier", key = "p21_010550_cypr_window004_before", visible = false, },
			{ func = s10010_sequence.SetInitialCameraRotation, rotationX = 13.529998779297, rotationY = 150.38847351074, },
			{ func = s10010_sequence.SetLocationTelopLangId, locationTelopIndex = 2, },
		},
	},
	passportPhotograph = {
		before = {
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD", visible = false, },
		},
		after = {
		},
	},
	fireWhaleTruth = {
		before = {
			{ func = s10010_sequence.ChangePlayerFova, filePath = "/Assets/tpp/fova/chara/sna/sna1_v04.fv2", },
		},
		Play = {
		},
		after = {
			{ func = s10010_sequence.SetEffectVisibility, effectName = "FxLocatorGroup_fx_tpp_dstwhtviw01_s2VD", visible = true, },
		},
	},
	twoBigBoss = {
		before = {
			{ func = s10010_sequence.SetSceneReflectionParameter, texturePath = "/Assets/tpp/common_source/cubemap/environ/mother_base/cm_mtbs_room002/sourceimages/cm_mtbs_room002_cbm.ftex", },
		},
	},
	volginRideStart = {
		before = {
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s08_other_DataIdentifier", key = "cypr_brdg001_0000", meshName = "MESH_before_IV", visible = true, },
		},
	},
	treeDown0000 = {
		before = {
			{
				func = s10010_sequence.BreakGimmick,
				locatorName = "cypr_tree009_anim001_gim_n0001|srt_cypr_tree009_anim001",
				datasetPath = "/Assets/tpp/level/location/cypr/block_small/08/cypr_08_asset.fox2",
			},
		},
	},
	treeDown0001 = {
		before = {
			{
				func = s10010_sequence.BreakGimmick,
				locatorName = "cypr_tree009_anim001_gim_n0002|srt_cypr_tree009_anim001",
				datasetPath = "/Assets/tpp/level/location/cypr/block_small/08/cypr_08_asset.fox2",
			},
		},
	},
	treeDown0002 = {
		before = {
			{
				func = s10010_sequence.BreakGimmick,
				locatorName = "cypr_tree009_anim001_gim_n0003|srt_cypr_tree009_anim001",
				datasetPath = "/Assets/tpp/level/location/cypr/block_small/08/cypr_08_asset.fox2",
			},
		},
	},
	treeDown0003 = {
		before = {
			{
				func = s10010_sequence.BreakGimmick,
				locatorName = "cypr_tree009_anim001_gim_n0004|srt_cypr_tree009_anim001",
				datasetPath = "/Assets/tpp/level/location/cypr/block_small/08/cypr_08_asset.fox2",
			},
		},
	},
	treeExplosion0000 = {
		before = {
			{ func = s10010_sequence.CreateEffect, effectName = "volginRide_treeExplosion0000", },
		},
	},
	treeExplosion0001 = {
		before = {
			{ func = s10010_sequence.CreateEffect, effectName = "volginRide_treeExplosion0001", },
		},
	},
	treeExplosion0002 = {
		before = {
			{ func = s10010_sequence.CreateEffect, effectName = "volginRide_treeExplosion0002", },
		},
	},
	treeExplosion0003 = {
		before = {
			{ func = s10010_sequence.CreateEffect, effectName = "volginRide_treeExplosion0003", },
		},
	},
	bgmChangeVolginRide = {
		before = {
			{ func = s10010_sequence.SetSceneBGMSwitch, switchName = "Set_Switch_bgm_s10010_sw_03", },
		},
	},
	volginRideFinish = {
		before = {
			{ func = s10010_sequence.SetMeshVisibility, identifier = "cypr_s08_other_DataIdentifier", key = "cypr_brdg001_0000", meshName = "MESH_before_IV", visible = false, },
		},
	},
	bridge = {
		before = {
			{ func = s10010_sequence.UnsetEquip, slot = PlayerSlotType.PRIMARY_1, },
			{ func = s10010_sequence.EnableDataBody, identifier = "cypr_common_light_DataIdentifier", key = "Light_Minato_Isolate", enable = true, },
			{ func = s10010_sequence.SetModelVisibility, identifier = "cypr_s06_other_DataIdentifier", key = "p21_020040_port", visible = true, },
			{ func = s10010_sequence.SetEffectVisibility, effectName = "p21_020040_FxLocatorGroup", visible = true, },
		},
		after = {
			{ func = s10010_sequence.StopVolginRide, },
			{ func = s10010_sequence.UnsetEquip, slot = PlayerSlotType.PRIMARY_1, },
		},
	},
	bridge2 = {
		before = {
			{ func = s10010_sequence.SetScatterDofEnabled, enabled = true, ignoreGen7 = true, },
		},
		after = {
			{ func = s10010_sequence.SetScatterDofEnabled, enabled = false, ignoreGen7 = true, },
		},
	},
}




return s10010_sequence
