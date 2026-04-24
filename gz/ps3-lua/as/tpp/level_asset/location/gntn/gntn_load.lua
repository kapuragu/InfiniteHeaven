--[[

	グアンタナモ：locationDataScript
	ロケーション起動時処理
	
	2012/03/02 miyata
--]]
gntn_load = {

OnEnterStartGame = function()
	Fox.Log("start!")
	--このロケーションに着てまずやること
	local mm = TppMissionManager:GetInstance()

	-- mm:SetMissionEnable("FreePlay")
	-- mm:SetFreePlayMission("FreePlay")
	mm:SetMissionEnable("m9904")
	mm:RequestAcceptMission("m9904")

	-- 天候大雨
	-- 仮対応。あとでちゃんとした処理の仕方が決まったら消す。
--	Fox.Log("HeavyRain")
--	Command.StartGroup()
--	local weatherManager=TppWeatherManager:GetInstance()
--	weatherManager:DebugSetCurrentWeatherInfo( 0, "WEATHER_TYPE_HEAVY_RAIN", "SUB_WEATHER_TYPE_FOG" )	--0秒後に雨になるように！
--	Command.EndGroup()

	local wm=TppWeatherManager:GetInstance()
	wm:SwitchWeatherDesc("location",7,0) --新天候システムで天候パラメータの複製を作る。全てのパラメータを０秒でコピーする ※戻すのはシステムに任せる。
	--wm:RequestWeather(0,0) --直ちに晴れになれ
	wm:PauseNewWeatherChangeRandom(true) --新天候でこのミッションが終わるまでランダム天候すな
	--ずっと深夜12時から変わらない設定
	wm:PauseClock(true) --新天候でこのミッションが終わるまで時間進めるな
	wm:SetCurrentClock(00,00)

end,

OnUpdateMissionPlayable = function( )

	local mm = TppMissionManager:GetInstance()
	mm:SetMissionEnable("m9904")

end,


}
