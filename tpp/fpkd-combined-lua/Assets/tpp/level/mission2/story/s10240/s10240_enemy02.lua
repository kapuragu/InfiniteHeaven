local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}


local BODY_ID_WORKER 		= 146
local BODY_ID_WORKER_BLOOD 	= 149
local BODY_ID_WORKER_DEMO	= 150
local BODY_ID_RESCUE 		= 147 
local BODY_ID_RESCUE_BLOOD	= 152 
local BODY_ID_SOLDIER 		= 148
local BODY_ID_SOLDIER_BLOOD	= 153

local BODY_ID_WORKER_W 			= 154
local BODY_ID_WORKER_BLOOD_W 	= 157
local BODY_ID_RESCUE_W 			= 155
local BODY_ID_RESCUE_BLOOD_W	= 158
local BODY_ID_SOLDIER_W			= 156
local BODY_ID_SOLDIER_BLOOD_W	= 159


this.disablePowerSettings = {
	"ARMOR",
	"SOFT_ARMOR",
	"HELMET",
	"NVG",
	"GAS_MASK",
	"SNIPER",
	"MG",
	"SMG",
	"SHOTGUN",
	"MISSILE",
	"RADIO",
}





this.soldierDefine = {
	
	mbqf_mbqf_cp = {
		"sol_mbqf_0000",
		"sol_mbqf_0001",
		"sol_mbqf_0003", 
		"sol_mbqf_0004",
		"sol_mbqf_0005",
		"sol_mbqf_0006",
		"sol_mbqf_0007",
		"sol_mbqf_0008",
		"sol_mbqf_0009", 
		"sol_mbqf_0010",
		"sol_mbqf_0011", 
		"sol_mbqf_0012",
		"sol_mbqf_0013",
		"sol_mbqf_0017", 
		"sol_mbqf_0018",
		"sol_mbqf_0019",
		"sol_mbqf_0021",
		"sol_mbqf_0022",
		"sol_mbqf_0023",
		"sol_mbqf_0024",
		"sol_mbqf_0026",
		
		"sol_mbqf_1000",
		"sol_mbqf_1001",
		"sol_mbqf_1002",
		"sol_mbqf_1003",
		"sol_mbqf_1004",
		"sol_mbqf_1005",
		"sol_mbqf_1006",
		"sol_mbqf_1007",
		"sol_mbqf_1008",
		"sol_mbqf_1009",

		"sol_mbqf_1010", 
		"sol_mbqf_1011", 
		"sol_mbqf_0014", 
		"sol_mbqf_0015", 
		"sol_mbqf_0016", 

		nil
	},
	nil
}
this.soldierTypes = {
        DD = {
                this.soldierDefine.mbqf_mbqf_cp,
        },
}

this.voiceTypeTable = {
	sol_mbqf_0000 = "ene_d", 
	sol_mbqf_0001 = "ene_a", 
	sol_mbqf_0003 = "ene_a", 
	sol_mbqf_0004 = "ene_d", 
	sol_mbqf_0005 = "ene_a", 
	sol_mbqf_0006 = "ene_c", 
	sol_mbqf_0007 = "ene_d", 
	sol_mbqf_0008 = "ene_a", 
	sol_mbqf_0009 = "ene_a", 
	sol_mbqf_0010 = "ene_d", 
	sol_mbqf_0011 = "ene_a", 
	sol_mbqf_0012 = "ene_c", 
	sol_mbqf_0013 = "ene_b", 
	sol_mbqf_0018 = "ene_c", 
	sol_mbqf_0019 = "ene_a", 
	sol_mbqf_0021 = "ene_a", 
	sol_mbqf_0022 = "ene_a", 
	sol_mbqf_0023 = "ene_d", 
	sol_mbqf_0024 = "ene_c", 
	sol_mbqf_0026 = "ene_a", 
	
	sol_mbqf_1000 = "ene_c", 
	sol_mbqf_1001 = "ene_a", 
	sol_mbqf_1002 = "ene_c", 
	sol_mbqf_1003 = "ene_d", 
	sol_mbqf_1004 = "ene_a", 
	sol_mbqf_1005 = "ene_b", 
	sol_mbqf_1006 = "ene_c", 
	sol_mbqf_1007 = "ene_c", 
	sol_mbqf_1008 = "ene_d", 
	sol_mbqf_1009 = "ene_c", 
	sol_mbqf_1010 = "ene_c", 
	sol_mbqf_1011 = "ene_d", 
	sol_mbqf_0014 = "ene_a", 
	sol_mbqf_0015 = "ene_c", 
	sol_mbqf_0016 = "ene_d", 
}

this.DemoActorEnemy = {
		"sol_mbqf_0005",
		"sol_mbqf_0006",
		"sol_mbqf_0007",
		"sol_mbqf_0009",
		"sol_mbqf_0011",
}

this.afterEnemy = {
		"sol_mbqf_0000",
		"sol_mbqf_0001",
		"sol_mbqf_0004",
		"sol_mbqf_0010",
		"sol_mbqf_0012",
		"sol_mbqf_0013",
		
		"sol_mbqf_0018",
		"sol_mbqf_0021",
		"sol_mbqf_0022",
		"sol_mbqf_0023",
		"sol_mbqf_0024",
		"sol_mbqf_0026",
		
		"sol_mbqf_0014",
		"sol_mbqf_0015",
		"sol_mbqf_0016",
}

this.afterDeadEnemy = {
		"sol_mbqf_0005", 
		"sol_mbqf_0006", 
		"sol_mbqf_0007", 
		"sol_mbqf_0008", 
		"sol_mbqf_0009", 
		"sol_mbqf_0011", 
		"sol_mbqf_0019", 
		"sol_mbqf_0017", 
}


this.DisableEnemyAfterClearTable = {
	
	"sol_mbqf_0021",
	"sol_mbqf_0026",
	"sol_mbqf_0014",	
	"sol_mbqf_0016",	
	"sol_mbqf_0015",	
	"sol_mbqf_0010",	
	
	"sol_mbqf_0005",
	"sol_mbqf_0006",
	"sol_mbqf_0007",	

	
	"sol_mbqf_0012",
	"sol_mbqf_0013",
	"sol_mbqf_0000",
	"sol_mbqf_0001",
	"sol_mbqf_0018",	
	"sol_mbqf_0022",	
	"sol_mbqf_0023",	
	"sol_mbqf_0024",	

}


this.afterDeadEnemy2 = {
		"sol_mbqf_1010", 
		"sol_mbqf_1011", 
}

this.DeadEnemyAfterDemo = {
		"sol_mbqf_0009", 
		"sol_mbqf_0011", 
}


this.DisableCarriedCorpse = {
	"crp_mbqf_0000",
	"crp_mbqf_0002",
	"crp_mbqf_0003",
	"crp_mbqf_0004",
	"crp_mbqf_0005",
	"crp_mbqf_0007",
	"crp_mbqf_0009",
	
	"crp_mbqf_0011",
	
	"crp_mbqf_0001",
	"crp_mbqf_0006",
	"crp_mbqf_0008",
	"crp_mbqf_0012",
	"crp_mbqf_0013",
	"crp_mbqf_0014",
	"crp_mbqf_0015",
	"crp_mbqf_0016",
	"TppCorpseGameObjectLocator0000",
	"TppCorpseGameObjectLocator0001",
	"TppCorpseGameObjectLocator0002",
	"TppCorpseGameObjectLocator0003",
	"TppCorpseGameObjectLocator0004",
	"TppCorpseGameObjectLocator0005",
	"TppCorpseGameObjectLocator0006",
	"TppCorpseGameObjectLocator0007",
	"TppCorpseGameObjectLocator0008",
	"TppCorpseGameObjectLocator0009",
	"TppCorpseGameObjectLocator0010",
	"TppCorpseGameObjectLocator0011",
	"TppCorpseGameObjectLocator0012",
	"TppCorpseGameObjectLocator0013",
	"TppCorpseGameObjectLocator0014",
	"TppCorpseGameObjectLocator0015",
	"TppCorpseGameObjectLocator0016",
	"TppCorpseGameObjectLocator0017",
	"TppCorpseGameObjectLocator0018",
	"TppCorpseGameObjectLocator0019",
	"TppCorpseGameObjectLocator0020",
	"TppCorpseGameObjectLocator0021",
	"TppCorpseGameObjectLocator0022",
	"TppCorpseGameObjectLocator0023",
	"TppCorpseGameObjectLocator0024",
	"TppCorpseGameObjectLocator0025",
	"TppCorpseGameObjectLocator0026",
	"TppCorpseGameObjectLocator0027",
	"TppCorpseGameObjectLocator0028",
	"TppCorpseGameObjectLocator0029",
	"TppCorpseGameObjectLocator0030",
	"TppCorpseGameObjectLocator0031",
	"TppCorpseGameObjectLocator0032",
	"TppCorpseGameObjectLocator0033",
	"TppCorpseGameObjectLocator0034",
	"TppCorpseGameObjectLocator0035",
}


this.ENAMY_LIST = {
	FLOOR0 = {
		"sol_mbqf_0000",
		"sol_mbqf_0001",
		"sol_mbqf_0012",
		"sol_mbqf_0013",
		"sol_mbqf_0018",
		"sol_mbqf_0022",
		"sol_mbqf_0023",
		"sol_mbqf_0024",
	},
	FLOOR1 = {
		"sol_mbqf_1000",
		"sol_mbqf_0014", 
		"sol_mbqf_0015", 
		"sol_mbqf_0016", 
	},
	FLOOR2 = {
		"sol_mbqf_0010",
		"sol_mbqf_0026",
		"sol_mbqf_0021",
		"sol_mbqf_1001",
		"sol_mbqf_1002",
		"sol_mbqf_1003",
		"sol_mbqf_1004",
		"sol_mbqf_1005",
	},
	FLOOR3 = {
		"sol_mbqf_0004",
		"sol_mbqf_1006",
		"sol_mbqf_1007",
		"sol_mbqf_1008",
		"sol_mbqf_1009",

	},
	OTHER = {
		
		"sol_mbqf_0003", 
	}
}






