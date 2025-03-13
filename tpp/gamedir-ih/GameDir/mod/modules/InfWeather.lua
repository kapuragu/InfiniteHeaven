-- InfWeather.lua
-- weather and sky param ivars
-- as well as weather support for location addons
local this={}

--tex hooking TppWeather for the moment since there's other mods out for it

--tex added to by location addon
--keyed by uppercase locationName
this.weatherProbabilitiesTable={}
this.extraWeatherProbabilitiesTable={
  NONE={},
}

function this.PostModuleReload(prevModule)
  this.weatherProbabilitiesTable=prevModule.weatherProbabilitiesTable
  this.extraWeatherProbabilitiesTable=prevModule.extraWeatherProbabilitiesTable
end

local TppWeather_SetDefaultWeatherProbabilities=TppWeather.SetDefaultWeatherProbabilities
function this.SetDefaultWeatherProbabilities()
  InfCore.LogFlow"InfWeather.SetDefaultWeatherProbabilities"
  local locationName=TppLocation.GetLocationName()
  locationName=string.upper(locationName) 
  --DEBUGNOW and per mission too?
  local weatherProbabilities=this.weatherProbabilitiesTable[locationName]
  --tex fall back to vanilla weather
  if weatherProbabilities==nil then
    TppWeather_SetDefaultWeatherProbabilities()
    return
  end
  
  local heliSuffix=""
  if TppMission.IsHelicopterSpace(vars.missionCode) then
    heliSuffix="_HELI"
  end
  local extraWeatherProbabilities=this.extraWeatherProbabilitiesTable[locationName..heliSuffix] or this.extraWeatherProbabilitiesTable.NONE
  
  if weatherProbabilities then
    WeatherManager.SetNewWeatherProbabilities("default",weatherProbabilities)
  end
  if extraWeatherProbabilities then
    WeatherManager.SetExtraWeatherProbabilities(extraWeatherProbabilities)
  end
  
  if this.debugModule then
    InfCore.PrintInspect(weatherProbabilities,locationName.." weatherProbabilities")
    InfCore.PrintInspect(weatherProbabilities,locationName.." extraWeatherProbabilities")
  end
end--SetDefaultWeatherProbabilities
TppWeather.SetDefaultWeatherProbabilities=this.SetDefaultWeatherProbabilities--HOOK OVERRIDE

--CALLER: InfMission.AddInLocations
--GOTCHA: no checks to see if it tramples an previously added entry
function this.AddWeatherProbabilities(locationName,locationInfo)
  this.weatherProbabilitiesTable[locationName]=locationInfo.weatherProbabilities
  this.extraWeatherProbabilitiesTable[locationName]=locationInfo.extraWeatherProbabilities
end--AddWeatherProbabilities
--<

--REF TppDefine.WEATHER={SUNNY=0,CLOUDY=1,RAINY=2,SANDSTORM=3,FOGGY=4,POURING=5}

local fogTypeToWeatherFogType={--DEBUGNOW TODO its probably the exact same value as the enum anyway
  WeatherManager.FOG_TYPE_NORMAL,
  WeatherManager.FOG_TYPE_PARASITE,
  WeatherManager.FOG_TYPE_EERIE,
}

local function OnChangeWeather()
  TppWeather.CancelForceRequestWeather()

  local weatherType=Ivars.weather_forceType:Get()-1
  if weatherType>=0 then
    local interpTime=1
    local fogParam=nil
    if weatherType==TppDefine.WEATHER.FOGGY then
      local fogDensity=Ivars.weather_fogDensity:Get()
      local fogType=Ivars.weather_fogType:Get()--DEBUG
      --InfCore.PrintInspect(fogType,"fogType")--DEBUG
      fogType=fogTypeToWeatherFogType[fogType+1]
      --InfCore.PrintInspect(fogType,"weatherfogType")--DEBUG

      fogParam={fogDensity=fogDensity,fogType=fogType,}
    end
    TppWeather.ForceRequestWeather(weatherType,interpTime,fogParam)
  end
end
--tex pulled from twpf files
--vanilla twpf files have mostly the same entries, see the comments on specific entries
this.weatherTags={
  'default',
  'indoor',
  'indoor_noSkySpe',
  'indoor_noSkySpe_RLR',
  'indoor_RLR',
  'indoor_RLR_paz',
  'fort_shadow_inside',
  'foggy_20',
  'qntnFacility',
  'pitchDark',
  'avatar_space',
  'sortie_space',
  'sortie_space_ShadowShort',
  'sortie_space_heli',--not in cypr twpf
  'citadel_indoor',
  'soviet_hanger',
  'soviet_hanger2',
  'Sahelan_fog',
  'Sahelan_RedFog',
  'factory_fog',
  'factory_fog_indoor',
  'VolginRide',
  'mafr_forest',
  'uq0040_p31_030020',
  'heli_space',
  'tunnel',
  'diamond_tunnel',
  'fort_shadow_outside',
  'ruins_shadow',
  'slopedTown_shadow',
  'shadow_middle',
  'shadow_long',
  'citadel_color_shadowMiddle',
  'citadel_color_shadowLong',
  'temp_CaptureLongShadow',
  'citadel_redDoor',
  'factory_Volgin_shadow_middle',
  'factory_Volgin_shadow_long',
  'bridge_shadow',
  'cypr_day',
  'cypr_title',
  'kypr_indoor',
  'group_photo',
  'edit',
  'probe_check',
  'exposureAdd_1',
  'citadel_color',
  'exposureSub_1',
  'bloomAdd_1',
  'cypr_Night_RLR',
  'cypr_Night_RLR2',
  'edit_1',--cypr twpf only
  'citadel_color2',
  'edit_2',--cypr twpf only
  'kypr_drizzle',
}--weatherTags

