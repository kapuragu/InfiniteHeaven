local this = {}

------------------------------------------------------------------------
-- from "TppCommon"
------------------------------------------------------------------------
this.RequiredFiles = {
	"/Assets/tpp/script/common/TppClock.lua",
	"/Assets/tpp/script/common/TppData.lua",
	"/Assets/tpp/script/common/TppDemo.lua",
	"/Assets/tpp/script/common/TppEffect.lua",
	"/Assets/tpp/script/common/TppEnemy.lua",
	"/Assets/tpp/script/common/TppGimmick.lua",
	"/Assets/tpp/script/common/TppHelicopter.lua",
	"/Assets/tpp/script/common/TppLocation.lua",
	"/Assets/tpp/script/common/TppMarker.lua",
	"/Assets/tpp/script/common/TppMission.lua",
	"/Assets/tpp/script/common/TppPlayer.lua",
	"/Assets/tpp/script/common/TppRadio.lua",
	"/Assets/tpp/script/common/TppSequence.lua",
	"/Assets/tpp/script/common/TppSound.lua",
	"/Assets/tpp/script/common/TppStaticModel.lua",
	"/Assets/tpp/script/common/TppTimer.lua",
	"/Assets/tpp/script/common/TppUI.lua",
	"/Assets/tpp/script/common/TppUtility.lua",
	"/Assets/tpp/script/common/TppWeather.lua",
}

-- Register necessary data
this.Register = function( script, manager, type )
	type = type or "mission"

	-- Do for any type
	TppSequence.Register( script, manager, type )

	-- Only do for location
	if( type == "location" ) then
		TppLocation.Register( script )

	-- Only do for mission
	elseif( type == "mission" ) then
		TppDemo.Register( script.DemoList )
		TppMission.Register( script.missionID, script.MissionFlagList )
		TppRadio.Register( script.RadioList, script.OptionalRadioList, script.IntelRadioList )

		-- Start initialization procedures for other common scripts
		TppDemo.Start()
		TppMission.Start()
		TppRadio.Start()
		TppSound.Start()
		TppUI.Start()
	end
end

