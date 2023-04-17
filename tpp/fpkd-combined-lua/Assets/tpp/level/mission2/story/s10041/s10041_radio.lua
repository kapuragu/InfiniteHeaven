local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table





this.GetVipIdentifiedRadio = function()
	Fox.Log("#### s10041_radio.GetVipIdentifiedRadio  ####")
	if svars.VipIdentified == 0 then  
	 	Fox.Log("#### Found Vip First f1000_rtrg2200 ####")
		svars.VipIdentified =svars.VipIdentified + 1	
		return "f1000_rtrg2200"
	elseif svars.VipIdentified == 1 then   
	   	Fox.Log("#### Found Vip Second 　f1000_rtrg2175 ####")
		svars.VipIdentified =svars.VipIdentified + 1	

		return "f1000_rtrg2175"
	elseif svars.VipIdentified == 2 then   
	   	Fox.Log("#### Found Vip third 　f1000_rtrg2170 ####")
		svars.VipIdentified =svars.VipIdentified + 1	

		return "f1000_rtrg2170"
	else 
	   	Fox.Log("#### Found Vip over 3 times illegal　f1000_rtrg2171  ####")
		return "f1000_rtrg2171" 	
	end


end

this.commonRadioTable = {


























	[ TppDefine.COMMON_RADIO.TARGET_RECOVERED  ] 			= TppRadio.IGNORE_COMMON_RADIO,		
	[ TppDefine.COMMON_RADIO.TARGET_ELIMINATED	] 			= TppRadio.IGNORE_COMMON_RADIO,		
}

	
this.commonRadioTable[ TppDefine.COMMON_RADIO.SEARCH_TARGET_ENABLED ] = this.GetVipIdentifiedRadio




this.ENEMY_NAME				= {
	FIELD_VIP				= "sol_vip_field",						
	ENEMYBASE_VIP			= "sol_vip_enemyBase",					
	SLOPEDTOWN_VIP			= "sol_vip_slopedTown",					
}

this.radioList = {
	
	{ "s0041_esrg0010", playOnce = false },	
	{ "s0041_esrg0020", playOnce = false },	
	{ "f1000_esrg0600", playOnce = false },	
	{ "f1000_esrg0610", playOnce = false },	
	{ "s0041_mirg0010", playOnce = false },	
	{ "s0041_mirg0020", playOnce = false },	
	{ "s0041_mirg0030", playOnce = false },	
	{ "s0041_mirg0040", playOnce = false },	
	{ "s0041_mprg0010", playOnce = false },	
	{ "s0041_mprg0020", playOnce = false },	
	{ "s0041_mprg0030", playOnce = false },	
	{ "s0041_mprg0031", playOnce = false },	
	{ "s0041_mprg0032", playOnce = false },	

	{ "s0041_oprg0010", playOnce = false },	
	{ "s0041_oprg0020", playOnce = false },	
	{ "s0041_oprg0030", playOnce = false },	
	{ "s0041_oprg0040", playOnce = false },	
	{ "s0041_rtrg0010", playOnce = false },	
	{ "s0041_rtrg0020", playOnce = false },	
	{ "s0041_rtrg0030", playOnce = false },	
	{ "s0041_rtrg0037", playOnce = false },	

	{ "s0041_rtrg0031", playOnce = false },	
	{ "s0041_rtrg0032", playOnce = false },	



	{ "s0041_rtrg0040", playOnce = false },	
	{ "s0041_rtrg0041", playOnce = false },	

	{ "f1000_rtrg2510", playOnce = false },	
	{ "s0041_rtrg0051", playOnce = false },	

	{ "f1000_rtrg2520", playOnce = false },	
	{ "s0041_rtrg0061", playOnce = false },	

	{ "s0041_rtrg0033", playOnce = false },	
	{ "s0041_rtrg0034", playOnce = false },	

	{ "f1000_rtrg2630", playOnce = false },	
	{ "s0041_rtrg0071", playOnce = false },	

	{ "f1000_rtrg2610", playOnce = false },	
	{ "s0041_rtrg0072", playOnce = false },	

	{ "s0041_rtrg0035", playOnce = false },	
	{ "s0041_rtrg0036", playOnce = false },	

	{ "f1000_mprg0260", playOnce = false },	
	{ "f1000_esrg1100", playOnce = false },	

	{ "f1000_rtrg7010", playOnce = false },	
	{ "s0041_rtrg0080", playOnce = false },	
	{ "s0041_rtrg0090", playOnce = false },	
	{ "f1000_rtrg2170", playOnce = false },	
	{ "f1000_rtrg2200", playOnce = false },	
	{ "f1000_rtrg2175", playOnce = false },	
	{ "f1000_rtrg2171", playOnce = false },	


	{ "f1000_rtrg2120", playOnce = false },	
	{ "f1000_rtrg2090", playOnce = false },	
	{ "f1000_rtrg2095", playOnce = false },	
	{ "f1000_esrg0780", playOnce = false },	
	{ "f1000_mprg0210", playOnce = false },	
	{ "f1000_mprg0080", playOnce = false },	
	{ "f1000_mprg0075", playOnce = false },	
	{ "f1000_mprg0070", playOnce = false },	
	{ "s0041_rtrg0120", playOnce = false },	


}


