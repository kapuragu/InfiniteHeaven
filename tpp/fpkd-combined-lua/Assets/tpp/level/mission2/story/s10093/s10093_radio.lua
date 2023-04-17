local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

this.requires = {}


this.OPTIONALRADIO_NAME = {
	MISSION_START		= "Set_s0093_oprg0011",
	REMAINING_ONE		= "Set_s0093_oprg3010",
	MISSION_COMPLETE	= "Set_s0093_oprg4010",
}




this.radioList = {
	"s0093_rtrg0010",	
	"s0093_rtrg0011",	
	"s0093_rtrg0029",	
	"s0093_rtrg0032", 	
	"s0093_rtrg0034",	
	"s0093_rtrg0036",	
	"s0093_rtrg4010",	
	"f1000_rtrg2500",	
	"s0093_rtrg0020",	
	"s0093_rtrg2010",	
	"f1000_rtrg3095",	
	"s0093_rtrg3010",	
	"s0093_rtrg3020",	
	"s0093_rtrg3022",	
	"s0093_rtrg4020",	
	"s0093_rtrg1010",	
	"f1000_rtrg1720",	
	"f1000_rtrg0155",	
	"f1000_mprg0170",	
	"f1000_mprg0095",	
	"f8000_gmov9090",	
	"s0093_mirg0010",	
	"s0093_mirg0020",	
	"s0093_rtrg4100",	
	"f1000_rtrg1375",	
	"s0093_rtrg0040",	
	"s0093_rtrg0041",	
	"s0093_rtrg0042",	

}

this.debugRadioLineTable = {
	
	enemyRouteChange_Trap = {
		"[dbg]敵ＣＰ：コンテナ周辺警備の増員を行う。",
		"[dbg]敵ＣＰ：建造物側警備員は速やかにコンテナ警備に向かえ。",
	},

}

this.optionalRadioList = {
	this.OPTIONALRADIO_NAME.MISSION_START ,
	this.OPTIONALRADIO_NAME.REMAINING_ONE ,
	this.OPTIONALRADIO_NAME.MISSION_COMPLETE ,
}

this.intelRadioList = {
	type_container				= "s0093_esrg0011",		
	type_enemy					= "f1000_esrg0460",		
	rds_lab_tent0000			= "f1000_esrg1600",		
	rds_lab_intfile0000			= "f1000_esrg0640",		
	rds_lab_intfile0001			= "f1000_esrg0640",		
}




