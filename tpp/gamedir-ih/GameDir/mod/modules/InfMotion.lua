-- InfMotion.lua
-- tex handles playing .ganis on player via Player.RequestToPlayDirectMotion
-- additional player animations can be loaded by seperate fpk with mtar and an TppPlayer2AdditionalMtarData Entity to point to the mtar.
-- (see /Assets/tpp/pack/player/motion/ih/ih_additional_motion.fpk)
-- TODO: build an addon system for it if there's interest
-- fpkdef:
-- /Assets/tpp/pack/mission2/ih/ih_additional_motion.fpk
--    TODO: document what this .mtar is, I think it's just a renamed mgoplayer_resident.mtar? DEBUGNOW
--    /Assets/tpp/motion/mtar/player2/player2_ih_additional_motion.mtar
--
-- /Assets/tpp/pack/mission2/ih/ih_additional_motion.fpkd
--    /Assets/tpp/level_asset/chara/player/game_object/player2_ih_additional_motion.fox2
--      Entity TppPlayer2AdditionalMtarData > /Assets/tpp/motion/mtar/player2/player2_ih_additional_motion.mtar

--see also: 
--bobs gani notes
--https://discord.com/channels/364177293133873153/364177950805065732/549317300256243720
--unknowns motion mod (of which this is a similar implmentatio) (see issues notes toward bottom of page)
--https://unknown321.github.io/mgsv_research/motions.html

--TODO: see if I can pull more info from TppPaz for reference

local this={}

this.registerIvars={
  "motionGroupIndex",
  "motionGaniIndex",
  "motionHold",
  "motionRepeat",
  "motionCloseMenuOnPlay",
  "motionPrintOnPlay",
  "motionWarpToOrig",
}

--menu command
function this.PlayCurrentMotionCommand()
  local closeMenuOnPlay=Ivars.motionCloseMenuOnPlay:Get()==1
  this.PlayCurrentMotion()
  if closeMenuOnPlay then
    InfMenu.MenuOff()
  end
end
InfMenuCommands.playCurrentMotionCommand={
  isMenuOff=false,--DYNAMIC
}

--ivars
this.motionGroupIndex={
  save=IvarProc.CATEGORY_EXTERNAL,
  inMission=true,
  settings={"NONE"},--DYNAMIC
  OnSelect=function(self)
    IvarProc.SetSettings(self,this.motionGroups)
  end,
  OnChange=function(self,setting)
    --tex make sure it's in bounds
    Ivars.motionGaniIndex:OnSelect()
  end,
  OnActivate=this.PlayCurrentMotionCommand,
}--motionGroupIndex

this.motionGaniIndex={
  save=IvarProc.CATEGORY_EXTERNAL,
  inMission=true,
  settings={"NONE"},--DYNAMIC
  GetSettingText=function(self,setting)
    local groupIndex=Ivars.motionGroupIndex:Get()+1
    local motionName=this.motionGroups[groupIndex]
    return motionName.." anim:"..setting
  end,
  OnSelect=function(self)
    local groupIndex=Ivars.motionGroupIndex:Get()+1
    local motionName=this.motionGroups[groupIndex]
    local motionsForGroup=this.motions[motionName]
    
    IvarProc.SetSettings(self,motionsForGroup)
  end,
  OnActivate=this.PlayCurrentMotionCommand,
}--motionGaniIndex

this.motionHold={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch"
}

this.motionRepeat={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch"
}

this.motionCloseMenuOnPlay={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",    
  OnChange=function(self,setting)
    --KLUDGE
    local isMenuOff=setting==1
    InfMenuCommands.playCurrentMotionCommand.isMenuOff=isMenuOff
    --DEBUGNOW isMenuOff not geared for ivars, cuts off settings text
    --Ivars.motionGroupIndex.isMenuOff=isMenuOff
    --Ivars.motionGaniIndex.isMenuOff=isMenuOff
  end,
}

this.motionPrintOnPlay={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch"
}

this.motionWarpToOrig={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch"
}

--<
this.registerMenus={
  "motionsMenu",
}

this.motionsMenu={
  parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
  options={
    "Ivars.motionGroupIndex",
    "Ivars.motionGaniIndex",
    "Ivars.motionHold",
    "Ivars.motionRepeat",
    "Ivars.motionCloseMenuOnPlay",
    "Ivars.motionPrintOnPlay",
    "Ivars.motionWarpToOrig",
    "InfMotion.StopMotion",
    "InfMotion.PlayCurrentMotionCommand",
  }
}
--< menu defs
-->
this.langStrings={
  eng={
    motionsMenu="Motions menu",
    motionGroupIndex="Motion group",
    motionGaniIndex="Motion number",
    motionHold="Hold motion",
    motionRepeat="Repeat motion",
    motionCloseMenuOnPlay="Close menu on Playing motion",
    motionPrintOnPlay="Print motion name on play",
    motionWarpToOrig="Warp to original position after play",
    stopMotion="Stop motion",
    playCurrentMotionCommand="Play motion",
  },
  help={
    eng={
      motionsMenu="Play different animations on player. A motion group may contain several related animations (usually lead-in, idle, lead-out)",
      motionGroupIndex="Press [ACTION] to play the selected animation.",
      motionGaniIndex="Press [ACTION] to play the selected animation.",
      motionHold="Holds motion, requires stop motion to stop.",
      motionRepeat="Repeat motion at end, some animations don't support this.",
      motionWarpToOrig="Since some animations move player position through geometry this may help to recover",
      stopMotion="Use to stop motions with motion hold or motion repeat.",
      playCurrentMotionCommand="Closes menu and plays current selected motion.",
    },
  },
}--langStrings
--<

