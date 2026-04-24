--[[
	@id			ProDemoNextRouteChange
	@category	demo
	GameScript用

	プロシージャルデモの再生完了時、終了時、中断時にキャラクタにルートを設定します。

	■プロパティ

		■variables
			PRO_DEMO_GAMESCRIPT1	:	プロシージャルデモ（のGameSctipt）
			PRO_DEMO_GAMESCRIPT2
			PRO_DEMO_GAMESCRIPT3
			PRO_DEMO_GAMESCRIPT4
			PRO_DEMO_GAMESCRIPT5
			PRO_DEMO_GAMESCRIPT6
			PRO_DEMO_GAMESCRIPT7
			PRO_DEMO_GAMESCRIPT8

		■character					:	対象のキャラクタ（のLocator）

		■playendPatrolRoute		:	再生完了時に設定する巡回ルート
		■playEndPatrolRoutePoint	:	再生完了時に設定する巡回ルートのインデックス
		■playEndCautionRoute		:	再生完了時に設定する警戒ルート
		■playEndCautionRoutePoint	:	再生完了時に設定する警戒ルートのインデックス

		■breakPatrolRoute			:	中断時に設定する巡回ルート
		■breakPatrolRoutePoint		:	中断時に設定する巡回ルートのインデックス
		■breakCautionRoute			:	中断時に設定する警戒ルート
		■breakCautionRoutePoint	:	中断時に設定する警戒ルートのインデックス

		■stopPatrolRoute			:	強制終了時に設定する巡回ルート
		■stopPatrolRoutePoint		:	強制終了時に設定する巡回ルートのインデックス
		■stopCautionRoute			:	強制終了時に設定する警戒ルート
		■stopCautionRoutePoint		:	強制終了時に設定する警戒ルートのインデックス


--]]
ProDemoNextRouteChange = {

--------------------------------------------------------------------------------
-- 初期設定
--------------------------------------------------------------------------------
-- イベントリスナーの登録
events = {
	PRO_DEMO_GAMESCRIPT1 = { PlayEnd = "OnProDemoPlayEnd", Break = "OnProDemoBreak", Stop = "OnProDemoStop" },
	PRO_DEMO_GAMESCRIPT2 = { PlayEnd = "OnProDemoPlayEnd", Break = "OnProDemoBreak", Stop = "OnProDemoStop" },
	PRO_DEMO_GAMESCRIPT3 = { PlayEnd = "OnProDemoPlayEnd", Break = "OnProDemoBreak", Stop = "OnProDemoStop" },
	PRO_DEMO_GAMESCRIPT4 = { PlayEnd = "OnProDemoPlayEnd", Break = "OnProDemoBreak", Stop = "OnProDemoStop" },
	PRO_DEMO_GAMESCRIPT5 = { PlayEnd = "OnProDemoPlayEnd", Break = "OnProDemoBreak", Stop = "OnProDemoStop" },
	PRO_DEMO_GAMESCRIPT6 = { PlayEnd = "OnProDemoPlayEnd", Break = "OnProDemoBreak", Stop = "OnProDemoStop" },
	PRO_DEMO_GAMESCRIPT7 = { PlayEnd = "OnProDemoPlayEnd", Break = "OnProDemoBreak", Stop = "OnProDemoStop" },
	PRO_DEMO_GAMESCRIPT8 = { PlayEnd = "OnProDemoPlayEnd", Break = "OnProDemoBreak", Stop = "OnProDemoStop" },
},

-- 動的プロパティの追加
AddDynamicPropertiesToData = function( data, body )

	Fox.Log( "ProDemoNextRouteChange.AddDynamicPropertiesToData()" )

	data:AddProperty( "EntityLink", "character" )			-- 対象のキャラクタ
	data.character = NULL

	data:AddProperty( "EntityLink", "playEndPatrolRoute" )	-- 再生完了時に設定する巡回ルート
	data.playEndPatrolRoute = NULL
	data:AddProperty( "int32", "playEndPatrolRoutePoint" )	-- 再生完了時に設定する巡回ルートのインデックス
	data.playEndPatrolRoutePoint = 0
	data:AddProperty( "EntityLink", "playEndCautionRoute" )	-- 再生完了時に設定する警戒ルート
	data.playEndCautionRoute = NULL
	data:AddProperty( "int32", "playEndCautionRoutePoint" )	-- 再生完了時に設定する警戒ルートのインデックス
	data.playEndCautionRoutePoint = 0

	data:AddProperty( "EntityLink", "breakPatrolRoute" )	-- 中断時に設定する巡回ルート
	data.breakPatrolRoute = NULL
	data:AddProperty( "int32", "breakPatrolRoutePoint" )	-- 中断時に設定する巡回ルートのインデックス
	data.breakPatrolRoutePoint = 0
	data:AddProperty( "EntityLink", "breakCautionRoute" )	-- 中断時に設定する警戒ルート
	data.breakCautionRoute = NULL
	data:AddProperty( "int32", "breakCautionRoutePoint" )	-- 中断時に設定する警戒ルートのインデックス
	data.breakCautionRoutePoint = 0

	data:AddProperty( "EntityLink", "stopPatrolRoute" )		-- 強制終了時に設定する巡回ルート
	data.stopPatrolRoute = NULL
	data:AddProperty( "int32", "stopPatrolRoutePoint" )		-- 強制終了時に設定する巡回ルートのインデックス
	data.stopPatrolRoutePoint = 0
	data:AddProperty( "EntityLink", "stopCautionRoute" )	-- 強制終了時に設定する警戒ルート
	data.stopCautionRoute = NULL
	data:AddProperty( "int32", "stopCautionRoutePoint" )	-- 強制終了時に設定する警戒ルートのインデックス
	data.stopCautionRoutePoint = 0

end,

--------------------------------------------------------------------------------
-- イベントリスナー
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- プロシージャルデモが再生完了した時の処理
OnProDemoPlayEnd = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemoNextRouteChange.OnProDemoPlayEnd() : sender[" .. sender.owner.data.name .. "]" )

	-- キャラクタにルートを設定する
	local characterLocatorData = data.character
	local patrolRouteData      = data.playEndPatrolRoute
	local patrolRoutePoint     = data.playEndPatrolRoutePoint
	local cautionRouteData     = data.playEndCautionRoute
	local cautionRoutePoint    = data.playEndCautionRoutePoint
	ProDemoNextRouteChange.CharacterRouteChange( data, body, characterLocatorData, patrolRouteData, patrolRoutePoint, cautionRouteData, cautionRoutePoint )

end,

--------------------------------------------------------------------------------
-- プロシージャルデモが中断した時の処理
OnProDemoBreak = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemoNextRouteChange.OnProDemoBreak() : sender[" .. sender.owner.data.name .. "]" )

	-- キャラクタにルートを設定する
	local characterLocatorData = data.character
	local patrolRouteData      = data.breakPatrolRoute
	local patrolRoutePoint     = data.breakPatrolRoutePoint
	local cautionRouteData     = data.breakCautionRoute
	local cautionRoutePoint    = data.breakCautionRoutePoint
	ProDemoNextRouteChange.CharacterRouteChange( data, body, characterLocatorData, patrolRouteData, patrolRoutePoint, cautionRouteData, cautionRoutePoint )

end,

--------------------------------------------------------------------------------
-- プロシージャルデモが強制終了した時の処理
OnProDemoStop = function( data, body, sender, id, arg1, arg2, arg3 )

	Fox.Log( "[" .. data.name .. "] ProDemoNextRouteChange.OnProDemoStop() sender[" .. sender.owner.data.name .. "]" )

	-- キャラクタにルートを設定する
	local characterLocatorData = data.character
	local patrolRouteData      = data.stopPatrolRoute
	local patrolRoutePoint     = data.stopPatrolRoutePoint
	local cautionRouteData     = data.stopCautionRoute
	local cautionRoutePoint    = data.stopCautionRoutePoint
	ProDemoNextRouteChange.CharacterRouteChange( data, body, characterLocatorData, patrolRouteData, patrolRoutePoint, cautionRouteData, cautionRoutePoint )

end,

--------------------------------------------------------------------------------
-- private
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- キャラクタにルートを設定する
CharacterRouteChange = function( data, body, characterLocatorData, patrolRouteData, patrolRoutePoint, cautionRouteData, cautionRoutePoint )

	if characterLocatorData == NULL then
		Fox.Warning( "[" .. data.name .. "] characterLocatorData is NULL." )
		return
	end

	-- キャラクタのBodyを取得
	local characterLocatorBody = characterLocatorData:GetDataBodyWithReferrer( body )
	if characterLocatorBody == NULL or not characterLocatorBody:IsKindOf( ChCharacterLocator ) then
		Fox.Warning( "[" .. data.name .. "] Body(ChCharacterLocator) not found. data[" .. tostring(characterLocatorData) .. "]" )
		return
	end

	if patrolRouteData == NULL and cautionRouteData == NULL then
		Fox.Log( "[" .. data.name .. "]  patrolRoute and cautionRoute is not found." )
		return
	end

	-- ルートチェンジ
	if patrolRouteData ~= NULL then
		Fox.Log( "[" .. data.name .. "]  Change Patrol Route. routeData[" .. patrolRouteData.name .. "] routePoint[" .. patrolRoutePoint .. "]" )
		TppEnemyMoveUtility.ChangeSneakRoute( characterLocatorBody, patrolRouteData, patrolRoutePoint )
	end
	if cautionRouteData ~= NULL then
		Fox.Log( "[" .. data.name .. "]  Change Caution Route. routeData[" .. cautionRouteData.name .. "] routePoint[" .. cautionRoutePoint .. "]" )
		TppEnemyMoveUtility.ChangeCautionRoute( characterLocatorBody, cautionRouteData, cautionRoutePoint )
	end

end,

}

