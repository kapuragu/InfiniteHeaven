local mtbs_baseTelop = {}





local PLNT_TELOP_NAME = {
	"platform_1st",					
	"platform_2nd",					
	"platform_3rd",					
	"platform_4th",					
}

local CLUSTER_TELOP_NAME = {
	"platform_main",				
	"platform_combat",				
	"platform_RD",					
	"platform_support",				
	"platform_medical",				
	"platform_intel",				
	"platform_base_dev",			
	"platform_common",				
}

local CLUSTER_TELOP_NAME_ZOO = {
	"platform_zoo_bird",			
	"platform_zoo_herbivore1",		
	"platform_zoo_canivore",		
	"platform_zoo_herbivore2",		
}

local CLUSTER_TELOP_NAME_ISOLATION = {
	"platform_isolation",			
}






mtbs_baseTelop.cpLangIdTable = {
	
	{ "platform_main",				"platform_main",			"platform_en_main" },					
	{ "platform_combat",			"platform_combat",			"platform_en_combat" },					
	{ "platform_RD",				"platform_RD",				"platform_en_RD" },						
	{ "platform_support",			"platform_support",			"platform_en_support" },				
	{ "platform_medical",			"platform_medical",			"platform_en_medical" },				
	{ "platform_intel",				"platform_intel",			"platform_en_intel" },					
	{ "platform_base_dev",			"platform_base_dev",		"platform_en_base_dev" },				
	
	{ "platform_zoo_bird",			"platform_zoo_bird",		"platform_en_zoo_bird", },				
	{ "platform_zoo_herbivore1",	"platform_zoo_herbivore1",	"platform_en_zoo_herbivore1", },		
	{ "platform_zoo_canivore",		"platform_zoo_canivore",	"platform_en_zoo_canivore", },			
	{ "platform_zoo_herbivore2",	"platform_zoo_herbivore2",	"platform_en_zoo_herbivore2", },		
	
	{ "platform_isolation",			"platform_isolation",		"platform_en_isolation", },				
}





mtbs_baseTelop.Messages = function()
	
	local telopMessages = mtbs_baseTelop.SetupTypingTextMessages()
	
	return
	Tpp.StrCode32Table{
		Player = {
			{	
				msg = "LandingFromHeli",
				func = mtbs_baseTelop._OnTelopStart,
			},
		},
		Trap = telopMessages,
	}
end

mtbs_baseTelop.SetupTypingTextMessages = function()
	local telopMessages	= {}
	local missionId		= TppMission.GetMissionID()
	local formatName	= nil
	
	if missionId == 30050 then
		formatName = "ly003_cl%02d_30050_heli0000|cl%02dpl%d_mb_fndt_plnt_heli_30050|trap_plnt_telop"
	
	elseif missionId == 10115 then
		formatName = "ly003_cl%02d_10115_heli0000|cl%02dpl%d_mb_fndt_plnt_heli_10115|trap_plnt_telop"
	
	elseif missionId == 30150 then
		formatName = "ly500_cl%02d_30150_heli0000|cl%02dpl%d_mb_fndt_plnt_heli_30050|trap_plnt_telop"
	
	elseif missionId == 50050 then
		if (vars.mbLayoutCode >= 10) and (vars.mbLayoutCode <= 13) then
			formatName = "ly013_cl%02d_50050_heli0000|cl%02dpl%d_mb_fndt_plnt_heli_50050|trap_plnt_telop"
		elseif (vars.mbLayoutCode >= 20) and (vars.mbLayoutCode <= 23) then
			formatName = "ly023_cl%02d_50050_heli0000|cl%02dpl%d_mb_fndt_plnt_heli_50050|trap_plnt_telop"
		elseif (vars.mbLayoutCode >= 30) and (vars.mbLayoutCode <= 33) then
			formatName = "ly033_cl%02d_50050_heli0000|cl%02dpl%d_mb_fndt_plnt_heli_50050|trap_plnt_telop"
		elseif (vars.mbLayoutCode >= 40) and (vars.mbLayoutCode <= 43) then
			formatName = "ly043_cl%02d_50050_heli0000|cl%02dpl%d_mb_fndt_plnt_heli_50050|trap_plnt_telop"
		elseif (vars.mbLayoutCode >= 70) and (vars.mbLayoutCode <= 73) then
			formatName = "ly073_cl%02d_50050_heli0000|cl%02dpl%d_mb_fndt_plnt_heli_50050|trap_plnt_telop"
		elseif (vars.mbLayoutCode >= 80) and (vars.mbLayoutCode <= 83) then
			formatName = "ly083_cl%02d_50050_heli0000|cl%02dpl%d_mb_fndt_plnt_heli_50050|trap_plnt_telop"
		elseif (vars.mbLayoutCode >= 90) and (vars.mbLayoutCode <= 93) then
			formatName = "ly093_cl%02d_50050_heli0000|cl%02dpl%d_mb_fndt_plnt_heli_50050|trap_plnt_telop"
		else
			Fox.Error( "mtbs_baseTelop.SetupTypingTextMessages : noLayOut" )
			return telopMessages
		end
	else
		return telopMessages
	end
	
	
	if missionId == 30050 or missionId == 10115 or missionId == 50050 then
		for clusterId, clusterName in ipairs( TppDefine.CLUSTER_NAME ) do
			local grade = mtbs_cluster.GetClusterConstruct( clusterId )
			if grade > 0 then
				for plnt = 0, (grade-1) do
					local trapName = string.format( formatName, clusterId - 1 , clusterId - 1, plnt )
					local trapTableEnter = {
						msg		= "Enter", 
						sender	= trapName,
						func = function( trap, playerId )
							mtbs_baseTelop._OnTrap( clusterId, grade, plnt, playerId )
						end,
						option = { isExecDemoPlaying = true , isExecMissionPrepare = true},
					}
					table.insert( telopMessages, trapTableEnter )
				end
			end
		end
	
	elseif missionId == 30150 then
		local clusterId = 1
		for plnt = 0, 4 do
			local trapName = string.format( formatName, clusterId - 1 , clusterId - 1, plnt )
			local trapTableEnter = {
				msg		= "Enter", 
				sender	= trapName,
				func = function( trap, playerId )
					mtbs_baseTelop._OnTrap( clusterId, 1, plnt, playerId )
				end
			}
			table.insert( telopMessages, trapTableEnter )
		end
	elseif missionId == 30250 then

	end
	
	return telopMessages
