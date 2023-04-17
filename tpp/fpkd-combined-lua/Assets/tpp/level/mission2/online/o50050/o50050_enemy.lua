-- DOBUILD: 0 --WIP EXPERIMENT, search EXP, revert/cleanup before use
-- ORIGINALQAR: chunk3
-- PACKPATH: \Assets\tpp\pack\mission2\online\o50050\o50050_additional.fpkd
-- o50050_enemy.lua
--DEBUGNOW check to see if your undefined NULL_ID is something you fsked up, compare with vanilla

local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}

local TIME_CHECK_FOCUS_AREA = 1*60	

local TIMER_NAME_CHECK_FOCUS_AREA = "CheckFocusArea"
local TIMER_NAME_PERMIT_SEARCHING_DEFENDER = "PermitSearchingDefender"

local NUM_MEMBER_MIN = 2
local NUM_MEMBER_MAX = 4

local GDTGT_MEMBER_LIST = {
	{	
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
	},
	{	
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
	},
	{	
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
	},
	{	
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
	},
	{	
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
	},
	{	
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
	},
	{	
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
		{ min = NUM_MEMBER_MIN, MAX = NUM_MEMBER_MAX },
	},
}


local ANYWHARE_CAMERA_LIST = {
	"AnyWhere_SecurityCameraLocator001",
	"AnyWhere_SecurityCameraLocator002",
	"AnyWhere_SecurityCameraLocator003",
	"AnyWhere_SecurityCameraLocator004",
}


this.PARASITE_NAME_LIST = {
	"Parasite0",
	"Parasite1",
	"Parasite2",
	"Parasite3",
}


local PARASITE_PARAM = {
	HARD = {
		sightDistance = 30,
		sightVertical = 55.0,
		sightHorizontal = 48.0,
	},
}




this.HOSTAGE_NAME_LIST = {
	"hos_o50050_event5_0000",
	"hos_o50050_event5_0001",
	"hos_o50050_event5_0002",
	"hos_o50050_event5_0003",
}


