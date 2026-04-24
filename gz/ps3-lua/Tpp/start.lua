-- TppMain start script
Fox.Log("Tpp/start.lua") -- 変えてみる Y.Ogaito 2010.10.29

-- 起動ロードアイコン用ftexリクエスト
UiDaemon.SetPrefetchTexture( "/Assets/tpp/ui/ModelAsset/cmn_loadmark/Pictures/cmn_loadmark_logo_mini_nmp.ftex" )
UiDaemon.SetPrefetchTexture( "/Assets/tpp/ui/ModelAsset/cmn_loadmark/Pictures/cmn_loadmark_logo_mini.ftex" )

-- プラットフォームごとにメインループのウェイトの仕方を変える
local platform = Fox.GetPlatformName()
if platform == 'Windows' then
	FoxGameFrame.SetGameFrameWaitType ("VirtualVsync");
end
if platform == 'Xbox360' then
	FoxGameFrame.SetGameFrameWaitType ("ExternalVsyncOffset");
end
if platform == 'PS3' then
	FoxGameFrame.SetGameFrameWaitType ("ExternalWait");
end
if platform == 'XboxOne' then
	FoxGameFrame.SetGameFrameWaitType ("ExternalVsyncOffset");
end

-- コンテンツロードが始まる前にGrのデバッグ用コード実行
if DEBUG then
	GrTools.AddExtraShaderPerfLua ( "Tpp/Debug/Scripts/ShaderPerf_TppShaders_ps3.lua" );
	GrTools.AddExtraShaderPerfLua ( "Tpp/Debug/Scripts/ShaderPerf_TppShaders_win32.lua" );
	GrTools.AddExtraShaderPerfLua ( "Tpp/Debug/Scripts/ShaderPerf_TppShaders_x360.lua" );
end

Fox.Log( "GameTitle:" .. TppGameSequence.GetGameTitleName() ) -- タイトル名を出す

-- 拡張子毎の「カテゴリ」指定
-- 「機種」に依存するファイル
AssetConfiguration.RegisterExtensionInfo{
		extensions = {
			"tetl", "tmss", "tmsl", "tlsp", "tmsu", "tmsf", "twpf", "adm", "tevt", "vpc","ends",
		},
		categories = { "Target" }
	}

--ゲームシーケンスコントローラー
if TppGameSequence then
    local   gameSequenceController = TppGameSequence:GetInstance()
	-- 依存解消の為一旦PhaseControllerは後から設定するようになりました(120515 y.yamazaki)
	gameSequenceController:SetPhaseController( TppPhaseController.Create() )
end

if TppHighSpeedCameraManager then
	-- ハイスピードカメラマネージャー生成
	local manager = TppHighSpeedCameraManager.CreateInstance()
end

-- チェックポイントデーモン
local checkpointDaemon = CheckpointDaemon{ name = "CheckpointDaemon" }

-- ストーリーフラグ
--[[
if TppGameSequence.GetGameTitleName() == "GZ" then
	StoryFlags.SetScript( "/Assets/tpp/level/all_load/gzStoryFlag.lua" ) -- start2nd.luaへ
else
	StoryFlags.SetScript( "/Assets/tpp/level/all_load/StoryFlag.lua" )
end
	StoryFlags.Initialize()
	StoryFlags.SetUsingCheckpointMode( true )
]]

if GkNoiseSystem then
	-- ノイズ定義読み込み
	GkNoiseSystem.InitNoiseSet( "Tpp/Scripts/Noises/TppNoiseDefinitions.lua" )
end

-- ChVoiceTaskOrganizer(Daemon)の設定
if ChVoiceTaskOrganizer then
	ChVoiceTaskOrganizer.PrepareTaskPool( "Player", 1 )		-- Playerの同時発声数1
	ChVoiceTaskOrganizer.PrepareTaskPool( "Enemy", 8 )		-- Enemyの同時発声数は8
	ChVoiceTaskOrganizer.PrepareTaskPool( "HqSquad", 1 )	-- 無線の同時発声数は1
end

if ChVoiceTaskOrganizer2 then
	ChVoiceTaskOrganizer2.PrepareTaskPool( "Player", 1 )		-- Playerの同時発声数1
	ChVoiceTaskOrganizer2.PrepareTaskPool( "Enemy", 8 )		-- Enemyの同時発声数は8
	ChVoiceTaskOrganizer2.PrepareTaskPool( "HqSquad", 1 )	-- 無線の同時発声数は1
end

-- Player関連

-- ライフ情報登録
TppPlayerDesc.RegisterLifeNames{
	mainLives = { "Life", },
}

-- パッド関連初期設定
TppPadOperatorUtility.Init()


