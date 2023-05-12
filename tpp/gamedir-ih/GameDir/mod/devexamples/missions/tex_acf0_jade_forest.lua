--tex_acf0_jade_forest.lua
--mission addon missionInfo reference of all parameters rather than a sane example
--see InfMission for implementation of system and other notes
--most of the ALL_CAPS, or other code looking reference in the comment after an entry below is a reference to the base game data structure the option is adding to.
--you can look up those references in the base game lua (Infinite Heaven github repo has all of them with further notes) to get more idea what they do 
local this={
  --unique identifier for the mission, can be anything, just make it unique enough to not conflict with any other community missions
  --none of the different parts have any meaning to the system, it just uses the whole string as an identifier
  --community missions made before now (r262) will not have this, they will fall back to using the file name as missionName
  missionName="tex_acf0_jade_forest",
  description="Jade Forest",-- Description for IH menu.

  --currently should be unique across all community missions, in the future this may be ignored if I can build a system that uses the missionName instead
  --see (and add to) https://mgsvmoddingwiki.github.io/Custom_Missions_List/ to avoid conflicts
  missionCode=12020,
  --locationName of location this mission uses, see TppDefine.LOCATION_ID for base game locationNames
  location="AFC0",

  --doesn't add mission to idroid/internal mission list (so no mission completion/ranking saved). 
  --Still loadable via Load addon mission, or TppMission.ReserveMissionClear, or Transistion system
  hideMission=false,
  
  --TppMissionList.missionPackTable entry, can be table of fpk names or function of packlist adding calls. RENAMED was: packs
  missionPacks=function(missionCode) 
    TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_WAIT)
    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/story/s13000/s13000_area.fpk"
  end,

  fovaSetupFunc=function(locationName,missionId)-- TppEneFova.fovaSetupFuncs entry
    local faces={}
    table.insert(faces,{TppEnemyFaceId.dds_balaclava2,10,10,0})
    table.insert(faces,{TppEnemyFaceId.dds_balaclava6,2,2,0})
    table.insert(faces,{TppEnemyFaceId.dds_balaclava7,2,2,0})

    TppSoldierFace.OverwriteMissionFovaData{face=faces}
  end,
  
  enableOOB=true,-- Enable the mission out of bound system
  startPos={-11.788,8.483,165.559},--TppDefine.NO_HELICOPTER_MISSION_START_POSITION entry -  player spawn pos for non heli ride mission starts
  missionGuaranteeGMP=120000, --TppResult.MISSION_GUARANTEE_GMP - base gmp for mission on mission clear
  noAddVolunteers=false,--dont add any volunteer staff on mission complete
  missionTaskList={0,2,3,4,5,6},--see TppResult.MISSION_TASK_LIST - <missioncode>_sequence.missionObjectiveDefine taskNo to idroid mission task UI index, also used to numerate the valid tasks
  noArmorForMission=true,--TppEneFova.noArmorForMission - disallow heavy armor in the mission
  missionArmorType={TppDefine.AFR_ARMOR.TYPE_RC},--TppEneFova.missionArmorType - Armor type for pfs in mafr
  missionHostageInfos={count=1,lang=RENlang2,overlap=true},--TppEneFova.missionHostageInfos - for the mission hostage generation system,
  
  --tex mission start options, you can start off developing a mission addon with just providing a startPos (see above)>
  --but if you want to support some of the different mission start features the base game missions have these are the options
  --terms-wise the game kind of assumes that most missions will be started by chosing a heli route from idroid
  --you can see some setup there in missionMapParams heliLandPoint
  --otherwise its considered a NO_HELICOPTER_MISSION_START, mission addons use this mode by default if you only provide the startPos and no other options below
  clearExistingMissionStartSettings=true,--only for use when overriding a vanilla mission, clears all the mission start data so the following options you set can work cleanly 
  clearMissionStartHeliRoute=true,--this will clear any heli route chosen for mission start, to clear way for startPos to work --TppDefine.NO_HELICOPTER_ROUTE_MISSION_LIST
  --An orderBox is the mission orders box that appears when chosing a mission from the idroid,
  --while in the free roam of the same location
  --for a mission without order box (without this and without orderBoxList it will be considered a NO_HELICOPTER_MISSION)>
  --in the base game all isNoHeliStartMission
  --(or more acuratly all missions that have entries in NO_HELICOPTER_ROUTE_MISSION_LIST also have entries in NO_ORDER_BOX_MISSION_LIST)
  isNoOrderBoxMission=true,--mission will use startPos as start position --TppDefine.NO_ORDER_BOX_MISSION_LIST,NO_ORDER_BOX_MISSION_ENUM
  heliRouteForNoBoxMission="rt_drp_mbqf_N",--tex will use heli with this route instead of starting on ground at startPos --TppDefine.NO_ORDER_FIX_HELICOPTER_ROUTE
  orderBoxList = { -- <mission>_sequence.missionStartPosition.orderBoxList -- TODO description
    "box_s13000_00",
    "box_s13000_01",
  },

  --<free roam mission>_orderBoxList.lua TODO description
  orderBoxBlockList = { "/Assets/tpp/pack/mission2/story/s13000/s13000_order_box.fpk" },
 
  missionMapParams={--mbdvc_map_mission_parameter.missionParameters
    missionArea2 = {
      { name="trig_innerZone", vertices={ Vector3(-1130.04,180.00,859.60),Vector3(-748.37,180.00,1241.27),Vector3(-475.96,180.00,968.86),Vector3(-225.87,180.00,1218.95),Vector3(152.35,180.00,840.77),Vector3(152.35,180.00,-89.97),Vector3(-479.32,180.00,-89.97),Vector3(-857.62,180.00,288.33),Vector3(-857.62,180.00,587.19), },  },
    },
    safetyArea2 = {
      { name="trig_hotZone", vertices={ Vector3(-652.23,180.00,1012.55),Vector3(-536.76,180.00,897.08),Vector3(-463.86,180.00,969.99),Vector3(-193.42,180.00,699.55),Vector3(-193.40,180.00,39.43),Vector3(-539.49,180.00,39.43),Vector3(-845.91,180.00,345.86),Vector3(-845.91,180.00,587.93),Vector3(-961.38,180.00,703.40), },  },
    },
    -- Order box points when mission is highlighted in free mode
    missionStartPoint = {Vector3(-218.07,328.03,395.86),Vector3(-381.54,294.27,910.16),},
    --GOTCHA: heli routeIds need to be unique across all locations
    heliLandPoint = {
      {point=Vector3(-351.61,321.89,768.34),startPoint=Vector3(-91.82,331.89,918.56),routeId="lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000"},
      {point=Vector3(-289.80,346.69,269.68),startPoint=Vector3(161.28,335.69,140.48),routeId="lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000"},
      {point=Vector3(-596.89,353.02,497.40),startPoint=Vector3(-946.28,309.02,981.35),routeId="lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000"},
    },
  },--missionMapParams

  weaponIdTable={-- alternatively a string of the TppEnemy.weaponIdTable ex weaponIdTable="SOVIET_A",   IMPLEMENTATION: GetWeaponIdTable, see also InfWeaponIdTable for IH global weaponIdTable override
    PF_A={
      NORMAL={
        HANDGUN=TppEquip.EQP_WP_East_hg_010,
        SMG=TppEquip.EQP_WP_East_sm_010,
        ASSAULT=TppEquip.EQP_WP_East_ar_010,
        SNIPER=TppEquip.EQP_WP_East_sr_011,
        SHOTGUN=TppEquip.EQP_WP_Com_sg_011,
        MG=TppEquip.EQP_WP_East_mg_010,
        MISSILE=TppEquip.EQP_WP_East_ms_010,
        SHIELD=TppEquip.EQP_SLD_SV
      },
    },
  },--weaponIdTable

  heliSpaceFlags={-- Sortie/mission prep screen feature flags
    SkipMissionPreparetion=false,                        -- No sortie prep, like vanilla Mother Base.
    NoBuddyMenuFromMissionPreparetion=true,              -- No buddy select in the sortie
    NoVehicleMenuFromMissionPreparetion=true,            -- No vehicle select in the sortie
    DisableSelectSortieTimeFromMissionPreparetion=true,  -- Only ASAP as deployment time option
  },

  defaultDropRoute="lz_drp_bridge_S0000|rt_drp_bridge_S_0000",--tex story missions only (not free roam), --TppDefine.DEFAULT_DROP_ROUTE not exactly sure how/what its used for (disapears into exe via TppUiCommand.RegisterDefaultLandPoint)
  --tex DEBUGNOW debating whether to have this here or in locationInfo to save duplication,
  --TppLandingZoneData is defined in mission pack fox2 so author would be duplicating anyhoo
  --but using this to build TppLandingZone MissionLandingZoneTable which is pretty much all the lzs dumped in for managing disabling the lzs in idroid
  --tex see also comment above InfLZ.lzInfo for the breakdown of what the data is from
  lzInfo={
    ["lz_bridge_S0000|lz_bridge_S_0000"]={
      approachRoute="lz_bridge_S0000|rt_apr_bridge_S_0000",
      dropRoute="lz_drp_bridge_S0000|rt_drp_bridge_S_0000",
      returnRoute="lz_bridge_S0000|rt_rtn_bridge_S_0000",
    },
    ["lz_citadelSouth_S0000|lz_citadelSouth_S_0000"]={
      approachRoute="lz_citadelSouth_S0000|rt_apr_citadelSouth_S_0000",
      dropRoute="lz_drp_citadelSouth_S0000|rt_drp_citadelSouth_S_0000",
      returnRoute="lz_citadelSouth_S0000|rt_rtn_citadelSouth_S_0000",
    },
  },--lzInfo
  enableQuests={"lab_q39011","lab_q80700","lab_q10700"},--Enables quests in story missions. if Ivar enableMissionQuest. handled by rlcs InfMissionQuest
  
  heliSpace=40020,--heliSpace for the mission, will load when landing spot is selected to go to mission prep (if ivar heliSpace_loadOnSelectLandPoint is on), and on returning from mission
  
  --Only for HeliSpace addons>
  
  --camera settings for mission prep and weapon customization
  --can be table that will override just the default parameters (see InfHeliSpace SelectCameraParameter) (more specifically its merged, so if theres a default parameter you want to clear set it to nil)
  --or function(focusTarget,immediately) to run whatever camera stuff you want (see InfHeliSpace.UpdateCameraParameter), function must return true if it handled the given focusType
  SelectCameraParameter={
    MissionPrep_FocusTarget_SecondaryWeapon={linkKey="PlayerPosition",aroundCam={distance=3.0},rotation={rotX=-5,rotY=160,interpTime=0.3}},
  },
  --Only for HeliSpace addons<
}--this

return this