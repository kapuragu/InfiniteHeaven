local this = {}

---------------------------------------------------------------------------------
-- Member Variables
---------------------------------------------------------------------------------

this.missionID					= 20050			-- グアンタナモ破壊工作ミッション
this.CP_ID						= "e20050_cp"

this.MISSILE_ID					= "WP_ms02"
this.CHARACTER_ID_HELICOPTER	= "SupportHelicopter"

---------------------------------------------------------------------------------
-- EventSequenceManager
---------------------------------------------------------------------------------
this.RequiredFiles = {
	"/Assets/tpp/script/common/GZCommon.lua",
}

this.Sequences = {
	{ "Seq_MissionPrepare" },
	{ "Seq_MissionSetup" },
	{ "Seq_LoadOpeningDemo" },
	{ "Seq_OpeningShowTransition" },
	{ "Seq_OpeningDemo" },
	{ "Seq_DestroyTarget1" },				-- 対空機関砲を破壊する
	{ "Seq_DestroyTarget2" },				-- 装甲車を破壊する
	{ "Seq_CallSupportHelicopter" },		-- ヘリを呼ぶ
	{ "Seq_Escape" },						-- 脱出する
	{ "Seq_PlayerRideHelicopter" },			-- プレイヤーがヘリに乗っている
	{ "Seq_PlayMissionClearDemo" },			-- クリアデモ
	{ "Seq_MissionClearShowTransition" },
	{ "Seq_MissionClear" },
	{ "Seq_MissionFailedRideHelicopter" },
	{ "Seq_MissionFailedTimeOver" },
	{ "Seq_MissionFailedOutsideMissionArea" },
	{ "Seq_MissionFailedPlayerDead" },
	{ "Seq_MissionFailedHelicopterDead" },
	{ "Seq_MissionGameOver" },
	{ "Seq_ShowClearReward" },
	{ "Seq_MissionEnd" },
}

this.OnStart = function( manager )

	Fox.Log( "e20050_sequence.OnStart()" )

	GZCommon.Register( this, manager )
	TppMission.Setup()

	-- this.onCommonMissionSetup()				-- ミッション初期化処理

end

-- "exec"に向かうべきシーケンスのリスト
this.ChangeExecSequenceList =  {
	"Seq_OpeningDemo",
	"Seq_DestroyTarget1",
	"Seq_DestroyTarget2",
	"Seq_CallSupportHelicopter",
	"Seq_Escape",
	"Seq_PlayerRideHelicopter",
}

-- ゲームに向かうべきシーケンスなのかを知ることが出来る
local IsChangeExecSequence = function()
	local sequence = TppSequence.GetCurrentSequence()

	for i = 1, #this.ChangeExecSequenceList do
		if sequence == this.ChangeExecSequenceList[i] then
			return true
		end
	end
	return false
end

-- Demo&EventBlockのLoad完了確認
local IsDemoAndEventBlockActive = function()

	-- デモブロックのロード待ち
	if ( TppMission.IsDemoBlockActive() == false ) then
		return false
	end

	-- イベントブロックのロード待ち
	if ( TppMission.IsEventBlockActive() == false ) then
		return false
	end

	-- ヘリブロックのロード待ち
	if ( TppVehicleBlockControllerService.IsHeliBlockExist() ) then
		-- HeliBlockあり
		if ( TppVehicleBlockControllerService.IsHeliBlockActivated() == false ) then
			return false
		end
	end

	-- テクスチャのロード待ち
	if ( MissionManager.IsMissionStartMiddleTextureLoaded() == false ) then
		return false
	end

	-- 決定ボタン押されるの待ち
	local hudCommonData = HudCommonDataManager.GetInstance()
	if hudCommonData:IsEndLoadingTips() == false then
			hudCommonData:PermitEndLoadingTips() --終了許可(決定ボタンを押したら消える)
			return false
	end

	return true

end

this.OnEnterCommon = function()

	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log( "=== " .. sequence .. " : OnEnter ===" )
	if IsChangeExecSequence() then
		TppMission.ChangeState( "exec" )
	end
end

this.OnLeaveCommon = function()

	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log( "=== " .. sequence .. " : OnLeave ===" )

end

this.OnSkipEnterCommon = function( manager )

	Fox.Log( "==== e20050_sequence.OnSkipEnterCommon() ====" )

	-- 現在のシーケンスを取得する
	local sequence = TppSequence.GetCurrentSequence()

	-- シーケンス毎の初期化
	if 	sequence == "Seq_MissionFailedRideHelicopter" or
		sequence == "Seq_MissionFailedTimeOver" or
		sequence == "Seq_MissionFailedOutsideMissionArea" or
		sequence == "Seq_MissionFailedPlayerDead" then						-- 現在のシーケンスがSeq_MissionFailed以降なら

		TppMission.ChangeState( "failed" )										-- ミッション状態をfailedに

	elseif sequence == "Seq_MissionClear" then								-- 現在のシーケンスがSeq_MissionClearなら
		TppMission.ChangeState( "clear" )										-- ミッション状態をclearに
	end

	-- SkipはDemoBlockを必ずロードする
	this.commonLoadDemoBlock()	-- デモブロックをロードする

end

this.OnSkipUpdateCommon = function()

	-- デモブロックが読み込み終わるまで待機
	return IsDemoAndEventBlockActive()

end

this.OnSkipLeaveCommon = function()

	Fox.Log( "==== e20050_sequence.OnSkipLeaveCommon() ====" )

	local sequence = TppSequence.GetCurrentSequence()
	if TppSequence.IsGreaterThan( sequence, "Seq_DestroyTarget1" ) then

		TppMission.SetFlag( "isAntiAirRouteSet", true )
		TppMission.SetFlag( "isAntiLandRouteSet", true )

	end
	if TppSequence.IsGreaterThan( sequence, "Seq_DestroyTarget2" ) then
		TppMission.SetFlag( "isArmoredVehicle0000Destroyed", true )
	end
	if sequence == "Seq_DestroyTarget1" then
		TppMission.SetFlag( "isOpeningDemoSkipped", true )
	end
	if sequence == "Seq_DestroyTarget2" then
		-- BGM変更。対空機関砲の破壊直後～装甲車出現～交戦するまで
		TppMusicManager.StartSceneMode()
		TppMusicManager.PlaySceneMusic( "Play_bgm_e20050_count" )
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20050_aircraftgun' )
	end
	if sequence == "Seq_CallSupportHelicopter" then
		TppMusicManager.StartSceneMode()
		TppMusicManager.PlaySceneMusic( "Play_bgm_e20050_count" )
	end
	if sequence == "Seq_Escape" then
		TppMusicManager.StartSceneMode()
		TppMusicManager.PlaySceneMusic( "Play_bgm_e20050_count" )
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20050_count_al' )
	end
	if sequence == "Seq_PlayMissionClearDemo" then
		TppHelicopter.Call( "RV_SeaSide" )	-- ヘリを出現させるためにヘリを呼んでおく
	end

	if sequence ~= "Seq_MissionPrepare" then
		this.onCommonMissionSetup()				-- ミッション初期化処理
	end

	-- デフォルトRVを設定
	TppSupportHelicopterService.SetDefaultRendezvousPointMarker( "RV_SeaSide" )

end

-- コンティニュー時にのみ呼ばれる復帰処理。デバッグスキップ時には呼ばれない
this.OnAfterRestore = function()

	local sequence = TppSequence.GetCurrentSequence()
	if sequence == "Seq_DestroyTarget1" then

	elseif sequence == "Seq_DestroyTarget2" then
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20050_aircraftgun' )
	elseif sequence == "Seq_Escape" then
		TppHelicopter.Call( "RV_SeaSide" )					-- ヘリを呼ぶ
	end

	-- 保存した諜報無線の内容をロードする
	Fox.Log("================== RestoreIntelRadio ====================== " )
	TppRadio.RestoreIntelRadio()
	-- 捕虜諜報無線セットアップ
	this.commonIntelCheck("Hostage_e20050_000")
	this.commonIntelCheck("Hostage_e20050_001")
	this.commonIntelCheck("Hostage_e20050_002")
	this.commonIntelCheck("Hostage_e20050_003")

	GZCommon.CheckContinueHostageRegister( this.ContinueHostageRegisterList )

end

-- ミッション後片付け
this.commonMissionCleanUp = function()

	-- ミッション共通後片付け
	GZCommon.MissionCleanup()

	-- ミッション固有の後片付け処理があればここに書く
	FadeFunction.ResetFadeColor()

	-- 一応ミュート解除しておく
	-- TppSoundDaemon.ResetMute( 'Result' )

	-- BGMシーン終了
	TppMusicManager.EndSceneMode()

	-- カメラ以外操作禁止を解除しておく
	TppPadOperatorUtility.ResetMasksForPlayer( 0, "CameraOnly")

	-- タイマーUIの表示消す
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:EraseDisplayTimer()

	-- 無線関連後始末
	TppRadioConditionManagerAccessor.Unregister( "Tutorial" )	 --コンポーネントの解除
	TppRadioConditionManagerAccessor.Unregister( "Basic" )

	-- 無線のフラグをリセット
	GzRadioSaveData.ResetSaveRadioId()
	local radioManager = RadioDaemon:GetInstance()
	radioManager:DisableAllFlagIsMarkAsRead()
	radioManager:ResetRadioGroupAndGroupSetAlreadyReadFlag()

	GzRadioSaveData.ResetSaveEspionageId()

end

-- 初期化処理
this.onCommonMissionSetup = function()

	Fox.Log( "==== e20050_sequence.onCommonMissionSetup() ====" )

	GZCommon.MissionSetup()													-- GZ共通ミッションセットアップ

	-- 時間と天候設定
	TppClock.SetTime( "07:10:00" )
	-- TppClock.SetTime( "12:10:00" )
	TppClock.Stop()
	TppWeather.SetWeather( "sunny" )
	WeatherManager.RequestTag("default", 0 )
	TppEffectUtility.RemoveColorCorrectionLut()
	-- TppEffectUtility.SetColorCorrectionLut( "common_clearSky_a_FILTERLUT" )
	GrTools.SetLightingColorScale(4.0)

	-- 色々初期化
	-- TppTerminal.DeactivateMenu( "Order_Helicopter" ) -- 端末の支援メニューを無効にする
	-- commonCounterListMissionSetup()
	this.commonDisableAllMarker() -- マーカー初期化

	-- ルートセット設定
	TppEnemy.RegisterRouteSet( this.CP_ID, "sneak_day", "e20050_route_d01" )			-- 昼の巡回ルート
	TppEnemy.RegisterRouteSet( this.CP_ID, "caution_day", "e20050_route_c01" )		-- 昼の警戒ルート
	TppEnemy.RegisterRouteSet( this.CP_ID, "hold", "e20050_route_r01" )				-- 警備シフト（使わないかも）

	-- 武器装備品設定
	local hardmode = TppGameSequence.GetGameFlag("hardmode")
	if ( hardmode ) then
		TppPlayer.SetWeapons( GZWeapon.e20050_SetWeaponsHard )
	else
		TppPlayer.SetWeapons( GZWeapon.e20050_SetWeapons )
	end

	-- トラックの荷台に武器を仕込んでおく
	-- TppNewCollectibleUtility.PutCollectibleOnCharacter{ id = "WP_ar00_v01", count = 8, target = "Cargo_Truck_WEST_000", attachPoint = "CNP_USERITEM" }

	-- 諜報無線を有効にしておく
	-- TppRadio.EnableIntelRadio( "IntelRadio_WoodTurret" )
	-- TppRadio.EnableIntelRadio( "IntelRadio_MetalTurret" )
	TppRadio.EnableIntelRadio( "gntn_area01_antiAirGun_000" )
	TppRadio.EnableIntelRadio( "gntn_area01_antiAirGun_001" )
	TppRadio.EnableIntelRadio( "gntn_area01_antiAirGun_002" )
	TppRadio.EnableIntelRadio( "gntn_area01_antiAirGun_003" )
	TppRadio.EnableIntelRadio( "Hostage_e20050_000" )
	TppRadio.EnableIntelRadio( "Hostage_e20050_001" )
	TppRadio.EnableIntelRadio( "Hostage_e20050_002" )
	TppRadio.EnableIntelRadio( "Hostage_e20050_003" )
	TppRadio.EnableIntelRadio( "IntelRadio_Claymore" )
	TppRadio.EnableIntelRadio( "Hostage_e20050_000" )
	TppRadio.EnableIntelRadio( "Hostage_e20050_001" )
	TppRadio.EnableIntelRadio( "Hostage_e20050_002" )
	TppRadio.EnableIntelRadio( "WoodTurret01" )
	TppRadio.EnableIntelRadio( "WoodTurret02" )
	TppRadio.EnableIntelRadio( "WoodTurret03" )
	TppRadio.EnableIntelRadio( "WoodTurret04" )
	TppRadio.EnableIntelRadio( "WoodTurret05" )
	TppRadio.EnableIntelRadio( "e20050_drum0002" )
	TppRadio.EnableIntelRadio( "e20050_drum0003" )
	TppRadio.EnableIntelRadio( "e20050_drum0004" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0002" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0005" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0011" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0012" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0015" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0019" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0020" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0021" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0022" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0023" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0024" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0025" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0027" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0028" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0029" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0030" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0031" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0035" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0037" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0038" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0039" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0040" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0041" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0042" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0043" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0044" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0045" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0046" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0047" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0048" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0065" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0066" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0068" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0069" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0070" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0071" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0072" )
	TppRadio.EnableIntelRadio( "gntnCom_drum0101" )
	TppRadio.EnableIntelRadio( "e20050_SecurityCamera_01" )
	TppRadio.EnableIntelRadio( "e20050_SecurityCamera_02" )
	TppRadio.EnableIntelRadio( "e20050_SecurityCamera_03" )
	TppRadio.EnableIntelRadio( "e20050_SecurityCamera_04" )
	TppRadio.EnableIntelRadio( "e20050_SecurityCamera_05" )
	-- 乗り物
	TppRadio.EnableIntelRadio( "Tactical_Vehicle_WEST_000" )
	TppRadio.EnableIntelRadio( "Tactical_Vehicle_WEST_001" )
	TppRadio.EnableIntelRadio( "Cargo_Truck_WEST_000" )
	TppRadio.EnableIntelRadio( "Cargo_Truck_WEST_001" )
	TppRadio.EnableIntelRadio( "Cargo_Truck_WEST_002" )

	--無効にする
	TppRadio.DisableIntelRadio( "intel_f0090_esrg0190" )
	TppRadio.DisableIntelRadio( "intel_f0090_esrg0200" )

	-- 保持すべきリアルタイム無線のフラグを保持
	TppRadio.SetAllSaveRadioId()

	-- UI系設定
	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager ~= NULL then
		local luaData = commonDataManager:GetUiLuaExportCommonData()
		if luaData ~= NULL then

			luaData:ResetMisionInfoCurrentStoryNo() -- ストーリー番号を0に戻す

			-- ミッション説明写真を用意
			luaData:EnableMissionPhotoId(10)
			luaData:EnableMissionPhotoId(20)
			luaData:EnableMissionPhotoId(30)
			luaData:EnableMissionPhotoId(40)

			-- 端末上のアイコン説明を用意
			luaData:SetupIconUniqueInformationTable(
				{ markerId = "gntn_area01_antiAirGun_000",		langId = "marker_info_gimmick_weapon" },
				{ markerId = "gntn_area01_antiAirGun_001",		langId = "marker_info_gimmick_weapon" },
				{ markerId = "gntn_area01_antiAirGun_002",		langId = "marker_info_gimmick_weapon" },
				{ markerId = "gntn_area01_antiAirGun_003",		langId = "marker_info_gimmick_weapon" },

				{ markerId = "Tactical_Vehicle_WEST_000",		langId = "marker_info_vehicle_4wd" },
				{ markerId = "Tactical_Vehicle_WEST_001",		langId = "marker_info_vehicle_4wd" },
				{ markerId = "Cargo_Truck_WEST_000",			langId = "marker_info_truck" },
				{ markerId = "Cargo_Truck_WEST_001",			langId = "marker_info_truck" },
				{ markerId = "Cargo_Truck_WEST_002",			langId = "marker_info_truck" },
				{ markerId = "Armored_Vehicle_WEST_000",		langId = "marker_info_APC" },

				{ markerId = "e20050_marker_c4_0000",			langId = "marker_info_weapon_06" },
				{ markerId = "e20050_marker_c4_0001",			langId = "marker_info_weapon_06" },
				{ markerId = "e20050_marker_c4_0002",			langId = "marker_info_weapon_06" },
				{ markerId = "e20050_marker_claymore0000",		langId = "marker_info_weapon_08" },
				{ markerId = "e20050_marker_grenade0000",		langId = "marker_info_weapon_07" },
				{ markerId = "e20050_marker_grenade0001",		langId = "marker_info_weapon_07" },
				{ markerId = "e20050_marker_grenade0002",		langId = "marker_info_weapon_07" },
				{ markerId = "e20050_marker_grenade0003",		langId = "marker_info_weapon_07" },
				{ markerId = "e20050_marker_ms0000",			langId = "marker_info_weapon_02" },
				{ markerId = "e20050_marker_ms0001",			langId = "marker_info_weapon_02" },
				{ markerId = "e20050_marker_shotgun0000",		langId = "marker_info_weapon_03" },
				{ markerId = "e20050_marker_smokegrenades0000",	langId = "marker_info_weapon_05" },
				{ markerId = "e20050_marker_sniperrifle0000",	langId = "marker_info_weapon_01" },
				{ markerId = "e20050_marker_submachinegun0000",	langId = "marker_info_weapon_04" },
				{ markerId = "e20050_marker_submachinegun0001",	langId = "marker_info_weapon_04" },
				{ markerId = "e20050_marker_tranq0000",			langId = "marker_info_bullet_tranq" },
				{ markerId = "e20050_marker_tranq0001",			langId = "marker_info_bullet_tranq" },
				{ markerId = "e20050_marker_tranq0002",			langId = "marker_info_bullet_tranq" },
				{ markerId = "e20050_marker_tranq0003",			langId = "marker_info_bullet_tranq" },
				{ markerId = "common_marker_Area_EastCamp",		langId="marker_info_area_00" },					--東難民キャンプ区画
				{ markerId = "common_marker_Area_WestCamp",		langId="marker_info_area_01" },					--西難民キャンプ区画
				{ markerId = "common_marker_Area_WareHouse",	langId="marker_info_area_02" },					--倉庫区画
				{ markerId = "common_marker_Area_HeliPort",		langId="marker_info_area_03" },					--ヘリ発着場
				{ markerId = "common_marker_Area_Center",		langId="marker_info_area_04" },					--管理棟
				{ markerId = "common_marker_Area_Asylum",		langId="marker_info_area_05" }					--旧収容区画
				,{ markerId="common_marker_Armory_WareHouse",	langId="marker_info_place_armory" }				--武器庫
				,{ markerId="common_marker_Armory_HeliPort",	langId="marker_info_place_armory" }				--武器庫
				,{ markerId="common_marker_Armory_Center",		langId="marker_info_place_armory" }				--武器庫
			)

		end
	end

	-- パス檻のドアを開けておく
	TppGimmick.OpenDoor( "Paz_PickingDoor00", 270 )

	if TppMission.GetFlag( "isAntiAirRouteSet" ) == true then				-- 対空警戒ルートになっていたら
		this.commonSetPhaseToKeepCaution( true )										-- keep cautionにする
	end

	if TppMission.GetFlag( "isAntiLandRouteSet" ) == true then				-- 地上警戒ルートになっていたら
		this.commonChangeToAntiLandRouteSet( true )									-- 地上警戒ルートにする
	end

	this.commonRestoreRoute()												-- ルートを再構築

	MissionManager.SetMiddleTextureWaitParameter( 0.5, 5 )					-- テクスチャロード待ちを宣言

	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0058", { noForceUpdate = false, }  )
	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0059", { noForceUpdate = false, }  )
	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0060", { noForceUpdate = false, }  )
	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0062", { noForceUpdate = false, }  )
	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0063", { noForceUpdate = false, }  )
	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0064", { noForceUpdate = false, }  )

	-- 無反動砲兵士の警戒ルートを無効にしておく
	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0068", { noForceUpdate = false, }  )
	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0069", { noForceUpdate = false, }  )
	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0070", { noForceUpdate = false, }  )
	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0074", { noForceUpdate = false, }  )
	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0075", { noForceUpdate = false, }  )
	TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0076", { noForceUpdate = false, }  )

	-- 機銃装甲車のクラッシュ設定を無効にする
	TppVehicleUtility.SetCrashActionMode( "Armored_Vehicle_WEST_000", false )

	-- リスポーン時の武器変更設定
	TppCommandPostObject.GsAddRespawnRandomWeaponId( this.CP_ID, "WP_sg01_v00", 10 )
	TppCommandPostObject.GsAddRespawnRandomWeaponId( this.CP_ID, "WP_ms02", 5 )

	-- フェードの色をリセットしておく
	FadeFunction.ResetFadeColor()

	TppMission.OnLeaveInnerArea( function() TppRadio.Play( "Radio_WarningMissionArea" ) end )
	TppMission.OnLeaveOuterArea( function()
		local sequence = TppSequence.GetCurrentSequence()
		if	sequence == "Seq_DestroyTarget1" or
			sequence == "Seq_DestroyTarget2" or
			sequence == "Seq_CallSupportHelicopter" or
			sequence == "Seq_Escape" then
			TppMission.ChangeState( "failed", "OutsideMissionArea" )
		end
	end )	--ミッション失敗

	TppMission.SetFlag( "isPlayerInMinefield", false )
	TppMission.SetFlag( "isVehicleInMinefield", false )
	TppMission.SetFlag( "isPlayerInClaymoreRadioTrap", false )
	TppMission.SetFlag( "isCountdownStarted", false )			-- カウントダウンのフラグはゲーム開始時（コンティニュー時含む）には絶対に立っていない

	-- CounterList初期化
	this.CounterList.HeliReachDemoCount = 0
	this.CounterList.playerInDeathTrap0000 = false

end

---------------------------------------------------------------------------------
-- Mission Flag List
---------------------------------------------------------------------------------
this.MissionFlagList = {

	-- 会話や無線を流したか系
	isMissionStartRadioPlayed			= false,				-- ミッション開始無線が流れた
	isMissionBackgroundRadio1Played		= false,				-- ミッション0001背景無線が流れた
	isMissionBackgroundRadio2Played		= false,				-- ミッション0002背景無線が流れた
	isMissionBackgroundRadio4Played		= false,				-- ミッション0004背景無線が流れた
	isCautionRadioPlayed				= false,				-- 警戒無線が流れた
	isHostageDialogue0000Played			= false,				-- 捕虜会話0000が流れた
	isHostageDialogue0001Played			= false,				-- 捕虜会話0001が流れた
	isHostageDialogue0002Played			= false,				-- 捕虜会話0002が流れた
	isVehicleIntelRadioPlayed			= false,				-- 車両諜報無線を聴いた
	isBackGroundRadioWait				= false,				-- ミッション背景説明無線再生を止める
	isClaymoreRadioPlayed				= false,				-- 突然の指向性地雷無線が流れた
	isEmptyAmmoRadioPlayed				= false,
	isHostage0003Talk1Played			= false,				-- 「ボス…？」が再生された
	isHostage0003Talk2Played			= false,				-- MB諜報員担ぎ会話が再生された
	isCountdownStarted					= false,				-- カウントダウンが開始された

	-- 敵系
	isAntiLandRouteSet					= false,				-- 一度でもアラートになった事があって警戒ルートセットになった
	isAntiAirRouteSet					= false,				-- 一度でもkeep cautionになった

	-- ギミック系
	isAntiAirGun0000Destroyed			= false,				-- 対空機関砲0000を破壊した
	isAntiAirGun0001Destroyed			= false,				-- 対空機関砲0001を破壊した
	isAntiAirGun0002Destroyed			= false,				-- 対空機関砲0002を破壊した
	isAntiAirGun0003Destroyed			= false,				-- 対空機関砲0003を破壊した

	isWoodTurret0000Destroyed			= false,				-- 木製櫓0000を破壊した
	isWoodTurret0001Destroyed			= false,				-- 木製櫓0001を破壊した
	isWoodTurret0002Destroyed			= false,				-- 木製櫓0002を破壊した
	isWoodTurret0003Destroyed			= false,				-- 木製櫓0003を破壊した
	isWoodTurret0004Destroyed			= false,				-- 木製櫓0004を破壊した

	-- 乗り物系
	isArmoredVehicle0000Destroyed		= false,				-- 機銃装甲車を破壊した

	isTruck0000Destroyed				= false,				-- トラック0000を破壊した
	isTruck0001Destroyed				= false,				-- トラック0001を破壊した
	isTruck0002Destroyed				= false,				-- トラック0002を破壊した

	isVehicle0000Destroyed				= false,				-- ビークル0000を破壊した
	isVehicle0001Destroyed				= false,				-- ビークル0001を破壊した

	isFinishLightVehicleGroup			= false,				-- 捕虜収容所に乗りつけるビークルの車両連携が終わった
	isLightVechicleStarted				= false,				-- 最初のシーケンスで5分後に発進するビークルが発進した

	isCarTutorial						= false,				--乗り物チュートリアルのボタン表示をした
	isAVMTutorial						= false,				--装甲車チュートリアルのボタン表示をした

	isHeliLandNow						= false,				-- ヘリが地面にホバリングってるかどうか

	-- 武器系
	isC4EquipRadioPlayed				= false,				-- C4を装備した
	isC4PlaceRadioPlayed				= false,				-- C4を設置した
	isPrimaryWPIcon						= false,				-- プライマリウェポンチュートリアルボタン表示をした

	-- 特殊系
	isPlayerInMinefield					= false,				-- プレイヤーが地雷原にいる
	isVehicleInMinefield				= false,				-- 機銃装甲車が地雷原にいる
	isPlayerInClaymoreRadioTrap			= false,
	isOpeningDemoSkipped				= false,

	-- Demo
	isSwitchLightDemo				= false,
}

---------------------------------------------------------------------------------
-- Demo List
---------------------------------------------------------------------------------
this.DemoList = {
	Demo_Opening 						= "p12_040000_000",	-- オープニングデモ
	Demo_MissionClear					= "p12_040010_000",	-- ミッションクリアデモ
	Demo_MissionClear_NotSmooth			= "p12_040015_000",	-- ミッションクリアデモ（つながない版）
	Demo_MissionFailure 				= "p12_040020_000",	-- ミッション失敗空爆デモ（プレイヤーリアクション有り）
	Demo_MissionFailureNoPlayerReaction	= "p12_040030_000",	-- ミッション失敗空爆デモ（プレイヤーリアクション無し）
	Demo_AreaEscapeNorth				= "p11_020010_000",	-- ミッション圏外離脱カメラデモ：北側
	Demo_AreaEscapeWest					= "p11_020020_000",	-- ミッション圏外離脱カメラデモ：西側
	Demo_SwitchLight					= "p11_020003_000",		--スイッチを押したときのカメラ
}

---------------------------------------------------------------------------------
-- ■■ Mission Counter List
---------------------------------------------------------------------------------
this.CounterList = {
	GameOverRadioName		= "NoRadio",							-- ゲームオーバー無線名
	GameOverFadeTime		= GZCommon.FadeOutTime_MissionFailed,	-- ゲームオーバー時フェードアウト開始までのウェイト
	lastRendezvouzPoint		= "",									-- ヘリが最後に出発したRV名
	currentWeapon			= "WP_ar00_v03",
	HeliReachDemoCount		= 0,
	playerInDeathTrap0000	= false,
}

---------------------------------------------------------------------------------
-- Radio List
---------------------------------------------------------------------------------
this.RadioList = {
	-- 正式無線
	Radio_MissionStart					= "e0050_rtrg0010",			-- ミッション開始
	Radio_MissionStartForSkip			= "e0050_rtrg0008",			-- ミッション開始（スキップ・コンティニュー用）
	Radio_MissionBackground1			= "e0050_rtrg0160",			-- ミッション背景説明その1
	Radio_MissionBackground2			= "e0050_rtrg0161",			-- ミッション背景説明その2
	Radio_MissionBackground3			= "e0050_rtrg0162",			-- ミッション背景説明その3
	Radio_MissionBackground4			= "e0050_rtrg0165",			-- 諜報員説明
	Radio_Caution						= "e0050_rtrg0120",			-- 警戒フェイズが上がった
	Radio_AntiAirGunDestroyed			= "e0050_rtrg0040",			-- 対空機関砲を破壊した
	Radio_AntiAirGunDestroyedHalf		= "e0050_rtrg0043",			-- 対空機関砲を半分破壊した（TODO:廃止予定）
	Radio_AntiAirGunDestroyedLastOne	= "e0050_rtrg0045",			-- 対空機関砲が残り1個になった
	Radio_PlayerPickUpWeapon_WP_ms02	= { "e0050_rtrg0050", 1 },	-- 無反動砲を取った
	Radio_PlayerVehicleRide_01			= { "e0050_rtrg0020", 1 },	-- 車両に乗った（e0050_esrg0050を再生していない）
	Radio_PlayerVehicleRide_02			= { "e0050_rtrg0023", 1 },	-- 車両に乗った（e0050_esrg0050を再生した）
	Radio_MbDvcActOpenHeliCall			= { "e0050_rtrg0030", 1 },	-- プレイヤーがヘリを呼んだ
	Radio_HelicopterArriveLZ			= "e0050_rtrg0070",			-- ヘリがLZに到達した
-- 	Radio_CountDownTimer30				= "e0050_rtrg0073",			-- 残り30秒
	Radio_Reinforcements				= "e0050_rtrg0090",			-- 機銃装甲車が増援にやってきた
	Radio_Reinforcements2				= "e0050_rtrg0091",			-- 機銃装甲車が増援にやってきたその2
	Radio_CompletionBreakTarget1		= "e0050_rtrg0060",			-- 所属不明機を捉えた
	Radio_CompletionBreakTarget2		= "e0050_rtrg0061",			-- 所属不明機を捉えた（続き）
	Radio_Escape_TimeLeft_180s			= "e0050_rtrg0080",			-- あと3分
	Radio_Escape_TimeLeft_150s			= "e0050_rtrg0065",			-- あと2分30秒、空爆されそうとわかる
	Radio_Escape_TimeLeft_120s			= "e0050_rtrg0070",			-- あと2分
	Radio_Escape_TimeLeft_060s			= "e0050_rtrg0073",			-- あと1分
	Radio_Escape_TimeLeft_030s			= "e0050_rtrg0074",			-- あと30秒
	Radio_Escape_TimeLeft_030s_2		= "e0050_rtrg0074",			-- あと30秒（ヘリが回収に向かっていない）
	Radio_Escape_TimeLeft_020s			= "e0050_rtrg0075",			-- あと20秒
	Radio_Escape_TimeLeft_010s			= "e0050_rtrg0100",			-- あと10秒
	Radio_Escape_TimeOver				= "e0050_rtrg0101",			-- 間に合わなかった
	Radio_WarningMissionArea			= "f0090_rtrg0310",			-- ミッション圏外警告
	Radio_EmptyAmmo						= { "e0050_rtrg0130", 1 },	-- 爆発系武器の残弾が少ない
	Radio_Advice						= "e0050_rtrg0097",			-- 装甲車の攻略方法
	Radio_Claymore						= { "e0050_rtrg0200", 1 },	-- 突然の指向性地雷
	Radio_Target						= { "e0050_rtrg0095", 1 },	-- それがターゲットの装甲車
	Radio_Conjunction1					= "e0050_rtrg9900",			-- それからボス
	Radio_Conjunction2					= "e0050_rtrg9910",			-- ボス
	Radio_MBHostage						= { "e0050_rtrg0170", 1 },	-- 「ボス、この捕虜……」
	Radio_ArmoredVehicle				= "e0050_rtrg0097",			-- 機銃装甲車の攻略方法
	Radio_ClaymoreInfo					= { "e0050_rtrg0205", 1 },	-- その先には地雷

	-- ヘリ
	Radio_RideHeli_Clear				= "f0090_rtrg0460",			-- ミッションクリア条件を満たしてヘリに乗った
	Radio_RideHeli_Failure				= "f0090_rtrg0130",			-- ミッションクリア条件を満たさずにヘリに乗った

	-- ゲームオーバー系
	Radio_GameOver_PlayerDead			= "f0033_gmov0010",
	Radio_GameOver_MissionArea			= "f0033_gmov0020",
	Radio_GameOver_Other				= "f0033_gmov0030",
	Radio_GameOver_PlayerRideHelicopter	= "f0033_gmov0040",
	Radio_GameOver_HelicopterDead		= "f0033_gmov0160",	-- ヘリ墜落（自分が乗っている）
	Radio_GameOver_PlayerDestroyHeli	= "f0033_gmov0120",
	Radio_GameOver_MissionFail			= "e0050_gmov0010",

	-- ゲームクリア系
	Radio_GameClear_Great				= "e0050_rtrg0144",
	Radio_GameClear_VeryGood			= "e0050_rtrg0143",
	Radio_GameClear_Good				= "e0050_rtrg0142",
	Radio_GameClear_Normal				= "e0050_rtrg0141",
	Radio_GameClear_Bad					= "e0050_rtrg0140",
	Radio_AfterGameClear				= "e0050_rtrg0150",

	-- チュートリアル系
	Radio_EquipC4						= "f0090_rtrg0520",
	Radio_PlaceC4						= "f0090_rtrg0521",

	--汎用無線
	Miller_DontSneakPhase				= "f0090_rtrg0110",	--キープコーション後、スニークフェイズに戻らない
	Miller_AlartAdvice					= "f0090_rtrg0230",	--0 アラート警告
	Miller_AlertToEvasion				= "f0090_rtrg0260",	--0 アラート後、エバージョンフェーズ
	Miller_ReturnToSneak				= "f0090_rtrg0270",	--0 スニークフェイズに戻った
	Miller_SpRecoveryLifeAdvice			= "f0090_rtrg0290",	--超体力回復促し
	Miller_RevivalAdvice				= "f0090_rtrg0280",	--体力戻った
	Miller_CuarAdvice					= "f0090_rtrg0300",	--キュア促し
	Miller_TargetOnHeli					= "f0090_rtrg0200",	--0 ターゲットをヘリで回収したら
	Miller_EnemyOnHeli					= "f0090_rtrg0210",	--0 ターゲット以外をヘリで回収したら
	Miller_HeliNoCall					= "f0090_rtrg0166",	-- ヘリを呼べない
	Miller_CallHeli01					= "f0090_rtrg0170",	--支援ヘリを呼んだ
	Miller_CallHeli02					= "f0090_rtrg0171",	--支援ヘリを呼んだ(ポイント変更)
--	Miller_BreakSuppressor				= "f0090_rtrg0530",	--サプレッサーが壊れた
	Miller_HeliDead						= "f0090_rtrg0220",	-- ヘリ撃墜
	Miller_HeliDeadSneak				= "f0090_rtrg0155",	-- プレイヤーがヘリ撃墜
	Miller_HeliAttack 					= "f0090_rtrg0225",	-- 支援ヘリがプレイヤーから攻撃を受けた
	Radio_HostageDead					= "f0090_rtrg0540",	-- 捕虜死亡（プレイヤー）
	Miller_CallHeliHot01				= "e0010_rtrg0376",	-- 支援ヘリ要請時/ホットゾーン
	Miller_CallHeliHot02				= "e0010_rtrg0377",	-- 支援ヘリ要請時/ホットゾーン
}

-- 任意無線
this.OptionalRadioList = {
	OptionalRadio_001					= "Set_e0050_oprg0010",	-- ミッション目的説明
	OptionalRadio_002					= "Set_e0050_oprg0015",	-- 装甲車登場から装甲車破壊まで
	OptionalRadio_003					= "Set_e0050_oprg0020",	-- ヘリに乗って脱出
}

-- 諜報無線
this.IntelRadioList = {

	-- 対空機関砲
	gntn_area01_antiAirGun_000			= "e0050_esrg0030",	-- 爆弾が有る時に対空機関砲を見た
	gntn_area01_antiAirGun_001			= "e0050_esrg0030",	-- 爆弾が有る時に対空機関砲を見た
	gntn_area01_antiAirGun_002			= "e0050_esrg0030",	-- 爆弾が有る時に対空機関砲を見た
	gntn_area01_antiAirGun_003			= "e0050_esrg0030",	-- 爆弾が有る時に対空機関砲を見た

	-- 乗り物系
	Armored_Vehicle_WEST_000			= "e0050_esrg0040",	-- 機銃装甲車を見た
	Tactical_Vehicle_WEST_000			= "e0050_esrg0053",	-- ビークルを見た
	Tactical_Vehicle_WEST_001			= "e0050_esrg0053",	-- ビークルを見た
	Cargo_Truck_WEST_000				= "e0050_esrg0051",	-- トラックを見た
	Cargo_Truck_WEST_001				= "e0050_esrg0051",	-- トラックを見た
	Cargo_Truck_WEST_002				= "e0050_esrg0051",	-- トラックを見た

	-- 背景系
	IntelRadio_WareHouse				= "e0050_esrg0060",	-- 倉庫を見た
	WoodTurret01						= "e0050_esrg0020",	-- 木製櫓を見た
	WoodTurret02						= "e0050_esrg0020",	-- 木製櫓を見た
	WoodTurret03						= "e0050_esrg0020",	-- 木製櫓を見た
	WoodTurret04						= "e0050_esrg0020",	-- 木製櫓を見た
	WoodTurret05						= "e0050_esrg0020",	-- 木製櫓を見た
--	IntelRadio_MetalTurret				= "e0050_esrg0025",	-- 金属櫓を見た

	-- NPC系
	Hostage_e20050_000					= "e0050_esrg0077",	-- カウントダウン前にHostage_e20050_000を見た
	Hostage_e20050_001					= "e0050_esrg0077",	-- カウントダウン前にHostage_e20050_001を見た
	Hostage_e20050_002					= "e0050_esrg0077",	-- カウントダウン前にHostage_e20050_002を見た
	Hostage_e20050_003					= "e0050_esrg0100",	-- カウントダウン前にHostage_e20050_003を見た

	-- 特殊系
	IntelRadio_Claymore					= "e0050_esrg0110",	-- 指向性地雷を見た

	-- 共通系
	intel_f0090_esrg0110				= "f0090_esrg0110", -- 収容施設
	intel_f0090_esrg0120				= "f0090_esrg0120", -- 難民キャンプ
	intel_f0090_esrg0130				= "f0090_esrg0130", -- 旧収容区画について
	intel_f0090_esrg0140				= "f0090_esrg0140", -- 管理棟
	intel_f0090_esrg0150				= "f0090_esrg0150", -- 運搬用ゲート（GZ)について
	intel_f0090_esrg0190				= "f0090_esrg0190", --
	intel_f0090_esrg0200				= "f0090_esrg0200", --

	--ドラム缶
	e20050_drum0002						= "f0090_esrg0180",
	e20050_drum0003						= "f0090_esrg0180",
	e20050_drum0004						= "f0090_esrg0180",
	gntnCom_drum0002					= "f0090_esrg0180",
	gntnCom_drum0005					= "f0090_esrg0180",
	gntnCom_drum0011					= "f0090_esrg0180",
	gntnCom_drum0012					= "f0090_esrg0180",
	gntnCom_drum0015					= "f0090_esrg0180",
	gntnCom_drum0019					= "f0090_esrg0180",
	gntnCom_drum0020					= "f0090_esrg0180",
	gntnCom_drum0021					= "f0090_esrg0180",
	gntnCom_drum0022					= "f0090_esrg0180",
	gntnCom_drum0023					= "f0090_esrg0180",
	gntnCom_drum0024					= "f0090_esrg0180",
	gntnCom_drum0025					= "f0090_esrg0180",
	gntnCom_drum0027					= "f0090_esrg0180",
	gntnCom_drum0028					= "f0090_esrg0180",
	gntnCom_drum0029					= "f0090_esrg0180",
	gntnCom_drum0030					= "f0090_esrg0180",
	gntnCom_drum0031					= "f0090_esrg0180",
	gntnCom_drum0035					= "f0090_esrg0180",
	gntnCom_drum0037					= "f0090_esrg0180",
	gntnCom_drum0038					= "f0090_esrg0180",
	gntnCom_drum0039					= "f0090_esrg0180",
	gntnCom_drum0040					= "f0090_esrg0180",
	gntnCom_drum0041					= "f0090_esrg0180",
	gntnCom_drum0042					= "f0090_esrg0180",
	gntnCom_drum0043					= "f0090_esrg0180",
	gntnCom_drum0044					= "f0090_esrg0180",
	gntnCom_drum0045					= "f0090_esrg0180",
	gntnCom_drum0046					= "f0090_esrg0180",
	gntnCom_drum0047					= "f0090_esrg0180",
	gntnCom_drum0048					= "f0090_esrg0180",
	gntnCom_drum0065					= "f0090_esrg0180",
	gntnCom_drum0066					= "f0090_esrg0180",
	gntnCom_drum0068					= "f0090_esrg0180",
	gntnCom_drum0069					= "f0090_esrg0180",
	gntnCom_drum0070					= "f0090_esrg0180",
	gntnCom_drum0071					= "f0090_esrg0180",
	gntnCom_drum0072					= "f0090_esrg0180",
	gntnCom_drum0101					= "f0090_esrg0180",

	--監視カメラ
	e20050_SecurityCamera_01			= "f0090_esrg0210",
	e20050_SecurityCamera_02			= "f0090_esrg0210",
	e20050_SecurityCamera_03			= "f0090_esrg0210",
	e20050_SecurityCamera_04			= "f0090_esrg0210",
	e20050_SecurityCamera_05			= "f0090_esrg0210",

	--ゲート開閉スイッチ
	intel_f0090_esrg0220				= "f0090_esrg0220",
}