this.registerIvars={
  "weather_forceType",
  "weather_fogDensity",
  "weather_fogType",
  "weather_requestTag",
  "weather_requestTagInterpTime",
  "weather_skyParameterAddOffsetY",
  "weather_skyParameterSetSkyScale",
  "weather_skyParameterSetScrollSpeedRate",
}

this.weather_forceType={
  inMission=true,
  --OFF save=IvarProc.CATEGORY_EXTERNAL,
  settings={"NONE","SUNNY","CLOUDY","RAINY","SANDSTORM","FOGGY"},
  OnChange=OnChangeWeather,
}

this.weather_fogDensity={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=1.0,increment=0.01},
  default=0.1,
  OnChange=OnChangeWeather,
}

this.weather_fogType={
  save=IvarProc.CATEGORY_EXTERNAL,
  settings={"NORMAL","PARASITE","EERIE"},--tex I cant tell difference between EERIE and NORMAL
  OnChange=OnChangeWeather,
}

this.weather_requestTag={
  settings=this.weatherTags,
  OnActivate=function(self,setting)
    local weatherTag=self.settings[setting+1]
    local interpTime=0--vanilla uses 0,1,3,5,7,8,40
    interpTime=ivars.weather_requestTagInterpTime
    WeatherManager.RequestTag(weatherTag,interpTime)
  end,
}--weather_requestTag

this.weather_requestTagInterpTime={--texdont actually know the units, seems to be longer than seconds
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=100,},
}

this.SetSkyParameters=function()
  TppEffectWeatherParameterMediator.SetParameters{
    addTppSkyOffsetY=ivars.weather_skyParameterAddOffsetY,
    setTppSkyScale=ivars.weather_skyParameterSetSkyScale,
    setTppSkyScrollSpeedRate=ivars.weather_skyParameterSetScrollSpeedRate,
  }
end--SetSkyParameters

this.RestoreDefaultSkyParameters=function()
  TppEffectWeatherParameterMediator.RestoreDefaultParameters()
end
--REF helispace addTppSkyOffsetY=1320
this.weather_skyParameterAddOffsetY={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=-1000,max=1000,increment=1},
  noBounds=true,
  OnChange=this.SetSkyParameters,
}
--REF helispace setTppSkyScale=.1
this.weather_skyParameterSetSkyScale={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=0,max=100,increment=0.1},
  OnChange=this.SetSkyParameters,
}
--REF helispace setTppSkyScrollSpeedRate=-20
this.weather_skyParameterSetScrollSpeedRate={
  save=IvarProc.CATEGORY_EXTERNAL,
  range={min=-100000,max=100000,},
  OnChange=this.SetSkyParameters,
}


this.registerMenus={
  "weatherMenu",
}
this.weatherMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu","InfMenuDefs.inDemoMenu"},
  options={
    "InfWeather.weather_forceType",
    "InfWeather.weather_fogDensity",
    "InfWeather.weather_fogType",
    "InfWeather.weather_requestTag",
    "InfWeather.weather_requestTagInterpTime",
    "InfWeather.SetSkyParameters",
    "InfWeather.RestoreDefaultSkyParameters",
    "InfWeather.weather_skyParameterSetSkyScale",
    "InfWeather.weather_skyParameterAddOffsetY",
    "InfWeather.weather_skyParameterSetScrollSpeedRate",
  }
}--weatherMenu
--< menu defs
this.langStrings={
  eng={
    weatherMenu="Weather menu",
    weather_forceType="Force weather",
    weather_fogDensity="Fog density",
    weather_fogType="Fog type",
    weather_requestTag="RequestTag",
    weather_requestTagInterpTime="RequestTag interp time",
    setSkyParameters="Apply Sky Parameters",
    restoreDefaultSkyParameters="Unapply Sky Parameters",
    weather_skyParameterSetSkyScale="Upper clouds scale",
    weather_skyParameterAddOffsetY="Horizon clouds height",
    weather_skyParameterSetScrollSpeedRate="Horizon clouds speed",
  },
  help={
    eng={
      weather_requestTag="A collection of sky, lighting settings bundled under a 'tag' name in the locations weatherParameters file. Only applies when you press activate (not persitant over sessions). Game may reset or change it at different points.",
      weather_requestTagInterpTime="Interpolation time between the prior tag and the one requested.",
      restoreDefaultSkyParameters="Stops the IH sky parameters from being applied.",
      weather_skyParameterSetSkyScale="Scale of main clouds overhead",
      weather_skyParameterAddOffsetY="Height of horizon clouds",
      weather_skyParameterSetScrollSpeedRate="Scrolling speed of horizon clouds",
    },
  }
}--langStrings
--<

return this
