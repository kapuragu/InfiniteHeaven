-- DOBUILD: 1
-- ORIGINALQAR: chunk0
-- PACKPATH: \Assets\tpp\pack\mission2\common\title_sequence.fpkd
-- title_sequence.lua
local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local TimerStart = GkEventTimerManager.Start
local IsSavingOrLoading = TppScriptVars.IsSavingOrLoading
local currentMissionCode = vars.missionCode

local sequences = {}



local SELECT_FLAG = TppDefine.Enum{
	"SELECT_CONTINUE" 	,
	"SELECT_RESTART_HELI" ,
	"SELECT_GAME_START" ,
	"SELECT_MGO",
}
this.SetOnSelectFlag = function( selectFlag )
	mvars.title_selectFlag = selectFlag
end
this.GetOnSelectFlag= function( )
	return mvars.title_selectFlag
end





















function this.ClearTitleMode()
	Fox.Log("title_sequence.ClearTitleMode")
	gvars.ini_isTitleMode = false
	gvars.ini_isReturnToTitle = false
end





function this.SetNewGameState()
	mvars.isExistSaveData = false
end








function this.AddTitleSequences( list )
	local sequenceList = {
		"Seq_Demo_StartHasTitleMission",	
		"Seq_Game_PushStart",	
		"Seq_Game_TitleMenu",
	}
	local init_sequenceList_size = #sequenceList

	for i, sequenceName in ipairs( list ) do
		sequenceList[ init_sequenceList_size + i ] = sequenceName
	end
	
	
	local afterSequenceList = {
		"Seq_Game_ChunkLoading",
		"Seq_Game_ChunkCanceled",
		"Seq_Game_ChunkInstalled",
		"Seq_Demo_CheckDlc",
		"Seq_Demo_ShowDlcError",
		"Seq_Demo_ShowDlcAnnouncePopup",
		"Seq_Demo_WaitSavingPersonalData",
	}
	for i, sequenceName in ipairs( afterSequenceList ) do
		table.insert( sequenceList, sequenceName )
	end

	return sequenceList
end

function this.AddTitleSequenceTable( sequenceTable )
	for key, value in pairs(sequences) do
		sequenceTable[key] = value
	end
	return sequenceTable
end




function this.RegisterMissionGameSequenceName( sequenceName )
	Fox.Log("RegisterMissionGameSequenceName: sequenceName = " .. tostring(sequenceName ))
	mvars.title_missionGameSequenceName = sequenceName
end

function this.RegisterGameStatusFunction( enableGameStatusFunction, disableGameStatusFunction )
	mvars.title_enableGameStatusFunction = enableGameStatusFunction
	mvars.title_disableGameStatusFunction = disableGameStatusFunction
end

function this.RegisterTitleModeOnEnterFunction( titleModeOnEnterFunction )
	mvars.title_titleModeOnEnterFunction = titleModeOnEnterFunction
end




function this.DoEnableGameStatusFunction()
	if mvars.title_enableGameStatusFunction then
		mvars.title_enableGameStatusFunction()
	else
		Fox.Error("Not registerd enableGameStatusFunction")
	end
end

function this.DoDisableGameStatusFunction()
	if mvars.title_disableGameStatusFunction then
		mvars.title_disableGameStatusFunction()
	else
		Fox.Error("Not registerd disableGameStatusFunction")
	end
end




function this.RegisterMessageFunction( messageFunc )
	mvars.title_messageFunction = messageFunc
end




function this.HideTitleOnInitialize()
	mvars.title_hideTitleMenuOnInitialize = true
end




function this.StartPressStartMenu()
	mvars.title_hideTitleMenuOnInitialize = false
	if vars.missionCode == 10010 then
		Fox.Log("title_sequence.StartPressStartMenu() : cypr mode")

		
		local isExistSaveData
		if not TppSave.IsNewGame() then
			isExistSaveData = true
		else
			isExistSaveData = false
		end

		TppUiCommand.StartPressStartCyprusTitle( isExistSaveData )
	else
		Fox.Log("title_sequence.StartPressStartMenu() : helispace mode")
		TppUiCommand.StartPressStartMenu()
	end
end




function this.StartTitleMenu()
	mvars.title_hideTitleMenuOnInitialize = false
	if vars.missionCode == 10010 then
		Fox.Log("title_sequence.StartTitleMenu() : cypr mode")
		TppUiCommand.StartCyprusTitle( mvars.isExistSaveData )
	else
		Fox.Log("title_sequence.StartTitleMenu() : helispace mode")
		TppUiCommand.StartTitleMenu( mvars.isExistSaveData )
	end
end




function this.MergeMessageTable( base, addMessages )
	if not addMessages then
		return base
	end
	if not Tpp.IsTypeTable( addMessages ) then
		return base
	end
	for srv, srvTbl in pairs(addMessages) do
		base[srv] = base[srv] or {}
		for index, msgAct in ipairs(srvTbl) do
			table.insert( base[srv], msgAct )
		end
	end
	return base
end




