--mgo_fovaInfo.lua
--mgo headgear that works, mostly full headgear, using it in hairFova slot since they don't have a stand-in face like the vanilla balaclavas?
--other mgo headgear stuff either doesn't look so great without hair, or is out of position
--(see https://unknown321.github.io/mgsv_research/fv2.html for more info)
--reh_m03 has issue with nose sticking through
--others with minor protusion issues
--have nil head on those I labeled 'full cover' to counter this,
--downside is on full neck reveal bodies like swimsuit the lack will be noticable
--Some of these are just the DD headgear, but may be worth seeing if the mgo color fovas can be got woeking
local this={
  --faceFova={
  --CULL
  --normalHeadMale={"/Assets/tpp/fova/common_source/chara/cm_head/face/cm_m0_h0_v000_eye0.fv2","/Assets/tpp/pack/fova/common_source/chara/cm_head/face/cm_m0_h0_v000_eye0.fpk"},--0
  --normalHeadFemale={"/Assets/tpp/fova/common_source/chara/cm_head/face/cm_f0_h0_v000_eye0.fv2","/Assets/tpp/pack/fova/common_source/chara/cm_head/face/cm_f0_h0_v000_eye0.fpk"},-- first female head
  --pfsBalaclavaMale={"/Assets/tpp/fova/common_source/chara/cm_head/face/cm_pfs0_head_z_eye0.fv2","/Assets/tpp/pack/fova/common_source/chara/cm_head/face/cm_pfs0_head_z_eye0.fpk"},--28,--balaclava
  --},
  hairFova={
    {"/Assets/mgo/fova/chara/head/inh_m00.fv2","/Assets/mgo/pack/player/fova/inh_m00.fpk"},
    {"/Assets/mgo/fova/chara/head/inh_m01.fv2","/Assets/mgo/pack/player/fova/inh_m01.fpk"},
    {"/Assets/mgo/fova/chara/head/inh_m02.fv2","/Assets/mgo/pack/player/fova/inh_m02.fpk"},
    {"/Assets/mgo/fova/chara/head/inh_m03.fv2","/Assets/mgo/pack/player/fova/inh_m03.fpk"},
    {"/Assets/mgo/fova/chara/head/inh_m04.fv2","/Assets/mgo/pack/player/fova/inh_m04.fpk"},

    {"/Assets/mgo/fova/chara/head/reh_m00.fv2","/Assets/mgo/pack/player/fova/reh_m00.fpk"},
    {"/Assets/mgo/fova/chara/head/reh_m01.fv2","/Assets/mgo/pack/player/fova/reh_m01.fpk"},
    {"/Assets/mgo/fova/chara/head/reh_m02.fv2","/Assets/mgo/pack/player/fova/reh_m02.fpk"},
    {"/Assets/mgo/fova/chara/head/reh_m03.fv2","/Assets/mgo/pack/player/fova/reh_m03.fpk"},
    {"/Assets/mgo/fova/chara/head/reh_m04.fv2","/Assets/mgo/pack/player/fova/reh_m04.fpk"},

    {"/Assets/mgo/fova/chara/head/teh_m00.fv2","/Assets/mgo/pack/player/fova/teh_m00.fpk"},
    {"/Assets/mgo/fova/chara/head/teh_m01.fv2","/Assets/mgo/pack/player/fova/teh_m01.fpk"},
    {"/Assets/mgo/fova/chara/head/teh_m02.fv2","/Assets/mgo/pack/player/fova/teh_m02.fpk"},
    {"/Assets/mgo/fova/chara/head/teh_m03.fv2","/Assets/mgo/pack/player/fova/teh_m03.fpk"},
    {"/Assets/mgo/fova/chara/head/teh_m04.fv2","/Assets/mgo/pack/player/fova/teh_m04.fpk"},

    {"/Assets/mgo/fova/chara/body/ins_m01.fv2","/Assets/mgo/pack/player/fova/ins_m01.fpk"},
    {"/Assets/mgo/fova/chara/body/res_m01.fv2","/Assets/mgo/pack/player/fova/res_m01.fpk"},
    {"/Assets/mgo/fova/chara/body/tes_m01.fv2","/Assets/mgo/pack/player/fova/tes_m01.fpk"},

    ---
    {"/Assets/mgo/fova/chara/head/inh_f00.fv2","/Assets/mgo/pack/player/fova/inh_f00.fpk"},
    {"/Assets/mgo/fova/chara/head/inh_f01.fv2","/Assets/mgo/pack/player/fova/inh_f01.fpk"},
    {"/Assets/mgo/fova/chara/head/inh_f02.fv2","/Assets/mgo/pack/player/fova/inh_f02.fpk"},
    {"/Assets/mgo/fova/chara/head/inh_f03.fv2","/Assets/mgo/pack/player/fova/inh_f03.fpk"},
    {"/Assets/mgo/fova/chara/head/inh_f04.fv2","/Assets/mgo/pack/player/fova/inh_f04.fpk"},

    {"/Assets/mgo/fova/chara/head/reh_f00.fv2","/Assets/mgo/pack/player/fova/reh_f00.fpk"},
    {"/Assets/mgo/fova/chara/head/reh_f01.fv2","/Assets/mgo/pack/player/fova/reh_f01.fpk"},
    {"/Assets/mgo/fova/chara/head/reh_f02.fv2","/Assets/mgo/pack/player/fova/reh_f02.fpk"},
    {"/Assets/mgo/fova/chara/head/reh_f03.fv2","/Assets/mgo/pack/player/fova/reh_f03.fpk"},
    {"/Assets/mgo/fova/chara/head/reh_f04.fv2","/Assets/mgo/pack/player/fova/reh_f04.fpk"},

    {"/Assets/mgo/fova/chara/head/teh_f00.fv2","/Assets/mgo/pack/player/fova/teh_f00.fpk"},
    {"/Assets/mgo/fova/chara/head/teh_f01.fv2","/Assets/mgo/pack/player/fova/teh_f01.fpk"},
    {"/Assets/mgo/fova/chara/head/teh_f02.fv2","/Assets/mgo/pack/player/fova/teh_f02.fpk"},
    {"/Assets/mgo/fova/chara/head/teh_f03.fv2","/Assets/mgo/pack/player/fova/teh_f03.fpk"},
    {"/Assets/mgo/fova/chara/head/teh_f04.fv2","/Assets/mgo/pack/player/fova/teh_f04.fpk"},

    {"/Assets/mgo/fova/chara/body/ins_f01.fv2","/Assets/mgo/pack/player/fova/ins_f01.fpk"},
    {"/Assets/mgo/fova/chara/body/res_f01.fv2","/Assets/mgo/pack/player/fova/res_f01.fpk"},
    {"/Assets/mgo/fova/chara/body/tes_f01.fv2","/Assets/mgo/pack/player/fova/tes_f01.fpk"},
  },

  --	hairDecoFova={
  --    --tex TODO: complete textures?
  --	  {"/Assets/mgo/fova/chara/head/inh_c00.fv2","/Assets/mgo/pack/player/fova/inh_c00.fpk"},
  --    {"/Assets/mgo/fova/chara/head/inh_c01.fv2","/Assets/mgo/pack/player/fova/inh_c01.fpk"},
  --    {"/Assets/mgo/fova/chara/head/inh_c02.fv2","/Assets/mgo/pack/player/fova/inh_c02.fpk"},
  --    {"/Assets/mgo/fova/chara/head/inh_c03.fv2","/Assets/mgo/pack/player/fova/inh_c03.fpk"},
  --    {"/Assets/mgo/fova/chara/head/inh_c04.fv2","/Assets/mgo/pack/player/fova/inh_c04.fpk"},
  --    {"/Assets/mgo/fova/chara/head/inh_c05.fv2","/Assets/mgo/pack/player/fova/inh_c05.fpk"},
  --    {"/Assets/mgo/fova/chara/head/inh_c06.fv2","/Assets/mgo/pack/player/fova/inh_c06.fpk"},
  --    {"/Assets/mgo/fova/chara/head/inh_c07.fv2","/Assets/mgo/pack/player/fova/inh_c07.fpk"},
  --    {"/Assets/mgo/fova/chara/head/inh_c08.fv2","/Assets/mgo/pack/player/fova/inh_c08.fpk"},
  --    {"/Assets/mgo/fova/chara/head/inh_c09.fv2","/Assets/mgo/pack/player/fova/inh_c09.fpk"},
  --    {"/Assets/mgo/fova/chara/head/inh_c10.fv2","/Assets/mgo/pack/player/fova/inh_c10.fpk"},
  --    {"/Assets/mgo/fova/chara/head/inh_c11.fv2","/Assets/mgo/pack/player/fova/inh_c11.fpk"},
  --	},

  --DEBUGNOW integrate in InfEneFova on load somehow
  fv2Info={--DEBUGNOW name?
    ["inh_m00.fv2"]={
      description="MGO inh_m00 TACTICAL MASK",
      gender="MALE",
    },
    ["inh_m01.fv2"]={--tex DD GAS_MASK open face
      description="MGO inh_m01 RESPIRATOR",
      gender="MALE",
    },
    ["inh_m02.fv2"]={--tex similar to existing DD, but blacktop
      description="MGO inh_m02 PLATED SKI MASK",
      gender="MALE",
    },
    ["inh_m03.fv2"]={
      description="MGO inh_m03 REINFORCED FACE MASK",
      gender="MALE",
    },
    ["inh_m04.fv2"]={
      description="MGO inh_m04 SURVIVOR MASK",
      gender="MALE",
    },
    --
    ["reh_m00.fv2"]={
      description="MGO reh_m00 INTEGRATED HEADSET",
      gender="MALE",
    },
    ["reh_m01.fv2"]={--tex headphones, out of position
      description="MGO reh_m01 PILOT HEADSET",
      gender="MALE",
    },
    ["reh_m02.fv2"]={
      description="MGO reh_m02 TARGETING MONOCLE",
      gender="MALE",
    },
    ["reh_m03.fv2"]={--tex full face cover, issues with nose protusion otherwise
      description="MGO reh_m03 TARGETING HEADSET",
      gender="MALE",
    },
    ["reh_m04.fv2"]={--tex DD nvg + blacktop - GZ nvg model?
      description="MGO reh_m04 PLATED SKY MASK/NVG",
      gender="MALE",
    },
    --
    ["teh_m00.fv2"]={
      description="MGO teh_m00 HEAVY RESPIRATOR",
      gender="MALE",
    },
    ["teh_m01.fv2"]={
      description="MGO teh_m01 HELMET AND VISOR",
      gender="MALE",
    },
    ["teh_m02.fv2"]={
      description="MGO teh_m02 TYPHOON TYPE-K",
      gender="MALE",
    },
    ["teh_m03.fv2"]={--tex full face cover
      description="MGO teh_m03 V0-R 3.ES",
      gender="MALE",
    },
    ["teh_m04.fv2"]={
      description="MGO teh_m04 ARMORED RESPIRATOR",
      gender="MALE",
    },
    ---
    ["ins_m01.fv2"]={--tex not quite full face cover (neck)
      description="MGO ins_m01 SNEAKING MASK",
      gender="MALE",
    },
    ["res_m01.fv2"]={
      description="MGO res_m01 GHILLIE HOOD",
      gender="MALE",
    },
    ["tes_m01.fv2"]={
      description="MGO tes_m01 BATTLE HELMET",
      gender="MALE",
    },

    --FEMALE--
    ["inh_f00.fv2"]={
      description="MGO inh_f00 TACTICAL MASK",
      gender="FEMALE",
    },
    ["inh_f01.fv2"]={--tex DD GAS_MASK open face
      description="MGO inh_f01 RESPIRATOR",
      gender="FEMALE",
    },
    ["inh_f02.fv2"]={--tex similar to existing DD, but blacktop
      description="MGO inh_f02 PLATED SKI MASK",
      gender="FEMALE",
    },
    ["inh_f03.fv2"]={
      description="MGO inh_f03 REINFORCED FACE MASK",
      gender="FEMALE",
    },
    ["inh_f04.fv2"]={
      description="MGO inh_f04 SURVIVOR MASK",
      gender="FEMALE",
    },
    --
    ["reh_f00.fv2"]={
      description="MGO reh_f00 INTEGRATED HEADSET",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
    },
    ["reh_f01.fv2"]={--tex headphones, out of position
      description="MGO reh_f01 PILOT HEADSET",
      gender="FEMALE",
    },
    ["reh_f02.fv2"]={
      description="MGO reh_f02 TARGETING MONOCLE",
      gender="FEMALE",
    },
    ["reh_f03.fv2"]={--tex full face cover
      description="MGO reh_f03 TARGETING HEADSET",
      gender="FEMALE",
    },
    ["reh_f04.fv2"]={--tex DD nvg + blacktop - GZ nvg model?
      description="MGO reh_f04 PLATED SKY MASK/NVG",
      gender="FEMALE",
    },
    --
    ["teh_f00.fv2"]={
      description="MGO teh_f00 HEAVY RESPIRATOR",
      gender="FEMALE",
    },
    ["teh_f01.fv2"]={
      description="MGO teh_f01 HELMET AND VISOR",
      gender="FEMALE",
    },
    ["teh_f02.fv2"]={
      description="MGO teh_f02 TYPHOON TYPE-K",
      gender="FEMALE",
    },
    ["teh_f03.fv2"]={
      description="MGO teh_f03 V0-R 3.ES",
      gender="FEMALE",
    },
    ["teh_f04.fv2"]={
      description="MGO teh_f04 ARMORED RESPIRATOR",
      gender="FEMALE",
    },
    ["ins_f01.fv2"]={
      description="MGO ins_f01 SNEAKING MASK",
      gender="FEMALE",
    },
    ["res_f01.fv2"]={
      description="MGO res_f01 GHILLIE HOOD",
      gender="FEMALE",
    },
    ["tes_f01.fv2"]={
      description="MGO tes_f01 BATTLE HELMET",
      gender="FEMALE",
    },
  },--< fv2Info

  headDefinitions={
    inh_m00={
      description="MGO inh_m00 TACTICAL MASK",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="inh_m00.fv2",
      hairDecoFova=nil,
    },
    --		inh_m01={--tex DD GAS_MASK open face
    --		  description="MGO inh_m01 RESPIRATOR",
    --			gender="MALE",
    --			faceFova="cm_m0_h0_v000_eye0.fv2",
    --			faceDecoFova=nil,
    --			hairFova="inh_m01.fv2",
    --			hairDecoFova=nil,
    --		},
    --		inh_m02={--tex similar to existing DD, but blacktop
    --		  description="MGO inh_m02 PLATED SKI MASK",
    --			gender="MALE",
    --			faceFova="cm_m0_h0_v000_eye0.fv2",
    --			faceDecoFova=nil,
    --			hairFova="inh_m02.fv2",
    --			hairDecoFova=nil,
    --		},
    inh_m03={
      description="MGO inh_m03 REINFORCED FACE MASK",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="inh_m03.fv2",
      hairDecoFova=nil,
    },
    inh_m04={
      description="MGO inh_m04 SURVIVOR MASK",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="inh_m04.fv2",
      hairDecoFova=nil,
      config={
        GAS_MASK=true,
      },
    },
    --
    reh_m00={
      description="MGO reh_m00 INTEGRATED HEADSET",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="reh_m00.fv2",
      hairDecoFova=nil,
      config={
        NVG=true,
      },
    },
    --		reh_m01={--tex headphones, out of position
    --      description="MGO reh_m01 PILOT HEADSET",
    --			gender="MALE",
    --			faceFova="cm_m0_h0_v000_eye0.fv2",
    --			faceDecoFova=nil,
    --			hairFova="reh_m01.fv2",
    --			hairDecoFova=nil,
    --		},
    reh_m02={
      description="MGO reh_m02 TARGETING MONOCLE",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="reh_m02.fv2",
      hairDecoFova=nil,
      config={
        NVG=true,
      },
    },
    reh_m03={--tex full face cover, issues with nose protusion otherwise
      description="MGO reh_m03 TARGETING HEADSET",
      gender="MALE",
      faceFova=nil,--"cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="reh_m03.fv2",
      hairDecoFova=nil,
      config={
        NVG=true,
      },
    },
    --		reh_m04={--tex DD nvg + blacktop - GZ nvg model?
    --		  description="MGO reh_m04 PLATED SKY MASK/NVG",
    --			gender="MALE",
    --			faceFova="cm_m0_h0_v000_eye0.fv2",
    --			faceDecoFova=nil,
    --			hairFova="reh_m04.fv2",
    --			hairDecoFova=nil,
    --            config={
    --              HELMET=true,
    --              NVG=true,
    --            },
    --		},
    --
    teh_m00={
      description="MGO teh_m00 HEAVY RESPIRATOR",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="teh_m00.fv2",
      hairDecoFova=nil,
      config={
        GAS_MASK=true,
      },
    },
    teh_m01={
      description="MGO teh_m01 HELMET AND VISOR",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="teh_m01.fv2",
      hairDecoFova=nil,
      config={
        HELMET=true,
      },
    },
    teh_m02={
      description="MGO teh_m02 TYPHOON TYPE-K",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="teh_m02.fv2",
      hairDecoFova=nil,
      config={
        HELMET=true,
      },
    },
    teh_m03={--tex full face cover
      description="MGO teh_m03 V0-R 3.ES",
      gender="MALE",
      faceFova=nil,--"cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="teh_m03.fv2",
      hairDecoFova=nil,
      config={
        GAS_MASK=true,
      },
    },
    teh_m04={
      description="MGO teh_m04 ARMORED RESPIRATOR",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="teh_m04.fv2",
      hairDecoFova=nil,
      config={
        GAS_MASK=true,
      },
    },
    ---
    ins_m01={--tex not quite full face cover (neck)
      description="MGO ins_m01 SNEAKING MASK",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="ins_m01.fv2",
      hairDecoFova=nil,
    },
    res_m01={
      description="MGO res_m01 GHILLIE HOOD",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="res_m01.fv2",
      hairDecoFova=nil,
    },
    tes_m01={
      description="MGO tes_m01 BATTLE HELMET",
      gender="MALE",
      faceFova="cm_m0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="tes_m01.fv2",
      hairDecoFova=nil,
      config={
        HELMET=true,
      },
    },

    --FEMALE--
    inh_f00={
      description="MGO inh_f00 TACTICAL MASK",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="inh_f00.fv2",
      hairDecoFova=nil,
    },
    --    inh_f01={--tex DD GAS_MASK open face
    --      description="MGO inh_f01 RESPIRATOR",
    --      gender="FEMALE",
    --      faceFova="cm_f0_h0_v000_eye0.fv2",
    --      faceDecoFova=nil,
    --      hairFova="inh_f01.fv2",
    --      hairDecoFova=nil,
    --            config={
    --              GAS_MASK=true,
    --            },
    --    },
    --    inh_f02={--tex similar to existing DD, but blacktop
    --      description="MGO inh_f02 PLATED SKI MASK",
    --      gender="FEMALE",
    --      faceFova="cm_f0_h0_v000_eye0.fv2",
    --      faceDecoFova=nil,
    --      hairFova="inh_f02.fv2",
    --      hairDecoFova=nil,
    --    },
    inh_f03={
      description="MGO inh_f03 REINFORCED FACE MASK",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="inh_f03.fv2",
      hairDecoFova=nil,
    },
    inh_f04={
      description="MGO inh_f04 SURVIVOR MASK",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="inh_f04.fv2",
      hairDecoFova=nil,
      config={
        GAS_MASK=true,
      },
    },
    --
    reh_f00={
      description="MGO reh_f00 INTEGRATED HEADSET",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="reh_f00.fv2",
      hairDecoFova=nil,
      config={
        NVG=true,
      },
    },
    --    reh_f01={--tex headphones, out of position
    --      description="MGO reh_f01 PILOT HEADSET",
    --      gender="FEMALE",
    --      faceFova="cm_f0_h0_v000_eye0.fv2",
    --      faceDecoFova=nil,
    --      hairFova="reh_f01.fv2",
    --      hairDecoFova=nil,
    --    },
    reh_f02={
      description="MGO reh_f02 TARGETING MONOCLE",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="reh_f02.fv2",
      hairDecoFova=nil,
      config={
        NVG=true,
      },
    },
    reh_f03={--tex full face cover
      description="MGO reh_f03 TARGETING HEADSET",
      gender="FEMALE",
      faceFova=nil,--"cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="reh_f03.fv2",
      hairDecoFova=nil,
      config={
        NVG=true,
      },
    },
    --    reh_f04={--tex DD nvg + blacktop - GZ nvg model?
    --      description="MGO reh_f04 PLATED SKY MASK/NVG",
    --      gender="FEMALE",
    --      faceFova="cm_f0_h0_v000_eye0.fv2",
    --      faceDecoFova=nil,
    --      hairFova="reh_f04.fv2",
    --      hairDecoFova=nil,
    --      config={
    --        HELMET=true,
    --        NVG=true,
    --      },
    --    },
    --
    teh_f00={
      description="MGO teh_f00 HEAVY RESPIRATOR",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="teh_f00.fv2",
      hairDecoFova=nil,
      config={
        GAS_MASK=true,
      },
    },
    teh_f01={
      description="MGO teh_f01 HELMET AND VISOR",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="teh_f01.fv2",
      hairDecoFova=nil,
      config={
        HELMET=true,
      },
    },
    teh_f02={
      description="MGO teh_f02 TYPHOON TYPE-K",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="teh_f02.fv2",
      hairDecoFova=nil,
      config={
        HELMET=true,
      },
    },
    teh_f03={--tex full face cover
      description="MGO teh_f03 V0-R 3.ES",
      gender="FEMALE",
      faceFova=nil,--"cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="teh_f03.fv2",
      hairDecoFova=nil,
      config={
        GAS_MASK=true,
      },
    },
    teh_f04={
      description="MGO teh_f04 ARMORED RESPIRATOR",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="teh_f04.fv2",
      hairDecoFova=nil,
    },

    ins_f01={--tex not quite full face cover (neck)
      description="MGO ins_f01 SNEAKING MASK",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="ins_f01.fv2",
      hairDecoFova=nil,
    },
    res_f01={
      description="MGO res_f01 GHILLIE HOOD",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="res_f01.fv2",
      hairDecoFova=nil,
    },
    tes_f01={
      description="MGO tes_f01 BATTLE HELMET",
      gender="FEMALE",
      faceFova="cm_f0_h0_v000_eye0.fv2",
      faceDecoFova=nil,
      hairFova="tes_f01.fv2",
      hairDecoFova=nil,
      config={
        HELMET=true,
      },
    },
  },
}

return this
