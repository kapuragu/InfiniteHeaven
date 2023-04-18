-- InfSoldierParams.lua
-- DEPS: gvars, TppSoldier2, Tpp
-- See Assets\tpp\level_asset\chara\enemy\Soldier2ParameterTables
local this={}

local IsTable=Tpp.IsTypeTable

this.registerIvars={
  "soldierParamsProfile",
  "soldierSightDistScale",
  "soldierNightSightDistScale",
  "soldierHearingDistScale",
  "soldierHealthScale",
}

local EXTERNAL=IvarProc.CATEGORY_EXTERNAL
--parameters
--tex TODO: change over name to something more accurate next time you do a change that would require the user to update their settings anyway
this.soldierParamsProfile={
  save=EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
}

--enemy parameters sight
this.sightScaleRange={max=400,min=0,increment=5}
local function OnChangeEnemyParam(self,setting)
  if Ivars.soldierParamsProfile:Is(0) then
    Ivars.soldierParamsProfile:Set(1)
  end
end

this.soldierSightDistScale={
  save=EXTERNAL,
  default=100,
  range=this.sightScaleRange,
  isPercent=true,
--OnChange=OnChangeEnemyParam,
}

this.soldierNightSightDistScale={
  save=EXTERNAL,
  default=100,
  range=this.sightScaleRange,
  isPercent=true,
--OnChange=OnChangeEnemyParam,
}

this.soldierHearingDistScale={
  save=EXTERNAL,
  default=100,
  range={max=400,min=0,increment=5},
  isPercent=true,
--OnChange=OnChangeEnemyParam,
}


--this.sightForms={
--  "contactSightForm",
--  "normalSightForm",
--  "farSightForm",
--  "searchLightSightForm",
--  "observeSightForm",
--}
--
--this.sightTypeNames={
--  "baseSight",
--  "nightSight",
--  "combatSight",
--  "walkerGearSight",
--  "observeSight",
--  "snipingSight",
--  "searchLightSight",
--  "armoredVehicleSight",
--  "zombieSight",
--  "msfSight",
--  "vehicleSight",
--}
--
--this.sightFormNames={
--  "discovery",
--  "indis",
--  "dim",
--  "far",
--  "observe",
--}
--
--this.sightIvarLists={
--  "sightForms",
--  "sightTypeNames",
--  "sightFormNames",
--}
--
--this.sightDistScaleName="DistScaleSightParam"
--for n,listName in ipairs(this.sightIvarLists) do
--  for i,name in ipairs(this[listName]) do
--    local ivarName=name..this.sightDistScaleName
--    local ivar={
--      save=EXTERNAL,
--      default=1,
--      range=this.sightScaleRange,
--    }
--    this[ivarName]=ivar
--  end
--end
--
this.soldierHealthScale={
  save=EXTERNAL,
  default=100,
  range={max=900,min=0,increment=20},
  isPercent=true,
}
--< ivar defs
this.registerMenus={
  "soldierParamsMenu",
}

