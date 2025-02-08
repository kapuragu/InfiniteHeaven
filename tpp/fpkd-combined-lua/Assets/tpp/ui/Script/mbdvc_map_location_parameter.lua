-- DOBUILD: 1
-- ORIGINALQAR: chunk0
-- PACKPATH: \Assets\tpp\pack\mbdvc\mb_dvc_top.fpkd
-- mbdvc_map_location_parameter.lua
mbdvc_map_location_parameter = {
  --tex REWORKED, GetLocationParameter was just a just a big ole if locationId return {table of params}
  --tex indexed by locationId
	locationParameters={
    --Fallback in case locationId doesn't match (ex. Cyprus)
    default={
      --rlc stage is 8192 x 8192 meter square
      stageSize = 4096.0 * 2.0,
      --rlc -x/-z scroll limit
      scrollMaxLeftUpPosition   = Vector3( -4096.0, 0.0, -4096.0 ),
      --rlc +x/+z scroll limit
      scrollMaxRightDownPosition  = Vector3(  4096.0, 0.0,  4096.0 ),
      --normal map zoom scale
      highZoomScale   = 4.80,
      middleZoomScale   = 2.340,
      lowZoomScale    = 0.70,
      --navi mode (action button) zoom scale
      naviHighZoomScale = 4.80,
      naviMiddleZoomScale = 2.340,
      --map texture path, height and satellite
      heightMapTexturePath    = "/Assets/tpp/common_source/ui/common_texture/cm_wht_64.ftex",
      photoRealMapTexturePath   = "/Assets/tpp/common_source/ui/common_texture/cm_wht_64.ftex",
    },
    --Afghanistan
    [10]={
      stageSize = 4096.0 * 2.0,
      scrollMaxLeftUpPosition		= Vector3( -4096.0, 0.0, -4096.0 ),
      scrollMaxRightDownPosition	= Vector3(  4096.0, 0.0,  4096.0 ),
      --rlc map image is actually rotated 45 degrees clockwise from what it really is
      stageRotate = -45.0,
      highZoomScale		= 14.40,
      middleZoomScale		= 3.0,
      lowZoomScale		= 1.0,
      naviHighZoomScale	= 14.40,
      naviMiddleZoomScale	= 5.0,
      --rlc lang id for the map on the bottom left of the map
      locationNameLangId	= "tpp_loc_afghan",
      heightMapTexturePath 			    = "/Assets/tpp/ui/texture/map/map_afgh/afgh_height_clp_alp.ftex",
      heightMapTexturePath2         = "/Assets/tpp/ui/texture/map/map_afgh/afgh_height_b_clp_alp.ftex",
      heightMapTexturePath3         = "/Assets/tpp/ui/texture/map/map_afgh/afgh_height_c_clp_alp.ftex",
      photoRealMapTexturePath       = "/Assets/tpp/ui/texture/map/map_afgh/afgh_photo_clp_alp.ftex",
      --higher detail map texture divided into 8 by 8 grid
      divideHeightMapTexturePath		= "/Assets/tpp/ui/texture/map/map_afgh/height_divide/afgh_hgt_dv_%02d_%02d_clp_alp.ftex",
      divideHeightMapTexturePath2		= "/Assets/tpp/ui/texture/map/map_afgh/height_divide/afgh_hgt_b_dv_%02d_%02d_clp_alp.ftex",
      divideHeightMapTexturePath3		= "/Assets/tpp/ui/texture/map/map_afgh/height_divide/afgh_hgt_c_dv_%02d_%02d_clp_alp.ftex",
      dividePhotoRealMapTexturePath	= "/Assets/tpp/ui/texture/map/map_afgh/photo_divide/afgh_pht_dv_%02d_%02d_clp_alp.ftex",
      --townParameter icon textures, unique if mini=false, common if mini=true
      uniqueTownTexturePath			    = "/Assets/tpp/ui/texture/map/building_icon/mb_map_bild_icon_afgh_alp_clp.ftex",
      commonTownTexturePath			    = "/Assets/tpp/ui/texture/map/building_icon/mb_map_bild_icon_cmn_alp_clp.ftex",
      --rank level for map function needed to display map texture variations
      sectionFuncRankForHeightMap2	= 3,
      sectionFuncRankForHeightMap3	= 5,
      townParameter = {
        --notes from caplag
        --[[ {
         -- Will pull the phase status from the given CP:
         cpName = "afgh_village_cp",
         -- langId shown when highlighted:
         langId = "tpp_afghan_en_village",
         -- langId of the marker on the map:
         cursorLangId = "tpp_afghan_village",
         position = Vector3(512.3,0.0,1152.3),
         -- Radius of the town, which Quiet will scout out:
         radius=200.0,
         -- UV shift of the town icon:
         uShift=0.25 ,
         vShift=0.75 ,
         -- true - use commonTown texture, false - use uniqueTown texture
         mini=false
        }, ]]

        --Command posts/outposts
        { cpName = "", langId = "tpp_afghan_en_ruins", cursorLangId = "tpp_afghan_ruins",
          position = Vector3(1459.0,0.0,1478.4), radius=75.0, uShift=0.25 , vShift=0.50 , mini=false },
        { cpName = "afgh_village_cp", langId = "tpp_afghan_en_village", cursorLangId = "tpp_afghan_village",
          position = Vector3(512.3,0.0,1152.3), radius=200.0, uShift=0.25 , vShift=0.75 , mini=false },
        { cpName = "afgh_commFacility_cp", langId = "tpp_afghan_en_commFacility", cursorLangId = "tpp_afghan_commFacility",
          position = Vector3(1505.4,0.0,449.4), radius=200.0, uShift=0.75 , vShift=0.00 , mini=false },
        { cpName = "afgh_slopedTown_cp", langId = "tpp_afghan_en_slopedTown", cursorLangId = "tpp_afghan_slopedTown",
          position = Vector3(511.2,0.0,64.9), radius=200.0, uShift=0.50 , vShift=0.50 , mini=false },
        { cpName = "afgh_enemyBase_cp", langId = "tpp_afghan_en_enemyBase", cursorLangId = "tpp_afghan_enemyBase",
          position = Vector3(-569.3,0.0,518.8), radius=200.0, uShift=0.00 , vShift=0.25 , mini=false },
        { cpName = "afgh_cliffTown_cp", langId = "tpp_afghan_en_cliffTown", cursorLangId = "tpp_afghan_cliffTown",
          position = Vector3(798.0,0.0,-1006.0), radius=200.0, uShift=0.50 , vShift=0.00 , mini=false },
        { cpName = "afgh_bridge_cp", langId = "tpp_afghan_en_bridge", cursorLangId = "tpp_afghan_bridge",
          position = Vector3(1922.2,0.0,-478.2), radius=200.0, uShift=0.00 , vShift=0.00 , mini=false },
        { cpName = "afgh_remnants_cp", langId = "tpp_afghan_en_remnant", cursorLangId = "tpp_afghan_remnant",
          position = Vector3(-782.5,0.0,1893.8), radius=200.0, uShift=0.00 , vShift=0.50 , mini=false },
        { cpName = "afgh_tent_cp", langId = "tpp_afghan_en_tent", cursorLangId = "tpp_afghan_tent",
          position = Vector3(-1745.0,0.0,838.0), radius=200.0, uShift=0.00 , vShift=0.75 , mini=false },
        { cpName = "", langId = "tpp_afghan_en_waterway", cursorLangId = "tpp_afghan_waterway",
          position = Vector3(-1702.1,0.0,-397.1), radius=200.0, uShift=0.50 , vShift=0.75 , mini=false },
        { cpName = "afgh_powerPlant_cp", langId = "tpp_afghan_en_powerPlant", cursorLangId = "tpp_afghan_powerPlant",
          position = Vector3(-712.3,0.0,-1532.4), radius=300.0, uShift=0.75 , vShift=0.25 , mini=false },
        { cpName = "afgh_field_cp", langId = "tpp_afghan_en_field", cursorLangId = "tpp_afghan_field",
          position = Vector3(393.0,0.0,2150.0), radius=200.0, uShift=0.25 , vShift=0.25 , mini=false },
        { cpName = "afgh_fort_cp", langId = "tpp_afghan_en_fort", cursorLangId = "tpp_afghan_fort",
          position = Vector3(2107.0,0.0,-1744.0), radius=300.0, uShift=0.50 , vShift=0.25 , mini=false },
        { cpName = "afgh_sovietBase_cp", langId = "tpp_afghan_en_sovietBase", cursorLangId = "tpp_afghan_sovietBase",
          position = Vector3(-2209.0,0.0,-1573.0), radius=300.0, uShift=0.75 , vShift=0.50 , mini=false },
        { cpName = "afgh_citadel_cp", langId = "tpp_afghan_en_citadel", cursorLangId = "tpp_afghan_citadel",
          position = Vector3(-1236.0,0.0,-3000.0), radius=300.0, uShift=0.25 , vShift=0.00 , mini=false },

        --Observation posts/guard posts
        { cpName = "afgh_commWest_ob", langId = "tpp_afghan_commWest_no", cursorLangId = "tpp_afghan_commWest",
          position = Vector3(990.7,0.0,658.6), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_villageWest_ob", langId = "tpp_afghan_villageWest_no", cursorLangId = "tpp_afghan_villageWest",
          position = Vector3(-249.0,0.0,930.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_ruinsNorth_ob", langId = "tpp_afghan_ruinsNorth_no", cursorLangId = "tpp_afghan_ruinsNorth",
          position = Vector3(1630.6,0.0,1056.2), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_villageNorth_ob", langId = "tpp_afghan_villageNorth_no", cursorLangId = "tpp_afghan_villageNorth",
          position = Vector3(506.0,0.0,703.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_slopedWest_ob", langId = "tpp_afghan_slopedWest_no", cursorLangId = "tpp_afghan_slopedWest",
          position = Vector3(100.0,0.0,88.4), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_fieldEast_ob", langId = "tpp_afghan_fieldEast_no", cursorLangId = "tpp_afghan_fieldEast",
          position = Vector3(1096.3,0.0,1833.1), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_fieldWest_ob", langId = "tpp_afghan_fieldWest_no", cursorLangId = "tpp_afghan_fieldWest",
          position = Vector3(10.5,0.0,1994.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_remnantsNorth_ob", langId = "tpp_afghan_remnantsNorth_no", cursorLangId = "tpp_afghan_remnantsNorth",
          position = Vector3(-1056.3,0.0,1471.2), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_tentNorth_ob", langId = "tpp_afghan_tentNorth_no", cursorLangId = "tpp_afghan_tentNorth",
          position = Vector3(-1756.6,0.0,214.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_slopedEast_ob", langId = "tpp_afghan_slopedEast_no", cursorLangId = "tpp_afghan_slopedEast",
          position = Vector3(966.0,0.0,-169.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_villageEast_ob", langId = "tpp_afghan_villageEast_no", cursorLangId = "tpp_afghan_villageEast",
          position = Vector3(1048.0,0.0,1273.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_bridgeWest_ob", langId = "tpp_afghan_bridgeWest_no", cursorLangId = "tpp_afghan_bridgeWest",
          position = Vector3(1593.2,0.0,43.3), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_fortSouth_ob", langId = "tpp_afghan_fortSouth_no", cursorLangId = "tpp_afghan_fortSouth",
          position = Vector3(2184.8,0.0,-1268.3), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_fortWest_ob", langId = "tpp_afghan_fortWest_no", cursorLangId = "tpp_afghan_fortWest",
          position = Vector3(1825.5,0.0,-1249.7), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_cliffEast_ob", langId = "tpp_afghan_cliffEast_no", cursorLangId = "tpp_afghan_cliffEast",
          position = Vector3(1259.0,0.0,-1347.4), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_cliffSouth_ob", langId = "tpp_afghan_cliffSouth_no", cursorLangId = "tpp_afghan_cliffSouth",
          position = Vector3(1046.0,0.0,-507.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_enemyNorth_ob", langId = "tpp_afghan_enemyNorth_no", cursorLangId = "tpp_afghan_enemyNorth",
          position = Vector3(-183.0,0.0,-466.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_bridgeNorth_ob", langId = "tpp_afghan_bridgeNorth_no", cursorLangId = "tpp_afghan_bridgeNorth",
          position = Vector3(2395.6,0.0,-507.6), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_cliffWest_ob", langId = "tpp_afghan_cliffWest_no", cursorLangId = "tpp_afghan_cliffWest",
          position = Vector3(299.7,0.0,-851.1), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_enemyEast_ob", langId = "tpp_afghan_enemyEast_no", cursorLangId = "tpp_afghan_enemyEast",
          position = Vector3(-367.0,0.0,120.5), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_tentEast_ob", langId = "tpp_afghan_tentEast_no", cursorLangId = "tpp_afghan_tentEast",
          position = Vector3(-1169.5,0.0,934.4), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_sovietSouth_ob", langId = "tpp_afghan_sovietSouth_no", cursorLangId = "tpp_afghan_sovietSouth",
          position = Vector3(-1582.0,0.0,-1151.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_plantWest_ob", langId = "tpp_afghan_plantWest_no", cursorLangId = "tpp_afghan_plantWest",
          position = Vector3(-1172.4,0.0,-1405.1), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_waterwayEast_ob", langId = "tpp_afghan_waterWayEast_no", cursorLangId = "tpp_afghan_waterWayEast",
          position = Vector3(-1328.3,0.0,-741.7), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "afgh_citadelSouth_ob", langId = "tpp_afghan_CitadelSouth_no", cursorLangId = "tpp_afghan_CitadelSouth",
          position = Vector3(-1668.0,0.0,-2441.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
      }
    },
    --Central Africa
    [20]= {
      stageSize = 4096.0 * 2.0,
      scrollMaxLeftUpPosition		= Vector3( -4096.0, 0.0, -3804.0 ),
      scrollMaxRightDownPosition	= Vector3(  1884.0, 0.0,  2172.0 ),
      stageRotate = -45.0,
      highZoomScale		= 14.40,
      middleZoomScale		= 3.0,
      lowZoomScale		= 1.0,
      naviHighZoomScale	= 14.40,
      naviMiddleZoomScale	= 5.0,
      locationNameLangId	= "tpp_loc_africa",
      heightMapTexturePath			= "/Assets/tpp/ui/texture/map/map_mafr/mafr_height_clp_alp.ftex",
      heightMapTexturePath2			= "/Assets/tpp/ui/texture/map/map_mafr/mafr_height_b_clp_alp.ftex",
      heightMapTexturePath3			= "/Assets/tpp/ui/texture/map/map_mafr/mafr_height_c_clp_alp.ftex",
      photoRealMapTexturePath			= "/Assets/tpp/ui/texture/map/map_mafr/mafr_photo_clp_alp.ftex",
      divideHeightMapTexturePath		= "/Assets/tpp/ui/texture/map/map_mafr/height_divide/mafr_hgt_dv_%02d_%02d_clp_alp.ftex",
      divideHeightMapTexturePath2		= "/Assets/tpp/ui/texture/map/map_mafr/height_divide/mafr_hgt_b_dv_%02d_%02d_clp_alp.ftex",
      divideHeightMapTexturePath3		= "/Assets/tpp/ui/texture/map/map_mafr/height_divide/mafr_hgt_c_dv_%02d_%02d_clp_alp.ftex",
      dividePhotoRealMapTexturePath	= "/Assets/tpp/ui/texture/map/map_mafr/photo_divide/mafr_pht_dv_%02d_%02d_clp_alp.ftex",
      uniqueTownTexturePath			= "/Assets/tpp/ui/texture/map/building_icon/mb_map_bild_icon_mafr_alp_clp.ftex",
      commonTownTexturePath			= "/Assets/tpp/ui/texture/map/building_icon/mb_map_bild_icon_cmn_alp_clp.ftex",
      sectionFuncRankForHeightMap2	= 5,
      sectionFuncRankForHeightMap3	= 7,
      townParameter = {
        --Command posts/outposts
        { cpName = "mafr_swamp_cp", langId = "tpp_africa_en_swamp", cursorLangId = "tpp_africa_swamp",
          position = Vector3(-64.9,0.0,-0.7), radius=200.0, uShift=0.50 , vShift=0.00 , mini=false },
        { cpName = "mafr_savannah_cp", langId = "tpp_africa_en_savannah", cursorLangId = "tpp_africa_savannah",
          position = Vector3(835.0,0.0,-130.0), radius=200.0, uShift=0.00 , vShift=0.25 , mini=false },
        { cpName = "mafr_banana_cp", langId = "tpp_africa_en_banana", cursorLangId = "tpp_africa_banana",
          position = Vector3(283.8,0.0,-1170.8), radius=200.0, uShift=0.25 , vShift=0.25 , mini=false },
        { cpName = "mafr_diamond_cp", langId = "tpp_africa_en_diamond", cursorLangId = "tpp_africa_diamond",
          position = Vector3(1326.5,0.0,-1483.0), radius=300.0, uShift=0.50 , vShift=0.25 , mini=false },
        { cpName = "mafr_factory_cp", langId = "tpp_africa_en_factory", cursorLangId = "tpp_africa_factory",
          position = Vector3(2837.5,0.0,-889.4), radius=300.0, uShift=0.00 , vShift=0.50 , mini=false },
        { cpName = "mafr_lab_cp", langId = "tpp_africa_en_lab", cursorLangId = "tpp_africa_lab",
          position = Vector3(2549.5,0.0,-2157.9), radius=300.0, uShift=0.25 , vShift=0.50 , mini=false },
        { cpName = "mafr_flowStation_cp", langId = "tpp_africa_en_flowstation", cursorLangId = "tpp_africa_flowstation",
          position = Vector3(-1023.0,0.0,-226.0), radius=300.0, uShift=0.25 , vShift=0.00 , mini=false },
        { cpName = "mafr_outland_cp", langId = "tpp_africa_en_outland", cursorLangId = "tpp_africa_outland",
          position = Vector3(-615.0,0.0,1029.0), radius=200.0, uShift=0.00 , vShift=0.00 , mini=false },
        { cpName = "mafr_hill_cp", langId = "tpp_africa_en_hill", cursorLangId = "tpp_africa_hill",
          position = Vector3(2165.6,0.0,388.5), radius=300.0, uShift=0.75 , vShift=0.25 , mini=false },
        { cpName = "mafr_pfCamp_cp", langId = "tpp_africa_en_pfcamp", cursorLangId = "tpp_africa_pfcamp",
          position = Vector3(823.0,0.0,993.0), radius=300.0, uShift=0.75 , vShift=0.00 , mini=false },

        --Observation posts/guard posts
        { cpName = "mafr_outlandNorth_ob", langId = "tpp_africa_outlandNorth_no", cursorLangId = "tpp_africa_outlandNorth",
          position = Vector3(-817.8,0.0,698.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_swampWest_ob", langId = "tpp_africa_swampWest_no", cursorLangId = "tpp_africa_swampWest",
          position = Vector3(-565.0,0.0,-188.4), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_outlandEast_ob", langId = "tpp_africa_outlandEast_no", cursorLangId = "tpp_africa_outlandEast",
          position = Vector3(-274.0,0.0,736.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_bananaSouth_ob", langId = "tpp_africa_bananaSouth_no", cursorLangId = "tpp_africa_bananaSouth",
          position = Vector3(233.1,0.0,-659.6), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_swampSouth_ob", langId = "tpp_africa_swampSouth_no", cursorLangId = "tpp_africa_swampSouth",
          position = Vector3(311.3,0.0,378.8), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_swampEast_ob", langId = "tpp_africa_swampEast_no", cursorLangId = "tpp_africa_swampEast",
          position = Vector3(367.5,0.0,0.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_savannahWest_ob", langId = "tpp_africa_savannahWest_no", cursorLangId = "tpp_africa_savannahWest",
          position = Vector3(713.2,0.0,-536.7), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_bananaEast_ob", langId = "tpp_africa_bananaEast_no", cursorLangId = "tpp_africa_bananaEast",
          position = Vector3(570.1,0.0,-1072.3), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_savannahNorth_ob", langId = "tpp_africa_savannahNorth_no", cursorLangId = "tpp_africa_savannahNorth",
          position = Vector3(711.5,0.0,-900.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_diamondWest_ob", langId = "tpp_africa_diamondWest_no", cursorLangId = "tpp_africa_diamondWest",
          position = Vector3(1086.0,0.0,-1151.5), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_diamondSouth_ob", langId = "tpp_africa_diamondSouth_no", cursorLangId = "tpp_africa_diamondSouth",
          position = Vector3(1451.8,0.0,-745.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_hillNorth_ob", langId = "tpp_africa_hillNorth_no", cursorLangId = "tpp_africa_hillNorth",
          position = Vector3(1941.5,0.0,-278.8), radius=200.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_hillSouth_ob", langId = "tpp_africa_hillSouth_no", cursorLangId = "tpp_africa_hillSouth",
          position = Vector3(2009.6,0.0,1370.1), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_savannahEast_ob", langId = "tpp_africa_savannahEast_no", cursorLangId = "tpp_africa_savannahEast",
          position = Vector3(1212.0,0.0,96.1), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_hillWest_ob", langId = "tpp_africa_hillWest_no", cursorLangId = "tpp_africa_hillWest",
          position = Vector3(1662.2,0.0,152.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_hillWestNear_ob", langId = "tpp_africa_hillWestNear_no", cursorLangId = "tpp_africa_hillWestNear",
          position = Vector3(1823.0,0.0,693.7), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_pfCampEast_ob", langId = "tpp_africa_pfCampEast_no", cursorLangId = "tpp_africa_pfCampEast",
          position = Vector3(1185.2,0.0,576.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_pfCampNorth_ob", langId = "tpp_africa_pfCampNorth_no", cursorLangId = "tpp_africa_pfCampNorth",
          position = Vector3(933.1,0.0,370.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_factorySouth_ob", langId = "tpp_africa_factorySouth_no", cursorLangId = "tpp_africa_factorySouth",
          position = Vector3(2366.0,0.0,-111.3), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_factoryWest_ob", langId = "tpp_africa_factoryWest_no", cursorLangId = "tpp_africa_factoryWest",
          position = Vector3(2441.2,0.0,-793.7), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_diamondNorth_ob", langId = "tpp_africa_diamondNorth_no", cursorLangId = "tpp_africa_diamondNorth",
          position = Vector3(1331.8,0.0,-1907.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_labWest_ob", langId = "tpp_africa_labWest_no", cursorLangId = "tpp_africa_labWest",
          position = Vector3(2155.7,0.0,-2184.7), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
        { cpName = "mafr_chicoVilWest_ob", langId = "tpp_africa_chicoVilWest_no", cursorLangId = "tpp_africa_chicoVilWest",
          position = Vector3(1537.1,0.0,1783.0), radius=75.0, uShift=0.00 , vShift=0.00 , mini=true },
      }
    },
    --Mother Base
    [50]= {
      stageSize = 2048.0 * 2.0,
      scrollMaxLeftUpPosition		= Vector3( -2144.0, 0.0, -2144.0 ),
      scrollMaxRightDownPosition	= Vector3(  2144.0, 0.0,  2144.0 ),
      highZoomScale		= 14.40,
      middleZoomScale		= 3.5,
      lowZoomScale		= 0.50,
      naviHighZoomScale	= 14.40,
      naviMiddleZoomScale	= 5.0,
      locationNameLangId	= "tpp_loc_mb",
      uniqueTownTexturePath			= "/Assets/tpp/ui/texture/map/building_icon/mb_map_bild_icon_mb_alp_clp.ftex",
      commonTownTexturePath			= "/Assets/tpp/ui/texture/map/building_icon/mb_map_bild_icon_cmn_alp_clp.ftex",
      townParameter = {
        --Unique platforms
        { mbId = 0, langId = "platform_en_main", cursorLangId = "platform_main",
          radius=75.0, uShift=0.00 , vShift=0.00 },
        { mbId = 1, langId = "platform_en_combat", cursorLangId = "platform_combat",
          radius=75.0, uShift=0.25 , vShift=0.00 },
        { mbId = 2, langId = "platform_en_RD", cursorLangId = "platform_RD",
          radius=75.0, uShift=0.50 , vShift=0.00 },
        { mbId = 3, langId = "platform_en_base_dev", cursorLangId = "platform_base_dev",
          radius=75.0, uShift=0.50 , vShift=0.25 },
        { mbId = 4, langId = "platform_en_support", cursorLangId = "platform_support",
          radius=75.0, uShift=0.75 , vShift=0.00 },
        { mbId = 5, langId = "platform_en_intel", cursorLangId = "platform_intel",
          radius=75.0, uShift=0.25 , vShift=0.25 },
        { mbId = 6, langId = "platform_en_medical", cursorLangId = "platform_medical",
          radius=75.0, uShift=0.00 , vShift=0.25 },

        --Quarantine
        { mbId = 10, langId = "platform_en_isolation", cursorLangId = "platform_isolation",
          radius=75.0, uShift=0.75 , vShift=0.25 },

        --Conservation
        { mbId = 20, langId = "platform_en_protection", cursorLangId = "platform_protection",
          radius=75.0, uShift=0.00 , vShift=0.50 },
        { mbId = 21, langId = "platform_en_zoo_bird", cursorLangId = "platform_zoo_bird",
          radius=75.0, uShift=0.00 , vShift=0.50 },
        { mbId = 22, langId = "platform_en_zoo_herbivore1", cursorLangId = "platform_zoo_herbivore1",
          radius=75.0, uShift=0.00 , vShift=0.50 },
        { mbId = 23, langId = "platform_en_zoo_herbivore2", cursorLangId = "platform_zoo_herbivore2",
          radius=75.0, uShift=0.00 , vShift=0.50 },
        { mbId = 24, langId = "platform_en_zoo_canivore", cursorLangId = "platform_zoo_canivore",
          radius=75.0, uShift=0.00 , vShift=0.50 },
      }
    },
    --Quarantine Interior
    [55]={
      stageSize = 37.5 * 2.0,
      scrollMaxLeftUpPosition		= Vector3( -12.0, 0.0, -32.0 ),
      scrollMaxRightDownPosition	= Vector3(  12.0, 0.0,  8.0 ),
      stageRotate = 0.0,
      highZoomScale		= 3.50,
      middleZoomScale		= 1.50,
      lowZoomScale		= 0.50,
      naviHighZoomScale	= 3.50,
      naviMiddleZoomScale	= 2.00,
      locationNameLangId	= "platform_isolation",
      heightMapTexturePath= "/Assets/tpp/ui/texture/map/map_mtbs/parts/uq_0070_inside_alp.ftex",
    },
	},

	--NMC: called on idroid map tab open?
	GetLocationParameter = function( locationId )
    InfCore.LogFlow("mbdvc_map_location_parameter.GetLocationParameter "..tostring(locationId))--tex
    local mapParams
    if InfMission then --tex> cant patch in the table from earlier in execution as it seems mbdvc_map_location_parameter is torn down/reloaded
      mapParams=InfCore.PCallDebug(InfMission.GetMapLocationParameter,locationId)
    end--<
    return mapParams or mbdvc_map_location_parameter.locationParameters[locationId] or mbdvc_map_location_parameter.locationParameters.default
	end,

	--tex NMC: called on idroid map tab open? nope
	--several calls, but the script is torn down each time as the pack its in is unloaded? VERIFY
	--TODO Narrow down further
	--first call -- InfMission not up yet.
	--info: TppLocation.lua
  --info: mbdvc_map_location_parameter.GetGlobalLocationParameter 65535
  --info: mbdvc_map_location_parameter.GetLocationParameter 65534
  --info: TppLandingZone.lua
	--second call
  --info: TppMain.OnChangeSVars done
  --info: mbdvc_map_location_parameter.GetGlobalLocationParameter 1
  --info: InfMission.AddGlobalLocationParameters
  --info: mbdvc_map_location_parameter.GetLocationParameter 1
  --info: InfMission.GetMapLocationParameter 1
  --info: TppSequence.SetNextSequence from Seq_Demo_SetSavedLanguage to Seq_Demo_StartCheckNecessaryStorageSpace

	--third call
  --info: TppMain.OnChangeSVars done
  --info: init_sequence CreateOrLoadSaveData
  --info: OnMessage[]: UI.PopupClose(--[[popupId:~:LOADING_SAVE_DATA]] 1200, --[[unk1:number:]] 0, nil, nil)
  --info: mbdvc_map_location_parameter.GetGlobalLocationParameter 1
  --info: InfMission.AddGlobalLocationParameters
  --info: init_sequence CreateOrLoadSaveData success
  --info: TppSequence.SetNextSequence from Seq_Demo_CreateOrLoadSaveData to Seq_Demo_LogInKonamiServer

	--any later?

	GetGlobalLocationParameter = function()
    InfCore.LogFlow("mbdvc_map_location_parameter.GetGlobalLocationParameter "..tostring(vars.missionCode))--tex
    local enableSpySearch=true--tex IH uses a different method to globally enable/disable, see disableSpySearch ivar
    local enableHerbSearch=Ivars.disableHerbSearch~=nil and Ivars.disableHerbSearch:Is(0) or true--tex disableHerbSearch hasnt been added to Ivars when GetGlobalLocationParameter is first called 
    local globalLocationParameters={--tex was just return the table
      --notes from caplag
      {
				locationId = 10,
				-- Intel level needed to mark objects on the map:
				sectionFuncRankForDustBox	= 2,
				sectionFuncRankForToilet	= 2,
				sectionFuncRankForCrack		= 4,
				-- Enable enemy FOM:
				isSpySearchEnable = enableSpySearch,--tex was true. Addon authorts should just set as true (if they want the feature) in their locationInfo addon globalLocationMapParams 
				-- Enable herb marking:
				isHerbSearchEnable = enableHerbSearch,--tex was true. as above
				-- Distance at which enemy FOM will be marked, each corresponding to Intel level:
				spySearchRadiusMeter = {	40.0,	40.0,	35.0,	30.0,	25.0,	20.0,	15.0,	10.0, },
				-- Intervals between enemy FOM updates, corresponding to Intel level:
				spySearchIntervalSec = {	420.0,	420.0,	360.0,	300.0,	240.0,	180.0,	120.0,	60.0, },
				-- Radius at which Intel will mark herbs, according to Intel level:
				herbSearchRadiusMeter = {	0.0,	0.0,	10.0,	15.0,	20.0,	25.0,	30.0,	35.0, },
			},
			{
				locationId = 20,
				sectionFuncRankForDustBox	= 4,
				sectionFuncRankForToilet	= 4,
				sectionFuncRankForCrack		= 6,
				isSpySearchEnable = enableSpySearch,--tex was true
				isHerbSearchEnable = enableHerbSearch,--tex was true

				spySearchRadiusMeter = {	40.0,	40.0,	35.0,	30.0,	25.0,	20.0,	15.0,	10.0, },
				spySearchIntervalSec = {	420.0,	420.0,	360.0,	300.0,	240.0,	180.0,	120.0,	60.0, },
				herbSearchRadiusMeter = {	0.0,	0.0,	10.0,	15.0,	20.0,	25.0,	30.0,	35.0, },
			},
			{
				locationId = 50,
				isFobSpySearchEnable = true,

				spySearchRadiusMeter = {	84.0,	84.0,	75.0,	65.0,	56.0,	47.0,	38.0,	29.0 },
				spySearchIntervalSec = {	700.0,	700.0,	600.0,	500.0,	400.0,	300.0,	200.0,	100.0, },
			},
		}--globalLocationParameters

		if InfMission then --tex> cant patch in the table from earlier in execution as it seems mbdvc_map_location_parameter (mb_dvc_top.fpk) is torn down/reloaded
      InfCore.PCallDebug(InfMission.AddGlobalLocationParameters,globalLocationParameters)
    end--<

		return globalLocationParameters
	end,

	GetLocationOfMissions = function()
    InfCore.LogFlow("mbdvc_map_location_parameter.GetLocationOfMissions "..tostring(vars.missionCode))--tex
    local locationOfMissions = {}
    for locationName, missionList in pairs(TppDefine.LOCATION_HAVE_MISSION_LIST) do
      for index, missionId in pairs(missionList) do
        locationOfMissions[ missionId ] = TppDefine.LOCATION_ID[locationName]
      end
    end
    return locationOfMissions
	end,
}
