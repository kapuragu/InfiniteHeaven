local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table




this.commonRadioTable = {}

this.GetRadioGroup = function()
	if svars.isAppearanceParasites and svars.isDyingAllParasites == false then   
		return
	end
	return "f1000_rtrg8030"
end
this.commonRadioTable[ TppDefine.COMMON_RADIO.OUTSIDE_HOTZONE ] = this.GetRadioGroup



this.radioList = {
	
	{ "s0090_rtrg0020" , playOnce = true },	
	{ "s0090_rtrg0030" , playOnce = true },	
	{ "s0090_rtrg0040" , playOnce = true },	
	{ "s0090_rtrg0045" , playOnce = true },	
	{ "s0090_rtrg0050" , playOnce = true },	
	{ "f1000_rtrg3095" },	
	{ "s0090_rtrg0060" , playOnce = true },	
	{ "s0090_rtrg0070" , playOnce = true },	
	{ "s0090_rtrg0080" , playOnce = true },	
	{ "s0090_rtrg0090" , playOnce = true },	
	{ "s0090_rtrg0095" , playOnce = true },	
	{ "s0090_rtrg0100" , playOnce = true },	
	{ "s0090_rtrg0110" , playOnce = true },	
	{ "s0090_rtrg0120" , playOnce = true },	
	{ "s0090_rtrg0190" , playOnce = true },	
	{ "s0090_rtrg0230" , playOnce = true },	
	{ "s0090_rtrg0180" , playOnce = true },	
	{ "s0090_rtrg0240" , playOnce = true },	
	{ "s0090_rtrg0250" , playOnce = true },	
	
	{ "s0090_rtrg0280" , playOnce = true },	
	{ "s0090_rtrg0290" , playOnce = true },	
	{ "s0090_rtrg0300" , playOnce = true },	
	{ "s0090_rtrg0330" , playOnce = true },	
	{ "s0090_rtrg0340" , playOnce = true },	
	{ "s0090_rtrg0345" , playOnce = true },	
	{ "s0090_rtrg0200" , playOnce = true },	
	{ "s0090_rtrg0350" , playOnce = true },	
	{ "s0090_rtrg0220" , playOnce = true },	

	
	{ "s0090_rtrg0260" , playOnce = true },	
	{ "s0090_rtrg0360" , playOnce = true },	
	{ "s0090_rtrg0380" , playOnce = true },	
	{ "s0090_rtrg0370" },	
	{ "s0090_rtrg0390" },	
	
	{ "s0090_rtrg0150" , playOnce = true },	
	{ "s0090_rtrg0270" , playOnce = true },	
	{ "s0090_rtrg0130" , playOnce = true },	
	{ "f1000_rtrg1395" },	
	
	{ "s0090_rtrg0055" },	
	{ "s0090_rtrg0065" },	
	{ "s0090_rtrg0375" },	
}





this.gameOverRadioTable = {}
this.gameOverRadioTable[ TppDefine.GAME_OVER_RADIO.S10090_TARGET_DEAD ]							= "f8000_gmov0240"
this.gameOverRadioTable[ TppDefine.GAME_OVER_RADIO.S10090_TARGET_DEAD_MARKING_OFF ]				= "s0090_gmov0020"
this.gameOverRadioTable[ TppDefine.GAME_OVER_RADIO.S10090_TARGET_DEAD_MARKING_ON ]				= "s0090_gmov0040"
this.gameOverRadioTable[ TppDefine.GAME_OVER_RADIO.S10090_TARGET_FULTON_FAILED_MARKING_OFF ]	= "s0090_gmov0010"
this.gameOverRadioTable[ TppDefine.GAME_OVER_RADIO.S10090_TARGET_FULTON_FAILED_MARKING_ON ]		= "s0090_gmov0050"





this.optionalRadioList = {
	"Set_s0090_oprg0010",		
	"Set_s0090_oprg0020",		
	"Set_s0090_oprg0030",		
	"Set_s0090_oprg0040",		
	"Set_s0090_oprg0050",		
	"Set_s0090_oprg0060",		
	"Set_s0090_oprg0070",		
}

this.optionalRadioIndexTable = {}

for i, name in ipairs( this.optionalRadioList ) do
	this.optionalRadioIndexTable[name] = i
end





this.intelRadioTruckList = {
	"s0090_esrg0020",											
	"s0090_esrg0030",											
	"s0090_esrg0035",											
	"s0090_esrg0040",											
}

this.intelRadioList = {
	veh_wav_0000			= "s0090_esrg0010",					
	--DUPLICATE: veh_wav_0000			= "s0090_esrg0010",					
	veh_trc_0000			= this.intelRadioTruckList[4],		
	wmu_s10090_0000			= "s0090_esrg0060",					
	wmu_s10090_0001			= "s0090_esrg0060",					
	wmu_s10090_0002			= "s0090_esrg0060",					
	wmu_s10090_0003			= "s0090_esrg0060",					
}