this.EVENT_HOSTAGE_POS_LIST = {
	
	ocean_area_0 = {	
		{	
			
			{ 22.689, 8.000, 3.315 }, { -30.212, -4.000, 119.651 }, { -59.733, -1.000, 244.211 }, { 26.202, 7.983, 326.453 },
		},
		{	
			{ -911.630, 4.002, 585.917 }, { -1019.922, -0.000, 658.446 }, { -1106.714, 0.000, 711.625 }, { -1200.333, 11.983, 823.313 },
		},
		{	
			{ 188.840, 12.000, -798.991 }, { 194.307, 3.978, -920.854 }, { 106.018, -4.000, -1021.523 }, { 179.169, -8.000, -1087.473 },
		},
		{	
			{ 679.553, 3.985, 940.273 }, { 667.664, -4.000, 1063.893 }, { 760.794, 0.000, 1169.939 }, 	{ 779.991, 7.996, 1407.408 },
		},
		{	
			{ 916.451, -4.000, 104.647 }, { 1028.942, 11.983, 90.717 }, { 1101.371, -4.000, 9.835 }, { 1113.730, 0.000, -97.688 },
		},
		{	
			{ -810.086, 15.963, -445.304 }, { -926.548, 4.000, -457.802 }, { -960.139, -8.011, -540.167 }, { -1140.334, 4.000, -568.642 },
		},
		{	
			{ -68.152, 0.006, 1224.505 }, { 32.176, 0.000, 1351.197 }, { -54.398, 0.000, 1403.541 }, { -106.019, -1.000, 1517.848 },
		},
	},
	ocean_area_10 = {	
		{	
			
			{ 22.689, 8.000, 3.315 }, { -30.212, -4.000, 119.651 }, { -59.733, -1.000, 244.211 }, { 26.202, 7.983, 326.453 },
		},
		{	
			{ -911.630, 4.002, 585.917 }, { -1019.922, -0.000, 658.446 }, { -1106.714, 0.000, 711.625 }, { -1200.333, 11.983, 823.313 },
		},
		{	
			{ 188.840, 12.000, -798.991 }, { 194.307, 3.978, -920.854 }, { 106.018, -4.000, -1021.523 }, { 179.169, -8.000, -1087.473 },
		},
		{	
			{ 759.063, 3.985, 1047.526 }, { 736.439, -4.000, 1160.734 }, { 818.176, 1.985, 1270.520 }, 	{ 779.991, 7.996, 1407.408 },
		},
		{	
			{ 916.451, -4.000, 104.647 }, { 1028.942, 11.983, 90.717 }, { 1101.371, -4.000, 9.835 }, { 1113.730, 0.000, -97.688 },
		},
		{	
			{ -810.086, 15.963, -445.304 }, { -926.548, 4.000, -457.802 }, { -960.139, -8.011, -540.167 }, { -1140.334, 4.000, -568.642 },
		},
		{	
			{ 18.628, 0.006, 1323.193 }, { 125.354, 3.983, 1434.143 }, { 35.498, 0.000, 1505.072 }, { -106.019, -1.000, 1517.848 },
		},
	},
	ocean_area_20 = {	
		{	
			
			{ 22.689, 8.000, 3.315 }, { -30.212, -4.000, 119.651 }, { -59.733, -1.000, 244.211 }, { 26.202, 7.983, 326.453 },
		},
		{	
			{ -911.630, 4.002, 585.917 }, { -1019.922, -0.000, 658.446 }, { -1106.714, 0.000, 711.625 }, { -1200.333, 11.983, 823.313 },
		},
		{	
			{ 188.840, 12.000, -798.991 }, { 194.307, 3.978, -920.854 }, { 106.018, -4.000, -1021.523 }, { 179.169, -8.000, -1087.473 },
		},
		{	
			{ 759.063, 3.985, 1047.526 }, { 736.439, -4.000, 1160.734 }, { 818.176, 1.985, 1270.520 }, 	{ 779.991, 7.996, 1407.408 },
		},
		{	
			{ 916.451, -4.000, 104.647 }, { 1028.942, 11.983, 90.717 }, { 1101.371, -4.000, 9.835 }, { 1113.730, 0.000, -97.688 },
		},
		{	
			{ -810.086, 15.963, -445.304 }, { -926.548, 4.000, -457.802 }, { -960.139, -8.011, -540.167 }, { -1140.334, 4.000, -568.642 },
		},
		{	
			{ 18.628, 0.006, 1323.193 }, { 125.354, 3.983, 1434.143 }, { 35.498, 0.000, 1505.072 }, { -106.019, -1.000, 1517.848 },
		},
	},
	ocean_area_30 = {	
		{	
			
			{ 7.835, 8.000, 22.217 }, { -113.086, -4.000, -18.880 }, { -211.959, 0.000, -125.738 }, { -193.801, 7.996, -257.238 },
		},
		{	
			{ 844.046, 8.985, 363.815 }, { 932.419, 0.750, 450.140 }, { 1064.081, 3.985, 443.146 }, { 1134.515, -0.000, 552.706 },
		},
		{	
			{ -1050.224, 32.000, 248.767 }, { -1155.083, 0.000, 286.133 }, { -1278.013, 0.985, 305.195 }, { -1397.158, 3.978, 370.733 },
		},
		{	
			{ -489.504, 3.985, 850.955 }, { -505.424, -4.000, 952.957 }, { -608.098, 0.000, 1056.523 }, 	{ -710.697, 3.985, 1111.215 },
		},
		{	
			{ -511.593, 0.000, -1095.840 }, { -575.686, 11.996, -1205.670 }, { -549.770, -8.011, -1295.849 }, { -667.129, 0.000, -1418.469 },
		},
		{	
			{ 514.909, 8.000, 786.919 }, { 584.424, 7.983, 906.840 }, { 589.087, -3.998, 1025.463 }, { 530.336, -4.000, 1147.441 },
		},
		{	
			{ -873.620, 0.000, -840.026 }, { -997.320, 0.000, -845.904 }, { -1144.872, -4.000, -857.855 }, { -1227.919, 11.996, -972.608 },
		},
	},
	ocean_area_40 = {	
		{	
			
			{ -13.635, 4.000, 20.322 }, { -95.405, 0.000, -85.716 }, { -72.032, -4.000, -212.121 }, { 33.268, 0.000, -299.420 },
		},
		{	
			{ 930.916, 8.000, -85.957 }, { 1026.633, -7.998, -11.209 }, { 1091.344, -1.000, 113.356 }, { 1223.049, 0.000, 110.144 },
		},
		{	
			{ -1062.147, 0.000, -231.611 }, { -1203.736, 7.996, -274.715 }, { -1314.980, -0.000, -268.189 }, { -1413.695, 3.985, -191.293 },
		},
		{	
			{ 735.238, 3.985, -1002.432 }, { 872.809, 0.985, -1070.083 }, { 845.549, 0.000, -1194.210 }, 	{ 973.756, 7.996, -1261.784 },
		},
		{	
			{ -656.552, 0.000, -1005.205 }, { -663.464, 0.750, -1151.407 }, { -614.903, 11.983, -1275.549 }, { -727.788, 0.000, -1353.721 },
		},
		{	
			{ -13.263, 8.000, 1018.600 }, { 57.744, -4.000, 1132.040 }, { 53.765, 4.000, 1214.184 }, { 145.392, 0.000, 1330.481 },
		},
		{	
			{ -793.765, 0.000, 603.293 }, { -904.096, 7.983, 683.753 }, { -899.892, -1.000, 807.734 }, { -1024.500, -4.000, 875.017 },
		},
	},
	ocean_area_50 = {	
		{	
			
			{ 22.689, 8.000, 3.315 }, { -132.379, 11.996, -32.448 }, { -210.196, 0.000, 66.022 }, { -337.465, -4.000, 36.321 },
		},
		{	
			{ -533.179, 16.000, 968.392 }, { -550.897, 0.000, 1108.067 }, { -483.141, 3.985, 1200.809 }, { -389.006, -4.000, 1299.342 },
		},
		{	
			{ 199.183, 7.969, -922.458 }, { 216.297, -4.000, -1073.063 }, { 126.743, -1.000, -1144.710 }, { 145.905, 0.000, -1279.611 },
		},
		{	
			{ -1142.123, 3.985, 578.664 }, { -1247.236, 0.000, 618.744 }, { -1339.535, 11.996, 695.626 }, 	{ -1338.849, -4.000, 836.084 },
		},
		{	
			{ -1269.716, 8.000, -132.810 }, { -1377.425, -1.000, -72.338 }, { -1458.651, 3.998, 5.960 }, { -1457.036, 0.000, 139.577 },
		},
		{	
			{ 790.713, 15.963, -541.663 }, { 913.271, 0.000, -526.109 }, { 1023.235, 3.985, -607.320 }, { 1111.086, 3.985, -682.576 },
		},
		{	
			{ 914.279, 0.000, 191.377 }, { 1023.581, 3.983, 293.011 }, { 1076.171, 7.996, 413.024 }, { 1201.766, 3.950, 420.283 },
		},
	},
	ocean_area_60 = {	
		{	
			
			{ 21.601, 16.000, 6.068 }, { -87.245, -0.000, -94.961 }, { -209.007, -4.000, -102.240 }, { -293.933, 0.000, -8.475 },
		},
		{	
			{ 786.329, 12.000, 498.101 }, { 896.389, 11.996, 527.455 }, { 1016.711, -4.000, 559.832 }, { 1105.908, -1.000, 628.525 },
		},
		{	
			{ 191.918, 28.035, 966.121 }, { 253.548, -1.000, 1021.465 }, { 232.507, 3.985, 1155.866 }, { 296.839, -4.000, 1255.406 },
		},
		{	
			{ -1192.152, 8.000, 295.228 }, { -1279.162, 0.000, 279.026 }, { -1400.880, 11.996, 369.112 }, 	{ -1514.452, -0.000, 335.196 },
		},
		{	
			{ -677.810, 0.004, 810.676 }, { -798.986, 7.996, 883.045 }, { -870.978, 0.000, 961.244 }, { -880.541, -1.000, 1094.072 },
		},
		{	
			{ -564.867, 15.963, -975.118 }, { -592.882, -8.011, -1065.834 }, { -704.979, -4.000, -1176.232 }, { -684.383, -4.000, -1291.419 },
		},
		{	
			{ 260.905, 12.000, -976.574 }, { 303.285, 0.000, -1086.512 }, { 406.973, 0.000, -1162.723 }, { 395.407, 7.996, -1292.956 },
		},
	},
	
	ocean_area_70 = {	
		{	
			
			{ 22.845, 8.000, 3.328 }, { 132.817, -4.000, -12.232 }, { 241.104, 0.000, -1.038 }, { 337.523, 7.996, 47.690 },
		},
		{	
			{ 1029.168, 8.985, -490.120 }, { 1146.438, 3.983, -590.458 }, { 1125.548, 0.000, -713.318 }, { 1244.932, -1.000, -785.337 },
		},
		{	
			{ 1011.365, 0.000, 557.098 }, { 1130.686, 4.000, 595.854 }, { 1219.826, 11.996, 694.443 }, { 1304.615, -4.000, 783.294 },
		},
		{	
			{ -1031.509, 3.985, -14.640 }, { -1106.935, -4.000, -127.861 }, { -1197.585, 7.996, -112.951 }, 	{ -1334.352, -0.000, -127.384 },
		},
		{	
			{ -689.193, 8.000, 533.381 }, { -777.287, 0.000, 589.194 }, { -905.718, -4.000, 606.840 }, { -1018.105, -0.000, 549.921 },
		},
		{	
			{ -686.756, 15.963, -543.646 }, { -759.602, 3.985, -632.099 }, { -887.936, 7.996, -660.224 }, { -950.881, -4.000, -731.199 },
		},
		{	
			{ 1349.457, 0.000, 46.561 }, { 1450.027, -1.000, 159.424 }, { 1582.102, -4.000, 160.583 }, { 1679.038, 3.985, 196.066 },
		},
	},
}





