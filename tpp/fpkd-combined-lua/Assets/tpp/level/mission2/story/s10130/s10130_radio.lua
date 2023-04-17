local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.DEBUG_strCode32List = {
	"CodeTalker",
	"speech130_CTV010_01",
	"speech130_CTV010_02",
	"speech130_CTV010_03",
	"speech130_CTV010_04",
	"speech130_CTV010_05",
	"speech130_CTV010_06",
	"speech130_CTV010_07",
	"speech130_CTV010_08",
	"speech130_CTV020_01",
	"speech130_CTV020_02",
	"speech130_CTV020_03",
}




this.commonRadioTable = {}
this.commonRadioTable[ TppDefine.COMMON_RADIO.HOSTAGE_DEAD ]				= TppRadio.IGNORE_COMMON_RADIO
this.commonRadioTable[ TppDefine.COMMON_RADIO.HOSTAGE_DAMAGED_FROM_PC ]	= TppRadio.IGNORE_COMMON_RADIO
this.commonRadioTable[ TppDefine.COMMON_RADIO.ABORT_BY_HELI ]				= TppRadio.IGNORE_COMMON_RADIO	
this.commonRadioTable[ TppDefine.COMMON_RADIO.TARGET_MARKED ]				= TppRadio.IGNORE_COMMON_RADIO
this.commonRadioTable[ TppDefine.COMMON_RADIO.SEARCH_TARGET_ENABLED ]		= TppRadio.IGNORE_COMMON_RADIO
this.commonRadioTable[ TppDefine.COMMON_RADIO.TARGET_RECOVERED ]			= TppRadio.IGNORE_COMMON_RADIO
this.commonRadioTable[ TppDefine.COMMON_RADIO.OUTSIDE_HOTZONE_ALERT ]		= TppRadio.IGNORE_COMMON_RADIO
this.commonRadioTable[ TppDefine.COMMON_RADIO.OUTSIDE_HOTZONE ]			= TppRadio.IGNORE_COMMON_RADIO
this.commonRadioTable[ TppDefine.COMMON_RADIO.RETURN_HOTZONE ]				= TppRadio.IGNORE_COMMON_RADIO




this.radioList = {
	
	
	
	
	"s0130_rtrg2010", 	
	{"s0130_rtrg2020",playOnce = true}, 	
	{"s0130_rtrg2030",playOnce = true}, 	
	{"s0130_rtrg2040",playOnce = true}, 	
	{"s0130_rtrg2050",playOnce = true}, 	
	{"s0130_rtrg2060",playOnce = true}, 	
	{"s0130_rtrg2070",playOnce = true}, 	
	{"s0130_rtrg2080",playOnce = true}, 	
	{"s0130_rtrg2090",playOnce = true}, 	
	{"s0130_rtrg2100",playOnce = true}, 	
	{"s0130_rtrg2110",playOnce = true}, 	
	{"s0130_rtrg2120",playOnce = true}, 	
	"s0130_rtrg2130", 	
	"s0130_rtrg2140", 	
	"s0130_rtrg2150", 	
	{"s0130_rtrg2160",playOnce = true}, 	
	{"s0130_rtrg2165",playOnce = true}, 	
	{"s0130_rtrg2170",playOnce = true}, 	
	"s0130_rtrg2180", 	
	"s0130_rtrg2190", 	
	"s0130_rtrg2200", 	
	"f1000_rtrg1490", 	
	"s0130_rtrg4010", 	
	"s0130_rtrg4020", 	
	"s0130_rtrg4030", 	
	"s0130_rtrg5010", 	
	"s0130_rtrg6010", 	
	"s0130_rtrg6020", 	
	"s0130_rtrg6050", 	
	"s0130_rtrg6060", 	
	"s0130_rtrg6070", 	
	"s0130_rtrg6100", 	
	"s0130_rtrg6110", 	
	"f1000_rtrg2325", 	
	"s0130_rtrg6090", 	
	"f1000_rtrg1870", 	
	"f1000_rtrg3150", 	
	"s0130_rtrg2230",	
	"f1000_rtrg2260",	
	"f1000_rtrg2270",	
	"f1000_rtrg2280",	
	"s0130_rtrg2240", 	
	
	"s0130_rtrg0020", 	
	"s0130_rtrg0050", 	
	"s0130_rtrg0080", 	
	"s0130_rtrg0070", 	
	"s0130_rtrg0100", 	
	"s0130_rtrg0110", 	
	"s0130_rtrg0120", 	
}

