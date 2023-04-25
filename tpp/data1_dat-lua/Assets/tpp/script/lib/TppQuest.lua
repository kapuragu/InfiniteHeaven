-- DOBUILD: 1
-- TppQuest.lua
InfCore.LogFlow"Load TppQuest.lua"--tex DEBUG
local this={}
local maxSteps=256
local defaultStepNumber=0
local questNameNone=0
local defaultQuestBlockName="quest_block"
local QStep_ClearStr="QStep_Clear"
local StrCode32=InfCore.StrCode32--tex was Fox.StrCode32
local StrCode32Table=Tpp.StrCode32Table
local IsTypeFunc=Tpp.IsTypeFunc
local IsTypeTable=Tpp.IsTypeTable
local IsTypeString=Tpp.IsTypeString
local TppDefine=TppDefine--tex

this.debugModule=false--tex

local questBlockStatus=TppDefine.Enum{"NONE","DEACTIVATE","DEACTIVATING","ACTIVATE"}
local missionTypes=TppDefine.Enum{"MISSION","FREE","HELI"}
local QUEST_STATUS_TYPES=TppDefine.Enum{"OPEN","CLEAR","FAILURE","UPDATE"}
local afgAreaList={"tent","field","ruins","waterway","cliffTown","commFacility","sovietBase","fort","citadel"}
local mafrAreaList={"outland","pfCamp","savannah","hill","banana","diamond","lab"}
local mtbsAreaList={"MtbsCommand","MtbsCombat","MtbsDevelop","MtbsMedical","MtbsSupport","MtbsSpy","MtbsBaseDev","MtbsPaz"}--tex added UNUSED GOTCHA: MtbsPaz?
local shootingPracticeMarkers={
  Command="ly003_cl00_npc0000|cl00pl0_uq_0000_npc2|Marker_shootingPractice",
  Develop="ly003_cl02_npc0000|cl02pl0_uq_0020_npc2|Marker_shootingPractice",
  Support="ly003_cl03_npc0000|cl03pl0_uq_0030_npc2|Marker_shootingPractice",
  BaseDev="ly003_cl06_npc0000|cl06pl0_uq_0060_npc2|Marker_shootingPractice",
  Medical="ly003_cl04_npc0000|cl04pl0_uq_0040_npc2|Marker_shootingPractice",
  Spy="ly003_cl05_npc0000|cl05pl0_uq_0050_npc2|Marker_shootingPractice",
  Combat="ly003_cl01_npc0000|cl01pl0_uq_0010_npc2|Marker_shootingPractice"
}
this.prevMissionType=missionTypes.HELI
--tex>
--NOTES:(incomplete)--total num in that category, afgh num, mafr num, mb num, lang string
--SYNC Ivars.QUEST_CATEGORIES
this.QUEST_CATEGORIES={
  "STORY",--11,7,2,2
  "EXTRACT_INTERPRETER",--4,2,2
  "BLUEPRINT",--6,4,2,Secure blueprint
  "EXTRACT_HIGHLY_SKILLED",--16,9,,Extract highly-skilled soldier
  "PRISONER",--20,10,Prisoner extraction
  "CAPTURE_ANIMAL",--4,2,
  "WANDERING_SOLDIER",--10,5,Wandering Mother Base soldier
  "DDOG_PRISONER",--5,Unlucky Dog
  "ELIMINATE_HEAVY_INFANTRY",--16
  "MINE_CLEARING",--10
  "ELIMINATE_ARMOR_VEHICLE",--14,Eliminate the armored vehicle unit
  "EXTRACT_GUNSMITH",--3,Extract the Legendary Gunsmith
  --"EXTRACT_CONTAINERS",--1, #110
  --"INTEL_AGENT_EXTRACTION",--1, #112
  "ELIMINATE_TANK_UNIT",--14
  "ELIMINATE_PUPPETS",--15
  "TARGET_PRACTICE",--7,0,0,7
  "NO_CATEGORY",--tex default given during load if addon info catergory nil, bucking tradition of having something like this first because this list is also used as (ih) category sort order
}--QUEST_CATEGORIES
this.QUEST_CATEGORIES_ENUM=TppDefine.Enum(this.QUEST_CATEGORIES)--tex from 0
--tex NMC: this is the main info for the UI for normal full player playable quests (see note below about hidden quests)
--a few more variables are added in GetSideOpsListTable
--also see TppQuestList for per quest area info
--NMC: see http://metalgearmodding.wikia.com/wiki/MissionCodes#Side_Ops.2FQuests (match with quest id after the q in questname below ex questName="ruins_q19010" = 19010
--actual GetQuestNameId. lang ids for quests are name_<questId>, info_<questId>
--index preceding the info (ie --[[001]]) is the sideop number in idroid
--see TppQuestList for the other main quest info tables, or see InfQuest to see the various stuff it pushes to get a quest added, or just search the questName through code to see what turns up
--Use GetSideOpsInfo(questName) to get entry
--NOTE: some quests are hidden which use the quest system more as a framework to do some stuff, that dont have entries in this table: 
--waterway_q99010 (Quiet fight), Mtbs_child_dog (sideop that controlls puppy ddog), mtbs_q99060 (paz)
--they are in TppQuestList ordered by priority, and will set clear flag when done
--tex ADDON modified by InfQuest to set up addon quests
--tex added categories-v-
local questInfoTable={
  --[[001]]{questName="ruins_q19010",questId="ruins_q19010",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1622.974,322.257,1062.973),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_INTERPRETER},
  --[[002]]{questName="commFacility_q19013",questId="commFacility_q19013",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1589.157,352.634,47.628),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_INTERPRETER},
  --[[003]]{questName="outland_q19011",questId="outland_q19011",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(222.113,20.445,-930.962),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_INTERPRETER},
  --[[004]]{questName="hill_q19012",questId="hill_q19012",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1910.658,59.872,-231.274),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_INTERPRETER},
  --[[005]]{questName="ruins_q60115",questId="quest_q60115",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(501.702,321.852,1194.651),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.BLUEPRINT},
  --[[006]]{questName="sovietBase_q60110",questId="quest_q60110",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-719.57,536.851,-1571.775),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.BLUEPRINT},
  --[[007]]{questName="citadel_q60112",questId="quest_q60112",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(785.013,473.162,-916.954),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.BLUEPRINT},
  --[[008]]{questName="outland_q60113",questId="quest_q60113",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-281.612,-8.36,751.687),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.BLUEPRINT},
  --[[009]]{questName="pfCamp_q60114",questId="quest_q60114",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(712.931,-3.225,1221.926),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.BLUEPRINT},
  --[[010]]{questName="sovietBase_q60111",questId="quest_q60111",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-2330.799,438.515,-1568.261),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.BLUEPRINT},
  --[[011]]{questName="tent_q10010",questId="tent_q10010",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1426.164,319.449,1053.029),radius=5.5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[012]]{questName="field_q10020",questId="field_q10020",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(574.394,320.805,1091.39),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[013]]{questName="fort_q10080",questId="fort_q10080",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(2144.585,459.984,-1764.566),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[014]]{questName="cliffTown_q10050",questId="cliffTown_q10050",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(545.646,339.103,7.983),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[015]]{questName="waterway_q10040",questId="waterway_q10040",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1200,399,-660),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[016]]{questName="commFacility_q10060",questId="commFacility_q10060",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1580.025,346.609,47.889),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[017]]{questName="pfCamp_q10200",questId="pfCamp_q10200",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1830.153,-12.065,1217.415),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[018]]{questName="outland_q10100",questId="outland_q10100",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-1117,-22,-250),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[019]]{questName="savannah_q10300",questId="savannah_q10300",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(352.291,-5.991,.927),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[020]]{questName="banana_q10500",questId="banana_q10500",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(846.97,36.452,-917.762),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[021]]{questName="hill_q10400",questId="hill_q10400",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2155.126,56.012,392.11),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[022]]{questName="diamond_q10600",questId="diamond_q10600",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1611.429,128.189,-848.904),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[023]]{questName="ruins_q10030",questId="ruins_q10030",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1301.97,331.741,1746.641),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[024]]{questName="sovietBase_q10070",questId="sovietBase_q10070",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-2081.274,436.152,-1532.619),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[025]]{questName="lab_q10700",questId="lab_q10700",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2695.907,154.625,-2304.778),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[026]]{questName="citadel_q10090",questId="citadel_q10090",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1258.72,598.68,-3055.925),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_HIGHLY_SKILLED},
  --[[027]]{questName="quest_q20065",questId="quest_q20065",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1481.748,359.7492,467.3845),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[028]]{questName="quest_q20025",questId="quest_q20025",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(419.7284,270.3819,2206.412),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[029]]{questName="quest_q20075",questId="quest_q20075",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-2200.667,443.142,-1632.121),radius=5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[030]]{questName="quest_q20805",questId="quest_q20805",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1876.726,321.956,-426.263),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[031]]{questName="quest_q20905",questId="quest_q20905",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1807.693,468.119,-1232.137),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[032]]{questName="quest_q20305",questId="quest_q20305",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(303.023,-5.295,401.582),radius=5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[033]]{questName="quest_q20035",questId="quest_q20035",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1444.029,332.4536,1493.478),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[034]]{questName="quest_q23005",questId="quest_q23005",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(269.693,43.457,-1208.378),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[035]]{questName="quest_q20045",questId="quest_q20045",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1721.014,349.7935,-300.9322),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[036]]{questName="quest_q21005",questId="quest_q21005",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-902.816,288.046,1905.899),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[037]]{questName="quest_q20105",questId="quest_q20105",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-318.246,-13.006,1078.101),radius=4,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[038]]{questName="quest_q24005",questId="quest_q24005",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2527.301,71.168,-817.188),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[039]]{questName="quest_q20505",questId="quest_q20505",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(592.412,52.144,-955.067),radius=4,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[040]]{questName="quest_q20605",questId="quest_q20605",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1532.148,127.692,-1296.662),radius=5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[041]]{questName="quest_q25005",questId="quest_q25005",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(967.334,-11.938,1269.883),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[042]]{questName="quest_q27005",questId="quest_q27005",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2073.421,51.254,355.372),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[043]]{questName="quest_q26005",questId="quest_q26005",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1728.982,155.168,-1869.883),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[044]]{questName="quest_q20055",questId="quest_q20055",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(784.1397,474.0518,-1008.116),radius=4,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[045]]{questName="quest_q22005",questId="quest_q22005",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1326.552,598.564,-3041.07),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[046]]{questName="quest_q20405",questId="quest_q20405",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2172.657,56.106,377.634),radius=4,category=this.QUEST_CATEGORIES_ENUM.PRISONER},
  --[[047]]{questName="field_q30010",questId="field_q30010",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(516.088,321.572,1065.328),radius=5,category=this.QUEST_CATEGORIES_ENUM.CAPTURE_ANIMAL},
  --[[048]]{questName="waterway_q39010",questId="waterway_q39010",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-473.987,417.258,-496.137),radius=7,category=this.QUEST_CATEGORIES_ENUM.CAPTURE_ANIMAL},
  --[[049]]{questName="lab_q39011",questId="lab_q39011",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2656.23,144.117,-2173.246),radius=7,category=this.QUEST_CATEGORIES_ENUM.CAPTURE_ANIMAL},
  --[[050]]{questName="pfCamp_q39012",questId="pfCamp_q39012",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1367.551,-3.12,1892.457),radius=7,category=this.QUEST_CATEGORIES_ENUM.CAPTURE_ANIMAL},
  --[[051]]{questName="commFacility_q80060",questId="commFacility_q80060",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1385.748,368,-23.469),radius=5,category=this.QUEST_CATEGORIES_ENUM.WANDERING_SOLDIER},
  --[[052]]{questName="field_q80020",questId="field_q80020",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(482.031,286.844,2474.655),radius=5,category=this.QUEST_CATEGORIES_ENUM.WANDERING_SOLDIER},
  --[[053]]{questName="outland_q80100",questId="outland_q80100",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-454.016,3.955,977.738),radius=5,category=this.QUEST_CATEGORIES_ENUM.WANDERING_SOLDIER},
  --[[054]]{questName="pfCamp_q80200",questId="pfCamp_q80200",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(338.505,1.002,1746.528),radius=5,category=this.QUEST_CATEGORIES_ENUM.WANDERING_SOLDIER},
  --[[055]]{questName="diamond_q80600",questId="diamond_q80600",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1460.408,121.347,-1411.282),radius=5,category=this.QUEST_CATEGORIES_ENUM.WANDERING_SOLDIER},
  --[[056]]{questName="hill_q80400",questId="hill_q80400",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2566.009,68,-200.753),radius=5,category=this.QUEST_CATEGORIES_ENUM.WANDERING_SOLDIER},
  --[[057]]{questName="tent_q80010",questId="tent_q80010",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1396.746,286.758,1009.375),radius=5,category=this.QUEST_CATEGORIES_ENUM.WANDERING_SOLDIER},
  --[[058]]{questName="lab_q80700",questId="lab_q80700",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2702.945,127.026,-1972.265),radius=5,category=this.QUEST_CATEGORIES_ENUM.WANDERING_SOLDIER},
  --[[059]]{questName="fort_q80080",questId="fort_q80080",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1408.371,500.486,-1300.667),radius=5,category=this.QUEST_CATEGORIES_ENUM.WANDERING_SOLDIER},
  --[[060]]{questName="waterway_q80040",questId="waterway_q80040",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1839.279,358.371,-339.326),radius=5,category=this.QUEST_CATEGORIES_ENUM.WANDERING_SOLDIER},
  --[[061]]{questName="quest_q20015",questId="quest_q20015",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1764.669,311.1947,805.5405),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.DDOG_PRISONER},--61 - Unlucky Dog 01>
  --[[062]]{questName="quest_q20085",questId="quest_q20085",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(2154.21,458.245,-1782.244),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.DDOG_PRISONER},
  --[[063]]{questName="quest_q20205",questId="quest_q20205",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(911.094,-3.444,1072.21),radius=6,category=this.QUEST_CATEGORIES_ENUM.DDOG_PRISONER},
  --[[064]]{questName="quest_q20705",questId="quest_q20705",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2643.892,143.728,-2179.943),radius=7,category=this.QUEST_CATEGORIES_ENUM.DDOG_PRISONER},
  --[[065]]{questName="quest_q20095",questId="quest_q20095",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1216.737,609.074,-3102.734),radius=5.5,category=this.QUEST_CATEGORIES_ENUM.DDOG_PRISONER},--65 - Unlucky Dog 05<
  --[[066]]{questName="tent_q11010",questId="tent_q11010",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1058.028,290.648,1472.578),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[067]]{questName="tent_q11020",questId="tent_q11020",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1143.261,322.876,839.478),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[068]]{questName="waterway_q11030",questId="waterway_q11030",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1347.736,397.481,-729.448),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[069]]{questName="cliffTown_q11040",questId="cliffTown_q11040",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(369.861,413.892,-905.375),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[070]]{questName="savannah_q11400",questId="savannah_q11400",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1200.66,7.889,113.637),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[071]]{questName="pfCamp_q11200",questId="pfCamp_q11200",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1555.195,-12.034,1790.219),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[072]]{questName="commFacility_q11080",questId="commFacility_q11080",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1475.388,344.972,13.41),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[073]]{questName="fort_q11060",questId="fort_q11060",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1812.198,465.938,-1241.909),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[074]]{questName="outland_q11090",questId="outland_q11090",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-386.984,9.648,762.663),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[075]]{questName="banana_q11600",questId="banana_q11600",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(563.844,77.95,-1070.378),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[076]]{questName="cliffTown_q11050",questId="cliffTown_q11050",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2383.08,86.157,-1125.214),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[077]]{questName="hill_q11500",questId="hill_q11500",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2342.049,68.132,-104.587),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[078]]{questName="savannah_q11300",questId="savannah_q11300",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(965.708,-4.035,287.023),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[079]]{questName="banana_q11700",questId="banana_q11700",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(713.795,33.409,-904.592),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[080]]{questName="fort_q11070",questId="fort_q11070",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(2194.519,429.075,-1284.068),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[081]]{questName="outland_q11100",questId="outland_q11100",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-552.513,-.011,-197.752),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_HEAVY_INFANTRY},
  --[[082]]{questName="sovietBase_q99020",questId="sovietBase_q99020",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-716.5531,536.7278,-1485.517),radius=5,isImportant=true,category=this.QUEST_CATEGORIES_ENUM.STORY},
  --[[083]]{questName="ruins_q60010",questId="ruins_q60010",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1331.732,295.46,2164.405),radius=4,category=this.QUEST_CATEGORIES_ENUM.MINE_CLEARING},
  --[[084]]{questName="tent_q60011",questId="tent_q60011",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-513.1647,372.9764,1148.782),radius=5,category=this.QUEST_CATEGORIES_ENUM.MINE_CLEARING},
  --[[085]]{questName="outland_q60024",questId="outland_q60024",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-1205.26,-21.20666,129.0079),radius=5,category=this.QUEST_CATEGORIES_ENUM.MINE_CLEARING},
  --[[086]]{questName="fort_q60013",questId="fort_q60013",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1921.452,456.3248,-1253.83),radius=4,category=this.QUEST_CATEGORIES_ENUM.MINE_CLEARING},
  --[[087]]{questName="hill_q60021",questId="hill_q60021",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2151.132,70.83097,-116.7761),radius=4.5,category=this.QUEST_CATEGORIES_ENUM.MINE_CLEARING},
  --[[088]]{questName="pfCamp_q60020",questId="pfCamp_q60020",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1555.736,-8.822165,1725.071),radius=4,category=this.QUEST_CATEGORIES_ENUM.MINE_CLEARING},
  --[[089]]{questName="cliffTown_q60012",questId="cliffTown_q60012",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(369.4612,412.6812,-844.1393),radius=4,category=this.QUEST_CATEGORIES_ENUM.MINE_CLEARING},
  --[[090]]{questName="banana_q60023",questId="banana_q60023",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(646.064,103.2225,-1122.37),radius=4,category=this.QUEST_CATEGORIES_ENUM.MINE_CLEARING},
  --[[091]]{questName="sovietBase_q60014",questId="sovietBase_q60014",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1440.167,415.0882,-1282.796),radius=4,category=this.QUEST_CATEGORIES_ENUM.MINE_CLEARING},
  --[[092]]{questName="lab_q60022",questId="lab_q60022",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2658.126,139.3819,-2146.524),radius=4,category=this.QUEST_CATEGORIES_ENUM.MINE_CLEARING},
  --[[093]]{questName="quest_q52030",questId="quest_q52030",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1889.494,332.666,546.761),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[094]]{questName="quest_q52010",questId="quest_q52010",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1388.719,299.004,1976.527),radius=6,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[095]]{questName="quest_q52040",questId="quest_q52040",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1589.128,511.561,-2113.037),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[096]]{questName="quest_q52020",questId="quest_q52020",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-380.063,-2.53,490.478),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[097]]{questName="quest_q52050",questId="quest_q52050",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(672.542,-3.727,108.875),radius=6,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[098]]{questName="quest_q52070",questId="quest_q52070",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2364.716,56.688,314.611),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[099]]{questName="quest_q52060",questId="quest_q52060",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1156.773,-12.097,1524.507),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[100]]{questName="quest_q52080",questId="quest_q52080",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(793.002,347.536,255.957),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[101]]{questName="quest_q52090",questId="quest_q52090",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1722.589,152.294,-2079.907),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[102]]{questName="quest_q52100",questId="quest_q52100",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(810.898,-11.701,1194.177),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[103]]{questName="quest_q52130",questId="quest_q52130",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1836.664,358.543,-326.481),radius=6,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[104]]{questName="quest_q52110",questId="quest_q52110",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-1007.882,-14.2,-231.401),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[105]]{questName="quest_q52120",questId="quest_q52120",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(840.141,4.947,-130.741),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[106]]{questName="quest_q52140",questId="quest_q52140",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-608.622,278.374,1694.876),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_ARMOR_VEHICLE},
  --[[107]]{questName="outland_q99071",questId="quest_q99071",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-648.583,-18.483,1032.586),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_GUNSMITH},
  --[[108]]{questName="sovietBase_q99070",questId="quest_q99070",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-2127.887,436.594,-1564.366),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_GUNSMITH},
  --[[109]]{questName="tent_q99072",questId="quest_q99072",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1761.536,310.333,806.76),radius=5,category=this.QUEST_CATEGORIES_ENUM.EXTRACT_GUNSMITH},
  --[[110]]{questName="outland_q40010",questId="outland_q40010",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(222.904,20.496,-932.784),radius=5,category=this.QUEST_CATEGORIES_ENUM.STORY,},--this.QUEST_CATEGORIES_ENUM.EXTRACT_CONTAINERS,
  --[[111]]{questName="mtbs_q99011",questId="mtbs_q99011",locationId=TppDefine.LOCATION_ID.MTBS,clusterId=TppDefine.CLUSTER_DEFINE.Medical,plntId=TppDefine.PLNT_DEFINE.Special,isImportant=true,category=this.QUEST_CATEGORIES_ENUM.STORY},
  --[[112]]{questName="cliffTown_q99080",questId="cliffTown_q99080",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(530.911,335.119,29.67),radius=5,category=this.QUEST_CATEGORIES_ENUM.STORY},--this.QUEST_CATEGORIES_ENUM.INTEL_AGENT_EXTRACTION
  --[[113]]{questName="mtbs_q99050",questId="mtbs_q99050",locationId=TppDefine.LOCATION_ID.MTBS,clusterId=TppDefine.CLUSTER_DEFINE.Develop,plntId=TppDefine.PLNT_DEFINE.Common1,isImportant=true,category=this.QUEST_CATEGORIES_ENUM.STORY},--this.QUEST_CATEGORIES_ENUM.EXTRACT_CONTAINERS,
  --[[114]]{questName="quest_q52035",questId="quest_q52035",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(730.943,320.818,88.148),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[115]]{questName="quest_q52025",questId="quest_q52025",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-608.622,278.374,1694.876),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[116]]{questName="quest_q52015",questId="quest_q52015",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1836.664,358.543,-326.481),radius=6,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[117]]{questName="quest_q52075",questId="quest_q52075",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1349.26,11.259,285.945),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[118]]{questName="quest_q52065",questId="quest_q52065",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(811.036,-11.657,1193.033),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[119]]{questName="quest_q52045",questId="quest_q52045",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1722.589,152.294,-2079.907),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[120]]{questName="quest_q52055",questId="quest_q52055",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-350.247,-2.555,-190.417),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[121]]{questName="quest_q52095",questId="quest_q52095",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2429.92,61.019,189.081),radius=6,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[122]]{questName="quest_q52085",questId="quest_q52085",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1898.048,316.223,610.601),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[123]]{questName="quest_q52105",questId="quest_q52105",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(672.542,-3.727,108.875),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[124]]{questName="quest_q52135",questId="quest_q52135",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(1393.775,299.887,1910.528),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[125]]{questName="quest_q52115",questId="quest_q52115",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-775.086,-3.786,563.539),radius=6,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[126]]{questName="quest_q52125",questId="quest_q52125",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1156.773,-12.097,1524.507),radius=6,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[127]]{questName="quest_q52145",questId="quest_q52145",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1589.128,511.561,-2113.037),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_TANK_UNIT},
  --[[128]]{questName="tent_q71010",questId="quest_q71010",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1759.032,310.695,806.245),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[129]]{questName="savannah_q71300",questId="quest_q71300",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(803.255,-11.806,1225.636),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[130]]{questName="field_q71020",questId="quest_q71020",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(421.778,269.679,2207.088),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[131]]{questName="lab_q71600",questId="quest_q71600",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2522.474,100.128,-896.065),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[132]]{questName="tent_q71030",questId="quest_q71030",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-859.822,301.749,1954.213),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[133]]{questName="sovietBase_q71070",questId="quest_q71070",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-675.085,533.228,-1482.026),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[134]]{questName="cliffTown_q71050",questId="quest_q71050",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(527.023,328.63,50),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[135]]{questName="lab_q71700",questId="quest_q71700",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2746.635,200.042,-2401.35),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[136]]{questName="field_q71090",questId="quest_q71090",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(474.7,322.281,1062.864),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[137]]{questName="waterway_q71040",questId="quest_q71040",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1490.294,396.138,-792.581),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[138]]{questName="fort_q71080",questId="quest_q71080",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(2080.718,456.726,-1927.582),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[139]]{questName="cliffTown_q71060",questId="quest_q71060",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(782.651,463.722,-1027.08),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[140]]{questName="diamond_q71500",questId="quest_q71500",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(1518,145,-2115),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[141]]{questName="banana_q71400",questId="quest_q71400",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(278.127,42.996,-1232.378),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[142]]{questName="outland_q71200",questId="quest_q71200",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-594.489,-17.482,1095.318),radius=5,category=this.QUEST_CATEGORIES_ENUM.ELIMINATE_PUPPETS},
  --[[143]]{questName="sovietBase_q99030",questId="sovietBase_q99030",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-2199.997,456.352,-1581.944),radius=6,isImportant=true,category=this.QUEST_CATEGORIES_ENUM.STORY},
  --[[144]]{questName="tent_q99040",questId="tent_q99040",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1762.503,310.288,802.482),radius=5,isImportant=true,category=this.QUEST_CATEGORIES_ENUM.STORY},
  --[[145]]{questName="outland_q20913",questId="quest_q20913",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(-958.532,-14.1,-224.044),radius=5,isImportant=true,category=this.QUEST_CATEGORIES_ENUM.STORY},
  --[[146]]{questName="lab_q20914",questId="quest_q20914",locationId=TppDefine.LOCATION_ID.MAFR,iconPos=Vector3(2747.504,200.042,-2401.418),radius=5,isImportant=true,category=this.QUEST_CATEGORIES_ENUM.STORY},
  --[[147]]{questName="sovietBase_q20912",questId="quest_q20912",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1573.917,369.848,-321.113),radius=5,isImportant=true,category=this.QUEST_CATEGORIES_ENUM.STORY},
  --[[148]]{questName="tent_q20910",questId="quest_q20910",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-865.471,300.445,1949.157),radius=5,isImportant=true,category=this.QUEST_CATEGORIES_ENUM.STORY},
  --[[149]]{questName="fort_q20911",questId="quest_q20911",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(2181.73,470.912,-1815.881),radius=5,isImportant=true,category=this.QUEST_CATEGORIES_ENUM.STORY},
  --[[150]]{questName="waterway_q99012",questId="waterway_q99012",locationId=TppDefine.LOCATION_ID.AFGH,iconPos=Vector3(-1335.904,398.264,-739.165),radius=5,isImportant=true,category=this.QUEST_CATEGORIES_ENUM.STORY},
  --[[151]]{questName="mtbs_q42010",questId="mtbs_q42010",locationId=TppDefine.LOCATION_ID.MTBS,clusterId=TppDefine.CLUSTER_DEFINE.Command,plntId=TppDefine.PLNT_DEFINE.Special,category=this.QUEST_CATEGORIES_ENUM.TARGET_PRACTICE},
  --[[152]]{questName="mtbs_q42020",questId="mtbs_q42020",locationId=TppDefine.LOCATION_ID.MTBS,clusterId=TppDefine.CLUSTER_DEFINE.Develop,plntId=TppDefine.PLNT_DEFINE.Special,category=this.QUEST_CATEGORIES_ENUM.TARGET_PRACTICE},
  --[[153]]{questName="mtbs_q42030",questId="mtbs_q42030",locationId=TppDefine.LOCATION_ID.MTBS,clusterId=TppDefine.CLUSTER_DEFINE.Support,plntId=TppDefine.PLNT_DEFINE.Special,category=this.QUEST_CATEGORIES_ENUM.TARGET_PRACTICE},
  --[[154]]{questName="mtbs_q42040",questId="mtbs_q42040",locationId=TppDefine.LOCATION_ID.MTBS,clusterId=TppDefine.CLUSTER_DEFINE.BaseDev,plntId=TppDefine.PLNT_DEFINE.Special,category=this.QUEST_CATEGORIES_ENUM.TARGET_PRACTICE},
  --[[155]]{questName="mtbs_q42060",questId="mtbs_q42060",locationId=TppDefine.LOCATION_ID.MTBS,clusterId=TppDefine.CLUSTER_DEFINE.Spy,plntId=TppDefine.PLNT_DEFINE.Special,category=this.QUEST_CATEGORIES_ENUM.TARGET_PRACTICE},
  --[[156]]{questName="mtbs_q42050",questId="mtbs_q42050",locationId=TppDefine.LOCATION_ID.MTBS,clusterId=TppDefine.CLUSTER_DEFINE.Medical,plntId=TppDefine.PLNT_DEFINE.Special,category=this.QUEST_CATEGORIES_ENUM.TARGET_PRACTICE},
  --[[157]]{questName="mtbs_q42070",questId="mtbs_q42070",locationId=TppDefine.LOCATION_ID.MTBS,clusterId=TppDefine.CLUSTER_DEFINE.Combat,plntId=TppDefine.PLNT_DEFINE.Special,category=this.QUEST_CATEGORIES_ENUM.TARGET_PRACTICE},
}--questInfoTable

