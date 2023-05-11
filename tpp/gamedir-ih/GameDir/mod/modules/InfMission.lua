--InfMission.lua
-- tex implements various mission selection options
-- and IH location and mission addon systems

--TODO: call validateweaponIdtable on load

--REF location addon module <GameDir>\mod\locations\ >
--reference of all entries rather than a sane example
--local this={
--  description="Jade Forest",
--  locationName="AFC0",
--  locationId=101,
--  packs={"/Assets/mgo/pack/location/afc0/afc0.fpk"},-- TppMissionList.locationPackTable entry RENAMED was: packs
--  locationMapParams={-- \Assets\tpp\pack\mbdvc\mb_dvc_top.fpkd \ mbdvc_map_location_parameter.lua entry
--    stageSize=556*1,
--    scrollMaxLeftUpPosition=Vector3(-255,0,-275),
--    scrollMaxRightDownPosition=Vector3(255,0,275),
--    highZoomScale=2,
--    middleZoomScale=1,
--    lowZoomScale=.5,
--    locationNameLangId="mgo_idt_Jungle",
--    stageRotate=0,
--    heightMapTexturePath="/Assets/mgo/ui/texture/map/afc0/afc0_iDroid_clp.ftex",
--    photoRealMapTexturePath="/Assets/mgo/ui/texture/map/afc0/afc0_jungle_sat_clp.ftex"
--  },
--  globalLocationMapParams={ --  see \Assets\tpp\pack\mbdvc\mb_dvc_top.fpkd \ mbdvc_map_location_parameter.lua GetGlobalLocationParameter
--    sectionFuncRankForDustBox = 4,
--    sectionFuncRankForToilet  = 4,
--    sectionFuncRankForCrack   = 6,
--    isSpySearchEnable = true,
--    isHerbSearchEnable = true,--tex IH will automatically patch in support for disableHerbSearch
--
--    spySearchRadiusMeter = {  40.0, 40.0, 35.0, 30.0, 25.0, 20.0, 15.0, 10.0, },
--    spySearchIntervalSec = {  420.0,  420.0,  360.0,  300.0,  240.0,  180.0,  120.0,  60.0, },
--    herbSearchRadiusMeter = { 0.0,  0.0,  10.0, 15.0, 20.0, 25.0, 30.0, 35.0, },
--  },
--  questAreas={--tex defines quest areas for location, see TppQuestList.questList .
--    {
--      areaName="tent",
--      --xMin,yMin,xMax,yMax, in smallblock coords. see Tpp.CheckBlockArea. debug menu ShowPosition will log GetCurrentStageSmallBlockIndex, or you can use whatever block visualisation in unity you have
--      loadArea={116,134,131,152},--load is the larger area, so -1 minx, -1miny, +1maxx,+1maxy vs active
--      activeArea={117,135,130,151},
--      invokeArea={117,135,130,151},--same size as active, but keeping here to stay same implementation as vanilla
--    },
--  },
--  requestTppBuddy2BlockController=true,--tex not sure, see TppLocation.SetBuddyBlock and its caller TppMissionList.GetLocationPackagePath
--  weatherProbabilities={-- see TppWeather.weatherProbabilitiesTable
--    {TppDefine.WEATHER.SUNNY,80},
--    {TppDefine.WEATHER.CLOUDY,20}
--  },
--  extraWeatherProbabilities={-- see TppWeather.extraWeatherProbabilitiesTable
--    {TppDefine.WEATHER.RAINY,50},
--    {TppDefine.WEATHER.FOGGY,50}
--  },
--  SelectCameraParameter={}--see missionInfo SelectCameraParameter (which will override this for given focusType)
--}--this
--
--return this
--<

--REF mission addon module aka missionInfo, <GameDir>\mod\missions\ >
--reference of all entries rather than a sane example
--most of the ALL_CAPS, or other code looking reference in the comment after an entry below is a reference to the base game data structure the option is adding to.
--local this={
--  description="Jade Forest",-- Description for IH menu.
--  missionCode=12020,
--  location="AFC0",
--  hideMission=false,--doesn't add mission to idroid/internal mission list (so no mission completion/ranking saved). Still loadable via Load addon mission, or TppMission.ReserveMissionClear, or Transistion system
--  missionPacks=function(missionCode) -- TppMissionList.missionPackTable entry, can be table of fpk names or function of packlist adding calls. RENAMED was: packs
--    TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_WAIT)
--    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/story/s13000/s13000_area.fpk"
--  end,
--  fovaSetupFunc=function(locationName,missionId)-- TppEneFova.fovaSetupFuncs entry
--    local faces={}
--    table.insert(faces,{TppEnemyFaceId.dds_balaclava2,10,10,0})
--    table.insert(faces,{TppEnemyFaceId.dds_balaclava6,2,2,0})
--    table.insert(faces,{TppEnemyFaceId.dds_balaclava7,2,2,0})
--
--    TppSoldierFace.OverwriteMissionFovaData{face=faces}}
--  end,
--  enableOOB=true,-- Enable the mission out of bound system
--  startPos={-11.788,8.483,165.559},--TppDefine.NO_HELICOPTER_MISSION_START_POSITION entry -  player spawn pos for non heli ride mission starts
--  missionGuaranteeGMP=120000, --TppResult.MISSION_GUARANTEE_GMP - base gmp for mission on mission clear
--  noAddVolunteers=false,--dont add any volunteer staff on mission complete
--  missionTaskList={0,2,3,4,5,6},--see TppResult.MISSION_TASK_LIST - <missioncode>_sequence.missionObjectiveDefine taskNo to idroid mission task UI index, also used to numerate the valid tasks
--  noArmorForMission=true,--TppEneFova.noArmorForMission - disallow heavy armor in the mission
--  missionArmorType={TppDefine.AFR_ARMOR.TYPE_RC},--TppEneFova.missionArmorType - Armor type for pfs in mafr
--  missionHostageInfos={count=1,lang=RENlang2,overlap=true},--TppEneFova.missionHostageInfos - for the mission hostage generation system
--  --tex mission start options, you can start off developing a mission addon with just providing a startPos (see above)>
--  --but if you want to support some of the different mission start features the base game missions have these are the options
--  --terms-wise the game kind of assumes that most missions will be started by chosing a heli route from idroid
--  --you can see some setup there in missionMapParams heliLandPoint
--  --otherwise its considered a NO_HELICOPTER_MISSION_START, mission addons use this mode by default if you only provide the startPos and no other options below
--  clearExistingMissionStartSettings=true,--only for use when overriding a vanilla mission, clears all the mission start data so the following options you set can work cleanly 
--  clearMissionStartHeliRoute=true,--this will clear any heli route chosen for mission start, to clear way for startPos to work --TppDefine.NO_HELICOPTER_ROUTE_MISSION_LIST
--  --An orderBox is the mission orders box that appears when chosing a mission from the idroid,
--  --while in the free roam of the same location
--  --for a mission without order box (without this and without orderBoxList it will be considered a NO_HELICOPTER_MISSION)>
--  --in the base game all isNoHeliStartMission
--  --(or more acuratly all missions that have entries in NO_HELICOPTER_ROUTE_MISSION_LIST also have entries in NO_ORDER_BOX_MISSION_LIST)
--  isNoOrderBoxMission=true,--mission will use startPos as start position --TppDefine.NO_ORDER_BOX_MISSION_LIST,NO_ORDER_BOX_MISSION_ENUM
--  heliRouteForNoBoxMission="rt_drp_mbqf_N",--tex will use heli with this route instead of starting on ground at startPos --TppDefine.NO_ORDER_FIX_HELICOPTER_ROUTE
--  orderBoxList = { -- <mission>_sequence.missionStartPosition.orderBoxList -- TODO description
--    "box_s13000_00",
--    "box_s13000_01",
--  },
--  orderBoxBlockList = { "/Assets/tpp/pack/mission2/story/s13000/s13000_order_box.fpk" } --<free roam mission>_orderBoxList.lua TODO description
--  --<
--  missionMapParams={--mbdvc_map_mission_parameter.missionParameters
--    missionArea2 = {
--      { name="trig_innerZone", vertices={ Vector3(-1130.04,180.00,859.60),Vector3(-748.37,180.00,1241.27),Vector3(-475.96,180.00,968.86),Vector3(-225.87,180.00,1218.95),Vector3(152.35,180.00,840.77),Vector3(152.35,180.00,-89.97),Vector3(-479.32,180.00,-89.97),Vector3(-857.62,180.00,288.33),Vector3(-857.62,180.00,587.19), },  },
--    },
--    safetyArea2 = {
--      { name="trig_hotZone", vertices={ Vector3(-652.23,180.00,1012.55),Vector3(-536.76,180.00,897.08),Vector3(-463.86,180.00,969.99),Vector3(-193.42,180.00,699.55),Vector3(-193.40,180.00,39.43),Vector3(-539.49,180.00,39.43),Vector3(-845.91,180.00,345.86),Vector3(-845.91,180.00,587.93),Vector3(-961.38,180.00,703.40), },  },
--    },
--    -- Order box points when mission is highlighted in free mode
--    missionStartPoint = {Vector3(-218.07,328.03,395.86),Vector3(-381.54,294.27,910.16),},
--    --GOTCHA: heli routeIds need to be unique across all locations
--    heliLandPoint = {
--      {point=Vector3(-351.61,321.89,768.34),startPoint=Vector3(-91.82,331.89,918.56),routeId="lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000"},
--      {point=Vector3(-289.80,346.69,269.68),startPoint=Vector3(161.28,335.69,140.48),routeId="lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000"},
--      {point=Vector3(-596.89,353.02,497.40),startPoint=Vector3(-946.28,309.02,981.35),routeId="lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000"},
--    },
--  },
--  weaponIdTable={-- alternatively a string of the TppEnemy.weaponIdTable ex weaponIdTable="SOVIET_A",   IMPLEMENTATION: GetWeaponIdTable, see also InfWeaponIdTable for IH global weaponIdTable override
--    PF_A={
--      NORMAL={
--        HANDGUN=TppEquip.EQP_WP_East_hg_010,
--        SMG=TppEquip.EQP_WP_East_sm_010,
--        ASSAULT=TppEquip.EQP_WP_East_ar_010,
--        SNIPER=TppEquip.EQP_WP_East_sr_011,
--        SHOTGUN=TppEquip.EQP_WP_Com_sg_011,
--        MG=TppEquip.EQP_WP_East_mg_010,
--        MISSILE=TppEquip.EQP_WP_East_ms_010,
--        SHIELD=TppEquip.EQP_SLD_SV
--      },
--    },
--  },
--  heliSpaceFlags={-- Sortie/mission prep screen feature flags
--    SkipMissionPreparetion=false,                        -- No sortie prep, like vanilla Mother Base.
--    NoBuddyMenuFromMissionPreparetion=true,              -- No buddy select in the sortie
--    NoVehicleMenuFromMissionPreparetion=true,            -- No vehicle select in the sortie
--    DisableSelectSortieTimeFromMissionPreparetion=true,  -- Only ASAP as deployment time option
--  },
--  defaultDropRoute="lz_drp_bridge_S0000|rt_drp_bridge_S_0000",--tex story missions only (not free roam), --TppDefine.DEFAULT_DROP_ROUTE not exactly sure how/what its used for (disapears into exe via TppUiCommand.RegisterDefaultLandPoint)
--  --tex DEBUGNOW debating whether to have this here or in locationInfo to save duplication,
--  --TppLandingZoneData is defined in mission pack fox2 so author would be duplicating anyhoo
--  --but using this to build TppLandingZone MissionLandingZoneTable which is pretty much all the lzs dumped in for managing disabling the lzs in idroid
--  --tex see also comment above InfLZ.lzInfo for the breakdown of what the data is from
--  lzInfo={
--    ["lz_bridge_S0000|lz_bridge_S_0000"]={
--      approachRoute="lz_bridge_S0000|rt_apr_bridge_S_0000",
--      dropRoute="lz_drp_bridge_S0000|rt_drp_bridge_S_0000",
--      returnRoute="lz_bridge_S0000|rt_rtn_bridge_S_0000",
--    },
--    ["lz_citadelSouth_S0000|lz_citadelSouth_S_0000"]={
--      approachRoute="lz_citadelSouth_S0000|rt_apr_citadelSouth_S_0000",
--      dropRoute="lz_drp_citadelSouth_S0000|rt_drp_citadelSouth_S_0000",
--      returnRoute="lz_citadelSouth_S0000|rt_rtn_citadelSouth_S_0000",
--    },
--  },--lzInfo
--  enableQuests={"lab_q39011","lab_q80700","lab_q10700"},--Enables quests in story missions. if Ivar enableMissionQuest. handled by rlcs InfMissionQuest
--  --Only for Helispace addons. camera settings for mission prep and weapon customization
--  --can be table that will override just the default parameters (see InfHeliSpace SelectCameraParameter) (more specifically its merged, so if theres a default parameter you want to clear set it to nil)
--  --or function(focusTarget,immediately) to run whatever camera stuff you want (see InfHeliSpace.UpdateCameraParameter), function must return true if it handled the given focusType
--  SelectCameraParameter={ 
--    MissionPrep_FocusTarget_SecondaryWeapon={linkKey="PlayerPosition",aroundCam={distance=3.0},rotation={rotX=-5,rotY=160,interpTime=0.3}},
--  },
--}--this
--
--return this
--<
--tex for Validate
local missionInfoFormat={
  description="string",
  missionCode="number",
  location="string",
  hideMission="boolean",
  --packs={"table","function"},--tex OFF till I make validate support multiple data types for a key
  fovaSetupFunc="function",
  enableOOB="boolean",
  startPos="table",
  missionGuaranteeGMP="number",
  noAddVolunteers="boolean",
  missionTaskList="table",
  noArmorForMission="boolean",
  missionArmorType="table",
  missionHostageInfos="table",
  clearExistingMissionStartSettings="boolean",
  clearMissionStartHeliRoute="boolean",
  isNoOrderBoxMission="boolean",
  heliRouteForNoBoxMission="string",
  orderBoxList="table",
  orderBoxBlockList="table",
  missionMapParams="table",
  --weaponIdTable={"string","table"}
  heliSpaceFlags="table",
  defaultDropRoute="string",
  lzInfo="table",
}