-- 全ての諜報無線を有効にする
this.commonEnableAllIntelRadio = function()

	for i, value in pairs( this.IntelRadioList ) do
		TppRadio.EnableIntelRadio( value )
	end

end
-- 諜報無線セットアップ
this.SetIntelRadio = function()
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log("================== SetIntelRadio ====================== " .. sequence)

	-- 捕虜諜報可否判定
	this.commonIntelCheck("Hostage_e20050_000")
	this.commonIntelCheck("Hostage_e20050_001")
	this.commonIntelCheck("Hostage_e20050_002")
	this.commonIntelCheck("Hostage_e20050_003")

	if ( sequence == "Seq_DestroyTarget1" or sequence == "Seq_DestroyTarget2" ) then
		if TppMission.GetFlag( "isMissionBackgroundRadio4Played" ) == true then			-- ミッション背景無線その4を再生した
			TppRadio.RegisterIntelRadio( "Hostage_e20050_000", "e0050_esrg0078", true )
			TppRadio.RegisterIntelRadio( "Hostage_e20050_001", "e0050_esrg0079", true )
			TppRadio.RegisterIntelRadio( "Hostage_e20050_002", "e0050_esrg0080", true )
		else
			TppRadio.RegisterIntelRadio( "Hostage_e20050_000", "e0050_esrg0077", true )
			TppRadio.RegisterIntelRadio( "Hostage_e20050_001", "e0050_esrg0077", true )
			TppRadio.RegisterIntelRadio( "Hostage_e20050_002", "e0050_esrg0077", true )
		end

		TppRadio.RegisterIntelRadio( "Armored_Vehicle_WEST_000", "e0050_esrg0040", true )	-- 機銃装甲車
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_000", "e0050_esrg0053", true )	-- ビークル
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_001", "e0050_esrg0053", true )	-- ビークル
		TppRadio.RegisterIntelRadio( "Cargo_Truck_WEST_000", "e0050_esrg0051", true )		-- トラック
		TppRadio.RegisterIntelRadio( "Cargo_Truck_WEST_001", "e0050_esrg0051", true )		-- トラック
		TppRadio.RegisterIntelRadio( "Cargo_Truck_WEST_002", "e0050_esrg0051", true )		-- トラック
		TppRadio.RegisterIntelRadio( "IntelRadio_WareHouse", "e0050_esrg0060", true )		-- 武器庫
		TppRadio.RegisterIntelRadio( "WoodTurret01", "e0050_esrg0020", true )				-- 木製櫓
		TppRadio.RegisterIntelRadio( "WoodTurret02", "e0050_esrg0020", true )				-- 木製櫓
		TppRadio.RegisterIntelRadio( "WoodTurret03", "e0050_esrg0020", true )				-- 木製櫓
		TppRadio.RegisterIntelRadio( "WoodTurret04", "e0050_esrg0020", true )				-- 木製櫓
		TppRadio.RegisterIntelRadio( "WoodTurret05", "e0050_esrg0020", true )				-- 木製櫓

		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0110", "f0090_esrg0110", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0120", "f0090_esrg0120", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0130", "f0090_esrg0130", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0140", "f0090_esrg0140", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0150", "f0090_esrg0150", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0190", "f0090_esrg0190", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0200", "f0090_esrg0200", true )

		TppRadio.EnableIntelRadio( "e20050_drum0002" )
		TppRadio.EnableIntelRadio( "e20050_drum0003" )
		TppRadio.EnableIntelRadio( "e20050_drum0004" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0002" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0005" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0011" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0012" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0015" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0019" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0020" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0021" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0022" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0023" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0024" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0025" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0027" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0028" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0029" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0030" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0031" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0035" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0037" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0038" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0039" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0040" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0041" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0042" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0043" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0044" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0045" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0046" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0047" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0048" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0065" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0066" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0068" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0069" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0070" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0071" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0072" )
		TppRadio.EnableIntelRadio( "e20050_drum0004" )
		TppRadio.EnableIntelRadio( "gntnCom_drum0101" )
		TppRadio.RegisterIntelRadio( "e20050_drum0002", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "e20050_drum0003", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "e20050_drum0004", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0002", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0005", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0011", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0012", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0015", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0019", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0020", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0021", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0022", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0023", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0024", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0025", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0027", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0028", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0029", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0030", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0031", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0035", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0037", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0038", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0039", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0040", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0041", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0042", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0043", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0044", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0045", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0046", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0047", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0048", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0065", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0066", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0068", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0069", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0070", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0071", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0072", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "e20050_drum0004", "f0090_esrg0180" )	-- ドラム缶
		TppRadio.RegisterIntelRadio( "gntnCom_drum0101", "f0090_esrg0180" )	-- ドラム缶
	end
	if ( sequence == "Seq_DestroyTarget1" ) then
		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_000", "e0050_esrg0030", true )
		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_001", "e0050_esrg0030", true )
		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_002", "e0050_esrg0030", true )
		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_003", "e0050_esrg0030", true )
	elseif ( sequence == "Seq_DestroyTarget2" ) then	-- 装甲車戦
		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_000", "e0050_esrg0033", true )
		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_001", "e0050_esrg0033", true )
		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_002", "e0050_esrg0033", true )
		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_003", "e0050_esrg0033", true )
	else -- 空爆開始
		if TppMission.GetFlag( "isHostage0003Talk2Played" ) == true then	-- MB諜報員担ぎ会話を聴いていたら
			TppRadio.RegisterIntelRadio( "Hostage_e20050_000", "e0050_esrg0091", true )	-- カウントダウン後にHostage_e20050_000を見た
			TppRadio.RegisterIntelRadio( "Hostage_e20050_001", "e0050_esrg0091", true )	-- カウントダウン後にHostage_e20050_001を見た
			TppRadio.RegisterIntelRadio( "Hostage_e20050_002", "e0050_esrg0091", true )	-- カウントダウン後にHostage_e20050_002を見た
		else															-- MB諜報員担ぎ会話を聴いていなかったら
			TppRadio.RegisterIntelRadio( "Hostage_e20050_000", "e0050_esrg0082", true )	-- カウントダウン後にHostage_e20050_000を見た
			TppRadio.RegisterIntelRadio( "Hostage_e20050_001", "e0050_esrg0083", true )	-- カウントダウン後にHostage_e20050_001を見た
			TppRadio.RegisterIntelRadio( "Hostage_e20050_002", "e0050_esrg0084", true )	-- カウントダウン後にHostage_e20050_002を見た
		end

		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_000", "e0050_esrg9000", true )	-- 対空機関砲
		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_001", "e0050_esrg9000", true )	-- 対空機関砲
		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_002", "e0050_esrg9000", true )	-- 対空機関砲
		TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_003", "e0050_esrg9000", true )	-- 対空機関砲
		TppRadio.RegisterIntelRadio( "Armored_Vehicle_WEST_000", "e0050_esrg9000", true )		-- 機銃装甲車
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_000", "e0050_esrg9000", true )	-- ビークル
		TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_001", "e0050_esrg9000", true )	-- ビークル
		TppRadio.RegisterIntelRadio( "Cargo_Truck_WEST_000", "e0050_esrg9000", true )			-- トラック
		TppRadio.RegisterIntelRadio( "Cargo_Truck_WEST_001", "e0050_esrg9000", true )			-- トラック
		TppRadio.RegisterIntelRadio( "Cargo_Truck_WEST_002", "e0050_esrg9000", true )			-- トラック
		TppRadio.RegisterIntelRadio( "IntelRadio_WareHouse", "e0050_esrg9000", true )			-- 武器庫
		TppRadio.RegisterIntelRadio( "WoodTurret01", "e0050_esrg9000", true )					-- 木製櫓
		TppRadio.RegisterIntelRadio( "WoodTurret02", "e0050_esrg9000", true )					-- 木製櫓
		TppRadio.RegisterIntelRadio( "WoodTurret03", "e0050_esrg9000", true )					-- 木製櫓
		TppRadio.RegisterIntelRadio( "WoodTurret04", "e0050_esrg9000", true )					-- 木製櫓
		TppRadio.RegisterIntelRadio( "WoodTurret05", "e0050_esrg9000", true )					-- 木製櫓

		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0110", "e0050_esrg9000", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0120", "e0050_esrg9000", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0130", "e0050_esrg9000", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0140", "e0050_esrg9000", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0150", "e0050_esrg9000", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0190", "e0050_esrg9000", true )
		TppRadio.RegisterIntelRadio( "intel_f0090_esrg0200", "e0050_esrg9000", true )

		TppRadio.DisableIntelRadio( "e20050_drum0002" )
		TppRadio.DisableIntelRadio( "e20050_drum0003" )
		TppRadio.DisableIntelRadio( "e20050_drum0004" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0002" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0005" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0011" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0012" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0015" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0019" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0020" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0021" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0022" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0023" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0024" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0025" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0027" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0028" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0029" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0030" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0031" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0035" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0037" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0038" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0039" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0040" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0041" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0042" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0043" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0044" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0045" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0046" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0047" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0048" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0065" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0066" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0068" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0069" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0070" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0071" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0072" )
		TppRadio.DisableIntelRadio( "e20050_drum0004" )
		TppRadio.DisableIntelRadio( "gntnCom_drum0101" )
	end
end

-- 壊したフラグとCharacterIDの組み合わせを定義
this.destroyFlagMap = {
	Armored_Vehicle_WEST_000	= "isArmoredVehicle0000Destroyed",
	Cargo_Truck_WEST_000		= "isTruck0000Destroyed",
	Cargo_Truck_WEST_001		= "isTruck0001Destroyed",
	Cargo_Truck_WEST_002		= "isTruck0002Destroyed",
	Tactical_Vehicle_WEST_000	= "isVehicle0000Destroyed",
	Tactical_Vehicle_WEST_001	= "isVehicle0001Destroyed",
	gntn_area01_antiAirGun_000	= "isAntiAirGun0000Destroyed",
	gntn_area01_antiAirGun_001	= "isAntiAirGun0001Destroyed",
	gntn_area01_antiAirGun_002	= "isAntiAirGun0002Destroyed",
	gntn_area01_antiAirGun_003	= "isAntiAirGun0003Destroyed",
	WoodTurret01				= "isWoodTurret0000Destroyed",
	WoodTurret02				= "isWoodTurret0001Destroyed",
	WoodTurret03				= "isWoodTurret0002Destroyed",
	WoodTurret04				= "isWoodTurret0003Destroyed",
	WoodTurret05				= "isWoodTurret0004Destroyed",
}

-- 指定されたキャラクターIDが壊されたフラグを立てる
this.commonSetDestroyFlag = function( characterId )

	TppMission.SetFlag( this.destroyFlagMap[characterId], true )

end

this.commonGetDestroyFlag = function( characterId )

	return TppMission.GetFlag( this.destroyFlagMap[ characterId ] )

end

-- マーカーID配列
-- 添え字でCharacterIDを指定してマーカーIDを引き出す
-- マーカーIDとCharacterIDの間に一定の規則が無いので直打ち
this.markerIds = {
	Armored_Vehicle_WEST_000	= "Armored_Vehicle_WEST_000",
	gntn_area01_antiAirGun_000	= "gntn_area01_antiAirGun_000",
	gntn_area01_antiAirGun_001	= "gntn_area01_antiAirGun_001",
	gntn_area01_antiAirGun_002	= "gntn_area01_antiAirGun_002",
	gntn_area01_antiAirGun_003	= "gntn_area01_antiAirGun_003",
	WoodTurret01				= "20050_marker_WoodTurret000",
	WoodTurret02				= "20050_marker_WoodTurret001",
	WoodTurret03				= "20050_marker_WoodTurret002",
	WoodTurret04				= "20050_marker_WoodTurret003",
	WoodTurret05				= "20050_marker_WoodTurret004",
}

-- マーカー全部表示
this.commonEnableAllMarker = function()

	-- 全てのマーカーを有効にする
	for i, value in pairs( markerIds ) do
		this.commonEnableMarker( value )
	end

end

-- マーカー全部非表示
this.commonDisableAllMarker = function()

	-- 全てのマーカーを無効にする
	for i, value in pairs( this.markerIds ) do
		TppMarkerSystem.DisableMarker{ markerId = value }
	end

end

-- CharacterIDで指定されたマーカーを表示
this.commonEnableMarker = function( characterId )

	TppMarkerSystem.EnableMarker{ markerId = this.markerIds[characterId], viewType = {"VIEW_MAP_ICON","VIEW_WORLD_ICON"} }
	TppMarkerSystem.SetMarkerImportant{ markerId = this.markerIds[characterId], isImportant = true }
	TppMarkerSystem.SetMarkerNew{ markerId = this.markerIds[characterId], isNew = true }
	-- TppMarkerSystem.SetMarkerGoalType{ markerId = this.markerIds[characterId], goalType="GOAL_ATTACK" }

end

-- CharacterIDで指定されたマーカーを非表示にする
this.commonDisableMarker = function( characterId )

	Fox.Log( "e20050_sequence.commonDisableMarker(" .. characterId .. ")" )
	TppMarkerSystem.DisableMarker{ markerId = this.markerIds[characterId] }

end

-- 生きている対空機関砲の数を数える
this.commonCountAliveAntiAirGun = function()

	local count = 0
	for i, characterId in ipairs( this.antiAirGuns ) do
		if this.commonGetDestroyFlag( characterId ) == false then
			count = count + 1
		end
	end
	return count

end

this.commonCountAliveTower = function()

	local count = 0
	for i, characterId in ipairs( this.towers ) do
		if this.commonGetDestroyFlag( characterId ) == false then
			count = count + 1
		end
	end
	return count

end

-- 指定したcharacterIdがターゲットに含まれているかどうかを返す
this.commonIsTarget = function( characterId )

	local sequence = TppSequence.GetCurrentSequence()
	if sequence == "Seq_DestroyTarget1" then
		for i, antiAirGunCharacterId in ipairs( this.antiAirGuns ) do
			if characterId == antiAirGunCharacterId then
				return true
			end
		end
	elseif sequence == "Seq_DestroyTarget2" then
		if characterId == "Armored_Vehicle_WEST_000" then
			return true
		end
	end

	return false

end

-- CharacterIdとアナウンスログの組み合わせ定義
this.destroyAnnounceLogMap = {
	gntn_area01_antiAirGun_000	= "announce_destroy_AntiAirCraftGun",
	gntn_area01_antiAirGun_001	= "announce_destroy_AntiAirCraftGun",
	gntn_area01_antiAirGun_002	= "announce_destroy_AntiAirCraftGun",
	gntn_area01_antiAirGun_003	= "announce_destroy_AntiAirCraftGun",
	WoodTurret01				= "announce_destroy_tower",
	WoodTurret02				= "announce_destroy_tower",
	WoodTurret03				= "announce_destroy_tower",
	WoodTurret04				= "announce_destroy_tower",
	WoodTurret05				= "announce_destroy_tower",
	Armored_Vehicle_WEST_000	= "announce_destroy_APC",
}

-- characterIdに対応したアナウンスログを取得
this.commonGetDestroyAnnounceLogId = function( characterId )

	return this.destroyAnnounceLogMap[ characterId ]

end

-- フラグを元にルート設定を再現する
-- フラグが変更された時に呼ばれるべき（例えば、物が壊れたとかの時）
-- ルート関連の設定が分散してカオスになるのを防ぐために全部まとめる
-- もしも処理負荷的に問題ありそうだったら関数を分けて個別に呼び出すようにする
this.commonRestoreRoute = function()

	-- 捕虜収容所に乗りつけるビークル乗員のルートを再構築
	if TppMission.GetFlag( "isFinishLightVehicleGroup" ) == true then							-- ビークルの車両連携が終了していたら
		-- ドライバーをルートチェンジさせる
		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0049", "e20050_c01_route0014" )
		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0049", "e20050_c01_route0015" )
		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c02_route0049", "e20050_c02_route0035" )
		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c02_route0049", "e20050_c02_route0036" )
	else																						-- 車両連携が終了していなかったら
		-- 捕虜収容所の警戒ルートを無効に
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0049", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0049", { noForceUpdate = false, }  )
	end

	if this.commonGetDestroyFlag( "gntn_area01_antiAirGun_000" ) == true then					-- 対空機関砲0000が壊れていたら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0065", { noForceUpdate = false, }  )	-- 対空機関砲周辺の警戒ルートを無効にする
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0051", { noForceUpdate = false, }  )		-- 対空機関砲周辺の警戒ルートを有効にする
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0052", { noForceUpdate = false, }  )		-- 対空機関砲周辺の警戒ルートを有効にする
	else																						-- 壊れていなかったら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0051", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0052", { noForceUpdate = false, }  )
	end

	if this.commonGetDestroyFlag( "gntn_area01_antiAirGun_001" ) == true then					-- 対空機関砲0001が壊れていたら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0002", { noForceUpdate = false, }  )	-- 対空機関砲周辺の警戒ルートを無効にする
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0003", { noForceUpdate = false, }  )	-- 対空機関砲周辺の警戒ルートを無効にする
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0053", { noForceUpdate = false, }  )		-- 対空機関砲周辺の警戒ルートを有効にする
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0054", { noForceUpdate = false, }  )		-- 対空機関砲周辺の警戒ルートを有効にする
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0055", { noForceUpdate = false, }  )		-- 対空機関砲周辺の警戒ルートを有効にする
	else																						-- 壊れていなかったら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0053", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0054", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0055", { noForceUpdate = false, }  )
	end

	if this.commonGetDestroyFlag( "gntn_area01_antiAirGun_002" ) == true then					-- 対空機関砲0002が壊れていたら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0005", { noForceUpdate = false, }  )	-- 対空機関砲周辺の警戒ルートを無効にする
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0061", { noForceUpdate = false, }  )	-- 対空機関砲周辺の警戒ルートを無効にする
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0062", { noForceUpdate = false, }  )		-- 対空機関砲周辺の警戒ルートを有効にする
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0063", { noForceUpdate = false, }  )		-- 対空機関砲周辺の警戒ルートを有効にする
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0064", { noForceUpdate = false, }  )		-- 対空機関砲周辺の警戒ルートを有効にする
	else																						-- 壊れていなかったら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0062", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0063", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0064", { noForceUpdate = false, }  )
	end

	if this.commonGetDestroyFlag( "gntn_area01_antiAirGun_003" ) == true then					-- 対空機関砲0003が壊れていたら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0006", { noForceUpdate = false, }  )	-- 対空機関砲周辺の警戒ルートを無効にする
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0057", { noForceUpdate = false, }  )	-- 対空機関砲周辺の警戒ルートを無効にする
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0058", { noForceUpdate = false, }  )		-- 対空機関砲周辺の警戒ルートを有効にする
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0059", { noForceUpdate = false, }  )		-- 対空機関砲周辺の警戒ルートを有効にする
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0060", { noForceUpdate = false, }  )		-- 対空機関砲周辺の警戒ルートを有効にする
	else																						-- 壊れていなかったら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0058", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0059", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0060", { noForceUpdate = false, }  )
	end

	if this.commonGetDestroyFlag( "WoodTurret01" ) == true then									-- 木製櫓0001が壊れていたら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0006", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0044", { noForceUpdate = false, }  )
	else																						-- 壊れていなかったら
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c01_route0006", { noForceUpdate = false, }  )
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0044", { noForceUpdate = false, }  )
	end

	if this.commonGetDestroyFlag( "WoodTurret02" ) == true then									-- 木製櫓0002が壊れていたら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0007", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0045", { noForceUpdate = false, }  )
	else																						-- 壊れていなかったら
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c01_route0007", { noForceUpdate = false, }  )
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0045", { noForceUpdate = false, }  )
	end

	if this.commonGetDestroyFlag( "WoodTurret03" ) == true then									-- 木製櫓0003が壊れていたら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0009", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0047", { noForceUpdate = false, }  )
	else																						-- 壊れていなかったら
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c01_route0009", { noForceUpdate = false, }  )
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0047", { noForceUpdate = false, }  )
	end

	if this.commonGetDestroyFlag( "WoodTurret04" ) == true then									-- 木製櫓0004が壊れていたら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0005", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0048", { noForceUpdate = false, }  )
	else																						-- 壊れていなかったら
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c01_route0005", { noForceUpdate = false, }  )
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0048", { noForceUpdate = false, }  )
	end

	if this.commonGetDestroyFlag( "WoodTurret05" ) == true then									-- 木製櫓0005が壊れていたら
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0008", { noForceUpdate = false, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c02_route0046", { noForceUpdate = false, }  )
	else																						-- 壊れていなかったら
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c01_route0008", { noForceUpdate = false, }  )
		TppEnemy.EnableRoute( this.CP_ID, "e20050_c02_route0046", { noForceUpdate = false, }  )
	end