function this.IsBrokenSaveData( missionCode )
	if not TppScriptVars.GetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "svars", "mis_isDefiniteMissionClear", 0 ) then
		
		if ( missionCode == 10150 )
		and ( TppScriptVars.GetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "svars", "seq_sequence", 0 ) == 2 ) then
			return true
		end
		
		return false
	end
	local SEQUENCE_MAX = 256
	local clearedSequenceTable = {
		
		[10010] = true,
		[10280] = true,
		
		[10020] = { 16, SEQUENCE_MAX },	
		
		[10036] = true,
		[10043] = true,
		[11043] = true,	
		[10033] = true,
		[11033] = true,	
		[10040] = true,
		[10041] = true,
		[10044] = true,
		[11044] = true,	
		[10052] = true,
		[10054] = true,	
		[11054] = true,	
		[10050] = true,
		[11050] = true,	
		[10070] = true,	
		
		[10080] = true,
		[11080] = true,	
		[10086] = true,
		[10082] = true,
		[11082] = true,	
		[10090] = true,
		[11090] = true,	
		[10195] = true,
		[10091] = true,
		[10100] = true,
		[10110] = true,
		[10121] = true,
		[11121] = true,	
		
		[10120] = true,
		[10085] = true,
		[10200] = true,
		[10211] = true,
		[10081] = true,
		[10130] = { 8, 9 },	
		[11130] = { 8, 9 },	
		[10140] = { 6, SEQUENCE_MAX },	
		[11140] = { 6, SEQUENCE_MAX },	
		[10150] = { 7, SEQUENCE_MAX },	
		[10151] = { 1, SEQUENCE_MAX },	
		[11151] = { 17, SEQUENCE_MAX },	
		[10045] = true,
		[10156] = true,
		[10093] = true,
		[10171] = true,
		[10240] = true,
		[10260] = true,
		[30010] = true,
		[30020] = true,
	}
	local clearedSequence = clearedSequenceTable[missionCode]

	if not clearedSequence then
		
		return false
	end
	if ( clearedSequence == true ) then
		
		return true
	end
	local missionSequenceIndex = TppScriptVars.GetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "svars", "seq_sequence", 0 )
	if ( missionCode == 10151 ) then
		
		
		
		local s10151ClearedSequence = {
			[5] = true,		
			[8] = true,		
			[17] = true,	
		}
		if s10151ClearedSequence[missionSequenceIndex] then
			return false 
		else
			return true
		end
	end

	if ( missionSequenceIndex >= clearedSequence[1] )
	and ( missionSequenceIndex <= clearedSequence[2] ) then
		
		
		return false
	else
		
		return true
	end
end

function this.ReverseMissionClearedFlag()
	local missionEnum = TppDefine.MISSION_ENUM[tostring(vars.missionCode)]
	if missionEnum then
		Fox.Log("this.ReverseMissionClearedFlag : vars.missionCode = " .. tostring(vars.missionCode))
		gvars.str_missionClearedFlag[missionEnum] = false
	end
end


function this.ReverseStorySequence()
	local storySequenceTable = TppStory.GetCurrentStorySequenceTable()
	if not storySequenceTable then
		Fox.Hungup("arienai story sequence de arienai save data ga dekita")
		return
	end
	local function MissionClose( missionName, defaultClose )
		Fox.Log("ReverseStorySequence : close mission " .. missionName )
		local missionCode = TppMission.ParseMissionName( missionName )
		TppStory.SetMissionOpenFlag( missionCode, false )
		local missionEnum = TppDefine.MISSION_ENUM[tostring(missionCode)]
		if missionEnum then
			gvars.str_missionOpenPermission[missionEnum] = false
		end
	end

	
	if storySequenceTable.main then
		MissionClose(storySequenceTable.main)
	end
	if storySequenceTable.flag then
		for index, missionName in pairs(storySequenceTable.flag) do
			MissionClose( missionName )
		end
	end
	if storySequenceTable.sub then
		for index, missionName in pairs(storySequenceTable.sub) do
			MissionClose( missionName )
		end
	end
	Fox.Log("ReverseStorySequence : decriment story sequence.")
	gvars.str_storySequence = gvars.str_storySequence - 1
end




function this.RecoverSaveDataIfForceGoToMbDemo()
	local mbDemoName = TppDemo.GetMBDemoName()
	if not mbDemoName then
		return
	end

	local function ReverseElapsedCount()
		if ( vars.missionCode == 30010 ) or ( vars.missionCode == 30020 ) then
			TppQuest.StartElapsedEvent( TppQuest.GetElapsedCount() + 1 )
		else
			local elapsedMissionCount = TppStory.GetElapsedMissionCount( TppDefine.ELAPSED_MISSION_EVENT.STORY_SEQUENCE )
			TppStory.StartElapsedMissionEvent( TppDefine.ELAPSED_MISSION_EVENT.STORY_SEQUENCE, elapsedMissionCount + 1 )
		end
	end

	local needRecoveryMbDemoTable = {
		
		EliLookSnake = ReverseElapsedCount,
		
		DevelopedBattleGear5 = ReverseElapsedCount,
		
		TheGreatEscapeLiquid = function()
			this.ReverseStorySequence()
			this.ReverseMissionClearedFlag()	
		end,
		
		DecisionHuey = function()
			this.ReverseStorySequence()
			
			TppStory.StartElapsedMissionEvent( TppDefine.ELAPSED_MISSION_EVENT.STORY_SEQUENCE, 1 )
			TppQuest.StartElapsedEvent( 1 )
		end,
	}
	TppDemo.SetNextMBDemo()
	local recoveryFunc = needRecoveryMbDemoTable[mbDemoName]
	if recoveryFunc then
		recoveryFunc()
	end