-- 敵兵関連
if Editor then
	-- Tpp::Soldier
	GsRouteDataNodeEvent.SetEventDefinitionPath( "Soldier", "Tpp/Scripts/RouteEvents/AiRtEvSoldier.lua" )
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "Soldier", "Tpp/Scripts/RouteEvents/AiRtEvSoldier.lua" )

	-- Tpp::Huey
	GsRouteDataNodeEvent.SetEventDefinitionPath( "Huey", "Tpp/Scripts/RouteEvents/AiRtEvHuey.lua" )
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "Huey", "Tpp/Scripts/RouteEvents/AiRtEvHuey.lua" )

	-- Tpp::Ishmael
	GsRouteDataNodeEvent.SetEventDefinitionPath( "Ishmael", "Tpp/Scripts/RouteEvents/AiRtEvIshmael.lua" )
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "Ishmael", "Tpp/Scripts/RouteEvents/AiRtEvIshmael.lua" )

	-- Tpp::Vehicle
	GsRouteDataNodeEvent.SetEventDefinitionPath( "Vehicle", "Tpp/Scripts/RouteEvents/AiRtEvVehicle.lua" )
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "Vehicle", "Tpp/Scripts/RouteEvents/AiRtEvVehicle.lua" )

	-- Tpp::Sahelan
	GsRouteDataNodeEvent.SetEventDefinitionPath( "Sahelan", "Tpp/Scripts/RouteEvents/AiRtEvSahelan.lua" )
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "Sahelan", "Tpp/Scripts/RouteEvents/AiRtEvSahelan.lua" )

	-- Tpp::Helicopter
	GsRouteDataNodeEvent.SetEventDefinitionPath( "Helicopter", "Tpp/Scripts/RouteEvents/AiRtEvHelicopter.lua" )
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "Helicopter", "Tpp/Scripts/RouteEvents/AiRtEvHelicopter.lua" )

	-- Tpp::Animal
	GsRouteDataNodeEvent.SetEventDefinitionPath("Animal","Tpp/Scripts/RouteEvents/AiRtEvAnimal.lua")
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "Animal", "Tpp/Scripts/RouteEvents/AiRtEvAnimal.lua" )

	-- Tpp::RideVolgin
	GsRouteDataNodeEvent.SetEventDefinitionPath("RideVolgin", "Tpp/Scripts/RouteEvents/AiRtEvRideVolgin.lua" )
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "RideVolgin", "Tpp/Scripts/RouteEvents/AiRtEvRideVolgin.lua" )

	-- Tpp::WatchDog
	GsRouteDataNodeEvent.SetEventDefinitionPath( "WatchDog", "Tpp/Scripts/RouteEvents/AiRtEvWatchDog.lua" )
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "WatchDog", "Tpp/Scripts/RouteEvents/AiRtEvWatchDog.lua" )

	-- Tpp::Soldier2
	GsRouteDataNodeEvent.SetEventDefinitionPath( "Soldier2", "Tpp/Scripts/RouteEvents/AiRtEvSoldier2.lua" )
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "Soldier2", "Tpp/Scripts/RouteEvents/AiRtEvSoldier2.lua" )

	-- Railゲーム関連
	-- ルートイベント設定

	-- Rail車用
	GsRouteDataNodeEvent.SetEventDefinitionPath( "RailVehicle", "Tpp/Scripts/RouteEvents/AiRtEvRailVehicle.lua" )
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "RailVehicle", "Tpp/Scripts/RouteEvents/AiRtEvRailVehicle.lua" )

	-- 注視対象ルート
	GsRouteDataNodeEvent.SetEventDefinitionPath( "AimTarget", "Tpp/Scripts/RouteEvents/AiRtEvAimTarget.lua" )
	GsRouteDataEdgeEvent.SetEventDefinitionPath( "AimTarget", "Tpp/Scripts/RouteEvents/AiRtEvAimTarget.lua" )

	GsRouteDataNodeEvent.SetEventList( "Soldier" )
	GsRouteDataEdgeEvent.SetEventList( "Soldier" )

	-- ルートシステムスクリプトの設定
	GsRoute.SetRouteSystemScript( "/Assets/tpp/editor_scripts/fox/route/TppRouteSystem.lua" )
end

--カバーポイント
if TppCoverPointProvider then
	Fox.Log("TppCoverPointProvider create")
	TppCoverPointProvider.Create()
end

--タクティカルアクションシステムスクリプトの設定
NavTactical.SetTacticalActionSystemScript( "/Assets/tpp/editor_scripts/fox/tactical_action/TppTacticalActionSystem.lua" )

--連携行動登録
if GroupBehavior then --init.lua から移動。要らないものはいずれ消してしまうこと。
	GroupBehavior.RegisterScript( "Counter",		"Tpp/Scripts/GroupBehavior/GroupTppCounter.lua" )
	GroupBehavior.RegisterScript( "MgmCarryHuman",		"Tpp/Scripts/GroupBehavior/GroupMgmCarryHuman.lua" )
	GroupBehavior.RegisterScript( "Parasite",		"Tpp/Scripts/GroupBehavior/GroupParasite.lua" )
	GroupBehavior.RegisterScript( "SetPlay",		"Tpp/Scripts/GroupBehavior/GroupTppSetPlay.lua" )

	GroupBehavior.RegisterScript( "GroupClearingMove",	"Tpp/Scripts/GroupBehavior/GroupClearingMove.lua" )
	GroupBehavior.RegisterScript( "GroupFieldBattle",	"Tpp/Scripts/GroupBehavior/GroupFieldBattle.lua" )
	GroupBehavior.RegisterScript( "GroupMortarAttack",	"Tpp/Scripts/GroupBehavior/GroupMortarAttack.lua" )
end

-- シェーダー関連初期化
if GrDaemon then
    local platform = Fox.GetPlatformName()
	local device = ""
	if GrTools then
		device = GrTools.GetDeviceName()
	end
    -- Luaのdofileは使用禁止です
    -- が、こういった初期化は例外です
	if platform == 'Windows' then
		if device == 'directx9' then
			GrTools.LoadShaderPack("shaders/win32/TppShaders_win32.fsop")
			if AssetConfiguration.GetConfigurationFromAssetManager("EnableWindowsDX11Texture") then
				dofile( 'shaders/win32/TppShadersNoLnm_win32.lua' )
			else
				dofile( 'shaders/win32/TppShaders_win32.lua' )
			end
		end
		if device == 'directx11' then
			GrTools.LoadShaderPack("shaders/dx11/TppShaders_dx11.fsop")
			dofile( 'shaders/dx11/TppShaders_dx11.lua' )
		end
	elseif platform == 'Xbox360' then
		GrTools.LoadShaderPack("shaders\\xbox360\\TppShaders_x360.fsop")
		dofile( 'shaders/xbox360/TppShaders_x360.lua' )
	elseif platform == 'PS3' then
		GrTools.LoadShaderPack("shaders/ps3/TppShaders_ps3.fsop.sdat")
		dofile( 'shaders/ps3/TppShaders_ps3.lua' )
	elseif platform == 'XboxOne' then
		GrTools.LoadShaderPack("shaders/xboxone/TppShaders_xone.fsop")
		dofile( 'shaders/xboxone/TppShadersNoLnm_xone.lua' )
	end
end

-- 被写界深度
-- CameraPluginにインタフェースがあるのでそれを使っている。
if ChCameraPlugin then
	ChCameraPlugin.SetUpDepthOfField()
end

-- エフェクト関連
TppFadeOutEffectHolder.Create()

