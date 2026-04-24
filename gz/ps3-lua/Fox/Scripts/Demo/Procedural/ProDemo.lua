--[[
	@id			ProDemo
	@category	demo
	GameScript用

	１つのプロシージャルデモ全体を管理します。
	ユーザーはプロパティに以下を登録します。

	・参加キャラクタ（のLocator）						×0～n
	・シーケンスGameScript								×1～n
	・中断/再開条件GameScript							×0～n
	・終了リアクションGameScript						×1
	・終了条件GameScript ＋ 終了リアクションGameScript	×0～n

	以下の状態を持ちます。
		"Stop"	:	終了中。デモが再生されていない状態。（開始前はこの状態です。）
		"Play"	:	再生中。デモが再生されている状態。デモの中断を受け付けます。
		"Break"	:	中断中。Stopと同じくデモが再生されていない状態。ただしデモの再開を受け付けます。

	■variables
		CHARACTER1						:	参加キャラクタ（のLocator）
		CHARACTER2
		CHARACTER3
			:
		CHARACTER16

		SEQUENCE_GAMESCRIPT1			:	シーケンスのGameScript
		SEQUENCE_GAMESCRIPT2
		SEQUENCE_GAMESCRIPT3
				:
		SEQUENCE_GAMESCRIPT16

		BREAK_CHECKER_GAMESCRIPT1		:	中断/再開条件のGameScript
		BREAK_CHECKER_GAMESCRIPT2
		BREAK_CHECKER_GAMESCRIPT3
		BREAK_CHECKER_GAMESCRIPT4

		STOP_CHECKER_GAMESCRIPT1		:	終了条件のGameScript
		STOP_CHECKER_GAMESCRIPT2
		STOP_CHECKER_GAMESCRIPT3
				:
		STOP_CHECKER_GAMESCRIPT8

--]]
ProDemo = {

--------------------------------------------------------------------------------
-- 初期設定
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- イベントリスナーの登録
events = {
	DEMO_DAEMON = { 
		SetDefaultValue = "OnSetDefaultValue", 
		Play = "OnPlay", 
		StopToPlay = "OnStopToPlay", 
		BreakToPlay = "OnBreakToPlay", 
		Stop = "OnStop", 
		FinalStop = "OnFinalStop", 
		Break = "OnBreak", 
		FinalBreak = "OnFinalBreak", 
		DebugDumpAll = "OnDebugDumpAll" },

	SEQUENCE_GAMESCRIPT1  = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT2  = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT3  = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT4  = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT5  = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT6  = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT7  = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT8  = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT9  = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT10 = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT11 = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT12 = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT13 = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT14 = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT15 = { PlayEnd = "OnSequencePlayEnd" },
	SEQUENCE_GAMESCRIPT16 = { PlayEnd = "OnSequencePlayEnd" },

	BREAK_CHECKER_GAMESCRIPT1 = { Break = "OnBreak", Continue = "OnContinue" },
	BREAK_CHECKER_GAMESCRIPT2 = { Break = "OnBreak", Continue = "OnContinue" },
	BREAK_CHECKER_GAMESCRIPT3 = { Break = "OnBreak", Continue = "OnContinue" },
	BREAK_CHECKER_GAMESCRIPT4 = { Break = "OnBreak", Continue = "OnContinue" },

	STOP_CHECKER_GAMESCRIPT1  = { Stop = "OnStop" },
	STOP_CHECKER_GAMESCRIPT2  = { Stop = "OnStop" },
	STOP_CHECKER_GAMESCRIPT3  = { Stop = "OnStop" },
	STOP_CHECKER_GAMESCRIPT4  = { Stop = "OnStop" },
	STOP_CHECKER_GAMESCRIPT5  = { Stop = "OnStop" },
	STOP_CHECKER_GAMESCRIPT6  = { Stop = "OnStop" },
	STOP_CHECKER_GAMESCRIPT7  = { Stop = "OnStop" },
	STOP_CHECKER_GAMESCRIPT8  = { Stop = "OnStop" },
},

--------------------------------------------------------------------------------
-- 初期化
Init = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemo.Init()" )

	local storage = body.storage

	---------------------------------------------------
	-- 定数

	-- 参加キャラクタの最大数
	storage:AddProperty( "int32", "MAX_CHARACTER_COUNT" )
	storage.MAX_CHARACTER_COUNT = 16

	-- シーケンスの最大数
	storage:AddProperty( "int32", "MAX_SEQUENCE_COUNT" )
	storage.MAX_SEQUENCE_COUNT = 16

	-- 中断/再開条件の最大数
	storage:AddProperty( "int32", "MAX_BREAK_CHECKER_COUNT" )
	storage.MAX_BREAK_CHECKER_COUNT = 4

	-- 終了条件の最大数
	storage:AddProperty( "int32", "MAX_STOP_CHECKER_COUNT" )
	storage.MAX_STOP_CHECKER_COUNT = 8

	---------------------------------------------------
	-- 変数

	-- プロシージャルデモ全体の状態
	storage:AddProperty( "String", "status" )

	-- 初期値を設定
	ProDemo.SetDefaultValue( data, body )

end,

--------------------------------------------------------------------------------
-- メッセージボックスリストの設定
SetMessageBoxes = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemo.SetMessageBoxes()" )

	-- 外部からの命令用にDemoDaemonのメッセージボックスを追加
	local fromMessageBox = ProDemo.GetDemoDaemonMessageBox()
	body:AddMessageBox( "DEMO_DAEMON", fromMessageBox )

end,

--------------------------------------------------------------------------------
-- イベントリスナー
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 初期値を設定
OnSetDefaultValue = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemo.OnSetDefaultValue()" )

	ProDemo.SetDefaultValue( data, body )

end,

--------------------------------------------------------------------------------
-- 再生命令を受けた時の処理
OnPlay = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemo.OnPlay()" )
	ProDemo.DebugDump( data, body )

	local storage = body.storage

	-- 再生を受け付けるのは、プロシージャルデモ全体が「停止中」か「中断中」の時のみ
	if storage.status ~= "Stop" and storage.status ~= "Break" then
		Fox.Warning( "[" .. data.name .. "] Now playing. data[" .. data.name .. "] status[" .. storage.status .. "]" )
		return
	end

	-- プロシージャルデモ再生
	ProDemo.Play( data, body )

end,

--------------------------------------------------------------------------------
-- 終了命令を受けた時の処理
OnStop = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemo.OnStop()" )

	local storage = body.storage

	-- 停止を受け付けるのは、プロシージャルデモ全体が「再生中」か「中断中」の時のみ
	if storage.status ~= "Play" and storage.status ~= "Break" then
		Fox.Warning( "[" .. data.name .. "] It stops now. data[" .. data.name .. "] status[" .. storage.status .. "]" )
		return
	end

	-- 条件GameScriptを無効にする
	ProDemo.SetCheckerEnable( data, body, false )

	-- 参加キャラクタのデモ乗っ取りの解除を要求
	ProDemo.RequestCharacterDemoStop( data, body )

	-- 次のフレームで完全終了
	local fromMessageBox = body.messageBoxes.DEMO_DAEMON
	local toMessageBox = body.messageBox
	fromMessageBox:SendMessageTo( toMessageBox, "FinalStop" )

end,

--------------------------------------------------------------------------------
-- 終了命令を受けた時の処理２
OnFinalStop = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemo.OnFinalStop()" )

	local storage = body.storage

	-- プロシージャルデモに含まれる全てのDemoDataの再生を終了する
	ProDemo.StopAllDemoData( data, body )

	-- プロシージャルデモ全体を「停止中」に変更
	storage.status = "Stop"

	-- プロシージャルデモ全体の再生が終了したことをメッセージで投げる
	body.messageBox:SendMessageToSubscribers( "Stop" )

end,

--------------------------------------------------------------------------------
-- 中断命令を受けた時の処理
OnBreak = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemo.OnBreak()" )

	local storage = body.storage

	-- 中断を受け付けるのは、プロシージャルデモ全体が「再生中」の時のみ
	if storage.status ~= "Play" then
		Fox.Warning( "[" .. data.name .. "] Break failed. not play now. data[" .. data.name .. "] status[" .. storage.status .. "]" )
		return
	end

	-- 参加キャラクタのデモ乗っ取りの解除を要求
	ProDemo.RequestCharacterDemoStop( data, body )

	-- 次のフレームで完全中断
	local fromMessageBox = body.messageBoxes.DEMO_DAEMON
	local toMessageBox = body.messageBox
	fromMessageBox:SendMessageTo( toMessageBox, "FinalBreak" )

end,

--------------------------------------------------------------------------------
-- 中断命令を受けた時の処理２
OnFinalBreak = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemo.OnFinalBreak()" )

	local storage = body.storage

	-- プロシージャルデモに含まれる全てのDemoDataの再生を終了する
	ProDemo.StopAllDemoData( data, body )

	-- プロシージャルデモ全体を「中断中」に変更
	storage.status = "Break"

	-- プロシージャルデモが中断したことをメッセージで投げる
	body.messageBox:SendMessageToSubscribers( "Break" )

end,

--------------------------------------------------------------------------------
-- 再開命令を受けた時の処理
OnContinue = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemo.OnContinue()" )

	local storage = body.storage

	-- 再開を受け付けるのは、プロシージャルデモ全体が「中断中」の時のみ
	if storage.status ~= "Break" then
		Fox.Log( "Continue Failed. not break now. status[" .. storage.status .. "]" )
		return
	end
	Fox.Log( "Continue Success. status[" .. storage.status .. "]" )

	-- プロシージャルデモ再生
	ProDemo.Play( data, body )

end,

--------------------------------------------------------------------------------
-- シーケンスの再生終了連絡を受けた時の処理
OnSequencePlayEnd = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemo.OnSequencePlayEnd()" )

	local storage = body.storage

	-- 次に再生すべきシーケンスを取得する
	local nextSequenceGameScriptData = ProDemo.GetNextSequence( data, body )

	-- 次が無いなら
	if nextSequenceGameScriptData == NULL then

		-- 条件GameScriptを無効にする
		ProDemo.SetCheckerEnable( data, body, false )

		-- プロシージャルデモ終了を要求する
	--	ProDemo.RequestStop( data, body )

		-- 次のフレームで完全終了
	--	local fromMessageBox = body.messageBoxes.DEMO_DAEMON
	--	local toMessageBox = body.messageBox
	--	fromMessageBox:SendMessageTo( toMessageBox, "FinalStop" )

		-- プロシージャルデモ全体を「停止中」に変更
		storage.status = "Stop"

		-- プロシージャルデモ全体の再生が終了したことをメッセージで投げる
		body.messageBox:SendMessageToSubscribers( "PlayEnd" )

		return
	end

	-- 次のシーケンスを再生
	ProDemo.PlaySequence( data, body, nextSequenceGameScriptData )

end,

--------------------------------------------------------------------------------
-- 停止から再生へ
OnStopToPlay = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemo.OnStopToPlay()" )

	local storage = body.storage

	-- 先頭のシーケンスを取得
	local nextSequenceGameScriptData = data.variables.SEQUENCE_GAMESCRIPT1
	if ProDemo.GetGameScriptBody( data, body, nextSequenceGameScriptData ) == NULL then
		Fox.Warning( "[" .. data.name .. "] variables.SEQUENCE_GAMESCRIPT1 is error." )
		return
	end

	-- シーケンスを再生
	ProDemo.PlaySequence( data, body, nextSequenceGameScriptData )

	-- プロシージャルデモ全体を「再生中」に変更
	storage.status = "Play"

end,

--------------------------------------------------------------------------------
-- 中断から再生へ
OnBreakToPlay = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemo.OnBreakToPlay()" )

	local storage = body.storage

	-- 次に再生すべきシーケンスを取得
	local nextSequenceGameScriptData = ProDemo.GetNextSequence( data, body )
	if nextSequenceGameScriptData == NULL then
		Fox.Warning( "[" .. data.name .. "] not next sequence." )
		return
	end

	-- 次のシーケンスを再生
	ProDemo.PlaySequence( data, body, nextSequenceGameScriptData )

	-- プロシージャルデモ全体を「再生中」に変更
	storage.status = "Play"

end,

--------------------------------------------------------------------------------
-- private
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 初期値を設定
SetDefaultValue = function( data, body )

	local storage = body.storage

	-- プロシージャルデモ全体の状態
	storage.status = "Stop"

	-- 条件GameScriptを無効にする
	ProDemo.SetCheckerEnable( data, body, false )

end,

--------------------------------------------------------------------------------
-- プロシージャルデモを再生する
Play = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemo.Play()" )

	local storage = body.storage

	-- DemoData制御用GameScriptの値を初期値に戻すよう要求する
	ProDemo.RequestSetDefaultValueSyncGameScript( data, body )

	-- 停止中の場合
	if storage.status == "Stop" then
		-- 条件GameScriptを有効にする
		ProDemo.SetCheckerEnable( data, body, true )

		-- シーケンスGameScriptの値を初期値に戻すよう要求する
		ProDemo.RequestSetDefaultValueSequence( data, body )
		-- 条件GameScriptの値を初期値に戻すよう要求する
		ProDemo.RequestSetDefaultValueChecker( data, body )

		-- 次のフレームで先頭のシーケンスを再生
		local fromMessageBox = body.messageBoxes.DEMO_DAEMON
		local toMessageBox = body.messageBox
		fromMessageBox:SendMessageTo( toMessageBox, "StopToPlay" )

		return
	end

	-- 中断中の場合

	-- 次のフレームで次に再生すべきシーケンスを再生
	local fromMessageBox = body.messageBoxes.DEMO_DAEMON
	local toMessageBox = body.messageBox
	fromMessageBox:SendMessageTo( toMessageBox, "BreakToPlay" )

end,

--------------------------------------------------------------------------------
-- DemoDataを再生する
PlayDemoData = function( data, body, demoData )

	Fox.Log( "[" .. data.name .. "] ProDemo.PlayDemoData()" )

	-- Bodyを取得
	local demoBody = ProDemo.GetDemoBody( data, body, demoData )
	if demoBody == NULL then
		Fox.Warning( "[" .. data.name .. "] demoData[" .. tostring(demoData) .. "] is error." )
		return
	end

	Fox.Log( " start demoData[" .. demoData.name .. "]" )
	demoBody:Start()

end,

--------------------------------------------------------------------------------
-- シーケンスを再生する
PlaySequence = function( data, body, sequenceGameScriptData )

	Fox.Log( "[" .. data.name .. "] ProDemo.PlaySequence()" )

	local sequenceGameScriptBody = ProDemo.GetGameScriptBody( data, body, sequenceGameScriptData )
	if sequenceGameScriptBody == NULL then
		Fox.Warning( "[" .. data.name .. "] body not found. [" .. tostring(sequenceGameScriptData) .. "]" )
		return false
	end

	-- 最初のDemoData
	for i = 1, sequenceGameScriptBody.storage.MAX_FIRST_DEMO_COUNT do

		-- Dataを取得
		local keyName = "FIRST_DEMO" .. i
		local demoData = sequenceGameScriptData.variables[ keyName ]
		if demoData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- 再生
		ProDemo.PlayDemoData( data, body, demoData )

	end

end,

--------------------------------------------------------------------------------
-- 次に再生すべきシーケンスを取得する
-- @return	GameScriptData:再生すべきシーケンス	NULL:再生すべきシーケンスは無い
GetNextSequence = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemo.GetNextSequence()" )

	local storage = body.storage

	-- シーケンスGameScript
	for i = 1, storage.MAX_SEQUENCE_COUNT do

		-- Dataを取得
		local keyName = "SEQUENCE_GAMESCRIPT" .. i
		local sequenceGameScriptData = data.variables[ keyName ]
		if sequenceGameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- 再生すべきかチェック
		if ProDemo.IsPlayableSequence( data, body, sequenceGameScriptData ) then
			return sequenceGameScriptData
		end

	end

	-- 次に再生すべきシーケンスは無い
	return NULL
end,

--------------------------------------------------------------------------------
-- 再生すべきシーケンスかチェック
--	@return true:再生すべき false:再生すべきではない
IsPlayableSequence = function( data, body, sequenceGameScriptData )

	local sequenceGameScriptBody = ProDemo.GetGameScriptBody( data, body, sequenceGameScriptData )
	if sequenceGameScriptBody == NULL then
		Fox.Warning( "[" .. data.name .. "] body not found. [" .. tostring(sequenceGameScriptData) .. "]" )
		return false
	end

	-- 再生済みのシーケンスはスキップする
	local isPlayEnd = sequenceGameScriptBody.storage.isPlayEnd
	if isPlayEnd then
		return false
	end

	return true

end,

--------------------------------------------------------------------------------
-- 参加キャラクタにデモ乗っ取り状態の解除を要求し、AI行動に戻す
RequestCharacterDemoStop = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemo.RequestCharacterDemoStop()" )

	local storage = body.storage

	-- 参加キャラクタ
	for i = 1, storage.MAX_CHARACTER_COUNT do

		-- Dataを取得
		local keyName = "CHARACTER" .. i
		local characterLocatorData = data.variables[ keyName ]
		if characterLocatorData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- メッセージを投げる
		local message = ChStopProceduralDemoRequest()
		ProDemo.SendMessageToCharacter( data, body, characterLocatorData, message )

	end

end,

--------------------------------------------------------------------------------
-- キャラクタのLocatorDataからLocatorBodyを取得する
GetCharacterLocatorBodyByData = function( data, body, characterLocatorData, message )

	local characterLocatorBody = characterLocatorData:GetDataBodyWithReferrer( body )
	if characterLocatorBody == NULL or not characterLocatorBody:IsKindOf( ChCharacterLocator ) then
		Fox.Warning( "[" .. data.name .. "] ChCharacterLocator not found. data[" .. tostring(characterLocatorData) .. "]" )
		return NULL
	end

	return characterLocatorBody
end,

--------------------------------------------------------------------------------
-- キャラクタにメッセージを投げる
SendMessageToCharacter = function( data, body, characterLocatorData, message )

	if message == NULL then
		Fox.Warning( "[" .. data.name .. "] message is NULL." )
		return
	end

	local characterLocatorBody = ProDemo.GetCharacterLocatorBodyByData( data, body, characterLocatorData )
	if characterLocatorBody == NULL then
		return
	end

	local charaObj = characterLocatorBody:GetCharacterObject()
	if charaObj == NULL then
		Fox.Warning( "[" .. data.name .. "] ChCharacterObject not found. data[" .. tostring(characterLocatorData) .. "]" )
		return
	end

	local chara = charaObj:GetCharacter()
	if chara == NULL then
		Fox.Warning( "[" .. data.name .. "] ChCharacter not found. data[" .. tostring(characterLocatorData) .. "]" )
		return
	end

	-- プロシージャルデモ乗っ取り解除をリクエスト
	chara:SendMessage( message )

end,

--------------------------------------------------------------------------------
-- GameScriptのDataからBodyを取得する
-- 	@return GameScriptBody:存在する NULL:存在しない
GetGameScriptBody = function( data, body, gameScriptData )

	if gameScriptData == NULL then
		Fox.Warning( "[" .. data.name .. "] ProDemo.GetGameScriptBody() : data is NULL." )
		return NULL
	end

	local gameScriptBody = gameScriptData:GetDataBodyWithReferrer( body )
	if gameScriptBody == NULL then
		Fox.Warning( "[" .. data.name .. "] ProDemo.GetGameScriptBody() : Body not found." )
		return NULL
	end
	if not gameScriptBody:IsKindOf( GameScriptBody ) then
		Fox.Warning( "[" .. data.name .. "] ProDemo.GetGameScriptBody() : body is not GameScriptBody. [" .. tostring(gameScriptBody) .. "]" )
		return NULL
	end

	return gameScriptBody
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
-- DemoData同期用GameScriptの値を初期値に戻す
RequestSetDefaultValueSyncGameScriptBySequence = function( data, body, gameScriptData )

	-- Bodyを取得
	local gameScriptBody = ProDemo.GetGameScriptBody( data, body, gameScriptData )
	if gameScriptBody == NULL then
		Fox.Warning( "[" .. data.name .. "] gameScriptData[" .. tostring(gameScriptData) .. "] is error." )
		return
	end

	-- DemoData同期用GameScript
	for i = 1, gameScriptBody.storage.MAX_SYNC_GAMESCRIPT_COUNT do

		-- Dataを取得
		local keyName = "SYNC_GAMESCRIPT" .. i
		local syncGameScriptData = gameScriptData.variables[ keyName ]
		if syncGameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- メッセージを投げる
		ProDemo.SendMessageToGameScript( data, body, syncGameScriptData, "SetDefaultValue" )
	end

end,

--------------------------------------------------------------------------------
-- DemoData同期用GameScriptの値を初期値に戻す
RequestSetDefaultValueSyncGameScript = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemo.RequestSetDefaultValueSyncGameScript()" )

	local storage = body.storage

	-- シーケンスGameScript
	for i = 1, storage.MAX_SEQUENCE_COUNT do

		-- Dataを取得
		local keyName = "SEQUENCE_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		ProDemo.RequestSetDefaultValueSyncGameScriptBySequence( data, body, gameScriptData )
	end

end,

--------------------------------------------------------------------------------
-- シーケンスGameScriptの値を初期値に戻す
RequestSetDefaultValueSequence = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemo.RequestSetDefaultValueSequence()" )

	local storage = body.storage

	-- シーケンスGameScript
	for i = 1, storage.MAX_SEQUENCE_COUNT do

		-- Dataを取得
		local keyName = "SEQUENCE_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- メッセージを投げる
		ProDemo.SendMessageToGameScript( data, body, gameScriptData, "SetDefaultValue" )

	end

end,

--------------------------------------------------------------------------------
-- 条件GameScriptの値を初期値に戻す
RequestSetDefaultValueChecker = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemo.RequestSetDefaultValueChecker()" )

	local storage = body.storage

	-- 中断/再開条件GameScript
	for i = 1, storage.MAX_BREAK_CHECKER_COUNT do

		-- Dataを取得
		local keyName = "BREAK_CHECKER_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- メッセージを投げる
		ProDemo.SendMessageToGameScript( data, body, gameScriptData, "SetDefaultValue" )

	end

	-- 終了条件GameScript
	for i = 1, storage.MAX_STOP_CHECKER_COUNT do

		-- Dataを取得
		local keyName = "STOP_CHECKER_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- メッセージを投げる
		ProDemo.SendMessageToGameScript( data, body, gameScriptData, "SetDefaultValue" )

	end

end,

--------------------------------------------------------------------------------
-- GameScriptにメッセージを投げる
SendMessageToGameScript = function( data, body, gameScriptData, messageName )

	--Fox.Log( "[" .. data.name .. "] ProDemo.SendMessageToGameScript() message[" .. messageName .. "]" )

	-- Bodyを取得
	local gameScriptBody = ProDemo.GetGameScriptBody( data, body, gameScriptData )
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
-- 条件GameScriptの有効/無効を設定する
SetCheckerEnable = function( data, body, boolFlag )

	Fox.Log( "[" .. data.name .. "] ProDemo.SetCheckerEnable() [" .. tostring(boolFlag) .. "]" )

	local storage = body.storage

	-- 中断/再開条件GameScript
	for i = 1, storage.MAX_BREAK_CHECKER_COUNT do

		-- Dataを取得
		local keyName = "BREAK_CHECKER_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- GameScriptのenableフラグを設定する
		ProDemo.SetGameScriptEnable( body, gameScriptData, boolFlag )

	end

	-- 終了条件GameScript
	for i = 1, storage.MAX_STOP_CHECKER_COUNT do

		-- Dataを取得
		local keyName = "STOP_CHECKER_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- GameScriptのenableフラグを設定する
		ProDemo.SetGameScriptEnable( body, gameScriptData, boolFlag )

	end

end,

--------------------------------------------------------------------------------
-- GameScriptのenableフラグを設定する
SetGameScriptEnable = function( body, gameScriptData, boolFlag )

	--Fox.Log( "[" .. data.name .. "] ProDemo.SetGameScriptEnable() [" .. tostring(boolFlag) .. "]" )

	-- Bodyを取得
	local gameScriptBody = ProDemo.GetGameScriptBody( data, body, gameScriptData )
	if gameScriptBody == NULL then
		Fox.Warning( "[" .. data.name .. "] gameScriptData[" .. tostring(gameScriptData) .. "] is error." )
		return
	end

	gameScriptBody.enable = boolFlag

end,

--------------------------------------------------------------------------------
-- プロシージャルデモに含まれる全てのDemoDataの再生を終了する
StopAllDemoData = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemo.StopAllDemoData()" )

	local storage = body.storage

	-- シーケンスGameScript
	for i = 1, storage.MAX_SEQUENCE_COUNT do

		-- Dataを取得
		local keyName = "SEQUENCE_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- シーケンスに含まれる全てのDemoDataの再生を終了
		ProDemo.StopAllDemoDataInSequence( data, body, gameScriptData )
	end

end,

--------------------------------------------------------------------------------
-- シーケンスGameScriptに含まれる全てのDemoDataの再生を終了
StopAllDemoDataInSequence = function( data, body, gameScriptData )

	Fox.Log( "[" .. data.name .. "] ProDemo.StopAllDemoDataInSequence() sequence[" .. gameScriptData.name .. "]" )

	-- Bodyを取得
	local gameScriptBody = ProDemo.GetGameScriptBody( data, body, gameScriptData )
	if gameScriptBody == NULL then
		Fox.Warning( "[" .. data.name .. "] gameScriptData[" .. tostring(gameScriptData) .. "] is error." )
		return
	end

	-- DemoData
	for i = 1, gameScriptBody.storage.MAX_DEMO_COUNT do

		-- Dataを取得
		local keyName = "DEMO" .. i
		local demoData = gameScriptData.variables[ keyName ]
		if demoData == NULL then
			Fox.Log( "[" .. data.name .. "]  DEMO count[" .. i-1 .. "]" )
			break	-- 末端まで取得し切ったら終了
		end

		-- 終了
		ProDemo.StopDemoData( data, body, demoData )
	end

end,

--------------------------------------------------------------------------------
-- DemoDataの再生を終了する
StopDemoData = function( data, body, demoData )

	Fox.Log( "[" .. data.name .. "] ProDemo.StopDemoData()" )

	-- Bodyを取得
	local demoBody = ProDemo.GetDemoBody( data, body, demoData )
	if demoBody == NULL then
		Fox.Warning( "[" .. data.name .. "] demoData[" .. tostring(demoData) .. "] is error." )
		return
	end

	Fox.Log( "[" .. data.name .. "]  Stop DemoData[" .. demoData.name .. "]" )
	demoBody:Stop()

end,

--------------------------------------------------------------------------------
-- DemoDataのDataからBodyを取得する
-- 	@return DemoDataBody:存在する NULL:存在しない
GetDemoBody = function( data, body, demoData )

	if demoData == NULL then
		Fox.Warning( "[" .. data.name .. "] demoData is NULL." )
		return
	end

	local demoBody = demoData:GetDataBodyWithReferrer( body )

	if demoBody == NULL then
		Fox.Warning( "[" .. data.name .. "] demoBody is NULL." )
		return NULL
	end

	if not demoBody:IsKindOf( DemoDataBody ) then
		Fox.Warning( "[" .. data.name .. "] DemoDataBody is not found. data[" .. tostring(demoData) .. "]" )
		return NULL
	end

	return demoBody

end,

--------------------------------------------------------------------------------
-- デバッグ
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- デバッグ用：全情報をログに出力
OnDebugDumpAll = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemo.OnDebugDumpAll()" )

	local storage = body.storage
	local fromMessageBox = body.messageBoxes.DEMO_DAEMON

	-- 全体管理
	ProDemo.DebugDump( data, body )

	-- 中断/再開条件GameScript
	for i = 1, storage.MAX_BREAK_CHECKER_COUNT do
		-- Dataを取得
		local keyName = "BREAK_CHECKER_GAMESCRIPT" .. i
		local gameScriptData = data.variables[ keyName ]
		if gameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- メッセージを投げる
		ProDemo.SendMessageToGameScript( data, body, gameScriptData, "DebugDump" )
	end

end,

--------------------------------------------------------------------------------
-- デバッグ用：情報をログに出力
DebugDump = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemo.DebugDump()" )

	local storage = body.storage

	Fox.Log( "[" .. data.name .. "]  status[" .. storage.status .. "]" )

--	Fox.Log( " messageBoxes.DEMO_DAEMON[" .. tostring(body.messageBoxes.DEMO_DAEMON) .. "]" )
--	local fromMessageBox = body.messageBoxes.DEMO_DAEMON

	-- シーケンスGameScript
	for i = 1, storage.MAX_SEQUENCE_COUNT do
		-- Dataを取得
		local keyName = "SEQUENCE_GAMESCRIPT" .. i
		local sequenceGameScriptData = data.variables[ keyName ]
		if sequenceGameScriptData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- Bodyを取得
		local sequenceGameScriptBody = ProDemo.GetGameScriptBody( data, body, sequenceGameScriptData )

		-- フラグを取得
		local isPlayEnd = false
		if sequenceGameScriptBody ~= NULL then
			isPlayEnd = sequenceGameScriptBody.storage.isPlayEnd
		end

		-- 出力
		Fox.Log( "[" .. data.name .. "]  " .. keyName .. " : isPlayEnd[" .. tostring(isPlayEnd) .. "] data[" .. tostring(sequenceGameScriptData) .. "] body[" .. tostring(sequenceGameScriptBody) .. "]" )
	end

end,

}

