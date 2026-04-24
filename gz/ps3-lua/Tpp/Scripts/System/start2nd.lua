-- TppMain start2nd script
-- 起動後のぐるぐるが出てからロゴが出るまでの間に何とか１回は発行しておきたい.lua
-- ※一回発行したら二度と発行されません。

Fox.Log("Tpp/Scripts/System/start2nd.lua") -- 変えてみる Y.Ogaito 2013.11.13

--------------------
-- 字幕用システムの初期化 --←↓TppUiBootUnit.luaより引っ越してきました Y.Ogaito 2013.11.20
-- パスの設定はタイトル画面に入る前に行う必要があるため元の位置に。重いdofileは2ndのまま。
local subtitlesDaemon = SubtitlesDaemon.GetInstance()
if SubtitlesCommand then
	dofile( "/Assets/tpp/ui/Subtitles/script/priorityTable.lua")
	dofile( "/Assets/tpp/ui/Subtitles/script/chapterNameTable.lua")
	dofile( "/Assets/tpp/ui/Subtitles/script/sdTextRelationalTableNotEd.lua")
end
Fox.Log("----- Create - SubtitlesDaemon")

-- ストーリーフラグ --←↓start.luaより引っ越してきました。 Y.Ogaito 2013.11.20
if TppGameSequence.GetGameTitleName() == "GZ" then
	StoryFlags.SetScript( "/Assets/tpp/level/all_load/gzStoryFlag.lua" )
else
	StoryFlags.SetScript( "/Assets/tpp/level/all_load/StoryFlag.lua" )
end
StoryFlags.Initialize()
StoryFlags.SetUsingCheckpointMode( true )

--プレイヤー関連 --←↓start.luaより引っ越してきました。 Y.Ogaito 2013.11.20
PlayerManager:SetUpTable("Tpp/Scripts/Characters/Player/PlayerTypeTable.lua")
TppPlayerUtility.Initialize()
TppEquipmentParameterManager:SetupTable("Tpp/Scripts/NewCollectibles/MotionInfoTableForTest.lua")
TppCollectibleDataManager:SetupTable("Tpp/Scripts/NewCollectibles/CollectibleIdTable.lua")
dofile( "Tpp/Scripts/NewCollectibles/ParameterTableLoaderAllIn.lua" )

--常駐ブロック
TppGameSequence.LoadResidentBlock("/Assets/tpp/pack/resident/resident01.fpk" ) -- GZ 用常駐パック（グアンタナモ＋マザーベース）
TppPlayerBlockControllerService:RequestLoadResidentBlock("/Assets/tpp/pack/player/resident/pl_resident.fpk")	

--モーション関連のサウンド指定 --←↓start.luaより引っ越してきました。 Y.Ogaito 2013.11.20
dofile( '/Assets/tpp/sound/scripts/motion/setup.lua' )


Fox.Log("Tpp/Scripts/System/start2nd.lua End.") --加えてみる Y.Ogaito 2013.11.13
