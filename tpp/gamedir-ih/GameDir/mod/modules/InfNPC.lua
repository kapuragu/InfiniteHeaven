--InfNPC.lua
--tex manages hostage entity npcs on mother base
local this={}

--LOCALOPT
local InfMain=InfMain
local NULL_ID=GameObject.NULL_ID
local GetGameObjectId=GameObject.GetGameObjectId
local SendCommand=GameObject.SendCommand

this.debugModule=false

this.numHostages=30--4--SYNC num locators--DEBUGWIP

this.hostageNames=InfUtil.GenerateNameList("ih_hostage_%04d",this.numHostages)
this.npcInfo={}

this.registerIvars={
  "mbAdditionalNpcs",
}

this.registerMenus={
  "mbAdditionalNpcsMenu",
}

--tex filled out below
this.mbAdditionalNpcsMenu={
  options={
  }
}

-- CULL
this.mbAdditionalNpcs={
  save=IvarProc.CATEGORY_EXTERNAL,
  range=Ivars.switchRange,
  settingNames="set_switch",
  MissionCheck=IvarProc.MissionCheckMbAll,
}

this.mbNpcTypes={
  "NURSE_3_FEMALE",
  "DOCTOR_0",
  "DDS_RESEARCHER",
  "DDS_RESEARCHER_FEMALE",
  "DDS_GROUNDCREW",
  "CHILD_0",
  "KAZ",
}

local ivarPrefix = "mbNpc_"