this.soldierDefine = {}




this.soldierSubTypes = {}


this.routeSets = {}


this.GetRouteSetPriority = nil


this.combatSetting = {}


this.interrogation = {
	
}






 
this.SetMarkerOnDefence = function()
	Fox.Log("*** SetMarkerOnDefence *** ")

	
	Fox.Log("######## SetMarkerOnSoldier ########")
	for _, plntName in ipairs( mtbs_enemy.plntNameDefine ) do
		
		for idx = 1, table.getn(this.soldierDefine[mtbs_enemy.cpNameDefine]) do

			TppMarker2System.EnableMarker{
				gameObjectId = GameObject.GetGameObjectId( this.soldierDefine[mtbs_enemy.cpNameDefine][idx] ),
			}
		end
	end
end


 
this.SetFriendly = function()
	Fox.Log("*** SetFriendly *** ")
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local command = { id="SetFriendly" }

	
	SendCommand( { type="TppSoldier2"}, command )

	
	for _, plntName in ipairs( mtbs_enemy.plntNameDefine ) do
		
		local plntTable = mtbs_enemy.plntParamTable[plntName]
		local plntAssetsTable = plntTable.assets
		
		for i, uavName in ipairs( plntAssetsTable.uavList ) do
			local gameObjectId = GameObject.GetGameObjectId( uavName )
			SendCommand( gameObjectId, {id = "SetFriendly"} )
		end
	end

	
	SendCommand( { type="TppSecurityCamera2"}, command )