this.MOTION_TABLE = {
	
	OBIE = {
		IDLE_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_scr_idl_a.gani",
		IDLE_B = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_scr_idl_b.gani",
		IDLE_C = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_scr_idl_c.gani",
		IDLE_D = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_scr_idl_d.gani",
		IDLE_E = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_scr_idl_e.gani",
		D2S_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_2_scr_a.gani",
		D2S_B = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_2_scr_b.gani",
		D2S_C = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_2_scr_c.gani",
		D2S_D = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_2_scr_d.gani",

		DEAD_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_2_ded_a.gani",
		DEAD_B = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_2_ded_b.gani",
		DEAD_C = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_2_ded_c.gani",
		DEAD_D = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_2_ded_d.gani",
	},
	DYING = {
	
		IDLE_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_idl_a.gani", 
		IDLE_B = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_idl_b.gani", 
		IDLE_C = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_idl_c.gani", 
		IDLE_D = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_idl_d.gani", 
		IDLE_P = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_idl_bb.gani",		
		
		RAG_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_rag_ded_p_a.gani", 
		RAG_B = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_rag_ded_p_b.gani", 
		RAG_C =	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_rag_ded_p_c.gani", 
		RAG_D =	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_rag_ded_p_d.gani", 
		RAG_E = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_rag_ded_p_e.gani", 
		RAG_WALL_A =	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_rag_ded_p_f.gani", 
		RAG_WALL_B =	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_rag_ded_p_g.gani", 
		RAG_STRC_A = 	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_rag_ded_p_h.gani", 
	},
	DAMAGE = {
		IDLE_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_scr_idl_a_dam.gani",
		IDLE_B = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_scr_idl_b_dam.gani",
		IDLE_C = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_scr_idl_c_dam.gani",
		IDLE_D = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_scr_idl_d_dam.gani",
		IDLE_E = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_scr_idl_e_dam.gani",
		OBIE_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_idl_a_dam.gani",
		OBIE_B = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_idl_b_dam.gani",
		OBIE_C = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_idl_c_dam.gani",
		OBIE_D = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dyg_idl_d_dam.gani",
	},
	EVENT = {
		E1F_4ROOM	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_1f_04_dnt_com.gani",
		E2F_1ROOM	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_01_ed.gani",		
		E2F_STEP_IDLE	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_str_a.gani",	
		E2F_STEP_A	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_str_ded_a.gani",	
		E2F_STEP_B	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_str_ded_b.gani",	
		
		E2F1_C_IDLE		=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_01b_a_idl.gani",	
		E2F1_TURN		=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_01b_b_st.gani",	
		E2F1_S_IDLE		=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_01b_c_idl.gani",	
		E2F1_HANDGUN	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_01b_d_st.gani",	
		E2F1_H_IDLE		=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_01b_e_idl.gani",	
		E2F1_SELF		=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_01b_f_ed.gani",	

		
		E2F_3START	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_03_a.gani",		
		E2F_3IDLE	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_03_b_idl.gani",	
		E2F_3AORI	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_03_c.gani",		
		E2F_3DEAD	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_03_d.gani",		
		E2F_3SELF	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_03_e.gani",		

		E2F_4START	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_2f_04_c.gani",		

		E1B_IDLE =	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_bfr_idl_a.gani", 
		E1B_A 	= 	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_rom_a.gani", 
		E1B_B 	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_rom_b.gani", 
		E1B_C 	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_rom_c.gani", 

		E1B_SONG_IDLE_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_idl_a.gani", 
		E1B_SONG_IDLE_B = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_idl_b.gani", 
		E1B_SONG_IDLE_C = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_idl_c.gani", 
		E1B_SONG_IDLE_D = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_idl_d.gani", 

		E1B_UP_FA =	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_st_f_a.gani", 
		E1B_UP_FB =	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_st_f_b.gani", 
		E1B_UP_LB =	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_st_l_b.gani", 
		E1B_UP_RA =	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_sng_st_r_a.gani", 

		
		E2R_START_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dir_gun_a.gani",
		E2R_START_B = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dir_gun_b.gani",
		E2R_IDLE_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dir_gun_idl_a.gani",
		E2R_IDLE_B = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dir_gun_idl_b.gani",
		E2R_OBIE_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dir_gun_2_scr_a.gani",
		E2R_OBIE_B = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_dir_gun_2_scr_b.gani",

	
		E1LASR_D2I = "/Assets/tpp/motion/SI_game/fani/bodies/prs0/prs0non/prs0non_fnt2qid.gani",
		E1LAST_A = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_lst_sol_a.gani",
		E1LAST_IDLE = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_lst_sol_b_idl.gani",
		E1LAST_DEAD = "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_lst_sol_d_ded.gani",


	},

	
	DEAD = {
		IDLE_A	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_cmn_ded_a.gani", 
		IDLE_B	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_cmn_ded_b.gani", 
		IDLE_C	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_cmn_ded_c.gani", 
		IDLE_D	=	"/Assets/tpp/motion/SI_game/fani/bodies/enet/enetzmb/enetzmb_s_msc_cmn_ded_d.gani",
	},
}

this.DownEnemyList = {
	
	
	
	{name = "sol_mbqf_1000", motion = this.MOTION_TABLE.DYING.IDLE_P , obie = this.MOTION_TABLE.OBIE.D2S_B, loop = this.MOTION_TABLE.OBIE.IDLE_B, dead = this.MOTION_TABLE.OBIE.DEAD_B, obieVoice = "DD_221" },
	{name = "sol_mbqf_1001", motion = this.MOTION_TABLE.DYING.IDLE_B , obie = this.MOTION_TABLE.OBIE.D2S_B, loop = this.MOTION_TABLE.OBIE.IDLE_B, dead = this.MOTION_TABLE.OBIE.DEAD_B, obieVoice = "DD_232" },
	{name = "sol_mbqf_1002", motion = this.MOTION_TABLE.DYING.IDLE_D , obie = this.MOTION_TABLE.OBIE.D2S_D, loop = this.MOTION_TABLE.OBIE.IDLE_D, dead = this.MOTION_TABLE.OBIE.DEAD_D, obieVoice = "DD_251" },
	{name = "sol_mbqf_1003", motion = this.MOTION_TABLE.DYING.IDLE_C , obie = this.MOTION_TABLE.OBIE.D2S_C, loop = this.MOTION_TABLE.OBIE.IDLE_C, dead = this.MOTION_TABLE.OBIE.DEAD_C, obieVoice = "DD_262"},
	{name = "sol_mbqf_1004", motion = this.MOTION_TABLE.DYING.IDLE_A , obie = this.MOTION_TABLE.OBIE.D2S_A, loop = this.MOTION_TABLE.OBIE.IDLE_A, dead = this.MOTION_TABLE.OBIE.DEAD_A, obieVoice = "DD_290"},
	{name = "sol_mbqf_1005", motion = this.MOTION_TABLE.EVENT.E2F_STEP_IDLE, obie = nil, 														dead = this.MOTION_TABLE.EVENT.E2F_STEP_B, obieVoice = nil}, 
	{name = "sol_mbqf_1006", motion = this.MOTION_TABLE.DYING.IDLE_P , obie = this.MOTION_TABLE.OBIE.D2S_B, loop = this.MOTION_TABLE.OBIE.IDLE_B, dead = this.MOTION_TABLE.OBIE.DEAD_B, obieVoice = "DD_211"}, 
	{name = "sol_mbqf_1007", motion = this.MOTION_TABLE.DYING.IDLE_D , obie = this.MOTION_TABLE.OBIE.D2S_D, loop = this.MOTION_TABLE.OBIE.IDLE_D, dead = this.MOTION_TABLE.OBIE.DEAD_D, obieVoice = "DD_142" },
	{name = "sol_mbqf_1008", motion = this.MOTION_TABLE.DYING.IDLE_C , obie = this.MOTION_TABLE.OBIE.D2S_C, loop = this.MOTION_TABLE.OBIE.IDLE_C, dead = this.MOTION_TABLE.OBIE.DEAD_C, obieVoice = "DD_120"},
	{name = "sol_mbqf_1009", motion = this.MOTION_TABLE.OBIE.IDLE_C ,  obie = this.MOTION_TABLE.OBIE.D2S_C, loop = this.MOTION_TABLE.OBIE.IDLE_C, dead = this.MOTION_TABLE.OBIE.DEAD_C, obieVoice = nil}, 
	{name = "sol_mbqf_1010", motion = this.MOTION_TABLE.DYING.IDLE_B ,  obie = this.MOTION_TABLE.OBIE.D2S_B, loop = this.MOTION_TABLE.OBIE.IDLE_B, dead = this.MOTION_TABLE.OBIE.DEAD_B, obieVoice = nil}, 
	{name = "sol_mbqf_1011", motion = this.MOTION_TABLE.DYING.IDLE_D ,  obie = this.MOTION_TABLE.OBIE.D2S_D, loop = this.MOTION_TABLE.OBIE.IDLE_D, dead = this.MOTION_TABLE.OBIE.DEAD_D, obieVoice = nil}, 
	{name = "sol_mbqf_0004", motion = this.MOTION_TABLE.DYING.IDLE_C  , obie = this.MOTION_TABLE.OBIE.D2S_C, loop = this.MOTION_TABLE.OBIE.IDLE_C, dead = this.MOTION_TABLE.OBIE.DEAD_C, obieVoice = nil}, 
	{name = "sol_mbqf_0010", motion = this.MOTION_TABLE.DYING.IDLE_B  , obie = nil, loop = this.MOTION_TABLE.OBIE.IDLE_B, 							dead = this.MOTION_TABLE.OBIE.DEAD_B, obieVoice = nil }, 
}










this.combatSetting = {
	nil
}





this.DisableEnemy = function()
	Fox.Log("disable all enemy. when before satsuriku sequence")

	for i,enemyId in pairs(this.afterEnemy)do
		if enemyId == nil then
			Fox.Log("enemyId is nil")
		else
			TppEnemy.SetDisable( enemyId )
		end
	end
	for i,enemyId in pairs(this.DemoActorEnemy)do
		if enemyId == nil then
			Fox.Log("enemyId is nil")
		else
			TppEnemy.SetDisable( enemyId )
		end
	end
end

this._EnableEnemy = function(enemyId)
	TppEnemy.SetEnable( enemyId )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2",enemyId ), { id = "SetRestrictNotice", enabled = true } ) 
end


this._AddRouteAfetrSequence = function()
	this.AddEnemyRoute("sol_mbqf_0000","rts_mbqf_B1000")
	this.AddEnemyRoute("sol_mbqf_0001","rts_mbqf_B1001")
	this.AddEnemyRoute("sol_mbqf_0012","rts_mbqf_B1012")
	this.AddEnemyRoute("sol_mbqf_0013","rts_mbqf_B1013")
	this.AddEnemyRoute("sol_mbqf_0018","rts_mbqf_B1018")
	this.AddEnemyRoute("sol_mbqf_0022","rts_mbqf_B1022")
	this.AddEnemyRoute("sol_mbqf_0023","rts_mbqf_B1023")
	this.AddEnemyRoute("sol_mbqf_0024","rts_mbqf_B1024")
end


this.EnableEnemy = function()
	Fox.Log("Enable all enemy. when after satsuriku sequence")
	this._AddRouteAfetrSequence()
	local enemyName
	local enemyTable = this.afterEnemy

	
	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.PUSH )
	local command = { 
		id = "SetIgnoreDamageAction", 
		flag = ignoreFlag
	 }
	 local gameObjectId


	for i,enemyId in pairs(enemyTable)do
		if enemyId == nil then
			Fox.Log("enemyId is nil")
		else
			this._EnableEnemy( enemyId )
			GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", enemyId ), command)
		end
	end

	
	local gameObjectId
	local command
	for i, enemyId in pairs( this.afterDeadEnemy )do
		if TppEnemy.GetLifeStatus( enemyId ) == TppEnemy.LIFE_STATUS.DEAD then
			Fox.Log("alredy dead "..enemyId)
		else
			TppEnemy.SetDisable( enemyId )
			Fox.Log("disable "..enemyId)
		end
	end
	
	
	this.SetZombie1F()
	this.SetNoKrei()
	
end

this.Kill2FEnemy = function()
	
	local gameObjectId
	local command

	for i, enemyId in pairs( this.afterDeadEnemy2 )do
		if TppEnemy.GetLifeStatus( enemyId ) == TppEnemy.LIFE_STATUS.DEAD then
			Fox.Log("alredy dead")
		else
			Fox.Log("die "..enemyId)
			this.DieEnemy(enemyId)

		end
	end

end

this.DisableEnemyAfterClear = function()
	for i, enemyId in pairs( this.DisableEnemyAfterClearTable )do
		Fox.Log("Disable "..enemyId)
		TppEnemy.SetDisable(enemyId)
	end

end

this.EnableEnamyForDemo = function()
	Fox.Log("enable enemy for demo")
	for i,enemyId in pairs( this.DemoActorEnemy )do
		if enemyId == nil then
			Fox.Log("enemyId is nil")
		else
			this._EnableEnemy( enemyId )
		end
	end
	this.SetNoKrei()