this.soldierParamsMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.soldierParamsProfile",
    "Ivars.soldierHealthScale",
    "Ivars.soldierSightDistScale",
    "Ivars.soldierNightSightDistScale",
    "Ivars.soldierHearingDistScale",
    "Ivars.itemDropChance",
    "InfMenuCommandsTpp.PrintHealthTableParameter",
    "InfMenuCommandsTpp.PrintSightFormParameter",
    "InfMenuCommandsTpp.PrintHearingTable",
  }
}
--< menu defs
this.langStrings={
  eng={
    soldierParamsMenu="Soldier parameters menu",
    soldierParamsProfile="Enable soldier parameter settings",
    soldierHealthScale="Soldier life scale",
    soldierSightDistScale="Soldier sight scale",
    soldierNightSightDistScale="Soldier night sight scale",
    printSightFormParameter="Print sight param table (look in iDroid Log>All tab)",
    printHealthTableParameter="Print health param table (look in iDroid Log>All tab)",
    soldierHearingDistScale="Soldier hearing distance scale",
    printHearingTable="Print hearing distance table (look in iDroid Log>All tab)",
  },
  help={
    eng={
      soldierParamsProfile=[[Turn this on to enable the life, sight and hearing enemy param options, turn this off if you have another mod that modifies Soldier2ParameterTables.lua (ie Hardcore mod).",
      "Any of the following option only apply on map load or checkpoint restart.]],
      soldierHealthScale="0% will kill off all enemies",
      soldierSightDistScale="A rough scale over all the soldier sight distances, except for night sight distance, use the command 'Print sight param table (look in iDroid Log>All tab)' to see exact values.",
    },
  }
}
--< langstrings

--tex so rather than tweak parameters manually my enemy param options scale,
--this.soldierParameters is the table actually manipulated, pulling soldierParametersDefaults when it does the change\scale operation
--at some point a modded table needs to be reloaded via TppSoldier2.ReloadSoldier2ParameterTables
--DOC: Enemy solider paramters.txt

--tex in sightFormParameter
--local sandstormSightDefault={distanceRate=.6,angleRate=.8}
--local rainSightDefault={distanceRate=1,angleRate=1}
--local cloudySightDefault={distanceRate=1,angleRate=1}
--local foggySightDefault={distanceRate=.5,angleRate=.6}
--tex BALANCE: being conservative, could be more agressive if coupled with a bump in the sight dist it modifies, but I like the retail settings in general
--local sandstormSightImproved={distanceRate=.6,angleRate=.8}
--local rainSightImproved={distanceRate=.9,angleRate=0.95}
--local cloudySightImproved={distanceRate=0.95,angleRate=1}
--local foggySightImproved={distanceRate=.5,angleRate=.6}

this.lifeParameterTableDefaults={maxLife=2600,maxStamina=3e3,maxLimbLife=1500,maxArmorLife=7500,maxHelmetLife=500,sleepRecoverSec=300,faintRecoverSec=50,dyingSec=60}
this.lifeParameterTable={maxLife=2600,maxStamina=3e3,maxLimbLife=1500,maxArmorLife=7500,maxHelmetLife=500,sleepRecoverSec=300,faintRecoverSec=50,dyingSec=60}--tex modified in-place by enemy health scale
this.soldierParametersDefaults={--tex  SYNC: soldierParametersMod. actually using my slight tweaks rather than true default
  sightFormParameter={
    contactSightForm={distance=2,verticalAngle=160,horizontalAngle=130},
    normalSightForm={distance=60,verticalAngle=60,horizontalAngle=100},
    farSightForm={distance=90,verticalAngle=30,horizontalAngle=30},
    searchLightSightForm={distance=50,verticalAngle=15,horizontalAngle=15},
    observeSightForm={distance=200,verticalAngle=5,horizontalAngle=5},
    baseSight={
      discovery={distance=10,verticalAngle=36,horizontalAngle=48},
      indis={distance=20,verticalAngle=60,horizontalAngle=80},
      dim={distance=45,verticalAngle=60,horizontalAngle=80},
      far={distance=70,verticalAngle=12,horizontalAngle=8}
    },
    nightSight={
      discovery={distance=10,verticalAngle=30,horizontalAngle=40},
      indis={distance=15,verticalAngle=60,horizontalAngle=60},
      dim={distance=35,verticalAngle=60,horizontalAngle=60},
      far={distance=0,verticalAngle=0,horizontalAngle=0}
    },
    combatSight={
      discovery={distance=10,verticalAngle=36,horizontalAngle=60},
      indis={distance=25,verticalAngle=60,horizontalAngle=100},
      dim={distance=50,verticalAngle=60,horizontalAngle=100},
      far={distance=70,verticalAngle=30,horizontalAngle=30}
    },
    walkerGearSight={
      discovery={distance=15,verticalAngle=36,horizontalAngle=60},
      indis={distance=25,verticalAngle=60,horizontalAngle=100},
      dim={distance=55,verticalAngle=60,horizontalAngle=100},
      far={distance=85,verticalAngle=30,horizontalAngle=30}
    },
    observeSight={
      discovery={distance=10,verticalAngle=36,horizontalAngle=48},
      indis={distance=70,verticalAngle=12,horizontalAngle=8},
      dim={distance=45,verticalAngle=5,horizontalAngle=5},
      far={distance=70,verticalAngle=5,horizontalAngle=5},
      observe={distance=200,verticalAngle=5,horizontalAngle=5}
    },
    snipingSight={
      discovery={distance=10,verticalAngle=36,horizontalAngle=48},
      indis={distance=70,verticalAngle=12,horizontalAngle=8},
      dim={distance=45,verticalAngle=5,horizontalAngle=5},
      far={distance=70,verticalAngle=5,horizontalAngle=5},
      observe={distance=200,verticalAngle=5,horizontalAngle=5}
    },
    searchLightSight={
      discovery={distance=30,verticalAngle=8,horizontalAngle=8},
      indis={distance=0,verticalAngle=0,horizontalAngle=0},
      dim={distance=50,verticalAngle=12,horizontalAngle=12},
      far={distance=0,verticalAngle=0,horizontalAngle=0}
    },
    armoredVehicleSight={
      discovery={distance=20,verticalAngle=36,horizontalAngle=60},
      indis={distance=25,verticalAngle=60,horizontalAngle=100},
      dim={distance=55,verticalAngle=60,horizontalAngle=100},
      far={distance=85,verticalAngle=30,horizontalAngle=30},
      observe={distance=120,verticalAngle=5,horizontalAngle=5}
    },
    zombieSight={
      discovery={distance=7,verticalAngle=36,horizontalAngle=48},
      indis={distance=14,verticalAngle=60,horizontalAngle=80},
      dim={distance=31.5,verticalAngle=60,horizontalAngle=80},
      far={distance=0,verticalAngle=12,horizontalAngle=8}
    },
    msfSight={
      discovery={distance=10,verticalAngle=36,horizontalAngle=48},
      indis={distance=20,verticalAngle=60,horizontalAngle=80},
      dim={distance=45,verticalAngle=60,horizontalAngle=80},
      far={distance=70,verticalAngle=12,horizontalAngle=8}
    },
    vehicleSight={
      discovery={distance=15,verticalAngle=36,horizontalAngle=48},
      indis={distance=25,verticalAngle=60,horizontalAngle=80},
      dim={distance=45,verticalAngle=60,horizontalAngle=80},
      far={distance=70,verticalAngle=12,horizontalAngle=8}
    },
    sandstormSight={distanceRate=.6,angleRate=.8},
    rainSight={distanceRate=1,angleRate=1},
    cloudySight={distanceRate=1,angleRate=1},
    foggySight={distanceRate=.5,angleRate=.6}
  },
  sightCamouflageParameter={
    discovery={enemy=530,character=530,object=530},
    indis={enemy=80,character=210,object=270},
    dim={enemy=-50,character=30,object=130},
    far={enemy=-310,character=0,object=70},
    bushDensityThresold=100
  },
  hearingRangeParameter={
    normal={zero=0,ss=4.5,hs=5.5,s=9,m=15,l=30,hll=60,ll=160,alert=160,special=500},
    sandstorm={zero=0,ss=0,hs=0,s=0,m=15,l=30,hll=60,ll=160,alert=160,special=500},
    rain={zero=0,ss=0,hs=0,s=4.5,m=15,l=30,hll=60,ll=160,alert=160,special=500}
  },
  lifeParameterTable={maxLife=2600,maxStamina=3e3,maxLimbLife=1500,maxArmorLife=7500,maxHelmetLife=500,sleepRecoverSec=300,faintRecoverSec=50,dyingSec=60},
  zombieParameterTable={highHeroicValue=1e3}
}

this.soldierParameters={--tex SYNC: soldierParametersDefault. Ugly, but don't want to blow out the stack by doing table copies at runtime
  sightFormParameter={
    contactSightForm={distance=2,verticalAngle=160,horizontalAngle=130},
    normalSightForm={distance=60,verticalAngle=60,horizontalAngle=100},
    farSightForm={distance=90,verticalAngle=30,horizontalAngle=30},
    searchLightSightForm={distance=50,verticalAngle=15,horizontalAngle=15},
    observeSightForm={distance=200,verticalAngle=5,horizontalAngle=5},

    baseSight={
      discovery={distance=10,verticalAngle=36,horizontalAngle=48},
      indis={distance=20,verticalAngle=60,horizontalAngle=80},
      dim={distance=45,verticalAngle=60,horizontalAngle=80},
      far={distance=70,verticalAngle=12,horizontalAngle=8}
    },
    nightSight={
      discovery={distance=10,verticalAngle=30,horizontalAngle=40},
      indis={distance=15,verticalAngle=60,horizontalAngle=60},
      dim={distance=35,verticalAngle=60,horizontalAngle=60},
      far={distance=0,verticalAngle=0,horizontalAngle=0}
    },
    combatSight={
      discovery={distance=10,verticalAngle=36,horizontalAngle=60},
      indis={distance=25,verticalAngle=60,horizontalAngle=100},
      dim={distance=50,verticalAngle=60,horizontalAngle=100},
      far={distance=70,verticalAngle=30,horizontalAngle=30}
    },
    walkerGearSight={
      discovery={distance=15,verticalAngle=36,horizontalAngle=60},
      indis={distance=25,verticalAngle=60,horizontalAngle=100},
      dim={distance=55,verticalAngle=60,horizontalAngle=100},
      far={distance=85,verticalAngle=30,horizontalAngle=30}
    },
    observeSight={
      discovery={distance=10,verticalAngle=36,horizontalAngle=48},
      indis={distance=70,verticalAngle=12,horizontalAngle=8},
      dim={distance=45,verticalAngle=5,horizontalAngle=5},
      far={distance=70,verticalAngle=5,horizontalAngle=5},
      observe={distance=200,verticalAngle=5,horizontalAngle=5}
    },
    snipingSight={
      discovery={distance=10,verticalAngle=36,horizontalAngle=48},
      indis={distance=70,verticalAngle=12,horizontalAngle=8},
      dim={distance=45,verticalAngle=5,horizontalAngle=5},
      far={distance=70,verticalAngle=5,horizontalAngle=5},
      observe={distance=200,verticalAngle=5,horizontalAngle=5}
    },
    searchLightSight={
      discovery={distance=30,verticalAngle=8,horizontalAngle=8},
      indis={distance=0,verticalAngle=0,horizontalAngle=0},
      dim={distance=50,verticalAngle=12,horizontalAngle=12},
      far={distance=0,verticalAngle=0,horizontalAngle=0}
    },
    armoredVehicleSight={
      discovery={distance=20,verticalAngle=36,horizontalAngle=60},
      indis={distance=25,verticalAngle=60,horizontalAngle=100},
      dim={distance=55,verticalAngle=60,horizontalAngle=100},
      far={distance=85,verticalAngle=30,horizontalAngle=30},
      observe={distance=120,verticalAngle=5,horizontalAngle=5}
    },
    zombieSight={
      discovery={distance=7,verticalAngle=36,horizontalAngle=48},
      indis={distance=14,verticalAngle=60,horizontalAngle=80},
      dim={distance=31.5,verticalAngle=60,horizontalAngle=80},
      far={distance=0,verticalAngle=12,horizontalAngle=8}
    },
    msfSight={
      discovery={distance=10,verticalAngle=36,horizontalAngle=48},
      indis={distance=20,verticalAngle=60,horizontalAngle=80},
      dim={distance=45,verticalAngle=60,horizontalAngle=80},
      far={distance=70,verticalAngle=12,horizontalAngle=8}
    },
    vehicleSight={
      discovery={distance=15,verticalAngle=36,horizontalAngle=48},
      indis={distance=25,verticalAngle=60,horizontalAngle=80},
      dim={distance=45,verticalAngle=60,horizontalAngle=80},
      far={distance=70,verticalAngle=12,horizontalAngle=8}
    },
    sandstormSight={distanceRate=.6,angleRate=.8},
    rainSight={distanceRate=1,angleRate=1},
    cloudySight={distanceRate=1,angleRate=1},
    foggySight={distanceRate=.5,angleRate=.6}
  },
  sightCamouflageParameter={
    discovery={enemy=530,character=530,object=530},
    indis={enemy=80,character=210,object=270},
    dim={enemy=-50,character=30,object=130},
    far={enemy=-310,character=0,object=70},
    bushDensityThresold=100
  },
  hearingRangeParameter={
    normal={zero=0,ss=4.5,hs=5.5,s=9,m=15,l=30,hll=60,ll=160,alert=160,special=500},
    sandstorm={zero=0,ss=0,hs=0,s=0,m=15,l=30,hll=60,ll=160,alert=160,special=500},
    rain={zero=0,ss=0,hs=0,s=4.5,m=15,l=30,hll=60,ll=160,alert=160,special=500}
  },
  lifeParameterTable=this.lifeParameterTable,
  zombieParameterTable={highHeroicValue=1e3}
}

--end tables
--system
function this.OnAllocate(missionTable)
  this.SoldierParametersMod()
end

--IN: this.lifeParameterTableDefault, Ivars.soldierHealthScale
--OUT: this.soldierParameters
function this.ApplyHealthIvarsToSoldierParams()
  --tex REF: this.lifeParameterTableDefault={maxLife=2600,maxStamina=3e3,maxLimbLife=1500,maxArmorLife=7500,maxHelmetLife=500,sleepRecoverSec=300,faintRecoverSec=50,dyingSec=60}
  local healthScale=(Ivars.soldierHealthScale:Get()/100)--tex mod enemy health scale
  this.lifeParameterTable.maxLife        = this.lifeParameterTableDefaults.maxLife*healthScale
  this.lifeParameterTable.maxLimbLife    = this.lifeParameterTableDefaults.maxLimbLife*healthScale
  this.lifeParameterTable.maxArmorLife   = this.lifeParameterTableDefaults.maxArmorLife*healthScale
  this.lifeParameterTable.maxHelmetLife  = this.lifeParameterTableDefaults.maxHelmetLife*healthScale
end

--IN: this.soldierParametersDefault.sightFormParameter
--OUT: this.soldierParameters.sightFormParameter
function this.ApplySightIvarsToSoldierParams()
  local sightParamsMod=this.soldierParameters.sightFormParameter
  local sightParamsDefaults=this.soldierParametersDefaults.sightFormParameter

  for name,item in pairs(sightParamsMod) do
    if IsTable(item) and item.distance~=nil then
      local default=sightParamsDefaults[name].distance
      if default>0 then
        item.distance=default*(Ivars.soldierSightDistScale:Get()/100)
        --InfCore.DebugPrint(name..".distance="..item.distance)
      end
    else
      for childName,item in pairs(item) do
        if IsTable(item) and item.distance~=nil then
          local default=sightParamsDefaults[name][childName].distance
          if default>0 then
            if name=="nightSight" then
              item.distance=default*(Ivars.soldierNightSightDistScale:Get()/100)
            else
              item.distance=default*(Ivars.soldierSightDistScale:Get()/100)
            end
            --InfCore.DebugPrint(name.."."..childName..".distance="..item.distance)
          end
        end
      end
    end--if else
  end--for sightmod
end

function this.PrintSightForm()
  local toPrint=""
  local sightParamsMod=this.soldierParameters.sightFormParameter
  for name,item in pairs(sightParamsMod) do
    if IsTable(item) and item.distance~=nil then
      --InfCore.DebugPrint(name..".distance="..item.distance)
      toPrint=toPrint.."\n"..name..".distance="..item.distance
    else
      for childName,item in pairs(item) do
        if IsTable(item) and item.distance~=nil then
          --InfCore.DebugPrint(name.."."..childName..".distance="..item.distance)
          toPrint=toPrint.."\n"..name.."."..childName..".distance="..item.distance
        end
      end
    end--if else
  end--for sightmod
  InfCore.DebugPrint(toPrint)
end

--IN: this.soldierParametersDefault.sightFormParameter
--OUT: this.soldierParameters.sightFormParameter
function this.ApplyHearingIvarsToSoldierParams()
  local hearingParams=this.soldierParameters.hearingRangeParameter
  local hearingParamsDefault=this.soldierParametersDefaults.hearingRangeParameter

  for name,distanceTypes in pairs(hearingParams) do
    for distanceName,distance in pairs(distanceTypes)do
      local default=hearingParamsDefault[name][distanceName]
      if default>0 then
        distanceTypes[distanceName]=default*(Ivars.soldierHearingDistScale:Get()/100)
        --InfCore.DebugPrint(name..".distance="..item.distance)
      end
    end
  end--for sightmod
end


--function this.ScaleValueClamp1(value,mult)--tex
--  local newValue=value*mult
--  if newValue < 1 then
--    newValue = 1
--  end
--  return newValue
--end
--IN: this.soldierParametersDefault, *Ivars.<sightForm>DistScaleSightParam
--OUT: this.soldierParameters
--WIP: more granular control of sightFormParameters
--function this.ApplySightIvarsToSoldierParams()
--  local sightParamsMod=this.soldierParameters.sightFormParameter
--  local sightParamsDefaults=this.soldierParametersDefaults.sightFormParameter
--  local sightDistScaleName=Ivars.sightDistScaleName
--
--  for i,typeName in ipairs(Ivars.sightTypeNames) do
--    --InfCore.DebugPrint("typeName: "..typeName)--DEBUG
--    local sightType=sightParamsMod[typeName]
--    local sightTypeDefault=sightParamsDefaults[typeName]
--
--    if sightTypeDefault==nil then--DEBUG
--      InfCore.DebugPrint"sightTypeDefault==nil"
--    end
--
--    local gvarName=typeName..Ivars.sightDistScaleName
--    local typeScale=gvars[gvarName] or 1
--    if gvars[gvarName]==nil then
--      InfCore.DebugPrint("gvars."..gvarName.."==nil")
--    end
--
--    --[[if sightType then--
--        InfCore.PrintInspect(sightType)
--      end--]]
--
--    for j,formName in ipairs(Ivars.sightFormNames) do
--      --InfCore.DebugPrint("formName: "..formName)
--      local sightForm=sightType[formName]
--      if sightForm then
--
--        --InfCore.PrintInspect(sightForm)
--
--
--        local sightFormDefault=sightTypeDefault[formName]
--        if sightFormDefault==nil then--DEBUG
--          InfCore.DebugPrint"sightFormDefault==nil"
--        end
--        local gvarName=formName..sightDistScaleName
--
--        local formScale=gvars[gvarName] or 1
--        if gvars[gvarName]==nil then
--          InfCore.DebugPrint("gvars."..gvarName.."==nil")
--        end
--
--        sightForm.distance=this.ScaleValueClamp1(sightFormDefault.distance,formScale)
--        sightForm.distance=this.ScaleValueClamp1(sightFormDefault.distance,typeScale)
--
--        --InfCore.DebugPrint(typeName.."."..formName.." dist=".. sightForm.distance.. " defdist="..sightFormDefault.distance .. " scale="..scale)
--
--        --sightType[formName].distance=this.ScaleValueClamp1(sightFormDefault.distance,scale)
--         --InfCore.DebugPrint(formName..".distance="..sightForm.distance)
--      end--if sightForm
--    end--for sightFormNames
--  end--for sightTypeNames
--end

--OUT: this.soldierPrameters, TppSoldier2 Soldier2ParameterTables
local function NotDefault(ivars)
  for i=1,#ivars do
    local ivar=ivars[i]
    if ivars[ivar.name]~=ivar.default then
      return true
    end
  end
end

function this.SoldierParametersMod()
  if InfMain.IsOnlineMission(vars.missionCode)then
    --tex TODO: wouldn't catch if tables had been reloaded with modded values, then ivars were reset and player went to FOB
    if NotDefault{Ivars.soldierHealthScale,Ivars.soldierSightDistScale,Ivars.soldierHearingDistScale} then
      TppSoldier2.ReloadSoldier2ParameterTables(this.soldierParametersDefaults)
    end
    return
  end

  if Ivars.soldierParamsProfile:Is(0) then
    return
  end
  this.ApplyHealthIvarsToSoldierParams()
  this.ApplySightIvarsToSoldierParams()
  this.ApplyHearingIvarsToSoldierParams()
  InfCore.LogFlow"InfSoldierParams.SoldierParametersMod ReloadSoldier2ParameterTables"
  TppSoldier2.ReloadSoldier2ParameterTables(this.soldierParameters)
end

return this