end

 
this.SetSaluteMoraleDisableAll = function()
	Fox.Log("*** SetSaluteMoraleDisable *** ")
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local command = { id="SetSaluteMoraleDisable", enabled=true }
	for idx = 1, table.getn(this.soldierDefine[mtbs_enemy.cpNameDefine]) do
		local gameObjectId = GetGameObjectId("TppSoldier2", this.soldierDefine[mtbs_enemy.cpNameDefine][idx])
		if gameObjectId ~= NULL_ID then--RETAILBUG: should be GameObject.NULL_ID, or localopt to NULL_ID
			SendCommand( gameObjectId, command )
		end
	end
end



this.isAnihilatedFOB = function()
	Fox.Log("*** isAnihilatedFOB *** ")

	for idx = 1, table.getn(this.soldierDefine[mtbs_enemy.cpNameDefine]) do
		local isEliminated = TppEnemy.IsEliminated( this.soldierDefine[mtbs_enemy.cpNameDefine][idx] )
		local isNeutralized = TppEnemy.IsNeutralized( this.soldierDefine[mtbs_enemy.cpNameDefine][idx] )
		
		if isEliminated == false and isNeutralized == false then
			return false
		end
	end
	return true
end

this.SetTimerCheckFocusArea = function()
	GkEventTimerManager.StartRaw(TIMER_NAME_CHECK_FOCUS_AREA, TIME_CHECK_FOCUS_AREA )
end

this.SetTimerCheckFocusArea_1st = function()
	GkEventTimerManager.StartRaw(TIMER_NAME_CHECK_FOCUS_AREA, math.random(1,5) )
end

this.SetupPracticeMode = function()
	
	local gameObjectId = { type="TppSoldier2" }
	local command = { id = "SetNoBloodMode", enabled=true }
	GameObject.SendCommand( gameObjectId, command )
end

this.SetEnemyRespawnTime = function()
	Fox.Log("*** o50050_enemy SetRespawnTime *** ")
	local cpId = { type="TppCommandPost2" } 

	
	local time = 90.0

	local respawnTimeCountList = {}
	
	respawnTimeCountList = {
		90,		
		85,		
		75,		
		65,		
		55,
		45,
		30,
		10,		
	}

	
	local sectionRankForDefence = TppMotherBaseManagement.GetMbsCombatSectionRank{ type = "Defence" } + 1

	
	if respawnTimeCountList[sectionRankForDefence] ~= nil then
		time = respawnTimeCountList[sectionRankForDefence]
	else
		Fox.Error("### SetRespawnTime :: Set time is nil ###")
	end

	local command = { id = "SetReinforceTime", time=time }
	GameObject.SendCommand( cpId, command )
end

this.SetGuardTagetMember = function( clstId )
	Fox.Log("*** SetGuardTagetMember *** clstId = " .. clstId)
	local gdList = {
		mtbs_enemy.plnt0_gtNameDefine,
		mtbs_enemy.plnt1_gtNameDefine,
		mtbs_enemy.plnt2_gtNameDefine,
		mtbs_enemy.plnt3_gtNameDefine,
	}
	local cpId = { type="TppCommandPost2" } 

	for key, value in ipairs(gdList) do
		local count = math.random(GDTGT_MEMBER_LIST[clstId][key].min, GDTGT_MEMBER_LIST[clstId][key].MAX)
		local front = count
		Fox.Log("*** SetGuardTagetMember *** key = " .. key .. "value = " .. value .. "count = ".. count)
		local command = { id = "SetLocatorMemberCount", name = value, count = count, front = front, }
		GameObject.SendCommand( cpId, command )
	end
end



 
this.SearchingDefencePlayer = function()
	Fox.Log("### SearchingDefencePlayer ###")
	
	
	if o50050_sequence.IsThereDefencePlayer() == true then
		
		TppUiCommand.ExecSpySearchForFobSneak{ visibleSec = mvars.numSearchingDefenceTime }

		
		TppUI.ShowAnnounceLog( "updateMap" )

		
		
		GkEventTimerManager.StartRaw(TIMER_NAME_PERMIT_SEARCHING_DEFENDER, mvars.numSearchingDefenceTime )
	end
end


this.MarkingAnnounce = function(gameObjectId)
	if gameObjectId == NULL_ID then--RETAILBUG: should be GameObject.NULL_ID, or localopt to NULL_ID
		Fox.Error( "Cannot get gameObjectId. gameObjectName = " .. gameObjectName )--RETAILBUG: gameObjectName undefined
		return
	end
	TppMarker.Enable( gameObjectId, 0, "defend", "map_and_world_only_icon", 0, false, true )
	TppUI.ShowAnnounceLog("updateMap", nil, nil, 1 )
