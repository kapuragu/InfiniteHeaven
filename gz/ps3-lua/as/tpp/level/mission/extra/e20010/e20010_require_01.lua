local this = {}
---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------
this.missionID	= 20010
this.cpID		= "gntn_cp"

---------------------------------------------------------------------------------
--脱走捕虜処刑待ち配置
---------------------------------------------------------------------------------
local KillWaiting_SpHostahe_EnemyPos = function()
	TppMission.SetFlag( "isSpHostageKillVersion", true )
	--脱走捕虜のステータス変更
	TppHostageUtility.SetHostageStatusInCp( "gntn_cp", "SpHostage", "HOSTAGE_STATUS_NONE" )
	TppEnemy.Warp( "SpHostage" , "warp_KillingHostage" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "KillWaiting_Hostage01" , -1 , "Seq20_01" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "KillWaiting_Hostage02" , -1 , "ComEne13" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "KillWaiting_Hostage03" , -1 , "ComEne14" , "ROUTE_PRIORITY_TYPE_FORCED" )
end
---------------------------------------------------------------------------------
--脱走捕虜処刑待ちじゃない配置
---------------------------------------------------------------------------------
local NoKillWaiting_SpHostahe_EnemyPos = function()
	TppMission.SetFlag( "isSpHostageKillVersion", false )
	--脱走捕虜のステータス設定
	TppHostageUtility.SetHostageStatusInCp( "gntn_cp", "SpHostage", "HOSTAGE_STATUS_LOST" )
	--キャラ有効無効
	TppEnemyUtility.SetEnableCharacterId( "Seq20_03" , false )
	TppEnemyUtility.SetEnableCharacterId( "Seq20_06" , true )
	--Trap有効化
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Talk_SearchSpHostage", true , false )
	--Trap無効化
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Seaside2manStartRouteChange", false , false )

	--脱走捕虜死んでるもしくはヘリ回収済みであればマーカーを消す
	if ( TppMission.GetFlag( "isPlaceOnHeliSpHostage" ) == true ) or
		( TppMission.GetFlag( "isSpHostage_Dead" ) == true ) then
		TppMarkerSystem.DisableMarker{ markerId = "SpHostage" }
	else
	end
	TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage01" ) 					--ルート有効
	TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage02" ) 					--ルート有効
	TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage03" ) 					--ルート有効
	TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage04" ) 					--ルート有効
	TppEnemy.EnableRoute( this.cpID , "S_SearchSpHostage05a" ) 					--ルート有効
	TppEnemy.DisableRoute( this.cpID , "S_Waiting_PC_AsyOut01" )				--ルート無効
	TppEnemy.DisableRoute( this.cpID , "S_Waiting_PC_AsyOut02" )				--ルート無効
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_SearchSpHostage03" , 0 , "Seq20_01" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_SearchSpHostage04" , 0 , "Seq20_06" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_SearchSpHostage05a" , 0 , "Seq20_04" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_SearchSpHostage01" , 0 , "ComEne13" , "ROUTE_PRIORITY_TYPE_FORCED" )
	TppCommandPostObject.GsSetPriorityEnemyForRoute( this.cpID , "e20010_Seq20_SneakRouteSet" , "S_SearchSpHostage02" , 0 , "ComEne14" , "ROUTE_PRIORITY_TYPE_FORCED" )
end
---------------------------------------------------------------------------------
--中間目標設定
---------------------------------------------------------------------------------
local commonUiMissionSubGoalNo = function( id )
	Fox.Log( "commonUiMissionSubGoalNo")
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then
			return
	end

	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then
			return
	end
	-- 中目標番号をその値に設定する
	luaData:SetCurrentMissionSubGoalNo( id)
end
----------------------------------------------------------------------------------------------------------------------------
--全シーケンス共通
-----------------------------------------------------------------------------------------------------------------
--弾切れになったとき
this.Radio_OnAmmoStackEmpty = function()
	local weaponID = TppData.GetArgument( 1 )
--	Fox.Log("========================================"..weaponID)
	-- 種類で分岐
	if weaponID == "WP_ar00_v03" then
		TppRadio.Play( "Miller_EmptyMagazin" )
	end
end

--チュートリアルボタン表示
this.Tutorial_1Button = function( textInfo, buttonIcon )
	-- 1ボタン
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:CallButtonGuide( textInfo, buttonIcon )
end
this.Tutorial_2Button = function( textInfo, buttonIcon1, buttonIcon2 )
	-- 2ボタン
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:CallButtonGuide( textInfo, buttonIcon1, buttonIcon2 )
end

--字幕起動で呼ばれる関数群
this.Sub_rdps0z00_0x1012 = function()
	-- 操作方法はポーズ画面
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:CallButtonGuide( "tutorial_pause", fox.PAD_SELECT )
	hudCommonData:CallButtonGuide( "tutorial_controll", fox.PAD_Y )
end

this.Sub_rdps1001_111010 = function()
	--そいつは機関砲も撃てる
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:CallButtonGuide( "tutorial_pause", fox.PAD_SELECT )
	hudCommonData:CallButtonGuide( "tutorial_apc", fox.PAD_Y )
end
this.Sub_RDPS1000_181015 = function()
	-- pad 装備切り替え
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:CallButtonGuide( "tutorial_equipment_wp", true, true )
	hudCommonData:CallButtonGuide( "tutorial_attack", "PL_HOLD", "PL_SHOT" )
end
this.Sub_ENQT1000_1m1310 = function()
	-- 尋問セリフ表示後に無線を流したい
	local timer = 3
	GkEventTimerManager.Start( "Timer_GetPazInfo", timer )
end
this.Sub_SLTB0z10_5y1010 = function()
	-- 立ち話セリフ表示後に無線を流したい
	local DelayTime = 3
	TppRadio.DelayPlay( "Miller_EscapeOrAttack", DelayTime )
end
this.Sub_rdps2110_141010 = function()
	this.Tutorial_1Button("tutorial_restraint","PL_CQC")
	this.Tutorial_1Button("tutorial_interrogation","PL_CQC_INTERROGATE")
end

--エルードしたとき
this.Common_Elude = function()
	if( TppMission.GetFlag( "isInSeaCliffArea" ) == true ) then	--旧収容所側の崖のトラップ内にいるとき（落ちたらゲームオーバー）
		TppRadio.DelayPlayEnqueue("Miller_MillerEludeFall", "short")
	elseif( TppMission.GetFlag( "isInStartCliffArea" ) == true ) then	--スタート崖側の崖のトラップ内にいるとき（落ちたらゲームオーバー）
		--なにもしない
	else														--それ以外の場所（落ちてもゲームオーバーにならない）
		TppRadio.DelayPlayEnqueue("Miller_MillerEludeNoFall", "short")
	end

	--シーケンスチェック
	local sequence = TppSequence.GetCurrentSequence()
	if ( sequence == "Seq_NextRescuePaz" ) then
		if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == false and
			 TppMission.GetFlag( "isQuestionChico" ) == false ) then
			TppRadio.RegisterOptionalRadio( "Optional_RescueChicoToRVChico" )	--0015
		end
	end
end

--尋問促し無線タイマー
this._InterrogationAdviceTimerStart = function( timer )

	--timer秒後に無線を再生する
	GkEventTimerManager.Start( "Timer_InterrogationAdvice", timer )
end
-- 初回
this.InterrogationAdviceTimerStart = function()
	this._InterrogationAdviceTimerStart(600)
end
-- コンテニュー後
this.InterrogationAdviceTimerReStart = function()
	TppRadio.DelayPlay("Miller_ChicoTapeAdvice01", "mid")
	this._InterrogationAdviceTimerStart(360)
end

--尋問促し無線再生
this.Radio_InterrogationAdvice = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then
		TppRadio.PlayEnqueue("Miller_InterrogationAdvice")
		TppEnemyUtility.SetInterrogationForceCharaIdAllCharacter( "PazHint_01" )	-- パスヒント１を言う
		TppMission.SetFlag( "isInterrogation_Radio", true )	-- 尋問でパスのヒントを言うのを許可するフラグ
		TppMission.SetFlag( "isPlayInterrogationAdv", true )
		TppRadio.RegisterOptionalRadio( "Optional_Interrogation" )
		-- チコテープ3再生中に無線再生許可判定
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1270") == false or
			radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1271") == false or
			radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1272") == false or
			radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1274") == false) then
			--チコ3再生中に無線再生できるようにする
			TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( false )
		end
	else
		this._InterrogationAdviceTimerStart(30)
	end
end

--立ち話終了時
this.Common_ConversationEnd = function()
--	local label = TppData.GetArgument( 2 )
--	if( label == "CTE0010_0345" ) then	
--		--独り言を最後まで聞いた
--		TppRadio.PlayEnqueue("Miller_EscapeOrAttack")
--	end
end

--車両に乗っているときは無線を再生しない
this.OnVehicleCheckRadioPlay = function( radioID, DelayTime )
	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()
	if( VehicleId == "" and GZCommon.PlayerOnCargo == "NoRide" ) then
		TppRadio.DelayPlay( radioID, DelayTime )
	end
end
this.OnVehicleCheckRadioPlayEnqueue = function( radioID, DelayTime )
	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()
	if( VehicleId == "" and GZCommon.PlayerOnCargo == "NoRide" ) then
		if( TppRadio.IdRadioPlayable() == true ) then
			TppRadio.DelayPlayEnqueue( radioID, DelayTime )
		end
	end