-- Tpp固有のFxノードの定義ファイルを追加（Windowsエディタのみ有効）
-- 製品リリースには必要のない処理です
if Preference then
	local fxEdPref = Preference.GetPreferenceEntity("FxEditorSetting")
	if not Entity.IsNull(fxEdPref) and Fox.GetPlatformName() == 'Windows' then
		if #fxEdPref.defineFiles == 0 then
			Command.AddPropertyElement{ entity=fxEdPref, property="defineFiles" }
		end
		fxEdPref.defineFiles[1] = "../../Tpp/Tpp/Fox/LevelEditor/Fx/tppFxModuleDefines.xml"
		-- Command.SetProperty{ entity=fxEdPref, property="defineFiles", value="../../Tpp/Tpp/Fox/LevelEditor/Fx/tppFxModuleDefines.xml" }
		Fox.Log("FxEditorSetting set node define file.")
	end
end

-- Fx のセットアップ
if FxDaemon then
	
	-- Tppシェーダの事前生成
	FxDaemon:InitializeReserveObject( "TppShaderPool" );
	FxDaemon:InitializeReserveObject( "TppTexturePoolManager" );
	
	-- Fxのインスタンスメモリサイズの制限変更
	if Fox.GetPlatformName() == 'Windows' then
		FxSystemConfig.SetLimitInstanceMemorySize( 1024 * 1024 * 24 )
		FxSystemConfig.SetLimitInstanceMemoryDefaultSize( 1024 * 1024 * 24 )
	else
		FxSystemConfig.SetLimitInstanceMemorySize( 1024 * 1024 * 9 )
		FxSystemConfig.SetLimitInstanceMemoryDefaultSize( 1024 * 1024 * 9 )
	end
	
end

-- サウンド仕向け値別拡張子設定
AssetConfiguration.SetLanguageGroupExtention{
	group = { "Sound" },
	extensions = {
		"mas", "fsm", "sbp", "wem", "evf", "sani", "sad", "stm"
	},
}

-- サウンド仕向け設定(デモも含みます)
if TppGameSequence.IsMaster() == false then
	--日本語
	AssetConfiguration.SetGroupCurrentLanguage( "Sound", "jpn" )
	--英語
	--AssetConfiguration.SetGroupCurrentLanguage( "Sound", "eng" )
else
	-- マスター版は仕向け地ごとに設定
	if (TppGameSequence.GetTargetArea() == "Japan" ) then
		--日本語
		AssetConfiguration.SetGroupCurrentLanguage( "Sound", "jpn" )
	else
		--英語
		AssetConfiguration.SetGroupCurrentLanguage( "Sound", "eng" )
	end
end

-- 仕向け設定
if (TppGameSequence.GetTargetArea() == "Japan" ) then
	--日本語
	SubtitlesCommand.SetVoiceLanguage( "jpn" )
	SubtitlesCommand.SetLanguage( "jpn" )
else
	--英語
	SubtitlesCommand.SetVoiceLanguage( "eng" )
	SubtitlesCommand.SetLanguage( "eng" )
end

-- サウンド初期化
if LuaUnitTest then
--	SoundCoreDaemon.SetAssetPath( "/Assets/tpptest/sound/asset/" )
	SoundCoreDaemon.SetAssetPath( "/Assets/tpp/sound/asset/" )
else
	SoundCoreDaemon.SetAssetPath( "/Assets/tpp/sound/asset/" )
--	SoundCoreDaemon.SetAssetPath( "/Assets/tpp_sandbox/sound/asset/" )
end
SoundCoreDaemon.SetInterferenceRTPCName( "obstruction_rtpc", "occlusion_rtpc" )	-- 遮蔽用RTPC名設定
SoundCoreDaemon.SetDopplerRTPCName( "doppler" )		-- ドップラー用RTPC名設定
SoundCoreDaemon.SetRearParameter( "rear_rtpc", 5.0 )	-- 後方補正用
--dofile( '/Assets/tpp/sound/scripts/motion/setup.lua' ) --start2nd.luaへ Y.Ogaito 2013.11.20

-- サウンド制御デーモン
if TppSoundDaemon then
	local	tppSoundDaemon = TppSoundDaemon{}

	if TppSoundEditorDaemon then
		local	tppSoundEditorDaemon = TppSoundEditorDaemon{}
	end
end

-- 無線用システムの初期化
TppRadioObjectCreator.Create()
TppRadioCommand.RegisterTppCommonConditionCheckFunc()

-- TPP側のエディタに関数が反映されるまで限定
if TppGameSequence.GetGameTitleName() == "GZ" then
TppRadioConditionUtility.RegisterRadioCommonConditionCheckFunc()
end

-- ストリーム音声再生優先制御
-- 音声の種類ごとの優先度設定( 優先度区分ID, 開始時優先度, 再生中優先度 )
VoiceCommand:SetVoiceTypePriority( 0, 100, 100 )	-- Unknown
VoiceCommand:SetVoiceTypePriority( 1, 1, 0 )	-- ゲームオーバー
VoiceCommand:SetVoiceTypePriority( 15, 5, 50 )	-- iDroid音声
VoiceCommand:SetVoiceTypePriority( 3, 15, 90 )	-- プリセット無線(オンメモリ想定)
VoiceCommand:SetVoiceTypePriority( 6, 12, 20 )	-- NPC台詞
VoiceCommand:SetVoiceTypePriority( 2, 15, 50 )	-- 諜報無線
VoiceCommand:SetVoiceTypePriority( 5, 15, 50 )	-- リアルタイム強制無線
VoiceCommand:SetVoiceTypePriority( 14, 47, 50 )	-- 尋問台詞(オンメモリ想定)(ごにょごにょ音声を鳴らす)
VoiceCommand:SetVoiceTypePriority( 4, 55, 60 )	-- ヘリパイロット音声
VoiceCommand:SetVoiceTypePriority( 7, 65, 70 )	-- CP無線
VoiceCommand:SetVoiceTypePriority( 8, 65, 70 )	-- HQ無線
VoiceCommand:SetVoiceTypePriority( 9, 65, 80 )	-- MotherBase通信(オンメモリ想定)
VoiceCommand:SetVoiceTypePriority( 13, 75, 80 )	-- 敵兵立話
VoiceCommand:SetVoiceTypePriority( 10, 75, 90 )	-- NPC音声(オンメモリ想定)
VoiceCommand:SetVoiceTypePriority( 11, 75, 90 )	-- 敵兵音声(オンメモリ想定)
VoiceCommand:SetVoiceTypePriority( 12, 85, 90 )	-- プレイヤー音声(オンメモリ想定)