--TABLESETUP
--tex various lookup tables>
this.NUM_VANILLA_UI_QUESTS=157--tex indexed/user facing quests only for unmodified questInfoTable -^-

this.QUESTTABLE_INDEX={}
for index,questInfo in ipairs(questInfoTable) do
  this.QUESTTABLE_INDEX[questInfo.questName]=index
  this.QUESTTABLE_INDEX[index]=questInfo.questName--is its own enum
end
--tex DEBUGNOW UNUSED, if you want to use it then make sure it's rebuilt after addon quests are added
--even if you dont use it keep it as a ref because of this note -v-
--tex TppQuestList.questList is indexed in this order
--local areaLists={afgAreaList,mafrAreaList,mtbsAreaList}
--
--this.questAreaToQuestListIndex={}
--local index=0
--for i,areaList in ipairs(areaLists)do
--  for i,areaName in ipairs(areaList)do
--    index=index+1
--    this.questAreaToQuestListIndex[areaName]=index
--  end
--end

function this.GetQuestInfoTable()
  return questInfoTable
end
--<

local questRadioList={
  ruins_q19010={radioNameFirst="f1000_rtrg0700"},
  outland_q19011={radioNameFirst="f1000_rtrg4380"},
  hill_q19012={radioNameFirst="f1000_rtrg4390"},
  commFacility_q19013={radioNameFirst="f1000_rtrg4370"},
  tent_q20910={radioNameFirst="f2000_rtrg8320",radioNameSecond="f2000_rtrg1560"},
  fort_q20911={radioNameFirst="f2000_rtrg8320",radioNameSecond="f2000_rtrg1560"},
  sovietBase_q20912={radioNameFirst="f2000_rtrg8320",radioNameSecond="f2000_rtrg1560"},
  outland_q20913={radioNameFirst="f2000_rtrg8320",radioNameSecond="f2000_rtrg1560"},
  lab_q20914={radioNameFirst="f2000_rtrg8320",radioNameSecond="f2000_rtrg1560"},
  cliffTown_q99080={radioNameFirst="f2000_rtrg1561"}
}
this.questCompleteLangIds={--tex made module local
  tent_q10010="quest_extract_elite",
  field_q10020="quest_extract_elite",
  ruins_q10030="quest_extract_elite",
  waterway_q10040="quest_extract_elite",
  cliffTown_q10050="quest_extract_elite",
  commFacility_q10060="quest_extract_elite",
  sovietBase_q10070="quest_extract_elite",
  fort_q10080="quest_extract_elite",
  citadel_q10090="quest_extract_elite",
  outland_q10100="quest_extract_elite",
  pfCamp_q10200="quest_extract_elite",
  savannah_q10300="quest_extract_elite",
  hill_q10400="quest_extract_elite",
  banana_q10500="quest_extract_elite",
  diamond_q10600="quest_extract_elite",
  lab_q10700="quest_extract_elite",
  tent_q11010="quest_defeat_armor",
  tent_q11020="quest_defeat_armor",
  waterway_q11030="quest_defeat_armor",
  cliffTown_q11040="quest_defeat_armor",
  cliffTown_q11050="quest_defeat_armor",
  fort_q11060="quest_defeat_armor",
  fort_q11070="quest_defeat_armor",
  commFacility_q11080="quest_defeat_armor",
  outland_q11090="quest_defeat_armor",
  outland_q11100="quest_defeat_armor",
  pfCamp_q11200="quest_defeat_armor",
  savannah_q11300="quest_defeat_armor",
  savannah_q11400="quest_defeat_armor",
  hill_q11500="quest_defeat_armor",
  banana_q11600="quest_defeat_armor",
  banana_q11700="quest_defeat_armor",
  tent_q71010="quest_defeat_zombie",
  field_q71020="quest_defeat_zombie",
  tent_q71030="quest_defeat_zombie",
  waterway_q71040="quest_defeat_zombie",
  cliffTown_q71050="quest_defeat_zombie",
  cliffTown_q71060="quest_defeat_zombie",
  sovietBase_q71070="quest_defeat_zombie",
  fort_q71080="quest_defeat_zombie",
  field_q71090="quest_defeat_zombie",
  outland_q71200="quest_defeat_zombie",
  savannah_q71300="quest_defeat_zombie",
  banana_q71400="quest_defeat_zombie",
  diamond_q71500="quest_defeat_zombie",
  lab_q71600="quest_defeat_zombie",
  lab_q71700="quest_defeat_zombie",
  quest_q20015="quest_extract_hostage",
  quest_q20025="quest_extract_hostage",
  quest_q20035="quest_extract_hostage",
  quest_q20045="quest_extract_hostage",
  quest_q20055="quest_extract_hostage",
  quest_q20065="quest_extract_hostage",
  quest_q20075="quest_extract_hostage",
  quest_q20085="quest_extract_hostage",
  quest_q20095="quest_extract_hostage",
  quest_q20105="quest_extract_hostage",
  quest_q20205="quest_extract_hostage",
  quest_q20305="quest_extract_hostage",
  quest_q20405="quest_extract_hostage",
  quest_q20505="quest_extract_hostage",
  quest_q20605="quest_extract_hostage",
  quest_q20705="quest_extract_hostage",
  quest_q20805="quest_extract_hostage",
  quest_q20905="quest_extract_hostage",
  quest_q21005="quest_extract_hostage",
  quest_q22005="quest_extract_hostage",
  quest_q23005="quest_extract_hostage",
  quest_q24005="quest_extract_hostage",
  quest_q25005="quest_extract_hostage",
  quest_q26005="quest_extract_hostage",
  quest_q27005="quest_extract_hostage",
  quest_q52010="quest_defeat_armor_vehicle",
  quest_q52020="quest_defeat_armor_vehicle",
  quest_q52030="quest_defeat_armor_vehicle",
  quest_q52040="quest_defeat_armor_vehicle",
  quest_q52050="quest_defeat_armor_vehicle",
  quest_q52060="quest_defeat_armor_vehicle",
  quest_q52070="quest_defeat_armor_vehicle",
  quest_q52080="quest_defeat_armor_vehicle",
  quest_q52090="quest_defeat_armor_vehicle",
  quest_q52100="quest_defeat_armor_vehicle",
  quest_q52110="quest_defeat_armor_vehicle",
  quest_q52120="quest_defeat_armor_vehicle",
  quest_q52130="quest_defeat_armor_vehicle",
  quest_q52140="quest_defeat_armor_vehicle",
  quest_q52015="quest_defeat_tunk",
  quest_q52025="quest_defeat_tunk",
  quest_q52035="quest_defeat_tunk",
  quest_q52045="quest_defeat_tunk",
  quest_q52055="quest_defeat_tunk",
  quest_q52065="quest_defeat_tunk",
  quest_q52075="quest_defeat_tunk",
  quest_q52085="quest_defeat_tunk",
  quest_q52095="quest_defeat_tunk",
  quest_q52105="quest_defeat_tunk",
  quest_q52115="quest_defeat_tunk",
  quest_q52125="quest_defeat_tunk",
  quest_q52135="quest_defeat_tunk",
  quest_q52145="quest_defeat_tunk",
  mtbs_q42020="quest_target_eliminate",
  mtbs_q42030="quest_target_eliminate",
  mtbs_q42040="quest_target_eliminate",
  mtbs_q42050="quest_target_eliminate",
  mtbs_q42060="quest_target_eliminate",
  mtbs_q42070="quest_target_eliminate",
  mtbs_q42010="quest_target_eliminate"
}--questCompleteLangIds
local keyItems={
  tent_q80010=TppMotherBaseManagementConst.PHOTO_1006,
  field_q80020=TppMotherBaseManagementConst.PHOTO_1007,
  waterway_q80040=TppMotherBaseManagementConst.PHOTO_1009,
  commFacility_q80060=TppMotherBaseManagementConst.PHOTO_1000,
  fort_q80080=TppMotherBaseManagementConst.PHOTO_1008,
  outland_q80100=TppMotherBaseManagementConst.PHOTO_1002,
  pfCamp_q80200=TppMotherBaseManagementConst.PHOTO_1003,
  hill_q80400=TppMotherBaseManagementConst.PHOTO_1005,
  diamond_q80600=TppMotherBaseManagementConst.PHOTO_1004,
  lab_q80700=TppMotherBaseManagementConst.PHOTO_1001,
  sovietBase_q99030=TppMotherBaseManagementConst.DESIGN_3009,
  tent_q99040=TppMotherBaseManagementConst.DESIGN_3002,
  mtbs_q99050=TppMotherBaseManagementConst.DESIGN_3000
}
local questPhotos={
  tent_q80010="key_photo_1006",
  field_q80020="key_photo_1007",
  waterway_q80040="key_photo_1009",
  commFacility_q80060="key_photo_1000",
  fort_q80080="key_photo_1008",
  outland_q80100="key_photo_1002",
  pfCamp_q80200="key_photo_1003",
  hill_q80400="key_photo_1005",
  diamond_q80600="key_photo_1004",
  lab_q80700="key_photo_1001"
}
local questEmblems={
  mtbs_q99060={"base44","front62"},
  sovietBase_q99020={"word14","word15","word51","front49"},
  sovietBase_q99030={"word122","word123","word124","word125","word126"},
  tent_q99040={"word78","word79","word87","word91"}
}
local setLockedTanQuests={"quest_q20015","quest_q20085","quest_q20205","quest_q20705","quest_q20095"}
local canOpenQuestChecks={}
function canOpenQuestChecks.waterway_q99010()
  return TppStory.IsOccuringBossQuiet()
end
function canOpenQuestChecks.waterway_q99012()
  return TppBuddyService.CheckBuddyCommonFlag(BuddyCommonFlag.BUDDY_QUIET_LOST)
end
function canOpenQuestChecks.sovietBase_q99020()
  return TppStory.GetCurrentStorySequence()>=TppDefine.STORY_SEQUENCE.CLEARD_FLAG_MISSIONS_AFTER_FIND_THE_SECRET_WEAPON
end
function canOpenQuestChecks.sovietBase_q99030()
  return TppStory.CanPlayDemoOrRadio"OpenSideOpsAiPod"
end
function canOpenQuestChecks.tent_q99040()
  return this.IsCleard"sovietBase_q99030"
end
function canOpenQuestChecks.cliffTown_q99080()
  return TppStory.IsMissionCleard(10091)
end
function canOpenQuestChecks.field_q30010()
  return this.IsCleard"ruins_q60115"
end
function this.OpenChildSoldier_1()
  local t=this.IsCleard"mtbs_q99050"
  local n=this.IsNowOccurringElapsed()
  local e=TppStory.IsNowOccurringElapsedMission(TppDefine.ELAPSED_MISSION_EVENT.STORY_SEQUENCE)
  local a=TppStory.IsMissionCleard(10093)
  return((e or n)and t)and a
end
function this.OpenChildSoldier_2()
  return this.IsCleard"outland_q20913"and this.IsCleard"lab_q20914"
end
function canOpenQuestChecks.outland_q20913()
  return this.OpenChildSoldier_1()
end
function canOpenQuestChecks.lab_q20914()
  return this.OpenChildSoldier_1()
end
function canOpenQuestChecks.tent_q20910()
  return this.OpenChildSoldier_2()
end
function canOpenQuestChecks.fort_q20911()
  return this.OpenChildSoldier_2()
end
function canOpenQuestChecks.sovietBase_q20912()
  return this.OpenChildSoldier_2()
end
function canOpenQuestChecks.waterway_q39010()
  return TppStory.IsMissionCleard(10054)
end
function canOpenQuestChecks.lab_q39011()
  return TppStory.IsMissionCleard(10151)
end
function canOpenQuestChecks.pfCamp_q39012()
  return TppStory.IsMissionCleard(10151)
end
function canOpenQuestChecks.ruins_q19010()
  return true
end
function canOpenQuestChecks.commFacility_q19013()
  return this.IsCleard"quest_q20065"
end
function canOpenQuestChecks.outland_q19011()
  return TppStory.IsMissionCleard(10086)
end
function canOpenQuestChecks.hill_q19012()
  return TppStory.IsMissionCleard(10100)
end
function canOpenQuestChecks.outland_q99071()
  return TppStory.IsMissionCleard(10080)
end
function canOpenQuestChecks.sovietBase_q99070()
  return this.IsCleard"outland_q99071"
end
function canOpenQuestChecks.tent_q99072()
  return this.IsCleard"sovietBase_q99070"
end
function canOpenQuestChecks.outland_q40010()
  return TppStory.IsMissionCleard(10080)
end
function canOpenQuestChecks.sovietBase_q60110()
  return TppStory.IsOccuringBossQuiet()
end
function canOpenQuestChecks.sovietBase_q60111()
  return TppStory.IsMissionCleard(10121)
end
function canOpenQuestChecks.citadel_q60112()
  return TppStory.IsMissionCleard(10121)
end
function canOpenQuestChecks.outland_q60113()
  return TppStory.IsMissionCleard(10121)
end
function canOpenQuestChecks.pfCamp_q60114()
  return TppStory.IsMissionCleard(10121)
end
function canOpenQuestChecks.ruins_q60115()
  return this.IsCleard"ruins_q19010"
end
function canOpenQuestChecks.tent_q10010()
  return true
end
function canOpenQuestChecks.field_q10020()
  local t=this.IsCleard"ruins_q60115"
  local e=this.IsCleard"tent_q10010"
  return t and e
end
function canOpenQuestChecks.ruins_q10030()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"commFacility_q10060"
  return t and e
end
function canOpenQuestChecks.waterway_q10040()
  local t=TppStory.IsMissionCleard(10044)
  local e=this.IsCleard"cliffTown_q10050"
  return t and e
end
function canOpenQuestChecks.cliffTown_q10050()
  local t=TppStory.IsMissionCleard(10041)
  local e=this.IsCleard"fort_q10080"
  return t and e
end
function canOpenQuestChecks.commFacility_q10060()
  local t=TppStory.IsMissionCleard(10080)
  local e=this.IsCleard"waterway_q10040"
  return t and e
end
function canOpenQuestChecks.sovietBase_q10070()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"ruins_q10030"
  return t and e
end
function canOpenQuestChecks.fort_q10080()
  local t=TppStory.IsMissionCleard(10040)
  local e=this.IsCleard"field_q10020"
  return t and e
end
function canOpenQuestChecks.citadel_q10090()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"sovietBase_q10070"
  return t and e
end
function canOpenQuestChecks.outland_q10100()
  local t=TppStory.IsMissionCleard(10090)
  local e=this.IsCleard"pfCamp_q10200"
  return t and e
end
function canOpenQuestChecks.pfCamp_q10200()
  return TppStory.IsMissionCleard(10086)
end
function canOpenQuestChecks.savannah_q10300()
  local t=TppStory.IsMissionCleard(10195)
  local e=this.IsCleard"outland_q10100"
  return t and e
end
function canOpenQuestChecks.hill_q10400()
  local t=TppStory.IsMissionCleard(10110)
  local e=this.IsCleard"banana_q10500"
  return t and e
end
function canOpenQuestChecks.banana_q10500()
  local t=TppStory.IsMissionCleard(10100)
  local e=this.IsCleard"savannah_q10300"
  return t and e
end
function canOpenQuestChecks.diamond_q10600()
  local t=TppStory.IsMissionCleard(10120)
  local e=this.IsCleard"hill_q10400"
  return t and e
end
function canOpenQuestChecks.lab_q10700()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"diamond_q10600"
  return t and e
end
function canOpenQuestChecks.quest_q20015()
  return TppStory.IsMissionCleard(10040)
end
function canOpenQuestChecks.quest_q20025()
  return this.IsCleard"quest_q20065"
end
function canOpenQuestChecks.quest_q20035()
  local t=TppStory.IsMissionCleard(10080)
  local e=this.IsCleard"quest_q20905"
  return t and e
end
function canOpenQuestChecks.quest_q20045()
  local t=TppStory.IsMissionCleard(10091)
  local e=this.IsCleard"quest_q20035"
  return t and e
end
function canOpenQuestChecks.quest_q20055()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"quest_q21005"
  return t and e
end
function canOpenQuestChecks.quest_q20065()
  return this.IsCleard"ruins_q60115"
end
function canOpenQuestChecks.quest_q20075()
  local t=TppStory.IsMissionCleard(10044)
  local e=this.IsCleard"quest_q20025"
  return t and e
end
function canOpenQuestChecks.quest_q20085()
  local t=TppStory.IsMissionCleard(10041)
  local e=this.IsCleard"quest_q20015"
  return t and e
end
function canOpenQuestChecks.quest_q20095()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"quest_q20705"
  return t and e
end
function canOpenQuestChecks.quest_q20105()
  local t=TppStory.IsMissionCleard(10100)
  local e=this.IsCleard"quest_q23005"
  return t and e
end
function canOpenQuestChecks.quest_q20205()
  local t=TppStory.IsMissionCleard(10195)
  local e=this.IsCleard"quest_q20085"
  return t and e
end
function canOpenQuestChecks.quest_q20305()
  return TppStory.IsMissionCleard(10080)
end
function canOpenQuestChecks.quest_q20405()
  local t=TppStory.IsMissionCleard(10093)
  local e=this.IsCleard"quest_q27005"
  return t and e
end
function canOpenQuestChecks.quest_q20505()
  local t=TppStory.IsMissionCleard(10110)
  local e=this.IsCleard"quest_q24005"
  return t and e
end
function canOpenQuestChecks.quest_q20605()
  local t=TppStory.IsMissionCleard(10121)
  local e=this.IsCleard"quest_q20505"
  return t and e
