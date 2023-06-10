local this={
  type="TppParasite2",
  name="mist_wmu0_main0",
  description="Mist Skull",
  --packages={"/Assets/tpp/pack/mission2/ih/ih_parasite_mist.fpk"},--TODO: cull
  --tex TODO pftxs
  --TODO: cull boss gauge head (but would need to do the same with ARMOR)
  packages={
    "/Assets/tpp/pack/boss/ih/TppParasite2/mist_wmu0_main0.fpk",
    "/Assets/tpp/pack/boss/ih/common/boss_gauge_head.fpk",
  },
  -- packages={--TODO: pftxs,

    
  --   --parts reffed by gameobject (and the files they reference) have been split out to own packs 
  --   "/Assets/tpp/pack/boss/ih/wmu0_main0_parts_boss.fpk",
  --   "/Assets/tpp/pack/boss/ih/ar02_main0_aw0_v00.fpk",
  --   "/Assets/tpp/pack/boss/ih/sm02_main1_aw0_v00.fpk",
  --   "/Assets/tpp/pack/boss/ih/sg03_main1_aw0_v00.fpk",
  --   "/Assets/tpp/pack/boss/ih/bl03_main0_def.fpk",
    
  --   "/Assets/tpp/pack/boss/ih/TppParasite2_gameobject_MIST.fpk",
  --   "/Assets/tpp/pack/boss/ih/TppParasite2_sound.fpk",--really just fox2 and sdf (fox2 variant)
    
  --   --tex hangs, but also uhh doesnt seem to need it??
  --   --loads fine in TppParasite2_other_MIST which has same files (well a couple extra vfx)
  --   --"/Assets/tpp/pack//boss/ih/boss_gauge_head.fpk",

  --   --"/Assets/tpp/pack/boss/ih/TppParasite2_other_MIST.fpk",
    
  --   "/Assets/tpp/pack/boss/ih/TppParasite2_locators_4.fpk",
  -- },
  objectNames={
    "wmu_mist_ih_0000",
    "wmu_mist_ih_0001",
    "wmu_mist_ih_0002",
    "wmu_mist_ih_0003",
  },
  eventParams={
    spawnRadius=20,--ivar
    --TODO: testing zombifies=true,
    fultonable=true,
    faction="SKULL",
    weather="PARASITE_FOG",--see InfBossEvent weatherTypes
  },
}--this
return this