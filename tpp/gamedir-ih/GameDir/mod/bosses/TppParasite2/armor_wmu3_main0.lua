local this={
  type="TppParasite2",--tex see InfBossTppParasite2 for notes
  name="armor_wmu3_main0",
  description="Armor Skull",
  packages={"/Assets/tpp/pack/mission2/online/o50050/o50055_parasite_metal.fpk",},
    --tex is split up more fine grained than it needs to be, just trying to get an idea of what files are involved
    --but with the weirdness thats results I dont think this is a viable approach
    --packs moved out to submods if you want to revisit
  -- packages={
  --   "/Assets/tpp/pack/boss/ih/wmu3_main0_parts_boss.fpk",
  --   "/Assets/tpp/pack/boss/ih/ar02_main0_aw0_v00.fpk",
  --   "/Assets/tpp/pack/boss/ih/sm02_main1_aw0_v00.fpk",
  --   "/Assets/tpp/pack/boss/ih/sg03_main1_aw0_v00.fpk",
  --   "/Assets/tpp/pack/boss/ih/bl03_main0_def.fpk",
    
  --   "/Assets/tpp/pack/boss/ih/TppParasite2_gameobject_ARMOR.fpk",
  --   "/Assets/tpp/pack/boss/ih/TppParasite2_sound.fpk",--really just fox2 and sdf (fox2 variant)
  --   --tex again same issue loading this in seperate pack than _other which is culled down from full pack. 
  --   --also, you can also exclude it and it will have mormal enemy triangle spotting, but this was inconsistant where I thought I'd excluded it from MIST but it was still showing
  --   --"/Assets/tpp/pack/boss/ih/boss_gauge_head.fpk",
    
  --   "/Assets/tpp/pack/boss/ih/TppParasite2_other_ARMOR.fpk",--tex theres some weird stuff if you run with the pack then TppParasite2_locators_4 doesnt load? or isn't loaded even when state/msg says loaded and active?

  --   "/Assets/tpp/pack/boss/ih/TppParasite2_locators_4.fpk",--TODO: rename locators to something that fits boss type
  -- },
  --tex GOTCHA: TppParasite2 is hard coded for 4 instances, less than that and 4 will still appear
  --but those without locators will not act correctly
  --likewise more than 4 units will not act correctly even with locators
  objectNames={
    "Parasite0",
    "Parasite1",
    "Parasite2",
    "Parasite3",
    --TODO see above
    --TppParasite2_locator_0000 or something
    -- "wmu_mist_ih_0000",
    -- "wmu_mist_ih_0001",
    -- "wmu_mist_ih_0002",
    -- "wmu_mist_ih_0003",
  },
  eventParams={
    spawnRadius=40,
    --zombify=true,--TODO: set false and test the boss objects zombifying ability
    fultonable=true,
    faction="SKULL",
    weather={"PARASITE_FOG"},--see InfBossEvent weatherTypes
  },

  params={--sendcommand SetParameters
    --s10090
    sightDistance=25,--[[20,25,30,]]
    sightDistanceCombat=75,--[[75,100]]
    sightVertical=40,--[[36,40,55,60]]
    sightHorizontal=60,--[[48,60,100]]
    noiseRate=8,--[[10]]
    avoidSideMin=8,
    avoidSideMax=12,
    areaCombatBattleRange=50,
    areaCombatBattleToSearchTime=1,
    areaCombatLostSearchRange=1000,
    areaCombatLostToGuardTime=120,--[[120,60]]
    --DEBUGNOW no idea of what a good value is
    --areaCombatGuardDistance=120,
    throwRecastTime=10,
  },

  combatGrade={--sendcommand SetCombatGrade
    --tex uhh where did I get these values?
    defenseValueMain=4000,
    defenseValueArmor=7000,--[[8400]]
    defenseValueWall=8000,--[[9600]]
    offenseGrade=2,--[[5]]
    defenseGrade=7,
  },
}--this
return this