end

function this.RecoverSaveDataIfPandemicTutorial()
	if not ( TppStory.GetCurrentStorySequence() == TppDefine.STORY_SEQUENCE.CLEARD_FLAG_MISSIONS_AFTER_WHITE_MAMBA ) then
		return
	end
	if ( ( vars.missionCode == 10085 ) or ( vars.missionCode == 10200 ) )
	and ( not TppTerminal.IsPandemicTutorialFinished() )then
		this.ReverseMissionClearedFlag()
		this.ReverseStorySequence()
		gvars.trm_isPushRewardSeparationPlatform = false 
		gvars.forceMbRadioPlayedFlag[ TppDefine.FORCE_MB_RETURN_RADIO_ENUM["ParasiticWormCarrierQuarantine"] ] = false
	end
end

function this.RecoverSaveDataIfRetrieveVolgin()
	if not ( vars.missionCode == 30010 ) then
		return
	end
	local missionSequenceIndex = TppScriptVars.GetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "svars", "seq_sequence", 0 )
	if ( missionSequenceIndex == 3 ) then 
		
		
		gvars.qst_volginQuestCleared = false
	end
end








function this.MissionPrepare()
	Fox.Log("title_sequence.MissionPrepare")
end








sequences.Seq_Demo_StartHasTitleMission = {
	Messages = function()
		local titleMessages = StrCode32Table {
		
			UI = {
				{	
					msg = "TitleMenu", sender = "PressStart",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_PushStart")
					end,
				},
				{	
					msg = "PressStart",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_PushStart")
					end,
				},
				{	
					msg = "EndCyprusTitle",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_PushStart")
					end,
				},
				{	
					msg = "EndFadeIn", sender = "FadeInOnStartTitle",
					func = function()
						if gvars.ini_isReturnToTitle then
							TppSequence.SetNextSequence("Seq_Game_PushStart")
						end
					end,
				},
				{
					msg = "TitleMenuReady",
					func = function()
						
						
						if currentMissionCode ~= 10010 then
							TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "FadeInOnStartTitle", nil, { exceptGameStatus = exceptGameStatus } )--RETAILBUG: exceptGameStatus undefined
						end
					end,
				},
			},
		}

		local registMessages
		if mvars.title_messageFunction then
			registMessages = mvars.title_messageFunction()
		end

		titleMessages = this.MergeMessageTable( titleMessages, registMessages )

		return titleMessages
	end,
	
	OnEndShowSplashScreen = function ()
	
		if not TppGameSequence.IsMaster() then
			if Chunk.GetChunkState(Chunk.INDEX_CYPR) ~= Chunk.STATE_INSTALLED then
				Fox.Warning("Cypr Chunk not Installed.")
			end
		end
		currentMissionCode = vars.missionCode	
		this.DoDisableGameStatusFunction()

		if gvars.ini_isTitleMode then
			
			TppSave.VarSaveMbMangement()
		
			if Tpp.IsMaster() then
				TppUiStatusManager.SetStatus( "TitleMenu", "DISABLE_RESTART_HELI" )
			else
				TppUiStatusManager.UnsetStatus( "TitleMenu", "DISABLE_RESTART_HELI" )
			end
		
			if mvars.title_titleModeOnEnterFunction then
				mvars.title_titleModeOnEnterFunction()
			end

			if currentMissionCode ~= 10010 then
				
				TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "FadeInOnStartTitle", nil, { exceptGameStatus = exceptGameStatus } )--RETAILBUG: exceptGameStatus is defined below it
			end
			
			
			local exceptGameStatus = Tpp.GetAllDisableGameStatusTable()

			if not gvars.ini_isReturnToTitle then
				if not mvars.title_hideTitleMenuOnInitialize then
					this.StartPressStartMenu()
				end
			end
		elseif currentMissionCode == 10010 then
			this.DoEnableGameStatusFunction()
			
			TppSequence.SetNextSequence(mvars.title_missionGameSequenceName)
		else
			this.DoEnableGameStatusFunction()
			TppDemo.EnableInGameFlagIfResereved()
			TppSequence.SetNextSequence(mvars.title_missionGameSequenceName)
			TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "FadeInOnStartMissionGame")
		end
	end,

	OnUpdate = function ( self )	  
		local konamiLogoScreenId = SplashScreen.GetSplashScreenWithName("konamiLogo")
		if konamiLogoScreenId then
			if DebugText then
				local context = DebugText.NewContext()
				DebugText.Print(context, "Waiting Konami Logo...")
			end
			return
		end
		local kjpLogoScreenId = SplashScreen.GetSplashScreenWithName("kjpLogo")
		if kjpLogoScreenId then
			if DebugText then
				local context = DebugText.NewContext()
				DebugText.Print(context, "Waiting KJP Logo...")
			end
			return
		end
		local foxLogoScreenId = SplashScreen.GetSplashScreenWithName("foxLogo")
		if foxLogoScreenId then
			if DebugText then
				local context = DebugText.NewContext()
				DebugText.Print(context, "Waiting Fox Logo...")
			end
			return
		end

		
		if gvars.ini_isTitleMode then

			
			if not mvars.doneSyncNuclearLocalToServer then
				mvars.doneSyncNuclearLocalToServer = true
				TppMotherBaseManagement.SyncNuclearLocalToServer()
			end

			if TppMotherBaseManagement.IsSynchronizeBusy() then
				if DebugText then
					local context = DebugText.NewContext()
					DebugText.Print(context, "Waiting finihs TppMotherBaseManagement.SyncNuclearLocalToServer() ...")
				end
			end
		
			if not mvars.startHasTitleSeqeunceMbSyc then
				mvars.startHasTitleSeqeunceMbSyc = true
				TppMotherBaseManagement.OnTitleLoaded() 
				TppMotherBaseManagement.ProcessBeforeSync()
				TppMotherBaseManagement.StartSyncControl{}
			end
		end
		
		if not TppMotherBaseManagement.IsEndedSyncControl() then
			if DebugText then
				local context = DebugText.NewContext()
				DebugText.Print(context, "Waiting TppMotherBaseManagement sync process finish ...")
			end
			return
		end

		
		if not mvars.startHasTitileSeqeunce then
			mvars.startHasTitileSeqeunce = true
			self.OnEndShowSplashScreen()		
			--OFF InfMain.DeleteStartSplashes()--tex
		end

	end,

	OnLeave = function ()
	end,

}