end
function canOpenQuestChecks.quest_q20705()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"quest_q20205"
  return t and e
end
function canOpenQuestChecks.quest_q20805()
  local t=TppStory.IsMissionCleard(10054)
  local e=this.IsCleard"quest_q20075"
  return t and e
end
function canOpenQuestChecks.quest_q20905()
  local t=TppStory.IsMissionCleard(10052)
  local e=this.IsCleard"quest_q20805"
  return t and e
end
function canOpenQuestChecks.quest_q21005()
  local t=TppStory.IsMissionCleard(10091)
  local e=this.IsCleard"quest_q20045"
  return t and e
end
function canOpenQuestChecks.quest_q22005()
  local t=TppStory.IsMissionCleard(10045)
  local e=this.IsCleard"quest_q21005"
  return t and e
end
function canOpenQuestChecks.quest_q23005()
  local t=TppStory.IsMissionCleard(10090)
  local e=this.IsCleard"quest_q20305"
  return t and e
end
function canOpenQuestChecks.quest_q24005()
  local t=TppStory.IsMissionCleard(10110)
  local e=this.IsCleard"quest_q20105"
  return t and e
end
function canOpenQuestChecks.quest_q25005()
  local t=TppStory.IsMissionCleard(10120)
  local e=this.IsCleard"quest_q20605"
  return t and e
end
function canOpenQuestChecks.quest_q26005()
  local t=TppStory.IsMissionCleard(10211)
  local e=this.IsCleard"quest_q27005"
  return t and e
end
function canOpenQuestChecks.quest_q27005()
  local t=TppStory.IsMissionCleard(10211)
  local e=this.IsCleard"quest_q25005"
  return t and e
end
function canOpenQuestChecks.tent_q11010()
  return TppStory.IsMissionCleard(10041)
end
function canOpenQuestChecks.tent_q11020()
  local t=TppStory.IsMissionCleard(10054)
  local e=this.IsCleard"tent_q11010"
  return t and e
end
function canOpenQuestChecks.waterway_q11030()
  local t=TppStory.IsMissionCleard(10052)
  local e=this.IsCleard"tent_q11020"
  return t and e
end
function canOpenQuestChecks.cliffTown_q11040()
  local t=TppStory.IsMissionCleard(10080)
  local e=this.IsCleard"waterway_q11030"
  return t and e
end
function canOpenQuestChecks.cliffTown_q11050()
  local t=TppStory.IsMissionCleard(10121)
  local e=this.IsCleard"banana_q11600"
  return t and e
end
function canOpenQuestChecks.fort_q11060()
  local t=TppStory.IsMissionCleard(10091)
  local e=this.IsCleard"commFacility_q11080"
  return t and e
end
function canOpenQuestChecks.fort_q11070()
  local t=TppStory.IsMissionCleard(10156)
  local e=this.IsCleard"fort_q11060"
  return t and e
end
function canOpenQuestChecks.commFacility_q11080()
  local t=TppStory.IsMissionCleard(10080)
  local e=this.IsCleard"cliffTown_q11040"
  return t and e
end
function canOpenQuestChecks.outland_q11090()
  local t=TppStory.IsMissionCleard(10195)
  local e=this.IsCleard"pfCamp_q11200"
  return t and e
end
function canOpenQuestChecks.outland_q11100()
  local t=TppStory.IsMissionCleard(10171)
  local e=this.IsCleard"banana_q11700"
  return t and e
end
function canOpenQuestChecks.pfCamp_q11200()
  local t=TppStory.IsMissionCleard(10100)
  local e=this.IsCleard"savannah_q11400"
  return t and e
end
function canOpenQuestChecks.savannah_q11300()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"hill_q11500"
  return t and e
end
function canOpenQuestChecks.savannah_q11400()
  return TppStory.IsMissionCleard(10086)
end
function canOpenQuestChecks.hill_q11500()
  local t=TppStory.IsMissionCleard(10120)
  local e=this.IsCleard"cliffTown_q11050"
  return t and e
end
function canOpenQuestChecks.banana_q11600()
  local t=TppStory.IsMissionCleard(10110)
  local e=this.IsCleard"outland_q11090"
  return t and e
end
function canOpenQuestChecks.banana_q11700()
  local t=TppStory.IsMissionCleard(10093)
  local e=this.IsCleard"savannah_q11300"
  return t and e
end
function canOpenQuestChecks.tent_q71010()
  return TppStory.IsMissionCleard(10045)
end
function canOpenQuestChecks.field_q71020()
  local t=TppStory.IsMissionCleard(10156)
  local e=this.IsCleard"tent_q71010"
  return t and e
end
function canOpenQuestChecks.tent_q71030()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"field_q71020"
  return t and e
end
function canOpenQuestChecks.waterway_q71040()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"sovietBase_q71070"
  return t and e
end
function canOpenQuestChecks.cliffTown_q71050()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"tent_q71030"
  return t and e
end
function canOpenQuestChecks.cliffTown_q71060()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"sovietBase_q71070"
  return t and e
end
function canOpenQuestChecks.sovietBase_q71070()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"tent_q71030"
  return t and e
end
function canOpenQuestChecks.fort_q71080()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"sovietBase_q71070"
  return t and e
end
function canOpenQuestChecks.field_q71090()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"sovietBase_q71070"
  return t and e
end
function canOpenQuestChecks.outland_q71200()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"lab_q71600"
  return t and e
end
function canOpenQuestChecks.savannah_q71300()
  return TppStory.IsMissionCleard(10093)
end
function canOpenQuestChecks.banana_q71400()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"lab_q71600"
  return t and e
end
function canOpenQuestChecks.diamond_q71500()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"lab_q71600"
  return t and e
end
function canOpenQuestChecks.lab_q71600()
  local t=TppStory.IsMissionCleard(10171)
  local e=this.IsCleard"savannah_q71300"
  return t and e
end
function canOpenQuestChecks.lab_q71700()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"lab_q71600"
  return t and e
end
function canOpenQuestChecks.commFacility_q80060()
  return TppStory.IsMissionCleard(10040)
end
function canOpenQuestChecks.field_q80020()
  local t=TppStory.IsMissionCleard(10044)
  local e=this.IsCleard"commFacility_q80060"
  return t and e
end
function canOpenQuestChecks.outland_q80100()
  local t=TppStory.IsMissionCleard(10090)
  local e=this.IsCleard"field_q80020"
  return t and e
end
function canOpenQuestChecks.pfCamp_q80200()
  local t=TppStory.IsMissionCleard(10110)
  local e=this.IsCleard"outland_q80100"
  return t and e
end
function canOpenQuestChecks.diamond_q80600()
  local t=TppStory.IsMissionCleard(10120)
  local e=this.IsCleard"pfCamp_q80200"
  return t and e
end
function canOpenQuestChecks.hill_q80400()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"diamond_q80600"
  return t and e
end
function canOpenQuestChecks.tent_q80010()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"hill_q80400"
  return t and e
end
function canOpenQuestChecks.lab_q80700()
  local t=TppStory.IsMissionCleard(10093)
  local e=this.IsCleard"tent_q80010"
  if t==true and e==true then
    return true
  end
  return false
end
function canOpenQuestChecks.fort_q80080()
  local t=TppStory.IsMissionCleard(10156)
  local e=this.IsCleard"lab_q80700"
  return t and e
end
function canOpenQuestChecks.waterway_q80040()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"fort_q80080"
  return t and e
end
function canOpenQuestChecks.quest_q52010()
  local t=TppStory.IsMissionCleard(10054)
  local e=this.IsCleard"quest_q52030"
  return t and e
end
function canOpenQuestChecks.quest_q52020()
  return TppStory.IsMissionCleard(10086)
end
function canOpenQuestChecks.quest_q52030()
  return TppStory.IsMissionCleard(10044)
end
function canOpenQuestChecks.quest_q52040()
  local t=TppStory.IsMissionCleard(10052)
  local e=this.IsCleard"quest_q52010"
  return t and e
end
function canOpenQuestChecks.quest_q52050()
  local t=TppStory.IsMissionCleard(10100)
  local e=this.IsCleard"quest_q52020"
  return t and e
end
function canOpenQuestChecks.quest_q52060()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"quest_q52070"
  return t and e
end
function canOpenQuestChecks.quest_q52070()
  local t=TppStory.IsMissionCleard(10120)
  local e=this.IsCleard"quest_q52050"
  return t and e
end
function canOpenQuestChecks.quest_q52080()
  local t=this.IsCleard"tent_q99040"
  local e=this.IsCleard"quest_q52040"
  return t and e
end
function canOpenQuestChecks.quest_q52090()
  local t=TppStory.IsMissionCleard(10093)
  local e=this.IsCleard"quest_q52060"
  return t and e
end
function canOpenQuestChecks.quest_q52100()
  local t=TppStory.IsMissionCleard(10171)
  local e=this.IsCleard"quest_q52090"
  return t and e
end
function canOpenQuestChecks.quest_q52110()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"quest_q52100"
  return t and e
end
function canOpenQuestChecks.quest_q52120()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"quest_q52110"
  return t and e
end
function canOpenQuestChecks.quest_q52130()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"quest_q52080"
  return t and e
end
function canOpenQuestChecks.quest_q52140()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"quest_q52130"
  return t and e
end
function canOpenQuestChecks.quest_q52015()
  local t=TppStory.IsMissionCleard(10080)
  local e=this.IsCleard"quest_q52025"
  return t and e
end
function canOpenQuestChecks.quest_q52025()
  local t=TppStory.IsMissionCleard(10052)
  local e=this.IsCleard"quest_q52035"
  return t and e
end
function canOpenQuestChecks.quest_q52035()
  return TppStory.IsMissionCleard(10054)
end
function canOpenQuestChecks.quest_q52045()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"quest_q52065"
  return t and e
end
function canOpenQuestChecks.quest_q52055()
  local t=TppStory.IsMissionCleard(10093)
  local e=this.IsCleard"quest_q52045"
  return t and e
end
function canOpenQuestChecks.quest_q52065()
  local t=TppStory.IsMissionCleard(10211)
  local e=this.IsCleard"quest_q52075"
  return t and e
end
function canOpenQuestChecks.quest_q52075()
  return TppStory.IsMissionCleard(10090)
end
function canOpenQuestChecks.quest_q52085()
  local t=TppStory.IsMissionCleard(10151)
  local e=this.IsCleard"quest_q52015"
  return t and e
end
function canOpenQuestChecks.quest_q52095()
  local t=TppStory.IsMissionCleard(10093)
  local e=this.IsCleard"quest_q52055"
  return t and e
end
function canOpenQuestChecks.quest_q52105()
  local t=TppStory.IsMissionCleard(10171)
  local e=this.IsCleard"quest_q52095"
  return t and e
end
function canOpenQuestChecks.quest_q52115()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"quest_q52105"
  return t and e
end
function canOpenQuestChecks.quest_q52125()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"quest_q52115"
  return t and e
end
function canOpenQuestChecks.quest_q52135()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"quest_q52085"
  return t and e
end
function canOpenQuestChecks.quest_q52145()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"quest_q52135"
  return t and e
end
function canOpenQuestChecks.ruins_q60010()
  return TppStory.IsMissionCleard(10054)
end
function canOpenQuestChecks.tent_q60011()
  local t=TppStory.IsMissionCleard(10052)
  local e=this.IsCleard"ruins_q60010"
  return t and e
end
function canOpenQuestChecks.cliffTown_q60012()
  local t=this.IsCleard"tent_q99040"
  local e=this.IsCleard"fort_q60013"
  return t and e
end
function canOpenQuestChecks.fort_q60013()
  local t=TppStory.IsMissionCleard(10091)
  local e=this.IsCleard"tent_q60011"
  return t and e
end
function canOpenQuestChecks.sovietBase_q60014()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"cliffTown_q60012"
  return t and e
end
function canOpenQuestChecks.pfCamp_q60020()
  local t=TppStory.IsMissionCleard(10211)
  local e=this.IsCleard"hill_q60021"
  return t and e
end
function canOpenQuestChecks.hill_q60021()
  local t=TppStory.IsMissionCleard(10121)
  local e=this.IsCleard"outland_q60024"
  return t and e
end
function canOpenQuestChecks.lab_q60022()
  local t=TppStory.IsMissionCleard(10280)
  local e=this.IsCleard"banana_q60023"
  return t and e
end
function canOpenQuestChecks.banana_q60023()
  local t=TppStory.IsMissionCleard(10093)
  local e=this.IsCleard"pfCamp_q60020"
  return t and e
end
function canOpenQuestChecks.outland_q60024()
  return TppStory.IsMissionCleard(10086)
end
function canOpenQuestChecks.Mtbs_SmokingSoldierCommand()
  return true
end
function canOpenQuestChecks.Mtbs_SmokingSoldierCombat()
  return true
end
function canOpenQuestChecks.Mtbs_child_dog()
  if TppDemo.IsPlayedMBEventDemo"EntrustDdog"then
    return true
  end
end
function canOpenQuestChecks.Mtbs_ddog_walking()
  return false
end
function canOpenQuestChecks.mtbs_q99050()
  local e=TppLocation.GetLocalMbStageClusterGrade(TppDefine.CLUSTER_DEFINE.Develop+1)>=2
  local t=TppStory.IsMissionCleard"10211"
  return t and e
end
function canOpenQuestChecks.mtbs_q99011()
  local n=TppBuddy2BlockController.DidObtainBuddyType(BuddyType.QUIET)
  local t=TppStory.IsMissionCleard(10086)
  local e=TppStory.IsNowOccurringElapsedMission(TppDefine.ELAPSED_MISSION_EVENT.QUIET_VISIT_MISSION)
  return(n and t)and e
end
function canOpenQuestChecks.mtbs_wait_quiet()
  return false
end
function canOpenQuestChecks.mtbs_return_quiet()
  return false
end
function canOpenQuestChecks.mtbs_q101210()
  return true
end
function canOpenQuestChecks.mtbs_q101220()
  return true
end
function canOpenQuestChecks.mtbs_q99060()
  return TppDemo.IsPlayedMBEventDemo"PazPhantomPain1"
end
function canOpenQuestChecks.mtbs_q42010()
  return TppLocation.GetLocalMbStageClusterGrade(TppDefine.CLUSTER_DEFINE.Command+1)>=4
end
function canOpenQuestChecks.mtbs_q42020()
  return TppLocation.GetLocalMbStageClusterGrade(TppDefine.CLUSTER_DEFINE.Develop+1)>0
end
function canOpenQuestChecks.mtbs_q42030()
  return TppLocation.GetLocalMbStageClusterGrade(TppDefine.CLUSTER_DEFINE.Support+1)>0
end
function canOpenQuestChecks.mtbs_q42040()
  return TppLocation.GetLocalMbStageClusterGrade(TppDefine.CLUSTER_DEFINE.BaseDev+1)>0
end
function canOpenQuestChecks.mtbs_q42050()
  return TppLocation.GetLocalMbStageClusterGrade(TppDefine.CLUSTER_DEFINE.Medical+1)>0
end
function canOpenQuestChecks.mtbs_q42060()
  return TppLocation.GetLocalMbStageClusterGrade(TppDefine.CLUSTER_DEFINE.Spy+1)>0
end
function canOpenQuestChecks.mtbs_q42070()
  return TppLocation.GetLocalMbStageClusterGrade(TppDefine.CLUSTER_DEFINE.Combat+1)>0
end

this.ShootingPracticeOpenCondition={
  Command=canOpenQuestChecks.mtbs_q42010,
  Develop=canOpenQuestChecks.mtbs_q42020,
  Support=canOpenQuestChecks.mtbs_q42030,
  BaseDev=canOpenQuestChecks.mtbs_q42040,
  Medical=canOpenQuestChecks.mtbs_q42050,
  Spy=canOpenQuestChecks.mtbs_q42060,
  Combat=canOpenQuestChecks.mtbs_q42070
}

function this.GetCanOpenQuestTable()--tex expose for InfQuest> 
  return canOpenQuestChecks
end--<