end


this.DisableCorpseRoof = function()

	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0001" ), { id = "SetForceUnreal", enabled=true } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0006" ), { id = "SetForceUnreal", enabled=true } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0008" ), { id = "SetForceUnreal", enabled=true } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0012" ), { id = "SetForceUnreal", enabled=true } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0013" ), { id = "SetForceUnreal", enabled=true } )

	
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0014" ), { id = "SetForceUnreal", enabled=true } )
	
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0015" ), { id = "SetForceUnreal", enabled=true } )
	
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0016" ), { id = "SetForceUnreal", enabled=true } )

end

this.DisableCorpseForDemo = function()
	Fox.Log("DisableCorpseForDemo")
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0002" ), { id = "SetForceUnreal", enabled=true } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0003" ), { id = "SetForceUnreal", enabled=true } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0000" ), { id = "SetForceUnreal", enabled=true } )
end

this.EnableCorpseRoof = function()
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0001" ), { id = "SetForceUnreal", enabled=false } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0006" ), { id = "SetForceUnreal", enabled=false } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0008" ), { id = "SetForceUnreal", enabled=false } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0012" ), { id = "SetForceUnreal", enabled=false } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0013" ), { id = "SetForceUnreal", enabled=false } )

	
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0014" ), { id = "SetForceUnreal", enabled=false } )
	
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0015" ), { id = "SetForceUnreal", enabled=false } )
	
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0016" ), { id = "SetForceUnreal", enabled=false } )

end


this.SetNoKrei = function()
	
	local gameObjectId = { type="TppSoldier2" }
	GameObject.SendCommand( gameObjectId, { id = "SetRestrictNotice", enabled = true } ) 
end

this.KillEnemyAfterDemo = function()
	TppEnemy.SetDisable( "sol_mbqf_0009" )
	TppEnemy.SetDisable( "sol_mbqf_0011" )

end


this.SetDemoRealize = function(flag)
	local enable = true
	if flag == false then
		enable = false
	end

	local zombieEnemy = {
		"sol_mbqf_0005",
		"sol_mbqf_0006",
		"sol_mbqf_0007",
		"sol_mbqf_0017",
	}
	local command = { id="SetIgnoreDisableNpc", enable=enable }	
	for i, enemyName in ipairs(zombieEnemy) do
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", enemyName ), command )
	end



end

this.SetEnemyWeapon = function()
	Fox.Log("set enemy weapon")
	local enemyName
	for i, enemyId in pairs(this.soldierDefine.mbqf_mbqf_cp)do
		if enemyId == nil then
			Fox.Log("enemyId is nil")
		else

			enemyName = GameObject.GetGameObjectId( "TppSoldier2",enemyId )
			GameObject.SendCommand( enemyName, { id = "SetFriendly"} )
			GameObject.SendCommand( enemyName, { id = "SetEnableDyingState", enabled = false })
			GameObject.SendCommand( enemyName, { id = "SetMaxLife", life = 900, stamina = 10})
			GameObject.SendCommand( enemyName, { id = "SetSoldier2Type", type = EnemyType.TYPE_DD } )
			GameObject.SendCommand( enemyName, { id = "SetVoiceType", voiceType=this.voiceTypeTable[enemyId] } )
			GameObject.SendCommand( enemyName, { id = "SetUnarmed", enabled=true })	
		end
	end
	
	local lowLifeEnemeyTable = {
		"sol_mbqf_0003",
		"sol_mbqf_0019",
		"sol_mbqf_1005",
		"sol_mbqf_0021",
		"sol_mbqf_0026",
	}
	for i, enemyId in pairs(lowLifeEnemeyTable)do
		enemyName = GameObject.GetGameObjectId( "TppSoldier2",enemyId )
		GameObject.SendCommand( enemyName, { id = "SetMaxLife", life = 400, stamina = 10})
	end
	
end

this.DieEnemy = function(enemyId)
	local gameObjectId
	if Tpp.IsTypeString( enemyId ) then
		gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
	else
		gameObjectId = enemyId
	end
	svars.numCheckDead = svars.numCheckDead + 1 
	
	GameObject.SendCommand( gameObjectId, { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_DEAD} )
end


this.DyingEnemy = function(enemyId)
	local gameObjectId
	if Tpp.IsTypeString( enemyId ) then
		gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
	else
		gameObjectId = enemyId
	end
	GameObject.SendCommand( gameObjectId, { id = "SetEnableDyingState", enabled = true })
	local command = { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_DYING} 
	GameObject.SendCommand( gameObjectId, command )

end

this.FaintEnemy = function(enemyId)
	local gameObjectId
	if Tpp.IsTypeString( enemyId ) then
		gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
	else
		gameObjectId = enemyId
	end

	local command = { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_FAINT} 
	GameObject.SendCommand( gameObjectId, command )
end

local GAMEOBJECT_INFO_LIST = { 
		
		{locatorName = "sol_mbqf_1000", id = "ChangeFova", bodyId = BODY_ID_WORKER_BLOOD },
		{locatorName = "sol_mbqf_1002", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD },
		{locatorName = "sol_mbqf_1006", id = "ChangeFova", bodyId = BODY_ID_WORKER_BLOOD },
		{locatorName = "sol_mbqf_1003", id = "ChangeFova", bodyId = BODY_ID_WORKER_BLOOD },
		{locatorName = "crp_mbqf_0004", id = "ChangeFovaCorpse", bodyId=BODY_ID_WORKER_BLOOD },
		{locatorName = "crp_mbqf_0002", id = "ChangeFovaCorpse", bodyId=BODY_ID_WORKER_BLOOD },
		{locatorName = "crp_mbqf_0005", id = "ChangeFovaCorpse", bodyId=BODY_ID_WORKER },
		{locatorName = "sol_mbqf_1001", id = "ChangeFova", bodyId = BODY_ID_WORKER_BLOOD },

		
		{locatorName = "sol_mbqf_0008", id = "ChangeFova", bodyId = BODY_ID_WORKER_BLOOD },
		{locatorName = "sol_mbqf_1009", id = "ChangeFova", bodyId = BODY_ID_WORKER_BLOOD },
		{locatorName = "sol_mbqf_1010", id = "ChangeFova", bodyId = BODY_ID_WORKER_BLOOD }, 
		{locatorName = "sol_mbqf_1011", id = "ChangeFova", bodyId = BODY_ID_WORKER_BLOOD },
		{locatorName = "sol_mbqf_0014", id = "ChangeFova", bodyId = BODY_ID_WORKER_BLOOD }, 
		{locatorName = "crp_mbqf_0000", id = "ChangeFovaCorpse", bodyId=BODY_ID_WORKER_BLOOD },
		{locatorName = "crp_mbqf_0003", id = "ChangeFovaCorpse", bodyId=BODY_ID_WORKER_BLOOD },
		{locatorName = "crp_mbqf_0009", id = "ChangeFovaCorpse", bodyId=BODY_ID_WORKER_BLOOD },
		{locatorName = "crp_mbqf_0011", id = "ChangeFovaCorpse", bodyId=BODY_ID_WORKER_BLOOD },
		
		
 		{locatorName = "sol_mbqf_0003", id = "ChangeFova", balaclavaFaceId=TppEnemyFaceId.dds_balaclava6, bodyId = BODY_ID_SOLDIER },
		{locatorName = "crp_mbqf_0007", id = "ChangeFovaCorpse", balaclavaFaceId=TppEnemyFaceId.dds_balaclava6, bodyId = BODY_ID_SOLDIER_BLOOD },
 		{locatorName = "sol_mbqf_0017", id = "ChangeFova", balaclavaFaceId=TppEnemyFaceId.dds_balaclava6, bodyId = BODY_ID_SOLDIER_BLOOD },

		
		{locatorName = "sol_mbqf_0000", id = "ChangeFova", bodyId = BODY_ID_RESCUE },
		{locatorName = "sol_mbqf_0004", id = "ChangeFova", bodyId = BODY_ID_RESCUE },
		{locatorName = "sol_mbqf_0005", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD },
		{locatorName = "sol_mbqf_0006", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD },
		{locatorName = "sol_mbqf_0007", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD },
		{locatorName = "sol_mbqf_0010", id = "ChangeFova", bodyId = BODY_ID_RESCUE },
		{locatorName = "sol_mbqf_0012", id = "ChangeFova", bodyId = BODY_ID_RESCUE },
		{locatorName = "sol_mbqf_0013", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD },
		{locatorName = "sol_mbqf_0019", id = "ChangeFova", bodyId = BODY_ID_RESCUE },
		{locatorName = "sol_mbqf_0021", id = "ChangeFova", bodyId = BODY_ID_RESCUE },
		{locatorName = "sol_mbqf_0026", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD },
		{locatorName = "sol_mbqf_1004", id = "ChangeFova", bodyId = BODY_ID_RESCUE },
		{locatorName = "sol_mbqf_1005", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD },
		{locatorName = "sol_mbqf_0015", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD }, 
		{locatorName = "sol_mbqf_0016", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD }, 
		{locatorName = "sol_mbqf_0009", id = "ChangeFova", balaclavaFaceId=TppEnemyFaceId.dds_balaclava2, bodyId = BODY_ID_RESCUE }, 
		{locatorName = "sol_mbqf_0011", id = "ChangeFova", balaclavaFaceId=TppEnemyFaceId.dds_balaclava2, bodyId = BODY_ID_RESCUE }, 
		{locatorName = "sol_mbqf_1007", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD }	,	
		{locatorName = "sol_mbqf_1008", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD },		
		{locatorName = "crp_mbqf_0001", id = "ChangeFovaCorpse", bodyId = BODY_ID_RESCUE },		 	 
		{locatorName = "crp_mbqf_0008", id = "ChangeFovaCorpse", bodyId = BODY_ID_RESCUE },		 
		{locatorName = "crp_mbqf_0012", id = "ChangeFovaCorpse", balaclavaFaceId=TppEnemyFaceId.dds_balaclava2, bodyId = BODY_ID_RESCUE },		 
		{locatorName = "crp_mbqf_0013", id = "ChangeFovaCorpse", balaclavaFaceId=TppEnemyFaceId.dds_balaclava2, bodyId = BODY_ID_RESCUE },		 

		{locatorName = "sol_mbqf_0001", id = "ChangeFova", bodyId = BODY_ID_WORKER_BLOOD }, 
		{locatorName = "sol_mbqf_0018", id = "ChangeFova", bodyId = BODY_ID_WORKER },
		{locatorName = "sol_mbqf_0023", id = "ChangeFova", bodyId = BODY_ID_WORKER_BLOOD }	,
		{locatorName = "sol_mbqf_0022", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD }	,	
		{locatorName = "sol_mbqf_0024", id = "ChangeFova", bodyId = BODY_ID_RESCUE_BLOOD }	,	
}