end

this.photoIdMap = {
	gntn_area01_antiAirGun_000 = 10,
	gntn_area01_antiAirGun_001 = 40,
	gntn_area01_antiAirGun_002 = 30,
	gntn_area01_antiAirGun_003 = 20,
}

this.commonSetCompleteMissionPhotoId = function( characterId )

	local commonDataManager = UiCommonDataManager.GetInstance()
	if commonDataManager ~= NULL then
		local luaData = commonDataManager:GetUiLuaExportCommonData()
		if luaData ~= NULL then

			local photoId = this.photoIdMap[characterId]
			if photoId ~= 0 then
				luaData:SetCompleteMissionPhotoId(photoId, true)
			end

		end
	end

end

-- 何かを壊した
this.commonDestroyObject = function( characterId )

	-- 壊れ汎用処理
	local hudCommonData = HudCommonDataManager.GetInstance()								-- とりあえずマネージャーを取得
	TppRadio.DisableIntelRadio( characterId )												-- 壊せるものには諜報無線が付いているはずなので諜報無線を無効にする
	this.commonSetDestroyFlag( characterId )												-- 壊せるものには壊したフラグが存在しているはずなので壊したフラグを立てる
	local announceLogId = this.commonGetDestroyAnnounceLogId( characterId )					-- characterIdに対応したアナウンスログのIDを取得
	if announceLogId ~= nil then															-- アナウンスログIDが存在すれば
		if announceLogId == "announce_destroy_tower" then										-- 対象が櫓なら
			if PlayRecord.IsMissionChallenge( "GUARDTOWER_DESTROY" ) == true then					-- チャンレンジ中なら
				local targetNum = this.commonCountAliveTower()
				local maxTargetNum = 5
				hudCommonData:AnnounceLogViewLangId( announceLogId, targetNum, maxTargetNum )			-- アナウンスログ表示。目標達成 [ targetNum / maxTargetNum ]
			end
		elseif announceLogId == "announce_destroy_AntiAirCraftGun" then							-- 対象が対空機関砲なら
			if TppSequence.GetCurrentSequence() == "Seq_DestroyTarget1" then
			hudCommonData:AnnounceLogViewLangId( announceLogId )									-- 破壊されたcharacterIdに対応したアナウンスログを表示
			end
		else																					-- それ以外なら
			hudCommonData:AnnounceLogViewLangId( announceLogId )									-- 破壊されたcharacterIdに対応したアナウンスログを表示
		end
	end

	if characterId == "WoodTurret01" then

	elseif characterId == "WoodTurret02" then
		TppCommandPostObject.GsAddDisabledRoutes( this.CP_ID, "e20050_c01_route0007" )
		TppCommandPostObject.GsAddDisabledRoutes( this.CP_ID, "e20050_c02_route0045" )
	elseif characterId == "WoodTurret03" then
		TppCommandPostObject.GsAddDisabledRoutes( this.CP_ID, "e20050_c01_route0009" )
		TppCommandPostObject.GsAddDisabledRoutes( this.CP_ID, "e20050_c02_route0047" )
	elseif characterId == "WoodTurret04" then
		TppCommandPostObject.GsAddDisabledRoutes( this.CP_ID, "e20050_c01_route0005" )
		TppCommandPostObject.GsAddDisabledRoutes( this.CP_ID, "e20050_c02_route0048" )
	elseif characterId == "WoodTurret05" then
		TppCommandPostObject.GsAddDisabledRoutes( this.CP_ID, "e20050_c01_route0008" )
		TppCommandPostObject.GsAddDisabledRoutes( this.CP_ID, "e20050_c02_route0046" )
	end

	-- 壊れたものがターゲットだったらターゲット用処理
	if this.commonIsTarget( characterId ) then																-- 壊したものがターゲットなら

		this.commonDisableMarker( characterId )																	-- ターゲットにはマーカーが付いているはずなのでマーカーを無効にする
		this.commonSetCompleteMissionPhotoId( characterId )														-- ターゲットの写真を完了に変更

	end

	-- フェイズを変更
	if TppMission.GetFlag( "isAntiAirRouteSet" ) == false then												-- まだkeep cautionになっていなかったら
		this.commonSetPhaseToKeepCaution( false )																		-- keep cautionにする
		TppMission.SetFlag( "isAntiAirRouteSet", true )															-- keep cautionになった事を記録
	end

	if TppMission.GetFlag( "isAntiLandRouteSet" ) == false then												-- アラートになった事があるフラグが立っていなかったら
		this.commonChangeToAntiLandRouteSet( false )																	-- 警戒ルートセットを変更する
		TppMission.SetFlag( "isAntiLandRouteSet", true )														-- アラートになった事があるフラグを立てる
	end

	-- ルートセット変更
	TppEnemy.ChangeRouteSet( this.CP_ID, "e20050_route_c02", { forceUpdate = true, forceReload = true } )	-- ルートセットを地上警戒に変更する

	-- チャレンジ要素判定
	if	this.commonGetDestroyFlag( "WoodTurret01" ) == true and												-- 木製櫓0001を壊し、かつ、
		this.commonGetDestroyFlag( "WoodTurret02" ) == true and												-- 木製櫓0002を壊し、かつ、
		this.commonGetDestroyFlag( "WoodTurret03" ) == true and												-- 木製櫓0003を壊し、かつ、
		this.commonGetDestroyFlag( "WoodTurret04" ) == true and												-- 木製櫓0004を壊し、かつ、
		this.commonGetDestroyFlag( "WoodTurret05" ) == true then											-- 木製櫓0005を壊していたら

		local tower = PlayRecord.IsMissionChallenge( "GUARDTOWER_DESTROY" )
		if tower == true then

			local hardmode = TppGameSequence.GetGameFlag("hardmode")	-- 現在の難易度を取得
			if hardmode == true then									-- 難易度がハードだったら
				PlayRecord.RegistPlayRecord( "GUARDTOWER_DESTROY" )			-- チャンレンジ要素達成を記録
				-- Trophy.TrophyUnlock( 12 )								-- トロフィー・実績「チャレンジ項目を一つでも達成した」
			else														-- 難易度がノーマルだったら
			end

		end

	end

	-- 最後にルートが変更されているかもしれないのでルート再設定
	this.commonRestoreRoute()																				-- ルートを再設定

end

-- 捕虜騒ぎトラップに入った
this.commonOnPlayerEnterHostageTrap = function()

	local trapBodyHandle = TppData.GetArgument(3)
	local trapName = trapBodyHandle.data.name

	if trapName == "Trap_HostageCallHelp1" then									-- 捕虜会話0000用トラップに入ったら

		for i, characterId in ipairs( this.hostages ) do
			if	characterId ~= this.CHARACTER_ID_MB_AGENT and
				this.commonIsHostageMonologuePlayed( characterId ) == false then

				if characterId == "Hostage_e20050_001" then
					TppHostageManager.GsSetStruggleVoice( characterId, "POWV_0270" )	-- 捕虜の騒ぎ音声を設定
				else
					TppHostageManager.GsSetStruggleVoice( characterId, "POWV_0260" )	-- 捕虜の騒ぎ音声を設定
				end
				if this.commonIsHostageDoorOpened( characterId ) == false then
					TppHostageManager.GsSetStruggleFlag( characterId, true )			-- 捕虜を暴れさせる
				end

			end
		end

	elseif trapName == "Trap_HostageCallHelp2" then								-- 捕虜会話0001用トラップに入ったら

		if TppMission.GetFlag( "isHostageDialogue0001Played" ) == false then	-- まだ捕虜会話0001が流れていなかったら

			TppMission.SetFlag( "isHostageDialogue0001Played", true )			-- 捕虜会話0001を流した事にする
			-- TppRadio.PlayDebug( "Radio_HostageCallHelp2" )					-- 捕虜会話0001を流す

		end

	elseif trapName == "Trap_HostageCallHelp3" then

		if	TppSequence.GetCurrentSequence() == "Seq_CallSupportHelicopter" or	-- 現在のシーケンスがヘリ呼び出しシーケンス、または、
			TppSequence.GetCurrentSequence() == "Seq_Escape" then				-- 現在のシーケンスが脱出シーケンスだったら

			-- 車を出現させる
			TppData.Enable( "Tactical_Vehicle_WEST_000" )

			-- ドライバーを出現させる
			TppData.Enable( "e20050_uss_driver0002" )
			TppData.Enable( "e20050_uss_driver0003" )

			-- ドライバーのリアライズ優先度を上げる
			-- TppCommandPostObject.GsSetRealizeFirstPriorityByRoute( this.CP_ID, "e20050_c01_route_rideLightVehicle0000", true )

		end

	end

end

-- 捕虜騒ぎトラップから出た
this.commonOnPlayerLeaveHostageTrap = function()

	local trapBodyHandle = TppData.GetArgument(3)
	local trapName = trapBodyHandle.data.name

	if trapName == "Trap_HostageCallHelp1" then								-- 捕虜会話0000用トラップから出たら
		TppHostageManager.GsSetStruggleFlag( "Hostage_e20050_000", false )		-- 捕虜を暴れさせるのを解除
		TppHostageManager.GsSetStruggleFlag( "Hostage_e20050_001", false )		-- 捕虜を暴れさせるのを解除
		TppHostageManager.GsSetStruggleFlag( "Hostage_e20050_002", false )		-- 捕虜を暴れさせるのを解除
	end

end

-- 捕虜会話続き
this.commonOnFinishHostageDialogue1 = function()

	-- TODO:警戒立ち話の対応が入るまで仮字幕で対応。音声出ないよ！
	SubtitlesCommand.Display( "PRSN1000_1u1210", "Default" )	-- 捕虜助けてくれ会話その2を流す
	GkEventTimerManager.Start( "Timer_WaitHostageDialogue2", 6.5 )

end

-- 捕虜会話続き2
this.commonOnFinishHostageDialogue2 = function()

	-- TODO:警戒立ち話の対応が入るまで仮字幕で対応。音声出ないよ！
	SubtitlesCommand.Display( "PRSN1000_1u1110", "Default" )	-- 捕虜助けてくれ会話その3を流す
	GkEventTimerManager.Start( "Timer_WaitHostageDialogue3", 6.5 )

end

this.CHARACTER_ID_MB_AGENT = "Hostage_e20050_003"
this.hostages = {
	"Hostage_e20050_000",
	"Hostage_e20050_001",
	"Hostage_e20050_002",
	this.CHARACTER_ID_MB_AGENT,
}

this.hostageRescueFlagMap = {}
for i, characterId in ipairs( this.hostages ) do
	this.hostageRescueFlagMap[ characterId ] = characterId .. "isRescued"
end

for characterId, flagName in pairs( this.hostageRescueFlagMap ) do
	this.MissionFlagList[ flagName ] = false
end

this.commonSetHostageRescued = function( characterId )

	TppMission.SetFlag( this.hostageRescueFlagMap[ characterId ], true )	-- 助けたフラグを設定
	local hudCommonData = HudCommonDataManager.GetInstance()				-- とりあえずマネージャーを取得
	GZCommon.NormalHostageRecovery( characterId )

	if characterId == this.CHARACTER_ID_MB_AGENT then						-- MB諜報員だったら
		PlayRecord.PlusExternalScore( 6500 )									-- ボーナス
		TppRadio.Play( "Miller_TargetOnHeli" )									-- 捕虜を回収した無線を流す
	else																	-- それ以外（通常捕虜か敵兵）だったら
		TppRadio.Play( "Miller_EnemyOnHeli" )									-- 捕虜を回収した無線を流す
	end

end

this.commonIsHostage = function( characterId )

	for i, hostageCharacterId in ipairs( this.hostages ) do
		if hostageCharacterId == characterId then
			return true
		end
	end

	return false

end

this.commonIsHostageRescued = function( characterId )

	return TppMission.GetFlag( this.hostageRescueFlagMap[ characterId ] )

end

this.commonIsAllHostageRescued = function()

	for i, characterId in pairs( this.hostages ) do
		if this.commonIsHostageRescued( characterId ) == false then
			return false
		end
	end

	return true

end

-- 捕虜をヘリに乗せた
this.commonOnLaidHostage = function()

	local characterId = TppData.GetArgument(1)
	local vehicle = TppData.GetArgument(2)
	local vehicleId = TppData.GetArgument(3)

	if vehicleId == this.CHARACTER_ID_HELICOPTER then

		if this.commonIsHostage( characterId ) == true and TppHostageUtility.GetStatus( characterId ) ~= "Dead" then

			this.commonSetHostageRescued( characterId )			-- 捕虜を助けた設定

			if	this.commonIsAllHostageRescued() == true then	-- 全ての捕虜を助けていたら
				Trophy.TrophyUnlock( 8 )							-- 捕虜を全て助けた実績・トロフィー解除（重複して解除するのは問題無いらしい）
			end

		end

	end

end
-- 捕虜をキルした
this.commonOnDeadHostage = function()

	Fox.Log( "commonOnDeadHostage" )
	local HostageCharacterID	= TppData.GetArgument(1)
	local PlayerDead			= TppData.GetArgument(4)
	-- 無線
	if( PlayerDead == true ) then
		TppRadio.DelayPlay( "Radio_HostageDead", "mid" )
	end
	TppRadio.DisableIntelRadio( HostageCharacterID )
end
-- ■ commonIntelCheck
this.commonIntelCheck = function( CharacterID )
	Fox.Log("--------commonIntelCheck--------")
	local status = TppHostageUtility.GetStatus( CharacterID )
	if status == "Dead" then
		TppRadio.DisableIntelRadio( CharacterID )
	else
		TppRadio.EnableIntelRadio( CharacterID )
	end
end
-- 敵兵を乗り物に乗せた
this.commonOnLaidEnemy = function()

	local characterId = TppData.GetArgument(1)
	local vehicle = TppData.GetArgument(2)
	local vehicleId = TppData.GetArgument(3)

	if vehicleId == this.CHARACTER_ID_HELICOPTER then
		TppRadio.Play( "Miller_EnemyOnHeli" )
	end

end

this.commonOnEnterWareHouse000 = function()

	TppMarker.Disable( "20050_marker_weapon000" )

end

this.commonOnEnterWareHouse001 = function()

	TppMarker.Disable( "20050_marker_weapon001" )

end

-- デモブロックをロードする
this.commonLoadDemoBlock = function()

	TppMission.LoadDemoBlock( "/Assets/tpp/pack/mission/extra/e20050/e20050_d01.fpk" )	-- デモブロックをロードする
	TppMission.LoadEventBlock("/Assets/tpp/pack/location/gntn/gntn_heli.fpk" )			-- HeliBlockをロードする

end

-- プレイヤーがヘリに乗った
this.commonOnPlayerRideHelicopter = function()

	-- ヘリに乗った無線を流す
	if this.commonGetDestroyFlag( "Armored_Vehicle_WEST_000" ) == true then				-- 機銃装甲車を破壊していたら

		TppRadio.Play( "Radio_RideHeli_Clear" )												-- クリア条件を満たしてヘリに乗った無線を流す
		TppSequence.ChangeSequence( "Seq_PlayerRideHelicopter" )							-- ヘリ乗ったシーケンスに遷移

		-- クリア確定の場合、デモにつなぐためにSIMを無効にする
		SimDaemon.SetForceSimNotActiveMode( 20.0 )

	else																				-- 破壊していなかったら

		TppRadio.DelayPlay( "Radio_RideHeli_Failure", "mid" )								-- クリア条件を満たさずにヘリに乗った無線を流す
		TppSupportHelicopterService.SetEnableGetOffTime( GZCommon.WaitTime_HeliTakeOff )	-- 離陸を少し待つ

	end

end

this.commonOnHelicopterDeparture = function()

	local characterId = TppData.GetArgument( 1 )
	this.CounterList.lastRendezvouzPoint = TppData.GetArgument( 2 )
	local playerRiding = TppData.GetArgument( 3 )

	if	characterId == this.CHARACTER_ID_HELICOPTER and
		playerRiding == true then

		if this.commonGetDestroyFlag( "Armored_Vehicle_WEST_000" ) == false then
			-- GkEventTimerManager.Start( "Timer_CloseDoor", 5 )				-- 一応クリアしないか待ってみる
		end

	end