this.RequiredFiles = {
	"/Assets/tpp/script/common/GZWeapon.lua",
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■■ Member Variables
------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ミッション失敗時のフェードアウト開始までの時間(sec)
this.FadeOutTime_MissionFailed	= 1.4

-- プレイヤー落下死亡によるミッション失敗時のフェードアウト開始までの時間(sec)
this.FadeOutTime_PlayerFallDead	= 0.03

-- ミッションクリア時のフェードアウト開始までの時間(sec)
this.FadeOutTime_MissionClear	= 1.6

-- ミッションクリア条件未達成でヘリに乗り込んだ場合の飛び立つまでの猶予時間(sec)
this.WaitTime_HeliTakeOff	= 10

-- ミッションヒント写真の確認を促す無線のコールチェックを行う間隔(sec)
this.Time_HintPhotoCheck	= (60*2)

------------------------------------------------------------------
-- ミッション圏外演出関連
------------------------------------------------------------------
-- 車両によるミッション圏外終了時の速度(km/h)
this.VehicleSpeed_OutsideArea = 50

-- 車両によるミッション圏外終了時に車両ワープさせる座標、向き：西検問側
this.VehicleWarpPos_OutsideAreaWest = { -297.319, 28.672, 172.444 }
this.VehicleWarpAngle_OutsideAreaWest = -135.0

-- 車両によるミッション圏外終了時に車両ワープさせる座標、向き：北検問側
this.VehicleWarpPos_OutsideAreaNorth = { 33.611, 30.831, 45.635 }
this.VehicleWarpAngle_OutsideAreaNorth = 150.0

-- 徒歩によるミッション圏外終了時にPlayerを向かわせる座標：西検問側
this.PlayerMovePos_OutsideAreaWest = Vector3(-326.115, 28.693, 143.885)

-- 徒歩によるミッション圏外終了時にPlayerを向かわせる座標：北検問側
this.PlayerMovePos_OutsideAreaNorth = Vector3(51.198, 30.795, 14.387)

-- ミッション圏外演出カメラOffSet値：四輪駆動車
this.OutsideAreaCamOffSetPos_LightVehicle = { 1.7, 1.2, 20 }

-- ミッション圏外演出カメラOffSet値：トラック
this.OutsideAreaCamOffSetPos_Truck = { 2.8, 2.0, 20 }

-- ミッション圏外演出カメラOffSet値：機銃装甲車
this.OutsideAreaCamOffSetPos_MgWav = { 3.9, 2.5, 23 }

-- ミッション圏外演出カメラOffSet値：人
this.OutsideAreaCamOffSetPos_Human = { 2, 0.8, 5 }

-- ミッション圏外エフェクト用フラグ
this.isOutOfMissionEffectEnable = true

-- プレイヤーがミッション圏外警告エリアに入ってるかどうか
this.isPlayerWarningMissionArea = false

------------------------------------------------------------------

-- プレイヤーの所属エリア名
this.PlayerAreaName = "WareHouse"	-- 初期状態はこれで

-- プレイヤーが搭乗中の車両CharaID
this.PlayerOnVehicle = "NoRide"

-- プレイヤーが荷台に乗っているか
this.PlayerOnCargo = "NoRide"

-- 管理棟巨大ゲートを移動する車両データ
this.BigGateVehicleData = {}

-- 管理棟巨大ゲートで使用する無線名前
this.BigGateCallRadioName = "CPRGZ0020"

-- 管理棟巨大ゲートが開く時間
this.BigGateOpenTimer = (5)

-- 管理棟巨大ゲート開いたフラグ
this.BigGateOpenFlag = false

-- 管理棟巨大ゲートが開いていた場合の時間
this.BigGateOpenToRouteTimer = (1)

-- ヘリ離脱時のCP無線フェードアウト開始までのタイムラグ
this.Time_CpRadioFadeOutStart = (5.0)
-- ヘリ離脱時のCP無線フェードアウト自体にかける時間
this.Time_CpRadioFadeOut = (15.0)

-- 敵勢力の対空行動判定用フラグ
this.EnemyAntiAirActCheck = false

-- プレイヤーのヘリ離脱中判定フラグ
this.PlayerEscapeOnHeli = false

-- チコパス死亡時デモカメラ名
this.ChicoPazDeadRideOnHelicopter = false

-- チコパス死亡時演出カメラOffSet値
this.CamOffSetPos_Paz = { 0, -0.5, -3.0 }

-- ユニークキャラデータ
this.UniqueCharacterId_AnnounceLog = {}

this.DefaultAmmoCountOnContinueMission	= {
	{ "WP_ar00_v00", 150 },
	{ "WP_ar00_v01", 150 },
	{ "WP_ar00_v03", 150 },
	{ "WP_ar00_v03b", 150 },
	{ "WP_ar00_v05", 150 },
	{ "WP_hg00_v01", 21 },
	{ "WP_hg01_v00", 14 },
	{ "WP_hg02_v00", 15 },
	{ "WP_sg01_v00", 30 },
	{ "WP_sm00_v00", 150 },
	{ "WP_sr01_v00", 10 },
	{ "WP_ms02", 3 },
	{ "WP_Grenade", 2 },
	{ "WP_SmokeGrenade", 2 },
	{ "WP_WarningFlare", 2 },
	{ "WP_C4", 3 },
	{ "WP_Claymore", 3 },
}

-- 直近のVehicleGroupInfoを保持するワーク
this.LastVehicleGroupInfo_routeInfoName = ""
this.LastVehicleGroupInfo_vehicleRouteId = ""
this.LastVehicleGroupInfo_passedNodeIndex = 0
this.LastVehicleGroupInfo_memberCharacterIds = nil
this.LastVehicleGroupInfo_vehicleCharacterId = ""

---------------------------------------------------------------------------------
-- Public Functions
---------------------------------------------------------------------------------
-- ■■ Mission Function
-------------------------------------------
-- ■ MissionPrepare
this.MissionPrepare = function()

	-- 装備携行品の設定など

end
-------------------------------------------
-- ■ MissionSetup
this.MissionSetup = function()

	-- 保険処理としてサイレン停止を発行しておく
	this.StopSirenForcibly()

	-- ミッション圏外エフェクトの停止
	TppOutOfMissionRangeEffect.Disable( 0 )

	-- 管理棟巨大ゲート車両データ初期化
	this.Common_CenterBigGateVehicleInit()

	-- プレイヤーが搭乗中の車両CharaIDを初期化
	this.PlayerOnVehicle = "NoRide"
	this.PlayerOnCargo = "NoRide"

	-- ユニークキャラデータ初期化
	this.UniqueCharacterId_AnnounceLog = {}

	-- CP無線をリセット（保険処理）
	TppEnemyUtility.ResetCpRadioManager()

	-- 敵勢力の対空行動判定用フラグ初期化
	this.EnemyAntiAirActCheck = false

	-- プレイヤーのヘリ離脱中判定フラグ初期化
	this.PlayerEscapeOnHeli = false

	-- 管理塔巨大ゲートの開閉状態をスイッチの状態に同期
	-- 状態が1なら開閉状態
	if ( TppGadgetManager.GetGadgetStatus("gntn_BigGateSwitch") == 1 ) then
		this.BigGateOpenFlag = true
		TppGadgetUtility.SetSwitch("gntn_BigGateSwitch","lock")
		TppGadgetUtility.SetDoor{ id = "gntn_BigGate", isVisible = true, isOpen = true }
	else
		this.BigGateOpenFlag = false
		TppGadgetUtility.SetSwitch("gntn_BigGateSwitch","unlock")
		TppGadgetUtility.SetDoor{ id = "gntn_BigGate", isVisible = true, isOpen = false }
	end

	-- ミッションコンティニュー時の最低保障回復弾数
	Fox.Log("*** GZWeapon:SetAmmoCountOnContinueMission ***")
	TppPlayerUtility.SetAmmoCountOnContinueMission( this.DefaultAmmoCountOnContinueMission )
end
-------------------------------------------
-- ■ MissionCleanup
this.MissionCleanup = function()

	-- サイレン停止
	this.StopSirenForcibly()

	-- タイマーの停止
	TppTimer.StopAll()

	-- 強字幕設定の無効化
	SubtitlesCommand.SetIsEnabledUiPrioStrong( false )

	-- プログラム側で無線停止、字幕停止を行うようになったのでバッティングを避けるためコメントアウト
	-- 再生中の無線停止
	-- local radioDaemon = RadioDaemon:GetInstance()
	-- radioDaemon:StopDirect()
	-- 字幕の停止
	-- SubtitlesCommand.StopAll()

	-- ミッション圏外エフェクトの停止
	TppOutOfMissionRangeEffect.Disable( 0 )

	-- 圏外エフェクト有効フラグを元に戻しておく
	this.isOutOfMissionEffectEnable = true

	-- 管理棟巨大ゲート車両データ初期化
	this.Common_CenterBigGateVehicleInit()

	-- 管理棟巨大ゲート開いたフラグ初期化
--	this.BigGateOpenFlag = false

	-- チコパスがヘリで死んだフラグ
	this.ChicoPazDeadRideOnHelicopter = false

	-- プレイヤーが搭乗中の車両CharaIDを初期化
	this.PlayerOnVehicle = "NoRide"
	this.PlayerOnCargo = "NoRide"

	-- プレイヤーがミッション圏外警告エリアに入ってる初期化
	this.isPlayerWarningMissionArea = false

	-- ユニークキャラデータ初期化
	this.UniqueCharacterId_AnnounceLog = {}

	-- CP無線をリセット
	TppEnemyUtility.ResetCpRadioManager()

	-- 敵勢力の対空行動判定用フラグ初期化
	this.EnemyAntiAirActCheck = false

	-- プレイヤーのヘリ離脱中判定フラグ初期化
	this.PlayerEscapeOnHeli = false

	-- ヘリ脱出BGMを停止
	this.StopHeliEscapeBGM()

	-- ボイラー室埃エフェクトをOFF
	TppDataUtility.DestroyEffectFromGroupId( "dstcomviw" )

end
-------------------------------------------
-- ■ ShowCommonAnnounceLog
this.ShowCommonAnnounceLog = function( LangId )

	if LangId == nil then return end

	Fox.Log( "---- GZCommon:ShowCommonAnnounceLog ----"..LangId)

	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( LangId )
end
---------------------------------------------------------------------------------
-- ■■ Staging Function
-------------------------------------------
-- ■ OutsideAreaVoiceStart
-- ミッション圏外iDoroid音声再生開始
this.OutsideAreaVoiceStart = function()
	Fox.Log( "---- GZCommon:OutsideAreaVoiceStart ----")

	-- ミッション圏外警告エリア内に入っているかチェック
	if ( this.isPlayerWarningMissionArea ) then
		-- ミッション圏外に近づいたときの警告アナウンスを鳴らす
		local commonDataManager = UiCommonDataManager.GetInstance()
		if commonDataManager == NULL then return end

		local luaData = commonDataManager:GetUiLuaExportCommonData()
		if luaData == NULL then return end

		luaData:RequestMbSoundControllerVoice( "VOICE_WARN_MISSION_AREA", true, 1.0 ) --再生リクエスト
	end
end

-------------------------------------------
-- ■ OutsideAreaVoiceEnd
-- ミッション圏外iDoroid音声再生停止
this.OutsideAreaVoiceEnd = function()
	Fox.Log( "---- GZCommon:OutsideAreaVoiceEnd ----")

	-- ミッション圏外に近づいたときの警告アナウンスを止める
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager == NULL then return end

	local luaData = commonDataManager:GetUiLuaExportCommonData()
	if luaData == NULL then return end

	luaData:RequestMbSoundControllerVoice( "VOICE_WARN_MISSION_AREA", false ) --停止リクエスト
end

-------------------------------------------
-- ■ OutsideAreaEffectEnable
-- ミッション圏外エフェクト有効
this.OutsideAreaEffectEnable = function()

	Fox.Log( "---- GZCommon:OutsideAreaEffectEnable ----")

	-- e20040ではミッション圏外警告を出さない
	if ( TppMission.GetMissionID() ~= 20040 ) then
		-- ミッションによってはミッション圏外を越えてクリア、もあるのでフラグチェック
		if( this.isOutOfMissionEffectEnable == true ) then
			TppOutOfMissionRangeEffect.Enable( 2.0 )

			-- ミッション圏外iDoroid音声再生開始（演出上タイミングをずらす）
			TppTimer.Start( "Timer_OutSideAreaVoiceStart", 1 )

			-- 2013.11.23 ファイルクローズ後につき限定対応	by sahara
			-- e20020以外のミッションの場合のみ、アナウンスログ表示（e20020は独自に行っている）
			if ( TppMission.GetMissionID() ~= 20020 ) then
				-- ミッション圏外警告アナウンスログ
				local hudCommonData = HudCommonDataManager.GetInstance()
				hudCommonData:AnnounceLogViewLangId( "announce_mission_area_warning" )
				TppSoundDaemon.PostEvent( "sfx_s_terminal_data_fix" )	-- 端末情報更新アリ、の音
			end
		end
	end
end
-------------------------------------------
-- ■ OutsideAreaEffectDisable
-- ミッション圏外エフェクト無効
this.OutsideAreaEffectDisable = function()

	Fox.Log( "---- GZCommon:OutsideAreaEffectDisable ----" )

	TppOutOfMissionRangeEffect.Disable( 1.0 )

	this.OutsideAreaVoiceEnd()		-- ミッション圏外iDoroid音声再生停止

end

-------------------------------------------
-- ■ OutsideAreaCamera
-- ミッション圏外終了時演出処理
this.OutsideAreaCamera = function()

	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()
	this.PlayerOnVehicle = TppPlayerUtility.GetRidingVehicleCharacterId()

	Fox.Log( "---- GZCommon:OutsideAreaCamera ----"..VehicleId )

	-- プレイヤーが車両に乗っているかで演出が変わる
	if ( VehicleId ~= "" ) then		-- 空文字列であれば「乗っていない」と判定
		-- 保険処理として万が一「ヘリ」に乗っていた場合は除外。ここで止めるのは演出のみ。（ミッション終了処理自体は別で進んでいる）
		if ( VehicleId == "SupportHelicopter" ) then
			Fox.Error("GZCommon:OutsideAreaCamera:::Player_On_Helicopter!!!")
		else
			-- いずれかの車両に乗っている
			this.OutsideAreaCamera_Vehicle( VehicleId, "Player" )	-- 搭乗中の車両CharaIDが入っているのでそのまま渡す
		end
	else
		if ( this.PlayerOnCargo ~= "NoRide" ) then
			-- 荷台に乗っている
			this.OutsideAreaCamera_Vehicle( this.PlayerOnCargo, "Player" )	-- 搭乗中の車両CharaIDが入っているのでそのまま渡す
		else
			-- 車両に乗っていない
			this.OutsideAreaCamera_Human( "Player" )
		end

	end
end
-------------------------------------------
-- ■ OutsideAreaCamera_Vehicle
-- 車両によるミッション圏外終了時演出処理
this.OutsideAreaCamera_Vehicle = function( VehicleId, CharaId, options )
	Fox.Log( "---------- GZCommon:OutsideAreaCamera_Vehicle -------" )
	local Pos
	local Angle
	local VehicleType
	local charaId = CharaId or nil

	-- 場所指定あり
	if ( options ) then
		-- 指定場所によって渡す座標を変える
		if ( options == "North" ) then
			Pos =	this.VehicleWarpPos_OutsideAreaNorth
			Angle =	this.VehicleWarpAngle_OutsideAreaNorth
		elseif ( options == "West" ) then
			Pos =	this.VehicleWarpPos_OutsideAreaWest
			Angle =	this.VehicleWarpAngle_OutsideAreaWest
		else
			--error
			Fox.Warning( "GZCommon.OutsideAreaCamera_Vehicle Cannot execute! " .. options  )
		end
	-- 場所指定なし
	else
		-- プレイヤーの現在の所属エリアから判断して渡す座標を変える
		if ( this.PlayerAreaName == "Heliport" ) then
			Pos =	this.VehicleWarpPos_OutsideAreaNorth
			Angle =	this.VehicleWarpAngle_OutsideAreaNorth
		elseif ( this.PlayerAreaName == "WestCamp" ) then
			Pos =	this.VehicleWarpPos_OutsideAreaWest
			Angle =	this.VehicleWarpAngle_OutsideAreaWest
		else
			--error
			Fox.Warning( "GZCommon.OutsideAreaCamera_Vehicle Cannot execute! PlayerArea is irregularity:" .. this.PlayerAreaName )
		end
	end
	-- ミッション圏外付近にいるNPCと車両を表示ＯＦＦする
	this.OutsideAreaGameRealizeCharacter( VehicleId, options )
	-- ミッション圏外エフェクトの停止
	this.OutsideAreaEffectDisable()
	-- 圏外エフェクトの有無を見て「クリア」か「失敗」かを判断する
	if ( this.isOutOfMissionEffectEnable == true ) then
		-- 失敗時ジングル
		TppMusicManager.PostJingleEvent( "SingleShot", "Play_bgm_gntn_jingle_area_failed" )
	else
		-- クリア時ジングル
		TppMusicManager.PostJingleEvent( "SingleShot", "Play_bgm_gntn_jingle_area_clear" )
	end
	-- 車両タイプ取得
	VehicleType = TppVehicleUtility.GetVehicleType( VehicleId )
	Fox.Log( "---------- GZCommon.OutsideAreaCamera_Vehicle VehicleType: ----------" .. VehicleType )
	if ( charaId == "Player" ) then
		-- 車両の強制移動
		this.ForceMove_Vehicle( VehicleId, Pos, Angle )
	end
	-- カメラ演出発動
	-- ビークル
	if( VehicleType == 2 ) then
		this.PlayCameraOnCommonCharacterOutsideArea( charaId, this.OutsideAreaCamOffSetPos_LightVehicle )
	-- トラック
	elseif( VehicleType == 3 ) then
		this.PlayCameraOnCommonCharacterOutsideArea( charaId, this.OutsideAreaCamOffSetPos_Truck )
	-- 機銃装甲車
	elseif( VehicleType == 5 ) then
		this.PlayCameraOnCommonCharacterOutsideArea( charaId, this.OutsideAreaCamOffSetPos_MgWav )
	else
		--error
		Fox.Warning( "GZCommon.OutsideAreaCamera_Vehicle Cannot execute! No VehicleType:" .. VehicleType )
	end

	-- プレイヤーが西側検問を抜けた場合の保険処理
	if ( this.PlayerAreaName == "WestCamp" ) then
		-- 衝突してしまう事があるので通路の突き当たりで再度強制移動させる
		TppTimer.Start( "Timer_OutSideAreaWestVehicleTurn", 4.5 )
	end
end

-- ■ ForceMove_Vehicle
-- 車両の強制移動
this.ForceMove_Vehicle = function( VehicleId, Pos, Angle )

	Fox.Log("*** GZCommon.ForceMove_Vehicle *** VehicleId = " .. VehicleId )

	-- 車両のCharacterを取得
	local vehicleObject = Ch.FindCharacterObjectByCharacterId( VehicleId )
	local vehicleCharacter = vehicleObject:GetCharacter()

	-- 車両のPluginを取得
	local plgBasicAction = vehicleCharacter:FindPluginByName( "TppStrykerBasicAction" )

	-- 車両をワープさせる
	plgBasicAction:WarpToPosition( Vector3( Pos ), Angle )

	-- 速度を設定
	plgBasicAction:QuickAccelerate( this.VehicleSpeed_OutsideArea, Angle )

	-- 操作の設定
	vehicleObject:SetDrivingInput( 0.0, 1.0, 0.0 ) -- ハンドルの角度が0（直進）、アクセル全開、ブレーキは踏んでいない状態

end

-------------------------------------------
-- ■ OutsideAreaCamera_Human
-- 徒歩によるミッション圏外終了時演出処理
this.OutsideAreaCamera_Human = function( CharacterId, options )

	Fox.Log( "---------- GZCommon:OutsideAreaCamera_Human -------" )

	local Pos

	if( CharacterId == "Player" ) then
		-- プレイヤーの現在の所属エリアから判断して渡す座標を変える
		if ( this.PlayerAreaName == "Heliport" ) then
			Pos = this.PlayerMovePos_OutsideAreaNorth
		elseif ( this.PlayerAreaName == "WestCamp" ) then
			Pos = this.PlayerMovePos_OutsideAreaWest
		else
			--error
			Fox.Warning( "GZCommon.OutsideAreaCamera_Vehicle Cannot execute! PlayerArea is irregularity:" .. this.PlayerAreaName )
		end
	end

	-- ミッション圏外付近にいるNPCをデモ中でもリアライズ
	this.OutsideAreaGameRealizeCharacter( "NoVehicle", 0 )

	-- ミッション圏外エフェクトの停止
	this.OutsideAreaEffectDisable()

	-- 圏外エフェクトの有無を見て「クリア」か「失敗」かを判断する
	if ( this.isOutOfMissionEffectEnable == true ) then
		-- 失敗時ジングル
		TppMusicManager.PostJingleEvent( "SingleShot", "Play_bgm_gntn_jingle_area_failed" )

	else
		-- クリア時ジングル
		TppMusicManager.PostJingleEvent( "SingleShot", "Play_bgm_gntn_jingle_area_clear" )
	end

	if( CharacterId == "Player" ) then
		-- プレイヤー強制移動
		TppPlayerUtility.RequestToStartTransition{ stance="Stand", position=Pos, direction=0, doKeep=true, run=true }
	else
		-- プレイヤー強制停止
	end

	-- カメラ演出発動
	this.PlayCameraOnCommonCharacterOutsideArea( CharacterId, this.OutsideAreaCamOffSetPos_Human )

end

-------------------------------------------
-- ■ OutsideAreaGameRealizeCharacter
-- ミッション圏外エリアのNPCをアンリアライズする
this.OutsideAreaGameRealizeCharacter = function( VehicleID, options )
	Fox.Log( "---------- GZCommon:OutsideAreaGameRealizeCharacter -------"..VehicleID )
	local pos			= Vector3( 0, 0, 0 )					-- BOX位置
	local size			= Vector3( 0, 0, 0 )					-- BOXサイズ
	local rot			= Quat( 0.0, 0.0, 0.0, 0.0 )			-- BOX回転
	local npcIds		= 0
	local vehicleIds	= 0
	local characterID
	local status
	local npctype
	-- 場所指定あり
	if ( options ) then
		-- 指定場所によって渡す座標を設定
		if( options == "North" ) then
			pos		= Vector3( 40, 30, 36 )
			size	= Vector3( 33, 14, 130 )
			rot		= Quat( 0.0, -0.3, 0.0, 0.8 )
		elseif( options == "West" ) then
			pos		= Vector3( -290, 30, 180 )
			size	= Vector3( 33, 14, 130 )
			rot		= Quat( 0.0, 0.4, 0.0, 0.8 )
		else
			return
		end
	-- 場所指定なし
	else
		-- プレイヤーの現在の所属エリアから判断して渡す座標を変える
		if( this.PlayerAreaName == "Heliport" ) then
			pos		= Vector3( 40, 30, 36 )
			size	= Vector3( 33, 14, 130 )
			rot		= Quat( 0.0, -0.3, 0.0, 0.8 )
		elseif( this.PlayerAreaName == "WestCamp" ) then
			pos		= Vector3( -290, 30, 180 )
			size	= Vector3( 33, 14, 130 )
			rot		= Quat( 0.0, 0.4, 0.0, 0.8 )
		else
			return
		end
	end

	-- 指定BOX内にいるNPCを取得
	npcIds = TppNpcUtility.GetNpcByBoxShape( pos, size, rot )

	-- 指定BOX何にいる敵兵を全てアンリアライズする
	if( npcIds and #npcIds.array > 0 ) then
		for i,id in ipairs( npcIds.array ) do
			npctype = TppNpcUtility.GetNpcType( id )
			Fox.Log( "GZCommon:OutsideAreaGameRealizeCharacter EnemyNpctype : "..npctype )
			if( npctype == "Enemy" ) then
				status = TppEnemyUtility.GetStatus( id )
				Fox.Log( "GZCommon:OutsideAreaGameRealizeCharacter EnemyStatus : "..status )
				if( status ~= "RideVehicle" and status ~= "Carried" ) then
					characterID = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
					Fox.Log( "GZCommon:OutsideAreaGameRealizeCharacter Disable EnemyID : "..characterID )
					TppEnemyUtility.SetEnableCharacterId( characterID, false )
				end
			elseif( npctype == "Hostage" ) then
				status = TppHostageUtility.GetStatus( id )
				if( status ~= "RideOnVehicle" and status ~= "Carried" ) then
					characterID = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
					Fox.Log( "GZCommon:OutsideAreaGameRealizeCharacter Disable HostageID : "..characterID )
					TppEnemyUtility.SetEnableCharacterId( characterID, false )
				end
			end
		end
	end

	-- 指定BOX内にいる車両を取得
	vehicleIds = TppVehicleUtility.GetVehicleByBoxShape( pos, size, rot )

	-- 指定BOX何にいる敵兵を全てリアライズする
	if( vehicleIds and #vehicleIds.array > 0 ) then
		for i,id in ipairs( vehicleIds.array ) do
			characterID = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
			Fox.Log( "GZCommon:OutsideAreaGameRealizeCharacter VehicleID"..characterID )
			if( characterID ~= VehicleID ) then
				-- 車両表示ＯＦＦ
				Fox.Log( "GZCommon:OutsideAreaGameRealizeCharacter Disable VehicleID"..characterID )
				TppData.Disable( characterID )
			end
		end
	end
end

---------------------------------------------------------------------------------
-- ■■ Player Function
-------------------------------------------
-- ■ PlayerRideOnVehicle
-- プレイヤーが車両に乗った
this.PlayerRideOnVehicle = function()

	local Type = TppData.GetArgument(2)

	-- 搭乗中の車両のCharaIdを保持
	this.PlayerOnVehicle = TppData.GetArgument(1)
	Fox.Log("------- PlayerRideOnVehicle ------:::"..this.PlayerOnVehicle)

end
-- ■ PlayerGetOffVehicle
-- プレイヤーが車両から降りた
this.PlayerGetOffVehicle = function()

	this.PlayerOnVehicle = "NoRide"
	Fox.Log("------- PlayerGetOffVehicle ------:::"..this.PlayerOnVehicle)

end
-------------------------------------------
-- ■ PlayerRideOnCargo
-- プレイヤーが荷台に乗った
this.PlayerRideOnCargo = function()

	local Type = TppData.GetArgument(2)

	if ( Type == "Truck" ) then
		-- 搭乗中の車両のCharaIdを保持
		this.PlayerOnCargo = TppData.GetArgument(1)
		Fox.Log("------- PlayerRideOnCargo ------:::"..this.PlayerOnCargo)
	end
end
-- ■ PlayerGetOffCargo
-- プレイヤーが荷台から降りた
this.PlayerGetOffCargo = function()

	this.PlayerOnCargo = "NoRide"
	Fox.Log("------- PlayerGetOffCargo ------:::"..this.PlayerOnCargo)

end
---------------------------------------------------------------------------------
-- ■■ Support Heli Function
-------------------------------------------
-- ■ SupporHeliLandingZone
-- ヘリがＲＶに到着
this.SupporHeliLandingZone = function()
	Fox.Log("------- GZCommon:SupporHeliLandingZone ------")
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:AnnounceLogViewLangId( "announce_heli_arrive_LZ" )
end
-- ■ OnStartMotherBaseDevise
-- マザベ端末からコールされた時に呼ばれる処理
this.OnStartMotherBaseDevise = function()
	local arg1 = TppData.GetArgument(1)
	Fox.Log("***** GZCommon.OnStartMotherBaseDevise *****")
	TppSupportHelicopterService.CallSupportHelicopter(arg1)

end
-- ■ OnStartWarningFlare
-- 発煙筒が使用された時に呼ばれる処理
this.OnStartWarningFlare = function()

	Fox.Log("***** GZCommon.OnStartWarningFlare *****")

	local arg1 = TppData.GetArgument(1)
	local arg2 = TppData.GetArgument(2)

	-- arg2にfalseが来たら地下判定なので呼ばない
	if ( arg2 ) then
		-- ヘリを呼ぶ
		TppSupportHelicopterService.CallSupportHelicopter(arg1)
		TppSupportHelicopterService.RequestAirStrike()
	end
end
-- ■ SupporHeliCloseDoor
-- 離陸したヘリのドアが閉まった
this.SupporHeliCloseDoor = function()
	Fox.Log("***** GZCommon.SupporHeliCloseDoor *****")
	local isPlayer = TppData.GetArgument(2)

	if ( isPlayer ) then
		-- 保険処理としてここでもCP無線を全停止
		TppEnemyUtility.StopAllCpRadio( 1.0 )	-- フェード時間

		-- 脱出BGMを停止
		this.StopHeliEscapeBGM()

		-- ミュージックプレイヤーフェード終了
		TppMusicManager.StopMusicPlayer( 3000 )
	end
end

-- ■ SupporHeliDeparture
-- ヘリが離陸した
this.SupporHeliDeparture = function()

	local isPlayer = TppData.GetArgument(3)

	if ( isPlayer ) then
		Fox.Log("***** GZCommon.SupporHeliDeparture *****")
		-- CP無線フェードアウトタイマースタート
		TppTimer.Start( "Timer_CpRadioFadeStart", this.Time_CpRadioFadeOutStart )

		-- プレイヤーのヘリ離脱中判定フラグを立てる
		this.PlayerEscapeOnHeli = true

		-- この時点で既に敵が対空行動に入っていたら脱出BGMコール
		if ( this.EnemyAntiAirActCheck == true ) then
			this.CallHeliEscapeBGM()
		end
	end
end

---------------------------------------------------------------------------------
-- ■■ Enemy Function
-------------------------------------------
-- ■ EnemyInterrogation
-- 敵兵が尋問された
this.EnemyInterrogation = function()
	Fox.Log("------- GZCommon:EnemyInterrogation ------")
	-- 尋問効果を取得
	-- 0:効果なし 1:周囲の敵をマーク 2:登録キャラをマーク
	local Type = TppData.GetArgument(3)
	-- 登録キャラマーキングの場合はMAP更新アナウンスログとSEを鳴らす
	if ( Type == 2 or Type == 1 ) then
		-- アナウンスログ表示
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:AnnounceLogViewLangId( "announce_map_update" )
		-- 端末情報更新アリ、の音
		TppSoundDaemon.PostEvent( "sfx_s_terminal_data_fix" )
	end
end

-- ■ EnemyLaidonHeliNoAnnounceSet
-- 敵兵をヘリで回収した時にアナウンスログを流さないCharacterID設定
this.EnemyLaidonHeliNoAnnounceSet = function( CharacterID )
	Fox.Log("------- GZCommon:EnemyLaidonHeliNoAnnounceSet ------")
	this.UniqueCharacterId_AnnounceLog[ #(this.UniqueCharacterId_AnnounceLog) + 1 ] = CharacterID
end

-- ■ CheckEnemyLaidonHeliNoAnnounce
-- CharacterIDが同じのか検索
this.CheckEnemyLaidonHeliNoAnnounce = function( CharacterID )
	Fox.Log("------- GZCommon:CheckEnemyLaidonHeliNoAnnounce ------")
	for i, value in pairs( this.UniqueCharacterId_AnnounceLog ) do
		if( value == CharacterID ) then
			return true
		end
	end
	return false
end

-- ■ EnemyLaidonVehicle
-- 敵兵をヘリで回収した
this.EnemyLaidonVehicle = function()
	Fox.Log("------- GZCommon:EnemyLaidonVehicle ------")
	local EnemyCharacterID		= TppData.GetArgument(1)
	local VehicleCharacterID	= TppData.GetArgument(3)
	local EnemyLife				= TppEnemyUtility.GetLifeStatus( EnemyCharacterID )
	if ( EnemyLife ~= "Dead" ) then
		-- 支援ヘリのみ
		if( VehicleCharacterID == "SupportHelicopter" ) then
			-- ユニークキャラチェック
			if( this.CheckEnemyLaidonHeliNoAnnounce( EnemyCharacterID ) == false ) then
				-- アナウンスログ「敵をヘリに乗せた」
				local hudCommonData = HudCommonDataManager.GetInstance()
				hudCommonData:AnnounceLogViewLangId( "announce_collection_enemy" )
				-- 戦績に反映
				PlayRecord.RegistPlayRecord( "SOLDIER_RESCUE" )
			end
		end
	end
end

-- ■ CpRadioFadeOut
-- CP無線のフェードアウト停止
this.CpRadioFadeOut = function( CharacterID )
	Fox.Log("------- GZCommon:CpRadioFadeOut ------")
	-- CP無線をフェードアウトしつつ全停止
	TppEnemyUtility.StopAllCpRadio( this.Time_CpRadioFadeOut )	-- フェード時間
	-- CP無線新規コール停止タイマースタート
	TppTimer.Start( "Timer_CpRadioFadeOutEnd", this.Time_CpRadioFadeOut )
end
-------------------------------------------
-- ■ ChangeAntiAir
-- 敵兵の対空行動開始/終了
this.ChangeAntiAir = function()

	Fox.Log("***** GZCommon:ChangeAntiAir *****")

	local Flag		= TppData.GetArgument(2)

	if ( Flag == true) then
		-- 対空行動判定フラグ更新：開始
		this.EnemyAntiAirActCheck = true

		-- この時点で既にヘリ離脱中であれば脱出BGMコール
		if ( this.PlayerEscapeOnHeli == true ) then
			this.CallHeliEscapeBGM()
		end
	elseif ( Flag == false ) then
		-- 対空行動判定フラグ更新：終了
		this.EnemyAntiAirActCheck = false
	else
		Fox.Warning("**** GZCommon:ChangeAntiAir irregul FLAG!! ****")
	end
end

---------------------------------------------------------------------------------
-- ■■ Hostage Function
-------------------------------------------

-- ■ NormalHostageRecovery
-- 捕虜を回収した（アナウンスログ表示、戦績反映）
this.NormalHostageRecovery = function( HostageCharacterID )
	Fox.Log("------- GZCommon:NormalHostageRecovery ------")
	-- 捕虜の状態を取得
	local HostageStatus = TppHostageUtility.GetStatus( HostageCharacterID )
	-- 死んでいない
	if ( HostageStatus ~= "Dead" ) then
		-- アナウンスログ表示
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:AnnounceLogViewLangId( "announce_collection_hostage" )
		-- 戦績に反映
		PlayRecord.RegistPlayRecord( "HOSTAGE_RESCUE", HostageCharacterID )
	end
end

-- ■ CallMonologueHostage
-- 捕虜の担ぎ台詞コール
this.CallMonologueHostage = function( CharacterID, HostageVoiceType, DataIdentifierName, OffTrapName )
	Fox.Log("------- GZCommon:CallMonologueHostage ------")
	local VoiceID
	--脱走捕虜を担いでいたら
	if( TppPlayerUtility.IsCarriedCharacter( CharacterID )) then
		local obj = Ch.FindCharacterObjectByCharacterId( CharacterID )
		if not Entity.IsNull(obj) then
			-- 捕虜のボイスタイプからしゃべられるデータ名を取得
			if( HostageVoiceType == "hostage_a" ) then
				VoiceID = "POW_CD_0010"
			elseif( HostageVoiceType == "hostage_b" ) then
				VoiceID = "POW_CD_0020"
			elseif( HostageVoiceType == "hostage_c" ) then
				VoiceID = "POW_CD_0030_01"
			elseif( HostageVoiceType == "hostage_d" ) then
				VoiceID = "POW_CD_0040"
			else
				Fox.Log("------- GZCommon:CallMonologueHostage Not HostageVoiceType ------")
				return
			end
			TppEnemyUtility.CallCharacterMonologue( VoiceID , 3, obj, true )
			TppDataUtility.SetEnableDataFromIdentifier( DataIdentifierName, OffTrapName, false, false )
		end
	end
end

---------------------------------------------------------------------------------
-- ■■ Area Function
-------------------------------------------
-- ■ onEnterPlayerAreaTrap
-- プレイヤーの所属エリアを更新
local onEnterPlayerAreaTrap = function()
	local trapName = TppEventSequenceManagerCollector.GetMessageArg( 3 )

	-- エリアトラップは(/Assets/tpp/level/location/gntn/block_mission/gntn_common_mission_trap.fox2)に格納
	-- エリア名：
	-- 「Asylum」「ControlTower_East」「ControlTower_West」「EastCamp」「Heliport」「SeaSide」「WareHouse」「WestCamp」

	this.PlayerAreaName = trapName	-- トラップ名がそのまま現在のエリア名になる

	Fox.Log( "---------- GZCommon:onEnterPlayerAreaTrap Update"..this.PlayerAreaName )
end
-- 旧収容施設の穴あきフェンスを通った（ＳＥを鳴らす
local Fence_SE = function()
	local position = Vector3( 81.01846 , 17.24862 , 225.3844 )
	TppSoundDaemon.PostEvent3D( 'Play_sfx_P_Fs_FENCA_Rn_Grd_L', position )
end
-------------------------------------------
-- ■ Common_CenterBigGate_Open
-- 管理棟巨大ゲート開錠
this.Common_CenterBigGate_Open = function()
	Fox.Log( "---------- GZCommon:Common_CenterBigGate_Open -------" )

	local gateObj = Ch.FindCharacterObjectByCharacterId( "gntn_BigGate" )
	local gateChara = gateObj:GetCharacter()

	gateChara:SendMessage( TppGadgetStartActionRequest() )

	-- 敵兵が開けるときもあるのでここでもONにしておく
	TppGadgetUtility.SetSwitch("gntn_BigGateSwitch", true)

	TppGadgetUtility.SetSwitch("gntn_BigGateSwitch","lock")

	-- 管理棟巨大ゲート開錠フラグ
	this.BigGateOpenFlag = true
end
-------------------------------------------
-- ■ Common_CenterBigGate_Close
-- 管理棟巨大ゲート封鎖
this.Common_CenterBigGate_Close = function()
	Fox.Log( "---------- GZCommon:Common_CenterBigGate_Close -------" )

	local gateObj = Ch.FindCharacterObjectByCharacterId( "gntn_BigGate" )
	local gateChara = gateObj:GetCharacter()

	gateChara:SendMessage( TppGadgetUnsetOwnerRequest() )
	gateChara:SendMessage( TppGadgetEndActionRequest() )

	TppGadgetUtility.SetSwitch("gntn_BigGateSwitch","unlock")

	-- ドアが開けられるときはスイッチもOFFにする
	TppGadgetUtility.SetSwitch("gntn_BigGateSwitch", false)

	-- 管理棟巨大ゲート封鎖フラグ
	this.BigGateOpenFlag = false
end

-- 管理棟巨大ゲート車両移動初期化
this.Common_CenterBigGateVehicleInit = function( )
	Fox.Log( "---------- GZCommon:Common_CenterBigGateVehicleInit -------" )
	this.BigGateVehicleData["Init"]						= false
	this.BigGateVehicleData["Cpid"]						= 0
	this.BigGateVehicleData["VehicleRouteInfoName"]		= 0
	this.BigGateVehicleData["VehicleID"]				= 0
	this.BigGateVehicleData["VehicleRouteName01"]		= 0
	this.BigGateVehicleData["VehicleRouteName02"]		= 0
	this.BigGateVehicleData["VehicleRouteNodeIndex01"]	= 0
	this.BigGateVehicleData["VehicleRouteNodeIndex02"]	= 0
end

-- ■ Common_CenterBigGateVehicleSetup
-- 管理棟巨大ゲート車両移動セットアップ
this.Common_CenterBigGateVehicleSetup = function( CpId, VehicleRouteInfoName, VehicleRouteName01, VehicleRouteName02, VehicleRouteNodeIndex01, VehicleRouteNodeIndex02 )
	Fox.Log( "---------- GZCommon:Common_CenterBigGateVehicleSetup -------" )
	this.BigGateVehicleData["Init"]						= true							--
	this.BigGateVehicleData["Cpid"]						= CpId							--
	this.BigGateVehicleData["VehicleRouteInfoName"]		= VehicleRouteInfoName			--
	this.BigGateVehicleData["VehicleID"]				= 0								-- ビークルＩＤ
	this.BigGateVehicleData["VehicleRouteName01"]		= VehicleRouteName01			-- 開錠前のルートName
	this.BigGateVehicleData["VehicleRouteName02"]		= VehicleRouteName02			-- 開錠後ルートName
	this.BigGateVehicleData["VehicleRouteNodeIndex01"]	= VehicleRouteNodeIndex01		-- 巨大ゲートを開錠するルートノード番号
	this.BigGateVehicleData["VehicleRouteNodeIndex02"]	= VehicleRouteNodeIndex02		-- 巨大ゲートを封鎖するルートノード番号
end

-- ■ Common_CenterBigGateVehicle
-- 管理棟巨大ゲート車両移動
this.Common_CenterBigGateVehicle = function()

	local	phasename			= TppCharacterUtility.GetCurrentPhaseName()
	local	VehicleGroupInfo	= TppData.GetArgument(2)

	-- メッセージから呼ばれた場合はVehicleGroupInfoを保存しておき、
	-- それ以外から呼ばれた場合は保存していたものを使う（到着ではなくゲートオープンデモ中に呼びたい為）
	-- ただし、保存したタイミングと使うタイミングが離れていた場合に情報が古くなるので注意が必要。
	-- [!] 参照するパラメータを増やした場合は保存ワークも増やす事。
	if not Entity.IsNull(VehicleGroupInfo.memberCharacterIds) then
		this.LastVehicleGroupInfo_routeInfoName 	 = VehicleGroupInfo.routeInfoName
		this.LastVehicleGroupInfo_vehicleRouteId	 = VehicleGroupInfo.vehicleRouteId
		this.LastVehicleGroupInfo_passedNodeIndex	 = VehicleGroupInfo.passedNodeIndex
		this.LastVehicleGroupInfo_memberCharacterIds = VehicleGroupInfo.memberCharacterIds
		this.LastVehicleGroupInfo_vehicleCharacterId = VehicleGroupInfo.vehicleCharacterId
		Fox.Log( "---------- GZCommon:Common_CenterBigGateVehicle ---Node::"..tostring(VehicleGroupInfo.passedNodeIndex) )
	else
		Fox.Log( "---------- GZCommon:Common_CenterBigGateVehicle ---NotMessageCall / Node::"..tostring(this.LastVehicleGroupInfo_passedNodeIndex) )
	end

	-- 管理棟巨大ゲート車両移動設定済みならば
	if( this.BigGateVehicleData["Init"] == true ) then
		-- 管理棟巨大ゲート開錠前
		if( this.LastVehicleGroupInfo_routeInfoName	== this.BigGateVehicleData["VehicleRouteInfoName"] ) then
			-- 開錠リクエストを持つルートかどうかの照合
			if( this.LastVehicleGroupInfo_vehicleRouteId == GsRoute.GetRouteId( this.BigGateVehicleData["VehicleRouteName01"] ) ) then
				-- 開錠リクエストノードの照合
				if( this.LastVehicleGroupInfo_passedNodeIndex == this.BigGateVehicleData["VehicleRouteNodeIndex01"] ) then
					-- 管理棟巨大ゲートが閉まっている
					if( this.BigGateOpenFlag == false ) then
						-- Sneak
						if( phasename == "Sneak" ) then
							-- 敵兵とCPに無線連絡させる
							TppEnemyUtility.CallRadioFromEnemyToCp( this.BigGateCallRadioName, 1, this.LastVehicleGroupInfo_memberCharacterIds[1], this.BigGateVehicleData["Cpid"] )
							-- ビークルＩＤ設定
							this.BigGateVehicleData["VehicleID"] = this.LastVehicleGroupInfo_vehicleCharacterId
						-- Sneak以外
						else
							-- 管理棟巨大ゲート開錠
							this.Common_CenterBigGate_Open()
							-- ビークルＩＤ設定
							this.BigGateVehicleData["VehicleID"] = this.LastVehicleGroupInfo_vehicleCharacterId
							-- 管理棟巨大ゲート開錠タイマースタート
--							TppTimer.Start( "Timer_CenterBigGateOpen", this.BigGateOpenTimer )
						end
					-- 管理棟巨大ゲートが開いている
					else
						-- ビークルＩＤ設定
						this.BigGateVehicleData["VehicleID"] = this.LastVehicleGroupInfo_vehicleCharacterId
						-- 管理棟巨大ゲート開錠タイマースタート
--						TppTimer.Start( "Timer_CenterBigGateOpen", this.BigGateOpenToRouteTimer )
						-- 巨大ゲートが開錠完了済みなのでルートチェンジを行う。
						this.Common_CenterBigGate_OpenTime()
					end
				end
			-- 管理棟巨大ゲート開錠後
			-- 閉鎖リクエストを持つルートかどうかの照合
			elseif( this.LastVehicleGroupInfo_vehicleRouteId == GsRoute.GetRouteId( this.BigGateVehicleData["VehicleRouteName02"] ) ) then
				-- 文字列（"NotClose")だったらゲート封鎖する
				if( GsRoute.GetRouteId( this.BigGateVehicleData["VehicleRouteName02"] ) ~= "NotClose" ) then
					-- 閉鎖リクエストノードの照合
					if( this.LastVehicleGroupInfo_passedNodeIndex == this.BigGateVehicleData["VehicleRouteNodeIndex02"] ) then
						-- 管理棟巨大ゲート封鎖
						this.Common_CenterBigGate_Close()
						-- 管理棟巨大ゲート車両初期化
						this.Common_CenterBigGateVehicleInit()
					end
				end
			end
		end
	end
end

-- ■ Common_CenterBigGateVehicle
-- 管理棟巨大ゲートの無線終了タイミング
this.Common_CenterBigGateVehicleEndCPRadio = function()

	local RadioEnentName = TppData.GetArgument(1)

	Fox.Log( "---------- GZCommon:Common_CenterBigGateVehicleEndRadio ---RadioEnentName::"..RadioEnentName )

	-- 無線連絡終了後
	if( RadioEnentName == this.BigGateCallRadioName ) then
		-- 管理棟巨大ゲート開錠
		this.Common_CenterBigGate_Open()
		-- 管理棟巨大ゲート開錠タイマースタート
		-- TppTimer.Start( "Timer_CenterBigGateOpen", this.BigGateOpenTimer )
	end

end

-- ■ Common_CenterBigGate_OpenTime
-- 管理棟巨大ゲート開錠完了時間
this.Common_CenterBigGate_OpenTime = function()

	Fox.Log( "---------- GZCommon:Common_CenterBigGate_OpenTime -------" )

	-- 管理棟巨大ゲート車両移動設定済みならば
	if( this.BigGateVehicleData["Init"] == true ) then
		Fox.Log( "---------- GZCommon:Common_CenterBigGate_OpenTime -------1" )
		-- 車両ルートチェンジ
		TppCommandPostObject.GsSetGroupVehicleRoute( this.BigGateVehicleData["Cpid"], this.BigGateVehicleData["VehicleID"], this.BigGateVehicleData["VehicleRouteName02"], 0 )
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ■■ CameraFunction
-- ミッション終了時カメラ演出
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- チコ死亡時カメラ
this.Common_ChicoPazDead = function()

	local manager = TppEventSequenceManagerCollector.GetManagerBody()
	local message = TppEventSequenceManagerCollector.GetMessageStr()
	local characterID = TppEventSequenceManagerCollector.GetMessageArg(0)
	local DeadSituation = TppEventSequenceManagerCollector.GetMessageArg(1)
	Fox.Log("*** Received message Common_ChicoPazDead *** characterID = " .. tostring(characterID) .. ": DeadSituation = " .. tostring(DeadSituation) )

	-- 複数回呼ばれたときは先勝ちになるように変数が初期状態のときのみ代入
	if ( DeadSituation == 11 ) then
		this.ChicoPazDeadRideOnHelicopter = true
	end

	TppMission.ChangeState( "failed", characterID .. "Dead" )

end

this.PlayCameraAnimationOnChicoPazDead = function( characterId )
	Fox.Log("*** PlayCameraAnimationOnChicoPazDead *** characterId = " .. characterId .. ". DeadHelicopter = " .. tostring(this.ChicoPazDeadRideOnHelicopter) )

	if ( not this.ChicoPazDeadRideOnHelicopter ) then
		this.PlayCameraOnCommonCharacterGameOver(characterId, this.CamOffSetPos_Paz )
	end
end

-- ■ PlayCameraOnCommonCharacterGameOver
-- 汎用ゲームオーバー時カメラ演出
this.PlayCameraOnCommonCharacterGameOver = function( characterId, OffSetPos)
	Fox.Log("*** PlayCameraOnCommonCharacterGameOver *** characterId = "  .. characterId )

	local OffSetPos = OffSetPos or { 0, -0.5, -3.0 }

	TppHighSpeedCameraManager.RequestEvent{
		continueTime = 1.0,		-- ハイスピードカメラ継続時間
		worldTimeRate = 0.1,			-- 世界全体の速度倍率(1.0で等倍速)
		localPlayerTimeRate = timeRate,		-- プレイヤーの速度倍率(1.0で等倍速)
		timeRateInterpTimeAtStart = 0.0,	-- イベント開始時目標速度に達するまでの補完時間(秒)
		timeRateInterpTimeAtEnd = 0.3,		-- イベント終了時元の速度に戻るまでの補完時間(秒)
		cameraSetUpTime = 0.0				-- イベント開始時のカメラの準備時間(秒)※この間は時間が止まってカメラだけが動きます。
	}

	-- MTP_CAMERA_Aがうまく取れないので一端この形であげる
	-- プログラム再生
	TppPlayerUtility.RequestToPlayCameraNonAnimation{
		characterId = characterId, -- キャラクターID指定
		isFollowPos = false,
		isFollowRot = true,
		isCollisionCheck = false, --★あたりチェック無視 NonAnimationのみ有効
		isCameraAutoSelect = true, --★カメラの初期座標を対象の周りから選択（PLに一番近いものを優先）
		followTime = 10.0,
		followDelayTime = 0.1, --★最大0.5sまで　それ以上は正常動作を保障しません。60fなら0.5s, 30fなら1sまでいける
		useCharaPosRot = true,
		rotX = 30.0,
		rotY = 145.0,	 -- offsetPosからの角度
		candidateRotX = 30.0,
		candidateRotY = 45.0,
		offsetPos = Vector3( OffSetPos ),
		focalLength = 50.0,
		focusDistance = 3.0 ,
		aperture = 1.875,
		timeToSleep = 10.0 -- 寝るまでの時間
	}

	-- 失敗時ジングル
	TppMusicManager.PostJingleEvent( "SingleShot", "Play_bgm_gntn_jingle_area_failed" )

end
-- ■ PlayCameraOnCommonHelicopterGameOver
-- ヘリ撃墜ゲームオーバー時カメラ演出
this.PlayCameraOnCommonHelicopterGameOver = function( )
	Fox.Log("*** PlayCameraOnCommonHelicopterGameOver *** " )

	TppPlayerUtility.RequestToPlayCameraNonAnimation{
		characterId = "SupportHelicopter", -- キャラクターID指定
		isFollowPos = false,
		isFollowRot = true,
		followTime = 10.0,
		useCharaPosRot = true,
		rotX = 13.00,
		rotY = 145.0,	 -- offsetPosからの角度
		candidateRotX = 0.0,
		candidateRotY = 45.0,
		offsetPos = Vector3( -11.471, 3.0, 16.383),
		focalLength = 21.0,
		focusDistance = 3.0 ,
		aperture = 1.875,
		timeToSleep = 30.0 -- 寝るまでの時間
	}

	--print("set camera noise")
	local levelX = 0.5
	local levelY = 0.5
	local time = 5.0
	local decayRate = 0.08
	local randomSeed = 12345
	local enableCamera = { 3 }

	TppPlayerUtility.SetCameraNoise{
		levelX = levelX,
		levelY = levelY,
		time = time,
		decayRate = decayRate,
		randomSeed = randomSeed,
		enableCamera = enableCamera,
	}
end
-- ■ PlayCameraOnCommonCharacterOutsideArea
-- ミッション圏外離脱時のカメラ演出
this.PlayCameraOnCommonCharacterOutsideArea = function( characterId, OffSetPos)
	Fox.Log("*** PlayCameraOnCommonCharacterOutsideArea *** characterId = "  .. characterId )

	local OffSetPos = OffSetPos or { 0, -0.5, -3.0 }

	TppHighSpeedCameraManager.RequestEvent{
		continueTime = 1.0,		-- ハイスピードカメラ継続時間
		worldTimeRate = 0.1,			-- 世界全体の速度倍率(1.0で等倍速)
		localPlayerTimeRate = timeRate,		-- プレイヤーの速度倍率(1.0で等倍速)
		timeRateInterpTimeAtStart = 0.0,	-- イベント開始時目標速度に達するまでの補完時間(秒)
		timeRateInterpTimeAtEnd = 0.3,		-- イベント終了時元の速度に戻るまでの補完時間(秒)
		cameraSetUpTime = 0.0				-- イベント開始時のカメラの準備時間(秒)※この間は時間が止まってカメラだけが動きます。
	}

	-- MTP_CAMERA_Aがうまく取れないので一端この形であげる
	-- プログラム再生
	TppPlayerUtility.RequestToPlayCameraNonAnimation{
		characterId = characterId,			-- キャラクターID指定
		isFollowPos = false,				-- 位置だけ追従（角度変化なし）
		isFollowRot = true,					-- 角度だけ追従（位置変化無し）
		isCollisionCheck = false,			--★あたりチェック無視 NonAnimationのみ有効
		isCameraAutoSelect = true,			--★カメラの初期座標を対象の周りから選択（PLに一番近いものを優先）
		followTime = 10.0,					-- 追従時間（秒）
		followDelayTime = 0.05,				--★最大0.5sまで　それ以上は正常動作を保障しません。60fなら0.5s, 30fなら1sまでいける
		useCharaPosRot = true,				-- characterId指定の場合trueで設定
		rotX = 30.0,						-- offsetPosからのX軸の角度
		rotY = 145.0,						-- offsetPosからのY軸の角度
		candidateRotX = 30.0,				-- 4方向に対してコリジョンチェックするX軸の相対角度
		candidateRotY = 45.0,				-- 4方向に対してコリジョンチェックするY軸の相対角度
		offsetPos = Vector3( OffSetPos ),	-- 指定キャラクター位置からの相対位置（初期向きはキャラクターの向き）
		focalLength = 30.0,					-- カメラの設定
		focusDistance = 3.0 ,				-- カメラの設定
		aperture = 1.875,					-- カメラの設定
		timeToSleep = 10.0					-- CutInCameraが寝るまでの時間
	}

end

---------------------------------------------------------------------------------
-- ■■ SearchTarget Function
-------------------------------------------
-- ■ SearchTargetCharacterSetup
this.SearchTargetCharacterSetup = function( manager, CharacterID )
	Fox.Log("-------GZCommon.SearchTargetCharacterSetup------")
	-- ターゲットマーカー対象登録
	manager.CheckLookingTarget:AddSearchTargetEntity{				-- 登録処理
		mode 						= "CHARACTER",					-- 対象はCharacter
		name						= CharacterID,					-- 対象の名前(この名前がMessageの引数になる)
		targetName					= CharacterID,					-- 対象のcharacterId
		skeletonName				= "SKL_004_HEAD",				-- 注視関節名
		offset 						= Vector3(0,0.15,0),			-- 注視関節原点からのオフセット
		lookingTime					= 1.0,							-- 注目継続時間
		doWideCheck					= true,							-- 画面に映っている大きさのチェックをするときはtrue
		wideCheckRadius				= 0.15,							-- 画面に映っている大きさチェック用、対象の半径
		wideCheckRange				= 0.07,							-- 画面に映っている大きさチェック用、画面に対する割合
		doDirectionCheck			= true,							-- 向きチェックをするときはtrue
		directionCheckRange			= 125,							-- こっちを向いていると判定する角度
		doInMarkerCheckingMode		= true,							-- trueにすると、マーカーチェック有効中のみチェックする
		doCollisionCheck			= true,							-- アタリチェックするときはtrue
		doSendMessage				= true,							-- 条件成立時にmessageを送信するときはtrue。LookingTargetというmessageが送信される
		doNearestCheck				= false							-- trueにすると、登録されているものの内一番近いものだけが選ばれる
	}
end

-- ■ CallSearchTarget
this.CallSearchTarget = function()
	Fox.Log("-------GZCommon.CallSearchTarget------")
	-- ターゲットマーカー音設定
	TppSoundDaemon.PostEvent( "sfx_s_enemytag_main_tgt" )
end

---------------------------------------------------------------------------------
-- ■■ Register Function

--[[ テンプレリストデータ
this.ContinueHostageRegisterList = {
	CheckList01 = {
		Pos						= "CheckPos_01",				-- sequenceのEntityLinkしているLocator
		VehicleType				= "Vehicle",					-- 【Vehicle】or【Truck】or【Armored_Vehicle】
		HostageRegisterPoint	= { "NoData", "NoData", },		-- "id_vipRestorePoint"のDataIdentifier
	},
}
--]]

-------------------------------------------
-- ■ CheckContinueHostageRegister
-- コンティニュー時車両がある場所に捕虜がいる場合にワープさせる
this.CheckContinueHostageRegister = function( ContinueHostageRegisterList )
	local VehicleTypeBoxShapeSizeList = {
		Vehicle			= Vector3( 5.0, 5.0, 5.0 ),
		Truck			= Vector3( 4.0, 6.0, 8.0 ),
		Armored_Vehicle	= Vector3( 5.0, 7.0, 9.0 ),
	}
	Fox.Log( "CheckContinueHostageRegister" )
	local missionName	= TppMission.GetMissionName()
	local warpLocatorID = missionName .. "_warpHostageLocators"
	-- チェック回数回す
	for i, CheckList in pairs( ContinueHostageRegisterList ) do
		local dataBody	= TppData.GetData( CheckList.Pos )
		local pos		= dataBody:GetWorldTransform().translation
		local rot		= dataBody:GetWorldTransform().rotQuat
		local size
		-- BOXサイズ設定
		if( CheckList.VehicleType == "Vehicle" or CheckList.VehicleType == "Truck" or CheckList.VehicleType == "Armored_Vehicle" ) then
			size = VehicleTypeBoxShapeSizeList[ CheckList.VehicleType ]
		else
			size = nil
		end
		if( size ~= nil ) then
			local npcIds = TppNpcUtility.GetNpcByBoxShape( pos, size, rot )
			Fox.Log( "CommonContinueHostageRegister : Point :"..CheckList.Pos )
			-- BOX内にいる敵兵or捕虜を検索
			if( npcIds and #npcIds.array > 0 ) then
				Fox.Log( "CommonContinueHostageRegister : NpcNum :"..#npcIds.array )
				local count = 1
				for j, id in ipairs( npcIds.array ) do
					local npctype = TppNpcUtility.GetNpcType( id )
					local CharacterID = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
					Fox.Log( "CommonContinueHostageRegister : Npc Type :"..npctype )
					Fox.Log( "CommonContinueHostageRegister : CharacterID :"..CharacterID )
					-- 捕虜だったら
					if( npctype == "Hostage" ) then
						local registerpoint = CheckList.HostageRegisterPoint[ count ]
						if( registerpoint ~= nil ) then
							Fox.Log( "CommonContinueHostageRegister : Set Hostage RegisterPoint"..registerpoint )
							local CharacterID = TppCharacterUtility.GetCharacterIdFromUniqueId( id )
							TppCharacterUtility.WarpCharacterIdFromIdentifier( CharacterID, warpLocatorID, registerpoint )
							count = count + 1
						else
							Fox.Log( "CommonContinueHostageRegister : Please Hostage RegisterPoint" )
						end
					end
				end
			end
		end
	end
end

---------------------------------------------------------------------------------
-- ■■ Sound Function
-------------------------------------------
-- ■ CallAlertSirenCheck
this.CallAlertSirenCheck = function()

	Fox.Log("-------GZCommon.CallAlertSirenCheck------")

	local status = TppData.GetArgument(2)

	-- Alertに「なった」ならサイレンをコール
	if ( status == "Up" ) then
		Fox.Log("--------CallAlertSirenCheck--------"..status)
		this.CallAlertSiren()
	end

end

-- ■ StopAlertSirenCheck
this.StopAlertSirenCheck = function()

	Fox.Log("-------GZCommon.StopAlertSirenCheck------")

	local status = TppData.GetArgument(2)

	-- フェイズが「下がってきた」ならサイレンを停止
	-- Alertから直接Sneak等に落ちるケースもあるので各Phaseの切り替わり時に判定する必要がある
	if ( status == "Down" ) then
		Fox.Log("--------StopAlertSirenCheck--------"..status)
		this.StopSirenNormal()
	end

end
-------------------------------------------
-- ■ CallAlertSiren
this.CallAlertSiren = function()
	Fox.Log("-------GZCommon.CallAlertSiren------")

	local daemon = TppSoundDaemon.GetInstance()

	-- サイレン1再生開始
	daemon:RegisterSourceEvent{
			sourceName = "SoundSource_alertsiren",
			tag = "Loop",
			playEvent = "sfx_m_gntn_alert_siren_lp",
	}

	-- サイレン2再生開始
	daemon:RegisterSourceEvent{
			sourceName = "SoundSource_alertsiren2",
			tag = "Loop",
			playEvent = "sfx_m_gntn_alert_siren2_lp",
	}

end

-- ■ CallCautionSiren
this.CallCautionSiren = function()
	Fox.Log("-------GZCommon.CallCautionSiren------")

	local daemon = TppSoundDaemon.GetInstance()

	-- サイレン1再生開始
	daemon:RegisterSourceEvent{
			sourceName = "SoundSource_alertsiren",
			tag = "Loop",
			playEvent = "sfx_m_gntn_alert_siren_lp",
	}

	-- サイレン2再生開始
	daemon:RegisterSourceEvent{
			sourceName = "SoundSource_alertsiren2",
			tag = "Loop",
			playEvent = "sfx_m_gntn_alert_siren2_lp",
	}

	-- サイレン3再生開始
	daemon:RegisterSourceEvent{
			sourceName = "SoundSource_alertsiren3",
			tag = "Loop",
			playEvent = "sfx_m_gntn_alert_siren3_lp",
	}

end

-- ■ StopSirenNormal
this.StopSirenNormal = function()
	Fox.Log("-------GZCommon.StopSirenNormal------")

	local daemon = TppSoundDaemon.GetInstance()

	-- サイレン1停止開始
	daemon:UnregisterSourceEvent{
			sourceName = "SoundSource_alertsiren",
			tag = "Loop",
			playEvent = "sfx_m_gntn_alert_siren_lp",
			stopEvent = "Stop_sfx_m_gntn_alert_siren_lp",
	}

	-- サイレン2停止開始
	daemon:UnregisterSourceEvent{
			sourceName = "SoundSource_alertsiren2",
			tag = "Loop",
			playEvent = "sfx_m_gntn_alert_siren2_lp",
			stopEvent = "Stop_sfx_m_gntn_alert_siren2_lp",
	}

	-- サイレン3停止開始
	daemon:UnregisterSourceEvent{
			sourceName = "SoundSource_alertsiren3",
			tag = "Loop",
			playEvent = "sfx_m_gntn_alert_siren3_lp",
			stopEvent = "Stop_sfx_m_gntn_alert_siren3_lp",
	}

end

-- ■ StopSirenForcibly
this.StopSirenForcibly = function()
	Fox.Log("-------GZCommon.StopSirenForcibly------")

	local daemon = TppSoundDaemon.GetInstance()

	-- サイレン1即時停止
	daemon:UnregisterSourceEvent{
			sourceName = "SoundSource_alertsiren",
			tag = "Loop",
	}

	-- サイレン2即時停止
	daemon:UnregisterSourceEvent{
			sourceName = "SoundSource_alertsiren2",
			tag = "Loop",
	}

	-- サイレン3即時停止
	daemon:UnregisterSourceEvent{
			sourceName = "SoundSource_alertsiren3",
			tag = "Loop",
	}

end
-------------------------------------------
-- ■ CallHeliEscapeBGM
this.CallHeliEscapeBGM = function()
	Fox.Log("-------GZCommon:CallHeliEscapeBGM------")

	-- これらの処理はe20040,e20050,e20070では行わない
	if ( TppMission.GetMissionID() ~= 20040 and
		 TppMission.GetMissionID() ~= 20050 and
		 TppMission.GetMissionID() ~= 20070 ) then

		Fox.Log("-------GZCommon:CallHeliEscapeBGM:::CALL_START------")
		-- ヘリ脱出曲再生
		TppMusicManager.StartSceneMode()
		TppMusicManager.PlaySceneMusic( "Play_bgm_gntn_heli_leave" )

	end
end
-- ■ StopHeliEscapeBGM
this.StopHeliEscapeBGM = function()
	Fox.Log("-------GZCommon:StopHeliEscapeBGM------")

	-- これらの処理はe20040,e20050,e20070では行わない
	if ( TppMission.GetMissionID() ~= 20040 and
		 TppMission.GetMissionID() ~= 20050 and
		 TppMission.GetMissionID() ~= 20070 ) then

		Fox.Log("-------GZCommon:CallHeliEscapeBGM:::CALL_STOP------")
		-- ヘリ脱出曲停止
		TppMusicManager.PostSceneSwitchEvent( "Stop_bgm_gntn_heli_leave" )
		TppMusicManager.EndSceneMode()
	end

end

---------------------------------------------------------------------------------
-- ■■ Radio Function
-------------------------------------------
-- ■ commonEsrConClean
-- 諜報無線の有効/無効情報をクリアする
this.commonEsrConClean = function()
	Fox.Log("!!!!!EspionageRadioController is Clean!!!!!")
	EspionageRadioController.Clean()
end
---------------------------------------------------------------------------------
-- ■■ Messages
---------------------------------------------------------------------------------

this.Messages = {
	Trap = {
		-- Playerの現在位置管理
		{  data = "Asylum", 					message = "Enter", 						commonFunc = onEnterPlayerAreaTrap },
		{  data = "ControlTower_East",		 	message = "Enter", 						commonFunc = onEnterPlayerAreaTrap },
		{  data = "ControlTower_West",		 	message = "Enter", 						commonFunc = onEnterPlayerAreaTrap },
		{  data = "EastCamp", 					message = "Enter", 						commonFunc = onEnterPlayerAreaTrap },
		{  data = "Heliport", 					message = "Enter", 						commonFunc = onEnterPlayerAreaTrap },
		{  data = "SeaSide", 					message = "Enter", 						commonFunc = onEnterPlayerAreaTrap },
		{  data = "WareHouse", 					message = "Enter", 						commonFunc = onEnterPlayerAreaTrap },
		{  data = "WestCamp", 					message = "Enter",						commonFunc = onEnterPlayerAreaTrap },

		-- 管理棟エリアボイラー室の蒸気エフェクトOn/Off
		{  data = "trap_wtrdrpbil", 			message = "Enter", 						commonFunc = function() TppDataUtility.CreateEffectFromGroupId( "wtrdrpbil" ) end },
		{  data = "trap_wtrdrpbil", 			message = "Exit", 						commonFunc = function() TppDataUtility.DestroyEffectFromGroupId( "wtrdrpbil" ) end },
		-- 管理棟エリアボイラー室の埃エフェクトOn/Off
		{  data = "trap_dstcomviw", 			message = "Enter", 						commonFunc = function() TppDataUtility.CreateEffectFromGroupId( "dstcomviw" ) end },
		{  data = "trap_dstcomviw", 			message = "Exit", 						commonFunc = function() TppDataUtility.DestroyEffectFromGroupId( "dstcomviw" ) end },

		-- ミッション圏外警告エフェクト判定
		{ data = "Trap_WarningMissionArea",		message = "Enter", 						commonFunc = function()
																											this.OutsideAreaEffectEnable()
																											this.isPlayerWarningMissionArea = true
																									end },
		{ data = "Trap_WarningMissionArea",		message = "Exit",						commonFunc = function()
																											this.OutsideAreaEffectDisable()
																											this.isPlayerWarningMissionArea = false
																									end },
		-- 旧収容施設穴あきフェンス判定
		{  data = "Fence_SE", 					message = "Enter", 						commonFunc = Fence_SE },
	},
	Timer = {
		-- 管理棟巨大ゲート
	--	{ data = "Timer_CenterBigGateOpen",		message = "OnEnd", 						commonFunc = function() this.Common_CenterBigGate_OpenTime() end },
		-- CP無線
		{ data = "Timer_CpRadioFadeStart",		message = "OnEnd", 						commonFunc = function() this.CpRadioFadeOut() end },
		{ data = "Timer_CpRadioFadeOutEnd",		message = "OnEnd", 						commonFunc = function() TppEnemyUtility.IgnoreCpRadioCall(true) end },	-- 以降の新規無線コールを止める
		-- 西検問側の圏外演出保険処理用タイマー
		{ data = "Timer_OutSideAreaWestVehicleTurn",	message = "OnEnd", 				commonFunc = function() this.ForceMove_Vehicle( this.PlayerOnVehicle, { -334.646, 28.693, 140.815 }, -45.0 ) end },
		-- ミッション圏外iDoroid音声再生開始タイマー
		{ data = "Timer_OutSideAreaVoiceStart",	message = "OnEnd", 				commonFunc = function() this.OutsideAreaVoiceStart() end },
	},
	Character = {
		-- プレイヤー
		{ data = "Player", 						message = "OnVehicleRide_End", 			commonFunc = function() this.PlayerRideOnVehicle() end },	-- 車両に乗り終わった
		{ data = "Player", 						message = "OnVehicleGetOff_Start",		commonFunc = function() this.PlayerGetOffVehicle() end },	-- 車両から降り始めた
		{ data = "Player", 						message = "OnVehicleRideSneak_End", 	commonFunc = function() this.PlayerRideOnCargo() end },		-- 荷台に乗り終わった
		{ data = "Player", 						message = "OnVehicleGetOffSneak_Start", commonFunc = function() this.PlayerGetOffCargo() end },		-- 荷台から降り始めた

		-- GameScript:TppGsCallSupportHelicopter.luaより移植
		{ data = "Player", 						message = "CallRescueHeli", 			localFunc = "OnStartMotherBaseDevise" },	-- MB端末から支援ヘリを呼んだ
		{ data = "Player", 						message = "NotifyStartWarningFlare",	localFunc = "OnStartWarningFlare" },		-- フレアグレネードから支援ヘリを呼んだ
		-- 支援ヘリ
		{ data = "SupportHelicopter",			message = "ArriveToLandingZone",		commonFunc = function() this.SupporHeliLandingZone() end },	--ヘリがＲＶに到着
		{ data = "SupportHelicopter",			message = "CloseDoor",					commonFunc = function() this.SupporHeliCloseDoor() end },	--ヘリのドアが閉まった
		{ data = "SupportHelicopter",			message = "DepartureToMotherBase",		commonFunc = function() this.SupporHeliDeparture() end },	--ヘリが離陸した
		-- 巨大ゲート用スイッチ
		{ data = "gntn_BigGateSwitch", 			message = "SwitchOn",					commonFunc = function() this.Common_CenterBigGate_Open() end },	--

		-- CommandPost
		{ data = "gntn_cp",		message = "AntiAir",	commonFunc = function() this.ChangeAntiAir() end },	-- 対空行動切り替え（e20010,e20030,e20060）
		{ data = "e20020_cp",	message = "AntiAir",	commonFunc = function() this.ChangeAntiAir() end },	-- 対空行動切り替え（e20020）
	},
	Enemy = {
		{ 										message = "EnemyInterrogation",			commonFunc = function() this.EnemyInterrogation() end },	-- 敵兵が尋問された
		{										message = "HostageLaidOnVehicle",		commonFunc = function() this.EnemyLaidonVehicle() end },	-- 敵兵をヘリで回収した
	},
	Mission = {
		{ message = "MissionClear", 			localFunc = "commonEsrConClean" },		-- ミッションクリア
		{ message = "ReturnTitle", 				localFunc = "commonEsrConClean" },		-- タイトル画面へ（メニュー）
	},
	Gimmick = {
		-- 管理棟巨大ゲート
		{ data = "gntn_BigGate", message = "DoorOpenComplete", commonFunc = function() this.Common_CenterBigGate_OpenTime() end },
		-- 配電盤
		{ data = "gntn_center_SwitchLight", message = "SwitchOn", commonFunc = function() this.ShowCommonAnnounceLog( "announce_power_on" ) end },	--管理棟配電盤ＯＮ
		{ data = "gntn_center_SwitchLight", message = "SwitchOff", commonFunc = function() this.ShowCommonAnnounceLog( "announce_power_off" ) end },	--管理棟配電盤ＯＦＦ
	},
}
---------------------------------------------------------------------------------
-- ■■ Score/Rank
---------------------------------------------------------------------------------
-- ■ ScoreRankTableSetup
this.ScoreRankTableSetup = function( missionId )
	Fox.Log("-------GZCommon.ScoreRankTableSetup------")

	-------- ミッション毎にチャレンジ項目達成時スコア及びランク判定用テーブルを設定 --------
	local challengeBonus
	local hardmode = TppGameSequence.GetGameFlag("hardmode")

	-- e20010:パスを救出
	if ( missionId == 20010 ) then

		-- ヘリ被撃破カウントは無効
		PlayRecord.InvalidResultScore( "SCORE_HERI_COUNT" )
		PlayRecord.InvalidResultScore( "SCORE_BONUS_CHALLENGE_COUNT" )

		-- チャレンジ項目達成時スコア
		challengeBonus = 0	-- 不要になったので0

		-- ランク判定用テーブル設定
		if ( hardmode ) then
			-- 難易度HARD
			PlayRecord.SetRankTable{ rank_s = 59000, rank_a = 44000, rank_b = 28000, rank_c = 12000, rank_d = 1 }
		else
			-- 難易度NORMAL
			PlayRecord.SetRankTable{ rank_s = 57000, rank_a = 42000, rank_b = 26000, rank_c = 10000, rank_d = 1 }
		end
		-------- スコア判定用テーブル設定 --------
		-- スコア計算方法：
		-- スコア = 基準スコア + ( (基準値 - プレイ結果) / 基準値 * 増加値)	←少ない方がいい場合
		-- 計算結果のスコアが最大スコアを超えている場合、ボーナススコアを更にプラス

		PlayRecord.SetScoreTable{
			initializeScore = 0,					-- 初期値
			challengeScore = challengeBonus,		-- 各ミッションのチャレンジ項目達成時スコア
			markingScore = 0,						-- ノーマーキングボーナススコア
			reflexScore = 5250,						-- ノーリフレックスボーナススコア

			--			   :増加値					:基準値				:基準スコア			:ボーナススコア		:最小スコア（未使用）:最大スコア（未使用）
			clearTime	 = { diffValue =  3000,		baseValue = 600,	baseScore = 39000,	bonusScore =	0,	minScore =		0,	maxScore = 40000 },	-- クリアタイム（より短いほうが良い）
			alertCount	 = { diffValue =   300,		baseValue =   0,	baseScore = 	0,	bonusScore = 5250,	minScore =	-6000,	maxScore =	   0 },	-- アラート回数（より少ないほうが良い）
			killCount	 = { diffValue =   200,		baseValue =   0,	baseScore = 	0,	bonusScore = 3500,	minScore = -10000,	maxScore =	   0 },	-- キル回数（より少ないほうが良い）
			retryCount	 = { diffValue =   300,		baseValue =   0,	baseScore = 	0,	bonusScore = 5250,	minScore =	-6000,	maxScore =	   0 },	-- リトライ回数（より少ないほうが良い）
			heriCount	 = { diffValue = 0,			baseValue =   0,	baseScore = 	0,	bonusScore =	0,	minScore = -12000,	maxScore =	   0 },	-- ヘリ破壊数（より少ないほうが良い）
			hostageCount = { diffValue = -3500,		baseValue =   0,	baseScore = 	0,	bonusScore =	0,	minScore =		0,	maxScore = 24500 }	-- 捕虜救助数（より多いほうが良い）
		}

	-- e20020:帰還兵をヘリで回収
	elseif ( missionId == 20020 ) then

		PlayRecord.InvalidResultScore( "SCORE_BONUS_CHALLENGE_COUNT" )

		-- チャレンジ項目達成時スコア
		challengeBonus = 0	-- 不要になったので0

		-- ランク判定用テーブル設定
		if ( hardmode ) then
			-- 難易度HARD
			PlayRecord.SetRankTable{ rank_s = 50000, rank_a = 38000, rank_b = 25000, rank_c = 12000, rank_d = 1 }
		else
			-- 難易度NORMAL
			PlayRecord.SetRankTable{ rank_s = 48000, rank_a = 35500, rank_b = 23000, rank_c = 10000, rank_d = 1 }
		end

		PlayRecord.SetScoreTable{
			initializeScore = 0,					-- 初期値
			challengeScore = challengeBonus,		-- 各ミッションのチャレンジ項目達成時スコア
			markingScore = 0,						-- ノーマーキングボーナススコア
			reflexScore = 7500,						-- ノーリフレックスボーナススコア

			--			   :増加値					:基準値				:基準スコア			:ボーナススコア		:最小スコア（未使用）:最大スコア（未使用）
			clearTime	 = { diffValue =  3000,		baseValue = 250,	baseScore = 33500,	bonusScore =	0,	minScore =		0,	maxScore = 31700 },	-- クリアタイム（より短いほうが良い）
			alertCount	 = { diffValue =   600,		baseValue =   0,	baseScore = 	0,	bonusScore = 7500,	minScore = -12000,	maxScore =	   0 },	-- アラート回数（より少ないほうが良い）
			killCount	 = { diffValue =   200,		baseValue =   0,	baseScore = 	0,	bonusScore = 2500,	minScore = -10000,	maxScore =	   0 },	-- キル回数（より少ないほうが良い）
			retryCount	 = { diffValue =   300,		baseValue =   0,	baseScore = 	0,	bonusScore = 3750,	minScore =	-6000,	maxScore =	   0 },	-- リトライ回数（より少ないほうが良い）
			heriCount	 = { diffValue =  1500,		baseValue =   0,	baseScore = 	0,	bonusScore =	0,	minScore = -12000,	maxScore =	   0 },	-- ヘリ破壊数（より少ないほうが良い）
			hostageCount = { diffValue = -3500,		baseValue =   0,	baseScore = 	0,	bonusScore =	0,	minScore =		0,	maxScore = 24500 }	-- 捕虜救助数（より多いほうが良い）
		}

	-- e20030:2つ目のテープを入手
	elseif ( missionId == 20030 ) then

		PlayRecord.InvalidResultScore( "SCORE_BONUS_CHALLENGE_COUNT" )

		-- チャレンジ項目達成時スコア
		challengeBonus = 0	-- 不要になったので0

		-- ランク判定用テーブル設定
		if ( hardmode ) then
			Fox.Log("-------GZCommon.ScoreRankTableSetup:::HARD_MODE------")
			-- 難易度HARD
			PlayRecord.SetRankTable{ rank_s = 52000, rank_a = 39000, rank_b = 25500, rank_c = 12000, rank_d = 1 }
		else
			Fox.Log("-------GZCommon.ScoreRankTableSetup:::NORMAL_MODE------")
			-- 難易度NORMAL
			PlayRecord.SetRankTable{ rank_s = 50750, rank_a = 38000, rank_b = 24000, rank_c = 10000, rank_d = 1 }
		end

		PlayRecord.SetScoreTable{
			initializeScore = 0,					-- 初期値
			challengeScore = challengeBonus,		-- 各ミッションのチャレンジ項目達成時スコア
			markingScore = 0,					-- ノーマーキングボーナススコア
			reflexScore = 6000,						-- ノーリフレックスボーナススコア

			--			   :増加値				:基準値			 :基準スコア		:ボーナススコア		:最小スコア（未使用）:最大スコア（未使用）
			clearTime	 = { diffValue =  3000, baseValue =  200, baseScore = 40000, bonusScore =	 0, minScore =		0, maxScore = 37000 },	-- クリアタイム（より短いほうが良い）
			alertCount	 = { diffValue =   600, baseValue =    0, baseScore =	  0, bonusScore = 6000, minScore = -12000, maxScore =	  0 },	-- アラート回数（より少ないほうが良い）
			killCount	 = { diffValue =   200, baseValue =    0, baseScore =	  0, bonusScore = 2000, minScore = -10000, maxScore =	  0 },	-- キル回数（より少ないほうが良い）
			retryCount	 = { diffValue =   300, baseValue =    0, baseScore =	  0, bonusScore = 3000, minScore =	-6000, maxScore =	  0 },	-- リトライ回数（より少ないほうが良い）
			heriCount	 = { diffValue =  1500, baseValue =    0, baseScore =	  0, bonusScore =	 0, minScore = -12000, maxScore =	  0 },	-- ヘリ破壊数（より少ないほうが良い）
			hostageCount = { diffValue = -3500, baseValue =    0, baseScore =	  0, bonusScore =	 0, minScore =		0, maxScore = 24500 }	-- 捕虜救助数（より多いほうが良い）
		}

	-- e20040:モアイを全て撃つ
	elseif ( missionId == 20040 ) then

		-- ヘリ被撃破カウントは無効
		PlayRecord.InvalidResultScore( "SCORE_HERI_COUNT" )
		-- ALERTカウントは無効
		PlayRecord.InvalidResultScore( "SCORE_ALERT_COUNT" )
		-- 捕虜は居ないので捕虜カウントは無効
		PlayRecord.InvalidResultScore( "SCORE_HOSTAGE_COUNT" )
		-- リフレックスは発生しないので無効
		PlayRecord.InvalidResultScore( "SCORE_BONUS_NOREFLEX" )

		PlayRecord.InvalidResultScore( "SCORE_BONUS_CHALLENGE" )

		-- チャレンジ項目達成時スコア
		challengeBonus = 0	-- 不要になったので0

		-- ランク判定用テーブル設定
		if ( hardmode ) then
			-- 難易度HARD
			PlayRecord.SetRankTable{ rank_s = 23500, rank_a = 18500, rank_b = 13500, rank_c = 8500, rank_d = 1 }
		else
			-- 難易度NORMAL
			PlayRecord.SetRankTable{ rank_s = 19250, rank_a = 15000, rank_b = 10750, rank_c = 6500, rank_d = 1 }
		end

		PlayRecord.SetScoreTable{
			initializeScore = 0,					-- 初期値
			challengeScore = challengeBonus,		-- 各ミッションのチャレンジ項目達成時スコア
			markingScore = 0,						-- ノーマーキングボーナススコア
			reflexScore = 0,						-- ノーリフレックスボーナススコア

			--			   :増加値			:基準値			 :基準スコア		:ボーナススコア	   :最小スコア（未使用） :最大スコア（未使用）
			clearTime	 = { diffValue = 3000, baseValue = 525, baseScore = 24750, bonusScore =    0, minScore =	  0, maxScore = 24779 },	-- クリアタイム（より短いほうが良い）
			alertCount	 = { diffValue =	0, baseValue =	 0, baseScore = 	0, bonusScore =    0, minScore =	  0, maxScore = 	0 },	-- アラート回数（より少ないほうが良い）
			killCount	 = { diffValue =  200, baseValue =	 0, baseScore = 	0, bonusScore =  250, minScore = -10000, maxScore = 	0 },	-- キル回数（より少ないほうが良い）
			retryCount	 = { diffValue =  300, baseValue =	 0, baseScore = 	0, bonusScore =  375, minScore =  -6000, maxScore = 	0 },	-- リトライ回数（より少ないほうが良い）
			heriCount	 = { diffValue =	0, baseValue =	 0, baseScore = 	0, bonusScore =    0, minScore =	  0, maxScore = 	0 },	-- ヘリ破壊数（より少ないほうが良い）
			hostageCount = { diffValue =	0, baseValue =	 0, baseScore = 	0, bonusScore =    0, minScore =	  0, maxScore = 	0 },	-- 捕虜救助数（より多いほうが良い）

		}

	-- e20050:木製櫓を全て壊す
	elseif ( missionId == 20050 ) then

		PlayRecord.InvalidResultScore( "SCORE_BONUS_CHALLENGE_COUNT" )

		-- チャレンジ項目達成時スコア
		challengeBonus = 0	-- 不要になったので0

		-- ランク判定用テーブル設定
		if ( hardmode ) then
			-- 難易度HARD
			PlayRecord.SetRankTable{ rank_s = 46000, rank_a = 35000, rank_b = 24000, rank_c = 12000, rank_d = 1 }
		else
			-- 難易度NORMAL
			PlayRecord.SetRankTable{ rank_s = 44000, rank_a = 33000, rank_b = 22000, rank_c = 10000, rank_d = 1 }
		end

		PlayRecord.SetScoreTable{
			initializeScore = 0,					-- 初期値
			challengeScore = challengeBonus,		-- 各ミッションのチャレンジ項目達成時スコア
			markingScore = 0,						-- ノーマーキングボーナススコア
			reflexScore = 8250,						-- ノーリフレックスボーナススコア

			--			   :増加値				:基準値				:基準スコア			:ボーナススコア		:最小スコア（未使用）:最大スコア（未使用）
			clearTime	 = { diffValue =  3000,	baseValue = 225,	baseScore = 33750,	bonusScore =	0,	minScore =		0,	maxScore = 31417 },
			alertCount	 = { diffValue =   600,	baseValue =   0,	baseScore = 	0,	bonusScore = 8250,	minScore = -12000,	maxScore =	   0 },	-- アラート回数（より少ないほうが良い）
			killCount	 = { diffValue =   200,	baseValue =   0,	baseScore = 	0,	bonusScore = 2750,	minScore = -10000,	maxScore =	   0 },	-- キル回数（より少ないほうが良い）
			retryCount	 = { diffValue =   300,	baseValue =   0,	baseScore = 	0,	bonusScore = 4125,	minScore =	-6000,	maxScore =	   0 },	-- リトライ回数（より少ないほうが良い）
			heriCount	 = { diffValue =  1500,	baseValue =   0,	baseScore = 	0,	bonusScore =	0,	minScore = -12000,	maxScore =	   0 },	-- ヘリ破壊数（より少ないほうが良い）
			hostageCount = { diffValue = -3500,	baseValue =   0,	baseScore = 	0,	bonusScore =	0,	minScore =		0,	maxScore = 24500 }	-- 捕虜救助数（より多いほうが良い）
		}

	-- e20060:全ての地雷を回収
	elseif ( missionId == 20060 ) then

		-- 捕虜は居ないので捕虜カウントは無効
		PlayRecord.InvalidResultScore( "SCORE_HOSTAGE_COUNT" )

		-- チャレンジ項目達成時スコア
		challengeBonus = 0	-- 不要になったので0

		-- ランク判定用テーブル設定
		if ( hardmode ) then
			-- 難易度HARD
			PlayRecord.SetRankTable{ rank_s = 69000, rank_a = 54500, rank_b = 40000, rank_c = 20000, rank_d = 1 }
		else
			-- 難易度NORMAL
			PlayRecord.SetRankTable{ rank_s = 65000, rank_a = 50500, rank_b = 36000, rank_c = 18000, rank_d = 1 }
		end

		PlayRecord.SetScoreTable{
			initializeScore = 0,					-- 初期値
			challengeScore = challengeBonus,		-- 各ミッションのチャレンジ項目達成時スコア
			markingScore = 0,						-- ノーマーキングボーナススコア
			reflexScore = 3000,						-- ノーリフレックスボーナススコア

			--			   :調整値				:基準値			 :基準スコア		:ボーナススコア	   :最小スコア（未使用）:最大スコア（未使用）
			clearTime	 = { diffValue =  3000, baseValue = 120, baseScore = 46800, bonusScore =	0, minScore =	   0,	maxScore = 39800 },	-- クリアタイム（より短いほうが良い）
			alertCount	 = { diffValue =   300, baseValue =	  0, baseScore =	 0, bonusScore = 3000, minScore =  -6000,	maxScore =	   0 },	-- アラート回数（より少ないほうが良い）
			killCount	 = { diffValue =   200, baseValue =   0, baseScore =	 0, bonusScore = 2000, minScore = -10000,	maxScore =	   0 },	-- キル回数（より少ないほうが良い）
			retryCount	 = { diffValue =   300, baseValue =   0, baseScore =	 0, bonusScore = 3000, minScore =  -6000,	maxScore =	   0 },	-- リトライ回数（より少ないほうが良い）
			heriCount	 = { diffValue =  1500, baseValue =   0, baseScore =	 0, bonusScore =	0, minScore = -12000,	maxScore =	   0 },	-- ヘリ破壊数（より少ないほうが良い）
			hostageCount = { diffValue =	 0, baseValue =   0, baseScore =	 0, bonusScore =	0, minScore =	   0,	maxScore =	   0 }	-- 捕虜救助数（より多いほうが良い）
		}

	-- e20070:
	elseif ( missionId == 20070 ) then
		-- チャレンジ項目達成時スコア
		challengeBonus = 0	-- 不要になったので0

		-- 使わないスコアを無効に
		PlayRecord.InvalidResultScore( "SCORE_HERI_COUNT" )	-- ヘリ被撃墜数
		PlayRecord.InvalidResultScore( "SCORE_HOSTAGE_COUNT" )	-- 捕虜回収数
		PlayRecord.InvalidResultScore( "SCORE_BONUS_CHALLENGE" )

		-- ランク判定用テーブル設定
		if ( hardmode ) then
			-- 難易度HARD
			PlayRecord.SetRankTable{ rank_s = 23000, rank_a = 19500, rank_b = 16000, rank_c = 12000, rank_d = 1 }
		else
			-- 難易度NORMAL
			PlayRecord.SetRankTable{ rank_s = 22000, rank_a = 18000, rank_b = 14000, rank_c = 10000, rank_d = 1 }
		end

		PlayRecord.SetScoreTable{
			initializeScore = 0,					-- 初期値
			challengeScore = challengeBonus,		-- 各ミッションのチャレンジ項目達成時スコア
			markingScore = 0,						-- ノーマーキングボーナススコア
			reflexScore = 1200,						-- ノーリフレックスボーナススコア

			--			   :増加値				:基準値				:基準スコア			:ボーナススコア		:最小スコア（未使用）:最大スコア（未使用）
			clearTime	 = { diffValue =  3000,	baseValue = 510,	baseScore = 21900,	bonusScore =	0,	minScore =		0,	maxScore = 22547 },
			alertCount	 = { diffValue =   600,	baseValue =   0,	baseScore = 	0,	bonusScore = 1200,	minScore = -12000,	maxScore =	   0 },	-- アラート回数（より少ないほうが良い）
			killCount	 = { diffValue =   600,	baseValue =   0,	baseScore = 	0,	bonusScore = 1200,	minScore = -30000,	maxScore =	   0 },	-- キル回数（より少ないほうが良い）
			retryCount	 = { diffValue =   200,	baseValue =   0,	baseScore = 	0,	bonusScore =  400,	minScore =	-4000,	maxScore =	   0 },	-- リトライ回数（より少ないほうが良い）
			heriCount	 = { diffValue =  1500,	baseValue =   0,	baseScore = 	0,	bonusScore =	0,	minScore = -12000,	maxScore =	   0 },	-- ヘリ破壊数（より少ないほうが良い）
			hostageCount = { diffValue =	 0,	baseValue =   0,	baseScore = 	0,	bonusScore =	0,	minScore =		0,	maxScore =	   0 }	-- 捕虜救助数（より多いほうが良い）
		}

	else
		Fox.Warning( "----- GZCommon.ScoreRankTableSetup: missionId is irregularity!! -----")
		challengeBonus = 0
	end

end

---------------------------------------------------------------------------------
-- ■■ Item
---------------------------------------------------------------------------------
-- ■ DromItemFromPlayer / 尋問時に敵兵が落とす想定で発生場所が調整してあります。
this.DromItemFromPlayer = function( itemId, index )
	Fox.Log("------ GZCommon.DromItemFromPlayer -----")

	local player = TppPlayerUtility.GetLocalPlayerCharacter()
	local pos = player:GetPosition()
	local isSquat = TppPlayerUtility.IsLocalPlayerSquat()

	if ( isSquat ) then
		-- しゃがみの場合
		local vel = player:GetRotation():Rotate( Vector3( 0.0, 0.5, 2.5) )
		local offset = player:GetRotation():Rotate( Vector3( 0.0, -0.35, 0.5) )
		TppNewCollectibleUtility.DropItem{ id = itemId, index = index, pos = pos+offset, rot = Quat.RotationY(1.5), vel = vel, rotVel = Vector3(0,2,0) }
	else
		-- 立ちの場合
		local vel = player:GetRotation():Rotate( Vector3( 0.0, 0.5, 1.5) )
		local offset = player:GetRotation():Rotate( Vector3( 0.0, 0.175, 0.5) )
		TppNewCollectibleUtility.DropItem{ id = itemId, index = index, pos = pos+offset, rot = Quat.RotationY(1.5), vel = vel, rotVel = Vector3(0,2,0) }
	end
end
---------------------------------------------------------------------------------
-- ■■ Reward
---------------------------------------------------------------------------------
-- ■ CheckClearRankReward
-- 難易度別にこれまでの戦績に応じて報酬アイテムを設置する
this.CheckClearRankReward = function( missionId, ClearRankRewardList )

	Fox.Log("************* GZCommon.CheckClearRankReward ***************" )

	local hardmode = TppGameSequence.GetGameFlag("hardmode")
	local bestRank = 0

	-- 今回の難易度によって問い合わせる戦績が異なる
	if ( hardmode ) then
		-- 難易度HARD
		bestRank = PlayRecord.GetMissionScore( missionId, "HARD", "BEST_RANK")
		Fox.Log("***"..missionId.."_HARD_MODE_BEST_RANK_IS____"..bestRank)
	else
		-- 難易度NORMAL
		bestRank = PlayRecord.GetMissionScore( missionId, "NORMAL", "BEST_RANK")
		Fox.Log("***"..missionId.."_NORMAL_MODE_BEST_RANK_IS____"..bestRank)
	end

	-- BestRankに応じて無効化するアイテムを決定
	-- ミッションクリア時の報酬獲得ポップアップ用にミッション開始時点でのBestRankを返しておく
	if ( bestRank == 1 ) then
		-- RankS
		-- 全ての報酬アイテムが有効（なので何もしない）
		return bestRank
	elseif ( bestRank == 2 ) then
		-- RankA
		-- RankSの報酬アイテムが無効
		TppPickableManager.DisableByLocator( ClearRankRewardList.RankS )
		return bestRank
	elseif ( bestRank == 3 ) then
		-- RankB
		-- RankS,Aの報酬アイテムが無効
		TppPickableManager.DisableByLocator( ClearRankRewardList.RankS )
		TppPickableManager.DisableByLocator( ClearRankRewardList.RankA )
		return bestRank
	elseif ( bestRank == 4 ) then
		-- RankC
		-- RankS,A,Bの報酬アイテムが無効
		TppPickableManager.DisableByLocator( ClearRankRewardList.RankS )
		TppPickableManager.DisableByLocator( ClearRankRewardList.RankA )
		TppPickableManager.DisableByLocator( ClearRankRewardList.RankB )
		return bestRank
	else
		-- それ以下または初回（BestRank0）
		-- 全ての報酬アイテムが無効
		TppPickableManager.DisableByLocator( ClearRankRewardList.RankS )
		TppPickableManager.DisableByLocator( ClearRankRewardList.RankA )
		TppPickableManager.DisableByLocator( ClearRankRewardList.RankB )
		TppPickableManager.DisableByLocator( ClearRankRewardList.RankC )
		return 5	-- ポップアップ判定の都合上5（=RankD）を返す
	end

end
-------------------------------------------
-- ■ CheckReward_AllChicoTape
-- 全ての「チコの記録」テープを入手済みか？
this.CheckReward_AllChicoTape = function()
	Fox.Log("------ GZCommon.CheckReward_AllChicoTape -----")

	local uiCommonData = UiCommonDataManager.GetInstance()

	if ( uiCommonData:IsHaveCassetteTape( "tp_chico_01" ) == true and
		 uiCommonData:IsHaveCassetteTape( "tp_chico_02" ) == true and
		 uiCommonData:IsHaveCassetteTape( "tp_chico_03" ) == true and
		 uiCommonData:IsHaveCassetteTape( "tp_chico_04" ) == true and
		 uiCommonData:IsHaveCassetteTape( "tp_chico_05" ) == true and
		 uiCommonData:IsHaveCassetteTape( "tp_chico_06" ) == true and
		 uiCommonData:IsHaveCassetteTape( "tp_chico_07" ) == true ) then
		Fox.Log("------ GZCommon.CheckReward_AllChicoTape:TRUE -----")
		return true
	else
		Fox.Log("------ GZCommon.CheckReward_AllChicoTape:FALSE -----")
		return false
	end

end

-------------------------------------------
-- ■ Radio_pleaseLeaveHeli
-- ヘリから離れる用促し無線処理
this.Radio_pleaseLeaveHeli = function()

	local player = Ch.FindCharacterObjectByCharacterId( "Player" )
	local pPos = player:GetPosition()
	local heli = Ch.FindCharacterObjectByCharacterId( "SupportHelicopter")
	local hPos = heli:GetPosition()

	local dist = TppUtility.FindDistance( pPos, hPos )
--	Fox.Log(dist)

	-- プレイヤーとヘリの距離が一定以下だったら
	if( dist < 1000 )then
		Fox.Log("please leave me!")
		return true
	end

	return false
end

-------------------------------------------
this.SetGameStatusForDemoTransition = function()
	Fox.Log("Set Game Status : npc_nothice target player_pad throwing placement")
	--デモ前の位置あわせのときから色々封じる。TppDemo.lua名で封じればデモ後に復帰する
	TppGameStatus.Set("TppDemo.lua","S_DISABLE_NPC_NOTICE")
	TppGameStatus.Set("TppDemo.lua","S_DISABLE_TARGET")
	TppGameStatus.Set("TppDemo.lua","S_DISABLE_PLAYER_PAD")
	TppGameStatus.Set("TppDemo.lua","S_DISABLE_THROWING")
	TppGameStatus.Set("TppDemo.lua","S_DISABLE_PLACEMENT")
end
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this
