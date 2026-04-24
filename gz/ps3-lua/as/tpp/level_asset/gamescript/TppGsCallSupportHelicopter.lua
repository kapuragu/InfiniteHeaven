--[[FDOC
	@id TppGsCallSupportHelicopter
	@category Script GameScript
	@brief 発煙筒に反応して支援ヘリを出撃させるゲームスクリプト
]]--

TppGsCallSupportHelicopter = {

--------------------------------------------------------------------------------
-- 初期設定
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- イベントリスナーの登録
events = {
	Player = {
		NotifyStartWarningFlare="OnStartWarningFlare",
		CallRescueHeli="OnStartMotherBaseDevise"
	},
},

-- 動的プロパティの追加
AddDynamicPropertiesToData = function( data, body )

	-- イベントキーの準備
	if data.variables.Player == NULL then
		data.variables.Player = nil
	end

end,

-- 初期化
Init = function( data, body )

	--Fox.Log( "CallRescueHelicopter.Init()" )

end,

-- メッセージボックスリストの設定
SetMessageBoxes = function( data, body )

	--Fox.Log( "CallRescueHelicopter.SetMessageBoxes()" )
	
	--Playerのメッセージボックス設定
	local playerMessageBox = PlayerManager:GetManagerMessageBox()
	body:AddMessageBox( "Player", playerMessageBox )

end,

-- チェックポイントデータの復元
Restore = function( data, body )

	--Fox.Log( "CallRescueHelicopter.Restore()" )

end,

--================================================================================
-- イベントリスナー
--================================================================================
-- 発煙筒が使用された時に呼ばれる処理
OnStartWarningFlare = function( data, body, sender, id, arg1, arg2, arg3, arg4 )
	local heliLocator = body.messageBoxes.Helicopter.owner
	TppSupportHelicopterService.CallSupportHelicopter(arg1)
	TppSupportHelicopterService.RequestAirStrike()

end,

-- マザベ端末からコールされた時に呼ばれる処理
OnStartMotherBaseDevise = function( data, body, sender, id, arg1, arg2, arg3, arg4 )

	local heliLocator = body.messageBoxes.Helicopter.owner
	TppSupportHelicopterService.CallSupportHelicopter(arg1)

end,

}

