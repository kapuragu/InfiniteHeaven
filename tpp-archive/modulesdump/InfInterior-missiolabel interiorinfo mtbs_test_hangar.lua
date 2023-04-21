--tex should be in mgs_tpp\mod\interiors
local this={
  description="Interior example: BG Hangar",--description for IH
  missionCode=30050,--missionCode this is an interior for
  packs=function(missionCode)--interior packs
    TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/free/f30050/f30050_hanger_minimal_ih.fpk"
    --TppPackList.AddMissionPack"/Assets/tpp/pack/mission2/free/f30050/f30050_interior_minimal_void.fpk"
  end,
  missionPacks={--tex packs loaded in exterior mission (for missionCode), usually just the extererior entrance switch
    --mbLayoutCode.
    [0]={"/Assets/tpp/pack/location/mtbs/pack_area/mtbs_area_ly003_cl00_ih.fpk",},--DEBUGNOW this fpk not in right place, see area packs mtbs_area_ly003_cl00
  },
  --tex switch on mb to enter interior. strictly speaking this doesn't need to have anything to do with the interior
  enterSwitchLocatorName="ext_enter_switch_cl0_plnt0_hangar_ih",--DEBUGNOW
  enterSwitchDataSet="/Assets/tpp/level/location/mtbs/block_large/ext_switches_ly03_cl00_ih.fox2",--DEBUGNOW this will be dynamic on vars.layout
  --tex interior to exterior switch, defined in an interior pack
  exitSwitchLocatorName="int_exit_switch_mtbs_hanger_test_ih",
  exitDataSetName="/Assets/tpp/level/location/mtbs/block_large/mtbs_hanger_gimmick_test_ih.fox2",
  startPos={pos={-11.600,-8.000,8.511},rotY=180},--start position, rotation in interior coordinates
  startCamera={rotX=-10,rotY=200},--optional, initial camera rotation once warped to interior
  clusterName="Command",--mb specific, the cluster this interior is supposed to be in
  plant="plnt0",--mb specific, the plant (platform) the interior is supposed to be in
  outsideExitPos={pos={-30.980, -7.000, 14.779},rotY=0},--DEBUGNOW in relation to platform center?? see GetPositionOuterInterior
}--this
return this