this.motions={
  --tex looking at anims from mtar_dictionary attack, see https://github.com/TinManTex/mgsv-lookup-strings/tree/master/Strings/brutegen/mtar-gani
  --  zzTest={
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapcig/snapcig_q_ed.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapcig/snapcig_q_idl.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapcig/snapcig_q_st.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapcig/snapcig_s_ed.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapcig/snapcig_s_idl.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapcig/snapcig_s_st.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_c_b2f_l.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_c_f2b_l.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_c_idl_l.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_c_stp_l.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/enet/enetnon/enetnon_ful_idl.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snappaz/snappaz_give_book.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_dh2s_l.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_p_idl.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_s_dh_lp.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_s_idl_l.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_s_idl_r.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_s_tn_0.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_s_tn_l0.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_s2dh_l.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapplv/snapplv_s_rde_rear_st_l.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapplv/snapplv_s_rde_st_l.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapplv/snapplv_s_rde_st_r.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapplv/snapplv_s_dve_ed_b.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapplv/snapplv_s_dve_lp_b.gani",
  --    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapplv/snapplv_s_dve_st_b.gani",
  --  },
  missionClearMotion={"/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_f_idl7.gani"},
  missionClearMotionFob={
    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapnon/snapnon_s_win_idl.gani",
  },
  end_of_snapdam_s_die_idl_l={
    "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapdam/snapdam_s_die_idl_l.gani",
  },
  --REF mgo AppealActions.lua --DEBUGNOW
  Salute={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snambud/snambud_s_slt_start_l.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snambud/snambud_s_slt_idl_l.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snambud/snambud_s_slt_ed_l.gani"
  },

  VenomSnake={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snambud/snambud_s_fst_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snambud/snambud_s_fst_idl_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snambud/snambud_s_fst_ed.gani"
  },

  Ocelot={
    "/Assets/mgo/motion/SI_game/fani/bodies/ocep/ocepbud/ocepbud_s_slt_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/ocep/ocepbud/ocepbud_s_slt_idl_l.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/ocep/ocepbud/ocepbud_s_slt_ed.gani"
  },

  QuietThumbsUpGood={
    "/Assets/mgo/motion/SI_game/fani/bodies/quip/quipnon/quipnon_s_good_st_l.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/quip/quipnon/quipnon_s_good_idl_l.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/quip/quipnon/quipnon_s_good_ed_l.gani"
  },

  MaruSign={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_6_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_6_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  BatsuSign={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_7_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_7_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  DVolunteer={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_9_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_9_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  DBow={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_8_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_8_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  Push={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_23_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_23_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  Disappointed={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_16_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_16_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  StandAttention={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_21_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_21_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  GratitudeBow={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_22_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_22_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  Karate={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_20_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_20_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  KungFu={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_18_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_18_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  BodyBuilderFrontChest={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_1_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_1_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  BodyBuilderSideChest={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_2_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_2_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  RollDanceUp={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_3_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_3_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  RollDanceSide={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_4_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_4_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },


  RollDanceDown={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_5_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_5_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  UDanceUp={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_25_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_25_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  UDanceSide={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_26_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_26_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  LDanceUp={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_28_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_28_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  LDanceSide={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_29_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_29_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  GutsPose={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_17_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_17_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  SuperSUp={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_10_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_10_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  SuperSSide={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_11_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_11_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"
  },

  Pointing={
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_19_st.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_19_lp.gani",
    "/Assets/mgo/motion/SI_game/fani/bodies/snam/snamidl/snamidl_s_ed.gani"},
}--motions

--tex lua tables with keys aren't iterated in the order they are defined
--and just sort by alpha, IHDev_AddMotions can override the order with it's own motionGroups
this.motionGroups={}
for name,ganis in pairs(this.motions)do
  this.motionGroups[#this.motionGroups+1]=name
end
table.sort(this.motionGroups)

function this.PlayCurrentMotion()
  --tex: kinda needed when hold is on otherwise new anim will not play
  --but causes RequestToPlayDirectMotion to not fire, TODO:: yield/wait a frame?
  --Player.RequestToStopDirectMotion()
  
  local motionGroupIndex=Ivars.motionGroupIndex:Get()
  local motionGaniIndex=Ivars.motionGaniIndex:Get()
  
  local motionName=this.motionGroups[motionGroupIndex+1]

  --param2Table
  local ganiPath=this.motions[motionName][motionGaniIndex+1]
  
  if Ivars.motionPrintOnPlay:Is(1)then
    --truncated motionName: groupName: ganiIndex
    --DEBUGNOW
    local slashIndex = string.find(ganiPath, "/[^/]*$")
    local ganiFileName = slashIndex~=nil and ganiPath:sub(slashIndex+1) or ganiPath
    TppUiCommand.AnnounceLogView(motionName.." "..motionGaniIndex..": "..ganiFileName)
  end
  
  local holdMotion=Ivars.motionHold:Get()==1
  local unk3GameObjectTargetName=""
  local unk4CNPTargetName=""--tex attachment stuff
  local unk5MTPTargetName=""--tex attachment stuff, the legacy CameraSubjectiveParams has --   attachPointName   = "MTP_GLOBAL_A", with    attachType      = "GlobalMotionPoint", above
  local repeatMotion=Ivars.motionRepeat:Get()==1
  local param2Table={
    ganiPath,--or state name, ex stateDirectPlayRideRearLeftSeatOnVehicle
    holdMotion,
    unk3GameObjectTargetName,
    unk4CNPTargetName,
    unk5MTPTargetName,
    repeatMotion,
  }

  --tex RequestToPlayDirectMotion actually takes varargs of param2Tables, it plays through everything in order provided the previous one ends/doesnt hold
  --motionName doesnt seem to matter, possibly you can use it for Stop?
  Player.RequestToPlayDirectMotion{motionName,param2Table}
  --REF
  --  Player.RequestToPlayDirectMotion {
  --    "rideVehicleRear",
  --    {
  --      "/Assets/tpp/motion/SI_game/fani/bodies/snap/snapplv/snapplv_s_rde_rear_st_l.gani",
  --      false,
  --      "vehs_citadel_0001",
  --      "CNP_ppos_c",
  --      "MTP_GLOBAL_C",
  --      true
  --    },
  --    {
  --      "stateDirectPlayRideRearLeftSeatOnVehicle",
  --      true,
  --      "vehs_citadel_0001",
  --      "CNP_ppos_c",
  --      "MTP_GLOBAL_C",
  --      true
  --    }
  --  }

  --REF
  --  Player.RequestToPlayDirectMotion{
  --    "handBookToPaz",
  --    {
  --      actionPath,
  --      false,
  --      pazLocator,
  --      "Move",
  --      "MTP_GLOBAL_C",
  --      false
  --    }
  --  }
  if Ivars.motionWarpToOrig:Is(1)then
    if not this.playerPos then
      this.playerPos={vars.playerPosX,vars.playerPosY,vars.playerPosZ,vars.playerRotY}
    end
  end
end--PlayCurrentMotion

function this.StopMotion()
  --tex theres some interesting queue type thing going on here, if you trigger a bunch of RequestToStopDirectMotion, 
  --RequestToPlayDirectMotion will not play untill you've called it the same(?) amount of times you Stopped it.
  Player.RequestToStopDirectMotion()
  if this.playerPos then
    TppPlayer.Warp{pos={this.playerPos[1],this.playerPos[2],this.playerPos[3]},rotY=this.playerPos[4]}
    this.playerPos=nil
  end
end

--Commands for quick menu
function this.NextGroup()
  InfMenu.ChangeSetting(Ivars.motionGroupIndex,1)
end
function this.PrevGroup()
  InfMenu.ChangeSetting(Ivars.motionGroupIndex,-1)
end

function this.NextMotion()
  InfMenu.ChangeSetting(Ivars.motionGaniIndex,1)
end
function this.PrevMotion()
  InfMenu.ChangeSetting(Ivars.motionGaniIndex,-1)
end

function this.PlayNextGroupMotion()
  InfMenu.ChangeSetting(Ivars.motionGroupIndex,1)
  this.PlayCurrentMotion()
end
function this.PlayPrevGroupMotion()
  InfMenu.ChangeSetting(Ivars.motionGroupIndex,-1)
  this.PlayCurrentMotion()
end

function this.PlayNextMotion()
  InfMenu.ChangeSetting(Ivars.motionGaniIndex,1)
  this.PlayCurrentMotion()
end
function this.PlayPrevMotion()
  InfMenu.ChangeSetting(Ivars.motionGaniIndex,-1)
  this.PlayCurrentMotion()
end

this.packages={
  "/Assets/tpp/pack/player/motion/ih/ih_additional_motion.fpk",
}

function this.AddMissionPacks(missionCode,packPaths)
  for i,packPath in ipairs(this.packages) do
    packPaths[#packPaths+1]=packPath
  end
end

function this.Messages()
	return Tpp.StrCode32Table{
		Player = {
      {
        msg="DirectMotion",--after Player.RequestToPlayDirectMotion is called
        func=function(animName,animStage,isFinished)
          if Ivars.motionWarpToOrig:Is(1) then
            if not Ivars.motionHold:Is(1) then
              if isFinished==1 then
                if this.playerPos then
                  TppPlayer.Warp{pos={this.playerPos[1],this.playerPos[2],this.playerPos[3]},rotY=this.playerPos[4]}
                  this.playerPos=nil
                end
              end
            end
          end
        end
      },
		},
	}
end

function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
	Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText)
end

function this.Init(missionTable)
	this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

return this