this.SetFova = function()

	local maleStaffIds, femaleStaffIds

	if TppStory.GetCurrentStorySequence() < TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS then
		Fox.Log("Set true staffIds. because first play")
		maleStaffIds, femaleStaffIds = TppMotherBaseManagement.GetStaffsS10240()
	else
		Fox.Log("Set false staffIds. because not first play")
		maleStaffIds = TppEneFova.S10240_MaleFaceIdList
		femaleStaffIds = TppEneFova.S10240_FemaleFaceIdList
	end

	if #maleStaffIds < 39 then
		Fox.Warning("maleStaffIds not over 39. num = "..tostring(#maleStaffIds))
	end

	local index = 1
	index = this.AssignStaffIdAndFaceId( femaleStaffIds, index, true) 
	index = this.AssignStaffIdAndFaceId( maleStaffIds, index, false)

	
	GameObject.SendCommand( GameObject.GetGameObjectId( "crp_mbqf_0006" ), { id = "ChangeFovaCorpse", faceId=623, bodyId=BODY_ID_WORKER_DEMO  } )		 
	
	GameObject.SendCommand( GameObject.GetGameObjectId( "sol_mbqf_0000" ), { id = "ChangeFova", seed=8 } )

	
	local faceId, faceId2, faceId3
	local staffId = maleStaffIds
	if TppStory.GetCurrentStorySequence() < TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS then
		faceId = TppMotherBaseManagement.StaffIdToFaceId{ staffId=staffId[12] }
		faceId2 = TppMotherBaseManagement.StaffIdToFaceId{ staffId=staffId[21] }
		faceId3 = TppMotherBaseManagement.StaffIdToFaceId{ staffId=staffId[9] }
	else	
		faceId = staffId[12]
		faceId2 = staffId[21]
		faceId3 = staffId[9]
	end
	GameObject.SendCommand( GameObject.GetGameObjectId( "crp_mbqf_0015" ), { id = "ChangeFovaCorpse", faceId = faceId, bodyId = BODY_ID_SOLDIER_BLOOD , balaclavaFaceId=TppEnemyFaceId.dds_balaclava6 } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "crp_mbqf_0014" ), { id = "ChangeFovaCorpse", faceId = faceId2, bodyId = BODY_ID_RESCUE_BLOOD , balaclavaFaceId=EnemyFova.INVALID_FOVA_VALUE } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "crp_mbqf_0016" ), { id = "ChangeFovaCorpse", faceId = faceId3, bodyId = BODY_ID_WORKER_BLOOD , balaclavaFaceId=EnemyFova.INVALID_FOVA_VALUE } )
end

this.AssignStaffIdAndFaceId = function( staffIdList ,index , isFemale)
	for i, staffId in ipairs(staffIdList) do
		local gameObjectInfo = GAMEOBJECT_INFO_LIST[index]
		if not gameObjectInfo then
			return index
		end
	
		if staffId == nil then
			return
		end

		index = index + 1

		local gameObjectId = GameObject.GetGameObjectId( gameObjectInfo.locatorName )
		local faceId
		if TppStory.GetCurrentStorySequence() < TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS then
			mtbs_enemy.SetStaffId( gameObjectId , staffId )
			faceId = TppMotherBaseManagement.StaffIdToFaceId{ staffId=staffId }
		else	
			faceId = staffId
		end
		local bodyId = gameObjectInfo.bodyId
		local balaclavaFaceId = EnemyFova.INVALID_FOVA_VALUE
		if gameObjectInfo.balaclavaFaceId then
			balaclavaFaceId = gameObjectInfo.balaclavaFaceId
		end
		if isFemale then
			
			local command = { id = "UseExtendParts", enabled = true }
			GameObject.SendCommand( gameObjectId, command )	

			
			if bodyId == BODY_ID_WORKER then
				bodyId = BODY_ID_WORKER_W
			elseif bodyId == BODY_ID_WORKER_BLOOD then
				bodyId = BODY_ID_WORKER_BLOOD_W
			elseif bodyId == BODY_ID_RESCUE then
				bodyId = BODY_ID_RESCUE_W 	
			elseif bodyId == BODY_ID_RESCUE_BLOOD then
				bodyId = BODY_ID_RESCUE_BLOOD_W
			elseif bodyId == BODY_ID_SOLDIER then
				bodyId = BODY_ID_SOLDIER_W
			elseif bodyId == BODY_ID_SOLDIER_BLOOD then
				bodyId = BODY_ID_SOLDIER_BLOOD_W
			end
			
			if balaclavaFaceId == gameObjectInfo.balaclavaFaceId then
				balaclavaFaceId = TppEnemyFaceId.dds_balaclava7 
			end
		else
			
			local command = { id = "UseExtendParts", enabled = false }
			GameObject.SendCommand( gameObjectId, command )	

		end		
		GameObject.SendCommand( gameObjectId, { id = gameObjectInfo.id, faceId = faceId, bodyId = bodyId , balaclavaFaceId=balaclavaFaceId } )
		

	end
	return index
end

this.SetBloodFace = function()
	local enemyTalbe = {
		"0008","1000","1001","1002","1003","1004","1006","1007", "1008","1009", "1010", "1011",
		"0016","0015","0014","0001","0023","0024","0000","0013", "0026", "0013",
	}
	for i,name in pairs(enemyTalbe) do
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_"..name ), { id = "SetBloodFaceMode", enabled=true } )		
	end
	local enemyTalbe = {
		"0002","0009","0011",
		"0004",
	}
	for i,name in pairs(enemyTalbe) do
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_"..name ), { id = "SetBloodFaceMode", enabled=true } )
	end
end


this.SetOwnerPlayer = function()
	local enemyTalbe = {
		"1007", "1008", "0004", "1009", "1006", 
		"1005", "0026", "0021", "1004", "1003", "0010", "1002", "1001", 
		"1000", "0010",
		"0000", "0012", "0013", "0024", "0023", "0001", "0018", "0003" , 
	}
	for i,name in pairs(enemyTalbe) do
		this._SetEventFlag( "sol_mbqf_"..name, { flag = "ownerPlayer", enable = true} )
	end

	local enemyInvalTalbe = {
		"0008",  
		"0017",	
	}
	for i,name in pairs(enemyInvalTalbe) do
		this._SetEventFlag( "sol_mbqf_"..name, { flag = "ownerInvalid", enable = true} )
	end

end



this._SetSpecialActionForEvent = function( enemyId, path, noMessage, message, startFrame, unarmed )
		if startFrame == nil then 
			startFrame = 0
		end

		local enableMessage = true
		if noMessage == true then 
			enableMessage = false
		end
		
		local gameObjectId	
		if Tpp.IsTypeString( enemyId ) then
			gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
		else
			gameObjectId = enemyId
		end

		local commandId = "none"
		if Tpp.IsTypeString( message ) then
			commandId = message
		end
		GameObject.SendCommand( gameObjectId, {
		        id="SpecialAction",
		        path=path,
		        stance=EnemyStance.STANCE_STAND,
		        autoFinish=false,
		        commandId=StrCode32(commandId),
		        enableMessage=enableMessage,
		        enableGravity=false,
		        enableCollision=false,
				interpFrame=16,
				startFrame=startFrame,
		} )
		GameObject.SendCommand( gameObjectId, { id = "SetDisableDamage", life = false, faint = true, sleep = true } )		
		if unarmed == false then
			Fox.Log("no unarmed")
		else
			GameObject.SendCommand( gameObjectId, { id = "SetUnarmed", enabled=true })	
		end
end
this._SetDeadSpecialActionForEvent = function( enemyId, path )
		local gameObjectId
		if Tpp.IsTypeString( enemyId ) then
			gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
		else
			gameObjectId = enemyId
		end
		
		GameObject.SendCommand( gameObjectId, {
		        id="SpecialAction",
		        path=path,
		        stance=EnemyStance.STANCE_SUPINE,
		        autoFinish=true,
		        enableMessage=false,
		        enableGravity=true,
		        enableCollision=true,
		        enableDeadEnd = true,
		} )
end


this.SetMotionDown = function()

	local gameObjectId
	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.BULLET )
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.PUSH )
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.FLASH_LIGHT )

	
	for i=1, #this.DownEnemyList do
		gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", this.DownEnemyList[i].name )
		GameObject.SendCommand( gameObjectId, {
		        id="SpecialAction",
		        path=this.DownEnemyList[i].motion,
		        stance=EnemyStance.STANCE_SUPINE,
		        autoFinish=false,
		        enableMessage=false,
		        enableGravity=false,
		        enableCollision=false,
		        enableDeadEnd = false,
		} )
		
		GameObject.SendCommand( gameObjectId, { id = "SetEnableSendMessageAimedFromPlayer", enabled=true } )

		
		GameObject.SendCommand( gameObjectId, { id = "SetDisableDamage", life = false, faint = true, sleep = true } )

		
		if this.DownEnemyList[i].dead == nil then
			Fox.Log("dead motion is nil. not set SetIgnoreDamageAction")
		else
			GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
		end
	end

end

this.SetInitMotionBody = function()
	local bodyMotionList = {
		{name = "crp_mbqf_0009", motion = this.MOTION_TABLE.DYING.RAG_A}, 
		{name = "crp_mbqf_0001", motion = this.MOTION_TABLE.DYING.RAG_A},
		
		{name = "crp_mbqf_0007", motion = this.MOTION_TABLE.DYING.RAG_C},
		{name = "crp_mbqf_0005", motion = this.MOTION_TABLE.DYING.RAG_D}, 
		{name = "crp_mbqf_0008", motion = this.MOTION_TABLE.DYING.RAG_D},
		{name = "crp_mbqf_0013", motion = this.MOTION_TABLE.DYING.RAG_E},
		{name = "crp_mbqf_0003", motion = this.MOTION_TABLE.DYING.RAG_E}, 
		{name = "crp_mbqf_0012", motion = this.MOTION_TABLE.DYING.RAG_C},
		{name = "crp_mbqf_0006", motion = this.MOTION_TABLE.DYING.RAG_WALL_A},
		{name = "crp_mbqf_0002", motion = this.MOTION_TABLE.DYING.RAG_WALL_B},
		{name = "crp_mbqf_0014", motion = this.MOTION_TABLE.DYING.RAG_E},
		{name = "crp_mbqf_0016", motion = this.MOTION_TABLE.DYING.RAG_E},

		{name = "crp_mbqf_0004", motion = this.MOTION_TABLE.DYING.RAG_A}, 
		{name = "crp_mbqf_0000", motion = this.MOTION_TABLE.DYING.RAG_STRC_A}, 
		{name = "crp_mbqf_0011", motion = this.MOTION_TABLE.DYING.RAG_B}, 

		{name = "crp_mbqf_0015", motion = this.MOTION_TABLE.DYING.RAG_B}, 
	}

	for i,table in pairs(bodyMotionList)do
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", table.name ), { id = "SetInitMotion", path=table.motion } ) 
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", table.name ), { id = "KeepInitMotion", enabled=true } ) 
	end

end






this._SetEventFlag = function(soldierName, param)
	Fox.Log("SetEventFlag")
	if not Tpp.IsTypeString( soldierName )  then
		Fox.Error("soldierName is not string")
		return 
	end
	local flag = "forceDeadMessageOwnerPlayer"
	if param.flag == nil then
		Fox.Error("param.flag is nil")
		return 
	elseif param.flag == "ownerPlayer" then
		flag = "forceDeadMessageOwnerPlayer"

	elseif param.flag == "ownerInvalid" then
		flag = "forceDeadMessageOwnerInvalid"

	elseif param.flag == "friednMarker" then
		flag = "forceFriendlyMarker"

	end



	local enable = true
	if param.enable == false then
		enable = false
	end

	Fox.Log("set flag : "..soldierName..", "..flag..", "..tostring(enable) )
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
	local command = { id="SetSoldier2Flag", flag=flag , on=enable }
	GameObject.SendCommand( gameObjectId, command )
end