end


this.InterCall_hostage_pos01 = function()
	Fox.Log("### InterCall_hostage_pos01 ###")
	local gameObjectId = GameObject.GetGameObjectId( this.HOSTAGE_NAME_LIST[1] )
	this.MarkingAnnounce(gameObjectId)
end
this.InterCall_hostage_pos02 = function()
	Fox.Log("### InterCall_hostage_pos02 ###")
	local gameObjectId = GameObject.GetGameObjectId( this.HOSTAGE_NAME_LIST[2] )
	this.MarkingAnnounce(gameObjectId)
end
this.InterCall_hostage_pos03 = function()
	Fox.Log("### InterCall_hostage_pos03 ###")
	local gameObjectId = GameObject.GetGameObjectId( this.HOSTAGE_NAME_LIST[3] )
	this.MarkingAnnounce(gameObjectId)
end
this.InterCall_hostage_pos04 = function()
	Fox.Log("### InterCall_hostage_pos04 ###")
	local gameObjectId = GameObject.GetGameObjectId( this.HOSTAGE_NAME_LIST[4] )
	this.MarkingAnnounce(gameObjectId)
end
 
this.INTER_SEARCHING_DEFENCE = { name = "enqt1000_101521", func = this.SearchingDefencePlayer, }
this.INTER_HOSTAGE_POS = {
	{ name = "enqt1000_101528", func = this.InterCall_hostage_pos01, },			
	{ name = "enqt1000_1i1210", func = this.InterCall_hostage_pos02, },			
	{ name = "enqt1000_1i1310", func = this.InterCall_hostage_pos03, },			
	{ name = "enqt1000_1i1210", func = this.InterCall_hostage_pos04, },			
}

this.AddHostageInterrogation = function()
	Fox.Log("### AddHostageInterrogation ###")
	local clusterId = MotherBaseStage.GetFirstCluster() + 1
	local grade = mtbs_cluster.GetClusterConstruct( clusterId )
	local hostagePosFuncTable = {
		this.INTER_HOSTAGE_POS[1],
		this.INTER_HOSTAGE_POS[2],
		this.INTER_HOSTAGE_POS[3],
		this.INTER_HOSTAGE_POS[4],
	}
	
	for k=1, 4, 1 do
		if k>grade then		hostagePosFuncTable[k] = nil	end
	end
	TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId(mtbs_enemy.cpNameDefine),hostagePosFuncTable )

end






this.InitEnemy = function ()
	Fox.Log("*** o50050 InitEnemy ***")
	local clusterId = MotherBaseStage.GetFirstCluster() + 1
	if not clusterId then
		Fox.Error("clusterId is nil")
	end
	mtbs_enemy.InitEnemy(clusterId)

	
	this.interrogation = {
		
		[mtbs_enemy.cpNameDefine] = {
			high = {
				this.INTER_SEARCHING_DEFENCE,		
				this.INTER_HOSTAGE_POS[4],			
				this.INTER_HOSTAGE_POS[3],			
				this.INTER_HOSTAGE_POS[2],			
				this.INTER_HOSTAGE_POS[1],			
				nil
			},
			nil
		},
		nil
	}
end