local heliSpaceFlagNames={
  "SkipMissionPreparetion",
  "NoBuddyMenuFromMissionPreparetion",
  "NoVehicleMenuFromMissionPreparetion",
  "DisableSelectSortieTimeFromMissionPreparetion",
}

local this={}

this.debugModule=true--DEBUGNOW

this.locationInfo={}--locationInfo[locationId]=locationInfo
this.missionInfo={}--missionInfo[missionCode]=missionInfo
this.missionNames={--[["<missionName>"=missionInfo]]}--tex see LoadMissionDefs missionInfo is indexed by missionCode
this.missionIds={}--tex used by Ivar loadAddonMission and SetupAddonStateGVars(), story missions only not free roam missions
this.missionListSlotIndices={}--tex MISSION_LIST indexes that can be reusued for addon missions
this.freeMissionIds={}--tex free roam missions

--tex various lookups, naturally wont have addon location/missions in them until they are added in LoadLibraries
this.locationNameToLocationCode=TppDefine.LOCATION_ID--tex I keep getting confused about all the different lookups scattered across the code
this.locationCodeForName=TppLocation.locationIdForName
this.locationForMission={--ref LOCATION_HAVE_MISSION_LIST
  [5]=TppDefine.SYS_MISSION_ID.INIT,
--AFGH
  [10020]=10,[10033]=10,[10034]=10,[10036]=10,[10040]=10,[10041]=10,[10043]=10,[10044]=10,[10045]=10,[10050]=10,[10052]=10,[10054]=10,[10060]=10,[10070]=10,[10150]=10,[10151]=10,[10153]=10,[10156]=10,[10164]=10,[10199]=10,[10260]=10,[30010]=10,[40010]=10,[65020]=10,[11036]=10,[11043]=10,[11041]=10,[11033]=10,[11050]=10,[11054]=10,[11044]=10,[11052]=10,[11151]=10,
  --MAFR
  [10080]=20,[10081]=20,[10082]=20,[10085]=20,[10086]=20,[10090]=20,[10091]=20,[10093]=20,[10100]=20,[10110]=20,[10120]=20,[10121]=20,[10130]=20,[10140]=20,[10154]=20,[10160]=20,[10162]=20,[10171]=20,[10200]=20,[10195]=20,[10211]=20,[30020]=20,[40020]=20,[65060]=20,[11085]=20,[11082]=20,[11090]=20,[11091]=20,[11195]=20,[11211]=20,[11140]=20,[11200]=20,[11080]=20,[11171]=20,[11121]=20,[11130]=20,
  --CYPR
  [10010]=30,[10280]=30,
  --MTBS
  [10030]=50,[10115]=50,[11115]=50,[10240]=50,[30050]=50,[30150]=50,[30250]=50,[40050]=50,[50050]=50,[65030]=50,
  --HLSP
  [40060]=60,
  --FLYK
  [10230]=70,
}--locationForMission

--tex addon mission added in LoadLibraries,
this.freeMissionForLocation={
  [TppDefine.LOCATION_ID.AFGH]=30010,
  [TppDefine.LOCATION_ID.MAFR]=30020,
--DEBUGNOW the mission<>freemisson functions where it was originally used for don't have MTBS
--OFF [TppDefine.LOCATION_ID.MTBS]=30050,
}
this.helispaceForLocation={
  [TppDefine.LOCATION_ID.AFGH]=40010,
  [TppDefine.LOCATION_ID.MAFR]=40020,
  [TppDefine.LOCATION_ID.MTBS]=40050,
  [TppDefine.LOCATION_ID.MBQF]=40050,
}
--tex addons only, for vanilla just fall back to heliSpaceForLocation (though that can also have addon)
this.helispaceForMission={}

this.registerIvars={
  "manualMissionCode",
  "manualSequence",
  "loadAddonMission",
  "ihMissionsPercentageCount",
}

this.manualMissionCode={
  inMission=true,
  --OFF save=IvarProc.CATEGORY_EXTERNAL,
  settings={},--DYNAMIC
  OnSelect=function(self)
    self.settingNames=self.settings--DEBUGNOW settingnames?
    IvarProc.SetSettings(self,this.GetMissionCodes())
  end,
  OnActivate=function(self,setting)
    local settingStr=self.settings[setting+1]
    local missionCode=tonumber(settingStr)
    InfCore.Log("manualMissionCode "..settingStr)

    this.LoadMissionManual(missionCode)
  end,
}

this.manualSequence={
  inMission=true,
  --OFF save=IvarProc.CATEGORY_EXTERNAL,
  settings={"NONE"},--DYNAMIC
  settingNamesDoc=[[<seq_sequenceNames>]],
  OnSelect=function(self)
    IvarProc.SetSettings(self,mvars.seq_sequenceNames)--tex GOTCHA, combines string array and Tpp.Enum
  end,
  OnActivate=function(self,setting)
    local settingStr=self.settings[setting+1]
    TppSequence.SetNextSequence(settingStr)
  end,
}

this.loadAddonMission={
  --OFF save=IvarProc.CATEGORY_EXTERNAL,
  settings={"NONE"},--DYNAMIC
  settingNamesDoc="<Addon mission names>",
  OnSelect=function(self)
    InfUtil.ClearArray(self.settings)
    for missionCode,missionInfo in pairs(this.missionInfo)do
      table.insert(self.settings,tostring(missionCode))
    end
    table.sort(self.settings)
    IvarProc.SetSettings(self,self.settings)
  end,
  GetSettingText=function(self,setting)
    if #self.settings==0 then
      return "No addon missions installed"--TODO langid
    end

    local missionCodeStr=self.settings[setting+1]
    local missionCode=tonumber(missionCodeStr)
    local missionInfo=InfMission.missionInfo[missionCode]
    if missionInfo then
      local location=missionInfo.location
      return "["..missionCodeStr.."]["..location.."] "..(missionInfo.description or "")
    else
      return "No missionInfo for "..missionCodeStr --TODO langid
    end
  end,
  OnActivate=function(self,setting)
    if #self.settings==0 then
      return
    end

    local settingStr=self.settings[setting+1]
    local missionCode=tonumber(settingStr)
    InfCore.Log("manualMissionCode "..settingStr)

    this.LoadMissionManual(missionCode)
  end,
}

this.ihMissionsPercentageCount={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  OnChange=function()
    TppMission.SetPlayRecordClearInfo()
  end,
}
--< Ivars

function this.PostModuleReload(prevModule)
  this.locationInfo=prevModule.locationInfo
  this.missionNames=prevModule.missionNames
  this.missionIds=prevModule.missionIds
  this.missionInfo=prevModule.missionInfo
  this.missionListSlotIndices=prevModule.missionListSlotIndices
  this.freeMissionIds=prevModule.freeMissionIds
  this.freeMissionForLocation=prevModule.freeMissionForLocation
end


--WIP
this.femaleFaceIdList={394,351,373,456,463,455,511,502}
this.maleFaceIdList={195,144,214,6,217,83,273,60,87,71,256,201,290,178,102,255,293,165,85,18,228,12,65,134,31,132,161,342,107,274,184,226,153,247,344,242,56,183,54,126,223}