this.CallDamageVoice = function(gameObjectId, param)
	Fox.Log("call damege voice. attack by player")
	if gameObjectId == GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0003" ) and svars.numDoEventLast == 2 then
		return
	elseif gameObjectId == GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0010" ) then
		
		return
	end

	
	if not(param == nil ) and param.isAim == true then 
		local randomId = {
			"none",
			"DDD280",
			"DDD290",
			"DDD320",
		}
		local labelId = randomId[math.random(#randomId)]
		Fox.Log("label:"..labelId)
		if labelId == "none" then
			Fox.Log("no voice")
		else
			this.CallVoice(gameObjectId,"DD_vox_ene_s10240",labelId)
		end
	else
		
		if TppEnemy.GetLifeStatus( gameObjectId ) == TppGameObject.NPC_LIFE_STATE_DEAD then
			
			Fox.Log("CallDamageVoice: Dead")
			this.CallVoice(gameObjectId,"DD_vox_ene","EVD040")
		else
			
			Fox.Log("CallDamageVoice: Damage")
			this.CallVoice(gameObjectId,"DD_vox_ene","EVD030")
		end
	end

end



this.CallVoice = function(enemyId,voiceType,maleLabel,femaleLabel)
	Fox.Log("call damege voice")
	if enemyId == nil then Fox.Error("enemyId is nil") return end
	if voiceType == nil then Fox.Error("voiceType is nil") return end
	if maleLabel == nil then Fox.Error("label is nil") return end

	local gameObjectId
	if Tpp.IsTypeString( enemyId ) then
		gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
	else
		gameObjectId = enemyId
	end

	
	local label  = maleLabel
	
	local gender = GameObject.SendCommand( gameObjectId, { id = "GetSoldier2Gender" } )
	if gender == 1 and Tpp.IsTypeString( femaleLabel ) == true then 
		label = femaleLabel
	else
		label  = maleLabel	
	end

	local command = { id="CallVoice", dialogueName=voiceType, parameter=label }  
	GameObject.SendCommand( gameObjectId, command )  

end


this.CallTalkEnemy = function( enemyId, label)
	if enemyId == nil then
		Fox.Error("enemyid is nil")
	end
	
	if label == nil then
		Fox.Error("label is nil")
	end
	
	Fox.Log("func:CallTalkEnemy")
	local gameObjectId
	if Tpp.IsTypeString( enemyId ) then
		gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
	else
		gameObjectId = enemyId
	end
	
	local lifeState = GameObject.SendCommand( gameObjectId, { id = "GetLifeStatus" } )
	if lifeState ~= TppGameObject.NPC_LIFE_STATE_DEAD then
		Fox.Log("call converstion "..label)
		local command = {
			id = "CallMonologue",
			label = label,
		}
		GameObject.SendCommand( gameObjectId, command )
	else
		Fox.Log("dont call converstion. enemy dead ")
	end
end


this.SetForceRealize = function(enemyId, flag)
	Fox.Log("SetForceRealize")
	local gameObjectId
	if Tpp.IsTypeString( enemyId ) then
		gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
		GameObject.SendCommand( { type="TppCorpse" }, { id = "SetForceRealize", name = enemyId, forceRealize = enable } )--RETAILBUG enable undefined

	else
		gameObjectId = enemyId
	end

	local enable = true
	if flag == false then
		enable = false
	end

	Fox.Log("Force enable "..tostring(enemyId)..", "..tostring(enable) )
	GameObject.SendCommand( gameObjectId, { id="SetForceRealize", forceRealize=enable } )
end


this.AddEnemyRoute = function(enemyId,routeId,point)
	
	if enemyId == nil then return end
	if routeId == nil then return end

	local gameObjectId = GameObject.GetGameObjectId( enemyId )
	GameObject.SendCommand( gameObjectId, { id="SetSneakRoute", route=routeId, point=routePointNum } )--RETAILBUG routePointNum
	GameObject.SendCommand( gameObjectId, { id="SetCautionRoute", route=routeId, point=routePointNum } )
	GameObject.SendCommand( gameObjectId, { id = "SetAlertRoute", 	enabled = true, route=routeId, point=routePointNum }  ) 

end



this.ChangeRoute = function(beforeRoute, afterRoute,point)
	Fox.Log("change route")
	if beforeRoute == nil then
		Fox.Error("beforeRoute is nil")
		return 
	end
	if afterRoute == nil then 
		Fox.Error("afterRoute is nil")
		return 
	end

	local routePointNum = 0
	if not point == nil then
		routePointNum = point
	end

	local gameObjectId = { type="TppSoldier2" } 
	local command = { id="GetGameObjectIdUsingRoute", route=beforeRoute }
	local soldiers = GameObject.SendCommand( gameObjectId, command )
	Fox.Log( "soldier num "..#soldiers )
	if #soldiers > 0 then
		for i, soldier in ipairs(soldiers) do
			Fox.Log( string.format("0x%x", soldier) )
			GameObject.SendCommand( soldier, { id="SetSneakRoute", route=afterRoute, point=routePointNum } )
			GameObject.SendCommand( soldier, { id="SetCautionRoute", route=afterRoute, point=routePointNum } )
			GameObject.SendCommand( soldier, { id = "SetAlertRoute",  enabled = true, route=afterRoute, point=routePointNum }  ) 
	
			Fox.Log( "soldierID : "..soldier..". change route. "..beforeRoute.." > "..afterRoute )
		end
	else
		Fox.Log("return. no soldier")
		return
	end

end



this.SetObieMotion = function(gameObjectId)
	Fox.Log("change motion. obie")

	
	for i=1, #this.DownEnemyList do
		if  gameObjectId == GameObject.GetGameObjectId( "TppSoldier2", this.DownEnemyList[i].name ) then

			
			if this.DownEnemyList[i].dead == nil then
				Fox.Log("obie motion is nil")

			
			elseif gameObjectId ==  GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0010" ) and svars.numEvent2F3 > 0 then
				return 
			
			else
				
				if s10240_sequence.CheckObieFlag(i) == false then
					Fox.Log("obie play"..i )
					this._SetSpecialActionForEvent(this.DownEnemyList[i].name, this.DownEnemyList[i].obie,false,"ObieLoop")
					s10240_sequence.SetObieFlag(i)

					
					this.CallObieVoice(i)
				else
					
					if not GkEventTimerManager.IsTimerActive("Timer_Shake") then
						this.CallDamageVoice(gameObjectId,{ isAim = true })
					end
				end
			end

		return
		end
	end
end

this.DamageMotion = function(gameObjectId)
	Fox.Log("DamageMotion()")

	
	local motionTable = {
		[this.MOTION_TABLE.DYING.IDLE_A] = this.MOTION_TABLE.DAMAGE.OBIE_A, 
		[this.MOTION_TABLE.DYING.IDLE_B] = this.MOTION_TABLE.DAMAGE.OBIE_B,
		[this.MOTION_TABLE.DYING.IDLE_C] = this.MOTION_TABLE.DAMAGE.OBIE_C, 
		[this.MOTION_TABLE.DYING.IDLE_D] = this.MOTION_TABLE.DAMAGE.OBIE_D, 
		[this.MOTION_TABLE.DYING.IDLE_P] = this.MOTION_TABLE.DAMAGE.OBIE_B,
		[this.MOTION_TABLE.OBIE.IDLE_A] = this.MOTION_TABLE.DAMAGE.IDLE_A, 
		[this.MOTION_TABLE.OBIE.IDLE_B] = this.MOTION_TABLE.DAMAGE.IDLE_B, 
		[this.MOTION_TABLE.OBIE.IDLE_C] = this.MOTION_TABLE.DAMAGE.IDLE_C, 
		[this.MOTION_TABLE.OBIE.IDLE_D] = this.MOTION_TABLE.DAMAGE.IDLE_D, 
		[this.MOTION_TABLE.OBIE.IDLE_E] = this.MOTION_TABLE.DAMAGE.IDLE_E, 
	}
	for i=1, #this.DownEnemyList do
		if  gameObjectId == GameObject.GetGameObjectId( "TppSoldier2", this.DownEnemyList[i].name ) then

			if this.DownEnemyList[i].dead == nil then
				Fox.Log("damage motion is nil")
				
			
			elseif gameObjectId ==  GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0010" ) and svars.numEvent2F3 > 0 then
				return 
			else				
				
				
				if TppEnemy.GetLifeStatus( this.DownEnemyList[i].name ) == TppEnemy.LIFE_STATUS.DEAD then
					Fox.Log("enemy dead alredy "..tostring(this.DownEnemyList[i].name) )
					return
				end
				
				local damageMotion = this.MOTION_TABLE.DAMAGE.IDLE_A
				if s10240_sequence.CheckObieFlag(i) == true then
					
					damageMotion = motionTable[ this.DownEnemyList[i].loop ]
				else
					
					damageMotion = motionTable[ this.DownEnemyList[i].motion ]				
				end

				if not (damageMotion == nil ) then
					this._SetSpecialActionForEvent(this.DownEnemyList[i].name, damageMotion,false,"ObieLoop")
					s10240_sequence.SetObieFlag(i)
				end
			end
		end
	end
	
end

this.CallObieVoice = function(i)
	
	
	Fox.Log("func:CallObieVoice")
	if this.DownEnemyList[i].obieVoice == nil then
		Fox.Log("no voice")
	else
		Fox.Log("play obie voice")
		this.CallTalkEnemy( this.DownEnemyList[i].name, this.DownEnemyList[i].obieVoice)
	end
end

this.SetObieLoopMotion = function(gameObjectId)
	Fox.Log("change loop motion. obie")

	
	for i=1, #this.DownEnemyList do
		if  gameObjectId == GameObject.GetGameObjectId( "TppSoldier2", this.DownEnemyList[i].name ) then

			
			if this.DownEnemyList[i].dead == nil then
				Fox.Log("obie motion is nil")
			else
				
				local lifeState = GameObject.SendCommand( gameObjectId, { id = "GetLifeStatus" } )
				if lifeState == TppGameObject.NPC_LIFE_STATE_NORMAL then
					Fox.Log("mobie play")
					this._SetSpecialActionForEvent(this.DownEnemyList[i].name, this.DownEnemyList[i].loop,true)
				end
			end
		return
		end
	end
end


this.SetDeadMotionHanyou = function(gameObjectId)
	Fox.Log("change motion. dead")
	
	for i=1, #this.DownEnemyList do
		if  gameObjectId == GameObject.GetGameObjectId( "TppSoldier2", this.DownEnemyList[i].name ) then

			
			if this.DownEnemyList[i].dead == nil then
				Fox.Log("dead motion is nil")
			else
				Fox.Log("dead play")
				this._SetDeadSpecialActionForEvent(this.DownEnemyList[i].name, this.DownEnemyList[i].dead)
			end
		return
		end
	end
end



this._SetZombie = function( gameObjectName, disableDamage, isHalf )
	if isHalf ~= true then
		isHalf = false
	end

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", gameObjectName )
	GameObject.SendCommand( gameObjectId, { id = "SetZombie", enabled=true,  isHalf=isHalf } )	
	GameObject.SendCommand( gameObjectId, { id = "SetMaxLife", life = 300, stamina = 10})
	GameObject.SendCommand( gameObjectId, { id = "SetZombieUseRoute", enabled=true } )
	if disableDamage == true then
		GameObject.SendCommand( gameObjectId, { id = "SetDisableDamage", life = false, faint = true, sleep = true } )
	end
	if isHalf then
		local ignoreFlag = 0
		GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	end

end

this.SetZombie1F = function()
	
	local zombieEnemy = {
		"sol_mbqf_0014",
		"sol_mbqf_0015",
		"sol_mbqf_0016",
	}

	for i, enemyName in ipairs(zombieEnemy) do
			this._SetZombie( enemyName, true, true )
	end

	s10240_enemy02.AddEnemyRoute("sol_mbqf_0014","rts_mbqf_zombie_0001",0)
	s10240_enemy02.AddEnemyRoute("sol_mbqf_0015","rts_mbqf_zombie_0002",0)
	s10240_enemy02.AddEnemyRoute("sol_mbqf_0016","rts_mbqf_zombie_0000",0)
end

this.SetRouteZombie1F = function()
	local ignoreFlag = 0
	local command =  { id = "SetIgnoreDamageAction", flag = ignoreFlag } 
	GameObject.SendCommand(  GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0014" ),command)
	GameObject.SendCommand(  GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0015" ),command)

	s10240_enemy02.AddEnemyRoute("sol_mbqf_0014","rts_mbqf_zombie_0004",0)
	s10240_enemy02.AddEnemyRoute("sol_mbqf_0015","rts_mbqf_zombie_0005",0)
end

this.SetRouteZombie1FAfter = function()
	local ignoreFlag = 0
	local command =  { id = "SetIgnoreDamageAction", flag = ignoreFlag } 
	GameObject.SendCommand(  GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0016" ),command)

	s10240_enemy02.AddEnemyRoute("sol_mbqf_0016","rts_mbqf_zombie_0003",0)
end



this.SetZombie2F = function()
	
	this._SetZombie( "sol_mbqf_0008" )
end

this.CheckEnemyDead = function(floorNum)
	
	
	local table
	if floorNum == 3 then
		table = this.ENAMY_LIST.FLOOR3
	elseif floorNum == 2 then
		table = this.ENAMY_LIST.FLOOR2
	elseif floorNum == 1 then
		table = this.ENAMY_LIST.FLOOR1
	elseif floorNum == 0 then
		table = this.ENAMY_LIST.FLOOR0	
	else
		Fox.Error("floorNum is false")
		return
	end
	
	
	local gameObjectId
	local command
	local lifeState
	local enableState
	
	for i,enemyId in pairs(table)do
		
		gameObjectId = GameObject.GetGameObjectId( enemyId )
		lifeState = GameObject.SendCommand( gameObjectId, { id = "GetLifeStatus" } )
		enableState = GameObject.SendCommand( gameObjectId, { id = "GetStatus" } )
		if lifeState ~= TppGameObject.NPC_LIFE_STATE_DEAD and enableState ~= TppGameObject.NPC_STATE_DISABLE then
			
			
			return false
		end
	end
	return true
end



this.CheckEnemyLiveForTutorial = function()
	local table = {
		"sol_mbqf_1007",
		"sol_mbqf_1008",
	}
	local gameObjectId
	local command
	local lifeState
	local enableState
	
	for i,enemyId in pairs(table)do
		
		gameObjectId = GameObject.GetGameObjectId( enemyId )
		lifeState = GameObject.SendCommand( gameObjectId, { id = "GetLifeStatus" } )
		enableState = GameObject.SendCommand( gameObjectId, { id = "GetStatus" } )

		if lifeState ~= TppGameObject.NPC_LIFE_STATE_DEAD and enableState ~= TppGameObject.NPC_STATE_DISABLE then
			return true
		end
	end
	return false
end


this.CheckEnemyDistForTutorial = function()
	local table = {
		"sol_mbqf_1007",
		"sol_mbqf_1008",
		"sol_mbqf_0004",
	}
	
	local dist
	for i,enemyId in pairs(table)do
		dist = this._GetDistPlayerToEnemy(enemyId)
		if dist < 6*6 then
			return true
		end
	end
	return false
end


this._GetDistPlayerToEnemy = function(enemyId)
	Fox.Log("::Get GameObject Pos")
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2",enemyId )
	
	
	local lifeState = GameObject.SendCommand( gameObjectId, { id = "GetLifeStatus" } )
	if lifeState == TppGameObject.NPC_LIFE_STATE_DEAD then
		return 200*200
	end
	
	local command = { id = "GetPosition" }
	local position = GameObject.SendCommand( gameObjectId, command )
	if position == nil then
		Fox.Error("can not get position")
		return false
	end
	local point1 = TppMath.Vector3toTable( position )
	local point2 =  { vars.playerPosX, vars.playerPosY, vars.playerPosZ }
	local dist = TppMath.FindDistance( point1, point2 )

	if dist == false or nil then
		return 200*200
	else
		return dist
	end
end


this.GetDistLiveManToRoom = function()
	Fox.Log("::Get GameObject Pos")
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2","sol_mbqf_0003" )
	
	
	local lifeState = GameObject.SendCommand( gameObjectId, { id = "GetLifeStatus" } )
	if lifeState == TppGameObject.NPC_LIFE_STATE_DEAD then
		return 200*200
	end
	
	local command = { id = "GetPosition" }
	local position = GameObject.SendCommand( gameObjectId, command )
	if position == nil then
		Fox.Error("can not get position")
		return false
	end
	local point1 = TppMath.Vector3toTable( position )
	local point2 =  { -3.963, -4.000, 20.129 } 
	local dist = TppMath.FindDistance( point1, point2 )

	if dist == false or nil then
		return 200*200
	else
		return dist
	end
end


this.SetDeadHoken = function(floorNum)
	Fox.Log("hoken dead group"..floorNum )

	local table
	if floorNum == 3 then
		table = this.ENAMY_LIST.FLOOR3
	elseif floorNum == 2 then
		table = this.ENAMY_LIST.FLOOR2
	elseif floorNum == 1 then
		table = this.ENAMY_LIST.FLOOR1
	elseif floorNum == 0 then
		table = this.ENAMY_LIST.FLOOR0	
	else
		table = this.ENAMY_LIST.OTHER	

	end
	
	local gameObjectId 

	
	local aliveNum = 0
	for i,enemyId in pairs(table)do

		if TppEnemy.GetLifeStatus( enemyId ) ~= TppEnemy.LIFE_STATUS.DEAD then
			Fox.Log( enemyId.." is alive")
			aliveNum = aliveNum + 1
		else
			Fox.Log( enemyId.." is dead")
		end
	end

	Fox.Log("aliveNum is "..aliveNum )

	if aliveNum <= 2 then
		Fox.Log("hoken dead")
		for i,enemyId in pairs(table)do

			if TppEnemy.GetLifeStatus( enemyId ) == TppEnemy.LIFE_STATUS.DEAD then
				Fox.Log( enemyId.." is dead alredy")
			else
				
				TppEnemy.SetDisable( enemyId )
				
			end
		end

	else
		Fox.Log("hoken dead is skip")
	end

end

this.SetDisableCarried = function()
	
	local gameObjectId
	local command = { id = "SetForceDisableCarried", enabled=true }
	for i,enemyId in pairs( this.soldierDefine.mbqf_mbqf_cp )do
		gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
		GameObject.SendCommand( gameObjectId, command )
	end

	
	for i,enemyId in pairs( this.DisableCarriedCorpse )do
		
		gameObjectId = GameObject.GetGameObjectId( enemyId )
		GameObject.SendCommand( gameObjectId, command )
	end
end


this.SetNoClothAnim = function()

	local command = { id = "SetClothStop", active=false }
	for i,name in pairs(this.DisableCarriedCorpse)do
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", name ), command )
	end
end





this.StartEvent1F4 = function( enemyId )

	Fox.Log("play event 1F4")
	TppEnemy.SetEnable( enemyId )

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
	GameObject.SendCommand( gameObjectId, {
	        id="SpecialAction",
	        path=this.MOTION_TABLE.EVENT.E1F_4ROOM,
	        stance=EnemyStance.STANCE_STAND,
	        autoFinish=true,
	        enableMessage=true,
	        enableGravity=true,
	        enableCollision=true,
	} )
	GameObject.SendCommand(gameObjectId, { id = "SetDisableDamage", life = false, faint = true, sleep = true } )
	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.FLASH_LIGHT )
	GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
end

this.SetEvent2F1Secondary = function()
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0019" )
	GameObject.SendCommand( gameObjectId, { id="DisablePickupMainWeapon", enabled=true } )
	

end



this.IdleEvent2F1 = function()
	this._SetSpecialActionForEvent("sol_mbqf_0019",this.MOTION_TABLE.EVENT.E2F1_C_IDLE,true,nil, nil, false)

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0019" )
	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.FLASH_LIGHT )
	GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )


end

this.StartEvent2F1 = function()
	Fox.Log("2F1 start event")
	
	this._SetSpecialActionForEvent("sol_mbqf_0019",this.MOTION_TABLE.EVENT.E2F1_TURN,false,"E2F_Turn_End", nil, false)
end

this.IdleEvent2F1B = function()
	Fox.Log("IdleEvent2F1B()")
	this._SetSpecialActionForEvent("sol_mbqf_0019",this.MOTION_TABLE.EVENT.E2F1_S_IDLE,true, nil, nil, false)
end

this.StartEvent2F1HandGun = function()
	Fox.Log("StartEvent2F1HandGun()")
	this._SetSpecialActionForEvent("sol_mbqf_0019",this.MOTION_TABLE.EVENT.E2F1_HANDGUN,false,"E2F_HandGun_End", nil, false)
end

this.IdleEvent2F1HandGun = function()
	Fox.Log("IdleEvent2F1HandGun()")
	this._SetSpecialActionForEvent("sol_mbqf_0019",this.MOTION_TABLE.EVENT.E2F1_H_IDLE,true, nil, nil, false)
end

this.DeadEvent2F1 = function()
	Fox.Log("DeadEvent2F1")
	this._SetDeadSpecialActionForEvent("sol_mbqf_0019",this.MOTION_TABLE.EVENT.E2F1_SELF)
end

this.PushEvent2F1 = function()
	
	Fox.Log("push 2f1")
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0019" )
	GameObject.SendCommand( gameObjectId, { id = "SetUnarmed", enabled=false })	
	GameObject.SendCommand( gameObjectId,  { id = "ChangeEquipSlot", slot = SoldierSlotType.SECONDARY } )

	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.PUSH )
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.BULLET )
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.FLASH_LIGHT )
	GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )

	Fox.Log("IdleEvent2F1HandGun()")
	this._SetSpecialActionForEvent("sol_mbqf_0019",this.MOTION_TABLE.EVENT.E2F1_H_IDLE,true, nil, nil, false)
