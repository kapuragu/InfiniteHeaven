--AFC0.lua
--location addon locationInfo reference of all parameters rather than a sane example
--see InfMission for implementation of system and other notes
--most of the ALL_CAPS, or other code looking reference in the comment after an entry below is a reference to the base game data structure the option is adding to.
--you can look up those references in the base game lua (Infinite Heaven github repo has all of them with further notes) to get more idea what they do 

local this={
 description="Jade Forest",--just for IH
 --unique identifier for location, in theory this doesnt have to be just 4 characters (VERIFY)
 locationName="AFC0",
 --currently should be unique across all community locations, in the future this may be ignored if I can build a system that uses the locationName instead
  --see (and add to) https://mgsvmoddingwiki.github.io/Custom_Missions_List/ to avoid conflicts
  locationId=101,
  packs={"/Assets/mgo/pack/location/afc0/afc0.fpk"},-- TppMissionList.locationPackTable entry RENAMED was: packs
  locationMapParams={-- \Assets\tpp\pack\mbdvc\mb_dvc_top.fpkd \ mbdvc_map_location_parameter.lua entry
    stageSize=556*1,
    scrollMaxLeftUpPosition=Vector3(-255,0,-275),
    scrollMaxRightDownPosition=Vector3(255,0,275),
    highZoomScale=2,
    middleZoomScale=1,
    lowZoomScale=.5,
    locationNameLangId="mgo_idt_Jungle",
    stageRotate=0,
    heightMapTexturePath="/Assets/mgo/ui/texture/map/afc0/afc0_iDroid_clp.ftex",
    photoRealMapTexturePath="/Assets/mgo/ui/texture/map/afc0/afc0_jungle_sat_clp.ftex"
  },
  globalLocationMapParams={ --  see \Assets\tpp\pack\mbdvc\mb_dvc_top.fpkd \ mbdvc_map_location_parameter.lua GetGlobalLocationParameter
    sectionFuncRankForDustBox = 4,
    sectionFuncRankForToilet  = 4,
    sectionFuncRankForCrack   = 6,
    isSpySearchEnable = true,
    isHerbSearchEnable = true,--tex IH will automatically patch in support for disableHerbSearch

    spySearchRadiusMeter = {  40.0, 40.0, 35.0, 30.0, 25.0, 20.0, 15.0, 10.0, },
    spySearchIntervalSec = {  420.0,  420.0,  360.0,  300.0,  240.0,  180.0,  120.0,  60.0, },
    herbSearchRadiusMeter = { 0.0,  0.0,  10.0, 15.0, 20.0, 25.0, 30.0, 35.0, },
  },
  questAreas={--tex defines quest areas for location, see TppQuestList.questList .
    {
      areaName="tent",
      --xMin,yMin,xMax,yMax, in smallblock coords. see Tpp.CheckBlockArea. debug menu ShowPosition will log GetCurrentStageSmallBlockIndex, or you can use whatever block visualisation in unity you have
      loadArea={116,134,131,152},--load is the larger area, so -1 minx, -1miny, +1maxx,+1maxy vs active
      activeArea={117,135,130,151},
      invokeArea={117,135,130,151},--same size as active, but keeping here to stay same implementation as vanilla
    },
  },
  requestTppBuddy2BlockController=true,--tex not sure, see TppLocation.SetBuddyBlock and its caller TppMissionList.GetLocationPackagePath
  weatherProbabilities={-- see TppWeather.weatherProbabilitiesTable
    {TppDefine.WEATHER.SUNNY,80},
    {TppDefine.WEATHER.CLOUDY,20}
  },
  extraWeatherProbabilities={-- see TppWeather.extraWeatherProbabilitiesTable
    {TppDefine.WEATHER.RAINY,50},
    {TppDefine.WEATHER.FOGGY,50}
  },
  heliSpace=40020,--heliSpace for location, will be overidden by any missionInfo heliSpace setting (see missionInfo heliSpace for more notes)
}--this

return this