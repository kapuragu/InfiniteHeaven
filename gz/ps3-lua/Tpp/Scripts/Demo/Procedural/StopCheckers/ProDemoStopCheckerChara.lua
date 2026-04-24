--[[
	@id			ProDemoStopCheckerChara
	@category	demo
	GameScript用

	終了条件GameScript
		・終了条件をチェックし、満たされたら「終了メッセージ」を投げます。
		・メッセージは「全体管理GameScript」が受け取り、全てのDemoDataの再生を終了させ、状態を「Stop」に変更します。
		・その後、「終了リアクションGameScript」を実行します。

	終了条件：
		・参加しているキャラクタが１人でも死亡・睡眠・気絶・フルトン回収・瀕死のいずれかになったら。

	■variables
		CHARACTER1		:	参加キャラクタ（のLocator）
		CHARACTER2
		CHARACTER3
			:
		CHARACTER16

--]]
ProDemoStopCheckerChara = {

--------------------------------------------------------------------------------
-- 初期設定
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- イベントリスナーの登録
events = {
	CHARACTER1  = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER2  = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER3  = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER4  = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER5  = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER6  = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER7  = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER8  = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER9  = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER10 = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER11 = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER12 = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER13 = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER14 = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER15 = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
	CHARACTER16 = { EnemyDead = "OnStopRequest", EnemySleep = "OnStopRequest", EnemyFaint = "OnStopRequest", EnemyFulton = "OnStopRequest", EnemyDying = "OnStopRequest" },
},

--------------------------------------------------------------------------------
-- 初期化
Init = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoStopCheckerChara.Init()" )

	local storage = body.storage

	---------------------------------------------------
	-- 定数

	-- 参加キャラクタの最大数
	storage:AddProperty( "int32", "MAX_CHARACTER_COUNT" )
	storage.MAX_CHARACTER_COUNT = 16

	ProDemoStopCheckerChara.DebugDump( data, body )

end,

--------------------------------------------------------------------------------
-- イベントリスナー
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- プロシージャルデモの終了を要求
OnStopRequest = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemoStopCheckerChara.OnStopRequest()" )

	-- プロシージャルデモの終了を要求
	body.messageBox:SendMessageToSubscribers( "Stop" )

end,

--------------------------------------------------------------------------------
-- デバッグ
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- デバッグ用：状態を出力
DebugDump = function( data, body )

	Fox.Log( "[" .. data.name .. "] ProDemoStopCheckerChara.DebugDump()" )

	local storage = body.storage

	-- 参加キャラクタ
	for i = 1, storage.MAX_CHARACTER_COUNT do

		-- Dataを取得
		local keyName = "CHARACTER" .. i
		local characterLocatorData = data.variables[ keyName ]
		if characterLocatorData == NULL then
			break	-- 末尾まで取得し切ったら終了
		end

		-- Bodyを取得
		local characterLocatorBody = characterLocatorData:GetDataBodyWithReferrer( body )

		-- MessageBoxを取得
		local characterMessageBox = NULL
		if characterLocatorBody ~= NULL then
			characterMessageBox = characterLocatorBody.messageBox
		end

		Fox.Log( "[" .. data.name .. "]  " .. keyName .. " : data[" .. tostring(characterLocatorData) .. "] body[" .. tostring(characterLocatorBody) .. "] messageBox[" .. tostring(characterMessageBox) .. "]" )
	end

end,

}