end









mtbs_baseTelop.OnInitialize = function( subScripts )
	local missionId		= TppMission.GetMissionID()
	
	
	mtbs_baseTelop.messageExecTable 			= Tpp.MakeMessageExecTable( mtbs_baseTelop.Messages() )
	
	mvars.mbBaseTelop_isTelop					= false
	mvars.mbBaseTelop_plntTelopName				= nil
	mvars.mbBaseTelop_clusterTelopName			= nil
	mvars.mbBaseTelop_clusterGrade				= 1
	
	mvars.mbBaseTelop_plntTelopName				= PLNT_TELOP_NAME[1]
	
	if missionId == 30050 or missionId == 10115 then--RETAILPATCH: 1070 or == 50050 removed
		mvars.mbBaseTelop_clusterTelopName		= CLUSTER_TELOP_NAME[8]
	elseif missionId == 30150 then
		mvars.mbBaseTelop_clusterTelopName		= CLUSTER_TELOP_NAME_ZOO[1]
	elseif missionId == 30250 then
		mvars.mbBaseTelop_clusterTelopName		= CLUSTER_TELOP_NAME_ISOLATION[1]
	end
end





mtbs_baseTelop.OnReload = function( subScripts )
	
	mtbs_baseTelop.messageExecTable = Tpp.MakeMessageExecTable( mtbs_baseTelop.Messages() )
end





mtbs_baseTelop.OnMessage = function( sender, messageId, arg0, arg1, arg2, arg3, strLogText )
	
	Tpp.DoMessage( mtbs_baseTelop.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText )
end









function mtbs_baseTelop.DispBaseName()
	mtbs_baseTelop._OnTelopStart()
end





function mtbs_baseTelop.DispBaseNameNoTelop()
	mvars.mbBaseTelop_isTelop = true
end




function mtbs_baseTelop.DisableBaseName()
	mvars.mbBaseTelop_isTelop = false
end







mtbs_baseTelop._OnTelopStart = function()
	if mvars.mbBaseTelop_isTelop == false then
		mvars.mbBaseTelop_isTelop = true
		mtbs_baseTelop._OnTelop( nil )
	end
end