this.blackTelephoneDisplaySetting = {
	f6000_rtrg0140 = {
		Japanese = {
			{ "main_1",		"/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10090_01.ftex",		 0.6 },
			{ "main_2",		"/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10090.ftex",			12.5 },
			{ "main_3",		"/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10090_02.ftex",		27.4 },
		},
		English = {
			{ "main_1",		"/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10090_01.ftex",		 0.6 },
			{ "main_2",		"/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10090.ftex",			10.8 },
			{ "main_3",		"/Assets/tpp/ui/texture/Photo/tpp/demo/mission_demo_s10090_02.ftex",		25.5 },
		},
	},
}









this.GetMissionStart = function( isFound )
	Fox.Log("#### s10090_radio.GetMissionStart ####")
	local radioGroups = {}
	table.insert( radioGroups, "s0090_rtrg0020" )
	
	this.SetOptionalRadioUpdate( "Set_s0090_oprg0010" )
	
	if isFound == false then
		table.insert( radioGroups, "s0090_rtrg0030" )
	end
	return radioGroups
end


this.GetArrivalAtpfCampNorth = function()
	Fox.Log("#### s10090_radio.GetArrivalAtpfCampNorth ####")
	
	this.SetOptionalRadioUpdate( "Set_s0090_oprg0020" )
	return "s0090_rtrg0040"
end


this.GetMissionComplete = function( isFound )
	Fox.Log("#### s10090_radio.GetMissionComplete ####")
	
	this.SetOptionalRadioUpdate( "Set_s0090_oprg0060" )
	
	if isFound == false then
		return "s0090_rtrg0130"
	
	else
		return "f1000_rtrg1395"
	end
	
end


this.TelephoneRadio = function()
	TppRadio.RequestBlackTelephoneRadio( "f6000_rtrg0140" )
end






this.ContinueMissionStart = function()
	
	if s10090_sequence.GetVehicleValue( s10090_sequence.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) == true then
		TppRadio.Play( "s0090_oprg0060", { delayTime = "short" } )
	
	elseif svars.isOnGetIntel == true then
		TppRadio.Play( "s0090_rtrg0065", { delayTime = "short" } )
	
	else
		TppRadio.Play( "s0090_rtrg0055", { delayTime = "short" } )
	end
end


this.ContinueMissionClear = function()
	TppRadio.Play( "s0090_rtrg0375", { delayTime = "short" } )
end


this.TrapBeforeGetIntel = function()
	Fox.Log("#### s10090_radio.TrapIntel ####")
	TppRadio.Play( "s0090_rtrg0050", { delayTime = "short" } )
end


this.TrapAfterGetIntel = function()
	Fox.Log("#### s10090_radio.TrapIntel ####")
	TppRadio.Play( "f1000_rtrg3095", { delayTime = "short" } )
end


this.OnIntel = function()
	Fox.Log("#### s10090_radio.OnIntel ####")
	TppRadio.Play( "s0090_rtrg0060", { delayTime = "short" } )
	
	this.SetOptionalRadioUpdate( "Set_s0090_oprg0030" )
end


this.SearchEscortVehicle = function( type, isAppearanceParasites, isPunkTargetVehicle )
	Fox.Log("#### s10090_radio.SearchEscortVehicle ####")
	
	if svars.isMarkingVehicle01 == false and svars.isAppearanceParasites == false	then
		if svars.eventSequenceIndex >= s10090_sequence.ENUM_EVENT_VEHICLE_SEQUENCE.ENTER_PFCAMP then
			TppRadio.Play( "s0090_rtrg0100", { delayTime = "short" } )
		else
			local isFound01 = s10090_sequence.GetVehicleValue( s10090_sequence.ENUM_VEHICLE_VALUE_TYPE.PRESENCE, s10090_enemy.VEHICLE_NAME.WEST_WAV01 )
			local isFound02 = s10090_sequence.GetVehicleValue( s10090_sequence.ENUM_VEHICLE_VALUE_TYPE.PRESENCE, s10090_enemy.VEHICLE_NAME.WEST_WAV02 )
			if isFound01 == true or isFound02 == true then
				
				TppRadio.Play( "s0090_rtrg0095", { delayTime = "short" } )
			else
				
				TppRadio.Play( "s0090_rtrg0090", { delayTime = "short" } )
			end
		end
	else
		Fox.Log("Already Target Marking ... No Playing Radio !!")
	end
end


