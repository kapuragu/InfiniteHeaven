-------------------------------------------------------------------------------
-- UI起動スクリプト
-------------------------------------------------------------------------------
TppMenuTerminal = {

-------------------------------------------------------------------------------
-- 更新
-------------------------------------------------------------------------------
-- C++化しました(2011/12/20)
__Update = function( chara , plugin )

	-- 割り当てボタンでのメニュOnOffトグル操作
	-- XBOX360版で、AssetManager通信を封じるコマンドを使いたいために、and not 以降があります。後で消してください。@TODO Y.Ogaito 負荷検証 ボタン整理 XBOX360
	-- → 消しました。2011/11/29 Sonoyama
	--if Pad.GetButtonPress( 0, "MB_DEVICE" ) and not Pad.GetButtonStatus( 0, fox.PAD_START ) then
	if Pad.GetButtonPress( 0, "MB_DEVICE" ) then
		if plugin:IsVisible() then
			plugin:Stop()
		else
			plugin:Start()
		end
	end

end,

}