local NEWGAME_CONFIRM_RESULT = TppDefine.Enum{
	"INIT",
	"OK",
	"NO",
	"CANCEL"
}





sequences.Seq_Game_PushStart = {

	Messages = function(self)
		local titleMessages = StrCode32Table {
		
			UI = {
				{
					msg = "PopupClose",
					func = function()
					end,
				},
			},
		}
		local registMessages
		if mvars.title_messageFunction then
			registMessages = mvars.title_messageFunction()
		end

		titleMessages = this.MergeMessageTable( titleMessages, registMessages )

		return titleMessages
	end,

	StartTitleMenu = function()
		Fox.Log("StartTitleMenu")
		mvars.isExistSaveData = true
		TppSequence.SetNextSequence("Seq_Game_TitleMenu")
	end,

	StartTitleMenuWithNoSavedData = function()
		Fox.Log("StartTitleMenuWithNoSavedData")
		mvars.isExistSaveData = false
		TppSequence.SetNextSequence("Seq_Game_TitleMenu")
	end,

	OnEnter = function ( self )
		mvars.newGameConfirmResult = NEWGAME_CONFIRM_RESULT.INIT
		if gvars.ini_isReturnToTitle then
			self.StartTitleMenu()
		end
	end,

	OnUpdate = function ( self )
		if TppUiCommand.IsShowPopup() then
			return
		end

		if TppSave.IsGameDataLoadResultOK() then
			self.StartTitleMenu()
		else
			self.StartTitleMenuWithNoSavedData()
		end
	end,

	OnLeave = function ()
	end,
}