end

-- プレイヤーに攻撃された
this.commonHeliDamagedByPlayer = function()

	local radioDaemon = RadioDaemon:GetInstance()
	if ( radioDaemon:IsPlayingRadio() == false ) then
		--無線の種類に問わず再生中でなければ
		TppRadio.PlayEnqueue( "Miller_HeliAttack" )
	end

end

-- ヘリがデモ地点に到達した
this.commonOnHelicopterReachDemoPoint = function()

	if this.commonGetDestroyFlag( "Armored_Vehicle_WEST_000" ) == true then	-- 機銃装甲車を破壊していたら

		-- スコア計算テーブルの設定
		GZCommon.ScoreRankTableSetup( this.missionID )

		TppMission.ChangeState( "clear", "RideHeli_Clear" )						-- クリアした事にする

	else																	-- 破壊していなかったら

		this.CounterList.HeliReachDemoCount = this.CounterList.HeliReachDemoCount + 1
		if	TppSequence.GetCurrentSequence() == "Seq_DestroyTarget1" or
			this.CounterList.HeliReachDemoCount > 1 then

			TppMission.ChangeState( "failed", "RideHelicopter" )					-- ミッション失敗

		end

	end

end

this.commonOnBeforeHelicopterReachDemoPoint = function()

	if	this.commonGetDestroyFlag( "Armored_Vehicle_WEST_000" ) == true or	-- 機銃装甲車を破壊していたら
		this.CounterList.HeliReachDemoCount > 0 then						-- 2周目だったら

		TppSupportHelicopterService.SetEnableLeanOut( false )						-- プレイヤーをヘリの中に引っ込める

	end

end

-- ヘリのドア閉める
this.commonCloseHelicopterDoor = function()

	TppSupportHelicopterService.CloseLeftDoor()		-- ヘリの左ドアを閉じる
	TppSupportHelicopterService.CloseRightDoor()	-- ヘリの右ドアを閉じる

	-- GkEventTimerManager.Start( "Timer_CloseDoor", 5 )			-- ヘリのドアが閉まるのを待つ

end

-- ミッション失敗にしたいタイミングで実行する
this.commonFailMission = function()

	TppMission.ChangeState( "failed", "RideHelicopter" )					-- ミッション失敗

end

-- プレイヤーが乗り物（ヘリ含む）に乗った
this.commonOnPlayerRideVehicle = function()
	local VehicleID = TppData.GetArgument(2)
	if VehicleID == "SupportHelicopter" then
		--
	else
		if VehicleID == "LightVehicle" then
			TppRadio.Play("Miller_CarRideAdviceJeep")
		end
--		if( TppMission.GetFlag( "isCarTutorial" ) == false ) then				--乗り物チュートリアルボタンを表示していないなら
			-- RT アクセルボタン
			local hudCommonData = HudCommonDataManager.GetInstance()
			hudCommonData:CallButtonGuide( "tutorial_accelarater", "VEHICLE_TRIGGER_ACCEL" )
			-- LT バックボタン
			local hudCommonData = HudCommonDataManager.GetInstance()
			hudCommonData:CallButtonGuide( "tutorial_brake", "VEHICLE_TRIGGER_BREAK" )

			TppMission.SetFlag( "isCarTutorial", true )							--乗り物チュートリアルボタンを表示した
--		end
	end
	if	TppSequence.GetCurrentSequence() == "Seq_DestroyTarget1" or		-- 現在のシーケンスが対空機関砲破壊、または、
		TppSequence.GetCurrentSequence() == "Seq_DestroyTarget2" then	-- 機銃装甲車破壊だったら

		local characterId = TppData.GetArgument( 1 )						-- プレイヤーが乗った乗り物のキャラクターIDを取得
		local radioDaemon = RadioDaemon:GetInstance()
		if	characterId ~= this.CHARACTER_ID_HELICOPTER and					-- プレイヤーが乗った乗り物がヘリ以外、かつ
			TppMission.GetFlag( "isEmptyAmmoRadioPlayed" ) == true then		-- 爆発系武器が無くなってきた無線を聴いていたら
			--無線を何も再生していないなら
			if ( radioDaemon:IsPlayingRadio() == false ) then
				if TppMission.GetFlag( "isVehicleIntelRadioPlayed" ) == false then	-- 車両諜報無線を聴いた事がなければ
					TppRadio.DelayPlay( "Radio_PlayerVehicleRide_01", "mid" )			-- 車両乗った無線を流す
				else																-- 車両諜報無線を聴いた事あれば
					TppRadio.DelayPlay( "Radio_PlayerVehicleRide_02", "mid" )			-- 車両乗った無線（諜報無線聴いた事がない版）を流す
				end
			end
		end

	end

end

--チュートリアルボタン表示
local Tutorial_2Button = function( textInfo, buttonIcon1, buttonIcon2 )
	-- 2ボタン
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:CallButtonGuide( textInfo, buttonIcon1, buttonIcon2 )
end

-- プレイヤーが武器を拾った
this.commonOnPlayerPickingUpWeapon = function()

	-- 拾った武器の武器IDを取得
	local weaponId = TppData.GetArgument(1)

	if weaponId == this.MISSILE_ID then									-- 拾った武器がWP_ms02だった

		local radioDaemon = RadioDaemon:GetInstance()
		if radioDaemon:IsPlayingRadio() == false then						--他の無線が何も再生されていなかったら
			TppRadio.DelayPlay( "Radio_PlayerPickUpWeapon_WP_ms02", "mid" )		-- 無反動砲を拾った無線を流す
		end

		if( TppMission.GetFlag( "isPrimaryWPIcon" ) == false ) then
			Tutorial_2Button("tutorial_primary_wp_select", fox.PAD_U, "RStick")
			TppMission.SetFlag( "isPrimaryWPIcon", true )
		end

	elseif weaponID == "WP_sr01_v00" then				-- スナイパーライフル

		if( TppMission.GetFlag( "isPrimaryWPIcon" ) == false ) then
			Tutorial_2Button("tutorial_primary_wp_select", fox.PAD_U, "RStick")
			TppMission.SetFlag( "isPrimaryWPIcon", true )
		end

	elseif	TppMission.GetFlag( "isPlayerInClaymoreRadioTrap" ) and
			weaponId == "WP_Claymore" then

		TppRadio.DisableIntelRadio( "IntelRadio_Claymore" )
		TppMission.SetFlag( "isClaymoreRadioPlayed", true )

	end

end

-- ヘリが下りてきた
this.commonOnHelicopterDescendToLZ = function()

	local sequence = TppSequence.GetCurrentSequence()
	if sequence == "Seq_CallSupportHelicopter" or sequence == "Seq_Escape" then
		TppSupportHelicopterService.DisableAutoReturn()
	end

end

-- ヘリが死んだ
this.commonOnHelicopterDead = function()

	local sequence = TppSequence.GetCurrentSequence()
	local killerCharacterId = TppData.GetArgument(2)

	-- 「ヘリ離脱シーケンス」だったらミッション失敗
	if sequence == "Seq_PlayerRideHelicopter" then
		TppMission.ChangeState( "failed", "HelicopterDead" )	-- ミッション失敗要求
	else
		if killerCharacterId == "Player" then
			TppRadio.Play( "Miller_HeliDeadSneak" )
		else
			TppRadio.Play( "Miller_HeliDead" )
		end
		-- アナウンスログ表示
		local commonDataManager = UiCommonDataManager.GetInstance()
		if commonDataManager ~= NULL then
			local luaData = commonDataManager:GetUiLuaExportCommonData()
			if luaData ~= NULL then
				local hudCommonData = HudCommonDataManager.GetInstance()					-- とりあえずマネージャーを取得
				hudCommonData:AnnounceLogViewLangId( "announce_destroyed_support_heli" )	-- アナウンスログ表示
			end
		end
	end

end

-- 捕虜のドアを開けたフラグを取得
this.commonGetHostageDoorOpenedFlagName = function( characterId )

	return characterId .. "_DoorOpened"

end

-- フラグリストに捕虜のドアを開けたフラグを追加
for i, characterId in ipairs( this.hostages ) do
	this.MissionFlagList[ this.commonGetHostageDoorOpenedFlagName( characterId ) ] = false
end

-- 捕虜のドアを開けていたらtrue、それ以外はfalse
this.commonIsHostageDoorOpened = function( characterId )

	return TppMission.GetFlag( this.commonGetHostageDoorOpenedFlagName( characterId ) )

end

-- 捕虜のドアを開けたかどうか設定
this.commonSetHostageDoorOpened = function( characterId, flag )

	TppMission.SetFlag( this.commonGetHostageDoorOpenedFlagName( characterId ), flag )

end

-- プレイヤーがドアをピッキングしようとした
this.commonOnPickingDoor = function()

	local characterId = TppData.GetArgument( 1 )
	local hostageCharacterId = nil

	-- 捕虜が暴れるのを止める
	if characterId == "AsyPickingDoor24" then
		hostageCharacterId = "Hostage_e20050_001"
		TppHostageManager.GsSetStruggleFlag( hostageCharacterId, false )
	elseif characterId == "AsyPickingDoor13" then
		hostageCharacterId = "Hostage_e20050_002"
		TppHostageManager.GsSetStruggleFlag( hostageCharacterId, false )
	elseif characterId == "AsyPickingDoor08" then
		hostageCharacterId = "Hostage_e20050_000"
		TppHostageManager.GsSetStruggleFlag( hostageCharacterId, false )
	end

	if hostageCharacterId ~= nil then
		this.commonSetHostageDoorOpened( hostageCharacterId, true )
	end

end

-- 警戒ルートセットを変更する
this.commonChangeToAntiLandRouteSet = function( isWarp )

	TppEnemy.RegisterRouteSet( this.CP_ID, "caution_day", "e20050_route_c02" )													-- 昼の警戒ルートを変更する
	TppEnemy.ChangeRouteSet( this.CP_ID, "e20050_route_c02", { forceUpdate = true, forceReload = true, warpEnemy = isWarp } )	-- ルートセットを変更する

end

-- ターゲット以外の何かが壊れた
-- ターゲットが壊れた時はシーケンス固有の関数の方が呼ばれる
this.commonOnNonTargetBroken = function()

	local characterId = TppData.GetArgument(1)	-- 壊れた物のCharacterIDを取得
	this.commonDestroyObject( characterId )		-- 壊れた事にする
	-- TppRadio.Play( "Radio_NonTargetDestroyed" )	-- 汎用破壊無線を流す

end

-- 最低フェイズを警戒フェイズにしてサイレンを流す
this.commonSetPhaseToKeepCaution = function( isWarp)

	GZCommon.CallCautionSiren()							-- Caution用サイレンのコール開始
	TppEnemy.SetMinimumPhase( this.CP_ID, "caution" )	-- keep caution にする
	TppEnemy.ChangeRouteSet( this.CP_ID, "e20050_route_c01", { forceUpdate = true, forceReload = true, warpEnemy = isWarp } )	-- ルートセットを変更する

end

-- ミッション失敗の時に、次に進むべきシーケンスを決めてシーケンスを変更する
this.commonOnMissionFailure = function( manager, messageId, message )

	-- 無線全部停止
	local radioDaemon = RadioDaemon:GetInstance()
	-- 再生中の無線停止
	radioDaemon:StopDirectNoEndMessage()
	-- 字幕の停止
	SubtitlesCommand.StopAll()
	-- CP無線をフェードアウトしつつ全停止
	TppEnemyUtility.IgnoreCpRadioCall(true)	-- 以降の新規無線コールを止める
	TppEnemyUtility.StopAllCpRadio( 0.5 )	-- フェード時間

	-- BGMフェードアウト
	TppSoundDaemon.SetMute( 'GameOver' )

	-- ミッション失敗フェード開始時間を汎用値で初期化しておく（Continue対策）
	this.CounterList.GameOverFadeTime = GZCommon.FadeOutTime_MissionFailed

	if message == "OutsideMissionArea" then									-- 失敗原因がミッション圏外だったら

		-- UI
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:CallFailedTelop( "gameover_reason_mission_outside" )	-- 失敗理由テロップ表示

		-- サウンド
		GZCommon.OutsideAreaCamera()

		-- 次シーケンスへ
		TppSequence.ChangeSequence( "Seq_MissionFailedOutsideMissionArea" )		-- ミッション圏外失敗シーケンスへ

	elseif message == "RideHelicopter" then									-- 失敗原因がヘリに乗っただったら
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:CallFailedTelop( "gameover_reason_mission_abort" )	-- 失敗理由テロップ表示

		TppSequence.ChangeSequence( "Seq_MissionFailedRideHelicopter" )			-- ヘリに乗って失敗シーケンスへ
	elseif message == "HelicopterDead" then
		TppSequence.ChangeSequence( "Seq_MissionFailedHelicopterDead" )
	elseif message == "TimeOver" then										-- 失敗原因が時間切れだったら
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:CallFailedTelop( "gameover_reason_time_over" )	-- 失敗理由テロップ表示

		TppSequence.ChangeSequence( "Seq_MissionFailedTimeOver" )				-- 時間切れ失敗シーケンスへ
	elseif message == "PlayerDead" then										-- 失敗原因がプレイヤー死亡だったら
		TppSequence.ChangeSequence( "Seq_MissionFailedPlayerDead" )				-- プレイヤー死亡シーケンスへ
	elseif message == "PlayerFallDead" then									-- 失敗原因がプレイヤー落下死亡だったら
		this.CounterList.GameOverFadeTime = GZCommon.FadeOutTime_PlayerFallDead	-- 落下死亡時はフェード開始時間を変更
		TppSequence.ChangeSequence( "Seq_MissionFailedPlayerDead" )				-- プレイヤー死亡シーケンスへ
	else																	-- それ以外だったら
		TppSequence.ChangeSequence( "Seq_MissionFailedPlayerDead" )				-- プレイヤー死亡失敗シーケンスへ
	end

end

-- ミッションクリアの時に、次に進むべきシーケンスを決めてシーケンスを変更する
this.commonOnMissionClear = function( manager, messageId, message )

	TppSequence.ChangeSequence( "Seq_PlayMissionClearDemo" )
	Trophy.TrophyUnlock( 2 )									-- トロフィー・実績「サイドオプスを一つクリア」

end

-- 武器を装備した
this.commonOnEquipWeapon = function()

	local weaponId = TppData.GetArgument( 1 )			-- 装備した武器ID
	this.CounterList.currentWeapon = weaponId

	if TppMission.GetFlag( "isC4EquipRadioPlayed" ) == true then
		return
	end

	local sequence = TppSequence.GetCurrentSequence()	-- 現在のシーケンス名
	if 	weaponId == "WP_C4" and
		( sequence == "Seq_DestroyTarget1" or sequence == "Seq_DestroyTarget2" ) then

		TppMission.SetFlag( "isC4EquipRadioPlayed", true )

		local radioDaemon = RadioDaemon:GetInstance()
		if radioDaemon:IsPlayingRadioWithGroupName("e0050_rtrg0008") == false and radioDaemon:IsPlayingRadioWithGroupName("e0050_rtrg0010") == false then
			TppRadio.Play( "Radio_EquipC4" )
		end

	end

end

-- 武器を設置した
this.commonOnPlaceWeapon = function()

	if TppMission.GetFlag( "isC4PlaceRadioPlayed" ) == true then
		return
	end

	local weaponId = TppData.GetArgument( 1 )
	local sequence = TppSequence.GetCurrentSequence()	-- 現在のシーケンス名
	if 	weaponId == "WP_C4" and
		( sequence == "Seq_DestroyTarget1" or sequence == "Seq_DestroyTarget2" ) then

		TppMission.SetFlag( "isC4PlaceRadioPlayed", true )

		local radioDaemon = RadioDaemon:GetInstance()
		if radioDaemon:IsPlayingRadioWithGroupName("e0050_rtrg0008") == false and radioDaemon:IsPlayingRadioWithGroupName("e0050_rtrg0010") == false then
			TppRadio.Play( "Radio_PlaceC4" )
		end

	end

end

-- C4爆弾を装備した
this.commonSub_PPRG1001_601010 = function()

	-- C4爆弾設置
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:CallButtonGuide( "tutorial_C4_set", "PL_HOLD", "PL_SHOT" )

end

-- C4爆弾を設置した
this.commonSub_PPRG1001_611010 = function()

	-- C4爆弾起動
	local hudCommonData = HudCommonDataManager.GetInstance()
	hudCommonData:CallButtonGuide( "tutorial_C4_exploding", "PL_HOLD", "PL_ACTION" )

end

this.commonEnableWeaponMarker = function()

	TppMarkerSystem.EnableMarker{ markerId="20050_marker_weapon000", goalType="GOAL_NONE", viewType = "VIEW_MAP_ICON" }
	TppMarkerSystem.EnableMarker{ markerId="20050_marker_weapon001", goalType="GOAL_NONE", viewType = "VIEW_MAP_ICON" }
	-- TppMarker.Enable( "20050_marker_weapon000", 0, "none", "map" )
	-- TppMarker.Enable( "20050_marker_weapon001", 0, "none", "map" )

end

-- アラートになった
this.commonOnAlert = function()

	if TppMission.GetFlag( "isAntiLandRouteSet" ) == false then	-- アラートになった事があるフラグが立っていなかったら
		this.commonChangeToAntiLandRouteSet( false )						-- 対地警戒ルートセットにする
		TppMission.SetFlag( "isAntiLandRouteSet", true )			-- アラートになった事があるフラグを立てる
	end

	GZCommon.CallAlertSirenCheck()

	-- 鳥を全部飛び立たせる
	local characters = Ch.FindCharacters( "Bird" )
	for i=1, #characters.array do
	   local chara = characters.array[i]
	   local plgAction = chara:FindPlugin("TppBirdActionPlugin")
	   plgAction:SetForceFly()
	end

end

this.commonOnEvasion = function()

	-- フェイズが「下がってきた」か
	if ( status == "Down" ) then
		-- Evasionに落ちてきた場合はCautionRouteにしておく
		if ( TppEnemy.GetPhase( this.CP_ID ) == "evasion" ) then
			local sequence = TppSequence.GetCurrentSequence()
			if sequence == "Seq_SearchAndDestroy" or sequence == "Seq_GotoHeliport" then
				TppEnemy.ChangeRouteSet( this.CP_ID, "e20070_route_c01", { warpEnemy = false } )
			end
		end
	end

end

-- 警戒フェイズになった
this.commonOnCaution = function()

	-- GZCommon.StopAlertSirenCheck()

	-- 鳥を全部飛び立たせる
	local characters = Ch.FindCharacters( "Bird" )
	for i=1, #characters.array do
	   local chara = characters.array[i]
	   local plgAction = chara:FindPlugin("TppBirdActionPlugin")
	   plgAction:SetForceFly()
	end

end


-- 残弾が0になった
this.commonOnAmmoStackEmpty = function()

	local weaponId = TppData.GetArgument( 1 )
	local sequence = TppSequence.GetCurrentSequence()
	Fox.Log("weaponId:" .. weaponId)
	if	( weaponId == "WP_C4" or weaponId == "WP_Grenade" ) and						-- C4またはグレネードの残弾が0になった、かつ
		( sequence == "Seq_DestroyTarget1" or sequence == "Seq_DestroyTarget2" ) then	-- 現在のシーケンスが破壊シーケンス中だったら

		TppRadio.DelayPlay( "Radio_EmptyAmmo", "mid" )	-- 爆発系武器無くなった無線を流す
		TppMission.SetFlag( "isEmptyAmmoRadioPlayed", true )

		if sequence == "Seq_DestroyTarget1" then
			TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_000", "e0050_esrg0010", true )
			TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_001", "e0050_esrg0010", true )
			TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_002", "e0050_esrg0010", true )
			TppRadio.RegisterIntelRadio( "gntn_area01_antiAirGun_003", "e0050_esrg0010", true )
		end

		this.commonEnableAllAntiAirGunIntelRadio()

		local sequence = TppSequence.GetCurrentSequence()
		if sequence == "Seq_DestroyTarget1" or sequence == "Seq_DestroyTarget1" then
			TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_000", "e0050_esrg0052", true )
			TppRadio.RegisterIntelRadio( "Tactical_Vehicle_WEST_001", "e0050_esrg0052", true )
			TppRadio.RegisterIntelRadio( "Cargo_Truck_WEST_000", "e0050_esrg0050", true )
			TppRadio.RegisterIntelRadio( "Cargo_Truck_WEST_001", "e0050_esrg0050", true )
			TppRadio.RegisterIntelRadio( "Cargo_Truck_WEST_002", "e0050_esrg0050", true )
		end

	end

end

this.commonOnReachRouteNode = function()

	local routeName = TppData.GetArgument( 3 )
	local routeNode = TppData.GetArgument( 1 )
	local maxRouteNode = TppData.GetArgument( 2 )

	-- 対空機関砲間巡回ルート設定
	if	routeName == GsRoute.GetRouteId( "e20050_c01_route0057" ) and
		routeNode == 1 then

		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0058", "e20050_c01_route0057" )

	end
	if routeName == GsRoute.GetRouteId( "e20050_c01_route0058" ) then
		if routeNode == 0 then
			TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0062", "e20050_c01_route0061" )
		elseif routeNode == 1 then
			TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0059", "e20050_c01_route0058" )
			TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0063", "e20050_c01_route0062" )
		end
	end
	if	routeName == GsRoute.GetRouteId( "e20050_c01_route0059" ) and
		routeNode == 1 then

		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0060", "e20050_c01_route0059" )

	end
	if	routeName == GsRoute.GetRouteId( "e20050_c01_route0060" ) then
		if routeNode == 0 then
			TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0064", "e20050_c01_route0063" )
		elseif routeNode == 1 then
			TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0057", "e20050_c01_route0060" )
			TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0061", "e20050_c01_route0064" )
		end
	end

	-- 無反動砲兵士を金属櫓ルートへ
	if	routeName == GsRoute.GetRouteId( "e20050_c01_route0071" ) then
		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0074", "e20050_c01_route0071" )
	end
	if	routeName == GsRoute.GetRouteId( "e20050_c01_route0074" ) then
		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0068", "e20050_c01_route0074" )
	end
	if	routeName == GsRoute.GetRouteId( "e20050_c01_route0072" ) then
		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0075", "e20050_c01_route0072" )
	end
	if	routeName == GsRoute.GetRouteId( "e20050_c01_route0075" ) then
		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0069", "e20050_c01_route0075" )
	end
	if	routeName == GsRoute.GetRouteId( "e20050_c01_route0073" ) then
		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0076", "e20050_c01_route0073" )
	end
	if	routeName == GsRoute.GetRouteId( "e20050_c01_route0076" ) then
		TppCommandPostObject.GsSetExclusionRoutes( this.CP_ID, "e20050_c01_route0070", "e20050_c01_route0076" )
	end

end

this.ChangeAntiAir = function()

	-- 対空行動の開始or終了
	local status = TppData.GetArgument(2)

	-- 対空行動の開始
	if ( status == true ) then
		-- サイレン開始
		GZCommon.CallCautionSiren()
	-- 対空行動の終了
	else
		-- サイレンの通常停止
		GZCommon.StopSirenNormal()
	end

end

---------------------------------------------------------------------------------------------------------
--停電演出
this.SwitchPuchButtonDemo = function()
	Fox.Log(":: Push Switch ::")
	local charaID = TppData.GetArgument( 1 )
	local check = TppEnemy.GetPhase( this.CP_ID )
	local status = TppGadgetManager.GetGadgetStatus( "gntn_center_SwitchLight" )

	--配電盤スイッチライト
	if( charaID == "gntn_center_SwitchLight" )then
		Fox.Log("Light goes out")
		if( status == 1 )then	--停電になった
			--管理棟内、監視カメラをＯＦＦにする
			TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_02", false )
			TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_03", false )
			TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_04", false )

			if( TppMission.GetFlag( "isSwitchLightDemo" ) == false and check ~= "alert") then	--停電演出を１度も見ていない

				local onDemoStart = function()
					--フラグ更新
					TppMission.SetFlag( "isSwitchLightDemo", true )
				end
				TppDemo.Play( "Demo_SwitchLight" , { onStart = onDemoStart} , {
					disableGame				= false,	--共通ゲーム無効を、キャンセル
					disableDamageFilter		= false,	--エフェクトは消さない
					disableDemoEnemies		= false,	--敵兵は消さないでいい
					disableEnemyReaction	= true,		--敵兵のリアクションを向こうかする
					disableHelicopter		= false,	--支援ヘリは消さないでいい
					disablePlacement		= false, 	--設置物は消さないでいい
					disableThrowing			= false	 	--投擲物は消さないでいい
				})
			end
		elseif( status == 2 )then	-- 停電から戻った
			Fox.Log("Light come back")
			--管理棟内、監視カメラをONにする
			TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_02", true )
			TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_03", true )
			TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_04", true )
		end

	end
end

