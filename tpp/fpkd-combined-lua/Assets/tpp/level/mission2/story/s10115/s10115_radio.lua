local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table




this.radioList = {
	
	
	"s0115_rtrg0010",
	"s0115_rtrg0020",
	"s0115_rtrg0030",
	"s0115_rtrg0040",
	"s0115_rtrg1010",
	"s0115_rtrg1020",
	"s0115_rtrg1030",

	"s0115_rtrg1050",
	"s0115_rtrg1060",
	"s0115_rtrg1070",
	"s0115_rtrg1080",
	"s0115_rtrg1090",
	"s0115_rtrg1100",
	"s0115_rtrg1110",
	"s0115_rtrg1120",
	"s0115_rtrg1130",
	"s0115_rtrg1140",
	"s0115_rtrg1150",
	"s0115_rtrg1160",
	"s0115_rtrg1170",
	"s0115_rtrg2010",
	"s0115_rtrg3000",
	"s0115_rtrg3010",
	"s0115_rtrg3015",
	"s0115_rtrg3020",
	"s0115_rtrg3030",
}




this.RecoveredHostageRadio = function()
	if mvars.isFultonedLastHostage == true then
		if mvars.numHostageKilled == 0 then
			
			return "s0115_rtrg1060"
		else
			
			return "s0115_rtrg1050"
		end
	else
		return "f1000_rtrg1550"
	end
end


this.commonRadioTable = {
	[ TppDefine.COMMON_RADIO.RESULT_RANK_NOT_DEFINED ] = "f1000_rtrg9011",
	[ TppDefine.COMMON_RADIO.HOSTAGE_DEAD ] = TppRadio.IGNORE_COMMON_RADIO,			
	[ TppDefine.COMMON_RADIO.HOSTAGE_RECOVERED ] = this.RecoveredHostageRadio,		
}





this.optionalRadioList = {
	"Set_s0115_oprg0010",	
	"Set_s0115_oprg0020",	
}