sequences.Seq_Game_TitleMenu = {
	Messages = function(self)
		local titleMessages = StrCode32Table {
		--tex msgs sent on actual activate option, none on navigate menu (except for some on hilight mgo)
			UI = {
				
				{
					msg = "TitleMenu", sender = "Continue",--tex NMC used for continue to acc and continue to mission?
					func = self.OnSelectContinue,
				},
				{
					msg = "TitleMenu", sender = "RestartHeli",--tex NMC when is this sent?
					func = self.OnSelectRestartHeli,
				},
				
				{
					msg = "TitleMenu", sender = "GameStart",
					func = self.OnSelectGameStart,
				},
				{
					msg = "GameStart",
					func = self.OnSelectGameStart,
				},
				{
					msg = "Continue",
					func = self.OnSelectContinue,--tex NMC then why this?
				},
				
				{
					msg = "StartMGO",
					func = self.OnSelectMGO,
				},
				{
					msg = "GzSaveDataLoaded",
					func = function()
						
						gvars.mb_isRecoverd_dlc_staffs = false
						TppSave.SaveOnlyGlobalData()
					end,
				},
			},
		}
		local registMessages
		if mvars.title_messageFunction then
			registMessages = mvars.title_messageFunction()
		end

		titleMessages = this.MergeMessageTable( titleMessages, registMessages )

		return titleMessages
	end,

	OnEnter = function ()
		if not mvars.title_hideTitleMenuOnInitialize then
			this.StartTitleMenu()
		end
	end,

	OnLeave = function ( self, nextSequenceName )
	end,
	
	OnSelectRestartHeli = function()
		this.SetOnSelectFlag( SELECT_FLAG.SELECT_RESTART_HELI )
		TppSequence.SetNextSequence("Seq_Demo_CheckDlc")
	end,
	--tex REWORKED
	OnSelectContinue = function()
   local loadToHeliMissions={[10115]=true,[50050]=true}
   
   local loadToHeli=TppMission.IsHelicopterSpace(gvars.title_nextMissionCode) 
    or loadToHeliMissions[gvars.title_nextMissionCode] 
    or InfMain.ShouldAbortToACC(gvars.title_nextLocationCode,gvars.title_nextMissionCode)--tex added ShouldAbortToAcc
     
    if loadToHeli then--tex> 
      InfMain.abortToAcc=false
    end--<
  
    if loadToHeli then
    	this.SetOnSelectFlag( SELECT_FLAG.SELECT_RESTART_HELI )
    else
    	this.SetOnSelectFlag( SELECT_FLAG.SELECT_CONTINUE )
    end
    TppSequence.SetNextSequence("Seq_Demo_CheckDlc")
  end,
	--ORIG
--	OnSelectContinue = function()
--    if TppMission.IsHelicopterSpace(gvars.title_nextMissionCode)
--    or ( gvars.title_nextMissionCode == 10115 )
--    or ( gvars.title_nextMissionCode == 50050 ) then
--      this.SetOnSelectFlag( SELECT_FLAG.SELECT_RESTART_HELI )
--    else
--      this.SetOnSelectFlag( SELECT_FLAG.SELECT_CONTINUE )
--    end
--    TppSequence.SetNextSequence("Seq_Demo_CheckDlc")
--  end,
	OnSelectGameStart = function()
		this.SetOnSelectFlag( SELECT_FLAG.SELECT_GAME_START )
		TppSequence.SetNextSequence("Seq_Demo_CheckDlc")
	end,
	OnSelectMGO = function()
		this.SetOnSelectFlag( SELECT_FLAG.SELECT_MGO )
		TppSequence.SetNextSequence("Seq_Demo_CheckDlc")
	end,
}

sequences.Seq_Demo_CheckDlc = {
	OnEnter = function(self)
		if ( Fox.GetPlatformName() ~= "XboxOne" ) then
			TppSequence.SetNextSequence("Seq_Game_ChunkLoading")
			return
		end
		
		Dlc.StartCheckingDlc()
	end,
	OnUpdate = function(self)
		if Dlc.IsCheckingDlc() then
			if DebugText then
				DebugText.Print(DebugText.NewContext(), "Checking DLC...")
			end
		else
			if Dlc.GetLastError() == DlcError.E_OK then
				TppSequence.SetNextSequence("Seq_Demo_ShowDlcAnnouncePopup")
			else
				TppSequence.SetNextSequence("Seq_Demo_ShowDlcError")
			end
		end
	end,
}

sequences.Seq_Demo_ShowDlcError = {
	OnEnter = function(self)
		local dlcError = Dlc.GetLastError()
		if dlcError == DlcError.E_NETWORK then
		else
		end
		
		
		
		TppSequence.SetNextSequence("Seq_Demo_ShowDlcAnnouncePopup")
	end,
}

sequences.Seq_Demo_ShowDlcAnnouncePopup = {
	OnEnter = function(self)
		TppUiCommand.ShowDlcAnnouncePopup()
	end,
	
	OnUpdate = function( self )
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "Showing dlc announce popup ...")
		end
	end,

	Messages = function(self)
		return StrCode32Table{
			UI = {
				{
					msg = "EndDlcAnnounce",
					func = function()
						TppSequence.SetNextSequence("Seq_Demo_WaitSavingPersonalData")
					end,
				},
			},
		}
	end,
	OnLeave = function(self)
		TppSave.CheckAndSavePersonalData()
	end,
}

sequences.Seq_Demo_WaitSavingPersonalData = {
	OnEnter = function(self)
	end,
	
	OnUpdate = function( self )
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "Wait saving personal data ...")
		end

		local fileName = TppDefine.PERSONAL_DATA_SAVE_FILE_NAME
		if TppSave.IsSavingWithFileName( fileName ) or  TppSave.HasQueue( fileName ) then
			return
		end

		TppSequence.SetNextSequence("Seq_Game_ChunkLoading")
	end,
}