-- 音声のイベント名の種類分け( 優先度区分ID, イベント名 ) /*文字列を指定していますが、内部ではIDに変換しています*/
VoiceCommand:SetVoiceEventType( 1, "DD_gameover" )	-- ゲームオーバー
VoiceCommand:SetVoiceEventType( 2, "DD_ESR" )	-- 諜報無線
VoiceCommand:SetVoiceEventType( 5, "radio_defo" )	-- リアルタイム強制無線
VoiceCommand:SetVoiceEventType( 6, "DD_Intelmen" ) -- 味方諜報員
VoiceCommand:SetVoiceEventType( 5, "DD_RTR" )	-- リアルタイム強制無線
VoiceCommand:SetVoiceEventType( 5, "DD_OPR" )	-- 任意無線
VoiceCommand:SetVoiceEventType( 5, "DD_TUTR" )	-- オセロット
VoiceCommand:SetVoiceEventType( 5, "DD_missionUQ" )	--ヘリ急襲ミッションミラー音声
VoiceCommand:SetVoiceEventType( 4, "DD_vox_SH_radio" )	 -- 支援ヘリパイロット音声
VoiceCommand:SetVoiceEventType( 4, "DD_vox_SH_voice" )	 -- 支援ヘリパイロット音声
VoiceCommand:SetVoiceEventType( 7, "DD_vox_ene_ld" )	-- CP無線
VoiceCommand:SetVoiceEventType( 7, "DD_vox_cp_radio" )	-- CP無線
VoiceCommand:SetVoiceEventType( 10, "DD_hostage" )	-- 捕虜音声
VoiceCommand:SetVoiceEventType( 10, "DD_Chico" )	-- チコインゲーム音声
VoiceCommand:SetVoiceEventType( 10, "DD_Paz" )	-- パスインゲーム音声
VoiceCommand:SetVoiceEventType( 10, "DD_vox_kaz_rt_ld" )	-- NPC音声
VoiceCommand:SetVoiceEventType( 10, "DD_Ishmael" )	-- NPC音声
VoiceCommand:SetVoiceEventType( 13, "DD_vox_ene_conversation" ) -- 敵兵立話

-- ガジェットマネージャーサウンド初期化
TppGadgetManager.InitSound()

-- TPP用草むらパラメータ設定
if Bush then
	Bush.SetParameters {
		--easingA = float,		-- 角度戻りイージング係数
		--easingB = float,
		-- 角度変化速度上限[rad/sec]
		rotSpeedMax = foxmath.DegreeToRadian( 1 ),
		-- アルファ補正(透過)を行うカメラからの距離 (非表示 <= Min～Max <= 表示)
		alphaDistanceMin=1,  alphaDistanceMax=3,
	}
end

-- Win以外及びGameビルドでは起動時にGameModeにする
local platform = Fox.GetPlatformName()
if platform ~= 'Windows' or not Editor then
	Fox.SetActMode( "GAME" )
end

-- KnowledgePluginにSearchTagを事前登録する(逐一追加)
Ai.RegisterKnowledgeTags {
	"Character",
	"Player",
	"Enemy",
	"Target",
	"Noise",
	"Damage",
	"TacticalPoint",
	"NoticeObject",
	"NeedTrace",
	"Hurry",
	"OpenAreaClearingInfo",
	"CheckedByComradeDamageS",
	"CheckedByComradeDying",
	"CheckedByComradeFaint",
	"CheckedByComradeEnableImprison",
	"CheckedByComradeLie",
	"CheckedByComradeLieOutOfReach",
	"CheckedByComradeSleep",
	"CheckedByFindFarObject",
	"CheckedByFindFarShadow",
	"CheckedByGrenade",
	"CheckedByNoiseFoot",
	"CheckedByReceivedAttack",
	"CheckedByLostPrisoner",
	"Clearing",
	"GroupSquad",
	"WarningFlare",
	"GroupWarningFlare",
	"RescueHeli",
}


-- Geo関連登録 --
-- パスサーチタグの登録
GeoPathService.RegisterPathTag( "Elude", 0 )
GeoPathService.RegisterPathTag( "Jump", 1 )
GeoPathService.RegisterPathTag( "Fence", 2 )
GeoPathService.RegisterPathTag( "StepOn", 3 )
GeoPathService.RegisterPathTag( "Behind", 4 )
GeoPathService.RegisterPathTag( "Urgent", 5 )
GeoPathService.RegisterPathTag( "Pipe", 6 )
GeoPathService.RegisterPathTag( "Climb", 7 )
GeoPathService.RegisterPathTag( "Rail", 8 )
GeoPathService.RegisterPathTag( "ForceFallDown", 9 )


-- パスエッジサーチタグの登録
GeoPathService.RegisterEdgeTag( "Stand", 0 )
GeoPathService.RegisterEdgeTag( "Squat", 1 )
GeoPathService.RegisterEdgeTag( "BEHIND_LOW", 2 )
GeoPathService.RegisterEdgeTag( "FenceElude", 3 )
GeoPathService.RegisterEdgeTag( "Elude", 4 )
GeoPathService.RegisterEdgeTag( "Jump", 5 )
GeoPathService.RegisterEdgeTag( "Fence", 6 )
GeoPathService.RegisterEdgeTag( "StepOn", 7 )
GeoPathService.RegisterEdgeTag( "Behind", 8 )
GeoPathService.RegisterEdgeTag( "Urgent", 9 )
GeoPathService.RegisterEdgeTag( "NoEnd", 10 )
GeoPathService.RegisterEdgeTag( "NoStart", 11 )
GeoPathService.RegisterEdgeTag( "FenceJump", 12 )
GeoPathService.RegisterEdgeTag( "Wall", 13 )
GeoPathService.RegisterEdgeTag( "NoWall", 14 )
GeoPathService.RegisterEdgeTag( "ToIdle", 15 )
GeoPathService.RegisterEdgeTag( "EnableFall", 16 )

