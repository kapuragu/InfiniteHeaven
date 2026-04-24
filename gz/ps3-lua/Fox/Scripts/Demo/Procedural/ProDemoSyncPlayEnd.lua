--[[FDOC
	@id			ProDemoSyncPlayEnd
	@category	Demo
	GameScript用

	指定のプロシージャルデモ全てが終了するまで同期待ちを行い、その後指定のプロシージャルデモを再生します。

	例）
		Pデモ1							Pデモ4
		Pデモ2	→	全て終了したら	→	Pデモ5
		Pデモ3

	■variables
		PREV_PRO_DEMO_GAMESCRIPT1	:	終了待ちプロシージャルデモ（のGameScript）
		PREV_PRO_DEMO_GAMESCRIPT2
		PREV_PRO_DEMO_GAMESCRIPT3
		PREV_PRO_DEMO_GAMESCRIPT4

		NEXT_PRO_DEMO_GAMESCRIPT1	:	再生待ちプロシージャルデモ（のGameScript）
		NEXT_PRO_DEMO_GAMESCRIPT2
		NEXT_PRO_DEMO_GAMESCRIPT3
		NEXT_PRO_DEMO_GAMESCRIPT4
]]

ProDemoSyncPlayEnd = {

--------------------------------------------------------------------------------
-- 初期設定
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- イベントリスナーの登録
events = {
	DEMO_DAEMON = { SetDefaultValue = "OnSetDefaultValue" },

	PREV_PRO_DEMO_GAMESCRIPT1 = { PlayEnd = "OnProDemoPlayEnd" },
	PREV_PRO_DEMO_GAMESCRIPT2 = { PlayEnd = "OnProDemoPlayEnd" },
	PREV_PRO_DEMO_GAMESCRIPT3 = { PlayEnd = "OnProDemoPlayEnd" },
	PREV_PRO_DEMO_GAMESCRIPT4 = { PlayEnd = "OnProDemoPlayEnd" },
},

--------------------------------------------------------------------------------
-- 初期化
Init = function( data, body )
	Fox.Log( "[" .. data.name .. "] ProDemoSyncPlayEnd.Init()" )

	local storage = body.storage

	---------------------------------------------------
	-- 定数

	-- 終了待ちプロシージャルデモ最大数
	storage:AddProperty( "int32", "MAX_PREV_PRO_DEMO_GAMESCRIPT_COUNT" )
	storage.MAX_PREV_PRO_DEMO_GAMESCRIPT_COUNT = 4

	-- 再生待ちプロシージャルデモ最大数
	storage:AddProperty( "int32", "MAX_NEXT_PRO_DEMO_GAMESCRIPT_COUNT" )
	storage.MAX_NEXT_PRO_DEMO_GAMESCRIPT_COUNT = 4

	---------------------------------------------------
	-- 変数

	-- 終了済みフラグ
	storage:AddProperty( "bool", "prevProDemoEndFlags", storage.MAX_PREV_PRO_DEMO_GAMESCRIPT_COUNT )

	-- 再生待ちプロシージャルデモ再生済みフラグ
	storage:AddProperty( "bool", "nextProDemoPlayFlag" )

	-- 初期値を設定
	ProDemoSyncPlayEnd.SetDefaultValue( data, body )

	ProDemoSyncPlayEnd.DebugDump( data, body )
end,

--------------------------------------------------------------------------------
-- メッセージボックスリストの設定
SetMessageBoxes = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoSyncPlayEnd.SetMessageBoxes()" )

	-- 外部からの命令用にDemoDaemonのメッセージボックスを追加
	local fromMessageBox = ProDemoSyncPlayEnd.GetDemoDaemonMessageBox()
	body:AddMessageBox( "DEMO_DAEMON", fromMessageBox )

end,


--------------------------------------------------------------------------------
-- イベントリスナー
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 初期値を設定
OnSetDefaultValue = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemoSyncPlayEnd.OnSetDefaultValue()" )

	ProDemoSyncPlayEnd.SetDefaultValue( data, body )

end,

--------------------------------------------------------------------------------
-- プロシージャルデモが最後まで再生完了した時の処理
OnProDemoPlayEnd = function( data, body, sender, id, arg1, arg2, arg3, arg4 )

	Fox.Log( "[" .. data.name .. "] ProDemoSyncPlayEnd.OnProDemoPlayEnd()" )

	local storage = body.storage

	-- そのプロシージャルデモの終了済みフラグを立てる
	ProDemoSyncPlayEnd.SetProDemoEndFlag( data, body, sender.owner, true )

	-- 次へ進んでも良いかチェック
	if ProDemoSyncPlayEnd.CheckNext( data, body ) == false then
		return
	end

	-- 次へ進む
	ProDemoSyncPlayEnd.Next( data, body )
end,

--------------------------------------------------------------------------------
-- private
--------------------------------------------------------------------------------
SetDefaultValue = function( data, body )

	local storage = body.storage

	-- 終了済みフラグ
	for i = 1, storage.MAX_PREV_PRO_DEMO_GAMESCRIPT_COUNT do
		storage.prevProDemoEndFlags[i] = false
	end

	-- 再生待ちプロシージャルデモ再生済みフラグ
	storage.nextProDemoPlayFlag = false

end,

--------------------------------------------------------------------------------
-- 次へ進む
Next = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoSyncPlayEnd.Next()" )

	local storage = body.storage

	-- 再生待ちプロシージャルデモ
	for i = 1, storage.MAX_NEXT_PRO_DEMO_GAMESCRIPT_COUNT do

		-- Dataを取得
		local keyName = "NEXT_PRO_DEMO_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- プロシージャルデモを再生
		ProDemoSyncPlayEnd.PlayProDemo( data, body, gameScriptData )
	end

	storage.nextProDemoPlayFlag = true

end,

--------------------------------------------------------------------------------
-- プロシージャルデモを再生する
PlayProDemo = function( data, body, proDemoGameScriptData )

	Fox.Log( "[" .. data.name .. "] ProDemoSyncPlayEnd.PlayProDemo()" )

	-- メッセージを投げる
	local messageName = "Play"
	ProDemoSyncPlayEnd.SendMessageToGameScript( data, body, proDemoGameScriptData, messageName )

end,

--------------------------------------------------------------------------------
-- GameScriptにメッセージを投げる
SendMessageToGameScript = function( data, body, gameScriptData, messageName )

	Fox.Log( "[" .. data.name .. "] ProDemoSyncPlayEnd.SendMessageToGameScript()" )

	-- Bodyを取得
	local gameScriptBody = ProDemoSyncPlayEnd.GetGameScriptBody( body, gameScriptData )
	if gameScriptBody == NULL then
		Fox.Warning( "[" .. data.name .. "] gameScriptData[" .. tostring(gameScriptData) .. "] is error." )
		return
	end

	-- 送信
	local fromMessageBox = body.messageBoxes.DEMO_DAEMON
	local toMessageBox = gameScriptBody.messageBox
	fromMessageBox:SendMessageTo( toMessageBox, messageName )

end,

--------------------------------------------------------------------------------
-- GameScriptのDataからBodyを取得する
-- @return GameScriptBody:存在する NULL:存在しない
GetGameScriptBody = function( body, gameScriptData )

	if gameScriptData == NULL then
		Fox.Warning( "[" .. data.name .. "] ProDemoSyncPlayEnd.GetGameScriptBody() : data is NULL." )
		return NULL
	end

	local gameScriptBody = gameScriptData:GetDataBodyWithReferrer( body )
	if gameScriptBody == NULL then
		Fox.Warning( "[" .. data.name .. "] ProDemoSyncPlayEnd.GetGameScriptBody() : Body not found." )
		return NULL
	end
	if not gameScriptBody:IsKindOf( GameScriptBody ) then
		Fox.Warning( "[" .. data.name .. "] ProDemoSyncPlayEnd.GetGameScriptBody() : body is not GameScriptBody. [" .. tostring(gameScriptBody) .. "]" )
		return NULL
	end

	return gameScriptBody
end,

--------------------------------------------------------------------------------
-- 指定のプロシージャルデモの終了済みフラグを設定する
SetProDemoEndFlag = function( data, body, targetGameScriptBody, boolFlag )

	Fox.Log( "[" .. data.name .. "] ProDemoSyncPlayEnd.SetProDemoEndFlag()" )

	local storage = body.storage

	-- 終了待ちプロシージャルデモGameScript
	for i = 1, storage.MAX_PREV_PRO_DEMO_GAMESCRIPT_COUNT do

		-- Dataを取得
		local keyName = "PREV_PRO_DEMO_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- 指定と一致するかチェック
		if ProDemoSyncPlayEnd.IsMatchGameScript( body, gameScriptData, targetGameScriptBody ) then
			-- フラグ設定
			storage.prevProDemoEndFlags[i] = boolFlag
			break
		end
	end

	ProDemoSyncPlayEnd.DebugDump( data, body )

end,

--------------------------------------------------------------------------------
-- 2つのGameScriptが一致するかチェック
-- @return true:一致	false:不一致
IsMatchGameScript = function( body, gameScriptDataA, gameScriptBodyB )

	-- Bodyを取得
	local gameScriptBodyA = ProDemoSyncPlayEnd.GetGameScriptBody( body, gameScriptDataA )
	if gameScriptBodyA == NULL then
		Fox.Warning( "[" .. data.name .. "] gameScriptData[" .. tostring(gameScriptDataA) .. "] is error." )
		return false
	end

	-- Bodyを比較
	if gameScriptBodyA ~= gameScriptBodyB then
		return false
	end

	return true
end,


--------------------------------------------------------------------------------
-- 次のプロシージャルデモへ進めるかチェック
--	@return true:可	false:不可
CheckNext = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoSyncPlayEnd.CheckNext()" )

	local storage = body.storage

	-- 再生待ちプロシージャルデモ再生済みフラグ
	if storage.nextProDemoPlayFlag then
		return false
	end

	-- プロシージャルデモ終了済みフラグ
	for i = 1, storage.MAX_PREV_PRO_DEMO_GAMESCRIPT_COUNT do

		local keyName = "PREV_PRO_DEMO_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break
		end

		local prevDemoEndFlag = storage.prevProDemoEndFlags[i]
		if prevDemoEndFlag == false then
			return false
		end
	end

	return true

end,

--------------------------------------------------------------------------------
-- DemoDaemonのメッセージボックスを取得する
GetDemoDaemonMessageBox = function()

	local fromMessageBox = DemoDaemon.GetInstance().messageBox
	if fromMessageBox == NULL then
		Fox.Warning( "[" .. data.name .. "] ProDemo.SetMessageBoxes() : DemoDaemon messageBox is NULL." )
		return NULL
	end
	if not fromMessageBox:IsKindOf( MessageBox ) then
		Fox.Warning( "[" .. data.name .. "] ProDemo.SetMessageBoxes() : DemoDeamon messageBox is not MessageBox. [" .. tostring(fromMessageBox) .. "]" )
		return NULL
	end

	return fromMessageBox

end,

--------------------------------------------------------------------------------
-- デバッグ
--------------------------------------------------------------------------------

-- デバッグ用：情報をログに出力
DebugDump = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoSyncPlayEnd.DebugDump()" )

	local storage = body.storage

	-- 終了待ちプロシージャルデモ
	for i = 1, storage.MAX_PREV_PRO_DEMO_GAMESCRIPT_COUNT do

		-- Dataを取得
		local keyName = "PREV_PRO_DEMO_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- Bodyを取得
		local gameScriptBody = ProDemoSyncPlayEnd.GetGameScriptBody( body, gameScriptData )

		-- 終了済みフラグを取得
		local prevDemoEndFlag = storage.prevProDemoEndFlags[i]

		-- 出力
		Fox.Log( "[" .. data.name .. "]  " .. keyName .. " : data[" .. tostring(gameScriptData) .. "] body[" .. tostring(gameScriptBody) .. "] prevDemoEndFlag[" .. tostring(prevDemoEndFlag) .. "]" )
	end

	-- 再生待ちプロシージャルデモ
	for i = 1, storage.MAX_NEXT_PRO_DEMO_GAMESCRIPT_COUNT do

		-- Dataを取得
		local keyName = "NEXT_PRO_DEMO_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- Bodyを取得
		local gameScriptBody = ProDemoSyncPlayEnd.GetGameScriptBody( body, gameScriptData )

		-- 出力
		Fox.Log( "[" .. data.name .. "]  " .. keyName .. " : data[" .. tostring(gameScriptData) .. "] body[" .. tostring(gameScriptBody) .. "]" )
	end

	-- 再生待ちプロシージャルデモの再生済みフラグ
	Fox.Log( "[" .. data.name .. "]  nextProDemoPlayFlag[" .. tostring(storage.nextProDemoPlayFlag) .. "]" )

end,

} -- ProDemoSyncPlayEnd

