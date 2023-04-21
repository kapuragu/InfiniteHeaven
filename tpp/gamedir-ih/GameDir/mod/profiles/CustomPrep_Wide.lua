--tex Custom Enemy Prep Configs
--In-game Custom Prep Configs are built by choosing random values between the min,max options.
--This only sets up the Prep config, Enemy prep mode must still be set to Custom in the menu.

--tex widest range of randomization
local this={
  description="Custom Prep - Random",
  profile={
    --Custom prep menu
    reinforceCount_MIN=1,--{ 1-99 } -- Reinforce calls min
    reinforceCount_MAX=5,--{ 1-99 } -- Reinforce calls max
    reinforceLevel_MIN="NONE",--{ NONE, SUPER_REINFORCE, BLACK_SUPER_REINFORCE } -- Vehicle reinforcement level min
    reinforceLevel_MAX="BLACK_SUPER_REINFORCE",--{ NONE, SUPER_REINFORCE, BLACK_SUPER_REINFORCE } -- Vehicle reinforcement level max
    revengeIgnoreBlocked_MIN=0,--{ 0-1 } -- Ignore combat-deploy supply blocks min
    revengeIgnoreBlocked_MAX=1,--{ 0-1 } -- Ignore combat-deploy supply blocks max
    --Weapon deployment
    SNIPER_MIN=0,--{ 0-100 } --  (percentage)
    SNIPER_MAX=100,--{ 0-100 } --  (percentage)
    MISSILE_MIN=0,--{ 0-100 } --  (percentage)
    MISSILE_MAX=100,--{ 0-100 } --  (percentage)
    MG_MIN=0,--{ 0-100 } --  (percentage)
    MG_MAX=100,--{ 0-100 } --  (percentage)
    SHOTGUN_MIN=0,--{ 0-100 } --  (percentage)
    SHOTGUN_MAX=100,--{ 0-100 } --  (percentage)
    SMG_MIN=0,--{ 0-100 } --  (percentage)
    SMG_MAX=100,--{ 0-100 } --  (percentage)
    ASSAULT_MIN=0,--{ 0-100 } --  (percentage)
    ASSAULT_MAX=100,--{ 0-100 } --  (percentage)
    GUN_LIGHT_MIN=0,--{ 0-100 } --  (percentage)
    GUN_LIGHT_MAX=100,--{ 0-100 } --  (percentage)
    --Armor deployment
    ARMOR_MIN=0,--{ 0-100 } --  (percentage)
    ARMOR_MAX=100,--{ 0-100 } --  (percentage)
    SOFT_ARMOR_MIN=0,--{ 0-100 } --  (percentage)
    SOFT_ARMOR_MAX=100,--{ 0-100 } --  (percentage)
    SHIELD_MIN=0,--{ 0-100 } --  (percentage)
    SHIELD_MAX=100,--{ 0-100 } --  (percentage)
    --Headgear deployment
    HELMET_MIN=0,--{ 0-100 } --  (percentage)
    HELMET_MAX=100,--{ 0-100 } --  (percentage)
    NVG_MIN=0,--{ 0-100 } --  (percentage)
    NVG_MAX=100,--{ 0-100 } --  (percentage)
    GAS_MASK_MIN=0,--{ 0-100 } --  (percentage)
    GAS_MASK_MAX=100,--{ 0-100 } --  (percentage)
    --CP deterrent deployment
    DECOY_MIN=0,--{ 0-100 } --  (percentage)
    DECOY_MAX=100,--{ 0-100 } --  (percentage)
    MINE_MIN=0,--{ 0-100 } --  (percentage)
    MINE_MAX=100,--{ 0-100 } --  (percentage)
    CAMERA_MIN=0,--{ 0-100 } --  (percentage)
    CAMERA_MAX=100,--{ 0-100 } --  (percentage)
    --Soldier abilities
    STEALTH_MIN="NONE",--{ NONE, LOW, HIGH, SPECIAL } -- Adjusts enemy soldiers notice,cure,reflex and speed ablilities.
    STEALTH_MAX="SPECIAL",--{ NONE, LOW, HIGH, SPECIAL } --
    COMBAT_MIN="NONE",--{ NONE, LOW, HIGH, SPECIAL } -- Adjusts enemy soldiers shot,grenade,reload,hp and speed abilities.
    COMBAT_MAX="SPECIAL",--{ NONE, LOW, HIGH, SPECIAL } --
    HOLDUP_MIN="NONE",--{ NONE, LOW, HIGH, SPECIAL } --
    HOLDUP_MAX="SPECIAL",--{ NONE, LOW, HIGH, SPECIAL } --
    FULTON_MIN="NONE",--{ NONE, LOW, HIGH, SPECIAL } --
    FULTON_MAX="SPECIAL",--{ NONE, LOW, HIGH, SPECIAL } --
    --Weapon strength menu
    STRONG_WEAPON_MIN=0,--{ 0-1 } --
    STRONG_WEAPON_MAX=1,--{ 0-1 } --
    STRONG_SNIPER_MIN=0,--{ 0-1 } --
    STRONG_SNIPER_MAX=1,--{ 0-1 } --
    STRONG_MISSILE_MIN=0,--{ 0-1 } --
    STRONG_MISSILE_MAX=1,--{ 0-1 } --
    --CP equip strength menu
    ACTIVE_DECOY_MIN=0,--{ 0-1 } --
    ACTIVE_DECOY_MAX=1,--{ 0-1 } --
    GUN_CAMERA_MIN=0,--{ 0-1 } --
    GUN_CAMERA_MAX=1,--{ 0-1 } --
  }
}
return this