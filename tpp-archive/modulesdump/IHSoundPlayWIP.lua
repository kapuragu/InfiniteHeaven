
local this={}

this.packages={

 -- "/Assets/tpp/pack/mission2/ih/mgo_bgm.fpk",
   "/Assets/tpp/pack/mission2/ih/bgm_fob_ih.fpk",
  --DEBUG    "C:\\Projects\\MGS\\InfiniteHeaven\\SubMods\\bgm-mgo",
}

function this.AddMissionPacks(missionCode,packPaths)
  if missionCode < 5 then
    return
  end

    for i,path in ipairs(this.packages)do
      packPaths[#packPaths+1]=path
    end
end

this.bgmLabels={
  "Play_bgm_mtbs_phase",
"Play_bgm_f30050_eli",
"Play_bgm_mtbs_training",
"Play_p51_020030_bgm",
"Play_p51_020050",
"Play_bgm_mtbs_free_start",
"Play_bgm_mission_chase_phase",
 "Play_bgm_mission_chase_phase",
"Play_bgm_s10140_metallic",
"Play_bgm_s10140_post_metallic",
  --tpp jingles
  "Play_bgm_common_jingle_failed",
  "Play_bgm_common_jingle_clear",
  "Play_bgm_common_jingle_achieved",
  "Play_bgm_mission_heli_descent_short",
  "Play_bgm_mission_heli_descent_low",
  "Play_bgm_mission_heli_descent",
  "Play_bgm_mission_clear_heli",
  "Play_bgm_mission_clear_heli_sad",
  "Play_bgm_afgh_mission_escape",
  "Stop_bgm_afgh_mission_escape",
  "Play_bgm_mafr_mission_escape",
  "Stop_bgm_mafr_mission_escape",
  "Play_bgm_mission_start",


  "Play_bgm_common_jingle_op",
  "Play_bgm_afgh_jingle_op",
  "Play_bgm_mafr_jingle_op",
  "Play_chapter_telop",
  "Set_Switch_bgm_jingle_result_s",
  "Set_Switch_bgm_jingle_result_ab",
  "Set_Switch_bgm_jingle_result_ab",
  "Set_Switch_bgm_jingle_result_cd",
  "Set_Switch_bgm_jingle_result_cd",
  "Set_Switch_bgm_jingle_result_e",
  "Set_Switch_bgm_jingle_result_kaz",
  "Stop_bgm_common_jingle_ed",--
  "sfx_s_bgm_change_situation",
  --mtbs target quests?
  "Play_bgm_training_jingle_clear",
  "Play_bgm_training_jingle_failed",
  
  --mgo
  "Play_bgm_Freeplay",
  "Play_bgm_Theme",
  "Play_bgm_Intro_01",
  "Play_bgm_Outro_win",
  "Play_bgm_Outro_lose",
  "Play_bgm_Result_normal_01",
  "Play_bgm_Result_victory_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGO3",
  --name="mgo_UI_Briefing_BGM_ORIGINAL1",
  "Play_bgm_Default_Set1_phase_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGO3",
  --name="mgo_UI_Briefing_BGM_ORIGINAL2",
  "Play_bgm_ALT_phase_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGO3",
  --name="mgo_UI_Briefing_BGM_ORIGINAL3",
  "Play_bgm_ALT_A_phase_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_TPP",
  --name="mgo_UI_Briefing_BGM_TPP_CYPR",
  "Play_bgm_MGO_cypr_phase_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_TPP",
  --name="mgo_UI_Briefing_BGM_TPP_AFGH",
  "Play_bgm_MGO_afgh_phase_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_TPP",
  --name="mgo_UI_Briefing_BGM_TPP_AFRC",
  "Play_bgm_MGO_mafr_phase_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_TPP",
  --name="mgo_UI_Briefing_BGM_TPP_MTBS",
  "Play_bgm_MGO_mtbs_phase",
  --
  --game="mgo_UI_Briefing_BGM_Title_TPP",
  --name="mgo_UI_Briefing_BGM_TPP_SINS",
  "Play_bgm_TPP_Sinsoffather",
  --
  --game="mgo_UI_Briefing_BGM_Title_TPP",
  --name="mgo_UI_Briefing_BGM_TPP_QUIET",
  "Play_bgm_TPP_Quietstheme",
  --
  --game="mgo_UI_Briefing_BGM_Title_GZ",
  --name="mgo_UI_Briefing_BGM_GAMEPLAY",
  "Play_bgm_GZ_phase_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGR",
  --name="mgo_UI_Briefing_BGM_GAMEPLAY",
  "Play_bgm_RISING_phase_01",
  "Play_bgm_RISING_Intro",
  "Play_bgm_RISING_Outro_win",
  "Play_bgm_RISING_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGR",
  --name="mgo_UI_Briefing_BGM_MGR_MISTRAL",
  "Play_bgm_MGR_mystral",
  --"Play_bgm_RISING_Intro",
  --"Play_bgm_RISING_Outro_win",
  --"Play_bgm_RISING_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGR",
  --name="mgo_UI_Briefing_BGM_MGR_MONSOON",
  "Play_bgm_MGR_Monsoon",
  --"Play_bgm_RISING_Intro",
  --"Play_bgm_RISING_Outro_win",
  --"Play_bgm_RISING_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGR",
  --name="mgo_UI_Briefing_BGM_MGR_SUNDOWNER",
  "Play_bgm_MGR_sundowner",
  --"Play_bgm_RISING_Intro",
  --"Play_bgm_RISING_Outro_win",
  --"Play_bgm_RISING_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGR",
  --name="mgo_UI_Briefing_BGM_MGR_SAMUEL",
  "Play_bgm_MGR_samuel",
  --"Play_bgm_RISING_Intro",
  --"Play_bgm_RISING_Outro_win",
  --"Play_bgm_RISING_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGR",
  "mgo_UI_Briefing_BGM_MGR_ARMSTRONG",
  "Play_bgm_MGR_Armstrong",
  --"Play_bgm_RISING_Intro",
  --"Play_bgm_RISING_Outro_win",
  --"Play_bgm_RISING_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_PW",
  "mgo_UI_Briefing_BGM_OUTDOOR",
  "Play_bgm_MGSPW_OUT_phase_01",
  "Play_bgm_MGSPW_OUT_Intro",
  "Play_bgm_MGSPW_OUT_Outro_win",
  "Play_bgm_MGSPW_OUT_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_PW",
  --name="mgo_UI_Briefing_BGM_INDOOR",
  "Play_bgm_MGSPW_IN_phase_01",
  --"Play_bgm_MGSPW_IN_Intro",
  --"Play_bgm_MGSPW_OUT_Outro_win",
  --"Play_bgm_MGSPW_IN_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_PW",
  --name="mgo_UI_Briefing_BGM_PW_GEARREX",
  "Play_bgm_MGSPW_Gearrex",
  --"Play_bgm_MGSPW_IN_Intro",
  --"Play_bgm_MGSPW_OUT_Outro_win",
  --"Play_bgm_MGSPW_IN_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_PW",
  --name="mgo_UI_Briefing_BGM_THEME",
  "Play_bgm_PW_Metal2",
  --"Play_bgm_MGSPW_IN_Intro",
  --"Play_bgm_MGSPW_OUT_Outro_win",
  --"Play_bgm_MGSPW_IN_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_PW",
  --name="mgo_UI_Briefing_BGM_PW_YOKUSHI",
  "Play_bgm_MGSPW_yokushiryoku",
  --"Play_bgm_MGSPW_IN_Intro",
  --"Play_bgm_MGSPW_OUT_Outro_win",
  --"Play_bgm_MGSPW_IN_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGO2",
  --name="mgo_UI_Briefing_BGM_ORIGINAL1",
  "Play_bgm_MGS4_2_phase_01",
  "Play_bgm_MGS4_2_Intro_01",
  "Play_bgm_MGS4_1_Outro_win_01",
  "Play_bgm_MGS4_2_Outro_lose_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGO2",
  --name="mgo_UI_Briefing_BGM_ORIGINAL2",
  "Play_bgm_MGS4_1_phase_01",
  "Play_bgm_MGS4_1_Intro_01",
  --"Play_bgm_MGS4_1_Outro_win_01",
  --"Play_bgm_MGS4_1_Outro_lose_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS4",
  --name="mgo_UI_Briefing_BGM_MGS4_ME",
  "Play_bgm_MGS4ME_phase_01",
  --"Play_bgm_MGS4_1_Intro_01",
  --"Play_bgm_MGS4_1_Outro_win_01",
  --"Play_bgm_MGS4_1_Outro_lose_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS4",
  --name="mgo_UI_Briefing_BGM_MGS4_SA",
  "Play_bgm_MGS4SA_phase_01",
  --"Play_bgm_MGS4_1_Intro_01",
  --"Play_bgm_MGS4_1_Outro_win_01",
  --"Play_bgm_MGS4_1_Outro_lose_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS4",
  --name="mgo_UI_Briefing_BGM_MGS4_EE",
  "Play_bgm_MGS4EE_phase_01",
  --"Play_bgm_MGS4_1_Intro_01",
  --"Play_bgm_MGS4_1_Outro_win_01",
  --"Play_bgm_MGS4_1_Outro_lose_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS4",
  --name="mgo_UI_Briefing_BGM_MGS4_SM",
  "Play_bgm_MGS4SM_phase_01",
  --"Play_bgm_MGS4_1_Intro_01",
  --"Play_bgm_MGS4_1_Outro_win_01",
  --"Play_bgm_MGS4_1_Outro_lose_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS4",
  --name="mgo_UI_Briefing_BGM_MGS4_HV",
  "Play_bgm_MGS4HV_phase_01",
  --"Play_bgm_MGS4_1_Intro_01",
  --"Play_bgm_MGS4_1_Outro_win_01",
  --"Play_bgm_MGS4_1_Outro_lose_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS4",
  --name="mgo_UI_Briefing_BGM_MGS4_REXVSRAY",
  "Play_bgm_MGS4_Rexray",
  --"Play_bgm_MGS4_1_Intro_01",
  --"Play_bgm_MGS4_1_Outro_win_01",
  --"Play_bgm_MGS4_1_Outro_lose_01",
  --
  --game="mgo_UI_Briefing_BGM_Title_MPO",
  --name="mgo_UI_Briefing_BGM_GAMEPLAY",
  "Play_bgm_MGSP_OPS_phase_01",
  "Play_bgm_MGSP_OPS_Intro",
  "Play_bgm_MGSP_OPS_Outro_win",
  "Play_bgm_MGSP_OPS_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MPO",
  --name="mgo_UI_Briefing_BGM_MPO_RAXA",
  "Play_bgm_MPO_Raxa",
  --"Play_bgm_MGSP_OPS_Intro",
  --"Play_bgm_MGSP_OPS_Outro_win",
  --"Play_bgm_MGSP_OPS_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MPO",
  --name="mgo_UI_Briefing_BGM_MPO_SHOWTIME",
  "Play_bgm_MPO_Showtime",
  --"Play_bgm_MGSP_OPS_Intro",
  --"Play_bgm_MGSP_OPS_Outro_win",
  --"Play_bgm_MGSP_OPS_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGO1",
  --name="mgo_UI_Briefing_BGM_ORIGINAL",
  "Play_bgm_Pre_phase_01",
  "Play_bgm_Pre_Intro",
  "Play_bgm_Pre_Outro_win",
  "Play_bgm_Pre_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS3",
  --name="mgo_UI_Briefing_BGM_OUTDOOR",
  "Play_bgm_MGS3O_phase_01",
  --"Play_bgm_Pre_Intro",
  --"Play_bgm_Pre_Outro_win",
  --"Play_bgm_Pre_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS3",
  --name="mgo_UI_Briefing_BGM_INDOOR",
  "Play_bgm_MGS3IN_phase_01",
  --"Play_bgm_Pre_Intro",
  --"Play_bgm_Pre_Outro_win",
  --"Play_bgm_Pre_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS3",
  --name="mgo_UI_Briefing_BGM_MGS3_THEBOSS",
  "Play_bgm_MGS3_Theboss",
  --"Play_bgm_Pre_Intro",
  --"Play_bgm_Pre_Outro_win",
  --"Play_bgm_Pre_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS2SS",
  --name="mgo_UI_Briefing_BGM_VR",
  "Play_bgm_MGS2S_phase",
  "BGM_MGS2S_Intro",
  "BGM_MGS2S_Outro_win",
  "BGM_MGS2S_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS2SS",
  --name="mgo_UI_Briefing_BGM_MGS2SS_GURLUGON",
  "Play_bgm_MGS2S_Gurlugon",
  --"BGM_MGS2S_Intro",
  --"BGM_MGS2S_Outro_win",
  --"BGM_MGS2S_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS2",
  --name="mgo_UI_Briefing_BGM_MGS2_TANKER",
  "Play_bgm_MGS2T_phase_01",
  --"BGM_MGS2S_Intro",
  --"BGM_MGS2S_Outro_win",
  --"BGM_MGS2S_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS2",
  --name="mgo_UI_Briefing_BGM_MGS2_PLANT",
  "Play_bgm_MGS2P_phase_01",
  --"BGM_MGS2S_Intro",
  --"BGM_MGS2S_Outro_win",
  --"BGM_MGS2S_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS2",
  --name="mgo_UI_Briefing_BGM_MGS2_DEADCELL",
  "Play_bgm_MGS2_Boss",
  --"BGM_MGS2S_Intro",
  --"BGM_MGS2S_Outro_win",
  --"BGM_MGS2S_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS1IT",
  --name="mgo_UI_Briefing_BGM_VR",
  "Play_bgm_MGSI_phase",
  "BGM_MGSI_Intro",
  "BGM_MGSI_Outro_win",
  "BGM_MGSI_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS1IT",
  --name="mgo_UI_Briefing_BGM_MGS1IT_GENOLA",
  "Play_bgm_MGSI_genola",
  --"BGM_MGSI_Intro",
  --"BGM_MGSI_Outro_win",
  --"BGM_MGSI_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS1",
  --name="mgo_UI_Briefing_BGM_GAMEPLAY",
  "Play_bgm_MGS1_phase_01",
  --"BGM_MGSI_Intro",
  --"BGM_MGSI_Outro_win",
  --"BGM_MGSI_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MGS1",
  --name="mgo_UI_Briefing_BGM_MGS1_DUEL",
  "Play_bgm_MGS1_Boss",
  --"BGM_MGSI_Intro",
  --"BGM_MGSI_Outro_win",
  --"BGM_MGSI_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MG2",
  --name="mgo_UI_Briefing_BGM_GAMEPLAY",
  "Play_bgm_MG2_phase_01",
  "Play_bgm_MG2_Intro",
  "Play_bgm_MG2_Outro_win",
  "Play_bgm_MG2_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_MG1",
  "mgo_UI_Briefing_BGM_GAMEPLAY",
  "Play_bgm_MG_phase_01",
  "Play_bgm_MG_Intro",
  "Play_bgm_MG_Outro_win",
  "Play_bgm_MG_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_ACID2",
  --name="mgo_UI_Briefing_BGM_GAMEPLAY",
  "Play_bgm_MGA2_phase",
  "BGM_MGA_Intro",
  "BGM_MGA_Outro_win",
  "BGM_MGA_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_ACID2",
  --name="mgo_UI_Briefing_BGM_ACID2_DUALITY",
  "Play_bgm_MGA2_duality",
  --"BGM_MGA_Intro",
  --"BGM_MGA_Outro_win",
  --"BGM_MGA_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_ACID",
  --name="mgo_UI_Briefing_BGM_GAMEPLAY",
  "Play_bgm_MGA_phase",
  --"BGM_MGA_Intro",
  --"BGM_MGA_Outro_win",
  -- "BGM_MGA_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_ACID",
  --name="mgo_UI_Briefing_BGM_ACID_NIKO2",
  "Play_bgm_MGA_niko2",
  --"BGM_MGA_Intro",
  --"BGM_MGA_Outro_win",
  --"BGM_MGA_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_GB",
  --name="mgo_UI_Briefing_BGM_GAMEPLAY",
  "Play_bgm_MGGB_phase",
  "BGM_MGGB_Intro",
  "BGM_MGGB_Outro_win",
  "BGM_MGGB_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_GB",
  --name="mgo_UI_Briefing_BGM_GB_BC",
  "Play_bgm_MGGB_mggb16",
  --"BGM_MGGB_Intro",
  --"BGM_MGGB_Outro_win",
  --"BGM_MGGB_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_ANUBIS",
  --name="mgo_UI_Briefing_BGM_ANUBIS_JEHUTY",
  "Play_bgm_ZOE2_Jehuty",
  "BGM_ZOE2_Intro",
  "BGM_ZOE2_Outro_win",
  "BGM_ZOE2_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_ZOE",
  --name="mgo_UI_Briefing_BGM_ZOE_BOSS",
  "Play_bgm_ZOE_Boss",
  "BGM_ZOE_Intro",
  "BGM_ZOE_Outro_win",
  "BGM_ZOE_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_BKDS",
  --name="mgo_UI_Briefing_BGM_BKDS_LAPLACE",
  "Play_bgm_BKDS_Shooting",
  "BGM_BKDS_Intro",
  "BGM_BKDS_Outro_win",
  "BGM_BKDS_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_BK",
  --name="mgo_UI_Briefing_BGM_BK_WOD",
  "Play_bgm_BKGBS_st05boss2",
  "BGM_BKGBS_Intro",
  "BGM_BKGBS_Outro_win",
  "BGM_BKGBS_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_PN",
  --name="mgo_UI_Briefing_BGM_PN_ICAD",
  "Play_bgm_PN_icy",
  "BGM_PN_Intro",
  "BGM_PN_Outro_win",
  "BGM_PN_Outro_lose",
  --
  --game="mgo_UI_Briefing_BGM_Title_SN",
  --name="mgo_UI_Briefing_BGM_SNATCHER",
  "Play_bgm_SN_theme",
  "BGM_SN_Intro",
  "BGM_SN_Outro_win",
  "BGM_SN_Outro_lose",
--
--"mgo_idt_Rand",
--
--"mgo_UI_Briefing_BGM_OFF",
}--bgm


this.debug_PostJingleEvent={
  --save=IvarProc.CATEGORY_EXTERNAL,
  settings=this.bgmLabels,
  OnActivate=function(self,setting,previousSetting)
    TppMusicManager.StopJingleEvent()
    local bgmLabel=self.settings[setting+1]
    TppMusicManager.PostJingleEvent('SingleShot',bgmLabel)
  end,
}--debug_PostJingleEvent

--see PlayMusicFromQuietRoom
local quietRadioNames={
  "[Autoplay]",
  "Heavens Divide",
  "Koi no Yokushiryoku",
  "Gloria",
  "Kids In America",
  "Rebel Yell",
  "The Final Countdown",
  "Nitrogen",
  "Take On Me",
  "Ride A White Horse",
  "Maneater",
  "A Phantom Pain",
  "Only Time Will Tell",
  "Behind the Drapery",
  "Love Will Tear Us Apart",
  "All the Sun Touches",
  "TRUE",
  "Take The DW",
  "Friday Im In Love",
  "Midnight Mirage",
  "Dancing With Tears In My Eyes",
  "The Tangerine",
  "Planet Scape",
  "How 'bout them zombies ey",
  "Snake Eater",
  "204863",
  "You Spin Me Round",
  "Quiet Life",
  "She Blinded Me With Science",
  "Dormant Stream",
  "Too Shy",
  "Peace Walker",--not in QUIET_RADIO_TELOP_LANG_LIST
}--quietRadioNames

this.playRadio={
  save=IvarProc.CATEGORY_EXTERNAL,
  --range={min=0,max=31},
  --range = 0=OFF,#list
  settings=quietRadioNames,
  OnChange=function(self,setting,previousSetting)
    --if setting>0 or previousSetting~=0 then
    if f30050_sequence and mvars.f30050_quietRadioName then
      f30050_sequence.PlayMusicFromQuietRoom()
    end
    --end
  end,
}--quietRadioMode



--DEBUGNOW hijack to experiment
--vox_ ?
--bgm_ ?
quietRadioNames={
  "sfx_m_mtbs_nature",
  "sfx_f_supply_flare",
  "bgm_mission_start",
  "tp_m_10100_01",
  "bgm_mission_clear_heli",
  "tp_bgm_10_01",
  "sfx_m_tp_10_01",
  "sfx_m_10_01",
  "sfx_tp_10_01",
  "Play_bgm_Freeplay",
  "sfx_m_afc0_fall_s",--
  "Play_bgm_mission_chase_phase",
}--quietRadioNames
this.playRadio.settings=quietRadioNames
this.playRadio.OnChange=nil
this.playRadio.OnActivate=function(self,setting,previousSetting)
  --local radioName=string.format("sfx_m_prison_radio_%02d",radioIndex)
  local radioName=self.settings[setting+1]
  local soundPos=Vector3(vars.playerPosX,vars.playerPosY,vars.playerPosZ)
  --    TppMusicManager.PlayPositionalMusic(radioName,soundPos)
  --TppSoundDaemon.PostEvent(radioName)
  TppSoundDaemon.PostEvent3D(radioName,soundPos)
end

--DEBUGNOW REF
function this.PlayMusicFromQuietRoom()
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
  InfCore.Log("PlayQuietRadio:"..tostring(mvars.f30050_quietRadioName) )
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

this.registerMenus={
  "soundPlayMenu",
}

this.registerIvars={
  "debug_PostJingleEvent",
  "playRadio",

}

this.soundPlayMenu={
  noDoc=true,
  nonConfig=true,
  parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.debug_PostJingleEvent",
    "Ivars.playRadio",
  },
}--soundPlayMenu

return this