local MAX_REALIZED_COUNT=255--EnemyFova.MAX_REALIZED_COUNT
local fovaSetupFuncs={}
function fovaSetupFuncs.basic(locationName,missionId)
  local faces={}
  local faceCounts={}

  for i,faceId in ipairs(this.maleFaceIdList)do
    if faceCounts[faceId]==nil then
      faceCounts[faceId]=2
    else
      faceCounts[faceId]=faceCounts[faceId]+1
    end
  end
  for i,faceId in ipairs(this.femaleFaceIdList)do
    if faceCounts[faceId]==nil then
      faceCounts[faceId]=2
    else
      faceCounts[faceId]=faceCounts[faceId]+1
    end
  end


  for faceId,faceCount in pairs(faceCounts)do
    table.insert(faces,{faceId,faceCount,faceCount,0})
  end
  table.insert(faces,{623,1,1,0})
  table.insert(faces,{TppEnemyFaceId.dds_balaclava2,10,10,0})
  table.insert(faces,{TppEnemyFaceId.dds_balaclava6,2,2,0})
  table.insert(faces,{TppEnemyFaceId.dds_balaclava7,2,2,0})

  local bodies={
    {146,MAX_REALIZED_COUNT},
  }
  --TppSoldier2.SetExtendPartsInfo{type=1,path="/Assets/tpp/parts/chara/dds/ddr1_main0_def_v00.parts"}
  TppSoldierFace.OverwriteMissionFovaData{face=faces}--,body=bodies}
end

--this.locationInfo[45].locationMapParams=this.locationMapParams.MBA0--

--REF tpp
--REF from TppDefine RegisterMissionCodeList
--this.missionUiNumbers={
--  [10010]=0,
--  [10020]=1,
--  [10030]=2,
--  [10036]=3,
--  [10043]=4,
--  [10033]=5,
--  [10040]=6,
--  [10041]=7,
--  [10044]=8,
--  [10054]=9,
--  [10052]=10,
--  [10050]=11,
--  [10070]=12,
--  [10080]=13,
--  [10086]=14,
--  [10082]=15,
--  [10090]=16,
--  [10091]=17,
--  [10100]=18,
--  [10195]=19,
--  [10110]=20,
--  [10121]=21,
--  [10115]=22,
--  [10120]=23,
--  [10085]=24,
--  [10200]=25,
--  [10211]=26,
--  [10081]=27,
--  [10130]=28,
--  [10140]=29,
--  [10150]=30,
--  [10151]=31,
--  [10045]=32,
--  [11043]=33,
--  [11054]=34,
--  [10093]=35,
--  [11082]=36,
--  [11090]=37,
--  [10156]=38,
--  [11033]=39,
--  [11050]=40,
--  [10171]=41,
--  [11140]=42,
--  [10240]=43,
--  [11080]=44,
--  [10260]=45,
--  [10280]=46,
--  [11121]=47,
--  [11130]=48,
--  [11044]=49,
--  [11151]=50,
--}
--#51

this.highestUIMission=50--tex vanilla, indexed from 0

this.vanillaMissions={
  [1]=true,
  [5]=true,
  [10010]=true,--1
  [10020]=true,--2
  [10030]=true,--3
  [10036]=true,--4
  [10043]=true,--5
  [10033]=true,--6
  [10040]=true,--7
  [10041]=true,--8
  [10044]=true,--9
  [10052]=true,--10
  [10054]=true,--11
  [10050]=true,--12
  [10070]=true,--13
  [10080]=true,--14
  [10086]=true,--15
  [10082]=true,--16
  [10090]=true,--17
  [10195]=true,--18
  [10091]=true,--19
  [10100]=true,--20
  [10110]=true,--21
  [10121]=true,--22
  [10115]=true,--23
  [10120]=true,--24
  [10085]=true,--25
  [10200]=true,--26
  [10211]=true,--27
  [10081]=true,--28
  [10130]=true,--29
  [10140]=true,--30
  [10150]=true,--31
  [10151]=true,--32
  [10045]=true,--33
  [10156]=true,--34
  [10093]=true,--35
  [10171]=true,--36
  [10240]=true,--37
  [10260]=true,--38
  [10280]=true,--39
  --[10230]=true,--40-no number mission40
  [11043]=true,--41
  --[11041]=true,--42-no number mission
  [11054]=true,--43
  --[11085]=true,--44-no number mission
  [11082]=true,--45
  [11090]=true,--46
  --[11036]=true,--47-no number mission
  [11033]=true,--48
  [11050]=true,--49
  --[11091]=true,--50-no number mission
  --[11195]=true,--51-no number mission
  --[11211]=true,--52-no number mission
  [11140]=true,--53
  --[11200]=true,--54-no number mission
  [11080]=true,--55
  --[11171]=true,--56-no number mission
  [11121]=true,--57
  --[11115]=true,--58-no number mission
  [11130]=true,--59
  [11044]=true,--60
  --[11052]=true,--61-no number mission
  [11151]=true,--62
  --
  [30010]=true,
  [30020]=true,
  [30050]=true,
  [30051]=true,
  [30150]=true,
  [30250]=true,
  [40010]=true,
  [40020]=true,
  [40050]=true,
  [50050]=true,
}--vanillaMissions

function this.IsVanillaMission(missionCode)
  return this.vanillaMissions[missionCode]
end--IsVanillaMission

--tex Load Location addons
--OUT/SIDE: this.locationInfo
function this.LoadLocationDefs()
  local missionFiles=InfCore.GetFileList(InfCore.files.locations,".lua")
  for i,fileName in ipairs(missionFiles)do
    InfCore.Log("InfMission.LoadLocationsDefs: "..fileName)

    local locationInfo=InfCore.LoadSimpleModule(InfCore.paths.locations,fileName)
    if locationInfo then
      local locationId=locationInfo.locationId
      if not locationId then
        InfCore.Log("WARNING: could not find missionCode on "..fileName)
      else
        if this.locationInfo[locationId] then
          InfCore.Log("WARNING: Existing locationInfo already found for "..locationId)
        end
        this.locationInfo[locationId]=locationInfo
      end
    end
  end
end

--tex Load Mission addons
--OUT/SIDE: this.missionInfo
function this.LoadMissionDefs()
  InfCore.LogFlow("InfMission.LoadMissionDefs")
  local missionNames={}
  local missionsInfo={}

  local missionFiles=InfCore.GetFileList(InfCore.files.missions,".lua")
  for i,fileName in ipairs(missionFiles)do
    InfCore.Log("InfMission.LoadMissionDefs: "..fileName)

    local missionName=InfUtil.StripExt(fileName) 
    --tex FIXUP WORKAROUND: first char is number (ex Ventos Yellow Asset, anything else following my original naming style), which gives BuildTableText issues
    --could go all fancy and missioncodestring it with story, free, but whatever
    if tonumber(string.sub(missionName, 1, 1))~=nil then
      missionName="m"..missionName
    end   
    local missionInfo=InfCore.LoadSimpleModule(InfCore.paths.missions,fileName)
    if missionInfo then
      missionInfo.missionPacks=missionInfo.missionPacks or missionInfo.packs--tex PATCHUP: RENAMED packs

      local missionCode=missionInfo.missionCode--TYPE
      if not missionCode then
        InfCore.Log("WARNING: could not find missionCode on "..fileName)
      else
        missionInfo.name=missionName
        missionNames[missionName]=missionInfo

        if missionsInfo[missionCode] then
          InfCore.Log("WARNING: Existing missionInfo already found for "..missionCode)
        end
        missionsInfo[missionCode]=missionInfo
      end
    end
  end

  this.missionNames=missionNames
  this.missionInfo=missionsInfo
end

--tex Patch in locations to relevant TPP tables.
--OUT/SIDE: a whole bunch
function this.AddInLocations()
  if next(this.locationInfo)==nil then
    return
  end

  InfCore.Log("InfMission.AddInLocations: Adding locationInfos")
  for locationId,locationInfo in pairs(this.locationInfo)do
    local locationName=locationInfo.locationName
    if not locationName then
      InfCore.Log("WARNING: Could nof find locationName for "..locationId)
    else
      locationInfo.locationPacks=locationInfo.locationPacks or locationInfo.packs--tex PATCHUP: RENAMED packs

      InfCore.Log("Adding location: "..locationName.." "..locationId)
      if TppDefine.LOCATION_ID[locationName] then
        InfCore.Log("WARNING: location already defined "..locationId)
      end
      TppDefine.LOCATION_ID[locationName]=locationId
      TppDefine.LOCATION_ID[string.lower(locationName)]=locationId
      if locationInfo.locationPacks then
        TppMissionList.locationPackTable[locationId]=locationInfo.locationPacks
      end

      --KLUDGE may not be accurate, but just stand-in until InfMain.BuildCpPositions kicks in and gets actually positions from the cp entities
      local locationNameLower=string.lower(locationName)
      local cpPositions=InfMain.cpPositions[locationNameLower] or {}
      InfMain.cpPositions[locationNameLower]=cpPositions
      if locationInfo.locationMapParams and locationInfo.locationMapParams.townParameter then
        for i,townParameter in ipairs(locationInfo.locationMapParams.townParameter)do
          if townParameter.cpName and townParameter.cpName~=""then--tex TODO in vanilla theres some valid townParameters with cpName ""
            if townParameter.position then
              cpPositions[townParameter.cpName]={townParameter.position:GetX(),townParameter.position:GetY(),townParameter.position:GetZ()}
          end
          end
        end--for townParameter
      end--if locationMapParams townParameter

      InfQuest.AddLocationQuestAreas(locationId,locationInfo.questAreas)
      InfWeather.AddWeatherProbabilities(locationName,locationInfo)
    end
  end
  InfCore.LogFlow"Adding to TppLocation.locationIdForName for TppLocation.GetLocationName"
  for locationId,locationInfo in pairs(this.locationInfo)do
    local locationName=locationInfo.locationName
    if locationName then
      TppLocation.locationIdForName[string.lower(locationName)]=locationId
    end
  end
  for locationName,locationId in pairs(TppLocation.locationIdForName)do
    TppLocation.locationNames[locationId]=locationName
  end

  --TppDefine.LOCATION_CHUNK_INDEX_TABLE[location]=Chunkbleh --tex TODO see what requires LOCATION_CHUNK_INDEX_TABLE for addon missions, fallback to some default instead of nil?

  InfUtil.GetLocationName=TppLocation.GetLocationName--tex LEGACY

  if this.debugModule then
    InfCore.PrintInspect(this.locationInfo,"locationInfo")
    --InfCore.PrintInspect(InfMain.cpPositions,"InfMain.cpPositions")
  end
end