-- OnShowRewardPopupWindow
this.OnShowRewardPopupWindow = function()

	Fox.Log( "e20050_sequence.OnShowRewardPopupWindow()" )

	local hudCommonData = HudCommonDataManager.GetInstance()
	local uiCommonData = UiCommonDataManager.GetInstance()

	-- **** ミッション達成率の表示 ****
	local RewardAllCount = uiCommonData:GetRewardAllCount( this.missionID )
	Fox.Log("**** ShowRewardAllCount::"..RewardAllCount)
	-- 報酬の獲得状況（達成率）表示
	hudCommonData:SetBonusPopupCounter( this.tmpRewardNum, RewardAllCount )

	-- 汎用報酬チェック
	-- 空文字になるまで繰り返す
	local challengeString = PlayRecord.GetOpenChallenge()
	while ( challengeString ~= "" ) do
		Fox.Log("-------OnShowRewardPopupWindow:challengeString:::"..challengeString)

		-- PopUpの表示。表示終了メッセージを受けたら再度実行
		hudCommonData:ShowBonusPopupCommon( challengeString )
		-- PlayRecordに問い合わせ
		challengeString = PlayRecord.GetOpenChallenge()
	end

	-- クリアランクに応じた報酬アイテム入手
	local Rank = PlayRecord.GetRank()
	Fox.Log("-------RANK_IS__"..Rank.."__BESTRANK_IS__"..this.tmpBestRank )
	while ( Rank < this.tmpBestRank ) do
		Fox.Log("-------OnShowRewardPopupWindow:ClearRankRewardItem-------"..this.tmpBestRank)

		this.tmpBestRank = ( this.tmpBestRank - 1 )
		if ( this.tmpBestRank == 4 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankC, "WP_sm00_v00", { isSup=true, isLight=true } )
		elseif ( this.tmpBestRank == 3 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankB, "WP_sr01_v00" )
		elseif ( this.tmpBestRank == 2 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankA, "WP_ms02" )
		elseif ( this.tmpBestRank == 1 ) then
			hudCommonData:ShowBonusPopupItem( this.ClearRankRewardPopupList.RankS, "WP_ar00_v05", { isBarrel=true } )
		end
	end

	-- チコテープ7入手チェック
	-- MB諜報員を助けていたら入手
	local ChicoTape7 = this.commonIsHostageRescued( this.CHARACTER_ID_MB_AGENT ) == true and uiCommonData:IsHaveCassetteTape( "tp_chico_07" ) == false
	if ChicoTape7 == true then
		hudCommonData:ShowBonusPopupItemTape( "reward_get_tape_20050" )
		uiCommonData:GetBriefingCassetteTape( "tp_chico_07" )
	end

	-- チコテープ入手チェック
	-- 全ての「チコの記録」入手で「チコの記録（完全版）」入手
	local AllChicoTape = GZCommon.CheckReward_AllChicoTape()
	if ( AllChicoTape == true and
			 uiCommonData:IsHaveCassetteTape( "tp_chico_08" ) == false ) then
		Fox.Log("-------OnShowRewardPopupWindow:GetCompChico-------")

		-- 「チコの記録（完全版）」カセット入手ポップアップ
		hudCommonData:ShowBonusPopupItemTape( "reward_get_tape_allchico" )

		-- 「チコの記録（完全版）」カセット入手処理
		uiCommonData:GetBriefingCassetteTape( "tp_chico_08" )

	end

	-- ANUBISテープ入手チェック
	-- 全てのHardモードクリアで「ANUBISテーマ」入手
	local AllHardClear = PlayRecord.IsAllMissionClearHard()
	if ( AllHardClear == true and
			 uiCommonData:IsHaveCassetteTape( "tp_bgm_01" ) == false ) then
		Fox.Log("-------OnShowRewardPopupWindow:GetAnubis-------")

		-- 「ANUBISテーマ」カセット入手ポップアップ
		hudCommonData:ShowBonusPopupItemTape( "reward_get_tape_tp_bgm_01" )

		-- 「ANUBISテーマ」カセット入手処理
		uiCommonData:GetBriefingCassetteTape( "tp_bgm_01" )

	end

	if	TppGameSequence.GetGameFlag("hardmode") == false and					-- ノーマルクリアかつ
		PlayRecord.GetMissionScore( 20050, "NORMAL", "CLEAR_COUNT" ) == 1 then	-- 初回クリアなら

		hudCommonData:ShowBonusPopupCommon( "reward_extreme" )						-- ハード解放

	end

	-- いずれのポップアップも呼ばれなかったら即座に次シーケンスへ
	if ( hudCommonData:IsShowBonusPopup() == false ) then
		Fox.Log("-------OnShowRewardPopupWindow:NoPopup!!-------")
		TppSequence.ChangeSequence( "Seq_MissionEnd" )	-- ST_CLEARから先に進ませるために次シーケンスへ
	end

end

this.tmpChallengeString = 0			-- 報酬ポップアップ識別用

