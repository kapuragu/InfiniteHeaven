local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table




this.bgmList = {
        bgm_parasites = {
                start = "Play_bgm_s10040_parasites",
                finish = "Set_Switch_bgm_s10040_parasites_ed",
                restore = "Set_Switch_bgm_s10040_parasites_op",
				switch = {
					"Set_Switch_bgm_s10040_parasites_op",
					"Set_Switch_bgm_s10040_parasites_sn",
					"Set_Switch_bgm_s10040_parasites_al",
					"Set_Switch_bgm_s10040_parasites_ed",
				},
        },
}

this.BGMParasitesOP = function()
		Fox.Log("BGM :: parasite")
		TppSound.SetSceneBGM("bgm_parasites")
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10040_parasites_op")
end
this.BGMParasitesSneek = function()
		Fox.Log("BGM :: parasite SNEEK")
		TppSound.SetSceneBGM("bgm_parasites")
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10040_parasites_sn")
end

this.BGMParasitesAlert = function()
		Fox.Log("BGM :: parasite ALERT")
		TppSound.SetSceneBGM("bgm_parasites")
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10040_parasites_al")
end

this.BGMParasitesEnd = function()
		Fox.Log("BGM :: parasite END")
		TppSound.StopSceneBGM("bgm_parasites")--RETAILBUG: func doesnt take any params
end

this.BGMChangePhaseLevel1 = function()
	Fox.Log("set phase BGM level 1")
	TppSound.SetPhaseBGM( "bgm_cave_level1" )
end

this.BGMChangePhaseLevel2 = function()
	Fox.Log("set phase BGM level 2")
	TppSound.SetPhaseBGM( "bgm_cave_level2" )
end

this.BGMPhaseReset = function()
	Fox.Log("reset bgm")
	TppSound.ResetPhaseBGM()
end



function this.MissionOpeningSoundSetting()
	
	
end




function this.GameOverSoundSetting()
	
	
	
end




function this.MissionClearJingleSetting()
	
	
end




return this