mtbs_baseTelop._OnTelop = function( playerId )
	local missionId		= TppMission.GetMissionID()
	local isTypingText	= false
	if mvars.mbBaseTelop_isTelop == true then
		
		if missionId == 30050 or missionId == 10115 then
			if mvars.mbBaseTelop_clusterGrade > 1 then
				TppUiCommand.RegistInfoTypingText( "separate", 5, mvars.mbBaseTelop_clusterTelopName, mvars.mbBaseTelop_plntTelopName )
				isTypingText = true
			else
				TppUiCommand.RegistInfoTypingText( "cpname", 5, mvars.mbBaseTelop_clusterTelopName )
				isTypingText = true
			end
		
		elseif missionId == 50050 then
			
			if mvars.mbBaseTelop_clusterTelopName == nil then--RETAILPATCH: 1070>
				Fox.Log( "mtbs_baseTelop._OnTelop :: It is not updated once. Don't Display telop on FOB")
				return
			end--<

			local isSucces = false
			
			if playerId == nil then
				isSucces = true
			
			elseif playerId == 0 then
				if TppServerManager.FobIsSneak() then
					isSucces = true
				end
			
			elseif playerId == 1 then
				if not TppServerManager.FobIsSneak() then
					isSucces = true
				end
			end
			if isSucces == true then
				if mvars.mbBaseTelop_clusterGrade > 1 then
					TppUiCommand.RegistInfoTypingText( "separate", 5, mvars.mbBaseTelop_clusterTelopName, mvars.mbBaseTelop_plntTelopName )
					isTypingText = true
				else
					TppUiCommand.RegistInfoTypingText( "cpname", 5, mvars.mbBaseTelop_clusterTelopName )
					isTypingText = true
				end
			end
		
		elseif missionId == 30150 or missionId == 30250 then
			TppUiCommand.RegistInfoTypingText( "cpname", 5, mvars.mbBaseTelop_clusterTelopName )
			isTypingText = true
		end
		TppUiCommand.ShowInfoTypingText()
	end
end




mtbs_baseTelop._OnTrap = function( clusterId, grade, plnt, playerId )
	--RETAILPATCH 1090>
	mtbs_baseTelop._OnEnterForUpdateFobClearedPlantCount( playerId, plnt )
	--^
	local missionId		= TppMission.GetMissionID()
	local isTelop		= false
	if missionId == 30050 or missionId == 10115 or missionId == 50050 then
		Fox.Log( "mtbs_baseTelop._OnTrap :: 30050 or 10115")--RETAILPATCH: 1070>
		if missionId == 50050 and Tpp.IsLocalPlayer(playerId) == false then
			Fox.Log( "mtbs_baseTelop._OnTrap :: 50050 :: OnTrap is not Local Player")
			return
		end--<
		if mvars.mbBaseTelop_isTelop == true then
			if PLNT_TELOP_NAME[plnt+1] == mvars.mbBaseTelop_plntTelopName then
				return
			end
		end
		mvars.mbBaseTelop_clusterId			= clusterId
		mvars.mbBaseTelop_clusterGrade		= grade
		mvars.mbBaseTelop_plntTelopName		= PLNT_TELOP_NAME[plnt+1]
		mvars.mbBaseTelop_clusterTelopName	= CLUSTER_TELOP_NAME[clusterId]
		isTelop								= true
	elseif missionId == 30150 then
		if mvars.mbBaseTelop_isTelop == true then
			if CLUSTER_TELOP_NAME_ZOO[plnt+1] == mvars.mbBaseTelop_clusterTelopName then
				return
			end
		end
		mvars.mbBaseTelop_clusterId			= clusterId
		mvars.mbBaseTelop_clusterGrade		= 1
		mvars.mbBaseTelop_clusterTelopName	= CLUSTER_TELOP_NAME_ZOO[plnt+1]
		isTelop								= true
	elseif missionId == 30250 then
		mvars.mbBaseTelop_clusterTelopName	= CLUSTER_TELOP_NAME_ISOLATION[1]
		isTelop								= false
	end
	
	if mvars.mbBaseTelop_isTelop == true and isTelop == true then
		mtbs_baseTelop._OnTelop( playerId )
	end
end



--RETAILPATCH 1090>
mtbs_baseTelop._OnEnterForUpdateFobClearedPlantCount = function( playerId, plantNumber )
	
	if not o50050_sequence then
		return
	end
	
	if ( vars.fobSneakMode == FobMode.MODE_ACTUAL )
	and TppServerManager.FobIsSneak()
	and Tpp.IsLocalPlayer( playerId ) then
		o50050_sequence.UpdateClearedPlantCount( plantNumber )
	end
end
--^

return mtbs_baseTelop

