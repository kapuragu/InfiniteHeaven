--[[
	@id			ProDemoSequence
	@category	demo
	GameScript用

	・プロシージャルデモの中断/再開の単位を表します。

	・各シーケンスのDemoData情報を持ちます。

	・最後のDemoDataの再生が終わったら
		・自身の「再生済みフラグ」を立て、以降はこのシーケンスを再生できないようにします。
		・「シーケンス終了メッセージ」を投げます。メッセージは「全体管理GameScript」が受け取り、次のシーケンスに遷移させます。

	■variables
		FIRST_DEMO1			:	最初のDemoData
		FIRST_DEMO2
		FIRST_DEMO3
			:
		FIRST_DEMO8

		LAST_GAMESCRIPT		:	最後のGameScript（DemoStepPlayなどのDemoData制御用GameScript）

		SYNC_GAMESCRIPT1	:	同期用GameScript
		SYNC_GAMESCRIPT2
		SYNC_GAMESCRIPT3
		SYNC_GAMESCRIPT4

		DEMO1				:	DemoData
		DEMO2
		DEMO3
			:
		DEMO16
--]]
ProDemoSequence = {

--------------------------------------------------------------------------------
-- 初期設定
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- イベントリスナーの登録
events = {
	DEMO_DAEMON = { SetDefaultValue = "OnSetDefaultValue" },

	LAST_GAMESCRIPT = { PlayEnd = "OnPlayEnd" },
},

--------------------------------------------------------------------------------
-- 初期化
Init = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoSequence.Init()" )

	local storage = body.storage

	---------------------------------------------------
	-- 定数

	-- 最初のDemoDataの最大数
	storage:AddProperty( "int32", "MAX_FIRST_DEMO_COUNT" )
	storage.MAX_FIRST_DEMO_COUNT = 8

	-- 同期用GameScriptの最大数
	storage:AddProperty( "int32", "MAX_SYNC_GAMESCRIPT_COUNT" )
	storage.MAX_SYNC_GAMESCRIPT_COUNT = 4

	-- DemoDataの最大数
	storage:AddProperty( "int32", "MAX_DEMO_COUNT" )
	storage.MAX_DEMO_COUNT = 16

	---------------------------------------------------
	-- 変数

	-- 再生済みフラグ
	storage:AddProperty( "bool", "isPlayEnd" )

	-- 初期値を設定
	ProDemoSequence.SetDefaultValue( data, body )

end,

--------------------------------------------------------------------------------
-- メッセージボックスリストの設定
SetMessageBoxes = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoSequence.SetMessageBoxes()" )

	-- 外部からの命令用にDemoDaemonのメッセージボックスを追加
	local fromMessageBox = ProDemoSequence.GetDemoDaemonMessageBox()
	body:AddMessageBox( "DEMO_DAEMON", fromMessageBox )

end,

--------------------------------------------------------------------------------
-- イベントリスナー
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 初期値を設定
OnSetDefaultValue = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemoSequence.OnSetDefaultValue()" )

	ProDemoSequence.SetDefaultValue( data, body )

end,

--------------------------------------------------------------------------------
-- 最後のGameScriptから再生終了を受け取った時の処理
OnPlayEnd = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemoSequence.OnPlayEnd()" )

	-- このシーケンスを再生済み扱いにする
	local storage = body.storage
	storage.isPlayEnd = true

	-- 再生終了した事を発信
	body.messageBox:SendMessageToSubscribers( "PlayEnd" )

end,

--------------------------------------------------------------------------------
-- private
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 初期値を設定
SetDefaultValue = function( data, body )

	--Fox.Log( "[" .. data.name .. "] ProDemoSequence.SetDefaultValue()" )

	local storage = body.storage
	storage.isPlayEnd = false		-- 再生済みフラグ

end,

--------------------------------------------------------------------------------
-- DemoDaemonのメッセージボックスを取得
GetDemoDaemonMessageBox = function()

	local fromMessageBox = DemoDaemon.GetInstance().messageBox
	if fromMessageBox == NULL then
		Fox.Warning( "[" .. data.name .. "] ProDemoSequence.SetMessageBoxes() : DemoDaemon messageBox is NULL." )
		return NULL
	end
	if not fromMessageBox:IsKindOf( MessageBox ) then
		Fox.Warning( "[" .. data.name .. "] ProDemoSequence.SetMessageBoxes() : DemoDeamon messageBox is not MessageBox. [" .. tostring(fromMessageBox) .. "]" )
		return NULL
	end

	return fromMessageBox

end,

}

