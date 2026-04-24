--[[
	最終更新	：2012.06.05
	管理者	：宮田
	内容		：終了シーケンスにおけるデモ終了時にヘリを旋廻ルートへルートチェンジさせる
	
	6/5　作成(DebugDemoEndToHeliRouteChange.luaを本番用に移行)
]]--

missionClearByHelicopter = {

--------------------------------------------------------------------------------
-- 初期設定
--------------------------------------------------------------------------------
-- イベントリスナーの登録
events = {
	DEMO = { PlayEnd="OnDemoEnd" }, -- デモは終了メッセージのみ
},

--------------------------------------------------------------------------------
-- 初期化
Init = function( data, body )
end,

--------------------------------------------------------------------------------
-- メッセージボックスリストの設定
SetMessageBoxes = function( data, body )
	--Fox.Log( "DemoStepPlay.SetMessageBoxes()" )
end,

-- 動的プロパティの追加
AddDynamicPropertiesToData = function( data, body )

	-- イベントキーの準備
	if data.variables.DEMO == NULL then
		data.variables.DEMO = nil
	end

	-- ヘリのロケーター
	data:AddProperty( 'EntityLink', "Heli_Locator" )

	-- ヘリのルート
	data:AddProperty( 'EntityLink', "Heli_Route" )
end,

--------------------------------------------------------------------------------
-- イベントリスナー
--------------------------------------------------------------------------------
OnDemoEnd = function( data, body, sender, id, arg1, arg2, arg3, arg4 )
	Fox.Log( "DemoEnd...Route of the Heli will be changed and disp Telop!" )
	body.messageBox:SendMessageToSubscribers( "PlayEnd" )

	local route =  data.Heli_Route
	
	TppSupportHelicopterService.SetUpHelicopterFreePlay(route)
	
end,

}
