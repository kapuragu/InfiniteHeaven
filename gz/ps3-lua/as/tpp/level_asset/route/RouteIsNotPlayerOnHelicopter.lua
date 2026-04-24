--[[FDOC
	@id RouteIsPlayerOnHelicopter
	@category Ai RouteNodeEvent
	@brief プレイヤーが乗り込んでいないかの判定用ルートイベント条件スクリプト
]]--

RouteIsNotPlayerOnHelicopter = {

----------------------------------------
--開始条件判定 EnableCheck()
--　RouteNodeEventのアクション実行前に呼ばれます。
--　boolを返してください。
--		true:	アクションを開始します。
--		false:	アクションを開始せずに、次のアクションを実行します。
----------------------------------------
EnableCheck = function( chara )
	--プレイヤーがヘリに乗り込んでいなかったら
	local plgPassenger = chara:FindPlugin("TppPassengerManagePlugin")
	if not plgPassenger:IsExist("Player") then
		return true
	end
	
	return false
end,

----------------------------------------
--終了条件判定 EndCheck()
--　RouteNodeEventのアクション実行後に呼ばれます。
--　boolを返してください。
--		true:	アクションを終了します。
--		false:	アクションを終了せずに、もう一度同じアクションを繰り返し実行します。
----------------------------------------
EndCheck = function( chara )
	return true
end,

}