this.SearchTargetVehicle = function( type, isAppearanceParasites, isPunkTargetVehicle )
	Fox.Log("#### s10090_radio.SearchTargetVehicle ####")
	
	if type == "OnVehicleRide_Start" then
		
		if isAppearanceParasites == false then
			if isPunkTargetVehicle == false then
				
				TppRadio.Play( "s0090_rtrg0300", { delayTime = "mid" } )
			else
				
				TppRadio.Play( "s0090_rtrg0280", { delayTime = "mid" } )
			end
		
		else
			if svars.isDyingAllParasites == false	then
				
				TppRadio.Play( "s0090_rtrg0340", { delayTime = "mid" } )
			else
				if isPunkTargetVehicle == false then
				
					TppRadio.Play( "s0090_rtrg0300", { delayTime = "mid" } )
				else
				
					TppRadio.Play( "s0090_rtrg0280", { delayTime = "mid" } )
				end
			end
		end
	
	else
		TppRadio.Play( "s0090_rtrg0120", { delayTime = "mid" } )
	end
	if isAppearanceParasites == false then
		if svars.eventSequenceIndex <= s10090_sequence.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMP then
			
			this.SetOptionalRadioUpdate( "Set_s0090_oprg0070", true )
		else
			
			this.SetOptionalRadioUpdate()
		end
	end
end


this.TargetVehicleRide = function( type, isAppearanceParasites, isPunkTargetVehicle )
	Fox.Log("#### s10090_radio.SearchTargetVehicle ####")
	if isAppearanceParasites == false then
		if isPunkTargetVehicle == false then
			
			TppRadio.Play( "s0090_rtrg0330", { delayTime = "mid" } )
		else
			
			TppRadio.Play( "s0090_rtrg0290", { delayTime = "mid" } )
		end
	else
		
		TppRadio.Play( "s0090_rtrg0345", { delayTime = "mid" } )
	end
end


this.MarkingZRS = function()
	Fox.Log("#### s10090_radio.MarkingZRS ####")
	TppRadio.Play( "s0090_rtrg0110", { delayTime = "short" } )
end


this.ArrivalAtpfCampNorth = function()
	Fox.Log("#### s10090_radio.ArrivalAtpfCampNorth ####")
	TppRadio.Play( "s0090_rtrg0045", { delayTime = "mid" } )
end


this.ArrivalAtTransportPoint = function()
	Fox.Log("#### s10090_radio.ArrivalAtTransportPoint ####")
	TppRadio.Play( "s0090_rtrg0080", { delayTime = "mid" } )
end


this.ArrivalAreaNoVehicleMarkerFound = function()
	Fox.Log("#### s10090_radio.ArrivalAreaNoVehicleMarkerFound ####")
	TppRadio.Play( "s0090_rtrg0070", { delayTime = "mid" } )
end


this.ArrivalAtTargetswamp = function( isSuccess )
	Fox.Log("#### s10090_radio.ArrivalAtTargetswamp ####")
	local radioGroups = nil
	
	if isSuccess == false then
		radioGroups = {}
		table.insert( radioGroups, "s0090_rtrg0180" )
	
	else
		TppRadio.Play( "s0090_rtrg0240", { delayTime = "mid" } )
	end
	return radioGroups
end


this.ArrivalAtTargetswampWest = function()
	Fox.Log("#### s10090_radio.ArrivalAtTargetswampWest ####")
	TppRadio.Play( "s0090_rtrg0250", { delayTime = "mid" } )
end


this.NoEquipDevelopedFultonCargo = function( isFound )
	Fox.Log("#### s10090_radio.NoEquipDevelopedFultonCargo ####")
	if isFound == false then
		TppRadio.Play( "s0090_rtrg0150", { delayTime = "mid" } )
	else
		TppRadio.Play( "s0090_rtrg0270", { delayTime = "mid" } )
	end
end


this.AppearParasites = function()
	Fox.Log("#### s10090_radio.AppearParasites ####")
	TppRadio.Play( { "s0090_rtrg0260" }, { delayTime = "mid" } )
	if s10090_sequence.IsMainSequence() then
		
		this.SetOptionalRadioUpdate( "Set_s0090_oprg0050", true )
	end
	
	this.SetIntelUpdateEnemyZombie( true )
end


this.ExitParasites = function( isFound )
	Fox.Log("#### s10090_radio.ExitParasites ####")
	if isFound == false then
		TppRadio.Play( "s0090_rtrg0370", { delayTime = "mid" } )
	else
		TppRadio.Play( "s0090_rtrg0390", { delayTime = "mid" } )
	end
	
	this.SetIntelUpdateEnemyZombie( false )
end