end
--排水溝チュートリアル
this.Radio_drainTutorial = function()

	local characterId = TppPlayerUtility.GetCarriedCharacterId()
	local radioDaemon = RadioDaemon:GetInstance()
	-- ホフクチュートリアルを言わないようにする
	radioDaemon:EnableFlagIsCallCompleted( "e0010_rtrg0968" )
	if( characterId == "" ) then
		TppRadio.DelayPlayEnqueue( "Miller_HohukuAdvice" ,"short" )
	end
end

--ヘリパッドに到着した無線
this.Radio_helipad = function()
	if( TppMission.GetFlag( "isCenterEnter" ) == false ) then
		this.OnVehicleCheckRadioPlay( "Miller_InHeliport" )
	end
end

--管理棟に入ったら（排水溝）ミラードラマ無線1
this.Radio_RouteDrain = function()
	local timer = 1
	GkEventTimerManager.Start( "Timer_MillerHistory1", timer )

	--ここまできたらビハインドチュートリアルはしない
	TppMission.SetFlag( "isBehindTutorial", e20010_sequence.flagchk_CoverTutorialEnd )
	--管理棟に入ったFlagを立てる
	TppMission.SetFlag( "isCenterEnter", true )
	--尋問促しタイマーをとめる
	GkEventTimerManager.Stop( "Timer_InterrogationAdvice" )
end

--管理棟に入ったら
this.Radio_InCenterCoverAdvice = function()
	local radioDaemon = RadioDaemon:GetInstance()

	if( TppMission.GetFlag( "isCenterEnter" ) == false ) then
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg3070") == false and
			radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg3072") == false ) then
			if( TppMission.GetFlag( "isDoneCQC" ) == false ) then
				TppRadio.PlayEnqueue("Miller_InCenterCoverAdviceCQC")
				TppMission.SetFlag( "isDoneCQC", true ) --説明を聞いたらCQCをしたことにする
			else
				TppRadio.PlayEnqueue("Miller_InCenterCoverAdvice")
			end

			--ここまできたらビハインドチュートリアルはしない
			TppMission.SetFlag( "isBehindTutorial", e20010_sequence.flagchk_CoverTutorialEnd )
			--尋問促しタイマーをとめる
			GkEventTimerManager.Stop( "Timer_InterrogationAdvice" )
			--管理棟に入ったFlagを立てる
			TppMission.SetFlag( "isCenterEnter", true )
		end
	end
end

--車両の近くに来たとき
this.Common_e0010_rtrg0740 = function()
	local VehicleID = TppData.GetArgument(2)
	if VehicleID == "LightVehicle" then
--		TppRadio.Play("Miller_CarRideAdviceJeep")
	else
--		TppRadio.Play("Miller_CarRideAdviceCommon")
	end
end

-- チコテープリアクション
this.CallTapeReaction0 = function()
	if( TppMission.GetFlag( "isPazMarkJingle" ) == false and TppMission.GetFlag( "isInterrogation_Radio" ) == false ) then
		TppRadio.Play( "Miller_TapeReaction00" )
	end
	if ( TppMission.GetFlag( "isChicoTapePlay" ) == false ) then
		TppMission.SetFlag( "isChicoTapePlay", true )
	end
end
this.CallTapeReaction1 = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1270") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1271") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1272") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1274") == false) then
		if( TppMission.GetFlag( "isPazMarkJingle" ) == false and TppMission.GetFlag( "isInterrogation_Radio" ) == false ) then
			TppRadio.Play( "Miller_TapeReaction01" )
		end
	end
end
this.CallTapeReaction2 = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1270") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1271") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1272") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1274") == false) then
		if( TppMission.GetFlag( "isPazMarkJingle" ) == false and TppMission.GetFlag( "isInterrogation_Radio" ) == false ) then
			TppRadio.Play( "Miller_TapeReaction02" )
		end
	end
end
this.CallTapeReaction3 = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1270") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1271") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1272") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1274") == false) then
		if( TppMission.GetFlag( "isPazMarkJingle" ) == false and TppMission.GetFlag( "isInterrogation_Radio" ) == false ) then
			TppRadio.Play( "Miller_TapeReaction03" )
		end
	end
end
this.CallTapeReaction4 = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1270") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1271") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1272") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1274") == false) then
		if( TppMission.GetFlag( "isPazMarkJingle" ) == false and TppMission.GetFlag( "isInterrogation_Radio" ) == false ) then
			--TppRadio.Play( "Miller_TapeReaction04" )
		end
	end
end
this.CallTapeReaction5 = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1270") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1271") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1272") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1274") == false) then
		if( TppMission.GetFlag( "isPazMarkJingle" ) == false and TppMission.GetFlag( "isInterrogation_Radio" ) == false ) then
			TppRadio.Play( "Miller_TapeReaction05" )
		end
	end
end
this.CallTapeReaction6 = function()
	local phase = TppEnemy.GetPhase( this.cpID )
	if ( phase == "alert" or phase == "evasion" ) then
	else
		if( TppMission.GetFlag( "isPazMarkJingle" ) == false and TppMission.GetFlag( "isInterrogation_Radio" ) == false ) then
			--TppRadio.Play( "Miller_TapeReaction06" )
		end
	end
end
this.CallTapeReaction7 = function()
	local phase = TppEnemy.GetPhase( this.cpID )
	local radioDaemon = RadioDaemon:GetInstance()
	if ( phase == "alert" or phase == "evasion" ) then
	else
		if( TppMission.GetFlag( "isPazMarkJingle" ) == false ) then
			TppRadio.DelayPlay( "Miller_TapeReaction07", "mid" )
		end
	end
	if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1270") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1271") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1272") == false or
		radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1274") == false) then
		if( TppMission.GetFlag( "isPazMarkJingle" ) == false and TppMission.GetFlag( "isInterrogation_Radio" ) == false ) then
			--チコ3再生中に無線再生できないようにする
			TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( true )
		else
			--チコ3再生中に無線再生できるようにする
			TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( false )
		end
	else
		--チコ3再生中に無線再生できるようにする
		TppRadioCommand.SetEnableDisableRadioWhileChico3TapeIsPlaying( false )
	end
end
--[[
this.CallTapeReaction7 = function()
	TppRadio.Play( "Miller_TapeReaction07" )
end
this.CallTapeReaction8 = function()
	if ( TppMission.GetFlag("isChicoTapeListen") == true ) then
		TppRadio.Play( "Miller_TapeReaction08" )
--  9つ目の台詞はテープ終了後に再生する必要があるため、ここで一緒にセットする
		TppRadio.PlayEnqueue( "Miller_TapeReaction08" )
	end
end
this.CallTapeReaction9 = function()
--	TppRadio.Play( "Miller_TapeReaction09" )
end]]

--ヘリ要請したとき
this.MbDvcActCallRescueHeli = function(characterId, type)
	local radioDaemon = RadioDaemon:GetInstance()
	local emergency = TppData.GetArgument(2)
	local charaObj = Ch.FindCharacterObjectByCharacterId("SupportHelicopter")
	local plgHeli = charaObj:GetCharacter():FindPlugin("TppSupportHelicopterPlugin")

	Fox.Log( "=================================" )
	Fox.Log( "===  mbDvaActCall(Type:" .. tostring(type) .. ") !!!   ===" )
	Fox.Log( "=================================" )


	TppMission.SetFlag( "isHeliComingRV", true )

	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()

	if( VehicleId == "SupportHelicopter" ) then
	else
		if ( type == "MbDvc" ) then
			Fox.Log( "=================================" )
			Fox.Log( "===  mbDvaActCall(emergencyRank:" .. tostring(emergency) .. ") !!!   ===" )
			Fox.Log( "=================================" )

			if ( radioDaemon:IsPlayingRadio() == false ) then
				--無線の種類に問わず再生中でない
				if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0381") == false and
				--スタート崖を抜ける前にヘリを呼んだ
					TppMission.GetFlag( "isDoCarryAdvice" ) == false ) then
						TppRadio.DelayPlay( "Miller_StartCallHeli", "long" )
				else
					if(TppSupportHelicopterService.IsDueToGoToLandingZone(characterId)) then
					--これからＬＺに行く予定がある
						if(emergency == 2) then
							TppRadio.DelayPlay( "Miller_CallHeliHot02", "long" )
						else
							TppRadio.DelayPlay( "Miller_CallHeli02", "long" )
						end
					else
					--特にＬＺに行く予定はない
						if plgHeli:GetAiStatus() ~= "AI_STATUS_RETURN" then
						  --帰還していない場合の処理
							if(emergency == 2) then
								TppRadio.DelayPlay( "Miller_CallHeliHot01", "long" )
							else
								TppRadio.DelayPlay( "Miller_CallHeli01", "long" )
							end
						end
					end
				end
			end
		elseif ( type == "flare" ) then
			Fox.Log( "=================================" )
			Fox.Log( "===  FlareHeliCall(isUnderground:" .. tostring(emergency) .. ") !!!   ===" )
			Fox.Log( "=================================" )

			if ( emergency == false ) then
				-- 地下なのでヘリは呼べない
				if ( radioDaemon:IsPlayingRadio() == false ) then
					--無線の種類に問わず再生中でない
					TppRadio.DelayPlay( "Miller_HeliNoCall", "long" )
				end
				TppMission.SetFlag( "isHeliComingRV", false )
			else
				-- ヘリは呼べる
				if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0381") == false and
				--スタート崖を抜ける前にヘリを呼んだ
					TppMission.GetFlag( "isDoCarryAdvice" ) == false ) then
						TppRadio.DelayPlay( "Miller_StartCallHeli", "long" )
				else
					if ( radioDaemon:IsPlayingRadio() == false ) then
						--無線の種類に問わず再生中でない
						if(TppSupportHelicopterService.IsDueToGoToLandingZone(characterId)) then
						--これからＬＺに行く予定がある
							if(emergency == 2) then
								TppRadio.DelayPlay( "Miller_CallHeliHot02", "long" )
							else
								TppRadio.DelayPlay( "Miller_CallHeli02", "long" )
							end
						else
						--特にＬＺに行く予定はない
							if plgHeli:GetAiStatus() ~= "AI_STATUS_RETURN" then
							  --帰還していない場合の処理
								if(emergency == 2) then
									TppRadio.DelayPlay( "Miller_CallHeliHot01", "long" )
								else
									TppRadio.DelayPlay( "Miller_CallHeli01", "long" )
								end
							end
						end
					end
				end
			end
		else
			if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0381") == false and
			--スタート崖を抜ける前にヘリを呼んだ
				TppMission.GetFlag( "isDoCarryAdvice" ) == false ) then
					TppRadio.DelayPlay( "Miller_StartCallHeli", "long" )
			else
				if ( radioDaemon:IsPlayingRadio() == false ) then
					--無線の種類に問わず再生中でない
					if(TppSupportHelicopterService.IsDueToGoToLandingZone(characterId)) then
					--これからＬＺに行く予定がある
						TppRadio.DelayPlay( "Miller_CallHeli02", "long" )
					else
					--特にＬＺに行く予定はない
						TppRadio.DelayPlay( "Miller_CallHeli01", "long" )
					end
				end
			end
		end
	end