end





this.StartEvent2F3 = function()
	Fox.Log("StartEvent2F3()")
	local path = this.MOTION_TABLE.EVENT.E2F_3START
	local enemyId = "sol_mbqf_0010"
	this._SetSpecialActionForEvent(enemyId, path)

	local enemyName = GameObject.GetGameObjectId( "TppSoldier2",enemyId )
	GameObject.SendCommand( enemyName, { id = "SetUnarmed", enabled=true })	

	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.BULLET )
	
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.FLASH_LIGHT )
	GameObject.SendCommand( enemyName, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )

end

this.SetDeadFlag2F3 = function()
	Fox.Log("SetDeadFlag2F3()")
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0010" )
	local command = { id = "SetDisableDamage", life = true, faint = true, sleep = true }
	GameObject.SendCommand( gameObjectId, command )
end

this.IdletEvent2F3 = function()
	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0010" )
	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.BULLET )
	GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	local path = this.MOTION_TABLE.EVENT.E2F_3IDLE

	this._SetSpecialActionForEvent(gameObjectId, path)

end

this.AoriEvent2F3 = function()
	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0010" )
	GameObject.SendCommand( gameObjectId, { id = "SetUnarmed", enabled=false })	
	GameObject.SendCommand( gameObjectId,  { id = "ChangeEquipSlot", slot = SoldierSlotType.SECONDARY } )

	local path = this.MOTION_TABLE.EVENT.E2F_3AORI
	local enemyId = "sol_mbqf_0010"
	this._SetSpecialActionForEvent(gameObjectId, path)
end