this.blackTelephoneDisplaySetting = {
	f6000_rtrg0240  = {
		Japanese = {
			{ "sub_3", "/Assets/tpp/ui/texture/Photo/tpp/10093/mb_photo_10093_010_1.ftex", 0.6 }, 
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10093/mb_photo_10093_020_1.ftex", 0.9 }, 
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10093_04.ftex", 4.4 }, 
			{ "sub_2", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10093_01.ftex", 8.5, "cast_code_talker" }, 
		},
		English = {
			{ "sub_3", "/Assets/tpp/ui/texture/Photo/tpp/10093/mb_photo_10093_010_1.ftex", 0.6 }, 
			{ "sub_1", "/Assets/tpp/ui/texture/Photo/tpp/10093/mb_photo_10093_020_1.ftex", 0.9 }, 
			{ "main_1", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10093_04.ftex", 4.9 }, 
			{ "sub_2", "/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10093_01.ftex", 9.9, "cast_code_talker"  }, 
		},
	},
}





this.OnLoad = function()
	Fox.Log("#### OnLoad ####")


end

this.OnUpdate = function ()
end











this.ContainerMarkerFollow = function()
	Fox.Log("#### s10093_radio.ContainerMarkerFollow ####")
	TppRadio.Play( "s0093_rtrg2010" )
end


this.ContainerNoMarker = function()
	Fox.Log("#### s10093_radio.ContainerNoMarker ####")
	TppRadio.Play( "f1000_rtrg3095" )
end


this.EnemyShiftGet = function()
	Fox.Log("#### s10093_radio.EnemyShiftGet ####")
	TppRadio.Play( "f1000_rtrg0155" )
end


this.JungleTalk = function()
	Fox.Log("#### s10093_radio.JungleTalk ####")
	TppRadio.Play( "s0093_rtrg0034" )
end


this.JungleTalkAfter = function()
	Fox.Log("#### s10093_radio.JungleTalkAfter ####")
	TppRadio.Play( "s0093_rtrg0036" )
end


this.EnemyInterrogationKazuFollow = function()
	Fox.Log("#### s10093_radio.EnemyInterrogationKazuFollow ####")
	TppRadio.Play( "s0093_rtrg1010" )
end


this.EmergencyCall = function()
	Fox.Log("#### s10093_radio.EmergencyCall ####")
	TppRadio.Play( "s0093_rtrg3020" )
end


this.XOFHeliNoStop = function()
	Fox.Log("#### s10093_radio.XOFHeliNoStop ####")
	TppRadio.Play( "s0093_rtrg3022" )
end


this.ContainerGetTeam_B2 = function()
	Fox.Log("#### s10093_radio.ContainerGetTeam_B2 ####")
	TppRadio.Play( "s0093_rtrg4020" )
end


this.MoreTimeOver01 = function()
	Fox.Log("#### s10093_radio.MoreTimeOver01 ####")
	TppRadio.Play( "s0093_rtrg0040" )
end


this.MoreTimeOver02 = function()
	Fox.Log("#### s10093_radio.MoreTimeOver02 ####")
	TppRadio.Play( "s0093_rtrg0041" )
end


this.MoreTimeOver03 = function()
	Fox.Log("#### s10093_radio.MoreTimeOver03 ####")
	TppRadio.Play( "s0093_rtrg0042" )
end


this.InterrogationUrged = function()
	Fox.Log("#### s10093_radio.InterrogationUrged ####")
	TppRadio.Play( "s0093_rtrg0032" )
end


this.ForEnemyHeli = function()
	Fox.Log("#### s10093_radio.ForEnemyHeli ####")
	TppRadio.Play( "s0093_rtrg0029" )
end



this.OnGameCleared = function()
	Fox.Log("#### s10093_radio.OnGameCleared ####")
	TppRadio.RequestBlackTelephoneRadio( "f6000_rtrg0240" )
end






this.MissionStart = function()
	Fox.Log("#### s10093_radio.MissionStart ####")
	TppRadio.Play( "s0093_rtrg0010" )
end


this.CargoFulton = function()
	Fox.Log("#### s10093_radio.CargoFulton ####")
	TppRadio.Play( "s0093_rtrg0011" )
end

this.ContinueMissionStart = function()
	Fox.Log("#### s10093_radio.ContinueMissionStart ####")
	TppRadio.Play( "s0093_rtrg4100" )
end


this.EnemyRouteChangeE = function()
	Fox.Log("#### s10093_radio.EnemyRouteChangeE ####")
	local gameObjectId = GameObject.GetGameObjectId( "mafr_lab_cp" )
	local command = { id = "RequestRadio", label="CPR0570FOB", memberId=memberGameObjectId }--RETAILBUG: memberGameObjectId undefined
	GameObject.SendCommand( gameObjectId, command )
end

this.EnemyRouteChangeK = function()
	Fox.Log("#### s10093_radio.EnemyRouteChangeK ####")
	TppRadio.Play( "s0093_rtrg0020" )
end



this.GetContainer_1st = function()
	Fox.Log("#### s10093_radio.GetContainer_1st ####")
	TppRadio.Play( "s0093_rtrg3010" )
end



this.ClearText = function()
	Fox.Log("#### s10093_radio.ClearText ####")
	TppRadio.Play( "s0093_rtrg4010" )
end

this.ContinueClearText = function()
	Fox.Log("#### s10093_radio.ContinueClearText ####")
	TppRadio.Play( "f1000_rtrg1375" )
end



this.MissionFailedTimeOver = function()
	Fox.Log("#### s10093_radio.MissionFailedTimeOver ####")
	TppRadio.Play( "f8000_gmov9090" )
end


this.MissionFailedContainerBreak = function()
	Fox.Log("#### s10093_radio.MissionFailedContainerBreak ####")
	TppRadio.Play( "f8000_gmov9090" )
end












return this