end

-- 旧収容施設を出たら騒いでいた捕虜は黙る
this.HostageQuiet_Trap = function()
	TppHostageManager.GsSetStruggleFlag( "Hostage_e20010_003" , false )
	TppHostageManager.GsSetStruggleFlag( "Hostage_e20010_004" , false )
end

-- チコパスをヘリに乗せた時セーブ
this.ChicoPaznHeliSave = function()

	local sequence = TppSequence.GetCurrentSequence()
	local LzName = TppSupportHelicopterService.GetRendezvousPointNameWhichHelicopterIsWaitingOn("SupportHelicopter")

	if ( sequence == "Seq_NextRescuePaz" ) and						-- 指定シーケンスで
		( TppMission.GetFlag( "isCassetteDemo" ) == false ) and		-- カセットテープデモを見てなく
		( TppMission.GetFlag( "isChicoTapePlay" ) == false ) then	-- テープを再生してなかったら
			-- セーブしない＝デモ再生するから
	else
		if ( LzName == "RV_HeliPort" ) then
			TppMissionManager.SaveGame("50")
		elseif ( LzName == "RV_SeaSide" ) then
			TppMissionManager.SaveGame("40")
		elseif ( LzName == "RV_StartCliff" ) then
			TppMissionManager.SaveGame("10")
		elseif ( LzName == "RV_WareHouse" ) then
			TppMissionManager.SaveGame("51")
		else
			TppMissionManager.SaveGame("10")
		end
	end
end
--ヘリがＲＶ上空から降下
this.Common_HeliDescend = function()

	local JingleFlag		= 0
	local lz_name = TppData.GetArgument(2)

	--lz判定
	if lz_name == "RV_SeaSide" then			-- 海岸
		local pos_seaside		= Vector3( 136.785 , 4.964 , 110.680 )
		local size_seaside		= Vector3( 40 , 10 , 40 )
		local npcIds = TppNpcUtility.GetNpcByBoxShape( pos_seaside , size_seaside )
		--ジングル判定
		if npcIds and #npcIds.array > 0 then
			for i,id in ipairs(npcIds.array) do
				local type = TppNpcUtility.GetNpcType( id )
				if type == "Hostage" then
					local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
					if( characterId == "Chico" ) then
						if( TppMission.GetFlag( "isChicoHeliJingle" ) == false ) then
							if JingleFlag == 0 then
								TppMusicManager.PostJingleEvent( "SuspendPhase", "Play_bgm_gntn_jingle_heli" )
								TppMission.SetFlag( "isChicoHeliJingle", true )
								JingleFlag = 1
							else
							end
						else
						end
					elseif ( characterId == "Paz" )then
						if( TppMission.GetFlag( "isPazHeliJingle" ) == false ) then
							if JingleFlag == 0 then
								TppMusicManager.PostJingleEvent( "SuspendPhase", "Play_bgm_gntn_jingle_heli" )
								TppMission.SetFlag( "isPazHeliJingle", true )
								JingleFlag = 1
							else
							end
						else
						end
					end
				end
			end
		end
	elseif lz_name == "RV_HeliPort" then	-- ヘリポート
		local pos_heliport		= Vector3( -89.871 , 31.080 , 52.4140 )
		local size_heliport		= Vector3( 40 , 10 , 40 )
		local npcIds = TppNpcUtility.GetNpcByBoxShape( pos_heliport , size_heliport )
		--ジングル判定
		if npcIds and #npcIds.array > 0 then
			for i,id in ipairs(npcIds.array) do
				local type = TppNpcUtility.GetNpcType( id )
				if type == "Hostage" then
					local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
					if( characterId == "Chico" ) then
						if( TppMission.GetFlag( "isChicoHeliJingle" ) == false ) then
							if JingleFlag == 0 then
								TppMusicManager.PostJingleEvent( "SuspendPhase", "Play_bgm_gntn_jingle_heli" )
								TppMission.SetFlag( "isChicoHeliJingle", true )
								JingleFlag = 1
							else
							end
						else
						end
					elseif ( characterId == "Paz" )then
						if( TppMission.GetFlag( "isPazHeliJingle" ) == false ) then
							if JingleFlag == 0 then
								TppMusicManager.PostJingleEvent( "SuspendPhase", "Play_bgm_gntn_jingle_heli" )
								TppMission.SetFlag( "isPazHeliJingle", true )
								JingleFlag = 1
							else
							end
						else
						end
					end
				end
			end
		end
	elseif lz_name == "RV_WareHouse" then	-- 倉庫
		local pos_warehouse 	= Vector3( -116.094 , 27.944 , 144.713 )
		local size_warehouse	= Vector3( 40 , 10 , 40 )
		local npcIds = TppNpcUtility.GetNpcByBoxShape( pos_warehouse , size_warehouse )
		--ジングル判定
		if npcIds and #npcIds.array > 0 then
			for i,id in ipairs(npcIds.array) do
				local type = TppNpcUtility.GetNpcType( id )
				if type == "Hostage" then
					local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
					if( characterId == "Chico" ) then
						if( TppMission.GetFlag( "isChicoHeliJingle" ) == false ) then
							if JingleFlag == 0 then
								TppMusicManager.PostJingleEvent( "SuspendPhase", "Play_bgm_gntn_jingle_heli" )
								TppMission.SetFlag( "isChicoHeliJingle", true )
								JingleFlag = 1
							else
							end
						else
						end
					elseif ( characterId == "Paz" )then
						if( TppMission.GetFlag( "isPazHeliJingle" ) == false ) then
							if JingleFlag == 0 then
								TppMusicManager.PostJingleEvent( "SuspendPhase", "Play_bgm_gntn_jingle_heli" )
								TppMission.SetFlag( "isPazHeliJingle", true )
								JingleFlag = 1
							else
							end
						else
						end
					end
				end
			end
		end
	elseif lz_name == "RV_StartCliff" then	-- スタート崖
		local pos_startcliff	= Vector3( -221.038 , 37.841 , 301.937 )
		local size_startcliff	= Vector3( 60 , 20 , 60 )
		local npcIds = TppNpcUtility.GetNpcByBoxShape( pos_startcliff , size_startcliff )
		--ジングル判定
		if npcIds and #npcIds.array > 0 then
			for i,id in ipairs(npcIds.array) do
				local type = TppNpcUtility.GetNpcType( id )
				if type == "Hostage" then
					local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
					if( characterId == "Chico" ) then
						if( TppMission.GetFlag( "isChicoHeliJingle" ) == false ) then
							if JingleFlag == 0 then
								TppMusicManager.PostJingleEvent( "SuspendPhase", "Play_bgm_gntn_jingle_heli" )
								TppMission.SetFlag( "isChicoHeliJingle", true )
								JingleFlag = 1
							else
							end
						else
						end
					elseif ( characterId == "Paz" )then
						if( TppMission.GetFlag( "isPazHeliJingle" ) == false ) then
							if JingleFlag == 0 then
								TppMusicManager.PostJingleEvent( "SuspendPhase", "Play_bgm_gntn_jingle_heli" )
								TppMission.SetFlag( "isPazHeliJingle", true )
								JingleFlag = 1
							else
							end
						else
						end
					end
				end
			end
		end
	else
	end
end
--巨大ゲート通過トラックの荷台に乗った
this.OpenGateTruck_SneakRideON = function()
	local VehicleId		= TppData.GetArgument(1)
	if( VehicleId == "Cargo_Truck_WEST_004" ) then
		TppMission.SetFlag( "isTruckSneakRideOn", true )
	else
	end