this.blackTelephoneDisplaySetting = {
	f6000_rtrg0150	= {
		Japanese = {
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10115/mb_photo_10115_010_1.ftex", 0.6,"cast_mosquito" }, 
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10115_02.ftex", 3.5 }, 
			{ "main_2", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10115_03.ftex", 7.3 }, 
			{ "main_3", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10115_04.ftex", 29.9 }, 
			{ "hide", "main_1", 47.1 }, 
			{ "hide", "main_2", 47.4 }, 
			{ "hide", "main_3", 47.7 }, 
		},
		English = {
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10115/mb_photo_10115_010_1.ftex", 0.6,"cast_mosquito" }, 
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10115_02.ftex", 4.0 }, 
			{ "main_2", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10115_03.ftex", 7.1 }, 
			{ "main_3", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10115_04.ftex", 28.3 }, 
			{ "hide", "main_1", 43.3 }, 
			{ "hide", "main_2", 43.7 }, 
			{ "hide", "main_3", 44.0 }, 
		},
	},
}





this.intelRadioList = {
	
	type_gunMount		= "s0115_esrg1010",		
	type_mortar			= "s0115_esrg1020",		
	type_antiAirGun		= "s0115_esrg1030",		
	type_eleGenerator	= "s0115_esrg1080",		
	
	pipe_A01			= "s0115_esrg1070",
	pipe_A02			= "s0115_esrg1070",
	pipe_A03			= "s0115_esrg1070",
	pipe_A04			= "s0115_esrg1070",
	pipe_A05			= "s0115_esrg1070",
	pipe_A06			= "s0115_esrg1070",
	pipe_A07			= "s0115_esrg1070",
	pipe_A08			= "s0115_esrg1070",
	pipe_A10			= "s0115_esrg1070",
	pipe_A11			= "s0115_esrg1070",
	pipe_A12			= "s0115_esrg1070",
	pipe_A20			= "s0115_esrg1070",
	pipe_A21			= "s0115_esrg1070",
	pipe_A22			= "s0115_esrg1070",
	--DUPLICATE: pipe_A20			= "s0115_esrg1070",
	--DUPLICATE: pipe_A21			= "s0115_esrg1070",
	--DUPLICATE: pipe_A22			= "s0115_esrg1070",

	
	hos_s10115_0000		= "s0115_esrg1040",
	hos_s10115_0001		= "s0115_esrg1040",
	hos_s10115_0002		= "s0115_esrg1040",
	hos_s10115_0003		= "s0115_esrg1040",
	hos_s10115_0004		= "s0115_esrg1040",
	hos_s10115_0005		= "s0115_esrg1040",
	
	ly003_cl02_10115_npc0000__cl02pl0_uq_0020_npc__sol_plnt0_0000 = "s0115_esrg1090",
	
	type_enemy			= "s0115_esrg1090",
}

this.intelRadioList_gunMountInvalid = {
	type_gunMount		= "Invalid",
}

this.intelRadioList_mortarInvalid = {
	type_mortar			= "Invalid",
}

this.intelRadioList_antiAirGunInvalid = {
	type_antiAirGun	= "Invalid",
}

this.intelRadioList_eleGeneratorInvalid = {
	type_eleGenerator	= "Invalid",
}

this.intelRadioList_allPipeInvalid = {
	pipe_A01			= "Invalid",
	pipe_A02			= "Invalid",
	pipe_A03			= "Invalid",
	pipe_A04			= "Invalid",
	pipe_A05			= "Invalid",
	pipe_A06			= "Invalid",
	pipe_A07			= "Invalid",
	pipe_A08			= "Invalid",
	pipe_A10			= "Invalid",
	pipe_A11			= "Invalid",
	pipe_A12			= "Invalid",
	pipe_A20			= "Invalid",
	pipe_A21			= "Invalid",
	pipe_A22			= "Invalid",
	--DUPLICATE: pipe_A20			= "Invalid",
	--DUPLICATE: pipe_A21			= "Invalid",
	--DUPLICATE: pipe_A22			= "Invalid",
}

this.intelRadioList_enemy2nd = {
	type_enemy			= "s0115_esrg1100",
}

this.intelRadioList_enemyInvalid = {
	type_enemy			= "Invalid",
}

this.intelRadioList_hostage2nd = {
	hos_s10115_0000		= "s0115_esrg1050",
	hos_s10115_0001		= "s0115_esrg1050",
	hos_s10115_0002		= "s0115_esrg1050",
	hos_s10115_0003		= "s0115_esrg1050",
	hos_s10115_0004		= "s0115_esrg1050",
	hos_s10115_0005		= "s0115_esrg1050",
}

this.intelRadioList_hostage3rd = {
	hos_s10115_0000		= "s0115_esrg1060",
	hos_s10115_0001		= "s0115_esrg1060",
	hos_s10115_0002		= "s0115_esrg1060",
	hos_s10115_0003		= "s0115_esrg1060",
	hos_s10115_0004		= "s0115_esrg1060",
	hos_s10115_0005		= "s0115_esrg1060",
}

this.intelRadioList_hostageInvalid = {
	hos_s10115_0000		= "Invalid",
	hos_s10115_0001		= "Invalid",
	hos_s10115_0002		= "Invalid",
	hos_s10115_0003		= "Invalid",
	hos_s10115_0004		= "Invalid",
	hos_s10115_0005		= "Invalid",
}

this.intelRadioList_targetActive = {
	ly003_cl02_10115_npc0000__cl02pl0_uq_0020_npc__sol_plnt0_0000	= "s0115_esrg2010",
}

this.intelRadioList_targetInvalid = {
	ly003_cl02_10115_npc0000__cl02pl0_uq_0020_npc__sol_plnt0_0000	= "Invalid",
}





this.MissionStart = function()
	Fox.Log("#### s10115_radio.MissionStart ####")
	TppRadio.Play( { "s0115_rtrg1010", "s0115_rtrg1020", "s0115_rtrg1030",}, { delayTime = "short"})
end


this.RescueLastHostage = function()
	Fox.Log("#### s10115_radio.RescueLastHostage ####")
	TppRadio.Play( { "s0115_rtrg1050", }, { delayTime = "short"} )
end


this.RescueAllHostage = function()
	Fox.Log("#### s10115_radio.RescueAllHostage ####")
	TppRadio.Play( { "s0115_rtrg1060", }, { delayTime = "short"} )
end



this.KilledHostageByEnemy = function()
	Fox.Log("#### s10115_radio.KilledHostageByEnemy ####")
	TppRadio.Play( { "s0115_rtrg1070", }, { delayTime = "short"} )
end


this.KilledLastHostageByEnemy = function()
	Fox.Log("#### s10115_radio.KilledLastHostageByEnemy ####")
	TppRadio.Play( { "s0115_rtrg1100", }, { delayTime = "short"} )
end


this.KilledAllHostageByEnemy = function()
	Fox.Log("#### s10115_radio.KilledAlltHostageByEnemy ####")
	TppRadio.Play( { "s0115_rtrg1110", }, { delayTime = "short"} )
end




this.KilledHostageByPlayer = function()
	Fox.Log("#### s10115_radio.KilledHostageByPlayer ####")
	TppRadio.Play( { "s0115_rtrg1120", }, { delayTime = "short"} )
end


this.KilledLastHostageByPlayer = function()
	Fox.Log("#### s10115_radio.KilledLastHostageByPlayer ####")
	TppRadio.Play( { "s0115_rtrg1150", }, { delayTime = "short"} )
end





this.MarkingTarget = function()
	Fox.Log("#### s10115_radio.MarkingTarget ####")
	TppRadio.Play( { "s0115_rtrg1160", }, { delayTime = "short"} )
end



this.RecognizedTarget = function()
	Fox.Log("#### s10115_radio.RecognizedTarget ####")
	TppRadio.Play( { "s0115_rtrg2010", }, { delayTime = "short"} )
end


this.RecoveredNotNoticeTarget = function()
	Fox.Log("#### s10115_radio.RecoveredNotNoticeTarget ####")
	TppRadio.Play( { "s0115_rtrg3000","s0115_rtrg3015", }, { delayTime = "long"} )
end


this.RecoveredTarget = function( isNoticeTarget )
	Fox.Log("#### s10115_radio.RecoveredTarget ####")
	if isNoticeTarget == true then
		TppRadio.Play( { "s0115_rtrg3010", }, { delayTime = "long"} )
		GkEventTimerManager.StartRaw( "radio_s0115_rtrg3010", 11 )
	else
		TppRadio.Play( { "s0115_rtrg3000", }, { delayTime = "long"} )
		GkEventTimerManager.StartRaw( "radio_s0115_rtrg3000", 10 )
	end
end


this.EliminateTarget = function()
	Fox.Log("#### s10115_radio.EliminateTarget ####")
	if mvars.isCallRadioElmTarget ~= true then
		TppRadio.Play( { "s0115_rtrg3015", }, { delayTime = "long"})
		GkEventTimerManager.StartRaw( "radio_s0115_rtrg3015", 13 )
		mvars.isCallRadioElmTarget = true
	end
end


this.AdmonishEnemy = function()
	Fox.Log("#### s10115_radio.AdmonishEnemy ####")
	TppRadio.Play( { "s0115_rtrg3030", }, { delayTime = "short"})
	GkEventTimerManager.StartRaw( "radio_s0115_rtrg3030", 17 )
end


this.EliminateAllEnemy = function()
	Fox.Log("#### s10115_radio.EliminateAllEnemy ####")
	TppRadio.Play( { "s0115_rtrg3020", }, { delayTime = "long"})
	GkEventTimerManager.StartRaw( "radio_s0115_rtrg3020", 16 )
end



this.KillTargetAndEliminateTarget = function()
	Fox.Log("#### s10115_radio.KillTargetAndEliminateAll ####")
	TppRadio.Play( { "s0115_rtrg3015","s0115_rtrg3030", }, { delayTime = "long"})
end


this.RecoveredNotNoticeTargetAndEliminateTarget = function()
	Fox.Log("#### s10115_radio.RecoveredTargetAndEliminateAll ####")
	TppRadio.Play( { "s0115_rtrg3010","s0115_rtrg3015" ,"s0115_rtrg3030", }, { delayTime = "long"})
end


this.RecoveredTargetAndEliminateTarget = function()
	Fox.Log("#### s10115_radio.RecoveredTargetAndEliminateAll ####")
	TppRadio.Play( { "s0115_rtrg3010","s0115_rtrg3030", }, { delayTime = "long"})
end


this.RecoveredTargetAndEliminateAll = function()
	Fox.Log("#### s10115_radio.RecoveredTargetAndEliminateAll ####")
	TppRadio.Play( { "s0115_rtrg3010","s0115_rtrg3020", }, { delayTime = "long"})
end



this.BlackScreenRadio = function()
	Fox.Log("#### s10115_radio.EliminateAllEnemy ####")
	TppRadio.RequestBlackTelephoneRadio( "f6000_rtrg0150" )
end





this.ChangeIntelRadio_gunMountInvalid = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_gunMountInvalid )
end

this.ChangeIntelRadio_mortarInvalid = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_mortarInvalid )
end

this.ChangeIntelRadio_antiAirGunInvalid = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_antiAirGunInvalid )
end

this.ChangeIntelRadio_eleGeneratorInvalid = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_eleGeneratorInvalid )
end

this.ChangeIntelRadio_allPipeInvalid = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_allPipeInvalid )
end

this.ChangeIntelRadio_enemy2nd = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_enemy2nd )
end

this.ChangeIntelRadio_enemyInvalid = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_enemyInvalid )
end

this.ChangeIntelRadio_hostage2nd = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_hostage2nd )
end

this.ChangeIntelRadio_hostage3rd = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_hostage3rd )
end

this.ChangeIntelRadio_hostageInvalid = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_hostageInvalid )
end

this.ChangeIntelRadio_targetActive = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_targetActive )
end

this.ChangeIntelRadio_targetInvalid = function()
	TppRadio.ChangeIntelRadio( this.intelRadioList_targetInvalid )
end



return this