--tex REWORKED
--tex NMC called via exe, see TppUiCommand.RegisterSideOpsListFunction. Actual quest selection in UpdateActiveQuest
--tex The vanilla behavior just show current Active and Cleared, which lets you see past progression/completion,
--though since uncleared quests do have priority, one will be selected for Active
--so if there's multiple uncleared for an area they will not be shown, 
--which gives you less of an idea of future progression
--the rework lets you have individual settings for many more quest conditions
--see uiShow flags -v-
function this.GetSideOpsListTable()
  return InfCore.PCallDebug(function()--tex wrap in pcall to protect debug addons CanActiveQuest (via GetAllIsActivable > SelectActivableQuests)
  InfCore.LogFlow("TppQuest.GetSideOpsListTable")--tex
  local sideOpsListTable={}
  if this.CanOpenSideOpsList()then
    local clearedNotActive={}--tex
    local showSettings=InfQuestIvars.GetUiShowSettings()--tex>
    for i,questInfo in ipairs(questInfoTable)do--tex NMC MODULE LOCAL. Does not include hidden quests
      local questName=questInfo.questName
      --tex uiShow flags
      questInfo.Active=this.IsActiveOnMBTerminal(questInfo)--tex also checks IsActive
      questInfo.Cleared=this.IsCleard(questName)
      questInfo.Uncleared=not this.IsCleard(questName)
      questInfo.Open=this.IsOpen(questName)
      --tex some more conditions, currently only used to eval Activable
      questInfo.Blocked=InfQuest.BlockQuest(questName)--tex IH reasons to block quest, including catergory selection menu / InfQuestIvars quest_category_ 
      questInfo.CanActiveQuest=this.CanActiveQuest(questName)
      questInfo.Repop=this.IsRepop(questName)
      --tex SYNC: SelectActivableQuests < UpdateActiveQuest
      --tex DEBUGNOW Activable in all other uses includes Active, but excluding there to make sort clearer 
      questInfo.Activable=questInfo.Open and questInfo.CanActiveQuest and (not questInfo.Blocked) and ((not questInfo.Cleared) or questInfo.Repop) and not questInfo.Active
      
      questInfo.Addon=InfQuest.ihQuestsInfo[questName]~=nil--tex UNUSED
      
      questInfo.questArea=TppQuestList.questAreaNameTable[questInfo.questName]--tex DEBUGNOW this should be done at load
      local areaQuestTable,questListInfo=this.GetQuestTable(questInfo.questName)--TppQuestList.questList
      --tex for sort, just sorting by x (in this case loadArea block minX) would an ok tour through the areas (if the map wasnt rotated),
      --though not so much with areas with equal x, so would also have to compare by y
      --but my KLUDGE is using xCenter instead since for vanilla at least width of areas differ for same minX, 
      --may run into trouble for addon missions if they have uniform areas 
      --TODO: another approach might to be to get the center of all the quests in the area (but would have to do as a post step after sideoplist done fill, before sort)
      --just be: find mins maxs of all questInfo iconpos, then center (but again mtbs doesnt have)
      
      if areaQuestTable.loadArea then
        questInfo.questAreaX=areaQuestTable.loadArea[1]+((areaQuestTable.loadArea[3]-areaQuestTable.loadArea[1])*0.5)
      else      
      --texfallback to areaName for missing loadArea (mtbs areas which use cluster)
        questInfo.questAreaX=questInfo.questArea
      end
      --OFF pure minX,minY
      --questInfo.questAreaX=areaQuestTable.loadArea and areaQuestTable.loadArea[1] or questInfo.questArea
      --questInfo.questAreaY=areaQuestTable.loadArea and areaQuestTable.loadArea[3] or questInfo.questArea
    
      local showQuest=false
      for flagName,showSetting in pairs(showSettings)do
        if showSetting and questInfo[flagName] then
          showQuest=true
          break
        end
      end--for showSettings
      --tex DEBUGNOW think IsOpen through, at the moment it's guard non open un cleared, all the rest of the flags already required to be open to have gotten themselves set (cleared, active etc).
      if questInfo and questInfo.Open and showQuest then--tex REWORKED was (isActiveOnMBTerminal or isCleard)
        questInfo.index=i--tex NMC: the number on the ui for the quest entry, the order of the entries is the order of sideOpsListTable (ie the order you're adding them to the table here -v-)
        questInfo.isActive=questInfo.Active--tex NMC controls hilighted on ui
        questInfo.isCleard=questInfo.Cleared--tex NMC controls checkmark
        questInfo.gmp=this.GetBounusGMP(questName)
        --tex NMC Note that its using the actual questInfoTable entries, so ui uses the other values
        table.insert(sideOpsListTable,questInfo)
        --tex TODO: target not activable first, then fall back to this if you run out?
        if questInfo.Cleared and not questInfo.Active then --tex>
          table.insert(clearedNotActive,questInfo)
        end--<
      end
      if this.debugModule then--tex>
        InfCore.PrintInspect(questInfo,questName.." questInfo showQuest:"..tostring(showQuest))
      end--<
    end--for questInfoTable

    this.ManageUiLimit(sideOpsListTable,clearedNotActive)--tex
    
    this.SortSideopsList(sideOpsListTable)--tex
    --<
  end--if CanOpenSideOpsList

  --NMC wut.
  --they can't just # off the table they're getting?
  --this would suggest they'd iterate the whole table looking for an element with allSideOpsNum just to get the table size
  --but by that point they could have counted it anyway...
  --or they could just get the last entry right?
  --but then they'd have to already know the table size...
  table.insert(sideOpsListTable,{allSideOpsNum=#questInfoTable})
  if this.debugModule then--tex>
    InfCore.PrintInspect(sideOpsListTable,"TppQuest.GetSideOpsListTable")--tex DEBUG  
    InfQuest.DEBUGTweakSideopsList(sideOpsListTable)--tex experiment with the table DEBUGNOW
  end--<
  
  return sideOpsListTable
  end)--tex PCallDebug
end--GetSideOpsListTable
--ORIG
--function this.GetSideOpsListTable()
--  local sideOpsListTable={}
--  if this.CanOpenSideOpsList()then
--    for i,questInfo in ipairs(questInfoTable)do--tex NMC MODULE LOCAL
--      local questName=questInfo.questName
--      local isActive=this.IsActiveOnMBTerminal(questInfo)
--      local isCleard=this.IsCleard(questName)
--      if questInfo and(isActive or isCleard)then
--        questInfo.index=i
--        questInfo.isActive=isActive
--        questInfo.isCleard=isCleard
--        questInfo.gmp=this.GetBounusGMP(questName)
--        table.insert(sideOpsListTable,questInfo)
--      end--if <conditions for adding>
--    end--for questInfoTable
--  end--if CanOpenSideOpsList
--  table.insert(sideOpsListTable,{allSideOpsNum=#questInfoTable})
--  return sideOpsListTable
--end--GetSideOpsListTable
--OUT: sideOpsListTable  
this.MAX_UI_QUESTS=192--tex LIMIT I verified this limit again in 2023. NOTE: theres 157 ui quests (this questInfoTable).
function this.ManageUiLimit(sideOpsListTable,clearedNotActive)
  local overCount=#sideOpsListTable-this.MAX_UI_QUESTS
  if overCount>0 then
    --tex TODO: some meaninful way of notifying user, indicating that it's not a big deal (unless there ever comes a time when theres more than 192 quest areas installed at one time lol)
    --and to point them towards the UI show options, or the category options.
    InfCore.Log("WARNING: #sidopList > maxUiQuests",false,true)--tex TODO lang
    InfCore.Log("overCount:"..overCount)--tex DEBUG      

    --tex since its just ui dont need to set random seed
    for i=1,overCount do
      if #clearedNotActive>0 then
        local randomIndex=math.random(#clearedNotActive)
        local removeEntry=clearedNotActive[randomIndex]
        table.remove(clearedNotActive,randomIndex)
        for j,sideopEntry in ipairs(sideOpsListTable)do
          if sideopEntry==removeEntry then
            table.remove(sideOpsListTable,j)
            InfCore.Log("removing "..sideopEntry.index)--tex DEBUG
            break
          end
        end--for sideOpsListTable
      end--if #clearedNotActive
    end--for overCount
  end--if overCount
  if #sideOpsListTable>this.MAX_UI_QUESTS then
    InfCore.Log("WARNING: #sidopList > maxUiQuests",false,true)--tex TODO lang
  end
  InfCore.Log("#sideOpsListTable:"..#sideOpsListTable)--tex DEBUG
end--ManageUiLimit

--tex sorts various flags of sideopsList questInfos depending on IH showOnUiMenu/ (InfQuestIvars) settings>
--OUT:sideOpsListTable
function this.SortSideopsList(sideOpsListTable)

--REF usual pattern for multi condition sorting:
--bool CompareData(a, b)
--   if (a.PrimaryCondition < b.PrimaryCondition) return true--true is sort a before b
--   if (b.PrimaryCondition < a.PrimaryCondition) return false
--   // a=b for primary condition, go to secondary
--
--   if (a.SecondaryCondition < b.SecondaryCondition) return true
--   if (b.SecondaryCondition < a.SecondaryCondition) return false
--
--   // ...
--
--   return false
 
--tex SortByFlags instead puts the list of condition/flag names that we actually want to sort in a list and iterates that
--so each flag will fall through to the next if equal
--it also handles ascending or descending order, which for boolean values just means put on top or bottom of any false/non sorted flags
--or for number/alpha flags actually ascending or descending order (assuming the flags are on every entry)


--the default/initial (ie no) sort is just by the internal questInfoTable, which does group them by category, but addon quests are added to the end.
--questInfoTable list is where it gets its quest index shown left of the quest name.

--category sort default uses this, ih sort uses the order seen in !!!! menu, which puts Story quests first, it also sorts addon quests into their categories
 
  local showSettings=InfQuestIvars.GetUiShowSettings()
  local sortSettings=InfQuestIvars.GetUiSortSettings()

  local groupByAreaSettings={"NO","BEFORE_QUEST_FLAGS","AFTER_QUEST_FLAGS"}--DEBUGNOW

  local sortByFlags={
  --tex manual testing by adding/removing entries (disable the ivar settings below though)
--    "Active",
--    "Activable",
--    "Uncleared",
--    "Cleared",
--    "Open",
--    "category",
--    "locationId",
--    "questArea",
--    "questAreaX",
  }
  
  local sortAscend={
    --tex manual testing by adding/removing entries (disable the ivar settings below though)
--    Active=true,    
--    Activable=true,
--    Uncleared=true,
--    Cleared=true,
--    Open=true,
--    category=true,
--    locationId=true,
--    questArea=true,
  }
  
  --REF
--      settings={
--      "None",
--      "Ascending",--DEBUGNOW --for boolean flags (Active,Uncleared etc) this sorts by either top or bottom of its sort. For numerical and alphabetical it sorts in expected ascending or descending order.
--      "Descending"
--    },
  --tex fill them out using the per flag ivar settings
  for i,flagName in ipairs(InfQuestIvars.uiSortFlags)do
    if sortSettings[flagName]~=0 and sortSettings[flagName]~=Ivars.quest_uiSort_Active.enum.None then
      table.insert(sortByFlags,flagName)
      sortAscend[flagName]=(sortSettings[flagName]==Ivars.quest_uiSort_Active.enum.Ascending)--bool
    end
  end--for uiShowFlags
  
  if this.debugModule then
    InfCore.PrintInspect(sortByFlags,"SortSideopsList sortByFlags")
    InfCore.PrintInspect(sortAscend,"SortSideopsList sortAscend")
  end
   
--IN:sortByFlags - array of flag names to sort by, in order
--IN:sortAscend - {[flagName]=<bool ascending/descending>,...}what direction to sort
  local function SortByFlags(questInfoA, questInfoB)
    for i,flagName in ipairs(sortByFlags)do
      local flagA=questInfoA[flagName]
      local flagB=questInfoB[flagName]
      if flagA==nil then
        InfCore.Log("ERROR: SortByFlags flagA."..flagName.."==nil",true,true)
        return false
      end
      if flagB==nil then
        InfCore.Log("ERROR: SortByFlags flagB."..flagName.."==nil",true,true)
        return false
      end        
      --tex bit of brain gymnasics, a flag being true means its important and we want it sorted first, 
      --but since acending numerical sort gets lowest number, with false (or nil) being higher.
      if type(flagA)=="boolean" then
        flagA=flagA and 0 or 1
      end
      if type(flagB)=="boolean" then 
        flagB=flagB and 0 or 1 
      end
      
      if flagA < flagB then 
        if this.debugModule then
          --InfCore.Log("SortByFlags sortAscend: "..questInfoA.questName.."."..flagName.."="..tostring(flagA).." < "..questInfoB.questName.."."..flagName.."="..tostring(flagB).." returning true")--DEBUGNOW
        end
        return  (sortAscend[flagName]==true)
      end--tex true is sort A before B, so ascending numbers and alpha (via < comparison)
      if flagA > flagB then
        if this.debugModule then
        --InfCore.Log("SortByFlags sortAscend: "..questInfoA.questName.."."..flagName.."="..tostring(flagA).." > "..questInfoB.questName.."."..flagName.."="..tostring(flagB).." returning false")--DEBUGNOW 
        end
        return  not (sortAscend[flagName]==true) --false if sortAscend true if not
      end
      --tex equal flag values fall through the above, so carry on to the next type of flag in sortOrder
    end--for sortOrder
       
    return questInfoA.index < questInfoB.index
  end--SortByFlags  

  table.sort(sideOpsListTable,SortByFlags)
end--SortSideopsList<
function this.GetBounusGMP(questName)
  local rank=TppDefine.QUEST_RANK_TABLE[TppDefine.QUEST_INDEX[questName]]
  if rank then
    return TppDefine.QUEST_BONUS_GMP[rank]
  end
  return 0
end
--UNUSED?
function this.RegisterForceDeactiveOnMBTerminal(questName)
  mvars.qst_forceDeactiveOnMBTerminal=questName
end
--tex NMC but this is. mostly to disable during demos
function this.RegisterClusterForceDeactiveOnMBTerminal(clusterId)
  mvars.qst_forceDeactiveClusterOnMBTerminal=clusterId
end
function this.UnregisterForceDeactiveOnMBTerminal()
  mvars.qst_forceDeactiveOnMBTerminal={}
end
function this.UnregisterClusterForceDeactiveOnMBTerminal()
  mvars.qst_forceDeactiveClusterOnMBTerminal=nil
end
function this.IsActiveOnMBTerminal(questInfo)
  local questName=questInfo.questName
  if mvars.qst_forceDeactiveOnMBTerminal then
    for n,_questName in ipairs(mvars.qst_forceDeactiveOnMBTerminal)do
      if _questName==questName then
        return false
      end
    end
  end
  if mvars.qst_forceDeactiveClusterOnMBTerminal then
    if mvars.qst_forceDeactiveClusterOnMBTerminal==questInfo.clusterId then
      return false
    end
  end
  return this.IsActive(questName)
end
function this.IsOpenLocation(locationId)
  if locationId==TppDefine.LOCATION_ID.MAFR then
    return TppStory.GetCurrentStorySequence()>=TppDefine.STORY_SEQUENCE.CLEARD_RESCUE_HUEY
  elseif locationId==TppDefine.LOCATION_ID.MTBS then
    return true
  end
  return true
end
--tex NMC extra check whether quest should repop (UpdateRepopFlagImpl) or be in the running in UpdateActiveQuest at all
--InfQuest/addon support via IH questAddon .canActiveQuest
local canActiveQuestChecks={}
function this.GetCanActiveQuestTable()--tex expose for InfQuest> 
  return canActiveQuestChecks
end--<
function this.CanActiveQuest(questName)--tex>
  local CanActiveQuestFunc=canActiveQuestChecks[questName]
  if CanActiveQuestFunc then 
    return CanActiveQuestFunc(questName)
  end
  return true
end--<
function canActiveQuestChecks.mtbs_wait_quiet()
  return TppStory.CanArrivalQuietInMB()
end
function canActiveQuestChecks.Mtbs_child_dog()
  local canSortieDDog=TppBuddyService.CanSortieBuddyType(BuddyType.DOG)
  local notDDogGoWithMe=not TppStory.IsNowOccurringElapsedMission(TppDefine.ELAPSED_MISSION_EVENT.D_DOG_GO_WITH_ME)
  return(not canSortieDDog)and notDDogGoWithMe
end
function canActiveQuestChecks.Mtbs_ddog_walking()
  local e=TppBuddyService.IsDeadBuddyType(BuddyType.DOG)
  return(not e)
end
function canActiveQuestChecks.cliffTown_q99080()
  local t=TppMotherBaseManagement.IsExistStaff{uniqueTypeId=110}
  local e=TppStory.IsMissionCleard(10240)
  return t or e
end
function this.SpecialMissionStartSetting(missionClearType)
  if(missionClearType==TppDefine.MISSION_CLEAR_TYPE.QUEST_BOSS_QUIET_BATTLE_END)then
    TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
    TppPlayer.ResetInitialPosition()
    TppPlayer.ResetMissionStartPosition()
    TppHelicopter.ResetMissionStartHelicopterRoute()
    TppPlayer.SetNoOrderBoxMissionStartPosition({-1868.27,343.22,-84.6095},160.651)
    TppMission.ResetIsStartFromHelispace()
    TppMission.SetIsStartFromFreePlay()
  elseif(missionClearType==TppDefine.MISSION_CLEAR_TYPE.QUEST_LOST_QUIET_END)then
    gvars.heli_missionStartRoute=StrCode32"drp_s10260"
    TppPlayer.SetStartStatusRideOnHelicopter()
    TppPlayer.ResetInitialPosition()
    TppPlayer.ResetMissionStartPosition()
    TppPlayer.ResetNoOrderBoxMissionStartPosition()
    TppMission.ResetIsStartFromHelispace()
    TppMission.ResetIsStartFromFreePlay()
  elseif(missionClearType==TppDefine.MISSION_CLEAR_TYPE.QUEST_INTRO_RESCUE_EMERICH_END)then
    TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
    TppPlayer.ResetInitialPosition()
    TppPlayer.ResetMissionStartPosition()
    TppHelicopter.ResetMissionStartHelicopterRoute()
    TppPlayer.SetNoOrderBoxMissionStartPosition({-855.6097,515.6722,-1250.411},160.651)
    TppMission.ResetIsStartFromHelispace()
    TppMission.SetIsStartFromFreePlay()
  end
end
--tex REWORKED only vanilla use was list of questNames 
--IN:
--allowedQuests="<questName>"
--allowedQuests={<questName>,...}
--allowedQuests={<questName>=true,...}
--OUT: mvars.qst_canActiveQuestList = {[<questName>]=true,...}
--checked via CanActiveQuestInMission
function this.RegisterCanActiveQuestListInMission(allowedQuests)
  if allowedQuests then
    local quests=mvars.qst_canActiveQuestList or {}
    mvars.qst_canActiveQuestList=quests
  
    if type(allowedQuests)=="table"then
      for k,v in pairs(allowedQuests)do
        if type(v)=="string"then--tex original usage as a list
          quests[v]=true
        else
          quests[k]=true
        end
      end--for allowedQuests
    elseif type(allowedQuests)=="string"then
      quests[allowedQuests]=true
    end--if table
  end--if allowedQuests
end--RegisterCanActiveQuestListInMission
--ORIG
--function this.RegisterCanActiveQuestListInMission(allowedQuests)
--  mvars.qst_canActiveQuestList=allowedQuests
--end
--NMC CALLER: quest script OnAllocate
function this.RegisterQuestStepList(questStepNames)
  if not IsTypeTable(questStepNames)then
    return
  end
  local numSteps=#questStepNames
  if numSteps==0 then
    return
  end
  if numSteps>=maxSteps then
    return
  end
  table.insert(questStepNames,QStep_ClearStr)
  mvars.qst_questStepList=Tpp.Enum(questStepNames)
end
--NMC CALLER: quest script OnAllocate, just after above.
function this.RegisterQuestStepTable(questStepTable)
  if not IsTypeTable(questStepTable)then
    return
  end
  questStepTable[QStep_ClearStr]={}
  mvars.qst_questStepTable=questStepTable
  if mtbs_enemy and vars.missionCode==30050 then
    mtbs_enemy.OnAllocateDemoBlock()
  end
end
function this.RegisterQuestSystemCallbacks(callbackFunctions)
  if not IsTypeTable(callbackFunctions)then
    return
  end
  InfQuest.RegisterQuestSystemCallbacks(callbackFunctions)--tex
  mvars.qst_systemCallbacks=mvars.qst_systemCallbacks or{}
  local function SetCallBack(callBackFunc,callbackName)
    if IsTypeFunc(callBackFunc[callbackName])then
      mvars.qst_systemCallbacks[callbackName]=callBackFunc[callbackName]
    end
  end
  local callbackNames={"OnActivate","OnOutOfAcitveArea","OnDeactivate","OnTerminate"}
  for i=1,#callbackNames do
    SetCallBack(callbackFunctions,callbackNames[i])
  end
end
function this.SetNextQuestStep(questStep)
  InfCore.Log("TppQuest.SetNextQuestStep("..tostring(questStep)..")")--tex DEBUG
  if not mvars.qst_questStepTable then
    return
  end
  if not mvars.qst_questStepList then
    return
  end
  local questStepTable=mvars.qst_questStepTable[questStep]
  local stepNumber=mvars.qst_questStepList[questStep]
  if questStepTable==nil then
    return
  end
  if stepNumber==nil then
    return
  end
  if this.IsInvoking()then
    local questStepTable=this.GetQuestStepTable(gvars.qst_currentQuestStepNumber)
    local OnLeave=questStepTable.OnLeave
    if IsTypeFunc(OnLeave)then
      OnLeave(questStepTable)
    end
  end
  gvars.qst_currentQuestStepNumber=stepNumber
  --OFF ORPHAN local n=ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE
  local blockState=this.GetQuestBlockState()
  if mvars.qst_allocated then
    local OnEnter=questStepTable.OnEnter
    if IsTypeFunc(OnEnter)then
      OnEnter(questStepTable)
    end
  end
end
function this.ClearWithSave(clearType,questName)
  InfCore.LogFlow("TppQuest.ClearWithSave "..tostring(clearType).." "..tostring(questName))--tex
  if not questName then
    questName=this.GetCurrentQuestName()
  end
  local questIndex=this.GetQuestIndex(questName)
  if clearType==TppDefine.QUEST_CLEAR_TYPE.SHOOTING_CLEAR or clearType==TppDefine.QUEST_CLEAR_TYPE.SHOOTING_RETRY then
    this.OnFinishShootingPractice(clearType)
    --tex> WORKAROUND rather than patching all the functions from OnFinishShootingPractice leading to this
    local retryOnClear=Ivars.quest_enableShootingPracticeRetry:Is(1)
    if clearType==TppDefine.QUEST_CLEAR_TYPE.SHOOTING_CLEAR and retryOnClear then
      TppGimmick.EndQuestShootingPractice(TppDefine.QUEST_CLEAR_TYPE.SHOOTING_RETRY)
    end--<
  end
  if clearType==TppDefine.QUEST_CLEAR_TYPE.CLEAR or clearType==TppDefine.QUEST_CLEAR_TYPE.SHOOTING_CLEAR then
    local retryOnClear=false--tex
    if clearType~=TppDefine.QUEST_CLEAR_TYPE.SHOOTING_CLEAR then
      this.AddStaffsFromTempBuffer()
    else
      retryOnClear=Ivars.quest_enableShootingPracticeRetry:Is(1)--tex
    end
    this.Clear(questName,retryOnClear)--tex added retryOnClear
    if clearType~=TppDefine.QUEST_CLEAR_TYPE.SHOOTING_CLEAR then
      this.Save()
    end
  elseif clearType==TppDefine.QUEST_CLEAR_TYPE.FAILURE then
    this.AddStaffsFromTempBuffer()
    this.Failure(questName)
    this.Save()
  elseif clearType==TppDefine.QUEST_CLEAR_TYPE.UPDATE then
    this.Update(questName)
  elseif clearType==TppDefine.QUEST_CLEAR_TYPE.SHOOTING_RETRY then
    this.Retry(questName)
    this.SetRetryShootingPracticeStartUi()
  end
end
function this.ClearWithSaveMtbsDDQuest()
  local questName=this.GetCurrentQuestName()
  local questIndex=this.GetQuestIndex(questName)
  this.UpdateClearFlag(questIndex,true)
  this.UpdateRepopFlag(questIndex)
  this.Save()
end
--tex added keepAlive
function this.Clear(questName,keepAlive)
  if questName==nil then
    questName=this.GetCurrentQuestName()
    if questName==nil then
      return
    end
  end
  local questIndex=this.GetQuestIndex(questName)
  if questIndex==nil then
    return
  end
  if not keepAlive then--tex added bypass
  this.SetNextQuestStep(QStep_ClearStr)
  end
  this.ShowAnnounceLog(QUEST_STATUS_TYPES.CLEAR,questName)
  this.CheckClearBounus(questIndex,questName)
  this.UpdateClearFlag(questIndex,true,keepAlive)--tex added keepAlive
  if not keepAlive then--tex added bypass DEBUGNOW why?
  this.UpdateRepopFlag(questIndex)
  end
  this.CheckAllClearBounus()
  this.CheckAllClearMineQuest()
  if not TppLocation.IsMotherBase()then
    this.DecreaseElapsedClearCount(questName)
  end
  TppStory.UpdateStorySequence{updateTiming="OnSideOpsClear"}
  if not this.PlayClearRadio(questName)then
    this.GoToMBAfterClear(questName)
  end
  this.GetClearKeyItem(questName)
  this.GetClearCassette(questName)
  this.GetClearEmblem(questName)
  if this.GetSideOpsInfo(questName)then
    TppTrophy.Unlock(15)
  end
  TppMission.SetPlayRecordClearInfo()--RETAILPATCH 1070
  TppChallengeTask.RequestUpdate"SIDEOPS"--RETAILPATCH 1070
  TppUiCommand.SetSideOpsListUpdate()
  for n,name in ipairs(setLockedTanQuests)do
    if questName==name then
      TppMotherBaseManagement.SetLockedTanFlag{locked=false}
      return
    end
  end
end
function this.GoToMBAfterClear(questName)
  if not Tpp.IsNotAlert()then
    return
  end
  if not TppMission.IsFreeMission(vars.missionCode)then
    return
  end
  if vars.missionCode==30050 then
    return
  end
  local forceDemoName=TppStory.GetForceMBDemoNameOrRadioList("clearSideOpsForceMBDemo",{clearSideOpsName=questName})
  if forceDemoName then
    TppMission.ReserveMissionClear{nextMissionId=TppDefine.SYS_MISSION_ID.MTBS_FREE,missionClearType=TppDefine.MISSION_CLEAR_TYPE.FORCE_GO_TO_MB_ON_SIDE_OPS_CLEAR}
    TppDemo.SetNextMBDemo(forceDemoName)
    mvars.qst_currentClearQuestName=questName
  end
end
function this.Failure(questName)
  if questName==nil then
    questName=this.GetCurrentQuestName()
    if questName==nil then
      return
    end
  end
  local questIndex=this.GetQuestIndex(questName)
  if questIndex==nil then
    return
  end
  this.UpdateClearFlag(questIndex,false)
  this.SetNextQuestStep(QStep_ClearStr)
  this.ShowAnnounceLog(QUEST_STATUS_TYPES.FAILURE,questName)
  TppUiCommand.SetSideOpsListUpdate()
  for e=0,9,1 do
    if gvars.qst_failedIndex[e]==-1 then
      gvars.qst_failedIndex[e]=questIndex
      break
    end
  end
end
function this.Update(currentQuestName)
  if currentQuestName==nil then
    currentQuestName=this.GetCurrentQuestName()
    if currentQuestName==nil then
      return
    end
  end
  local questIndex=this.GetQuestIndex(currentQuestName)
  if questIndex==nil then
    return
  end
  --tex TODO Refactor, combine with other call to GetQuestCount s
  local enemyTargetsComplete,enemyTargetsTotal=TppEnemy.GetQuestCount()
  local shotTargetsCount,shotTargetsTotal=TppGimmick.GetQuestShootingPracticeCount()
  local animalStateCounts=TppAnimal.GetQuestCount()--tex added
  if enemyTargetsComplete>0 and enemyTargetsTotal>1 then
    this.ShowAnnounceLog(QUEST_STATUS_TYPES.UPDATE,currentQuestName,enemyTargetsComplete,enemyTargetsTotal)
  elseif shotTargetsCount>0 and shotTargetsTotal>1 then
    this.UpdateShootingPracticeUi()
    this.ShowAnnounceLog(QUEST_STATUS_TYPES.UPDATE,currentQuestName,shotTargetsCount,shotTargetsTotal)
    --tex added>
  elseif animalStateCounts.changed>0 and animalStateCounts.total>1 then
    this.ShowAnnounceLog(QUEST_STATUS_TYPES.UPDATE,currentQuestName,animalStateCounts.changed,animalStateCounts.total)
    --<
  end
end
function this.Retry(questName)
  if questName==nil then
    questName=this.GetCurrentQuestName()
    if questName==nil then
      return
    end
  end
  local questIndex=this.GetQuestIndex(questName)
  if questIndex==nil then
    return
  end
  this.ShowAnnounceLog(QUEST_STATUS_TYPES.FAILURE,questName)
end
function this.AddStaffsFromTempBuffer()
  local isQuestInHelicopter=TppEnemy.IsQuestInHelicopter()
  if isQuestInHelicopter then
    TppTerminal.OnRecoverByHelicopterOnCheckPoint()
  end
  TppTerminal.AddStaffsFromTempBuffer(true)
end
function this.Save()
  TppSave.VarSaveQuest(vars.missionCode)
  TppSave.SaveGameData(vars.missionCode)
end
function this.SetClearFlag(questName)
  if questName==nil then
    return
  end
  --RETAILBUG: WTF, but function not actually used it seems
  local questIndex=TppDefine.QUEST_INDEX[questName]
  if gvars.qst_questClearedFlag[questName]then
    gvars.qst_questClearedFlag[questIndex]=true
  end
end
--should be
--function this.SetClearFlag(questName)
--  if questName==nil then
--    return
--  end
--  --RETAILBUG: WTF, but function not actually used it seems
--  local questIndex=TppDefine.QUEST_INDEX[questName]
--  if gvars.qst_questClearedFlag[questIndex]then
--    gvars.qst_questClearedFlag[questIndex]=true
--  end
--end
function this.ReserveOpenQuestDynamicUpdate()
  InfCore.Log"ReserveOpenQuestDynamicUpdate DEBUGTRACE"--tex cant find any references, seeing if it's called at all
  mvars.qst_reserveDynamicQuestOpen=true
end
function this.FadeOutAndDeativateQuestBlock()
  TppUI.FadeOut(TppUI.FADE_SPEED.FADE_NORMALSPEED,"FadeOutOnOutOfMissionArea")
end
function this.SetQuestBlockName(blockName)
  mvars.qst_blockName=blockName
end
--NMC: UNUSED: just search/use mvars.qst_blockName directly
function this.GetQuestBlockName(e)
  return mvars.qst_blockName
end
function this.OnAllocate(missionTable)
  this.SetDefaultQuestBlock()
end
function this.Init(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.OnReload(missionTable)
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end
function this.Messages()
  local questTrapMessages=this.DeactiveQuestAreaTrapMessages()
  return StrCode32Table{
    Block={{msg="StageBlockCurrentSmallBlockIndexUpdated",func=this.OnUpdateSmallBlockIndex}},
    UI={
      {msg="EndFadeOut",sender="FadeOutOnOutOfMissionArea",
        func=function()
          mvars.qst_blockStateRequest=questBlockStatus.DEACTIVATE
          TppUI.FadeIn(TppUI.FADE_SPEED.FADE_NORMALSPEED)
        end},
      {msg="QuestAreaAnnounceText",
        func=function(questIdNumber)
          this.OnQuestAreaAnnounceText(questIdNumber)
        end}
    },
    Marker={
      {msg="ChangeToEnable",
        func=function(instanceName,makerType,gameObjectId,identificationCode)
          this._ChangeToEnable(instanceName,makerType,gameObjectId,identificationCode)
        end}
    },
    Timer={
      {msg="Finish",sender="TimerShootingPracticeStart",
        func=function()
          this.StartShootingPractice()
        end,
        option={isExecMissionPrepare=true,isExecMissionClear=true}},
      {msg="Finish",sender="TimerShootingPracticeEnd",
        func=function()
          this.OnQuestShootingTimerEnd()
        end,
        option={isExecMissionPrepare=true,isExecMissionClear=true}},
      {msg="Finish",sender="TimerShootingPracticeRetryConfirm",
        func=function()
          TppGimmick.SetQuestShootingPracticeTargetInvisible()
        end,
        option={isExecMissionPrepare=true,isExecMissionClear=true}
      }
    },
    Trap=questTrapMessages}
end
function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  local questScriptBlockMessageExecTable=mvars.qst_questScriptBlockMessageExecTable
  if questScriptBlockMessageExecTable then
    local logText=strLogText
    local r
    Tpp.DoMessage(questScriptBlockMessageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,logText)
  end
  if this.IsInvoking()and mvars.qst_questStepList then
    local currentQuestStepNumber=gvars.qst_currentQuestStepNumber
    local questStepTable=this.GetQuestStepTable(currentQuestStepNumber)
    if questStepTable then
      local questStepMessageExecTable=questStepTable._messageExecTable
      if questStepMessageExecTable then
        local logText=strLogText
        local l
        Tpp.DoMessage(questStepMessageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,logText)
      end
    end
  end
end
--quest script .QUEST_TABLE
function this.OnDeactivate(questTable)
  InfCore.LogFlow("TppQuest.OnDeactivate:")--tex DEBUG
  if questTable.questType==TppDefine.QUEST_TYPE.SHOOTING_PRACTIVE then
    this.OnFinishShootingPractice()
    this.ShootingPracticeStopAllTimer()
    this.OnQuestShootingTimerEnd()
    this.OnDeactivateShootingPracticeForUi()
    this.ClearShootingPracticeMvars()
  end
end
--CALLER: TppMain.OnInitialize, near top
--questList==TppQuestList.questList
function this.RegisterQuestList(questList)
return InfCore.PCallDebug(function(questList)--DEBUGNOW
  InfCore.LogFlow("TppQuest.RegisterQuestList")--tex
  if not IsTypeTable(questList)then
    InfCore.Log("ERROR: TppQuest.RegisterQuestList return: not IsTypeTable(questList)")--tex 
    return
  end
  local numAreas=#questList
  if numAreas==0 then
    InfCore.Log("ERROR: TppQuest.RegisterQuestList return: numAreas==0")--tex 
    return
  end
  for areaIndex=1,numAreas do
    if not IsTypeTable(questList[areaIndex])then
      InfCore.Log("ERROR: TppQuest.RegisterQuestList return: areaIndex "..areaIndex..": not IsTypeTable(questList[areaIndex]")--tex 
      return
    end
    local infoList=questList[areaIndex].infoList
    if not IsTypeTable(infoList)then
      Tpp.DEBUG_DumpTable(questList,2)
      InfCore.Log("ERROR: TppQuest.RegisterQuestList return: area "..tostring(questList[areaIndex].areaName)..":  not IsTypeTable(infoList)")--tex 
      return
    end
    if#infoList==0 then
      InfCore.Log("TppQuest.RegisterQuestList: area "..tostring(questList[areaIndex].areaName)..": #infoList==0")--tex 
      --tex GOTCHA: with IH location addons ability to add new areas it will hit this if there is no addon sideops installed for the new area
      --just logging it and continuing is fine as long as the rest of the code just ipairs the infolist (thus just skiping empty)
      --IH adds an empty infolist to a new area so dot have to worry about it being nil
      --tex was: return
    end
    for infoIndex,questListInfo in ipairs(infoList)do
      if not IsTypeString(questListInfo.name)then
        InfCore.Log("ERROR: TppQuest.RegisterQuestList return: not IsTypeString(questListInfo.name)")--tex 
        return
      end
      if not IsTypeString(questListInfo.invokeStepName)then
        InfCore.Log("ERROR: TppQuest.RegisterQuestList return: not IsTypeString(questListInfo.invokeStepName)")--tex 
        return
      end
    end
    if not questList[areaIndex].clusterName then
      if not IsTypeTable(questList[areaIndex].loadArea)then
      	InfCore.Log("ERROR: TppQuest.RegisterQuestList return: not IsTypeTable(questList[areaIndex].loadArea)")--tex 
        return
      end
      if not IsTypeTable(questList[areaIndex].activeArea)then
        InfCore.Log("ERROR: TppQuest.RegisterQuestList return: not IsTypeTable(questList[areaIndex].activeArea)")--tex 
        return
      end
      if not IsTypeTable(questList[areaIndex].invokeArea)then
        InfCore.Log("ERROR: TppQuest.RegisterQuestList return: not IsTypeTable(questList[areaIndex].invokeArea)")--tex 
        return
      end
    end
  end
  InfCore.LogFlow("TppQuest.RegisterQuestList set mvars.qst_questList")--tex
  mvars.qst_questList=questList
  for areaIndex=1,numAreas do
    for infoIndex,questListInfo in ipairs(questList[areaIndex].infoList)do
      local questName=questListInfo.name
      if StrCode32(questName)==gvars.qst_currentQuestName then
        this.SetCurrentQuestName(questName)
      end
    end
  end
  return mvars.qst_questList
  end,questList)--tex PCall DEBUGNOW
end--RegisterQuestList
--questPackList either TppQuestList.questPackList or (via TppMbFreeDemo.UpdatePackList) TppMbFreeDemo.demoBlockList, f30050demo_fovaPackList (which I think mb in general uses to load its soldier faces? see f30050_sequence.RegisterFovaFpk), and others 
function this.RegisterQuestPackList(questPackList,blockName)
  if not IsTypeTable(questPackList)then
    return
  end
  if this.debugModule then--tex>
    InfCore.Log("TppQuest.RegisterQuestPackList "..tostring(blockName))
    InfCore.PrintInspect(questPackList,"questPackList")
    --tex more logging at bottom
  end--<
  blockName=blockName or defaultQuestBlockName
  local isMotherBase=TppLocation.IsMotherBase()
  local fpkList={}
  for questName,questPackInfo in pairs(questPackList)do
    fpkList[questName]={}
    for k,packPathOrFova in pairs(questPackInfo)do
      if type(packPathOrFova)=="number"then--NMC shouldn't this be type(k)==number?, otherwise what number values are added?
        table.insert(fpkList[questName],packPathOrFova)
      elseif k=="faceIdList"then
        local faceFpkFileCodeList=TppSoldierFace.GetFaceFpkFileCodeList{face=packPathOrFova,useHair=isMotherBase}
        if faceFpkFileCodeList~=nil then
          for n,e in ipairs(faceFpkFileCodeList)do
            table.insert(fpkList[questName],e)
          end
        end
      elseif k=="bodyIdList"then
        local bodyFpkFileCodeList=TppSoldierFace.GetBodyFpkFileCodeList{body=packPathOrFova}
        if bodyFpkFileCodeList~=nil then
          for n,e in ipairs(bodyFpkFileCodeList)do
            table.insert(fpkList[questName],e)
          end
        end
      elseif k=="randomFaceList"then
        if this.IsRandomFaceQuestName(questName)then
          if packPathOrFova.race and packPathOrFova.gender then
            if TppMission.IsMissionStart()then
              local seed=(math.random(0,65535)*65536)+math.random(1,65535)
              local faceTable=TppSoldierFace.CreateFaceTable{race=packPathOrFova.race,gender=packPathOrFova.gender,needCount=1,maxUsedFovaCount=1,seed=seed}
              if faceTable~=nil then
                for i,faceId in ipairs(faceTable)do
                  this.SetRandomFaceId(questName,faceId)
                end
              else
                if packPathOrFova.gender==TppDefine.QUEST_GENDER_TYPE.MAN then
                  this.SetRandomFaceId(questName,TppDefine.QUEST_FACE_ID_LIST.DEFAULT_MAN)
                elseif packPathOrFova.gender==TppDefine.QUEST_GENDER_TYPE.WOMAN then
                  this.SetRandomFaceId(questName,TppDefine.QUEST_FACE_ID_LIST.DEFAULT_WOMAN)
                end
              end
            end
            local faceId=this.GetRandomFaceId(questName)
            local faceTable={faceId}
            local faceFpkFileCodeList=TppSoldierFace.GetFaceFpkFileCodeList{face=faceTable}
            if faceFpkFileCodeList==nil then
              if packPathOrFova.gender==TppDefine.QUEST_GENDER_TYPE.MAN then
                this.SetRandomFaceId(questName,TppDefine.QUEST_FACE_ID_LIST.DEFAULT_MAN)
              elseif packPathOrFova.gender==TppDefine.QUEST_GENDER_TYPE.WOMAN then
                this.SetRandomFaceId(questName,TppDefine.QUEST_FACE_ID_LIST.DEFAULT_WOMAN)
              end
              faceId=this.GetRandomFaceId(questName)
              faceTable={faceId}
              faceFpkFileCodeList=TppSoldierFace.GetFaceFpkFileCodeList{face=faceTable}
            end
            if faceFpkFileCodeList~=nil then
              for n,e in ipairs(faceFpkFileCodeList)do
                table.insert(fpkList[questName],e)
              end
            end
          end
        end
      else
        --NMC: FPK paths
        table.insert(fpkList[questName],packPathOrFova)
      end
    end
  end
  if this.debugModule then--tex>
    InfCore.PrintInspect(questPackList,"RegisterQuestPackList.questPackList")--DEBUG
    InfCore.PrintInspect(fpkList,"RegisterQuestPackList.fpkList")--DEBUG
  end--<
  TppScriptBlock.RegisterCommonBlockPackList(blockName,fpkList)
end
function this.SetDefaultQuestBlock()
  mvars.qst_blockName=defaultQuestBlockName
end
function this.InitializeQuestLoad(clusterIndex)
  local blockState=this.GetQuestBlockState()
  if blockState==nil then
    return
  end
  if vars.missionCode==30050 and clusterIndex==nil then
    return
  end
  local blockIndexX,blockIndexY=Tpp.GetCurrentStageSmallBlockIndex()
  this.UpdateQuestBlockStateAtNotLoaded(blockIndexX,blockIndexY,clusterIndex)
end
function this.InitializeQuestActiveStatus(questActiveCluster)
  local questBlockState=this.GetQuestBlockState()
  if questBlockState==nil then
    return
  end
  if questBlockState==ScriptBlock.SCRIPT_BLOCK_STATE_EMPTY then
    return
  end
  mvars.qst_requestInitializeQuestActiveStatus=false
  mvars.qst_requestInitializeQuestActiveCluster=nil
  if questBlockState<ScriptBlock.SCRIPT_BLOCK_STATE_INACTIVE or not this._CanActivateQuest()then
    mvars.qst_requestInitializeQuestActiveStatus=true
    mvars.qst_requestInitializeQuestActiveCluster=questActiveCluster
    return
  end
  local currentQuestTable=this.GetCurrentQuestTable()
  if currentQuestTable==nil then
    return
  end
  local blockIndexX,blockIndexY=Tpp.GetCurrentStageSmallBlockIndex()
  if this.IsInsideArea("activeArea",currentQuestTable,blockIndexX,blockIndexY,questActiveCluster)then
    this.ActivateCurrentQuestBlock()
  end
  if not this.IsInvoking()then
    if this.IsInsideArea("invokeArea",currentQuestTable,blockIndexX,blockIndexY,questActiveCluster)then
      this.Invoke()
    end
  else
    gvars.qst_currentQuestStepNumber=1
    local questStep=mvars.qst_questStepList[gvars.qst_currentQuestStepNumber]
    this.SetNextQuestStep(questStep)
  end
end
function this.DEBUG_Init()
  mvars.debug.showCurrentQuest=false
  ;(nil).AddDebugMenu("LuaQuest","showCurrentQuest","bool",mvars.debug,"showCurrentQuest")
  mvars.debug.showQuestStatus=false
  ;(nil).AddDebugMenu("LuaQuest","showQuestStatus","bool",mvars.debug,"showQuestStatus")
  mvars.debug.selectQuest=1
  ;(nil).AddDebugMenu("LuaQuest","selectQuest","int32",mvars.debug,"selectQuest")
  mvars.debug.selectQuestIndex=1
  ;(nil).AddDebugMenu("LuaQuest","selectQuestIndex","int32",mvars.debug,"selectQuestIndex")
  mvars.debug.historyQuestStep={}
  mvars.debug.showHistoryQuestStep=false
  ;(nil).AddDebugMenu("LuaQuest","historyQuestStep","bool",mvars.debug,"showHistoryQuestStep")
  mvars.debug.updateActiveQuest=false
  ;(nil).AddDebugMenu("LuaQuest","updateActiveQuest","bool",mvars.debug,"updateActiveQuest")
  mvars.debug.applyDebugFlags=false
  ;(nil).AddDebugMenu("LuaQuest","applyDebugFlags","bool",mvars.debug,"applyDebugFlags")
  mvars.debug.updateOpenFlagSelectQuest=false
  ;(nil).AddDebugMenu("LuaQuest"," dbgSetOpenFlag","bool",mvars.debug,"updateOpenFlagSelectQuest")
  mvars.debug.updateClearFlagSelectQuest=false
  ;(nil).AddDebugMenu("LuaQuest"," dbgSetClearFlag","bool",mvars.debug,"updateClearFlagSelectQuest")
  mvars.debug.updateActiveFlagSelectQuest=false
  ;(nil).AddDebugMenu("LuaQuest"," dbgSetActiveFlag","bool",mvars.debug,"updateActiveFlagSelectQuest")
end
function this.DebugUpdate()
  local mvars=mvars
  local Print=(nil).Print
  local NewContext=(nil).NewContext()
  if mvars.debug.showCurrentQuest then
    Print(NewContext,"")
    Print(NewContext,{.5,.5,1},"LuaQuest showCurrentQuest")
    Print(NewContext,"Current Area Name : "..tostring(this.GetCurrentAreaName()))
    Print(NewContext,"Current Quest Name : "..tostring(this.GetCurrentQuestName()))
    local questBlockState=this.GetQuestBlockState()
    local scriptBlockStateNames={}
    scriptBlockStateNames[ScriptBlock.SCRIPT_BLOCK_STATE_EMPTY]="EMPTY"
    scriptBlockStateNames[ScriptBlock.SCRIPT_BLOCK_STATE_PROCESSING]="PROCESSING"
    scriptBlockStateNames[ScriptBlock.SCRIPT_BLOCK_STATE_INACTIVE]="INACTIVE"
    scriptBlockStateNames[ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE]="ACTIVE"
    Print(NewContext,"Quest block state : "..tostring(scriptBlockStateNames[questBlockState]))
    Print(NewContext,"gvars.qst_currentQuestName : "..tostring(gvars.qst_currentQuestName))
    Print(NewContext,"gvars.qst_currentQuestStepNumber : "..tostring(gvars.qst_currentQuestStepNumber))
    do
      local o={0,1,0}
      local r={1,0,0}
      local s="OK"
      local o=o
      if not this.GetCurrentAreaName()or questBlockState<ScriptBlock.SCRIPT_BLOCK_STATE_INACTIVE then
        s="---"
        elseif not mvars.qst_questStepTable then
        s="No register quest step table! Please Check quest script!"
        o=r
      end
      Print(NewContext,o,"scriptStatus : "..s)
    end
  end
  if mvars.debug.showQuestStatus then
    Print(NewContext,"")
    Print(NewContext,{.5,.5,1},"LuaQuest showQuestStatus")
    local areaIndex=mvars.debug.selectQuest
    local selectQuestIndex=mvars.debug.selectQuestIndex
    if areaIndex>0 and selectQuestIndex>0 then
      local areaInfo=mvars.qst_questList[areaIndex]
      if areaInfo then
        Print(NewContext,string.format("AreaName = %s",areaInfo.areaName))
        local questListInfo=areaInfo.infoList[selectQuestIndex]
        if questListInfo then
          Print(NewContext,string.format("name = %s",questListInfo.name))
          Print(NewContext,string.format("invokeStepName = %s",questListInfo.invokeStepName))
          if questListInfo.clusterName then
            DebutTextPrint(NewContext,string.format("clusterName  =%s",questListInfo.clusterName))--RETAIL NONBUG typo DebugText.Print, doesnt exist in retail anyway
          else
            local function PrintAreaInfo(printContext,areaType,bounds)
              local Print=(nil).Print
              Print(printContext,string.format("%s = { %03d, %03d, %03d, %03d }",areaType,bounds[1],bounds[2],bounds[3],bounds[4]))
            end
            local areaTypes={"loadArea","activeArea","invokeArea"}
            for n=1,#areaTypes do
              local areaType=areaTypes[n]
              local areaBounds=areaInfo[areaType]
              if areaBounds then
                PrintAreaInfo(NewContext,areaType,areaBounds)
              end
            end
          end
          Print(NewContext,"IsOpen : "..tostring(this.IsOpen(questListInfo.name)))
          Print(NewContext,"IsCleard : "..tostring(this.IsCleard(questListInfo.name)))
          Print(NewContext,"IsRepop : "..tostring(this.IsRepop(questListInfo.name)))
          Print(NewContext,"IsActive : "..tostring(this.IsActive(questListInfo.name)))
        else
          Print(NewContext,"No define quest. index: "..tostring(selectQuestIndex))
        end
      end
    end
  end
  if mvars.debug.showHistoryQuestStep then
    Print(NewContext,"")
    Print(NewContext,{.5,.5,1},"LuaQuest historyQuestStep")
    local e=#mvars.debug.historyQuestStep
    for e=1,e do
      Print(NewContext,string.format("%03d: %s",e,mvars.debug.historyQuestStep[e]))
    end
  end
  if mvars.debug.updateActiveQuest then
    this.UpdateActiveQuest{debugUpdate=true}
    this.OnUpdateSmallBlockIndex(Tpp.GetCurrentStageSmallBlockIndex())
    mvars.debug.updateActiveQuest=false
  end
  if mvars.debug.applyDebugFlags then
    local areaIndex=mvars.debug.selectQuest
    local selectQuestIndex=mvars.debug.selectQuestIndex
    if areaIndex>0 and selectQuestIndex>0 then
      local areaInfo=mvars.qst_questList[areaIndex]
      if areaInfo then
        local questListInfo=areaInfo.infoList[selectQuestIndex]
        if questListInfo then
          local questIndex=TppDefine.QUEST_INDEX[questListInfo.name]
          gvars.qst_questOpenFlag[questIndex]=mvars.debug.updateOpenFlagSelectQuest
          gvars.qst_questClearedFlag[questIndex]=mvars.debug.updateClearFlagSelectQuest
          gvars.qst_questActiveFlag[questIndex]=mvars.debug.updateActiveFlagSelectQuest
          if mvars.debug.updateActiveFlagSelectQuest then
            for _questIndex,_questListInfo in pairs(areaInfo.infoList)do
              if _questListInfo.name~=questListInfo.name then
                local questIndex=TppDefine.QUEST_INDEX[_questListInfo.name]
                gvars.qst_questActiveFlag[questIndex]=false
              end
            end
          end
        else
          Print(NewContext,"No define quest. index: "..tostring(selectQuestIndex))
        end
      end
    end
    mvars.debug.applyDebugFlags=false
  end
  if mvars.debug.updateOpenFlagSelectQuest then
  end
  if mvars.debug.updateClearFlagSelectQuest then
  end
  if mvars.debug.updateActiveFlagSelectQuest then
  end
end
function this.ShowAnnounceLogQuestOpen()
  if mvars.qst_isQuestNewOpenFlag==true then
    mvars.qst_isQuestNewOpenFlag=false
    this.ShowAnnounceLog(QUEST_STATUS_TYPES.OPEN)
  end
end
function this.OnUpdateSmallBlockIndex(blockIndexX,blockIndexY,clusterIndex)
  local blockState=this.GetQuestBlockState()
  if blockState==nil then
    InfCore.Log"TppQuest.OnUpdateSmallBlockIndex return: blockState==nil"--tex DEBUGNOW
    return
  end
  local STATE_EMPTY=ScriptBlock.SCRIPT_BLOCK_STATE_EMPTY
  local STATE_PROCESSING=ScriptBlock.SCRIPT_BLOCK_STATE_PROCESSING
  local STATE_INACTIVE=ScriptBlock.SCRIPT_BLOCK_STATE_INACTIVE
  local STATE_ACTIVE=ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE
  mvars.qst_invokeReserveOnActivate=false
  if(blockState==STATE_EMPTY)or(blockState==STATE_PROCESSING)then
    if mvars.qst_reserveDynamicQuestOpen then
      this.UpdateOpenQuest()
      mvars.qst_reserveDynamicQuestOpen=false
    end
    this.UpdateQuestBlockStateAtNotLoaded(blockIndexX,blockIndexY,clusterIndex)
  elseif(blockState==STATE_INACTIVE)then
    this.UpdateQuestBlockStateAtInactive(blockIndexX,blockIndexY,clusterIndex)
  elseif(blockState==STATE_ACTIVE)then
    if Ivars.quest_useAltForceFulton:Get()==1 then--tex>
      local questAreaTable=this.GetCurrentQuestTable()
      if not this.IsInsideArea("activeArea",questAreaTable,blockIndexX,blockIndexY)then
        TppEnemy.CheckDeactiveQuestAreaForceFulton()
      end
    end--<
    this.UpdateQuestBlockStateAtActive(blockIndexX,blockIndexY)
  end
end
function this.OnUpdateClusterIndex(clusterIndex)
  local blockState=this.GetQuestBlockState()
  if blockState==nil then
    return
  end
  if mvars.qst_reserveDynamicQuestOpen then
    this.UpdateOpenQuest()
    mvars.qst_reserveDynamicQuestOpen=false
  end
  local questForArea=this.UpdateQuestBlockStateAtNotLoaded(0,0,clusterIndex)
  mvars.qst_skipTerminateFlag=questForArea
  return questForArea
end
function this.UpdateQuestBlockStateAtNotLoaded(blockIndexX,blockIndexY,clusterIndex)
  if not mvars.qst_questList then--See RegisterQuestList
    InfCore.LogFlow("TppQuest.UpdateQuestBlockStateAtNotLoaded return: not mvars.qst_questList")--tex DEBUGNOW
    return
  end
  InfCore.LogFlow("TppQuest.UpdateQuestBlockStateAtNotLoaded")--tex DEBUGNOW
  local currentQuestName=this.GetCurrentQuestName()
  local questForArea=this.SearchQuestFromAllSpecifiedArea("loadArea",blockIndexX,blockIndexY,clusterIndex)
  if questForArea==nil then
    this.UnloadCurrentQuestBlock()
    this.ClearCurrentQuestName()
    this.ResetQuestStatus()
  end
  if currentQuestName then
    local blockState=this.GetQuestBlockState()
    local SCRIPT_BLOCK_STATE_EMPTY=ScriptBlock.SCRIPT_BLOCK_STATE_EMPTY
    if questForArea then
      if(blockState==SCRIPT_BLOCK_STATE_EMPTY or currentQuestName~=questForArea)then
        this.SetNewQuestAndLoadQuestBlock(questForArea)
      end
      if(blockState~=SCRIPT_BLOCK_STATE_EMPTY)and(currentQuestName==questForArea)then
        mvars.qst_currentQuestTable=this.GetQuestTable(questForArea)
      end
    end
  else
    if questForArea then
      this.SetNewQuestAndLoadQuestBlock(questForArea)
    end
  end
  return questForArea
end
function this.UpdateQuestBlockStateAtInactive(blockIndexX,blockIndexY)
  InfCore.LogFlow("TppQuest.UpdateQuestBlockStateAtInactive ")--tex DEBUGNOW
  local questAreaTable=this.GetCurrentQuestTable()
  if not this.IsInsideArea("loadArea",questAreaTable,blockIndexX,blockIndexY)then
    this.UnloadCurrentQuestBlock()
    return
  end
  if this.IsInsideArea("activeArea",questAreaTable,blockIndexX,blockIndexY)then
    if not this.IsInvoking()then
      if this.IsInsideArea("invokeArea",questAreaTable,blockIndexX,blockIndexY)then
        mvars.qst_invokeReserveOnActivate=true
      end
    end
    mvars.qst_blockStateRequest=questBlockStatus.ACTIVATE
    return
  end
end
function this.UpdateQuestBlockStateAtActive(blockIndexX,blockIndexY)
  local questAreaTable=this.GetCurrentQuestTable()
  if not this.IsInsideArea("activeArea",questAreaTable,blockIndexX,blockIndexY)then
    if mvars.qst_blockStateRequest~=questBlockStatus.DEACTIVATING then
      mvars.qst_blockStateRequest=questBlockStatus.DEACTIVATING
      local remainActive=this.ExecuteSystemCallback"OnOutOfAcitveArea"
      InfCore.Log("InfQuest.UpdateQuestBlockStateAtActive not in activeArea "..questAreaTable.areaName.." Deactivate:"..tostring(not remainActive))--tex DEBUG
      if not remainActive then
        mvars.qst_blockStateRequest=questBlockStatus.DEACTIVATE
      end
    end
    return
  end
  if not this.IsInvoking()then
    if this.IsInsideArea("invokeArea",questAreaTable,blockIndexX,blockIndexY)then
      local currentQuestName=this.GetCurrentQuestName()--tex DEBUG>
      InfCore.Log("InfQuest.UpdateQuestBlockStateAtActive inside invokeArea "..questAreaTable.areaName.." Invoking "..tostring(currentQuestName))--tex DEBUG--<
      this.Invoke()
    end
  end
end
--tex added, only called if quest scrip .OnAllocate call it, so none of the vanilla quest scripts.
function this.QuestBlockOnAllocate(questScript)
  InfCore.LogFlow("TppQuest.QuestBlockOnAllocate")--tex
  InfQuest.QuestBlockOnAllocate(questScript)--tex
end
--<
function this.QuestBlockOnInitialize(questScript)
  InfCore.LogFlow("TppQuest.QuestBlockOnInitialize")--tex
  InfQuest.QuestBlockOnInitialize(questScript)--tex
  local Messages=questScript.Messages
  if IsTypeFunc(Messages)then
    local messageExecTable=Messages()
    mvars.qst_questScriptBlockMessageExecTable=Tpp.MakeMessageExecTable(messageExecTable)
  end
  this.MakeQuestStepMessageExecTable()
  mvars.qst_skipTerminateFlag=nil
  mvars.qst_isRadioTarget=false
  InfQuest.QuestBlockOnInitializeBottom(questScript)--tex
end
function this.QuestBlockOnTerminate(questScript)
  InfCore.LogFlow("TppQuest.QuestBlockOnTerminate")--tex
  InfQuest.QuestBlockOnTerminate(questScript)--tex
  this.ExecuteSystemCallback"OnTerminate"
  mvars.qst_systemCallbacks=nil
  mvars.qst_lastQuestBlockState=nil
  mvars.qst_questStepList=nil
  mvars.qst_questStepTable=nil
  mvars.qst_isRadioTarget=false
  gvars.qst_currentQuestStepNumber=defaultStepNumber
  if mtbs_enemy and vars.missionCode==30050 then
    mtbs_enemy.OnTerminateDemoBlock()
  end
  if not mvars.qst_skipTerminateFlag then
    mvars.qst_currentQuestTable=nil
    this.ClearCurrentQuestName()
    local blockId=ScriptBlock.GetScriptBlockId(mvars.qst_blockName)
    TppScriptBlock.FinalizeScriptBlockState(blockId)
  end
end
function this._CanActivateQuest()
  if mvars.ene_isQuestHeli then
    return not TppReinforceBlock.IsProcessing()
  end
  return true
end
function this.QuestBlockOnUpdate(questScript)
  InfQuest.QuestBlockOnUpdate(questScript)--tex
  local thisLocal=this--NMC: tihs pattern is used in two functions in other files. why? is it that really performant?
  local questBlockState=thisLocal.GetQuestBlockState()
  if questBlockState==nil then
    return
  end
  local ScriptBlock=ScriptBlock
  local mvars=mvars
  local lastQuestBlockState=mvars.qst_lastQuestBlockState
  local SCRIPT_BLOCK_STATE_INACTIVE=ScriptBlock.SCRIPT_BLOCK_STATE_INACTIVE
  local SCRIPT_BLOCK_STATE_ACTIVE=ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE
  if mvars.qst_requestInitializeQuestActiveStatus then
    thisLocal.InitializeQuestActiveStatus(mvars.qst_requestInitializeQuestActiveCluster)
    return
  end
  if questBlockState==SCRIPT_BLOCK_STATE_INACTIVE then
    if lastQuestBlockState==SCRIPT_BLOCK_STATE_ACTIVE then
      thisLocal._DoDeactivate()
    end
    if mvars.qst_blockStateRequest==questBlockStatus.ACTIVATE then
      if thisLocal._CanActivateQuest()then
        thisLocal.ActivateCurrentQuestBlock()
        thisLocal.ClearBlockStateRequest()
      end
    end
    mvars.qst_lastInactiveToActive=false
  elseif questBlockState==SCRIPT_BLOCK_STATE_ACTIVE then
    if not thisLocal._CanActivateQuest()then
      return
    end
    local questStepTable
    if thisLocal.IsInvoking()then
      questStepTable=thisLocal.GetQuestStepTable(gvars.qst_currentQuestStepNumber)
    end
    if mvars.qst_lastInactiveToActive then
      mvars.qst_lastInactiveToActive=false
      mvars.qst_deactivated=false
      thisLocal.ExecuteSystemCallback"OnActivate"
      mvars.qst_allocated=true
      if mvars.qst_invokeReserveOnActivate then
        mvars.qst_invokeReserveOnActivate=false
        thisLocal.Invoke()
        questStepTable=thisLocal.GetQuestStepTable(gvars.qst_currentQuestStepNumber)
      end
      if questStepTable and IsTypeFunc(questStepTable.OnEnter)then
        questStepTable.OnEnter(questStepTable)
      end
    end
    if(not lastQuestBlockState)or lastQuestBlockState<=SCRIPT_BLOCK_STATE_INACTIVE then
      mvars.qst_lastInactiveToActive=true
    end
    if questStepTable and IsTypeFunc(questStepTable.OnUpdate)then
      questStepTable.OnUpdate(questStepTable)
    end
    if mvars.qst_blockStateRequest==questBlockStatus.DEACTIVATE then
      thisLocal.DeactivateCurrentQuestBlock()
      thisLocal.ClearBlockStateRequest()
    end
  else
    mvars.qst_lastInactiveToActive=false
    thisLocal.ClearBlockStateRequest()
  end
  mvars.qst_lastQuestBlockState=questBlockState
end
function this.OnMissionGameEnd()
  local blockState=this.GetQuestBlockState()
  mvars.qst_isMissionEnd=true
  if blockState==ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE then
    this._DoDeactivate()
  end
end
function this.ClearBlockStateRequest()
  mvars.qst_blockStateRequest=questBlockStatus.NONE
end
function this.Invoke()
  local currentQuestName=this.GetCurrentQuestName()
  local areaQuestTable,questListInfo=this.GetQuestTable(currentQuestName)
  local invokeStepName=questListInfo.invokeStepName
  this.SetNextQuestStep(invokeStepName)
end
function this.SetNewQuestAndLoadQuestBlock(questName)
  InfCore.LogFlow("TppQuest.SetNewQuestAndLoadQuestBlock: "..questName)--tex DEBUG
  --InfCore.PrintInspect(TppQuestList.questPackList[questName],"questPackList")--tex DEBUG
  if TppLocation.IsMotherBase()then
    f30050_demo.UpdatePackList(questName)
  end

  local loaded=TppScriptBlock.Load(mvars.qst_blockName,questName)
  if loaded==false then
    return
  end
  this.ResetQuestStatus()
  this.SetCurrentQuestName(questName)
  mvars.qst_currentQuestTable=this.GetQuestTable(questName)
end
function this.GetCurrentQuestName()
  return mvars.qst_currentQuestName
end
function this.GetCurrentAreaName()
  local questAreaTable=this.GetCurrentQuestTable()
  if questAreaTable then
    return questAreaTable.areaName
  else
    return nil
  end
end
function this.SetCurrentQuestName(questName)
  mvars.qst_currentQuestName=questName
  gvars.qst_currentQuestName=StrCode32(questName)
end
function this.ClearCurrentQuestName()
  mvars.qst_currentQuestName=nil
  gvars.qst_currentQuestName=questNameNone
end
function this.ResetQuestStatus()
  gvars.qst_currentQuestName=questNameNone
  gvars.qst_currentQuestStepNumber=defaultStepNumber
end
function this.UnloadCurrentQuestBlock()
  TppScriptBlock.Unload(mvars.qst_blockName)
end
function this.ActivateCurrentQuestBlock()
  local blockId=ScriptBlock.GetScriptBlockId(mvars.qst_blockName)
  TppScriptBlock.ActivateScriptBlockState(blockId)
end
function this.DeactivateCurrentQuestBlock()
  local blockId=ScriptBlock.GetScriptBlockId(mvars.qst_blockName)
  TppScriptBlock.DeactivateScriptBlockState(blockId)
end
function this.SearchQuestFromAllSpecifiedArea(areaType,blockIndexX,blockIndexY,clusterIndex)
  local numAreas=#mvars.qst_questList--TppQuest.questList
  for i=1,numAreas do
    local locationAreaQuestTable=mvars.qst_questList[i]--TppQuestList .questList
    if this.IsInsideArea(areaType,locationAreaQuestTable,blockIndexX,blockIndexY,clusterIndex)then
      --OFF ORPHAN local n={}
      for n,questListInfo in ipairs(locationAreaQuestTable.infoList)do
        local questForArea=questListInfo.name
        if this.IsActive(questForArea)then
          return questForArea
        end
      end
    end
  end
end
function this.IsInsideArea(areaType,locationAreaQuestTable,blockIndexX,blockIndexY,clusterId)
  do
    local locationName=TppPackList.GetLocationNameFormMissionCode(vars.missionCode)
    local locationId=TppDefine.LOCATION_ID[locationName]
    if locationAreaQuestTable.locationId~=locationId then
      return false
    end
  end
  if locationAreaQuestTable.clusterName then
    return TppDefine.CLUSTER_NAME[clusterId]==locationAreaQuestTable.clusterName
  else
    --OFF ORPHAN local t=e.areaName
    local areaExtents=locationAreaQuestTable[areaType]
    if areaExtents==nil then
      return
    end
    
    local inBlockArea=Tpp.CheckBlockArea(areaExtents,blockIndexX,blockIndexY)
    if this.debugModule then--tex>
      InfCore.LogFlow("TppQuest. IsInsideArea in location: "..areaType.." blockIndexX:"..tostring(blockIndexX)..", blockIndexY:"..tostring(blockIndexY)..", clusterId:"..tostring(clusterId).." inBlockArea=" ..tostring(inBlockArea))
    end--tex
    return inBlockArea
  end
end
function this.GetCurrentQuestTable()
  return mvars.qst_currentQuestTable
end
function this.GetQuestTable(questName)
  local numAreas=#mvars.qst_questList--TppQuest.questList
  for areaIndex=1,numAreas do
    local areaQuestTable=mvars.qst_questList[areaIndex]
    for i,questListInfo in ipairs(areaQuestTable.infoList)do
      if questListInfo.name==questName then
        return areaQuestTable,questListInfo
      end
    end
  end
end
function this.GetQuestIndex(questName)
  local questIndex=TppDefine.QUEST_INDEX[questName]
  if questIndex then
    return questIndex
  else
    return
  end
end
--tex NMC GOTCHA: some quests are hidden, dont have questInfo (see Note at top of questInfoTable)
function this.GetSideOpsInfo(questName)
  --tex modified
  local questTableIndex=this.QUESTTABLE_INDEX[questName]
  if questTableIndex then
    return questInfoTable[questTableIndex]
  end
  --ORIG
  --  for n,sideOpInfo in ipairs(questTable)do
  --    if sideOpInfo.questName==questName then
  --      return sideOpInfo
  --    end
  --  end
  return nil
end
--UNUSED
function this.IsShowSideOpsList(t)
  return this.GetSideOpsInfo()~=nil
end
--NMC takes last parts of questName to get questId ex tent_q10010 to q10010
function this.GetQuestNameLangId(questName)
  local sideOpInfo=this.GetSideOpsInfo(questName)
  if sideOpInfo then
    local langId="name_"..string.sub(sideOpInfo.questId,-6)
    return langId
  end
  return false
end
function this.GetQuestNameId(questName)
  local sideOpInfo=this.GetSideOpsInfo(questName)
  if sideOpInfo then
    local nameId=string.sub(sideOpInfo.questId,-6)
    return nameId
  end
  return false
end
function this.GetQuestName(questIdNumber)
  for i,questInfo in ipairs(questInfoTable)do
    local currentIdNumber=tonumber(string.sub(questInfo.questId,-5))
    if questIdNumber==currentIdNumber then
      return questInfo.questName
    end
  end
end
function this.ExecuteSystemCallback(callbackName)
  InfCore.LogFlow("TppQuest.ExecuteSystemCallback:"..callbackName)--tex DEBUG
  if mvars.qst_systemCallbacks==nil then
    return
  end
  local CallBackFunc=mvars.qst_systemCallbacks[callbackName]
  if CallBackFunc then
    return InfCore.PCallDebug(CallBackFunc)--tex wrapped in pcall
  end
end
function this.IsInvoking()
  if gvars.qst_currentQuestStepNumber~=defaultStepNumber then
    return true
  else
    return false
  end
end
function this.UpdateOpenQuest()
  InfCore.LogFlow("TppQuest.UpdateOpenQuest")--tex
  mvars.qst_isQuestNewOpenFlag=false
  for questName,questIndex in pairs(TppDefine.QUEST_INDEX) do
    local CanOpenQuestFunc=canOpenQuestChecks[questName]
    --tex added pass quest name into func
    if CanOpenQuestFunc and CanOpenQuestFunc(questName) then
      if gvars.qst_questOpenFlag[questIndex]==false then
        mvars.qst_isQuestNewOpenFlag=true
      end
      gvars.qst_questOpenFlag[questIndex]=true
    end
  end
end  
--tex returns lists of activable candidates for the area, split into priorities
--broken out from UpdateActiveQuest
--areaQuestsList: TppQuestList.questList[areaInfoIdx].infoList
function this.SelectActivableQuests(areaQuestsList,dontBlock)--ForArea
  --uncleared
  local storyQuests={}
  local nonStoryQuests={}
  --cleared
  local repopQuests={}
  local repopAddonQuests={}--tex for selectForArea RANDOM_ADDON, subset of above    
  
  for j,info in ipairs(areaQuestsList)do
    local questName=info.name
    local questIndex=TppDefine.QUEST_INDEX[questName]
    if questIndex then       
      local CanActiveQuest=canActiveQuestChecks[questName]
      local blockQuest=InfQuest.BlockQuest(questName) and not dontBlock--tex IH reasons to block quest, including catergory selection menu / InfQuestIvars quest_category_ 
      if blockQuest then
        InfCore.Log("blocked Quest "..questName)
      end
      if this.debugModule then--tex>
        InfCore.Log(questName.." selection states: canActiveQuest:"..tostring(this.CanActiveQuest(questName)).." IsOpen:"..tostring(this.IsOpen(questName)).." IsCleared:"..tostring(this.IsCleard(questName)).." IsRepop:"..tostring(this.IsRepop(questName)).." isStory:"..tostring(info.isStory).." isOnce:"..tostring(info.isOnce))
      end--<
      if this.IsOpen(questName)and this.CanActiveQuest(questName)and not blockQuest then--tex added blockQuest, added questName param to CanActiveQuest
        if not this.IsCleard(questName)then
          if info.isStory then
            table.insert(storyQuests,questName)
          else
            table.insert(nonStoryQuests,questName)
          end
        elseif this.IsRepop(questName) then
          table.insert(repopQuests,questName)
          local isAddon=InfQuest.ihQuestsInfo[questName]--tex> 
          if isAddon then
            table.insert(repopAddonQuests,questName)
          end--<
        end--if cleared or repop
      end --<quest open
    end --<questindex
  end --<for infolist
  return storyQuests,nonStoryQuests,repopQuests,repopAddonQuests
end--SelectActivableQuests 

--tex heavily REWORKED --PCall InfHooked
--CALLER: TppMain.OnInitialize
--GOTCHA: once player has completed most quests the system then mostly relies on repoping quests, which is driven by UpdateRepopFlag/UpdateRepopFlagImpl.
--however with vanilla code this is mainly only called on quest completion. This means with some IH quest selection options the whole list could get stuck in a none-selected state.
--though in most of those cases IH runs UpdateRepopFlagImpl on changing its options anyway, and IH reroll also calls it.
function this.UpdateActiveQuest(updateFlags)
  if not mvars.qst_questList then
    InfCore.LogFlow("TppMain.UpdateActiveQuest return: not mvars.qst_questList")--tex DEBUGNOW
    return
  end
  InfCore.LogFlow("TppQuest.UpdateActiveQuest "..vars.missionCode)--tex DEBUGNOW
  if this.NeedUpdateActiveQuest(updateFlags)then
  	if this.debugModule then--tex>
    	InfCore.Log("NeedUpdateActiveQuest true")
    end--<
    this.UpdateOpenQuest()

    if this.debugModule then--tex >
      local selectForArea=Ivars.quest_selectForArea:GetSettingName()
      InfCore.Log("UpdateActiveQuest: selectForArea:"..tostring(selectForArea))--tex DEBUG
      local enabledCategories=InfQuest.GetEnabledCategories()--tex LEGACY now doing category selection in BlockQuest, leaving this here for debug
      InfCore.PrintInspect(enabledCategories,"enabledCategories")
    end--<
    
    local activeQuestCount=0
    local forcedQuests=InfQuest.GetForced()--tex REF {[forcedQuestArea]=<forcedQuestName>,...}
    for i,areaQuests in ipairs(mvars.qst_questList)do--TppQuestList.questList
      --tex NMC clear current active quests
      for j,info in ipairs(areaQuests.infoList)do
        local questName=info.name
        local questIndex=TppDefine.QUEST_INDEX[questName]
        if questIndex then
          gvars.qst_questActiveFlag[questIndex]=false
        end
      end--for infoList
      
      --tex forcedquests>  add quest then skip area that unlocked op is in. 
      --GOTCHA: since this is outright override it could cause issues blocking story/hidden quests 
      local unlockedName=forcedQuests and forcedQuests[areaQuests.areaName] or nil
      if unlockedName then
        InfCore.Log("TppQuest.UpdateActiveQuest unlockedName:"..unlockedName)--
        gvars.qst_questActiveFlag[TppDefine.QUEST_INDEX[unlockedName]]=true
        --<forcedquests
      else
        --tex NMC: activable candidates for the area, split into priorities
        local storyQuests,nonStoryQuests,repopQuests,repopAddonQuests=this.SelectActivableQuests(areaQuests.infoList)    

        local selectedCount=#storyQuests+#nonStoryQuests+#repopQuests--tex>
        InfCore.Log("UpdateActiveQuest selected "..selectedCount.." quest candidates out of "..#areaQuests.infoList.." for area "..areaQuests.areaName)
        if this.debugModule then
          InfCore.PrintInspect(storyQuests,"storyQuests")
          InfCore.PrintInspect(nonStoryQuests,"nonStoryQuests")
          InfCore.PrintInspect(repopQuests,"repopQuests")
 
          InfCore.PrintInspect(repopAddonQuests,"repopAddonQuests")         
        end--<
        
        --tex NMC now that we've gatherered all candidate quests for the area, we need to select one, using the lists as priority order
        local activateQuest=nil
        if selectedCount>0 then
          --tex NOTE: these are uncleared, so it still prioritizes vanilla uncleared to avoid issues with progression and hidden quests
          --and on repop they'll be randomed (if the setting is on) like you'd want to anyway
          for j,questNames in ipairs{storyQuests,nonStoryQuests}do--tex was {storyQuests,nonStoryQuests,repopQuests}
            if not activateQuest then--tex NMC with below -v- doubles as a nil check for empty list
              activateQuest=questNames[1]--tex NMC select first in first list found
            end
          end--for uncleared quests

          if not activateQuest then
            local selectForArea=Ivars.quest_selectForArea:GetSettingName()--tex REF "FIRST_FOUND"|"RANDOM"|"RANDOM_ADDON"
            local repopLists={repopQuests}      
            if selectForArea=="RANDOM_ADDON" then
              repopLists={repopAddonQuests,repopQuests}
            end
            InfMain.RandomSetToLevelSeed()
            for j,questNames in ipairs(repopLists) do
              if not activateQuest and #questNames>0 then
                if selectForArea=="FIRST_FOUND"then--tex default
                  activateQuest=questNames[1]
                else--tex ASSUMPTION: "RANDOM","RANDOM_ADDON". be more specific if you add anything else to quest_selectForArea
                  activateQuest=questNames[math.random(#questNames)]
                end
              end
            end--for repop quests
            InfMain.RandomResetToOsTime()--tex technically changing the seed here even if defaults on, but whatever
          end--if not selectedQuest
        end--if selectedCount>0

        if activateQuest then
          InfCore.Log("areaName:"..areaQuests.areaName.." activateQuest:"..activateQuest)--tex DEBUG
          gvars.qst_questActiveFlag[TppDefine.QUEST_INDEX[activateQuest]]=true
          activeQuestCount=activeQuestCount+1--tex 
        else
          --tex covered by "UpdateActiveQuest selected" selectedCount log above
          --InfCore.Log("UpdateActiveQuest "..vars.missionCode.." did not activate a quest for area "..areaQuests.areaName)--tex
        end
      end--not forcedquest
    end-- for areaQuests in questlist
    
    InfCore.Log(activeQuestCount.." quests activated")--tex NOTE: doesnt include forced
  --< if NeedUpdateActiveQuest
  elseif TppMission.IsStoryMission(vars.missionCode)then
    for n,questName in ipairs(TppDefine.QUEST_DEFINE)do
      if not this.CanActiveQuestInMission(vars.missionCode,questName) then
        gvars.qst_questActiveFlag[TppDefine.QUEST_INDEX[questName]]=false
      end
    end
  else
    --tex NMC just reactivate a recently failed quest?
    for i=0,9,1 do
      if gvars.qst_failedIndex[i]~=-1 then
        local failedIndex=gvars.qst_failedIndex[i]
        gvars.qst_questActiveFlag[failedIndex]=true
        gvars.qst_failedIndex[i]=-1
      end
    end
  end
  for i=0,9,1 do
    gvars.qst_failedIndex[i]=-1
  end
  TppUiCommand.SetSideOpsListUpdate()--tex NMC see GetSideOpsListTable for what's actually shown
  for i,questName in ipairs(setLockedTanQuests)do
    if gvars.qst_questActiveFlag[TppDefine.QUEST_INDEX[questName]]==true then
      TppMotherBaseManagement.SetLockedTanFlag{locked=true}
      return
    end
  end
  --tex TODO if debugModule log all qst_questActiveFlag[] 
end--UpdateActiveQuest
--tex ORIG:
--function this.UpdateActiveQuest(updateFlags)
--  if not mvars.qst_questList then
--    return
--  end
--  if this.NeedUpdateActiveQuest(updateFlags)then
--    this.UpdateOpenQuest()
--    for i,areaQuests in ipairs(mvars.qst_questList)do
--      local n=nil
--      local n={}
--      local storyQuests={}
--      local nonStoryQuests={}
--      local repopQuests={}
--      for j,info in ipairs(areaQuests.infoList)do
--        local questName=info.name
--        local questIndex=TppDefine.QUEST_INDEX[questName]
--        if questIndex then
--          gvars.qst_questActiveFlag[questIndex]=false
--          local CanActiveQuest=canActiveQuestChecks[questName]
--          if this.IsOpen(questName)and(not CanActiveQuest or CanActiveQuest())then
--            if not this.IsCleard(questName)then
--              if info.isStory then
--                table.insert(storyQuests,questName)
--              else
--                table.insert(nonStoryQuests,questName)
--              end
--            elseif this.IsRepop(questName)then
--              table.insert(repopQuests,questName)
--            end
--          end
--        end
--      end
--      local questName=nil
--      for j,questNames in ipairs{storyQuests,nonStoryQuests,repopQuests}do
--        if not questName then
--          questName=questNames[1]
--        end
--      end
--      if questName then
--        gvars.qst_questActiveFlag[TppDefine.QUEST_INDEX[questName]]=true
--      end
--    end
--  elseif TppMission.IsStoryMission(vars.missionCode)then
--    for n,questName in ipairs(TppDefine.QUEST_DEFINE)do
--      if not this.CanActiveQuestInMission(vars.missionCode,questName)then
--        gvars.qst_questActiveFlag[TppDefine.QUEST_INDEX[questName]]=false
--      end
--    end
--  else
--    for i=0,9,1 do
--      if gvars.qst_failedIndex[i]~=-1 then
--        local failedIndex=gvars.qst_failedIndex[i]
--        gvars.qst_questActiveFlag[failedIndex]=true
--        gvars.qst_failedIndex[i]=-1
--      end
--    end
--  end
--  for i=0,9,1 do
--    gvars.qst_failedIndex[i]=-1
--  end
--  TppUiCommand.SetSideOpsListUpdate()
--  for i,questName in ipairs(RENsetLockedTanQuests)do
--    if gvars.qst_questActiveFlag[TppDefine.QUEST_INDEX[questName]]==true then
--      TppMotherBaseManagement.SetLockedTanFlag{locked=true}
--      return
--    end
--  end
--end
function this.CanActiveQuestInMission(missionCode,questName)
  if(not TppMission.IsStoryMission(missionCode))then
    return true
  else
    if mvars.qst_canActiveQuestList then
      return mvars.qst_canActiveQuestList[questName]--tex changed to key,bool table
    --ORIG
--      for i,_questName in ipairs(mvars.qst_canActiveQuestList)do
--        if _questName==questName then
--          return true
--        end
--      end
    end
    return false
  end
end
function this.IsImportant(questName)
  local sideOpsInfo=this.GetSideOpsInfo(questName)
  if sideOpsInfo then
    return sideOpsInfo.isImportant
  end
  return false
end
--NMC: just checks that player isnt in the area
local specialQuestList={
  waterway_q99012="waterway",--150 - Secure Quiet - NMC OpenAndActivateSpecialQuest never actually called with this?
  tent_q99040="tent",--144 - Secure the Remains of the Man on Fire
  --NMC > called in one go
  tent_q20910="tent",--148 Search for the Escaped Children 04
  sovietBase_q20912="waterway",-- Search for the Escaped Children 03
  fort_q20911="fort"--Search for the Escaped Children 05
}
function this.OpenAndActivateSpecialQuest(questNames)
  local opened=true
  for i,questName in ipairs(questNames)do
    if this.CanOpenAndActivateSpecialQuest(questName)then
      this.OpenQuestForce(questName)
      this.SwitchActiveQuest(questName)
      this.AddStaffsFromTempBuffer()
      this.Save()
    else
      opened=false
    end
  end
  if opened then
    this.ShowAnnounceLog(QUEST_STATUS_TYPES.OPEN)
  end
  return opened
end
function this.OpenQuestForce(questName)
  local questIndex=TppDefine.QUEST_INDEX[questName]
  if questIndex then
    gvars.qst_questOpenFlag[questIndex]=true
  end
end
function this.CanOpenAndActivateSpecialQuest(questName)
  local areaName=specialQuestList[questName]
  if not areaName then
    return false
  end
  for a,areaQuests in ipairs(TppQuestList.questList)do
    if areaQuests.areaName==areaName then
      local locationName=TppPackList.GetLocationNameFormMissionCode(vars.missionCode)
      local locationId=TppDefine.LOCATION_ID[locationName]
      if areaQuests.locationId~=locationId then
        return true
      end
      local blockIndexX,blockIndexY=Tpp.GetCurrentStageSmallBlockIndex()
      if not this.IsInsideArea("loadArea",areaQuests,blockIndexX,blockIndexY)then
        return true
      end
    end
  end
  return false
end
function this.SwitchActiveQuest(questName)
  local specialQuestArea=specialQuestList[questName]
  if not specialQuestArea then
    return
  end
  for i,areaQuests in ipairs(TppQuestList.questList)do
    if areaQuests.areaName==specialQuestArea then
      for j,info in ipairs(areaQuests.infoList)do
        local _questName=info.name
        local questIndex=TppDefine.QUEST_INDEX[_questName]
        if questIndex then
          gvars.qst_questActiveFlag[questIndex]=(_questName==questName)
        end
      end
    end
  end
end
function this.IsRepop(questName)
  --tex>force repop
  if Ivars.quest_forceRepop:Is(1) then
    return true
  end--<
  local questIndex=TppDefine.QUEST_INDEX[questName]
  if questIndex then
    return gvars.qst_questRepopFlag[questIndex]
  end
end
function this.IsOpen(questName)
  --tex just force this here, don't want to touch the actual flag as it's saved/cant be easily reversed>
  if Ivars.quest_forceOpen:Is(1) then
    return true
  end--<
  local questIndex=TppDefine.QUEST_INDEX[questName]
  if questIndex then
    return gvars.qst_questOpenFlag[questIndex]
  end
end
function this.IsActive(questName)
  local questIndex=TppDefine.QUEST_INDEX[questName]
  if questIndex then
    return gvars.qst_questActiveFlag[questIndex]
  end
end
function this.IsCleard(questName)--TYPO
  local questIndex=TppDefine.QUEST_INDEX[questName]
  if questIndex then
    return gvars.qst_questClearedFlag[questIndex]
  end
end
function this.IsEnd(questName)
  if questName==nil then
    questName=this.GetCurrentQuestName()
    if questName==nil then
      return
    end
  end
  if mvars.qst_questStepList[gvars.qst_currentQuestStepNumber]==QStep_ClearStr then
    return true
  end
  return false
end
function this._DoDeactivate()
  mvars.qst_deactivated=true
  this.ExecuteSystemCallback"OnDeactivate"
  mvars.qst_allocated=false
end
function this.MakeQuestStepMessageExecTable()
  if not IsTypeTable(mvars.qst_questStepTable)then
    return
  end
  for n,questStepTable in pairs(mvars.qst_questStepTable)do
    local Messages=questStepTable.Messages
    if IsTypeFunc(Messages)then
      local messagesTable=Messages(questStepTable)
      questStepTable._messageExecTable=Tpp.MakeMessageExecTable(messagesTable)
    end
  end
end
function this.GetQuestStepTable(questStepNumber)
  if mvars.qst_questStepList==nil then
    return
  end
  local questStep=mvars.qst_questStepList[questStepNumber]
  if questStep==nil then
    return
  end
  local questStepTable=mvars.qst_questStepTable[questStep]
  if questStepTable~=nil then
    return questStepTable
  else
    return
  end
end
function this.GetQuestBlockState()
  local blockId=ScriptBlock.GetScriptBlockId(mvars.qst_blockName)
  if blockId==ScriptBlock.SCRIPT_BLOCK_ID_INVALID then
    InfCore.Log("GetQuestBlockState: return: mvars.qst_blockName ==ScriptBlock.SCRIPT_BLOCK_ID_INVALID")--DEBUGNOW
    return
  end
  return ScriptBlock.GetScriptBlockState(blockId)
end
function this.CheckClearBounus(questIndex,t)
  local questRank=TppDefine.QUEST_RANK_TABLE[questIndex]
  local gmp=TppDefine.QUEST_BONUS_GMP[questRank]
  if questRank then
    TppHero.SetAndAnnounceHeroicOgrePointForQuestClear(questRank)
    TppTerminal.UpdateGMP{gmp=gmp,gmpCostType=TppDefine.GMP_COST_TYPE.CLEAR_SIDE_OPS}
  end
end
function this.UpdateClearFlag(questIndex,clear,keepAlive)--tex added keepAlive
  if clear then
    gvars.qst_questClearedFlag[questIndex]=true
  end
  if not keepAlive then--tex added bypass
  gvars.qst_questActiveFlag[questIndex]=false
  end
end
--CALLER: Clear
function this.UpdateRepopFlag(questIndex)
  gvars.qst_questRepopFlag[questIndex]=false
  local questAreaTable=this.GetCurrentQuestTable()
  if not questAreaTable then
    return
  end
  this.UpdateRepopFlagImpl(questAreaTable)
end
--tex NMC: broken out from UpdateRepopFlagImpl
--returns false if there's any activable quests
function this.NeedUpdateRepop(locationQuests)
  local numRepopable=0
  for n,questListInfo in ipairs(locationQuests.infoList)do
    local questName=questListInfo.name
    if this.IsOpen(questName)then
      if not questListInfo.isOnce then
        numRepopable=numRepopable+1
      end
      if this.IsRepop(questName)or not this.IsCleard(questName)then
        local CanActiveQuest=canActiveQuestChecks[questName]
        if(CanActiveQuest==nil)or CanActiveQuest(questName)then--tex NMC if CanActiveQuest() true, tex added questName param to CanActiveQuest
          if this.debugModule then--tex>
            InfCore.Log("TppQuest.NeedUpdateRepop:"..questName.." is uncleared or already repop. Not repoping other quests. returning false.")
          end--<
          return false--tex NMC bail if theres a quest candidate to Active
        end
      end--if IsRepop or not IsCleard
    end--if IsOpen
  end--for infoList
  --tex NMC dont quite understand what this is guarding against. seems like a basic skip out early
  --and I understand why you'd bail on 0, but why on 1 repopable?
  --but cant see any non mb areas that have only 1 or 0 repopables. citadel has two.
  --MB areas by default only usually have one quest (a shooting prac), 
  --so the IsMotherBase check means those mb areas wont actually repop unless on mb (or helispace mb)
  if numRepopable<=1 and(not TppLocation.IsMotherBase())then
    if this.debugModule then--tex>
      InfCore.Log("TppQuest.NeedUpdateRepop numRepopable<=1 and(not TppLocation.IsMotherBase()) returning false")
    end--<
    return false
  end
  
  return true
end--NeedUpdateRepop
--CALLER: UpdateRepopFlag < Clear
--locationQuests = TppQuestList.questList[<some area index>]
--tex NMC Called on a quest clear with the locationQuests table of the area that quest is in
--NOTE: the quest that was just cleared will have had qst_questRepopFlag set false, see above -^-
--will do nothing if there's other quests already Activable (not WantUpdateRepop)
--otherwise repop every quest in area that can be
--which results in (UpdateActiveQuest) quest selection being whittled down as they are completed, then refreshing with repops. rince and repeat.
--GOTCHA: quest_forceRepop (though that ivar has now been relegated to debug) will bail this (is this good or bad?), but forced isOnce wont have flags touched (good)
--IN:Ivars.quest_updateRepopMode--tex switch between default behaviour of only repopping if no other quests left, or allways repopping 
--OUT:gvars.qst_questRepopFlag
--tex added allwaysUpdate
function this.UpdateRepopFlagImpl(locationQuests,allwaysUpdate)
  InfCore.PCallDebug(function(locationQuests)--tex wrapped in pcall
    InfCore.LogFlow("TppQuest.UpdateRepopFlagImpl area:"..tostring(locationQuests.areaName))--tex
    if not this.NeedUpdateRepop(locationQuests) and not allwaysUpdate and not Ivars.quest_updateRepopMode:Get()==0 then--tex added quest_updateRepopMode bypass GOTCHA: if you add any other modes than 'ALLWAYS'
      return
    end

    for n,questListInfo in ipairs(locationQuests.infoList)do
      if this.IsCleard(questListInfo.name)and(not questListInfo.isOnce) then
        if this.debugModule then--tex>
          InfCore.Log("InfQuest.UpdateRepopFlagImpl "..questListInfo.name.." setting repop true")
        end--<
        gvars.qst_questRepopFlag[TppDefine.QUEST_INDEX[questListInfo.name]]=true
      end
      local CanActiveQuest=canActiveQuestChecks[questListInfo.name]
      if CanActiveQuest and(not CanActiveQuest(questListInfo.name))then--tex NMC if CanActiveQuest() false, tex added questName param to CanActiveQuest
        if this.debugModule then--tex>
          InfCore.Log("InfQuest.UpdateRepopFlagImpl "..questListInfo.name.." not CanActiveQuest() so setting repop false")
        end--<
        gvars.qst_questRepopFlag[TppDefine.QUEST_INDEX[questListInfo.name]]=false
      end--if not CanQuest
    end--for infoList
  end,locationQuests)--tex pcall wrap
end--UpdateRepopFlagImpl
function this.CheckAllClearBounus()
  if gvars.qst_allQuestCleared then
    TppTrophy.UnlockOnAllQuestClear()
    return
  end
  local allCleared=true
  for n,questInfo in ipairs(questInfoTable)do
    local questName=questInfo.questName
    local questIndex=TppDefine.QUEST_INDEX[questName]
    if not gvars.qst_questClearedFlag[questIndex]then
      allCleared=false
      break
    end
  end
  if allCleared then
    gvars.qst_allQuestCleared=true
    TppTrophy.UnlockOnAllQuestClear()
    TppHero.SetAndAnnounceHeroicOgrePoint(TppHero.QUEST_ALL_CLEAR)
  end
end
function this.CalcQuestClearedCount()
  local clearedCount=0
  local totalCount=0
  for n,questInfo in ipairs(questInfoTable)do
    local questName=questInfo.questName
    local questIndex=TppDefine.QUEST_INDEX[questName]
    --tex quest_addonsCountForCompletion>
    local isIHQuest=InfQuest~=nil and InfQuest.ihQuestsInfo[questName]~=nil
    local addonsCountForCompletion=Ivars.quest_addonsCountForCompletion:Is(1)
    if not isIHQuest or (isIHQuest and addonsCountForCompletion) then
      --<
      if gvars.qst_questClearedFlag[questIndex]then
        clearedCount=clearedCount+1
      end
      totalCount=totalCount+1
    end
  end
  return clearedCount,totalCount
end
function this.CheckAllClearMineQuest()
  if gvars.qst_allQuestCleared then
    TppTrophy.Unlock(16)
    return
  end
  local allCleared=true
  for questName,n in pairs(TppDefine.REMOVAL_TROPHY_QUEST)do
    local isCleared=gvars.qst_questClearedFlag[TppDefine.QUEST_INDEX[questName]]
    if not isCleared then
      allCleared=false
      break
    end
  end
  if allCleared then
    TppTrophy.Unlock(16,TppHero.MINE_QUEST_ALL_CLEAR.heroicPoint,TppHero.MINE_QUEST_ALL_CLEAR.ogrePoint)
  end
end
--tex NMC gates most of UpdateActiveQuest
function this.NeedUpdateActiveQuest(updateFlags)
  if not this.CanOpenSideOpsList()then
    return false
  end
  if not TppMission.IsMissionStart()then
    InfCore.Log"TppQuest.NeedUpdateActiveQuest false: not IsMissionStart"--DEBUGNOW
    return false
  end

  if TppMission.IsStoryMission(vars.missionCode) and (not InfMissionQuest.IsAnyMissionQuest()) then--tex added IsAnyMissionQuest
    InfCore.Log"TppQuest.NeedUpdateActiveQuest false: IsStoryMission"--DEBUGNOW
    return false
  end

  return true
end
function this.CanOpenSideOpsList()
  if TppMission.IsFOBMission(vars.missionCode)then
    return false
  end
  local clearMissions={10033,10036,10043}
  return(TppStory.GetClearedMissionCount(clearMissions)>=1)or(gvars.str_storySequence>TppDefine.STORY_SEQUENCE.CLEARD_TO_MATHER_BASE)
end
function this.StartElapsedEvent(countDown)
  gvars.qst_elapseCount=countDown
end
function this.GetElapsedCount()--RETAILPATCH: 1060
  return gvars.qst_elapseCount
end--
function this.IsNowOccurringElapsed()
  return gvars.qst_elapseCount==TppDefine.ELAPSED_QUEST_COUNT.NOW_OCCURRING
end
function this.SetDoneElapsed()
  gvars.qst_elapseCount=TppDefine.ELAPSED_QUEST_COUNT.DONE_EVENT
end
local skipQuests={waterway_q99010=true,waterway_q99012=true,sovietBase_q99020=true}
function this.DecreaseElapsedClearCount(questName)
  if gvars.qst_elapseCount<=1 then
    if not Tpp.IsNotAlert()then
      return
    end
    if not TppMission.IsFreeMission(vars.missionCode)then
      return
    end
  end
  if skipQuests[questName]then
    return
  end
  if gvars.qst_elapseCount>TppDefine.ELAPSED_QUEST_COUNT.NOW_OCCURRING then
    gvars.qst_elapseCount=gvars.qst_elapseCount-1
  end
end
function this.PlayClearRadio(clearSideOpsName)
  if Tpp.IsNotAlert()then
    local playName=TppStory.GetForceMBDemoNameOrRadioList("clearSideOps",{clearSideOpsName=clearSideOpsName})
    if playName then
      TppRadio.Play(playName)
      return true
    end
  end
  return false
end
function this.GetClearKeyItem(questName)
  for itemQuestName,dataBaseId in pairs(keyItems)do
    if itemQuestName==questName then
      TppTerminal.AcquireKeyItem{dataBaseId=dataBaseId,isShowAnnounceLog=true}
      for photoQuestName,photoLangId in pairs(questPhotos)do
        if itemQuestName==photoQuestName then
          TppUI.ShowAnnounceLog("quest_get_photo",photoLangId)
        end
      end
    end
  end
end
function this.GetClearEmblem(questName)
  local emblems=questEmblems[questName]
  if emblems then
    for i,emblem in ipairs(emblems)do
      TppEmblem.Add(emblem,false,true)
    end
  end
end
function this.GetClearCassette(questName)
  local cassetteQuests={"outland_q20913","lab_q20914","tent_q20910","sovietBase_q20912","fort_q20911"}
  local cassetes={{"tp_m_10160_06"},{"tp_m_10160_07"},{"tp_m_10160_08"},{"tp_m_10160_09","tp_m_10160_10"}}
  if(((questName=="outland_q20913"or questName=="lab_q20914")or questName=="tent_q20910")or questName=="sovietBase_q20912")or questName=="fort_q20911"then
    local completedCasseteQuests=0
    for i,questName in ipairs(cassetteQuests)do
      if this.IsCleard(questName)then
        completedCasseteQuests=completedCasseteQuests+1
      end
    end
    local cassetteList=cassetes[completedCasseteQuests]
    if cassetteList then
      TppCassette.Acquire{cassetteList=cassetteList,isShowAnnounceLog=true}
    end
  elseif questName=="sovietBase_q99030"then
    TppCassette.Acquire{cassetteList={"tp_m_10150_20","tp_m_10150_29","tp_m_10150_30"},isShowAnnounceLog=true}
  elseif questName=="tent_q99040"then
    TppCassette.Acquire{cassetteList={"tp_m_10150_21","tp_m_10150_22","tp_m_10150_24","tp_m_10150_25"},isShowAnnounceLog=true}
  end
end
function this.ShowAnnounceLog(status,questName,questCurrentCount,questTotalCount)
  if not status then
    return
  end
  if status==QUEST_STATUS_TYPES.OPEN then
    TppUI.ShowAnnounceLog"quest_list_update"
    TppUI.ShowAnnounceLog"quest_add"
  elseif status==QUEST_STATUS_TYPES.CLEAR then
    if not questName then
      return
    end
    local questNameLangId=this.GetQuestNameLangId(questName)
    if questNameLangId~=false then
      local showAnnounceLogId=this.questCompleteLangIds[questName]
      local enemyTargetsComplete,enemyTargetsTotal=TppEnemy.GetQuestCount()
      local shotTargetsCount,shotTargetsTotal=TppGimmick.GetQuestShootingPracticeCount()
      --tex TODO Refactor, combine with other call to GetQuestCount, add TppAnimal.GetQuestCount support
      if showAnnounceLogId then
        if enemyTargetsComplete>1 then
          TppUI.ShowAnnounceLog(showAnnounceLogId,enemyTargetsComplete,enemyTargetsTotal)
        elseif shotTargetsCount>1 then
          TppUI.ShowAnnounceLog(showAnnounceLogId,shotTargetsCount,shotTargetsTotal)
        end
      end
      TppUI.ShowAnnounceLog"quest_list_update"
      TppUI.ShowAnnounceLog("quest_complete",questNameLangId)
      local questNameId=this.GetQuestNameId(questName)
      if(questNameId~=false)and(questNameId~="q99012")then
        TppUiCommand.ShowSideFobInfo("end",string.format("name_%s",questNameId),"hud_quest_finish")
        TppSoundDaemon.PostEvent"sfx_s_sideops_sted"
      end
    end
  elseif status==QUEST_STATUS_TYPES.FAILURE then
    if not questName then
      return
    end
    local questNameLangId=this.GetQuestNameLangId(questName)
    if questNameLangId~=false then
      TppUI.ShowAnnounceLog"quest_list_update"
      TppUI.ShowAnnounceLog("quest_delete",questNameLangId)
    end
  elseif status==QUEST_STATUS_TYPES.UPDATE then
    if not questName then
      return
    end
    local showAnnounceLogId=this.questCompleteLangIds[questName]
    if showAnnounceLogId then
      TppUI.ShowAnnounceLog(showAnnounceLogId,questCurrentCount,questTotalCount)
    end
  end
end
function this.IsRandomFaceQuestName(questName)
  if questName==nil then
    questName=this.GetCurrentQuestName()
    if questName==nil then
      return
    end
  end
  local faceIndex=TppDefine.QUEST_RANDOM_FACE_INDEX[questName]
  if faceIndex then
    return true
  end
  return false
end
--tex KLUDGE added index
function this.GetRandomFaceId(questName,index)
  if questName==nil then
    questName=this.GetCurrentQuestName()
    if questName==nil then
      return
    end
  end
  --tex support for randomFaceListIH>
  if index then
    local questPackList=TppQuestList.questPackList[questName]
    if questPackList and questPackList.randomFaceListIH then
      if questPackList.faceIdList and #questPackList.faceIdList then
        if this.debugModule then--tex>
          InfCore.Log("TppQuest.GetRandomFaceId: randomFaceListIH faceId for index "..index.." :"..tostring(questPackList.faceIdList[index]))--DEBUG
        end--<
        return questPackList.faceIdList[index]
      else
        InfCore.Log("WARNING: TppQuest.GetRandomFaceId: randomFaceListIH on questPackList but no faceIdList")
      end
    end
  end
  --<
  local questIndex=TppDefine.QUEST_RANDOM_FACE_INDEX[questName]
  if questIndex then
    return gvars.qst_randomFaceId[questIndex]
  end
end
function this.SetRandomFaceId(questName,faceId)
  local questIndex=TppDefine.QUEST_RANDOM_FACE_INDEX[questName]
  if questIndex then
    gvars.qst_randomFaceId[questIndex]=faceId
  end
end
function this.OnQuestAreaAnnounceText(questIdNumber)
  local questName=this.GetQuestName(questIdNumber)
  local radioName
  if questName then
    for radioQuestName,radioInfo in pairs(questRadioList)do
      if radioQuestName==questName then
        if radioInfo.radioNameFirst then
          if radioInfo.radioNameSecond then
            if TppRadio.IsPlayed(radioInfo.radioNameFirst)then
              radioName=radioInfo.radioNameSecond
            else
              radioName=radioInfo.radioNameFirst
            end
          else
            radioName=radioInfo.radioNameFirst
          end
        end
      end
    end
    if radioName~=nil then
      TppRadio.Play(radioName,{delayTime="mid"})
    end
    TppSoundDaemon.PostEvent"sfx_s_sideops_sted"
  end
end
function this.IsActiveQuestHeli()
  for n,questName in ipairs(TppDefine.QUEST_HELI_DEFINE)do
    if this.IsActive(questName)then
      return true
    end
  end
  return false
end
-- NMC: messages for trap_preDeactiveQuestArea_<areaName> traps in <missionCode>_sequence.fox2
--tex REWORKED to support addons
function this.DeactiveQuestAreaTrapMessages()
  if Ivars.quest_useAltForceFulton:Get()==1 then--tex>
    return {}
  end--<
  local deactiveQuestAreaTrapMessages={}
  if (TppMission.IsFreeMission(vars.missionCode) or (TppMission.IsStoryMission(vars.missionCode) and InfMissionQuest.IsAnyMissionQuest())) and not TppMission.IsMbFreeMissions(vars.missionCode) then--tex added IsAnyMissionQuest check TODO: use CanActiveQuestInMission instead of IsAnyMission? TODO rethink, enable for wargames?
    for i,areaInfo in ipairs(TppQuestList.questList)do
      if areaInfo.locationId==vars.locationCode then
        local trapName=this.GetTrapName(areaInfo.areaName)
        local message={msg="Exit",sender=trapName,
          func=function(trapNameS32,gameId)
            TppEnemy.CheckDeactiveQuestAreaForceFulton()
          end}
        table.insert(deactiveQuestAreaTrapMessages,message)     
      end--if locationId
    end--for questList
  end--if isfreemission
  return deactiveQuestAreaTrapMessages
end--DeactiveQuestAreaTrapMessages
--ORIG
--function this.DeactiveQuestAreaTrapMessages()
--  local deactiveQuestAreaTrapMessages={}
--  local areaList={}
--  local missionCode=TppMission.GetMissionID()
--  --RETAILBUG: this means wont fire for sideops in story missions, but there only seems to be one sideop active during them anyway (see CanActiveQuestInMission)
--  if missionCode==30010 then
--    areaList=afgAreaList
--  elseif missionCode==30020 then
--    areaList=mafrAreaList
--  else
--    return
--  end
--  for i,areaName in ipairs(areaList)do
--    local trapName=this.GetTrapName(areaName)
--    local message={msg="Exit",sender=trapName,
--      func=function(trapNameS32,gameId)
--        TppEnemy.CheckDeactiveQuestAreaForceFulton()
--      end}
--    table.insert(deactiveQuestAreaTrapMessages,message)
--  end
--  return deactiveQuestAreaTrapMessages
--end
function this.GetTrapName(areaName)
  return"trap_preDeactiveQuestArea_"..areaName
end
function this._ChangeToEnable(instanceName,makerType,gameObjectId,identificationCode)
  if identificationCode==StrCode32"Player"and this.IsInvoking()then
    local isEnemyQuestTarget=TppEnemy.IsQuestTarget(gameObjectId)
    local isGimmickQuestTarget=TppGimmick.IsQuestTarget(gameObjectId)
    local isAnimalQuestTarget=TppAnimal.IsQuestTarget(gameObjectId)
    if(isEnemyQuestTarget or isGimmickQuestTarget)or isAnimalQuestTarget then
      TppSoundDaemon.PostEvent"sfx_s_enemytag_quest_tgt"
      if mvars.qst_isRadioTarget==false then
        local currentQuestName=this.GetCurrentQuestName()
        if(((currentQuestName=="tent_q20910"or currentQuestName=="fort_q20911")or currentQuestName=="sovietBase_q20912")or currentQuestName=="outland_q20913")or currentQuestName=="lab_q20914"then
          TppRadio.Play("f2000_rtrg8330",{delayTime="short"})
        else
          TppRadio.Play("f1000_rtrg2180",{delayTime="short"})
        end
        mvars.qst_isRadioTarget=true
      end
    end
  end
end
--CALLER: quest script msg QuestStarted
function this.SetQuestShootingPractice()
  TppSoundDaemon.PostEvent"sfx_s_training_ready_go"
  GkEventTimerManager.Start("TimerShootingPracticeStart",3.5)
  this.StopTimer"TimerShootingPracticeRetryConfirm"
  if Ivars.quest_enableShootingPracticeRetry:Is(0) then--tex--tex added bypass
    this.HideShootingPracticeStartUi()
  end
  mvars.qst_isShootingPracticeStarted=true
  GameObject.SendCommand({type="TppHeli2",index=0},{id="PullOut"})
end
--CALLER: TimerShootingPracticeStart -^
function this.StartShootingPractice()
  this.UpdateShootingPracticeUi()
  InfShootingPractice.OverrideShootingPracticeTime()--tex
  TppUiCommand.StartDisplayTimer(mvars.gim_questDisplayTimeSec,mvars.gim_questCautionTimeSec)
  TppGimmick.StartQuestShootingPractice()
  TppGimmick.SetQuestSootingTargetInvincible(false)
  --tex REWORKED
  if mvars.snd_bgmList and mvars.snd_bgmList.bgm_shooting_range then
    TppSound.SetSceneBGM("bgm_shooting_range")
  end
  --ORIG --f30050_sound.SetScene_ShootingRange()
  TppSoundDaemon.PostEvent"sfx_m_tra_tgt_get_up_alot"
  Player.SetInfiniteAmmoFromScript(true)
end
function this.OnFinishShootingPractice(clearType,canceled)
  if clearType or canceled then
    this.ProcessFinishShootingPractice(clearType,canceled)
  end
  Player.SetInfiniteAmmoFromScript(false)
  mvars.qst_isShootingPracticeStarted=false
end
function this.IsShootingPracticeStarted()
  if not mvars.qst_isShootingPracticeStarted then
    return false
  end
  return true
end
function this.IsShootingPracticeActivated()
  if not mvars.isShootingPracticeQuestActivated then
    return false
  end
  return true
end
function this.ProcessFinishShootingPractice(clearType,canceled)
  this.UpdateShootingPracticeUi()
  TppUiStatusManager.SetStatus("DisplayTimer","STOP_VISIBLE")
  this.StartSafeTimer("TimerShootingPracticeEnd",8)
  TppSound.StopSceneBGM()
  if mvars.isShootingPracticeInMedicalStopMusicFromQuietRoom==true then
    f30050_sequence.PlayMusicFromQuietRoom()
    mvars.isShootingPracticeInMedicalStopMusicFromQuietRoom=false
  end
  if canceled then
    TppGimmick.EndQuestShootingPractice(TppDefine.QUEST_CLEAR_TYPE.SHOOTING_RETRY)
    TppGimmick.SetQuestShootingPracticeTargetInvisible()
  else
    TppGimmick.EndQuestShootingPractice(clearType)
    if mvars.qst_deactivated==false then
      if vars.playerVehicleGameObjectId==GameObject.NULL_ID then
        TppPlayer.PlayMissionClearCameraOnFoot(2,true)
      end
      if clearType==TppDefine.QUEST_CLEAR_TYPE.SHOOTING_CLEAR then
        TppMusicManager.PostJingleEvent("SingleShot","Play_bgm_training_jingle_clear")
        TppGimmick.SetQuestShootingPracticeTargetInvisible()
      else
        TppMusicManager.PostJingleEvent("SingleShot","Play_bgm_training_jingle_failed")
        this.StartSafeTimer("TimerShootingPracticeRetryConfirm",60)
        TppGimmick.SetQuestSootingTargetInvincible(true)
      end
    end
  end
end
function this.CancelShootingPractice()
  local currentQuestName=this.GetCurrentQuestName()
  this.ShowAnnounceLog(QUEST_STATUS_TYPES.FAILURE,currentQuestName)
  this.OnFinishShootingPractice(nil,true)
  this.ShootingPracticeStopAllTimer()
  this.OnQuestShootingTimerEnd()
  this.SetCancelShootingPracticeStartUi()
end
function this.StartSafeTimer(timerName,time)
  this.StopTimer(timerName)
  GkEventTimerManager.Start(timerName,time)
end
function this.StopTimer(timerName)
  if GkEventTimerManager.IsTimerActive(timerName)then
    GkEventTimerManager.Stop(timerName)
  end
end
function this.ShootingPracticeStopAllTimer()
  this.StopTimer"TimerShootingPracticeEnd"
  this.StopTimer"TimerShootingPracticeRetryConfirm"
  this.StopTimer"TimerShootingPracticeStart"
end
function this.OnQuestShootingTimerEnd()
  TppUiStatusManager.UnsetStatus("DisplayTimer","STOP_VISIBLE")
  TppUiCommand.EraseDisplayTimer()
end
--CALLERS: Quest script OnActivate, TppQuest.SetRetryShootingPracticeStartUi
--NMC: tex: shooting practice start marker system is a bit of a mess, the locators are loaded by mission pack (layout pack), so all the known markers are hidden on current shooting quest activate
--further more the ground ui 'mb stage spot' is relocated using offset from plat pos, (but the icon marker above it isnt?)
--tex so trying to expand this further without having to mod the vanilla stuff
--tex added markerName, and assumes startUiPosition is absolute if offsetType is nil
function this.ShowShootingPracticeStartUi(offsetType,startUiPosition,markerName)
  this.ShowShootingPracticeGroundUi(offsetType,startUiPosition)
  this.ShowShootingPracticeMarker(offsetType,markerName)
end
--CALLERS: ShowShootingPracticeStartUi ^, SetCancelShootingPracticeStartUi (called with nil params)
function this.ShowShootingPracticeGroundUi(offsetType,startUiPosition)
  mvars.qst_shootingPracticeStartUiPos=startUiPosition or mvars.qst_shootingPracticeStartUiPos
  mvars.qst_shootingPracticeOffsetType=offsetType or mvars.qst_shootingPracticeOffsetType

  if mvars.qst_shootingPracticeOffsetType==nil then--tex> using startUiPos instead if no offsetType so it can be used in other locations than mtbs
    local pos=mvars.qst_shootingPracticeStartUiPos or {0,0,0}
    TppUiCommand.SetMbStageSpot("show",Vector3(pos[1],pos[2],pos[3]))
  else--<
  local pos,rotY=mtbs_cluster.GetPosAndRotY(mvars.qst_shootingPracticeOffsetType,"plnt0",mvars.qst_shootingPracticeStartUiPos,0)
  TppUiCommand.SetMbStageSpot("show",Vector3(pos[1],pos[2],pos[3]))
end
end
--CALLERS: ShowShootingPracticeStartUi ^, Quest script LandingFromHeli
--tex added markerName
function this.ShowShootingPracticeMarker(offsetType,markerName)
  if offsetType then
    for clusterName,locatorName in pairs(shootingPracticeMarkers)do
      if clusterName~=offsetType then
        TppMarker.Disable(locatorName)
      else
        mvars.qst_shootingPracticeMarkerName=locatorName or mvars.qst_shootingPracticeMarkerName
      end
    end
  end
  if markerName then--tex> DEBUGNOW
    for clusterName,locatorName in pairs(shootingPracticeMarkers)do
      if locatorName~=markerName then
        TppMarker.Disable(locatorName)
      end
    end 
    mvars.qst_shootingPracticeMarkerName=markerName or mvars.qst_shootingPracticeMarkerName
  end--<
  if Tpp.IsHelicopter(vars.playerVehicleGameObjectId)then
    return
  end
  if mvars.qst_shootingPracticeMarkerName then
    TppMarker.Enable(mvars.qst_shootingPracticeMarkerName)
  end
end
function this.HideShootingPracticeStartUi()
  TppUiCommand.SetMbStageSpot"hide"
  this.HideShootingPracticeMarker()
end
function this.HideShootingPracticeMarker()
  if mvars.qst_shootingPracticeMarkerName then
    TppMarker.Disable(mvars.qst_shootingPracticeMarkerName)
  end
end
function this.OnDeactivateShootingPracticeForUi()
  this.HideAllShootingPracticeForUi()
end
function this.ClearShootingPracticeMvars()
  mvars.qst_shootingPracticeStartUiPos=nil
  mvars.qst_shootingPracticeOffsetType=nil
  mvars.qst_shootingPracticeMarkerName=nil
  mvars.qst_isShootingPracticeStarted=false
end
function this.HideAllShootingPracticeForUi()
  for clusterName,locatorName in pairs(shootingPracticeMarkers)do
    local gameId=GameObject.GetGameObjectId(locatorName)
    if gameId~=GameObject.NULL_ID then
      TppMarker.Disable(locatorName)
    end
  end
end
function this.SetRetryShootingPracticeStartUi()
  this.ShowShootingPracticeStartUi()
  TppPlayer.ResetIconForQuest"ShootingPractice"
end
function this.SetCancelShootingPracticeStartUi()
  this.ShowShootingPracticeGroundUi()
  TppPlayer.ResetIconForQuest"ShootingPractice"
end
function this.UpdateShootingPracticeUi()
  local questMarkCount,questMarkTotalCount=TppGimmick.GetQuestShootingPracticeCount()
  TppUiCommand.SetDisplayTimerText("time_quest",questMarkCount,questMarkTotalCount)
end
--RETAILPATCH: 1060 big additions to below
local designAquireInfo={
  ruins_q60115=TppMotherBaseManagementConst.DESIGN_2027,
  sovietBase_q60110=TppMotherBaseManagementConst.DESIGN_2020,
  citadel_q60112=TppMotherBaseManagementConst.DESIGN_2021,
  outland_q60113=TppMotherBaseManagementConst.DESIGN_2022,
  pfCamp_q60114=TppMotherBaseManagementConst.DESIGN_2023,
  sovietBase_q60111=TppMotherBaseManagementConst.DESIGN_2024
}
local animalAquireInfo={
  pfCamp_q39012={dataBaseId=TppMotherBaseManagementConst.ANIMAL_130},
  waterway_q39010={dataBaseId=TppMotherBaseManagementConst.ANIMAL_610},
  lab_q39011={dataBaseId=TppMotherBaseManagementConst.ANIMAL_2250}
}
function this.AcquireKeyItemOnMissionStart()
  for questName,dataBaseId in pairs(keyItems)do
    if this.IsCleard(questName)then
      TppTerminal.AcquireKeyItem{dataBaseId=dataBaseId,isShowAnnounceLog=true}
    end
  end
  if TppStory.IsMissionCleard(11050)then
    TppTerminal.AcquireKeyItem{dataBaseId=TppMotherBaseManagementConst.DESIGN_3014,pushReward=true}
    TppTerminal.AcquireKeyItem{dataBaseId=TppMotherBaseManagementConst.DESIGN_3015,pushReward=true}
  end
  if TppDemo.IsPlayedMBEventDemo"DecisionHuey"then
    TppTerminal.AcquireKeyItem{dataBaseId=TppMotherBaseManagementConst.DESIGN_3007,pushReward=true}
  end
  if TppStory.IsMissionCleard(10280)then
    TppTerminal.AcquireKeyItem{dataBaseId=TppMotherBaseManagementConst.DESIGN_3008,pushReward=true}
    TppTerminal.AcquireKeyItem{dataBaseId=TppMotherBaseManagementConst.DESIGN_3010,pushReward=true}
  end
  if TppStory.IsMissionCleard(10100)then
    TppTerminal.AcquireKeyItem{dataBaseId=TppMotherBaseManagementConst.DESIGN_3013,pushReward=true}
  end
  if this.IsCleard"mtbs_q99060"then
    TppTerminal.AcquireKeyItem{dataBaseId=TppMotherBaseManagementConst.PHOTO_1010,pushReward=true}
  end
  for questName,dataBaseId in pairs(designAquireInfo)do
    if this.IsCleard(questName)then
      TppTerminal.AcquireKeyItem{dataBaseId=dataBaseId,isShowAnnounceLog=true}
    end
  end
  for questName,info in pairs(animalAquireInfo)do
    if this.IsCleard(questName)and not TppMotherBaseManagement.IsGotDataBase{dataBaseId=info.dataBaseId}then
      TppMotherBaseManagement.DirectAddDataBaseAnimal{dataBaseId=info.dataBaseId,areaName=info.areaName,isNew=true}
    end
  end
  if TppUiCommand.HasEmblemTexture"front5019"then
    TppTerminal.AcquireKeyItem{dataBaseId=428,isShowAnnounceLog=true}
  end

  if this.IsCleard"ruins_q19010"then
    vars.isRussianTranslatable=1
  end
  if this.IsCleard"outland_q19011"then
    vars.isAfrikaansTranslatable=1
  end
  if this.IsCleard"hill_q19012"then
    vars.isKikongoTranslatable=1
  end
  if this.IsCleard"commFacility_q19013"then
    vars.isPashtoTranslatable=1
  end
  if this.IsCleard"tent_q99072"then
    vars.mbmMasterGunsmithSkill=1
  end
  do
    local cassetteAquireInfo={
      {questName="mtbs_q99060",cassetteList={"tp_m_99060_01","tp_m_99060_02","tp_m_99060_03","tp_m_99060_04","tp_m_99060_05","tp_sp_01_03"}},
      {questName="sovietBase_q99030",cassetteList={"tp_m_10150_20","tp_m_10150_29","tp_m_10150_30"}},
      {questName="tent_q99040",cassetteList={"tp_m_10150_21","tp_m_10150_22","tp_m_10150_24","tp_m_10150_25"}},
      {questName="mtbs_q99011",cassetteList={"tp_c_00000_13","tp_m_10050_03"}},
      {storySequence=TppDefine.STORY_SEQUENCE.CLEARD_RESCUE_HUEY,cassetteList={"tp_m_10050_01"}},
      {storySequence=TppDefine.STORY_SEQUENCE.CLEARD_FLAG_MISSIONS_BEFORE_ENDRESS_PROXY_WAR,cassetteList={"tp_m_10160_06","tp_m_10160_07","tp_m_10160_08","tp_m_10160_09","tp_m_10160_10","tp_m_10160_05"}},
      {storySequence=TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS,cassetteList={"tp_m_10160_11","tp_m_10160_04","tp_c_00000_18","tp_m_10240_05","tp_m_10190_02","tp_m_10190_03"}},
      {demoName="DecisionHuey",cassetteList={"tp_m_10190_05","tp_m_10190_06","tp_m_10240_03","tp_m_10240_04","tp_m_10190_01"}}
    }
    for i,info in pairs(cassetteAquireInfo)do
      if((info.questName and this.IsCleard(info.questName))
        or(info.storySequence and(TppStory.GetCurrentStorySequence()>=info.storySequence)))
        or(info.demoName and TppDemo.IsPlayedMBEventDemo(info.demoName))then
        TppCassette.Acquire{cassetteList=info.cassetteList,isShowAnnounceLog=true}
      end
    end
  end
  do
    local uniqueTypeId=110
    if this.IsCleard"cliffTown_q99080"and not TppMotherBaseManagement.IsExistStaff{uniqueTypeId=uniqueTypeId}then
      local staffId=TppMotherBaseManagement.GenerateStaffParameter{staffType="Unique",uniqueTypeId=uniqueTypeId}
      TppMotherBaseManagement.DirectAddStaff{staffId=staffId}
    end
    local uniqueTypeId=111
    if this.IsCleard"quest_q20095"and not TppMotherBaseManagement.IsExistStaff{uniqueTypeId= uniqueTypeId}then
      local staffId=TppMotherBaseManagement.GenerateStaffParameter{staffType="Unique",uniqueTypeId=uniqueTypeId}
      TppMotherBaseManagement.DirectAddStaff{staffId=staffId}
      TppMotherBaseManagement.SetLockedTanFlag{locked=false}
    end
  end
  do
    for questName,emblems in pairs(questEmblems)do
      if this.IsCleard(questName)then
        this.GetClearEmblem(questName)
      end
    end
  end
end
return this