this.debugRadioLineTable = {
	
	CPRadio01 = {
		"[dbg]敵CP：森林の部隊に動きがあった模様。",
		"[dbg]敵CP：敵襲の可能性がある、各員、十分に警戒せよ。",
	},
	CPRadio02 = {
		"[dbg]敵CP：緊急事態発生。",
		"[dbg]敵CP：森林の部隊が何者かの襲撃により壊滅した模様。",
		"[dbg]敵CP：各隊は一帯を封鎖、侵入者を逃がすな。",
	},
	
	
	GoToRV = {
		"[dbg]｛目標→ターゲット｝を確保したな。",
		"[dbg]だがその老体にフルトン回収は危険だ。",
		"[dbg]ヘリか陸路で、｛危険領域→ホットゾーン｝から連れ出してくれ。",
	},
	
	whenContactCTOnAlert = {
		"[dbg]敵に発見されている状態では、コードトーカーには会えない！",
		"[dbg]何とかして警戒状態を解くんだ！",
	},
}




this.optionalRadioList = {
	"Set_s0130_oprg0010",	
	"Set_s0130_oprg0020",	
	"Set_s0130_oprg0030",	
	"Set_s0130_oprg0040",	
	"Set_s0130_oprg0050",	
}




this.intelRadioList = {
	
	
	wmu_lab_0000 = "s0130_esrg2020",
	wmu_lab_0001 = "s0130_esrg2020",
	wmu_lab_0002 = "s0130_esrg2020",
	wmu_lab_0003 = "s0130_esrg2020",
	
	rds_lab_mansion_0000 = "s0130_esrg2030",
	
	type_enemy = "s0130_esrg2050",
	
	rds_lab_cemetery_0000 = "s0130_esrg6010",
}

this.intelRadioListPrasiteCombat = {
	
	
	wmu_lab_0000 = "s0130_esrg2010",
	wmu_lab_0001 = "s0130_esrg2010",
	wmu_lab_0002 = "s0130_esrg2010",
	wmu_lab_0003 = "s0130_esrg2010",
}

this.intelRadioListEscapeA = {
	
	
	wmu_lab_0000 = "s0130_esrg4010",
	wmu_lab_0001 = "s0130_esrg4010",
	wmu_lab_0002 = "s0130_esrg4010",
	wmu_lab_0003 = "s0130_esrg4010",
	
	type_enemy = "s0130_esrg4020",
}

this.intelRadioListDefeatedParasites = {
	
	
	wmu_lab_0000 = "Invalid",
	wmu_lab_0001 = "Invalid",
	wmu_lab_0002 = "Invalid",
	wmu_lab_0003 = "Invalid",
}

this.intelRadioListAfterZombie = {
	
	type_enemy = "s0130_esrg2050",
}

this.intelRadioListNearLab = {
	
	rds_lab_mansion_0000 = "s0130_esrg2040",
}

this.intelRadioListEscapeB = {
	
	type_enemy = "s0130_esrg5010",
	
	veh_guard01_0000 = "s0130_esrg5030",
	sol_lab_0012 = "s0130_esrg5030",
	
	EnemyHeli = "s0130_esrg5040",
}

this.intelRadioListCemeteryDemoEnd = {
	
	rds_lab_cemetery_0000 = "Invalid",
}