--tex Patch in misssions to relevant TPP tables.TppMissionList.missionPackTable
--OUT/SIDE: a whole bunch
function this.AddInMissions()
  if next(this.missionInfo)==nil then
    return
  end

  InfCore.Log("InfMission.AddInMissions: Adding missionInfos")
  local rebuildLzTables=false

  for missionCode,missionInfo in pairs(this.missionInfo)do
    InfCore.Log("Adding mission: "..missionCode)

    if InfCore.Validate(missionInfoFormat,missionInfo,"mission addon for "..missionCode) then
      --tex TODO: expand Validate to validate sub tables

      local missionLocation=TppDefine.LOCATION_ID[missionInfo.location]
      if missionInfo.heliSpaceFlags then
        for flagName,set in pairs(missionInfo.heliSpaceFlags)do
          if type(set)~="boolean" then
            InfCore.Log("InfMission.AddInMissions: WARNING: missionInfo.heliSpaceFlags."..flagName.." should be boolean")
            missionInfo.heliSpaceFlags[flagName]=nil--tex could do fixup, convert 0,1 whatever, either way I like to validate up front rather than slathering code with type guards
          end
        end
      end

      --tex TODO: check it has a valid location
      if missionInfo.missionPacks then
        TppMissionList.missionPackTable[missionCode]=missionInfo.missionPacks
      end

      --tex LOCATION_HAVE_MISSION_LIST is in a pretty bad layout of
      --{<location>={<missioncode>,<missioncode>,...}
      --Given how it's used it should have just been {[missioncode]=<location>,...} or {<location>={[missioncode]=true,...},}
      --Used by TppPackList.GetLocationNameFormMissionCode
      local locationMissions=TppDefine.LOCATION_HAVE_MISSION_LIST[missionInfo.location] or {}
      InfUtil.InsertUniqueInList(locationMissions,missionCode)
      TppDefine.LOCATION_HAVE_MISSION_LIST[missionInfo.location]=locationMissions

      local locationCode=TppDefine.LOCATION_ID[missionInfo.location]
      this.locationForMission[missionCode]=locationCode

      --tex mission start stuff:
      if missionInfo.clearExistingMissionStartSettings then --DEBUGNOW name a bit unweildy
        TppDefine.NO_HELICOPTER_MISSION_START_POSITION[missionCode]=nil
        TppDefine.NO_BOX_MISSION_START_POSITION[missionCode]=nil
        
        --DEBUGNOW move to InfUtil
        local function RemoveFromArray(array,valueToRemove)
          --tex find
          local foundIndex
          for i,v in ipairs(array)do
            if v==valueToRemove then
              foundIndex=i
              break
            end
          end--for array
          if foundIndex then
            table.remove(array,foundIndex)
          end
        end--RemoveFromArray
        
        RemoveFromArray(TppDefine.NO_ORDER_BOX_MISSION_LIST,tostring(missionCode))
        RemoveFromArray(TppDefine.NO_HELICOPTER_ROUTE_MISSION_LIST,tostring(missionCode))
        --DEBUGNOW
        InfCore.PrintInspect(TppDefine.NO_HELICOPTER_ROUTE_MISSION_LIST,"zzz TppDefine.NO_HELICOPTER_ROUTE_MISSION_LIST")   
        InfCore.PrintInspect(TppDefine.NO_ORDER_FIX_HELICOPTER_ROUTE,"zzzTppDefine.NO_ORDER_FIX_HELICOPTER_ROUTE")   
        --tex the enums are rebuilt just after for missionInfos loop   
      end
      --the 'loadingposition' code in the vanilla game is pretty twisty, but it basically boils down to:
      --assuming missions will start with a heli route, most likely given by chosing lz in idroid.
      --otherwise its either a start on foot via NO_HELICOPTER_MISSION_START_POSITION
      --or via a free roam > mission via the intel 'order(s) box'
      --or maybe its a mission that might otherwise have started by orderbox but isn't, then its a no order box mission (start)
      local startPos=missionInfo.startPos and missionInfo.startPos.pos or missionInfo.startPos
      if startPos then
        local rotY=startPos[4] or startPos.rotY
        startPos[4]=rotY--NO_BOX_MISSION_START_POSITION format of {x,y,z,rotY} but using for NO_HELICOPTER_MISSION_START_POSITION (which had no rotY in vanilla) as well to be consistant
        if not missionInfo.isNoOrderBoxMission then
          TppDefine.NO_HELICOPTER_MISSION_START_POSITION[missionCode]=startPos
        elseif not missionInfo.heliRouteForNoBoxMission then
          --noBoxMissionStartPosition
          TppDefine.NO_BOX_MISSION_START_POSITION[missionCode]=startPos
        end
      end--if startPos
      --tex indicates that theres no free roam mission box start (there are 7 of these in vanilla)
      --see also AddOrderBoxInfoToFreeRoam
      if missionInfo.isNoOrderBoxMission then--tex these are awkwardly worded, it's alway a struggle to decide whether to chose a nicer new name or keep it closer to what it's called in the vanilla data.
        InfUtil.InsertUniqueInList(TppDefine.NO_ORDER_BOX_MISSION_LIST,tostring(missionCode))
      end

      if missionInfo.heliRouteForNoBoxMission then
        --tex only used for two vanilla missions (of the 7 no box mission starts)
        InfUtil.InsertUniqueInList(TppDefine.NO_ORDER_FIX_HELICOPTER_ROUTE,missionInfo.heliRouteForNoBoxMission)
      end

      --tex pretty much just clears gvars.heli_missionStartRoute
      --Seems to just be to clear any selected heliroute for NO_HELICOPTER_MISSION_START_POSITION
      if missionInfo.clearMissionStartHeliRoute then
        InfUtil.InsertUniqueInList(TppDefine.NO_HELICOPTER_ROUTE_MISSION_LIST,tostring(missionCode))
      end

      --tex base gmp for mission on mission clear
      if missionInfo.missionGuaranteeGMP then
        TppResult.MISSION_GUARANTEE_GMP[missionCode]=missionInfo.missionGuaranteeGMP
      end
      --tex dont add volunteers on mission clear
      if missionInfo.noAddVolunteers then
        TppTerminal.noAddVolunteerMissions[missionCode]=true
      end

      if missionInfo.missionTaskList then
        TppResult.MISSION_TASK_LIST[missionCode]=missionInfo.missionTaskList
      end

      --tex TODO: shouldn't be needed
      --TppTerminal.noAddVolunteerMissions
      if missionInfo.fovaSetupFunc then
        TppEneFova.fovaSetupFuncs[missionCode]=missionInfo.fovaSetupFunc
      end

      if missionInfo.noArmorForMission then
        TppEneFova.noArmorForMission[missionCode]=1
      end
      if missionInfo.missionArmorType then
        TppEneFova.missionArmorType[missionCode]=missionInfo.missionArmorType
      end
      if missionInfo.missionHostageInfos then
        TppEneFova.missionHostageInfos[missionCode]=missionInfo.missionHostageInfos
      end

      --tex add IH start-on-foot support
      --missionInfo.missionMapParams is mbdvc_map_mission_parameter.missionParameters entry
      if missionInfo.missionMapParams and missionInfo.missionMapParams.heliLandPoint then
        for n,heliLandPoint in ipairs(missionInfo.missionMapParams.heliLandPoint)do
          local routeIdStr32=InfCore.StrCode32(heliLandPoint.routeId)
          if InfLZ.groundStartPositions[1][routeIdStr32] then
            InfCore.Log("WARNING: entry for "..heliLandPoint.routeId.." already in InfLZ.groundStartPositions")
          end
          --tex heliLandPoint.point is ui point and .startPoint is the start of the route (according to caplag eyeballing a mission), as he's used it in gntn as the ground point without any issues I guess the game either doesn't use it, or it warps to route start which would make it moot anyhoo
          --using startPoint for custom missions to allow the author some more control over the startOnFoot point.
          --DEBUGNOW this means I can't use AddLzPointsFromMissionParameters yet (because its using .point)
          InfLZ.groundStartPositions[1][routeIdStr32]={pos={heliLandPoint.startPoint:GetX(),heliLandPoint.startPoint:GetY(),heliLandPoint.startPoint:GetZ()}}
        end
      end--if missionInfo heliLandPoint

      if missionInfo.lzInfo then
        rebuildLzTables=true
        this.AddLzInfo(missionInfo)
      end

      if missionInfo.defaultDropRoute then
        if TppMission.IsStoryMission(missionCode)then
          TppDefine.DEFAULT_DROP_ROUTE[missionCode]=missionInfo.defaultDropRoute
        end
      end
      --DEBUGNOW there's also isDefault on some mbdvc_map_mbstage_parameter routes?
    end--if validate
  end--for missionInfo
  
  --tex rebuild enums, TppDefine.Enum always returns a new table (unlike Tpp.Enum which modifies input table)
  TppDefine.NO_HELICOPTER_ROUTE_ENUM=TppDefine.Enum(TppDefine.NO_HELICOPTER_ROUTE_MISSION_LIST)
  TppDefine.NO_ORDER_BOX_MISSION_ENUM=TppDefine.Enum(TppDefine.NO_ORDER_BOX_MISSION_LIST)
    
  if rebuildLzTables then
    if this.debugModule then
      InfCore.PrintInspect(TppLandingZone.locInfo,"TppLandingZone.locInfo")--DEBUGNOW
    end
    TppLandingZone.BuildMissionLzTable()
  end

  if this.debugModule then
    InfCore.PrintInspect(this.missionInfo,"missionInfo")
  end
end--AddInMissions
function this.AddLzInfo(missionInfo)
  --DEBUGNOW currently only MissionLandingZoneTable as aacrGimmicks not worked out yet
  --REF
  --TppLandingZone.locInfo={
  --  afgh={
  --    MissionLandingZoneTable={
  --      {aprLandingZoneName="lz_bridge_S0000|lz_bridge_S_0000",drpLandingZoneName="lz_drp_bridge_S0000|rt_drp_bridge_S_0000",missionList={10040}},
  local locationNameLower=string.lower(missionInfo.location)
  for lzName,lzInfo in pairs(missionInfo.lzInfo)do
    InfLZ.lzInfo[lzName]=lzInfo

    TppLandingZone.locInfo[locationNameLower]=TppLandingZone.locInfo[locationNameLower] or {MissionLandingZoneTable={},ConnectLandingZoneTable={}}
    local missionLandingZoneTable=TppLandingZone.locInfo[locationNameLower].MissionLandingZoneTable
    local currentLzEntry
    --tex find any existing entry for lz DEBUGNOW slow
    for lzName,lzEntry in pairs(missionLandingZoneTable)do
      if lzEntry.aprLandingZoneName==lzName then
        currentLzEntry=lzEntry
        break
      end
    end--for missionLandingZoneTable
    --DEBUGNOW validate that drpLandingZoneName matches?
    if not currentLzEntry then
      --GOTCHA: aprLandingZoneName is lzName (not route), while drpLandingZoneName is droproute (for that lz)
      currentLzEntry={aprLandingZoneName=lzName,drpLandingZoneName=lzInfo.dropRoute,missionList={}}
      table.insert(missionLandingZoneTable,currentLzEntry)
    end

    if TppMission.IsStoryMission(missionInfo.missionCode)then
      InfUtil.InsertUniqueInList(currentLzEntry.missionList,missionInfo.missionCode)
    else
      --tex KLUDGE need something open, so just slap in early mission
      --a solution would be to - if IsFreeRoam then for all storymission in that location add
      InfUtil.InsertUniqueInList(currentLzEntry.missionList,10020)
    end
    if this.debugModule then
      InfCore.PrintInspect(currentLzEntry,"currentLzEntry")
    end
  end--for lzInfo
end--AddLzInfo

--tex register missions with UI/TPP Mission system
--IN/SIDE: this.missionIds
--OUT/SIDE: this.missionListSlotIndices
--OUT/SIDE: TppDefine.MISSION_LIST, TppDefine.MISSION_ENUM
function this.RegisterMissions()
  InfCore.LogFlow("InfMission.RegisterMissions")
  --tex LIMIT WORKAROUND exe/ui seems to have same limit as TppDefine.MISSION_COUNT_MAX
  --but there's issues with mission completed rank not matching and seemingly no lua>ui way to set it
  --unlike the rest of the information via Mission.RegisterMissionCodeList, the gmp and task completion via TppResult.GetMbMissionListParameterTable
  --so am reusing the MISSING_NUMBER_MISSION_LIST which is flyk and some uncompleted extreme/subsidence of other missions
  --
  --plus the 2 actual free missionlist slots
  this.missionListSlotIndices={}
  for i,missionCodeStr in ipairs(TppDefine.MISSING_NUMBER_MISSION_LIST)do
    local missionIndex=TppDefine.MISSION_ENUM[missionCodeStr]
    table.insert(this.missionListSlotIndices,missionIndex)
  end

  for i=#TppDefine.MISSION_LIST,TppDefine.MISSION_COUNT_MAX-1 do
    table.insert(this.missionListSlotIndices,i)
  end
  table.sort(this.missionListSlotIndices)

  if this.debugModule then
    local numFreeMissions=TppDefine.MISSION_COUNT_MAX-(#TppDefine.MISSION_LIST-#TppDefine.MISSING_NUMBER_MISSION_LIST)
    --tex or just TppDefine.MISSION_COUNT_MAX-#this.missionListSlotIndices
    InfCore.Log("numFreeMissions="..numFreeMissions)
    InfCore.PrintInspect(this.missionListSlotIndices,"missionListSlotIndices")
    InfCore.PrintInspect(TppDefine.MISSION_LIST,"missionlist vanill")
  end

  local freeSlot=1
  for i,missionCode in ipairs(this.missionIds)do
    if freeSlot>#this.missionListSlotIndices then
      InfCore.Log("WARNING: No free MISSION_LIST slots")
      break
    else--if not this.IsVanillaMission(missionCode)then--tex OVERKILL, shouldn't be in missionIds in the first place
      local missionIndex=this.missionListSlotIndices[freeSlot]
      freeSlot=freeSlot+1
      TppDefine.MISSION_LIST[missionIndex+1]=tostring(missionCode)--GOTCHA: MISSION_LIST 1based, MISSION_ENUM 0based
      InfCore.Log("MISSION_LIST[missionIndex:"..missionIndex.."]="..missionCode)
    end--not IsVanillaMission
  end--for missionIds
  TppDefine.MISSION_ENUM=TppDefine.Enum(TppDefine.MISSION_LIST)--tex DEBUGNOW TODO look at what else uses MISSION_ENUM and how it might be affected if it varies over sessions, MISSION_LIST too I guess

  if this.debugModule then
    InfCore.PrintInspect(TppDefine.MISSION_ENUM,"MISSION_ENUM")--DEBUGNOW
    InfCore.PrintInspect(TppDefine.MISSION_LIST,"missionlist modded")
    InfCore.PrintInspect(#TppDefine.MISSION_LIST,"#missionlist")
  end

  local highestMissionNum=this.highestUIMission
  for i,missionCode in ipairs(this.missionIds)do
    highestMissionNum=highestMissionNum+1
    InfCore.Log("RegistMissionEpisodeNo("..missionCode..","..highestMissionNum..")")
    TppUiCommand.RegistMissionEpisodeNo(missionCode,highestMissionNum)--TODO see if this is happy with being called more than once for a mission code (ie via reloadmodules)
  end

  --tex register modified list
  Mission.RegisterMissionCodeList{codeList=TppDefine.MISSION_LIST}--TODO see if this is happy with being called more than once for a mission code (ie via reloadmodules), it's already been called once anyway in vanilla in TppDefine
end

--CALLER: start2nd>InfMain.LoadLibraries
function this.LoadLibraries()
  if InfCore.gameId~="TPP" then
    return
  end

  this.LoadStates()
  this.LoadLocationDefs()
  this.LoadMissionDefs()

  this.AddInLocations()
  this.AddInMissions()


  this.missionIds={}--clear
  for missionCode,missionInfo in pairs(this.missionInfo)do
    if not this.IsVanillaMission(missionCode) and not TppMission.IsFreeMission(missionCode) and not missionInfo.hideMission then
      table.insert(this.missionIds,missionCode)
    end
  end
  table.sort(this.missionIds)

  this.RegisterMissions()

  this.freeMissionIds={}
  this.freeMissionForLocation={
    [TppDefine.LOCATION_ID.AFGH]=30010,
    [TppDefine.LOCATION_ID.MAFR]=30020,
  --DEBUGNOW the mission<>freemisson functions where it was originally used for don't have MTBS
  --OFF [TppDefine.LOCATION_ID.MTBS]=30050,
  }
  for missionCode,missionInfo in pairs(this.missionInfo)do
    if not this.IsVanillaMission(missionCode) and TppMission.IsFreeMission(missionCode) and not missionInfo.hideMission then
      table.insert(this.freeMissionIds,missionCode)

      local locationId=TppDefine.LOCATION_ID[missionInfo.location]--DEBUGNOW
      if locationId==nil then
        InfCore.Log("ERROR: InfMission.LoadLibraries: locationId==nil for missionInfo.location:"..tostring(missionInfo.location))
      else
        if this.freeMissionForLocation[locationId] then
          if this.freeMissionForLocation[locationId]~=missionCode then
            InfCore.Log("WARNING: InfMission.LoadLibraries: freeMissionForLocation["..locationId.."] already has a different free mission defined")
          end
        else
          this.freeMissionForLocation[locationId]=missionCode
        end--if freeMissionForLocation
      end--if locationId
    end
  end--for missionInfo

  this.UpdateChangeLocationMenu()

  if this.debugModule then
    InfCore.PrintInspect(this.missionIds,"missionIds")
    InfCore.PrintInspect(this.locationInfo,"locationInfo")
    InfCore.PrintInspect(this.missionInfo,"missionInfo")
    InfCore.PrintInspect(TppMissionList.locationPackTable,"TppMissionList.locationPackTable")
    InfCore.PrintInspect(TppMissionList.missionPackTable,"TppMissionList.missionPackTable")
    InfCore.PrintInspect(TppDefine.LOCATION_ID,"TppDefine.LOCATION_ID")
    InfCore.PrintInspect(TppDefine.LOCATION_HAVE_MISSION_LIST,"TppDefine.LOCATION_HAVE_MISSION_LIST")
    InfCore.PrintInspect(TppDefine.NO_HELICOPTER_MISSION_START_POSITION,"TppDefine.NO_HELICOPTER_MISSION_START_POSITION")
    InfCore.PrintInspect(TppDefine.NO_ORDER_BOX_MISSION_LIST,"TppDefine.NO_ORDER_BOX_MISSION_LIST")
    --TppDefine.NO_ORDER_BOX_MISSION_ENUM
    InfCore.PrintInspect(TppDefine.NO_HELICOPTER_ROUTE_MISSION_LIST,"TppDefine.NO_HELICOPTER_ROUTE_MISSION_LIST")   
    InfCore.PrintInspect(TppDefine.NO_ORDER_FIX_HELICOPTER_ROUTE,"TppDefine.NO_ORDER_FIX_HELICOPTER_ROUTE")   
    --InfCore.PrintInspect(mbdvc_map_location_parameter,"mbdvc_map_location_parameter")
    InfCore.PrintInspect(this.locationForMission,"locationForMission")
    InfCore.PrintInspect(this.freeMissionForLocation,"freeMissionForLocation")
    InfCore.PrintInspect(this.helispaceForLocation,"heliSpaceForLocation")
  end
end--LoadLibraries

function this.OnStartTitle()
  --tex since registermissions is run before the first game save/gvar load
  this.SetupAddonStateGVars()
end

--CALLER: mbdvc_map_location_parameter.GetMapLocationParameter --tex cant patch in to script since it seems mbdvc_map_location_parameter is torn down/reloaded so instead called from mbdvc_map_location_parameter
function this.GetMapLocationParameter(locationId)
  InfCore.LogFlow("InfMission.GetMapLocationParameter "..tostring(locationId))
  local locationInfo=this.locationInfo[locationId]
  if locationInfo then
    return locationInfo.locationMapParams
  end
end
--CALLER: mbdvc_map_location_parameter.GetMapLocationParameter --tex cant patch in to script since it seems mbdvc_map_location_parameter is torn down/reloaded so instead called from mbdvc_map_location_parameter
--DEBUGNOW TEST PCallDebug these functions?-^--v-
function this.AddGlobalLocationParameters(globalLocationParameters)
  InfCore.LogFlow"InfMission.AddGlobalLocationParameters"
  local enableHerbSearch=Ivars.disableHerbSearch:Is(0)--tex patches in IH disableHerbSearch support (if they have locationParams.isHerbSearchEnable set)
  for locationId,locationInfo in pairs(this.locationInfo)do
    local locationParams=locationInfo.globalLocationMapParams
    if locationParams then
      locationParams.locationId=locationId
      if locationParams.isSpySearchEnable then
        locationParams.isSpySearchEnable=true--tex IH uses a different method to globally enable/disable, see disableSpySearch ivar
      end
      if locationParams.isHerbSearchEnable then
        locationParams.isHerbSearchEnable=enableHerbSearch
      end
      table.insert(globalLocationParameters,locationParams)
    end
  end--for locationInfo
end--AddGlobalLocationParameters

--CALLER: mbdvc_map_mission_parameter.GetMissionParameter
function this.GetMapMissionParameter(missionCode)
  InfCore.LogFlow("InfMission.GetMapMissionParameter "..tostring(missionCode))
  --TODO mgo style map param for location
  --TODO see if mgo map params are useful
  local missionInfo=this.missionInfo[missionCode]
  if missionInfo then
    return missionInfo.missionMapParams
  end
end

--rlcs RemoveInvalidTasks
--FIXUP BADATA
--tex also fixes <r237 BUG, see SetupAddonMissionStates
--fix any invalid ui_isTaskLastComleted tasks as defined by MISSION_TASK_LIST
--symptom of the invalid data is incorrect mission task completion percentage
function this.RemoveInvalidTasks()
  InfCore.Log("Removing invalid tasks")

  local inspectTable={}--debug inspect

  for missionIndex=0, TppDefine.MISSION_COUNT_MAX-1 do
    --Checking mission
    local missionCode = TppDefine.MISSION_LIST[missionIndex+1]

    if tonumber(missionCode) then
      inspectTable[tonumber(missionCode)]={} --debug inspect
    end

    for taskIndex=0, TppDefine.MAX_MISSION_TASK_COUNT-1 do
      --Checking the task of the mission
      local globalTaskIndexStart = missionIndex*TppDefine.MAX_MISSION_TASK_COUNT
      local globalTaskIndex = globalTaskIndexStart + taskIndex

      --Checking if the task is valid against TppResult.MISSION_TASK_LIST
      local validTask=false
      local taskTable=TppResult.MISSION_TASK_LIST[tonumber(missionCode)]
      if Tpp.IsTypeTable(taskTable) then
        for taskListIndex, validTaskIndex in ipairs(taskTable) do
          if taskIndex==validTaskIndex then
            -- TppResult.MISSION_TASK_LIST[missionCode]={} table contains the task index, task is valid
            validTask=true
            break
          end
        end
      end
      if validTask==false then
        if gvars.ui_isTaskLastComleted[globalTaskIndex]==true then  
          --Did not pass validity check through TppResult.MISSION_TASK_LIST, resetting task
          gvars.ui_isTaskLastComleted[globalTaskIndex]=false
        end
      end

      if tonumber(missionCode) then
        inspectTable[tonumber(missionCode)][taskIndex+1]={ --debug inspect
          internalIndex=taskIndex, --0 thru 7 task index
          flag=gvars.ui_isTaskLastComleted[globalTaskIndex], --true or false - cleared or not
          valid=validTask, --true or false - valid on MISSION_TASK_LIST or not
          globalIndex=globalTaskIndex, --0 thru 511 index
        }
      end
    end
  end
  if this.debugModule then
    InfCore.PrintInspect(inspectTable,"inspectTable") --debug inspect
  end
end--RemoveInvalidTasks

--tex mission state gvar names
--pretty much all gvars that are indexed by MISSION_COUNT_MAX
local gvarFlagNames={
  --TppStory
  "str_missionOpenPermission",--PermitMissionOpen
  "str_missionOpenFlag",--SetMissionOpenFlag
  "str_missionNewOpenFlag",--SetMissionNewOpenFlag
  "str_missionClearedFlag",--UpdateMissionCleardFlag
  "res_bestRank",--see TppResult.SetBestRank,GetBestRank
  "rnk_missionBestScore",--tex should be cautious with rnk_ stuff since its kjp server rank records stuff, in the case of these gvars see RegistMissionClearRankingResult
  "rnk_missionBestScoreUsedLimitEquip",
}
--REF
--{name="ui_isTaskLastComleted",arraySize=TppDefine.MISSION_COUNT_MAX*TppDefine.MAX_MISSION_TASK_COUNT,type=TppScriptVars.TYPE_BOOL --tex handled seperatly due to the 2d>1d indexing 
--tex could look up TppGvars.DeclareGVarsTable value, but would have to iterate whole table since its not keyed
--Assuming bool/false if type not given
local gvarFlagDefaults={
  res_bestRank=TppDefine.MISSION_CLEAR_RANK.E+1,
  rnk_missionBestScore=0,
  rnk_missionBestScoreUsedLimitEquip=0,
}

--CALLER: TppStory.UpdateStorySequence
--IN/SIDE: this.missionListSlotIndices
function this.SetupAddonStateGVars()
  InfCore.LogFlow("InfMission.SetupAddonStateGVars")

  --DEBUGNOW limit to only run once



  --tex clear gvars for mission slots being used for addon missions (see RegisterMissions missionListSlotIndices) first so its ok if user uninstalls mission
  for i,missionListIndex in ipairs(this.missionListSlotIndices)do
    --InfCore.Log("Clearing "..missionListIndex)
    for i, name in ipairs(gvarFlagNames)do
      gvars[name][missionListIndex]=gvarFlagDefaults[name] or false
    end

    for taskIndex=0,TppDefine.MAX_MISSION_TASK_COUNT-1 do
      local missionTaskIndex=missionListIndex*TppDefine.MAX_MISSION_TASK_COUNT+taskIndex
      --tex <r237 BUG: (though discovered in r233, why didnt I fix till 237? who knows)
      --gvars.ui_isTaskLastComleted[missionListIndex-1]=0--GOTCHA TppScriptVars of TYPE_BOOL being set to 0 sets value to true
      --this resulted in trashing some of the users ui_isTaskLastComleted data, a symptom of which being incorrect percentage completion
      
      gvars.ui_isTaskLastComleted[missionTaskIndex]=false
    end
  end

  this.ReadSaveStates()  
  
  local ih_states=ih_mission_states
  for missionCode,missionInfo in pairs(this.missionInfo)do  
    --tex open missions. TODO: story progress support
    InfCore.Log("Opening "..missionCode)
    TppStory.PermitMissionOpen(missionCode)
    TppStory.SetMissionOpenFlag(missionCode,true)
    --TppStory.MissionOpen(missionCode)
      
    --tex flag new missions  
    local name=missionInfo.name
    if not ih_states[name] then
      local missionIndex=TppDefine.MISSION_ENUM[tostring(missionCode)]
      if missionIndex then
        TppStory.SetMissionNewOpenFlag(missionCode,true)
      end
    end
  end--for missionInfo  
  
  this.RemoveInvalidTasks()--FIXUP ui_isTaskLastComleted
end--SetupAddonStateGVars

--saving/loading addon mission gvars that need to be juggled since they are reusing mission slots
--tex currently only loads ih_mission_states once on session
--but saves to is on every game save
--the mission gvars keep doing their thing normally after the initial set by ih
--
--
this.debugSave=true--DEBUGNOW

this.isSaveDirty=false

this.saveName="ih_mission_states.lua"

--tex don't lose existing on modulereload
ih_mission_states=ih_mission_states or {}

--CALLER: MakeNewGameSaveData
--TODO: delete file outright
function this.ClearSave()
  --tex only bother saving if there was something in previous
  if next(ih_mission_states)~=nil then
    this.isSaveDirty=true
  end
  --tex clear
  ih_mission_states={}
end--ClearSave

function this.Save(newSave)
  local ih_states=ih_mission_states

  local isSaveDirty=this.isSaveDirty or this.GetCurrentStates()--tex nothing else currently sets isSaveDirty, but keeping it the same as InfQuest
  if isSaveDirty then
    if this.debugSave then
      InfCore.Log("missionStates isDirty")
    end
--CULL
--    local saveTextList={
--      "-- "..this.saveName,
--      "-- save states for addon missions.",
--      "local this={}",
--    }
--    for name,state in pairs(ih_states)do
--      IvarProc.BuildTableText(name,state,saveTextList)
--    end
--
--    saveTextList[#saveTextList+1]="return this"

    local saveTextList={
      "-- "..this.saveName,
      "-- save states for addon missions.",
      "local this="..InfInspect.Inspect(ih_states),
      "return this"
    }
    IvarProc.WriteSave(saveTextList,this.saveName)
    this.isSaveDirty=false
  end

  if this.debugSave then
    InfCore.PrintInspect(ih_states,"states")
  end
end--Save
--GOTCHA: not module 'LoadSave' because we only really want to load once on , as gvars handles reverting state
--OUT: ih_mission_states
function this.LoadStates()
  InfCore.LogFlow"InfMission.LoadStates"
  local saveName=this.saveName
  local filePath=InfCore.paths.saves..saveName
  if not InfCore.FileExists(filePath) then
    InfCore.Log(filePath.." does not exist. (File is only created if addon missions installed)",false,true);
    return nil
  end
  
  local box=true
  local ih_save=InfCore.LoadSimpleModule(InfCore.paths.saves,saveName,box)

  if ih_save==nil then
    local errorText="LoadStates Error: ih_save==nil"
    InfCore.Log(errorText,true,true)
    return nil
  end

  if type(ih_save)~="table"then
    local errorText="LoadStates Error: ih_save==table"
    InfCore.Log(errorText,true,true)

    return nil
  end

  ih_mission_states=ih_save
  if this.debugSave then
    InfCore.PrintInspect(ih_mission_states,"ih_mission_states")
  end
end--LoadStates

--tex set mission status gvars from ih save state
--IN/SIDE: ih_mission_states
--REF ih_mission_states
--ih_mission_states={
--  13005_afgh={
--    str_missionClearedFlag=true,
--    ...
--  },
--  ...
--}
--tex TODO: give user options whether to clear old entries or not (ditto InfQuest)
function this.ReadSaveStates()
  InfCore.LogFlow"InfMission.ReadSaveStates"
  local ih_states=ih_mission_states

  if ih_states==nil then
    local errorText="ERROR: ReadSaveStates: ih_mission_states==nil"
    InfCore.Log(errorText,true,true)
    return {}
  end

  if this.debugSave then
    InfCore.PrintInspect(ih_states,"states")
  end

  local clearStates={}
  for name,state in pairs(ih_states) do
    local missionInfo=this.missionNames[name]
    if not missionInfo then
        InfCore.Log("InfMission.ReadSaveStates: Could not find missionInfo for "..name..". Clearing")
        table.insert(clearStates,name)--tex dont propogate it (also cant delete from table you're iterating, so actual clear ias after the loop)        
    else
      local missionIndex=TppDefine.MISSION_ENUM[tostring(missionInfo.missionCode)]
      if not missionIndex then
        InfCore.Log("InfMission.ReadSaveStates: Could not find missionIndex for "..name.." "..missionInfo.missionCode..". Clearing")
        table.insert(clearStates,name)--tex dont propogate it (also cant delete from table you're iterating, so actual clear ias after the loop)
      else
        InfCore.Log("InfMission.ReadSaveStates: Setting state gvars for "..name.." missionIndex:"..missionIndex)
        for i,gvarFlagName in ipairs(gvarFlagNames)do
          gvars[gvarFlagName][missionIndex]=state[gvarFlagName] or gvarFlagDefaults[gvarFlagName] or false
        end
        
        if state.ui_isTaskLastComleted then
          for taskIndex=0,TppDefine.MAX_MISSION_TASK_COUNT-1 do
            local missionTaskIndex=missionIndex*TppDefine.MAX_MISSION_TASK_COUNT+taskIndex
            gvars.ui_isTaskLastComleted[missionTaskIndex]=state.ui_isTaskLastComleted[taskIndex+1]
          end
        end--if ui_isTaskLastComleted
      end--if missionIndex
    end--if missionInfo
  end--for ih_states

  for i,name in ipairs(clearStates)do
    ih_states[name]=nil
  end
end--ReadSaveStates
--returns isDirty
--OUT/SIDE: ih_mission_states
function this.GetCurrentStates()
  local MISSION_ENUM=TppDefine.MISSION_ENUM
  local gvars=gvars
  local ih_states=ih_mission_states
  if this.debugModule then
    InfCore.PrintInspect(ih_mission_states,"GetCurrentStates: pre ih_mission_states")
  end

  local isSaveDirty=false

  for missionCode,missionInfo in pairs(this.missionInfo)do
    local name=missionInfo.name
    local missionIndex=MISSION_ENUM[tostring(missionCode)]
    if not missionIndex then
      if this.debugSave then
        InfCore.Log("InfMission.GetCurrentStates: Could not find missionIndex for "..name.." "..missionCode,false,true)
      end
    else
      InfCore.Log("InfMission.GetCurrentStates: "..name.." "..missionCode.." missionIndex:"..missionIndex)
      local states=ih_states[name] or {}

      for i,gvarFlagName in ipairs(gvarFlagNames) do
        local gvarValue=gvars[gvarFlagName][missionIndex]
        if states[gvarFlagName]~=gvarValue then
          isSaveDirty=true
          states[gvarFlagName]=gvarValue
        end
      end
      
      states.ui_isTaskLastComleted=states.ui_isTaskLastComleted or {}
      for taskIndex=0,TppDefine.MAX_MISSION_TASK_COUNT-1 do
        local missionTaskIndex=missionIndex*TppDefine.MAX_MISSION_TASK_COUNT+taskIndex
        states.ui_isTaskLastComleted[taskIndex+1]=gvars.ui_isTaskLastComleted[missionTaskIndex]
      end

      ih_states[name]=states
    end
  end--for missionInfo
  
  if this.debugModule then
    InfCore.PrintInspect(ih_mission_states,"GetCurrentStates: post ih_mission_states")
  end

  return isSaveDirty
end--GetCurrentStates
--< save/load stuff

function this.GetLocationInfo(locationCode)
  --locationCode=locationCode or vars.locationCode
  return this.locationInfo[locationCode]
end
--tex missionCode only needed for debug
function this.GetFreeMissionForLocation(locationCode,missionCode)
  InfCore.Log("InfMission.GetFreeMissionForLocation "..tostring(locationCode)..", "..tostring(missionCode))
  --locationCode=locationCode or vars.locationCode
  return this.freeMissionForLocation[locationCode] or TppDefine.SYS_MISSION_ID.AFGH_FREE
end

--CALLER: TppTerminal.ReleaseFreePlay
--Enables the free roam entry
--but the issue is that name doesnt show
--despite there being a map_location_parameter - locationNameLangId = "tpp_loc_<whatever> (that matches tpp_common lng for vanilla free)
--however the above map does show
--given that there's a location icon I guess that's set up in engine
--TODO: find the names of the icons
--see IHHook GetFreeRoamLangIdHook and UpdateChangeLocationMenu below for fix
--CALLER: TppTerminal.Init > TppTerminal.ReleaseFreePlay
function this.EnableLocationChangeMissions()
  local skipLocations={
    [TppDefine.LOCATION_ID.AFGH]=true,
    [TppDefine.LOCATION_ID.MAFR]=true,
    [TppDefine.LOCATION_ID.MTBS]=true,
  }
  for locationCode,freeMissionCode in pairs(this.freeMissionForLocation)do
    if skipLocations[locationCode]~=true then
      InfCore.Log("EnableChangeLocationMenu{locationId="..locationCode..",missionId="..freeMissionCode.."}")
      TppUiCommand.EnableChangeLocationMenu{locationId=locationCode,missionId=freeMissionCode}
    end
  end
end--EnableLocationChangeMissions

--see above comment
function this.UpdateChangeLocationMenu()
  local locationLangIds={
    [10]="tpp_loc_afghan",
    [20]="tpp_loc_africa",
    [30]="tpp_loc_cyprus",--tex has langid, but wasn't referenced in the original function I found.
    [50]="tpp_loc_mb",
  }--locationLangIds
  for locationCode,locationInfo in pairs(this.locationInfo)do
    local langId
    if locationInfo.locationMapParams then
      langId=locationInfo.locationMapParams.locationNameLangId
    end
    langId=langId or ("tpp_loc_"..string.lower(locationInfo.locationName))

    locationLangIds[locationCode]=langId--tex handle hashing on ihhook side since I'm unsure of lua number size Fox.StrCode(langId)--strcode64
  end
  if IHH then
    IHH.UpdateChangeLocationMenu(locationLangIds)
  end
end--UpdateChangeLocationMenu

--orig in TppResult.GetMbMissionListParameterTable
-- currently conflict with Anyones Improvements
--OFF CULL
function this.GetMbMissionListParameterTable()
  InfCore.LogFlow("InfMission.GetMbMissionListParameterTable")--tex DEBUG
  local missionListParameterTable={}
  for missionCodeStr,enum in pairs(TppDefine.MISSION_ENUM)do
    local missionCode=tonumber(missionCodeStr)
    local missionParameters={}
    missionParameters.missionId=missionCode
    if this.MISSION_GUARANTEE_GMP[missionCode]then
      missionParameters.baseGmp=101--DEBUGNOW setting to magic number to see if working--ORIG this.MISSION_GUARANTEE_GMP[missionCode]
      missionParameters.currentGmp=101--DEBUGNOW setting to magic number to see if working --ORIG this.GetMissionGuaranteeGMP(missionCode)
    end
    if this.MISSION_TASK_LIST[missionCode]then
      missionParameters.completedTaskNum=TppUI.GetTaskCompletedNumber(missionCode)
      missionParameters.maxTaskNum=#this.MISSION_TASK_LIST[missionCode]
      missionParameters.taskList=this.MISSION_TASK_LIST[missionCode]
    end

    --OFF tex DEBUGNOW TODO what was I trying to do here?
    --    local isMissingNumberMission=TppDefine.MISSING_NUMBER_MISSION_ENUM[missionCodeStr]--tex
    --    if isMissingNumberMission then
    --      InfCore.Log("---------- GetMbMissionListParameterTable "..missionCodeStr)
    --    end
    --    if not isMissingNumberMission then--tex added skip
    --      table.insert(missionListParameterTable,missionParameters)
    --    end
    --
  end

  return missionListParameterTable
end

--REF
--  weaponIdTable={
--    NORMAL={
--      HANDGUN=TppEquip.EQP_WP_East_hg_010,
--      SMG=TppEquip.EQP_WP_East_sm_010,
--      ASSAULT=TppEquip.EQP_WP_East_ar_010,
--      SNIPER=TppEquip.EQP_WP_East_sr_011,
--      SHOTGUN=TppEquip.EQP_WP_Com_sg_011,
--      MG=TppEquip.EQP_WP_East_mg_010,
--      MISSILE=TppEquip.EQP_WP_East_ms_010,
--      SHIELD=TppEquip.EQP_SLD_SV
--    },
--    STRONG={
--      HANDGUN=TppEquip.EQP_WP_East_hg_010,
--      SMG=TppEquip.EQP_WP_East_sm_020,
--      ASSAULT=TppEquip.EQP_WP_East_ar_030,
--      SNIPER=TppEquip.EQP_WP_East_sr_020,
--      SHOTGUN=TppEquip.EQP_WP_Com_sg_020,
--      MG=TppEquip.EQP_WP_East_mg_010,
--      MISSILE=TppEquip.EQP_WP_Com_ms_010,
--      SHIELD=TppEquip.EQP_SLD_SV
--    }
--  }
function this.ValidateWeaponIdTable(weaponIdTable)
  local valid=true
  for strength,weaponTable in pairs(weaponIdTable)do
    for weaponType,equipId in pairs(weaponTable)do
      if equipId==nil then
        InfCore.Log("WARNING: InfMission.ValidateWeaponIdTable: equipId nil for weaponTable category "..strength.." "..weaponType)
        return false
      else
      --local equipName=InfLookup.TppEquip.equipId[equipId]--DEBUG
      --InfCore.Log("ValidateWeaponIdTable "..strength.." "..weaponType.." "..equipName.." "..equipId)--DEBUG
      end
    end
  end
  return valid
end

--CALLER: TppEnemy.GetWeaponIdTable
--returns soldier type weaponIdTable
--GOTCHA: soldierType==EnemyType, soldierSubType==string
function this.GetSoldierWeaponIdTable(soldierType,soldierSubType)
  if InfMain.IsOnlineMission(vars.missionCode)then
    return nil
  end

  local weaponIdTable
  local missionInfo=this.missionInfo[vars.missionCode]
  if missionInfo then
    weaponIdTable=missionInfo.weaponIdTable
    --tex key is just a soldierSubType string to lookup the base weaponIdTable
    if type(weaponIdTable)=="string" then
      weaponIdTable=TppEnemy.weaponIdTable[weaponIdTable]
      if weaponIdTable==nil then
        InfCore.Log("WARNING: InfMission.GetWeaponIdTable: could not find weaponIdTable["..missionInfo.weaponIdTable.."]")
      end
    elseif type(weaponIdTable)=="table" then
      --LEGACY: initial implementation missionInfo.weaponIdTable was just a soldieSubType weaponIdTable
      if weaponIdTable.NORMAL or weaponIdTable.STRONG then
      --will just use weaponIdTable
      else
        --assuming its a full weaponIdTable
        weaponIdTable=TppEnemy.GetSoldierWeaponIdTable(weaponIdTable,soldierType,soldierSubType)
      end
    else
      weaponIdTable=nil
    end
  end--if missionInfo

  return weaponIdTable
end--GetSoldierWeaponIdTable
--
--tex need to patch in some orderbox data into the free roam mission scripts.
--TppMission.OnAllocate (which is run before this?) sets mvars.mis_orderBoxList to .missionStartPosition.orderBoxList, but doesn't seem to be used till later in execution
--OnAllocate is just before <sequence>.MissionPrepare which in freeroam calls:
--TppScriptBlock.RegisterCommonBlockPackList( "orderBoxBlock", f30020_orderBoxList.orderBoxBlockList )
--REF
--<free roam>_sequence.missionStartPosition = {
--    orderBoxList = {
--      "box_s10033_00",
--      "box_s10033_01",
--      ...
--REF
--<free roam>_orderBoxList.orderBoxBlockList[10081] = { "/Assets/tpp/pack/mission2/story/s10081/s10081_order_box.fpk" }
--CALLER: this.OnAllocate
function this.AddOrderBoxInfoToFreeRoam(missionTable)
  InfCore.Log("InfMission.AddOrderBoxInfoToFreeRoam")--
  local currentMissionCode=vars.missionCode
  local currentLocationCode=vars.locationCode
  local missionStartPosition=missionTable.sequence.missionStartPosition--tex such a strange name for what the table is used for. ASSUMPTION always exists (it should if the sequence script has been cribbed from a vanilla script)
  if not missionStartPosition then
    InfCore.Log("WARNING: InfMission.AddOrderBoxInfoToFreeRoam: missionTable.sequence.missionStartPosition==nil ")
  else
    --  local sequenceModule = _G["f"..missionCode.."_sequence] -- is just missionTable.sequence
    local orderBoxListModule=_G["f"..currentMissionCode.."_orderBoxList"]
    for missionCode,missionInfo in pairs(this.missionInfo)do
      local missionLocationCode=TppDefine.LOCATION_ID[missionInfo.location]
      if not missionLocationCode then
        InfCore.Log("ERROR: TppDefine.LOCATION_ID[missionInfo.location]==nil")
      elseif missionLocationCode==currentLocationCode then
        if missionInfo.orderBoxList then
          if not missionStartPosition.orderBoxList then
            InfCore.Log("WARNING: missionTable.sequence.missionStartPosition.orderBoxList==nil")
            missionStartPosition.orderBoxList={}
          end
          for i,boxName in ipairs(missionInfo.orderBoxList)do
            InfUtil.InsertUniqueInList(missionStartPosition.orderBoxList,boxName)
          end
        end--if missionInfo.orderBoxList

        if missionInfo.orderBoxBlockList then
          if not orderBoxListModule then
            InfCore.Log("WARNING: no _orderBoxList module for "..missionCode)
          else
            orderBoxListModule.orderBoxBlockList[missionInfo.missionCode]=missionInfo.orderBoxBlockList
          end
        end--missionInfo.orderBoxBlockList
      end--for this.missionInfo
    end--if missionLocation

    if this.debugModule then
      InfCore.PrintInspect(missionStartPosition.orderBoxList,"missionStartPosition.orderBoxList")
      InfCore.PrintInspect(orderBoxListModule,"orderBoxListModule")
    end
  end--if missionStartPosition
end--AddOrderBoxInfoToFreeRoam
function this.OnAllocate(missionTable)
  if TppMission.IsFreeMission(vars.missionCode)then
    this.AddOrderBoxInfoToFreeRoam(missionTable)
  end--if IsFreeMission
end--OnAllocate

function this.Init(missionTable)
  -- OFF
  --tex Original in TppResult.Init ,  TODO: log to see when this is called in relation to that
  --  if TppUiCommand.RegisterMbMissionListFunction then
  --    if TppUiCommand.IsTppUiReady()then
  --    InfCore.LogFlow("TppUiCommand.RegisterMbMissionListFunction InfMission.GetMbMissionListParameterTable")
  --    --TppUiCommand.RegisterMbMissionListFunction("InfMission","GetMbMissionListParameterTable")
  --    end
  --  end

  --tex TODO figure out zone system,
  local missionInfo=this.missionInfo[vars.missionCode]
  if missionInfo then
    --tex KLUDGE: this was originally when I was thrashing out the mission addons and messing with OMBS and mgo maps just to kill the out of bounds system,
    --but now it's kind of stuck since those are still being passed around.
    --So now you have to manually add the flag to the mission addon module so it 'enables' it,
    --when really it's just not-disabling it.
    if not missionInfo.enableOOB then
      --tex in tppmission.init
      mvars.mis_isAlertOutOfMissionArea=false

      --tex in tppui init
      TppUiCommand.HideInnerZone()
      TppUiCommand.HideOuterZone()
    end
  end
end--Init

function this.OnRestoreSvars()
  --tex sortie mvars per mission - see heli_common_sequence OnRestoreSvars
  for missionCode,missionInfo in pairs(this.missionInfo)do
    if missionInfo.heliSpaceFlags then--tex alway a question when choosing a name whether to make it friendly for user (sortiePrepFlags or somthin), or to use naming from existing code, missionInfo in general uses code derived naming
      InfTppUtil.SetHeliSpaceFlags(missionInfo.heliSpaceFlags,missionCode)
    end--if heliSpaceFlags
  end--for missionInfo
end

function this.LoadMissionManual(missionCode)
  local loadDirect=false--DEBUGNOW

  --TppMission.Load( tonumber(settingStr), vars.missionCode, { showLoadingTips = false } )
  --TppMission.RequestLoad(tonumber(settingStr),vars.missionCode,{force=true,showLoadingTips=true})--,ignoreMtbsLoadLocationForce=mvars.mis_ignoreMtbsLoadLocationForce})
  --TppMission.RequestLoad(10036,vars.missionCode,{force=true,showLoadingTips=true})--,ignoreMtbsLoadLocationForce=mvars.mis_ignoreMtbsLoadLocationForce})
  if loadDirect then
    gvars.mis_nextMissionCodeForMissionClear=missionCode
    mvars.mis_showLoadingTipsOnMissionFinalize=false
    --mvars.heli_missionStartRoute
    --mvars.mis_nextLayoutCode
    --mvars.mis_nextClusterId
    --mvars.mis_ignoreMtbsLoadLocationForce

    TppMission.ExecuteMissionFinalize()
  else
    TppMission.ReserveMissionClear{
      missionClearType=TppDefine.MISSION_CLEAR_TYPE.FROM_HELISPACE,
      nextMissionId=missionCode,
    }
  end
end

function this.GetMissionCodes()
  return {
    --LOC,TYPE,Notes
    --    "1",--INIT
    --    "5",--TITLE
    --storyMissions
    "10010",--CYPR
    "10020",
    "10030",
    "10036",
    "10043",
    "10033",
    "10040",
    "10041",
    "10044",
    "10052",
    "10054",
    "10050",
    "10070",
    "10080",
    "10086",
    "10082",
    "10090",
    "10195",
    "10091",
    "10100",
    "10110",
    "10121",
    "10115",
    "10120",
    "10085",
    "10200",
    "10211",
    "10081",
    "10130",
    "10140",
    "10150",
    "10151",
    "10045",
    "10156",
    "10093",
    "10171",
    "10240",
    "10260",
    "10280",--CYPR
    --hard missions
    "11043",
    "11041",--missingno
    "11054",
    "11085",--missingno
    "11082",
    "11090",
    "11036",--missingno
    "11033",
    "11050",
    "11091",--missingno
    "11195",--missingno
    "11211",--missingno
    "11140",
    "11200",--missingno
    "11080",
    "11171",--missingno
    "11121",
    "11115",--missingno
    "11130",
    "11044",
    "11052",--missingno
    "11151",
    --
    --"10230",--FLYK,missing completely, chap 3, no load
    --in PLAY_DEMO_END_MISSION, no other refs
    --    "11070",
    --    "11100",
    --    "11110",
    --    "11150",
    --    "11240",
    --    "11260",
    --    "11280",
    --    "11230",
    --free mission
    "30010",--AFGH,FREE
    "30020",--MAFR,FREE
    "30050",--MTBS,FREE
    "30150",--MTBS,MTBS_ZOO,FREE
    "30250",--MBQF,MBTS_WARD,FREE
    --heli space
    "40010",--AFGH,AFGH_HELI,HLSP
    "40020",--MAFR,MAFR_HELI,HLSP
    "40050",--MTBS
  --"40060",--HLSP,HELI_SPACE,--no load
  --online
  --"50050",--MTBS,FOB
  --select??
  --"60000",--SELECT --6e4
  --show demonstrations (not demos lol)
  --    "65020",--AFGH,e3_2014
  --    "65030",--MTBS,e3_2014
  --    "65050",--MAFR??,e3_2014
  --    "65060",--MAFR,tgs_2014
  --    "65414",--gc_2014
  --    "65415",--tgs_2014
  --    "65416",--tgs_2014
  }
end

--tex OVERRIDE InfMission.GetCurrentLocationHeliMissionAndLocationCode
--given missioncode and support for addons
function this.GetHelispaceForMission(missionCode)
  missionCode=missionCode or vars.missionCode

  local helispace=this.helispaceForMission[missionCode]
  if helispace then
    InfCore.Log("InfMission.GetHelispaceForMission: found helispace "..helispace.." for mission "..missionCode)
  else
    local locationCode=InfMission.locationForMission[missionCode]
    helispace=this.helispaceForLocation[locationCode]
    if helispace then
      InfCore.Log("InfHeliSpace.GetHelispaceForMission: found helispace "..helispace.." for location "..locationCode)
    end
  end

  if helispace then
    local helispaceLocation=InfMission.locationForMission[helispace]
    return helispace,helispaceLocation
  end

  InfCore.Log("WARNING: InfHeliSpace.GetHelispaceForMission: could not find helispace for mission "..missionCode)
  return TppDefine.SYS_MISSION_ID.AFGH_HELI,TppDefine.LOCATION_ID.AFGH
end--GetHelispaceForMission

--tex HOOK OVERRIDE: this is kjp records server stuff, so bypassing this for non vanilla missionCodes
--even though it's likely to just return RankingBordId.NONE for any non vanilla missions anyway, might as well be (beleatedly) thorough
--SYNC TppRanking.RegistMissionClearRankingResult
function this.RegistMissionClearRankingResult(usedRankLimitedItem,missionCode,totalScore)
  --tex>
  if this.vanillaMissions[missionCode] then
    return
  end
  --<
  local missionBoardId
  if usedRankLimitedItem then
    missionBoardId=RecordRanking.GetMissionLimitBordId(missionCode)
  else
    missionBoardId=RecordRanking.GetMissionBordId(missionCode)
  end
  if missionBoardId==RankingBordId.NONE then
    return
  end
  mvars.rnk_missionClearRankingResult={missionBoardId,totalScore}
end
TppRanking.RegistMissionClearRankingResult=this.RegistMissionClearRankingResult--tex doing it here rather than in TppRanking since TppRanking has no other edits/I'm not adding it at this late stage till I see if any other mods use it


return this