-- パスノードサーチタグの登録
GeoPathService.RegisterNodeTag( "Edge", 0 )
GeoPathService.RegisterNodeTag( "Cover", 1 )
GeoPathService.RegisterNodeTag( "BEHIND_LOOK_IN", 2 )
-- 崖のぼり用パスノードサーチタグの登録
GeoPathService.RegisterNodeTag( "CHANGE_TO_60", 3 )
-- ターンモーションが出来ない場合のタグ（パイプ）
GeoPathService.RegisterNodeTag( "NoTurn", 4 )

GeoPathService.RegisterNodeTag( "BEHIND_STOP", 5 )

-- パイプから出られない場合のタグ（パイプ）
GeoPathService.RegisterNodeTag( "NoOut", 6 )

GeoPathService.BindEdgeTag( "Elude", "Wall" )
GeoPathService.BindEdgeTag( "Elude", "NoWall" )
GeoPathService.BindEdgeTag( "Elude", "NoEnd" )
GeoPathService.BindEdgeTag( "Elude", "Urgent" )
GeoPathService.BindEdgeTag( "Elude", "FenceElude" )
GeoPathService.BindEdgeTag( "Elude", "EnableFall" )

GeoPathService.BindEdgeTag( "Urgent", "Wall" )
GeoPathService.BindEdgeTag( "Urgent", "NoEnd" )
GeoPathService.BindEdgeTag( "Urgent", "Urgent" )
GeoPathService.BindEdgeTag( "Urgent", "FenceElude" )

GeoPathService.BindNodeTag( "Behind", "BEHIND_LOOK_IN" )
GeoPathService.BindNodeTag( "Behind", "BEHIND_STOP" )
GeoPathService.BindEdgeTag( "Behind", "BEHIND_LOW" )

GeoPathService.BindEdgeTag( "Jump", "FenceJump" )

GeoPathService.BindNodeTag( "Climb", "Edge" )

GeoPathService.BindNodeTag( "Pipe", "NoTurn" )
GeoPathService.BindNodeTag( "Pipe", "NoOut" )
GeoPathService.BindEdgeTag( "Pipe", "NoEnd" )
GeoPathService.BindEdgeTag( "Pipe", "NoStart" )

GeoPathService.BindEdgeTag( "Fence", "ToIdle" )
GeoPathService.BindEdgeTag( "Fence", "EnableFall" )



-- PH_COL_GROUP_ID_CHARACTER	: 1 ・・・ Player/NPC/Animal(馬含む)
-- PH_COL_GROUP_ID_WEAPON		: 2 ・・・ 捨てたときの武器
-- PH_COL_GROUP_ID_VEHICLE		: 3 ・・・ 乗り物
-- PH_COL_GROUP_ID_GIMMICK_S	: 4 ・・・ 物理ギミック(小) 30cm以下
-- PH_COL_GROUP_ID_GIMMICK_L	: 5 ・・・ 物理ギミック(大) 乗り物/爆発時のみ
-- PH_COL_GROUP_ID_RAGDOLL		: 6 ・・・ ラグドール
-- PH_COL_GROUP_ID_WEAPON_NOHIT	: 7 ・・・ 捨てたときの武器（物理に当たらないバージョン）

local phdaemon = PhDaemon.GetInstance();
-- 15fps まで許可
PhDaemon.SetUpdateDtMax(1.0/15.0)
PhDaemon.SetWorldMin(Vector3(-4000.0,-1000.0,-4000.0))
PhDaemon.SetWorldMax(Vector3( 4000.0, 3000.0, 4000.0))
-- キャラ
phdaemon.SetCollisionGroupState(1,3,false)
phdaemon.SetCollisionGroupState(1,4,true) -- 対ギミックS
phdaemon.SetCollisionGroupState(1,6,true) -- 対ラグドール

-- 乗り物
phdaemon.SetCollisionGroupState(3,3,true) -- 対車両
phdaemon.SetCollisionGroupState(3,4,true) -- 対ギミックS
phdaemon.SetCollisionGroupState(3,5,true) -- 対ギミックL
phdaemon.SetCollisionGroupState(3,6,true) -- 対ラグドール

-- 捨てたときの武器（物理に当たらない）
phdaemon.SetCollisionGroupState(7,1,false)
phdaemon.SetCollisionGroupState(7,2,false)
phdaemon.SetCollisionGroupState(7,3,false)
phdaemon.SetCollisionGroupState(7,4,false)
phdaemon.SetCollisionGroupState(7,5,false)
phdaemon.SetCollisionGroupState(7,6,false)


--------
-- UI管理起動
dofile( "Tpp/Scripts/Ui/TppUiBootInit.lua" )

--------
--MotherBase
TppMotherBaseManager.Create()
Fox.Log("----- Create - TppMotherBaseManager")

-- GMPミッション設定
if TppGameSequence.GetGameTitleName() == "TPP" then
	dofile( "/Assets/tpp/motherbase/gmpEarnMissions.lua" )
	Fox.Log("----- Call - gmpEarnMissions.lua")
end

-- カセットテープ情報のセットアップ
-- TppMusicManagerの情報を使うので、TppSoundDaemon初期化より後に実行
-- また、TppUiCommonDataManagerによって生成されるので、UIより後に実行
TppCassetteTapeInfo.Setup()


-- エディタ用スクリプト置き場の登録
if Editor then
	package.path = package.path .. ";/Assets/tpp/editor_scripts/?.lua"
end

if TppGameSequence.GetGameTitleName() == "TPP" then
	--ReleaseGameBuild仮テスト用ではこの五行は要らない
	local app = Application:GetInstance()
	local game = app:GetMainGame()
	local mainScene = app:GetScene("MainScene")
	local setupBucket	= game:CreateBucket( "SetupBucket", mainScene )
	setupBucket:LoadProjectFile( "/Assets/tpp/level/location/SetupLocation2.fxp" );
end

-- TppLightProbe/SkyCapture用のインスタンス初期化
if Editor then
	TppLightCapture.InitInstance()
end