this.SetUpEnemy = function ()
	Fox.Log("*** o50050 SetUpEnemy ***")

	
	TppMotherBaseManagement.SetupFreePositionSecurityItems()

	local clusterId = MotherBaseStage.GetFirstCluster() + 1
	local sortieSoldierNum = mtbs_enemy.SetupEnemy( clusterId )

	
	mvars.mbSoldier_placedCountTotal = 0
	if mvars.mbSoldier_enableSoldierLocatorList[clusterId] ~= nil then
		mvars.mbSoldier_placedCountTotal = #mvars.mbSoldier_enableSoldierLocatorList[clusterId]
	end

	if sortieSoldierNum == nil then
		Fox.Error("*** sortieSoldier = nil ***")
	 	return
	end

	
	this._SetupReinforce( clusterId, sortieSoldierNum )

	
	mvars.o50050_sortieSoldierNum = sortieSoldierNum

	
	local gameObjectId = { type="TppCommandPost2" } 
	local combatAreaList = {
		area1 = {
			{ guardTargetName = mtbs_enemy.plnt0_gtNameDefine, locatorSetName = mtbs_enemy.plnt0_cbtSetNameDefine,}, 
		},
		area2 = {
			{ guardTargetName = mtbs_enemy.plnt1_gtNameDefine, locatorSetName = mtbs_enemy.plnt1_cbtSetNameDefine,}, 
		},
		area3 = {
			{ guardTargetName = mtbs_enemy.plnt2_gtNameDefine, locatorSetName = mtbs_enemy.plnt2_cbtSetNameDefine,}, 
		},
		area4 = {
			{ guardTargetName = mtbs_enemy.plnt3_gtNameDefine, locatorSetName = mtbs_enemy.plnt3_cbtSetNameDefine,}, 
		},
	}
	local command = { id = "SetCombatArea", cpName = mtbs_enemy.cpNameDefine, combatAreaList = combatAreaList }
	GameObject.SendCommand( gameObjectId, command )

	this.SetGuardTagetMember( clusterId )

	
	if vars.fobSneakMode == FobMode.MODE_SHAM then
		this.SetupPracticeMode()
	end

	
	if vars.fobSneakMode == FobMode.MODE_VISIT then
		this.SetFriendly()
		
		if TppMotherBaseManagement.IsMbsOwner{} ~= true then
			Fox.Log("### Not Owner ###")
			this.SetSaluteMoraleDisableAll()
		end
	end

	
	this.SetEnemyRespawnTime()

	
	if TppEnemy.IsHostageEventFOB() then
		local hostagePosTable = {}
		local oceanId = TppMotherBaseManagement.GetMbsOceanAreaId{}
		for value,oceanIds in pairs(o50050_sequence.OCEAN_LIST) do
			for i, key in pairs(oceanIds) do
				if key == oceanId then
					hostagePosTable = this.EVENT_HOSTAGE_POS_LIST[value]	
					local hostagePosList = hostagePosTable[ clusterId ]
					local grade = mtbs_cluster.GetClusterConstruct( clusterId )
					for plantNum, hostagePos in pairs(hostagePosList) do
						local gameObjectId = GameObject.GetGameObjectId( this.HOSTAGE_NAME_LIST[plantNum] )
						
						if plantNum <= grade then
							local command = { id="Warp", degRotationY=vars.playerRotY, position = Vector3( hostagePos[1], hostagePos[2]+0.8, hostagePos[3] ) }	
							if gameObjectId ~= nil then
								GameObject.SendCommand( gameObjectId, command )
							end
						else
							local command = { id="SetEnabled", enabled=false }
							if gameObjectId ~= nil then
								GameObject.SendCommand( gameObjectId, command )
							end
						end
					end
					return
				end
			end
		end
	end

	
	if TppEnemy.IsZombieEventFOB() then
		this.SetUpEventFOBZombie()
	end

	
	
	if not TppEnemy.IsSpecialEventFOB() then	
		for k,locatorName in pairs(ANYWHARE_CAMERA_LIST) do
			local gameObjectId = GameObject.GetGameObjectId( "TppSecurityCamera2", locatorName )
			GameObject.SendCommand( gameObjectId, {id = "SetEnabled", enabled = false } )
			GameObject.SendCommand( gameObjectId, {id = "SetCommandPost", cp=mtbs_enemy.cpNameDefine } )
		end
	end

end


this.OnLoad = function ()
	Fox.Log("*** o50050 onload ***")
	local clusterId = MotherBaseStage.GetFirstCluster() + 1
	local securityStaffIdList, rewardStaffIds = TppMotherBaseManagement.GetStaffsFob()
	mvars.o50050_rewardStaffIds = rewardStaffIds
	mtbs_enemy.SetSecurityStaffIdList( clusterId, securityStaffIdList )
	mtbs_enemy.OnLoad( clusterId )

	
	this.soldierDefine = mtbs_enemy.soldierDefine
	this.soldierSubTypes = mtbs_enemy.soldierSubTypes
	this.routeSets = mtbs_enemy.routeSets
	this.combatSetting = mtbs_enemy.combatSetting

end


this.OnAllocate = function()
	this.GetRouteSetPriority = mtbs_enemy.GetRouteSetPriority

	














end

function this.Messages()
	return
	StrCode32Table {
		Timer = {
			{
				msg = "Finish",
				sender = TIMER_NAME_CHECK_FOCUS_AREA,
				func = function()
					GkEventTimerManager.Stop(TIMER_NAME_CHECK_FOCUS_AREA)
					local clusterId = mtbs_cluster.GetCurrentClusterId()
					mtbs_enemy.StartCheckFocusArea( clusterId )
					this.SetTimerCheckFocusArea()
				end,
			},
			{
				msg = "Finish",
				sender = TIMER_NAME_PERMIT_SEARCHING_DEFENDER,
				func = function()
					GkEventTimerManager.Stop(TIMER_NAME_PERMIT_SEARCHING_DEFENDER)
					local cp = GameObject.GetGameObjectId(mtbs_enemy.cpNameDefine)
					TppInterrogation.MakeFlagHigh( cp )
				end,
			},
		},
		Marker = {
			{
				msg = "ChangeToEnable",
				func = function ( arg0, arg1 )
					for k, hostageName in pairs(this.HOSTAGE_NAME_LIST) do
						if arg0 == StrCode32(hostageName) then
							
							TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId(mtbs_enemy.cpNameDefine), { this.INTER_HOSTAGE_POS[k],} )
							return
						end
					end
				end
			},
		},
		GameObject = {
			{
				msg = "Dead",
				func = function( gameObjectId )
					for k, hostageName in pairs(this.HOSTAGE_NAME_LIST) do
						if gameObjectId == GameObject.GetGameObjectId(hostageName) then
							
							TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId(mtbs_enemy.cpNameDefine), { this.INTER_HOSTAGE_POS[k],} )
							return
						end
					end
				end
			},
			{
				msg = "Fulton",
				func = function( gameObjectId )
					for k, hostageName in pairs(this.HOSTAGE_NAME_LIST) do
						if gameObjectId == GameObject.GetGameObjectId(hostageName) then
							
							TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId(mtbs_enemy.cpNameDefine), { this.INTER_HOSTAGE_POS[k],} )
							return
						end
					end
				end
			},
		},
		nil
	}
