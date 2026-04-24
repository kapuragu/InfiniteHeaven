--[[
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	Author		：	Tanimoto_Hayato
	Outline		：	TPPステージ共通設定

	Description	：	TPPステージ共通で必要な設定をまとめる
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
]]--

tpp_default_setting = {

-- ******************************************************************************************* --
--　スクリプト初期設定
-- ******************************************************************************************* --
-- イベントリスナーの登録
events = {
	clockListener = {
		clock_mafrDay_clockEventMessage = "OnClockMafrDay",		-- mafr各ミッション共通朝
		clock_mafrNight_clockEventMessage = "OnClockMafrNight",	-- mafr各ミッション共通夜
		clock1900_clockEventMessage = "OnClock1900"
		},
},

-- ******************************************************************************************* --
--　共通処理関数
-- ******************************************************************************************* --

-- アフリカ朝
OnClockMafrDay = function( data, body, sender, id, hour, minute, arg3, arg4 )

	Fox.Log("africa day time!")
	return true

end,

-- アフリカ夜
OnClockMafrNight = function( data, body, sender, id, hour, minute, arg3, arg4 )

	Fox.Log("africa night time!")
	return true

end,

-- 強制指定時間チェンジ（2012,10末デバッグ用。10末以降消されます）
OnClock1900 = function( data, body, sender, id, hour, minute, arg3, arg4 )

	local wm=TppWeatherManager:GetInstance()
	wm:DebugSetCurrentClock(06,30)
	return true

end,

}