if TppGameSequence.GetGameTitleName() == "TPP" then
	TppGameSequence.SetSystemBlockSize(2*1024*1024,40.5*1024*1024) -- 常駐ブロックサイズ、ロケーションブロックサイズ(ステージとミッションの合計が入るくらいのサイズ）gntnでメモリ不足になるのでコメントアウトします
else	
	TppGameSequence.SetSystemBlockSize(1*1024*1024+10*1024,40.5*1024*1024) -- 常駐ブロックサイズ、ロケーションブロックサイズ(ステージとミッションの合計が入るくらいのサイズ）gntnでメモリ不足になるのでコメントアウトします
end
MissionManager.CreateMissionBlockGroup(30.5*1024*1024)

if TppGameSequence.GetGameTitleName() == "TPP" then
	TppGameSequence.LoadResidentBlock("/Assets/tpp/pack/resident/resident00.fpk" ) -- TPP 用常駐パック

	-- TPP側でGZ用パックをprerequisiteしているfpkをLoadしたときにERRORが出るのを抑制するための設定
	TppGameSequence.SetGzResidentPackagePath("/Assets/tpp/pack/resident/resident01.fpk" ) 
else
--	TppGameSequence.LoadResidentBlock("/Assets/tpp/pack/resident/resident01.fpk" ) -- GZ 用常駐パック（グアンタナモ＋マザーベース） -- start2nd.luaへ Y.Ogaito 2013.11.上
end

if TppGameSequence.GetGameTitleName() == "TPP" then
	MissionManager.SetDefaultEnemyMotionPackagePath("/Assets/tpp/pack/soldier/motion/TppSoldierMotion.fpk")
else
	MissionManager.SetDefaultEnemyMotionPackagePath("/Assets/tpp/pack/soldier/motion/TppSoldierGzMotion.fpk")
end

if TppGameSequence.GetGameTitleName() == "TPP" then
	dofile( "/Assets/tpp/level/all_load/tppSetupLocation.lua" )
else
	--dofile( "/Assets/tpp/level/all_load/gzSetupLocation.lua" ) ←↓gzSetupLocation.luaより引っ越してきました。Y.Ogaito 2013.11.20
	LocationManager.RegisterLocationInformation(39,3,"/Assets/tpp/pack/ui/gz/title_datas.fpk") --title
	LocationManager.RegisterLocationInformation(38,3,"/Assets/tpp/pack/ui/gz/title_datas.fpk") --ending
	LocationManager.RegisterLocationInformation(40,1,"/Assets/tpp/pack/location/gntn/gntn.fpk") 
	LocationManager.RegisterLocationInformation(45,1,"/Assets/tpp/pack/location/ombs/ombs.fpk")
end

-- PlayerTypeTableの初期化
--PlayerManager:SetUpTable("Tpp/Scripts/Characters/Player/PlayerTypeTable.lua") -- start2nd.luaへ Y.Ogaito 2013.11.20

-- PlayerBlockControllerの初期化

-- タイトル別
if TppGameSequence.GetGameTitleName() == "TPP" then
	TppPlayerBlockControllerService:SetResidentPackPath("/Assets/tpp/pack/player/resident/pl_resident_tpp.fpk")
	TppPlayerBlockControllerService:SetResidentBlockSize(300*1024) -- residentBlockサイズの設定
	TppPlayerBlockControllerService:SetPartsBlockSize(2.5*1024*1024) -- partsBlockサイズの設定
	TppPlayerBlockControllerService:SetMotionBlockSize(20.5*1024*1024) -- motionBlockサイズの設定
	TppPlayerBlockControllerService:SetMotionPackPath("/Assets/tpp/pack/player/motion/plmot_base_default.fpk") -- defaultのMotionFpkPathの設定
	TppPlayerBlockControllerService:CreateResidentBlockGroup()
	TppPlayerBlockControllerService:CreatePartsBlockGroup(0) -- singlePlayer用のpartsBlockの生成
	TppPlayerBlockControllerService:CreateMotionBlockGroup()
	TppPlayerBlockControllerService:RequestLoadResidentBlock("/Assets/tpp/pack/player/resident/pl_resident_tpp.fpk")

else
	TppPlayerBlockControllerService:SetResidentPackPath("/Assets/tpp/pack/player/resident/pl_resident.fpk")
	TppPlayerBlockControllerService:SetResidentBlockSize(300*1024) -- residentBlockサイズの設定
	TppPlayerBlockControllerService:SetPartsBlockSize(1.8*1024*1024) -- partsBlockサイズの設定
	TppPlayerBlockControllerService:SetMotionBlockSize(15*1024*1024) -- motionBlockサイズの設定
	TppPlayerBlockControllerService:SetMotionPackPath("/Assets/tpp/pack/player/motion/plmot_base_gz.fpk") -- defaultのMotionFpkPathの設定
	TppPlayerBlockControllerService:CreateResidentBlockGroup()
	TppPlayerBlockControllerService:CreatePartsBlockGroup(0) -- singlePlayer用のpartsBlockの生成
	TppPlayerBlockControllerService:CreateMotionBlockGroup()
--	TppPlayerBlockControllerService:RequestLoadResidentBlock("/Assets/tpp/pack/player/resident/pl_resident.fpk") -- start2nd.luaへ Y.Ogaito 2013.11.上
end

--TppPlayerUtility.Initialize() -- start2nd.luaへ Y.Ogaito 2013.11.20

if Player then
	Player.RegisterCommonMotionPackagePath( "DefaultCommonMotion", "/Assets/tpp/pack/player/motion/player2_common_motion.fpk", "/Assets/tpp/motion/motion_graph/player2/TppPlayer2_layers.mog" )
	Player.RegisterCommonMtarPath( "/Assets/tpp/motion/mtar/player2/TppPlayer2_layers.mtar" )
	Player.RegisterPartsPackagePath( "PLTypeNormal", "/Assets/tpp/pack/player/parts/plparts_normal.fpk", "/Assets/tpp/parts/chara/sna/sna0_main0_def_v00.parts" )
	Player.RegisterPartsPackagePath( "PLTypeNormalScarf", "/Assets/tpp/pack/player/parts/plparts_normal_scarf.fpk", "/Assets/tpp/parts/chara/sna/sna0_main1_def_v00.parts" )
	Player.RegisterPartsPackagePath( "PLTypeSneakingSuit", "/Assets/tpp/pack/player/parts/plparts_sneaking_suit.fpk", "/Assets/tpp/parts/chara/sna/sna2_main0_def_v00.parts" )
	Player.RegisterPartsPackagePath( "PLTypeHospital", "/Assets/tpp/pack/player/parts/plparts_hospital.fpk", "/Assets/tpp/parts/chara/sna/sna1_main0_def_v00.parts" )
	Player.RegisterPartsPackagePath( "PLTypeRider", "/Assets/tpp/pack/player/parts/plparts_rider.fpk", "/Assets/tpp/parts/chara/sna/sna3_main0_def_v00.parts" )
	Player.RegisterPartsPackagePath( "PLTypeMGS1", "/Assets/tpp/pack/player/parts/plparts_mgs1.fpk", "/Assets/tpp/parts/chara/sna/sna6_main0_def_v00.parts" )
end

-- EquipSystem の初期化
if TppEquipSystem then
	TppEquipSystem.Initialize{
		equipObjectMaxCount = 120,
		equipObjectRealizedMaxCount = 80,
	}
end

if TppRouteAnimationCollector then
	TppRouteAnimationCollector.RegisterGaniPath( "SoldierLookWatch",	"/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_a.gani" );
	TppRouteAnimationCollector.RegisterGaniPath( "SoldierWipeFace",		"/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_d.gani" );
	TppRouteAnimationCollector.RegisterGaniPath( "SoldierYawn",			"/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_f.gani" );
	TppRouteAnimationCollector.RegisterGaniPath( "SoldierSneeze",		"/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_g.gani" );
	TppRouteAnimationCollector.RegisterGaniPath( "SoldierFootStep",		"/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_h.gani" );
	TppRouteAnimationCollector.RegisterGaniPath( "SoldierCough",		"/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_i.gani" );
	TppRouteAnimationCollector.RegisterGaniPath( "SoldierScratchHead",	"/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_o.gani" );
	TppRouteAnimationCollector.RegisterGaniPath( "SoldierHungry",		"/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_p.gani" );
end

-- VehicleBlockControllerの初期化
TppVehicleBlockControllerService:SetHorseBlockSize(3.5*1024*1024)
TppVehicleBlockControllerService:SetHorseBlockPath("/Assets/tpp/pack/horse/horse_block.fpk")
TppVehicleBlockControllerService:SetHorseLocatorBlockSize(16*1024)
TppVehicleBlockControllerService:SetHorseLocatorBlockPath("/Assets/tpp/pack/horse/horse_locator.fpk")
TppVehicleBlockControllerService:SetVehicleBlockSize(4*1024*1024)
TppVehicleBlockControllerService:SetHeliBlockSize(1.90*1024*1024)  -- GZ用にサイズ削減。最終的には2.29MBの予定
TppVehicleBlockControllerService:SetHeliBlockDefaultPath("/Assets/tpp/pack/heli/support_heli.fpk")

-- CollectibleDataManagerの初期化
--TppCollectibleDataManager:SetupTable("Tpp/Scripts/NewCollectibles/CollectibleIdTable.lua")  -- start2nd.luaへ Y.Ogaito 2013.11.20
TppCollectibleBlockControllerService:SetBlockInfo( TppCollectibleBlock.BLOCK_COMMON, 1, 1760*1024 )
TppCollectibleBlockControllerService:SetBlockInfo( TppCollectibleBlock.BLOCK_PLAYER_PRIMARY_WEAPON, 1, 0.5*1024*1024 )
TppCollectibleBlockControllerService:SetBlockInfo( TppCollectibleBlock.BLOCK_PLAYER_PRIMARY2_WEAPON, 1, 0.5*1024*1024 )
TppCollectibleBlockControllerService:SetBlockInfo( TppCollectibleBlock.BLOCK_PLAYER_SECONDARY_WEAPON, 1, 0.5*1024*1024 )
TppCollectibleBlockControllerService:SetBlockInfo( TppCollectibleBlock.BLOCK_PLAYER_ITEM, 5, 128*1024 )
TppCollectibleBlockControllerService:SetBlockInfo( TppCollectibleBlock.BLOCK_MISSION_WEAPON, 8, 0.5*1024*1024 )
TppCollectibleBlockControllerService:SetBlockInfo( TppCollectibleBlock.BLOCK_SUPPORT_WEAPON, 6, 0.2*1024*1024 )
TppCollectibleBlockControllerService:SetBlockInfo( TppCollectibleBlock.BLOCK_PLAYER_MOTION, 3, 640*1024 )

if TppGameSequence.GetGameTitleName() == "TPP" then
-- GZ用のPack名を設定(ERROR回避用)
	TppCollectibleBlockControllerService.SetGzColCommonPackagePath("/Assets/tpp/pack/collectible/common/col_common.fpk")
end

-- EquipmentParameterTableの初期化
--TppEquipmentParameterManager:SetupTable("Tpp/Scripts/NewCollectibles/MotionInfoTableForTest.lua")  -- start2nd.luaへ Y.Ogaito 2013.11.20

-- 下記の４つをひとつに纏めたもの
--dofile( "Tpp/Scripts/NewCollectibles/ParameterTableLoaderAllIn.lua" )  -- start2nd.luaへ Y.Ogaito 2013.11.20
--dofile( "Tpp/Scripts/Characters/Damages/DamageParameterTableLoader.lua" )
--dofile( "Tpp/Scripts/NewCollectibles/EquipmentParameterTableLoader.lua" )
--dofile( "Tpp/Scripts/NewCollectibles/RecoilMaterialParameterTableLoader.lua" )
-- 車両エフェクト
--dofile( "Tpp/Scripts/Characters/VehicleMaterialInfoTableLoader.lua" )


local gameFlags = {
	e20010_cassette = false,
	e20010_xof = false,
	hardmode = false,
	titleBlackOut = false,
	isSkin1Enabled = false,
	isSkin2Enabled = false,
	isLowSkin1Enabled = false,
	isLowSkin2Enabled = false,
	playerSkinMode = 0,
	e20010_beforeBestRank = 0,
	trialOpen = 0,
	rewardNumOfMissionStart = 0,
}

TppGameSequence.RegisterGameFlags( gameFlags )

if TppGameSequence.GetGameTitleName() == "GZ" then
	MissionManager.RegisterResidentMissionInfo( 20000, 0, "/Assets/tpp/pack/ui/gz/title_datas.fpk", 4, 0xc )

	-- インストール画面設定
	MissionManager.RegisterResidentMissionInfo( 20001, 0, "/Assets/tpp/pack/ui/gz/title_install.fpk", 4, 0xc )
	TppGameSequence.RegisterTitleInformation(3,"",39)
end

if Editor then
	-- ミッション配置ツールのコンバートスクリプトの指定。コンバート内容のハードコーディングを避けたいから。避けきれてないけど。
	TppEdMissionListEditInfo.SetConverterScriptPath("Tpp/Scripts/Classes/TppEdMissionConverterCaller.lua"  )
	-- デモエディット用パッケージの指定
	EdDemoEditBlockController.AddToolsBlockPath("/Assets/tpp/demo/event/info/TppEdDemoEditTools.fpk")
end

-- Tpp用WorldName登録
if NavWorldDaemon then
	if TppGameSequence.GetGameTitleName() == "GZ" then
		-- GZ専用World生成
		NavWorldDaemon.AddWorld("MainScene", "", 60) -- 敵兵
		NavWorldDaemon.AddWorld("MainScene", "sky" , 1) -- 空ナビ
	else
		-- TPPでのWorld生成
		NavWorldDaemon.AddWorld("MainScene", "", 4000) -- 敵兵
		NavWorldDaemon.AddWorld("MainScene", "sky" ) -- 空ナビ
		NavWorldDaemon.AddWorld("MainScene", "sahelan" ) -- サヘラン
	end
end

if DEBUG then
	if GameObjectDebugCamera then
		-- GameObject用デバッグカメラ生成
		GameObjectDebugCamera.Setup()
	end
end

local installCheck = false
-- Select起動
if LuaUnitTest == null then
	if TppGameSequence.IsMaster() == false then
		if Selector then
			if platform ~= 'Windows' or not Editor then
				-- ステージセレクタースクリプト置き場の登録
				package.path = package.path .. ";/Assets/tpp/level/debug_menu/?.lua"
				-- TPP_IS_GZ で分けます
				if TppGameSequence.GetGameTitleName() == "TPP" then
					TppGameSequence.RegisterTitleInformation(1,"",39)
					TppGameSequence.RegisterTitleInformation(2,"/Assets/tpp/level/debug_menu/Select.lua") -- デバッグセレクト画面を登録
					TppGameSequence.RequestTitle(2) --デバッグセレクトを起動
				else
					-- F_DISC_IMAGEはインストール有無判定が必須のため
					local uiCommonData = UiCommonDataManager.GetInstance()
					if uiCommonData:IsDiscImage() == true then
						TppGameSequence.RegisterTitleInformation(1,"",39)
						TppGameSequence.RegisterTitleInformation(2,"/Assets/tpp/level/debug_menu/SelectGZ.lua") -- デバッグセレクト画面を登録
						uiCommonData:CreateInstallCheckJob()
						installCheck = true
					else
						TppGameSequence.RegisterTitleInformation(1,"",39)
						TppGameSequence.RegisterTitleInformation(2,"/Assets/tpp/level/debug_menu/SelectGZ.lua") -- デバッグセレクト画面を登録
						TppGameSequence.RequestTitle(2) --デバッグセレクトを起動
					end
				end
			else
				TppGameSequence.RegisterTitleInformation(1,"",39)
			end
		else
			-- QA_RELEASE ビルドでここに来る可能性あり
			if TppGameSequence.GetGameTitleName() == "TPP" then
				TppGameSequence.RegisterTitleInformation(1,"",39)
				TppGameSequence.RegisterTitleInformation(2,"/Assets/tpp/level/debug_menu/Select.lua") -- 正規タイトル画面を登録 --まだない
				TppGameSequence.RequestTitle(2) --デバッグセレクトを起動
			else
				--タイトル画面の事前設定( ロゴスキップ有無もここで指定 )
				local uiCommonData = UiCommonDataManager.GetInstance()
				local isLogoSKip = true
				uiCommonData:GzTitlePreSetting( isLogoSKip )

				-- インストール有無判定してのタイトル起動
				TppGameSequence.RegisterTitleInformation(1,"",39)
				uiCommonData:CreateInstallCheckJob()
				installCheck = true
			end
		end --Selector
	else --IsMaster
		if TppGameSequence.GetGameTitleName() == "TPP" then
			TppGameSequence.RegisterTitleInformation(2,"/Assets/tpp/level/debug_menu/Select.lua") -- 正規タイトル画面を登録 --まだない
			TppGameSequence.RequestTitle(2) --デバッグセレクトを起動
		else
			--タイトル画面の事前設定
			local uiCommonData = UiCommonDataManager.GetInstance()
			local isLogoSKip = false
			uiCommonData:GzTitlePreSetting( isLogoSKip )

			-- インストール有無判定してのタイトル起動
			TppGameSequence.RegisterTitleInformation(1,"",39)
			uiCommonData:CreateInstallCheckJob()
			installCheck = true
		end
	end --IsMaster
end --LuaUnitTest

--マスターっぽいの以外は、start2nd.luaを起動する
if installCheck == false then
	TppGameSequence.RequestGameSetup()
end

-- デバッグ文字列検索ファイル
if DEBUG then
	if platform == 'Windows' then
		DEBUG.RegisterDebugStringHashTableListFile{path='Z:/tpp/toolbox/inhouse/Config/StringHashTable/tppshtlist.txt'}
	end
end

-- デバッグカメラ生成
if DEBUG then
	if TppDebugCamera then
		TppDebugCamera.Create()
	end
end

-- start.lua のタイミングで呼ぶ初期化処理
TppNewCollectibleModule.InitializeWhenStartLua()


if DEBUG then
	local debugStartLuaPath = "Tpp/Debug/Scripts/debug_start.lua"
	local file = io.open( debugStartLuaPath, "r" )
	if file ~= nil then
		io.close( file )
		Fox.Log( "do debug_start.lua" )
		dofile( debugStartLuaPath )
	end
	
	if TppNetworkUtil then
		TppNetworkUtil.DEBUG_StartAutoDebugSession()
	end
end

Fox.Log("Tpp/start.lua End.") --加えてみる Y.Ogaito 2010.12.09

