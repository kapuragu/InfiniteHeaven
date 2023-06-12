local this={
  type="TppVolgin2",
  name="volgin_vol0_main0",
  description="Volgin",
  packages={
    --tex mantis appears when volgin downed
    --you can simply not load the mantis packs and he wont appear, volgin will still work 
    --(VERIFY, I've had some weird back and forths with this during breaking apart and reconstructing volgin stuff, stuff loading when they in theory coulnt)
    --TODO: document any other behavior during vanilla
    "/Assets/tpp/pack/mission2/common/mis_com_mantis.fpk",--aka mants_mnt0_main0
    --TODO: combine maybe
    --but no tpp_mantis2.fox2
    --TppMantis2GameObjectLocator
    --mantis mog,mtar
    --locator
    "/Assets/tpp/pack/boss/ih/TppMantis2/mantis_mnt0_main0_gameobject.fpk",--tex not really its own boss (or is it the one true boss of tpp), but keeping naming consistanct

    --tex just parts, no gameobject
    "/Assets/tpp/pack/mission2/common/mis_com_volgin.fpk",
    --based on s10110_npc_sp.fox2
    --Gameobject
    --TppVfxFileLoader with referenced files (that aren't already in mis_com_volgin)
    --Volgin2_layers.mog
    --Volgin2_layers.mtar
    "/Assets/tpp/pack/boss/ih/TppVolgin2/TppVolgin2_gameobject.fpk",
  },
  objectNames={
    "vol_factory_0000",
  },
  eventParams={
    spawnRadius=10,--ivar
    --zombifies=true,--TODO: set false and test the boss objects zombifying ability
    fultonable=true,
    faction="SKULL",
    weather="CLOUDY",--see InfBossEvent weatherTypes
  },
}--this
return this