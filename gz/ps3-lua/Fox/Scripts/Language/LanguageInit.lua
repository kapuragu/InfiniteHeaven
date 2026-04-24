-------------------------------------------------------------------------------
--[[
	言語初期化処理
]]
--------------------------------------------------------------------------------
Fox.Log("********** Start - LanguageInit.lua ********** ")

--------------------
----- 言語設定
AssetConfiguration.SetDefaultCategory( "Language", "jpn" )
-- AssetConfiguration.SetDefaultCategory( "Language", "eng" )
-- AssetConfiguration.SetDefaultCategory( "Language", "fre" )
-- AssetConfiguration.SetDefaultCategory( "Language", "ita" )
-- AssetConfiguration.SetDefaultCategory( "Language", "ger" )
-- AssetConfiguration.SetDefaultCategory( "Language", "spa" )
-- AssetConfiguration.SetDefaultCategory( "Language", "por" )
-- AssetConfiguration.SetDefaultCategory( "Language", "rus" )
-- AssetConfiguration.SetDefaultCategory( "Language", "ara" )

----- 字幕音声言語設定
if SubtitlesDaemon then
	SubtitlesDaemon.SetDefaultVoiceLanguage( "jpn" )
	-- SubtitlesDaemon.SetDefaultVoiceLanguage( "eng" )
	-- SubtitlesDaemon.SetDefaultVoiceLanguage( "fre" )
	-- SubtitlesDaemon.SetDefaultVoiceLanguage( "ita" )
	-- SubtitlesDaemon.SetDefaultVoiceLanguage( "ger" )
	-- SubtitlesDaemon.SetDefaultVoiceLanguage( "spa" )
	-- SubtitlesDaemon.SetDefaultVoiceLanguage( "por" )
	-- SubtitlesDaemon.SetDefaultVoiceLanguage( "rus" )
	-- SubtitlesDaemon.SetDefaultVoiceLanguage( "ara" )
end

Fox.Log("********** End - LanguageInit.lua ********** ")