this.blackTelephoneDisplaySetting = {
	f6000_rtrg0340  = {
		Japanese = {
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10130_01.ftex", 0.6 }, 
			{ "hide", "main_1", 14.9 }, 
			{ "main_2", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10130_02.ftex", 18.3 }, 
		},
		English = {
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10130_01.ftex", 0.6 }, 
			{ "hide", "main_1", 13.3 }, 
			{ "main_2", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10130_02.ftex", 15.8 }, 
		},
	},
}





this.MissionStart = function()
	Fox.Log("#### s10130_radio.MissionStart ####")
	TppRadio.Play( "s0130_rtrg2010" )
end


this.MissionContinue = function()
	Fox.Log("#### s10130_radio.MissionContinue ####")
	TppRadio.Play( "s0130_rtrg2240" )
end


this.NoEnemy = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2020 ####")
	TppRadio.Play( "s0130_rtrg2020" )
end


this.FogSkulls = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2030 ####")
	TppRadio.Play( "s0130_rtrg2030" )
end





this.ParasiteCombatStart = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2040 ####")
	TppRadio.Play( "s0130_rtrg2040" )
end




this.ParasitePhantom = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2050 ####")
	TppRadio.Play( "s0130_rtrg2050" )
end


this.ParasiteCombatHint01 = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2060 ####")
	TppRadio.Play( "s0130_rtrg2060" )
end


this.ParasiteCombatHint02 = function()

	
	if (TppQuest.IsCleard( "waterway_q99010" ) == true ) then
		Fox.Log("#### s10130_radio.s0130_rtrg2070 ####")
		TppRadio.Play( "s0130_rtrg2070" )
	else
		Fox.Log("#### s10130_radio.s0130_rtrg2080 ####")
		TppRadio.Play( "s0130_rtrg2080" )
	end

end


this.ParasiteCombatHint03 = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2080 ####")
	TppRadio.Play( "s0130_rtrg2080" )
end


this.ParasiteCombatEnd01 = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2090 ####")
	TppRadio.Play( "s0130_rtrg2090" )
end


this.ParasiteCombatEndAfter = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2100 ####")
	TppRadio.Play( "s0130_rtrg2100" )
end


this.ParasiteCombatEnd02 = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2110 ####")
	TppRadio.Play( "s0130_rtrg2110" )
end


this.ParasiteCombatEnd03 = function()
	Fox.Log("#### s10130_radio.s0130_rtrg4030 ####")
	TppRadio.Play( "s0130_rtrg4030" )
end


this.ParasiteDiscovery = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2120 ####")
	TppRadio.Play( {"s0130_rtrg2120","s0130_rtrg2130"} )
end


this.BackCipher = function()
	
	
end


this.ArrivalLab = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2140 ####")
	TppRadio.Play( "s0130_rtrg2140" )
end


this.ZRSCPtoKazu = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2150 ####")
	TppRadio.Play( "s0130_rtrg2150" )
end


this.ZRSDiscovery = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2160 ####")
	
	if ( TppRadio.IsPlayed("s0130_rtrg2150") ) then
		TppRadio.Play( "s0130_rtrg2165" )
	else
		TppRadio.Play( "s0130_rtrg2160" )
	end
end


this.ZRSQuestioning = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2170 ####")
	TppRadio.Play( "s0130_rtrg2170" , { delayTime = "short" } )
end


this.ZRSQuestioningtoKazu01 = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2180 ####")
	TppRadio.Play( "s0130_rtrg2180" )
end


this.ZRSQuestioningtoKazu02 = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2190 ####")
	TppRadio.Play( "s0130_rtrg2190" )
end


this.GetIntelFile = function()
	Fox.Log("#### s10130_radio.s0130_rtrg2200 ####")
	TppRadio.Play( "s0130_rtrg2200" )
end


this.GetIntelFileAfter = function()
	Fox.Log("#### s10130_radio.f1000_rtrg1490 ####")
	TppRadio.Play( "f1000_rtrg1490" )
end


this.GoToRV = function()
	Fox.Log("#### s10130_radio.GoToRV ####")
	TppRadio.Play( "s0130_rtrg6010" , { delayTime = "short" } )
end


this.ZombieRadio01 = function()
	Fox.Log("#### s10130_radio.ZombieRadio01 ####")
	TppRadio.Play( "s0130_rtrg4010" )
end


this.ZombieRadio02 = function()
	Fox.Log("#### s10130_radio.ZombieRadio02 ####")
	TppRadio.Play( "s0130_rtrg4020" )
end


this.EnemyAttackCodetalker = function()
	Fox.Log("#### s10130_radio.EnenyAttackCodetalker ####")
	if ( svars.PreliminaryFlag08 == false ) then
		svars.PreliminaryFlag08 = true
		TppRadio.Play( "s0130_rtrg6050" )
	else
		svars.PreliminaryFlag08 = false
		TppRadio.Play( "s0130_rtrg6060" )
	end
end


this.PlayerAttackCodetalker = function()
	Fox.Log("#### s10130_radio.PlayerAttackCodetalker ####")
	TppRadio.Play( "s0130_rtrg6070" )
end



this.LookAtMap = function()
	Fox.Log("#### s10130_radio.LookAtMap ####")
	TppRadio.Play( "s0130_rtrg0050" )
end


this.RiverOverThere = function()
	Fox.Log("#### s10130_radio.RiverOverThere ####")
	TppRadio.Play( "s0130_rtrg0080" )
end


this.SkullsReady = function()
	Fox.Log("#### s10130_radio.SkullsReady ####")
	TppRadio.Play( "s0130_rtrg0070" )
end


this.RescueCodeTalker = function()
	Fox.Log("#### s10130_radio.RescueCodeTalker ####")
	TppRadio.Play( "s0130_rtrg0100" )
end


this.CliffFallDead = function()
	Fox.Log("#### s10130_radio.CliffFallDead ####")
	TppRadio.Play( "s0130_rtrg0110" )
end


this.CodeTalkerInLab = function()
	Fox.Log("#### s10130_radio.CodeTalkerInLab ####")
	TppRadio.Play( "s0130_rtrg0120" )
end


this.CPRadio01 = function()
	Fox.Log("#### s10130_radio.CPRadio01 ####")
	local gameObjectId = GameObject.GetGameObjectId( "mafr_lab_cp" )
	local command = { id = "RequestRadio", label="CPRSP010", memberId=memberGameObjectId }--RETAILBUG memberGameObjectId undefined
	GameObject.SendCommand( gameObjectId, command )
end


this.CPRadio02 = function()
	Fox.Log("#### s10130_radio.CPRadio02 ####")
	local gameObjectId = GameObject.GetGameObjectId( "mafr_lab_cp" )
	local command = { id = "RequestRadio", label="CPRSP020", memberId=memberGameObjectId }--RETAILBUG memberGameObjectId undefined
	GameObject.SendCommand( gameObjectId, command )
end


this.DistantCodeTalkerRadio01 = function()
	Fox.Log("#### s10130_radio.DistantCodeTalkerRadio01 ####")
	TppRadio.Play( "f1000_rtrg2325" )
end


this.DistantCodeTalkerRadio02 = function()
	Fox.Log("#### s10130_radio.DistantCodeTalkerRadio02 ####")
	TppRadio.Play( "s0130_rtrg6090" )
end


this.CodeTalkerStayInHeli = function()
	Fox.Log("#### s10130_radio.CodeTalkerStayInHeli ####")
	TppRadio.Play( "f1000_rtrg1870" )
end


this.CodeTalkerNotStayInHeli = function()
	Fox.Log("#### s10130_radio.CodeTalkerNotStayInHeli ####")
	TppRadio.Play( "f1000_rtrg3150" )
end


this.MonologueAfterKazuRadio01 = function()
	Fox.Log("#### s10130_radio.CallMonologueCodeTalker01 After Kazu Radio ####")
	TppRadio.Play( "s0130_rtrg6100" )
end


this.MonologueAfterKazuRadio02 = function()
	Fox.Log("#### s10130_radio.CallMonologueCodeTalker02 After Kazu Radio ####")
	TppRadio.Play( "s0130_rtrg6110" )
end


this.ZRSCPtoKazuEscape = function()
	Fox.Log("#### s10130_radio.ZRSCPtoKazuEscape ####")
	TppRadio.Play( "s0130_rtrg5010" )
end


this.KazuSneakSuccess = function()
	Fox.Log("#### s10130_radio.KazuSneakSuccess ####")
	TppRadio.Play( "s0130_rtrg6020" )
end



this.CallMonologueHostage = function( locatorName, labelName )

	
	mvars.currentspeech130 = labelName

	Fox.Log("s10130_radio Monologue locatorName " .. locatorName)
	Fox.Log("s10130_radio Monologue labelName " .. labelName)

	local gameObjectType = "TppCodeTalker2"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local command = {
		id="CallMonologue",
		label = labelName,
	}
	GameObject.SendCommand( gameObjectId, command )

end


this.StopMonologueHostage = function( locatorName )
	Fox.Log("s10130_radio Monologue locatorName " .. locatorName)

	
	local labelName = mvars.currentspeech130

	Fox.Log("s10130_radio Monologue labelName " .. labelName)

	local gameObjectType = "TppCodeTalker2"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local command = {
		id="CallMonologue",
		label = labelName,
		reset = true,
	}
	GameObject.SendCommand( gameObjectId, command )

end


this.CallMonologueCodeTalker01 = function()

	
	mvars.currentspeech130 = "speech130_CTV010_01"

	local locatorName = "CodeTalker"
	local gameObjectType = "TppCodeTalker2"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local command = {
		id="CallMonologue",
		label = "speech130_CTV010_01",
	}
	GameObject.SendCommand( gameObjectId, command )

end


this.CallMonologueCodeTalker02 = function()

	
	mvars.currentspeech130 = "speech130_CTV010_05"

	local locatorName = "CodeTalker"
	local gameObjectType = "TppCodeTalker2"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local command = {
		id="CallMonologue",
		label = "speech130_CTV010_05",
	}
	GameObject.SendCommand( gameObjectId, command )

end


this.CallMonologueCodeTalker03 = function()

	
	svars.speech130_CTV020_01					= true

	
	mvars.currentspeech130 = "speech130_CTV020_02"

	local locatorName = "CodeTalker"
	local gameObjectType = "TppCodeTalker2"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local command = {
		id="CallMonologue",
		label = "speech130_CTV020_02",
	}
	GameObject.SendCommand( gameObjectId, command )

end


this.CallMonologueCodeTalker04 = function()

	
	mvars.currentspeech130 = "speech130_CTV020_01"

	local locatorName = "CodeTalker"
	local gameObjectType = "TppCodeTalker2"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local command = {
		id="CallMonologue",
		label = "speech130_CTV020_01",
	}
	GameObject.SendCommand( gameObjectId, command )

end


this.OnGameCleared = function()
	Fox.Log("#### s10130_radio.OnGameCleared ####")
	TppRadio.RequestBlackTelephoneRadio( "f6000_rtrg0340" )
end






this.dontPicking_Alert = function()
	Fox.Log("#### s10130_radio.dontPicking_Alert ####")
	TppRadio.Play( "s0130_rtrg2230" )
end

this.dontPicking_Enemy = function()
	Fox.Log("#### s10130_radio.dontPicking_Enemy ####")
	TppRadio.Play( "f1000_rtrg2260" )
end

this.Alert_off = function()
	Fox.Log("#### s10130_radio.Alert_off ####")
	TppRadio.Play( "f1000_rtrg2280" )
end

this.enemy_off = function()
	Fox.Log("#### s10130_radio.enemy_off ####")
	TppRadio.Play( "f1000_rtrg2270" )
end




return this