local OK_BUTTON = 1
local CANCEL_BUTTON = 2
sequences.Seq_Game_ChunkLoading = {
	OnEnter = function(self)
		if gvars.str_storySequence < TppDefine.STORY_SEQUENCE.CLEARD_ESCAPE_THE_HOSPITAL then
			Fox.Log("Now cypr title skip chunk installation check.")
			TppSequence.SetNextSequence("Seq_Game_ChunkInstalled")
			return
		end
		
		Chunk.SetChunkInstallSpeed(Chunk.INSTALL_SPEED_FAST)
		self.chunkIndex = self.GetChunkIndex()
		Chunk.PrefetchChunk(self.chunkIndex)
	end,

	OnUpdate = function(self)
		if Chunk.GetChunkState(self.chunkIndex) == Chunk.STATE_INSTALLED then
			Fox.Log("Install Chunk Index:" ..tostring(self.chunkIndex) )
			
			if TppUiCommand.IsShowPopup( TppDefine.ERROR_ID.NOW_INSTALLING ) then
				TppUiCommand.ErasePopup()
			end
			TppSequence.SetNextSequence("Seq_Game_ChunkInstalled")
			return
		end
		
		Tpp.ShowChunkInstallingPopup( self.chunkIndex, true )	
		
		
		TppUI.ShowAccessIconContinue()
	end,
	
	Messages = function(self)
		local titleMessages = StrCode32Table {
		
			UI = {
				{
					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.NOW_INSTALLING,
					func = function()
						TppSequence.SetNextSequence("Seq_Game_ChunkCanceled")
					end,
				},
			},
		}
		local registMessages
		if mvars.title_messageFunction then
			registMessages = mvars.title_messageFunction()
		end

		titleMessages = this.MergeMessageTable( titleMessages, registMessages )

		return titleMessages
	end,

	OnLeave = function ( self, nextSequenceName )
		
		Chunk.SetChunkInstallSpeed(Chunk.INSTALL_SPEED_NORMAL)
	end,
	GetChunkIndex = function()
		local isMGO
		if this.GetOnSelectFlag() == SELECT_FLAG.SELECT_MGO then
			isMGO = true
		end
		local chunkIndex = Tpp.GetChunkIndex( gvars.title_nextLocationCode, isMGO )
		return chunkIndex
	end,

}



sequences.Seq_Game_ChunkCanceled = {
	OnEnter = function(self)
		TppUiCommand.ShowErrorPopup( TppDefine.ERROR_ID.INSTALL_CANCEL, Popup.TYPE_TWO_BUTTON )
	end,
	Messages = function(self)
		local titleMessages = StrCode32Table {
		
			UI = {
				{
					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.INSTALL_CANCEL,
					func = function()
						local select = TppUiCommand.GetPopupSelect()
						if select == OK_BUTTON then 
							TppUiCommand.RebootTitleSelectMenu() 
							TppSequence.SetNextSequence("Seq_Game_TitleMenu")
						else 
							TppSequence.SetNextSequence("Seq_Game_ChunkLoading")
						end
					end,
				},
			},
		}
		local registMessages
		if mvars.title_messageFunction then
			registMessages = mvars.title_messageFunction()
		end
		titleMessages = this.MergeMessageTable( titleMessages, registMessages )
		return titleMessages
	end,
}