end

function this._SetupReinforce( clusterId, sortieSoldierNum )
	if svars.fobUsedStaffNum == 0 then
		svars.fobUsedStaffNum = sortieSoldierNum 
	end
	local canSortieStaffList = mtbs_enemy.GetSecurityStaffIdList(clusterId)
	local reinforceCount = #canSortieStaffList - svars.fobUsedStaffNum

	
	local maxReinforceCountFromSecurityRank = this._GetMaxRespawnSoldierNum()
	
	if TppNetworkUtil.IsEnableFobDeployDamage() then
		local damageParams = TppNetworkUtil.GetFobDeployDamageParams()
		Fox.Log("FobDeployDamage down reinforceCount: dowm:".. tostring(damageParams.reinforce) .."%" )
		if damageParams.reinforce > 100 then
			damageParams.reinforce = 100
		end
		maxReinforceCountFromSecurityRank = maxReinforceCountFromSecurityRank * ( ( 100 - damageParams.reinforce ) / 100.0 )
	end
	if reinforceCount > maxReinforceCountFromSecurityRank then
		reinforceCount = maxReinforceCountFromSecurityRank
	end
	
	Fox.Log("SetupReinforceNum:" ..tostring(reinforceCount) )
	local cpId = { type="TppCommandPost2" } 
	local command = { id = "SetFOBReinforceCount", count=reinforceCount }
	GameObject.SendCommand( cpId, command )
end


function this.AssignAndSetupRespawnSoldier(gameObjectId)
	
	local serverStaffIdList = mtbs_enemy.GetSecurityStaffIdList(mtbs_cluster.GetCurrentClusterId())
	local serverStaffId = 			serverStaffIdList[svars.fobUsedStaffNum+1]

	if not serverStaffId then
		Fox.Error("no staffId. but, respawnSoldier")
		return	
	end

	
	mtbs_enemy.SetStaffId( gameObjectId , serverStaffId )
	
	mtbs_enemy.SetStaffAbirity( serverStaffId, gameObjectId )
	
	local faceId = TppMotherBaseManagement.StaffIdToFaceId{ staffId=serverStaffId }
	TppEneFova.ApplyMTBSUniqueSetting( gameObjectId, faceId, true )

	
	svars.fobUsedStaffNum =	svars.fobUsedStaffNum+1
	for i, locatorName in ipairs(mvars.mbSoldier_enableSoldierLocatorList[mtbs_cluster.GetCurrentClusterId()]) do
		if GameObject.GetGameObjectId(locatorName) == gameObjectId then
			svars.fobUsingStaffIndexList[i-1] = svars.fobUsedStaffNum
			return
		end
	end
	Fox.Error("Unknown GameObjectId: " ..tostring(gameObjectId) )
end

function this._GetMaxRespawnSoldierNum()
	local rank = TppMotherBaseManagement.GetMbsCombatSectionRank{ type = "Defence" }
	local RESPORN_MAX = {
		4,	
		4,	
		8,	
		16, 
		32, 
		48, 
		100 
	}
	local maxRespornNum = RESPORN_MAX[rank]
	Fox.Log("GetMaxRespawnSoldierNumForRank:" ..tostring(maxRespornNum) )
	if maxRespornNum then
		return maxRespornNum
	else
		return 0
	end
end


function this.RestoreSoldier()
	local clusterId = mtbs_cluster.GetCurrentClusterId()
	for i, soldierName in ipairs(mvars.mbSoldier_enableSoldierLocatorList[clusterId]) do
		local serverStaffIndex = svars.fobUsingStaffIndexList[i-1]
		if serverStaffIndex == 0 then
			return 
		end

		local serverStaffIdList = mtbs_enemy.GetSecurityStaffIdList(clusterId)
		local staffId = serverStaffIdList[ serverStaffIndex ]
		local gameObjectId =  GameObject.GetGameObjectId(soldierName)
		
		mtbs_enemy.SetStaffId( gameObjectId , staffId )
		
		mtbs_enemy.SetStaffAbirity( serverStaffId, gameObjectId )--RETAILBUG: should be staffId, bug propably due to copy/paste from AssignAndSetupRespawnSoldier
		
		local faceId = TppMotherBaseManagement.StaffIdToFaceId{ staffId=staffId }
		TppEneFova.ApplyMTBSUniqueSetting( gameObjectId, faceId, mvars.o50050_sortieSoldierNum < serverStaffIndex )
	end
end


function this.InitializeFobUsingStaffIndex()
	if TppMission.IsMissionStart() then
		for i = 1, mvars.o50050_sortieSoldierNum do 
			svars.fobUsingStaffIndexList[i-1] = i
		end
	end
end

