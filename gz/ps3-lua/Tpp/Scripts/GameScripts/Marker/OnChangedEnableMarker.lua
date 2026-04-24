
OnChangedEnableMarker = {

--------------------------------------------------------------------------------
-- 初期設定
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- イベントリスナーの登録
events = {
	markedLocator = { OnChangedEnable="OnChangedEnable" },
},

-- 動的プロパティの追加
AddDynamicPropertiesToData = function( data, body )
	-- マークされるオブジェクトのロケーター
	if data.variables.markedLocator == NULL then
		data.variables.markedLocator = nil
	end
	
	-- 表示テキスト
	data:AddProperty( "String", "text", 1 )
	data.text = ""
	
	-- 生存時間(1/60)
	data:AddProperty( "uint32", "textLife", 1 )
	data.textLife = 60 * 5
	
	-- 表示位置 X
	data:AddProperty( "uint32", "textPosX", 1 )
	data.textPosX = 100
	
	-- 表示位置 Y
	data:AddProperty( "uint32", "textPosY", 1 )
	data.textPosY = 320
	
	-- サイズ
	data:AddProperty( "float", "textSize", 1 )
	data.textSize = 60
	
	-- 色
	data:AddProperty( "Color", "textColor" )
	data.textColor = Color{ 1.0, 1.0, 1.0, 1.0 }
	
	-- 色
	data:AddProperty( "String", "playSoundLabel" )
	data.playSoundLabel = ""
end,

-- 初期化
Init = function( data, body )

	--Fox.Log( "CallRescueHelicopter.Init()" )

end,

-- メッセージボックスリストの設定
SetMessageBoxes = function( data, body )

	--Fox.Log( "CallRescueHelicopter.SetMessageBoxes()" )

end,

-- チェックポイントデータの復元
Restore = function( data, body )

	--Fox.Log( "CallRescueHelicopter.Restore()" )

end,

--================================================================================
-- イベントリスナー
--================================================================================
OnChangedEnable = function( data, body, sender, id, arg1, arg2, arg3, arg4 )
	local textData = string.gsub( data.text, "\\n", "\n" )
	
	-- 文字列出力
	GrxDebug.Print2D {	-- 時間指定
		life = 	data.textLife,
		x = 	data.textPosX,
		y = 	data.textPosY,
		size = 	data.textSize,
		color = data.textColor,
		args = 	{ textData }
	}
	
	-- 指定サウンドを再生
	SoundCommand.PostEvent( data.playSoundLabel )
end,


}