end
--巨大ゲート通過トラックの荷台から降りた
this.OpenGateTruck_SneakRideOFF = function()
	local VehicleId		= TppData.GetArgument(1)
	if( VehicleId == "Cargo_Truck_WEST_004" ) then
		TppMission.SetFlag( "isTruckSneakRideOn", false )
	else
	end
end
--脱走捕虜担ぎ会話
this.SpHostageMonologue = function( manager, messageId, characterId, characterHandle, trapBodyHandle, trapName )

	--脱走捕虜を担いでいたら
	if( TppPlayerUtility.IsCarriedCharacter( "SpHostage" )) then
		local obj = Ch.FindCharacterObjectByCharacterId("SpHostage")

		if not Entity.IsNull(obj) then
			TppEnemyUtility.CallCharacterMonologue( "POW_CD_paz_001" , 3, obj, true )
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "SpHostageMonologue", false , false )
		end
	else
	end
end
--通常捕虜０１担ぎ会話
this.Hostage01Monologue = function( manager, messageId, characterId, characterHandle, trapBodyHandle, trapName )

	--脱走捕虜を担いでいたら
	if( TppPlayerUtility.IsCarriedCharacter( "Hostage_e20010_001" )) then
		local obj = Ch.FindCharacterObjectByCharacterId("Hostage_e20010_001")

		if not Entity.IsNull(obj) then
			TppEnemyUtility.CallCharacterMonologue( "POW_CD_0010" , 3, obj, true )
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Hostage01Monologue", false , false )
		end
	else
	end
end
--通常捕虜０２担ぎ会話
this.Hostage02Monologue = function( manager, messageId, characterId, characterHandle, trapBodyHandle, trapName )

	--脱走捕虜を担いでいたら
	if( TppPlayerUtility.IsCarriedCharacter( "Hostage_e20010_002" )) then
		local obj = Ch.FindCharacterObjectByCharacterId("Hostage_e20010_002")

		if not Entity.IsNull(obj) then
			TppEnemyUtility.CallCharacterMonologue( "POW_CD_0020" , 3, obj, true )
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Hostage02Monologue", false , false )
		end
	else
	end
end
--通常捕虜０３担ぎ会話
this.Hostage03Monologue = function( manager, messageId, characterId, characterHandle, trapBodyHandle, trapName )

	--脱走捕虜を担いでいたら
	if( TppPlayerUtility.IsCarriedCharacter( "Hostage_e20010_003" )) then
		local obj = Ch.FindCharacterObjectByCharacterId("Hostage_e20010_003")

		if not Entity.IsNull(obj) then
			TppEnemyUtility.CallCharacterMonologue( "POW_CD_0030_01" , 3, obj, true )
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Hostage03Monologue", false , false )
		end
	else
	end
end
--通常捕虜０４担ぎ会話
this.Hostage04Monologue = function( manager, messageId, characterId, characterHandle, trapBodyHandle, trapName )

	--脱走捕虜を担いでいたら
	if( TppPlayerUtility.IsCarriedCharacter( "Hostage_e20010_004" )) then
		local obj = Ch.FindCharacterObjectByCharacterId("Hostage_e20010_004")

		if not Entity.IsNull(obj) then
			TppEnemyUtility.CallCharacterMonologue( "POW_CD_0040" , 3, obj, true )
			TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap", "Hostage04Monologue", false , false )
		end
	else
	end
end
--脱走捕虜担ぎ会話終了
this.SpHostageInformation = function()
	TppMission.SetFlag( "isGetDuctInfomation", true )					--フラグ更新
	--端末更新
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_map_update" )
	--排水溝マーキング
	TppMarker.Enable( "Marker_Duct", 0 , "none" , "map_only_icon" , 0 , false , true )
end

-- ヘリから離れろって促すかどうか
this.commonHeliLeaveJudge = function()
	local radioDaemon = RadioDaemon:GetInstance()
	local timer = 55 --「ヘリから離れろよ」という促しをするまでの時間

	-- ヘリが着陸してるRadio_pleaseLeaveHeli
	if( TppMission.GetFlag( "isHeliLandNow" ) == true ) then
		-- プレイヤーがヘリの近くにいたら
		if ( GZCommon.Radio_pleaseLeaveHeli() == true ) then
			--無線流してもう一回同じタイマーを回す
			if ( radioDaemon:IsPlayingRadio() == false ) then
				--無線再生中でなければ
				TppRadio.PlayEnqueue( "Miller_HeliLeave" )
			end
			GkEventTimerManager.Start( "Timer_pleaseLeaveHeli", timer )
		end
	end
end
-- ヘリから離れろって促すのを延長
this.commonHeliLeaveExtension = function()
	local timer = 55 --「ヘリから離れろよ」という促しをするまでの時間

	-- 一回止めて同じタイマーを回す
	GkEventTimerManager.Stop( "Timer_pleaseLeaveHeli" )
	GkEventTimerManager.Start( "Timer_pleaseLeaveHeli", timer )
end
----------------------------------------------------------------------------------------------------------------------------
--複数シーケンスで使用
-----------------------------------------------------------------------------------------------------------------
this.ComeEne17_NodeAction = function()

	local RouteName			= TppData.GetArgument(3)
	local RoutePointNumber	= TppData.GetArgument(1)

	if ( RouteName ==  GsRoute.GetRouteId( "ComEne17_TalkRoute" )) then
		if( RoutePointNumber == 11 ) then
			TppEnemy.EnableRoute( this.cpID , "S_Sen_Bridge" )
			TppEnemy.DisableRoute( this.cpID , "ComEne17_TalkRoute" )
			TppEnemy.ChangeRoute( this.cpID , "ComEne17","e20010_Seq20_SneakRouteSet","S_Sen_Bridge", 0 )
		else
		end
	else
	end
end
this.ComEne17_RouteChange = function()

	TppEnemy.EnableRoute( this.cpID , "ComEne17_TalkRoute" )
	TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortHouse" )
	TppEnemy.ChangeRoute( this.cpID , "ComEne17","e20010_Seq20_SneakRouteSet","ComEne17_TalkRoute", 0 )
end
--ヘリポート敵兵ComEne15会話
this.Talk_Helipad02 = function()

	local sequence = TppSequence.GetCurrentSequence()

	TppEnemy.EnableRoute( this.cpID , "ComEne15_TalkRoute" )
	TppEnemy.DisableRoute( this.cpID , "S_Sen_HeliPortFrontGate_a" )

	--シーケンスチェック
	if ( sequence == "Seq_RescueHostages" ) then
		TppEnemy.ChangeRoute( this.cpID , "ComEne15","e20010_Seq10_SneakRouteSet","ComEne15_TalkRoute", 0 )
	elseif ( sequence == "Seq_NextRescuePaz" ) then
		TppEnemy.ChangeRoute( this.cpID , "ComEne15","e20010_Seq20_SneakRouteSet","ComEne15_TalkRoute", 0 )
	else
		--何もしない
	end
end
--ComEne15ノードアクション
this.Select_ComEne15_NodeAction = function()
	local RouteName			= TppData.GetArgument(3)
	local RoutePointNumber	= TppData.GetArgument(1)
	local sequence			= TppSequence.GetCurrentSequence()
	--GsRoute.GetRouteIdは6/14以降廃止
	if ( RouteName ==  GsRoute.GetRouteId( "ComEne15_TalkRoute" )) then
		if( RoutePointNumber == 2 ) then
			TppEnemy.EnableRoute( this.cpID , "S_Sen_HeliPortFrontGate_a" ) 	--ルート有効
			TppEnemy.DisableRoute( this.cpID , "ComEne15_TalkRoute" ) 			--ルート無効
			--シーケンスチェック
			if ( sequence == "Seq_RescueHostages" ) then
				TppEnemy.ChangeRoute( this.cpID , "ComEne15","e20010_Seq10_SneakRouteSet","S_Sen_HeliPortFrontGate_a", 0 )	--指定敵兵ルートチェンジ
			elseif ( sequence == "Seq_NextRescuePaz" ) then
				TppEnemy.ChangeRoute( this.cpID , "ComEne15","e20010_Seq20_SneakRouteSet","S_Sen_HeliPortFrontGate_a", 0 )	--指定敵兵ルートチェンジ
			else
				--何もしない
			end
		else
		end
	else
	end
end
--拘束時無線
this.Radio_QustionAdvice = function()
	if( TppMission.GetFlag( "isDoCarryAdvice" ) == true ) then	
		TppRadio.DelayPlay("Miller_QustionAdvice", "short")
	end
end

