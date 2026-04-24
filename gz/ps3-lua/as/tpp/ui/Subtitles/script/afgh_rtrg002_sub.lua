--------------------------------------------------------------------------------
-- 無線再生後に音声無字幕を表示させる
--------------------------------------------------------------------------------
afgh_rtrg002_sub = {

--================================================================================
-- data への動的プロパティの追加・初期値設定
--================================================================================
AddDynamicPropertiesToData = function( data, body )
	data:AddProperty( "String", "msgID")         -- メッセージID
	data:AddProperty( "String", "key")           -- 字幕コントローラー名
end,

--================================================================================
-- 初期化
--================================================================================
Init = function( data, body )

	local storage = body.storage

        storage:AddProperty( "bool", "isRead" )
        storage.isRead = false

	Fox.Log( "============ Call radioMsgBox:AddSubscriber =========== " )
end,

--================================================================================
-- メッセージボックスの登録
--================================================================================
SetMessageBoxes = function( data, body )
	local radioMsgBox		= RadioDaemon.GetMessageBox()

	body:AddMessageBox( "RADIO_MSGBOX", radioMsgBox )

end,

--================================================================================
-- イベントリスナー
--================================================================================
events = {
        -- GameScriptに登録した"RADIO_MSGBOX"キーから"RadioGroupName_radioEventMessage"メッセージが届いたらDisplayTelopを実行
        RADIO_MSGBOX = { afgh_rtrg002_radioEventMessage="DisplayTelop" },
},

-- テロップ表示関数
DisplayTelop = function( data, body, sender, id, arg1, arg2, arg3, arg4 )
	Fox.Log( "============ Call DisplayTelop =========== " )
	local storage = body.storage
	if not storage.isRead then
		local eventType = arg1
		if eventType == 1 then
			-- 既読フラグを立てる
			storage.isRead = true


			Fox.Log( "============ Call DisplayTelop2 =========== " )

			-- 無線をコール
			SubtitlesCommand.Display( data.msgID, data.key )
		end
	end
end,

}