sequences.Seq_Game_ChunkInstalled = {
	OnEnter = function(self)
		local onSelect = this.GetOnSelectFlag()
		if onSelect == SELECT_FLAG.SELECT_GAME_START then
			self.OnSelectGameStart()
		elseif onSelect == SELECT_FLAG.SELECT_CONTINUE then
			self.OnSelectContinue()
		elseif onSelect == SELECT_FLAG.SELECT_RESTART_HELI then
			self.OnSelectRestartHeli()
		elseif onSelect == SELECT_FLAG.SELECT_MGO then
			self.OnSelectMGO()
		end
	end,

	Messages = function(self)
		local titleMessages = StrCode32Table {
		
			UI = {
				{
					msg = "EndFadeOut", sender = "ContinueFromCheckPoint",
					func = self.OnEndFadeOutSelectContinue,
				},
				{
					msg = "EndFadeOut", sender = "GameStart",
					func = self.OnEndFadeSelectGameStart,
				},
				{
					msg = "EndFadeOut", sender = "GoToMgo",
					func = self.OnEndFadeSelectMGO,
				},
			},
		}
		local registMessages
		if mvars.title_messageFunction then
			registMessages = mvars.title_messageFunction()
		end
		titleMessages = this.MergeMessageTable( titleMessages, registMessages )
		return titleMessages
	end,
	
	OnUpdate = function ( self )
		if mvars.startLoadNewGame then
			self.OnUpdateForNewGameLoad()
		end

		self.OnUpdateSelectMGO()
	end,
	
	OnLeave = function()
	end,
	
	OnSelectContinue = function()
		TppUI.FadeOut( TppUI.FADE_SPEED.FADE_NORMALSPEED, "ContinueFromCheckPoint", nil, { setMute = true } )
	end,

	OnEndFadeOutSelectContinue = function()
    InfCore.LogFlow("title_sequence.OnEndFadeOutSelectContinue "..tostring(vars.missionCode))--tex
		--tex NMC I'm still not quite clear when missionCode is set from the save files continue version 
		--vs it being set to helispace in TppVarInit.StartTitle
		--gvars.title_nextMissionCode is involved somewhere, but I cant see vars.missionCode being set from it
		local titleMissionCode = vars.missionCode
		this.DoEnableGameStatusFunction()
		TppMission.SafeStopSettingOnMissionReload()	
		TppSave.VarRestoreOnContinueFromCheckPoint()
		InfGameEvent.GenerateEvent(vars.missionCode)--tex events are implemented as non saving ivars, so need to reapply if continiuing
		this.ClearTitleMode()
		if not this.IsBrokenSaveData( vars.missionCode ) then	
		TppMain.ReservePlayerLoadingPosition(
			TppDefine.MISSION_LOAD_TYPE.CONTINUE_FROM_CHECK_POINT
		)
		gvars.isContinueFromTitle = true
		TppTerminal.AcquirePrivilegeInTitleScreen()

			
    if	( vars.missionCode == 10240 )
			and ( not TppPackList.IsMissionPackLabel( "InQuarantineFacility" ) )
			and ( vars.locationCode == TppDefine.LOCATION_ID.MBQF ) then
				
				vars.locationCode = TppDefine.LOCATION_ID.MTBS
				TppScriptVars.SetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "vars", "locationCode", TppDefine.LOCATION_ID.MTBS)
			end
			
			
			this.RestoreSaveDetaForBtk44624()
			
		TppSave.VarSaveMbMangement( titleMissionCode )
		TppSave.CheckAndSavePersonalData()
		else
			if not Tpp.IsMaster() then
				
				TppSave.DEBUG_RecoverSaveDataCount = 3.0
			end
			
			
			
			
			TppPlayer.ResetInitialPosition()
			TppMain.ReservePlayerLoadingPosition( TppDefine.MISSION_LOAD_TYPE.MISSION_RESTART )
			TppMission.VarResetOnNewMission()
			this.ClearTitleMode()
			

			
			this.RecoverSaveDataIfPandemicTutorial()
			
			this.RecoverSaveDataIfForceGoToMbDemo()
			
			this.RecoverSaveDataIfRetrieveVolgin()

			
			gvars.mbFreeDemoPlayRequestFlag[TppDefine.MB_FREEPLAY_DEMO_REQUESTFLAG_DEFINE.PlayAfterQuietBattle] = false
			gvars.mbFreeDemoPlayRequestFlag[TppDefine.MB_FREEPLAY_DEMO_REQUESTFLAG_DEFINE.PlayAfterDethFactory] = false
			gvars.mbFreeDemoPlayRequestFlag[TppDefine.MB_FREEPLAY_DEMO_REQUESTFLAG_DEFINE.PlayAfterWhiteMamba] = false

			
			local locationName = TppPackList.GetLocationNameFormMissionCode( vars.missionCode )
			if locationName then
				local locationCode = TppDefine.LOCATION_ID[locationName]
				if locationCode then
					Fox.Log("Reset locationCode. locationCode = " .. tostring(locationCode) )
					vars.locationCode = locationCode
				end
			end
			TppTerminal.AcquirePrivilegeInTitleScreen()

			

			
			TppSave.VarSave()
			TppSave.CheckAndSavePersonalData()
		end
		TppMission.Load( vars.missionCode, currentMissionCode )
	end,

	OnSelectRestartHeli = function()
		this.DoEnableGameStatusFunction()
		TppMission.EnableInGameFlag()
		this.ClearTitleMode()

		TppTerminal.AcquirePrivilegeInTitleScreen()
		TppVarInit.InitializeOnlineChallengeTaskVarsForNewMission()--RETAILPATCH 1090

		TppSave.VarSave( nil, true )
		TppSave.CheckAndSavePersonalData()
		TppSequence.SetNextSequence(mvars.title_missionGameSequenceName)
		TppTerminal.GetFobStatus()
	end,

	OnSelectGameStart = function()
		TppUI.FadeOut( TppUI.FADE_SPEED.FADE_NORMALSPEED, "GameStart", nil, { setMute = true } )
	end,

	OnEndFadeSelectGameStart = function()
		TppMission.SafeStopSettingOnMissionReload()
		this.ClearTitleMode()
		TppSave.MakeNewGameSaveData( true ) 
		mvars.startLoadNewGame = true
	end,

	OnUpdateForNewGameLoad = function()
		InfCore.LogFlow("title_sequence.OnUpdateForNewGameLoad "..tostring(vars.missionCode))--tex
		if TppSave.IsEnqueuedSaveData() or IsSavingOrLoading() then
			Fox.Log("Now saveing wait.")
			return
		end
		this.DoEnableGameStatusFunction()
		TppMission.Load( vars.missionCode, currentMissionCode, { showLoadingTips = false } )
	end,

	OnSelectMGO = function()
		Fox.Log("OnSelectMGO")

		InvitationManager.EnableMessage(false)	

		


		local function TitlePatchDlcCheck()
			local function existPatchDlcFunc()
				TppUiCommand.ErasePopup()
				TppException.isNowGoingToMgo = true		
				TppUI.FadeOut( TppUI.FADE_SPEED.FADE_NORMALSPEED, "GoToMgo", nil, { setMute = true } )
			end
			local function notExistPatchDlcFunc()
				
				
				TppUiCommand.ShowErrorPopup( 5103, Popup.TYPE_ONE_BUTTON )--INVITATION_PATCH_DLC_ERROR
				
				while TppUiCommand.IsShowPopup() do
					coroutine.yield()
				end

				InvitationManager.EnableMessage(true)	
				Tpp.ClearDidCancelPatchDlcDownloadRequest()
				TppSequence.SetNextSequence("Seq_Game_TitleMenu")
			end
		
			return Tpp.PatchDlcCheckCoroutine( existPatchDlcFunc, notExistPatchDlcFunc ) 
		end

		mvars.title_patchDlcCheckCoroutine = coroutine.create(TitlePatchDlcCheck)
	end,

	OnUpdateSelectMGO = function()
		if mvars.title_patchDlcCheckCoroutine then
			local status, ret1 = coroutine.resume(mvars.title_patchDlcCheckCoroutine)

			
			if not TppGameSequence.IsMaster() then
				if ( not status )then
					Fox.Hungup()
				end
			end

			
			
			if ( coroutine.status(mvars.title_patchDlcCheckCoroutine) == "dead" ) 
			or ( not status )then
				mvars.title_patchDlcCheckCoroutine = nil
				return ret1
			end
		end
	end,

	OnEndFadeSelectMGO = function()
		Fox.Log("Start MGO!")
		Mission.SwitchApplication("mgo")
	end,
}



