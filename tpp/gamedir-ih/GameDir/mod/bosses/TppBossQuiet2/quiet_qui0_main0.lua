--quiet_qui0_main0.lua
--IH TppBossQuiet2 addon
local this={
  name="quiet_qui0_main0",
  description="Quiet",
  packages={
    --tex TODO: create pftxs
    "/Assets/tpp/pack/boss/ih/TppBossQuiet2/quiet_qui0_main0.fpk",
    "/Assets/tpp/pack/boss/ih/common/boss_gauge_head.fpk",
  },
  --test stuff moved to submods
  --packages={"/Assets/tpp/pack/boss/ih/TppBossQuiet2/xqest_bossQuiet_00.fpk"},--modified light quiet quest pack
  --packages={"/Assets/tpp/pack/boss/ih/TppBossQuiet2/notquiet_qui0_main0.fpk"},--tex testing changing names of pretty much anything to see if GetQuietType changes.
    
  --tex split version of s10050_area (with added missing files) moved to submods, 
  --combined version is qui0_main0.fpk above used in release
  -- packages={
  --   "/Assets/tpp/pack/boss/ih/TppBossQuiet2/QUIET/qui0_main0_def_parts_boss.fpk",
  --   --tex also includes sr02qui_asm.mtar
  --   --and EQP_WP_Quiet_sr_010.mtar (even though EquipIdTable lists sr02qui_asm.mtar for this EQP id)
  --   "/Assets/tpp/pack/boss/ih/TppBossQuiet2/QUIET/sr02_main1_aw0_v00.fpk",
    
  --   --boss_quiet2.fox2
  --   --TppBossQuiet2Parameter (pointing to qui0_main0_def_v00.parts) and the files it points to (mtar,effects)
  --   --se_b_qui.sdf
  --   --BuddyQuiet2Facial.mtar - see TppBossQuiet2_gameobject_CAMO note
  --   "/Assets/tpp/pack/boss/ih/TppBossQuiet2/QUIET/TppBossQuiet2_gameobject_QUIET.fpk",

  --   "/Assets/tpp/pack/boss/ih/boss_gauge_head.fpk",
  --   --tex single locator
  --   "/Assets/tpp/pack/boss/ih/TppBossQuiet2/QUIET/TppBossQuiet2_BossQuietGameObjectLocator.fpk",

  --   --tex see ih_parasite_camo_other note
  --   --"/Assets/tpp/pack/boss/ih/TppBossQuiet2/QUIET/s10050_area_whittle.fpk",
  -- },
  objectNames={
    "BossQuietGameObjectLocator",
    --"BossQGameObjectLocator",
  },
}--this
return this