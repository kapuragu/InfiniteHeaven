--camo_wmu1_main0.lua
--IH TppBossQuiet2 addon
local this={
  name="camo_wmu1_main0",
  description="Camo Parasite",
  packages={
    --tex TODO: create pftxs
    "/Assets/tpp/pack/boss/ih/TppBossQuiet2/camo_wmu1_main0.fpk",
    "/Assets/tpp/pack/boss/ih/common/boss_gauge_head.fpk",
  },
  --tex s10130 split up to get an idea of whats involved, has been moved to submods
  --combined version is wmu1_main0.fpk above used in release
  -- packages={
  --   --tex main .parts and the files it references
  --   "/Assets/tpp/pack/boss/ih/TppBossQuiet2/CAMO/wmu1_main0_def_parts_boss.fpk",
  --   --tex unlike TppParasite2 which references weapon .parts in it gameobect parameters, 
  --   --TppBossQuiet2 doent, it most likely uses the TppEquip system instead
  --   "/Assets/tpp/pack/boss/ih/TppBossQuiet2/weapons/sr02_main1_aw0_v00.fpk",
  --   "/Assets/tpp/pack/boss/ih/TppBossQuiet2/weapons/sr02_main1_aw2_v00.fpk",
  --   "/Assets/tpp/pack/boss/ih/TppBossQuiet2/weapons/bl03_main0_def.fpk",
    
  --   --gameobject definition (parasite_camo.fox2 > TppCamoParasiteGameObject) and the files it references
  --   --gameobject locators (parasite_camo.fox2) TODO: split out
  --   --TppFemaleFacial.mtar - even though theres no ref to it in fpkd TODO: I don't actually know how it's referenced in vanilla, QUIET has BuddyQuiet2Facial
  --   "/Assets/tpp/pack/boss/ih/TppBossQuiet2/CAMO/TppBossQuiet2_gameobject_CAMO.fpk",
    
  --   "/Assets/tpp/pack/boss/ih/boss_gauge_head.fpk",
    
  --   "/Assets/tpp/pack/boss/ih/TppBossQuiet2/CAMO/TppBossQuiet2_sound_wmu.fpk",
    
  --   "/Assets/tpp/pack/boss/ih/zombie_asset.fpk",
  
  --   --tex whatevers left over from splitting out the rest from the initial pack (which was s10130 + including more files that were refed in fox2,.parts)
  --   --so may just be other stuff orphaned from non camo .fox2/parts files I initially culled, 
  --   --or may be referenced in some other way (ala tppequip system)
  --   --TODO: can mtar/ganis ref fx that aren't referenced via fox2/data?
  --   --OFF "/Assets/tpp/pack/boss/ih/TppBossQuiet2/CAMO/ih_parasite_camo_other.fpk",
  -- },
  objectNames={
    "TppBossQuiet2_ih_0000",
    "TppBossQuiet2_ih_0001",
    "TppBossQuiet2_ih_0002",
    "TppBossQuiet2_ih_0003",
  },

  eventParams={
    --tex since camos start moving to route when activated, and closest cp may not be that discoverable
    --or their positions even that good, spawn at player pos in a close enough radius that they spot player
    --they'll then be aiming at player when they reach the cp
    --TODO: alternatively try triggering StartCombat on camo spawn
    --tex player will get hit pretty quick if this is far enough for sniper shot 
    --could just DisableFight till SetInitialRoute, 
    --or shorten time till SetInitialRoute
    --closer they will drop a nade instead
    --
    spawnRadius=10,
    zombifies=true,--TODO: set false and test the boss objects zombifying ability
    fultonable=true,--TODO:
    faction="SKULL",
    weather="PARASITE_FOG",--see InfBossEvent weatherTypes
  },
}--this
return this