this.RestoreSaveDetaForBtk44624 = function()
	if vars.missionCode ~= 30050 then
		return
	end
	
	local CheckPlayerOnPlntXZ = function(playerPos)
		local plntNameList = {"plnt0","plnt1","plnt2","plnt3"}
		local plntSizeSqr = 3000 
		for _, clusterName in ipairs( TppDefine.CLUSTER_NAME ) do
			for _, plntName in ipairs( plntNameList ) do
				if not mtbs_cluster.HasPlant(clusterName, plntName) then
					break 
				end
				local plntCenterPos = mtbs_cluster.GetDemoCenter( clusterName, plntName )
				local distVec = plntCenterPos - playerPos
				local distSqr = distVec:GetX()*distVec:GetX() + distVec:GetZ()*distVec:GetZ()	
				if distSqr < plntSizeSqr then
					Fox.Log("Player on Cluster: cluster:"..tostring(clusterName) .. " : plntName: " ..tostring(plntName) .. " : distSqr:" ..tostring(distSqr) )
					return true, clusterName, plntName
				end
			end
		end
		return false
	end
	
	
	local CheckPlayerOnPlntY = function(playerPos, clusterName, plntName )
		local thresholdY = 0.0 
		if clusterName == "Medical" and plntName == "plnt0" then
			thresholdY = -3.5 
		elseif clusterName == "Develop" and plntName == "plnt0" then
			thresholdY = -7.8 
		elseif clusterName == "Command" and plntName == "plnt0" then
			thresholdY = -8.5 
		end
		return playerPos:GetY() > thresholdY
	end
	
	
	local isUseMissionStartPos = not TppScriptVars.GetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "gvars", "sav_varRestoreForContinue" )
	local playerPos = Vector3(vars.initialPlayerPosX, vars.initialPlayerPosY, vars.initialPlayerPosZ)
	if isUseMissionStartPos then
		
		playerPos = Vector3(
			TppScriptVars.GetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "gvars", "ply_missionStartPos",0 ),
			TppScriptVars.GetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "gvars", "ply_missionStartPos",1 ),
			TppScriptVars.GetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "gvars", "ply_missionStartPos",2 ) )
	end	
	local isOnPlntXZ, clusterName, plntName = CheckPlayerOnPlntXZ( playerPos )
	if isOnPlntXZ then
		if CheckPlayerOnPlntY(playerPos, clusterName, plntName ) then
			
			
			vars.mbClusterId = TppDefine.CLUSTER_DEFINE[clusterName]--RETAILPATCH: 1070>
			TppScriptVars.SetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "vars", "mbClusterId",vars.mbClusterId )--<
			return 
		end
	end
	
	
	
	
	
	
	vars.mbClusterId = TppDefine.CLUSTER_DEFINE.Command--RETAILPATCH: 1070>
	TppScriptVars.SetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "vars", "mbClusterId",vars.mbClusterId )--<
	
	local MB_COMMAND_POS = { 9, 0.8, -42 } 
	if isUseMissionStartPos then 
		TppScriptVars.SetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "gvars", "ply_missionStartPos", 0, MB_COMMAND_POS[1])
		TppScriptVars.SetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "gvars", "ply_missionStartPos", 1, MB_COMMAND_POS[2])
		TppScriptVars.SetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "gvars", "ply_missionStartPos", 2, MB_COMMAND_POS[3])
		Fox.Log("Restore mission start position for btk:44624")
	else
		TppScriptVars.SetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "vars", "initialPlayerPosX", MB_COMMAND_POS[1])
		TppScriptVars.SetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "vars", "initialPlayerPosY", MB_COMMAND_POS[2])
		TppScriptVars.SetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "vars", "initialPlayerPosZ", MB_COMMAND_POS[3])
		
		local sequenceIndex = TppScriptVars.GetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "svars", "seq_sequence" )
		if 	9 <= sequenceIndex and sequenceIndex <= 16 then 
			TppScriptVars.SetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "svars", "seq_sequence", 8 ) 
			TppScriptVars.SetVarValueInSlot(TppDefine.SAVE_SLOT.CHECK_POINT, "svars", "isPazRoomStart", false ) 
		end
		Fox.Log("Restore player initial position for btk:44624")
	end
end

return this