for i,npcType in ipairs(this.mbNpcTypes)do
  local ivarName = ivarPrefix..npcType
  local ivar={
    save=IvarProc.CATEGORY_EXTERNAL,
    range=Ivars.switchRange,
    settingNames="set_switch",
    MissionCheck=IvarProc.MissionCheckMbAll,
  }
  this[ivarName]=ivar
  this.registerIvars[#this.registerIvars+1]=ivarName
  local menuOptions=this.mbAdditionalNpcsMenu.options
  menuOptions[#menuOptions+1]="InfNPC."..ivarName
end

--IN/SIDE:this.mbNpcTypes
function this.IsMbAdditionalNpcsEnabled(missionCode)
  local isEnabled=false
  for i,npcType in ipairs(this.mbNpcTypes)do
    local ivarName = ivarPrefix..npcType
    if Ivars[ivarName]:EnabledForMission() then
      isEnabled=true
      break
    end
  end
  return isEnabled
end

--< ivar defs
this.langStrings={
  eng={
    mbAdditionalNpcs="Additional NPCs",--CULL
    mbAdditionalNpcsMenu="Additional NPCs menu",
    mbNpc_NURSE_3_FEMALE="Female nurse",
    mbNpc_DOCTOR_0="Male doctor",
    mbNpc_DDS_RESEARCHER="Male researcher",
    mbNpc_DDS_RESEARCHER_FEMALE="Female researcher",
    mbNpc_DDS_GROUNDCREW="Male groundcrew",
    mbNpc_CHILD_0="Children",
    mbNpc_KAZ="Kaz Miller",
  },
  help={
    eng={
      mbAdditionalNpcs="Adds different NPCs standing around mother base, including ground crew, researchers and Miller.",
    },
  }
}

function this.PostModuleReload(prevModule)
  this.npcInfo=prevModule.npcInfo
end

function this.AddMissionPacks(missionCode,packPaths)
  if not this.IsMbAdditionalNpcsEnabled(missionCode) then
    return
  end

  if missionCode==30250 then--tex TODO no idea what is going on on quarantine, getting NULL_IDs for hostages
    --DEBUGNOW return
  end
  
  local placement=this.npcPositions[missionCode]
  if placement==nil then
    return
  end

  if InfMainTpp.IsMbEvent(missionCode) then
    return
  end

  --tex TODO: a bit janky putting this here DEBUGNOW likely asking for trouble if user continues with an ih_save with different options than the mission was initially loaded with
  this.npcInfo=this.BuildNPCInfo(missionCode)
  if this.debugModule then
    InfCore.PrintInspect(this.npcInfo,"npcInfo")
  end

  local bodyTypes={}
  for hostageName,npcInfo in pairs(this.npcInfo)do
    bodyTypes[npcInfo.bodyType]=true
  end
  for bodyType,bool in pairs(bodyTypes)do
    local bodyInfo=InfBodyInfo.bodyInfo[bodyType]
    if bodyInfo and bodyInfo.partsPathHostage then
      InfEneFova.AddBodyPackPaths(bodyInfo,"HOSTAGE")
    end
  end
  if this.debugModule then
    InfCore.PrintInspect(bodyTypes,"bodyTypes")
  end

  --DEBUGNOW document why
  local hostageMob=true
  if hostageMob then
    packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage2mob.fpk"
    packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage2mob_def12.fpk"
    packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage_loc30.fpk"
  else
    packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage_def.fpk"
    packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage_loc30.fpk"
  end

  if TppHostage2.SetUniquePartsPath then
    local uniquePartsPath={}
    for hostageName,npcInfo in pairs(this.npcInfo)do
      local bodyInfo=InfBodyInfo.bodyInfo[npcInfo.bodyType]
      if bodyInfo and bodyInfo.partsPathHostage then
        uniquePartsPath[hostageName]=bodyInfo.partsPathHostage
      end
    end

    for locatorName,parts in pairs(uniquePartsPath)do
      TppHostage2.SetUniquePartsPath{gameObjectType="TppHostage2",locatorName=locatorName,parts=parts}
    end
    if this.debugModule then
      InfCore.PrintInspect(uniquePartsPath,"uniquePartsPath")
    end

    local settings={}
    for hostageName,npcInfo in pairs(this.npcInfo)do
      if npcInfo.bodyId or npcInfo.faceId then
        settings[#settings+1]={type="hostage",name=hostageName,bodyId=npcInfo.bodyId,faceId=npcInfo.faceId}
      end
    end
    if #settings>0 then
      TppEneFova.AddUniqueSettingPackage(settings)
    end
  end--TppHostage2.SetUniquePartsPath


end--AddMissionPacks

--CULL
function this.AddMissionPacksEx(missionCode,packPaths)
  --TODO: running into the crash from quit from title after exiting from load with just
  --          packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/common/mis_com_mafr_hostage.fpk"
  --        packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage_def.fpk"
  --        packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage_loc4.fpk"
  --changelog says I fixed similar issue in r179, but I don't remeber how lol
  --but comparing r179 r178 it seems I did remove hostage entitie defs from f30050_npc.fox2

  packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage_base.fpk"

  packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/prs2_main0_mdl.fpk"
  packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/dds4_main0_mdl.fpk"
  local hostageMob=true
  if hostageMob then
    packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage2mob.fpk"
    packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage2mob_def12.fpk"
    packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage_loc30.fpk"
  else
    packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage_def.fpk"
    packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/ih/ih_hostage_loc30.fpk"
  end

  --packPaths[#packPaths+1]="/Assets/tpp/pack/mission2/common/mis_com_mafr_hostage.fpk"

  local uniquePartsPath={
    --ih_hostage_0000="/Assets/tpp/parts/chara/prs/prs2_main0_def_v00_ih_hos.parts",
    ih_hostage_0000="/Assets/tpp/parts/chara/dds/dds4_main0_def_v00_ih_hos.parts",
  }
  for locatorName,parts in pairs(uniquePartsPath)do
  -- TppHostage2.SetUniquePartsPath{gameObjectType="TppHostage2",locatorName=locatorName,parts=parts}
  end

  local settings={
    {type="hostage",name="ih_hostage_0000",bodyId=300,faceId="male"},
    {type="hostage",name="ih_hostage_0001",bodyId=301,faceId="female"},
    {type="hostage",name="ih_hostage_0002",bodyId=302},
    {type="hostage",name="ih_hostage_0003",bodyId=303},
  }
  -- TppEneFova.AddUniqueSettingPackage(settings)


  if TppHostage2.SetHostageType then
  --    TppHostage2.SetHostageType{gameObjectType="TppHostageUnique",hostageType="Volgin"}
  --    TppHostage2.SetHostageType{gameObjectType="TppHostage2",hostageType="Parasite"}
  --TppHostage2.SetHostageType{gameObjectType="TppHostage2",hostageType="NoStand"}
  --TppHostage2.SetHostageType{gameObjectType="TppHostage2",hostageType="Mob"}
  end
end--AddMissionPacksEx

function this.Init(missionTable)
  this.messageExecTable=nil

  if not this.IsMbAdditionalNpcsEnabled() then
    return
  end

  if InfMainTpp.IsMbEvent() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())

  --tex TODO don't know if I want uniques on a random cluster or the first the player loads on
  --probably better to be random, but have uniques in a few prominant positions
  for npcType,bool in pairs(this.uniqueChars)do
    local ivarName = ivarPrefix..npcType
    if Ivars[ivarName]:EnabledForMission() then
      this.npcOnClusters[npcType]=MotherBaseStage.GetFirstCluster()--ALT math.random(0,6)
    end
  end
  InfCore.PrintInspect(this.npcOnClusters,"InfNPC.npcOnClusters")

  this.InitCluster()
end--Init

function this.OnReload(missionTable)
  this.messageExecTable=nil

  if not this.IsMbAdditionalNpcsEnabled() then
    return
  end

  if InfMainTpp.IsMbEvent() then
    return
  end

  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.Messages()
  return Tpp.StrCode32Table{
    MotherBaseStage={
      --{msg="MotherBaseCurrentClusterLoadStart",func=this.MotherBaseCurrentClusterLoadStart},
      {msg="MotherBaseCurrentClusterActivated",func=this.MotherBaseCurrentClusterActivated},
    },
  }
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end


--tex used to limit unique charaters to one cluster so they dont magically transport to other clusters as you do
this.npcOnClusters={}

--tex buch of these  too short/repeating with too specific action to make good idle
this.motionPaths={
  --OFF  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_a_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_b_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_c_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_d_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_e_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_f_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_g_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_h_idl.gani",
  --OFF  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_i_idl.gani",--clutching side,
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_j_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_k_idl.gani",
--OFF  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_l_idl.gani",
--OFF  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_m_idl.gani",
--OFF "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_guilty_ish_idl.gani",--leaning over quite a bit
}

this.motionPathsSleeping={
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_01_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_02_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_03_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_01_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/ptn0/ptn0/ptn0_cutn_02_idl.gani",
}

--tex TODO: find mtar these are in
this.moreMotionPaths={
  "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_guilty_a_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_guilty_b_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_guilty_c_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_guilty_a_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_guilty_b_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_guilty_a_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_guilty_a_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/dct0/dct0/dct0_tuto_idl.gani",
  "/Assets/tpp/motion/SI_game/fani/bodies/nrs0/nrs0/nrs0_tuto_idl.gani",
}

--REF cluster order InfMain.CLUSTER_DEFINE, from 0
--tex TODO these positions are only for layout 3
--TODO more positions - lower decks, next to walker gears, inner positions on non main plats
--[clusterId][platId]
this.npcPositions={
  [30050]={
    --command
    {
      --main
      {
        {pos={-15.070,20.800,24.918},rotY=176.028,},--command looking at code talker orig pos
        {pos={-1.389,24.802,4.863},rotY=-0.044,}, --command upper helipad under eaves
        {pos={-8.524,24.800,-2.706},rotY=-57.954,},--upper looking toward intel dome
        {pos={6.174,24.825,-5.242},rotY=93.085,},--outside core door overlooking command plats
        {pos={0.997,20.800,-1.294},rotY=17.494,},--
        {pos={22.476,0.800,1.900},rotY=155.419,},--
        {pos={20.986,0.800,-2.108},rotY=-34.112,},--
        {pos={10.943,0.800,20.757},rotY=39.755,},--
        {pos={18.199,0.800,20.015},rotY=91.617,},--
        {pos={20.078,0.800,21.038},rotY=60.013,},--
        {pos={-12.544,0.800,24.727},rotY=-83.662,},--
        {pos={-19.198,0.798,28.951},rotY=-2.266,},--
        {pos={-32.830,0.798,15.040},rotY=-124.140,},--
        {pos={-18.755,0.800,-5.655},rotY=-170.810,},--
        {pos={-8.265,0.800,-1.633},rotY=-80.527,},--
        {pos={-17.946,0.800,4.842},rotY=-92.019,},--
        {pos={-7.051,0.800,19.366},rotY=-147.335,},--
        {pos={-4.819,0.800,-19.002},rotY=-25.023,},--
        {pos={0.799,0.800,-18.767},rotY=66.884,},--
        {pos={-19.555,4.800,-18.518},rotY=-144.732,},--
        {pos={-22.456,4.800,-7.170},rotY=-40.297,},--
        {pos={-14.467,4.800,20.937},rotY=34.957,},--
        {pos={24.396,8.800,0.053},rotY=90.567,},--
        {pos={13.745,12.800,26.653},rotY=42.258,},--
        {pos={-17.262,12.800,2.391},rotY=45.731,},--
        {pos={-15.061,12.800,-17.886},rotY=114.731,},--
        {pos={-1.819,12.800,-5.867},rotY=148.967,},--
        {pos={23.391,12.800,-2.974},rotY=104.796,},--
        {pos={-7.582,16.800,-4.632},rotY=-159.934,},--
        {pos={-23.082,16.800,-8.944},rotY=-66.051,},--
        {pos={-8.004,20.800,-3.626},rotY=-121.567,},--
        {pos={12.717,0.800,-28.643},rotY=-154.735,},--command lower helipad in square looking out
      },
      {--command plat 1
        {pos={115.799,0.800,-4.337},rotY=115.064,},--next to walker pos
        {pos={138.609,-3.200,14.213},rotY=-106.014,},--
        {pos={133.789,-3.200,21.330},rotY=-59.577,},--
        {pos={127.105,-3.200,10.110},rotY=75.833,},--
        {pos={88.830,0.800,18.599},rotY=-95.874,},--
        {pos={83.394,0.862,26.296},rotY=-59.053,},--
        {pos={101.831,0.798,-32.518},rotY=-179.963,},--
        {pos={124.208,0.800,-29.460},rotY=-55.440,},--
        {pos={134.706,0.800,-28.546},rotY=113.276,},--
        {pos={137.220,0.798,-32.362},rotY=-177.108,},--
        {pos={146.694,0.800,-20.950},rotY=-15.898,},--
        {pos={119.408,0.800,13.611},rotY=106.680,},--
        {pos={147.830,0.800,3.533},rotY=77.999,},--helipad left side
      },
      {--command plat 2
        {pos={234.865,0.800,-58.714},rotY=-29.576,},--next to walker pos
        {pos={204.471,0.800,-45.697},rotY=7.381,},
        {pos={218.293,0.798,-44.346},rotY=64.339,},
        {pos={226.915,0.798,-47.749},rotY=51.977,},
        {pos={190.294,0.800,-92.213},rotY=-136.231,},
        {pos={174.578,-0.204,-86.219},rotY=-61.783,},
        {pos={186.005,0.796,-97.328},rotY=-167.162,},
        {pos={192.986,0.800,-105.771},rotY=178.287,},
        {pos={204.433,0.798,-118.630},rotY=-175.011,},
        {pos={208.691,0.863,-123.608},rotY=-72.476,},
        {pos={248.138,0.797,-85.541},rotY=94.239,},
        {pos={238.400,0.800,-73.211},rotY=-71.482,},
        {pos={247.675,0.797,-85.869},rotY=167.248,},--helipad right
      },
      {--command plat 3
        {pos={204.471,0.800,-45.697},rotY=7.381,},
        {pos={218.293,0.798,-44.346},rotY=64.339,},
        {pos={226.915,0.798,-47.749},rotY=51.977,},
        {pos={234.865,0.800,-58.714},rotY=-29.576,},
        {pos={190.294,0.800,-92.213},rotY=-136.231,},
        {pos={174.578,-0.204,-86.219},rotY=-61.783,},
        {pos={186.005,0.796,-97.328},rotY=-167.162,},
        {pos={192.986,0.800,-105.771},rotY=178.287,},
        {pos={204.433,0.798,-118.630},rotY=-175.011,},
        {pos={208.691,0.863,-123.608},rotY=-72.476,},
        {pos={248.138,0.797,-85.541},rotY=94.239,},
        {pos={238.400,0.800,-73.211},rotY=-71.482,},
        {pos={325.164,0.800,-53.336},rotY=9.314,},
        {pos={328.353,0.800,-54.714},rotY=172.036,},
        {pos={309.296,0.798,-37.986},rotY=-15.134,},
        {pos={305.851,0.800,-52.341},rotY=-70.063,},
        {pos={310.881,0.800,-51.147},rotY=97.076,},
        {pos={321.217,0.798,-34.227},rotY=-8.461,},
        {pos={319.174,0.798,-99.535},rotY=-146.480,},
        {pos={305.833,-0.202,-92.193},rotY=-77.814,},
        {pos={298.470,0.863,-73.032},rotY=-45.055,},
        {pos={341.044,0.800,-95.255},rotY=-106.012,},
        {pos={361.274,0.863,-99.274},rotY=-177.263,},
        {pos={363.431,0.800,-88.255},rotY=77.581,},
        {pos={363.373,0.798,-72.880},rotY=85.897,},
        {pos={364.583,0.800,-65.446},rotY=93.349,},
        {pos={375.331,0.800,-55.283},rotY=6.301,},
        {pos={355.675,0.798,-34.692},rotY=8.389,},
        {pos={322.791,4.800,-46.608},rotY=52.401,},--top of that vehicle lift square thing --ELEVATED
      },
    },
    --combat
    {
      {
        {pos={1107.550,0.800,-613.607},rotY=-129.872,},--eaves med side
        {pos={1094.703,-0.202,-604.137},rotY=-62.551,},--ground outer walkway overlook med
        {pos={1125.146,0.800,-581.443},rotY=-33.777,},--eaves r&d
        {pos={1150.264,0.800,-592.433},rotY=-33.450,},--walker pos
        {pos={1154.808,0.800,-602.553},rotY=-34.242,},--shower
        {pos={1110.128,0.800,-607.906},rotY=113.499,},--passageway 2doors
        {pos={1135.134,4.800,-608.884},rotY=145.496,},--f1 entrance
        {pos={1142.560,9.800,-596.879},rotY=141.275,},--f2 raised plat elec cabinet
        {pos={1121.479,8.800,-600.558},rotY=-31.299,},--f2 eaves bridge overlook
        {pos={1128.686,8.800,-607.253},rotY=-133.662,},--f2 eaves doorcubby
        {pos={1117.558,4.800,-598.112},rotY=-51.426,},--f2 doorway power switch bridge overlook
        {pos={1133.797,28.850,-610.000},rotY=158.761,},--topf overlook
        {pos={1128.498,28.850,-609.337},rotY=-109.123,},--topf overlook2
        {pos={1118.996,28.800,-601.950},rotY=-47.131,},--topf overlook3
        {pos={1135.354,28.850,-605.245},rotY=126.098,},--topf overlook4
        {pos={1155.885,0.800,-626.247},rotY=130.847,},--combat main helipad
      },
      {
        {pos={1136.231,0.798,-760.292},rotY=-131.025,},
        {pos={1164.339,0.797,-760.095},rotY=137.074,},
        {pos={1176.423,0.798,-722.209},rotY=57.170,},
        {pos={1161.336,0.800,-702.536},rotY=-16.442,},
        {pos={1132.828,-0.200,-716.895},rotY=67.930,},
        {pos={1129.153,-0.200,-723.359},rotY=-150.462,},
        {pos={1110.214,0.798,-715.511},rotY=-12.713,},
        {pos={1115.899,-0.204,-704.599},rotY=39.451,},
        {pos={1120.087,0.800,-726.070},rotY=119.111,},
        {pos={1113.951,0.800,-734.504},rotY=-159.593,},
        {pos={1110.210,0.798,-734.563},rotY=-51.364,},
        {pos={1113.700,0.800,-749.054},rotY=160.958,},
        {pos={1122.059,0.800,-759.076},rotY=85.150,},
        {pos={1129.141,0.800,-754.043},rotY=83.206,},
        {pos={1148.184,0.800,-741.441},rotY=-169.141,},
        {pos={1147.399,0.800,-737.192},rotY=177.510,},
        {pos={1146.073,0.800,-761.718},rotY=-151.643,},--combat plat1 helipad
      },
      {
        {pos={1203.959,0.798,-801.051},rotY=-70.144,},
        {pos={1200.518,-0.202,-816.577},rotY=-118.528,},
        {pos={1220.292,0.800,-830.370},rotY=160.825,},
        {pos={1233.519,0.800,-843.444},rotY=-104.589,},
        {pos={1244.820,0.798,-848.294},rotY=119.332,},
        {pos={1254.436,0.798,-832.956},rotY=75.549,},
        {pos={1272.714,0.797,-814.587},rotY=60.580,},
        {pos={1277.865,0.863,-808.936},rotY=101.152,},
        {pos={1273.467,0.800,-799.590},rotY=13.103,},
        {pos={1262.964,0.800,-789.172},rotY=4.427,},
        {pos={1264.676,0.800,-801.014},rotY=174.399,},
        {pos={1256.255,0.800,-810.974},rotY=-152.949,},
        {pos={1260.909,0.800,-803.276},rotY=-38.561,},
        {pos={1252.221,-3.200,-825.910},rotY=119.013,},
        {pos={1232.150,-3.200,-834.191},rotY=-107.594,},
        {pos={1225.118,-3.200,-826.665},rotY=-7.313,},
        {pos={1247.724,-3.200,-832.050},rotY=148.350,},
        {pos={1245.051,-3.200,-826.208},rotY=-99.049,},
        {pos={1237.473,-3.200,-827.814},rotY=-14.614,},
        {pos={1243.325,-3.200,-816.283},rotY=44.295,},
        {pos={1226.480,1.800,-816.368},rotY=-132.600,},
        {pos={1262.262,0.800,-827.466},rotY=116.030,},--combat plat2 helipad
        {pos={1252.925,4.800,-807.273},rotY=-134.806,},--next to walker pos, top of that vehicle lift square thing --ELEVATED
      },
      {
        {pos={1325.596,0.862,-809.458},rotY=-111.525,},
        {pos={1331.508,-0.202,-818.257},rotY=-136.790,},
        {pos={1343.193,0.798,-827.269},rotY=172.595,},
        {pos={1367.144,0.800,-824.292},rotY=50.663,},
        {pos={1382.682,0.800,-824.386},rotY=-141.340,},
        {pos={1381.831,0.798,-762.808},rotY=-24.482,},
        {pos={1358.548,0.798,-761.567},rotY=31.563,},
        {pos={1334.964,0.798,-766.588},rotY=-63.610,},
        {pos={1329.044,0.800,-783.836},rotY=-98.876,},
        {pos={1347.949,-3.200,-771.547},rotY=15.303,},
        {pos={1342.862,-3.200,-792.030},rotY=-124.407,},
        {pos={1345.345,-3.200,-784.520},rotY=-36.817,},
        {pos={1369.686,0.800,-814.022},rotY=-106.066,},
        {pos={1371.479,1.800,-806.825},rotY=-85.575,},
        {pos={1378.243,1.800,-778.822},rotY=-14.375,},
        {pos={1390.848,0.800,-791.756},rotY=107.475,},--combat plat3 helipad
      },
    },
    --develop
    {
      --main
      {
        --r&d aipod/sahel pit
        --researcher, ground crew, characters
        {pos={1186.687,20.798,317.456},rotY=-108.292,},--
        {pos={1184.219,20.798,310.037},rotY=17.097,},--
        {pos={1181.865,20.798,321.180},rotY=21.767,},--
        {pos={1187.345,21.803,320.608},rotY=101.350,},--
        {pos={1191.868,21.803,322.071},rotY=-128.473,},--
        {pos={1192.484,21.803,320.006},rotY=-94.921,},--
        {pos={1191.019,23.050,329.068},rotY=-134.593,except={KAZ=true}},--ELEVATED
        {pos={1173.625,22.014,314.806},rotY=85.081,except={KAZ=true}},--ELEVATED

        {pos={1195.339,28.800,328.074},rotY=-134.556,},--overlooking pit
        {pos={1178.531,28.800,306.269},rotY=53.914,},--overlooking pit2
        {pos={1177.293,28.800,291.906},rotY=47.236,},--upper, machine with screen
        {pos={1199.309,24.800,305.900},rotY=48.848,},--between buildings two doors on walkway
        {pos={1201.835,16.800,304.952},rotY=-103.831,},--between buildings two doors on walkway one lower
        {pos={1191.951,16.800,298.702},rotY=-145.436,},--between buildings two doors on walkway one lower2
        {pos={1203.078,15.800,293.779},rotY=111.954,},--covered passage next to door
        {pos={1180.676,8.800,285.566},rotY=-137.589,},--covered passage2 looking over bridge
        {pos={1160.131,20.800,298.772},rotY=-110.381,},--walkway overlooking mb
        {pos={1168.636,20.800,288.161},rotY=-137.489,},--walkway overlooking bridge
        {pos={1169.538,12.800,300.118},rotY=38.722,},--covered passage3
        {pos={1161.451,12.800,297.225},rotY=-145.108,},--walkway overlooking bridge2

        {pos={1208.461,0.800,329.816},rotY=-13.650,},--r and d main helipad
        {pos={1195.817,32.800,281.671},rotY=87.793,},--upper helipad
        {pos={1192.044,32.800,277.948},rotY=-171.377,},--upper helipad2
      },
      {
        {pos={1277.597,0.863,310.668},rotY=-31.779,},
        {pos={1282.262,0.818,302.036},rotY=-116.126,},
        {pos={1284.291,-0.202,293.358},rotY=-145.761,},
        {pos={1290.720,-0.204,286.609},rotY=-62.022,},
        {pos={1297.732,0.798,284.273},rotY=-143.647,},
        {pos={1319.827,0.798,284.158},rotY=-141.387,},
        {pos={1333.638,0.798,284.185},rotY=-164.967,},
        {pos={1346.191,0.862,290.646},rotY=128.793,},
        {pos={1342.503,0.798,310.309},rotY=65.308,},
        {pos={1332.506,0.800,347.855},rotY=-37.947,},
        {pos={1312.552,0.798,349.632},rotY=-12.315,},
        {pos={1301.329,0.798,350.219},rotY=-70.887,},
        {pos={1293.108,0.798,345.948},rotY=-29.919,},
        {pos={1284.924,0.800,331.622},rotY=-0.126,},
        {pos={1344.188,0.800,320.030},rotY=74.442,},--r and d plat1 helipad
      },
      {
        {pos={1374.242,0.862,250.514},rotY=140.896,},
        {pos={1371.685,-0.202,239.837},rotY=-105.542,},
        {pos={1381.463,0.796,220.248},rotY=177.202,},
        {pos={1393.823,0.800,210.292},rotY=-33.721,},
        {pos={1400.452,0.800,203.313},rotY=118.525,},
        {pos={1413.629,0.800,200.535},rotY=77.592,},
        {pos={1428.363,0.798,215.289},rotY=160.572,},
        {pos={1444.478,0.797,230.451},rotY=84.900,},
        {pos={1448.300,0.863,235.129},rotY=102.540,},
        {pos={1443.786,0.800,245.041},rotY=35.653,},
        {pos={1431.270,0.798,260.370},rotY=32.830,},
        {pos={1423.655,0.798,268.634},rotY=-12.349,},
        {pos={1412.187,0.798,273.994},rotY=-2.486,},
        {pos={1402.948,0.798,274.042},rotY=-50.924,},
        {pos={1397.353,0.800,267.173},rotY=-39.188,},
        {pos={1398.265,0.800,256.625},rotY=-143.310,},
        {pos={1432.527,0.800,216.973},rotY=161.896,},--r and d plat2 helipad
      },
      {
        {pos={1495.865,0.863,243.180},rotY=88.531,},
        {pos={1501.755,0.798,230.287},rotY=-127.470,},
        {pos={1514.123,0.798,216.664},rotY=-168.384,},
        {pos={1524.492,0.796,218.580},rotY=142.080,},
        {pos={1548.316,0.800,218.898},rotY=136.032,},
        {pos={1563.759,0.798,225.385},rotY=75.696,},
        {pos={1559.748,0.798,245.426},rotY=109.788,},
        {pos={1553.230,0.798,281.376},rotY=54.528,},
        {pos={1531.231,0.800,280.270},rotY=13.560,},
        {pos={1518.477,0.798,282.730},rotY=-49.173,},
        {pos={1510.614,0.798,279.024},rotY=25.070,},
        {pos={1500.889,0.800,268.740},rotY=175.479,},
        {pos={1561.935,0.800,252.879},rotY=151.662,},--r and d plat3 helipad
      },
    },
    --support
    {
      --main
      {
        --support main basement plants
        --researcher,characters?
        --may look a bit odd if theyre standing right on rats in sideop lol
        {pos={359.289,-4.013,858.222},rotY=141.763,except={DDS_GROUNDCREW=true},},--
        {pos={359.289,-4.013,858.222},rotY=141.763,except={DDS_GROUNDCREW=true},},--
        {pos={357.656,-4.013,851.733},rotY=-50.512,except={DDS_GROUNDCREW=true},},--
        {pos={356.429,-4.013,854.618},rotY=-88.528,except={DDS_GROUNDCREW=true},},--
        {pos={367.299,-4.013,848.299},rotY=135.103,except={DDS_GROUNDCREW=true},},--
        {pos={368.424,-4.013,858.881},rotY=48.018,except={DDS_GROUNDCREW=true},},--
        {pos={375.046,-4.013,857.026},rotY=-141.125,except={DDS_GROUNDCREW=true},},--
        {pos={374.705,-4.013,849.362},rotY=-133.565,except={DDS_GROUNDCREW=true},},--
        {pos={383.712,-4.013,848.737},rotY=-179.609,except={DDS_GROUNDCREW=true},},--
        {pos={386.119,-4.013,848.781},rotY=59.610,except={DDS_GROUNDCREW=true},},--
        {pos={382.996,-4.013,854.479},rotY=-61.963,except={DDS_GROUNDCREW=true},},--
        {pos={384.038,-4.013,856.722},rotY=-10.950,except={DDS_GROUNDCREW=true},},--
        {pos={383.189,-4.013,858.506},rotY=-59.514,except={DDS_GROUNDCREW=true},},--
        {pos={385.162,-4.013,866.424},rotY=7.842,except={DDS_GROUNDCREW=true},},--
        {pos={385.165,-4.013,866.444},rotY=7.842,except={DDS_GROUNDCREW=true},},--
        {pos={385.693,-4.013,869.991},rotY=-90.079,except={DDS_GROUNDCREW=true},},--
        {pos={376.689,-4.013,869.225},rotY=-119.923,except={DDS_GROUNDCREW=true},},--
        {pos={374.893,-4.013,867.593},rotY=-92.707,except={DDS_GROUNDCREW=true},},--
        {pos={373.922,-4.013,869.923},rotY=-28.713,except={DDS_GROUNDCREW=true},},--
        {pos={376.726,-4.013,873.906},rotY=58.588,except={DDS_GROUNDCREW=true},},--
        {pos={377.633,-4.013,875.342},rotY=94.696,except={DDS_GROUNDCREW=true},},--
        {pos={377.983,-4.013,877.740},rotY=97.864,except={DDS_GROUNDCREW=true},},--
        {pos={374.927,-4.013,878.589},rotY=-103.341,except={DDS_GROUNDCREW=true},},--
        {pos={368.466,-4.013,878.475},rotY=-93.801,except={DDS_GROUNDCREW=true},},--
        {pos={366.398,-4.013,876.562},rotY=-146.038,except={DDS_GROUNDCREW=true},},--
        {pos={367.723,-4.013,874.678},rotY=148.694,except={DDS_GROUNDCREW=true},},--
        {pos={368.381,-4.013,871.281},rotY=-169.474,except={DDS_GROUNDCREW=true},},--
        {pos={366.352,-4.013,868.006},rotY=157.874,except={DDS_GROUNDCREW=true},},--
        {pos={360.848,-4.013,865.974},rotY=-111.549,except={DDS_GROUNDCREW=true},},--
        {pos={357.787,-4.013,867.672},rotY=-40.737,except={DDS_GROUNDCREW=true},},--
        {pos={358.161,-4.013,873.142},rotY=34.323,except={DDS_GROUNDCREW=true},},--
        {pos={356.977,-4.013,876.269},rotY=-34.293,except={DDS_GROUNDCREW=true},},--
        {pos={359.478,-4.013,878.751},rotY=97.053,except={DDS_GROUNDCREW=true},},--
        --
        {pos={373.573,0.800,875.099},rotY=-70.262,},--next to walker gear pos
        {pos={360.768,0.800,882.319},rotY=-86.415,},--elevator ground floor

        {pos={368.465,0.800,893.759},rotY=12.324,},--support main helipad
      },
      {
        {pos={431.465,0.863,929.112},rotY=176.466,},
        {pos={450.969,-0.202,921.021},rotY=167.034,},
        {pos={470.952,0.796,933.839},rotY=77.359,},
        {pos={478.371,0.800,943.100},rotY=44.455,},
        {pos={486.443,0.800,949.330},rotY=58.444,},
        {pos={492.929,0.798,961.996},rotY=57.775,},
        {pos={476.013,0.798,975.497},rotY=49.680,},
        {pos={457.430,0.797,994.060},rotY=8.971,},
        {pos={446.401,0.800,1003.425},rotY=-3.852,},
        {pos={443.795,0.800,994.276},rotY=-85.276,},
        {pos={422.221,0.798,975.818},rotY=-79.336,},
        {pos={416.763,0.798,964.638},rotY=-60.796,},
        {pos={418.701,0.800,950.486},rotY=135.895,},
        {pos={471.727,0.800,982.474},rotY=77.610,},--support plat1 helipad
      },
      {
        {pos={453.677,0.862,1044.683},rotY=80.412,},
        {pos={463.109,-0.202,1051.247},rotY=111.782,},
        {pos={472.193,0.798,1064.120},rotY=159.669,},
        {pos={467.024,0.800,1083.464},rotY=-1.272,},
        {pos={467.420,0.800,1102.511},rotY=167.150,},
        {pos={460.261,0.800,1109.446},rotY=-44.826,},
        {pos={443.062,0.798,1109.224},rotY=-38.548,},
        {pos={412.316,0.863,1108.975},rotY=-22.846,},
        {pos={407.936,0.800,1084.150},rotY=-116.734,},
        {pos={405.962,0.798,1078.522},rotY=-67.481,},
        {pos={405.889,0.798,1067.320},rotY=-124.456,},
        {pos={415.834,0.798,1049.751},rotY=-125.797,},
        {pos={419.500,0.800,1072.480},rotY=174.635,},
        {pos={428.408,0.800,1071.177},rotY=108.713,},
        {pos={415.732,0.800,1070.258},rotY=60.741,},
        {pos={436.188,0.800,1110.676},rotY=7.540,},--support plat2 helipad
        {pos={429.681,4.800,1073.251},rotY=92.522,},--top of that vehicle lift square thing --ELEVATED
      },
      {
        {pos={376.474,0.800,1134.658},rotY=-133.018,},
        {pos={381.167,-0.202,1164.788},rotY=31.940,},
        {pos={375.063,0.798,1169.920},rotY=-5.370,},
        {pos={364.181,0.798,1181.967},rotY=45.792,},
        {pos={347.885,0.800,1193.249},rotY=149.692,},
        {pos={341.867,0.798,1197.949},rotY=10.368,},
        {pos={324.910,0.798,1179.745},rotY=-98.190,},
        {pos={308.829,0.797,1163.967},rotY=-98.852,},
        {pos={305.546,0.798,1149.910},rotY=-109.249,},
        {pos={324.583,0.798,1128.825},rotY=-176.507,},
        {pos={330.651,0.798,1126.015},rotY=169.849,},
        {pos={337.865,0.798,1121.280},rotY=-170.618,},
        {pos={351.706,0.800,1123.064},rotY=16.014,},
        {pos={320.024,0.800,1176.748},rotY=-113.860,},--support plat3 helipad
      },
    },
    --medical
    {
      --main
      {
        --medical main
        --researcher, ground crew, characters
        {pos={-158.877,0.800,-960.767},rotY=-142.092,},--eaves, closest to helipad
        {pos={-161.945,0.800,-951.129},rotY=-36.057,},--eaves, building close to helipad
        {pos={-123.737,0.800,-938.880},rotY=24.794,},--eaves, next to bridge to mb center
        {pos={-111.897,0.800,-958.830},rotY=-172.163,},--eaves next to shower
        {pos={-142.571,0.800,-951.048},rotY=-36.968,},--courtyard next to door
        {pos={-142.906,0.800,-941.532},rotY=154.804,},--courtyard door2
        {pos={-127.209,0.800,-943.385},rotY=-89.710,},--courtyard eaves
        {pos={-147.908,12.800,-939.036},rotY=76.442,},--upper next to door where soldiers usually pile up
        {pos={-123.740,8.800,-957.702},rotY=-88.836,},--rooftop fire doors
        {pos={-154.079,8.800,-954.621},rotY=169.767,},--rooftop fire doors2
        {pos={-139.890,-0.204,-919.139},rotY=8.916,},--med main outer railing looking toward command
        {pos={-156.534,0.800,-980.978},rotY=-124.673,},--med plat0 helipad
      },
      {
        {pos={-138.783,0.862,-1044.349},rotY=-2.699,},
        {pos={-131.378,0.800,-1038.492},rotY=32.843,},
        {pos={-145.807,-0.202,-1049.659},rotY=-87.569,},
        {pos={-157.142,0.798,-1062.534},rotY=-83.638,},
        {pos={-156.983,0.798,-1082.252},rotY=-95.604,},
        {pos={-153.214,0.800,-1096.211},rotY=157.181,},
        {pos={-149.573,0.862,-1111.157},rotY=-169.429,},
        {pos={-144.427,0.800,-1106.890},rotY=95.719,},
        {pos={-128.660,0.800,-1101.798},rotY=9.470,},
        {pos={-102.729,0.797,-1107.548},rotY=171.901,},
        {pos={-93.296,0.800,-1082.692},rotY=77.798,},
        {pos={-91.304,0.798,-1066.248},rotY=71.483,},
        {pos={-94.925,0.798,-1054.751},rotY=32.654,},
        {pos={-104.973,0.800,-1049.605},rotY=-106.255,},
        {pos={-120.652,0.800,-1109.467},rotY=-173.912,},--med plat1 helipad
      },
      {
        {pos={-184.527,0.863,-1145.055},rotY=92.736,},
        {pos={-189.799,0.862,-1140.001},rotY=20.340,},
        {pos={-197.510,0.798,-1140.549},rotY=22.331,},
        {pos={-208.861,-0.204,-1136.494},rotY=-48.768,},
        {pos={-221.612,0.796,-1147.717},rotY=-55.543,},
        {pos={-230.073,0.800,-1159.061},rotY=70.372,},
        {pos={-245.420,0.798,-1168.671},rotY=-91.377,},
        {pos={-245.139,0.798,-1179.785},rotY=-168.417,},
        {pos={-229.412,0.798,-1190.122},rotY=-102.813,},
        {pos={-210.940,0.797,-1209.359},rotY=159.224,},
        {pos={-206.047,0.863,-1213.409},rotY=-166.749,},
        {pos={-197.971,0.862,-1213.224},rotY=151.132,},
        {pos={-180.892,0.798,-1196.651},rotY=141.160,},
        {pos={-175.741,0.798,-1192.297},rotY=127.112,},
        {pos={-168.562,0.798,-1179.738},rotY=89.348,},
        {pos={-166.421,0.798,-1168.731},rotY=8.470,},
        {pos={-175.504,0.800,-1160.422},rotY=31.964,},
        {pos={-223.789,0.800,-1198.227},rotY=-155.437,},--med plat2 helipad
      },
      {
        {pos={-206.123,0.836,-1264.635},rotY=-80.713,},
        {pos={-215.721,-0.202,-1267.686},rotY=-5.063,},
        {pos={-223.800,0.798,-1299.246},rotY=-62.554,},
        {pos={-224.207,0.798,-1316.645},rotY=-116.820,},
        {pos={-215.986,0.798,-1328.489},rotY=131.760,},
        {pos={-213.068,0.800,-1325.088},rotY=106.812,},
        {pos={-194.186,0.798,-1325.216},rotY=148.770,},
        {pos={-157.983,0.798,-1288.445},rotY=81.695,},
        {pos={-158.241,0.798,-1283.597},rotY=14.232,},
        {pos={-165.707,0.798,-1268.229},rotY=15.556,},
        {pos={-176.822,0.800,-1266.974},rotY=162.419,},
        {pos={-223.789,0.800,-1198.227},rotY=-155.437,},--med plat3 helipad looking toward sunset
      },
    },
    --intel
    {
      --main
      {
        --intel main
        --researcher, ground crew, characters?
        {pos={-698.130,4.925,530.658},rotY=59.610,},--outer mid 3 light doohickey
        {pos={-689.036,4.925,546.251},rotY=75.332,},--intel main lower power boards
        {pos={-686.236,8.800,542.537},rotY=145.050,},--inner lower machine with screen
        {pos={-692.792,8.800,535.372},rotY=28.452,},--inner lower beside door
        {pos={-668.694,16.800,534.313},rotY=173.543,},--inner mid looking out
        {pos={-671.383,27.800,543.246},rotY=-110.593,},--inner top looking at dome
        {pos={-673.428,27.800,535.440},rotY=154.124,},--inner top right looking out
        {pos={-680.678,27.800,526.692},rotY=124.719,},--inner top left looking out
        {pos={-655.239,4.800,538.215},rotY=143.736,},--outer mid, next to walker pos/looking out
        {pos={-657.063,4.800,530.029},rotY=-161.525,},--outer mid power box thing
        {pos={-704.688,0.800,555.878},rotY=-54.961,},--intel main helipad
      },
      {
        {pos={-683.935,0.862,623.558},rotY=-120.053,},
        {pos={-677.182,0.862,626.550},rotY=155.923,},
        {pos={-664.561,-0.204,634.484},rotY=86.695,},
        {pos={-658.781,0.798,644.318},rotY=128.491,},
        {pos={-663.531,0.800,667.459},rotY=138.355,},
        {pos={-662.323,0.800,679.270},rotY=13.255,},
        {pos={-679.318,0.800,684.524},rotY=-156.893,},
        {pos={-686.327,0.798,690.023},rotY=36.592,},
        {pos={-712.491,0.797,690.082},rotY=-31.663,},
        {pos={-719.058,0.863,690.116},rotY=-32.491,},
        {pos={-727.530,0.800,688.932},rotY=-66.259,},
        {pos={-722.558,0.800,664.427},rotY=-135.955,},
        {pos={-724.825,0.798,652.294},rotY=-127.748,},
        {pos={-721.121,0.798,639.311},rotY=-69.770,},
        {pos={-714.165,0.798,629.849},rotY=168.083,},
        {pos={-709.827,0.800,631.045},rotY=74.593,},
        {pos={-704.851,0.800,638.004},rotY=9.775,},
        {pos={-694.680,0.800,691.468},rotY=41.650,},--intel plat1 helipad
      },
      {
        {pos={-753.006,0.862,723.643},rotY=88.875,},
        {pos={-751.139,0.800,734.714},rotY=89.055,},
        {pos={-752.187,0.798,749.214},rotY=20.115,},
        {pos={-765.945,0.798,762.948},rotY=78.795,},
        {pos={-783.090,0.863,778.520},rotY=9.783,},
        {pos={-791.145,0.862,780.561},rotY=-17.901,},
        {pos={-803.053,0.831,761.543},rotY=-31.473,},
        {pos={-825.173,0.798,730.834},rotY=-68.031,},
        {pos={-803.238,0.798,706.838},rotY=-107.451,},
        {pos={-789.028,0.798,699.893},rotY=-150.406,},
        {pos={-777.042,0.800,707.003},rotY=174.386,},
        {pos={-810.317,0.800,757.305},rotY=-94.442,},--intel plat2 helipad
      },
      {
        {pos={-790.986,0.863,825.991},rotY=-103.854,},
        {pos={-766.235,0.800,845.237},rotY=114.593,},
        {pos={-767.699,0.831,865.313},rotY=-30.940,},
        {pos={-768.194,0.800,883.222},rotY=-143.745,},
        {pos={-773.079,0.798,894.807},rotY=-20.986,},
        {pos={-828.535,0.800,880.583},rotY=-94.138,},
        {pos={-828.389,0.800,855.063},rotY=-126.848,},
        {pos={-820.036,0.798,830.863},rotY=-151.904,},
        {pos={-812.437,0.800,831.687},rotY=-88.868,},
        {pos={-800.825,0.800,892.441},rotY=21.630,},--intel plat3 helipad
      },
    },
    --basedev
    {
      --main
      {
        {pos={-723.933,8.800,-365.184},rotY=132.996,},--basedev core overlooking medical
        {pos={-749.970,8.800,-355.458},rotY=-34.118,},--basedev mid by stacked railings
        {pos={-763.970,8.800,-354.248},rotY=-14.224,},--basedev mid, under roof by drums
        {pos={-768.742,4.946,-350.953},rotY=-47.044,},--ramp corner
        {pos={-716.225,0.800,-390.044},rotY=-11.991,},--by AA
        {pos={-764.672,0.800,-403.081},rotY=-150.380,},--next to bridge
        {pos={-716.225,0.800,-390.044},rotY=-11.991,},--elevator bottom
        {pos={-725.471,7.800,-385.384},rotY=-90.869,},--elevator top
        {pos={-750.509,0.800,-357.305},rotY=69.679,},--lower super corridoor window
        {pos={-750.342,0.800,-363.388},rotY=103.299,},--lower super corridoor electric box
        {pos={-753.762,0.800,-350.529},rotY=-151.057,},--generator/power switch
        {pos={-763.874,0.800,-344.187},rotY=-73.664,},--aa gatling
        {pos={-769.075,0.800,-355.836},rotY=57.417,},--shower
        {pos={-777.260,0.800,-375.675},rotY=-65.203,},--basedev main helipad
      },
      {
        {pos={-809.038,0.862,-433.559},rotY=13.130,},
        {pos={-828.574,-0.204,-430.413},rotY=11.690,},
        {pos={-853.012,0.798,-450.207},rotY=-51.910,},
        {pos={-860.909,0.798,-459.189},rotY=-68.420,},
        {pos={-865.750,0.862,-472.422},rotY=-87.838,},
        {pos={-857.044,0.800,-472.945},rotY=112.450,},
        {pos={-847.203,0.798,-485.074},rotY=-129.687,},
        {pos={-812.314,0.800,-500.846},rotY=131.603,},
        {pos={-803.775,0.800,-492.550},rotY=107.029,},
        {pos={-791.301,0.798,-481.864},rotY=92.597,},
        {pos={-786.136,0.798,-472.102},rotY=68.477,},
        {pos={-791.816,0.800,-456.659},rotY=84.864,},
        {pos={-842.464,0.800,-491.712},rotY=-120.655,},--basedev plat1 helipad
      },
      {
        {pos={-912.061,0.863,-471.934},rotY=126.545,},
        {pos={-929.235,0.800,-447.866},rotY=13.143,},
        {pos={-954.313,0.800,-449.136},rotY=-91.840,},
        {pos={-965.767,0.800,-449.257},rotY=-58.540,},
        {pos={-976.527,0.798,-471.266},rotY=-84.841,},
        {pos={-975.313,0.863,-504.489},rotY=-127.285,},
        {pos={-966.221,0.800,-509.504},rotY=170.831,},
        {pos={-946.757,0.798,-511.116},rotY=175.259,},
        {pos={-923.786,0.798,-507.118},rotY=154.710,},
        {pos={-918.301,0.800,-496.598},rotY=29.466,},
        {pos={-977.710,0.800,-482.065},rotY=-72.800,},--basedev plat2 helipad
        {pos={-953.322,0.800,-483.266},rotY=78.458,},--next to walker pos
      },
      {
        {pos={-1010.840,0.862,-539.909},rotY=17.512,},
        {pos={-1023.284,-0.202,-536.118},rotY=-59.743,},
        {pos={-1036.997,0.798,-540.355},rotY=-86.563,},
        {pos={-1046.374,0.796,-552.014},rotY=-74.971,},
        {pos={-1064.587,0.798,-569.437},rotY=-124.111,},
        {pos={-1060.559,0.800,-578.911},rotY=168.407,},
        {pos={-1045.347,0.798,-594.118},rotY=-125.317,},
        {pos={-1013.855,0.800,-606.683},rotY=144.647,},
        {pos={-1000.283,0.798,-596.203},rotY=112.146,},
        {pos={-988.158,0.798,-578.757},rotY=129.455,},
        {pos={-995.015,0.800,-559.584},rotY=45.337,},
        {pos={-995.015,0.800,-559.584},rotY=45.337,},
        {pos={-1043.576,0.800,-597.933},rotY=-131.106,},--basedev plat3 helipad
      },
    },
  },--30050
  [30250]={--DEBUGNOW
    --mbqf == cluster 7
    [7+1]={
      {
        {pos={-155.161,-7.200,-2063.335},rotY=49.298,},
        {pos={-155.011,-7.200,-2067.285},rotY=-134.627,},
        {pos={-162.716,-7.200,-2075.680},rotY=-139.864,},
        {pos={-168.453,-7.200,-2070.586},rotY=-139.288,},
        {pos={-175.123,-7.200,-2071.572},rotY=132.980,},
        {pos={-180.935,-7.200,-2078.616},rotY=-131.512,},
        {pos={-178.374,-7.200,-2084.976},rotY=179.492,},
        {pos={-172.121,-7.200,-2087.185},rotY=23.254,},
        {pos={-169.952,-7.200,-2083.988},rotY=-36.362,},
        {pos={-172.771,-7.149,-2081.732},rotY=167.903,},
        {pos={-174.780,-7.149,-2080.283},rotY=173.339,},
        {pos={-164.886,-7.200,-2063.989},rotY=132.591,},
        {pos={-159.083,-7.200,-2087.196},rotY=-42.694,},
        {pos={-179.338,-7.200,-2084.911},rotY=156.660,},
        {pos={-151.286,-7.200,-2081.400},rotY=24.541,},
      },
    },
  },--30250
  [30150]={
    --zoo, not actually cluster 8
    [8+1]={
      {
        {pos={-19.249,0.800,5.989},rotY=85.676,},
        {pos={12.335,0.800,17.288},rotY=-160.875,},
        {pos={14.245,0.800,-15.325},rotY=-38.620,},
        {pos={3.564,-3.513,-10.822},rotY=-30.248,},
        {pos={-10.346,-3.513,0.896},rotY=109.120,},
        {pos={2.233,-3.513,10.487},rotY=-170.305,},
        {pos={-16.873,-2.700,-7.689},rotY=68.108,},
        {pos={7.960,-2.700,-16.461},rotY=-31.902,},
        {pos={-1.580,8.769,-17.771},rotY=35.003,},
        {pos={-4.853,8.769,17.847},rotY=-156.173,},
        {pos={-16.736,0.800,-18.829},rotY=38.733,},
        {pos={93.585,0.800,-6.641},rotY=97.682,},
        {pos={94.844,0.800,16.963},rotY=129.065,},
        {pos={126.264,0.800,10.860},rotY=-120.884,},
        {pos={134.279,0.800,-16.810},rotY=-77.322,},
        {pos={111.402,1.545,-1.367},rotY=-20.154,},
        {pos={125.255,1.545,-1.651},rotY=-168.656,},
        {pos={113.891,1.545,-8.475},rotY=-90.969,},
        {pos={96.933,-2.700,-14.501},rotY=73.360,},
        {pos={104.854,-2.700,-19.713},rotY=25.877,},
        {pos={132.086,-2.700,-16.869},rotY=-68.235,},
        {pos={127.593,-2.763,-1.218},rotY=-23.812,},
        {pos={104.606,-2.700,16.584},rotY=-165.125,},
        {pos={-74.464,1.545,-85.940},rotY=-42.429,},
        {pos={-69.130,0.800,-108.945},rotY=-39.873,},
        {pos={-76.534,0.800,-112.518},rotY=31.378,},
        {pos={-106.675,0.800,-92.216},rotY=86.637,},
        {pos={-89.385,0.800,-72.649},rotY=143.841,},
        {pos={-77.910,0.800,-69.484},rotY=-178.828,},
        {pos={-79.232,-2.700,-70.471},rotY=-143.911,},
        {pos={-66.896,-3.513,-83.022},rotY=-166.519,},
        {pos={-87.381,-2.763,-84.385},rotY=-141.571,},
        {pos={-95.137,-2.700,-103.280},rotY=20.644,},
        {pos={-80.748,-2.700,-106.749},rotY=29.140,},
        {pos={-57.973,-3.513,-84.002},rotY=-139.375,},
        {pos={-73.513,0.800,86.027},rotY=-132.168,},
        {pos={-85.794,1.545,82.193},rotY=-59.053,},
        {pos={-93.155,1.545,74.802},rotY=-57.901,},
        {pos={-100.733,1.545,84.846},rotY=56.758,},
        {pos={-99.350,0.800,97.364},rotY=148.989,},
        {pos={-108.993,0.800,75.557},rotY=119.362,},
        {pos={-100.155,0.800,56.403},rotY=71.122,},
        {pos={-85.927,0.800,53.830},rotY=-26.671,},
        {pos={-72.235,0.800,66.828},rotY=-43.159,},
        {pos={-70.931,-2.700,73.869},rotY=-55.543,},
        {pos={-75.464,-3.513,83.523},rotY=-137.694,},
        {pos={-75.243,-3.510,86.047},rotY=-59.179,},
        {pos={-98.803,-3.513,85.688},rotY=49.720,},
        {pos={-97.438,-3.513,94.071},rotY=148.144,},
        {pos={-108.040,-3.513,82.896},rotY=123.124,},
        {pos={-109.150,-2.700,84.413},rotY=142.240,},
        {pos={-108.843,-2.700,73.652},rotY=82.480,},
        {pos={-96.171,-2.763,71.539},rotY=132.700,},
        {pos={-88.872,-3.513,70.421},rotY=-128.697,},
        {pos={-88.886,-2.763,73.256},rotY=64.297,},
        {pos={-83.126,-2.700,58.909},rotY=-31.357,},
      },
    },
  },--30150
}--npcPositions

this.uniqueChars={
  KAZ=true,
}

this.npcCounts={
  --PRISONER_MAFR=4,
  NURSE_3_FEMALE=3,
  DOCTOR_0=2,
  --DOCTOR_1=4,
  --DOCTOR_2=2,
  DDS_RESEARCHER=3,
  DDS_RESEARCHER_FEMALE=3,
  DDS_GROUNDCREW=8,
  CHILD_0=3,
  KAZ=1,
}

--clusters --default to all
--plats default to main
this.npcTemplates={
  NURSE_3_FEMALE={
    bodyType="NURSE_3_FEMALE",
    bodyId={
      TppEnemyBodyId.nrs0_v00,--brunette,bun
      TppEnemyBodyId.nrs0_v01,--black straight hair
      TppEnemyBodyId.nrs0_v02,--blond, glasses
      TppEnemyBodyId.nrs0_v03,--brunnete bun again? different face?
      TppEnemyBodyId.nrs0_v04,--brown straight, glasses
      TppEnemyBodyId.nrs0_v05,--blond and brunette
      TppEnemyBodyId.nrs0_v06,--brown, bun, glasses
      TppEnemyBodyId.nrs0_v07,--brown, bun
    },
    clusters={
      Medical=true,
    },
  },
  PRISONER_MAFR={
    bodyType="PRISONER_MAFR",
    faceId=0,
  },
  CHILD_0={
    bodyType="CHILD_0",
    bodyId={
      TppEnemyBodyId.chd0_v00,
      TppEnemyBodyId.chd0_v01,
      TppEnemyBodyId.chd0_v02,
      TppEnemyBodyId.chd0_v03,
      TppEnemyBodyId.chd0_v04,
      TppEnemyBodyId.chd0_v05,
      TppEnemyBodyId.chd0_v06,
      TppEnemyBodyId.chd0_v07,
      TppEnemyBodyId.chd0_v08,
      TppEnemyBodyId.chd0_v09,
      TppEnemyBodyId.chd0_v10,
      TppEnemyBodyId.chd0_v11,
    },
    offsetY=-0.22,
    --tex need an except
    clusters={
      Command=true,
      Combat=true,
      Develop=true,
      Support=true,
      Medical=true,
      Spy=true,
      BaseDev=true,
    },
    plats={1,2,3,4},
  },
  DOCTOR_0={
    bodyType="DOCTOR_0",
    bodyId={
      TppEnemyBodyId.dct0_v00,
      TppEnemyBodyId.dct0_v01,
    },
    clusters={
      Medical=true,
    },
  },
  DOCTOR_1={
    bodyType="DOCTOR_1",
    clusters={
      Medical=true,
    },
  },
  DOCTOR_2={
    bodyType="DOCTOR_2",
  },
  DDS_GROUNDCREW={
    bodyType="DDS_GROUNDCREW",
    plats={2,3,4},
  },
  DDS_RESEARCHER={
    bodyType="DDS_RESEARCHER",
    faceId="male",
    clusters={
      Command=true,
      --Combat=false,
      Develop=true,
      Support=true,
      Spy=true,
      --BaseDev=false,
      Separation=true,
    },
  },
  DDS_RESEARCHER_FEMALE={
    bodyType="DDS_RESEARCHER_FEMALE",
    faceId="female",
    clusters={
      Command=true,
      --Combat=false,
      Develop=true,
      Support=true,
      Spy=true,
      --BaseDev=false,
      Separation=true,
    },
  },
  KAZ={
    bodyType="KAZ",
  },
}
for npcType,npcInfo in pairs(this.npcTemplates)do
  if type(npcInfo.bodyId)=="table" then
    npcInfo.bodyBag=InfUtil.ShuffleBag:New()--tex heheh bodyBag
    npcInfo.bodyBag:Fill(npcInfo.bodyId)
  end
  if type(npcInfo.faceId)=="table" then
    npcInfo.faceBag=InfUtil.ShuffleBag:New()
    npcInfo.faceBag:Fill(npcInfo.faceId)
  end
end

function this.BuildNPCInfo(missionCode)
  InfCore.LogFlow("InfNPC.BuildNPCInfo")
  local npcInfos={}
  local npcIndex=0
  for npcType,count in pairs(this.npcCounts)do
    local ivarName = ivarPrefix..npcType
    if Ivars[ivarName]:EnabledForMission() then
      for i=1,count do
        local template=this.npcTemplates[npcType]
        if template then
          local npcInfo={}
          for k,v in pairs(template) do
            npcInfo[k]=v
          end
          if template.faceBag then
            npcInfo.faceId=template.faceBag:Next()
          end
          if template.bodyBag then
            npcInfo.bodyId=template.bodyBag:Next()
          end

          npcInfos[string.format("ih_hostage_%04d",npcIndex)]=npcInfo
          npcIndex=npcIndex+1
        end--npcTemplate
      end--for npc count
    end--Ivar enabled
  end--for npcCounts
  return npcInfos
end--BuildNPCInfo

function this.MotherBaseCurrentClusterActivated(clusterId)
  this.InitCluster(clusterId)
end

--tex since hostage parts can only be set at loadtime the same total group of npcs are reused/repositioned on cluster change.
function this.InitCluster(clusterId)
  if not this.IsMbAdditionalNpcsEnabled()  then
    return
  end

  local placement=this.npcPositions[vars.missionCode]
  if placement==nil then
    return
  end

  clusterId=clusterId or MotherBaseStage.GetCurrentCluster()

  local grade=TppLocation.GetMbStageClusterGrade(clusterId)
  local commandGrade=TppLocation.GetMbStageClusterGrade(0)

  --tex WORKAROUND outer cluster positions change depending on the command grade (due to the amount of connections for bridges on the command plats)
  --and currently only have positions for mbLayout 3 - all plats on command built
  --command (clusterId 0) is fine, plat positions dont change
  if clusterId~=0 then
    if commandGrade<4 then
      grade=0--tex bail out
    end
  end

  --tex no plats on cluster
  if grade==0 then
    return
  end

  --tex mbqf,zoo
  if vars.missionCode~=30050 then
    grade=1
  end
  --zoo
  if vars.missionCode==30150 then
    clusterId=8
  end
  if vars.missionCode==30250 then
    clusterId=7
  end
  if clusterId==7 then
    grade=1
  end

  if this.debugModule then
    InfCore.Log("InfNPC.InitCluster "..tostring(clusterId).." "..tostring(InfMain.CLUSTER_NAME[clusterId+1]).." grade:"..tostring(grade).." commandGrade:"..tostring(commandGrade))
  end

  --DEBUGNOW TODO per plat bags and distribute npcs evenly across all plats
  --the current combined ext plats bag will create crowding on clusters with few platforms

  local positionBags={}
  for platIndex=1,grade do
    positionBags[platIndex]=InfUtil.ShuffleBag:New()
    --local clusterPlacement=placement[clusterId+1] or placement[1]
    local positions=placement[clusterId+1][platIndex]--tex positions for plat
    if positions then
      for i,position in ipairs(positions)do
        positionBags[platIndex]:Add(position)
      end
    end
  end--for platindex
  if this.debugModule then
  --InfCore.PrintInspect(positionBags,"positionBags")
  end
  --DEBUGNOW TODO if positionBag empty then warn, abort

  local motionTable={}
  --    motionTable=InfNPC.motionTable[index1]

  local locatorName=motionTable.locatorName
  local motionPath=motionTable.motionPath
  local position=motionTable.position
  local rotationY=motionTable.rotationY
  local idle=motionTable.idle or true
  local enableGunFire=motionTable.enableGunFire
  local OnStart=motionTable.OnStart
  local action=motionTable.action or "PlayMotion"
  local state=motionTable.state
  local enableAim=motionTable.enableAim
  local charaControl=motionTable.charaControl
  local startPos=motionTable.startPos
  local startRot=motionTable.startRot
  local interpFrame=motionTable.interpFrame
  local enableCollision=motionTable.enableCollision or false
  local enableSubCollision=motionTable.enableSubCollision or false
  local enableGravity=motionTable.enableGravity or false
  local enableCurtain=motionTable.enableCurtain

  local autoFinish=false

  for hostageName,npcInfo in pairs(this.npcInfo)do
    local skipNpc=false

    local locatorName=hostageName
    local gameObjectId=GameObject.GetGameObjectId(locatorName)

    if this.debugModule then
      InfCore.Log("locatorName:"..locatorName.." gameId:"..tostring(gameObjectId).." "..npcInfo.bodyType)--DEBUG
    end
    if gameObjectId~=GameObject.NULL_ID then
      local onClusterId=this.npcOnClusters[npcInfo.bodyType]
      if onClusterId and onClusterId~=clusterId then
        skipNpc=true
      end

      if clusterId==8 and npcInfo.bodyType~="DDS_GROUNDCREW" then --KLUDGE, TODO face system not set up on zoo
        skipNpc=true
      end

      if npcInfo.clusters then
        skipNpc=true
        for clusterName,allow in pairs(npcInfo.clusters)do
          if allow then
            if InfMain.CLUSTER_NAME[clusterId+1]==clusterName then
              skipNpc=false
              break
            end
          end--allow
        end--for clusters
      end--clusters

      if skipNpc then
        if this.debugModule then
          InfCore.Log("skipping npc")
        end
      else
        --tex TODO: need to bias selection toward target
        --local position
        --        local positionOK=false
        --        for i=1,10 do
        --          position=positionBag:Next()
        --          if not position.target then
        --            positionOK=true
        --          elseif position.target[npcInfo.bodyType] then
        --            positionOK=true
        --          end
        --          if position.except and position.except[npcInfo.bodyType] then
        --            positionOK=false
        --          end
        --          if positionOK then
        --            break
        --          end
        --        end

        local plats={1}
        if npcInfo.plats then
          plats={}
          if clusterId==8 then --KLUDGE DDS_GROUNDCREW doesnt allow plat1
            plats={1}
          end
          for i,plat in ipairs(npcInfo.plats)do
            if plat<=grade then
              plats[#plats+1]=plat
            end
          end
        end
        if this.debugModule then
          InfCore.PrintInspect(plats,"available plats")
        end
        if #plats>0 then
          local platIndex=InfUtil.GetRandomInList(plats)
          if this.debugModule then
            InfCore.Log("platindex:"..platIndex)
          end

          local position=positionBags[platIndex]:Next()

          local motionPath=this.motionPaths[math.random(#this.motionPaths)]

          --GameObject.SendCommand(gameObjectId,{id="SetHostage2Flag",flag="disableMarker",on=true})-
          TppUiCommand.RegisterIconUniqueInformation{markerId=gameObjectId,langId="marker_friend_mb"}
          --      local faceId=nil
          --      local bodyId=TppEnemyBodyId.ddr0_main0_v00
          --      GameObject.SendCommand( gameObjectId, { id = "ChangeFova", faceId = faceId, bodyId = bodyId, } )

          SendCommand(gameObjectId,{id="SetEnabled",enabled=true})
          SendCommand(gameObjectId,{id="SetHostage2Flag",flag="unlocked",on=true,updateModel=true})
          SendCommand(gameObjectId,{id="SetHostage2Flag",flag="disableFulton",on=true})
          SendCommand(gameObjectId,{id="SetHostage2Flag",flag="commonNpc",on=true,})
          --GameObject.SendCommand(gameObjectId,{id="SetHostage2Flag",flag="disableDamageReaction",on=true,})
          SendCommand(gameObjectId,{id="SetDisableDamage",life=true,faint=true,sleep=true,})

          local specialActionCmd={
            id="SpecialAction",
            action=action,
            path=motionPath,
            state=state,
            autoFinish=autoFinish,
            enableMessage=true,
            enableGravity=motionTable.enableGravity,
            enableCollision=enableCollision,
            enableSubCollision=enableSubCollision,
            enableGunFire=enableGunFire,
            enableAim=enableAim,
            startPos=startPos,
            startRot=startRot,
            enableCurtain=enableCurtain,
          }
          SendCommand(gameObjectId,specialActionCmd)

          local rotY=position.rotY
          rotY=math.random(360)--tex TODO bias towards given rotation
          local randomOffset=0.2
          local offsetX=math.random(-randomOffset,randomOffset)
          local offsetZ=math.random(-randomOffset,randomOffset)
          local offsetY=npcInfo.offsetY or 0
          local command={id="Warp",degRotationY=rotY,position=Vector3(position.pos[1]+offsetX,position.pos[2]+offsetY,position.pos[3]+offsetZ)}
          SendCommand(gameObjectId,command)

          if this.debugModule then
            InfCore.Log("platIndex"..platIndex)--DEBUG
            InfCore.Log("motionPath:"..InfUtil.GetFileName(motionPath))--DEBUG
          end
        end--plats>0
      end--not skipNpc
    end--gameObjectId ~= NULL
  end--for npcInfo
end--InitCluster

return this
