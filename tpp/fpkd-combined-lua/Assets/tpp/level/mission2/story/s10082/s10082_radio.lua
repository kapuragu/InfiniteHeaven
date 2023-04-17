local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table




this.blackTelephoneDisplaySetting = {

	f6000_rtrg0230 = {
		Japanese = {
			{ "main_3", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10082_04.ftex", 2.1 }, 
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10082_02.ftex", 10.0 }, 
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/10080/mb_photo_10080_010.ftex", 10.3 }, 
			{ "hide", "sub_1", 21.7 }, 
			{ "hide", "main_1", 22.0 }, 
			{ "main_2", "/Assets/tpp/ui/texture/Photo/tpp/10121/mb_photo_10121_010.ftex", 22.2 }, 
			{ "main_4", "/Assets/tpp/ui/texture/Photo/tpp/10082/mb_photo_10082_010.ftex", 37.3 }, 
		},
		English = {
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10082_02.ftex", 9.0 }, 
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/10080/mb_photo_10080_010.ftex", 9.3 }, 
			{ "hide", "sub_1", 18.8 }, 
			{ "hide", "main_1", 19.1 }, 
			{ "main_3", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10082_04.ftex", 2.2 }, 
			{ "main_2", "/Assets/tpp/ui/texture/Photo/tpp/10121/mb_photo_10121_010.ftex", 19.4 }, 
			{ "main_4", "/Assets/tpp/ui/texture/Photo/tpp/10082/mb_photo_10082_010.ftex", 34.7 }, 
		},
	},
}



this.radioList = {

	
	{"s0082_rtrg2010",	playOnce = false},	
	{"s0082_rtrg0010",	playOnce = false},	
	{"s0082_rtrg0030",	playOnce = false},	
	{"s0082_rtrg0040",	playOnce = false},	
	{"s0082_rtrg0050",	playOnce = false},	
	{"s0082_rtrg0060",	playOnce = false},	
	{"s0082_rtrg0070",	playOnce = false},	
	{"s0082_rtrg0080",	playOnce = false},	
	{"s0082_rtrg0090",	playOnce = false},	

}





this.optionalRadioList = {
	"Set_s0082_oprg0010",		
	"Set_s0082_oprg0020",		
	"Set_s0082_oprg0030",		
	"Set_s0082_oprg0040",
	"Set_s0082_oprg0050",
}





this.intelRadioList = {
	rds_savannah0000 = "s0082_esrg0010",
	-- wkr_WalkerGear_0000 = "s0082_esrg0020",		
	-- wkr_WalkerGear_0001 = "s0082_esrg0020",		
	-- wkr_WalkerGear_0002 = "s0082_esrg0020",		
	-- wkr_WalkerGear_0003 = "s0082_esrg0020",		
	
	--RETAILBUG: duplicate, keys differing values-v--^-
	wkr_WalkerGear_0000 = "s0082_esrg0030",
	wkr_WalkerGear_0001 = "s0082_esrg0040",		
	wkr_WalkerGear_0002 = "s0082_esrg0030",		
	wkr_WalkerGear_0003 = "s0082_esrg0040",		
	
}





this.commonRadioTable = {}

this.commonRadioTable[ TppDefine.COMMON_RADIO.TARGET_MARKED ] = TppRadio.IGNORE_COMMON_RADIO
this.commonRadioTable[ TppDefine.COMMON_RADIO.SEARCH_TARGET_ENABLED ] = TppRadio.IGNORE_COMMON_RADIO






this.MissionStart = function()
	Fox.Log("radio play : mission start")
	TppRadio.Play( "s0082_rtrg2010",{delayTime = "short"} )
	TppRadio.SetOptionalRadio( "Set_s0082_oprg0010" )	
end


this.ArrivedSavannah = function()
	Fox.Log("radio play : ArrivedSavannah")
	TppRadio.Play( "s0082_rtrg0030",{delayTime = "short"} )
	TppRadio.SetOptionalRadio( "Set_s0082_oprg0030" )	
end


this.Search_WalkerGear = function()
	Fox.Log("radio play : Search_WalkerGear")
	TppRadio.Play( "s0082_rtrg0100",{delayTime = "short"} )
end


this.Search_WalkerGear_onenemy = function()
	Fox.Log("radio play : Search_WalkerGear")
	TppRadio.Play( "s0082_rtrg0050",{delayTime = "short"} )
end


this.countermeasurewalkerGear = function()
Fox.Log("radio play : countermeasurewalkerGear")
TppRadio.SetOptionalRadio( "Set_s0082_oprg0030" )	
end


this.walkerGearBrokenCount = function()
Fox.Log("radio play : walkerGearBrokenCount")
	TppRadio.Play( "s0082_rtrg0060",{delayTime = "short"} )
end


this.walkerGearFultonCount = function()
Fox.Log("radio play : walkerGearFultonCount")
	TppRadio.Play( "s0082_rtrg0070",{delayTime = "short"} )
end


this.walkerGearBrokenCountLast = function()
	Fox.Log("#### walkerGearBrokenCount3####")
	TppRadio.Play( "s0082_rtrg0080", {delayTime = "short"} )
end


this.Continue = function()
	Fox.Log("radio play : mission start")
	TppRadio.Play( "s0082_rtrg2020",{delayTime = "short"} )

end

this.AlertOptionalRadio = function()
	Fox.Log("radio play : walkerGearFultonCount")
	TppRadio.SetOptionalRadio( "Set_s0082_oprg0020" )	
end

this.MissionClear = function()
	Fox.Log("#### MissionClear ####")
	TppRadio.Play( "s0082_rtrg0090", {delayTime = "short"} )
end


this.TelephoneRadio = function()
	TppRadio.RequestBlackTelephoneRadio( "f6000_rtrg0230" )
end




return this
