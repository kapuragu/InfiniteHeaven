--[[

	グアンタナモ：locationDataScript
	ロケーション起動時処理
	
	2012/09/18 Matsushita_Arata
	新ミッションに対応
--]]

gntn_load2 = {

OnEnterStartGame = function()
	Fox.Log("Guantanamo Location Start!")
	--このロケーションに着てまずやること

	WeatherManager.LoadNewWeatherParametersFile("/Assets/tpp/level/location/gntn/block_common/gntn_climateSettings.twpf")
	WeatherManager.SwitchWeatherDesc("location",7,0) --新天候システムで天候パラメータの複製を作る。全てのパラメータを０秒でコピーする ※戻すのはシステムに任せる。
	WeatherManager.RequestWeather(5,0) --直ちに大雨になれ
	WeatherManager.PauseNewWeatherChangeRandom(true) --新天候でこのミッションが終わるまでランダム天候すな
	--ずっと深夜12時から変わらない設定
	WeatherManager.PauseClock(true) --新天候でこのミッションが終わるまで時間進めるな
	WeatherManager.SetCurrentClock(00,00)
	--天候システムでLUTを指定する仮対処するスクリプト
	TppEffectUtility.SetColorCorrectionLut( "/Assets/tpp/effect/gr_pic/lut/gntn_25thDemo_FILTERLUT.ftex" )
end,

}
