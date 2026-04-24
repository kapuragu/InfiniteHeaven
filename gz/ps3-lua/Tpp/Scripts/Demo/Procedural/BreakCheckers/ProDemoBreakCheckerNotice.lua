--[[
	@id			ProDemoBreakCheckerNotice
	@category	demo
	GameScript用

	中断/再開条件GameScript
		・プロシージャルデモの中断条件をチェックし、満たされたら「中断メッセージ」を投げます
		・メッセージは「全体管理GameScript」が受け取り、全てのDemoDataの再生を終了させ、状態を「Break」に変更します。

		・プロシージャルデモの再開条件をチェックし、満たされたら「再開メッセージ」を投げます
		・メッセージは「全体管理GameScript」が受け取り、現在のシーケンスの頭から再生を開始し、状態を「Play」に変更します。

	中断条件：
		・指定のキャラクタがNoticeを発動したら中断

	再開条件：
		・指定のキャラクタ全員が巡回ルート行動に戻ったら再開

	■variables
		CHARACTER1		:	参加キャラクタ（のLocator）
		CHARACTER2
		CHARACTER3
			:
		CHARACTER16

		CHARA_DEMO1		:	参加キャラクタの待機用DemoData
		CHARA_DEMO2
		CHARA_DEMO3
			:
		CHARA_DEMO16

--]]
ProDemoBreakCheckerNotice = {

--------------------------------------------------------------------------------
-- 初期設定
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- イベントリスナーの登録
events = {
	DEMO_DAEMON = { SetDefaultValue = "OnSetDefaultValue", DebugDump = "OnDebugDump" },

	CHARACTER1  = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER2  = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER3  = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER4  = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER5  = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER6  = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER7  = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER8  = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER9  = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER10 = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER11 = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER12 = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER13 = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER14 = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER15 = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
	CHARACTER16 = { StartNotice = "OnStartNotice", StartPatrolRoute = "OnStartPatrolRoute" },
},

--------------------------------------------------------------------------------
-- 初期化
Init = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoBreakCheckerNotice.Init()" )

	local storage = body.storage

	---------------------------------------------------
	-- 定数

	-- 参加キャラクタの最大数
	storage:AddProperty( "int32", "MAX_CHARACTER_COUNT" )
	storage.MAX_CHARACTER_COUNT = 16

	---------------------------------------------------
	-- 変数

	-- このGameScriptの中断フラグ
	storage:AddProperty( "bool", "breakFlag" )

	-- キャラクタ毎の中断フラグ
	storage:AddProperty( "bool", "characterBreakFlags", storage.MAX_CHARACTER_COUNT )

	-- 初期値を設定
	ProDemoBreakCheckerNotice.SetDefaultValue( data, body )

	ProDemoBreakCheckerNotice.DebugDump( data, body )

end,

--------------------------------------------------------------------------------
-- メッセージボックスリストの設定
SetMessageBoxes = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoBreakCheckerNotice.SetMessageBoxes()" )

	-- 外部からの命令用にDemoDaemonのメッセージボックスを追加
	local fromMessageBox = ProDemoBreakCheckerNotice.GetDemoDaemonMessageBox()
	body:AddMessageBox( "DEMO_DAEMON", fromMessageBox )

end,

--------------------------------------------------------------------------------
-- イベントリスナー
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 初期値を設定
OnSetDefaultValue = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemoBreakCheckerNotice.OnSetDefaultValue()" )

	ProDemoBreakCheckerNotice.SetDefaultValue( data, body )

end,

--------------------------------------------------------------------------------
-- 参加キャラクタの誰かがNoticeを発動した時の処理
OnStartNotice = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemoBreakCheckerNotice.OnStartNotice()" )

	local storage = body.storage

	-- そのキャラクタの中断フラグを立てる
	ProDemoBreakCheckerNotice.SetCharacterBreakFlag( data, body, sender.owner, true )

	-- 中断条件をチェック
	if not ProDemoBreakCheckerNotice.BreakCheck( data, body ) then
		Fox.Log( "[" .. data.name .. "]  cannot break it." )
		return
	end

	-- プロシージャルデモの中断を要求
	Fox.Log( "[" .. data.name .. "]  Send Break message." )
	body.messageBox:SendMessageToSubscribers( "Break" )

	-- @todo 中断フラグの立っていないキャラクタに待機デモを流し込む

	-- 中断済みフラグを立てる
	storage.breakFlag = true

end,

--------------------------------------------------------------------------------
-- 参加キャラクタの誰かが巡回行動を開始した時の処理
OnStartPatrolRoute = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemoBreakCheckerNotice.OnStartPatrolRoute()" )

	local storage = body.storage

	-- そのキャラクタの中断フラグを下ろす
	ProDemoBreakCheckerNotice.SetCharacterBreakFlag( data, body, sender.owner, false )

	-- 再開条件をチェック
	if not ProDemoBreakCheckerNotice.ContinueCheck( data, body ) then
		Fox.Log( "[" .. data.name .. "]  continue failed." )
		return
	end

	-- プロシージャルデモの再開を要求
	Fox.Log( "[" .. data.name .. "] Send Continue message." )
	body.messageBox:SendMessageToSubscribers( "Continue" )

	-- 中断済みフラグを下ろす
	storage.breakFlag = false

end,

--------------------------------------------------------------------------------
-- private
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 初期値を設定
SetDefaultValue = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoBreakCheckerNotice.SetDefaultValue()" )

	local storage = body.storage

	storage.breakFlag = false

	for i = 1, storage.MAX_CHARACTER_COUNT do
		storage.characterBreakFlags[i] = false
	end

end,

--------------------------------------------------------------------------------
-- 中断条件をチェック
--	@return true:可 false:不可
BreakCheck = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoBreakCheckerNotice.BreakCheck()" )

	local storage = body.storage

	-- 中断済みなら不可
	if storage.breakFlag then
		return false
	end

	return true

end,

--------------------------------------------------------------------------------
-- 再開条件をチェック
--	@return true:可 false:不可
ContinueCheck = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoBreakCheckerNotice.ContinueCheck()" )

	local storage = body.storage

	-- 中断されていないなら不可
	if not storage.breakFlag then
		return false
	end

	-- キャラクタの誰も中断していないなら再開
	for i = 1, storage.MAX_CHARACTER_COUNT do

		local characterLocatorData = data.variables["CHARACTER" .. i]
		if characterLocatorData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- 再開不可
		if storage.characterBreakFlags[i] then
			return false
		end
	end

	-- 再開可能
	return true
end,

--------------------------------------------------------------------------------
-- 指定のキャラクタの中断フラグを設定する
SetCharacterBreakFlag = function( data, body, senderCharacterLocatorBody, boolFlag )

	local storage = body.storage

	for i = 1, storage.MAX_CHARACTER_COUNT do

		local characterLocatorData = data.variables["CHARACTER" .. i]
		if characterLocatorData == NULL then
			break	-- 末端まで取得し切ったら終了
		end

		-- 指定と一致するかチェック
		if ProDemoBreakCheckerNotice.IsMatchCharacter( data, body, characterLocatorData, senderCharacterLocatorBody ) then
			storage.characterBreakFlags[i] = boolFlag
		end
	end

	ProDemoBreakCheckerNotice.DebugDump( data, body )

end,

--------------------------------------------------------------------------------
-- 2体のキャラクタが一致するかチェック
--	@return true:一致	false:不一致
IsMatchCharacter = function( data, body, characterLocatorDataA, characterLocatorBodyB )

	-- Bodyを取得
	local characterLocatorBodyA = characterLocatorDataA:GetDataBodyWithReferrer( body )
	if characterLocatorBodyA == NULL or not characterLocatorBodyA:IsKindOf( ChCharacterLocator ) then
		Fox.Warning( "body not found. data[" .. tostring(characterLocatorDataA) .. "]" )
		return false
	end

	-- Bodyを比較
	if characterLocatorBodyA ~= characterLocatorBodyB then
		return false
	end

	return true
end,

--------------------------------------------------------------------------------
-- DemoDaemonのメッセージボックスを取得する
GetDemoDaemonMessageBox = function()

	local fromMessageBox = DemoDaemon.GetInstance().messageBox
	if fromMessageBox == NULL then
		Fox.Warning( "ProDemo.SetMessageBoxes() : DemoDaemon messageBox is NULL." )
		return NULL
	end
	if not fromMessageBox:IsKindOf( MessageBox ) then
		Fox.Warning( "ProDemo.SetMessageBoxes() : DemoDeamon messageBox is not MessageBox. [" .. tostring(fromMessageBox) .. "]" )
		return NULL
	end

	return fromMessageBox

end,

--------------------------------------------------------------------------------
-- デバッグ
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- デバッグ用：情報をログに出力
OnDebugDump = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemoBreakCheckerNotice.OnDebugDump()" )

	ProDemoBreakCheckerNotice.DebugDump( data, body )

end,

--------------------------------------------------------------------------------
-- デバッグ用：情報をログに出力
DebugDump = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoBreakCheckerNotice.DebugDump()" )

	local storage = body.storage

	-- 中断済みフラグ
	Fox.Log( "[" .. data.name .. "]  breakFlag[" .. tostring(storage.breakFlag) .. "]" )

	for i = 1, storage.MAX_CHARACTER_COUNT do
		local keyName = "CHARACTER" .. i
		local characterLocatorData = data.variables[ keyName ]
		if characterLocatorData == NULL then
			break
		end

		local characterLocatorBody = characterLocatorData:GetDataBodyWithReferrer( body )

		local breakFlag = storage.characterBreakFlags[i]
		Fox.Log( "[" .. data.name .. "]  " .. keyName .. " : breakFlag[" .. tostring(breakFlag) .. "] data[" .. tostring(characterLocatorData) .. "] body[" .. tostring(characterLocatorBody) .. "]" )
	end

end,

}