this.DyingParasites = function( isFound )
	Fox.Log("#### s10090_radio.ExitParasites ####")
	if isFound == false then
		TppRadio.Play( "s0090_rtrg0360", { delayTime = "mid" } )
		
		this.SetOptionalRadioUpdate( "Set_s0090_oprg0070", true )
	else
		TppRadio.Play( "s0090_rtrg0380", { delayTime = "mid" } )
		
		this.SetOptionalRadioUpdate( "Set_s0090_oprg0060", true )
	end
	
	this.SetIntelUpdateEnemyZombie( false )
end


this.AlertZRS = function( isFound )
	Fox.Log("#### s10090_radio.ExitParasites ####")
	if isFound == false then
		TppRadio.Play( "s0090_rtrg0190", { delayTime = "long" } )
	else
		TppRadio.Play( "s0090_rtrg0230", { delayTime = "long" } )
	end
end


this.VehicleDamage = function()
	Fox.Log("#### s10090_radio.ExitParasites ####")
	TppRadio.Play( "s0090_rtrg0200", { delayTime = "mid" } )
end


this.VehicleHalfBroken = function()
	Fox.Log("#### s10090_radio.ExitParasites ####")
	TppRadio.Play( "s0090_rtrg0350", { delayTime = "mid" } )
end


this.VehicleCanNotMove = function()
	Fox.Log("#### s10090_radio.ExitParasites ####")
	TppRadio.Play( "s0090_rtrg0220", { delayTime = "mid" } )
end






function this.SetOptionalRadioUpdate( name, isForceUpdate )
	if name then
		if this.optionalRadioIndexTable[name] then
			local index = this.optionalRadioIndexTable[name]
			
			if index > svars.optionalRadioIndex or isForceUpdate == true then
				svars.optionalRadioIndex = this.optionalRadioIndexTable[name]
				TppRadio.SetOptionalRadio( name )
			end
		end
	else
		local isSet = false
		if s10090_sequence.IsMainSequence() == true then
			local isFound = s10090_sequence.GetVehicleValue( s10090_sequence.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET )
			if isFound == true then
				local isParasites = s10090_sequence.IsAppearanceParasites()
				if isParasites == false then
					local isDrive		= s10090_sequence.IsSequenceEnemyVehicleAction( s10090_sequence.ENUM_VEHICLE_CHECK_ACTION.DRIVE )
					local isStop		= s10090_sequence.IsSequenceEnemyVehicleAction( s10090_sequence.ENUM_VEHICLE_CHECK_ACTION.STOP )
					
					if isDrive == true then
						name	= "Set_s0090_oprg0040"
						isSet	= true
					elseif isStop == true then
						name	= "Set_s0090_oprg0070"
						isSet	= true
					end
					
					this.SetIntelUpdateTruck( isDrive, isStop )
				end
			end
		end
		if isSet == true then
			
			if svars.optionalRadioIndex ~= this.optionalRadioIndexTable[name] then
				svars.optionalRadioIndex = this.optionalRadioIndexTable[name]
				TppRadio.SetOptionalRadio( name )
			end
		end
	end
end






function this.SetIntelUpdateEnemyZombie( enabled )
	enabled = enabled or false
	if enabled then
		TppRadio.ChangeIntelRadio( { type_enemy = "s0090_esrg0050" } )
	else
		TppRadio.ChangeIntelRadio( { type_enemy = "Invalid" } )
	end
end


function this.SetIntelUpdateTruck( isDrive, isStop )
	local isWavFound01 = s10090_sequence.GetVehicleValue( s10090_sequence.ENUM_VEHICLE_VALUE_TYPE.PRESENCE, s10090_enemy.VEHICLE_NAME.WEST_WAV01 )
	local isWavFound02 = s10090_sequence.GetVehicleValue( s10090_sequence.ENUM_VEHICLE_VALUE_TYPE.PRESENCE, s10090_enemy.VEHICLE_NAME.WEST_WAV02 )
	if svars.eventSequenceIndex <= s10090_sequence.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMP then
		
		TppRadio.ChangeIntelRadio( { veh_trc_0000 = "s0090_esrg0040" } )
	else
		if isDrive == true then
			
			if isWavFound01 == true and isWavFound02 == true then
				TppRadio.ChangeIntelRadio( { veh_trc_0000 = "s0090_esrg0020" } )
			
			elseif isWavFound01 == false and isWavFound02 == false then
				TppRadio.ChangeIntelRadio( { veh_trc_0000 = "s0090_esrg0030" } )
			
			else
				TppRadio.ChangeIntelRadio( { veh_trc_0000 = "s0090_esrg0035" } )
			end
		elseif isStop == true then
			TppRadio.ChangeIntelRadio( { veh_trc_0000 = "s0090_esrg0040" } )
		end
	end
end




return this