--双眼鏡モードになったとき
this.Radio_BinocularsTutorial = function()
--[[	local radioDaemon = RadioDaemon:GetInstance()不要とのことでいったんコメントアウト

	if( TppMission.GetFlag( "isDoCarryAdvice" ) == true 
		and radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0930") == true ) then
		TppRadio.PlayEnqueue( "Miller_BinocularsTutorial" )
	end--]]
end
--双眼鏡モード
this.Radio_BinocularsModeOn = function()
	-- 今セットされている任意無線グループセットを見て、該当するものに切替える
	Fox.Log("optionalRadio set BinocularsMode_On")
	local radioDaemon = RadioDaemon:GetInstance()
	local binoJudge = radioDaemon:GetRadioGroupSetNameCurrentRegistered()

	local hash1 = radioDaemon.ConvertToGroupNameID( "Set_e0010_oprg0010" )
	local hash2 = radioDaemon.ConvertToGroupNameID( "Set_e0010_oprg0020" )
	local hash3 = radioDaemon.ConvertToGroupNameID( "Set_e0010_oprg0022" )
	local hash4 = radioDaemon.ConvertToGroupNameID( "Set_e0010_oprg0030" )

	if ( binoJudge == hash1 ) then
			TppRadio.RegisterOptionalRadio( "Optional_GameStartToRescueBino" )
	elseif ( binoJudge == hash2 ) then
			TppRadio.RegisterOptionalRadio( "Optional_RVChicoToRescuePazBino" )
	elseif ( binoJudge == hash3 ) then
			TppRadio.RegisterOptionalRadio( "Optional_InterrogationBino" )
	elseif ( binoJudge == hash4 ) then
			TppRadio.RegisterOptionalRadio( "Optional_RescuePazToRescueChicoBino" )
	end
end
--双眼鏡モード解除
this.Radio_BinocularsModeOff = function()
	-- 今セットされている任意無線グループセットを見て、該当するものに切替える
	Fox.Log("optionalRadio set BinocularsMode_Off")
	local radioDaemon = RadioDaemon:GetInstance()
	local binoJudge = radioDaemon:GetRadioGroupSetNameCurrentRegistered()

	local hash1 = radioDaemon.ConvertToGroupNameID( "Set_e0010_oprg1010" )
	local hash2 = radioDaemon.ConvertToGroupNameID( "Set_e0010_oprg1020" )
	local hash3 = radioDaemon.ConvertToGroupNameID( "Set_e0010_oprg1022" )
	local hash4 = radioDaemon.ConvertToGroupNameID( "Set_e0010_oprg1030" )

	if ( binoJudge == hash1 ) then
			TppRadio.RegisterOptionalRadio( "Optional_GameStartToRescue" )
	elseif ( binoJudge == hash2 ) then
			TppRadio.RegisterOptionalRadio( "Optional_RVChicoToRescuePaz" )
	elseif ( binoJudge == hash3 ) then
			TppRadio.RegisterOptionalRadio( "Optional_Interrogation" )
	elseif ( binoJudge == hash4 ) then
			TppRadio.RegisterOptionalRadio( "Optional_RescuePazToRescueChico" )
	end
end

--配電盤のお知らせ
this.Select_SwitchLightAdvice = function()
--[[	if( TppMission.GetFlag( "isPlaceOnHeliSpHostage" ) == true ) then不要とのことでいったんコメントアウト
		local RadioSet = {"Miller_CommonHostageInformation","Miller_SwitchLightAdvice01"}
		TppRadio.Play( RadioSet )
	else
	end--]]
end
--ヘリを呼んでくれ
this.Radio_NearRvEscapedTarget = function()
	if( TppMission.GetFlag( "isHeliComingRV" ) == false ) then
		TppRadio.Play( "Miller_NearRvEscapedTarget" )
	end
end

--旧収容所のやぐらに登った
this.Radio_SearchChico = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if( TppMission.GetFlag( "isSearchLightChicoArea" ) < 2 ) then
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_esrg0070") == false and radioDaemon:IsRadioGroupMarkAsRead("e0010_esrg0080") == false ) then
			TppRadio.DelayPlayEnqueue( "Miller_SearchChico", "short" )
		end
	end
end

--ミラーが応援してくれる
this.Radio_Cheer = function()
	if( TppMission.GetFlag( "isKeepCaution" ) == true ) then
		TppRadio.PlayEnqueue( "Miller_Cheer" )
	end
end

--CQCチュートリアル
this.Radio_CQCTutorial = function()
	local radioDaemon = RadioDaemon:GetInstance()

	if( TppMission.GetFlag( "isDoCarryAdvice" ) == true ) then
		if( TppMission.GetFlag( "isDoneCQC" ) == false ) then
			TppRadio.PlayEnqueue( "Miller_CqcAdvice" )
			TppMission.SetFlag( "isDoneCQC", true )	--説明を聞いたらCQCをしたことがあることにする
		elseif( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0680") == true ) then
			TppRadio.PlayEnqueue( "Miller_RestrictAdvice" )
		end
	end
end

--アラート状態で回収デモを見れる場所に置いた状態で、フェイズがコーションまで落ちた
this.Radio_RePazChicoAdvice = function()
	local sequence = TppSequence.GetCurrentSequence()

	--シーケンスチェック
	if ( sequence == "Seq_NextRescuePaz" ) then				-- 先にチコと会った
		TppRadio.PlayEnqueue("Miller_ReChicoAdvice")
	elseif ( sequence == "Seq_NextRescueChico" ) then		-- 先にパスと会った
--		TppRadio.PlayEnqueue("Miller_RePazAdvice")
	else
	end
end

--テープ促し後
this.EndTapeReAdvice = function()
	--任意無線変更
	TppRadio.RegisterOptionalRadio( "Optional_RVChicoToRescuePaz" )	
end

--アラート中だったらテープ促し無線をあとで再生するフラグをtrueにする
this.Check_AlertTapeReAdvice = function()
	local phase = TppEnemy.GetPhase( this.cpID )
	if ( phase == "alert" ) then
		TppMission.SetFlag( "isAlertTapeAdvice", true )
	else
		this.EndTapeReAdvice()
	end
end
--テープ促し無線がアラート中で流せなかったとき、フェイズが下がり次第再生する
this.Radio_AlertTapeReAdvice = function()
	if( TppMission.GetFlag( "isQuestionChico" ) == true ) then	--回収デモをみている
		TppRadio.Play("Miller_ChicoTapeAdvice02", { onEnd = this.EndTapeReAdvice } )
	else														--回収デモをみていない
		TppRadio.Play("Miller_ChicoTapeReAdvice")
	end
end


--パスチコ乗せた後ヘリに乗って促し無線タイマー
this.Timer_PlayerOnHeliAdviceStart = function()
	local timer = 5
	GkEventTimerManager.Start( "Timer_PlayerOnHeliAdvice", timer )
end

--パスチコ乗せた後ヘリに乗って促し無線
this.Radio_PlayerOnHeliAdvice = function()
	TppRadio.Play("Miller_PlayerOnHeliAdvice")
end

--捕虜を担いでヘリに乗ったら
this.Common_CarryHostageOnHeli = function()
	GkEventTimerManager.Stop( "Timer_PlayerOnHeliAdvice" )
end

--旧収容所付近に入ったとき
this.OptionalRadio_InOldAsylum = function()
	--チコのいる檻を諜報していなかったら任意無線を変更する
	local radioDaemon = RadioDaemon:GetInstance()
	if( radioDaemon:IsRadioGroupMarkAsRead("e0010_esrg0070") == false and radioDaemon:IsRadioGroupMarkAsRead("e0010_esrg0080") == false ) then
		TppRadio.RegisterOptionalRadio( "Optional_InOldAsylum" )
	else
		TppRadio.RegisterOptionalRadio( "Optional_DiscoveryChico" )
	end
end

--旧収容所から離れたとき
this.OptionalRadio_OutOldAsylum = function( optRadioID )
	--チコのいる檻を諜報していなかったら任意無線を元に戻す
	local radioDaemon = RadioDaemon:GetInstance()
	if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg0180") == true ) then
		TppRadio.RegisterOptionalRadio( "Optional_DiscoveryPaz" )			--0025
	elseif( radioDaemon:IsRadioGroupMarkAsRead("e0010_esrg0070") == false and radioDaemon:IsRadioGroupMarkAsRead("e0010_esrg0080") == false ) then
		TppRadio.RegisterOptionalRadio( optRadioID )
	end
end
--キャラエリアワープ：ヘリポート巨大ゲート前機銃装甲車
this.HostageWarp_FrontGateArmorVehicle = function()

	local pos = Vector3( -111.743 , 31.080 , 22.037 )
	local size = Vector3( 11.0 , 10.0 , 7.0 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp( "Chico" , "HW_Chico_FrontGateArmorVehicle" )
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_SpHostage_FrontGateArmorVehicle")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp("SpHostage", "HW_SpHostage_FrontGateArmorVehicle")
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp("Hostage_e20010_001", "HW_Hostage01_FrontGateArmorVehicle")
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp("Hostage_e20010_002", "HW_Hostage02_FrontGateArmorVehicle")
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp("Hostage_e20010_003", "HW_Hostage03_FrontGateArmorVehicle")
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp("Hostage_e20010_004", "HW_Hostage04_FrontGateArmorVehicle")
				end
			else
			end
		end
	else
	end
end
--キャラエリアワープ：東難民キャンプ四輪駆動車
this.HostageWarp_EastCampVehicle01 = function()

	local pos = Vector3( -33.052 , 27.140 , 190.926 )
	local size = Vector3( 5 , 6 , 4 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp( "Chico" , "HW_Chico_EastCampVehicle01" )
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_Paz_EastCampVehicle01")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp( "SpHostage" , "HW_SpHostage_EastCampVehicle01" )
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp( "Hostage_e20010_001" , "HW_Hostage01_EastCampVehicle01" )
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp( "Hostage_e20010_002" , "HW_Hostage02_EastCampVehicle01" )
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp( "Hostage_e20010_003" , "HW_Hostage03_EastCampVehicle01" )
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp( "Hostage_e20010_004" , "HW_Hostage04_EastCampVehicle01" )
				end
			else
			end
		end
	else
	end
end
--キャラエリアワープ：東難民キャンプトラック
this.HostageWarp_EastCampTruck = function()

	local pos = Vector3( -24.640 , 25.364 , 113.673 )
	local size = Vector3( 10 , 4 , 7 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp( "Chico" , "HW_Chico_EastCampTruck" )
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_Paz_EastCampTruck")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp( "SpHostage" , "HW_SpHostage_EastCampTruck" )
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp("Hostage_e20010_001", "HW_Hostage01_EastCampTruck")
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp("Hostage_e20010_002", "HW_Hostage02_EastCampTruck")
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp("Hostage_e20010_003", "HW_Hostage03_EastCampTruck")
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp("Hostage_e20010_004", "HW_Hostage04_EastCampTruck")
				end
			else
			end
		end
	else
	end
end
--キャラエリアワープ：秘密兵器トラック
this.HostageWarp_CarryWeaponTruck = function()

	local pos = Vector3( -139.098 , 27.944 , 177.126 )
	local size = Vector3( 10 , 8 , 5 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp( "Chico" , "HW_Chico_CarryWeaponTruck" )
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_Paz_CarryWeaponTruck")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp("SpHostage", "HW_SpHostage_CarryWeaponTruck")
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp("Hostage_e20010_001", "HW_Hostage01_CarryWeaponTruck")
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp("Hostage_e20010_002", "HW_Hostage02_CarryWeaponTruck")
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp("Hostage_e20010_003", "HW_Hostage03_CarryWeaponTruck")
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp("Hostage_e20010_004", "HW_Hostage04_CarryWeaponTruck")
				end
			else
			end
		end
	else
	end
end
--キャラエリアワープ：巨大ゲート通過トラック０１
this.HostageWarp_OpenGateTruck01 = function()

	local pos = Vector3( -14.309 , 26.228 , 112.424 )
	local size = Vector3( 4 , 6 , 8 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp( "Chico" , "HW_Chico_GateOpenTruck01" )
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_Paz_GateOpenTruck01")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp("SpHostage", "HW_SpHostage_GateOpenTruck01")
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp("Hostage_e20010_001", "HW_Hostage01_GateOpenTruck01")
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp("Hostage_e20010_002", "HW_Hostage02_GateOpenTruck01")
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp("Hostage_e20010_003", "HW_Hostage03_GateOpenTruck01")
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp("Hostage_e20010_004", "HW_Hostage04_GateOpenTruck01")
				end
			else
			end
		end
	else
	end
end
--キャラエリアワープ：巨大ゲート通過トラック０２
this.HostageWarp_OpenGateTruck02 = function()

	local pos = Vector3( -74.926 , 31.080 , 16.313 )
	local size = Vector3( 12 , 6 , 8 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp("Chico", "HW_SpHostage_GateOpenTruck02")
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_Paz_GateOpenTruck02")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp("SpHostage", "HW_SpHostage_GateOpenTruck02")
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp("Hostage_e20010_001", "HW_Hostage01_GateOpenTruck02")
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp("Hostage_e20010_002", "HW_Hostage02_GateOpenTruck02")
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp("Hostage_e20010_003", "HW_Hostage03_GateOpenTruck02")
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp("Hostage_e20010_004", "HW_Hostage04_OpenGateTruck02")
				end
			else
			end
		end
	else
	end
end
--キャラエリアワープ：巨大ゲート通過トラック０３
this.HostageWarp_OpenGateTruck03 = function()

	local pos = Vector3( -133.609 , 31.071 , 17.321 )
	local size = Vector3( 6 , 6 , 8 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp("Chico", "HW_Chico_GateOpenTruck03")
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_Paz_GateOpenTruck03")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp("SpHostage", "HW_SpHostage_GateOpenTruck03")
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp("Hostage_e20010_001", "HW_Hostage01_GateOpenTruck03")
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp("Hostage_e20010_002", "HW_Hostage02_GateOpenTruck03")
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp("Hostage_e20010_003", "HW_Hostage03_GateOpenTruck03")
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp("Hostage_e20010_004", "HW_Hostage04_GateOpenTruck03")
				end
			else
			end
		end
	else
	end
end
--キャラエリアワープ：管理棟を出る四輪駆動０１
this.HostageWarp_CenterOutVehicle01 = function()

	local pos = Vector3( -181.6569 , 31.071 , 11.82651 )
	local size = Vector3( 5 , 6 , 6 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp("Chico", "HW_Chico_CenterOutVehicle01")
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_Paz_CenterOutVehicle01")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp("SpHostage", "HW_SpHostage_CenterOutVehicle01")
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp("Hostage_e20010_001", "HW_Hostage01_CenterOutVehicle01")
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp("Hostage_e20010_002", "HW_Hostage02_CenterOutVehicle01")
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp("Hostage_e20010_003", "HW_Hostage03_CenterOutVehicle01")
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp("Hostage_e20010_004", "HW_Hostage04_CenterOutVehicle01")
				end
			else
			end
		end
	else
	end
end
--キャラエリアワープ：管理棟を出る四輪駆動０２
this.HostageWarp_CenterOutVehicle02 = function()

	local pos = Vector3( 34.867 , 17.141 , 218.102 )
	local size = Vector3( 4 , 6 , 5 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp("Chico", "HW_Chico_CenterOutVehicle02")
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_Paz_CenterOutVehicle02")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp("SpHostage", "HW_SpHostage_CenterOutVehicle02")
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp("Hostage_e20010_001", "HW_Hostage01_CenterOutVehicle02")
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp("Hostage_e20010_002", "HW_Hostage02_CenterOutVehicle02")
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp("Hostage_e20010_003", "HW_Hostage03_CenterOutVehicle02")
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp("Hostage_e20010_004", "HW_Hostage04_CenterOutVehicle02")
				end
			else
			end
		end
	else
	end
end
--キャラエリアワープ：倉庫機銃装甲車
this.HostageWarp_WareHouseArmorVehicle = function()

	local pos = Vector3( -112.754 , 27.944 , 158.058 )
	local size = Vector3( 6 , 8 , 8 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp("Chico", "HW_Chico_WareHouseArmorVehicle")
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_Paz_WareHouseArmorVehicle")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp("SpHostage", "HW_SpHostage_WareHouseArmorVehicle")
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp("Hostage_e20010_001", "HW_Hostage01_WareHouseArmorVehicle")
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp("Hostage_e20010_002", "HW_Hostage02_WareHouseArmorVehicle")
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp("Hostage_e20010_003", "HW_Hostage03_WareHouseArmorVehicle")
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp("Hostage_e20010_004", "HW_Hostage04_WareHouseArmorVehicle")
				end
			else
			end
		end
	else
	end
end
--キャラエリアワープ：旧収容施設四輪駆動車
this.HostageWarp_AsylumVehicle = function()

	local pos = Vector3( 46.939 , 16.911 , 182.370 )
	local size = Vector3( 5 , 8 , 4 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp("Chico", "HW_Chico_CenterOutVehicle02")
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_Paz_CenterOutVehicle02")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp("SpHostage", "HW_SpHostage_CenterOutVehicle02")
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp("Hostage_e20010_001", "HW_Hostage01_CenterOutVehicle02")
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp("Hostage_e20010_002", "HW_Hostage02_CenterOutVehicle02")
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp("Hostage_e20010_003", "HW_Hostage03_CenterOutVehicle02")
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp("Hostage_e20010_004", "HW_Hostage04_CenterOutVehicle02")
				end
			else
			end
		end
	else
	end
end
--キャラエリアワープ：ヘリポートゲート前機銃装甲車
this.HostageWarp_HeliPortFrontGateArmorVehicle = function()

	local pos = Vector3( -88.168 , 31.080 , 19.823 )
	local size = Vector3( 8 , 8 , 10 )
	local npcIds = TppNpcUtility.GetNpcByBoxShape( pos , size )

	if npcIds and #npcIds.array > 0 then
		for i,id in ipairs(npcIds.array) do
			local type = TppNpcUtility.GetNpcType( id )
			if type == "Hostage" then
				local characterId = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
				if( characterId =="Chico" )then
					TppEnemy.Warp("Chico", "HW_Chico_GateOpenTruck02")
				elseif( characterId =="Paz" )then
					TppEnemy.Warp("Paz", "HW_Paz_GateOpenTruck02")
				elseif( characterId =="SpHostage" )then
					TppEnemy.Warp("SpHostage", "HW_SpHostage_GateOpenTruck02")
				elseif( characterId =="Hostage_e20010_001" )then
					TppEnemy.Warp("Hostage_e20010_001", "HW_Hostage01_GateOpenTruck02")
				elseif( characterId =="Hostage_e20010_002" )then
					TppEnemy.Warp("Hostage_e20010_002", "HW_Hostage02_GateOpenTruck02")
				elseif( characterId =="Hostage_e20010_003" )then
					TppEnemy.Warp("Hostage_e20010_003", "HW_Hostage03_GateOpenTruck02")
				elseif( characterId =="Hostage_e20010_004" )then
					TppEnemy.Warp("Hostage_e20010_004", "HW_Hostage04_GateOpenTruck02")
				end
			else
			end
		end
	else
	end
end
-- 監視カメラ破壊
this.Common_SecurityCameraBroken = function()
	local characterID = TppData.GetArgument( 1 )
--	TppRadio.DisableIntelRadio( characterID )
	TppRadio.RegisterIntelRadio( characterID, "e0010_esrg0471", true )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap_SecurityCameraAdvice", "Radio_SecurityCameraAdvice", false , false )
end
-- 監視カメラ電源オフ
this.Common_SecurityCameraPowerOff = function()
	local characterID = TppData.GetArgument( 1 )
--	TppRadio.DisableIntelRadio( characterID )
	TppRadio.RegisterIntelRadio( characterID, "e0010_esrg0471", true )
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap_SecurityCameraAdvice", "Radio_SecurityCameraAdvice", false , false )
end
-- 監視カメラ電源オン
this.Common_SecurityCameraPowerOn = function()
	local characterID = TppData.GetArgument( 1 )
	TppRadio.EnableIntelRadio( characterID)
	TppRadio.RegisterIntelRadio( characterID, "e0010_esrg0470", true )
end
--監視カメラに見つかる
this.Common_SecurityCameraAlert = function()
	TppDataUtility.SetEnableDataFromIdentifier( "e20010_Trap_SecurityCameraAdvice", "Radio_SecurityCameraAdvice", false , false )
end

--監視カメラの近くに入った
this.Radio_SecurityCameraAdvice = function()
	local phase = TppEnemy.GetPhase( this.cpID )
	if ( phase == "alert" ) then
	else
		TppRadio.Play( "Miller_SecurityCameraAdvice" )
	end
end

--危険エリアでチコパスを降ろした
this.Radio_CarryDownInDanger = function()
	if( TppMission.GetFlag( "isHostageOnVehicle") == false and
		TppMission.GetFlag( "isHeliLandNow" ) == false ) then
		TppRadio.DelayPlayEnqueue("Miller_CarryDownInDanger", "short")
	end
	TppMission.SetFlag( "isHostageOnVehicle", false )
end

--危険エリアでチコパスを車両に乗せた
this.Common_HostageOnVehicleInDangerArea = function()
	local VehicleID = TppData.GetArgument( 3 )

	if( VehicleID == "SupportHelicopter" ) then
		--ヘリに乗せたときはフラグは立たせない
	else
		if( TppMission.GetFlag( "isDangerArea" ) == true ) then
			TppMission.SetFlag( "isHostageOnVehicle", true )
		end
	end
end
------------------------------------------------------------------
-- チコパス諜報無線後処理
------------------------------------------------------------------
-- チコ
this.Chico_Espion = function()
	if( TppMission.GetFlag( "isPlaceOnHeliChico" ) == false ) then
		local sequence = TppSequence.GetCurrentSequence()

		-- 共通処理
		TppMarkerSystem.DisableMarker{ markerId = "20010_marker_Chico" }
		TppMarker.Enable( "20010_marker_ChicoPinpoint" , 0 , "moving" , "all" , 0 , false )
		TppMarker.Enable( "Chico" , 0 , "none" , "map_and_world_only_icon" , 0 , true )

			-- マークＳＥ
			if( TppMission.GetFlag( "isChicoMarkJingle" ) == false ) then
				GZCommon.CallSearchTarget()
				TppMission.SetFlag( "isChicoMarkJingle", true )
			end
		-- シーケンス専用処理
		if ( sequence == "Seq_RescueHostages" ) then
			TppRadio.RegisterIntelRadio( "SL_WoodTurret05", "e0010_esrg0010", true )	--旧収容所サーチライトの諜報無線を元に戻す
			TppRadio.RegisterOptionalRadio( "Optional_DiscoveryChico" )					--任意無線登録
		end
	end
end
-- パス
this.Paz_Espion = function()
	if( TppMission.GetFlag( "isPlaceOnHeliPaz" ) == false ) then
					
		-- 共通処理
		TppMarkerSystem.DisableMarker{ markerId = "20010_marker_Paz" }
		TppMarker.Enable( "Paz" , 0 , "none" , "map_and_world_only_icon" , 0 , true )

			-- マークＳＥ
			if( TppMission.GetFlag( "isPazMarkJingle" ) == false ) then
				GZCommon.CallSearchTarget()
				TppMission.SetFlag( "isPazMarkJingle", true )
			end

		TppRadio.RegisterOptionalRadio( "Optional_DiscoveryPaz" )
		TppRadio.RegisterIntelRadio( "intel_e0010_esrg0100", "e0010_esrg0101", true )
	end
end
------------------------------------------------------------------
-- デモ関係
------------------------------------------------------------------
-- プレイヤーの移動補正位置を取得
this.getDemoStartPos = function( demoId )
	Fox.Log(":: get demo start position ::")
	if( demoId ~= nil )then
		Fox.Log( demoId )
		local body = DemoDaemon.FindDemoBody( demoId )
		local data = body.data
		local controlCharacters = data.controlCharacters
		for k, controlCharacter in pairs(controlCharacters) do
			local characterId = controlCharacter.characterId
			Fox.Log("id = " .. characterId )
			local translation = controlCharacter.startTranslation
			Fox.Log("x = " .. translation:GetX() .. " y = ".. translation:GetY() .. " z = " .. translation:GetZ())
			local rotation = controlCharacter.startRotation
			Fox.Log("x = " .. Quat.GetX(rotation) .. " y = ".. Quat.GetY(rotation) .. " z = " .. Quat.GetZ(rotation) .. " w = ".. Quat.GetW(rotation))
			-- プレイヤーの値のみを返す
			if( characterId == "Player")then

				local direction = rotation:Rotate( Vector3( 0.0, 0.0, 1.0 ) )
				local angle = foxmath.Atan2( direction:GetX(), direction:GetZ() )
				local degree = foxmath.RadianToDegree( angle )

				return translation, degree
			end
		end
	end
end


----------------------------------------------------------------------------------------------------------------------------
--ゲーム開始～１人目に会うまで
-----------------------------------------------------------------------------------------------------------------

--写真を見たとき
this.Mb_WatchPhoto = function()
	local photLookFunc = {
		onEnd = function()
			local radioDaemon = RadioDaemon:GetInstance()
			if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1410") == true 
				and radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1420") == true ) then
				-- 写真全部見てるなら〆の無線再生
				TppRadio.DelayPlayEnqueue( "Miller_WatchPhotoAll", "short", "end" )
			else
				-- 写真全部見てないなら無線終了SEだけコール
				TppSoundDaemon.PostEvent( "Play_sfx_s_codec_NPC_end" )
			end
		end,
	}

	local photoID = TppData.GetArgument( 1 )
--	Fox.Log("========================================"..photoID)
	local radioDaemon = RadioDaemon:GetInstance()
	local watchFirst = false
	if( radioDaemon:IsRadioGroupMarkAsRead("e0010_rtrg1429") == false ) then
		-- この無線を再生したことがないなら
		TppRadio.DelayPlayEnqueue( "Miller_WatchPhotoStart", "short", "end" )
		watchFirst = true
	end

	local RadioName
	if( photoID == 30 ) then
		RadioName = "Miller_WatchPhotoPaz"
	else
		RadioName = "Miller_WatchPhotoChico"
	end

	if watchFirst == true then
		TppRadio.DelayPlayEnqueue( RadioName, "short", "begin", photLookFunc )
	else
		TppRadio.DelayPlay( RadioName, "short", "begin", photLookFunc )
	end
end
--キープコーション時のサイレンを鳴らすタイマー
this.Timer_CallCautionSiren = function()
	GZCommon.CallCautionSiren()
	--BGM設定
	TppMusicManager.SetSwitch{
		groupName = "bgm_phase_ct_level",
		stateName = "bgm_phase_ct_level_02",
	}
end
--雰囲気無線：パスの居場所がわからず焦るミラー1
this.Radio_RescuePaz1Timer = function()
	local timer = 600
	GkEventTimerManager.Start( "Timer_RescuePaz1", timer )
end
this.Radio_RescuePaz1TimerStop = function()
	GkEventTimerManager.Stop( "Timer_RescuePaz1" )
end
this.Radio_RescuePaz1 = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then
		TppRadio.Play("Miller_RescuePaz1")
	end
end

--雰囲気無線：パスの居場所がわからず焦るミラー2
this.Radio_RescuePaz2Timer = function()
	local timer = 900
	GkEventTimerManager.Start( "Timer_RescuePaz2", timer )
end
this.Radio_RescuePaz2TimerStop = function()
	GkEventTimerManager.Stop( "Timer_RescuePaz2" )
end
this.Radio_RescuePaz2 = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then
		TppRadio.Play("Miller_RescuePaz2")
	end
end

--雰囲気無線
this.Radio_MillerHistory1 = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then
		TppRadio.DelayPlay( "Miller_MillerHistory1", "mid" )
	end
end

--
this.Radio_GetPazInfo = function()
--	TppRadio.DelayPlay( "Miller_GetPazInfo", "short" )
end

--
this.Radio_ListenTape = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then
		TppRadio.Play( "Miller_TapeReaction07" )
	end
end

--ドラマ無線：パスのこと
this.Radio_DramaPaz = function()
	TppMission.SetFlag( "isDramaPazArea", true )

	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()
	if( VehicleId == "" ) then
		TppRadio.DelayPlayEnqueue( "Miller_DramaPaz1", "long", "begin", {onEnd = function()
				local radioDaemon = RadioDaemon:GetInstance()
				if ( radioDaemon:IsPlayingRadio() == false ) then
					if( TppMission.GetFlag( "isDramaPazArea") == true ) then
						TppRadio.Play( "Miller_DramaPaz2", nil, nil, nil, "end" )
					else
						TppSoundDaemon.PostEvent( "Play_sfx_s_codec_NPC_end" )
					end
				end
		end}, nil )
	end
end
--ドラマ無線：チコのこと
this.Radio_DramaChico = function()
	TppMission.SetFlag( "isAsylumRadioArea", true )

--	this.OnVehicleCheckRadioPlayEnqueue( "Miller_DramaChico", "short" )
	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()
	if( VehicleId == "" ) then
		TppRadio.Play( "Miller_DramaChico", {onEnd = function()
				local radioDaemon = RadioDaemon:GetInstance()
				if ( radioDaemon:IsPlayingRadio() == false ) then
					if( TppMission.GetFlag( "isAsylumRadioArea") == true ) then
						TppRadio.Play( "Miller_Drama2Chico", nil, nil, nil, "end" )
					else
						TppSoundDaemon.PostEvent( "Play_sfx_s_codec_NPC_end" )
					end
				end
		end}, nil, nil, "begin" )
	end
end

--ドラマ無線：カズとの思い出（コロンビアからPW）起動タイマー
this.Radio_StartCliffTimer = function()
	if( TppMission.GetFlag( "isDoCarryAdvice" ) == false ) then
		local timer = 5
		GkEventTimerManager.Start( "Timer_StartCliff", timer )
	end
end
--ドラマ無線：カズとの思い出（コロンビアからPW）本体
this.Radio_StartCliff = function()
	local radioDaemon = RadioDaemon:GetInstance()
	if( radioDaemon:IsPlayingRadio() == false and
		TppMission.GetFlag( "isHeliComingRV" ) == false ) then
		TppRadio.PlayEnqueue("Miller_MillerHistory2")
	end
end

--周辺チェック
this.playerNearCheck = function( characterID )

	Fox.Log( "!!!!!playerNearCheck!!!!!" )

	local pos		= TppPlayerUtility.GetLocalPlayerCharacter():GetPosition()	-- BOX位置
	local size		= Vector3( 20, 12, 20 )										-- BOXサイズ
	local rot		= Quat( 0.0 , 0.0, 0.0, 0.0 )								-- BOX回転
	local npcIds	= TppNpcUtility.GetNpcByBoxShape( pos, size, rot )

	-- characterIDのUniqueIdを取得
	local charaObj = Ch.FindCharacterObjectByCharacterId( characterID )
	if Entity.IsNull( charaObj ) then
		Fox.Log("--- playerNearCheck:charaObj is Null! -----")
		return false
	end
	local chara = charaObj:GetCharacter()
	local uniqueId = chara:GetUniqueId()

	-- 検索範囲内に居る敵兵のUniqueId分チェックする
	if( npcIds and #npcIds.array > 0 ) then
		for i,id in ipairs(npcIds.array) do
			Fox.Log("OutsideAreaMastermindCheck::::::::ID"..id)
			-- IDと照合
			if ( id == uniqueId ) then
				return true
			end
		end
	end

	return false

end

this.Radio_DiscoveryPaz = function()

	local radioDaemon = RadioDaemon:GetInstance()
	local phase = TppEnemy.GetPhase( this.cpID )
	if ( phase == "alert" or phase == "evasion" ) then
	else
		if( radioDaemon:IsRadioGroupMarkAsRead("e0010_esrg0100") == false ) then
			TppRadio.Play( "Miller_DiscoveryPaz", { onEnd = function()
				TppRadio.RegisterOptionalRadio( "Optional_DiscoveryPaz" )
				TppRadio.RegisterIntelRadio( "intel_e0010_esrg0100", "e0010_esrg0101", true )
			end} )
		end
	end

end

-----------------------------------------------------------------------------------------------------------------
--１人目チコで、パスに会うまで
-----------------------------------------------------------------------------------------------------------------

-- カセットテープを再生した
this.Common_PlayListenTape = function()
	local CassetteId = TppData.GetArgument(1)

	if ( CassetteId == "tp_chico_03" and TppMission.GetFlag( "isChicoTapePlay" ) == false ) then
	--	TppRadio.Play("Miller_TapeReaction07")
		TppMission.SetFlag( "isChicoTapePlay", true )
	else
	end
end

-- 脱走捕虜状態判定
this.SpHostageStatus = function()

	if( TppMission.GetFlag( "isCarryOnSpHostage" ) == false ) and			--脱走捕虜を担いだことがある
		( TppMission.GetFlag( "isSpHostage_Dead" ) == false ) and			--脱走捕虜死んでいない
		( TppMission.GetFlag( "isPlaceOnHeliSpHostage" ) == false ) then	--脱走捕虜をヘリで回収していない
		KillWaiting_SpHostahe_EnemyPos()								--脱走捕虜処刑待ち配置
	else
		NoKillWaiting_SpHostahe_EnemyPos()								--脱走捕虜処刑待ち配置（仮）
	end
end
-------------------------------------------------------------------------------------------------------------------------
--チコに会ってからパスに会うまで
-----------------------------------------------------------------------------------------------------------------
-- Seq20尋問設定
this.Seq20_Interrogation = function()
	-- 尋問誘導無線が流れた
	if( TppMission.GetFlag( "isInterrogation_Radio" ) == true ) then
		local CountInterrogation = TppMission.GetFlag( "isInterrogation_Count" )
		-- カウント増加
		TppMission.SetFlag( "isInterrogation_Count", ( CountInterrogation + 1 ) )
		CountInterrogation = CountInterrogation + 1

--		if( CountInterrogation == 0 ) then
--			Fox.Log (" PazHint_01 ")
--			TppEnemyUtility.SetInterrogationForceCharaIdAllCharacter( "PazHint_01" )	-- パスヒント１を言う
		if( CountInterrogation == 1 ) then
			Fox.Log (" Common Interrogation ")
			TppEnemyUtility.UnsetInterrogationForceCharaIdAllCharacter()	-- 初期化
		elseif( CountInterrogation == 2 ) then
			Fox.Log (" PazHint_02 ")
			TppEnemyUtility.SetInterrogationForceCharaIdAllCharacter( "PazHint_02" )	-- パスヒント２を言う
		elseif( CountInterrogation == 3 ) or ( CountInterrogation == 4 ) then
			Fox.Log (" Common Interrogation ")
			TppEnemyUtility.UnsetInterrogationForceCharaIdAllCharacter()	-- 初期化
		elseif( CountInterrogation == 5 ) then
			Fox.Log (" PazHint_03 ")
			TppEnemyUtility.SetInterrogationForceCharaIdAllCharacter( "PazHint_03" )	-- パスヒント３を言う
		elseif( CountInterrogation == 6 ) then
			Fox.Log (" Common Interrogation ")
			TppEnemyUtility.UnsetInterrogationForceCharaIdAllCharacter()	-- 初期化			
		end
	else
		-- 尋問誘導無線が鳴ってない
		Fox.Log (" Common Interrogation == false ")
	end
end
-- 尋問内容変更（尋問２を言った後）
this.Common_interrogation_B = function()
	local hudCommonData = HudCommonDataManager.GetInstance()
	--アナウンスログ
--	hudCommonData:AnnounceLogViewLangId( "announce_map_update" )
	--ボイラー室（パス）マーカーＯＮ
	TppMarker.Enable( "20010_marker_Paz", 2 , "moving" , "all" , 0 , true , true )
	--アナウンスログ
	hudCommonData:AnnounceLogViewLangId( "announce_mission_info_update" )
	--中間目標設定
	commonUiMissionSubGoalNo(5)
	--任意無線変更
	TppRadio.RegisterOptionalRadio( "Optional_ChicoOnHeli" )		--0021
	
	TppRadio.DelayPlay( "Miller_GetPazInfo", "long" )
	--パスが見つからない無線タイマーをとめる
	this.Radio_RescuePaz1TimerStop()
	this.Radio_RescuePaz2TimerStop()
	--テープ促し無線再生フラグをおろす
	TppMission.SetFlag( "isAlertTapeAdvice", false )
end
--パスのいる檻の前についた(先チコシーケンス用)
this.NextRescuePaz_DiscoveryPaz = function()
	TppMission.SetFlag( "isAlertTapeAdvice", false )
	TppRadio.RegisterOptionalRadio( "Optional_DiscoveryPaz" )
	--パスが見つからない無線タイマーをとめる
	this.Radio_RescuePaz1TimerStop()
	this.Radio_RescuePaz2TimerStop()
end
-------------------------------------------------------------------------------------------------------------------------
--パスに会ってからチコに会うまで
-----------------------------------------------------------------------------------------------------------------
this.PazCarryStart = function()

	local phase = TppEnemy.GetPhase( this.cpID )
	TppMission.SetFlag( "isPazChicoDemoArea", false )

	if ( phase == "alert" ) then
		--何もしない
	else
		if( TppMission.GetFlag( "isChicoPaz1stCarry" ) == false ) then
			TppMusicManager.PostJingleEvent( 'SuspendPhase', 'Play_bgm_e20010_jingle_rescue' )
			TppMission.SetFlag( "isChicoPaz1stCarry", true )
		else
		end
	end
end

return this
