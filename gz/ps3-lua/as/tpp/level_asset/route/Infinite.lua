--[[FDOC
	@id Infinite
	@category Ai RouteNodeEvent
	@brief 無限繰り返しルートイベント条件スクリプト
	 * 永続的にイベントを繰り返します。
]]--

Infinite = {

----------------------------------------
--開始条件判定 EnableCheck()
--　RouteNodeEventのアクション実行前に呼ばれます。
--　boolを返してください。
--		true:	アクションを開始します。
--		false:	アクションを開始せずに、次のアクションを実行します。
----------------------------------------
EnableCheck = function( chara )
	return true
end,

----------------------------------------
--終了条件判定 EndCheck()
--　RouteNodeEventのアクション実行後に呼ばれます。
--　boolを返してください。
--		true:	アクションを終了します。
--		false:	アクションを終了せずに、もう一度同じアクションを繰り返し実行します。
----------------------------------------
EndCheck = function( chara )
	return false
end,

}
