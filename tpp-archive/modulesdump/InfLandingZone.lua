-- DOBUILD: 0
local this={}
--tex SYS: landing zone waveoff WIP
this.disablePeriodMin = 22 --tex game hours, want in minutes?
this.disablePeriodMax = 26
this.cooloffPeriodMin = 10
this.cooloffPeriodMax = 14
this.numWavedOff = 0
this.disablePercent = 0
this.lzWaveOffTimes={--tex indexed by lz name
  }
this.lzWavedOff={--tex lzWavedOff[lzName]=bool
  }

function this.UpdateWaveOff()
--  --tex TODO: schedule reenables via timer system instead of polling
--  local lzsForMission = this.lzsForMission[vars.missionCode];
--  if lzsForMission == nil then
--    return
--  end
--   if #lzsForMission == 1 then 
--    return
--   end
--   this.disablePercent = 5--tex TODO: calc to num lzs, TODO: calc when setting changed?
--  for n, lz in this.lzWaveOffTimes do
--    if time????????? - this.lzWaveOffTimes[lz].disabledTime  > math.random(this.disablePeriodMin, this.disablePeriodMax)
--      WaveOffEnable(lz)
--    end
--  end
--
--  
--
--  --tex TODO: instead of polling, schedule another disable via timer system each time a lz is reenabled? (some point after cooldown)
--  --tex still would have to handle init though -> this.OnMissionCanStart()? also probably earlier, on helispace init
--  --tex also saving??
--
--  if this.numWavedOff < this.disablePercent then
--    local chosing=0
--    local i = math.random(1,#this.lzWaveOffTimes)
--    while chosing < #lzWaveOffTimes do
--      local lzName = ??????
--      if not this.lzWavedOff[lzName] then
--        if time????? - this.lzWaveOffTimes[lz].disabledTime > math.random(this.cooloffPeriodMin, this.cooloffPeriodMax) then
--          this.WaveOffDisable(lz)
--        end
--      end
--      i=i+1
--      if i >= #lzWaveOffTimes then
--        i = 1
--      end 
--      chosing=chosing+1
--    end
--  end
end
function this.WaveOffDisable(lzName)
--  if this.lzWavedOff[lzName] then
--    return
--  end
--
--give message - if lz in same theater, or if in helispace
--  this.numWavedOff = this.numWavedOff + 1
--  this.lzWaveOffTimes[lzName].disabledTime = now 
--  this.lzWavedOff[lzName]=false
--  TppLandingZone.DisableLandingZone -=actually dsiable
end
function this.WaveOffEnable(lzName)
--  if not this.lzWavedOff[lzName] then
--    return
--  end
--  give message -  - if lz in same theater
--  this.numWavedOff = numWavedOff - 1
--  this.lzWaveOffTimes[lzName].disabledTime = now --tex doubles as a cooldown timer
--  this.lzWavedOff[lzName]=true
--  TppHelicopter.SeEnableLandingZone
end
------------
lzsForMission={--tex built from /Assets/tpp/ui/Script/mbdvc_map_mission_parameter.lua, intial 'drop' lzs, other lzs in game are called 'assault' lzs??
  --[0]={},
  --[10010]={},
  --[10020]={},
  --[10030]={},
  [10033]={
    "lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000",
    "lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000",
    "lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000",
  },
  [10036]={
    "lz_drp_field_I0000|rt_drp_field_I_0000",
    "lz_drp_field_N0000|rt_drp_field_N_0000",
    "lz_drp_field_W0000|rt_drp_field_W_0000",
  },
  [10040]={
    "lz_drp_fort_I0000|rt_drp_fort_I_0000",
    "lz_drp_slopedTownEast_E0000|rt_drp_slopedTownEast_E_0000",
  },
  [10041]={
    "lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000",
    "lz_drp_field_N0000|rt_drp_field_N_0000",
    "lz_drp_field_W0000|rt_drp_field_W_0000",
    "lz_drp_slopedTown_E0000|rt_drp_slopedTown_E_0000",
    "lz_drp_slopedTown_I0000|rt_drp_slopedTown_I_0000",
    "lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000",
    "lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000",
    "lz_drp_field_I0000|rt_drp_field_I_0000",
    "lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000",
  },
  [10043]={
    "lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000",
    "lz_drp_commFacility_I0000|rt_drp_commFacility_I_0000",
  },
  [10044]={
    "lz_drp_fort_I0000|rt_drp_fort_I_0000",
    "lz_drp_cliffTown_I0000|rt_drp_cliffTown_I0000",
    "lz_drp_cliffTown_N0000|rt_drp_clifftown_N_0000",
    "lz_drp_cliffTown_S0000|rt_drp_cliffTown_S_0000",
  },
  [10045]={
    "lz_drp_field_N0000|rt_drp_field_N_0000",
    "lz_drp_field_I0000|rt_drp_field_I_0000",
    "lz_drp_remnants_I0000|rt_drp_remnants_I_0000",
  },
  --[10050]={},
  [10052]={
    "lz_drp_tent_I0000|rt_drp_tent_I_0000",
    "lz_drp_remnants_I0000|rt_drp_remnants_I_0000",
    "lz_drp_remnants_S0000|rt_drp_remnants_S_0000",
  },
  [10054]={
    "lz_drp_tent_N0000|rt_drp_tent_N_0000",
    "lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000",
    "lz_drp_tent_I0000|rt_drp_tent_I_0000",
    "lz_drp_remnantsNorth_N0000|rt_drp_remnantsNorth_N_0000",
    "lz_drp_remnants_I0000|rt_drp_remnants_I_0000",
    "lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000",
  },
  --[10070]={},
  --[10080]={},
  [10081]={"lz_drp_diamondSouth_W0000|rt_drp_diamondSouth_W_0000"},
  [10082]={
    "lz_drp_savannah_I0000|rt_drp_savannah_I_0000",
    "lz_drp_pfCampNorth_S0000|rt_drp_pfCampNorth_S_0000",
  },
  [10085]={
    "lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000",
    "lz_drp_hillNorth_W0000|rt_drp_hillNorth_W_0000",
    "lz_drp_hill_I0000|rt_drp_hill_I_0000",
  },
  [10086]={
    "lz_drp_swamp_I0000|rt_drp_swamp_I_0000",
    "lz_drp_swamp_S0000|rt_drp_swamp_S_0000",
    "lz_drp_swamp_W0000|lz_drp_swamp_W_0000",
  },
  [10090]={
    "lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000",
    "lz_drp_savannah_I0000|rt_drp_savannah_I_0000",
    "lz_drp_pfCampNorth_S0000|rt_drp_pfCampNorth_S_0000",
    "lz_drp_swamp_I0000|rt_drp_swamp_I_0000",
    "lz_drp_flowStation_I0000|rt_drp_flowStation_I_0000",
  },
  [10091]={
    "lz_drp_flowStation_E0000|lz_drp_flowStation_E_0000",
    "lz_drp_swamp_I0000|rt_drp_swamp_I_0000",
    "lz_drp_swamp_W0000|lz_drp_swamp_W_0000",
  },
  [10093]={
    "lz_drp_lab_W0000|rt_drp_lab_W_0000",
    "lz_drp_lab_S0000|rt_drp_lab_S_0000",
  },
  [10100]={
    "lz_drp_savannahWest_N0000|lz_drp_savannahWest_N_0000",
    "lz_drp_diamond_I0000|rt_drp_diamond_I_0000",
    "lz_drp_banana_I0000|rt_drp_banana_I_0000",
  },
  [10110]={
    "lz_drp_hill_I0000|rt_drp_hill_I_0000",
    "lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000",
  },
  --[10115]={},
  [10120]={"lz_drp_outland_N0000|rt_drp_outland_N_0000"},
  [10121]={
    "lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000",
    "lz_drp_pfCamp_N0000|rt_drp_pfcamp_N_0000",
  },
  [10130]={"rts_drp_lab_S_0000"},
  [10140]={},
  [10150]={},
  [10151]={},
  [10156]={
    "lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000",
    "lz_drp_ruins_S0000|rt_drp_ruins_S_0000",
  },
  [10171]={
    "lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000",
    "lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000",
    "lz_drp_swamp_N0000|lz_drp_swamp_N_0000",
    "lz_drp_savannahEast_S0000|lz_drp_savannahEast_S_0000",
  },
  [10195]={
    "lz_drp_savannah_I0000|rt_drp_savannah_I_0000",
    "lz_drp_savannahEast_S0000|lz_drp_savannahEast_S_0000",
    "lz_drp_savannahEast_N0000|rt_drp_savannahEast_N_0000",
  },
  [10200]={"lz_drp_hillNorth_N0000|rt_drp_hillNorth_N_0000"},
  [10211]={
    "lz_drp_savannahEast_N0000|rt_drp_savannahEast_N_0000",
    "lz_drp_savannah_I0000|rt_drp_savannah_I_0000",
    "lz_drp_swamp_S0000|rt_drp_swamp_S_0000",
    "lz_drp_bananaSouth_N0000|rt_drp_bananaSouth_N_0000",
    "lz_drp_swamp_I0000|rt_drp_swamp_I_0000",
  },
  --[10230]={},
  [10240]={"rt_drp_mbqf_N"},
  --[10260]={},
  --[10280]={},
  [30010]={
    "lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000",
    "lz_drp_field_N0000|rt_drp_field_N_0000",
    "lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000",
    "lz_drp_citadelSouth_S0000|rt_drp_citadelSouth_S_0000",
    "lz_drp_commFacility_S0000|rt_drp_commFacility_S_0000",
    "lz_drp_cliffTown_N0000|rt_drp_clifftown_N_0000",
    "lz_drp_sovietBase_N0000|rt_drp_sovietBase_N_0000",
    "lz_drp_cliffTownWest_S0000|rt_drp_cliffTownWest_S_0000",
    "lz_drp_field_W0000|rt_drp_field_W_0000",
    "lz_drp_field_I0000|rt_drp_field_I_0000",
    "lz_drp_remnantsNorth_N0000|rt_drp_remnantsNorth_N_0000",
    "lz_drp_fort_E0000|rt_drp_fort_E_0000",
    "lz_drp_slopedTownEast_E0000|rt_drp_slopedTownEast_E_0000",
    "lz_drp_commFacility_I0000|rt_drp_commFacility_I_0000",
    "lz_drp_waterway_I0000|rt_drp_waterway_I_0000",
    "lz_drp_sovietBase_S0000|rt_drp_sovietBase_S_0000",
    "lz_drp_powerPlant_S0000|rt_drp_powerPlant_S_0000",
    "lz_drp_bridge_S0000|rt_drp_bridge_S_0000",
    "lz_drp_fieldWest_S0000|rt_drp_fiieldWest_S_0000",
    "lz_drp_remnants_S0000|rt_drp_remnants_S_0000",
    "lz_drp_slopedTown_E0000|rt_drp_slopedTown_E_0000",
    "lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000",
    "lz_drp_slopedTown_I0000|rt_drp_slopedTown_I_0000",
    "lz_drp_fort_I0000|rt_drp_fort_I_0000",
    "lz_drp_tent_I0000|rt_drp_tent_I_0000",
    "lz_drp_village_W0000|rt_drp_village_W_0000",
    "lz_drp_remnantsNorth_S0000|rt_drp_remnantsNorth_S_0000",
    "lz_drp_village_N0000|rt_drp_village_N_0000",
    "lz_drp_tent_N0000|rt_drp_tent_N_0000",
    "lz_drp_tent_E0000|rt_drp_tent_E_0000",
    "lz_drp_slopedTown_W0000|rt_drp_slopedTown_W_0000",
    "lz_drp_remnants_I0000|rt_drp_remnants_I_0000",
    "lz_drp_fort_W0000|rt_drp_fort_W_0000",
    "lz_drp_commFacility_W0000|rt_drp_commFacility_W_0000",
    "lz_drp_cliffTown_I0000|rt_drp_cliffTown_I0000",
    "lz_drp_powerPlant_E0000|rt_drp_powerPlant_E_0000",
    "lz_drp_cliffTown_S0000|rt_drp_cliffTown_S_0000",
    "lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000",
    "lz_drp_ruins_S0000|rt_drp_ruins_S_0000",
    "lz_drp_sovietBase_E0000|rt_drp_sovietBase_E_0000",
    "lz_drp_sovietSouth_S0000|rt_drp_sovietSouth_S_0000",
  },
  [30020]={
    "lz_drp_lab_W0000|rt_drp_lab_W_0000",
    "lz_drp_hill_I0000|rt_drp_hill_I_0000",
    "lz_drp_diamond_N0000|rt_drp_diamond_N_0000",
    "lz_drp_swamp_S0000|rt_drp_swamp_S_0000",
    "lz_drp_savannahWest_N0000|lz_drp_savannahWest_N_0000",
    "lz_drp_diamondWest_S0000|lz_drp_diamondWest_S_0000",
    "lz_drp_swamp_I0000|rt_drp_swamp_I_0000",
    "lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000",
    "lz_drp_savannah_I0000|rt_drp_savannah_I_0000",
    "lz_drp_pfCamp_N0000|rt_drp_pfcamp_N_0000",
    "lz_drp_diamond_I0000|rt_drp_diamond_I_0000",
    "lz_drp_diamondSouth_W0000|rt_drp_diamondSouth_W_0000",
    "lz_drp_factoryWest_S0000|lz_drp_factoryWest_S_0000",
    "lz_drp_pfCamp_S0000|lz_drp_pfCamp_S_0000",
    "lz_drp_swamp_N0000|lz_drp_swamp_N_0000",
    "lz_drp_labWest_W0000|rt_drp_labWest_W_0000",
    "lz_drp_lab_S0000|rt_drp_lab_S_0000",
    "lz_drp_savannahEast_S0000|lz_drp_savannahEast_S_0000",
    "lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000",
    "lz_drp_hill_N0000|lz_drp_hill_N_0000",
    "lz_drp_pfCampNorth_S0000|rt_drp_pfCampNorth_S_0000",
    "lz_drp_swamp_W0000|lz_drp_swamp_W_0000",
    "lz_drp_bananaSouth_N0000|rt_drp_bananaSouth_N_0000",
    "lz_drp_swampEast_N0000|lz_drp_swampEast_N_0000",
    "lz_drp_diamondSouth_S0000|lz_drp_diamondSouth_S_0000",
    "lz_drp_hillSouth_W0000|lz_drp_hillSouth_W_0000",
    "lz_drp_banana_I0000|rt_drp_banana_I_0000",
    "lz_drp_hill_E0000|lz_drp_hill_E_0000",
    "lz_drp_factory_N0000|rt_drp_factory_N_0000",
    "lz_drp_savannahEast_N0000|rt_drp_savannahEast_N_0000",
    "lz_drp_flowStation_E0000|lz_drp_flowStation_E_0000",
    "lz_drp_flowStation_I0000|rt_drp_flowStation_I_0000",
    "lz_drp_outland_S0000|rt_drp_outland_S_0000",
  },
--[30050]={},
--[50050]={},
}

--tex No heli drop, user still selects lz drop point, it uses similar override to NO_HELICOPTER_MISSION_START_POSITION, but uses below table
--tex table initially cribbed from tpplandingzone OverwriteBuddyVehiclePosForALZ
--REF:
--function this.OverwriteBuddyVehiclePosForALZ()
--  local posTable={
--    cliffTown={
--      [Fox.StrCode32"lz_drp_cliffTown_I0000|rt_drp_cliffTown_I0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(784.236,435.562,-1237.65),TppMath.DegreeToRadian(-4.08)},
--        [EntryBuddyType.BUDDY]={Vector3(783.114,435.136,-1246.231),-4.08}}},
--    commFacility={
--      [Fox.StrCode32"lz_drp_commFacility_I0000|rt_drp_commFacility_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(1345.682,357.239,434.999),TppMath.DegreeToRadian(30.64)},
--        [EntryBuddyType.BUDDY]={Vector3(1340.923,358.53,438.866),42.41}}},
--    enemyBase={
--      [Fox.StrCode32"lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(-407.628,315.992,482.41),TppMath.DegreeToRadian(1.8)},
--        [EntryBuddyType.BUDDY]={Vector3(-410.208,316.399,508.065),176.17}}},
--    field={
--      [Fox.StrCode32"lz_drp_field_I0000|rt_drp_field_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(368.004,278.145,2361.91),TppMath.DegreeToRadian(116.9)},
--        [EntryBuddyType.BUDDY]={Vector3(367.974,279.287,2355.952),102.35}}},
--    fort={
--      [Fox.StrCode32"lz_drp_fort_I0000|rt_drp_fort_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(2041.735,479.324,-1594.738),TppMath.DegreeToRadian(140.63)},
--        [EntryBuddyType.BUDDY]={Vector3(2044.589,478.915,-1588.505),151.95}}},
--    powerPlant={
--      [Fox.StrCode32"lz_drp_powerPlant_E0000|rt_drp_powerPlant_E_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(-830.87,511.191,-1243.93),TppMath.DegreeToRadian(-144.68)},
--        [EntryBuddyType.BUDDY]={Vector3(-829.978,511.451,-1236.262),-150.97}}},
--    remnants={
--      [Fox.StrCode32"lz_drp_remnants_I0000|rt_drp_remnants_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(-709.726,289.695,1735.643),TppMath.DegreeToRadian(-49.07)},
--        [EntryBuddyType.BUDDY]={Vector3(-702.429,289.014,1740.65),-38.93}}},
--    slopedTown={
--      [Fox.StrCode32"lz_drp_slopedTown_I0000|rt_drp_slopedTown_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(495.854,333.515,232.89),TppMath.DegreeToRadian(111.55)},
--        [EntryBuddyType.BUDDY]={Vector3(496.236,334.679,237.834),108.72}}},
--    sovietBase={
--      [Fox.StrCode32"lz_drp_sovietBase_E0000|rt_drp_sovietBase_E_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(-2006.886,425.727,-1127.261),TppMath.DegreeToRadian(-5.26)},
--        [EntryBuddyType.BUDDY]={Vector3(-2003.57,426.474,-1128.173),-5.26}}},
--    tent={
--      [Fox.StrCode32"lz_drp_tent_I0000|rt_drp_tent_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(-1883.463,323.868,746.783),TppMath.DegreeToRadian(44.64)},
--        [EntryBuddyType.BUDDY]={Vector3(-1873.108,323.846,736.65),35.82}}},
--    banana={
--      [Fox.StrCode32"lz_drp_banana_I0000|rt_drp_banana_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(394.645,60.24,-1318.929),TppMath.DegreeToRadian(-40.98)},
--        [EntryBuddyType.BUDDY]={Vector3(390.86,59.935,-1321.727),-40.98}}},
--    diamond={
--      [Fox.StrCode32"lz_drp_diamond_I0000|rt_drp_diamond_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(1196.886,143.309,-1639.064),TppMath.DegreeToRadian(51.3)},
--        [EntryBuddyType.BUDDY]={Vector3(1199.647,143.293,-1645.311),51.3}}},
--    flowStation={
--      [Fox.StrCode32"lz_drp_flowStation_I0000|rt_drp_flowStation_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(-1090.728,-12.305,-45.368),TppMath.DegreeToRadian(-172.81)},
--        [EntryBuddyType.BUDDY]={Vector3(-1083.825,-12.284,-44.864),-178.15}}},
--    hill={
--      [Fox.StrCode32"lz_drp_hill_I0000|rt_drp_hill_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(1962.906,44.372,356.735),TppMath.DegreeToRadian(83.13)},
--        [EntryBuddyType.BUDDY]={Vector3(1961.012,43.662,364.622),83.13}}},
--    pfCamp={
--      [Fox.StrCode32"lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(659.712,-11.962,1016.94),TppMath.DegreeToRadian(93.6)},
--        [EntryBuddyType.BUDDY]={Vector3(657.349,-11.296,1010.927),93.6}}},
--    svannah={
--      [Fox.StrCode32"lz_drp_savannah_I0000|rt_drp_savannah_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(1025.44,18.729,-295.689),TppMath.DegreeToRadian(-71.73)},
--        [EntryBuddyType.BUDDY]={Vector3(1026.319,18.662,-302.596),-71.73}}},
--    swamp={
--      [Fox.StrCode32"lz_drp_swamp_I0000|rt_drp_swamp_I_0000"]={
--        [EntryBuddyType.VEHICLE]={Vector3(6.412,-5.952,294.757),TppMath.DegreeToRadian(-153.76)},
--        [EntryBuddyType.BUDDY]={Vector3(2.113,-5.436,299.302),-153.76}}}
--  }
--  for n,posForLz in pairs(posTable)do
--    TppEnemy.NPCEntryPointSetting(posForLz)
--  end
--end
--
--function this.NPCEntryPointSetting(settings)
--  local npcsEntryPoints=settings[gvars.heli_missionStartRoute]
--  if not npcsEntryPoints then
--    return
--  end
--  for entryBuddyType,t in pairs(npcsEntryPoints)do
--    local pos,rotY=t[1],t[2]
--    TppBuddyService.SetMissionEntryPosition(entryBuddyType,pos)
--    TppBuddyService.SetMissionEntryRotationY(entryBuddyType,rotY)
--  end
--end

--this.groundStartPositions={
--  [Fox.StrCode32"lz_drp_cliffTown_I0000|rt_drp_cliffTown_I0000"]={pos={783.114,435.136,-1246.231},rotY=-4.08},
--  [Fox.StrCode32"lz_drp_commFacility_I0000|rt_drp_commFacility_I_0000"]={pos={1340.923,358.53,438.866},rotY=42.41},
--  [Fox.StrCode32"lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000"]={pos={-410.208,316.399,508.065},rotY=176.17},
--  [Fox.StrCode32"lz_drp_field_I0000|rt_drp_field_I_0000"]={pos={367.974,279.287,2355.952},rotY=102.35},
--  [Fox.StrCode32"lz_drp_fort_I0000|rt_drp_fort_I_0000"]={pos={2044.589,478.915,-1588.505},rotY=151.95},
--  [Fox.StrCode32"lz_drp_powerPlant_E0000|rt_drp_powerPlant_E_0000"]={pos={-829.978,511.451,-1236.262},rotY=-150.97},
--  [Fox.StrCode32"lz_drp_remnants_I0000|rt_drp_remnants_I_0000"]={pos={-702.429,289.014,1740.65},rotY=-38.93},
--  [Fox.StrCode32"lz_drp_slopedTown_I0000|rt_drp_slopedTown_I_0000"]={pos={496.236,334.679,237.834},rotY=108.72},
--  [Fox.StrCode32"lz_drp_field_N0000|rt_drp_field_N_0000"]={pos={-359.62,283.42,1714.79},rotY=108.72},--
--  [Fox.StrCode32"lz_drp_field_W0000|rt_drp_field_W_0000"]={pos={-359.62,283.42,1714.79},rotY=108.72},--
--
--  [Fox.StrCode32"lz_drp_sovietBase_E0000|rt_drp_sovietBase_E_0000"]={pos={-2003.57,426.474,-1128.173},rotY=-5.26},
--  [Fox.StrCode32"lz_drp_tent_I0000|rt_drp_tent_I_0000"]={pos={-1873.108,323.846,736.65},rotY=35.82},
--  [Fox.StrCode32"lz_drp_banana_I0000|rt_drp_banana_I_0000"]={pos={390.86,59.935,-1321.727},rotY=-40.98},
--  [Fox.StrCode32"lz_drp_diamond_I0000|rt_drp_diamond_I_0000"]={pos={1199.647,143.293,-1645.311},rotY=51.3},
--  [Fox.StrCode32"lz_drp_flowStation_I0000|rt_drp_flowStation_I_0000"]={pos={-1083.825,-12.284,-44.864},rotY=-178.15},
--  [Fox.StrCode32"lz_drp_hill_I0000|rt_drp_hill_I_0000"]={pos={1961.012,43.662,364.622},rotY=83.13},
--  [Fox.StrCode32"lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000"]={pos={657.349,-11.296,1010.927},rotY=93.6},
--  [Fox.StrCode32"lz_drp_savannah_I0000|rt_drp_savannah_I_0000"]={pos={1026.319,18.662,-302.596},rotY=-71.73},
--  [Fox.StrCode32"lz_drp_swamp_I0000|rt_drp_swamp_I_0000"]={pos={2.113,-5.436,299.302},rotY=-153.76},
--}

--REF: in case I want to do rotation, would need per mission to face toward objective, in free should just face toward center
--this.groundStartPositions2={
--  [10033]={
--    {point={-351.61,321.89,768.34},routeId="lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000"},
--    {point={-289.80,346.69,269.68},routeId="lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000"},
--    {point={-596.89,353.02,497.40},routeId="lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000"},
--  },
--  [10036]={
--    {point={418.33,278.22,2261.37},routeId="lz_drp_field_I0000|rt_drp_field_I_0000",},
--    {point={802.56,345.37,1637.75},routeId="lz_drp_field_N0000|rt_drp_field_N_0000"},
--    {point={-359.62,283.42,1714.79},routeId="lz_drp_field_W0000|rt_drp_field_W_0000"},
--  },
--  [10040]={
--    {point={2106.16,463.64,-1747.21},routeId="lz_drp_fort_I0000|rt_drp_fort_I_0000",},
--    {point={1187.73,320.98,-10.40},routeId="lz_drp_slopedTownEast_E0000|rt_drp_slopedTownEast_E_0000"},
--  },
--  [10041]={
--    {point={-289.80,346.69,269.68},routeId="lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000"},
--    {point={802.56,345.37,1637.75},routeId="lz_drp_field_N0000|rt_drp_field_N_0000"},
--    {point={-359.62,283.42,1714.79},routeId="lz_drp_field_W0000|rt_drp_field_W_0000"},
--    {point={822.37,360.44,292.44},routeId="lz_drp_slopedTown_E0000|rt_drp_slopedTown_E_0000"},
--    {point={512.11,316.60,167.44},routeId="lz_drp_slopedTown_I0000|rt_drp_slopedTown_I_0000",},
--    {point={1275.22,337.42,1313.33},routeId="lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000"},
--    {point={-351.61,321.89,768.34},routeId="lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000"},
--    {point={418.33,278.22,2261.37},routeId="lz_drp_field_I0000|rt_drp_field_I_0000",},
--    {point={-596.89,353.02,497.40},routeId="lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000",},
--  },
--  [10043]={
--    {point={1275.22,337.42,1313.33},routeId="lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000"},
--    {point={1444.40,364.14,390.78},routeId="lz_drp_commFacility_I0000|rt_drp_commFacility_I_0000",},
--  },
--  [10044]={
--    {point={2106.16,463.64,-1747.21},routeId="lz_drp_fort_I0000|rt_drp_fort_I_0000"},
--    {point={759.83,452.30,-1113.10},routeId="lz_drp_cliffTown_I0000|rt_drp_cliffTown_I0000"},
--    {point={834.42,451.21,-1420.10},routeId="lz_drp_cliffTown_N0000|rt_drp_clifftown_N_0000"},
--    {point={491.46,418.47,-693.19},routeId="lz_drp_cliffTown_S0000|rt_drp_cliffTown_S_0000"},
--  },
--  [10045]={
--    {point={802.56,345.37,1637.75},startPoint={1247.97,345.37,1298.36},routeId="lz_drp_field_N0000|rt_drp_field_N_0000"},
--    {point={418.33,278.22,2261.37},startPoint={887.95,309.12,2383.44},routeId="lz_drp_field_I0000|rt_drp_field_I_0000"},
--    {point={-805.54,291.88,1820.65},startPoint={-248.03,297.88,1963.33},routeId="lz_drp_remnants_I0000|rt_drp_remnants_I_0000"},
--  },
--  [10052]={
--    {point={-1761.73,317.69,806.51},startPoint={-1158.50,335.69,1422.75},routeId="lz_drp_tent_I0000|rt_drp_tent_I_0000"},
--    {point={-805.54,291.88,1820.65},startPoint={-248.03,297.88,1963.33},routeId="lz_drp_remnants_I0000|rt_drp_remnants_I_0000"},
--    {point={-424.83,289.10,2004.96},startPoint={54.07,312.10,2230.84},routeId="lz_drp_remnants_S0000|rt_drp_remnants_S_0000"},
--  },
--  [10054]={
--    {point={-1868.78,338.48,538.78},startPoint={-1886.95,348.98,166.98},routeId="lz_drp_tent_N0000|rt_drp_tent_N_0000"},
--    {point={-351.61,321.89,768.34},startPoint={-91.82,331.89,918.56},routeId="lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000"},
--    {point={-1761.73,317.69,806.51},startPoint={-1158.50,335.69,1422.75},routeId="lz_drp_tent_I0000|rt_drp_tent_I_0000"},
--    {point={-836.84,288.90,1574.03},startPoint={-312.47,306.90,1792.76},routeId="lz_drp_remnantsNorth_N0000|rt_drp_remnantsNorth_N_0000"},
--    {point={-805.54,291.88,1820.65},startPoint={-248.03,297.88,1963.33},routeId="lz_drp_remnants_I0000|rt_drp_remnants_I_0000"},
--    {point={-596.89,353.02,497.40},startPoint={-946.28,309.02,981.35},routeId="lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000"},
--  },
--  [10081]={
--    {point={1203.80,107.74,-792.16},startPoint={1225.37,122.74,-303.61},routeId="lz_drp_diamondSouth_W0000|rt_drp_diamondSouth_W_0000"},
--  },
--  [10082]={
--    {point={1014.25,57.18,-221.46},startPoint={263.05,40.18,-292.45},routeId="lz_drp_savannah_I0000|rt_drp_savannah_I_0000"},
--    {point={582.54,-3.14,418.17},startPoint={416.04,37.87,955.68},routeId="lz_drp_pfCampNorth_S0000|rt_drp_pfCampNorth_S_0000"},
--  },
--  [10085]={
--    {point={1769.46,28.60,560.59},startPoint={1318.61,56.60,247.85},routeId="lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000"},
--    {point={1734.22,66.01,-407.54},startPoint={1905.69,129.57,-767.85},routeId="lz_drp_hillNorth_W0000|rt_drp_hillNorth_W_0000"},
--    {point={2154.83,63.09,366.70},startPoint={1472.96,56.09,535.65},routeId="lz_drp_hill_I0000|rt_drp_hill_I_0000"},
--  },
--  [10086]={
--    {point={-19.63,11.17,140.91},startPoint={-690.06,9.17,384.74},routeId="lz_drp_swamp_I0000|rt_drp_swamp_I_0000"},
--    {point={-163.59,7.96,385.58},startPoint={129.00,40.96,832.24},routeId="lz_drp_swamp_S0000|rt_drp_swamp_S_0000"},
--    {point={-618.09,6.48,232.79},startPoint={-1170.26,39.73,167.57},routeId="lz_drp_swamp_W0000|lz_drp_swamp_W_0000"},
--  },
--  [10090]={
--    {point={846.46,-4.97,1148.62},startPoint={1340.72,3.13,1707.16},routeId="lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000"},
--    {point={1014.25,57.18,-221.46},startPoint={263.05,40.18,-292.45},routeId="lz_drp_savannah_I0000|rt_drp_savannah_I_0000"},
--    {point={582.54,-3.14,418.17},startPoint={416.04,37.87,955.68},routeId="lz_drp_pfCampNorth_S0000|rt_drp_pfCampNorth_S_0000"},
--    {point={-19.63,11.17,140.91},startPoint={-690.06,9.17,384.74},routeId="lz_drp_swamp_I0000|rt_drp_swamp_I_0000"},
--    {point={-1001.38,-7.20,-199.16},startPoint={-853.18,22.80,251.66},routeId="lz_drp_flowStation_I0000|rt_drp_flowStation_I_0000"},
--  },
--  [10091]={
--    {point={-610.26,13.10,-398.20},startPoint={-513.43,36.10,39.07},routeId="lz_drp_flowStation_E0000|lz_drp_flowStation_E_0000"},
--    {point={-19.63,11.17,140.91},startPoint={-690.06,9.17,384.74},routeId="lz_drp_swamp_I0000|rt_drp_swamp_I_0000"},
--    {point={-618.09,6.48,232.79},startPoint={-1170.26,39.73,167.57},routeId="lz_drp_swamp_W0000|lz_drp_swamp_W_0000"},
--  },
--  [10093]={
--    {point={2331.11,208.01,-2487.00},startPoint={2069.32,209.01,-2087.33},routeId="lz_drp_lab_W0000|rt_drp_lab_W_0000"},
--    {point={2521.90,111.82,-1833.82},startPoint={2481.70,86.82,-1321.02},routeId="lz_drp_lab_S0000|rt_drp_lab_S_0000"},
--  },
--  [10100]={
--    {point={510.10,20.43,-732.55},startPoint={430.71,35.43,-208.19},routeId="lz_drp_savannahWest_N0000|lz_drp_savannahWest_N_0000"},
--    {point={1381.85,137.05,-1516.01},startPoint={1083.13,158.05,-1892.86},routeId="lz_drp_diamond_I0000|rt_drp_diamond_I_0000"},
--    {point={300.61,50.06,-1237.66},startPoint={559.74,38.06,-707.21},routeId="lz_drp_banana_I0000|rt_drp_banana_I_0000"},
--  },
--  [10110]={
--    {point={2154.83,63.09,366.70},startPoint={1472.96,56.09,535.65},routeId="lz_drp_hill_I0000|rt_drp_hill_I_0000"},
--    {point={1769.46,28.60,560.59},startPoint={1318.61,56.60,247.85},routeId="lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000"},
--  },
--  [10120]={
--    {point={-807.61,3.47,516.01},startPoint={-428.89,33.47,271.33},routeId="lz_drp_outland_N0000|rt_drp_outland_N_0000"},
--  },
--  [10121]={
--    {point={846.46,-4.97,1148.62},startPoint={1340.72,3.13,1707.16},routeId="lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000"},
--    {point={1061.84,6.78,731.21},startPoint={625.74,29.78,306.26},routeId="lz_drp_pfCamp_N0000|rt_drp_pfcamp_N_0000"},
--  },
--  [10130]={
--    {point={2441.72,78.25,-1191.68},startPoint={2674.50,97.25,-1781.35},routeId="rts_drp_lab_S_0000"},
--  },
--  [10156]={
--    {point={1275.22,337.42,1313.33},startPoint={1255.64,340.42,1747.07},routeId="lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000"},
--    {point={1272.20,329.63,1853.51},startPoint={1250.48,317.63,2167.53},routeId="lz_drp_ruins_S0000|rt_drp_ruins_S_0000"},
--  },
--  [10171]={
--    {point={846.46,-4.97,1148.62},startPoint={1340.72,3.13,1707.16},routeId="lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000"},
--    {point={1769.46,28.60,560.59},startPoint={1318.61,56.60,247.85},routeId="lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000"},
--    {point={-145.52,16.15,-379.20},startPoint={474.18,30.15,-323.11},routeId="lz_drp_swamp_N0000|lz_drp_swamp_N_0000"},
--    {point={1119.97,10.72,317.63},startPoint={564.28,31.72,31.20},routeId="lz_drp_savannahEast_S0000|lz_drp_savannahEast_S_0000"},
--  },
--  [10195]={
--    {point={1014.25,57.18,-221.46},startPoint={263.05,40.18,-292.45},routeId="lz_drp_savannah_I0000|rt_drp_savannah_I_0000"},
--    {point={1119.97,10.72,317.63},startPoint={564.28,31.72,31.20},routeId="lz_drp_savannahEast_S0000|lz_drp_savannahEast_S_0000"},
--    {point={1233.17,25.84,-127.05},startPoint={1836.30,103.84,5.63},routeId="lz_drp_savannahEast_N0000|rt_drp_savannahEast_N_0000"},
--  },
--  [10200]={
--    {point={1666.75,113.91,-740.61},startPoint={1428.20,73.91,-136.30},routeId="lz_drp_hillNorth_N0000|rt_drp_hillNorth_N_0000"},
--  },
--  [10211]={
--    {point={1233.17,25.84,-127.05},startPoint={1836.30,103.84,5.63},routeId="lz_drp_savannahEast_N0000|rt_drp_savannahEast_N_0000"},
--    {point={1014.25,57.18,-221.46},startPoint={263.05,40.18,-292.45},routeId="lz_drp_savannah_I0000|rt_drp_savannah_I_0000"},
--    {point={-163.59,7.96,385.58},startPoint={129.00,40.96,832.24},routeId="lz_drp_swamp_S0000|rt_drp_swamp_S_0000"},
--    {point={74.70,18.20,-689.41},startPoint={430.19,36.20,-164.65},routeId="lz_drp_bananaSouth_N0000|rt_drp_bananaSouth_N_0000"},
--    {point={-19.63,11.17,140.91},startPoint={-690.06,9.17,384.74},routeId="lz_drp_swamp_I0000|rt_drp_swamp_I_0000"},
--  },
--  [10240]={
--    {point={-162.70,4.97,-2105.86},startPoint={204.36,89.64,-1560.65},routeId="rt_drp_mbqf_N"},
--  },
--  [30010]={
--    {point={-289.80,346.69,269.68},startPoint={161.28,335.69,140.48},routeId="lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000"},
--    {point={802.56,345.37,1637.75},startPoint={1247.97,345.37,1298.36},routeId="lz_drp_field_N0000|rt_drp_field_N_0000"},
--    {point={-351.61,321.89,768.34},startPoint={-91.82,331.89,918.56},routeId="lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000"},
--    {point={-1663.71,536.63,-2201.78},startPoint={-1531.39,474.63,-1679.84},routeId="lz_drp_citadelSouth_S0000|rt_drp_citadelSouth_S_0000"},
--    {point={1651.17,353.38,587.98},startPoint={1701.22,353.38,1084.22},routeId="lz_drp_commFacility_S0000|rt_drp_commFacility_S_0000"},
--    {point={834.42,451.21,-1420.10},startPoint={1398.39,514.21,-1245.88},routeId="lz_drp_cliffTown_N0000|rt_drp_clifftown_N_0000"},
--    {point={-1718.06,474.38,-1713.62},startPoint={-1590.27,526.60,-2075.17},routeId="lz_drp_sovietBase_N0000|rt_drp_sovietBase_N_0000"},
--    {point={64.77,434.32,-842.65},startPoint={462.40,432.32,-727.01},routeId="lz_drp_cliffTownWest_S0000|rt_drp_cliffTownWest_S_0000"},
--    {point={-359.62,283.42,1714.79},startPoint={-771.13,305.42,1447.29},routeId="lz_drp_field_W0000|rt_drp_field_W_0000"},
--    {point={418.33,278.22,2261.37},startPoint={887.95,309.12,2383.44},routeId="lz_drp_field_I0000|rt_drp_field_I_0000"},
--    {point={-836.84,288.90,1574.03},startPoint={-312.47,306.90,1792.76},routeId="lz_drp_remnantsNorth_N0000|rt_drp_remnantsNorth_N_0000"},
--    {point={2305.28,394.03,-923.73},startPoint={2636.58,397.03,-805.06},routeId="lz_drp_fort_E0000|rt_drp_fort_E_0000"},
--    {point={1187.73,320.98,-10.40},startPoint={1489.55,336.98,65.91},routeId="lz_drp_slopedTownEast_E0000|rt_drp_slopedTownEast_E_0000"},
--    {point={1444.40,364.14,390.78},startPoint={925.92,368.14,502.51},routeId="lz_drp_commFacility_I0000|rt_drp_commFacility_I_0000"},
--    {point={-1677.59,360.88,-321.82},startPoint={-1861.11,373.88,-136.02},routeId="lz_drp_waterway_I0000|rt_drp_waterway_I_0000"},
--    {point={-1949.57,439.73,-1170.39},startPoint={-1441.68,439.73,-1006.99},routeId="lz_drp_sovietBase_S0000|rt_drp_sovietBase_S_0000"},
--    {point={-630.25,444.69,-910.73},startPoint={-400.84,502.69,-1175.87},routeId="lz_drp_powerPlant_S0000|rt_drp_powerPlant_S_0000"},
--    {point={1904.32,368.36,81.33},startPoint={1340.73,356.36,44.81},routeId="lz_drp_bridge_S0000|rt_drp_bridge_S_0000"},
--    {point={141.47,275.51,2353.44},startPoint={-249.77,310.51,1998.40},routeId="lz_drp_fieldWest_S0000|rt_drp_fiieldWest_S_0000"},
--    {point={-424.83,289.10,2004.96},startPoint={54.07,312.10,2230.84},routeId="lz_drp_remnants_S0000|rt_drp_remnants_S_0000"},
--    {point={822.37,360.44,292.44},startPoint={335.25,364.44,413.83},routeId="lz_drp_slopedTown_E0000|rt_drp_slopedTown_E_0000"},
--    {point={1275.22,337.42,1313.33},startPoint={1255.64,340.42,1747.07},routeId="lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000"},
--    {point={512.11,316.60,167.44},startPoint={1074.92,379.60,506.01},routeId="lz_drp_slopedTown_I0000|rt_drp_slopedTown_I_0000"},
--    {point={2106.16,463.64,-1747.21},startPoint={2043.26,474.64,-1248.49},routeId="lz_drp_fort_I0000|rt_drp_fort_I_0000"},
--    {point={-1761.73,317.69,806.51},startPoint={-1158.50,335.69,1422.75},routeId="lz_drp_tent_I0000|rt_drp_tent_I_0000"},
--    {point={20.70,329.63,888.03},startPoint={626.34,354.63,849.22},routeId="lz_drp_village_W0000|rt_drp_village_W_0000"},
--    {point={-1273.30,305.48,1342.07},startPoint={-887.87,311.48,1427.74},routeId="lz_drp_remnantsNorth_S0000|rt_drp_remnantsNorth_S_0000"},
--    {point={612.73,355.48,911.22},startPoint={2.37,343.48,848.51},routeId="lz_drp_village_N0000|rt_drp_village_N_0000"},
--    {point={-1868.78,338.48,538.78},startPoint={-1886.95,348.98,166.98},routeId="lz_drp_tent_N0000|rt_drp_tent_N_0000"},
--    {point={-1372.18,318.33,934.68},startPoint={-1183.10,332.33,1243.43},routeId="lz_drp_tent_E0000|rt_drp_tent_E_0000"},
--    {point={95.31,320.37,243.91},startPoint={-454.10,368.37,206.70},routeId="lz_drp_slopedTown_W0000|rt_drp_slopedTown_W_0000"},
--    {point={-805.54,291.88,1820.65},startPoint={-248.03,297.88,1963.33},routeId="lz_drp_remnants_I0000|rt_drp_remnants_I_0000"},
--    {point={1649.11,491.21,-1340.58},startPoint={1034.49,511.21,-1286.79},routeId="lz_drp_fort_W0000|rt_drp_fort_W_0000"},
--    {point={1060.06,362.05,467.90},startPoint={590.77,374.89,368.06},routeId="lz_drp_commFacility_W0000|rt_drp_commFacility_W_0000"},
--    {point={759.83,452.30,-1113.10},startPoint={65.71,437.30,-792.83},routeId="lz_drp_cliffTown_I0000|rt_drp_cliffTown_I0000"},
--    {point={-662.20,556.88,-1489.06},startPoint={-433.13,522.23,-1094.86},routeId="lz_drp_powerPlant_E0000|rt_drp_powerPlant_E_0000"},
--    {point={491.46,418.47,-693.19},startPoint={886.63,393.47,-299.32},routeId="lz_drp_cliffTown_S0000|rt_drp_cliffTown_S_0000"},
--    {point={-596.89,353.02,497.40},startPoint={-946.28,309.02,981.35},routeId="lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000"},
--    {point={1272.20,329.63,1853.51},startPoint={1250.48,317.63,2167.53},routeId="lz_drp_ruins_S0000|rt_drp_ruins_S_0000"},
--    {point={-2355.80,445.52,-1431.61},startPoint={-1639.10,466.52,-1589.67},routeId="lz_drp_sovietBase_E0000|rt_drp_sovietBase_E_0000"},
--    {point={-1219.28,416.14,-886.41},startPoint={-583.54,445.14,-815.04},routeId="lz_drp_sovietSouth_S0000|rt_drp_sovietSouth_S_0000"},
--  },
--  [30020]={
--    {point={2331.11,208.01,-2487.00},startPoint={2069.32,209.01,-2087.33},routeId="lz_drp_lab_W0000|rt_drp_lab_W_0000"},
--    {point={2154.83,63.09,366.70},startPoint={1472.96,56.09,535.65},routeId="lz_drp_hill_I0000|rt_drp_hill_I_0000"},
--    {point={1096.40,150.86,-1685.39},startPoint={1145.97,148.86,-1044.72},routeId="lz_drp_diamond_N0000|rt_drp_diamond_N_0000"},
--    {point={-163.59,7.96,385.58},startPoint={129.00,40.96,832.24},routeId="lz_drp_swamp_S0000|rt_drp_swamp_S_0000"},
--    {point={510.10,20.43,-732.55},startPoint={430.71,35.43,-208.19},routeId="lz_drp_savannahWest_N0000|lz_drp_savannahWest_N_0000"},
--    {point={924.72,44.01,-931.28},startPoint={1280.06,60.93,-437.63},routeId="lz_drp_diamondWest_S0000|lz_drp_diamondWest_S_0000"},
--    {point={-19.63,11.17,140.91},startPoint={-690.06,9.17,384.74},routeId="lz_drp_swamp_I0000|rt_drp_swamp_I_0000"},
--    {point={846.46,-4.97,1148.62},startPoint={1340.72,3.13,1707.16},routeId="lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000"},
--    {point={1014.25,57.18,-221.46},startPoint={263.05,40.18,-292.45},routeId="lz_drp_savannah_I0000|rt_drp_savannah_I_0000"},
--    {point={1061.84,6.78,731.21},startPoint={625.74,29.78,306.26},routeId="lz_drp_pfCamp_N0000|rt_drp_pfcamp_N_0000"},
--    {point={1381.85,137.05,-1516.01},startPoint={1083.13,158.05,-1892.86},routeId="lz_drp_diamond_I0000|rt_drp_diamond_I_0000"},
--    {point={1203.80,107.74,-792.16},startPoint={1225.37,122.74,-303.61},routeId="lz_drp_diamondSouth_W0000|rt_drp_diamondSouth_W_0000"},
--    {point={2271.82,84.84,-418.59},startPoint={2416.57,86.54,-33.38},routeId="lz_drp_factoryWest_S0000|lz_drp_factoryWest_S_0000"},
--    {point={1007.02,-4.46,1557.61},startPoint={1580.16,18.96,1490.89},routeId="lz_drp_pfCamp_S0000|lz_drp_pfCamp_S_0000"},
--    {point={-145.52,16.15,-379.20},startPoint={474.18,30.15,-323.11},routeId="lz_drp_swamp_N0000|lz_drp_swamp_N_0000"},
--    {point={1786.78,170.73,-2130.50},startPoint={1623.44,168.73,-1806.87},routeId="lz_drp_labWest_W0000|rt_drp_labWest_W_0000"},
--    {point={2521.90,111.82,-1833.82},startPoint={2481.70,86.82,-1321.02},routeId="lz_drp_lab_S0000|rt_drp_lab_S_0000"},
--    {point={1119.97,10.72,317.63},startPoint={564.28,31.72,31.20},routeId="lz_drp_savannahEast_S0000|lz_drp_savannahEast_S_0000"},
--    {point={1769.46,28.60,560.59},startPoint={1318.61,56.60,247.85},routeId="lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000"},
--    {point={1951.46,49.82,88.58},startPoint={1644.07,67.82,633.63},routeId="lz_drp_hill_N0000|lz_drp_hill_N_0000"},
--    {point={582.54,-3.14,418.17},startPoint={416.04,37.87,955.68},routeId="lz_drp_pfCampNorth_S0000|rt_drp_pfCampNorth_S_0000"},
--    {point={-618.09,6.48,232.79},startPoint={-1170.26,39.73,167.57},routeId="lz_drp_swamp_W0000|lz_drp_swamp_W_0000"},
--    {point={74.70,18.20,-689.41},startPoint={430.19,36.20,-164.65},routeId="lz_drp_bananaSouth_N0000|rt_drp_bananaSouth_N_0000"},
--    {point={266.57,1.56,-234.08},startPoint={744.40,33.56,86.60},routeId="lz_drp_swampEast_N0000|lz_drp_swampEast_N_0000"},
--    {point={1648.35,87.11,-555.26},startPoint={1447.82,64.11,63.98},routeId="lz_drp_diamondSouth_S0000|lz_drp_diamondSouth_S_0000"},
--    {point={1688.90,-3.65,1520.55},startPoint={1910.28,19.35,1883.37},routeId="lz_drp_hillSouth_W0000|lz_drp_hillSouth_W_0000"},
--    {point={300.61,50.06,-1237.66},startPoint={559.74,38.06,-707.21},routeId="lz_drp_banana_I0000|rt_drp_banana_I_0000"},
--    {point={2465.21,71.47,230.49},startPoint={2447.80,89.47,-244.96},routeId="lz_drp_hill_E0000|lz_drp_hill_E_0000"},
--    {point={2441.72,78.25,-1191.68},startPoint={2678.54,97.25,-1790.59},routeId="lz_drp_factory_N0000|rt_drp_factory_N_0000"},
--    {point={1233.17,25.84,-127.05},startPoint={1836.30,103.84,5.63},routeId="lz_drp_savannahEast_N0000|rt_drp_savannahEast_N_0000"},
--    {point={-610.26,13.10,-398.20},startPoint={-513.43,36.10,39.07},routeId="lz_drp_flowStation_E0000|lz_drp_flowStation_E_0000"},
--    {point={-1001.38,-7.20,-199.16},startPoint={-853.18,22.80,251.66},routeId="lz_drp_flowStation_I0000|rt_drp_flowStation_I_0000"},
--    {point={-440.57,-14.39,1339.17},startPoint={-462.44,-5.39,1926.48},routeId="lz_drp_outland_S0000|rt_drp_outland_S_0000"},
--  },
--}

return this