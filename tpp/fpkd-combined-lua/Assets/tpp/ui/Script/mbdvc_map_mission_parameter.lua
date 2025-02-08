-- DOBUILD: 1
-- ORIGINALQAR: chunk0
-- PACKPATH: \Assets\tpp\pack\mbdvc\mb_dvc_top.fpkd

mbdvc_map_mission_parameter = {
  --tex REWORKED
  missionParameters={
    default={},
    [0]={},
    [10010]={ --PROLOGUE: AWAKENING
      missionArea2 = {},
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [10020]={ --PHANTOM LIMBS
      missionArea2 = {
        {
          name="innerZone",
          vertices={
            Vector3(836.00,241.06,-80.00),
            Vector3(-48.00,241.06,-80.00),
            Vector3(-256.00,241.06,128.00),
            Vector3(-768.00,241.06,128.00),
            Vector3(-768.00,241.06,1216.00),
            Vector3(0.00,241.06,1216.00),
            Vector3(512.00,241.06,1728.00),
            Vector3(1792.00,241.06,1728.00),
            Vector3(1792.00,241.06,128.00),
            Vector3(1044.00,241.06,128.00),
          },
        },
      },
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [10030]={ --DIAMOND DOGS
      missionArea2 = {},
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [10033]={ --OVER THE FENCE
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(-1130.04,180.00,859.60),
            Vector3(-748.37,180.00,1241.27),
            Vector3(-475.96,180.00,968.86),
            Vector3(-225.87,180.00,1218.95),
            Vector3(152.35,180.00,840.77),
            Vector3(152.35,180.00,-89.97),
            Vector3(-479.32,180.00,-89.97),
            Vector3(-857.62,180.00,288.33),
            Vector3(-857.62,180.00,587.19), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(-652.23,180.00,1012.55),
            Vector3(-536.76,180.00,897.08),
            Vector3(-463.86,180.00,969.99),
            Vector3(-193.42,180.00,699.55),
            Vector3(-193.40,180.00,39.43),
            Vector3(-539.49,180.00,39.43),
            Vector3(-845.91,180.00,345.86),
            Vector3(-845.91,180.00,587.93),
            Vector3(-961.38,180.00,703.40), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(-218.07,328.03,395.86),
        Vector3(-381.54,294.27,910.16),
      },
      heliLandPoint = {
        {
          point=Vector3(-351.61,321.89,768.34),
          startPoint=Vector3(-91.82,331.89,918.56),
          routeId="lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000"
        },
        {
          point=Vector3(-289.80,346.69,269.68),
          startPoint=Vector3(161.28,335.69,140.48),
          routeId="lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000"
        },
        {
          point=Vector3(-596.89,353.02,497.40),
          startPoint=Vector3(-946.28,309.02,981.35),
          routeId="lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000"
        },
      },
    },
    [10036]={ --A HERO'S WAY
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(1006.90,227.00,1606.90),
            Vector3(-544.99,227.00,1606.90),
            Vector3(-544.99,227.00,2866.90),
            Vector3(1357.90,227.00,2866.90),
            Vector3(1357.90,227.00,1957.90), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(665.93,210.47,2451.45),
            Vector3(665.93,210.47,1821.45),
            Vector3(-127.91,210.47,1821.45),
            Vector3(-127.91,210.47,2451.45), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(942.09,290.66,2357.63),
        Vector3(864.09,329.14,1682.99),
        Vector3(-102.06,276.40,1831.24),
      },
      heliLandPoint = {
        {
          point=Vector3(418.33,278.22,2261.37),
          startPoint=Vector3(887.95,309.12,2383.44),
          routeId="lz_drp_field_I0000|rt_drp_field_I_0000"
        },
        {
          point=Vector3(802.56,345.37,1637.75),
          startPoint=Vector3(1247.97,345.37,1298.36),
          routeId="lz_drp_field_N0000|rt_drp_field_N_0000"
        },
        {
          point=Vector3(-359.62,283.42,1714.79),
          startPoint=Vector3(-771.13,305.42,1447.29),
          routeId="lz_drp_field_W0000|rt_drp_field_W_0000"
        },
      },
    },
    [10040]={ --WHERE DO THE BEES SLEEP?
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(1414.63,220.09,-1123.40),
            Vector3(604.63,220.09,-313.40),
            Vector3(1180.63,220.09,262.60),
            Vector3(2625.13,220.09,262.60),
            Vector3(2625.13,220.09,-1978.40),
            Vector3(1414.63,220.09,-1978.40), 
          },  
        },
      },
      safetyArea2 = {},
      missionStartPoint = {
        Vector3(1116.82,322.19,-76.58),
      },
      heliLandPoint = {
        {
          point=Vector3(2106.16,463.64,-1747.21),
          startPoint=Vector3(2043.26,474.64,-1248.49),
          routeId="lz_drp_fort_I0000|rt_drp_fort_I_0000"
        },
        {
          point=Vector3(1187.73,320.98,-10.40),
          startPoint=Vector3(1489.55,336.98,65.91),
          routeId="lz_drp_slopedTownEast_E0000|rt_drp_slopedTownEast_E_0000"
        },
      },
    },
    [10041]={ --RED BRASS
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(-895.17,204.30,1536.07),
            Vector3(1.24,243.97,2432.28),
            Vector3(1022.88,231.70,2434.90),
            Vector3(1536.83,254.47,1919.95),
            Vector3(1536.05,269.43,895.81),
            Vector3(1536.05,269.43,895.81),
            Vector3(1024.20,314.57,382.74),
            Vector3(1025.58,343.35,252.96),
            Vector3(640.80,322.99,-129.22),
            Vector3(0.36,405.08,-128.88),
            Vector3(-253.80,332.66,128.53),
            Vector3(-897.70,477.84,129.34), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone_01", 
          vertices={ 
            Vector3(896.24,293.06,1536.30),
            Vector3(895.35,278.38,2046.77),
            Vector3(511.50,244.19,2431.13),
            Vector3(197.51,246.44,2433.68),
            Vector3(255.51,314.89,1790.82),
            Vector3(383.54,326.54,1789.59),
            Vector3(639.29,304.69,1534.85), 
          },  
        },
        { 
          name="trig_hotZone_02", 
          vertices={ 
            Vector3(767.97,302.40,866.95),
            Vector3(555.03,263.40,854.60),
            Vector3(511.44,258.97,894.87),
            Vector3(385.21,260.54,895.19),
            Vector3(256.28,319.20,767.70),
            Vector3(0.51,277.12,767.49),
            Vector3(-0.31,313.31,1356.47),
            Vector3(766.44,254.49,1353.08), 
          },  
        },
        { 
          name="trig_hotZone_03", 
          vertices={ 
            Vector3(-254.23,333.57,709.96),
            Vector3(-510.23,353.92,965.30),
            Vector3(-640.50,364.18,977.21),
            Vector3(-638.56,285.52,836.22),
            Vector3(-782.00,339.46,697.81),
            Vector3(-766.86,430.43,260.05),
            Vector3(-256.85,331.36,255.86), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(492.55,348.17,521.41),
        Vector3(-304.16,325.66,819.24),
        Vector3(1096.99,331.71,1453.27),
      },
      heliLandPoint = {
        {
          point=Vector3(-289.80,346.69,269.68),
          startPoint=Vector3(161.28,335.69,140.48),
          routeId="lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000"
        },
        {
          point=Vector3(802.56,345.37,1637.75),
          startPoint=Vector3(1247.97,345.37,1298.36),
          routeId="lz_drp_field_N0000|rt_drp_field_N_0000"
        },
        {
          point=Vector3(-359.62,283.42,1714.79),
          startPoint=Vector3(-771.13,305.42,1447.29),
          routeId="lz_drp_field_W0000|rt_drp_field_W_0000"
        },
        {
          point=Vector3(822.37,360.44,292.44),
          startPoint=Vector3(335.25,364.44,413.83),
          routeId="lz_drp_slopedTown_E0000|rt_drp_slopedTown_E_0000"
        },
        {
          point=Vector3(512.11,316.60,167.44),
          startPoint=Vector3(1074.92,379.60,506.01),
          routeId="lz_drp_slopedTown_I0000|rt_drp_slopedTown_I_0000"
        },
        {
          point=Vector3(1275.22,337.42,1313.33),
          startPoint=Vector3(1255.64,340.42,1747.07),
          routeId="lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000"
        },
        {
          point=Vector3(-351.61,321.89,768.34),
          startPoint=Vector3(-91.82,331.89,918.56),
          routeId="lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000"
        },
        {
          point=Vector3(418.33,278.22,2261.37),
          startPoint=Vector3(887.95,309.12,2383.44),
          routeId="lz_drp_field_I0000|rt_drp_field_I_0000"
        },
        {
          point=Vector3(-596.89,353.02,497.40),
          startPoint=Vector3(-946.28,309.02,981.35),
          routeId="lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000"
        },
      },
    },
    [10043]={ --C2W
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(-93.09,176.59,1524.90),
            Vector3(1338.70,176.59,1524.90),
            Vector3(1338.70,176.59,1323.08),
            Vector3(1802.91,176.59,1323.08),
            Vector3(1802.91,176.59,239.79),
            Vector3(1070.73,176.59,239.79),
            Vector3(1070.73,176.59,386.06),
            Vector3(789.20,176.59,386.06),
            Vector3(789.20,176.59,597.49),
            Vector3(-93.09,176.59,597.49), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(1488.70,176.59,673.08),
            Vector3(1802.91,176.59,573.08),
            Vector3(1802.91,176.59,189.79),
            Vector3(1220.73,176.59,189.79),
            Vector3(1220.73,176.59,536.06), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(1277.31,330.42,1311.32),
      },
      heliLandPoint = {
        {
          point=Vector3(1275.22,337.42,1313.33),
          startPoint=Vector3(1255.64,340.42,1747.07),
          routeId="lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000"
        },
        {
          point=Vector3(1444.40,364.14,390.78),
          startPoint=Vector3(925.92,368.14,502.51),
          routeId="lz_drp_commFacility_I0000|rt_drp_commFacility_I_0000"
        },
      },
    },
    [10044]={ --OCCUPATION FORCES
      missionArea2 = {
        { 
          name="innerZone", 
          vertices={ 
            Vector3(2560.00,404.21,-2048.00),
            Vector3(604.00,413.11,-2048.00),
            Vector3(604.00,413.11,-1344.00),
            Vector3(-448.00,413.11,-1344.00),
            Vector3(-448.00,413.11,-256.00),
            Vector3(100.00,413.11,-256.00),
            Vector3(100.00,413.11,-576.00),
            Vector3(570.05,413.11,-576.00),
            Vector3(573.83,413.11,-768.00),
            Vector3(663.60,413.11,-768.00),
            Vector3(896.00,413.11,-768.00),
            Vector3(896.00,413.11,-768.00),
            Vector3(896.00,413.11,-1088.00),
            Vector3(2560.00,413.11,-1088.00), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(446.45,336.90,-640.51),
            Vector3(36.00,335.77,-640.00),
            Vector3(36.00,335.77,-320.00),
            Vector3(-384.00,335.77,-320.00),
            Vector3(-384.00,335.77,-1280.00),
            Vector3(668.00,335.77,-1280.00),
            Vector3(668.00,335.77,-1984.00),
            Vector3(2496.00,335.77,-1984.00),
            Vector3(2496.00,335.77,-1152.00),
            Vector3(832.00,335.77,-1152.00),
            Vector3(832.00,335.77,-832.00),
            Vector3(547.41,335.77,-832.00),
            Vector3(547.34,334.63,-639.49), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(765.04,445.37,-1388.23),
        Vector3(392.03,411.17,-868.69),
      },
      heliLandPoint = {
        {
          point=Vector3(2106.16,463.64,-1747.21),
          startPoint=Vector3(2043.26,474.64,-1248.49),
          routeId="lz_drp_fort_I0000|rt_drp_fort_I_0000"
        },
        {
          point=Vector3(759.83,452.30,-1113.10),
          startPoint=Vector3(65.71,437.30,-792.83),
          routeId="lz_drp_cliffTown_I0000|rt_drp_cliffTown_I0000"
        },
        {
          point=Vector3(834.42,451.21,-1420.10),
          startPoint=Vector3(1398.39,514.21,-1245.88),
          routeId="lz_drp_cliffTown_N0000|rt_drp_clifftown_N_0000"
        },
        {
          point=Vector3(491.46,418.47,-693.19),
          startPoint=Vector3(886.63,393.47,-299.32),
          routeId="lz_drp_cliffTown_S0000|rt_drp_cliffTown_S_0000"
        },
      },
    },
    [10045]={ --TO KNOW TOO MUCH
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(-628.00,204.00,1232.00),
            Vector3(-1197.60,204.00,1801.60),
            Vector3(-1197.60,204.00,2171.84),
            Vector3(-884.32,204.00,2485.12),
            Vector3(1107.50,204.00,2485.12),
            Vector3(1107.50,204.00,1605.80),
            Vector3(-120.70,204.00,1605.80),
            Vector3(-120.70,204.00,1232.00), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(-1165.45,300.78,1961.37),
            Vector3(-426.53,332.25,2469.81),
            Vector3(7.73,238.02,1852.37),
            Vector3(-731.18,206.55,1343.92), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(799.48,327.50,1745.08),
      },
      heliLandPoint = {
        {
          point=Vector3(802.56,345.37,1637.75),
          startPoint=Vector3(1247.97,345.37,1298.36),
          routeId="lz_drp_field_N0000|rt_drp_field_N_0000"
        },
        {
          point=Vector3(418.33,278.22,2261.37),
          startPoint=Vector3(887.95,309.12,2383.44),
          routeId="lz_drp_field_I0000|rt_drp_field_I_0000"
        },
        {
          point=Vector3(-805.54,291.88,1820.65),
          startPoint=Vector3(-248.03,297.88,1963.33),
          routeId="lz_drp_remnants_I0000|rt_drp_remnants_I_0000"
        },
      },
    },
    [10050]={ --CLOAKED IN SILENCE
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(-1503.12,233.18,-25.15),
            Vector3(-1426.90,233.18,-468.66),
            Vector3(-1870.38,233.18,-544.99),
            Vector3(-1946.70,233.18,-101.51), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(-1526.68,233.18,-55.88),
            Vector3(-1458.93,233.18,-450.11),
            Vector3(-1853.13,233.18,-517.96),
            Vector3(-1920.98,233.18,-123.75), 
          },  
        },
      },
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [10052]={ --ANGEL WITH BROKEN WINGS
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(45.68,205.75,2176.00),
            Vector3(45.70,205.75,1811.34),
            Vector3(-1640.33,205.75,125.27),
            Vector3(-2048.00,205.75,125.27),
            Vector3(-2048.00,205.75,1408.00),
            Vector3(-1280.00,205.75,2176.00), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(-2030.49,205.75,638.47),
            Vector3(-2030.49,205.75,850.94),
            Vector3(-719.94,205.75,2158.71),
            Vector3(-378.96,205.75,2158.71),
            Vector3(-293.85,205.75,2073.61),
            Vector3(-293.85,205.75,1495.73),
            Vector3(-1320.96,205.75,468.49),
            Vector3(-1860.19,205.75,468.49), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(-425.12,282.10,2004.85),
      },
      heliLandPoint = {
        {
          point=Vector3(-1761.73,317.69,806.51),
          startPoint=Vector3(-1158.50,335.69,1422.75),
          routeId="lz_drp_tent_I0000|rt_drp_tent_I_0000"
        },
        {
          point=Vector3(-805.54,291.88,1820.65),
          startPoint=Vector3(-248.03,297.88,1963.33),
          routeId="lz_drp_remnants_I0000|rt_drp_remnants_I_0000"
        },
        {
          point=Vector3(-424.83,289.10,2004.96),
          startPoint=Vector3(54.07,312.10,2230.84),
          routeId="lz_drp_remnants_S0000|rt_drp_remnants_S_0000"
        },
      },
    },
    [10054]={ --BACKUP, BACK DOWN
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(-127.62,258.86,259.52),
            Vector3(-127.62,258.86,1386.09),
            Vector3(-764.70,258.86,2023.18),
            Vector3(-1506.76,258.87,2023.18),
            Vector3(-2122.12,258.87,1407.82),
            Vector3(-2122.12,258.87,388.44),
            Vector3(-1572.01,258.87,-161.67),
            Vector3(-548.84,258.87,-161.67), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(-127.62,258.86,259.52),
            Vector3(-127.62,258.86,1386.09),
            Vector3(-764.70,258.86,2023.18),
            Vector3(-1506.76,258.87,2023.18),
            Vector3(-2122.12,258.87,1407.82),
            Vector3(-2122.12,258.87,388.44),
            Vector3(-1572.01,258.87,-161.67),
            Vector3(-548.84,258.87,-161.67), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(-289.90,339.60,276.04),
        Vector3(-1344.53,299.51,1157.05),
        Vector3(-1905.65,333.13,555.18),
      },
      heliLandPoint = {
        {
          point=Vector3(-1868.78,338.48,538.78),
          startPoint=Vector3(-1886.95,348.98,166.98),
          routeId="lz_drp_tent_N0000|rt_drp_tent_N_0000"
        },
        {
          point=Vector3(-351.61,321.89,768.34),
          startPoint=Vector3(-91.82,331.89,918.56),
          routeId="lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000"
        },
        {
          point=Vector3(-1761.73,317.69,806.51),
          startPoint=Vector3(-1158.50,335.69,1422.75),
          routeId="lz_drp_tent_I0000|rt_drp_tent_I_0000"
        },
        {
          point=Vector3(-836.84,288.90,1574.03),
          startPoint=Vector3(-312.47,306.90,1792.76),
          routeId="lz_drp_remnantsNorth_N0000|rt_drp_remnantsNorth_N_0000"
        },
        {
          point=Vector3(-805.54,291.88,1820.65),
          startPoint=Vector3(-248.03,297.88,1963.33),
          routeId="lz_drp_remnants_I0000|rt_drp_remnants_I_0000"
        },
        {
          point=Vector3(-596.89,353.02,497.40),
          startPoint=Vector3(-946.28,309.02,981.35),
          routeId="lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000"
        },
      },
    },
    [10070]={ --HELLBOUND
      missionArea2 = {
        { 
          name="trig_innerZone_01", 
          vertices={ 
            Vector3(-451.80,465.27,-1471.82),
            Vector3(-880.53,356.86,-1002.45),
            Vector3(-2748.29,348.50,-1002.28),
            Vector3(-2748.75,362.11,-1984.15),
            Vector3(-451.28,488.01,-1984.17), 
          },  
        },
        { 
          name="trig_innerZone_02", 
          vertices={ 
            Vector3(-1444.27,465.27,-1599.11),
            Vector3(-1443.48,356.86,-972.49),
            Vector3(-2720.17,348.50,-993.99),
            Vector3(-2733.90,362.11,-1851.76),
            Vector3(-1987.58,488.01,-1856.46),
            Vector3(-1987.49,476.79,-1600.21), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(-2046.91,376.46,-1071.55),
            Vector3(-2058.20,362.71,-1038.40),
            Vector3(-2450.99,347.93,-1040.55),
            Vector3(-2696.60,362.50,-1542.06),
            Vector3(-2430.90,360.33,-1874.87),
            Vector3(-2052.43,379.00,-1871.44),
            Vector3(-1767.86,392.62,-1542.68), 
          },  
        },
      },
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [10080]={ --PITCH DARK
      missionArea2 = {
        { 
          name="innerZone", 
          vertices={ 
            Vector3(-368.00,-78.94,1368.00),
            Vector3(-128.00,-78.94,1152.00),
            Vector3(-128.00,-78.94,-512.00),
            Vector3(-1280.00,-78.94,-512.00),
            Vector3(-1280.00,-80.22,-128.00),
            Vector3(-1280.00,-80.22,-128.00),
            Vector3(-1280.00,-80.22,-128.00),
            Vector3(-1280.00,-82.57,208.00),
            Vector3(-1280.00,-82.57,208.00),
            Vector3(-1024.00,-78.94,464.00),
            Vector3(-1024.00,-78.94,464.00),
            Vector3(-1024.00,-78.94,464.00),
            Vector3(-1024.00,-78.94,624.00),
            Vector3(-768.00,-78.94,880.00),
            Vector3(-768.00,-78.94,880.00),
            Vector3(-768.00,-78.94,1072.00),
            Vector3(-642.07,-78.94,1152.00),
            Vector3(-640.00,-78.94,1216.00),
            Vector3(-512.00,-78.94,1344.00),
            Vector3(-512.00,-78.94,1368.00), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="hotZone", 
          vertices={ 
            Vector3(-576.00,-78.94,544.00),
            Vector3(-448.00,-78.94,416.00),
            Vector3(-448.00,-78.94,-400.00),
            Vector3(-448.00,-78.94,-624.00),
            Vector3(-1392.00,-78.94,-624.00),
            Vector3(-1392.00,-80.22,-128.00),
            Vector3(-1392.00,-80.22,-128.00),
            Vector3(-1392.00,-80.22,-128.00),
            Vector3(-1392.00,-82.57,-0.00),
            Vector3(-1392.00,-82.57,-0.00),
            Vector3(-1392.00,-78.94,272.00),
            Vector3(-1392.00,-78.94,272.00),
            Vector3(-1392.00,-78.94,272.00),
            Vector3(-1120.00,-78.94,544.00), 
          },  
        },
      },
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [10081]={ --ROOT CAUSE
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(418.21,-55.96,-811.08),
            Vector3(859.29,-55.96,-811.08),
            Vector3(859.29,-55.96,-563.91),
            Vector3(1603.25,-55.96,-563.91),
            Vector3(1603.76,99.96,-828.15),
            Vector3(1408.89,129.67,-1023.14),
            Vector3(1407.82,113.13,-1344.87),
            Vector3(414.78,64.68,-1345.76), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(512.42,-58.49,-851.54),
            Vector3(1334.61,-58.49,-851.54),
            Vector3(1334.61,-58.49,-851.54),
            Vector3(1334.61,-58.49,-851.54),
            Vector3(1345.49,51.35,-1279.86),
            Vector3(511.69,51.35,-1279.86), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(1211.75,96.57,-752.04),
      },
      heliLandPoint = {
        {
          point=Vector3(1203.80,107.74,-792.16),
          startPoint=Vector3(1225.37,122.74,-303.61),
          routeId="lz_drp_diamondSouth_W0000|rt_drp_diamondSouth_W_0000"
        },
      },
    },
    [10082]={ --FOOTPRINTS OF PHANTOMS
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(26.69,-55.28,-225.84),
            Vector3(682.40,-55.28,706.07),
            Vector3(1582.09,-55.28,73.03),
            Vector3(926.38,-55.28,-858.88), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(60.99,-55.28,-217.14),
            Vector3(687.23,-55.28,672.88),
            Vector3(1546.48,-55.28,68.29),
            Vector3(920.24,-55.28,-821.73), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(592.67,-9.82,406.99),
      },
      heliLandPoint = {
        {
          point=Vector3(1014.25,57.18,-221.46),
          startPoint=Vector3(263.05,40.18,-292.45),
          routeId="lz_drp_savannah_I0000|rt_drp_savannah_I_0000"
        },
        {
          point=Vector3(582.54,-3.14,418.17),
          startPoint=Vector3(416.04,37.87,955.68),
          routeId="lz_drp_pfCampNorth_S0000|rt_drp_pfCampNorth_S_0000"
        },
      },
    },
    [10085]={ --CLOSE CONTACT
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(2650.17,-113.61,-637.64),
            Vector3(1792.72,-115.14,-637.64),
            Vector3(1448.37,-126.44,-293.44),
            Vector3(1447.81,-130.93,884.45),
            Vector3(2123.47,-125.87,883.32),
            Vector3(2648.24,-110.49,358.82), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(2508.38,11.61,-445.77),
            Vector3(2213.34,-115.14,-445.76),
            Vector3(2077.08,147.50,-308.70),
            Vector3(2077.10,147.50,-35.06),
            Vector3(1941.28,11.61,100.81),
            Vector3(1941.45,11.61,487.32),
            Vector3(2372.43,11.61,487.22),
            Vector3(2508.38,147.50,351.41), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(1676.12,49.58,-276.88),
        Vector3(1959.47,33.69,477.70),
      },
      heliLandPoint = {
        {
          point=Vector3(1769.46,28.60,560.59),
          startPoint=Vector3(1318.61,56.60,247.85),
          routeId="lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000"
        },
        {
          point=Vector3(1734.22,66.01,-407.54),
          startPoint=Vector3(1905.69,129.57,-767.85),
          routeId="lz_drp_hillNorth_W0000|rt_drp_hillNorth_W_0000"
        },
        {
          point=Vector3(2154.83,63.09,366.70),
          startPoint=Vector3(1472.96,56.09,535.65),
          routeId="lz_drp_hill_I0000|rt_drp_hill_I_0000"
        },
      },
    },
    [10086]={ --LINGUA FRANCA
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(-225.00,-99.80,-460.00),
            Vector3(-52.00,-99.80,-633.00),
            Vector3(146.00,-99.80,-633.00),
            Vector3(451.75,-99.80,-327.25),
            Vector3(451.75,-99.80,92.26),
            Vector3(-27.00,-99.80,571.00),
            Vector3(-27.00,-99.80,871.00),
            Vector3(-125.00,-99.80,969.00),
            Vector3(-366.00,-99.80,969.00),
            Vector3(-366.00,-99.80,740.00),
            Vector3(-474.00,-99.80,632.00),
            Vector3(-577.00,-99.80,632.00),
            Vector3(-694.00,-99.80,515.00),
            Vector3(-694.00,-99.80,-247.00),
            Vector3(-481.00,-99.80,-460.00), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(-163.40,-99.45,-472.00),
            Vector3(101.00,-99.45,-472.00),
            Vector3(101.00,-99.45,296.00),
            Vector3(-474.00,-99.45,296.00),
            Vector3(-614.00,-99.45,156.00),
            Vector3(-614.00,-99.45,-246.00),
            Vector3(-392.00,-99.45,-246.00), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(-389.61,-0.31,431.53),
      },
      heliLandPoint = {
        {
          point=Vector3(-19.63,11.17,140.91),
          startPoint=Vector3(-690.06,9.17,384.74),
          routeId="lz_drp_swamp_I0000|rt_drp_swamp_I_0000"
        },
        {
          point=Vector3(-163.59,7.96,385.58),
          startPoint=Vector3(129.00,40.96,832.24),
          routeId="lz_drp_swamp_S0000|rt_drp_swamp_S_0000"
        },
        {
          point=Vector3(-618.09,6.48,232.79),
          startPoint=Vector3(-1170.26,39.73,167.57),
          routeId="lz_drp_swamp_W0000|lz_drp_swamp_W_0000"
        },
      },
    },
    [10090]={ --TRAITORS' CARAVAN
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(624.00,-123.00,1664.00),
            Vector3(1663.00,-123.00,1664.00),
            Vector3(1665.00,-123.00,-448.00),
            Vector3(192.00,-123.00,-448.00),
            Vector3(128.00,-123.00,-513.00),
            Vector3(-1280.00,-123.00,-512.00),
            Vector3(-1280.00,-123.00,208.00),
            Vector3(-1024.00,-123.00,464.00),
            Vector3(-384.00,-123.00,464.00),
            Vector3(-0.00,-123.00,848.00),
            Vector3(-0.00,-123.00,1040.00), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(871.00,-123.00,1600.00),
            Vector3(1327.00,-123.00,1600.00),
            Vector3(1553.00,-123.00,1373.00),
            Vector3(1553.00,-123.00,-335.00),
            Vector3(0.00,-123.00,-335.00),
            Vector3(-304.00,-123.00,-640.00),
            Vector3(-1406.00,-123.00,-640.00),
            Vector3(-1406.00,-123.00,210.00),
            Vector3(-342.00,-123.00,210.00),
            Vector3(311.00,-123.00,854.00),
            Vector3(311.00,-123.00,1040.00), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(571.07,-7.50,386.21),
      },
      heliLandPoint = {
        {
          point=Vector3(846.46,-4.97,1148.62),
          startPoint=Vector3(1340.72,3.13,1707.16),
          routeId="lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000"
        },
        {
          point=Vector3(1014.25,57.18,-221.46),
          startPoint=Vector3(263.05,40.18,-292.45),
          routeId="lz_drp_savannah_I0000|rt_drp_savannah_I_0000"
        },
        {
          point=Vector3(582.54,-3.14,418.17),
          startPoint=Vector3(416.04,37.87,955.68),
          routeId="lz_drp_pfCampNorth_S0000|rt_drp_pfCampNorth_S_0000"
        },
        {
          point=Vector3(-19.63,11.17,140.91),
          startPoint=Vector3(-690.06,9.17,384.74),
          routeId="lz_drp_swamp_I0000|rt_drp_swamp_I_0000"
        },
        {
          point=Vector3(-1001.38,-7.20,-199.16),
          startPoint=Vector3(-853.18,22.80,251.66),
          routeId="lz_drp_flowStation_I0000|rt_drp_flowStation_I_0000"
        },
      },
    },
    [10091]={ --RESCUE THE INTEL AGENTS
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(544.00,-92.04,480.00),
            Vector3(542.70,-92.04,-608.01),
            Vector3(542.70,-92.04,-608.01),
            Vector3(-544.00,-92.04,-608.00),
            Vector3(-800.00,-92.04,-352.00),
            Vector3(-800.00,-92.04,224.00),
            Vector3(-544.00,-92.04,480.00), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(384.00,-91.07,352.00),
            Vector3(384.00,-91.07,-480.00),
            Vector3(384.00,-91.07,-480.00),
            Vector3(-512.00,-91.07,-480.00),
            Vector3(-768.00,-91.07,-320.00),
            Vector3(-768.00,-91.07,192.00),
            Vector3(-512.00,-91.07,352.00), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(-726.65,7.79,-360.65),
      },
      heliLandPoint = {
        {
          point=Vector3(-610.26,13.10,-398.20),
          startPoint=Vector3(-513.43,36.10,39.07),
          routeId="lz_drp_flowStation_E0000|lz_drp_flowStation_E_0000"
        },
        {
          point=Vector3(-19.63,11.17,140.91),
          startPoint=Vector3(-690.06,9.17,384.74),
          routeId="lz_drp_swamp_I0000|rt_drp_swamp_I_0000"
        },
        {
          point=Vector3(-618.09,6.48,232.79),
          startPoint=Vector3(-1170.26,39.73,167.57),
          routeId="lz_drp_swamp_W0000|lz_drp_swamp_W_0000"
        },
      },
    },
    [10093]={ --CURSED LEGACY
      missionArea2 = {
        { 
          name="trap_innerZone", 
          vertices={ 
            Vector3(2880.22,31.98,-1632.86),
            Vector3(2880.40,104.39,-2591.27),
            Vector3(1831.71,47.81,-2591.22),
            Vector3(1831.37,61.76,-1632.81),
            Vector3(2880.22,31.98,-1632.86), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trap_hotZone", 
          vertices={ 
            Vector3(2877.15,31.98,-1729.20),
            Vector3(2877.34,104.39,-2588.17),
            Vector3(1969.79,47.81,-2588.13),
            Vector3(1969.45,61.76,-1729.16),
            Vector3(2877.15,31.98,-1729.20), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(2588.31,190.33,-2491.76),
        Vector3(2509.88,102.72,-1808.14),
        Vector3(2040.85,189.38,-2211.11),
      },
      heliLandPoint = {
        {
          point=Vector3(2331.11,208.01,-2487.00),
          startPoint=Vector3(2069.32,209.01,-2087.33),
          routeId="lz_drp_lab_W0000|rt_drp_lab_W_0000"
        },
        {
          point=Vector3(2521.90,111.82,-1833.82),
          startPoint=Vector3(2481.70,86.82,-1321.02),
          routeId="lz_drp_lab_S0000|rt_drp_lab_S_0000"
        },
      },
    },
    [10100]={ --BLOOD RUNS DEEP
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(2092.00,-24.12,-2376.01),
            Vector3(1064.06,-24.12,-2376.00),
            Vector3(-0.00,-24.12,-1311.69),
            Vector3(-0.01,-24.12,-384.13),
            Vector3(2092.04,-24.12,-384.04), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(2042.00,-24.12,-2326.01),
            Vector3(1064.06,-24.12,-2326.00),
            Vector3(50.00,-24.12,-1311.69),
            Vector3(49.99,-24.12,-434.13),
            Vector3(2042.04,-24.12,-434.04), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(265.18,2.34,-467.95),
        Vector3(484.26,67.85,-1316.00),
      },
      heliLandPoint = {
        {
          point=Vector3(510.10,20.43,-732.55),
          startPoint=Vector3(430.71,35.43,-208.19),
          routeId="lz_drp_savannahWest_N0000|lz_drp_savannahWest_N_0000"
        },
        {
          point=Vector3(1381.85,137.05,-1516.01),
          startPoint=Vector3(1083.13,158.05,-1892.86),
          routeId="lz_drp_diamond_I0000|rt_drp_diamond_I_0000"
        },
        {
          point=Vector3(300.61,50.06,-1237.66),
          startPoint=Vector3(559.74,38.06,-707.21),
          routeId="lz_drp_banana_I0000|rt_drp_banana_I_0000"
        },
      },
    },
    [10110]={ --VOICES
      missionArea2 = {
        { 
          name="Trig_innerZone", 
          vertices={ 
            Vector3(1778.00,-63.00,196.00),
            Vector3(1778.00,-63.00,-8.00),
            Vector3(1778.00,-63.00,-57.00),
            Vector3(1778.00,-63.00,-199.00),
            Vector3(1778.00,-63.00,-384.00),
            Vector3(1946.00,-63.00,-384.00),
            Vector3(2148.00,-63.00,-384.00),
            Vector3(2148.00,-63.00,-1289.80),
            Vector3(2507.09,-63.00,-1289.96),
            Vector3(2505.69,-63.00,-1089.79),
            Vector3(2984.00,-63.00,-1088.03),
            Vector3(2984.00,-63.00,-349.00),
            Vector3(2686.00,-63.00,-349.00),
            Vector3(2686.00,-63.00,-278.00),
            Vector3(2687.95,-63.00,509.48),
            Vector3(2430.88,-63.00,763.20),
            Vector3(1717.00,-63.00,762.70),
            Vector3(1717.00,-63.00,424.00),
            Vector3(1719.00,-63.00,420.00),
            Vector3(1778.00,-63.00,420.20), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="Trig_hotZone", 
          vertices={ 
            Vector3(2664.31,76.67,-923.01),
            Vector3(2697.92,88.21,-987.19),
            Vector3(2867.15,103.90,-996.88),
            Vector3(2978.33,96.39,-922.24),
            Vector3(2971.94,89.17,-826.97),
            Vector3(2825.50,95.36,-754.85),
            Vector3(2685.86,86.31,-861.37), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(1899.35,9.51,582.51),
      },
      heliLandPoint = {
        {
          point=Vector3(2154.83,63.09,366.70),
          startPoint=Vector3(1472.96,56.09,535.65),
          routeId="lz_drp_hill_I0000|rt_drp_hill_I_0000"
        },
        {
          point=Vector3(1769.46,28.60,560.59),
          startPoint=Vector3(1318.61,56.60,247.85),
          routeId="lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000"
        },
      },
    },
    [10115]={ --RETAKE THE PLATFORM
      missionArea2 = {},
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [10120]={ --THE WHITE MAMBA
      missionArea2 = {
        { 
          name="innerZone", 
          vertices={ 
            Vector3(-402.03,-20.50,768.08),
            Vector3(-682.04,-49.50,413.07),
            Vector3(-984.00,-31.11,413.00),
            Vector3(-984.00,-35.90,624.00),
            Vector3(-768.00,-36.11,880.00),
            Vector3(-767.00,-36.25,1079.00),
            Vector3(-587.27,-36.52,1200.80),
            Vector3(-587.27,-36.52,1363.80),
            Vector3(-402.00,-66.13,1364.00), 
          },  
        },
      },
      safetyArea2 = {},
      missionStartPoint = {
        Vector3(-932.20,-20.51,600.14),
      },
      heliLandPoint = {
        {
          point=Vector3(-807.61,3.47,516.01),
          startPoint=Vector3(-428.89,33.47,271.33),
          routeId="lz_drp_outland_N0000|rt_drp_outland_N_0000"
        },
      },
    },
    [10121]={ --THE WAR ECONOMY
      missionArea2 = {
        { 
          name="trig_InnerZone", 
          vertices={ 
            Vector3(1153.51,-101.51,384.25),
            Vector3(896.37,-112.00,640.43),
            Vector3(638.57,-108.93,640.60),
            Vector3(384.91,-98.06,896.38),
            Vector3(387.14,-60.60,1276.82),
            Vector3(767.54,-113.21,1663.08),
            Vector3(1152.08,-107.49,1664.93),
            Vector3(1409.31,-108.61,1919.39),
            Vector3(1666.91,-106.50,1918.91),
            Vector3(1790.00,-111.56,1792.61),
            Vector3(1793.80,-105.72,1539.13),
            Vector3(1664.48,-108.66,1407.37),
            Vector3(1664.81,-111.08,1025.25),
            Vector3(1408.27,-114.07,768.72),
            Vector3(1408.02,-112.38,640.31), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_HotZone", 
          vertices={ 
            Vector3(1151.35,-109.15,1598.21),
            Vector3(768.59,-111.20,1592.14),
            Vector3(576.00,-88.25,1408.00),
            Vector3(572.65,-109.06,896.65),
            Vector3(767.71,-112.77,698.35),
            Vector3(1151.31,-112.79,698.99),
            Vector3(1152.51,-113.30,895.11),
            Vector3(1153.00,-113.54,1145.04),
            Vector3(1280.40,-113.41,1278.40),
            Vector3(1283.08,-113.47,1470.53), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(1047.60,-3.47,732.79),
      },
      heliLandPoint = {
        {
          point=Vector3(846.46,-4.97,1148.62),
          startPoint=Vector3(1340.72,3.13,1707.16),
          routeId="lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000"
        },
        {
          point=Vector3(1061.84,6.78,731.21),
          startPoint=Vector3(625.74,29.78,306.26),
          routeId="lz_drp_pfCamp_N0000|rt_drp_pfcamp_N_0000"
        },
      },
    },
    [10130]={ --CODE TALKER
      missionArea2 = {
        { 
          name="trap_innerZone", 
          vertices={ 
            Vector3(2879.42,-668.03,-2591.70),
            Vector3(1767.69,-668.03,-2591.70),
            Vector3(1767.69,-668.03,-1025.44),
            Vector3(2527.00,-668.03,-1025.44),
            Vector3(2526.97,-668.03,-1279.21),
            Vector3(2879.41,-668.03,-1631.65),
            Vector3(2879.42,-668.03,-2591.70), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trap_hotZone", 
          vertices={ 
            Vector3(2815.31,-668.02,-1665.44),
            Vector3(2815.50,-595.61,-2586.86),
            Vector3(1969.79,-652.19,-2586.82),
            Vector3(1969.45,-638.24,-1665.40),
            Vector3(2815.31,-668.02,-1665.44), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(2386.56,86.06,-1120.91),
      },
      heliLandPoint = {
        {
          point=Vector3(2441.72,78.25,-1191.68),
          startPoint=Vector3(2674.50,97.25,-1781.35),
          routeId="rts_drp_lab_S_0000"
        },
      },
    },
    [10140]={ --METALLIC ARCHAEA
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(980.90,-100.00,1024.54),
            Vector3(828.75,-100.00,936.09),
            Vector3(785.91,-100.00,1009.78),
            Vector3(723.21,-100.00,973.35),
            Vector3(659.32,-100.00,1037.70),
            Vector3(659.70,-100.00,1152.50),
            Vector3(715.95,-99.98,1185.19),
            Vector3(679.97,-100.00,1247.09),
            Vector3(826.31,-100.00,1332.16),
            Vector3(842.23,-100.00,1304.79),
            Vector3(858.64,-100.00,1314.40),
            Vector3(878.76,-100.00,1279.82),
            Vector3(934.22,-100.00,1312.07),
            Vector3(977.99,-100.00,1308.05),
            Vector3(1054.00,-100.00,1177.19),
            Vector3(933.04,-100.00,1106.87), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(980.90,-100.00,1024.54),
            Vector3(828.75,-100.00,936.09),
            Vector3(785.91,-100.00,1009.78),
            Vector3(723.21,-100.00,973.35),
            Vector3(659.32,-100.00,1037.70),
            Vector3(659.70,-100.00,1152.50),
            Vector3(715.95,-99.98,1185.19),
            Vector3(679.97,-100.00,1247.09),
            Vector3(826.31,-100.00,1332.16),
            Vector3(842.23,-100.00,1304.79),
            Vector3(858.64,-100.00,1314.40),
            Vector3(878.76,-100.00,1279.82),
            Vector3(934.22,-100.00,1312.07),
            Vector3(977.99,-100.00,1308.05),
            Vector3(1054.00,-100.00,1177.19),
            Vector3(933.04,-100.00,1106.87), 
          },  
        },
      },
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [10150]={ --SKULL FACE
      missionArea2 = {
        { 
          name="trig_innerZone_01", 
          vertices={ 
            Vector3(-1791.99,537.21,-2175.94),
            Vector3(-1664.18,509.14,-2176.01),
            Vector3(-1407.96,559.73,-2432.01),
            Vector3(-1151.91,583.02,-2688.02),
            Vector3(-1152.06,589.49,-3392.48),
            Vector3(-1791.90,558.23,-3393.69), 
          },  
        },
        { 
          name="trig_innerZone_03", 
          vertices={ 
            Vector3(-3494.58,174.72,3419.49),
            Vector3(3472.30,174.72,3419.49),
            Vector3(3472.30,174.72,-4037.82),
            Vector3(-3494.58,174.72,-3900.36), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(-3494.58,174.72,3419.49),
            Vector3(3472.30,174.72,3419.49),
            Vector3(3472.30,174.72,-4037.82),
            Vector3(-3494.58,174.72,-3900.36), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(-1737.74,538.55,-2188.85),
      },
      heliLandPoint = {},
    },
    [10151]={ --SAHELANTHROPUS
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(-761.72,313.58,-762.69),
            Vector3(-147.37,313.58,-762.69),
            Vector3(-147.37,313.58,-1259.50),
            Vector3(-761.72,313.58,-1259.50), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(-3494.58,174.72,3419.49),
            Vector3(3472.30,174.72,3419.49),
            Vector3(3472.30,174.72,-4037.82),
            Vector3(-3494.58,174.72,-3900.36), 
          },  
        },
      },
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [10156]={ --EXTRAORDINARY
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(815.80,128.00,1965.90),
            Vector3(1715.82,128.00,1954.53),
            Vector3(1728.00,128.00,960.00),
            Vector3(827.99,128.00,971.37), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(1338.95,160.00,1170.95),
            Vector3(1146.95,160.00,1362.95),
            Vector3(1146.95,160.00,1682.95),
            Vector3(1146.95,160.00,1682.95),
            Vector3(1146.95,160.00,1682.95),
            Vector3(1146.95,160.00,1682.95),
            Vector3(1338.95,160.00,1874.95),
            Vector3(1690.95,128.00,1522.95), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(1586.17,312.85,1807.30),
      },
      heliLandPoint = {
        {
          point=Vector3(1275.22,337.42,1313.33),
          startPoint=Vector3(1255.64,340.42,1747.07),
          routeId="lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000"
        },
        {
          point=Vector3(1272.20,329.63,1853.51),
          startPoint=Vector3(1250.48,317.63,2167.53),
          routeId="lz_drp_ruins_S0000|rt_drp_ruins_S_0000"
        },
      },
    },
    [10171]={ --PROXY WAR WITHOUT END
      missionArea2 = {
        { 
          name="trg_innerZone", 
          vertices={ 
            Vector3(-640.01,-95.22,-384.03),
            Vector3(-639.97,-103.10,205.98),
            Vector3(512.31,-48.21,1356.08),
            Vector3(1664.00,-107.09,1358.03),
            Vector3(2176.00,-88.63,896.00),
            Vector3(2176.07,-28.67,227.89),
            Vector3(1563.99,-49.63,-384.06), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trg_hotZone", 
          vertices={ 
            Vector3(671.53,-124.43,1312.92),
            Vector3(1176.82,-124.43,1312.92),
            Vector3(1176.82,-124.43,204.01),
            Vector3(672.12,-124.43,204.01), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(245.33,7.77,551.92),
        Vector3(1530.92,30.21,-33.40),
      },
      heliLandPoint = {
        {
          point=Vector3(846.46,-4.97,1148.62),
          startPoint=Vector3(1340.72,3.13,1707.16),
          routeId="lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000"
        },
        {
          point=Vector3(1769.46,28.60,560.59),
          startPoint=Vector3(1318.61,56.60,247.85),
          routeId="lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000"
        },
        {
          point=Vector3(-145.52,16.15,-379.20),
          startPoint=Vector3(474.18,30.15,-323.11),
          routeId="lz_drp_swamp_N0000|lz_drp_swamp_N_0000"
        },
        {
          point=Vector3(1119.97,10.72,317.63),
          startPoint=Vector3(564.28,31.72,31.20),
          routeId="lz_drp_savannahEast_S0000|lz_drp_savannahEast_S_0000"
        },
      },
    },
    [10195]={ --ON THE TRAIL
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(721.32,-53.04,-233.15),
            Vector3(719.91,-81.13,460.05),
            Vector3(951.99,-81.30,689.48),
            Vector3(1297.55,-86.01,690.89),
            Vector3(1475.10,-48.99,522.69),
            Vector3(1759.15,-29.99,523.55),
            Vector3(1759.66,-3.95,345.69),
            Vector3(1875.23,11.46,229.88),
            Vector3(2105.49,67.24,229.78),
            Vector3(2105.21,161.19,-924.52),
            Vector3(1415.82,191.21,-926.40), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone_01", 
          vertices={ 
            Vector3(1407.80,149.78,-829.36),
            Vector3(1345.29,105.24,-768.82),
            Vector3(1344.38,40.28,-642.12),
            Vector3(1536.04,89.99,-640.02),
            Vector3(1664.16,40.01,-512.45),
            Vector3(1792.13,103.27,-638.83),
            Vector3(1791.89,94.51,-768.12),
            Vector3(1727.49,106.43,-832.06), 
          },  
        },
        { 
          name="trig_hotZone_02", 
          vertices={ 
            Vector3(1763.13,40.01,-384.91),
            Vector3(1764.61,55.54,-2.89),
            Vector3(2059.37,32.92,2.70),
            Vector3(2058.74,85.74,-384.54), 
          },  
        },
        { 
          name="trig_hotZone_03", 
          vertices={ 
            Vector3(1666.85,55.54,-2.89),
            Vector3(1401.06,-49.69,0.31),
            Vector3(1406.11,-78.50,382.47),
            Vector3(1663.69,-43.19,403.56),
            Vector3(1866.97,33.04,176.94), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(1368.69,18.01,-164.46),
        Vector3(1096.41,5.67,449.27),
      },
      heliLandPoint = {
        {
          point=Vector3(1014.25,57.18,-221.46),
          startPoint=Vector3(263.05,40.18,-292.45),
          routeId="lz_drp_savannah_I0000|rt_drp_savannah_I_0000"
        },
        {
          point=Vector3(1119.97,10.72,317.63),
          startPoint=Vector3(564.28,31.72,31.20),
          routeId="lz_drp_savannahEast_S0000|lz_drp_savannahEast_S_0000"
        },
        {
          point=Vector3(1233.17,25.84,-127.05),
          startPoint=Vector3(1836.30,103.84,5.63),
          routeId="lz_drp_savannahEast_N0000|rt_drp_savannahEast_N_0000"
        },
      },
    },
    [10200]={ --AIM TRUE, YE VENGEFUL
      missionArea2 = {
        { 
          name="trig_InnerZone", 
          vertices={ 
            Vector3(1634.49,-43.17,-818.98),
            Vector3(1634.49,-43.17,-678.98),
            Vector3(1694.49,-43.17,-618.98),
            Vector3(1694.49,-43.17,-23.09),
            Vector3(1761.41,-43.17,45.63),
            Vector3(1844.20,-43.17,46.69),
            Vector3(1914.48,-43.17,119.89),
            Vector3(2141.64,-43.17,124.36),
            Vector3(2214.43,-43.17,53.55),
            Vector3(2214.30,-43.17,-568.34),
            Vector3(2084.49,-43.17,-698.98),
            Vector3(1984.49,-43.17,-698.98),
            Vector3(1864.49,-43.17,-818.98), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(2178.76,-44.69,-458.00),
            Vector3(1718.46,-80.55,-458.99),
            Vector3(1718.20,-95.17,-161.80),
            Vector3(1894.29,-101.74,5.83),
            Vector3(1894.59,-115.58,75.03),
            Vector3(1930.31,-113.09,112.70),
            Vector3(2128.70,-75.86,115.81),
            Vector3(2180.10,-77.50,67.64), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(1865.90,106.30,-682.01),
      },
      heliLandPoint = {
        {
          point=Vector3(1666.75,113.91,-740.61),
          startPoint=Vector3(1428.20,73.91,-136.30),
          routeId="lz_drp_hillNorth_N0000|rt_drp_hillNorth_N_0000"
        },
      },
    },
    [10211]={ --HUNTING DOWN
      missionArea2 = {
        { 
          name="trig_innerZone", 
          vertices={ 
            Vector3(896.00,-68.98,-704.00),
            Vector3(1024.00,-70.65,-576.00),
            Vector3(1280.93,-44.59,-578.57),
            Vector3(1472.00,-54.81,-386.23),
            Vector3(1472.00,-67.42,0.00),
            Vector3(1344.00,-68.60,128.00),
            Vector3(1344.00,-77.38,320.00),
            Vector3(1280.00,-81.38,320.00),
            Vector3(1024.00,-97.40,576.00),
            Vector3(1024.00,-99.84,704.00),
            Vector3(-0.00,-77.31,704.00),
            Vector3(-256.00,-91.18,448.00),
            Vector3(-512.00,-91.98,448.00),
            Vector3(-640.00,-92.18,320.00),
            Vector3(-704.00,-92.71,320.00),
            Vector3(-704.00,-89.59,0.00),
            Vector3(-256.00,-58.96,-448.00),
            Vector3(-0.00,-64.56,-704.00), 
          },  
        },
      },
      safetyArea2 = {
        { 
          name="trig_hotZone", 
          vertices={ 
            Vector3(-320.00,-46.97,384.00),
            Vector3(-256.00,-48.71,384.00),
            Vector3(-1.26,-36.09,640.00),
            Vector3(960.00,-56.18,640.00),
            Vector3(960.00,-52.69,512.00),
            Vector3(1088.00,-35.92,384.00),
            Vector3(1088.00,-18.33,-320.00),
            Vector3(640.00,-41.56,-320.00),
            Vector3(-128.00,-51.87,-320.00),
            Vector3(-320.00,-41.87,-128.00), 
          },  
        },
      },
      missionStartPoint = {
        Vector3(1295.21,22.27,-29.86),
        Vector3(571.34,-2.01,-364.91),
      },
      heliLandPoint = {
        {
          point=Vector3(1233.17,25.84,-127.05),
          startPoint=Vector3(1836.30,103.84,5.63),
          routeId="lz_drp_savannahEast_N0000|rt_drp_savannahEast_N_0000"
        },
        {
          point=Vector3(1014.25,57.18,-221.46),
          startPoint=Vector3(263.05,40.18,-292.45),
          routeId="lz_drp_savannah_I0000|rt_drp_savannah_I_0000"
        },
        {
          point=Vector3(-163.59,7.96,385.58),
          startPoint=Vector3(129.00,40.96,832.24),
          routeId="lz_drp_swamp_S0000|rt_drp_swamp_S_0000"
        },
        {
          point=Vector3(74.70,18.20,-689.41),
          startPoint=Vector3(430.19,36.20,-164.65),
          routeId="lz_drp_bananaSouth_N0000|rt_drp_bananaSouth_N_0000"
        },
        {
          point=Vector3(-19.63,11.17,140.91),
          startPoint=Vector3(-690.06,9.17,384.74),
          routeId="lz_drp_swamp_I0000|rt_drp_swamp_I_0000"
        },
      },
    },
    [10230]={ --KINGDOM OF THE FLIES
      missionArea2 = {},
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [10240]={ --SHINING LIGHTS: EVEN IN DEATH
      missionArea2 = {},
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {
        {
          point=Vector3(-162.70,4.97,-2105.86),
          startPoint=Vector3(204.36,89.64,-1560.65),
          routeId="rt_drp_mbqf_N"
        },
      },
    },
    [10260]={ --A QUIET EXIT
      missionArea2 = {
        { 
          name="InnerZone", 
          vertices={ 
            Vector3(-1212.60,234.48,1093.71),
            Vector3(-1372.60,234.48,1253.71),
            Vector3(-1372.60,234.48,1363.71),
            Vector3(-1212.60,234.48,1523.71),
            Vector3(-1062.60,234.48,1523.71),
            Vector3(-1062.60,234.48,1653.71),
            Vector3(-962.60,234.48,1753.71),
            Vector3(-962.60,234.48,1843.71),
            Vector3(-1012.60,234.48,1893.71),
            Vector3(-1012.60,234.48,1993.71),
            Vector3(-912.60,234.48,2093.71),
            Vector3(-762.60,234.48,2093.71),
            Vector3(-512.60,234.48,1843.71),
            Vector3(-512.60,234.48,1543.71),
            Vector3(-682.60,234.48,1373.71),
            Vector3(-862.60,234.48,1373.71),
            Vector3(-1142.60,234.48,1093.71), 
          },  
        },
        { 
          name="InnerZone0000", 
          vertices={ 
            Vector3(-961.32,165.29,1847.61),
            Vector3(-1004.72,164.00,1892.04),
            Vector3(-1011.26,163.78,1993.79),
            Vector3(-911.74,160.73,2092.87),
            Vector3(-759.48,160.16,2093.47),
            Vector3(-665.88,152.90,2000.43),
            Vector3(-659.24,134.93,1878.03),
            Vector3(-786.37,134.95,1737.06),
            Vector3(-926.52,161.07,1732.06),
            Vector3(-963.12,166.48,1768.52), 
          },  
        },
        { 
          name="InnerZone0001", 
          vertices={ 
            Vector3(-886.84,216.67,1669.50),
            Vector3(-966.44,236.85,1745.79),
            Vector3(-961.15,223.26,1848.36),
            Vector3(-1012.68,222.26,1904.18),
            Vector3(-1016.38,222.77,1991.97),
            Vector3(-913.66,219.14,2094.79),
            Vector3(-763.35,217.67,2094.86),
            Vector3(-671.88,210.78,2007.56),
            Vector3(-439.06,239.49,2240.75),
            Vector3(-248.73,202.11,2250.43),
            Vector3(-102.03,192.47,2112.34),
            Vector3(-436.50,193.77,1775.77),
            Vector3(-567.92,190.58,1775.70),
            Vector3(-684.79,185.27,1647.21), 
          },  
        },
        { 
          name="InnerZone0002", 
          vertices={ 
            Vector3(-424.22,252.51,2308.18),
            Vector3(-320.05,252.51,1911.26),
            Vector3(-491.41,252.51,1867.29),
            Vector3(-587.39,252.51,2268.89), 
          },  
        },
      },
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [10280]={ --TRUTH: THE MAN WHO SOLD THE WORLD
      missionArea2 = {},
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [30010]={ --Afghanistan Free Roam
      missionArea2 = {},
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {
        {
          point=Vector3(-289.80,346.69,269.68),
          startPoint=Vector3(161.28,335.69,140.48),
          routeId="lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000"
        },
        {
          point=Vector3(802.56,345.37,1637.75),
          startPoint=Vector3(1247.97,345.37,1298.36),
          routeId="lz_drp_field_N0000|rt_drp_field_N_0000"
        },
        {
          point=Vector3(-351.61,321.89,768.34),
          startPoint=Vector3(-91.82,331.89,918.56),
          routeId="lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000"
        },
        {
          point=Vector3(-1663.71,536.63,-2201.78),
          startPoint=Vector3(-1531.39,474.63,-1679.84),
          routeId="lz_drp_citadelSouth_S0000|rt_drp_citadelSouth_S_0000"
        },
        {
          point=Vector3(1651.17,353.38,587.98),
          startPoint=Vector3(1701.22,353.38,1084.22),
          routeId="lz_drp_commFacility_S0000|rt_drp_commFacility_S_0000"
        },
        {
          point=Vector3(834.42,451.21,-1420.10),
          startPoint=Vector3(1398.39,514.21,-1245.88),
          routeId="lz_drp_cliffTown_N0000|rt_drp_clifftown_N_0000"
        },
        {
          point=Vector3(-1718.06,474.38,-1713.62),
          startPoint=Vector3(-1590.27,526.60,-2075.17),
          routeId="lz_drp_sovietBase_N0000|rt_drp_sovietBase_N_0000"
        },
        {
          point=Vector3(64.77,434.32,-842.65),
          startPoint=Vector3(462.40,432.32,-727.01),
          routeId="lz_drp_cliffTownWest_S0000|rt_drp_cliffTownWest_S_0000"
        },
        {
          point=Vector3(-359.62,283.42,1714.79),
          startPoint=Vector3(-771.13,305.42,1447.29),
          routeId="lz_drp_field_W0000|rt_drp_field_W_0000"
        },
        {
          point=Vector3(418.33,278.22,2261.37),
          startPoint=Vector3(887.95,309.12,2383.44),
          routeId="lz_drp_field_I0000|rt_drp_field_I_0000"
        },
        {
          point=Vector3(-836.84,288.90,1574.03),
          startPoint=Vector3(-312.47,306.90,1792.76),
          routeId="lz_drp_remnantsNorth_N0000|rt_drp_remnantsNorth_N_0000"
        },
        {
          point=Vector3(2305.28,394.03,-923.73),
          startPoint=Vector3(2636.58,397.03,-805.06),
          routeId="lz_drp_fort_E0000|rt_drp_fort_E_0000"
        },
        {
          point=Vector3(1187.73,320.98,-10.40),
          startPoint=Vector3(1489.55,336.98,65.91),
          routeId="lz_drp_slopedTownEast_E0000|rt_drp_slopedTownEast_E_0000"
        },
        {
          point=Vector3(1444.40,364.14,390.78),
          startPoint=Vector3(925.92,368.14,502.51),
          routeId="lz_drp_commFacility_I0000|rt_drp_commFacility_I_0000"
        },
        {
          point=Vector3(-1677.59,360.88,-321.82),
          startPoint=Vector3(-1861.11,373.88,-136.02),
          routeId="lz_drp_waterway_I0000|rt_drp_waterway_I_0000"
        },
        {
          point=Vector3(-1949.57,439.73,-1170.39),
          startPoint=Vector3(-1441.68,439.73,-1006.99),
          routeId="lz_drp_sovietBase_S0000|rt_drp_sovietBase_S_0000"
        },
        {
          point=Vector3(-630.25,444.69,-910.73),
          startPoint=Vector3(-400.84,502.69,-1175.87),
          routeId="lz_drp_powerPlant_S0000|rt_drp_powerPlant_S_0000"
        },
        {
          point=Vector3(1904.32,368.36,81.33),
          startPoint=Vector3(1340.73,356.36,44.81),
          routeId="lz_drp_bridge_S0000|rt_drp_bridge_S_0000"
        },
        {
          point=Vector3(141.47,275.51,2353.44),
          startPoint=Vector3(-249.77,310.51,1998.40),
          routeId="lz_drp_fieldWest_S0000|rt_drp_fiieldWest_S_0000"
        },
        {
          point=Vector3(-424.83,289.10,2004.96),
          startPoint=Vector3(54.07,312.10,2230.84),
          routeId="lz_drp_remnants_S0000|rt_drp_remnants_S_0000"
        },
        {
          point=Vector3(822.37,360.44,292.44),
          startPoint=Vector3(335.25,364.44,413.83),
          routeId="lz_drp_slopedTown_E0000|rt_drp_slopedTown_E_0000"
        },
        {
          point=Vector3(1275.22,337.42,1313.33),
          startPoint=Vector3(1255.64,340.42,1747.07),
          routeId="lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000"
        },
        {
          point=Vector3(512.11,316.60,167.44),
          startPoint=Vector3(1074.92,379.60,506.01),
          routeId="lz_drp_slopedTown_I0000|rt_drp_slopedTown_I_0000"
        },
        {
          point=Vector3(2106.16,463.64,-1747.21),
          startPoint=Vector3(2043.26,474.64,-1248.49),
          routeId="lz_drp_fort_I0000|rt_drp_fort_I_0000"
        },
        {
          point=Vector3(-1761.73,317.69,806.51),
          startPoint=Vector3(-1158.50,335.69,1422.75),
          routeId="lz_drp_tent_I0000|rt_drp_tent_I_0000"
        },
        {
          point=Vector3(20.70,329.63,888.03),
          startPoint=Vector3(626.34,354.63,849.22),
          routeId="lz_drp_village_W0000|rt_drp_village_W_0000"
        },
        {
          point=Vector3(-1273.30,305.48,1342.07),
          startPoint=Vector3(-887.87,311.48,1427.74),
          routeId="lz_drp_remnantsNorth_S0000|rt_drp_remnantsNorth_S_0000"
        },
        {
          point=Vector3(612.73,355.48,911.22),
          startPoint=Vector3(2.37,343.48,848.51),
          routeId="lz_drp_village_N0000|rt_drp_village_N_0000"
        },
        {
          point=Vector3(-1868.78,338.48,538.78),
          startPoint=Vector3(-1886.95,348.98,166.98),
          routeId="lz_drp_tent_N0000|rt_drp_tent_N_0000"
        },
        {
          point=Vector3(-1372.18,318.33,934.68),
          startPoint=Vector3(-1183.10,332.33,1243.43),
          routeId="lz_drp_tent_E0000|rt_drp_tent_E_0000"
        },
        {
          point=Vector3(95.31,320.37,243.91),
          startPoint=Vector3(-454.10,368.37,206.70),
          routeId="lz_drp_slopedTown_W0000|rt_drp_slopedTown_W_0000"
        },
        {
          point=Vector3(-805.54,291.88,1820.65),
          startPoint=Vector3(-248.03,297.88,1963.33),
          routeId="lz_drp_remnants_I0000|rt_drp_remnants_I_0000"
        },
        {
          point=Vector3(1649.11,491.21,-1340.58),
          startPoint=Vector3(1034.49,511.21,-1286.79),
          routeId="lz_drp_fort_W0000|rt_drp_fort_W_0000"
        },
        {
          point=Vector3(1060.06,362.05,467.90),
          startPoint=Vector3(590.77,374.89,368.06),
          routeId="lz_drp_commFacility_W0000|rt_drp_commFacility_W_0000"
        },
        {
          point=Vector3(759.83,452.30,-1113.10),
          startPoint=Vector3(65.71,437.30,-792.83),
          routeId="lz_drp_cliffTown_I0000|rt_drp_cliffTown_I0000"
        },
        {
          point=Vector3(-662.20,556.88,-1489.06),
          startPoint=Vector3(-433.13,522.23,-1094.86),
          routeId="lz_drp_powerPlant_E0000|rt_drp_powerPlant_E_0000"
        },
        {
          point=Vector3(491.46,418.47,-693.19),
          startPoint=Vector3(886.63,393.47,-299.32),
          routeId="lz_drp_cliffTown_S0000|rt_drp_cliffTown_S_0000"
        },
        {
          point=Vector3(-596.89,353.02,497.40),
          startPoint=Vector3(-946.28,309.02,981.35),
          routeId="lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000"
        },
        {
          point=Vector3(1272.20,329.63,1853.51),
          startPoint=Vector3(1250.48,317.63,2167.53),
          routeId="lz_drp_ruins_S0000|rt_drp_ruins_S_0000"
        },
        {
          point=Vector3(-2355.80,445.52,-1431.61),
          startPoint=Vector3(-1639.10,466.52,-1589.67),
          routeId="lz_drp_sovietBase_E0000|rt_drp_sovietBase_E_0000"
        },
        {
          point=Vector3(-1219.28,416.14,-886.41),
          startPoint=Vector3(-583.54,445.14,-815.04),
          routeId="lz_drp_sovietSouth_S0000|rt_drp_sovietSouth_S_0000"
        },
      },
    },
    [30020]={ --Central Africa Free Roam
      missionArea2 = {},
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {
        {
          point=Vector3(2331.11,208.01,-2487.00),
          startPoint=Vector3(2069.32,209.01,-2087.33),
          routeId="lz_drp_lab_W0000|rt_drp_lab_W_0000"
        },
        {
          point=Vector3(2154.83,63.09,366.70),
          startPoint=Vector3(1472.96,56.09,535.65),
          routeId="lz_drp_hill_I0000|rt_drp_hill_I_0000"
        },
        {
          point=Vector3(1096.40,150.86,-1685.39),
          startPoint=Vector3(1145.97,148.86,-1044.72),
          routeId="lz_drp_diamond_N0000|rt_drp_diamond_N_0000"
        },
        {
          point=Vector3(-163.59,7.96,385.58),
          startPoint=Vector3(129.00,40.96,832.24),
          routeId="lz_drp_swamp_S0000|rt_drp_swamp_S_0000"
        },
        {
          point=Vector3(510.10,20.43,-732.55),
          startPoint=Vector3(430.71,35.43,-208.19),
          routeId="lz_drp_savannahWest_N0000|lz_drp_savannahWest_N_0000"
        },
        {
          point=Vector3(924.72,44.01,-931.28),
          startPoint=Vector3(1280.06,60.93,-437.63),
          routeId="lz_drp_diamondWest_S0000|lz_drp_diamondWest_S_0000"
        },
        {
          point=Vector3(-19.63,11.17,140.91),
          startPoint=Vector3(-690.06,9.17,384.74),
          routeId="lz_drp_swamp_I0000|rt_drp_swamp_I_0000"
        },
        {
          point=Vector3(846.46,-4.97,1148.62),
          startPoint=Vector3(1340.72,3.13,1707.16),
          routeId="lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000"
        },
        {
          point=Vector3(1014.25,57.18,-221.46),
          startPoint=Vector3(263.05,40.18,-292.45),
          routeId="lz_drp_savannah_I0000|rt_drp_savannah_I_0000"
        },
        {
          point=Vector3(1061.84,6.78,731.21),
          startPoint=Vector3(625.74,29.78,306.26),
          routeId="lz_drp_pfCamp_N0000|rt_drp_pfcamp_N_0000"
        },
        {
          point=Vector3(1381.85,137.05,-1516.01),
          startPoint=Vector3(1083.13,158.05,-1892.86),
          routeId="lz_drp_diamond_I0000|rt_drp_diamond_I_0000"
        },
        {
          point=Vector3(1203.80,107.74,-792.16),
          startPoint=Vector3(1225.37,122.74,-303.61),
          routeId="lz_drp_diamondSouth_W0000|rt_drp_diamondSouth_W_0000"
        },
        {
          point=Vector3(2271.82,84.84,-418.59),
          startPoint=Vector3(2416.57,86.54,-33.38),
          routeId="lz_drp_factoryWest_S0000|lz_drp_factoryWest_S_0000"
        },
        {
          point=Vector3(1007.02,-4.46,1557.61),
          startPoint=Vector3(1580.16,18.96,1490.89),
          routeId="lz_drp_pfCamp_S0000|lz_drp_pfCamp_S_0000"
        },
        {
          point=Vector3(-145.52,16.15,-379.20),
          startPoint=Vector3(474.18,30.15,-323.11),
          routeId="lz_drp_swamp_N0000|lz_drp_swamp_N_0000"
        },
        {
          point=Vector3(1786.78,170.73,-2130.50),
          startPoint=Vector3(1623.44,168.73,-1806.87),
          routeId="lz_drp_labWest_W0000|rt_drp_labWest_W_0000"
        },
        {
          point=Vector3(2521.90,111.82,-1833.82),
          startPoint=Vector3(2481.70,86.82,-1321.02),
          routeId="lz_drp_lab_S0000|rt_drp_lab_S_0000"
        },
        {
          point=Vector3(1119.97,10.72,317.63),
          startPoint=Vector3(564.28,31.72,31.20),
          routeId="lz_drp_savannahEast_S0000|lz_drp_savannahEast_S_0000"
        },
        {
          point=Vector3(1769.46,28.60,560.59),
          startPoint=Vector3(1318.61,56.60,247.85),
          routeId="lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000"
        },
        {
          point=Vector3(1951.46,49.82,88.58),
          startPoint=Vector3(1644.07,67.82,633.63),
          routeId="lz_drp_hill_N0000|lz_drp_hill_N_0000"
        },
        {
          point=Vector3(582.54,-3.14,418.17),
          startPoint=Vector3(416.04,37.87,955.68),
          routeId="lz_drp_pfCampNorth_S0000|rt_drp_pfCampNorth_S_0000"
        },
        {
          point=Vector3(-618.09,6.48,232.79),
          startPoint=Vector3(-1170.26,39.73,167.57),
          routeId="lz_drp_swamp_W0000|lz_drp_swamp_W_0000"
        },
        {
          point=Vector3(74.70,18.20,-689.41),
          startPoint=Vector3(430.19,36.20,-164.65),
          routeId="lz_drp_bananaSouth_N0000|rt_drp_bananaSouth_N_0000"
        },
        {
          point=Vector3(266.57,1.56,-234.08),
          startPoint=Vector3(744.40,33.56,86.60),
          routeId="lz_drp_swampEast_N0000|lz_drp_swampEast_N_0000"
        },
        {
          point=Vector3(1648.35,87.11,-555.26),
          startPoint=Vector3(1447.82,64.11,63.98),
          routeId="lz_drp_diamondSouth_S0000|lz_drp_diamondSouth_S_0000"
        },
        {
          point=Vector3(1688.90,-3.65,1520.55),
          startPoint=Vector3(1910.28,19.35,1883.37),
          routeId="lz_drp_hillSouth_W0000|lz_drp_hillSouth_W_0000"
        },
        {
          point=Vector3(300.61,50.06,-1237.66),
          startPoint=Vector3(559.74,38.06,-707.21),
          routeId="lz_drp_banana_I0000|rt_drp_banana_I_0000"
        },
        {
          point=Vector3(2465.21,71.47,230.49),
          startPoint=Vector3(2447.80,89.47,-244.96),
          routeId="lz_drp_hill_E0000|lz_drp_hill_E_0000"
        },
        {
          point=Vector3(2441.72,78.25,-1191.68),
          startPoint=Vector3(2678.54,97.25,-1790.59),
          routeId="lz_drp_factory_N0000|rt_drp_factory_N_0000"
        },
        {
          point=Vector3(1233.17,25.84,-127.05),
          startPoint=Vector3(1836.30,103.84,5.63),
          routeId="lz_drp_savannahEast_N0000|rt_drp_savannahEast_N_0000"
        },
        {
          point=Vector3(-610.26,13.10,-398.20),
          startPoint=Vector3(-513.43,36.10,39.07),
          routeId="lz_drp_flowStation_E0000|lz_drp_flowStation_E_0000"
        },
        {
          point=Vector3(-1001.38,-7.20,-199.16),
          startPoint=Vector3(-853.18,22.80,251.66),
          routeId="lz_drp_flowStation_I0000|rt_drp_flowStation_I_0000"
        },
        {
          point=Vector3(-440.57,-14.39,1339.17),
          startPoint=Vector3(-462.44,-5.39,1926.48),
          routeId="lz_drp_outland_S0000|rt_drp_outland_S_0000"
        },
      },
    },
    [30050]={ --Mother Base free roam
      missionArea2 = {},
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {},
    },
    [50050]={ --FOB MISSIONS
      missionArea2 = {},
      safetyArea2 = {},
      missionStartPoint = {},
      heliLandPoint = {},
    }
  },

  GetMissionParameter = function( missionId )
    --InfCore.LogFlow("mbdvc_map_mission_parameter.GetMissionParameter "..tostring(missionId))--tex
    local mapParams
    if InfMission then --tex> cant patch in the table from earlier in execution as it seems mbdvc_map_mission_parameter is torn down/reloaded
      mapParams=InfCore.PCallDebug(InfMission.GetMapMissionParameter,missionId)
    end--<
    return mapParams or mbdvc_map_mission_parameter.missionParameters[missionId] or mbdvc_map_mission_parameter.missionParameters.default
  end,
  
  GetMissionParameter2 = function( missionId )
    InfCore.LogFlow("mbdvc_map_mission_parameter.GetMissionParameter2 "..tostring(missionId))--tex

    if missionId >= 11000 then
      if missionId < 12000 then
        missionId = missionId - 1000
        Fox.Log("use parameter of mission:" .. missionId)
      end
    end

    local missionParameter = mbdvc_map_mission_parameter.GetMissionParameter( missionId )
    missionParameter[ "zoomScaleForMission" ]	= 4.0
    missionParameter[ "zoomScale2ForMission" ]	= 3.0

    --tex> disableLzs
    local lzTable=missionParameter.heliLandPoint
    local newLzTable={}
    if lzTable and Ivars.disableLzs:Is()>0 then
      local checkLzs=nil
      if Ivars.disableLzs:Is"ASSAULT" then
        checkLzs=TppLandingZone.assaultLzs
      elseif Ivars.disableLzs:Is"REGULAR" then
        checkLzs=TppLandingZone.missionLzs
      end
      --tex DEBUGNOW TODO
      for i=1,#lzTable do
        local lzInfo=lzTable[i]
        local addLz=true
        for location,lzs in pairs(checkLzs)do
          if lzs[lzInfo.routeId] then
            addLz=false
            break
          end
        end
        if addLz then
          newLzTable[#newLzTable+1]=lzInfo
        end
      end
      missionParameter.heliLandPoint=newLzTable
    end
    --<

    return missionParameter
  end,--GetMissionParameter2
}--mbdvc_map_mission_parameter