this.USE_COMMON_RESULT_RADIO = true




this.blackTelephoneDisplaySetting = {


	f6000_rtrg0010 = {
		Japanese = {
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_020_1.ftex", 0.6, "cast_da_shago_kallai_platoon_cmdr", },
			{ "sub_2", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_030_1.ftex", 0.9, "cast_da_wialo_kallai_company_cmdr", },
			{ "sub_3", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_040_1.ftex", 1.2, "cast_wakh_sind_barracks_platoon_cmdr", },
		},
		English = {
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_020_1.ftex", 0.6, "cast_da_shago_kallai_platoon_cmdr", },
			{ "sub_2", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_030_1.ftex", 0.9, "cast_da_wialo_kallai_company_cmdr", },
			{ "sub_3", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_040_1.ftex", 1.2, "cast_wakh_sind_barracks_platoon_cmdr", },
		},
	},
	f6000_rtrg0020 = {
		Japanese = {
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_020_1.ftex", 0.6, "cast_da_shago_kallai_platoon_cmdr", },
			{ "sub_2", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_030_1.ftex", 0.9, "cast_da_wialo_kallai_company_cmdr", },
			{ "sub_3", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_040_1.ftex", 1.2, "cast_wakh_sind_barracks_platoon_cmdr", },
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10041.ftex", 8.0 },
		},
		English = {
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_020_1.ftex", 0.6, "cast_da_shago_kallai_platoon_cmdr", },
			{ "sub_2", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_030_1.ftex", 0.9, "cast_da_wialo_kallai_company_cmdr", },
			{ "sub_3", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_040_1.ftex", 1.2, "cast_wakh_sind_barracks_platoon_cmdr", },
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10041.ftex", 6.5 },
		},
	},
	f6000_rtrg0030 = {
		Japanese = {
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_020_1.ftex", 0.6, "cast_da_shago_kallai_platoon_cmdr", },
			{ "sub_2", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_030_1.ftex", 0.9, "cast_da_wialo_kallai_company_cmdr", },
			{ "sub_3", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_040_1.ftex", 1.2, "cast_wakh_sind_barracks_platoon_cmdr", },
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10041.ftex", 8.0 },
		},
		English = {
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_020_1.ftex", 0.6, "cast_da_shago_kallai_platoon_cmdr", },
			{ "sub_2", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_030_1.ftex", 0.9, "cast_da_wialo_kallai_company_cmdr", },
			{ "sub_3", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_040_1.ftex", 1.2, "cast_wakh_sind_barracks_platoon_cmdr", },
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10041.ftex", 6.5 },
		},
	},
	f6000_rtrg0040 = {
		Japanese = {
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_020_1.ftex", 0.6, "cast_da_shago_kallai_platoon_cmdr", },
			{ "sub_2", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_030_1.ftex", 0.9, "cast_da_wialo_kallai_company_cmdr", },
			{ "sub_3", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_040_1.ftex", 1.2, "cast_wakh_sind_barracks_platoon_cmdr", },
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10041.ftex", 8.0 },
		},
		English = {
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_020_1.ftex", 0.6, "cast_da_shago_kallai_platoon_cmdr", },
			{ "sub_2", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_030_1.ftex", 0.9, "cast_da_wialo_kallai_company_cmdr", },
			{ "sub_3", "/Assets/tpp/ui/texture/Photo/tpp/10041/mb_photo_10041_040_1.ftex", 1.2, "cast_wakh_sind_barracks_platoon_cmdr", },
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10041.ftex", 6.5 },
		},
	},

}




this.optionalRadioList	= {
	"Set_s0041_oprg0010",	
	"Set_s0041_oprg0020",	
	"Set_s0041_oprg0030",	
	"Set_s0041_oprg0040",	
	"Set_s0041_oprg0050",	

}







this.intelRadioList = {
	rds_village_meeting_point	= "s0041_esrg0020",	
	sol_vip_field				= "f1000_esrg0600",		
	sol_vip_village				= "f1000_esrg0600",		
	sol_vip_enemyBase			= "f1000_esrg0600",		

	rds_ruinsNorth_0000= "s0041_esrg0010",		

}

this.intelRadioListGualdEliminated = {	
	rds_village_meeting_point				= "s0041_esrg0010",			
}






this.intelRadioListAbortMeeting = {	
	rds_village_meeting_point				= "s0041_esrg0010",			
}


this.intelRadioListFieldVipIdentified = {
	sol_vip_field			= "f1000_esrg0610",			
}
this.intelRadioListVillageVipIdentified = {
	sol_vip_village			= "f1000_esrg0610",			
}
this.intelRadioListEnemyBaseVipIdentified = {
	sol_vip_enemyBase			= "f1000_esrg0610",			
}





this.MissionStart = function()
	local radioGroups

	
	if TppSequence.GetContinueCount() == 0 then	
		Fox.Log("#### StartFirst s0041_rtrg0010 s0041_rtrg0020 ####")
		radioGroups = {  "s0041_rtrg0010" }	


	else	
		radioGroups = this.SetContinueRadio()	
	end

	
	if svars.isMeetingAborted == false then	
		Fox.Log("#### set Set_s0041_oprg0010 ####")
		TppRadio.SetOptionalRadio( "Set_s0041_oprg0010" )
	else	
		if isTargetRemain ==0 then--RETAILBUG: isTargetRemain undefined
			Fox.Log("#### set Set_s0041_oprg0030 ####")
			TppRadio.SetOptionalRadio( "Set_s0041_oprg0030" )
		else							
			Fox.Log("#### set Set_s0041_oprg0020 ####")
			TppRadio.SetOptionalRadio( "Set_s0041_oprg0020" )
		end
	end
	
	TppRadioCommand.SetEnableEspionageRadioTarget{
		name= {
			"rds_village_meeting_point",
			"sol_vip_field",
			"sol_vip_village",
			"sol_vip_enemyBase" ,
		
		}, enable = true
	}

	return radioGroups
end

function this.SetContinueRadio()
	Fox.Log("#### s0041_radio.SetContinueRadio ####")

	local radioGroups
	local isTargetRemain	=3

	if	TppEnemy.IsEliminated(s10041_enemy.ENEMY_NAME.FIELD_VIP) == true then
		isTargetRemain = isTargetRemain -1


		TppMission.UpdateObjective{objectives = { "task1_complete",nil },}	
	end
	if	TppEnemy.IsEliminated(s10041_enemy.ENEMY_NAME.ENEMYBASE_VIP) == true then
		isTargetRemain = isTargetRemain -1

		TppMission.UpdateObjective{objectives = { "task2_complete" ,nil },}	
	end
	if	TppEnemy.IsEliminated(s10041_enemy.ENEMY_NAME.VILLAGE_VIP) == true then
		isTargetRemain = isTargetRemain -1

		TppMission.UpdateObjective{objectives = { "task0_complete",nil	},}	
	end

	if isTargetRemain ==0 then		

		Fox.Log("#### StartContinue Eliminate Vip 2  f1000_rtrg7010 ####")
		radioGroups = "f1000_rtrg7010" 
	elseif isTargetRemain ==1 then	
		Fox.Log("#### StartContinue Eliminate Vip 2  s0041_rtrg0090 ####")
		radioGroups = "s0041_rtrg0090" 
	elseif isTargetRemain ==2 then	
		Fox.Log("#### StartContinue Eliminate Vip 1 play s0041_rtrg0080 ####")
		radioGroups = "s0041_rtrg0080" 
	else							
		Fox.Log("#### StartContinue Eliminate Vip 0 play  s0041_rtrg0010 s0041_rtrg0020  ####")
		radioGroups = { "s0041_rtrg0010", "s0041_rtrg0020" }	
	end
	return radioGroups

end











this.VipKill_1 = function()
	Fox.Log("#### VipKill_1 s0041_rtrg0030 ####")
	TppRadio.Play( "s0041_rtrg0030",{ delayTime = "mid", isEnqueue = true })










end
this.VipKillNotIdentified_1 = function()
	Fox.Log("#### VipKillNotIdentified_1 s0041_rtrg0037 ####")
	TppRadio.Play( "s0041_rtrg0037", { delayTime = "mid", isEnqueue = true })









end
this.VipFullton_1 = function()
	Fox.Log("#### VipFullton_1 s0041_rtrg0040 ####")
	TppRadio.Play( "s0041_rtrg0040",{ delayTime = "mid", isEnqueue = true })











end
this.VipFulltonNotIdentified_1 = function()
	Fox.Log("#### VipFulltonNotIdentified_1 s0041_rtrg0041 ####")
	TppRadio.Play( "s0041_rtrg0041",{ delayTime = "mid", isEnqueue = true })










end

this.VipFulltonFailed_1 = function()
	Fox.Log("#### VipFulltonFailed_1 s0041_rtrg0032 ####")
	TppRadio.Play( "s0041_rtrg0032",{ delayTime = "long", isEnqueue = true } )










end
this.VipFulltonFailedNotIdentified_1 = function()
	Fox.Log("#### VipFulltonFailedNotIdentified_1 s0041_rtrg0031 ####")
	TppRadio.Play( "s0041_rtrg0031",{ delayTime = "long", isEnqueue = true })










end

this.VipKill_2 = function()
	Fox.Log("#### VipKill_2  f1000_rtrg2510 ####")
	TppRadio.Play( "f1000_rtrg2510",{ delayTime = "mid", isEnqueue = true } )	









end
this.VipKillNotIdentified_2 = function()
	Fox.Log("#### VipKillNotIdentified_2  s0041_rtrg0051 ####")
	TppRadio.Play( "s0041_rtrg0051",{ delayTime = "mid", isEnqueue = true })	









end
this.VipFullton_2 = function()
	Fox.Log("#### VipFullton_2  f1000_rtrg2520 ####")
	TppRadio.Play( "f1000_rtrg2520",{ delayTime = "long", isEnqueue = true } )









end
this.VipFulltonNotIdentified_2 = function()
	Fox.Log("#### VipFulltonNotIdentified_2  s0041_rtrg0061 ####")
	TppRadio.Play( "s0041_rtrg0061",{delayTime = "long", isEnqueue = true} )









end

this.VipFulltonFailed_2 = function()
	Fox.Log("#### VipFulltonFailed_2 s0041_rtrg0034 ####")
	TppRadio.Play( "s0041_rtrg0034",{delayTime = "long", isEnqueue = true } )











end
this.VipFulltonFailedNotIdentified_2 = function()
	Fox.Log("#### VipFulltonFailedNotIdentified_2 s0041_rtrg0033 ####")
	TppRadio.Play( "s0041_rtrg0033", {delayTime = "long", isEnqueue = true} )










end

this.AboutHostage = function()
	if svars.isAboutHostage		== false then	
		s10041_sequence.DeleteHighInterrogationAboutHostage()	
		svars.isAboutHostage	=true
		Fox.Log("#### about hostage f1000_esrg0780 ####")
		TppRadio.Play( "f1000_esrg0780",{delayTime = "short"} )
	end
end



this.FoundFieldVip = function()
	Fox.Log("####  intel radio change  Field Vip ####")
	svars.isIdentifiedFieldVip = true

	TppRadio.ChangeIntelRadio( s10041_radio.intelRadioListFieldVipIdentified )
	s10041_sequence.DeleteHighInterrogationField()	
end

this.FoundVillageVip = function()
	Fox.Log("####  intel radio change  VillageVip ####")

	svars.isIdentifiedVillageVip = true

	TppRadio.ChangeIntelRadio( s10041_radio.intelRadioListVillageVipIdentified )
	s10041_sequence.DeleteHighInterrogationVillageVipAll()
end

this.FoundEnemyBaseVip = function()
	Fox.Log("#### intel radio change EnemyBase Vip ####")
	svars.isIdentifiedEnemyBaseVip = true

	TppRadio.ChangeIntelRadio( s10041_radio.intelRadioListEnemyBaseVipIdentified )

	s10041_sequence.DeleteHighInterrogationEnemyBase()
end

this.MissionStartOptional = function()
	Fox.Log("#### s0041_rtrg0020 ####")
	TppRadio.SetOptionalRadio( "s0041_rtrg0020")
end

this.PlayAbortMeeting = function(strSoldierName, strSpeech)
	Fox.Log("Soldier A tell to friend to abort meeting")
	
	this.PlaySpeech{
		speakerName = strSoldierName,
		speakerType = "TppSoldier2",
		
	}
end


this.EspionageMeetingPointBeforeMeeting = function()
	Fox.Log("#### s0041_esrg0020 ####")
	TppRadio.Play( "s0041_esrg0020" ,{delayTime = "mid"} )	
end

this.AboutVehicle = function()
	Fox.Log("#### AboutVehicle  ####")
	TppRadio.Play( "f1000_esrg1100",{delayTime = "short"} )
end



this.TelephoneRadioAllVipDeid = function()	
	TppRadio.RequestBlackTelephoneRadio( "f6000_rtrg0010" )
end


this.TelephoneRadioVipFullton = function()
	TppRadio.RequestBlackTelephoneRadio( "f6000_rtrg0020" )
end

this.TelephoneRadioMeetingFinished = function()
	TppRadio.RequestBlackTelephoneRadio( "f6000_rtrg0030" )
end

this.TelephoneRadioSetMine = function()
	TppRadio.RequestBlackTelephoneRadio( "f6000_rtrg0040" )
end



this.EscapeStartRadio = function()
	Fox.Log("#### s10041_radio.EscapeStartRadio  ####")

	local radioGroups
	
	if TppSequence.GetContinueCount() == 0 then	
		
		if mvars.EscapeRadioGroups == s10041_sequence.vipKillType.KILL_IDENTIFIED then						
			Fox.Log("#### Eliminate Vip 3  KILL_IDENTIFIED  f1000_rtrg2630 ####")
			radioGroups = "f1000_rtrg2630" 
		elseif mvars.EscapeRadioGroups == s10041_sequence.vipKillType.FULLTON_IDENTIFIED then				
			Fox.Log("#### Eliminate Vip 3 FULLTON_IDENTIFIED f1000_rtrg2610 ####")
			radioGroups = "f1000_rtrg2610" 
		elseif mvars.EscapeRadioGroups == s10041_sequence.vipKillType.HELI_IDENTIFIED then					
			Fox.Log("#### Eliminate Vip 3 HELI_IDENTIFIED f1000_rtrg2620 ####")
			radioGroups = "f1000_rtrg2620" 

		elseif mvars.EscapeRadioGroups == s10041_sequence.vipKillType.FULLTON_FAILED_IDENTIFIED then		
			Fox.Log("#### Eliminate Vip 3 FULLTON_FAILED_IDENTIFIED s0041_rtrg0036 ####")
			radioGroups = "s0041_rtrg0036" 
		elseif mvars.EscapeRadioGroups == s10041_sequence.vipKillType.KILL_NOT_IDENTIFIED then				
			Fox.Log("#### Eliminate Vip 3 KILL_NOT_IDENTIFIED s0041_rtrg0071 ####")
			radioGroups = "s0041_rtrg0071" 
		elseif mvars.EscapeRadioGroups == s10041_sequence.vipKillType.FULLTON_NOT_IDENTIFIED then				
			Fox.Log("#### Eliminate Vip 3 FULLTON_NOT_IDENTIFIED s0041_rtrg0072 ####")
			radioGroups = "s0041_rtrg0072" 
		elseif EliminateRadioType == s10041_sequence.vipKillType.HELI_NOT_IDENTIFIED then	--RETAILBUG: EliminateRadioType undefined		
			Fox.Log("#### Eliminate Vip 3 HELI_NOT_IDENTIFIED s0041_rtrg0073 ####")
			radioGroups = "s0041_rtrg0073" 
		elseif mvars.EscapeRadioGroups == s10041_sequence.vipKillType.FULLTON_FAILED_NOT_IDENTIFIED then	
			Fox.Log("#### Eliminate Vip 3 FULLTON_FAILED_NOT_IDENTIFIED s0041_rtrg0035 ####")
			radioGroups = "s0041_rtrg0035" 
		else
			Fox.Log( "### Error Illegal target kill type Set Default Radio f1000_rtrg7010 ###")	
			radioGroups = "f1000_rtrg7010" 
		end
	else	
		Fox.Log("#### StartContinue Eliminate Vip 3  f1000_rtrg7010 ####")
		radioGroups = "f1000_rtrg7010" 

	end


	return radioGroups
end








return this
