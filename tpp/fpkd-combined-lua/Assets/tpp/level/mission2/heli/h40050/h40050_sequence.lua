local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}
















function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		


		
		"Seq_Game_MainGame",
		"Seq_Game_MissionClear",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end
































































function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	
	
		
		
		
	
	
	local systemCallbackTable ={
		OnEstablishMissionClear = function()
			TppMission.MissionFinalize{ isFadeOut = true }
		end,
		OnEndMissionCredit = function()
			TppMission.MissionFinalize{ isFadeOut = true }
		end,
		OnEndMissionReward = function()
			TppMission.MissionFinalize{ isFadeOut = true }
		end,
		OnGameOver = function()
		end,
		nil
	}
	
	TppMission.RegiserMissionSystemCallback(systemCallbackTable)

end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
end








function this.Messages()
	return
	StrCode32Table {
	
		
		Terminal = {
			{ msg = "MbDvcActAcceptMissionList", func = function( arg0, arg1 ) Fox.Log(arg0) Fox.Log(arg1) end, }
		},
		
	}
end





sequences.Seq_Demo_Opening = {

	OnEnter = function ()
	end,

	OnLeave = function ()
	end,

}

sequences.Seq_Game_MainGame = {
	
	Messages = function( self ) 
		return
		StrCode32Table {
			
			
			Terminal = {
				{
				
					msg = "MbDvcActOpenTop",
					func = function()
						
						if gvars.rad_isFinishMissionListTutorial ~= true then
							
							hlsp_common_radio.MissionListGuide10()--RETAILBUG: should be heli_common_radio
						end
					end
				},
			},
			Radio = {
				{
					
					msg = "Finish",
					sender = "TOMB6000_121010",
					func = function()
						
						gvars.rad_isFinishMissionListTutorial = true

						
						
							
						
							
							return
					end
				},
			nil
			}
		}
	end,


	OnEnter = function ()
		
		if gvars.rad_isFinishMissionListTutorial ~= true then
			
			hlsp_common_radio.MissionListGuide00()--RETAILBUG: should be heli_common_radio
		end
	end,

	OnLeave = function ()
	end,

}



sequences.Seq_Game_MissionClear = {

	OnEnter = function ()
		
		
		local requestedMission = 10033	

		TppMission.ReserveMissionClear{
		nextMissionId = requestedMission ,
		missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER
		}
	end,
	OnLeave = function ()
	end,
}




return this