this.SelfiEvent2F3 = function()
	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0010" )
	GameObject.SendCommand( gameObjectId, { id = "SetUnarmed", enabled=false })	
	local path = this.MOTION_TABLE.EVENT.E2F_3SELF
	this._SetDeadSpecialActionForEvent(gameObjectId, path)

	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.BULLET )
	this._SetEventFlag( "sol_mbqf_0010", { flag = "ownerPlayer", enable = false} )
	this._SetEventFlag( "sol_mbqf_0010", { flag = "ownerInvalid", enable = true} )
	GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )

end

this.DeadEvent2F3 = function()
	Fox.Log("DeadEvent2F3()")
	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0010" )
	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.BULLET )
	GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )

	GameObject.SendCommand( gameObjectId, { id = "RecoveryLife" } )
	
	local path = this.MOTION_TABLE.EVENT.E2F_3DEAD
	local enemyId = "sol_mbqf_0010"
	this._SetDeadSpecialActionForEvent(enemyId, path)

end

this.PushEvent2F3 = function()
	Fox.Log("push 2f3")
	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0010" )
	GameObject.SendCommand( gameObjectId, { id = "SetUnarmed", enabled=false })	
	GameObject.SendCommand( gameObjectId,  { id = "ChangeEquipSlot", slot = SoldierSlotType.SECONDARY } )

	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.PUSH )
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.BULLET )
	GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )


	local path = this.MOTION_TABLE.EVENT.E2F_3SELF
	GameObject.SendCommand( gameObjectId, {
	        id="SpecialAction",
	        path=path,
	        stance=EnemyStance.STANCE_SUPINE,
	        autoFinish=true,
	        enableMessage=false,
	        enableGravity=true,
	        enableCollision=true,
	        enableDeadEnd = true,
			interpFrame=16,
			startFrame=400,
	} )
end





this.StartShoot3F = function()
	Fox.Log("StartShoot3F()")
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0017" )
	local gameObjectId2 = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_1008" )

	local command = { id = "SetEnableDyingState", enabled = true }
	GameObject.SendCommand( gameObjectId, command )
	GameObject.SendCommand( gameObjectId2, command )

	command = { id = "SetMaxLife", life = 400, stamina = 3000 }
	GameObject.SendCommand( gameObjectId, command )
	GameObject.SendCommand( gameObjectId2, command )

	command = { id = "SetForceDyingFire", toEnemy=true }
	GameObject.SendCommand( gameObjectId, command )
	GameObject.SendCommand( gameObjectId2, command )

	command = { id = "SetDyingFireInfinity", enabled=true }
	GameObject.SendCommand( gameObjectId, command )
	GameObject.SendCommand( gameObjectId2, command )
end

this.LastShoot3F = function()
	Fox.Log("LastShoot3F()")
	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_1008" )
	local command = { id = "DyingFireOnce" }
	GameObject.SendCommand( gameObjectId, command )

	local command2 = { id = "SetDyingFireInfinity", enabled=false }
	GameObject.SendCommand( gameObjectId, command2 )

end



this.EndShoot3F = function()
	Fox.Log("EndShoot3F()")
	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_1008" )
	local command = { id = "SetForceDyingFire", toNone=true }
	GameObject.SendCommand( gameObjectId, command )

	local command2 = { id = "SetDyingFireInfinity", enabled=false }
	GameObject.SendCommand( gameObjectId, command2 )

	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0017" )
	local command = { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_DEAD }
	GameObject.SendCommand( gameObjectId, command )

end


this.EndShoot3F2 = function()
	Fox.Log("EndShoot3F2()")
	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_1008" )
	local command = { id = "SetForceDyingFire", toNone=false }
	GameObject.SendCommand( gameObjectId, command )

end




this.SetZombieMode = function(init)
	
	local zombieEnemy = {
		"sol_mbqf_0005",
		"sol_mbqf_0006",
		"sol_mbqf_0007",	
	}

	
	
	if init == "Reset" then
		TppEnemy.SetDisable( "sol_mbqf_0005" )
		TppEnemy.SetDisable( "sol_mbqf_0006" )
		TppEnemy.SetDisable( "sol_mbqf_0007" )
	
		s10240_enemy02.AddEnemyRoute("sol_mbqf_0005","rts_mbqf_4002",0)
		s10240_enemy02.AddEnemyRoute("sol_mbqf_0006","rts_mbqf_4000",0)
		s10240_enemy02.AddEnemyRoute("sol_mbqf_0007","rts_mbqf_4001",0)

		TppEnemy.SetEnable( "sol_mbqf_0005" )
		TppEnemy.SetEnable( "sol_mbqf_0006" )
		TppEnemy.SetEnable( "sol_mbqf_0007" )
	end

	for i, enemyName in ipairs(zombieEnemy) do
			this._SetZombie( enemyName, true )
	end

	s10240_enemy02.AddEnemyRoute("sol_mbqf_0005","rts_mbqf_4002",0)
	s10240_enemy02.AddEnemyRoute("sol_mbqf_0006","rts_mbqf_4000",0)
	s10240_enemy02.AddEnemyRoute("sol_mbqf_0007","rts_mbqf_4001",0)
	
end

this.SetEverDownRoof = function()
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0006" )

	local lifeState = GameObject.SendCommand( gameObjectId, { id = "GetLifeStatus" } )
	if not(lifeState == TppGameObject.NPC_LIFE_STATE_DEAD) then
		GameObject.SendCommand( gameObjectId, { id = "SetDisableDamage", life = false, faint = false, sleep = true } )
		GameObject.SendCommand( gameObjectId, { id="SetEverDown", enabled=true } )
		GameObject.SendCommand( gameObjectId, { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_FAINT} )
	end

end

this.SetRouteForBattle = function()

	local soldierName = "sol_mbqf_0006"
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", soldierName )
	GameObject.SendCommand( gameObjectId, { id = "SetZombie", enabled=true  } )	
	
	GameObject.SendCommand( gameObjectId, { id = "SetFriendly", enabled = false} )
	GameObject.SendCommand( gameObjectId, { id = "SetRestrictNotice", enabled = false } ) 
	this._SetEventFlag( soldierName, { flag = "friednMarker"} )
end


this.SetUpEvent2F4 = function()
	
	local ignoreFlag = 0
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0003" )
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.BULLET )
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.FLASH_LIGHT )
	GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	
	
end

this.UnsetEvent2F4 = function()
	
	local ignoreFlag = 0
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0003" )
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.NONE )
	GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )


end

this.DeadEvent2F4 = function()
	
	this._SetDeadSpecialActionForEvent("sol_mbqf_0003", this.MOTION_TABLE.EVENT.E2F_4START,true) 
end

this.StartEvent2F4 = function()
	Fox.Log("set last man motion")
	
	local enemyId = "sol_mbqf_0003"

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
	GameObject.SendCommand( gameObjectId, { id = "SetUnarmed", enabled=true })
	GameObject.SendCommand( gameObjectId, { id = "SetForceDisableCarried", enabled=false } )
	GameObject.SendCommand( gameObjectId, { id = "SetRestrictNotice", enabled = true } ) 
	GameObject.SendCommand( gameObjectId, {
	        id="SpecialAction",
	        path=this.MOTION_TABLE.DYING.IDLE_D,
	        stance=EnemyStance.STANCE_SUPINE,
	        autoFinish=false,
	        enableMessage=false,
	        enableGravity=true,
	        enableCollision=true,
	} )
end

this.FaintEvent2F4 = function()
	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0003" )
	GameObject.SendCommand( gameObjectId, { id="SetEverDown", enabled=true } )
	GameObject.SendCommand( gameObjectId, { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_FAINT } )

end
this.WakeUpEvent2F4 = function()
	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0003" )
	GameObject.SendCommand( gameObjectId, { id="SetEverDown", enabled=false } )
	GameObject.SendCommand( gameObjectId, { id="RecoveryStamina" } )
	GameObject.SendCommand( gameObjectId, { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_NORMAL } )
end


this.SetNodoLastMan = function(enable)
	
	local set
	if enable == false then
		set = false
	else
		set = true
	end
	
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0003" )
	GameObject.SendCommand( gameObjectId, { id = "SetEnableHotThroat", enabled = set } )

end

this.SetWakeMotionLastMan = function()
	this._SetSpecialActionForEvent("sol_mbqf_0003",this.MOTION_TABLE.EVENT.E1LASR_D2I,false,"LastManWakeUp")
	this.AddEnemyRoute( "sol_mbqf_0003", "", 0)
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0003" )
	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.BULLET )
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.PUSH )
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.FLASH_LIGHT )
	GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
end

this.SetWakeMotionLastMan2 = function()
	this._SetSpecialActionForEvent("sol_mbqf_0003",this.MOTION_TABLE.EVENT.E1LAST_A,false,"LastManWakeUp2")
end



this.SetIdleMotionLastMan = function()
	
	this._SetSpecialActionForEvent("sol_mbqf_0003",this.MOTION_TABLE.EVENT.E1LAST_IDLE,true)
end

this.SetDeadMotionLastMan = function()
	
	this._SetSpecialActionForEvent("sol_mbqf_0003",this.MOTION_TABLE.EVENT.E1LAST_DEAD,true)
end