-- 車輌連携が終了したら呼ばれる
this.commonOnVehicleGroupActionEnd = function()

	local vehicleGroupInfo = TppData.GetArgument( 2 )

	local routeInfoName = vehicleGroupInfo.routeInfoName									-- RouteInfoデータ名
	local vehicleCharacterId = vehicleGroupInfo.vehicleCharacterId							-- 車両のキャラクターID
	local routeId = vehicleGroupInfo.vehicleRouteId											-- ルートID
	local memberCharacterIds = vehicleGroupInfo.memberCharacterIds							-- 乗車しているキャラクターID
	local result = vehicleGroupInfo.result													-- 結果（成功 or 失敗）
	local reason = vehicleGroupInfo.reason													-- 結果の原因

	if routeInfoName == "TppGroupVehicleDefaultRideRouteInfo0002" then						-- 増援車両連携ではなかったら

		TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0079", { noForceUpdate = true, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0080", { noForceUpdate = true, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0081", { noForceUpdate = true, }  )
		TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0082", { noForceUpdate = true, }  )

	end

end

-- 報酬ポップアップの表示
this.OnClosePopupWindow = function()

	Fox.Log("-------OnClosePopupWindow--------")

	-- CloseされたポップアップのLangIdハッシュ値
	local LangIdHash = TppData.GetArgument(1)

	-- Closeされたポップアップが報酬用のものかどうかを識別
	if ( LangIdHash == this.tmpChallengeString ) then

		-- 報酬ポップアップ表示実行
		this.OnShowRewardPopupWindow()
	end
end


this.commonOnPlayerDamaged = function()

	local attackId = TppData.GetArgument( 1 )
	Fox.Log( "e20050_sequence.commonOnPlayerDamaged() attackId:" .. attackId )
	if	attackId == "ATK_Claymore" and
		TppMission.GetFlag( "isPlayerInClaymoreRadioTrap" ) == true then

		local radioDaemon = RadioDaemon:GetInstance()
		if	TppMission.GetFlag( "isClaymoreRadioPlayed" ) == false and
			radioDaemon:IsRadioGroupMarkAsRead("e0050_esrg0110") == false then

			TppMission.SetFlag( "isClaymoreRadioPlayed", true )
			TppRadio.DelayPlay( "Radio_Claymore", "mid" )
			TppRadio.DisableIntelRadio( "IntelRadio_Claymore" )

		end

	end

end

this.commonOnActivatePlaced = function()

	local attackId = TppData.GetArgument( 1 )
	if attackId == "WP_Claymore" then							-- 世界のどこかでクレイモアが爆発した

		-- TppMission.SetFlag( "isClaymoreRadioPlayed", true )
		TppRadio.DisableIntelRadio( "IntelRadio_Claymore" )

	end

end

this.commonPlayerEnterClaymoreRadioTrap = function()

	TppMission.SetFlag( "isPlayerInClaymoreRadioTrap", true )

end

this.commonPlayerLeaveClaymoreRadioTrap = function()

	TppMission.SetFlag( "isPlayerInClaymoreRadioTrap", false )

end

this.commonOnPlayerLifeLessThanHalf = function()

	if	TppMission.GetFlag( "isClaymoreRadioPlayed" ) == true then

		TppRadio.Play( "Miller_SpRecoveryLifeAdvice" )

	end

end

this.commonPlayerEnterPowCarriedTalkTrap0001 = function()

	if TppMission.GetFlag( "isHostage0003Talk1Played" ) == true then
		return
	end

	local trapBodyHandle = TppData.GetArgument(3)
	local trapName = trapBodyHandle.data.name

	local obj = Ch.FindCharacterObjectByCharacterId("Hostage_e20050_003")
	if not Entity.IsNull(obj) then

		TppHostageManager.GsSetSpecialFaintFlag( "Hostage_e20050_003", false )
		TppHostageManager.GsSetSpecialIdleFlag( "Hostage_e20050_003", false )
		TppEnemyUtility.CallCharacterMonologue( "POW_CD_e0050_002" , 3, obj, true )
		trapBodyHandle:SetInvalid() -- このTrapは用済み

		TppMission.SetFlag( "isHostage0003Talk1Played", true )

	end

end

this.commonPlayerEnterPowCarriedTalkTrap0002 = function()

	if TppMission.GetFlag( "isHostage0003Talk2Played" ) == true then
		return
	end

	local trapBodyHandle = TppData.GetArgument(3)
	local trapName = trapBodyHandle.data.name

	--捕虜を担いでいたら
	if( TppPlayerUtility.IsCarriedCharacter( "Hostage_e20050_003" )) then

		local obj = Ch.FindCharacterObjectByCharacterId("Hostage_e20050_003")
		if not Entity.IsNull(obj) then

			TppHostageManager.GsSetSpecialFaintFlag( "Hostage_e20050_003", false )
			TppHostageManager.GsSetSpecialIdleFlag( "Hostage_e20050_003", false )
			TppEnemyUtility.CallCharacterMonologue( "POW_CD_e0050_001" , 3, obj, true )
			trapBodyHandle:SetInvalid() -- このTrapは用済み

			if TppMission.GetFlag( "isArmoredVehicle0000Destroyed" ) == false then	-- カウントダウン前だったら

				TppRadio.RegisterIntelRadio( "Hostage_e20050_000", "e0050_esrg0090", true )
				TppRadio.RegisterIntelRadio( "Hostage_e20050_001", "e0050_esrg0090", true )
				TppRadio.RegisterIntelRadio( "Hostage_e20050_002", "e0050_esrg0090", true )

			else																	-- カウントダウン後だったら

				TppRadio.RegisterIntelRadio( "Hostage_e20050_000", "e0050_esrg0091", true )
				TppRadio.RegisterIntelRadio( "Hostage_e20050_001", "e0050_esrg0091", true )
				TppRadio.RegisterIntelRadio( "Hostage_e20050_002", "e0050_esrg0091", true )

			end

			TppRadio.EnableIntelRadio( "Hostage_e20050_000" )
			TppRadio.EnableIntelRadio( "Hostage_e20050_001" )
			TppRadio.EnableIntelRadio( "Hostage_e20050_002" )

			TppMission.SetFlag( "isHostage0003Talk2Played", true )

		end

	else
	end

end

this.commonOnHostageIntelRadioPlayed = function()

	if TppMission.GetFlag( "isArmoredVehicle0000Destroyed" ) == false then	-- カウントダウン前だったら

		TppRadio.RegisterIntelRadio( "Hostage_e20050_000", "e0050_esrg0090", true )
		TppRadio.RegisterIntelRadio( "Hostage_e20050_001", "e0050_esrg0090", true )
		TppRadio.RegisterIntelRadio( "Hostage_e20050_002", "e0050_esrg0090", true )

	else																	-- カウントダウン後だったら

		TppRadio.RegisterIntelRadio( "Hostage_e20050_000", "e0050_esrg0091", true )
		TppRadio.RegisterIntelRadio( "Hostage_e20050_001", "e0050_esrg0091", true )
		TppRadio.RegisterIntelRadio( "Hostage_e20050_002", "e0050_esrg0091", true )

	end

end

this.hostageMonologues = {
	Hostage_e20050_000 = "POW_CD_0010",
	Hostage_e20050_001 = "POW_CD_0020",
	Hostage_e20050_002 = "POW_CD_0040",
}

this.hostageMonologueFlags = {
}
for i, characterId in ipairs( this.hostages ) do
	local flagName = characterId .. "_Monologue"
	this.hostageMonologueFlags[ characterId ] = flagName
	this.MissionFlagList[ flagName ] = false
end


this.commonIsHostageMonologuePlayed = function( characterId )

	if TppMission.GetFlag( this.hostageMonologueFlags[ characterId ] ) == true then
		return true
	end

	return false

end

this.commonSetHostageMonologueFlag = function( characterId, flag )

	TppMission.SetFlag( this.hostageMonologueFlags[ characterId ], flag )

end

-- 死亡トラップに入ったら呼ばれる
this.commonOnEnterDeathTrap = function()

	local trapBodyHandle = TppData.GetArgument(3)
	local trapName = trapBodyHandle.data.name

	Fox.Log( "e20050_sequence.commonOnEnterDeathTrap():trapName:" .. trapName )

	if trapName == "GeoTrapDamage" then

		this.CounterList.playerInDeathTrap0000 = true

	end

end

-- 死亡トラップから出たら呼ばれる
this.commonOnLeaveDeathTrap = function()

	local trapBodyHandle = TppData.GetArgument(3)
	local trapName = trapBodyHandle.data.name

	Fox.Log( "e20050_sequence.commonOnEnterDeathTrap():trapName:" .. trapName )

	if trapName == "GeoTrapDamage" then

		this.CounterList.playerInDeathTrap0000 = false

	end

end

this.commonPlayerEnterPowCarriedTalkTrap0003 = function()

	local trapBodyHandle = TppData.GetArgument(3)
	local trapName = trapBodyHandle.data.name

	-- MB諜報員以外の捕虜を担いでいたら担ぎ会話
	for i, characterId in ipairs( this.hostages ) do
		if	characterId ~= this.CHARACTER_ID_MB_AGENT and
			this.commonIsHostageMonologuePlayed( characterId ) == false then

			if TppPlayerUtility.IsCarriedCharacter( characterId ) == true then

				local obj = Ch.FindCharacterObjectByCharacterId( characterId )
				if not Entity.IsNull(obj) then

					TppHostageManager.GsSetSpecialFaintFlag( characterId, false )
					TppHostageManager.GsSetSpecialIdleFlag( characterId, false )
					TppEnemyUtility.CallCharacterMonologue( this.hostageMonologues[ characterId ], 3, obj, true )
					this.commonSetHostageMonologueFlag( characterId, true )

				end
			end
		end
	end

end

this.commonPlayerEnterHostageRadioTrap0000 = function()

	local trapBodyHandle = TppData.GetArgument(3)

	local radioDaemon = RadioDaemon:GetInstance()
	if radioDaemon:IsRadioGroupMarkAsRead("e0050_esrg0100") == false then	-- まだ諜報無線を聴いていなかったら
		TppRadio.Play( "Radio_MBHostage" )
	end

	if TppMission.GetFlag( "isArmoredVehicle0000Destroyed" ) == false then	-- カウントダウン前だったら

		TppRadio.RegisterIntelRadio( "Hostage_e20050_000", "e0050_esrg0077", true )
		TppRadio.RegisterIntelRadio( "Hostage_e20050_001", "e0050_esrg0077", true )
		TppRadio.RegisterIntelRadio( "Hostage_e20050_002", "e0050_esrg0077", true )

	else																	-- カウントダウン後だったら

		TppRadio.RegisterIntelRadio( "Hostage_e20050_000", "e0050_esrg0082", true )
		TppRadio.RegisterIntelRadio( "Hostage_e20050_001", "e0050_esrg0083", true )
		TppRadio.RegisterIntelRadio( "Hostage_e20050_002", "e0050_esrg0084", true )

	end

	TppRadio.EnableIntelRadio( "Hostage_e20050_000" )
	TppRadio.EnableIntelRadio( "Hostage_e20050_001" )
	TppRadio.EnableIntelRadio( "Hostage_e20050_002" )

	trapBodyHandle:SetInvalid() -- このTrapは用済み

end

this.commonPlayMissionBackgroundRadio4 = function()

	TppMission.SetFlag( "isMissionBackgroundRadio4Played", true )						-- ミッション背景無線その4を再生した事を記録
	TppRadio.DelayPlayEnqueue( "Radio_MissionBackground4", "long", "both" )											-- ミッション背景無線その4を再生する

	TppRadio.RegisterIntelRadio( "Hostage_e20050_000", "e0050_esrg0078", true )
	TppRadio.RegisterIntelRadio( "Hostage_e20050_001", "e0050_esrg0079", true )
	TppRadio.RegisterIntelRadio( "Hostage_e20050_002", "e0050_esrg0080", true )

	TppRadio.EnableIntelRadio( "Hostage_e20050_000", true )
	TppRadio.EnableIntelRadio( "Hostage_e20050_001", true )
	TppRadio.EnableIntelRadio( "Hostage_e20050_002", true )

end

this.commonPlayClaymoreInfoRadio = function()

	if TppMission.GetFlag( "isClaymoreRadioPlayed" ) == false then
		TppRadio.DelayPlay( "Radio_ClaymoreInfo", "mid" )
	end

end

-- ヘリコール画面を開いた
this.OnMbDvcActOpenHeliCall = function()

	if TppSequence.GetCurrentSequence() ~= "Seq_Escape" then
		TppRadio.DelayPlay( "Radio_MbDvcActOpenHeliCall", "short" )
	end

end

--支援ヘリ要請したとき
this.OnMbDvcActCallRescueHeli = function(characterId, type)
	local radioDaemon = RadioDaemon:GetInstance()
	local emergency = TppData.GetArgument(2)

	Fox.Log( "=================================" )
	Fox.Log( "===  mbDvaActCall(Type:" .. tostring(type) .. ") !!!   ===" )
	Fox.Log( "=================================" )

	local VehicleId = TppPlayerUtility.GetRidingVehicleCharacterId()

	if( VehicleId == "SupportHelicopter" ) then
	else
		if ( type == "MbDvc" ) then
			Fox.Log( "=================================" )
			Fox.Log( "===  mbDvaActCall(emergencyRank:" .. tostring(emergency) .. ") !!!   ===" )
			Fox.Log( "=================================" )

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
					local charaObj = Ch.FindCharacterObjectByCharacterId("SupportHelicopter")
					local plgHeli = charaObj:GetCharacter():FindPlugin("TppSupportHelicopterPlugin")
					if plgHeli:GetAiStatus() ~= "AI_STATUS_RETURN" then
						if(emergency == 2) then
							TppRadio.DelayPlay( "Miller_CallHeliHot01", "long" )
						else
							TppRadio.DelayPlay( "Miller_CallHeli01", "long" )
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
					TppRadio.DelayPlay( "Miller_HeliNoCall", "long" )
				end
			else
				-- ヘリは呼べる
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
						local charaObj = Ch.FindCharacterObjectByCharacterId("SupportHelicopter")
						local plgHeli = charaObj:GetCharacter():FindPlugin("TppSupportHelicopterPlugin")
						if plgHeli:GetAiStatus() ~= "AI_STATUS_RETURN" then
							if(emergency == 2) then
								TppRadio.DelayPlay( "Miller_CallHeliHot01", "long" )
							else
								TppRadio.DelayPlay( "Miller_CallHeli01", "long" )
							end
						end
					end
				end
			end
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

this.commonEnableAllAntiAirGunIntelRadio = function()

	if TppMission.GetFlag( "isAntiAirGun0000Destroyed" ) == false then
		TppRadio.EnableIntelRadio( "gntn_area01_antiAirGun_000" )
	end
	if TppMission.GetFlag( "isAntiAirGun0001Destroyed" ) == false then
		TppRadio.EnableIntelRadio( "gntn_area01_antiAirGun_001" )
	end
	if TppMission.GetFlag( "isAntiAirGun0002Destroyed" ) == false then
		TppRadio.EnableIntelRadio( "gntn_area01_antiAirGun_002" )
	end
	if TppMission.GetFlag( "isAntiAirGun0003Destroyed" ) == false then
		TppRadio.EnableIntelRadio( "gntn_area01_antiAirGun_003" )
	end

end

this.antiAirGuns = {
	"gntn_area01_antiAirGun_000",
	"gntn_area01_antiAirGun_001",
	"gntn_area01_antiAirGun_002",
	"gntn_area01_antiAirGun_003",
}

this.towers = {
	"WoodTurret01",
	"WoodTurret02",
	"WoodTurret03",
	"WoodTurret04",
	"WoodTurret05",
}

this.antiAirGunsMarkerFlagMap = {}
for i, characterId in ipairs( this.antiAirGuns ) do
	this.antiAirGunsMarkerFlagMap[ characterId ] = characterId .. "Mark"
	this.MissionFlagList[ this.antiAirGunsMarkerFlagMap[ characterId ] ] = false
end

this.commonIsAntiAirGunsMarked = function( characterId )

	return TppMission.GetFlag( this.antiAirGunsMarkerFlagMap[ characterId ] )

end

this.commonSetAntiAirGunsMarkFlag = function( characterId, flag )

	TppMission.SetFlag( this.antiAirGunsMarkerFlagMap[ characterId ], flag )
end

-- ミッション背景説明無線2を流すためのタイマーをスタート
this.commonStartPlayBackGroundRadio2 = function()

	GkEventTimerManager.Stop( "Timer_BackGroundRadio1" )
	GkEventTimerManager.Start( "Timer_BackGroundRadio2", 5 )

end

-- ミッション背景説明無線を流す
this.commonPlayBackGroundRadio2 = function()

	if	TppCharacterUtility.GetCurrentPhaseName() ~= "Alert" then						-- アラートではなかったら

		if TppMission.GetFlag( "isMissionBackgroundRadio1Played" ) == false then			-- まだミッション背景無線その1を再生していなかったら

			TppMission.SetFlag( "isMissionBackgroundRadio1Played", true )						-- ミッション背景無線その1を再生した事を記録
			TppRadio.DelayPlayEnqueue( "Radio_MissionBackground1", "long","both", {										-- ミッション背景無線その1を再生する
				onEnd = function()																-- 無線終了時に
					GkEventTimerManager.Start( "Timer_BackGroundRadio2", 5 )								-- ミッション背景無線その2を再生するためのタイマーをセット
				end } )

		elseif TppMission.GetFlag( "isMissionBackgroundRadio4Played" ) == false then		-- ミッション背景無線その2を再生していてその4を再生していなかったら

			this.commonPlayMissionBackgroundRadio4()

		end

	else																				-- それ以外だったら
		GkEventTimerManager.Start( "Timer_BackGroundRadio2", 5 )							-- またタイマーを回す
	end

end

-- クリアランク報酬テーブル
this.ClearRankRewardList = {

	-- ステージ上に配置した報酬アイテムロケータのLocatorIDを登録
	RankS = "e20050_Assult",
	RankA = "e20050_Missile",
	RankB = "e20050_Sniper",
	RankC = "e20050_MachineGun",
}

this.ClearRankRewardPopupList = {

	-- 報酬アイテム入手ポップアップID
	RankS = "reward_clear_s_rifle",
	RankA = "reward_clear_a_rocket",
	RankB = "reward_clear_b_sniper",
	RankC = "reward_clear_c_submachine",
}

this.After_SwitchOff = function()

	-- 敵兵停電挙動トラップＯＮ
	TppDataUtility.SetEnableDataFromIdentifier( "gntn_Trap", "SwitchLightArea", true , false )

	-- 管理棟内全監視カメラ無効化
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_02", false )
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_03", false )

	-- 停電ルートチェンジ

end

this.SwitchLight_ON = function()

	-- 敵兵停電ノーティストラップＯＦＦ
	TppDataUtility.SetEnableDataFromIdentifier( "gntn_Trap", "SwitchLightArea", false , false )

	-- 管理棟全監視カメラ有効化
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_02", true )
	TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_03", true )

	-- 停電復帰ルートチェンジ

end

this.SwitchLight_OFF = function()

	local phase = TppEnemy.GetPhase( this.CP_ID )

	-- 演出デモを見てなく、アラート以外の時のみ停電演出デモが流れる
	if( TppMission.GetFlag( "isSwitchLightDemo" ) == false )
		and ( phase == "sneak" or phase == "caution" or phase == "evasion" ) then

		local onDemoStart = function()

			-- 再生中の無線停止
			local radioDaemon = RadioDaemon:GetInstance()
			radioDaemon:StopDirect()
			-- 字幕の停止
			SubtitlesCommand.StopAll()
			-- カメラに映らない監視カメラを無効化する
			TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_02", false )

		   -- ボイラー室エフェクトＯＮ
		   TppDataUtility.CreateEffectFromGroupId( "wtrdrpbil" )
		   TppDataUtility.CreateEffectFromGroupId( "dstcomviw" )

		end
		local onDemoSkip = function()

			-- スキップ時、照明を消す
			TppGadgetUtility.SetSwitch( "gntn_center_SwitchLight", false )

		end
		local onDemoEnd = function()

			-- フラグ更新
			TppMission.SetFlag( "isSwitchLightDemo", true )
			-- 停電後処理
			this.After_SwitchOff()

			-- ボイラー室エフェクトＯＦＦ
			TppDataUtility.DestroyEffectFromGroupId( "wtrdrpbil" )
			TppDataUtility.DestroyEffectFromGroupId( "dstcomviw" )

		end
		TppDemo.Play( "Demo_SwitchLight" , { onStart = onDemoStart, onSkip = onDemoSkip ,onEnd = onDemoEnd } , {
			disableGame			= false,	--共通ゲーム無効を、キャンセル
			disableDamageFilter		= false,	--エフェクトは消さない
			disableDemoEnemies		= false,	--敵兵は消さないでいい
			disableEnemyReaction	= true,		--敵兵のリアクションを向こうかする
			disableHelicopter		= false,	--支援ヘリは消さないでいい
			disablePlacement		= false, 	--設置物は消さないでいい
			disableThrowing		= false	 	--投擲物は消さないでいい
		})
	-- 演出デモを見たか、アラートフェイズの時
	else
		-- 停電後処理
		this.After_SwitchOff()
	end
end

-- 監視カメラ破壊
this.Common_SecurityCameraBroken = function()
	local characterID = TppData.GetArgument( 1 )
	TppRadio.DisableIntelRadio( characterID )
end
-- 監視カメラ電源オフ
this.Common_SecurityCameraPowerOff = function()
	local characterID = TppData.GetArgument( 1 )
	TppRadio.DisableIntelRadio( characterID )
end
-- 監視カメラ電源オン
this.Common_SecurityCameraPowerOn = function()
	local characterID = TppData.GetArgument( 1 )
	TppRadio.EnableIntelRadio( characterID)
end

this.ContinueHostageRegisterList = {
	-- Tactical_Vehicle_WEST_000
	CheckList01 = {
		Pos						= "TppLightVehicleForBlock0000_Position",
		VehicleType				= "Vehicle",
		HostageRegisterPoint	= { "hostageWarpPoint0004", "hostageWarpPoint0005", "hostageWarpPoint0006", "hostageWarpPoint0007", },
	},
	-- Cargo_Truck_WEST_000
	CheckList02 = {
		Pos						= "TppWesternTruckForBlock0000_Position",
		VehicleType				= "Truck",
		HostageRegisterPoint	= { "hostageWarpPoint0000", "hostageWarpPoint0001", "hostageWarpPoint0002", "hostageWarpPoint0003", },
	},
	-- Cargo_Truck_WEST_001
	CheckList03 = {
		Pos						= "TppWesternTruckForBlock0001_Position",
		VehicleType				= "Truck",
		HostageRegisterPoint	= { "hostageWarpPoint0008", "hostageWarpPoint0009", "hostageWarpPoint0010", "hostageWarpPoint0011", },
	},
	-- Cargo_Truck_WEST_002
	CheckList04 = {
		Pos						= "TppWesternTruckForBlock0002_Position",
		VehicleType				= "Truck",
		HostageRegisterPoint	= { "hostageWarpPoint0012", "hostageWarpPoint0013", "hostageWarpPoint0014", "hostageWarpPoint0015", },
	},
}

---------------------------------------------------------------------------------
-- ミッション全体のメッセージ
---------------------------------------------------------------------------------
this.Messages = {
	Trap = {
		{ data = "Trap_HostageCallHelp1",			message = "Enter",							commonFunc = this.commonOnPlayerEnterHostageTrap, },		-- 捕虜に近付いた
		{ data = "Trap_HostageCallHelp1",			message = "Exit",							commonFunc = this.commonOnPlayerLeaveHostageTrap, },		-- 捕虜に近付いた
		{ data = "Trap_HostageCallHelp2",			message = "Enter",							commonFunc = this.commonOnPlayerEnterHostageTrap, },		-- 捕虜収用所に入った
		{ data = "Trap_HostageCallHelp3",			message = "Enter",							commonFunc = this.commonOnPlayerEnterHostageTrap, },		-- さらに捕虜に近付いた
		{ data = "Trap_WareHouse000",				message = "Enter",							commonFunc = this.commonOnEnterWareHouse000, },				-- 倉庫000に入った
		{ data = "Trap_WareHouse001",				message = "Enter",							commonFunc = this.commonOnEnterWareHouse001, },				-- 倉庫000に入った
		{ data = "Trap_HeliReachDemoPoint",			message = "Enter",							commonFunc = this.commonOnHelicopterReachDemoPoint, },		-- ヘリがクリアデモ再生位置まできた
		{ data = "Trap_BeforeHeliReachDemoPoint",	message = "Enter",							commonFunc = this.commonOnBeforeHelicopterReachDemoPoint, },		-- ヘリがクリアデモ再生位置直前まできた
		{ data = "Trap_ClaymoreRadio",				message = "Enter",							commonFunc = this.commonPlayerEnterClaymoreRadioTrap, },
		{ data = "Trap_ClaymoreRadio",				message = "Exit",							commonFunc = this.commonPlayerLeaveClaymoreRadioTrap, },
		{ data = "Trap_PowCarriedTalk0001",			message = "Enter",							commonFunc = this.commonPlayerEnterPowCarriedTalkTrap0001, },
		{ data = "Trap_PowCarriedTalk0002",			message = "Enter",							commonFunc = this.commonPlayerEnterPowCarriedTalkTrap0002, },
		{ data = "Trap_HostageRadio0000",			message = "Enter",							commonFunc = this.commonPlayerEnterHostageRadioTrap0000, },
		{ data = "Trap_Monologue_Hostage01",		message = "Enter", 							commonFunc = this.commonPlayerEnterPowCarriedTalkTrap0003 },
		{ data = "Trap_ClaymoreInfo",				message = "Enter", 							commonFunc = this.commonPlayClaymoreInfoRadio },
		{ data = "GeoTrapDamage",					message = "Enter",							commonFunc = this.commonOnEnterDeathTrap, },
		{ data = "GeoTrapDamage",					message = "Exit",							commonFunc = this.commonOnLeaveDeathTrap, },
	},
	Character = {
		-- プレイヤー
		{ data = "Player",							message = "RideHelicopterStart",			commonFunc = this.commonOnPlayerRideHelicopter, },			-- プレイヤーがヘリに乗った
		{ data = "Player",							message = "OnVehicleRide_End",				commonFunc = this.commonOnPlayerRideVehicle },				-- プレイヤーが乗り物（ヘリ以外）に乗った
		{ data = "Player",							message = "OnPickUpWeapon", 				commonFunc = this.commonOnPlayerPickingUpWeapon },			-- プレイヤーが武器を拾った
		{ data = "Player",							message = "TryPicking",						commonFunc = this.commonOnPickingDoor },					-- プレイヤーがピッキングドアを開けようとした
		{ data = "Player",							message = "OnEquipWeapon",					commonFunc = this.commonOnEquipWeapon },
		{ data = "Player",							message = "WeaponPutPlaced",				commonFunc = this.commonOnPlaceWeapon },
		{ data = "Player",							message = "OnAmmoStackEmpty",				commonFunc = this.commonOnAmmoStackEmpty },					-- 残弾が0になった
		{ data = "Player",							message = "e0010_rtrg0700",					commonFunc = function() TppRadio.Play( "Miller_RecoveryLifeAdvice" ) end },
		{ data = "Player",							message = "e0010_rtrg0710",					commonFunc = function() TppRadio.Play( "Miller_SpRecoveryLifeAdvice" ) end },
		{ data = "Player",							message = "e0010_rtrg0720",					commonFunc = function() TppRadio.Play( "Miller_RevivalAdvice" ) end },
		{ data = "Player",							message = "OnDamaged",						commonFunc = this.commonOnPlayerDamaged },
		-- { data = "Player", 							message = "SwitchPushButton", 				commonFunc = this.SwitchPuchButtonDemo },		--スイッチを押したときのカメラ
		{ data = "Player",							message = "NotifyStartWarningFlare",		commonFunc = function() this.OnMbDvcActCallRescueHeli("SupportHelicopter", "flare") end  },	--支援ヘリ要請
		{ data = "Player", 							message = "OnActivatePlaced", 				commonFunc = this.commonOnActivatePlaced },

		-- 敵兵
		{ data = this.CP_ID,						message = "Alert",							commonFunc = this.commonOnAlert },								-- CPがアラートになった
		{ data = this.CP_ID,						message = "Evasion",						commonFunc = this.commonOnEvasion },	-- Alert時用サイレン停止判定
		{ data = this.CP_ID,						message = "Caution",						commonFunc = this.commonOnCaution },	-- Alert時用サイレン停止判定
		-- { data = this.CP_ID,						message = "Sneak",							commonFunc = function() GZCommon.StopAlertSirenCheck() end },	-- Alert時用サイレン停止判定
		{ data = this.CP_ID,						message = "AntiAir",						commonFunc = this.ChangeAntiAir },								-- 対空行動への切り替え
		{ data = this.CP_ID,						message = "EndGroupVehicleRouteMove",		commonFunc = this.commonOnVehicleGroupActionEnd },

		-- 捕虜
		{ data = "Hostage_e20050_000",				message = "HostageLaidOnVehicle",			commonFunc = this.commonOnLaidHostage, },
		{ data = "Hostage_e20050_001",				message = "HostageLaidOnVehicle",			commonFunc = this.commonOnLaidHostage, },
		{ data = "Hostage_e20050_002",				message = "HostageLaidOnVehicle",			commonFunc = this.commonOnLaidHostage, },
		{ data = "Hostage_e20050_003",				message = "HostageLaidOnVehicle",			commonFunc = this.commonOnLaidHostage, },
		{ data = "Hostage_e20050_000",				message = "Dead",							commonFunc = this.commonOnDeadHostage, },
		{ data = "Hostage_e20050_001",				message = "Dead",							commonFunc = this.commonOnDeadHostage, },
		{ data = "Hostage_e20050_002",				message = "Dead",							commonFunc = this.commonOnDeadHostage, },
		{ data = "Hostage_e20050_003",				message = "Dead",							commonFunc = this.commonOnDeadHostage, },

		-- 支援ヘリ
		{ data = this.CHARACTER_ID_HELICOPTER,		message = "DescendToLandingZone",			commonFunc = this.commonOnHelicopterDescendToLZ, },
		{ data = this.CHARACTER_ID_HELICOPTER,		message = "Dead",							commonFunc = this.commonOnHelicopterDead, },
		{ data = this.CHARACTER_ID_HELICOPTER,		message = "DepartureToMotherBase",			commonFunc = this.commonOnHelicopterDeparture, },
		{ data = this.CHARACTER_ID_HELICOPTER,		message = "DamagedByPlayer",				commonFunc = this.commonHeliDamagedByPlayer },		-- プレイヤーから攻撃を受けた

		-- 監視カメラ
		{ data = "e20050_SecurityCamera_01",		message = "Dead",							commonFunc = this.Common_SecurityCameraBroken },
		{ data = "e20050_SecurityCamera_02",		message = "Dead",							commonFunc = this.Common_SecurityCameraBroken },
		{ data = "e20050_SecurityCamera_03",		message = "Dead",							commonFunc = this.Common_SecurityCameraBroken },
		{ data = "e20050_SecurityCamera_04",		message = "Dead",							commonFunc = this.Common_SecurityCameraBroken },
		{ data = "e20050_SecurityCamera_05",		message = "Dead",							commonFunc = this.Common_SecurityCameraBroken },
		{ data = "e20050_SecurityCamera_01",		message = "PowerOFF",						commonFunc = this.Common_SecurityCameraPowerOff },
		{ data = "e20050_SecurityCamera_02",		message = "PowerOFF",						commonFunc = this.Common_SecurityCameraPowerOff },
		{ data = "e20050_SecurityCamera_03",		message = "PowerOFF",						commonFunc = this.Common_SecurityCameraPowerOff },
		{ data = "e20050_SecurityCamera_04",		message = "PowerOFF",						commonFunc = this.Common_SecurityCameraPowerOff },
		{ data = "e20050_SecurityCamera_05",		message = "PowerOFF",						commonFunc = this.Common_SecurityCameraPowerOff },
		{ data = "e20050_SecurityCamera_01",		message = "PowerON",						commonFunc = this.Common_SecurityCameraPowerOn },
		{ data = "e20050_SecurityCamera_02",		message = "PowerON",						commonFunc = this.Common_SecurityCameraPowerOn },
		{ data = "e20050_SecurityCamera_03",		message = "PowerON",						commonFunc = this.Common_SecurityCameraPowerOn },
		{ data = "e20050_SecurityCamera_04",		message = "PowerON",						commonFunc = this.Common_SecurityCameraPowerOn },
		{ data = "e20050_SecurityCamera_05",		message = "PowerON",						commonFunc = this.Common_SecurityCameraPowerOn },
	},
	Enemy = {
		{ 											message = "MessageRoutePoint",				commonFunc = this.commonOnReachRouteNode },
		{											message = "HostageLaidOnVehicle",			commonFunc = this.commonOnLaidEnemy },	--捕虜・敵兵をヘリに乗せる
	},
	Gimmick = {
		-- 櫓
		{ data = "WoodTurret01",					message = "BreakGimmick",					commonFunc = this.commonOnNonTargetBroken },
		{ data = "WoodTurret02",					message = "BreakGimmick",					commonFunc = this.commonOnNonTargetBroken },
		{ data = "WoodTurret03",					message = "BreakGimmick", 					commonFunc = this.commonOnNonTargetBroken },
		{ data = "WoodTurret04",					message = "BreakGimmick", 					commonFunc = this.commonOnNonTargetBroken },
		{ data = "WoodTurret05",					message = "BreakGimmick", 					commonFunc = this.commonOnNonTargetBroken },
		-- 配電盤
		{ data = "gntn_center_SwitchLight",			message = "SwitchOn",						commonFunc = this.SwitchLight_ON },	--管理棟配電盤ＯＮ
		{ data = "gntn_center_SwitchLight",			message = "SwitchOff",						commonFunc = this.SwitchLight_OFF },	--管理棟配電盤ＯＦＦ
	},
	Mission = {
		{											message = "MissionFailure",					localFunc = "commonOnMissionFailure" },
		{											message = "MissionClear",					localFunc = "commonOnMissionClear" },
		{											message = "MissionRestart", 				localFunc = "commonMissionCleanUp" },		-- ミッションリスタート（メニュー）
		{											message = "MissionRestartFromCheckPoint",	localFunc = "commonMissionCleanUp" },		-- ミッションリスタート（チェックポイント）
		{											message = "ReturnTitle",					localFunc = "commonMissionCleanUp" },		-- タイトル画面へ（メニュー）
	},
	Timer = {
		{ data = "Timer_WaitHostageDialogue1",		message = "OnEnd",							commonFunc = this.commonOnFinishHostageDialogue1 },
		{ data = "Timer_WaitHostageDialogue2",		message = "OnEnd",							commonFunc = this.commonOnFinishHostageDialogue2 },
		{ data = "Timer_WaitClear",					message = "OnEnd",							commonFunc = this.commonCloseHelicopterDoor, },
		{ data = "Timer_CloseDoor",					message = "OnEnd",							commonFunc = this.commonFailMission, },
	},
	Subtitles = {
		{ data = "pprg1001_601010",					message = "SubtitlesEventMessage",			commonFunc = this.commonSub_PPRG1001_601010, },
		{ data = "pprg1001_611010",					message = "SubtitlesEventMessage",			commonFunc = this.commonSub_PPRG1001_611010, },
		{ data = "snes2000_191010",					message = "SubtitlesEventMessage",			commonFunc = function() TppMission.SetFlag( "isVehicleIntelRadioPlayed", true ) end },
	},
	Radio = {
		{ data = "e0050_esrg0100",					message = "RadioEventMessage",				commonFunc = this.commonOnHostageIntelRadioPlayed, },
		{ data = "e0050_rtrg0170",					message = "RadioEventMessage",				commonFunc = this.commonOnHostageIntelRadioPlayed, },
	},
	RadioCondition = {
--		{											message = "PlayerLifeLessThanHalf",			commonFunc = this.commonOnPlayerLifeLessThanHalf },
		{											message = "PlayerHurt",						commonFunc = function() TppRadio.Play( "Miller_CuarAdvice" ) end },
		{											message = "PlayerCureComplete",				commonFunc = function() TppRadio.Play( "Miller_SpRecoveryLifeAdvice" ) end },
--		{											message = "SuppressorIsBroken",				commonFunc = function() TppRadio.Play( "Miller_BreakSuppressor" ) end },
	},
	Terminal = {
		{											message = "MbDvcActOpenHeliCall",			commonFunc = this.OnMbDvcActOpenHeliCall },		-- ヘリコール画面を開いた
		{											message = "MbDvcActCallRescueHeli",			commonFunc = function() this.OnMbDvcActCallRescueHeli("SupportHelicopter", "MbDvc") end },	--支援ヘリ要請
	},
	Demo = {
		{ data = "p11_020003_000",					message="invis_cam",						commonFunc = function() TppEnemyUtility.PowerOnSecurityCameraByCharacterId( "e20050_SecurityCamera_03", false ) end },
		{ data = "p11_020003_000",					message="lightOff",							commonFunc = function() TppGadgetUtility.SetSwitch("gntn_center_SwitchLight",false) end },
		{ data = "p11_020003_000",					message="lightOn",							commonFunc = function() TppGadgetUtility.SetSwitch("gntn_center_SwitchLight",true) end },
		{ data = "p11_020003_000",					message="under",							commonFunc = function() TppWeatherManager:GetInstance():RequestTag("under", 0 ) end },
		{ data = "p11_020003_000",					message="default",							commonFunc = function() TppWeatherManager:GetInstance():RequestTag("default", 0 ) end },
	},
}

---------------------------------------------------------------------------------
-- Sequences
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------

this.tmpBestRank = 0
this.tmpRewardNum = 0				-- 達成率（報酬獲得数）表示用

-- ミッション起動前
this.Seq_MissionPrepare = {

	OnEnter = function( manager )

		this.tmpBestRank = GZCommon.CheckClearRankReward( this.missionID, this.ClearRankRewardList )

		local sequence = TppSequence.GetCurrentSequence()							-- 現在のシーケンスを取得する
		if	sequence == "Seq_MissionPrepare" or										-- シーケンスがMissionPrepare、または
			manager:IsStartingFromResearvedForDebug() then							-- メニューからスキップされてきていたら
			this.onCommonMissionSetup()												-- ミッション初期化処理（ミッション中1回だけ）
		end

		-- これまでに獲得している報酬数を保持
		local uiCommonData = UiCommonDataManager.GetInstance()
		this.tmpRewardNum = uiCommonData:GetRewardNowCount( this.missionID )
		Fox.Log("***e20050_MissionPrepare.tmpRewardNum_IS___"..this.tmpRewardNum)

		TppSequence.ChangeSequence( "Seq_MissionSetup" )	-- 次のシーケンスへ

	end,
}

-- ミッション準備
this.Seq_MissionSetup = {

	OnEnter = function()

		TppSequence.ChangeSequence( "Seq_LoadOpeningDemo" )	-- 次のシーケンスへ

	end,

}

---------------------------------------------------------------------------------
this.Seq_LoadOpeningDemo = {

	OnEnter = function()

		-- オープニングデモロード：グアンタナモはデモブロックは別パッケージなのでロードする必要がある。
		this.commonLoadDemoBlock()

	end,

	OnUpdate = function()

		-- デモブロックをロードするまで待機
		if( IsDemoAndEventBlockActive() ) then							-- デモブロックとイベントブロックがアクティブになったら
			TppSequence.ChangeSequence( "Seq_OpeningShowTransition" )		-- 次のシーケンスへ
		end

	end,

}

---------------------------------------------------------------------------------ミッション開始テロップ
this.Seq_OpeningShowTransition = {

	OnEnter = function()

		local localChangeSequence = {
			onOpeningBgEnd = function()
				TppSequence.ChangeSequence( "Seq_OpeningDemo" ) --テロップの絵が消えるくらいで関数を実行
			end,
		}

		TppUI.ShowTransition( "opening", localChangeSequence )
		TppMusicManager.PostJingleEvent( "MissionStart", "Play_bgm_gntn_op_default" )

	end,

}

---------------------------------------------------------------------------------
this.Seq_OpeningDemo = {

	Messages = {
		Demo = {
			{ data = "p12_040000_000",	message = "marking1",	localFunc = "localOnDemoMessage_marking1", },
			{ data = "p12_040000_000",	message = "marking2",	localFunc = "localOnDemoMessage_marking2", },
		},
	},

	OnEnter = function( manager )

		-- 邪魔な敵兵を消しておく
		TppCharacterUtility.SetEnableCharacterId( "Enemy_DisableWhenDemo", false )

		TppDemo.Play( "Demo_Opening", {
			onStart = function()

				TppUI.FadeIn( 0.7 )

				local commonDataManager = UiCommonDataManager.GetInstance()
				if commonDataManager ~= NULL then
					local luaData = commonDataManager:GetUiLuaExportCommonData()
					if luaData ~= NULL then
						luaData:RegisterDemoMarkerHandleId( "gntn_area01_antiAirGun_000" )
						luaData:RegisterDemoMarkerHandleId( "gntn_area01_antiAirGun_001" )
					end
				end

			end,
			onSkip = function()
				TppMission.SetFlag( "isOpeningDemoSkipped", true )
			end,
			onEnd = function()

				local commonDataManager = UiCommonDataManager.GetInstance()
				if commonDataManager ~= NULL then
					local luaData = commonDataManager:GetUiLuaExportCommonData()
					if luaData ~= NULL then
						luaData:InitDemoMarkerHandleIds()
					end
				end

				TppMissionManager.SaveGame( 5 )						-- チェックポイントセーブ
				TppSequence.ChangeSequence( "Seq_DestroyTarget1" )	-- 次のシーケンスへ

			end, } )

	end,

	localOnDemoMessage_marking1 = function()

		-- マーカーをつける
		this.commonEnableMarker( "gntn_area01_antiAirGun_000" )
		this.commonSetAntiAirGunsMarkFlag( "gntn_area01_antiAirGun_000", true )

		-- 音を鳴らす
		local charaObj = Ch.FindCharacterObjectByCharacterId( "gntn_area01_antiAirGun_000" )
		local position = charaObj:GetPosition()
		TppSoundDaemon.PostEvent3D( 'Play_Test_sfx_s_enemytag01', position )

	end,

	localOnDemoMessage_marking2 = function()

		-- 消していた敵兵を出しておく
		TppCharacterUtility.SetEnableCharacterId( "Enemy_DisableWhenDemo", true )

		-- マーカーをつける
		this.commonEnableMarker( "gntn_area01_antiAirGun_001" )
		this.commonSetAntiAirGunsMarkFlag( "gntn_area01_antiAirGun_001", true )

		-- 音を鳴らす
		local charaObj = Ch.FindCharacterObjectByCharacterId( "gntn_area01_antiAirGun_001" )
		local position = charaObj:GetPosition()
		TppSoundDaemon.PostEvent3D( 'Play_Test_sfx_s_enemytag01', position )

	end,

}

---------------------------------------------------------------------------------対空機関砲を壊す
this.Seq_DestroyTarget1 = {

	Messages = {
		Character = {
			-- CP
			{ data = this.CP_ID,							message = "ConversationEnd",		localFunc = "localOnConversationEnd" },

			-- 乗り物
			{ data = "Armored_Vehicle_WEST_000",			message = "StrykerDestroyed",		commonFunc = this.commonOnNonTargetBroken },
			{ data = "Tactical_Vehicle_WEST_000",			message = "VehicleBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "Tactical_Vehicle_WEST_001",			message = "VehicleBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_000",				message = "VehicleBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_001",				message = "VehicleBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_002",				message = "VehicleBroken",			commonFunc = this.commonOnNonTargetBroken },
		},
		Gimmick = {
			-- 対空機関砲
			{ data = "gntn_area01_antiAirGun_000",			message = "AntiAircraftGunBroken",	localFunc = "localOnTargetBroken" },
			{ data = "gntn_area01_antiAirGun_001",			message = "AntiAircraftGunBroken",	localFunc = "localOnTargetBroken" },
			{ data = "gntn_area01_antiAirGun_002",			message = "AntiAircraftGunBroken",	localFunc = "localOnTargetBroken" },
			{ data = "gntn_area01_antiAirGun_003",			message = "AntiAircraftGunBroken",	localFunc = "localOnTargetBroken" },
		},
		Timer = {
			{ data = "Timer_StopRadio",						message = "OnEnd", 					localFunc = "localWaitRadioPlayUntilFlagChange" },
			{ data = "Timer_StartSilen",					message = "OnEnd", 					localFunc = "localPlaySilenSound" },
			{ data = "Timer_StartRadio",					message = "OnEnd", 					localFunc = "localPlayCautionRadio" },
			{ data = "Timer_CautionPhase",					message = "OnEnd", 					localFunc = "localChangePhaseCaution" },
			{ data = "Timer_BackGroundRadio1",				message = "OnEnd", 					localFunc = "localPlayBackGroundRadio" },
			{ data = "Timer_BackGroundRadio1AfterCaution",	message = "OnEnd", 					localFunc = "localEnableRadioPlay" },
			{ data = "Timer_BackGroundRadio2",				message = "OnEnd", 					commonFunc = this.commonPlayBackGroundRadio2 },
			{ data = "Timer_SequenceChange",				message = "OnEnd", 					localFunc = "localChangeSequence" },
			{ data = "Timer_StartVehicle",					message = "OnEnd", 					localFunc = "localStartVehicle" },
			{ data = "Timer_MarkAntiAirGun",				message = "OnEnd", 					localFunc = "localMarkAntiAirGun" },
		},
		Trap = {
			{ data = "Trap_ForceCaution0000",				message = "Enter",					localFunc = "localPlaySilenSound", },
			{ data = "Trap_MissionBackgroundRadio",			message = "Enter",					commonFunc = this.commonStartPlayBackGroundRadio2, },
		},
	},

	OnEnter = function()

		-- 無線関連
		if TppMission.GetFlag( "isOpeningDemoSkipped" ) == true then		-- デモがスキップされていたら

			TppMission.SetFlag( "isMissionStartRadioPlayed", true )				-- 無線を流したことにする
			TppRadio.DelayPlay( "Radio_MissionStartForSkip", "mid", nil, {		-- ミッション開始無線を流す
				onEnd = function()
					TppMusicManager.PostJingleEvent( 'SingleShot', 'Stop_bgm_gntn_op_default' )
					GkEventTimerManager.Start( "Timer_BackGroundRadio1", 15 )	-- ミッション背景無線再生用タイマーを回す
				end } )

		else

			if TppMission.GetFlag( "isMissionStartRadioPlayed" ) == false then	-- まだ無線を流していなかったら
				TppMission.SetFlag( "isMissionStartRadioPlayed", true )				-- 無線を流したことにする
				TppRadio.DelayPlay( "Radio_MissionStart", "short", "end", {							-- ミッション開始無線を流す
					onEnd = function()
						TppMusicManager.PostJingleEvent( 'SingleShot', 'Stop_bgm_gntn_op_default' )
						GkEventTimerManager.Start( "Timer_BackGroundRadio1", 5 )		-- ミッション背景無線再生用タイマーを回す
					end } )
			end

		end

		-- 任意無線を登録
		TppRadio.RegisterOptionalRadio( "OptionalRadio_001" )

		-- 汎用無線登録
		TppRadioConditionManagerAccessor.Register( "Tutorial", TppRadioConditionTutorialPlayer{ time = 1.5 } )	  --コンポーネントの登録
		TppRadioConditionManagerAccessor.Register( "Basic", TppRadioConditionPlayerBasic{ time = 0.3 } )

		-- 諜報無線を設定
		this.commonEnableAllIntelRadio()
		-- 諜報無線セットアップ
		this.SetIntelRadio()

		-- UI関連
		-- マーカーを表示する
		TppUI.ShowAllMarkers()

		-- 中目標を変更する
		local commonDataManager = UiCommonDataManager.GetInstance()
		if commonDataManager ~= NULL then
			local luaData = commonDataManager:GetUiLuaExportCommonData()
			if luaData ~= NULL then
				luaData:SetCurrentMissionSubGoalNo(1)
			end
		end

		-- デフォルトRVを設定
		TppSupportHelicopterService.SetDefaultRendezvousPointMarker( "RV_SeaSide" )

		-- タイマー関連
		-- タイマースタート
		GkEventTimerManager.Start( "Timer_StopRadio", 60 )			-- ミッション背景説明無線用タイマーを一時停止するタイマースタート
		GkEventTimerManager.Start( "Timer_StartSilen", 85 )			-- 警戒フェイズ移行タイマースタート
		GkEventTimerManager.Start( "Timer_StartVehicle", 300 )		-- ビークル発進タイマースタート
		GkEventTimerManager.Start( "Timer_MarkAntiAirGun", 0.5 )	-- 対空兵器マーキングタイマースタート

		-- サウンド関連
		-- 対空機関砲が残り少なくなったらBGMを変える
		local targetCount = this.commonCountAliveAntiAirGun()		-- 残りの対空機関砲を数える
		if targetCount < 2 then										-- 残りの対空機関砲が2個以下なら
			TppMusicManager.StartSceneMode()
			TppMusicManager.PlaySceneMusic( "Play_bgm_e20050_count" )
			TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20050_aircraftgun' )
		end

		-- 敵兵関連
		-- オープニングデモ中に消していた敵兵を一応再出現させておく
		TppCharacterUtility.SetEnableCharacterId( "Enemy_DisableWhenDemo", true )

	end,

	localMarkAntiAirGun = function()

		-- 対空機関砲をターゲットにする
		for i, characterId in ipairs( this.antiAirGuns ) do
			if	this.commonGetDestroyFlag( characterId ) == false and
				this.commonIsAntiAirGunsMarked( characterId ) == false then

				this.commonEnableMarker( characterId )	-- マーカーを有効にする
				this.commonSetAntiAirGunsMarkFlag( characterId, true )

				-- 音を鳴らす
				local charaObj = Ch.FindCharacterObjectByCharacterId( characterId )
				local position = charaObj:GetPosition()
				TppSoundDaemon.PostEvent3D( 'Play_Test_sfx_s_enemytag01', position )


				GkEventTimerManager.Start( "Timer_MarkAntiAirGun", 0.5 )
				break

			end
		end

	end,

	localStartVehicle = function()

		if TppMission.GetFlag( "isLightVechicleStarted" ) == false then

			TppData.Enable( "Tactical_Vehicle_WEST_001" )	-- ビークルを出現させる
			TppData.Enable( "e20050_uss_driver0001" )		-- ビークルの乗員を出現させる
			TppData.Enable( "e20050_uss_driver0004" )		-- ビークルの乗員を出現させる
			TppData.Enable( "e20050_uss_driver0005" )		-- ビークルの乗員を出現させる
			TppData.Enable( "e20050_uss_driver0006" )		-- ビークルの乗員を出現させる

			TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0079", { noForceUpdate = true, }  )
			TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0080", { noForceUpdate = true, }  )
			TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0081", { noForceUpdate = true, }  )
			TppEnemy.DisableRoute( this.CP_ID, "e20050_c01_route0082", { noForceUpdate = true, }  )

			-- アナウンスログ表示
			local commonDataManager = UiCommonDataManager.GetInstance()
			if commonDataManager ~= NULL then
				local luaData = commonDataManager:GetUiLuaExportCommonData()
				if luaData ~= NULL then
					local hudCommonData = HudCommonDataManager.GetInstance()				-- とりあえずマネージャーを取得
					hudCommonData:AnnounceLogViewLangId( "announce_enemyIncrease" )			-- 増援アナウンスログ
				end
			end

			TppMission.SetFlag( "isLightVechicleStarted", true )

		end

	end,

	-- ミッション背景説明無線用のタイマーを一度止める
	localWaitRadioPlayUntilFlagChange = function()

		TppMission.SetFlag( "isBackGroundRadioWait", true )

	end,

	localEnableRadioPlay = function()

		TppMission.SetFlag( "isBackGroundRadioWait", false )

	end,

	-- ミッション背景説明無線を流す
	localPlayBackGroundRadio = function()

		if TppMission.GetFlag( "isBackGroundRadioWait" ) == true then
			GkEventTimerManager.Start( "Timer_BackGroundRadio1", 5 )
			return
		end

		local player = TppPlayerUtility.GetLocalPlayerCharacter()
		local pos = player:GetPosition()
		if	TppCharacterUtility.GetCurrentPhaseName() ~= "Alert" and						-- アラートではない、かつ
			TppEnemyUtility.GetNumberOfActiveSoldier( pos, 40 ) == 0 then					-- 周りに敵兵がいなかったら

			if TppMission.GetFlag( "isMissionBackgroundRadio1Played" ) == false then			-- まだミッション背景無線その1を再生していなかったら

				TppMission.SetFlag( "isMissionBackgroundRadio1Played", true )						-- ミッション背景無線その1を再生した事を記録
				TppRadio.DelayPlayEnqueue( "Radio_MissionBackground1", "long","both", {										-- ミッション背景無線その1を再生する
					onEnd = function()																-- 無線終了時に
						GkEventTimerManager.Start( "Timer_BackGroundRadio1", 5 )								-- ミッション背景無線その2を再生するためのタイマーをセット
					end } )

			elseif TppMission.GetFlag( "isMissionBackgroundRadio2Played" ) == false then		-- ミッション背景無線その1を再生していてその2を再生していなかったら

				TppMission.SetFlag( "isMissionBackgroundRadio2Played", true )						-- ミッション背景無線その2を再生した事を記録

				TppRadio.DelayPlayEnqueue( "Radio_Conjunction2", "long","begin", {
					onEnd = function()
						TppRadio.DelayPlay( "Radio_MissionBackground2", nil, "end", {									-- ミッション背景無線その2を再生する
							onEnd = function()																-- 無線終了時に
								GkEventTimerManager.Start( "Timer_BackGroundRadio1", 5 )						-- ミッション背景無線その2を再生するためのタイマーをセット
							end } )
					end } )

			elseif TppMission.GetFlag( "isMissionBackgroundRadio4Played" ) == false then		-- ミッション背景無線その3を再生していてその4を再生していなかったら

				this.commonPlayMissionBackgroundRadio4()

			end

		else																				-- それ以外だったら
			GkEventTimerManager.Start( "Timer_BackGroundRadio1", 5 )							-- またタイマーを回す
		end

	end,

	-- ターゲットが壊れた
	localOnTargetBroken = function()

		local characterId = TppData.GetArgument(1)				-- 壊れたターゲットのCharacterIDを取得

		this.commonDestroyObject( characterId )					-- ターゲットが壊れたことにする

		-- 残りターゲット数によって分岐
		local targetCount = this.commonCountAliveAntiAirGun()		-- 残りの対空機関砲を数える
		if targetCount < 2 then									-- 残り1個以下（シーケンス遷移条件達成）なら

			-- BGM変更。対空機関砲の破壊直後～装甲車出現～交戦するまで
			TppMusicManager.StartSceneMode()
			TppMusicManager.PlaySceneMusic( "Play_bgm_e20050_count" )
			TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20050_aircraftgun' )

			-- チェックポイントセーブ
			-- プレイヤーの現在地から復帰位置を決定する
			if ( GZCommon.PlayerAreaName == "WareHouse" ) then
				TppMissionManager.SaveGame("20")
			elseif ( GZCommon.PlayerAreaName == "Asylum" ) then
				TppMissionManager.SaveGame("21")
			elseif ( GZCommon.PlayerAreaName == "EastCamp" ) then
				TppMissionManager.SaveGame("22")
			elseif ( GZCommon.PlayerAreaName == "WestCamp" ) then
				TppMissionManager.SaveGame("23")
			elseif ( GZCommon.PlayerAreaName == "Heliport" ) then
				TppMissionManager.SaveGame("24")
			elseif ( GZCommon.PlayerAreaName == "ControlTower_East" ) then
				TppMissionManager.SaveGame("25")
			elseif ( GZCommon.PlayerAreaName == "ControlTower_West" ) then
				TppMissionManager.SaveGame("26")
			elseif ( GZCommon.PlayerAreaName == "SeaSide" ) then
				TppMissionManager.SaveGame("27")
			else
				Fox.Warning(" commonSequenceSaveAfterContactDemo:GZCommon.PlayerAreaName illegality:".. GZCommon.PlayerAreaName )
				TppMissionManager.SaveGame("24")									-- 保険処理としてSave
			end

			-- TppMissionManager.SaveGame( 20 )									-- チェックポイントセーブ

			TppSequence.ChangeSequence( "Seq_DestroyTarget2" )					-- 次のシーケンスへ

		elseif targetCount == 2 then										-- 残り2個なら

			TppRadio.DelayPlay( "Radio_AntiAirGunDestroyedLastOne", "short" )	-- 残り1個無線を流す

			GkEventTimerManager.Stop( "Timer_BackGroundRadio1" )				-- ミッション背景説明無線1を停止

		else																-- それ以外なら
			TppRadio.Play( "Radio_AntiAirGunDestroyed" )						-- 汎用破壊無線を流す
		end

		-- アナウンスログを出す
		local hudCommonData = HudCommonDataManager.GetInstance()											-- とりあえずマネージャーを取得
		if hudCommonData ~= nil then
			local targetNum = 4 - this.commonCountAliveAntiAirGun()													-- 破壊したターゲットの数を取得
			local maxTargetNum = 3																				-- ターゲットの最大数を取得
			hudCommonData:AnnounceLogViewLangId( "announce_mission_goal_num", targetNum, maxTargetNum )			-- アナウンスログ表示。目標達成 [ targetNum / maxTargetNum ]
		end

	end,

	-- サイレン鳴らす
	localPlaySilenSound = function()

		GkEventTimerManager.Stop( "Timer_StartSilen")		-- タイマー停止
		GkEventTimerManager.Start( "Timer_StartRadio", 5 )

	end,

	-- 無線流す
	localPlayCautionRadio = function()

		GkEventTimerManager.Stop( "Timer_StartRadio")			-- タイマー停止
		GkEventTimerManager.Start( "Timer_CautionPhase", 10 )

		-- 警戒無線流す
		if TppMission.GetFlag( "isCautionRadioPlayed" ) == false then	-- まだ無線を流していなかったら
			TppMission.SetFlag( "isCautionRadioPlayed", true ) 				-- 無線を流した事を記録
			TppRadio.Play( "Radio_Caution", {								-- 警戒無線を流す
				onEnd = function()

				end } )
		end

	end,

	-- 警戒フェイズへ
	localChangePhaseCaution = function()

		GkEventTimerManager.Stop( "Timer_CautionPhase")				-- タイマー停止
		if TppMission.GetFlag( "isAntiAirRouteSet" ) == false then	-- まだkeep cautionになっていなかったら

			this.commonSetPhaseToKeepCaution()							-- keep cautionにする
			TppMissionManager.SaveGame( 10 )							-- チェックポイントセーブ
			TppMission.SetFlag( "isAntiAirRouteSet", true )				-- keep cautionになった事を記録

			GkEventTimerManager.Start( "Timer_BackGroundRadio1AfterCaution", 30 )	-- ミッション背景無線再生用タイマーを回す

		end

	end,

}

---------------------------------------------------------------------------------装甲車を壊す
this.Seq_DestroyTarget2 = {

	Messages = {
		Character = {
			-- プレイヤー
			{ data = "Player",						message = "OnPickUpWeapon", 				localFunc = "localOnPlayerPickingUpWeapon" }, -- プレイヤーが武器を拾った

			-- 装甲車
			{ data = "Armored_Vehicle_WEST_000",	message = "StrykerDestroyed",				localFunc = "localOnStrykerBroken" },
			{ data = "Armored_Vehicle_WEST_000",	message = "VehicleMessageRoutePoint",		localFunc = "localOnStrykerRoutePoint" },
			{ data = "Tactical_Vehicle_WEST_000",	message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Tactical_Vehicle_WEST_001",	message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_000",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_001",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_002",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
		},
		Gimmick = {
			-- 対空機関砲
			{ data = "gntn_area01_antiAirGun_000",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_001",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_002",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_003",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
		},
		Terminal = {
			-- 端末
			{ 										message = "MbDvcActFocusMapIcon", 			localFunc = "localOnFocusMapIcon" },			-- マップアイコンにフォーカスした
		},
		Timer = {
			{ data = "Timer_SequenceChange",		message = "OnEnd", 							localFunc = "localChangeSequence" },
			{ data = "Timer_BgmChange",				message = "OnEnd", 							localFunc = "localChangeMusicIfAlert" },
			{ data = "Timer_PlayVehicleRadio",		message = "OnEnd", 							localFunc = "localPlayVehicleRadio" },
			{ data = "Timer_BackGroundRadio2",		message = "OnEnd", 							commonFunc = this.commonPlayBackGroundRadio2 },
		},
		Trap = {
			{ data = "Trap_VehicleCrash",			message = "Enter",							localFunc = "localOnVehicleEnterMinefield", },
			{ data = "Trap_VehicleCrash",			message = "Exit",							localFunc = "localOnVehicleLeaveMinefield", },
			{ data = "Trap_VehicleCrash_Player",	message = "Enter",							localFunc = "localOnPlayerEnterMinefield", },
			{ data = "Trap_VehicleCrash_Player",	message = "Exit",							localFunc = "localOnPlayerLeaveMinefield", },
			{ data = "Trap_MissionBackgroundRadio",	message = "Enter",							commonFunc = this.commonStartPlayBackGroundRadio2, },
		},
	},

	OnEnter = function()

		-- 敵兵関連
		-- 装甲車をターゲットに加える
		if TppMission.GetFlag( this.destroyFlagMap["Armored_Vehicle_WEST_000"] ) == false then
			for i, antiAirGunCharacterId in ipairs( this.antiAirGuns ) do	-- 対空機関砲に付けていたターゲット用のマーカーを無効にする
				this.commonDisableMarker( antiAirGunCharacterId )
			end
			this.commonEnableMarker( "Armored_Vehicle_WEST_000" )	-- マーカーを有効にする
		end

		-- 敵兵と機銃装甲車を有効に
		TppData.Enable( "Armored_Vehicle_WEST_000" )		-- 装甲車を出現させる
		TppData.Enable( "e20050_uss_driver0000" )			-- ドライバーを出現させる

		-- リスポーン時の武器変更設定
		TppCommandPostObject.GsAddRespawnRandomWeaponId( this.CP_ID, "WP_sg01_v00", 15 )
		TppCommandPostObject.GsAddRespawnRandomWeaponId( this.CP_ID, "WP_ms02", 10 )

		-- タイマー関連
		GkEventTimerManager.Start( "Timer_BgmChange", 1 )		-- BGM変更タイマー開始

		-- 無線関連
		-- 任意無線登録
		TppRadio.RegisterOptionalRadio( "OptionalRadio_002" )
		-- 機銃装甲車の諜報無線を有効に
		TppRadio.EnableIntelRadio( "Armored_Vehicle_WEST_000" )
		-- 増援が来たよ無線を再生
		TppRadio.DelayPlay( "Radio_Reinforcements", "mid", nil, {
			onEnd = function()

				TppRadio.DelayPlay( "Radio_Reinforcements2", "long", nil, {
					onStart = function()

						-- UI関連
						-- ミッション説明を変更する
						local commonDataManager = UiCommonDataManager.GetInstance()
						if commonDataManager ~= NULL then
							local luaData = commonDataManager:GetUiLuaExportCommonData()
							if luaData ~= NULL then

								-- ストーリー番号を変更
								luaData:SetMisionInfoCurrentStoryNo(1)									-- ストーリー番号を0から1に

								-- 中目標を変更する
								luaData:SetCurrentMissionSubGoalNo(2)

								-- アナウンスログ表示
								local hudCommonData = HudCommonDataManager.GetInstance()				-- とりあえずマネージャーを取得
								hudCommonData:AnnounceLogViewLangId( "announce_mission_info_update" )	-- ミッション情報更新アナウンスログを表示
								hudCommonData:AnnounceLogViewLangId( "announce_map_update" )			-- マップ更新アナウンスログ
								hudCommonData:AnnounceLogViewLangId( "announce_enemyIncrease" )			-- 増援アナウンスログ

								luaData:DisableMissionPhotoId(10)
								luaData:DisableMissionPhotoId(20)
								luaData:DisableMissionPhotoId(30)
								luaData:DisableMissionPhotoId(40)

							end
						end

					end, } )

			end } )
		-- 諜報無線セットアップ
		this.SetIntelRadio()

		-- デフォルトRVを設定
		TppSupportHelicopterService.SetDefaultRendezvousPointMarker( "RV_SeaSide" )

	end,

	-- 装甲車の攻略法無線を流す
	localPlayVehicleRadio = function()

		if	this.CounterList.currentWeapon == "WP_ar00_v03" or
			this.CounterList.currentWeapon == "WP_ar00_v03b" or
			this.CounterList.currentWeapon == "WP_ar00_v01" or
			this.CounterList.currentWeapon == "WP_sr01_v00" then

			TppRadio.Play( "Radio_ArmoredVehicle" )

		end

	end,

	localOnFocusMapIcon = function()

		local arg1 = TppEventSequenceManagerCollector.GetMessageArg( 0 )
		if StringId.IsEqual32( arg1, "Armored_Vehicle_WEST_000" ) then
			TppRadio.DelayPlay( "Radio_Target", "mid" )
		end

	end,

	-- アラート曲に変更する
	localChangeMusicIfAlert = function()

		local phaseName = TppCharacterUtility.GetCurrentPhaseName()

		local player = TppPlayerUtility.GetLocalPlayerCharacter()
		local playerPosition
		if player ~= nil then
			playerPosition = player:GetPosition()
		else
			return
		end

		local vehicle = Ch.FindCharacterObjectByCharacterId( "Armored_Vehicle_WEST_000" )
		local vehiclePosition
		if vehicle ~= nil then
			vehiclePosition = vehicle:GetPosition()
		else
			return
		end

		local length = (playerPosition - vehiclePosition):GetLength()

		if	phaseName == "Alert" and				-- 現在のフェイズがアラートだったら、かつ
			length < 65 then						-- プレイヤーと機銃装甲車の距離が50m以下だったら

			-- BGM変更。装甲車と交戦
			TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20050_boss' )

			-- 装甲車の攻略法無線を流すためのタイマースタート
			GkEventTimerManager.Start( "Timer_PlayVehicleRadio", 10 )

		else										-- それ以外だったら
			GkEventTimerManager.Stop( "Timer_BgmChange")			-- タイマー停止
			GkEventTimerManager.Start( "Timer_BgmChange", 1 )		-- タイマー開始
		end

	end,

	-- プレイヤーが地雷原に入った
	localOnPlayerEnterMinefield = function()

		TppMission.SetFlag( "isPlayerInMinefield", true )

		if TppMission.GetFlag( "isVehicleInMinefield" ) == true then
			this.Seq_DestroyTarget2.localSetVehicleCrashActionMode()
		end

	end,

	-- プレイヤーが地雷原から出た
	localOnPlayerLeaveMinefield = function()

		TppMission.SetFlag( "isPlayerInMinefield", false )

	end,

	-- 機銃装甲車が地雷原に入った
	localOnVehicleEnterMinefield = function()

		TppMission.SetFlag( "isVehicleInMinefield", true )

		if TppMission.GetFlag( "isPlayerInMinefield" ) == true then
			this.Seq_DestroyTarget2.localSetVehicleCrashActionMode()
		end

	end,

	-- 機銃装甲車が地雷原から出た
	localOnVehicleLeaveMinefield = function()

		TppMission.SetFlag( "isVehicleInMinefield", false )

	end,

	-- 機銃装甲車をクラッシュするようにして強制ルート行動させる
	localSetVehicleCrashActionMode = function()

		TppCommandPostObject.GsSetGroupVehicleRoute( this.CP_ID, "Armored_Vehicle_WEST_000", "e20050_c01_route_vehicle0003", 0 )	-- 機銃装甲車のルートをクラッシュルートに
		TppEnemyUtility.SetForceRouteMode( "e20050_uss_driver0000", true )													-- ドライバーを強制ルートモードに
		TppVehicleUtility.SetCrashActionMode( "Armored_Vehicle_WEST_000", true )											-- 機銃装甲車をクラッシュモードに

	end,

	-- 機銃装甲車がクラッシュしないようにして通常ルートに戻す
	localUnsetVehicleCrashActionMode = function()

		TppVehicleUtility.SetCrashActionMode( "Armored_Vehicle_WEST_000", false )
		TppCommandPostObject.GsSetGroupVehicleRoute( this.CP_ID, "Armored_Vehicle_WEST_000", "e20050_c01_route_vehicle0001", 0 )
		TppEnemyUtility.SetForceRouteMode( "e20050_uss_driver0000", false )

	end,

	-- 装甲車がルートポイントに到達した
	localOnStrykerRoutePoint = function()

		local vehicleCharacterId = TppData.GetArgument(1)	-- 車両のCharacterID
		local characterIds = TppData.GetArgument(2)			-- 車両に乗っているCharacterID
		local routeId = TppData.GetArgument(3)				-- ルートID
		local routeNodeIndex = TppData.GetArgument(4)		-- ルートノードのインデックス

		if 	routeId == GsRoute.GetRouteId( "e20050_c01_route_vehicle0000" ) and
			routeNodeIndex == 4 then

			-- ルートチェンジさせる
			TppCommandPostObject.GsSetGroupVehicleRoute( this.CP_ID, vehicleCharacterId, "e20050_c01_route_vehicle0001", 0 )
			TppRadio.EnableIntelRadio( "Armored_Vehicle_WEST_000" )

		elseif	routeId == GsRoute.GetRouteId( "e20050_c01_route_vehicle0003" ) and
				routeNodeIndex == 1 then

			this.Seq_DestroyTarget2.localUnsetVehicleCrashActionMode()

		end

	end,

	-- 装甲車が壊れた
	localOnStrykerBroken = function()

		local characterId = TppData.GetArgument(1)								-- 壊れたターゲットのCharacterIDを取得
		this.commonDestroyObject( characterId )									-- ターゲットが壊れた事にする

		if this.commonGetDestroyFlag( "Armored_Vehicle_WEST_000" ) == true then	-- 装甲車がちゃんと壊れていたら

			-- アナウンスログを出す
			local hudCommonData = HudCommonDataManager.GetInstance()												-- とりあえずマネージャーを取得
			if hudCommonData ~= nil then
				hudCommonData:AnnounceLogViewLangId( "announce_mission_goal" )									-- アナウンスログ表示。目標達成
			end

			-- シーケンス変更処理
			-- チェックポイントセーブ
			-- プレイヤーの現在地から復帰位置を決定する
			if ( GZCommon.PlayerAreaName == "WareHouse" ) then
				TppMissionManager.SaveGame("30")
			elseif ( GZCommon.PlayerAreaName == "Asylum" ) then
				TppMissionManager.SaveGame("31")
			elseif ( GZCommon.PlayerAreaName == "EastCamp" ) then
				TppMissionManager.SaveGame("32")
			elseif ( GZCommon.PlayerAreaName == "WestCamp" ) then
				TppMissionManager.SaveGame("33")
			elseif ( GZCommon.PlayerAreaName == "Heliport" ) then
				TppMissionManager.SaveGame("34")
			elseif ( GZCommon.PlayerAreaName == "ControlTower_East" ) then
				TppMissionManager.SaveGame("35")
			elseif ( GZCommon.PlayerAreaName == "ControlTower_West" ) then
				TppMissionManager.SaveGame("36")
			elseif ( GZCommon.PlayerAreaName == "SeaSide" ) then
				TppMissionManager.SaveGame("37")
			else
				Fox.Warning(" commonSequenceSaveAfterContactDemo:GZCommon.PlayerAreaName illegality:".. GZCommon.PlayerAreaName )
				TppMissionManager.SaveGame("34")	-- 保険処理としてSave
			end

			TppSequence.ChangeSequence( "Seq_CallSupportHelicopter" )				-- 次のシーケンスへ

		end

	end,

	-- 対空機関砲を壊した
	localOnAntiAirGunBroken = function()

		local characterId = TppData.GetArgument(1)		-- 壊れたターゲットのCharacterIDを取得
		this.commonDestroyObject( characterId )			-- 対空機関砲が壊れた処理をする
		TppRadio.Play( "Radio_AntiAirGunDestroyed" )	-- 対空機関砲が壊れた無線を流す

	end,

}

---------------------------------------------------------------------------------ヘリを呼ぶ
this.Seq_CallSupportHelicopter = {

	Messages = {
		Character = {
			{ data = "Tactical_Vehicle_WEST_000",	message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Tactical_Vehicle_WEST_001",	message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_000",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_001",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_002",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
		},
		Gimmick = {
			-- 対空機関砲
			{ data = "gntn_area01_antiAirGun_000",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_001",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_002",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_003",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
		},
	},

	OnEnter = function()

		-- 無線関連
		TppRadio.RegisterOptionalRadio( "OptionalRadio_003" )	-- 任意無線登録

		-- UI関連
		this.commonDisableMarker( "Armored_Vehicle_WEST_000" )	-- とりあえず機銃装甲車のマーカーを消す

		-- BGM変更。装甲車破壊直後～空爆までのカウントダウン開始
		TppMusicManager.PostSceneSwitchEvent( 'Set_Switch_bgm_e20050_count_al' )

		-- チェックポイントを無効にする
		TppDataUtility.SetEnableDataFromIdentifier( "DataIdentifier_CheckPointTraps", "CheckPointTraps", false, true )

		-- ヘリ設定
		-- デフォルトRVを設定
		TppSupportHelicopterService.SetDefaultRendezvousPointMarker( "RV_SeaSide" )
		-- ヘリの自動帰還を無効
		TppSupportHelicopterService.DisableAutoReturn()

		TppSequence.ChangeSequence( "Seq_Escape" )					-- 次のシーケンスへ

	end,

}

--------------------------------------------------------------------------------- プレイヤー脱出シーケンス
this.Seq_Escape = {

	Messages = {
		Character = {
			-- プレイヤー
			{ data = "Player",						message = "RideHelicopterStart",			localFunc = "localOnPlayerRideHelicopter" },

			-- CP
			{ data = this.CP_ID,					message = "EndGroupVehicleRouteMove",		localFunc = "localOnEndGroupVehicleRouteMove" },

			-- 支援ヘリ
			{ data = this.CHARACTER_ID_HELICOPTER,			message = "ArriveToWaitPointOnLandingZone",	localFunc = "localOnHelicopterArriveLZ" },

			{ data = "Tactical_Vehicle_WEST_000",	message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Tactical_Vehicle_WEST_001",	message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_000",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_001",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_002",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
		},
		Gimmick = {
			-- 対空機関砲
			{ data = "gntn_area01_antiAirGun_000",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_001",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_002",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_003",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
		},
		Timer = {
			{ data = "Timer1",						message = "OnEnd",							localFunc = "OnTimer1End" },
			{ data = "Timer5",						message = "OnEnd",							localFunc = "OnTimer5End" },
			{ data = "Timer60",						message = "OnEnd",							localFunc = "OnTimer60End" },
			{ data = "Timer120",					message = "OnEnd",							localFunc = "OnTimer120End" },
			{ data = "Timer150",					message = "OnEnd",							localFunc = "OnTimer150End" },
			{ data = "Timer160",					message = "OnEnd",							localFunc = "OnTimer160End" },
			{ data = "Timer170",					message = "OnEnd",							localFunc = "OnTimer170End" },
			{ data = "Timer179",					message = "OnEnd",							localFunc = "OnTimer179End" },
			{ data = "Timer180",					message = "OnEnd",							localFunc = "OnTimer180End" },
		},
		Subtitles = {
			{ data="countdown",						message = "SubtitlesEventMessage",			localFunc = "localStartCountdown" },
		},
	},

	OnEnter = function()

		if TppSupportHelicopterService.IsDueToGoToLandingZone( this.CHARACTER_ID_HELICOPTER ) == false then	-- 特にＬＺに行く予定がないなら
			TppHelicopter.Call( "RV_SeaSide" )									-- ヘリを呼ぶ
		end

		-- TppMusicManager.PlaySceneMusic( "Stop_bgm_e20050_count" )	-- ミッション専用曲を一回止めてしまおう
		-- TppMusicManager.EndSceneMode()

		-- 無線関連
		-- 諜報セットアップ
		this.SetIntelRadio()

		-- 敵兵関連
		-- リスポーン時の武器変更設定
		TppCommandPostObject.GsAddRespawnRandomWeaponId( this.CP_ID, "WP_sg01_v00", 20 )
		TppCommandPostObject.GsAddRespawnRandomWeaponId( this.CP_ID, "WP_ms02", 15 )

		-- UI関連
		-- 中目標を変更する
		local commonDataManager = UiCommonDataManager.GetInstance()
		if commonDataManager ~= NULL then
			local luaData = commonDataManager:GetUiLuaExportCommonData()
			if luaData ~= NULL then
				luaData:SetCurrentMissionSubGoalNo(3)									-- 中目標番号をその値に設定する
				-- アナウンスログ表示
				local hudCommonData = HudCommonDataManager.GetInstance()				-- とりあえずマネージャーを取得
				hudCommonData:AnnounceLogViewLangId( "announce_mission_info_update" )	-- ミッション情報更新アナウンスログを表示
			end
		end

		-- ヘリ設定
		-- デフォルトRVを設定
		TppSupportHelicopterService.SetDefaultRendezvousPointMarker( "RV_SeaSide" )
		-- ヘリの自動帰還を無効
		TppSupportHelicopterService.DisableAutoReturn()

		-- タイマー開始
		GkEventTimerManager.Start( "Timer1", 1.5 )								-- ちょっと待つ

	end,

	-- カウントダウンを開始する（既にカウントダウン開始していたら何もしない）
	localStartCountdown = function()

		if TppMission.GetFlag( "isCountdownStarted" ) == false then

			TppMission.SetFlag( "isCountdownStarted", true )

			-- タイマー開始
			GkEventTimerManager.Start( "Timer5", 30 )								-- 残り2分半
			GkEventTimerManager.Start( "Timer60", 60 )								-- 残り2分
			GkEventTimerManager.Start( "Timer120", 120 )							-- 残り1分
			GkEventTimerManager.Start( "Timer150", 150 )							-- 残り30秒
			GkEventTimerManager.Start( "Timer160", 160 )							-- 残り20秒
			GkEventTimerManager.Start( "Timer170", 170 )							-- 残り10秒
			GkEventTimerManager.Start( "Timer179", 180 )							-- 時間切れ
			GkEventTimerManager.Start( "Timer180", 181 )							-- 時間切れ

			-- タイマーUIを出す
			local hudCommonData = HudCommonDataManager.GetInstance()
			hudCommonData:StartDisplayTimer( 180 )

		end

	end,

	-- ヘリがLZに到達した
	localOnHelicopterArriveLZ = function()

		-- TppRadio.PlayEnqueue( "Radio_HelicopterArriveLZ" )

	end,


	-- 車両連携が終了した
	localOnEndGroupVehicleRouteMove = function()

		local vehicleGroupInfo = TppData.GetArgument( 2 )

		local routeInfoName = vehicleGroupInfo.routeInfoName									-- RouteInfoデータ名
		local vehicleCharacterId = vehicleGroupInfo.vehicleCharacterId							-- 車両のキャラクターID
		local routeId = vehicleGroupInfo.vehicleRouteId											-- ルートID
		local memberCharacterIds = vehicleGroupInfo.memberCharacterIds							-- 乗車しているキャラクターID
		local result = vehicleGroupInfo.result													-- 結果（成功 or 失敗）
		local reason = vehicleGroupInfo.reason													-- 結果の原因

		if	routeInfoName ~= "TppGroupVehicleDefaultRideRouteInfo0001" or						-- 捕虜収容所に向かう車両連携ではない、または
			result == "FAILURE" then															-- 車両連携が失敗したら

			return																					-- 何もしない

		end

		TppMission.SetFlag( "isFinishLightVehicleGroup", true )									-- ビークルの車両連携が終了した事を記録しておく
		this.commonRestoreRoute()																-- ルートを再構築

	end,

	-- プレイヤーがヘリに乗った
	localOnPlayerRideHelicopter = function()

		GkEventTimerManager.Stop( "Timer180" )
		GkEventTimerManager.Stop( "Timer170" )
		GkEventTimerManager.Stop( "Timer160" )
		GkEventTimerManager.Stop( "Timer150" )
		GkEventTimerManager.Stop( "Timer120" )
		GkEventTimerManager.Stop( "Timer60" )
		GkEventTimerManager.Stop( "Timer5" )

		-- タイマーUIの表示消す
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:EraseDisplayTimer()

	end,

	-- ちょっと待つ
	OnTimer1End = function()

		-- タイマーとめる
		GkEventTimerManager.Stop( "Timer1" )

		-- カウントダウン開始無線再生
		TppRadio.PlayStrong( "Radio_CompletionBreakTarget1", {
			onEnd = function()
				this.Seq_Escape.localStartCountdown()	-- 保険処理で一応カウントダウンを開始しておく。フラグが立っていたら何もしない。
			end } )

	end,

	-- 30秒経過、残り2分半
	OnTimer5End = function()

		GkEventTimerManager.Stop( "Timer5" )
		TppRadio.PlayStrong( "Radio_Escape_TimeLeft_150s" )

	end,

	-- 1分経過、残り2分
	OnTimer60End = function()

		GkEventTimerManager.Stop( "Timer60" )
		TppRadio.PlayStrong( "Radio_Escape_TimeLeft_120s" )

	end,

	-- 2分経過、残り1分
	OnTimer120End = function()

		GkEventTimerManager.Stop( "Timer120" )
		TppRadio.PlayStrong( "Radio_Escape_TimeLeft_060s" )

	end,

	-- 150秒経過、残り30秒
	OnTimer150End = function()

		GkEventTimerManager.Stop( "Timer150" )
		if TppSupportHelicopterService.IsDueToGoToLandingZone( this.CHARACTER_ID_HELICOPTER ) == false then	-- 特にＬＺに行く予定がないなら
			TppRadio.PlayStrong( "Radio_Escape_TimeLeft_030s_2" )
		else
			TppRadio.PlayStrong( "Radio_Escape_TimeLeft_030s" )
		end

	end,

	-- 160秒経過、残り20秒
	OnTimer160End = function()

		GkEventTimerManager.Stop( "Timer160" )
		TppRadio.PlayStrong( "Radio_Escape_TimeLeft_020s" )

	end,

	-- 170秒経過、残り10秒
	OnTimer170End = function()

		GkEventTimerManager.Stop( "Timer170" )
		TppRadio.PlayStrong( "Radio_Escape_TimeLeft_010s" )

	end,

	-- 179秒経過、プレイヤーをとめる
	OnTimer179End = function()

		-- タイマーを止める
		GkEventTimerManager.Stop( "Timer179" )

		-- ヘリを飛び立たせる
		-- TODO:共通スクリプトではノード番号を指定できなかったので、元の関数を使っている
		TppSupportHelicopterService.ChangeRouteWithNodeIndex( "ReturnRoute_SeaSide", 3)

		-- ヘリの扉を閉める
		TppHelicopter.SetStatus( "leftDoor_close" )
		TppHelicopter.SetStatus( "rightDoor_close" )

		-- ヘリに乗れなくする
		TppPlayerUtility.SetDisableActionsWithName{ name = "DisableRideHelicopter_e20050", disableActions = {"DIS_ACT_RIDE_HELICOPTER"} }

		-- プレイヤーの動きを止める
		TppPadOperatorUtility.SetMasksForPlayer( 0, "CameraOnly")											-- カメラ以外の操作を止める

	end,

	-- 180秒経過、ゲームオーバー
	OnTimer180End = function()

		-- タイマーを止める
		GkEventTimerManager.Stop( "Timer180" )

		-- タイマーUIの表示消す
		local hudCommonData = HudCommonDataManager.GetInstance()
		hudCommonData:EraseDisplayTimer()

		-- ヘリを飛び立たせる
		-- TODO:共通スクリプトではノード番号を指定できなかったので、元の関数を使っている
		TppSupportHelicopterService.ChangeRouteWithNodeIndex( "ReturnRoute_SeaSide", 3)

		-- ヘリの扉を閉める
		TppHelicopter.SetStatus( "leftDoor_close" )
		TppHelicopter.SetStatus( "rightDoor_close" )

		-- ヘリに乗れなくする
		TppPlayerUtility.SetDisableActionsWithName{ name = "DisableRideHelicopter_e20050", disableActions = {"DIS_ACT_RIDE_HELICOPTER"} }

		-- プレイヤーの動きを止める

		-- ミッション失敗要求
		TppMission.ChangeState( "failed", "TimeOver", { disableGame = false, disablePlayerPad = false,	} )	-- プレイヤー操作を有効にしつつゲームオーバーにする
		TppPadOperatorUtility.SetMasksForPlayer( 0, "CameraOnly")											-- カメラ以外の操作を止める

	end,

}

--------------------------------------------------------------------------------ヘリに乗っているところ
this.Seq_PlayerRideHelicopter = {

	Messages = {
		Character = {
			{ data = "Tactical_Vehicle_WEST_000",	message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Tactical_Vehicle_WEST_001",	message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_000",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_001",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
			{ data = "Cargo_Truck_WEST_002",		message = "VehicleBroken",					commonFunc = this.commonOnNonTargetBroken },
		},
		Gimmick = {
			-- 対空機関砲
			{ data = "gntn_area01_antiAirGun_000",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_001",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_002",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
			{ data = "gntn_area01_antiAirGun_003",	message = "AntiAircraftGunBroken",			commonFunc = this.commonOnNonTargetBroken },
		},
	},

	OnEnter = function()

	end,

}

--------------------------------------------------------------------------------クリアデモ再生
this.Seq_PlayMissionClearDemo = {

	MissionState = "clear",

	OnEnter = function()

		-- CP無線をとめる
		TppEnemyUtility.IgnoreCpRadioCall( true )
		TppEnemyUtility.StopAllCpRadio( 1.0 )

		-- RVで
		if this.CounterList.lastRendezvouzPoint == "RV_SeaSide" then
			TppDemo.Play( "Demo_MissionClear", {
				onEnd = function()													-- デモが終わったら

					TppUI.FadeOut( 0 )
					TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" )	-- 次のシーケンスへ

				end,
				}, { disableHelicopter = false } )
		else
			TppDemo.Play( "Demo_MissionClear_NotSmooth", {
				onEnd = function()													-- デモが終わったら

					TppUI.FadeOut( 0 )
					TppSequence.ChangeSequence( "Seq_MissionClearShowTransition" )	-- 次のシーケンスへ

				end,
				}, { disableHelicopter = false } )
		end

	end,

	OnLeave = function()

	end,

}

--------------------------------------------------------------------------------
this.Seq_MissionClearShowTransition = {

	MissionState = "clear",

	Messages = {
		UI = {
			-- 終了ミッションテロップのフェードイン
			{ message = "EndMissionTelopFadeIn" ,	localFunc = "OnFinishClearFade" },
		},
	},

	-- クリア画面遷移タイミングでクリア無線コール
	OnFinishClearFade = function()

		TppMusicManager.PlaySceneMusic( "Stop_bgm_e20050_count" )
		TppMusicManager.EndSceneMode()

		-- テロップ～ミッション完全終了まで無線とBGM以外ミュート
		TppSoundDaemon.SetMute( 'Result' )
		-- TppMusicManager.PostJingleEvent( 'MissionEnd', 'Play_bgm_gntn_ed_default' )

		-- Btk14648対応：クリアランクに応じてジングル呼び分け
		local Rank = PlayRecord.GetRank()
		if( Rank == 0 ) then
			Fox.Warning( "Seq_MissionClearShowTransition:Mission not yet clear!!" )
		elseif( Rank == 1 ) then
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_s" )
		elseif( Rank == 2 ) then
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_ab" )
		elseif( Rank == 3 ) then
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_ab" )
		elseif( Rank == 4 ) then
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_cd" )
		elseif( Rank == 5 ) then
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_cd" )
		else
			TppMusicManager.PostJingleEvent( "MissionEnd", "Play_bgm_gntn_ed_default_e" )
		end

		-- 強字幕設定にする
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )

		-- ミッション結果に応じて無線を流す
		local rank = PlayRecord.GetRank()
		if rank == 0 then								-- クリアできてなかったら（ありえないはず）
			TppRadio.Play( "Radio_GameClear_Bad" )
		elseif rank == 1 then							-- Sランクだったら
			TppRadio.Play( "Radio_GameClear_Great" )
			Trophy.TrophyUnlock( 4 )						-- トロフィー・実績「Sランクでミッションをクリア」
		elseif rank == 2 then							-- Aランクだったら
			TppRadio.Play( "Radio_GameClear_VeryGood" )
		elseif rank == 3 then							-- Bランクだったら
			TppRadio.Play( "Radio_GameClear_Good" )
		elseif rank == 4 then							-- Cランクだったら
			TppRadio.Play( "Radio_GameClear_Normal" )
		elseif rank == 5 then							-- Dランクだったら
			TppRadio.Play( "Radio_GameClear_Bad" )
		elseif rank == 6 then							-- Eランクだったら
			TppRadio.Play( "Radio_GameClear_Bad" )
		end

	end,

	OnEnter = function()

		TppRadioConditionManagerAccessor.Unregister( "Tutorial" )	 --コンポーネントの解除
		TppRadioConditionManagerAccessor.Unregister( "Basic" )

		TppUI.ShowTransition( "ending", {
			onStart = function()
				TppUI.FadeOut( 0 )
			end,
			onEnd = function()
				TppSequence.ChangeSequence( "Seq_MissionClear" )
			end,
		} )

	end,

}

---------------------------------------------------------------------------------
this.Seq_MissionClear = {

	MissionState = "clear",

	OnEnter = function()

		-- 強字幕設定にする
		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )

		-- クリア後黒電話
		TppRadio.Play( "Radio_AfterGameClear", {
			onStart = function() TppMusicManager.PostJingleEvent( 'SingleShot', 'Set_Switch_bgm_gntn_ed_default_lp' ) end,
			onEnd = function()
				TppSequence.ChangeSequence( "Seq_ShowClearReward" )
			end
		}, nil, nil, "none"  )

	end,

	OnUpdate = function()

		-- スキップ処理
		local hudCommonData = HudCommonDataManager.GetInstance()
		if hudCommonData:IsPushRadioSkipButton() == true then
			-- スキップボタンが押されたら即座に黒電話停止、次シーケンスへ
			-- 再生中の無線停止
			local radioDaemon = RadioDaemon:GetInstance()
			radioDaemon:StopDirect()
			TppSequence.ChangeSequence( "Seq_ShowClearReward" )
		end

	end,

}

---------------------------------------------------------------------------------ミッション失敗（ヘリに乗った）
this.Seq_MissionFailedRideHelicopter = {

	MissionState = "failed",

	OnEnter = function()

		this.CounterList.GameOverRadioName = "Radio_GameOver_PlayerRideHelicopter"
		TppSequence.ChangeSequence( "Seq_MissionGameOver" )							-- ミッション終了シーケンスへ

	end,

}

---------------------------------------------------------------------------------ミッション失敗（カウントダウンが0になった）
this.Seq_MissionFailedTimeOver = {

	MissionState = "failed",

	Messages = {
		Demo = {
			{ data = "p12_040020_000",	message = "snakeWarp",	localFunc = "localOnPlayerCamera", },
			{ data = "p12_040030_000",	message = "snakeWarp",	localFunc = "localOnPlayerCamera", },
		},
	},

	OnEnter = function()

		-- ミッション失敗演出があればここに書く
		-- CP無線を強制停止
		TppEnemyUtility.IgnoreCpRadioCall( true )
		TppEnemyUtility.StopAllCpRadio( 1.0 )
		-- ミッション圏外演出を停止
		GZCommon.OutsideAreaEffectDisable()

		-- 強制リアライズ
		local characterId = nil
		if characterId ~= nil then
			MissionManager.RegisterNotInGameRealizeCharacter( characterId )
		end

		if TppPlayerUtility.IsNormalState() == true or TppPlayerUtility.GetCarriedCharacterId() ~= "" then

 			TppDemo.Play( "Demo_MissionFailure", {
				onEnd = function()

					FadeFunction.SetFadeColor( 255, 255, 255, 255 )									-- フェードアウトの色を白にしておく
					TppUI.FadeOut( 0 )																-- フェードアウト

					TppPlayerUtility.ResetDisableActionsWithName("DisableRideHelicopter_e20050")	-- ヘリ乗り禁止を解除しておく

					this.CounterList.GameOverRadioName = "Radio_GameOver_MissionFail"
					FadeFunction.ResetFadeColor()											-- フェードの色をリセット

					TppHostageManager.GsSetStruggleFlag( "Hostage_e20050_000", false )	-- 捕虜をおとなしくさせる
					TppHostageManager.GsSetStruggleFlag( "Hostage_e20050_001", false )	-- 捕虜をおとなしくさせる
					TppHostageManager.GsSetStruggleFlag( "Hostage_e20050_002", false )	-- 捕虜をおとなしくさせる

					GZCommon.StopSirenForcibly()

					TppSequence.ChangeSequence( "Seq_MissionGameOver" )						-- ミッション終了シーケンスへ

				end
				},
				{	disableGame = false,			--共通ゲーム無効を、キャンセル
					-- disableDemoEnemies = false,	--敵兵無効を、キャンセル
					disableHelicopter = false,		--支援ヘリ無効かを、キャンセル
					disablePlayerPad = false,		-- パッド無効をキャンセル
					--ST_FAILED中なのでここまでで、仕様をかなえるはず
					disableDemoEnemies = true
				}
				)

		else

			TppDemo.Play( "Demo_MissionFailureNoPlayerReaction", {
				onEnd = function()

					FadeFunction.SetFadeColor( 255, 255, 255, 255 )									-- フェードアウトの色を白にしておく
					TppUI.FadeOut( 0 )																-- フェードアウト

					TppPlayerUtility.ResetDisableActionsWithName("DisableRideHelicopter_e20050")	-- ヘリ乗り禁止を解除しておく

					this.CounterList.GameOverRadioName = "Radio_GameOver_MissionFail"
					FadeFunction.ResetFadeColor()											-- フェードの色をリセット

					TppHostageManager.GsSetStruggleFlag( "Hostage_e20050_000", false )	-- 捕虜をおとなしくさせる
					TppHostageManager.GsSetStruggleFlag( "Hostage_e20050_001", false )	-- 捕虜をおとなしくさせる
					TppHostageManager.GsSetStruggleFlag( "Hostage_e20050_002", false )	-- 捕虜をおとなしくさせる

					GZCommon.StopSirenForcibly()

					TppSequence.ChangeSequence( "Seq_MissionGameOver" )						-- ミッション終了シーケンスへ

				end
				},
				{	disableGame = false,			--共通ゲーム無効を、キャンセル
					-- disableDemoEnemies = false,	--敵兵無効を、キャンセル
					disableHelicopter = false,		--支援ヘリ無効かを、キャンセル
					disablePlayerPad = false,		-- パッド無効をキャンセル
					--ST_FAILED中なのでここまでで、仕様をかなえるはず
				}
				)

		end

	end,

	-- デモ中にプレイヤーにカメラが戻る時に呼ばれる
	localOnPlayerCamera = function()

		Fox.Log( "e20050_sequence.Seq_MissionFailedTimeOver.localOnPlayerCamera()" )

		local playerObject = Ch.FindCharacterObjectByCharacterId( "Player" )
		local playerPosition = playerObject:GetPosition()

		if playerPosition:GetY() < 4.25 then

			Fox.Log( "e20050_sequence.Seq_MissionFailedTimeOver.localOnPlayerCamera(): PlayerWarp!" )

			TppCharacterUtility.WarpCharacterIdFromIdentifier( "Player", "e20050_warpLocators", "SeaSide0000" )

		end

	end,

}

---------------------------------------------------------------------------------ミッション失敗（ミッション圏外）
this.Seq_MissionFailedOutsideMissionArea = {

	-- ここに入ってきた時点で自動的にMissionMangaerがST_FAILEDで止めている
	MissionState = "failed",

	Messages = {
		Timer = {
			{ data = "MissionFailedProductionTimer",	message = "OnEnd", 	localFunc="OnFinishMissionFailedProduction" },
		},
	},

	-- ミッション失敗演出ウェイト明け
	OnFinishMissionFailedProduction = function()

		Fox.Log("----------------Seq_MissionFailed:OnFinishMissionFailedProduction----------------")

		TppSequence.ChangeSequence( "Seq_MissionGameOver" )								-- ミッション終了シーケンスへ

	end,


	OnEnter = function( manager )
		Fox.Log("----------------Seq_MissionFailed:OnEnter----------------")

		TppPlayerUtility.ResetDisableActionsWithName("DisableRideHelicopter_e20050")	-- ヘリ乗り禁止を解除しておく
		this.CounterList.GameOverRadioName = "Radio_GameOver_MissionArea"

		-- ミッション失敗演出中のウェイトを行う
		TppTimer.Start( "MissionFailedProductionTimer", this.CounterList.GameOverFadeTime )

	end,

}

---------------------------------------------------------------------------------ミッション失敗（ヘリが死んだ）
this.Seq_MissionFailedHelicopterDead = {

	MissionState = "failed",

	OnEnter = function()

		-- ミッション失敗演出があればここに書く
		TppPlayerUtility.ResetDisableActionsWithName("DisableRideHelicopter_e20050")	-- ヘリ乗り禁止を解除しておく

		this.CounterList.GameOverRadioName = "Radio_GameOver_HelicopterDead"

		TppSequence.ChangeSequence( "Seq_MissionGameOver" )								-- ミッション終了シーケンスへ

	end,

}

---------------------------------------------------------------------------------ミッション失敗（プレイヤーが死んだ）
this.Seq_MissionFailedPlayerDead = {

	MissionState = "failed",

	Messages = {
		Timer = {
			{ data = "MissionFailedProductionTimer",	message = "OnEnd", 	localFunc="OnFinishMissionFailedProduction" },
		},
	},

	OnEnter = function()

		TppPlayerUtility.ResetDisableActionsWithName("DisableRideHelicopter_e20050")			-- ヘリ乗り禁止を解除しておく
		GkEventTimerManager.Start( "MissionFailedProductionTimer", this.CounterList.GameOverFadeTime )	-- ミッション失敗演出中のウェイトを行う

	end,

	-- ミッション失敗演出ウェイト明け
	OnFinishMissionFailedProduction = function( manager )

		this.CounterList.GameOverRadioName = "Radio_GameOver_PlayerDead"
		TppSequence.ChangeSequence( "Seq_MissionGameOver" )										-- ミッション終了シーケンスへ

	end,

}


--------------------------------------------------------------------------------- ゲームオーバー
this.Seq_MissionGameOver = {

	MissionState = "gameOver",

	Messages = {
		UI = {
			{ message = "GameOverOpen" ,	localFunc = "OnFinishGameOverFade" },	-- ゲームオーバー画面遷移完了
		},
	},

	-- ゲームオーバー画面遷移が完了したタイミングでゲームオーバー無線コール
	OnFinishGameOverFade = function()

		SubtitlesCommand.SetIsEnabledUiPrioStrong( true )	-- 強字幕設定にする
		TppRadio.DelayPlay( this.CounterList.GameOverRadioName, nil, "none" )	-- ミッション失敗内容に応じた無線をコール

	end,

	OnEnter = function()

	end,
}

--------------------------------------------------------------------------------- ミッションクリア後の報酬表示シーケンス
this.Seq_ShowClearReward = {

	MissionState = "clear",

	Messages = {
		UI = {
			-- ポップアップの終了メッセージ
			-- {	message = "PopupClose",	commonFunc = function() this.OnClosePopupWindow() end },
			-- 全ての報酬ポップアップが閉じられたら次シーケンスへ
			{	message = "BonusPopupAllClose",	commonFunc = function() TppSequence.ChangeSequence( "Seq_MissionEnd" ) end },		},
	},

	OnEnter = function()

		-- 報酬ポップアップの表示
		this.OnShowRewardPopupWindow()

	end,

}

--------------------------------------------------------------------------------- ミッション終了
this.Seq_MissionEnd = {

	OnEnter = function()

		this.commonMissionCleanUp()		-- 後片付け
		-- ジングルフェード終了
		TppMusicManager.PostJingleEvent( "SingleShot", "Stop_bgm_gntn_ed_default" )

		TppMissionManager.SaveGame()		-- Btk14449対応：報酬獲得Sequenceで獲得した報酬をSaveする

		TppMission.ChangeState( "end" )	--ミッションを終了させる（アンロード）

	end,

}

---------------------------------------------------------------------------------
-- END
---------------------------------------------------------------------------------
return this