function this.SetUpEventFOBZombie()
	Fox.Log("***** EventFOB:ZombieEvent *****")

	for idx = 1, table.getn(this.soldierDefine[mtbs_enemy.cpNameDefine]) do
		local gameObjectId = GameObject.GetGameObjectId("TppSoldier2", this.soldierDefine[mtbs_enemy.cpNameDefine][idx])
		if gameObjectId ~= NULL_ID then--RETAILBUG: should be GameObject.NULL_ID, or localopt to NULL_ID
			GameObject.SendCommand( gameObjectId, { id = "SetZombie", enabled = true, isMsf = false, isZombieSkin = true, isHagure = false } )
		end
	end

end

function this.UnsetEventFOBZombie()
	Fox.Log("***** EventFOB:UnsetEventFOBZombie *****")

	for idx = 1, table.getn(this.soldierDefine[mtbs_enemy.cpNameDefine]) do
		local gameObjectId = GameObject.GetGameObjectId("TppSoldier2", this.soldierDefine[mtbs_enemy.cpNameDefine][idx])
		if gameObjectId ~= NULL_ID then--RETAILBUG: should be GameObject.NULL_ID, or localopt to NULL_ID
			GameObject.SendCommand( gameObjectId, { id = "SetZombie", enabled = false } )
			GameObject.SendCommand( gameObjectId, { id = "SetEverDown", enabled = true } )
		end
	end

end

this.InitParasiteEvent = function ()
	Fox.Log("***** this.InitParasiteEvent *****")

	
	TppWeather.ForceRequestWeather( TppDefine.WEATHER.FOGGY, 0, { fogDensity = 0.001 } )	

end


this.BeforeSpawnParasite = function ()
	Fox.Log("***** this.BeforeSpawnParasite *****")

	TppTerminal.TerminalVoiceWeatherForecast(TppDefine.WEATHER.FOGGY)
	TppWeather.ForceRequestWeather( TppDefine.WEATHER.FOGGY, 15, { fogDensity = 0.09 } )	

end


this.SpawnParasite = function ()
	Fox.Log("***** this.SpawnParasite *****")

	WeatherManager.PauseNewWeatherChangeRandom(true)

	
	local params, combatGrade = this.GetDifficultyParasite()
	GameObject.SendCommand( { type="TppParasite2" }, { id="SetParameters", params=params } ) 
	GameObject.SendCommand(
    { type="TppParasite2" },
    {
      id="SetCombatGrade",
      defenseValueMain = combatGrade.defenseValueMain,
      defenseValueArmor = combatGrade.defenseValueArmor,
      defenseValueWall = combatGrade.defenseValueWall,
      offenseGrade = combatGrade.offenseGrade,
      defenseGrade = combatGrade.defenseGrade,
    }
	)

	
	local clusterId = MotherBaseStage.GetFirstCluster() + 1
	local posSpotList, rotSpotY = mtbs_cluster.GetPosAndRotY_FOB( TppDefine.CLUSTER_NAME[o50050_sequence.currentClusterSetting.numClstId], "plnt0", {0,0,0}, 0 )
	GameObject.SendCommand( { type="TppParasite2" }, { id="StartAppearance", position=Vector3(posSpotList[1],posSpotList[2]+0.0001,posSpotList[3]), radius=15.0 } )

end


this.GetDifficultyParasite = function ()
	Fox.Log("***** this.GetDifficultyParasite *****")
	local combatGrade = TppNetworkUtil.GetEventFobSkullsParam()
  if ( Tpp.IsQARelease() or DEBUG ) then
    Tpp.DEBUG_DumpTable( combatGrade )
  end
  return PARASITE_PARAM.HARD, combatGrade
end


this.StartSearchParasite = function ()
	Fox.Log("***** this.StartSearchParasite *****")

	for k, parasiteName in pairs(this.PARASITE_NAME_LIST) do
		local gameObjectId = GameObject.GetGameObjectId(parasiteName)
		if gameObjectId ~= nil then
			GameObject.SendCommand( gameObjectId, { id="StartSearch" })
		end
	end
end


this.StartCombatParasite = function ()
	Fox.Log("***** this.StartCombatParasite *****")

	for k, parasiteName in pairs(this.PARASITE_NAME_LIST) do
		local gameObjectId = GameObject.GetGameObjectId(parasiteName)
		if gameObjectId ~= nil then
			GameObject.SendCommand( gameObjectId, { id="StartCombat" })
		end
	end
end


this.CountDyingParasite = function (gameObjectId)
	Fox.Log("***** this.CountDyingParasite *****")

	for k, parasiteName in pairs(this.PARASITE_NAME_LIST) do
		if gameObjectId == GameObject.GetGameObjectId(parasiteName) then
			mvars.parasiteDyingNum = mvars.parasiteDyingNum + 1
		end
	end
	Fox.Log("#### o50050_enemy.CountDyingParasite #### dying count = "..mvars.parasiteDyingNum)

	if mvars.parasiteDyingNum >= table.getn(this.PARASITE_NAME_LIST) then
		return true
	else
		return false
	end

end




return this