this._SetForceEnableB1Room = function(enemyId)
	Fox.Log("Force enable "..enemyId)
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
	GameObject.SendCommand( gameObjectId, { id="SetForceRealize", forceRealize=true } )
	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.BULLET )
	GameObject.SendCommand( gameObjectId, { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
end

this._EnemySong = function(enemyId,songId)
	Fox.Log("EnemySong "..enemyId..":"..songId )
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
	GameObject.SendCommand( gameObjectId, { id="CallSoundEffect", sound=songId, isCheckShield=true, isFollow=true } )
end

this.PreSetEventB1Room = function()
	
	this._SetForceEnableB1Room("sol_mbqf_0022")
	this._SetForceEnableB1Room("sol_mbqf_0001")
	this._SetForceEnableB1Room("sol_mbqf_0018")
	this._SetForceEnableB1Room("sol_mbqf_0023")
	this._SetForceEnableB1Room("sol_mbqf_0024")

end



this.StartSongEvent = function()
	Fox.Log("check Song")
	
	this._EnemySong("sol_mbqf_0022",'vox_dd_hum_01')
	this._EnemySong("sol_mbqf_0001",'vox_dd_hum_02')
	this._EnemySong("sol_mbqf_0018",'vox_dd_hum_03')
	this._EnemySong("sol_mbqf_0023",'vox_dd_hum_04')
	this._EnemySong("sol_mbqf_0024",'vox_dd_hum_05')

end

this.StartEventB1Room = function()
	
	


	if TppEnemy.GetLifeStatus( "sol_mbqf_0012" ) ~= TppEnemy.LIFE_STATUS.DEAD then
		this._SetSpecialActionForEvent("sol_mbqf_0012"	, this.MOTION_TABLE.EVENT.E1B_A, nil, nil, nil, false)
		this._SetZombie("sol_mbqf_0012",false,true)
		
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0012" )
		GameObject.SendCommand( gameObjectId, { id = "SetUnarmed", enabled=false })	
		GameObject.SendCommand( gameObjectId, { id = "ChangeEquipSlot", slot = SoldierSlotType.SECONDARY } )
	end

	if TppEnemy.GetLifeStatus( "sol_mbqf_0013" ) ~= TppEnemy.LIFE_STATUS.DEAD 
	and TppEnemy.GetLifeStatus( "sol_mbqf_0000" ) ~= TppEnemy.LIFE_STATUS.DEAD then
		this._SetSpecialActionForEvent("sol_mbqf_0013"	, this.MOTION_TABLE.EVENT.E1B_B)
		this._SetSpecialActionForEvent("sol_mbqf_0000"	, this.MOTION_TABLE.EVENT.E1B_C)
		this._SetZombie("sol_mbqf_0013",false,true)
		this._SetZombie("sol_mbqf_0000",false,true)
	end
	

	local ignoreFlag = 0
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0012" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0013" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0000" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
end

this.SetB1Unarm = function()
	Fox.Log("set Unarmed 0012 B1")
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0012" )
	GameObject.SendCommand( gameObjectId, { id = "SetUnarmed", enabled=true })
end

this.IdleEventB1Room = function()
	
	
	if TppEnemy.GetLifeStatus( "sol_mbqf_0012" ) ~= TppEnemy.LIFE_STATUS.DEAD then
		this._SetSpecialActionForEvent("sol_mbqf_0012"	, this.MOTION_TABLE.EVENT.E1B_SONG_IDLE_A,true)
	end

	if TppEnemy.GetLifeStatus( "sol_mbqf_0013" ) ~= TppEnemy.LIFE_STATUS.DEAD then
		this._SetSpecialActionForEvent("sol_mbqf_0013"	, this.MOTION_TABLE.EVENT.E1B_SONG_IDLE_A,true)
	end
	
	if TppEnemy.GetLifeStatus( "sol_mbqf_0000" ) ~= TppEnemy.LIFE_STATUS.DEAD then
		this._SetSpecialActionForEvent("sol_mbqf_0000"	, this.MOTION_TABLE.EVENT.E1B_SONG_IDLE_B,true)
	end
end

this.WaitEventB1Room = function()
	

	this._SetZombie("sol_mbqf_0001",false,true)
	this._SetZombie("sol_mbqf_0018",false,true)
	this._SetZombie("sol_mbqf_0022",false,true)
	this._SetZombie("sol_mbqf_0023",false,true)
	this._SetZombie("sol_mbqf_0024",false,true)
	
	this._SetSpecialActionForEvent("sol_mbqf_0001"	, this.MOTION_TABLE.EVENT.E1B_IDLE,true)
	this._SetSpecialActionForEvent("sol_mbqf_0018"	, this.MOTION_TABLE.DYING.IDLE_D,true) 
	this._SetSpecialActionForEvent("sol_mbqf_0022"	, this.MOTION_TABLE.EVENT.E1B_IDLE,true) 
	this._SetSpecialActionForEvent("sol_mbqf_0023"	, this.MOTION_TABLE.EVENT.E1B_IDLE,true)
	this._SetSpecialActionForEvent("sol_mbqf_0024"	, this.MOTION_TABLE.EVENT.E1B_IDLE,true) 

	local ignoreFlag = 0
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0001" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0018" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0022" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0023" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0024" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )

end

this.StandUpEventB1Room = function()
	
	this._SetSpecialActionForEvent("sol_mbqf_0001"	, this.MOTION_TABLE.EVENT.E1B_UP_RA)
	this._SetSpecialActionForEvent("sol_mbqf_0018"	, this.MOTION_TABLE.EVENT.E1B_UP_FB)
	this._SetSpecialActionForEvent("sol_mbqf_0022"	, this.MOTION_TABLE.EVENT.E1B_UP_FA)
	this._SetSpecialActionForEvent("sol_mbqf_0023"	, this.MOTION_TABLE.EVENT.E1B_UP_FB)
	this._SetSpecialActionForEvent("sol_mbqf_0024"	, this.MOTION_TABLE.EVENT.E1B_UP_LB)

	local ignoreFlag = 0
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.BULLET )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0001" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0018" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0022" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0023" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0024" ), { id = "SetIgnoreDamageAction", flag = ignoreFlag } )

end
this.SongEventB1Room = function(enemyId)
	Fox.Log("change motion. K-ray Idle")
	local gameObjectId
	if Tpp.IsTypeString( enemyId ) then
		gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
	else
		gameObjectId = enemyId
	end

	if gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0001" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_SONG_IDLE_B,false,nil,560)
	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0018" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_SONG_IDLE_D)
	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0022" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_SONG_IDLE_B)
	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0023" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_SONG_IDLE_C)
	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0024" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_SONG_IDLE_A)
	end
end


this.AfterPushB1Room = function(enemyId)
	Fox.Log("change motion. after push")
	local gameObjectId
	if Tpp.IsTypeString( enemyId ) then
		gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyId )
	else
		gameObjectId = enemyId
	end
	if TppEnemy.GetLifeStatus( enemyId ) == TppEnemy.LIFE_STATUS.DEAD then
		return false
	end
	if gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0001" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_UP_RA,false,nil,470)

	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0018" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_UP_FB,false,nil,560)

	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0022" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_UP_FA,false,nil,260)

	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0023" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_UP_FB,false,nil,560)

	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0024" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_UP_LB,false,nil,460)

	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0012" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_A,false,nil,270) 

	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0013" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_B,false,nil,460) 

	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0000" ) then
		this._SetSpecialActionForEvent(gameObjectId	, this.MOTION_TABLE.EVENT.E1B_C,false,nil,350)

	end
end


this.SetDeadMotionSong = function(gameObjectId)
	Fox.Log("change motion. dead")
	if gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0001" ) then
		this._SetDeadSpecialActionForEvent("sol_mbqf_0001"	, this.MOTION_TABLE.DEAD.IDLE_B)
		
	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0018" ) then
		this._SetDeadSpecialActionForEvent("sol_mbqf_0018"	, this.MOTION_TABLE.DEAD.IDLE_C)
		
	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0022" ) then
		this._SetDeadSpecialActionForEvent("sol_mbqf_0022"	, this.MOTION_TABLE.DEAD.IDLE_A)
		
	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0023" ) then
		this._SetDeadSpecialActionForEvent("sol_mbqf_0023"	, this.MOTION_TABLE.DEAD.IDLE_D)
		
	elseif gameObjectId == GameObject.GetGameObjectId( "sol_mbqf_0024" ) then
		this._SetDeadSpecialActionForEvent("sol_mbqf_0024"	, this.MOTION_TABLE.DEAD.IDLE_C)
	end

end


this.IdleEvent2rouka = function(flag)
	
	local enemyName = "sol_mbqf_0021"
	if flag == "two" then
		enemyName = "sol_mbqf_0026"
	end
	
	local ignoreFlag = 0
	
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.PUSH )
	ignoreFlag = bit.bor( ignoreFlag, IgnoreDamageActionFlag.FLASH_LIGHT )
	local command = { id = "SetIgnoreDamageAction", flag = ignoreFlag }
	local gameObjectId = GameObject.GetGameObjectId( enemyName )
	GameObject.SendCommand( gameObjectId, command )

	GameObject.SendCommand( gameObjectId, { id = "SetMaxLife", life = 400, stamina = 3000 } )
	GameObject.SendCommand( gameObjectId, { id = "SetEnableDyingState", enabled = true } )

	GameObject.SendCommand( gameObjectId, { id = "SetForceDyingFire", toNone=true } )
	
	this.SetNoKrei()
	
end

this.Set2FUnarmed = function()
	Fox.Log("Set2FUnarmed()")
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0021" ), { id = "SetUnarmed", enabled=true })
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_0026" ), { id = "SetUnarmed", enabled=true })
end

this.StartFireEvent2rouka = function(gameObjectId)
	local liveObjectId

	local lifeState = GameObject.SendCommand( GameObject.GetGameObjectId( "sol_mbqf_0021" ), { id = "GetLifeStatus" } )
	if lifeState == TppGameObject.NPC_LIFE_STATE_DEAD then
		liveObjectId = "sol_mbqf_0026"
	else
		liveObjectId = "sol_mbqf_0021"	
	end

	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", liveObjectId )
	GameObject.SendCommand( gameObjectId, { id = "SetUnarmed", enabled=false })
	GameObject.SendCommand( gameObjectId, { id = "ChangeEquipSlot", slot = SoldierSlotType.SECONDARY } )
	GameObject.SendCommand( gameObjectId, { id = "SetForceDyingFire", toPlayer=true } )

end

this.ForObieEvent2rouka = function()
	this._SetSpecialActionForEvent("sol_mbqf_0021",this.MOTION_TABLE.EVENT.E2R_OBIE_A,false, "2roukaObie")
	this._SetSpecialActionForEvent("sol_mbqf_0026",this.MOTION_TABLE.EVENT.E2R_OBIE_B,false, "2roukaObie")
end

this.IdleObieEvent2rouka = function()
	this._SetSpecialActionForEvent("sol_mbqf_0021",this.MOTION_TABLE.OBIE.IDLE_E ,true)
	this._SetSpecialActionForEvent("sol_mbqf_0026",this.MOTION_TABLE.OBIE.IDLE_E ,true)
end






this.InitEnemy = function ()
	Fox.Log("*** enemu.lua s10240 InitEnemy ***")
	local mbqf_gimmick = {}

	mbqf_gimmick.gimmickIdentifierParamTable = {
		mbqf_casset001 = {
			type = TppGameObject.GAME_OBJECT_TYPE_RADIO_CASSETTE,
			locatorName = "afgh_radi001_csst001_gim_n0000|srt_afgh_radi001_csst001",
			dataSetName = "/Assets/tpp/level/location/mtbs/block_large/mtbs_qrntnFacility_gimmick.fox2",
			gimmickType = TppGimmick.GIMMICK_TYPE.CSET,
			blockSmall = {101,102} ,
		}
	}

	TppGimmick.SetUpIdentifierTable( mbqf_gimmick.gimmickIdentifierParamTable )

	
	this.SetInitMotionBody()

	
	local command = { id = "SetDisableWarpToNav", enabled=true }
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_1002" ), command )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_1003" ), command )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_1007" ), command )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_1010" ), command )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", "sol_mbqf_1011" ), command )
	this.SetNoKrei()
	this.SetBloodFace()
	


end




this.SetUpEnemy = function ()
	Fox.Log("*** enemu.lua s10240 SetUpEnemy ***")

	TppEnemy.RegisterCombatSetting( this.combatSetting )

	local gameObjectId
	gameObjectId = { type="TppCommandPost2", index=0} 
	GameObject.SendCommand( gameObjectId, { id = "SetCpType", type = CpType.TYPE_AMERICA } )
	GameObject.SendCommand( gameObjectId, { id = "SetFriendlyCp" } )

	
	GameObject.SendCommand( { type="TppCorpse" }, { id = "SetInRoomRealizeMode", enabled = true } )
	GameObject.SendCommand( { type="TppSoldier2" }, { id = "SetInRoomRealizeMode", enabled = true } )

	
	
	TppEffectUtility.SetDirtyModelMemoryStrategy("AllHuman")
	this.SetBloodFace()

	
	GameObject.SendCommand( { type="TppCorpse" }, { id = "DisableDeactiveInUnrealize", enabled = true } )

	
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0001" ), { id = "SetBurnt", enabled = true } )
	GameObject.SendCommand( GameObject.GetGameObjectId( "TppCorpse", "crp_mbqf_0008" ), { id = "SetBurnt", enabled = true } )	

	
	gameObjectId = { type="TppSoldier2" } 
	GameObject.SendCommand( gameObjectId, { id = "SetEnableHotThroat", enabled = true } )
	
	GameObject.SendCommand( gameObjectId, { id = "SetSlowDeadSoundEffect", enabled=true } )



	this.SetMotionDown()
	this.SetEnemyWeapon()
	this.DisableEnemy()

	this.SetNoKrei()
	this.SetFova()

end



this.OnLoad = function ()
	Fox.Log("*** enemu.lua s10240 onload ***")

end




return this
